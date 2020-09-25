Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA00227932F
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 23:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728472AbgIYVXP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 17:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728336AbgIYVXN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Sep 2020 17:23:13 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF00EC0613D5
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 14:23:13 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id w8so2615829qvt.18
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 14:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=ghcbda5Gcwx3UnIAaqAaGm8LTVhquolw1KyMWFRxb/k=;
        b=pYiyHMEJi022dQb6mD1VjA3IbQ9/CGZ5EktjBaX+sqJovC+hXW50n6az8iXbQ4xGWp
         AOznuY9+Dz/NVxY3mPOsTHCgxELYa2uigXZXZRASH0u979wdpWzdX9gvPYepZFsQvfu7
         lT52i1fzeS7O/bfrwEhr9XamVg4SrVJxK9M+L4chLwtqUBprSUnSZDdf3f1UFsiMiteH
         G1WsuQr3ijF7EV3dbu0Mbr4RRpWIJBJFn9FMOJtceZlzfX+PicjWDruT4btApxCY+dNM
         4iTyN1eCEPvC1PTbLRyOBr9M5KaSO24T1ZMjyD6Rq9AkRk9irIumW3RLskFTWrqtZl1s
         0rsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ghcbda5Gcwx3UnIAaqAaGm8LTVhquolw1KyMWFRxb/k=;
        b=VYHuvDIdLk9E5GdvQzFb3GmTi40/A6y1vahGRKFAJgMNf+LtfGCAf7+R7BEg5sk3Qy
         BJeCByrFvyetdCg0lR3SKb521zoXWRT4P6niio5YzlWlMpDmPPoBH7Y+SMDZsjLNlfE7
         s3KIYK+XhyWGFnJxca269X7eEwB5lT6IX/EAUYWpiCH8FQreJWy7WqSsKPxK6h9nPOcc
         m/9srPChdPN06zce4qOUGoRtU8I4SUoy1tX8gyLkDsG67xaqN2hCjUzqGKIiqlo3XVmP
         FMiO+KRAd9P5psqV9ln4wJXRm3lFrImwHzU/ySUwr+yuGzsU8wGT2unb1YO+roPwe20n
         bb+w==
X-Gm-Message-State: AOAM5333pXEbzZsZzGVH6CKrZEyz/9Ihu6TFeLG2py8fzhEhIAImM2kR
        0f6iNHXL+sTycp6eW/KbDx4HOVV3L7ir
X-Google-Smtp-Source: ABdhPJyJCL3aA3scPQXV3XIYl1a3sjvFmRNoITGvHEFC33SHo2AWp3SAL5U/D220afkAixxVLjAOgCBV87IV
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:ad4:4d87:: with SMTP id
 cv7mr642891qvb.49.1601068991820; Fri, 25 Sep 2020 14:23:11 -0700 (PDT)
Date:   Fri, 25 Sep 2020 14:22:42 -0700
In-Reply-To: <20200925212302.3979661-1-bgardon@google.com>
Message-Id: <20200925212302.3979661-3-bgardon@google.com>
Mime-Version: 1.0
References: <20200925212302.3979661-1-bgardon@google.com>
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH 02/22] kvm: mmu: Introduce tdp_iter
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
 arch/x86/kvm/mmu/mmu.c          |  19 +---
 arch/x86/kvm/mmu/mmu_internal.h |  15 +++
 arch/x86/kvm/mmu/tdp_iter.c     | 163 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_iter.h     |  53 +++++++++++
 5 files changed, 237 insertions(+), 16 deletions(-)
 create mode 100644 arch/x86/kvm/mmu/tdp_iter.c
 create mode 100644 arch/x86/kvm/mmu/tdp_iter.h

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 4a3081e9f4b5d..cf6a9947955f7 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -15,7 +15,8 @@ kvm-$(CONFIG_KVM_ASYNC_PF)	+= $(KVM)/async_pf.o
 
 kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
 			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
-			   hyperv.o debugfs.o mmu/mmu.o mmu/page_track.o
+			   hyperv.o debugfs.o mmu/mmu.o mmu/page_track.o \
+			   mmu/tdp_iter.o
 
 kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o vmx/evmcs.o vmx/nested.o
 kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o svm/sev.o
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 81240b558d67f..b48b00c8cde65 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -134,15 +134,6 @@ module_param(dbg, bool, 0644);
 #define SPTE_AD_WRPROT_ONLY_MASK (2ULL << 52)
 #define SPTE_MMIO_MASK (3ULL << 52)
 
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
@@ -192,8 +183,6 @@ module_param(dbg, bool, 0644);
 #define SPTE_HOST_WRITEABLE	(1ULL << PT_FIRST_AVAIL_BITS_SHIFT)
 #define SPTE_MMU_WRITEABLE	(1ULL << (PT_FIRST_AVAIL_BITS_SHIFT + 1))
 
