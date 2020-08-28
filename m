Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76199255615
	for <lists+kvm@lfdr.de>; Fri, 28 Aug 2020 10:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728647AbgH1IMW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Aug 2020 04:12:22 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:34970 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728581AbgH1IMQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Aug 2020 04:12:16 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 99B9BB2BF2C7879FE501;
        Fri, 28 Aug 2020 16:12:13 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.187.22) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Fri, 28 Aug 2020 16:12:06 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <x86@kernel.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <wanghaibin.wang@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>,
        "Sean Christopherson" <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: [RFC PATCH] KVM: x86: Support write protect huge pages lazily
Date:   Fri, 28 Aug 2020 16:11:57 +0800
Message-ID: <20200828081157.15748-1-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.22]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently during enable dirty logging, if we're with init-all-set,
we just write protect huge pages and leave normal pages untouched,
for that we can enable dirty logging for these pages lazily.

It seems that enable dirty logging lazily for huge pages is feasible
too, which not only reduces the time of start dirty logging, also
greatly reduces side-effect on guest when there is high dirty rate.

(These codes are not tested, for RFC purpose :-) ).

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +-
 arch/x86/kvm/mmu/mmu.c          | 65 ++++++++++++++++++++++++++-------
 arch/x86/kvm/vmx/vmx.c          |  3 +-
 arch/x86/kvm/x86.c              | 22 +++++------
 4 files changed, 62 insertions(+), 31 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5303dbc5c9bc..201a068cf43d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1296,8 +1296,7 @@ void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
 
 void kvm_mmu_reset_context(struct kvm_vcpu *vcpu);
 void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
-				      struct kvm_memory_slot *memslot,
-				      int start_level);
+				      struct kvm_memory_slot *memslot);
 void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 				   const struct kvm_memory_slot *memslot);
 void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 43fdb0c12a5d..4b7d577de6cd 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1625,14 +1625,45 @@ static bool __rmap_set_dirty(struct kvm *kvm, struct kvm_rmap_head *rmap_head)
 }
 
 /**
- * kvm_mmu_write_protect_pt_masked - write protect selected PT level pages
+ * kvm_mmu_write_protect_largepage_masked - write protect selected largepages
  * @kvm: kvm instance
  * @slot: slot to protect
  * @gfn_offset: start of the BITS_PER_LONG pages we care about
  * @mask: indicates which pages we should protect
  *
- * Used when we do not need to care about huge page mappings: e.g. during dirty
- * logging we do not have any such mappings.
+ * @ret: true if all pages are write protected
+ */
+static bool kvm_mmu_write_protect_largepage_masked(struct kvm *kvm,
+				    struct kvm_memory_slot *slot,
+				    gfn_t gfn_offset, unsigned long mask)
+{
+	struct kvm_rmap_head *rmap_head;
+	bool protected, all_protected;
+	gfn_t start_gfn = slot->base_gfn + gfn_offset;
+	int i;
+
+	all_protected = true;
+	while (mask) {
+		protected = false;
+		for (i = PG_LEVEL_2M; i <= KVM_MAX_HUGEPAGE_LEVEL; ++i) {
+			rmap_head = __gfn_to_rmap(start_gfn + __ffs(mask), i, slot);
+			protectd |= __rmap_write_protect(kvm, rmap_head, false);
+		}
+
+		all_protected &= protectd;
+		/* clear the first set bit */
+		mask &= mask - 1;
+	}
+
+	return all_protected;
+}
+
+/**
+ * kvm_mmu_write_protect_pt_masked - write protect selected PT level pages
+ * @kvm: kvm instance
+ * @slot: slot to protect
+ * @gfn_offset: start of the BITS_PER_LONG pages we care about
+ * @mask: indicates which pages we should protect
  */
 static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 				     struct kvm_memory_slot *slot,
@@ -1679,18 +1710,25 @@ EXPORT_SYMBOL_GPL(kvm_mmu_clear_dirty_pt_masked);
 
 /**
  * kvm_arch_mmu_enable_log_dirty_pt_masked - enable dirty logging for selected
- * PT level pages.
- *
- * It calls kvm_mmu_write_protect_pt_masked to write protect selected pages to
- * enable dirty logging for them.
- *
- * Used when we do not need to care about huge page mappings: e.g. during dirty
- * logging we do not have any such mappings.
+ * dirty pages.
  */
 void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 				struct kvm_memory_slot *slot,
 				gfn_t gfn_offset, unsigned long mask)
 {
+	/*
+	 * If we're with initial-all-set, huge pages are NOT
+	 * write protected when we start dirty log, so we must
+	 * write protect them here.
+	 */
+	if (kvm_dirty_log_manual_protect_and_init_set(kvm)) {
+		if (kvm_mmu_write_protect_largepage_masked(kvm, slot,
+					gfn_offset, mask))
+			return;
+	}
+
+	/* Then we can handle the 4K level pages */
+
 	if (kvm_x86_ops.enable_log_dirty_pt_masked)
 		kvm_x86_ops.enable_log_dirty_pt_masked(kvm, slot, gfn_offset,
 				mask);
@@ -5906,14 +5944,13 @@ static bool slot_rmap_write_protect(struct kvm *kvm,
 }
 
 void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
-				      struct kvm_memory_slot *memslot,
-				      int start_level)
+				      struct kvm_memory_slot *memslot)
 {
 	bool flush;
 
 	spin_lock(&kvm->mmu_lock);
-	flush = slot_handle_level(kvm, memslot, slot_rmap_write_protect,
-				start_level, KVM_MAX_HUGEPAGE_LEVEL, false);
+	flush = slot_handle_all_level(kvm, memslot, slot_rmap_write_protect,
+				      false);
 	spin_unlock(&kvm->mmu_lock);
 
 	/*
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 819c185adf09..ba871c52ef8b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7538,8 +7538,7 @@ static void vmx_sched_in(struct kvm_vcpu *vcpu, int cpu)
 static void vmx_slot_enable_log_dirty(struct kvm *kvm,
 				     struct kvm_memory_slot *slot)
 {
-	if (!kvm_dirty_log_manual_protect_and_init_set(kvm))
-		kvm_mmu_slot_leaf_clear_dirty(kvm, slot);
+	kvm_mmu_slot_leaf_clear_dirty(kvm, slot);
 	kvm_mmu_slot_largepage_remove_write_access(kvm, slot);
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d39d6cf1d473..c31c32f1424b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10225,22 +10225,18 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 	 * is enabled the D-bit or the W-bit will be cleared.
 	 */
 	if (new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
+		/*
+		 * If we're with initial-all-set, we don't need
+		 * to write protect any page because they're
+		 * reported as dirty already.
+		 */
+		if (kvm_dirty_log_manual_protect_and_init_set(kvm))
+			return;
+
 		if (kvm_x86_ops.slot_enable_log_dirty) {
 			kvm_x86_ops.slot_enable_log_dirty(kvm, new);
 		} else {
-			int level =
-				kvm_dirty_log_manual_protect_and_init_set(kvm) ?
-				PG_LEVEL_2M : PG_LEVEL_4K;
-
-			/*
-			 * If we're with initial-all-set, we don't need
-			 * to write protect any small page because
-			 * they're reported as dirty already.  However
-			 * we still need to write-protect huge pages
-			 * so that the page split can happen lazily on
-			 * the first write to the huge page.
-			 */
-			kvm_mmu_slot_remove_write_access(kvm, new, level);
+			kvm_mmu_slot_remove_write_access(kvm, new);
 		}
 	} else {
 		if (kvm_x86_ops.slot_disable_log_dirty)
-- 
2.23.0

