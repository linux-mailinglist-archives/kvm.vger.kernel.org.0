Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBA43B0E31
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 22:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233090AbhFVUIY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 16:08:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232935AbhFVUIO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 16:08:14 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2759C0613A4
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 13:05:53 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id a193-20020a3766ca0000b02903a9be00d619so19414215qkc.12
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 13:05:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=PqgYvrxFkZun/wkd3Jd2Nxz9FdLaLGoT8QkQD6VQExc=;
        b=uzL5BVem1LwuQPte4KvnH+CfMid24KDbC9dKoGEqU8CRkG8RDxVjO3ghptPTdevryX
         d71DnOQJXSpqmXGXD2EUMOhgydYkeixDZ4S5QDtm4+GyQwMciuQxpP64CX2rqLIELDu/
         MiN2oVTeCEn62nRtkmc1fVHaWng0U/1a1m7GygndfTAPdFoFly4MXbsVLej8Kxry4Ntj
         sZFSjvTdjcATDwXZuvIGDHGu7d1LkmpMKVF/G1HqwnSmqhxwP+SVSSJf4rNQ0ib8eSzM
         e2CXvDY83JfVRZK26cDdSnAPu4IQKSPXcUUh/f087PMyyFPBMn84YszCbdwJz9W2tl5i
         A02A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=PqgYvrxFkZun/wkd3Jd2Nxz9FdLaLGoT8QkQD6VQExc=;
        b=PsolgJuwhTgTf/OlFVfGPzbQJ+FKAzlhUqOkvfxWDJYlJsaGjckC57GgzqB1R4jQ0p
         VOuWV305VgycGAdB4uJPNb/lNLoJZWNXJdp0HUPTb+Em27R2J/sXVM0zsBEbumo/aOFW
         9EXeFUerNfEt7gLGRj3IafHyQ9iseDPtNR5u7LBLlAtXE2G/zpeEBH8WpINfZe491JI+
         5b7bkO9KGDZwz8jWwWGRdyhnXOsGFWg3RQ3WfAkOPgYXQKR1Hw24oTksqZZ6tVK15oxy
         jYig+WPPgEUC3Ee9rdJ2JynrZeqzsqxsDiGeV3ZtnKY6C2EKtqxnTZBIa8mLLxbPj9t3
         gRdg==
X-Gm-Message-State: AOAM531GJrLuwV7JFuBqkhvQdrw12jQceqkQtqnDQjQayhiDJH5qxp1E
        O8XQ4DU/ibfFh8WO/EHXbRXYThm7sZA=
X-Google-Smtp-Source: ABdhPJwDiZajggid90LT5jHhtYSKqFbva8fRWQTCqq2NLRhOymDkMmEzLO140vpbqfNkjYNiQ5LDwW3BJGI=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:7d90:4528:3c45:18fb])
 (user=seanjc job=sendgmr) by 2002:a0c:fd44:: with SMTP id j4mr588106qvs.12.1624392352923;
 Tue, 22 Jun 2021 13:05:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 13:05:16 -0700
In-Reply-To: <20210622200529.3650424-1-seanjc@google.com>
Message-Id: <20210622200529.3650424-7-seanjc@google.com>
Mime-Version: 1.0
References: <20210622200529.3650424-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 06/19] KVM: selftests: Add helpers to allocate N pages of
 virtual memory
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add wrappers to allocate 1 and N pages of memory using de facto standard
values as the defaults for minimum virtual address, data memslot, and
page table memslot.  Convert all compatible users.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  |  3 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 38 +++++++++++++++++++
 tools/testing/selftests/kvm/lib/x86_64/svm.c  |  9 ++---
 tools/testing/selftests/kvm/lib/x86_64/vmx.c  | 25 ++++++------
 .../selftests/kvm/x86_64/hyperv_clock.c       |  2 +-
 .../selftests/kvm/x86_64/hyperv_features.c    |  6 +--
 6 files changed, 59 insertions(+), 24 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 59608b17707d..70385bf25446 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -142,6 +142,9 @@ void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
 void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid);
 vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
 			  uint32_t data_memslot, uint32_t pgd_memslot);
+vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages);
+vm_vaddr_t vm_vaddr_alloc_page(struct kvm_vm *vm);
+
 void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 	      unsigned int npages, uint32_t pgd_memslot);
 void *addr_gpa2hva(struct kvm_vm *vm, vm_paddr_t gpa);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 15a8527b15db..c45e8c492627 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1280,6 +1280,44 @@ vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
 	return vaddr_start;
 }
 
