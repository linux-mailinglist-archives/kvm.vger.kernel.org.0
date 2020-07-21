Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E63E8228AAD
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731404AbgGUVQ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:16:26 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37982 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731397AbgGUVQT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:16:19 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 4989F305D59A;
        Wed, 22 Jul 2020 00:09:27 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 29330304FA14;
        Wed, 22 Jul 2020 00:09:27 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 52/84] KVM: introspection: add KVMI_VCPU_PAUSE
Date:   Wed, 22 Jul 2020 00:08:50 +0300
Message-Id: <20200721210922.7646-53-alazar@bitdefender.com>
In-Reply-To: <20200721210922.7646-1-alazar@bitdefender.com>
References: <20200721210922.7646-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is the only vCPU command handled by the receiving thread.
It increments a pause requests counter and kicks the vCPU out of guest.

The introspection tool can pause a VM by sending this command to all
vCPUs. If it sets 'wait=1', it can consider that the VM is paused when
it receives the reply for last KVMI_VCPU_PAUSE command.

Usually, a vCPU command is dispatched to the vCPU thread after being read
from socket. This new command only signals the vCPU. Once out of guest,
the vCPU will send the event that caused the VM-exist (if it is the case),
handle the queued commands and only then checks its pause counter in
order to send the pause events requested by the introspection tool.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 66 ++++++++++++++++++-
 include/linux/kvmi_host.h                     |  2 +
 include/uapi/linux/kvmi.h                     | 11 +++-
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 53 +++++++++++++++
 virt/kvm/introspection/kvmi.c                 | 63 ++++++++++++++++--
 virt/kvm/introspection/kvmi_int.h             |  1 +
 virt/kvm/introspection/kvmi_msg.c             | 42 ++++++++++++
 7 files changed, 232 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 5ead29a7b2a7..502ee06d5e77 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -480,12 +480,52 @@ Returns the TSC frequency (in HZ) for the specified vCPU if available
 * -KVM_EINVAL - the selected vCPU is invalid
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
 
+9. KVMI_VCPU_PAUSE
+------------------
+
+:Architecture: all
+:Versions: >= 1
+:Parameters:
+
+::
+
+	struct kvmi_vcpu_hdr;
+	struct kvmi_vcpu_pause {
+		__u8 wait;
+		__u8 padding1;
+		__u16 padding2;
+		__u32 padding3;
+	};
+
+:Returns:
+
+::
+
+	struct kvmi_error_code;
+
+Kicks the vCPU out of guest.
+
+If `wait` is 1, the command will wait for vCPU to acknowledge the IPI.
+
+The vCPU will handle the pending commands/events and send the
+*KVMI_EVENT_PAUSE_VCPU* event (one for every successful *KVMI_VCPU_PAUSE*
+command) before returning to guest.
+
+:Errors:
+
+* -KVM_EINVAL - the padding is not zero
+* -KVM_EINVAL - the selected vCPU is invalid
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+* -KVM_EBUSY  - the selected vCPU has too many queued
+                *KVMI_EVENT_PAUSE_VCPU* events
+* -KVM_EPERM  - the *KVMI_EVENT_PAUSE_VCPU* event is disallowed
+
 Events
 ======
 
 All introspection events (VM or vCPU related) are sent
 using the *KVMI_EVENT* message id. No event will be sent unless
-it is explicitly enabled.
+it is explicitly enabled or requested (eg. *KVMI_EVENT_PAUSE_VCPU*).
 
 The *KVMI_EVENT_UNHOOK* event doesn't have a reply and share the kvmi_event
 structure, for consistency with the vCPU events.
@@ -544,3 +584,27 @@ the guest (see **Unhooking**) and the introspection has been enabled
 for this event (see **KVMI_VM_CONTROL_EVENTS**). The introspection tool
 has a chance to unhook and close the KVMI channel (signaling that the
 operation can proceed).
