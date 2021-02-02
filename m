Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61AB330CB01
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 20:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238928AbhBBTHb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 14:07:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239396AbhBBTCo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 14:02:44 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27390C061A30
        for <kvm@vger.kernel.org>; Tue,  2 Feb 2021 10:58:23 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id bc11so12606236plb.17
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 10:58:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=/3ZQzUuaWzQcmBzEG3kq4CNXokRjzWqOYdXtOTnfHDo=;
        b=Le+bNWezEFxaDZOKrNLQ4fH7bWg5iMGI+cjUv60qgHbWxOe+u/2TbMwhpEk2aqoDsR
         ZPvqP95APopbB04XcSnsKw5/p34amZhFuWWblhbufZ8Up9HNqEI/qn59ohk/piAIuWVJ
         oabL0b94itqfddvIZ3DoDU3ArirLVyG2mUXJx+1j+SjKFqqOd8peXceH5s8l0eVkPCsG
         o28hj1CC6o0aNfE0jdtMtMKeZTMUtu3cXJ1tl4pp36NcQrQDpGx2it33t4AUpNVnlkQ0
         nGsMcGYM1ftOYlM8l4kbbDr0rjHWbS+i+DiiyELdPhsILNeyRfmdNLaZCc2Z17+Hlq9b
         cH3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=/3ZQzUuaWzQcmBzEG3kq4CNXokRjzWqOYdXtOTnfHDo=;
        b=A2FcQw+X63/ZQH8Za5uDEk4tkV5T9xlWCw6OjUpTBr76aEw+zjGglj5pEHxK7Ql/eG
         OUJEGypipXV2suOuHcjqYhk+jbMpiQdrpewtUgQ8GlCLP5L7Zn738BH5UFaSLa4cHj32
         /cHAMKnlJbeKHFpRwwUMJrJ2dlxw883XPjRYA+Jl52qB0gznZw6jo0PDOnu+hlE8w0gI
         E0S2NtyB5PehW2umSaCJCs0ksESE5bTJ9T+OTNw9iEMycCTcBhSfBAJ3dI4vR+ZL6+Nl
         pRLHCHMeJFStFvNhIOruewkvyVSOYR815aOcBronZAhSH8z1GaHcVJUQPbPl4AJQwAkT
         FbHg==
X-Gm-Message-State: AOAM530OiROY1/5u4GlY1OC7lGvJGFag7qxMp8+27nqLg6SpADSEyOKM
        p6dRL9IDX78gyHNaTlMFOj70SIoV74vW
X-Google-Smtp-Source: ABdhPJy1BMU80b5YgTS5yqKaDrFz5HZVkcONiJE3x3mdnFBkjJM+WarVov1mVVwmTVl9yoyev5MCWaZ1yYgH
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:9090:561:5a98:6d47])
 (user=bgardon job=sendgmr) by 2002:a17:90a:8d83:: with SMTP id
 d3mr614698pjo.0.1612292302292; Tue, 02 Feb 2021 10:58:22 -0800 (PST)
Date:   Tue,  2 Feb 2021 10:57:30 -0800
In-Reply-To: <20210202185734.1680553-1-bgardon@google.com>
Message-Id: <20210202185734.1680553-25-bgardon@google.com>
Mime-Version: 1.0
References: <20210202185734.1680553-1-bgardon@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH v2 24/28] KVM: x86/mmu: Allow zap gfn range to operate under
 the mmu read lock
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

To reduce lock contention and interference with page fault handlers,
allow the TDP MMU function to zap a GFN range to operate under the MMU
read lock.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c          |  13 ++-
 arch/x86/kvm/mmu/mmu_internal.h |   6 +-
 arch/x86/kvm/mmu/tdp_mmu.c      | 165 +++++++++++++++++++++++++-------
 arch/x86/kvm/mmu/tdp_mmu.h      |   3 +-
 4 files changed, 145 insertions(+), 42 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3d181a2b2485..254ff87d2a61 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5518,13 +5518,17 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 		}
 	}
 
