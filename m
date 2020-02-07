Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39770155DA7
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:17:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727727AbgBGSRn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:17:43 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40634 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727675AbgBGSQw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:52 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 39755305D357;
        Fri,  7 Feb 2020 20:16:41 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 149E63052079;
        Fri,  7 Feb 2020 20:16:41 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v7 57/78] KVM: introspection: add KVMI_EVENT_HYPERCALL
Date:   Fri,  7 Feb 2020 20:16:15 +0200
Message-Id: <20200207181636.1065-58-alazar@bitdefender.com>
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

This event is sent on a specific user hypercall.

It is used by the code residing inside the introspected guest to call the
introspection tool and to report certain details about its operation.
For example, a classic antimalware remediation tool can report
what it has found during a scan.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/hypercalls.txt         | 32 ++++++++++++++
 Documentation/virt/kvm/kvmi.rst               | 36 +++++++++++++++-
 arch/x86/include/uapi/asm/kvmi.h              |  2 +
 arch/x86/kvm/kvmi.c                           | 33 ++++++++++++++
 arch/x86/kvm/x86.c                            | 16 +++++--
 include/linux/kvmi_host.h                     |  2 +
 include/uapi/linux/kvm_para.h                 |  1 +
 include/uapi/linux/kvmi.h                     |  1 +
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 43 +++++++++++++++++++
 virt/kvm/introspection/kvmi.c                 | 22 ++++++++++
 virt/kvm/introspection/kvmi_int.h             | 13 +++++-
 virt/kvm/introspection/kvmi_msg.c             | 12 ++++++
 12 files changed, 208 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/hypercalls.txt b/Documentation/virt/kvm/hypercalls.txt
index aff272bede08..c4f6cce1e4d3 100644
--- a/Documentation/virt/kvm/hypercalls.txt
+++ b/Documentation/virt/kvm/hypercalls.txt
@@ -152,3 +152,35 @@ a0: destination APIC ID
 
 Usage example: When sending a call-function IPI-many to vCPUs, yield if
 any of the IPI target vCPUs was preempted.
+
+9. KVM_HC_XEN_HVM_OP
+--------------------
+
+Architecture: x86
+Status: active
+Purpose: To enable communication between a guest agent and a VMI application
+Usage:
+
+An event will be sent to the VMI application (see kvmi.rst) if the following
+registers, which differ between 32bit and 64bit, have the following values:
+
+       32bit       64bit     value
+       ---------------------------
+       ebx (a0)    rdi       KVM_HC_XEN_HVM_OP_GUEST_REQUEST_VM_EVENT
+       ecx (a1)    rsi       0
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
index f9f961509c61..90256141a15d 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -527,7 +527,10 @@ Use *KVMI_VM_CHECK_EVENT* first.
 
 	struct kvmi_error_code
 
-Enables/disables vCPU introspection events.
+Enables/disables vCPU introspection events. This command can be used with
+the following events::
+
+	KVMI_EVENT_HYPERCALL
 
 When an event is enabled, the introspection tool is notified and it
 must reply with: continue, retry, crash, etc. (see **Events** below).
@@ -764,3 +767,34 @@ This event is sent in response to a *KVMI_VCPU_PAUSE* command.
 
 This event has a low priority. It will be sent after any other vCPU
 introspection event and when no vCPU introspection command is queued.
+
+3. KVMI_EVENT_HYPERCALL
+-----------------------
+
+:Architectures: x86
+:Versions: >= 1
+:Actions: CONTINUE, CRASH
+:Parameters:
+
+::
+
+	struct kvmi_event;
+
+:Returns:
+
+::
+
+	struct kvmi_vcpu_hdr;
+	struct kvmi_event_reply;
+
+This event is sent on a specific user hypercall when the introspection has
+been enabled for this event (see *KVMI_VCPU_CONTROL_EVENTS*).
+
+The hypercall number must be ``KVM_HC_XEN_HVM_OP`` with the
+``KVM_HC_XEN_HVM_OP_GUEST_REQUEST_VM_EVENT`` sub-function
+(see hypercalls.txt).
+
+It is used by the code residing inside the introspected guest to call the
+introspection tool and to report certain details about its operation. For
+example, a classic antimalware remediation tool can report what it has
+found during a scan.
diff --git a/arch/x86/include/uapi/asm/kvmi.h b/arch/x86/include/uapi/asm/kvmi.h
index 57c48ace417f..9882e68cab75 100644
--- a/arch/x86/include/uapi/asm/kvmi.h
+++ b/arch/x86/include/uapi/asm/kvmi.h
@@ -8,6 +8,8 @@
 
 #include <asm/kvm.h>
 
