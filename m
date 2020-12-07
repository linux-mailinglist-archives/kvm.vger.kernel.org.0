Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 158372D1B33
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 21:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727457AbgLGUsw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 15:48:52 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:42578 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727524AbgLGUsv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 15:48:51 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id EF5BE305D481;
        Mon,  7 Dec 2020 22:46:24 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id BC8B33072784;
        Mon,  7 Dec 2020 22:46:24 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v11 72/81] KVM: introspection: add KVMI_VCPU_CONTROL_MSR and KVMI_VCPU_EVENT_MSR
Date:   Mon,  7 Dec 2020 22:46:13 +0200
Message-Id: <20201207204622.15258-73-alazar@bitdefender.com>
In-Reply-To: <20201207204622.15258-1-alazar@bitdefender.com>
References: <20201207204622.15258-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

This command is used to enable/disable introspection for a specific
MSR. The KVMI_VCPU_EVENT_MSR event is sent when the tracked MSR is going
to be changed. The introspection tool can respond by allowing the guest
to continue with normal execution or by discarding the change.

This is meant to prevent malicious changes to MSRs
such as MSR_IA32_SYSENTER_EIP.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Nicușor Cîțu <nicu.citu@icloud.com>
Signed-off-by: Nicușor Cîțu <nicu.citu@icloud.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               |  79 +++++++++++
 arch/x86/include/asm/kvmi_host.h              |  12 ++
 arch/x86/include/uapi/asm/kvmi.h              |  18 +++
 arch/x86/kvm/kvmi.c                           | 125 ++++++++++++++++++
 arch/x86/kvm/kvmi.h                           |   3 +
 arch/x86/kvm/kvmi_msg.c                       |  52 ++++++++
 arch/x86/kvm/x86.c                            |   3 +
 include/uapi/linux/kvmi.h                     |   2 +
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 111 ++++++++++++++++
 9 files changed, 405 insertions(+)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 2bfb2bf0e778..7220f27ea5c3 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -542,6 +542,7 @@ the following events::
 	KVMI_VCPU_EVENT_CR
 	KVMI_VCPU_EVENT_DESCRIPTOR
 	KVMI_VCPU_EVENT_HYPERCALL
+	KVMI_VCPU_EVENT_MSR
 	KVMI_VCPU_EVENT_XSETBV
 
 When an event is enabled, the introspection tool is notified and
@@ -922,6 +923,48 @@ Returns the guest memory type for a specific guest physical address (``gpa``).
 * -KVM_EINVAL - the padding is not zero
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
 
