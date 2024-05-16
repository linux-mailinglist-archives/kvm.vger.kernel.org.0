Return-Path: <kvm+bounces-17505-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 875228C701A
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 03:48:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C87D283026
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 01:48:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A1DB1C2D;
	Thu, 16 May 2024 01:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mS3Kkxog"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58831366;
	Thu, 16 May 2024 01:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715824087; cv=none; b=AzMUjtqNCkSOIbXLgeNX80gEABsDl5Y9n8wY/DVRMBaOxu8+Tbq9HltObMkxKUCOCAu5Is8U5b3ZogHl9KfUTlC43+E2Mn9r3damPo5K6mfdldu0MCzTl1Aht2CiYBi23XUPP84ybgERfiMsWNzXBWJgNNAmp/n+wH2YihyyYjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715824087; c=relaxed/simple;
	bh=8A1Ua9ge6R3SVCKSWE8Awr7EzSeDB0C7jXXzTDFwAt4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g4jeBl0YAfVvuxPI2wlztktyVd/o5+7Nwi0KaJJICThpFZOBWmtmi4EafqSrmvWSx1Ivle+TyzIbw7E1oPObRQMgRz48bYRMBwK3dn4eJ9lKevHzIJSBFQaNmnj0FdlN8fRaklpKiTHIK26HRLuemRtnNLZYKASYHXb0R65VJ7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mS3Kkxog; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715824085; x=1747360085;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8A1Ua9ge6R3SVCKSWE8Awr7EzSeDB0C7jXXzTDFwAt4=;
  b=mS3KkxogmPyRAFZF7zdm4PixON7kx4V6Ep1r65K0JhJ6HJbLanuS9VWE
   CWZYPSTDLWey49rbtRO7JFA0A/8XAft7cyOAIV0IKJL0rn3bP8+LefMDb
   CYcV7IMoNWpfzezXMB2OZ2kKZZwx+N/zr0W86Y/HiyxHQBqHkeT2Pm5Mn
   B1i9Rusp4Ang0m5Hpf5gIR1jkML09VqeqKj9/c6fvWSKkbc5MfqNwhaSl
   SKEM9RhLqxFtpwtOXCYy0I0glT3T+pcnY4YkYIl0oUsRyh0aohUu9byho
   +KO1UX69eHcpAC6m+ghsxdmyABCl6y76+YKZIUaqTPfb8dN6wUPvCdrmM
   w==;
X-CSE-ConnectionGUID: jBwJRUS2SU2GV/ZSqHqp0Q==
X-CSE-MsgGUID: tVqH38T4QUqkCX/Gb+sYdg==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="23311085"
X-IronPort-AV: E=Sophos;i="6.08,163,1712646000"; 
   d="scan'208";a="23311085"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 18:48:04 -0700
X-CSE-ConnectionGUID: x5I4tR1rRdC6B08P2xHAkg==
X-CSE-MsgGUID: 3ndJShgFROeZmms0CVpuXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,163,1712646000"; 
   d="scan'208";a="31190389"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 18:48:04 -0700
Date: Wed, 15 May 2024 18:48:03 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, pbonzini@redhat.com,
	seanjc@google.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	erdemaktas@google.com, sagis@google.com, yan.y.zhao@intel.com,
	dmatlack@google.com
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Message-ID: <20240516014803.GI168153@ls.amr.corp.intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-11-rick.p.edgecombe@intel.com>
 <12afae41-906c-4bb7-956a-d73734c68010@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <12afae41-906c-4bb7-956a-d73734c68010@intel.com>

