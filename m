Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89EFD352415
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 01:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236457AbhDAXi0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 19:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236407AbhDAXiS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 19:38:18 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF0EEC0613E6
        for <kvm@vger.kernel.org>; Thu,  1 Apr 2021 16:38:16 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id b13so3654633plh.19
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 16:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=B9SPQUTURDgYxZT4jg/14G5H1+2mPXu/rmwDPGYD4zc=;
        b=nwbTBESH3zKjkaEnYPNtHigiBmQymCrrz22eGK183oLKuxPfgfqGJ2q9peHKA/5eML
         Ugo6baTMD+zMtAZECZdPtdKc/sKtko03dZxA1P1koJyGhrvN3rjhEpgSAsY06SJabopK
         YesigV58j+soiCcvfp1YKMpGXvgANDSGVDVsmbe3TXq3C/xavpm3viJEl9QIczwXNbm9
         v8edyPLwC04REp0kh6aPvElLm16gA5wdfwMSxrCbeaHgv5z6VECYLBZlfeajFSOStxyS
         2E7iH6PBw8EV86RvWiNEtEoHh7fAjjSFu/T3vyuZ3DRvpxYhFX8aKC9xUcFHWgejDbNJ
         FTOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=B9SPQUTURDgYxZT4jg/14G5H1+2mPXu/rmwDPGYD4zc=;
        b=MI5WzuOFCZvGUWzY+UwTB5dYSSoqG07KtHWotaobU0b3oQcAzFWaY1JkIH/vgs2VPl
         WpdxAqSDX37pk9sPvN4hKYket/3gRRshWWVOqwOss1LXn32cnQnI+aClgWsJVoZ3DYbf
         IslS1kfUIsykicGBsRHxe4EIAdnuGqqTLh9AH9iUR33Sgzq9Bw5WnNvm8tmEE1qvQWzb
         DQ0oLBplbCuwe3PsAf4Ld2Vuc7qGMAYw3i15DeCbMk9eIZ6Wb0cQg0aNK2L2JPsxTbiA
         aQXgBSgFeZhUguglLQikB8iViO0ifRT8m3hLKTZAjXHXrs7yn7tOo9VQxDrH17OPQDkp
         2mLg==
X-Gm-Message-State: AOAM531Qb4DoWREUVKDus6xoXrcGXqAB9wag5LmPlvq1opKjKc3q+sQ1
        sviYKF8HjCXGYr5zgp6SyFd6jrLJ+VH1
X-Google-Smtp-Source: ABdhPJw1UloSAaq1sT9CTM30RJGZNVOdO+ITDv/sXZ65n/U2xTp8628Y5B6WNb5BIfzsV1LQPFzqeyEGJoOU
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:e088:88b8:ea4a:22b6])
 (user=bgardon job=sendgmr) by 2002:a17:902:9b8b:b029:e6:b027:2f96 with SMTP
 id y11-20020a1709029b8bb02900e6b0272f96mr10470721plp.28.1617320296374; Thu,
 01 Apr 2021 16:38:16 -0700 (PDT)
Date:   Thu,  1 Apr 2021 16:37:32 -0700
In-Reply-To: <20210401233736.638171-1-bgardon@google.com>
Message-Id: <20210401233736.638171-10-bgardon@google.com>
Mime-Version: 1.0
References: <20210401233736.638171-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH v2 09/13] KVM: x86/mmu: Allow zap gfn range to operate under
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
 arch/x86/kvm/mmu/mmu.c     |  22 +++++---
 arch/x86/kvm/mmu/tdp_mmu.c | 111 ++++++++++++++++++++++++++-----------
 arch/x86/kvm/mmu/tdp_mmu.h |  14 +++--
 3 files changed, 102 insertions(+), 45 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 47d996a8074f..d03a7a8b7ea2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3154,7 +3154,7 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
 	sp = to_shadow_page(*root_hpa & PT64_BASE_ADDR_MASK);
 
 	if (is_tdp_mmu_page(sp))
-		kvm_tdp_mmu_put_root(kvm, sp);
+		kvm_tdp_mmu_put_root(kvm, sp, false);
 	else if (!--sp->root_count && sp->role.invalid)
 		kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);
 
@@ -5507,16 +5507,24 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 		}
 	}
 
-	if (is_tdp_mmu_enabled(kvm)) {
-		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
-			flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, gfn_start,
-							  gfn_end, flush);
-	}
-
 	if (flush)
 		kvm_flush_remote_tlbs_with_address(kvm, gfn_start, gfn_end);
 
 	write_unlock(&kvm->mmu_lock);
+
+	if (is_tdp_mmu_enabled(kvm)) {
+		flush = false;
+
+		read_lock(&kvm->mmu_lock);
+		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
+			flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, gfn_start,
+							  gfn_end, flush, true);
+		if (flush)
+			kvm_flush_remote_tlbs_with_address(kvm, gfn_start,
+							   gfn_end);
+
+		read_unlock(&kvm->mmu_lock);
+	}
 }
 
 static bool slot_rmap_write_protect(struct kvm *kvm,
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index c1d7f6b86870..6917403484ce 100644
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
@@ -42,7 +51,8 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 }
 
 static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
