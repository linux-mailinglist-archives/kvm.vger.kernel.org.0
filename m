Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A63A228AC2
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731314AbgGUVQz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:16:55 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:38060 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731342AbgGUVQO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:16:14 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id A8B9B305D4F4;
        Wed, 22 Jul 2020 00:09:28 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 7F5BD304FA12;
        Wed, 22 Jul 2020 00:09:28 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 60/84] KVM: introspection: add KVMI_EVENT_BREAKPOINT
Date:   Wed, 22 Jul 2020 00:08:58 +0300
Message-Id: <20200721210922.7646-61-alazar@bitdefender.com>
In-Reply-To: <20200721210922.7646-1-alazar@bitdefender.com>
References: <20200721210922.7646-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

This event is sent when a breakpoint was reached.

The introspection tool can place breakpoints and use them as notification
for when the OS or an application has reached a certain state or is
trying to perform a certain operation (eg. create a process).

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 40 ++++++++++++++++
 arch/x86/include/uapi/asm/kvmi.h              |  6 +++
 arch/x86/kvm/kvmi.c                           | 48 +++++++++++++++++++
 arch/x86/kvm/svm/svm.c                        | 34 +++++++++++++
 arch/x86/kvm/vmx/vmx.c                        | 17 +++++--
 include/linux/kvmi_host.h                     |  4 ++
 include/uapi/linux/kvmi.h                     |  1 +
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 46 ++++++++++++++++++
 virt/kvm/introspection/kvmi.c                 | 23 ++++++++-
 virt/kvm/introspection/kvmi_int.h             |  4 ++
 virt/kvm/introspection/kvmi_msg.c             | 17 +++++++
 11 files changed, 235 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index d062f2ccf365..110a6e7a7d2a 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -549,6 +549,7 @@ command) before returning to guest.
 Enables/disables vCPU introspection events. This command can be used with
 the following events::
 
+	KVMI_EVENT_BREAKPOINT
 	KVMI_EVENT_HYPERCALL
 
 When an event is enabled, the introspection tool is notified and
@@ -570,6 +571,9 @@ the *KVMI_VM_CONTROL_EVENTS* command.
 * -KVM_EINVAL - the event ID is unknown (use *KVMI_VM_CHECK_EVENT* first)
 * -KVM_EPERM - the access is disallowed (use *KVMI_VM_CHECK_EVENT* first)
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
+* -KVM_EBUSY - the event can't be intercepted right now
+               (e.g. KVMI_EVENT_BREAKPOINT if the #BP event is already intercepted
+                by userspace)
 
 11. KVMI_VCPU_GET_REGISTERS
 ---------------------------
@@ -820,3 +824,39 @@ It is used by the code residing inside the introspected guest to call the
 introspection tool and to report certain details about its operation. For
 example, a classic antimalware remediation tool can report what it has
 found during a scan.
+
+4. KVMI_EVENT_BREAKPOINT
+------------------------
+
+:Architectures: x86
+:Versions: >= 1
+:Actions: CONTINUE, CRASH, RETRY
+:Parameters:
+
+::
+
+	struct kvmi_event;
+	struct kvmi_event_breakpoint {
+		__u64 gpa;
+		__u8 insn_len;
+		__u8 padding[7];
+	};
+
+:Returns:
+
+::
+
+	struct kvmi_vcpu_hdr;
+	struct kvmi_event_reply;
+
+This event is sent when a breakpoint was reached and the introspection has
+been enabled for this event (see *KVMI_VCPU_CONTROL_EVENTS*).
+
+Some of these breakpoints could have been injected by the introspection tool,
+placed in the slack space of various functions and used as notification
+for when the OS or an application has reached a certain state or is
+trying to perform a certain operation (like creating a process).
+
+``kvmi_event`` and the guest physical address are sent to the introspection tool.
+
+The *RETRY* action is used by the introspection tool for its own breakpoints.
diff --git a/arch/x86/include/uapi/asm/kvmi.h b/arch/x86/include/uapi/asm/kvmi.h
index 9882e68cab75..1605777256a3 100644
--- a/arch/x86/include/uapi/asm/kvmi.h
+++ b/arch/x86/include/uapi/asm/kvmi.h
@@ -59,4 +59,10 @@ struct kvmi_vcpu_get_cpuid_reply {
 	__u32 edx;
 };
 
