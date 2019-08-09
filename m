Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7727A87F54
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437195AbfHIQP6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:15:58 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53090 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437108AbfHIQPG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:15:06 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 9370D305D352;
        Fri,  9 Aug 2019 19:01:26 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 34541305B7A4;
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
Subject: [RFC PATCH v6 61/92] kvm: introspection: add KVMI_EVENT_BREAKPOINT
Date:   Fri,  9 Aug 2019 19:00:16 +0300
Message-Id: <20190809160047.8319-62-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

This event is sent when a breakpoint was reached. It has to
be enabled with the KVMI_CONTROL_EVENTS command first.

The introspection tool can place breakpoints and use them as notification
for when the OS or an application has reached a certain state or is
trying to perform a certain operation (like creating a process).

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virtual/kvm/kvmi.rst | 36 +++++++++++++
 arch/x86/kvm/kvmi.c                | 20 +++++++
 arch/x86/kvm/svm.c                 |  6 +++
 arch/x86/kvm/vmx/vmx.c             | 17 ++++--
 arch/x86/kvm/x86.c                 | 12 +++++
 include/linux/kvm_host.h           |  2 +
 include/linux/kvmi.h               |  7 +++
 include/uapi/linux/kvmi.h          |  6 +++
 virt/kvm/kvmi.c                    | 84 ++++++++++++++++++++++++++++--
 virt/kvm/kvmi_int.h                |  3 ++
 virt/kvm/kvmi_msg.c                | 17 ++++++
 11 files changed, 201 insertions(+), 9 deletions(-)

diff --git a/Documentation/virtual/kvm/kvmi.rst b/Documentation/virtual/kvm/kvmi.rst
index 1d2431639770..da216415bf32 100644
--- a/Documentation/virtual/kvm/kvmi.rst
+++ b/Documentation/virtual/kvm/kvmi.rst
@@ -1469,3 +1469,39 @@ to be changed and the introspection has been enabled for this event
 (see *KVMI_CONTROL_EVENTS*).
 
 ``kvmi_event`` is sent to the introspector.
+
+9. KVMI_EVENT_BREAKPOINT
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
+been enabled for this event (see *KVMI_CONTROL_EVENTS*).
+
+Some of these breakpoints could have been injected by the introspector,
+placed in the slack space of various functions and used as notification
+for when the OS or an application has reached a certain state or is
+trying to perform a certain operation (like creating a process).
+
+``kvmi_event`` and the guest physical address are sent to the introspector.
+
+The *RETRY* action is used by the introspector for its own breakpoints.
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 0e9c91d2f282..e998223bca1e 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -428,6 +428,26 @@ void kvmi_xsetbv_event(struct kvm_vcpu *vcpu)
 	kvmi_put(vcpu->kvm);
 }
 
