Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48BBC155D95
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbgBGSQz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:16:55 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40778 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727390AbgBGSQw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:52 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id DD0DD305D351;
        Fri,  7 Feb 2020 20:16:40 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id D14DC3086D0A;
        Fri,  7 Feb 2020 20:16:40 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v7 51/78] KVM: introspection: add KVMI_VCPU_PAUSE
Date:   Fri,  7 Feb 2020 20:16:09 +0200
Message-Id: <20200207181636.1065-52-alazar@bitdefender.com>
In-Reply-To: <20200207181636.1065-1-alazar@bitdefender.com>
References: <20200207181636.1065-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is the only vCPU command handled by the receiving thread.
It increments a pause request counter and kicks the vCPU.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 66 ++++++++++++++++++-
 include/linux/kvmi_host.h                     |  2 +
 include/uapi/linux/kvmi.h                     | 11 +++-
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 31 +++++++++
 virt/kvm/introspection/kvmi.c                 | 64 ++++++++++++++++--
 virt/kvm/introspection/kvmi_int.h             |  6 +-
 virt/kvm/introspection/kvmi_msg.c             | 39 +++++++++++
 7 files changed, 212 insertions(+), 7 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 8eb0006349d6..ba01b9a249a2 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -465,12 +465,52 @@ Returns the TSC frequency (in HZ) for the specified vCPU if available
 * -KVM_EINVAL - padding is not zero
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
 
+9. KVMI_VCPU_PAUSE
+------------------
+
+:Architecture: all
+:Versions: >= 1
+:Parameters:
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
+Kicks the vCPU from guest.
+
+If `wait` is 1, the command will wait for vCPU to acknowledge the IPI.
+
+The vCPU will handle the pending commands/events and send the
+*KVMI_EVENT_PAUSE_VCPU* event (one for every successful *KVMI_VCPU_PAUSE*
+command) before returning to guest.
+
+The socket will be closed if the *KVMI_EVENT_PAUSE_VCPU* event is disallowed.
+Use *KVMI_VM_CHECK_EVENT* first.
+
+:Errors:
+
+* -KVM_EINVAL - the selected vCPU is invalid
+* -KVM_EINVAL - padding is not zero
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+* -KVM_EBUSY  - the selected vCPU has too many queued *KVMI_EVENT_PAUSE_VCPU* events
+
+
 Events
 ======
 
 All introspection events (VM or vCPU related) are sent
 using the *KVMI_EVENT* message id. No event will be sent unless
-it is explicitly enabled.
+it is explicitly enabled or requested (eg. *KVMI_EVENT_PAUSE_VCPU*).
 
 The *KVMI_EVENT_UNHOOK* event doesn't have a reply and share the kvmi_event
 structure, for consistency with the vCPU events.
@@ -529,3 +569,27 @@ the guest (see **Unhooking**) and the introspection has been enabled
 for this event (see **KVMI_VM_CONTROL_EVENTS**). The introspection tool
 has a chance to unhook and close the KVMI channel (signaling that the
 operation can proceed).
+
+1. KVMI_EVENT_PAUSE_VCPU
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
+
+This event has a low priority. It will be sent after any other vCPU
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
index b36ecc0d6513..54a788c1c204 100644
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
@@ -97,6 +99,13 @@ struct kvmi_vcpu_hdr {
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
index 5c55f4ce5875..942601f6177b 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -648,6 +648,36 @@ static void test_cmd_get_vcpu_info(struct kvm_vm *vm)
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
 	setup_socket();
@@ -662,6 +692,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vm_control_events();
 	test_memory_access(vm);
 	test_cmd_get_vcpu_info(vm);
+	test_pause(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index ea86512ca81e..51c090a56242 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -9,6 +9,10 @@
 #include "kvmi_int.h"
 #include <linux/kthread.h>
 
+enum {
+	MAX_PAUSE_REQUESTS = 1001
+};
+
 static struct kmem_cache *msg_cache;
 static struct kmem_cache *job_cache;
 
@@ -65,10 +69,14 @@ void kvmi_uninit(void)
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
@@ -103,7 +111,7 @@ int kvmi_add_job(struct kvm_vcpu *vcpu,
 	err = __kvmi_add_job(vcpu, fct, ctx, free_fct);
 
 	if (!err)
-		kvmi_make_request(vcpu);
+		kvmi_make_request(vcpu, false);
 
 	return err;
 }
@@ -278,6 +286,22 @@ static int __kvmi_hook(struct kvm *kvm,
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
@@ -291,6 +315,8 @@ static int kvmi_recv_thread(void *arg)
 	 */
 	kvmi_sock_shutdown(kvmi);
 
+	kvmi_release_vcpus(kvmi->kvm);
+
 	kvmi_put(kvmi->kvm);
 	return 0;
 }
@@ -676,15 +702,45 @@ void kvmi_run_jobs(struct kvm_vcpu *vcpu)
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
index bab73fc232ec..d1d93488af1c 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -21,7 +21,9 @@
 #define KVMI_KNOWN_VM_EVENTS ( \
 			  BIT(KVMI_EVENT_UNHOOK) \
 		)
-#define KVMI_KNOWN_VCPU_EVENTS 0
+#define KVMI_KNOWN_VCPU_EVENTS ( \
+			  BIT(KVMI_EVENT_PAUSE_VCPU) \
+		)
 
 #define KVMI_KNOWN_EVENTS (KVMI_KNOWN_VM_EVENTS | KVMI_KNOWN_VCPU_EVENTS)
 
