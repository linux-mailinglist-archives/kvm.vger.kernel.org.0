Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 655E37A4670
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 11:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240942AbjIRJy2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 18 Sep 2023 05:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241120AbjIRJyI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 05:54:08 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF0ED116
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 02:54:01 -0700 (PDT)
Received: from lhrpeml100002.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Rq0Sg3TmWz6HJk0;
        Mon, 18 Sep 2023 17:52:03 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 lhrpeml100002.china.huawei.com (7.191.160.241) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Mon, 18 Sep 2023 10:53:59 +0100
Received: from lhrpeml500005.china.huawei.com ([7.191.163.240]) by
 lhrpeml500005.china.huawei.com ([7.191.163.240]) with mapi id 15.01.2507.031;
 Mon, 18 Sep 2023 10:53:59 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Oliver Upton <oliver.upton@linux.dev>
CC:     "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "will@kernel.org" <will@kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
        yuzenghui <yuzenghui@huawei.com>,
        zhukeqian <zhukeqian1@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        Linuxarm <linuxarm@huawei.com>
Subject: RE: [RFC PATCH v2 3/8] KVM: arm64: Add some HW_DBM related pgtable
 interfaces
Thread-Topic: [RFC PATCH v2 3/8] KVM: arm64: Add some HW_DBM related pgtable
 interfaces
Thread-Index: AQHZ1zeo1TAqj48yIUy5dQTN13GTvLAchxYAgAPfXOA=
Date:   Mon, 18 Sep 2023 09:53:59 +0000
Message-ID: <47a49e5112b24f178c9b386f894b489c@huawei.com>
References: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
 <20230825093528.1637-4-shameerali.kolothum.thodi@huawei.com>
 <ZQTZMl7RP8ZYQ6tr@linux.dev>
