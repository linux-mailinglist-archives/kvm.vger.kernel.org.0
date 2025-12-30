Return-Path: <kvm+bounces-66878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A4B7BCEAD2F
	for <lists+kvm@lfdr.de>; Wed, 31 Dec 2025 00:04:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 55C12300F594
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 23:03:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B7552E62CE;
	Tue, 30 Dec 2025 23:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="huXxvwEX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927D62F28FF
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 23:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767135728; cv=none; b=BspZvApryM5L7UzkwqMU+QK1l3/e9PPK5PaLbwL1zPiUHxE1KzEtV6Sv56tIaje1Juc05fZeie4xUC3FT0M0JXjKuK8Bn3xEOGu6vzUi/z/33sebvqBVj17USYv7WTKsszSxiGAxItAshdRBoNFfDe72y3pUlrXPylTzsgyt1zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767135728; c=relaxed/simple;
	bh=ZU8xlAMH6mZxvqsPzFpIFF9VcGo1De1VYXH4GsE/Stk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Oa6WT6CgTN2bV1a2lvBrSbLl6SmKPki356SdNBcFdnyiicXBuepiU3kKebK1oGiRf9l+smUJ7Wn2RZorRCJvTWefzgCSAwf9bxDWsSm+ebe2YZplTB695+DomVVtRezNNaW33Mqj04hGudS1OBOVWQZuYrj1NhsOge4MpJil+qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=huXxvwEX; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34e5a9de94bso22057013a91.0
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 15:02:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767135725; x=1767740525; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=5Cc6wkm6hIGFSfttAC+mfZ95Ec3DVPFhFOuj3x7H3nk=;
        b=huXxvwEXGo4vJUxgPlhDhMnBY+++5KZy/uPIqOO4fRsT6a4MDayLLol2WYB2/+foeV
         eRvf8oPyYZbgXUTzVVDM9fK/+M/rRqD3Ott9kygbjZfKPzrSeicFvkk9znJFfnoQd2aq
         7Jd8LzrLDIU6kiUm/gnmDUSlb8CHIVKBvVi+vsrU0yvqNpiO79TnEyTYg648X85G/VGe
         R7SNwgAMj5MbTGJzs2NYWui2Uc/7VCeJ6L3nbMz5UT0Xe0pP06yJPXj1wcc7BtnFLghj
         XzWsNgzvRH9Mmb6tYaeGzCmzFoPzXNXjGu0BwQge6V1LpnZfXgnHV3hmUmkspUonLBx0
         jFlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767135725; x=1767740525;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5Cc6wkm6hIGFSfttAC+mfZ95Ec3DVPFhFOuj3x7H3nk=;
        b=RxAeJTOvURBfX0i43kEbAYYSna2FnpcVw6dG/fhAxqPWSV3EsUMn9HQxWnlx33Afua
         mK3TP//keOnwpTYZDu8uK0HRdOQ+dLoCMWvZkVarJfOX/w0xVlAJKYEZyNX4sNKZ1BhR
         o3XAqv25z/FGYAycZigMbKUN96iW3wVlVAy+o5gr8sxXPHX5E6SJ9I2/279NuKlL8aPG
         1c0sjoWKBInG5sxTvifaeZno5aXebsCvMr8ORs8aSlgS5bRhd+Kv3k4PR6vcUX2ofWv5
         GEmd2E8o0K1WeLRMQ/VWMuLnwVHArfvp6p/GxIjnb7Thbhfp3xH/LHws8KoD+q1EpHFe
         SRvQ==
X-Gm-Message-State: AOJu0YxMD7S9QgFdMwH+o18VxpvnAU1oZGrOeImt8msN9Q8+CfezTjIU
	C5Z06rxsiRvOzJ1rehaMlhU6l0SgViDoIeclM9X5Nl7E9Z0O+mRuv2Jvxnw4w0+ISfUy5YB5UCK
	vwo4p0A==
