Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 452FB4D4FA3
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 17:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243846AbiCJQrF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 11:47:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240945AbiCJQrA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 11:47:00 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61415163D4C
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 08:45:57 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id v1-20020a25fc01000000b006289a83ed20so4880134ybd.7
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 08:45:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=LgzUuiV3i4GTw4ek7OK0jYRmP4wJZt05xSkMjC1DGeY=;
        b=raZMY8NwGJVOQ4m+NWTLQtqfiIxGD4q/xwlNolusyOtrRRxgHlsRDT0ZtZBYbor69Q
         tNsPTILei0AP5B2S4fIGSFJHoDRXgoo2wfjGd8G31y5knsy4gXURr6yY5ZfSiNX3zUR5
         0J2aXv7APhaz2CAW0VLQQMttzdOmAK/xyZNdAowtCibemE1lmRagN9rfqER8s+dvQXIg
         6BDTQ6kgrN9uqIqdAGlVeuiM+QOIvQaB0fnSkZRVt/mZ5megnHvwdUqj0JTG2tULRQvE
         juqvZ9/3PrCEhwxo6+dPwuruiESPJXQGtts9qj3a/vVVcGY6vkvHBEkO0m3mQsaarzEU
         Vv5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=LgzUuiV3i4GTw4ek7OK0jYRmP4wJZt05xSkMjC1DGeY=;
        b=YS8jONK5195xGwCFoH2n3atU/d4KQ5NDTCxrSKJqH3ntKuu0WlEOlYcx8DxDflLZil
         Epk+B1eRk7J0YfHsEORjtkk6gT8Cpi/2yoI2sLZvf14KPvlb+tHR9geHasseblo3mS15
         HwbMFsVpgkDFGAScX47xkEITHk+mYjyuZlaWKrWKD9D5K/R4sM/mA4eprenzE1nym9K5
         XN8KVUaBR5IZJSoo+6v71MGtyl7TAdADDWR/uuTLQeHpfxLKuCrLRvc0wdUTTVOw1aa8
         XqS2fn9YfVE9BfXDYEnvZJFYRgj1G53LRElLSM3Ap1rsp5uglCA4xn6qGIe3QlFwoJlM
         W4JA==
X-Gm-Message-State: AOAM530ukuojFU3qZXg/0ePYk87ORsI9FNzxvVWLffQI3AydjGQl/+DP
        lM/0eO5djPYO5s0g8ptAQCS9wo6xB2CP
X-Google-Smtp-Source: ABdhPJzmpQbXz1Us8j+DQXhr8RJuWVh+zTgua5lJQX3HkOChlmTKcQft7+VABR/f+362DLfhc0OKa/oBeBei
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:2d58:733f:1853:8e86])
 (user=bgardon job=sendgmr) by 2002:a81:9844:0:b0:2db:db74:f7db with SMTP id
 p65-20020a819844000000b002dbdb74f7dbmr4719925ywg.359.1646930756373; Thu, 10
 Mar 2022 08:45:56 -0800 (PST)
Date:   Thu, 10 Mar 2022 08:45:23 -0800
In-Reply-To: <20220310164532.1821490-1-bgardon@google.com>
Message-Id: <20220310164532.1821490-5-bgardon@google.com>
Mime-Version: 1.0
References: <20220310164532.1821490-1-bgardon@google.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
Subject: [PATCH 04/13] selftests: KVM: Add memslot parameter to VM vaddr allocation
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>
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

Currently, the vm_vaddr_alloc functions implicitly allocate in memslot
0. Add an argument to allow allocations in any memslot. This will be
used in future commits to allow loading code in a test memslot with
different backing memory types.

No functional change intended.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  8 ++++---
 .../selftests/kvm/lib/aarch64/processor.c     |  5 +++--
 tools/testing/selftests/kvm/lib/elf.c         |  3 ++-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 17 +++++++-------
 .../selftests/kvm/lib/riscv/processor.c       |  3 ++-
 .../selftests/kvm/lib/s390x/processor.c       |  3 ++-
 .../selftests/kvm/lib/x86_64/processor.c      | 11 +++++-----
 tools/testing/selftests/kvm/lib/x86_64/svm.c  |  8 +++----
 tools/testing/selftests/kvm/lib/x86_64/vmx.c  | 22 +++++++++----------
 tools/testing/selftests/kvm/x86_64/amx_test.c |  6 ++---
 .../testing/selftests/kvm/x86_64/cpuid_test.c |  2 +-
 .../selftests/kvm/x86_64/hyperv_clock.c       |  2 +-
 .../selftests/kvm/x86_64/hyperv_features.c    |  6 ++---
 .../selftests/kvm/x86_64/kvm_clock_test.c     |  2 +-
 .../selftests/kvm/x86_64/xapic_ipi_test.c     |  2 +-
 15 files changed, 54 insertions(+), 46 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 69a6b5e509ab..f70dfa3e1202 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -181,9 +181,11 @@ void vm_mem_region_move(struct kvm_vm *vm, struct kvm_memslot memslot,
 			uint64_t new_gpa);
 void vm_mem_region_delete(struct kvm_vm *vm, struct kvm_memslot memslot);
 void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid);
-vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
-vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages);
-vm_vaddr_t vm_vaddr_alloc_page(struct kvm_vm *vm);
+vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
+			  struct kvm_memslot memslot);
+vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages,
+				struct kvm_memslot memslot);
+vm_vaddr_t vm_vaddr_alloc_page(struct kvm_vm *vm, struct kvm_memslot memslot);
 
 void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 	      unsigned int npages);
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index a9e505e351e0..163746259d93 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -322,7 +322,8 @@ void aarch64_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid,
 					DEFAULT_STACK_PGS * vm->page_size :
 					vm->page_size;
 	uint64_t stack_vaddr = vm_vaddr_alloc(vm, stack_size,
-					      DEFAULT_ARM64_GUEST_STACK_VADDR_MIN);
+					      DEFAULT_ARM64_GUEST_STACK_VADDR_MIN,
+					      MEMSLOT(0));
 
 	vm_vcpu_add(vm, vcpuid);
 	aarch64_vcpu_setup(vm, vcpuid, init);
@@ -426,7 +427,7 @@ void route_exception(struct ex_regs *regs, int vector)
 void vm_init_descriptor_tables(struct kvm_vm *vm)
 {
 	vm->handlers = vm_vaddr_alloc(vm, sizeof(struct handlers),
-			vm->page_size);
+			vm->page_size, MEMSLOT(0));
 
 	*(vm_vaddr_t *)addr_gva2hva(vm, (vm_vaddr_t)(&exception_handlers)) = vm->handlers;
 }
diff --git a/tools/testing/selftests/kvm/lib/elf.c b/tools/testing/selftests/kvm/lib/elf.c
index 13e8e3dcf984..88d03cb80423 100644
--- a/tools/testing/selftests/kvm/lib/elf.c
+++ b/tools/testing/selftests/kvm/lib/elf.c
@@ -162,7 +162,8 @@ void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename)
 		seg_vend |= vm->page_size - 1;
 		size_t seg_size = seg_vend - seg_vstart + 1;
 
-		vm_vaddr_t vaddr = vm_vaddr_alloc(vm, seg_size, seg_vstart);
+		vm_vaddr_t vaddr = vm_vaddr_alloc(vm, seg_size, seg_vstart,
+						  MEMSLOT(0));
 		TEST_ASSERT(vaddr == seg_vstart, "Unable to allocate "
 			"virtual memory for segment at requested min addr,\n"
 			"  segment idx: %u\n"
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 97d1badaba8b..04abfc7e6b5c 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1340,8 +1340,7 @@ static vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz,
  *   vm - Virtual Machine
  *   sz - Size in bytes
  *   vaddr_min - Minimum starting virtual address
- *   data_memslot - Memory region slot for data pages
- *   pgd_memslot - Memory region slot for new virtual translation tables
+ *   memslot - Memory region slot for data pages
  *
  * Output Args: None
  *
@@ -1354,14 +1353,15 @@ static vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz,
  * a unique set of pages, with the minimum real allocation being at least
  * a page.
  */
-vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min)
+vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
+			  struct kvm_memslot memslot)
 {
 	uint64_t pages = (sz >> vm->page_shift) + ((sz % vm->page_size) != 0);
 
 	virt_pgd_alloc(vm);
 	vm_paddr_t paddr = vm_phy_pages_alloc(vm, pages,
 					      KVM_UTIL_MIN_PFN * vm->page_size,
-					      MEMSLOT(0));
+					      memslot);
 
 	/*
 	 * Find an unused range of virtual page addresses of at least
@@ -1396,9 +1396,10 @@ vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min)
  * Allocates at least N system pages worth of bytes within the virtual address
  * space of the vm.
  */
-vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages)
+vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages,
+				struct kvm_memslot memslot)
 {
-	return vm_vaddr_alloc(vm, nr_pages * getpagesize(), KVM_UTIL_MIN_VADDR);
+	return vm_vaddr_alloc(vm, nr_pages * getpagesize(), KVM_UTIL_MIN_VADDR, memslot);
 }
 
 /*
@@ -1415,9 +1416,9 @@ vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages)
  * Allocates at least one system page worth of bytes within the virtual address
  * space of the vm.
  */
-vm_vaddr_t vm_vaddr_alloc_page(struct kvm_vm *vm)
+vm_vaddr_t vm_vaddr_alloc_page(struct kvm_vm *vm, struct kvm_memslot memslot)
 {
-	return vm_vaddr_alloc_pages(vm, 1);
+	return vm_vaddr_alloc_pages(vm, 1, memslot);
 }
 
 /*
diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
index 7a0ff26b9f8d..9b554d6939a5 100644
--- a/tools/testing/selftests/kvm/lib/riscv/processor.c
+++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
@@ -281,7 +281,8 @@ void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code)
 					DEFAULT_STACK_PGS * vm->page_size :
 					vm->page_size;
 	unsigned long stack_vaddr = vm_vaddr_alloc(vm, stack_size,
-					DEFAULT_RISCV_GUEST_STACK_VADDR_MIN);
+					DEFAULT_RISCV_GUEST_STACK_VADDR_MIN,
+					MEMSLOT(0));
 	unsigned long current_gp = 0;
 	struct kvm_mp_state mps;
 
diff --git a/tools/testing/selftests/kvm/lib/s390x/processor.c b/tools/testing/selftests/kvm/lib/s390x/processor.c
index 1c873a26e6de..edcba350dbef 100644
--- a/tools/testing/selftests/kvm/lib/s390x/processor.c
+++ b/tools/testing/selftests/kvm/lib/s390x/processor.c
@@ -169,7 +169,8 @@ void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code)
 		    vm->page_size);
 
 	stack_vaddr = vm_vaddr_alloc(vm, stack_size,
-				     DEFAULT_GUEST_STACK_VADDR_MIN);
+				     DEFAULT_GUEST_STACK_VADDR_MIN,
+				     MEMSLOT(0));
 
 	vm_vcpu_add(vm, vcpuid);
 
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 9f000dfb5594..afcc13655790 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -597,7 +597,7 @@ vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 static void kvm_setup_gdt(struct kvm_vm *vm, struct kvm_dtable *dt)
 {
 	if (!vm->gdt)
-		vm->gdt = vm_vaddr_alloc_page(vm);
+		vm->gdt = vm_vaddr_alloc_page(vm, MEMSLOT(0));
 
 	dt->base = vm->gdt;
 	dt->limit = getpagesize();
@@ -607,7 +607,7 @@ static void kvm_setup_tss_64bit(struct kvm_vm *vm, struct kvm_segment *segp,
 				int selector)
 {
 	if (!vm->tss)
-		vm->tss = vm_vaddr_alloc_page(vm);
+		vm->tss = vm_vaddr_alloc_page(vm, MEMSLOT(0));
 
 	memset(segp, 0, sizeof(*segp));
 	segp->base = vm->tss;
@@ -710,7 +710,8 @@ void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code)
 	struct kvm_regs regs;
 	vm_vaddr_t stack_vaddr;
 	stack_vaddr = vm_vaddr_alloc(vm, DEFAULT_STACK_PGS * getpagesize(),
-				     DEFAULT_GUEST_STACK_VADDR_MIN);
+				     DEFAULT_GUEST_STACK_VADDR_MIN,
+				     MEMSLOT(0));
 
 	/* Create VCPU */
 	vm_vcpu_add(vm, vcpuid);
@@ -1377,8 +1378,8 @@ void vm_init_descriptor_tables(struct kvm_vm *vm)
 	extern void *idt_handlers;
 	int i;
 
