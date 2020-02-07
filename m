Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39344155D9D
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727696AbgBGSRY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:17:24 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40648 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727702AbgBGSQy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:54 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 7BAFD305D35C;
        Fri,  7 Feb 2020 20:16:41 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 680243052067;
        Fri,  7 Feb 2020 20:16:41 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v7 62/78] KVM: introspection: add KVMI_VCPU_INJECT_EXCEPTION + KVMI_EVENT_TRAP
Date:   Fri,  7 Feb 2020 20:16:20 +0200
Message-Id: <20200207181636.1065-63-alazar@bitdefender.com>
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

The KVMI_VCPU_INJECT_EXCEPTION command is used by the introspection tool
to inject exceptions (eg. get a page from swap). The exception is queued
right before entering the guest. If there is already an event pending
(exception, interrupt or NMI) we notify the introspection tool with the
KVMI_EVENT_TRAP event and abort the injection. The introspecion tool is
expected to try again at a later time.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               |  73 ++++++++++++
 arch/x86/include/uapi/asm/kvmi.h              |  14 +++
 arch/x86/kvm/kvmi.c                           | 105 +++++++++++++++++
 arch/x86/kvm/x86.c                            |   3 +
 include/linux/kvmi_host.h                     |  12 ++
 include/uapi/linux/kvmi.h                     |  16 +--
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 106 +++++++++++++++++-
 virt/kvm/introspection/kvmi.c                 |  48 ++++++++
 virt/kvm/introspection/kvmi_int.h             |   7 ++
 virt/kvm/introspection/kvmi_msg.c             |  79 ++++++++-----
 10 files changed, 430 insertions(+), 33 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 17a7cc50aedc..9a902a94ed28 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -533,6 +533,7 @@ the following events::
 	KVMI_EVENT_BREAKPOINT
 	KVMI_EVENT_CR
 	KVMI_EVENT_HYPERCALL
+	KVMI_EVENT_TRAP
 
 When an event is enabled, the introspection tool is notified and it
 must reply with: continue, retry, crash, etc. (see **Events** below).
@@ -694,6 +695,46 @@ ID set.
 * -KVM_EINVAL - padding is not zero
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
 
+15. KVMI_VCPU_INJECT_EXCEPTION
+------------------------------
+
+:Architectures: x86
+:Versions: >= 1
+:Parameters:
+
+::
+
+	struct kvmi_vcpu_hdr;
+	struct kvmi_vcpu_inject_exception {
+		__u8 nr;
+		__u8 padding1;
+		__u16 padding2;
+		__u32 error_code;
+		__u64 address;
+	};
+
+:Returns:
+
+::
+
+	struct kvmi_error_code
+
+Injects a vCPU exception with or without an error code. In case of page fault
+exception, the guest virtual address has to be specified.
+
+The introspection tool should enable the *KVMI_EVENT_TRAP* event in
+order to be notified about the effective injected expection.
+
+:Errors:
+
+* -KVM_EINVAL - the selected vCPU is invalid
+* -KVM_EINVAL - the specified exception number is invalid
+* -KVM_EINVAL - the specified address is invalid
+* -KVM_EINVAL - padding is not zero
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+* -KVM_EBUSY - another *KVMI_VCPU_INJECT_EXCEPTION* command was issued and no
+  corresponding *KVMI_EVENT_TRAP* (if enabled) has been provided yet.
+
 Events
 ======
 
@@ -906,3 +947,35 @@ register (see **KVMI_VCPU_CONTROL_EVENTS**).
 
 ``kvmi_event``, the control register number, the old value and the new value
 are sent to the introspection tool. The *CONTINUE* action will set the ``new_val``.
