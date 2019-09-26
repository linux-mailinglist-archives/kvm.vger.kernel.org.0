Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9DBBFBD1
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 01:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728939AbfIZXS7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 19:18:59 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:47674 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729000AbfIZXS7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 19:18:59 -0400
Received: by mail-pf1-f201.google.com with SMTP id t65so490632pfd.14
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 16:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=x+VzNiLJHjNZuhYKHwySsWShXnowbtgPFa+qtIsFFJY=;
        b=jcCv9GmsNfyrMTWIoGIXXAx3XRrSLUhhpyMMdimXIhPWyh5w5mjfAJZ7CklyVFeWV3
         ryzq6XzPPoo4C5rYKTgMA5aboTcp19K1M0RHEBVPnMx01j3t18Biac4FTrakKcWQ+DZR
         B9r/kAhZG/p2LgxNHn0zrmVMwExtQY6snxq9GsO/3DgMcYgZornZV3IigWTFptg5sNBn
         fmqZCtJonlk5QHvUhm5R+J79t4syxdpBqOjn8SGNfjR13lvQQrELYQsqZavzdEX383rJ
         evHAYkLFkJy54DONF4YDVGS/6be0V6gFa3RDgBU0PWs7hdmKclV+Q2PJ0adlb2VQAQhY
         +fJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=x+VzNiLJHjNZuhYKHwySsWShXnowbtgPFa+qtIsFFJY=;
        b=hvOHBW24utFRp6zeUsUYF8qinuupvKYqeQyYtJ7mtFzh68ZtWpJOsfaNwHxuRG7NNT
         ZZA05JRhE8udT2KAGa6ldsBX90jL6Rv4zMECXA9Dby6ODzaz5plEz8xbsqJsFvToJ3ci
         F1LTyas8bkr/jy2YQaEwvW4VMBx/8PxxXrlnEWZDknQNZfXYAfmhj0QRdijo27UUPu3A
         aVw/tCiXnQsB8aDVc8V2ZhSzPsyTP/hAMZwRqh02pUSBBHHfRypKSYcL2hUs6wqBr8uB
         X6a73cuXVtDDNjWOBCd0Or1yF7rvIa0wcJcUj2mX83W5TVcpiI700d0qsWI7oIXwY3fs
         9fNg==
X-Gm-Message-State: APjAAAV0MwITXXr4ZwEcjFjH+zPoWIUCski5EdvCWMm0Tmt9DDgq9tm7
        QQakKPDSzW001rvY/cpa86HcsPwjaCkPSZRl8zSY06weBQS45rrYx6CqDT6VEqm5sQTnhGCVahv
        2glOA7JZyjOMqXTszSOnViULKfQZEreqvQ+O9wwHpux6wKDggBGn+2RABGJ0M
X-Google-Smtp-Source: APXvYqzD11vasZoAfJTdFcItsEwIjGHLbYchuPXaUVpHfnaW7z0twc3Cl202wjq9UtfWqKIaWxgI6oo2vfvu
X-Received: by 2002:a65:5648:: with SMTP id m8mr6141682pgs.37.1569539937612;
 Thu, 26 Sep 2019 16:18:57 -0700 (PDT)
Date:   Thu, 26 Sep 2019 16:18:09 -0700
In-Reply-To: <20190926231824.149014-1-bgardon@google.com>
Message-Id: <20190926231824.149014-14-bgardon@google.com>
Mime-Version: 1.0
References: <20190926231824.149014-1-bgardon@google.com>
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
Subject: [RFC PATCH 13/28] kvm: mmu: Add an iterator for concurrent paging
 structure walks
From:   Ben Gardon <bgardon@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a utility for concurrent paging structure traversals. This iterator
uses several mechanisms to ensure that its accesses to paging structure
memory are safe, and that memory can be freed safely in the face of
lockless access. The purpose of the iterator is to create a unified
pattern for concurrent paging structure traversals and simplify the
implementation of other MMU functions.

