Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52A51197901
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729750AbgC3KUE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:20:04 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:43882 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729518AbgC3KUB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 06:20:01 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 96215305D3CC;
        Mon, 30 Mar 2020 13:13:00 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 69134305B7A1;
        Mon, 30 Mar 2020 13:13:00 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v8 70/81] KVM: introspection: add KVMI_EVENT_DESCRIPTOR
Date:   Mon, 30 Mar 2020 13:12:57 +0300
Message-Id: <20200330101308.21702-71-alazar@bitdefender.com>
In-Reply-To: <20200330101308.21702-1-alazar@bitdefender.com>
References: <20200330101308.21702-1-alazar@bitdefender.com>
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
 Documentation/virt/kvm/kvmi.rst               | 41 ++++++++++
 arch/x86/include/asm/kvmi_host.h              |  3 +
 arch/x86/include/uapi/asm/kvmi.h              | 11 +++
 arch/x86/kvm/kvmi.c                           | 75 +++++++++++++++++++
 arch/x86/kvm/svm.c                            | 33 ++++++++
 arch/x86/kvm/vmx/vmx.c                        | 23 ++++++
 include/uapi/linux/kvmi.h                     |  1 +
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 75 +++++++++++++++++++
 virt/kvm/introspection/kvmi.c                 |  1 +
 9 files changed, 263 insertions(+)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 9d37030213a6..6f6551230e11 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -548,6 +548,7 @@ the following events::
 
 	KVMI_EVENT_BREAKPOINT
 	KVMI_EVENT_CR
+	KVMI_EVENT_DESCRIPTOR
 	KVMI_EVENT_HYPERCALL
 	KVMI_EVENT_XSETBV
 
@@ -572,6 +573,8 @@ the *KVMI_VM_CONTROL_EVENTS* command.
 * -KVM_EINVAL - the event ID is unknown (use *KVMI_VM_CHECK_EVENT* first)
 * -KVM_EPERM - the access is disallowed (use *KVMI_VM_CHECK_EVENT* first)
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
+* -KVM_EOPNOTSUPP - the event can't be intercepted in the current setup
+                    (e.g. KVMI_EVENT_DESCRIPTOR with AMD)
 * -KVM_EBUSY - the event can't be intercepted right now
                (e.g. KVMI_EVENT_BREAKPOINT if the #BP event is already intercepted
                 by userspace)
@@ -1107,3 +1110,41 @@ to be changed and the introspection has been enabled for this event
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
index b3fa950362db..7633501031d2 100644
--- a/arch/x86/include/asm/kvmi_host.h
+++ b/arch/x86/include/asm/kvmi_host.h
@@ -31,6 +31,7 @@ bool kvmi_cr_event(struct kvm_vcpu *vcpu, unsigned int cr,
 bool kvmi_cr3_intercepted(struct kvm_vcpu *vcpu);
 bool kvmi_monitor_cr3w_intercept(struct kvm_vcpu *vcpu, bool enable);
 void kvmi_xsetbv_event(struct kvm_vcpu *vcpu);
+bool kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor, bool write);
 
 #else /* CONFIG_KVM_INTROSPECTION */
 
@@ -43,6 +44,8 @@ static inline bool kvmi_cr3_intercepted(struct kvm_vcpu *vcpu) { return false; }
 static inline bool kvmi_monitor_cr3w_intercept(struct kvm_vcpu *vcpu,
 						bool enable) { return false; }
 static inline void kvmi_xsetbv_event(struct kvm_vcpu *vcpu) { }
+static inline bool kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor,
+					 bool write) { return true; }
 
 #endif /* CONFIG_KVM_INTROSPECTION */
 
diff --git a/arch/x86/include/uapi/asm/kvmi.h b/arch/x86/include/uapi/asm/kvmi.h
index d622c89a4f2c..691a501200b3 100644
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
index 3de7e98fa426..093ff0da88ff 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -360,6 +360,21 @@ static void kvmi_arch_disable_cr3w_intercept(struct kvm_vcpu *vcpu)
 	vcpu->arch.kvmi->cr3w.kvm_intercepted = false;
 }
 
+static int kvmi_control_desc_intercept(struct kvm_vcpu *vcpu, bool enable)
+{
+	if (!kvm_x86_ops->desc_ctrl_supported())
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
@@ -369,6 +384,9 @@ int kvmi_arch_cmd_control_intercept(struct kvm_vcpu *vcpu,
 	case KVMI_EVENT_BREAKPOINT:
 		err = kvmi_control_bp_intercept(vcpu, enable);
 		break;
+	case KVMI_EVENT_DESCRIPTOR:
+		err = kvmi_control_desc_intercept(vcpu, enable);
+		break;
 	default:
 		break;
 	}
@@ -405,6 +423,7 @@ bool kvmi_arch_restore_interception(struct kvm_vcpu *vcpu)
 
 	kvmi_arch_disable_bp_intercept(vcpu);
 	kvmi_arch_disable_cr3w_intercept(vcpu);
+	kvmi_arch_disable_desc_intercept(vcpu);
 
 	return true;
 }