+struct kvmi_event_breakpoint {
+	__u64 gpa;
+	__u8 insn_len;
+	__u8 padding[7];
+};
+
 #endif /* _UAPI_ASM_X86_KVMI_H */
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 45f1a45d5c0f..f13272350bc9 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -242,3 +242,51 @@ void kvmi_arch_hypercall_event(struct kvm_vcpu *vcpu)
 		kvmi_handle_common_event_actions(vcpu->kvm, action);
 	}
 }
+
+static int kvmi_control_bp_intercept(struct kvm_vcpu *vcpu, bool enable)
+{
+	struct kvm_guest_debug dbg = {};
+	int err = 0;
+
+	if (enable)
+		dbg.control = KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_SW_BP;
+	err = kvm_arch_vcpu_set_guest_debug(vcpu, &dbg);
+
+	return err;
+}
+
+int kvmi_arch_cmd_control_intercept(struct kvm_vcpu *vcpu,
+				    unsigned int event_id, bool enable)
+{
+	int err = 0;
+
+	switch (event_id) {
+	case KVMI_EVENT_BREAKPOINT:
+		err = kvmi_control_bp_intercept(vcpu, enable);
+		break;
+	default:
+		break;
+	}
+
+	return err;
+}
+
+void kvmi_arch_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva, u8 insn_len)
+{
+	u32 action;
+	u64 gpa;
+
+	gpa = kvm_mmu_gva_to_gpa_system(vcpu, gva, 0, NULL);
+
+	action = kvmi_msg_send_bp(vcpu, gpa, insn_len);
+	switch (action) {
+	case KVMI_EVENT_ACTION_CONTINUE:
+		kvm_queue_exception(vcpu, BP_VECTOR);
+		break;
+	case KVMI_EVENT_ACTION_RETRY:
+		/* rip was most likely adjusted past the INT 3 instruction */
+		break;
+	default:
+		kvmi_handle_common_event_actions(vcpu->kvm, action);
+	}
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 580997701b1c..47c50e2f0f86 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -25,6 +25,7 @@
 #include <linux/pagemap.h>
 #include <linux/swap.h>
 #include <linux/rwsem.h>
+#include <linux/kvmi_host.h>
 
 #include <asm/apic.h>
 #include <asm/perf_event.h>
@@ -1841,10 +1842,43 @@ static int db_interception(struct vcpu_svm *svm)
 	return 1;
 }
 
