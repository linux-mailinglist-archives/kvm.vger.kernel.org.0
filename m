Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24047228A91
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731361AbgGUVQK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:16:10 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37860 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731287AbgGUVQJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:16:09 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 9A456305D4FA;
        Wed, 22 Jul 2020 00:09:29 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 71989304FA13;
        Wed, 22 Jul 2020 00:09:29 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 66/84] KVM: introspection: add KVMI_VCPU_INJECT_EXCEPTION + KVMI_EVENT_TRAP
Date:   Wed, 22 Jul 2020 00:09:04 +0300
Message-Id: <20200721210922.7646-67-alazar@bitdefender.com>
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

The KVMI_VCPU_INJECT_EXCEPTION command is used by the introspection tool
to inject exceptions, for example, to get a page from swap.

The exception is queued right before entering in guest unless there is
already an exception pending. The introspection tool is notified with
an KVMI_EVENT_TRAP event about the success of the injection.  In case
of failure, the introspecion tool is expected to try again later.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               |  74 +++++++++++
 arch/x86/kvm/kvmi.c                           | 103 ++++++++++++++++
 arch/x86/kvm/x86.c                            |   3 +
 include/linux/kvmi_host.h                     |  12 ++
 include/uapi/linux/kvmi.h                     |  20 ++-
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 115 +++++++++++++++++-
 virt/kvm/introspection/kvmi.c                 |  45 +++++++
 virt/kvm/introspection/kvmi_int.h             |   8 ++
 virt/kvm/introspection/kvmi_msg.c             |  50 ++++++--
 9 files changed, 418 insertions(+), 12 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index e1f978fc799b..4263a9ac90e4 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -561,6 +561,7 @@ because these are sent as a result of certain commands (but they can be
 disallowed by the device manager) ::
 
 	KVMI_EVENT_PAUSE_VCPU
+	KVMI_EVENT_TRAP
 
 The VM events (e.g. *KVMI_EVENT_UNHOOK*) are controlled with
 the *KVMI_VM_CONTROL_EVENTS* command.
@@ -749,6 +750,45 @@ ID set.
 * -KVM_EINVAL - the padding is not zero
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
 
+16. KVMI_VCPU_INJECT_EXCEPTION
+------------------------------
+
+:Architectures: all
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
+The *KVMI_EVENT_TRAP* event will be sent with the effective injected
+exception.
+
+:Errors:
+
+* -KVM_EPERM  - the *KVMI_EVENT_TRAP* event is disallowed
+* -KVM_EINVAL - the selected vCPU is invalid
+* -KVM_EINVAL - the padding is not zero
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+* -KVM_EBUSY - another *KVMI_VCPU_INJECT_EXCEPTION*-*KVMI_EVENT_TRAP* pair
+               is in progress
+
 Events
 ======
 
@@ -960,3 +1000,37 @@ register (see **KVMI_VCPU_CONTROL_EVENTS**).
 
 ``kvmi_event``, the control register number, the old value and the new value
 are sent to the introspection tool. The *CONTINUE* action will set the ``new_val``.
+
+6. KVMI_EVENT_TRAP
+------------------
+
+:Architectures: all
+:Versions: >= 1
+:Actions: CONTINUE, CRASH
+:Parameters:
+
+::
+
+	struct kvmi_event;
+	struct kvmi_event_trap {
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
+	struct kvmi_vcpu_hdr;
+	struct kvmi_event_reply;
+
+This event is sent if a previous *KVMI_VCPU_INJECT_EXCEPTION* command
+took place. Because it has a high priority, it will be sent before any
+other vCPU introspection event.
+
+``kvmi_event``, exception/interrupt number, exception code
+(``error_code``) and address are sent to the introspection tool,
+which should check if its exception has been injected or overridden.
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index e340a2c3500f..0c6ab136084f 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -569,3 +569,106 @@ bool kvmi_cr3_intercepted(struct kvm_vcpu *vcpu)
 	return ret;
 }
 EXPORT_SYMBOL(kvmi_cr3_intercepted);
