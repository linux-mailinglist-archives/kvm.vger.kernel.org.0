Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADE4155D99
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgBGSRQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:17:16 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40630 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727722AbgBGSQ4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:56 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id B43E2305D361;
        Fri,  7 Feb 2020 20:16:41 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id A2D1E3052076;
        Fri,  7 Feb 2020 20:16:41 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v7 67/78] KVM: introspection: add KVMI_EVENT_DESCRIPTOR
Date:   Fri,  7 Feb 2020 20:16:25 +0200
Message-Id: <20200207181636.1065-68-alazar@bitdefender.com>
In-Reply-To: <20200207181636.1065-1-alazar@bitdefender.com>
References: <20200207181636.1065-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nicușor Cîțu <ncitu@bitdefender.com>

This event is sent when IDTR, GDTR, LDTR or TR are accessed.

These could be used to implement a tiny agent which runs in the context
of an introspected guest and uses virtualized exceptions (#VE) and
alternate EPT views (VMFUNC #0) to filter converted VMEXITS. The events
of interested will be suppressed (after some appropriate guest-side
handling) while the rest will be sent to the introspector via a VMCALL.

Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 39 ++++++++++++
 arch/x86/include/asm/kvmi_host.h              |  3 +
 arch/x86/include/uapi/asm/kvmi.h              | 11 ++++
 arch/x86/kvm/kvmi.c                           | 57 ++++++++++++++++++
 arch/x86/kvm/svm.c                            | 45 ++++++++++++++
 arch/x86/kvm/vmx/vmx.c                        | 37 +++++++++++-
 include/uapi/linux/kvmi.h                     |  1 +
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 60 +++++++++++++++++++
 virt/kvm/introspection/kvmi_int.h             |  2 +
 virt/kvm/introspection/kvmi_msg.c             | 17 ++++++
 10 files changed, 270 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index ae8e242c4721..0a0e5305a0af 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -532,6 +532,7 @@ the following events::
 
 	KVMI_EVENT_BREAKPOINT
 	KVMI_EVENT_CR
+	KVMI_EVENT_DESCRIPTOR
 	KVMI_EVENT_HYPERCALL
 	KVMI_EVENT_TRAP
 	KVMI_EVENT_XSETBV
@@ -1088,3 +1089,41 @@ to be changed and the introspection has been enabled for this event
 (see *KVMI_VCPU_CONTROL_EVENTS*).
 
 ``kvmi_event`` is sent to the introspection tool.
+
+8. KVMI_EVENT_DESCRIPTOR
+------------------------
+
+:Architecture: x86
+:Versions: >= 1
+:Actions: CONTINUE, RETRY, CRASH
+:Parameters:
+
+::
+
+	struct kvmi_event;
+	struct kvmi_event_descriptor {
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
+	struct kvmi_event_reply;
+
+This event is sent when a descriptor table register is accessed and the
+introspection has been enabled for this event (see **KVMI_VCPU_CONTROL_EVENTS**).
+
+``kvmi_event`` and ``kvmi_event_descriptor`` are sent to the introspection tool.
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
index b3fa950362db..8f9e6bd2953a 100644
--- a/arch/x86/include/asm/kvmi_host.h
+++ b/arch/x86/include/asm/kvmi_host.h
@@ -31,6 +31,7 @@ bool kvmi_cr_event(struct kvm_vcpu *vcpu, unsigned int cr,
 bool kvmi_cr3_intercepted(struct kvm_vcpu *vcpu);
 bool kvmi_monitor_cr3w_intercept(struct kvm_vcpu *vcpu, bool enable);
 void kvmi_xsetbv_event(struct kvm_vcpu *vcpu);
+bool kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor, u8 write);
 
 #else /* CONFIG_KVM_INTROSPECTION */
 
@@ -43,6 +44,8 @@ static inline bool kvmi_cr3_intercepted(struct kvm_vcpu *vcpu) { return false; }
 static inline bool kvmi_monitor_cr3w_intercept(struct kvm_vcpu *vcpu,
 						bool enable) { return false; }
 static inline void kvmi_xsetbv_event(struct kvm_vcpu *vcpu) { }
+static inline bool kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor,
+					 u8 write) { return true; }
 
 #endif /* CONFIG_KVM_INTROSPECTION */
 
diff --git a/arch/x86/include/uapi/asm/kvmi.h b/arch/x86/include/uapi/asm/kvmi.h
index 1dc3fc02d3ec..6f411b9ba449 100644
--- a/arch/x86/include/uapi/asm/kvmi.h
+++ b/arch/x86/include/uapi/asm/kvmi.h
@@ -110,4 +110,15 @@ struct kvmi_vcpu_get_mtrr_type_reply {
 	__u8 padding[7];
 };
 
+#define KVMI_DESC_IDTR  1
+#define KVMI_DESC_GDTR  2
+#define KVMI_DESC_LDTR  3
+#define KVMI_DESC_TR    4
+
+struct kvmi_event_descriptor {
+	__u8 descriptor;
+	__u8 write;
+	__u8 padding[6];
+};
+
 #endif /* _UAPI_ASM_X86_KVMI_H */
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index d3cddd34326b..ed9b45060e2a 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -311,6 +311,21 @@ static void kvmi_arch_disable_cr3w_intercept(struct kvm_vcpu *vcpu)
 	vcpu->arch.kvmi->cr3w.kvm_intercepted = false;
 }
 
+static int kvmi_control_desc_intercept(struct kvm_vcpu *vcpu, bool enable)
+{
+	if (!kvm_x86_ops->umip_emulated())
+		return -KVM_EOPNOTSUPP;
+
+	kvm_x86_ops->control_desc_intercept(vcpu, enable);
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
@@ -320,6 +335,9 @@ int kvmi_arch_cmd_control_intercept(struct kvm_vcpu *vcpu,
 	case KVMI_EVENT_BREAKPOINT:
 		err = kvmi_control_bp_intercept(vcpu, enable);
 		break;
+	case KVMI_EVENT_DESCRIPTOR:
+		err = kvmi_control_desc_intercept(vcpu, enable);
+		break;
 	default:
 		break;
 	}
@@ -356,6 +374,7 @@ bool kvmi_arch_restore_interception(struct kvm_vcpu *vcpu)
 
 	kvmi_arch_disable_bp_intercept(vcpu);
 	kvmi_arch_disable_cr3w_intercept(vcpu);
+	kvmi_arch_disable_desc_intercept(vcpu);
 
 	return true;
 }
@@ -644,3 +663,41 @@ int kvmi_arch_cmd_vcpu_get_mtrr_type(struct kvm_vcpu *vcpu, u64 gpa, u8 *type)
 
 	return 0;
 }