+
+2. KVMI_EVENT_PAUSE_VCPU
+------------------------
+
+:Architectures: all
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
+
+This event is sent in response to a *KVMI_VCPU_PAUSE* command.
+Because it has a low priority, it will be sent after any other vCPU
+introspection event and when no other vCPU introspection command is
+queued.
diff --git a/include/linux/kvmi_host.h b/include/linux/kvmi_host.h
index 956b8d5c51e3..fdb8ce6fe6a5 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -18,6 +18,8 @@ struct kvm_vcpu_introspection {
 
 	struct list_head job_list;
 	spinlock_t job_lock;
+
+	atomic_t pause_requests;
 };
 
 struct kvm_introspection {
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index a3dca420c887..3ded22020bef 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -26,12 +26,14 @@ enum {
 	KVMI_VM_WRITE_PHYSICAL = 7,
 
 	KVMI_VCPU_GET_INFO     = 8,
+	KVMI_VCPU_PAUSE        = 9,
 
 	KVMI_NUM_MESSAGES
 };
 
 enum {
-	KVMI_EVENT_UNHOOK = 0,
+	KVMI_EVENT_UNHOOK     = 0,
+	KVMI_EVENT_PAUSE_VCPU = 1,
 
 	KVMI_NUM_EVENTS
 };
@@ -107,6 +109,13 @@ struct kvmi_vcpu_hdr {
 	__u32 padding2;
 };
 
+struct kvmi_vcpu_pause {
+	__u8 wait;
+	__u8 padding1;
+	__u16 padding2;
+	__u32 padding3;
+};
+
 struct kvmi_event {
 	__u16 size;
 	__u16 vcpu;
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 107661fbe52f..0df890b4b440 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -691,6 +691,17 @@ static int do_vcpu_command(struct kvm_vm *vm, int cmd_id,
 	return r;
 }
 
+static int __do_vcpu0_command(int cmd_id, struct kvmi_msg_hdr *req,
+			      size_t req_size, void *rpl, size_t rpl_size)
+{
+	struct kvmi_vcpu_hdr *vcpu_hdr = (struct kvmi_vcpu_hdr *)(req + 1);
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
@@ -736,6 +747,47 @@ static void test_cmd_vcpu_get_info(struct kvm_vm *vm)
 		-r, kvm_strerror(-r));
 }
 
+static void cmd_vcpu_pause(__u8 wait, __u8 padding, int expected_err)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vcpu_hdr vcpu_hdr;
+		struct kvmi_vcpu_pause cmd;
+	} req = {};
+	int r;
+
+	req.cmd.wait = wait;
+	req.cmd.padding1 = padding;
+	req.cmd.padding2 = padding;
+	req.cmd.padding3 = padding;
+
+	r = __do_vcpu0_command(KVMI_VCPU_PAUSE, &req.hdr, sizeof(req), NULL, 0);
+	TEST_ASSERT(r == expected_err,
+		"KVMI_VCPU_PAUSE failed, error %d (%s), expected error %d\n",
+		-r, kvm_strerror(-r), expected_err);
+}
+
+static void pause_vcpu(void)
+{
+	cmd_vcpu_pause(1, 0, 0);
+}
+
+static void test_pause(struct kvm_vm *vm)
+{
+	__u8 no_wait = 0, wait = 1, wait_inval = 2;
+	__u8 padding = 1, no_padding = 0;
+
+	pause_vcpu();
+
+	cmd_vcpu_pause(wait, no_padding, 0);
+	cmd_vcpu_pause(wait_inval, no_padding, -KVM_EINVAL);
+	cmd_vcpu_pause(no_wait, padding, -KVM_EINVAL);
+
+	disallow_event(vm, KVMI_EVENT_PAUSE_VCPU);
+	cmd_vcpu_pause(no_wait, no_padding, -KVM_EPERM);
+	allow_event(vm, KVMI_EVENT_PAUSE_VCPU);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	srandom(time(0));
@@ -751,6 +803,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vm_control_events(vm);
 	test_memory_access(vm);
 	test_cmd_vcpu_get_info(vm);
+	test_pause(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index a9d406f276f5..a704e05b3184 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -12,6 +12,8 @@
 #define KVMI_NUM_COMMANDS KVMI_NUM_MESSAGES
 #define KVMI_MSG_SIZE_ALLOC (sizeof(struct kvmi_msg_hdr) + KVMI_MSG_SIZE)
 
+#define MAX_PAUSE_REQUESTS 1001
+
 static DECLARE_BITMAP(Kvmi_always_allowed_commands, KVMI_NUM_COMMANDS);
 static DECLARE_BITMAP(Kvmi_known_events, KVMI_NUM_EVENTS);
 static DECLARE_BITMAP(Kvmi_known_vm_events, KVMI_NUM_EVENTS);
@@ -90,6 +92,7 @@ static void setup_known_events(void)
 	set_bit(KVMI_EVENT_UNHOOK, Kvmi_known_vm_events);
 
 	bitmap_zero(Kvmi_known_vcpu_events, KVMI_NUM_EVENTS);
+	set_bit(KVMI_EVENT_PAUSE_VCPU, Kvmi_known_vcpu_events);
 
 	bitmap_or(Kvmi_known_events, Kvmi_known_vm_events,
 		  Kvmi_known_vcpu_events, KVMI_NUM_EVENTS);
@@ -113,10 +116,14 @@ void kvmi_uninit(void)
 	kvmi_cache_destroy();
 }
 
-static void kvmi_make_request(struct kvm_vcpu *vcpu)
+static void kvmi_make_request(struct kvm_vcpu *vcpu, bool wait)
 {
 	kvm_make_request(KVM_REQ_INTROSPECTION, vcpu);
-	kvm_vcpu_kick(vcpu);
+
+	if (wait)
+		kvm_vcpu_kick_and_wait(vcpu);
+	else
+		kvm_vcpu_kick(vcpu);
 }
 
 static int __kvmi_add_job(struct kvm_vcpu *vcpu,
@@ -151,7 +158,7 @@ int kvmi_add_job(struct kvm_vcpu *vcpu,
 	err = __kvmi_add_job(vcpu, fct, ctx, free_fct);
 
 	if (!err)
-		kvmi_make_request(vcpu);
+		kvmi_make_request(vcpu, false);
 
 	return err;
 }
@@ -346,6 +353,22 @@ static int __kvmi_hook(struct kvm *kvm,
 	return 0;
 }
 
+static void kvmi_job_release_vcpu(struct kvm_vcpu *vcpu, void *ctx)
+{
+	struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
+
+	atomic_set(&vcpui->pause_requests, 0);
+}
+
+static void kvmi_release_vcpus(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu;
+	int i;
+
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		kvmi_add_job(vcpu, kvmi_job_release_vcpu, NULL, NULL);
+}
+
 static int kvmi_recv_thread(void *arg)
 {
 	struct kvm_introspection *kvmi = arg;
@@ -359,6 +382,8 @@ static int kvmi_recv_thread(void *arg)
 	 */
 	kvmi_sock_shutdown(kvmi);
 
+	kvmi_release_vcpus(kvmi->kvm);
+
 	kvmi_put(kvmi->kvm);
 	return 0;
 }
@@ -718,15 +743,45 @@ void kvmi_run_jobs(struct kvm_vcpu *vcpu)
 	}
 }
 