+
+int kvmi_arch_cmd_vcpu_inject_exception(struct kvm_vcpu *vcpu, u8 vector,
+					u32 error_code, u64 address)
+{
+	struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
+	bool has_error;
+
+	if (vcpui->exception.pending || vcpui->exception.send_event)
+		return -KVM_EBUSY;
+
+	vcpui->exception.pending = true;
+
+	has_error = x86_exception_has_error_code(vector);
+
+	vcpui->exception.nr = vector;
+	vcpui->exception.error_code = has_error ? error_code : 0;
+	vcpui->exception.error_code_valid = has_error;
+	vcpui->exception.address = address;
+
+	return 0;
+}
+
+static void kvmi_arch_queue_exception(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
+	struct x86_exception e = {
+		.vector = vcpui->exception.nr,
+		.error_code_valid = vcpui->exception.error_code_valid,
+		.error_code = vcpui->exception.error_code,
+		.address = vcpui->exception.address,
+	};
+
+	if (e.vector == PF_VECTOR)
+		kvm_inject_page_fault(vcpu, &e);
+	else if (e.error_code_valid)
+		kvm_queue_exception_e(vcpu, e.vector, e.error_code);
+	else
+		kvm_queue_exception(vcpu, e.vector);
+}
+
+static void kvmi_arch_save_injected_event(struct kvm_vcpu *vcpu)
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
+void kvmi_arch_inject_exception(struct kvm_vcpu *vcpu)
+{
+	if (!kvm_event_needs_reinjection(vcpu)) {
+		kvmi_arch_queue_exception(vcpu);
+		kvm_inject_pending_exception(vcpu);
+	}
+
+	kvmi_arch_save_injected_event(vcpu);
+}
+
+static u32 kvmi_send_trap(struct kvm_vcpu *vcpu, u8 nr,
+			  u32 error_code, u64 addr)
+{
+	struct kvmi_event_trap e;
+	int err, action;
+
+	memset(&e, 0, sizeof(e));
+	e.nr = nr;
+	e.error_code = error_code;
+	e.address = addr;
+
+	err = __kvmi_send_event(vcpu, KVMI_EVENT_TRAP, &e, sizeof(e),
+				NULL, 0, &action);
+	if (err)
+		return KVMI_EVENT_ACTION_CONTINUE;
+
+	return action;
+}
+
+void kvmi_arch_send_trap_event(struct kvm_vcpu *vcpu)
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
+		kvmi_handle_common_event_actions(vcpu->kvm, action);
+	}
+}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a12aa8e125d3..af987ad1a174 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8566,6 +8566,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		goto cancel_injection;
 	}
 
+	if (!kvmi_enter_guest(vcpu))
+		req_immediate_exit = true;
+
 	if (req_immediate_exit) {
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
 		kvm_x86_ops.request_immediate_exit(vcpu);
diff --git a/include/linux/kvmi_host.h b/include/linux/kvmi_host.h
index 01219c56d042..1fae589d9d35 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -36,6 +36,15 @@ struct kvm_vcpu_introspection {
 
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
@@ -76,6 +85,7 @@ int kvmi_ioctl_preunhook(struct kvm *kvm);
 void kvmi_handle_requests(struct kvm_vcpu *vcpu);
 bool kvmi_hypercall_event(struct kvm_vcpu *vcpu);
 bool kvmi_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva, u8 insn_len);
+bool kvmi_enter_guest(struct kvm_vcpu *vcpu);
 
 #else
 
@@ -90,6 +100,8 @@ static inline bool kvmi_hypercall_event(struct kvm_vcpu *vcpu) { return false; }
 static inline bool kvmi_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva,
 					 u8 insn_len)
 			{ return true; }
+static inline bool kvmi_enter_guest(struct kvm_vcpu *vcpu)
+			{ return true; }
 
 #endif /* CONFIG_KVM_INTROSPECTION */
 
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index e31b474e3496..faf4624d7a97 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -34,7 +34,8 @@ enum {
 
 	KVMI_VM_CONTROL_CLEANUP = 14,
 
-	KVMI_VCPU_CONTROL_CR = 15,
+	KVMI_VCPU_CONTROL_CR       = 15,
+	KVMI_VCPU_INJECT_EXCEPTION = 16,
 
 	KVMI_NUM_MESSAGES
 };
