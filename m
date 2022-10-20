Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E52A1606458
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 17:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbiJTPYs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 11:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbiJTPYl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 11:24:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A16752D1C2
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 08:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666279472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RLpvZLezrZAZNnbweweq52tH3FQCl7CvyD0SLa7dzBU=;
        b=AhrAm0taaUSXxHucKbfWBdWTNbS0CQpmawQpqybeuPY2n51RbAviUd5SeoijDXunbFdciL
        i4nk8ugNltoyFESlnDoNJfX3Coy0gqiDyp1XX79w9rdUlN9SmvmfHX3AKTww5aPvnHBP/k
        UQ+cc4356DkFNHgawxvCo3BJMYyRkcw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-413-_OGijuSUPdC-i3Tsp6BUbA-1; Thu, 20 Oct 2022 11:24:31 -0400
X-MC-Unique: _OGijuSUPdC-i3Tsp6BUbA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 31101833AF3
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 15:24:31 +0000 (UTC)
Received: from localhost.localdomain (ovpn-192-51.brq.redhat.com [10.40.192.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AB99A2024CB7;
        Thu, 20 Oct 2022 15:24:29 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH 14/16] svm: rewerite vm entry macros
Date:   Thu, 20 Oct 2022 18:24:02 +0300
Message-Id: <20221020152404.283980-15-mlevitsk@redhat.com>
In-Reply-To: <20221020152404.283980-1-mlevitsk@redhat.com>
References: <20221020152404.283980-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 lib/x86/svm_lib.h | 58 +++++++++++++++++++++++++++++++++++++++
 x86/svm.c         | 51 ++++++++++------------------------
 x86/svm.h         | 70 ++---------------------------------------------
 x86/svm_tests.c   | 24 ++++++++++------
 4 files changed, 91 insertions(+), 112 deletions(-)

diff --git a/lib/x86/svm_lib.h b/lib/x86/svm_lib.h
index 27c3b137..59db26de 100644
--- a/lib/x86/svm_lib.h
+++ b/lib/x86/svm_lib.h
@@ -71,4 +71,62 @@ u8* svm_get_io_bitmap(void);
 #define MSR_BITMAP_SIZE 8192
 
 
+struct svm_extra_regs
+{
+    u64 rbx;
+    u64 rcx;
+    u64 rdx;
+    u64 rbp;
+    u64 rsi;
+    u64 rdi;
+    u64 r8;
+    u64 r9;
+    u64 r10;
+    u64 r11;
+    u64 r12;
+    u64 r13;
+    u64 r14;
+    u64 r15;
+};
+
+#define SWAP_GPRS(reg) \
+		"xchg %%rcx, 0x08(%%" reg ")\n\t"       \
+		"xchg %%rdx, 0x10(%%" reg ")\n\t"       \
+		"xchg %%rbp, 0x18(%%" reg ")\n\t"       \
+		"xchg %%rsi, 0x20(%%" reg ")\n\t"       \
+		"xchg %%rdi, 0x28(%%" reg ")\n\t"       \
+		"xchg %%r8,  0x30(%%" reg ")\n\t"       \
+		"xchg %%r9,  0x38(%%" reg ")\n\t"       \
+		"xchg %%r10, 0x40(%%" reg ")\n\t"       \
+		"xchg %%r11, 0x48(%%" reg ")\n\t"       \
+		"xchg %%r12, 0x50(%%" reg ")\n\t"       \
+		"xchg %%r13, 0x58(%%" reg ")\n\t"       \
+		"xchg %%r14, 0x60(%%" reg ")\n\t"       \
+		"xchg %%r15, 0x68(%%" reg ")\n\t"       \
+		\
+		"xchg %%rbx, 0x00(%%" reg ")\n\t"       \
+
+
+#define __SVM_VMRUN(vmcb, regs, label)          \
+		asm volatile (                          \
+			"vmload %%rax\n\t"                  \
+			"push %%rax\n\t"                    \
+			"push %%rbx\n\t"                    \
+			SWAP_GPRS("rbx")                    \
+			".global " label "\n\t"             \
+			label ": vmrun %%rax\n\t"           \
+			"vmsave %%rax\n\t"                  \
+			"pop %%rax\n\t"                     \
+			SWAP_GPRS("rax")                    \
+			"pop %%rax\n\t"                     \
+			:                                   \
+			: "a" (virt_to_phys(vmcb)),         \
+			  "b"(regs)                         \
+			/* clobbers*/                       \
+			: "memory"                          \
+		);
+
+#define SVM_VMRUN(vmcb, regs) \
+		__SVM_VMRUN(vmcb, regs, "vmrun_dummy_label_%=")
+
 #endif /* SRC_LIB_X86_SVM_LIB_H_ */
diff --git a/x86/svm.c b/x86/svm.c
index 37b4cd38..9484a6d1 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -76,11 +76,11 @@ static void test_thunk(struct svm_test *test)
 	vmmcall();
 }
 
-struct regs regs;
+struct svm_extra_regs regs;
 
-struct regs get_regs(void)
+struct svm_extra_regs* get_regs(void)
 {
-	return regs;
+	return &regs;
 }
 
 // rax handled specially below
