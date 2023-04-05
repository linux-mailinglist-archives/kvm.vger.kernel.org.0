Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5FD76D8919
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 22:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233393AbjDEUvu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 16:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231880AbjDEUvq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 16:51:46 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02506CD
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 13:51:45 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id q9-20020a170902dac900b001a18ceff5ebso21447969plx.4
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 13:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680727904;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=J32QfDG/N0fnwFvEA1vrkQnMqbl9Zm9NHz5B44dC12w=;
        b=JqSM2Uf3uS1YvgXiVIj2oy/QGwQbyyDIdjrpHy4m+pPHj8xS5hKqddwLtgNKwKE+sL
         35OoLw6gbMR+z0SJ4TVe1WfYdOG4A9lyw0gUXJyKO5TUgll7XKH+PR73u3pB05QgRalL
         EvHSKRfMFZXG4mCZ6jlNY5R3LySDEYUnTx8Jf7CSEM7eWZ6eQc+EKBr1xXYEp8o/B9T4
         fiWA6uO2p9sh30REy8BU2zmj3Trx11Bj7SrPOkcTtvoNxOnCHl4ttXAJHpXxAbvdNZKz
         IL2wgJITuJaY1gT8aK4y3dgv5KT5YWaIHsQOccXBpW0fIris9M3JjuOvmYW9aXXbz0W/
         54wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680727904;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J32QfDG/N0fnwFvEA1vrkQnMqbl9Zm9NHz5B44dC12w=;
        b=tUuiF2B5GG92DrFZPHu5VSaaURkSzraXqo55/zO8TIUSG9VVa8rnp5nAP16tc9+B6K
         cZVm+PoNaK9j3WjuGFr4k1KdIYccCbqhArfHelV50WS620jwqWP80dMGaPquHVXwS6Yq
         30opMPoT2V1yY7K7NbIIqRU61sDYOVjMHUPWUJEDbAeInQDWWwyZcJ+4CnhkHkvsblVY
         k+Y17zNVm8roIdStQwOzCxvuEZmlqEUraJ3j+JVcWZVkz7KAbYQFe5LQugcDRVaMamFE
         jC3ojeRhAHIVErD8csgAj1/xf2XNoUnC0ubPI2JC1ioiyh2Qs3V8rQ61MGOpRtVYbLEd
         2ugQ==
X-Gm-Message-State: AAQBX9dPziadHUiXShCE4GtJuYVIYRNMnI2ILM8jlwX+7vhNU/dXyKi2
        Wz27OanXy7pougj5BjP1GJLL1onRg2A=
X-Google-Smtp-Source: AKy350aSsK50Bqzap+Oy2/ML7KTFfpyvAFLLp63Br5yy7o833tWCfftkyahxr47DLlvDH73adsg/OeaSDIc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:2f23:b0:23f:6efa:bd55 with SMTP id
 s32-20020a17090a2f2300b0023f6efabd55mr2792288pjd.8.1680727904539; Wed, 05 Apr
 2023 13:51:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  5 Apr 2023 13:51:38 -0700
In-Reply-To: <20230405205138.525310-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230405205138.525310-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230405205138.525310-3-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v4 2/2] x86: nSVM: Add support for VNMI test
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

From: Santosh Shukla <santosh.shukla@amd.com>

Add a VNMI test case to test Virtual NMI in a nested environment,
The test covers the Virtual NMI (VNMI) delivery.

Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
[sean: reuse pieces of NMI test framework, fix formatting issues]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/processor.h |  1 +
 x86/svm.c           |  5 +++
 x86/svm.h           |  8 +++++
 x86/svm_tests.c     | 78 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 92 insertions(+)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 3d58ef72..3802c1e2 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -267,6 +267,7 @@ static inline bool is_intel(void)
 #define X86_FEATURE_PAUSEFILTER		(CPUID(0x8000000A, 0, EDX, 10))
 #define X86_FEATURE_PFTHRESHOLD		(CPUID(0x8000000A, 0, EDX, 12))
 #define	X86_FEATURE_VGIF		(CPUID(0x8000000A, 0, EDX, 16))
+#define X86_FEATURE_V_NMI               (CPUID(0x8000000A, 0, EDX, 25))
 #define	X86_FEATURE_AMD_PMU_V2		(CPUID(0x80000022, 0, EAX, 0))
 
 static inline bool this_cpu_has(u64 feature)
diff --git a/x86/svm.c b/x86/svm.c
index ba435b4a..022a0fde 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -99,6 +99,11 @@ bool npt_supported(void)
 	return this_cpu_has(X86_FEATURE_NPT);
 }
 
