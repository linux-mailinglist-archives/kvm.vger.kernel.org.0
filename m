Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80E3642449F
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 19:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239377AbhJFRmp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 13:42:45 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53574 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238684AbhJFRmf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 13:42:35 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id CAFE130828BE;
        Wed,  6 Oct 2021 20:31:24 +0300 (EEST)
Received: from localhost (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id B15533064495;
        Wed,  6 Oct 2021 20:31:24 +0300 (EEST)
X-Is-Junk-Enabled: fGZTSsP0qEJE2AIKtlSuFiRRwg9xyHmJ
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v12 74/77] KVM: introspection: add KVMI_VCPU_EVENT_SINGLESTEP
Date:   Wed,  6 Oct 2021 20:31:10 +0300
Message-Id: <20211006173113.26445-75-alazar@bitdefender.com>
In-Reply-To: <20211006173113.26445-1-alazar@bitdefender.com>
References: <20211006173113.26445-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nicușor Cîțu <nicu.citu@icloud.com>

This event is sent after each instruction when the singlestep has been
enabled for a vCPU.

Signed-off-by: Nicușor Cîțu <nicu.citu@icloud.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 31 +++++++++++
 arch/x86/kvm/kvmi.c                           |  1 +
 arch/x86/kvm/kvmi_msg.c                       |  6 +++
 arch/x86/kvm/vmx/vmx.c                        |  6 +++
 include/linux/kvmi_host.h                     |  4 ++
 include/uapi/linux/kvmi.h                     |  6 +++
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 54 +++++++++++++++++--
 virt/kvm/introspection/kvmi.c                 | 43 +++++++++++++++
 virt/kvm/introspection/kvmi_int.h             |  1 +
 virt/kvm/introspection/kvmi_msg.c             | 17 ++++++
 10 files changed, 166 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 7f70345ebaac..84922d327255 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -565,6 +565,7 @@ because these are sent as a result of certain commands (but they can be
 disallowed by the device manager) ::
 
 	KVMI_VCPU_EVENT_PAUSE
+	KVMI_VCPU_EVENT_SINGLESTEP
 	KVMI_VCPU_EVENT_TRAP
 
 The VM events (e.g. *KVMI_VM_EVENT_UNHOOK*) are controlled with
@@ -1044,8 +1045,12 @@ Enables/disables singlestep for the selected vCPU.
 The introspection tool should use *KVMI_GET_VERSION*, to check
 if the hardware supports singlestep (see **KVMI_GET_VERSION**).
 
+After every instruction, a *KVMI_VCPU_EVENT_SINGLESTEP* event is sent
+to the introspection tool.
+
 :Errors:
 
+* -KVM_EPERM  - the *KVMI_VCPU_EVENT_SINGLESTEP* event is disallowed
 * -KVM_EOPNOTSUPP - the hardware doesn't support singlestep
 * -KVM_EINVAL - the padding is not zero
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
@@ -1489,3 +1494,29 @@ emulation).
 The *RETRY* action is used by the introspection tool to retry the
 execution of the current instruction, usually because it changed the
 instruction pointer or the page restrictions.
+
+11. KVMI_VCPU_EVENT_SINGLESTEP
+------------------------------
+
+:Architectures: x86
+:Versions: >= 1
+:Actions: CONTINUE, CRASH
+:Parameters:
+
+::
+
+	struct kvmi_vcpu_event;
+
+:Returns:
+
+::
+
+	struct kvmi_vcpu_hdr;
+	struct kvmi_vcpu_event_reply;
+	struct kvmi_vcpu_event_singlestep {
+		__u8 failed;
+		__u8 padding[7];
+	};
+
+This event is sent after each instruction, as long as the singlestep is
+enabled for the current vCPU (see **KVMI_VCPU_CONTROL_SINGLESTEP**).
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index e26a0eee1592..58c2debd8815 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -20,6 +20,7 @@ void kvmi_arch_init_vcpu_events_mask(unsigned long *supported)
 	set_bit(KVMI_VCPU_EVENT_DESCRIPTOR, supported);
 	set_bit(KVMI_VCPU_EVENT_MSR, supported);
 	set_bit(KVMI_VCPU_EVENT_PF, supported);
+	set_bit(KVMI_VCPU_EVENT_SINGLESTEP, supported);
 	set_bit(KVMI_VCPU_EVENT_TRAP, supported);
 	set_bit(KVMI_VCPU_EVENT_XSETBV, supported);
 }
