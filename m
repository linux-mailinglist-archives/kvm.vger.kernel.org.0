Return-Path: <kvm+bounces-60622-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A77EBF5146
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 09:51:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 52BCB18C6963
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 07:51:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F55D28DEE9;
	Tue, 21 Oct 2025 07:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tscP50w1"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421DA2BEC52
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 07:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761032931; cv=none; b=J3WvYMNATyY/oZeVKJN0Pw6bYuivO0UZ6ef1J+G0OvJrlRY4ggVev7bMPy7ripqkzNTj01ZsZCfaYXwV9DCW7wLiDcliEcKZJZfhJHmrur3oZcsNWEYn8KaVapxawSIDGiVwSOLfTx3eIbkNiHgTfXfBQRsoM3025nZSWqsDuqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761032931; c=relaxed/simple;
	bh=SZqOuzEjDdoKPxqV5Y9lkTH9kF6fWYp3FNbawXF6fJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i5onXAu1EsvK1L3YPckEUwQg5Cpdc8MlbQlKt4sJ6FVAT1Hwx/PeFga0l3WqFS2bvQY8z14kjZ0MZrJfgU0ozjdssSibuovzw1yEKftIMDtPgDi/IWM9ZFLf96dKaRdQzkXVrDLo9lqmbg3GFK7EgYiHolx5jMAikQtB61Ey8+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tscP50w1; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761032923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NpTEio1Cyx5w3MYAM4L9C9x1WQNW7BkqB04RH3S+dnM=;
	b=tscP50w1d2QP11dWA0Uz3r5XodiRMtmMij0dWDJbMAatK4zxGvFs4x4ZYqyx4mbqSFIDQm
	cByYSjc9U597cFXg+woY6nT4eyNbPMaiBY2nqkSjmKac1vkUwQKGu1RvvalSEbq8TUcI8h
	SbTDudzr3MkdjWk05P5cYLqXwaxtzuM=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v2 12/23] KVM: selftests: Parameterize the PTE bitmasks for virt mapping functions
Date: Tue, 21 Oct 2025 07:47:25 +0000
Message-ID: <20251021074736.1324328-13-yosry.ahmed@linux.dev>
In-Reply-To: <20251021074736.1324328-1-yosry.ahmed@linux.dev>
References: <20251021074736.1324328-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Move the PTE bitmasks into a struct and define one for x86 page tables.
Move all internal functions in lib/x86/processor.c to take in and use
the structs but do not expose it to external callers. Drop the 'global'
bit definition as it's currently unused, but leave the 'user' bit as it
will be used in coming changes.

Following changes will add support to use the virt mapping functions for
EPTs and NPTs, so they will define their own bitmask structs.

Leave PHYSICAL_PAGE_MASK alone, it's fixed in all page table formats and
a lot of other macros depend on it. It's tempting to move all the other
macros to be per-struct instead, but it would be too much noise for
little benefit.

While at it, make __vm_get_page_table_entry() static as it's not used in
any other files.

No functional change intended.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 .../selftests/kvm/include/x86/processor.h     | 27 +++---
 .../testing/selftests/kvm/lib/x86/processor.c | 92 +++++++++++--------
 2 files changed, 69 insertions(+), 50 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index 51cd84b9ca664..8debe0df3ffca 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -362,16 +362,6 @@ static inline unsigned int x86_model(unsigned int eax)
 	return ((eax >> 12) & 0xf0) | ((eax >> 4) & 0x0f);
 }
 
-/* Page table bitfield declarations */
-#define PTE_PRESENT_MASK        BIT_ULL(0)
-#define PTE_WRITABLE_MASK       BIT_ULL(1)
-#define PTE_USER_MASK           BIT_ULL(2)
-#define PTE_ACCESSED_MASK       BIT_ULL(5)
-#define PTE_DIRTY_MASK          BIT_ULL(6)
-#define PTE_LARGE_MASK          BIT_ULL(7)
-#define PTE_GLOBAL_MASK         BIT_ULL(8)
-#define PTE_NX_MASK             BIT_ULL(63)
-
 #define PHYSICAL_PAGE_MASK      GENMASK_ULL(51, 12)
 
 #define PAGE_SHIFT		12
