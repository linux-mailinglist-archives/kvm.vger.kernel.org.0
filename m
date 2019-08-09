Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46D7F87F42
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437160AbfHIQPd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:15:33 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53078 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437167AbfHIQPK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:15:10 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 492A4305D354;
        Fri,  9 Aug 2019 19:01:27 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id DE9C0305B7A1;
        Fri,  9 Aug 2019 19:01:26 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?q?Samuel=20Laur=C3=A9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>, Zhang@vger.kernel.org,
        Yu C <yu.c.zhang@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>
Subject: [RFC PATCH v6 63/92] kvm: introspection: add KVMI_EVENT_DESCRIPTOR
Date:   Fri,  9 Aug 2019 19:00:18 +0300
Message-Id: <20190809160047.8319-64-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
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
 Documentation/virtual/kvm/kvmi.rst | 38 +++++++++++++++
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/include/uapi/asm/kvmi.h   | 11 +++++
 arch/x86/kvm/kvmi.c                | 70 ++++++++++++++++++++++++++++
 arch/x86/kvm/svm.c                 | 74 ++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c             | 59 +++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.h             |  2 +
 arch/x86/kvm/x86.c                 |  6 +++
 include/linux/kvm_host.h           |  1 +
 include/linux/kvmi.h               |  4 ++
 virt/kvm/kvmi.c                    |  2 +-
 virt/kvm/kvmi_int.h                |  3 ++
 virt/kvm/kvmi_msg.c                | 17 +++++++
 13 files changed, 285 insertions(+), 3 deletions(-)

diff --git a/Documentation/virtual/kvm/kvmi.rst b/Documentation/virtual/kvm/kvmi.rst
index 2603813d1ee6..8721a470de87 100644
--- a/Documentation/virtual/kvm/kvmi.rst
+++ b/Documentation/virtual/kvm/kvmi.rst
@@ -1536,3 +1536,41 @@ It is used by the code residing inside the introspected guest to call the
 introspection tool and to report certain details about its operation. For
 example, a classic antimalware remediation tool can report what it has
 found during a scan.
+
+11. KVMI_EVENT_DESCRIPTOR
+-------------------------
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
+introspection has been enabled for this event (see **KVMI_CONTROL_EVENTS**).
+
+``kvmi_event`` and ``kvmi_event_descriptor`` are sent to the introspector.
+
+``descriptor`` can be one of::
+
+	KVMI_DESC_IDTR
+	KVMI_DESC_GDTR
+	KVMI_DESC_LDTR
+	KVMI_DESC_TR
+
+``write`` is 1 if the descriptor was written, 0 otherwise.
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 91cd43a7a7bf..ad36a5fc2048 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1015,6 +1015,7 @@ struct kvm_x86_ops {
 
 	void (*msr_intercept)(struct kvm_vcpu *vcpu, unsigned int msr,
 				bool enable);
+	bool (*desc_intercept)(struct kvm_vcpu *vcpu, bool enable);
 	void (*cr3_write_exiting)(struct kvm_vcpu *vcpu, bool enable);
 	bool (*nested_pagefault)(struct kvm_vcpu *vcpu);
 	bool (*spt_fault)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/include/uapi/asm/kvmi.h b/arch/x86/include/uapi/asm/kvmi.h
index c3c96e6e2a26..0fa4ac3ed5d1 100644
--- a/arch/x86/include/uapi/asm/kvmi.h
+++ b/arch/x86/include/uapi/asm/kvmi.h
@@ -110,4 +110,15 @@ struct kvmi_get_mtrr_type_reply {
 	__u8 padding[7];
 };
 
+#define KVMI_DESC_IDTR	1
+#define KVMI_DESC_GDTR	2
+#define KVMI_DESC_LDTR	3
+#define KVMI_DESC_TR	4
+
+struct kvmi_event_descriptor {
+	__u8 descriptor;
+	__u8 write;
+	__u8 padding[6];
+};
+
 #endif /* _UAPI_ASM_X86_KVMI_H */
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 02e026ef5ed7..04cac5b8a4d0 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -161,6 +161,38 @@ bool kvmi_monitored_msr(struct kvm_vcpu *vcpu, u32 msr)
 }
 EXPORT_SYMBOL(kvmi_monitored_msr);
 
