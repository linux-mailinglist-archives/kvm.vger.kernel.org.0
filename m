Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD7CABFBDD
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 01:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729052AbfIZXTY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 19:19:24 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:36834 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728923AbfIZXTY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 19:19:24 -0400
Received: by mail-pf1-f201.google.com with SMTP id 194so510486pfu.3
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 16:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=8HD0TRmSoGCa91TLgT7Wl5W5ZqHPYC6XlL7tI1HTTBk=;
        b=pKnvT6Hg6lFBsOGhCWWH8YQLnZ7hZd8006IBg53fuek5jytJO8M9pZzBLthK/pXQgb
         FC3i487C9svDvCXo766VGD6NtNWDUKBjQp1fYIpe77yCBzwn4Duw5fc0gVPMNZtCJthG
         2J3IlhFOjizeXDX/Cto4beAb42G6VgQCUaYAmjvg1nJobAgCBFZGF+o7iDl34J0L2a54
         KvCyjTEEShRnCGEMnNLODzKMPUueJhBelQm3t1HKskSykVfJea3e1uF/rlIongwQ2tVr
         xY9icHDH6klF9IeVfsPrg5YMGBa6fuuXxEV8ciF3ehJvepqRhAUXGraV47ajCK7qQEJk
         jSEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=8HD0TRmSoGCa91TLgT7Wl5W5ZqHPYC6XlL7tI1HTTBk=;
        b=rYusKNQ2NkqHjULmTyDXvuK5+ctItX5snR7LWVwRWviZzbZZQvSMugJCz4ZnTLytKh
         TRRaLCZtmsMIfkX2Mj2BrJfitXS2fTSEdSTc//8PG/WxOEktg/rhwIGTpvkUxt98HSPn
         pP3qhgJg+kf8coxhB02HxR9dkUtiwi+NbbtLK/b7WH8PD/jZxiCb5ilvz4FuB3RzRAoE
         TSiGBwMr+m3TpuGwMumZwXd074eI6oCsggAtG1Q7wgjsx/i2zTQ7ZyujanKxtl8fy2fz
         MSdww/o+W19CoySwl75Z0GUdIohI261vNkhUZ72kLclNTrCS1p+/EUHfc+9MAW3XpsDl
         d9fw==
X-Gm-Message-State: APjAAAVtd+AfiemgkhdzCtRPhc4FMe6Y1kb5FaJzjta9h7xO3R6jlKGB
        +aoZHNnA8yE3yQBRXo5GV4NFR7PLOAW+Ox2Op9AleYtS0XgRoSQcJ+CZFksHqF6d0LtElfHuacz
        beZkB1TM85HH/E6lrV+xWu8xvwlhVpchxJFMRAMfGlbLpihK4xO96lL9tFlkz
X-Google-Smtp-Source: APXvYqxumecpzpya7qCvjMzVto+bHggKvYwVfcY8JrtTnDd4T+/S0jxzqXnKcldOGIxfmMrcf+21ABDmL1h8
X-Received: by 2002:a63:741a:: with SMTP id p26mr5923543pgc.177.1569539962803;
 Thu, 26 Sep 2019 16:19:22 -0700 (PDT)
Date:   Thu, 26 Sep 2019 16:18:20 -0700
In-Reply-To: <20190926231824.149014-1-bgardon@google.com>
Message-Id: <20190926231824.149014-25-bgardon@google.com>
Mime-Version: 1.0
References: <20190926231824.149014-1-bgardon@google.com>
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
Subject: [RFC PATCH 24/28] kvm: mmu: Support dirty logging in the direct MMU
From:   Ben Gardon <bgardon@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Adds functions for handling changes to the dirty state of PTEs and
functions for enabling / resetting dirty logging which use a paging
structure iterator.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/include/asm/kvm_host.h |  10 ++
 arch/x86/kvm/mmu.c              | 259 ++++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/vmx.c          |  10 +-
 arch/x86/kvm/x86.c              |   4 +-
 4 files changed, 269 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9bf149dce146d..b6a3380e66d44 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1305,6 +1305,16 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 				      struct kvm_memory_slot *memslot);
 void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 				   const struct kvm_memory_slot *memslot);
