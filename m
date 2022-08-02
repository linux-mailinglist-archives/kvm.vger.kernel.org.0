Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B32BE5884B0
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 01:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235193AbiHBXHo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 19:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234764AbiHBXHh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 19:07:37 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF9664F68D
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 16:07:30 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id z18-20020a63d012000000b0041b3478e9a9so6074423pgf.17
        for <kvm@vger.kernel.org>; Tue, 02 Aug 2022 16:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=QkdGTQkLJe04OzhDUqvLuS5XVeRvpbZXCtgImio6O8A=;
        b=OzSphegZ1ZknlH64i7UfsjWeZJTk9WrqkWEPugROrPfUOzMHLQLm+uQCZmOV9GVR59
         tYhyP6MJ5xRrGXCzH5OKV2aikWfzBbdf9luApysy4G4MuorO54u6yVMwgJkfPLYlQLdk
         oa3Qn1bH24vwK9PsaD/Hbl9nh3MGudIDZDNSjJxiPXq6jWaWujYJLkddCQmYJMs5kbq0
         oaFLJw18NwZHg3NQSpI/HREeSRpK7ieF1PDpNMigh1jqpVTo7EfvUq/IgP0GGPNWjO+F
         HOPOYBnqS/i/TBp5lrGBiDApbmBcwxQwRVuBCXh18CFdxTdTnk6r7bIxTBfhdKFCHC+s
         1s5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=QkdGTQkLJe04OzhDUqvLuS5XVeRvpbZXCtgImio6O8A=;
        b=yxrAh5SL2FsJShJy9fmWXR+E2cLt37LgBB4ZjOd8pgwK/nio7bkmuxn1tu7D1as5Mt
         snqwT60dh0tMmKpErxdpa5dQ7uZjSQ8rzoDOcuEoWz7ymA3KSDZD78TCVb3Ap9SCwME7
         HdJW0OMhMsRggyvexUGkffd2lVrecGa5eSMqMuy4JmQZ/eWA/zG9JowIVDhTXVl8kW2l
         DwbA1P4WtjQelRuMDUx/bqhBFXmHToHV15ZQIOuNTzWrkmcxtJIqksQoaU9i7jbDMwB6
         lbo+zvmU8w141awbz/NI6pt52DcZgmnhqzmqvSljivNCPKdnHDNx9ygjs8etsKk1P0PS
         d9eg==
X-Gm-Message-State: ACgBeo0I8GhhtcxG0H/gCl/+Wal6JsziMl4eg7iE4EerRQ8CioO86oKD
        TCn9TaEjqHFH581gsFeCfYu2tdNmgmfW
X-Google-Smtp-Source: AA6agR547QKamGuY0F3IOJpsmXV7IB1tIgc1/YRZNcgkFzsbk9vm+zmpsbwzzwvMO+TFezDI2VsZNLZJNN6L
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr162545pje.0.1659481649565; Tue, 02 Aug
 2022 16:07:29 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Tue,  2 Aug 2022 23:07:18 +0000
In-Reply-To: <20220802230718.1891356-1-mizhang@google.com>
Message-Id: <20220802230718.1891356-6-mizhang@google.com>
Mime-Version: 1.0
References: <20220802230718.1891356-1-mizhang@google.com>
X-Mailer: git-send-email 2.37.1.455.g008518b4e5-goog
Subject: [PATCH 5/5] selftests: KVM: Test if posted interrupt delivery race
 with migration
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jim Mattson <jmattson@google.com>

Test if posted interrupt delivery race with migration. Add a selftest
to demonstrate a race condition between migration and posted
interrupt for a nested VM. The consequence of this race condition causes
the loss of a posted interrupt for a nested vCPU after migration and
triggers a warning for unpatched kernel.

The selftest demonstrates that if a L2 vCPU is in halted state before
migration, then after migration, it is not able to receive a posted
interrupt from another vCPU within the same VM.

The fundamental problem is deeply buried in the kernel logic where
vcpu_block() will directly check vmcs12 related mappings before having a
valid vmcs12 ready.  Because of that, it fails to process the posted
interrupt and triggers the warning in vmx_guest_apic_has_interrupt()