@@ -34,6 +36,7 @@
 			| BIT(KVMI_VM_READ_PHYSICAL) \
 			| BIT(KVMI_VM_WRITE_PHYSICAL) \
 			| BIT(KVMI_VCPU_GET_INFO) \
+			| BIT(KVMI_VCPU_PAUSE) \
 		)
 
 #define KVMI(kvm) ((struct kvm_introspection *)((kvm)->kvmi))
@@ -68,6 +71,7 @@ int kvmi_cmd_read_physical(struct kvm *kvm, u64 gpa, u64 size,
 			   const struct kvmi_msg_hdr *ctx);
 int kvmi_cmd_write_physical(struct kvm *kvm, u64 gpa, u64 size,
 			    const void *buf);
+int kvmi_cmd_vcpu_pause(struct kvm_vcpu *vcpu, bool wait);
 
 /* arch */
 int kvmi_arch_cmd_vcpu_get_info(struct kvm_vcpu *vcpu,
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 4e7a2ceb78da..1eae0a9a8e0a 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -25,6 +25,7 @@ static const char *const msg_IDs[] = {
 	[KVMI_VM_READ_PHYSICAL]  = "KVMI_VM_READ_PHYSICAL",
 	[KVMI_VM_WRITE_PHYSICAL] = "KVMI_VM_WRITE_PHYSICAL",
 	[KVMI_VCPU_GET_INFO]     = "KVMI_VCPU_GET_INFO",
+	[KVMI_VCPU_PAUSE]        = "KVMI_VCPU_PAUSE",
 };
 
 static bool is_known_message(u16 id)
@@ -291,6 +292,43 @@ static int handle_write_physical(struct kvm_introspection *kvmi,
 	return kvmi_msg_vm_reply(kvmi, msg, ec, NULL, 0);
 }
 
+/*
+ * We handle this vCPU command on the receiving thread to make it easier
+ * for userspace to implement a 'pause VM' command. Usually, this is done
+ * by sending one 'pause vCPU' command for every vCPU. By handling the
+ * command here, the userspace can consider that the VM has stopped
+ * once it receives the reply for the last 'pause vCPU' command.
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
+	if (req->padding1 || req->padding2 || req->padding3)
+		return -KVM_EINVAL;
+
+	if (!is_event_allowed(kvmi, KVMI_EVENT_PAUSE_VCPU))
+		return -KVM_EPERM;
+
+	cmd = (const struct kvmi_vcpu_hdr *) (msg + 1);
+
+	if (invalid_vcpu_hdr(cmd)) {
+		err = -KVM_EINVAL;
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
@@ -303,6 +341,7 @@ static int(*const msg_vm[])(struct kvm_introspection *,
 	[KVMI_VM_GET_INFO]       = handle_get_info,
 	[KVMI_VM_READ_PHYSICAL]  = handle_read_physical,
 	[KVMI_VM_WRITE_PHYSICAL] = handle_write_physical,
+	[KVMI_VCPU_PAUSE]        = handle_pause_vcpu,
 };
 
 static int handle_get_vcpu_info(const struct kvmi_vcpu_cmd_job *job,
