Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 906AC28E641
	for <lists+kvm@lfdr.de>; Wed, 14 Oct 2020 20:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388286AbgJNS1L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Oct 2020 14:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388099AbgJNS1I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Oct 2020 14:27:08 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62EB3C0613D3
        for <kvm@vger.kernel.org>; Wed, 14 Oct 2020 11:27:08 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id h1so70291pll.10
        for <kvm@vger.kernel.org>; Wed, 14 Oct 2020 11:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=RC4N2/gqC7dvT5r7OYRXQDjOiOBDyQ1/me8gzCR93Cg=;
        b=fW/JGUhOe2535gv/T8yzmsT6ybOII5POWX22I9oluIINUAwxctY+mxjc5tjBSpw1gt
         LjQ19FYgBr3EFDsYQZcgzJvEwP5Pe+ZiKWo9W1NGmKoFE1uSD0iItjWULQpdlSi/U6HE
         fE7KmRKp5fJlH2bKxXbDpGbV3SERr1lLGmxaiaHl+cWksLcN/igCzdu2+wF8QRXIKd+n
         Wtc9S6KebRwF1MavgID6RLPnmFevP05jkevPcOw6KqAlYGOIsgrSqeyoM5R9cB04zscN
         UDkRJWXm0uyKIKrzUngiG43S/FIHUcxi84WiWdVZWgbbaat3Jem+xALkmlVdTRlllSr+
         Kw9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=RC4N2/gqC7dvT5r7OYRXQDjOiOBDyQ1/me8gzCR93Cg=;
        b=MSKfWoAhHsB6DuGanQPzgTke0PA/pRiL3aI33EMPkhKxT2xoAe1SYoGxGioIiixYqX
         8UDZ6gYZ9eoAldWkbjWM7H8lt+T85Z7abW3SvKUXPC56cYF8BGwNzuwLSf0Ay4osqSqX
         oqsVRb0/+Lje7GBI8jHSY6yYULylQZJ+cTnPizoLPM0aFoMrqb1ZUSRByYJZ+QmJ+0Vy
         7KHJXaXdO2wBAy/C0VgZap5M66tOjjIF5X8V5y7OEQo2SlOG71no/XJTKUd8qWVzO2jI
         WgsaufQN60p15qs673vV1bL+sig4werTtcQvqvoX654xRgs/LGPjWqmsMdxZaFc4RiJQ
         h1TQ==
X-Gm-Message-State: AOAM531HL1ANHBN5RKGFA+hAKwXEpasn6e+CJNUslYd+tZUl2wyBS/me
        zKrQBXAk1HEcetnnNNDzTUBTcUzZc5Jz
X-Google-Smtp-Source: ABdhPJwnuWxI8owj41gSglpnb1Cp16F+sCPh/GAGpI0q55qSKS74QeOhVKURouObzliIqDHJYFOvDa3TtmDg
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a63:5914:: with SMTP id
 n20mr214535pgb.69.1602700027785; Wed, 14 Oct 2020 11:27:07 -0700 (PDT)
Date:   Wed, 14 Oct 2020 11:26:42 -0700
In-Reply-To: <20201014182700.2888246-1-bgardon@google.com>
Message-Id: <20201014182700.2888246-3-bgardon@google.com>
Mime-Version: 1.0
References: <20201014182700.2888246-1-bgardon@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v2 02/20] kvm: x86/mmu: Introduce tdp_iter
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

The TDP iterator implements a pre-order traversal of a TDP paging
structure. This iterator will be used in future patches to create
an efficient implementation of the KVM MMU for the TDP case.

Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
machine. This series introduced no new failures.

This series can be viewed in Gerrit at:
	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/Makefile           |   3 +-
 arch/x86/kvm/mmu/mmu.c          |  66 ------------
 arch/x86/kvm/mmu/mmu_internal.h |  66 ++++++++++++
 arch/x86/kvm/mmu/tdp_iter.c     | 176 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_iter.h     |  56 ++++++++++
 5 files changed, 300 insertions(+), 67 deletions(-)
 create mode 100644 arch/x86/kvm/mmu/tdp_iter.c
 create mode 100644 arch/x86/kvm/mmu/tdp_iter.h

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 7f86a14aed0e9..4525c1151bf99 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -15,7 +15,8 @@ kvm-$(CONFIG_KVM_ASYNC_PF)	+= $(KVM)/async_pf.o
 
 kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
 			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
