Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE3C52C3CAA
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 10:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728528AbgKYJmg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 04:42:36 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:57224 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728077AbgKYJmE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Nov 2020 04:42:04 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 272B9305D3CB;
        Wed, 25 Nov 2020 11:35:53 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id EC2873072785;
        Wed, 25 Nov 2020 11:35:52 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v10 63/81] KVM: introspection: add KVMI_VCPU_INJECT_EXCEPTION + KVMI_VCPU_EVENT_TRAP
Date:   Wed, 25 Nov 2020 11:35:42 +0200
Message-Id: <20201125093600.2766-64-alazar@bitdefender.com>
In-Reply-To: <20201125093600.2766-1-alazar@bitdefender.com>
References: <20201125093600.2766-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

The KVMI_VCPU_INJECT_EXCEPTION command is used by the introspection tool
to inject exceptions, for example, to get a page from swap.

The exception is injected right before entering in guest unless there is
already an exception pending. The introspection tool is notified with
an KVMI_VCPU_EVENT_TRAP event about the success of the injection. In
case of failure, the introspection tool is expected to try again later.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Nicușor Cîțu <nicu.citu@icloud.com>
Signed-off-by: Nicușor Cîțu <nicu.citu@icloud.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               |  76 +++++++++++
 arch/x86/include/asm/kvmi_host.h              |  11 ++
 arch/x86/include/uapi/asm/kvmi.h              |  16 +++
 arch/x86/kvm/kvmi.c                           | 110 ++++++++++++++++
 arch/x86/kvm/kvmi.h                           |   3 +
 arch/x86/kvm/kvmi_msg.c                       |  55 +++++++-
 arch/x86/kvm/x86.c                            |   2 +
 include/uapi/linux/kvmi.h                     |  14 +-
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 124 ++++++++++++++++++
 virt/kvm/introspection/kvmi.c                 |   2 +
 virt/kvm/introspection/kvmi_int.h             |   4 +
 virt/kvm/introspection/kvmi_msg.c             |  16 ++-
 12 files changed, 419 insertions(+), 14 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 85e14b82aa2f..e688ac387faf 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -550,6 +550,7 @@ because these are sent as a result of certain commands (but they can be
 disallowed by the device manager) ::
 
 	KVMI_VCPU_EVENT_PAUSE
+	KVMI_VCPU_EVENT_TRAP
 
 The VM events (e.g. *KVMI_VM_EVENT_UNHOOK*) are controlled with
 the *KVMI_VM_CONTROL_EVENTS* command.
@@ -736,6 +737,46 @@ ID set.
 * -KVM_EINVAL - the padding is not zero
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
 
+16. KVMI_VCPU_INJECT_EXCEPTION
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
+Injects a vCPU exception (``nr``) with or without an error code (``error_code``).
+For page fault exceptions, the guest virtual address (``address``)
+has to be specified too.
+
+The *KVMI_VCPU_EVENT_TRAP* event will be sent with the effective injected
+exception.
+
+:Errors:
+
+* -KVM_EPERM  - the *KVMI_VCPU_EVENT_TRAP* event is disallowed
+* -KVM_EINVAL - the selected vCPU is invalid
+* -KVM_EINVAL - the padding is not zero
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+* -KVM_EBUSY - another *KVMI_VCPU_INJECT_EXCEPTION*-*KVMI_VCPU_EVENT_TRAP*
+               pair is in progress
+
 Events
 ======
 
@@ -966,3 +1007,38 @@ register (see **KVMI_VCPU_CONTROL_EVENTS**).
 (``cr``), the old value (``old_value``) and the new value (``new_value``)
 are sent to the introspection tool. The *CONTINUE* action will set the
 ``new_val``.
