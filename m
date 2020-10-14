Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E310E28E65C
	for <lists+kvm@lfdr.de>; Wed, 14 Oct 2020 20:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389148AbgJNS2T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Oct 2020 14:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389154AbgJNS1c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Oct 2020 14:27:32 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13409C0613D4
        for <kvm@vger.kernel.org>; Wed, 14 Oct 2020 11:27:32 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id y7so51559pff.20
        for <kvm@vger.kernel.org>; Wed, 14 Oct 2020 11:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=KKZHJtN9WqXgoLgBZcTpcZR4f5FGT7hOVvseCh/jLD8=;
        b=gHohKNtW2c5TmlJfXi/3rU0gyJiqyjHyPQhe77N8pHNMqjdQbI80GoTHlCGJbH2heZ
         0OsYXtbr3ktioOcu/GGvBBnoUVqM8EuHKnO68Wuz76Td8mKNR5MzCm5dNsD02Y6+PNM4
         DOo1JBNcSQksG6EESJ/q8EXOVA8L+zS9EZOtZnmBY+/Tglkwj48HEtRpxRydxMNcujk8
         ledMDL33kwgxvneqNCVZ+Jftjaz/S47XKWZCFaFXDwyoBfZPQDXqXeFa+fR2Lz5MCMCH
         U5SE2cp4WVJ9MFcEtvrlZTX5+n37M0fuAhVZ/t27Jjev9ZVLy055drOUni9zvCOhWVkP
         9Luw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=KKZHJtN9WqXgoLgBZcTpcZR4f5FGT7hOVvseCh/jLD8=;
        b=e0C81W12IXYm7gNn1TIITWup51w/+LQE/QWBytezy1l/0t13vMgS4mAREMbP+MPBQR
         L5rIIQY371fQKV+qcazAIpiftDOH+gR3fNwteNQQyL4VQeb55eY665ybPbHWPc7t3rRg
         W7hSF9R6vRCsjukyGZJkdWgbWH2YzevvuYW/XxCFnqPYMXQBWgVuoCNqnmoELpA1Qm8c
         XSJvUAK96C6MFCOdHZ1QI1+/8x89LY/p0sdXx/yCPMRaR5kEyWH9zHzTKpxoTOkmDJdM
         bMyiHvrbQKEcSCgev8vlIxQyZfenZ5fUTPcviVs+nXgunBUNWhOG6YIrXycDylgTGDE1
         4SXw==
X-Gm-Message-State: AOAM530VfM5q3zimQrPNE1EwW8cifYmlkEcI+gU9ClTwXPXwLC5092E9
        6IY3hfIeuspJ8RTpsMDZC2PG3RRA5/KH
X-Google-Smtp-Source: ABdhPJyDMNlYqOv1eulnBDaRClPa67kalSmyoiSoBZFtJVhaUek7N6JC5WY1G7twpjYOjEFZVfckq0FQNKPL
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a17:90a:94cc:: with SMTP id
 j12mr482198pjw.106.1602700051568; Wed, 14 Oct 2020 11:27:31 -0700 (PDT)
Date:   Wed, 14 Oct 2020 11:26:55 -0700
In-Reply-To: <20201014182700.2888246-1-bgardon@google.com>
Message-Id: <20201014182700.2888246-16-bgardon@google.com>
Mime-Version: 1.0
References: <20201014182700.2888246-1-bgardon@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v2 15/20] kvm: x86/mmu: Support dirty logging for the TDP MMU
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Cannon Matthews <cannonmatthews@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
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

Dirty logging is a key feature of the KVM MMU and must be supported by
the TDP MMU. Add support for both the write protection and PML dirty
logging modes.

Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
machine. This series introduced no new failures.

