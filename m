Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82CC0197916
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729632AbgC3KVV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:21:21 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:43780 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729440AbgC3KT7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 06:19:59 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 3FBD4305D3D4;
        Mon, 30 Mar 2020 13:13:02 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id E41EF305B7A7;
        Mon, 30 Mar 2020 13:13:01 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v8 78/81] KVM: introspection: add KVMI_EVENT_SINGLESTEP
Date:   Mon, 30 Mar 2020 13:13:05 +0300
Message-Id: <20200330101308.21702-79-alazar@bitdefender.com>
In-Reply-To: <20200330101308.21702-1-alazar@bitdefender.com>
References: <20200330101308.21702-1-alazar@bitdefender.com>
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
 Documentation/virt/kvm/kvmi.rst               | 32 ++++++++
 arch/x86/kvm/vmx/vmx.c                        |  6 ++
 include/linux/kvmi_host.h                     |  4 +
 include/uapi/linux/kvmi.h                     |  6 ++
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 80 ++++++++++++++++---
 virt/kvm/introspection/kvmi.c                 | 61 ++++++++++++++
 virt/kvm/introspection/kvmi_msg.c             |  5 ++
 7 files changed, 185 insertions(+), 9 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 5e013ee4a79b..c761438801dd 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -572,6 +572,7 @@ The following vCPU events do not need to be enabled or disabled,
 because these are sent as a result of certain commands::
 
 	KVMI_EVENT_PAUSE_VCPU
+	KVMI_EVENT_SINGLESTEP
 	KVMI_EVENT_TRAP
 
 However, the events mentioned above can be disallowed.
@@ -980,8 +981,12 @@ Enables/disables singlestep for the selected vCPU.
 The introspection tool should use *KVMI_GET_VERSION*, to check
 if the hardware supports singlestep (see **KVMI_GET_VERSION**).
 
+After every instruction, a *KVMI_EVENT_SINGLESTEP* event is sent
+to the introspection tool.
+
 :Errors:
 
+* -KVM_EPERM  - the *KVMI_EVENT_SINGLESTEP* event is disallowed
 * -KVM_EOPNOTSUPP - the hardware doesn't support singlestep
 * -KVM_EINVAL - the padding is not zero
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
@@ -1375,3 +1380,30 @@ The *CONTINUE* action will continue the page fault handling via emulation.
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
+This event is sent when the current instruction has been executed or
+failed and the singlestep has been enabled for the selected vCPU
+(see **KVMI_VCPU_CONTROL_SINGLESTEP**).
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fd748c165e78..baae118f1cdc 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5464,6 +5464,7 @@ static int handle_invalid_op(struct kvm_vcpu *vcpu)
 
 static int handle_monitor_trap(struct kvm_vcpu *vcpu)
 {
+	kvmi_singlestep_done(vcpu);
 	return 1;
 }
 
@@ -6025,6 +6026,11 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu,
 		return 1;
 	}
 
+	if (kvmi_vcpu_running_singlestep(vcpu) &&
+	    exit_reason != EXIT_REASON_EPT_VIOLATION &&
+	    exit_reason != EXIT_REASON_MONITOR_TRAP_FLAG)
+		kvmi_singlestep_failed(vcpu);
+
 	if (exit_reason >= kvm_vmx_max_exit_handlers)
 		goto unexpected_vmexit;
 #ifdef CONFIG_RETPOLINE
diff --git a/include/linux/kvmi_host.h b/include/linux/kvmi_host.h
index 23784611996e..58a30c087d63 100644
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
+static inline void kvmi_singlestep_done(struct kvm_vcpu *vcpu) { }
+static inline void kvmi_singlestep_failed(struct kvm_vcpu *vcpu) { }
 
 #endif /* CONFIG_KVM_INTROSPECTION */
 
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 97c4ef67bfe4..d69735918fd6 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -58,6 +58,7 @@ enum {
 	KVMI_EVENT_DESCRIPTOR = 7,
 	KVMI_EVENT_MSR        = 8,
 	KVMI_EVENT_PF         = 9,
+	KVMI_EVENT_SINGLESTEP = 10,
 
 	KVMI_NUM_EVENTS
 };
@@ -209,4 +210,9 @@ struct kvmi_event_pf {
 	__u32 padding3;
 };
 
+struct kvmi_event_singlestep {
+	__u8 failed;
+	__u8 padding[7];
+};
+
 #endif /* _UAPI__LINUX_KVMI_H */
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 27642000c4e4..24dfcba113cd 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -745,6 +745,14 @@ static void stop_vcpu_worker(pthread_t vcpu_thread,
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
@@ -755,13 +763,24 @@ static int do_vcpu_command(struct kvm_vm *vm, int cmd_id,
 
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
@@ -1668,26 +1687,69 @@ static void test_event_pf(struct kvm_vm *vm)
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
 
 	if (!features.singlestep) {
 		DEBUG("Skip %s()\n", __func__);
 		return;
 	}
 
-	req.cmd.enable = true;
-	test_vcpu0_command(vm, KVMI_VCPU_CONTROL_SINGLESTEP,
-			   &req.hdr, sizeof(req), NULL, 0);
+	enable_vcpu_event(vm, event_id);
 
-	req.cmd.enable = false;
-	test_vcpu0_command(vm, KVMI_VCPU_CONTROL_SINGLESTEP,
-			   &req.hdr, sizeof(req), NULL, 0);
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
+
+	disable_vcpu_event(vm, KVMI_EVENT_SINGLESTEP);
 }
 
 static void test_introspection(struct kvm_vm *vm)
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 90e6c2d3dd4f..8a73fac287b4 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -110,6 +110,7 @@ static void setup_known_events(void)
 	set_bit(KVMI_EVENT_MSR, Kvmi_known_vcpu_events);
 	set_bit(KVMI_EVENT_PAUSE_VCPU, Kvmi_known_vcpu_events);
 	set_bit(KVMI_EVENT_PF, Kvmi_known_vcpu_events);
+	set_bit(KVMI_EVENT_SINGLESTEP, Kvmi_known_vcpu_events);
 	set_bit(KVMI_EVENT_TRAP, Kvmi_known_vcpu_events);
 	set_bit(KVMI_EVENT_XSETBV, Kvmi_known_vcpu_events);
 
@@ -1320,3 +1321,63 @@ bool kvmi_vcpu_running_singlestep(struct kvm_vcpu *vcpu)
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
+static void kvmi_singlestep_event(struct kvm_vcpu *vcpu, bool success)
+{
+	u32 action;
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
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 14c063869c29..43762e4b7c5c 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -630,6 +630,11 @@ static int handle_vcpu_control_singlestep(const struct kvmi_vcpu_cmd_job *job,
 	bool done;
 	int i;
 
+	if (!is_event_allowed(KVMI(vcpu->kvm), KVMI_EVENT_SINGLESTEP)) {
+		ec = -KVM_EPERM;
+		goto reply;
+	}
+
 	for (i = 0; i < sizeof(req->padding); i++)
 		if (req->padding[i])
 			goto reply;
