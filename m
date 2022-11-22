Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 888BF63413D
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 17:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234363AbiKVQQO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 11:16:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232748AbiKVQP4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 11:15:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA96E6238D
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 08:12:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669133568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TFvlWTYKUB3Ul7peXVi9YQw3/dKG2ej3ODo52yUvFbU=;
        b=PVbePAanAkE88NMx2u0E57vHvZp6WJOTAxtN3lKO57zEljJQ6Bo+l1/1Yk1HDz+K6jAm4u
        i8MmdzSQsP7STI6nFXiMlyWZaYWE4LlEumIa/8ht35nY5/HEmnLZ8obHpZv2zdn4wYUoWB
        Y+ryoyeVJ644KmTaq28zaygH/2RuRZc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-5d0v8sMgMiqQiucQGV3Lpw-1; Tue, 22 Nov 2022 11:12:46 -0500
X-MC-Unique: 5d0v8sMgMiqQiucQGV3Lpw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6EC9038012D4;
        Tue, 22 Nov 2022 16:12:46 +0000 (UTC)
Received: from amdlaptop.tlv.redhat.com (dhcp-4-238.tlv.redhat.com [10.35.4.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 49D9E1121314;
        Tue, 22 Nov 2022 16:12:44 +0000 (UTC)
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
Subject: [kvm-unit-tests PATCH v3 22/27] svm: introduce svm_vcpu
Date:   Tue, 22 Nov 2022 18:11:47 +0200
Message-Id: <20221122161152.293072-23-mlevitsk@redhat.com>
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

This adds minimum amount of code to support tests that
run SVM on more that one vCPU.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 lib/x86/svm_lib.c |  16 +-
 lib/x86/svm_lib.h |  31 ++-
 x86/svm.c         |  36 +--
 x86/svm.h         |   5 +-
 x86/svm_npt.c     |  44 ++--
 x86/svm_tests.c   | 649 +++++++++++++++++++++++-----------------------
 6 files changed, 401 insertions(+), 380 deletions(-)

diff --git a/lib/x86/svm_lib.c b/lib/x86/svm_lib.c
index aed757a1..f705f0ae 100644
--- a/lib/x86/svm_lib.c
+++ b/lib/x86/svm_lib.c
@@ -119,7 +119,7 @@ void vmcb_set_seg(struct vmcb_seg *seg, u16 selector,
 	seg->base = base;
 }
 
-void vmcb_ident(struct vmcb *vmcb)
+static void vmcb_ident(struct vmcb *vmcb)
 {
 	u64 vmcb_phys = virt_to_phys(vmcb);
 	struct vmcb_save_area *save = &vmcb->save;
@@ -163,3 +163,17 @@ void vmcb_ident(struct vmcb *vmcb)
 		ctrl->tlb_ctl = TLB_CONTROL_FLUSH_ALL_ASID;
 	}
 }
+
+void svm_vcpu_ident(struct svm_vcpu *vcpu)
+{
+	vmcb_ident(vcpu->vmcb);
+	memset(&vcpu->regs, 0, sizeof(vcpu->regs));
+	vcpu->vmcb->save.rsp = (ulong)(vcpu->stack);
+}
+
+void svm_vcpu_init(struct svm_vcpu *vcpu)
+{
+	vcpu->vmcb = alloc_page();
+	vcpu->stack = alloc_pages(4) + (PAGE_SIZE << 4);
+	svm_vcpu_ident(vcpu);
+}
diff --git a/lib/x86/svm_lib.h b/lib/x86/svm_lib.h
index f9c2b352..fba34eae 100644
--- a/lib/x86/svm_lib.h
+++ b/lib/x86/svm_lib.h
@@ -53,7 +53,6 @@ void vmcb_set_seg(struct vmcb_seg *seg, u16 selector,
 				  u64 base, u32 limit, u32 attr);
 
 bool setup_svm(void);
-void vmcb_ident(struct vmcb *vmcb);
 
 u64 *npt_get_pte(u64 address);
 u64 *npt_get_pde(u64 address);
@@ -85,6 +84,16 @@ struct svm_gprs {
 	u64 rsp;
 };
 
+struct svm_vcpu {
+	struct vmcb *vmcb;
+	struct svm_gprs regs;
+	void *stack;
+};
+
+void svm_vcpu_init(struct svm_vcpu *vcpu);
+void svm_vcpu_ident(struct svm_vcpu *vcpu);
+
+
 #define SWAP_GPRS \
 	"xchg %%rbx, 0x08(%%rax)\n"           \
 	"xchg %%rcx, 0x10(%%rax)\n"           \
@@ -103,12 +112,14 @@ struct svm_gprs {
 	\
 
 
-#define __SVM_VMRUN(vmcb, regs, label)        \
-{                                             \
-	u32 dummy;                            \
+#define __SVM_VMRUN(vcpu, label)                 \
+{                                                \
+	u32 dummy;                               \
+	struct vmcb *vmcb = (vcpu)->vmcb;        \
+	struct svm_gprs *regs = &((vcpu)->regs); \
 \
-	(vmcb)->save.rax = (regs)->rax;       \
-	(vmcb)->save.rsp = (regs)->rsp;       \
+	vmcb->save.rax = regs->rax;              \
+	vmcb->save.rsp = regs->rsp;              \
 \
 	asm volatile (                        \
 		"vmload %%rax\n"              \
@@ -130,11 +141,11 @@ struct svm_gprs {
 		: "memory"                    \
 	);                                    \
 \
-	(regs)->rax = (vmcb)->save.rax;       \
-	(regs)->rsp = (vmcb)->save.rsp;       \
+	regs->rax = vmcb->save.rax;           \
+	regs->rsp = vmcb->save.rsp;           \
 }
 
-#define SVM_VMRUN(vmcb, regs) \
-	__SVM_VMRUN(vmcb, regs, "vmrun_dummy_label_%=")
+#define SVM_VMRUN(vcpu) \
+	__SVM_VMRUN(vcpu, "vmrun_dummy_label_%=")
 
 #endif /* SRC_LIB_X86_SVM_LIB_H_ */
diff --git a/x86/svm.c b/x86/svm.c
index 5667402b..51ed4d06 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -16,7 +16,7 @@
 #include "apic.h"
 #include "svm_lib.h"
 
-struct vmcb *vmcb;
+struct svm_vcpu vcpu0;
 
 bool smp_supported(void)
 {
@@ -75,27 +75,17 @@ static void test_thunk(struct svm_test *test)
 	vmmcall();
 }
 
-static struct svm_gprs regs;
-
-struct svm_gprs *get_regs(void)
-{
-	return &regs;
-}
 
 struct svm_test *v2_test;
 
 
-u64 guest_stack[10000];
-
 int __svm_vmrun(u64 rip)
 {
-	vmcb->save.rip = (ulong)rip;
-	regs.rsp = (ulong)(guest_stack + ARRAY_SIZE(guest_stack));
-	regs.rdi = (ulong)v2_test;
-
-	SVM_VMRUN(vmcb, &regs);
-
-	return (vmcb->control.exit_code);
+	vcpu0.vmcb->save.rip = (ulong)rip;
+	vcpu0.regs.rdi = (ulong)v2_test;
+	vcpu0.regs.rsp = (ulong)(vcpu0.stack);
+	SVM_VMRUN(&vcpu0);
+	return vcpu0.vmcb->control.exit_code;
 }
 
 int svm_vmrun(void)
@@ -105,21 +95,21 @@ int svm_vmrun(void)
 
 static noinline void test_run(struct svm_test *test)
 {
+	svm_vcpu_ident(&vcpu0);
+
 	if (test->v2) {
-		vmcb_ident(vmcb);
 		v2_test = test;
 		test->v2();
 		return;
 	}
 
 	cli();
-	vmcb_ident(vmcb);
 
 	test->prepare(test);
 	guest_main = test->guest_func;
-	vmcb->save.rip = (ulong)test_thunk;
-	regs.rsp = (ulong)(guest_stack + ARRAY_SIZE(guest_stack));
-	regs.rdi = (ulong)test;
+	vcpu0.vmcb->save.rip = (ulong)test_thunk;
+	vcpu0.regs.rsp = (ulong)(vcpu0.stack);
+	vcpu0.regs.rdi = (ulong)test;
 	do {
 
 		clgi();
@@ -127,7 +117,7 @@ static noinline void test_run(struct svm_test *test)
 
 		test->prepare_gif_clear(test);
 
-		__SVM_VMRUN(vmcb, &regs, "vmrun_rip");
+		__SVM_VMRUN(&vcpu0, "vmrun_rip");
 
 		cli();
 		stgi();
@@ -195,7 +185,7 @@ int run_svm_tests(int ac, char **av, struct svm_test *svm_tests)
 	if (!setup_svm())
 		return 0;
 
-	vmcb = alloc_page();
+	svm_vcpu_init(&vcpu0);
 
 	for (; svm_tests[i].name != NULL; i++) {
 		if (!test_wanted(svm_tests[i].name, av, ac))
diff --git a/x86/svm.h b/x86/svm.h
index 6f809ce3..61fd2387 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -35,12 +35,13 @@ bool default_finished(struct svm_test *test);
 int get_test_stage(struct svm_test *test);
 void set_test_stage(struct svm_test *test, int s);
 void inc_test_stage(struct svm_test *test);
-struct svm_gprs *get_regs(void);
 int __svm_vmrun(u64 rip);
 void __svm_bare_vmrun(void);
 int svm_vmrun(void);
 void test_set_guest(test_guest_func func);
 
-extern struct vmcb *vmcb;
+
 extern struct svm_test svm_tests[];
+extern struct svm_vcpu vcpu0;
+
 #endif
diff --git a/x86/svm_npt.c b/x86/svm_npt.c
index 8aac0bb6..53a82793 100644
--- a/x86/svm_npt.c
+++ b/x86/svm_npt.c
@@ -31,8 +31,8 @@ static bool npt_np_check(struct svm_test *test)
 
 	*pte |= 1ULL;
 
-	return (vmcb->control.exit_code == SVM_EXIT_NPF)
-	    && (vmcb->control.exit_info_1 == 0x100000004ULL);
+	return (vcpu0.vmcb->control.exit_code == SVM_EXIT_NPF)
+	    && (vcpu0.vmcb->control.exit_info_1 == 0x100000004ULL);
 }
 
 static void npt_nx_prepare(struct svm_test *test)
@@ -43,7 +43,7 @@ static void npt_nx_prepare(struct svm_test *test)
 	wrmsr(MSR_EFER, test->scratch | EFER_NX);
 
 	/* Clear the guest's EFER.NX, it should not affect NPT behavior. */
-	vmcb->save.efer &= ~EFER_NX;
+	vcpu0.vmcb->save.efer &= ~EFER_NX;
 
 	pte = npt_get_pte((u64) null_test);
 
@@ -58,8 +58,8 @@ static bool npt_nx_check(struct svm_test *test)
 
 	*pte &= ~PT64_NX_MASK;
 
-	return (vmcb->control.exit_code == SVM_EXIT_NPF)
-	    && (vmcb->control.exit_info_1 == 0x100000015ULL);
+	return (vcpu0.vmcb->control.exit_code == SVM_EXIT_NPF)
+	    && (vcpu0.vmcb->control.exit_info_1 == 0x100000015ULL);
 }
 
 static void npt_us_prepare(struct svm_test *test)
@@ -83,8 +83,8 @@ static bool npt_us_check(struct svm_test *test)
 
 	*pte |= (1ULL << 2);
 
-	return (vmcb->control.exit_code == SVM_EXIT_NPF)
-	    && (vmcb->control.exit_info_1 == 0x100000005ULL);
+	return (vcpu0.vmcb->control.exit_code == SVM_EXIT_NPF)
+	    && (vcpu0.vmcb->control.exit_info_1 == 0x100000005ULL);
 }
 
 static void npt_rw_prepare(struct svm_test *test)
@@ -110,8 +110,8 @@ static bool npt_rw_check(struct svm_test *test)
 
 	*pte |= (1ULL << 1);
 
-	return (vmcb->control.exit_code == SVM_EXIT_NPF)
-	    && (vmcb->control.exit_info_1 == 0x100000007ULL);
+	return (vcpu0.vmcb->control.exit_code == SVM_EXIT_NPF)
+	    && (vcpu0.vmcb->control.exit_info_1 == 0x100000007ULL);
 }
 
 static void npt_rw_pfwalk_prepare(struct svm_test *test)
@@ -130,9 +130,9 @@ static bool npt_rw_pfwalk_check(struct svm_test *test)
 
 	*pte |= (1ULL << 1);
 
-	return (vmcb->control.exit_code == SVM_EXIT_NPF)
-	    && (vmcb->control.exit_info_1 == 0x200000007ULL)
-	    && (vmcb->control.exit_info_2 == read_cr3());
+	return (vcpu0.vmcb->control.exit_code == SVM_EXIT_NPF)
+	    && (vcpu0.vmcb->control.exit_info_1 == 0x200000007ULL)
+	    && (vcpu0.vmcb->control.exit_info_2 == read_cr3());
 }
 
 static void npt_l1mmio_prepare(struct svm_test *test)
@@ -181,8 +181,8 @@ static bool npt_rw_l1mmio_check(struct svm_test *test)
 
 	*pte |= (1ULL << 1);
 
-	return (vmcb->control.exit_code == SVM_EXIT_NPF)
-	    && (vmcb->control.exit_info_1 == 0x100000007ULL);
+	return (vcpu0.vmcb->control.exit_code == SVM_EXIT_NPF)
+	    && (vcpu0.vmcb->control.exit_info_1 == 0x100000007ULL);
 }
 
 static void basic_guest_main(struct svm_test *test)
@@ -199,8 +199,8 @@ static void __svm_npt_rsvd_bits_test(u64 * pxe, u64 rsvd_bits, u64 efer,
 	wrmsr(MSR_EFER, efer);
 	write_cr4(cr4);
 
-	vmcb->save.efer = guest_efer;
-	vmcb->save.cr4 = guest_cr4;
+	vcpu0.vmcb->save.efer = guest_efer;
+	vcpu0.vmcb->save.cr4 = guest_cr4;
 
 	*pxe |= rsvd_bits;
 
@@ -226,10 +226,10 @@ static void __svm_npt_rsvd_bits_test(u64 * pxe, u64 rsvd_bits, u64 efer,
 
 	}
 
-	report(vmcb->control.exit_info_1 == pfec,
+	report(vcpu0.vmcb->control.exit_info_1 == pfec,
 	       "Wanted PFEC = 0x%lx, got PFEC = %lx, PxE = 0x%lx.  "
 	       "host.NX = %u, host.SMEP = %u, guest.NX = %u, guest.SMEP = %u",
-	       pfec, vmcb->control.exit_info_1, *pxe,
+	       pfec, vcpu0.vmcb->control.exit_info_1, *pxe,
 	       !!(efer & EFER_NX), !!(cr4 & X86_CR4_SMEP),
 	       !!(guest_efer & EFER_NX), !!(guest_cr4 & X86_CR4_SMEP));
 
@@ -317,8 +317,8 @@ static void svm_npt_rsvd_bits_test(void)
 
 	saved_efer = host_efer = rdmsr(MSR_EFER);
 	saved_cr4 = host_cr4 = read_cr4();
-	sg_efer = guest_efer = vmcb->save.efer;
-	sg_cr4 = guest_cr4 = vmcb->save.cr4;
+	sg_efer = guest_efer = vcpu0.vmcb->save.efer;
+	sg_cr4 = guest_cr4 = vcpu0.vmcb->save.cr4;
 
 	test_set_guest(basic_guest_main);
 
@@ -350,8 +350,8 @@ skip_pte_test:
 
 	wrmsr(MSR_EFER, saved_efer);
 	write_cr4(saved_cr4);
-	vmcb->save.efer = sg_efer;
-	vmcb->save.cr4 = sg_cr4;
+	vcpu0.vmcb->save.efer = sg_efer;
+	vcpu0.vmcb->save.cr4 = sg_cr4;
 }
 
 #define NPT_V1_TEST(name, prepare, guest_code, check)				\
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 3b68718e..0312df33 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -44,33 +44,33 @@ static void null_test(struct svm_test *test)
 
 static bool null_check(struct svm_test *test)
 {
-	return vmcb->control.exit_code == SVM_EXIT_VMMCALL;
+	return vcpu0.vmcb->control.exit_code == SVM_EXIT_VMMCALL;
 }
 
 static void prepare_no_vmrun_int(struct svm_test *test)
 {
-	vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMRUN);
+	vcpu0.vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMRUN);
 }
 
 static bool check_no_vmrun_int(struct svm_test *test)
 {
-	return vmcb->control.exit_code == SVM_EXIT_ERR;
+	return vcpu0.vmcb->control.exit_code == SVM_EXIT_ERR;
 }
 
 static void test_vmrun(struct svm_test *test)
 {
-	asm volatile ("vmrun %0" : : "a"(virt_to_phys(vmcb)));
+	asm volatile ("vmrun %0" : : "a"(virt_to_phys(vcpu0.vmcb)));
 }
 
 static bool check_vmrun(struct svm_test *test)
 {
-	return vmcb->control.exit_code == SVM_EXIT_VMRUN;
+	return vcpu0.vmcb->control.exit_code == SVM_EXIT_VMRUN;
 }
 
 static void prepare_rsm_intercept(struct svm_test *test)
 {
-	vmcb->control.intercept |= 1 << INTERCEPT_RSM;
-	vmcb->control.intercept_exceptions |= (1ULL << UD_VECTOR);
+	vcpu0.vmcb->control.intercept |= 1 << INTERCEPT_RSM;
+	vcpu0.vmcb->control.intercept_exceptions |= (1ULL << UD_VECTOR);
 }
 
 static void test_rsm_intercept(struct svm_test *test)