+static int kvmi_control_event_desc(struct kvm_vcpu *vcpu, bool enable)
+{
+	int err = 0;
+
+	if (enable) {
+		if (!is_event_enabled(vcpu, KVMI_EVENT_DESCRIPTOR))
+			if (!kvm_arch_vcpu_intercept_desc(vcpu, true))
+				err = -KVM_EOPNOTSUPP;
+	} else if (is_event_enabled(vcpu, KVMI_EVENT_DESCRIPTOR)) {
+		kvm_arch_vcpu_intercept_desc(vcpu, false);
+	}
+
+	return err;
+}
+
+int kvmi_arch_cmd_control_event(struct kvm_vcpu *vcpu, unsigned int event_id,
+				bool enable)
+{
+	int err;
+
+	switch (event_id) {
+	case KVMI_EVENT_DESCRIPTOR:
+		err = kvmi_control_event_desc(vcpu, enable);
+		break;
+	default:
+		err = 0;
+		break;
+	}
+
+	return err;
+}
+
 static void *alloc_get_registers_reply(const struct kvmi_msg_hdr *msg,
 				       const struct kvmi_get_registers *req,
 				       size_t *rpl_size)
@@ -604,6 +636,44 @@ void kvmi_arch_trap_event(struct kvm_vcpu *vcpu)
 	}
 }
 
+static bool __kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor,
+				    u8 write)
+{
+	u32 action;
+	bool ret = false;
+
+	action = kvmi_msg_send_descriptor(vcpu, descriptor, write);
+	switch (action) {
+	case KVMI_EVENT_ACTION_CONTINUE:
+		ret = true;
+		break;
+	case KVMI_EVENT_ACTION_RETRY:
+		break;
+	default:
+		kvmi_handle_common_event_actions(vcpu, action, "DESC");
+	}
+
+	return ret;
+}
+
+bool kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor, u8 write)
+{
+	struct kvmi *ikvm;
+	bool ret = true;
+
+	ikvm = kvmi_get(vcpu->kvm);
+	if (!ikvm)
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
+
 int kvmi_arch_cmd_get_cpuid(struct kvm_vcpu *vcpu,
 			    const struct kvmi_get_cpuid *req,
 			    struct kvmi_get_cpuid_reply *rpl)
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index b4e59ef040b7..b178b8900660 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -52,6 +52,7 @@
 #include <asm/kvm_para.h>
 #include <asm/irq_remapping.h>
 #include <asm/spec-ctrl.h>
+#include <asm/kvmi.h>
 
 #include <asm/virtext.h>
 #include "trace.h"
@@ -4754,6 +4755,41 @@ static int avic_unaccelerated_access_interception(struct vcpu_svm *svm)
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
+	return 1;
+}
+#endif /* CONFIG_KVM_INTROSPECTION */
+
 static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_READ_CR0]			= cr_interception,
 	[SVM_EXIT_READ_CR3]			= cr_interception,
@@ -4819,6 +4855,16 @@ static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
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
@@ -7141,6 +7187,33 @@ static void svm_cr3_write_exiting(struct kvm_vcpu *vcpu, bool enable)
 {
 }
 
+static bool svm_desc_intercept(struct kvm_vcpu *vcpu, bool enable)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (enable) {
+		set_intercept(svm, INTERCEPT_STORE_IDTR);
+		set_intercept(svm, INTERCEPT_STORE_GDTR);
+		set_intercept(svm, INTERCEPT_STORE_LDTR);
+		set_intercept(svm, INTERCEPT_STORE_TR);
+		set_intercept(svm, INTERCEPT_LOAD_IDTR);
+		set_intercept(svm, INTERCEPT_LOAD_GDTR);
+		set_intercept(svm, INTERCEPT_LOAD_LDTR);
+		set_intercept(svm, INTERCEPT_LOAD_TR);
+	} else {
+		clr_intercept(svm, INTERCEPT_STORE_IDTR);
+		clr_intercept(svm, INTERCEPT_STORE_GDTR);
+		clr_intercept(svm, INTERCEPT_STORE_LDTR);
+		clr_intercept(svm, INTERCEPT_STORE_TR);
+		clr_intercept(svm, INTERCEPT_LOAD_IDTR);
+		clr_intercept(svm, INTERCEPT_LOAD_GDTR);
+		clr_intercept(svm, INTERCEPT_LOAD_LDTR);
+		clr_intercept(svm, INTERCEPT_LOAD_TR);
+	}
+
+	return true;
+}
+
 static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.cpu_has_kvm_support = has_svm,
 	.disabled_by_bios = is_disabled,