+static unsigned svm_get_instruction_len(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	unsigned long rip = kvm_rip_read(vcpu);
+	unsigned long next_rip = 0;
+	unsigned insn_len;
+
+	if (static_cpu_has(X86_FEATURE_NRIPS))
+		next_rip = svm->vmcb->control.next_rip;
+
+	if (!next_rip) {
+		if (!kvm_emulate_instruction(vcpu, EMULTYPE_SKIP))
+			return 0;
+
+		next_rip = kvm_rip_read(vcpu);
+		kvm_rip_write(vcpu, rip);
+	}
+
+	insn_len = next_rip - rip;
+	if (insn_len > MAX_INST_SIZE) {
+		pr_err("%s: ip 0x%lx next 0x%lx\n",
+		       __func__, rip, next_rip);
+		return 0;
+	}
+
+	return insn_len;
+}
+
 static int bp_interception(struct vcpu_svm *svm)
 {
 	struct kvm_run *kvm_run = svm->vcpu.run;
 
+	if (!kvmi_breakpoint_event(&svm->vcpu, svm->vmcb->save.cs.base +
+					       svm->vmcb->save.rip,
+				   svm_get_instruction_len(&svm->vcpu)))
+		return 1;
+
 	kvm_run->exit_reason = KVM_EXIT_DEBUG;
 	kvm_run->debug.arch.pc = svm->vmcb->save.cs.base + svm->vmcb->save.rip;
 	kvm_run->debug.arch.exception = BP_VECTOR;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4ef4f3c1b78a..9e1bea74b74c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -27,6 +27,7 @@
 #include <linux/slab.h>
 #include <linux/tboot.h>
 #include <linux/trace_events.h>
+#include <linux/kvmi_host.h>
 
 #include <asm/apic.h>
 #include <asm/asm.h>
@@ -4798,7 +4799,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct kvm_run *kvm_run = vcpu->run;
 	u32 intr_info, ex_no, error_code;
-	unsigned long cr2, rip, dr6;
+	unsigned long cr2, dr6;
 	u32 vect_info;
 
 	vect_info = vmx->idt_vectoring_info;
@@ -4871,7 +4872,10 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 		kvm_run->debug.arch.dr6 = dr6 | DR6_FIXED_1 | DR6_RTM;
 		kvm_run->debug.arch.dr7 = vmcs_readl(GUEST_DR7);
 		/* fall through */
-	case BP_VECTOR:
+	case BP_VECTOR: {
+		unsigned long gva = vmcs_readl(GUEST_CS_BASE) +
+			kvm_rip_read(vcpu);
+
 		/*
 		 * Update instruction length as we may reinject #BP from
 		 * user space while in guest debugging mode. Reading it for
@@ -4879,11 +4883,16 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 		 */
 		vmx->vcpu.arch.event_exit_inst_len =
 			vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
+
+		if (!kvmi_breakpoint_event(vcpu, gva,
+					   vmx->vcpu.arch.event_exit_inst_len))
+			return 1;
+
 		kvm_run->exit_reason = KVM_EXIT_DEBUG;
-		rip = kvm_rip_read(vcpu);
-		kvm_run->debug.arch.pc = vmcs_readl(GUEST_CS_BASE) + rip;
+		kvm_run->debug.arch.pc = gva;
 		kvm_run->debug.arch.exception = ex_no;
 		break;
+	}
 	case AC_VECTOR:
 		if (guest_inject_ac(vcpu)) {
 			kvm_queue_exception_e(vcpu, AC_VECTOR, error_code);
diff --git a/include/linux/kvmi_host.h b/include/linux/kvmi_host.h
index 5c4b9c160019..c4fac41bd5c7 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -73,6 +73,7 @@ int kvmi_ioctl_preunhook(struct kvm *kvm);
 
 void kvmi_handle_requests(struct kvm_vcpu *vcpu);
 bool kvmi_hypercall_event(struct kvm_vcpu *vcpu);
+bool kvmi_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva, u8 insn_len);
 
 #else
 
@@ -84,6 +85,9 @@ static inline void kvmi_vcpu_uninit(struct kvm_vcpu *vcpu) { }
 
 static inline void kvmi_handle_requests(struct kvm_vcpu *vcpu) { }
 static inline bool kvmi_hypercall_event(struct kvm_vcpu *vcpu) { return false; }
+static inline bool kvmi_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva,
+					 u8 insn_len)
+			{ return true; }
 
 #endif /* CONFIG_KVM_INTROSPECTION */
 
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 7d1febd671d7..026ae5911b1c 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -39,6 +39,7 @@ enum {
 	KVMI_EVENT_UNHOOK     = 0,
 	KVMI_EVENT_PAUSE_VCPU = 1,
 	KVMI_EVENT_HYPERCALL  = 2,
+	KVMI_EVENT_BREAKPOINT = 3,
 
 	KVMI_NUM_EVENTS
 };
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 3a76842e48c6..3b921e3cf958 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -49,6 +49,7 @@ struct vcpu_worker_data {
 
 enum {
 	GUEST_TEST_NOOP = 0,
+	GUEST_TEST_BP,
 	GUEST_TEST_HYPERCALL,
 };
 
@@ -63,6 +64,11 @@ static int guest_test_id(void)
 	return READ_ONCE(test_id);
 }
 