+22. KVMI_VCPU_CONTROL_MSR
+-------------------------
+
+:Architectures: x86
+:Versions: >= 1
+:Parameters:
+
+::
+
+	struct kvmi_vcpu_hdr;
+	struct kvmi_vcpu_control_msr {
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
+in addition to *KVMI_VCPU_CONTROL_EVENTS* with the *KVMI_VCPU_EVENT_MSR*
+ID set.
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
+* -KVM_EINVAL - the padding is not zero
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+* -KVM_EPERM  - the interception of the selected MSR is disallowed
+                from userspace (KVM_X86_SET_MSR_FILTER)
+
 Events
 ======
 
@@ -1260,3 +1303,39 @@ introspection tool.
 	KVMI_DESC_TR
 
 ``write`` is 1 if the descriptor was written, 0 otherwise.
+
+9. KVMI_VCPU_EVENT_MSR
+----------------------
+
+:Architectures: x86
+:Versions: >= 1
+:Actions: CONTINUE, CRASH
+:Parameters:
+
+::
+
+	struct kvmi_vcpu_event;
+	struct kvmi_vcpu_event_msr {
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
+	struct kvmi_vcpu_event_reply;
+	struct kvmi_vcpu_event_msr_reply {
+		__u64 new_val;
+	};
+
+This event is sent when a model specific register is going to be changed
+and the introspection has been enabled for this event and for this specific
+register (see **KVMI_VCPU_CONTROL_EVENTS**).
+
+``kvmi_vcpu_event`` (with the vCPU state), the MSR number (``msr``),
+the old value (``old_value``) and the new value (``new_value``) are sent
+to the introspection tool. The *CONTINUE* action will set the ``new_val``.
diff --git a/arch/x86/include/asm/kvmi_host.h b/arch/x86/include/asm/kvmi_host.h
index a872277eba67..5a4fc5b80907 100644
--- a/arch/x86/include/asm/kvmi_host.h
+++ b/arch/x86/include/asm/kvmi_host.h
@@ -4,7 +4,10 @@
 
 #include <asm/kvmi.h>
 
+struct msr_data;
+
 #define KVMI_NUM_CR 5
+#define KVMI_NUM_MSR 0x2000
 
 struct kvmi_monitor_interception {
 	bool kvmi_intercepted;
@@ -18,6 +21,12 @@ struct kvmi_interception {
 	struct kvmi_monitor_interception breakpoint;
 	struct kvmi_monitor_interception cr3w;
 	struct kvmi_monitor_interception descriptor;
+	struct {
+		struct {
+			DECLARE_BITMAP(low, KVMI_NUM_MSR);
+			DECLARE_BITMAP(high, KVMI_NUM_MSR);
+		} kvmi_mask;
+	} msrw;
 };
 
 struct kvm_vcpu_arch_introspection {
@@ -51,6 +60,7 @@ void kvmi_xsetbv_event(struct kvm_vcpu *vcpu, u8 xcr,
 		       u64 old_value, u64 new_value);
 bool kvmi_monitor_desc_intercept(struct kvm_vcpu *vcpu, bool enable);
 bool kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor, bool write);
+bool kvmi_msr_event(struct kvm_vcpu *vcpu, struct msr_data *msr);
 
 #else /* CONFIG_KVM_INTROSPECTION */
 
@@ -70,6 +80,8 @@ static inline bool kvmi_monitor_desc_intercept(struct kvm_vcpu *vcpu,
 					       bool enable) { return false; }
 static inline bool kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor,
 					 bool write) { return true; }
+static inline bool kvmi_msr_event(struct kvm_vcpu *vcpu, struct msr_data *msr)
+				{ return true; }
 
 #endif /* CONFIG_KVM_INTROSPECTION */
 
diff --git a/arch/x86/include/uapi/asm/kvmi.h b/arch/x86/include/uapi/asm/kvmi.h
index 9c608ef5daa3..6ef144ddb4bb 100644
--- a/arch/x86/include/uapi/asm/kvmi.h
+++ b/arch/x86/include/uapi/asm/kvmi.h
@@ -141,4 +141,22 @@ struct kvmi_vcpu_event_descriptor {
 	__u8 padding[6];
 };
 
+struct kvmi_vcpu_control_msr {
+	__u8 enable;
+	__u8 padding1;
+	__u16 padding2;
+	__u32 msr;
+};
+
+struct kvmi_vcpu_event_msr {
+	__u32 msr;
+	__u32 padding;
+	__u64 old_value;
+	__u64 new_value;
+};
+
+struct kvmi_vcpu_event_msr_reply {
+	__u64 new_val;
+};
+
 #endif /* _UAPI_ASM_X86_KVMI_H */
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 4106ae63a115..ce29e01ba7a6 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -16,6 +16,7 @@ void kvmi_arch_init_vcpu_events_mask(unsigned long *supported)
 	set_bit(KVMI_VCPU_EVENT_CR, supported);
 	set_bit(KVMI_VCPU_EVENT_HYPERCALL, supported);
 	set_bit(KVMI_VCPU_EVENT_DESCRIPTOR, supported);
+	set_bit(KVMI_VCPU_EVENT_MSR, supported);
 	set_bit(KVMI_VCPU_EVENT_TRAP, supported);
 	set_bit(KVMI_VCPU_EVENT_XSETBV, supported);
 }
@@ -344,6 +345,77 @@ static void kvmi_arch_disable_desc_intercept(struct kvm_vcpu *vcpu)
 	vcpu->arch.kvmi->descriptor.kvm_intercepted = false;
 }
 