-			   hyperv.o debugfs.o mmu/mmu.o mmu/page_track.o
+			   hyperv.o debugfs.o mmu/mmu.o mmu/page_track.o \
+			   mmu/tdp_iter.o
 
 kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
 			   vmx/evmcs.o vmx/nested.o vmx/posted_intr.o
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6c9db349600c8..6d82784ed5679 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -121,28 +121,6 @@ module_param(dbg, bool, 0644);
 
 #define PTE_PREFETCH_NUM		8
 
-#define PT_FIRST_AVAIL_BITS_SHIFT 10
-#define PT64_SECOND_AVAIL_BITS_SHIFT 54
-
-/*
- * The mask used to denote special SPTEs, which can be either MMIO SPTEs or
- * Access Tracking SPTEs.
- */
-#define SPTE_SPECIAL_MASK (3ULL << 52)
-#define SPTE_AD_ENABLED_MASK (0ULL << 52)
-#define SPTE_AD_DISABLED_MASK (1ULL << 52)
-#define SPTE_AD_WRPROT_ONLY_MASK (2ULL << 52)
-#define SPTE_MMIO_MASK (3ULL << 52)
-
-#define PT64_LEVEL_BITS 9
-
-#define PT64_LEVEL_SHIFT(level) \
-		(PAGE_SHIFT + (level - 1) * PT64_LEVEL_BITS)
-
-#define PT64_INDEX(address, level)\
-	(((address) >> PT64_LEVEL_SHIFT(level)) & ((1 << PT64_LEVEL_BITS) - 1))
-
-
 #define PT32_LEVEL_BITS 10
 
 #define PT32_LEVEL_SHIFT(level) \
@@ -155,19 +133,6 @@ module_param(dbg, bool, 0644);
 #define PT32_INDEX(address, level)\
 	(((address) >> PT32_LEVEL_SHIFT(level)) & ((1 << PT32_LEVEL_BITS) - 1))
 
-
-#ifdef CONFIG_DYNAMIC_PHYSICAL_MASK
-#define PT64_BASE_ADDR_MASK (physical_mask & ~(u64)(PAGE_SIZE-1))
-#else
-#define PT64_BASE_ADDR_MASK (((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1))
-#endif
-#define PT64_LVL_ADDR_MASK(level) \
-	(PT64_BASE_ADDR_MASK & ~((1ULL << (PAGE_SHIFT + (((level) - 1) \
-						* PT64_LEVEL_BITS))) - 1))
-#define PT64_LVL_OFFSET_MASK(level) \
-	(PT64_BASE_ADDR_MASK & ((1ULL << (PAGE_SHIFT + (((level) - 1) \
-						* PT64_LEVEL_BITS))) - 1))
-
 #define PT32_BASE_ADDR_MASK PAGE_MASK
 #define PT32_DIR_BASE_ADDR_MASK \
 	(PAGE_MASK & ~((1ULL << (PAGE_SHIFT + PT32_LEVEL_BITS)) - 1))
@@ -192,8 +157,6 @@ module_param(dbg, bool, 0644);
 #define SPTE_HOST_WRITEABLE	(1ULL << PT_FIRST_AVAIL_BITS_SHIFT)
 #define SPTE_MMU_WRITEABLE	(1ULL << (PT_FIRST_AVAIL_BITS_SHIFT + 1))
 
-#define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)
-
 /* make pte_list_desc fit well in cache line */
 #define PTE_LIST_EXT 3
 
@@ -349,11 +312,6 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 access_mask)
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_mask);
 
-static bool is_mmio_spte(u64 spte)
-{
-	return (spte & SPTE_SPECIAL_MASK) == SPTE_MMIO_MASK;
-}
-
 static inline bool sp_ad_disabled(struct kvm_mmu_page *sp)
 {
 	return sp->role.ad_disabled;
@@ -626,35 +584,11 @@ static int is_nx(struct kvm_vcpu *vcpu)
 	return vcpu->arch.efer & EFER_NX;
 }
 