+
+6. KVMI_EVENT_TRAP
+------------------
+
+:Architectures: x86
+:Versions: >= 1
+:Actions: CONTINUE, CRASH
+:Parameters:
+
+::
+
+	struct kvmi_event;
+	struct kvmi_event_trap {
+		__u32 vector;
+		__u32 error_code;
+		__u64 cr2;
+	};
+
+:Returns:
+
+::
+
+	struct kvmi_vcpu_hdr;
+	struct kvmi_event_reply;
+
+This event is sent if a previous *KVMI_VCPU_INJECT_EXCEPTION* command
+took place and the introspection has been enabled for this event
+(see *KVMI_VCPU_CONTROL_EVENTS*).
+
+``kvmi_event``, exception/interrupt number (vector), exception code
+(``error_code``) and CR2 are sent to the introspection tool,
+which should check if its exception has been injected or overridden.
diff --git a/arch/x86/include/uapi/asm/kvmi.h b/arch/x86/include/uapi/asm/kvmi.h
index d1a0be0499d4..06f69cfa3d79 100644
--- a/arch/x86/include/uapi/asm/kvmi.h
+++ b/arch/x86/include/uapi/asm/kvmi.h
@@ -83,4 +83,18 @@ struct kvmi_event_cr_reply {
 	__u64 new_val;
 };
 
+struct kvmi_event_trap {
+	__u32 vector;
+	__u32 error_code;
+	__u64 cr2;
+};
+
+struct kvmi_vcpu_inject_exception {
+	__u8 nr;
+	__u8 padding1;
+	__u16 padding2;
+	__u32 error_code;
+	__u64 address;
+};
+
 #endif /* _UAPI_ASM_X86_KVMI_H */
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index a522d4b1fa09..ac493fcebb5b 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -511,3 +511,108 @@ bool kvmi_cr3_intercepted(struct kvm_vcpu *vcpu)
 	return ret;
 }
 EXPORT_SYMBOL(kvmi_cr3_intercepted);
+
+int kvmi_arch_cmd_vcpu_inject_exception(struct kvm_vcpu *vcpu, u8 vector,
+					u32 error_code, u64 address)
+{
+	struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
+
+	if (vcpui->exception.pending || vcpui->exception.send_event)
+		return -KVM_EBUSY;
+
+	vcpui->exception.pending = true;
+
+	vcpui->exception.nr = vector;
+	vcpui->exception.error_code = x86_exception_has_error_code(vector) ?
+				error_code : 0;
+	vcpui->exception.error_code_valid =
+		x86_exception_has_error_code(vector);
+	vcpui->exception.address = address;
+
+	return 0;
+}
+
+static bool kvmi_arch_queue_exception(struct kvm_vcpu *vcpu)
+{
+	if (!kvm_event_needs_reinjection(vcpu)) {
+		struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
+		struct x86_exception e = {
+			.vector = vcpui->exception.nr,
+			.error_code_valid = vcpui->exception.error_code_valid,
+			.error_code = vcpui->exception.error_code,
+			.address = vcpui->exception.address,
+		};
+
+		if (e.vector == PF_VECTOR)
+			kvm_inject_page_fault(vcpu, &e);
+		else if (e.error_code_valid)
+			kvm_queue_exception_e(vcpu, e.vector, e.error_code);
+		else
+			kvm_queue_exception(vcpu, e.vector);
+
+		return true;
+	}
+
+	return false;
+}
+
+static u32 kvmi_send_trap(struct kvm_vcpu *vcpu, u8 vector,
+			  u32 error_code, u64 cr2)
+{
+	struct kvmi_event_trap e = {
+		.vector = vector,
+		.error_code = error_code,
+		.cr2 = cr2
+	};
+	int err, action;
+
+	err = kvmi_send_event(vcpu, KVMI_EVENT_TRAP, &e, sizeof(e),
+			      NULL, 0, &action);
+	if (err)
+		return KVMI_EVENT_ACTION_CONTINUE;
+
+	return action;
+}
+
+void kvmi_arch_trap_event(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
+	u32 action;
+
+	action = kvmi_send_trap(vcpu, vcpui->exception.nr,
+				vcpui->exception.error_code,
+				vcpui->exception.address);
+
+	switch (action) {
+	case KVMI_EVENT_ACTION_CONTINUE:
+		break;
+	default:
+		kvmi_handle_common_event_actions(vcpu->kvm, action, "TRAP");
+	}
+}
+
+static void kvmi_save_injected_event(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
+
+	vcpui->exception.error_code = 0;
+	vcpui->exception.error_code_valid = false;
+
+	vcpui->exception.address = vcpu->arch.cr2;
+	if (vcpu->arch.exception.injected) {
+		vcpui->exception.nr = vcpu->arch.exception.nr;
+		vcpui->exception.error_code_valid =
+			x86_exception_has_error_code(vcpu->arch.exception.nr);
+		vcpui->exception.error_code = vcpu->arch.exception.error_code;
+	} else if (vcpu->arch.interrupt.injected) {
+		vcpui->exception.nr = vcpu->arch.interrupt.nr;
+	}
+}
+
+void kvmi_arch_inject_pending_exception(struct kvm_vcpu *vcpu)
+{
+	if (kvmi_arch_queue_exception(vcpu))
+		kvm_inject_pending_exception(vcpu);
+
+	kvmi_save_injected_event(vcpu);
+}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e0376d0b7408..ff61123ce4bd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8251,6 +8251,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		goto cancel_injection;
 	}
 