+	kvm_mmu_unlock(kvm);
+
 	if (kvm->arch.tdp_mmu_enabled) {
-		flush = kvm_tdp_mmu_zap_gfn_range(kvm, gfn_start, gfn_end);
+		read_lock(&kvm->mmu_lock);
+		flush = kvm_tdp_mmu_zap_gfn_range(kvm, gfn_start, gfn_end,
+						  true);
 		if (flush)
 			kvm_flush_remote_tlbs(kvm);
-	}
 
-	write_unlock(&kvm->mmu_lock);
+		read_unlock(&kvm->mmu_lock);
+	}
 }
 
 static bool slot_rmap_write_protect(struct kvm *kvm,
@@ -6015,7 +6019,8 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
 		WARN_ON_ONCE(!sp->lpage_disallowed);
 		if (sp->tdp_mmu_page) {
 			kvm_tdp_mmu_zap_gfn_range(kvm, sp->gfn,
-				sp->gfn + KVM_PAGES_PER_HPAGE(sp->role.level));
+				sp->gfn + KVM_PAGES_PER_HPAGE(sp->role.level),
+				false);
 		} else {
 			kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
 			WARN_ON_ONCE(sp->lpage_disallowed);
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 7f599cc64178..7df209fb8051 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -40,7 +40,11 @@ struct kvm_mmu_page {
 	u64 *spt;
 	/* hold the gfn of each spte inside spt */
 	gfn_t *gfns;
-	int root_count;          /* Currently serving as active root */
+	/* Currently serving as active root */
+	union {
+		int root_count;
+		refcount_t tdp_mmu_root_count;
+	};
 	unsigned int unsync_children;
 	struct kvm_rmap_head parent_ptes; /* rmap pointers to parent sptes */
 	DECLARE_BITMAP(unsync_child_bitmap, 512);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 0dd27e000dd0..de26762433ea 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -52,46 +52,104 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 	rcu_barrier();
 }
 
-static void tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root)
+static __always_inline __must_check bool tdp_mmu_get_root(struct kvm *kvm,
+						struct kvm_mmu_page *root)
 {
-	if (kvm_mmu_put_root(kvm, root))
-		kvm_tdp_mmu_free_root(kvm, root);
+	return refcount_inc_not_zero(&root->tdp_mmu_root_count);
 }
 
-static inline bool tdp_mmu_next_root_valid(struct kvm *kvm,
-					   struct kvm_mmu_page *root)
+static __always_inline void tdp_mmu_put_root(struct kvm *kvm,
+					     struct kvm_mmu_page *root,
+					     bool shared)
 {
-	lockdep_assert_held_write(&kvm->mmu_lock);
+	int root_count;
+	int r;
 
-	if (list_entry_is_head(root, &kvm->arch.tdp_mmu_roots, link))
-		return false;
+	if (shared) {
+		lockdep_assert_held_read(&kvm->mmu_lock);
 
-	kvm_mmu_get_root(kvm, root);
-	return true;
+		root_count = atomic_read(&root->tdp_mmu_root_count.refs);
+
+		/*
+		 * If this is not the last reference on the root, it can be
+		 * dropped under the MMU read lock.
+		 */
+		if (root_count > 1) {
+			r = atomic_cmpxchg(&root->tdp_mmu_root_count.refs,
+					   root_count, root_count - 1);
+			if (r == root_count)
+				return;
+		}
+
+		/*
+		 * If the cmpxchg failed because of a race or this is the
+		 * last reference on the root, drop the read lock, and
+		 * reacquire the MMU lock in write mode.
+		 */
+		read_unlock(&kvm->mmu_lock);
+		write_lock(&kvm->mmu_lock);
+	} else {
+		lockdep_assert_held_write(&kvm->mmu_lock);
+	}
+
+	/*
+	 * No other thread can modify the root count since this thread holds
+	 * the MMU lock in write mode.
+	 */
+	BUG_ON(!atomic_read(&root->tdp_mmu_root_count.refs));
 
+
+	if (refcount_dec_and_test(&root->tdp_mmu_root_count))
+		kvm_tdp_mmu_free_root(kvm, root);
+
+	if (shared) {
+		write_unlock(&kvm->mmu_lock);
+		read_lock(&kvm->mmu_lock);
+
+	}
 }
 
 static inline struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
