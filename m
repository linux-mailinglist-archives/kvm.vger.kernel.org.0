Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF576634144
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 17:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234289AbiKVQQ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 11:16:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234347AbiKVQQE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 11:16:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 843226F370
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 08:12:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669133572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nxtR5G+CtqJpR2Kj94VrwwtsXCYRd/kQaXmZ/pGnpQk=;
        b=gJixDPCqUjN4fbEzngWkq6fn1dISQJsn5V/G1JlK5srcJ5d7bccZkYlsCvs9XE9MOTthX8
        OV5tcBRTvMZMRgSFtQrPY8gS0+nd2a1RTjh6ySxyB53oJYwl+GRNCzKs7jR5L1IAPxNdTr
        jDQkJKr0WqyOAE9/jyXG4TwW87HQVps=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-570-UqnD8_N_OvCzGVyvDM4hzg-1; Tue, 22 Nov 2022 11:12:49 -0500
X-MC-Unique: UqnD8_N_OvCzGVyvDM4hzg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D995C101A56C;
        Tue, 22 Nov 2022 16:12:48 +0000 (UTC)
Received: from amdlaptop.tlv.redhat.com (dhcp-4-238.tlv.redhat.com [10.35.4.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA15C1121314;
        Tue, 22 Nov 2022 16:12:46 +0000 (UTC)
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
Subject: [kvm-unit-tests PATCH v3 23/27] svm: introduce struct svm_test_context
Date:   Tue, 22 Nov 2022 18:11:48 +0200
Message-Id: <20221122161152.293072-24-mlevitsk@redhat.com>
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

Introduce struct_svm_test_context which will contain all the current
test state instead of abusing the array of the test templates for this.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 x86/svm.c       |  62 +++---
 x86/svm.h       |  35 ++--
 x86/svm_npt.c   |  48 ++---
 x86/svm_tests.c | 533 ++++++++++++++++++++++++------------------------
 4 files changed, 343 insertions(+), 335 deletions(-)

diff --git a/x86/svm.c b/x86/svm.c
index 51ed4d06..6381dee9 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -28,37 +28,37 @@ bool default_supported(void)
 	return true;
 }
 
-void default_prepare(struct svm_test *test)
+void default_prepare(struct svm_test_context *ctx)
 {
 }
 
-void default_prepare_gif_clear(struct svm_test *test)
+void default_prepare_gif_clear(struct svm_test_context *ctx)
 {
 }
 
-bool default_finished(struct svm_test *test)
+bool default_finished(struct svm_test_context *ctx)
 {
 	return true; /* one vmexit */
 }
 
 
-int get_test_stage(struct svm_test *test)
+int get_test_stage(struct svm_test_context *ctx)
 {
 	barrier();
-	return test->scratch;
+	return ctx->scratch;
 }
 
-void set_test_stage(struct svm_test *test, int s)
+void set_test_stage(struct svm_test_context *ctx, int s)
 {
 	barrier();
-	test->scratch = s;
+	ctx->scratch = s;
 	barrier();
 }
 
-void inc_test_stage(struct svm_test *test)
+void inc_test_stage(struct svm_test_context *ctx)
 {
 	barrier();
-	test->scratch++;
+	ctx->scratch++;
 	barrier();
 }
 
@@ -69,20 +69,20 @@ void test_set_guest(test_guest_func func)
 	guest_main = func;
 }
 
-static void test_thunk(struct svm_test *test)
+static void test_thunk(struct svm_test_context *ctx)
 {
-	guest_main(test);
+	guest_main(ctx);
 	vmmcall();
 }
 
 
-struct svm_test *v2_test;
+struct svm_test_context *v2_ctx;
 
 
 int __svm_vmrun(u64 rip)
 {
 	vcpu0.vmcb->save.rip = (ulong)rip;
-	vcpu0.regs.rdi = (ulong)v2_test;
+	vcpu0.regs.rdi = (ulong)v2_ctx;
 	vcpu0.regs.rsp = (ulong)(vcpu0.stack);
 	SVM_VMRUN(&vcpu0);
 	return vcpu0.vmcb->control.exit_code;
@@ -93,43 +93,43 @@ int svm_vmrun(void)
 	return __svm_vmrun((u64)test_thunk);
 }
 
-static noinline void test_run(struct svm_test *test)
+static noinline void test_run(struct svm_test_context *ctx)
 {
 	svm_vcpu_ident(&vcpu0);
 
-	if (test->v2) {
-		v2_test = test;
-		test->v2();
+	if (ctx->test->v2) {
+		v2_ctx = ctx;
+		ctx->test->v2();
 		return;
 	}
 
 	cli();
 
-	test->prepare(test);
-	guest_main = test->guest_func;
+	ctx->test->prepare(ctx);
+	guest_main = ctx->test->guest_func;
 	vcpu0.vmcb->save.rip = (ulong)test_thunk;
 	vcpu0.regs.rsp = (ulong)(vcpu0.stack);
-	vcpu0.regs.rdi = (ulong)test;
+	vcpu0.regs.rdi = (ulong)ctx;
 	do {
 
 		clgi();
 		sti();
 
-		test->prepare_gif_clear(test);
+		ctx->test->prepare_gif_clear(ctx);
 
 		__SVM_VMRUN(&vcpu0, "vmrun_rip");
 
 		cli();
 		stgi();
 
-		++test->exits;
-	} while (!test->finished(test));
+		++ctx->exits;
+	} while (!ctx->test->finished(ctx));
 	sti();
 
-	report(test->succeeded(test), "%s", test->name);
+	report(ctx->test->succeeded(ctx), "%s", ctx->test->name);
 
-	if (test->on_vcpu)
-		test->on_vcpu_done = true;
+	if (ctx->test->on_vcpu)
+		ctx->on_vcpu_done = true;
 }
 
 int matched;
@@ -185,16 +185,22 @@ int run_svm_tests(int ac, char **av, struct svm_test *svm_tests)
 	if (!setup_svm())
 		return 0;
 
+	struct svm_test_context ctx;
+
 	svm_vcpu_init(&vcpu0);
 
 	for (; svm_tests[i].name != NULL; i++) {
+
+		memset(&ctx, 0, sizeof(ctx));
+		ctx.test = &svm_tests[i];
+
 		if (!test_wanted(svm_tests[i].name, av, ac))
 			continue;
 		if (svm_tests[i].supported && !svm_tests[i].supported())
 			continue;
 
 		if (!svm_tests[i].on_vcpu) {
-			test_run(&svm_tests[i]);
+			test_run(&ctx);
 			continue;
 		}
 
@@ -203,7 +209,7 @@ int run_svm_tests(int ac, char **av, struct svm_test *svm_tests)
 
 		on_cpu_async(svm_tests[i].on_vcpu, (void *)test_run, &svm_tests[i]);
 
-		while (!svm_tests[i].on_vcpu_done)
+		while (!ctx.on_vcpu_done)
 			cpu_relax();
 	}
 
diff --git a/x86/svm.h b/x86/svm.h
index 61fd2387..01d07a54 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -7,41 +7,44 @@
 
 #define LBR_CTL_ENABLE_MASK BIT_ULL(0)
 
+struct svm_test_context {
+	int exits;
+	ulong scratch;
+	bool on_vcpu_done;
+	struct svm_test *test;
+};
+
 struct svm_test {
 	const char *name;
 	bool (*supported)(void);
-	void (*prepare)(struct svm_test *test);
-	void (*prepare_gif_clear)(struct svm_test *test);
-	void (*guest_func)(struct svm_test *test);
-	bool (*finished)(struct svm_test *test);
-	bool (*succeeded)(struct svm_test *test);
-	int exits;
-	ulong scratch;
+	void (*prepare)(struct svm_test_context *ctx);
+	void (*prepare_gif_clear)(struct svm_test_context *ctx);
+	void (*guest_func)(struct svm_test_context *ctx);
+	bool (*finished)(struct svm_test_context *ctx);
+	bool (*succeeded)(struct svm_test_context *ctx);
 	/* Alternative test interface. */
 	void (*v2)(void);
 	int on_vcpu;
-	bool on_vcpu_done;
 };
 
-typedef void (*test_guest_func)(struct svm_test *);
+typedef void (*test_guest_func)(struct svm_test_context *ctx);
 
 int run_svm_tests(int ac, char **av, struct svm_test *svm_tests);
 
 bool smp_supported(void);
 bool default_supported(void);
-void default_prepare(struct svm_test *test);
-void default_prepare_gif_clear(struct svm_test *test);
-bool default_finished(struct svm_test *test);
-int get_test_stage(struct svm_test *test);
-void set_test_stage(struct svm_test *test, int s);
-void inc_test_stage(struct svm_test *test);
+void default_prepare(struct svm_test_context *ctx);
+void default_prepare_gif_clear(struct svm_test_context *ctx);
+bool default_finished(struct svm_test_context *ctx);
+int get_test_stage(struct svm_test_context *ctx);
+void set_test_stage(struct svm_test_context *ctx, int s);
+void inc_test_stage(struct svm_test_context *ctx);
 int __svm_vmrun(u64 rip);
 void __svm_bare_vmrun(void);
 int svm_vmrun(void);
 void test_set_guest(test_guest_func func);
 
 
-extern struct svm_test svm_tests[];
 extern struct svm_vcpu vcpu0;
 
 #endif
diff --git a/x86/svm_npt.c b/x86/svm_npt.c
index 53a82793..fe6cbb29 100644
--- a/x86/svm_npt.c
+++ b/x86/svm_npt.c
@@ -6,11 +6,11 @@
 
 static void *scratch_page;
 
-static void null_test(struct svm_test *test)
+static void null_test(struct svm_test_context *ctx)
 {
 }
 