+	if (!kvmi_enter_guest(vcpu))
+		req_immediate_exit = true;
+
 	if (req_immediate_exit) {
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
 		kvm_x86_ops->request_immediate_exit(vcpu);
diff --git a/include/linux/kvmi_host.h b/include/linux/kvmi_host.h
index 57e91c8659a3..b738f15cd826 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -41,6 +41,15 @@ struct kvm_vcpu_introspection {
 
 	struct kvm_regs delayed_regs;
 	bool have_delayed_regs;
+
+	struct {
+		u8 nr;
+		u32 error_code;
+		bool error_code_valid;
+		u64 address;
+		bool pending;
+		bool send_event;
+	} exception;
 };
 
 struct kvm_introspection {
@@ -77,6 +86,7 @@ int kvmi_ioctl_preunhook(struct kvm *kvm);
 void kvmi_handle_requests(struct kvm_vcpu *vcpu);
 bool kvmi_hypercall_event(struct kvm_vcpu *vcpu);
 bool kvmi_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva, u8 insn_len);
+bool kvmi_enter_guest(struct kvm_vcpu *vcpu);
 
 #else
 
@@ -91,6 +101,8 @@ static inline bool kvmi_hypercall_event(struct kvm_vcpu *vcpu) { return false; }
 static inline bool kvmi_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva,
 					 u8 insn_len)
 			{ return true; }
+static inline bool kvmi_enter_guest(struct kvm_vcpu *vcpu)
+			{ return true; }
 
 #endif /* CONFIG_KVM_INTROSPECTION */
 
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 7be58dcf194f..fcbb19020c70 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -26,13 +26,14 @@ enum {
 	KVMI_VM_READ_PHYSICAL    = 7,
 	KVMI_VM_WRITE_PHYSICAL   = 8,
 
-	KVMI_VCPU_GET_INFO       = 9,
-	KVMI_VCPU_PAUSE          = 10,
-	KVMI_VCPU_CONTROL_EVENTS = 11,
-	KVMI_VCPU_GET_REGISTERS  = 12,
-	KVMI_VCPU_SET_REGISTERS  = 13,
-	KVMI_VCPU_GET_CPUID      = 14,
-	KVMI_VCPU_CONTROL_CR     = 15,
+	KVMI_VCPU_GET_INFO         = 9,
+	KVMI_VCPU_PAUSE            = 10,
+	KVMI_VCPU_CONTROL_EVENTS   = 11,
+	KVMI_VCPU_GET_REGISTERS    = 12,
+	KVMI_VCPU_SET_REGISTERS    = 13,
+	KVMI_VCPU_GET_CPUID        = 14,
+	KVMI_VCPU_CONTROL_CR       = 15,
+	KVMI_VCPU_INJECT_EXCEPTION = 16,
 
 	KVMI_NUM_MESSAGES
 };
