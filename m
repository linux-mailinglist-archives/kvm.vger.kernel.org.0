Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3BA82C3CB8
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 10:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728766AbgKYJmt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 04:42:49 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:57194 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727718AbgKYJmB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Nov 2020 04:42:01 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id C1C69305D3C9;
        Wed, 25 Nov 2020 11:35:52 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 982663072785;
        Wed, 25 Nov 2020 11:35:52 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v10 61/81] KVM: introspection: add KVMI_VCPU_CONTROL_CR and KVMI_VCPU_EVENT_CR
Date:   Wed, 25 Nov 2020 11:35:40 +0200
Message-Id: <20201125093600.2766-62-alazar@bitdefender.com>
In-Reply-To: <20201125093600.2766-1-alazar@bitdefender.com>
References: <20201125093600.2766-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

Using the KVMI_VCPU_CONTROL_CR command, the introspection tool subscribes
to KVMI_VCPU_EVENT_CR events that will be sent when a control register
(CR0, CR3 or CR4) is going to be changed.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               |  73 +++++++++++++
 arch/x86/include/asm/kvmi_host.h              |  12 +++
 arch/x86/include/uapi/asm/kvmi.h              |  18 ++++
 arch/x86/kvm/kvmi.c                           |  78 ++++++++++++++
 arch/x86/kvm/kvmi.h                           |   4 +
 arch/x86/kvm/kvmi_msg.c                       |  44 ++++++++
 arch/x86/kvm/vmx/vmx.c                        |   6 +-
 arch/x86/kvm/x86.c                            |  12 ++-
 include/uapi/linux/kvmi.h                     |   2 +
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 100 ++++++++++++++++++
 virt/kvm/introspection/kvmi_int.h             |   2 +
 11 files changed, 348 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index f9c10d27ce14..85e14b82aa2f 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -539,6 +539,7 @@ Enables/disables vCPU introspection events. This command can be used with
 the following events::
 
 	KVMI_VCPU_EVENT_BREAKPOINT
+	KVMI_VCPU_EVENT_CR
 	KVMI_VCPU_EVENT_HYPERCALL
 
 When an event is enabled, the introspection tool is notified and
@@ -701,6 +702,40 @@ interceptions). By default it is enabled.
 * -KVM_EINVAL - the padding is not zero
 * -KVM_EINVAL - ``enable`` is not 1 or 0
 
+15. KVMI_VCPU_CONTROL_CR
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
+		__u8 cr;
+		__u8 enable;
+		__u16 padding1;
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
+be used in addition to *KVMI_VCPU_CONTROL_EVENTS* with the *KVMI_VCPU_EVENT_CR*
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
 
@@ -893,3 +928,41 @@ before returning this action.
 
 The *CONTINUE* action will cause the breakpoint exception to be reinjected
 (the OS will handle it).