+#define KVM_HC_XEN_HVM_OP_GUEST_REQUEST_VM_EVENT 24
+
 struct kvmi_event_arch {
 	__u8 mode;		/* 2, 4 or 8 */
 	__u8 padding[7];
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index bba85f333639..f597b3c1cba0 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -159,3 +159,36 @@ int kvmi_arch_cmd_vcpu_get_cpuid(struct kvm_vcpu *vcpu,
 
 	return 0;
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
+
+void kvmi_arch_hypercall_event(struct kvm_vcpu *vcpu)
+{
+	u32 action;
+
+	action = kvmi_msg_send_hypercall(vcpu);
+	switch (action) {
+	case KVMI_EVENT_ACTION_CONTINUE:
+		break;
+	default:
+		kvmi_handle_common_event_actions(vcpu->kvm, action,
+						"HYPERCALL");
+	}
+}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 46a135595893..b4a7805ce9e4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7433,11 +7433,14 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 {
 	unsigned long nr, a0, a1, a2, a3, ret;
 	int op_64_bit;
+	bool kvmi_hc;
 
-	if (kvm_hv_hypercall_enabled(vcpu->kvm))
+	nr = kvm_rax_read(vcpu);
+	kvmi_hc = (u32)nr == KVM_HC_XEN_HVM_OP;
+
+	if (kvm_hv_hypercall_enabled(vcpu->kvm) && !kvmi_hc)
 		return kvm_hv_hypercall(vcpu);
 
-	nr = kvm_rax_read(vcpu);
 	a0 = kvm_rbx_read(vcpu);
 	a1 = kvm_rcx_read(vcpu);
 	a2 = kvm_rdx_read(vcpu);
@@ -7454,7 +7457,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		a3 &= 0xFFFFFFFF;
 	}
 
-	if (kvm_x86_ops->get_cpl(vcpu) != 0) {
+	if (kvm_x86_ops->get_cpl(vcpu) != 0 && !kvmi_hc) {
 		ret = -KVM_EPERM;
 		goto out;
 	}
@@ -7480,6 +7483,13 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
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
index 68c76db83973..0a85bfbd0c0c 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -75,6 +75,7 @@ int kvmi_ioctl_event(struct kvm *kvm, void __user *argp);
 int kvmi_ioctl_preunhook(struct kvm *kvm);
 
 void kvmi_handle_requests(struct kvm_vcpu *vcpu);
+bool kvmi_hypercall_event(struct kvm_vcpu *vcpu);
 
 #else
 
@@ -85,6 +86,7 @@ static inline void kvmi_destroy_vm(struct kvm *kvm) { }
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
index 05535a7d9313..20e2f154ab88 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -39,6 +39,7 @@ enum {
 enum {
 	KVMI_EVENT_UNHOOK     = 0,
 	KVMI_EVENT_PAUSE_VCPU = 1,
+	KVMI_EVENT_HYPERCALL  = 2,
 
 	KVMI_NUM_EVENTS
 };
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index fa23ca0ed0d7..ef4e33e92fff 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -48,6 +48,7 @@ struct vcpu_worker_data {
 
 enum {
 	GUEST_TEST_NOOP = 0,
+	GUEST_TEST_HYPERCALL,
 };
 
 #define GUEST_REQUEST_TEST()     GUEST_SYNC(0)
@@ -61,12 +62,23 @@ static int guest_test_id(void)
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
@@ -942,6 +954,36 @@ static void test_cmd_vcpu_get_cpuid(struct kvm_vm *vm)
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
+	struct kvmi_event ev;
+	struct vcpu_reply rpl = {};
+	__u16 event_id = KVMI_EVENT_HYPERCALL;
+	pthread_t vcpu_thread;
+
+	enable_vcpu_event(vm, event_id);
+
+	vcpu_thread = start_vcpu_worker(&data);
+
+	receive_event(&hdr, &ev, sizeof(ev), event_id);
+
+	DEBUG("Hypercall event, rip 0x%llx\n",
+		ev.arch.regs.rip);
+
+	reply_to_event(&hdr, &ev, KVMI_EVENT_ACTION_CONTINUE,
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
@@ -961,6 +1003,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vcpu_get_registers(vm);
 	test_cmd_vcpu_set_registers(vm);
 	test_cmd_vcpu_get_cpuid(vm);
+	test_event_hypercall(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 8ffbf46bc17d..a1c059489dea 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -828,3 +828,25 @@ void kvmi_post_reply(struct kvm_vcpu *vcpu)
 		vcpui->have_delayed_regs = false;
 	}
 }
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
+	if (is_event_enabled(vcpu, KVMI_EVENT_HYPERCALL)) {
+		kvmi_arch_hypercall_event(vcpu);
+		ret = true;
+	}
+
+	kvmi_put(vcpu->kvm);
+
+	return ret;
+}
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 1b3d8958e6c8..3dbcf944a606 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -22,7 +22,8 @@
 			  BIT(KVMI_EVENT_UNHOOK) \
 		)
 #define KVMI_KNOWN_VCPU_EVENTS ( \
-			  BIT(KVMI_EVENT_PAUSE_VCPU) \
+			    BIT(KVMI_EVENT_HYPERCALL) \
+			  | BIT(KVMI_EVENT_PAUSE_VCPU) \
 		)
 
 #define KVMI_KNOWN_EVENTS (KVMI_KNOWN_VM_EVENTS | KVMI_KNOWN_VCPU_EVENTS)
@@ -52,6 +53,11 @@ static inline bool is_vm_event_enabled(struct kvm_introspection *kvmi,
 	return test_bit(event, kvmi->vm_event_enable_mask);
 }
 
+static inline bool is_event_enabled(struct kvm_vcpu *vcpu, int event)
+{
+	return test_bit(event, VCPUI(vcpu)->ev_mask);
+}
+
 /* kvmi_msg.c */
 bool kvmi_sock_get(struct kvm_introspection *kvmi, int fd);
 void kvmi_sock_shutdown(struct kvm_introspection *kvmi);
@@ -59,6 +65,7 @@ void kvmi_sock_put(struct kvm_introspection *kvmi);
 bool kvmi_msg_process(struct kvm_introspection *kvmi);
 int kvmi_msg_send_unhook(struct kvm_introspection *kvmi);
 u32 kvmi_msg_send_vcpu_pause(struct kvm_vcpu *vcpu);
+u32 kvmi_msg_send_hypercall(struct kvm_vcpu *vcpu);
 
 /* kvmi.c */
 void *kvmi_msg_alloc(void);
@@ -69,6 +76,8 @@ int kvmi_add_job(struct kvm_vcpu *vcpu,
 		 void *ctx, void (*free_fct)(void *ctx));
 void kvmi_run_jobs(struct kvm_vcpu *vcpu);
 void kvmi_post_reply(struct kvm_vcpu *vcpu);
+void kvmi_handle_common_event_actions(struct kvm *kvm,
+				      u32 action, const char *str);
 int kvmi_cmd_vm_control_events(struct kvm_introspection *kvmi,
 				unsigned int event_id, bool enable);
 int kvmi_cmd_vcpu_control_events(struct kvm_vcpu *vcpu,
@@ -96,5 +105,7 @@ int kvmi_arch_cmd_vcpu_get_registers(struct kvm_vcpu *vcpu,
 int kvmi_arch_cmd_vcpu_get_cpuid(struct kvm_vcpu *vcpu,
 				 const struct kvmi_vcpu_get_cpuid *req,
 				 struct kvmi_vcpu_get_cpuid_reply *rpl);
+bool kvmi_arch_is_agent_hypercall(struct kvm_vcpu *vcpu);
+void kvmi_arch_hypercall_event(struct kvm_vcpu *vcpu);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 11873cb3c23b..bcdf104eaa43 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -868,3 +868,15 @@ u32 kvmi_msg_send_vcpu_pause(struct kvm_vcpu *vcpu)
 
 	return action;
 }
+
+u32 kvmi_msg_send_hypercall(struct kvm_vcpu *vcpu)
+{
+	int err, action;
+
+	err = kvmi_send_event(vcpu, KVMI_EVENT_HYPERCALL, NULL, 0,
+			      NULL, 0, &action);
+	if (err)
+		return KVMI_EVENT_ACTION_CONTINUE;
+
+	return action;
+}