+void kvmi_arch_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva, u8 insn_len)
+{
+	u32 action;
+	u64 gpa;
+
+	gpa = kvm_mmu_gva_to_gpa_system(vcpu, gva, NULL);
+
+	action = kvmi_msg_send_bp(vcpu, gpa, insn_len);
+	switch (action) {
+	case KVMI_EVENT_ACTION_CONTINUE:
+		kvm_arch_queue_bp(vcpu);
+		break;
+	case KVMI_EVENT_ACTION_RETRY:
+		/* rip was most likely adjusted past the INT 3 instruction */
+		break;
+	default:
+		kvmi_handle_common_event_actions(vcpu, action, "BP");
+	}
+}
+
 bool kvmi_arch_pf_event(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 			u8 access)
 {
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index e46a4c423545..b4e59ef040b7 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -18,6 +18,7 @@
 #define pr_fmt(fmt) "SVM: " fmt
 
 #include <linux/kvm_host.h>
+#include <linux/kvmi.h>
 #include <asm/kvmi_host.h>
 
 #include "irq.h"
@@ -2722,6 +2723,11 @@ static int bp_interception(struct vcpu_svm *svm)
 {
 	struct kvm_run *kvm_run = svm->vcpu.run;
 
+	if (!kvmi_breakpoint_event(&svm->vcpu,
+		svm->vmcb->save.cs.base + svm->vmcb->save.rip,
+		svm->vmcb->control.insn_len))
+		return 1;
+
 	kvm_run->exit_reason = KVM_EXIT_DEBUG;
 	kvm_run->debug.arch.pc = svm->vmcb->save.cs.base + svm->vmcb->save.rip;
 	kvm_run->debug.arch.exception = BP_VECTOR;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fff41adcdffe..d560b583bf30 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -22,6 +22,7 @@
 #include <linux/kernel.h>
 #include <linux/kvm_host.h>
 #include <asm/kvmi_host.h>
+#include <linux/kvmi.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/mod_devicetable.h>
@@ -4484,7 +4485,7 @@ static int handle_exception(struct kvm_vcpu *vcpu)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct kvm_run *kvm_run = vcpu->run;
 	u32 intr_info, ex_no, error_code;
-	unsigned long cr2, rip, dr6;
+	unsigned long cr2, dr6;
 	u32 vect_info;
 	enum emulation_result er;
 
@@ -4562,7 +4563,10 @@ static int handle_exception(struct kvm_vcpu *vcpu)
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
@@ -4570,11 +4574,16 @@ static int handle_exception(struct kvm_vcpu *vcpu)
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
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e633f297e86d..a9da8ac0d2b3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8763,6 +8763,13 @@ int kvm_arch_vcpu_set_guest_debug(struct kvm_vcpu *vcpu,
 			kvm_queue_exception(vcpu, BP_VECTOR);
 	}
 
+#ifdef CONFIG_KVM_INTROSPECTION
+	if (kvmi_bp_intercepted(vcpu, dbg->control)) {
+		r = -EBUSY;
+		goto out;
+	}
+#endif
+
 	/*
 	 * Read rflags as long as potentially injected trace flags are still
 	 * filtered out.
@@ -10106,6 +10113,11 @@ void kvm_arch_msr_intercept(struct kvm_vcpu *vcpu, unsigned int msr,
 }
 EXPORT_SYMBOL_GPL(kvm_arch_msr_intercept);
 
+void kvm_arch_queue_bp(struct kvm_vcpu *vcpu)
+{
+	kvm_queue_exception(vcpu, BP_VECTOR);
+}
+
 void kvm_control_cr3_write_exiting(struct kvm_vcpu *vcpu, bool enable)
 {
 	kvm_x86_ops->cr3_write_exiting(vcpu, enable);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 691c24598b4d..b77914e944a4 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1330,4 +1330,6 @@ static inline int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 }
 #endif /* CONFIG_HAVE_KVM_VCPU_RUN_PID_CHANGE */
 
+void kvm_arch_queue_bp(struct kvm_vcpu *vcpu);
+
 #endif
diff --git a/include/linux/kvmi.h b/include/linux/kvmi.h
index 5ae02c64fb33..13b58b3202bb 100644
--- a/include/linux/kvmi.h
+++ b/include/linux/kvmi.h
@@ -16,11 +16,13 @@ int kvmi_ioctl_event(struct kvm *kvm, void __user *argp);
 int kvmi_ioctl_unhook(struct kvm *kvm, bool force_reset);
 int kvmi_vcpu_init(struct kvm_vcpu *vcpu);
 void kvmi_vcpu_uninit(struct kvm_vcpu *vcpu);
+bool kvmi_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva, u8 insn_len);
 bool kvmi_queue_exception(struct kvm_vcpu *vcpu);
 void kvmi_trap_event(struct kvm_vcpu *vcpu);
 void kvmi_handle_requests(struct kvm_vcpu *vcpu);
 void kvmi_init_emulate(struct kvm_vcpu *vcpu);
 void kvmi_activate_rep_complete(struct kvm_vcpu *vcpu);
+bool kvmi_bp_intercepted(struct kvm_vcpu *vcpu, u32 dbg);
 
 #else
 
@@ -29,12 +31,17 @@ static inline void kvmi_uninit(void) { }
 static inline void kvmi_create_vm(struct kvm *kvm) { }
 static inline void kvmi_destroy_vm(struct kvm *kvm) { }
 static inline int kvmi_vcpu_init(struct kvm_vcpu *vcpu) { return 0; }
+static inline bool kvmi_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva,
+					 u8 insn_len)
+			{ return true; }
 static inline void kvmi_vcpu_uninit(struct kvm_vcpu *vcpu) { }
 static inline void kvmi_handle_requests(struct kvm_vcpu *vcpu) { }
 static inline bool kvmi_queue_exception(struct kvm_vcpu *vcpu) { return true; }
 static inline void kvmi_trap_event(struct kvm_vcpu *vcpu) { }
 static inline void kvmi_init_emulate(struct kvm_vcpu *vcpu) { }
 static inline void kvmi_activate_rep_complete(struct kvm_vcpu *vcpu) { }