@@ -87,22 +87,22 @@ static bool finished_rsm_intercept(struct svm_test *test)
 {
 	switch (get_test_stage(test)) {
 	case 0:
-		if (vmcb->control.exit_code != SVM_EXIT_RSM) {
+		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_RSM) {
 			report_fail("VMEXIT not due to rsm. Exit reason 0x%x",
-				    vmcb->control.exit_code);
+				    vcpu0.vmcb->control.exit_code);
 			return true;
 		}
-		vmcb->control.intercept &= ~(1 << INTERCEPT_RSM);
+		vcpu0.vmcb->control.intercept &= ~(1 << INTERCEPT_RSM);
 		inc_test_stage(test);
 		break;
 
 	case 1:
-		if (vmcb->control.exit_code != SVM_EXIT_EXCP_BASE + UD_VECTOR) {
+		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_EXCP_BASE + UD_VECTOR) {
 			report_fail("VMEXIT not due to #UD. Exit reason 0x%x",
-				    vmcb->control.exit_code);
+				    vcpu0.vmcb->control.exit_code);
 			return true;
 		}
-		vmcb->save.rip += 2;
+		vcpu0.vmcb->save.rip += 2;
 		inc_test_stage(test);
 		break;
 
@@ -114,7 +114,7 @@ static bool finished_rsm_intercept(struct svm_test *test)
 
 static void prepare_cr3_intercept(struct svm_test *test)
 {
-	vmcb->control.intercept_cr_read |= 1 << 3;
+	vcpu0.vmcb->control.intercept_cr_read |= 1 << 3;
 }
 
 static void test_cr3_intercept(struct svm_test *test)
@@ -124,7 +124,7 @@ static void test_cr3_intercept(struct svm_test *test)
 
 static bool check_cr3_intercept(struct svm_test *test)
 {
-	return vmcb->control.exit_code == SVM_EXIT_READ_CR3;
+	return vcpu0.vmcb->control.exit_code == SVM_EXIT_READ_CR3;
 }
 
 static bool check_cr3_nointercept(struct svm_test *test)
@@ -147,7 +147,7 @@ static void corrupt_cr3_intercept_bypass(void *_test)
 
 static void prepare_cr3_intercept_bypass(struct svm_test *test)
 {
-	vmcb->control.intercept_cr_read |= 1 << 3;
+	vcpu0.vmcb->control.intercept_cr_read |= 1 << 3;
 	on_cpu_async(1, corrupt_cr3_intercept_bypass, test);
 }
 
@@ -166,8 +166,8 @@ static void test_cr3_intercept_bypass(struct svm_test *test)
 
 static void prepare_dr_intercept(struct svm_test *test)
 {
-	vmcb->control.intercept_dr_read = 0xff;
-	vmcb->control.intercept_dr_write = 0xff;
+	vcpu0.vmcb->control.intercept_dr_read = 0xff;
+	vcpu0.vmcb->control.intercept_dr_write = 0xff;
 }
 
 static void test_dr_intercept(struct svm_test *test)
@@ -251,7 +251,7 @@ static void test_dr_intercept(struct svm_test *test)
 
 static bool dr_intercept_finished(struct svm_test *test)
 {
-	ulong n = (vmcb->control.exit_code - SVM_EXIT_READ_DR0);
+	ulong n = (vcpu0.vmcb->control.exit_code - SVM_EXIT_READ_DR0);
 
 	/* Only expect DR intercepts */
 	if (n > (SVM_EXIT_MAX_DR_INTERCEPT - SVM_EXIT_READ_DR0))
@@ -267,7 +267,7 @@ static bool dr_intercept_finished(struct svm_test *test)
 	test->scratch = (n % 16);
 
 	/* Jump over MOV instruction */
-	vmcb->save.rip += 3;
+	vcpu0.vmcb->save.rip += 3;
 
 	return false;
 }
@@ -284,7 +284,7 @@ static bool next_rip_supported(void)
 
 static void prepare_next_rip(struct svm_test *test)
 {
-	vmcb->control.intercept |= (1ULL << INTERCEPT_RDTSC);
+	vcpu0.vmcb->control.intercept |= (1ULL << INTERCEPT_RDTSC);
 }
 
 
@@ -300,14 +300,14 @@ static bool check_next_rip(struct svm_test *test)
 	extern char exp_next_rip;
 	unsigned long address = (unsigned long)&exp_next_rip;
 
-	return address == vmcb->control.next_rip;
+	return address == vcpu0.vmcb->control.next_rip;
 }
 
 
 static void prepare_msr_intercept(struct svm_test *test)
 {
-	vmcb->control.intercept |= (1ULL << INTERCEPT_MSR_PROT);
-	vmcb->control.intercept_exceptions |= (1ULL << GP_VECTOR);
+	vcpu0.vmcb->control.intercept |= (1ULL << INTERCEPT_MSR_PROT);
+	vcpu0.vmcb->control.intercept_exceptions |= (1ULL << GP_VECTOR);
 	memset(svm_get_msr_bitmap(), 0xff, MSR_BITMAP_SIZE);
 }
 
@@ -359,12 +359,12 @@ static void test_msr_intercept(struct svm_test *test)
 
 static bool msr_intercept_finished(struct svm_test *test)
 {
-	u32 exit_code = vmcb->control.exit_code;
+	u32 exit_code = vcpu0.vmcb->control.exit_code;
 	u64 exit_info_1;
 	u8 *opcode;
 
 	if (exit_code == SVM_EXIT_MSR) {
-		exit_info_1 = vmcb->control.exit_info_1;
+		exit_info_1 = vcpu0.vmcb->control.exit_info_1;
 	} else {
 		/*
 		 * If #GP exception occurs instead, check that it was
@@ -374,7 +374,7 @@ static bool msr_intercept_finished(struct svm_test *test)
 		if (exit_code != (SVM_EXIT_EXCP_BASE + GP_VECTOR))
 			return true;
 
-		opcode = (u8 *)vmcb->save.rip;
+		opcode = (u8 *)vcpu0.vmcb->save.rip;
 		if (opcode[0] != 0x0f)
 			return true;
 
@@ -394,11 +394,11 @@ static bool msr_intercept_finished(struct svm_test *test)
 		 * RCX holds the MSR index.
 		 */
 		printf("%s 0x%lx #GP exception\n",
-		       exit_info_1 ? "WRMSR" : "RDMSR", get_regs()->rcx);
+		       exit_info_1 ? "WRMSR" : "RDMSR", vcpu0.regs.rcx);
 	}
 
 	/* Jump over RDMSR/WRMSR instruction */
