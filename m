Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60355155D94
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbgBGSQz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:16:55 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40628 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727117AbgBGSQx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:53 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 42954305D358;
        Fri,  7 Feb 2020 20:16:41 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 1E50A305206E;
        Fri,  7 Feb 2020 20:16:41 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v7 58/78] KVM: introspection: add KVMI_EVENT_BREAKPOINT
Date:   Fri,  7 Feb 2020 20:16:16 +0200
Message-Id: <20200207181636.1065-59-alazar@bitdefender.com>
In-Reply-To: <20200207181636.1065-1-alazar@bitdefender.com>
References: <20200207181636.1065-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

This event is sent when a breakpoint was reached. It has to
be enabled with the KVMI_VCPU_CONTROL_EVENTS command first.

The introspection tool can place breakpoints and use them as notification
for when the OS or an application has reached a certain state or is
trying to perform a certain operation (like creating a process).

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 37 +++++++++++++
 arch/x86/include/uapi/asm/kvmi.h              |  6 +++
 arch/x86/kvm/kvmi.c                           | 52 +++++++++++++++++++
 arch/x86/kvm/svm.c                            | 32 ++++++++++++
 arch/x86/kvm/vmx/vmx.c                        | 16 ++++--
 include/linux/kvmi_host.h                     |  4 ++
 include/uapi/linux/kvmi.h                     |  1 +
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 46 ++++++++++++++++
 virt/kvm/introspection/kvmi.c                 | 29 ++++++++++-
 virt/kvm/introspection/kvmi_int.h             |  8 ++-
 virt/kvm/introspection/kvmi_msg.c             | 22 +++++++-
 11 files changed, 245 insertions(+), 8 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 90256141a15d..470407f309d9 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -530,6 +530,7 @@ Use *KVMI_VM_CHECK_EVENT* first.
 Enables/disables vCPU introspection events. This command can be used with
 the following events::
 
+	KVMI_EVENT_BREAKPOINT
 	KVMI_EVENT_HYPERCALL
 
 When an event is enabled, the introspection tool is notified and it
@@ -798,3 +799,39 @@ It is used by the code residing inside the introspected guest to call the
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
index f597b3c1cba0..2c8c062a4b11 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -192,3 +192,55 @@ void kvmi_arch_hypercall_event(struct kvm_vcpu *vcpu)
 						"HYPERCALL");
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
+		kvmi_handle_common_event_actions(vcpu->kvm, action, "BP");
+	}
+}
+
+void kvmi_arch_restore_interception(struct kvm_vcpu *vcpu)
+{
+}
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 38ecd86c1d58..37b018988d7d 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2788,10 +2788,42 @@ static int db_interception(struct vcpu_svm *svm)
 	return 1;
 }
 
+static unsigned svm_get_instruction_len(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	unsigned long next_rip = 0, rip = kvm_rip_read(vcpu);
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
index 475f5eb6c4c2..d231ff25f467 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4620,7 +4620,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct kvm_run *kvm_run = vcpu->run;
 	u32 intr_info, ex_no, error_code;
-	unsigned long cr2, rip, dr6;
+	unsigned long cr2, dr6;
 	u32 vect_info;
 
 	vect_info = vmx->idt_vectoring_info;
@@ -4698,7 +4698,10 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 		kvm_run->debug.arch.dr6 = dr6 | DR6_FIXED_1;
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
@@ -4706,11 +4709,16 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
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
 	default:
 		kvm_run->exit_reason = KVM_EXIT_EXCEPTION;
 		kvm_run->ex.exception = ex_no;
diff --git a/include/linux/kvmi_host.h b/include/linux/kvmi_host.h
index 0a85bfbd0c0c..57e91c8659a3 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -76,6 +76,7 @@ int kvmi_ioctl_preunhook(struct kvm *kvm);
 
 void kvmi_handle_requests(struct kvm_vcpu *vcpu);
 bool kvmi_hypercall_event(struct kvm_vcpu *vcpu);
+bool kvmi_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva, u8 insn_len);
 
 #else
 
@@ -87,6 +88,9 @@ static inline void kvmi_vcpu_uninit(struct kvm_vcpu *vcpu) { }
 
 static inline void kvmi_handle_requests(struct kvm_vcpu *vcpu) { }
 static inline bool kvmi_hypercall_event(struct kvm_vcpu *vcpu) { return false; }
