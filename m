Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3C8634146
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 17:16:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234393AbiKVQQt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 11:16:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234237AbiKVQQN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 11:16:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 595B56F35A
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 08:13:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669133579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mj5PTzGu3S0oj4ln+RKEFNHuK3fMDauOmxIZGd28qJA=;
        b=PgONVy1C/Trz8PKCpXQVMnaOU5Zt8IX31v78db5iHXehs5WZHuqrqvnRouORhT2RXgiiMP
        vYmwb/hEN9YMS8u0VaLwd5ysKT50sAbp2Emu1nHqNrZuZMvmSfjFMm8oLfnN1if/9KsC8n
        D6W/n+IWWQfjmbeY1mGCb5RDs0FTsrs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-640-Pb_19b4_PAC_YUn51t_J3g-1; Tue, 22 Nov 2022 11:12:56 -0500
X-MC-Unique: Pb_19b4_PAC_YUn51t_J3g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B63151C0896E;
        Tue, 22 Nov 2022 16:12:55 +0000 (UTC)
Received: from amdlaptop.tlv.redhat.com (dhcp-4-238.tlv.redhat.com [10.35.4.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BAFED112132D;
        Tue, 22 Nov 2022 16:12:53 +0000 (UTC)
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
Subject: [kvm-unit-tests PATCH v3 26/27] svm: move test_guest_func to test context
Date:   Tue, 22 Nov 2022 18:11:51 +0200
Message-Id: <20221122161152.293072-27-mlevitsk@redhat.com>
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

Make test context have pointer to the guest function.
For V1 tests it is initialized from the test template,
for V2 tests, the test functions sets it.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 x86/svm.c       | 12 ++++--------
 x86/svm.h       |  4 ++--
 x86/svm_npt.c   |  2 +-
 x86/svm_tests.c | 26 +++++++++++++-------------
 4 files changed, 20 insertions(+), 24 deletions(-)

diff --git a/x86/svm.c b/x86/svm.c
index a3279545..244555d4 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -60,16 +60,11 @@ void inc_test_stage(struct svm_test_context *ctx)
 	barrier();
 }
 
-static test_guest_func guest_main;
-
-void test_set_guest(test_guest_func func)
-{
-	guest_main = func;
-}
 
 static void test_thunk(struct svm_test_context *ctx)
 {
-	guest_main(ctx);
+	if (ctx->guest_func)
+		ctx->guest_func(ctx);
 	vmmcall();
 }
 
@@ -93,6 +88,7 @@ static noinline void test_run(struct svm_test_context *ctx)
 	svm_vcpu_ident(ctx->vcpu);
 
 	if (ctx->test->v2) {
+		ctx->guest_func = NULL;
 		ctx->test->v2(ctx);
 		return;
 	}
@@ -100,7 +96,7 @@ static noinline void test_run(struct svm_test_context *ctx)
 	cli();
 
 	ctx->test->prepare(ctx);
-	guest_main = ctx->test->guest_func;
+	ctx->guest_func = ctx->test->guest_func;
 	ctx->vcpu->vmcb->save.rip = (ulong)test_thunk;
 	ctx->vcpu->regs.rsp = (ulong)(ctx->vcpu->stack);
 	ctx->vcpu->regs.rdi = (ulong)ctx;
diff --git a/x86/svm.h b/x86/svm.h
index ec181715..149b76c4 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -15,6 +15,8 @@ struct svm_test_context {
 
 	/* TODO: test cases currently are single threaded */
 	struct svm_vcpu *vcpu;
+
+	void (*guest_func)(struct svm_test_context *ctx);
 };
 
 struct svm_test {
@@ -44,7 +46,5 @@ void set_test_stage(struct svm_test_context *ctx, int s);
 void inc_test_stage(struct svm_test_context *ctx);
 int __svm_vmrun(struct svm_test_context *ctx, u64 rip);
 int svm_vmrun(struct svm_test_context *ctx);
-void test_set_guest(test_guest_func func);
-
 
 #endif
diff --git a/x86/svm_npt.c b/x86/svm_npt.c
index 39fd7198..1e27f9ef 100644
--- a/x86/svm_npt.c
+++ b/x86/svm_npt.c
@@ -332,7 +332,7 @@ static void svm_npt_rsvd_bits_test(struct svm_test_context *ctx)
 	sg_efer = guest_efer = vmcb->save.efer;
 	sg_cr4 = guest_cr4 = vmcb->save.cr4;
 
-	test_set_guest(basic_guest_main);
+	ctx->guest_func = basic_guest_main;
 
 	/*
 	 * 4k PTEs don't have reserved bits if MAXPHYADDR >= 52, just skip the
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index bd92fcee..6d6dfa0e 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -793,7 +793,7 @@ static void svm_tsc_scale_run_testcase(struct svm_test_context *ctx,
 
 	guest_tsc_delay_value = (duration << TSC_SHIFT) * tsc_scale;
 
-	test_set_guest(svm_tsc_scale_guest);
+	ctx->guest_func = svm_tsc_scale_guest;
 	vmcb->control.tsc_offset = tsc_offset;
 	wrmsr(MSR_AMD64_TSC_RATIO, (u64)(tsc_scale * (1ULL << 32)));
 
@@ -2067,7 +2067,7 @@ static void svm_cr4_osxsave_test(struct svm_test_context *ctx)
 
 	report(this_cpu_has(X86_FEATURE_OSXSAVE), "CPUID.01H:ECX.XSAVE set before VMRUN");
 
-	test_set_guest(svm_cr4_osxsave_test_guest);
+	ctx->guest_func = svm_cr4_osxsave_test_guest;
 	report(svm_vmrun(ctx) == SVM_EXIT_VMMCALL,
 	       "svm_cr4_osxsave_test_guest finished with VMMCALL");
 
@@ -2494,7 +2494,7 @@ static void guest_rflags_test_db_handler(struct ex_regs *r)
 
 static void svm_guest_state_test(struct svm_test_context *ctx)
 {
-	test_set_guest(basic_guest_main);
+	ctx->guest_func = basic_guest_main;
 	test_efer(ctx);
 	test_cr0(ctx);
 	test_cr3(ctx);
@@ -2633,7 +2633,7 @@ static void svm_vmload_vmsave(struct svm_test_context *ctx)
 	struct vmcb *vmcb = ctx->vcpu->vmcb;
 	u32 intercept_saved = vmcb->control.intercept;
 
-	test_set_guest(vmload_vmsave_guest_main);
+	ctx->guest_func = vmload_vmsave_guest_main;
 
 	/*
 	 * Disabling intercept for VMLOAD and VMSAVE doesn't cause
@@ -2777,7 +2777,7 @@ static void pause_filter_run_test(struct svm_test_context *ctx,
 {
 	struct vmcb *vmcb = ctx->vcpu->vmcb;
 
-	test_set_guest(pause_filter_test_guest_main);
+	ctx->guest_func = pause_filter_test_guest_main;
 
 	pause_test_counter = pause_iterations;
 	wait_counter = wait_iterations;
@@ -2832,7 +2832,7 @@ static void svm_no_nm_test(struct svm_test_context *ctx)
 	struct vmcb *vmcb = ctx->vcpu->vmcb;
 
 	write_cr0(read_cr0() & ~X86_CR0_TS);
-	test_set_guest((test_guest_func)fnop);
+	ctx->guest_func = (test_guest_func)fnop;
 
 	vmcb->save.cr0 = vmcb->save.cr0 & ~(X86_CR0_TS | X86_CR0_EM);
 	report(svm_vmrun(ctx) == SVM_EXIT_VMMCALL,
@@ -3149,7 +3149,7 @@ static void svm_intr_intercept_mix_if(struct svm_test_context *ctx)
 	vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
 	vmcb->save.rflags &= ~X86_EFLAGS_IF;
 
-	test_set_guest(svm_intr_intercept_mix_if_guest);
+	ctx->guest_func = svm_intr_intercept_mix_if_guest;
 	cli();
 	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_FIXED | 0x55, 0);
 	svm_intr_intercept_mix_run_guest(ctx, &dummy_isr_recevied, SVM_EXIT_INTR);
@@ -3184,7 +3184,7 @@ static void svm_intr_intercept_mix_gif(struct svm_test_context *ctx)
 	vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
 	vmcb->save.rflags &= ~X86_EFLAGS_IF;
 
-	test_set_guest(svm_intr_intercept_mix_gif_guest);
+	ctx->guest_func = svm_intr_intercept_mix_gif_guest;
 	cli();
 	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_FIXED | 0x55, 0);
 	svm_intr_intercept_mix_run_guest(ctx, &dummy_isr_recevied, SVM_EXIT_INTR);
@@ -3216,7 +3216,7 @@ static void svm_intr_intercept_mix_gif2(struct svm_test_context *ctx)
 	vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
 	vmcb->save.rflags |= X86_EFLAGS_IF;
 
-	test_set_guest(svm_intr_intercept_mix_gif_guest2);
+	ctx->guest_func = svm_intr_intercept_mix_gif_guest2;
 	svm_intr_intercept_mix_run_guest(ctx, &dummy_isr_recevied, SVM_EXIT_INTR);
 }
 
@@ -3247,7 +3247,7 @@ static void svm_intr_intercept_mix_nmi(struct svm_test_context *ctx)
 	vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
 	vmcb->save.rflags |= X86_EFLAGS_IF;
 
-	test_set_guest(svm_intr_intercept_mix_nmi_guest);
+	ctx->guest_func = svm_intr_intercept_mix_nmi_guest;
 	svm_intr_intercept_mix_run_guest(ctx, &nmi_recevied, SVM_EXIT_NMI);
 }
 
@@ -3271,7 +3271,7 @@ static void svm_intr_intercept_mix_smi(struct svm_test_context *ctx)
 
 	vmcb->control.intercept |= (1 << INTERCEPT_SMI);
 	vmcb->control.int_ctl &= ~V_INTR_MASKING_MASK;
-	test_set_guest(svm_intr_intercept_mix_smi_guest);
+	ctx->guest_func = svm_intr_intercept_mix_smi_guest;
 	svm_intr_intercept_mix_run_guest(ctx, NULL, SVM_EXIT_SMI);
 }
 
@@ -3346,7 +3346,7 @@ static void svm_exception_test(struct svm_test_context *ctx)
 
 	for (i = 0; i < ARRAY_SIZE(svm_exception_tests); i++) {
 		t = &svm_exception_tests[i];
-		test_set_guest((test_guest_func)t->guest_code);
+		ctx->guest_func = (test_guest_func)t->guest_code;
 
 		handle_exception_in_l2(ctx, t->vector);
 		svm_vcpu_ident(ctx->vcpu);
@@ -3366,7 +3366,7 @@ static void svm_shutdown_intercept_test(struct svm_test_context *ctx)
 {
 	struct vmcb *vmcb = ctx->vcpu->vmcb;
 
-	test_set_guest(shutdown_intercept_test_guest);
+	ctx->guest_func = shutdown_intercept_test_guest;
 	vmcb->save.idtr.base = (u64)alloc_vpage();
 	vmcb->control.intercept |= (1ULL << INTERCEPT_SHUTDOWN);
 	svm_vmrun(ctx);
-- 
2.34.3

