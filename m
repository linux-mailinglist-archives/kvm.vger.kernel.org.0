Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51D8E2D1B40
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 21:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727535AbgLGUtU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 15:49:20 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:42566 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727450AbgLGUss (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 15:48:48 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 8D636305D47F;
        Mon,  7 Dec 2020 22:46:24 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 605333072784;
        Mon,  7 Dec 2020 22:46:24 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v11 70/81] KVM: introspection: add KVMI_VCPU_EVENT_DESCRIPTOR
Date:   Mon,  7 Dec 2020 22:46:11 +0200
Message-Id: <20201207204622.15258-71-alazar@bitdefender.com>
In-Reply-To: <20201207204622.15258-1-alazar@bitdefender.com>
References: <20201207204622.15258-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nicușor Cîțu <nicu.citu@icloud.com>

This event is sent when IDTR, GDTR, LDTR or TR are accessed.

These could be used to implement a tiny agent which runs in the context
of an introspected guest and uses virtualized exceptions (#VE) and
alternate EPT views (VMFUNC #0) to filter converted VMEXITS. The events
of interested will be suppressed (after some appropriate guest-side
handling) while the rest will be sent to the introspector via a VMCALL.

Signed-off-by: Nicușor Cîțu <nicu.citu@icloud.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 43 +++++++++++
 arch/x86/include/asm/kvmi_host.h              |  3 +
 arch/x86/include/uapi/asm/kvmi.h              | 13 ++++
 arch/x86/kvm/kvmi.c                           | 58 ++++++++++++++
 arch/x86/kvm/kvmi.h                           |  1 +
 arch/x86/kvm/kvmi_msg.c                       | 19 +++++
 arch/x86/kvm/svm/svm.c                        | 33 ++++++++
 arch/x86/kvm/vmx/vmx.c                        | 23 ++++++
 include/uapi/linux/kvmi.h                     |  1 +
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 75 +++++++++++++++++++
 10 files changed, 269 insertions(+)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index b3527d10a44e..2bfb2bf0e778 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -540,6 +540,7 @@ the following events::
 
 	KVMI_VCPU_EVENT_BREAKPOINT
 	KVMI_VCPU_EVENT_CR
+	KVMI_VCPU_EVENT_DESCRIPTOR
 	KVMI_VCPU_EVENT_HYPERCALL
 	KVMI_VCPU_EVENT_XSETBV
 
@@ -563,6 +564,8 @@ the *KVMI_VM_CONTROL_EVENTS* command.
 * -KVM_EINVAL - the event ID is unknown (use *KVMI_VM_CHECK_EVENT* first)
 * -KVM_EPERM - the access is disallowed (use *KVMI_VM_CHECK_EVENT* first)
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
+* -KVM_EOPNOTSUPP - the event can't be intercepted in the current setup
+                    (e.g. KVMI_VCPU_EVENT_DESCRIPTOR with AMD)
 * -KVM_EBUSY - the event can't be intercepted right now
                (e.g. KVMI_VCPU_EVENT_BREAKPOINT if the #BP event
                 is already intercepted by userspace)
@@ -1217,3 +1220,43 @@ to be changed and the introspection has been enabled for this event
 ``kvmi_vcpu_event`` (with the vCPU state), the extended control register
 number (``xcr``), the old value (``old_value``) and the new value
 (``new_value``) are sent to the introspection tool.
+
+8. KVMI_VCPU_EVENT_DESCRIPTOR
+-----------------------------
+
+:Architectures: x86
+:Versions: >= 1
+:Actions: CONTINUE, RETRY, CRASH
+:Parameters:
+
+::
+
+	struct kvmi_vcpu_event;
+	struct kvmi_vcpu_event_descriptor {
+		__u8 descriptor;
+		__u8 write;
+		__u8 padding[6];
+	};
+
+:Returns:
+
+::
+
+	struct kvmi_vcpu_hdr;
+	struct kvmi_vcpu_event_reply;
+
+This event is sent when a descriptor table register is accessed and the
+introspection has been enabled for this event (see **KVMI_VCPU_CONTROL_EVENTS**).
+
+``kvmi_vcpu_event`` (with the vCPU state), the descriptor-table register
+(``descriptor``) and the access type (``write``) are sent to the
+introspection tool.
+
+``descriptor`` can be one of::
+
+	KVMI_DESC_IDTR
+	KVMI_DESC_GDTR
+	KVMI_DESC_LDTR
+	KVMI_DESC_TR
+
+``write`` is 1 if the descriptor was written, 0 otherwise.
diff --git a/arch/x86/include/asm/kvmi_host.h b/arch/x86/include/asm/kvmi_host.h
index d66349208a6b..a24ba87036f7 100644
--- a/arch/x86/include/asm/kvmi_host.h
+++ b/arch/x86/include/asm/kvmi_host.h
@@ -48,6 +48,7 @@ bool kvmi_monitor_cr3w_intercept(struct kvm_vcpu *vcpu, bool enable);
 void kvmi_enter_guest(struct kvm_vcpu *vcpu);
 void kvmi_xsetbv_event(struct kvm_vcpu *vcpu, u8 xcr,
 		       u64 old_value, u64 new_value);
+bool kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor, bool write);
 
 #else /* CONFIG_KVM_INTROSPECTION */
 
@@ -63,6 +64,8 @@ static inline bool kvmi_monitor_cr3w_intercept(struct kvm_vcpu *vcpu,
 static inline void kvmi_enter_guest(struct kvm_vcpu *vcpu) { }
 static inline void kvmi_xsetbv_event(struct kvm_vcpu *vcpu, u8 xcr,
 					u64 old_value, u64 new_value) { }
+static inline bool kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor,
+					 bool write) { return true; }
 
 #endif /* CONFIG_KVM_INTROSPECTION */
 
diff --git a/arch/x86/include/uapi/asm/kvmi.h b/arch/x86/include/uapi/asm/kvmi.h
index 7b93450d0d62..9c608ef5daa3 100644
--- a/arch/x86/include/uapi/asm/kvmi.h
+++ b/arch/x86/include/uapi/asm/kvmi.h
@@ -128,4 +128,17 @@ struct kvmi_vcpu_get_mtrr_type_reply {
 	__u8 padding[7];
 };
 
+enum {
+	KVMI_DESC_IDTR = 1,
+	KVMI_DESC_GDTR = 2,
+	KVMI_DESC_LDTR = 3,
+	KVMI_DESC_TR   = 4,
+};
+
+struct kvmi_vcpu_event_descriptor {
+	__u8 descriptor;
+	__u8 write;
+	__u8 padding[6];
+};
+
 #endif /* _UAPI_ASM_X86_KVMI_H */
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 5219b6faf4b5..3d5b041de634 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -15,6 +15,7 @@ void kvmi_arch_init_vcpu_events_mask(unsigned long *supported)
 	set_bit(KVMI_VCPU_EVENT_BREAKPOINT, supported);
 	set_bit(KVMI_VCPU_EVENT_CR, supported);
 	set_bit(KVMI_VCPU_EVENT_HYPERCALL, supported);
+	set_bit(KVMI_VCPU_EVENT_DESCRIPTOR, supported);
 	set_bit(KVMI_VCPU_EVENT_TRAP, supported);
 	set_bit(KVMI_VCPU_EVENT_XSETBV, supported);
 }
