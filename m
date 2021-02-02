Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6B3630CAF9
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 20:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239456AbhBBTIA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 14:08:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239432AbhBBTDv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 14:03:51 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFF79C061BD1
        for <kvm@vger.kernel.org>; Tue,  2 Feb 2021 10:58:26 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id z2so10916137pln.18
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 10:58:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=Ea/WfcZfvg2RR5BqxG5prQgL5AJRdv/sOQkRymma1pQ=;
        b=KkwrCFNyw92sZ83NDZJSCE35gzQiP7qB54jgVjdHH/FfchU1kzyYP2mVrsxUfA/NV5
         k0lWkoueYtDF3SNduP/l8UmLhWsVyhMsHdUGJBrpo4Kv4e2iVoJMHpTYkN3WngxpFnH1
         VQvj8ItpN+2gWxFoQLy9gc6me3kIt5QrHCf8E1xWtbykmmNROxArfsD79UvdZ4suAbQZ
         cNufnBytD9FrmMnpfO1fNVLYgWPvTrP7kvolakobbEaebBSvVmN4qLcZQQZf1FBxtVcz
         mwUn7KUddvVDQMwpozQhp/ywo05Rdj0RiZyyletUQ8zFEYVuptozieGsgfyl9ZMlrFdS
         zuHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Ea/WfcZfvg2RR5BqxG5prQgL5AJRdv/sOQkRymma1pQ=;
        b=lTR75rMRpc9usUp5cka5e3qqebKRmioOwFJuNwE72pQ++TY32maXkCna9gfShTCFkY
         AN32z8CZfM5iCgtdDXeyxIkGnf13Rw2sBsa1cc7QTaurESPznxc58rZ/WPQV3u9pVsZW
         OKA1AbIZ2OaJRQFUxcs6ERfhjDhTodN/RGmD6GUGMDWrOk+STYtq6Vhkx9UBGu6ws0F4
         +9CLDwDIk0N7nPdcGpY5mLQlngL5KqsOK1bpNJBLSy2onzI9It6ft3IId7mjEo0VijHC
         E8FwoIUHJ9B0OtgZ/2vJ2IivjP7uXgYYRjiKg0pDzxL1px4urfa8Q2aFWowXFFOuxE0V
         COOg==
X-Gm-Message-State: AOAM530f/OVT1NE2bdnwmmcH6g/y6Bbl618zX2pU4bUXPg2jM9bmHTMs
        OCcrgX4vuKIPgpHVsEpcYSgg7rGJOPRy
X-Google-Smtp-Source: ABdhPJxyiV/VNdVF4hzY9QnU1Q6fO/z/S3yQ+VmReVkk9xb0WGhltjZWUgFeH6ioH3fhefmV2oLsrZtUlA9o
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:9090:561:5a98:6d47])
 (user=bgardon job=sendgmr) by 2002:a17:902:724c:b029:e1:4aae:c72 with SMTP id
 c12-20020a170902724cb02900e14aae0c72mr13132359pll.81.1612292306332; Tue, 02
 Feb 2021 10:58:26 -0800 (PST)
Date:   Tue,  2 Feb 2021 10:57:32 -0800
In-Reply-To: <20210202185734.1680553-1-bgardon@google.com>
Message-Id: <20210202185734.1680553-27-bgardon@google.com>
Mime-Version: 1.0
References: <20210202185734.1680553-1-bgardon@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH v2 26/28] KVM: x86/mmu: Allow enabling / disabling dirty
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


Extend dirty logging enable disable functions read lock-ness

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 14 +++---
 arch/x86/kvm/mmu/tdp_mmu.c | 93 ++++++++++++++++++++++++++++++--------
 arch/x86/kvm/mmu/tdp_mmu.h |  2 +-
 3 files changed, 84 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e3cf868be6bd..6ba2a72d4330 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5638,9 +5638,10 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 
 	write_lock(&kvm->mmu_lock);
 	flush = slot_handle_leaf(kvm, memslot, __rmap_clear_dirty, false);
+	write_unlock(&kvm->mmu_lock);
+
 	if (kvm->arch.tdp_mmu_enabled)
 		flush |= kvm_tdp_mmu_clear_dirty_slot(kvm, memslot);
