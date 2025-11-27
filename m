Return-Path: <kvm+bounces-64810-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E3806C8C921
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 02:37:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 40EA23A7503
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 01:37:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1945D22156A;
	Thu, 27 Nov 2025 01:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VA0qzw9i"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D04261B6E
	for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 01:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764207318; cv=none; b=PTD1qs9PrA0pIEoHoO5J6SiNU9D7Jgz0SHkajyyvye9VX5d4/48xntOsNFuA2LDlrG8/1/idQcOzii5wLqMIxYF5HLn/FJfS+FKij94jHmjDRPHwXZ57GRC4zp4NyccFogVsZbVe0/6MgxeOnWAki7ak7Ggm81z+hHT786ik2bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764207318; c=relaxed/simple;
	bh=AVL65zE6ap9yXa02g08WlNKn7e/EuZdOWIoUxqMYqAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TS6rGB1bsVKa8M8SBz3MtP6JUYyM6DkALbiZFLzWQWlOS4UNYu6Elgh1rhGwsv6h6dE0rMtDw/TEoW1bo1KyVVjTCd/OMLGaxbjH1bgoLq3Bfm4h3LAAAy4vSQGlGwsKGaYekw7jhbuwXAZZHWhwOMrCWgINzvEJon4kQvU9xNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VA0qzw9i; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764207313;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=heCl6z29MAL1C93kBW4Xu7OGs20kKxnbrJao+8ri5pg=;
	b=VA0qzw9iMAs3D2ocRyQ5XNuY/PAsNZyEk0BVwoJmkEHh8lI8RIJothTwLjyyyHX/yNEfwp
	Fn259pMLYb/S8pBM3qtd6o2AXt0Z2e7nTcpfB9s8jK3LFdOQNzaI9PwRtS5a9eT3waJFNc
	XBqmcapbioaMuLVrm6k9DLudcuV93Cs=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v3 10/16] KVM: selftests: Reuse virt mapping functions for nested EPTs
Date: Thu, 27 Nov 2025 01:34:34 +0000
Message-ID: <20251127013440.3324671-11-yosry.ahmed@linux.dev>
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

__tdp_pg_map() bears a lot of resemblence to __virt_pg_map(). The
main differences are:
- It uses the EPT struct overlay instead of the PTE masks.
- It always assumes 4-level EPTs.

To reuse __virt_pg_map(), initialize the PTE masks in nested MMU with
EPT PTE masks. EPTs have no 'present' or 'user' bits, so use the
'readable' bit instead like shadow_{present/user}_mask, ignoring the
fact that entries can be present and not readable if the CPU has
VMX_EPT_EXECUTE_ONLY_BIT.  This is simple and sufficient for testing.

Add an executable bitmask and update __virt_pg_map() and friends to set
the bit on newly created entries to match the EPT behavior. It's a nop
for x86 page tables.

Another benefit of reusing the code is having separate handling for
upper-level PTEs vs 4K PTEs, which avoids some quirks like setting the
large bit on a 4K PTE in the EPTs.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 .../selftests/kvm/include/x86/processor.h     |   3 +
 .../testing/selftests/kvm/lib/x86/processor.c |  12 +-
 tools/testing/selftests/kvm/lib/x86/vmx.c     | 115 ++++--------------
 3 files changed, 33 insertions(+), 97 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index fb2b2e53d453..62e10b296719 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -1447,6 +1447,7 @@ struct pte_masks {
 	uint64_t dirty;
 	uint64_t huge;
 	uint64_t nx;
+	uint64_t x;
 	uint64_t c;
 	uint64_t s;
 };