@@ -285,6 +286,21 @@ static void kvmi_arch_disable_cr3w_intercept(struct kvm_vcpu *vcpu)
 	vcpu->arch.kvmi->cr3w.kvm_intercepted = false;
 }
 
+static int kvmi_control_desc_intercept(struct kvm_vcpu *vcpu, bool enable)
+{
+	if (!kvm_x86_ops.desc_ctrl_supported())
+		return -KVM_EOPNOTSUPP;
+
+	kvm_x86_ops.control_desc_intercept(vcpu, enable);
+
+	return 0;
+}
+
+static void kvmi_arch_disable_desc_intercept(struct kvm_vcpu *vcpu)
+{
+	kvmi_control_desc_intercept(vcpu, false);
+}
+
 int kvmi_arch_cmd_control_intercept(struct kvm_vcpu *vcpu,
 				    unsigned int event_id, bool enable)
 {
@@ -294,6 +310,9 @@ int kvmi_arch_cmd_control_intercept(struct kvm_vcpu *vcpu,
 	case KVMI_VCPU_EVENT_BREAKPOINT:
 		err = kvmi_control_bp_intercept(vcpu, enable);
 		break;
+	case KVMI_VCPU_EVENT_DESCRIPTOR:
+		err = kvmi_control_desc_intercept(vcpu, enable);
+		break;
 	default:
 		break;
 	}
@@ -325,6 +344,7 @@ static void kvmi_arch_restore_interception(struct kvm_vcpu *vcpu)
 {
 	kvmi_arch_disable_bp_intercept(vcpu);
 	kvmi_arch_disable_cr3w_intercept(vcpu);
+	kvmi_arch_disable_desc_intercept(vcpu);
 }
 
 bool kvmi_arch_clean_up_interception(struct kvm_vcpu *vcpu)
@@ -597,3 +617,41 @@ void kvmi_xsetbv_event(struct kvm_vcpu *vcpu, u8 xcr,
 
 	kvmi_put(vcpu->kvm);
 }
+
+static bool __kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor,
+				    bool write)
+{
+	bool ret = false;
+	u32 action;
+
+	action = kvmi_msg_send_vcpu_descriptor(vcpu, descriptor, write);
+	switch (action) {
+	case KVMI_EVENT_ACTION_CONTINUE:
+		ret = true;
+		break;
+	case KVMI_EVENT_ACTION_RETRY:
+		break;
+	default:
+		kvmi_handle_common_event_actions(vcpu, action);
+	}
+
+	return ret;
+}
+
+bool kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor, bool write)
+{
+	struct kvm_introspection *kvmi;
+	bool ret = true;
+
+	kvmi = kvmi_get(vcpu->kvm);
+	if (!kvmi)
+		return true;
+
+	if (is_vcpu_event_enabled(vcpu, KVMI_VCPU_EVENT_DESCRIPTOR))
+		ret = __kvmi_descriptor_event(vcpu, descriptor, write);
+
+	kvmi_put(vcpu->kvm);
+
+	return ret;
+}
+EXPORT_SYMBOL(kvmi_descriptor_event);
diff --git a/arch/x86/kvm/kvmi.h b/arch/x86/kvm/kvmi.h
index 43bc956d740c..92422e2e57cf 100644
--- a/arch/x86/kvm/kvmi.h
+++ b/arch/x86/kvm/kvmi.h
@@ -16,5 +16,6 @@ u32 kvmi_msg_send_vcpu_cr(struct kvm_vcpu *vcpu, u32 cr, u64 old_value,
 u32 kvmi_msg_send_vcpu_trap(struct kvm_vcpu *vcpu);
 u32 kvmi_msg_send_vcpu_xsetbv(struct kvm_vcpu *vcpu, u8 xcr,
 			      u64 old_value, u64 new_value);
+u32 kvmi_msg_send_vcpu_descriptor(struct kvm_vcpu *vcpu, u8 desc, bool write);
 
 #endif
diff --git a/arch/x86/kvm/kvmi_msg.c b/arch/x86/kvm/kvmi_msg.c
index 2617ada3a692..f0b4016820ce 100644
--- a/arch/x86/kvm/kvmi_msg.c
+++ b/arch/x86/kvm/kvmi_msg.c
@@ -330,3 +330,22 @@ u32 kvmi_msg_send_vcpu_xsetbv(struct kvm_vcpu *vcpu, u8 xcr,
 
 	return action;
 }
+
+u32 kvmi_msg_send_vcpu_descriptor(struct kvm_vcpu *vcpu, u8 desc, bool write)
+{
+	struct kvmi_vcpu_event_descriptor e;
+	u32 action;
+	int err;
+
+	memset(&e, 0, sizeof(e));
+	e.descriptor = desc;
+	e.write = write ? 1 : 0;
+
+	err = kvmi_send_vcpu_event(vcpu, KVMI_VCPU_EVENT_DESCRIPTOR,
+				   &e, sizeof(e), NULL, 0, &action);
+	if (err)
+		action = KVMI_EVENT_ACTION_CONTINUE;
+
+	return action;
+
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f3ec79e6c39a..5b689d3fe3e4 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2449,6 +2449,39 @@ static int descriptor_access_interception(struct vcpu_svm *svm)
 {
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 
+#ifdef CONFIG_KVM_INTROSPECTION
+	struct vmcb_control_area *c = &svm->vmcb->control;
+	bool cont;
+
+	switch (c->exit_code) {
+	case SVM_EXIT_IDTR_READ:
+	case SVM_EXIT_IDTR_WRITE:
+		cont = kvmi_descriptor_event(vcpu, KVMI_DESC_IDTR,
+				      c->exit_code == SVM_EXIT_IDTR_WRITE);
+		break;
+	case SVM_EXIT_GDTR_READ:
+	case SVM_EXIT_GDTR_WRITE:
+		cont = kvmi_descriptor_event(vcpu, KVMI_DESC_GDTR,
+				      c->exit_code == SVM_EXIT_GDTR_WRITE);
+		break;
+	case SVM_EXIT_LDTR_READ:
+	case SVM_EXIT_LDTR_WRITE:
+		cont = kvmi_descriptor_event(vcpu, KVMI_DESC_LDTR,
+				      c->exit_code == SVM_EXIT_LDTR_WRITE);
+		break;
+	case SVM_EXIT_TR_READ:
+	case SVM_EXIT_TR_WRITE:
+		cont = kvmi_descriptor_event(vcpu, KVMI_DESC_TR,
+				      c->exit_code == SVM_EXIT_TR_WRITE);
+		break;
+	default:
+		cont = true;
+		break;
+	}
+	if (!cont)
+		return 1;
+#endif /* CONFIG_KVM_INTROSPECTION */
+
 	return kvm_emulate_instruction(vcpu, 0);
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 837447541710..3afdf532b030 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5043,7 +5043,30 @@ static int handle_set_cr4(struct kvm_vcpu *vcpu, unsigned long val)
 
 static int handle_desc(struct kvm_vcpu *vcpu)
 {
+#ifdef CONFIG_KVM_INTROSPECTION
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	u32 exit_reason = vmx->exit_reason;
+	u32 vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
+	u8 store = (vmx_instruction_info >> 29) & 0x1;
+	u8 descriptor = 0;
+
+	if (exit_reason == EXIT_REASON_GDTR_IDTR) {
+		if ((vmx_instruction_info >> 28) & 0x1)
+			descriptor = KVMI_DESC_IDTR;
+		else
+			descriptor = KVMI_DESC_GDTR;
+	} else {
+		if ((vmx_instruction_info >> 28) & 0x1)
+			descriptor = KVMI_DESC_TR;
+		else
+			descriptor = KVMI_DESC_LDTR;
+	}
+
+	if (!kvmi_descriptor_event(vcpu, descriptor, store))
+		return 1;
+#else
 	WARN_ON(!(vcpu->arch.cr4 & X86_CR4_UMIP));
+#endif /* CONFIG_KVM_INTROSPECTION */
 	return kvm_emulate_instruction(vcpu, 0);
 }
 
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 8d7c6027f12c..09f78c0efc4f 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -68,6 +68,7 @@ enum {
 	KVMI_VCPU_EVENT_CR         = KVMI_VCPU_EVENT_ID(3),
 	KVMI_VCPU_EVENT_TRAP       = KVMI_VCPU_EVENT_ID(4),
 	KVMI_VCPU_EVENT_XSETBV     = KVMI_VCPU_EVENT_ID(5),
+	KVMI_VCPU_EVENT_DESCRIPTOR = KVMI_VCPU_EVENT_ID(6),
 
 	KVMI_NEXT_VCPU_EVENT
 };
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index b0906c7fb954..d26df3a9ffff 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -58,6 +58,7 @@ enum {
 	GUEST_TEST_NOOP = 0,
 	GUEST_TEST_BP,
 	GUEST_TEST_CR,
+	GUEST_TEST_DESCRIPTOR,
 	GUEST_TEST_HYPERCALL,
 	GUEST_TEST_XSETBV,
 };
@@ -87,6 +88,14 @@ static void guest_cr_test(void)
 	set_cr4(get_cr4() | X86_CR4_OSXSAVE);
 }
 
+static void guest_descriptor_test(void)
+{
+	void *ptr;
+
+	asm volatile("sgdt %0" :: "m"(ptr));
+	asm volatile("lgdt %0" :: "m"(ptr));
+}
+
 static void guest_hypercall_test(void)
 {
 	asm volatile("mov $34, %rax");
@@ -146,6 +155,9 @@ static void guest_code(void)
 		case GUEST_TEST_CR:
 			guest_cr_test();
 			break;
+		case GUEST_TEST_DESCRIPTOR:
+			guest_descriptor_test();
+			break;
 		case GUEST_TEST_HYPERCALL:
 			guest_hypercall_test();
 			break;
@@ -1505,6 +1517,68 @@ static void test_cmd_vcpu_get_mtrr_type(struct kvm_vm *vm)
 	pr_debug("mtrr_type: gpa 0x%lx type 0x%x\n", test_gpa, rpl.type);
 }
 
+static void test_desc_read_access(__u16 event_id)
+{
+	struct kvmi_msg_hdr hdr;
+	struct {
+		struct vcpu_event vcpu_ev;
+		struct kvmi_vcpu_event_descriptor desc;
+	} ev;
+	struct vcpu_reply rpl = {};
+
+	receive_vcpu_event(&hdr, &ev.vcpu_ev, sizeof(ev), event_id);
+
+	pr_info("Descriptor event (read), descriptor %u, write %u\n",
+		ev.desc.descriptor, ev.desc.write);
+
+	TEST_ASSERT(ev.desc.write == 0,
+		"Received a write descriptor access\n");
+
+	reply_to_event(&hdr, &ev.vcpu_ev, KVMI_EVENT_ACTION_CONTINUE,
+			&rpl, sizeof(rpl));
+}
+
+static void test_desc_write_access(__u16 event_id)
+{
+	struct kvmi_msg_hdr hdr;
+	struct {
+		struct vcpu_event vcpu_ev;
+		struct kvmi_vcpu_event_descriptor desc;
+	} ev;
+	struct vcpu_reply rpl = {};
+
+	receive_vcpu_event(&hdr, &ev.vcpu_ev, sizeof(ev), event_id);
+
+	pr_debug("Descriptor event (write), descriptor %u, write %u\n",
+		ev.desc.descriptor, ev.desc.write);
+
+	TEST_ASSERT(ev.desc.write == 1,
+		"Received a read descriptor access\n");
+
+	reply_to_event(&hdr, &ev.vcpu_ev, KVMI_EVENT_ACTION_CONTINUE,
+			&rpl, sizeof(rpl));
+}
+
+static void test_event_descriptor(struct kvm_vm *vm)
+{
+	struct vcpu_worker_data data = {
+		.vm = vm,
+		.vcpu_id = VCPU_ID,
+		.test_id = GUEST_TEST_DESCRIPTOR,
+	};
+	__u16 event_id = KVMI_VCPU_EVENT_DESCRIPTOR;
+	pthread_t vcpu_thread;
+
+	enable_vcpu_event(vm, event_id);
+	vcpu_thread = start_vcpu_worker(&data);
+
+	test_desc_read_access(event_id);
+	test_desc_write_access(event_id);
+
+	wait_vcpu_worker(vcpu_thread);
+	disable_vcpu_event(vm, event_id);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	srandom(time(0));
@@ -1535,6 +1609,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vcpu_get_xcr(vm);
 	test_cmd_vcpu_xsave(vm);
 	test_cmd_vcpu_get_mtrr_type(vm);
+	test_event_descriptor(vm);
 
 	unhook_introspection(vm);
 }
