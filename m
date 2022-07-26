Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3235C581C76
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 01:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233233AbiGZXkL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 19:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233136AbiGZXkF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 19:40:05 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 061C313DCF;
        Tue, 26 Jul 2022 16:40:02 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id r186so14483259pgr.2;
        Tue, 26 Jul 2022 16:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KAxh+KTDk+gupPFc9nW2q5HBpLbuRDgjrzesO/9tVsI=;
        b=I9BMvwKqacdYeYJd8EBx+kd2g/fomh5PUIpECZUl0hMLJWKyw+KL9EtLdKuj7oc9ka
         qp1PInTvk9rCFZDI8XdXrYOw/vTIG8ARBGzZy0My9YPtDkk4iI/e2jrTqJPlmPZlRqpZ
         AnyflQvtAVH/fZbo+71VJo3Akoka4dt+VRrHBHeSziJiT/iWc0f2q3gHHj8e2RZ7nskt
         lsPykb98Up7Xdb6ylSV6W6J6bdD74NH584Qy1qwwdJrBAt4bdDVaoLh8qY2eZHUCZewA
         4uErVnyaIVZqVgS8YbVuih5kXJ+0is/GV4FCaKj1aeidHY7GhFCN2KgFPRfDt1qCcYep
         wGgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KAxh+KTDk+gupPFc9nW2q5HBpLbuRDgjrzesO/9tVsI=;
        b=lZQaZL/fSarKdqLpWDTOCPF0ed5UMfHeZeVTF0vrqMehzi60P7JieO3JBaSn6m0HBX
         gCWJvr/3mqH0y3DcYzN8xjju9HKx6uWyqCYf5kNFOleyxSWfZOq3MwNKyKA4byLD+IjP
         VUiGYWMEjWXnAC/U1tMVPYbAeb4Hhm6t9+UQ7A66ZNU9lubmHCqvOVQwzLnkQAmuqLPG
         jPduyAq/BGTuRRyWdZuSdAjEx908kJ/L2FzExZLpgKU3ct1cJVJ2hcDzgyothuaLBFYC
         SmpAhuucM5LvgyO5631iQM4yB/yfs/AgtqZXmbk+EBKaTF3uF//f2J+FbMMxUWgZrUUz
         kTNw==
X-Gm-Message-State: AJIora9f4rM9RMG831RKOxm4nPS2FAxsH8HciA2B0GD8PA+UWdSxGjfX
        pigzfAFSZm3pT59s9jVq/K8=
X-Google-Smtp-Source: AGRyM1sDhkM2xpB4960DjosxaaZ7v9JaKqe+0+dz3c8jaAmfhmpdI6pR2pNa0Gp2v3UCX16Q/Ea22A==
X-Received: by 2002:a65:604a:0:b0:3f9:f423:b474 with SMTP id a10-20020a65604a000000b003f9f423b474mr16247084pgp.527.1658878802065;
        Tue, 26 Jul 2022 16:40:02 -0700 (PDT)
Received: from localhost ([192.55.54.49])
        by smtp.gmail.com with ESMTPSA id t23-20020a17090ad15700b001e29ddf9f4fsm163792pjw.3.2022.07.26.16.40.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 16:40:01 -0700 (PDT)
Date:   Tue, 26 Jul 2022 16:39:59 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 046/102] KVM: x86/tdp_mmu: Support TDX private mapping
 for TDP MMU
Message-ID: <20220726233959.GC1379820@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <94524fe1d3ead13019a2b502f37797727296fbd1.1656366338.git.isaku.yamahata@intel.com>
 <f5172016f6481f65efe5508bba629c1b9f0ff117.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f5172016f6481f65efe5508bba629c1b9f0ff117.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 08, 2022 at 03:44:05PM +1200,
Kai Huang <kai.huang@intel.com> wrote:

> > +static int kvm_faultin_pfn_private_mapped(struct kvm_vcpu *vcpu,
> > +					   struct kvm_page_fault *fault)
> > +{
> > +	hva_t hva = gfn_to_hva_memslot(fault->slot, fault->gfn);
> > +	struct page *page[1];
> > +
> > +	fault->map_writable = false;
> > +	fault->pfn = KVM_PFN_ERR_FAULT;
> > +	if (hva == KVM_HVA_ERR_RO_BAD || hva == KVM_HVA_ERR_BAD)
> > +		return RET_PF_CONTINUE;
> > +
> > +	/* TDX allows only RWX.  Read-only isn't supported. */
> > +	WARN_ON_ONCE(!fault->write);
> > +	if (pin_user_pages_fast(hva, 1, FOLL_WRITE, page) != 1)
> > +		return RET_PF_INVALID;
> > +
> > +	fault->map_writable = true;
> > +	fault->pfn = page_to_pfn(page[0]);
> > +	return RET_PF_CONTINUE;
> > +}
> > +
> >  static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >  {
> >  	struct kvm_memory_slot *slot = fault->slot;
> > @@ -4058,6 +4094,9 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >  			return RET_PF_EMULATE;
> >  	}
> >  
> > +	if (fault->is_private)
> > +		return kvm_faultin_pfn_private_mapped(vcpu, fault);
> > +
> >  	async = false;
> >  	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, &async,
> >  					  fault->write, &fault->map_writable,
> > @@ -4110,6 +4149,17 @@ static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
> >  	       mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, fault->hva);
> >  }
> >  
> > +void kvm_mmu_release_fault(struct kvm *kvm, struct kvm_page_fault *fault, int r)
> > +{
> > +	if (is_error_noslot_pfn(fault->pfn) || kvm_is_reserved_pfn(fault->pfn))
> > +		return;
> > +
> > +	if (fault->is_private)
> > +		put_page(pfn_to_page(fault->pfn));
> > +	else
> > +		kvm_release_pfn_clean(fault->pfn);
> > +}
> 
> What's the purpose of 'int r'?  Is it even used?