+static void guest_bp_test(void)
+{
+	asm volatile("int3");
+}
+
 static void guest_hypercall_test(void)
 {
 	asm volatile("mov $34, %rax");
@@ -77,6 +83,9 @@ static void guest_code(void)
 		switch (guest_test_id()) {
 		case GUEST_TEST_NOOP:
 			break;
+		case GUEST_TEST_BP:
+			guest_bp_test();
+			break;
 		case GUEST_TEST_HYPERCALL:
 			guest_hypercall_test();
 			break;
@@ -1107,6 +1116,42 @@ static void test_event_hypercall(struct kvm_vm *vm)
 	disable_vcpu_event(vm, event_id);
 }
 
+static void test_event_breakpoint(struct kvm_vm *vm)
+{
+	struct vcpu_worker_data data = {
+		.vm = vm,
+		.vcpu_id = VCPU_ID,
+		.test_id = GUEST_TEST_BP,
+	};
+	struct kvmi_msg_hdr hdr;
+	struct {
+		struct kvmi_event common;
+		struct kvmi_event_breakpoint bp;
+	} ev;
+	struct vcpu_reply rpl = {};
+	__u16 event_id = KVMI_EVENT_BREAKPOINT;
+	pthread_t vcpu_thread;
+
+	enable_vcpu_event(vm, event_id);
+
+	vcpu_thread = start_vcpu_worker(&data);
+
+	receive_event(&hdr, &ev.common, sizeof(ev), event_id);
+
+	pr_info("Breakpoint event, rip 0x%llx, len %u\n",
+		ev.common.arch.regs.rip, ev.bp.insn_len);
+
+	ev.common.arch.regs.rip += ev.bp.insn_len;
+	__set_registers(vm, &ev.common.arch.regs);
+
+	reply_to_event(&hdr, &ev.common, KVMI_EVENT_ACTION_RETRY,
+			&rpl, sizeof(rpl));
+
+	stop_vcpu_worker(vcpu_thread, &data);
+
+	disable_vcpu_event(vm, event_id);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	srandom(time(0));
@@ -1128,6 +1173,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vcpu_set_registers(vm);
 	test_cmd_vcpu_get_cpuid(vm);
 	test_event_hypercall(vm);
+	test_event_breakpoint(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 571b79c52353..a5264696c630 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -97,6 +97,7 @@ static void setup_known_events(void)
 	set_bit(KVMI_EVENT_UNHOOK, Kvmi_known_vm_events);
 
 	bitmap_zero(Kvmi_known_vcpu_events, KVMI_NUM_EVENTS);
+	set_bit(KVMI_EVENT_BREAKPOINT, Kvmi_known_vcpu_events);
 	set_bit(KVMI_EVENT_HYPERCALL, Kvmi_known_vcpu_events);
 	set_bit(KVMI_EVENT_PAUSE_VCPU, Kvmi_known_vcpu_events);
 
@@ -637,7 +638,7 @@ int kvmi_cmd_vcpu_control_events(struct kvm_vcpu *vcpu,
 	else
 		clear_bit(event_id, vcpui->ev_enable_mask);
 
-	return 0;
+	return kvmi_arch_cmd_control_intercept(vcpu, event_id, enable);
 }
 
 static unsigned long gfn_to_hva_safe(struct kvm *kvm, gfn_t gfn)
@@ -908,3 +909,23 @@ bool kvmi_hypercall_event(struct kvm_vcpu *vcpu)
 
 	return ret;
 }
+
+bool kvmi_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva, u8 insn_len)
+{
+	struct kvm_introspection *kvmi;
+	bool ret = false;
+
+	kvmi = kvmi_get(vcpu->kvm);
+	if (!kvmi)
+		return true;
+
+	if (is_event_enabled(vcpu, KVMI_EVENT_BREAKPOINT))
+		kvmi_arch_breakpoint_event(vcpu, gva, insn_len);
+	else
+		ret = true;
+
+	kvmi_put(vcpu->kvm);
+
+	return ret;
+}
+EXPORT_SYMBOL(kvmi_breakpoint_event);
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 8c02528e3056..810dde913ad6 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -34,6 +34,7 @@ bool kvmi_msg_process(struct kvm_introspection *kvmi);
 int kvmi_msg_send_unhook(struct kvm_introspection *kvmi);
 u32 kvmi_msg_send_vcpu_pause(struct kvm_vcpu *vcpu);
 u32 kvmi_msg_send_hypercall(struct kvm_vcpu *vcpu);
+u32 kvmi_msg_send_bp(struct kvm_vcpu *vcpu, u64 gpa, u8 insn_len);
 
 /* kvmi.c */
 void *kvmi_msg_alloc(void);
@@ -79,5 +80,8 @@ int kvmi_arch_cmd_vcpu_get_cpuid(struct kvm_vcpu *vcpu,
 				 struct kvmi_vcpu_get_cpuid_reply *rpl);
 bool kvmi_arch_is_agent_hypercall(struct kvm_vcpu *vcpu);
 void kvmi_arch_hypercall_event(struct kvm_vcpu *vcpu);
+void kvmi_arch_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva, u8 insn_len);
+int kvmi_arch_cmd_control_intercept(struct kvm_vcpu *vcpu,
+				    unsigned int event_id, bool enable);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 80ade6055747..4a03980e0bbb 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -805,3 +805,20 @@ u32 kvmi_msg_send_hypercall(struct kvm_vcpu *vcpu)
 
 	return action;
 }
+
+u32 kvmi_msg_send_bp(struct kvm_vcpu *vcpu, u64 gpa, u8 insn_len)
+{
+	struct kvmi_event_breakpoint e;
+	int err, action;
+
+	memset(&e, 0, sizeof(e));
+	e.gpa = gpa;
+	e.insn_len = insn_len;
+
+	err = kvmi_send_event(vcpu, KVMI_EVENT_BREAKPOINT, &e, sizeof(e),
+			      NULL, 0, &action);
+	if (err)
+		return KVMI_EVENT_ACTION_CONTINUE;
+
+	return action;
+}