X-Google-Smtp-Source: AGHT+IEOOU/PO2opx5uUUNTa4NR3nkLk9xuANEwk4g6N1XvLso6TqSi1gOEvbsBH7aLFxJKOwgJ+kV8p0Fg=
X-Received: from pjnz3.prod.google.com ([2002:a17:90a:8b83:b0:34a:bee9:ef2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2e08:b0:340:ad5e:ca
 with SMTP id 98e67ed59e1d1-34e92139e3amr31373229a91.12.1767135724924; Tue, 30
 Dec 2025 15:02:04 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Dec 2025 15:01:36 -0800
In-Reply-To: <20251230230150.4150236-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251230230150.4150236-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251230230150.4150236-8-seanjc@google.com>
Subject: [PATCH v4 07/21] KVM: selftests: Plumb "struct kvm_mmu" into x86's
 MMU APIs
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

In preparation for generalizing the x86 virt mapping APIs to work with
TDP (stage-2) page tables, plumb "struct kvm_mmu" into all of the helper
functions instead of operating on vm->mmu directly.

Opportunistically swap the order of the check in virt_get_pte() to first
assert that the parent is the PGD, and then check that the PTE is present,
as it makes more sense to check if the parent PTE is the PGD/root (i.e.
not a PTE) before checking that the PTE is PRESENT.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
[sean: rebase on common kvm_mmu structure, rewrite changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86/processor.h     |  3 +-
 .../testing/selftests/kvm/lib/x86/processor.c | 68 +++++++++++--------
 2 files changed, 41 insertions(+), 30 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index c00c0fbe62cd..cbac9de29074 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -1449,7 +1449,8 @@ enum pg_level {
 #define PG_SIZE_2M PG_LEVEL_SIZE(PG_LEVEL_2M)
 #define PG_SIZE_1G PG_LEVEL_SIZE(PG_LEVEL_1G)
 
-void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level);
+void __virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, uint64_t vaddr,
+		   uint64_t paddr,  int level);
 void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 		    uint64_t nr_bytes, int level);
 
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index f027f86d1535..f25742a804b0 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -156,26 +156,31 @@ bool kvm_is_tdp_enabled(void)
 		return get_kvm_amd_param_bool("npt");
 }
 