In-Reply-To: <ZQTZMl7RP8ZYQ6tr@linux.dev>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.227.178]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Oliver Upton [mailto:oliver.upton@linux.dev]
> Sent: 15 September 2023 23:23
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: kvmarm@lists.linux.dev; kvm@vger.kernel.org;
> linux-arm-kernel@lists.infradead.org; maz@kernel.org; will@kernel.org;
> catalin.marinas@arm.com; james.morse@arm.com;
> suzuki.poulose@arm.com; yuzenghui <yuzenghui@huawei.com>; zhukeqian
> <zhukeqian1@huawei.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>; Linuxarm <linuxarm@huawei.com>
> Subject: Re: [RFC PATCH v2 3/8] KVM: arm64: Add some HW_DBM related
> pgtable interfaces
> 
> Hi Shameer,
> 
> On Fri, Aug 25, 2023 at 10:35:23AM +0100, Shameer Kolothum wrote:
> > From: Keqian Zhu <zhukeqian1@huawei.com>
> >
> > This adds set_dbm, clear_dbm and sync_dirty interfaces in pgtable
> > layer. (1) set_dbm: Set DBM bit for last level PTE of a specified
> > range. TLBI is completed. (2) clear_dbm: Clear DBM bit for last
> > level PTE of a specified range. TLBI is not acted. (3) sync_dirty:
> > Scan last level PTE of a specific range. Log dirty if PTE is writeable.
> >
> > Besides, save the dirty state of PTE if it's invalided by map or
> > unmap.
> >
> > Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> > Signed-off-by: Shameer Kolothum
> <shameerali.kolothum.thodi@huawei.com>
> > ---
> >  arch/arm64/include/asm/kvm_pgtable.h | 45 +++++++++++++
> >  arch/arm64/kernel/image-vars.h       |  2 +
> >  arch/arm64/kvm/hyp/pgtable.c         | 98
> ++++++++++++++++++++++++++++
> >  3 files changed, 145 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_pgtable.h
> b/arch/arm64/include/asm/kvm_pgtable.h
> > index 3f96bdd2086f..a12add002b89 100644
> > --- a/arch/arm64/include/asm/kvm_pgtable.h
> > +++ b/arch/arm64/include/asm/kvm_pgtable.h
> > @@ -578,6 +578,51 @@ int kvm_pgtable_stage2_set_owner(struct
> kvm_pgtable *pgt, u64 addr, u64 size,
> >   */
> >  int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64
> size);
> >
> > +/**
> > + * kvm_pgtable_stage2_clear_dbm() - Clear DBM of guest stage-2 address
> range
> > + *                                  without TLB invalidation (only
> last level).
> > + * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
> > + * @addr:	Intermediate physical address from which to clear DBM,
> > + * @size:	Size of the range.
> > + *
> > + * The offset of @addr within a page is ignored and @size is rounded-up
> to
> > + * the next page boundary.
> > + *
> > + * Note that it is the caller's responsibility to invalidate the TLB after
> > + * calling this function to ensure that the disabled HW dirty are visible
> > + * to the CPUs.
> > + *
> > + * Return: 0 on success, negative error code on failure.
> > + */
> > +int kvm_pgtable_stage2_clear_dbm(struct kvm_pgtable *pgt, u64 addr,
> u64 size);
> > +
> > +/**
> > + * kvm_pgtable_stage2_set_dbm() - Set DBM of guest stage-2 address
> range to
> > + *                                enable HW dirty (only last level).
> > + * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
> > + * @addr:	Intermediate physical address from which to set DBM.
> > + * @size:	Size of the range.
> > + *
> > + * The offset of @addr within a page is ignored and @size is rounded-up
> to
> > + * the next page boundary.
> > + *
> > + * Return: 0 on success, negative error code on failure.
> > + */
> > +int kvm_pgtable_stage2_set_dbm(struct kvm_pgtable *pgt, u64 addr, u64
> size);
> > +
> > +/**
> > + * kvm_pgtable_stage2_sync_dirty() - Sync HW dirty state into memslot.
> > + * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init().
> > + * @addr:	Intermediate physical address from which to sync.
> > + * @size:	Size of the range.
> > + *
> > + * The offset of @addr within a page is ignored and @size is rounded-up
> to
> > + * the next page boundary.
> > + *
> > + * Return: 0 on success, negative error code on failure.
> > + */
> > +int kvm_pgtable_stage2_sync_dirty(struct kvm_pgtable *pgt, u64 addr,
> u64 size);
> > +
> >  /**
> >   * kvm_pgtable_stage2_wrprotect() - Write-protect guest stage-2
> address range
> >   *                                  without TLB invalidation.
> > diff --git a/arch/arm64/kernel/image-vars.h
> b/arch/arm64/kernel/image-vars.h
> > index 35f3c7959513..2ca600e3d637 100644
> > --- a/arch/arm64/kernel/image-vars.h
> > +++ b/arch/arm64/kernel/image-vars.h
> > @@ -68,6 +68,8 @@ KVM_NVHE_ALIAS(__hyp_stub_vectors);
> >  KVM_NVHE_ALIAS(vgic_v2_cpuif_trap);
> >  KVM_NVHE_ALIAS(vgic_v3_cpuif_trap);
> >
> > +KVM_NVHE_ALIAS(mark_page_dirty);
> > +
> 
> This doesn't make any sense besides satisfying the linker. The hyp page
> table walkers will *never* need to mark a page as dirty.
> 
> Consider adding a new function pointer to kvm_pgtable_mm_ops and only
> set it for the 'normal' stage-2 mm ops in mmu.c.

Yes, this is only to satisfy the linker for NVHE. I will add the function pointer
to handle this.

> 
> > +static bool stage2_pte_writeable(kvm_pte_t pte)
> > +{
> > +	return pte & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
> > +}
> > +
> > +static void kvm_update_hw_dbm(const struct kvm_pgtable_visit_ctx *ctx,
> > +			      kvm_pte_t new)
> > +{
> > +	kvm_pte_t old_pte, pte = ctx->old;
> > +
> > +	/* Only set DBM if page is writeable */
> > +	if ((new & KVM_PTE_LEAF_ATTR_HI_S2_DBM)
> && !stage2_pte_writeable(pte))
> > +		return;
> > +
> > +	/* Clear DBM walk is not shared, update */
> > +	if (!kvm_pgtable_walk_shared(ctx)) {
> > +		WRITE_ONCE(*ctx->ptep, new);
> > +		return;
> > +	}
> > +
> > +	do {
> > +		old_pte = pte;
> > +		pte = new;
> > +
> > +		if (old_pte == pte)
> > +			break;
> > +
> > +		pte = cmpxchg_relaxed(ctx->ptep, old_pte, pte);
> > +	} while (pte != old_pte);
> > +}
> > +
> 
> We don't need a separate walker for updating the DBM state in the
> page tables. Can't we treat it like any other permission bit and use
> something like kvm_pgtable_stage2_relax_perms()?

I treated it separately to isolate it from rest of PTE updates for ease of
debug/test initially. But yes, looks like we can treat it generally. 

> Also, what is the purpose of retrying the update on a descriptor if the
> cmpxchg() fails? Everywhere else in the page table walker code we bail
> and retry execution since that is a clear indication of a race. In all
> likelihood the other vCPU thread was either trying to update DBM or
> service a permission fault.

Retry was added to avoid any situation where it will return without setting
the DBM and we end up scanning for dirty pages irrespectively. I will add
some debug info to see the number of races we are getting and its impact
on performance.