@@ -43,6 +44,7 @@ enum {
 	KVMI_EVENT_HYPERCALL  = 2,
 	KVMI_EVENT_BREAKPOINT = 3,
 	KVMI_EVENT_CR         = 4,
+	KVMI_EVENT_TRAP       = 5,
 
 	KVMI_NUM_EVENTS
 };
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index a6e565b05947..6c9d1f3f927c 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -44,6 +44,8 @@ struct vcpu_worker_data {
 	int vcpu_id;
 	int test_id;
 	bool stop;
+	bool shutdown;
+	bool restart_on_shutdown;
 };
 
 enum {
@@ -596,11 +598,19 @@ static void *vcpu_worker(void *data)
 
 		vcpu_run(ctx->vm, ctx->vcpu_id);
 
-		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO
+			|| (run->exit_reason == KVM_EXIT_SHUTDOWN
+				&& ctx->shutdown),
 			"vcpu_run() failed, test_id %d, exit reason %u (%s)\n",
 			ctx->test_id, run->exit_reason,
 			exit_reason_str(run->exit_reason));
 
+		if (run->exit_reason == KVM_EXIT_SHUTDOWN) {
+			if (ctx->restart_on_shutdown)
+				continue;
+			break;
+		}
+
 		TEST_ASSERT(get_ucall(ctx->vm, ctx->vcpu_id, &uc),
 			"No guest request\n");
 
@@ -1126,6 +1136,99 @@ static void test_cmd_vcpu_control_cr(struct kvm_vm *vm)
 		sregs.cr4, ev.cr.old_value);
 }
 
+static void __inject_exception(struct kvm_vm *vm, int vector)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vcpu_hdr vcpu_hdr;
+		struct kvmi_vcpu_inject_exception cmd;
+	} req = {};
+	__u16 vcpu_index = 0;
+	int r;
+
+	req.vcpu_hdr.vcpu = vcpu_index;
+	req.cmd.nr = vector;
+
+	r = do_command(KVMI_VCPU_INJECT_EXCEPTION,
+			&req.hdr, sizeof(req), NULL, 0);
+	TEST_ASSERT(r == 0,
+		"KVMI_VCPU_INJECT_EXCEPTION failed, error %d(%s)\n",
+		-r, kvm_strerror(-r));
+}
+
+static void receive_exception_event(struct kvm_vm *vm, int vector)
+{
+	struct kvmi_msg_hdr hdr;
+	struct {
+		struct kvmi_event common;
+		struct kvmi_event_trap trap;
+	} ev;
+	struct vcpu_reply rpl = {};
+
+	receive_event(&hdr, &ev.common, sizeof(ev), KVMI_EVENT_TRAP);
+
+	DEBUG("Exception event: vector %u, error_code 0x%x, cr2 0x%llx\n",
+		ev.trap.vector, ev.trap.error_code, ev.trap.cr2);
+
+	TEST_ASSERT(ev.trap.vector == vector,
+		"Injected exception %u instead of %u\n",
+		ev.trap.vector, vector);
+
+	reply_to_event(&hdr, &ev.common, KVMI_EVENT_ACTION_CONTINUE,
+			&rpl, sizeof(rpl));
+}
+
+static void test_cmd_vcpu_inject_exception(struct kvm_vm *vm)
+{
+	struct vcpu_worker_data data = {
+		.vm = vm,
+		.vcpu_id = VCPU_ID,
+		.shutdown = true,
+		.restart_on_shutdown = true,
+	};
+	struct kvmi_msg_hdr hdr;
+	struct {
+		struct kvmi_event common;
+		struct kvmi_event_breakpoint bp;
+	} ev;
+	struct vcpu_reply rpl = {};
+	pthread_t vcpu_thread;
+	__u8 ud_vector = 6;
+	__u8 bp_vector = 3;
+
+	enable_vcpu_event(vm, KVMI_EVENT_BREAKPOINT);
+	enable_vcpu_event(vm, KVMI_EVENT_TRAP);
+
+	vcpu_thread = start_vcpu_worker(&data);
+
+	__inject_exception(vm, ud_vector);
+
+	/* confirm that our exception has been injected */
+	receive_exception_event(vm, ud_vector);
+
+	WRITE_ONCE(data.test_id, GUEST_TEST_BP);
+
+	receive_event(&hdr, &ev.common, sizeof(ev), KVMI_EVENT_BREAKPOINT);
+
+	__inject_exception(vm, ud_vector);
+
+	/* skip the breakpoint instruction, next time guest_bp_test() runs */
+	ev.common.arch.regs.rip += ev.bp.insn_len;
+	__set_registers(vm, &ev.common.arch.regs);
+
+	/* reinject the #BP exception */
+	reply_to_event(&hdr, &ev.common, KVMI_EVENT_ACTION_CONTINUE,
+			&rpl, sizeof(rpl));
+
+	/* confirm that our injection didn't override the #BP exception */
+	receive_exception_event(vm, bp_vector);
+
+	stop_vcpu_worker(vcpu_thread, &data);
+
+	disable_vcpu_event(vm, KVMI_EVENT_TRAP);
+	disable_vcpu_event(vm, KVMI_EVENT_BREAKPOINT);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	setup_socket();
@@ -1148,6 +1251,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_event_hypercall(vm);
 	test_event_breakpoint(vm);
 	test_cmd_vcpu_control_cr(vm);
+	test_cmd_vcpu_inject_exception(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index f369856f91b1..92d1719f4941 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -789,6 +789,16 @@ static void kvmi_vcpu_pause_event(struct kvm_vcpu *vcpu)
 	}
 }
 