-	write_unlock(&kvm->mmu_lock);
 
 	/*
 	 * It's also safe to flush TLBs out of mmu lock here as currently this
@@ -5661,9 +5662,10 @@ void kvm_mmu_slot_largepage_remove_write_access(struct kvm *kvm,
 	write_lock(&kvm->mmu_lock);
 	flush = slot_handle_large_level(kvm, memslot, slot_rmap_write_protect,
 					false);
+	write_unlock(&kvm->mmu_lock);
+
 	if (kvm->arch.tdp_mmu_enabled)
 		flush |= kvm_tdp_mmu_wrprot_slot(kvm, memslot, PG_LEVEL_2M);
-	write_unlock(&kvm->mmu_lock);
 
 	if (flush)
 		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
@@ -5677,12 +5679,12 @@ void kvm_mmu_slot_set_dirty(struct kvm *kvm,
 
 	write_lock(&kvm->mmu_lock);
 	flush = slot_handle_all_level(kvm, memslot, __rmap_set_dirty, false);
-	if (kvm->arch.tdp_mmu_enabled)
-		flush |= kvm_tdp_mmu_slot_set_dirty(kvm, memslot);
-	write_unlock(&kvm->mmu_lock);
-
 	if (flush)
 		kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
+	write_unlock(&kvm->mmu_lock);
+
+	if (kvm->arch.tdp_mmu_enabled)
+		kvm_tdp_mmu_slot_set_dirty(kvm, memslot);
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_slot_set_dirty);
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index cfe66b8d39fa..6093926a6bc5 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -553,18 +553,22 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 }
 
 /*
- * tdp_mmu_set_spte_atomic - Set a TDP MMU SPTE atomically and handle the
+ * __tdp_mmu_set_spte_atomic - Set a TDP MMU SPTE atomically and handle the
  * associated bookkeeping
  *
  * @kvm: kvm instance
  * @iter: a tdp_iter instance currently on the SPTE that should be set
  * @new_spte: The value the SPTE should be set to
+ * @record_dirty_log: Record the page as dirty in the dirty bitmap if
+ *		      appropriate for the change being made. Should be set
+ *		      unless performing certain dirty logging operations.
+ *		      Leaving record_dirty_log unset in that case prevents page
+ *		      writes from being double counted.
  * Returns: true if the SPTE was set, false if it was not. If false is returned,
  *	    this function will have no side-effects.
  */
-static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
-					   struct tdp_iter *iter,
-					   u64 new_spte)
+static inline bool __tdp_mmu_set_spte_atomic(struct kvm *kvm,
+		struct tdp_iter *iter, u64 new_spte, bool record_dirty_log)
 {
 	u64 *root_pt = tdp_iter_root_pt(iter);
 	struct kvm_mmu_page *root = sptep_to_sp(root_pt);
@@ -583,12 +587,31 @@ static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
 		      new_spte) != iter->old_spte)
 		return false;
 
-	handle_changed_spte(kvm, as_id, iter->gfn, iter->old_spte, new_spte,
-			    iter->level, true);
+	__handle_changed_spte(kvm, as_id, iter->gfn, iter->old_spte, new_spte,
+			      iter->level, true);
+	handle_changed_spte_acc_track(iter->old_spte, new_spte, iter->level);
+	if (record_dirty_log)
+		handle_changed_spte_dirty_log(kvm, as_id, iter->gfn,
+					      iter->old_spte, new_spte,
+					      iter->level);
 
 	return true;
 }
 
+static inline bool tdp_mmu_set_spte_atomic_no_dirty_log(struct kvm *kvm,
+							struct tdp_iter *iter,
+							u64 new_spte)
+{
+	return __tdp_mmu_set_spte_atomic(kvm, iter, new_spte, false);
+}
+
+static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
+					   struct tdp_iter *iter,
+					   u64 new_spte)
+{
+	return __tdp_mmu_set_spte_atomic(kvm, iter, new_spte, true);
+}
+
 static inline bool tdp_mmu_zap_spte_atomic(struct kvm *kvm,
 					   struct tdp_iter *iter)
 {
@@ -1206,7 +1229,8 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	for_each_tdp_pte_min_level(iter, root->spt, root->role.level,
 				   min_level, start, end) {
-		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, false))
+retry:
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
 			continue;
 
 		if (!is_shadow_present_pte(iter.old_spte) ||
@@ -1216,7 +1240,15 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
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
 
@@ -1236,7 +1268,8 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm, struct kvm_memory_slot *slot,
 	int root_as_id;
 	bool spte_set = false;
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root, false) {
+	read_lock(&kvm->mmu_lock);
+	for_each_tdp_mmu_root_yield_safe(kvm, root, true) {
 		root_as_id = kvm_mmu_page_as_id(root);
 		if (root_as_id != slot->as_id)
 			continue;
@@ -1244,6 +1277,7 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm, struct kvm_memory_slot *slot,
 		spte_set |= wrprot_gfn_range(kvm, root, slot->base_gfn,
 			     slot->base_gfn + slot->npages, min_level);
 	}
+	read_unlock(&kvm->mmu_lock);
 
 	return spte_set;
 }
