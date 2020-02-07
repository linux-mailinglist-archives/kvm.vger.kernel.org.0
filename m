Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C039D155D9A
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727550AbgBGSRS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:17:18 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40730 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727756AbgBGSQ4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:56 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 01551305D369;
        Fri,  7 Feb 2020 20:16:42 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id E63643052069;
        Fri,  7 Feb 2020 20:16:41 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v7 75/78] KVM: introspection: add KVMI_EVENT_SINGLESTEP
Date:   Fri,  7 Feb 2020 20:16:33 +0200
Message-Id: <20200207181636.1065-76-alazar@bitdefender.com>
In-Reply-To: <20200207181636.1065-1-alazar@bitdefender.com>
References: <20200207181636.1065-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nicușor Cîțu <ncitu@bitdefender.com>

This event is sent when the current instruction has been single stepped
with or without success.

Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 28 +++++++
 arch/x86/kvm/vmx/vmx.c                        |  6 ++
 include/linux/kvmi_host.h                     |  4 +
 include/uapi/linux/kvmi.h                     |  6 ++
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 80 ++++++++++++++++---
 virt/kvm/introspection/kvmi.c                 | 61 ++++++++++++++
 virt/kvm/introspection/kvmi_int.h             |  1 +
 7 files changed, 177 insertions(+), 9 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index ffa183745722..3515fea1eb75 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -547,6 +547,7 @@ the following events::
 	KVMI_EVENT_HYPERCALL
 	KVMI_EVENT_MSR
 	KVMI_EVENT_PF
+	KVMI_EVENT_SINGLESTEP
 	KVMI_EVENT_TRAP
 	KVMI_EVENT_XSETBV
 
@@ -1352,3 +1353,30 @@ The *CONTINUE* action will continue the page fault handling via emulation.
 The *RETRY* action is used by the introspection tool to retry the
 execution of the current instruction, usually because it changed the
 instruction pointer or the page restrictions.
+
+11. KVMI_EVENT_SINGLESTEP
+-------------------------
+
+:Architectures: x86
+:Versions: >= 1
+:Actions: CONTINUE, CRASH
+:Parameters:
+
+::
+
+	struct kvmi_event;
+
+:Returns:
+
+::
+
+	struct kvmi_vcpu_hdr;
+	struct kvmi_event_reply;
+	struct kvmi_event_singlestep {
+		__u8 failed;
+		__u8 padding[7];
+	};
+
+This event is sent when the current instruction has been executed or the
+singlestep failed and the introspection has been enabled for this event
+(see **KVMI_VCPU_CONTROL_EVENTS**).
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2aaa74caefff..fece435ce743 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5439,6 +5439,7 @@ static int handle_invalid_op(struct kvm_vcpu *vcpu)
 
 static int handle_monitor_trap(struct kvm_vcpu *vcpu)
 {
+	kvmi_singlestep_done(vcpu);
 	return 1;
 }
 
@@ -5994,6 +5995,11 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
 		}
 	}
 
+	if (kvmi_vcpu_running_singlestep(vcpu) &&
+	    exit_reason != EXIT_REASON_EPT_VIOLATION &&
+	    exit_reason != EXIT_REASON_MONITOR_TRAP_FLAG)
+		kvmi_singlestep_failed(vcpu);
+
 	if (exit_reason < kvm_vmx_max_exit_handlers
 	    && kvm_vmx_exit_handlers[exit_reason]) {
 #ifdef CONFIG_RETPOLINE
diff --git a/include/linux/kvmi_host.h b/include/linux/kvmi_host.h
index 7c84ca681411..723a902f4b89 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -95,6 +95,8 @@ bool kvmi_hypercall_event(struct kvm_vcpu *vcpu);
 bool kvmi_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva, u8 insn_len);
 bool kvmi_enter_guest(struct kvm_vcpu *vcpu);
 bool kvmi_vcpu_running_singlestep(struct kvm_vcpu *vcpu);
+void kvmi_singlestep_done(struct kvm_vcpu *vcpu);
+void kvmi_singlestep_failed(struct kvm_vcpu *vcpu);
 
 #else
 
@@ -113,6 +115,8 @@ static inline bool kvmi_enter_guest(struct kvm_vcpu *vcpu)
 			{ return true; }
 static inline bool kvmi_vcpu_running_singlestep(struct kvm_vcpu *vcpu)
 			{ return false; }
