Return-Path: <kvm+bounces-64806-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A831AC8C90F
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 02:36:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 28B803B2098
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 01:36:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9E48258CE5;
	Thu, 27 Nov 2025 01:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gGki0PWz"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B770D23B62C
	for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 01:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764207313; cv=none; b=ZVaUDkPkoowvO2CPPyo4oswzupa7nw6NtvNCYIBeoUOApieQv507DYUjz05eLGE74fwQmrAuOrKWW9LsdwoeTo5bZyS4hxJYRVEX385+FOUUO7jGy3TPK5+2/O6JtgN559+AKJchqCmuvlBBIVG33xIBKSdjToUjj3VzgnIGL8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764207313; c=relaxed/simple;
	bh=rJ8IoloP2mS8Aj9KDphh3mE3ooKXuct3r7Tjf9+L1aQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dog53dbbeDqmplzPomJ3hQpVxjraeANwQOaxlwDssT0McAbEnKOiQfiN+eA1YbAjYtIhjhEmTrIBQ7VUzsMAYI7m6e97QAifSvBTy86c7gcTJf1UI/lz6wuxSaTguDqjmhuJhWsH5x3hpe75jNJKlFVmRHfGnF5pqoGvYWb+t40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gGki0PWz; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764207307;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b6AFu0tluctYDpxhADpmghqFz338Jgmap++Fi9r6Ggs=;
	b=gGki0PWztDUomJ33glUMRuprhXI+yoRhmi1BO77qhRd02vsnuafANITePQRUKOA5LMF2b4
	mOxk+DlJRLdRnLVs+9ezIUYJDOGomkwbGKg4W4IASHZpl+M8YB9LIsUTRDUsMdTKMRGqrT
	L9prh8wa0DiFYV0nM0VyMDeEvuEG8Qk=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v3 06/16] KVM: selftests: Introduce struct kvm_mmu
Date: Thu, 27 Nov 2025 01:34:30 +0000
Message-ID: <20251127013440.3324671-7-yosry.ahmed@linux.dev>
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

In preparation for generalizing the virt mapping functions to work with
TDP page tables, introduce struct kvm_mmu. This struct currently only
holds the root GPA and number of page table levels. Parameterize virt
mapping functions by the kvm_mmu, and use the root GPA and page table
levels instead of hardcoding vm->pgd and vm->pgtable_levels.

There's a subtle change here, instead of checking that the parent
pointer is the address of the vm->pgd, check if the value pointed at by
the parent pointer is the root GPA (i.e. the value of vm->pgd in this
case). No change in behavior expected.

Opportunistically, switch the ordering of the checks in the assertion in
virt_get_pte(), as it makes more sense to check if the parent PTE is the
root (in which case, not a PTE) before checking the present flag.

vm->arch.mmu is dynamically allocated to avoid a circular dependency
chain if kvm_util_arch.h includes processor.h for the struct definition:
kvm_util_arch.h -> processor.h -> kvm_util.h -> kvm_util_arch.h

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 .../selftests/kvm/include/x86/kvm_util_arch.h |  4 ++
 .../selftests/kvm/include/x86/processor.h     |  8 ++-
 .../testing/selftests/kvm/lib/x86/processor.c | 61 +++++++++++++------
 3 files changed, 53 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h b/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
index 972bb1c4ab4c..d8808fa33faa 100644
--- a/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
+++ b/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
@@ -10,6 +10,8 @@
 
 extern bool is_forced_emulation_enabled;
 
+struct kvm_mmu;
+
 struct kvm_vm_arch {
 	vm_vaddr_t gdt;
 	vm_vaddr_t tss;
@@ -19,6 +21,8 @@ struct kvm_vm_arch {
 	uint64_t s_bit;
 	int sev_fd;
 	bool is_pt_protected;
+
+	struct kvm_mmu *mmu;
 };
 
 static inline bool __vm_arch_has_protected_memory(struct kvm_vm_arch *arch)
diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index c00c0fbe62cd..0c295097c714 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -1449,7 +1449,13 @@ enum pg_level {
 #define PG_SIZE_2M PG_LEVEL_SIZE(PG_LEVEL_2M)
 #define PG_SIZE_1G PG_LEVEL_SIZE(PG_LEVEL_1G)
 
-void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level);
+struct kvm_mmu {
+	uint64_t root_gpa;
+	int pgtable_levels;
+};
+
+void __virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, uint64_t vaddr,
+		   uint64_t paddr,  int level);
 void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 		    uint64_t nr_bytes, int level);
 
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index c14bf2b5f28f..871de49c35ee 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -156,6 +156,23 @@ bool kvm_is_tdp_enabled(void)
 		return get_kvm_amd_param_bool("npt");
 }
 