+static inline bool kvmi_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva,
+					 u8 insn_len)
+			{ return true; }
 
 #endif /* CONFIG_KVM_INTROSPECTION */
 
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 20e2f154ab88..eec33e85b0c7 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -40,6 +40,7 @@ enum {
 	KVMI_EVENT_UNHOOK     = 0,
 	KVMI_EVENT_PAUSE_VCPU = 1,
 	KVMI_EVENT_HYPERCALL  = 2,
+	KVMI_EVENT_BREAKPOINT = 3,
 
 	KVMI_NUM_EVENTS
 };
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index ef4e33e92fff..33164ac75ca9 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -48,6 +48,7 @@ struct vcpu_worker_data {
 
 enum {
 	GUEST_TEST_NOOP = 0,
+	GUEST_TEST_BP,
 	GUEST_TEST_HYPERCALL,
 };
 
@@ -62,6 +63,11 @@ static int guest_test_id(void)
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
@@ -76,6 +82,9 @@ static void guest_code(void)
 		switch (guest_test_id()) {
 		case GUEST_TEST_NOOP:
 			break;
+		case GUEST_TEST_BP:
+			guest_bp_test();
+			break;
 		case GUEST_TEST_HYPERCALL:
 			guest_hypercall_test();
 			break;
@@ -984,6 +993,42 @@ static void test_event_hypercall(struct kvm_vm *vm)
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
+	DEBUG("Breakpoint event, rip 0x%llx, len %u\n",
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
 	setup_socket();
@@ -1004,6 +1049,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vcpu_set_registers(vm);
 	test_cmd_vcpu_get_cpuid(vm);
 	test_event_hypercall(vm);
+	test_event_breakpoint(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index a1c059489dea..19ea94dc0e1d 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -165,6 +165,8 @@ static void free_vcpui(struct kvm_vcpu *vcpu)
 
 	kfree(vcpui);
 	vcpu->kvmi = NULL;
+
+	kvmi_make_request(vcpu, false);
 }
 
 static void free_kvmi(struct kvm *kvm)
@@ -555,7 +557,7 @@ int kvmi_cmd_vcpu_control_events(struct kvm_vcpu *vcpu,
 	else
 		clear_bit(event_id, vcpui->ev_mask);
 
-	return 0;
+	return kvmi_arch_cmd_control_intercept(vcpu, event_id, enable);
 }
 
 unsigned long gfn_to_hva_safe(struct kvm *kvm, gfn_t gfn)
@@ -777,7 +779,7 @@ void kvmi_handle_requests(struct kvm_vcpu *vcpu)
 
 	kvmi = kvmi_get(vcpu->kvm);
 	if (!kvmi)
-		return;
+		goto out;
 
 	for (;;) {
 		kvmi_run_jobs(vcpu);
@@ -789,6 +791,9 @@ void kvmi_handle_requests(struct kvm_vcpu *vcpu)
 	}
 
 	kvmi_put(vcpu->kvm);
+
+out:
+	kvmi_arch_restore_interception(vcpu);
 }
 
 int kvmi_cmd_vcpu_pause(struct kvm_vcpu *vcpu, bool wait)
@@ -850,3 +855,23 @@ bool kvmi_hypercall_event(struct kvm_vcpu *vcpu)
 
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
index 3dbcf944a606..06f2c5b6857a 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -22,7 +22,8 @@
 			  BIT(KVMI_EVENT_UNHOOK) \
 		)
 #define KVMI_KNOWN_VCPU_EVENTS ( \
-			    BIT(KVMI_EVENT_HYPERCALL) \
+			    BIT(KVMI_EVENT_BREAKPOINT) \
+			  | BIT(KVMI_EVENT_HYPERCALL) \
 			  | BIT(KVMI_EVENT_PAUSE_VCPU) \
 		)
 
@@ -66,6 +67,7 @@ bool kvmi_msg_process(struct kvm_introspection *kvmi);
 int kvmi_msg_send_unhook(struct kvm_introspection *kvmi);
 u32 kvmi_msg_send_vcpu_pause(struct kvm_vcpu *vcpu);
 u32 kvmi_msg_send_hypercall(struct kvm_vcpu *vcpu);
+u32 kvmi_msg_send_bp(struct kvm_vcpu *vcpu, u64 gpa, u8 insn_len);
 
 /* kvmi.c */
 void *kvmi_msg_alloc(void);
@@ -94,6 +96,7 @@ int kvmi_cmd_vcpu_set_registers(struct kvm_vcpu *vcpu,
 				const struct kvm_regs *regs);
 
 /* arch */
+void kvmi_arch_restore_interception(struct kvm_vcpu *vcpu);
 int kvmi_arch_cmd_vcpu_get_info(struct kvm_vcpu *vcpu,
 				struct kvmi_vcpu_get_info_reply *rpl);
 void kvmi_arch_setup_event(struct kvm_vcpu *vcpu, struct kvmi_event *ev);
@@ -107,5 +110,8 @@ int kvmi_arch_cmd_vcpu_get_cpuid(struct kvm_vcpu *vcpu,
 				 struct kvmi_vcpu_get_cpuid_reply *rpl);
 bool kvmi_arch_is_agent_hypercall(struct kvm_vcpu *vcpu);
 void kvmi_arch_hypercall_event(struct kvm_vcpu *vcpu);
+void kvmi_arch_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva, u8 insn_len);
+int kvmi_arch_cmd_control_intercept(struct kvm_vcpu *vcpu,
+				    unsigned int event_id, bool enable);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index bcdf104eaa43..67762baa281a 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -430,9 +430,12 @@ static int handle_vcpu_control_events(const struct kvmi_vcpu_cmd_job *job,
 		ec = -KVM_EINVAL;
 	else if (!is_event_allowed(kvmi, req->event_id))
 		ec = -KVM_EPERM;
-	else
+	else {
 		ec = kvmi_cmd_vcpu_control_events(job->vcpu, req->event_id,
 						  req->enable);
+		if (ec)
+			ec = -KVM_EOPNOTSUPP;
+	}
 
 	return kvmi_msg_vcpu_reply(job, msg, ec, NULL, 0);
 }
@@ -880,3 +883,20 @@ u32 kvmi_msg_send_hypercall(struct kvm_vcpu *vcpu)
 
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
