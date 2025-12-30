Return-Path: <kvm+bounces-66880-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EACFACEAD71
	for <lists+kvm@lfdr.de>; Wed, 31 Dec 2025 00:13:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2998E304C6F2
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 23:11:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1E152E5427;
	Tue, 30 Dec 2025 23:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p1xE+NvE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721402E36F1
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 23:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767135733; cv=none; b=X1ZmvAhXrDe3h0Mdd01aGEtMEZ3B+n03vZYKKWpM1jZQiIvnEgRrfjjqSrBtkYqQpmqy1CzseVm4T7U5SrZbxLzupKWjWFNhf6VQ1PK41z5hFfINRsBUyp3OFvbGv7XqU87hiu1BMS5gKprTS4EudMk594iv9ZLTnIgFTgXoJwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767135733; c=relaxed/simple;
	bh=BhtOyCRfzVpLTFESld4Vi5QuDQZcBRxr4LUMT100+ew=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RiztdCKUX5Xv9/PZMVfMQHyFMyPy69q3F0g44C9hWuf5ZXvWTeR/gV21H34OGKv5DgJw3cT9KsII2WipIAk7wtDdcdRtNlcweq2LMPJk+NuA1bIFxY/dG0L3Tcyye/AA7WwaCWyDYKH6djAt7sPGqC9po/PiV6jUSAa17/A5IQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p1xE+NvE; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c38781efcso20738396a91.2
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 15:02:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767135729; x=1767740529; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=rp9dO+QiHStaM2noTobEg1WWV0+ff87sBjqkUH1s1So=;
        b=p1xE+NvEZFNo+uzEKeKG7WX32FBEmlqi+fM1DR9LZWG7dIwa9rt+S0ZQB/30QlhTdx
         ezEhWhTIwObXXK6EiEefm02R6yqy9oXaB5/0lTKEKpRT8zONR1fQutjRhQ9MLJZvEcsE
         k4IIkV+LhiNtTzcuEsI3PKTx4KRnorGgCbxnDMSMfPrdFbceEEt/wWuIuuA3nY+5Asop
         l1AXwBLsUj+fz5XyO1WLGXLD/RnLXBvI5q/z6rBT1y7bXiX7oR3mg7rN/nNnPaCwJpmQ
         xIuZOv0QdsDAqJ7VGc44PjqOtbsB/tzuPwB6VaYoH9CB9m4tx9zdYWU8xZMSn1milE5H
         JU1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767135729; x=1767740529;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rp9dO+QiHStaM2noTobEg1WWV0+ff87sBjqkUH1s1So=;
        b=K/oPqLhw7sAdpmJ1VoxyzCmrS6pEUiYi/hJmfE/guT4YRmPct7ZdeSvE+qIAapj3W6
         lofi3dI/rpufVrK5EntyIDYZWqPsjLUmV2Hl8cGqpgwlCo2XwcC7UaJlF4awgqJv8U9d
         Uqbbt5NEDqyrVjAwRY62r9kVvxIx8r0v40LYld/NLgzq1He9Gz17HomwXpTprOkeqK6W
         30aEB3vnHIXywT7gzmMlESxsCqBlUYEXjcF0f7Xn9MSQt/+JFAD19yRaEwW88rg2N8FH
         Iz3xvYzPVF2zomnZBR3ZlIse78z/uuYTYuk9OUc9kVymF4Oov3+nqjPCWToR6naBaNwe
         7Y2g==
X-Gm-Message-State: AOJu0YxR56xpMcCi0F4KB34KFox306bHC8C1U8PO6T/BDUf7QFZl+AF8
	RV4sGLlPjkLBl6qiV/wTnSLVBs/juj8TM/lhSfDKSi/nO6TEaBilD17hSMvH7s77vEGK9/DqNXT
	PGtjfMw==
X-Google-Smtp-Source: AGHT+IHXiVGp+aLiRnfsWKk0NFKmgA3+F+MNTAgUXfHua357amgtXMsohsm9V2nYhNe7Fz2ha8uNgJNsSiU=
X-Received: from pjbci19.prod.google.com ([2002:a17:90a:fc93:b0:34a:c039:1428])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:524b:b0:32d:f352:f764
 with SMTP id 98e67ed59e1d1-34e9212a45cmr24810424a91.2.1767135728615; Tue, 30
 Dec 2025 15:02:08 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Dec 2025 15:01:38 -0800
In-Reply-To: <20251230230150.4150236-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251230230150.4150236-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251230230150.4150236-10-seanjc@google.com>
Subject: [PATCH v4 09/21] KVM: selftests: Move PTE bitmasks to kvm_mmu
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

