Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53BBD155D90
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727865AbgBGSQ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:16:59 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40728 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727732AbgBGSQ5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:57 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id C64A1305D363;
        Fri,  7 Feb 2020 20:16:41 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id B3347305207B;
        Fri,  7 Feb 2020 20:16:41 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v7 69/78] KVM: introspection: add KVMI_VCPU_CONTROL_MSR and KVMI_EVENT_MSR
Date:   Fri,  7 Feb 2020 20:16:27 +0200
Message-Id: <20200207181636.1065-70-alazar@bitdefender.com>
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

This command is used to enable/disable introspection for a specific
MSR. The KVMI_EVENT_MSR event is send when the tracked MSR is going to
be changed. The introspection tool can respond by allowing the guest to
continue with normal execution or by discarding the change.

This is meant to prevent malicious changes to MSRs
such as MSR_IA32_SYSENTER_EIP.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               |  75 ++++++++
 arch/x86/include/asm/kvmi_host.h              |  12 ++
 arch/x86/include/uapi/asm/kvmi.h              |  18 ++
 arch/x86/kvm/kvmi.c                           | 163 ++++++++++++++++++
 arch/x86/kvm/x86.c                            |   3 +
 include/uapi/linux/kvmi.h                     |   2 +
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 102 +++++++++++
 virt/kvm/introspection/kvmi_int.h             |   4 +
 virt/kvm/introspection/kvmi_msg.c             |  13 ++
 9 files changed, 392 insertions(+)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 0a0e5305a0af..4930a84200fc 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -534,6 +534,7 @@ the following events::
 	KVMI_EVENT_CR
 	KVMI_EVENT_DESCRIPTOR
 	KVMI_EVENT_HYPERCALL
+	KVMI_EVENT_MSR
 	KVMI_EVENT_TRAP
 	KVMI_EVENT_XSETBV
 
@@ -820,6 +821,45 @@ Returns the guest memory type for a specific physical address.
 * -KVM_EINVAL - padding is not zero
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
 
+19. KVMI_VCPU_CONTROL_MSR
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
+in addition to *KVMI_VCPU_CONTROL_EVENTS* with the *KVMI_EVENT_MSR* ID set.
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
 
@@ -1127,3 +1167,38 @@ introspection has been enabled for this event (see **KVMI_VCPU_CONTROL_EVENTS**)
 	KVMI_DESC_TR
 
 ``write`` is 1 if the descriptor was written, 0 otherwise.
+
+9. KVMI_EVENT_MSR
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
+register (see **KVMI_VCPU_CONTROL_EVENTS**).
+
+``kvmi_event``, the MSR number, the old value and the new value are
+sent to the introspection tool. The *CONTINUE* action will set the ``new_val``.
diff --git a/arch/x86/include/asm/kvmi_host.h b/arch/x86/include/asm/kvmi_host.h
index 10b251856c0e..f9aaff45d082 100644
--- a/arch/x86/include/asm/kvmi_host.h
+++ b/arch/x86/include/asm/kvmi_host.h
@@ -2,7 +2,10 @@
 #ifndef _ASM_X86_KVMI_HOST_H
 #define _ASM_X86_KVMI_HOST_H
 
+struct msr_data;
+
 #define KVMI_NUM_CR 5
+#define KVMI_NUM_MSR 0x2000
 
 struct kvmi_monitor_interception {
 	bool kvmi_intercepted;
@@ -15,6 +18,12 @@ struct kvmi_interception {
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
@@ -34,6 +43,7 @@ bool kvmi_monitor_cr3w_intercept(struct kvm_vcpu *vcpu, bool enable);
 void kvmi_xsetbv_event(struct kvm_vcpu *vcpu);
 bool kvmi_monitor_desc_intercept(struct kvm_vcpu *vcpu, bool enable);
 bool kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor, u8 write);
+bool kvmi_msr_event(struct kvm_vcpu *vcpu, struct msr_data *msr);
 
 #else /* CONFIG_KVM_INTROSPECTION */
 
@@ -50,6 +60,8 @@ static inline bool kvmi_monitor_desc_intercept(struct kvm_vcpu *vcpu,
 					       bool enable) { return false; }
 static inline bool kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor,
 					 u8 write) { return true; }
+static inline bool kvmi_msr_event(struct kvm_vcpu *vcpu, struct msr_data *msr)
+				{ return true; }
 
 #endif /* CONFIG_KVM_INTROSPECTION */
 
