Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F54887F51
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437168AbfHIQPy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:15:54 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53078 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437061AbfHIQPG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:15:06 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 9723D301AB45;
        Fri,  9 Aug 2019 19:01:23 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 3B8DE305B7A3;
        Fri,  9 Aug 2019 19:01:23 +0300 (EEST)
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
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v6 55/92] kvm: introspection: add KVMI_CONTROL_MSR and KVMI_EVENT_MSR
Date:   Fri,  9 Aug 2019 19:00:10 +0300
Message-Id: <20190809160047.8319-56-alazar@bitdefender.com>
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

The KVMI_CONTROL_MSR is used to enable/disable introspection for a
specific MSR. The KVMI_EVENT_MSR is send when the tracked MSR is going
to be changed. The introspection tool can respond by allowing the guest
to continue with normal execution or by discarding the change.

This is meant to prevent malicious changes to MSR-s
such as MSR_IA32_SYSENTER_EIP.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virtual/kvm/kvmi.rst |  73 +++++++++++++++++
 arch/x86/include/asm/kvm_host.h    |   4 +
 arch/x86/include/asm/kvmi_host.h   |   6 ++
 arch/x86/include/uapi/asm/kvmi.h   |  18 ++++
 arch/x86/kvm/kvmi.c                | 127 +++++++++++++++++++++++++++++
 arch/x86/kvm/svm.c                 |  15 ++++
 arch/x86/kvm/vmx/vmx.c             |  10 +++
 arch/x86/kvm/x86.c                 |  10 +++
 virt/kvm/kvmi_int.h                |   8 +-
 virt/kvm/kvmi_msg.c                |  13 +++
 10 files changed, 283 insertions(+), 1 deletion(-)

diff --git a/Documentation/virtual/kvm/kvmi.rst b/Documentation/virtual/kvm/kvmi.rst
index 2e6e285c8e2e..c41c3edb0134 100644
--- a/Documentation/virtual/kvm/kvmi.rst
+++ b/Documentation/virtual/kvm/kvmi.rst
@@ -1042,6 +1042,45 @@ ID set.
 * -KVM_EINVAL - padding is not zero
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
 
+22. KVMI_CONTROL_MSR
+--------------------
+
+:Architectures: x86
+:Versions: >= 1
+:Parameters:
+
+::
+
+	struct kvmi_vcpu_hdr;
+	struct kvmi_control_msr {
+		__u8 enable;
+		__u8 padding1;
+		__u16 padding2;
+		__u32 msr;
+	};
+
+:Returns:
+
+::
+
+	struct kvmi_error_code
+
+Enables/disables introspection for a specific MSR and must be used
+in addition to *KVMI_CONTROL_EVENTS* with the *KVMI_EVENT_MSR* ID set.
+
+Currently, only MSRs within the following two ranges are supported. Trying
+to control events for any other register will fail with -KVM_EINVAL::
+
+	0          ... 0x00001fff
+	0xc0000000 ... 0xc0001fff
+
+:Errors:
+
+* -KVM_EINVAL - the selected vCPU is invalid
+* -KVM_EINVAL - the specified MSR is invalid
+* -KVM_EINVAL - padding is not zero
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+
 Events
 ======
 
@@ -1308,3 +1347,37 @@ register (see **KVMI_CONTROL_EVENTS**).
 ``kvmi_event``, the control register number, the old value and the new value
 are sent to the introspector. The *CONTINUE* action will set the ``new_val``.
 
