Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCAAE27934D
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 23:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728983AbgIYVYX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 17:24:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729268AbgIYVXj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Sep 2020 17:23:39 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7D29C0613D7
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 14:23:39 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id c3so3297577pgj.5
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 14:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=++T5s3YUay3rT5B+q2dH+DuGWd7bTsv0ett1YKhKSfo=;
        b=P8zn92rxX46Uh7YPJ9dvtX8aZ/bn5kQC0uN5VafSE/U4zgBDmTglpK36HInd8FIPSL
         jbFD35EAO/P+CUhsyxRkn2SNHcyYwilbEuKzJmtFLyjCVif2y1iE0TlC3xZRgV/Y8dS6
         lK54XvJ2kWYSMTwPvCfS5jHysPNbD2xxaRj7Uzuc7izRCVqvaCLCQPyb7/wB6RqqGSbu
         SgBxo1NwPZnd021EJcUu1b61T79Prv4Naa3ewQ7ntygpbAtSoQ/c/BZlFuTpi9YvUP1w
         RW1jH3p7KwXVcrz0tTrguF3amRTXV+T3NOooFeJ4PhSrBLA0wbaZhM6l4hfZIx19z0O5
         7JHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=++T5s3YUay3rT5B+q2dH+DuGWd7bTsv0ett1YKhKSfo=;
        b=JXp5R3bZvLyRJseGU9s2Y75hh/UvFTxZuQYesSJ/P10S7z8uZ+hmdP1/XrUaslmuMa
         r2JWjffv0pKkfkVNvPV/UWiSsk3ZeEUiPc68e2IYurblYBEzf3ViUpUVOXmZRlqc5Oc3
         YWVyJQWWrNwsuPRyX/shKLt9b+wJ4xpPh+SlEiE4UljljL1n4q95HG0FV0QD+qMxC5bZ
         CXXXXry3OnsY4w4/TX8duzCYf7y4COhdfRU2tpIBa49hcmHbO5uQBaPMbj1rBofznMJK
         C1cnDz/yAnqQKXtUGCfigIQlUnox8tLIxKgxGrYa0wXPcnp8QVqVm0cS9g/oC1eHYPJ5
         rpwg==
X-Gm-Message-State: AOAM531zjwO09nNpbykxX5VJUQ3+3V83dDoNP5I1Nhs7/lZSq0R8p+g3
        G8AhQ+OBcuk2M06qEWVoCsAPesyycuIc
X-Google-Smtp-Source: ABdhPJx2ipmX5d0mSlnu2hDv6zA5hEE8DlZs0VHesABKTm87rPEAHVRB+/erIsPyvFo4Es+t6yjRJSb0wh69
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a17:90a:ea0c:: with SMTP id
 w12mr431434pjy.65.1601069019270; Fri, 25 Sep 2020 14:23:39 -0700 (PDT)
Date:   Fri, 25 Sep 2020 14:22:57 -0700
In-Reply-To: <20200925212302.3979661-1-bgardon@google.com>
Message-Id: <20200925212302.3979661-18-bgardon@google.com>
Mime-Version: 1.0
References: <20200925212302.3979661-1-bgardon@google.com>
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH 17/22] kvm: mmu: Support dirty logging for the TDP MMU
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
 arch/x86/kvm/mmu/mmu.c          |  19 +-
 arch/x86/kvm/mmu/mmu_internal.h |   2 +
 arch/x86/kvm/mmu/tdp_iter.c     |  18 ++
 arch/x86/kvm/mmu/tdp_iter.h     |   1 +
 arch/x86/kvm/mmu/tdp_mmu.c      | 295 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.h      |  10 ++
 6 files changed, 343 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0d80abe82ca93..b9074603f9df1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -201,7 +201,7 @@ static u64 __read_mostly shadow_nx_mask;
 static u64 __read_mostly shadow_x_mask;	/* mutual exclusive with nx_mask */
 u64 __read_mostly shadow_user_mask;
 u64 __read_mostly shadow_accessed_mask;
