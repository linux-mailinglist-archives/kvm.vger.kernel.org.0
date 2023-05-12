Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35331700D90
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 19:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237750AbjELRCs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 13:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237740AbjELRCr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 13:02:47 -0400
Received: from out-53.mta0.migadu.com (out-53.mta0.migadu.com [91.218.175.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6DE5E3
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 10:02:45 -0700 (PDT)
Date:   Fri, 12 May 2023 17:02:38 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1683910963;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sODTyDv5L5PcXKxq0ByU2ty1JyyzAf4TEsGxAx4S/Kk=;
        b=wLQHdgkjIl3VGsRv1Hh6QjgfeOSxabsRa36OxyVZst7jQZNdxWCojHsM6ILzlp0BgNiTld
        vq0YTbY3+uPgZ18oxcEsbxXqyjoqNsW8fv7mYQ7sekHxJvZOA7r9DbhV5Nxo35rnAGH77i
        qZvp+8t6N7mE0AgDSfEQ1E3V/QbxSZ8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Ricardo Koller <ricarkol@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 7/7] KVM: arm64: Use TLBI range-based intructions for
 unmap
Message-ID: <ZF5xLrr2tEYdLL1i@linux.dev>
References: <20230414172922.812640-1-rananta@google.com>
 <20230414172922.812640-8-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230414172922.812640-8-rananta@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Raghavendra,

On Fri, Apr 14, 2023 at 05:29:22PM +0000, Raghavendra Rao Ananta wrote:
> The current implementation of the stage-2 unmap walker traverses
> the given range and, as a part of break-before-make, performs
> TLB invalidations with a DSB for every PTE. A multitude of this
> combination could cause a performance bottleneck.
> 
> Hence, if the system supports FEAT_TLBIRANGE, defer the TLB
> invalidations until the entire walk is finished, and then
> use range-based instructions to invalidate the TLBs in one go.
> Condition this upon S2FWB in order to avoid walking the page-table
> again to perform the CMOs after issuing the TLBI.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> Suggested-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 33 +++++++++++++++++++++++++++++----
>  1 file changed, 29 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 3f136e35feb5e..bcb748e3566c7 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -987,10 +987,16 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
>  	return ret;
>  }
>  
> +struct stage2_unmap_data {
> +	struct kvm_pgtable *pgt;
> +	bool skip_pte_tlbis;
> +};
> +
>  static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
>  			       enum kvm_pgtable_walk_flags visit)
>  {
> -	struct kvm_pgtable *pgt = ctx->arg;
> +	struct stage2_unmap_data *unmap_data = ctx->arg;
> +	struct kvm_pgtable *pgt = unmap_data->pgt;
>  	struct kvm_s2_mmu *mmu = pgt->mmu;
>  	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
>  	kvm_pte_t *childp = NULL;
> @@ -1018,7 +1024,7 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
>  	 * block entry and rely on the remaining portions being faulted
>  	 * back lazily.
>  	 */
> -	stage2_put_pte(ctx, mmu, mm_ops, false);
> +	stage2_put_pte(ctx, mmu, mm_ops, unmap_data->skip_pte_tlbis);
>  
>  	if (need_flush && mm_ops->dcache_clean_inval_poc)
>  		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(ctx->old, mm_ops),
> @@ -1032,13 +1038,32 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
>  
>  int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
>  {
> +	int ret;
> +	struct stage2_unmap_data unmap_data = {
> +		.pgt = pgt,
> +		/*
> +		 * If FEAT_TLBIRANGE is implemented, defer the individial PTE
> +		 * TLB invalidations until the entire walk is finished, and
> +		 * then use the range-based TLBI instructions to do the
> +		 * invalidations. Condition this upon S2FWB in order to avoid
> +		 * a page-table walk again to perform the CMOs after TLBI.
> +		 */
> +		.skip_pte_tlbis = system_supports_tlb_range() &&
> +					stage2_has_fwb(pgt),

Why can't the underlying walker just call these two helpers directly?
There are static keys behind these...

> +	};
>  	struct kvm_pgtable_walker walker = {
>  		.cb	= stage2_unmap_walker,
> -		.arg	= pgt,
> +		.arg	= &unmap_data,
>  		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
>  	};
>  
> -	return kvm_pgtable_walk(pgt, addr, size, &walker);
> +	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
> +	if (unmap_data.skip_pte_tlbis)
> +		/* Perform the deferred TLB invalidations */
> +		kvm_call_hyp(__kvm_tlb_flush_vmid_range, pgt->mmu,
> +				addr, addr + size);
> +
> +	return ret;
>  }
>  
>  struct stage2_attr_data {
> -- 
> 2.40.0.634.g4ca3ef3211-goog
> 

-- 
Thanks,
Oliver
