Return-Path: <kvm+bounces-66877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 603C5CEAD17
	for <lists+kvm@lfdr.de>; Wed, 31 Dec 2025 00:02:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 84B3E3009840
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 23:02:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 278782FD675;
	Tue, 30 Dec 2025 23:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VEaBHz0T"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E802E8B8B
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 23:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767135727; cv=none; b=knPkClh4gy1VmHBrFg4vsHdoTvy6jVX5KIAfgdzcTTK7007Nu4+Usd0NBu4IxXzcZpHwN2a6vCMaMFxNSwFM1eP6Kk0ewojJYjHblvJibbZei/vVf20PXEs3pzdfl+cspWMwaLl9b4QuayGq5HY2Ivfbj+3RimrNp2NbfCBh7HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767135727; c=relaxed/simple;
	bh=VBEZazNQmX47aR+zvVpMv3ul4jxDIkXc586G94mUMS8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bo1q94Q5QBWLYgg0E/je10Vnt9HRK5eGR7MvejgQLN2EPBa3W5mnqfDswEpRATgs4668y+SR1zOSE0TzaCPHqyqrwoePiYBwWDwZ5WHokQlcptzLl03NooQ0PGHBzv+R0sdIfVfijz+VMvSNrEVbae+V1OSFig5wIzXJKMgmWqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VEaBHz0T; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b6097ca315bso18943436a12.3
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 15:02:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767135723; x=1767740523; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+BOw+hIi1bRSqv3w3/oHSK6eg1GIdqsKODkrn0JtmRs=;
        b=VEaBHz0TKDiPvAatzM24RjuFb8+ezJRKF43ObSlg+xTXmqQfP+ADTggmKQt4cIYYxc
         3xvSC3C+y1tdXKVbxbJsvmBeksKpuK6LLEtqxYYvFATnmrvj4edvyvIrbgt2uB1emVr7
         SuuJ8+SM4glkoDTu+WFi9Yy0kcOQOP+z9HO+ku+2kgvH0ZurYa0dagz3P2T4jZ8ScqXw
         FsA8d3KgoYnZdjAjmoByZ18KDOTIb18llFxCX+763wgdWZbIFelfqREZgkT3bpJ5//Tv
         28TmpJ/mJLLOBf/IeJUzspTPPqkGFQTsZbvlftHfriX3f0+0s/MBzuOVxCL/lf8fEhsM
         m81w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767135723; x=1767740523;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+BOw+hIi1bRSqv3w3/oHSK6eg1GIdqsKODkrn0JtmRs=;
        b=vclH62hSK4PSD66gtghO0ZQccjcTXZWZmH2Lg8Z9vXEjX754vKi0795d528PiYYc9+
         4QatNGQ8oq27kljfBYM3aCoKANxQwS1Stv9lXhZYlxjNefiQNTwau7FuzSMBmEzUW41+
         N5Xj7NzT73IfUEsj5D4Enk46WtQayVmD9Hla9y612Rb1fcH4H5OYLzjHxDiYmrh6lIcW
         8UO8AHxDewUhFbthKXDrw0LBZmIY0ng/xWBk9hvQwB7MzBqu/EX8AMSUpN1C7RCS0N0+
         YnLVMdnpmZNp2Q7g1/Rkc2OjLYAX37TaqcugF/MEzUwVpjwM+C30YaPLQPY1HNf/3+fv
         l6/g==
X-Gm-Message-State: AOJu0YyiytpebkUaNKSERDH3BRDSt4BCwC2ZTduCdQBK0JtthaKKw9lq
	cNNaO8MsbTdwlab72+/a4K+UNQrQqCqgK3DxApkYwywbV2spkL1S6ztBJTGA09xyDOcGiX6MBit
	+mIvyAg==
X-Google-Smtp-Source: AGHT+IEys4f3BVFYDoa/02B3caxExHnUYhMZBOGJg0+IEIIzrst7dQ9T8MyTlUZ9TvEhnr4W7Sf0wNW88Eg=
X-Received: from pjbpc3.prod.google.com ([2002:a17:90b:3b83:b0:341:88c5:20ac])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:33a2:b0:35e:824a:dc57
 with SMTP id adf61e73a8af0-376a94cb6femr37621114637.37.1767135723117; Tue, 30
 Dec 2025 15:02:03 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Dec 2025 15:01:35 -0800
In-Reply-To: <20251230230150.4150236-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251230230150.4150236-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251230230150.4150236-7-seanjc@google.com>
Subject: [PATCH v4 06/21] KVM: selftests: Add "struct kvm_mmu" to track a
 given MMU instance
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

