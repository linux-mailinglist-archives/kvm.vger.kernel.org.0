Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6994352419
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 01:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236481AbhDAXia (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 19:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236443AbhDAXiY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 19:38:24 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAFB4C0613E6
        for <kvm@vger.kernel.org>; Thu,  1 Apr 2021 16:38:22 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id k15so923837ybh.6
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 16:38:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ZGN46dQ1OAhPZ0z1ytjvfSQ6SLM+jM8ZsyCkpclp1kQ=;
        b=dl+S9X6MRRiMQzm2bwWTyn41Bqc04/I7WIBk7R50++PIqAQpX2ohA9VtkA6TDYXaEz
         Seqq9ebVht/T7+PmBUAF6C7U/kdB1FYkiv/JjpOhI5YFjX0HgXkfGEwGr1K2YFd2o/Pg
         AcDXp++O60BstR133J4YvhZhA0wk/nOvPKouchO5pEkbuIxANTPaoqDGJFFZS8U2k9/a
         wTj3bEc93uippvdjnZz+zMHdBa3N+FtZcl/hKZoLpbCuto1lQ3RQTb4JOekvRGZ7uk1Q
         rK5jaWHHOT2wVMUlL+NWGmnr8TZYHVR20+Idsxi02meTD1mPqzxYhO/iSlZYkXkE5yjk
         ByOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ZGN46dQ1OAhPZ0z1ytjvfSQ6SLM+jM8ZsyCkpclp1kQ=;
        b=dF93YuLfFRFlIGFjqqYT+bOctFbWvpw0/KhT+hVPRH7CNcB324V7ML9UNesox9WmGm
         ibtMI/RwSbFsQTnX9+8Atq0fGQ3hoL95aKfiB0MWIPbfrDLxE9Yf/ggbRndBdyqkrpZo
         Yqs2Hvz03gjM8ikvlzqC0hhFYO55dCYKlB8jmSc+pT6JUboZ0BrrgMgpXj71trxZQSs4
         skHNUzKkL+ozK0pNUpHacprn55okHXH3pTL0s0Gr0PEGhBaJrhxUPZpVrH5D6KrQln2q
         M/S0nvpb5vIlHEHZv1vkKeNQLjGHdH+jnBTF2OKDiQurxU1lgNeLk3imBn7qc4/wWaWy
         oEDg==
X-Gm-Message-State: AOAM531c+bgPVLEjX88U+gvThHXMysYiGf3GIOpIlfIIv/ErszphAyAe
        NgEATpOfQ6Drcf8jlWevb/AxLOQYDo0k
X-Google-Smtp-Source: ABdhPJzx/qp2GyGvifKlr78fbr+AT3oOENRSF4LXnffkUp80c4D7rn9T745eLB17fJwwspQZ4FwndTfQYXL9
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:e088:88b8:ea4a:22b6])
 (user=bgardon job=sendgmr) by 2002:a25:6088:: with SMTP id
 u130mr15500313ybb.257.1617320301927; Thu, 01 Apr 2021 16:38:21 -0700 (PDT)
Date:   Thu,  1 Apr 2021 16:37:34 -0700
In-Reply-To: <20210401233736.638171-1-bgardon@google.com>
Message-Id: <20210401233736.638171-12-bgardon@google.com>
Mime-Version: 1.0
References: <20210401233736.638171-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH v2 11/13] KVM: x86/mmu: Allow enabling / disabling dirty
 logging under MMU read lock
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
allow the TDP MMU functions which enable and disable dirty logging
to operate under the MMU read lock.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 16 +++++++---
 arch/x86/kvm/mmu/tdp_mmu.c | 62 ++++++++++++++++++++++++++++++--------
 2 files changed, 61 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5939813e3043..a3837f8ad4ed 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5543,10 +5543,14 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 	write_lock(&kvm->mmu_lock);
 	flush = slot_handle_level(kvm, memslot, slot_rmap_write_protect,
 				start_level, KVM_MAX_HUGEPAGE_LEVEL, false);
-	if (is_tdp_mmu_enabled(kvm))
-		flush |= kvm_tdp_mmu_wrprot_slot(kvm, memslot, PG_LEVEL_4K);
 	write_unlock(&kvm->mmu_lock);
 