@@ -1265,7 +1299,8 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 	rcu_read_lock();
 
 	tdp_root_for_each_leaf_pte(iter, root, start, end) {
-		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, false))
+retry:
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
 			continue;
 
 		if (spte_ad_need_write_protect(iter.old_spte)) {
@@ -1280,7 +1315,15 @@ static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
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
 
@@ -1301,7 +1344,8 @@ bool kvm_tdp_mmu_clear_dirty_slot(struct kvm *kvm, struct kvm_memory_slot *slot)
 	int root_as_id;
 	bool spte_set = false;
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root, false) {
+	read_lock(&kvm->mmu_lock);
+	for_each_tdp_mmu_root_yield_safe(kvm, root, true) {
 		root_as_id = kvm_mmu_page_as_id(root);
 		if (root_as_id != slot->as_id)
 			continue;
@@ -1309,6 +1353,7 @@ bool kvm_tdp_mmu_clear_dirty_slot(struct kvm *kvm, struct kvm_memory_slot *slot)
 		spte_set |= clear_dirty_gfn_range(kvm, root, slot->base_gfn,
 				slot->base_gfn + slot->npages);
 	}
+	read_unlock(&kvm->mmu_lock);
 
 	return spte_set;
 }
@@ -1397,7 +1442,8 @@ static bool set_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 	rcu_read_lock();
 
 	tdp_root_for_each_pte(iter, root, start, end) {
-		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, false))
+retry:
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
 			continue;
 
 		if (!is_shadow_present_pte(iter.old_spte) ||
@@ -1406,7 +1452,14 @@ static bool set_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 		new_spte = iter.old_spte | shadow_dirty_mask;
 
-		tdp_mmu_set_spte(kvm, &iter, new_spte);
+		if (!tdp_mmu_set_spte_atomic(kvm, &iter, new_spte)) {
+			/*
+			 * The iter must explicitly re-read the SPTE because
+			 * the atomic cmpxchg failed.
+			 */
+			iter.old_spte = READ_ONCE(*rcu_dereference(iter.sptep));
+			goto retry;
+		}
 		spte_set = true;
 	}
 
@@ -1417,15 +1470,15 @@ static bool set_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 /*
  * Set the dirty status of all the SPTEs mapping GFNs in the memslot. This is
  * only used for PML, and so will involve setting the dirty bit on each SPTE.
- * Returns true if an SPTE has been changed and the TLBs need to be flushed.
  */
-bool kvm_tdp_mmu_slot_set_dirty(struct kvm *kvm, struct kvm_memory_slot *slot)
+void kvm_tdp_mmu_slot_set_dirty(struct kvm *kvm, struct kvm_memory_slot *slot)
 {
 	struct kvm_mmu_page *root;
 	int root_as_id;
 	bool spte_set = false;
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root, false) {
+	read_lock(&kvm->mmu_lock);
+	for_each_tdp_mmu_root_yield_safe(kvm, root, true) {
 		root_as_id = kvm_mmu_page_as_id(root);
 		if (root_as_id != slot->as_id)
 			continue;
@@ -1433,7 +1486,11 @@ bool kvm_tdp_mmu_slot_set_dirty(struct kvm *kvm, struct kvm_memory_slot *slot)
 		spte_set |= set_dirty_gfn_range(kvm, root, slot->base_gfn,
 				slot->base_gfn + slot->npages);
 	}
-	return spte_set;
+
+	if (spte_set)
+		kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
+
+	read_unlock(&kvm->mmu_lock);
 }
 
 /*
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 10ada884270b..848b41b20985 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -38,7 +38,7 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 				       struct kvm_memory_slot *slot,
 				       gfn_t gfn, unsigned long mask,
 				       bool wrprot);
-bool kvm_tdp_mmu_slot_set_dirty(struct kvm *kvm, struct kvm_memory_slot *slot);
+void kvm_tdp_mmu_slot_set_dirty(struct kvm *kvm, struct kvm_memory_slot *slot);
 void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
 				       const struct kvm_memory_slot *slot);
 
-- 
2.30.0.365.g02bc693789-goog

