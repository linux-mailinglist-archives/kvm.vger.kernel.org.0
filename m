Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59C4D1978DF
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729825AbgC3KUT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:20:19 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:43880 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729713AbgC3KUJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 06:20:09 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id DAED4305D48E;
        Mon, 30 Mar 2020 13:12:58 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id A88B2305B7A2;
        Mon, 30 Mar 2020 13:12:58 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v8 63/81] KVM: introspection: add KVMI_VCPU_CONTROL_CR and KVMI_EVENT_CR
Date:   Mon, 30 Mar 2020 13:12:50 +0300
Message-Id: <20200330101308.21702-64-alazar@bitdefender.com>
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

Using the KVMI_VCPU_CONTROL_CR command, the introspection tool subscribes
to KVMI_EVENT_CR events that will be sent when CR{0,3,4} is going to
be changed.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               |  70 +++++++++++
 arch/x86/include/asm/kvmi_host.h              |  10 ++
 arch/x86/include/uapi/asm/kvmi.h              |  18 +++
 arch/x86/kvm/kvmi.c                           | 111 ++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c                        |   6 +-
 arch/x86/kvm/x86.c                            |  12 +-
 include/uapi/linux/kvmi.h                     |   2 +
 .../testing/selftests/kvm/x86_64/kvmi_test.c  |  98 ++++++++++++++++
 virt/kvm/introspection/kvmi.c                 |   1 +
 virt/kvm/introspection/kvmi_int.h             |   7 ++
 virt/kvm/introspection/kvmi_msg.c             |  19 ++-
 11 files changed, 348 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index b62cfdd61f89..c624ab59bd0e 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -547,6 +547,7 @@ Enables/disables vCPU introspection events. This command can be used with
 the following events::
 
 	KVMI_EVENT_BREAKPOINT
+	KVMI_EVENT_CR
 	KVMI_EVENT_HYPERCALL
 
 When an event is enabled, the introspection tool is notified and
@@ -680,6 +681,40 @@ Returns a CPUID leaf (as seen by the guest OS).
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
 * -KVM_ENOENT - the selected leaf is not present or is invalid
 
+14. KVMI_VCPU_CONTROL_CR
+------------------------
+
+:Architectures: x86
+:Versions: >= 1
+:Parameters:
+
+::
+
+	struct kvmi_vcpu_hdr;
+	struct kvmi_vcpu_control_cr {
+		__u16 cr;
+		__u8 enable;
+		__u8 padding1;
+		__u32 padding2;
+	};
+
+:Returns:
+
+::
+
+	struct kvmi_error_code
+
+Enables/disables introspection for a specific control register and must
+be used in addition to *KVMI_VCPU_CONTROL_EVENTS* with the *KVMI_EVENT_CR*
+ID set.
+
+:Errors:
+
+* -KVM_EINVAL - the selected vCPU is invalid
+* -KVM_EINVAL - the specified control register is not CR0, CR3 or CR4
+* -KVM_EINVAL - the padding is not zero
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+
 Events
 ======
 
@@ -855,3 +890,38 @@ trying to perform a certain operation (like creating a process).
 ``kvmi_event`` and the guest physical address are sent to the introspection tool.
 
 The *RETRY* action is used by the introspection tool for its own breakpoints.
