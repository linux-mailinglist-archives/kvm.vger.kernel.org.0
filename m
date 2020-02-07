Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37A27155DA5
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbgBGSRj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:17:39 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40632 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727655AbgBGSQw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:52 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 02910305D353;
        Fri,  7 Feb 2020 20:16:41 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id E3DA9305206B;
        Fri,  7 Feb 2020 20:16:40 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v7 53/78] KVM: introspection: add KVMI_VCPU_CONTROL_EVENTS
Date:   Fri,  7 Feb 2020 20:16:11 +0200
Message-Id: <20200207181636.1065-54-alazar@bitdefender.com>
In-Reply-To: <20200207181636.1065-1-alazar@bitdefender.com>
References: <20200207181636.1065-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

This command enables/disables vCPU introspection events.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 45 +++++++++-
 include/linux/kvmi_host.h                     |  2 +
 include/uapi/linux/kvmi.h                     | 28 ++++---
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 82 +++++++++++++++++++
 virt/kvm/introspection/kvmi.c                 | 13 +++
 virt/kvm/introspection/kvmi_int.h             |  3 +
 virt/kvm/introspection/kvmi_msg.c             | 52 +++++++++---
 7 files changed, 202 insertions(+), 23 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 8bf9b8f6dd7c..c48abc8f5c97 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -504,13 +504,56 @@ Use *KVMI_VM_CHECK_EVENT* first.
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
 * -KVM_EBUSY  - the selected vCPU has too many queued *KVMI_EVENT_PAUSE_VCPU* events
 
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
+When an event is enabled, the introspection tool is notified and it
+must reply with: continue, retry, crash, etc. (see **Events** below).
+
+The *KVMI_EVENT_PAUSE_VCPU* event is always allowed,
+because it is triggered by the *KVMI_VCPU_PAUSE* command.
+
+The *KVMI_EVENT_UNHOOK* event is controlled
+by the *KVMI_VM_CONTROL_EVENTS* command.
+
+:Errors:
+
+* -KVM_EINVAL - the selected vCPU is invalid
+* -KVM_EINVAL - the event ID is invalid/unknown (use *KVMI_VM_CHECK_EVENT* first)
+* -KVM_EINVAL - padding is not zero
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+* -KVM_EPERM - the access is restricted by the host
+* -KVM_EOPNOTSUPP - one the events can't be intercepted in the current setup
 
 Events
 ======
 
 All introspection events (VM or vCPU related) are sent
 using the *KVMI_EVENT* message id. No event will be sent unless
-it is explicitly enabled or requested (eg. *KVMI_EVENT_PAUSE_VCPU*).
+it is explicitly enabled (see *KVMI_VM_CONTROL_EVENTS* and *KVMI_VCPU_CONTROL_EVENTS*)
+or requested (eg. *KVMI_EVENT_PAUSE_VCPU*).
 
 The *KVMI_EVENT_UNHOOK* event doesn't have a reply and share the kvmi_event
 structure, for consistency with the vCPU events.
