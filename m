Return-Path: <kvm+bounces-60626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E7AEBF5195
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 09:54:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3A1144FF498
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 07:52:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D2FD2F3C3E;
	Tue, 21 Oct 2025 07:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DLVPI02F"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B8C29B217;
	Tue, 21 Oct 2025 07:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761032936; cv=none; b=Teyu3zag8c27AKfY8DHjzipJQawSa9HQ6ZXTwpV+jEbqn64Jk4rtNfEhEnOeAAxjpStWjfJNbbCRCgZS71i7d6cRb4/k+LK2Ts5BERRx5K4k7nIe7lbT05THjXl/xhtuxIKmvPO1+R0WUzoBL6DTwSo7Opb6ck5cTyj13kyt2w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761032936; c=relaxed/simple;
	bh=mgC55q9T1f5jBf/8CfjvJMiQ5793zmo9lyYlDPw9u4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dIe7TDlXnrFxvJsfl+jnuI/3/mm3sgILMWlTi9wVobSPMDjjHdmdoHkiKPxQxFD8GjKUNKyMordmb1RP4Krb7VbsHpEqJymKGsYUAORYS5pCYTd40AyaPk10kOdfwCzx6xHN2IFe4PmVeP7dUTHoL3baKRGZN3h7/n+EEx+mo/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DLVPI02F; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761032931;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vRlNitll6uLSlbrA9R14UL9rp6yZ0zp6Csut3gOTm0g=;
	b=DLVPI02FdBoOOBwOryq4jlv6HCaxiutVRwxD1QSrxmoSOpkEMfvqvgV65NgiH0/vSYFTa8
	smQFr0+fqrOATKNUR2cGXXAAkl8x3qJ8HPfj6wcizdS0GBM+GKJ9qZtSUMLRMCOjUbxAbT
	oMKg4UDhf5nJ4UXlVlrk+3jeoy+cvsE=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v2 16/23] KVM: selftests: Use __virt_pg_map() for nested EPTs
Date: Tue, 21 Oct 2025 07:47:29 +0000
Message-ID: <20251021074736.1324328-17-yosry.ahmed@linux.dev>
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

__nested_pg_map() bears a lot of resemblence to __virt_pg_map(). The
main difference is using the EPT struct overlay instead of the PTE
masks. Now that PTE masks are passed into __virt_pg_map() as a struct,
define a similar struct for EPTs and use __virt_pg_map() instead of
__nested_pg_map().

EPTs have no 'present' or 'user' bits, so use the 'readable' bit instead
like shadow_{present/user}_mask, ignoring the fact that entries can be
present and not readable if the CPU has VMX_EPT_EXECUTE_ONLY_BIT. This
is simple and sufficient for testing.

Opportunistically drop nested_pg_map() since it has no callers.

Add an executable bitmask to struct pte_masks, and update
__virt_pg_map() and friends to set the bit on newly created entries to
match the EPT behavior. It's a noop for x86 page tables.

Another benefit of reusing the code is having separate handling for
upper-level PTEs vs 4K PTEs, which avoids some quirks like setting the
large bit on a 4K PTE.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Suggested-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86/processor.h     |   1 +
 tools/testing/selftests/kvm/include/x86/vmx.h |   4 +-
 .../testing/selftests/kvm/lib/x86/processor.c |   9 +-
 tools/testing/selftests/kvm/lib/x86/vmx.c     | 113 +++---------------
 4 files changed, 27 insertions(+), 100 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index 2f0d83b6e5952..0d6d335d309ef 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -1447,6 +1447,7 @@ struct pte_masks {
 	uint64_t dirty;
 	uint64_t large;
 	uint64_t nx;
+	uint64_t x;
 };
 
 extern const struct pte_masks x86_pte_masks;
diff --git a/tools/testing/selftests/kvm/include/x86/vmx.h b/tools/testing/selftests/kvm/include/x86/vmx.h
index 96e2b4c630a9b..5aa14ceed050a 100644
--- a/tools/testing/selftests/kvm/include/x86/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86/vmx.h
@@ -99,6 +99,8 @@
 #define VMX_EPT_VPID_CAP_1G_PAGES		0x00020000
 #define VMX_EPT_VPID_CAP_AD_BITS		0x00200000
 