diff --git a/arch/x86/include/uapi/asm/kvmi.h b/arch/x86/include/uapi/asm/kvmi.h
index 6f411b9ba449..f4be7d12f63a 100644
--- a/arch/x86/include/uapi/asm/kvmi.h
+++ b/arch/x86/include/uapi/asm/kvmi.h
@@ -121,4 +121,22 @@ struct kvmi_event_descriptor {
 	__u8 padding[6];
 };
 
+struct kvmi_vcpu_control_msr {
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
index 048f0e1f9f79..7705ac155c84 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -369,6 +369,72 @@ static void kvmi_arch_disable_desc_intercept(struct kvm_vcpu *vcpu)
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
+static void kvmi_arch_disable_msr_intercept(struct kvm_vcpu *vcpu,
+					    unsigned long *mask)
+{
+	int offset = -1;
+	unsigned int msr_base = msr_mask_to_base(vcpu, mask);
+
+	for (;;) {
+		offset = find_next_bit(mask, KVMI_NUM_MSR, offset + 1);
+
+		if (offset >= KVMI_NUM_MSR)
+			break;
+
+		kvm_x86_ops->control_msr_intercept(vcpu, msr_base + offset,
+						   MSR_TYPE_W, false);
+		msr_control(vcpu, msr_base + offset, false);
+	}
+
+	bitmap_zero(mask, KVMI_NUM_MSR);
+}
+
 int kvmi_arch_cmd_control_intercept(struct kvm_vcpu *vcpu,
 				    unsigned int event_id, bool enable)
 {
@@ -418,6 +484,8 @@ bool kvmi_arch_restore_interception(struct kvm_vcpu *vcpu)
 	kvmi_arch_disable_bp_intercept(vcpu);
 	kvmi_arch_disable_cr3w_intercept(vcpu);
 	kvmi_arch_disable_desc_intercept(vcpu);
+	kvmi_arch_disable_msr_intercept(vcpu, arch_vcpui->msrw.kvmi_mask.low);
+	kvmi_arch_disable_msr_intercept(vcpu, arch_vcpui->msrw.kvmi_mask.high);
 
 	return true;
 }
@@ -746,3 +814,98 @@ bool kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor, u8 write)
 	return ret;
 }
 EXPORT_SYMBOL(kvmi_descriptor_event);
+
+static bool kvmi_msr_valid(unsigned int msr)
+{
+	if ((msr < 0x1fff) || ((msr > 0xc0000000) && (msr < 0xc0001fff)))
+		return true;
+
+	return false;
+}
+
+
+int kvmi_arch_cmd_vcpu_control_msr(struct kvm_vcpu *vcpu,
+				   const struct kvmi_vcpu_control_msr *req)
+{
+	if (req->padding1 || req->padding2)
+		return -KVM_EINVAL;
+
+	if (!kvmi_msr_valid(req->msr))
+		return -KVM_EINVAL;
+
+	kvm_x86_ops->control_msr_intercept(vcpu, req->msr, MSR_TYPE_W,
+					   req->enable);
+	msr_control(vcpu, req->msr, req->enable);
+
+	return 0;
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
+	if (kvm_x86_ops->get_msr(vcpu, &old_msr))
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
+		kvmi_handle_common_event_actions(vcpu->kvm, action, "MSR");
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
+	if (is_event_enabled(vcpu, KVMI_EVENT_MSR))
+		ret = __kvmi_msr_event(vcpu, msr);
+
+	kvmi_put(vcpu->kvm);
+
+	return ret;
+}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fa583f82298e..5d6ac6c99246 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1470,6 +1470,9 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 	msr.index = index;
 	msr.host_initiated = host_initiated;
 
+	if (!host_initiated && !kvmi_msr_event(vcpu, &msr))
+		return 1;
+
 	return kvm_x86_ops->set_msr(vcpu, &msr);
 }
 
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index a8f5dc415e3d..2d37d407f65d 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -39,6 +39,7 @@ enum {
 
 	KVMI_VCPU_GET_XSAVE     = 18,
 	KVMI_VCPU_GET_MTRR_TYPE = 19,
+	KVMI_VCPU_CONTROL_MSR   = 20,
 
 	KVMI_NUM_MESSAGES
 };