+bool vnmi_supported(void)
+{
+       return this_cpu_has(X86_FEATURE_V_NMI);
+}
+
 int get_test_stage(struct svm_test *test)
 {
 	barrier();
diff --git a/x86/svm.h b/x86/svm.h
index 766ff7e3..4631c2ff 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -131,6 +131,13 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define V_INTR_MASKING_SHIFT 24
 #define V_INTR_MASKING_MASK (1 << V_INTR_MASKING_SHIFT)
 
+#define V_NMI_PENDING_SHIFT	11
+#define V_NMI_PENDING_MASK	(1 << V_NMI_PENDING_SHIFT)
+#define V_NMI_BLOCKING_SHIFT	12
+#define V_NMI_BLOCKING_MASK	(1 << V_NMI_BLOCKING_SHIFT)
+#define V_NMI_ENABLE_SHIFT	26
+#define V_NMI_ENABLE_MASK	(1 << V_NMI_ENABLE_SHIFT)
+
 #define SVM_INTERRUPT_SHADOW_MASK 1
 
 #define SVM_IOIO_STR_SHIFT 2
@@ -419,6 +426,7 @@ void default_prepare(struct svm_test *test);
 void default_prepare_gif_clear(struct svm_test *test);
 bool default_finished(struct svm_test *test);
 bool npt_supported(void);
+bool vnmi_supported(void);
 int get_test_stage(struct svm_test *test);
 void set_test_stage(struct svm_test *test, int s);
 void inc_test_stage(struct svm_test *test);
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index e87db3fa..3d2ca0f6 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1419,6 +1419,81 @@ static bool nmi_hlt_check(struct svm_test *test)
 	return get_test_stage(test) == 3;
 }
 
+static void vnmi_prepare(struct svm_test *test)
+{
+	nmi_prepare(test);
+
+	/*
+	 * Disable NMI interception to start.  Enabling vNMI without
+	 * intercepting "real" NMIs should result in an ERR VM-Exit.
+	 */
+	vmcb->control.intercept &= ~(1ULL << INTERCEPT_NMI);
+	vmcb->control.int_ctl = V_NMI_ENABLE_MASK;
+	vmcb->control.int_vector = NMI_VECTOR;
+}
+
+static void vnmi_test(struct svm_test *test)
+{
+	report_svm_guest(!nmi_fired, test, "No vNMI before injection");
+	vmmcall();
+
+	report_svm_guest(nmi_fired, test, "vNMI delivered after injection");
+	vmmcall();
+}
+
+static bool vnmi_finished(struct svm_test *test)
+{
+	switch (get_test_stage(test)) {
+	case 0:
+		if (vmcb->control.exit_code != SVM_EXIT_ERR) {
+			report_fail("Wanted ERR VM-Exit, got 0x%x",
+				    vmcb->control.exit_code);
+			return true;
+		}
+		report(!nmi_fired, "vNMI enabled but NMI_INTERCEPT unset!");
+		vmcb->control.intercept |= (1ULL << INTERCEPT_NMI);
+		vmcb->save.rip += 3;
+		break;
+
+	case 1:
+		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+			report_fail("Wanted VMMCALL VM-Exit, got 0x%x",
+				    vmcb->control.exit_code);
+			return true;
+		}
+		report(!nmi_fired, "vNMI with vector 2 not injected");
+		vmcb->control.int_ctl |= V_NMI_PENDING_MASK;
+		vmcb->save.rip += 3;
+		break;
+
+	case 2:
+		if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+			report_fail("Wanted VMMCALL VM-Exit, got 0x%x",
+				    vmcb->control.exit_code);
+			return true;
+		}
+		if (vmcb->control.int_ctl & V_NMI_BLOCKING_MASK) {
+			report_fail("V_NMI_BLOCKING_MASK not cleared on VMEXIT");
+			return true;
+		}
+		report_pass("VNMI serviced");
+		vmcb->save.rip += 3;
+		break;
+
+	default:
+		return true;
+	}
+
+	inc_test_stage(test);
+
+	return get_test_stage(test) == 3;
+}
+
+static bool vnmi_check(struct svm_test *test)
+{
+	return get_test_stage(test) == 3;
+}
+
 static volatile int count_exc = 0;
 
 static void my_isr(struct ex_regs *r)
@@ -3298,6 +3373,9 @@ struct svm_test svm_tests[] = {
 	{ "nmi_hlt", smp_supported, nmi_prepare,
 	  default_prepare_gif_clear, nmi_hlt_test,
 	  nmi_hlt_finished, nmi_hlt_check },
+        { "vnmi", vnmi_supported, vnmi_prepare,
+          default_prepare_gif_clear, vnmi_test,
+          vnmi_finished, vnmi_check },
 	{ "virq_inject", default_supported, virq_inject_prepare,
 	  default_prepare_gif_clear, virq_inject_test,
 	  virq_inject_finished, virq_inject_check },
-- 
2.40.0.348.gf938b09366-goog