+
+#define KVM_DIRTY_LOG_MODE_WRPROT	1
+#define KVM_DIRTY_LOG_MODE_PML		2
+
+void kvm_mmu_zap_collapsible_direct_ptes(struct kvm *kvm,
+					 const struct kvm_memory_slot *memslot);
+void reset_direct_mmu_dirty_logging(struct kvm *kvm,
+				    struct kvm_memory_slot *slot,
+				    int dirty_log_mode,
+				    bool record_dirty_pages);
 void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 				   struct kvm_memory_slot *memslot);
 void kvm_mmu_slot_largepage_remove_write_access(struct kvm *kvm,
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index cc81ba5ee46d6..ca58b27a17c52 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -790,6 +790,18 @@ static bool is_accessed_direct_pte(u64 pte, int level)
 	return pte & shadow_acc_track_mask;
 }
 
+static bool is_dirty_direct_pte(u64 pte, int dlog_mode)
+{
+	/* If the pte is non-present, the entry cannot have been dirtied. */
+	if (!is_present_direct_pte(pte))
+		return false;
+
+	if (dlog_mode == KVM_DIRTY_LOG_MODE_WRPROT)
+		return pte & PT_WRITABLE_MASK;
+
+	return pte & shadow_dirty_mask;
+}
+
 static bool is_accessed_spte(u64 spte)
 {
 	u64 accessed_mask = spte_shadow_accessed_mask(spte);
@@ -1743,6 +1755,38 @@ static void handle_changed_pte_acc_track(u64 old_pte, u64 new_pte, int level)
 		kvm_set_pfn_accessed(spte_to_pfn(old_pte));
 }
 