@@ -52,6 +53,7 @@ enum {
 	KVMI_EVENT_TRAP       = 5,
 	KVMI_EVENT_XSETBV     = 6,
 	KVMI_EVENT_DESCRIPTOR = 7,
+	KVMI_EVENT_MSR        = 8,
 
 	KVMI_NUM_EVENTS
 };
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 4308cb995ce3..7bf2b64b62a3 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -56,6 +56,7 @@ enum {
 	GUEST_TEST_CR,
 	GUEST_TEST_DESCRIPTOR,
 	GUEST_TEST_HYPERCALL,
+	GUEST_TEST_MSR,
 	GUEST_TEST_XSETBV,
 };
 
@@ -96,6 +97,15 @@ static void guest_hypercall_test(void)
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
@@ -153,6 +163,9 @@ static void guest_code(void)
 		case GUEST_TEST_HYPERCALL:
 			guest_hypercall_test();
 			break;
+		case GUEST_TEST_MSR:
+			guest_msr_test();
+			break;
 		case GUEST_TEST_XSETBV:
 			guest_xsetbv_test();
 			break;
@@ -1419,6 +1432,94 @@ static void test_event_descriptor(struct kvm_vm *vm)
 	disable_vcpu_event(vm, event_id);
 }
 
+static int cmd_control_msr(struct kvm_vm *vm, __u32 msr, bool enable)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vcpu_hdr vcpu_hdr;
+		struct kvmi_vcpu_control_msr cmd;
+	} req = {};
+
+	req.cmd.msr = msr;
+	req.cmd.enable = enable ? 1 : 0;
+
+	return do_vcpu0_command(vm, KVMI_VCPU_CONTROL_MSR,
+				&req.hdr, sizeof(req), NULL, 0);
+}
+
+static void enable_msr_events(struct kvm_vm *vm, __u32 msr)
+{
+	int r;
+
+	enable_vcpu_event(vm, KVMI_EVENT_MSR);
+
+	r = cmd_control_msr(vm, msr, true);
+	TEST_ASSERT(r == 0,
+		"KVMI_EVENT_MSR failed, error %d(%s)\n",
+		-r, kvm_strerror(-r));
+}
+
+static void disable_msr_events(struct kvm_vm *vm, __u32 msr)
+{
+	int r;
+
+	r = cmd_control_msr(vm, msr, false);
+	TEST_ASSERT(r == 0,
+		"KVMI_EVENT_MSR failed, error %d(%s)\n",
+		-r, kvm_strerror(-r));
+
+	disable_vcpu_event(vm, KVMI_EVENT_MSR);
+}
+
+static void test_cmd_vcpu_control_msr(struct kvm_vm *vm)
+{
+	struct vcpu_worker_data data = {
+		.vm = vm,
+		.vcpu_id = VCPU_ID,
+		.test_id = GUEST_TEST_MSR,
+	};
+	struct kvmi_msg_hdr hdr;
+	struct {
+		struct kvmi_event common;
+		struct kvmi_event_msr msr;
+	} ev;
+	struct {
+		struct vcpu_reply common;
+		struct kvmi_event_msr_reply msr;
+	} rpl = {};
+	__u16 event_id = KVMI_EVENT_MSR;
+	__u32 msr = MSR_MISC_FEATURES_ENABLES;
+	uint64_t msr_data;
+	pthread_t vcpu_thread;
+
+	enable_msr_events(vm, msr);
+
+	vcpu_thread = start_vcpu_worker(&data);
+
+	receive_event(&hdr, &ev.common, sizeof(ev), event_id);
+
+	DEBUG("MSR 0x%x, old 0x%llx, new 0x%llx\n",
+		ev.msr.msr, ev.msr.old_value, ev.msr.new_value);
+
+	TEST_ASSERT(ev.msr.msr == msr,
+		"Unexpected MSR event, received MSR 0x%x, expected MSR 0x%x",
+		ev.msr.msr, msr);
+
+	rpl.msr.new_val = ev.msr.old_value;
+
+	reply_to_event(&hdr, &ev.common, KVMI_EVENT_ACTION_CONTINUE,
+			&rpl.common, sizeof(rpl));
+
+	stop_vcpu_worker(vcpu_thread, &data);
+
+	disable_msr_events(vm, msr);
+
+	msr_data = vcpu_get_msr(vm, VCPU_ID, msr);
+	TEST_ASSERT(msr_data == ev.msr.old_value,
+		"Failed to block MSR 0x%x update, value 0x%x, expected 0x%x",
+		msr, msr_data, ev.msr.old_value);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	setup_socket();
@@ -1447,6 +1548,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vcpu_get_xsave(vm);
 	test_cmd_vcpu_get_mtrr_type(vm);
 	test_event_descriptor(vm);
+	test_cmd_vcpu_control_msr(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 6d2c09a12c49..33544dd9dce5 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -26,6 +26,7 @@
 			  | BIT(KVMI_EVENT_CR) \
 			  | BIT(KVMI_EVENT_DESCRIPTOR) \
 			  | BIT(KVMI_EVENT_HYPERCALL) \
+			  | BIT(KVMI_EVENT_MSR) \
 			  | BIT(KVMI_EVENT_TRAP) \
 			  | BIT(KVMI_EVENT_PAUSE_VCPU) \
 			  | BIT(KVMI_EVENT_XSETBV) \
@@ -46,6 +47,7 @@
 			| BIT(KVMI_VCPU_PAUSE) \
 			| BIT(KVMI_VCPU_CONTROL_CR) \
 			| BIT(KVMI_VCPU_CONTROL_EVENTS) \
+			| BIT(KVMI_VCPU_CONTROL_MSR) \
 			| BIT(KVMI_VCPU_GET_CPUID) \
 			| BIT(KVMI_VCPU_GET_MTRR_TYPE) \
 			| BIT(KVMI_VCPU_GET_REGISTERS) \
@@ -143,5 +145,7 @@ int kvmi_arch_cmd_vcpu_get_xsave(struct kvm_vcpu *vcpu,
 				 struct kvmi_vcpu_get_xsave_reply **dest,
 				 size_t *dest_size);
 int kvmi_arch_cmd_vcpu_get_mtrr_type(struct kvm_vcpu *vcpu, u64 gpa, u8 *type);
+int kvmi_arch_cmd_vcpu_control_msr(struct kvm_vcpu *vcpu,
+				   const struct kvmi_vcpu_control_msr *req);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index fed483bec936..a5250d9b9b3d 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -28,6 +28,7 @@ static const char *const msg_IDs[] = {
 	[KVMI_VM_WRITE_PHYSICAL]     = "KVMI_VM_WRITE_PHYSICAL",
 	[KVMI_VCPU_CONTROL_CR]       = "KVMI_VCPU_CONTROL_CR",
 	[KVMI_VCPU_CONTROL_EVENTS]   = "KVMI_VCPU_CONTROL_EVENTS",
+	[KVMI_VCPU_CONTROL_MSR]      = "KVMI_VCPU_CONTROL_MSR",
 	[KVMI_VCPU_GET_CPUID]        = "KVMI_VCPU_GET_CPUID",
 	[KVMI_VCPU_GET_INFO]         = "KVMI_VCPU_GET_INFO",
 	[KVMI_VCPU_GET_MTRR_TYPE]    = "KVMI_VCPU_GET_MTRR_TYPE",
@@ -558,6 +559,17 @@ static int handle_vcpu_get_mtrr_type(const struct kvmi_vcpu_cmd_job *job,
 	return kvmi_msg_vcpu_reply(job, msg, ec, &rpl, sizeof(rpl));
 }
 
+static int handle_vcpu_control_msr(const struct kvmi_vcpu_cmd_job *job,
+				   const struct kvmi_msg_hdr *msg,
+				   const void *req)
+{
+	int ec;
+
+	ec = kvmi_arch_cmd_vcpu_control_msr(job->vcpu, req);
+
+	return kvmi_msg_vcpu_reply(job, msg, ec, NULL, 0);
+}
+
 /*
  * These commands are executed on the vCPU thread. The receiving thread
  * passes the messages using a newly allocated 'struct kvmi_vcpu_cmd_job'
@@ -569,6 +581,7 @@ static int(*const msg_vcpu[])(const struct kvmi_vcpu_cmd_job *,
 	[KVMI_EVENT_REPLY]           = handle_event_reply,
 	[KVMI_VCPU_CONTROL_CR]       = handle_vcpu_control_cr,
 	[KVMI_VCPU_CONTROL_EVENTS]   = handle_vcpu_control_events,
+	[KVMI_VCPU_CONTROL_MSR]      = handle_vcpu_control_msr,
 	[KVMI_VCPU_GET_CPUID]        = handle_get_cpuid,
 	[KVMI_VCPU_GET_INFO]         = handle_get_vcpu_info,
 	[KVMI_VCPU_GET_MTRR_TYPE]    = handle_vcpu_get_mtrr_type,
