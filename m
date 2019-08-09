Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8598A87F64
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437237AbfHIQQW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:16:22 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:52860 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437054AbfHIQPB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:15:01 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id C3F22305D34E;
        Fri,  9 Aug 2019 19:01:22 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 5A9F4305B7A1;
        Fri,  9 Aug 2019 19:01:21 +0300 (EEST)
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
        Joerg Roedel <joro@8bytes.org>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>
Subject: [RFC PATCH v6 53/92] kvm: introspection: add KVMI_INJECT_EXCEPTION + KVMI_EVENT_TRAP
Date:   Fri,  9 Aug 2019 19:00:08 +0300
Message-Id: <20190809160047.8319-54-alazar@bitdefender.com>
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

The KVMI_INJECT_EXCEPTION command is used by the introspection tool to
inject exceptions (eg. get a page from swap). The exception is queued
right before entering the guest. If there is already an event pending
(exception, interrupt or NMI) we notify the introspection tool with the
KVMI_EVENT_TRAP event and abort the injection. The introspecion tool is
expected to try again at a later time.

CC: Joerg Roedel <joro@8bytes.org>
Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virtual/kvm/kvmi.rst |  71 +++++++++++++++++++
 arch/x86/include/uapi/asm/kvmi.h   |   8 +++
 arch/x86/kvm/kvmi.c                | 108 +++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c                 |  11 +++
 include/linux/kvmi.h               |   4 ++
 include/uapi/linux/kvmi.h          |   8 +++
 virt/kvm/kvmi.c                    |  40 +++++++++++
 virt/kvm/kvmi_int.h                |  16 +++++
 virt/kvm/kvmi_msg.c                |  21 ++++++
 9 files changed, 287 insertions(+)

diff --git a/Documentation/virtual/kvm/kvmi.rst b/Documentation/virtual/kvm/kvmi.rst
index 9e15132ed976..1eaed7c61148 100644
--- a/Documentation/virtual/kvm/kvmi.rst
+++ b/Documentation/virtual/kvm/kvmi.rst
@@ -969,6 +969,44 @@ Returns a CPUID leaf (as seen by the guest OS).
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
 * -KVM_ENOENT - the selected leaf is not present or is invalid
 
+20. KVMI_INJECT_EXCEPTION
+-------------------------
+
+:Architectures: x86
+:Versions: >= 1
+:Parameters:
+
+::
+
+	struct kvmi_vcpu_hdr;
+	struct kvmi_inject_exception {
+		__u8 nr;
+		__u8 has_error;
+		__u16 padding;
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
+order to be notified if the expection was not delivered.
+
+:Errors:
+
+* -KVM_EINVAL - the selected vCPU is invalid
+* -KVM_EINVAL - the specified exception number is invalid
+* -KVM_EINVAL - the specified address is invalid
+* -KVM_EINVAL - padding is not zero
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+
 Events
 ======
 
@@ -1167,3 +1205,36 @@ cannot be disabled via *KVMI_CONTROL_EVENTS*.
 This event has a low priority. It will be sent after any other vCPU
 introspection event and when no vCPU introspection command is queued.
 
+5. KVMI_EVENT_TRAP
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
+		__u32 type;
+		__u32 error_code;
+		__u32 padding;
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
+This event is sent if a previous *KVMI_INJECT_EXCEPTION* command has
+been overwritten by an interrupt picked up during guest reentry and the
+introspection has been enabled for this event (see *KVMI_CONTROL_EVENTS*).
+
+``kvmi_event``, exception/interrupt number (vector), exception/interrupt
+type, exception code (``error_code``) and CR2 are sent to the introspector.
+
diff --git a/arch/x86/include/uapi/asm/kvmi.h b/arch/x86/include/uapi/asm/kvmi.h
index fa2719226198..b074ad735e84 100644
--- a/arch/x86/include/uapi/asm/kvmi.h
+++ b/arch/x86/include/uapi/asm/kvmi.h
@@ -26,6 +26,14 @@ struct kvmi_event_arch {
 	} msrs;
 };
 