-static void npt_np_prepare(struct svm_test *test)
+static void npt_np_prepare(struct svm_test_context *ctx)
 {
 	u64 *pte;
 
@@ -20,12 +20,12 @@ static void npt_np_prepare(struct svm_test *test)
 	*pte &= ~1ULL;
 }
 
-static void npt_np_test(struct svm_test *test)
+static void npt_np_test(struct svm_test_context *ctx)
 {
 	(void)*(volatile u64 *)scratch_page;
 }
 
-static bool npt_np_check(struct svm_test *test)
+static bool npt_np_check(struct svm_test_context *ctx)
 {
 	u64 *pte = npt_get_pte((u64) scratch_page);
 
@@ -35,12 +35,12 @@ static bool npt_np_check(struct svm_test *test)
 	    && (vcpu0.vmcb->control.exit_info_1 == 0x100000004ULL);
 }
 
-static void npt_nx_prepare(struct svm_test *test)
+static void npt_nx_prepare(struct svm_test_context *ctx)
 {
 	u64 *pte;
 
-	test->scratch = rdmsr(MSR_EFER);
-	wrmsr(MSR_EFER, test->scratch | EFER_NX);
+	ctx->scratch = rdmsr(MSR_EFER);
+	wrmsr(MSR_EFER, ctx->scratch | EFER_NX);
 
 	/* Clear the guest's EFER.NX, it should not affect NPT behavior. */
 	vcpu0.vmcb->save.efer &= ~EFER_NX;
@@ -50,11 +50,11 @@ static void npt_nx_prepare(struct svm_test *test)
 	*pte |= PT64_NX_MASK;
 }
 
-static bool npt_nx_check(struct svm_test *test)
+static bool npt_nx_check(struct svm_test_context *ctx)
 {
 	u64 *pte = npt_get_pte((u64) null_test);
 
-	wrmsr(MSR_EFER, test->scratch);
+	wrmsr(MSR_EFER, ctx->scratch);
 
 	*pte &= ~PT64_NX_MASK;
 
@@ -62,7 +62,7 @@ static bool npt_nx_check(struct svm_test *test)
 	    && (vcpu0.vmcb->control.exit_info_1 == 0x100000015ULL);
 }
 
-static void npt_us_prepare(struct svm_test *test)
+static void npt_us_prepare(struct svm_test_context *ctx)
 {
 	u64 *pte;
 
@@ -72,12 +72,12 @@ static void npt_us_prepare(struct svm_test *test)
 	*pte &= ~(1ULL << 2);
 }
 
-static void npt_us_test(struct svm_test *test)
+static void npt_us_test(struct svm_test_context *ctx)
 {
 	(void)*(volatile u64 *)scratch_page;
 }
 
-static bool npt_us_check(struct svm_test *test)
+static bool npt_us_check(struct svm_test_context *ctx)
 {
 	u64 *pte = npt_get_pte((u64) scratch_page);
 
@@ -87,7 +87,7 @@ static bool npt_us_check(struct svm_test *test)
 	    && (vcpu0.vmcb->control.exit_info_1 == 0x100000005ULL);
 }
 
-static void npt_rw_prepare(struct svm_test *test)
+static void npt_rw_prepare(struct svm_test_context *ctx)
 {
 
 	u64 *pte;
@@ -97,14 +97,14 @@ static void npt_rw_prepare(struct svm_test *test)
 	*pte &= ~(1ULL << 1);
 }
 
-static void npt_rw_test(struct svm_test *test)
+static void npt_rw_test(struct svm_test_context *ctx)
 {
 	u64 *data = (void *)(0x80000);
 
 	*data = 0;
 }
 
-static bool npt_rw_check(struct svm_test *test)
+static bool npt_rw_check(struct svm_test_context *ctx)
 {
 	u64 *pte = npt_get_pte(0x80000);
 
@@ -114,7 +114,7 @@ static bool npt_rw_check(struct svm_test *test)
 	    && (vcpu0.vmcb->control.exit_info_1 == 0x100000007ULL);
 }
 
-static void npt_rw_pfwalk_prepare(struct svm_test *test)
+static void npt_rw_pfwalk_prepare(struct svm_test_context *ctx)
 {
 
 	u64 *pte;
@@ -124,7 +124,7 @@ static void npt_rw_pfwalk_prepare(struct svm_test *test)
 	*pte &= ~(1ULL << 1);
 }
 
-static bool npt_rw_pfwalk_check(struct svm_test *test)
+static bool npt_rw_pfwalk_check(struct svm_test_context *ctx)
 {
 	u64 *pte = npt_get_pte(read_cr3());
 
@@ -135,14 +135,14 @@ static bool npt_rw_pfwalk_check(struct svm_test *test)
 	    && (vcpu0.vmcb->control.exit_info_2 == read_cr3());
 }
 
-static void npt_l1mmio_prepare(struct svm_test *test)
+static void npt_l1mmio_prepare(struct svm_test_context *ctx)
 {
 }
 
 u32 nested_apic_version1;
 u32 nested_apic_version2;
 
-static void npt_l1mmio_test(struct svm_test *test)
+static void npt_l1mmio_test(struct svm_test_context *ctx)
 {
 	volatile u32 *data = (volatile void *)(0xfee00030UL);
 
@@ -150,7 +150,7 @@ static void npt_l1mmio_test(struct svm_test *test)
 	nested_apic_version2 = *data;
 }
 
-static bool npt_l1mmio_check(struct svm_test *test)
+static bool npt_l1mmio_check(struct svm_test_context *ctx)
 {
 	volatile u32 *data = (volatile void *)(0xfee00030);
 	u32 lvr = *data;
@@ -158,7 +158,7 @@ static bool npt_l1mmio_check(struct svm_test *test)
 	return nested_apic_version1 == lvr && nested_apic_version2 == lvr;
 }
 
-static void npt_rw_l1mmio_prepare(struct svm_test *test)
+static void npt_rw_l1mmio_prepare(struct svm_test_context *ctx)
 {
 
 	u64 *pte;
@@ -168,14 +168,14 @@ static void npt_rw_l1mmio_prepare(struct svm_test *test)
 	*pte &= ~(1ULL << 1);
 }
 
-static void npt_rw_l1mmio_test(struct svm_test *test)
+static void npt_rw_l1mmio_test(struct svm_test_context *ctx)
 {
 	volatile u32 *data = (volatile void *)(0xfee00080);
 
 	*data = *data;
 }
 
-static bool npt_rw_l1mmio_check(struct svm_test *test)
+static bool npt_rw_l1mmio_check(struct svm_test_context *ctx)
 {
 	u64 *pte = npt_get_pte(0xfee00080);
 
@@ -185,7 +185,7 @@ static bool npt_rw_l1mmio_check(struct svm_test *test)
 	    && (vcpu0.vmcb->control.exit_info_1 == 0x100000007ULL);
 }
 
-static void basic_guest_main(struct svm_test *test)
+static void basic_guest_main(struct svm_test_context *ctx)
 {
 }
 
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 0312df33..c29e9a5d 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -38,54 +38,54 @@ u64 latclgi_max;
 u64 latclgi_min;
 u64 runs;
 
-static void null_test(struct svm_test *test)
+static void null_test(struct svm_test_context *ctx)
 {
 }
 
-static bool null_check(struct svm_test *test)
+static bool null_check(struct svm_test_context *ctx)
 {
 	return vcpu0.vmcb->control.exit_code == SVM_EXIT_VMMCALL;
 }
 
-static void prepare_no_vmrun_int(struct svm_test *test)
+static void prepare_no_vmrun_int(struct svm_test_context *ctx)
 {
 	vcpu0.vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMRUN);
 }
 
-static bool check_no_vmrun_int(struct svm_test *test)
+static bool check_no_vmrun_int(struct svm_test_context *ctx)
 {
 	return vcpu0.vmcb->control.exit_code == SVM_EXIT_ERR;
 }
 
-static void test_vmrun(struct svm_test *test)
+static void test_vmrun(struct svm_test_context *ctx)
 {
 	asm volatile ("vmrun %0" : : "a"(virt_to_phys(vcpu0.vmcb)));
 }
 
-static bool check_vmrun(struct svm_test *test)
+static bool check_vmrun(struct svm_test_context *ctx)
 {
 	return vcpu0.vmcb->control.exit_code == SVM_EXIT_VMRUN;
 }
 
-static void prepare_rsm_intercept(struct svm_test *test)
+static void prepare_rsm_intercept(struct svm_test_context *ctx)
 {
 	vcpu0.vmcb->control.intercept |= 1 << INTERCEPT_RSM;
 	vcpu0.vmcb->control.intercept_exceptions |= (1ULL << UD_VECTOR);
 }
 
-static void test_rsm_intercept(struct svm_test *test)
+static void test_rsm_intercept(struct svm_test_context *ctx)
 {
 	asm volatile ("rsm" : : : "memory");
 }
 
-static bool check_rsm_intercept(struct svm_test *test)
+static bool check_rsm_intercept(struct svm_test_context *ctx)
 {
-	return get_test_stage(test) == 2;
+	return get_test_stage(ctx) == 2;
 }
 
-static bool finished_rsm_intercept(struct svm_test *test)
+static bool finished_rsm_intercept(struct svm_test_context *ctx)
 {
-	switch (get_test_stage(test)) {
+	switch (get_test_stage(ctx)) {
 	case 0:
 		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_RSM) {
 			report_fail("VMEXIT not due to rsm. Exit reason 0x%x",
@@ -93,7 +93,7 @@ static bool finished_rsm_intercept(struct svm_test *test)
 			return true;
 		}
 		vcpu0.vmcb->control.intercept &= ~(1 << INTERCEPT_RSM);
-		inc_test_stage(test);
+		inc_test_stage(ctx);
 		break;
 
 	case 1:
@@ -103,41 +103,41 @@ static bool finished_rsm_intercept(struct svm_test *test)
 			return true;
 		}
 		vcpu0.vmcb->save.rip += 2;
-		inc_test_stage(test);
+		inc_test_stage(ctx);
 		break;
 
 	default:
 		return true;
 	}
-	return get_test_stage(test) == 2;
+	return get_test_stage(ctx) == 2;
 }
 
