Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08F165AF35B
	for <lists+kvm@lfdr.de>; Tue,  6 Sep 2022 20:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbiIFSKA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 14:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbiIFSJy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 14:09:54 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A18474E3F
        for <kvm@vger.kernel.org>; Tue,  6 Sep 2022 11:09:52 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-340ae84fb7dso95468667b3.17
        for <kvm@vger.kernel.org>; Tue, 06 Sep 2022 11:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=mBtx7H6gwduk2C5lu92clfmk+N0XgBE6Y3tpg2ksljk=;
        b=QGG0BLHi5GQGVos8uny6WdfWHTEk/bM6280oHgCBBKjbu2u8vwkv+iSmF8VQv6CuLt
         Xax2PcDtQCH34uXfFt6rUBA16uTkoe20L3yG+YWZ+k7U9hMYO08BfeFkGrviPEBwANbF
         Km9R8uAozFZfOnC+rctZ8b0mpONPXhU8lYEiDZr8/LxC6RbR0Afy2z4hVP/QP0TWTrDt
         y4ms4BFAjcF6rQx4LFLoc2HNbN3e7rxW9sCvRyBnxQspCmkoX53Txd94A0WFtU3pgQA3
         5noPb3aOi19GMeC7doV+VJf9ShAkz153udeMbN4FCFos26DPEdhhUL8aIKdHX0f0aRlA
         JQBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=mBtx7H6gwduk2C5lu92clfmk+N0XgBE6Y3tpg2ksljk=;
        b=nAVG3u+MB5C4ykwSFdhOIjPzULJ44a69AYAeDUbXT0U1ta26VGP0h4FQHBv2vXDfsB
         cXJdI43zw1qr1iViRvPbSR5xCJTEAdLE6CFXdF3zAVmcYaSw021HrfO0ubiEFxsBa4D/
         yQrfsXFcpQis6XCYyL3q8X8aOo4cJ4Nbbp0MK/JSdJOhsJfEYghRKYt/hYnHV3AMs6x2
         YADGvM+FqvcAuLaGpWumtfVduSeEmfP2/GmXSkKNyOe4jtLPccqjBOCAnNwoaEIw2lFj
         KAnOllqbGEA0bcT4UDa+4Soh1yZ0wGw70L6iErfEx26V8mpA4ydzkvIPQgxzrevzKXRr
         cIRA==
X-Gm-Message-State: ACgBeo0A0bjIIphhP7W3eh8FiNkovb56y/0JaxMnlETAgigyIITG+75X
        VYAJyE43FF+02EI78+8lzzWMmVnWtcWkXVt4r0QIqyrxm3e7vdQwqAA715XbavLM0acLwVm2074
        VLSIVH2iEWPJD8UFoOlc42/E70S0goUWHjYi6Ov1V+JK7NZO1CLP3waBmvw8ylO8=
X-Google-Smtp-Source: AA6agR4kv0PzDjV2w60M2r2X58B3mYrKh8mAIPqkG9zuEoIbK+EyZohvUNi+chAQbn8Dn66nq+5Wx5OoRdKAlw==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a0d:f201:0:b0:335:4933:6683 with SMTP id
 b1-20020a0df201000000b0033549336683mr42051742ywf.23.1662487790487; Tue, 06
 Sep 2022 11:09:50 -0700 (PDT)
Date:   Tue,  6 Sep 2022 18:09:25 +0000
In-Reply-To: <20220906180930.230218-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20220906180930.230218-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220906180930.230218-9-ricarkol@google.com>
Subject: [PATCH v6 08/13] KVM: selftests: Use the right memslot for code,
 page-tables, and data allocations
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, seanjc@google.com,
        alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com,
        reijiw@google.com, rananta@google.com, bgardon@google.com,
        dmatlack@google.com, axelrasmussen@google.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The previous commit added support for callers of ____vm_create() to specify
what memslots to use for code, page-tables, and data allocations. Change
them accordingly:

- stacks, code, and exception tables use the code memslot
- page tables and the pgd use the pt memslot
- data (anything allocated with vm_vaddr_alloc()) uses the data memslot