-	vmcb->save.rip += 2;
+	vcpu0.vmcb->save.rip += 2;
 
 	/*
 	 * Test whether the intercept was for RDMSR/WRMSR.
@@ -410,9 +410,9 @@ static bool msr_intercept_finished(struct svm_test *test)
 	 */
 	if (exit_info_1)
 		test->scratch =
-			((get_regs()->rdx << 32) | (get_regs()->rax & 0xffffffff));
+			((vcpu0.regs.rdx << 32) | (vcpu0.regs.rax & 0xffffffff));
 	else
-		test->scratch = get_regs()->rcx;
+		test->scratch = vcpu0.regs.rcx;
 
 	return false;
 }
@@ -425,7 +425,7 @@ static bool check_msr_intercept(struct svm_test *test)
 
 static void prepare_mode_switch(struct svm_test *test)
 {
-	vmcb->control.intercept_exceptions |= (1ULL << GP_VECTOR)
+	vcpu0.vmcb->control.intercept_exceptions |= (1ULL << GP_VECTOR)
 		|  (1ULL << UD_VECTOR)
 		|  (1ULL << DF_VECTOR)
 		|  (1ULL << PF_VECTOR);
@@ -491,16 +491,16 @@ static bool mode_switch_finished(struct svm_test *test)
 {
 	u64 cr0, cr4, efer;
 
-	cr0  = vmcb->save.cr0;
-	cr4  = vmcb->save.cr4;
-	efer = vmcb->save.efer;
+	cr0  = vcpu0.vmcb->save.cr0;
+	cr4  = vcpu0.vmcb->save.cr4;
+	efer = vcpu0.vmcb->save.efer;
 
 	/* Only expect VMMCALL intercepts */
-	if (vmcb->control.exit_code != SVM_EXIT_VMMCALL)
+	if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL)
 		return true;
 
 	/* Jump over VMMCALL instruction */
-	vmcb->save.rip += 3;
+	vcpu0.vmcb->save.rip += 3;
 
 	/* Do sanity checks */
 	switch (test->scratch) {
@@ -535,7 +535,7 @@ static void prepare_ioio(struct svm_test *test)
 {
 	u8 *io_bitmap = svm_get_io_bitmap();
 
-	vmcb->control.intercept |= (1ULL << INTERCEPT_IOIO_PROT);
+	vcpu0.vmcb->control.intercept |= (1ULL << INTERCEPT_IOIO_PROT);
 	test->scratch = 0;
 	memset(io_bitmap, 0, 8192);
 	io_bitmap[8192] = 0xFF;
@@ -619,17 +619,17 @@ static bool ioio_finished(struct svm_test *test)
 	u8 *io_bitmap = svm_get_io_bitmap();
 
 	/* Only expect IOIO intercepts */
-	if (vmcb->control.exit_code == SVM_EXIT_VMMCALL)
+	if (vcpu0.vmcb->control.exit_code == SVM_EXIT_VMMCALL)
 		return true;
 
-	if (vmcb->control.exit_code != SVM_EXIT_IOIO)
+	if (vcpu0.vmcb->control.exit_code != SVM_EXIT_IOIO)
 		return true;
 
 	/* one step forward */
 	test->scratch += 1;
 
-	port = vmcb->control.exit_info_1 >> 16;
-	size = (vmcb->control.exit_info_1 >> SVM_IOIO_SIZE_SHIFT) & 7;
+	port = vcpu0.vmcb->control.exit_info_1 >> 16;
+	size = (vcpu0.vmcb->control.exit_info_1 >> SVM_IOIO_SIZE_SHIFT) & 7;
 
 	while (size--) {
 		io_bitmap[port / 8] &= ~(1 << (port & 7));
@@ -649,7 +649,7 @@ static bool check_ioio(struct svm_test *test)
 
 static void prepare_asid_zero(struct svm_test *test)
 {
-	vmcb->control.asid = 0;
+	vcpu0.vmcb->control.asid = 0;
 }
 
 static void test_asid_zero(struct svm_test *test)
@@ -659,12 +659,12 @@ static void test_asid_zero(struct svm_test *test)
 
 static bool check_asid_zero(struct svm_test *test)
 {
-	return vmcb->control.exit_code == SVM_EXIT_ERR;
+	return vcpu0.vmcb->control.exit_code == SVM_EXIT_ERR;
 }
 
 static void sel_cr0_bug_prepare(struct svm_test *test)
 {
-	vmcb->control.intercept |= (1ULL << INTERCEPT_SELECTIVE_CR0);
+	vcpu0.vmcb->control.intercept |= (1ULL << INTERCEPT_SELECTIVE_CR0);
 }
 
 static bool sel_cr0_bug_finished(struct svm_test *test)
@@ -692,7 +692,7 @@ static void sel_cr0_bug_test(struct svm_test *test)
 
 static bool sel_cr0_bug_check(struct svm_test *test)
 {
-	return vmcb->control.exit_code == SVM_EXIT_CR0_SEL_WRITE;
+	return vcpu0.vmcb->control.exit_code == SVM_EXIT_CR0_SEL_WRITE;
 }
 
 #define TSC_ADJUST_VALUE    (1ll << 32)
@@ -706,7 +706,7 @@ static bool tsc_adjust_supported(void)
 
 static void tsc_adjust_prepare(struct svm_test *test)
 {
-	vmcb->control.tsc_offset = TSC_OFFSET_VALUE;
+	vcpu0.vmcb->control.tsc_offset = TSC_OFFSET_VALUE;
 
 	wrmsr(MSR_IA32_TSC_ADJUST, -TSC_ADJUST_VALUE);
 	int64_t adjust = rdmsr(MSR_IA32_TSC_ADJUST);
@@ -761,13 +761,13 @@ static void svm_tsc_scale_run_testcase(u64 duration,
 	guest_tsc_delay_value = (duration << TSC_SHIFT) * tsc_scale;
 
 	test_set_guest(svm_tsc_scale_guest);
-	vmcb->control.tsc_offset = tsc_offset;
+	vcpu0.vmcb->control.tsc_offset = tsc_offset;
 	wrmsr(MSR_AMD64_TSC_RATIO, (u64)(tsc_scale * (1ULL << 32)));
 
 	start_tsc = rdtsc();
 
 	if (svm_vmrun() != SVM_EXIT_VMMCALL)
-		report_fail("unexpected vm exit code 0x%x", vmcb->control.exit_code);
+		report_fail("unexpected vm exit code 0x%x", vcpu0.vmcb->control.exit_code);
 
 	actual_duration = (rdtsc() - start_tsc) >> TSC_SHIFT;
 
@@ -851,7 +851,7 @@ static bool latency_finished(struct svm_test *test)
 
 	vmexit_sum += cycles;
 
-	vmcb->save.rip += 3;
+	vcpu0.vmcb->save.rip += 3;
 
 	runs -= 1;
 
@@ -862,7 +862,7 @@ static bool latency_finished(struct svm_test *test)
 
 static bool latency_finished_clean(struct svm_test *test)
 {
-	vmcb->control.clean = VMCB_CLEAN_ALL;
+	vcpu0.vmcb->control.clean = VMCB_CLEAN_ALL;
 	return latency_finished(test);
 }
 
@@ -885,7 +885,7 @@ static void lat_svm_insn_prepare(struct svm_test *test)
 
 static bool lat_svm_insn_finished(struct svm_test *test)
 {
-	u64 vmcb_phys = virt_to_phys(vmcb);
+	u64 vmcb_phys = virt_to_phys(vcpu0.vmcb);
 	u64 cycles;
 
 	for ( ; runs != 0; runs--) {
@@ -964,8 +964,8 @@ static void pending_event_prepare(struct svm_test *test)
 
 	pending_event_guest_run = false;
 
-	vmcb->control.intercept |= (1ULL << INTERCEPT_INTR);
-	vmcb->control.int_ctl |= V_INTR_MASKING_MASK;
+	vcpu0.vmcb->control.intercept |= (1ULL << INTERCEPT_INTR);
+	vcpu0.vmcb->control.int_ctl |= V_INTR_MASKING_MASK;
 
 	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL |
 		       APIC_DM_FIXED | ipi_vector, 0);
@@ -982,14 +982,14 @@ static bool pending_event_finished(struct svm_test *test)
 {
 	switch (get_test_stage(test)) {
 	case 0:
-		if (vmcb->control.exit_code != SVM_EXIT_INTR) {
+		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_INTR) {
 			report_fail("VMEXIT not due to pending interrupt. Exit reason 0x%x",
-				    vmcb->control.exit_code);
+				    vcpu0.vmcb->control.exit_code);
 			return true;
 		}
 
-		vmcb->control.intercept &= ~(1ULL << INTERCEPT_INTR);
-		vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
+		vcpu0.vmcb->control.intercept &= ~(1ULL << INTERCEPT_INTR);
+		vcpu0.vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
 
 		if (pending_event_guest_run) {
 			report_fail("Guest ran before host received IPI\n");
@@ -1067,19 +1067,19 @@ static void pending_event_cli_test(struct svm_test *test)
 
 static bool pending_event_cli_finished(struct svm_test *test)
 {
-	if ( vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+	if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
 		report_fail("VM_EXIT return to host is not EXIT_VMMCALL exit reason 0x%x",
-			    vmcb->control.exit_code);
+			    vcpu0.vmcb->control.exit_code);
 		return true;
 	}
 
 	switch (get_test_stage(test)) {
 	case 0:
-		vmcb->save.rip += 3;
+		vcpu0.vmcb->save.rip += 3;
 
 		pending_event_ipi_fired = false;
 
-		vmcb->control.int_ctl |= V_INTR_MASKING_MASK;
+		vcpu0.vmcb->control.int_ctl |= V_INTR_MASKING_MASK;
 
 		/* Now entering again with VINTR_MASKING=1.  */
 		apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL |
@@ -1209,29 +1209,29 @@ static bool interrupt_finished(struct svm_test *test)
 	switch (get_test_stage(test)) {
 	case 0:
 	case 2:
-		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
 			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
-				    vmcb->control.exit_code);
+				    vcpu0.vmcb->control.exit_code);
 			return true;
 		}
-		vmcb->save.rip += 3;
+		vcpu0.vmcb->save.rip += 3;
 
-		vmcb->control.intercept |= (1ULL << INTERCEPT_INTR);
-		vmcb->control.int_ctl |= V_INTR_MASKING_MASK;
+		vcpu0.vmcb->control.intercept |= (1ULL << INTERCEPT_INTR);
+		vcpu0.vmcb->control.int_ctl |= V_INTR_MASKING_MASK;
 		break;
 
 	case 1:
 	case 3:
-		if (vmcb->control.exit_code != SVM_EXIT_INTR) {
+		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_INTR) {
 			report_fail("VMEXIT not due to intr intercept. Exit reason 0x%x",
-				    vmcb->control.exit_code);
+				    vcpu0.vmcb->control.exit_code);
 			return true;
 		}
 
 		sti_nop_cli();
 
-		vmcb->control.intercept &= ~(1ULL << INTERCEPT_INTR);
-		vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
+		vcpu0.vmcb->control.intercept &= ~(1ULL << INTERCEPT_INTR);
+		vcpu0.vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
 		break;
 
 	case 4:
@@ -1291,20 +1291,20 @@ static bool nmi_finished(struct svm_test *test)
 {
 	switch (get_test_stage(test)) {
 	case 0:
-		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
 			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
-				    vmcb->control.exit_code);
+				    vcpu0.vmcb->control.exit_code);
 			return true;
 		}
-		vmcb->save.rip += 3;
+		vcpu0.vmcb->save.rip += 3;
 
-		vmcb->control.intercept |= (1ULL << INTERCEPT_NMI);
+		vcpu0.vmcb->control.intercept |= (1ULL << INTERCEPT_NMI);
 		break;
 
 	case 1:
-		if (vmcb->control.exit_code != SVM_EXIT_NMI) {
+		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_NMI) {
 			report_fail("VMEXIT not due to NMI intercept. Exit reason 0x%x",
-				    vmcb->control.exit_code);
+				    vcpu0.vmcb->control.exit_code);
 			return true;
 		}
 
@@ -1393,20 +1393,20 @@ static bool nmi_hlt_finished(struct svm_test *test)
 {
 	switch (get_test_stage(test)) {
 	case 1:
-		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
 			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
-				    vmcb->control.exit_code);
+				    vcpu0.vmcb->control.exit_code);
 			return true;
 		}
-		vmcb->save.rip += 3;
+		vcpu0.vmcb->save.rip += 3;
 
-		vmcb->control.intercept |= (1ULL << INTERCEPT_NMI);
+		vcpu0.vmcb->control.intercept |= (1ULL << INTERCEPT_NMI);
 		break;
 
 	case 2:
-		if (vmcb->control.exit_code != SVM_EXIT_NMI) {
+		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_NMI) {
 			report_fail("VMEXIT not due to NMI intercept. Exit reason 0x%x",
-				    vmcb->control.exit_code);
+				    vcpu0.vmcb->control.exit_code);
 			return true;
 		}
 
@@ -1451,34 +1451,39 @@ static bool exc_inject_finished(struct svm_test *test)
 {
 	switch (get_test_stage(test)) {
 	case 0:
-		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
 			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
-				    vmcb->control.exit_code);
+				    vcpu0.vmcb->control.exit_code);
 			return true;
 		}
-		vmcb->save.rip += 3;
-		vmcb->control.event_inj = NMI_VECTOR | SVM_EVTINJ_TYPE_EXEPT | SVM_EVTINJ_VALID;
+		vcpu0.vmcb->save.rip += 3;
+		vcpu0.vmcb->control.event_inj = NMI_VECTOR |
+						SVM_EVTINJ_TYPE_EXEPT |
+						SVM_EVTINJ_VALID;
 		break;
 
 	case 1:
-		if (vmcb->control.exit_code != SVM_EXIT_ERR) {
+		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_ERR) {
 			report_fail("VMEXIT not due to error. Exit reason 0x%x",
-				    vmcb->control.exit_code);
+				    vcpu0.vmcb->control.exit_code);
 			return true;
 		}
 		report(count_exc == 0, "exception with vector 2 not injected");
-		vmcb->control.event_inj = DE_VECTOR | SVM_EVTINJ_TYPE_EXEPT | SVM_EVTINJ_VALID;
+		vcpu0.vmcb->control.event_inj = DE_VECTOR |
+						SVM_EVTINJ_TYPE_EXEPT |
+						SVM_EVTINJ_VALID;
 		break;
 
 	case 2:
-		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
 			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
-				    vmcb->control.exit_code);
+				    vcpu0.vmcb->control.exit_code);
 			return true;
 		}
