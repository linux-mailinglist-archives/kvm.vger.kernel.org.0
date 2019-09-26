Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85614BFBCA
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 01:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728957AbfIZXSr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 19:18:47 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:38129 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728911AbfIZXSq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 19:18:46 -0400
Received: by mail-pg1-f201.google.com with SMTP id m1so2350676pgq.5
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 16:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=qc2FIJjoMRMnM9iD3YvkjCVVKh2fl8gDEeddE5ycrwI=;
        b=eB2CtsZP8+WWfjzK2Mpl4c8nXWmwbmKfextssWXG3u4+b6UmMQQVRdkv8OFvtOEKLe
         Hb/KssEm3NqyDfTSt3x22L4Kr3Ex1lxrIKiYg1Tr37bl8ycteODynwqzhRD36hEHAxpn
         QWrVh+TJf7RBnSDcesCvpN/CsjlJhY2Brw08Eke5jIWxvfO4n0OC4xfijf1OX/Hf4KrP
         te9oXyH3bAlUl5Dcev5g1oCoPByBjm6f6heUhHRnlviBoCfH1gMDylnBn7xlMkacn5CL
         ALTadmCjeBPmIIUa+Bdo++ZiV4a6j4ZbyITRZEScG75hX7c1vQ/TnrxGEXasyEWWC2VL
         zGyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=qc2FIJjoMRMnM9iD3YvkjCVVKh2fl8gDEeddE5ycrwI=;
        b=JuvO8Esq5GdAAmmZemrkBfO2HERfDOtU4ACTIUz26VpUe5/cm6VvFdJuztgi+fl4ZN
         lzE/9rEXifKQb2G+uAP8elpUN0ZNRRJtzaNeoLbZfLxL0+8wxwto4n2yJ1qAz2DExgr/
         rtnEjOBF3EpTZE8cdQx8b3APW8dDd7KmzFw8IkUnL335HhKRGQtP7XPnAClC0E5jn7Is
         lb81c4pRVa/4NnlHKURQbYJ3NX0ERE2pmdvTwTH5awRcVF71uXCnk12UUDDAtB7TUCTL
         rtTPOdO7OQ2XrOLuD8x0JXP73AnRMLTobduKAV2cqN2CoyGESI+HeofEMRrTrg6s5JbJ
         CSXA==
X-Gm-Message-State: APjAAAXFxrxjCWMFSUafce5Q4ciVbmWIgw3tBFZPf8siaYDfX+apO+5w
        3/00wE4qFvjRKEYBYuZeFnFixdRinDN3vvQ9DsfnAUIz3PYLIxfIH4EqPfczhBi/PJ7ca37I3Jj
        WyVLuyWP2Fyq9yxKnyf+l5DiRvM5llyUQIgIKLLAvhN6bYICLAGhd238w5Lrk
X-Google-Smtp-Source: APXvYqz4nMCIPOZJL7l6N5+EC9ZP9HANzvmB+9r4PD6oVlBdu6/3M5JM4WDO99SehT32DscVGIh1NhEqzKiE
X-Received: by 2002:a65:68c9:: with SMTP id k9mr6156369pgt.49.1569539923984;
 Thu, 26 Sep 2019 16:18:43 -0700 (PDT)
Date:   Thu, 26 Sep 2019 16:18:03 -0700
In-Reply-To: <20190926231824.149014-1-bgardon@google.com>
Message-Id: <20190926231824.149014-8-bgardon@google.com>
Mime-Version: 1.0
References: <20190926231824.149014-1-bgardon@google.com>
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
Subject: [RFC PATCH 07/28] kvm: mmu: Add functions for handling changed PTEs
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

