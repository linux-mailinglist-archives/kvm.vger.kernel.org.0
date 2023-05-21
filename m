Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 407F570AFEE
	for <lists+kvm@lfdr.de>; Sun, 21 May 2023 21:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbjEUTdF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 May 2023 15:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjEUTdD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 May 2023 15:33:03 -0400
Received: from out-40.mta1.migadu.com (out-40.mta1.migadu.com [95.215.58.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0CB5CF
        for <kvm@vger.kernel.org>; Sun, 21 May 2023 12:33:01 -0700 (PDT)
Date:   Sun, 21 May 2023 19:32:55 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1684697580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Akzv5NktCvKGPt0vU42haRZ9ILj4vsVHEjDPh0FBt5c=;
        b=hL8GqOAV5h82tlgHzhue02i1byAYrjXvnwi5Ela8TBVeuXBMB0Za94zqr7INqehcHRIL/A
        jITLf8LDah5KC3AJdzTCa0LHbRSoVjL1Acgd+4ZWUV7HbZTwr/Ij/+bsdb8iOUWjHRoDmb
        HyTrLoAajcfC5oH0wKrD5HhkmkoUGSQ=
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
Subject: Re: [PATCH v4 6/6] KVM: arm64: Use TLBI range-based intructions for
 unmap
Message-ID: <ZGpx58R6Lp1qpTkA@linux.dev>
References: <20230519005231.3027912-1-rananta@google.com>
 <20230519005231.3027912-7-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230519005231.3027912-7-rananta@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 19, 2023 at 12:52:31AM +0000, Raghavendra Rao Ananta wrote:
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

nit: Rather than discussing a theoretical CMO walker, I think this is
more readable if you mention the existing behavior of the walker.

  Condition deferred TLB invalidation on the system supporting FWB, as
  the optimization is entirely pointless when the unmap walker needs to
  perform CMOs.

> Rename stage2_put_pte() to stage2_unmap_put_pte() as the function
> now serves the stage-2 unmap walker specifically, rather than
> acting generic.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 35 ++++++++++++++++++++++++++++++-----
>  1 file changed, 30 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index b8f0dbd12f773..5832ee3418fb0 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -771,16 +771,34 @@ static void stage2_make_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t n
>  	smp_store_release(ctx->ptep, new);
>  }
>  
> -static void stage2_put_pte(const struct kvm_pgtable_visit_ctx *ctx, struct kvm_s2_mmu *mmu,
> -			   struct kvm_pgtable_mm_ops *mm_ops)
> +static bool stage2_unmap_defer_tlb_flush(struct kvm_pgtable *pgt)
>  {
> +	/*
> +	 * If FEAT_TLBIRANGE is implemented, defer the individial PTE

typo: individual

Also, 'PTE' isn't significant here.

> +	 * TLB invalidations until the entire walk is finished, and
> +	 * then use the range-based TLBI instructions to do the
> +	 * invalidations. Condition this upon S2FWB in order to avoid
> +	 * a page-table walk again to perform the CMOs after TLBI.
> +	 */

Apply the wording suggestion from the changelog here as well.

> +	return system_supports_tlb_range() && stage2_has_fwb(pgt);
> +}
> +
> +static void stage2_unmap_put_pte(const struct kvm_pgtable_visit_ctx *ctx,
> +				struct kvm_s2_mmu *mmu,
> +				struct kvm_pgtable_mm_ops *mm_ops)
> +{
> +	struct kvm_pgtable *pgt = ctx->arg;
> +
>  	/*
>  	 * Clear the existing PTE, and perform break-before-make with
>  	 * TLB maintenance if it was valid.
>  	 */
>  	if (kvm_pte_valid(ctx->old)) {
>  		kvm_clear_pte(ctx->ptep);
> -		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr, ctx->level);
> +
> +		if (!stage2_unmap_defer_tlb_flush(pgt))
> +			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu,
> +					ctx->addr, ctx->level);
>  	}
>  
>  	mm_ops->put_page(ctx->ptep);
> @@ -1015,7 +1033,7 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
>  	 * block entry and rely on the remaining portions being faulted
>  	 * back lazily.
>  	 */
> -	stage2_put_pte(ctx, mmu, mm_ops);
> +	stage2_unmap_put_pte(ctx, mmu, mm_ops);
>  
>  	if (need_flush && mm_ops->dcache_clean_inval_poc)
>  		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(ctx->old, mm_ops),
> @@ -1029,13 +1047,20 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
>  
>  int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
>  {
> +	int ret;
>  	struct kvm_pgtable_walker walker = {
>  		.cb	= stage2_unmap_walker,
>  		.arg	= pgt,
>  		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
>  	};
>  
> -	return kvm_pgtable_walk(pgt, addr, size, &walker);
> +	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
> +	if (stage2_unmap_defer_tlb_flush(pgt))
> +		/* Perform the deferred TLB invalidations */
> +		kvm_call_hyp(__kvm_tlb_flush_vmid_range, pgt->mmu,
> +				addr, addr + size);
> +
> +	return ret;
>  }
>  
>  struct stage2_attr_data {
> -- 
> 2.40.1.698.g37aff9b760-goog
> 

-- 
Thanks,
Oliver
