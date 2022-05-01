Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 616BA51688F
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 00:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356804AbiEAWMi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 May 2022 18:12:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378579AbiEAWM0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 May 2022 18:12:26 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE75483B8;
        Sun,  1 May 2022 15:08:47 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1nlHk8-0008Pd-K5; Mon, 02 May 2022 00:08:40 +0200
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 11/12] KVM: selftests: nSVM: Add svm_nested_soft_inject_test
Date:   Mon,  2 May 2022 00:07:35 +0200
Message-Id: <d5f3d56528558ad8e28a9f1e1e4187f5a1e6770a.1651440202.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1651440202.git.maciej.szmigiero@oracle.com>
References: <cover.1651440202.git.maciej.szmigiero@oracle.com>
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
inject a software interrupt, a soft exception and a NMI into its L2 guest.

In practice, this tests both the next_rip field consistency and
L1-injected event with intervening L0 VMEXIT during its delivery:
the first nested VMRUN (that's also trying to inject a software interrupt)
will immediately trigger a L0 NPF.
This L0 NPF will have zero in its CPU-returned next_rip field, which if
incorrectly reused by KVM will trigger a #PF when trying to return to
such address 0 from the interrupt handler.

For NMI injection this tests whether the L1 NMI state isn't getting
incorrectly mixed with the L2 NMI state if a L1 -> L2 NMI needs to be
re-injected.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
[sean: check exact L2 RIP on first soft interrupt]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 tools/testing/selftests/kvm/.gitignore        |   3 +-
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/processor.h  |  17 ++
 .../selftests/kvm/include/x86_64/svm_util.h   |  12 +
 .../kvm/x86_64/svm_nested_soft_inject_test.c  | 217 ++++++++++++++++++
 5 files changed, 249 insertions(+), 1 deletion(-)
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
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 37db341d4cc5..deff64605442 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -17,6 +17,8 @@
 
 #include "../kvm_util.h"
 
+#define NMI_VECTOR		0x02
+
 #define X86_EFLAGS_FIXED	 (1u << 1)
 
 #define X86_CR4_VME		(1ul << 0)
@@ -368,6 +370,21 @@ static inline void cpu_relax(void)
 	asm volatile("rep; nop" ::: "memory");
 }
 
+#define vmmcall()		\
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
 bool is_intel_cpu(void);
 bool is_amd_cpu(void);
 
diff --git a/tools/testing/selftests/kvm/include/x86_64/svm_util.h b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
index a25aabd8f5e7..136ba6a5d027 100644
--- a/tools/testing/selftests/kvm/include/x86_64/svm_util.h
+++ b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
@@ -16,6 +16,8 @@
 #define CPUID_SVM_BIT		2
 #define CPUID_SVM		BIT_ULL(CPUID_SVM_BIT)
 
+#define SVM_EXIT_EXCP_BASE	0x040
+#define SVM_EXIT_HLT		0x078
 #define SVM_EXIT_MSR		0x07c
 #define SVM_EXIT_VMMCALL	0x081
 
@@ -36,6 +38,16 @@ struct svm_test_data {
 	uint64_t msr_gpa;
 };
 
+#define stgi()			\
+	__asm__ __volatile__(	\
+		"stgi\n"	\
+		)
+
+#define clgi()			\
+	__asm__ __volatile__(	\
+		"clgi\n"	\
+		)
+
 struct svm_test_data *vcpu_alloc_svm(struct kvm_vm *vm, vm_vaddr_t *p_svm_gva);
 void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_rsp);
 void run_guest(struct vmcb *vmcb, uint64_t vmcb_gpa);