static bool vmx_guest_apic_has_interrupt(struct kvm_vcpu *vcpu)
{
	...
	if (WARN_ON_ONCE(!is_guest_mode(vcpu)) ||
		!nested_cpu_has_vid(get_vmcs12(vcpu)) ||
		WARN_ON_ONCE(!vmx->nested.virtual_apic_map.gfn)) <= HERE
		return false;
	...
}

Signed-off-by: Jim Mattson <jmattson@google.com>
Co-developed-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../kvm/x86_64/vmx_migrate_pi_pending.c       | 289 ++++++++++++++++++
 3 files changed, 291 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_migrate_pi_pending.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index d625a3f83780..749b2be5b23c 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -51,6 +51,7 @@
 /x86_64/vmx_exception_with_invalid_guest_state
 /x86_64/vmx_invalid_nested_guest_state
 /x86_64/vmx_msrs_test
+/x86_64/vmx_migrate_pi_pending
 /x86_64/vmx_preemption_timer_test
 /x86_64/vmx_set_nested_state_test
 /x86_64/vmx_tsc_adjust_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 690b499c3471..2d32416237db 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -109,6 +109,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/vmx_dirty_log_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_exception_with_invalid_guest_state
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_msrs_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_invalid_nested_guest_state
+TEST_GEN_PROGS_x86_64 += x86_64/vmx_migrate_pi_pending
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_nested_tsc_scaling_test
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_migrate_pi_pending.c b/tools/testing/selftests/kvm/x86_64/vmx_migrate_pi_pending.c
new file mode 100644
index 000000000000..f1498621eb9a
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/vmx_migrate_pi_pending.c
@@ -0,0 +1,289 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * vmx_migrate_pi_pending
+ *
+ * Copyright (C) 2022, Google, LLC.
+ *
+ * Deliver a nested posted interrupt between migration and the first
+ * KVM_RUN on the target.
+ */
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+#include "vmx.h"
+
+#include <string.h>
+#include <sys/ioctl.h>
+#include <linux/bitmap.h>
+#include <pthread.h>
+#include <signal.h>
+
+#include "kselftest.h"
+
+#define VCPU_ID0 0
+#define VCPU_ID1 1
+#define PI_ON_BIT 256
+#define PI_NV    0x42
+#define L2_INTR  0x71
+
+enum {
+	PORT_L0_EXIT = 0x2000,
+};
+
+/* The virtual machine object. */
+struct vmx_pages *vmx;
+
+static struct kvm_vm *vm;
+static struct kvm_vcpu *vcpu0;
+static struct kvm_vcpu *vcpu1;
+bool vcpu0_can_run = true;
+bool vcpu0_running;
+bool pi_executed;
+pthread_t pthread_cpu0;
+pthread_t pthread_cpu1;
+
+static void vcpu0_ipi_handler(struct ex_regs *regs)
+{
+	 asm volatile("inb %%dx, %%al"
+		      : : [port] "d" (PORT_L0_EXIT) : "rax");
+	asm volatile("vmcall");
+}
+
+static void l2_vcpu0_guest_code(void)
+{
+	asm volatile("cli");
+	asm volatile("sti; nop; hlt");
+}
+
+static void l1_vcpu0_guest_code(struct vmx_pages *vmx_pages)
+{
+#define L2_GUEST_STACK_SIZE 64
+	unsigned long l2_vcpu0_guest_stack[L2_GUEST_STACK_SIZE];
+	uint32_t control;
+
+	x2apic_enable();
+
+	GUEST_ASSERT(prepare_for_vmx_operation(vmx_pages));
+	GUEST_ASSERT(load_vmcs(vmx_pages));
+
+	/* Prepare the VMCS for L2 execution. */
+	prepare_vmcs(vmx_pages, l2_vcpu0_guest_code,
+		     &l2_vcpu0_guest_stack[L2_GUEST_STACK_SIZE]);
+	control = vmreadz(PIN_BASED_VM_EXEC_CONTROL);
+	control |= (PIN_BASED_EXT_INTR_MASK |
+		    PIN_BASED_POSTED_INTR);
+	vmwrite(PIN_BASED_VM_EXEC_CONTROL, control);
+	control = vmreadz(CPU_BASED_VM_EXEC_CONTROL);
+	control |= (CPU_BASED_TPR_SHADOW |
+		    CPU_BASED_ACTIVATE_SECONDARY_CONTROLS);
+	vmwrite(CPU_BASED_VM_EXEC_CONTROL, control);
+	control = vmreadz(SECONDARY_VM_EXEC_CONTROL);
+	control |= (SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE |
+		    SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
+	vmwrite(SECONDARY_VM_EXEC_CONTROL, control);
+	control = vmreadz(VM_EXIT_CONTROLS);
+	control |= VM_EXIT_ACK_INTR_ON_EXIT;
+	vmwrite(VM_EXIT_CONTROLS, control);
+	vmwrite(VIRTUAL_APIC_PAGE_ADDR, vmx_pages->virtual_apic_gpa);
+	vmwrite(POSTED_INTR_DESC_ADDR, vmx_pages->posted_intr_desc_gpa);
+	vmwrite(POSTED_INTR_NV, PI_NV);
+
+	GUEST_ASSERT(!vmlaunch());
+	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_VMCALL);
+	GUEST_ASSERT(!test_bit(PI_ON_BIT, (void *)vmx_pages->posted_intr_desc));
+	GUEST_DONE();
+}
+
+static void post_intr(u8 vector, void *pi_desc)
+{
+	set_bit(vector, pi_desc);
+	set_bit(PI_ON_BIT, pi_desc);
+}
+
+static void l1_vcpu1_guest_code(void *vcpu0_pi_desc)
+{
+	post_intr(L2_INTR, vcpu0_pi_desc);
+	x2apic_enable();
+	x2apic_write_reg(APIC_ICR, ((u64)VCPU_ID0 << 32) |
+			 APIC_DEST_PHYSICAL | APIC_DM_FIXED | PI_NV);
+	GUEST_DONE();
+}
+
+static void save_restore_vm(struct kvm_vm *vm)
+{
+	struct kvm_regs regs1 = {}, regs2 = {};
+	struct kvm_x86_state *state;
+
+	state = vcpu_save_state(vcpu0);
+	vcpu_regs_get(vcpu0, &regs1);
+
+	kvm_vm_release(vm);
+
+	/* Restore state in a new VM.  */
+	vcpu0 = vm_recreate_with_one_vcpu(vm);
+	vcpu_load_state(vcpu0, state);
+	kvm_x86_state_cleanup(state);
+
+	vcpu_regs_get(vcpu0, &regs2);
+	TEST_ASSERT(!memcmp(&regs1, &regs2, sizeof(regs2)),
+		    "vcpu0: Unexpected register values after vcpu_load_state; rdi: %lx rsi: %lx",
+		    (ulong) regs2.rdi, (ulong) regs2.rsi);
+}
+
+void *create_and_run_vcpu1(void *arg)
+{
+	struct ucall uc;
+	struct kvm_run *run;
+	struct kvm_mp_state vcpu0_mp_state;
+
+	pthread_cpu1 = pthread_self();
+
+	/* Keep trying to kick out vcpu0 until it is in halted state. */
+	for (;;) {
+		WRITE_ONCE(vcpu0_can_run, true);
+		sleep(0.1);
+		WRITE_ONCE(vcpu0_can_run, false);
+		pthread_kill(pthread_cpu0, SIGUSR1);
+		printf("vcpu1: Sent SIGUSR1 to vcpu0\n");
+
+		while (READ_ONCE(vcpu0_running))
+			;
+
+		vcpu_mp_state_get(vcpu0, &vcpu0_mp_state);
+		if (vcpu0_mp_state.mp_state == KVM_MP_STATE_HALTED)
+			break;
+	}
+
+	printf("vcpu1: Kicked out vcpu0 and ensure vcpu0 is halted\n");
+
+	/* Use save_restore_vm() to simulate a VM migration. */
+	save_restore_vm(vm);
+
+	printf("vcpu1: Finished save and restore vm.\n");
+	vcpu1 = vm_vcpu_add(vm, VCPU_ID1, l1_vcpu1_guest_code);
+	vcpu_args_set(vcpu1, 1, vmx->posted_intr_desc);
+
+	/* Start an L1 in vcpu1 and send a posted interrupt to halted L2 in vcpu0. */
+	for (;;) {
+		run = vcpu1->run;
+		vcpu_run(vcpu1);
+
+		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+			    "vcpu1: Got exit_reason other than KVM_EXIT_IO: %u (%s)\n",
+			    run->exit_reason,
+			    exit_reason_str(run->exit_reason));
+
+		switch (get_ucall(vcpu1, &uc)) {
+		case UCALL_ABORT:
+			TEST_FAIL("%s", (const char *)uc.args[0]);
+			/* NOT REACHED */
+		case UCALL_DONE:
+			printf("vcpu1: Successfully send a posted interrupt to vcpu0\n");
+			goto done;
+		default:
+			TEST_FAIL("vcpu1: Unknown ucall %lu", uc.cmd);
+		}
+	}
+
+done:
+	/*
+	 * Allow vcpu0 resume execution from L0 userspace and check if the
+	 * posted interrupt get executed.
+	 */
+	WRITE_ONCE(vcpu0_can_run, true);
+	sleep(1);
+	TEST_ASSERT(READ_ONCE(pi_executed),
+		    "vcpu0 did not execute the posted interrupt.\n");
+
+	return NULL;
+}
+
+void sig_handler(int signum, siginfo_t *info, void *context)
+{
+	TEST_ASSERT(pthread_self() == pthread_cpu0,
+		    "Incorrect receiver of the signal, expect pthread_cpu0: "
+		    "%lu, but get: %lu\n", pthread_cpu0, pthread_self());
+	printf("vcpu0: Execute sighandler for signal: %d\n", signum);
+}
+
+int main(int argc, char *argv[])
+{
+	vm_vaddr_t vmx_pages_gva;
+	struct sigaction sig_action;
+	struct sigaction old_action;
+
+	memset(&sig_action, 0, sizeof(sig_action));
+	sig_action.sa_sigaction = sig_handler;
+	sig_action.sa_flags = SA_RESTART | SA_SIGINFO;
+	sigemptyset(&sig_action.sa_mask);
+	sigaction(SIGUSR1, &sig_action, &old_action);
+
+	pthread_cpu0 = pthread_self();
+	printf("vcpu0: Finish setup signal handler for SIGUSR1\n");
+
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_NESTED_STATE));
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
+
+	vm = vm_create_with_one_vcpu(&vcpu0, (void *)l1_vcpu0_guest_code);
+
+	vm_init_descriptor_tables(vm);
+	vcpu_init_descriptor_tables(vcpu0);
+	vm_install_exception_handler(vm, L2_INTR, vcpu0_ipi_handler);
+
+	/* Allocate VMX pages and shared descriptors (vmx_pages). */
+	vmx = vcpu_alloc_vmx(vm, &vmx_pages_gva);
+	prepare_virtual_apic(vmx, vm);
+	prepare_posted_intr_desc(vmx, vm);
+	vcpu_args_set(vcpu0, 1, vmx_pages_gva);
+
+	pthread_create(&pthread_cpu1, NULL, create_and_run_vcpu1, NULL);
+
+	for (;;) {
+		struct kvm_run *run = vcpu0->run;
+		struct ucall uc;
+		int rc;
+
+		while (!READ_ONCE(vcpu0_can_run))
+			;
+
+		WRITE_ONCE(vcpu0_running, true);
+
+		rc = vcpu_run_interruptable(vcpu0);
+
+		/*
+		 * When vCPU is kicked out by a signal, ensure a consistent vCPU
+		 * state to prepare for migration before setting the
+		 * vcpu_running flag to false.
+		 */
+		if (rc == -1 && run->exit_reason == KVM_EXIT_INTR) {
+			vcpu_run_complete_io(vcpu0);
+
+			WRITE_ONCE(vcpu0_running, false);
+
+			continue;
+		}
+
+		WRITE_ONCE(vcpu0_running, false);
+
+		if (run->io.port == PORT_L0_EXIT) {
+			printf("vcpu0: Executed the posted interrupt\n");
+			WRITE_ONCE(pi_executed, true);
+			continue;
+		}
+
+		switch (get_ucall(vcpu0, &uc)) {
+		case UCALL_ABORT:
+			TEST_FAIL("%s", (const char *)uc.args[0]);
+			/* NOT REACHED */
+		case UCALL_DONE:
+			goto done;
+		default:
+			TEST_FAIL("vcpu0: Unknown ucall %lu", uc.cmd);
+		}
+	}
+
+done:
+	kvm_vm_free(vm);
+	return 0;
+}
-- 
2.37.1.455.g008518b4e5-goog