No functional change intended. All allocators keep using memslot #0.

Cc: Sean Christopherson <seanjc@google.com>
Cc: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  3 +
 .../selftests/kvm/lib/aarch64/processor.c     | 11 ++--
 tools/testing/selftests/kvm/lib/elf.c         |  3 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 57 ++++++++++++-------
 .../selftests/kvm/lib/riscv/processor.c       |  7 ++-
 .../selftests/kvm/lib/s390x/processor.c       |  7 ++-
 .../selftests/kvm/lib/x86_64/processor.c      | 13 +++--
 7 files changed, 61 insertions(+), 40 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 5dbca38a512b..76a087a88efd 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -402,7 +402,10 @@ void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
 void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
 struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id);
 vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
+vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz,
+			    vm_vaddr_t vaddr_min, enum kvm_mem_region_type mr);
 vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages);
+vm_vaddr_t __vm_vaddr_alloc_page(struct kvm_vm *vm, enum kvm_mem_region_type mr);
 vm_vaddr_t vm_vaddr_alloc_page(struct kvm_vm *vm);
 
 void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 5a31dc85d054..885b893a5f40 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -79,7 +79,7 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
 	if (!vm->pgd_created) {
 		vm_paddr_t paddr = vm_phy_pages_alloc(vm,
 			page_align(vm, ptrs_per_pgd(vm) * 8) / vm->page_size,
-			KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
+			KVM_GUEST_PAGE_TABLE_MIN_PADDR, vm->memslots[MEM_REGION_PT]);
 		vm->pgd = paddr;
 		vm->pgd_created = true;
 	}
@@ -328,8 +328,9 @@ struct kvm_vcpu *aarch64_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
 	size_t stack_size = vm->page_size == 4096 ?
 					DEFAULT_STACK_PGS * vm->page_size :
 					vm->page_size;
-	uint64_t stack_vaddr = vm_vaddr_alloc(vm, stack_size,
-					      DEFAULT_ARM64_GUEST_STACK_VADDR_MIN);
+	uint64_t stack_vaddr = __vm_vaddr_alloc(vm, stack_size,
+						DEFAULT_ARM64_GUEST_STACK_VADDR_MIN,
+						MEM_REGION_CODE);
 	struct kvm_vcpu *vcpu = __vm_vcpu_add(vm, vcpu_id);
 
 	aarch64_vcpu_setup(vcpu, init);
@@ -435,8 +436,8 @@ void route_exception(struct ex_regs *regs, int vector)
 
 void vm_init_descriptor_tables(struct kvm_vm *vm)
 {
-	vm->handlers = vm_vaddr_alloc(vm, sizeof(struct handlers),
-			vm->page_size);
+	vm->handlers = __vm_vaddr_alloc(vm, sizeof(struct handlers),
+					vm->page_size, MEM_REGION_CODE);
 
 	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
 }
diff --git a/tools/testing/selftests/kvm/lib/elf.c b/tools/testing/selftests/kvm/lib/elf.c
index 9f54c098d9d0..51f280c412ba 100644
--- a/tools/testing/selftests/kvm/lib/elf.c
+++ b/tools/testing/selftests/kvm/lib/elf.c
@@ -161,7 +161,8 @@ void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename)
 		seg_vend |= vm->page_size - 1;
 		size_t seg_size = seg_vend - seg_vstart + 1;
 
-		vm_vaddr_t vaddr = vm_vaddr_alloc(vm, seg_size, seg_vstart);
+		vm_vaddr_t vaddr = __vm_vaddr_alloc(vm, seg_size, seg_vstart,
+						    MEM_REGION_CODE);
 		TEST_ASSERT(vaddr == seg_vstart, "Unable to allocate "
 			"virtual memory for segment at requested min addr,\n"
 			"  segment idx: %u\n"
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 02532bc528da..ff457af44c53 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1226,32 +1226,15 @@ static vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz,
 	return pgidx_start * vm->page_size;
 }
 