The existing bookkeeping done by KVM when a PTE is changed is
spread around several functions. This makes it difficult to remember all
the stats, bitmaps, and other subsystems that need to be updated whenever
a PTE is modified. When a non-leaf PTE is marked non-present or becomes
a leaf PTE, page table memory must also be freed. Further, most of the
bookkeeping is done before the PTE is actually set. This works well with
a monolithic MMU lock, however if changes use atomic compare/exchanges,
the bookkeeping cannot be done before the change is made. In either
case, there is a short window in which some statistics, e.g. the dirty
bitmap will be inconsistent, however consistency is still restored
before the MMU lock is released. To simplify the MMU and facilitate the
use of atomic operations on PTEs, create functions to handle some of the
bookkeeping required as a result of the change.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu.c | 145 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 145 insertions(+)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 0311d18d9a995..50413f17c7cd0 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -143,6 +143,18 @@ module_param(dbg, bool, 0644);
 #define SPTE_HOST_WRITEABLE	(1ULL << PT_FIRST_AVAIL_BITS_SHIFT)
 #define SPTE_MMU_WRITEABLE	(1ULL << (PT_FIRST_AVAIL_BITS_SHIFT + 1))
 
+/*
+ * PTEs in a disconnected page table can be set to DISCONNECTED_PTE to indicate
+ * to other threads that the page table in which the pte resides is no longer
+ * connected to the root of a paging structure.
+ *
+ * This constant works because it is considered non-present on both AMD and
+ * Intel CPUs and does not create a L1TF vulnerability because the pfn section
+ * is zeroed out. PTE bit 57 is available to software, per vol 3, figure 28-1
+ * of the Intel SDM and vol 2, figures 5-18 to 5-21 of the AMD APM.
+ */
+#define DISCONNECTED_PTE (1ull << 57)
+
 #define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)
 
 /* make pte_list_desc fit well in cache line */
@@ -555,6 +567,16 @@ static int is_shadow_present_pte(u64 pte)
 	return (pte != 0) && !is_mmio_spte(pte);
 }
 
+static inline int is_disconnected_pte(u64 pte)
+{
+	return pte == DISCONNECTED_PTE;
+}
+
+static int is_present_direct_pte(u64 pte)
+{
+	return is_shadow_present_pte(pte) && !is_disconnected_pte(pte);
+}
+
 static int is_large_pte(u64 pte)
 {
 	return pte & PT_PAGE_SIZE_MASK;
@@ -1659,6 +1681,129 @@ static bool __rmap_set_dirty(struct kvm *kvm, struct kvm_rmap_head *rmap_head)
 	return flush;
 }
 
