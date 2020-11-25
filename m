Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4749C2C3C7F
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 10:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbgKYJmA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 04:42:00 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:57224 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727455AbgKYJl7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Nov 2020 04:41:59 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 3D3E2305D3C0;
        Wed, 25 Nov 2020 11:35:51 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 191A03072784;
        Wed, 25 Nov 2020 11:35:51 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v10 52/81] KVM: introspection: add KVMI_VCPU_CONTROL_EVENTS
Date:   Wed, 25 Nov 2020 11:35:31 +0200
Message-Id: <20201125093600.2766-53-alazar@bitdefender.com>
In-Reply-To: <20201125093600.2766-1-alazar@bitdefender.com>
References: <20201125093600.2766-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

By default, all introspection events are disabled. The introspection tool
must explicitly enable the events it wants to receive. With this command
(KVMI_VCPU_CONTROL_EVENTS) it can enable/disable any vCPU event allowed
by the device manager.

Some vCPU events doesn't have to be explicitly enabled (and can't
be disabled) with this command because they are implicitly enabled
or requested by the use of certain commands. For example, if the
introspection tool uses the KVMI_VM_PAUSE_VCPU command, it wants to
receive an KVMI_VCPU_EVENT_PAUSE event.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 48 +++++++++++++++++++
 include/linux/kvmi_host.h                     |  2 +
 include/uapi/linux/kvmi.h                     | 10 +++-
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 46 ++++++++++++++++++
 virt/kvm/introspection/kvmi.c                 | 26 ++++++++++
 virt/kvm/introspection/kvmi_int.h             |  3 ++
 virt/kvm/introspection/kvmi_msg.c             | 24 +++++++++-
 7 files changed, 157 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index c86c83566c3d..a502cf9baead 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -367,6 +367,9 @@ the following events::
 
 	KVMI_VM_EVENT_UNHOOK
 
+The vCPU events (e.g. *KVMI_VCPU_EVENT_PAUSE*) are controlled with
+the *KVMI_VCPU_CONTROL_EVENTS* command.
+
 :Errors:
 
 * -KVM_EINVAL - the padding is not zero
@@ -509,6 +512,51 @@ command) before returning to guest.
                 *KVMI_VCPU_EVENT_PAUSE* events
 * -KVM_EPERM  - the *KVMI_VCPU_EVENT_PAUSE* event is disallowed
 
