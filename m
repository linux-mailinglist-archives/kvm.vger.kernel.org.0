Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2263A30CB39
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 20:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbhBBTRX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 14:17:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239243AbhBBTBl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 14:01:41 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98DEBC0611C1
        for <kvm@vger.kernel.org>; Tue,  2 Feb 2021 10:58:09 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id 145so5495500pgh.2
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 10:58:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=PUjq1PmHRqanFbRtZvCFLqPwTIM7m5ji/Z5EVfp8UJ8=;
        b=S8YoCVyZ5DUGM/oyyP1/qwQro5DsIPqTY6Y1+CcTD0/eSiHuZ+wC6F/vv+lJYMn1GF
         zmMfNsOpL3FDjIjQpXp0zVjwj1sOjPCnUszIBDTbVHpranL+1sOktF3yz/Db2q+R7t3a
         bzV+jsXbk0NjTUoRNiwgzzVzXI1tdRAw9J7S4okJsAm3vElMp1GXXGnhtLmLR0LfZ9+1
         8rFNExDgFKrOPOWUxM3JZKL3cMwhp7cTrCxOURH5jU5TPa1mPJxsdI/eS+2J9Z5nG9Na
         PMFG44qctZTLbo4NgfGJDLY6KgvVpM0bes0o/BphFflY4DaGoaXZNgTuwfbe6elg84Sp
         O5pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=PUjq1PmHRqanFbRtZvCFLqPwTIM7m5ji/Z5EVfp8UJ8=;
        b=p0lrSjPQ1BYeIg0vWSklq4zwqP5/d8wFTN265yXVNbbV0Chd3h+ZT2MMIUYALfZAUH
         hhQ/VOUybPeHP1o0nRWAjFPdzTJVbpUWElKVDCdEOMndYeyU3U3CJbSSKHN8MxZYdIQ4
         B+k2U7o6WaJYNUDAtRTcxBflVpeLUoHF6rzO74sQKcPz8Cq5partX946iZEFWmiSfyal
         9VL1aaZYMfchc8fUiiCYOesZRYDBBNrTsjg9up8Qhauv7n175Nqel/XLSW04H5doTrfX
         lYC94oPYXY2W+9+e1ZFFWSJyLzftwnUAL9nYqbzHXzvJhyz3w1KzIe9pOpCQcM0HG6ON
         hB1A==
X-Gm-Message-State: AOAM532v3FzfeUgxJbukNew2PYlRmu6gAs53dd5Dc4akOF7MDu/VTClL
        iA11gPBJpN47PrqkYivPFI0BD/v3ZjlR
X-Google-Smtp-Source: ABdhPJxGKEq11F1hW7rwkQqAfEKRiHg/+xDfc56d7O/I/IKDaG6iyUQlp3+GiAtQ891MZ5Zg9FgRglVpH6BT
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:9090:561:5a98:6d47])
 (user=bgardon job=sendgmr) by 2002:a17:90a:3f08:: with SMTP id
 l8mr614277pjc.1.1612292288437; Tue, 02 Feb 2021 10:58:08 -0800 (PST)
Date:   Tue,  2 Feb 2021 10:57:23 -0800
In-Reply-To: <20210202185734.1680553-1-bgardon@google.com>
Message-Id: <20210202185734.1680553-18-bgardon@google.com>
Mime-Version: 1.0
References: <20210202185734.1680553-1-bgardon@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH v2 17/28] KVM: x86/mmu: Protect TDP MMU page table memory with RCU
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to enable concurrent modifications to the paging structures in
the TDP MMU, threads must be able to safely remove pages of page table
memory while other threads are traversing the same memory. To ensure
threads do not access PT memory after it is freed, protect PT memory
with RCU.

Protecting concurrent accesses to page table memory from use-after-free
bugs could also have been acomplished using
walk_shadow_page_lockless_begin/end() and READING_SHADOW_PAGE_TABLES,
coupling with the barriers in a TLB flush. The use of RCU for this case
has several distinct advantages over that approach.
1. Disabling interrupts for long running operations is not desirable.
   Future commits will allow operations besides page faults to operate
   without the exclusive protection of the MMU lock and those operations
   are too long to disable iterrupts for their duration.
2. The use of RCU here avoids long blocking / spinning operations in
   perfromance critical paths. By freeing memory with an asynchronous
   RCU API we avoid the longer wait times TLB flushes experience when
   overlapping with a thread in walk_shadow_page_lockless_begin/end().
