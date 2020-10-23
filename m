Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B45A2973BE
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 18:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751542AbgJWQaf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 12:30:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39074 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751516AbgJWQae (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Oct 2020 12:30:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603470632;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r0u+Is6JwRmmXFJMLeCPF6/HpKU+rnLQL1ih5VNFzJI=;
        b=OywPTgum9W6QTHy+stt66irplj7v7ZSmZs8XTPF59llWhGQtl0yBmg9SHX0ePAcMXqubR8
        cqDyxF5TnQ99BTugRYP9B+tlOzYL0g3eKiLzRk0HWG0goWuv8G7M5dQJbq7SNEcV5+7rM5
        dV+ZTp6OsjvCckV9y5y3I66qGb4xUmI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-ws4dslFJOmq9yo_MsSRQwQ-1; Fri, 23 Oct 2020 12:30:29 -0400
X-MC-Unique: ws4dslFJOmq9yo_MsSRQwQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7E67CF983;
        Fri, 23 Oct 2020 16:30:27 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4842A5D9E2;
        Fri, 23 Oct 2020 16:30:27 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     bgardon@google.com
Subject: [PATCH 05/22] kvm: x86/mmu: Introduce tdp_iter
Date:   Fri, 23 Oct 2020 12:30:07 -0400
Message-Id: <20201023163024.2765558-6-pbonzini@redhat.com>
In-Reply-To: <20201023163024.2765558-1-pbonzini@redhat.com>
References: <20201023163024.2765558-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ben Gardon <bgardon@google.com>

The TDP iterator implements a pre-order traversal of a TDP paging
structure. This iterator will be used in future patches to create
an efficient implementation of the KVM MMU for the TDP case.

Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
machine. This series introduced no new failures.

This series can be viewed in Gerrit at:
	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538

Signed-off-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/Makefile       |   2 +-
 arch/x86/kvm/mmu/tdp_iter.c | 177 ++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_iter.h |  56 ++++++++++++
 3 files changed, 234 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/kvm/mmu/tdp_iter.c
 create mode 100644 arch/x86/kvm/mmu/tdp_iter.h

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 66aa24f5e2db..a5dd4e5970f8 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -16,7 +16,7 @@ kvm-$(CONFIG_KVM_ASYNC_PF)	+= $(KVM)/async_pf.o
 kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
 			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
 			   hyperv.o debugfs.o mmu/mmu.o mmu/page_track.o \
-			   mmu/spte.o
+			   mmu/spte.o mmu/tdp_iter.o
 
 kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
 			   vmx/evmcs.o vmx/nested.o vmx/posted_intr.o
diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
new file mode 100644
index 000000000000..ad2184cb054c
--- /dev/null
+++ b/arch/x86/kvm/mmu/tdp_iter.c
@@ -0,0 +1,177 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "mmu_internal.h"
+#include "tdp_iter.h"
+#include "spte.h"
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
+	return gfn & -KVM_PAGES_PER_HPAGE(level);
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
+	if (SHADOW_PT_INDEX(iter->gfn << PAGE_SHIFT, iter->level) ==
+            (PT64_ENT_PER_PAGE - 1))
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
index 000000000000..d629a53e1b73
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
2.26.2