This iterator implements a pre-order traversal of PTEs for a given GFN
range within a given address space. The iterator abstracts away
bookkeeping on successful changes to PTEs, retrying on failed PTE
modifications, TLB flushing, and yielding during long operations.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu.c      | 455 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmutrace.h |  50 +++++
 2 files changed, 505 insertions(+)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 263718d49f730..59d1866398c42 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1948,6 +1948,461 @@ static void handle_changed_pte(struct kvm *kvm, int as_id, gfn_t gfn,
 	}
 }
 
+/*
+ * Given a host page table entry and its level, returns a pointer containing
+ * the host virtual address of the child page table referenced by the page table
+ * entry. Returns null if there is no such entry.
+ */
+static u64 *pte_to_child_pt(u64 pte, int level)
+{
+	u64 *pt;
+	/* There's no child entry if this entry isn't present */
+	if (!is_present_direct_pte(pte))
+		return NULL;
+
+	/* There is no child page table if this is a leaf entry. */
+	if (is_last_spte(pte, level))
+		return NULL;
+
+	pt = (u64 *)__va(pte & PT64_BASE_ADDR_MASK);
+	return pt;
+}
+
+enum mmu_lock_mode {
+	MMU_NO_LOCK = 0,
+	MMU_READ_LOCK = 1,
+	MMU_WRITE_LOCK = 2,
+	MMU_LOCK_MAY_RESCHED = 4
+};
+
+/*
+ * A direct walk iterator encapsulates a walk through a direct paging structure.
+ * It handles ensuring that the walk uses RCU to safely access page table
+ * memory.
+ */
+struct direct_walk_iterator {
+	/* Internal */
+	gfn_t walk_start;
+	gfn_t walk_end;
+	gfn_t target_gfn;
+	long tlbs_dirty;
+
+	/* the address space id. */
+	int as_id;
+	u64 *pt_path[PT64_ROOT_4LEVEL];
+	bool walk_in_progress;
+
+	/*
+	 * If set, the next call to direct_walk_iterator_next_pte_raw will
+	 * simply reread the current pte and return. This is useful in cases
+	 * where a thread misses a race to set a pte and wants to retry. This
+	 * should be set with a call to direct_walk_iterator_retry_pte.
+	 */
+	bool retry_pte;
+
+	/*
+	 * If set, the next call to direct_walk_iterator_next_pte_raw will not
+	 * step down to a lower level on its next step, even if it is at a
+	 * present, non-leaf pte. This is useful when, for example, splitting
+	 * pages, since we know that the entries below the now split page don't
+	 * need to be handled again.
+	 */
+	bool skip_step_down;
+
+	enum mmu_lock_mode lock_mode;
+	struct kvm *kvm;
+
+	/* Output */
+
+	/* The iterator's current level within the paging structure */
+	int level;
+	/* A pointer to the current PTE */
+	u64 *ptep;
+	/* The a snapshot of the PTE pointed to by ptep */
+	u64 old_pte;
+	/* The lowest GFN mapped by the current PTE */
+	gfn_t pte_gfn_start;
+	/* The highest GFN mapped by the current PTE, + 1 */
+	gfn_t pte_gfn_end;
+};
+
+static void direct_walk_iterator_start_traversal(
+		struct direct_walk_iterator *iter)
+{
+	int level;
+
+	/*
+	 * Only clear the levels below the root. The root level page table is
+	 * allocated at VM creation time and will never change for the life of
+	 * the VM.
+	 */
+	for (level = PT_PAGE_TABLE_LEVEL; level < PT64_ROOT_4LEVEL; level++)
+		iter->pt_path[level - 1] = NULL;
+	iter->level = 0;
+	iter->ptep = NULL;
+	iter->old_pte = 0;
+	iter->pte_gfn_start = 0;
+	iter->pte_gfn_end = 0;
+	iter->walk_in_progress = false;
+	iter->retry_pte = false;
+	iter->skip_step_down = false;
+}
+
+static bool direct_walk_iterator_flush_needed(struct direct_walk_iterator *iter)
+{
+	long tlbs_dirty;
+
+	if (iter->tlbs_dirty) {
+		tlbs_dirty = xadd(&iter->kvm->tlbs_dirty, iter->tlbs_dirty) +
+				iter->tlbs_dirty;
+		iter->tlbs_dirty = 0;
+	} else {
+		tlbs_dirty = READ_ONCE(iter->kvm->tlbs_dirty);
+	}
+
+	return (iter->lock_mode & MMU_WRITE_LOCK) && tlbs_dirty;
+}
+
+static bool direct_walk_iterator_end_traversal(
+		struct direct_walk_iterator *iter)
+{
+	if (iter->walk_in_progress)
+		rcu_read_unlock();
+	return direct_walk_iterator_flush_needed(iter);
+}
+
+/*
+ * Resets a direct walk iterator to the root of the paging structure and RCU
+ * unlocks. After calling this function, the traversal can be reattempted.
+ */
+static void direct_walk_iterator_reset_traversal(
+		struct direct_walk_iterator *iter)
+{
+	/*
+	 * It's okay it ignore the return value, indicating whether a TLB flush
+	 * is needed here because we are ending and then restarting the
+	 * traversal without releasing the MMU lock. At this point the
+	 * iterator tlbs_dirty will have been flushed to the kvm tlbs_dirty, so
+	 * the next end_traversal will return that a flush is needed, if there's
+	 * not an intervening flush for some other reason.
+	 */
+	direct_walk_iterator_end_traversal(iter);
+	direct_walk_iterator_start_traversal(iter);
+}
+
+/*
+ * Sets a direct walk iterator to seek the gfn range [start, end).
+ * If end is greater than the maximum possible GFN, it will be changed to the
+ * maximum possible gfn + 1. (Note that start/end is and inclusive/exclusive
+ * range, so the last gfn to be interated over would be the largest possible
+ * GFN, in this scenario.)
+ */
+__attribute__((unused))
+static void direct_walk_iterator_setup_walk(struct direct_walk_iterator *iter,
+	struct kvm *kvm, int as_id, gfn_t start, gfn_t end,
+	enum mmu_lock_mode lock_mode)
+{
+	BUG_ON(!kvm->arch.direct_mmu_enabled);
+	BUG_ON((lock_mode & MMU_WRITE_LOCK) && (lock_mode & MMU_READ_LOCK));
+	BUG_ON(as_id < 0);
+	BUG_ON(as_id >= KVM_ADDRESS_SPACE_NUM);
+	BUG_ON(!VALID_PAGE(kvm->arch.direct_root_hpa[as_id]));
+
+	/* End cannot be greater than the maximum possible gfn. */
+	end = min(end, 1ULL << (PT64_ROOT_4LEVEL * PT64_PT_BITS));
+
+	iter->as_id = as_id;
+	iter->pt_path[PT64_ROOT_4LEVEL - 1] =
+			(u64 *)__va(kvm->arch.direct_root_hpa[as_id]);
+
+	iter->walk_start = start;
+	iter->walk_end = end;
+	iter->target_gfn = start;
+
+	iter->lock_mode = lock_mode;
+	iter->kvm = kvm;
+	iter->tlbs_dirty = 0;
+
+	direct_walk_iterator_start_traversal(iter);
+}
+
+__attribute__((unused))
+static void direct_walk_iterator_retry_pte(struct direct_walk_iterator *iter)
+{
+	BUG_ON(!iter->walk_in_progress);
+	iter->retry_pte = true;
+}
+
+__attribute__((unused))
+static void direct_walk_iterator_skip_step_down(
+		struct direct_walk_iterator *iter)
+{
+	BUG_ON(!iter->walk_in_progress);
+	iter->skip_step_down = true;
+}
+
+/*
+ * Steps down one level in the paging structure towards the previously set
+ * target gfn. Returns true if the iterator was able to step down a level,
+ * false otherwise.
+ */
+static bool direct_walk_iterator_try_step_down(
+		struct direct_walk_iterator *iter)
+{
+	u64 *child_pt;
+
+	/*
+	 * Reread the pte before stepping down to avoid traversing into page
+	 * tables that are no longer linked from this entry. This is not
+	 * needed for correctness - just a small optimization.
+	 */
+	iter->old_pte = READ_ONCE(*iter->ptep);
+
+	child_pt = pte_to_child_pt(iter->old_pte, iter->level);
+	if (child_pt == NULL)
+		return false;
+	child_pt = rcu_dereference(child_pt);
+
+	iter->level--;
+	iter->pt_path[iter->level - 1] = child_pt;
+	return true;
+}
+
+/*
+ * Steps to the next entry in the current page table, at the current page table
+ * level. The next entry could map a page of guest memory, another page table,
+ * or it could be non-present or invalid. Returns true if the iterator was able
+ * to step to the next entry in the page table, false otherwise.
+ */
+static bool direct_walk_iterator_try_step_side(
+		struct direct_walk_iterator *iter)
+{
+	/*
+	 * If the current gfn maps past the target gfn range, the next entry in
+	 * the current page table will be outside the target range.
+	 */
+	if (iter->pte_gfn_end >= iter->walk_end)
+		return false;
+
+	/*
+	 * Check if the iterator is already at the end of the current page
+	 * table.
+	 */
+	if (!(iter->pte_gfn_end % KVM_PAGES_PER_HPAGE(iter->level + 1)))
+		return false;
+
+	iter->target_gfn = iter->pte_gfn_end;
+	return true;
+}
+
+/*
+ * Tries to back up a level in the paging structure so that the walk can
+ * continue from the next entry in the parent page table. Returns true on a
+ * successful step up, false otherwise.
+ */
+static bool direct_walk_iterator_try_step_up(struct direct_walk_iterator *iter)
+{
+	if (iter->level == PT64_ROOT_4LEVEL)
+		return false;
+
+	iter->level++;
+	return true;
+}
+
+/*
+ * Step to the next pte in a pre-order traversal of the target gfn range.
+ * To get to the next pte, the iterator either steps down towards the current
+ * target gfn, if at a present, non-leaf pte, or over to a pte mapping a
+ * highter gfn, if there's room in the gfn range. If there is no step within
+ * the target gfn range, returns false.
+ */
+static bool direct_walk_iterator_next_pte_raw(struct direct_walk_iterator *iter)
+{
+	bool retry_pte = iter->retry_pte;
+	bool skip_step_down = iter->skip_step_down;
+
+	iter->retry_pte = false;
+	iter->skip_step_down = false;
+
+	if (iter->target_gfn >= iter->walk_end)
+		return false;
+
+	/* If the walk is just starting, set up initial values. */
+	if (!iter->walk_in_progress) {
+		rcu_read_lock();
+
+		iter->level = PT64_ROOT_4LEVEL;
+		iter->walk_in_progress = true;
+		return true;
+	}
+
+	if (retry_pte)
+		return true;
+
+	if (!skip_step_down && direct_walk_iterator_try_step_down(iter))
+		return true;
+
+	while (!direct_walk_iterator_try_step_side(iter))
+		if (!direct_walk_iterator_try_step_up(iter))
+			return false;
+	return true;
+}
+
+static void direct_walk_iterator_recalculate_output_fields(
+		struct direct_walk_iterator *iter)
+{
+	iter->ptep = iter->pt_path[iter->level - 1] +
+			PT64_INDEX(iter->target_gfn << PAGE_SHIFT, iter->level);
+	iter->old_pte = READ_ONCE(*iter->ptep);
+	iter->pte_gfn_start = ALIGN_DOWN(iter->target_gfn,
+			KVM_PAGES_PER_HPAGE(iter->level));
+	iter->pte_gfn_end = iter->pte_gfn_start +
+			KVM_PAGES_PER_HPAGE(iter->level);
+}
+
+static void direct_walk_iterator_prepare_cond_resched(
+		struct direct_walk_iterator *iter)
+{
+	if (direct_walk_iterator_end_traversal(iter))
+		kvm_flush_remote_tlbs(iter->kvm);
+
+	if (iter->lock_mode & MMU_WRITE_LOCK)
+		write_unlock(&iter->kvm->mmu_lock);
+	else if (iter->lock_mode & MMU_READ_LOCK)
+		read_unlock(&iter->kvm->mmu_lock);
+
+}
+
+static void direct_walk_iterator_finish_cond_resched(
+		struct direct_walk_iterator *iter)
+{
+	if (iter->lock_mode & MMU_WRITE_LOCK)
+		write_lock(&iter->kvm->mmu_lock);
+	else if (iter->lock_mode & MMU_READ_LOCK)
+		read_lock(&iter->kvm->mmu_lock);
+
+	direct_walk_iterator_start_traversal(iter);
+}
+
+static void direct_walk_iterator_cond_resched(struct direct_walk_iterator *iter)
+{
+	if (!(iter->lock_mode & MMU_LOCK_MAY_RESCHED) || !need_resched())
+		return;
+
+	direct_walk_iterator_prepare_cond_resched(iter);
+	cond_resched();
+	direct_walk_iterator_finish_cond_resched(iter);
+}
+
+static bool direct_walk_iterator_next_pte(struct direct_walk_iterator *iter)
+{
+	/*
+	 * This iterator could be iterating over a large number of PTEs, such
+	 * that if this thread did not yield, it would cause scheduler\
+	 * problems. To avoid this, yield if needed. Note the check on
+	 * MMU_LOCK_MAY_RESCHED in direct_walk_iterator_cond_resched. This
+	 * iterator will not yield unless that flag is set in its lock_mode.
+	 */
+	direct_walk_iterator_cond_resched(iter);
+
+	while (true) {
+		if (!direct_walk_iterator_next_pte_raw(iter))
+			return false;
+
+		direct_walk_iterator_recalculate_output_fields(iter);
+		if (iter->old_pte != DISCONNECTED_PTE)
+			break;
+
+		/*
+		 * The iterator has encountered a disconnected pte, so it is in
+		 * a page that has been disconnected from the root. Restart the
+		 * traversal from the root in this case.
+		 */
+		direct_walk_iterator_reset_traversal(iter);
+	}
+
+	trace_kvm_mmu_direct_walk_iterator_step(iter->walk_start,
+			iter->walk_end, iter->pte_gfn_start,
+			iter->level, iter->old_pte);
+
+	return true;
+}
+
+/*
+ * As direct_walk_iterator_next_pte but skips over non-present ptes.
+ * (i.e. ptes that are 0 or invalidated.)
+ */
+static bool direct_walk_iterator_next_present_pte(
+		struct direct_walk_iterator *iter)
+{
+	while (direct_walk_iterator_next_pte(iter))
+		if (is_present_direct_pte(iter->old_pte))
+			return true;
+
+	return false;
+}
+
+/*
+ * As direct_walk_iterator_next_present_pte but skips over non-leaf ptes.
+ */
+__attribute__((unused))
+static bool direct_walk_iterator_next_present_leaf_pte(
+		struct direct_walk_iterator *iter)
+{
+	while (direct_walk_iterator_next_present_pte(iter))
+		if (is_last_spte(iter->old_pte, iter->level))
+			return true;
+
+	return false;
+}
+
+/*
+ * Performs an atomic compare / exchange of ptes.
+ * Returns true if the pte was successfully set to the new value, false if the
+ * there was a race and the compare exchange needs to be retried.
+ */
+static bool cmpxchg_pte(u64 *ptep, u64 old_pte, u64 new_pte, int level, u64 gfn)
+{
+	u64 r;
+
+	r = cmpxchg64(ptep, old_pte, new_pte);
+	if (r == old_pte)
+		trace_kvm_mmu_set_pte_atomic(gfn, level, old_pte, new_pte);
+
+	return r == old_pte;
+}
+
+__attribute__((unused))
+static bool direct_walk_iterator_set_pte(struct direct_walk_iterator *iter,
+					 u64 new_pte)
+{
+	bool r;
+
+	if (!(iter->lock_mode & (MMU_READ_LOCK | MMU_WRITE_LOCK))) {
+		BUG_ON(is_present_direct_pte(iter->old_pte) !=
+				is_present_direct_pte(new_pte));
+		BUG_ON(spte_to_pfn(iter->old_pte) != spte_to_pfn(new_pte));
+		BUG_ON(is_last_spte(iter->old_pte, iter->level) !=
+				is_last_spte(new_pte, iter->level));
+	}
+
+	if (iter->old_pte == new_pte)
+		return true;
+
+	r = cmpxchg_pte(iter->ptep, iter->old_pte, new_pte, iter->level,
+			iter->pte_gfn_start);
+	if (r) {
+		handle_changed_pte(iter->kvm, iter->as_id, iter->pte_gfn_start,
+				   iter->old_pte, new_pte, iter->level, false);
+
+		if (iter->lock_mode & (MMU_WRITE_LOCK | MMU_READ_LOCK))
+			iter->tlbs_dirty++;
+	} else
+		direct_walk_iterator_retry_pte(iter);
+
+	return r;
+}
+
 /**
  * kvm_mmu_write_protect_pt_masked - write protect selected PT level pages
  * @kvm: kvm instance
diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
index 7ca8831c7d1a2..530723038296a 100644
--- a/arch/x86/kvm/mmutrace.h
+++ b/arch/x86/kvm/mmutrace.h
@@ -166,6 +166,56 @@ TRACE_EVENT(
 		  __entry->created ? "new" : "existing")
 );
 
+TRACE_EVENT(
+	kvm_mmu_direct_walk_iterator_step,
+	TP_PROTO(u64 walk_start, u64 walk_end, u64 base_gfn, int level,
+		u64 pte),
+	TP_ARGS(walk_start, walk_end, base_gfn, level, pte),
+
+	TP_STRUCT__entry(
+		__field(u64, walk_start)
+		__field(u64, walk_end)
+		__field(u64, base_gfn)
+		__field(int, level)
+		__field(u64, pte)
+		),
+
+	TP_fast_assign(
+		__entry->walk_start = walk_start;
+		__entry->walk_end = walk_end;
+		__entry->base_gfn = base_gfn;
+		__entry->level = level;
+		__entry->pte = pte;
+		),
+
+	TP_printk("walk_start=%llx walk_end=%llx base_gfn=%llx lvl=%d pte=%llx",
+		__entry->walk_start, __entry->walk_end, __entry->base_gfn,
+		__entry->level, __entry->pte)
+);
+
+TRACE_EVENT(
+	kvm_mmu_set_pte_atomic,
+	TP_PROTO(u64 gfn, int level, u64 old_pte, u64 new_pte),
+	TP_ARGS(gfn, level, old_pte, new_pte),
+
+	TP_STRUCT__entry(
+		__field(u64, gfn)
+		__field(int, level)
+		__field(u64, old_pte)
+		__field(u64, new_pte)
+		),
+
+	TP_fast_assign(
+		__entry->gfn = gfn;
+		__entry->level = level;
+		__entry->old_pte = old_pte;
+		__entry->new_pte = new_pte;
+		),
+
+	TP_printk("gfn=%llx level=%d old_pte=%llx new_pte=%llx", __entry->gfn,
+		  __entry->level, __entry->old_pte, __entry->new_pte)
+);
+
 DECLARE_EVENT_CLASS(kvm_mmu_page_class,
 
 	TP_PROTO(struct kvm_mmu_page *sp),
-- 
2.23.0.444.g18eeb5a265-goog

