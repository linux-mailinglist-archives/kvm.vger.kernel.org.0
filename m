Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57AFC3508F3
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 23:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233119AbhCaVKE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 17:10:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232883AbhCaVJd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Mar 2021 17:09:33 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 423A7C06174A
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 14:09:32 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id f20so2088701pgj.6
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 14:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=g4yhsGdq/iXeJP11WQ8LbSIQn68/bjXt6uk7V5jIWEA=;
        b=UST8JH9MDT8t1R7djBJIoYHjYxYXADs6eFafwKsZnUgDg3bQNZSUccc0+ydBqiz1Ze
         AhEdXbRNSzIKsUtT21vNZ0j7oGU+1Ge/KzXmlRujzOwmuXPDBQOoHSbVOLik1uFbNBhn
         0ZMbvLgObsPAmAnmIJI8Odnu2mVs00kqDgK3AuEkp821thrx4rvKR1HhbN8I8QslhIJE
         at85bkpgHiPCL1FmQ3EjRpCsMAlDaQltkk6cZXBwjPYIuUGEY3U1imWKSJITfZlh07oR
         t1ZDTt6rmj87Qg6wQUTL0J4xplIFhjhHnzDb9poKvBgc+4Lqb4lQcfacw55CojY+uCYc
         oLzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=g4yhsGdq/iXeJP11WQ8LbSIQn68/bjXt6uk7V5jIWEA=;
        b=V1e1gxBdnD8omXNh1AO5Xe2zVn+d4leQ1tx79z3LDT0vT52WAEhQqnNU42PI6ft7W/
         1i/eHDOP4WKh3lIPpwtDcap6mWT1n8JUXvWvAWRLcgbwT1qyPT+p1mAcisteXdkLn+c5
         x8LOxYPDmi4o15EtLYuSYqSyrYDSpKbCLEyvxiEIm0IXvbaOQfVpwZ+BcXeX3QmYZIhO
         6dhGmO8RSqwOSZtJPxg4WsF7OGOSuId0BAj3cr4maxXImdsVVwsTHPm3th22nZt9kykm
         eipJDeEaxdbVQbnAnyZBTPmyyTB5rv0mPC2pPozU2IfyFSQS+i8ZC808yGPzeImQl2cQ
         nuRg==
X-Gm-Message-State: AOAM530L23oTeta1rwcBtgrYjm+FrQbUiWtIx3KYcrmr3XuHc0QZTlS0
        AWYrcAL0//KlosfkmIHhmAPjJe9lKySr
X-Google-Smtp-Source: ABdhPJwsLiU1eIc2FCVKYgkLLh79Ri95VB2mDC1fL88Gb2BrJ/QT2sNyV/2IbkfKnBV+NeJiFqLJ0xAlIA/w
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:8026:6888:3d55:3842])
 (user=bgardon job=sendgmr) by 2002:a17:902:e882:b029:e6:caba:fff6 with SMTP
 id w2-20020a170902e882b02900e6cabafff6mr4843196plg.73.1617224972205; Wed, 31
 Mar 2021 14:09:32 -0700 (PDT)
Date:   Wed, 31 Mar 2021 14:08:39 -0700
In-Reply-To: <20210331210841.3996155-1-bgardon@google.com>
Message-Id: <20210331210841.3996155-12-bgardon@google.com>
Mime-Version: 1.0
References: <20210331210841.3996155-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 11/13] KVM: x86/mmu: Allow enabling / disabling dirty logging
 under MMU read lock
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
index 81967b4e7d76..bf535c9f7ff2 100644
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
@@ -5641,10 +5645,14 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 
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
index 862acb868abd..0c90dc034819 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -491,8 +491,9 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
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
@@ -500,9 +501,9 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
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
 
@@ -517,9 +518,22 @@ static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
 		      new_spte) != iter->old_spte)
 		return false;
 
-	handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
-			    new_spte, iter->level, true);
+	__handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
+			      new_spte, iter->level, true);
+	handle_changed_spte_acc_track(iter->old_spte, new_spte, iter->level);
+
+	return true;
+}
+
+static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
+					   struct tdp_iter *iter,
+					   u64 new_spte)
+{
+	if (!tdp_mmu_set_spte_atomic_no_dirty_log(kvm, iter, new_spte))
+		return false;
 
+	handle_changed_spte_dirty_log(kvm, iter->as_id, iter->gfn,
+				      iter->old_spte, new_spte, iter->level);
 	return true;
 }
 
@@ -1142,7 +1156,8 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	for_each_tdp_pte_min_level(iter, root->spt, root->role.level,
 				   min_level, start, end) {
-		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, false))
+retry:
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
 			continue;
 
 		if (!is_shadow_present_pte(iter.old_spte) ||
@@ -1152,7 +1167,15 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
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
 
@@ -1172,7 +1195,9 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm, struct kvm_memory_slot *slot,
 	int root_as_id;
 	bool spte_set = false;
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root, false) {
+	lockdep_assert_held_read(&kvm->mmu_lock);
+
+	for_each_tdp_mmu_root_yield_safe(kvm, root, true) {
 		root_as_id = kvm_mmu_page_as_id(root);
 		if (root_as_id != slot->as_id)
 			continue;
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
 
@@ -1237,7 +1271,9 @@ bool kvm_tdp_mmu_clear_dirty_slot(struct kvm *kvm, struct kvm_memory_slot *slot)
 	int root_as_id;
 	bool spte_set = false;
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root, false) {
+	lockdep_assert_held_read(&kvm->mmu_lock);
+
+	for_each_tdp_mmu_root_yield_safe(kvm, root, true) {
 		root_as_id = kvm_mmu_page_as_id(root);
 		if (root_as_id != slot->as_id)
 			continue;
-- 
2.31.0.291.g576ba9dcdaf-goog