-	vm->idt = vm_vaddr_alloc_page(vm);
-	vm->handlers = vm_vaddr_alloc_page(vm);
+	vm->idt = vm_vaddr_alloc_page(vm, MEMSLOT(0));
+	vm->handlers = vm_vaddr_alloc_page(vm, MEMSLOT(0));
 	/* Handlers have the same address in both address spaces.*/
 	for (i = 0; i < NUM_INTERRUPTS; i++)
 		set_idt_entry(vm, i, (unsigned long)(&idt_handlers)[i], 0,
diff --git a/tools/testing/selftests/kvm/lib/x86_64/svm.c b/tools/testing/selftests/kvm/lib/x86_64/svm.c
index 736ee4a23df6..6d935cc1225a 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/svm.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/svm.c
@@ -32,18 +32,18 @@ u64 rflags;
 struct svm_test_data *
 vcpu_alloc_svm(struct kvm_vm *vm, vm_vaddr_t *p_svm_gva)
 {
-	vm_vaddr_t svm_gva = vm_vaddr_alloc_page(vm);
+	vm_vaddr_t svm_gva = vm_vaddr_alloc_page(vm, MEMSLOT(0));
 	struct svm_test_data *svm = addr_gva2hva(vm, svm_gva);
 
-	svm->vmcb = (void *)vm_vaddr_alloc_page(vm);
+	svm->vmcb = (void *)vm_vaddr_alloc_page(vm, MEMSLOT(0));
 	svm->vmcb_hva = addr_gva2hva(vm, (uintptr_t)svm->vmcb);
 	svm->vmcb_gpa = addr_gva2gpa(vm, (uintptr_t)svm->vmcb);
 
-	svm->save_area = (void *)vm_vaddr_alloc_page(vm);
+	svm->save_area = (void *)vm_vaddr_alloc_page(vm, MEMSLOT(0));
 	svm->save_area_hva = addr_gva2hva(vm, (uintptr_t)svm->save_area);
 	svm->save_area_gpa = addr_gva2gpa(vm, (uintptr_t)svm->save_area);
 
-	svm->msr = (void *)vm_vaddr_alloc_page(vm);
+	svm->msr = (void *)vm_vaddr_alloc_page(vm, MEMSLOT(0));
 	svm->msr_hva = addr_gva2hva(vm, (uintptr_t)svm->msr);
 	svm->msr_gpa = addr_gva2gpa(vm, (uintptr_t)svm->msr);
 	memset(svm->msr_hva, 0, getpagesize());
diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
index 7ea9455b3e71..3678969e992a 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
@@ -77,48 +77,48 @@ int vcpu_enable_evmcs(struct kvm_vm *vm, int vcpu_id)
 struct vmx_pages *
 vcpu_alloc_vmx(struct kvm_vm *vm, vm_vaddr_t *p_vmx_gva)
 {
-	vm_vaddr_t vmx_gva = vm_vaddr_alloc_page(vm);
+	vm_vaddr_t vmx_gva = vm_vaddr_alloc_page(vm, MEMSLOT(0));
 	struct vmx_pages *vmx = addr_gva2hva(vm, vmx_gva);
 
 	/* Setup of a region of guest memory for the vmxon region. */
-	vmx->vmxon = (void *)vm_vaddr_alloc_page(vm);
+	vmx->vmxon = (void *)vm_vaddr_alloc_page(vm, MEMSLOT(0));
 	vmx->vmxon_hva = addr_gva2hva(vm, (uintptr_t)vmx->vmxon);
 	vmx->vmxon_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->vmxon);
 
 	/* Setup of a region of guest memory for a vmcs. */
-	vmx->vmcs = (void *)vm_vaddr_alloc_page(vm);
+	vmx->vmcs = (void *)vm_vaddr_alloc_page(vm, MEMSLOT(0));
 	vmx->vmcs_hva = addr_gva2hva(vm, (uintptr_t)vmx->vmcs);
 	vmx->vmcs_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->vmcs);
 
 	/* Setup of a region of guest memory for the MSR bitmap. */
-	vmx->msr = (void *)vm_vaddr_alloc_page(vm);
+	vmx->msr = (void *)vm_vaddr_alloc_page(vm, MEMSLOT(0));
 	vmx->msr_hva = addr_gva2hva(vm, (uintptr_t)vmx->msr);
 	vmx->msr_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->msr);
 	memset(vmx->msr_hva, 0, getpagesize());
 
 	/* Setup of a region of guest memory for the shadow VMCS. */
-	vmx->shadow_vmcs = (void *)vm_vaddr_alloc_page(vm);
+	vmx->shadow_vmcs = (void *)vm_vaddr_alloc_page(vm, MEMSLOT(0));
 	vmx->shadow_vmcs_hva = addr_gva2hva(vm, (uintptr_t)vmx->shadow_vmcs);
 	vmx->shadow_vmcs_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->shadow_vmcs);
 
 	/* Setup of a region of guest memory for the VMREAD and VMWRITE bitmaps. */