+
+static bool __kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor,
+				    u8 write)
+{
+	bool ret = false;
+	u32 action;
+
+	action = kvmi_msg_send_descriptor(vcpu, descriptor, write);
+	switch (action) {
+	case KVMI_EVENT_ACTION_CONTINUE:
+		ret = true;
+		break;
+	case KVMI_EVENT_ACTION_RETRY:
+		break;
+	default:
+		kvmi_handle_common_event_actions(vcpu->kvm, action, "DESC");
+	}
+
+	return ret;
+}
+
+bool kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor, u8 write)
+{
+	struct kvm_introspection *kvmi;
+	bool ret = true;
+
+	kvmi = kvmi_get(vcpu->kvm);
+	if (!kvmi)
+		return true;
+
+	if (is_event_enabled(vcpu, KVMI_EVENT_DESCRIPTOR))
+		ret = __kvmi_descriptor_event(vcpu, descriptor, write);
+
+	kvmi_put(vcpu->kvm);
+
+	return ret;
+}
+EXPORT_SYMBOL(kvmi_descriptor_event);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 909308711bb7..988eb6937515 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -4808,6 +4808,41 @@ static int avic_unaccelerated_access_interception(struct vcpu_svm *svm)
 	return ret;
 }
 
+#ifdef CONFIG_KVM_INTROSPECTION
+static int descriptor_access_interception(struct vcpu_svm *svm)
+{
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct vmcb_control_area *c = &svm->vmcb->control;
+
+	switch (c->exit_code) {
+	case SVM_EXIT_IDTR_READ:
+	case SVM_EXIT_IDTR_WRITE:
+		kvmi_descriptor_event(vcpu, KVMI_DESC_IDTR,
+				      c->exit_code == SVM_EXIT_IDTR_WRITE);
+		break;
+	case SVM_EXIT_GDTR_READ:
+	case SVM_EXIT_GDTR_WRITE:
+		kvmi_descriptor_event(vcpu, KVMI_DESC_GDTR,
+				      c->exit_code == SVM_EXIT_GDTR_WRITE);
+		break;
+	case SVM_EXIT_LDTR_READ:
+	case SVM_EXIT_LDTR_WRITE:
+		kvmi_descriptor_event(vcpu, KVMI_DESC_LDTR,
+				      c->exit_code == SVM_EXIT_LDTR_WRITE);
+		break;
+	case SVM_EXIT_TR_READ:
+	case SVM_EXIT_TR_WRITE:
+		kvmi_descriptor_event(vcpu, KVMI_DESC_TR,
+				      c->exit_code == SVM_EXIT_TR_WRITE);
+		break;
+	default:
+		break;
+	}
+
+	return kvm_emulate_instruction(vcpu, 0);
+}
+#endif /* CONFIG_KVM_INTROSPECTION */
+
 static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_READ_CR0]			= cr_interception,
 	[SVM_EXIT_READ_CR3]			= cr_interception,