-		vmcb->save.rip += 3;
+		vcpu0.vmcb->save.rip += 3;
 		report(count_exc == 1, "divide overflow exception injected");
-		report(!(vmcb->control.event_inj & SVM_EVTINJ_VALID), "eventinj.VALID cleared");
+		report(!(vcpu0.vmcb->control.event_inj & SVM_EVTINJ_VALID),
+		       "eventinj.VALID cleared");
 		break;
 
 	default:
@@ -1505,9 +1510,10 @@ static void virq_isr(isr_regs_t *regs)
 static void virq_inject_prepare(struct svm_test *test)
 {
 	handle_irq(0xf1, virq_isr);
-	vmcb->control.int_ctl = V_INTR_MASKING_MASK | V_IRQ_MASK |
+
+	vcpu0.vmcb->control.int_ctl = V_INTR_MASKING_MASK | V_IRQ_MASK |
 		(0x0f << V_INTR_PRIO_SHIFT); // Set to the highest priority
-	vmcb->control.int_vector = 0xf1;
+	vcpu0.vmcb->control.int_vector = 0xf1;
 	virq_fired = false;
 	set_test_stage(test, 0);
 }
@@ -1557,66 +1563,66 @@ static void virq_inject_test(struct svm_test *test)
 
 static bool virq_inject_finished(struct svm_test *test)
 {
-	vmcb->save.rip += 3;
+	vcpu0.vmcb->save.rip += 3;
 
 	switch (get_test_stage(test)) {
 	case 0:
-		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
 			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
-				    vmcb->control.exit_code);
+				    vcpu0.vmcb->control.exit_code);
 			return true;
 		}
-		if (vmcb->control.int_ctl & V_IRQ_MASK) {
+		if (vcpu0.vmcb->control.int_ctl & V_IRQ_MASK) {
 			report_fail("V_IRQ not cleared on VMEXIT after firing");
 			return true;
 		}
 		virq_fired = false;
-		vmcb->control.intercept |= (1ULL << INTERCEPT_VINTR);
-		vmcb->control.int_ctl = V_INTR_MASKING_MASK | V_IRQ_MASK |
+		vcpu0.vmcb->control.intercept |= (1ULL << INTERCEPT_VINTR);
+		vcpu0.vmcb->control.int_ctl = V_INTR_MASKING_MASK | V_IRQ_MASK |
 			(0x0f << V_INTR_PRIO_SHIFT);
 		break;
 
 	case 1:
-		if (vmcb->control.exit_code != SVM_EXIT_VINTR) {
+		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VINTR) {
 			report_fail("VMEXIT not due to vintr. Exit reason 0x%x",
-				    vmcb->control.exit_code);
+				    vcpu0.vmcb->control.exit_code);
 			return true;
 		}
 		if (virq_fired) {
 			report_fail("V_IRQ fired before SVM_EXIT_VINTR");
 			return true;
 		}
-		vmcb->control.intercept &= ~(1ULL << INTERCEPT_VINTR);
+		vcpu0.vmcb->control.intercept &= ~(1ULL << INTERCEPT_VINTR);
 		break;
 
 	case 2:
-		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
 			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
-				    vmcb->control.exit_code);
+				    vcpu0.vmcb->control.exit_code);
 			return true;
 		}
 		virq_fired = false;
 		// Set irq to lower priority
-		vmcb->control.int_ctl = V_INTR_MASKING_MASK | V_IRQ_MASK |
+		vcpu0.vmcb->control.int_ctl = V_INTR_MASKING_MASK | V_IRQ_MASK |
 			(0x08 << V_INTR_PRIO_SHIFT);
 		// Raise guest TPR
-		vmcb->control.int_ctl |= 0x0a & V_TPR_MASK;
+		vcpu0.vmcb->control.int_ctl |= 0x0a & V_TPR_MASK;
 		break;
 
 	case 3:
-		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
 			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
-				    vmcb->control.exit_code);
+				    vcpu0.vmcb->control.exit_code);
 			return true;
 		}
-		vmcb->control.intercept |= (1ULL << INTERCEPT_VINTR);
+		vcpu0.vmcb->control.intercept |= (1ULL << INTERCEPT_VINTR);
 		break;
 
 	case 4:
 		// INTERCEPT_VINTR should be ignored because V_INTR_PRIO < V_TPR
-		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
 			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
-				    vmcb->control.exit_code);
+				    vcpu0.vmcb->control.exit_code);
 			return true;
 		}
 		break;
@@ -1669,8 +1675,8 @@ static void reg_corruption_prepare(struct svm_test *test)
 {
 	set_test_stage(test, 0);
 
-	vmcb->control.int_ctl = V_INTR_MASKING_MASK;
-	vmcb->control.intercept |= (1ULL << INTERCEPT_INTR);
+	vcpu0.vmcb->control.int_ctl = V_INTR_MASKING_MASK;
+	vcpu0.vmcb->control.intercept |= (1ULL << INTERCEPT_INTR);
 
 	handle_irq(TIMER_VECTOR, reg_corruption_isr);
 
@@ -1706,9 +1712,9 @@ static bool reg_corruption_finished(struct svm_test *test)
 		goto cleanup;
 	}
 