+static inline bool kvmi_bp_intercepted(struct kvm_vcpu *vcpu, u32 dbg)
+			{ return false; }
 
 #endif /* CONFIG_KVM_INTROSPECTION */
 
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index a4583de5c2f6..b072e0a4f33d 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -256,4 +256,10 @@ struct kvmi_event_pf_reply {
 	__u8 ctx_data[256];
 };
 
+struct kvmi_event_breakpoint {
+	__u64 gpa;
+	__u8 insn_len;
+	__u8 padding[7];
+};
+
 #endif /* _UAPI__LINUX_KVMI_H */
diff --git a/virt/kvm/kvmi.c b/virt/kvm/kvmi.c
index e3f308898a60..4c868a94ac37 100644
--- a/virt/kvm/kvmi.c
+++ b/virt/kvm/kvmi.c
@@ -219,6 +219,48 @@ static void kvmi_clear_mem_access(struct kvm *kvm)
 	srcu_read_unlock(&kvm->srcu, idx);
 }
 
+static int kvmi_control_event_breakpoint(struct kvm_vcpu *vcpu, bool enable)
+{
+	struct kvmi_vcpu *ivcpu = IVCPU(vcpu);
+	struct kvm_guest_debug dbg = {};
+	int err = 0;
+
+	if (enable) {
+		if (!is_event_enabled(vcpu, KVMI_EVENT_BREAKPOINT)) {
+			dbg.control = KVM_GUESTDBG_ENABLE |
+				      KVM_GUESTDBG_USE_SW_BP;
+			ivcpu->bp_intercepted = true;
+			err = kvm_arch_vcpu_set_guest_debug(vcpu, &dbg);
+		}
+	} else if (is_event_enabled(vcpu, KVMI_EVENT_BREAKPOINT)) {
+		ivcpu->bp_intercepted = false;
+		err = kvm_arch_vcpu_set_guest_debug(vcpu, &dbg);
+	}
+
+	return err;
+}
+
+bool kvmi_bp_intercepted(struct kvm_vcpu *vcpu, u32 dbg)
+{
+	struct kvmi *ikvm;
+	bool ret = false;
+
+	ikvm = kvmi_get(vcpu->kvm);
+	if (!ikvm)
+		return false;
+
+	if (IVCPU(vcpu)->bp_intercepted &&
+		!(dbg & (KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_SW_BP))) {
+		kvmi_warn_once(ikvm, "Trying to disable SW BP interception\n");
+		ret = true;
+	}
+
+	kvmi_put(vcpu->kvm);
+
+	return ret;
+}
+EXPORT_SYMBOL(kvmi_bp_intercepted);
+
 static void kvmi_cache_destroy(void)
 {
 	kmem_cache_destroy(msg_cache);
@@ -1058,6 +1100,26 @@ void kvmi_activate_rep_complete(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL(kvmi_activate_rep_complete);
 
+bool kvmi_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva, u8 insn_len)
+{
+	struct kvmi *ikvm;
+	bool ret = false;
+
+	ikvm = kvmi_get(vcpu->kvm);
+	if (!ikvm)
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
+
 /*
  * This function returns false if there is an exception or interrupt pending.
  * It returns true in all other cases including KVMI not being initialized.
@@ -1438,13 +1500,25 @@ int kvmi_cmd_control_events(struct kvm_vcpu *vcpu, unsigned int event_id,
 			    bool enable)
 {
 	struct kvmi_vcpu *ivcpu = IVCPU(vcpu);
+	int err;
 
-	if (enable)
-		set_bit(event_id, ivcpu->ev_mask);
-	else
-		clear_bit(event_id, ivcpu->ev_mask);
+	switch (event_id) {
+	case KVMI_EVENT_BREAKPOINT:
+		err = kvmi_control_event_breakpoint(vcpu, enable);
+		break;
+	default:
+		err = 0;
+		break;
+	}
 
-	return 0;
+	if (!err) {
+		if (enable)
+			set_bit(event_id, ivcpu->ev_mask);
+		else
+			clear_bit(event_id, ivcpu->ev_mask);
+	}
+
+	return err;
 }
 
 int kvmi_cmd_control_vm_events(struct kvmi *ikvm, unsigned int event_id,
diff --git a/virt/kvm/kvmi_int.h b/virt/kvm/kvmi_int.h
index ac2e13787f01..d039446922e6 100644
--- a/virt/kvm/kvmi_int.h
+++ b/virt/kvm/kvmi_int.h
@@ -118,6 +118,7 @@ struct kvmi_vcpu {
 	bool have_delayed_regs;
 	struct kvm_regs delayed_regs;
 
+	bool bp_intercepted;
 	DECLARE_BITMAP(ev_mask, KVMI_NUM_EVENTS);
 	DECLARE_BITMAP(cr_mask, KVMI_NUM_CR);
 	struct {
@@ -183,6 +184,7 @@ bool kvmi_msg_process(struct kvmi *ikvm);
 int kvmi_send_event(struct kvm_vcpu *vcpu, u32 ev_id,
 		    void *ev, size_t ev_size,
 		    void *rpl, size_t rpl_size, int *action);
+u32 kvmi_msg_send_bp(struct kvm_vcpu *vcpu, u64 gpa, u8 insn_len);
 u32 kvmi_msg_send_pf(struct kvm_vcpu *vcpu, u64 gpa, u64 gva, u8 access,
 		     bool *singlestep, bool *rep_complete,
 		     u64 *ctx_addr, u8 *ctx, u32 *ctx_size);
@@ -252,6 +254,7 @@ bool kvmi_arch_pf_event(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 			u8 access);
 bool kvmi_arch_queue_exception(struct kvm_vcpu *vcpu);
 void kvmi_arch_trap_event(struct kvm_vcpu *vcpu);
+void kvmi_arch_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva, u8 insn_len);
 int kvmi_arch_cmd_get_cpuid(struct kvm_vcpu *vcpu,
 			    const struct kvmi_get_cpuid *req,
 			    struct kvmi_get_cpuid_reply *rpl);
diff --git a/virt/kvm/kvmi_msg.c b/virt/kvm/kvmi_msg.c
index ee54d92b07ec..c7a1fa5f7245 100644
--- a/virt/kvm/kvmi_msg.c
+++ b/virt/kvm/kvmi_msg.c
@@ -1079,6 +1079,23 @@ int kvmi_msg_send_unhook(struct kvmi *ikvm)
 	return kvmi_sock_write(ikvm, vec, n, msg_size);
 }
 
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
+
 u32 kvmi_msg_send_pf(struct kvm_vcpu *vcpu, u64 gpa, u64 gva, u8 access,
 		     bool *singlestep, bool *rep_complete, u64 *ctx_addr,
 		     u8 *ctx_data, u32 *ctx_size)