-#define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)
-
 /* make pte_list_desc fit well in cache line */
 #define PTE_LIST_EXT 3
 
@@ -346,7 +335,7 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 access_mask)
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_mask);
 
-static bool is_mmio_spte(u64 spte)
+bool is_mmio_spte(u64 spte)
 {
 	return (spte & SPTE_SPECIAL_MASK) == SPTE_MMIO_MASK;
 }
@@ -623,7 +612,7 @@ static int is_nx(struct kvm_vcpu *vcpu)
 	return vcpu->arch.efer & EFER_NX;
 }
 
-static int is_shadow_present_pte(u64 pte)
+int is_shadow_present_pte(u64 pte)
 {
 	return (pte != 0) && !is_mmio_spte(pte);
 }
@@ -633,7 +622,7 @@ static int is_large_pte(u64 pte)
 	return pte & PT_PAGE_SIZE_MASK;
 }
 
-static int is_last_spte(u64 pte, int level)
+int is_last_spte(u64 pte, int level)
 {
 	if (level == PG_LEVEL_4K)
 		return 1;
@@ -647,7 +636,7 @@ static bool is_executable_pte(u64 spte)
 	return (spte & (shadow_x_mask | shadow_nx_mask)) == shadow_x_mask;
 }
 
-static kvm_pfn_t spte_to_pfn(u64 pte)
+kvm_pfn_t spte_to_pfn(u64 pte)
 {
 	return (pte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT;
 }
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 3acf3b8eb469d..65bb110847858 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -60,4 +60,19 @@ void kvm_mmu_gfn_allow_lpage(struct kvm_memory_slot *slot, gfn_t gfn);
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
+/* Functions for interpreting SPTEs */
+kvm_pfn_t spte_to_pfn(u64 pte);
+bool is_mmio_spte(u64 spte);
+int is_shadow_present_pte(u64 pte);
+int is_last_spte(u64 pte, int level);
+
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
new file mode 100644
index 0000000000000..ee90d62d2a9b1
--- /dev/null
+++ b/arch/x86/kvm/mmu/tdp_iter.c
@@ -0,0 +1,163 @@
+/* SPDX-License-Identifier: GPL-2.0 */
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
+/*
+ * Sets a TDP iterator to walk a pre-order traversal of the paging structure
+ * rooted at root_pt, starting with the walk to translate goal_gfn.
+ */
+void tdp_iter_start(struct tdp_iter *iter, u64 *root_pt, int root_level,
+		    gfn_t goal_gfn)
+{
+	WARN_ON(root_level < 1);
+	WARN_ON(root_level > PT64_ROOT_MAX_LEVEL);
+
+	iter->goal_gfn = goal_gfn;
+	iter->root_level = root_level;
+	iter->level = root_level;
+	iter->pt_path[iter->level - 1] = root_pt;
+
+	iter->gfn = iter->goal_gfn -
+		(iter->goal_gfn % KVM_PAGES_PER_HPAGE(iter->level));
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
+	u64 *pt;
+	/* There's no child entry if this entry isn't present */
+	if (!is_shadow_present_pte(spte))
+		return NULL;
+
+	/* There is no child page table if this is a leaf entry. */
+	if (is_last_spte(spte, level))
+		return NULL;
+
+	pt = (u64 *)__va(spte_to_pfn(spte) << PAGE_SHIFT);
+	return pt;
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
+	if (iter->level == PG_LEVEL_4K)
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
+	iter->gfn = iter->goal_gfn -
+		(iter->goal_gfn % KVM_PAGES_PER_HPAGE(iter->level));
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
+	iter->gfn =  iter->gfn - (iter->gfn % KVM_PAGES_PER_HPAGE(iter->level));
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
+	bool done;
+
+	done = try_step_down(iter);
+	if (done)
+		return;
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
new file mode 100644
index 0000000000000..b102109778eac
--- /dev/null
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -0,0 +1,53 @@
+/* SPDX-License-Identifier: GPL-2.0 */
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
+	for (tdp_iter_start(&iter, root, root_level, start); \
+	     iter.valid && iter.gfn < end;		     \
+	     tdp_iter_next(&iter))
+
+u64 *spte_to_child_pt(u64 pte, int level);
+
+void tdp_iter_start(struct tdp_iter *iter, u64 *root_pt, int root_level,
+		    gfn_t goal_gfn);
+void tdp_iter_next(struct tdp_iter *iter);
+
+#endif /* __KVM_X86_MMU_TDP_ITER_H */
-- 
2.28.0.709.gb0816b6eb0-goog