+static void handle_changed_pte_dlog(struct kvm *kvm, int as_id, gfn_t gfn,
+				    u64 old_pte, u64 new_pte, int level)
+{
+	bool pfn_changed = spte_to_pfn(old_pte) != spte_to_pfn(new_pte);
+	bool was_wrprot_dirty = is_dirty_direct_pte(old_pte,
+						    KVM_DIRTY_LOG_MODE_WRPROT);
+	bool is_wrprot_dirty = is_dirty_direct_pte(new_pte,
+						   KVM_DIRTY_LOG_MODE_WRPROT);
+	bool wrprot_dirty = (!was_wrprot_dirty || pfn_changed) &&
+			    is_wrprot_dirty;
+	struct kvm_memory_slot *slot;
+
+	if (level > PT_PAGE_TABLE_LEVEL)
+		return;
+
+	/*
+	 * Only mark pages dirty if they are becoming writable or no longer have
+	 * the dbit set and dbit dirty logging is enabled.
+	 * If pages are marked dirty when unsetting the dbit when dbit
+	 * dirty logging isn't on, it can cause spurious dirty pages, e.g. from
+	 * zapping PTEs during VM teardown.
+	 * If, on the other hand, pages were only marked dirty when becoming
+	 * writable when in wrprot dirty logging, that would also cause problems
+	 * because dirty pages could be lost when switching from dbit to wrprot
+	 * dirty logging.
+	 */
+	if (wrprot_dirty) {
+		slot = __gfn_to_memslot(__kvm_memslots(kvm, as_id), gfn);
+		mark_page_dirty_in_slot(slot, gfn);
+	}
+}
+
 /*
  * Takes a snapshot of, and clears, the direct MMU disconnected pt list. Once
  * TLBs have been flushed, this snapshot can be transferred to the direct MMU
@@ -1873,6 +1917,8 @@ static void mark_pte_disconnected(struct kvm *kvm, int as_id, gfn_t gfn,
 	handle_changed_pte(kvm, as_id, gfn, old_pte, DISCONNECTED_PTE, level,
 			   vm_teardown, disconnected_pts);
 	handle_changed_pte_acc_track(old_pte, DISCONNECTED_PTE, level);
+	handle_changed_pte_dlog(kvm, as_id, gfn, old_pte, DISCONNECTED_PTE,
+				level);
 }
 
 /**
@@ -1964,6 +2010,14 @@ static void handle_changed_pte(struct kvm *kvm, int as_id, gfn_t gfn,
 	bool was_present = is_present_direct_pte(old_pte);
 	bool is_present = is_present_direct_pte(new_pte);
 	bool was_leaf = was_present && is_last_spte(old_pte, level);
+	bool was_dirty = is_dirty_direct_pte(old_pte,
+				KVM_DIRTY_LOG_MODE_WRPROT) ||
+			 is_dirty_direct_pte(old_pte,
+				KVM_DIRTY_LOG_MODE_PML);
+	bool is_dirty = is_dirty_direct_pte(new_pte,
+				KVM_DIRTY_LOG_MODE_WRPROT) ||
+			 is_dirty_direct_pte(new_pte,
+				KVM_DIRTY_LOG_MODE_PML);
 	bool pfn_changed = spte_to_pfn(old_pte) != spte_to_pfn(new_pte);
 	int child_level;
 
@@ -1990,6 +2044,9 @@ static void handle_changed_pte(struct kvm *kvm, int as_id, gfn_t gfn,
 		return;
 	}
 
+	if (((was_dirty && !is_dirty) || pfn_changed) && was_leaf)
+		kvm_set_pfn_dirty(spte_to_pfn(old_pte));
+
 	if (was_present && !was_leaf && (pfn_changed || !is_present)) {
 		/*
 		 * The level of the page table being freed is one level lower
@@ -2439,7 +2496,8 @@ static bool cmpxchg_pte(u64 *ptep, u64 old_pte, u64 new_pte, int level, u64 gfn)
 }
 
 static bool direct_walk_iterator_set_pte_raw(struct direct_walk_iterator *iter,
-					 u64 new_pte, bool handle_acc_track)
+					     u64 new_pte, bool handle_acc_track,
+					     bool handle_dlog)
 {
 	bool r;
 
@@ -2464,6 +2522,11 @@ static bool direct_walk_iterator_set_pte_raw(struct direct_walk_iterator *iter,
 		if (handle_acc_track)
 			handle_changed_pte_acc_track(iter->old_pte, new_pte,
 						     iter->level);
+		if (handle_dlog)
+			handle_changed_pte_dlog(iter->kvm, iter->as_id,
+						iter->pte_gfn_start,
+						iter->old_pte, new_pte,
+						iter->level);
 
 		if (iter->lock_mode & (MMU_WRITE_LOCK | MMU_READ_LOCK))
 			iter->tlbs_dirty++;
@@ -2476,13 +2539,19 @@ static bool direct_walk_iterator_set_pte_raw(struct direct_walk_iterator *iter,
 static bool direct_walk_iterator_set_pte_no_acc_track(
 		struct direct_walk_iterator *iter, u64 new_pte)
 {
-	return direct_walk_iterator_set_pte_raw(iter, new_pte, false);
+	return direct_walk_iterator_set_pte_raw(iter, new_pte, false, true);
+}
+
+static bool direct_walk_iterator_set_pte_no_dlog(
+		struct direct_walk_iterator *iter, u64 new_pte)
+{
+	return direct_walk_iterator_set_pte_raw(iter, new_pte, true, false);
 }
 
 static bool direct_walk_iterator_set_pte(struct direct_walk_iterator *iter,
 					 u64 new_pte)
 {
-	return direct_walk_iterator_set_pte_raw(iter, new_pte, true);
+	return direct_walk_iterator_set_pte_raw(iter, new_pte, true, true);
 }
 
 static u64 generate_nonleaf_pte(u64 *child_pt, bool ad_disabled)
@@ -2500,6 +2569,83 @@ static u64 generate_nonleaf_pte(u64 *child_pt, bool ad_disabled)
 	return pte;
 }
 
+static u64 mark_direct_pte_for_dirty_track(u64 pte, int dlog_mode)
+{
+	if (dlog_mode == KVM_DIRTY_LOG_MODE_WRPROT)
+		pte &= ~PT_WRITABLE_MASK;
+	else
+		pte &= ~shadow_dirty_mask;
+
+	return pte;
+}
+
+void reset_direct_mmu_dirty_logging(struct kvm *kvm,
+				    struct kvm_memory_slot *slot,
+				    int dirty_log_mode, bool record_dirty_pages)
+{
+	struct direct_walk_iterator iter;
+	u64 new_pte;
+	bool pte_set;
+
+	write_lock(&kvm->mmu_lock);
+
+	direct_walk_iterator_setup_walk(&iter, kvm, slot->as_id, slot->base_gfn,
+			slot->base_gfn + slot->npages,
+			MMU_WRITE_LOCK);
+	while (direct_walk_iterator_next_present_leaf_pte(&iter)) {
+		if (iter.level == PT_PAGE_TABLE_LEVEL &&
+		    !is_dirty_direct_pte(iter.old_pte, dirty_log_mode))
+			continue;
+
+		new_pte = mark_direct_pte_for_dirty_track(iter.old_pte,
+							  dirty_log_mode);
+
+		if (record_dirty_pages)
+			pte_set = direct_walk_iterator_set_pte(&iter, new_pte);
+		else
+			pte_set = direct_walk_iterator_set_pte_no_dlog(&iter,
+								       new_pte);
+		if (!pte_set)
+			continue;
+	}
+	if (direct_walk_iterator_end_traversal(&iter))
+		kvm_flush_remote_tlbs(kvm);
+	write_unlock(&kvm->mmu_lock);
+}
+EXPORT_SYMBOL_GPL(reset_direct_mmu_dirty_logging);
+
+static bool clear_direct_dirty_log_gfn_masked(struct kvm *kvm,
+		struct kvm_memory_slot *slot, gfn_t gfn, unsigned long mask,
+		int dirty_log_mode, enum mmu_lock_mode lock_mode)
+{
+	struct direct_walk_iterator iter;
+	u64 new_pte;
+
+	direct_walk_iterator_setup_walk(&iter, kvm, slot->as_id,
+			gfn + __ffs(mask), gfn + BITS_PER_LONG, lock_mode);
+	while (mask && direct_walk_iterator_next_present_leaf_pte(&iter)) {
+		if (iter.level > PT_PAGE_TABLE_LEVEL) {
+			BUG_ON(iter.old_pte & PT_WRITABLE_MASK);
+			continue;
+		}
+
+		if (!is_dirty_direct_pte(iter.old_pte, dirty_log_mode))
+			continue;
+
+		if (!(mask & (1UL << (iter.pte_gfn_start - gfn))))
+			continue;
+
+		new_pte = mark_direct_pte_for_dirty_track(iter.old_pte,
+							  dirty_log_mode);
+
+		if (!direct_walk_iterator_set_pte_no_dlog(&iter, new_pte))
+			continue;
+
+		mask &= ~(1UL << (iter.pte_gfn_start - gfn));
+	}
+	return direct_walk_iterator_end_traversal(&iter);
+}
+
 /**
  * kvm_mmu_write_protect_pt_masked - write protect selected PT level pages
  * @kvm: kvm instance
@@ -2509,12 +2655,24 @@ static u64 generate_nonleaf_pte(u64 *child_pt, bool ad_disabled)
  *
  * Used when we do not need to care about huge page mappings: e.g. during dirty
  * logging we do not have any such mappings.
+ *
+ * We don't need to worry about flushing tlbs here as they are flushed
+ * unconditionally at a higher level. See the comments on
+ * kvm_vm_ioctl_get_dirty_log and kvm_mmu_slot_remove_write_access.
  */
 static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 				     struct kvm_memory_slot *slot,
 				     gfn_t gfn_offset, unsigned long mask)
 {
 	struct kvm_rmap_head *rmap_head;
+	gfn_t gfn = slot->base_gfn + gfn_offset;
+
+	if (kvm->arch.direct_mmu_enabled)
+		clear_direct_dirty_log_gfn_masked(kvm, slot, gfn, mask,
+						  KVM_DIRTY_LOG_MODE_WRPROT,
+						  MMU_WRITE_LOCK);
+	if (kvm->arch.pure_direct_mmu)
+		return;
 
 	while (mask) {
 		rmap_head = __gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
@@ -2541,6 +2699,16 @@ void kvm_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 				     gfn_t gfn_offset, unsigned long mask)
 {
 	struct kvm_rmap_head *rmap_head;
+	gfn_t gfn = slot->base_gfn + gfn_offset;
+
+	if (!mask)
+		return;
+
+	if (kvm->arch.direct_mmu_enabled)
+		clear_direct_dirty_log_gfn_masked(kvm, slot, gfn, mask,
+				KVM_DIRTY_LOG_MODE_PML, MMU_WRITE_LOCK);
+	if (kvm->arch.pure_direct_mmu)
+		return;
 
 	while (mask) {
 		rmap_head = __gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
@@ -3031,6 +3199,7 @@ static int age_direct_gfn_range(struct kvm *kvm, struct kvm_memory_slot *slot,
 					iter.old_pte);
 			new_pte |= shadow_acc_track_value;
 		}
+		new_pte &= ~shadow_dirty_mask;
 
 		/*
 		 * We've created a new pte with the accessed state cleared.
@@ -7293,11 +7462,17 @@ static bool slot_rmap_write_protect(struct kvm *kvm,
 void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 				      struct kvm_memory_slot *memslot)
 {
-	bool flush;
+	bool flush = false;
+
+	if (kvm->arch.direct_mmu_enabled)
+		reset_direct_mmu_dirty_logging(kvm, memslot,
+				KVM_DIRTY_LOG_MODE_WRPROT, false);
 
 	write_lock(&kvm->mmu_lock);
-	flush = slot_handle_all_level(kvm, memslot, slot_rmap_write_protect,
-				      false);
+	if (!kvm->arch.pure_direct_mmu)
+		flush = slot_handle_all_level(kvm, memslot,
+					      slot_rmap_write_protect,
+					      false);
 	write_unlock(&kvm->mmu_lock);
 
 	/*
@@ -7367,8 +7542,42 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 {
 	/* FIXME: const-ify all uses of struct kvm_memory_slot.  */
 	write_lock(&kvm->mmu_lock);
-	slot_handle_leaf(kvm, (struct kvm_memory_slot *)memslot,
-			 kvm_mmu_zap_collapsible_spte, true);
+	if (!kvm->arch.pure_direct_mmu)
+		slot_handle_leaf(kvm, (struct kvm_memory_slot *)memslot,
+				 kvm_mmu_zap_collapsible_spte, true);
+	write_unlock(&kvm->mmu_lock);
+}
+
+void kvm_mmu_zap_collapsible_direct_ptes(struct kvm *kvm,
+					 const struct kvm_memory_slot *memslot)
+{
+	struct direct_walk_iterator iter;
+	kvm_pfn_t pfn;
+
+	if (!kvm->arch.direct_mmu_enabled)
+		return;
+
+	write_lock(&kvm->mmu_lock);
+
+	direct_walk_iterator_setup_walk(&iter, kvm, memslot->as_id,
+					memslot->base_gfn,
+					memslot->base_gfn + memslot->npages,
+					MMU_READ_LOCK | MMU_LOCK_MAY_RESCHED);
+	while (direct_walk_iterator_next_present_leaf_pte(&iter)) {
+		pfn = spte_to_pfn(iter.old_pte);
+		if (kvm_is_reserved_pfn(pfn) ||
+		    !PageTransCompoundMap(pfn_to_page(pfn)))
+			continue;
+		/*
+		 * If the compare / exchange succeeds, then we will continue on
+		 * to the next pte. If it fails, the next iteration will repeat
+		 * the current pte. We'll handle both cases in the same way, so
+		 * we don't need to check the result here.
+		 */
+		direct_walk_iterator_set_pte(&iter, 0);
+	}
+	direct_walk_iterator_end_traversal(&iter);
+
 	write_unlock(&kvm->mmu_lock);
 }
 
@@ -7414,18 +7623,46 @@ void kvm_mmu_slot_largepage_remove_write_access(struct kvm *kvm,
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_slot_largepage_remove_write_access);
 
+static bool slot_set_dirty_direct(struct kvm *kvm,
+			    struct kvm_memory_slot *memslot)
+{
+	struct direct_walk_iterator iter;
+	u64 new_pte;
+
+	direct_walk_iterator_setup_walk(&iter, kvm, memslot->as_id,
+			memslot->base_gfn, memslot->base_gfn + memslot->npages,
+			MMU_WRITE_LOCK | MMU_LOCK_MAY_RESCHED);
+	while (direct_walk_iterator_next_present_pte(&iter)) {
+		new_pte = iter.old_pte | shadow_dirty_mask;
+
+		if (!direct_walk_iterator_set_pte(&iter, new_pte))
+			continue;
+	}
+	return direct_walk_iterator_end_traversal(&iter);
+}
+
 void kvm_mmu_slot_set_dirty(struct kvm *kvm,
 			    struct kvm_memory_slot *memslot)
 {
-	bool flush;
+	bool flush = false;
 
 	write_lock(&kvm->mmu_lock);
-	flush = slot_handle_all_level(kvm, memslot, __rmap_set_dirty, false);
+	if (kvm->arch.direct_mmu_enabled)
+		flush |= slot_set_dirty_direct(kvm, memslot);
+
+	if (!kvm->arch.pure_direct_mmu)
+		flush |= slot_handle_all_level(kvm, memslot, __rmap_set_dirty,
+					       false);
 	write_unlock(&kvm->mmu_lock);
 
 	lockdep_assert_held(&kvm->slots_lock);
 
-	/* see kvm_mmu_slot_leaf_clear_dirty */
+	/*
+	 * It's also safe to flush TLBs out of mmu lock here as currently this
+	 * function is only used for dirty logging, in which case flushing TLB
+	 * out of mmu lock also guarantees no dirty pages will be lost in
+	 * dirty_bitmap.
+	 */
 	if (flush)
 		kvm_flush_remote_tlbs_with_address(kvm, memslot->base_gfn,
 				memslot->npages);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d4575ffb3cec7..aab8f3ab456ec 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7221,8 +7221,14 @@ static void vmx_sched_in(struct kvm_vcpu *vcpu, int cpu)
 static void vmx_slot_enable_log_dirty(struct kvm *kvm,
 				     struct kvm_memory_slot *slot)
 {
-	kvm_mmu_slot_leaf_clear_dirty(kvm, slot);
-	kvm_mmu_slot_largepage_remove_write_access(kvm, slot);
+	if (kvm->arch.direct_mmu_enabled)
+		reset_direct_mmu_dirty_logging(kvm, slot,
+					       KVM_DIRTY_LOG_MODE_PML, false);
+
+	if (!kvm->arch.pure_direct_mmu) {
+		kvm_mmu_slot_leaf_clear_dirty(kvm, slot);
+		kvm_mmu_slot_largepage_remove_write_access(kvm, slot);
+	}
 }
 
 static void vmx_slot_disable_log_dirty(struct kvm *kvm,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2972b6c6029fb..edd7d7bece2fe 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9776,8 +9776,10 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 	 */
 	if (change == KVM_MR_FLAGS_ONLY &&
 		(old->flags & KVM_MEM_LOG_DIRTY_PAGES) &&
-		!(new->flags & KVM_MEM_LOG_DIRTY_PAGES))
+		!(new->flags & KVM_MEM_LOG_DIRTY_PAGES)) {
 		kvm_mmu_zap_collapsible_sptes(kvm, new);
+		kvm_mmu_zap_collapsible_direct_ptes(kvm, new);
+	}
 
 	/*
 	 * Set up write protection and/or dirty logging for the new slot.
-- 
2.23.0.444.g18eeb5a265-goog