@@ -4874,6 +4909,16 @@ static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_RSM]                          = rsm_interception,
 	[SVM_EXIT_AVIC_INCOMPLETE_IPI]		= avic_incomplete_ipi_interception,
 	[SVM_EXIT_AVIC_UNACCELERATED_ACCESS]	= avic_unaccelerated_access_interception,
+#ifdef CONFIG_KVM_INTROSPECTION
+	[SVM_EXIT_IDTR_READ]			= descriptor_access_interception,
+	[SVM_EXIT_GDTR_READ]			= descriptor_access_interception,
+	[SVM_EXIT_LDTR_READ]			= descriptor_access_interception,
+	[SVM_EXIT_TR_READ]			= descriptor_access_interception,
+	[SVM_EXIT_IDTR_WRITE]			= descriptor_access_interception,
+	[SVM_EXIT_GDTR_WRITE]			= descriptor_access_interception,
+	[SVM_EXIT_LDTR_WRITE]			= descriptor_access_interception,
+	[SVM_EXIT_TR_WRITE]			= descriptor_access_interception,
+#endif /* CONFIG_KVM_INTROSPECTION */
 };
 
 static void dump_vmcb(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 157dfc3f756a..68986f600f98 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3070,11 +3070,11 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 
 	if (!boot_cpu_has(X86_FEATURE_UMIP) && vmx_umip_emulated()) {
 		if (cr4 & X86_CR4_UMIP) {
-			secondary_exec_controls_setbit(vmx, SECONDARY_EXEC_DESC);
+			vmx_control_desc_intercept(vcpu, true);
 			hw_cr4 &= ~X86_CR4_UMIP;
 		} else if (!is_guest_mode(vcpu) ||
 			!nested_cpu_has2(get_vmcs12(vcpu), SECONDARY_EXEC_DESC)) {
-			secondary_exec_controls_clearbit(vmx, SECONDARY_EXEC_DESC);
+			vmx_control_desc_intercept(vcpu, false);
 		}
 	}
 
@@ -4831,7 +4831,40 @@ static int handle_set_cr4(struct kvm_vcpu *vcpu, unsigned long val)
 
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
+	/*
+	 * For now, this function returns false only when the guest
+	 * is ungracefully stopped (crashed) or the current instruction
+	 * is skipped by the introspection tool.
+	 */
+	if (!kvmi_descriptor_event(vcpu, descriptor, store))
+		return 1;
+
+	/*
+	 * We are here because X86_CR4_UMIP was set or
+	 * KVMI enabled the interception.
+	 */
+#else
 	WARN_ON(!(vcpu->arch.cr4 & X86_CR4_UMIP));
+#endif /* CONFIG_KVM_INTROSPECTION */
 	return kvm_emulate_instruction(vcpu, 0);
 }
 
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 5e911ca7a636..a8f5dc415e3d 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -51,6 +51,7 @@ enum {
 	KVMI_EVENT_CR         = 4,
 	KVMI_EVENT_TRAP       = 5,
 	KVMI_EVENT_XSETBV     = 6,
+	KVMI_EVENT_DESCRIPTOR = 7,
 
 	KVMI_NUM_EVENTS
 };
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 600d65922bf4..4308cb995ce3 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -54,6 +54,7 @@ enum {
 	GUEST_TEST_NOOP = 0,
 	GUEST_TEST_BP,
 	GUEST_TEST_CR,
+	GUEST_TEST_DESCRIPTOR,
 	GUEST_TEST_HYPERCALL,
 	GUEST_TEST_XSETBV,
 };
@@ -79,6 +80,14 @@ static void guest_cr_test(void)
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
@@ -138,6 +147,9 @@ static void guest_code(void)
 		case GUEST_TEST_CR:
 			guest_cr_test();
 			break;