+10. KVMI_VCPU_CONTROL_EVENTS
+----------------------------
+
+:Architectures: all
+:Versions: >= 1
+:Parameters:
+
+::
+
+	struct kvmi_vcpu_hdr;
+	struct kvmi_vcpu_control_events {
+		__u16 event_id;
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
+Enables/disables vCPU introspection events.
+
+When an event is enabled, the introspection tool is notified and
+must reply with: continue, retry, crash, etc. (see **Events** below).
+
+The following vCPU events doesn't have to be enabled and can't be disabled,
+because these are sent as a result of certain commands (but they can be
+disallowed by the device manager) ::
+
+	KVMI_VCPU_EVENT_PAUSE
+
+The VM events (e.g. *KVMI_VM_EVENT_UNHOOK*) are controlled with
+the *KVMI_VM_CONTROL_EVENTS* command.
+
+:Errors:
+
+* -KVM_EINVAL - the padding is not zero
+* -KVM_EINVAL - the selected vCPU is invalid
+* -KVM_EINVAL - the event ID is unknown (use *KVMI_VM_CHECK_EVENT* first)
+* -KVM_EPERM - the access is disallowed (use *KVMI_VM_CHECK_EVENT* first)
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+
 Events
 ======
 
diff --git a/include/linux/kvmi_host.h b/include/linux/kvmi_host.h
index 4a43e51a44c9..5e5d255e5a2c 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -31,6 +31,8 @@ struct kvm_vcpu_introspection {
 
 	struct kvmi_vcpu_reply reply;
 	bool waiting_for_reply;
+
+	unsigned long *ev_enable_mask;
 };
 
 struct kvm_introspection {
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 757d4b84f473..acd00e883dc9 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -35,7 +35,8 @@ enum {
 enum {
 	KVMI_VCPU_EVENT = KVMI_VCPU_MESSAGE_ID(0),
 
-	KVMI_VCPU_GET_INFO = KVMI_VCPU_MESSAGE_ID(1),
+	KVMI_VCPU_GET_INFO       = KVMI_VCPU_MESSAGE_ID(1),
+	KVMI_VCPU_CONTROL_EVENTS = KVMI_VCPU_MESSAGE_ID(2),
 
 	KVMI_NEXT_VCPU_MESSAGE
 };
@@ -148,4 +149,11 @@ struct kvmi_vcpu_event_reply {
 	__u32 padding2;
 };
 
+struct kvmi_vcpu_control_events {
+	__u16 event_id;
+	__u8 enable;
+	__u8 padding1;
+	__u32 padding2;
+};
+
 #endif /* _UAPI__LINUX_KVMI_H */
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 4c9dc6560ad9..5948f9b79ed0 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -763,6 +763,51 @@ static void test_pause(struct kvm_vm *vm)
 	allow_event(vm, KVMI_VCPU_EVENT_PAUSE);
 }
 
+static void cmd_vcpu_control_event(struct kvm_vm *vm, __u16 event_id,
+				   __u8 enable, int expected_err)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vcpu_hdr vcpu_hdr;
+		struct kvmi_vcpu_control_events cmd;
+	} req = {};
+
+	req.cmd.event_id = event_id;
+	req.cmd.enable = enable;
+
+	test_vcpu0_command(vm, KVMI_VCPU_CONTROL_EVENTS,
+			   &req.hdr, sizeof(req), NULL, 0,
+			   expected_err);
+}
+
+
+static void enable_vcpu_event(struct kvm_vm *vm, __u16 event_id)
+{
+	cmd_vcpu_control_event(vm, event_id, 1, 0);
+}
+
+static void disable_vcpu_event(struct kvm_vm *vm, __u16 event_id)
+{
+	cmd_vcpu_control_event(vm, event_id, 0, 0);
+}
+
+static void test_cmd_vcpu_control_events(struct kvm_vm *vm)
+{
+	__u16 id = KVMI_VCPU_EVENT_PAUSE, invalid_id = 0xffff;
+	__u8 enable = 1, enable_inval = 2;
+
+	enable_vcpu_event(vm, id);
+	disable_vcpu_event(vm, id);
+
+	cmd_vcpu_control_event(vm, id, enable_inval, -KVM_EINVAL);
+	cmd_vcpu_control_event(vm, invalid_id, enable, -KVM_EINVAL);
+
+	disallow_event(vm, id);
+	cmd_vcpu_control_event(vm, id, enable, -KVM_EPERM);
+	allow_event(vm, id);
+
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	srandom(time(0));
@@ -779,6 +824,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_memory_access(vm);
 	test_cmd_vcpu_get_info(vm);
 	test_pause(vm);
+	test_cmd_vcpu_control_events(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index d25b83dce8ed..457d1b9122ad 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -83,6 +83,11 @@ bool kvmi_is_known_vm_event(u16 id)
 	return id < KVMI_NUM_EVENTS && test_bit(id, Kvmi_known_vm_events);
 }
 
+bool kvmi_is_known_vcpu_event(u16 id)
+{
+	return id < KVMI_NUM_EVENTS && test_bit(id, Kvmi_known_vcpu_events);
+}
+
 static bool kvmi_is_vm_event_enabled(struct kvm_introspection *kvmi, u16 id)
 {
 	return id < KVMI_NUM_EVENTS && test_bit(id, kvmi->vm_event_enable_mask);
@@ -190,6 +195,12 @@ static bool kvmi_alloc_vcpui(struct kvm_vcpu *vcpu)
 	if (!vcpui)
 		return false;
 
+	vcpui->ev_enable_mask = bitmap_zalloc(KVMI_NUM_EVENTS, GFP_KERNEL);
+	if (!vcpui->ev_enable_mask) {
+		kfree(vcpu);
+		return false;
+	}
+
 	INIT_LIST_HEAD(&vcpui->job_list);
 	spin_lock_init(&vcpui->job_lock);
 
@@ -225,6 +236,8 @@ static void kvmi_free_vcpui(struct kvm_vcpu *vcpu)
 
 	kvmi_free_vcpu_jobs(vcpui);
 
+	bitmap_free(vcpui->ev_enable_mask);
+
 	kfree(vcpui);
 	vcpu->kvmi = NULL;
 }
@@ -621,6 +634,19 @@ int kvmi_cmd_vm_control_events(struct kvm_introspection *kvmi,
 	return 0;
 }
 
+int kvmi_cmd_vcpu_control_events(struct kvm_vcpu *vcpu,
+				 u16 event_id, bool enable)
+{
+	struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
+
+	if (enable)
+		set_bit(event_id, vcpui->ev_enable_mask);
+	else
+		clear_bit(event_id, vcpui->ev_enable_mask);
+
+	return 0;
+}
+
 static long
 get_user_pages_remote_unlocked(struct mm_struct *mm, unsigned long start,
 				unsigned long nr_pages, unsigned int gup_flags,
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 0876740dfa24..8059029cadf4 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -47,12 +47,15 @@ bool kvmi_is_command_allowed(struct kvm_introspection *kvmi, u16 id);
 bool kvmi_is_event_allowed(struct kvm_introspection *kvmi, u16 id);
 bool kvmi_is_known_event(u16 id);
 bool kvmi_is_known_vm_event(u16 id);
+bool kvmi_is_known_vcpu_event(u16 id);
 int kvmi_add_job(struct kvm_vcpu *vcpu,
 		 void (*fct)(struct kvm_vcpu *vcpu, void *ctx),
 		 void *ctx, void (*free_fct)(void *ctx));
 void kvmi_run_jobs(struct kvm_vcpu *vcpu);
 int kvmi_cmd_vm_control_events(struct kvm_introspection *kvmi,
 			       u16 event_id, bool enable);
+int kvmi_cmd_vcpu_control_events(struct kvm_vcpu *vcpu,
+				 u16 event_id, bool enable);
 int kvmi_cmd_read_physical(struct kvm *kvm, u64 gpa, size_t size,
 			   int (*send)(struct kvm_introspection *,
 					const struct kvmi_msg_hdr*,
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 71a28e26d382..f7549baf5c41 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -364,6 +364,27 @@ static int handle_vcpu_event_reply(const struct kvmi_vcpu_msg_job *job,
 	return expected->error;
 }
 
+static int handle_vcpu_control_events(const struct kvmi_vcpu_msg_job *job,
+				      const struct kvmi_msg_hdr *msg,
+				      const void *_req)
+{
+	struct kvm_introspection *kvmi = KVMI(job->vcpu->kvm);
+	const struct kvmi_vcpu_control_events *req = _req;
+	int ec;
+
+	if (req->padding1 || req->padding2 || req->enable > 1)
+		ec = -KVM_EINVAL;
+	else if (!kvmi_is_known_vcpu_event(req->event_id))
+		ec = -KVM_EINVAL;
+	else if (!kvmi_is_event_allowed(kvmi, req->event_id))
+		ec = -KVM_EPERM;
+	else
+		ec = kvmi_cmd_vcpu_control_events(job->vcpu, req->event_id,
+						  req->enable == 1);
+
+	return kvmi_msg_vcpu_reply(job, msg, ec, NULL, 0);
+}
+
 /*
  * These functions are executed from the vCPU thread. The receiving thread
  * passes the messages using a newly allocated 'struct kvmi_vcpu_msg_job'
@@ -371,7 +392,8 @@ static int handle_vcpu_event_reply(const struct kvmi_vcpu_msg_job *job,
  * sending back the reply).
  */
 static kvmi_vcpu_msg_job_fct const msg_vcpu[] = {
-	[KVMI_VCPU_EVENT] = handle_vcpu_event_reply,
+	[KVMI_VCPU_EVENT]          = handle_vcpu_event_reply,
+	[KVMI_VCPU_CONTROL_EVENTS] = handle_vcpu_control_events,
 };
 
 static kvmi_vcpu_msg_job_fct get_vcpu_msg_handler(u16 id)