-	if (vmcb->control.exit_code == SVM_EXIT_INTR) {
+	if (vcpu0.vmcb->control.exit_code == SVM_EXIT_INTR) {
 
-		void* guest_rip = (void*)vmcb->save.rip;
+		void *guest_rip = (void *)vcpu0.vmcb->save.rip;
 
 		sti_nop_cli();
 
@@ -1777,7 +1783,7 @@ static volatile bool init_intercept;
 static void init_intercept_prepare(struct svm_test *test)
 {
 	init_intercept = false;
-	vmcb->control.intercept |= (1ULL << INTERCEPT_INIT);
+	vcpu0.vmcb->control.intercept |= (1ULL << INTERCEPT_INIT);
 }
 
 static void init_intercept_test(struct svm_test *test)
@@ -1787,11 +1793,11 @@ static void init_intercept_test(struct svm_test *test)
 
 static bool init_intercept_finished(struct svm_test *test)
 {
-	vmcb->save.rip += 3;
+	vcpu0.vmcb->save.rip += 3;
 
-	if (vmcb->control.exit_code != SVM_EXIT_INIT) {
+	if (vcpu0.vmcb->control.exit_code != SVM_EXIT_INIT) {
 		report_fail("VMEXIT not due to init intercept. Exit reason 0x%x",
-			    vmcb->control.exit_code);
+			    vcpu0.vmcb->control.exit_code);
 
 		return true;
 	}
@@ -1890,12 +1896,12 @@ static bool host_rflags_finished(struct svm_test *test)
 {
 	switch (get_test_stage(test)) {
 	case 0:
-		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
 			report_fail("Unexpected VMEXIT. Exit reason 0x%x",
-				    vmcb->control.exit_code);
+				    vcpu0.vmcb->control.exit_code);
 			return true;
 		}
-		vmcb->save.rip += 3;
+		vcpu0.vmcb->save.rip += 3;
 		/*
 		 * Setting host EFLAGS.TF not immediately before VMRUN, causes
 		 * #DB trap before first guest instruction is executed
@@ -1903,14 +1909,14 @@ static bool host_rflags_finished(struct svm_test *test)
 		host_rflags_set_tf = true;
 		break;
 	case 1:
-		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL ||
+		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL ||
 		    host_rflags_guest_main_flag != 1) {
 			report_fail("Unexpected VMEXIT or #DB handler"
 				    " invoked before guest main. Exit reason 0x%x",
-				    vmcb->control.exit_code);
+				    vcpu0.vmcb->control.exit_code);
 			return true;
 		}
-		vmcb->save.rip += 3;
+		vcpu0.vmcb->save.rip += 3;
 		/*
 		 * Setting host EFLAGS.TF immediately before VMRUN, causes #DB
 		 * trap after VMRUN completes on the host side (i.e., after
@@ -1919,21 +1925,21 @@ static bool host_rflags_finished(struct svm_test *test)
 		host_rflags_ss_on_vmrun = true;
 		break;
 	case 2:
-		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL ||
+		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL ||
 		    rip_detected != (u64)&vmrun_rip + 3) {
 			report_fail("Unexpected VMEXIT or RIP mismatch."
 				    " Exit reason 0x%x, RIP actual: %lx, RIP expected: "
-				    "%lx", vmcb->control.exit_code,
+				    "%lx", vcpu0.vmcb->control.exit_code,
 				    (u64)&vmrun_rip + 3, rip_detected);
 			return true;
 		}
 		host_rflags_set_rf = true;
 		host_rflags_guest_main_flag = 0;
 		host_rflags_vmrun_reached = false;
-		vmcb->save.rip += 3;
+		vcpu0.vmcb->save.rip += 3;
 		break;
 	case 3:
-		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL ||
+		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL ||
 		    rip_detected != (u64)&vmrun_rip ||
 		    host_rflags_guest_main_flag != 1 ||
 		    host_rflags_db_handler_flag > 1 ||
@@ -1941,13 +1947,13 @@ static bool host_rflags_finished(struct svm_test *test)
 			report_fail("Unexpected VMEXIT or RIP mismatch or "
 				    "EFLAGS.RF not cleared."
 				    " Exit reason 0x%x, RIP actual: %lx, RIP expected: "
-				    "%lx", vmcb->control.exit_code,
+				    "%lx", vcpu0.vmcb->control.exit_code,
 				    (u64)&vmrun_rip, rip_detected);
 			return true;
 		}
 		host_rflags_set_tf = false;
 		host_rflags_set_rf = false;
-		vmcb->save.rip += 3;
+		vcpu0.vmcb->save.rip += 3;
 		break;
 	default:
 		return true;
@@ -1989,7 +1995,7 @@ static void svm_cr4_osxsave_test(void)
 		unsigned long cr4 = read_cr4() | X86_CR4_OSXSAVE;
 
 		write_cr4(cr4);
-		vmcb->save.cr4 = cr4;
+		vcpu0.vmcb->save.cr4 = cr4;
 	}
 
 	report(this_cpu_has(X86_FEATURE_OSXSAVE), "CPUID.01H:ECX.XSAVE set before VMRUN");
@@ -2037,13 +2043,13 @@ static void basic_guest_main(struct svm_test *test)
 		tmp = val | mask;					\
 		switch (cr) {						\
 		case 0:							\
-			vmcb->save.cr0 = tmp;				\
+			vcpu0.vmcb->save.cr0 = tmp;				\
 			break;						\
 		case 3:							\
-			vmcb->save.cr3 = tmp;				\
+			vcpu0.vmcb->save.cr3 = tmp;				\
 			break;						\
 		case 4:							\
-			vmcb->save.cr4 = tmp;				\
+			vcpu0.vmcb->save.cr4 = tmp;				\
 		}							\
 		r = svm_vmrun();					\
 		report(r == exit_code, "Test CR%d %s%d:%d: %lx, wanted exit 0x%x, got 0x%x", \
@@ -2056,39 +2062,39 @@ static void test_efer(void)
 	/*
 	 * Un-setting EFER.SVME is illegal
 	 */
-	u64 efer_saved = vmcb->save.efer;
+	u64 efer_saved = vcpu0.vmcb->save.efer;
 	u64 efer = efer_saved;
 
 	report (svm_vmrun() == SVM_EXIT_VMMCALL, "EFER.SVME: %lx", efer);
 	efer &= ~EFER_SVME;
-	vmcb->save.efer = efer;
+	vcpu0.vmcb->save.efer = efer;
 	report (svm_vmrun() == SVM_EXIT_ERR, "EFER.SVME: %lx", efer);
-	vmcb->save.efer = efer_saved;
+	vcpu0.vmcb->save.efer = efer_saved;
 
 	/*
 	 * EFER MBZ bits: 63:16, 9
 	 */
-	efer_saved = vmcb->save.efer;
+	efer_saved = vcpu0.vmcb->save.efer;
 
-	SVM_TEST_REG_RESERVED_BITS(8, 9, 1, "EFER", vmcb->save.efer,
+	SVM_TEST_REG_RESERVED_BITS(8, 9, 1, "EFER", vcpu0.vmcb->save.efer,
 				   efer_saved, SVM_EFER_RESERVED_MASK);
-	SVM_TEST_REG_RESERVED_BITS(16, 63, 4, "EFER", vmcb->save.efer,
+	SVM_TEST_REG_RESERVED_BITS(16, 63, 4, "EFER", vcpu0.vmcb->save.efer,
 				   efer_saved, SVM_EFER_RESERVED_MASK);
 
 	/*
 	 * EFER.LME and CR0.PG are both set and CR4.PAE is zero.
 	 */
-	u64 cr0_saved = vmcb->save.cr0;
+	u64 cr0_saved = vcpu0.vmcb->save.cr0;
 	u64 cr0;
-	u64 cr4_saved = vmcb->save.cr4;
+	u64 cr4_saved = vcpu0.vmcb->save.cr4;
 	u64 cr4;
 
 	efer = efer_saved | EFER_LME;
-	vmcb->save.efer = efer;
+	vcpu0.vmcb->save.efer = efer;
 	cr0 = cr0_saved | X86_CR0_PG | X86_CR0_PE;
-	vmcb->save.cr0 = cr0;
+	vcpu0.vmcb->save.cr0 = cr0;
 	cr4 = cr4_saved & ~X86_CR4_PAE;
-	vmcb->save.cr4 = cr4;
+	vcpu0.vmcb->save.cr4 = cr4;
 	report(svm_vmrun() == SVM_EXIT_ERR, "EFER.LME=1 (%lx), "
 	       "CR0.PG=1 (%lx) and CR4.PAE=0 (%lx)", efer, cr0, cr4);
 
@@ -2099,31 +2105,31 @@ static void test_efer(void)
 	 * SVM_EXIT_ERR.
 	 */
 	cr4 = cr4_saved | X86_CR4_PAE;
-	vmcb->save.cr4 = cr4;
+	vcpu0.vmcb->save.cr4 = cr4;
 	cr0 &= ~X86_CR0_PE;
-	vmcb->save.cr0 = cr0;
+	vcpu0.vmcb->save.cr0 = cr0;
 	report(svm_vmrun() == SVM_EXIT_ERR, "EFER.LME=1 (%lx), "
 	       "CR0.PG=1 and CR0.PE=0 (%lx)", efer, cr0);
 
 	/*
 	 * EFER.LME, CR0.PG, CR4.PAE, CS.L, and CS.D are all non-zero.
 	 */
-	u32 cs_attrib_saved = vmcb->save.cs.attrib;
+	u32 cs_attrib_saved = vcpu0.vmcb->save.cs.attrib;
 	u32 cs_attrib;
 
 	cr0 |= X86_CR0_PE;
-	vmcb->save.cr0 = cr0;
+	vcpu0.vmcb->save.cr0 = cr0;
 	cs_attrib = cs_attrib_saved | SVM_SELECTOR_L_MASK |
 		SVM_SELECTOR_DB_MASK;
-	vmcb->save.cs.attrib = cs_attrib;
+	vcpu0.vmcb->save.cs.attrib = cs_attrib;
 	report(svm_vmrun() == SVM_EXIT_ERR, "EFER.LME=1 (%lx), "
 	       "CR0.PG=1 (%lx), CR4.PAE=1 (%lx), CS.L=1 and CS.D=1 (%x)",
 	       efer, cr0, cr4, cs_attrib);
 
-	vmcb->save.cr0 = cr0_saved;
-	vmcb->save.cr4 = cr4_saved;
-	vmcb->save.efer = efer_saved;
-	vmcb->save.cs.attrib = cs_attrib_saved;
+	vcpu0.vmcb->save.cr0 = cr0_saved;
+	vcpu0.vmcb->save.cr4 = cr4_saved;
+	vcpu0.vmcb->save.efer = efer_saved;
+	vcpu0.vmcb->save.cs.attrib = cs_attrib_saved;
 }
 
 static void test_cr0(void)
@@ -2131,37 +2137,37 @@ static void test_cr0(void)
 	/*
 	 * Un-setting CR0.CD and setting CR0.NW is illegal combination
 	 */
-	u64 cr0_saved = vmcb->save.cr0;
+	u64 cr0_saved = vcpu0.vmcb->save.cr0;
 	u64 cr0 = cr0_saved;
 
 	cr0 |= X86_CR0_CD;
 	cr0 &= ~X86_CR0_NW;
-	vmcb->save.cr0 = cr0;
+	vcpu0.vmcb->save.cr0 = cr0;
 	report (svm_vmrun() == SVM_EXIT_VMMCALL, "Test CR0 CD=1,NW=0: %lx",
 		cr0);
 	cr0 |= X86_CR0_NW;
-	vmcb->save.cr0 = cr0;
+	vcpu0.vmcb->save.cr0 = cr0;
 	report (svm_vmrun() == SVM_EXIT_VMMCALL, "Test CR0 CD=1,NW=1: %lx",
 		cr0);
 	cr0 &= ~X86_CR0_NW;
 	cr0 &= ~X86_CR0_CD;
-	vmcb->save.cr0 = cr0;
+	vcpu0.vmcb->save.cr0 = cr0;
 	report (svm_vmrun() == SVM_EXIT_VMMCALL, "Test CR0 CD=0,NW=0: %lx",
 		cr0);
 	cr0 |= X86_CR0_NW;
-	vmcb->save.cr0 = cr0;
+	vcpu0.vmcb->save.cr0 = cr0;
 	report (svm_vmrun() == SVM_EXIT_ERR, "Test CR0 CD=0,NW=1: %lx",
 		cr0);
-	vmcb->save.cr0 = cr0_saved;
+	vcpu0.vmcb->save.cr0 = cr0_saved;
 
 	/*
 	 * CR0[63:32] are not zero
 	 */
 	cr0 = cr0_saved;
 
-	SVM_TEST_REG_RESERVED_BITS(32, 63, 4, "CR0", vmcb->save.cr0, cr0_saved,
+	SVM_TEST_REG_RESERVED_BITS(32, 63, 4, "CR0", vcpu0.vmcb->save.cr0, cr0_saved,
 				   SVM_CR0_RESERVED_MASK);
-	vmcb->save.cr0 = cr0_saved;
+	vcpu0.vmcb->save.cr0 = cr0_saved;
 }
 
 static void test_cr3(void)
@@ -2170,37 +2176,37 @@ static void test_cr3(void)
 	 * CR3 MBZ bits based on different modes:
 	 *   [63:52] - long mode
 	 */
-	u64 cr3_saved = vmcb->save.cr3;
+	u64 cr3_saved = vcpu0.vmcb->save.cr3;
 
 	SVM_TEST_CR_RESERVED_BITS(0, 63, 1, 3, cr3_saved,
 				  SVM_CR3_LONG_MBZ_MASK, SVM_EXIT_ERR, "");
 
-	vmcb->save.cr3 = cr3_saved & ~SVM_CR3_LONG_MBZ_MASK;
+	vcpu0.vmcb->save.cr3 = cr3_saved & ~SVM_CR3_LONG_MBZ_MASK;
 	report(svm_vmrun() == SVM_EXIT_VMMCALL, "Test CR3 63:0: %lx",
-	       vmcb->save.cr3);
+	       vcpu0.vmcb->save.cr3);
 
 	/*
 	 * CR3 non-MBZ reserved bits based on different modes:
 	 *   [11:5] [2:0] - long mode (PCIDE=0)
 	 *          [2:0] - PAE legacy mode
 	 */
-	u64 cr4_saved = vmcb->save.cr4;
+	u64 cr4_saved = vcpu0.vmcb->save.cr4;
 	u64 *pdpe = npt_get_pml4e();
 
 	/*
 	 * Long mode
 	 */
 	if (this_cpu_has(X86_FEATURE_PCID)) {
-		vmcb->save.cr4 = cr4_saved | X86_CR4_PCIDE;
+		vcpu0.vmcb->save.cr4 = cr4_saved | X86_CR4_PCIDE;
 		SVM_TEST_CR_RESERVED_BITS(0, 11, 1, 3, cr3_saved,
 					  SVM_CR3_LONG_RESERVED_MASK, SVM_EXIT_VMMCALL, "(PCIDE=1) ");
 
-		vmcb->save.cr3 = cr3_saved & ~SVM_CR3_LONG_RESERVED_MASK;
+		vcpu0.vmcb->save.cr3 = cr3_saved & ~SVM_CR3_LONG_RESERVED_MASK;
 		report(svm_vmrun() == SVM_EXIT_VMMCALL, "Test CR3 63:0: %lx",
-		       vmcb->save.cr3);
+		       vcpu0.vmcb->save.cr3);
 	}
 
-	vmcb->save.cr4 = cr4_saved & ~X86_CR4_PCIDE;
+	vcpu0.vmcb->save.cr4 = cr4_saved & ~X86_CR4_PCIDE;
 
 	if (!npt_supported())
 		goto skip_npt_only;
@@ -2212,44 +2218,44 @@ static void test_cr3(void)
 				  SVM_CR3_LONG_RESERVED_MASK, SVM_EXIT_NPF, "(PCIDE=0) ");
 
 	pdpe[0] |= 1ULL;
-	vmcb->save.cr3 = cr3_saved;
+	vcpu0.vmcb->save.cr3 = cr3_saved;
 
 	/*
 	 * PAE legacy
 	 */
 	pdpe[0] &= ~1ULL;
-	vmcb->save.cr4 = cr4_saved | X86_CR4_PAE;
+	vcpu0.vmcb->save.cr4 = cr4_saved | X86_CR4_PAE;
 	SVM_TEST_CR_RESERVED_BITS(0, 2, 1, 3, cr3_saved,
 				  SVM_CR3_PAE_LEGACY_RESERVED_MASK, SVM_EXIT_NPF, "(PAE) ");
 
 	pdpe[0] |= 1ULL;
 
 skip_npt_only:
-	vmcb->save.cr3 = cr3_saved;
-	vmcb->save.cr4 = cr4_saved;
+	vcpu0.vmcb->save.cr3 = cr3_saved;
+	vcpu0.vmcb->save.cr4 = cr4_saved;
 }
 
 /* Test CR4 MBZ bits based on legacy or long modes */
 static void test_cr4(void)
 {
-	u64 cr4_saved = vmcb->save.cr4;
-	u64 efer_saved = vmcb->save.efer;
+	u64 cr4_saved = vcpu0.vmcb->save.cr4;
+	u64 efer_saved = vcpu0.vmcb->save.efer;
 	u64 efer = efer_saved;
 
 	efer &= ~EFER_LME;
-	vmcb->save.efer = efer;
+	vcpu0.vmcb->save.efer = efer;
 	SVM_TEST_CR_RESERVED_BITS(12, 31, 1, 4, cr4_saved,
 				  SVM_CR4_LEGACY_RESERVED_MASK, SVM_EXIT_ERR, "");
 
 	efer |= EFER_LME;
-	vmcb->save.efer = efer;
+	vcpu0.vmcb->save.efer = efer;
 	SVM_TEST_CR_RESERVED_BITS(12, 31, 1, 4, cr4_saved,
 				  SVM_CR4_RESERVED_MASK, SVM_EXIT_ERR, "");
 	SVM_TEST_CR_RESERVED_BITS(32, 63, 4, 4, cr4_saved,
 				  SVM_CR4_RESERVED_MASK, SVM_EXIT_ERR, "");
 
-	vmcb->save.cr4 = cr4_saved;
-	vmcb->save.efer = efer_saved;
+	vcpu0.vmcb->save.cr4 = cr4_saved;
+	vcpu0.vmcb->save.efer = efer_saved;
 }
 
 static void test_dr(void)