-static void prepare_cr3_intercept(struct svm_test *test)
+static void prepare_cr3_intercept(struct svm_test_context *ctx)
 {
 	vcpu0.vmcb->control.intercept_cr_read |= 1 << 3;
 }
 
-static void test_cr3_intercept(struct svm_test *test)
+static void test_cr3_intercept(struct svm_test_context *ctx)
 {
-	asm volatile ("mov %%cr3, %0" : "=r"(test->scratch) : : "memory");
+	asm volatile ("mov %%cr3, %0" : "=r"(ctx->scratch) : : "memory");
 }
 
-static bool check_cr3_intercept(struct svm_test *test)
+static bool check_cr3_intercept(struct svm_test_context *ctx)
 {
 	return vcpu0.vmcb->control.exit_code == SVM_EXIT_READ_CR3;
 }
 
-static bool check_cr3_nointercept(struct svm_test *test)
+static bool check_cr3_nointercept(struct svm_test_context *ctx)
 {
-	return null_check(test) && test->scratch == read_cr3();
+	return null_check(ctx) && ctx->scratch == read_cr3();
 }
 
-static void corrupt_cr3_intercept_bypass(void *_test)
+static void corrupt_cr3_intercept_bypass(void *_ctx)
 {
-	struct svm_test *test = _test;
+	struct svm_test_context *ctx = _ctx;
 	extern volatile u32 mmio_insn;
 
-	while (!__sync_bool_compare_and_swap(&test->scratch, 1, 2))
+	while (!__sync_bool_compare_and_swap(&ctx->scratch, 1, 2))
 		pause();
 	pause();
 	pause();
@@ -145,32 +145,32 @@ static void corrupt_cr3_intercept_bypass(void *_test)
 	mmio_insn = 0x90d8200f;  // mov %cr3, %rax; nop
 }
 
-static void prepare_cr3_intercept_bypass(struct svm_test *test)
+static void prepare_cr3_intercept_bypass(struct svm_test_context *ctx)
 {
 	vcpu0.vmcb->control.intercept_cr_read |= 1 << 3;
-	on_cpu_async(1, corrupt_cr3_intercept_bypass, test);
+	on_cpu_async(1, corrupt_cr3_intercept_bypass, ctx);
 }
 
-static void test_cr3_intercept_bypass(struct svm_test *test)
+static void test_cr3_intercept_bypass(struct svm_test_context *ctx)
 {
 	ulong a = 0xa0000;
 
-	test->scratch = 1;
-	while (test->scratch != 2)
+	ctx->scratch = 1;
+	while (ctx->scratch != 2)
 		barrier();
 
 	asm volatile ("mmio_insn: mov %0, (%0); nop"
 		      : "+a"(a) : : "memory");
-	test->scratch = a;
+	ctx->scratch = a;
 }
 
-static void prepare_dr_intercept(struct svm_test *test)
+static void prepare_dr_intercept(struct svm_test_context *ctx)
 {
 	vcpu0.vmcb->control.intercept_dr_read = 0xff;
 	vcpu0.vmcb->control.intercept_dr_write = 0xff;
 }
 
-static void test_dr_intercept(struct svm_test *test)
+static void test_dr_intercept(struct svm_test_context *ctx)
 {
 	unsigned int i, failcnt = 0;
 
@@ -179,32 +179,32 @@ static void test_dr_intercept(struct svm_test *test)
 
 		switch (i) {
 		case 0:
-			asm volatile ("mov %%dr0, %0" : "=r"(test->scratch) : : "memory");
+			asm volatile ("mov %%dr0, %0" : "=r"(ctx->scratch) : : "memory");
 			break;
 		case 1:
-			asm volatile ("mov %%dr1, %0" : "=r"(test->scratch) : : "memory");
+			asm volatile ("mov %%dr1, %0" : "=r"(ctx->scratch) : : "memory");
 			break;
 		case 2:
-			asm volatile ("mov %%dr2, %0" : "=r"(test->scratch) : : "memory");
+			asm volatile ("mov %%dr2, %0" : "=r"(ctx->scratch) : : "memory");
 			break;
 		case 3:
-			asm volatile ("mov %%dr3, %0" : "=r"(test->scratch) : : "memory");
+			asm volatile ("mov %%dr3, %0" : "=r"(ctx->scratch) : : "memory");
 			break;
 		case 4:
-			asm volatile ("mov %%dr4, %0" : "=r"(test->scratch) : : "memory");
+			asm volatile ("mov %%dr4, %0" : "=r"(ctx->scratch) : : "memory");
 			break;
 		case 5:
-			asm volatile ("mov %%dr5, %0" : "=r"(test->scratch) : : "memory");
+			asm volatile ("mov %%dr5, %0" : "=r"(ctx->scratch) : : "memory");
 			break;
 		case 6:
-			asm volatile ("mov %%dr6, %0" : "=r"(test->scratch) : : "memory");
+			asm volatile ("mov %%dr6, %0" : "=r"(ctx->scratch) : : "memory");
 			break;
 		case 7:
-			asm volatile ("mov %%dr7, %0" : "=r"(test->scratch) : : "memory");
+			asm volatile ("mov %%dr7, %0" : "=r"(ctx->scratch) : : "memory");
 			break;
 		}
 
-		if (test->scratch != i) {
+		if (ctx->scratch != i) {
 			report_fail("dr%u read intercept", i);
 			failcnt++;
 		}
@@ -215,41 +215,41 @@ static void test_dr_intercept(struct svm_test *test)
 
 		switch (i) {
 		case 0:
-			asm volatile ("mov %0, %%dr0" : : "r"(test->scratch) : "memory");
+			asm volatile ("mov %0, %%dr0" : : "r"(ctx->scratch) : "memory");
 			break;
 		case 1:
-			asm volatile ("mov %0, %%dr1" : : "r"(test->scratch) : "memory");
+			asm volatile ("mov %0, %%dr1" : : "r"(ctx->scratch) : "memory");
 			break;
 		case 2:
-			asm volatile ("mov %0, %%dr2" : : "r"(test->scratch) : "memory");
+			asm volatile ("mov %0, %%dr2" : : "r"(ctx->scratch) : "memory");
 			break;
 		case 3:
-			asm volatile ("mov %0, %%dr3" : : "r"(test->scratch) : "memory");
+			asm volatile ("mov %0, %%dr3" : : "r"(ctx->scratch) : "memory");
 			break;
 		case 4:
-			asm volatile ("mov %0, %%dr4" : : "r"(test->scratch) : "memory");
+			asm volatile ("mov %0, %%dr4" : : "r"(ctx->scratch) : "memory");
 			break;
 		case 5:
-			asm volatile ("mov %0, %%dr5" : : "r"(test->scratch) : "memory");
+			asm volatile ("mov %0, %%dr5" : : "r"(ctx->scratch) : "memory");
 			break;
 		case 6:
-			asm volatile ("mov %0, %%dr6" : : "r"(test->scratch) : "memory");
+			asm volatile ("mov %0, %%dr6" : : "r"(ctx->scratch) : "memory");
 			break;
 		case 7:
-			asm volatile ("mov %0, %%dr7" : : "r"(test->scratch) : "memory");
+			asm volatile ("mov %0, %%dr7" : : "r"(ctx->scratch) : "memory");
 			break;
 		}
 
-		if (test->scratch != i) {
+		if (ctx->scratch != i) {
 			report_fail("dr%u write intercept", i);
 			failcnt++;
 		}
 	}
 
-	test->scratch = failcnt;
+	ctx->scratch = failcnt;
 }
 
-static bool dr_intercept_finished(struct svm_test *test)
+static bool dr_intercept_finished(struct svm_test_context *ctx)
 {
 	ulong n = (vcpu0.vmcb->control.exit_code - SVM_EXIT_READ_DR0);
 
@@ -264,7 +264,7 @@ static bool dr_intercept_finished(struct svm_test *test)
 	 * http://support.amd.com/TechDocs/24593.pdf
 	 * there are 16 VMEXIT codes each for DR read and write.
 	 */
-	test->scratch = (n % 16);
+	ctx->scratch = (n % 16);
 
 	/* Jump over MOV instruction */
 	vcpu0.vmcb->save.rip += 3;
@@ -272,9 +272,9 @@ static bool dr_intercept_finished(struct svm_test *test)
 	return false;
 }
 
-static bool check_dr_intercept(struct svm_test *test)
+static bool check_dr_intercept(struct svm_test_context *ctx)
 {
-	return !test->scratch;
+	return !ctx->scratch;
 }
 
 static bool next_rip_supported(void)
@@ -282,20 +282,20 @@ static bool next_rip_supported(void)
 	return this_cpu_has(X86_FEATURE_NRIPS);
 }
 
-static void prepare_next_rip(struct svm_test *test)
+static void prepare_next_rip(struct svm_test_context *ctx)
 {
 	vcpu0.vmcb->control.intercept |= (1ULL << INTERCEPT_RDTSC);
 }
 
 
-static void test_next_rip(struct svm_test *test)
+static void test_next_rip(struct svm_test_context *ctx)
 {
 	asm volatile ("rdtsc\n\t"
 		      ".globl exp_next_rip\n\t"
 		      "exp_next_rip:\n\t" ::: "eax", "edx");
 }
 
-static bool check_next_rip(struct svm_test *test)
+static bool check_next_rip(struct svm_test_context *ctx)
 {
 	extern char exp_next_rip;
 	unsigned long address = (unsigned long)&exp_next_rip;
@@ -304,14 +304,14 @@ static bool check_next_rip(struct svm_test *test)
 }
 
 
