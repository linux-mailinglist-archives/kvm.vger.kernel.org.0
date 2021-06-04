Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E733A39BEBC
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 19:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbhFDR3s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 13:29:48 -0400
Received: from mail-qk1-f202.google.com ([209.85.222.202]:55290 "EHLO
        mail-qk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbhFDR3s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 13:29:48 -0400
Received: by mail-qk1-f202.google.com with SMTP id s20-20020ae9f7140000b02903a98afb6313so7014849qkg.21
        for <kvm@vger.kernel.org>; Fri, 04 Jun 2021 10:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ExzF5GAgx6kdyb5TlE2fN5Do28wdaAIZFuxM/uKeTy8=;
        b=oTtsq5IW2ni/24kBjQAIJGHrAOYBthQZ5M9bPjTxe3mBed72/vN3heBsHjWSuKT4n0
         ksjnlsc2p0aq5iWnHa8vEmURr3HitG5rGUIrsr2wuP9rqpPp6cLH73aLL74cxAZA22Cj
         s4WET+MuHn48Rm2S0c/YDwWtwDiD2D9su5FWkYcXESHslRk1epwEZmZMHBfqzbehQ3F0
         uE7LdFuuBdCHWDBV7Sy0UvavNsbajzkqZGU/nlcrRNRgOt8TBoekaHgcblNliArMi76O
         k2XgMuONVmn+IMTHnWLajVL3D84KNrnuAjL4TzpPLEg8RujMIjfIcjPTabq+EP3PU20B
         aOcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ExzF5GAgx6kdyb5TlE2fN5Do28wdaAIZFuxM/uKeTy8=;
        b=JDwGyAcojUC0x/HwNWfTEUtsLedPSAByby5yY5N/F2sRYJcq0JBwju4drO3MqLJ5Mb
         wU6k730GrY9UAHHJbxEmPlbNBpbcilFCXlSSFWnQm+dvsuKtkgUbLG5fckAVfvICjHTh
         AsGMILdXKy+1AraUtjDe8TE6e7922y4QNx2QIWmGYwyFmpbcwTf7P1TZabgY+dn3kAbE
         05UBk+UhSrjnMCFU4K91UdlkU9AlHFCFwcoZk71xg2qpBVJMKTwgCUZTPHhtJUBD+Oks
         m09DxhSz57hwUUz/aP4UYMmjB8vav+DdYQxNNXEikJM1iRGo7zNKmEECCuSaM5fCLNpJ
         cbMg==
X-Gm-Message-State: AOAM530hZaPK06nuZOdt+u+mIZfperxKT8Qk4kyOPoHlckKQRWZtp5e6
        DhEqPJvhz/gJ0RDzq+KutcRStEb1DKbX7pS72l9BM0rWVJRNhCrkuY+oYA01NrblnNF7JtmowMC
        M6fawQuJmhpO1UzvNTXkw/JtQZREi6Vsy+2x+uLUyn5jANLbjOxNkER5BFrw9uGc=
X-Google-Smtp-Source: ABdhPJyxmmRPoM6BqCirHb+vSxZ5QfRXd0h0ATukglcW0OtqTgvYw34p6dtqQS0z4cMRZJahraXreP72CYzYQw==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:ad4:5569:: with SMTP id
 w9mr5546688qvy.59.1622827607531; Fri, 04 Jun 2021 10:26:47 -0700 (PDT)
Date:   Fri,  4 Jun 2021 10:26:11 -0700
In-Reply-To: <20210604172611.281819-1-jmattson@google.com>
Message-Id: <20210604172611.281819-13-jmattson@google.com>
Mime-Version: 1.0
References: <20210604172611.281819-1-jmattson@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH v2 12/12] KVM: selftests: Add a test of an unbacked nested PI descriptor
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Jim Mattson <jmattson@google.com>, Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a regression test for the unsupported configuration of a VMCS12
posted interrupt descriptor that has no backing memory in L1. KVM
should exit to userspace with KVM_INTERNAL_ERROR rather than just
silently doing something wrong.

Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/vmx_pi_mmio_test.c   | 252 ++++++++++++++++++
 3 files changed, 254 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_pi_mmio_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 524c857a049c..43fe1bb037ac 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -34,6 +34,7 @@
 /x86_64/xen_vmcall_test
 /x86_64/xss_msr_test
 /x86_64/vmx_pmu_msrs_test
+/x86_64/vmx_pi_mmio_test
 /demand_paging_test
 /dirty_log_test
 /dirty_log_perf_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 5e9051dd4336..d7b7d6e641f0 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -67,6 +67,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/tsc_msrs_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_pmu_msrs_test
 TEST_GEN_PROGS_x86_64 += x86_64/xen_shinfo_test
 TEST_GEN_PROGS_x86_64 += x86_64/xen_vmcall_test
