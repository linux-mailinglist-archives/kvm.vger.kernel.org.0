Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E5D361B85
	for <lists+kvm@lfdr.de>; Fri, 16 Apr 2021 10:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240063AbhDPIZv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Apr 2021 04:25:51 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:17366 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232022AbhDPIZu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Apr 2021 04:25:50 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FM8Nz6Bl9zlYCt;
        Fri, 16 Apr 2021 16:23:31 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.187.224) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Fri, 16 Apr 2021 16:25:15 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>
CC:     <wanghaibin.wang@huawei.com>
Subject: [RFC PATCH v2 2/2] KVM: x86: Not wr-protect huge page with init_all_set dirty log
Date:   Fri, 16 Apr 2021 16:25:11 +0800
Message-ID: <20210416082511.2856-3-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20210416082511.2856-1-zhukeqian1@huawei.com>
References: <20210416082511.2856-1-zhukeqian1@huawei.com>
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
 arch/x86/kvm/mmu/mmu.c | 48 ++++++++++++++++++++++++++++++++++++++----
 arch/x86/kvm/x86.c     | 37 +++++++++-----------------------
 2 files changed, 54 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2ce5bc2ea46d..98fa25172b9a 100644
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
@@ -1246,13 +1245,54 @@ static void kvm_mmu_clear_dirty_pt_masked(struct kvm *kvm,
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
+	gfn_t start, end;
+
+	/*
+	 * Huge pages are NOT write protected when we start dirty log with
+	 * init-all-set, so we must write protect them at here.
+	 *
+	 * The gfn_offset is guaranteed to be aligned to 64, but the base_gfn
+	 * of memslot has no such restriction, so the range can cross two large
+	 * pages.
+	 */
+	if (kvm_dirty_log_manual_protect_and_init_set(kvm)) {
+		start = slot->base_gfn + gfn_offset + __ffs(mask);
+		end = slot->base_gfn + gfn_offset + __fls(mask);
+		kvm_mmu_slot_gfn_write_protect(kvm, slot, start, PG_LEVEL_2M);
+
+		/* Cross two large pages? */
+		if (ALIGN(start << PAGE_SHIFT, PMD_SIZE) !=
+		    ALIGN(end << PAGE_SHIFT, PMD_SIZE))
+			kvm_mmu_slot_gfn_write_protect(kvm, slot, end,
+						       PG_LEVEL_2M);
+	}
+
+	/*
+	 * RFC:
+	 *
+	 * 1. I don't return early when kvm_mmu_slot_gfn_write_protect() returns
+	 * true, because I am not very clear about the relationship between
+	 * legacy mmu and tdp mmu. AFAICS, the code logic is NOT an if/else
+	 * manner.
+	 *
+	 * The kvm_mmu_slot_gfn_write_protect() returns true when we hit a
+	 * writable large page mapping in legacy mmu mapping or tdp mmu mapping.
+	 * Do we still have normal mapping in that case? (e.g. We have large
+	 * mapping in legacy mmu and normal mapping in tdp mmu).
+	 *
+	 * 2. kvm_mmu_slot_gfn_write_protect() doesn't tell us whether the large
+	 * page mapping exist. If it exists but is clean, we can return early.
+	 * However, we have to do invasive change.
+	 */
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

