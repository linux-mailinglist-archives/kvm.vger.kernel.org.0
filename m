Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF2B2973E0
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 18:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751559AbgJWQah (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 12:30:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54776 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751529AbgJWQaf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Oct 2020 12:30:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603470633;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fQXo3w6++exbt+yYm9DLvC5CT8Y3RKX9MIYgFenYBXw=;
        b=QLz2Qu1fij2kLZfFx+B28yiJ8mpoqdhUXSo118GYaTIZ/J/+el3qTnNXWZUu5RKrCT5eUc
        OsZvgUK/bjKQWuobJAzFCziXTComfytWkJzUMGVlN6fArD1OG0CL6D6T5LuXiX6A12a8nj
        zvmgV9GUgaW95LPL1T2hxxk4OWmFvxU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479--O5Oz8HwPNicQf4-WNYryg-1; Fri, 23 Oct 2020 12:30:30 -0400
X-MC-Unique: -O5Oz8HwPNicQf4-WNYryg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 449EB1891E91;
        Fri, 23 Oct 2020 16:30:29 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D832E5D9E2;
        Fri, 23 Oct 2020 16:30:28 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     bgardon@google.com
Subject: [PATCH 08/22] kvm: x86/mmu: Add functions to handle changed TDP SPTEs
Date:   Fri, 23 Oct 2020 12:30:10 -0400
Message-Id: <20201023163024.2765558-9-pbonzini@redhat.com>
In-Reply-To: <20201023163024.2765558-1-pbonzini@redhat.com>
References: <20201023163024.2765558-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ben Gardon <bgardon@google.com>

The existing bookkeeping done by KVM when a PTE is changed is spread
around several functions. This makes it difficult to remember all the
stats, bitmaps, and other subsystems that need to be updated whenever a
PTE is modified. When a non-leaf PTE is marked non-present or becomes a
leaf PTE, page table memory must also be freed. To simplify the MMU and
facilitate the use of atomic operations on SPTEs in future patches, create
functions to handle some of the bookkeeping required as a result of
a change.

Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
machine. This series introduced no new failures.

This series can be viewed in Gerrit at:
	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538

Signed-off-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c          |   2 +-
 arch/x86/kvm/mmu/mmu_internal.h |   2 +
 arch/x86/kvm/mmu/tdp_mmu.c      | 112 ++++++++++++++++++++++++++++++++
 3 files changed, 115 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 017d37b19cf3..9c8f42e17f44 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -213,7 +213,7 @@ static void kvm_flush_remote_tlbs_with_range(struct kvm *kvm,
 		kvm_flush_remote_tlbs(kvm);
 }
 
-static void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
+void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
 		u64 start_gfn, u64 pages)
 {
 	struct kvm_tlb_range range;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 6665b10288ce..564954c6b079 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -92,6 +92,8 @@ void kvm_mmu_gfn_disallow_lpage(struct kvm_memory_slot *slot, gfn_t gfn);
 void kvm_mmu_gfn_allow_lpage(struct kvm_memory_slot *slot, gfn_t gfn);
 bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 				    struct kvm_memory_slot *slot, u64 gfn);
+void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
+					u64 start_gfn, u64 pages);
 
 static inline void kvm_mmu_get_root(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 76ebb5898dd7..8accfae76bf6 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -2,6 +2,7 @@
 
 #include "mmu.h"
 #include "mmu_internal.h"
+#include "tdp_iter.h"
 #include "tdp_mmu.h"
 #include "spte.h"
 
@@ -130,3 +131,114 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 
 	return __pa(root->spt);
 }
