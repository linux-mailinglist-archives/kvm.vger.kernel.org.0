Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABD796D8918
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 22:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232888AbjDEUvs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 16:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbjDEUvo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 16:51:44 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E6F3185
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 13:51:43 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id k1-20020a170902c40100b001a20f75cd40so21936231plk.22
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 13:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680727902;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=yIZS+lESLjc2SVQMvqfoiClSoxP1FKlhXwqqrQtmCCw=;
        b=d7Qr3XQ8kYtcWqKNu75D003g7obqdDBf1X6q54wAFdogWsnqKpjMzx8Yt37jt2k8lt
         Ly6fh4+8qL/rdU+iGz+bh7wUZYHDttno67iGquBSomvs65C0t42WHLyJWe8yo6XimMyw
         jB9EysiXCbqv6XwP9QnEaLv6lSuiyeWEI14z217PRUxvILQRjTr03ImiuW+BM6OHpz1N
         Dv0zA2OTphJ5EqrI6vQoKRxHxl11YZN0o0bMejfFOn35QZc9CgLUfLj18l616SWhRF3F
         Mh4PxXv3xpBQctz1tmHUh/jjbdU/Bsk18bSyIAorrFokcBy8MkLWxWyo0orrElTtNxf5
         TpJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680727902;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yIZS+lESLjc2SVQMvqfoiClSoxP1FKlhXwqqrQtmCCw=;
        b=jPw9la9hWcwFPyyOvj16M0sSbDDSy4bffUWUD624W1XB7ktX1TkNWatlY5d/0CvAzE
         EcSwqWi/A6yS3ZJ5rXhZ6KtpWW7rFqQ2OuFJo217aPAA57BJCXLZlkA10Gmh8arn0U92
         cejSrY4aAxWnasEAOr9EFBYSeOXHqeIcnr4TO5YODGY9lfKtMeXSRKms2RbSeZKh4AEt
         pv3wjxy8q24uXx7c6VYhYYdlWvYBHV4CKpnDLkj8ge/HPiLhvZZjRyCFn67JqSVH+q+q
         SU1PGcJ1uWUuGoR/EVO4V2U1FgMCf16CdLUrHnKohHLPY0fZAE4w4mOvKIdMDA2BUpGp
         kI4g==
X-Gm-Message-State: AAQBX9drefe80Q6D36MM5v3gEWOkoC04GfzTjzPcckbllmD1ZXTA6GrZ
        HPDIaClwq+KHN808J7bfSjS+7v9oJ4Q=
X-Google-Smtp-Source: AKy350bmwnKQReX4GjZhoe5cW/ok+K99zU9OHOi3pYgv7QOUBvQ87IIRPHyXXL8UDl23aop3TIBseBBawX0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:82cb:b0:1a0:7630:8ef1 with SMTP id
 u11-20020a17090282cb00b001a076308ef1mr3176042plz.11.1680727902718; Wed, 05
 Apr 2023 13:51:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  5 Apr 2023 13:51:37 -0700
In-Reply-To: <20230405205138.525310-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230405205138.525310-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230405205138.525310-2-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v4 1/2] nSVM: Add helper to report fatal errors
 in guest
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Santosh Shukla <santosh.shukla@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a helper macro to dedup nSVM test code that handles fatal errors
by reporting the failure, setting the test stage to a magic number, and
invoking VMMCALL to bail to the host and terminate.

Note, the V_TPR fails if report() is invoked.  Punt on the issue for
now as most users already report only failures, but leave a TODO for
future developers.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/svm_tests.c | 127 ++++++++++++++++--------------------------------
 1 file changed, 42 insertions(+), 85 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 27ce47b4..e87db3fa 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -947,6 +947,21 @@ static bool lat_svm_insn_check(struct svm_test *test)
 	return true;
 }
 
