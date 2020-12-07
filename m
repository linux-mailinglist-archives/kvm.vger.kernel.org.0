Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE9632D1B1D
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 21:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbgLGUs3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 15:48:29 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:42562 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727293AbgLGUs2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 15:48:28 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 4CC1A305D46F;
        Mon,  7 Dec 2020 22:46:20 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 291BC3072784;
        Mon,  7 Dec 2020 22:46:20 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v11 48/81] KVM: introspection: add KVMI_VM_PAUSE_VCPU
Date:   Mon,  7 Dec 2020 22:45:49 +0200
Message-Id: <20201207204622.15258-49-alazar@bitdefender.com>
In-Reply-To: <20201207204622.15258-1-alazar@bitdefender.com>
References: <20201207204622.15258-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This command increments a pause requests counter for a vCPU and kicks
it out of guest.

The introspection tool can pause a VM by sending this command for all
vCPUs. If it sets 'wait=1', it can consider that the VM is paused when
it receives the reply for the last KVMI_VM_PAUSE_VCPU command.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 39 +++++++++++++++
 include/linux/kvmi_host.h                     |  2 +
 include/uapi/linux/kvmi.h                     |  8 ++++
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 30 ++++++++++++
 virt/kvm/introspection/kvmi.c                 | 47 +++++++++++++++++--
 virt/kvm/introspection/kvmi_int.h             |  1 +
 virt/kvm/introspection/kvmi_msg.c             | 24 ++++++++++
 7 files changed, 147 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 902ced4dd0c4..a71fb78d546e 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -470,6 +470,45 @@ Returns the TSC frequency (in HZ) for the specified vCPU if available
 * -KVM_EINVAL - the selected vCPU is invalid
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
 
+9. KVMI_VM_PAUSE_VCPU
+---------------------
+
+:Architectures: all
+:Versions: >= 1
+:Parameters:
+
+::
+
+	struct kvmi_vm_pause_vcpu {
+		__u16 vcpu;
+		__u8 wait;
+		__u8 padding1;
+		__u32 padding2;
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
+*KVMI_VCPU_EVENT_PAUSE* event (one for every successful *KVMI_VM_PAUSE_VCPU*
+command) before returning to guest.
+
+:Errors:
+
+* -KVM_EINVAL - the padding is not zero
+* -KVM_EINVAL - the selected vCPU is invalid
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+* -KVM_EBUSY  - the selected vCPU has too many queued
+                *KVMI_VCPU_EVENT_PAUSE* events
+* -KVM_EPERM  - the *KVMI_VCPU_EVENT_PAUSE* event is disallowed
+
 Events
 ======
 
diff --git a/include/linux/kvmi_host.h b/include/linux/kvmi_host.h
index 736edb400c05..59e645d9ea34 100644
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
index da766427231e..bb90d03f059b 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -26,6 +26,7 @@ enum {
 	KVMI_VM_CONTROL_EVENTS = KVMI_VM_MESSAGE_ID(5),
 	KVMI_VM_READ_PHYSICAL  = KVMI_VM_MESSAGE_ID(6),
 	KVMI_VM_WRITE_PHYSICAL = KVMI_VM_MESSAGE_ID(7),
+	KVMI_VM_PAUSE_VCPU     = KVMI_VM_MESSAGE_ID(8),
 
 	KVMI_NEXT_VM_MESSAGE
 };
@@ -115,4 +116,11 @@ struct kvmi_vcpu_hdr {
 	__u32 padding2;
 };
 
+struct kvmi_vm_pause_vcpu {
+	__u16 vcpu;
+	__u8 wait;
+	__u8 padding1;
+	__u32 padding2;
+};
+
 #endif /* _UAPI__LINUX_KVMI_H */
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 9350ba8b7f9b..52765ca3f9c8 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -671,6 +671,35 @@ static void test_cmd_vcpu_get_info(struct kvm_vm *vm)
 			&rpl, sizeof(rpl), -KVM_EINVAL);
 }
 