-	vmx->vmread = (void *)vm_vaddr_alloc_page(vm);
+	vmx->vmread = (void *)vm_vaddr_alloc_page(vm, MEMSLOT(0));
 	vmx->vmread_hva = addr_gva2hva(vm, (uintptr_t)vmx->vmread);
 	vmx->vmread_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->vmread);
 	memset(vmx->vmread_hva, 0, getpagesize());
 
-	vmx->vmwrite = (void *)vm_vaddr_alloc_page(vm);
+	vmx->vmwrite = (void *)vm_vaddr_alloc_page(vm, MEMSLOT(0));
 	vmx->vmwrite_hva = addr_gva2hva(vm, (uintptr_t)vmx->vmwrite);
 	vmx->vmwrite_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->vmwrite);
 	memset(vmx->vmwrite_hva, 0, getpagesize());
 
 	/* Setup of a region of guest memory for the VP Assist page. */
-	vmx->vp_assist = (void *)vm_vaddr_alloc_page(vm);
+	vmx->vp_assist = (void *)vm_vaddr_alloc_page(vm, MEMSLOT(0));
 	vmx->vp_assist_hva = addr_gva2hva(vm, (uintptr_t)vmx->vp_assist);
 	vmx->vp_assist_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->vp_assist);
 
 	/* Setup of a region of guest memory for the enlightened VMCS. */
-	vmx->enlightened_vmcs = (void *)vm_vaddr_alloc_page(vm);
+	vmx->enlightened_vmcs = (void *)vm_vaddr_alloc_page(vm, MEMSLOT(0));
 	vmx->enlightened_vmcs_hva =
 		addr_gva2hva(vm, (uintptr_t)vmx->enlightened_vmcs);
 	vmx->enlightened_vmcs_gpa =
@@ -528,14 +528,14 @@ void nested_map_memslot(struct vmx_pages *vmx, struct kvm_vm *vm,
 void prepare_eptp(struct vmx_pages *vmx, struct kvm_vm *vm,
 		  struct kvm_memslot eptp_memslot)
 {
-	vmx->eptp = (void *)vm_vaddr_alloc_page(vm);
+	vmx->eptp = (void *)vm_vaddr_alloc_page(vm, MEMSLOT(0));
 	vmx->eptp_hva = addr_gva2hva(vm, (uintptr_t)vmx->eptp);
 	vmx->eptp_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->eptp);
 }
 
 void prepare_virtualize_apic_accesses(struct vmx_pages *vmx, struct kvm_vm *vm)
 {
-	vmx->apic_access = (void *)vm_vaddr_alloc_page(vm);
+	vmx->apic_access = (void *)vm_vaddr_alloc_page(vm, MEMSLOT(0));
 	vmx->apic_access_hva = addr_gva2hva(vm, (uintptr_t)vmx->apic_access);
 	vmx->apic_access_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->apic_access);
 }
diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
index 52a3ef6629e8..2c12a3bf1f62 100644
--- a/tools/testing/selftests/kvm/x86_64/amx_test.c
+++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
@@ -360,15 +360,15 @@ int main(int argc, char *argv[])
 	vm_install_exception_handler(vm, NM_VECTOR, guest_nm_handler);
 
 	/* amx cfg for guest_code */
-	amx_cfg = vm_vaddr_alloc_page(vm);
+	amx_cfg = vm_vaddr_alloc_page(vm, MEMSLOT(0));
 	memset(addr_gva2hva(vm, amx_cfg), 0x0, getpagesize());
 
 	/* amx tiledata for guest_code */
-	tiledata = vm_vaddr_alloc_pages(vm, 2);
+	tiledata = vm_vaddr_alloc_pages(vm, 2, MEMSLOT(0));
 	memset(addr_gva2hva(vm, tiledata), rand() | 1, 2 * getpagesize());
 
 	/* xsave data for guest_code */
-	xsavedata = vm_vaddr_alloc_pages(vm, 3);
+	xsavedata = vm_vaddr_alloc_pages(vm, 3, MEMSLOT(0));
 	memset(addr_gva2hva(vm, xsavedata), 0, 3 * getpagesize());
 	vcpu_args_set(vm, VCPU_ID, 3, amx_cfg, tiledata, xsavedata);
 