-			  gfn_t start, gfn_t end, bool can_yield, bool flush);
+			  gfn_t start, gfn_t end, bool can_yield, bool flush,
+			  bool shared);
 
 static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
 {
@@ -66,11 +76,12 @@ static void tdp_mmu_free_sp_rcu_callback(struct rcu_head *head)
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
@@ -81,7 +92,7 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root)
 	list_del_rcu(&root->link);
 	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 
-	zap_gfn_range(kvm, root, 0, max_gfn, false, false);
+	zap_gfn_range(kvm, root, 0, max_gfn, false, false, shared);
 
 	call_rcu(&root->rcu_head, tdp_mmu_free_sp_rcu_callback);
 }
@@ -94,11 +105,11 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root)
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
 
@@ -117,7 +128,7 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 	rcu_read_unlock();
 
 	if (prev_root)
-		kvm_tdp_mmu_put_root(kvm, prev_root);
+		kvm_tdp_mmu_put_root(kvm, prev_root, shared);
 
 	return next_root;
 }
@@ -127,12 +138,16 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
  * This makes it safe to release the MMU lock and yield within the loop, but
  * if exiting the loop early, the caller must drop the reference to the most
  * recent root. (Unless keeping a live reference is desirable.)
+ *
+ * If shared is set, this function is operating under the MMU lock in read
+ * mode. In the unlikely event that this thread must free a root, the lock
+ * will be temporarily dropped and reacquired in write mode.
  */
-#define for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id)	\
-	for (_root = tdp_mmu_next_root(_kvm, NULL);		\
-	     _root;						\
-	     _root = tdp_mmu_next_root(_kvm, _root))		\
-		if (kvm_mmu_page_as_id(_root) != _as_id) {	\
+#define for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared)	\
+	for (_root = tdp_mmu_next_root(_kvm, NULL, _shared);		\
+	     _root;							\
+	     _root = tdp_mmu_next_root(_kvm, _root, _shared))		\
+		if (kvm_mmu_page_as_id(_root) != _as_id) {		\
 		} else
 
 #define for_each_tdp_mmu_root(_kvm, _root, _as_id)				\
@@ -636,7 +651,8 @@ static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
  * Return false if a yield was not needed.
  */
 static inline bool tdp_mmu_iter_cond_resched(struct kvm *kvm,
-					     struct tdp_iter *iter, bool flush)
+					     struct tdp_iter *iter, bool flush,
+					     bool shared)
 {
 	/* Ensure forward progress has been made before yielding. */
 	if (iter->next_last_level_gfn == iter->yielded_gfn)
@@ -648,7 +664,11 @@ static inline bool tdp_mmu_iter_cond_resched(struct kvm *kvm,
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
@@ -666,24 +686,32 @@ static inline bool tdp_mmu_iter_cond_resched(struct kvm *kvm,
  * non-root pages mapping GFNs strictly within that range. Returns true if
  * SPTEs have been cleared and a TLB flush is needed before releasing the
  * MMU lock.
+ *
  * If can_yield is true, will release the MMU lock and reschedule if the
  * scheduler needs the CPU or there is contention on the MMU lock. If this
  * function cannot yield, it will not release the MMU lock or reschedule and
  * the caller must ensure it does not supply too large a GFN range, or the
- * operation can cause a soft lockup.  Note, in some use cases a flush may be
- * required by prior actions.  Ensure the pending flush is performed prior to
- * yielding.
+ * operation can cause a soft lockup.
+ *
+ * If shared is true, this thread holds the MMU lock in read mode and must
+ * account for the possibility that other threads are modifying the paging
+ * structures concurrently. If shared is false, this thread should hold the
+ * MMU lock in write mode.
  */
 static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
-			  gfn_t start, gfn_t end, bool can_yield, bool flush)
+			  gfn_t start, gfn_t end, bool can_yield, bool flush,
+			  bool shared)
 {
 	struct tdp_iter iter;
 
+	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
+
 	rcu_read_lock();
 
 	tdp_root_for_each_pte(iter, root, start, end) {
+retry:
 		if (can_yield &&
-		    tdp_mmu_iter_cond_resched(kvm, &iter, flush)) {
+		    tdp_mmu_iter_cond_resched(kvm, &iter, flush, shared)) {
 			flush = false;
 			continue;
 		}
@@ -701,8 +729,17 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 		    !is_last_spte(iter.old_spte, iter.level))
 			continue;
 
-		tdp_mmu_set_spte(kvm, &iter, 0);
-		flush = true;
+		if (!shared) {
+			tdp_mmu_set_spte(kvm, &iter, 0);
+			flush = true;
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
@@ -714,14 +751,21 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
  * non-root pages mapping GFNs strictly within that range. Returns true if
  * SPTEs have been cleared and a TLB flush is needed before releasing the
  * MMU lock.
+ *
+ * If shared is true, this thread holds the MMU lock in read mode and must
+ * account for the possibility that other threads are modifying the paging
+ * structures concurrently. If shared is false, this thread should hold the
+ * MMU in write mode.
  */
 bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
-				 gfn_t end, bool can_yield, bool flush)
+				 gfn_t end, bool can_yield, bool flush,
+				 bool shared)
 {
 	struct kvm_mmu_page *root;
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root, as_id)
-		flush = zap_gfn_range(kvm, root, start, end, can_yield, flush);
+	for_each_tdp_mmu_root_yield_safe(kvm, root, as_id, shared)
+		flush = zap_gfn_range(kvm, root, start, end, can_yield, flush,
+				      shared);
 
 	return flush;
 }