-static void prepare_msr_intercept(struct svm_test *test)
+static void prepare_msr_intercept(struct svm_test_context *ctx)
 {
 	vcpu0.vmcb->control.intercept |= (1ULL << INTERCEPT_MSR_PROT);
 	vcpu0.vmcb->control.intercept_exceptions |= (1ULL << GP_VECTOR);
 	memset(svm_get_msr_bitmap(), 0xff, MSR_BITMAP_SIZE);
 }
 
-static void test_msr_intercept(struct svm_test *test)
+static void test_msr_intercept(struct svm_test_context *ctx)
 {
 	unsigned long msr_value = 0xef8056791234abcd; /* Arbitrary value */
 	unsigned long msr_index;
@@ -333,12 +333,12 @@ static void test_msr_intercept(struct svm_test *test)
 		else if (msr_index == 0xc0002000)
 			msr_index = 0xc0010000;
 
-		test->scratch = -1;
+		ctx->scratch = -1;
 
 		rdmsr(msr_index);
 
 		/* Check that a read intercept occurred for MSR at msr_index */
-		if (test->scratch != msr_index)
+		if (ctx->scratch != msr_index)
 			report_fail("MSR 0x%lx read intercept", msr_index);
 
 		/*
@@ -350,14 +350,14 @@ static void test_msr_intercept(struct svm_test *test)
 		wrmsr(msr_index, msr_value);
 
 		/* Check that a write intercept occurred for MSR with msr_value */
-		if (test->scratch != msr_value)
+		if (ctx->scratch != msr_value)
 			report_fail("MSR 0x%lx write intercept", msr_index);
 	}
 
-	test->scratch = -2;
+	ctx->scratch = -2;
 }
 
-static bool msr_intercept_finished(struct svm_test *test)
+static bool msr_intercept_finished(struct svm_test_context *ctx)
 {
 	u32 exit_code = vcpu0.vmcb->control.exit_code;
 	u64 exit_info_1;
@@ -402,37 +402,37 @@ static bool msr_intercept_finished(struct svm_test *test)
 
 	/*
 	 * Test whether the intercept was for RDMSR/WRMSR.
-	 * For RDMSR, test->scratch is set to the MSR index;
+	 * For RDMSR, ctx->scratch is set to the MSR index;
 	 *      RCX holds the MSR index.
-	 * For WRMSR, test->scratch is set to the MSR value;
+	 * For WRMSR, ctx->scratch is set to the MSR value;
 	 *      RDX holds the upper 32 bits of the MSR value,
 	 *      while RAX hold its lower 32 bits.
 	 */
 	if (exit_info_1)
-		test->scratch =
+		ctx->scratch =
 			((vcpu0.regs.rdx << 32) | (vcpu0.regs.rax & 0xffffffff));
 	else
-		test->scratch = vcpu0.regs.rcx;
+		ctx->scratch = vcpu0.regs.rcx;
 
 	return false;
 }
 
-static bool check_msr_intercept(struct svm_test *test)
+static bool check_msr_intercept(struct svm_test_context *ctx)
 {
 	memset(svm_get_msr_bitmap(), 0, MSR_BITMAP_SIZE);
-	return (test->scratch == -2);
+	return (ctx->scratch == -2);
 }
 
-static void prepare_mode_switch(struct svm_test *test)
+static void prepare_mode_switch(struct svm_test_context *ctx)
 {
 	vcpu0.vmcb->control.intercept_exceptions |= (1ULL << GP_VECTOR)
 		|  (1ULL << UD_VECTOR)
 		|  (1ULL << DF_VECTOR)
 		|  (1ULL << PF_VECTOR);
-	test->scratch = 0;
+	ctx->scratch = 0;
 }
 
-static void test_mode_switch(struct svm_test *test)
+static void test_mode_switch(struct svm_test_context *ctx)
 {
 	asm volatile("	cli\n"
 		     "	ljmp *1f\n" /* jump to 32-bit code segment */
@@ -487,7 +487,7 @@ static void test_mode_switch(struct svm_test *test)
 		     : "rax", "rbx", "rcx", "rdx", "memory");
 }
 