-static int is_shadow_present_pte(u64 pte)
-{
-	return (pte != 0) && !is_mmio_spte(pte);
-}
-
-static int is_large_pte(u64 pte)
-{
-	return pte & PT_PAGE_SIZE_MASK;
-}
-
-static int is_last_spte(u64 pte, int level)
-{
-	if (level == PG_LEVEL_4K)
-		return 1;
-	if (is_large_pte(pte))
-		return 1;
-	return 0;
-}
-
 static bool is_executable_pte(u64 spte)
 {
 	return (spte & (shadow_x_mask | shadow_nx_mask)) == shadow_x_mask;
 }
 
-static kvm_pfn_t spte_to_pfn(u64 pte)
-{
-	return (pte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT;
-}
-
 static gfn_t pse36_gfn_delta(u32 gpte)
 {
 	int shift = 32 - PT32_DIR_PSE36_SHIFT - PAGE_SHIFT;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 3acf3b8eb469d..74ccbf001a42e 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -2,6 +2,8 @@
 #ifndef __KVM_X86_MMU_INTERNAL_H
 #define __KVM_X86_MMU_INTERNAL_H
 
+#include "mmu.h"
+
 #include <linux/types.h>
 
 #include <asm/kvm_host.h>
@@ -60,4 +62,68 @@ void kvm_mmu_gfn_allow_lpage(struct kvm_memory_slot *slot, gfn_t gfn);
 bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 				    struct kvm_memory_slot *slot, u64 gfn);
 
+#define PT64_LEVEL_BITS 9
+
+#define PT64_LEVEL_SHIFT(level) \
+		(PAGE_SHIFT + (level - 1) * PT64_LEVEL_BITS)
+
+#define PT64_INDEX(address, level)\
+	(((address) >> PT64_LEVEL_SHIFT(level)) & ((1 << PT64_LEVEL_BITS) - 1))
+#define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)
+
+#define PT_FIRST_AVAIL_BITS_SHIFT 10
+#define PT64_SECOND_AVAIL_BITS_SHIFT 54
+
+/*
+ * The mask used to denote special SPTEs, which can be either MMIO SPTEs or
+ * Access Tracking SPTEs.
+ */
+#define SPTE_SPECIAL_MASK (3ULL << 52)
+#define SPTE_AD_ENABLED_MASK (0ULL << 52)
+#define SPTE_AD_DISABLED_MASK (1ULL << 52)
+#define SPTE_AD_WRPROT_ONLY_MASK (2ULL << 52)
+#define SPTE_MMIO_MASK (3ULL << 52)
+
+#ifdef CONFIG_DYNAMIC_PHYSICAL_MASK
+#define PT64_BASE_ADDR_MASK (physical_mask & ~(u64)(PAGE_SIZE-1))
+#else
+#define PT64_BASE_ADDR_MASK (((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1))
+#endif
+#define PT64_LVL_ADDR_MASK(level) \
+	(PT64_BASE_ADDR_MASK & ~((1ULL << (PAGE_SHIFT + (((level) - 1) \
+						* PT64_LEVEL_BITS))) - 1))
+#define PT64_LVL_OFFSET_MASK(level) \
+	(PT64_BASE_ADDR_MASK & ((1ULL << (PAGE_SHIFT + (((level) - 1) \
+						* PT64_LEVEL_BITS))) - 1))
+
+/* Functions for interpreting SPTEs */
+static inline bool is_mmio_spte(u64 spte)
+{
+	return (spte & SPTE_SPECIAL_MASK) == SPTE_MMIO_MASK;
+}
+
+static inline int is_shadow_present_pte(u64 pte)
+{
+	return (pte != 0) && !is_mmio_spte(pte);
+}
+
+static inline int is_large_pte(u64 pte)
+{
+	return pte & PT_PAGE_SIZE_MASK;
+}
+
+static inline int is_last_spte(u64 pte, int level)
+{
+	if (level == PG_LEVEL_4K)
+		return 1;
+	if (is_large_pte(pte))
+		return 1;
+	return 0;
+}
+
+static inline kvm_pfn_t spte_to_pfn(u64 pte)
+{
+	return (pte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT;
+}
+
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
new file mode 100644
index 0000000000000..b07e9f0c5d4aa
--- /dev/null
+++ b/arch/x86/kvm/mmu/tdp_iter.c
@@ -0,0 +1,176 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "mmu_internal.h"
+#include "tdp_iter.h"
+
+/*
+ * Recalculates the pointer to the SPTE for the current GFN and level and
+ * reread the SPTE.
+ */
+static void tdp_iter_refresh_sptep(struct tdp_iter *iter)
+{
+	iter->sptep = iter->pt_path[iter->level - 1] +
+		SHADOW_PT_INDEX(iter->gfn << PAGE_SHIFT, iter->level);
+	iter->old_spte = READ_ONCE(*iter->sptep);
+}
+
+static gfn_t round_gfn_for_level(gfn_t gfn, int level)
+{
+	return gfn - (gfn % KVM_PAGES_PER_HPAGE(level));
+}
+
+/*
+ * Sets a TDP iterator to walk a pre-order traversal of the paging structure
+ * rooted at root_pt, starting with the walk to translate goal_gfn.
+ */
+void tdp_iter_start(struct tdp_iter *iter, u64 *root_pt, int root_level,
+		    int min_level, gfn_t goal_gfn)
+{
+	WARN_ON(root_level < 1);
+	WARN_ON(root_level > PT64_ROOT_MAX_LEVEL);
+
+	iter->goal_gfn = goal_gfn;
+	iter->root_level = root_level;
+	iter->min_level = min_level;
+	iter->level = root_level;
+	iter->pt_path[iter->level - 1] = root_pt;
+
+	iter->gfn = round_gfn_for_level(iter->goal_gfn, iter->level);
+	tdp_iter_refresh_sptep(iter);
+
+	iter->valid = true;
+}
+
+/*
+ * Given an SPTE and its level, returns a pointer containing the host virtual
+ * address of the child page table referenced by the SPTE. Returns null if
+ * there is no such entry.
+ */
+u64 *spte_to_child_pt(u64 spte, int level)
+{
+	/*
+	 * There's no child entry if this entry isn't present or is a
+	 * last-level entry.
+	 */
+	if (!is_shadow_present_pte(spte) || is_last_spte(spte, level))
+		return NULL;
+
+	return __va(spte_to_pfn(spte) << PAGE_SHIFT);
+}
+
+/*
+ * Steps down one level in the paging structure towards the goal GFN. Returns
+ * true if the iterator was able to step down a level, false otherwise.
+ */
+static bool try_step_down(struct tdp_iter *iter)
+{
+	u64 *child_pt;
+
+	if (iter->level == iter->min_level)
+		return false;
+
+	/*
+	 * Reread the SPTE before stepping down to avoid traversing into page
+	 * tables that are no longer linked from this entry.
+	 */
+	iter->old_spte = READ_ONCE(*iter->sptep);
+
+	child_pt = spte_to_child_pt(iter->old_spte, iter->level);
+	if (!child_pt)
+		return false;
+
+	iter->level--;
+	iter->pt_path[iter->level - 1] = child_pt;
+	iter->gfn = round_gfn_for_level(iter->goal_gfn, iter->level);
+	tdp_iter_refresh_sptep(iter);
+
+	return true;
+}
+
+/*
+ * Steps to the next entry in the current page table, at the current page table
+ * level. The next entry could point to a page backing guest memory or another
+ * page table, or it could be non-present. Returns true if the iterator was
+ * able to step to the next entry in the page table, false if the iterator was
+ * already at the end of the current page table.
+ */
+static bool try_step_side(struct tdp_iter *iter)
+{
+	/*
+	 * Check if the iterator is already at the end of the current page
+	 * table.
+	 */
+	if (!((iter->gfn + KVM_PAGES_PER_HPAGE(iter->level)) %
+	      KVM_PAGES_PER_HPAGE(iter->level + 1)))
+		return false;
+
+	iter->gfn += KVM_PAGES_PER_HPAGE(iter->level);
+	iter->goal_gfn = iter->gfn;
+	iter->sptep++;
+	iter->old_spte = READ_ONCE(*iter->sptep);
+
+	return true;
+}
+
+/*
+ * Tries to traverse back up a level in the paging structure so that the walk
+ * can continue from the next entry in the parent page table. Returns true on a
+ * successful step up, false if already in the root page.
+ */
+static bool try_step_up(struct tdp_iter *iter)
+{
+	if (iter->level == iter->root_level)
+		return false;
+
+	iter->level++;
+	iter->gfn = round_gfn_for_level(iter->gfn, iter->level);
+	tdp_iter_refresh_sptep(iter);
+
+	return true;
+}
+
+/*
+ * Step to the next SPTE in a pre-order traversal of the paging structure.
+ * To get to the next SPTE, the iterator either steps down towards the goal
+ * GFN, if at a present, non-last-level SPTE, or over to a SPTE mapping a
+ * highter GFN.
+ *
+ * The basic algorithm is as follows:
+ * 1. If the current SPTE is a non-last-level SPTE, step down into the page
+ *    table it points to.
+ * 2. If the iterator cannot step down, it will try to step to the next SPTE
+ *    in the current page of the paging structure.
+ * 3. If the iterator cannot step to the next entry in the current page, it will
+ *    try to step up to the parent paging structure page. In this case, that
+ *    SPTE will have already been visited, and so the iterator must also step
+ *    to the side again.
+ */
+void tdp_iter_next(struct tdp_iter *iter)
+{
+	if (try_step_down(iter))
+		return;
+
+	do {
+		if (try_step_side(iter))
+			return;
+	} while (try_step_up(iter));
+	iter->valid = false;
+}
+
+/*
+ * Restart the walk over the paging structure from the root, starting from the
+ * highest gfn the iterator had previously reached. Assumes that the entire
+ * paging structure, except the root page, may have been completely torn down
+ * and rebuilt.
+ */
+void tdp_iter_refresh_walk(struct tdp_iter *iter)
+{
+	gfn_t goal_gfn = iter->goal_gfn;
+
+	if (iter->gfn > goal_gfn)
+		goal_gfn = iter->gfn;
+
+	tdp_iter_start(iter, iter->pt_path[iter->root_level - 1],
+		       iter->root_level, iter->min_level, goal_gfn);
+}
+
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
new file mode 100644
index 0000000000000..d629a53e1b73f
--- /dev/null
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -0,0 +1,56 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#ifndef __KVM_X86_MMU_TDP_ITER_H
+#define __KVM_X86_MMU_TDP_ITER_H
+
+#include <linux/kvm_host.h>
+
+#include "mmu.h"
+
+/*
+ * A TDP iterator performs a pre-order walk over a TDP paging structure.
+ */
+struct tdp_iter {
+	/*
+	 * The iterator will traverse the paging structure towards the mapping
+	 * for this GFN.
+	 */
+	gfn_t goal_gfn;
+	/* Pointers to the page tables traversed to reach the current SPTE */
+	u64 *pt_path[PT64_ROOT_MAX_LEVEL];
+	/* A pointer to the current SPTE */
+	u64 *sptep;
+	/* The lowest GFN mapped by the current SPTE */
+	gfn_t gfn;
+	/* The level of the root page given to the iterator */
+	int root_level;
+	/* The lowest level the iterator should traverse to */
+	int min_level;
+	/* The iterator's current level within the paging structure */
+	int level;
+	/* A snapshot of the value at sptep */
+	u64 old_spte;
+	/*
+	 * Whether the iterator has a valid state. This will be false if the
+	 * iterator walks off the end of the paging structure.
+	 */
+	bool valid;
+};
+
+/*
+ * Iterates over every SPTE mapping the GFN range [start, end) in a
+ * preorder traversal.
+ */
+#define for_each_tdp_pte(iter, root, root_level, start, end) \
+	for (tdp_iter_start(&iter, root, root_level, PG_LEVEL_4K, start); \
+	     iter.valid && iter.gfn < end;		     \
+	     tdp_iter_next(&iter))
+
+u64 *spte_to_child_pt(u64 pte, int level);
+
+void tdp_iter_start(struct tdp_iter *iter, u64 *root_pt, int root_level,
+		    int min_level, gfn_t goal_gfn);
+void tdp_iter_next(struct tdp_iter *iter);
+void tdp_iter_refresh_walk(struct tdp_iter *iter);
+
+#endif /* __KVM_X86_MMU_TDP_ITER_H */
-- 
2.28.0.1011.ga647a8990f-goog