+extern const struct pte_masks ept_pte_masks;
+
 #define EXIT_REASON_FAILED_VMENTRY	0x80000000
 
 enum vmcs_field {
@@ -559,8 +561,6 @@ bool load_vmcs(struct vmx_pages *vmx);
 
 bool ept_1g_pages_supported(void);
 
-void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
-		   uint64_t nested_paddr, uint64_t paddr);
 void nested_map(struct vmx_pages *vmx, struct kvm_vm *vm,
 		 uint64_t nested_paddr, uint64_t paddr, uint64_t size);
 void nested_map_memslot(struct vmx_pages *vmx, struct kvm_vm *vm,
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index 13e9376d5f545..caad8a9b3f067 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -177,6 +177,7 @@ const struct pte_masks x86_pte_masks = {
 	.dirty		=	BIT_ULL(6),
 	.large		=	BIT_ULL(7),
 	.nx		=	BIT_ULL(63),
+	.x		=	0,
 };
 
 static void *virt_get_pte(struct kvm_vm *vm, vm_paddr_t root_gpa,
@@ -209,7 +210,7 @@ static uint64_t *virt_create_upper_pte(struct kvm_vm *vm,
 	paddr = vm_untag_gpa(vm, paddr);
 
 	if (!(*pte & masks->present)) {
-		*pte = masks->present | masks->writeable;
+		*pte = masks->present | masks->writeable | masks->x;
 		if (current_level == target_level)
 			*pte |= masks->large | (paddr & PHYSICAL_PAGE_MASK);
 		else
@@ -256,6 +257,9 @@ void __virt_pg_map(struct kvm_vm *vm, vm_paddr_t root_gpa, uint64_t vaddr,
 	TEST_ASSERT(vm_untag_gpa(vm, paddr) == paddr,
 		    "Unexpected bits in paddr: %lx", paddr);
 
+	TEST_ASSERT(!masks->x || !masks->nx,
+		    "X and NX bit masks cannot be used simultaneously");
+
 	/*
 	 * Allocate upper level page tables, if not already present.  Return
 	 * early if a hugepage was created.
@@ -271,7 +275,8 @@ void __virt_pg_map(struct kvm_vm *vm, vm_paddr_t root_gpa, uint64_t vaddr,
 	pte = virt_get_pte(vm, root_gpa, pte, vaddr, PG_LEVEL_4K, masks);
 	TEST_ASSERT(!(*pte & masks->present),
 		    "PTE already present for 4k page at vaddr: 0x%lx", vaddr);
-	*pte = masks->present | masks->writeable | (paddr & PHYSICAL_PAGE_MASK);
+	*pte = masks->present | masks->writeable | masks->x
+		| (paddr & PHYSICAL_PAGE_MASK);
 
 	/*
 	 * Neither SEV nor TDX supports shared page tables, so only the final
diff --git a/tools/testing/selftests/kvm/lib/x86/vmx.c b/tools/testing/selftests/kvm/lib/x86/vmx.c
index 36e60016fa7b2..46a491eb083c9 100644
--- a/tools/testing/selftests/kvm/lib/x86/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
@@ -19,19 +19,21 @@ bool enable_evmcs;
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
+const struct pte_masks ept_pte_masks = {
+	/*
+	 * EPTs do not have 'present' or 'user' bits, instead bit 0 is the
+	 * 'readable' bit. In some cases, EPTs can be execute-only and an entry
+	 * is present but not readable. However, for the purposes of testing we
+	 * assume present == user == readable for simplicity.
+	 */
+	.present	=	BIT_ULL(0),
+	.user		=	BIT_ULL(0),
+	.writeable	=	BIT_ULL(1),
+	.x		=	BIT_ULL(2),
+	.accessed	=	BIT_ULL(5),
+	.dirty		=	BIT_ULL(6),
+	.large		=	BIT_ULL(7),
+	.nx		=	0,
 };
 
 struct eptPageTablePointer {
@@ -362,88 +364,6 @@ void prepare_vmcs(struct vmx_pages *vmx, void *guest_rip, void *guest_rsp)
 	init_vmcs_guest_state(guest_rip, guest_rsp);
 }
 
-static void nested_create_pte(struct kvm_vm *vm,
-			      struct eptPageTableEntry *pte,
-			      uint64_t nested_paddr,
-			      uint64_t paddr,
-			      int current_level,
-			      int target_level)
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
-void __nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
-		     uint64_t nested_paddr, uint64_t paddr, int target_level)
-{
-	const uint64_t page_size = PG_LEVEL_SIZE(target_level);
-	struct eptPageTableEntry *pt = vmx->eptp_hva, *pte;
-	uint16_t index;
-
-	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K ||
-		    vm->mode == VM_MODE_PXXV57_4K,
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
-		nested_create_pte(vm, pte, nested_paddr, paddr, level, target_level);
-
-		if (pte->page_size)
-			break;
-
-		pt = addr_gpa2hva(vm, pte->address * vm->page_size);
-	}
-}
-
-void nested_pg_map(struct vmx_pages *vmx, struct kvm_vm *vm,
-		   uint64_t nested_paddr, uint64_t paddr)
-{
-	__nested_pg_map(vmx, vm, nested_paddr, paddr, PG_LEVEL_4K);
-}
-
 /*
  * Map a range of EPT guest physical addresses to the VM's physical address
  *
@@ -472,7 +392,8 @@ void __nested_map(struct vmx_pages *vmx, struct kvm_vm *vm,
 	TEST_ASSERT(paddr + size > paddr, "Paddr overflow");
 
 	while (npages--) {
-		__nested_pg_map(vmx, vm, nested_paddr, paddr, level);
+		__virt_pg_map(vm, vmx->eptp_gpa, nested_paddr, paddr,
+			      level, &ept_pte_masks);
 		nested_paddr += page_size;
 		paddr += page_size;
 	}
-- 
2.51.0.869.ge66316f041-goog