-static bool mode_switch_finished(struct svm_test *test)
+static bool mode_switch_finished(struct svm_test_context *ctx)
 {
 	u64 cr0, cr4, efer;
 
@@ -503,7 +503,7 @@ static bool mode_switch_finished(struct svm_test *test)
 	vcpu0.vmcb->save.rip += 3;
 
 	/* Do sanity checks */
-	switch (test->scratch) {
+	switch (ctx->scratch) {
 	case 0:
 		/* Test should be in real mode now - check for this */
 		if ((cr0  & 0x80000001) || /* CR0.PG, CR0.PE */
@@ -521,99 +521,99 @@ static bool mode_switch_finished(struct svm_test *test)
 	}
 
 	/* one step forward */
-	test->scratch += 1;
+	ctx->scratch += 1;
 
-	return test->scratch == 2;
+	return ctx->scratch == 2;
 }
 
-static bool check_mode_switch(struct svm_test *test)
+static bool check_mode_switch(struct svm_test_context *ctx)
 {
-	return test->scratch == 2;
+	return ctx->scratch == 2;
 }
 
-static void prepare_ioio(struct svm_test *test)
+static void prepare_ioio(struct svm_test_context *ctx)
 {
 	u8 *io_bitmap = svm_get_io_bitmap();
 
 	vcpu0.vmcb->control.intercept |= (1ULL << INTERCEPT_IOIO_PROT);
-	test->scratch = 0;
+	ctx->scratch = 0;
 	memset(io_bitmap, 0, 8192);
 	io_bitmap[8192] = 0xFF;
 }
 
-static void test_ioio(struct svm_test *test)
+static void test_ioio(struct svm_test_context *ctx)
 {
 	u8 *io_bitmap = svm_get_io_bitmap();
 
 	// stage 0, test IO pass
 	inb(0x5000);
 	outb(0x0, 0x5000);
-	if (get_test_stage(test) != 0)
+	if (get_test_stage(ctx) != 0)
 		goto fail;
 
 	// test IO width, in/out
 	io_bitmap[0] = 0xFF;
-	inc_test_stage(test);
+	inc_test_stage(ctx);
 	inb(0x0);
-	if (get_test_stage(test) != 2)
+	if (get_test_stage(ctx) != 2)
 		goto fail;
 
 	outw(0x0, 0x0);
-	if (get_test_stage(test) != 3)
+	if (get_test_stage(ctx) != 3)
 		goto fail;
 
 	inl(0x0);
-	if (get_test_stage(test) != 4)
+	if (get_test_stage(ctx) != 4)
 		goto fail;
 
 	// test low/high IO port
 	io_bitmap[0x5000 / 8] = (1 << (0x5000 % 8));
 	inb(0x5000);
-	if (get_test_stage(test) != 5)
+	if (get_test_stage(ctx) != 5)
 		goto fail;
 
 	io_bitmap[0x9000 / 8] = (1 << (0x9000 % 8));
 	inw(0x9000);
-	if (get_test_stage(test) != 6)
+	if (get_test_stage(ctx) != 6)
 		goto fail;
 
 	// test partial pass
 	io_bitmap[0x5000 / 8] = (1 << (0x5000 % 8));
 	inl(0x4FFF);
-	if (get_test_stage(test) != 7)
+	if (get_test_stage(ctx) != 7)
 		goto fail;
 
 	// test across pages
-	inc_test_stage(test);
+	inc_test_stage(ctx);
 	inl(0x7FFF);
-	if (get_test_stage(test) != 8)
+	if (get_test_stage(ctx) != 8)
 		goto fail;
 
-	inc_test_stage(test);
+	inc_test_stage(ctx);
 	io_bitmap[0x8000 / 8] = 1 << (0x8000 % 8);
 	inl(0x7FFF);
-	if (get_test_stage(test) != 10)
+	if (get_test_stage(ctx) != 10)
 		goto fail;
 
 	io_bitmap[0] = 0;
 	inl(0xFFFF);
-	if (get_test_stage(test) != 11)
+	if (get_test_stage(ctx) != 11)
 		goto fail;
 
 	io_bitmap[0] = 0xFF;
 	io_bitmap[8192] = 0;
 	inl(0xFFFF);
-	inc_test_stage(test);
-	if (get_test_stage(test) != 12)
+	inc_test_stage(ctx);
+	if (get_test_stage(ctx) != 12)
 		goto fail;
 
 	return;
 fail:
-	report_fail("stage %d", get_test_stage(test));
-	test->scratch = -1;
+	report_fail("stage %d", get_test_stage(ctx));
+	ctx->scratch = -1;
 }
 
-static bool ioio_finished(struct svm_test *test)
+static bool ioio_finished(struct svm_test_context *ctx)
 {
 	unsigned port, size;
 	u8 *io_bitmap = svm_get_io_bitmap();
@@ -626,7 +626,7 @@ static bool ioio_finished(struct svm_test *test)
 		return true;
 
 	/* one step forward */
-	test->scratch += 1;
+	ctx->scratch += 1;
 
 	port = vcpu0.vmcb->control.exit_info_1 >> 16;
 	size = (vcpu0.vmcb->control.exit_info_1 >> SVM_IOIO_SIZE_SHIFT) & 7;
@@ -639,40 +639,40 @@ static bool ioio_finished(struct svm_test *test)
 	return false;
 }
 
-static bool check_ioio(struct svm_test *test)
+static bool check_ioio(struct svm_test_context *ctx)
 {
 	u8 *io_bitmap = svm_get_io_bitmap();
 
 	memset(io_bitmap, 0, 8193);
-	return test->scratch != -1;
+	return ctx->scratch != -1;
 }
 
-static void prepare_asid_zero(struct svm_test *test)
+static void prepare_asid_zero(struct svm_test_context *ctx)
 {
 	vcpu0.vmcb->control.asid = 0;
 }
 
-static void test_asid_zero(struct svm_test *test)
+static void test_asid_zero(struct svm_test_context *ctx)
 {
 	asm volatile ("vmmcall\n\t");
 }
 
-static bool check_asid_zero(struct svm_test *test)
+static bool check_asid_zero(struct svm_test_context *ctx)
 {
 	return vcpu0.vmcb->control.exit_code == SVM_EXIT_ERR;
 }
 
-static void sel_cr0_bug_prepare(struct svm_test *test)
+static void sel_cr0_bug_prepare(struct svm_test_context *ctx)
 {
 	vcpu0.vmcb->control.intercept |= (1ULL << INTERCEPT_SELECTIVE_CR0);
 }
 
-static bool sel_cr0_bug_finished(struct svm_test *test)
+static bool sel_cr0_bug_finished(struct svm_test_context *ctx)
 {
 	return true;
 }
 
-static void sel_cr0_bug_test(struct svm_test *test)
+static void sel_cr0_bug_test(struct svm_test_context *ctx)
 {
 	unsigned long cr0;
 
@@ -690,7 +690,7 @@ static void sel_cr0_bug_test(struct svm_test *test)
 	exit(report_summary());
 }
 
-static bool sel_cr0_bug_check(struct svm_test *test)
+static bool sel_cr0_bug_check(struct svm_test_context *ctx)
 {
 	return vcpu0.vmcb->control.exit_code == SVM_EXIT_CR0_SEL_WRITE;
 }
@@ -704,7 +704,7 @@ static bool tsc_adjust_supported(void)
 	return this_cpu_has(X86_FEATURE_TSC_ADJUST);
 }
 
-static void tsc_adjust_prepare(struct svm_test *test)
+static void tsc_adjust_prepare(struct svm_test_context *ctx)
 {
 	vcpu0.vmcb->control.tsc_offset = TSC_OFFSET_VALUE;
 
@@ -713,7 +713,7 @@ static void tsc_adjust_prepare(struct svm_test *test)
 	ok = adjust == -TSC_ADJUST_VALUE;
 }
 
-static void tsc_adjust_test(struct svm_test *test)
+static void tsc_adjust_test(struct svm_test_context *ctx)
 {
 	int64_t adjust = rdmsr(MSR_IA32_TSC_ADJUST);
 	ok &= adjust == -TSC_ADJUST_VALUE;
@@ -731,7 +731,7 @@ static void tsc_adjust_test(struct svm_test *test)
 	ok &= (l1_tsc_msr + TSC_ADJUST_VALUE - l1_tsc) < TSC_ADJUST_VALUE;
 }
 
-static bool tsc_adjust_check(struct svm_test *test)
+static bool tsc_adjust_check(struct svm_test_context *ctx)
 {
 	int64_t adjust = rdmsr(MSR_IA32_TSC_ADJUST);
 
@@ -745,7 +745,7 @@ static u64 guest_tsc_delay_value;
 #define TSC_SHIFT 24
 #define TSC_SCALE_ITERATIONS 10
 
-static void svm_tsc_scale_guest(struct svm_test *test)
+static void svm_tsc_scale_guest(struct svm_test_context *ctx)
 {
 	u64 start_tsc = rdtsc();
 
@@ -803,7 +803,7 @@ static void svm_tsc_scale_test(void)
 	svm_tsc_scale_run_testcase(50, 0.0001, rdrand());
 }
 
-static void latency_prepare(struct svm_test *test)
+static void latency_prepare(struct svm_test_context *ctx)
 {
 	runs = LATENCY_RUNS;
 	latvmrun_min = latvmexit_min = -1ULL;
@@ -812,7 +812,7 @@ static void latency_prepare(struct svm_test *test)
 	tsc_start = rdtsc();
 }
 
-static void latency_test(struct svm_test *test)
+static void latency_test(struct svm_test_context *ctx)
 {
 	u64 cycles;
 
@@ -835,7 +835,7 @@ start:
 	goto start;
 }
 
-static bool latency_finished(struct svm_test *test)
+static bool latency_finished(struct svm_test_context *ctx)
 {
 	u64 cycles;
 
@@ -860,13 +860,13 @@ static bool latency_finished(struct svm_test *test)
 	return runs == 0;
 }
 
-static bool latency_finished_clean(struct svm_test *test)
+static bool latency_finished_clean(struct svm_test_context *ctx)
 {
 	vcpu0.vmcb->control.clean = VMCB_CLEAN_ALL;
-	return latency_finished(test);
+	return latency_finished(ctx);
 }
 
-static bool latency_check(struct svm_test *test)
+static bool latency_check(struct svm_test_context *ctx)
 {
 	printf("    Latency VMRUN : max: %ld min: %ld avg: %ld\n", latvmrun_max,
 	       latvmrun_min, vmrun_sum / LATENCY_RUNS);
@@ -875,7 +875,7 @@ static bool latency_check(struct svm_test *test)
 	return true;
 }
 
-static void lat_svm_insn_prepare(struct svm_test *test)
+static void lat_svm_insn_prepare(struct svm_test_context *ctx)
 {
 	runs = LATENCY_RUNS;
 	latvmload_min = latvmsave_min = latstgi_min = latclgi_min = -1ULL;
@@ -883,7 +883,7 @@ static void lat_svm_insn_prepare(struct svm_test *test)
 	vmload_sum = vmsave_sum = stgi_sum = clgi_sum;
 }
 
-static bool lat_svm_insn_finished(struct svm_test *test)
+static bool lat_svm_insn_finished(struct svm_test_context *ctx)
 {
 	u64 vmcb_phys = virt_to_phys(vcpu0.vmcb);
 	u64 cycles;
@@ -931,7 +931,7 @@ static bool lat_svm_insn_finished(struct svm_test *test)
 	return true;
 }
 
-static bool lat_svm_insn_check(struct svm_test *test)
+static bool lat_svm_insn_check(struct svm_test_context *ctx)
 {
 	printf("    Latency VMLOAD: max: %ld min: %ld avg: %ld\n", latvmload_max,
 	       latvmload_min, vmload_sum / LATENCY_RUNS);
@@ -953,11 +953,10 @@ static void pending_event_ipi_isr(isr_regs_t *regs)
 	eoi();
 }
 
-static void pending_event_prepare(struct svm_test *test)
+static void pending_event_prepare(struct svm_test_context *ctx)
 {
 	int ipi_vector = 0xf1;
 
-
 	pending_event_ipi_fired = false;
 
 	handle_irq(ipi_vector, pending_event_ipi_isr);
@@ -970,17 +969,17 @@ static void pending_event_prepare(struct svm_test *test)
 	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL |
 		       APIC_DM_FIXED | ipi_vector, 0);
 
-	set_test_stage(test, 0);
+	set_test_stage(ctx, 0);
 }
 
-static void pending_event_test(struct svm_test *test)
+static void pending_event_test(struct svm_test_context *ctx)
 {
 	pending_event_guest_run = true;
 }
 
-static bool pending_event_finished(struct svm_test *test)
+static bool pending_event_finished(struct svm_test_context *ctx)
 {
-	switch (get_test_stage(test)) {
+	switch (get_test_stage(ctx)) {
 	case 0:
 		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_INTR) {
 			report_fail("VMEXIT not due to pending interrupt. Exit reason 0x%x",
@@ -1012,17 +1011,17 @@ static bool pending_event_finished(struct svm_test *test)
 		break;
 	}
 
-	inc_test_stage(test);
+	inc_test_stage(ctx);
 
-	return get_test_stage(test) == 2;
+	return get_test_stage(ctx) == 2;
 }
 
-static bool pending_event_check(struct svm_test *test)
+static bool pending_event_check(struct svm_test_context *ctx)
 {
-	return get_test_stage(test) == 2;
+	return get_test_stage(ctx) == 2;
 }
 
-static void pending_event_cli_prepare(struct svm_test *test)
+static void pending_event_cli_prepare(struct svm_test_context *ctx)
 {
 	pending_event_ipi_fired = false;
 
@@ -1031,18 +1030,18 @@ static void pending_event_cli_prepare(struct svm_test *test)
 	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL |
 		       APIC_DM_FIXED | 0xf1, 0);
 
-	set_test_stage(test, 0);
+	set_test_stage(ctx, 0);
 }
 
-static void pending_event_cli_prepare_gif_clear(struct svm_test *test)
+static void pending_event_cli_prepare_gif_clear(struct svm_test_context *ctx)
 {
 	asm("cli");
 }
 
-static void pending_event_cli_test(struct svm_test *test)
+static void pending_event_cli_test(struct svm_test_context *ctx)
 {
 	if (pending_event_ipi_fired == true) {
-		set_test_stage(test, -1);
+		set_test_stage(ctx, -1);
 		report_fail("Interrupt preceeded guest");
 		vmmcall();
 	}
@@ -1051,7 +1050,7 @@ static void pending_event_cli_test(struct svm_test *test)
 	sti_nop_cli();
 
 	if (pending_event_ipi_fired != true) {
-		set_test_stage(test, -1);
+		set_test_stage(ctx, -1);
 		report_fail("Interrupt not triggered by guest");
 	}
 
@@ -1065,7 +1064,7 @@ static void pending_event_cli_test(struct svm_test *test)
 	sti_nop_cli();
 }
 
-static bool pending_event_cli_finished(struct svm_test *test)
+static bool pending_event_cli_finished(struct svm_test_context *ctx)
 {
 	if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
 		report_fail("VM_EXIT return to host is not EXIT_VMMCALL exit reason 0x%x",
@@ -1073,7 +1072,7 @@ static bool pending_event_cli_finished(struct svm_test *test)
 		return true;
 	}
 
-	switch (get_test_stage(test)) {
+	switch (get_test_stage(ctx)) {
 	case 0:
 		vcpu0.vmcb->save.rip += 3;
 
@@ -1106,14 +1105,14 @@ static bool pending_event_cli_finished(struct svm_test *test)
 		return true;
 	}
 
-	inc_test_stage(test);
+	inc_test_stage(ctx);
 
-	return get_test_stage(test) == 2;
+	return get_test_stage(ctx) == 2;
 }
 
-static bool pending_event_cli_check(struct svm_test *test)
+static bool pending_event_cli_check(struct svm_test_context *ctx)
 {
-	return get_test_stage(test) == 2;
+	return get_test_stage(ctx) == 2;
 }
 
 #define TIMER_VECTOR    222
@@ -1126,14 +1125,14 @@ static void timer_isr(isr_regs_t *regs)
 	apic_write(APIC_EOI, 0);
 }
 
-static void interrupt_prepare(struct svm_test *test)
+static void interrupt_prepare(struct svm_test_context *ctx)
 {
 	handle_irq(TIMER_VECTOR, timer_isr);
 	timer_fired = false;
-	set_test_stage(test, 0);
+	set_test_stage(ctx, 0);
 }
 
-static void interrupt_test(struct svm_test *test)
+static void interrupt_test(struct svm_test_context *ctx)
 {
 	long long start, loops;
 
@@ -1147,7 +1146,7 @@ static void interrupt_test(struct svm_test *test)
 	report(timer_fired, "direct interrupt while running guest");
 
 	if (!timer_fired) {
-		set_test_stage(test, -1);
+		set_test_stage(ctx, -1);
 		vmmcall();
 	}
 
@@ -1163,7 +1162,7 @@ static void interrupt_test(struct svm_test *test)
 	report(timer_fired, "intercepted interrupt while running guest");
 
 	if (!timer_fired) {
-		set_test_stage(test, -1);
+		set_test_stage(ctx, -1);
 		vmmcall();
 	}
 
@@ -1180,7 +1179,7 @@ static void interrupt_test(struct svm_test *test)
 	       "direct interrupt + hlt");
 
 	if (!timer_fired) {
-		set_test_stage(test, -1);
+		set_test_stage(ctx, -1);
 		vmmcall();
 	}
 
@@ -1197,16 +1196,16 @@ static void interrupt_test(struct svm_test *test)
 	       "intercepted interrupt + hlt");
 
 	if (!timer_fired) {
-		set_test_stage(test, -1);
+		set_test_stage(ctx, -1);
 		vmmcall();
 	}
 
 	apic_cleanup_timer();
 }
 