+		case GUEST_TEST_DESCRIPTOR:
+			guest_descriptor_test();
+			break;
 		case GUEST_TEST_HYPERCALL:
 			guest_hypercall_test();
 			break;
@@ -1360,6 +1372,53 @@ static void test_cmd_vcpu_get_mtrr_type(struct kvm_vm *vm)
 	DEBUG("mtrr_type: gpa 0x%lx type 0x%x\n", test_gpa, rpl.type);
 }
 
+static void test_event_descriptor(struct kvm_vm *vm)
+{
+	struct vcpu_worker_data data = {
+		.vm = vm,
+		.vcpu_id = VCPU_ID,
+		.test_id = GUEST_TEST_DESCRIPTOR,
+	};
+	struct kvmi_msg_hdr hdr;
+	struct {
+		struct kvmi_event common;
+		struct kvmi_event_descriptor desc;
+	} ev;
+	struct vcpu_reply rpl = {};
+	__u16 event_id = KVMI_EVENT_DESCRIPTOR;
+	pthread_t vcpu_thread;
+
+	enable_vcpu_event(vm, event_id);
+
+	vcpu_thread = start_vcpu_worker(&data);
+
+	receive_event(&hdr, &ev.common, sizeof(ev), event_id);
+
+	DEBUG("Descriptor event (read), descriptor %u, write %u\n",
+		ev.desc.descriptor, ev.desc.write);
+
+	TEST_ASSERT(ev.desc.write == 0,
+		"Received a write descriptor access\n");
+
+	reply_to_event(&hdr, &ev.common, KVMI_EVENT_ACTION_CONTINUE,
+			&rpl, sizeof(rpl));
+
+	receive_event(&hdr, &ev.common, sizeof(ev), event_id);
+
+	DEBUG("Descriptor event (write), descriptor %u, write %u\n",
+		ev.desc.descriptor, ev.desc.write);
+
+	TEST_ASSERT(ev.desc.write == 1,
+		"Received a read descriptor access\n");
+
+	reply_to_event(&hdr, &ev.common, KVMI_EVENT_ACTION_CONTINUE,
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
@@ -1387,6 +1446,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_event_xsetbv(vm);
 	test_cmd_vcpu_get_xsave(vm);
 	test_cmd_vcpu_get_mtrr_type(vm);
+	test_event_descriptor(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 1e28355ea4d7..6d2c09a12c49 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -24,6 +24,7 @@
 #define KVMI_KNOWN_VCPU_EVENTS ( \
 			    BIT(KVMI_EVENT_BREAKPOINT) \
 			  | BIT(KVMI_EVENT_CR) \
+			  | BIT(KVMI_EVENT_DESCRIPTOR) \
 			  | BIT(KVMI_EVENT_HYPERCALL) \
 			  | BIT(KVMI_EVENT_TRAP) \
 			  | BIT(KVMI_EVENT_PAUSE_VCPU) \
@@ -79,6 +80,7 @@ int kvmi_msg_send_unhook(struct kvm_introspection *kvmi);
 u32 kvmi_msg_send_vcpu_pause(struct kvm_vcpu *vcpu);
 u32 kvmi_msg_send_hypercall(struct kvm_vcpu *vcpu);
 u32 kvmi_msg_send_bp(struct kvm_vcpu *vcpu, u64 gpa, u8 insn_len);
+u32 kvmi_msg_send_descriptor(struct kvm_vcpu *vcpu, u8 descriptor, u8 write);
 
 /* kvmi.c */
 void *kvmi_msg_alloc(void);
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 6f23bc7517aa..fed483bec936 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -1029,3 +1029,20 @@ void kvmi_xsetbv_event(struct kvm_vcpu *vcpu)
 
 	kvmi_put(vcpu->kvm);
 }
+
+u32 kvmi_msg_send_descriptor(struct kvm_vcpu *vcpu, u8 descriptor, u8 write)
+{
+	struct kvmi_event_descriptor e;
+	int err, action;
+
+	memset(&e, 0, sizeof(e));
+	e.descriptor = descriptor;
+	e.write = write;
+
+	err = kvmi_send_event(vcpu, KVMI_EVENT_DESCRIPTOR, &e, sizeof(e),
+			      NULL, 0, &action);
+	if (err)
+		return KVMI_EVENT_ACTION_CONTINUE;
+
+	return action;
+}