+static void kvmi_singlestep_done(struct kvm_vcpu *vcpu) { }
+static void kvmi_singlestep_failed(struct kvm_vcpu *vcpu) { }
 
 #endif /* CONFIG_KVM_INTROSPECTION */
 
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index c6c5019ccf85..37c51e64d22c 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -59,6 +59,7 @@ enum {
 	KVMI_EVENT_DESCRIPTOR = 7,
 	KVMI_EVENT_MSR        = 8,
 	KVMI_EVENT_PF         = 9,
+	KVMI_EVENT_SINGLESTEP = 10,
 
 	KVMI_NUM_EVENTS
 };
@@ -199,4 +200,9 @@ struct kvmi_event_pf {
 	__u32 padding3;
 };
 
+struct kvmi_event_singlestep {
+	__u8 failed;
+	__u8 padding[7];
+};
+
 #endif /* _UAPI__LINUX_KVMI_H */
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 090cb7acd2ed..cf5edf91197d 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -738,6 +738,14 @@ static void stop_vcpu_worker(pthread_t vcpu_thread,
 	wait_vcpu_worker(vcpu_thread);
 }
 
+static int __do_vcpu_command(struct kvm_vm *vm, int cmd_id,
+			     struct kvmi_msg_hdr *req, size_t req_size,
+			     void *rpl, size_t rpl_size)
+{
+	send_message(cmd_id, req, req_size);
+	return receive_cmd_reply(req, rpl, rpl_size);
+}
+
 static int do_vcpu_command(struct kvm_vm *vm, int cmd_id,
 			   struct kvmi_msg_hdr *req, size_t req_size,
 			   void *rpl, size_t rpl_size)
@@ -748,13 +756,24 @@ static int do_vcpu_command(struct kvm_vm *vm, int cmd_id,
 
 	vcpu_thread = start_vcpu_worker(&data);
 
-	send_message(cmd_id, req, req_size);
-	r = receive_cmd_reply(req, rpl, rpl_size);
+	r = __do_vcpu_command(vm, cmd_id, req, req_size, rpl, rpl_size);
 
 	stop_vcpu_worker(vcpu_thread, &data);
 	return r;
 }
 
+static int __do_vcpu0_command(struct kvm_vm *vm, int cmd_id,
+			      struct kvmi_msg_hdr *req, size_t req_size,
+			      void *rpl, size_t rpl_size)
+{
+	struct kvmi_vcpu_hdr *vcpu_hdr = (struct kvmi_vcpu_hdr *)req;
+
+	vcpu_hdr->vcpu = 0;
+
+	send_message(cmd_id, req, req_size);
+	return receive_cmd_reply(req, rpl, rpl_size);
+}
+
 static int do_vcpu0_command(struct kvm_vm *vm, int cmd_id,
 			    struct kvmi_msg_hdr *req, size_t req_size,
 			    void *rpl, size_t rpl_size)
@@ -1681,24 +1700,67 @@ static void test_event_pf(struct kvm_vm *vm)
 	test_pf(vm, cbk_test_event_pf);
 }
 