This series can be viewed in Gerrit at:
	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c          |  20 ++-
 arch/x86/kvm/mmu/mmu_internal.h |   6 +
 arch/x86/kvm/mmu/tdp_iter.h     |   7 +-
 arch/x86/kvm/mmu/tdp_mmu.c      | 292 +++++++++++++++++++++++++++++++-
 arch/x86/kvm/mmu/tdp_mmu.h      |  10 ++
 include/linux/kvm_host.h        |   1 +
 virt/kvm/kvm_main.c             |   6 +-
 7 files changed, 327 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ef9ea3f45241b..b2ce57761d2f1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -277,12 +277,6 @@ static inline bool kvm_vcpu_ad_need_write_protect(struct kvm_vcpu *vcpu)
 	return vcpu->arch.mmu == &vcpu->arch.guest_mmu;
 }
 
-static inline bool spte_ad_need_write_protect(u64 spte)
-{
-	MMU_WARN_ON(is_mmio_spte(spte));
-	return (spte & SPTE_SPECIAL_MASK) != SPTE_AD_ENABLED_MASK;
-}
-
 bool is_nx_huge_page_enabled(void)
 {
 	return READ_ONCE(nx_huge_pages);
@@ -1483,6 +1477,9 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 {
 	struct kvm_rmap_head *rmap_head;
 
+	if (kvm->arch.tdp_mmu_enabled)
+		kvm_tdp_mmu_clear_dirty_pt_masked(kvm, slot,
+				slot->base_gfn + gfn_offset, mask, true);
 	while (mask) {
 		rmap_head = __gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
 					  PG_LEVEL_4K, slot);
@@ -1509,6 +1506,9 @@ void kvm_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 {
 	struct kvm_rmap_head *rmap_head;
 
+	if (kvm->arch.tdp_mmu_enabled)
+		kvm_tdp_mmu_clear_dirty_pt_masked(kvm, slot,
+				slot->base_gfn + gfn_offset, mask, false);
 	while (mask) {
 		rmap_head = __gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
 					  PG_LEVEL_4K, slot);
@@ -5853,6 +5853,8 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 	spin_lock(&kvm->mmu_lock);
 	flush = slot_handle_level(kvm, memslot, slot_rmap_write_protect,
 				start_level, KVM_MAX_HUGEPAGE_LEVEL, false);
+	if (kvm->arch.tdp_mmu_enabled)
+		flush |= kvm_tdp_mmu_wrprot_slot(kvm, memslot, PG_LEVEL_4K);
 	spin_unlock(&kvm->mmu_lock);
 
 	/*
@@ -5941,6 +5943,8 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 
 	spin_lock(&kvm->mmu_lock);
 	flush = slot_handle_leaf(kvm, memslot, __rmap_clear_dirty, false);
+	if (kvm->arch.tdp_mmu_enabled)
+		flush |= kvm_tdp_mmu_clear_dirty_slot(kvm, memslot);
 	spin_unlock(&kvm->mmu_lock);
 
 	/*
@@ -5962,6 +5966,8 @@ void kvm_mmu_slot_largepage_remove_write_access(struct kvm *kvm,
 	spin_lock(&kvm->mmu_lock);
 	flush = slot_handle_large_level(kvm, memslot, slot_rmap_write_protect,
 					false);
+	if (kvm->arch.tdp_mmu_enabled)
+		flush |= kvm_tdp_mmu_wrprot_slot(kvm, memslot, PG_LEVEL_2M);
 	spin_unlock(&kvm->mmu_lock);
 
 	if (flush)
@@ -5976,6 +5982,8 @@ void kvm_mmu_slot_set_dirty(struct kvm *kvm,
 
 	spin_lock(&kvm->mmu_lock);
 	flush = slot_handle_all_level(kvm, memslot, __rmap_set_dirty, false);
+	if (kvm->arch.tdp_mmu_enabled)
+		flush |= kvm_tdp_mmu_slot_set_dirty(kvm, memslot);
 	spin_unlock(&kvm->mmu_lock);
 
 	if (flush)
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 49c3a04d2b894..a7230532bb845 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -232,6 +232,12 @@ static inline bool is_executable_pte(u64 spte)
 	return (spte & (shadow_x_mask | shadow_nx_mask)) == shadow_x_mask;
 }
 
+static inline bool spte_ad_need_write_protect(u64 spte)
+{
+	MMU_WARN_ON(is_mmio_spte(spte));
+	return (spte & SPTE_SPECIAL_MASK) != SPTE_AD_ENABLED_MASK;
+}
+
 void kvm_flush_remote_tlbs_with_address(struct kvm *kvm, u64 start_gfn,
 					u64 pages);
 
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index 884ed2c70bfed..47170d0dc98e5 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -41,11 +41,14 @@ struct tdp_iter {
  * Iterates over every SPTE mapping the GFN range [start, end) in a
  * preorder traversal.
  */
-#define for_each_tdp_pte(iter, root, root_level, start, end) \
-	for (tdp_iter_start(&iter, root, root_level, PG_LEVEL_4K, start); \
+#define for_each_tdp_pte_min_level(iter, root, root_level, min_level, start, end) \
+	for (tdp_iter_start(&iter, root, root_level, min_level, start); \
 	     iter.valid && iter.gfn < end;		     \
 	     tdp_iter_next(&iter))
 
+#define for_each_tdp_pte(iter, root, root_level, start, end) \
+	for_each_tdp_pte_min_level(iter, root, root_level, PG_LEVEL_4K, start, end)
+
 u64 *spte_to_child_pt(u64 pte, int level);
 
 void tdp_iter_start(struct tdp_iter *iter, u64 *root_pt, int root_level,
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 90abd55c89375..099c7d68aeb1d 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -180,6 +180,24 @@ static void handle_changed_spte_acc_track(u64 old_spte, u64 new_spte, int level)
 		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
 }
 
+static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
+					  u64 old_spte, u64 new_spte, int level)
+{
+	bool pfn_changed;
+	struct kvm_memory_slot *slot;
+
+	if (level > PG_LEVEL_4K)
+		return;
+
+	pfn_changed = spte_to_pfn(old_spte) != spte_to_pfn(new_spte);
+
+	if ((!is_writable_pte(old_spte) || pfn_changed) &&
+	    is_writable_pte(new_spte)) {
+		slot = __gfn_to_memslot(__kvm_memslots(kvm, as_id), gfn);
+		mark_page_dirty_in_slot(slot, gfn);
+	}
+}
+
 /**
  * handle_changed_spte - handle bookkeeping associated with an SPTE change
  * @kvm: kvm instance
@@ -292,10 +310,13 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 {
 	__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level);
 	handle_changed_spte_acc_track(old_spte, new_spte, level);
+	handle_changed_spte_dirty_log(kvm, as_id, gfn, old_spte,
+				      new_spte, level);
 }
 
 static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
-				      u64 new_spte, bool record_acc_track)
+				      u64 new_spte, bool record_acc_track,
+				      bool record_dirty_log)
 {
 	u64 *root_pt = tdp_iter_root_pt(iter);
 	struct kvm_mmu_page *root = sptep_to_sp(root_pt);
@@ -308,19 +329,30 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 	if (record_acc_track)
 		handle_changed_spte_acc_track(iter->old_spte, new_spte,
 					      iter->level);
+	if (record_dirty_log)
+		handle_changed_spte_dirty_log(kvm, as_id, iter->gfn,
+					      iter->old_spte, new_spte,
+					      iter->level);
 }
 
 static inline void tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 				    u64 new_spte)
 {
-	__tdp_mmu_set_spte(kvm, iter, new_spte, true);
+	__tdp_mmu_set_spte(kvm, iter, new_spte, true, true);
 }
 
 static inline void tdp_mmu_set_spte_no_acc_track(struct kvm *kvm,
 						 struct tdp_iter *iter,
 						 u64 new_spte)
 {
-	__tdp_mmu_set_spte(kvm, iter, new_spte, false);
+	__tdp_mmu_set_spte(kvm, iter, new_spte, false, true);
+}
+
+static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
+						 struct tdp_iter *iter,
+						 u64 new_spte)
+{
+	__tdp_mmu_set_spte(kvm, iter, new_spte, true, false);
 }
 
 #define tdp_root_for_each_pte(_iter, _root, _start, _end) \
@@ -644,6 +676,7 @@ static int age_gfn_range(struct kvm *kvm, struct kvm_memory_slot *slot,
 
 			new_spte = mark_spte_for_access_track(new_spte);
 		}
+		new_spte &= ~shadow_dirty_mask;
 
 		tdp_mmu_set_spte_no_acc_track(kvm, &iter, new_spte);
 		young = 1;
@@ -733,3 +766,256 @@ int kvm_tdp_mmu_set_spte_hva(struct kvm *kvm, unsigned long address,
 					    set_tdp_spte);
 }
 
+/*
+ * Remove write access from all the SPTEs mapping GFNs [start, end). If
+ * skip_4k is set, SPTEs that map 4k pages, will not be write-protected.
+ * Returns true if an SPTE has been changed and the TLBs need to be flushed.
+ */
+static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
+			     gfn_t start, gfn_t end, int min_level)
+{
+	struct tdp_iter iter;
+	u64 new_spte;
+	bool spte_set = false;
+
+	BUG_ON(min_level > KVM_MAX_HUGEPAGE_LEVEL);
+
+	for_each_tdp_pte_min_level(iter, root->spt, root->role.level,
+				   min_level, start, end) {
+		if (!is_shadow_present_pte(iter.old_spte) ||
+		    !is_last_spte(iter.old_spte, iter.level))
+			continue;
+
+		new_spte = iter.old_spte & ~PT_WRITABLE_MASK;
+
+		tdp_mmu_set_spte_no_dirty_log(kvm, &iter, new_spte);
+		spte_set = true;
+
+		tdp_mmu_iter_cond_resched(kvm, &iter);
+	}
+	return spte_set;
+}
+
+/*
+ * Remove write access from all the SPTEs mapping GFNs in the memslot. Will
+ * only affect leaf SPTEs down to min_level.
+ * Returns true if an SPTE has been changed and the TLBs need to be flushed.
+ */
+bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm, struct kvm_memory_slot *slot,
+			     int min_level)
+{
+	struct kvm_mmu_page *root;
+	int root_as_id;
+	bool spte_set = false;
+
+	for_each_tdp_mmu_root(kvm, root) {
+		root_as_id = kvm_mmu_page_as_id(root);
+		if (root_as_id != slot->as_id)
+			continue;
+
+		/*
+		 * Take a reference on the root so that it cannot be freed if
+		 * this thread releases the MMU lock and yields in this loop.
+		 */
+		get_tdp_mmu_root(kvm, root);
+
+		spte_set = wrprot_gfn_range(kvm, root, slot->base_gfn,
+				slot->base_gfn + slot->npages, min_level) ||
+			   spte_set;
+
+		put_tdp_mmu_root(kvm, root);
+	}
+
+	return spte_set;
+}
+
+/*
+ * Clear the dirty status of all the SPTEs mapping GFNs in the memslot. If
+ * AD bits are enabled, this will involve clearing the dirty bit on each SPTE.
+ * If AD bits are not enabled, this will require clearing the writable bit on
+ * each SPTE. Returns true if an SPTE has been changed and the TLBs need to
+ * be flushed.
+ */
+static bool clear_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
+			   gfn_t start, gfn_t end)
+{
+	struct tdp_iter iter;
+	u64 new_spte;
+	bool spte_set = false;
+
+	tdp_root_for_each_leaf_pte(iter, root, start, end) {
+		if (spte_ad_need_write_protect(iter.old_spte)) {
+			if (is_writable_pte(iter.old_spte))
+				new_spte = iter.old_spte & ~PT_WRITABLE_MASK;
+			else
+				continue;
+		} else {
+			if (iter.old_spte & shadow_dirty_mask)
+				new_spte = iter.old_spte & ~shadow_dirty_mask;
+			else
+				continue;
+		}
+
+		tdp_mmu_set_spte_no_dirty_log(kvm, &iter, new_spte);
+		spte_set = true;
+
+		tdp_mmu_iter_cond_resched(kvm, &iter);
+	}
+	return spte_set;
+}
+
+/*
+ * Clear the dirty status of all the SPTEs mapping GFNs in the memslot. If
+ * AD bits are enabled, this will involve clearing the dirty bit on each SPTE.
+ * If AD bits are not enabled, this will require clearing the writable bit on
+ * each SPTE. Returns true if an SPTE has been changed and the TLBs need to
+ * be flushed.
+ */
+bool kvm_tdp_mmu_clear_dirty_slot(struct kvm *kvm, struct kvm_memory_slot *slot)
+{
+	struct kvm_mmu_page *root;
+	int root_as_id;
+	bool spte_set = false;
+
+	for_each_tdp_mmu_root(kvm, root) {
+		root_as_id = kvm_mmu_page_as_id(root);
+		if (root_as_id != slot->as_id)
+			continue;
+
+		/*
+		 * Take a reference on the root so that it cannot be freed if
+		 * this thread releases the MMU lock and yields in this loop.
+		 */
+		get_tdp_mmu_root(kvm, root);
+
+		spte_set = clear_dirty_gfn_range(kvm, root, slot->base_gfn,
+				slot->base_gfn + slot->npages) || spte_set;
+
+		put_tdp_mmu_root(kvm, root);
+	}
+
+	return spte_set;
+}
+
+/*
+ * Clears the dirty status of all the 4k SPTEs mapping GFNs for which a bit is
+ * set in mask, starting at gfn. The given memslot is expected to contain all
+ * the GFNs represented by set bits in the mask. If AD bits are enabled,
+ * clearing the dirty status will involve clearing the dirty bit on each SPTE
+ * or, if AD bits are not enabled, clearing the writable bit on each SPTE.
+ */
+static void clear_dirty_pt_masked(struct kvm *kvm, struct kvm_mmu_page *root,
+				  gfn_t gfn, unsigned long mask, bool wrprot)
+{
+	struct tdp_iter iter;
+	u64 new_spte;
+
+	tdp_root_for_each_leaf_pte(iter, root, gfn + __ffs(mask),
+				    gfn + BITS_PER_LONG) {
+		if (!mask)
+			break;
+
+		if (iter.level > PG_LEVEL_4K ||
+		    !(mask & (1UL << (iter.gfn - gfn))))
+			continue;
+
+		if (wrprot || spte_ad_need_write_protect(iter.old_spte)) {
+			if (is_writable_pte(iter.old_spte))
+				new_spte = iter.old_spte & ~PT_WRITABLE_MASK;
+			else
+				continue;
+		} else {
+			if (iter.old_spte & shadow_dirty_mask)
+				new_spte = iter.old_spte & ~shadow_dirty_mask;
+			else
+				continue;
+		}
+
+		tdp_mmu_set_spte_no_dirty_log(kvm, &iter, new_spte);
+
+		mask &= ~(1UL << (iter.gfn - gfn));
+	}
+}
+
+/*
+ * Clears the dirty status of all the 4k SPTEs mapping GFNs for which a bit is
+ * set in mask, starting at gfn. The given memslot is expected to contain all
+ * the GFNs represented by set bits in the mask. If AD bits are enabled,
+ * clearing the dirty status will involve clearing the dirty bit on each SPTE
+ * or, if AD bits are not enabled, clearing the writable bit on each SPTE.
+ */
+void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
+				       struct kvm_memory_slot *slot,
+				       gfn_t gfn, unsigned long mask,
+				       bool wrprot)
+{
+	struct kvm_mmu_page *root;
+	int root_as_id;
+
+	lockdep_assert_held(&kvm->mmu_lock);
+	for_each_tdp_mmu_root(kvm, root) {
+		root_as_id = kvm_mmu_page_as_id(root);
+		if (root_as_id != slot->as_id)
+			continue;
+
+		clear_dirty_pt_masked(kvm, root, gfn, mask, wrprot);
+	}
+}
+
+/*
+ * Set the dirty status of all the SPTEs mapping GFNs in the memslot. This is
+ * only used for PML, and so will involve setting the dirty bit on each SPTE.
+ * Returns true if an SPTE has been changed and the TLBs need to be flushed.
+ */
+static bool set_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
+				gfn_t start, gfn_t end)
+{
+	struct tdp_iter iter;
+	u64 new_spte;
+	bool spte_set = false;
+
+	tdp_root_for_each_pte(iter, root, start, end) {
+		if (!is_shadow_present_pte(iter.old_spte))
+			continue;
+
+		new_spte = iter.old_spte | shadow_dirty_mask;
+
+		tdp_mmu_set_spte(kvm, &iter, new_spte);
+		spte_set = true;
+
+		tdp_mmu_iter_cond_resched(kvm, &iter);
+	}
+
+	return spte_set;
+}
+
+/*
+ * Set the dirty status of all the SPTEs mapping GFNs in the memslot. This is
+ * only used for PML, and so will involve setting the dirty bit on each SPTE.
+ * Returns true if an SPTE has been changed and the TLBs need to be flushed.
+ */
+bool kvm_tdp_mmu_slot_set_dirty(struct kvm *kvm, struct kvm_memory_slot *slot)
+{
+	struct kvm_mmu_page *root;
+	int root_as_id;
+	bool spte_set = false;
+
+	for_each_tdp_mmu_root(kvm, root) {
+		root_as_id = kvm_mmu_page_as_id(root);
+		if (root_as_id != slot->as_id)
+			continue;
+
+		/*
+		 * Take a reference on the root so that it cannot be freed if
+		 * this thread releases the MMU lock and yields in this loop.
+		 */
+		get_tdp_mmu_root(kvm, root);
+
+		spte_set = set_dirty_gfn_range(kvm, root, slot->base_gfn,
+				slot->base_gfn + slot->npages) || spte_set;
+
+		put_tdp_mmu_root(kvm, root);
+	}
+	return spte_set;
+}
+
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 6569792f40d4f..add8bb97c56dd 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -28,4 +28,14 @@ int kvm_tdp_mmu_test_age_hva(struct kvm *kvm, unsigned long hva);
 
 int kvm_tdp_mmu_set_spte_hva(struct kvm *kvm, unsigned long address,
 			     pte_t *host_ptep);