diff --git a/arch/x86/kvm/kvmi_msg.c b/arch/x86/kvm/kvmi_msg.c
index 6d3980e18281..ea38eb7ccb7c 100644
--- a/arch/x86/kvm/kvmi_msg.c
+++ b/arch/x86/kvm/kvmi_msg.c
@@ -284,6 +284,12 @@ static int handle_vcpu_control_singlestep(const struct kvmi_vcpu_msg_job *job,
 	struct kvm_vcpu *vcpu = job->vcpu;
 	int ec = 0;
 
+	if (!kvmi_is_event_allowed(KVMI(vcpu->kvm),
+				   KVMI_VCPU_EVENT_SINGLESTEP)) {
+		ec = -KVM_EPERM;
+		goto reply;
+	}
+
 	if (non_zero_padding(req->padding, ARRAY_SIZE(req->padding)) ||
 	    req->enable > 1) {
 		ec = -KVM_EINVAL;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1df0a29d1d8d..4f5b04fb1ede 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5587,6 +5587,7 @@ static int handle_pause(struct kvm_vcpu *vcpu)
 
 static int handle_monitor_trap(struct kvm_vcpu *vcpu)
 {
+	kvmi_singlestep_done(vcpu);
 	return 1;
 }
 
@@ -6137,6 +6138,11 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 		}
 	}
 
+	if (kvmi_vcpu_running_singlestep(vcpu) &&
+	    exit_reason.basic != EXIT_REASON_EPT_VIOLATION &&
+	    exit_reason.basic != EXIT_REASON_MONITOR_TRAP_FLAG)
+		kvmi_singlestep_failed(vcpu);
+
 	if (exit_fastpath != EXIT_FASTPATH_NONE)
 		return 1;
 
diff --git a/include/linux/kvmi_host.h b/include/linux/kvmi_host.h
index e2103ab9d0d5..ec38e434c8e9 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -81,6 +81,8 @@ void kvmi_handle_requests(struct kvm_vcpu *vcpu);
 bool kvmi_hypercall_event(struct kvm_vcpu *vcpu);
 bool kvmi_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva, u8 insn_len);
 bool kvmi_vcpu_running_singlestep(struct kvm_vcpu *vcpu);
+void kvmi_singlestep_done(struct kvm_vcpu *vcpu);
+void kvmi_singlestep_failed(struct kvm_vcpu *vcpu);
 
 #else
 
@@ -97,6 +99,8 @@ static inline bool kvmi_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva,
 					 u8 insn_len) { return true; }
 static inline bool kvmi_vcpu_running_singlestep(struct kvm_vcpu *vcpu)
 			{ return false; }
+static inline void kvmi_singlestep_done(struct kvm_vcpu *vcpu) { }
+static inline void kvmi_singlestep_failed(struct kvm_vcpu *vcpu) { }
 
 #endif /* CONFIG_KVM_INTROSPECTION */
 
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 31bf2b6f3779..148d145ddea0 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -73,6 +73,7 @@ enum {
 	KVMI_VCPU_EVENT_DESCRIPTOR = KVMI_VCPU_EVENT_ID(6),
 	KVMI_VCPU_EVENT_MSR        = KVMI_VCPU_EVENT_ID(7),
 	KVMI_VCPU_EVENT_PF         = KVMI_VCPU_EVENT_ID(8),
+	KVMI_VCPU_EVENT_SINGLESTEP = KVMI_VCPU_EVENT_ID(9),
 
 	KVMI_NEXT_VCPU_EVENT
 };
@@ -222,4 +223,9 @@ struct kvmi_vcpu_control_singlestep {
 	__u8 padding[7];
 };
 
+struct kvmi_vcpu_event_singlestep {
+	__u8 failed;
+	__u8 padding[7];
+};
+
 #endif /* _UAPI__LINUX_KVMI_H */
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 1bd01115be31..faef908eeedd 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -1823,12 +1823,60 @@ static void cmd_vcpu_singlestep(struct kvm_vm *vm, __u8 enable,
 			   &req.hdr, sizeof(req), NULL, 0, expected_err);
 }
 