-void virt_arch_pgd_alloc(struct kvm_vm *vm)
+static void virt_mmu_init(struct kvm_vm *vm, struct kvm_mmu *mmu)
 {
-	TEST_ASSERT(vm->mode == VM_MODE_PXXVYY_4K,
-		    "Unknown or unsupported guest mode: 0x%x", vm->mode);
-
 	/* If needed, create the top-level page table. */
-	if (!vm->mmu.pgd_created) {
-		vm->mmu.pgd = vm_alloc_page_table(vm);
-		vm->mmu.pgd_created = true;
+	if (!mmu->pgd_created) {
+		mmu->pgd = vm_alloc_page_table(vm);
+		mmu->pgd_created = true;
 	}
 }
 
-static void *virt_get_pte(struct kvm_vm *vm, uint64_t *parent_pte,
-			  uint64_t vaddr, int level)
+void virt_arch_pgd_alloc(struct kvm_vm *vm)
+{
+	TEST_ASSERT(vm->mode == VM_MODE_PXXVYY_4K,
+		    "Unknown or unsupported guest mode: 0x%x", vm->mode);
+
+	virt_mmu_init(vm, &vm->mmu);
+}
+
+static void *virt_get_pte(struct kvm_vm *vm, struct kvm_mmu *mmu,
+			  uint64_t *parent_pte, uint64_t vaddr, int level)
 {
 	uint64_t pt_gpa = PTE_GET_PA(*parent_pte);
 	uint64_t *page_table = addr_gpa2hva(vm, pt_gpa);
 	int index = (vaddr >> PG_LEVEL_SHIFT(level)) & 0x1ffu;
 
-	TEST_ASSERT((*parent_pte & PTE_PRESENT_MASK) || parent_pte == &vm->mmu.pgd,
+	TEST_ASSERT((*parent_pte == mmu->pgd) || (*parent_pte & PTE_PRESENT_MASK),
 		    "Parent PTE (level %d) not PRESENT for gva: 0x%08lx",
 		    level + 1, vaddr);
 
@@ -183,13 +188,14 @@ static void *virt_get_pte(struct kvm_vm *vm, uint64_t *parent_pte,
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
 
@@ -215,10 +221,11 @@ static uint64_t *virt_create_upper_pte(struct kvm_vm *vm,
 	return pte;
 }
 
-void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
+void __virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, uint64_t vaddr,
+		   uint64_t paddr, int level)
 {
 	const uint64_t pg_size = PG_LEVEL_SIZE(level);
-	uint64_t *pte = &vm->mmu.pgd;
+	uint64_t *pte = &mmu->pgd;
 	int current_level;
 
 	TEST_ASSERT(vm->mode == VM_MODE_PXXVYY_4K,
@@ -243,17 +250,17 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
 	 * Allocate upper level page tables, if not already present.  Return
 	 * early if a hugepage was created.
 	 */
-	for (current_level = vm->mmu.pgtable_levels;
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
@@ -270,7 +277,7 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
 
 void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 {
-	__virt_pg_map(vm, vaddr, paddr, PG_LEVEL_4K);
+	__virt_pg_map(vm, &vm->mmu, vaddr, paddr, PG_LEVEL_4K);
 }
 
 void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
@@ -285,7 +292,7 @@ void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 		    nr_bytes, pg_size);
 
 	for (i = 0; i < nr_pages; i++) {
-		__virt_pg_map(vm, vaddr, paddr, level);
+		__virt_pg_map(vm, &vm->mmu, vaddr, paddr, level);
 		sparsebit_set_num(vm->vpages_mapped, vaddr >> vm->page_shift,
 				  nr_bytes / PAGE_SIZE);
 
@@ -294,7 +301,8 @@ void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 	}
 }
 
-static bool vm_is_target_pte(uint64_t *pte, int *level, int current_level)
+static bool vm_is_target_pte(struct kvm_mmu *mmu, uint64_t *pte,
+			     int *level, int current_level)
 {
 	if (*pte & PTE_LARGE_MASK) {
 		TEST_ASSERT(*level == PG_LEVEL_NONE ||
@@ -306,17 +314,19 @@ static bool vm_is_target_pte(uint64_t *pte, int *level, int current_level)
 	return *level == current_level;
 }
 
-static uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr,
+static uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm,
+					   struct kvm_mmu *mmu,
+					   uint64_t vaddr,
 					   int *level)
 {
-	int va_width = 12 + (vm->mmu.pgtable_levels) * 9;
-	uint64_t *pte = &vm->mmu.pgd;
+	int va_width = 12 + (mmu->pgtable_levels) * 9;
+	uint64_t *pte = &mmu->pgd;
 	int current_level;
 
 	TEST_ASSERT(!vm->arch.is_pt_protected,
 		    "Walking page tables of protected guests is impossible");
 
-	TEST_ASSERT(*level >= PG_LEVEL_NONE && *level <= vm->mmu.pgtable_levels,
+	TEST_ASSERT(*level >= PG_LEVEL_NONE && *level <= mmu->pgtable_levels,
 		    "Invalid PG_LEVEL_* '%d'", *level);
 
 	TEST_ASSERT(vm->mode == VM_MODE_PXXVYY_4K,
@@ -332,22 +342,22 @@ static uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr,
 		    (((int64_t)vaddr << (64 - va_width) >> (64 - va_width))),
 		    "Canonical check failed.  The virtual address is invalid.");
 
-	for (current_level = vm->mmu.pgtable_levels;
+	for (current_level = mmu->pgtable_levels;
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
+	return __vm_get_page_table_entry(vm, &vm->mmu, vaddr, &level);
 }
 
 void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
@@ -497,7 +507,7 @@ static void kvm_seg_set_kernel_data_64bit(struct kvm_segment *segp)
 vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 {
 	int level = PG_LEVEL_NONE;
-	uint64_t *pte = __vm_get_page_table_entry(vm, gva, &level);
+	uint64_t *pte = __vm_get_page_table_entry(vm, &vm->mmu, gva, &level);
 
 	TEST_ASSERT(*pte & PTE_PRESENT_MASK,
 		    "Leaf PTE not PRESENT for gva: 0x%08lx", gva);
-- 
2.52.0.351.gbe84eed79e-goog


