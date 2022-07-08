Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A14E556B110
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 05:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236655AbiGHDoQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 23:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbiGHDoN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 23:44:13 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 735C25A2C4;
        Thu,  7 Jul 2022 20:44:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657251850; x=1688787850;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=SN8M8c1Re6eZOLeMIfgs3vXZtNfivZUGvLuaCfno0Ew=;
  b=MNDCloDHsgJuMbgpfSS2AqXEcMyzhJV2yF2B8E2WMlVRnXDwUwjRn7gD
   Y8mQf8c51f5EkFTBKnbm6N1sbX3mBILHA2jvwjvjPgEuqOHmpAzcJU7wG
   qwm5334HopOszkmfdEPqcm1TPLAJ8aHkm09mrBgng+33dhpgEcaCktiKG
   Paft6p4duIl9du1eo0eEgg5s54a5+LEbdFP2+pcmtR3DlDelQMwcCGNVx
   PQi3S1t+zWwOB4Bwe/akYufLb+jXSkcQAuZm/RWkgZRjWN5jQ+n4tSZes
   Zm0hKoE73W3M0cOYpEioYrU4cNEk62vBEtuHBoIHdUOyPHXECVaDYeosG
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10401"; a="267211776"
X-IronPort-AV: E=Sophos;i="5.92,254,1650956400"; 
   d="scan'208";a="267211776"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 20:44:09 -0700
X-IronPort-AV: E=Sophos;i="5.92,254,1650956400"; 
   d="scan'208";a="626563533"
Received: from pantones-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.54.208])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 20:44:08 -0700
Message-ID: <f5172016f6481f65efe5508bba629c1b9f0ff117.camel@intel.com>
Subject: Re: [PATCH v7 046/102] KVM: x86/tdp_mmu: Support TDX private
 mapping for TDP MMU
From:   Kai Huang <kai.huang@intel.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>
Date:   Fri, 08 Jul 2022 15:44:05 +1200
In-Reply-To: <94524fe1d3ead13019a2b502f37797727296fbd1.1656366338.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
         <94524fe1d3ead13019a2b502f37797727296fbd1.1656366338.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-06-27 at 14:53 -0700, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>=20
> Allocate mirrored private page table for private page table, and add hook=
s
> to operate on mirrored private page table.  This patch adds only hooks. A=
s
> kvm_gfn_shared_mask() returns false always, those hooks aren't called yet=
.
>=20
> Because private guest page is protected, page copy with mmu_notifier to
> migrate page doesn't work.  Callback from backing store is needed.
>=20
> When the faulting GPA is private, the KVM fault is also called private.
> When resolving private KVM, allocate mirrored private page table and call
> hooks to operate on mirrored private page table. On the change of the
> private PTE entry, invoke kvm_x86_ops hook in __handle_changed_spte() to
> propagate the change to mirrored private page table. The following depict=
s
> the relationship.
>=20
>   private KVM page fault   |
>       |                    |
>       V                    |
>  private GPA               |
>       |                    |
>       V                    |
>  KVM private PT root       |  CPU private PT root
>       |                    |           |
>       V                    |           V
>    private PT ---hook to mirror--->mirrored private PT
>       |                    |           |
>       \--------------------+------\    |
>                            |      |    |
>                            |      V    V
>                            |    private guest page
>                            |
>                            |
>      non-encrypted memory  |    encrypted memory
>                            |
> PT: page table
>=20
> The existing KVM TDP MMU code uses atomic update of SPTE.  On populating
> the EPT entry, atomically set the entry.  However, it requires TLB
> shootdown to zap SPTE.  To address it, the entry is frozen with the speci=
al
> SPTE value that clears the present bit. After the TLB shootdown, the entr=
y
> is set to the eventual value (unfreeze).
>=20
> For mirrored private page table, hooks are called to update mirrored
> private page table in addition to direct access to the private SPTE. For
> the zapping case, it works to freeze the SPTE. It can call hooks in
> addition to TLB shootdown.  For populating the private SPTE entry, there
> can be a race condition without further protection
>=20
>   vcpu 1: populating 2M private SPTE
>   vcpu 2: populating 4K private SPTE
>   vcpu 2: TDX SEAMCALL to update 4K mirrored private SPTE =3D> error
>   vcpu 1: TDX SEAMCALL to update 2M mirrored private SPTE
>=20
> To avoid the race, the frozen SPTE is utilized.  Instead of atomic update
> of the private entry, freeze the entry, call the hook that update mirrore=
d
> private SPTE, set the entry to the final value.
>=20
> Support 4K page only at this stage.  2M page support can be done in futur=
e
> patches.
>=20
> Add is_private member to kvm_page_fault to indicate the fault is private.
> Also is_private member to struct tdp_inter to propagate it.
>=20
> Co-developed-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |   2 +
>  arch/x86/include/asm/kvm_host.h    |  20 +++
>  arch/x86/kvm/mmu/mmu.c             |  86 +++++++++-
>  arch/x86/kvm/mmu/mmu_internal.h    |  37 +++++
>  arch/x86/kvm/mmu/paging_tmpl.h     |   2 +-
>  arch/x86/kvm/mmu/tdp_iter.c        |   1 +
>  arch/x86/kvm/mmu/tdp_iter.h        |   5 +-
>  arch/x86/kvm/mmu/tdp_mmu.c         | 247 +++++++++++++++++++++++------
>  arch/x86/kvm/mmu/tdp_mmu.h         |   7 +-
>  virt/kvm/kvm_main.c                |   1 +
>  10 files changed, 346 insertions(+), 62 deletions(-)
>=20
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kv=
m-x86-ops.h
> index 32a6df784ea6..6982d57e4518 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -93,6 +93,8 @@ KVM_X86_OP_OPTIONAL_RET0(set_tss_addr)
>  KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
>  KVM_X86_OP(get_mt_mask)
>  KVM_X86_OP(load_mmu_pgd)
> +KVM_X86_OP_OPTIONAL(free_private_sp)
> +KVM_X86_OP_OPTIONAL(handle_changed_private_spte)
>  KVM_X86_OP(has_wbinvd_exit)
>  KVM_X86_OP(get_l2_tsc_offset)
>  KVM_X86_OP(get_l2_tsc_multiplier)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index bfc934dc9a33..f2a4d5a18851 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -440,6 +440,7 @@ struct kvm_mmu {
>  			 struct kvm_mmu_page *sp);
>  	void (*invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa);
>  	struct kvm_mmu_root_info root;
> +	hpa_t private_root_hpa;
>  	union kvm_cpu_role cpu_role;
>  	union kvm_mmu_page_role root_role;
> =20
> @@ -1435,6 +1436,20 @@ static inline u16 kvm_lapic_irq_dest_mode(bool des=
t_mode_logical)
>  	return dest_mode_logical ? APIC_DEST_LOGICAL : APIC_DEST_PHYSICAL;
>  }
> =20
> +struct kvm_spte {
> +	kvm_pfn_t pfn;
> +	bool is_present;
> +	bool is_leaf;
> +};
> +
> +struct kvm_spte_change {
> +	gfn_t gfn;
> +	enum pg_level level;
> +	struct kvm_spte old;
> +	struct kvm_spte new;
> +	void *sept_page;
> +};
> +
>  struct kvm_x86_ops {
>  	const char *name;
> =20
> @@ -1547,6 +1562,11 @@ struct kvm_x86_ops {
>  	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
>  			     int root_level);
> =20
> +	int (*free_private_sp)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> +			       void *private_sp);
> +	void (*handle_changed_private_spte)(
> +		struct kvm *kvm, const struct kvm_spte_change *change);
> +
>  	bool (*has_wbinvd_exit)(void);
> =20
>  	u64 (*get_l2_tsc_offset)(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index a5bf3e40e209..ef925722ee28 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1577,7 +1577,11 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct k=
vm_gfn_range *range)
>  		flush =3D kvm_handle_gfn_range(kvm, range, kvm_unmap_rmapp);
> =20
>  	if (is_tdp_mmu_enabled(kvm))
> -		flush =3D kvm_tdp_mmu_unmap_gfn_range(kvm, range, flush);
> +		/*
> +		 * private page needs to be kept and handle page migration
> +		 * on next EPT violation.
> +		 */