@@ -2257,27 +2263,27 @@ static void test_dr(void)
 	/*
 	 * DR6[63:32] and DR7[63:32] are MBZ
 	 */
-	u64 dr_saved = vmcb->save.dr6;
+	u64 dr_saved = vcpu0.vmcb->save.dr6;
 
-	SVM_TEST_REG_RESERVED_BITS(32, 63, 4, "DR6", vmcb->save.dr6, dr_saved,
+	SVM_TEST_REG_RESERVED_BITS(32, 63, 4, "DR6", vcpu0.vmcb->save.dr6, dr_saved,
 				   SVM_DR6_RESERVED_MASK);
-	vmcb->save.dr6 = dr_saved;
+	vcpu0.vmcb->save.dr6 = dr_saved;
 
-	dr_saved = vmcb->save.dr7;
-	SVM_TEST_REG_RESERVED_BITS(32, 63, 4, "DR7", vmcb->save.dr7, dr_saved,
+	dr_saved = vcpu0.vmcb->save.dr7;
+	SVM_TEST_REG_RESERVED_BITS(32, 63, 4, "DR7", vcpu0.vmcb->save.dr7, dr_saved,
 				   SVM_DR7_RESERVED_MASK);
 
-	vmcb->save.dr7 = dr_saved;
+	vcpu0.vmcb->save.dr7 = dr_saved;
 }
 
 /* TODO: verify if high 32-bits are sign- or zero-extended on bare metal */
 #define	TEST_BITMAP_ADDR(save_intercept, type, addr, exit_code,		\
 			 msg) {						\
-		vmcb->control.intercept = saved_intercept | 1ULL << type; \
+		vcpu0.vmcb->control.intercept = saved_intercept | 1ULL << type; \
 		if (type == INTERCEPT_MSR_PROT)				\
-			vmcb->control.msrpm_base_pa = addr;		\
+			vcpu0.vmcb->control.msrpm_base_pa = addr;		\
 		else							\
-			vmcb->control.iopm_base_pa = addr;		\
+			vcpu0.vmcb->control.iopm_base_pa = addr;		\
 		report(svm_vmrun() == exit_code,			\
 		       "Test %s address: %lx", msg, addr);		\
 	}
@@ -2300,7 +2306,7 @@ static void test_dr(void)
  */
 static void test_msrpm_iopm_bitmap_addrs(void)
 {
-	u64 saved_intercept = vmcb->control.intercept;
+	u64 saved_intercept = vcpu0.vmcb->control.intercept;
 	u64 addr_beyond_limit = 1ull << cpuid_maxphyaddr();
 	u64 addr = virt_to_phys(svm_get_msr_bitmap()) & (~((1ull << 12) - 1));
 	u8 *io_bitmap = svm_get_io_bitmap();
@@ -2342,7 +2348,7 @@ static void test_msrpm_iopm_bitmap_addrs(void)
 	TEST_BITMAP_ADDR(saved_intercept, INTERCEPT_IOIO_PROT, addr,
 			 SVM_EXIT_VMMCALL, "IOPM");
 
-	vmcb->control.intercept = saved_intercept;
+	vcpu0.vmcb->control.intercept = saved_intercept;
 }
 
 /*
@@ -2372,22 +2378,22 @@ static void test_canonicalization(void)
 	u64 saved_addr;
 	u64 return_value;
 	u64 addr_limit;
-	u64 vmcb_phys = virt_to_phys(vmcb);
+	u64 vmcb_phys = virt_to_phys(vcpu0.vmcb);
 
 	addr_limit = (this_cpu_has(X86_FEATURE_LA57)) ? 57 : 48;
 	u64 noncanonical_mask = NONCANONICAL & ~((1ul << addr_limit) - 1);
 
-	TEST_CANONICAL_VMLOAD(vmcb->save.fs.base, "FS");
-	TEST_CANONICAL_VMLOAD(vmcb->save.gs.base, "GS");
-	TEST_CANONICAL_VMLOAD(vmcb->save.ldtr.base, "LDTR");
-	TEST_CANONICAL_VMLOAD(vmcb->save.tr.base, "TR");
-	TEST_CANONICAL_VMLOAD(vmcb->save.kernel_gs_base, "KERNEL GS");
-	TEST_CANONICAL_VMRUN(vmcb->save.es.base, "ES");
-	TEST_CANONICAL_VMRUN(vmcb->save.cs.base, "CS");
-	TEST_CANONICAL_VMRUN(vmcb->save.ss.base, "SS");
-	TEST_CANONICAL_VMRUN(vmcb->save.ds.base, "DS");
-	TEST_CANONICAL_VMRUN(vmcb->save.gdtr.base, "GDTR");
-	TEST_CANONICAL_VMRUN(vmcb->save.idtr.base, "IDTR");
+	TEST_CANONICAL_VMLOAD(vcpu0.vmcb->save.fs.base, "FS");
+	TEST_CANONICAL_VMLOAD(vcpu0.vmcb->save.gs.base, "GS");
+	TEST_CANONICAL_VMLOAD(vcpu0.vmcb->save.ldtr.base, "LDTR");
+	TEST_CANONICAL_VMLOAD(vcpu0.vmcb->save.tr.base, "TR");
+	TEST_CANONICAL_VMLOAD(vcpu0.vmcb->save.kernel_gs_base, "KERNEL GS");
+	TEST_CANONICAL_VMRUN(vcpu0.vmcb->save.es.base, "ES");
+	TEST_CANONICAL_VMRUN(vcpu0.vmcb->save.cs.base, "CS");
+	TEST_CANONICAL_VMRUN(vcpu0.vmcb->save.ss.base, "SS");
+	TEST_CANONICAL_VMRUN(vcpu0.vmcb->save.ds.base, "DS");
+	TEST_CANONICAL_VMRUN(vcpu0.vmcb->save.gdtr.base, "GDTR");
+	TEST_CANONICAL_VMRUN(vcpu0.vmcb->save.idtr.base, "IDTR");
 }
 
 /*
@@ -2441,7 +2447,7 @@ static void svm_test_singlestep(void)
 	/*
 	 * Trap expected after completion of first guest instruction
 	 */
-	vmcb->save.rflags |= X86_EFLAGS_TF;
+	vcpu0.vmcb->save.rflags |= X86_EFLAGS_TF;
 	report (__svm_vmrun((u64)guest_rflags_test_guest) == SVM_EXIT_VMMCALL &&
 		guest_rflags_test_trap_rip == (u64)&insn2,
 		"Test EFLAGS.TF on VMRUN: trap expected  after completion of first guest instruction");
@@ -2449,17 +2455,19 @@ static void svm_test_singlestep(void)
 	 * No trap expected
 	 */
 	guest_rflags_test_trap_rip = 0;
-	vmcb->save.rip += 3;
-	vmcb->save.rflags |= X86_EFLAGS_TF;
-	report (__svm_vmrun(vmcb->save.rip) == SVM_EXIT_VMMCALL &&
-		guest_rflags_test_trap_rip == 0, "Test EFLAGS.TF on VMRUN: trap not expected");
+	vcpu0.vmcb->save.rip += 3;
+	vcpu0.vmcb->save.rflags |= X86_EFLAGS_TF;
+	report(__svm_vmrun(vcpu0.vmcb->save.rip) == SVM_EXIT_VMMCALL &&
+		guest_rflags_test_trap_rip == 0,
+		"Test EFLAGS.TF on VMRUN: trap not expected");
 
 	/*
 	 * Let guest finish execution
 	 */
-	vmcb->save.rip += 3;
-	report (__svm_vmrun(vmcb->save.rip) == SVM_EXIT_VMMCALL &&
-		vmcb->save.rip == (u64)&guest_end, "Test EFLAGS.TF on VMRUN: guest execution completion");
+	vcpu0.vmcb->save.rip += 3;
+	report(__svm_vmrun(vcpu0.vmcb->save.rip) == SVM_EXIT_VMMCALL &&
+		vcpu0.vmcb->save.rip == (u64)&guest_end,
+		"Test EFLAGS.TF on VMRUN: guest execution completion");
 }
 
 static bool volatile svm_errata_reproduced = false;
@@ -2530,7 +2538,7 @@ static void svm_vmrun_errata_test(void)
 
 static void vmload_vmsave_guest_main(struct svm_test *test)
 {
-	u64 vmcb_phys = virt_to_phys(vmcb);
+	u64 vmcb_phys = virt_to_phys(vcpu0.vmcb);
 
 	asm volatile ("vmload %0" : : "a"(vmcb_phys));
 	asm volatile ("vmsave %0" : : "a"(vmcb_phys));
@@ -2538,7 +2546,7 @@ static void vmload_vmsave_guest_main(struct svm_test *test)
 
 static void svm_vmload_vmsave(void)
 {
-	u32 intercept_saved = vmcb->control.intercept;
+	u32 intercept_saved = vcpu0.vmcb->control.intercept;
 
 	test_set_guest(vmload_vmsave_guest_main);
 
@@ -2546,49 +2554,49 @@ static void svm_vmload_vmsave(void)
 	 * Disabling intercept for VMLOAD and VMSAVE doesn't cause
 	 * respective #VMEXIT to host
 	 */
-	vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMLOAD);
-	vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMSAVE);
+	vcpu0.vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMLOAD);
+	vcpu0.vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMSAVE);
 	svm_vmrun();