@@ -45,6 +46,7 @@ enum {
 	KVMI_EVENT_HYPERCALL  = 2,
 	KVMI_EVENT_BREAKPOINT = 3,
 	KVMI_EVENT_CR         = 4,
+	KVMI_EVENT_TRAP       = 5,
 
 	KVMI_NUM_EVENTS
 };
@@ -162,4 +164,20 @@ struct kvmi_event_reply {
 	__u32 padding2;
 };
 
+struct kvmi_event_trap {
+	__u8 nr;
+	__u8 padding1;
+	__u16 padding2;
+	__u32 error_code;
+	__u64 address;
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
 #endif /* _UAPI__LINUX_KVMI_H */
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 7694fa8fef89..9abf4ec0d09a 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -45,6 +45,8 @@ struct vcpu_worker_data {
 	int vcpu_id;
 	int test_id;
 	bool stop;
+	bool shutdown;
+	bool restart_on_shutdown;
 };
 
 enum {
@@ -687,11 +689,19 @@ static void *vcpu_worker(void *data)
 
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
 
@@ -1308,6 +1318,108 @@ static void test_cmd_vcpu_control_cr(struct kvm_vm *vm)
 	test_invalid_vcpu_control_cr(vm);
 }
 
+static void __inject_exception(int nr)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vcpu_hdr vcpu_hdr;
+		struct kvmi_vcpu_inject_exception cmd;
+	} req = {};
+	int r;
+
+	req.cmd.nr = nr;
+
+	r = __do_vcpu0_command(KVMI_VCPU_INJECT_EXCEPTION,
+			       &req.hdr, sizeof(req), NULL, 0);
+	TEST_ASSERT(r == 0,
+		"KVMI_VCPU_INJECT_EXCEPTION failed, error %d(%s)\n",
+		-r, kvm_strerror(-r));
+}
+
+static void receive_exception_event(int nr)
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
+	pr_info("Exception event: vector %u, error_code 0x%x, address 0x%llx\n",
+		ev.trap.nr, ev.trap.error_code, ev.trap.address);
+
+	TEST_ASSERT(ev.trap.nr == nr,
+		"Injected exception %u instead of %u\n",
+		ev.trap.nr, nr);
+
+	reply_to_event(&hdr, &ev.common, KVMI_EVENT_ACTION_CONTINUE,
+			&rpl, sizeof(rpl));
+}
+
+static void test_succeded_ud_injection(void)
+{
+	__u8 ud_vector = 6;
+
+	__inject_exception(ud_vector);
+
+	receive_exception_event(ud_vector);
+}
+
+static void test_failed_ud_injection(struct kvm_vm *vm,
+				     struct vcpu_worker_data *data)
+{
+	struct kvmi_msg_hdr hdr;
+	struct {
+		struct kvmi_event common;
+		struct kvmi_event_breakpoint bp;
+	} ev;
+	struct vcpu_reply rpl = {};
+	__u8 ud_vector = 6, bp_vector = 3;
+
+	WRITE_ONCE(data->test_id, GUEST_TEST_BP);
+
+	receive_event(&hdr, &ev.common, sizeof(ev), KVMI_EVENT_BREAKPOINT);
+
+	/* skip the breakpoint instruction, next time guest_bp_test() runs */
+	ev.common.arch.regs.rip += ev.bp.insn_len;
+	__set_registers(vm, &ev.common.arch.regs);
+
+	__inject_exception(ud_vector);
+
+	/* reinject the #BP exception because of the continue action */
+	reply_to_event(&hdr, &ev.common, KVMI_EVENT_ACTION_CONTINUE,
+			&rpl, sizeof(rpl));
+
+	receive_exception_event(bp_vector);
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
+	pthread_t vcpu_thread;
+
+	if (!is_intel_cpu()) {
+		print_skip("TODO: %s() - make it work with AMD", __func__);
+		return;
+	}
+
+	enable_vcpu_event(vm, KVMI_EVENT_BREAKPOINT);
+	vcpu_thread = start_vcpu_worker(&data);
+
+	test_succeded_ud_injection();
+	test_failed_ud_injection(vm, &data);
+
+	stop_vcpu_worker(vcpu_thread, &data);
+	disable_vcpu_event(vm, KVMI_EVENT_BREAKPOINT);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	srandom(time(0));
@@ -1332,6 +1444,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_event_breakpoint(vm);
 	test_cmd_vm_control_cleanup(vm);
 	test_cmd_vcpu_control_cr(vm);
+	test_cmd_vcpu_inject_exception(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 2dd82aa5e11c..d4b39d0800ee 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -101,6 +101,7 @@ static void setup_known_events(void)
 	set_bit(KVMI_EVENT_CR, Kvmi_known_vcpu_events);
 	set_bit(KVMI_EVENT_HYPERCALL, Kvmi_known_vcpu_events);
 	set_bit(KVMI_EVENT_PAUSE_VCPU, Kvmi_known_vcpu_events);
+	set_bit(KVMI_EVENT_TRAP, Kvmi_known_vcpu_events);
 
 	bitmap_or(Kvmi_known_events, Kvmi_known_vm_events,
 		  Kvmi_known_vcpu_events, KVMI_NUM_EVENTS);
@@ -855,6 +856,16 @@ static void kvmi_vcpu_pause_event(struct kvm_vcpu *vcpu)
 	}
 }
 
