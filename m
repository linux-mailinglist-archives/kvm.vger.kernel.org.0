Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 295512D1B28
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 21:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbgLGUsh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 15:48:37 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:42604 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727368AbgLGUsg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 15:48:36 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 1E521305D478;
        Mon,  7 Dec 2020 22:46:22 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id DF5543072785;
        Mon,  7 Dec 2020 22:46:21 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v11 57/81] KVM: introspection: add KVMI_VCPU_EVENT_BREAKPOINT
Date:   Mon,  7 Dec 2020 22:45:58 +0200
Message-Id: <20201207204622.15258-58-alazar@bitdefender.com>
In-Reply-To: <20201207204622.15258-1-alazar@bitdefender.com>
References: <20201207204622.15258-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

This event is sent when a breakpoint was reached.

The introspection tool can place breakpoints and use them as notification
for when the OS or an application has reached a certain state or is
trying to perform a certain operation (eg. create a process).

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Nicușor Cîțu <nicu.citu@icloud.com>
Signed-off-by: Nicușor Cîțu <nicu.citu@icloud.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 48 ++++++++++++++++++
 arch/x86/kvm/kvmi.c                           | 50 +++++++++++++++++++
 arch/x86/kvm/svm/svm.c                        | 34 +++++++++++++
 arch/x86/kvm/vmx/vmx.c                        | 17 +++++--
 include/linux/kvmi_host.h                     |  3 ++
 include/uapi/linux/kvmi.h                     | 11 +++-
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 46 +++++++++++++++++
 virt/kvm/introspection/kvmi.c                 | 25 ++++++++++
 virt/kvm/introspection/kvmi_int.h             |  4 ++
 virt/kvm/introspection/kvmi_msg.c             | 18 +++++++
 10 files changed, 250 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 023c885638af..c89f383e48f9 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -538,6 +538,7 @@ command) before returning to guest.
 Enables/disables vCPU introspection events. This command can be used with
 the following events::
 
+	KVMI_VCPU_EVENT_BREAKPOINT
 	KVMI_VCPU_EVENT_HYPERCALL
 
 When an event is enabled, the introspection tool is notified and
@@ -559,6 +560,9 @@ the *KVMI_VM_CONTROL_EVENTS* command.
 * -KVM_EINVAL - the event ID is unknown (use *KVMI_VM_CHECK_EVENT* first)
 * -KVM_EPERM - the access is disallowed (use *KVMI_VM_CHECK_EVENT* first)
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
+* -KVM_EBUSY - the event can't be intercepted right now
+               (e.g. KVMI_VCPU_EVENT_BREAKPOINT if the #BP event
+                is already intercepted by userspace)
 
 11. KVMI_VCPU_GET_REGISTERS
 ---------------------------
@@ -817,3 +821,47 @@ found during a scan.
 
 The most useful registers describing the vCPU state can be read from
 ``kvmi_vcpu_event.arch.regs``.
+
+4. KVMI_VCPU_EVENT_BREAKPOINT
+-----------------------------
+
+:Architectures: x86
+:Versions: >= 1
+:Actions: CONTINUE, CRASH, RETRY
+:Parameters:
+
+::
+
+	struct kvmi_event_hdr;
+	struct kvmi_vcpu_event;
+	struct kvmi_vcpu_event_breakpoint {
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
+	struct kvmi_vcpu_event_reply;
+
+This event is sent when a breakpoint was reached and the introspection has
+been enabled for this event (see *KVMI_VCPU_CONTROL_EVENTS*).
+
+Some of these breakpoints could have been injected by the introspection tool,
+placed in the slack space of various functions and used as notification
+for when the OS or an application has reached a certain state or is
+trying to perform a certain operation (like creating a process).
+
+``kvmi_vcpu_event`` (with the vCPU state), the guest physical address
+(``gpa``) where the breakpoint instruction is placed and the breakpoint
+instruction length (``insn_len``) are sent to the introspection tool.
+
+The *RETRY* action is used by the introspection tool for its own
+breakpoints. In most cases, the tool will change the instruction pointer
+before returning this action.
+
+The *CONTINUE* action will cause the breakpoint exception to be reinjected
+(the OS will handle it).
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 5f08cf0d19bc..0bb6f38f1213 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -11,6 +11,7 @@
 
 void kvmi_arch_init_vcpu_events_mask(unsigned long *supported)
 {
+	set_bit(KVMI_VCPU_EVENT_BREAKPOINT, supported);
 	set_bit(KVMI_VCPU_EVENT_HYPERCALL, supported);
 }
 
@@ -160,3 +161,52 @@ bool kvmi_arch_is_agent_hypercall(struct kvm_vcpu *vcpu)
 	return (subfunc1 == KVM_HC_XEN_HVM_OP_GUEST_REQUEST_VM_EVENT
 		&& subfunc2 == 0);
 }