+static void handle_changed_pte(struct kvm *kvm, int as_id, gfn_t gfn,
+			       u64 old_pte, u64 new_pte, int level);
+
+/**
+ * mark_pte_disconnected - Mark a PTE as part of a disconnected PT
+ * @kvm: kvm instance
+ * @as_id: the address space of the paging structure the PTE was a part of
+ * @gfn: the base GFN that was mapped by the PTE
+ * @ptep: a pointer to the PTE to be marked disconnected
+ * @level: the level of the PT this PTE was a part of, when it was part of the
+ *	paging structure
+ */
+static void mark_pte_disconnected(struct kvm *kvm, int as_id, gfn_t gfn,
+				  u64 *ptep, int level)
+{
+	u64 old_pte;
+
+	old_pte = xchg(ptep, DISCONNECTED_PTE);
+	BUG_ON(old_pte == DISCONNECTED_PTE);
+
+	handle_changed_pte(kvm, as_id, gfn, old_pte, DISCONNECTED_PTE, level);
+}
+
+/**
+ * handle_disconnected_pt - Mark a PT as disconnected and handle associated
+ * bookkeeping and freeing
+ * @kvm: kvm instance
+ * @as_id: the address space of the paging structure the PT was a part of
+ * @pt_base_gfn: the base GFN that was mapped by the first PTE in the PT
+ * @pfn: The physical frame number of the disconnected PT page
+ * @level: the level of the PT, when it was part of the paging structure
+ *
+ * Given a pointer to a page table that has been removed from the paging
+ * structure and its level, recursively free child page tables and mark their
+ * entries as disconnected.
+ */
+static void handle_disconnected_pt(struct kvm *kvm, int as_id,
+				   gfn_t pt_base_gfn, kvm_pfn_t pfn, int level)
+{
+	int i;
+	gfn_t gfn = pt_base_gfn;
+	u64 *pt = pfn_to_kaddr(pfn);
+
+	for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
+		/*
+		 * Mark the PTE as disconnected so that no other thread will
+		 * try to map in an entry there or try to free any child page
+		 * table the entry might have pointed to.
+		 */
+		mark_pte_disconnected(kvm, as_id, gfn, &pt[i], level);
+
+		gfn += KVM_PAGES_PER_HPAGE(level);
+	}
+
+	free_page((unsigned long)pt);
+}
+
+/**
+ * handle_changed_pte - handle bookkeeping associated with a PTE change
+ * @kvm: kvm instance
+ * @as_id: the address space of the paging structure the PTE was a part of
+ * @gfn: the base GFN that was mapped by the PTE
+ * @old_pte: The value of the PTE before the atomic compare / exchange
+ * @new_pte: The value of the PTE after the atomic compare / exchange
+ * @level: the level of the PT the PTE is part of in the paging structure
+ *
+ * Handle bookkeeping that might result from the modification of a PTE.
+ * This function should be called in the same RCU read critical section as the
+ * atomic cmpxchg on the pte. This function must be called for all direct pte
+ * modifications except those which strictly emulate hardware, for example
+ * setting the dirty bit on a pte.
+ */
+static void handle_changed_pte(struct kvm *kvm, int as_id, gfn_t gfn,
+			       u64 old_pte, u64 new_pte, int level)
+{
+	bool was_present = is_present_direct_pte(old_pte);
+	bool is_present = is_present_direct_pte(new_pte);
+	bool was_leaf = was_present && is_last_spte(old_pte, level);
+	bool pfn_changed = spte_to_pfn(old_pte) != spte_to_pfn(new_pte);
+	int child_level;
+
+	BUG_ON(level > PT64_ROOT_MAX_LEVEL);
+	BUG_ON(level < PT_PAGE_TABLE_LEVEL);
+	BUG_ON(gfn % KVM_PAGES_PER_HPAGE(level));
+
+	/*
+	 * The only times a pte should be changed from a non-present to
+	 * non-present state is when an entry in an unlinked page table is
+	 * marked as a disconnected PTE as part of freeing the page table,
+	 * or an MMIO entry is installed/modified. In these cases there is
+	 * nothing to do.
+	 */
+	if (!was_present && !is_present) {
+		/*
+		 * If this change is not on an MMIO PTE and not setting a PTE
+		 * as disconnected, then it is unexpected. Log the change,
+		 * though it should not impact the guest since both the former
+		 * and current PTEs are nonpresent.
+		 */
+		WARN_ON((new_pte != DISCONNECTED_PTE) &&
+			!is_mmio_spte(new_pte));
+		return;
+	}
+
+	if (was_present && !was_leaf && (pfn_changed || !is_present)) {
+		/*
+		 * The level of the page table being freed is one level lower
+		 * than the level at which it is mapped.
+		 */
+		child_level = level - 1;
+
+		/*
+		 * If there was a present non-leaf entry before, and now the
+		 * entry points elsewhere, the lpage stats and dirty logging /
+		 * access tracking status for all the entries the old pte
+		 * pointed to must be updated and the page table pages it
+		 * pointed to must be freed.
+		 */
+		handle_disconnected_pt(kvm, as_id, gfn, spte_to_pfn(old_pte),
+				       child_level);
+	}
+}
+
 /**
  * kvm_mmu_write_protect_pt_masked - write protect selected PT level pages
  * @kvm: kvm instance
-- 
2.23.0.444.g18eeb5a265-goog