+static void kvmi_vcpu_pause_event(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
+
+	atomic_dec(&vcpui->pause_requests);
+	/* to be implemented */
+}
+
 void kvmi_handle_requests(struct kvm_vcpu *vcpu)
 {
+	struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
 	struct kvm_introspection *kvmi;
 
 	kvmi = kvmi_get(vcpu->kvm);
 	if (!kvmi)
 		return;
 
-	kvmi_run_jobs(vcpu);
+	for (;;) {
+		kvmi_run_jobs(vcpu);
+
+		if (atomic_read(&vcpui->pause_requests))
+			kvmi_vcpu_pause_event(vcpu);
+		else
+			break;
+	}
 
 	kvmi_put(vcpu->kvm);
 }
+
+int kvmi_cmd_vcpu_pause(struct kvm_vcpu *vcpu, bool wait)
+{
+	struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
+
+	if (atomic_read(&vcpui->pause_requests) > MAX_PAUSE_REQUESTS)
+		return -KVM_EBUSY;
+
+	atomic_inc(&vcpui->pause_requests);
+
+	kvmi_make_request(vcpu, wait);
+
+	return 0;
+}
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 42803b6d0e81..cb99cb3db396 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -46,6 +46,7 @@ int kvmi_cmd_read_physical(struct kvm *kvm, u64 gpa, size_t size,
 			   const struct kvmi_msg_hdr *ctx);
 int kvmi_cmd_write_physical(struct kvm *kvm, u64 gpa, size_t size,
 			    const void *buf);