+void kvmi_send_pending_event(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
+
+	if (vcpui->exception.send_event) {
+		vcpui->exception.send_event = false;
+		kvmi_arch_trap_event(vcpu);
+	}
+}
+
 void kvmi_handle_requests(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
@@ -798,6 +808,8 @@ void kvmi_handle_requests(struct kvm_vcpu *vcpu)
 	if (!kvmi)
 		goto out;
 
+	kvmi_send_pending_event(vcpu);
+
 	for (;;) {
 		kvmi_run_jobs(vcpu);
 
@@ -896,3 +908,39 @@ bool kvmi_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva, u8 insn_len)
 	return ret;
 }
 EXPORT_SYMBOL(kvmi_breakpoint_event);
+
+static bool kvmi_inject_pending_exception(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
+
+	if (!vcpui->exception.pending)
+		return false;
+
+	kvmi_arch_inject_pending_exception(vcpu);
+
+	vcpui->exception.pending = false;
+
+	if (!is_event_enabled(vcpu, KVMI_EVENT_TRAP))
+		return false;
+
+	kvm_make_request(KVM_REQ_INTROSPECTION, vcpu);
+	vcpui->exception.send_event = true;
+
+	return true;
+}
+
+bool kvmi_enter_guest(struct kvm_vcpu *vcpu)
+{
+	struct kvm_introspection *kvmi;
+	bool r = true;
+
+	kvmi = kvmi_get(vcpu->kvm);
+	if (!kvmi)
+		return true;
+
+	if (kvmi_inject_pending_exception(vcpu))
+		r = false;
+
+	kvmi_put(vcpu->kvm);
+	return r;
+}
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index c2f613e5304e..9784477db46c 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -25,6 +25,7 @@
 			    BIT(KVMI_EVENT_BREAKPOINT) \
 			  | BIT(KVMI_EVENT_CR) \
 			  | BIT(KVMI_EVENT_HYPERCALL) \
+			  | BIT(KVMI_EVENT_TRAP) \
 			  | BIT(KVMI_EVENT_PAUSE_VCPU) \
 		)
 
@@ -44,6 +45,7 @@
 			| BIT(KVMI_VCPU_CONTROL_EVENTS) \
 			| BIT(KVMI_VCPU_GET_CPUID) \
 			| BIT(KVMI_VCPU_GET_REGISTERS) \
+			| BIT(KVMI_VCPU_INJECT_EXCEPTION) \
 			| BIT(KVMI_VCPU_SET_REGISTERS) \
 		)
 
@@ -87,6 +89,7 @@ void kvmi_handle_common_event_actions(struct kvm *kvm,
 				      u32 action, const char *str);
 struct kvm_introspection * __must_check kvmi_get(struct kvm *kvm);
 void kvmi_put(struct kvm *kvm);