@@ -1464,6 +1465,7 @@ struct kvm_mmu {
 #define PTE_DIRTY_MASK(mmu) ((mmu)->pte_masks.dirty)
 #define PTE_HUGE_MASK(mmu) ((mmu)->pte_masks.huge)
 #define PTE_NX_MASK(mmu) ((mmu)->pte_masks.nx)
+#define PTE_X_MASK(mmu) ((mmu)->pte_masks.x)
 #define PTE_C_MASK(mmu) ((mmu)->pte_masks.c)
 #define PTE_S_MASK(mmu) ((mmu)->pte_masks.s)
 
@@ -1474,6 +1476,7 @@ struct kvm_mmu {
 #define pte_dirty(mmu, pte) (!!(*(pte) & PTE_DIRTY_MASK(mmu)))
 #define pte_huge(mmu, pte) (!!(*(pte) & PTE_HUGE_MASK(mmu)))
 #define pte_nx(mmu, pte) (!!(*(pte) & PTE_NX_MASK(mmu)))
+#define pte_x(mmu, pte) (!!(*(pte) & PTE_X_MASK(mmu)))
 #define pte_c(mmu, pte) (!!(*(pte) & PTE_C_MASK(mmu)))
 #define pte_s(mmu, pte) (!!(*(pte) & PTE_S_MASK(mmu)))
 
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index bff75ff05364..8b0e17f8ca37 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -162,8 +162,7 @@ struct kvm_mmu *mmu_create(struct kvm_vm *vm, int pgtable_levels,
 	struct kvm_mmu *mmu = calloc(1, sizeof(*mmu));
 
 	TEST_ASSERT(mmu, "-ENOMEM when allocating MMU");
-	if (pte_masks)
-		mmu->pte_masks = *pte_masks;
+	mmu->pte_masks = *pte_masks;
 	mmu->root_gpa = vm_alloc_page_table(vm);
 	mmu->pgtable_levels = pgtable_levels;
 	return mmu;
@@ -179,6 +178,7 @@ static void mmu_init(struct kvm_vm *vm)
 		.dirty		=	BIT_ULL(6),
 		.huge		=	BIT_ULL(7),
 		.nx		=	BIT_ULL(63),
+		.x		=	0,
 		.c		=	vm->arch.c_bit,
 		.s		=	vm->arch.s_bit,
 	};
@@ -225,7 +225,7 @@ static uint64_t *virt_create_upper_pte(struct kvm_vm *vm,
 	paddr = vm_untag_gpa(vm, paddr);
 
 	if (!pte_present(mmu, pte)) {
-		*pte = PTE_PRESENT_MASK(mmu) | PTE_WRITABLE_MASK(mmu);
+		*pte = PTE_PRESENT_MASK(mmu) | PTE_WRITABLE_MASK(mmu) | PTE_X_MASK(mmu);
 		if (current_level == target_level)
 			*pte |= PTE_HUGE_MASK(mmu) | (paddr & PHYSICAL_PAGE_MASK);
 		else
@@ -271,6 +271,9 @@ void __virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, uint64_t vaddr,
 	TEST_ASSERT(vm_untag_gpa(vm, paddr) == paddr,
 		    "Unexpected bits in paddr: %lx", paddr);
 
+	TEST_ASSERT(!PTE_X_MASK(mmu) || !PTE_NX_MASK(mmu),
+		    "X and NX bit masks cannot be used simultaneously");
+
 	/*
 	 * Allocate upper level page tables, if not already present.  Return
 	 * early if a hugepage was created.
@@ -288,7 +291,8 @@ void __virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, uint64_t vaddr,
 	pte = virt_get_pte(vm, mmu, pte, vaddr, PG_LEVEL_4K);
 	TEST_ASSERT(!pte_present(mmu, pte),
 		    "PTE already present for 4k page at vaddr: 0x%lx", vaddr);
-	*pte = PTE_PRESENT_MASK(mmu) | PTE_WRITABLE_MASK(mmu) | (paddr & PHYSICAL_PAGE_MASK);
+	*pte = PTE_PRESENT_MASK(mmu) | PTE_WRITABLE_MASK(mmu) | PTE_X_MASK(mmu)
+		| (paddr & PHYSICAL_PAGE_MASK);
 
 	/*
 	 * Neither SEV nor TDX supports shared page tables, so only the final
diff --git a/tools/testing/selftests/kvm/lib/x86/vmx.c b/tools/testing/selftests/kvm/lib/x86/vmx.c
index a909fad57fd5..0cba31cae896 100644
--- a/tools/testing/selftests/kvm/lib/x86/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
@@ -25,21 +25,6 @@ bool enable_evmcs;
 struct hv_enlightened_vmcs *current_evmcs;
 struct hv_vp_assist_page *current_vp_assist;
 
-struct eptPageTableEntry {
-	uint64_t readable:1;
-	uint64_t writable:1;
-	uint64_t executable:1;
-	uint64_t memory_type:3;
-	uint64_t ignore_pat:1;
-	uint64_t page_size:1;
-	uint64_t accessed:1;
-	uint64_t dirty:1;
-	uint64_t ignored_11_10:2;
-	uint64_t address:40;
-	uint64_t ignored_62_52:11;
-	uint64_t suppress_ve:1;
-};
-
 int vcpu_enable_evmcs(struct kvm_vcpu *vcpu)
 {
 	uint16_t evmcs_ver;
@@ -58,12 +43,31 @@ int vcpu_enable_evmcs(struct kvm_vcpu *vcpu)
 
 void vm_enable_ept(struct kvm_vm *vm)
 {
+	struct pte_masks pte_masks;
+
 	TEST_ASSERT(kvm_cpu_has_ept(), "KVM doesn't support nested EPT");
 	if (vm->arch.nested.mmu)
 		return;
 
+	/*
+	 * EPTs do not have 'present' or 'user' bits, instead bit 0 is the
+	 * 'readable' bit. In some cases, EPTs can be execute-only and an entry
+	 * is present but not readable. However, for the purposes of testing we
+	 * assume 'present' == 'user' == 'readable' for simplicity.
+	 */
+	pte_masks = (struct pte_masks){
+		.present	=	BIT_ULL(0),
+		.user		=	BIT_ULL(0),
+		.writable	=	BIT_ULL(1),
+		.x		=	BIT_ULL(2),
+		.accessed	=	BIT_ULL(5),
+		.dirty		=	BIT_ULL(6),
+		.huge		=	BIT_ULL(7),
+		.nx		=	0,
+	};
+
 	/* EPTP_PWL_4 is always used */
-	vm->arch.nested.mmu = mmu_create(vm, 4, NULL);
+	vm->arch.nested.mmu = mmu_create(vm, 4, &pte_masks);
 }
 
 /* Allocate memory regions for nested VMX tests.
@@ -372,82 +376,6 @@ void prepare_vmcs(struct vmx_pages *vmx, void *guest_rip, void *guest_rsp)
 	init_vmcs_guest_state(guest_rip, guest_rsp);
 }
 
-static void tdp_create_pte(struct kvm_vm *vm,
-			   struct eptPageTableEntry *pte,
-			   uint64_t nested_paddr,
-			   uint64_t paddr,
-			   int current_level,
-			   int target_level)
-{
-	if (!pte->readable) {
-		pte->writable = true;
-		pte->readable = true;
-		pte->executable = true;
-		pte->page_size = (current_level == target_level);
-		if (pte->page_size)
-			pte->address = paddr >> vm->page_shift;
-		else
-			pte->address = vm_alloc_page_table(vm) >> vm->page_shift;
-	} else {
-		/*
-		 * Entry already present.  Assert that the caller doesn't want
-		 * a hugepage at this level, and that there isn't a hugepage at
-		 * this level.
-		 */
-		TEST_ASSERT(current_level != target_level,
-			    "Cannot create hugepage at level: %u, nested_paddr: 0x%lx",
-			    current_level, nested_paddr);
-		TEST_ASSERT(!pte->page_size,
-			    "Cannot create page table at level: %u, nested_paddr: 0x%lx",
-			    current_level, nested_paddr);
-	}
-}
-
-
-void __tdp_pg_map(struct kvm_vm *vm, uint64_t nested_paddr, uint64_t paddr,
-		  int target_level)
-{
-	const uint64_t page_size = PG_LEVEL_SIZE(target_level);
-	void *eptp_hva = addr_gpa2hva(vm, vm->arch.nested.mmu->root_gpa);
-	struct eptPageTableEntry *pt = eptp_hva, *pte;
-	uint16_t index;
-
-	TEST_ASSERT(vm->mode == VM_MODE_PXXVYY_4K,
-		    "Unknown or unsupported guest mode: 0x%x", vm->mode);
-
-	TEST_ASSERT((nested_paddr >> 48) == 0,
-		    "Nested physical address 0x%lx is > 48-bits and requires 5-level EPT",
-		    nested_paddr);
-	TEST_ASSERT((nested_paddr % page_size) == 0,
-		    "Nested physical address not on page boundary,\n"
-		    "  nested_paddr: 0x%lx page_size: 0x%lx",
-		    nested_paddr, page_size);
-	TEST_ASSERT((nested_paddr >> vm->page_shift) <= vm->max_gfn,
-		    "Physical address beyond beyond maximum supported,\n"
-		    "  nested_paddr: 0x%lx vm->max_gfn: 0x%lx vm->page_size: 0x%x",
-		    paddr, vm->max_gfn, vm->page_size);
-	TEST_ASSERT((paddr % page_size) == 0,
-		    "Physical address not on page boundary,\n"
-		    "  paddr: 0x%lx page_size: 0x%lx",
-		    paddr, page_size);
-	TEST_ASSERT((paddr >> vm->page_shift) <= vm->max_gfn,
-		    "Physical address beyond beyond maximum supported,\n"
-		    "  paddr: 0x%lx vm->max_gfn: 0x%lx vm->page_size: 0x%x",
-		    paddr, vm->max_gfn, vm->page_size);
-
-	for (int level = PG_LEVEL_512G; level >= PG_LEVEL_4K; level--) {
-		index = (nested_paddr >> PG_LEVEL_SHIFT(level)) & 0x1ffu;
-		pte = &pt[index];
-
-		tdp_create_pte(vm, pte, nested_paddr, paddr, level, target_level);
-
-		if (pte->page_size)
-			break;
-
-		pt = addr_gpa2hva(vm, pte->address * vm->page_size);
-	}
-}
-
 /*
  * Map a range of EPT guest physical addresses to the VM's physical address
  *
@@ -468,6 +396,7 @@ void __tdp_pg_map(struct kvm_vm *vm, uint64_t nested_paddr, uint64_t paddr,
 void __tdp_map(struct kvm_vm *vm, uint64_t nested_paddr, uint64_t paddr,
 	       uint64_t size, int level)
 {
+	struct kvm_mmu *mmu = vm->arch.nested.mmu;
 	size_t page_size = PG_LEVEL_SIZE(level);
 	size_t npages = size / page_size;
 
@@ -475,7 +404,7 @@ void __tdp_map(struct kvm_vm *vm, uint64_t nested_paddr, uint64_t paddr,
 	TEST_ASSERT(paddr + size > paddr, "Paddr overflow");
 
 	while (npages--) {
-		__tdp_pg_map(vm, nested_paddr, paddr, level);
+		__virt_pg_map(vm, mmu, nested_paddr, paddr, level);
 		nested_paddr += page_size;
 		paddr += page_size;
 	}
-- 
2.52.0.158.g65b55ccf14-goog