-static void test_cmd_vcpu_control_singlestep(struct kvm_vm *vm)
+static void control_singlestep(struct kvm_vm *vm, bool enable)
 {
 	struct {
 		struct kvmi_msg_hdr hdr;
 		struct kvmi_vcpu_hdr vcpu_hdr;
 		struct kvmi_vcpu_control_singlestep cmd;
 	} req = {};
+	int r;
+
+	req.cmd.enable = enable;
+	r = __do_vcpu0_command(vm, KVMI_VCPU_CONTROL_SINGLESTEP,
+			       &req.hdr, sizeof(req), NULL, 0);
+	TEST_ASSERT(r == 0,
+		"KVMI_VCPU_CONTROL_SINGLESTEP failed, error %d (%s)\n",
+		-r, kvm_strerror(-r));
+}
+
+static void enable_singlestep(struct kvm_vm *vm)
+{
+	control_singlestep(vm, true);
+}
+
+static void disable_singlestep(struct kvm_vm *vm)
+{
+	control_singlestep(vm, false);
+}
+
+static void test_cmd_vcpu_control_singlestep(struct kvm_vm *vm)
+{
+	struct vcpu_worker_data data = { .vm = vm, .vcpu_id = VCPU_ID };
+	struct {
+		struct kvmi_event common;
+		struct kvmi_event_singlestep singlestep;
+	} ev;
+	__u16 event_id = KVMI_EVENT_SINGLESTEP;
+	struct vcpu_reply rpl = {};
+	struct kvmi_msg_hdr hdr;
+	pthread_t vcpu_thread;
 
 	if (!features.singlestep)
 		return;
 
-	req.cmd.enable = true;
-	test_vcpu0_command(vm, KVMI_VCPU_CONTROL_SINGLESTEP,
-			   &req.hdr, sizeof(req), NULL, 0);
+	enable_vcpu_event(vm, event_id);
+
+	vcpu_thread = start_vcpu_worker(&data);
+
+	enable_singlestep(vm);
+
+	receive_event(&hdr, &ev.common, sizeof(ev), event_id);
+
+	DEBUG("SINGLESTEP event, rip 0x%llx success %d\n",
+		ev.common.arch.regs.rip, !ev.singlestep.failed);
+
+	disable_singlestep(vm);
+
+	reply_to_event(&hdr, &ev.common, KVMI_EVENT_ACTION_CONTINUE,
+			&rpl, sizeof(rpl));
+
+	stop_vcpu_worker(vcpu_thread, &data);
 
-	req.cmd.enable = false;
-	test_vcpu0_command(vm, KVMI_VCPU_CONTROL_SINGLESTEP,
-			   &req.hdr, sizeof(req), NULL, 0);
+	disable_vcpu_event(vm, KVMI_EVENT_SINGLESTEP);
 }
 
 static void test_introspection(struct kvm_vm *vm)
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index b798eeab6618..5bb3e1252242 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -1319,3 +1319,64 @@ bool kvmi_vcpu_running_singlestep(struct kvm_vcpu *vcpu)
 	return ret;
 }
 EXPORT_SYMBOL(kvmi_vcpu_running_singlestep);
+
+static u32 kvmi_send_singlestep(struct kvm_vcpu *vcpu, bool success)
+{
+	struct kvmi_event_singlestep e;
+	int err, action;
+
+	memset(&e, 0, sizeof(e));
+	e.failed = success ? 0 : 1;
+
+	err = kvmi_send_event(vcpu, KVMI_EVENT_SINGLESTEP, &e, sizeof(e),
+			      NULL, 0, &action);
+	if (err)
+		return KVMI_EVENT_ACTION_CONTINUE;
+
+	return action;
+}
+
+static void __kvmi_singlestep_event(struct kvm_vcpu *vcpu, bool success)
+{
+	struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
+	u32 action;
+
+	if (!vcpui->singlestep.loop)
+		return;
+
+	action = kvmi_send_singlestep(vcpu, success);
+	switch (action) {
+	case KVMI_EVENT_ACTION_CONTINUE:
+		break;
+	default:
+		kvmi_handle_common_event_actions(vcpu->kvm, action,
+						"SINGLESTEP");
+	}
+}
+
+static void kvmi_singlestep_event(struct kvm_vcpu *vcpu, bool success)
+{
+	struct kvm_introspection *kvmi;
+	struct kvm *kvm = vcpu->kvm;
+
+	kvmi = kvmi_get(kvm);
+	if (!kvmi)
+		return;
+
+	if (is_event_enabled(vcpu, KVMI_EVENT_SINGLESTEP))
+		__kvmi_singlestep_event(vcpu, success);
+
+	kvmi_put(kvm);
+}
+
+void kvmi_singlestep_done(struct kvm_vcpu *vcpu)
+{
+	kvmi_singlestep_event(vcpu, true);
+}
+EXPORT_SYMBOL(kvmi_singlestep_done);
+
+void kvmi_singlestep_failed(struct kvm_vcpu *vcpu)
+{
+	kvmi_singlestep_event(vcpu, false);
+}
+EXPORT_SYMBOL(kvmi_singlestep_failed);
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 64425ff16c7d..ccd99dfddf31 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -30,6 +30,7 @@
 			  | BIT(KVMI_EVENT_TRAP) \
 			  | BIT(KVMI_EVENT_PAUSE_VCPU) \
 			  | BIT(KVMI_EVENT_PF) \
+			  | BIT(KVMI_EVENT_SINGLESTEP) \
 			  | BIT(KVMI_EVENT_XSETBV) \
 		)
 