-	report(vmcb->control.exit_code == SVM_EXIT_VMMCALL, "Test "
+	report(vcpu0.vmcb->control.exit_code == SVM_EXIT_VMMCALL, "Test "
 	       "VMLOAD/VMSAVE intercept: Expected VMMCALL #VMEXIT");
 
 	/*
 	 * Enabling intercept for VMLOAD and VMSAVE causes respective
 	 * #VMEXIT to host
 	 */
-	vmcb->control.intercept |= (1ULL << INTERCEPT_VMLOAD);
+	vcpu0.vmcb->control.intercept |= (1ULL << INTERCEPT_VMLOAD);
 	svm_vmrun();
-	report(vmcb->control.exit_code == SVM_EXIT_VMLOAD, "Test "
+	report(vcpu0.vmcb->control.exit_code == SVM_EXIT_VMLOAD, "Test "
 	       "VMLOAD/VMSAVE intercept: Expected VMLOAD #VMEXIT");
-	vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMLOAD);
-	vmcb->control.intercept |= (1ULL << INTERCEPT_VMSAVE);
+	vcpu0.vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMLOAD);
+	vcpu0.vmcb->control.intercept |= (1ULL << INTERCEPT_VMSAVE);
 	svm_vmrun();
-	report(vmcb->control.exit_code == SVM_EXIT_VMSAVE, "Test "
+	report(vcpu0.vmcb->control.exit_code == SVM_EXIT_VMSAVE, "Test "
 	       "VMLOAD/VMSAVE intercept: Expected VMSAVE #VMEXIT");
-	vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMSAVE);
+	vcpu0.vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMSAVE);
 	svm_vmrun();
-	report(vmcb->control.exit_code == SVM_EXIT_VMMCALL, "Test "
+	report(vcpu0.vmcb->control.exit_code == SVM_EXIT_VMMCALL, "Test "
 	       "VMLOAD/VMSAVE intercept: Expected VMMCALL #VMEXIT");
 
-	vmcb->control.intercept |= (1ULL << INTERCEPT_VMLOAD);
+	vcpu0.vmcb->control.intercept |= (1ULL << INTERCEPT_VMLOAD);
 	svm_vmrun();
-	report(vmcb->control.exit_code == SVM_EXIT_VMLOAD, "Test "
+	report(vcpu0.vmcb->control.exit_code == SVM_EXIT_VMLOAD, "Test "
 	       "VMLOAD/VMSAVE intercept: Expected VMLOAD #VMEXIT");
-	vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMLOAD);
+	vcpu0.vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMLOAD);
 	svm_vmrun();
-	report(vmcb->control.exit_code == SVM_EXIT_VMMCALL, "Test "
+	report(vcpu0.vmcb->control.exit_code == SVM_EXIT_VMMCALL, "Test "
 	       "VMLOAD/VMSAVE intercept: Expected VMMCALL #VMEXIT");
 
-	vmcb->control.intercept |= (1ULL << INTERCEPT_VMSAVE);
+	vcpu0.vmcb->control.intercept |= (1ULL << INTERCEPT_VMSAVE);
 	svm_vmrun();
-	report(vmcb->control.exit_code == SVM_EXIT_VMSAVE, "Test "
+	report(vcpu0.vmcb->control.exit_code == SVM_EXIT_VMSAVE, "Test "
 	       "VMLOAD/VMSAVE intercept: Expected VMSAVE #VMEXIT");
-	vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMSAVE);
+	vcpu0.vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMSAVE);
 	svm_vmrun();
-	report(vmcb->control.exit_code == SVM_EXIT_VMMCALL, "Test "
+	report(vcpu0.vmcb->control.exit_code == SVM_EXIT_VMMCALL, "Test "
 	       "VMLOAD/VMSAVE intercept: Expected VMMCALL #VMEXIT");
 
-	vmcb->control.intercept = intercept_saved;
+	vcpu0.vmcb->control.intercept = intercept_saved;
 }
 
 static void prepare_vgif_enabled(struct svm_test *test)
@@ -2605,42 +2613,42 @@ static bool vgif_finished(struct svm_test *test)
 	switch (get_test_stage(test))
 		{
 		case 0:
-			if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+			if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
 				report_fail("VMEXIT not due to vmmcall.");
 				return true;
 			}
-			vmcb->control.int_ctl |= V_GIF_ENABLED_MASK;
-			vmcb->save.rip += 3;
+			vcpu0.vmcb->control.int_ctl |= V_GIF_ENABLED_MASK;
+			vcpu0.vmcb->save.rip += 3;
 			inc_test_stage(test);
 			break;
 		case 1:
-			if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+			if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
 				report_fail("VMEXIT not due to vmmcall.");
 				return true;
 			}
-			if (!(vmcb->control.int_ctl & V_GIF_MASK)) {
+			if (!(vcpu0.vmcb->control.int_ctl & V_GIF_MASK)) {
 				report_fail("Failed to set VGIF when executing STGI.");
-				vmcb->control.int_ctl &= ~V_GIF_ENABLED_MASK;
+				vcpu0.vmcb->control.int_ctl &= ~V_GIF_ENABLED_MASK;
 				return true;
 			}
 			report_pass("STGI set VGIF bit.");
-			vmcb->save.rip += 3;
+			vcpu0.vmcb->save.rip += 3;
 			inc_test_stage(test);
 			break;
 		case 2:
-			if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+			if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
 				report_fail("VMEXIT not due to vmmcall.");
 				return true;
 			}
-			if (vmcb->control.int_ctl & V_GIF_MASK) {
+			if (vcpu0.vmcb->control.int_ctl & V_GIF_MASK) {
 				report_fail("Failed to clear VGIF when executing CLGI.");
-				vmcb->control.int_ctl &= ~V_GIF_ENABLED_MASK;
+				vcpu0.vmcb->control.int_ctl &= ~V_GIF_ENABLED_MASK;
 				return true;
 			}
 			report_pass("CLGI cleared VGIF bit.");
-			vmcb->save.rip += 3;
+			vcpu0.vmcb->save.rip += 3;
 			inc_test_stage(test);
-			vmcb->control.int_ctl &= ~V_GIF_ENABLED_MASK;
+			vcpu0.vmcb->control.int_ctl &= ~V_GIF_ENABLED_MASK;
 			break;
 		default:
 			return true;
@@ -2683,14 +2691,16 @@ static void pause_filter_run_test(int pause_iterations, int filter_value, int wa
 	pause_test_counter = pause_iterations;
 	wait_counter = wait_iterations;
 
-	vmcb->control.pause_filter_count = filter_value;
-	vmcb->control.pause_filter_thresh = threshold;
+	vcpu0.vmcb->control.pause_filter_count = filter_value;
+	vcpu0.vmcb->control.pause_filter_thresh = threshold;
 	svm_vmrun();
 
 	if (filter_value <= pause_iterations || wait_iterations < threshold)
-		report(vmcb->control.exit_code == SVM_EXIT_PAUSE, "expected PAUSE vmexit");
+		report(vcpu0.vmcb->control.exit_code == SVM_EXIT_PAUSE,
+		       "expected PAUSE vmexit");
 	else
-		report(vmcb->control.exit_code == SVM_EXIT_VMMCALL, "no expected PAUSE vmexit");
+		report(vcpu0.vmcb->control.exit_code == SVM_EXIT_VMMCALL,
+		       "no expected PAUSE vmexit");
 }
 
 static void pause_filter_test(void)
@@ -2700,7 +2710,7 @@ static void pause_filter_test(void)
 		return;
 	}
 
-	vmcb->control.intercept |= (1 << INTERCEPT_PAUSE);
+	vcpu0.vmcb->control.intercept |= (1 << INTERCEPT_PAUSE);
 
 	// filter count more that pause count - no VMexit
 	pause_filter_run_test(10, 9, 0, 0);
@@ -2729,7 +2739,7 @@ static void svm_no_nm_test(void)
 	write_cr0(read_cr0() & ~X86_CR0_TS);
 	test_set_guest((test_guest_func)fnop);
 
-	vmcb->save.cr0 = vmcb->save.cr0 & ~(X86_CR0_TS | X86_CR0_EM);
+	vcpu0.vmcb->save.cr0 = vcpu0.vmcb->save.cr0 & ~(X86_CR0_TS | X86_CR0_EM);
 	report(svm_vmrun() == SVM_EXIT_VMMCALL,
 	       "fnop with CR0.TS and CR0.EM unset no #NM excpetion");
 }
@@ -2860,21 +2870,20 @@ static void svm_lbrv_test0(void)
 
 static void svm_lbrv_test1(void)
 {
-	struct svm_gprs *regs = get_regs();
 
 	report(true, "Test that without LBRV enabled, guest LBR state does 'leak' to the host(1)");
 
-	vmcb->save.rip = (ulong)svm_lbrv_test_guest1;
-	vmcb->control.virt_ext = 0;
+	vcpu0.vmcb->save.rip = (ulong)svm_lbrv_test_guest1;
+	vcpu0.vmcb->control.virt_ext = 0;
 
 	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
 	DO_BRANCH(host_branch1);
-	SVM_VMRUN(vmcb, regs);
+	SVM_VMRUN(&vcpu0);
 	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
 
-	if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+	if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
 		report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
-		       vmcb->control.exit_code);
+		       vcpu0.vmcb->control.exit_code);
 		return;
 	}
 
@@ -2884,23 +2893,21 @@ static void svm_lbrv_test1(void)
 
 static void svm_lbrv_test2(void)
 {
-	struct svm_gprs *regs = get_regs();
-
 	report(true, "Test that without LBRV enabled, guest LBR state does 'leak' to the host(2)");
 
-	vmcb->save.rip = (ulong)svm_lbrv_test_guest2;
-	vmcb->control.virt_ext = 0;
+	vcpu0.vmcb->save.rip = (ulong)svm_lbrv_test_guest2;
+	vcpu0.vmcb->control.virt_ext = 0;
 
 	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
 	DO_BRANCH(host_branch2);
 	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
-	SVM_VMRUN(vmcb, regs);
+	SVM_VMRUN(&vcpu0);
 	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
 	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
 
-	if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+	if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
 		report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
-		       vmcb->control.exit_code);
+		       vcpu0.vmcb->control.exit_code);
 		return;
 	}
 
@@ -2910,32 +2917,32 @@ static void svm_lbrv_test2(void)
 
 static void svm_lbrv_nested_test1(void)
 {
-	struct svm_gprs *regs = get_regs();
-
 	if (!lbrv_supported()) {
 		report_skip("LBRV not supported in the guest");
 		return;
 	}
 
 	report(true, "Test that with LBRV enabled, guest LBR state doesn't leak (1)");
-	vmcb->save.rip = (ulong)svm_lbrv_test_guest1;
-	vmcb->control.virt_ext = LBR_CTL_ENABLE_MASK;
-	vmcb->save.dbgctl = DEBUGCTLMSR_LBR;
+	vcpu0.vmcb->save.rip = (ulong)svm_lbrv_test_guest1;
+	vcpu0.vmcb->control.virt_ext = LBR_CTL_ENABLE_MASK;
+	vcpu0.vmcb->save.dbgctl = DEBUGCTLMSR_LBR;
 
 	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
 	DO_BRANCH(host_branch3);
-	SVM_VMRUN(vmcb, regs);
+	SVM_VMRUN(&vcpu0);
 	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
 	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
 
-	if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+	if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
 		report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
-		       vmcb->control.exit_code);
+		       vcpu0.vmcb->control.exit_code);
 		return;
 	}
 
