Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2798710F4E1
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 03:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfLCCPS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 21:15:18 -0500
Received: from mga18.intel.com ([134.134.136.126]:35025 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725899AbfLCCPS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Dec 2019 21:15:18 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Dec 2019 18:15:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,271,1571727600"; 
   d="scan'208";a="204797838"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga008.jf.intel.com with ESMTP; 02 Dec 2019 18:15:14 -0800
Date:   Mon, 2 Dec 2019 18:15:14 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [RFC PATCH 13/28] kvm: mmu: Add an iterator for concurrent
 paging structure walks
Message-ID: <20191203021514.GK8120@linux.intel.com>
References: <20190926231824.149014-1-bgardon@google.com>
 <20190926231824.149014-14-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190926231824.149014-14-bgardon@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 26, 2019 at 04:18:09PM -0700, Ben Gardon wrote:
> Add a utility for concurrent paging structure traversals. This iterator
> uses several mechanisms to ensure that its accesses to paging structure
> memory are safe, and that memory can be freed safely in the face of
> lockless access. The purpose of the iterator is to create a unified
> pattern for concurrent paging structure traversals and simplify the
> implementation of other MMU functions.
> 
> This iterator implements a pre-order traversal of PTEs for a given GFN
> range within a given address space. The iterator abstracts away
> bookkeeping on successful changes to PTEs, retrying on failed PTE
> modifications, TLB flushing, and yielding during long operations.
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/x86/kvm/mmu.c      | 455 ++++++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/mmutrace.h |  50 +++++
>  2 files changed, 505 insertions(+)

...

> +/*
> + * Sets a direct walk iterator to seek the gfn range [start, end).
> + * If end is greater than the maximum possible GFN, it will be changed to the
> + * maximum possible gfn + 1. (Note that start/end is and inclusive/exclusive
> + * range, so the last gfn to be interated over would be the largest possible
> + * GFN, in this scenario.)
> + */
> +__attribute__((unused))
> +static void direct_walk_iterator_setup_walk(struct direct_walk_iterator *iter,
> +	struct kvm *kvm, int as_id, gfn_t start, gfn_t end,
> +	enum mmu_lock_mode lock_mode)

Echoing earlier patches, please introduce variables/flags/functions along
with their users.  I have a feeling you're adding some of the unused
functions so that all flags/variables in struct direct_walk_iterator can
be in place from the get-go, but that actually makes everything much harder
to review.

> +{
> +	BUG_ON(!kvm->arch.direct_mmu_enabled);
> +	BUG_ON((lock_mode & MMU_WRITE_LOCK) && (lock_mode & MMU_READ_LOCK));
> +	BUG_ON(as_id < 0);
> +	BUG_ON(as_id >= KVM_ADDRESS_SPACE_NUM);
> +	BUG_ON(!VALID_PAGE(kvm->arch.direct_root_hpa[as_id]));
> +
> +	/* End cannot be greater than the maximum possible gfn. */
> +	end = min(end, 1ULL << (PT64_ROOT_4LEVEL * PT64_PT_BITS));
> +
> +	iter->as_id = as_id;
> +	iter->pt_path[PT64_ROOT_4LEVEL - 1] =
> +			(u64 *)__va(kvm->arch.direct_root_hpa[as_id]);
> +
> +	iter->walk_start = start;
> +	iter->walk_end = end;
> +	iter->target_gfn = start;
> +
> +	iter->lock_mode = lock_mode;
> +	iter->kvm = kvm;
> +	iter->tlbs_dirty = 0;
> +
> +	direct_walk_iterator_start_traversal(iter);
> +}

...

> +static void direct_walk_iterator_cond_resched(struct direct_walk_iterator *iter)
> +{
> +	if (!(iter->lock_mode & MMU_LOCK_MAY_RESCHED) || !need_resched())
> +		return;
> +
> +	direct_walk_iterator_prepare_cond_resched(iter);
> +	cond_resched();
> +	direct_walk_iterator_finish_cond_resched(iter);
> +}
> +
> +static bool direct_walk_iterator_next_pte(struct direct_walk_iterator *iter)
> +{
> +	/*
> +	 * This iterator could be iterating over a large number of PTEs, such
> +	 * that if this thread did not yield, it would cause scheduler\
> +	 * problems. To avoid this, yield if needed. Note the check on
> +	 * MMU_LOCK_MAY_RESCHED in direct_walk_iterator_cond_resched. This
> +	 * iterator will not yield unless that flag is set in its lock_mode.
> +	 */
> +	direct_walk_iterator_cond_resched(iter);

This looks very fragile, e.g. one of the future patches even has to avoid
problems with this code by limiting the number of PTEs it processes.

> +
> +	while (true) {
> +		if (!direct_walk_iterator_next_pte_raw(iter))

Implicitly initializing the iterator during next_pte_raw() is asking for
problems, e.g. @walk_in_progress should not exist.  The standard kernel
pattern for fancy iterators is to wrap the initialization, deref, and
advancement operators in a macro, e.g. something like:

	for_each_direct_pte(...) {

	}

That might require additional control flow logic in the users of the
iterator, but if so that's probably a good thing in terms of readability
and robustness.  E.g. verifying that rcu_read_unlock() is guaranteed to
be called is extremely difficult as rcu_read_lock() is buried in this
low level helper but the iterator relies on the top-level caller to
terminate traversal.

See mem_cgroup_iter_break() for one example of handling an iter walk
where an action needs to taken when the walk terminates early.

> +			return false;
> +
> +		direct_walk_iterator_recalculate_output_fields(iter);
> +		if (iter->old_pte != DISCONNECTED_PTE)
> +			break;
> +
> +		/*
> +		 * The iterator has encountered a disconnected pte, so it is in
> +		 * a page that has been disconnected from the root. Restart the
> +		 * traversal from the root in this case.
> +		 */
> +		direct_walk_iterator_reset_traversal(iter);

I understand wanting to hide details to eliminate copy-paste, but this
goes too far and makes it too difficult to understand the flow of the
top-level walks.  Ditto for burying retry_pte() in set_pte().  I'd say it
also applies to skip_step_down(), but AFAICT that's dead code.

Off-topic for a second, the super long direct_walk_iterator_... names
make me want to simply call this new MMU the "tdp MMU" and just live with
the discrepancy until the old shadow-based TDP MMU can be nuked.  Then we
could have tdp_iter_blah_blah_blah(), for_each_tdp_present_pte(), etc...

Back to the iterator, I think it can be massaged into a standard for loop
approach without polluting the top level walkers much.  The below code is
the basic idea, e.g. the macros won't compile, probably doesn't terminate
the walk correct, rescheduling is missing, etc...

Note, open coding the down/sideways/up helpers is 50% personal preference,
50% because gfn_start and gfn_end are now local variables, and 50% because
it was the easiest way to learn the code.  I wouldn't argue too much about
having one or more of the helpers.


static void tdp_iter_break(struct tdp_iter *iter)
{
	/* TLB flush, RCU unlock, etc...)
}

static void tdp_iter_next(struct tdp_iter *iter, bool *retry)
{
	gfn_t gfn_start, gfn_end;
	u64 *child_pt;

	if (*retry) {
		*retry = false;
		return;
	}

	/*
	 * Reread the pte before stepping down to avoid traversing into page
	 * tables that are no longer linked from this entry. This is not
	 * needed for correctness - just a small optimization.
	 */
	iter->old_pte = READ_ONCE(*iter->ptep);

	/* Try to step down. */
	child_pt = pte_to_child_pt(iter->old_pte, iter->level);
	if (child_pt) {
		child_pt = rcu_dereference(child_pt);
		iter->level--;
		iter->pt_path[iter->level - 1] = child_pt;
		return;
	}

step_sideways:
	/* Try to step sideways. */
	gfn_start = ALIGN_DOWN(iter->target_gfn,
			       KVM_PAGES_PER_HPAGE(iter->level));
	gfn_end = gfn_start + KVM_PAGES_PER_HPAGE(iter->level)

	/*
	 * If the current gfn maps past the target gfn range, the next entry in
	 * the current page table will be outside the target range.
	 */
	if (gfn_end >= iter->walk_end ||
	    !(gfn_end % KVM_PAGES_PER_HPAGE(iter->level + 1))) {
		/* Try to step up. */
		iter->level++;

		if (iter->level > PT64_ROOT_4LEVEL; {
			/* This is ugly, there's probably a better solution. */
			tdp_iter_break(iter);
			return;
		}
		goto step_sideways;
	}

	iter->target_gfn = gfn_end;
	iter->ptep = iter->pt_path[iter->level - 1] +
			PT64_INDEX(iter->target_gfn << PAGE_SHIFT, iter->level);
	iter->old_pte = READ_ONCE(*iter->ptep);
}

#define for_each_tdp_pte(iter, start, end, retry)
	for (tdp_iter_start(&iter, start, end);
	     iter->level <= PT64_ROOT_4LEVEL;
	     tdp_iter_next(&iter, &retry))

#define for_each_tdp_present_pte(iter, start, end, retry)
	for_each_tdp_pte(iter, start, end, retry)
		if (!is_present_direct_pte(iter->old_pte)) {

		} else

#define for_each_tdp_present_leaf_pte(iter, start, end, retry)
	for_each_tdp_pte(iter, start, end, retry)
		if (!is_present_direct_pte(iter->old_pte) ||
		    !is_last_spte(iter->old_pte, iter->level))
		{

		} else

/*
 * Marks the range of gfns, [start, end), non-present.
 */
static bool zap_direct_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
				 gfn_t end, enum mmu_lock_mode lock_mode)
{
	struct direct_walk_iterator iter;
	bool retry;

	tdp_iter_init(&iter, kvm, as_id, lock_mode);

restart:
	retry = false;
	for_each_tdp_present_pte(iter, start, end, retry) {
		if (tdp_iter_set_pte(&iter, 0))
			retry = true;

		if (tdp_iter_disconnected(&iter)) {
			tdp_iter_break(&iter);
			goto restart;
		}
	}
}