+7. KVMI_EVENT_MSR
+-----------------
+
+:Architectures: x86
+:Versions: >= 1
+:Actions: CONTINUE, CRASH
+:Parameters:
+
+::
+
+	struct kvmi_event;
+	struct kvmi_event_msr {
+		__u32 msr;
+		__u32 padding;
+		__u64 old_value;
+		__u64 new_value;
+	};
+
+:Returns:
+
+::
+
+	struct kvmi_vcpu_hdr;
+	struct kvmi_event_reply;
+	struct kvmi_event_msr_reply {
+		__u64 new_val;
+	};
+
+This event is sent when a model specific register is going to be changed
+and the introspection has been enabled for this event and for this specific
+register (see **KVMI_CONTROL_EVENTS**).
+
+``kvmi_event``, the MSR number, the old value and the new value are
+sent to the introspector. The *CONTINUE* action will set the ``new_val``.
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 22f08f2732cc..91cd43a7a7bf 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1013,6 +1013,8 @@ struct kvm_x86_ops {
 	bool (*has_emulated_msr)(int index);
 	void (*cpuid_update)(struct kvm_vcpu *vcpu);
 
+	void (*msr_intercept)(struct kvm_vcpu *vcpu, unsigned int msr,
+				bool enable);
 	void (*cr3_write_exiting)(struct kvm_vcpu *vcpu, bool enable);
 	bool (*nested_pagefault)(struct kvm_vcpu *vcpu);
 	bool (*spt_fault)(struct kvm_vcpu *vcpu);
@@ -1621,6 +1623,8 @@ static inline int kvm_cpu_get_apicid(int mps_cpu)
 #define put_smstate(type, buf, offset, val)                      \
 	*(type *)((buf) + (offset) - 0x7e00) = val
 
+void kvm_arch_msr_intercept(struct kvm_vcpu *vcpu, unsigned int msr,
+				bool enable);
 bool kvm_mmu_nested_pagefault(struct kvm_vcpu *vcpu);
 bool kvm_spt_fault(struct kvm_vcpu *vcpu);
 void kvm_control_cr3_write_exiting(struct kvm_vcpu *vcpu, bool enable);
diff --git a/arch/x86/include/asm/kvmi_host.h b/arch/x86/include/asm/kvmi_host.h
index 83a098dc8939..8285d1eb0db6 100644
--- a/arch/x86/include/asm/kvmi_host.h
+++ b/arch/x86/include/asm/kvmi_host.h
@@ -11,11 +11,17 @@ struct kvmi_arch_mem_access {
 
 #ifdef CONFIG_KVM_INTROSPECTION
 
+bool kvmi_msr_event(struct kvm_vcpu *vcpu, struct msr_data *msr);
 bool kvmi_cr_event(struct kvm_vcpu *vcpu, unsigned int cr,
 		   unsigned long old_value, unsigned long *new_value);
 
 #else /* CONFIG_KVM_INTROSPECTION */
 
+static inline bool kvmi_msr_event(struct kvm_vcpu *vcpu, struct msr_data *msr)
+{
+	return true;
+}
+
 static inline bool kvmi_cr_event(struct kvm_vcpu *vcpu, unsigned int cr,
 				 unsigned long old_value,
 				 unsigned long *new_value)
diff --git a/arch/x86/include/uapi/asm/kvmi.h b/arch/x86/include/uapi/asm/kvmi.h
index c983b4bd2c72..08af2eccbdfb 100644
--- a/arch/x86/include/uapi/asm/kvmi.h
+++ b/arch/x86/include/uapi/asm/kvmi.h
@@ -79,4 +79,22 @@ struct kvmi_event_cr_reply {
 	__u64 new_val;
 };
 
+struct kvmi_control_msr {
+	__u8 enable;
+	__u8 padding1;
+	__u16 padding2;
+	__u32 msr;
+};
+
+struct kvmi_event_msr {
+	__u32 msr;
+	__u32 padding;
+	__u64 old_value;
+	__u64 new_value;
+};
+
+struct kvmi_event_msr_reply {
+	__u64 new_val;
+};
+
 #endif /* _UAPI_ASM_X86_KVMI_H */
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index b3cab0db6a70..5dba4f87afef 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -9,6 +9,133 @@
 #include <asm/vmx.h>
 #include "../../../virt/kvm/kvmi_int.h"
 
+static unsigned long *msr_mask(struct kvm_vcpu *vcpu, unsigned int *msr)
+{
+	switch (*msr) {
+	case 0 ... 0x1fff:
+		return IVCPU(vcpu)->msr_mask.low;
+	case 0xc0000000 ... 0xc0001fff:
+		*msr &= 0x1fff;
+		return IVCPU(vcpu)->msr_mask.high;
+	}
+
+	return NULL;
+}
+
+static bool test_msr_mask(struct kvm_vcpu *vcpu, unsigned int msr)
+{
+	unsigned long *mask = msr_mask(vcpu, &msr);
+
+	if (!mask)
+		return false;
+	if (!test_bit(msr, mask))
+		return false;
+
+	return true;
+}
+
+static int msr_control(struct kvm_vcpu *vcpu, unsigned int msr, bool enable)
+{
+	unsigned long *mask = msr_mask(vcpu, &msr);
+
+	if (!mask)
+		return -KVM_EINVAL;
+	if (enable)
+		set_bit(msr, mask);
+	else
+		clear_bit(msr, mask);
+	return 0;
+}
+
+int kvmi_arch_cmd_control_msr(struct kvm_vcpu *vcpu,
+			      const struct kvmi_control_msr *req)
+{
+	int err;
+
+	if (req->padding1 || req->padding2)
+		return -KVM_EINVAL;
+
+	err = msr_control(vcpu, req->msr, req->enable);
+
+	if (!err && req->enable)
+		kvm_arch_msr_intercept(vcpu, req->msr, req->enable);
+
+	return err;
+}
+
+static u32 kvmi_send_msr(struct kvm_vcpu *vcpu, u32 msr, u64 old_value,
+			 u64 new_value, u64 *ret_value)
+{
+	struct kvmi_event_msr e = {
+		.msr = msr,
+		.old_value = old_value,
+		.new_value = new_value,
+	};
+	struct kvmi_event_msr_reply r;
+	int err, action;
+
+	err = kvmi_send_event(vcpu, KVMI_EVENT_MSR, &e, sizeof(e),
+			      &r, sizeof(r), &action);
+	if (err) {
+		*ret_value = new_value;
+		return KVMI_EVENT_ACTION_CONTINUE;
+	}
+
+	*ret_value = r.new_val;
+	return action;
+}
+
+static bool __kvmi_msr_event(struct kvm_vcpu *vcpu, struct msr_data *msr)
+{
+	struct msr_data old_msr = {
+		.host_initiated = true,
+		.index = msr->index,
+	};
+	bool ret = false;
+	u64 ret_value;
+	u32 action;
+
+	if (!test_msr_mask(vcpu, msr->index))
+		return true;
+	if (kvm_get_msr(vcpu, &old_msr))
+		return true;
+	if (old_msr.data == msr->data)
+		return true;
+
+	action = kvmi_send_msr(vcpu, msr->index, old_msr.data, msr->data,
+			       &ret_value);
+	switch (action) {
+	case KVMI_EVENT_ACTION_CONTINUE:
+		msr->data = ret_value;
+		ret = true;
+		break;
+	default:
+		kvmi_handle_common_event_actions(vcpu, action, "MSR");
+	}
+
+	return ret;
+}
+
+bool kvmi_msr_event(struct kvm_vcpu *vcpu, struct msr_data *msr)
+{
+	struct kvmi *ikvm;
+	bool ret = true;
+
+	if (msr->host_initiated)
+		return true;
+
+	ikvm = kvmi_get(vcpu->kvm);
+	if (!ikvm)
+		return true;
+
+	if (is_event_enabled(vcpu, KVMI_EVENT_MSR))
+		ret = __kvmi_msr_event(vcpu, msr);
+
+	kvmi_put(vcpu->kvm);
+
+	return ret;
+}
+
 static void *alloc_get_registers_reply(const struct kvmi_msg_hdr *msg,
 				       const struct kvmi_get_registers *req,
 				       size_t *rpl_size)
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index fc78b0052dee..cdb315578979 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7098,6 +7098,20 @@ static int nested_enable_evmcs(struct kvm_vcpu *vcpu,
 	return -ENODEV;
 }
 
+static void svm_msr_intercept(struct kvm_vcpu *vcpu, unsigned int msr,
+				bool enable)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	u32 *msrpm = svm->msrpm;
+
+	/*
+	 * The below code enable or disable the msr interception for both
+	 * read and write. The best way will be to get here the current
+	 * bit status for read and send that value as argument.
+	 */
+	set_msr_interception(msrpm, msr, enable, enable);
+}
+
 static bool svm_nested_pagefault(struct kvm_vcpu *vcpu)
 {
 	return false;
@@ -7126,6 +7140,7 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.has_emulated_msr = svm_has_emulated_msr,
 
 	.cr3_write_exiting = svm_cr3_write_exiting,
+	.msr_intercept = svm_msr_intercept,
 	.nested_pagefault = svm_nested_pagefault,
 	.spt_fault = svm_spt_fault,
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6450c8c44771..0306c7ef3158 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7784,6 +7784,15 @@ static __exit void hardware_unsetup(void)
 	free_kvm_area();
 }
 
+static void vmx_msr_intercept(struct kvm_vcpu *vcpu, unsigned int msr,
+			      bool enable)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
+
+	vmx_set_intercept_for_msr(msr_bitmap, msr, MSR_TYPE_W, enable);
+}
+
 static void vmx_cr3_write_exiting(struct kvm_vcpu *vcpu,
 					 bool enable)
 {
@@ -7844,6 +7853,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.cpu_has_accelerated_tpr = report_flexpriority,
 	.has_emulated_msr = vmx_has_emulated_msr,
 
+	.msr_intercept = vmx_msr_intercept,
 	.cr3_write_exiting = vmx_cr3_write_exiting,
 	.nested_pagefault = vmx_nested_pagefault,
 	.spt_fault = vmx_spt_fault,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2cd146ccc6ff..ac027471c4f3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1319,6 +1319,9 @@ EXPORT_SYMBOL_GPL(kvm_enable_efer_bits);
  */
 int kvm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 {
+	if (!kvmi_msr_event(vcpu, msr))
+		return 1;
+
 	switch (msr->index) {
 	case MSR_FS_BASE:
 	case MSR_GS_BASE:
@@ -10083,6 +10086,13 @@ bool kvm_vector_hashing_enabled(void)
 }
 EXPORT_SYMBOL_GPL(kvm_vector_hashing_enabled);
 
+void kvm_arch_msr_intercept(struct kvm_vcpu *vcpu, unsigned int msr,
+				bool enable)
+{
+	kvm_x86_ops->msr_intercept(vcpu, msr, enable);
+}
+EXPORT_SYMBOL_GPL(kvm_arch_msr_intercept);
+
 void kvm_control_cr3_write_exiting(struct kvm_vcpu *vcpu, bool enable)
 {
 	kvm_x86_ops->cr3_write_exiting(vcpu, enable);
diff --git a/virt/kvm/kvmi_int.h b/virt/kvm/kvmi_int.h
index c92be3c2c131..640a78b54947 100644
--- a/virt/kvm/kvmi_int.h
+++ b/virt/kvm/kvmi_int.h
@@ -27,7 +27,7 @@
 #define IVCPU(vcpu) ((struct kvmi_vcpu *)((vcpu)->kvmi))
 
 #define KVMI_NUM_CR 9
-
+#define KVMI_NUM_MSR 0x2000
 #define KVMI_CTX_DATA_SIZE FIELD_SIZEOF(struct kvmi_event_pf_reply, ctx_data)
 
 #define KVMI_MSG_SIZE_ALLOC (sizeof(struct kvmi_msg_hdr) + KVMI_MSG_SIZE)
@@ -120,6 +120,10 @@ struct kvmi_vcpu {
 
 	DECLARE_BITMAP(ev_mask, KVMI_NUM_EVENTS);
 	DECLARE_BITMAP(cr_mask, KVMI_NUM_CR);
+	struct {
+		DECLARE_BITMAP(low, KVMI_NUM_MSR);
+		DECLARE_BITMAP(high, KVMI_NUM_MSR);
+	} msr_mask;
 
 	struct list_head job_list;
 	spinlock_t job_lock;
@@ -258,5 +262,7 @@ int kvmi_arch_cmd_inject_exception(struct kvm_vcpu *vcpu, u8 vector,
 				   u64 address);
 int kvmi_arch_cmd_control_cr(struct kvm_vcpu *vcpu,
 			     const struct kvmi_control_cr *req);
+int kvmi_arch_cmd_control_msr(struct kvm_vcpu *vcpu,
+			      const struct kvmi_control_msr *req);
 
 #endif
diff --git a/virt/kvm/kvmi_msg.c b/virt/kvm/kvmi_msg.c
index d4f5459722bb..8a8951f13f8e 100644
--- a/virt/kvm/kvmi_msg.c
+++ b/virt/kvm/kvmi_msg.c
@@ -26,6 +26,7 @@ static const char *const msg_IDs[] = {
 	[KVMI_CONTROL_CMD_RESPONSE]  = "KVMI_CONTROL_CMD_RESPONSE",
 	[KVMI_CONTROL_CR]            = "KVMI_CONTROL_CR",
 	[KVMI_CONTROL_EVENTS]        = "KVMI_CONTROL_EVENTS",
+	[KVMI_CONTROL_MSR]           = "KVMI_CONTROL_MSR",
 	[KVMI_CONTROL_SPP]           = "KVMI_CONTROL_SPP",
 	[KVMI_CONTROL_VM_EVENTS]     = "KVMI_CONTROL_VM_EVENTS",
 	[KVMI_EVENT]                 = "KVMI_EVENT",
@@ -674,6 +675,17 @@ static int handle_control_cr(struct kvm_vcpu *vcpu,
 	return reply_cb(vcpu, msg, ec, NULL, 0);
 }
 
+static int handle_control_msr(struct kvm_vcpu *vcpu,
+			      const struct kvmi_msg_hdr *msg, const void *req,
+			      vcpu_reply_fct reply_cb)
+{
+	int ec;
+
+	ec = kvmi_arch_cmd_control_msr(vcpu, req);
+
+	return reply_cb(vcpu, msg, ec, NULL, 0);
+}
+
 static int handle_get_cpuid(struct kvm_vcpu *vcpu,
 			    const struct kvmi_msg_hdr *msg,
 			    const void *req, vcpu_reply_fct reply_cb)
@@ -699,6 +711,7 @@ static int(*const msg_vcpu[])(struct kvm_vcpu *,
 			      vcpu_reply_fct) = {
 	[KVMI_CONTROL_CR]       = handle_control_cr,
 	[KVMI_CONTROL_EVENTS]   = handle_control_events,
+	[KVMI_CONTROL_MSR]      = handle_control_msr,
 	[KVMI_EVENT_REPLY]      = handle_event_reply,
 	[KVMI_GET_CPUID]        = handle_get_cpuid,
 	[KVMI_GET_REGISTERS]    = handle_get_registers,