+static unsigned long *msr_mask(struct kvm_vcpu *vcpu, unsigned int *msr)
+{
+	switch (*msr) {
+	case 0 ... 0x1fff:
+		return vcpu->arch.kvmi->msrw.kvmi_mask.low;
+	case 0xc0000000 ... 0xc0001fff:
+		*msr &= 0x1fff;
+		return vcpu->arch.kvmi->msrw.kvmi_mask.high;
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
+
+	return !!test_bit(msr, mask);
+}
+
+static bool msr_control(struct kvm_vcpu *vcpu, unsigned int msr, bool enable)
+{
+	unsigned long *mask = msr_mask(vcpu, &msr);
+
+	if (!mask)
+		return false;
+
+	if (enable)
+		set_bit(msr, mask);
+	else
+		clear_bit(msr, mask);
+
+	return true;
+}
+
+static unsigned int msr_mask_to_base(struct kvm_vcpu *vcpu, unsigned long *mask)
+{
+	if (mask == vcpu->arch.kvmi->msrw.kvmi_mask.high)
+		return 0xc0000000;
+
+	return 0;
+}
+
+void kvmi_control_msrw_intercept(struct kvm_vcpu *vcpu, u32 msr, bool enable)
+{
+	kvm_x86_ops.control_msr_intercept(vcpu, msr, MSR_TYPE_W, enable);
+	msr_control(vcpu, msr, enable);
+}
+
+static void kvmi_arch_disable_msr_intercept(struct kvm_vcpu *vcpu,
+					    unsigned long *mask)
+{
+	unsigned int msr_base = msr_mask_to_base(vcpu, mask);
+	int offset = -1;
+
+	for (;;) {
+		offset = find_next_bit(mask, KVMI_NUM_MSR, offset + 1);
+
+		if (offset >= KVMI_NUM_MSR)
+			break;
+
+		kvm_x86_ops.control_msr_intercept(vcpu, msr_base + offset,
+						   MSR_TYPE_W, false);
+	}
+
+	bitmap_zero(mask, KVMI_NUM_MSR);
+}
+
 int kvmi_arch_cmd_control_intercept(struct kvm_vcpu *vcpu,
 				    unsigned int event_id, bool enable)
 {
@@ -385,9 +457,13 @@ void kvmi_arch_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva, u8 insn_len)
 
 static void kvmi_arch_restore_interception(struct kvm_vcpu *vcpu)
 {
+	struct kvmi_interception *arch_vcpui = vcpu->arch.kvmi;
+
 	kvmi_arch_disable_bp_intercept(vcpu);
 	kvmi_arch_disable_cr3w_intercept(vcpu);
 	kvmi_arch_disable_desc_intercept(vcpu);
+	kvmi_arch_disable_msr_intercept(vcpu, arch_vcpui->msrw.kvmi_mask.low);
+	kvmi_arch_disable_msr_intercept(vcpu, arch_vcpui->msrw.kvmi_mask.high);
 }
 
 bool kvmi_arch_clean_up_interception(struct kvm_vcpu *vcpu)
@@ -700,3 +776,52 @@ bool kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor, bool write)
 	return ret;
 }
 EXPORT_SYMBOL(kvmi_descriptor_event);