diff --git a/tools/testing/selftests/kvm/x86_64/cpuid_test.c b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
index 16d2465c5634..d0250f32d729 100644
--- a/tools/testing/selftests/kvm/x86_64/cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
@@ -145,7 +145,7 @@ static void run_vcpu(struct kvm_vm *vm, uint32_t vcpuid, int stage)
 struct kvm_cpuid2 *vcpu_alloc_cpuid(struct kvm_vm *vm, vm_vaddr_t *p_gva, struct kvm_cpuid2 *cpuid)
 {
 	int size = sizeof(*cpuid) + cpuid->nent * sizeof(cpuid->entries[0]);
-	vm_vaddr_t gva = vm_vaddr_alloc(vm, size, KVM_UTIL_MIN_VADDR);
+	vm_vaddr_t gva = vm_vaddr_alloc(vm, size, KVM_UTIL_MIN_VADDR, MEMSLOT(0));
 	struct kvm_cpuid2 *guest_cpuids = addr_gva2hva(vm, gva);
 
 	memcpy(guest_cpuids, cpuid, size);
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
index e0b2bb1339b1..8cc31ce181a0 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
@@ -214,7 +214,7 @@ int main(void)
 
 	vcpu_set_hv_cpuid(vm, VCPU_ID);
 
-	tsc_page_gva = vm_vaddr_alloc_page(vm);
+	tsc_page_gva = vm_vaddr_alloc_page(vm, MEMSLOT(0));
 	memset(addr_gva2hva(vm, tsc_page_gva), 0x0, getpagesize());
 	TEST_ASSERT((addr_gva2gpa(vm, tsc_page_gva) & (getpagesize() - 1)) == 0,
 		"TSC page has to be page aligned\n");
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
index 672915ce73d8..64cbb2cabcda 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
@@ -191,7 +191,7 @@ static void guest_test_msrs_access(void)
 	while (true) {
 		vm = vm_create_default(VCPU_ID, 0, guest_msr);
 
-		msr_gva = vm_vaddr_alloc_page(vm);
+		msr_gva = vm_vaddr_alloc_page(vm, MEMSLOT(0));
 		memset(addr_gva2hva(vm, msr_gva), 0x0, getpagesize());
 		msr = addr_gva2hva(vm, msr_gva);
 
@@ -534,11 +534,11 @@ static void guest_test_hcalls_access(void)
 		vm_install_exception_handler(vm, UD_VECTOR, guest_ud_handler);
 
 		/* Hypercall input/output */
-		hcall_page = vm_vaddr_alloc_pages(vm, 2);
+		hcall_page = vm_vaddr_alloc_pages(vm, 2, MEMSLOT(0));
 		hcall = addr_gva2hva(vm, hcall_page);
 		memset(addr_gva2hva(vm, hcall_page), 0x0, 2 * getpagesize());
 
-		hcall_params = vm_vaddr_alloc_page(vm);
+		hcall_params = vm_vaddr_alloc_page(vm, MEMSLOT(0));
 		memset(addr_gva2hva(vm, hcall_params), 0x0, getpagesize());
 
 		vcpu_args_set(vm, VCPU_ID, 2, addr_gva2gpa(vm, hcall_page), hcall_params);
diff --git a/tools/testing/selftests/kvm/x86_64/kvm_clock_test.c b/tools/testing/selftests/kvm/x86_64/kvm_clock_test.c
index 97731454f3f3..c0d3bc5a1e7d 100644
--- a/tools/testing/selftests/kvm/x86_64/kvm_clock_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvm_clock_test.c
@@ -194,7 +194,7 @@ int main(void)
 
 	vm = vm_create_default(VCPU_ID, 0, guest_main);
 
-	pvti_gva = vm_vaddr_alloc(vm, getpagesize(), 0x10000);
+	pvti_gva = vm_vaddr_alloc(vm, getpagesize(), 0x10000, MEMSLOT(0));
 	pvti_gpa = addr_gva2gpa(vm, pvti_gva);
 	vcpu_args_set(vm, VCPU_ID, 2, pvti_gpa, pvti_gva);
 
diff --git a/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c b/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
index afbbc40df884..ffb92f304302 100644
--- a/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xapic_ipi_test.c
@@ -427,7 +427,7 @@ int main(int argc, char *argv[])
 
 	vm_vcpu_add_default(vm, SENDER_VCPU_ID, sender_guest_code);
 
-	test_data_page_vaddr = vm_vaddr_alloc_page(vm);
+	test_data_page_vaddr = vm_vaddr_alloc_page(vm, MEMSLOT(0));
 	data =
 	   (struct test_data_page *)addr_gva2hva(vm, test_data_page_vaddr);
 	memset(data, 0, sizeof(*data));
-- 
2.35.1.616.g0bdcbb4464-goog