@@ -729,3 +748,59 @@ int kvmi_arch_cmd_vcpu_get_mtrr_type(struct kvm_vcpu *vcpu, u64 gpa, u8 *type)
 
 	return 0;
 }
+
+static u32 kvmi_msg_send_descriptor(struct kvm_vcpu *vcpu, u8 descriptor,
+				    bool write)
+{
+	struct kvmi_event_descriptor e;
+	int err, action;
+
+	memset(&e, 0, sizeof(e));
+	e.descriptor = descriptor;
+	e.write = write ? 1 : 0;
+
+	err = kvmi_send_event(vcpu, KVMI_EVENT_DESCRIPTOR, &e, sizeof(e),
+			      NULL, 0, &action);
+	if (err)
+		return KVMI_EVENT_ACTION_CONTINUE;
+
+	return action;
+}
+
+static bool __kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor,
+				    bool write)
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
+bool kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor, bool write)
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
index 1021ff2f9e57..b377acc3410c 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -4854,6 +4854,39 @@ static int descriptor_access_interception(struct vcpu_svm *svm)
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
index f6180ecf15ba..c54c01e088b6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4866,7 +4866,30 @@ static int handle_set_cr4(struct kvm_vcpu *vcpu, unsigned long val)
 
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
index 0827bd90691b..2ccc4045137f 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -50,6 +50,7 @@ enum {
 	KVMI_EVENT_CR         = 4,
 	KVMI_EVENT_TRAP       = 5,
 	KVMI_EVENT_XSETBV     = 6,
+	KVMI_EVENT_DESCRIPTOR = 7,
 
 	KVMI_NUM_EVENTS
 };
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index b984c3704baf..4f2de304a6f8 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -55,6 +55,7 @@ enum {
 	GUEST_TEST_NOOP = 0,
 	GUEST_TEST_BP,
 	GUEST_TEST_CR,
+	GUEST_TEST_DESCRIPTOR,
 	GUEST_TEST_HYPERCALL,
 	GUEST_TEST_XSETBV,
 };
@@ -80,6 +81,14 @@ static void guest_cr_test(void)
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
@@ -139,6 +148,9 @@ static void guest_code(void)
 		case GUEST_TEST_CR:
 			guest_cr_test();
 			break;
+		case GUEST_TEST_DESCRIPTOR:
+			guest_descriptor_test();
+			break;
 		case GUEST_TEST_HYPERCALL:
 			guest_hypercall_test();
 			break;
@@ -1363,6 +1375,68 @@ static void test_cmd_vcpu_get_mtrr_type(struct kvm_vm *vm)
 	DEBUG("mtrr_type: gpa 0x%lx type 0x%x\n", test_gpa, rpl.type);
 }
 
+static void test_desc_read_access(__u16 event_id)
+{
+	struct kvmi_msg_hdr hdr;
+	struct {
+		struct kvmi_event common;
+		struct kvmi_event_descriptor desc;
+	} ev;
+	struct vcpu_reply rpl = {};
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
+}
+
+static void test_desc_write_access(__u16 event_id)
+{
+	struct kvmi_msg_hdr hdr;
+	struct {
+		struct kvmi_event common;
+		struct kvmi_event_descriptor desc;
+	} ev;
+	struct vcpu_reply rpl = {};
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
+}
+
+static void test_event_descriptor(struct kvm_vm *vm)
+{
+	struct vcpu_worker_data data = {
+		.vm = vm,
+		.vcpu_id = VCPU_ID,
+		.test_id = GUEST_TEST_DESCRIPTOR,
+	};
+	__u16 event_id = KVMI_EVENT_DESCRIPTOR;
+	pthread_t vcpu_thread;
+
+	enable_vcpu_event(vm, event_id);
+	vcpu_thread = start_vcpu_worker(&data);
+
+	test_desc_read_access(event_id);
+	test_desc_write_access(event_id);
+
+	stop_vcpu_worker(vcpu_thread, &data);
+	disable_vcpu_event(vm, event_id);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	srandom(time(0));
@@ -1391,6 +1465,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_event_xsetbv(vm);
 	test_cmd_vcpu_get_xsave(vm);
 	test_cmd_vcpu_get_mtrr_type(vm);
+	test_event_descriptor(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index d358686fce76..db79744e5d2f 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -80,6 +80,7 @@ static void setup_known_events(void)
 	bitmap_zero(Kvmi_known_vcpu_events, KVMI_NUM_EVENTS);
 	set_bit(KVMI_EVENT_BREAKPOINT, Kvmi_known_vcpu_events);
 	set_bit(KVMI_EVENT_CR, Kvmi_known_vcpu_events);
+	set_bit(KVMI_EVENT_DESCRIPTOR, Kvmi_known_vcpu_events);
 	set_bit(KVMI_EVENT_HYPERCALL, Kvmi_known_vcpu_events);
 	set_bit(KVMI_EVENT_PAUSE_VCPU, Kvmi_known_vcpu_events);
 	set_bit(KVMI_EVENT_TRAP, Kvmi_known_vcpu_events);
