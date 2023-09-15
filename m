Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 955467A2A6B
	for <lists+kvm@lfdr.de>; Sat, 16 Sep 2023 00:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235323AbjIOWYu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 18:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237838AbjIOWY2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 18:24:28 -0400
Received: from out-225.mta0.migadu.com (out-225.mta0.migadu.com [91.218.175.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFA1B2718
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 15:22:49 -0700 (PDT)
Date:   Fri, 15 Sep 2023 22:22:42 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1694816568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qzk1kWKQ5Jx8f4B0HOb4pSvibE/Fy1ssQI2BM7f0Yns=;
        b=ggGdDqrbvN9k7CtjcilAYWv5wrCp89MUGf1OzF2gAJbx3CswGYzxMPFAzN9/3b/XIorCmt
        iQ3uo4/LhlEAkzZsQjbMFpfPv6J+ppIZA2HYg03PbSwjI1aONLtMyUoxfssUbi1TySe444
        9V6e//bPtYa+wMXakQW7uEEKCbC0+P8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, maz@kernel.org,
        will@kernel.org, catalin.marinas@arm.com, james.morse@arm.com,
        suzuki.poulose@arm.com, yuzenghui@huawei.com,
        zhukeqian1@huawei.com, jonathan.cameron@huawei.com,
        linuxarm@huawei.com
Subject: Re: [RFC PATCH v2 3/8] KVM: arm64: Add some HW_DBM related pgtable
 interfaces
Message-ID: <ZQTZMl7RP8ZYQ6tr@linux.dev>
References: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
 <20230825093528.1637-4-shameerali.kolothum.thodi@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230825093528.1637-4-shameerali.kolothum.thodi@huawei.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Shameer,

On Fri, Aug 25, 2023 at 10:35:23AM +0100, Shameer Kolothum wrote:
> From: Keqian Zhu <zhukeqian1@huawei.com>
> 
> This adds set_dbm, clear_dbm and sync_dirty interfaces in pgtable
> layer. (1) set_dbm: Set DBM bit for last level PTE of a specified
> range. TLBI is completed. (2) clear_dbm: Clear DBM bit for last
> level PTE of a specified range. TLBI is not acted. (3) sync_dirty:
> Scan last level PTE of a specific range. Log dirty if PTE is writeable.
> 
> Besides, save the dirty state of PTE if it's invalided by map or
> unmap.
> 
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>  arch/arm64/include/asm/kvm_pgtable.h | 45 +++++++++++++
>  arch/arm64/kernel/image-vars.h       |  2 +
>  arch/arm64/kvm/hyp/pgtable.c         | 98 ++++++++++++++++++++++++++++
>  3 files changed, 145 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 3f96bdd2086f..a12add002b89 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -578,6 +578,51 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
>   */
>  int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size);
>  
> +/**
> + * kvm_pgtable_stage2_clear_dbm() - Clear DBM of guest stage-2 address range
> + *                                  without TLB invalidation (only last level).
> + * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
> + * @addr:	Intermediate physical address from which to clear DBM,
> + * @size:	Size of the range.
> + *
> + * The offset of @addr within a page is ignored and @size is rounded-up to
> + * the next page boundary.
> + *
> + * Note that it is the caller's responsibility to invalidate the TLB after
> + * calling this function to ensure that the disabled HW dirty are visible
> + * to the CPUs.
> + *
> + * Return: 0 on success, negative error code on failure.
> + */
> +int kvm_pgtable_stage2_clear_dbm(struct kvm_pgtable *pgt, u64 addr, u64 size);
> +
> +/**
> + * kvm_pgtable_stage2_set_dbm() - Set DBM of guest stage-2 address range to
> + *                                enable HW dirty (only last level).
> + * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
> + * @addr:	Intermediate physical address from which to set DBM.
> + * @size:	Size of the range.
> + *
> + * The offset of @addr within a page is ignored and @size is rounded-up to
> + * the next page boundary.
> + *
> + * Return: 0 on success, negative error code on failure.
> + */
> +int kvm_pgtable_stage2_set_dbm(struct kvm_pgtable *pgt, u64 addr, u64 size);
> +
> +/**
> + * kvm_pgtable_stage2_sync_dirty() - Sync HW dirty state into memslot.
> + * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
> + * @addr:	Intermediate physical address from which to sync.
> + * @size:	Size of the range.
> + *
> + * The offset of @addr within a page is ignored and @size is rounded-up to
> + * the next page boundary.
> + *
> + * Return: 0 on success, negative error code on failure.
> + */
> +int kvm_pgtable_stage2_sync_dirty(struct kvm_pgtable *pgt, u64 addr, u64 size);
> +
>  /**
>   * kvm_pgtable_stage2_wrprotect() - Write-protect guest stage-2 address range
>   *                                  without TLB invalidation.
> diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
> index 35f3c7959513..2ca600e3d637 100644
> --- a/arch/arm64/kernel/image-vars.h
> +++ b/arch/arm64/kernel/image-vars.h
> @@ -68,6 +68,8 @@ KVM_NVHE_ALIAS(__hyp_stub_vectors);
>  KVM_NVHE_ALIAS(vgic_v2_cpuif_trap);
>  KVM_NVHE_ALIAS(vgic_v3_cpuif_trap);
>  
> +KVM_NVHE_ALIAS(mark_page_dirty);
> +

This doesn't make any sense besides satisfying the linker. The hyp page
table walkers will *never* need to mark a page as dirty.

Consider adding a new function pointer to kvm_pgtable_mm_ops and only
set it for the 'normal' stage-2 mm ops in mmu.c.

> +static bool stage2_pte_writeable(kvm_pte_t pte)
> +{
> +	return pte & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> +}
> +
> +static void kvm_update_hw_dbm(const struct kvm_pgtable_visit_ctx *ctx,
> +			      kvm_pte_t new)
> +{
> +	kvm_pte_t old_pte, pte = ctx->old;
> +
> +	/* Only set DBM if page is writeable */
> +	if ((new & KVM_PTE_LEAF_ATTR_HI_S2_DBM) && !stage2_pte_writeable(pte))
> +		return;
> +
> +	/* Clear DBM walk is not shared, update */
> +	if (!kvm_pgtable_walk_shared(ctx)) {
> +		WRITE_ONCE(*ctx->ptep, new);
> +		return;
> +	}
> +
> +	do {
> +		old_pte = pte;
> +		pte = new;
> +
> +		if (old_pte == pte)
> +			break;
> +
> +		pte = cmpxchg_relaxed(ctx->ptep, old_pte, pte);
> +	} while (pte != old_pte);
> +}
> +