-						     struct kvm_mmu_page *root)
+						     struct kvm_mmu_page *root,
+						     bool shared)
 {
 	struct kvm_mmu_page *next_root;
 
 	next_root = list_next_entry(root, link);
-	tdp_mmu_put_root(kvm, root);
+	tdp_mmu_put_root(kvm, root, shared);
 	return next_root;
 }
 
+static inline bool tdp_mmu_next_root_valid(struct kvm *kvm,
+					   struct kvm_mmu_page *root)
+{
+	for (;;) {
+		if (list_entry_is_head(root, &kvm->arch.tdp_mmu_roots, link))
+			return false;
+
+		if (tdp_mmu_get_root(kvm, root))
+			return true;
+
+		root = list_next_entry(root, link);
+	}
+
+}
+
 /*
  * Note: this iterator gets and puts references to the roots it iterates over.
  * This makes it safe to release the MMU lock and yield within the loop, but
  * if exiting the loop early, the caller must drop the reference to the most
  * recent root. (Unless keeping a live reference is desirable.)
+ *
+ * If shared is set, this function is operating under the MMU lock in read
+ * mode. In the unlikely event that this thread must free a root, the lock
+ * will be temporarily dropped and reacquired in write mode.
  */
-#define for_each_tdp_mmu_root_yield_safe(_kvm, _root)				\
+#define for_each_tdp_mmu_root_yield_safe(_kvm, _root, _shared)				\
 	for (_root = list_first_entry(&_kvm->arch.tdp_mmu_roots,	\
 				      typeof(*_root), link);		\
 	     tdp_mmu_next_root_valid(_kvm, _root);			\
-	     _root = tdp_mmu_next_root(_kvm, _root))
+	     _root = tdp_mmu_next_root(_kvm, _root, _shared))
 
 #define for_each_tdp_mmu_root(_kvm, _root)				\
 	list_for_each_entry(_root, &_kvm->arch.tdp_mmu_roots, link)
@@ -113,7 +171,7 @@ bool is_tdp_mmu_root(struct kvm *kvm, hpa_t hpa)
 }
 
 static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
-			  gfn_t start, gfn_t end, bool can_yield);
+			  gfn_t start, gfn_t end, bool can_yield, bool shared);
 
 void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root)
 {
@@ -126,7 +184,7 @@ void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root)
 
 	list_del(&root->link);
 
-	zap_gfn_range(kvm, root, 0, max_gfn, false);
+	zap_gfn_range(kvm, root, 0, max_gfn, false, false);
 
 	free_page((unsigned long)root->spt);
 	kmem_cache_free(mmu_page_header_cache, root);