@@ -7154,6 +7227,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 
 	.cr3_write_exiting = svm_cr3_write_exiting,
 	.msr_intercept = svm_msr_intercept,
+	.desc_intercept = svm_desc_intercept,
 	.nested_pagefault = svm_nested_pagefault,
 	.spt_fault = svm_spt_fault,
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d560b583bf30..7d1e341b51ad 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -22,6 +22,7 @@
 #include <linux/kernel.h>
 #include <linux/kvm_host.h>
 #include <asm/kvmi_host.h>
+#include <uapi/linux/kvmi.h>
 #include <linux/kvmi.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
@@ -2922,8 +2923,9 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 			hw_cr4 &= ~X86_CR4_UMIP;
 		} else if (!is_guest_mode(vcpu) ||
 			!nested_cpu_has2(get_vmcs12(vcpu), SECONDARY_EXEC_DESC))
-			vmcs_clear_bits(SECONDARY_VM_EXEC_CONTROL,
-					SECONDARY_EXEC_DESC);
+			if (!to_vmx(vcpu)->tracking_desc)
+				vmcs_clear_bits(SECONDARY_VM_EXEC_CONTROL,
+						SECONDARY_EXEC_DESC);
 	}
 
 	if (cr4 & X86_CR4_VMXE) {
@@ -4691,7 +4693,43 @@ static int handle_set_cr4(struct kvm_vcpu *vcpu, unsigned long val)
 
 static int handle_desc(struct kvm_vcpu *vcpu)
 {
+#ifdef CONFIG_KVM_INTROSPECTION
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	u32 exit_reason = vmx->exit_reason;
+	u32 vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
+	u8 store = (vmx_instruction_info >> 29) & 0x1;
+	u8 descriptor = 0;
+
+	if (!vmx->tracking_desc)
+		goto emulate;
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
+emulate:
+	/*
+	 * We are here because X86_CR4_UMIP was set or
+	 * KVMI enabled the interception.
+	 */
+#else
 	WARN_ON(!(vcpu->arch.cr4 & X86_CR4_UMIP));
+#endif /* CONFIG_KVM_INTROSPECTION */
 	return kvm_emulate_instruction(vcpu, 0) == EMULATE_DONE;
 }
 
@@ -7840,6 +7878,22 @@ static bool vmx_spt_fault(struct kvm_vcpu *vcpu)
 	return (vmx->exit_reason == EXIT_REASON_EPT_VIOLATION);
 }
 
+static bool vmx_desc_intercept(struct kvm_vcpu *vcpu, bool enable)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	if (!cpu_has_secondary_exec_ctrls())
+		return false;
+
+	if (enable)
+		vmcs_set_bits(SECONDARY_VM_EXEC_CONTROL, SECONDARY_EXEC_DESC);
+	else
+		vmcs_clear_bits(SECONDARY_VM_EXEC_CONTROL, SECONDARY_EXEC_DESC);
+
+	vmx->tracking_desc = enable;
+	return true;
+}
+
 static bool vmx_get_spp_status(void)
 {
 	return spp_supported;
@@ -7875,6 +7929,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 
 	.msr_intercept = vmx_msr_intercept,
 	.cr3_write_exiting = vmx_cr3_write_exiting,
+	.desc_intercept = vmx_desc_intercept,
 	.nested_pagefault = vmx_nested_pagefault,
 	.spt_fault = vmx_spt_fault,
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 0ac0a64c7790..580b02f86011 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -268,6 +268,8 @@ struct vcpu_vmx {
 	u64 msr_ia32_feature_control_valid_bits;
 	u64 ept_pointer;
 
+	bool tracking_desc;
+
 	struct pt_desc pt_desc;
 };
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d568e60ae568..38aaddadb93a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10140,6 +10140,12 @@ bool kvm_spt_fault(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL(kvm_spt_fault);
 
+bool kvm_arch_vcpu_intercept_desc(struct kvm_vcpu *vcpu, bool enable)
+{
+	return kvm_x86_ops->desc_intercept(vcpu, enable);
+}
+EXPORT_SYMBOL(kvm_arch_vcpu_intercept_desc);
+
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b77914e944a4..6c57291414d0 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -806,6 +806,7 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 					struct kvm_guest_debug *dbg);
 int kvm_arch_vcpu_set_guest_debug(struct kvm_vcpu *vcpu,
 				  struct kvm_guest_debug *dbg);
+bool kvm_arch_vcpu_intercept_desc(struct kvm_vcpu *vcpu, bool enable);
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run);
 void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
 				  struct kvm_xsave *guest_xsave);