+
+5. KVMI_VCPU_EVENT_CR
+---------------------
+
+:Architectures: x86
+:Versions: >= 1
+:Actions: CONTINUE, CRASH
+:Parameters:
+
+::
+
+	struct kvmi_event_hdr;
+	struct kvmi_vcpu_event;
+	struct kvmi_vcpu_event_cr {
+		__u8 cr;
+		__u8 padding[7];
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
+	struct kvmi_vcpu_event_cr_reply {
+		__u64 new_val;
+	};
+
+This event is sent when a control register is going to be changed and the
+introspection has been enabled for this event and for this specific
+register (see **KVMI_VCPU_CONTROL_EVENTS**).
+
+``kvmi_vcpu_event`` (with the vCPU state), the control register number
+(``cr``), the old value (``old_value``) and the new value (``new_value``)
+are sent to the introspection tool. The *CONTINUE* action will set the
+``new_val``.
diff --git a/arch/x86/include/asm/kvmi_host.h b/arch/x86/include/asm/kvmi_host.h
index 161d1ae5a7cf..7613088d0ae2 100644
--- a/arch/x86/include/asm/kvmi_host.h
+++ b/arch/x86/include/asm/kvmi_host.h
@@ -4,6 +4,8 @@
 
 #include <asm/kvmi.h>
 
+#define KVMI_NUM_CR 5
+
 struct kvmi_monitor_interception {
 	bool kvmi_intercepted;
 	bool kvm_intercepted;
@@ -19,6 +21,8 @@ struct kvmi_interception {
 struct kvm_vcpu_arch_introspection {
 	struct kvm_regs delayed_regs;
 	bool have_delayed_regs;
+
+	DECLARE_BITMAP(cr_mask, KVMI_NUM_CR);
 };
 
 struct kvm_arch_introspection {
@@ -27,11 +31,19 @@ struct kvm_arch_introspection {
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
+				 unsigned long *new_value)
+			{ return true; }
+static inline bool kvmi_cr3_intercepted(struct kvm_vcpu *vcpu) { return false; }
 
 #endif /* CONFIG_KVM_INTROSPECTION */
 
diff --git a/arch/x86/include/uapi/asm/kvmi.h b/arch/x86/include/uapi/asm/kvmi.h
index a442ba4d2190..32cd17488058 100644
--- a/arch/x86/include/uapi/asm/kvmi.h
+++ b/arch/x86/include/uapi/asm/kvmi.h
@@ -61,4 +61,22 @@ struct kvmi_vcpu_get_cpuid_reply {
 	__u32 edx;
 };
 
+struct kvmi_vcpu_control_cr {
+	__u8 cr;
+	__u8 enable;
+	__u16 padding1;
+	__u32 padding2;
+};
+
+struct kvmi_vcpu_event_cr {
+	__u8 cr;
+	__u8 padding[7];
+	__u64 old_value;
+	__u64 new_value;
+};
+
+struct kvmi_vcpu_event_cr_reply {
+	__u64 new_val;
+};
+
 #endif /* _UAPI_ASM_X86_KVMI_H */
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index e7a4ef48ed61..2bb6b4bb932b 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -8,10 +8,12 @@
 #include "linux/kvm_host.h"
 #include "x86.h"
 #include "../../../virt/kvm/introspection/kvmi_int.h"
+#include "kvmi.h"
 
 void kvmi_arch_init_vcpu_events_mask(unsigned long *supported)
 {
 	set_bit(KVMI_VCPU_EVENT_BREAKPOINT, supported);
+	set_bit(KVMI_VCPU_EVENT_CR, supported);
 	set_bit(KVMI_VCPU_EVENT_HYPERCALL, supported);
 }
 
@@ -320,3 +322,79 @@ void kvmi_arch_request_interception_cleanup(struct kvm_vcpu *vcpu,
 		arch_vcpui->cleanup = true;
 	}
 }
+
+int kvmi_arch_cmd_vcpu_control_cr(struct kvm_vcpu *vcpu, int cr, bool enable)
+{
+	if (cr == 3)
+		kvm_x86_ops.control_cr3_intercept(vcpu, CR_TYPE_W, enable);
+
+	if (enable)
+		set_bit(cr, VCPUI(vcpu)->arch.cr_mask);
+	else
+		clear_bit(cr, VCPUI(vcpu)->arch.cr_mask);
+
+	return 0;
+}
+
+static bool __kvmi_cr_event(struct kvm_vcpu *vcpu, unsigned int cr,
+			    u64 old_value, unsigned long *new_value)
+{
+	u64 reply_value;
+	u32 action;
+	bool ret;
+
+	if (!test_bit(cr, VCPUI(vcpu)->arch.cr_mask))
+		return true;
+
+	action = kvmi_msg_send_cr(vcpu, cr, old_value, *new_value,
+				  &reply_value);
+	switch (action) {
+	case KVMI_EVENT_ACTION_CONTINUE:
+		*new_value = reply_value;
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
+	if (is_vcpu_event_enabled(vcpu, KVMI_VCPU_EVENT_CR))
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
diff --git a/arch/x86/kvm/kvmi.h b/arch/x86/kvm/kvmi.h
index 4eeb0c900083..6f4aaebb67f9 100644
--- a/arch/x86/kvm/kvmi.h
+++ b/arch/x86/kvm/kvmi.h
@@ -7,5 +7,9 @@ int kvmi_arch_cmd_vcpu_get_registers(struct kvm_vcpu *vcpu,
 				struct kvmi_vcpu_get_registers_reply *rpl);
 void kvmi_arch_cmd_vcpu_set_registers(struct kvm_vcpu *vcpu,
 				      const struct kvm_regs *regs);
+int kvmi_arch_cmd_vcpu_control_cr(struct kvm_vcpu *vcpu, int cr, bool enable);
+
+u32 kvmi_msg_send_cr(struct kvm_vcpu *vcpu, u32 cr, u64 old_value,
+		     u64 new_value, u64 *ret_value);
 
 #endif
diff --git a/arch/x86/kvm/kvmi_msg.c b/arch/x86/kvm/kvmi_msg.c
index 1651ef877e3e..1682bb27105f 100644
--- a/arch/x86/kvm/kvmi_msg.c
+++ b/arch/x86/kvm/kvmi_msg.c
@@ -132,7 +132,26 @@ static int handle_vcpu_get_cpuid(const struct kvmi_vcpu_msg_job *job,
 	return kvmi_msg_vcpu_reply(job, msg, ec, &rpl, sizeof(rpl));
 }
 
+static int handle_vcpu_control_cr(const struct kvmi_vcpu_msg_job *job,
+				  const struct kvmi_msg_hdr *msg,
+				  const void *_req)
+{
+	const struct kvmi_vcpu_control_cr *req = _req;
+	int ec;
+
+	if (req->padding1 || req->padding2 || req->enable > 1)
+		ec = -KVM_EINVAL;
+	else if (req->cr != 0 && req->cr != 3 && req->cr != 4)
+		ec = -KVM_EINVAL;
+	else
+		ec = kvmi_arch_cmd_vcpu_control_cr(job->vcpu, req->cr,
+						   req->enable == 1);
+
+	return kvmi_msg_vcpu_reply(job, msg, ec, NULL, 0);
+}
+
 static kvmi_vcpu_msg_job_fct const msg_vcpu[] = {
+	[KVMI_VCPU_CONTROL_CR]    = handle_vcpu_control_cr,
 	[KVMI_VCPU_GET_CPUID]     = handle_vcpu_get_cpuid,
 	[KVMI_VCPU_GET_INFO]      = handle_vcpu_get_info,
 	[KVMI_VCPU_GET_REGISTERS] = handle_vcpu_get_registers,
@@ -143,3 +162,28 @@ kvmi_vcpu_msg_job_fct kvmi_arch_vcpu_msg_handler(u16 id)
 {
 	return id < ARRAY_SIZE(msg_vcpu) ? msg_vcpu[id] : NULL;
 }
+
+u32 kvmi_msg_send_cr(struct kvm_vcpu *vcpu, u32 cr, u64 old_value,
+		     u64 new_value, u64 *ret_value)
+{
+	struct kvmi_vcpu_event_cr e;
+	struct kvmi_vcpu_event_cr_reply r;
+	u32 action;
+	int err;
+
+	memset(&e, 0, sizeof(e));
+	e.cr = cr;
+	e.old_value = old_value;
+	e.new_value = new_value;
+
+	err = kvmi_send_vcpu_event(vcpu, KVMI_VCPU_EVENT_CR, &e, sizeof(e),
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
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9bfa2e9f8161..723e78529146 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5062,7 +5062,8 @@ static int handle_cr(struct kvm_vcpu *vcpu)
 			err = handle_set_cr0(vcpu, val);
 			return kvm_complete_insn_gp(vcpu, err);
 		case 3:
-			WARN_ON_ONCE(enable_unrestricted_guest);
+			WARN_ON_ONCE(enable_unrestricted_guest &&
+				     !kvmi_cr3_intercepted(vcpu));
 			err = kvm_set_cr3(vcpu, val);
 			return kvm_complete_insn_gp(vcpu, err);
 		case 4:
@@ -5095,7 +5096,8 @@ static int handle_cr(struct kvm_vcpu *vcpu)
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
index 824d9d20a6ea..9a4ec0b4714c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -849,6 +849,9 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	if (!(cr0 & X86_CR0_PG) && kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE))
 		return 1;
 
+	if (!kvmi_cr_event(vcpu, 0, old_cr0, &cr0))
+		return 1;
+
 	kvm_x86_ops.set_cr0(vcpu, cr0);
 
 	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
@@ -1010,6 +1013,9 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 			return 1;
 	}
 
+	if (!kvmi_cr_event(vcpu, 4, old_cr4, &cr4))
+		return 1;
+
 	kvm_x86_ops.set_cr4(vcpu, cr4);
 
 	if (((cr4 ^ old_cr4) & mmu_role_bits) ||
@@ -1022,6 +1028,7 @@ EXPORT_SYMBOL_GPL(kvm_set_cr4);
 
 int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 {
+	unsigned long old_cr3 = kvm_read_cr3(vcpu);
 	bool skip_tlb_flush = false;
 #ifdef CONFIG_X86_64
 	bool pcid_enabled = kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE);
@@ -1032,7 +1039,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	}
 #endif
 
-	if (cr3 == kvm_read_cr3(vcpu) && !pdptrs_changed(vcpu)) {
+	if (cr3 == old_cr3 && !pdptrs_changed(vcpu)) {
 		if (!skip_tlb_flush) {
 			kvm_mmu_sync_roots(vcpu);
 			kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
@@ -1047,6 +1054,9 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 		 !load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
 		return 1;
 
+	if (!kvmi_cr_event(vcpu, 3, old_cr3, &cr3))
+		return 1;
+
 	kvm_mmu_new_pgd(vcpu, cr3, skip_tlb_flush, skip_tlb_flush);
 	vcpu->arch.cr3 = cr3;
 	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 9e28961a8387..c1d8cf02018b 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -41,6 +41,7 @@ enum {
 	KVMI_VCPU_GET_REGISTERS  = KVMI_VCPU_MESSAGE_ID(3),
 	KVMI_VCPU_SET_REGISTERS  = KVMI_VCPU_MESSAGE_ID(4),
 	KVMI_VCPU_GET_CPUID      = KVMI_VCPU_MESSAGE_ID(5),
+	KVMI_VCPU_CONTROL_CR     = KVMI_VCPU_MESSAGE_ID(6),
 
 	KVMI_NEXT_VCPU_MESSAGE
 };
@@ -58,6 +59,7 @@ enum {
 	KVMI_VCPU_EVENT_PAUSE      = KVMI_VCPU_EVENT_ID(0),
 	KVMI_VCPU_EVENT_HYPERCALL  = KVMI_VCPU_EVENT_ID(1),
 	KVMI_VCPU_EVENT_BREAKPOINT = KVMI_VCPU_EVENT_ID(2),
+	KVMI_VCPU_EVENT_CR         = KVMI_VCPU_EVENT_ID(3),
 
 	KVMI_NEXT_VCPU_EVENT
 };
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index f95f2771a123..6a1103eab77a 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -54,6 +54,7 @@ struct vcpu_worker_data {
 enum {
 	GUEST_TEST_NOOP = 0,
 	GUEST_TEST_BP,
+	GUEST_TEST_CR,
 	GUEST_TEST_HYPERCALL,
 };
 
@@ -77,6 +78,11 @@ static void guest_bp_test(void)
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
@@ -94,6 +100,9 @@ static void guest_code(void)
 		case GUEST_TEST_BP:
 			guest_bp_test();
 			break;
+		case GUEST_TEST_CR:
+			guest_cr_test();
+			break;
 		case GUEST_TEST_HYPERCALL:
 			guest_hypercall_test();
 			break;
@@ -1100,6 +1109,96 @@ static void test_cmd_vm_control_cleanup(struct kvm_vm *vm)
 	cmd_vm_control_cleanup(disable, 0);
 }
 
+static void cmd_vcpu_control_cr(struct kvm_vm *vm, __u8 cr, __u8 enable,
+				int expected_err)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vcpu_hdr vcpu_hdr;
+		struct kvmi_vcpu_control_cr cmd;
+	} req = {};
+
+	req.cmd.cr = cr;
+	req.cmd.enable = enable;
+
+	test_vcpu0_command(vm, KVMI_VCPU_CONTROL_CR, &req.hdr, sizeof(req),
+			   NULL, 0, expected_err);
+}
+
+static void enable_cr_events(struct kvm_vm *vm, __u8 cr)
+{
+	enable_vcpu_event(vm, KVMI_VCPU_EVENT_CR);
+
+	cmd_vcpu_control_cr(vm, cr, 1, 0);
+}
+
+static void disable_cr_events(struct kvm_vm *vm, __u8 cr)
+{
+	cmd_vcpu_control_cr(vm, cr, 0, 0);
+
+	disable_vcpu_event(vm, KVMI_VCPU_EVENT_CR);
+}
+
+static void test_invalid_vcpu_control_cr(struct kvm_vm *vm)
+{
+	__u8 enable = 1, enable_inval = 2;
+	__u8 cr_inval = 99, cr = 0;
+
+	cmd_vcpu_control_cr(vm, cr,       enable_inval, -KVM_EINVAL);
+	cmd_vcpu_control_cr(vm, cr_inval, enable,       -KVM_EINVAL);
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
+		struct vcpu_event vcpu_ev;
+		struct kvmi_vcpu_event_cr cr;
+	} ev;
+	struct {
+		struct vcpu_reply common;
+		struct kvmi_vcpu_event_cr_reply cr;
+	} rpl = {};
+	__u16 event_id = KVMI_VCPU_EVENT_CR;
+	__u8 cr_no = 4;
+	struct kvm_sregs sregs;
+	pthread_t vcpu_thread;
+
+	enable_cr_events(vm, cr_no);
+
+	vcpu_thread = start_vcpu_worker(&data);
+
+	receive_vcpu_event(&hdr, &ev.vcpu_ev, sizeof(ev), event_id);
+
+	pr_debug("CR%u, old 0x%llx, new 0x%llx\n",
+		 ev.cr.cr, ev.cr.old_value, ev.cr.new_value);
+
+	TEST_ASSERT(ev.cr.cr == cr_no,
+		"Unexpected CR event, received CR%u, expected CR%u",
+		ev.cr.cr, cr_no);
+
+	rpl.cr.new_val = ev.cr.old_value;
+
+	reply_to_event(&hdr, &ev.vcpu_ev, KVMI_EVENT_ACTION_CONTINUE,
+		       &rpl.common, sizeof(rpl));
+
+	wait_vcpu_worker(vcpu_thread);
+
+	disable_cr_events(vm, cr_no);
+
+	vcpu_sregs_get(vm, VCPU_ID, &sregs);
+	TEST_ASSERT(sregs.cr4 == ev.cr.old_value,
+		"Failed to block CR4 update, CR4 0x%llx, expected 0x%llx",
+		sregs.cr4, ev.cr.old_value);
+
+	test_invalid_vcpu_control_cr(vm);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	srandom(time(0));
@@ -1123,6 +1222,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_event_hypercall(vm);
 	test_event_breakpoint(vm);
 	test_cmd_vm_control_cleanup(vm);
+	test_cmd_vcpu_control_cr(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 8a266b058155..b1877a770fcb 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -69,6 +69,8 @@ int kvmi_add_job(struct kvm_vcpu *vcpu,
 void kvmi_run_jobs(struct kvm_vcpu *vcpu);
 void kvmi_handle_common_event_actions(struct kvm_vcpu *vcpu, u32 action);
 void kvmi_cmd_vm_control_cleanup(struct kvm_introspection *kvmi, bool enable);
+struct kvm_introspection * __must_check kvmi_get(struct kvm *kvm);
+void kvmi_put(struct kvm *kvm);
 int kvmi_cmd_vm_control_events(struct kvm_introspection *kvmi,
 			       u16 event_id, bool enable);
 int kvmi_cmd_vcpu_control_events(struct kvm_vcpu *vcpu,