+static struct kvm_mmu *mmu_create(struct kvm_vm *vm,
+				  int pgtable_levels)
+{
+	struct kvm_mmu *mmu = calloc(1, sizeof(*mmu));
+
+	TEST_ASSERT(mmu, "-ENOMEM when allocating MMU");
+	mmu->root_gpa = vm_alloc_page_table(vm);
+	mmu->pgtable_levels = pgtable_levels;
+	return mmu;
+}
+
+static void mmu_init(struct kvm_vm *vm)
+{
+	vm->arch.mmu = mmu_create(vm, vm->pgtable_levels);
+	vm->pgd = vm->arch.mmu->root_gpa;
+}
+
 void virt_arch_pgd_alloc(struct kvm_vm *vm)
 {
 	TEST_ASSERT(vm->mode == VM_MODE_PXXVYY_4K,
@@ -163,19 +180,19 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
 
 	/* If needed, create the top-level page table. */
 	if (!vm->pgd_created) {
-		vm->pgd = vm_alloc_page_table(vm);
+		mmu_init(vm);
 		vm->pgd_created = true;
 	}
 }
 
-static void *virt_get_pte(struct kvm_vm *vm, uint64_t *parent_pte,
-			  uint64_t vaddr, int level)
+static void *virt_get_pte(struct kvm_vm *vm, struct kvm_mmu *mmu,
+			  uint64_t *parent_pte, uint64_t vaddr, int level)
 {
 	uint64_t pt_gpa = PTE_GET_PA(*parent_pte);
 	uint64_t *page_table = addr_gpa2hva(vm, pt_gpa);
 	int index = (vaddr >> PG_LEVEL_SHIFT(level)) & 0x1ffu;
 
-	TEST_ASSERT((*parent_pte & PTE_PRESENT_MASK) || parent_pte == &vm->pgd,
+	TEST_ASSERT((*parent_pte == mmu->root_gpa) || (*parent_pte & PTE_PRESENT_MASK),
 		    "Parent PTE (level %d) not PRESENT for gva: 0x%08lx",
 		    level + 1, vaddr);
 
@@ -183,13 +200,14 @@ static void *virt_get_pte(struct kvm_vm *vm, uint64_t *parent_pte,
 }
 
 static uint64_t *virt_create_upper_pte(struct kvm_vm *vm,
+				       struct kvm_mmu *mmu,
 				       uint64_t *parent_pte,
 				       uint64_t vaddr,
 				       uint64_t paddr,
 				       int current_level,
 				       int target_level)
 {
-	uint64_t *pte = virt_get_pte(vm, parent_pte, vaddr, current_level);
+	uint64_t *pte = virt_get_pte(vm, mmu, parent_pte, vaddr, current_level);
 
 	paddr = vm_untag_gpa(vm, paddr);
 
@@ -215,10 +233,11 @@ static uint64_t *virt_create_upper_pte(struct kvm_vm *vm,
 	return pte;
 }
 
-void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
+void __virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, uint64_t vaddr,
+		   uint64_t paddr, int level)
 {
 	const uint64_t pg_size = PG_LEVEL_SIZE(level);
-	uint64_t *pte = &vm->pgd;
+	uint64_t *pte = &mmu->root_gpa;
 	int current_level;
 
 	TEST_ASSERT(vm->mode == VM_MODE_PXXVYY_4K,
@@ -243,17 +262,17 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
 	 * Allocate upper level page tables, if not already present.  Return
 	 * early if a hugepage was created.
 	 */
-	for (current_level = vm->pgtable_levels;
+	for (current_level = mmu->pgtable_levels;
 	     current_level > PG_LEVEL_4K;
 	     current_level--) {
-		pte = virt_create_upper_pte(vm, pte, vaddr, paddr,
+		pte = virt_create_upper_pte(vm, mmu, pte, vaddr, paddr,
 					    current_level, level);
 		if (*pte & PTE_LARGE_MASK)
 			return;
 	}
 
 	/* Fill in page table entry. */
-	pte = virt_get_pte(vm, pte, vaddr, PG_LEVEL_4K);
+	pte = virt_get_pte(vm, mmu, pte, vaddr, PG_LEVEL_4K);
 	TEST_ASSERT(!(*pte & PTE_PRESENT_MASK),
 		    "PTE already present for 4k page at vaddr: 0x%lx", vaddr);
 	*pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK | (paddr & PHYSICAL_PAGE_MASK);
@@ -270,7 +289,7 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
 
 void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 {
-	__virt_pg_map(vm, vaddr, paddr, PG_LEVEL_4K);
+	__virt_pg_map(vm, vm->arch.mmu, vaddr, paddr, PG_LEVEL_4K);
 }
 
 void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
@@ -285,7 +304,7 @@ void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 		    nr_bytes, pg_size);
 
 	for (i = 0; i < nr_pages; i++) {
-		__virt_pg_map(vm, vaddr, paddr, level);
+		__virt_pg_map(vm, vm->arch.mmu, vaddr, paddr, level);
 		sparsebit_set_num(vm->vpages_mapped, vaddr >> vm->page_shift,
 				  nr_bytes / PAGE_SIZE);
 
@@ -294,7 +313,8 @@ void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 	}
 }
 
-static bool vm_is_target_pte(uint64_t *pte, int *level, int current_level)
+static bool vm_is_target_pte(struct kvm_mmu *mmu, uint64_t *pte,
+			     int *level, int current_level)
 {
 	if (*pte & PTE_LARGE_MASK) {
 		TEST_ASSERT(*level == PG_LEVEL_NONE ||
@@ -306,7 +326,9 @@ static bool vm_is_target_pte(uint64_t *pte, int *level, int current_level)
 	return *level == current_level;
 }
 
-static uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr,
+static uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm,
+					   struct kvm_mmu *mmu,
+					   uint64_t vaddr,
 					   int *level)
 {
 	int va_width = 12 + (vm->pgtable_levels) * 9;
@@ -335,19 +357,19 @@ static uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr,
 	for (current_level = vm->pgtable_levels;
 	     current_level > PG_LEVEL_4K;
 	     current_level--) {
-		pte = virt_get_pte(vm, pte, vaddr, current_level);
-		if (vm_is_target_pte(pte, level, current_level))
+		pte = virt_get_pte(vm, mmu, pte, vaddr, current_level);
+		if (vm_is_target_pte(mmu, pte, level, current_level))
 			return pte;
 	}
 
-	return virt_get_pte(vm, pte, vaddr, PG_LEVEL_4K);
+	return virt_get_pte(vm, mmu, pte, vaddr, PG_LEVEL_4K);
 }
 
 uint64_t *vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr)
 {
 	int level = PG_LEVEL_4K;
 
-	return __vm_get_page_table_entry(vm, vaddr, &level);
+	return __vm_get_page_table_entry(vm, vm->arch.mmu, vaddr, &level);
 }
 
 void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
@@ -497,7 +519,8 @@ static void kvm_seg_set_kernel_data_64bit(struct kvm_segment *segp)
 vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 {
 	int level = PG_LEVEL_NONE;
-	uint64_t *pte = __vm_get_page_table_entry(vm, gva, &level);
+	struct kvm_mmu *mmu = vm->arch.mmu;
+	uint64_t *pte = __vm_get_page_table_entry(vm, mmu, gva, &level);
 
 	TEST_ASSERT(*pte & PTE_PRESENT_MASK,
 		    "Leaf PTE not PRESENT for gva: 0x%08lx", gva);
-- 
2.52.0.158.g65b55ccf14-goog