diff --git a/include/linux/kvmi.h b/include/linux/kvmi.h
index 59d83d2d0cca..5d162b9e67f2 100644
--- a/include/linux/kvmi.h
+++ b/include/linux/kvmi.h
@@ -20,6 +20,7 @@ bool kvmi_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva, u8 insn_len);
 bool kvmi_hypercall_event(struct kvm_vcpu *vcpu);
 bool kvmi_queue_exception(struct kvm_vcpu *vcpu);
 void kvmi_trap_event(struct kvm_vcpu *vcpu);
+bool kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor, u8 write);
 void kvmi_handle_requests(struct kvm_vcpu *vcpu);
 void kvmi_init_emulate(struct kvm_vcpu *vcpu);
 void kvmi_activate_rep_complete(struct kvm_vcpu *vcpu);
@@ -35,6 +36,9 @@ static inline int kvmi_vcpu_init(struct kvm_vcpu *vcpu) { return 0; }
 static inline bool kvmi_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva,
 					 u8 insn_len)
 			{ return true; }
+static inline bool kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor,
+					 u8 write)
+			{ return true; }
 static inline void kvmi_vcpu_uninit(struct kvm_vcpu *vcpu) { }
 static inline void kvmi_handle_requests(struct kvm_vcpu *vcpu) { }
 static inline bool kvmi_hypercall_event(struct kvm_vcpu *vcpu) { return false; }
diff --git a/virt/kvm/kvmi.c b/virt/kvm/kvmi.c
index d04e13a0b244..d47a725a4045 100644
--- a/virt/kvm/kvmi.c
+++ b/virt/kvm/kvmi.c
@@ -1529,7 +1529,7 @@ int kvmi_cmd_control_events(struct kvm_vcpu *vcpu, unsigned int event_id,
 		err = kvmi_control_event_breakpoint(vcpu, enable);
 		break;
 	default:
-		err = 0;
+		err = kvmi_arch_cmd_control_event(vcpu, event_id, enable);
 		break;
 	}
 
diff --git a/virt/kvm/kvmi_int.h b/virt/kvm/kvmi_int.h
index 793ec269b9fa..d7f9858d3e97 100644
--- a/virt/kvm/kvmi_int.h
+++ b/virt/kvm/kvmi_int.h
@@ -189,6 +189,7 @@ u32 kvmi_msg_send_hypercall(struct kvm_vcpu *vcpu);
 u32 kvmi_msg_send_pf(struct kvm_vcpu *vcpu, u64 gpa, u64 gva, u8 access,
 		     bool *singlestep, bool *rep_complete,
 		     u64 *ctx_addr, u8 *ctx, u32 *ctx_size);
+u32 kvmi_msg_send_descriptor(struct kvm_vcpu *vcpu, u8 descriptor, u8 write);
 u32 kvmi_msg_send_create_vcpu(struct kvm_vcpu *vcpu);
 u32 kvmi_msg_send_pause_vcpu(struct kvm_vcpu *vcpu);
 int kvmi_msg_send_unhook(struct kvmi *ikvm);
@@ -228,6 +229,8 @@ void kvmi_handle_common_event_actions(struct kvm_vcpu *vcpu, u32 action,
 void kvmi_arch_update_page_tracking(struct kvm *kvm,
 				    struct kvm_memory_slot *slot,
 				    struct kvmi_mem_access *m);
+int kvmi_arch_cmd_control_event(struct kvm_vcpu *vcpu, unsigned int event_id,
+				bool enable);
 int kvmi_arch_cmd_get_registers(struct kvm_vcpu *vcpu,
 				const struct kvmi_msg_hdr *msg,
 				const struct kvmi_get_registers *req,
diff --git a/virt/kvm/kvmi_msg.c b/virt/kvm/kvmi_msg.c
index 89f63f40f5cc..3e381f95b686 100644
--- a/virt/kvm/kvmi_msg.c
+++ b/virt/kvm/kvmi_msg.c
@@ -1163,6 +1163,23 @@ u32 kvmi_msg_send_pf(struct kvm_vcpu *vcpu, u64 gpa, u64 gva, u8 access,
 	return action;
 }
 
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
+
 u32 kvmi_msg_send_create_vcpu(struct kvm_vcpu *vcpu)
 {
 	int err, action;
