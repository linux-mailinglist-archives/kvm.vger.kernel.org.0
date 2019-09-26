Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C77CBFBCF
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 01:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729032AbfIZXSz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 19:18:55 -0400
Received: from mail-qk1-f202.google.com ([209.85.222.202]:44959 "EHLO
        mail-qk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729019AbfIZXSy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 19:18:54 -0400
Received: by mail-qk1-f202.google.com with SMTP id x77so824222qka.11
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 16:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=HYTTeYbK/aVfFSgOVXcFV9VVH02ZEYoiUG/MoI0UcY0=;
        b=rGDN1/dPr08EUOP55QKYL85lqDyr1fTQif9OW5w6aspEMjXO5EzFlqbVMFjLCjtsxH
         kWxKu/lRL1bXJ90jHLIyGRowzWQF0Pfg69OK5rUg7x1euh9U7q43Lmd7oIafXTdkByFd
         GonlM/nQnoOKgseOi6R47QsXESaHWdV0b/tFPtFPGg03cKPoeZNd9hBTo0v0alGfHQgO
         KgqctMZ7FrXcWhKghrXsHCIqStK98A4ItMPEMLggzS7RE/FwjsLd059Z7BOqEqnyms7F
         o0qoG62TZpiEVWylfB91mhvjIGpdq99WyHr99o6P4DIDwQLFlZwfaUlLLu0ljydl4NZF
         oHiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=HYTTeYbK/aVfFSgOVXcFV9VVH02ZEYoiUG/MoI0UcY0=;
        b=KZl6eNAi3aL7KzEdYn+P/45hKlDQMspseJxNNpNncpZfDdx+drkGmzoQOtH3Cq+EPU
         yqznKht4rpuXw1Rr89qmd/FdOomTrGXXMPNAmxOa+CEPkwbvBLlcNNGHAJvyUMOo1Og3
         rkh83BxKx8+7uYKiafW2d3RI4+gBmdDKRDUC+HaaD5eqXhEqOtrH/aIpB2s+FPG9mnbZ
         Nnxn/3lMDg78hvJYS8nz1y4DTtMF4qxk1+HmJTlhpOhO4rlUZqfN367G9RxmP1SZQ20a
         GZXaIEAoyaWdDmngtca7zrtJQCskBKVJa+YWGPmdQKgLo9TVv9RJh8UPy4PHKYwAB9E8
         OXxw==
X-Gm-Message-State: APjAAAWuqEnENIDPrPXDnY6r83OgR9HsY7X4c+ar6UKDqR0WVFjeq3/L
        c5/kHeGYKv1i3r1AcxYlEKuCsC767PUW9o1IHbrTwoD9vQ8gPD0WAAbsprb312HauZCcKyoEaO+
        N1v97yKGGRs8OCpCuiFP5YAlU58bqG6Yz/tDtRlXapTIEMyV4v1xatUzC7gjT
X-Google-Smtp-Source: APXvYqwwM08fU8vK7ZnfwpAp/teTxfnJH2gKHmczwiSyWthxs6MU/ERqwWYIyhoittx4Ow3E6Xnsv7V2nCLt
X-Received: by 2002:ac8:2d2c:: with SMTP id n41mr6867280qta.335.1569539933282;
 Thu, 26 Sep 2019 16:18:53 -0700 (PDT)
Date:   Thu, 26 Sep 2019 16:18:07 -0700
In-Reply-To: <20190926231824.149014-1-bgardon@google.com>
Message-Id: <20190926231824.149014-12-bgardon@google.com>
Mime-Version: 1.0
References: <20190926231824.149014-1-bgardon@google.com>
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
Subject: [RFC PATCH 11/28] kvm: mmu: Optimize for freeing direct MMU PTs on teardown
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

Waiting for a TLB flush and an RCU grace priod before freeing page table
memory grants safety in steady state operation, however these
protections are not always necessary. On VM teardown, only one thread is
operating on the paging structures and no vCPUs are running. As a result
a fast path can be added to the disconnected page table handler which
frees the memory immediately. Add the fast path and use it when tearing
down VMs.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu.c | 44 ++++++++++++++++++++++++++++++++++----------
 1 file changed, 34 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 317e9238f17b2..263718d49f730 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1795,7 +1795,8 @@ static void direct_mmu_disconnected_pt_list_add(struct kvm *kvm,
 
 
 static void handle_changed_pte(struct kvm *kvm, int as_id, gfn_t gfn,
-			       u64 old_pte, u64 new_pte, int level);
+			       u64 old_pte, u64 new_pte, int level,
+			       bool vm_teardown);
 
 /**
  * mark_pte_disconnected - Mark a PTE as part of a disconnected PT
@@ -1805,16 +1806,19 @@ static void handle_changed_pte(struct kvm *kvm, int as_id, gfn_t gfn,
  * @ptep: a pointer to the PTE to be marked disconnected
  * @level: the level of the PT this PTE was a part of, when it was part of the
  *	paging structure
+ * @vm_teardown: all vCPUs are paused and the VM is being torn down. Yield and
+ *	free child page table memory immediately.
  */
 static void mark_pte_disconnected(struct kvm *kvm, int as_id, gfn_t gfn,
-				  u64 *ptep, int level)
+				  u64 *ptep, int level, bool vm_teardown)
 {
 	u64 old_pte;
 
 	old_pte = xchg(ptep, DISCONNECTED_PTE);
 	BUG_ON(old_pte == DISCONNECTED_PTE);
 
-	handle_changed_pte(kvm, as_id, gfn, old_pte, DISCONNECTED_PTE, level);
+	handle_changed_pte(kvm, as_id, gfn, old_pte, DISCONNECTED_PTE, level,
+			   vm_teardown);
 }
 
 /**
@@ -1825,6 +1829,8 @@ static void mark_pte_disconnected(struct kvm *kvm, int as_id, gfn_t gfn,
  * @pt_base_gfn: the base GFN that was mapped by the first PTE in the PT
  * @pfn: The physical frame number of the disconnected PT page
  * @level: the level of the PT, when it was part of the paging structure
+ * @vm_teardown: all vCPUs are paused and the VM is being torn down. Yield and
+ *	free child page table memory immediately.
  *
  * Given a pointer to a page table that has been removed from the paging
  * structure and its level, recursively free child page tables and mark their
@@ -1834,9 +1840,17 @@ static void mark_pte_disconnected(struct kvm *kvm, int as_id, gfn_t gfn,
  * page table or its children because it has been atomically removed from the
  * root of the paging structure, so no other thread will be trying to free the
  * memory.
+ *
+ * If vm_teardown=true, this function will yield while handling the
+ * disconnected page tables and will free memory immediately. This option
+ * should only be used during VM teardown when no other CPUs are accessing the
+ * direct paging structures. Yielding is necessary because the paging structure
+ * could be quite large, and freeing it without yielding would induce
+ * soft-lockups or scheduler warnings.
  */
 static void handle_disconnected_pt(struct kvm *kvm, int as_id,
-				   gfn_t pt_base_gfn, kvm_pfn_t pfn, int level)
+				   gfn_t pt_base_gfn, kvm_pfn_t pfn, int level,
+				   bool vm_teardown)
 {
 	int i;
 	gfn_t gfn = pt_base_gfn;
@@ -1849,13 +1863,20 @@ static void handle_disconnected_pt(struct kvm *kvm, int as_id,
 		 * try to map in an entry there or try to free any child page
 		 * table the entry might have pointed to.
 		 */
-		mark_pte_disconnected(kvm, as_id, gfn, &pt[i], level);
+		mark_pte_disconnected(kvm, as_id, gfn, &pt[i], level,
+				      vm_teardown);
 
 		gfn += KVM_PAGES_PER_HPAGE(level);
 	}
 
-	page = pfn_to_page(pfn);
-	direct_mmu_disconnected_pt_list_add(kvm, page);
+	if (vm_teardown) {
+		BUG_ON(atomic_read(&kvm->online_vcpus) != 0);
+		cond_resched();
+		free_page((unsigned long)pt);
+	} else {
+		page = pfn_to_page(pfn);
+		direct_mmu_disconnected_pt_list_add(kvm, page);
+	}
 }
 
 /**
@@ -1866,6 +1887,8 @@ static void handle_disconnected_pt(struct kvm *kvm, int as_id,
  * @old_pte: The value of the PTE before the atomic compare / exchange
  * @new_pte: The value of the PTE after the atomic compare / exchange
  * @level: the level of the PT the PTE is part of in the paging structure
+ * @vm_teardown: all vCPUs are paused and the VM is being torn down. Yield and
+ *	free child page table memory immediately.
  *
  * Handle bookkeeping that might result from the modification of a PTE.
  * This function should be called in the same RCU read critical section as the
@@ -1874,7 +1897,8 @@ static void handle_disconnected_pt(struct kvm *kvm, int as_id,
  * setting the dirty bit on a pte.
  */
 static void handle_changed_pte(struct kvm *kvm, int as_id, gfn_t gfn,
-			       u64 old_pte, u64 new_pte, int level)
+			       u64 old_pte, u64 new_pte, int level,
+			       bool vm_teardown)
 {
 	bool was_present = is_present_direct_pte(old_pte);
 	bool is_present = is_present_direct_pte(new_pte);
@@ -1920,7 +1944,7 @@ static void handle_changed_pte(struct kvm *kvm, int as_id, gfn_t gfn,
 		 * pointed to must be freed.
 		 */
 		handle_disconnected_pt(kvm, as_id, gfn, spte_to_pfn(old_pte),
-				       child_level);
+				       child_level, vm_teardown);
 	}
 }
 
@@ -5932,7 +5956,7 @@ static void kvm_mmu_uninit_direct_mmu(struct kvm *kvm)
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
 		handle_disconnected_pt(kvm, i, 0,
 			(kvm_pfn_t)(kvm->arch.direct_root_hpa[i] >> PAGE_SHIFT),
-			PT64_ROOT_4LEVEL);
+			PT64_ROOT_4LEVEL, true);
 }
 
 /* The return value indicates if tlb flush on all vcpus is needed. */
-- 
2.23.0.444.g18eeb5a265-goog

