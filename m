Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D065810B650
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 20:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727139AbfK0TEE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 14:04:04 -0500
Received: from mga17.intel.com ([192.55.52.151]:45148 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726603AbfK0TEE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 14:04:04 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Nov 2019 11:04:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,250,1571727600"; 
   d="scan'208";a="410447441"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga006.fm.intel.com with ESMTP; 27 Nov 2019 11:04:01 -0800
Date:   Wed, 27 Nov 2019 11:04:01 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [RFC PATCH 07/28] kvm: mmu: Add functions for handling changed
 PTEs
Message-ID: <20191127190401.GG22227@linux.intel.com>
References: <20190926231824.149014-1-bgardon@google.com>
 <20190926231824.149014-8-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190926231824.149014-8-bgardon@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 26, 2019 at 04:18:03PM -0700, Ben Gardon wrote:
> The existing bookkeeping done by KVM when a PTE is changed is
> spread around several functions. This makes it difficult to remember all
> the stats, bitmaps, and other subsystems that need to be updated whenever
> a PTE is modified. When a non-leaf PTE is marked non-present or becomes
> a leaf PTE, page table memory must also be freed. Further, most of the
> bookkeeping is done before the PTE is actually set. This works well with
> a monolithic MMU lock, however if changes use atomic compare/exchanges,
> the bookkeeping cannot be done before the change is made. In either
> case, there is a short window in which some statistics, e.g. the dirty
> bitmap will be inconsistent, however consistency is still restored
> before the MMU lock is released. To simplify the MMU and facilitate the
> use of atomic operations on PTEs, create functions to handle some of the
> bookkeeping required as a result of the change.

This is one case where splitting into multiple patches is probably not the
best option.  It's difficult to review this patch without seeing how
disconnected PTEs are used.  And, the patch is untestable for all intents
and purposes since there is no external caller, i.e. all of the calles are
self-referential within the new code.

> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu.c | 145 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 145 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 0311d18d9a995..50413f17c7cd0 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -143,6 +143,18 @@ module_param(dbg, bool, 0644);
>  #define SPTE_HOST_WRITEABLE	(1ULL << PT_FIRST_AVAIL_BITS_SHIFT)
>  #define SPTE_MMU_WRITEABLE	(1ULL << (PT_FIRST_AVAIL_BITS_SHIFT + 1))
>  
> +/*
> + * PTEs in a disconnected page table can be set to DISCONNECTED_PTE to indicate
> + * to other threads that the page table in which the pte resides is no longer
> + * connected to the root of a paging structure.
> + *
> + * This constant works because it is considered non-present on both AMD and
> + * Intel CPUs and does not create a L1TF vulnerability because the pfn section
> + * is zeroed out. PTE bit 57 is available to software, per vol 3, figure 28-1
> + * of the Intel SDM and vol 2, figures 5-18 to 5-21 of the AMD APM.
> + */
> +#define DISCONNECTED_PTE (1ull << 57)

Use BIT_ULL, ignore the bad examples in mmu.c :-)

> +
>  #define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)
>  
>  /* make pte_list_desc fit well in cache line */
> @@ -555,6 +567,16 @@ static int is_shadow_present_pte(u64 pte)
>  	return (pte != 0) && !is_mmio_spte(pte);
>  }
>  
> +static inline int is_disconnected_pte(u64 pte)
> +{
> +	return pte == DISCONNECTED_PTE;
> +}

An explicit comparsion scares me a bit, but that's just my off the cuff
reaction.  I'll come back to the meat of this series after turkey day.

