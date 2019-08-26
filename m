Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39BA89C93B
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 08:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729681AbfHZGVj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 02:21:39 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36279 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729419AbfHZGVj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 02:21:39 -0400
Received: by mail-pl1-f194.google.com with SMTP id f19so9494771plr.3;
        Sun, 25 Aug 2019 23:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jhumqEElyml+VQcUaz7DK88JZN+LVnNlU6ClLZJta9U=;
        b=VtcuNQf7yEwrSFkRAfdSjIjfch56FwVopMVv6HPntvZWXjkJfqpa7HvzcMh+YDAWVm
         JWT+yLAXuTqxPTrw5qDFA1qe6TadkmwdK6JsPYWKmP4BwY1n5k/OZdE5reqUCNgOD7RH
         VmeMKPd8mjg6ffO6J7etF/QRz/JjXcdnRXRnrt57b1CKPqPueIOUd8aGnKA+wn/UVHo9
         zEVtLbGIPw4qILimduGeFqWZRTpBLy9Go8DOdjRKZQ1t2ZQC8FtklEZk9f9KwtQ0wAxx
         KziFTujSDdhE+4NkHVQjJpHeuRC8lwTWNRpKcfA35cvn4fISAnZ9K4MXlnecwuhdepXr
         s+EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jhumqEElyml+VQcUaz7DK88JZN+LVnNlU6ClLZJta9U=;
        b=huvFeJvnYPiHJd7HiBqJcI/Yg0xIeYPqdlD/BzyUuad+gr5fd5AMhMaWgBP4U+Z2rM
         aEDZ4b29yDzfPOQChddmyHp7QITnbPvkmpLMKuT3Lcda5lOsh8inWdEV/TJjt0XWODsK
         tG6Tj1e9q5SU2FC0bXnhUZYu3PUkcX9DTmj0qe6tmFG9nTcCkWIUbROf3VKprLFFo0Tb
         cm6NhFeElCwF74xmcrpH7K/HLuy5g9nlKu+Ayba/Me4iXYCarwZujI7CFSeTgz6UAelZ
         sxuyj5szVZ/BOft1TCEaC4M8kuxuwGGH9SON4+qCUQ+1lDNGYIN3BpWN94wPYqb3svbH
         ZUFQ==
X-Gm-Message-State: APjAAAVEmX9wX9+Jv6Qjs5f+Bw1F6wl0aCrX7qZqx+s0blpxkitSw9wI
        T9b4dJpdmUn5YRulg5L5djAR9IR0DP0=
X-Google-Smtp-Source: APXvYqxjdqCURqGwvJ/P9qaL1HC1wQsj5JqATwgkcG8DFbvhMZwOvZ6JeD4koSREU5No+31kfELcQQ==
X-Received: by 2002:a17:902:bcc2:: with SMTP id o2mr17490425pls.127.1566800497870;
        Sun, 25 Aug 2019 23:21:37 -0700 (PDT)
Received: from surajjs2.ozlabs.ibm.com.ozlabs.ibm.com ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id f7sm10030353pfd.43.2019.08.25.23.21.35
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 25 Aug 2019 23:21:37 -0700 (PDT)
From:   Suraj Jitindar Singh <sjitindarsingh@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     paulus@ozlabs.org, kvm@vger.kernel.org,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Subject: [PATCH 09/23] KVM: PPC: Book3S HV: Nested: Improve comments and naming of nest rmap functions
Date:   Mon, 26 Aug 2019 16:20:55 +1000
Message-Id: <20190826062109.7573-10-sjitindarsingh@gmail.com>
X-Mailer: git-send-email 2.13.6
In-Reply-To: <20190826062109.7573-1-sjitindarsingh@gmail.com>
References: <20190826062109.7573-1-sjitindarsingh@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The nested rmap entries are used to track nested pages which map a given
guest page such that that information can be retrieved from the guest
memslot.

Improve the naming of some of these functions such that it's clearer
what they do, the functions with remove in the name remove the rmap
_and_ perform an invalidation so rename them invalidate to reflect this.

kvmhv_insert_nest_rmap() takes a kvm struct as an argument which is unused,
so remove this argument.

Additionally improve the function comments and add information about which
locks must be held for clarity.

No functional change.

Signed-off-by: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
---
 arch/powerpc/include/asm/kvm_book3s_64.h |  4 +--
 arch/powerpc/kvm/book3s_64_mmu_radix.c   |  8 +++---
 arch/powerpc/kvm/book3s_hv_nested.c      | 49 +++++++++++++++++++++++---------
 3 files changed, 42 insertions(+), 19 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_book3s_64.h b/arch/powerpc/include/asm/kvm_book3s_64.h
