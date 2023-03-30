Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5562A6CF823
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 02:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbjC3ARm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 20:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjC3ARl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 20:17:41 -0400
Received: from out-13.mta1.migadu.com (out-13.mta1.migadu.com [IPv6:2001:41d0:203:375::d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 434721706
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 17:17:40 -0700 (PDT)
Date:   Thu, 30 Mar 2023 00:17:25 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1680135457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dZ7CgR7LTAUcUKEiGOSUlgNQXWvEplmklKUnppCogvc=;
        b=hRX9HcY4lHKvklyIm9h5vMkVivWZXvGwyJDd5XCTzM29yNzKcO7TXlGwIu+7wmffVDeVof
        XgLEjtUm074mMAdnfFC0AGMUVl2/hrS6DpBuI9GVy6scElft++20vrOGXsNmvbt2Zh3bAr
        8VYBc2aq4fHO3hc8+86ULT8PRGPctfE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 6/7] KVM: arm64: Break the table entries using TLBI
 range instructions
Message-ID: <ZCTVFYd2oJnGR6O+@linux.dev>
References: <20230206172340.2639971-1-rananta@google.com>
 <20230206172340.2639971-7-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206172340.2639971-7-rananta@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

nit: s/break/invalidate/g

There is a rather important degree of nuance there. 'Break' as it
relates to break-before-make implies that the PTE is made invalid and
visible to hardware _before_ a subsequent invalidation. There will be
systems that relax this requirement and also support TLBIRANGE.

On Mon, Feb 06, 2023 at 05:23:39PM +0000, Raghavendra Rao Ananta wrote:

Some nitpicking on the changelog:

> Currently, when breaking up the stage-2 table entries, KVM

'breaking up stage-2 table entries' is rather ambiguous. Instead
describe the operation taking place on the page tables (i.e. hugepage
collapse).

> would flush the entire VM's context using 'vmalls12e1is'
> TLBI operation. One of the problematic situation is collapsing
> table entries into a hugepage, specifically if the VM is
> faulting on many hugepages (say after dirty-logging). This
> creates a performance penality for the guest whose pages have

typo: penalty

> already been faulted earlier as they would have to refill their
> TLBs again.
> 
> Hence, if the system supports it, use __kvm_tlb_flush_range_vmid_ipa()

> to flush only the range of pages governed by the table entry,
> while leaving other TLB entries alone. An upcoming patch also
> takes advantage of this when breaking up table entries during
> the unmap operation.

Language regarding an upcoming patch isn't necessary, as this one stands
on its own (implements and uses a range-based invalidation helper).

> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  arch/arm64/kvm/hyp/pgtable.c | 23 ++++++++++++++++++++---
>  1 file changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index b11cf2c618a6c..0858d1fa85d6b 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -686,6 +686,20 @@ static bool stage2_try_set_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_
>  	return cmpxchg(ctx->ptep, ctx->old, new) == ctx->old;
>  }
>  
> +static void kvm_pgtable_stage2_flush_range(struct kvm_s2_mmu *mmu, u64 start, u64 end,
> +						u32 level, u32 tlb_level)
> +{
> +	if (system_supports_tlb_range())

You also check this in __kvm_tlb_flush_range(), ideally this should be
done exactly once per call.

> +		kvm_call_hyp(__kvm_tlb_flush_range_vmid_ipa, mmu, start, end, level, tlb_level);
> +	else
> +		/*
> +		 * Invalidate the whole stage-2, as we may have numerous leaf
> +		 * entries below us which would otherwise need invalidating
> +		 * individually.
> +		 */
> +		kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
> +}
> +
>  /**
>   * stage2_try_break_pte() - Invalidates a pte according to the
>   *			    'break-before-make' requirements of the
> @@ -721,10 +735,13 @@ static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
>  	 * Perform the appropriate TLB invalidation based on the evicted pte
>  	 * value (if any).
>  	 */
> -	if (kvm_pte_table(ctx->old, ctx->level))
> -		kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
> -	else if (kvm_pte_valid(ctx->old))
> +	if (kvm_pte_table(ctx->old, ctx->level)) {
> +		u64 end = ctx->addr + kvm_granule_size(ctx->level);
> +
> +		kvm_pgtable_stage2_flush_range(mmu, ctx->addr, end, ctx->level, 0);
> +	} else if (kvm_pte_valid(ctx->old)) {
>  		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr, ctx->level);
> +	}
>  
>  	if (stage2_pte_is_counted(ctx->old))
>  		mm_ops->put_page(ctx->ptep);
> -- 
> 2.39.1.519.gcb327c4b5f-goog
> 
> 

-- 
Thanks,
Oliver
