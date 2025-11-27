Return-Path: <kvm+bounces-64807-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E898DC8C915
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 02:36:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A22013B2284
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 01:36:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F34325A2B4;
	Thu, 27 Nov 2025 01:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="U7FqDzLF"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4661B21C160
	for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 01:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764207314; cv=none; b=FGQEumkSjR+IDmYJw9quiWMxgO6EB3OW2teBIGhQC3wLdyyuq2tiPw16lMv/XaRpFo0D79wYg0SVKC3x8oFspDE8zWDFDWKTrPqWJkeTYfSsK00ccLVxAWRpl5/mPmNzBnK/ICEIiKWIFDlC2RfXXr00AHA/fhhLnIY5Q1XRcsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764207314; c=relaxed/simple;
	bh=vuv7bbxrOvBKQ1IUI9rgXryPW8TxCWii3teACFVtGLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gtWSyUjh5ruuYZMmVA5mGctdGFyr8WWifQzCzYkcyBZR4JsMDGyKFKLnfY0+qS80DZseopjQamyLLdYJ6Y5Y7SLdyMl9MDHEcR1hj95jrbhSk6YeTi0C44mTxSkMyUMI7CtkplmjjYGTcbIJcsAJTTifP1XwIkKwurrxehZd1LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=U7FqDzLF; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764207308;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gYInxveGKbklo3Ptic2jmegqmlW4BlcGcNBMNHcuHrk=;
	b=U7FqDzLFmWMhwTptUCer8z9mpc1HboYrnPGOjqKuQhpKR/96YWMA9w0jC9TPxcA6om1Z8U
	kKxt2OH39BNcuGoyvN5bW6PuLtz5qHgrITT3ACF6cbM/0huGGg/0VDZUDVxOdZ9tXVkIDL
	ACObJ3espX2p6zyTSMhVIotkYjABllA=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v3 07/16] KVM: selftests: Move PTE bitmasks to kvm_mmu
Date: Thu, 27 Nov 2025 01:34:31 +0000
Message-ID: <20251127013440.3324671-8-yosry.ahmed@linux.dev>
In-Reply-To: <20251127013440.3324671-1-yosry.ahmed@linux.dev>
References: <20251127013440.3324671-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Move the PTE bitmasks into kvm_mmu to parameterize them for virt mapping
functions. Introduce helpers to read/write different PTE bits given a
kvm_mmu.

Drop the 'global' bit definition as it's currently unused, but leave the
'user' bit as it will be used in coming changes. Opportunisitcally
rename 'large' to 'huge' as it's more consistent with the kernel naming.

Leave PHYSICAL_PAGE_MASK alone, it's fixed in all page table formats and
a lot of other macros depend on it. It's tempting to move all the other
macros to be per-struct instead, but it would be too much noise for
little benefit.

Keep c_bit and s_bit in vm->arch as they used before the MMU is
initialized, through  __vmcreate() -> vm_userspace_mem_region_add() ->
vm_mem_add() -> vm_arch_has_protected_memory().