+
+6. KVMI_VCPU_EVENT_TRAP
+-----------------------
+
+:Architectures: x86
+:Versions: >= 1
+:Actions: CONTINUE, CRASH
+:Parameters:
+
+::
+
+	struct kvmi_vcpu_event;
+	struct kvmi_vcpu_event_trap {
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
+	struct kvmi_vcpu_event_reply;
+
+This event is sent if a previous *KVMI_VCPU_INJECT_EXCEPTION* command
+took place. Because it has a high priority, it will be sent before any
+other vCPU introspection event.
+
+``kvmi_vcpu_event`` (with the vCPU state), exception/interrupt number
+(``nr``), exception code (``error_code``) and ``address`` are sent to
+the introspection tool, which should check if its exception has been
+injected or overridden.
diff --git a/arch/x86/include/asm/kvmi_host.h b/arch/x86/include/asm/kvmi_host.h
index edbedf031467..97f5b1a01c9e 100644
--- a/arch/x86/include/asm/kvmi_host.h
+++ b/arch/x86/include/asm/kvmi_host.h
@@ -24,6 +24,15 @@ struct kvm_vcpu_arch_introspection {
 	bool have_delayed_regs;
 
 	DECLARE_BITMAP(cr_mask, KVMI_NUM_CR);
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
 
 struct kvm_arch_introspection {
@@ -36,6 +45,7 @@ bool kvmi_cr_event(struct kvm_vcpu *vcpu, unsigned int cr,
 		   unsigned long old_value, unsigned long *new_value);
 bool kvmi_cr3_intercepted(struct kvm_vcpu *vcpu);
 bool kvmi_monitor_cr3w_intercept(struct kvm_vcpu *vcpu, bool enable);
+void kvmi_enter_guest(struct kvm_vcpu *vcpu);
 
 #else /* CONFIG_KVM_INTROSPECTION */
 
@@ -48,6 +58,7 @@ static inline bool kvmi_cr_event(struct kvm_vcpu *vcpu, unsigned int cr,
 static inline bool kvmi_cr3_intercepted(struct kvm_vcpu *vcpu) { return false; }
 static inline bool kvmi_monitor_cr3w_intercept(struct kvm_vcpu *vcpu,
 						bool enable) { return false; }
+static inline void kvmi_enter_guest(struct kvm_vcpu *vcpu) { }
 
 #endif /* CONFIG_KVM_INTROSPECTION */
 
diff --git a/arch/x86/include/uapi/asm/kvmi.h b/arch/x86/include/uapi/asm/kvmi.h
index 32cd17488058..aa991fbab473 100644
--- a/arch/x86/include/uapi/asm/kvmi.h
+++ b/arch/x86/include/uapi/asm/kvmi.h
@@ -79,4 +79,20 @@ struct kvmi_vcpu_event_cr_reply {
 	__u64 new_val;
 };
 
+struct kvmi_vcpu_event_trap {
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
 #endif /* _UAPI_ASM_X86_KVMI_H */
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 8ad3698e5988..52b46d56ebb5 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -15,6 +15,7 @@ void kvmi_arch_init_vcpu_events_mask(unsigned long *supported)
 	set_bit(KVMI_VCPU_EVENT_BREAKPOINT, supported);
 	set_bit(KVMI_VCPU_EVENT_CR, supported);
 	set_bit(KVMI_VCPU_EVENT_HYPERCALL, supported);
+	set_bit(KVMI_VCPU_EVENT_TRAP, supported);
 }
 
 static unsigned int kvmi_vcpu_mode(const struct kvm_vcpu *vcpu,
@@ -457,3 +458,112 @@ bool kvmi_cr3_intercepted(struct kvm_vcpu *vcpu)
 	return ret;
 }
 EXPORT_SYMBOL(kvmi_cr3_intercepted);
+
+int kvmi_arch_cmd_vcpu_inject_exception(struct kvm_vcpu *vcpu,
+					const struct kvmi_vcpu_inject_exception *req)
+{
+	struct kvm_vcpu_arch_introspection *arch = &VCPUI(vcpu)->arch;
+	bool has_error;
+
+	arch->exception.pending = true;
+
+	has_error = x86_exception_has_error_code(req->nr);
+
+	arch->exception.nr = req->nr;
+	arch->exception.error_code = has_error ? req->error_code : 0;
+	arch->exception.error_code_valid = has_error;
+	arch->exception.address = req->address;
+
+	return 0;
+}
+
+static void kvmi_queue_exception(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_arch_introspection *arch = &VCPUI(vcpu)->arch;
+	struct x86_exception e = {
+		.vector = arch->exception.nr,
+		.error_code_valid = arch->exception.error_code_valid,
+		.error_code = arch->exception.error_code,
+		.address = arch->exception.address,
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
+static void kvmi_save_injected_event(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
+
+	vcpui->arch.exception.error_code = 0;
+	vcpui->arch.exception.error_code_valid = false;
+
+	vcpui->arch.exception.address = vcpu->arch.cr2;
+	if (vcpu->arch.exception.injected) {
+		vcpui->arch.exception.nr = vcpu->arch.exception.nr;
+		vcpui->arch.exception.error_code_valid =
+			x86_exception_has_error_code(vcpu->arch.exception.nr);
+		vcpui->arch.exception.error_code = vcpu->arch.exception.error_code;
+	} else if (vcpu->arch.interrupt.injected) {
+		vcpui->arch.exception.nr = vcpu->arch.interrupt.nr;
+	}
+}
+
+static void kvmi_inject_pending_exception(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
+
+	if (!kvm_event_needs_reinjection(vcpu)) {
+		kvmi_queue_exception(vcpu);
+		kvm_inject_pending_exception(vcpu);
+	}
+
+	kvmi_save_injected_event(vcpu);
+
+	vcpui->arch.exception.pending = false;
+	vcpui->arch.exception.send_event = true;
+	kvm_make_request(KVM_REQ_INTROSPECTION, vcpu);
+}
+
+void kvmi_enter_guest(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_introspection *vcpui;
+	struct kvm_introspection *kvmi;
+
+	kvmi = kvmi_get(vcpu->kvm);
+	if (kvmi) {
+		vcpui = VCPUI(vcpu);
+
+		if (vcpui->arch.exception.pending)
+			kvmi_inject_pending_exception(vcpu);
+
+		kvmi_put(vcpu->kvm);
+	}
+}
+
+static void kvmi_send_trap_event(struct kvm_vcpu *vcpu)
+{
+	u32 action;
+
+	action = kvmi_msg_send_vcpu_trap(vcpu);
+	switch (action) {
+	case KVMI_EVENT_ACTION_CONTINUE:
+		break;
+	default:
+		kvmi_handle_common_event_actions(vcpu, action);
+	}
+}
+
+void kvmi_arch_send_pending_event(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
+
+	if (vcpui->arch.exception.send_event) {
+		vcpui->arch.exception.send_event = false;
+		kvmi_send_trap_event(vcpu);
+	}
+}
diff --git a/arch/x86/kvm/kvmi.h b/arch/x86/kvm/kvmi.h
index 6a444428b831..265fece148d2 100644
--- a/arch/x86/kvm/kvmi.h
+++ b/arch/x86/kvm/kvmi.h
@@ -8,8 +8,11 @@ int kvmi_arch_cmd_vcpu_get_registers(struct kvm_vcpu *vcpu,
 void kvmi_arch_cmd_vcpu_set_registers(struct kvm_vcpu *vcpu,
 				      const struct kvm_regs *regs);
 int kvmi_arch_cmd_vcpu_control_cr(struct kvm_vcpu *vcpu, int cr, bool enable);
+int kvmi_arch_cmd_vcpu_inject_exception(struct kvm_vcpu *vcpu,
+				const struct kvmi_vcpu_inject_exception *req);
 
 u32 kvmi_msg_send_vcpu_cr(struct kvm_vcpu *vcpu, u32 cr, u64 old_value,
 			  u64 new_value, u64 *ret_value);
+u32 kvmi_msg_send_vcpu_trap(struct kvm_vcpu *vcpu);
 
 #endif
diff --git a/arch/x86/kvm/kvmi_msg.c b/arch/x86/kvm/kvmi_msg.c
index 34aedb4785e4..0b73142ab73a 100644
--- a/arch/x86/kvm/kvmi_msg.c
+++ b/arch/x86/kvm/kvmi_msg.c
@@ -150,12 +150,37 @@ static int handle_vcpu_control_cr(const struct kvmi_vcpu_msg_job *job,
 	return kvmi_msg_vcpu_reply(job, msg, ec, NULL, 0);
 }
 
+static int handle_vcpu_inject_exception(const struct kvmi_vcpu_msg_job *job,
+					const struct kvmi_msg_hdr *msg,
+					const void *_req)
+{
+	const struct kvmi_vcpu_inject_exception *req = _req;
+	struct kvm_vcpu_arch_introspection *arch;
+	struct kvm_vcpu *vcpu = job->vcpu;
+	int ec;
+
+	arch = &VCPUI(vcpu)->arch;
+
+	if (!kvmi_is_event_allowed(KVMI(vcpu->kvm), KVMI_VCPU_EVENT_TRAP))
+		ec = -KVM_EPERM;
+	else if (req->padding1 || req->padding2)
+		ec = -KVM_EINVAL;
+	else if (VCPUI(vcpu)->arch.exception.pending ||
+			VCPUI(vcpu)->arch.exception.send_event)
+		ec = -KVM_EBUSY;
+	else
+		ec = kvmi_arch_cmd_vcpu_inject_exception(vcpu, req);
+
+	return kvmi_msg_vcpu_reply(job, msg, ec, NULL, 0);
+}
+
 static kvmi_vcpu_msg_job_fct const msg_vcpu[] = {
-	[KVMI_VCPU_CONTROL_CR]    = handle_vcpu_control_cr,
-	[KVMI_VCPU_GET_CPUID]     = handle_vcpu_get_cpuid,
-	[KVMI_VCPU_GET_INFO]      = handle_vcpu_get_info,
-	[KVMI_VCPU_GET_REGISTERS] = handle_vcpu_get_registers,
-	[KVMI_VCPU_SET_REGISTERS] = handle_vcpu_set_registers,
+	[KVMI_VCPU_CONTROL_CR]       = handle_vcpu_control_cr,
+	[KVMI_VCPU_GET_CPUID]        = handle_vcpu_get_cpuid,
+	[KVMI_VCPU_GET_INFO]         = handle_vcpu_get_info,
+	[KVMI_VCPU_GET_REGISTERS]    = handle_vcpu_get_registers,
+	[KVMI_VCPU_INJECT_EXCEPTION] = handle_vcpu_inject_exception,
+	[KVMI_VCPU_SET_REGISTERS]    = handle_vcpu_set_registers,
 };
 
 kvmi_vcpu_msg_job_fct kvmi_arch_vcpu_msg_handler(u16 id)
@@ -187,3 +212,23 @@ u32 kvmi_msg_send_vcpu_cr(struct kvm_vcpu *vcpu, u32 cr, u64 old_value,
 
 	return action;
 }
+
+u32 kvmi_msg_send_vcpu_trap(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
+	struct kvmi_vcpu_event_trap e;
+	u32 action;
+	int err;
+
+	memset(&e, 0, sizeof(e));
+	e.nr = vcpui->arch.exception.nr;
+	e.error_code = vcpui->arch.exception.error_code;
+	e.address = vcpui->arch.exception.address;
+
+	err = __kvmi_send_vcpu_event(vcpu, KVMI_VCPU_EVENT_TRAP,
+				     &e, sizeof(e), NULL, 0, &action);
+	if (err)
+		action = KVMI_EVENT_ACTION_CONTINUE;
+
+	return action;
+}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9a4ec0b4714c..beb183b9f979 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9008,6 +9008,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		goto cancel_injection;
 	}
 
+	kvmi_enter_guest(vcpu);
+
 	if (req_immediate_exit) {
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
 		kvm_x86_ops.request_immediate_exit(vcpu);
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index c1d8cf02018b..263d98a5903e 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -36,12 +36,13 @@ enum {
 enum {
 	KVMI_VCPU_EVENT = KVMI_VCPU_MESSAGE_ID(0),
 
-	KVMI_VCPU_GET_INFO       = KVMI_VCPU_MESSAGE_ID(1),
-	KVMI_VCPU_CONTROL_EVENTS = KVMI_VCPU_MESSAGE_ID(2),
-	KVMI_VCPU_GET_REGISTERS  = KVMI_VCPU_MESSAGE_ID(3),
-	KVMI_VCPU_SET_REGISTERS  = KVMI_VCPU_MESSAGE_ID(4),
-	KVMI_VCPU_GET_CPUID      = KVMI_VCPU_MESSAGE_ID(5),
-	KVMI_VCPU_CONTROL_CR     = KVMI_VCPU_MESSAGE_ID(6),
+	KVMI_VCPU_GET_INFO         = KVMI_VCPU_MESSAGE_ID(1),
+	KVMI_VCPU_CONTROL_EVENTS   = KVMI_VCPU_MESSAGE_ID(2),
+	KVMI_VCPU_GET_REGISTERS    = KVMI_VCPU_MESSAGE_ID(3),
+	KVMI_VCPU_SET_REGISTERS    = KVMI_VCPU_MESSAGE_ID(4),
+	KVMI_VCPU_GET_CPUID        = KVMI_VCPU_MESSAGE_ID(5),
+	KVMI_VCPU_CONTROL_CR       = KVMI_VCPU_MESSAGE_ID(6),
+	KVMI_VCPU_INJECT_EXCEPTION = KVMI_VCPU_MESSAGE_ID(7),
 
 	KVMI_NEXT_VCPU_MESSAGE
 };
@@ -60,6 +61,7 @@ enum {
 	KVMI_VCPU_EVENT_HYPERCALL  = KVMI_VCPU_EVENT_ID(1),
 	KVMI_VCPU_EVENT_BREAKPOINT = KVMI_VCPU_EVENT_ID(2),
 	KVMI_VCPU_EVENT_CR         = KVMI_VCPU_EVENT_ID(3),
+	KVMI_VCPU_EVENT_TRAP       = KVMI_VCPU_EVENT_ID(4),
 
 	KVMI_NEXT_VCPU_EVENT
 };
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 6a1103eab77a..dc9f2f0d99e8 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -49,6 +49,7 @@ struct vcpu_worker_data {
 	struct kvm_vm *vm;
 	int vcpu_id;
 	int test_id;
+	bool restart_on_shutdown;
 };
 
 enum {
@@ -633,6 +634,10 @@ static void *vcpu_worker(void *data)
 
 		vcpu_run(ctx->vm, ctx->vcpu_id);
 
+		if (run->exit_reason == KVM_EXIT_SHUTDOWN &&
+		    ctx->restart_on_shutdown)
+			continue;
+
 		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
 			"vcpu_run() failed, test_id %d, exit reason %u (%s)\n",
 			ctx->test_id, run->exit_reason,
@@ -1199,6 +1204,124 @@ static void test_cmd_vcpu_control_cr(struct kvm_vm *vm)
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
+static void test_disallowed_trap_event(struct kvm_vm *vm)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vcpu_hdr vcpu_hdr;
+		struct kvmi_vcpu_inject_exception cmd;
+	} req = {};
+
+	disallow_event(vm, KVMI_VCPU_EVENT_TRAP);
+	test_vcpu0_command(vm, KVMI_VCPU_INJECT_EXCEPTION,
+			   &req.hdr, sizeof(req), NULL, 0, -KVM_EPERM);
+	allow_event(vm, KVMI_VCPU_EVENT_TRAP);
+}
+
+static void receive_exception_event(int nr)
+{
+	struct kvmi_msg_hdr hdr;
+	struct {
+		struct vcpu_event vcpu_ev;
+		struct kvmi_vcpu_event_trap trap;
+	} ev;
+	struct vcpu_reply rpl = {};
+
+	receive_vcpu_event(&hdr, &ev.vcpu_ev, sizeof(ev), KVMI_VCPU_EVENT_TRAP);
+
+	pr_debug("Exception event: vector %u, error_code 0x%x, address 0x%llx\n",
+		ev.trap.nr, ev.trap.error_code, ev.trap.address);
+
+	TEST_ASSERT(ev.trap.nr == nr,
+		"Injected exception %u instead of %u\n",
+		ev.trap.nr, nr);
+
+	reply_to_event(&hdr, &ev.vcpu_ev, KVMI_EVENT_ACTION_CONTINUE,
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
+		struct vcpu_event vcpu_ev;
+		struct kvmi_vcpu_event_breakpoint bp;
+	} ev;
+	struct vcpu_reply rpl = {};
+	__u8 ud_vector = 6, bp_vector = 3;
+
+	WRITE_ONCE(data->test_id, GUEST_TEST_BP);
+
+	receive_vcpu_event(&hdr, &ev.vcpu_ev, sizeof(ev),
+			   KVMI_VCPU_EVENT_BREAKPOINT);
+
+	/* skip the breakpoint instruction, next time guest_bp_test() runs */
+	ev.vcpu_ev.common.arch.regs.rip += ev.bp.insn_len;
+	__set_registers(vm, &ev.vcpu_ev.common.arch.regs);
+
+	__inject_exception(ud_vector);
+
+	/* reinject the #BP exception because of the continue action */
+	reply_to_event(&hdr, &ev.vcpu_ev, KVMI_EVENT_ACTION_CONTINUE,
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
+		.restart_on_shutdown = true,
+	};
+	pthread_t vcpu_thread;
+
+	if (!is_intel_cpu()) {
+		print_skip("TODO: %s() - make it work with AMD", __func__);
+		return;
+	}
+
+	test_disallowed_trap_event(vm);
+
+	enable_vcpu_event(vm, KVMI_VCPU_EVENT_BREAKPOINT);
+	vcpu_thread = start_vcpu_worker(&data);
+
+	test_succeded_ud_injection();
+	test_failed_ud_injection(vm, &data);
+
+	wait_vcpu_worker(vcpu_thread);
+	disable_vcpu_event(vm, KVMI_VCPU_EVENT_BREAKPOINT);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	srandom(time(0));
@@ -1223,6 +1346,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_event_breakpoint(vm);
 	test_cmd_vm_control_cleanup(vm);
 	test_cmd_vcpu_control_cr(vm);
+	test_cmd_vcpu_inject_exception(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index e6333708c584..b366ba6820d6 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -845,6 +845,8 @@ void kvmi_handle_requests(struct kvm_vcpu *vcpu)
 	if (!kvmi)
 		goto out;
 
+	kvmi_arch_send_pending_event(vcpu);
+
 	for (;;) {
 		kvmi_run_jobs(vcpu);
 
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index b1877a770fcb..0a7a8285b981 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -48,6 +48,9 @@ int kvmi_msg_send_unhook(struct kvm_introspection *kvmi);
 int kvmi_send_vcpu_event(struct kvm_vcpu *vcpu, u32 ev_id,
 			 void *ev, size_t ev_size,
 			 void *rpl, size_t rpl_size, u32 *action);
+int __kvmi_send_vcpu_event(struct kvm_vcpu *vcpu, u32 ev_id,
+			   void *ev, size_t ev_size,
+			   void *rpl, size_t rpl_size, u32 *action);
 int kvmi_msg_vcpu_reply(const struct kvmi_vcpu_msg_job *job,
 			const struct kvmi_msg_hdr *msg, int err,
 			const void *rpl, size_t rpl_size);
@@ -100,5 +103,6 @@ bool kvmi_arch_is_agent_hypercall(struct kvm_vcpu *vcpu);
 void kvmi_arch_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva, u8 insn_len);
 int kvmi_arch_cmd_control_intercept(struct kvm_vcpu *vcpu,
 				    unsigned int event_id, bool enable);
+void kvmi_arch_send_pending_event(struct kvm_vcpu *vcpu);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 9c1d69caaf11..762fb5227dd9 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -715,9 +715,9 @@ static int kvmi_fill_and_sent_vcpu_event(struct kvm_vcpu *vcpu,
 	return kvmi_sock_write(kvmi, vec, n, msg_size);
 }
 
-int kvmi_send_vcpu_event(struct kvm_vcpu *vcpu, u32 ev_id,
-			 void *ev, size_t ev_size,
-			 void *rpl, size_t rpl_size, u32 *action)
+int __kvmi_send_vcpu_event(struct kvm_vcpu *vcpu, u32 ev_id,
+			   void *ev, size_t ev_size,
+			   void *rpl, size_t rpl_size, u32 *action)
 {
 	struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
 	struct kvm_introspection *kvmi = KVMI(vcpu->kvm);
@@ -745,6 +745,16 @@ int kvmi_send_vcpu_event(struct kvm_vcpu *vcpu, u32 ev_id,
 	return err;
 }
 
+int kvmi_send_vcpu_event(struct kvm_vcpu *vcpu,
+			 u32 ev_id, void *ev, size_t ev_size,
+			 void *rpl, size_t rpl_size, u32 *action)
+{
+	kvmi_arch_send_pending_event(vcpu);
+
+	return __kvmi_send_vcpu_event(vcpu, ev_id, ev, ev_size,
+				      rpl, rpl_size, action);
+}
+
 u32 kvmi_msg_send_vcpu_pause(struct kvm_vcpu *vcpu)
 {
 	u32 action;
