Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A490636E3C3
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 05:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236972AbhD2DmZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 23:42:25 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:17822 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbhD2DmW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 23:42:22 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FW1Sm713czBtQn;
        Thu, 29 Apr 2021 11:39:04 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.187.224) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Thu, 29 Apr 2021 11:41:26 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>
CC:     <wanghaibin.wang@huawei.com>
Subject: [PATCH v3 2/2] KVM: x86: Not wr-protect huge page with init_all_set dirty log
Date:   Thu, 29 Apr 2021 11:41:15 +0800
Message-ID: <20210429034115.35560-3-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20210429034115.35560-1-zhukeqian1@huawei.com>
References: <20210429034115.35560-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.224]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently during start dirty logging, if we're with init-all-set,
we write protect huge pages and leave normal pages untouched, for
that we can enable dirty logging for these pages lazily.

Actually enable dirty logging lazily for huge pages is feasible
too, which not only reduces the time of start dirty logging, also
greatly reduces side-effect on guest when there is high dirty rate.

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 arch/x86/kvm/mmu/mmu.c | 29 +++++++++++++++++++++++++----
 arch/x86/kvm/x86.c     | 37 ++++++++++---------------------------
 2 files changed, 35 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2ce5bc2ea46d..f52c7ceafb72 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1188,8 +1188,7 @@ static bool __rmap_clear_dirty(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
  * @gfn_offset: start of the BITS_PER_LONG pages we care about
  * @mask: indicates which pages we should protect
  *
- * Used when we do not need to care about huge page mappings: e.g. during dirty
- * logging we do not have any such mappings.
+ * Used when we do not need to care about huge page mappings.
  */
 static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 				     struct kvm_memory_slot *slot,
@@ -1246,13 +1245,35 @@ static void kvm_mmu_clear_dirty_pt_masked(struct kvm *kvm,
  * It calls kvm_mmu_write_protect_pt_masked to write protect selected pages to
  * enable dirty logging for them.
  *
- * Used when we do not need to care about huge page mappings: e.g. during dirty
- * logging we do not have any such mappings.
+ * We need to care about huge page mappings: e.g. during dirty logging we may
+ * have any such mappings.
  */
 void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 				struct kvm_memory_slot *slot,
 				gfn_t gfn_offset, unsigned long mask)
 {
+	/*
+	 * Huge pages are NOT write protected when we start dirty log with
+	 * init-all-set, so we must write protect them at here.
+	 *
+	 * The gfn_offset is guaranteed to be aligned to 64, but the base_gfn
+	 * of memslot has no such restriction, so the range can cross two large
+	 * pages.
+	 */
+	if (kvm_dirty_log_manual_protect_and_init_set(kvm)) {
+		gfn_t start = slot->base_gfn + gfn_offset + __ffs(mask);
+		gfn_t end = slot->base_gfn + gfn_offset + __fls(mask);
+
+		kvm_mmu_slot_gfn_write_protect(kvm, slot, start, PG_LEVEL_2M);
+
+		/* Cross two large pages? */
+		if (ALIGN(start << PAGE_SHIFT, PMD_SIZE) !=
+		    ALIGN(end << PAGE_SHIFT, PMD_SIZE))
+			kvm_mmu_slot_gfn_write_protect(kvm, slot, end,
+						       PG_LEVEL_2M);
+	}
+
+	/* Then we can handle the PT level pages */
 	if (kvm_x86_ops.cpu_dirty_log_size)
 		kvm_mmu_clear_dirty_pt_masked(kvm, slot, gfn_offset, mask);
 	else
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index eca63625aee4..dfd676ffa7da 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10888,36 +10888,19 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 		 */
 		kvm_mmu_zap_collapsible_sptes(kvm, new);
 	} else {
-		/* By default, write-protect everything to log writes. */
-		int level = PG_LEVEL_4K;
+		/*
+		 * If we're with initial-all-set, we don't need to write protect
+		 * any page because they're reported as dirty already.
+		 */
+		if (kvm_dirty_log_manual_protect_and_init_set(kvm))
+			return;
 
 		if (kvm_x86_ops.cpu_dirty_log_size) {
-			/*
-			 * Clear all dirty bits, unless pages are treated as
-			 * dirty from the get-go.
-			 */
-			if (!kvm_dirty_log_manual_protect_and_init_set(kvm))
-				kvm_mmu_slot_leaf_clear_dirty(kvm, new);
-
-			/*
-			 * Write-protect large pages on write so that dirty
-			 * logging happens at 4k granularity.  No need to
-			 * write-protect small SPTEs since write accesses are
-			 * logged by the CPU via dirty bits.
-			 */
-			level = PG_LEVEL_2M;
-		} else if (kvm_dirty_log_manual_protect_and_init_set(kvm)) {
-			/*
-			 * If we're with initial-all-set, we don't need
-			 * to write protect any small page because
-			 * they're reported as dirty already.  However
-			 * we still need to write-protect huge pages
-			 * so that the page split can happen lazily on
-			 * the first write to the huge page.
-			 */
-			level = PG_LEVEL_2M;
+			kvm_mmu_slot_leaf_clear_dirty(kvm, new);
+			kvm_mmu_slot_remove_write_access(kvm, new, PG_LEVEL_2M);
+		} else {
+			kvm_mmu_slot_remove_write_access(kvm, new, PG_LEVEL_4K);
 		}
-		kvm_mmu_slot_remove_write_access(kvm, new, level);
 	}
 }
 
-- 
2.23.0