-static u64 __read_mostly shadow_dirty_mask;
+u64 __read_mostly shadow_dirty_mask;
 static u64 __read_mostly shadow_mmio_value;
 static u64 __read_mostly shadow_mmio_access_mask;
 u64 __read_mostly shadow_present_mask;
@@ -324,7 +324,7 @@ inline bool spte_ad_enabled(u64 spte)
 	return (spte & SPTE_SPECIAL_MASK) != SPTE_AD_DISABLED_MASK;
 }
 
-static inline bool spte_ad_need_write_protect(u64 spte)
+inline bool spte_ad_need_write_protect(u64 spte)
 {
 	MMU_WARN_ON(is_mmio_spte(spte));
 	return (spte & SPTE_SPECIAL_MASK) != SPTE_AD_ENABLED_MASK;
@@ -1591,6 +1591,9 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 {
 	struct kvm_rmap_head *rmap_head;
 
+	if (kvm->arch.tdp_mmu_enabled)
+		kvm_tdp_mmu_clear_dirty_pt_masked(kvm, slot,
+				slot->base_gfn + gfn_offset, mask, true);
 	while (mask) {
 		rmap_head = __gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
 					  PG_LEVEL_4K, slot);
@@ -1617,6 +1620,9 @@ void kvm_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 {
 	struct kvm_rmap_head *rmap_head;
 
+	if (kvm->arch.tdp_mmu_enabled)
+		kvm_tdp_mmu_clear_dirty_pt_masked(kvm, slot,
+				slot->base_gfn + gfn_offset, mask, false);
 	while (mask) {
 		rmap_head = __gfn_to_rmap(slot->base_gfn + gfn_offset + __ffs(mask),
 					  PG_LEVEL_4K, slot);
@@ -5954,6 +5960,8 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 	spin_lock(&kvm->mmu_lock);
 	flush = slot_handle_level(kvm, memslot, slot_rmap_write_protect,
 				start_level, KVM_MAX_HUGEPAGE_LEVEL, false);
+	if (kvm->arch.tdp_mmu_enabled)
+		flush = kvm_tdp_mmu_wrprot_slot(kvm, memslot, false) || flush;
 	spin_unlock(&kvm->mmu_lock);
 
 	/*
@@ -6034,6 +6042,7 @@ void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
 	kvm_flush_remote_tlbs_with_address(kvm, memslot->base_gfn,
 					   memslot->npages);
 }
+EXPORT_SYMBOL_GPL(kvm_arch_flush_remote_tlbs_memslot);
 
 void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 				   struct kvm_memory_slot *memslot)
@@ -6042,6 +6051,8 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 
 	spin_lock(&kvm->mmu_lock);
 	flush = slot_handle_leaf(kvm, memslot, __rmap_clear_dirty, false);
+	if (kvm->arch.tdp_mmu_enabled)
+		flush = kvm_tdp_mmu_clear_dirty_slot(kvm, memslot) || flush;
 	spin_unlock(&kvm->mmu_lock);
 
 	/*
@@ -6063,6 +6074,8 @@ void kvm_mmu_slot_largepage_remove_write_access(struct kvm *kvm,
 	spin_lock(&kvm->mmu_lock);
 	flush = slot_handle_large_level(kvm, memslot, slot_rmap_write_protect,
 					false);
+	if (kvm->arch.tdp_mmu_enabled)
+		flush = kvm_tdp_mmu_wrprot_slot(kvm, memslot, true) || flush;
 	spin_unlock(&kvm->mmu_lock);
 
 	if (flush)
@@ -6077,6 +6090,8 @@ void kvm_mmu_slot_set_dirty(struct kvm *kvm,
 
 	spin_lock(&kvm->mmu_lock);
 	flush = slot_handle_all_level(kvm, memslot, __rmap_set_dirty, false);
+	if (kvm->arch.tdp_mmu_enabled)
+		flush = kvm_tdp_mmu_slot_set_dirty(kvm, memslot) || flush;
 	spin_unlock(&kvm->mmu_lock);
 
 	if (flush)
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 8eaa6e4764bce..1a777ccfde44e 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -89,6 +89,7 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 extern u64 shadow_user_mask;
 extern u64 shadow_accessed_mask;
 extern u64 shadow_present_mask;
+extern u64 shadow_dirty_mask;
 
 #define ACC_EXEC_MASK    1
 #define ACC_WRITE_MASK   PT_WRITABLE_MASK
@@ -112,6 +113,7 @@ bool is_access_track_spte(u64 spte);
 bool is_accessed_spte(u64 spte);
 bool spte_ad_enabled(u64 spte);
 bool is_executable_pte(u64 spte);
+bool spte_ad_need_write_protect(u64 spte);
 
 void kvm_flush_remote_tlbs_with_address(struct kvm *kvm, u64 start_gfn,
 					u64 pages);
diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
index 6c1a38429c81a..132e286150856 100644
--- a/arch/x86/kvm/mmu/tdp_iter.c
+++ b/arch/x86/kvm/mmu/tdp_iter.c
@@ -178,3 +178,21 @@ void tdp_iter_refresh_walk(struct tdp_iter *iter)
 	tdp_iter_start(iter, iter->pt_path[iter->root_level - 1],
 		       iter->root_level, goal_gfn);
 }
+
+/*
+ * Move on to the next SPTE, but do not move down into a child page table even
+ * if the current SPTE leads to one.
+ */
+void tdp_iter_next_no_step_down(struct tdp_iter *iter)
+{
+	bool done;
+
+	done = try_step_side(iter);
+	while (!done) {
+		if (!try_step_up(iter)) {
+			iter->valid = false;
+			break;
+		}
+		done = try_step_side(iter);
+	}
+}
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index 34da3bdada436..d0e65a62ea7d9 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -50,5 +50,6 @@ void tdp_iter_start(struct tdp_iter *iter, u64 *root_pt, int root_level,
 		    gfn_t goal_gfn);
 void tdp_iter_next(struct tdp_iter *iter);
 void tdp_iter_refresh_walk(struct tdp_iter *iter);
+void tdp_iter_next_no_step_down(struct tdp_iter *iter);
 
 #endif /* __KVM_X86_MMU_TDP_ITER_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index bbe973d3f8084..e5cb7f0ec23e8 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -700,6 +700,7 @@ static int age_gfn_range(struct kvm *kvm, struct kvm_memory_slot *slot,
 
 			new_spte = mark_spte_for_access_track(new_spte);
 		}
+		new_spte &= ~shadow_dirty_mask;
 
 		*iter.sptep = new_spte;
 		__handle_changed_spte(kvm, as_id, iter.gfn, iter.old_spte,
@@ -804,3 +805,297 @@ int kvm_tdp_mmu_set_spte_hva(struct kvm *kvm, unsigned long address,
 					    set_tdp_spte);
 }
 
+/*
+ * Remove write access from all the SPTEs mapping GFNs [start, end). If
+ * skip_4k is set, SPTEs that map 4k pages, will not be write-protected.
+ * Returns true if an SPTE has been changed and the TLBs need to be flushed.
+ */
+static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
+			     gfn_t start, gfn_t end, bool skip_4k)
+{
+	struct tdp_iter iter;
+	u64 new_spte;
+	bool spte_set = false;
+	int as_id = kvm_mmu_page_as_id(root);
+
+	for_each_tdp_pte_root(iter, root, start, end) {
+iteration_start:
+		if (!is_shadow_present_pte(iter.old_spte))
+			continue;
+
+		/*
+		 * If this entry points to a page of 4K entries, and 4k entries
+		 * should be skipped, skip the whole page. If the non-leaf
+		 * entry is at a higher level, move on to the next,
+		 * (lower level) entry.
+		 */
+		if (!is_last_spte(iter.old_spte, iter.level)) {
+			if (skip_4k && iter.level == PG_LEVEL_2M) {
+				tdp_iter_next_no_step_down(&iter);
+				if (iter.valid && iter.gfn >= end)
+					goto iteration_start;
+				else
+					break;
+			} else {
+				continue;
+			}
+		}
+
+		WARN_ON(skip_4k && iter.level == PG_LEVEL_4K);
+
+		new_spte = iter.old_spte & ~PT_WRITABLE_MASK;
+
+		*iter.sptep = new_spte;
+		__handle_changed_spte(kvm, as_id, iter.gfn, iter.old_spte,
+				      new_spte, iter.level);
+		handle_changed_spte_acc_track(iter.old_spte, new_spte,
+					      iter.level);
+		spte_set = true;
+
+		tdp_mmu_iter_cond_resched(kvm, &iter);
+	}
+	return spte_set;
+}
+
+/*
+ * Remove write access from all the SPTEs mapping GFNs in the memslot. If
+ * skip_4k is set, SPTEs that map 4k pages, will not be write-protected.
+ * Returns true if an SPTE has been changed and the TLBs need to be flushed.
+ */
+bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm, struct kvm_memory_slot *slot,
+			     bool skip_4k)
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
+				slot->base_gfn + slot->npages, skip_4k) ||
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
+	int as_id = kvm_mmu_page_as_id(root);
+
+	for_each_tdp_pte_root(iter, root, start, end) {
+		if (!is_shadow_present_pte(iter.old_spte) ||
+		    !is_last_spte(iter.old_spte, iter.level))
+			continue;
+
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
+		*iter.sptep = new_spte;
+		__handle_changed_spte(kvm, as_id, iter.gfn, iter.old_spte,
+				      new_spte, iter.level);
+		handle_changed_spte_acc_track(iter.old_spte, new_spte,
+					      iter.level);
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
+	int as_id = kvm_mmu_page_as_id(root);
+
+	for_each_tdp_pte_root(iter, root, gfn + __ffs(mask),
+			      gfn + BITS_PER_LONG) {
+		if (!mask)
+			break;
+
+		if (!is_shadow_present_pte(iter.old_spte) ||
+		    !is_last_spte(iter.old_spte, iter.level) ||
+		    iter.level > PG_LEVEL_4K ||
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
+		*iter.sptep = new_spte;
+		__handle_changed_spte(kvm, as_id, iter.gfn, iter.old_spte,
+				      new_spte, iter.level);
+		handle_changed_spte_acc_track(iter.old_spte, new_spte,
+					      iter.level);
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
+	int as_id = kvm_mmu_page_as_id(root);
+
+	for_each_tdp_pte_root(iter, root, start, end) {
+		if (!is_shadow_present_pte(iter.old_spte))
+			continue;
+
+		new_spte = iter.old_spte | shadow_dirty_mask;
+
+		*iter.sptep = new_spte;
+		handle_changed_spte(kvm, as_id, iter.gfn, iter.old_spte,
+				    new_spte, iter.level);
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
index 5a399aa60b8d8..2c9322ba3462b 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -28,4 +28,14 @@ int kvm_tdp_mmu_test_age_hva(struct kvm *kvm, unsigned long hva);
 
 int kvm_tdp_mmu_set_spte_hva(struct kvm *kvm, unsigned long address,
 			     pte_t *host_ptep);
+
+bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm, struct kvm_memory_slot *slot,
+			     bool skip_4k);
+bool kvm_tdp_mmu_clear_dirty_slot(struct kvm *kvm,
+				  struct kvm_memory_slot *slot);
+void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
+				       struct kvm_memory_slot *slot,
+				       gfn_t gfn, unsigned long mask,
+				       bool wrprot);
+bool kvm_tdp_mmu_slot_set_dirty(struct kvm *kvm, struct kvm_memory_slot *slot);
 #endif /* __KVM_X86_MMU_TDP_MMU_H */
-- 
2.28.0.709.gb0816b6eb0-goog

