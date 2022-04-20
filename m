Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8636508613
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 12:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377737AbiDTKjS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 06:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358587AbiDTKjQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 06:39:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B517E1CB35
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 03:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650450988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=jaITzi8hb+2gl2eQb8mUcEwowTDVA1eQxZHgpTw9QgU=;
        b=J4vtyMskvK2Is+1QmfEkbOW3mW5NfcGs2Har/0zlTEgolVLcw1dFULyQNgCKNVXj4mPMG4
        sivCjwjsLjLZhITY2hL5H2upQvWCCVRKhcTBiFIj4uUncc9a1L/M7hYAWikOD1qTyh9YJ/
        fXUTI98djJe2cA9TSedvd4Fm0SPOROE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-511-ETgRgZgFMQq8E5wJL_EcNA-1; Wed, 20 Apr 2022 06:36:25 -0400
X-MC-Unique: ETgRgZgFMQq8E5wJL_EcNA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4E59C857D00;
        Wed, 20 Apr 2022 10:36:25 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1CF644087D71;
        Wed, 20 Apr 2022 10:36:25 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterx@redhat.com, seanjc@google.com
Subject: [PATCH] kvm: selftests: do not use bitfields larger than 32-bits for PTEs
Date:   Wed, 20 Apr 2022 06:36:24 -0400
Message-Id: <20220420103624.1143824-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Red Hat's QE team reported test failure on access_tracking_perf_test:

Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
guest physical test memory offset: 0x3fffbffff000

Populating memory             : 0.684014577s
Writing to populated memory   : 0.006230175s
Reading from populated memory : 0.004557805s
==== Test Assertion Failure ====
  lib/kvm_util.c:1411: false
  pid=125806 tid=125809 errno=4 - Interrupted system call
     1  0x0000000000402f7c: addr_gpa2hva at kvm_util.c:1411
     2   (inlined by) addr_gpa2hva at kvm_util.c:1405
     3  0x0000000000401f52: lookup_pfn at access_tracking_perf_test.c:98
     4   (inlined by) mark_vcpu_memory_idle at access_tracking_perf_test.c:152
     5   (inlined by) vcpu_thread_main at access_tracking_perf_test.c:232
     6  0x00007fefe9ff81ce: ?? ??:0
     7  0x00007fefe9c64d82: ?? ??:0
  No vm physical memory at 0xffbffff000

I can easily reproduce it with a Intel(R) Xeon(R) CPU E5-2630 with 46 bits
PA.

It turns out that the address translation for clearing idle page tracking
returned a wrong result; addr_gva2gpa()'s last step, which is based on
"pte[index[0]].pfn", did the calculation with 40 bits length and the
high 12 bits got truncated.  In above case the GPA address to be returned
should be 0x3fffbffff000 for GVA 0xc0000000, but it got truncated into
0xffbffff000 and the subsequent gpa2hva lookup failed.

The width of operations on bit fields greater than 32-bit is
implementation defined, and differs between GCC (which uses the bitfield
precision) and clang (which uses 64-bit arithmetic), so this is a
potential minefield.  Remove the bit fields and using manual masking
instead.

Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=2075036
Reported-by: Peter Xu <peterx@redhat.com>
Message-Id: <20220414152837.83320-1-peterx@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 .../selftests/kvm/lib/x86_64/processor.c      | 202 ++++++++----------
 1 file changed, 89 insertions(+), 113 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 9f000dfb5594..90c3d34ce80b 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -20,36 +20,18 @@
 vm_vaddr_t exception_handlers;
 
 /* Virtual translation table structure declarations */
