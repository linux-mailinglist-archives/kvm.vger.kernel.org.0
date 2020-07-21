Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14A67228AF9
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731447AbgGUVSf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:18:35 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37844 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731209AbgGUVP6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:15:58 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 0FE58305D509;
        Wed, 22 Jul 2020 00:09:32 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id DE647304FA14;
        Wed, 22 Jul 2020 00:09:31 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 81/84] KVM: introspection: add KVMI_EVENT_SINGLESTEP
Date:   Wed, 22 Jul 2020 00:09:19 +0300
Message-Id: <20200721210922.7646-82-alazar@bitdefender.com>
In-Reply-To: <20200721210922.7646-1-alazar@bitdefender.com>
References: <20200721210922.7646-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nicușor Cîțu <ncitu@bitdefender.com>

This event is sent after each instruction when the singlestep has been
enabled for a vCPU.

Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 31 +++++++++
 arch/x86/kvm/vmx/vmx.c                        |  6 ++
 include/linux/kvmi_host.h                     |  4 ++
 include/uapi/linux/kvmi.h                     |  6 ++
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 65 +++++++++++++++++--
 virt/kvm/introspection/kvmi.c                 | 60 +++++++++++++++++
 virt/kvm/introspection/kvmi_msg.c             |  5 ++
 7 files changed, 172 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 0a07ef101302..3c481c1b2186 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -576,6 +576,7 @@ because these are sent as a result of certain commands (but they can be
 disallowed by the device manager) ::
 
 	KVMI_EVENT_PAUSE_VCPU
+	KVMI_EVENT_SINGLESTEP
 	KVMI_EVENT_TRAP
 
 The VM events (e.g. *KVMI_EVENT_UNHOOK*) are controlled with
@@ -1075,8 +1076,12 @@ Enables/disables singlestep for the selected vCPU.
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
@@ -1481,3 +1486,29 @@ emulation).
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
+This event is sent after each instruction, as long as the singlestep is
+enabled for the current vCPU (see **KVMI_VCPU_CONTROL_SINGLESTEP**).
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f57587ddb3be..8c9ccd1ba0f0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5598,6 +5598,7 @@ static int handle_invalid_op(struct kvm_vcpu *vcpu)
 
 static int handle_monitor_trap(struct kvm_vcpu *vcpu)
 {
+	kvmi_singlestep_done(vcpu);
 	return 1;
 }
 
@@ -6173,6 +6174,11 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 		}
 	}
 
+	if (kvmi_vcpu_running_singlestep(vcpu) &&
+	    exit_reason != EXIT_REASON_EPT_VIOLATION &&
+	    exit_reason != EXIT_REASON_MONITOR_TRAP_FLAG)
+		kvmi_singlestep_failed(vcpu);
+
 	if (exit_fastpath != EXIT_FASTPATH_NONE)
 		return 1;
 
diff --git a/include/linux/kvmi_host.h b/include/linux/kvmi_host.h
index a641768027cc..b01e8505f493 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -94,6 +94,8 @@ bool kvmi_hypercall_event(struct kvm_vcpu *vcpu);
 bool kvmi_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva, u8 insn_len);
 bool kvmi_enter_guest(struct kvm_vcpu *vcpu);
 bool kvmi_vcpu_running_singlestep(struct kvm_vcpu *vcpu);
+void kvmi_singlestep_done(struct kvm_vcpu *vcpu);
+void kvmi_singlestep_failed(struct kvm_vcpu *vcpu);
 
 #else
 
@@ -112,6 +114,8 @@ static inline bool kvmi_enter_guest(struct kvm_vcpu *vcpu)
 			{ return true; }
 static inline bool kvmi_vcpu_running_singlestep(struct kvm_vcpu *vcpu)
 			{ return false; }
+static inline void kvmi_singlestep_done(struct kvm_vcpu *vcpu) { }
+static inline void kvmi_singlestep_failed(struct kvm_vcpu *vcpu) { }
 
 #endif /* CONFIG_KVM_INTROSPECTION */
 
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index bc515237612a..040049abd450 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -63,6 +63,7 @@ enum {
 	KVMI_EVENT_DESCRIPTOR = 7,
 	KVMI_EVENT_MSR        = 8,
 	KVMI_EVENT_PF         = 9,
+	KVMI_EVENT_SINGLESTEP = 10,
 
 	KVMI_NUM_EVENTS
 };
@@ -236,4 +237,9 @@ struct kvmi_event_pf {
 	__u32 padding3;
 };
 