No functional change intended.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 .../selftests/kvm/include/x86/processor.h     | 43 +++++++++---
 .../testing/selftests/kvm/lib/x86/processor.c | 68 +++++++++++--------
 2 files changed, 74 insertions(+), 37 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index 0c295097c714..3a1a82fd42b2 100644
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
@@ -1449,11 +1439,44 @@ enum pg_level {
 #define PG_SIZE_2M PG_LEVEL_SIZE(PG_LEVEL_2M)
 #define PG_SIZE_1G PG_LEVEL_SIZE(PG_LEVEL_1G)
 
+struct pte_masks {
+	uint64_t present;
+	uint64_t writable;
+	uint64_t user;
+	uint64_t accessed;
+	uint64_t dirty;
+	uint64_t huge;
+	uint64_t nx;
+	uint64_t c;
+	uint64_t s;
+};
+
 struct kvm_mmu {
 	uint64_t root_gpa;
 	int pgtable_levels;
+	struct pte_masks pte_masks;
 };
 
+#define PTE_PRESENT_MASK(mmu) ((mmu)->pte_masks.present)
+#define PTE_WRITABLE_MASK(mmu) ((mmu)->pte_masks.writable)
+#define PTE_USER_MASK(mmu) ((mmu)->pte_masks.user)
+#define PTE_ACCESSED_MASK(mmu) ((mmu)->pte_masks.accessed)
+#define PTE_DIRTY_MASK(mmu) ((mmu)->pte_masks.dirty)
+#define PTE_HUGE_MASK(mmu) ((mmu)->pte_masks.huge)
+#define PTE_NX_MASK(mmu) ((mmu)->pte_masks.nx)
+#define PTE_C_MASK(mmu) ((mmu)->pte_masks.c)
+#define PTE_S_MASK(mmu) ((mmu)->pte_masks.s)
+
+#define pte_present(mmu, pte) (!!(*(pte) & PTE_PRESENT_MASK(mmu)))
+#define pte_writable(mmu, pte) (!!(*(pte) & PTE_WRITABLE_MASK(mmu)))
+#define pte_user(mmu, pte) (!!(*(pte) & PTE_USER_MASK(mmu)))
+#define pte_accessed(mmu, pte) (!!(*(pte) & PTE_ACCESSED_MASK(mmu)))
+#define pte_dirty(mmu, pte) (!!(*(pte) & PTE_DIRTY_MASK(mmu)))
+#define pte_huge(mmu, pte) (!!(*(pte) & PTE_HUGE_MASK(mmu)))
+#define pte_nx(mmu, pte) (!!(*(pte) & PTE_NX_MASK(mmu)))
+#define pte_c(mmu, pte) (!!(*(pte) & PTE_C_MASK(mmu)))
+#define pte_s(mmu, pte) (!!(*(pte) & PTE_S_MASK(mmu)))
+
 void __virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, uint64_t vaddr,
 		   uint64_t paddr,  int level);
 void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index 871de49c35ee..dc568d70f9d6 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -157,11 +157,13 @@ bool kvm_is_tdp_enabled(void)
 }
 
 static struct kvm_mmu *mmu_create(struct kvm_vm *vm,
-				  int pgtable_levels)
+				  int pgtable_levels,
+				  struct pte_masks *pte_masks)
 {
 	struct kvm_mmu *mmu = calloc(1, sizeof(*mmu));
 
 	TEST_ASSERT(mmu, "-ENOMEM when allocating MMU");
+	mmu->pte_masks = *pte_masks;
 	mmu->root_gpa = vm_alloc_page_table(vm);
 	mmu->pgtable_levels = pgtable_levels;
 	return mmu;
@@ -169,7 +171,19 @@ static struct kvm_mmu *mmu_create(struct kvm_vm *vm,
 
 static void mmu_init(struct kvm_vm *vm)
 {
-	vm->arch.mmu = mmu_create(vm, vm->pgtable_levels);
+	struct pte_masks pte_masks = (struct pte_masks){
+		.present	=	BIT_ULL(0),
+		.writable	=	BIT_ULL(1),
+		.user		=	BIT_ULL(2),
+		.accessed	=	BIT_ULL(5),
+		.dirty		=	BIT_ULL(6),
+		.huge		=	BIT_ULL(7),
+		.nx		=	BIT_ULL(63),
+		.c		=	vm->arch.c_bit,
+		.s		=	vm->arch.s_bit,
+	};
+
+	vm->arch.mmu = mmu_create(vm, vm->pgtable_levels, &pte_masks);
 	vm->pgd = vm->arch.mmu->root_gpa;
 }
 
@@ -177,7 +191,6 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
 {
 	TEST_ASSERT(vm->mode == VM_MODE_PXXVYY_4K,
 		    "Unknown or unsupported guest mode: 0x%x", vm->mode);
-
 	/* If needed, create the top-level page table. */
 	if (!vm->pgd_created) {
 		mmu_init(vm);
@@ -192,7 +205,7 @@ static void *virt_get_pte(struct kvm_vm *vm, struct kvm_mmu *mmu,
 	uint64_t *page_table = addr_gpa2hva(vm, pt_gpa);
 	int index = (vaddr >> PG_LEVEL_SHIFT(level)) & 0x1ffu;
 
-	TEST_ASSERT((*parent_pte == mmu->root_gpa) || (*parent_pte & PTE_PRESENT_MASK),
+	TEST_ASSERT((*parent_pte == mmu->root_gpa) || pte_present(mmu, parent_pte),
 		    "Parent PTE (level %d) not PRESENT for gva: 0x%08lx",
 		    level + 1, vaddr);
 
@@ -211,10 +224,10 @@ static uint64_t *virt_create_upper_pte(struct kvm_vm *vm,
 
 	paddr = vm_untag_gpa(vm, paddr);
 
-	if (!(*pte & PTE_PRESENT_MASK)) {
-		*pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK;
+	if (!pte_present(mmu, pte)) {
+		*pte = PTE_PRESENT_MASK(mmu) | PTE_WRITABLE_MASK(mmu);
 		if (current_level == target_level)
-			*pte |= PTE_LARGE_MASK | (paddr & PHYSICAL_PAGE_MASK);
+			*pte |= PTE_HUGE_MASK(mmu) | (paddr & PHYSICAL_PAGE_MASK);
 		else
 			*pte |= vm_alloc_page_table(vm) & PHYSICAL_PAGE_MASK;
 	} else {
@@ -226,7 +239,7 @@ static uint64_t *virt_create_upper_pte(struct kvm_vm *vm,
 		TEST_ASSERT(current_level != target_level,
 			    "Cannot create hugepage at level: %u, vaddr: 0x%lx",
 			    current_level, vaddr);
-		TEST_ASSERT(!(*pte & PTE_LARGE_MASK),
+		TEST_ASSERT(!pte_huge(mmu, pte),
 			    "Cannot create page table at level: %u, vaddr: 0x%lx",
 			    current_level, vaddr);
 	}
@@ -267,24 +280,24 @@ void __virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, uint64_t vaddr,
 	     current_level--) {
 		pte = virt_create_upper_pte(vm, mmu, pte, vaddr, paddr,
 					    current_level, level);
-		if (*pte & PTE_LARGE_MASK)
+		if (pte_huge(mmu, pte))
 			return;
 	}
 
 	/* Fill in page table entry. */
 	pte = virt_get_pte(vm, mmu, pte, vaddr, PG_LEVEL_4K);
-	TEST_ASSERT(!(*pte & PTE_PRESENT_MASK),
+	TEST_ASSERT(!pte_present(mmu, pte),
 		    "PTE already present for 4k page at vaddr: 0x%lx", vaddr);
-	*pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK | (paddr & PHYSICAL_PAGE_MASK);
+	*pte = PTE_PRESENT_MASK(mmu) | PTE_WRITABLE_MASK(mmu) | (paddr & PHYSICAL_PAGE_MASK);
 
 	/*
 	 * Neither SEV nor TDX supports shared page tables, so only the final
 	 * leaf PTE needs manually set the C/S-bit.
 	 */
 	if (vm_is_gpa_protected(vm, paddr))
-		*pte |= vm->arch.c_bit;
+		*pte |= PTE_C_MASK(mmu);
 	else
-		*pte |= vm->arch.s_bit;
+		*pte |= PTE_S_MASK(mmu);
 }
 
 void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
@@ -316,7 +329,7 @@ void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 static bool vm_is_target_pte(struct kvm_mmu *mmu, uint64_t *pte,
 			     int *level, int current_level)
 {
-	if (*pte & PTE_LARGE_MASK) {
+	if (pte_huge(mmu, pte)) {
 		TEST_ASSERT(*level == PG_LEVEL_NONE ||
 			    *level == current_level,
 			    "Unexpected hugepage at level %d", current_level);
@@ -374,6 +387,7 @@ uint64_t *vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr)
 
 void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 {
+	struct kvm_mmu *mmu = vm->arch.mmu;
 	uint64_t *pml4e, *pml4e_start;
 	uint64_t *pdpe, *pdpe_start;
 	uint64_t *pde, *pde_start;
@@ -390,44 +404,44 @@ void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 	pml4e_start = (uint64_t *) addr_gpa2hva(vm, vm->pgd);
 	for (uint16_t n1 = 0; n1 <= 0x1ffu; n1++) {
 		pml4e = &pml4e_start[n1];
-		if (!(*pml4e & PTE_PRESENT_MASK))
+		if (!pte_present(mmu, pml4e))
 			continue;
 		fprintf(stream, "%*spml4e 0x%-3zx %p 0x%-12lx 0x%-10llx %u "
 			" %u\n",
 			indent, "",
 			pml4e - pml4e_start, pml4e,
 			addr_hva2gpa(vm, pml4e), PTE_GET_PFN(*pml4e),
-			!!(*pml4e & PTE_WRITABLE_MASK), !!(*pml4e & PTE_NX_MASK));
+			pte_writable(mmu, pml4e), pte_nx(mmu, pml4e));
 
 		pdpe_start = addr_gpa2hva(vm, *pml4e & PHYSICAL_PAGE_MASK);
 		for (uint16_t n2 = 0; n2 <= 0x1ffu; n2++) {
 			pdpe = &pdpe_start[n2];
-			if (!(*pdpe & PTE_PRESENT_MASK))
+			if (!pte_present(mmu, pdpe))
 				continue;
 			fprintf(stream, "%*spdpe  0x%-3zx %p 0x%-12lx 0x%-10llx "
 				"%u  %u\n",
 				indent, "",
 				pdpe - pdpe_start, pdpe,
 				addr_hva2gpa(vm, pdpe),
-				PTE_GET_PFN(*pdpe), !!(*pdpe & PTE_WRITABLE_MASK),
-				!!(*pdpe & PTE_NX_MASK));
+				PTE_GET_PFN(*pdpe), pte_writable(mmu, pdpe),
+				pte_nx(mmu, pdpe));
 
 			pde_start = addr_gpa2hva(vm, *pdpe & PHYSICAL_PAGE_MASK);
 			for (uint16_t n3 = 0; n3 <= 0x1ffu; n3++) {
 				pde = &pde_start[n3];
-				if (!(*pde & PTE_PRESENT_MASK))
+				if (!pte_present(mmu, pde))
 					continue;
 				fprintf(stream, "%*spde   0x%-3zx %p "
 					"0x%-12lx 0x%-10llx %u  %u\n",
 					indent, "", pde - pde_start, pde,
 					addr_hva2gpa(vm, pde),
-					PTE_GET_PFN(*pde), !!(*pde & PTE_WRITABLE_MASK),
-					!!(*pde & PTE_NX_MASK));
+					PTE_GET_PFN(*pde), pte_writable(mmu, pde),
+					pte_nx(mmu, pde));
 
 				pte_start = addr_gpa2hva(vm, *pde & PHYSICAL_PAGE_MASK);
 				for (uint16_t n4 = 0; n4 <= 0x1ffu; n4++) {
 					pte = &pte_start[n4];
-					if (!(*pte & PTE_PRESENT_MASK))
+					if (!pte_present(mmu, pte))
 						continue;
 					fprintf(stream, "%*spte   0x%-3zx %p "
 						"0x%-12lx 0x%-10llx %u  %u "
@@ -436,9 +450,9 @@ void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 						pte - pte_start, pte,
 						addr_hva2gpa(vm, pte),
 						PTE_GET_PFN(*pte),
-						!!(*pte & PTE_WRITABLE_MASK),
-						!!(*pte & PTE_NX_MASK),
-						!!(*pte & PTE_DIRTY_MASK),
+						pte_writable(mmu, pte),
+						pte_nx(mmu, pte),
+						pte_dirty(mmu, pte),
 						((uint64_t) n1 << 27)
 							| ((uint64_t) n2 << 18)
 							| ((uint64_t) n3 << 9)
@@ -522,7 +536,7 @@ vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 	struct kvm_mmu *mmu = vm->arch.mmu;
 	uint64_t *pte = __vm_get_page_table_entry(vm, mmu, gva, &level);
 
-	TEST_ASSERT(*pte & PTE_PRESENT_MASK,
+	TEST_ASSERT(pte_present(mmu, pte),
 		    "Leaf PTE not PRESENT for gva: 0x%08lx", gva);
 
 	/*
-- 
2.52.0.158.g65b55ccf14-goog


