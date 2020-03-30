Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4A4919792A
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729263AbgC3KV5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:21:57 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:43790 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729249AbgC3KTz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 06:19:55 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 50547305FFA8;
        Mon, 30 Mar 2020 13:12:57 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 31A66305B7A2;
        Mon, 30 Mar 2020 13:12:57 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v8 53/81] KVM: introspection: add KVMI_VCPU_PAUSE
Date:   Mon, 30 Mar 2020 13:12:40 +0300
Message-Id: <20200330101308.21702-54-alazar@bitdefender.com>
In-Reply-To: <20200330101308.21702-1-alazar@bitdefender.com>
References: <20200330101308.21702-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is the only vCPU command handled by the receiving thread.
It increments a pause request counter and kicks the vCPU out of guest.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 64 ++++++++++++++++++-
 include/linux/kvmi_host.h                     |  2 +
 include/uapi/linux/kvmi.h                     | 11 +++-
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 31 +++++++++
 virt/kvm/introspection/kvmi.c                 | 63 ++++++++++++++++--
 virt/kvm/introspection/kvmi_int.h             |  1 +
 virt/kvm/introspection/kvmi_msg.c             | 44 +++++++++++++
 7 files changed, 210 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 16438e863003..642e2f10adfd 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -478,12 +478,51 @@ Returns the TSC frequency (in HZ) for the specified vCPU if available
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
+* -KVM_EBUSY  - the selected vCPU has too many queued *KVMI_EVENT_PAUSE_VCPU* events
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
@@ -542,3 +581,26 @@ the guest (see **Unhooking**) and the introspection has been enabled
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
+introspection event and when no vCPU introspection command is queued.
diff --git a/include/linux/kvmi_host.h b/include/linux/kvmi_host.h
index 6a0fb481b192..988927c29bf5 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -23,6 +23,8 @@ struct kvm_vcpu_introspection {
 
 	struct list_head job_list;
 	spinlock_t job_lock;
+
+	atomic_t pause_requests;
 };
 
 struct kvm_introspection {
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 4cdaad656de4..38954a5297da 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -26,12 +26,14 @@ enum {
 	KVMI_VM_WRITE_PHYSICAL = 8,
 
 	KVMI_VCPU_GET_INFO     = 9,
+	KVMI_VCPU_PAUSE        = 10,
 
 	KVMI_NUM_MESSAGES
 };
 
 enum {
-	KVMI_EVENT_UNHOOK = 0,
+	KVMI_EVENT_UNHOOK     = 0,
+	KVMI_EVENT_PAUSE_VCPU = 1,
 
 	KVMI_NUM_EVENTS
 };
@@ -108,6 +110,13 @@ struct kvmi_vcpu_hdr {
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
index c765b1e5707d..bc84d478ff6b 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -655,6 +655,36 @@ static void test_cmd_get_vcpu_info(struct kvm_vm *vm)
 	DEBUG("tsc_speed: %llu HZ\n", rpl.tsc_speed);
 }
 
+static int cmd_pause_vcpu(struct kvm_vm *vm)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vcpu_hdr vcpu_hdr;
+		struct kvmi_vcpu_pause cmd;
+	} req = {};
+	__u16 vcpu_index = 0;
+
+	req.vcpu_hdr.vcpu = vcpu_index;
+
+	return do_command(KVMI_VCPU_PAUSE, &req.hdr, sizeof(req),
+			     NULL, 0);
+}
+
+static void pause_vcpu(struct kvm_vm *vm)
+{
+	int r;
+
+	r = cmd_pause_vcpu(vm);
+	TEST_ASSERT(r == 0,
+		"KVMI_VCPU_PAUSE failed, error %d(%s)\n",
+		-r, kvm_strerror(-r));
+}
+
+static void test_pause(struct kvm_vm *vm)
+{
+	pause_vcpu(vm);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	srandom(time(0));
@@ -670,6 +700,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vm_control_events();
 	test_memory_access(vm);
 	test_cmd_get_vcpu_info(vm);
+	test_pause(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 65a77b8d2616..c4da264ad5a6 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -11,6 +11,8 @@
 
 #define KVMI_MSG_SIZE_ALLOC (sizeof(struct kvmi_msg_hdr) + KVMI_MSG_SIZE)
 
+#define MAX_PAUSE_REQUESTS 1001
+
 static DECLARE_BITMAP(Kvmi_always_allowed_commands, KVMI_NUM_COMMANDS);
 DECLARE_BITMAP(Kvmi_known_events, KVMI_NUM_EVENTS);
 DECLARE_BITMAP(Kvmi_known_vm_events, KVMI_NUM_EVENTS);
@@ -69,6 +71,7 @@ static void setup_known_events(void)
 	set_bit(KVMI_EVENT_UNHOOK, Kvmi_known_vm_events);
 
 	bitmap_zero(Kvmi_known_vcpu_events, KVMI_NUM_EVENTS);
+	set_bit(KVMI_EVENT_PAUSE_VCPU, Kvmi_known_vcpu_events);
 
 	bitmap_or(Kvmi_known_events, Kvmi_known_vm_events,
 		  Kvmi_known_vcpu_events, KVMI_NUM_EVENTS);
@@ -87,10 +90,14 @@ void kvmi_uninit(void)
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
@@ -125,7 +132,7 @@ int kvmi_add_job(struct kvm_vcpu *vcpu,
 	err = __kvmi_add_job(vcpu, fct, ctx, free_fct);
 
 	if (!err)
-		kvmi_make_request(vcpu);
+		kvmi_make_request(vcpu, false);
 
 	return err;
 }
@@ -304,6 +311,22 @@ static int __kvmi_hook(struct kvm *kvm,
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
@@ -317,6 +340,8 @@ static int kvmi_recv_thread(void *arg)
 	 */
 	kvmi_sock_shutdown(kvmi);
 
+	kvmi_release_vcpus(kvmi->kvm);
+
 	kvmi_put(kvmi->kvm);
 	return 0;
 }
@@ -681,15 +706,45 @@ void kvmi_run_jobs(struct kvm_vcpu *vcpu)
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
index 4a71e33d46ef..bd968e837a54 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -44,6 +44,7 @@ int kvmi_cmd_read_physical(struct kvm *kvm, u64 gpa, size_t size,
 			   const struct kvmi_msg_hdr *ctx);
 int kvmi_cmd_write_physical(struct kvm *kvm, u64 gpa, size_t size,
 			    const void *buf);
+int kvmi_cmd_vcpu_pause(struct kvm_vcpu *vcpu, bool wait);
 
 /* arch */
 int kvmi_arch_cmd_vcpu_get_info(struct kvm_vcpu *vcpu,
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 62dc50060a1e..772ba1d7d9df 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -28,6 +28,7 @@ static const char *const msg_IDs[] = {
 	[KVMI_VM_READ_PHYSICAL]  = "KVMI_VM_READ_PHYSICAL",
 	[KVMI_VM_WRITE_PHYSICAL] = "KVMI_VM_WRITE_PHYSICAL",
 	[KVMI_VCPU_GET_INFO]     = "KVMI_VCPU_GET_INFO",
+	[KVMI_VCPU_PAUSE]        = "KVMI_VCPU_PAUSE",
 };
 
 static const char *id2str(u16 id)
@@ -298,6 +299,48 @@ static int handle_write_physical(struct kvm_introspection *kvmi,
 	return kvmi_msg_vm_reply(kvmi, msg, ec, NULL, 0);
 }
 
+/*
+ * This vCPU command is handled from the receiving thread instead of
+ * the vCPU thread, to make it easier for userspace to implement a 'pause VM'
+ * command by sending a 'pause vCPU' command (with wait=1) for every vCPU.
+ * By handling the command here, the userspace can consider that the VM
+ * is stopped (no vCPU runs guest code) once it receives the reply
+ * for the last 'pause vCPU' command.
+ */
+static int handle_pause_vcpu(struct kvm_introspection *kvmi,
+			     const struct kvmi_msg_hdr *msg,
+			     const void *_req)
+{
+	const struct kvmi_vcpu_pause *req = _req;
+	const struct kvmi_vcpu_hdr *cmd;
+	struct kvm_vcpu *vcpu = NULL;
+	int err;
+
+	cmd = (const struct kvmi_vcpu_hdr *) (msg + 1);
+
+	if (invalid_vcpu_hdr(cmd) || req->wait > 0) {
+		err = -KVM_EINVAL;
+		goto reply;
+	}
+
+	if (req->padding1 || req->padding2 || req->padding3) {
+		err = -KVM_EINVAL;
+		goto reply;
+	}
+
+	if (!is_event_allowed(kvmi, KVMI_EVENT_PAUSE_VCPU)) {
+		err = -KVM_EPERM;
+		goto reply;
+	}
+
+	err = kvmi_get_vcpu(kvmi, cmd->vcpu, &vcpu);
+	if (!err)
+		err = kvmi_cmd_vcpu_pause(vcpu, req->wait == 1);
+
+reply:
+	return kvmi_msg_vm_reply(kvmi, msg, err, NULL, 0);
+}
+
 /*
  * These commands are executed by the receiving thread/worker.
  */
@@ -310,6 +353,7 @@ static int(*const msg_vm[])(struct kvm_introspection *,
 	[KVMI_VM_GET_INFO]       = handle_get_info,
 	[KVMI_VM_READ_PHYSICAL]  = handle_read_physical,
 	[KVMI_VM_WRITE_PHYSICAL] = handle_write_physical,
+	[KVMI_VCPU_PAUSE]        = handle_pause_vcpu,
 };
 
 static bool is_vm_command(u16 id)