removed r because r is unused.


> >  static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >  {
> >  	bool is_tdp_mmu_fault = is_tdp_mmu(vcpu->arch.mmu);
> > @@ -4117,7 +4167,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
> >  	unsigned long mmu_seq;
> >  	int r;
> >  
> > -	fault->gfn = fault->addr >> PAGE_SHIFT;
> > +	fault->gfn = gpa_to_gfn(fault->addr) & ~kvm_gfn_shared_mask(vcpu->kvm);
> >  	fault->slot = kvm_vcpu_gfn_to_memslot(vcpu, fault->gfn);
> 
> Where is fault->is_private set? Shouldn't it be set here?

kvm_mmu_do_page_fault() does it and no because is_private is constant.
is_private is input.  On the other hand gfn and slot is working variables.


> >  	}
> >  
> >  	if (flush)
> > @@ -6023,6 +6079,11 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
> >  		write_unlock(&kvm->mmu_lock);
> >  	}
> >  
> > +	/*
> > +	 * For now this can only happen for non-TD VM, because TD private
> > +	 * mapping doesn't support write protection.  kvm_tdp_mmu_wrprot_slot()
> > +	 * will give a WARN() if it hits for TD.
> > +	 */
> 
> Unless I am mistaken, 'kvm_tdp_mmu_wrprot_slot() will give a WARN() if it hits
> for TD" is done in your later patch "KVM: x86/tdp_mmu: Ignore unsupported mmu
> operation on private GFNs".  Why putting comment here?
> 
> Please move this comment to that patch, and I think you can put that patch
> before this patch.
> 
> And this problem happens repeatedly in this series.  Could you check the entire
> series?

Split out those stuff into a patch.


> > diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> > index 9f3a6bea60a3..d3b30d62aca0 100644
> > --- a/arch/x86/kvm/mmu/mmu_internal.h
> > +++ b/arch/x86/kvm/mmu/mmu_internal.h
> > @@ -6,6 +6,8 @@
> >  #include <linux/kvm_host.h>
> >  #include <asm/kvm_host.h>
> >  
> > +#include "mmu.h"
> > +
> >  #undef MMU_DEBUG
> >  
> >  #ifdef MMU_DEBUG
> > @@ -164,11 +166,30 @@ static inline void kvm_mmu_alloc_private_sp(
> >  	WARN_ON_ONCE(!sp->private_sp);
> >  }
> >  
> > +static inline int kvm_alloc_private_sp_for_split(
> > +	struct kvm_mmu_page *sp, gfp_t gfp)
> > +{
> > +	gfp &= ~__GFP_ZERO;
> > +	sp->private_sp = (void*)__get_free_page(gfp);
> > +	if (!sp->private_sp)
> > +		return -ENOMEM;
> > +	return 0;
> > +}
> 
> What does "for_split" mean?  Why do we need it?

Split large page into smaller sized one.  Followed tdp_mmu_alloc_sp_for_split().
We can defer to introduce this function until large page support.