+
+static int kvmi_control_bp_intercept(struct kvm_vcpu *vcpu, bool enable)
+{
+	struct kvm_guest_debug dbg = {};
+	int err = 0;
+
+	if (enable)
+		dbg.control = KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_SW_BP;
+
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
+	case KVMI_VCPU_EVENT_BREAKPOINT:
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
+	action = kvmi_msg_send_vcpu_bp(vcpu, gpa, insn_len);
+	switch (action) {
+	case KVMI_EVENT_ACTION_CONTINUE:
+		kvm_queue_exception(vcpu, BP_VECTOR);
+		break;
+	case KVMI_EVENT_ACTION_RETRY:
+		/* rip was most likely adjusted past the INT 3 instruction */
+		break;
+	default:
+		kvmi_handle_common_event_actions(vcpu, action);
+	}
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c6730ec39c58..baca455212f9 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -25,6 +25,7 @@
 #include <linux/pagemap.h>
 #include <linux/swap.h>
 #include <linux/rwsem.h>
+#include <linux/kvmi_host.h>
 
 #include <asm/apic.h>
 #include <asm/perf_event.h>
@@ -1958,10 +1959,43 @@ static int db_interception(struct vcpu_svm *svm)
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
index 1c8fbd6209ce..9bfa2e9f8161 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -28,6 +28,7 @@
 #include <linux/tboot.h>
 #include <linux/trace_events.h>
 #include <linux/entry-kvm.h>
+#include <linux/kvmi_host.h>
 
 #include <asm/apic.h>
 #include <asm/asm.h>
@@ -4814,7 +4815,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct kvm_run *kvm_run = vcpu->run;
 	u32 intr_info, ex_no, error_code;
-	unsigned long cr2, rip, dr6;
+	unsigned long cr2, dr6;
 	u32 vect_info;
 
 	vect_info = vmx->idt_vectoring_info;
@@ -4895,7 +4896,10 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 		kvm_run->debug.arch.dr6 = dr6 | DR6_FIXED_1 | DR6_RTM;
 		kvm_run->debug.arch.dr7 = vmcs_readl(GUEST_DR7);
 		fallthrough;
-	case BP_VECTOR:
+	case BP_VECTOR: {
+		unsigned long gva = vmcs_readl(GUEST_CS_BASE) +
+			kvm_rip_read(vcpu);
+
 		/*
 		 * Update instruction length as we may reinject #BP from
 		 * user space while in guest debugging mode. Reading it for
@@ -4903,11 +4907,16 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
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
index 1fb775b0de33..30b7269468dd 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -70,6 +70,7 @@ int kvmi_ioctl_preunhook(struct kvm *kvm);
 
 void kvmi_handle_requests(struct kvm_vcpu *vcpu);
 bool kvmi_hypercall_event(struct kvm_vcpu *vcpu);
+bool kvmi_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva, u8 insn_len);
 
 #else
 
@@ -82,6 +83,8 @@ static inline void kvmi_vcpu_uninit(struct kvm_vcpu *vcpu) { }
 
 static inline void kvmi_handle_requests(struct kvm_vcpu *vcpu) { }
 static inline bool kvmi_hypercall_event(struct kvm_vcpu *vcpu) { return false; }
+static inline bool kvmi_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva,
+					 u8 insn_len) { return true; }
 
 #endif /* CONFIG_KVM_INTROSPECTION */
 
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 3dfc3486cc46..ea66f3f803e7 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -54,8 +54,9 @@ enum {
 };
 
 enum {
-	KVMI_VCPU_EVENT_PAUSE     = KVMI_VCPU_EVENT_ID(0),
-	KVMI_VCPU_EVENT_HYPERCALL = KVMI_VCPU_EVENT_ID(1),
+	KVMI_VCPU_EVENT_PAUSE      = KVMI_VCPU_EVENT_ID(0),
+	KVMI_VCPU_EVENT_HYPERCALL  = KVMI_VCPU_EVENT_ID(1),
+	KVMI_VCPU_EVENT_BREAKPOINT = KVMI_VCPU_EVENT_ID(2),
 
 	KVMI_NEXT_VCPU_EVENT
 };
@@ -160,4 +161,10 @@ struct kvmi_vcpu_control_events {
 	__u32 padding2;
 };
 
+struct kvmi_vcpu_event_breakpoint {
+	__u64 gpa;
+	__u8 insn_len;
+	__u8 padding[7];
+};
+
 #endif /* _UAPI__LINUX_KVMI_H */
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 8c772b2bff2a..ccb9a3a997d8 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -53,6 +53,7 @@ struct vcpu_worker_data {
 
 enum {
 	GUEST_TEST_NOOP = 0,
+	GUEST_TEST_BP,
 	GUEST_TEST_HYPERCALL,
 };
 
@@ -68,6 +69,11 @@ static int guest_test_id(void)
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
@@ -82,6 +88,9 @@ static void guest_code(void)
 		switch (guest_test_id()) {
 		case GUEST_TEST_NOOP:
 			break;
+		case GUEST_TEST_BP:
+			guest_bp_test();
+			break;
 		case GUEST_TEST_HYPERCALL:
 			guest_hypercall_test();
 			break;
@@ -1018,6 +1027,42 @@ static void test_event_hypercall(struct kvm_vm *vm)
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
+		struct vcpu_event vcpu_ev;
+		struct kvmi_vcpu_event_breakpoint bp;
+	} ev;
+	struct vcpu_reply rpl = {};
+	__u16 event_id = KVMI_VCPU_EVENT_BREAKPOINT;
+	pthread_t vcpu_thread;
+
+	enable_vcpu_event(vm, event_id);
+
+	vcpu_thread = start_vcpu_worker(&data);
+
+	receive_vcpu_event(&hdr, &ev.vcpu_ev, sizeof(ev), event_id);
+
+	pr_debug("Breakpoint event, rip 0x%llx, len %u\n",
+		ev.vcpu_ev.common.arch.regs.rip, ev.bp.insn_len);
+
+	ev.vcpu_ev.common.arch.regs.rip += ev.bp.insn_len;
+	__set_registers(vm, &ev.vcpu_ev.common.arch.regs);
+
+	reply_to_event(&hdr, &ev.vcpu_ev, KVMI_EVENT_ACTION_RETRY,
+			&rpl, sizeof(rpl));
+
+	wait_vcpu_worker(vcpu_thread);
+
+	disable_vcpu_event(vm, event_id);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	srandom(time(0));
@@ -1039,6 +1084,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vcpu_set_registers(vm);
 	test_cmd_vcpu_get_cpuid(vm);
 	test_event_hypercall(vm);
+	test_event_breakpoint(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 7a4b9b5c3248..bd1e6afaed9f 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -639,6 +639,11 @@ int kvmi_cmd_vcpu_control_events(struct kvm_vcpu *vcpu,
 				 u16 event_id, bool enable)
 {
 	struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
+	int err;
+
+	err = kvmi_arch_cmd_control_intercept(vcpu, event_id, enable);
+	if (err)
+		return err;
 
 	if (enable)
 		set_bit(event_id, vcpui->ev_enable_mask);
@@ -875,3 +880,23 @@ bool kvmi_hypercall_event(struct kvm_vcpu *vcpu)
 
 	return ret;
 }
+
+bool kvmi_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva, u8 insn_len)
+{
+	struct kvm_introspection *kvmi;
+	bool ret = true;
+
+	kvmi = kvmi_get(vcpu->kvm);
+	if (!kvmi)
+		return ret;
+
+	if (is_vcpu_event_enabled(vcpu, KVMI_VCPU_EVENT_BREAKPOINT)) {
+		kvmi_arch_breakpoint_event(vcpu, gva, insn_len);
+		ret = false;
+	}
+
+	kvmi_put(vcpu->kvm);
+
+	return ret;
+}
+EXPORT_SYMBOL(kvmi_breakpoint_event);
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 72f0b75d2cf5..ff745e3cebaf 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -45,6 +45,7 @@ int kvmi_msg_vcpu_reply(const struct kvmi_vcpu_msg_job *job,
 			const void *rpl, size_t rpl_size);
 u32 kvmi_msg_send_vcpu_pause(struct kvm_vcpu *vcpu);
 u32 kvmi_msg_send_vcpu_hypercall(struct kvm_vcpu *vcpu);
+u32 kvmi_msg_send_vcpu_bp(struct kvm_vcpu *vcpu, u64 gpa, u8 insn_len);
 
 /* kvmi.c */
 void *kvmi_msg_alloc(void);
@@ -79,5 +80,8 @@ void kvmi_arch_setup_vcpu_event(struct kvm_vcpu *vcpu,
 				struct kvmi_vcpu_event *ev);
 void kvmi_arch_post_reply(struct kvm_vcpu *vcpu);
 bool kvmi_arch_is_agent_hypercall(struct kvm_vcpu *vcpu);
+void kvmi_arch_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva, u8 insn_len);
+int kvmi_arch_cmd_control_intercept(struct kvm_vcpu *vcpu,
+				    unsigned int event_id, bool enable);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index a515734dc937..ee41f2397822 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -757,3 +757,21 @@ u32 kvmi_msg_send_vcpu_hypercall(struct kvm_vcpu *vcpu)
 
 	return action;
 }
+
+u32 kvmi_msg_send_vcpu_bp(struct kvm_vcpu *vcpu, u64 gpa, u8 insn_len)
+{
+	struct kvmi_vcpu_event_breakpoint e;
+	u32 action;
+	int err;
+
+	memset(&e, 0, sizeof(e));
+	e.gpa = gpa;
+	e.insn_len = insn_len;
+
+	err = kvmi_send_vcpu_event(vcpu, KVMI_VCPU_EVENT_BREAKPOINT,
+				   &e, sizeof(e), NULL, 0, &action);
+	if (err)
+		return KVMI_EVENT_ACTION_CONTINUE;
+
+	return action;
+}