I don't think this series supports page migration? How can page migration b=
e
handled in next EPT violation?

> +		flush =3D kvm_tdp_mmu_unmap_gfn_range(kvm, range, flush, false);

The meaning of the additional 'false' isn't clear at all.  I need to go thr=
ough
entire patch to figure out what does it mean.

How about splitting 'adding additional false argument' part as a separate p=
atch
(no functional change), give a short changelog to explain, and put it befor=
e
this patch?  In this way we can clearly understand what it does here.
> =20
>  	return flush;
>  }
> @@ -3082,7 +3086,8 @@ static int handle_abnormal_pfn(struct kvm_vcpu *vcp=
u, struct kvm_page_fault *fau
>  		 * SPTE value without #VE suppress bit cleared
>  		 * (kvm->arch.shadow_mmio_value =3D 0).
>  		 */
> -		if (unlikely(!vcpu->kvm->arch.enable_mmio_caching) ||
> +		if (unlikely(!vcpu->kvm->arch.enable_mmio_caching &&
> +			     !kvm_gfn_shared_mask(vcpu->kvm)) ||

This chunk belongs to MMIO fault handling patch.

>  		    unlikely(fault->gfn > kvm_mmu_max_gfn()))
>  			return RET_PF_EMULATE;
>  	}
> @@ -3454,7 +3459,12 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu =
*vcpu)
>  		goto out_unlock;
> =20
>  	if (is_tdp_mmu_enabled(vcpu->kvm)) {
> -		root =3D kvm_tdp_mmu_get_vcpu_root_hpa(vcpu);
> +		if (kvm_gfn_shared_mask(vcpu->kvm) &&
> +		    !VALID_PAGE(mmu->private_root_hpa)) {
> +			root =3D kvm_tdp_mmu_get_vcpu_root_hpa(vcpu, true);
> +			mmu->private_root_hpa =3D root;
> +		}
> +		root =3D kvm_tdp_mmu_get_vcpu_root_hpa(vcpu, false);
>  		mmu->root.hpa =3D root;
>  	} else if (shadow_root_level >=3D PT64_ROOT_4LEVEL) {
>  		root =3D mmu_alloc_root(vcpu, 0, 0, shadow_root_level, true);
> @@ -4026,6 +4036,32 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vc=
pu, struct kvm_async_pf *work)
>  	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true);
>  }
> =20
> +/*
> + * Private page can't be release on mmu_notifier without losing page con=
tents.
> + * The help, callback, from backing store is needed to allow page migrat=
ion.

I hardly can understand what does ', callback, ' part mean.  I guess it is =
used
to explain exactly what is the 'help'.  I am not native speaker, but the
grammar=C2=A0doesn't look right to me.

This series is fully of this patten.  It hurts readability a lot.  Would yo=
u
improve it?

> + * For now, pin the page.
> + */

Back to the technical point.  IMHO you need to explain how page migration i=
s
supposed to work to justify why page migration needs help from backing stor=
e
first.  Perhaps you can briefly explain in the changelog so people can
understand what part is done by backing store and which part is done by KVM=
.

For instance, for anonymous page, page migration is done by core-kernel.  S=
o why
backing store cannot handle page migration for TDX?  Is it technically unab=
le to
by design, or is it because it just hasn't implemented it yet?

If the latter, why backing store doesn't pin the page directly but requires=
 KVM
to do?


> +static int kvm_faultin_pfn_private_mapped(struct kvm_vcpu *vcpu,
> +					   struct kvm_page_fault *fault)
> +{
> +	hva_t hva =3D gfn_to_hva_memslot(fault->slot, fault->gfn);
> +	struct page *page[1];
> +
> +	fault->map_writable =3D false;
> +	fault->pfn =3D KVM_PFN_ERR_FAULT;
> +	if (hva =3D=3D KVM_HVA_ERR_RO_BAD || hva =3D=3D KVM_HVA_ERR_BAD)
> +		return RET_PF_CONTINUE;
> +
> +	/* TDX allows only RWX.  Read-only isn't supported. */
> +	WARN_ON_ONCE(!fault->write);
> +	if (pin_user_pages_fast(hva, 1, FOLL_WRITE, page) !=3D 1)
> +		return RET_PF_INVALID;
> +
> +	fault->map_writable =3D true;
> +	fault->pfn =3D page_to_pfn(page[0]);
> +	return RET_PF_CONTINUE;
> +}
> +
>  static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault =
*fault)
>  {
>  	struct kvm_memory_slot *slot =3D fault->slot;
> @@ -4058,6 +4094,9 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, s=
truct kvm_page_fault *fault)
>  			return RET_PF_EMULATE;
>  	}
> =20
> +	if (fault->is_private)
> +		return kvm_faultin_pfn_private_mapped(vcpu, fault);
> +
>  	async =3D false;
>  	fault->pfn =3D __gfn_to_pfn_memslot(slot, fault->gfn, false, &async,
>  					  fault->write, &fault->map_writable,
> @@ -4110,6 +4149,17 @@ static bool is_page_fault_stale(struct kvm_vcpu *v=
cpu,
>  	       mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, fault->hva);
>  }
> =20
> +void kvm_mmu_release_fault(struct kvm *kvm, struct kvm_page_fault *fault=
, int r)
> +{
> +	if (is_error_noslot_pfn(fault->pfn) || kvm_is_reserved_pfn(fault->pfn))
> +		return;
> +
> +	if (fault->is_private)
> +		put_page(pfn_to_page(fault->pfn));
> +	else
> +		kvm_release_pfn_clean(fault->pfn);
> +}

What's the purpose of 'int r'?  Is it even used?