3. RCU provides a separation of concerns when removing memory from the
   paging structure. Because the RCU callback to free memory can be
   scheduled immediately after a TLB flush, there's no need for the
   thread to manually free a queue of pages later, as commit_zap_pages
   does.

Fixes: 95fb5b0258b7 ("kvm: x86/mmu: Support MMIO in the TDP MMU")
Reviewed-by: Peter Feiner <pfeiner@google.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ben Gardon <bgardon@google.com>

---

v1 -> v2
- Moved RCU read unlock before the TLB flush
- Merged the RCU commits from v1 into a single commit
- Changed the way accesses to page table memory are annotated with RCU
  in the TDP iterator

 arch/x86/kvm/mmu/mmu_internal.h |  3 ++
 arch/x86/kvm/mmu/tdp_iter.c     | 16 +++---
 arch/x86/kvm/mmu/tdp_iter.h     | 10 ++--
 arch/x86/kvm/mmu/tdp_mmu.c      | 95 +++++++++++++++++++++++++++++----
 4 files changed, 103 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index bfc6389edc28..7f599cc64178 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -57,6 +57,9 @@ struct kvm_mmu_page {
 	atomic_t write_flooding_count;
 
 	bool tdp_mmu_page;
+
+	/* Used for freeing the page asyncronously if it is a TDP MMU page. */
+	struct rcu_head rcu_head;
 };
 
 extern struct kmem_cache *mmu_page_header_cache;
diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
index 1a09d212186b..e5f148106e20 100644
--- a/arch/x86/kvm/mmu/tdp_iter.c
+++ b/arch/x86/kvm/mmu/tdp_iter.c
@@ -12,7 +12,7 @@ static void tdp_iter_refresh_sptep(struct tdp_iter *iter)
 {
 	iter->sptep = iter->pt_path[iter->level - 1] +
 		SHADOW_PT_INDEX(iter->gfn << PAGE_SHIFT, iter->level);
-	iter->old_spte = READ_ONCE(*iter->sptep);
+	iter->old_spte = READ_ONCE(*rcu_dereference(iter->sptep));
 }
 
 static gfn_t round_gfn_for_level(gfn_t gfn, int level)