-/*
- * VM Virtual Address Allocate
- *
- * Input Args:
- *   vm - Virtual Machine
- *   sz - Size in bytes
- *   vaddr_min - Minimum starting virtual address
- *
- * Output Args: None
- *
- * Return:
- *   Starting guest virtual address
- *
- * Allocates at least sz bytes within the virtual address space of the vm
- * given by vm.  The allocated bytes are mapped to a virtual address >=
- * the address given by vaddr_min.  Note that each allocation uses a
- * a unique set of pages, with the minimum real allocation being at least
- * a page.
- */
-vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min)
+vm_vaddr_t __vm_vaddr_alloc(struct kvm_vm *vm, size_t sz,
+			    vm_vaddr_t vaddr_min, enum kvm_mem_region_type mrt)
 {
 	uint64_t pages = (sz >> vm->page_shift) + ((sz % vm->page_size) != 0);
 
 	virt_pgd_alloc(vm);
 	vm_paddr_t paddr = vm_phy_pages_alloc(vm, pages,
-					      KVM_UTIL_MIN_PFN * vm->page_size, 0);
+				KVM_UTIL_MIN_PFN * vm->page_size,
+				vm->memslots[mrt]);
 
 	/*
 	 * Find an unused range of virtual page addresses of at least
@@ -1272,6 +1255,30 @@ vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min)
 	return vaddr_start;
 }
 
+/*
+ * VM Virtual Address Allocate
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *   sz - Size in bytes
+ *   vaddr_min - Minimum starting virtual address
+ *
+ * Output Args: None
+ *
+ * Return:
+ *   Starting guest virtual address
+ *
+ * Allocates at least sz bytes within the virtual address space of the vm
+ * given by vm.  The allocated bytes are mapped to a virtual address >=
+ * the address given by vaddr_min.  Note that each allocation uses a
+ * a unique set of pages, with the minimum real allocation being at least
+ * a page. The allocated physical space comes from the data memory region.
+ */
+vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min)
+{
+	return __vm_vaddr_alloc(vm, sz, vaddr_min, MEM_REGION_DATA);
+}
+
 /*
  * VM Virtual Address Allocate Pages
  *
@@ -1291,6 +1298,11 @@ vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages)
 	return vm_vaddr_alloc(vm, nr_pages * getpagesize(), KVM_UTIL_MIN_VADDR);
 }
 
+vm_vaddr_t __vm_vaddr_alloc_page(struct kvm_vm *vm, enum kvm_mem_region_type mrt)
+{
+	return __vm_vaddr_alloc(vm, getpagesize(), KVM_UTIL_MIN_VADDR, mrt);
+}
+
 /*
  * VM Virtual Address Allocate Page
  *
@@ -1856,7 +1868,8 @@ vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
 
 vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm)
 {
-	return vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
+	return vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR,
+				 vm->memslots[MEM_REGION_PT]);
 }
 
 /*
diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
index 604478151212..26c8d3dffb9a 100644
--- a/tools/testing/selftests/kvm/lib/riscv/processor.c
+++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
@@ -58,7 +58,7 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
 	if (!vm->pgd_created) {
 		vm_paddr_t paddr = vm_phy_pages_alloc(vm,
 			page_align(vm, ptrs_per_pte(vm) * 8) / vm->page_size,
-			KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
+			KVM_GUEST_PAGE_TABLE_MIN_PADDR, vm->memslots[MEM_REGION_PT]);
 		vm->pgd = paddr;
 		vm->pgd_created = true;
 	}
@@ -282,8 +282,9 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
 	size_t stack_size = vm->page_size == 4096 ?
 					DEFAULT_STACK_PGS * vm->page_size :
 					vm->page_size;
-	unsigned long stack_vaddr = vm_vaddr_alloc(vm, stack_size,
-					DEFAULT_RISCV_GUEST_STACK_VADDR_MIN);
+	unsigned long stack_vaddr = __vm_vaddr_alloc(vm, stack_size,
+					DEFAULT_RISCV_GUEST_STACK_VADDR_MIN,
+					MEM_REGION_CODE);
 	unsigned long current_gp = 0;
 	struct kvm_mp_state mps;
 	struct kvm_vcpu *vcpu;
diff --git a/tools/testing/selftests/kvm/lib/s390x/processor.c b/tools/testing/selftests/kvm/lib/s390x/processor.c
index 89d7340d9cbd..410ae2b59847 100644
--- a/tools/testing/selftests/kvm/lib/s390x/processor.c
+++ b/tools/testing/selftests/kvm/lib/s390x/processor.c
@@ -21,7 +21,7 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
 		return;
 
 	paddr = vm_phy_pages_alloc(vm, PAGES_PER_REGION,
-				   KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
+			KVM_GUEST_PAGE_TABLE_MIN_PADDR, vm->memslots[MEM_REGION_PT]);
 	memset(addr_gpa2hva(vm, paddr), 0xff, PAGES_PER_REGION * vm->page_size);
 
 	vm->pgd = paddr;
@@ -167,8 +167,9 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
 	TEST_ASSERT(vm->page_size == 4096, "Unsupported page size: 0x%x",
 		    vm->page_size);
 
-	stack_vaddr = vm_vaddr_alloc(vm, stack_size,
-				     DEFAULT_GUEST_STACK_VADDR_MIN);
+	stack_vaddr = __vm_vaddr_alloc(vm, stack_size,
+				       DEFAULT_GUEST_STACK_VADDR_MIN,
+				       MEM_REGION_CODE);
 
 	vcpu = __vm_vcpu_add(vm, vcpu_id);
 
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 2e6e61bbe81b..f7b90a6c7d19 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -525,7 +525,7 @@ vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 static void kvm_setup_gdt(struct kvm_vm *vm, struct kvm_dtable *dt)
 {
 	if (!vm->gdt)
-		vm->gdt = vm_vaddr_alloc_page(vm);
+		vm->gdt = __vm_vaddr_alloc_page(vm, MEM_REGION_CODE);
 
 	dt->base = vm->gdt;
 	dt->limit = getpagesize();
@@ -535,7 +535,7 @@ static void kvm_setup_tss_64bit(struct kvm_vm *vm, struct kvm_segment *segp,
 				int selector)
 {
 	if (!vm->tss)
-		vm->tss = vm_vaddr_alloc_page(vm);
+		vm->tss = __vm_vaddr_alloc_page(vm, MEM_REGION_CODE);
 
 	memset(segp, 0, sizeof(*segp));
 	segp->base = vm->tss;
@@ -620,8 +620,9 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
 	vm_vaddr_t stack_vaddr;
 	struct kvm_vcpu *vcpu;
 
-	stack_vaddr = vm_vaddr_alloc(vm, DEFAULT_STACK_PGS * getpagesize(),
-				     DEFAULT_GUEST_STACK_VADDR_MIN);
+	stack_vaddr = __vm_vaddr_alloc(vm, DEFAULT_STACK_PGS * getpagesize(),
+				       DEFAULT_GUEST_STACK_VADDR_MIN,
+				       MEM_REGION_CODE);
 
 	vcpu = __vm_vcpu_add(vm, vcpu_id);
 	vcpu_init_cpuid(vcpu, kvm_get_supported_cpuid());
@@ -1118,8 +1119,8 @@ void vm_init_descriptor_tables(struct kvm_vm *vm)
 	extern void *idt_handlers;
 	int i;
 
-	vm->idt = vm_vaddr_alloc_page(vm);
-	vm->handlers = vm_vaddr_alloc_page(vm);
+	vm->idt = __vm_vaddr_alloc_page(vm, MEM_REGION_CODE);
+	vm->handlers = __vm_vaddr_alloc_page(vm, MEM_REGION_CODE);
 	/* Handlers have the same address in both address spaces.*/
 	for (i = 0; i < NUM_INTERRUPTS; i++)
 		set_idt_entry(vm, i, (unsigned long)(&idt_handlers)[i], 0,
-- 
2.37.2.789.g6183377224-goog