> +
>  static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_faul=
t *fault)
>  {
>  	bool is_tdp_mmu_fault =3D is_tdp_mmu(vcpu->arch.mmu);
> @@ -4117,7 +4167,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu,=
 struct kvm_page_fault *fault
>  	unsigned long mmu_seq;
>  	int r;
> =20
> -	fault->gfn =3D fault->addr >> PAGE_SHIFT;
> +	fault->gfn =3D gpa_to_gfn(fault->addr) & ~kvm_gfn_shared_mask(vcpu->kvm=
);
>  	fault->slot =3D kvm_vcpu_gfn_to_memslot(vcpu, fault->gfn);

Where is fault->is_private set? Shouldn't it be set here?

> =20
>  	if (page_fault_handle_page_track(vcpu, fault))
> @@ -4166,7 +4216,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu,=
 struct kvm_page_fault *fault
>  		read_unlock(&vcpu->kvm->mmu_lock);
>  	else
>  		write_unlock(&vcpu->kvm->mmu_lock);
> -	kvm_release_pfn_clean(fault->pfn);
> +	kvm_mmu_release_fault(vcpu->kvm, fault, r);
>  	return r;
>  }
> =20
> @@ -5665,6 +5715,7 @@ static int __kvm_mmu_create(struct kvm_vcpu *vcpu, =
struct kvm_mmu *mmu)
> =20
>  	mmu->root.hpa =3D INVALID_PAGE;
>  	mmu->root.pgd =3D 0;
> +	mmu->private_root_hpa =3D INVALID_PAGE;
>  	for (i =3D 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
>  		mmu->prev_roots[i] =3D KVM_MMU_ROOT_INFO_INVALID;
> =20
> @@ -5855,6 +5906,10 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
>  	 * lead to use-after-free.
>  	 */
>  	if (is_tdp_mmu_enabled(kvm))
> +		/*
> +		 * For now private root is never invalidate during VM is running,
> +		 * so this can only happen for shared roots.
> +		 */

Please put the comment to the code which actually does the job.

>  		kvm_tdp_mmu_zap_invalidated_roots(kvm);
>  }
> =20
> @@ -5882,7 +5937,8 @@ static void kvm_mmu_zap_memslot(struct kvm *kvm, st=
ruct kvm_memory_slot *slot)
>  		      .may_block =3D false,
>  		};
> =20
> -		flush =3D kvm_tdp_mmu_unmap_gfn_range(kvm, &range, flush);
> +		/* All private page should be zapped on memslot deletion. */
> +		flush =3D kvm_tdp_mmu_unmap_gfn_range(kvm, &range, flush, true);
>  	} else {
>  		flush =3D slot_handle_level(kvm, slot, kvm_zap_rmapp, PG_LEVEL_4K,
>  					  KVM_MAX_HUGEPAGE_LEVEL, true);
> @@ -5990,7 +6046,7 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_s=
tart, gfn_t gfn_end)
>  	if (is_tdp_mmu_enabled(kvm)) {
>  		for (i =3D 0; i < KVM_ADDRESS_SPACE_NUM; i++)
>  			flush =3D kvm_tdp_mmu_zap_leafs(kvm, i, gfn_start,
> -						      gfn_end, true, flush);
> +						      gfn_end, true, flush, false);

Add a comment to why kvm_zap_gfn_range() only zap shared?

>  	}
> =20
>  	if (flush)
> @@ -6023,6 +6079,11 @@ void kvm_mmu_slot_remove_write_access(struct kvm *=
kvm,
>  		write_unlock(&kvm->mmu_lock);
>  	}
> =20
> +	/*
> +	 * For now this can only happen for non-TD VM, because TD private
> +	 * mapping doesn't support write protection.  kvm_tdp_mmu_wrprot_slot()
> +	 * will give a WARN() if it hits for TD.
> +	 */

Unless I am mistaken, 'kvm_tdp_mmu_wrprot_slot() will give a WARN() if it h=
its
for TD" is done in your later patch "KVM: x86/tdp_mmu: Ignore unsupported m=
mu
operation on private GFNs".  Why putting comment here?

Please move this comment to that patch, and I think you can put that patch
before this patch.

And this problem happens repeatedly in this series.  Could you check the en=
tire
series?