+
+5. KVMI_EVENT_CR
+----------------
+
+:Architectures: x86
+:Versions: >= 1
+:Actions: CONTINUE, CRASH
+:Parameters:
+
+::
+
+	struct kvmi_event;
+	struct kvmi_event_cr {
+		__u16 cr;
+		__u16 padding[3];
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
+	struct kvmi_event_cr_reply {
+		__u64 new_val;
+	};
+
+This event is sent when a control register is going to be changed and the
+introspection has been enabled for this event and for this specific
+register (see **KVMI_VCPU_CONTROL_EVENTS**).
+
+``kvmi_event``, the control register number, the old value and the new value
+are sent to the introspection tool. The *CONTINUE* action will set the ``new_val``.
diff --git a/arch/x86/include/asm/kvmi_host.h b/arch/x86/include/asm/kvmi_host.h
index c8b793915b84..4ac209cb4ebf 100644
--- a/arch/x86/include/asm/kvmi_host.h
+++ b/arch/x86/include/asm/kvmi_host.h
@@ -2,6 +2,8 @@
 #ifndef _ASM_X86_KVMI_HOST_H
 #define _ASM_X86_KVMI_HOST_H
 
+#define KVMI_NUM_CR 5
+
 struct kvmi_monitor_interception {
 	bool kvmi_intercepted;
 	bool kvm_intercepted;
@@ -14,6 +16,7 @@ struct kvmi_interception {
 };
 
 struct kvm_vcpu_arch_introspection {
+	DECLARE_BITMAP(cr_mask, KVMI_NUM_CR);
 };
 
 struct kvm_arch_introspection {
@@ -22,11 +25,18 @@ struct kvm_arch_introspection {
 #ifdef CONFIG_KVM_INTROSPECTION
 
 bool kvmi_monitor_bp_intercept(struct kvm_vcpu *vcpu, u32 dbg);
+bool kvmi_cr_event(struct kvm_vcpu *vcpu, unsigned int cr,
+		   unsigned long old_value, unsigned long *new_value);
+bool kvmi_cr3_intercepted(struct kvm_vcpu *vcpu);
 
 #else /* CONFIG_KVM_INTROSPECTION */
 
 static inline bool kvmi_monitor_bp_intercept(struct kvm_vcpu *vcpu, u32 dbg)
 	{ return false; }
+static inline bool kvmi_cr_event(struct kvm_vcpu *vcpu, unsigned int cr,
+				 unsigned long old_value,
+				 unsigned long *new_value) { return true; }
+static inline bool kvmi_cr3_intercepted(struct kvm_vcpu *vcpu) { return false; }
 
 #endif /* CONFIG_KVM_INTROSPECTION */
 
diff --git a/arch/x86/include/uapi/asm/kvmi.h b/arch/x86/include/uapi/asm/kvmi.h
index 1605777256a3..a3d29557cc15 100644
--- a/arch/x86/include/uapi/asm/kvmi.h
+++ b/arch/x86/include/uapi/asm/kvmi.h
@@ -65,4 +65,22 @@ struct kvmi_event_breakpoint {
 	__u8 padding[7];
 };
 
+struct kvmi_vcpu_control_cr {
+	__u16 cr;
+	__u8 enable;
+	__u8 padding1;
+	__u32 padding2;
+};
+
+struct kvmi_event_cr {
+	__u16 cr;
+	__u16 padding[3];
+	__u64 old_value;
+	__u64 new_value;
+};
+
+struct kvmi_event_cr_reply {
+	__u64 new_val;
+};
+
 #endif /* _UAPI_ASM_X86_KVMI_H */
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 74fca566a44a..2e00f0c530f2 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -390,3 +390,114 @@ void kvmi_arch_request_restore_interception(struct kvm_vcpu *vcpu)
 	if (arch_vcpui)
 		arch_vcpui->restore_interception = true;
 }
+
+int kvmi_arch_cmd_vcpu_control_cr(struct kvm_vcpu *vcpu,
+				  const struct kvmi_vcpu_control_cr *req)
+{
+	u32 cr = req->cr;
+
+	if (req->padding1 || req->padding2 || req->enable > 1)
+		return -KVM_EINVAL;
+
+	switch (cr) {
+	case 0:
+		break;
+	case 3:
+		kvm_x86_ops->control_cr3_intercept(vcpu, CR_TYPE_W,
+						   req->enable == 1);
+		break;
+	case 4:
+		break;
+	default:
+		return -KVM_EINVAL;
+	}
+
+	if (req->enable)
+		set_bit(cr, VCPUI(vcpu)->arch.cr_mask);
+	else
+		clear_bit(cr, VCPUI(vcpu)->arch.cr_mask);
+
+	return 0;
+}
+
+static u32 kvmi_send_cr(struct kvm_vcpu *vcpu, u32 cr, u64 old_value,
+			u64 new_value, u64 *ret_value)
+{
+	struct kvmi_event_cr e;
+	struct kvmi_event_cr_reply r;
+	int err, action;
+
+	memset(&e, 0, sizeof(e));
+	e.cr = cr;
+	e.old_value = old_value;
+	e.new_value = new_value;
+
+	err = kvmi_send_event(vcpu, KVMI_EVENT_CR, &e, sizeof(e),
+			      &r, sizeof(r), &action);
+	if (err)
+		return KVMI_EVENT_ACTION_CONTINUE;
+
+	*ret_value = r.new_val;
+	return action;
+}
+
+static bool __kvmi_cr_event(struct kvm_vcpu *vcpu, unsigned int cr,
+			    unsigned long old_value, unsigned long *new_value)
+{
+	u64 ret_value = *new_value;
+	bool ret = false;
+	u32 action;
+
+	if (!test_bit(cr, VCPUI(vcpu)->arch.cr_mask))
+		return true;
+
+	action = kvmi_send_cr(vcpu, cr, old_value, *new_value, &ret_value);
+	switch (action) {
+	case KVMI_EVENT_ACTION_CONTINUE:
+		*new_value = ret_value;
+		ret = true;
+		break;
+	default:
+		kvmi_handle_common_event_actions(vcpu->kvm, action, "CR");
+	}
+
+	return ret;
+}
+
+bool kvmi_cr_event(struct kvm_vcpu *vcpu, unsigned int cr,
+		   unsigned long old_value, unsigned long *new_value)
+{
+	struct kvm_introspection *kvmi;
+	bool ret = true;
+
+	if (old_value == *new_value)
+		return true;
+
+	kvmi = kvmi_get(vcpu->kvm);
+	if (!kvmi)
+		return true;
+
+	if (is_event_enabled(vcpu, KVMI_EVENT_CR))
+		ret = __kvmi_cr_event(vcpu, cr, old_value, new_value);
+
+	kvmi_put(vcpu->kvm);
+
+	return ret;
+}
+
+bool kvmi_cr3_intercepted(struct kvm_vcpu *vcpu)
+{
+	struct kvm_introspection *kvmi;
+	bool ret;
+
+	kvmi = kvmi_get(vcpu->kvm);
+	if (!kvmi)
+		return false;
+
+	ret = test_bit(3, VCPUI(vcpu)->arch.cr_mask);
+
+	kvmi_put(vcpu->kvm);
+
+	return ret;
+}
+EXPORT_SYMBOL(kvmi_cr3_intercepted);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4b7044193917..ff705b4eee19 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4885,7 +4885,8 @@ static int handle_cr(struct kvm_vcpu *vcpu)
 			err = handle_set_cr0(vcpu, val);
 			return kvm_complete_insn_gp(vcpu, err);
 		case 3:
-			WARN_ON_ONCE(enable_unrestricted_guest);
+			WARN_ON_ONCE(enable_unrestricted_guest &&
+				     !kvmi_cr3_intercepted(vcpu));
 			err = kvm_set_cr3(vcpu, val);
 			return kvm_complete_insn_gp(vcpu, err);
 		case 4:
@@ -4918,7 +4919,8 @@ static int handle_cr(struct kvm_vcpu *vcpu)
 	case 1: /*mov from cr*/
 		switch (cr) {
 		case 3:
-			WARN_ON_ONCE(enable_unrestricted_guest);
+			WARN_ON_ONCE(enable_unrestricted_guest &&
+				     !kvmi_cr3_intercepted(vcpu));
 			val = kvm_read_cr3(vcpu);
 			kvm_register_write(vcpu, reg, val);
 			trace_kvm_cr_read(cr, val);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 31273c4c7f8d..5b88540384b4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -773,6 +773,9 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	if (!(cr0 & X86_CR0_PG) && kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE))
 		return 1;
 
+	if (!kvmi_cr_event(vcpu, 0, old_cr0, &cr0))
+		return 1;
+
 	kvm_x86_ops->set_cr0(vcpu, cr0);
 
 	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
@@ -950,6 +953,9 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 			return 1;
 	}
 
+	if (!kvmi_cr_event(vcpu, 4, old_cr4, &cr4))
+		return 1;
+
 	if (kvm_x86_ops->set_cr4(vcpu, cr4))
 		return 1;
 
@@ -966,6 +972,7 @@ EXPORT_SYMBOL_GPL(kvm_set_cr4);
 
 int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 {
+	unsigned long old_cr3 = kvm_read_cr3(vcpu);
 	bool skip_tlb_flush = false;
 #ifdef CONFIG_X86_64
 	bool pcid_enabled = kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
@@ -976,7 +983,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	}
 #endif
 
-	if (cr3 == kvm_read_cr3(vcpu) && !pdptrs_changed(vcpu)) {
+	if (cr3 == old_cr3 && !pdptrs_changed(vcpu)) {
 		if (!skip_tlb_flush) {
 			kvm_mmu_sync_roots(vcpu);
 			kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
@@ -991,6 +998,9 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 		 !load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
 		return 1;
 
+	if (!kvmi_cr_event(vcpu, 3, old_cr3, &cr3))
+		return 1;
+
 	kvm_mmu_new_cr3(vcpu, cr3, skip_tlb_flush);
 	vcpu->arch.cr3 = cr3;
 	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index f6792d41b02f..2826ac0f74e5 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -31,6 +31,7 @@ enum {
 	KVMI_VCPU_GET_REGISTERS  = 12,
 	KVMI_VCPU_SET_REGISTERS  = 13,
 	KVMI_VCPU_GET_CPUID      = 14,
+	KVMI_VCPU_CONTROL_CR     = 15,
 
 	KVMI_NUM_MESSAGES
 };
@@ -40,6 +41,7 @@ enum {
 	KVMI_EVENT_PAUSE_VCPU = 1,
 	KVMI_EVENT_HYPERCALL  = 2,
 	KVMI_EVENT_BREAKPOINT = 3,
+	KVMI_EVENT_CR         = 4,
 
 	KVMI_NUM_EVENTS
 };
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index dab015555f89..9595e86cd79e 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -50,6 +50,7 @@ struct vcpu_worker_data {
 enum {
 	GUEST_TEST_NOOP = 0,
 	GUEST_TEST_BP,
+	GUEST_TEST_CR,
 	GUEST_TEST_HYPERCALL,
 };
 
@@ -69,6 +70,11 @@ static void guest_bp_test(void)
 	asm volatile("int3");
 }
 
+static void guest_cr_test(void)
+{
+	set_cr4(get_cr4() | X86_CR4_OSXSAVE);
+}
+
 static void guest_hypercall_test(void)
 {
 	asm volatile("mov $34, %rax");
@@ -86,6 +92,9 @@ static void guest_code(void)
 		case GUEST_TEST_BP:
 			guest_bp_test();
 			break;
+		case GUEST_TEST_CR:
+			guest_cr_test();
+			break;
 		case GUEST_TEST_HYPERCALL:
 			guest_hypercall_test();
 			break;
@@ -1029,6 +1038,94 @@ static void test_event_breakpoint(struct kvm_vm *vm)
 	disable_vcpu_event(vm, event_id);
 }
 
+static int cmd_control_cr(struct kvm_vm *vm, __u32 cr, bool enable)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vcpu_hdr vcpu_hdr;
+		struct kvmi_vcpu_control_cr cmd;
+	} req = {};
+
+	req.cmd.cr = cr;
+	req.cmd.enable = enable ? 1 : 0;
+
+	return do_vcpu0_command(vm, KVMI_VCPU_CONTROL_CR, &req.hdr, sizeof(req),
+				NULL, 0);
+}
+
+static void enable_cr_events(struct kvm_vm *vm, __u32 cr)
+{
+	int r;
+
+	enable_vcpu_event(vm, KVMI_EVENT_CR);
+
+	r = cmd_control_cr(vm, cr, true);
+	TEST_ASSERT(r == 0,
+		"KVMI_VCPU_CONTROL_CR failed, error %d(%s)\n",
+		-r, kvm_strerror(-r));
+}
+
+static void disable_cr_events(struct kvm_vm *vm, __u32 cr)
+{
+	int r;
+
+	r = cmd_control_cr(vm, cr, false);
+	TEST_ASSERT(r == 0,
+		"KVMI_VCPU_CONTROL_CR failed, error %d(%s)\n",
+		-r, kvm_strerror(-r));
+
+	disable_vcpu_event(vm, KVMI_EVENT_CR);
+}
+
+static void test_cmd_vcpu_control_cr(struct kvm_vm *vm)
+{
+	struct vcpu_worker_data data = {
+		.vm = vm,
+		.vcpu_id = VCPU_ID,
+		.test_id = GUEST_TEST_CR,
+	};
+	struct kvmi_msg_hdr hdr;
+	struct {
+		struct kvmi_event common;
+		struct kvmi_event_cr cr;
+	} ev;
+	struct {
+		struct vcpu_reply common;
+		struct kvmi_event_cr_reply cr;
+	} rpl = {};
+	__u16 event_id = KVMI_EVENT_CR;
+	__u32 cr_no = 4;
+	struct kvm_sregs sregs;
+	pthread_t vcpu_thread;
+
+	enable_cr_events(vm, cr_no);
+
+	vcpu_thread = start_vcpu_worker(&data);
+
+	receive_event(&hdr, &ev.common, sizeof(ev), event_id);
+
+	DEBUG("CR%u, old 0x%llx, new 0x%llx\n",
+		ev.cr.cr, ev.cr.old_value, ev.cr.new_value);
+
+	TEST_ASSERT(ev.cr.cr == cr_no,
+		"Unexpected CR event, received CR%u, expected CR%u",
+		ev.cr.cr, cr_no);
+
+	rpl.cr.new_val = ev.cr.old_value;
+
+	reply_to_event(&hdr, &ev.common, KVMI_EVENT_ACTION_CONTINUE,
+			&rpl.common, sizeof(rpl));
+
+	stop_vcpu_worker(vcpu_thread, &data);
+
+	disable_cr_events(vm, cr_no);
+
+	vcpu_sregs_get(vm, VCPU_ID, &sregs);
+	TEST_ASSERT(sregs.cr4 == ev.cr.old_value,
+		"Failed to block CR4 update, CR4 0x%x, expected 0x%x",
+		sregs.cr4, ev.cr.old_value);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	srandom(time(0));
@@ -1051,6 +1148,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vcpu_get_cpuid(vm);
 	test_event_hypercall(vm);
 	test_event_breakpoint(vm);
+	test_cmd_vcpu_control_cr(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 7ea0512bc580..6d421cf213d7 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -79,6 +79,7 @@ static void setup_known_events(void)
 
 	bitmap_zero(Kvmi_known_vcpu_events, KVMI_NUM_EVENTS);
 	set_bit(KVMI_EVENT_BREAKPOINT, Kvmi_known_vcpu_events);
+	set_bit(KVMI_EVENT_CR, Kvmi_known_vcpu_events);
 	set_bit(KVMI_EVENT_HYPERCALL, Kvmi_known_vcpu_events);
 	set_bit(KVMI_EVENT_PAUSE_VCPU, Kvmi_known_vcpu_events);
 
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 7024bfa3df61..588a386a3f37 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -33,6 +33,9 @@ bool kvmi_sock_get(struct kvm_introspection *kvmi, int fd);
 void kvmi_sock_shutdown(struct kvm_introspection *kvmi);
 void kvmi_sock_put(struct kvm_introspection *kvmi);
 bool kvmi_msg_process(struct kvm_introspection *kvmi);
+int kvmi_send_event(struct kvm_vcpu *vcpu, u32 ev_id,
+		    void *ev, size_t ev_size,
+		    void *rpl, size_t rpl_size, int *action);
 int kvmi_msg_send_unhook(struct kvm_introspection *kvmi);
 u32 kvmi_msg_send_vcpu_pause(struct kvm_vcpu *vcpu);
 u32 kvmi_msg_send_hypercall(struct kvm_vcpu *vcpu);
@@ -49,6 +52,8 @@ void kvmi_run_jobs(struct kvm_vcpu *vcpu);
 void kvmi_post_reply(struct kvm_vcpu *vcpu);
 void kvmi_handle_common_event_actions(struct kvm *kvm,
 				      u32 action, const char *str);
+struct kvm_introspection * __must_check kvmi_get(struct kvm *kvm);
+void kvmi_put(struct kvm *kvm);
 int kvmi_cmd_vm_control_events(struct kvm_introspection *kvmi,
 				unsigned int event_id, bool enable);
 int kvmi_cmd_vcpu_control_events(struct kvm_vcpu *vcpu,
@@ -88,5 +93,7 @@ void kvmi_arch_hypercall_event(struct kvm_vcpu *vcpu);
 void kvmi_arch_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva, u8 insn_len);
 int kvmi_arch_cmd_control_intercept(struct kvm_vcpu *vcpu,
 				    unsigned int event_id, bool enable);
+int kvmi_arch_cmd_vcpu_control_cr(struct kvm_vcpu *vcpu,
+				  const struct kvmi_vcpu_control_cr *req);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 8e451ad534e4..789aa9f1912f 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -28,6 +28,7 @@ static const char *const msg_IDs[] = {
 	[KVMI_VM_GET_INFO]         = "KVMI_VM_GET_INFO",
 	[KVMI_VM_READ_PHYSICAL]    = "KVMI_VM_READ_PHYSICAL",
 	[KVMI_VM_WRITE_PHYSICAL]   = "KVMI_VM_WRITE_PHYSICAL",
+	[KVMI_VCPU_CONTROL_CR]     = "KVMI_VCPU_CONTROL_CR",
 	[KVMI_VCPU_CONTROL_EVENTS] = "KVMI_VCPU_CONTROL_EVENTS",
 	[KVMI_VCPU_GET_CPUID]      = "KVMI_VCPU_GET_CPUID",
 	[KVMI_VCPU_GET_INFO]       = "KVMI_VCPU_GET_INFO",
@@ -514,6 +515,17 @@ static int handle_get_cpuid(const struct kvmi_vcpu_cmd_job *job,
 	return kvmi_msg_vcpu_reply(job, msg, ec, &rpl, sizeof(rpl));
 }
 
+static int handle_vcpu_control_cr(const struct kvmi_vcpu_cmd_job *job,
+				  const struct kvmi_msg_hdr *msg,
+				  const void *req)
+{
+	int ec;
+
+	ec = kvmi_arch_cmd_vcpu_control_cr(job->vcpu, req);
+
+	return kvmi_msg_vcpu_reply(job, msg, ec, NULL, 0);
+}
+
 /*
  * These commands are executed from the vCPU thread. The receiving thread
  * passes the messages using a newly allocated 'struct kvmi_vcpu_cmd_job'
@@ -523,6 +535,7 @@ static int handle_get_cpuid(const struct kvmi_vcpu_cmd_job *job,
 static int(*const msg_vcpu[])(const struct kvmi_vcpu_cmd_job *,
 			      const struct kvmi_msg_hdr *, const void *) = {
 	[KVMI_EVENT]               = handle_event_reply,
+	[KVMI_VCPU_CONTROL_CR]     = handle_vcpu_control_cr,
 	[KVMI_VCPU_CONTROL_EVENTS] = handle_vcpu_control_events,
 	[KVMI_VCPU_GET_CPUID]      = handle_get_cpuid,
 	[KVMI_VCPU_GET_INFO]       = handle_get_vcpu_info,
@@ -784,9 +797,9 @@ static void kvmi_setup_vcpu_reply(struct kvm_vcpu_introspection *vcpui,
 	vcpui->waiting_for_reply = true;
 }
 
-static int kvmi_send_event(struct kvm_vcpu *vcpu, u32 ev_id,
-			   void *ev, size_t ev_size,
-			   void *rpl, size_t rpl_size, int *action)
+int kvmi_send_event(struct kvm_vcpu *vcpu, u32 ev_id,
+		    void *ev, size_t ev_size,
+		    void *rpl, size_t rpl_size, int *action)
 {
 	struct kvmi_msg_hdr hdr;
 	struct kvmi_event common;