-static bool interrupt_finished(struct svm_test *test)
+static bool interrupt_finished(struct svm_test_context *ctx)
 {
-	switch (get_test_stage(test)) {
+	switch (get_test_stage(ctx)) {
 	case 0:
 	case 2:
 		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
@@ -1241,14 +1240,14 @@ static bool interrupt_finished(struct svm_test *test)
 		return true;
 	}
 
-	inc_test_stage(test);
+	inc_test_stage(ctx);
 
-	return get_test_stage(test) == 5;
+	return get_test_stage(ctx) == 5;
 }
 
-static bool interrupt_check(struct svm_test *test)
+static bool interrupt_check(struct svm_test_context *ctx)
 {
-	return get_test_stage(test) == 5;
+	return get_test_stage(ctx) == 5;
 }
 
 static volatile bool nmi_fired;
@@ -1258,21 +1257,21 @@ static void nmi_handler(struct ex_regs *regs)
 	nmi_fired = true;
 }
 
-static void nmi_prepare(struct svm_test *test)
+static void nmi_prepare(struct svm_test_context *ctx)
 {
 	nmi_fired = false;
 	handle_exception(NMI_VECTOR, nmi_handler);
-	set_test_stage(test, 0);
+	set_test_stage(ctx, 0);
 }
 
-static void nmi_test(struct svm_test *test)
+static void nmi_test(struct svm_test_context *ctx)
 {
 	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_NMI | APIC_INT_ASSERT, 0);
 
 	report(nmi_fired, "direct NMI while running guest");
 
 	if (!nmi_fired)
-		set_test_stage(test, -1);
+		set_test_stage(ctx, -1);
 
 	vmmcall();
 
@@ -1282,14 +1281,14 @@ static void nmi_test(struct svm_test *test)
 
 	if (!nmi_fired) {
 		report(nmi_fired, "intercepted pending NMI not dispatched");
-		set_test_stage(test, -1);
+		set_test_stage(ctx, -1);
 	}
 
 }
 
-static bool nmi_finished(struct svm_test *test)
+static bool nmi_finished(struct svm_test_context *ctx)
 {
-	switch (get_test_stage(test)) {
+	switch (get_test_stage(ctx)) {
 	case 0:
 		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
 			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
@@ -1318,30 +1317,30 @@ static bool nmi_finished(struct svm_test *test)
 		return true;
 	}
 
-	inc_test_stage(test);
+	inc_test_stage(ctx);
 
-	return get_test_stage(test) == 3;
+	return get_test_stage(ctx) == 3;
 }
 
-static bool nmi_check(struct svm_test *test)
+static bool nmi_check(struct svm_test_context *ctx)
 {
-	return get_test_stage(test) == 3;
+	return get_test_stage(ctx) == 3;
 }
 
 #define NMI_DELAY 100000000ULL
 
-static void nmi_message_thread(void *_test)
+static void nmi_message_thread(void *_ctx)
 {
-	struct svm_test *test = _test;
+	struct svm_test_context *ctx = _ctx;
 
-	while (get_test_stage(test) != 1)
+	while (get_test_stage(ctx) != 1)
 		pause();
 
 	delay(NMI_DELAY);
 
 	apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_NMI | APIC_INT_ASSERT, id_map[0]);
 
-	while (get_test_stage(test) != 2)
+	while (get_test_stage(ctx) != 2)
 		pause();
 
 	delay(NMI_DELAY);
@@ -1349,15 +1348,15 @@ static void nmi_message_thread(void *_test)
 	apic_icr_write(APIC_DEST_PHYSICAL | APIC_DM_NMI | APIC_INT_ASSERT, id_map[0]);
 }
 
-static void nmi_hlt_test(struct svm_test *test)
+static void nmi_hlt_test(struct svm_test_context *ctx)
 {
 	long long start;
 
-	on_cpu_async(1, nmi_message_thread, test);
+	on_cpu_async(1, nmi_message_thread, ctx);
 
 	start = rdtsc();
 
-	set_test_stage(test, 1);
+	set_test_stage(ctx, 1);
 
 	asm volatile ("hlt");
 
@@ -1365,7 +1364,7 @@ static void nmi_hlt_test(struct svm_test *test)
 	       "direct NMI + hlt");
 
 	if (!nmi_fired)
-		set_test_stage(test, -1);
+		set_test_stage(ctx, -1);
 
 	nmi_fired = false;
 
@@ -1373,7 +1372,7 @@ static void nmi_hlt_test(struct svm_test *test)
 
 	start = rdtsc();
 
-	set_test_stage(test, 2);
+	set_test_stage(ctx, 2);
 
 	asm volatile ("hlt");
 
@@ -1382,16 +1381,16 @@ static void nmi_hlt_test(struct svm_test *test)
 
 	if (!nmi_fired) {
 		report(nmi_fired, "intercepted pending NMI not dispatched");
-		set_test_stage(test, -1);
+		set_test_stage(ctx, -1);
 		vmmcall();
 	}
 
-	set_test_stage(test, 3);
+	set_test_stage(ctx, 3);
 }
 
-static bool nmi_hlt_finished(struct svm_test *test)
+static bool nmi_hlt_finished(struct svm_test_context *ctx)
 {
-	switch (get_test_stage(test)) {
+	switch (get_test_stage(ctx)) {
 	case 1:
 		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
 			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
@@ -1420,12 +1419,12 @@ static bool nmi_hlt_finished(struct svm_test *test)
 		return true;
 	}
 
-	return get_test_stage(test) == 3;
+	return get_test_stage(ctx) == 3;
 }
 
-static bool nmi_hlt_check(struct svm_test *test)
+static bool nmi_hlt_check(struct svm_test_context *ctx)
 {
-	return get_test_stage(test) == 3;
+	return get_test_stage(ctx) == 3;
 }
 
 static volatile int count_exc = 0;
@@ -1435,21 +1434,21 @@ static void my_isr(struct ex_regs *r)
 	count_exc++;
 }
 
-static void exc_inject_prepare(struct svm_test *test)
+static void exc_inject_prepare(struct svm_test_context *ctx)
 {
 	handle_exception(DE_VECTOR, my_isr);
 	handle_exception(NMI_VECTOR, my_isr);
 }
 
 
-static void exc_inject_test(struct svm_test *test)
+static void exc_inject_test(struct svm_test_context *ctx)
 {
 	asm volatile ("vmmcall\n\tvmmcall\n\t");
 }
 
-static bool exc_inject_finished(struct svm_test *test)
+static bool exc_inject_finished(struct svm_test_context *ctx)
 {
-	switch (get_test_stage(test)) {
+	switch (get_test_stage(ctx)) {
 	case 0:
 		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
 			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
@@ -1490,14 +1489,14 @@ static bool exc_inject_finished(struct svm_test *test)
 		return true;
 	}
 
-	inc_test_stage(test);
+	inc_test_stage(ctx);
 
-	return get_test_stage(test) == 3;
+	return get_test_stage(ctx) == 3;
 }
 
-static bool exc_inject_check(struct svm_test *test)
+static bool exc_inject_check(struct svm_test_context *ctx)
 {
-	return count_exc == 1 && get_test_stage(test) == 3;
+	return count_exc == 1 && get_test_stage(ctx) == 3;
 }
 
 static volatile bool virq_fired;
@@ -1507,7 +1506,7 @@ static void virq_isr(isr_regs_t *regs)
 	virq_fired = true;
 }
 
