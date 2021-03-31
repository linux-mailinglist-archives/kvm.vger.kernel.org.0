Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D50513508EF
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 23:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbhCaVJ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 17:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232682AbhCaVJ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Mar 2021 17:09:27 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 586A4C06175F
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 14:09:26 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 71so525013ybl.0
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 14:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=D3yhdA0SbfOZ8/HUhdVLoEpIVed7C/spdyqXqc6kmuA=;
        b=di+hCO0vOSPxyz7cYAcvQmi7yiDWrPABjxVZkRfxNGs8qhYE9c2E6mTpZMfg7Vj31i
         RdoWErxhipOlndt6dMpiDVYG3ScVEtG0T0/JCFyGUsIsJ2R4evxFGtTslj2BA6fLvDC0
         +kwYrUs/PFU1Oe85mAC3V3pkvPCJzzeptD3T3/fS0VTYxpF9rGsT2JLTRUS5UyeJAduR
         W56W0X7YibxX3GtSuO56ffZpSM+lLk/9VuNXNF2tIQtImhOw4qrl0dqY0mLGHSD2Tzu5
         FHI+bhZUHj/YJWXH6DJ6KbWM6XdbK+wVXJgQTpmag4sUX2OLNwSlrldrnZuk9tza6X+w
         YcqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=D3yhdA0SbfOZ8/HUhdVLoEpIVed7C/spdyqXqc6kmuA=;
        b=uiePJlRAjqYicg/ocNNMP5wE3JL0vqtUO7jFHKQT4uNZTl3tmEPpdIyhx7pd++bLmL
         DMA7pN6EUaKEoDCdJkH1G+SZFaCa4fPJAkfqbfkLLpM+RP+ZC4r7evMgQZXJ4QLMqbGv
         m1v0xf5f9WaXaJWF6x2n31jC6MWwiNfWdTb4cS/XE1I9jJyPU9AQFSggt4869LIlX9bE
         LOhnqOS30NvPAoc/t7MnHiAbBh/2wQgPUc7gBEaR/kKBobrCiquOWzUssW1SvZWT6VKY
         bbJyS4b9nmtN8bbST8RGu0/9x5bgdzFzShqCX89yigUk1Y7hZJurizsbu7St2o473dA5
         8LEw==
X-Gm-Message-State: AOAM533ruyu9jgHaoWMfVHx/vQfwU4H3g9wPl9iDInDYKBWZ5gVltwD6
        oLdZuWgk+nrPbZ5YkQ1R1jefWiz/q6TY
X-Google-Smtp-Source: ABdhPJyaBZsZ03PKHBu8tZ1QHlTBf/TrAMVN7LxSvfPVD5I8vxcHe6hXUeftn5uPbOL3KC+i6X7asymswkgg
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:8026:6888:3d55:3842])
 (user=bgardon job=sendgmr) by 2002:a25:7809:: with SMTP id
 t9mr7038269ybc.99.1617224965618; Wed, 31 Mar 2021 14:09:25 -0700 (PDT)
Date:   Wed, 31 Mar 2021 14:08:37 -0700
In-Reply-To: <20210331210841.3996155-1-bgardon@google.com>
Message-Id: <20210331210841.3996155-10-bgardon@google.com>
Mime-Version: 1.0
References: <20210331210841.3996155-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 09/13] KVM: x86/mmu: Allow zap gfn range to operate under the
 mmu read lock
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
 arch/x86/kvm/mmu/mmu.c     |  15 ++++--
 arch/x86/kvm/mmu/tdp_mmu.c | 102 ++++++++++++++++++++++++++-----------
 arch/x86/kvm/mmu/tdp_mmu.h |   6 ++-
 3 files changed, 87 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 667d64daa82c..dcbfc784cf2f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3155,7 +3155,7 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
 	sp = to_shadow_page(*root_hpa & PT64_BASE_ADDR_MASK);
 
 	if (is_tdp_mmu_page(sp))
-		kvm_tdp_mmu_put_root(kvm, sp);
+		kvm_tdp_mmu_put_root(kvm, sp, false);
 	else if (!--sp->root_count && sp->role.invalid)
 		kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);
 
@@ -5514,13 +5514,17 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 		}
 	}
 