@@ -658,7 +716,8 @@ static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
  * Return false if a yield was not needed.
  */
 static inline bool tdp_mmu_iter_cond_resched(struct kvm *kvm,
-					     struct tdp_iter *iter, bool flush)
+					     struct tdp_iter *iter, bool flush,
+					     bool shared)
 {
 	/* Ensure forward progress has been made before yielding. */
 	if (iter->next_last_level_gfn == iter->yielded_gfn)
@@ -670,7 +729,11 @@ static inline bool tdp_mmu_iter_cond_resched(struct kvm *kvm,
 		if (flush)
 			kvm_flush_remote_tlbs(kvm);
 
-		cond_resched_rwlock_write(&kvm->mmu_lock);
+		if (shared)
+			cond_resched_rwlock_read(&kvm->mmu_lock);
+		else
+			cond_resched_rwlock_write(&kvm->mmu_lock);
+
 		rcu_read_lock();
 
 		WARN_ON(iter->gfn > iter->next_last_level_gfn);
@@ -690,23 +753,38 @@ static inline bool tdp_mmu_iter_cond_resched(struct kvm *kvm,
  * non-root pages mapping GFNs strictly within that range. Returns true if
  * SPTEs have been cleared and a TLB flush is needed before releasing the
  * MMU lock.
+ *
  * If can_yield is true, will release the MMU lock and reschedule if the
  * scheduler needs the CPU or there is contention on the MMU lock. If this
  * function cannot yield, it will not release the MMU lock or reschedule and
  * the caller must ensure it does not supply too large a GFN range, or the
  * operation can cause a soft lockup.
+ *
+ * If shared is true, this thread holds the MMU lock in read mode and must
+ * account for the possibility that other threads are modifying the paging
+ * structures concurrently. If shared is false, this thread should hold the
+ * MMU in write mode.
  */
 static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
-			  gfn_t start, gfn_t end, bool can_yield)
+			  gfn_t start, gfn_t end, bool can_yield, bool shared)
 {
 	struct tdp_iter iter;
 	bool flush_needed = false;
 
+#ifdef CONFIG_LOCKDEP
+	if (shared)
+		lockdep_assert_held_read(&kvm->mmu_lock);
+	else
+		lockdep_assert_held_write(&kvm->mmu_lock);
+#endif /* CONFIG_LOCKDEP */
+
 	rcu_read_lock();
 
 	tdp_root_for_each_pte(iter, root, start, end) {
+retry:
 		if (can_yield &&
-		    tdp_mmu_iter_cond_resched(kvm, &iter, flush_needed)) {
+		    tdp_mmu_iter_cond_resched(kvm, &iter, flush_needed,
+					      shared)) {
 			flush_needed = false;
 			continue;
 		}
@@ -724,8 +802,17 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 		    !is_last_spte(iter.old_spte, iter.level))
 			continue;
 
-		tdp_mmu_set_spte(kvm, &iter, 0);
-		flush_needed = true;
+		if (!shared) {
+			tdp_mmu_set_spte(kvm, &iter, 0);
+			flush_needed = true;
+		} else if (!tdp_mmu_zap_spte_atomic(kvm, &iter)) {
+			/*
+			 * The iter must explicitly re-read the SPTE because
+			 * the atomic cmpxchg failed.
+			 */
+			iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
+			goto retry;
+		}
 	}
 
 	rcu_read_unlock();
@@ -737,14 +824,20 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
  * non-root pages mapping GFNs strictly within that range. Returns true if
  * SPTEs have been cleared and a TLB flush is needed before releasing the
  * MMU lock.
+ *
+ * If shared is true, this thread holds the MMU lock in read mode and must
+ * account for the possibility that other threads are modifying the paging
+ * structures concurrently. If shared is false, this thread should hold the
+ * MMU in write mode.
  */
-bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end)
+bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end,
+			       bool shared)
 {
 	struct kvm_mmu_page *root;
 	bool flush = false;
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root)
-		flush |= zap_gfn_range(kvm, root, start, end, true);
+	for_each_tdp_mmu_root_yield_safe(kvm, root, shared)
+		flush |= zap_gfn_range(kvm, root, start, end, true, shared);
 
 	return flush;
 }
@@ -754,7 +847,7 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
 	gfn_t max_gfn = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
 	bool flush;
 
-	flush = kvm_tdp_mmu_zap_gfn_range(kvm, 0, max_gfn);
+	flush = kvm_tdp_mmu_zap_gfn_range(kvm, 0, max_gfn, false);
 	if (flush)
 		kvm_flush_remote_tlbs(kvm);
 }