@@ -97,13 +97,7 @@ int __svm_vmrun(u64 rip)
 	vmcb->save.rsp = (ulong)(guest_stack + ARRAY_SIZE(guest_stack));
 	regs.rdi = (ulong)v2_test;
 
-	asm volatile (
-		      ASM_PRE_VMRUN_CMD
-		      "vmrun %%rax\n\t"               \
-		      ASM_POST_VMRUN_CMD
-		      :
-		      : "a" (virt_to_phys(vmcb))
-		      : "memory", "r15");
+	SVM_VMRUN(vmcb, &regs);
 
 	return (vmcb->control.exit_code);
 }
@@ -113,12 +107,8 @@ int svm_vmrun(void)
 	return __svm_vmrun((u64)test_thunk);
 }
 
-extern u8 vmrun_rip;
-
 static noinline void test_run(struct svm_test *test)
 {
-	u64 vmcb_phys = virt_to_phys(vmcb);
-
 	irq_disable();
 	vmcb_ident(vmcb);
 
@@ -128,28 +118,17 @@ static noinline void test_run(struct svm_test *test)
 	vmcb->save.rsp = (ulong)(guest_stack + ARRAY_SIZE(guest_stack));
 	regs.rdi = (ulong)test;
 	do {
-		struct svm_test *the_test = test;
-		u64 the_vmcb = vmcb_phys;
-		asm volatile (
-			      "clgi;\n\t" // semi-colon needed for LLVM compatibility
-			      "sti \n\t"
-			      "call *%c[PREPARE_GIF_CLEAR](%[test]) \n \t"
-			      "mov %[vmcb_phys], %%rax \n\t"
-			      ASM_PRE_VMRUN_CMD
-			      ".global vmrun_rip\n\t"		\
-			      "vmrun_rip: vmrun %%rax\n\t"    \
-			      ASM_POST_VMRUN_CMD
-			      "cli \n\t"
-			      "stgi"
-			      : // inputs clobbered by the guest:
-				"=D" (the_test),            // first argument register
-				"=b" (the_vmcb)             // callee save register!
-			      : [test] "0" (the_test),
-				[vmcb_phys] "1"(the_vmcb),
-				[PREPARE_GIF_CLEAR] "i" (offsetof(struct svm_test, prepare_gif_clear))
-			      : "rax", "rcx", "rdx", "rsi",
-				"r8", "r9", "r10", "r11" , "r12", "r13", "r14", "r15",
-				"memory");
+
+		clgi();
+		sti();
+
+		test->prepare_gif_clear(test);
+
+		__SVM_VMRUN(vmcb, &regs, "vmrun_rip");
+
+		cli();
+		stgi();
+
 		++test->exits;
 	} while (!test->finished(test));
 	irq_enable();
diff --git a/x86/svm.h b/x86/svm.h
index 623f2b36..8d4515f0 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -23,26 +23,6 @@ struct svm_test {
 	bool on_vcpu_done;
 };
 
-struct regs {
-	u64 rax;
-	u64 rbx;
-	u64 rcx;
-	u64 rdx;
-	u64 cr2;
-	u64 rbp;
-	u64 rsi;
-	u64 rdi;
-	u64 r8;
-	u64 r9;
-	u64 r10;
-	u64 r11;
-	u64 r12;
-	u64 r13;
-	u64 r14;
-	u64 r15;
-	u64 rflags;
-};
-
 typedef void (*test_guest_func)(struct svm_test *);
 
 int run_svm_tests(int ac, char **av, struct svm_test *svm_tests);
@@ -55,7 +35,7 @@ bool default_finished(struct svm_test *test);
 int get_test_stage(struct svm_test *test);
 void set_test_stage(struct svm_test *test, int s);
 void inc_test_stage(struct svm_test *test);
-struct regs get_regs(void);
+struct svm_extra_regs * get_regs(void);
 int __svm_vmrun(u64 rip);
 void __svm_bare_vmrun(void);
 int svm_vmrun(void);
@@ -63,51 +43,5 @@ void test_set_guest(test_guest_func func);
 u64* get_npt_pte(u64 *pml4, u64 guest_addr, int level);
 
 extern struct vmcb *vmcb;
-
-
-#define SAVE_GPR_C                              \
-        "xchg %%rbx, regs+0x8\n\t"              \
-        "xchg %%rcx, regs+0x10\n\t"             \
-        "xchg %%rdx, regs+0x18\n\t"             \
-        "xchg %%rbp, regs+0x28\n\t"             \
-        "xchg %%rsi, regs+0x30\n\t"             \
-        "xchg %%rdi, regs+0x38\n\t"             \
-        "xchg %%r8, regs+0x40\n\t"              \
-        "xchg %%r9, regs+0x48\n\t"              \
-        "xchg %%r10, regs+0x50\n\t"             \
-        "xchg %%r11, regs+0x58\n\t"             \
-        "xchg %%r12, regs+0x60\n\t"             \
-        "xchg %%r13, regs+0x68\n\t"             \
-        "xchg %%r14, regs+0x70\n\t"             \
-        "xchg %%r15, regs+0x78\n\t"
-
-#define LOAD_GPR_C      SAVE_GPR_C
-
-#define ASM_PRE_VMRUN_CMD                       \
-                "vmload %%rax\n\t"              \
-                "mov regs+0x80, %%r15\n\t"      \
-                "mov %%r15, 0x170(%%rax)\n\t"   \
-                "mov regs, %%r15\n\t"           \
-                "mov %%r15, 0x1f8(%%rax)\n\t"   \
-                LOAD_GPR_C                      \
-
-#define ASM_POST_VMRUN_CMD                      \
-                SAVE_GPR_C                      \
-                "mov 0x170(%%rax), %%r15\n\t"   \
-                "mov %%r15, regs+0x80\n\t"      \
-                "mov 0x1f8(%%rax), %%r15\n\t"   \
-                "mov %%r15, regs\n\t"           \
-                "vmsave %%rax\n\t"              \
-
-
-
-#define SVM_BARE_VMRUN \
-	asm volatile ( \
-		ASM_PRE_VMRUN_CMD \
-                "vmrun %%rax\n\t"               \
-		ASM_POST_VMRUN_CMD \
-		: \
-		: "a" (virt_to_phys(vmcb)) \
-		: "memory", "r15") \
-
+extern struct svm_test svm_tests[];
 #endif
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 57b5b572..475a40d0 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -398,7 +398,7 @@ static bool msr_intercept_finished(struct svm_test *test)
 		 * RCX holds the MSR index.
 		 */
 		printf("%s 0x%lx #GP exception\n",
-		       exit_info_1 ? "WRMSR" : "RDMSR", get_regs().rcx);
+		       exit_info_1 ? "WRMSR" : "RDMSR", get_regs()->rcx);
 	}
 
 	/* Jump over RDMSR/WRMSR instruction */