index bb7c8cc77f1a..bec78f15e2f5 100644
--- a/arch/powerpc/include/asm/kvm_book3s_64.h
+++ b/arch/powerpc/include/asm/kvm_book3s_64.h
@@ -624,12 +624,12 @@ extern int kvmppc_create_pte(struct kvm *kvm, pgd_t *pgtable, pte_t pte,
 			     unsigned long gpa, unsigned int level,
 			     unsigned long mmu_seq, unsigned int lpid,
 			     unsigned long *rmapp, struct rmap_nested **n_rmap);
-extern void kvmhv_insert_nest_rmap(struct kvm *kvm, unsigned long *rmapp,
+extern void kvmhv_insert_nest_rmap(unsigned long *rmapp,
 				   struct rmap_nested **n_rmap);
 extern void kvmhv_update_nest_rmap_rc_list(struct kvm *kvm, unsigned long *rmapp,
 					   unsigned long clr, unsigned long set,
 					   unsigned long hpa, unsigned long nbytes);
-extern void kvmhv_remove_nest_rmap_range(struct kvm *kvm,
+extern void kvmhv_invalidate_nest_rmap_range(struct kvm *kvm,
 				const struct kvm_memory_slot *memslot,
 				unsigned long gpa, unsigned long hpa,
 				unsigned long nbytes);
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index 310d8dde9a48..48b844d33dc9 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -405,7 +405,7 @@ void kvmppc_unmap_pte(struct kvm *kvm, pte_t *pte, unsigned long gpa,
 
 	gpa &= ~(page_size - 1);
 	hpa = old & PTE_RPN_MASK;
-	kvmhv_remove_nest_rmap_range(kvm, memslot, gpa, hpa, page_size);
+	kvmhv_invalidate_nest_rmap_range(kvm, memslot, gpa, hpa, page_size);
 
 	if ((old & _PAGE_DIRTY) && memslot->dirty_bitmap)
 		kvmppc_update_dirty_map(memslot, gfn, page_size);
@@ -643,7 +643,7 @@ int kvmppc_create_pte(struct kvm *kvm, pgd_t *pgtable, pte_t pte,
 		}
 		kvmppc_radix_set_pte_at(kvm, gpa, (pte_t *)pud, pte);
 		if (rmapp && n_rmap)
-			kvmhv_insert_nest_rmap(kvm, rmapp, n_rmap);
+			kvmhv_insert_nest_rmap(rmapp, n_rmap);
 		ret = 0;
 		goto out_unlock;
 	}
@@ -695,7 +695,7 @@ int kvmppc_create_pte(struct kvm *kvm, pgd_t *pgtable, pte_t pte,
 		}
 		kvmppc_radix_set_pte_at(kvm, gpa, pmdp_ptep(pmd), pte);
 		if (rmapp && n_rmap)
-			kvmhv_insert_nest_rmap(kvm, rmapp, n_rmap);
+			kvmhv_insert_nest_rmap(rmapp, n_rmap);
 		ret = 0;
 		goto out_unlock;
 	}
@@ -721,7 +721,7 @@ int kvmppc_create_pte(struct kvm *kvm, pgd_t *pgtable, pte_t pte,
 	}
 	kvmppc_radix_set_pte_at(kvm, gpa, ptep, pte);
 	if (rmapp && n_rmap)
-		kvmhv_insert_nest_rmap(kvm, rmapp, n_rmap);
+		kvmhv_insert_nest_rmap(rmapp, n_rmap);
 	ret = 0;
 
  out_unlock:
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 68d492e8861e..555b45a35fec 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -776,8 +776,8 @@ static inline bool kvmhv_n_rmap_is_equal(u64 rmap_1, u64 rmap_2)
 				       RMAP_NESTED_GPA_MASK));
 }
 