> > +
> >  static inline void kvm_mmu_free_private_sp(struct kvm_mmu_page *sp)
> >  {
> >  	if (sp->private_sp != KVM_MMU_PRIVATE_SP_ROOT)
> >  		free_page((unsigned long)sp->private_sp);
> >  }
> > +
> > +static inline gfn_t kvm_gfn_for_root(struct kvm *kvm, struct kvm_mmu_page *root,
> > +				     gfn_t gfn)
> > +{
> > +	if (is_private_sp(root))
> > +		return kvm_gfn_private(kvm, gfn);
> > +	else
> > +		return kvm_gfn_shared(kvm, gfn);
> > +}
> >  #else
> >  static inline bool is_private_sp(struct kvm_mmu_page *sp)
> >  {
> > @@ -194,11 +215,25 @@ static inline void kvm_mmu_alloc_private_sp(
> >  {
> >  }
> >  
> > +static inline int kvm_alloc_private_sp_for_split(
> > +	struct kvm_mmu_page *sp, gfp_t gfp)
> > +{
> > +	return -ENOMEM;
> > +}
> > +
> >  static inline void kvm_mmu_free_private_sp(struct kvm_mmu_page *sp)
> >  {
> >  }
> > +
> > +static inline gfn_t kvm_gfn_for_root(struct kvm *kvm, struct kvm_mmu_page *root,
> > +				     gfn_t gfn)
> > +{
> > +	return gfn;
> > +}
> >  #endif
> >  
> > +void kvm_mmu_release_fault(struct kvm *kvm, struct kvm_page_fault *fault, int r);
> > +
> >  static inline bool kvm_mmu_page_ad_need_write_protect(struct kvm_mmu_page *sp)
> >  {
> >  	/*
> > @@ -246,6 +281,7 @@ struct kvm_page_fault {
> >  	/* Derived from mmu and global state.  */
> >  	const bool is_tdp;
> >  	const bool nx_huge_page_workaround_enabled;
> > +	const bool is_private;
> >  
> >  	/*
> >  	 * Whether a >4KB mapping can be created or is forbidden due to NX
> > @@ -327,6 +363,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> >  		.prefetch = prefetch,
> >  		.is_tdp = likely(vcpu->arch.mmu->page_fault == kvm_tdp_page_fault),
> >  		.nx_huge_page_workaround_enabled = is_nx_huge_page_enabled(),
> > +		.is_private = kvm_is_private_gpa(vcpu->kvm, cr2_or_gpa),
> 
> I guess putting this chunk and setting up fault->gfn together would be clearer?

is_private is input for kvm page fault. gfn is working variable to resolve
kvm page fault.

> >  static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
> > -				u64 old_spte, u64 new_spte, int level,
> > -				bool shared)
> > +				bool private_spte, u64 old_spte, u64 new_spte,
> > +				int level, bool shared)
> >  {
> > -	__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level,
> > -			      shared);
> > +	__handle_changed_spte(kvm, as_id, gfn, private_spte,
> > +			old_spte, new_spte, level, shared);
> >  	handle_changed_spte_acc_track(old_spte, new_spte, level);
> >  	handle_changed_spte_dirty_log(kvm, as_id, gfn, old_spte,
> >  				      new_spte, level);
> > @@ -640,6 +714,8 @@ static inline int tdp_mmu_set_spte_atomic(struct kvm *kvm,
> >  					  struct tdp_iter *iter,
> >  					  u64 new_spte)
> >  {
> > +	bool freeze_spte = iter->is_private && !is_removed_spte(new_spte);
> > +	u64 tmp_spte = freeze_spte ? REMOVED_SPTE : new_spte;
> 
> Perhaps I am missing something.  Could you add comments to explain the logic?

Add a comment.
+       /*
+        * For conventional page table, the update flow is
+        * - update STPE with atomic operation
+        * - hanlde changed SPTE. __handle_changed_spte()
+        * NOTE: __handle_changed_spte() (and functions) must be safe against
+        * concurrent update.  It is an exception to zap SPTE.  See
+        * tdp_mmu_zap_spte_atomic().
+        *
+        * For private page table, callbacks are needed to propagate SPTE
+        * change into the protected page table.  In order to atomically update
+        * both the SPTE and the protected page tables with callbacks, utilize
+        * freezing SPTE.
+        * - Freeze the SPTE. Set entry to REMOVED_SPTE.
+        * - Trigger callbacks for protected page tables. __handle_changed_spte()
+        * - Unfreeze the SPTE.  Set the entry to new_spte.
+        */


> > @@ -1067,6 +1163,12 @@ void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
> >  
> >  	lockdep_assert_held_write(&kvm->mmu_lock);
> >  	list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link) {
> > +		/*
> > +		 * Skip private root since private page table
> > +		 * is only torn down when VM is destroyed.
> > +		 */
> > +		if (is_private_sp(root))
> > +			continue;
> >  		if (!root->role.invalid &&
> >  		    !WARN_ON_ONCE(!kvm_tdp_mmu_get_root(root))) {
> >  			root->role.invalid = true;
> > @@ -1087,14 +1189,22 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
> >  	u64 new_spte;
> >  	int ret = RET_PF_FIXED;
> >  	bool wrprot = false;
> > +	unsigned long pte_access = ACC_ALL;
> > +	gfn_t gfn_unalias = iter->gfn & ~kvm_gfn_shared_mask(vcpu->kvm);
> 
> Here looks the iter->gfn still contains the shared bits.  It is not consistent
> with above.
> 
> Can you put some words into the changelog explaining exactly what GFN will you
> put to iterator?
> 
> Or can you even split out this part as a separate patch?

I think you meant the above is zap_leafs function. It zaps GPA range module
alias (module shared bit).
This function is to resolve kvm page fault.  It means gpa includes shared bit.

here is the updated patch.

From ae3cee62e53a877bef04813e6ae8d710b4a9128a Mon Sep 17 00:00:00 2001
Message-Id: <ae3cee62e53a877bef04813e6ae8d710b4a9128a.1658878587.git.isaku.yamahata@intel.com>
In-Reply-To: <3941849bf08a55cfbbe69b222f0fd0dac7c5ee53.1658878587.git.isaku.yamahata@intel.com>
References: <3941849bf08a55cfbbe69b222f0fd0dac7c5ee53.1658878587.git.isaku.yamahata@intel.com>
From: Isaku Yamahata <isaku.yamahata@intel.com>
Date: Thu, 14 Jul 2022 15:11:24 -0700
Subject: [PATCH 048/292] KVM: x86/tdp_mmu: Support TDX private mapping for TDP
 MMU

Allocate protected page table for private page table, and add hooks to
operate on protected page table.  This patch adds allocation/free of
protected page tables and hooks.  When calling hooks to update SPTE entry,
freeze the entry, call hooks and unfree the entry to allow concurrent
updates on page tables.  Which is the advantage of TDP MMU.  As
kvm_gfn_shared_mask() returns false always, those hooks aren't called yet
with this patch.

When the faulting GPA is private, the KVM fault is called private.  When
resolving private KVM, allocate protected page table and call hooks to
operate on protected page table. On the change of the private PTE entry,
invoke kvm_x86_ops hook in __handle_changed_spte() to propagate the change
to protected page table. The following depicts the relationship.

  private KVM page fault   |
      |                    |
      V                    |
 private GPA               |     CPU protected EPTP
      |                    |           |
      V                    |           V
 private PT root           |     protected PT root
      |                    |           |
      V                    |           V
   private PT --hook to propagate-->protected PT
      |                    |           |
      \--------------------+------\    |
                           |      |    |
                           |      V    V
                           |    private guest page
                           |
                           |
     non-encrypted memory  |    encrypted memory
                           |
PT: page table

The existing KVM TDP MMU code uses atomic update of SPTE.  On populating
the EPT entry, atomically set the entry.  However, it requires TLB
shootdown to zap SPTE.  To address it, the entry is frozen with the special
SPTE value that clears the present bit. After the TLB shootdown, the entry
is set to the eventual value (unfreeze).

For protected page table, hooks are called to update protected page table
in addition to direct access to the private SPTE. For the zapping case, it
works to freeze the SPTE. It can call hooks in addition to TLB shootdown.
For populating the private SPTE entry, there can be a race condition
without further protection

  vcpu 1: populating 2M private SPTE
  vcpu 2: populating 4K private SPTE
  vcpu 2: TDX SEAMCALL to update 4K protected SPTE => error
  vcpu 1: TDX SEAMCALL to update 2M protected SPTE

To avoid the race, the frozen SPTE is utilized.  Instead of atomic update
of the private entry, freeze the entry, call the hook that update protected
SPTE, set the entry to the final value.

Support 4K page only at this stage.  2M page support can be done in future
patches.

Add is_private member to kvm_page_fault to indicate the fault is private.
Also is_private member to struct tdp_inter to propagate it.

Co-developed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Acked-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |   2 +
 arch/x86/include/asm/kvm_host.h    |  20 +++
 arch/x86/kvm/mmu/mmu.c             |  15 +-
 arch/x86/kvm/mmu/mmu_internal.h    |  35 +++++
 arch/x86/kvm/mmu/tdp_iter.h        |   2 +-
 arch/x86/kvm/mmu/tdp_mmu.c         | 215 ++++++++++++++++++++++++-----
 arch/x86/kvm/mmu/tdp_mmu.h         |   2 +-
 virt/kvm/kvm_main.c                |   1 +
 8 files changed, 254 insertions(+), 38 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 32a6df784ea6..6982d57e4518 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -93,6 +93,8 @@ KVM_X86_OP_OPTIONAL_RET0(set_tss_addr)
 KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
 KVM_X86_OP(get_mt_mask)
 KVM_X86_OP(load_mmu_pgd)
+KVM_X86_OP_OPTIONAL(free_private_sp)
+KVM_X86_OP_OPTIONAL(handle_changed_private_spte)
 KVM_X86_OP(has_wbinvd_exit)
 KVM_X86_OP(get_l2_tsc_offset)
 KVM_X86_OP(get_l2_tsc_multiplier)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a73050a69aab..23a4d9d06772 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -467,6 +467,7 @@ struct kvm_mmu {
 			 struct kvm_mmu_page *sp);
 	void (*invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa);
 	struct kvm_mmu_root_info root;
+	hpa_t private_root_hpa;
 	union kvm_cpu_role cpu_role;
 	union kvm_mmu_page_role root_role;
 
@@ -1462,6 +1463,20 @@ static inline u16 kvm_lapic_irq_dest_mode(bool dest_mode_logical)
 	return dest_mode_logical ? APIC_DEST_LOGICAL : APIC_DEST_PHYSICAL;
 }
 
+struct kvm_spte {
+	kvm_pfn_t pfn;
+	bool is_present;
+	bool is_leaf;
+};
+
+struct kvm_spte_change {
+	gfn_t gfn;
+	enum pg_level level;
+	struct kvm_spte old;
+	struct kvm_spte new;
+	void *sept_page;
+};
+
 struct kvm_x86_ops {
 	const char *name;
 
@@ -1574,6 +1589,11 @@ struct kvm_x86_ops {
 	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			     int root_level);
 
+	int (*free_private_sp)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+			       void *private_sp);
+	void (*handle_changed_private_spte)(
+		struct kvm *kvm, const struct kvm_spte_change *change);
+
 	bool (*has_wbinvd_exit)(void);
 
 	u64 (*get_l2_tsc_offset)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 37ae04ef0719..98138e688c59 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3465,7 +3465,12 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 		goto out_unlock;
 
 	if (is_tdp_mmu_enabled(vcpu->kvm)) {
-		root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu);
+		if (kvm_gfn_shared_mask(vcpu->kvm) &&
+		    !VALID_PAGE(mmu->private_root_hpa)) {
+			root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu, true);
+			mmu->private_root_hpa = root;
+		}
+		root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu, false);
 		mmu->root.hpa = root;
 	} else if (shadow_root_level >= PT64_ROOT_4LEVEL) {
 		root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level, true);