+static void cmd_vcpu_pause(__u8 wait, int expected_err)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vm_pause_vcpu cmd;
+	} req = {};
+	__u16 vcpu_idx = 0;
+
+	req.cmd.wait = wait;
+	req.cmd.vcpu = vcpu_idx;
+
+	test_vm_command(KVMI_VM_PAUSE_VCPU, &req.hdr, sizeof(req), NULL, 0, expected_err);
+}
+
+static void pause_vcpu(void)
+{
+	cmd_vcpu_pause(1, 0);
+}
+
+static void test_pause(struct kvm_vm *vm)
+{
+	__u8 wait = 1, wait_inval = 2;
+
+	pause_vcpu();
+
+	cmd_vcpu_pause(wait, 0);
+	cmd_vcpu_pause(wait_inval, -KVM_EINVAL);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	srandom(time(0));
@@ -686,6 +715,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vm_control_events(vm);
 	test_memory_access(vm);
 	test_cmd_vcpu_get_info(vm);
+	test_pause(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 95677cb9a657..904362d00e62 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -17,6 +17,8 @@
 
 #define KVMI_MSG_SIZE_ALLOC (sizeof(struct kvmi_msg_hdr) + KVMI_MAX_MSG_SIZE)
 
+#define MAX_PAUSE_REQUESTS 1001
+
 static DECLARE_BITMAP(Kvmi_always_allowed_commands, KVMI_NUM_COMMANDS);
 static DECLARE_BITMAP(Kvmi_known_events, KVMI_NUM_EVENTS);
 static DECLARE_BITMAP(Kvmi_known_vm_events, KVMI_NUM_EVENTS);
@@ -124,10 +126,14 @@ void kvmi_uninit(void)
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
@@ -162,7 +168,7 @@ int kvmi_add_job(struct kvm_vcpu *vcpu,
 	err = __kvmi_add_job(vcpu, fct, ctx, free_fct);
 
 	if (!err)
-		kvmi_make_request(vcpu);
+		kvmi_make_request(vcpu, false);
 
 	return err;
 }
@@ -359,6 +365,9 @@ static int __kvmi_hook(struct kvm *kvm,
 
 static void kvmi_job_release_vcpu(struct kvm_vcpu *vcpu, void *ctx)
 {
+	struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
+
+	atomic_set(&vcpui->pause_requests, 0);
 }
 
 static void kvmi_release_vcpus(struct kvm *kvm)
@@ -731,15 +740,45 @@ void kvmi_run_jobs(struct kvm_vcpu *vcpu)
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
index 126e72201518..f1caa67dbdc3 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -55,6 +55,7 @@ int kvmi_cmd_read_physical(struct kvm *kvm, u64 gpa, size_t size,
 			   const struct kvmi_msg_hdr *ctx);
 int kvmi_cmd_write_physical(struct kvm *kvm, u64 gpa, size_t size,
 			    const void *buf);
+int kvmi_cmd_vcpu_pause(struct kvm_vcpu *vcpu, bool wait);
 
 /* arch */
 void kvmi_arch_init_vcpu_events_mask(unsigned long *supported);
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 0c12b7c53a9e..8d87ba16eb12 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -245,6 +245,29 @@ static int handle_vm_write_physical(struct kvm_introspection *kvmi,
 	return kvmi_msg_vm_reply(kvmi, msg, ec, NULL, 0);
 }
 
+static int handle_vm_pause_vcpu(struct kvm_introspection *kvmi,
+				const struct kvmi_msg_hdr *msg,
+				const void *_req)
+{
+	const struct kvmi_vm_pause_vcpu *req = _req;
+	struct kvm_vcpu *vcpu;
+	int ec;
+
+	if (req->wait > 1 || req->padding1 || req->padding2) {
+		ec = -KVM_EINVAL;
+		goto reply;
+	}
+
+	vcpu = kvmi_get_vcpu(kvmi, req->vcpu);
+	if (!vcpu)
+		ec = -KVM_EINVAL;
+	else
+		ec = kvmi_cmd_vcpu_pause(vcpu, req->wait == 1);
+
+reply:
+	return kvmi_msg_vm_reply(kvmi, msg, ec, NULL, 0);
+}
+
 /*
  * These commands are executed by the receiving thread.
  */
@@ -254,6 +277,7 @@ static kvmi_vm_msg_fct const msg_vm[] = {
 	[KVMI_VM_CHECK_EVENT]    = handle_vm_check_event,
 	[KVMI_VM_CONTROL_EVENTS] = handle_vm_control_events,
 	[KVMI_VM_GET_INFO]       = handle_vm_get_info,
+	[KVMI_VM_PAUSE_VCPU]     = handle_vm_pause_vcpu,
 	[KVMI_VM_READ_PHYSICAL]  = handle_vm_read_physical,
 	[KVMI_VM_WRITE_PHYSICAL] = handle_vm_write_physical,
 };
