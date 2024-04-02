Return-Path: <kvm+bounces-13342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 09A80894B8A
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 08:37:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2BACC1C21AA5
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 06:37:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C5032BCE8;
	Tue,  2 Apr 2024 06:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S9xgGnPB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38918219FF;
	Tue,  2 Apr 2024 06:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712039864; cv=none; b=Jksu/BfLMf/YeFTUtjPOI2omxXFu7S6JuENhvl1+Y/u7DC98jNz86q9TptDKL0MTQ4GGYUp9Sr/GCtgo7hk0XRl34Z/s2A7hCcgHry9kuTZmqdrHQx/193VxYnKTtbEvzxoq3vHi15NvI0aWSue6O1XevNryr20E8ilz2zK9iGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712039864; c=relaxed/simple;
	bh=WGICcZtRDyKUPDDG9RTEoEfu6A++ShcvmxKaOD2dDr0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pAhUyE1e8Wk1i0SXC3SOrqxQLJrnC07UOsrC3XhibcnJwVnJbp2E1iElus66oG7GIE0CDWo/2Eih97SYRS521uU/6xAv/s+JfHiUKAKKwhiuoH0jAV5PYrnP8hqd0+JPPhIAjoDITvwpzQECcOGYeeBB2eknyo7MIQehwZ3vel8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S9xgGnPB; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712039859; x=1743575859;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=WGICcZtRDyKUPDDG9RTEoEfu6A++ShcvmxKaOD2dDr0=;
  b=S9xgGnPBpig3dt0CeAax3iElcVwdBk0ruG+wBFN8DKmFXW31jbiZ2EbL
   BW5HWw3HVcwm7ORYUFLxsUNMFE93iKhhf16aEzHF0hpoVQFMMFOnMh/3V
   p4Uz+8YghP+c7b4KAveNzKvMxnvH0E+duhlM5RQAdCravEmeK371KVlZa
   aIP5ayT5zIWRkHDVzVBqWQqCR7QzVB6Y6x+VAlSVBpWQ2PKnkyk8+utZV
   nxyaX0eFaPtfUGmT6iODc2fqdathyez+iNHH2aEa4dPL7sZjc/G4tnXbF
   V2C5Mr0R0Ddnm9ohONmna03F97ume8j2RiIFAg3GTZIMlgO3Q6RB3tUxy
   A==;
X-CSE-ConnectionGUID: nzEZCtZOR5+FLrWZQBe8iA==
X-CSE-MsgGUID: tocUPWIJT7ij612yOI5YeQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11031"; a="10975149"
X-IronPort-AV: E=Sophos;i="6.07,174,1708416000"; 
   d="scan'208";a="10975149"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2024 23:37:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,174,1708416000"; 
   d="scan'208";a="48962106"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2024 23:37:38 -0700
Date: Mon, 1 Apr 2024 23:37:37 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 062/130] KVM: x86/tdp_mmu: Support TDX private
 mapping for TDP MMU
Message-ID: <20240402063737.GX2444378@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <fc97847d04f2b469d8f4cfceee84c7ef055ab1ac.1708933498.git.isaku.yamahata@intel.com>
 <9ea80003-3167-45f0-8574-01c364eb33c7@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9ea80003-3167-45f0-8574-01c364eb33c7@linux.intel.com>

