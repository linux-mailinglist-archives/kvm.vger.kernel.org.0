Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B95E22973CD
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 18:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751665AbgJWQbE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 12:31:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36219 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751602AbgJWQas (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Oct 2020 12:30:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603470645;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p9cT0dJVluzxFkEttep05GErxFKHJDY1dIK05HgXnTU=;
        b=ZHdxerWsJIj+2SNaXF2o5E4PKvJWZalvvhXsSeLBP5oq0OLX8MAsC5aAEDD1jgaxpJsmJo
        gXgZEMbL2qOxCI4vnzrUXxqKKr4kfQ2D83/vXFnLJs7e0YMu+1N8RZTPmJzE2sz9Nj/LUJ
        c1zeSINFEf6CpoC/M2pqvuVfM27yfVo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-570-Yqyktu9lMMemBBT-4iK5mQ-1; Fri, 23 Oct 2020 12:30:41 -0400
X-MC-Unique: Yqyktu9lMMemBBT-4iK5mQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3FF33EC10E;
        Fri, 23 Oct 2020 16:30:40 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DF28D60FC2;
        Fri, 23 Oct 2020 16:30:39 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     bgardon@google.com
Subject: [PATCH 17/22] kvm: x86/mmu: Support dirty logging for the TDP MMU
Date:   Fri, 23 Oct 2020 12:30:19 -0400
Message-Id: <20201023163024.2765558-18-pbonzini@redhat.com>
In-Reply-To: <20201023163024.2765558-1-pbonzini@redhat.com>
References: <20201023163024.2765558-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ben Gardon <bgardon@google.com>

Dirty logging is a key feature of the KVM MMU and must be supported by
the TDP MMU. Add support for both the write protection and PML dirty
logging modes.

Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
machine. This series introduced no new failures.

This series can be viewed in Gerrit at:
	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538

Signed-off-by: Ben Gardon <bgardon@google.com>
Message-Id: <20201014182700.2888246-16-bgardon@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c      |  14 ++
 arch/x86/kvm/mmu/tdp_iter.h |   7 +-
 arch/x86/kvm/mmu/tdp_mmu.c  | 299 +++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/mmu/tdp_mmu.h  |  10 ++
 include/linux/kvm_host.h    |   1 +
 virt/kvm/kvm_main.c         |   6 +-
 6 files changed, 328 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 41f0354c7489..0c64643819b9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1223,6 +1223,9 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 {
 	struct kvm_rmap_head *rmap_head;
 
+	if (kvm->arch.tdp_mmu_enabled)
+		kvm_tdp_mmu_clear_dirty_pt_masked(kvm, slot,
+				slot->base_gfn + gfn_offset, mask, true);
 	while (mask) {
 		rmap_head = __gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
 					  PG_LEVEL_4K, slot);
@@ -1249,6 +1252,9 @@ void kvm_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 {
 	struct kvm_rmap_head *rmap_head;
 
+	if (kvm->arch.tdp_mmu_enabled)
+		kvm_tdp_mmu_clear_dirty_pt_masked(kvm, slot,
+				slot->base_gfn + gfn_offset, mask, false);
 	while (mask) {
 		rmap_head = __gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
 					  PG_LEVEL_4K, slot);
@@ -5473,6 +5479,8 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 	spin_lock(&kvm->mmu_lock);
 	flush = slot_handle_level(kvm, memslot, slot_rmap_write_protect,
 				start_level, KVM_MAX_HUGEPAGE_LEVEL, false);
+	if (kvm->arch.tdp_mmu_enabled)
+		flush |= kvm_tdp_mmu_wrprot_slot(kvm, memslot, PG_LEVEL_4K);
 	spin_unlock(&kvm->mmu_lock);
 
 	/*
@@ -5561,6 +5569,8 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 
 	spin_lock(&kvm->mmu_lock);
 	flush = slot_handle_leaf(kvm, memslot, __rmap_clear_dirty, false);
+	if (kvm->arch.tdp_mmu_enabled)
+		flush |= kvm_tdp_mmu_clear_dirty_slot(kvm, memslot);
 	spin_unlock(&kvm->mmu_lock);
 
 	/*
@@ -5582,6 +5592,8 @@ void kvm_mmu_slot_largepage_remove_write_access(struct kvm *kvm,
 	spin_lock(&kvm->mmu_lock);
 	flush = slot_handle_large_level(kvm, memslot, slot_rmap_write_protect,
 					false);
+	if (kvm->arch.tdp_mmu_enabled)
+		flush |= kvm_tdp_mmu_wrprot_slot(kvm, memslot, PG_LEVEL_2M);
 	spin_unlock(&kvm->mmu_lock);
 
 	if (flush)
@@ -5596,6 +5608,8 @@ void kvm_mmu_slot_set_dirty(struct kvm *kvm,
 
 	spin_lock(&kvm->mmu_lock);
 	flush = slot_handle_all_level(kvm, memslot, __rmap_set_dirty, false);
+	if (kvm->arch.tdp_mmu_enabled)
+		flush |= kvm_tdp_mmu_slot_set_dirty(kvm, memslot);
 	spin_unlock(&kvm->mmu_lock);
 
 	if (flush)
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index 884ed2c70bfe..47170d0dc98e 100644
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
index 64e640cfcff9..7181b4ab54d0 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -161,6 +161,24 @@ static void handle_changed_spte_acc_track(u64 old_spte, u64 new_spte, int level)
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
@@ -273,10 +291,13 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
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
@@ -289,19 +310,30 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
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
@@ -334,6 +366,14 @@ static bool tdp_mmu_iter_flush_cond_resched(struct kvm *kvm, struct tdp_iter *it
 	}
 }
 
+static void tdp_mmu_iter_cond_resched(struct kvm *kvm, struct tdp_iter *iter)
+{
+	if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
+		cond_resched_lock(&kvm->mmu_lock);
+		tdp_iter_refresh_walk(iter);
+	}
+}
+
 /*
  * Tears down the mappings for the range of gfns, [start, end), and frees the
  * non-root pages mapping GFNs strictly within that range. Returns true if
@@ -638,6 +678,7 @@ static int age_gfn_range(struct kvm *kvm, struct kvm_memory_slot *slot,
 
 			new_spte = mark_spte_for_access_track(new_spte);
 		}
+		new_spte &= ~shadow_dirty_mask;
 
 		tdp_mmu_set_spte_no_acc_track(kvm, &iter, new_spte);
 		young = 1;
@@ -727,3 +768,255 @@ int kvm_tdp_mmu_set_spte_hva(struct kvm *kvm, unsigned long address,
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
+		kvm_mmu_get_root(kvm, root);
+
+		spte_set |= wrprot_gfn_range(kvm, root, slot->base_gfn,
+			     slot->base_gfn + slot->npages, min_level);
+
+		kvm_mmu_put_root(kvm, root);
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
+		kvm_mmu_get_root(kvm, root);
+
+		spte_set |= clear_dirty_gfn_range(kvm, root, slot->base_gfn,
+				slot->base_gfn + slot->npages);
+
+		kvm_mmu_put_root(kvm, root);
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
+		kvm_mmu_get_root(kvm, root);
+
+		spte_set |= set_dirty_gfn_range(kvm, root, slot->base_gfn,
+				slot->base_gfn + slot->npages);
+
+		kvm_mmu_put_root(kvm, root);
+	}
+	return spte_set;
+}
+
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index aeee3ce7b3f4..ece66f10d85f 100644
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
index c6f45687ba89..7f2e2a09ebbd 100644
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
index 2e8539213125..2541a17ff1c4 100644
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
2.26.2