@@ -4128,7 +4133,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	unsigned long mmu_seq;
 	int r;
 
-	fault->gfn = fault->addr >> PAGE_SHIFT;
+	fault->gfn = gpa_to_gfn(fault->addr) & ~kvm_gfn_shared_mask(vcpu->kvm);
 	fault->slot = kvm_vcpu_gfn_to_memslot(vcpu, fault->gfn);
 
 	if (page_fault_handle_page_track(vcpu, fault))
@@ -5669,6 +5674,7 @@ static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
 
 	mmu->root.hpa = INVALID_PAGE;
 	mmu->root.pgd = 0;
+	mmu->private_root_hpa = INVALID_PAGE;
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
 		mmu->prev_roots[i] = KVM_MMU_ROOT_INFO_INVALID;
 
@@ -6467,6 +6473,9 @@ int kvm_mmu_vendor_module_init(void)
 void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
 {
 	kvm_mmu_unload(vcpu);
+	if (is_tdp_mmu_enabled(vcpu->kvm))
+		mmu_free_root_page(vcpu->kvm, &vcpu->arch.mmu->private_root_hpa,
+				NULL);
 	free_mmu_pages(&vcpu->arch.root_mmu);
 	free_mmu_pages(&vcpu->arch.guest_mmu);
 	mmu_free_memory_caches(vcpu);
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 29904f8d8719..6c529c804875 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -6,6 +6,8 @@
 #include <linux/kvm_host.h>
 #include <asm/kvm_host.h>
 
+#include "mmu.h"
+
 #undef MMU_DEBUG
 
 #ifdef MMU_DEBUG
@@ -163,11 +165,30 @@ static inline void kvm_mmu_alloc_private_sp(
 	}
 }
 