-static void virq_inject_prepare(struct svm_test *test)
+static void virq_inject_prepare(struct svm_test_context *ctx)
 {
 	handle_irq(0xf1, virq_isr);
 
@@ -1515,14 +1514,14 @@ static void virq_inject_prepare(struct svm_test *test)
 		(0x0f << V_INTR_PRIO_SHIFT); // Set to the highest priority
 	vcpu0.vmcb->control.int_vector = 0xf1;
 	virq_fired = false;
-	set_test_stage(test, 0);
+	set_test_stage(ctx, 0);
 }
 
-static void virq_inject_test(struct svm_test *test)
+static void virq_inject_test(struct svm_test_context *ctx)
 {
 	if (virq_fired) {
 		report_fail("virtual interrupt fired before L2 sti");
-		set_test_stage(test, -1);
+		set_test_stage(ctx, -1);
 		vmmcall();
 	}
 
@@ -1530,14 +1529,14 @@ static void virq_inject_test(struct svm_test *test)
 
 	if (!virq_fired) {
 		report_fail("virtual interrupt not fired after L2 sti");
-		set_test_stage(test, -1);
+		set_test_stage(ctx, -1);
 	}
 
 	vmmcall();
 
 	if (virq_fired) {
 		report_fail("virtual interrupt fired before L2 sti after VINTR intercept");
-		set_test_stage(test, -1);
+		set_test_stage(ctx, -1);
 		vmmcall();
 	}
 
@@ -1545,7 +1544,7 @@ static void virq_inject_test(struct svm_test *test)
 
 	if (!virq_fired) {
 		report_fail("virtual interrupt not fired after return from VINTR intercept");
-		set_test_stage(test, -1);
+		set_test_stage(ctx, -1);
 	}
 
 	vmmcall();
@@ -1554,18 +1553,18 @@ static void virq_inject_test(struct svm_test *test)
 
 	if (virq_fired) {
 		report_fail("virtual interrupt fired when V_IRQ_PRIO less than V_TPR");
-		set_test_stage(test, -1);
+		set_test_stage(ctx, -1);
 	}
 
 	vmmcall();
 	vmmcall();
 }
 
-static bool virq_inject_finished(struct svm_test *test)
+static bool virq_inject_finished(struct svm_test_context *ctx)
 {
 	vcpu0.vmcb->save.rip += 3;
 
-	switch (get_test_stage(test)) {
+	switch (get_test_stage(ctx)) {
 	case 0:
 		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
 			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
@@ -1631,14 +1630,14 @@ static bool virq_inject_finished(struct svm_test *test)
 		return true;
 	}
 
-	inc_test_stage(test);
+	inc_test_stage(ctx);
 
-	return get_test_stage(test) == 5;
+	return get_test_stage(ctx) == 5;
 }
 
-static bool virq_inject_check(struct svm_test *test)
+static bool virq_inject_check(struct svm_test_context *ctx)
 {
-	return get_test_stage(test) == 5;
+	return get_test_stage(ctx) == 5;
 }
 
 /*
@@ -1671,9 +1670,9 @@ static void reg_corruption_isr(isr_regs_t *regs)
 	apic_write(APIC_EOI, 0);
 }
 
-static void reg_corruption_prepare(struct svm_test *test)
+static void reg_corruption_prepare(struct svm_test_context *ctx)
 {
-	set_test_stage(test, 0);
+	set_test_stage(ctx, 0);
 
 	vcpu0.vmcb->control.int_ctl = V_INTR_MASKING_MASK;
 	vcpu0.vmcb->control.intercept |= (1ULL << INTERCEPT_INTR);
@@ -1685,7 +1684,7 @@ static void reg_corruption_prepare(struct svm_test *test)
 	apic_start_timer(1000);
 }
 
-static void reg_corruption_test(struct svm_test *test)
+static void reg_corruption_test(struct svm_test_context *ctx)
 {
 	/* this is endless loop, which is interrupted by the timer interrupt */
 	asm volatile (
@@ -1703,12 +1702,12 @@ static void reg_corruption_test(struct svm_test *test)
 		      );
 }
 
-static bool reg_corruption_finished(struct svm_test *test)
+static bool reg_corruption_finished(struct svm_test_context *ctx)
 {
 	if (isr_cnt == 10000) {
 		report_pass("No RIP corruption detected after %d timer interrupts",
 			    isr_cnt);
-		set_test_stage(test, 1);
+		set_test_stage(ctx, 1);
 		goto cleanup;
 	}
 
@@ -1732,9 +1731,9 @@ cleanup:
 
 }
 
-static bool reg_corruption_check(struct svm_test *test)
+static bool reg_corruption_check(struct svm_test_context *ctx)
 {
-	return get_test_stage(test) == 1;
+	return get_test_stage(ctx) == 1;
 }
 
 static void get_tss_entry(void *data)
@@ -1744,7 +1743,7 @@ static void get_tss_entry(void *data)
 
 static int orig_cpu_count;
 
-static void init_startup_prepare(struct svm_test *test)
+static void init_startup_prepare(struct svm_test_context *ctx)
 {
 	gdt_entry_t *tss_entry;
 	int i;
@@ -1768,30 +1767,30 @@ static void init_startup_prepare(struct svm_test *test)
 		delay(100000000ULL);
 }
 
-static bool init_startup_finished(struct svm_test *test)
+static bool init_startup_finished(struct svm_test_context *ctx)
 {
 	return true;
 }
 
-static bool init_startup_check(struct svm_test *test)
+static bool init_startup_check(struct svm_test_context *ctx)
 {
 	return atomic_read(&cpu_online_count) == orig_cpu_count;
 }
 
 static volatile bool init_intercept;
 
-static void init_intercept_prepare(struct svm_test *test)
+static void init_intercept_prepare(struct svm_test_context *ctx)
 {
 	init_intercept = false;
 	vcpu0.vmcb->control.intercept |= (1ULL << INTERCEPT_INIT);
 }
 
-static void init_intercept_test(struct svm_test *test)
+static void init_intercept_test(struct svm_test_context *ctx)
 {
 	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_INIT | APIC_INT_ASSERT, 0);
 }
 
-static bool init_intercept_finished(struct svm_test *test)
+static bool init_intercept_finished(struct svm_test_context *ctx)
 {
 	vcpu0.vmcb->save.rip += 3;
 
@@ -1809,7 +1808,7 @@ static bool init_intercept_finished(struct svm_test *test)
 	return true;
 }
 
-static bool init_intercept_check(struct svm_test *test)
+static bool init_intercept_check(struct svm_test_context *ctx)
 {
 	return init_intercept;
 }
@@ -1865,36 +1864,36 @@ static void host_rflags_db_handler(struct ex_regs *r)
 	}
 }
 
-static void host_rflags_prepare(struct svm_test *test)
+static void host_rflags_prepare(struct svm_test_context *ctx)
 {
 	handle_exception(DB_VECTOR, host_rflags_db_handler);
-	set_test_stage(test, 0);
+	set_test_stage(ctx, 0);
 }
 
-static void host_rflags_prepare_gif_clear(struct svm_test *test)
+static void host_rflags_prepare_gif_clear(struct svm_test_context *ctx)
 {
 	if (host_rflags_set_tf)
 		write_rflags(read_rflags() | X86_EFLAGS_TF);
 }
 
-static void host_rflags_test(struct svm_test *test)
+static void host_rflags_test(struct svm_test_context *ctx)
 {
 	while (1) {
-		if (get_test_stage(test) > 0) {
+		if (get_test_stage(ctx) > 0) {
 			if ((host_rflags_set_tf && !host_rflags_ss_on_vmrun && !host_rflags_db_handler_flag) ||
 			    (host_rflags_set_rf && host_rflags_db_handler_flag == 1))
 				host_rflags_guest_main_flag = 1;
 		}
 
-		if (get_test_stage(test) == 4)
+		if (get_test_stage(ctx) == 4)
 			break;
 		vmmcall();
 	}
 }
 
-static bool host_rflags_finished(struct svm_test *test)
+static bool host_rflags_finished(struct svm_test_context *ctx)
 {
-	switch (get_test_stage(test)) {
+	switch (get_test_stage(ctx)) {
 	case 0:
 		if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
 			report_fail("Unexpected VMEXIT. Exit reason 0x%x",
@@ -1958,13 +1957,13 @@ static bool host_rflags_finished(struct svm_test *test)
 	default:
 		return true;
 	}
-	inc_test_stage(test);
-	return get_test_stage(test) == 5;
+	inc_test_stage(ctx);
+	return get_test_stage(ctx) == 5;
 }
 
-static bool host_rflags_check(struct svm_test *test)
+static bool host_rflags_check(struct svm_test_context *ctx)
 {
-	return get_test_stage(test) == 4;
+	return get_test_stage(ctx) == 4;
 }
 
 #define TEST(name) { #name, .v2 = name }
@@ -1979,7 +1978,7 @@ static bool host_rflags_check(struct svm_test *test)
  * value than in L1.
  */
 
-static void svm_cr4_osxsave_test_guest(struct svm_test *test)
+static void svm_cr4_osxsave_test_guest(struct svm_test_context *ctx)
 {
 	write_cr4(read_cr4() & ~X86_CR4_OSXSAVE);
 }
@@ -2007,7 +2006,7 @@ static void svm_cr4_osxsave_test(void)
 	report(this_cpu_has(X86_FEATURE_OSXSAVE), "CPUID.01H:ECX.XSAVE set after VMRUN");
 }
 
-static void basic_guest_main(struct svm_test *test)
+static void basic_guest_main(struct svm_test_context *ctx)
 {
 }
 
@@ -2423,7 +2422,7 @@ static void svm_guest_state_test(void)
 	test_canonicalization();
 }
 
-extern void guest_rflags_test_guest(struct svm_test *test);
+extern void guest_rflags_test_guest(struct svm_test_context *ctx);
 extern u64 *insn2;
 extern u64 *guest_end;
 
@@ -2536,7 +2535,7 @@ static void svm_vmrun_errata_test(void)
 	}
 }
 