+
+static bool __kvmi_msr_event(struct kvm_vcpu *vcpu, struct msr_data *msr)
+{
+	struct msr_data old_msr = {
+		.host_initiated = true,
+		.index = msr->index,
+	};
+	u64 reply_value;
+	u32 action;
+	bool ret;
+
+	if (!test_msr_mask(vcpu, msr->index))
+		return true;
+	if (kvm_x86_ops.get_msr(vcpu, &old_msr))
+		return true;
+	if (old_msr.data == msr->data)
+		return true;
+
+	action = kvmi_msg_send_vcpu_msr(vcpu, msr->index, old_msr.data,
+					msr->data, &reply_value);
+	switch (action) {
+	case KVMI_EVENT_ACTION_CONTINUE:
+		msr->data = reply_value;
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
+bool kvmi_msr_event(struct kvm_vcpu *vcpu, struct msr_data *msr)
+{
+	struct kvm_introspection *kvmi;
+	bool ret = true;
+
+	kvmi = kvmi_get(vcpu->kvm);
+	if (!kvmi)
+		return true;
+
+	if (is_vcpu_event_enabled(vcpu, KVMI_VCPU_EVENT_MSR))
+		ret = __kvmi_msr_event(vcpu, msr);
+
+	kvmi_put(vcpu->kvm);
+
+	return ret;
+}
diff --git a/arch/x86/kvm/kvmi.h b/arch/x86/kvm/kvmi.h
index 92422e2e57cf..6483edbb80c5 100644
--- a/arch/x86/kvm/kvmi.h
+++ b/arch/x86/kvm/kvmi.h
@@ -17,5 +17,8 @@ u32 kvmi_msg_send_vcpu_trap(struct kvm_vcpu *vcpu);
 u32 kvmi_msg_send_vcpu_xsetbv(struct kvm_vcpu *vcpu, u8 xcr,
 			      u64 old_value, u64 new_value);
 u32 kvmi_msg_send_vcpu_descriptor(struct kvm_vcpu *vcpu, u8 desc, bool write);
+void kvmi_control_msrw_intercept(struct kvm_vcpu *vcpu, u32 msr, bool enable);
+u32 kvmi_msg_send_vcpu_msr(struct kvm_vcpu *vcpu, u32 msr, u64 old_value,
+			   u64 new_value, u64 *ret_value);
 
 #endif
diff --git a/arch/x86/kvm/kvmi_msg.c b/arch/x86/kvm/kvmi_msg.c
index f0b4016820ce..6d45b1c49184 100644
--- a/arch/x86/kvm/kvmi_msg.c
+++ b/arch/x86/kvm/kvmi_msg.c
@@ -248,8 +248,36 @@ static int handle_vcpu_get_mtrr_type(const struct kvmi_vcpu_msg_job *job,
 	return kvmi_msg_vcpu_reply(job, msg, 0, &rpl, sizeof(rpl));
 }
 
+static bool is_valid_msr(unsigned int msr)
+{
+	return msr <= 0x1fff || (msr >= 0xc0000000 && msr <= 0xc0001fff);
+}
+
+static int handle_vcpu_control_msr(const struct kvmi_vcpu_msg_job *job,
+				   const struct kvmi_msg_hdr *msg,
+				   const void *_req)
+{
+	const struct kvmi_vcpu_control_msr *req = _req;
+	int ec = 0;
+
+	if (req->padding1 || req->padding2 || req->enable > 1)
+		ec = -KVM_EINVAL;
+	else if (!is_valid_msr(req->msr))
+		ec = -KVM_EINVAL;
+	else if (req->enable &&
+		 !kvm_msr_allowed(job->vcpu, req->msr,
+				  KVM_MSR_FILTER_WRITE))
+		ec = -KVM_EPERM;
+	else
+		kvmi_control_msrw_intercept(job->vcpu, req->msr,
+					    req->enable == 1);
+
+	return kvmi_msg_vcpu_reply(job, msg, ec, NULL, 0);
+}
+
 static kvmi_vcpu_msg_job_fct const msg_vcpu[] = {
 	[KVMI_VCPU_CONTROL_CR]       = handle_vcpu_control_cr,
+	[KVMI_VCPU_CONTROL_MSR]      = handle_vcpu_control_msr,
 	[KVMI_VCPU_GET_CPUID]        = handle_vcpu_get_cpuid,
 	[KVMI_VCPU_GET_INFO]         = handle_vcpu_get_info,
 	[KVMI_VCPU_GET_MTRR_TYPE]    = handle_vcpu_get_mtrr_type,
@@ -349,3 +377,27 @@ u32 kvmi_msg_send_vcpu_descriptor(struct kvm_vcpu *vcpu, u8 desc, bool write)
 	return action;
 
 }
+
+u32 kvmi_msg_send_vcpu_msr(struct kvm_vcpu *vcpu, u32 msr, u64 old_value,
+			   u64 new_value, u64 *ret_value)
+{
+	struct kvmi_vcpu_event_msr e;
+	struct kvmi_vcpu_event_msr_reply r;
+	int err, action;
+
+	memset(&e, 0, sizeof(e));
+	e.msr = msr;
+	e.old_value = old_value;
+	e.new_value = new_value;
+
+	err = kvmi_send_vcpu_event(vcpu, KVMI_VCPU_EVENT_MSR, &e, sizeof(e),
+				   &r, sizeof(r), &action);
+	if (err) {
+		action = KVMI_EVENT_ACTION_CONTINUE;
+		*ret_value = new_value;
+	} else {
+		*ret_value = r.new_val;
+	}
+
+	return action;
+}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7a1cd14b0a87..381e3dfba535 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1585,6 +1585,9 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 	msr.index = index;
 	msr.host_initiated = host_initiated;
 
+	if (!host_initiated && !kvmi_msr_event(vcpu, &msr))
+		return 1;
+
 	return kvm_x86_ops.set_msr(vcpu, &msr);
 }
 
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 09f78c0efc4f..c8e7f4516379 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -48,6 +48,7 @@ enum {
 	KVMI_VCPU_GET_XSAVE        = KVMI_VCPU_MESSAGE_ID(9),
 	KVMI_VCPU_SET_XSAVE        = KVMI_VCPU_MESSAGE_ID(10),
 	KVMI_VCPU_GET_MTRR_TYPE    = KVMI_VCPU_MESSAGE_ID(11),
+	KVMI_VCPU_CONTROL_MSR      = KVMI_VCPU_MESSAGE_ID(12),
 
 	KVMI_NEXT_VCPU_MESSAGE
 };
@@ -69,6 +70,7 @@ enum {
 	KVMI_VCPU_EVENT_TRAP       = KVMI_VCPU_EVENT_ID(4),
 	KVMI_VCPU_EVENT_XSETBV     = KVMI_VCPU_EVENT_ID(5),
 	KVMI_VCPU_EVENT_DESCRIPTOR = KVMI_VCPU_EVENT_ID(6),
+	KVMI_VCPU_EVENT_MSR        = KVMI_VCPU_EVENT_ID(7),
 
 	KVMI_NEXT_VCPU_EVENT
 };
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index d26df3a9ffff..2e07b22bc8c0 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -60,6 +60,7 @@ enum {
 	GUEST_TEST_CR,
 	GUEST_TEST_DESCRIPTOR,
 	GUEST_TEST_HYPERCALL,
+	GUEST_TEST_MSR,
 	GUEST_TEST_XSETBV,
 };
 
@@ -104,6 +105,15 @@ static void guest_hypercall_test(void)
 	asm volatile(".byte 0x0f,0x01,0xc1");
 }
 
