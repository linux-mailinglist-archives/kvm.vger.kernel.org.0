Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE26619792B
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729409AbgC3KTz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:19:55 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:43750 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728864AbgC3KTx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 06:19:53 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id E4A22305D3CE;
        Mon, 30 Mar 2020 13:13:00 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id B983A305B7A3;
        Mon, 30 Mar 2020 13:13:00 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v8 72/81] KVM: introspection: add KVMI_VCPU_CONTROL_MSR and KVMI_EVENT_MSR
Date:   Mon, 30 Mar 2020 13:12:59 +0300
Message-Id: <20200330101308.21702-73-alazar@bitdefender.com>
In-Reply-To: <20200330101308.21702-1-alazar@bitdefender.com>
References: <20200330101308.21702-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

This command is used to enable/disable introspection for a specific
MSR. The KVMI_EVENT_MSR event is sent when the tracked MSR is going to
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
 Documentation/virt/kvm/kvmi.rst               |  75 +++++++++
 arch/x86/include/asm/kvmi_host.h              |  12 ++
 arch/x86/include/uapi/asm/kvmi.h              |  18 ++
 arch/x86/kvm/kvmi.c                           | 157 ++++++++++++++++++
 arch/x86/kvm/x86.c                            |   3 +
 include/uapi/linux/kvmi.h                     |   2 +
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 102 ++++++++++++
 virt/kvm/introspection/kvmi.c                 |   1 +
 virt/kvm/introspection/kvmi_int.h             |   2 +
 virt/kvm/introspection/kvmi_msg.c             |  13 ++
 10 files changed, 385 insertions(+)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 6f6551230e11..3b9db943a549 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -550,6 +550,7 @@ the following events::
 	KVMI_EVENT_CR
 	KVMI_EVENT_DESCRIPTOR
 	KVMI_EVENT_HYPERCALL
+	KVMI_EVENT_MSR
 	KVMI_EVENT_XSETBV
 
 When an event is enabled, the introspection tool is notified and
@@ -843,6 +844,45 @@ Returns the guest memory type for a specific physical address.
 * -KVM_EINVAL - the padding is not zero
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
+* -KVM_EINVAL - the padding is not zero
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+
 Events
 ======
 
@@ -1148,3 +1188,38 @@ introspection has been enabled for this event (see **KVMI_VCPU_CONTROL_EVENTS**)
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
index 3c4bba88b50d..a9326c8e8252 100644
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
 bool kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor, bool write);
+bool kvmi_msr_event(struct kvm_vcpu *vcpu, struct msr_data *msr);
 
 #else /* CONFIG_KVM_INTROSPECTION */
 
@@ -50,6 +60,8 @@ static inline bool kvmi_monitor_desc_intercept(struct kvm_vcpu *vcpu,
 					       bool enable) { return false; }
 static inline bool kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor,
 					 bool write) { return true; }
+static inline bool kvmi_msr_event(struct kvm_vcpu *vcpu, struct msr_data *msr)
+				{ return true; }
 
 #endif /* CONFIG_KVM_INTROSPECTION */
 
diff --git a/arch/x86/include/uapi/asm/kvmi.h b/arch/x86/include/uapi/asm/kvmi.h
index 691a501200b3..e4d591912f37 100644
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
index 11178bd75cb4..b57b4320a19f 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -418,6 +418,76 @@ static void kvmi_arch_disable_desc_intercept(struct kvm_vcpu *vcpu)
 	vcpu->arch.kvmi->descriptor.kvm_intercepted = false;
 }
 
+static bool kvmi_msr_valid(unsigned int msr)
+{
+	return msr <= 0x1fff || (msr >= 0xc0000000 && msr <= 0xc0001fff);
+}
+
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
+	unsigned int msr_base = msr_mask_to_base(vcpu, mask);
+	int offset = -1;
+
+	for (;;) {
+		offset = find_next_bit(mask, KVMI_NUM_MSR, offset + 1);
+
+		if (offset >= KVMI_NUM_MSR)
+			break;
+
+		kvm_x86_ops->control_msr_intercept(vcpu, msr_base + offset,
+						   MSR_TYPE_W, false);
+	}
+
+	bitmap_zero(mask, KVMI_NUM_MSR);
+}
+
 int kvmi_arch_cmd_control_intercept(struct kvm_vcpu *vcpu,
 				    unsigned int event_id, bool enable)
 {
@@ -467,6 +537,8 @@ bool kvmi_arch_restore_interception(struct kvm_vcpu *vcpu)
 	kvmi_arch_disable_bp_intercept(vcpu);
 	kvmi_arch_disable_cr3w_intercept(vcpu);
 	kvmi_arch_disable_desc_intercept(vcpu);
+	kvmi_arch_disable_msr_intercept(vcpu, arch_vcpui->msrw.kvmi_mask.low);
+	kvmi_arch_disable_msr_intercept(vcpu, arch_vcpui->msrw.kvmi_mask.high);
 
 	return true;
 }
@@ -849,3 +921,88 @@ bool kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor, bool write)
 	return ret;
 }
 EXPORT_SYMBOL(kvmi_descriptor_event);
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
+	struct kvmi_event_msr e;
+	struct kvmi_event_msr_reply r;
+	int err, action;
+
+	memset(&e, 0, sizeof(e));
+	e.msr = msr;
+	e.old_value = old_value;
+	e.new_value = new_value;
+
+	err = kvmi_send_event(vcpu, KVMI_EVENT_MSR, &e, sizeof(e),
+			      &r, sizeof(r), &action);
+	if (err)
+		return KVMI_EVENT_ACTION_CONTINUE;
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
+	u64 ret_value = msr->data;
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
index ab0ad3b6ebc2..ce2f9d47d6f6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1490,6 +1490,9 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 	msr.index = index;
 	msr.host_initiated = host_initiated;
 