+	write_unlock(&kvm->mmu_lock);
+
 	if (is_tdp_mmu_enabled(kvm)) {
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
@@ -5959,7 +5963,8 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
 		WARN_ON_ONCE(!sp->lpage_disallowed);
 		if (is_tdp_mmu_page(sp)) {
 			kvm_tdp_mmu_zap_gfn_range(kvm, sp->gfn,
-				sp->gfn + KVM_PAGES_PER_HPAGE(sp->role.level));
+				sp->gfn + KVM_PAGES_PER_HPAGE(sp->role.level),
+				false);
 		} else {
 			kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
 			WARN_ON_ONCE(sp->lpage_disallowed);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index d255125059c4..0e99e4675dd4 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -27,6 +27,15 @@ void kvm_mmu_init_tdp_mmu(struct kvm *kvm)
 	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_pages);
 }
 
+static __always_inline void kvm_lockdep_assert_mmu_lock_held(struct kvm *kvm,
+							     bool shared)
+{
+	if (shared)
+		lockdep_assert_held_read(&kvm->mmu_lock);
+	else
+		lockdep_assert_held_write(&kvm->mmu_lock);
+}
+
 void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 {
 	if (!kvm->arch.tdp_mmu_enabled)
@@ -42,7 +51,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 }
 
 static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
-			  gfn_t start, gfn_t end, bool can_yield);
+			  gfn_t start, gfn_t end, bool can_yield, bool shared);
 
 static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
 {
@@ -66,11 +75,12 @@ static void tdp_mmu_free_sp_rcu_callback(struct rcu_head *head)
 	tdp_mmu_free_sp(sp);
 }
 
-void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root)
+void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
+			  bool shared)
 {
 	gfn_t max_gfn = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
 
-	lockdep_assert_held_write(&kvm->mmu_lock);
+	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
 
 	if (!refcount_dec_and_test(&root->tdp_mmu_root_count))
 		return;
@@ -81,7 +91,7 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root)
 	list_del_rcu(&root->link);
 	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 
-	zap_gfn_range(kvm, root, 0, max_gfn, false);
+	zap_gfn_range(kvm, root, 0, max_gfn, false, shared);
 
 	call_rcu(&root->rcu_head, tdp_mmu_free_sp_rcu_callback);
 }
@@ -94,11 +104,11 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root)
  * function will return NULL.
  */
 static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
-					      struct kvm_mmu_page *prev_root)
+					      struct kvm_mmu_page *prev_root,
+					      bool shared)
 {
 	struct kvm_mmu_page *next_root;
 
-	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	rcu_read_lock();
 
@@ -117,7 +127,7 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 	rcu_read_unlock();
 
 	if (prev_root)
-		kvm_tdp_mmu_put_root(kvm, prev_root);
+		kvm_tdp_mmu_put_root(kvm, prev_root, shared);
 
 	return next_root;
 }
@@ -127,11 +137,15 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
  * This makes it safe to release the MMU lock and yield within the loop, but
  * if exiting the loop early, the caller must drop the reference to the most
  * recent root. (Unless keeping a live reference is desirable.)
+ *
+ * If shared is set, this function is operating under the MMU lock in read
+ * mode. In the unlikely event that this thread must free a root, the lock
+ * will be temporarily dropped and reacquired in write mode.
  */
-#define for_each_tdp_mmu_root_yield_safe(_kvm, _root)	\
-	for (_root = tdp_mmu_next_root(_kvm, NULL);	\
-	     _root;					\
-	     _root = tdp_mmu_next_root(_kvm, _root))
+#define for_each_tdp_mmu_root_yield_safe(_kvm, _root, _shared)	\
+	for (_root = tdp_mmu_next_root(_kvm, NULL, _shared);	\
+	     _root;						\
+	     _root = tdp_mmu_next_root(_kvm, _root, _shared))
 
 /* Only safe under the MMU lock in write mode, without yielding. */
 #define for_each_tdp_mmu_root(_kvm, _root)				\