+/*
+ * Report failures from SVM guest code, and on failure, set the stage to -1 and
+ * do VMMCALL to terminate the test (host side must treat -1 as "finished").
+ * TODO: fix the tests that don't play nice with a straight report, e.g. the
+ * V_TPR test fails if report() is invoked.
+ */
+#define report_svm_guest(cond, test, fmt, args...)	\
+do {							\
+	if (!(cond)) {					\
+		report_fail("why didn't my format '" fmt "' format?", ##args);\
+		set_test_stage(test, -1);		\
+		vmmcall();				\
+	}						\
+} while (0)
+
 bool pending_event_ipi_fired;
 bool pending_event_guest_run;
 
@@ -1049,22 +1064,16 @@ static void pending_event_cli_prepare_gif_clear(struct svm_test *test)
 
 static void pending_event_cli_test(struct svm_test *test)
 {
-	if (pending_event_ipi_fired == true) {
-		set_test_stage(test, -1);
-		report_fail("Interrupt preceeded guest");
-		vmmcall();
-	}
+	report_svm_guest(!pending_event_ipi_fired, test,
+			 "IRQ should NOT be delivered while IRQs disabled");
 
 	/* VINTR_MASKING is zero.  This should cause the IPI to fire.  */
 	irq_enable();
 	asm volatile ("nop");
 	irq_disable();
 
-	if (pending_event_ipi_fired != true) {
-		set_test_stage(test, -1);
-		report_fail("Interrupt not triggered by guest");
-	}
-
+	report_svm_guest(pending_event_ipi_fired, test,
+			 "IRQ should be delivered after enabling IRQs");
 	vmmcall();
 
 	/*
@@ -1079,11 +1088,9 @@ static void pending_event_cli_test(struct svm_test *test)
 
 static bool pending_event_cli_finished(struct svm_test *test)
 {
-	if ( vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
-		report_fail("VM_EXIT return to host is not EXIT_VMMCALL exit reason 0x%x",
-			    vmcb->control.exit_code);
-		return true;
-	}
+	report_svm_guest(vmcb->control.exit_code == SVM_EXIT_VMMCALL, test,
+			 "Wanted VMMCALL VM-Exit, got ext reason 0x%x",
+			 vmcb->control.exit_code);
 
 	switch (get_test_stage(test)) {
 	case 0:
@@ -1158,12 +1165,8 @@ static void interrupt_test(struct svm_test *test)
 	for (loops = 0; loops < 10000000 && !timer_fired; loops++)
 		asm volatile ("nop");
 
-	report(timer_fired, "direct interrupt while running guest");
-
-	if (!timer_fired) {
-		set_test_stage(test, -1);
-		vmmcall();
-	}
+	report_svm_guest(timer_fired, test,
+			 "direct interrupt while running guest");
 
 	apic_write(APIC_TMICT, 0);
 	irq_disable();
@@ -1174,12 +1177,8 @@ static void interrupt_test(struct svm_test *test)
 	for (loops = 0; loops < 10000000 && !timer_fired; loops++)
 		asm volatile ("nop");
 
-	report(timer_fired, "intercepted interrupt while running guest");
-
-	if (!timer_fired) {
-		set_test_stage(test, -1);
-		vmmcall();
-	}
+	report_svm_guest(timer_fired, test,
+			 "intercepted interrupt while running guest");
 
 	irq_enable();
 	apic_write(APIC_TMICT, 0);
@@ -1190,13 +1189,8 @@ static void interrupt_test(struct svm_test *test)
 	apic_write(APIC_TMICT, 1000000);
 	safe_halt();
 
-	report(rdtsc() - start > 10000 && timer_fired,
-	       "direct interrupt + hlt");
-
-	if (!timer_fired) {
-		set_test_stage(test, -1);
-		vmmcall();
-	}
+	report_svm_guest(timer_fired, test, "direct interrupt + hlt");
+	report(rdtsc() - start > 10000, "IRQ arrived after expected delay");
 
 	apic_write(APIC_TMICT, 0);
 	irq_disable();
@@ -1207,13 +1201,8 @@ static void interrupt_test(struct svm_test *test)
 	apic_write(APIC_TMICT, 1000000);
 	asm volatile ("hlt");
 
-	report(rdtsc() - start > 10000 && timer_fired,
-	       "intercepted interrupt + hlt");
-
-	if (!timer_fired) {
-		set_test_stage(test, -1);
-		vmmcall();
-	}
+	report_svm_guest(timer_fired, test, "intercepted interrupt + hlt");
+	report(rdtsc() - start > 10000, "IRQ arrived after expected delay");
 
 	apic_write(APIC_TMICT, 0);
 	irq_disable();
@@ -1287,10 +1276,7 @@ static void nmi_test(struct svm_test *test)
 {
 	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_NMI | APIC_INT_ASSERT, 0);
 
-	report(nmi_fired, "direct NMI while running guest");
-
-	if (!nmi_fired)
-		set_test_stage(test, -1);
+	report_svm_guest(nmi_fired, test, "direct NMI while running guest");
 
 	vmmcall();
 
@@ -1298,11 +1284,7 @@ static void nmi_test(struct svm_test *test)
 
 	apic_icr_write(APIC_DEST_SELF | APIC_DEST_PHYSICAL | APIC_DM_NMI | APIC_INT_ASSERT, 0);
 
-	if (!nmi_fired) {
-		report(nmi_fired, "intercepted pending NMI not dispatched");
-		set_test_stage(test, -1);
-	}
-
+	report_svm_guest(nmi_fired, test, "intercepted pending NMI delivered to guest");
 }
 
 static bool nmi_finished(struct svm_test *test)
@@ -1379,11 +1361,8 @@ static void nmi_hlt_test(struct svm_test *test)
 
 	asm volatile ("hlt");
 
-	report((rdtsc() - start > NMI_DELAY) && nmi_fired,
-	       "direct NMI + hlt");
-
-	if (!nmi_fired)
-		set_test_stage(test, -1);
+	report_svm_guest(nmi_fired, test, "direct NMI + hlt");
+	report(rdtsc() - start > NMI_DELAY, "direct NMI after expected delay");
 
 	nmi_fired = false;
 
@@ -1395,14 +1374,8 @@ static void nmi_hlt_test(struct svm_test *test)
 
 	asm volatile ("hlt");
 
-	report((rdtsc() - start > NMI_DELAY) && nmi_fired,
-	       "intercepted NMI + hlt");
-
-	if (!nmi_fired) {
-		report(nmi_fired, "intercepted pending NMI not dispatched");
-		set_test_stage(test, -1);
-		vmmcall();
-	}
+	report_svm_guest(nmi_fired, test, "intercepted NMI + hlt");
+	report(rdtsc() - start > NMI_DELAY, "intercepted NMI after expected delay");
 
 	set_test_stage(test, 3);
 }
@@ -1534,37 +1507,23 @@ static void virq_inject_prepare(struct svm_test *test)
 
 static void virq_inject_test(struct svm_test *test)
 {
-	if (virq_fired) {
-		report_fail("virtual interrupt fired before L2 sti");
-		set_test_stage(test, -1);
-		vmmcall();
-	}
+	report_svm_guest(!virq_fired, test, "virtual IRQ blocked after L2 cli");
 
 	irq_enable();
 	asm volatile ("nop");
 	irq_disable();
 
-	if (!virq_fired) {
-		report_fail("virtual interrupt not fired after L2 sti");
-		set_test_stage(test, -1);
-	}
+	report_svm_guest(virq_fired, test, "virtual IRQ fired after L2 sti");
 
 	vmmcall();
 
-	if (virq_fired) {
-		report_fail("virtual interrupt fired before L2 sti after VINTR intercept");
-		set_test_stage(test, -1);
-		vmmcall();
-	}
+	report_svm_guest(!virq_fired, test, "intercepted VINTR blocked after L2 cli");
 
 	irq_enable();
 	asm volatile ("nop");
 	irq_disable();
 
-	if (!virq_fired) {
-		report_fail("virtual interrupt not fired after return from VINTR intercept");
-		set_test_stage(test, -1);
-	}
+	report_svm_guest(virq_fired, test, "intercepted VINTR fired after L2 sti");
 
 	vmmcall();
 
@@ -1572,10 +1531,8 @@ static void virq_inject_test(struct svm_test *test)
 	asm volatile ("nop");
 	irq_disable();
 
-	if (virq_fired) {
-		report_fail("virtual interrupt fired when V_IRQ_PRIO less than V_TPR");
-		set_test_stage(test, -1);
-	}
+	report_svm_guest(!virq_fired, test,
+			  "virtual IRQ blocked V_IRQ_PRIO less than V_TPR");
 
 	vmmcall();
 	vmmcall();
-- 
2.40.0.348.gf938b09366-goog