On Thu, May 16, 2024 at 12:52:32PM +1200,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On 15/05/2024 12:59 pm, Rick Edgecombe wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Allocate mirrored page table for the private page table and implement MMU
> > hooks to operate on the private page table.
> > 
> > To handle page fault to a private GPA, KVM walks the mirrored page table in
> > unencrypted memory and then uses MMU hooks in kvm_x86_ops to propagate
> > changes from the mirrored page table to private page table.
> > 
> >    private KVM page fault   |
> >        |                    |
> >        V                    |
> >   private GPA               |     CPU protected EPTP
> >        |                    |           |
> >        V                    |           V
> >   mirrored PT root          |     private PT root
> >        |                    |           |
> >        V                    |           V
> >     mirrored PT --hook to propagate-->private PT
> >        |                    |           |
> >        \--------------------+------\    |
> >                             |      |    |
> >                             |      V    V
> >                             |    private guest page
> >                             |
> >                             |
> >       non-encrypted memory  |    encrypted memory
> >                             |
> > 
> > PT:         page table
> > Private PT: the CPU uses it, but it is invisible to KVM. TDX module manages
> >              this table to map private guest pages.
> > Mirrored PT:It is visible to KVM, but the CPU doesn't use it. KVM uses it
> >              to propagate PT change to the actual private PT.
> > 
> > SPTEs in mirrored page table (refer to them as mirrored SPTEs hereafter)
> > can be modified atomically with mmu_lock held for read, however, the MMU
> > hooks to private page table are not atomical operations.
> > 
> > To address it, a special REMOVED_SPTE is introduced and below sequence is
> > used when mirrored SPTEs are updated atomically.
> > 
> > 1. Mirrored SPTE is first atomically written to REMOVED_SPTE.
> > 2. The successful updater of the mirrored SPTE in step 1 proceeds with the
> >     following steps.
> > 3. Invoke MMU hooks to modify private page table with the target value.
> > 4. (a) On hook succeeds, update mirrored SPTE to target value.
> >     (b) On hook failure, restore mirrored SPTE to original value.
> > 
> > KVM TDP MMU ensures other threads will not overrite REMOVED_SPTE.
> > 
> > This sequence also applies when SPTEs are atomiclly updated from
> > non-present to present in order to prevent potential conflicts when
> > multiple vCPUs attempt to set private SPTEs to a different page size
> > simultaneously, though 4K page size is only supported for private page
> > table currently.
> > 
> > 2M page support can be done in future patches.
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > Co-developed-by: Kai Huang <kai.huang@intel.com>
> > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> > Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> > ---
> > TDX MMU Part 1:
> >   - Remove unnecessary gfn, access twist in
> >     tdp_mmu_map_handle_target_level(). (Chao Gao)
> >   - Open code call to kvm_mmu_alloc_private_spt() instead oCf doing it in
> >     tdp_mmu_alloc_sp()
> >   - Update comment in set_private_spte_present() (Yan)
> >   - Open code call to kvm_mmu_init_private_spt() (Yan)
> >   - Add comments on TDX MMU hooks (Yan)
> >   - Fix various whitespace alignment (Yan)
> >   - Remove pointless warnings and conditionals in
> >     handle_removed_private_spte() (Yan)
> >   - Remove redundant lockdep assert in tdp_mmu_set_spte() (Yan)
> >   - Remove incorrect comment in handle_changed_spte() (Yan)
> >   - Remove unneeded kvm_pfn_to_refcounted_page() and
> >     is_error_noslot_pfn() check in kvm_tdp_mmu_map() (Yan)
> >   - Do kvm_gfn_for_root() branchless (Rick)
> >   - Update kvm_tdp_mmu_alloc_root() callers to not check error code (Rick)
> >   - Add comment for stripping shared bit for fault.gfn (Chao)
> > 
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
> > ---
> >   arch/x86/include/asm/kvm-x86-ops.h |   5 +
> >   arch/x86/include/asm/kvm_host.h    |  25 +++
> >   arch/x86/kvm/mmu/mmu.c             |  13 +-
> >   arch/x86/kvm/mmu/mmu_internal.h    |  19 +-
> >   arch/x86/kvm/mmu/tdp_iter.h        |   2 +-
> >   arch/x86/kvm/mmu/tdp_mmu.c         | 269 +++++++++++++++++++++++++----
> >   arch/x86/kvm/mmu/tdp_mmu.h         |   2 +-
> >   7 files changed, 293 insertions(+), 42 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> > index 566d19b02483..d13cb4b8fce6 100644
> > --- a/arch/x86/include/asm/kvm-x86-ops.h
> > +++ b/arch/x86/include/asm/kvm-x86-ops.h
> > @@ -95,6 +95,11 @@ KVM_X86_OP_OPTIONAL_RET0(set_tss_addr)
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
> > index d010ca5c7f44..20fa8fa58692 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -470,6 +470,7 @@ struct kvm_mmu {
> >   	int (*sync_spte)(struct kvm_vcpu *vcpu,
> >   			 struct kvm_mmu_page *sp, int i);
> >   	struct kvm_mmu_root_info root;
> > +	hpa_t private_root_hpa;
> 
> Should we have
> 
> 	struct kvm_mmu_root_info private_root;
> 
> instead?

Yes. And the private root allocation can be pushed down into TDP MMU.


> >   	union kvm_cpu_role cpu_role;
> >   	union kvm_mmu_page_role root_role;
> > @@ -1747,6 +1748,30 @@ struct kvm_x86_ops {
> >   	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
> >   			     int root_level);
> > +	/* Add a page as page table page into private page table */
> > +	int (*link_private_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> > +				void *private_spt);
> > +	/*
> > +	 * Free a page table page of private page table.
> > +	 * Only expected to be called when guest is not active, specifically
> > +	 * during VM destruction phase.
> > +	 */
> > +	int (*free_private_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> > +				void *private_spt);
> > +
> > +	/* Add a guest private page into private page table */
> > +	int (*set_private_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> > +				kvm_pfn_t pfn);
> > +
> > +	/* Remove a guest private page from private page table*/
> > +	int (*remove_private_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> > +				   kvm_pfn_t pfn);
> > +	/*
> > +	 * Keep a guest private page mapped in private page table, but clear its
> > +	 * present bit
> > +	 */
> > +	int (*zap_private_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level);
> > +
> >   	bool (*has_wbinvd_exit)(void);
> >   	u64 (*get_l2_tsc_offset)(struct kvm_vcpu *vcpu);
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 76f92cb37a96..2506d6277818 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -3701,7 +3701,9 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
> >   	int r;
> >   	if (tdp_mmu_enabled) {
> > -		kvm_tdp_mmu_alloc_root(vcpu);
> > +		if (kvm_gfn_shared_mask(vcpu->kvm))
> > +			kvm_tdp_mmu_alloc_root(vcpu, true);
> 
> As mentioned in replies to other patches, I kinda prefer
> 
> 	kvm->arch.has_mirrored_pt (or has_mirrored_private_pt)
> 
> Or we have a helper
> 
> 	kvm_has_mirrored_pt() / kvm_has_mirrored_private_pt()
> 
> > +		kvm_tdp_mmu_alloc_root(vcpu, false);
> >   		return 0;
> >   	}
> > @@ -4685,7 +4687,7 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >   	if (kvm_mmu_honors_guest_mtrrs(vcpu->kvm)) {
> >   		for ( ; fault->max_level > PG_LEVEL_4K; --fault->max_level) {
> >   			int page_num = KVM_PAGES_PER_HPAGE(fault->max_level);
> > -			gfn_t base = gfn_round_for_level(fault->gfn,
> > +			gfn_t base = gfn_round_for_level(gpa_to_gfn(fault->addr),
> >   							 fault->max_level);
> 
> I thought by reaching here the shared bit has already been stripped away by
> the caller?
> 
> It doesn't make a lot sense to still have it here, given we have a universal
> KVM-defined PFERR_PRIVATE_ACCESS flag:
> 
> https://lore.kernel.org/kvm/20240507155817.3951344-2-pbonzini@redhat.com/T/#mb30987f31b431771b42dfa64dcaa2efbc10ada5e
> 
> IMHO we should just strip the shared bit in the TDX variant of
> handle_ept_violation(), and pass the PFERR_PRIVATE_ACCESS (when GPA doesn't
> hvae shared bit) to the common fault handler so it can correctly set
> fault->is_private to true.

Yes, this part should be dropped.  Because we will have vCPUID.MTRR=0 for TDX in
long term, we can make kvm_mmu_honors_guest_mtrrs() always false.  Maybe
kvm->arch.disbled_mtrr or guest_cpuid_has(vcpu, X86_FEATURE_MTRR) = false.  We
will enforce vcpu.CPUID.MTRR=false.

Guest MTRR=0 support can be independently addressed.


> >   			if (kvm_mtrr_check_gfn_range_consistency(vcpu, base, page_num))
> > @@ -6245,6 +6247,7 @@ static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
> >   	mmu->root.hpa = INVALID_PAGE;
> >   	mmu->root.pgd = 0;
> > +	mmu->private_root_hpa = INVALID_PAGE;
> >   	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
> >   		mmu->prev_roots[i] = KVM_MMU_ROOT_INFO_INVALID;
> > @@ -7263,6 +7266,12 @@ int kvm_mmu_vendor_module_init(void)
> >   void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
> >   {
> >   	kvm_mmu_unload(vcpu);
> > +	if (tdp_mmu_enabled) {
> > +		read_lock(&vcpu->kvm->mmu_lock);
> > +		mmu_free_root_page(vcpu->kvm, &vcpu->arch.mmu->private_root_hpa,
> > +				   NULL);
> > +		read_unlock(&vcpu->kvm->mmu_lock);
> > +	}
> 
> Hmm.. I don't quite like this, but sorry I kinda forgot why we need to to
> this here.
> 
> Could you elaborate?
> 
> Anyway, from common code's perspective, we need to have some clarification
> why we design to do it here.

This should be cleaned up.  It can be pushed down into kvm_tdp_mmu_alloc_root().

void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu)
  allocate shared root
  if (has_mirrort_pt)
    allocate private root


> >   	free_mmu_pages(&vcpu->arch.root_mmu);
> >   	free_mmu_pages(&vcpu->arch.guest_mmu);
> >   	mmu_free_memory_caches(vcpu);
> > diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> > index 0f1a9d733d9e..3a7fe9261e23 100644
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
> > @@ -178,6 +180,16 @@ static inline void kvm_mmu_alloc_private_spt(struct kvm_vcpu *vcpu, struct kvm_m
> >   	sp->private_spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_private_spt_cache);
> >   }
> > +static inline gfn_t kvm_gfn_for_root(struct kvm *kvm, struct kvm_mmu_page *root,
> > +				     gfn_t gfn)
> > +{
> > +	gfn_t gfn_for_root = kvm_gfn_to_private(kvm, gfn);
> > +
> > +	/* Set shared bit if not private */
> > +	gfn_for_root |= -(gfn_t)!is_private_sp(root) & kvm_gfn_shared_mask(kvm);
> > +	return gfn_for_root;
> > +}
> > +
> >   static inline bool kvm_mmu_page_ad_need_write_protect(struct kvm_mmu_page *sp)
> >   {
> >   	/*
> > @@ -348,7 +360,12 @@ static inline int __kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gp
> >   	int r;
> >   	if (vcpu->arch.mmu->root_role.direct) {
> > -		fault.gfn = fault.addr >> PAGE_SHIFT;
> > +		/*
> > +		 * Things like memslots don't understand the concept of a shared
> > +		 * bit. Strip it so that the GFN can be used like normal, and the
> > +		 * fault.addr can be used when the shared bit is needed.
> > +		 */
> > +		fault.gfn = gpa_to_gfn(fault.addr) & ~kvm_gfn_shared_mask(vcpu->kvm);
> >   		fault.slot = kvm_vcpu_gfn_to_memslot(vcpu, fault.gfn);
> 
> Again, I don't think it's nessary for fault.gfn to still have the shared bit
> here?
> 
> This kinda usage is pretty much the reason I want to get rid of
> kvm_gfn_shared_mask().

We are going to flags like has_mirrored_pt and we have root page table iterator
with types specified.  I'll investigate how we can reduce (or eliminate)
those helper functions.


> >   	}
> > diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
> > index fae559559a80..8a64bcef9deb 100644
> > --- a/arch/x86/kvm/mmu/tdp_iter.h
> > +++ b/arch/x86/kvm/mmu/tdp_iter.h
> > @@ -91,7 +91,7 @@ struct tdp_iter {
> >   	tdp_ptep_t pt_path[PT64_ROOT_MAX_LEVEL];
> >   	/* A pointer to the current SPTE */
> >   	tdp_ptep_t sptep;
> > -	/* The lowest GFN mapped by the current SPTE */
> > +	/* The lowest GFN (shared bits included) mapped by the current SPTE */
> >   	gfn_t gfn;
> 
> IMHO we need more clarification of this design.
> 
> We at least needs to call out the TDX hardware uses the 'GFA + shared bit'
> when it walks the page table for shared mappings, so we must set up the
> mapping at the GPA with the shared bit.
> 
> E.g, because TDX hardware uses separate root for shared/private mappings, I
> think it's a resonable opion for the TDX hardware to just use the actual GPA
> w/o shared bit when it walks the shared page table, and still report EPT
> violation with GPA with shared bit set.
> 
> Such HW implementation is completely hidden from software, thus should be
> clarified in the changelog/comments.

Totally agree that it deserves for documentation.  I would update the design
document of TDX TDP MMU to include it.  This patch series doesn't include it,
though.


> >   	/* The level of the root page given to the iterator */
> >   	int root_level;
> 
> [...]
> 
> >   	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_4K, start, end) {
> > @@ -1029,8 +1209,8 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
> >   		new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
> >   	else
> >   		wrprot = make_spte(vcpu, sp, fault->slot, ACC_ALL, iter->gfn,
> > -					 fault->pfn, iter->old_spte, fault->prefetch, true,
> > -					 fault->map_writable, &new_spte);
> > +					fault->pfn, iter->old_spte, fault->prefetch, true,
> > +					fault->map_writable, &new_spte);
> >   	if (new_spte == iter->old_spte)
> >   		ret = RET_PF_SPURIOUS;
> > @@ -1108,6 +1288,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >   	struct kvm *kvm = vcpu->kvm;
> >   	struct tdp_iter iter;
> >   	struct kvm_mmu_page *sp;
> > +	gfn_t raw_gfn;
> > +	bool is_private = fault->is_private && kvm_gfn_shared_mask(kvm);
> 
> Ditto.  I wish we can have 'has_mirrored_private_pt'.

Which name do you prefer? has_mirrored_pt or has_mirrored_private_pt?
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