@@ -1367,8 +1357,6 @@ static inline bool kvm_is_ignore_msrs(void)
 	return get_kvm_param_bool("ignore_msrs");
 }
 
-uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr,
-				    int *level);
 uint64_t *vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr);
 
 uint64_t kvm_hypercall(uint64_t nr, uint64_t a0, uint64_t a1, uint64_t a2,
@@ -1451,7 +1439,20 @@ enum pg_level {
 #define PG_SIZE_2M PG_LEVEL_SIZE(PG_LEVEL_2M)
 #define PG_SIZE_1G PG_LEVEL_SIZE(PG_LEVEL_1G)
 
-void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level);
+struct pte_masks {
+	uint64_t present;
+	uint64_t writeable;
+	uint64_t user;
+	uint64_t accessed;
+	uint64_t dirty;
+	uint64_t large;
+	uint64_t nx;
+};
+
+extern const struct pte_masks x86_pte_masks;
+
+void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
+		   int level, const struct pte_masks *masks);
 void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 		    uint64_t nr_bytes, int level);
 
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index 4ee9fc844ee66..8a838f208abe4 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -169,14 +169,25 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
 	}
 }
 
+const struct pte_masks x86_pte_masks = {
+	.present	=	BIT_ULL(0),
+	.writeable	=	BIT_ULL(1),
+	.user		=	BIT_ULL(2),
+	.accessed	=	BIT_ULL(5),
+	.dirty		=	BIT_ULL(6),
+	.large		=	BIT_ULL(7),
+	.nx		=	BIT_ULL(63),
+};
+
 static void *virt_get_pte(struct kvm_vm *vm, uint64_t *parent_pte,
-			  uint64_t vaddr, int level)
+			  uint64_t vaddr, int level,
+			  const struct pte_masks *masks)
 {
 	uint64_t pt_gpa = PTE_GET_PA(*parent_pte);
 	uint64_t *page_table = addr_gpa2hva(vm, pt_gpa);
 	int index = (vaddr >> PG_LEVEL_SHIFT(level)) & 0x1ffu;
 
-	TEST_ASSERT((*parent_pte & PTE_PRESENT_MASK) || parent_pte == &vm->pgd,
+	TEST_ASSERT((*parent_pte & masks->present) || parent_pte == &vm->pgd,
 		    "Parent PTE (level %d) not PRESENT for gva: 0x%08lx",
 		    level + 1, vaddr);
 
@@ -188,16 +199,17 @@ static uint64_t *virt_create_upper_pte(struct kvm_vm *vm,
 				       uint64_t vaddr,
 				       uint64_t paddr,
 				       int current_level,
-				       int target_level)
+				       int target_level,
+				       const struct pte_masks *masks)
 {
-	uint64_t *pte = virt_get_pte(vm, parent_pte, vaddr, current_level);
+	uint64_t *pte = virt_get_pte(vm, parent_pte, vaddr, current_level, masks);
 
 	paddr = vm_untag_gpa(vm, paddr);
 
-	if (!(*pte & PTE_PRESENT_MASK)) {
-		*pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK;
+	if (!(*pte & masks->present)) {
+		*pte = masks->present | masks->writeable;
 		if (current_level == target_level)
-			*pte |= PTE_LARGE_MASK | (paddr & PHYSICAL_PAGE_MASK);
+			*pte |= masks->large | (paddr & PHYSICAL_PAGE_MASK);
 		else
 			*pte |= vm_alloc_page_table(vm) & PHYSICAL_PAGE_MASK;
 	} else {
@@ -209,14 +221,15 @@ static uint64_t *virt_create_upper_pte(struct kvm_vm *vm,
 		TEST_ASSERT(current_level != target_level,
 			    "Cannot create hugepage at level: %u, vaddr: 0x%lx",
 			    current_level, vaddr);
-		TEST_ASSERT(!(*pte & PTE_LARGE_MASK),
+		TEST_ASSERT(!(*pte & masks->large),
 			    "Cannot create page table at level: %u, vaddr: 0x%lx",
 			    current_level, vaddr);
 	}
 	return pte;
 }
 
-void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
+void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
+		   int level, const struct pte_masks *masks)
 {
 	const uint64_t pg_size = PG_LEVEL_SIZE(level);
 	uint64_t *pte = &vm->pgd;
@@ -246,16 +259,16 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
 	 * early if a hugepage was created.
 	 */
 	for (current_level = vm->pgtable_levels; current_level > PG_LEVEL_4K; current_level--) {
-		pte = virt_create_upper_pte(vm, pte, vaddr, paddr, current_level, level);
-		if (*pte & PTE_LARGE_MASK)
+		pte = virt_create_upper_pte(vm, pte, vaddr, paddr, current_level, level, masks);
+		if (*pte & masks->large)
 			return;
 	}
 
 	/* Fill in page table entry. */
-	pte = virt_get_pte(vm, pte, vaddr, PG_LEVEL_4K);
-	TEST_ASSERT(!(*pte & PTE_PRESENT_MASK),
+	pte = virt_get_pte(vm, pte, vaddr, PG_LEVEL_4K, masks);
+	TEST_ASSERT(!(*pte & masks->present),
 		    "PTE already present for 4k page at vaddr: 0x%lx", vaddr);
-	*pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK | (paddr & PHYSICAL_PAGE_MASK);
+	*pte = masks->present | masks->writeable | (paddr & PHYSICAL_PAGE_MASK);
 
 	/*
 	 * Neither SEV nor TDX supports shared page tables, so only the final
@@ -269,7 +282,7 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
 
 void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 {
-	__virt_pg_map(vm, vaddr, paddr, PG_LEVEL_4K);
+	__virt_pg_map(vm, vaddr, paddr, PG_LEVEL_4K, &x86_pte_masks);
 }
 
 void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
@@ -284,7 +297,7 @@ void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 		    nr_bytes, pg_size);
 
 	for (i = 0; i < nr_pages; i++) {
-		__virt_pg_map(vm, vaddr, paddr, level);
+		__virt_pg_map(vm, vaddr, paddr, level, &x86_pte_masks);
 		sparsebit_set_num(vm->vpages_mapped, vaddr >> vm->page_shift,
 				  nr_bytes / PAGE_SIZE);
 
@@ -293,9 +306,10 @@ void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 	}
 }
 
-static bool vm_is_target_pte(uint64_t *pte, int *level, int current_level)
+static bool vm_is_target_pte(uint64_t *pte, int *level, int current_level,
+			     const struct pte_masks *masks)
 {
-	if (*pte & PTE_LARGE_MASK) {
+	if (*pte & masks->large) {
 		TEST_ASSERT(*level == PG_LEVEL_NONE ||
 			    *level == current_level,
 			    "Unexpected hugepage at level %d", current_level);
@@ -305,8 +319,10 @@ static bool vm_is_target_pte(uint64_t *pte, int *level, int current_level)
 	return *level == current_level;
 }
 
-uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr,
-				    int *level)
+static uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm,
+					   uint64_t vaddr,
+					   int *level,
+					   const struct pte_masks *masks)
 {
 	uint64_t *pte = &vm->pgd;
 	int current_level;
@@ -332,8 +348,8 @@ uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr,
 		"Canonical check failed.  The virtual address is invalid.");
 
 	for (current_level = vm->pgtable_levels; current_level >= PG_LEVEL_4K; current_level--) {
-		pte = virt_get_pte(vm, pte, vaddr, current_level);
-		if (vm_is_target_pte(pte, level, current_level))
+		pte = virt_get_pte(vm, pte, vaddr, current_level, masks);
+		if (vm_is_target_pte(pte, level, current_level, masks))
 			return pte;
 	}
 
@@ -344,11 +360,12 @@ uint64_t *vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr)
 {
 	int level = PG_LEVEL_4K;
 
-	return __vm_get_page_table_entry(vm, vaddr, &level);
+	return __vm_get_page_table_entry(vm, vaddr, &level, &x86_pte_masks);
 }
 
 void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 {
+	const struct pte_masks *masks = &x86_pte_masks;
 	uint64_t *pml4e, *pml4e_start;
 	uint64_t *pdpe, *pdpe_start;
 	uint64_t *pde, *pde_start;
@@ -365,44 +382,44 @@ void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 	pml4e_start = (uint64_t *) addr_gpa2hva(vm, vm->pgd);
 	for (uint16_t n1 = 0; n1 <= 0x1ffu; n1++) {
 		pml4e = &pml4e_start[n1];
-		if (!(*pml4e & PTE_PRESENT_MASK))
+		if (!(*pml4e & masks->present))
 			continue;
 		fprintf(stream, "%*spml4e 0x%-3zx %p 0x%-12lx 0x%-10llx %u "
 			" %u\n",
 			indent, "",
 			pml4e - pml4e_start, pml4e,
 			addr_hva2gpa(vm, pml4e), PTE_GET_PFN(*pml4e),
-			!!(*pml4e & PTE_WRITABLE_MASK), !!(*pml4e & PTE_NX_MASK));
+			!!(*pml4e & masks->writeable), !!(*pml4e & masks->nx));
 
 		pdpe_start = addr_gpa2hva(vm, *pml4e & PHYSICAL_PAGE_MASK);
 		for (uint16_t n2 = 0; n2 <= 0x1ffu; n2++) {
 			pdpe = &pdpe_start[n2];
-			if (!(*pdpe & PTE_PRESENT_MASK))
+			if (!(*pdpe & masks->present))
 				continue;
 			fprintf(stream, "%*spdpe  0x%-3zx %p 0x%-12lx 0x%-10llx "
 				"%u  %u\n",
 				indent, "",
 				pdpe - pdpe_start, pdpe,
 				addr_hva2gpa(vm, pdpe),
-				PTE_GET_PFN(*pdpe), !!(*pdpe & PTE_WRITABLE_MASK),
-				!!(*pdpe & PTE_NX_MASK));
+				PTE_GET_PFN(*pdpe), !!(*pdpe & masks->writeable),
+				!!(*pdpe & masks->nx));
 
 			pde_start = addr_gpa2hva(vm, *pdpe & PHYSICAL_PAGE_MASK);
 			for (uint16_t n3 = 0; n3 <= 0x1ffu; n3++) {
 				pde = &pde_start[n3];
-				if (!(*pde & PTE_PRESENT_MASK))
+				if (!(*pde & masks->present))
 					continue;
 				fprintf(stream, "%*spde   0x%-3zx %p "
 					"0x%-12lx 0x%-10llx %u  %u\n",
 					indent, "", pde - pde_start, pde,
 					addr_hva2gpa(vm, pde),
-					PTE_GET_PFN(*pde), !!(*pde & PTE_WRITABLE_MASK),
-					!!(*pde & PTE_NX_MASK));
+					PTE_GET_PFN(*pde), !!(*pde & masks->writeable),
+					!!(*pde & masks->nx));
 
 				pte_start = addr_gpa2hva(vm, *pde & PHYSICAL_PAGE_MASK);
 				for (uint16_t n4 = 0; n4 <= 0x1ffu; n4++) {
 					pte = &pte_start[n4];
-					if (!(*pte & PTE_PRESENT_MASK))
+					if (!(*pte & masks->present))
 						continue;
 					fprintf(stream, "%*spte   0x%-3zx %p "
 						"0x%-12lx 0x%-10llx %u  %u "
@@ -411,9 +428,9 @@ void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 						pte - pte_start, pte,
 						addr_hva2gpa(vm, pte),
 						PTE_GET_PFN(*pte),
-						!!(*pte & PTE_WRITABLE_MASK),
-						!!(*pte & PTE_NX_MASK),
-						!!(*pte & PTE_DIRTY_MASK),
+						!!(*pte & masks->writeable),
+						!!(*pte & masks->nx),
+						!!(*pte & masks->dirty),
 						((uint64_t) n1 << 27)
 							| ((uint64_t) n2 << 18)
 							| ((uint64_t) n3 << 9)
@@ -493,10 +510,11 @@ static void kvm_seg_set_kernel_data_64bit(struct kvm_segment *segp)
 
 vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 {
+	const struct pte_masks *masks = &x86_pte_masks;
 	int level = PG_LEVEL_NONE;
-	uint64_t *pte = __vm_get_page_table_entry(vm, gva, &level);
+	uint64_t *pte = __vm_get_page_table_entry(vm, gva, &level, masks);
 
-	TEST_ASSERT(*pte & PTE_PRESENT_MASK,
+	TEST_ASSERT(*pte & masks->present,
 		    "Leaf PTE not PRESENT for gva: 0x%08lx", gva);
 
 	/*
-- 
2.51.0.869.ge66316f041-goog