@@ -35,7 +35,7 @@ void tdp_iter_start(struct tdp_iter *iter, u64 *root_pt, int root_level,
 	iter->root_level = root_level;
 	iter->min_level = min_level;
 	iter->level = root_level;
-	iter->pt_path[iter->level - 1] = root_pt;
+	iter->pt_path[iter->level - 1] = (tdp_ptep_t)root_pt;
 
 	iter->gfn = round_gfn_for_level(iter->next_last_level_gfn, iter->level);
 	tdp_iter_refresh_sptep(iter);
@@ -48,7 +48,7 @@ void tdp_iter_start(struct tdp_iter *iter, u64 *root_pt, int root_level,
  * address of the child page table referenced by the SPTE. Returns null if
  * there is no such entry.
  */
-u64 *spte_to_child_pt(u64 spte, int level)
+tdp_ptep_t spte_to_child_pt(u64 spte, int level)
 {
 	/*
 	 * There's no child entry if this entry isn't present or is a
@@ -57,7 +57,7 @@ u64 *spte_to_child_pt(u64 spte, int level)
 	if (!is_shadow_present_pte(spte) || is_last_spte(spte, level))
 		return NULL;
 
-	return __va(spte_to_pfn(spte) << PAGE_SHIFT);
+	return (tdp_ptep_t)__va(spte_to_pfn(spte) << PAGE_SHIFT);
 }
 
 /*
@@ -66,7 +66,7 @@ u64 *spte_to_child_pt(u64 spte, int level)
  */
 static bool try_step_down(struct tdp_iter *iter)
 {
-	u64 *child_pt;
+	tdp_ptep_t child_pt;
 
 	if (iter->level == iter->min_level)
 		return false;
@@ -75,7 +75,7 @@ static bool try_step_down(struct tdp_iter *iter)
 	 * Reread the SPTE before stepping down to avoid traversing into page
 	 * tables that are no longer linked from this entry.
 	 */
-	iter->old_spte = READ_ONCE(*iter->sptep);
+	iter->old_spte = READ_ONCE(*rcu_dereference(iter->sptep));
 
 	child_pt = spte_to_child_pt(iter->old_spte, iter->level);
 	if (!child_pt)
@@ -109,7 +109,7 @@ static bool try_step_side(struct tdp_iter *iter)
 	iter->gfn += KVM_PAGES_PER_HPAGE(iter->level);
 	iter->next_last_level_gfn = iter->gfn;
 	iter->sptep++;
-	iter->old_spte = READ_ONCE(*iter->sptep);
+	iter->old_spte = READ_ONCE(*rcu_dereference(iter->sptep));
 
 	return true;
 }
@@ -159,7 +159,7 @@ void tdp_iter_next(struct tdp_iter *iter)
 	iter->valid = false;
 }
 
-u64 *tdp_iter_root_pt(struct tdp_iter *iter)
+tdp_ptep_t tdp_iter_root_pt(struct tdp_iter *iter)
 {
 	return iter->pt_path[iter->root_level - 1];
 }
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index d480c540ee27..4cc177d75c4a 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -7,6 +7,8 @@
 
 #include "mmu.h"
 
+typedef u64 __rcu *tdp_ptep_t;
+
 /*
  * A TDP iterator performs a pre-order walk over a TDP paging structure.
  */
@@ -23,9 +25,9 @@ struct tdp_iter {
 	 */
 	gfn_t yielded_gfn;
 	/* Pointers to the page tables traversed to reach the current SPTE */
-	u64 *pt_path[PT64_ROOT_MAX_LEVEL];
+	tdp_ptep_t pt_path[PT64_ROOT_MAX_LEVEL];
 	/* A pointer to the current SPTE */
-	u64 *sptep;
+	tdp_ptep_t sptep;
 	/* The lowest GFN mapped by the current SPTE */
 	gfn_t gfn;
 	/* The level of the root page given to the iterator */
@@ -55,11 +57,11 @@ struct tdp_iter {
 #define for_each_tdp_pte(iter, root, root_level, start, end) \
 	for_each_tdp_pte_min_level(iter, root, root_level, PG_LEVEL_4K, start, end)
 
-u64 *spte_to_child_pt(u64 pte, int level);
+tdp_ptep_t spte_to_child_pt(u64 pte, int level);
 
 void tdp_iter_start(struct tdp_iter *iter, u64 *root_pt, int root_level,
 		    int min_level, gfn_t next_last_level_gfn);
 void tdp_iter_next(struct tdp_iter *iter);
-u64 *tdp_iter_root_pt(struct tdp_iter *iter);
+tdp_ptep_t tdp_iter_root_pt(struct tdp_iter *iter);
 
 #endif /* __KVM_X86_MMU_TDP_ITER_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index a75e92164a8b..9e4009068920 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -42,6 +42,12 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 		return;
 
 	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_roots));
+
+	/*
+	 * Ensure that all the outstanding RCU callbacks to free shadow pages
+	 * can run before the VM is torn down.
+	 */
+	rcu_barrier();
 }
 
 static void tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root)
@@ -196,6 +202,28 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 	return __pa(root->spt);
 }
 
+static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
+{
+	free_page((unsigned long)sp->spt);
+	kmem_cache_free(mmu_page_header_cache, sp);
+}
+
+/*
+ * This is called through call_rcu in order to free TDP page table memory
+ * safely with respect to other kernel threads that may be operating on
+ * the memory.
+ * By only accessing TDP MMU page table memory in an RCU read critical
+ * section, and freeing it after a grace period, lockless access to that
+ * memory won't use it after it is freed.
+ */
+static void tdp_mmu_free_sp_rcu_callback(struct rcu_head *head)
+{
+	struct kvm_mmu_page *sp = container_of(head, struct kvm_mmu_page,
+					       rcu_head);
+
+	tdp_mmu_free_sp(sp);
+}
+
 static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 				u64 old_spte, u64 new_spte, int level);
 
@@ -269,8 +297,7 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, u64 *pt)
 	kvm_flush_remote_tlbs_with_address(kvm, gfn,
 					   KVM_PAGES_PER_HPAGE(level));
 