+void kvmi_send_pending_event(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
+
+	if (vcpui->exception.send_event) {
+		vcpui->exception.send_event = false;
+		kvmi_arch_send_trap_event(vcpu);
+	}
+}
+
 void kvmi_handle_requests(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
@@ -864,6 +875,8 @@ void kvmi_handle_requests(struct kvm_vcpu *vcpu)
 	if (!kvmi)
 		goto out;
 
+	kvmi_send_pending_event(vcpu);
+
 	for (;;) {
 		kvmi_run_jobs(vcpu);
 
@@ -962,3 +975,35 @@ bool kvmi_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva, u8 insn_len)
 	return ret;
 }
 EXPORT_SYMBOL(kvmi_breakpoint_event);
+
+static void kvmi_inject_pending_exception(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
+
+	kvmi_arch_inject_exception(vcpu);
+
+	vcpui->exception.pending = false;
+	vcpui->exception.send_event = true;
+	kvm_make_request(KVM_REQ_INTROSPECTION, vcpu);
+}
+
+bool kvmi_enter_guest(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_introspection *vcpui;
+	struct kvm_introspection *kvmi;
+	bool r = true;
+
+	kvmi = kvmi_get(vcpu->kvm);
+	if (!kvmi)
+		return true;
+
+	vcpui = VCPUI(vcpu);
+
+	if (vcpui->exception.pending) {
+		kvmi_inject_pending_exception(vcpu);
+		r = false;
+	}
+
+	kvmi_put(vcpu->kvm);
+	return r;
+}
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index c206376eb0ad..51c03097a7d5 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -34,6 +34,9 @@ bool kvmi_msg_process(struct kvm_introspection *kvmi);
 int kvmi_send_event(struct kvm_vcpu *vcpu, u32 ev_id,
 		    void *ev, size_t ev_size,
 		    void *rpl, size_t rpl_size, int *action);
+int __kvmi_send_event(struct kvm_vcpu *vcpu, u32 ev_id,
+		      void *ev, size_t ev_size,
+		      void *rpl, size_t rpl_size, int *action);
 int kvmi_msg_send_unhook(struct kvm_introspection *kvmi);
 u32 kvmi_msg_send_vcpu_pause(struct kvm_vcpu *vcpu);
 u32 kvmi_msg_send_hypercall(struct kvm_vcpu *vcpu);
@@ -55,6 +58,7 @@ void kvmi_handle_common_event_actions(struct kvm *kvm, u32 action);
 void kvmi_cmd_vm_control_cleanup(struct kvm_introspection *kvmi, bool enable);
 struct kvm_introspection * __must_check kvmi_get(struct kvm *kvm);
 void kvmi_put(struct kvm *kvm);