+static inline int kvm_alloc_private_sp_for_split(
+	struct kvm_mmu_page *sp, gfp_t gfp)
+{
+	gfp &= ~__GFP_ZERO;
+	sp->private_sp = (void*)__get_free_page(gfp);
+	if (!sp->private_sp)
+		return -ENOMEM;
+	return 0;
+}
+
 static inline void kvm_mmu_free_private_sp(struct kvm_mmu_page *sp)
 {
 	if (sp->private_sp)
 		free_page((unsigned long)sp->private_sp);
 }
+
+static inline gfn_t kvm_gfn_for_root(struct kvm *kvm, struct kvm_mmu_page *root,
+				     gfn_t gfn)
+{
+	if (is_private_sp(root))
+		return kvm_gfn_private(kvm, gfn);
+	else
+		return kvm_gfn_shared(kvm, gfn);
+}
 #else
 static inline void *kvm_mmu_private_sp(struct kvm_mmu_page *sp)
 {
@@ -183,9 +204,21 @@ static inline void kvm_mmu_alloc_private_sp(
 {
 }
 
+static inline int kvm_alloc_private_sp_for_split(
+	struct kvm_mmu_page *sp, gfp_t gfp)
+{
+	return -ENOMEM;
+}
+
 static inline void kvm_mmu_free_private_sp(struct kvm_mmu_page *sp)
 {
 }
+
+static inline gfn_t kvm_gfn_for_root(struct kvm *kvm, struct kvm_mmu_page *root,
+				     gfn_t gfn)
+{
+	return gfn;
+}
 #endif
 
 static inline bool kvm_mmu_page_ad_need_write_protect(struct kvm_mmu_page *sp)
@@ -235,6 +268,7 @@ struct kvm_page_fault {
 	/* Derived from mmu and global state.  */
 	const bool is_tdp;
 	const bool nx_huge_page_workaround_enabled;
+	const bool is_private;
 
 	/*
 	 * Whether a >4KB mapping can be created or is forbidden due to NX
@@ -316,6 +350,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		.prefetch = prefetch,
 		.is_tdp = likely(vcpu->arch.mmu->page_fault == kvm_tdp_page_fault),
 		.nx_huge_page_workaround_enabled = is_nx_huge_page_enabled(),
+		.is_private = kvm_is_private_gpa(vcpu->kvm, cr2_or_gpa),
 
 		.max_level = vcpu->kvm->arch.tdp_max_page_level,
 		.req_level = PG_LEVEL_4K,
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index e25992df5bba..20422eeba6aa 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -71,7 +71,7 @@ struct tdp_iter {
 	tdp_ptep_t pt_path[PT64_ROOT_MAX_LEVEL];
 	/* A pointer to the current SPTE */
 	tdp_ptep_t sptep;
-	/* The lowest GFN mapped by the current SPTE */
+	/* The lowest GFN (shared bits included) mapped by the current SPTE */
 	gfn_t gfn;
 	/* The level of the root page given to the iterator */
 	int root_level;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 8d8481beca4e..9d0bd5e1afbf 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -285,6 +285,11 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu,
 	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
 	sp->role = role;
 
+	if (kvm_mmu_page_role_is_private(role))
+		kvm_mmu_alloc_private_sp(vcpu, sp);
+	else
+		kvm_mmu_init_private_sp(sp, NULL);
+
 	return sp;
 }
 
@@ -301,12 +306,12 @@ static void tdp_mmu_init_sp(struct kvm_mmu_page *sp, tdp_ptep_t sptep,
 	sp->gfn = gfn;
 	sp->ptep = sptep;
 	sp->tdp_mmu_page = true;
-	kvm_mmu_init_private_sp(sp, NULL);
 
 	trace_kvm_mmu_get_page(sp, true);
 }
 
-hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
+static struct kvm_mmu_page *kvm_tdp_mmu_get_vcpu_root(struct kvm_vcpu *vcpu,
+						      bool private)
 {
 	union kvm_mmu_page_role role = vcpu->arch.mmu->root_role;
 	struct kvm *kvm = vcpu->kvm;
@@ -318,6 +323,8 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 	 * Check for an existing root before allocating a new one.  Note, the
 	 * role check prevents consuming an invalid root.
 	 */
+	if (private)
+		kvm_mmu_page_role_set_private(&role);
 	for_each_tdp_mmu_root(kvm, root, kvm_mmu_role_as_id(role)) {
 		if (root->role.word == role.word &&
 		    kvm_tdp_mmu_get_root(root))
@@ -334,12 +341,17 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 
 out:
-	return __pa(root->spt);
+	return root;
+}
+
+hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu, bool private)
+{
+	return __pa(kvm_tdp_mmu_get_vcpu_root(vcpu, private)->spt);
 }
 
 static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
-				u64 old_spte, u64 new_spte, int level,
-				bool shared);
+				u64 old_spte, u64 new_spte,
+				union kvm_mmu_page_role role, bool shared);
 
 static void handle_changed_spte_acc_track(u64 old_spte, u64 new_spte, int level)
 {
@@ -365,6 +377,8 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
 
 	if ((!is_writable_pte(old_spte) || pfn_changed) &&
 	    is_writable_pte(new_spte)) {
+		/* For memory slot operations, use GFN without aliasing */
+		gfn = gfn & ~kvm_gfn_shared_mask(kvm);
 		slot = __gfn_to_memslot(__kvm_memslots(kvm, as_id), gfn);
 		mark_page_dirty_in_slot(kvm, slot, gfn);
 	}
@@ -489,7 +503,18 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
 							  REMOVED_SPTE, level);
 		}
 		handle_changed_spte(kvm, kvm_mmu_page_as_id(sp), gfn,
-				    old_spte, REMOVED_SPTE, level, shared);
+				    old_spte, REMOVED_SPTE, sp->role, shared);
+	}
+
+	if (is_private_sp(sp) && WARN_ON(static_call(kvm_x86_free_private_sp)(
+						   kvm, sp->gfn, sp->role.level,
+						   kvm_mmu_private_sp(sp)))) {
+		/*
+		 * Failed to unlink Secure EPT page and there is nothing to do
+		 * further.  Intentionally leak the page to prevent the kernel
+		 * from accessing the encrypted page.
+		 */
+		kvm_mmu_init_private_sp(sp, NULL);
 	}
 
 	call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