-	free_page((unsigned long)pt);
-	kmem_cache_free(mmu_page_header_cache, sp);
+	call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
 }
 
 /**
@@ -390,13 +417,13 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 				      u64 new_spte, bool record_acc_track,
 				      bool record_dirty_log)
 {
-	u64 *root_pt = tdp_iter_root_pt(iter);
+	tdp_ptep_t root_pt = tdp_iter_root_pt(iter);
 	struct kvm_mmu_page *root = sptep_to_sp(root_pt);
 	int as_id = kvm_mmu_page_as_id(root);
 
 	lockdep_assert_held(&kvm->mmu_lock);
 
-	WRITE_ONCE(*iter->sptep, new_spte);
+	WRITE_ONCE(*rcu_dereference(iter->sptep), new_spte);
 
 	__handle_changed_spte(kvm, as_id, iter->gfn, iter->old_spte, new_spte,
 			      iter->level);
@@ -466,10 +493,13 @@ static inline bool tdp_mmu_iter_cond_resched(struct kvm *kvm,
 		return false;
 
 	if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
+		rcu_read_unlock();
+
 		if (flush)
 			kvm_flush_remote_tlbs(kvm);
 
 		cond_resched_lock(&kvm->mmu_lock);
+		rcu_read_lock();
 
 		WARN_ON(iter->gfn > iter->next_last_level_gfn);
 
@@ -500,6 +530,8 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 	struct tdp_iter iter;
 	bool flush_needed = false;
 
+	rcu_read_lock();
+
 	tdp_root_for_each_pte(iter, root, start, end) {
 		if (can_yield &&
 		    tdp_mmu_iter_cond_resched(kvm, &iter, flush_needed)) {
@@ -523,6 +555,8 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 		tdp_mmu_set_spte(kvm, &iter, 0);
 		flush_needed = true;
 	}
+
+	rcu_read_unlock();
 	return flush_needed;
 }
 
@@ -568,13 +602,15 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
 
 	if (unlikely(is_noslot_pfn(pfn))) {
 		new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
-		trace_mark_mmio_spte(iter->sptep, iter->gfn, new_spte);
+		trace_mark_mmio_spte(rcu_dereference(iter->sptep), iter->gfn,
+				     new_spte);
 	} else {
 		make_spte_ret = make_spte(vcpu, ACC_ALL, iter->level, iter->gfn,
 					 pfn, iter->old_spte, prefault, true,
 					 map_writable, !shadow_accessed_mask,
 					 &new_spte);
-		trace_kvm_mmu_set_spte(iter->level, iter->gfn, iter->sptep);
+		trace_kvm_mmu_set_spte(iter->level, iter->gfn,
+				       rcu_dereference(iter->sptep));
 	}
 
 	if (new_spte == iter->old_spte)
@@ -597,7 +633,8 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
 	if (unlikely(is_mmio_spte(new_spte)))
 		ret = RET_PF_EMULATE;
 
-	trace_kvm_mmu_set_spte(iter->level, iter->gfn, iter->sptep);
+	trace_kvm_mmu_set_spte(iter->level, iter->gfn,
+			       rcu_dereference(iter->sptep));
 	if (!prefault)
 		vcpu->stat.pf_fixed++;
 
@@ -635,6 +672,9 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 					huge_page_disallowed, &req_level);
 
 	trace_kvm_mmu_spte_requested(gpa, level, pfn);
+
+	rcu_read_lock();
+
 	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
 		if (nx_huge_page_workaround_enabled)
 			disallowed_hugepage_adjust(iter.old_spte, gfn,
@@ -660,7 +700,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 			 * because the new value informs the !present
 			 * path below.
 			 */
-			iter.old_spte = READ_ONCE(*iter.sptep);
+			iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
 		}
 
 		if (!is_shadow_present_pte(iter.old_spte)) {
@@ -678,11 +718,14 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		}
 	}
 
-	if (WARN_ON(iter.level != level))
+	if (WARN_ON(iter.level != level)) {
+		rcu_read_unlock();
 		return RET_PF_RETRY;
+	}
 
 	ret = tdp_mmu_map_handle_target_level(vcpu, write, map_writable, &iter,
 					      pfn, prefault);
+	rcu_read_unlock();
 
 	return ret;
 }
