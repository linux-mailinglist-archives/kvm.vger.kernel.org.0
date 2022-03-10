Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA7CE4D53AE
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 22:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344083AbiCJVkq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 16:40:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344057AbiCJVkl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 16:40:41 -0500
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0962D226F;
        Thu, 10 Mar 2022 13:39:35 -0800 (PST)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1nSQV7-0006K2-SC; Thu, 10 Mar 2022 22:39:13 +0100
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jon Grimm <Jon.Grimm@amd.com>,
        David Kaplan <David.Kaplan@amd.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Liam Merwick <liam.merwick@oracle.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] KVM: selftests: nSVM: Add svm_nested_soft_inject_test
Date:   Thu, 10 Mar 2022 22:38:41 +0100
Message-Id: <a1031936e91221e2b30e18fe0087dd6e25d66aa3.1646944472.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1646944472.git.maciej.szmigiero@oracle.com>
References: <cover.1646944472.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

Add a KVM self-test that checks whether a nSVM L1 is able to successfully
inject a software interrupt and a soft exception into its L2 guest.

In practice, this tests both the next_rip field consistency and
L1-injected event with intervening L0 VMEXIT during its delivery:
the first nested VMRUN (that's also trying to inject a software interrupt)
will immediately trigger a L0 NPF.
This L0 NPF will have zero in its CPU-returned next_rip field, which if
incorrectly reused by KVM will trigger a #PF when trying to return to
such address 0 from the interrupt handler.

Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/svm_util.h   |   2 +
 .../kvm/x86_64/svm_nested_soft_inject_test.c  | 147 ++++++++++++++++++
 4 files changed, 151 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 9b67343dc4ab..bc7e2c5a8560 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -32,6 +32,7 @@
 /x86_64/state_test
 /x86_64/svm_vmcall_test
 /x86_64/svm_int_ctl_test
+/x86_64/svm_nested_soft_inject_test
 /x86_64/sync_regs_test
 /x86_64/tsc_msrs_test
 /x86_64/userspace_io_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 04099f453b59..ff63e3caac9b 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -65,6 +65,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/state_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_preemption_timer_test
 TEST_GEN_PROGS_x86_64 += x86_64/svm_vmcall_test
 TEST_GEN_PROGS_x86_64 += x86_64/svm_int_ctl_test
+TEST_GEN_PROGS_x86_64 += x86_64/svm_nested_soft_inject_test
 TEST_GEN_PROGS_x86_64 += x86_64/sync_regs_test
 TEST_GEN_PROGS_x86_64 += x86_64/userspace_io_test
 TEST_GEN_PROGS_x86_64 += x86_64/userspace_msr_exit_test
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
index 000000000000..d39be5d885c1
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
@@ -0,0 +1,147 @@
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
+static void guest_int_handler(struct ex_regs *regs)
+{
+	int_fired++;
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