> 
> >  static bool stage2_try_set_pte(const struct kvm_pgtable_visit_ctx *ctx,
> kvm_pte_t new)
> >  {
> > +	if (kvm_pgtable_walk_hw_dbm(ctx)) {
> > +		kvm_update_hw_dbm(ctx, new);
> > +		return true;
> > +	}
> > +
> 
> Why are you trying to circumvent the primitive for setting stage-2 PTEs?

Not sure it actually does that from a functionality point of view, as the flag 
_WALK_HW_DBM is only set from set_dbm/clear_dbm paths. But yes we
can do better if we get rid of the above retry logic, I guess.

> 
> >  	if (!kvm_pgtable_walk_shared(ctx)) {
> >  		WRITE_ONCE(*ctx->ptep, new);
> >  		return true;
> > @@ -952,6 +990,11 @@ static int stage2_map_walker_try_leaf(const
> struct kvm_pgtable_visit_ctx *ctx,
> >  	    stage2_pte_executable(new))
> >  		mm_ops->icache_inval_pou(kvm_pte_follow(new, mm_ops),
> granule);
> >
> > +	/* Save the possible hardware dirty info */
> > +	if ((ctx->level == KVM_PGTABLE_MAX_LEVELS - 1) &&
> > +	    stage2_pte_writeable(ctx->old))
> > +		mark_page_dirty(kvm_s2_mmu_to_kvm(pgt->mmu), ctx->addr >>
> PAGE_SHIFT);
> > +
> >  	stage2_make_pte(ctx, new);
> >
> >  	return 0;
> > @@ -1125,6 +1168,11 @@ static int stage2_unmap_walker(const struct
> kvm_pgtable_visit_ctx *ctx,
> >  	 */
> >  	stage2_unmap_put_pte(ctx, mmu, mm_ops);
> >
> > +	/* Save the possible hardware dirty info */
> > +	if ((ctx->level == KVM_PGTABLE_MAX_LEVELS - 1) &&
> > +	    stage2_pte_writeable(ctx->old))
> > +		mark_page_dirty(kvm_s2_mmu_to_kvm(mmu), ctx->addr >>
> PAGE_SHIFT);
> > +
> >  	if (need_flush && mm_ops->dcache_clean_inval_poc)
> >  		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(ctx->old,
> mm_ops),
> >  					       kvm_granule_size(ctx->level));
> > @@ -1230,6 +1278,30 @@ static int stage2_update_leaf_attrs(struct
> kvm_pgtable *pgt, u64 addr,
> >  	return 0;
> >  }
> >
> > +int kvm_pgtable_stage2_set_dbm(struct kvm_pgtable *pgt, u64 addr, u64
> size)
> > +{
> > +	int ret;
> > +	u64 offset;
> > +
> > +	ret = stage2_update_leaf_attrs(pgt, addr, size,
> KVM_PTE_LEAF_ATTR_HI_S2_DBM, 0,
> > +				       NULL, NULL, KVM_PGTABLE_WALK_HW_DBM |
> > +				       KVM_PGTABLE_WALK_SHARED);
> > +	if (!ret)
> > +		return ret;
> > +
> > +	for (offset = 0; offset < size; offset += PAGE_SIZE)
> > +		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa_nsh, pgt->mmu, addr +
> offset, 3);
> > +
> > +	return 0;
> > +}
> > +
> > +int kvm_pgtable_stage2_clear_dbm(struct kvm_pgtable *pgt, u64 addr,
> u64 size)
> > +{
> > +	return stage2_update_leaf_attrs(pgt, addr, size,
> > +					0, KVM_PTE_LEAF_ATTR_HI_S2_DBM,
> > +					NULL, NULL, KVM_PGTABLE_WALK_HW_DBM);
> > +}
> > +
> >  int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr,
> u64 size)
> >  {
> >  	return stage2_update_leaf_attrs(pgt, addr, size, 0,
> > @@ -1329,6 +1401,32 @@ int kvm_pgtable_stage2_relax_perms(struct
> kvm_pgtable *pgt, u64 addr,
> >  	return ret;
> >  }
> >
> > +static int stage2_sync_dirty_walker(const struct kvm_pgtable_visit_ctx
> *ctx,
> > +				    enum kvm_pgtable_walk_flags visit)
> > +{
> > +	kvm_pte_t pte = READ_ONCE(*ctx->ptep);
> 
> ctx->old is fetched in __kvm_pgtable_visit(), and the whole
> parallelization scheme for page table walkers depends on us being
> careful to read the PTE once per level. Do you need to reread it here?

Nope. That's a mistake. Will change that.

Thanks,
Shameer