We don't need a separate walker for updating the DBM state in the
page tables. Can't we treat it like any other permission bit and use
something like kvm_pgtable_stage2_relax_perms()?

Also, what is the purpose of retrying the update on a descriptor if the
cmpxchg() fails? Everywhere else in the page table walker code we bail
and retry execution since that is a clear indication of a race. In all
likelihood the other vCPU thread was either trying to update DBM or
service a permission fault.

>  static bool stage2_try_set_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t new)
>  {
> +	if (kvm_pgtable_walk_hw_dbm(ctx)) {
> +		kvm_update_hw_dbm(ctx, new);
> +		return true;
> +	}
> +

Why are you trying to circumvent the primitive for setting stage-2 PTEs?

>  	if (!kvm_pgtable_walk_shared(ctx)) {
>  		WRITE_ONCE(*ctx->ptep, new);
>  		return true;
> @@ -952,6 +990,11 @@ static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
>  	    stage2_pte_executable(new))
>  		mm_ops->icache_inval_pou(kvm_pte_follow(new, mm_ops), granule);
>  
> +	/* Save the possible hardware dirty info */
> +	if ((ctx->level == KVM_PGTABLE_MAX_LEVELS - 1) &&
> +	    stage2_pte_writeable(ctx->old))
> +		mark_page_dirty(kvm_s2_mmu_to_kvm(pgt->mmu), ctx->addr >> PAGE_SHIFT);
> +
>  	stage2_make_pte(ctx, new);
>  
>  	return 0;
> @@ -1125,6 +1168,11 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
>  	 */
>  	stage2_unmap_put_pte(ctx, mmu, mm_ops);
>  
> +	/* Save the possible hardware dirty info */
> +	if ((ctx->level == KVM_PGTABLE_MAX_LEVELS - 1) &&
> +	    stage2_pte_writeable(ctx->old))
> +		mark_page_dirty(kvm_s2_mmu_to_kvm(mmu), ctx->addr >> PAGE_SHIFT);
> +
>  	if (need_flush && mm_ops->dcache_clean_inval_poc)
>  		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(ctx->old, mm_ops),
>  					       kvm_granule_size(ctx->level));
> @@ -1230,6 +1278,30 @@ static int stage2_update_leaf_attrs(struct kvm_pgtable *pgt, u64 addr,
>  	return 0;
>  }
>  
> +int kvm_pgtable_stage2_set_dbm(struct kvm_pgtable *pgt, u64 addr, u64 size)
> +{
> +	int ret;
> +	u64 offset;
> +
> +	ret = stage2_update_leaf_attrs(pgt, addr, size, KVM_PTE_LEAF_ATTR_HI_S2_DBM, 0,
> +				       NULL, NULL, KVM_PGTABLE_WALK_HW_DBM |
> +				       KVM_PGTABLE_WALK_SHARED);
> +	if (!ret)
> +		return ret;
> +
> +	for (offset = 0; offset < size; offset += PAGE_SIZE)
> +		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa_nsh, pgt->mmu, addr + offset, 3);
> +
> +	return 0;
> +}
> +
> +int kvm_pgtable_stage2_clear_dbm(struct kvm_pgtable *pgt, u64 addr, u64 size)
> +{
> +	return stage2_update_leaf_attrs(pgt, addr, size,
> +					0, KVM_PTE_LEAF_ATTR_HI_S2_DBM,
> +					NULL, NULL, KVM_PGTABLE_WALK_HW_DBM);
> +}
> +
>  int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
>  {
>  	return stage2_update_leaf_attrs(pgt, addr, size, 0,
> @@ -1329,6 +1401,32 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
>  	return ret;
>  }
>  
> +static int stage2_sync_dirty_walker(const struct kvm_pgtable_visit_ctx *ctx,
> +				    enum kvm_pgtable_walk_flags visit)
> +{
> +	kvm_pte_t pte = READ_ONCE(*ctx->ptep);

ctx->old is fetched in __kvm_pgtable_visit(), and the whole
parallelization scheme for page table walkers depends on us being
careful to read the PTE once per level. Do you need to reread it here?

-- 
Thanks,
Oliver