@@ -502,7 +527,7 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
  * @gfn: the base GFN that was mapped by the SPTE
  * @old_spte: The value of the SPTE before the change
  * @new_spte: The value of the SPTE after the change
- * @level: the level of the PT the SPTE is part of in the paging structure
+ * @role: the role of the PT the SPTE is part of in the paging structure
  * @shared: This operation may not be running under the exclusive use of
  *	    the MMU lock and the operation must synchronize with other
  *	    threads that might be modifying SPTEs.
@@ -511,14 +536,32 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
  * This function must be called for all TDP SPTE modifications.
  */
 static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
-				  u64 old_spte, u64 new_spte, int level,
-				  bool shared)
+				  u64 old_spte, u64 new_spte,
+				  union kvm_mmu_page_role role, bool shared)
 {
+	bool is_private = kvm_mmu_page_role_is_private(role);
+	int level = role.level;
 	bool was_present = is_shadow_present_pte(old_spte);
 	bool is_present = is_shadow_present_pte(new_spte);
 	bool was_leaf = was_present && is_last_spte(old_spte, level);
 	bool is_leaf = is_present && is_last_spte(new_spte, level);
-	bool pfn_changed = spte_to_pfn(old_spte) != spte_to_pfn(new_spte);
+	kvm_pfn_t old_pfn = spte_to_pfn(old_spte);
+	kvm_pfn_t new_pfn = spte_to_pfn(new_spte);
+	bool pfn_changed = old_pfn != new_pfn;
+	struct kvm_spte_change change = {
+		.gfn = gfn,
+		.level = level,
+		.old = {
+			.pfn = old_pfn,
+			.is_present = was_present,
+			.is_leaf = was_leaf,
+		},
+		.new = {
+			.pfn = new_pfn,
+			.is_present = is_present,
+			.is_leaf = is_leaf,
+		},
+	};
 
 	WARN_ON(level > PT64_ROOT_MAX_LEVEL);
 	WARN_ON(level < PG_LEVEL_4K);
@@ -585,7 +628,7 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 
 	if (was_leaf && is_dirty_spte(old_spte) &&
 	    (!is_present || !is_dirty_spte(new_spte) || pfn_changed))
-		kvm_set_pfn_dirty(spte_to_pfn(old_spte));
+		kvm_set_pfn_dirty(old_pfn);
 
 	/*
 	 * Recursively handle child PTs if the change removed a subtree from
@@ -594,19 +637,48 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	 * pages are kernel allocations and should never be migrated.
 	 */
 	if (was_present && !was_leaf &&
-	    (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed)))
+	    (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed))) {
+		WARN_ON(is_private !=
+			is_private_sptep(spte_to_child_pt(old_spte, level)));
 		handle_removed_pt(kvm, spte_to_child_pt(old_spte, level), shared);
+	}
+
+	/*
+	 * Special handling for the private mapping.  We are either
+	 * setting up new mapping at middle level page table, or leaf,
+	 * or tearing down existing mapping.
+	 *
+	 * This is after handling lower page table by above
+	 * handle_remove_tdp_mmu_page().  S-EPT requires to remove S-EPT tables
+	 * after removing childrens.
+	 */
+	if (is_private &&
+	    /* Ignore change of software only bits. e.g. host_writable */
+	    (was_leaf != is_leaf || was_present != is_present || pfn_changed)) {
+		void *sept_page = NULL;
+
+		if (is_present && !is_leaf) {
+			struct kvm_mmu_page *sp = to_shadow_page(pfn_to_hpa(new_pfn));
+
+			sept_page = kvm_mmu_private_sp(sp);
+			WARN_ON(!sept_page);
+			WARN_ON(sp->role.level + 1 != level);
+			WARN_ON(sp->gfn != gfn);
+		}
+		change.sept_page = sept_page;
+
+		static_call(kvm_x86_handle_changed_private_spte)(kvm, &change);
+	}
 }
 
 static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
