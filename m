Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62B422D1B2D
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 21:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727413AbgLGUsl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 15:48:41 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:42598 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727330AbgLGUsi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 15:48:38 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id D928D305D477;
        Mon,  7 Dec 2020 22:46:21 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id A1A423072784;
        Mon,  7 Dec 2020 22:46:21 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v11 56/81] KVM: introspection: add KVMI_VCPU_EVENT_HYPERCALL
Date:   Mon,  7 Dec 2020 22:45:57 +0200
Message-Id: <20201207204622.15258-57-alazar@bitdefender.com>
In-Reply-To: <20201207204622.15258-1-alazar@bitdefender.com>
References: <20201207204622.15258-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

This event is sent on a specific hypercall.

It is used by the code residing inside the introspected guest to call the
introspection tool and to report certain details about its operation.
For example, a classic antimalware remediation tool can report
what it has found during a scan.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/hypercalls.rst         | 35 ++++++++++++++++
 Documentation/virt/kvm/kvmi.rst               | 40 +++++++++++++++++-
 arch/x86/include/uapi/asm/kvmi.h              |  4 ++
 arch/x86/kvm/kvmi.c                           | 20 +++++++++
 arch/x86/kvm/x86.c                            | 18 ++++++--
 include/linux/kvmi_host.h                     |  2 +
 include/uapi/linux/kvm_para.h                 |  1 +
 include/uapi/linux/kvmi.h                     |  3 +-
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 42 +++++++++++++++++++
 virt/kvm/introspection/kvmi.c                 | 38 +++++++++++++++++
 virt/kvm/introspection/kvmi_int.h             |  8 ++++
 virt/kvm/introspection/kvmi_msg.c             | 13 ++++++
 12 files changed, 218 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/hypercalls.rst b/Documentation/virt/kvm/hypercalls.rst
index 70e77c66b64c..abfbff96b9e3 100644
--- a/Documentation/virt/kvm/hypercalls.rst
+++ b/Documentation/virt/kvm/hypercalls.rst
@@ -169,3 +169,38 @@ a0: destination APIC ID
 
 :Usage example: When sending a call-function IPI-many to vCPUs, yield if
 	        any of the IPI target vCPUs was preempted.
+
+9. KVM_HC_XEN_HVM_OP
+--------------------
+
+:Architecture: x86
+:Status: active
+:Purpose: To enable communication between a guest agent and a VMI application
+
+Usage:
+
+An event will be sent to the VMI application (see kvmi.rst) if the following
+registers, which differ between 32bit and 64bit, have the following values:
+
+       ========    =====     =====
+       32bit       64bit     value
+       ========    =====     =====
+       ebx (a0)    rdi       KVM_HC_XEN_HVM_OP_GUEST_REQUEST_VM_EVENT
+       ecx (a1)    rsi       0
+       ========    =====     =====
+
+This specification copies Xen's { __HYPERVISOR_hvm_op,
+HVMOP_guest_request_vm_event } hypercall and can originate from kernel or
+userspace.
+
+It returns 0 if successful, or a negative POSIX.1 error code if it fails. The
+absence of an active VMI application is not signaled in any way.
+
+The following registers are clobbered:
+
+  * 32bit: edx, esi, edi, ebp
+  * 64bit: rdx, r10, r8, r9
+
+In particular, for KVM_HC_XEN_HVM_OP_GUEST_REQUEST_VM_EVENT, the last two
+registers can be poisoned deliberately and cannot be used for passing
+information.
diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 10966430621c..023c885638af 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -535,7 +535,10 @@ command) before returning to guest.
 
 	struct kvmi_error_code
 
-Enables/disables vCPU introspection events.
+Enables/disables vCPU introspection events. This command can be used with
+the following events::
+
+	KVMI_VCPU_EVENT_HYPERCALL
 
 When an event is enabled, the introspection tool is notified and
 must reply with: continue, retry, crash, etc. (see **Events** below).
@@ -779,3 +782,38 @@ cannot be controlled with *KVMI_VCPU_CONTROL_EVENTS*.
 Because it has a low priority, it will be sent after any other vCPU
 introspection event and when no other vCPU introspection command is
 queued.