+	if (is_tdp_mmu_enabled(kvm)) {
+		read_lock(&kvm->mmu_lock);
+		flush |= kvm_tdp_mmu_wrprot_slot(kvm, memslot, PG_LEVEL_4K);
+		read_unlock(&kvm->mmu_lock);
+	}
+
 	/*
 	 * We can flush all the TLBs out of the mmu lock without TLB
 	 * corruption since we just change the spte from writable to
@@ -5649,10 +5653,14 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 
 	write_lock(&kvm->mmu_lock);
 	flush = slot_handle_leaf(kvm, memslot, __rmap_clear_dirty, false);
-	if (is_tdp_mmu_enabled(kvm))
-		flush |= kvm_tdp_mmu_clear_dirty_slot(kvm, memslot);
 	write_unlock(&kvm->mmu_lock);
 
+	if (is_tdp_mmu_enabled(kvm)) {
+		read_lock(&kvm->mmu_lock);
+		flush |= kvm_tdp_mmu_clear_dirty_slot(kvm, memslot);
+		read_unlock(&kvm->mmu_lock);
+	}
+
 	/*
 	 * It's also safe to flush TLBs out of mmu lock here as currently this
 	 * function is only used for dirty logging, in which case flushing TLB
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 0e6ffa04e5e1..501722a524a7 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -496,8 +496,9 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 }
 
 /*
- * tdp_mmu_set_spte_atomic - Set a TDP MMU SPTE atomically and handle the
- * associated bookkeeping
+ * tdp_mmu_set_spte_atomic_no_dirty_log - Set a TDP MMU SPTE atomically
+ * and handle the associated bookkeeping, but do not mark the page dirty
+ * in KVM's dirty bitmaps.
  *
  * @kvm: kvm instance
  * @iter: a tdp_iter instance currently on the SPTE that should be set
@@ -505,9 +506,9 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
  * Returns: true if the SPTE was set, false if it was not. If false is returned,
  *	    this function will have no side-effects.
  */
-static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
-					   struct tdp_iter *iter,
-					   u64 new_spte)
+static inline bool tdp_mmu_set_spte_atomic_no_dirty_log(struct kvm *kvm,
+							struct tdp_iter *iter,
+							u64 new_spte)
 {
 	lockdep_assert_held_read(&kvm->mmu_lock);
 
@@ -522,12 +523,25 @@ static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
 		      new_spte) != iter->old_spte)
 		return false;
 
-	handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
-			    new_spte, iter->level, true);
+	__handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
+			      new_spte, iter->level, true);
+	handle_changed_spte_acc_track(iter->old_spte, new_spte, iter->level);
 
 	return true;
 }
 
+static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
+					   struct tdp_iter *iter,
+					   u64 new_spte)
+{
+	if (!tdp_mmu_set_spte_atomic_no_dirty_log(kvm, iter, new_spte))
+		return false;
+
+	handle_changed_spte_dirty_log(kvm, iter->as_id, iter->gfn,
+				      iter->old_spte, new_spte, iter->level);
+	return true;
+}
+
 static inline bool tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 					   struct tdp_iter *iter)
 {
@@ -1148,7 +1162,8 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	for_each_tdp_pte_min_level(iter, root->spt, root->role.level,
 				   min_level, start, end) {
-		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, false))
+retry:
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
 			continue;
 
 		if (!is_shadow_present_pte(iter.old_spte) ||
@@ -1158,7 +1173,15 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 		new_spte = iter.old_spte & ~PT_WRITABLE_MASK;
 
-		tdp_mmu_set_spte_no_dirty_log(kvm, &iter, new_spte);
+		if (!tdp_mmu_set_spte_atomic_no_dirty_log(kvm, &iter,
+							  new_spte)) {
+			/*
+			 * The iter must explicitly re-read the SPTE because
+			 * the atomic cmpxchg failed.
+			 */
+			iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
+			goto retry;
+		}
 		spte_set = true;
 	}
 
@@ -1177,7 +1200,9 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm, struct kvm_memory_slot *slot,
 	struct kvm_mmu_page *root;
 	bool spte_set = false;
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, false)
+	lockdep_assert_held_read(&kvm->mmu_lock);
+
+	for_each_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, true)
 		spte_set |= wrprot_gfn_range(kvm, root, slot->base_gfn,
 			     slot->base_gfn + slot->npages, min_level);
 
@@ -1201,7 +1226,8 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 	rcu_read_lock();
 
 	tdp_root_for_each_leaf_pte(iter, root, start, end) {
-		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, false))
+retry:
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
 			continue;
 
 		if (spte_ad_need_write_protect(iter.old_spte)) {
@@ -1216,7 +1242,15 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 				continue;
 		}
 
-		tdp_mmu_set_spte_no_dirty_log(kvm, &iter, new_spte);
+		if (!tdp_mmu_set_spte_atomic_no_dirty_log(kvm, &iter,
+							  new_spte)) {
+			/*
+			 * The iter must explicitly re-read the SPTE because
+			 * the atomic cmpxchg failed.
+			 */
+			iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
+			goto retry;
+		}
 		spte_set = true;
 	}
 
@@ -1236,7 +1270,9 @@ bool kvm_tdp_mmu_clear_dirty_slot(struct kvm *kvm, struct kvm_memory_slot *slot)
 	struct kvm_mmu_page *root;
 	bool spte_set = false;
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, false)
+	lockdep_assert_held_read(&kvm->mmu_lock);
+
+	for_each_tdp_mmu_root_yield_safe(kvm, root, slot->as_id, true)
 		spte_set |= clear_dirty_gfn_range(kvm, root, slot->base_gfn,
 				slot->base_gfn + slot->npages);
 
-- 
2.31.0.208.g409f899ff0-goog