+static void guest_msr_test(void)
+{
+	uint64_t msr;
+
+	msr = rdmsr(MSR_MISC_FEATURES_ENABLES);
+	msr |= 1; /* MSR_MISC_FEATURES_ENABLES_CPUID_FAULT */
+	wrmsr(MSR_MISC_FEATURES_ENABLES, msr);
+}
+
 /* from fpu/internal.h */
 static u64 xgetbv(u32 index)
 {
@@ -161,6 +171,9 @@ static void guest_code(void)
 		case GUEST_TEST_HYPERCALL:
 			guest_hypercall_test();
 			break;
+		case GUEST_TEST_MSR:
+			guest_msr_test();
+			break;
 		case GUEST_TEST_XSETBV:
 			guest_xsetbv_test();
 			break;
@@ -1579,6 +1592,103 @@ static void test_event_descriptor(struct kvm_vm *vm)
 	disable_vcpu_event(vm, event_id);
 }
 
+static void cmd_control_msr(struct kvm_vm *vm, __u32 msr, __u8 enable,
+			    int expected_err)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vcpu_hdr vcpu_hdr;
+		struct kvmi_vcpu_control_msr cmd;
+	} req = {};
+
+	req.cmd.msr = msr;
+	req.cmd.enable = enable;
+
+	test_vcpu0_command(vm, KVMI_VCPU_CONTROL_MSR, &req.hdr, sizeof(req),
+			     NULL, 0, expected_err);
+}
+
+static void enable_msr_events(struct kvm_vm *vm, __u32 msr)
+{
+	enable_vcpu_event(vm, KVMI_VCPU_EVENT_MSR);
+	cmd_control_msr(vm, msr, 1, 0);
+}
+
+static void disable_msr_events(struct kvm_vm *vm, __u32 msr)
+{
+	cmd_control_msr(vm, msr, 0, 0);
+	disable_vcpu_event(vm, KVMI_VCPU_EVENT_MSR);
+}
+
+static void handle_msr_event(struct kvm_vm *vm, __u16 event_id, __u32 msr,
+			     __u64 *old_value)
+{
+	struct kvmi_msg_hdr hdr;
+	struct {
+		struct vcpu_event vcpu_ev;
+		struct kvmi_vcpu_event_msr msr;
+	} ev;
+	struct {
+		struct vcpu_reply common;
+		struct kvmi_vcpu_event_msr_reply msr;
+	} rpl = {};
+
+	receive_vcpu_event(&hdr, &ev.vcpu_ev, sizeof(ev), event_id);
+
+	pr_debug("MSR 0x%x, old 0x%llx, new 0x%llx\n",
+		 ev.msr.msr, ev.msr.old_value, ev.msr.new_value);
+
+	TEST_ASSERT(ev.msr.msr == msr,
+		"Unexpected MSR event, received MSR 0x%x, expected MSR 0x%x",
+		ev.msr.msr, msr);
+
+	*old_value = rpl.msr.new_val = ev.msr.old_value;
+
+	reply_to_event(&hdr, &ev.vcpu_ev, KVMI_EVENT_ACTION_CONTINUE,
+			&rpl.common, sizeof(rpl));
+}
+
+static void test_invalid_control_msr(struct kvm_vm *vm, __u32 msr)
+{
+	__u8 enable = 1, enable_inval = 2;
+	int expected_err = -KVM_EINVAL;
+	__u32 msr_inval = -1;
+
+	cmd_control_msr(vm, msr, enable_inval, expected_err);
+	cmd_control_msr(vm, msr_inval, enable, expected_err);
+}
+
+static void test_cmd_vcpu_control_msr(struct kvm_vm *vm)
+{
+	struct vcpu_worker_data data = {
+		.vm = vm,
+		.vcpu_id = VCPU_ID,
+		.test_id = GUEST_TEST_MSR,
+	};
+	__u16 event_id = KVMI_VCPU_EVENT_MSR;
+	__u32 msr = MSR_MISC_FEATURES_ENABLES;
+	pthread_t vcpu_thread;
+	uint64_t msr_data;
+	__u64 old_value;
+
+	enable_msr_events(vm, msr);
+
+	vcpu_thread = start_vcpu_worker(&data);
+
+	handle_msr_event(vm, event_id, msr, &old_value);
+
+	wait_vcpu_worker(vcpu_thread);
+
+	disable_msr_events(vm, msr);
+
+	msr_data = vcpu_get_msr(vm, VCPU_ID, msr);
+	TEST_ASSERT(msr_data == old_value,
+		"Failed to block MSR 0x%x update, value 0x%lx, expected 0x%llx",
+		msr, msr_data, old_value);
+
+	test_invalid_control_msr(vm, msr);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	srandom(time(0));
@@ -1610,6 +1720,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vcpu_xsave(vm);
 	test_cmd_vcpu_get_mtrr_type(vm);
 	test_event_descriptor(vm);
+	test_cmd_vcpu_control_msr(vm);
 
 	unhook_introspection(vm);
 }