+
+3. KVMI_VCPU_EVENT_HYPERCALL
+----------------------------
+
+:Architectures: x86
+:Versions: >= 1
+:Actions: CONTINUE, CRASH
+:Parameters:
+
+::
+
+	struct kvmi_event_hdr;
+	struct kvmi_vcpu_event;
+
+:Returns:
+
+::
+
+	struct kvmi_vcpu_hdr;
+	struct kvmi_vcpu_event_reply;
+
+This event is sent on a specific user hypercall when the introspection has
+been enabled for this event (see *KVMI_VCPU_CONTROL_EVENTS*).
+
+The hypercall number must be ``KVM_HC_XEN_HVM_OP`` with the
+``KVM_HC_XEN_HVM_OP_GUEST_REQUEST_VM_EVENT`` sub-function
+(see hypercalls.rst).
+
+It is used by the code residing inside the introspected guest to call the
+introspection tool and to report certain details about its operation. For
+example, a classic antimalware remediation tool can report what it has
+found during a scan.
+
+The most useful registers describing the vCPU state can be read from
+``kvmi_vcpu_event.arch.regs``.
diff --git a/arch/x86/include/uapi/asm/kvmi.h b/arch/x86/include/uapi/asm/kvmi.h
index 3631da9eef8c..a442ba4d2190 100644
--- a/arch/x86/include/uapi/asm/kvmi.h
+++ b/arch/x86/include/uapi/asm/kvmi.h
@@ -8,6 +8,10 @@
 
 #include <asm/kvm.h>
 
+enum {
+	KVM_HC_XEN_HVM_OP_GUEST_REQUEST_VM_EVENT = 24,
+};
+
 struct kvmi_vcpu_get_info_reply {
 	__u64 tsc_speed;
 };
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 39638af7757e..5f08cf0d19bc 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -11,6 +11,7 @@
 
 void kvmi_arch_init_vcpu_events_mask(unsigned long *supported)
 {
+	set_bit(KVMI_VCPU_EVENT_HYPERCALL, supported);
 }
 
 static unsigned int kvmi_vcpu_mode(const struct kvm_vcpu *vcpu,
@@ -140,3 +141,22 @@ void kvmi_arch_post_reply(struct kvm_vcpu *vcpu)
 	kvm_arch_vcpu_set_regs(vcpu, &vcpui->arch.delayed_regs, false);
 	vcpui->arch.have_delayed_regs = false;
 }
+
+bool kvmi_arch_is_agent_hypercall(struct kvm_vcpu *vcpu)
+{
+	unsigned long subfunc1, subfunc2;
+	bool longmode = is_64_bit_mode(vcpu);
+
+	if (longmode) {
+		subfunc1 = kvm_rdi_read(vcpu);
+		subfunc2 = kvm_rsi_read(vcpu);
+	} else {
+		subfunc1 = kvm_rbx_read(vcpu);
+		subfunc1 &= 0xFFFFFFFF;
+		subfunc2 = kvm_rcx_read(vcpu);
+		subfunc2 &= 0xFFFFFFFF;
+	}
+
+	return (subfunc1 == KVM_HC_XEN_HVM_OP_GUEST_REQUEST_VM_EVENT
+		&& subfunc2 == 0);
+}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f691e8477136..fcd02f6279b8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8099,11 +8099,14 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 {
 	unsigned long nr, a0, a1, a2, a3, ret;
 	int op_64_bit;
-
-	if (kvm_hv_hypercall_enabled(vcpu->kvm))
-		return kvm_hv_hypercall(vcpu);
+	bool kvmi_hc;
 
 	nr = kvm_rax_read(vcpu);
+	kvmi_hc = (u32)nr == KVM_HC_XEN_HVM_OP;
+
+	if (kvm_hv_hypercall_enabled(vcpu->kvm) && !kvmi_hc)
+		return kvm_hv_hypercall(vcpu);
+
 	a0 = kvm_rbx_read(vcpu);
 	a1 = kvm_rcx_read(vcpu);
 	a2 = kvm_rdx_read(vcpu);
@@ -8120,7 +8123,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		a3 &= 0xFFFFFFFF;
 	}
 