+void kvmi_send_pending_event(struct kvm_vcpu *vcpu);
 int kvmi_cmd_vm_control_events(struct kvm_introspection *kvmi,
 				unsigned int event_id, bool enable);
 int kvmi_cmd_vcpu_control_events(struct kvm_vcpu *vcpu,
@@ -97,5 +101,9 @@ int kvmi_arch_cmd_control_intercept(struct kvm_vcpu *vcpu,
 				    unsigned int event_id, bool enable);
 int kvmi_arch_cmd_vcpu_control_cr(struct kvm_vcpu *vcpu,
 				  const struct kvmi_vcpu_control_cr *req);
+int kvmi_arch_cmd_vcpu_inject_exception(struct kvm_vcpu *vcpu, u8 vector,
+					u32 error_code, u64 address);
+void kvmi_arch_send_trap_event(struct kvm_vcpu *vcpu);
+void kvmi_arch_inject_exception(struct kvm_vcpu *vcpu);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 330fad27e1df..63efb85ff1ae 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -492,6 +492,25 @@ static int handle_vcpu_control_cr(const struct kvmi_vcpu_msg_job *job,
 	return kvmi_msg_vcpu_reply(job, msg, ec, NULL, 0);
 }
 
+static int handle_vcpu_inject_exception(const struct kvmi_vcpu_msg_job *job,
+					const struct kvmi_msg_hdr *msg,
+					const void *_req)
+{
+	const struct kvmi_vcpu_inject_exception *req = _req;
+	int ec;
+
+	if (!is_event_allowed(KVMI(job->vcpu->kvm), KVMI_EVENT_TRAP))
+		ec = -KVM_EPERM;
+	else if (req->padding1 || req->padding2)
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
  * These functions are executed from the vCPU thread. The receiving thread
  * passes the messages using a newly allocated 'struct kvmi_vcpu_msg_job'
@@ -500,13 +519,14 @@ static int handle_vcpu_control_cr(const struct kvmi_vcpu_msg_job *job,
  */
 static int(*const msg_vcpu[])(const struct kvmi_vcpu_msg_job *,
 			      const struct kvmi_msg_hdr *, const void *) = {
-	[KVMI_EVENT]               = handle_vcpu_event_reply,
-	[KVMI_VCPU_CONTROL_CR]     = handle_vcpu_control_cr,
-	[KVMI_VCPU_CONTROL_EVENTS] = handle_vcpu_control_events,
-	[KVMI_VCPU_GET_CPUID]      = handle_vcpu_get_cpuid,
-	[KVMI_VCPU_GET_INFO]       = handle_vcpu_get_info,
-	[KVMI_VCPU_GET_REGISTERS]  = handle_vcpu_get_registers,
-	[KVMI_VCPU_SET_REGISTERS]  = handle_vcpu_set_registers,
+	[KVMI_EVENT]                 = handle_vcpu_event_reply,
+	[KVMI_VCPU_CONTROL_CR]       = handle_vcpu_control_cr,
+	[KVMI_VCPU_CONTROL_EVENTS]   = handle_vcpu_control_events,
+	[KVMI_VCPU_GET_CPUID]        = handle_vcpu_get_cpuid,
+	[KVMI_VCPU_GET_INFO]         = handle_vcpu_get_info,
+	[KVMI_VCPU_GET_REGISTERS]    = handle_vcpu_get_registers,
+	[KVMI_VCPU_INJECT_EXCEPTION] = handle_vcpu_inject_exception,
+	[KVMI_VCPU_SET_REGISTERS]    = handle_vcpu_set_registers,
 };
 
 static bool is_vcpu_command(u16 id)
@@ -770,9 +790,9 @@ static void kvmi_setup_vcpu_reply(struct kvm_vcpu_introspection *vcpui,
 	vcpui->waiting_for_reply = true;
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
@@ -812,6 +832,16 @@ int kvmi_send_event(struct kvm_vcpu *vcpu, u32 ev_id,
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