+/*
+ * VM Virtual Address Allocate Pages
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *
+ * Output Args: None
+ *
+ * Return:
+ *   Starting guest virtual address
+ *
+ * Allocates at least N system pages worth of bytes within the virtual address
+ * space of the vm.
+ */
+vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages)
+{
+	return vm_vaddr_alloc(vm, nr_pages * getpagesize(), 0x10000, 0, 0);
+}
+
+/*
+ * VM Virtual Address Allocate Page
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *
+ * Output Args: None
+ *
+ * Return:
+ *   Starting guest virtual address
+ *
+ * Allocates at least one system page worth of bytes within the virtual address
+ * space of the vm.
+ */
+vm_vaddr_t vm_vaddr_alloc_page(struct kvm_vm *vm)
+{
+	return vm_vaddr_alloc_pages(vm, 1);
+}
+
 /*
  * Map a range of VM virtual address to the VM's physical address
  *
diff --git a/tools/testing/selftests/kvm/lib/x86_64/svm.c b/tools/testing/selftests/kvm/lib/x86_64/svm.c
index 827fe6028dd4..2ac98d70d02b 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/svm.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/svm.c
@@ -30,17 +30,14 @@ u64 rflags;
 struct svm_test_data *
 vcpu_alloc_svm(struct kvm_vm *vm, vm_vaddr_t *p_svm_gva)
 {
-	vm_vaddr_t svm_gva = vm_vaddr_alloc(vm, getpagesize(),
-					    0x10000, 0, 0);
+	vm_vaddr_t svm_gva = vm_vaddr_alloc_page(vm);
 	struct svm_test_data *svm = addr_gva2hva(vm, svm_gva);
 
-	svm->vmcb = (void *)vm_vaddr_alloc(vm, getpagesize(),
-					   0x10000, 0, 0);
+	svm->vmcb = (void *)vm_vaddr_alloc_page(vm);
 	svm->vmcb_hva = addr_gva2hva(vm, (uintptr_t)svm->vmcb);
 	svm->vmcb_gpa = addr_gva2gpa(vm, (uintptr_t)svm->vmcb);
 
-	svm->save_area = (void *)vm_vaddr_alloc(vm, getpagesize(),
-						0x10000, 0, 0);
+	svm->save_area = (void *)vm_vaddr_alloc_page(vm);
 	svm->save_area_hva = addr_gva2hva(vm, (uintptr_t)svm->save_area);
 	svm->save_area_gpa = addr_gva2gpa(vm, (uintptr_t)svm->save_area);
 
diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
index 2448b30e8efa..d568d8cfd44d 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
@@ -77,50 +77,48 @@ int vcpu_enable_evmcs(struct kvm_vm *vm, int vcpu_id)
 struct vmx_pages *
 vcpu_alloc_vmx(struct kvm_vm *vm, vm_vaddr_t *p_vmx_gva)
 {
-	vm_vaddr_t vmx_gva = vm_vaddr_alloc(vm, getpagesize(), 0x10000, 0, 0);
+	vm_vaddr_t vmx_gva = vm_vaddr_alloc_page(vm);
 	struct vmx_pages *vmx = addr_gva2hva(vm, vmx_gva);
 
 	/* Setup of a region of guest memory for the vmxon region. */
-	vmx->vmxon = (void *)vm_vaddr_alloc(vm, getpagesize(), 0x10000, 0, 0);
+	vmx->vmxon = (void *)vm_vaddr_alloc_page(vm);
 	vmx->vmxon_hva = addr_gva2hva(vm, (uintptr_t)vmx->vmxon);
 	vmx->vmxon_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->vmxon);
 
 	/* Setup of a region of guest memory for a vmcs. */
-	vmx->vmcs = (void *)vm_vaddr_alloc(vm, getpagesize(), 0x10000, 0, 0);
+	vmx->vmcs = (void *)vm_vaddr_alloc_page(vm);
 	vmx->vmcs_hva = addr_gva2hva(vm, (uintptr_t)vmx->vmcs);
 	vmx->vmcs_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->vmcs);
 
 	/* Setup of a region of guest memory for the MSR bitmap. */
-	vmx->msr = (void *)vm_vaddr_alloc(vm, getpagesize(), 0x10000, 0, 0);
+	vmx->msr = (void *)vm_vaddr_alloc_page(vm);
 	vmx->msr_hva = addr_gva2hva(vm, (uintptr_t)vmx->msr);
 	vmx->msr_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->msr);
 	memset(vmx->msr_hva, 0, getpagesize());
 
 	/* Setup of a region of guest memory for the shadow VMCS. */
-	vmx->shadow_vmcs = (void *)vm_vaddr_alloc(vm, getpagesize(), 0x10000, 0, 0);
+	vmx->shadow_vmcs = (void *)vm_vaddr_alloc_page(vm);
 	vmx->shadow_vmcs_hva = addr_gva2hva(vm, (uintptr_t)vmx->shadow_vmcs);
 	vmx->shadow_vmcs_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->shadow_vmcs);
 
 	/* Setup of a region of guest memory for the VMREAD and VMWRITE bitmaps. */
-	vmx->vmread = (void *)vm_vaddr_alloc(vm, getpagesize(), 0x10000, 0, 0);
+	vmx->vmread = (void *)vm_vaddr_alloc_page(vm);
 	vmx->vmread_hva = addr_gva2hva(vm, (uintptr_t)vmx->vmread);
 	vmx->vmread_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->vmread);
 	memset(vmx->vmread_hva, 0, getpagesize());
 