+
+bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm, struct kvm_memory_slot *slot,
+			     int min_level);
+bool kvm_tdp_mmu_clear_dirty_slot(struct kvm *kvm,
+				  struct kvm_memory_slot *slot);
+void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
+				       struct kvm_memory_slot *slot,
+				       gfn_t gfn, unsigned long mask,
+				       bool wrprot);
+bool kvm_tdp_mmu_slot_set_dirty(struct kvm *kvm, struct kvm_memory_slot *slot);
 #endif /* __KVM_X86_MMU_TDP_MMU_H */
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c6f45687ba89c..7f2e2a09ebbd9 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -798,6 +798,7 @@ struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn);
 bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn);
 bool kvm_vcpu_is_visible_gfn(struct kvm_vcpu *vcpu, gfn_t gfn);
 unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn);
+void mark_page_dirty_in_slot(struct kvm_memory_slot *memslot, gfn_t gfn);
 void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
 
 struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2e85392131252..2541a17ff1c45 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -143,8 +143,6 @@ static void hardware_disable_all(void);
 
 static void kvm_io_bus_destroy(struct kvm_io_bus *bus);
 
-static void mark_page_dirty_in_slot(struct kvm_memory_slot *memslot, gfn_t gfn);
-
 __visible bool kvm_rebooting;
 EXPORT_SYMBOL_GPL(kvm_rebooting);
 
@@ -2645,8 +2643,7 @@ int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len)
 }
 EXPORT_SYMBOL_GPL(kvm_clear_guest);
 
-static void mark_page_dirty_in_slot(struct kvm_memory_slot *memslot,
-				    gfn_t gfn)
+void mark_page_dirty_in_slot(struct kvm_memory_slot *memslot, gfn_t gfn)
 {
 	if (memslot && memslot->dirty_bitmap) {
 		unsigned long rel_gfn = gfn - memslot->base_gfn;
@@ -2654,6 +2651,7 @@ static void mark_page_dirty_in_slot(struct kvm_memory_slot *memslot,
 		set_bit_le(rel_gfn, memslot->dirty_bitmap);
 	}
 }
+EXPORT_SYMBOL_GPL(mark_page_dirty_in_slot);
 
 void mark_page_dirty(struct kvm *kvm, gfn_t gfn)
 {
-- 
2.28.0.1011.ga647a8990f-goog