-struct pageUpperEntry {
-	uint64_t present:1;
-	uint64_t writable:1;
-	uint64_t user:1;
-	uint64_t write_through:1;
-	uint64_t cache_disable:1;
-	uint64_t accessed:1;
-	uint64_t ignored_06:1;
-	uint64_t page_size:1;
-	uint64_t ignored_11_08:4;
-	uint64_t pfn:40;
-	uint64_t ignored_62_52:11;
-	uint64_t execute_disable:1;
-};
-
-struct pageTableEntry {
-	uint64_t present:1;
-	uint64_t writable:1;
-	uint64_t user:1;
-	uint64_t write_through:1;
-	uint64_t cache_disable:1;
-	uint64_t accessed:1;
-	uint64_t dirty:1;
-	uint64_t reserved_07:1;
-	uint64_t global:1;
-	uint64_t ignored_11_09:3;
-	uint64_t pfn:40;
-	uint64_t ignored_62_52:11;
-	uint64_t execute_disable:1;
-};
+#define PTE_PRESENT_MASK  (1ULL << 0)
+#define PTE_WRITABLE_MASK (1ULL << 1)
+#define PTE_USER_MASK     (1ULL << 2)
+#define PTE_ACCESSED_MASK (1ULL << 5)
+#define PTE_DIRTY_MASK    (1ULL << 6)
+#define PTE_LARGE_MASK    (1ULL << 7)
+#define PTE_GLOBAL_MASK   (1ULL << 8)
+#define PTE_NX_MASK       (1ULL << 63)
+
+#define PTE_PFN_MASK      0xFFFFFFFFFF000ULL
+#define PTE_PFN_SHIFT     12
+#define PTE_GET_PFN(pte) (((pte) & PTE_PFN_MASK) >> PTE_PFN_SHIFT)
 
 void regs_dump(FILE *stream, struct kvm_regs *regs,
 	       uint8_t indent)
@@ -195,23 +177,21 @@ static void *virt_get_pte(struct kvm_vm *vm, uint64_t pt_pfn, uint64_t vaddr,
 	return &page_table[index];
 }
 