diff --git a/include/linux/kvmi_host.h b/include/linux/kvmi_host.h
index 49e68777a390..da621d83cd94 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -36,6 +36,8 @@ struct kvm_vcpu_introspection {
 
 	struct kvmi_vcpu_reply reply;
 	bool waiting_for_reply;
+
+	DECLARE_BITMAP(ev_mask, KVMI_NUM_EVENTS);
 };
 
 struct kvm_introspection {
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 2eb1e5b20d53..745503fb7378 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -18,16 +18,17 @@ enum {
 	KVMI_EVENT_REPLY       = 0,
 	KVMI_EVENT             = 1,
 
-	KVMI_GET_VERSION       = 2,
-	KVMI_VM_CHECK_COMMAND  = 3,
-	KVMI_VM_CHECK_EVENT    = 4,
-	KVMI_VM_GET_INFO       = 5,
-	KVMI_VM_CONTROL_EVENTS = 6,
-	KVMI_VM_READ_PHYSICAL  = 7,
-	KVMI_VM_WRITE_PHYSICAL = 8,
-
-	KVMI_VCPU_GET_INFO     = 9,
-	KVMI_VCPU_PAUSE        = 10,
+	KVMI_GET_VERSION         = 2,
+	KVMI_VM_CHECK_COMMAND    = 3,
+	KVMI_VM_CHECK_EVENT      = 4,
+	KVMI_VM_GET_INFO         = 5,
+	KVMI_VM_CONTROL_EVENTS   = 6,
+	KVMI_VM_READ_PHYSICAL    = 7,
+	KVMI_VM_WRITE_PHYSICAL   = 8,
+
+	KVMI_VCPU_GET_INFO       = 9,
+	KVMI_VCPU_PAUSE          = 10,
+	KVMI_VCPU_CONTROL_EVENTS = 11,
 
 	KVMI_NUM_MESSAGES
 };
@@ -113,6 +114,13 @@ struct kvmi_vcpu_pause {
 	__u32 padding3;
 };
 
+struct kvmi_vcpu_control_events {
+	__u16 event_id;
+	__u8 enable;
+	__u8 padding1;
+	__u32 padding2;
+};
+
 struct kvmi_event {
 	__u16 size;
 	__u16 vcpu;
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 27de5fb24580..830b64cae20b 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -96,6 +96,11 @@ static void toggle_event_permission(struct kvm_vm *vm, __s32 id, bool allow)
 		id, errno, strerror(errno));
 }
 
+static void disallow_event(struct kvm_vm *vm, __s32 event_id)
+{
+	toggle_event_permission(vm, event_id, false);
+}
+
 static void allow_event(struct kvm_vm *vm, __s32 event_id)
 {
 	toggle_event_permission(vm, event_id, true);
@@ -722,6 +727,82 @@ static void test_pause(struct kvm_vm *vm)
 	stop_vcpu_worker(vcpu_thread, &data);
 }
 