@@ -918,7 +1011,7 @@ static int kvm_tdp_mmu_handle_hva_range(struct kvm *kvm, unsigned long start,
 	int ret = 0;
 	int as_id;
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root) {
+	for_each_tdp_mmu_root_yield_safe(kvm, root, false) {
 		as_id = kvm_mmu_page_as_id(root);
 		slots = __kvm_memslots(kvm, as_id);
 		kvm_for_each_memslot(memslot, slots) {
@@ -950,7 +1043,7 @@ static int zap_gfn_range_hva_wrapper(struct kvm *kvm,
 				     struct kvm_mmu_page *root, gfn_t start,
 				     gfn_t end, unsigned long unused)
 {
-	return zap_gfn_range(kvm, root, start, end, false);
+	return zap_gfn_range(kvm, root, start, end, false, false);
 }
 
 int kvm_tdp_mmu_zap_hva_range(struct kvm *kvm, unsigned long start,
@@ -1113,7 +1206,7 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	for_each_tdp_pte_min_level(iter, root->spt, root->role.level,
 				   min_level, start, end) {
-		if (tdp_mmu_iter_cond_resched(kvm, &iter, false))
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, false))
 			continue;
 
 		if (!is_shadow_present_pte(iter.old_spte) ||
@@ -1143,7 +1236,7 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm, struct kvm_memory_slot *slot,
 	int root_as_id;
 	bool spte_set = false;
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root) {
+	for_each_tdp_mmu_root_yield_safe(kvm, root, false) {
 		root_as_id = kvm_mmu_page_as_id(root);
 		if (root_as_id != slot->as_id)
 			continue;
@@ -1172,7 +1265,7 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 	rcu_read_lock();
 
 	tdp_root_for_each_leaf_pte(iter, root, start, end) {
-		if (tdp_mmu_iter_cond_resched(kvm, &iter, false))
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, false))
 			continue;
 
 		if (spte_ad_need_write_protect(iter.old_spte)) {
@@ -1208,7 +1301,7 @@ bool kvm_tdp_mmu_clear_dirty_slot(struct kvm *kvm, struct kvm_memory_slot *slot)
 	int root_as_id;
 	bool spte_set = false;
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root) {
+	for_each_tdp_mmu_root_yield_safe(kvm, root, false) {
 		root_as_id = kvm_mmu_page_as_id(root);
 		if (root_as_id != slot->as_id)
 			continue;
@@ -1304,7 +1397,7 @@ static bool set_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 	rcu_read_lock();
 
 	tdp_root_for_each_pte(iter, root, start, end) {
-		if (tdp_mmu_iter_cond_resched(kvm, &iter, false))
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, false))
 			continue;
 
 		if (!is_shadow_present_pte(iter.old_spte) ||
@@ -1332,7 +1425,7 @@ bool kvm_tdp_mmu_slot_set_dirty(struct kvm *kvm, struct kvm_memory_slot *slot)
 	int root_as_id;
 	bool spte_set = false;
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root) {
+	for_each_tdp_mmu_root_yield_safe(kvm, root, false) {
 		root_as_id = kvm_mmu_page_as_id(root);
 		if (root_as_id != slot->as_id)
 			continue;
@@ -1358,7 +1451,7 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 	rcu_read_lock();
 
 	tdp_root_for_each_pte(iter, root, start, end) {
-		if (tdp_mmu_iter_cond_resched(kvm, &iter, spte_set)) {
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, false)) {
 			spte_set = false;
 			continue;
 		}
@@ -1392,7 +1485,7 @@ void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
 	struct kvm_mmu_page *root;
 	int root_as_id;
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root) {
+	for_each_tdp_mmu_root_yield_safe(kvm, root, false) {
 		root_as_id = kvm_mmu_page_as_id(root);
 		if (root_as_id != slot->as_id)
 			continue;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index cbbdbadd1526..10ada884270b 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -12,7 +12,8 @@ bool is_tdp_mmu_root(struct kvm *kvm, hpa_t root);
 hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
 void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root);
 
-bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end);
+bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end,
+			       bool shared);
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
 
 int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
-- 
2.30.0.365.g02bc693789-goog