From: Yosry Ahmed <yosry.ahmed@linux.dev>

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
[sean: rename accessors to is_<adjective>_pte()]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86/kvm_util_arch.h | 16 ++++-
 .../selftests/kvm/include/x86/processor.h     | 28 +++++---
 .../testing/selftests/kvm/lib/x86/processor.c | 71 +++++++++++--------
 3 files changed, 76 insertions(+), 39 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h b/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
index 456e5ca170df..bad381d63b6a 100644
--- a/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
+++ b/tools/testing/selftests/kvm/include/x86/kvm_util_arch.h
@@ -10,7 +10,21 @@
 
 extern bool is_forced_emulation_enabled;
 
-struct kvm_mmu_arch {};
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
+struct kvm_mmu_arch {
+	struct pte_masks pte_masks;
+};
 
 struct kvm_vm_arch {
 	vm_vaddr_t gdt;
diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index cbac9de29074..b2084434dd8b 100644
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
@@ -1449,6 +1439,24 @@ enum pg_level {
 #define PG_SIZE_2M PG_LEVEL_SIZE(PG_LEVEL_2M)
 #define PG_SIZE_1G PG_LEVEL_SIZE(PG_LEVEL_1G)
 
+#define PTE_PRESENT_MASK(mmu)		((mmu)->arch.pte_masks.present)
+#define PTE_WRITABLE_MASK(mmu)		((mmu)->arch.pte_masks.writable)
+#define PTE_USER_MASK(mmu)		((mmu)->arch.pte_masks.user)
+#define PTE_ACCESSED_MASK(mmu)		((mmu)->arch.pte_masks.accessed)
+#define PTE_DIRTY_MASK(mmu)		((mmu)->arch.pte_masks.dirty)
+#define PTE_HUGE_MASK(mmu)		((mmu)->arch.pte_masks.huge)
+#define PTE_NX_MASK(mmu)		((mmu)->arch.pte_masks.nx)
+#define PTE_C_BIT_MASK(mmu)		((mmu)->arch.pte_masks.c)
+#define PTE_S_BIT_MASK(mmu)		((mmu)->arch.pte_masks.s)
+
+#define is_present_pte(mmu, pte)	(!!(*(pte) & PTE_PRESENT_MASK(mmu)))
+#define is_writable_pte(mmu, pte)	(!!(*(pte) & PTE_WRITABLE_MASK(mmu)))
+#define is_user_pte(mmu, pte)		(!!(*(pte) & PTE_USER_MASK(mmu)))
+#define is_accessed_pte(mmu, pte)	(!!(*(pte) & PTE_ACCESSED_MASK(mmu)))
+#define is_dirty_pte(mmu, pte)		(!!(*(pte) & PTE_DIRTY_MASK(mmu)))
+#define is_huge_pte(mmu, pte)		(!!(*(pte) & PTE_HUGE_MASK(mmu)))
+#define is_nx_pte(mmu, pte)		(!!(*(pte) & PTE_NX_MASK(mmu)))
+
 void __virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, uint64_t vaddr,
 		   uint64_t paddr,  int level);
 void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index f25742a804b0..3800f4ff6770 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -156,12 +156,14 @@ bool kvm_is_tdp_enabled(void)
 		return get_kvm_amd_param_bool("npt");
 }
 
-static void virt_mmu_init(struct kvm_vm *vm, struct kvm_mmu *mmu)
+static void virt_mmu_init(struct kvm_vm *vm, struct kvm_mmu *mmu,
+			  struct pte_masks *pte_masks)
 {
 	/* If needed, create the top-level page table. */
 	if (!mmu->pgd_created) {
 		mmu->pgd = vm_alloc_page_table(vm);
 		mmu->pgd_created = true;
+		mmu->arch.pte_masks = *pte_masks;
 	}
 }
 
@@ -170,7 +172,19 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
 	TEST_ASSERT(vm->mode == VM_MODE_PXXVYY_4K,
 		    "Unknown or unsupported guest mode: 0x%x", vm->mode);
 