-	if (kvm_x86_ops.get_cpl(vcpu) != 0) {
+	if (kvm_x86_ops.get_cpl(vcpu) != 0 && !kvmi_hc) {
 		ret = -KVM_EPERM;
 		goto out;
 	}
@@ -8157,6 +8160,13 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		kvm_sched_yield(vcpu->kvm, a0);
 		ret = 0;
 		break;
+#ifdef CONFIG_KVM_INTROSPECTION
+	case KVM_HC_XEN_HVM_OP:
+		ret = 0;
+		if (!kvmi_hypercall_event(vcpu))
+			ret = -KVM_ENOSYS;
+		break;
+#endif /* CONFIG_KVM_INTROSPECTION */
 	default:
 		ret = -KVM_ENOSYS;
 		break;
diff --git a/include/linux/kvmi_host.h b/include/linux/kvmi_host.h
index 5e5d255e5a2c..1fb775b0de33 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -69,6 +69,7 @@ int kvmi_ioctl_event(struct kvm *kvm,
 int kvmi_ioctl_preunhook(struct kvm *kvm);
 
 void kvmi_handle_requests(struct kvm_vcpu *vcpu);
+bool kvmi_hypercall_event(struct kvm_vcpu *vcpu);
 
 #else
 
@@ -80,6 +81,7 @@ static inline void kvmi_destroy_vm(struct kvm *kvm) { }
 static inline void kvmi_vcpu_uninit(struct kvm_vcpu *vcpu) { }
 
 static inline void kvmi_handle_requests(struct kvm_vcpu *vcpu) { }
+static inline bool kvmi_hypercall_event(struct kvm_vcpu *vcpu) { return false; }
 
 #endif /* CONFIG_KVM_INTROSPECTION */
 
diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
index 3ce388249682..53cebbe22099 100644
--- a/include/uapi/linux/kvm_para.h
+++ b/include/uapi/linux/kvm_para.h
@@ -33,6 +33,7 @@
 #define KVM_HC_CLOCK_PAIRING		9
 #define KVM_HC_SEND_IPI		10
 #define KVM_HC_SCHED_YIELD		11
+#define KVM_HC_XEN_HVM_OP		34 /* Xen's __HYPERVISOR_hvm_op */
 
 /*
  * hypercalls use architecture specific
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 2c93a36bfa43..3dfc3486cc46 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -54,7 +54,8 @@ enum {
 };
 
 enum {
-	KVMI_VCPU_EVENT_PAUSE = KVMI_VCPU_EVENT_ID(0),
+	KVMI_VCPU_EVENT_PAUSE     = KVMI_VCPU_EVENT_ID(0),
+	KVMI_VCPU_EVENT_HYPERCALL = KVMI_VCPU_EVENT_ID(1),
 
 	KVMI_NEXT_VCPU_EVENT
 };
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 542b59466d12..8c772b2bff2a 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -53,6 +53,7 @@ struct vcpu_worker_data {
 
 enum {
 	GUEST_TEST_NOOP = 0,
+	GUEST_TEST_HYPERCALL,
 };
 
 #define GUEST_REQUEST_TEST()     GUEST_SYNC(0)
@@ -67,12 +68,23 @@ static int guest_test_id(void)
 	return READ_ONCE(test_id);
 }
 
+static void guest_hypercall_test(void)
+{
+	asm volatile("mov $34, %rax");
+	asm volatile("mov $24, %rdi");
+	asm volatile("mov $0, %rsi");
+	asm volatile(".byte 0x0f,0x01,0xc1");
+}
+
 static void guest_code(void)
 {
 	while (true) {
 		switch (guest_test_id()) {
 		case GUEST_TEST_NOOP:
 			break;
+		case GUEST_TEST_HYPERCALL:
+			guest_hypercall_test();
+			break;
 		}
 		GUEST_SIGNAL_TEST_DONE();
 	}
@@ -977,6 +989,35 @@ static void test_cmd_vcpu_get_cpuid(struct kvm_vm *vm)
 	      function, index, rpl.eax, rpl.ebx, rpl.ecx, rpl.edx);
 }
 
+static void test_event_hypercall(struct kvm_vm *vm)
+{
+	struct vcpu_worker_data data = {
+		.vm = vm,
+		.vcpu_id = VCPU_ID,
+		.test_id = GUEST_TEST_HYPERCALL,
+	};
+	struct kvmi_msg_hdr hdr;
+	struct vcpu_event ev;
+	struct vcpu_reply rpl = {};
+	__u16 event_id = KVMI_VCPU_EVENT_HYPERCALL;
+	pthread_t vcpu_thread;
+
+	enable_vcpu_event(vm, event_id);
+
+	vcpu_thread = start_vcpu_worker(&data);
+
+	receive_vcpu_event(&hdr, &ev, sizeof(ev), event_id);
+
+	pr_debug("Hypercall event, rip 0x%llx\n", ev.common.arch.regs.rip);
+
+	reply_to_event(&hdr, &ev, KVMI_EVENT_ACTION_CONTINUE,
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
@@ -997,6 +1038,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vcpu_get_registers(vm);
 	test_cmd_vcpu_set_registers(vm);
 	test_cmd_vcpu_get_cpuid(vm);
+	test_event_hypercall(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 3fff9b4c5107..7a4b9b5c3248 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -837,3 +837,41 @@ int kvmi_cmd_vcpu_pause(struct kvm_vcpu *vcpu, bool wait)
 
 	return 0;
 }
+
+static bool __kvmi_hypercall_event(struct kvm_vcpu *vcpu)
+{
+	u32 action;
+	bool ret;
+
+	action = kvmi_msg_send_vcpu_hypercall(vcpu);
+	switch (action) {
+	case KVMI_EVENT_ACTION_CONTINUE:
+		ret = true;
+		break;
+	default:
+		kvmi_handle_common_event_actions(vcpu, action);
+		ret = false;
+	}
+
+	return ret;
+}
+
+bool kvmi_hypercall_event(struct kvm_vcpu *vcpu)
+{
+	struct kvm_introspection *kvmi;
+	bool ret = false;
+
+	if (!kvmi_arch_is_agent_hypercall(vcpu))
+		return ret;
+
+	kvmi = kvmi_get(vcpu->kvm);
+	if (!kvmi)
+		return ret;
+
+	if (is_vcpu_event_enabled(vcpu, KVMI_VCPU_EVENT_HYPERCALL))
+		ret = __kvmi_hypercall_event(vcpu);
+
+	kvmi_put(vcpu->kvm);
+
+	return ret;
+}
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 018764ca1b71..72f0b75d2cf5 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -26,6 +26,11 @@ typedef int (*kvmi_vcpu_msg_job_fct)(const struct kvmi_vcpu_msg_job *job,
 				     const struct kvmi_msg_hdr *msg,
 				     const void *req);
 
+static inline bool is_vcpu_event_enabled(struct kvm_vcpu *vcpu, u16 event_id)
+{
+	return test_bit(event_id, VCPUI(vcpu)->ev_enable_mask);
+}
+
 /* kvmi_msg.c */
 bool kvmi_sock_get(struct kvm_introspection *kvmi, int fd);
 void kvmi_sock_shutdown(struct kvm_introspection *kvmi);
@@ -39,6 +44,7 @@ int kvmi_msg_vcpu_reply(const struct kvmi_vcpu_msg_job *job,
 			const struct kvmi_msg_hdr *msg, int err,
 			const void *rpl, size_t rpl_size);
 u32 kvmi_msg_send_vcpu_pause(struct kvm_vcpu *vcpu);
+u32 kvmi_msg_send_vcpu_hypercall(struct kvm_vcpu *vcpu);
 
 /* kvmi.c */
 void *kvmi_msg_alloc(void);
@@ -52,6 +58,7 @@ int kvmi_add_job(struct kvm_vcpu *vcpu,
 		 void (*fct)(struct kvm_vcpu *vcpu, void *ctx),
 		 void *ctx, void (*free_fct)(void *ctx));
 void kvmi_run_jobs(struct kvm_vcpu *vcpu);
+void kvmi_handle_common_event_actions(struct kvm_vcpu *vcpu, u32 action);
 int kvmi_cmd_vm_control_events(struct kvm_introspection *kvmi,
 			       u16 event_id, bool enable);
 int kvmi_cmd_vcpu_control_events(struct kvm_vcpu *vcpu,
@@ -71,5 +78,6 @@ kvmi_vcpu_msg_job_fct kvmi_arch_vcpu_msg_handler(u16 id);
 void kvmi_arch_setup_vcpu_event(struct kvm_vcpu *vcpu,
 				struct kvmi_vcpu_event *ev);
 void kvmi_arch_post_reply(struct kvm_vcpu *vcpu);
+bool kvmi_arch_is_agent_hypercall(struct kvm_vcpu *vcpu);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index ea8d824b698c..a515734dc937 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -744,3 +744,16 @@ u32 kvmi_msg_send_vcpu_pause(struct kvm_vcpu *vcpu)
 
 	return action;
 }
+
+u32 kvmi_msg_send_vcpu_hypercall(struct kvm_vcpu *vcpu)
+{
+	u32 action;
+	int err;
+
+	err = kvmi_send_vcpu_event(vcpu, KVMI_VCPU_EVENT_HYPERCALL, NULL, 0,
+				   NULL, 0, &action);
+	if (err)
+		return KVMI_EVENT_ACTION_CONTINUE;
+
+	return action;
+}