> +
> +static int is_present_direct_pte(u64 pte)
> +{
> +	return is_shadow_present_pte(pte) && !is_disconnected_pte(pte);
> +}
> +
>  static int is_large_pte(u64 pte)
>  {
>  	return pte & PT_PAGE_SIZE_MASK;
> @@ -1659,6 +1681,129 @@ static bool __rmap_set_dirty(struct kvm *kvm, struct kvm_rmap_head *rmap_head)
>  	return flush;
>  }
>  
> +static void handle_changed_pte(struct kvm *kvm, int as_id, gfn_t gfn,
> +			       u64 old_pte, u64 new_pte, int level);
> +
> +/**
> + * mark_pte_disconnected - Mark a PTE as part of a disconnected PT
> + * @kvm: kvm instance
> + * @as_id: the address space of the paging structure the PTE was a part of
> + * @gfn: the base GFN that was mapped by the PTE
> + * @ptep: a pointer to the PTE to be marked disconnected
> + * @level: the level of the PT this PTE was a part of, when it was part of the
> + *	paging structure
> + */
> +static void mark_pte_disconnected(struct kvm *kvm, int as_id, gfn_t gfn,
> +				  u64 *ptep, int level)
> +{
> +	u64 old_pte;
> +
> +	old_pte = xchg(ptep, DISCONNECTED_PTE);
> +	BUG_ON(old_pte == DISCONNECTED_PTE);
> +
> +	handle_changed_pte(kvm, as_id, gfn, old_pte, DISCONNECTED_PTE, level);
> +}
> +
> +/**
> + * handle_disconnected_pt - Mark a PT as disconnected and handle associated
> + * bookkeeping and freeing
> + * @kvm: kvm instance
> + * @as_id: the address space of the paging structure the PT was a part of
> + * @pt_base_gfn: the base GFN that was mapped by the first PTE in the PT
> + * @pfn: The physical frame number of the disconnected PT page
> + * @level: the level of the PT, when it was part of the paging structure
> + *
> + * Given a pointer to a page table that has been removed from the paging
> + * structure and its level, recursively free child page tables and mark their
> + * entries as disconnected.
> + */
> +static void handle_disconnected_pt(struct kvm *kvm, int as_id,
> +				   gfn_t pt_base_gfn, kvm_pfn_t pfn, int level)
> +{
> +	int i;
> +	gfn_t gfn = pt_base_gfn;
> +	u64 *pt = pfn_to_kaddr(pfn);
> +
> +	for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
> +		/*
> +		 * Mark the PTE as disconnected so that no other thread will
> +		 * try to map in an entry there or try to free any child page
> +		 * table the entry might have pointed to.
> +		 */
> +		mark_pte_disconnected(kvm, as_id, gfn, &pt[i], level);
> +
> +		gfn += KVM_PAGES_PER_HPAGE(level);
> +	}
> +
> +	free_page((unsigned long)pt);
> +}
> +
> +/**
> + * handle_changed_pte - handle bookkeeping associated with a PTE change
> + * @kvm: kvm instance
> + * @as_id: the address space of the paging structure the PTE was a part of
> + * @gfn: the base GFN that was mapped by the PTE
> + * @old_pte: The value of the PTE before the atomic compare / exchange
> + * @new_pte: The value of the PTE after the atomic compare / exchange
> + * @level: the level of the PT the PTE is part of in the paging structure
> + *
> + * Handle bookkeeping that might result from the modification of a PTE.
> + * This function should be called in the same RCU read critical section as the
> + * atomic cmpxchg on the pte. This function must be called for all direct pte
> + * modifications except those which strictly emulate hardware, for example
> + * setting the dirty bit on a pte.
> + */
> +static void handle_changed_pte(struct kvm *kvm, int as_id, gfn_t gfn,
> +			       u64 old_pte, u64 new_pte, int level)
> +{
> +	bool was_present = is_present_direct_pte(old_pte);
> +	bool is_present = is_present_direct_pte(new_pte);
> +	bool was_leaf = was_present && is_last_spte(old_pte, level);
> +	bool pfn_changed = spte_to_pfn(old_pte) != spte_to_pfn(new_pte);
> +	int child_level;
> +
> +	BUG_ON(level > PT64_ROOT_MAX_LEVEL);
> +	BUG_ON(level < PT_PAGE_TABLE_LEVEL);
> +	BUG_ON(gfn % KVM_PAGES_PER_HPAGE(level));
> +
> +	/*
> +	 * The only times a pte should be changed from a non-present to
> +	 * non-present state is when an entry in an unlinked page table is
> +	 * marked as a disconnected PTE as part of freeing the page table,
> +	 * or an MMIO entry is installed/modified. In these cases there is
> +	 * nothing to do.
> +	 */
> +	if (!was_present && !is_present) {
> +		/*
> +		 * If this change is not on an MMIO PTE and not setting a PTE
> +		 * as disconnected, then it is unexpected. Log the change,
> +		 * though it should not impact the guest since both the former
> +		 * and current PTEs are nonpresent.
> +		 */
> +		WARN_ON((new_pte != DISCONNECTED_PTE) &&
> +			!is_mmio_spte(new_pte));
> +		return;
> +	}
> +
> +	if (was_present && !was_leaf && (pfn_changed || !is_present)) {
> +		/*
> +		 * The level of the page table being freed is one level lower
> +		 * than the level at which it is mapped.
> +		 */
> +		child_level = level - 1;
> +
> +		/*
> +		 * If there was a present non-leaf entry before, and now the
> +		 * entry points elsewhere, the lpage stats and dirty logging /
> +		 * access tracking status for all the entries the old pte
> +		 * pointed to must be updated and the page table pages it
> +		 * pointed to must be freed.
> +		 */
> +		handle_disconnected_pt(kvm, as_id, gfn, spte_to_pfn(old_pte),
> +				       child_level);
> +	}
> +}
> +
>  /**
>   * kvm_mmu_write_protect_pt_masked - write protect selected PT level pages
>   * @kvm: kvm instance
> -- 
> 2.23.0.444.g18eeb5a265-goog
> 