-static struct pageUpperEntry *virt_create_upper_pte(struct kvm_vm *vm,
-						    uint64_t pt_pfn,
-						    uint64_t vaddr,
-						    uint64_t paddr,
-						    int level,
-						    enum x86_page_size page_size)
+static uint64_t *virt_create_upper_pte(struct kvm_vm *vm,
+				       uint64_t pt_pfn,
+				       uint64_t vaddr,
+				       uint64_t paddr,
+				       int level,
+				       enum x86_page_size page_size)
 {
-	struct pageUpperEntry *pte = virt_get_pte(vm, pt_pfn, vaddr, level);
-
-	if (!pte->present) {
-		pte->writable = true;
-		pte->present = true;
-		pte->page_size = (level == page_size);
-		if (pte->page_size)
-			pte->pfn = paddr >> vm->page_shift;
+	uint64_t *pte = virt_get_pte(vm, pt_pfn, vaddr, level);
+
+	if (!(*pte & PTE_PRESENT_MASK)) {
+		*pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK;
+		if (level == page_size)
+			*pte |= PTE_LARGE_MASK | (paddr & PTE_PFN_MASK);
 		else
-			pte->pfn = vm_alloc_page_table(vm) >> vm->page_shift;
+			*pte |= vm_alloc_page_table(vm) & PTE_PFN_MASK;
 	} else {
 		/*
 		 * Entry already present.  Assert that the caller doesn't want
@@ -221,7 +201,7 @@ static struct pageUpperEntry *virt_create_upper_pte(struct kvm_vm *vm,
 		TEST_ASSERT(level != page_size,
 			    "Cannot create hugepage at level: %u, vaddr: 0x%lx\n",
 			    page_size, vaddr);
-		TEST_ASSERT(!pte->page_size,
+		TEST_ASSERT(!(*pte & PTE_LARGE_MASK),
 			    "Cannot create page table at level: %u, vaddr: 0x%lx\n",
 			    level, vaddr);
 	}
@@ -232,8 +212,8 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 		   enum x86_page_size page_size)
 {
 	const uint64_t pg_size = 1ull << ((page_size * 9) + 12);
-	struct pageUpperEntry *pml4e, *pdpe, *pde;
-	struct pageTableEntry *pte;
+	uint64_t *pml4e, *pdpe, *pde;
+	uint64_t *pte;
 
 	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K,
 		    "Unknown or unsupported guest mode, mode: 0x%x", vm->mode);
@@ -257,24 +237,22 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 	 */
 	pml4e = virt_create_upper_pte(vm, vm->pgd >> vm->page_shift,
 				      vaddr, paddr, 3, page_size);
-	if (pml4e->page_size)
+	if (*pml4e & PTE_LARGE_MASK)
 		return;
 
-	pdpe = virt_create_upper_pte(vm, pml4e->pfn, vaddr, paddr, 2, page_size);
-	if (pdpe->page_size)
+	pdpe = virt_create_upper_pte(vm, PTE_GET_PFN(*pml4e), vaddr, paddr, 2, page_size);
+	if (*pdpe & PTE_LARGE_MASK)
 		return;
 
-	pde = virt_create_upper_pte(vm, pdpe->pfn, vaddr, paddr, 1, page_size);
-	if (pde->page_size)
+	pde = virt_create_upper_pte(vm, PTE_GET_PFN(*pdpe), vaddr, paddr, 1, page_size);
+	if (*pde & PTE_LARGE_MASK)
 		return;
 
 	/* Fill in page table entry. */
-	pte = virt_get_pte(vm, pde->pfn, vaddr, 0);
-	TEST_ASSERT(!pte->present,
+	pte = virt_get_pte(vm, PTE_GET_PFN(*pde), vaddr, 0);
+	TEST_ASSERT(!(*pte & PTE_PRESENT_MASK),
 		    "PTE already present for 4k page at vaddr: 0x%lx\n", vaddr);
-	pte->pfn = paddr >> vm->page_shift;
-	pte->writable = true;
-	pte->present = 1;
+	*pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK | (paddr & PTE_PFN_MASK);
 }
 
 void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
@@ -282,12 +260,12 @@ void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 	__virt_pg_map(vm, vaddr, paddr, X86_PAGE_SIZE_4K);
 }
 
-static struct pageTableEntry *_vm_get_page_table_entry(struct kvm_vm *vm, int vcpuid,
+static uint64_t *_vm_get_page_table_entry(struct kvm_vm *vm, int vcpuid,
 						       uint64_t vaddr)
 {
 	uint16_t index[4];
-	struct pageUpperEntry *pml4e, *pdpe, *pde;
-	struct pageTableEntry *pte;
+	uint64_t *pml4e, *pdpe, *pde;
+	uint64_t *pte;
 	struct kvm_cpuid_entry2 *entry;
 	struct kvm_sregs sregs;
 	int max_phy_addr;
@@ -329,30 +307,29 @@ static struct pageTableEntry *_vm_get_page_table_entry(struct kvm_vm *vm, int vc
 	index[3] = (vaddr >> 39) & 0x1ffu;
 
 	pml4e = addr_gpa2hva(vm, vm->pgd);
-	TEST_ASSERT(pml4e[index[3]].present,
+	TEST_ASSERT(pml4e[index[3]] & PTE_PRESENT_MASK,
 		"Expected pml4e to be present for gva: 0x%08lx", vaddr);
-	TEST_ASSERT((*(uint64_t*)(&pml4e[index[3]]) &
-		(rsvd_mask | (1ull << 7))) == 0,
+	TEST_ASSERT((pml4e[index[3]] & (rsvd_mask | PTE_LARGE_MASK)) == 0,
 		"Unexpected reserved bits set.");
 
-	pdpe = addr_gpa2hva(vm, pml4e[index[3]].pfn * vm->page_size);
-	TEST_ASSERT(pdpe[index[2]].present,
+	pdpe = addr_gpa2hva(vm, PTE_GET_PFN(pml4e[index[3]]) * vm->page_size);
+	TEST_ASSERT(pdpe[index[2]] & PTE_PRESENT_MASK,
 		"Expected pdpe to be present for gva: 0x%08lx", vaddr);
-	TEST_ASSERT(pdpe[index[2]].page_size == 0,
+	TEST_ASSERT(!(pdpe[index[2]] & PTE_LARGE_MASK),
 		"Expected pdpe to map a pde not a 1-GByte page.");
-	TEST_ASSERT((*(uint64_t*)(&pdpe[index[2]]) & rsvd_mask) == 0,
+	TEST_ASSERT((pdpe[index[2]] & rsvd_mask) == 0,
 		"Unexpected reserved bits set.");
 
-	pde = addr_gpa2hva(vm, pdpe[index[2]].pfn * vm->page_size);
-	TEST_ASSERT(pde[index[1]].present,
+	pde = addr_gpa2hva(vm, PTE_GET_PFN(pdpe[index[2]]) * vm->page_size);
+	TEST_ASSERT(pde[index[1]] & PTE_PRESENT_MASK,
 		"Expected pde to be present for gva: 0x%08lx", vaddr);
-	TEST_ASSERT(pde[index[1]].page_size == 0,
+	TEST_ASSERT(!(pde[index[1]] & PTE_LARGE_MASK),
 		"Expected pde to map a pte not a 2-MByte page.");
-	TEST_ASSERT((*(uint64_t*)(&pde[index[1]]) & rsvd_mask) == 0,
+	TEST_ASSERT((pde[index[1]] & rsvd_mask) == 0,
 		"Unexpected reserved bits set.");
 
-	pte = addr_gpa2hva(vm, pde[index[1]].pfn * vm->page_size);
-	TEST_ASSERT(pte[index[0]].present,
+	pte = addr_gpa2hva(vm, PTE_GET_PFN(pde[index[1]]) * vm->page_size);
+	TEST_ASSERT(pte[index[0]] & PTE_PRESENT_MASK,
 		"Expected pte to be present for gva: 0x%08lx", vaddr);
 
 	return &pte[index[0]];
@@ -360,7 +337,7 @@ static struct pageTableEntry *_vm_get_page_table_entry(struct kvm_vm *vm, int vc
 
 uint64_t vm_get_page_table_entry(struct kvm_vm *vm, int vcpuid, uint64_t vaddr)
 {
-	struct pageTableEntry *pte = _vm_get_page_table_entry(vm, vcpuid, vaddr);
+	uint64_t *pte = _vm_get_page_table_entry(vm, vcpuid, vaddr);
 
 	return *(uint64_t *)pte;
 }
@@ -368,18 +345,17 @@ uint64_t vm_get_page_table_entry(struct kvm_vm *vm, int vcpuid, uint64_t vaddr)
 void vm_set_page_table_entry(struct kvm_vm *vm, int vcpuid, uint64_t vaddr,
 			     uint64_t pte)
 {
-	struct pageTableEntry *new_pte = _vm_get_page_table_entry(vm, vcpuid,
-								  vaddr);
+	uint64_t *new_pte = _vm_get_page_table_entry(vm, vcpuid, vaddr);
 
 	*(uint64_t *)new_pte = pte;
 }
 
 void virt_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 {
-	struct pageUpperEntry *pml4e, *pml4e_start;
-	struct pageUpperEntry *pdpe, *pdpe_start;
-	struct pageUpperEntry *pde, *pde_start;
-	struct pageTableEntry *pte, *pte_start;
+	uint64_t *pml4e, *pml4e_start;
+	uint64_t *pdpe, *pdpe_start;
+	uint64_t *pde, *pde_start;
+	uint64_t *pte, *pte_start;
 
 	if (!vm->pgd_created)
 		return;
@@ -389,58 +365,58 @@ void virt_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 	fprintf(stream, "%*s      index hvaddr         gpaddr         "
 		"addr         w exec dirty\n",
 		indent, "");
-	pml4e_start = (struct pageUpperEntry *) addr_gpa2hva(vm, vm->pgd);
+	pml4e_start = (uint64_t *) addr_gpa2hva(vm, vm->pgd);
 	for (uint16_t n1 = 0; n1 <= 0x1ffu; n1++) {
 		pml4e = &pml4e_start[n1];
-		if (!pml4e->present)
+		if (!(*pml4e & PTE_PRESENT_MASK))
 			continue;
-		fprintf(stream, "%*spml4e 0x%-3zx %p 0x%-12lx 0x%-10lx %u "
+		fprintf(stream, "%*spml4e 0x%-3zx %p 0x%-12lx 0x%-10llx %u "
 			" %u\n",
 			indent, "",
 			pml4e - pml4e_start, pml4e,
-			addr_hva2gpa(vm, pml4e), (uint64_t) pml4e->pfn,
-			pml4e->writable, pml4e->execute_disable);
+			addr_hva2gpa(vm, pml4e), PTE_GET_PFN(*pml4e),
+			!!(*pml4e & PTE_WRITABLE_MASK), !!(*pml4e & PTE_NX_MASK));
 
-		pdpe_start = addr_gpa2hva(vm, pml4e->pfn * vm->page_size);
+		pdpe_start = addr_gpa2hva(vm, *pml4e & PTE_PFN_MASK);
 		for (uint16_t n2 = 0; n2 <= 0x1ffu; n2++) {
 			pdpe = &pdpe_start[n2];
-			if (!pdpe->present)
+			if (!(*pdpe & PTE_PRESENT_MASK))
 				continue;
-			fprintf(stream, "%*spdpe  0x%-3zx %p 0x%-12lx 0x%-10lx "
+			fprintf(stream, "%*spdpe  0x%-3zx %p 0x%-12lx 0x%-10llx "
 				"%u  %u\n",
 				indent, "",
 				pdpe - pdpe_start, pdpe,
 				addr_hva2gpa(vm, pdpe),
-				(uint64_t) pdpe->pfn, pdpe->writable,
-				pdpe->execute_disable);
+				PTE_GET_PFN(*pdpe), !!(*pdpe & PTE_WRITABLE_MASK),
+				!!(*pdpe & PTE_NX_MASK));
 
-			pde_start = addr_gpa2hva(vm, pdpe->pfn * vm->page_size);
+			pde_start = addr_gpa2hva(vm, *pdpe & PTE_PFN_MASK);
 			for (uint16_t n3 = 0; n3 <= 0x1ffu; n3++) {
 				pde = &pde_start[n3];
-				if (!pde->present)
+				if (!(*pde & PTE_PRESENT_MASK))
 					continue;
 				fprintf(stream, "%*spde   0x%-3zx %p "
-					"0x%-12lx 0x%-10lx %u  %u\n",
+					"0x%-12lx 0x%-10llx %u  %u\n",
 					indent, "", pde - pde_start, pde,
 					addr_hva2gpa(vm, pde),
-					(uint64_t) pde->pfn, pde->writable,
-					pde->execute_disable);
+					PTE_GET_PFN(*pde), !!(*pde & PTE_WRITABLE_MASK),
+					!!(*pde & PTE_NX_MASK));
 
-				pte_start = addr_gpa2hva(vm, pde->pfn * vm->page_size);
+				pte_start = addr_gpa2hva(vm, *pde & PTE_PFN_MASK);
 				for (uint16_t n4 = 0; n4 <= 0x1ffu; n4++) {
 					pte = &pte_start[n4];
-					if (!pte->present)
+					if (!(*pte & PTE_PRESENT_MASK))
 						continue;
 					fprintf(stream, "%*spte   0x%-3zx %p "
-						"0x%-12lx 0x%-10lx %u  %u "
+						"0x%-12lx 0x%-10llx %u  %u "
 						"    %u    0x%-10lx\n",
 						indent, "",
 						pte - pte_start, pte,
 						addr_hva2gpa(vm, pte),
-						(uint64_t) pte->pfn,
-						pte->writable,
-						pte->execute_disable,
-						pte->dirty,
+						PTE_GET_PFN(*pte),
+						!!(*pte & PTE_WRITABLE_MASK),
+						!!(*pte & PTE_NX_MASK),
+						!!(*pte & PTE_DIRTY_MASK),
 						((uint64_t) n1 << 27)
 							| ((uint64_t) n2 << 18)
 							| ((uint64_t) n3 << 9)
@@ -558,8 +534,8 @@ static void kvm_seg_set_kernel_data_64bit(struct kvm_vm *vm, uint16_t selector,
 vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 {
 	uint16_t index[4];
-	struct pageUpperEntry *pml4e, *pdpe, *pde;
-	struct pageTableEntry *pte;
+	uint64_t *pml4e, *pdpe, *pde;
+	uint64_t *pte;
 
 	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K, "Attempt to use "
 		"unknown or unsupported guest mode, mode: 0x%x", vm->mode);
@@ -572,22 +548,22 @@ vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 	if (!vm->pgd_created)
 		goto unmapped_gva;
 	pml4e = addr_gpa2hva(vm, vm->pgd);
-	if (!pml4e[index[3]].present)
+	if (!(pml4e[index[3]] & PTE_PRESENT_MASK))
 		goto unmapped_gva;
 
-	pdpe = addr_gpa2hva(vm, pml4e[index[3]].pfn * vm->page_size);
-	if (!pdpe[index[2]].present)
+	pdpe = addr_gpa2hva(vm, PTE_GET_PFN(pml4e[index[3]]) * vm->page_size);
+	if (!(pdpe[index[2]] & PTE_PRESENT_MASK))
 		goto unmapped_gva;
 
-	pde = addr_gpa2hva(vm, pdpe[index[2]].pfn * vm->page_size);
-	if (!pde[index[1]].present)
+	pde = addr_gpa2hva(vm, PTE_GET_PFN(pdpe[index[2]]) * vm->page_size);
+	if (!(pde[index[1]] & PTE_PRESENT_MASK))
 		goto unmapped_gva;
 
-	pte = addr_gpa2hva(vm, pde[index[1]].pfn * vm->page_size);
-	if (!pte[index[0]].present)
+	pte = addr_gpa2hva(vm, PTE_GET_PFN(pde[index[1]]) * vm->page_size);
+	if (!(pte[index[0]] & PTE_PRESENT_MASK))
 		goto unmapped_gva;
 
-	return (pte[index[0]].pfn * vm->page_size) + (gva & 0xfffu);
+	return (PTE_GET_PFN(pte[index[0]]) * vm->page_size) + (gva & 0xfffu);
 
 unmapped_gva:
 	TEST_FAIL("No mapping for vm virtual address, gva: 0x%lx", gva);
-- 
2.31.1

