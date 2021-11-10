Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E81944CCBE
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 23:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233759AbhKJWdV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 17:33:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233766AbhKJWdP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 17:33:15 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 329D5C061767
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 14:30:27 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id w2-20020a627b02000000b0049fa951281fso2730919pfc.9
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 14:30:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ZyHddNGopGY/lza1UZlncFMjZJJM1j4g87L00tHisx8=;
        b=hZXGX2BqInvhBr17VwQFPDZblpGbwErhA25L417eM0C4wya2Mz0BSmHZ57PExAB5C8
         l/ejrmTc/Ev0pYYaxinvsvJEiPplUg2VGRSk/pd2vtP1NPITzXwD1rgdlQwPHrPz65F0
         Fy0Lvc9d6h0EQV81QZkhtgPAgSUuJyq52RcO0Kf3oSAgKJ4HlkehzNLHDAPHkuZbGp3d
         kNP8cpP5sRcVxhUZKHBh5p207E4hCotQS/Kjw9Oaq9WdQNr6nVefOzfBBgTdCwiNHFVE
         77jMLZLM2TWMyTgu4AoK5osaOl8q73ag+A1wjvdHdm6zB6FkpORAovVRBXP2MeXJ8QRP
         n23w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ZyHddNGopGY/lza1UZlncFMjZJJM1j4g87L00tHisx8=;
        b=dvlZKM5aFiK8BB+hKrQqv2BQKPqFeO6TDb0LkZ0IfBdzSH0iHbAWBwwtqFffMVLQvc
         FDpx7t8QJ8zpaNO9tDQw2FuWNLie+y4QBkxnJqogZ2i6cGIf4FoG6ZOB8fgUbdHsd6JF
         T1QUfawOcob5EmkhED0iXfKWm/98i6xoO3y6WAoQ39GxGElsMwQvd1t59YZXWXPtnDTq
         bISOB4dALuq7JwxRC6Kji5yvgV4a0wgNHKRgfcJx499tVw0sOk1GHImw5rsKZmrvyWeT
         130N2KD+toaQjvASHIPuNaTDyeq+esMP2Sz2vW8gR9v38ctDGFc2hnv1pfZRVRxGvFvV
         DQqQ==
X-Gm-Message-State: AOAM531iMToZvLJ9MUDjdhX3aKxfc5N7mq7+d6+27sej3AJjWg7oyUZE
        S6swb+iIN+PA6JCcvmPu+roWJiVFC76w
X-Google-Smtp-Source: ABdhPJwaci3mHy1I59FmDVZFexbfweOAJYQShAUkg2GBiTBX6eyMa46UQ8SopCwDR5guJydvHtX++tE3UPpV
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:6586:7b2f:b259:2011])
 (user=bgardon job=sendgmr) by 2002:a17:90a:c3:: with SMTP id
 v3mr48530pjd.0.1636583425446; Wed, 10 Nov 2021 14:30:25 -0800 (PST)
Date:   Wed, 10 Nov 2021 14:29:53 -0800
In-Reply-To: <20211110223010.1392399-1-bgardon@google.com>
Message-Id: <20211110223010.1392399-3-bgardon@google.com>
Mime-Version: 1.0
References: <20211110223010.1392399-1-bgardon@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [RFC 02/19] KVM: x86/mmu: Batch TLB flushes for a single zap
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When recursively handling a removed TDP page table, the TDP MMU will
flush the TLBs and queue an RCU callback to free the PT. If the original
change zapped a non-leaf SPTE at PG_LEVEL_1G or above, that change will
result in many unnecessary TLB flushes when one would suffice. Queue all
the PTs which need to be freed on a list and wait to queue RCU callbacks
to free them until after all the recursive callbacks are done.


Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 88 ++++++++++++++++++++++++++++++--------
 1 file changed, 70 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 866c2b191e1e..5b31d046df78 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -220,7 +220,8 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 
 static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 				u64 old_spte, u64 new_spte, int level,
-				bool shared);
+				bool shared,
+				struct list_head *disconnected_sps);
 
 static void handle_changed_spte_acc_track(u64 old_spte, u64 new_spte, int level)
 {
@@ -302,6 +303,11 @@ static void tdp_mmu_unlink_page(struct kvm *kvm, struct kvm_mmu_page *sp,
  * @shared: This operation may not be running under the exclusive use
  *	    of the MMU lock and the operation must synchronize with other
  *	    threads that might be modifying SPTEs.
+ * @disconnected_sps: If null, the TLBs will be flushed and the disconnected
+ *		      TDP MMU page will be queued to be freed after an RCU
+ *		      callback. If non-null the page will be added to the list
+ *		      and flushing the TLBs and queueing an RCU callback to
+ *		      free the page will be the caller's responsibility.
  *
  * Given a page table that has been removed from the TDP paging structure,
  * iterates through the page table to clear SPTEs and free child page tables.
@@ -312,7 +318,8 @@ static void tdp_mmu_unlink_page(struct kvm *kvm, struct kvm_mmu_page *sp,
  * early rcu_dereferences in the function.
  */
 static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
-					bool shared)
+					bool shared,
+					struct list_head *disconnected_sps)
 {
 	struct kvm_mmu_page *sp = sptep_to_sp(rcu_dereference(pt));
 	int level = sp->role.level;
@@ -371,13 +378,16 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
 		}
 		handle_changed_spte(kvm, kvm_mmu_page_as_id(sp), gfn,
 				    old_child_spte, REMOVED_SPTE, level,
-				    shared);
+				    shared, disconnected_sps);
 	}
 
