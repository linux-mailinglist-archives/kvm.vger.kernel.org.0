Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCBB354BC3B
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358513AbiFNUtz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358362AbiFNUs7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:48:59 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C02E54D69F
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:48:22 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id u6-20020a63d346000000b00407d7652203so3568525pgi.18
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=HVrWphNJm9ODVqQWlSo7gw++y6zZnMkQugM6MxdMyIo=;
        b=n+7P2v7NKs8n+8JRX3W3Dia0TK84riQ5E+jJ86CNtA9ZWSqsX6l3sZutvDJU81hfJG
         u2YkkGwRnHfiv0A1eA4ml+hbKNLd7SYCvi0p/fC6ZgmLtjVxUEuSL3836u/L1FpsXdFo
         mfEDoxczyqb90IMDDVZemD+6vPPfNHZOKaKHEAaIiNn+7duG4xjwPCQf/8kd8ybL7Cbz
         F1LHvcTEOuu0zFpg7jnAdWzsLaiEH/YILmZq28//pxBukUlAaZJAinEA6PHrt6lX1BrS
         Mr+wb3Ejn2OEzk6k5N4zrMw+UYi8NiRZKZgDoXcMgGQ5Asi6kURSCMlv42ZhXZe6Ab09
         qyew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=HVrWphNJm9ODVqQWlSo7gw++y6zZnMkQugM6MxdMyIo=;
        b=wEfiaQE4HkuNKVKI+G1PN7KhIo1LqdKUtniHDPVCpB9la0RB72U4hdr+2GXVidswkT
         QeCHAhEij14pkE8C2M6Ex5Mscd6Aw5ApN7oUWY4rdO7gq6Jkrh7UjUFOcqA0DQskWqyR
         9kbP2FUHybkd02TBDFpulha3vitVzHiDGR/GYzpIrggtiPhkbnTD1ANGYDO7cuXXnwOg
         6XPJA3dxdHU3dQu1tY/nDYj1aUNglDYsyXe4CmIkrwYenTb8GBBEm851FtS0h02Zy1Ap
         IF6S2V9ZuuC3BhpQfIcOg79lBE8oYYbIXD5Q/gEEP8yB/T13YWtGNLXQHR1ebRsP80Xh
         2WGA==
X-Gm-Message-State: AOAM531Nut4qFZLQmONvUFItTellee5Ar3OQ8RZ3Fkavmlrn9iZHjvYo
        lnbyEnzQue0VaScpWw1qIXw4bqg1WLs=
X-Google-Smtp-Source: ABdhPJwBTG5GtOAoenn7/v08HElHG5WIh1QOed6kt0p9lJiIuSouSOtPxmc9DBzfZPhOIldBUvPnV12qGh4=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a63:3183:0:b0:3fd:6797:70a8 with SMTP id
 x125-20020a633183000000b003fd679770a8mr6010940pgx.206.1655239695826; Tue, 14
 Jun 2022 13:48:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:47:30 +0000
In-Reply-To: <20220614204730.3359543-1-seanjc@google.com>
Message-Id: <20220614204730.3359543-22-seanjc@google.com>
Mime-Version: 1.0
References: <20220614204730.3359543-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 21/21] KVM: selftests: Add an x86-only test to verify
 nested exception queueing
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
 .../kvm/x86_64/nested_exceptions_test.c       | 295 ++++++++++++++++++
 3 files changed, 297 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/nested_exceptions_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 0ab0e255d292..7c8adb8cff83 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -27,6 +27,7 @@
 /x86_64/hyperv_svm_test
 /x86_64/max_vcpuid_cap_test
 /x86_64/mmio_warning_test
+/x86_64/nested_exceptions_test
 /x86_64/platform_info_test
 /x86_64/pmu_event_filter_test
 /x86_64/set_boot_cpu_id
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 2ca5400220b9..6db2dd5eca96 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -83,6 +83,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/hyperv_svm_test
 TEST_GEN_PROGS_x86_64 += x86_64/kvm_clock_test
 TEST_GEN_PROGS_x86_64 += x86_64/kvm_pv_test
 TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