@@ -632,7 +646,8 @@ static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
  * Return false if a yield was not needed.
  */
 static inline bool tdp_mmu_iter_cond_resched(struct kvm *kvm,
-					     struct tdp_iter *iter, bool flush)
+					     struct tdp_iter *iter, bool flush,
+					     bool shared)
 {
 	/* Ensure forward progress has been made before yielding. */
 	if (iter->next_last_level_gfn == iter->yielded_gfn)
@@ -644,7 +659,11 @@ static inline bool tdp_mmu_iter_cond_resched(struct kvm *kvm,
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
@@ -662,23 +681,33 @@ static inline bool tdp_mmu_iter_cond_resched(struct kvm *kvm,
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
+ * MMU lock in write mode.
  */
 static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
-			  gfn_t start, gfn_t end, bool can_yield)
+			  gfn_t start, gfn_t end, bool can_yield, bool shared)
 {
 	struct tdp_iter iter;
 	bool flush_needed = false;
 
+	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
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
@@ -696,8 +725,17 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
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
@@ -709,14 +747,20 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
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
@@ -726,7 +770,7 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
 	gfn_t max_gfn = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
 	bool flush;
 
-	flush = kvm_tdp_mmu_zap_gfn_range(kvm, 0, max_gfn);
+	flush = kvm_tdp_mmu_zap_gfn_range(kvm, 0, max_gfn, false);
 	if (flush)
 		kvm_flush_remote_tlbs(kvm);
 }
@@ -893,7 +937,7 @@ static __always_inline int kvm_tdp_mmu_handle_hva_range(struct kvm *kvm,
 	int ret = 0;
 	int as_id;
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root) {
+	for_each_tdp_mmu_root_yield_safe(kvm, root, false) {
 		as_id = kvm_mmu_page_as_id(root);
 		slots = __kvm_memslots(kvm, as_id);
 		kvm_for_each_memslot(memslot, slots) {
@@ -933,7 +977,7 @@ static int zap_gfn_range_hva_wrapper(struct kvm *kvm,
 				     struct kvm_mmu_page *root, gfn_t start,
 				     gfn_t end, unsigned long unused)
 {
-	return zap_gfn_range(kvm, root, start, end, false);
+	return zap_gfn_range(kvm, root, start, end, false, false);
 }
 
 int kvm_tdp_mmu_zap_hva_range(struct kvm *kvm, unsigned long start,
@@ -1098,7 +1142,7 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	for_each_tdp_pte_min_level(iter, root->spt, root->role.level,
 				   min_level, start, end) {
-		if (tdp_mmu_iter_cond_resched(kvm, &iter, false))
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, false))
 			continue;
 
 		if (!is_shadow_present_pte(iter.old_spte) ||
@@ -1128,7 +1172,7 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm, struct kvm_memory_slot *slot,
 	int root_as_id;
 	bool spte_set = false;
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root) {
+	for_each_tdp_mmu_root_yield_safe(kvm, root, false) {
 		root_as_id = kvm_mmu_page_as_id(root);
 		if (root_as_id != slot->as_id)
 			continue;
@@ -1157,7 +1201,7 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 	rcu_read_lock();
 
 	tdp_root_for_each_leaf_pte(iter, root, start, end) {
-		if (tdp_mmu_iter_cond_resched(kvm, &iter, false))
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, false))
 			continue;
 
 		if (spte_ad_need_write_protect(iter.old_spte)) {
@@ -1193,7 +1237,7 @@ bool kvm_tdp_mmu_clear_dirty_slot(struct kvm *kvm, struct kvm_memory_slot *slot)
 	int root_as_id;
 	bool spte_set = false;
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root) {
+	for_each_tdp_mmu_root_yield_safe(kvm, root, false) {
 		root_as_id = kvm_mmu_page_as_id(root);
 		if (root_as_id != slot->as_id)
 			continue;
@@ -1291,7 +1335,7 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 	rcu_read_lock();
 
 	tdp_root_for_each_pte(iter, root, start, end) {
-		if (tdp_mmu_iter_cond_resched(kvm, &iter, spte_set)) {
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, spte_set, false)) {
 			spte_set = false;
 			continue;
 		}
@@ -1326,7 +1370,7 @@ void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
 	struct kvm_mmu_page *root;
 	int root_as_id;
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root) {
+	for_each_tdp_mmu_root_yield_safe(kvm, root, false) {
 		root_as_id = kvm_mmu_page_as_id(root);
 		if (root_as_id != slot->as_id)
 			continue;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 9961df505067..855e58856815 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -13,9 +13,11 @@ __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm *kvm,
 	return refcount_inc_not_zero(&root->tdp_mmu_root_count);
 }
 
-void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root);
+void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
+			  bool shared);
 
-bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end);
+bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end,
+			       bool shared);
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
 
 int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
-- 
2.31.0.291.g576ba9dcdaf-goog