+	if (!host_initiated && !kvmi_msr_event(vcpu, &msr))
+		return 1;
+
 	return kvm_x86_ops->set_msr(vcpu, &msr);
 }
 
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 2ccc4045137f..04e6971ea0af 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -38,6 +38,7 @@ enum {
 
 	KVMI_VCPU_GET_XSAVE     = 18,
 	KVMI_VCPU_GET_MTRR_TYPE = 19,
+	KVMI_VCPU_CONTROL_MSR   = 20,
 
 	KVMI_NUM_MESSAGES
 };
@@ -51,6 +52,7 @@ enum {
 	KVMI_EVENT_TRAP       = 5,
 	KVMI_EVENT_XSETBV     = 6,
 	KVMI_EVENT_DESCRIPTOR = 7,
+	KVMI_EVENT_MSR        = 8,
 
 	KVMI_NUM_EVENTS
 };
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 4f2de304a6f8..955ef55e1346 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -57,6 +57,7 @@ enum {
 	GUEST_TEST_CR,
 	GUEST_TEST_DESCRIPTOR,
 	GUEST_TEST_HYPERCALL,
+	GUEST_TEST_MSR,
 	GUEST_TEST_XSETBV,
 };
 
@@ -97,6 +98,15 @@ static void guest_hypercall_test(void)
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
@@ -154,6 +164,9 @@ static void guest_code(void)
 		case GUEST_TEST_HYPERCALL:
 			guest_hypercall_test();
 			break;
+		case GUEST_TEST_MSR:
+			guest_msr_test();
+			break;
 		case GUEST_TEST_XSETBV:
 			guest_xsetbv_test();
 			break;
@@ -1437,6 +1450,94 @@ static void test_event_descriptor(struct kvm_vm *vm)
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
 	srandom(time(0));
@@ -1466,6 +1567,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vcpu_get_xsave(vm);
 	test_cmd_vcpu_get_mtrr_type(vm);
 	test_event_descriptor(vm);
+	test_cmd_vcpu_control_msr(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index db79744e5d2f..a858aba1672d 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -82,6 +82,7 @@ static void setup_known_events(void)
 	set_bit(KVMI_EVENT_CR, Kvmi_known_vcpu_events);
 	set_bit(KVMI_EVENT_DESCRIPTOR, Kvmi_known_vcpu_events);
 	set_bit(KVMI_EVENT_HYPERCALL, Kvmi_known_vcpu_events);
+	set_bit(KVMI_EVENT_MSR, Kvmi_known_vcpu_events);
 	set_bit(KVMI_EVENT_PAUSE_VCPU, Kvmi_known_vcpu_events);
 	set_bit(KVMI_EVENT_TRAP, Kvmi_known_vcpu_events);
 	set_bit(KVMI_EVENT_XSETBV, Kvmi_known_vcpu_events);
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 72c9d3a1a4b6..ba4bdfaef20d 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -107,5 +107,7 @@ int kvmi_arch_cmd_vcpu_get_xsave(struct kvm_vcpu *vcpu,
 				 struct kvmi_vcpu_get_xsave_reply **dest,
 				 size_t *dest_size);
 int kvmi_arch_cmd_vcpu_get_mtrr_type(struct kvm_vcpu *vcpu, u64 gpa, u8 *type);
+int kvmi_arch_cmd_vcpu_control_msr(struct kvm_vcpu *vcpu,
+				   const struct kvmi_vcpu_control_msr *req);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 78ae52f05c29..191b60c290ee 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -31,6 +31,7 @@ static const char *const msg_IDs[] = {
 	[KVMI_VM_WRITE_PHYSICAL]     = "KVMI_VM_WRITE_PHYSICAL",
 	[KVMI_VCPU_CONTROL_CR]       = "KVMI_VCPU_CONTROL_CR",
 	[KVMI_VCPU_CONTROL_EVENTS]   = "KVMI_VCPU_CONTROL_EVENTS",
+	[KVMI_VCPU_CONTROL_MSR]      = "KVMI_VCPU_CONTROL_MSR",
 	[KVMI_VCPU_GET_CPUID]        = "KVMI_VCPU_GET_CPUID",
 	[KVMI_VCPU_GET_INFO]         = "KVMI_VCPU_GET_INFO",
 	[KVMI_VCPU_GET_MTRR_TYPE]    = "KVMI_VCPU_GET_MTRR_TYPE",
@@ -592,6 +593,17 @@ static int handle_vcpu_get_mtrr_type(const struct kvmi_vcpu_cmd_job *job,
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
  * These commands are executed from the vCPU thread. The receiving thread
  * passes the messages using a newly allocated 'struct kvmi_vcpu_cmd_job'
@@ -603,6 +615,7 @@ static int(*const msg_vcpu[])(const struct kvmi_vcpu_cmd_job *,
 	[KVMI_EVENT]                 = handle_event_reply,
 	[KVMI_VCPU_CONTROL_CR]       = handle_vcpu_control_cr,
 	[KVMI_VCPU_CONTROL_EVENTS]   = handle_vcpu_control_events,
+	[KVMI_VCPU_CONTROL_MSR]      = handle_vcpu_control_msr,
 	[KVMI_VCPU_GET_CPUID]        = handle_get_cpuid,
 	[KVMI_VCPU_GET_INFO]         = handle_get_vcpu_info,
 	[KVMI_VCPU_GET_MTRR_TYPE]    = handle_vcpu_get_mtrr_type,