@@ -414,9 +414,9 @@ static bool msr_intercept_finished(struct svm_test *test)
 	 */
 	if (exit_info_1)
 		test->scratch =
-			((get_regs().rdx << 32) | (vmcb->save.rax & 0xffffffff));
+			((get_regs()->rdx << 32) | (vmcb->save.rax & 0xffffffff));
 	else
-		test->scratch = get_regs().rcx;
+		test->scratch = get_regs()->rcx;
 
 	return false;
 }
@@ -1851,7 +1851,7 @@ static volatile bool host_rflags_set_tf = false;
 static volatile bool host_rflags_set_rf = false;
 static u64 rip_detected;
 
-extern u64 *vmrun_rip;
+extern u64 vmrun_rip;
 
 static void host_rflags_db_handler(struct ex_regs *r)
 {
@@ -2989,6 +2989,8 @@ static void svm_lbrv_test0(void)
 
 static void svm_lbrv_test1(void)
 {
+	struct svm_extra_regs* regs = get_regs();
+
 	report(true, "Test that without LBRV enabled, guest LBR state does 'leak' to the host(1)");
 
 	vmcb->save.rip = (ulong)svm_lbrv_test_guest1;
@@ -2996,7 +2998,7 @@ static void svm_lbrv_test1(void)
 
 	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
 	DO_BRANCH(host_branch1);
-	SVM_BARE_VMRUN;
+	SVM_VMRUN(vmcb,regs);
 	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
 
 	if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
@@ -3011,6 +3013,8 @@ static void svm_lbrv_test1(void)
 
 static void svm_lbrv_test2(void)
 {
+	struct svm_extra_regs* regs = get_regs();
+
 	report(true, "Test that without LBRV enabled, guest LBR state does 'leak' to the host(2)");
 
 	vmcb->save.rip = (ulong)svm_lbrv_test_guest2;
@@ -3019,7 +3023,7 @@ static void svm_lbrv_test2(void)
 	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
 	DO_BRANCH(host_branch2);
 	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
-	SVM_BARE_VMRUN;
+	SVM_VMRUN(vmcb,regs);
 	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
 	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
 
@@ -3035,6 +3039,8 @@ static void svm_lbrv_test2(void)
 
 static void svm_lbrv_nested_test1(void)
 {
+	struct svm_extra_regs* regs = get_regs();
+
 	if (!lbrv_supported()) {
 		report_skip("LBRV not supported in the guest");
 		return;
@@ -3047,7 +3053,7 @@ static void svm_lbrv_nested_test1(void)
 
 	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
 	DO_BRANCH(host_branch3);
-	SVM_BARE_VMRUN;
+	SVM_VMRUN(vmcb,regs);
 	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
 	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
 
@@ -3068,6 +3074,8 @@ static void svm_lbrv_nested_test1(void)
 
 static void svm_lbrv_nested_test2(void)
 {
+	struct svm_extra_regs* regs = get_regs();
+
 	if (!lbrv_supported()) {
 		report_skip("LBRV not supported in the guest");
 		return;
@@ -3083,7 +3091,7 @@ static void svm_lbrv_nested_test2(void)
 
 	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
 	DO_BRANCH(host_branch4);
-	SVM_BARE_VMRUN;
+	SVM_VMRUN(vmcb,regs);
 	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
 	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
 
-- 
2.26.3