+void kvmi_send_pending_event(struct kvm_vcpu *vcpu);
 int kvmi_cmd_vm_control_events(struct kvm_introspection *kvmi,
 				unsigned int event_id, bool enable);
 int kvmi_cmd_vcpu_control_events(struct kvm_vcpu *vcpu,
@@ -126,5 +129,9 @@ int kvmi_arch_cmd_control_intercept(struct kvm_vcpu *vcpu,
 				    unsigned int event_id, bool enable);
 int kvmi_arch_cmd_vcpu_control_cr(struct kvm_vcpu *vcpu,
 				  const struct kvmi_vcpu_control_cr *req);
+int kvmi_arch_cmd_vcpu_inject_exception(struct kvm_vcpu *vcpu, u8 vector,
+					u32 error_code, u64 address);
+void kvmi_arch_trap_event(struct kvm_vcpu *vcpu);
+void kvmi_arch_inject_pending_exception(struct kvm_vcpu *vcpu);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 3f7be92502cf..8d77e6a7794d 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -17,21 +17,22 @@ struct kvmi_vcpu_cmd_job {
 };
 
 static const char *const msg_IDs[] = {
-	[KVMI_EVENT_REPLY]         = "KVMI_EVENT_REPLY",
-	[KVMI_GET_VERSION]         = "KVMI_GET_VERSION",
-	[KVMI_VM_CHECK_COMMAND]    = "KVMI_VM_CHECK_COMMAND",
-	[KVMI_VM_CHECK_EVENT]      = "KVMI_VM_CHECK_EVENT",
-	[KVMI_VM_CONTROL_EVENTS]   = "KVMI_VM_CONTROL_EVENTS",
-	[KVMI_VM_GET_INFO]         = "KVMI_VM_GET_INFO",
-	[KVMI_VM_READ_PHYSICAL]    = "KVMI_VM_READ_PHYSICAL",
-	[KVMI_VM_WRITE_PHYSICAL]   = "KVMI_VM_WRITE_PHYSICAL",
-	[KVMI_VCPU_CONTROL_CR]     = "KVMI_VCPU_CONTROL_CR",
-	[KVMI_VCPU_CONTROL_EVENTS] = "KVMI_VCPU_CONTROL_EVENTS",
-	[KVMI_VCPU_GET_CPUID]      = "KVMI_VCPU_GET_CPUID",
-	[KVMI_VCPU_GET_INFO]       = "KVMI_VCPU_GET_INFO",
-	[KVMI_VCPU_GET_REGISTERS]  = "KVMI_VCPU_GET_REGISTERS",
-	[KVMI_VCPU_PAUSE]          = "KVMI_VCPU_PAUSE",
-	[KVMI_VCPU_SET_REGISTERS]  = "KVMI_VCPU_SET_REGISTERS",
+	[KVMI_EVENT_REPLY]           = "KVMI_EVENT_REPLY",
+	[KVMI_GET_VERSION]           = "KVMI_GET_VERSION",
+	[KVMI_VM_CHECK_COMMAND]      = "KVMI_VM_CHECK_COMMAND",
+	[KVMI_VM_CHECK_EVENT]        = "KVMI_VM_CHECK_EVENT",
+	[KVMI_VM_CONTROL_EVENTS]     = "KVMI_VM_CONTROL_EVENTS",
+	[KVMI_VM_GET_INFO]           = "KVMI_VM_GET_INFO",
+	[KVMI_VM_READ_PHYSICAL]      = "KVMI_VM_READ_PHYSICAL",
+	[KVMI_VM_WRITE_PHYSICAL]     = "KVMI_VM_WRITE_PHYSICAL",
+	[KVMI_VCPU_CONTROL_CR]       = "KVMI_VCPU_CONTROL_CR",
+	[KVMI_VCPU_CONTROL_EVENTS]   = "KVMI_VCPU_CONTROL_EVENTS",
+	[KVMI_VCPU_GET_CPUID]        = "KVMI_VCPU_GET_CPUID",
+	[KVMI_VCPU_GET_INFO]         = "KVMI_VCPU_GET_INFO",
+	[KVMI_VCPU_GET_REGISTERS]    = "KVMI_VCPU_GET_REGISTERS",
+	[KVMI_VCPU_INJECT_EXCEPTION] = "KVMI_VCPU_INJECT_EXCEPTION",
+	[KVMI_VCPU_PAUSE]            = "KVMI_VCPU_PAUSE",
+	[KVMI_VCPU_SET_REGISTERS]    = "KVMI_VCPU_SET_REGISTERS",
 };
 
 static bool is_known_message(u16 id)
@@ -494,6 +495,23 @@ static int handle_vcpu_control_cr(const struct kvmi_vcpu_cmd_job *job,
 	return kvmi_msg_vcpu_reply(job, msg, ec, NULL, 0);
 }
 
+static int handle_vcpu_inject_exception(const struct kvmi_vcpu_cmd_job *job,
+					const struct kvmi_msg_hdr *msg,
+					const void *_req)
+{
+	const struct kvmi_vcpu_inject_exception *req = _req;
+	int ec;
+
+	if (req->padding1 || req->padding2)
+		ec = -KVM_EINVAL;
+	else
+		ec = kvmi_arch_cmd_vcpu_inject_exception(job->vcpu, req->nr,
+							 req->error_code,
+							 req->address);
+
+	return kvmi_msg_vcpu_reply(job, msg, ec, NULL, 0);
+}
+
 /*
  * These commands are executed on the vCPU thread. The receiving thread
  * passes the messages using a newly allocated 'struct kvmi_vcpu_cmd_job'
@@ -502,13 +520,14 @@ static int handle_vcpu_control_cr(const struct kvmi_vcpu_cmd_job *job,
  */
 static int(*const msg_vcpu[])(const struct kvmi_vcpu_cmd_job *,
 			      const struct kvmi_msg_hdr *, const void *) = {
-	[KVMI_EVENT_REPLY]         = handle_event_reply,
-	[KVMI_VCPU_CONTROL_CR]     = handle_vcpu_control_cr,
-	[KVMI_VCPU_CONTROL_EVENTS] = handle_vcpu_control_events,
-	[KVMI_VCPU_GET_CPUID]      = handle_get_cpuid,
-	[KVMI_VCPU_GET_INFO]       = handle_get_vcpu_info,
-	[KVMI_VCPU_GET_REGISTERS]  = handle_get_registers,
-	[KVMI_VCPU_SET_REGISTERS]  = handle_set_registers,
+	[KVMI_EVENT_REPLY]           = handle_event_reply,
+	[KVMI_VCPU_CONTROL_CR]       = handle_vcpu_control_cr,
+	[KVMI_VCPU_CONTROL_EVENTS]   = handle_vcpu_control_events,
+	[KVMI_VCPU_GET_CPUID]        = handle_get_cpuid,
+	[KVMI_VCPU_GET_INFO]         = handle_get_vcpu_info,
+	[KVMI_VCPU_GET_REGISTERS]    = handle_get_registers,
+	[KVMI_VCPU_INJECT_EXCEPTION] = handle_vcpu_inject_exception,
+	[KVMI_VCPU_SET_REGISTERS]    = handle_set_registers,
 };
 
 static void kvmi_job_vcpu_cmd(struct kvm_vcpu *vcpu, void *ctx)
@@ -821,9 +840,9 @@ static int kvmi_wait_for_reply(struct kvm_vcpu *vcpu)
 	return err;
 }
 
-int kvmi_send_event(struct kvm_vcpu *vcpu, u32 ev_id,
-		    void *ev, size_t ev_size,
-		    void *rpl, size_t rpl_size, int *action)
+int __kvmi_send_event(struct kvm_vcpu *vcpu, u32 ev_id,
+		      void *ev, size_t ev_size,
+		      void *rpl, size_t rpl_size, int *action)
 {
 	struct kvmi_msg_hdr hdr;
 	struct kvmi_event common;
@@ -873,6 +892,16 @@ int kvmi_send_event(struct kvm_vcpu *vcpu, u32 ev_id,
 	return err;
 }
 
+int kvmi_send_event(struct kvm_vcpu *vcpu, u32 ev_id,
+		    void *ev, size_t ev_size,
+		    void *rpl, size_t rpl_size, int *action)
+{
+	kvmi_send_pending_event(vcpu);
+
+	return __kvmi_send_event(vcpu, ev_id, ev, ev_size,
+				 rpl, rpl_size, action);
+}
+
 u32 kvmi_msg_send_vcpu_pause(struct kvm_vcpu *vcpu)
 {
 	int err, action;
