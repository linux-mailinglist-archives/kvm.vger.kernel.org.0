Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23D6C634136
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 17:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234247AbiKVQPk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 11:15:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233740AbiKVQPE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 11:15:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 107BE2127B
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 08:12:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669133556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VBiXb4zz9SsMP4w8BlFneLQlEw7/Zz/xY7UdQoZAOOk=;
        b=NGBDR7g2XXCjkcY0166Jf7nc7/u8W+zNjvrbalfSq1ze+OU4JGYxm0P9U4Z+AtZFULynkt
        SSbQl72DqZxd8VjscYI8w2sKPVaJh7xpfGxo8cupd4wBa3xt4vNrlYiTzVWGlU76oS6PLt
        Zl5KHNhnZhPXeZ6+EUeWaPOQXSz+5yw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-251-Z1Lz5K21OlaO4r-1nqsi6g-1; Tue, 22 Nov 2022 11:12:33 -0500
X-MC-Unique: Z1Lz5K21OlaO4r-1nqsi6g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 92D85185A794;
        Tue, 22 Nov 2022 16:12:32 +0000 (UTC)
Received: from amdlaptop.tlv.redhat.com (dhcp-4-238.tlv.redhat.com [10.35.4.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 89C411121314;
        Tue, 22 Nov 2022 16:12:30 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Nico Boehr <nrb@linux.ibm.com>,
        Cathy Avery <cavery@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: [kvm-unit-tests PATCH v3 16/27] svm: move setup_svm() to svm_lib.c
Date:   Tue, 22 Nov 2022 18:11:41 +0200
Message-Id: <20221122161152.293072-17-mlevitsk@redhat.com>
In-Reply-To: <20221122161152.293072-1-mlevitsk@redhat.com>
References: <20221122161152.293072-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 lib/x86/svm.h       |   2 +
 lib/x86/svm_lib.c   | 107 ++++++++++++++++++++++++++++++++++++++++++++
 lib/x86/svm_lib.h   |  12 +++++
 x86/Makefile.x86_64 |   2 +
 x86/svm.c           |  90 ++-----------------------------------
 x86/svm.h           |   6 +--
 x86/svm_tests.c     |  18 +++++---
 7 files changed, 138 insertions(+), 99 deletions(-)
 create mode 100644 lib/x86/svm_lib.c

diff --git a/lib/x86/svm.h b/lib/x86/svm.h
index 8b836c13..d714dac9 100644
--- a/lib/x86/svm.h
+++ b/lib/x86/svm.h
@@ -2,6 +2,8 @@
 #ifndef SRC_LIB_X86_SVM_H_
 #define SRC_LIB_X86_SVM_H_
 
+#include "libcflat.h"
+
 enum {
 	INTERCEPT_INTR,
 	INTERCEPT_NMI,
diff --git a/lib/x86/svm_lib.c b/lib/x86/svm_lib.c
new file mode 100644
index 00000000..cb80f08f
--- /dev/null
+++ b/lib/x86/svm_lib.c
@@ -0,0 +1,107 @@
+
+#include "svm_lib.h"
+#include "libcflat.h"
+#include "processor.h"
+#include "desc.h"
+#include "msr.h"
+#include "vm.h"
+#include "smp.h"
+#include "alloc_page.h"
+#include "fwcfg.h"
+
+/* for the nested page table*/
+static u64 *pml4e;
+
+static u8 *io_bitmap;
+static u8 io_bitmap_area[16384];
+
+static u8 *msr_bitmap;
+static u8 msr_bitmap_area[MSR_BITMAP_SIZE + PAGE_SIZE];
+
+
+u64 *npt_get_pte(u64 address)
+{
+	return get_pte(npt_get_pml4e(), (void *)address);
+}
+
+u64 *npt_get_pde(u64 address)
+{
+	struct pte_search search;
+
+	search = find_pte_level(npt_get_pml4e(), (void *)address, 2);
+	return search.pte;
+}
+
+u64 *npt_get_pdpe(u64 address)
+{
+	struct pte_search search;
+
+	search = find_pte_level(npt_get_pml4e(), (void *)address, 3);
+	return search.pte;
+}
+
+u64 *npt_get_pml4e(void)
+{
+	return pml4e;
+}
+
+u8 *svm_get_msr_bitmap(void)
+{
+	return msr_bitmap;
+}
+
+u8 *svm_get_io_bitmap(void)
+{
+	return io_bitmap;
+}
+
+static void set_additional_vcpu_msr(void *msr_efer)
+{
+	void *hsave = alloc_page();
+
+	wrmsr(MSR_VM_HSAVE_PA, virt_to_phys(hsave));
+	wrmsr(MSR_EFER, (ulong)msr_efer | EFER_SVME);
+}
+
+static void setup_npt(void)
+{
+	u64 size = fwcfg_get_u64(FW_CFG_RAM_SIZE);
+
+	/* Ensure all <4gb is mapped, e.g. if there's no RAM above 4gb. */
+	if (size < BIT_ULL(32))
+		size = BIT_ULL(32);
+
+	pml4e = alloc_page();
+
+	/* NPT accesses are treated as "user" accesses. */
+	__setup_mmu_range(pml4e, 0, size, X86_MMU_MAP_USER);
+}
+
+void setup_svm(void)
+{
+	void *hsave = alloc_page();
+	int i;
+
+	wrmsr(MSR_VM_HSAVE_PA, virt_to_phys(hsave));
+	wrmsr(MSR_EFER, rdmsr(MSR_EFER) | EFER_SVME);
+
+	io_bitmap = (void *) ALIGN((ulong)io_bitmap_area, PAGE_SIZE);
+
+	msr_bitmap = (void *) ALIGN((ulong)msr_bitmap_area, PAGE_SIZE);
+
+	if (!npt_supported())
+		return;
+
+	for (i = 1; i < cpu_count(); i++)
+		on_cpu(i, (void *)set_additional_vcpu_msr, (void *)rdmsr(MSR_EFER));
+
+	printf("NPT detected - running all tests with NPT enabled\n");
+
+	/*
+	 * Nested paging supported - Build a nested page table
+	 * Build the page-table bottom-up and map everything with 4k
+	 * pages to get enough granularity for the NPT unit-tests.
+	 */
+
+	setup_npt();
+}
diff --git a/lib/x86/svm_lib.h b/lib/x86/svm_lib.h
index 04910281..b491eee6 100644
--- a/lib/x86/svm_lib.h
+++ b/lib/x86/svm_lib.h
@@ -49,5 +49,17 @@ static inline void clgi(void)
 	asm volatile ("clgi");
 }
 
+void setup_svm(void);
+
+u64 *npt_get_pte(u64 address);
+u64 *npt_get_pde(u64 address);
+u64 *npt_get_pdpe(u64 address);
+u64 *npt_get_pml4e(void);
+
+u8 *svm_get_msr_bitmap(void);
+u8 *svm_get_io_bitmap(void);
+
+#define MSR_BITMAP_SIZE 8192
+
 
 #endif /* SRC_LIB_X86_SVM_LIB_H_ */
diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
index f76ff18a..5e4c4cc0 100644
--- a/x86/Makefile.x86_64
+++ b/x86/Makefile.x86_64
@@ -19,6 +19,8 @@ COMMON_CFLAGS += -mno-red-zone -mno-sse -mno-sse2 $(fcf_protection_full)
 cflatobjs += lib/x86/setjmp64.o
 cflatobjs += lib/x86/intel-iommu.o
 cflatobjs += lib/x86/usermode.o
+cflatobjs += lib/x86/svm_lib.o
+
 
 tests = $(TEST_DIR)/apic.$(exe) \
 	  $(TEST_DIR)/idt_test.$(exe) \
diff --git a/x86/svm.c b/x86/svm.c
index 8d90a242..9edf5500 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -16,35 +16,8 @@
 #include "apic.h"
 #include "svm_lib.h"
 
-/* for the nested page table*/
-u64 *pml4e;
-
 struct vmcb *vmcb;
 
-u64 *npt_get_pte(u64 address)
-{
-	return get_pte(npt_get_pml4e(), (void*)address);
-}
-
-u64 *npt_get_pde(u64 address)
-{
-	struct pte_search search;
-	search = find_pte_level(npt_get_pml4e(), (void*)address, 2);
-	return search.pte;
-}
-
-u64 *npt_get_pdpe(u64 address)
-{
-	struct pte_search search;
-	search = find_pte_level(npt_get_pml4e(), (void*)address, 3);
-	return search.pte;
-}
-
-u64 *npt_get_pml4e(void)
-{
-	return pml4e;
-}
-
 bool smp_supported(void)
 {
 	return cpu_count() > 1;
@@ -112,12 +85,6 @@ static void test_thunk(struct svm_test *test)
 	vmmcall();
 }
 
-u8 *io_bitmap;
-u8 io_bitmap_area[16384];
-
-u8 *msr_bitmap;
-u8 msr_bitmap_area[MSR_BITMAP_SIZE + PAGE_SIZE];
-
 void vmcb_ident(struct vmcb *vmcb)
 {
 	u64 vmcb_phys = virt_to_phys(vmcb);
@@ -153,12 +120,12 @@ void vmcb_ident(struct vmcb *vmcb)
 	ctrl->intercept = (1ULL << INTERCEPT_VMRUN) |
 		(1ULL << INTERCEPT_VMMCALL) |
 		(1ULL << INTERCEPT_SHUTDOWN);
-	ctrl->iopm_base_pa = virt_to_phys(io_bitmap);
-	ctrl->msrpm_base_pa = virt_to_phys(msr_bitmap);
+	ctrl->iopm_base_pa = virt_to_phys(svm_get_io_bitmap());
+	ctrl->msrpm_base_pa = virt_to_phys(svm_get_msr_bitmap());
 
 	if (npt_supported()) {
 		ctrl->nested_ctl = 1;
-		ctrl->nested_cr3 = (u64)pml4e;
+		ctrl->nested_cr3 = (u64)npt_get_pml4e();
 		ctrl->tlb_ctl = TLB_CONTROL_FLUSH_ALL_ASID;
 	}
 }
@@ -247,57 +214,6 @@ static noinline void test_run(struct svm_test *test)
 		test->on_vcpu_done = true;
 }
 
-static void set_additional_vcpu_msr(void *msr_efer)
-{
-	void *hsave = alloc_page();
-
-	wrmsr(MSR_VM_HSAVE_PA, virt_to_phys(hsave));
-	wrmsr(MSR_EFER, (ulong)msr_efer | EFER_SVME);
-}
-
-static void setup_npt(void)
-{
-	u64 size = fwcfg_get_u64(FW_CFG_RAM_SIZE);
-
-	/* Ensure all <4gb is mapped, e.g. if there's no RAM above 4gb. */
-	if (size < BIT_ULL(32))
-		size = BIT_ULL(32);
-
-	pml4e = alloc_page();
-
-	/* NPT accesses are treated as "user" accesses. */
-	__setup_mmu_range(pml4e, 0, size, X86_MMU_MAP_USER);
-}
-
-static void setup_svm(void)
-{
-	void *hsave = alloc_page();
-	int i;
-
-	wrmsr(MSR_VM_HSAVE_PA, virt_to_phys(hsave));
-	wrmsr(MSR_EFER, rdmsr(MSR_EFER) | EFER_SVME);
-
-	io_bitmap = (void *) ALIGN((ulong)io_bitmap_area, PAGE_SIZE);
-
-	msr_bitmap = (void *) ALIGN((ulong)msr_bitmap_area, PAGE_SIZE);
-
-	if (!npt_supported())
-		return;
-
-	for (i = 1; i < cpu_count(); i++)
-		on_cpu(i, (void *)set_additional_vcpu_msr, (void *)rdmsr(MSR_EFER));
-
-	printf("NPT detected - running all tests with NPT enabled\n");
-
-	/*
-	 * Nested paging supported - Build a nested page table
-	 * Build the page-table bottom-up and map everything with 4k
-	 * pages to get enough granularity for the NPT unit-tests.
-	 */
-
-	setup_npt();
-}
-
 int matched;
 
 static bool
diff --git a/x86/svm.h b/x86/svm.h
index 7cb1b898..67f3205d 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -5,7 +5,6 @@
 #include <x86/svm.h>
 
 
-#define MSR_BITMAP_SIZE 8192
 #define LBR_CTL_ENABLE_MASK BIT_ULL(0)
 
 struct svm_test {
@@ -47,10 +46,7 @@ struct regs {
 typedef void (*test_guest_func)(struct svm_test *);
 
 int run_svm_tests(int ac, char **av, struct svm_test *svm_tests);
-u64 *npt_get_pte(u64 address);
-u64 *npt_get_pde(u64 address);
-u64 *npt_get_pdpe(u64 address);
-u64 *npt_get_pml4e(void);
+
 bool smp_supported(void);
 bool default_supported(void);
 void default_prepare(struct svm_test *test);
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index f86c2fa4..712d24e2 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -307,14 +307,13 @@ static bool check_next_rip(struct svm_test *test)
 	return address == vmcb->control.next_rip;
 }
 
-extern u8 *msr_bitmap;
 
 static void prepare_msr_intercept(struct svm_test *test)
 {
 	default_prepare(test);
 	vmcb->control.intercept |= (1ULL << INTERCEPT_MSR_PROT);
 	vmcb->control.intercept_exceptions |= (1ULL << GP_VECTOR);
-	memset(msr_bitmap, 0xff, MSR_BITMAP_SIZE);
+	memset(svm_get_msr_bitmap(), 0xff, MSR_BITMAP_SIZE);
 }
 
 static void test_msr_intercept(struct svm_test *test)
@@ -425,7 +424,7 @@ static bool msr_intercept_finished(struct svm_test *test)
 
 static bool check_msr_intercept(struct svm_test *test)
 {
-	memset(msr_bitmap, 0, MSR_BITMAP_SIZE);
+	memset(svm_get_msr_bitmap(), 0, MSR_BITMAP_SIZE);
 	return (test->scratch == -2);
 }
 
@@ -537,10 +536,10 @@ static bool check_mode_switch(struct svm_test *test)
 	return test->scratch == 2;
 }
 
-extern u8 *io_bitmap;
-
 static void prepare_ioio(struct svm_test *test)
 {
+	u8 *io_bitmap = svm_get_io_bitmap();
+
 	vmcb->control.intercept |= (1ULL << INTERCEPT_IOIO_PROT);
 	test->scratch = 0;
 	memset(io_bitmap, 0, 8192);
@@ -549,6 +548,8 @@ static void prepare_ioio(struct svm_test *test)
 
 static void test_ioio(struct svm_test *test)
 {
+	u8 *io_bitmap = svm_get_io_bitmap();
+
 	// stage 0, test IO pass
 	inb(0x5000);
 	outb(0x0, 0x5000);
@@ -612,7 +613,6 @@ static void test_ioio(struct svm_test *test)
 		goto fail;
 
 	return;
-
 fail:
 	report_fail("stage %d", get_test_stage(test));
 	test->scratch = -1;
@@ -621,6 +621,7 @@ fail:
 static bool ioio_finished(struct svm_test *test)
 {
 	unsigned port, size;
+	u8 *io_bitmap = svm_get_io_bitmap();
 
 	/* Only expect IOIO intercepts */
 	if (vmcb->control.exit_code == SVM_EXIT_VMMCALL)
@@ -645,6 +646,8 @@ static bool ioio_finished(struct svm_test *test)
 
 static bool check_ioio(struct svm_test *test)
 {
+	u8 *io_bitmap = svm_get_io_bitmap();
+
 	memset(io_bitmap, 0, 8193);
 	return test->scratch != -1;
 }
@@ -2316,7 +2319,8 @@ static void test_msrpm_iopm_bitmap_addrs(void)
 {
 	u64 saved_intercept = vmcb->control.intercept;
 	u64 addr_beyond_limit = 1ull << cpuid_maxphyaddr();
-	u64 addr = virt_to_phys(msr_bitmap) & (~((1ull << 12) - 1));
+	u64 addr = virt_to_phys(svm_get_msr_bitmap()) & (~((1ull << 12) - 1));
+	u8 *io_bitmap = svm_get_io_bitmap();
 
 	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_MSR_PROT,
 			 addr_beyond_limit - 2 * PAGE_SIZE, SVM_EXIT_ERR,
-- 
2.34.3