+static void __control_singlestep(bool enable)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vcpu_hdr vcpu_hdr;
+		struct kvmi_vcpu_control_singlestep cmd;
+	} req = {};
+	int r;
+
+	req.cmd.enable = enable ? 1 : 0;
+
+	r = __do_vcpu0_command(KVMI_VCPU_CONTROL_SINGLESTEP,
+			     &req.hdr, sizeof(req), NULL, 0);
+	TEST_ASSERT(r == 0,
+		"KVMI_VCPU_CONTROL_SINGLESTEP failed, error %d(%s)\n",
+		-r, kvm_strerror(-r));
+}
+
+static void test_singlestep_event(__u16 event_id)
+{
+	struct {
+		struct vcpu_event vcpu_ev;
+		struct kvmi_vcpu_event_singlestep singlestep;
+	} ev;
+	bool enable = true, disable = false;
+	struct vcpu_reply rpl = { };
+	struct kvmi_msg_hdr hdr;
+
+	__control_singlestep(enable);
+
+	receive_vcpu_event(&hdr, &ev.vcpu_ev, sizeof(ev), event_id);
+
+	pr_debug("SINGLESTEP event, rip 0x%llx success %d\n",
+		 ev.vcpu_ev.common.arch.regs.rip, !ev.singlestep.failed);
+	TEST_ASSERT(!ev.singlestep.failed, "Singlestep failed");
+
+	__control_singlestep(disable);
+
+	reply_to_event(&hdr, &ev.vcpu_ev, KVMI_EVENT_ACTION_CONTINUE,
+		       &rpl, sizeof(rpl));
+}
+
 static void test_supported_singlestep(struct kvm_vm *vm)
 {
-	__u8 disable = 0, enable = 1, enable_inval = 2;
+	struct vcpu_worker_data data = {.vm = vm, .vcpu_id = VCPU_ID };
+	__u16 event_id = KVMI_VCPU_EVENT_SINGLESTEP;
+	__u8 enable_inval = 2;
+	pthread_t vcpu_thread;
 
-	cmd_vcpu_singlestep(vm, enable, 0);
-	cmd_vcpu_singlestep(vm, disable, 0);
+	enable_vcpu_event(vm, event_id);
+	vcpu_thread = start_vcpu_worker(&data);
+	test_singlestep_event(event_id);
+	wait_vcpu_worker(vcpu_thread);
+	disable_vcpu_event(vm, event_id);
 
 	cmd_vcpu_singlestep(vm, enable_inval, -KVM_EINVAL);
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index c20c70547065..4ed145421d69 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -1194,3 +1194,46 @@ bool kvmi_vcpu_running_singlestep(struct kvm_vcpu *vcpu)
 	return ret;
 }
 EXPORT_SYMBOL(kvmi_vcpu_running_singlestep);
+
+static void kvmi_singlestep_event(struct kvm_vcpu *vcpu, bool success)
+{
+	u32 action;
+
+	action = kvmi_msg_send_vcpu_singlestep(vcpu, success);
+	switch (action) {
+	case KVMI_EVENT_ACTION_CONTINUE:
+		break;
+	default:
+		kvmi_handle_common_event_actions(vcpu, action);
+	}
+}
+
+static void kvmi_handle_singlestep_exit(struct kvm_vcpu *vcpu, bool success)
+{
+	struct kvm_vcpu_introspection *vcpui;
+	struct kvm_introspection *kvmi;
+	struct kvm *kvm = vcpu->kvm;
+
+	kvmi = kvmi_get(kvm);
+	if (!kvmi)
+		return;
+
+	vcpui = VCPUI(vcpu);
+
+	if (vcpui->singlestep.loop)
+		kvmi_singlestep_event(vcpu, success);
+
+	kvmi_put(kvm);
+}
+
+void kvmi_singlestep_done(struct kvm_vcpu *vcpu)
+{
+	kvmi_handle_singlestep_exit(vcpu, true);
+}
+EXPORT_SYMBOL(kvmi_singlestep_done);
+
+void kvmi_singlestep_failed(struct kvm_vcpu *vcpu)
+{
+	kvmi_handle_singlestep_exit(vcpu, false);
+}
+EXPORT_SYMBOL(kvmi_singlestep_failed);
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 4815fa61b136..5f4bcdf27d6a 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -64,6 +64,7 @@ u32 kvmi_msg_send_vcpu_pause(struct kvm_vcpu *vcpu);
 u32 kvmi_msg_send_vcpu_hypercall(struct kvm_vcpu *vcpu);
 u32 kvmi_msg_send_vcpu_bp(struct kvm_vcpu *vcpu, u64 gpa, u8 insn_len);
 u32 kvmi_msg_send_vcpu_pf(struct kvm_vcpu *vcpu, u64 gpa, u64 gva, u8 access);
+u32 kvmi_msg_send_vcpu_singlestep(struct kvm_vcpu *vcpu, bool success);
 
 /* kvmi.c */
 void *kvmi_msg_alloc(void);
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index e2aef76bfd16..f280a4b9fee3 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -883,3 +883,20 @@ u32 kvmi_msg_send_vcpu_pf(struct kvm_vcpu *vcpu, u64 gpa, u64 gva, u8 access)
 
 	return action;
 }
+
+u32 kvmi_msg_send_vcpu_singlestep(struct kvm_vcpu *vcpu, bool success)
+{
+	struct kvmi_vcpu_event_singlestep e;
+	u32 action;
+	int err;
+
+	memset(&e, 0, sizeof(e));
+	e.failed = success ? 0 : 1;
+
+	err = kvmi_send_vcpu_event(vcpu, KVMI_VCPU_EVENT_SINGLESTEP,
+				   &e, sizeof(e), NULL, 0, &action);
+	if (err)
+		return KVMI_EVENT_ACTION_CONTINUE;
+
+	return action;
+}