On Mon, Apr 01, 2024 at 05:12:38PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> 
> On 2/26/2024 4:26 PM, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Allocate protected page table for private page table, and add hooks to
> > operate on protected page table.  This patch adds allocation/free of
> > protected page tables and hooks.  When calling hooks to update SPTE entry,
> > freeze the entry, call hooks and unfreeze the entry to allow concurrent
> > updates on page tables.  Which is the advantage of TDP MMU.  As
> > kvm_gfn_shared_mask() returns false always, those hooks aren't called yet
> > with this patch.
> > 
> > When the faulting GPA is private, the KVM fault is called private.  When
> > resolving private KVM fault, allocate protected page table and call hooks
> > to operate on protected page table. On the change of the private PTE entry,
> > invoke kvm_x86_ops hook in __handle_changed_spte() to propagate the change
> > to protected page table. The following depicts the relationship.
> > 
> >    private KVM page fault   |
> >        |                    |
> >        V                    |
> >   private GPA               |     CPU protected EPTP
> >        |                    |           |
> >        V                    |           V
> >   private PT root           |     protected PT root
> >        |                    |           |
> >        V                    |           V
> >     private PT --hook to propagate-->protected PT
> >        |                    |           |
> >        \--------------------+------\    |
> >                             |      |    |
> >                             |      V    V
> >                             |    private guest page
> >                             |
> >                             |
> >       non-encrypted memory  |    encrypted memory
> >                             |
> > PT: page table
> > 
> > The existing KVM TDP MMU code uses atomic update of SPTE.  On populating
> > the EPT entry, atomically set the entry.  However, it requires TLB
> > shootdown to zap SPTE.  To address it, the entry is frozen with the special
> > SPTE value that clears the present bit. After the TLB shootdown, the entry
> > is set to the eventual value (unfreeze).
> > 
> > For protected page table, hooks are called to update protected page table
> > in addition to direct access to the private SPTE. For the zapping case, it
> > works to freeze the SPTE. It can call hooks in addition to TLB shootdown.
> > For populating the private SPTE entry, there can be a race condition
> > without further protection
> > 
> >    vcpu 1: populating 2M private SPTE
> >    vcpu 2: populating 4K private SPTE
> >    vcpu 2: TDX SEAMCALL to update 4K protected SPTE => error
> >    vcpu 1: TDX SEAMCALL to update 2M protected SPTE
> > 
> > To avoid the race, the frozen SPTE is utilized.  Instead of atomic update
> > of the private entry, freeze the entry, call the hook that update protected
> > SPTE, set the entry to the final value.
> > 
> > Support 4K page only at this stage.  2M page support can be done in future
> > patches.
> > 
> > Co-developed-by: Kai Huang <kai.huang@intel.com>
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > ---
> > v19:
> > - drop CONFIG_KVM_MMU_PRIVATE
> > 
> > v18:
> > - Rename freezed => frozen
> > 
> > v14 -> v15:
> > - Refined is_private condition check in kvm_tdp_mmu_map().
> >    Add kvm_gfn_shared_mask() check.
> > - catch up for struct kvm_range change
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >   arch/x86/include/asm/kvm-x86-ops.h |   5 +
> >   arch/x86/include/asm/kvm_host.h    |  11 ++
> >   arch/x86/kvm/mmu/mmu.c             |  17 +-
> >   arch/x86/kvm/mmu/mmu_internal.h    |  13 +-
> >   arch/x86/kvm/mmu/tdp_iter.h        |   2 +-
> >   arch/x86/kvm/mmu/tdp_mmu.c         | 308 +++++++++++++++++++++++++----
> >   arch/x86/kvm/mmu/tdp_mmu.h         |   2 +-
> >   virt/kvm/kvm_main.c                |   1 +
> >   8 files changed, 320 insertions(+), 39 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> > index a8e96804a252..e1c75f8c1b25 100644
> > --- a/arch/x86/include/asm/kvm-x86-ops.h
> > +++ b/arch/x86/include/asm/kvm-x86-ops.h
> > @@ -101,6 +101,11 @@ KVM_X86_OP_OPTIONAL_RET0(set_tss_addr)
> >   KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
> >   KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
> >   KVM_X86_OP(load_mmu_pgd)
> > +KVM_X86_OP_OPTIONAL(link_private_spt)
> > +KVM_X86_OP_OPTIONAL(free_private_spt)
> > +KVM_X86_OP_OPTIONAL(set_private_spte)
> > +KVM_X86_OP_OPTIONAL(remove_private_spte)
> > +KVM_X86_OP_OPTIONAL(zap_private_spte)
> >   KVM_X86_OP(has_wbinvd_exit)
> >   KVM_X86_OP(get_l2_tsc_offset)
> >   KVM_X86_OP(get_l2_tsc_multiplier)
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index efd3fda1c177..bc0767c884f7 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -468,6 +468,7 @@ struct kvm_mmu {
> >   	int (*sync_spte)(struct kvm_vcpu *vcpu,
> >   			 struct kvm_mmu_page *sp, int i);
> >   	struct kvm_mmu_root_info root;
> > +	hpa_t private_root_hpa;
> >   	union kvm_cpu_role cpu_role;
> >   	union kvm_mmu_page_role root_role;
> > @@ -1740,6 +1741,16 @@ struct kvm_x86_ops {
> >   	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
> >   			     int root_level);
> > +	int (*link_private_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> > +				void *private_spt);
> > +	int (*free_private_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> > +				void *private_spt);
> > +	int (*set_private_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> > +				 kvm_pfn_t pfn);
> > +	int (*remove_private_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> > +				    kvm_pfn_t pfn);
> > +	int (*zap_private_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level);
> > +
> >   	bool (*has_wbinvd_exit)(void);
> >   	u64 (*get_l2_tsc_offset)(struct kvm_vcpu *vcpu);
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 30c86e858ae4..0e0321ad9ca2 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -3717,7 +3717,12 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
> >   		goto out_unlock;
> >   	if (tdp_mmu_enabled) {
> > -		root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu);
> > +		if (kvm_gfn_shared_mask(vcpu->kvm) &&
> > +		    !VALID_PAGE(mmu->private_root_hpa)) {
> > +			root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu, true);
> > +			mmu->private_root_hpa = root;
> > +		}
> > +		root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu, false);
> >   		mmu->root.hpa = root;
> >   	} else if (shadow_root_level >= PT64_ROOT_4LEVEL) {
> >   		root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level);
> > @@ -4627,7 +4632,7 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >   	if (kvm_mmu_honors_guest_mtrrs(vcpu->kvm)) {
> >   		for ( ; fault->max_level > PG_LEVEL_4K; --fault->max_level) {
> >   			int page_num = KVM_PAGES_PER_HPAGE(fault->max_level);
> > -			gfn_t base = gfn_round_for_level(fault->gfn,
> > +			gfn_t base = gfn_round_for_level(gpa_to_gfn(fault->addr),
> >   							 fault->max_level);
> >   			if (kvm_mtrr_check_gfn_range_consistency(vcpu, base, page_num))
> > @@ -4662,6 +4667,7 @@ int kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
> >   	};
> >   	WARN_ON_ONCE(!vcpu->arch.mmu->root_role.direct);
> > +	fault.gfn = gpa_to_gfn(fault.addr) & ~kvm_gfn_shared_mask(vcpu->kvm);
> >   	fault.slot = kvm_vcpu_gfn_to_memslot(vcpu, fault.gfn);
> >   	r = mmu_topup_memory_caches(vcpu, false);
> > @@ -6166,6 +6172,7 @@ static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
> >   	mmu->root.hpa = INVALID_PAGE;
> >   	mmu->root.pgd = 0;
> > +	mmu->private_root_hpa = INVALID_PAGE;
> >   	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
> >   		mmu->prev_roots[i] = KVM_MMU_ROOT_INFO_INVALID;
> > @@ -7211,6 +7218,12 @@ int kvm_mmu_vendor_module_init(void)
> >   void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
> >   {
> >   	kvm_mmu_unload(vcpu);
> > +	if (tdp_mmu_enabled) {
> > +		write_lock(&vcpu->kvm->mmu_lock);
> > +		mmu_free_root_page(vcpu->kvm, &vcpu->arch.mmu->private_root_hpa,
> > +				NULL);
> > +		write_unlock(&vcpu->kvm->mmu_lock);
> > +	}
> >   	free_mmu_pages(&vcpu->arch.root_mmu);
> >   	free_mmu_pages(&vcpu->arch.guest_mmu);
> >   	mmu_free_memory_caches(vcpu);
> > diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> > index 002f3f80bf3b..9e2c7c6d85bf 100644
> > --- a/arch/x86/kvm/mmu/mmu_internal.h
> > +++ b/arch/x86/kvm/mmu/mmu_internal.h
> > @@ -6,6 +6,8 @@
> >   #include <linux/kvm_host.h>
> >   #include <asm/kvm_host.h>
> > +#include "mmu.h"
> > +
> >   #ifdef CONFIG_KVM_PROVE_MMU
> >   #define KVM_MMU_WARN_ON(x) WARN_ON_ONCE(x)
> >   #else
> > @@ -205,6 +207,15 @@ static inline void kvm_mmu_free_private_spt(struct kvm_mmu_page *sp)
> >   		free_page((unsigned long)sp->private_spt);
> >   }
> > +static inline gfn_t kvm_gfn_for_root(struct kvm *kvm, struct kvm_mmu_page *root,
> > +				     gfn_t gfn)
> > +{
> > +	if (is_private_sp(root))
> > +		return kvm_gfn_to_private(kvm, gfn);
> 
> IIUC, the purpose of this function is to add back shared bit to gfn for
> shared memory.
> For private address, the gfn should not contain shared bit anyway.
> It seems weird to clear the shared bit from gfn for private address.

The current caller happens to do so.  With such assumption, we can code it as
something like

if (is_private_sp(root)) {
    WARN_ON_ONCE(gfn & kvm_gfn_shared_mask(kvm));
    return gfn;
}


... snip ...

> > @@ -376,12 +387,78 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
> >   							  REMOVED_SPTE, level);
> >   		}
> >   		handle_changed_spte(kvm, kvm_mmu_page_as_id(sp), gfn,
> > -				    old_spte, REMOVED_SPTE, level, shared);
> > +				    old_spte, REMOVED_SPTE, sp->role,
> > +				    shared);
> > +	}
> > +
> > +	if (is_private_sp(sp) &&
> > +	    WARN_ON(static_call(kvm_x86_free_private_spt)(kvm, sp->gfn, sp->role.level,
> > +							  kvm_mmu_private_spt(sp)))) {
> > +		/*
> > +		 * Failed to unlink Secure EPT page and there is nothing to do
> > +		 * further.  Intentionally leak the page to prevent the kernel
> > +		 * from accessing the encrypted page.
> > +		 */
> > +		kvm_mmu_init_private_spt(sp, NULL);
> >   	}
> >   	call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
> >   }
> > +static void *get_private_spt(gfn_t gfn, u64 new_spte, int level)
> > +{
> > +	if (is_shadow_present_pte(new_spte) && !is_last_spte(new_spte, level)) {
> > +		struct kvm_mmu_page *sp = to_shadow_page(pfn_to_hpa(spte_to_pfn(new_spte)));
> > +		void *private_spt = kvm_mmu_private_spt(sp);
> > +
> > +		WARN_ON_ONCE(!private_spt);
> > +		WARN_ON_ONCE(sp->role.level + 1 != level);
> > +		WARN_ON_ONCE(sp->gfn != gfn);
> > +		return private_spt;
> > +	}
> > +
> > +	return NULL;
> > +}
> > +
> > +static void handle_removed_private_spte(struct kvm *kvm, gfn_t gfn,
> > +					u64 old_spte, u64 new_spte,
> > +					int level)
> > +{
> > +	bool was_present = is_shadow_present_pte(old_spte);
> > +	bool is_present = is_shadow_present_pte(new_spte);
> > +	bool was_leaf = was_present && is_last_spte(old_spte, level);
> > +	bool is_leaf = is_present && is_last_spte(new_spte, level);
> > +	kvm_pfn_t old_pfn = spte_to_pfn(old_spte);
> > +	kvm_pfn_t new_pfn = spte_to_pfn(new_spte);
> > +	int ret;
> > +
> > +	/* Ignore change of software only bits. e.g. host_writable */
> > +	if (was_leaf == is_leaf && was_present == is_present)
> > +		return;
> > +
> > +	/*
> > +	 * Allow only leaf page to be zapped.  Reclaim Non-leaf page tables at
> > +	 * destroying VM.
> > +	 */
> 
> The comment seems just for !was_leaf,
> move the comment just before "if (!was_leaf)" ?

Makes sense. 


> > +	WARN_ON_ONCE(is_present);
> 
> Is this warning needed?
> It can be captured by the later "KVM_BUG_ON(new_pfn, kvm)"

Yes, let's remove this warn_on.


... snip ...

> > @@ -597,8 +775,17 @@ static u64 tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
> >   	WARN_ON_ONCE(is_removed_spte(old_spte) || is_removed_spte(new_spte));
> >   	old_spte = kvm_tdp_mmu_write_spte(sptep, old_spte, new_spte, level);
> > +	if (is_private_sptep(sptep) && !is_removed_spte(new_spte) &&
> > +	    is_shadow_present_pte(new_spte)) {
> > +		lockdep_assert_held_write(&kvm->mmu_lock);
> 
> tdp_mmu_set_spte() has already called lockdep_assert_held_write() above.

Ok.


> > @@ -1041,6 +1255,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >   	struct kvm *kvm = vcpu->kvm;
> >   	struct tdp_iter iter;
> >   	struct kvm_mmu_page *sp;
> > +	gfn_t raw_gfn;
> > +	bool is_private = fault->is_private && kvm_gfn_shared_mask(kvm);
> >   	int ret = RET_PF_RETRY;
> >   	kvm_mmu_hugepage_adjust(vcpu, fault);
> > @@ -1049,7 +1265,17 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >   	rcu_read_lock();
> > -	tdp_mmu_for_each_pte(iter, mmu, fault->gfn, fault->gfn + 1) {
> > +	raw_gfn = gpa_to_gfn(fault->addr);
> > +
> > +	if (is_error_noslot_pfn(fault->pfn) ||
> > +	    !kvm_pfn_to_refcounted_page(fault->pfn)) {
> > +		if (is_private) {
> 
>  Why this is only checked for private fault?

Because (the current implementation of) the TDX vendor backend gets page
reference count.  In future, it should be removed with allowing page migration.



> > +			rcu_read_unlock();
> > +			return -EFAULT;
> > +		}
> > +	}
> > +
> > +	tdp_mmu_for_each_pte(iter, mmu, is_private, raw_gfn, raw_gfn + 1) {
> >   		int r;
> >   		if (fault->nx_huge_page_workaround_enabled)
> > @@ -1079,9 +1305,14 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >   		sp->nx_huge_page_disallowed = fault->huge_page_disallowed;
> > -		if (is_shadow_present_pte(iter.old_spte))
> > +		if (is_shadow_present_pte(iter.old_spte)) {
> > +			/*
> > +			 * TODO: large page support.
> > +			 * Doesn't support large page for TDX now
> > +			 */
> > +			KVM_BUG_ON(is_private_sptep(iter.sptep), vcpu->kvm);
> >   			r = tdp_mmu_split_huge_page(kvm, &iter, sp, true);
> > -		else
> > +		} else
> >   			r = tdp_mmu_link_sp(kvm, &iter, sp, true);
> >   		/*
> > @@ -1362,6 +1593,8 @@ static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp, union kvm_mm
> >   	sp->role = role;
> >   	sp->spt = (void *)__get_free_page(gfp);
> > +	/* TODO: large page support for private GPA. */
> > +	WARN_ON_ONCE(kvm_mmu_page_role_is_private(role));
> 
> Seems not needed, since __tdp_mmu_alloc_sp_for_split()
> is only called in  tdp_mmu_alloc_sp_for_split() and it has
> KVM_BUG_ON() for large page case.

Ah, yes.  Will remove one of two.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

