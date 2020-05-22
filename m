Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E411DDEF0
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 06:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgEVEgx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 00:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726910AbgEVEgw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 00:36:52 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77139C05BD43
        for <kvm@vger.kernel.org>; Thu, 21 May 2020 21:36:52 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id d145so1259973qkg.22
        for <kvm@vger.kernel.org>; Thu, 21 May 2020 21:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=6BSJUwn39A2bzFJk4zAD9K55fP2QZLzeYCaME2UR9Xg=;
        b=UwyWFBjzND/CwFXQd4rh0HsIYJdzusALIXrWnxfsmNd71zE/32koLy+KWSRmTPX1Vc
         kZqqJEvmpSa6Z+H5FOO/Z5D/LhrRRInpnSAtOZnGQJulPYmZCgp22QAYOSmYLURBn8FR
         EWwnROeHVoBGd/rQJB1a9BuyRuiyI9+uv3ZmPD/nFYA/9kGpDrsdTKZQvWEXB+2q8HpO
         TAZMM0iddJZIz2AuzE6ouwoZXhwZRaUTDN2+Fk7ULgYThlWm6fRbzMfBh6met72Fn6ZT
         433D17tiJm3pN3PXy7dT1ZpiOkyMpk61cwBJJRAQ33KUR63Oq1vJ+j0drK1vgk1D62d6
         Nuxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=6BSJUwn39A2bzFJk4zAD9K55fP2QZLzeYCaME2UR9Xg=;
        b=WisI67DxIQCHk12/PBegGzZox2HHWN/qxOmHJ5icedZKbxmjG3mq6TXyNXWALvoWMz
         M6TtHJvrC96fhsVYcDQIEKpuFN/W2LTNCzsuvR+22qxV0JQluMfNrrt1sAMdCHJhH0E8
         ivdFEfvxrP/crGkjdelIEYccFzW7DC8daDA96A1k6N5w03bUznGqaVEzzOtyU8EQATw9
         PaLx+JFNTn76UqJBfA4MvvDOa0Svlfvt3e3ljWgEeoMLmSSvIvKzHKRwrX9Km8nUFMhL
         16Ci5QwStLF/XpKvZMpR+FgI7RicWQXEJBj2JNeka3/inbutfvZrgV+u6rfUkJQMePZY
         UM5g==
X-Gm-Message-State: AOAM531cfyPFdj+HLMqmddiOX4PeDchoTDwAZfcDaAHcmjpXyj3+S+XR
        YPoM+u0ASeHGNktYuKKL1yTmaFGTWNUr1JutSZr0kTe+aC9y/ZQpgVHb1NF2ahUjyj1DMXLHUWd
        Ev/TB4R8WPtoeFQ55c3gYVukPxp9sv0H6+vir1oAildljCdMCxXHAyPi/UG9K6jWWKt58vglQMY
        AJthM=
X-Google-Smtp-Source: ABdhPJxv+xngCG6xRsxLlyrav+/cPkohCd+OuDBqFVm5NMZzS6SlKNFMXSnjo/UimqFoCLckh+4oMcLT9K73Kw2UOSETLQ==
X-Received: by 2002:a05:6214:1908:: with SMTP id er8mr727025qvb.239.1590122211424;
 Thu, 21 May 2020 21:36:51 -0700 (PDT)
Date:   Thu, 21 May 2020 21:36:34 -0700
In-Reply-To: <20200522043634.79779-1-makarandsonare@google.com>
Message-Id: <20200522043634.79779-3-makarandsonare@google.com>
Mime-Version: 1.0
References: <20200522043634.79779-1-makarandsonare@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH  2/2 v4] KVM: selftests: VMX preemption timer migration test
From:   Makarand Sonare <makarandsonare@google.com>
To:     kvm@vger.kernel.org, pshier@google.com, jmattson@google.com
Cc:     Makarand Sonare <makarandsonare@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a nested VM with a VMX-preemption timer is migrated, verify that the
nested VM and its parent VM observe the VMX-preemption timer exit close to
the original expiration deadline.

Signed-off-by: Makarand Sonare <makarandsonare@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 tools/arch/x86/include/uapi/asm/kvm.h         |   1 +
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/include/kvm_util.h  |   2 +
 .../selftests/kvm/include/x86_64/processor.h  |  11 +-
 .../selftests/kvm/include/x86_64/vmx.h        |  27 ++
 .../kvm/x86_64/vmx_preemption_timer_test.c    | 255 ++++++++++++++++++
 7 files changed, 294 insertions(+), 4 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c

diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
index 3f3f780c8c650..43e24903812c4 100644
--- a/tools/arch/x86/include/uapi/asm/kvm.h
+++ b/tools/arch/x86/include/uapi/asm/kvm.h
@@ -400,6 +400,7 @@ struct kvm_sync_regs {
 struct kvm_vmx_nested_state_data {
 	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
 	__u8 shadow_vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
+	__u64 preemption_timer_deadline;
 };

 struct kvm_vmx_nested_state_hdr {
diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 222e50104296a..f159718f90c0a 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -10,6 +10,7 @@
 /x86_64/set_sregs_test
 /x86_64/smm_test
 /x86_64/state_test
+/x86_64/vmx_preemption_timer_test
 /x86_64/svm_vmcall_test
 /x86_64/sync_regs_test
 /x86_64/vmx_close_while_nested_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index c66f4eec34111..780f0c189a7bc 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -20,6 +20,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
 TEST_GEN_PROGS_x86_64 += x86_64/set_sregs_test
 TEST_GEN_PROGS_x86_64 += x86_64/smm_test
 TEST_GEN_PROGS_x86_64 += x86_64/state_test
+TEST_GEN_PROGS_x86_64 += x86_64/vmx_preemption_timer_test
 TEST_GEN_PROGS_x86_64 += x86_64/svm_vmcall_test
 TEST_GEN_PROGS_x86_64 += x86_64/sync_regs_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index e244c6ecfc1d5..919e161dd2893 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -314,6 +314,8 @@ void ucall_uninit(struct kvm_vm *vm);
 void ucall(uint64_t cmd, int nargs, ...);
 uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc);

+#define GUEST_SYNC_ARGS(stage, arg1, arg2, arg3, arg4)	\
+				ucall(UCALL_SYNC, 6, "hello", stage, arg1, arg2, arg3, arg4)
 #define GUEST_SYNC(stage)	ucall(UCALL_SYNC, 2, "hello", stage)
 #define GUEST_DONE()		ucall(UCALL_DONE, 0)
 #define __GUEST_ASSERT(_condition, _nargs, _args...) do {	\
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 7428513a4c687..7cb19eca6c72d 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -79,13 +79,16 @@ static inline uint64_t get_desc64_base(const struct desc64 *desc)
 static inline uint64_t rdtsc(void)
 {
 	uint32_t eax, edx;
-
+	uint32_t tsc_val;
 	/*
 	 * The lfence is to wait (on Intel CPUs) until all previous
-	 * instructions have been executed.
+	 * instructions have been executed. If software requires RDTSC to be
+	 * executed prior to execution of any subsequent instruction, it can
+	 * execute LFENCE immediately after RDTSC
 	 */
-	__asm__ __volatile__("lfence; rdtsc" : "=a"(eax), "=d"(edx));
-	return ((uint64_t)edx) << 32 | eax;
+	__asm__ __volatile__("lfence; rdtsc; lfence" : "=a"(eax), "=d"(edx));
+	tsc_val = ((uint64_t)edx) << 32 | eax;
+	return tsc_val;
 }

 static inline uint64_t rdtscp(uint32_t *aux)
diff --git a/tools/testing/selftests/kvm/include/x86_64/vmx.h b/tools/testing/selftests/kvm/include/x86_64/vmx.h
index 3d27069b9ed9c..ccff3e6e27048 100644
--- a/tools/testing/selftests/kvm/include/x86_64/vmx.h
+++ b/tools/testing/selftests/kvm/include/x86_64/vmx.h
@@ -575,6 +575,33 @@ struct vmx_pages {
 	void *eptp;
 };

+union vmx_basic {
+	u64 val;
+	struct {
+		u32 revision;
+		u32	size:13,
+			reserved1:3,
+			width:1,
+			dual:1,
+			type:4,
+			insouts:1,
+			ctrl:1,
+			vm_entry_exception_ctrl:1,
+			reserved2:7;
+	};
+};
+
+union vmx_ctrl_msr {
+	u64 val;
+	struct {
+		u32 set, clr;
+	};
+};
+
+union vmx_basic basic;
+union vmx_ctrl_msr ctrl_pin_rev;
+union vmx_ctrl_msr ctrl_exit_rev;
+
 struct vmx_pages *vcpu_alloc_vmx(struct kvm_vm *vm, vm_vaddr_t *p_vmx_gva);
 bool prepare_for_vmx_operation(struct vmx_pages *vmx);
 void prepare_vmcs(struct vmx_pages *vmx, void *guest_rip, void *guest_rsp);
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c b/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
new file mode 100644
index 0000000000000..e2f5dccb4d5ba
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
@@ -0,0 +1,255 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * VMX-preemption timer test
+ *
+ * Copyright (C) 2020, Google, LLC.
+ *
+ * Test to ensure the VM-Enter after migration doesn't
+ * incorrectly restarts the timer with the full timer
+ * value instead of partially decayed timer value
+ *
+ */
+#define _GNU_SOURCE /* for program_invocation_short_name */
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+
+#include "test_util.h"
+
+#include "kvm_util.h"
+#include "processor.h"
+#include "vmx.h"
+
+#define VCPU_ID		5
+#define PREEMPTION_TIMER_VALUE			100000000ull
+#define PREEMPTION_TIMER_VALUE_THRESHOLD1	 80000000ull
+
+u32 vmx_pt_rate;
+bool l2_save_restore_done;
+static u64 l2_vmx_pt_start;
+volatile u64 l2_vmx_pt_finish;
+
+void l2_guest_code(void)
+{
+	u64 vmx_pt_delta;
+
+	vmcall();
+	l2_vmx_pt_start = (rdtsc() >> vmx_pt_rate) << vmx_pt_rate;
+
+	/*
+	 * Wait until the 1st threshold has passed
+	 */
+	do {
+		l2_vmx_pt_finish = rdtsc();
+		vmx_pt_delta = (l2_vmx_pt_finish - l2_vmx_pt_start) >>
+				vmx_pt_rate;
+	} while (vmx_pt_delta < PREEMPTION_TIMER_VALUE_THRESHOLD1);
+
+	/*
+	 * Force L2 through Save and Restore cycle
+	 */
+	GUEST_SYNC(1);
+
+	l2_save_restore_done = 1;
+
+	/*
+	 * Now wait for the preemption timer to fire and
+	 * exit to L1
+	 */
+	while ((l2_vmx_pt_finish = rdtsc()))
+		;
+}
+
+void l1_guest_code(struct vmx_pages *vmx_pages)
+{
+#define L2_GUEST_STACK_SIZE 64
+	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+	u64 l1_vmx_pt_start;
+	u64 l1_vmx_pt_finish;
+	u64 l1_tsc_deadline, l2_tsc_deadline;
+
+	GUEST_ASSERT(vmx_pages->vmcs_gpa);
+	GUEST_ASSERT(prepare_for_vmx_operation(vmx_pages));
+	GUEST_ASSERT(load_vmcs(vmx_pages));
+	GUEST_ASSERT(vmptrstz() == vmx_pages->vmcs_gpa);
+
+	prepare_vmcs(vmx_pages, l2_guest_code,
+		     &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+
+	/*
+	 * Check for Preemption timer support
+	 */
+	basic.val = rdmsr(MSR_IA32_VMX_BASIC);
+	ctrl_pin_rev.val = rdmsr(basic.ctrl ? MSR_IA32_VMX_TRUE_PINBASED_CTLS
+			: MSR_IA32_VMX_PINBASED_CTLS);
+	ctrl_exit_rev.val = rdmsr(basic.ctrl ? MSR_IA32_VMX_TRUE_EXIT_CTLS
+			: MSR_IA32_VMX_EXIT_CTLS);
+
+	if (!(ctrl_pin_rev.clr & PIN_BASED_VMX_PREEMPTION_TIMER) ||
+	    !(ctrl_exit_rev.clr & VM_EXIT_SAVE_VMX_PREEMPTION_TIMER))
+		return;
+
+	GUEST_ASSERT(!vmlaunch());
+	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_VMCALL);
+	vmwrite(GUEST_RIP, vmreadz(GUEST_RIP) + vmreadz(VM_EXIT_INSTRUCTION_LEN));
+
+	/*
+	 * Turn on PIN control and resume the guest
+	 */
+	GUEST_ASSERT(!vmwrite(PIN_BASED_VM_EXEC_CONTROL,
+			      vmreadz(PIN_BASED_VM_EXEC_CONTROL) |
+			      PIN_BASED_VMX_PREEMPTION_TIMER));
+
+	GUEST_ASSERT(!vmwrite(VMX_PREEMPTION_TIMER_VALUE,
+			      PREEMPTION_TIMER_VALUE));
+
+	vmx_pt_rate = rdmsr(MSR_IA32_VMX_MISC) & 0x1F;
+
+	l2_save_restore_done = 0;
+
+	l1_vmx_pt_start = (rdtsc() >> vmx_pt_rate) << vmx_pt_rate;
+
+	GUEST_ASSERT(!vmresume());
+
+	l1_vmx_pt_finish = rdtsc();
+
+	/*
+	 * Ensure exit from L2 happens after L2 goes through
+	 * save and restore
+	 */
+	GUEST_ASSERT(l2_save_restore_done);
+
+	/*
+	 * Ensure the exit from L2 is due to preemption timer expiry
+	 */
+	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_PREEMPTION_TIMER);
+
+	l1_tsc_deadline = l1_vmx_pt_start +
+		(PREEMPTION_TIMER_VALUE << vmx_pt_rate);
+
+	l2_tsc_deadline = l2_vmx_pt_start +
+		(PREEMPTION_TIMER_VALUE << vmx_pt_rate);
+
+	/*
+	 * Sync with the host and pass the l1|l2 pt_expiry_finish times and
+	 * tsc deadlines so that host can verify they are as expected
+	 */
+	GUEST_SYNC_ARGS(2, l1_vmx_pt_finish, l1_tsc_deadline,
+		l2_vmx_pt_finish, l2_tsc_deadline);
+}
+
+void guest_code(struct vmx_pages *vmx_pages)
+{
+	if (vmx_pages)
+		l1_guest_code(vmx_pages);
+
+	GUEST_DONE();
+}
+
+int main(int argc, char *argv[])
+{
+	vm_vaddr_t vmx_pages_gva = 0;
+
+	struct kvm_regs regs1, regs2;
+	struct kvm_vm *vm;
+	struct kvm_run *run;
+	struct kvm_x86_state *state;
+	struct ucall uc;
+	int stage;
+
+	/*
+	 * AMD currently does not implement any VMX features, so for now we
+	 * just early out.
+	 */
+	nested_vmx_check_supported();
+
+	/* Create VM */
+	vm = vm_create_default(VCPU_ID, 0, guest_code);
+	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
+	run = vcpu_state(vm, VCPU_ID);
+
+	vcpu_regs_get(vm, VCPU_ID, &regs1);
+
+	if (kvm_check_cap(KVM_CAP_NESTED_STATE_PREEMPTION_TIMER)) {
+		vcpu_alloc_vmx(vm, &vmx_pages_gva);
+		vcpu_args_set(vm, VCPU_ID, 1, vmx_pages_gva);
+	} else {
+		pr_info("will skip vmx preemption timer checks\n");
+		goto done;
+	}
+
+	for (stage = 1;; stage++) {
+		_vcpu_run(vm, VCPU_ID);
+		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+			    "Stage %d: unexpected exit reason: %u (%s),\n",
+			    stage, run->exit_reason,
+			    exit_reason_str(run->exit_reason));
+
+		switch (get_ucall(vm, VCPU_ID, &uc)) {
+		case UCALL_ABORT:
+			TEST_FAIL("%s at %s:%ld", (const char *)uc.args[0],
+				  __FILE__, uc.args[1]);
+			/* NOT REACHED */
+		case UCALL_SYNC:
+			break;
+		case UCALL_DONE:
+			goto done;
+		default:
+			TEST_FAIL("Unknown ucall %lu", uc.cmd);
+		}
+
+		/* UCALL_SYNC is handled here.  */
+		TEST_ASSERT(!strcmp((const char *)uc.args[0], "hello") &&
+			    uc.args[1] == stage, "Stage %d: Unexpected register values vmexit, got %lx",
+			    stage, (ulong)uc.args[1]);
+		/*
+		 * If this stage 2 then we should verify the vmx pt expiry
+		 * is as expected.
+		 * From L1's perspective verify Preemption timer hasn't
+		 * expired too early.
+		 * From L2's perspective verify Preemption timer hasn't
+		 * expired too late.
+		 */
+		if (stage == 2) {
+
+			pr_info("Stage %d: L1 PT expiry TSC (%lu) , L1 TSC deadline (%lu)\n",
+				stage, uc.args[2], uc.args[3]);
+
+			pr_info("Stage %d: L2 PT expiry TSC (%lu) , L2 TSC deadline (%lu)\n",
+				stage, uc.args[4], uc.args[5]);
+
+			TEST_ASSERT(uc.args[2] >= uc.args[3],
+				"Stage %d: L1 PT expiry TSC (%lu) < L1 TSC deadline (%lu)",
+				stage, uc.args[2], uc.args[3]);
+
+			TEST_ASSERT(uc.args[4] < uc.args[5],
+				"Stage %d: L2 PT expiry TSC (%lu) > L2 TSC deadline (%lu)",
+				stage, uc.args[4], uc.args[5]);
+		}
+
+		state = vcpu_save_state(vm, VCPU_ID);
+		memset(&regs1, 0, sizeof(regs1));
+		vcpu_regs_get(vm, VCPU_ID, &regs1);
+
+		kvm_vm_release(vm);
+
+		/* Restore state in a new VM.  */
+		kvm_vm_restart(vm, O_RDWR);
+		vm_vcpu_add(vm, VCPU_ID);
+		vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
+		vcpu_load_state(vm, VCPU_ID, state);
+		run = vcpu_state(vm, VCPU_ID);
+		free(state);
+
+		memset(&regs2, 0, sizeof(regs2));
+		vcpu_regs_get(vm, VCPU_ID, &regs2);
+		TEST_ASSERT(!memcmp(&regs1, &regs2, sizeof(regs2)),
+			    "Unexpected register values after vcpu_load_state; rdi: %lx rsi: %lx",
+			    (ulong) regs2.rdi, (ulong) regs2.rsi);
+	}
+
+done:
+	kvm_vm_free(vm);
+}
--
2.27.0.rc0.183.gde8f92d652-goog