>  	if (is_tdp_mmu_enabled(kvm)) {
>  		read_lock(&kvm->mmu_lock);
>  		flush |=3D kvm_tdp_mmu_wrprot_slot(kvm, memslot, start_level);
> @@ -6111,6 +6172,9 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm=
 *kvm,
>  		sp =3D sptep_to_sp(sptep);
>  		pfn =3D spte_to_pfn(*sptep);
> =20
> +		/* Private page dirty logging is not supported. */
> +		KVM_BUG_ON(is_private_sptep(sptep), kvm);
> +

Looks like this chunk should belong to patch "KVM: x86/tdp_mmu: Ignore
unsupported mmu operation on private GFNs".

Or you can just merge the two patches together if that make things clearer.

>  		/*
>  		 * We cannot do huge page mapping for indirect shadow pages,
>  		 * which are found on the last rmap (level =3D 1) when not using
> @@ -6151,6 +6215,11 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm=
,
>  		write_unlock(&kvm->mmu_lock);
>  	}
> =20
> +	/*
> +	 * This should only be reachable in case of log-dirty, wihch TD private
> +	 * mapping doesn't support so far.  kvm_tdp_mmu_zap_collapsible_sptes()
> +	 * internally gives a WARN() when it hits.
> +	 */

The same to above..

>  	if (is_tdp_mmu_enabled(kvm)) {
>  		read_lock(&kvm->mmu_lock);
>  		kvm_tdp_mmu_zap_collapsible_sptes(kvm, slot);
> @@ -6437,6 +6506,9 @@ int kvm_mmu_vendor_module_init(void)
>  void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
>  {
>  	kvm_mmu_unload(vcpu);
> +	if (is_tdp_mmu_enabled(vcpu->kvm))
> +		mmu_free_root_page(vcpu->kvm, &vcpu->arch.mmu->private_root_hpa,
> +				NULL);

Cannot judge correctness now, but at least a comment would help here.

>  	free_mmu_pages(&vcpu->arch.root_mmu);
>  	free_mmu_pages(&vcpu->arch.guest_mmu);
>  	mmu_free_memory_caches(vcpu);
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_inter=
nal.h
> index 9f3a6bea60a3..d3b30d62aca0 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -6,6 +6,8 @@
>  #include <linux/kvm_host.h>
>  #include <asm/kvm_host.h>
> =20
> +#include "mmu.h"
> +
>  #undef MMU_DEBUG
> =20
>  #ifdef MMU_DEBUG
> @@ -164,11 +166,30 @@ static inline void kvm_mmu_alloc_private_sp(
>  	WARN_ON_ONCE(!sp->private_sp);
>  }
> =20
> +static inline int kvm_alloc_private_sp_for_split(
> +	struct kvm_mmu_page *sp, gfp_t gfp)
> +{
> +	gfp &=3D ~__GFP_ZERO;
> +	sp->private_sp =3D (void*)__get_free_page(gfp);
> +	if (!sp->private_sp)
> +		return -ENOMEM;
> +	return 0;
> +}

What does "for_split" mean?  Why do we need it?

> +
>  static inline void kvm_mmu_free_private_sp(struct kvm_mmu_page *sp)
>  {
>  	if (sp->private_sp !=3D KVM_MMU_PRIVATE_SP_ROOT)
>  		free_page((unsigned long)sp->private_sp);
>  }
> +
> +static inline gfn_t kvm_gfn_for_root(struct kvm *kvm, struct kvm_mmu_pag=
e *root,
> +				     gfn_t gfn)
> +{
> +	if (is_private_sp(root))
> +		return kvm_gfn_private(kvm, gfn);
> +	else
> +		return kvm_gfn_shared(kvm, gfn);
> +}
>  #else
>  static inline bool is_private_sp(struct kvm_mmu_page *sp)
>  {
> @@ -194,11 +215,25 @@ static inline void kvm_mmu_alloc_private_sp(
>  {
>  }
> =20
> +static inline int kvm_alloc_private_sp_for_split(
> +	struct kvm_mmu_page *sp, gfp_t gfp)
> +{
> +	return -ENOMEM;
> +}
> +
>  static inline void kvm_mmu_free_private_sp(struct kvm_mmu_page *sp)
>  {
>  }
> +
> +static inline gfn_t kvm_gfn_for_root(struct kvm *kvm, struct kvm_mmu_pag=
e *root,
> +				     gfn_t gfn)
> +{
> +	return gfn;
> +}
>  #endif
> =20
> +void kvm_mmu_release_fault(struct kvm *kvm, struct kvm_page_fault *fault=
, int r);
> +
>  static inline bool kvm_mmu_page_ad_need_write_protect(struct kvm_mmu_pag=
e *sp)
>  {
>  	/*
> @@ -246,6 +281,7 @@ struct kvm_page_fault {
>  	/* Derived from mmu and global state.  */
>  	const bool is_tdp;
>  	const bool nx_huge_page_workaround_enabled;
> +	const bool is_private;
> =20
>  	/*
>  	 * Whether a >4KB mapping can be created or is forbidden due to NX
> @@ -327,6 +363,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vc=
pu *vcpu, gpa_t cr2_or_gpa,
>  		.prefetch =3D prefetch,
>  		.is_tdp =3D likely(vcpu->arch.mmu->page_fault =3D=3D kvm_tdp_page_faul=
t),
>  		.nx_huge_page_workaround_enabled =3D is_nx_huge_page_enabled(),
> +		.is_private =3D kvm_is_private_gpa(vcpu->kvm, cr2_or_gpa),

I guess putting this chunk and setting up fault->gfn together would be clea=
rer?

> =20
>  		.max_level =3D vcpu->kvm->arch.tdp_max_page_level,
>  		.req_level =3D PG_LEVEL_4K,
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmp=
l.h
> index 62ae590d4e5b..e5b73638bd83 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -877,7 +877,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, s=
truct kvm_page_fault *fault
> =20
>  out_unlock:
>  	write_unlock(&vcpu->kvm->mmu_lock);
> -	kvm_release_pfn_clean(fault->pfn);
> +	kvm_mmu_release_fault(vcpu->kvm, fault, r);

Too painful to review.  If 'r' is ever needed, please at least consider a m=
ore
meaningful name.

>  	return r;
>  }
> =20
> diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
> index ee4802d7b36c..4ed50f3c424d 100644
> --- a/arch/x86/kvm/mmu/tdp_iter.c
> +++ b/arch/x86/kvm/mmu/tdp_iter.c
> @@ -53,6 +53,7 @@ void tdp_iter_start(struct tdp_iter *iter, struct kvm_m=
mu_page *root,
>  	iter->min_level =3D min_level;
>  	iter->pt_path[iter->root_level - 1] =3D (tdp_ptep_t)root->spt;
>  	iter->as_id =3D kvm_mmu_page_as_id(root);
> +	iter->is_private =3D is_private_sp(root);
> =20
>  	tdp_iter_restart(iter);
>  }
> diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
> index adfca0cf94d3..dec56795c5da 100644
> --- a/arch/x86/kvm/mmu/tdp_iter.h
> +++ b/arch/x86/kvm/mmu/tdp_iter.h
> @@ -71,7 +71,7 @@ struct tdp_iter {
>  	tdp_ptep_t pt_path[PT64_ROOT_MAX_LEVEL];
>  	/* A pointer to the current SPTE */
>  	tdp_ptep_t sptep;
> -	/* The lowest GFN mapped by the current SPTE */
> +	/* The lowest GFN (shared bits included) mapped by the current SPTE */
>  	gfn_t gfn;
>  	/* The level of the root page given to the iterator */
>  	int root_level;
> @@ -94,6 +94,9 @@ struct tdp_iter {
>  	 * level instead of advancing to the next entry.
>  	 */
>  	bool yielded;
> +
> +	/* True if this iter is handling private KVM page fault. */
> +	bool is_private;
>  };
> =20
>  /*
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index d874c79ab96c..12f75e60a254 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -278,18 +278,24 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struc=
t kvm *kvm,
>  		    kvm_mmu_page_as_id(_root) !=3D _as_id) {		\
>  		} else
> =20
> -static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu)
> +static struct kvm_mmu_page *tdp_mmu_alloc_sp(
> +	struct kvm_vcpu *vcpu, bool private, bool is_root)
>  {
>  	struct kvm_mmu_page *sp;
> =20
>  	sp =3D kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
>  	sp->spt =3D kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cach=
e);
> =20
> +	if (private)
> +		kvm_mmu_alloc_private_sp(vcpu, sp, is_root);
> +	else
> +		kvm_mmu_init_private_sp(sp, NULL);
> +
>  	return sp;
>  }
> =20
> -static void tdp_mmu_init_sp(struct kvm_mmu_page *sp, tdp_ptep_t sptep,
> -			    gfn_t gfn, union kvm_mmu_page_role role)
> +static void tdp_mmu_init_sp(struct kvm_mmu_page *sp, tdp_ptep_t sptep, g=
fn_t gfn,
> +			    union kvm_mmu_page_role role)
>  {
>  	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
> =20
> @@ -297,7 +303,6 @@ static void tdp_mmu_init_sp(struct kvm_mmu_page *sp, =
tdp_ptep_t sptep,
>  	sp->gfn =3D gfn;
>  	sp->ptep =3D sptep;
>  	sp->tdp_mmu_page =3D true;
> -	kvm_mmu_init_private_sp(sp);
> =20
>  	trace_kvm_mmu_get_page(sp, true);
>  }
> @@ -316,7 +321,8 @@ static void tdp_mmu_init_child_sp(struct kvm_mmu_page=
 *child_sp,
>  	tdp_mmu_init_sp(child_sp, iter->sptep, iter->gfn, role);
>  }
> =20
> -hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
> +static struct kvm_mmu_page *kvm_tdp_mmu_get_vcpu_root(struct kvm_vcpu *v=
cpu,
> +						      bool private)
>  {
>  	union kvm_mmu_page_role role =3D vcpu->arch.mmu->root_role;
>  	struct kvm *kvm =3D vcpu->kvm;
> @@ -330,11 +336,12 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu=
 *vcpu)
>  	 */
>  	for_each_tdp_mmu_root(kvm, root, kvm_mmu_role_as_id(role)) {
>  		if (root->role.word =3D=3D role.word &&
> +		    is_private_sp(root) =3D=3D private &&
>  		    kvm_tdp_mmu_get_root(root))

Is it better to have a role.private, so you don't need this change?

>  			goto out;
>  	}
> =20
> -	root =3D tdp_mmu_alloc_sp(vcpu);
> +	root =3D tdp_mmu_alloc_sp(vcpu, private, true);

With role.private, I think you can avoid 'private' argument here?

And can you check sp->role.level to determine whether it is root?


>  	tdp_mmu_init_sp(root, NULL, 0, role);
> =20
>  	refcount_set(&root->tdp_mmu_root_count, 1);
> @@ -344,12 +351,17 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu=
 *vcpu)
>  	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> =20
>  out:
> -	return __pa(root->spt);
> +	return root;
> +}
> +
> +hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu, bool private)
> +{
> +	return __pa(kvm_tdp_mmu_get_vcpu_root(vcpu, private)->spt);
>  }
> =20
>  static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
> -				u64 old_spte, u64 new_spte, int level,
> -				bool shared);
> +				bool private_spte, u64 old_spte,
> +				u64 new_spte, int level, bool shared);
> =20
>  static void handle_changed_spte_acc_track(u64 old_spte, u64 new_spte, in=
t level)
>  {
> @@ -410,6 +422,7 @@ static void tdp_mmu_unlink_sp(struct kvm *kvm, struct=
 kvm_mmu_page *sp,
>   *
>   * @kvm: kvm instance
>   * @pt: the page removed from the paging structure
> + * @is_private: pt is private or not.
>   * @shared: This operation may not be running under the exclusive use
>   *	    of the MMU lock and the operation must synchronize with other
>   *	    threads that might be modifying SPTEs.
> @@ -422,7 +435,8 @@ static void tdp_mmu_unlink_sp(struct kvm *kvm, struct=
 kvm_mmu_page *sp,
>   * this thread will be responsible for ensuring the page is freed. Hence=
 the
>   * early rcu_dereferences in the function.
>   */
> -static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool share=
d)
> +static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool is_pr=
ivate,
> +			      bool shared)

I think you can get whether the page table is private or not by ...
>  {
>  	struct kvm_mmu_page *sp =3D sptep_to_sp(rcu_dereference(pt));

... checking is_private_sp(sp), right?

Why do you need 'is_private' argumenet?

>  	int level =3D sp->role.level;
> @@ -498,8 +512,20 @@ static void handle_removed_pt(struct kvm *kvm, tdp_p=
tep_t pt, bool shared)
>  			old_spte =3D kvm_tdp_mmu_write_spte(sptep, old_spte,
>  							  REMOVED_SPTE, level);
>  		}
> -		handle_changed_spte(kvm, kvm_mmu_page_as_id(sp), gfn,
> -				    old_spte, REMOVED_SPTE, level, shared);
> +		handle_changed_spte(kvm, kvm_mmu_page_as_id(sp), gfn, is_private,
> +				    old_spte, REMOVED_SPTE, level,
> +				    shared);
> +	}
> +
> +	if (is_private && WARN_ON(static_call(kvm_x86_free_private_sp)(
> +					  kvm, sp->gfn, sp->role.level,
> +					  kvm_mmu_private_sp(sp)))) {
> +		/*
> +		 * Failed to unlink Secure EPT page and there is nothing to do
> +		 * further.  Intentionally leak the page to prevent the kernel
> +		 * from accessing the encrypted page.
> +		 */
> +		kvm_mmu_init_private_sp(sp, NULL);

At least explicitly give a error message, or even a WARN().

>  	}
> =20
>  	call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
> @@ -510,6 +536,7 @@ static void handle_removed_pt(struct kvm *kvm, tdp_pt=
ep_t pt, bool shared)
>   * @kvm: kvm instance
>   * @as_id: the address space of the paging structure the SPTE was a part=
 of
>   * @gfn: the base GFN that was mapped by the SPTE
> + * @private_spte: the SPTE is private or not
>   * @old_spte: The value of the SPTE before the change
>   * @new_spte: The value of the SPTE after the change
>   * @level: the level of the PT the SPTE is part of in the paging structu=
re
> @@ -521,14 +548,30 @@ static void handle_removed_pt(struct kvm *kvm, tdp_=
ptep_t pt, bool shared)
>   * This function must be called for all TDP SPTE modifications.
>   */
>  static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
> -				  u64 old_spte, u64 new_spte, int level,
> -				  bool shared)
> +				  bool private_spte, u64 old_spte,
> +				  u64 new_spte, int level, bool shared)