@@ -733,7 +777,8 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
 	int i;
 
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
-		flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, 0, max_gfn, flush);
+		flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, 0, max_gfn,
+						  flush, false);
 
 	if (flush)
 		kvm_flush_remote_tlbs(kvm);
@@ -902,7 +947,7 @@ static __always_inline int kvm_tdp_mmu_handle_hva_range(struct kvm *kvm,
 	int as_id;
 
 	for (as_id = 0; as_id < KVM_ADDRESS_SPACE_NUM; as_id++) {
-		for_each_tdp_mmu_root_yield_safe(kvm, root, as_id) {
+		for_each_tdp_mmu_root_yield_safe(kvm, root, as_id, false) {
 			slots = __kvm_memslots(kvm, as_id);
 			kvm_for_each_memslot(memslot, slots) {
 				unsigned long hva_start, hva_end;
@@ -942,7 +987,7 @@ static int zap_gfn_range_hva_wrapper(struct kvm *kvm,
 				     struct kvm_mmu_page *root, gfn_t start,
 				     gfn_t end, unsigned long unused)
 {
-	return zap_gfn_range(kvm, root, start, end, false, false);
+	return zap_gfn_range(kvm, root, start, end, false, false, false);
 }
 
 int kvm_tdp_mmu_zap_hva_range(struct kvm *kvm, unsigned long start,
@@ -1103,7 +1148,7 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	for_each_tdp_pte_min_level(iter, root->spt, root->role.level,
 				   min_level, start, end) {
-		if (tdp_mmu_iter_cond_resched(kvm, &iter, false))
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, false))
 			continue;
 
 		if (!is_shadow_present_pte(iter.old_spte) ||
@@ -1132,7 +1177,7 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm, struct kvm_memory_slot *slot,
 	struct kvm_mmu_page *root;
 	bool spte_set = false;
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root, slot->as_id)
+	for_each_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, false)
 		spte_set |= wrprot_gfn_range(kvm, root, slot->base_gfn,
 			     slot->base_gfn + slot->npages, min_level);
 
@@ -1156,7 +1201,7 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 	rcu_read_lock();
 
 	tdp_root_for_each_leaf_pte(iter, root, start, end) {
-		if (tdp_mmu_iter_cond_resched(kvm, &iter, false))
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, false))
 			continue;
 
 		if (spte_ad_need_write_protect(iter.old_spte)) {
@@ -1191,7 +1236,7 @@ bool kvm_tdp_mmu_clear_dirty_slot(struct kvm *kvm, struct kvm_memory_slot *slot)
 	struct kvm_mmu_page *root;
 	bool spte_set = false;
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root, slot->as_id)
+	for_each_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, false)
 		spte_set |= clear_dirty_gfn_range(kvm, root, slot->base_gfn,
 				slot->base_gfn + slot->npages);
 
@@ -1278,7 +1323,7 @@ static bool zap_collapsible_spte_range(struct kvm *kvm,
 	rcu_read_lock();
 
 	tdp_root_for_each_pte(iter, root, start, end) {
-		if (tdp_mmu_iter_cond_resched(kvm, &iter, flush)) {
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, flush, false)) {
 			flush = false;
 			continue;
 		}
@@ -1313,7 +1358,7 @@ bool kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
 {
 	struct kvm_mmu_page *root;
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root, slot->as_id)
+	for_each_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, false)
 		flush = zap_collapsible_spte_range(kvm, root, slot, flush);
 
 	return flush;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index f0a26214e999..d703c6d6024a 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -13,14 +13,18 @@ __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm *kvm,
 	return refcount_inc_not_zero(&root->tdp_mmu_root_count);
 }
 
-void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root);
+void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
+			  bool shared);
 
 bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
-				 gfn_t end, bool can_yield, bool flush);
+				 gfn_t end, bool can_yield, bool flush,
+				 bool shared);
 static inline bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id,
-					     gfn_t start, gfn_t end, bool flush)
+					     gfn_t start, gfn_t end, bool flush,
+					     bool shared)
 {
-	return __kvm_tdp_mmu_zap_gfn_range(kvm, as_id, start, end, true, flush);
+	return __kvm_tdp_mmu_zap_gfn_range(kvm, as_id, start, end, true, flush,
+					   shared);
 }
 static inline bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
@@ -37,7 +41,7 @@ static inline bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 	 */
 	lockdep_assert_held_write(&kvm->mmu_lock);
 	return __kvm_tdp_mmu_zap_gfn_range(kvm, kvm_mmu_page_as_id(sp),
-					   sp->gfn, end, false, false);
+					   sp->gfn, end, false, false, false);
 }
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
 
-- 
2.31.0.208.g409f899ff0-goog