@@ -753,6 +796,8 @@ static int age_gfn_range(struct kvm *kvm, struct kvm_memory_slot *slot,
 	int young = 0;
 	u64 new_spte = 0;
 
+	rcu_read_lock();
+
 	tdp_root_for_each_leaf_pte(iter, root, start, end) {
 		/*
 		 * If we have a non-accessed entry we don't need to change the
@@ -784,6 +829,8 @@ static int age_gfn_range(struct kvm *kvm, struct kvm_memory_slot *slot,
 		trace_kvm_age_page(iter.gfn, iter.level, slot, young);
 	}
 
+	rcu_read_unlock();
+
 	return young;
 }
 
@@ -829,6 +876,8 @@ static int set_tdp_spte(struct kvm *kvm, struct kvm_memory_slot *slot,
 	u64 new_spte;
 	int need_flush = 0;
 
+	rcu_read_lock();
+
 	WARN_ON(pte_huge(*ptep));
 
 	new_pfn = pte_pfn(*ptep);
@@ -857,6 +906,8 @@ static int set_tdp_spte(struct kvm *kvm, struct kvm_memory_slot *slot,
 	if (need_flush)
 		kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
 
+	rcu_read_unlock();
+
 	return 0;
 }
 
@@ -880,6 +931,8 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 	u64 new_spte;
 	bool spte_set = false;
 
+	rcu_read_lock();
+
 	BUG_ON(min_level > KVM_MAX_HUGEPAGE_LEVEL);
 
 	for_each_tdp_pte_min_level(iter, root->spt, root->role.level,
@@ -897,6 +950,8 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 		tdp_mmu_set_spte_no_dirty_log(kvm, &iter, new_spte);
 		spte_set = true;
 	}
+
+	rcu_read_unlock();
 	return spte_set;
 }
 
@@ -938,6 +993,8 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 	u64 new_spte;
 	bool spte_set = false;
 
+	rcu_read_lock();
+
 	tdp_root_for_each_leaf_pte(iter, root, start, end) {
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false))
 			continue;
@@ -957,6 +1014,8 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 		tdp_mmu_set_spte_no_dirty_log(kvm, &iter, new_spte);
 		spte_set = true;
 	}
+
+	rcu_read_unlock();
 	return spte_set;
 }
 
@@ -998,6 +1057,8 @@ static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
 	struct tdp_iter iter;
 	u64 new_spte;
 
+	rcu_read_lock();
+
 	tdp_root_for_each_leaf_pte(iter, root, gfn + __ffs(mask),
 				    gfn + BITS_PER_LONG) {
 		if (!mask)
@@ -1023,6 +1084,8 @@ static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
 
 		tdp_mmu_set_spte_no_dirty_log(kvm, &iter, new_spte);
 	}
+
+	rcu_read_unlock();
 }
 
 /*
@@ -1062,6 +1125,8 @@ static bool set_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 	u64 new_spte;
 	bool spte_set = false;
 
+	rcu_read_lock();
+
 	tdp_root_for_each_pte(iter, root, start, end) {
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false))
 			continue;
@@ -1076,6 +1141,7 @@ static bool set_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 		spte_set = true;
 	}
 
+	rcu_read_unlock();
 	return spte_set;
 }
 
@@ -1113,6 +1179,8 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 	kvm_pfn_t pfn;
 	bool spte_set = false;
 
+	rcu_read_lock();
+
 	tdp_root_for_each_pte(iter, root, start, end) {
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, spte_set)) {
 			spte_set = false;
@@ -1133,6 +1201,7 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 		spte_set = true;
 	}
 
+	rcu_read_unlock();
 	if (spte_set)
 		kvm_flush_remote_tlbs(kvm);
 }
@@ -1169,6 +1238,8 @@ static bool write_protect_gfn(struct kvm *kvm, struct kvm_mmu_page *root,
 	u64 new_spte;
 	bool spte_set = false;
 
+	rcu_read_lock();
+
 	tdp_root_for_each_leaf_pte(iter, root, gfn, gfn + 1) {
 		if (!is_writable_pte(iter.old_spte))
 			break;
@@ -1180,6 +1251,8 @@ static bool write_protect_gfn(struct kvm *kvm, struct kvm_mmu_page *root,
 		spte_set = true;
 	}
 
+	rcu_read_unlock();
+
 	return spte_set;
 }
 
@@ -1220,10 +1293,14 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 
 	*root_level = vcpu->arch.mmu->shadow_root_level;
 
+	rcu_read_lock();
+
 	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
 		leaf = iter.level;
 		sptes[leaf] = iter.old_spte;
 	}
 
+	rcu_read_unlock();
+
 	return leaf;
 }
-- 
2.30.0.365.g02bc693789-goog