+static int cmd_vcpu_control_event(struct kvm_vm *vm, __u16 event_id,
+				  bool enable)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vcpu_hdr vcpu_hdr;
+		struct kvmi_vcpu_control_events cmd;
+	} req = {};
+
+	req.cmd.event_id = event_id;
+	req.cmd.enable = enable ? 1 : 0;
+
+	return do_vcpu0_command(vm, KVMI_VCPU_CONTROL_EVENTS,
+				&req.hdr, sizeof(req), NULL, 0);
+}
+
+static void enable_vcpu_event(struct kvm_vm *vm, __u16 event_id)
+{
+	int r;
+
+	r = cmd_vcpu_control_event(vm, event_id, true);
+	TEST_ASSERT(r == 0,
+		"KVMI_VCPU_CONTROL_EVENTS failed to enable vCPU event %d, error %d(%s)\n",
+		event_id, -r, kvm_strerror(-r));
+}
+
+static void disable_vcpu_event(struct kvm_vm *vm, __u16 event_id)
+{
+	int r;
+
+	r = cmd_vcpu_control_event(vm, event_id, false);
+	TEST_ASSERT(r == 0,
+		"KVMI_VCPU_CONTROL_EVENTS failed to disable vCPU event %d, error %d(%s)\n",
+		event_id, -r, kvm_strerror(-r));
+}
+
+static void test_disallowed_vcpu_event(struct kvm_vm *vm, __u16 event_id)
+{
+	bool enable = true;
+	int r;
+
+	disallow_event(vm, event_id);
+
+	r = cmd_vcpu_control_event(vm, event_id, enable);
+	TEST_ASSERT(r == -KVM_EPERM,
+		"KVMI_VCPU_CONTROL_EVENTS didn't failed with KVM_EPERM, id %d, error %d (%s)\n",
+		event_id, -r, kvm_strerror(-r));
+
+	allow_event(vm, event_id);
+}
+
+static void test_invalid_vcpu_event(struct kvm_vm *vm, __u16 event_id)
+{
+	bool enable = true;
+	int r;
+
+	r = cmd_vcpu_control_event(vm, event_id, enable);
+	TEST_ASSERT(r == -KVM_EINVAL,
+		"cmd_vcpu_control_event didn't failed with KVM_EINVAL, id %d, error %d (%s)\n",
+		event_id, -r, kvm_strerror(-r));
+}
+
+static void test_cmd_vcpu_control_events(struct kvm_vm *vm)
+{
+	__u16 valid_id = KVMI_EVENT_PAUSE_VCPU;
+	__u16 invalid_id = 0xffff;
+
+	test_disallowed_vcpu_event(vm, valid_id);
+
+	enable_vcpu_event(vm, valid_id);
+
+	disable_vcpu_event(vm, valid_id);
+
+	test_invalid_vcpu_event(vm, invalid_id);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	setup_socket();
@@ -737,6 +818,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_memory_access(vm);
 	test_cmd_get_vcpu_info(vm);
 	test_pause(vm);
+	test_cmd_vcpu_control_events(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 670c14c9683f..f4ff9968bd58 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -545,6 +545,19 @@ int kvmi_cmd_vm_control_events(struct kvm_introspection *kvmi,
 	return 0;
 }
 
+int kvmi_cmd_vcpu_control_events(struct kvm_vcpu *vcpu,
+				 unsigned int event_id, bool enable)
+{
+	struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
+
+	if (enable)
+		set_bit(event_id, vcpui->ev_mask);
+	else
+		clear_bit(event_id, vcpui->ev_mask);
+
+	return 0;
+}
+
 unsigned long gfn_to_hva_safe(struct kvm *kvm, gfn_t gfn)
 {
 	unsigned long hva;
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 50b2b98dd99b..fe59696b0826 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -37,6 +37,7 @@
 			| BIT(KVMI_VM_WRITE_PHYSICAL) \
 			| BIT(KVMI_VCPU_GET_INFO) \
 			| BIT(KVMI_VCPU_PAUSE) \
+			| BIT(KVMI_VCPU_CONTROL_EVENTS) \
 		)
 
 #define KVMI(kvm) ((struct kvm_introspection *)((kvm)->kvmi))
@@ -66,6 +67,8 @@ int kvmi_add_job(struct kvm_vcpu *vcpu,
 void kvmi_run_jobs(struct kvm_vcpu *vcpu);
 int kvmi_cmd_vm_control_events(struct kvm_introspection *kvmi,
 				unsigned int event_id, bool enable);
+int kvmi_cmd_vcpu_control_events(struct kvm_vcpu *vcpu,
+				 unsigned int event_id, bool enable);
 int kvmi_cmd_read_physical(struct kvm *kvm, u64 gpa, u64 size,
 			   int (*send)(struct kvm_introspection *,
 					const struct kvmi_msg_hdr*,
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 69abca999cd2..1995a63f4e99 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -17,16 +17,17 @@ struct kvmi_vcpu_cmd_job {
 };
 
 static const char *const msg_IDs[] = {
-	[KVMI_EVENT_REPLY]       = "KVMI_EVENT_REPLY",
-	[KVMI_GET_VERSION]       = "KVMI_GET_VERSION",
-	[KVMI_VM_CHECK_COMMAND]  = "KVMI_VM_CHECK_COMMAND",
-	[KVMI_VM_CHECK_EVENT]    = "KVMI_VM_CHECK_EVENT",
-	[KVMI_VM_CONTROL_EVENTS] = "KVMI_VM_CONTROL_EVENTS",
-	[KVMI_VM_GET_INFO]       = "KVMI_VM_GET_INFO",
-	[KVMI_VM_READ_PHYSICAL]  = "KVMI_VM_READ_PHYSICAL",
-	[KVMI_VM_WRITE_PHYSICAL] = "KVMI_VM_WRITE_PHYSICAL",
-	[KVMI_VCPU_GET_INFO]     = "KVMI_VCPU_GET_INFO",
-	[KVMI_VCPU_PAUSE]        = "KVMI_VCPU_PAUSE",
+	[KVMI_EVENT_REPLY]         = "KVMI_EVENT_REPLY",
+	[KVMI_GET_VERSION]         = "KVMI_GET_VERSION",
+	[KVMI_VM_CHECK_COMMAND]    = "KVMI_VM_CHECK_COMMAND",
+	[KVMI_VM_CHECK_EVENT]      = "KVMI_VM_CHECK_EVENT",
+	[KVMI_VM_CONTROL_EVENTS]   = "KVMI_VM_CONTROL_EVENTS",
+	[KVMI_VM_GET_INFO]         = "KVMI_VM_GET_INFO",
+	[KVMI_VM_READ_PHYSICAL]    = "KVMI_VM_READ_PHYSICAL",
+	[KVMI_VM_WRITE_PHYSICAL]   = "KVMI_VM_WRITE_PHYSICAL",
+	[KVMI_VCPU_CONTROL_EVENTS] = "KVMI_VCPU_CONTROL_EVENTS",
+	[KVMI_VCPU_GET_INFO]       = "KVMI_VCPU_GET_INFO",
+	[KVMI_VCPU_PAUSE]          = "KVMI_VCPU_PAUSE",
 };
 
 static bool is_known_message(u16 id)
@@ -407,6 +408,32 @@ static int handle_event_reply(const struct kvmi_vcpu_cmd_job *job,
 	return expected->error;
 }
 
+static int handle_vcpu_control_events(const struct kvmi_vcpu_cmd_job *job,
+				      const struct kvmi_msg_hdr *msg,
+				      const void *_req)
+{
+	struct kvm_introspection *kvmi = KVMI(job->vcpu->kvm);
+	const struct kvmi_vcpu_control_events *req = _req;
+	DECLARE_BITMAP(known_events, KVMI_NUM_EVENTS);
+	int ec;
+
+	bitmap_from_u64(known_events, KVMI_KNOWN_VCPU_EVENTS);
+
+	if (req->padding1 || req->padding2)
+		ec = -KVM_EINVAL;
+	else if (req->event_id >= KVMI_NUM_EVENTS)
+		ec = -KVM_EINVAL;
+	else if (!test_bit(req->event_id, known_events))
+		ec = -KVM_EINVAL;
+	else if (!is_event_allowed(kvmi, req->event_id))
+		ec = -KVM_EPERM;
+	else
+		ec = kvmi_cmd_vcpu_control_events(job->vcpu, req->event_id,
+						  req->enable);
+
+	return kvmi_msg_vcpu_reply(job, msg, ec, NULL, 0);
+}
+
 /*
  * These commands are executed on the vCPU thread. The receiving thread
  * passes the messages using a newly allocated 'struct kvmi_vcpu_cmd_job'
@@ -415,8 +442,9 @@ static int handle_event_reply(const struct kvmi_vcpu_cmd_job *job,
  */
 static int(*const msg_vcpu[])(const struct kvmi_vcpu_cmd_job *,
 			      const struct kvmi_msg_hdr *, const void *) = {
-	[KVMI_EVENT_REPLY]   = handle_event_reply,
-	[KVMI_VCPU_GET_INFO] = handle_get_vcpu_info,
+	[KVMI_EVENT_REPLY]         = handle_event_reply,
+	[KVMI_VCPU_CONTROL_EVENTS] = handle_vcpu_control_events,
+	[KVMI_VCPU_GET_INFO]       = handle_get_vcpu_info,
 };
 
 static void kvmi_job_vcpu_cmd(struct kvm_vcpu *vcpu, void *ctx)