+int kvmi_cmd_vcpu_pause(struct kvm_vcpu *vcpu, bool wait);
 
 /* arch */
 int kvmi_arch_cmd_vcpu_get_info(struct kvm_vcpu *vcpu,
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index ee25ba44fb0b..1adec838cddd 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -264,12 +264,54 @@ static int handle_vm_write_physical(struct kvm_introspection *kvmi,
 	return kvmi_msg_vm_reply(kvmi, msg, ec, NULL, 0);
 }
 
+/*
+ * This vCPU command is handled by the receiving thread instead of
+ * the vCPU thread in order to make it easier for the introspection tool
+ * to implement a 'pause VM' command by sending a 'pause vCPU' command
+ * for every vCPU. It can consider that the VM has stopped
+ * once it receives the reply for the last 'pause vCPU' command.
+ */
+static int handle_vcpu_pause(struct kvm_introspection *kvmi,
+			     const struct kvmi_msg_hdr *msg,
+			     const void *_req)
+{
+	const struct kvmi_vcpu_hdr *vcpu_hdr = _req;
+	const struct kvmi_vcpu_pause *vcpu_req;
+	struct kvm_vcpu *vcpu = NULL;
+	int err;
+
+	vcpu_req = (const struct kvmi_vcpu_pause *) (vcpu_hdr + 1);
+
+	if (invalid_vcpu_hdr(vcpu_hdr) || vcpu_req->wait > 1) {
+		err = -KVM_EINVAL;
+		goto reply;
+	}
+
+	if (vcpu_req->padding1 || vcpu_req->padding2 || vcpu_req->padding3) {
+		err = -KVM_EINVAL;
+		goto reply;
+	}
+
+	if (!is_event_allowed(kvmi, KVMI_EVENT_PAUSE_VCPU)) {
+		err = -KVM_EPERM;
+		goto reply;
+	}
+
+	err = kvmi_get_vcpu(kvmi, vcpu_hdr->vcpu, &vcpu);
+	if (!err)
+		err = kvmi_cmd_vcpu_pause(vcpu, vcpu_req->wait == 1);
+
+reply:
+	return kvmi_msg_vm_reply(kvmi, msg, err, NULL, 0);
+}
+
 /*
  * These commands are executed by the receiving thread.
  */
 static int(*const msg_vm[])(struct kvm_introspection *,
 			    const struct kvmi_msg_hdr *, const void *) = {
 	[KVMI_GET_VERSION]       = handle_get_version,
+	[KVMI_VCPU_PAUSE]        = handle_vcpu_pause,
 	[KVMI_VM_CHECK_COMMAND]  = handle_vm_check_command,
 	[KVMI_VM_CHECK_EVENT]    = handle_vm_check_event,
 	[KVMI_VM_CONTROL_EVENTS] = handle_vm_control_events,