diff --git a/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c b/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
new file mode 100644
index 000000000000..f94f1b449aef
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/svm_nested_soft_inject_test.c
@@ -0,0 +1,217 @@
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
+#include <stdatomic.h>
+#include <stdio.h>
+#include <unistd.h>
+#include "apic.h"
+#include "kvm_util.h"
+#include "processor.h"
+#include "svm_util.h"
+#include "test_util.h"
+#include "../lib/kvm_util_internal.h"
+
+#define VCPU_ID		0
+#define INT_NR			0x20
+#define X86_FEATURE_NRIPS	BIT(3)
+
+static_assert(ATOMIC_INT_LOCK_FREE == 2, "atomic int is not lockless");
+
+static unsigned int bp_fired;
+static void guest_bp_handler(struct ex_regs *regs)
+{
+	bp_fired++;
+}
+
+static unsigned int int_fired;
+static void l2_guest_code_int(void);
+
+static void guest_int_handler(struct ex_regs *regs)
+{
+	int_fired++;
+	GUEST_ASSERT_2(regs->rip == (unsigned long)l2_guest_code_int,
+		       regs->rip, (unsigned long)l2_guest_code_int);
+}
+
+static void l2_guest_code_int(void)
+{
+	GUEST_ASSERT_1(int_fired == 1, int_fired);
+	vmmcall();
+	ud2();
+
+	GUEST_ASSERT_1(bp_fired == 1, bp_fired);
+	hlt();
+}
+
+static atomic_int nmi_stage;
+#define nmi_stage_get() atomic_load_explicit(&nmi_stage, memory_order_acquire)
+#define nmi_stage_inc() atomic_fetch_add_explicit(&nmi_stage, 1, memory_order_acq_rel)
+static void guest_nmi_handler(struct ex_regs *regs)
+{
+	nmi_stage_inc();
+
+	if (nmi_stage_get() == 1) {
+		vmmcall();
+		GUEST_ASSERT(false);
+	} else {
+		GUEST_ASSERT_1(nmi_stage_get() == 3, nmi_stage_get());
+		GUEST_DONE();
+	}
+}
+
+static void l2_guest_code_nmi(void)
+{
+	ud2();
+}
+
+static void l1_guest_code(struct svm_test_data *svm, uint64_t is_nmi, uint64_t idt_alt)
+{
+	#define L2_GUEST_STACK_SIZE 64
+	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+	struct vmcb *vmcb = svm->vmcb;
+
+	if (is_nmi)
+		x2apic_enable();
+
+	/* Prepare for L2 execution. */
+	generic_svm_setup(svm,
+			  is_nmi ? l2_guest_code_nmi : l2_guest_code_int,
+			  &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+
+	vmcb->control.intercept_exceptions |= BIT(PF_VECTOR) | BIT(UD_VECTOR);
+	vmcb->control.intercept |= BIT(INTERCEPT_NMI) | BIT(INTERCEPT_HLT);
+
+	if (is_nmi) {
+		vmcb->control.event_inj = SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_NMI;
+	} else {
+		vmcb->control.event_inj = INT_NR | SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_SOFT;
+		/* The return address pushed on stack */
+		vmcb->control.next_rip = vmcb->save.rip;
+	}
+
+	run_guest(vmcb, svm->vmcb_gpa);
+	GUEST_ASSERT_3(vmcb->control.exit_code == SVM_EXIT_VMMCALL,
+		       vmcb->control.exit_code,
+		       vmcb->control.exit_info_1, vmcb->control.exit_info_2);
+
+	if (is_nmi) {
+		clgi();
+		x2apic_write_reg(APIC_ICR, APIC_DEST_SELF | APIC_INT_ASSERT | APIC_DM_NMI);
+
+		GUEST_ASSERT_1(nmi_stage_get() == 1, nmi_stage_get());
+		nmi_stage_inc();
+
+		stgi();
+		/* self-NMI happens here */
+		while (true)
+			cpu_relax();
+	}
+
+	/* Skip over VMMCALL */
+	vmcb->save.rip += 3;
+
+	/* Switch to alternate IDT to cause intervening NPF again */
+	vmcb->save.idtr.base = idt_alt;
+	vmcb->control.clean = 0; /* &= ~BIT(VMCB_DT) would be enough */
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
+static void run_test(bool is_nmi)
+{
+	struct kvm_vm *vm;
+	vm_vaddr_t svm_gva;
+	vm_vaddr_t idt_alt_vm;
+	struct kvm_guest_debug debug;
+
+	pr_info("Running %s test\n", is_nmi ? "NMI" : "soft int");
+
+	vm = vm_create_default(VCPU_ID, 0, (void *) l1_guest_code);
+
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vm, VCPU_ID);
+
+	vm_install_exception_handler(vm, NMI_VECTOR, guest_nmi_handler);
+	vm_install_exception_handler(vm, BP_VECTOR, guest_bp_handler);
+	vm_install_exception_handler(vm, INT_NR, guest_int_handler);
+
+	vcpu_alloc_svm(vm, &svm_gva);
+
+	if (!is_nmi) {
+		void *idt, *idt_alt;
+
+		idt_alt_vm = vm_vaddr_alloc_page(vm);
+		idt_alt = addr_gva2hva(vm, idt_alt_vm);
+		idt = addr_gva2hva(vm, vm->idt);
+		memcpy(idt_alt, idt, getpagesize());
+	} else {
+		idt_alt_vm = 0;
+	}
+	vcpu_args_set(vm, VCPU_ID, 3, svm_gva, (uint64_t)is_nmi, (uint64_t)idt_alt_vm);
+
+	memset(&debug, 0, sizeof(debug));
+	vcpu_set_guest_debug(vm, VCPU_ID, &debug);
+
+	struct kvm_run *run = vcpu_state(vm, VCPU_ID);
+	struct ucall uc;
+
+	alarm(2);
+	vcpu_run(vm, VCPU_ID);
+	alarm(0);
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
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_cpuid_entry2 *cpuid;
+
+	/* Tell stdout not to buffer its content */
+	setbuf(stdout, NULL);
+
+	nested_svm_check_supported();
+
+	cpuid = kvm_get_supported_cpuid_entry(0x8000000a);
+	TEST_ASSERT(cpuid->edx & X86_FEATURE_NRIPS,
+		    "KVM with nSVM is supposed to unconditionally advertise nRIP Save\n");
+
+	atomic_init(&nmi_stage, 0);
+
+	run_test(false);
+	run_test(true);
+
+	return 0;
+}