-	vmx->vmwrite = (void *)vm_vaddr_alloc(vm, getpagesize(), 0x10000, 0, 0);
+	vmx->vmwrite = (void *)vm_vaddr_alloc_page(vm);
 	vmx->vmwrite_hva = addr_gva2hva(vm, (uintptr_t)vmx->vmwrite);
 	vmx->vmwrite_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->vmwrite);
 	memset(vmx->vmwrite_hva, 0, getpagesize());
 
 	/* Setup of a region of guest memory for the VP Assist page. */
-	vmx->vp_assist = (void *)vm_vaddr_alloc(vm, getpagesize(),
-						0x10000, 0, 0);
+	vmx->vp_assist = (void *)vm_vaddr_alloc_page(vm);
 	vmx->vp_assist_hva = addr_gva2hva(vm, (uintptr_t)vmx->vp_assist);
 	vmx->vp_assist_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->vp_assist);
 
 	/* Setup of a region of guest memory for the enlightened VMCS. */
-	vmx->enlightened_vmcs = (void *)vm_vaddr_alloc(vm, getpagesize(),
-						       0x10000, 0, 0);
+	vmx->enlightened_vmcs = (void *)vm_vaddr_alloc_page(vm);
 	vmx->enlightened_vmcs_hva =
 		addr_gva2hva(vm, (uintptr_t)vmx->enlightened_vmcs);
 	vmx->enlightened_vmcs_gpa =
@@ -538,7 +536,7 @@ void nested_map_memslot(struct vmx_pages *vmx, struct kvm_vm *vm,
 void prepare_eptp(struct vmx_pages *vmx, struct kvm_vm *vm,
 		  uint32_t eptp_memslot)
 {
-	vmx->eptp = (void *)vm_vaddr_alloc(vm, getpagesize(), 0x10000, 0, 0);
+	vmx->eptp = (void *)vm_vaddr_alloc_page(vm);
 	vmx->eptp_hva = addr_gva2hva(vm, (uintptr_t)vmx->eptp);
 	vmx->eptp_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->eptp);
 }
@@ -546,8 +544,7 @@ void prepare_eptp(struct vmx_pages *vmx, struct kvm_vm *vm,
 void prepare_virtualize_apic_accesses(struct vmx_pages *vmx, struct kvm_vm *vm,
 				      uint32_t eptp_memslot)
 {
-	vmx->apic_access = (void *)vm_vaddr_alloc(vm, getpagesize(),
-						  0x10000, 0, 0);
+	vmx->apic_access = (void *)vm_vaddr_alloc_page(vm);
 	vmx->apic_access_hva = addr_gva2hva(vm, (uintptr_t)vmx->apic_access);
 	vmx->apic_access_gpa = addr_gva2gpa(vm, (uintptr_t)vmx->apic_access);
 }
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
index 489625acc9cf..bab10ae787b6 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
@@ -214,7 +214,7 @@ int main(void)
 
 	vcpu_set_hv_cpuid(vm, VCPU_ID);
 
-	tsc_page_gva = vm_vaddr_alloc(vm, getpagesize(), 0x10000, 0, 0);
+	tsc_page_gva = vm_vaddr_alloc_page(vm);
 	memset(addr_gpa2hva(vm, tsc_page_gva), 0x0, getpagesize());
 	TEST_ASSERT((addr_gva2gpa(vm, tsc_page_gva) & (getpagesize() - 1)) == 0,
 		"TSC page has to be page aligned\n");
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
index ad7ee06fa71e..42bd658f52a8 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
@@ -604,7 +604,7 @@ int main(void)
 	/* Test MSRs */
 	vm = vm_create_default(VCPU_ID, 0, guest_msr);
 
-	msr_gva = vm_vaddr_alloc(vm, getpagesize(), 0x10000, 0, 0);
+	msr_gva = vm_vaddr_alloc_page(vm);
 	memset(addr_gva2hva(vm, msr_gva), 0x0, getpagesize());
 	vcpu_args_set(vm, VCPU_ID, 1, msr_gva);
 	vcpu_enable_cap(vm, VCPU_ID, &cap);
@@ -626,10 +626,10 @@ int main(void)
 	vm = vm_create_default(VCPU_ID, 0, guest_hcall);
 
 	/* Hypercall input/output */
-	hcall_page = vm_vaddr_alloc(vm, 2 * getpagesize(), 0x10000, 0, 0);
+	hcall_page = vm_vaddr_alloc_pages(vm, 2);
 	memset(addr_gva2hva(vm, hcall_page), 0x0, 2 * getpagesize());
 
-	hcall_params = vm_vaddr_alloc(vm, getpagesize(), 0x10000, 0, 0);
+	hcall_params = vm_vaddr_alloc_page(vm);
 	memset(addr_gva2hva(vm, hcall_params), 0x0, getpagesize());
 
 	vcpu_args_set(vm, VCPU_ID, 2, addr_gva2gpa(vm, hcall_page), hcall_params);
-- 
2.32.0.288.g62a8d224e6-goog

