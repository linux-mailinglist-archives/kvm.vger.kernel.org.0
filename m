Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1EC4D590C
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 04:30:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346053AbiCKDaq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 22:30:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346221AbiCKDaT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 22:30:19 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB03F70CA
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 19:28:41 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id s12-20020a17090a13cc00b001bee1e1677fso4544260pjf.0
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 19:28:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=cAMiTqYYBxmgWCvoOynsSSin6TLDW3p525uMTOd0VH4=;
        b=VHKnyEdv0xqSYSYlQ1Jpb+d13Q/A5BI5XvyKytQp2L2NbjeENyt/+F1YVQHUDyHgHZ
         ohMxnP27BZFYsu9rqYkwhx+TgfmaMvAJNiPCXislAg/hqLPO++xYvfkcYogitlnKiSf+
         YyFdiJVvWcmczYkJethvxoB4Fj2kJjAzmYo8G02o2NbEs+momn5e/82fIKnsC6Kg2MgM
         m0mgDTQn6HAKc5gHyz36WNVOhW2flLrpAZzmYCTwKOPJJpu9JaZgwKFQGHoEB251UI3/
         2dfoEs6wWXenu+bIOBM5bfghkoqHzyRslRH5Nak2yVsXBYXetG8tpt+IcIjwTp/xQngN
         Q4Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=cAMiTqYYBxmgWCvoOynsSSin6TLDW3p525uMTOd0VH4=;
        b=wnOu7KVJy8Z9eagcGctuyLT/bMm3UOZtBuRHQUiFdqxuzTMm4ovoD019XuetB9i3qb
         mC/1xqi9b/cCvHO7+UCXne7FDbfisV+9sU7bsNYwDEszYubROcY+I/oFEIbrvPGU+h7w
         EcYKcZiLacJDXKu0V10nPVvQuM2sH9mDPCLlf+4CVsZCLP1cFi4hUQEKZ2KQ6ZoyRWZ8
         mUuyw9sJDmeeDd6yc+vswKBcOI1xAE+9fn/o4C2udiMKl6G2tW6wUWmozkYppeG4afCk
         A9Yoh5jZULbQe+7eMgjDgYQuZkJkjsE75S13/qgQJ3PRAhWgpeRgMWLOf60IG/qYIzNB
         uf8g==
X-Gm-Message-State: AOAM5325Dm8Xbp3q0Pi+05PDfSpzt1joKYUJJYvXEuzhin9WolBz9WAq
        FjKCWP9RPTZS8RTOOXnY1chCML0/KhY=
X-Google-Smtp-Source: ABdhPJz5lEznNR2iDFQv1PAPPDs7P230i9UA7M1toCuScPyaIApPuBC+gsciPzrqruDrJXtqX52qwfSlWAU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1e10:b0:1bf:6c78:54a9 with SMTP id
 pg16-20020a17090b1e1000b001bf6c7854a9mr403463pjb.1.1646969320203; Thu, 10 Mar
 2022 19:28:40 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 11 Mar 2022 03:28:01 +0000
In-Reply-To: <20220311032801.3467418-1-seanjc@google.com>
Message-Id: <20220311032801.3467418-22-seanjc@google.com>
Mime-Version: 1.0
References: <20220311032801.3467418-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH 21/21] KVM: selftests: Add an x86-only test to verify nested
 exception queueing
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
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

Add a test to verify that KVM_{G,S}ET_EVENTS play nice with pending vs.
injected exceptions when an exception is being queued for L2, and that
KVM correctly handles L1's exception intercept wants.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/x86_64/nested_exceptions_test.c       | 307 ++++++++++++++++++
 3 files changed, 309 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/nested_exceptions_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 9b67343dc4ab..c8b8203ca867 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -23,6 +23,7 @@
 /x86_64/hyperv_features
 /x86_64/mmio_warning_test
 /x86_64/mmu_role_test
+/x86_64/nested_exceptions_test
 /x86_64/platform_info_test
 /x86_64/pmu_event_filter_test
 /x86_64/set_boot_cpu_id
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 04099f453b59..5679d1a79a83 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -56,6 +56,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/kvm_clock_test
 TEST_GEN_PROGS_x86_64 += x86_64/kvm_pv_test
 TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
 TEST_GEN_PROGS_x86_64 += x86_64/mmu_role_test
+TEST_GEN_PROGS_x86_64 += x86_64/nested_exceptions_test
 TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
 TEST_GEN_PROGS_x86_64 += x86_64/pmu_event_filter_test
 TEST_GEN_PROGS_x86_64 += x86_64/set_boot_cpu_id