-void kvmhv_insert_nest_rmap(struct kvm *kvm, unsigned long *rmapp,
-			    struct rmap_nested **n_rmap)
+/* called with kvm->mmu_lock held */
+void kvmhv_insert_nest_rmap(unsigned long *rmapp, struct rmap_nested **n_rmap)
 {
 	struct llist_node *entry = ((struct llist_head *) rmapp)->first;
 	struct rmap_nested *cursor;
@@ -808,6 +808,11 @@ void kvmhv_insert_nest_rmap(struct kvm *kvm, unsigned long *rmapp,
 	*n_rmap = NULL;
 }
 
+/*
+ * called with kvm->mmu_lock held
+ * Given a single rmap entry, update the rc bits in the corresponding shadow
+ * pte. Should only be used to clear rc bits.
+ */
 static void kvmhv_update_nest_rmap_rc(struct kvm *kvm, u64 n_rmap,
 				      unsigned long clr, unsigned long set,
 				      unsigned long hpa, unsigned long mask)
@@ -838,8 +843,10 @@ static void kvmhv_update_nest_rmap_rc(struct kvm *kvm, u64 n_rmap,
 }
 
 /*
+ * called with kvm->mmu_lock held
  * For a given list of rmap entries, update the rc bits in all ptes in shadow
  * page tables for nested guests which are referenced by the rmap list.
+ * Should only be used to clear rc bits.
  */
 void kvmhv_update_nest_rmap_rc_list(struct kvm *kvm, unsigned long *rmapp,
 				    unsigned long clr, unsigned long set,
@@ -859,8 +866,12 @@ void kvmhv_update_nest_rmap_rc_list(struct kvm *kvm, unsigned long *rmapp,
 		kvmhv_update_nest_rmap_rc(kvm, rmap, clr, set, hpa, mask);
 }
 
-static void kvmhv_remove_nest_rmap(struct kvm *kvm, u64 n_rmap,
-				   unsigned long hpa, unsigned long mask)
+/*
+ * called with kvm->mmu_lock held
+ * Given a single rmap entry, invalidate the corresponding shadow pte.
+ */
+static void kvmhv_invalidate_nest_rmap(struct kvm *kvm, u64 n_rmap,
+				       unsigned long hpa, unsigned long mask)
 {
 	struct kvm_nested_guest *gp;
 	unsigned long gpa;
@@ -880,24 +891,35 @@ static void kvmhv_remove_nest_rmap(struct kvm *kvm, u64 n_rmap,
 		kvmppc_unmap_pte(kvm, ptep, gpa, shift, NULL, gp->shadow_lpid);
 }
 
-static void kvmhv_remove_nest_rmap_list(struct kvm *kvm, unsigned long *rmapp,
-					unsigned long hpa, unsigned long mask)
+/*
+ * called with kvm->mmu_lock held
+ * For a given list of rmap entries, invalidate the corresponding shadow ptes
+ * for nested guests which are referenced by the rmap list.
+ */
+static void kvmhv_invalidate_nest_rmap_list(struct kvm *kvm,
+					    unsigned long *rmapp,
+					    unsigned long hpa,
+					    unsigned long mask)
 {
 	struct llist_node *entry = llist_del_all((struct llist_head *) rmapp);
 	struct rmap_nested *cursor;
 	unsigned long rmap;
 
 	for_each_nest_rmap_safe(cursor, entry, &rmap) {
-		kvmhv_remove_nest_rmap(kvm, rmap, hpa, mask);
+		kvmhv_invalidate_nest_rmap(kvm, rmap, hpa, mask);
 		kfree(cursor);
 	}
 }
 
-/* called with kvm->mmu_lock held */
-void kvmhv_remove_nest_rmap_range(struct kvm *kvm,
-				  const struct kvm_memory_slot *memslot,
-				  unsigned long gpa, unsigned long hpa,
-				  unsigned long nbytes)
+/*
+ * called with kvm->mmu_lock held
+ * For a given memslot, invalidate all of the rmap entries which fall into the
+ * given range.
+ */
+void kvmhv_invalidate_nest_rmap_range(struct kvm *kvm,
+				      const struct kvm_memory_slot *memslot,
+				      unsigned long gpa, unsigned long hpa,
+				      unsigned long nbytes)
 {
 	unsigned long gfn, end_gfn;
 	unsigned long addr_mask;
@@ -912,10 +934,11 @@ void kvmhv_remove_nest_rmap_range(struct kvm *kvm,
 
 	for (; gfn < end_gfn; gfn++) {
 		unsigned long *rmap = &memslot->arch.rmap[gfn];
-		kvmhv_remove_nest_rmap_list(kvm, rmap, hpa, addr_mask);
+		kvmhv_invalidate_nest_rmap_list(kvm, rmap, hpa, addr_mask);
 	}
 }
 
+/* Free the nest rmap structures for a given memslot */
 static void kvmhv_free_memslot_nest_rmap(struct kvm_memory_slot *free)
 {
 	unsigned long page;
-- 
2.13.6