+struct kvmi_event_singlestep {
+	__u8 failed;
+	__u8 padding[7];
+};
+
 #endif /* _UAPI__LINUX_KVMI_H */
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 0803d7e5af1e..967ea568d93c 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -829,6 +829,14 @@ static void stop_vcpu_worker(pthread_t vcpu_thread,
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
@@ -839,8 +847,7 @@ static int do_vcpu_command(struct kvm_vm *vm, int cmd_id,
 
 	vcpu_thread = start_vcpu_worker(&data);
 
-	send_message(cmd_id, req, req_size);
-	r = receive_cmd_reply(req, rpl, rpl_size);
+	r = __do_vcpu_command(vm, cmd_id, req, req_size, rpl, rpl_size);
 
 	stop_vcpu_worker(vcpu_thread, &data);
 	return r;
@@ -1960,13 +1967,61 @@ static void cmd_vcpu_singlestep(struct kvm_vm *vm, __u8 enable, __u8 padding,
 		-r, kvm_strerror(-r), expected_err);
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
+		struct kvmi_event common;
+		struct kvmi_event_singlestep singlestep;
+	} ev;
+	bool enable = true, disable = false;
+	struct vcpu_reply rpl = { };
+	struct kvmi_msg_hdr hdr;
+
+	__control_singlestep(enable);
+
+	receive_event(&hdr, &ev.common, sizeof(ev), event_id);
+
+	pr_info("SINGLESTEP event, rip 0x%llx success %d\n",
+		ev.common.arch.regs.rip, !ev.singlestep.failed);
+	TEST_ASSERT(!ev.singlestep.failed, "Singlestep failed");
+
+	__control_singlestep(disable);
+
+	reply_to_event(&hdr, &ev.common, KVMI_EVENT_ACTION_CONTINUE,
+		       &rpl, sizeof(rpl));
+}
+
 static void test_supported_singlestep(struct kvm_vm *vm)
 {
-	__u8 disable = 0, enable = 1, enable_inval = 2;
+	struct vcpu_worker_data data = {.vm = vm, .vcpu_id = VCPU_ID };
+	__u16 event_id = KVMI_EVENT_SINGLESTEP;
+	__u8 enable = 1, enable_inval = 2;
 	__u8 padding = 1, no_padding = 0;
+	pthread_t vcpu_thread;
 
-	cmd_vcpu_singlestep(vm, enable, no_padding, 0);
-	cmd_vcpu_singlestep(vm, disable, no_padding, 0);
+	enable_vcpu_event(vm, event_id);
+	vcpu_thread = start_vcpu_worker(&data);
+	test_singlestep_event(event_id);
+	stop_vcpu_worker(vcpu_thread, &data);
+	disable_vcpu_event(vm, event_id);
 
 	cmd_vcpu_singlestep(vm, enable, padding, -KVM_EINVAL);
 	cmd_vcpu_singlestep(vm, enable_inval, no_padding, -KVM_EINVAL);
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 2c7533a966f9..5382569b190b 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -114,6 +114,7 @@ static void setup_known_events(void)
 	set_bit(KVMI_EVENT_MSR, Kvmi_known_vcpu_events);
 	set_bit(KVMI_EVENT_PAUSE_VCPU, Kvmi_known_vcpu_events);
 	set_bit(KVMI_EVENT_PF, Kvmi_known_vcpu_events);
+	set_bit(KVMI_EVENT_SINGLESTEP, Kvmi_known_vcpu_events);
 	set_bit(KVMI_EVENT_TRAP, Kvmi_known_vcpu_events);
 	set_bit(KVMI_EVENT_XSETBV, Kvmi_known_vcpu_events);
 
@@ -1321,3 +1322,62 @@ bool kvmi_vcpu_running_singlestep(struct kvm_vcpu *vcpu)
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
+		kvmi_handle_common_event_actions(vcpu->kvm, action);
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
index 04e7511a9777..645debc47f13 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -626,6 +626,11 @@ static int handle_vcpu_control_singlestep(const struct kvmi_vcpu_msg_job *job,
 		if (req->padding[i])
 			goto reply;
 
+	if (!is_event_allowed(KVMI(vcpu->kvm), KVMI_EVENT_SINGLESTEP)) {
+		ec = -KVM_EPERM;
+		goto reply;
+	}
+
 	if (req->enable)
 		done = kvmi_arch_start_singlestep(vcpu);
 	else
