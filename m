Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF7B11DA46D
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 00:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728033AbgESWW7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 May 2020 18:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727097AbgESWW6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 May 2020 18:22:58 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC33C08C5C0
        for <kvm@vger.kernel.org>; Tue, 19 May 2020 15:22:58 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id d19so1598831qkj.21
        for <kvm@vger.kernel.org>; Tue, 19 May 2020 15:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=qbjnIgYBJ3XppSXgQQQYeUiA93XhGIz1VXZs5463P7w=;
        b=INoq135MwddeHyFBkmiondf71do3Nzz5lwylPFHbOK5l3cTNU7A9vM93LJJuHe7+go
         qvlknWBVY7DOl0zF5x5vedOGuoQv/OwNxT2wV6YvCNHSQudFssZWNZmzxQtcKHAbuoek
         TeWqQ3EfNXipokk/Hm5Lgldw+pUM3SUSS17kox7j8AdxI6q84seLBmno+VjTRTHJyLXH
         onLXWDIvq5asksLTeMzCl/xOdmjTOWG3t+YoaA5n+z0jYZalZmzHhHIoRTrrNF/+ZJUf
         GkMjBEZN3eh6F0jkymK3GmDjaQE7wOaeUl015af6NA2xiUU10YGze4Pqbn0+XYZDLloo
         17cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=qbjnIgYBJ3XppSXgQQQYeUiA93XhGIz1VXZs5463P7w=;
        b=b3UpS/HALGqGt24cy8UppID+RwY62hd2yTdNiO0h1GwLHI5a9eTZW6FC0DzIxLaIHU
         3rVLJTxHOXbhIMpbQMkf/+45frJ52lRqpvGGXv8cCbmWyB39sfj+q46AKZigEiJjkpeK
         xjI3e2wxARZQxt1AirDTy0JqMTuqCB+T2eTL3qBSsaM9K63oQra5/mNM+SE9WaEkSUar
         qGA1T/7BaYPcNDaXD5rFsuYI2yC7nOgx7vrKFpPhxFA4NYwknJvJte7TXyyECaZ3by/l
         2ZJVKrn/QwSYdFs2vBtiTSLRMCVpKinl7ktr66tLn7N4NvXfQebCB9Vc7ItNH1cr/FaN
         Ze4w==
X-Gm-Message-State: AOAM5317ZkzkVfgOL4PllxLsvFJM+Ip6SkX9gqbswHyZru0ZfDU05UYJ
        J9bhuttMBzMQM4wf6+qmEg7Fjc7/tCuWMgKZliJyOfTU3JeHYVmVrKPC74BC/KBys6HV5uy1XF9
        Al0jwoWbkb7jxAlZfQ1r9DaJnodDbgVxy7YbnYz/peSZq79Ayu79XK8shiSDuRUqUwtrhF478mQ
        0MSYw=
X-Google-Smtp-Source: ABdhPJz9Ek7cEnnPCPkoDny99Hshm4lGjHn+ctBh/26ElC2yGLSEfafQoXOoVDhsi4tv9Hxiff+bgT7e2TeYLEN4rwTx0w==
X-Received: by 2002:a5b:58a:: with SMTP id l10mr2498710ybp.483.1589926977413;
 Tue, 19 May 2020 15:22:57 -0700 (PDT)
Date:   Tue, 19 May 2020 15:22:38 -0700
In-Reply-To: <20200519222238.213574-1-makarandsonare@google.com>
Message-Id: <20200519222238.213574-3-makarandsonare@google.com>
Mime-Version: 1.0
References: <20200519222238.213574-1-makarandsonare@google.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH  v2 2/2] KVM: selftests: VMX preemption timer migration test
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
Change-Id: Ia79337c682ee161399525edc34201fad473fc190
---
 tools/arch/x86/include/uapi/asm/kvm.h         |   1 +
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/include/kvm_util.h  |   2 +
 .../selftests/kvm/include/x86_64/processor.h  |  11 +-
 .../selftests/kvm/include/x86_64/vmx.h        |  27 ++
 .../kvm/x86_64/vmx_preemption_timer_test.c    | 257 ++++++++++++++++++
 7 files changed, 296 insertions(+), 4 deletions(-)
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
index 0000000000000..83e363260e145
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
@@ -0,0 +1,257 @@
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
+	GUEST_ASSERT(!vmlaunch());
+	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_VMCALL);
+	vmwrite(GUEST_RIP, vmreadz(GUEST_RIP) + 3);
+
+	/*
+	 * Check for Preemption timer support and turn on PIN control
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
+		 * is as expected
+		 */
+		if (stage == 2) {
+
+			pr_info("Stage %d: L1 PT expiry TSC (%lu) , L1 TSC deadline (%lu)\n",
+				stage, uc.args[2], uc.args[3]);
+
+			pr_info("Stage %d: L2 PT expiry TSC (%lu) , L2 TSC deadline (%lu)\n",
+				stage, uc.args[4], uc.args[5]);
+
+			/*
+			 * From L1's perspective verify Preemption timer hasn't
+			 * expired too early
+			 */
+
+			TEST_ASSERT(uc.args[2] >= uc.args[3],
+				"Stage %d: L1 PT expiry TSC (%lu) < L1 TSC deadline (%lu)",
+				stage, uc.args[2], uc.args[3]);
+
+			/*
+			 * From L2's perspective verify Preemption timer hasn't
+			 * expired too late
+			 */
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
2.26.2.761.g0e0b3e54be-goog