-static void vmload_vmsave_guest_main(struct svm_test *test)
+static void vmload_vmsave_guest_main(struct svm_test_context *ctx)
 {
 	u64 vmcb_phys = virt_to_phys(vcpu0.vmcb);
 
@@ -2599,18 +2598,18 @@ static void svm_vmload_vmsave(void)
 	vcpu0.vmcb->control.intercept = intercept_saved;
 }
 
-static void prepare_vgif_enabled(struct svm_test *test)
+static void prepare_vgif_enabled(struct svm_test_context *ctx)
 {
 }
 
-static void test_vgif(struct svm_test *test)
+static void test_vgif(struct svm_test_context *ctx)
 {
 	asm volatile ("vmmcall\n\tstgi\n\tvmmcall\n\tclgi\n\tvmmcall\n\t");
 }
 
-static bool vgif_finished(struct svm_test *test)
+static bool vgif_finished(struct svm_test_context *ctx)
 {
-	switch (get_test_stage(test))
+	switch (get_test_stage(ctx))
 		{
 		case 0:
 			if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
@@ -2619,7 +2618,7 @@ static bool vgif_finished(struct svm_test *test)
 			}
 			vcpu0.vmcb->control.int_ctl |= V_GIF_ENABLED_MASK;
 			vcpu0.vmcb->save.rip += 3;
-			inc_test_stage(test);
+			inc_test_stage(ctx);
 			break;
 		case 1:
 			if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
@@ -2633,7 +2632,7 @@ static bool vgif_finished(struct svm_test *test)
 			}
 			report_pass("STGI set VGIF bit.");
 			vcpu0.vmcb->save.rip += 3;
-			inc_test_stage(test);
+			inc_test_stage(ctx);
 			break;
 		case 2:
 			if (vcpu0.vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
@@ -2647,7 +2646,7 @@ static bool vgif_finished(struct svm_test *test)
 			}
 			report_pass("CLGI cleared VGIF bit.");
 			vcpu0.vmcb->save.rip += 3;
-			inc_test_stage(test);
+			inc_test_stage(ctx);
 			vcpu0.vmcb->control.int_ctl &= ~V_GIF_ENABLED_MASK;
 			break;
 		default:
@@ -2655,19 +2654,19 @@ static bool vgif_finished(struct svm_test *test)
 			break;
 		}
 
-	return get_test_stage(test) == 3;
+	return get_test_stage(ctx) == 3;
 }
 
-static bool vgif_check(struct svm_test *test)
+static bool vgif_check(struct svm_test_context *ctx)
 {
-	return get_test_stage(test) == 3;
+	return get_test_stage(ctx) == 3;
 }
 
 
 static int pause_test_counter;
 static int wait_counter;
 
-static void pause_filter_test_guest_main(struct svm_test *test)
+static void pause_filter_test_guest_main(struct svm_test_context *ctx)
 {
 	int i;
 	for (i = 0 ; i < pause_test_counter ; i++)
@@ -3025,7 +3024,7 @@ static void svm_intr_intercept_mix_run_guest(volatile int *counter, int expected
 
 
 // subtest: test that enabling EFLAGS.IF is enough to trigger an interrupt
-static void svm_intr_intercept_mix_if_guest(struct svm_test *test)
+static void svm_intr_intercept_mix_if_guest(struct svm_test_context *ctx)
 {
 	asm volatile("nop;nop;nop;nop");
 	report(!dummy_isr_recevied, "No interrupt expected");
@@ -3051,7 +3050,7 @@ static void svm_intr_intercept_mix_if(void)
 
 // subtest: test that a clever guest can trigger an interrupt by setting GIF
 // if GIF is not intercepted
-static void svm_intr_intercept_mix_gif_guest(struct svm_test *test)
+static void svm_intr_intercept_mix_gif_guest(struct svm_test_context *ctx)
 {
 
 	asm volatile("nop;nop;nop;nop");
@@ -3084,7 +3083,7 @@ static void svm_intr_intercept_mix_gif(void)
 // subtest: test that a clever guest can trigger an interrupt by setting GIF
 // if GIF is not intercepted and interrupt comes after guest
 // started running
-static void svm_intr_intercept_mix_gif_guest2(struct svm_test *test)
+static void svm_intr_intercept_mix_gif_guest2(struct svm_test_context *ctx)
 {
 	asm volatile("nop;nop;nop;nop");
 	report(!dummy_isr_recevied, "No interrupt expected");
@@ -3111,7 +3110,7 @@ static void svm_intr_intercept_mix_gif2(void)
 
 
 // subtest: test that pending NMI will be handled when guest enables GIF
-static void svm_intr_intercept_mix_nmi_guest(struct svm_test *test)
+static void svm_intr_intercept_mix_nmi_guest(struct svm_test_context *ctx)
 {
 	asm volatile("nop;nop;nop;nop");
 	report(!nmi_recevied, "No NMI expected");
@@ -3141,7 +3140,7 @@ static void svm_intr_intercept_mix_nmi(void)
 // test that pending SMI will be handled when guest enables GIF
 // TODO: can't really count #SMIs so just test that guest doesn't hang
 // and VMexits on SMI
-static void svm_intr_intercept_mix_smi_guest(struct svm_test *test)
+static void svm_intr_intercept_mix_smi_guest(struct svm_test_context *ctx)
 {
 	asm volatile("nop;nop;nop;nop");
 
@@ -3239,7 +3238,7 @@ static void svm_exception_test(void)
 	}
 }
 
-static void shutdown_intercept_test_guest(struct svm_test *test)
+static void shutdown_intercept_test_guest(struct svm_test_context *ctx)
 {
 	asm volatile ("ud2");
 	report_fail("should not reach here\n");
@@ -3259,7 +3258,7 @@ static void svm_shutdown_intercept_test(void)
  * when parent exception is intercepted
  */
 
-static void exception_merging_prepare(struct svm_test *test)
+static void exception_merging_prepare(struct svm_test_context *ctx)
 {
 	vcpu0.vmcb->control.intercept_exceptions |= (1ULL << GP_VECTOR);
 
@@ -3267,12 +3266,12 @@ static void exception_merging_prepare(struct svm_test *test)
 	boot_idt[UD_VECTOR].type = 1;
 }
 
-static void exception_merging_test(struct svm_test *test)
+static void exception_merging_test(struct svm_test_context *ctx)
 {
 	asm volatile ("ud2");
 }
 
-static bool exception_merging_finished(struct svm_test *test)
+static bool exception_merging_finished(struct svm_test_context *ctx)
 {
 	u32 vec = vcpu0.vmcb->control.exit_int_info & SVM_EXITINTINFO_VEC_MASK;
 	u32 type = vcpu0.vmcb->control.exit_int_info & SVM_EXITINTINFO_TYPE_MASK;
@@ -3297,15 +3296,15 @@ static bool exception_merging_finished(struct svm_test *test)
 		goto out;
 	}
 
-	set_test_stage(test, 1);
+	set_test_stage(ctx, 1);
 out:
 	boot_idt[UD_VECTOR].type = 14;
 	return true;
 }
 
-static bool exception_merging_check(struct svm_test *test)
+static bool exception_merging_check(struct svm_test_context *ctx)
 {
-	return get_test_stage(test) == 1;
+	return get_test_stage(ctx) == 1;
 }
 
 
@@ -3315,7 +3314,7 @@ static bool exception_merging_check(struct svm_test *test)
  * in EXITINTINFO of the exception
  */
 
-static void interrupt_merging_prepare(struct svm_test *test)
+static void interrupt_merging_prepare(struct svm_test_context *ctx)
 {
 	/* intercept #GP */
 	vcpu0.vmcb->control.intercept_exceptions |= (1ULL << GP_VECTOR);
@@ -3327,7 +3326,7 @@ static void interrupt_merging_prepare(struct svm_test *test)
 
 #define INTERRUPT_MERGING_DELAY 100000000ULL
 
-static void interrupt_merging_test(struct svm_test *test)
+static void interrupt_merging_test(struct svm_test_context *ctx)
 {
 	handle_irq(TIMER_VECTOR, timer_isr);
 	/* break timer vector IDT entry to get #GP on interrupt delivery */
@@ -3337,7 +3336,7 @@ static void interrupt_merging_test(struct svm_test *test)
 	delay(INTERRUPT_MERGING_DELAY);
 }
 
-static bool interrupt_merging_finished(struct svm_test *test)
+static bool interrupt_merging_finished(struct svm_test_context *ctx)
 {
 
 	u32 vec = vcpu0.vmcb->control.exit_int_info & SVM_EXITINTINFO_VEC_MASK;
@@ -3375,7 +3374,7 @@ static bool interrupt_merging_finished(struct svm_test *test)
 		goto cleanup;
 	}
 
-	set_test_stage(test, 1);
+	set_test_stage(ctx, 1);
 
 cleanup:
 	// restore the IDT gate
@@ -3387,9 +3386,9 @@ cleanup:
 	return true;
 }
 
-static bool interrupt_merging_check(struct svm_test *test)
+static bool interrupt_merging_check(struct svm_test_context *ctx)
 {
-	return get_test_stage(test) == 1;
+	return get_test_stage(ctx) == 1;
 }
 
 
-- 
2.34.3