+TEST_GEN_PROGS_x86_64 += x86_64/vmx_pi_mmio_test
 TEST_GEN_PROGS_x86_64 += demand_paging_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
 TEST_GEN_PROGS_x86_64 += dirty_log_perf_test
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pi_mmio_test.c b/tools/testing/selftests/kvm/x86_64/vmx_pi_mmio_test.c
new file mode 100644
index 000000000000..2246899d8988
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/vmx_pi_mmio_test.c
@@ -0,0 +1,252 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * vmx_pi_mmio_test
+ *
+ * Copyright (C) 2021, Google LLC.
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.
+ *
+ * Test that an L2 vCPU can be launched with an unbacked posted
+ * interrupt descriptor, but that any attempt to send that vCPU its
+ * posted interrupt notification vector will result in an exit to
+ * userspace with KVM_INTERNAL_ERROR.
+ *
+ */
+
+#define _GNU_SOURCE /* for program_invocation_short_name */
+#include <pthread.h>
+#include <inttypes.h>
+#include <unistd.h>
+
+#include "kvm_util.h"
+#include "processor.h"
+#include "test_util.h"
+#include "vmx.h"
+
+#include "kselftest.h"
+
+#define RECEIVER_VCPU_ID	0
+#define SENDER_VCPU_ID		1
+
+#define L2_GUEST_STACK_SIZE	64
+
+#define TIMEOUT_SECS		10
+
+#define L1_PI_VECTOR		33
+
+static struct kvm_vm *vm;
+
+static bool l2_active;
+
+static void l2_guest_code(void)
+{
+	l2_active = true;
+	__asm__ __volatile__("hlt");
+	/* NOT REACHED */
+}
+
+static void l1_receiver_code(struct vmx_pages *vmx_pages,
+			     unsigned long high_gpa)
+{
+	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+	uint32_t control;
+
+	x2apic_enable();
+
+	GUEST_ASSERT(prepare_for_vmx_operation(vmx_pages));
+	GUEST_ASSERT(load_vmcs(vmx_pages));
+
+	prepare_vmcs(vmx_pages, l2_guest_code,
+		     &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+	control = vmreadz(PIN_BASED_VM_EXEC_CONTROL);
+	control |= PIN_BASED_EXT_INTR_MASK |
+		PIN_BASED_POSTED_INTR;
+	vmwrite(PIN_BASED_VM_EXEC_CONTROL, control);
+
+	control = vmreadz(CPU_BASED_VM_EXEC_CONTROL);
+	control |= CPU_BASED_TPR_SHADOW |
+		CPU_BASED_ACTIVATE_SECONDARY_CONTROLS;
+	vmwrite(CPU_BASED_VM_EXEC_CONTROL, control);
+
+	control = vmreadz(SECONDARY_VM_EXEC_CONTROL);
+	control |= SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY;
+	vmwrite(SECONDARY_VM_EXEC_CONTROL, control);
+
+	control = vmreadz(VM_EXIT_CONTROLS);
+	control |= VM_EXIT_ACK_INTR_ON_EXIT;
+	vmwrite(VM_EXIT_CONTROLS, control);
+
+	vmwrite(VIRTUAL_APIC_PAGE_ADDR, vmx_pages->virtual_apic_gpa);
+	vmwrite(POSTED_INTR_NV, L1_PI_VECTOR);
+	vmwrite(POSTED_INTR_DESC_ADDR, high_gpa);
+
+	GUEST_ASSERT(!vmlaunch());
+	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_VMCALL);
+
+	GUEST_DONE();
+}
+
+static void l1_sender_code(void *arg)
+{
+	x2apic_enable();
+
+	x2apic_write_reg(APIC_ICR,
+			 APIC_INT_ASSERT | APIC_DEST_PHYSICAL |
+			 APIC_DM_FIXED | L1_PI_VECTOR |
+			 ((uint64_t)RECEIVER_VCPU_ID << 32));
+
+	GUEST_DONE();
+}
+
+static bool vcpu_run_loop(int vcpu_id)
+{
+	volatile struct kvm_run *run = vcpu_state(vm, vcpu_id);
+	bool done = false;
+	struct ucall uc;
+
+	while (!done) {
+		vcpu_run(vm, vcpu_id);
+
+		if (run->exit_reason != KVM_EXIT_IO)
+			break;
+
+		switch (get_ucall(vm, vcpu_id, &uc)) {
+		case UCALL_ABORT:
+			TEST_FAIL("vCPU  %d: %s at %s:%ld", vcpu_id,
+				  (const char *)uc.args[0], __FILE__,
+				  uc.args[1]);
+			/* NOT REACHED */
+		case UCALL_SYNC:
+			break;
+		case UCALL_DONE:
+			done = true;
+			break;
+		default:
+			TEST_FAIL("vCPU %d: Unknown ucall %lu",
+				  vcpu_id, uc.cmd);
+			/* NOT REACHED */
+		}
+	}
+
+	return done;
+}
+
+static void *receiver(void *arg)
+{
+	volatile struct kvm_run *run = vcpu_state(vm, RECEIVER_VCPU_ID);
+	unsigned long high_gpa = *(unsigned long *)arg;
+	vm_vaddr_t vmx_pages_gva;
+	struct vmx_pages *vmx;
+	bool success;
+
+	vmx = vcpu_alloc_vmx(vm, &vmx_pages_gva);
+	prepare_tpr_shadow(vmx, vm);
+	vcpu_args_set(vm, RECEIVER_VCPU_ID, 2, vmx_pages_gva, high_gpa);
+
+	success = vcpu_run_loop(RECEIVER_VCPU_ID);
+	TEST_ASSERT(!success, "Receiver didn't fail as expected.\n");
+	TEST_ASSERT(run->exit_reason ==
+		    KVM_EXIT_INTERNAL_ERROR,
+		    "Exit reason isn't KVM_EXIT_INTERNAL_ERROR: %u (%s).\n",
+		    run->exit_reason,
+		    exit_reason_str(run->exit_reason));
+	TEST_ASSERT(run->internal.suberror ==
+		    KVM_INTERNAL_ERROR_EMULATION,
+		    "Internal suberror isn't KVM_INTERNAL_ERROR_EMULATION: %u.\n",
+		    run->internal.suberror);
+
+	return NULL;
+}
+
+static void sender(void)
+{
+	volatile struct kvm_run *run = vcpu_state(vm, SENDER_VCPU_ID);
+	bool success;
+
+	success = vcpu_run_loop(SENDER_VCPU_ID);
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+		    "Sender didn't exit with KVM_EXIT_IO: %u (%s).\n",
+		    run->exit_reason,
+		    exit_reason_str(run->exit_reason));
+	TEST_ASSERT(success, "Sender didn't complete successfully.\n");
+}
+
+void check_constraints(void)
+{
+	uint64_t msr;
+
+	nested_vmx_check_supported();
+
+	msr = kvm_get_feature_msr(MSR_IA32_VMX_PINBASED_CTLS) >> 32;
+	if (!(msr & PIN_BASED_EXT_INTR_MASK)) {
+		print_skip("Cannot enable \"external-interrupt exiting\"");
+		exit(KSFT_SKIP);
+	}
+	if (!(msr & PIN_BASED_POSTED_INTR)) {
+		print_skip("Cannot enable \"process posted interrupts\"");
+		exit(KSFT_SKIP);
+	}
+
+	msr = kvm_get_feature_msr(MSR_IA32_VMX_PROCBASED_CTLS) >> 32;
+	if (!(msr & CPU_BASED_TPR_SHADOW)) {
+		print_skip("Cannot enable \"use TPR shadow\"");
+		exit(KSFT_SKIP);
+	}
+	if (!(msr & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS)) {
+		print_skip("Cannot enable \"activate secondary controls\"");
+		exit(KSFT_SKIP);
+	}
+
+	msr = kvm_get_feature_msr(MSR_IA32_VMX_PROCBASED_CTLS2) >> 32;
+	if (!(msr & SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY)) {
+		print_skip("Cannot enable \"virtual-interrupt delivery\"");
+		exit(KSFT_SKIP);
+	}
+
+	msr = kvm_get_feature_msr(MSR_IA32_VMX_EXIT_CTLS) >> 32;
+	if (!(msr & VM_EXIT_ACK_INTR_ON_EXIT)) {
+		print_skip("Cannot enable \"acknowledge interrupt on exit\"");
+		exit(KSFT_SKIP);
+	}
+}
+
+int main(int argc, char *argv[])
+{
+	unsigned int paddr_width;
+	unsigned int vaddr_width;
+	unsigned long high_gpa;
+	pthread_t thread;
+	bool *l2_active_hva;
+	int r;
+
+	kvm_get_cpu_address_width(&paddr_width, &vaddr_width);
+	high_gpa = (1ul << paddr_width) - getpagesize();
+	if ((unsigned long)DEFAULT_GUEST_PHY_PAGES * getpagesize() > high_gpa) {
+		print_skip("No unbacked physical page available");
+		exit(KSFT_SKIP);
+	}
+
+	check_constraints();
+
+	vm = vm_create_default(RECEIVER_VCPU_ID, 0, (void *)l1_receiver_code);
+	vm_vcpu_add_default(vm, SENDER_VCPU_ID, (void *)l1_sender_code);
+	vcpu_set_cpuid(vm, SENDER_VCPU_ID, kvm_get_supported_cpuid());
+
+	r = pthread_create(&thread, NULL, receiver, &high_gpa);
+	TEST_ASSERT(r == 0,
+		    "pthread_create failed errno=%d", errno);
+
+	alarm(TIMEOUT_SECS);
+	l2_active_hva = (bool *)addr_gva2hva(vm, (vm_vaddr_t)&l2_active);
+	while (!*l2_active_hva)
+		pthread_yield();
+
+	sender();
+
+	r = pthread_join(thread, NULL);
+	TEST_ASSERT(r == 0, "pthread_join failed with errno=%d", r);
+
+	kvm_vm_free(vm);
+
+	return 0;
+}
-- 
2.32.0.rc1.229.g3e70b5a671-goog