-	if (vmcb->save.dbgctl != 0) {
-		report(false, "unexpected virtual guest MSR_IA32_DEBUGCTLMSR value 0x%lx", vmcb->save.dbgctl);
+	if (vcpu0.vmcb->save.dbgctl != 0) {
+		report(false,
+		       "unexpected virtual guest MSR_IA32_DEBUGCTLMSR value 0x%lx",
+		       vcpu0.vmcb->save.dbgctl);
 		return;
 	}
 
@@ -2945,30 +2952,28 @@ static void svm_lbrv_nested_test1(void)
 
 static void svm_lbrv_nested_test2(void)
 {
-	struct svm_gprs *regs = get_regs();
-
 	if (!lbrv_supported()) {
 		report_skip("LBRV not supported in the guest");
 		return;
 	}
 
 	report(true, "Test that with LBRV enabled, guest LBR state doesn't leak (2)");
-	vmcb->save.rip = (ulong)svm_lbrv_test_guest2;
-	vmcb->control.virt_ext = LBR_CTL_ENABLE_MASK;
+	vcpu0.vmcb->save.rip = (ulong)svm_lbrv_test_guest2;
+	vcpu0.vmcb->control.virt_ext = LBR_CTL_ENABLE_MASK;
 
-	vmcb->save.dbgctl = 0;
-	vmcb->save.br_from = (u64)&host_branch2_from;
-	vmcb->save.br_to = (u64)&host_branch2_to;
+	vcpu0.vmcb->save.dbgctl = 0;
+	vcpu0.vmcb->save.br_from = (u64)&host_branch2_from;
+	vcpu0.vmcb->save.br_to = (u64)&host_branch2_to;
 
 	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
 	DO_BRANCH(host_branch4);
-	SVM_VMRUN(vmcb, regs);
+	SVM_VMRUN(&vcpu0);
 	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
 	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
 
-	if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+	if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
 		report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
-		       vmcb->control.exit_code);
+		       vcpu0.vmcb->control.exit_code);
 		return;
 	}
 
@@ -3013,8 +3018,8 @@ static void svm_intr_intercept_mix_run_guest(volatile int *counter, int expected
 	if (counter)
 		report(*counter == 1, "Interrupt is expected");
 
-	report (vmcb->control.exit_code == expected_vmexit, "Test expected VM exit");
-	report(vmcb->save.rflags & X86_EFLAGS_IF, "Guest should have EFLAGS.IF set now");
+	report(vcpu0.vmcb->control.exit_code == expected_vmexit, "Test expected VM exit");
+	report(vcpu0.vmcb->save.rflags & X86_EFLAGS_IF, "Guest should have EFLAGS.IF set now");
 	cli();
 }
 
@@ -3033,9 +3038,9 @@ static void svm_intr_intercept_mix_if(void)
 	// make a physical interrupt to be pending
 	handle_irq(0x55, dummy_isr);
 
-	vmcb->control.intercept |= (1 << INTERCEPT_INTR);
-	vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
-	vmcb->save.rflags &= ~X86_EFLAGS_IF;
+	vcpu0.vmcb->control.intercept |= (1 << INTERCEPT_INTR);
+	vcpu0.vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
+	vcpu0.vmcb->save.rflags &= ~X86_EFLAGS_IF;
 
 	test_set_guest(svm_intr_intercept_mix_if_guest);
 	cli();
@@ -3066,9 +3071,9 @@ static void svm_intr_intercept_mix_gif(void)
 {
 	handle_irq(0x55, dummy_isr);
 
-	vmcb->control.intercept |= (1 << INTERCEPT_INTR);
-	vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
-	vmcb->save.rflags &= ~X86_EFLAGS_IF;
+	vcpu0.vmcb->control.intercept |= (1 << INTERCEPT_INTR);
+	vcpu0.vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
+	vcpu0.vmcb->save.rflags &= ~X86_EFLAGS_IF;
 
 	test_set_guest(svm_intr_intercept_mix_gif_guest);
 	cli();
@@ -3096,9 +3101,9 @@ static void svm_intr_intercept_mix_gif2(void)
 {
 	handle_irq(0x55, dummy_isr);
 
-	vmcb->control.intercept |= (1 << INTERCEPT_INTR);
-	vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
-	vmcb->save.rflags |= X86_EFLAGS_IF;
+	vcpu0.vmcb->control.intercept |= (1 << INTERCEPT_INTR);
+	vcpu0.vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
+	vcpu0.vmcb->save.rflags |= X86_EFLAGS_IF;
 
 	test_set_guest(svm_intr_intercept_mix_gif_guest2);
 	svm_intr_intercept_mix_run_guest(&dummy_isr_recevied, SVM_EXIT_INTR);
@@ -3125,9 +3130,9 @@ static void svm_intr_intercept_mix_nmi(void)
 {
 	handle_exception(2, dummy_nmi_handler);
 
-	vmcb->control.intercept |= (1 << INTERCEPT_NMI);
-	vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
-	vmcb->save.rflags |= X86_EFLAGS_IF;
+	vcpu0.vmcb->control.intercept |= (1 << INTERCEPT_NMI);
+	vcpu0.vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
+	vcpu0.vmcb->save.rflags |= X86_EFLAGS_IF;
 
 	test_set_guest(svm_intr_intercept_mix_nmi_guest);
 	svm_intr_intercept_mix_run_guest(&nmi_recevied, SVM_EXIT_NMI);
@@ -3149,8 +3154,8 @@ static void svm_intr_intercept_mix_smi_guest(struct svm_test *test)
 
 static void svm_intr_intercept_mix_smi(void)
 {
-	vmcb->control.intercept |= (1 << INTERCEPT_SMI);
-	vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
+	vcpu0.vmcb->control.intercept |= (1 << INTERCEPT_SMI);
+	vcpu0.vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
 	test_set_guest(svm_intr_intercept_mix_smi_guest);
 	svm_intr_intercept_mix_run_guest(NULL, SVM_EXIT_SMI);
 }
@@ -3207,14 +3212,14 @@ static void handle_exception_in_l2(u8 vector)
 
 static void handle_exception_in_l1(u32 vector)
 {
-	u32 old_ie = vmcb->control.intercept_exceptions;
+	u32 old_ie = vcpu0.vmcb->control.intercept_exceptions;
 
-	vmcb->control.intercept_exceptions |= (1ULL << vector);
+	vcpu0.vmcb->control.intercept_exceptions |= (1ULL << vector);
 
 	report(svm_vmrun() == (SVM_EXIT_EXCP_BASE + vector),
 		"%s handled by L1",  exception_mnemonic(vector));
 
-	vmcb->control.intercept_exceptions = old_ie;
+	vcpu0.vmcb->control.intercept_exceptions = old_ie;
 }
 
 static void svm_exception_test(void)
@@ -3227,10 +3232,10 @@ static void svm_exception_test(void)
 		test_set_guest((test_guest_func)t->guest_code);
 
 		handle_exception_in_l2(t->vector);
-		vmcb_ident(vmcb);
+		svm_vcpu_ident(&vcpu0);
 
 		handle_exception_in_l1(t->vector);
-		vmcb_ident(vmcb);
+		svm_vcpu_ident(&vcpu0);
 	}
 }
 
@@ -3243,10 +3248,10 @@ static void shutdown_intercept_test_guest(struct svm_test *test)
 static void svm_shutdown_intercept_test(void)
 {
 	test_set_guest(shutdown_intercept_test_guest);
-	vmcb->save.idtr.base = (u64)alloc_vpage();
-	vmcb->control.intercept |= (1ULL << INTERCEPT_SHUTDOWN);
+	vcpu0.vmcb->save.idtr.base = (u64)alloc_vpage();
+	vcpu0.vmcb->control.intercept |= (1ULL << INTERCEPT_SHUTDOWN);
 	svm_vmrun();
-	report(vmcb->control.exit_code == SVM_EXIT_SHUTDOWN, "shutdown test passed");
+	report(vcpu0.vmcb->control.exit_code == SVM_EXIT_SHUTDOWN, "shutdown test passed");
 }
 
 /*
@@ -3256,7 +3261,7 @@ static void svm_shutdown_intercept_test(void)
 
 static void exception_merging_prepare(struct svm_test *test)
 {
-	vmcb->control.intercept_exceptions |= (1ULL << GP_VECTOR);
+	vcpu0.vmcb->control.intercept_exceptions |= (1ULL << GP_VECTOR);
 
 	/* break UD vector idt entry to get #GP*/
 	boot_idt[UD_VECTOR].type = 1;
@@ -3269,15 +3274,15 @@ static void exception_merging_test(struct svm_test *test)
 
 static bool exception_merging_finished(struct svm_test *test)
 {
-	u32 vec = vmcb->control.exit_int_info & SVM_EXITINTINFO_VEC_MASK;
-	u32 type = vmcb->control.exit_int_info & SVM_EXITINTINFO_TYPE_MASK;
+	u32 vec = vcpu0.vmcb->control.exit_int_info & SVM_EXITINTINFO_VEC_MASK;
+	u32 type = vcpu0.vmcb->control.exit_int_info & SVM_EXITINTINFO_TYPE_MASK;
 
-	if (vmcb->control.exit_code != SVM_EXIT_EXCP_BASE + GP_VECTOR) {
+	if (vcpu0.vmcb->control.exit_code != SVM_EXIT_EXCP_BASE + GP_VECTOR) {
 		report(false, "unexpected VM exit");
 		goto out;
 	}
 
-	if (!(vmcb->control.exit_int_info & SVM_EXITINTINFO_VALID)) {
+	if (!(vcpu0.vmcb->control.exit_int_info & SVM_EXITINTINFO_VALID)) {
 		report(false, "EXITINTINFO not valid");
 		goto out;
 	}
@@ -3313,7 +3318,7 @@ static bool exception_merging_check(struct svm_test *test)
 static void interrupt_merging_prepare(struct svm_test *test)
 {
 	/* intercept #GP */
-	vmcb->control.intercept_exceptions |= (1ULL << GP_VECTOR);
+	vcpu0.vmcb->control.intercept_exceptions |= (1ULL << GP_VECTOR);
 
 	/* set local APIC to inject external interrupts */
 	apic_setup_timer(TIMER_VECTOR, APIC_LVT_TIMER_PERIODIC);
@@ -3335,15 +3340,15 @@ static void interrupt_merging_test(struct svm_test *test)
 static bool interrupt_merging_finished(struct svm_test *test)
 {
 
-	u32 vec = vmcb->control.exit_int_info & SVM_EXITINTINFO_VEC_MASK;
-	u32 type = vmcb->control.exit_int_info & SVM_EXITINTINFO_TYPE_MASK;
-	u32 error_code = vmcb->control.exit_info_1;
+	u32 vec = vcpu0.vmcb->control.exit_int_info & SVM_EXITINTINFO_VEC_MASK;
+	u32 type = vcpu0.vmcb->control.exit_int_info & SVM_EXITINTINFO_TYPE_MASK;
+	u32 error_code = vcpu0.vmcb->control.exit_info_1;
 
 	/* exit on external interrupts is disabled, thus timer interrupt
 	 * should be attempted to be delivered, but due to incorrect IDT entry
 	 * an #GP should be raised
 	 */
-	if (vmcb->control.exit_code != SVM_EXIT_EXCP_BASE + GP_VECTOR) {
+	if (vcpu0.vmcb->control.exit_code != SVM_EXIT_EXCP_BASE + GP_VECTOR) {
 		report(false, "unexpected VM exit");
 		goto cleanup;
 	}
@@ -3355,7 +3360,7 @@ static bool interrupt_merging_finished(struct svm_test *test)
 	}
 
 	/* Original interrupt should be preserved in EXITINTINFO */
-	if (!(vmcb->control.exit_int_info & SVM_EXITINTINFO_VALID)) {
+	if (!(vcpu0.vmcb->control.exit_int_info & SVM_EXITINTINFO_VALID)) {
 		report(false, "EXITINTINFO not valid");
 		goto cleanup;
 	}
-- 
2.34.3

