Return-Path: <kvm+bounces-17546-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 487C68C7ADE
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 19:10:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 90EB9B2295E
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 17:10:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEB9014C599;
	Thu, 16 May 2024 17:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oDB3JMBy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2A14A3D;
	Thu, 16 May 2024 17:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715879422; cv=none; b=kISsa4hVQAjwVDJ8FEKv8yri5OHQOdkji8PUB0dQy76nkqpkEeNmxYgV6m7Eg8P3tSncLyvAYLAoKZGz75qV4kuUpCMBhwnWI9IBzKcciQcaTYErXJ9F4RdjUb7k8M8uGOtYzQMzd6+305HDeZJ8Z4QgpAXErZf7OX1a+tPLqZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715879422; c=relaxed/simple;
	bh=TAT+y1/BqZGIR7Oo7l+zHf0qfJhDwWUX9v1gQYraqC4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X4JDcnc4y101vZ2TYurcYNb0zqLwiM3MHFlpLAux+FaeRPM0fZ4b8GF2NmoAFRld490Sn54CpjYUazHE4EoZhJYMOrmyZnKprnJyCOYflHustOfkxSJhVIclT5lA+/u3Sa25fGqqlHDfUtqSpc5biDvsCKWciGag8O+Quv+iIEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oDB3JMBy; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715879420; x=1747415420;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=TAT+y1/BqZGIR7Oo7l+zHf0qfJhDwWUX9v1gQYraqC4=;
  b=oDB3JMBygZPQj5ogSHwh7H+iwiX2vP89AkpI9B41/0BWYhS4V/VmUxn/
   hO2EA4GLq5vb037LoJlf+pGEzUnx4re/ehORtm2FLYb1TCe/Ybh4moHki
   5Q1kul4FmcLTZQaMeEE58OFb4eKYOjf51XoOg/TsDsh1puzwZbAUZ4UBP
   ePT4Q9nPxTopibnomERm9kHvGnfT73UxOCed1+BYwyjfSw/+IxGp+l5tw
   30XM3K7/jc/43owy3toL4ZIQ+aLO4ykCgFCqBzzWX1kaLPI8yLgO6g2vi
   mWfW/SStspQ85hS4OKMqgR1PK7jXXlmD0eQShAplFrchOLUwqbuJRQhuy
   A==;
X-CSE-ConnectionGUID: +gfFYKsmRcqTbZ5oAY0bHg==
X-CSE-MsgGUID: IKHNVaphS1yTN4AdzzIKHw==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="11857055"
X-IronPort-AV: E=Sophos;i="6.08,165,1712646000"; 
   d="scan'208";a="11857055"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2024 10:10:19 -0700
X-CSE-ConnectionGUID: Fabwq6ZWQvqPLWCxuhul6Q==
X-CSE-MsgGUID: y1HOFSGsS5CQ5BGOZjnVJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,165,1712646000"; 
   d="scan'208";a="31432086"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2024 10:10:19 -0700
Date: Thu, 16 May 2024 10:10:18 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Huang, Kai" <kai.huang@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"dmatlack@google.com" <dmatlack@google.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Message-ID: <20240516171018.GJ168153@ls.amr.corp.intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-11-rick.p.edgecombe@intel.com>
 <12afae41-906c-4bb7-956a-d73734c68010@intel.com>
 <20240516014803.GI168153@ls.amr.corp.intel.com>
 <c8fe14f6c3b4a7330c3dc26f82c679334cf70994.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c8fe14f6c3b4a7330c3dc26f82c679334cf70994.camel@intel.com>

On Thu, May 16, 2024 at 02:00:32AM +0000,
"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:

> On Wed, 2024-05-15 at 18:48 -0700, Isaku Yamahata wrote:
> > On Thu, May 16, 2024 at 12:52:32PM +1200,
> > "Huang, Kai" <kai.huang@intel.com> wrote:
> > 
> > > On 15/05/2024 12:59 pm, Rick Edgecombe wrote:
> > > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > > 
> > > > Allocate mirrored page table for the private page table and implement MMU
> > > > hooks to operate on the private page table.
> > > > 
> > > > To handle page fault to a private GPA, KVM walks the mirrored page table
> > > > in
> > > > unencrypted memory and then uses MMU hooks in kvm_x86_ops to propagate
> > > > changes from the mirrored page table to private page table.
> > > > 
> > > >    private KVM page fault   |
> > > >        |                    |
> > > >        V                    |
> > > >   private GPA               |     CPU protected EPTP
> > > >        |                    |           |
> > > >        V                    |           V
> > > >   mirrored PT root          |     private PT root
> > > >        |                    |           |
> > > >        V                    |           V
> > > >     mirrored PT --hook to propagate-->private PT
> > > >        |                    |           |
> > > >        \--------------------+------\    |
> > > >                             |      |    |
> > > >                             |      V    V
> > > >                             |    private guest page
> > > >                             |
> > > >                             |
> > > >       non-encrypted memory  |    encrypted memory
> > > >                             |
> > > > 
> > > > PT:         page table
> > > > Private PT: the CPU uses it, but it is invisible to KVM. TDX module
> > > > manages
> > > >              this table to map private guest pages.
> > > > Mirrored PT:It is visible to KVM, but the CPU doesn't use it. KVM uses it
> > > >              to propagate PT change to the actual private PT.
> > > > 
> > > > SPTEs in mirrored page table (refer to them as mirrored SPTEs hereafter)
> > > > can be modified atomically with mmu_lock held for read, however, the MMU
> > > > hooks to private page table are not atomical operations.
> > > > 
> > > > To address it, a special REMOVED_SPTE is introduced and below sequence is
> > > > used when mirrored SPTEs are updated atomically.
> > > > 
> > > > 1. Mirrored SPTE is first atomically written to REMOVED_SPTE.
> > > > 2. The successful updater of the mirrored SPTE in step 1 proceeds with the
> > > >     following steps.
> > > > 3. Invoke MMU hooks to modify private page table with the target value.
> > > > 4. (a) On hook succeeds, update mirrored SPTE to target value.
> > > >     (b) On hook failure, restore mirrored SPTE to original value.
> > > > 
> > > > KVM TDP MMU ensures other threads will not overrite REMOVED_SPTE.
> > > > 
> > > > This sequence also applies when SPTEs are atomiclly updated from
> > > > non-present to present in order to prevent potential conflicts when
> > > > multiple vCPUs attempt to set private SPTEs to a different page size
> > > > simultaneously, though 4K page size is only supported for private page
> > > > table currently.
> > > > 
> > > > 2M page support can be done in future patches.
> > > > 
> > > > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > > > Co-developed-by: Kai Huang <kai.huang@intel.com>
> > > > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > > > Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
> > > > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > > > Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> > > > Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> > > > ---
> > > > TDX MMU Part 1:
> > > >   - Remove unnecessary gfn, access twist in
> > > >     tdp_mmu_map_handle_target_level(). (Chao Gao)
> > > >   - Open code call to kvm_mmu_alloc_private_spt() instead oCf doing it in
> > > >     tdp_mmu_alloc_sp()
> > > >   - Update comment in set_private_spte_present() (Yan)
> > > >   - Open code call to kvm_mmu_init_private_spt() (Yan)
> > > >   - Add comments on TDX MMU hooks (Yan)
> > > >   - Fix various whitespace alignment (Yan)
> > > >   - Remove pointless warnings and conditionals in
> > > >     handle_removed_private_spte() (Yan)
> > > >   - Remove redundant lockdep assert in tdp_mmu_set_spte() (Yan)
> > > >   - Remove incorrect comment in handle_changed_spte() (Yan)
> > > >   - Remove unneeded kvm_pfn_to_refcounted_page() and
> > > >     is_error_noslot_pfn() check in kvm_tdp_mmu_map() (Yan)
> > > >   - Do kvm_gfn_for_root() branchless (Rick)
> > > >   - Update kvm_tdp_mmu_alloc_root() callers to not check error code (Rick)
> > > >   - Add comment for stripping shared bit for fault.gfn (Chao)
> > > > 
> > > > v19:
> > > > - drop CONFIG_KVM_MMU_PRIVATE
> > > > 
> > > > v18:
> > > > - Rename freezed => frozen
> > > > 
> > > > v14 -> v15:
> > > > - Refined is_private condition check in kvm_tdp_mmu_map().
> > > >    Add kvm_gfn_shared_mask() check.
> > > > - catch up for struct kvm_range change
> > > > ---
> > > >   arch/x86/include/asm/kvm-x86-ops.h |   5 +
> > > >   arch/x86/include/asm/kvm_host.h    |  25 +++
> > > >   arch/x86/kvm/mmu/mmu.c             |  13 +-
> > > >   arch/x86/kvm/mmu/mmu_internal.h    |  19 +-
> > > >   arch/x86/kvm/mmu/tdp_iter.h        |   2 +-
> > > >   arch/x86/kvm/mmu/tdp_mmu.c         | 269 +++++++++++++++++++++++++----
> > > >   arch/x86/kvm/mmu/tdp_mmu.h         |   2 +-
> > > >   7 files changed, 293 insertions(+), 42 deletions(-)
> > > > 
> > > > diff --git a/arch/x86/include/asm/kvm-x86-ops.h
> > > > b/arch/x86/include/asm/kvm-x86-ops.h
> > > > index 566d19b02483..d13cb4b8fce6 100644
> > > > --- a/arch/x86/include/asm/kvm-x86-ops.h
> > > > +++ b/arch/x86/include/asm/kvm-x86-ops.h
> > > > @@ -95,6 +95,11 @@ KVM_X86_OP_OPTIONAL_RET0(set_tss_addr)
> > > >   KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
> > > >   KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
> > > >   KVM_X86_OP(load_mmu_pgd)
> > > > +KVM_X86_OP_OPTIONAL(link_private_spt)
> > > > +KVM_X86_OP_OPTIONAL(free_private_spt)
> > > > +KVM_X86_OP_OPTIONAL(set_private_spte)
> > > > +KVM_X86_OP_OPTIONAL(remove_private_spte)
> > > > +KVM_X86_OP_OPTIONAL(zap_private_spte)
> > > >   KVM_X86_OP(has_wbinvd_exit)
> > > >   KVM_X86_OP(get_l2_tsc_offset)
> > > >   KVM_X86_OP(get_l2_tsc_multiplier)
> > > > diff --git a/arch/x86/include/asm/kvm_host.h
> > > > b/arch/x86/include/asm/kvm_host.h
> > > > index d010ca5c7f44..20fa8fa58692 100644
> > > > --- a/arch/x86/include/asm/kvm_host.h
> > > > +++ b/arch/x86/include/asm/kvm_host.h
> > > > @@ -470,6 +470,7 @@ struct kvm_mmu {
> > > >         int (*sync_spte)(struct kvm_vcpu *vcpu,
> > > >                          struct kvm_mmu_page *sp, int i);
> > > >         struct kvm_mmu_root_info root;
> > > > +       hpa_t private_root_hpa;
> > > 
> > > Should we have
> > > 
> > >         struct kvm_mmu_root_info private_root;
> > > 
> > > instead?
> > 
> > Yes. And the private root allocation can be pushed down into TDP MMU.
> 
> Why?

Because the only TDP MMU supports mirrored PT and the change of the root pt
allocation will be contained in TDP MMU.  Also it will be symetric to
kvm_mmu_destroy() and kvm_tdp_mmu_destroy().


> [snip]
> > > > @@ -7263,6 +7266,12 @@ int kvm_mmu_vendor_module_init(void)
> > > >   void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
> > > >   {
> > > >         kvm_mmu_unload(vcpu);
> > > > +       if (tdp_mmu_enabled) {
> > > > +               read_lock(&vcpu->kvm->mmu_lock);
> > > > +               mmu_free_root_page(vcpu->kvm, &vcpu->arch.mmu-
> > > > >private_root_hpa,
> > > > +                                  NULL);
> > > > +               read_unlock(&vcpu->kvm->mmu_lock);
> > > > +       }
> > > 
> > > Hmm.. I don't quite like this, but sorry I kinda forgot why we need to to
> > > this here.
> > > 
> > > Could you elaborate?
> > > 
> > > Anyway, from common code's perspective, we need to have some clarification
> > > why we design to do it here.
> > 
> > This should be cleaned up.  It can be pushed down into
> > kvm_tdp_mmu_alloc_root().
> > 
> > void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu)
> >   allocate shared root
> >   if (has_mirrort_pt)
> >     allocate private root
> > 
> 
> Huh? This is kvm_mmu_destroy()...




> > > >         free_mmu_pages(&vcpu->arch.root_mmu);
> > > >         free_mmu_pages(&vcpu->arch.guest_mmu);
> > > >         mmu_free_memory_caches(vcpu);
> > > > diff --git a/arch/x86/kvm/mmu/mmu_internal.h
> > > > b/arch/x86/kvm/mmu/mmu_internal.h
> > > > index 0f1a9d733d9e..3a7fe9261e23 100644
> > > > --- a/arch/x86/kvm/mmu/mmu_internal.h
> > > > +++ b/arch/x86/kvm/mmu/mmu_internal.h
> > > > @@ -6,6 +6,8 @@
> > > >   #include <linux/kvm_host.h>
> > > >   #include <asm/kvm_host.h>
> > > > +#include "mmu.h"
> > > > +
> > > >   #ifdef CONFIG_KVM_PROVE_MMU
> > > >   #define KVM_MMU_WARN_ON(x) WARN_ON_ONCE(x)
> > > >   #else
> > > > @@ -178,6 +180,16 @@ static inline void kvm_mmu_alloc_private_spt(struct
> > > > kvm_vcpu *vcpu, struct kvm_m
> > > >         sp->private_spt = kvm_mmu_memory_cache_alloc(&vcpu-
> > > > >arch.mmu_private_spt_cache);
> > > >   }
> > > > +static inline gfn_t kvm_gfn_for_root(struct kvm *kvm, struct kvm_mmu_page
> > > > *root,
> > > > +                                    gfn_t gfn)
> > > > +{
> > > > +       gfn_t gfn_for_root = kvm_gfn_to_private(kvm, gfn);
> > > > +
> > > > +       /* Set shared bit if not private */
> > > > +       gfn_for_root |= -(gfn_t)!is_private_sp(root) &
> > > > kvm_gfn_shared_mask(kvm);
> > > > +       return gfn_for_root;
> > > > +}
> > > > +
> > > >   static inline bool kvm_mmu_page_ad_need_write_protect(struct
> > > > kvm_mmu_page *sp)
> > > >   {
> > > >         /*
> > > > @@ -348,7 +360,12 @@ static inline int __kvm_mmu_do_page_fault(struct
> > > > kvm_vcpu *vcpu, gpa_t cr2_or_gp
> > > >         int r;
> > > >         if (vcpu->arch.mmu->root_role.direct) {
> > > > -               fault.gfn = fault.addr >> PAGE_SHIFT;
> > > > +               /*
> > > > +                * Things like memslots don't understand the concept of a
> > > > shared
> > > > +                * bit. Strip it so that the GFN can be used like normal,
> > > > and the
> > > > +                * fault.addr can be used when the shared bit is needed.
> > > > +                */
> > > > +               fault.gfn = gpa_to_gfn(fault.addr) &
> > > > ~kvm_gfn_shared_mask(vcpu->kvm);
> > > >                 fault.slot = kvm_vcpu_gfn_to_memslot(vcpu, fault.gfn);
> > > 
> > > Again, I don't think it's nessary for fault.gfn to still have the shared bit
> > > here?
> > > 
> > > This kinda usage is pretty much the reason I want to get rid of
> > > kvm_gfn_shared_mask().
> > 
> > We are going to flags like has_mirrored_pt and we have root page table
> > iterator
> > with types specified.  I'll investigate how we can reduce (or eliminate)
> > those helper functions.
> 
> Let's transition the abusers off and see whats left. I'm still waiting for an
> explanation of why they are bad when uses properly.

Sure. Let's untangle things one by one.


> [snip]
> > 
> > > >         /* The level of the root page given to the iterator */
> > > >         int root_level;
> > > 
> > > [...]
> > > 
> > > >         for_each_tdp_pte_min_level(iter, root, PG_LEVEL_4K, start, end) {
> > > > @@ -1029,8 +1209,8 @@ static int tdp_mmu_map_handle_target_level(struct
> > > > kvm_vcpu *vcpu,
> > > >                 new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
> > > >         else
> > > >                 wrprot = make_spte(vcpu, sp, fault->slot, ACC_ALL, iter-
> > > > >gfn,
> > > > -                                        fault->pfn, iter->old_spte,
> > > > fault->prefetch, true,
> > > > -                                        fault->map_writable, &new_spte);
> > > > +                                       fault->pfn, iter->old_spte, fault-
> > > > >prefetch, true,
> > > > +                                       fault->map_writable, &new_spte);
> > > >         if (new_spte == iter->old_spte)
> > > >                 ret = RET_PF_SPURIOUS;
> > > > @@ -1108,6 +1288,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct
> > > > kvm_page_fault *fault)
> > > >         struct kvm *kvm = vcpu->kvm;
> > > >         struct tdp_iter iter;
> > > >         struct kvm_mmu_page *sp;
> > > > +       gfn_t raw_gfn;
> > > > +       bool is_private = fault->is_private && kvm_gfn_shared_mask(kvm);
> > > 
> > > Ditto.  I wish we can have 'has_mirrored_private_pt'.
> > 
> > Which name do you prefer? has_mirrored_pt or has_mirrored_private_pt?
> 
> Why not helpers that wrap vm_type like:
> https://lore.kernel.org/kvm/d4c96caffd2633a70a140861d91794cdb54c7655.camel@intel.com/

I followed the existing way.  Anyway I'm fine with either way.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

