Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D714C50C678
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 04:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbiDWCRi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 22:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231984AbiDWCR2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 22:17:28 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80766223C7A
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 19:14:30 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id y23-20020a62b517000000b004fd8affa86aso6450971pfe.12
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 19:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=d/SdPO1Vv4rU9lCOmy+jzP8vSw2/8svTwDt3X3jyL+E=;
        b=fpGCuDIKiUEBtWUFXzxOcTLpNElXWXUvDFxT13ygkTKRN27WK59npvqxfFYCFgvqWu
         LxHFLqVIEB26w9ybeZclWGN1uxaZqdn9Phyoydn9U//1K3ad+3IRjcSLkt3nMIgsDE/U
         SiLhcKZMFRRjIHKhxBKCVUGvx1ZnA+UVLp9WbpxDA7DYC2gegBsHtNTUGBXwa9+h7vfp
         HWS9nR7VKmhQGa8XKYXeSfpoWkJxrcryIAvhJj+vauGHdHHhdyV92IZOq5jFgUiDb0LZ
         YdOX7Ir4FXMMQg0XRUhXKUJu8lbCbtWpWlGKJy3Pu94T/D+fo+7nmoyMxEEdLBmHWYa3
         AA4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=d/SdPO1Vv4rU9lCOmy+jzP8vSw2/8svTwDt3X3jyL+E=;
        b=UfE/pt6Es3fIKg8qxJ/mpbaHSM+UHCGlnrAfvPQaVDkXL3CvmGjSuL4neSLAB8b/YR
         qpAZRIT2q2pD6M7KIzO6LVk3rdsPrwv/dwKhN03sSpY+qMpMfx81qZurG708bQGENpzV
         SlaGBOXxmKSqkETdeIaP1cyE6nvq5LEp/KvtHI8JkguuJFHaR9G4P7xkQg/wd1PK1s67
         RV2q4FSX48x9c9CEdKtqWsL3rNJw5oMgKqnwyudRXUrXh1xxOms1syOQAHCxrP0ZBedb
         PrNatdug+DdGfH3W+3G/dpQIvtV/guehSh5ZnqPmzS8cQsy3+8DAnIrGyDl68r5oj9JX
         MHcg==
X-Gm-Message-State: AOAM533PkkLdzo3OMno+6sPttO+oUHPR8AtSlmw8HNpwnJ1l7G9tc0b0
        yHvi+VDuGTyc+/H5ugCnpr91rDkS28M=
X-Google-Smtp-Source: ABdhPJzRAKMMl9jvcUVVo/JbXi+/3XEovu4fh5ysH5cQ2bkaxizwsb/lxlFrbWarppfjF05Oc3i1x9G/PNw=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:14d2:b0:50a:48f0:881a with SMTP id
 w18-20020a056a0014d200b0050a48f0881amr7930016pfu.36.1650680069966; Fri, 22
 Apr 2022 19:14:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 23 Apr 2022 02:14:10 +0000
In-Reply-To: <20220423021411.784383-1-seanjc@google.com>
Message-Id: <20220423021411.784383-11-seanjc@google.com>
Mime-Version: 1.0
References: <20220423021411.784383-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v2 10/11] KVM: selftests: nSVM: Add svm_nested_soft_inject_test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>

Add a KVM self-test that checks whether a nSVM L1 is able to successfully
inject a software interrupt and a soft exception into its L2 guest.