diff --git a/tools/testing/selftests/kvm/x86_64/nested_exceptions_test.c b/tools/testing/selftests/kvm/x86_64/nested_exceptions_test.c
new file mode 100644
index 000000000000..1a2b2010e8f3
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/nested_exceptions_test.c
@@ -0,0 +1,307 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#define _GNU_SOURCE /* for program_invocation_short_name */
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+#include "vmx.h"
+#include "svm_util.h"
+
+#define VCPU_ID	0
+#define L2_GUEST_STACK_SIZE 256
+
+/*
+ * Arbitrary, never shoved into KVM/hardware, just need to avoid conflict with
+ * the "real" exceptions used, #SS/#GP/#DF (12/13/8).
+ */
+#define FAKE_TRIPLE_FAULT_VECTOR	0xaa
+
+/* Arbitrary 32-bit error code injected by this test. */
+#define SS_ERROR_CODE 0xdeadbeef
+
+/*
+ * Bit '0' is set on Intel if the exception occurs while delivering a previous
+ * event/exception.  AMD's wording is ambiguous, but presumably the bit is set
+ * if the exception occurs while delivering an external event, e.g. NMI or INTR,
+ * but not for exceptions that occur when delivering other exceptions or
+ * software interrupts.
+ *
+ * Note, Intel's name for it, "External event", is misleading and much more
+ * aligned with AMD's behavior, but the SDM is quite clear on its behavior.
+ */
+#define ERROR_CODE_EXT_FLAG	BIT(0)
+
+/*
+ * Bit '1' is set if the fault occurred when looking up a descriptor in the
+ * IDT, which is the case here as the IDT is empty/NULL.
+ */
+#define ERROR_CODE_IDT_FLAG	BIT(1)
+
+/*
+ * The #GP that occurs when vectoring #SS should show the index into the IDT
+ * for #SS, plus have the "IDT flag" set.
+ */
+#define GP_ERROR_CODE_AMD ((SS_VECTOR * 8) | ERROR_CODE_IDT_FLAG)
+#define GP_ERROR_CODE_INTEL ((SS_VECTOR * 8) | ERROR_CODE_IDT_FLAG | ERROR_CODE_EXT_FLAG)
+
+/*
+ * Intel and AMD both shove '0' into the error code on #DF, regardless of what
+ * led to the double fault.
+ */
+#define DF_ERROR_CODE 0
+
+#define INTERCEPT_SS		(BIT_ULL(SS_VECTOR))
+#define INTERCEPT_SS_DF		(INTERCEPT_SS | BIT_ULL(DF_VECTOR))
+#define INTERCEPT_SS_GP_DF	(INTERCEPT_SS_DF | BIT_ULL(GP_VECTOR))
+
+static void l2_ss_pending_test(void)
+{
+	GUEST_SYNC(SS_VECTOR);
+}
+
+static void l2_ss_injected_gp_test(void)
+{
+	GUEST_SYNC(GP_VECTOR);
+}
+
+static void l2_ss_injected_df_test(void)
+{
+	GUEST_SYNC(DF_VECTOR);
+}
+
+static void l2_ss_injected_tf_test(void)
+{
+	GUEST_SYNC(FAKE_TRIPLE_FAULT_VECTOR);
+}
+
+static void svm_run_l2(struct svm_test_data *svm, void *l2_code, int vector,
+		       uint32_t error_code)
+{
+	struct vmcb *vmcb = svm->vmcb;
+	struct vmcb_control_area *ctrl = &vmcb->control;
+
+	vmcb->save.rip = (u64)l2_code;
+	run_guest(vmcb, svm->vmcb_gpa);
+
+	if (vector == FAKE_TRIPLE_FAULT_VECTOR)
+		return;
+
+	GUEST_ASSERT_EQ(ctrl->exit_code, (SVM_EXIT_EXCP_BASE + vector));
+	GUEST_ASSERT_EQ(ctrl->exit_info_1, error_code);
+}
+
+static void l1_svm_code(struct svm_test_data *svm)
+{
+	struct vmcb_control_area *ctrl = &svm->vmcb->control;
+	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+
+	generic_svm_setup(svm, NULL, &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+	svm->vmcb->save.idtr.limit = 0;
+	ctrl->intercept |= BIT_ULL(INTERCEPT_SHUTDOWN);
+
+	ctrl->intercept_exceptions = INTERCEPT_SS_GP_DF;
+	svm_run_l2(svm, l2_ss_pending_test, SS_VECTOR, SS_ERROR_CODE);
+	svm_run_l2(svm, l2_ss_injected_gp_test, GP_VECTOR, GP_ERROR_CODE_AMD);
+
+	ctrl->intercept_exceptions = INTERCEPT_SS_DF;
+	svm_run_l2(svm, l2_ss_injected_df_test, DF_VECTOR, DF_ERROR_CODE);
+
+	ctrl->intercept_exceptions = INTERCEPT_SS;
+	svm_run_l2(svm, l2_ss_injected_tf_test, FAKE_TRIPLE_FAULT_VECTOR, 0);
+	GUEST_ASSERT_EQ(ctrl->exit_code, SVM_EXIT_SHUTDOWN);
+
+	GUEST_DONE();
+}
+
+static void vmx_run_l2(void *l2_code, int vector, uint32_t error_code)
+{
+	GUEST_ASSERT(!vmwrite(GUEST_RIP, (u64)l2_code));
+
+	GUEST_ASSERT_EQ(vector == SS_VECTOR ? vmlaunch() : vmresume(), 0);
+
+	if (vector == FAKE_TRIPLE_FAULT_VECTOR)
+		return;
+
+	GUEST_ASSERT_EQ(vmreadz(VM_EXIT_REASON), EXIT_REASON_EXCEPTION_NMI);
+	GUEST_ASSERT_EQ((vmreadz(VM_EXIT_INTR_INFO) & 0xff), vector);
+	GUEST_ASSERT_EQ(vmreadz(VM_EXIT_INTR_ERROR_CODE), error_code);
+}
+
+static void l1_vmx_code(struct vmx_pages *vmx)
+{
+	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+
+	GUEST_ASSERT_EQ(prepare_for_vmx_operation(vmx), true);
+
+	GUEST_ASSERT_EQ(load_vmcs(vmx), true);
+
+	prepare_vmcs(vmx, NULL, &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+	GUEST_ASSERT_EQ(vmwrite(GUEST_IDTR_LIMIT, 0), 0);
+
+	/*
+	 * VMX disallows injecting an exception with error_code[31:16] != 0,
+	 * and hardware will never generate a VM-Exit with bits 31:16 set.
+	 * KVM should likewise truncate the "bad" userspace value.
+	 */
+	GUEST_ASSERT_EQ(vmwrite(EXCEPTION_BITMAP, INTERCEPT_SS_GP_DF), 0);
+	vmx_run_l2(l2_ss_pending_test, SS_VECTOR, (u16)SS_ERROR_CODE);
+	vmx_run_l2(l2_ss_injected_gp_test, GP_VECTOR, GP_ERROR_CODE_INTEL);
+
+	GUEST_ASSERT_EQ(vmwrite(EXCEPTION_BITMAP, INTERCEPT_SS_DF), 0);
+	vmx_run_l2(l2_ss_injected_df_test, DF_VECTOR, DF_ERROR_CODE);
+
+	GUEST_ASSERT_EQ(vmwrite(EXCEPTION_BITMAP, INTERCEPT_SS), 0);
+	vmx_run_l2(l2_ss_injected_tf_test, FAKE_TRIPLE_FAULT_VECTOR, 0);
+	GUEST_ASSERT_EQ(vmreadz(VM_EXIT_REASON), EXIT_REASON_TRIPLE_FAULT);
+
+	GUEST_DONE();
+}
+
+static void __attribute__((__flatten__)) l1_guest_code(void *test_data)
+{
+	if (cpu_has_svm())
+		l1_svm_code(test_data);
+	else
+		l1_vmx_code(test_data);
+}
+
+static void assert_ucall_vector(struct kvm_vm *vm, int vector)
+{
+	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
+	struct ucall uc;
+
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+		    "Unexpected exit reason: %u (%s),\n",
+		    run->exit_reason, exit_reason_str(run->exit_reason));
+
+	switch (get_ucall(vm, VCPU_ID, &uc)) {
+	case UCALL_SYNC:
+		TEST_ASSERT(vector == uc.args[1],
+			    "Expected L2 to ask for %d, got %ld", vector, uc.args[1]);
+		break;
+	case UCALL_DONE:
+		TEST_ASSERT(vector == -1,
+			    "Expected L2 to ask for %d, L2 says it's done", vector);
+		break;
+	case UCALL_ABORT:
+		TEST_FAIL("%s at %s:%ld (0x%lx != 0x%lx)",
+			  (const char *)uc.args[0], __FILE__, uc.args[1],
+			  uc.args[2], uc.args[3]);
+		break;
+	default:
+		TEST_FAIL("Expected L2 to ask for %d, got unexpected ucall %lu", vector, uc.cmd);
+	}
+}
+
+static void queue_ss_exception(struct kvm_vm *vm, bool inject)
+{
+	struct kvm_vcpu_events events;
+
+	vcpu_events_get(vm, VCPU_ID, &events);
+
+	TEST_ASSERT(!events.exception.pending,
+		    "Vector %d unexpectedlt pending", events.exception.nr);
+	TEST_ASSERT(!events.exception.injected,
+		    "Vector %d unexpectedly injected", events.exception.nr);
+
+	events.flags = KVM_VCPUEVENT_VALID_PAYLOAD;
+	events.exception.pending = !inject;
+	events.exception.injected = inject;
+	events.exception.nr = SS_VECTOR;
+	events.exception.has_error_code = true;
+	events.exception.error_code = SS_ERROR_CODE;
+	vcpu_events_set(vm, VCPU_ID, &events);
+}
+
+/*
+ * Verify KVM_{G,S}ET_EVENTS play nice with pending vs. injected exceptions
+ * when an exception is being queued for L2.  Specifically, verify that KVM
+ * honors L1 exception intercept controls when a #SS is pending/injected,
+ * triggers a #GP on vectoring the #SS, morphs to #DF if #GP isn't intercepted
+ * by L1, and finally causes (nested) SHUTDOWN if #DF isn't intercepted by L1.
+ */
+int main(int argc, char *argv[])
+{
+	struct kvm_enable_cap cap_exception_payload = {
+		.cap = KVM_CAP_EXCEPTION_PAYLOAD,
+		.args[0] = -2ul,
+	};
+	vm_vaddr_t nested_test_data_gva;
+	struct kvm_vcpu_events events;
+	struct kvm_run *run;
+	struct kvm_vm *vm;
+
+	if (!kvm_check_cap(KVM_CAP_EXCEPTION_PAYLOAD)) {
+		pr_info("KVM_CAP_EXCEPTION_PAYLOAD not supported, skipping\n");
+		exit(KSFT_SKIP);
+	}
+
+	vm = vm_create_default(VCPU_ID, 0, l1_guest_code);
+	vm_enable_cap(vm, &cap_exception_payload);
+
+	if (nested_svm_supported()) {
+		vcpu_alloc_svm(vm, &nested_test_data_gva);
+	} else if (nested_vmx_supported()) {
+		vcpu_alloc_vmx(vm, &nested_test_data_gva);
+	} else {
+		pr_info("Nested virtualization not supported, skipping\n");
+		exit(KSFT_SKIP);
+	}
+
+	vcpu_args_set(vm, VCPU_ID, 1, nested_test_data_gva);
+	run = vcpu_state(vm, VCPU_ID);
+
+	/* Run L1 => L2.  L2 should sync and request #SS. */
+	vcpu_run(vm, VCPU_ID);
+	assert_ucall_vector(vm, SS_VECTOR);
+
+	/* Pend #SS and request immediate exit.  #SS should still be pending. */
+	queue_ss_exception(vm, false);
+	run->immediate_exit = true;
+	vcpu_run_complete_io(vm, VCPU_ID);
+
+	/* Verify the pending events comes back out the same as it went in. */
+	vcpu_events_get(vm, VCPU_ID, &events);
+	ASSERT_EQ(events.flags & KVM_VCPUEVENT_VALID_PAYLOAD,
+		  KVM_VCPUEVENT_VALID_PAYLOAD);
+	ASSERT_EQ(events.exception.pending, true);
+	ASSERT_EQ(events.exception.nr, SS_VECTOR);
+	ASSERT_EQ(events.exception.has_error_code, true);
+	ASSERT_EQ(events.exception.error_code, SS_ERROR_CODE);
+
+	/*
+	 * Run for real with the pending #SS, L1 should get a VM-Exit due to
+	 * #SS interception and re-enter L2 to request #GP (via injected #SS).
+	 */
+	run->immediate_exit = false;
+	vcpu_run(vm, VCPU_ID);
+	assert_ucall_vector(vm, GP_VECTOR);
+
+	/*
+	 * Inject #SS, the #SS should bypass interception and cause #GP, which
+	 * L1 should intercept before KVM morphs it to #DF.  L1 should then
+	 * disable #GP interception and run L2 to request #DF (via #SS => #GP).
+	 */
+	queue_ss_exception(vm, true);
+	vcpu_run(vm, VCPU_ID);
+	assert_ucall_vector(vm, DF_VECTOR);
+
+	/*
+	 * Inject #SS, the #SS should bypass interception and cause #GP, which
+	 * L1 is no longer interception, and so should see a #DF VM-Exit.  L1
+	 * should then signal that is done.
+	 */
+	queue_ss_exception(vm, true);
+	vcpu_run(vm, VCPU_ID);
+	assert_ucall_vector(vm, FAKE_TRIPLE_FAULT_VECTOR);
+
+	/*
+	 * Inject #SS yet again.  L1 is not intercepting #GP or #DF, and so
+	 * should see nested TRIPLE_FAULT / SHUTDOWN.
+	 */
+	queue_ss_exception(vm, true);
+	vcpu_run(vm, VCPU_ID);
+	assert_ucall_vector(vm, -1);
+
+	kvm_vm_free(vm);
+}
-- 
2.35.1.723.g4982287a31-goog