-				u64 old_spte, u64 new_spte, int level,
-				bool shared)
+				u64 old_spte, u64 new_spte,
+				union kvm_mmu_page_role role, bool shared)
 {
-	__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level,
-			      shared);
-	handle_changed_spte_acc_track(old_spte, new_spte, level);
+	__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, role, shared);
+	handle_changed_spte_acc_track(old_spte, new_spte, role.level);
 	handle_changed_spte_dirty_log(kvm, as_id, gfn, old_spte,
-				      new_spte, level);
+				      new_spte, role.level);
 }
 
 /*
@@ -630,6 +702,24 @@ static inline int tdp_mmu_set_spte_atomic(struct kvm *kvm,
 					  struct tdp_iter *iter,
 					  u64 new_spte)
 {
+	/*
+	 * For conventional page table, the update flow is
+	 * - update STPE with atomic operation
+	 * - hanlde changed SPTE. __handle_changed_spte()
+	 * NOTE: __handle_changed_spte() (and functions) must be safe against
+	 * concurrent update.  It is an exception to zap SPTE.  See
+	 * tdp_mmu_zap_spte_atomic().
+	 *
+	 * For private page table, callbacks are needed to propagate SPTE
+	 * change into the protected page table.  In order to atomically update
+	 * both the SPTE and the protected page tables with callbacks, utilize
+	 * freezing SPTE.
+	 * - Freeze the SPTE. Set entry to REMOVED_SPTE.
+	 * - Trigger callbacks for protected page tables. __handle_changed_spte()
+	 * - Unfreeze the SPTE.  Set the entry to new_spte.
+	 */
+	bool freeze_spte = is_private_sptep(iter->sptep) && !is_removed_spte(new_spte);
+	u64 tmp_spte = freeze_spte ? REMOVED_SPTE : new_spte;
 	u64 *sptep = rcu_dereference(iter->sptep);
 	u64 old_spte;
 