Add a "struct kvm_mmu" to track a given MMU instance, e.g. a VM's stage-1
MMU versus a VM's stage-2 MMU, so that x86 can share MMU functionality for
both stage-1 and stage-2 MMUs, without creating the potential for subtle
bugs, e.g. due to consuming on vm->pgtable_levels when operating a stage-2
MMU.

Encapsulate the existing de facto MMU in "struct kvm_vm", e.g instead of
burying the MMU details in "struct kvm_vm_arch", to avoid more #ifdefs in
____vm_create(), and in the hopes that other architectures can utilize the
formalized MMU structure if/when they too support stage-2 page tables.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  | 11 ++++--
 .../selftests/kvm/lib/arm64/processor.c       | 38 +++++++++----------
 tools/testing/selftests/kvm/lib/kvm_util.c    | 28 +++++++-------
 .../selftests/kvm/lib/loongarch/processor.c   | 28 +++++++-------
 .../selftests/kvm/lib/riscv/processor.c       | 31 +++++++--------
 .../selftests/kvm/lib/s390/processor.c        | 16 ++++----
 .../testing/selftests/kvm/lib/x86/processor.c | 28 +++++++-------
 .../kvm/x86/vmx_nested_la57_state_test.c      |  2 +-
 8 files changed, 94 insertions(+), 88 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 81f4355ff28a..39558c05c0bf 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -88,12 +88,17 @@ enum kvm_mem_region_type {
 	NR_MEM_REGIONS,
 };
 