In practice, this tests both the next_rip field consistency and
L1-injected event with intervening L0 VMEXIT during its delivery:
the first nested VMRUN (that's also trying to inject a software interrupt)
will immediately trigger a L0 NPF.
This L0 NPF will have zero in its CPU-returned next_rip field, which if
incorrectly reused by KVM will trigger a #PF when trying to return to
such address 0 from the interrupt handler.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
[sean: check exact L2 RIP on first soft interrupt]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   3 +-
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/svm_util.h   |   2 +
 .../kvm/x86_64/svm_nested_soft_inject_test.c  | 151 ++++++++++++++++++
 4 files changed, 156 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 56140068b763..74f3099f0ad3 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -35,9 +35,10 @@
 /x86_64/state_test
 /x86_64/svm_vmcall_test
 /x86_64/svm_int_ctl_test
-/x86_64/tsc_scaling_sync
+/x86_64/svm_nested_soft_inject_test
 /x86_64/sync_regs_test
 /x86_64/tsc_msrs_test
+/x86_64/tsc_scaling_sync
 /x86_64/userspace_io_test
 /x86_64/userspace_msr_exit_test
 /x86_64/vmx_apic_access_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index af582d168621..eedf6bf713d3 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -66,6 +66,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/state_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_preemption_timer_test
 TEST_GEN_PROGS_x86_64 += x86_64/svm_vmcall_test
 TEST_GEN_PROGS_x86_64 += x86_64/svm_int_ctl_test
+TEST_GEN_PROGS_x86_64 += x86_64/svm_nested_soft_inject_test
 TEST_GEN_PROGS_x86_64 += x86_64/tsc_scaling_sync
 TEST_GEN_PROGS_x86_64 += x86_64/sync_regs_test
 TEST_GEN_PROGS_x86_64 += x86_64/userspace_io_test
diff --git a/tools/testing/selftests/kvm/include/x86_64/svm_util.h b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
index a25aabd8f5e7..d49f7c9b4564 100644
--- a/tools/testing/selftests/kvm/include/x86_64/svm_util.h
+++ b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
@@ -16,6 +16,8 @@
 #define CPUID_SVM_BIT		2
 #define CPUID_SVM		BIT_ULL(CPUID_SVM_BIT)
 
+#define SVM_EXIT_EXCP_BASE	0x040
+#define SVM_EXIT_HLT		0x078
 #define SVM_EXIT_MSR		0x07c
 #define SVM_EXIT_VMMCALL	0x081
 
diff --git a/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c b/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
new file mode 100644
index 000000000000..257aa2280b5c
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
@@ -0,0 +1,151 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2022 Oracle and/or its affiliates.
+ *
+ * Based on:
+ *   svm_int_ctl_test
+ *
+ *   Copyright (C) 2021, Red Hat, Inc.
+ *
+ */
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+#include "svm_util.h"
+
+#define VCPU_ID		0
+#define INT_NR			0x20
+#define X86_FEATURE_NRIPS	BIT(3)
+
+#define vmcall()		\
+	__asm__ __volatile__(	\
+		"vmmcall\n"	\
+		)
+
+#define ud2()			\
+	__asm__ __volatile__(	\
+		"ud2\n"	\
+		)
+
+#define hlt()			\
+	__asm__ __volatile__(	\
+		"hlt\n"	\
+		)
+
+static unsigned int bp_fired;
+static void guest_bp_handler(struct ex_regs *regs)
+{
+	bp_fired++;
+}
+
+static unsigned int int_fired;
+static void l2_guest_code(void);
+
+static void guest_int_handler(struct ex_regs *regs)
+{
+	int_fired++;
+	GUEST_ASSERT_2(regs->rip == (unsigned long)l2_guest_code,
+		       regs->rip, (unsigned long)l2_guest_code);
+}
+
+static void l2_guest_code(void)
+{
+	GUEST_ASSERT(int_fired == 1);
+	vmcall();
+	ud2();
+
+	GUEST_ASSERT(bp_fired == 1);
+	hlt();
+}
+
+static void l1_guest_code(struct svm_test_data *svm)
+{
+	#define L2_GUEST_STACK_SIZE 64
+	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+	struct vmcb *vmcb = svm->vmcb;
+
+	/* Prepare for L2 execution. */
+	generic_svm_setup(svm, l2_guest_code,
+			  &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+
+	vmcb->control.intercept_exceptions |= BIT(PF_VECTOR) | BIT(UD_VECTOR);
+	vmcb->control.intercept |= BIT(INTERCEPT_HLT);
+
+	vmcb->control.event_inj = INT_NR | SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_SOFT;
+	/* The return address pushed on stack */
+	vmcb->control.next_rip = vmcb->save.rip;
+
+	run_guest(vmcb, svm->vmcb_gpa);
+	GUEST_ASSERT_3(vmcb->control.exit_code == SVM_EXIT_VMMCALL,
+		       vmcb->control.exit_code,
+		       vmcb->control.exit_info_1, vmcb->control.exit_info_2);
+
+	/* Skip over VMCALL */
+	vmcb->save.rip += 3;
+
+	vmcb->control.event_inj = BP_VECTOR | SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_EXEPT;
+	/* The return address pushed on stack, skip over UD2 */
+	vmcb->control.next_rip = vmcb->save.rip + 2;
+
+	run_guest(vmcb, svm->vmcb_gpa);
+	GUEST_ASSERT_3(vmcb->control.exit_code == SVM_EXIT_HLT,
+		       vmcb->control.exit_code,
+		       vmcb->control.exit_info_1, vmcb->control.exit_info_2);
+
+	GUEST_DONE();
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_cpuid_entry2 *cpuid;
+	struct kvm_vm *vm;
+	vm_vaddr_t svm_gva;
+	struct kvm_guest_debug debug;
+
+	nested_svm_check_supported();
+
+	cpuid = kvm_get_supported_cpuid_entry(0x8000000a);
+	if (!(cpuid->edx & X86_FEATURE_NRIPS)) {
+		print_skip("nRIP Save unavailable");
+		exit(KSFT_SKIP);
+	}
+
+	vm = vm_create_default(VCPU_ID, 0, (void *) l1_guest_code);
+
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vm, VCPU_ID);
+
+	vm_install_exception_handler(vm, BP_VECTOR, guest_bp_handler);
+	vm_install_exception_handler(vm, INT_NR, guest_int_handler);
+
+	vcpu_alloc_svm(vm, &svm_gva);
+	vcpu_args_set(vm, VCPU_ID, 1, svm_gva);
+
+	memset(&debug, 0, sizeof(debug));
+	vcpu_set_guest_debug(vm, VCPU_ID, &debug);
+
+	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
+	struct ucall uc;
+
+	vcpu_run(vm, VCPU_ID);
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+		    "Got exit_reason other than KVM_EXIT_IO: %u (%s)\n",
+		    run->exit_reason,
+		    exit_reason_str(run->exit_reason));
+
+	switch (get_ucall(vm, VCPU_ID, &uc)) {
+	case UCALL_ABORT:
+		TEST_FAIL("%s at %s:%ld, vals = 0x%lx 0x%lx 0x%lx", (const char *)uc.args[0],
+			  __FILE__, uc.args[1], uc.args[2], uc.args[3], uc.args[4]);
+		break;
+		/* NOT REACHED */
+	case UCALL_DONE:
+		goto done;
+	default:
+		TEST_FAIL("Unknown ucall 0x%lx.", uc.cmd);
+	}
+done:
+	kvm_vm_free(vm);
+	return 0;
+}
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