I am thinking if you can just pass parent 'sp', or sptep, then you can get =
all
roles internally, including whether it is private.  I guess it is more flex=
ible.

>  {
>  	bool was_present =3D is_shadow_present_pte(old_spte);
>  	bool is_present =3D is_shadow_present_pte(new_spte);
>  	bool was_leaf =3D was_present && is_last_spte(old_spte, level);
>  	bool is_leaf =3D is_present && is_last_spte(new_spte, level);
> -	bool pfn_changed =3D spte_to_pfn(old_spte) !=3D spte_to_pfn(new_spte);
> +	kvm_pfn_t old_pfn =3D spte_to_pfn(old_spte);
> +	kvm_pfn_t new_pfn =3D spte_to_pfn(new_spte);
> +	bool pfn_changed =3D old_pfn !=3D new_pfn;
> +	struct kvm_spte_change change =3D {
> +		.gfn =3D gfn,
> +		.level =3D level,
> +		.old =3D {
> +			.pfn =3D old_pfn,
> +			.is_present =3D was_present,
> +			.is_leaf =3D was_leaf,
> +		},
> +		.new =3D {
> +			.pfn =3D new_pfn,
> +			.is_present =3D is_present,
> +			.is_leaf =3D is_leaf,
> +		},
> +	};
> =20
>  	WARN_ON(level > PT64_ROOT_MAX_LEVEL);
>  	WARN_ON(level < PG_LEVEL_4K);
> @@ -595,7 +638,7 @@ static void __handle_changed_spte(struct kvm *kvm, in=
t as_id, gfn_t gfn,
> =20
>  	if (was_leaf && is_dirty_spte(old_spte) &&
>  	    (!is_present || !is_dirty_spte(new_spte) || pfn_changed))
> -		kvm_set_pfn_dirty(spte_to_pfn(old_spte));
> +		kvm_set_pfn_dirty(old_pfn);
> =20
>  	/*
>  	 * Recursively handle child PTs if the change removed a subtree from
> @@ -604,16 +647,47 @@ static void __handle_changed_spte(struct kvm *kvm, =
int as_id, gfn_t gfn,
>  	 * pages are kernel allocations and should never be migrated.
>  	 */
>  	if (was_present && !was_leaf &&
> -	    (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed)))
> -		handle_removed_pt(kvm, spte_to_child_pt(old_spte, level), shared);
> +	    (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed))) {
> +		WARN_ON(private_spte !=3D
> +			is_private_sptep(spte_to_child_pt(old_spte, level)));
> +		handle_removed_pt(kvm, spte_to_child_pt(old_spte, level),
> +				  private_spte, shared);
> +	}
> +
> +	/*
> +	 * Special handling for the private mapping.  We are either
> +	 * setting up new mapping at middle level page table, or leaf,
> +	 * or tearing down existing mapping.
> +	 *
> +	 * This is after handling lower page table by above
> +	 * handle_remove_tdp_mmu_page().  S-EPT requires to remove S-EPT tables
> +	 * after removing childrens.
> +	 */
> +	if (private_spte &&
> +	    /* Ignore change of software only bits. e.g. host_writable */
> +	    (was_leaf !=3D is_leaf || was_present !=3D is_present || pfn_change=
d)) {
> +		void *sept_page =3D NULL;
> +
> +		if (is_present && !is_leaf) {
> +			struct kvm_mmu_page *sp =3D to_shadow_page(pfn_to_hpa(new_pfn));
> +
> +			sept_page =3D kvm_mmu_private_sp(sp);
> +			WARN_ON(!sept_page);
> +			WARN_ON(sp->role.level + 1 !=3D level);
> +			WARN_ON(sp->gfn !=3D gfn);
> +		}
> +		change.sept_page =3D sept_page;
> +
> +		static_call(kvm_x86_handle_changed_private_spte)(kvm, &change);
> +	}
>  }
> =20
>  static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
> -				u64 old_spte, u64 new_spte, int level,
> -				bool shared)
> +				bool private_spte, u64 old_spte, u64 new_spte,
> +				int level, bool shared)
>  {
> -	__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level,
> -			      shared);
> +	__handle_changed_spte(kvm, as_id, gfn, private_spte,
> +			old_spte, new_spte, level, shared);
>  	handle_changed_spte_acc_track(old_spte, new_spte, level);
>  	handle_changed_spte_dirty_log(kvm, as_id, gfn, old_spte,
>  				      new_spte, level);
> @@ -640,6 +714,8 @@ static inline int tdp_mmu_set_spte_atomic(struct kvm =
*kvm,
>  					  struct tdp_iter *iter,
>  					  u64 new_spte)
>  {
> +	bool freeze_spte =3D iter->is_private && !is_removed_spte(new_spte);
> +	u64 tmp_spte =3D freeze_spte ? REMOVED_SPTE : new_spte;

Perhaps I am missing something.  Could you add comments to explain the logi=
c?

>  	u64 *sptep =3D rcu_dereference(iter->sptep);
>  	u64 old_spte;
> =20
> @@ -657,7 +733,7 @@ static inline int tdp_mmu_set_spte_atomic(struct kvm =
*kvm,
>  	 * Note, fast_pf_fix_direct_spte() can also modify TDP MMU SPTEs and
>  	 * does not hold the mmu_lock.
>  	 */
> -	old_spte =3D cmpxchg64(sptep, iter->old_spte, new_spte);
> +	old_spte =3D cmpxchg64(sptep, iter->old_spte, tmp_spte);
>  	if (old_spte !=3D iter->old_spte) {
>  		/*
>  		 * The page table entry was modified by a different logical
> @@ -669,10 +745,14 @@ static inline int tdp_mmu_set_spte_atomic(struct kv=
m *kvm,
>  		return -EBUSY;
>  	}
> =20
> -	__handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
> -			      new_spte, iter->level, true);
> +	__handle_changed_spte(
> +		kvm, iter->as_id, iter->gfn, iter->is_private,
> +		iter->old_spte, new_spte, iter->level, true);
>  	handle_changed_spte_acc_track(iter->old_spte, new_spte, iter->level);
> =20
> +	if (freeze_spte)
> +		__kvm_tdp_mmu_write_spte(sptep, new_spte);
> +
>  	return 0;
>  }
> =20
> @@ -734,13 +814,15 @@ static inline int tdp_mmu_zap_spte_atomic(struct kv=
m *kvm,
>   *		      unless performing certain dirty logging operations.
>   *		      Leaving record_dirty_log unset in that case prevents page
>   *		      writes from being double counted.
> + * @is_private:       The fault is private.
>   *
>   * Returns the old SPTE value, which _may_ be different than @old_spte i=
f the
>   * SPTE had voldatile bits.
>   */
>  static u64 __tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t spt=
ep,
> -			      u64 old_spte, u64 new_spte, gfn_t gfn, int level,
> -			      bool record_acc_track, bool record_dirty_log)
> +			       u64 old_spte, u64 new_spte, gfn_t gfn, int level,
> +			       bool record_acc_track, bool record_dirty_log,
> +			       bool is_private)
>  {
>  	lockdep_assert_held_write(&kvm->mmu_lock);
> =20
> @@ -755,7 +837,8 @@ static u64 __tdp_mmu_set_spte(struct kvm *kvm, int as=
_id, tdp_ptep_t sptep,
> =20
>  	old_spte =3D kvm_tdp_mmu_write_spte(sptep, old_spte, new_spte, level);
> =20
> -	__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level, false=
);
> +	__handle_changed_spte(kvm, as_id, gfn, is_private,
> +			      old_spte, new_spte, level, false);
> =20
>  	if (record_acc_track)
>  		handle_changed_spte_acc_track(old_spte, new_spte, level);
> @@ -774,7 +857,8 @@ static inline void _tdp_mmu_set_spte(struct kvm *kvm,=
 struct tdp_iter *iter,
>  	iter->old_spte =3D __tdp_mmu_set_spte(kvm, iter->as_id, iter->sptep,
>  					    iter->old_spte, new_spte,
>  					    iter->gfn, iter->level,
> -					    record_acc_track, record_dirty_log);
> +					    record_acc_track, record_dirty_log,
> +					    iter->is_private);
>  }
> =20
>  static inline void tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *it=
er,
> @@ -807,8 +891,11 @@ static inline void tdp_mmu_set_spte_no_dirty_log(str=
uct kvm *kvm,
>  			continue;					\
>  		else
> =20
> -#define tdp_mmu_for_each_pte(_iter, _mmu, _start, _end)		\
> -	for_each_tdp_pte(_iter, to_shadow_page(_mmu->root.hpa), _start, _end)
> +#define tdp_mmu_for_each_pte(_iter, _mmu, _private, _start, _end)	\
> +	for_each_tdp_pte(_iter,						\
> +		 to_shadow_page((_private) ? _mmu->private_root_hpa :	\
> +				_mmu->root.hpa),			\
> +		_start, _end)
> =20
>  /*
>   * Yield if the MMU lock is contended or this thread needs to return con=
trol
> @@ -945,7 +1032,7 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_=
mmu_page *sp)
> =20
>  	__tdp_mmu_set_spte(kvm, kvm_mmu_page_as_id(sp), sp->ptep, old_spte,
>  			   SHADOW_NONPRESENT_VALUE, sp->gfn, sp->role.level + 1,
> -			   true, true);
> +			   true, true, is_private_sp(sp));
> =20
>  	return true;
>  }
> @@ -961,13 +1048,21 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kv=
m_mmu_page *sp)
>   * operation can cause a soft lockup.
>   */
>  static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root=
,
> -			      gfn_t start, gfn_t end, bool can_yield, bool flush)
> +			      gfn_t start, gfn_t end, bool can_yield, bool flush,
> +			      bool drop_private)
>  {
>  	struct tdp_iter iter;
> =20
>  	end =3D min(end, tdp_mmu_max_gfn_exclusive());
> =20
>  	lockdep_assert_held_write(&kvm->mmu_lock);
> +	/*
> +	 * Extend [start, end) to include GFN shared bit when TDX is enabled,
> +	 * and for shared mapping range.
> +	 */
> +	WARN_ON_ONCE(!is_private_sp(root) && drop_private);
> +	start =3D kvm_gfn_for_root(kvm, root, start);
> +	end =3D kvm_gfn_for_root(kvm, root, end);

So for the GFN given to the iterator, it always doesn't have shared bit, ri=
ght?

> =20
>  	rcu_read_lock();
> =20
> @@ -1002,12 +1097,13 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, st=
ruct kvm_mmu_page *root,
>   * MMU lock.
>   */
>  bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start, gfn_=
t end,
> -			   bool can_yield, bool flush)
> +			   bool can_yield, bool flush, bool drop_private)
>  {
>  	struct kvm_mmu_page *root;
> =20
>  	for_each_tdp_mmu_root_yield_safe(kvm, root, as_id)
> -		flush =3D tdp_mmu_zap_leafs(kvm, root, start, end, can_yield, flush);
> +		flush =3D tdp_mmu_zap_leafs(kvm, root, start, end, can_yield, flush,
> +					  drop_private && is_private_sp(root));


	if (is_private_sp(root) && drop_private)
		continue;

	flush  =3D tdp_mmu_zap_leafs(kvm, root, start, end, can_yield, flush);

In this case, I guess you can remove 'is_private' in tdp_mmu_zap_leafs()?

> =20
>  	return flush;
>  }
> @@ -1067,6 +1163,12 @@ void kvm_tdp_mmu_invalidate_all_roots(struct kvm *=
kvm)
> =20
>  	lockdep_assert_held_write(&kvm->mmu_lock);
>  	list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link) {
> +		/*
> +		 * Skip private root since private page table
> +		 * is only torn down when VM is destroyed.
> +		 */
> +		if (is_private_sp(root))
> +			continue;
>  		if (!root->role.invalid &&
>  		    !WARN_ON_ONCE(!kvm_tdp_mmu_get_root(root))) {
>  			root->role.invalid =3D true;
> @@ -1087,14 +1189,22 @@ static int tdp_mmu_map_handle_target_level(struct=
 kvm_vcpu *vcpu,
>  	u64 new_spte;
>  	int ret =3D RET_PF_FIXED;
>  	bool wrprot =3D false;
> +	unsigned long pte_access =3D ACC_ALL;
> +	gfn_t gfn_unalias =3D iter->gfn & ~kvm_gfn_shared_mask(vcpu->kvm);

Here looks the iter->gfn still contains the shared bits.  It is not consist=
ent
with above.

Can you put some words into the changelog explaining exactly what GFN will =
you
put to iterator?

Or can you even split out this part as a separate patch?

> =20
>  	WARN_ON(sp->role.level !=3D fault->goal_level);
> +
> +	/* TDX shared GPAs are no executable, enforce this for the SDV. */
> +	if (kvm_gfn_shared_mask(vcpu->kvm) && !fault->is_private)
> +		pte_access &=3D ~ACC_EXEC_MASK;
> +
>  	if (unlikely(!fault->slot))
> -		new_spte =3D make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
> +		new_spte =3D make_mmio_spte(vcpu, gfn_unalias, pte_access);

This part belong to MMIO fault handing patch.

>  	else
> -		wrprot =3D make_spte(vcpu, sp, fault->slot, ACC_ALL, iter->gfn,
> -					 fault->pfn, iter->old_spte, fault->prefetch, true,
> -					 fault->map_writable, &new_spte);
> +		wrprot =3D make_spte(vcpu, sp, fault->slot, pte_access,
> +				   gfn_unalias, fault->pfn, iter->old_spte,
> +				   fault->prefetch, true, fault->map_writable,
> +				   &new_spte);
> =20
>  	if (new_spte =3D=3D iter->old_spte)
>  		ret =3D RET_PF_SPURIOUS;
> @@ -1167,8 +1277,7 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct =
tdp_iter *iter,
>  	return 0;
>  }
> =20
> -static int tdp_mmu_populate_nonleaf(
> -	struct kvm_vcpu *vcpu, struct tdp_iter *iter, bool account_nx)
> +static int tdp_mmu_populate_nonleaf(struct kvm_vcpu *vcpu, struct tdp_it=
er *iter, bool account_nx)
>  {
>  	struct kvm_mmu_page *sp;
>  	int ret;
> @@ -1176,7 +1285,7 @@ static int tdp_mmu_populate_nonleaf(
>  	WARN_ON(is_shadow_present_pte(iter->old_spte));
>  	WARN_ON(is_removed_spte(iter->old_spte));
> =20
> -	sp =3D tdp_mmu_alloc_sp(vcpu);
> +	sp =3D tdp_mmu_alloc_sp(vcpu, iter->is_private, false);
>  	tdp_mmu_init_child_sp(sp, iter);
> =20
>  	ret =3D tdp_mmu_link_sp(vcpu->kvm, iter, sp, account_nx, true);
> @@ -1193,6 +1302,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct k=
vm_page_fault *fault)
>  {
>  	struct kvm_mmu *mmu =3D vcpu->arch.mmu;
>  	struct tdp_iter iter;
> +	gfn_t raw_gfn;
> +	bool is_private =3D fault->is_private;
>  	int ret;
> =20
>  	kvm_mmu_hugepage_adjust(vcpu, fault);
> @@ -1201,7 +1312,16 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct =
kvm_page_fault *fault)
> =20
>  	rcu_read_lock();
> =20
> -	tdp_mmu_for_each_pte(iter, mmu, fault->gfn, fault->gfn + 1) {
> +	raw_gfn =3D gpa_to_gfn(fault->addr);
> +
> +	if (is_error_noslot_pfn(fault->pfn) || kvm_is_reserved_pfn(fault->pfn))=
 {
> +		if (is_private) {
> +			rcu_read_unlock();
> +			return -EFAULT;
> +		}
> +	}
> +
> +	tdp_mmu_for_each_pte(iter, mmu, is_private, raw_gfn, raw_gfn + 1) {
>  		if (fault->nx_huge_page_workaround_enabled)
>  			disallowed_hugepage_adjust(fault, iter.old_spte, iter.level);
> =20
> @@ -1217,6 +1337,12 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct =
kvm_page_fault *fault)
>  		    is_large_pte(iter.old_spte)) {
>  			if (tdp_mmu_zap_spte_atomic(vcpu->kvm, &iter))
>  				break;
> +			/*
> +			 * TODO: large page support.
> +			 * Doesn't support large page for TDX now
> +			 */
> +			WARN_ON(is_private_sptep(iter.sptep));
> +
> =20
>  			/*
>  			 * The iter must explicitly re-read the spte here
> @@ -1258,11 +1384,13 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct=
 kvm_page_fault *fault)
>  	return ret;
>  }
> =20
> +/* Used by mmu notifier via kvm_unmap_gfn_range() */
>  bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *=
range,
> -				 bool flush)
> +				 bool flush, bool drop_private)
>  {
>  	return kvm_tdp_mmu_zap_leafs(kvm, range->slot->as_id, range->start,
> -				     range->end, range->may_block, flush);
> +				     range->end, range->may_block, flush,
> +				     drop_private);
>  }
> =20
>  typedef bool (*tdp_handler_t)(struct kvm *kvm, struct tdp_iter *iter,
> @@ -1445,7 +1573,8 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
>  	return spte_set;
>  }
> =20
> -static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp)
> +static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(
> +	gfp_t gfp, bool is_private)
>  {
>  	struct kvm_mmu_page *sp;
> =20
> @@ -1456,6 +1585,12 @@ static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for=
_split(gfp_t gfp)
>  		return NULL;
> =20
>  	sp->spt =3D (void *)__get_free_page(gfp);
> +	if (is_private) {
> +		if (kvm_alloc_private_sp_for_split(sp, gfp)) {
> +			free_page((unsigned long)sp->spt);
> +			sp->spt =3D NULL;
> +		}
> +	}
>  	if (!sp->spt) {
>  		kmem_cache_free(mmu_page_header_cache, sp);
>  		return NULL;
> @@ -1469,6 +1604,11 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_s=
plit(struct kvm *kvm,
>  						       bool shared)
>  {
>  	struct kvm_mmu_page *sp;
> +	bool is_private =3D iter->is_private;
> +
> +	/* TODO: For now large page isn't supported for private SPTE. */
> +	WARN_ON(is_private);
> +	WARN_ON(iter->is_private !=3D is_private_sptep(iter->sptep));
> =20
>  	/*
>  	 * Since we are allocating while under the MMU lock we have to be
> @@ -1479,7 +1619,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_sp=
lit(struct kvm *kvm,
>  	 * If this allocation fails we drop the lock and retry with reclaim
>  	 * allowed.
>  	 */
> -	sp =3D __tdp_mmu_alloc_sp_for_split(GFP_NOWAIT | __GFP_ACCOUNT);
> +	sp =3D __tdp_mmu_alloc_sp_for_split(GFP_NOWAIT | __GFP_ACCOUNT, is_priv=
ate);
>  	if (sp)
>  		return sp;
> =20
> @@ -1491,7 +1631,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_sp=
lit(struct kvm *kvm,
>  		write_unlock(&kvm->mmu_lock);
> =20
>  	iter->yielded =3D true;
> -	sp =3D __tdp_mmu_alloc_sp_for_split(GFP_KERNEL_ACCOUNT);
> +	sp =3D __tdp_mmu_alloc_sp_for_split(GFP_KERNEL_ACCOUNT, is_private);
> =20
>  	if (shared)
>  		read_lock(&kvm->mmu_lock);
> @@ -1907,10 +2047,14 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u=
64 addr, u64 *sptes,
>  	struct kvm_mmu *mmu =3D vcpu->arch.mmu;
>  	gfn_t gfn =3D addr >> PAGE_SHIFT;
>  	int leaf =3D -1;
> +	bool is_private =3D kvm_is_private_gpa(vcpu->kvm, addr);
> =20
>  	*root_level =3D vcpu->arch.mmu->root_role.level;
> =20
> -	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
> +	if (WARN_ON(is_private))
> +		return leaf;
> +
> +	tdp_mmu_for_each_pte(iter, mmu, false, gfn, gfn + 1) {
>  		leaf =3D iter.level;
>  		sptes[leaf] =3D iter.old_spte;
>  	}
> @@ -1937,7 +2081,10 @@ u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm=
_vcpu *vcpu, u64 addr,
>  	gfn_t gfn =3D addr >> PAGE_SHIFT;
>  	tdp_ptep_t sptep =3D NULL;
> =20
> -	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
> +	/* fast page fault for private GPA isn't supported. */
> +	WARN_ON_ONCE(kvm_is_private_gpa(vcpu->kvm, addr));

Shouldn't this chunk belong to patch:

[PATCH v7 038/102] KVM: x86/mmu: Disallow fast page fault on private GPA

?

> +
> +	tdp_mmu_for_each_pte(iter, mmu, false, gfn, gfn + 1) {
>  		*spte =3D iter.old_spte;
>  		sptep =3D iter.sptep;
>  	}
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index c163f7cc23ca..d1655571eb2f 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -5,7 +5,7 @@
> =20
>  #include <linux/kvm_host.h>
> =20
> -hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
> +hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu, bool private)=
;
> =20
>  __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page=
 *root)
>  {
> @@ -16,7 +16,8 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_m=
mu_page *root,
>  			  bool shared);
> =20
>  bool kvm_tdp_mmu_zap_leafs(struct kvm *kvm, int as_id, gfn_t start,
> -				 gfn_t end, bool can_yield, bool flush);
> +				gfn_t end, bool can_yield, bool flush,
> +				bool drop_private);
>  bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp);
>  void kvm_tdp_mmu_zap_all(struct kvm *kvm);
>  void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm);
> @@ -25,7 +26,7 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)=
;
>  int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)=
;
> =20
>  bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *=
range,
> -				 bool flush);
> +				 bool flush, bool drop_private);
>  bool kvm_tdp_mmu_age_gfn_range(struct kvm *kvm, struct kvm_gfn_range *ra=
nge);
>  bool kvm_tdp_mmu_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *ran=
ge);
>  bool kvm_tdp_mmu_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *ran=
ge);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 0acb0b6d1f82..7a5261eb7eb8 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -196,6 +196,7 @@ bool kvm_is_reserved_pfn(kvm_pfn_t pfn)
> =20
>  	return true;
>  }
> +EXPORT_SYMBOL_GPL(kvm_is_reserved_pfn);
> =20
>  /*
>   * Switches to specified vcpu, until a matching vcpu_put()