+struct kvm_mmu {
+	bool pgd_created;
+	uint64_t pgd;
+	int pgtable_levels;
+};
+
 struct kvm_vm {
 	int mode;
 	unsigned long type;
 	int kvm_fd;
 	int fd;
-	unsigned int pgtable_levels;
 	unsigned int page_size;
 	unsigned int page_shift;
 	unsigned int pa_bits;
@@ -104,13 +109,13 @@ struct kvm_vm {
 	struct sparsebit *vpages_valid;
 	struct sparsebit *vpages_mapped;
 	bool has_irqchip;
-	bool pgd_created;
 	vm_paddr_t ucall_mmio_addr;
-	vm_paddr_t pgd;
 	vm_vaddr_t handlers;
 	uint32_t dirty_ring_size;
 	uint64_t gpa_tag_mask;
 
+	struct kvm_mmu mmu;
+
 	struct kvm_vm_arch arch;
 
 	struct kvm_binary_stats stats;
diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
index d46e4b13b92c..c40f59d48311 100644
--- a/tools/testing/selftests/kvm/lib/arm64/processor.c
+++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
@@ -28,7 +28,7 @@ static uint64_t page_align(struct kvm_vm *vm, uint64_t v)
 
 static uint64_t pgd_index(struct kvm_vm *vm, vm_vaddr_t gva)
 {
-	unsigned int shift = (vm->pgtable_levels - 1) * (vm->page_shift - 3) + vm->page_shift;
+	unsigned int shift = (vm->mmu.pgtable_levels - 1) * (vm->page_shift - 3) + vm->page_shift;
 	uint64_t mask = (1UL << (vm->va_bits - shift)) - 1;
 
 	return (gva >> shift) & mask;
@@ -39,7 +39,7 @@ static uint64_t pud_index(struct kvm_vm *vm, vm_vaddr_t gva)
 	unsigned int shift = 2 * (vm->page_shift - 3) + vm->page_shift;
 	uint64_t mask = (1UL << (vm->page_shift - 3)) - 1;
 
-	TEST_ASSERT(vm->pgtable_levels == 4,
+	TEST_ASSERT(vm->mmu.pgtable_levels == 4,
 		"Mode %d does not have 4 page table levels", vm->mode);
 
 	return (gva >> shift) & mask;
@@ -50,7 +50,7 @@ static uint64_t pmd_index(struct kvm_vm *vm, vm_vaddr_t gva)
 	unsigned int shift = (vm->page_shift - 3) + vm->page_shift;
 	uint64_t mask = (1UL << (vm->page_shift - 3)) - 1;
 
-	TEST_ASSERT(vm->pgtable_levels >= 3,
+	TEST_ASSERT(vm->mmu.pgtable_levels >= 3,
 		"Mode %d does not have >= 3 page table levels", vm->mode);
 
 	return (gva >> shift) & mask;
@@ -104,7 +104,7 @@ static uint64_t pte_addr(struct kvm_vm *vm, uint64_t pte)
 
 static uint64_t ptrs_per_pgd(struct kvm_vm *vm)
 {
-	unsigned int shift = (vm->pgtable_levels - 1) * (vm->page_shift - 3) + vm->page_shift;
+	unsigned int shift = (vm->mmu.pgtable_levels - 1) * (vm->page_shift - 3) + vm->page_shift;
 	return 1 << (vm->va_bits - shift);
 }
 
@@ -117,13 +117,13 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
 {
 	size_t nr_pages = page_align(vm, ptrs_per_pgd(vm) * 8) / vm->page_size;
 
-	if (vm->pgd_created)
+	if (vm->mmu.pgd_created)
 		return;
 
-	vm->pgd = vm_phy_pages_alloc(vm, nr_pages,
-				     KVM_GUEST_PAGE_TABLE_MIN_PADDR,
-				     vm->memslots[MEM_REGION_PT]);
-	vm->pgd_created = true;
+	vm->mmu.pgd = vm_phy_pages_alloc(vm, nr_pages,
+					 KVM_GUEST_PAGE_TABLE_MIN_PADDR,
+					 vm->memslots[MEM_REGION_PT]);
+	vm->mmu.pgd_created = true;
 }
 
 static void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
@@ -147,12 +147,12 @@ static void _virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 		"  paddr: 0x%lx vm->max_gfn: 0x%lx vm->page_size: 0x%x",
 		paddr, vm->max_gfn, vm->page_size);
 
-	ptep = addr_gpa2hva(vm, vm->pgd) + pgd_index(vm, vaddr) * 8;
+	ptep = addr_gpa2hva(vm, vm->mmu.pgd) + pgd_index(vm, vaddr) * 8;
 	if (!*ptep)
 		*ptep = addr_pte(vm, vm_alloc_page_table(vm),
 				 PGD_TYPE_TABLE | PTE_VALID);
 
-	switch (vm->pgtable_levels) {
+	switch (vm->mmu.pgtable_levels) {
 	case 4:
 		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pud_index(vm, vaddr) * 8;
 		if (!*ptep)
@@ -190,16 +190,16 @@ uint64_t *virt_get_pte_hva_at_level(struct kvm_vm *vm, vm_vaddr_t gva, int level
 {
 	uint64_t *ptep;
 
-	if (!vm->pgd_created)
+	if (!vm->mmu.pgd_created)
 		goto unmapped_gva;
 
-	ptep = addr_gpa2hva(vm, vm->pgd) + pgd_index(vm, gva) * 8;
+	ptep = addr_gpa2hva(vm, vm->mmu.pgd) + pgd_index(vm, gva) * 8;
 	if (!ptep)
 		goto unmapped_gva;
 	if (level == 0)
 		return ptep;
 
-	switch (vm->pgtable_levels) {
+	switch (vm->mmu.pgtable_levels) {
 	case 4:
 		ptep = addr_gpa2hva(vm, pte_addr(vm, *ptep)) + pud_index(vm, gva) * 8;
 		if (!ptep)
@@ -263,13 +263,13 @@ static void pte_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent, uint64_t p
 
 void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 {
-	int level = 4 - (vm->pgtable_levels - 1);
+	int level = 4 - (vm->mmu.pgtable_levels - 1);
 	uint64_t pgd, *ptep;
 
-	if (!vm->pgd_created)
+	if (!vm->mmu.pgd_created)
 		return;
 
-	for (pgd = vm->pgd; pgd < vm->pgd + ptrs_per_pgd(vm) * 8; pgd += 8) {
+	for (pgd = vm->mmu.pgd; pgd < vm->mmu.pgd + ptrs_per_pgd(vm) * 8; pgd += 8) {
 		ptep = addr_gpa2hva(vm, pgd);
 		if (!*ptep)
 			continue;
@@ -350,7 +350,7 @@ void aarch64_vcpu_setup(struct kvm_vcpu *vcpu, struct kvm_vcpu_init *init)
 		TEST_FAIL("Unknown guest mode, mode: 0x%x", vm->mode);
 	}
 
-	ttbr0_el1 = vm->pgd & GENMASK(47, vm->page_shift);
+	ttbr0_el1 = vm->mmu.pgd & GENMASK(47, vm->page_shift);
 
 	/* Configure output size */
 	switch (vm->mode) {
@@ -358,7 +358,7 @@ void aarch64_vcpu_setup(struct kvm_vcpu *vcpu, struct kvm_vcpu_init *init)
 	case VM_MODE_P52V48_16K:
 	case VM_MODE_P52V48_64K:
 		tcr_el1 |= TCR_IPS_52_BITS;
-		ttbr0_el1 |= FIELD_GET(GENMASK(51, 48), vm->pgd) << 2;
+		ttbr0_el1 |= FIELD_GET(GENMASK(51, 48), vm->mmu.pgd) << 2;
 		break;
 	case VM_MODE_P48V48_4K:
 	case VM_MODE_P48V48_16K:
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 8279b6ced8d2..65752daeed90 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -281,34 +281,34 @@ struct kvm_vm *____vm_create(struct vm_shape shape)
 	/* Setup mode specific traits. */
 	switch (vm->mode) {
 	case VM_MODE_P52V48_4K:
-		vm->pgtable_levels = 4;
+		vm->mmu.pgtable_levels = 4;
 		break;
 	case VM_MODE_P52V48_64K:
-		vm->pgtable_levels = 3;
+		vm->mmu.pgtable_levels = 3;
 		break;
 	case VM_MODE_P48V48_4K:
-		vm->pgtable_levels = 4;
+		vm->mmu.pgtable_levels = 4;
 		break;
 	case VM_MODE_P48V48_64K:
-		vm->pgtable_levels = 3;
+		vm->mmu.pgtable_levels = 3;
 		break;
 	case VM_MODE_P40V48_4K:
 	case VM_MODE_P36V48_4K:
-		vm->pgtable_levels = 4;
+		vm->mmu.pgtable_levels = 4;
 		break;
 	case VM_MODE_P40V48_64K:
 	case VM_MODE_P36V48_64K:
-		vm->pgtable_levels = 3;
+		vm->mmu.pgtable_levels = 3;
 		break;
 	case VM_MODE_P52V48_16K:
 	case VM_MODE_P48V48_16K:
 	case VM_MODE_P40V48_16K:
 	case VM_MODE_P36V48_16K:
-		vm->pgtable_levels = 4;
+		vm->mmu.pgtable_levels = 4;
 		break;
 	case VM_MODE_P47V47_16K:
 	case VM_MODE_P36V47_16K:
-		vm->pgtable_levels = 3;
+		vm->mmu.pgtable_levels = 3;
 		break;
 	case VM_MODE_PXXVYY_4K:
 #ifdef __x86_64__
@@ -321,22 +321,22 @@ struct kvm_vm *____vm_create(struct vm_shape shape)
 			 vm->va_bits);
 
 		if (vm->va_bits == 57) {
-			vm->pgtable_levels = 5;
+			vm->mmu.pgtable_levels = 5;
 		} else {
 			TEST_ASSERT(vm->va_bits == 48,
 				    "Unexpected guest virtual address width: %d",
 				    vm->va_bits);
-			vm->pgtable_levels = 4;
+			vm->mmu.pgtable_levels = 4;
 		}
 #else
 		TEST_FAIL("VM_MODE_PXXVYY_4K not supported on non-x86 platforms");
 #endif
 		break;
 	case VM_MODE_P47V64_4K:
-		vm->pgtable_levels = 5;
+		vm->mmu.pgtable_levels = 5;
 		break;
 	case VM_MODE_P44V64_4K:
-		vm->pgtable_levels = 5;
+		vm->mmu.pgtable_levels = 5;
 		break;
 	default:
 		TEST_FAIL("Unknown guest mode: 0x%x", vm->mode);
@@ -1956,8 +1956,8 @@ void vm_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 	fprintf(stream, "%*sMapped Virtual Pages:\n", indent, "");
 	sparsebit_dump(stream, vm->vpages_mapped, indent + 2);
 	fprintf(stream, "%*spgd_created: %u\n", indent, "",
-		vm->pgd_created);
-	if (vm->pgd_created) {
+		vm->mmu.pgd_created);
+	if (vm->mmu.pgd_created) {
 		fprintf(stream, "%*sVirtual Translation Tables:\n",
 			indent + 2, "");
 		virt_dump(stream, vm, indent + 4);
diff --git a/tools/testing/selftests/kvm/lib/loongarch/processor.c b/tools/testing/selftests/kvm/lib/loongarch/processor.c
index 07c103369ddb..17aa55a2047a 100644
--- a/tools/testing/selftests/kvm/lib/loongarch/processor.c
+++ b/tools/testing/selftests/kvm/lib/loongarch/processor.c
@@ -50,11 +50,11 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
 	int i;
 	vm_paddr_t child, table;
 
-	if (vm->pgd_created)
+	if (vm->mmu.pgd_created)
 		return;
 
 	child = table = 0;
-	for (i = 0; i < vm->pgtable_levels; i++) {
+	for (i = 0; i < vm->mmu.pgtable_levels; i++) {
 		invalid_pgtable[i] = child;
 		table = vm_phy_page_alloc(vm, LOONGARCH_PAGE_TABLE_PHYS_MIN,
 				vm->memslots[MEM_REGION_PT]);
@@ -62,8 +62,8 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
 		virt_set_pgtable(vm, table, child);
 		child = table;
 	}
-	vm->pgd = table;
-	vm->pgd_created = true;
+	vm->mmu.pgd = table;
+	vm->mmu.pgd_created = true;
 }
 
 static int virt_pte_none(uint64_t *ptep, int level)
@@ -77,11 +77,11 @@ static uint64_t *virt_populate_pte(struct kvm_vm *vm, vm_vaddr_t gva, int alloc)
 	uint64_t *ptep;
 	vm_paddr_t child;
 
-	if (!vm->pgd_created)
+	if (!vm->mmu.pgd_created)
 		goto unmapped_gva;
 
-	child = vm->pgd;
-	level = vm->pgtable_levels - 1;
+	child = vm->mmu.pgd;
+	level = vm->mmu.pgtable_levels - 1;
 	while (level > 0) {
 		ptep = addr_gpa2hva(vm, child) + virt_pte_index(vm, gva, level) * 8;
 		if (virt_pte_none(ptep, level)) {
@@ -161,11 +161,11 @@ void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 {
 	int level;
 
-	if (!vm->pgd_created)
+	if (!vm->mmu.pgd_created)
 		return;
 
-	level = vm->pgtable_levels - 1;
-	pte_dump(stream, vm, indent, vm->pgd, level);
+	level = vm->mmu.pgtable_levels - 1;
+	pte_dump(stream, vm, indent, vm->mmu.pgd, level);
 }
 
 void vcpu_arch_dump(FILE *stream, struct kvm_vcpu *vcpu, uint8_t indent)
@@ -297,7 +297,7 @@ static void loongarch_vcpu_setup(struct kvm_vcpu *vcpu)
 
 	width = vm->page_shift - 3;
 
-	switch (vm->pgtable_levels) {
+	switch (vm->mmu.pgtable_levels) {
 	case 4:
 		/* pud page shift and width */
 		val = (vm->page_shift + width * 2) << 20 | (width << 25);
@@ -309,15 +309,15 @@ static void loongarch_vcpu_setup(struct kvm_vcpu *vcpu)
 		val |= vm->page_shift | width << 5;
 		break;
 	default:
-		TEST_FAIL("Got %u page table levels, expected 3 or 4", vm->pgtable_levels);
+		TEST_FAIL("Got %u page table levels, expected 3 or 4", vm->mmu.pgtable_levels);
 	}
 
 	loongarch_set_csr(vcpu, LOONGARCH_CSR_PWCTL0, val);
 
 	/* PGD page shift and width */
-	val = (vm->page_shift + width * (vm->pgtable_levels - 1)) | width << 6;
+	val = (vm->page_shift + width * (vm->mmu.pgtable_levels - 1)) | width << 6;
 	loongarch_set_csr(vcpu, LOONGARCH_CSR_PWCTL1, val);
-	loongarch_set_csr(vcpu, LOONGARCH_CSR_PGDL, vm->pgd);
+	loongarch_set_csr(vcpu, LOONGARCH_CSR_PGDL, vm->mmu.pgd);
 
 	/*
 	 * Refill exception runs on real mode
diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
index 2eac7d4b59e9..e6ec7c224fc3 100644
--- a/tools/testing/selftests/kvm/lib/riscv/processor.c
+++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
@@ -60,7 +60,7 @@ static uint64_t pte_index(struct kvm_vm *vm, vm_vaddr_t gva, int level)
 {
 	TEST_ASSERT(level > -1,
 		"Negative page table level (%d) not possible", level);
-	TEST_ASSERT(level < vm->pgtable_levels,
+	TEST_ASSERT(level < vm->mmu.pgtable_levels,
 		"Invalid page table level (%d)", level);
 
 	return (gva & pte_index_mask[level]) >> pte_index_shift[level];
@@ -70,19 +70,19 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
 {
 	size_t nr_pages = page_align(vm, ptrs_per_pte(vm) * 8) / vm->page_size;
 
-	if (vm->pgd_created)
+	if (vm->mmu.pgd_created)
 		return;
 
-	vm->pgd = vm_phy_pages_alloc(vm, nr_pages,
-				     KVM_GUEST_PAGE_TABLE_MIN_PADDR,
-				     vm->memslots[MEM_REGION_PT]);
-	vm->pgd_created = true;
+	vm->mmu.pgd = vm_phy_pages_alloc(vm, nr_pages,
+					 KVM_GUEST_PAGE_TABLE_MIN_PADDR,
+					 vm->memslots[MEM_REGION_PT]);
+	vm->mmu.pgd_created = true;
 }
 
 void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 {
 	uint64_t *ptep, next_ppn;
-	int level = vm->pgtable_levels - 1;
+	int level = vm->mmu.pgtable_levels - 1;
 
 	TEST_ASSERT((vaddr % vm->page_size) == 0,
 		"Virtual address not on page boundary,\n"
@@ -98,7 +98,7 @@ void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 		"  paddr: 0x%lx vm->max_gfn: 0x%lx vm->page_size: 0x%x",
 		paddr, vm->max_gfn, vm->page_size);
 
-	ptep = addr_gpa2hva(vm, vm->pgd) + pte_index(vm, vaddr, level) * 8;
+	ptep = addr_gpa2hva(vm, vm->mmu.pgd) + pte_index(vm, vaddr, level) * 8;
 	if (!*ptep) {
 		next_ppn = vm_alloc_page_table(vm) >> PGTBL_PAGE_SIZE_SHIFT;
 		*ptep = (next_ppn << PGTBL_PTE_ADDR_SHIFT) |
@@ -126,12 +126,12 @@ void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 {
 	uint64_t *ptep;
-	int level = vm->pgtable_levels - 1;
+	int level = vm->mmu.pgtable_levels - 1;
 
-	if (!vm->pgd_created)
+	if (!vm->mmu.pgd_created)
 		goto unmapped_gva;
 
-	ptep = addr_gpa2hva(vm, vm->pgd) + pte_index(vm, gva, level) * 8;
+	ptep = addr_gpa2hva(vm, vm->mmu.pgd) + pte_index(vm, gva, level) * 8;
 	if (!ptep)
 		goto unmapped_gva;
 	level--;
@@ -176,13 +176,14 @@ static void pte_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent,
 
 void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 {
-	int level = vm->pgtable_levels - 1;
+	struct kvm_mmu *mmu = &vm->mmu;
+	int level = mmu->pgtable_levels - 1;
 	uint64_t pgd, *ptep;
 
-	if (!vm->pgd_created)
+	if (!mmu->pgd_created)
 		return;
 
-	for (pgd = vm->pgd; pgd < vm->pgd + ptrs_per_pte(vm) * 8; pgd += 8) {
+	for (pgd = mmu->pgd; pgd < mmu->pgd + ptrs_per_pte(vm) * 8; pgd += 8) {
 		ptep = addr_gpa2hva(vm, pgd);
 		if (!*ptep)
 			continue;
@@ -211,7 +212,7 @@ void riscv_vcpu_mmu_setup(struct kvm_vcpu *vcpu)
 		TEST_FAIL("Unknown guest mode, mode: 0x%x", vm->mode);
 	}
 
-	satp = (vm->pgd >> PGTBL_PAGE_SIZE_SHIFT) & SATP_PPN;
+	satp = (vm->mmu.pgd >> PGTBL_PAGE_SIZE_SHIFT) & SATP_PPN;
 	satp |= SATP_MODE_48;
 
 	vcpu_set_reg(vcpu, RISCV_GENERAL_CSR_REG(satp), satp);
diff --git a/tools/testing/selftests/kvm/lib/s390/processor.c b/tools/testing/selftests/kvm/lib/s390/processor.c
index 8ceeb17c819a..6a9a660413a7 100644
--- a/tools/testing/selftests/kvm/lib/s390/processor.c
+++ b/tools/testing/selftests/kvm/lib/s390/processor.c
@@ -17,7 +17,7 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
 	TEST_ASSERT(vm->page_size == PAGE_SIZE, "Unsupported page size: 0x%x",
 		    vm->page_size);
 
-	if (vm->pgd_created)
+	if (vm->mmu.pgd_created)
 		return;
 
 	paddr = vm_phy_pages_alloc(vm, PAGES_PER_REGION,
@@ -25,8 +25,8 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
 				   vm->memslots[MEM_REGION_PT]);
 	memset(addr_gpa2hva(vm, paddr), 0xff, PAGES_PER_REGION * vm->page_size);
 
-	vm->pgd = paddr;
-	vm->pgd_created = true;
+	vm->mmu.pgd = paddr;
+	vm->mmu.pgd_created = true;
 }
 
 /*
@@ -70,7 +70,7 @@ void virt_arch_pg_map(struct kvm_vm *vm, uint64_t gva, uint64_t gpa)
 		gva, vm->max_gfn, vm->page_size);
 
 	/* Walk through region and segment tables */
-	entry = addr_gpa2hva(vm, vm->pgd);
+	entry = addr_gpa2hva(vm, vm->mmu.pgd);
 	for (ri = 1; ri <= 4; ri++) {
 		idx = (gva >> (64 - 11 * ri)) & 0x7ffu;
 		if (entry[idx] & REGION_ENTRY_INVALID)
@@ -94,7 +94,7 @@ vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 	TEST_ASSERT(vm->page_size == PAGE_SIZE, "Unsupported page size: 0x%x",
 		    vm->page_size);
 
-	entry = addr_gpa2hva(vm, vm->pgd);
+	entry = addr_gpa2hva(vm, vm->mmu.pgd);
 	for (ri = 1; ri <= 4; ri++) {
 		idx = (gva >> (64 - 11 * ri)) & 0x7ffu;
 		TEST_ASSERT(!(entry[idx] & REGION_ENTRY_INVALID),
@@ -149,10 +149,10 @@ static void virt_dump_region(FILE *stream, struct kvm_vm *vm, uint8_t indent,
 
 void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 {
-	if (!vm->pgd_created)
+	if (!vm->mmu.pgd_created)
 		return;
 
-	virt_dump_region(stream, vm, indent, vm->pgd);
+	virt_dump_region(stream, vm, indent, vm->mmu.pgd);
 }
 
 void vcpu_arch_set_entry_point(struct kvm_vcpu *vcpu, void *guest_code)
@@ -184,7 +184,7 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
 
 	vcpu_sregs_get(vcpu, &sregs);
 	sregs.crs[0] |= 0x00040000;		/* Enable floating point regs */
-	sregs.crs[1] = vm->pgd | 0xf;		/* Primary region table */
+	sregs.crs[1] = vm->mmu.pgd | 0xf;	/* Primary region table */
 	vcpu_sregs_set(vcpu, &sregs);
 
 	vcpu->run->psw_mask = 0x0400000180000000ULL;  /* DAT enabled + 64 bit mode */
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index c14bf2b5f28f..f027f86d1535 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -162,9 +162,9 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
 		    "Unknown or unsupported guest mode: 0x%x", vm->mode);
 
 	/* If needed, create the top-level page table. */
-	if (!vm->pgd_created) {
-		vm->pgd = vm_alloc_page_table(vm);
-		vm->pgd_created = true;
+	if (!vm->mmu.pgd_created) {
+		vm->mmu.pgd = vm_alloc_page_table(vm);
+		vm->mmu.pgd_created = true;
 	}
 }
 
@@ -175,7 +175,7 @@ static void *virt_get_pte(struct kvm_vm *vm, uint64_t *parent_pte,
 	uint64_t *page_table = addr_gpa2hva(vm, pt_gpa);
 	int index = (vaddr >> PG_LEVEL_SHIFT(level)) & 0x1ffu;
 
-	TEST_ASSERT((*parent_pte & PTE_PRESENT_MASK) || parent_pte == &vm->pgd,
+	TEST_ASSERT((*parent_pte & PTE_PRESENT_MASK) || parent_pte == &vm->mmu.pgd,
 		    "Parent PTE (level %d) not PRESENT for gva: 0x%08lx",
 		    level + 1, vaddr);
 
@@ -218,7 +218,7 @@ static uint64_t *virt_create_upper_pte(struct kvm_vm *vm,
 void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
 {
 	const uint64_t pg_size = PG_LEVEL_SIZE(level);
-	uint64_t *pte = &vm->pgd;
+	uint64_t *pte = &vm->mmu.pgd;
 	int current_level;
 
 	TEST_ASSERT(vm->mode == VM_MODE_PXXVYY_4K,
@@ -243,7 +243,7 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
 	 * Allocate upper level page tables, if not already present.  Return
 	 * early if a hugepage was created.
 	 */
-	for (current_level = vm->pgtable_levels;
+	for (current_level = vm->mmu.pgtable_levels;
 	     current_level > PG_LEVEL_4K;
 	     current_level--) {
 		pte = virt_create_upper_pte(vm, pte, vaddr, paddr,
@@ -309,14 +309,14 @@ static bool vm_is_target_pte(uint64_t *pte, int *level, int current_level)
 static uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr,
 					   int *level)
 {
-	int va_width = 12 + (vm->pgtable_levels) * 9;
-	uint64_t *pte = &vm->pgd;
+	int va_width = 12 + (vm->mmu.pgtable_levels) * 9;
+	uint64_t *pte = &vm->mmu.pgd;
 	int current_level;
 
 	TEST_ASSERT(!vm->arch.is_pt_protected,
 		    "Walking page tables of protected guests is impossible");
 
-	TEST_ASSERT(*level >= PG_LEVEL_NONE && *level <= vm->pgtable_levels,
+	TEST_ASSERT(*level >= PG_LEVEL_NONE && *level <= vm->mmu.pgtable_levels,
 		    "Invalid PG_LEVEL_* '%d'", *level);
 
 	TEST_ASSERT(vm->mode == VM_MODE_PXXVYY_4K,
@@ -332,7 +332,7 @@ static uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr,
 		    (((int64_t)vaddr << (64 - va_width) >> (64 - va_width))),
 		    "Canonical check failed.  The virtual address is invalid.");
 
-	for (current_level = vm->pgtable_levels;
+	for (current_level = vm->mmu.pgtable_levels;
 	     current_level > PG_LEVEL_4K;
 	     current_level--) {
 		pte = virt_get_pte(vm, pte, vaddr, current_level);
@@ -357,7 +357,7 @@ void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 	uint64_t *pde, *pde_start;
 	uint64_t *pte, *pte_start;
 
-	if (!vm->pgd_created)
+	if (!vm->mmu.pgd_created)
 		return;
 
 	fprintf(stream, "%*s                                          "
@@ -365,7 +365,7 @@ void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 	fprintf(stream, "%*s      index hvaddr         gpaddr         "
 		"addr         w exec dirty\n",
 		indent, "");
-	pml4e_start = (uint64_t *) addr_gpa2hva(vm, vm->pgd);
+	pml4e_start = (uint64_t *) addr_gpa2hva(vm, vm->mmu.pgd);
 	for (uint16_t n1 = 0; n1 <= 0x1ffu; n1++) {
 		pml4e = &pml4e_start[n1];
 		if (!(*pml4e & PTE_PRESENT_MASK))
@@ -538,7 +538,7 @@ static void vcpu_init_sregs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 	sregs.cr4 |= X86_CR4_PAE | X86_CR4_OSFXSR;
 	if (kvm_cpu_has(X86_FEATURE_XSAVE))
 		sregs.cr4 |= X86_CR4_OSXSAVE;
-	if (vm->pgtable_levels == 5)
+	if (vm->mmu.pgtable_levels == 5)
 		sregs.cr4 |= X86_CR4_LA57;
 	sregs.efer |= (EFER_LME | EFER_LMA | EFER_NX);
 
@@ -549,7 +549,7 @@ static void vcpu_init_sregs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 	kvm_seg_set_kernel_data_64bit(&sregs.gs);
 	kvm_seg_set_tss_64bit(vm->arch.tss, &sregs.tr);
 
-	sregs.cr3 = vm->pgd;
+	sregs.cr3 = vm->mmu.pgd;
 	vcpu_sregs_set(vcpu, &sregs);
 }
 
diff --git a/tools/testing/selftests/kvm/x86/vmx_nested_la57_state_test.c b/tools/testing/selftests/kvm/x86/vmx_nested_la57_state_test.c
index cf1d2d1f2a8f..915c42001dba 100644
--- a/tools/testing/selftests/kvm/x86/vmx_nested_la57_state_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_nested_la57_state_test.c
@@ -90,7 +90,7 @@ int main(int argc, char *argv[])
 	 * L1 needs to read its own PML5 table to set up L2. Identity map
 	 * the PML5 table to facilitate this.
 	 */
-	virt_map(vm, vm->pgd, vm->pgd, 1);
+	virt_map(vm, vm->mmu.pgd, vm->mmu.pgd, 1);
 
 	vcpu_alloc_vmx(vm, &vmx_pages_gva);
 	vcpu_args_set(vcpu, 1, vmx_pages_gva);
-- 
2.52.0.351.gbe84eed79e-goog