+TEST_GEN_PROGS_x86_64 += x86_64/nested_exceptions_test
 TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
 TEST_GEN_PROGS_x86_64 += x86_64/pmu_event_filter_test
 TEST_GEN_PROGS_x86_64 += x86_64/set_boot_cpu_id
diff --git a/tools/testing/selftests/kvm/x86_64/nested_exceptions_test.c b/tools/testing/selftests/kvm/x86_64/nested_exceptions_test.c
new file mode 100644
index 000000000000..ac33835f78f4
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/nested_exceptions_test.c
@@ -0,0 +1,295 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#define _GNU_SOURCE /* for program_invocation_short_name */
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+#include "vmx.h"
+#include "svm_util.h"
+
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
+	if (this_cpu_has(X86_FEATURE_SVM))
+		l1_svm_code(test_data);
+	else
+		l1_vmx_code(test_data);
+}
+
+static void assert_ucall_vector(struct kvm_vcpu *vcpu, int vector)
+{
+	struct kvm_run *run = vcpu->run;
+	struct ucall uc;
+
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+		    "Unexpected exit reason: %u (%s),\n",
+		    run->exit_reason, exit_reason_str(run->exit_reason));
+
+	switch (get_ucall(vcpu, &uc)) {
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
+static void queue_ss_exception(struct kvm_vcpu *vcpu, bool inject)
+{
+	struct kvm_vcpu_events events;
+
+	vcpu_events_get(vcpu, &events);
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
+	vcpu_events_set(vcpu, &events);
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
+	vm_vaddr_t nested_test_data_gva;
+	struct kvm_vcpu_events events;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_EXCEPTION_PAYLOAD));
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SVM) || kvm_cpu_has(X86_FEATURE_VMX));
+
+	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
+	vm_enable_cap(vm, KVM_CAP_EXCEPTION_PAYLOAD, -2ul);
+
+	if (kvm_cpu_has(X86_FEATURE_SVM))
+		vcpu_alloc_svm(vm, &nested_test_data_gva);
+	else
+		vcpu_alloc_vmx(vm, &nested_test_data_gva);
+
+	vcpu_args_set(vcpu, 1, nested_test_data_gva);
+
+	/* Run L1 => L2.  L2 should sync and request #SS. */
+	vcpu_run(vcpu);
+	assert_ucall_vector(vcpu, SS_VECTOR);
+
+	/* Pend #SS and request immediate exit.  #SS should still be pending. */
+	queue_ss_exception(vcpu, false);
+	vcpu->run->immediate_exit = true;
+	vcpu_run_complete_io(vcpu);
+
+	/* Verify the pending events comes back out the same as it went in. */
+	vcpu_events_get(vcpu, &events);
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
+	vcpu->run->immediate_exit = false;
+	vcpu_run(vcpu);
+	assert_ucall_vector(vcpu, GP_VECTOR);
+
+	/*
+	 * Inject #SS, the #SS should bypass interception and cause #GP, which
+	 * L1 should intercept before KVM morphs it to #DF.  L1 should then
+	 * disable #GP interception and run L2 to request #DF (via #SS => #GP).
+	 */
+	queue_ss_exception(vcpu, true);
+	vcpu_run(vcpu);
+	assert_ucall_vector(vcpu, DF_VECTOR);
+
+	/*
+	 * Inject #SS, the #SS should bypass interception and cause #GP, which
+	 * L1 is no longer interception, and so should see a #DF VM-Exit.  L1
+	 * should then signal that is done.
+	 */
+	queue_ss_exception(vcpu, true);
+	vcpu_run(vcpu);
+	assert_ucall_vector(vcpu, FAKE_TRIPLE_FAULT_VECTOR);
+
+	/*
+	 * Inject #SS yet again.  L1 is not intercepting #GP or #DF, and so
+	 * should see nested TRIPLE_FAULT / SHUTDOWN.
+	 */
+	queue_ss_exception(vcpu, true);
+	vcpu_run(vcpu);
+	assert_ucall_vector(vcpu, -1);
+
+	kvm_vm_free(vm);
+}
-- 
2.36.1.476.g0c4daa206d-goog