-	kvm_flush_remote_tlbs_with_address(kvm, base_gfn,
-					   KVM_PAGES_PER_HPAGE(level + 1));
-
-	call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
+	if (disconnected_sps) {
+		list_add_tail(&sp->link, disconnected_sps);
+	} else {
+		kvm_flush_remote_tlbs_with_address(kvm, base_gfn,
+						   KVM_PAGES_PER_HPAGE(level + 1));
+		call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
+	}
 }
 
 /**
@@ -391,13 +401,21 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
  * @shared: This operation may not be running under the exclusive use of
  *	    the MMU lock and the operation must synchronize with other
  *	    threads that might be modifying SPTEs.
+ * @disconnected_sps: Only used if a page of page table memory has been
+ *		      removed from the paging structure by this change.
+ *		      If null, the TLBs will be flushed and the disconnected
+ *		      TDP MMU page will be queued to be freed after an RCU
+ *		      callback. If non-null the page will be added to the list
+ *		      and flushing the TLBs and queueing an RCU callback to
+ *		      free the page will be the caller's responsibility.
  *
  * Handle bookkeeping that might result from the modification of a SPTE.
  * This function must be called for all TDP SPTE modifications.
  */
 static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 				  u64 old_spte, u64 new_spte, int level,
-				  bool shared)
+				  bool shared,
+				  struct list_head *disconnected_sps)
 {
 	bool was_present = is_shadow_present_pte(old_spte);
 	bool is_present = is_shadow_present_pte(new_spte);
@@ -475,22 +493,39 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	 */
 	if (was_present && !was_leaf && (pfn_changed || !is_present))
 		handle_removed_tdp_mmu_page(kvm,
-				spte_to_child_pt(old_spte, level), shared);
+				spte_to_child_pt(old_spte, level), shared,
+				disconnected_sps);
 }
 
 static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 				u64 old_spte, u64 new_spte, int level,
-				bool shared)
+				bool shared, struct list_head *disconnected_sps)
 {
 	__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level,
-			      shared);
+			      shared, disconnected_sps);
 	handle_changed_spte_acc_track(old_spte, new_spte, level);
 	handle_changed_spte_dirty_log(kvm, as_id, gfn, old_spte,
 				      new_spte, level);
 }
 
 /*
- * tdp_mmu_set_spte_atomic - Set a TDP MMU SPTE atomically
+ * The TLBs must be flushed between the pages linked from disconnected_sps
+ * being removed from the paging structure and this function being called.
+ */
+static void handle_disconnected_sps(struct kvm *kvm,
+				    struct list_head *disconnected_sps)
+{
+	struct kvm_mmu_page *sp;
+	struct kvm_mmu_page *next;
+
+	list_for_each_entry_safe(sp, next, disconnected_sps, link) {
+		list_del(&sp->link);
+		call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
+	}
+}
+
+/*
+ * __tdp_mmu_set_spte_atomic - Set a TDP MMU SPTE atomically
  * and handle the associated bookkeeping.  Do not mark the page dirty
  * in KVM's dirty bitmaps.
  *
@@ -500,9 +535,10 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
  * Returns: true if the SPTE was set, false if it was not. If false is returned,
  *	    this function will have no side-effects.
  */
-static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
-					   struct tdp_iter *iter,
-					   u64 new_spte)
+static inline bool __tdp_mmu_set_spte_atomic(struct kvm *kvm,
+					     struct tdp_iter *iter,
+					     u64 new_spte,
+					     struct list_head *disconnected_sps)
 {
 	lockdep_assert_held_read(&kvm->mmu_lock);
 
@@ -522,22 +558,32 @@ static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
 		return false;
 
 	__handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
-			      new_spte, iter->level, true);
+			      new_spte, iter->level, true, disconnected_sps);
 	handle_changed_spte_acc_track(iter->old_spte, new_spte, iter->level);
 
 	return true;
 }
 
+static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
+					   struct tdp_iter *iter,
+					   u64 new_spte)
+{
+	return __tdp_mmu_set_spte_atomic(kvm, iter, new_spte, NULL);
+}
+
 static inline bool tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 					   struct tdp_iter *iter)
 {
+	LIST_HEAD(disconnected_sps);
+
 	/*
 	 * Freeze the SPTE by setting it to a special,
 	 * non-present value. This will stop other threads from
 	 * immediately installing a present entry in its place
 	 * before the TLBs are flushed.
 	 */
-	if (!tdp_mmu_set_spte_atomic(kvm, iter, REMOVED_SPTE))
+	if (!__tdp_mmu_set_spte_atomic(kvm, iter, REMOVED_SPTE,
+				       &disconnected_sps))
 		return false;
 
 	kvm_flush_remote_tlbs_with_address(kvm, iter->gfn,
@@ -553,6 +599,8 @@ static inline bool tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 	 */
 	WRITE_ONCE(*rcu_dereference(iter->sptep), 0);
 
+	handle_disconnected_sps(kvm, &disconnected_sps);
+
 	return true;
 }
 
@@ -577,6 +625,8 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 				      u64 new_spte, bool record_acc_track,
 				      bool record_dirty_log)
 {
+	LIST_HEAD(disconnected_sps);
+
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	/*
@@ -591,7 +641,7 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 	WRITE_ONCE(*rcu_dereference(iter->sptep), new_spte);
 
 	__handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
-			      new_spte, iter->level, false);
+			      new_spte, iter->level, false, &disconnected_sps);
 	if (record_acc_track)
 		handle_changed_spte_acc_track(iter->old_spte, new_spte,
 					      iter->level);
@@ -599,6 +649,8 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 		handle_changed_spte_dirty_log(kvm, iter->as_id, iter->gfn,
 					      iter->old_spte, new_spte,
 					      iter->level);
+
+	handle_disconnected_sps(kvm, &disconnected_sps);
 }
 
 static inline void tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
-- 
2.34.0.rc0.344.g81b53c2807-goog