+struct kvmi_event_trap {
+	__u32 vector;
+	__u32 type;
+	__u32 error_code;
+	__u32 padding;
+	__u64 cr2;
+};
+
 struct kvmi_get_registers {
 	__u16 nmsrs;
 	__u16 padding1;
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 4615bbe9c0db..8c18030d12f4 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -6,6 +6,7 @@
  */
 #include "x86.h"
 #include "cpuid.h"
+#include <asm/vmx.h>
 #include "../../../virt/kvm/kvmi_int.h"
 
 static void *alloc_get_registers_reply(const struct kvmi_msg_hdr *msg,
@@ -212,6 +213,87 @@ bool kvmi_arch_pf_event(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 	return ret;
 }
 
+bool kvmi_arch_queue_exception(struct kvm_vcpu *vcpu)
+{
+	if (!vcpu->arch.exception.injected &&
+	    !vcpu->arch.interrupt.injected &&
+	    !vcpu->arch.nmi_injected) {
+		struct kvmi_vcpu *ivcpu = IVCPU(vcpu);
+		struct x86_exception e = {
+			.vector = ivcpu->exception.nr,
+			.error_code_valid = ivcpu->exception.error_code_valid,
+			.error_code = ivcpu->exception.error_code,
+			.address = ivcpu->exception.address,
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
+static u32 kvmi_send_trap(struct kvm_vcpu *vcpu, u32 vector, u32 type,
+			  u32 error_code, u64 cr2)
+{
+	struct kvmi_event_trap e = {
+		.error_code = error_code,
+		.vector = vector,
+		.type = type,
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
+	u32 vector, type, err;
+	u32 action;
+
+	if (vcpu->arch.exception.injected) {
+		vector = vcpu->arch.exception.nr;
+		err = vcpu->arch.exception.error_code;
+
+		if (kvm_exception_is_soft(vector))
+			type = INTR_TYPE_SOFT_EXCEPTION;
+		else
+			type = INTR_TYPE_HARD_EXCEPTION;
+	} else if (vcpu->arch.interrupt.injected) {
+		vector = vcpu->arch.interrupt.nr;
+		err = 0;
+
+		if (vcpu->arch.interrupt.soft)
+			type = INTR_TYPE_SOFT_INTR;
+		else
+			type = INTR_TYPE_EXT_INTR;
+	} else {
+		vector = 0;
+		type = 0;
+		err = 0;
+	}
+
+	action = kvmi_send_trap(vcpu, vector, type, err, vcpu->arch.cr2);
+	switch (action) {
+	case KVMI_EVENT_ACTION_CONTINUE:
+		break;
+	default:
+		kvmi_handle_common_event_actions(vcpu, action, "TRAP");
+	}
+}
+
 int kvmi_arch_cmd_get_cpuid(struct kvm_vcpu *vcpu,
 			    const struct kvmi_get_cpuid *req,
 			    struct kvmi_get_cpuid_reply *rpl)
@@ -241,6 +323,32 @@ int kvmi_arch_cmd_get_vcpu_info(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static bool is_vector_valid(u8 vector)
+{
+	return true;
+}
+
+static bool is_gva_valid(struct kvm_vcpu *vcpu, u64 gva)
+{
+	return true;
+}
+
+int kvmi_arch_cmd_inject_exception(struct kvm_vcpu *vcpu, u8 vector,
+				   bool error_code_valid,
+				   u32 error_code, u64 address)
+{
+	if (!(is_vector_valid(vector) && is_gva_valid(vcpu, address)))
+		return -KVM_EINVAL;
+
+	IVCPU(vcpu)->exception.pending = true;
+	IVCPU(vcpu)->exception.nr = vector;
+	IVCPU(vcpu)->exception.error_code = error_code_valid ? error_code : 0;
+	IVCPU(vcpu)->exception.error_code_valid = error_code_valid;
+	IVCPU(vcpu)->exception.address = address;
+
+	return 0;
+}
+
 static const struct {
 	unsigned int allow_bit;
 	enum kvm_page_track_mode track_mode;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 62d15bbb2332..e38c0b95a0e7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7930,6 +7930,17 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		}
 	}
 
+	if (!kvmi_queue_exception(vcpu))
+		kvmi_trap_event(vcpu);
+	else if (vcpu->arch.exception.pending) {
+		kvm_x86_ops->queue_exception(vcpu);
+		if (exception_type(vcpu->arch.exception.nr) == EXCPT_FAULT)
+			__kvm_set_rflags(vcpu, kvm_get_rflags(vcpu) |
+						X86_EFLAGS_RF);
+		vcpu->arch.exception.pending = false;
+		vcpu->arch.exception.injected = true;
+	}
+
 	r = kvm_mmu_reload(vcpu);
 	if (unlikely(r)) {
 		goto cancel_injection;
diff --git a/include/linux/kvmi.h b/include/linux/kvmi.h
index 80c15b9195e4..5ae02c64fb33 100644
--- a/include/linux/kvmi.h
+++ b/include/linux/kvmi.h
@@ -16,6 +16,8 @@ int kvmi_ioctl_event(struct kvm *kvm, void __user *argp);
 int kvmi_ioctl_unhook(struct kvm *kvm, bool force_reset);
 int kvmi_vcpu_init(struct kvm_vcpu *vcpu);
 void kvmi_vcpu_uninit(struct kvm_vcpu *vcpu);
+bool kvmi_queue_exception(struct kvm_vcpu *vcpu);
+void kvmi_trap_event(struct kvm_vcpu *vcpu);
 void kvmi_handle_requests(struct kvm_vcpu *vcpu);
 void kvmi_init_emulate(struct kvm_vcpu *vcpu);
 void kvmi_activate_rep_complete(struct kvm_vcpu *vcpu);
@@ -29,6 +31,8 @@ static inline void kvmi_destroy_vm(struct kvm *kvm) { }
 static inline int kvmi_vcpu_init(struct kvm_vcpu *vcpu) { return 0; }
 static inline void kvmi_vcpu_uninit(struct kvm_vcpu *vcpu) { }
 static inline void kvmi_handle_requests(struct kvm_vcpu *vcpu) { }
+static inline bool kvmi_queue_exception(struct kvm_vcpu *vcpu) { return true; }
+static inline void kvmi_trap_event(struct kvm_vcpu *vcpu) { }
 static inline void kvmi_init_emulate(struct kvm_vcpu *vcpu) { }
 static inline void kvmi_activate_rep_complete(struct kvm_vcpu *vcpu) { }
 
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index ca9c6b6aeed5..a4583de5c2f6 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -215,6 +215,14 @@ struct kvmi_vcpu_hdr {
 	__u32 padding2;
 };
 
+struct kvmi_inject_exception {
+	__u8 nr;
+	__u8 has_error;
+	__u16 padding;
+	__u32 error_code;
+	__u64 address;
+};
+
 struct kvmi_event {
 	__u16 size;
 	__u16 vcpu;
diff --git a/virt/kvm/kvmi.c b/virt/kvm/kvmi.c
index a20891d3a2ce..e3f308898a60 100644
--- a/virt/kvm/kvmi.c
+++ b/virt/kvm/kvmi.c
@@ -1058,6 +1058,46 @@ void kvmi_activate_rep_complete(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL(kvmi_activate_rep_complete);
 
+/*
+ * This function returns false if there is an exception or interrupt pending.
+ * It returns true in all other cases including KVMI not being initialized.
+ */
+bool kvmi_queue_exception(struct kvm_vcpu *vcpu)
+{
+	struct kvmi *ikvm;
+	bool ret = true;
+
+	ikvm = kvmi_get(vcpu->kvm);
+	if (!ikvm)
+		return true;
+
+	if (!IVCPU(vcpu)->exception.pending)
+		goto out;
+
+	ret = kvmi_arch_queue_exception(vcpu);
+
+	memset(&IVCPU(vcpu)->exception, 0, sizeof(IVCPU(vcpu)->exception));
+
+out:
+	kvmi_put(vcpu->kvm);
+
+	return ret;
+}
+
+void kvmi_trap_event(struct kvm_vcpu *vcpu)
+{
+	struct kvmi *ikvm;
+
+	ikvm = kvmi_get(vcpu->kvm);
+	if (!ikvm)
+		return;
+
+	if (is_event_enabled(vcpu, KVMI_EVENT_TRAP))
+		kvmi_arch_trap_event(vcpu);
+
+	kvmi_put(vcpu->kvm);
+}
+
 static bool __kvmi_create_vcpu_event(struct kvm_vcpu *vcpu)
 {
 	u32 action;
diff --git a/virt/kvm/kvmi_int.h b/virt/kvm/kvmi_int.h
index 22508d147495..2eadeb6efde8 100644
--- a/virt/kvm/kvmi_int.h
+++ b/virt/kvm/kvmi_int.h
@@ -105,6 +105,14 @@ struct kvmi_vcpu {
 	bool reply_waiting;
 	struct kvmi_vcpu_reply reply;
 
+	struct {
+		u8 nr;
+		u32 error_code;
+		bool error_code_valid;
+		u64 address;
+		bool pending;
+	} exception;
+
 	bool have_delayed_regs;
 	struct kvm_regs delayed_regs;
 
@@ -165,6 +173,9 @@ bool kvmi_sock_get(struct kvmi *ikvm, int fd);
 void kvmi_sock_shutdown(struct kvmi *ikvm);
 void kvmi_sock_put(struct kvmi *ikvm);
 bool kvmi_msg_process(struct kvmi *ikvm);
+int kvmi_send_event(struct kvm_vcpu *vcpu, u32 ev_id,
+		    void *ev, size_t ev_size,
+		    void *rpl, size_t rpl_size, int *action);
 u32 kvmi_msg_send_pf(struct kvm_vcpu *vcpu, u64 gpa, u64 gva, u8 access,
 		     bool *singlestep, bool *rep_complete,
 		     u64 *ctx_addr, u8 *ctx, u32 *ctx_size);
@@ -230,10 +241,15 @@ int kvmi_arch_cmd_set_page_write_bitmap(struct kvmi *ikvm,
 void kvmi_arch_setup_event(struct kvm_vcpu *vcpu, struct kvmi_event *ev);
 bool kvmi_arch_pf_event(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 			u8 access);
+bool kvmi_arch_queue_exception(struct kvm_vcpu *vcpu);
+void kvmi_arch_trap_event(struct kvm_vcpu *vcpu);
 int kvmi_arch_cmd_get_cpuid(struct kvm_vcpu *vcpu,
 			    const struct kvmi_get_cpuid *req,
 			    struct kvmi_get_cpuid_reply *rpl);
 int kvmi_arch_cmd_get_vcpu_info(struct kvm_vcpu *vcpu,
 				struct kvmi_get_vcpu_info_reply *rpl);
+int kvmi_arch_cmd_inject_exception(struct kvm_vcpu *vcpu, u8 vector,
+				   bool error_code_valid, u32 error_code,
+				   u64 address);
 
 #endif
diff --git a/virt/kvm/kvmi_msg.c b/virt/kvm/kvmi_msg.c
index 9548042de618..e80d28dbb061 100644
--- a/virt/kvm/kvmi_msg.c
+++ b/virt/kvm/kvmi_msg.c
@@ -36,6 +36,7 @@ static const char *const msg_IDs[] = {
 	[KVMI_GET_REGISTERS]         = "KVMI_GET_REGISTERS",
 	[KVMI_GET_VCPU_INFO]         = "KVMI_GET_VCPU_INFO",
 	[KVMI_GET_VERSION]           = "KVMI_GET_VERSION",
+	[KVMI_INJECT_EXCEPTION]      = "KVMI_INJECT_EXCEPTION",
 	[KVMI_PAUSE_VCPU]            = "KVMI_PAUSE_VCPU",
 	[KVMI_READ_PHYSICAL]         = "KVMI_READ_PHYSICAL",
 	[KVMI_SET_PAGE_ACCESS]       = "KVMI_SET_PAGE_ACCESS",
@@ -620,6 +621,25 @@ static int handle_set_registers(struct kvm_vcpu *vcpu,
 	return reply_cb(vcpu, msg, err, NULL, 0);
 }
 
+static int handle_inject_exception(struct kvm_vcpu *vcpu,
+				   const struct kvmi_msg_hdr *msg,
+				   const void *_req,
+				   vcpu_reply_fct reply_cb)
+{
+	const struct kvmi_inject_exception *req = _req;
+	int ec;
+
+	if (req->padding)
+		ec = -KVM_EINVAL;
+	else
+		ec = kvmi_arch_cmd_inject_exception(vcpu, req->nr,
+						    req->has_error,
+						    req->error_code,
+						    req->address);
+
+	return reply_cb(vcpu, msg, ec, NULL, 0);
+}
+
 static int handle_control_events(struct kvm_vcpu *vcpu,
 				 const struct kvmi_msg_hdr *msg,
 				 const void *_req,
@@ -670,6 +690,7 @@ static int(*const msg_vcpu[])(struct kvm_vcpu *,
 	[KVMI_GET_CPUID]        = handle_get_cpuid,
 	[KVMI_GET_REGISTERS]    = handle_get_registers,
 	[KVMI_GET_VCPU_INFO]    = handle_get_vcpu_info,
+	[KVMI_INJECT_EXCEPTION] = handle_inject_exception,
 	[KVMI_SET_REGISTERS]    = handle_set_registers,
 };
 