-	virt_mmu_init(vm, &vm->mmu);
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
+	virt_mmu_init(vm, &vm->mmu, &pte_masks);
 }
 
 static void *virt_get_pte(struct kvm_vm *vm, struct kvm_mmu *mmu,
@@ -180,7 +194,7 @@ static void *virt_get_pte(struct kvm_vm *vm, struct kvm_mmu *mmu,
 	uint64_t *page_table = addr_gpa2hva(vm, pt_gpa);
 	int index = (vaddr >> PG_LEVEL_SHIFT(level)) & 0x1ffu;
 
-	TEST_ASSERT((*parent_pte == mmu->pgd) || (*parent_pte & PTE_PRESENT_MASK),
+	TEST_ASSERT((*parent_pte == mmu->pgd) || is_present_pte(mmu, parent_pte),
 		    "Parent PTE (level %d) not PRESENT for gva: 0x%08lx",
 		    level + 1, vaddr);
 
@@ -199,10 +213,10 @@ static uint64_t *virt_create_upper_pte(struct kvm_vm *vm,
 
 	paddr = vm_untag_gpa(vm, paddr);
 
-	if (!(*pte & PTE_PRESENT_MASK)) {
-		*pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK;
+	if (!is_present_pte(mmu, pte)) {
+		*pte = PTE_PRESENT_MASK(mmu) | PTE_WRITABLE_MASK(mmu);
 		if (current_level == target_level)
-			*pte |= PTE_LARGE_MASK | (paddr & PHYSICAL_PAGE_MASK);
+			*pte |= PTE_HUGE_MASK(mmu) | (paddr & PHYSICAL_PAGE_MASK);
 		else
 			*pte |= vm_alloc_page_table(vm) & PHYSICAL_PAGE_MASK;
 	} else {
@@ -214,7 +228,7 @@ static uint64_t *virt_create_upper_pte(struct kvm_vm *vm,
 		TEST_ASSERT(current_level != target_level,
 			    "Cannot create hugepage at level: %u, vaddr: 0x%lx",
 			    current_level, vaddr);
-		TEST_ASSERT(!(*pte & PTE_LARGE_MASK),
+		TEST_ASSERT(!is_huge_pte(mmu, pte),
 			    "Cannot create page table at level: %u, vaddr: 0x%lx",
 			    current_level, vaddr);
 	}
@@ -255,24 +269,24 @@ void __virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, uint64_t vaddr,
 	     current_level--) {
 		pte = virt_create_upper_pte(vm, mmu, pte, vaddr, paddr,
 					    current_level, level);
-		if (*pte & PTE_LARGE_MASK)
+		if (is_huge_pte(mmu, pte))
 			return;
 	}
 
 	/* Fill in page table entry. */
 	pte = virt_get_pte(vm, mmu, pte, vaddr, PG_LEVEL_4K);
-	TEST_ASSERT(!(*pte & PTE_PRESENT_MASK),
+	TEST_ASSERT(!is_present_pte(mmu, pte),
 		    "PTE already present for 4k page at vaddr: 0x%lx", vaddr);
-	*pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK | (paddr & PHYSICAL_PAGE_MASK);
+	*pte = PTE_PRESENT_MASK(mmu) | PTE_WRITABLE_MASK(mmu) | (paddr & PHYSICAL_PAGE_MASK);
 
 	/*
 	 * Neither SEV nor TDX supports shared page tables, so only the final
 	 * leaf PTE needs manually set the C/S-bit.
 	 */
 	if (vm_is_gpa_protected(vm, paddr))
-		*pte |= vm->arch.c_bit;
+		*pte |= PTE_C_BIT_MASK(mmu);
 	else
-		*pte |= vm->arch.s_bit;
+		*pte |= PTE_S_BIT_MASK(mmu);
 }
 
 void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
@@ -304,7 +318,7 @@ void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 static bool vm_is_target_pte(struct kvm_mmu *mmu, uint64_t *pte,
 			     int *level, int current_level)
 {
-	if (*pte & PTE_LARGE_MASK) {
+	if (is_huge_pte(mmu, pte)) {
 		TEST_ASSERT(*level == PG_LEVEL_NONE ||
 			    *level == current_level,
 			    "Unexpected hugepage at level %d", current_level);
@@ -362,12 +376,13 @@ uint64_t *vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr)
 
 void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 {
+	struct kvm_mmu *mmu = &vm->mmu;
 	uint64_t *pml4e, *pml4e_start;
 	uint64_t *pdpe, *pdpe_start;
 	uint64_t *pde, *pde_start;
 	uint64_t *pte, *pte_start;
 
-	if (!vm->mmu.pgd_created)
+	if (!mmu->pgd_created)
 		return;
 
 	fprintf(stream, "%*s                                          "
@@ -375,47 +390,47 @@ void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 	fprintf(stream, "%*s      index hvaddr         gpaddr         "
 		"addr         w exec dirty\n",
 		indent, "");
-	pml4e_start = (uint64_t *) addr_gpa2hva(vm, vm->mmu.pgd);
+	pml4e_start = (uint64_t *) addr_gpa2hva(vm, mmu->pgd);
 	for (uint16_t n1 = 0; n1 <= 0x1ffu; n1++) {
 		pml4e = &pml4e_start[n1];
-		if (!(*pml4e & PTE_PRESENT_MASK))
+		if (!is_present_pte(mmu, pml4e))
 			continue;
 		fprintf(stream, "%*spml4e 0x%-3zx %p 0x%-12lx 0x%-10llx %u "
 			" %u\n",
 			indent, "",
 			pml4e - pml4e_start, pml4e,
 			addr_hva2gpa(vm, pml4e), PTE_GET_PFN(*pml4e),
-			!!(*pml4e & PTE_WRITABLE_MASK), !!(*pml4e & PTE_NX_MASK));
+			is_writable_pte(mmu, pml4e), is_nx_pte(mmu, pml4e));
 
 		pdpe_start = addr_gpa2hva(vm, *pml4e & PHYSICAL_PAGE_MASK);
 		for (uint16_t n2 = 0; n2 <= 0x1ffu; n2++) {
 			pdpe = &pdpe_start[n2];
-			if (!(*pdpe & PTE_PRESENT_MASK))
+			if (!is_present_pte(mmu, pdpe))
 				continue;
 			fprintf(stream, "%*spdpe  0x%-3zx %p 0x%-12lx 0x%-10llx "
 				"%u  %u\n",
 				indent, "",
 				pdpe - pdpe_start, pdpe,
 				addr_hva2gpa(vm, pdpe),
-				PTE_GET_PFN(*pdpe), !!(*pdpe & PTE_WRITABLE_MASK),
-				!!(*pdpe & PTE_NX_MASK));
+				PTE_GET_PFN(*pdpe), is_writable_pte(mmu, pdpe),
+				is_nx_pte(mmu, pdpe));
 
 			pde_start = addr_gpa2hva(vm, *pdpe & PHYSICAL_PAGE_MASK);
 			for (uint16_t n3 = 0; n3 <= 0x1ffu; n3++) {
 				pde = &pde_start[n3];
-				if (!(*pde & PTE_PRESENT_MASK))
+				if (!is_present_pte(mmu, pde))
 					continue;
 				fprintf(stream, "%*spde   0x%-3zx %p "
 					"0x%-12lx 0x%-10llx %u  %u\n",
 					indent, "", pde - pde_start, pde,
 					addr_hva2gpa(vm, pde),
-					PTE_GET_PFN(*pde), !!(*pde & PTE_WRITABLE_MASK),
-					!!(*pde & PTE_NX_MASK));
+					PTE_GET_PFN(*pde), is_writable_pte(mmu, pde),
+					is_nx_pte(mmu, pde));
 
 				pte_start = addr_gpa2hva(vm, *pde & PHYSICAL_PAGE_MASK);
 				for (uint16_t n4 = 0; n4 <= 0x1ffu; n4++) {
 					pte = &pte_start[n4];
-					if (!(*pte & PTE_PRESENT_MASK))
+					if (!is_present_pte(mmu, pte))
 						continue;
 					fprintf(stream, "%*spte   0x%-3zx %p "
 						"0x%-12lx 0x%-10llx %u  %u "
@@ -424,9 +439,9 @@ void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 						pte - pte_start, pte,
 						addr_hva2gpa(vm, pte),
 						PTE_GET_PFN(*pte),
-						!!(*pte & PTE_WRITABLE_MASK),
-						!!(*pte & PTE_NX_MASK),
-						!!(*pte & PTE_DIRTY_MASK),
+						is_writable_pte(mmu, pte),
+						is_nx_pte(mmu, pte),
+						is_dirty_pte(mmu, pte),
 						((uint64_t) n1 << 27)
 							| ((uint64_t) n2 << 18)
 							| ((uint64_t) n3 << 9)
@@ -509,7 +524,7 @@ vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 	int level = PG_LEVEL_NONE;
 	uint64_t *pte = __vm_get_page_table_entry(vm, &vm->mmu, gva, &level);
 
-	TEST_ASSERT(*pte & PTE_PRESENT_MASK,
+	TEST_ASSERT(is_present_pte(&vm->mmu, pte),
 		    "Leaf PTE not PRESENT for gva: 0x%08lx", gva);
 
 	/*
-- 
2.52.0.351.gbe84eed79e-goog