@@ -647,7 +737,7 @@ static inline int tdp_mmu_set_spte_atomic(struct kvm *kvm,
 	 * Note, fast_pf_fix_direct_spte() can also modify TDP MMU SPTEs and
 	 * does not hold the mmu_lock.
 	 */
-	old_spte = cmpxchg64(sptep, iter->old_spte, new_spte);
+	old_spte = cmpxchg64(sptep, iter->old_spte, tmp_spte);
 	if (old_spte != iter->old_spte) {
 		/*
 		 * The page table entry was modified by a different logical
@@ -659,10 +749,14 @@ static inline int tdp_mmu_set_spte_atomic(struct kvm *kvm,
 		return -EBUSY;
 	}
 
-	__handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
-			      new_spte, iter->level, true);
+	__handle_changed_spte(
+		kvm, iter->as_id, iter->gfn,
+		iter->old_spte, new_spte, sptep_to_sp(sptep)->role, true);
 	handle_changed_spte_acc_track(iter->old_spte, new_spte, iter->level);
 
+	if (freeze_spte)
+		__kvm_tdp_mmu_write_spte(sptep, new_spte);
+
 	return 0;
 }
 
@@ -729,9 +823,11 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
  * SPTE had voldatile bits.
  */
 static u64 __tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
-			      u64 old_spte, u64 new_spte, gfn_t gfn, int level,
-			      bool record_acc_track, bool record_dirty_log)
+			       u64 old_spte, u64 new_spte, gfn_t gfn, int level,
+			       bool record_acc_track, bool record_dirty_log)
 {
+	union kvm_mmu_page_role role;
+
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	/*
@@ -745,7 +841,9 @@ static u64 __tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
 
 	old_spte = kvm_tdp_mmu_write_spte(sptep, old_spte, new_spte, level);
 
-	__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level, false);
+	role = sptep_to_sp(sptep)->role;
+	role.level = level;
+	__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, role, false);
 
 	if (record_acc_track)
 		handle_changed_spte_acc_track(old_spte, new_spte, level);
@@ -797,8 +895,11 @@ static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
 			continue;					\
 		else
 
-#define tdp_mmu_for_each_pte(_iter, _mmu, _start, _end)		\
-	for_each_tdp_pte(_iter, to_shadow_page(_mmu->root.hpa), _start, _end)
+#define tdp_mmu_for_each_pte(_iter, _mmu, _private, _start, _end)	\
+	for_each_tdp_pte(_iter,						\
+		 to_shadow_page((_private) ? _mmu->private_root_hpa :	\
+				_mmu->root.hpa),			\
+		_start, _end)
 
 /*
  * Yield if the MMU lock is contended or this thread needs to return control
@@ -964,6 +1065,14 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 	if (!zap_private && is_private_sp(root))
 		return false;
 
+	/*
+	 * start and end doesn't have GFN shared bit.  This function zaps
+	 * a region including alias.  Adjust shared bit of [start, end) if the
+	 * root is shared.
+	 */
+	start = kvm_gfn_for_root(kvm, root, start);
+	end = kvm_gfn_for_root(kvm, root, end);
+
 	rcu_read_lock();
 
 	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_4K, start, end) {
@@ -1093,10 +1202,19 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 	WARN_ON(sp->role.level != fault->goal_level);
 	if (unlikely(!fault->slot))
 		new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
-	else
-		wrprot = make_spte(vcpu, sp, fault->slot, ACC_ALL, iter->gfn,
-					 fault->pfn, iter->old_spte, fault->prefetch, true,
-					 fault->map_writable, &new_spte);
+	else {
+		unsigned long pte_access = ACC_ALL;
+		gfn_t gfn_unalias = iter->gfn & ~kvm_gfn_shared_mask(vcpu->kvm);
+
+		/* TDX shared GPAs are no executable, enforce this for the SDV. */
+		if (kvm_gfn_shared_mask(vcpu->kvm) && !fault->is_private)
+			pte_access &= ~ACC_EXEC_MASK;
+
+		wrprot = make_spte(vcpu, sp, fault->slot, pte_access,
+				   gfn_unalias, fault->pfn, iter->old_spte,
+				   fault->prefetch, true, fault->map_writable,
+				   &new_spte);
+	}
 
 	if (new_spte == iter->old_spte)
 		ret = RET_PF_SPURIOUS;
@@ -1195,6 +1313,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	struct tdp_iter iter;
+	gfn_t raw_gfn;
+	bool is_private = fault->is_private;
 	int ret;
 
 	kvm_mmu_hugepage_adjust(vcpu, fault);
@@ -1203,7 +1323,16 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 
 	rcu_read_lock();
 
-	tdp_mmu_for_each_pte(iter, mmu, fault->gfn, fault->gfn + 1) {
+	raw_gfn = gpa_to_gfn(fault->addr);
+
+	if (is_error_noslot_pfn(fault->pfn) || kvm_is_reserved_pfn(fault->pfn)) {
+		if (is_private) {
+			rcu_read_unlock();
+			return -EFAULT;
+		}
+	}
+
+	tdp_mmu_for_each_pte(iter, mmu, is_private, raw_gfn, raw_gfn + 1) {
 		if (fault->nx_huge_page_workaround_enabled)
 			disallowed_hugepage_adjust(fault, iter.old_spte, iter.level);
 
@@ -1219,6 +1348,12 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		    is_large_pte(iter.old_spte)) {
 			if (tdp_mmu_zap_spte_atomic(vcpu->kvm, &iter))
 				break;
+			/*
+			 * TODO: large page support.
+			 * Doesn't support large page for TDX now
+			 */
+			WARN_ON(is_private_sptep(iter.sptep));
+
 
 			/*
 			 * The iter must explicitly re-read the spte here
@@ -1462,6 +1597,12 @@ static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(
 
 	sp->role = role;
 	sp->spt = (void *)__get_free_page(gfp);
+	if (kvm_mmu_page_role_is_private(role)) {
+		if (kvm_alloc_private_sp_for_split(sp, gfp)) {
+			free_page((unsigned long)sp->spt);
+			sp->spt = NULL;
+		}
+	}
 	if (!sp->spt) {
 		kmem_cache_free(mmu_page_header_cache, sp);
 		return NULL;
@@ -1477,6 +1618,11 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 	union kvm_mmu_page_role role = tdp_iter_child_role(iter);
 	struct kvm_mmu_page *sp;
 
+	WARN_ON(kvm_mmu_page_role_is_private(role) !=
+		is_private_sptep(iter->sptep));
+	/* TODO: Large page isn't supported for private SPTE yet. */
+	WARN_ON(kvm_mmu_page_role_is_private(role));
+
 	/*
 	 * Since we are allocating while under the MMU lock we have to be
 	 * careful about GFP flags. Use GFP_NOWAIT to avoid blocking on direct
@@ -1924,7 +2070,7 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 	if (WARN_ON(kvm_gfn_shared_mask(vcpu->kvm)))
 		return leaf;
 
-	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
+	tdp_mmu_for_each_pte(iter, mmu, false, gfn, gfn + 1) {
 		leaf = iter.level;
 		sptes[leaf] = iter.old_spte;
 	}
@@ -1951,7 +2097,10 @@ u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, u64 addr,
 	gfn_t gfn = addr >> PAGE_SHIFT;
 	tdp_ptep_t sptep = NULL;
 
-	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
+	/* fast page fault for private GPA isn't supported. */
+	WARN_ON_ONCE(kvm_is_private_gpa(vcpu->kvm, addr));
+
+	tdp_mmu_for_each_pte(iter, mmu, false, gfn, gfn + 1) {
 		*spte = iter.old_spte;
 		sptep = iter.sptep;
 	}
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index c98c7df449a8..695175c921a5 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -5,7 +5,7 @@
 
 #include <linux/kvm_host.h>
 
-hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
+hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu, bool private);
 
 __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
 {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0acb0b6d1f82..7a5261eb7eb8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -196,6 +196,7 @@ bool kvm_is_reserved_pfn(kvm_pfn_t pfn)
 
 	return true;
 }
+EXPORT_SYMBOL_GPL(kvm_is_reserved_pfn);
 
 /*
  * Switches to specified vcpu, until a matching vcpu_put()
-- 
2.25.1




-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