+
+static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
+				u64 old_spte, u64 new_spte, int level);
+
+/**
+ * handle_changed_spte - handle bookkeeping associated with an SPTE change
+ * @kvm: kvm instance
+ * @as_id: the address space of the paging structure the SPTE was a part of
+ * @gfn: the base GFN that was mapped by the SPTE
+ * @old_spte: The value of the SPTE before the change
+ * @new_spte: The value of the SPTE after the change
+ * @level: the level of the PT the SPTE is part of in the paging structure
+ *
+ * Handle bookkeeping that might result from the modification of a SPTE.
+ * This function must be called for all TDP SPTE modifications.
+ */
+static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
+				u64 old_spte, u64 new_spte, int level)
+{
+	bool was_present = is_shadow_present_pte(old_spte);
+	bool is_present = is_shadow_present_pte(new_spte);
+	bool was_leaf = was_present && is_last_spte(old_spte, level);
+	bool is_leaf = is_present && is_last_spte(new_spte, level);
+	bool pfn_changed = spte_to_pfn(old_spte) != spte_to_pfn(new_spte);
+	u64 *pt;
+	u64 old_child_spte;
+	int i;
+
+	WARN_ON(level > PT64_ROOT_MAX_LEVEL);
+	WARN_ON(level < PG_LEVEL_4K);
+	WARN_ON(gfn % KVM_PAGES_PER_HPAGE(level));
+
+	/*
+	 * If this warning were to trigger it would indicate that there was a
+	 * missing MMU notifier or a race with some notifier handler.
+	 * A present, leaf SPTE should never be directly replaced with another
+	 * present leaf SPTE pointing to a differnt PFN. A notifier handler
+	 * should be zapping the SPTE before the main MM's page table is
+	 * changed, or the SPTE should be zeroed, and the TLBs flushed by the
+	 * thread before replacement.
+	 */
+	if (was_leaf && is_leaf && pfn_changed) {
+		pr_err("Invalid SPTE change: cannot replace a present leaf\n"
+		       "SPTE with another present leaf SPTE mapping a\n"
+		       "different PFN!\n"
+		       "as_id: %d gfn: %llx old_spte: %llx new_spte: %llx level: %d",
+		       as_id, gfn, old_spte, new_spte, level);
+
+		/*
+		 * Crash the host to prevent error propagation and guest data
+		 * courruption.
+		 */
+		BUG();
+	}
+
+	if (old_spte == new_spte)
+		return;
+
+	/*
+	 * The only times a SPTE should be changed from a non-present to
+	 * non-present state is when an MMIO entry is installed/modified/
+	 * removed. In that case, there is nothing to do here.
+	 */
+	if (!was_present && !is_present) {
+		/*
+		 * If this change does not involve a MMIO SPTE, it is
+		 * unexpected. Log the change, though it should not impact the
+		 * guest since both the former and current SPTEs are nonpresent.
+		 */
+		if (WARN_ON(!is_mmio_spte(old_spte) && !is_mmio_spte(new_spte)))
+			pr_err("Unexpected SPTE change! Nonpresent SPTEs\n"
+			       "should not be replaced with another,\n"
+			       "different nonpresent SPTE, unless one or both\n"
+			       "are MMIO SPTEs.\n"
+			       "as_id: %d gfn: %llx old_spte: %llx new_spte: %llx level: %d",
+			       as_id, gfn, old_spte, new_spte, level);
+		return;
+	}
+
+
+	if (was_leaf && is_dirty_spte(old_spte) &&
+	    (!is_dirty_spte(new_spte) || pfn_changed))
+		kvm_set_pfn_dirty(spte_to_pfn(old_spte));
+
+	/*
+	 * Recursively handle child PTs if the change removed a subtree from
+	 * the paging structure.
+	 */
+	if (was_present && !was_leaf && (pfn_changed || !is_present)) {
+		pt = spte_to_child_pt(old_spte, level);
+
+		for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
+			old_child_spte = READ_ONCE(*(pt + i));
+			WRITE_ONCE(*(pt + i), 0);
+			handle_changed_spte(kvm, as_id,
+				gfn + (i * KVM_PAGES_PER_HPAGE(level - 1)),
+				old_child_spte, 0, level - 1);
+		}
+
+		kvm_flush_remote_tlbs_with_address(kvm, gfn,
+						   KVM_PAGES_PER_HPAGE(level));
+
+		free_page((unsigned long)pt);
+	}
+}
+
+static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
+				u64 old_spte, u64 new_spte, int level)
+{
+	__handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level);
+}
-- 
2.26.2


