Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6896B1978D6
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729870AbgC3KUM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:20:12 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:43784 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729748AbgC3KUJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 06:20:09 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 410FF305FFA0;
        Mon, 30 Mar 2020 13:12:56 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 28588305B7A0;
        Mon, 30 Mar 2020 13:12:56 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v8 46/81] KVM: introspection: add KVMI_VM_CONTROL_EVENTS
Date:   Mon, 30 Mar 2020 13:12:33 +0300
Message-Id: <20200330101308.21702-47-alazar@bitdefender.com>
In-Reply-To: <20200330101308.21702-1-alazar@bitdefender.com>
References: <20200330101308.21702-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With this command the introspection tool enables/disables VM events
(ie. KVMI_EVENT_UNHOOK).

By default, all events are disabled.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 44 +++++++++++++--
 include/linux/kvmi_host.h                     |  2 +
 include/uapi/linux/kvmi.h                     | 18 +++++--
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 54 +++++++++++++++++++
 virt/kvm/introspection/kvmi.c                 | 21 +++++++-
 virt/kvm/introspection/kvmi_int.h             |  3 ++
 virt/kvm/introspection/kvmi_msg.c             | 31 +++++++++--
 7 files changed, 159 insertions(+), 14 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index e652bdd65052..7a47fade7f08 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -340,11 +340,45 @@ This command is always allowed.
 
 Returns the number of online vCPUs.
 
+5. KVMI_VM_CONTROL_EVENTS
+-------------------------
+
+:Architectures: all
+:Versions: >= 1
+:Parameters:
+
+::
+
+	struct kvmi_vm_control_events {
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
+Enables/disables VM introspection events. This command can be used with
+the following events::
+
+	KVMI_EVENT_UNHOOK
+
+:Errors:
+
+* -KVM_EINVAL - the padding is not zero
+* -KVM_EINVAL - the event ID is unknown (use *KVMI_VM_CHECK_EVENT* first)
+* -KVM_EPERM - the access is disallowed (use *KVMI_VM_CHECK_EVENT* first)
+
 Events
 ======
 
 All introspection events (VM or vCPU related) are sent
-using the *KVMI_EVENT* message id.
+using the *KVMI_EVENT* message id. No event will be sent unless
+it is explicitly enabled.
 
 The *KVMI_EVENT_UNHOOK* event doesn't have a reply and share the kvmi_event
 structure, for consistency with the vCPU events.
@@ -398,6 +432,8 @@ Specific data can follow these common structures.
 
 :Returns: none
 
-This event is sent when the device manager has to pause/stop/migrate the
-guest (see **Unhooking**).  The introspection tool has a chance to unhook
-and close the KVMI channel (signaling that the operation can proceed).
+This event is sent when the device manager has to pause/stop/migrate
+the guest (see **Unhooking**) and the introspection has been enabled
+for this event (see **KVMI_VM_CONTROL_EVENTS**). The introspection tool
+has a chance to unhook and close the KVMI channel (signaling that the
+operation can proceed).
diff --git a/include/linux/kvmi_host.h b/include/linux/kvmi_host.h
index 180e26335a8f..41b22af771fb 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -22,6 +22,8 @@ struct kvm_introspection {
 	DECLARE_BITMAP(cmd_allow_mask, KVMI_NUM_COMMANDS);
 	DECLARE_BITMAP(event_allow_mask, KVMI_NUM_EVENTS);
 
+	DECLARE_BITMAP(vm_event_enable_mask, KVMI_NUM_EVENTS);
+
 	atomic_t ev_seq;
 };
 
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 689eba32c031..66e04a82f054 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -15,12 +15,13 @@ enum {
 };
 
 enum {
-	KVMI_EVENT            = 1,
+	KVMI_EVENT             = 1,
 
-	KVMI_GET_VERSION      = 2,
-	KVMI_VM_CHECK_COMMAND = 3,
-	KVMI_VM_CHECK_EVENT   = 4,
-	KVMI_VM_GET_INFO      = 5,
+	KVMI_GET_VERSION       = 2,
+	KVMI_VM_CHECK_COMMAND  = 3,
+	KVMI_VM_CHECK_EVENT    = 4,
+	KVMI_VM_GET_INFO       = 5,
+	KVMI_VM_CONTROL_EVENTS = 6,
 
 	KVMI_NUM_MESSAGES
 };
@@ -75,6 +76,13 @@ struct kvmi_vm_get_info_reply {
 	__u32 padding[3];
 };
 
+struct kvmi_vm_control_events {
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
index 9cb65f8c946f..c3beea3feb26 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -245,9 +245,15 @@ static int cmd_check_event(__u16 id)
 
 static void test_cmd_check_event(void)
 {
+	__u16 valid_id = KVMI_EVENT_UNHOOK;
 	__u16 invalid_id = 0xffff;
 	int r;
 
+	r = cmd_check_event(valid_id);
+	TEST_ASSERT(r == 0,
+		"KVMI_VM_CHECK_EVENT failed, error %d (%s)\n",
+		-r, kvm_strerror(-r));
+
 	r = cmd_check_event(invalid_id);
 	TEST_ASSERT(r == -KVM_ENOENT,
 		"KVMI_VM_CHECK_EVENT didn't failed with -KVM_ENOENT, error %d (%s)\n",
@@ -298,15 +304,62 @@ static void receive_event(struct kvmi_msg_hdr *hdr, struct kvmi_event *ev,
 		ev->event, event_id);
 }
 
+static int cmd_vm_control_events(__u16 event_id, bool enable)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vm_control_events cmd;
+	} req = {};
+
+	req.cmd.event_id = event_id;
+	req.cmd.enable = enable ? 1 : 0;
+
+	return do_command(KVMI_VM_CONTROL_EVENTS, &req.hdr, sizeof(req),
+			     NULL, 0);
+}
+
+static void enable_vm_event(__u16 event_id)
+{
+	int r;
+
+	r = cmd_vm_control_events(event_id, true);
+	TEST_ASSERT(r == 0,
+		"KVMI_VM_CONTROL_EVENTS failed to enable VM event %d, error %d (%s)\n",
+		event_id, -r, kvm_strerror(-r));
+}
+
+static void disable_vm_event(__u16 event_id)
+{
+	int r;
+
+	r = cmd_vm_control_events(event_id, false);
+	TEST_ASSERT(r == 0,
+		"KVMI_VM_CONTROL_EVENTS failed to disable VM event %d, error %d (%s)\n",
+		event_id, -r, kvm_strerror(-r));
+}
+
 static void test_event_unhook(struct kvm_vm *vm)
 {
 	__u16 id = KVMI_EVENT_UNHOOK;
 	struct kvmi_msg_hdr hdr;
 	struct kvmi_event ev;
 
+	enable_vm_event(id);
+
 	trigger_event_unhook_notification(vm);
 
 	receive_event(&hdr, &ev, sizeof(ev), id);
+
+	disable_vm_event(id);
+}
+
+static void test_cmd_vm_control_events(void)
+{
+	__u16 id = KVMI_EVENT_UNHOOK;
+
+	enable_vm_event(id);
+
+	disable_vm_event(id);
 }
 
 static void test_introspection(struct kvm_vm *vm)
@@ -320,6 +373,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_check_event();
 	test_cmd_get_vm_info();
 	test_event_unhook(vm);
+	test_cmd_vm_control_events();
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index bf6d5ec951c8..ec4515be5acc 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -12,7 +12,7 @@
 
 static DECLARE_BITMAP(Kvmi_always_allowed_commands, KVMI_NUM_COMMANDS);
 DECLARE_BITMAP(Kvmi_known_events, KVMI_NUM_EVENTS);
-static DECLARE_BITMAP(Kvmi_known_vm_events, KVMI_NUM_EVENTS);
+DECLARE_BITMAP(Kvmi_known_vm_events, KVMI_NUM_EVENTS);
 static DECLARE_BITMAP(Kvmi_known_vcpu_events, KVMI_NUM_EVENTS);
 
 static struct kmem_cache *msg_cache;
@@ -360,10 +360,18 @@ int kvmi_ioctl_command(struct kvm *kvm, void __user *argp)
 	return err;
 }
 
+static bool is_vm_event_enabled(struct kvm_introspection *kvmi, int event)
+{
+	return test_bit(event, kvmi->vm_event_enable_mask);
+}
+
 static bool kvmi_unhook_event(struct kvm_introspection *kvmi)
 {
 	int err;
 
+	if (!is_vm_event_enabled(kvmi, KVMI_EVENT_UNHOOK))
+		return false;
+
 	err = kvmi_msg_send_unhook(kvmi);
 
 	return !err;
@@ -389,3 +397,14 @@ int kvmi_ioctl_preunhook(struct kvm *kvm)
 	mutex_unlock(&kvm->kvmi_lock);
 	return err;
 }
+
+int kvmi_cmd_vm_control_events(struct kvm_introspection *kvmi,
+				unsigned int event_id, bool enable)
+{
+	if (enable)
+		set_bit(event_id, kvmi->vm_event_enable_mask);
+	else
+		clear_bit(event_id, kvmi->vm_event_enable_mask);
+
+	return 0;
+}
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index ecd0625e0c9e..75078248a69c 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -17,6 +17,7 @@
 	kvm_info("%pU ERROR: " fmt, &kvmi->uuid, ## __VA_ARGS__)
 
 extern DECLARE_BITMAP(Kvmi_known_events, KVMI_NUM_EVENTS);
+extern DECLARE_BITMAP(Kvmi_known_vm_events, KVMI_NUM_EVENTS);
 
 #define KVMI(kvm) ((kvm)->kvmi)
 
@@ -30,5 +31,7 @@ int kvmi_msg_send_unhook(struct kvm_introspection *kvmi);
 /* kvmi.c */
 void *kvmi_msg_alloc(void);
 void kvmi_msg_free(void *addr);
+int kvmi_cmd_vm_control_events(struct kvm_introspection *kvmi,
+				unsigned int event_id, bool enable);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index b381273b7355..4d897c65085b 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -171,15 +171,38 @@ static int handle_get_info(struct kvm_introspection *kvmi,
 	return kvmi_msg_vm_reply(kvmi, msg, 0, &rpl, sizeof(rpl));
 }
 
+static int handle_vm_control_events(struct kvm_introspection *kvmi,
+				    const struct kvmi_msg_hdr *msg,
+				    const void *_req)
+{
+	const struct kvmi_vm_control_events *req = _req;
+	int ec;
+
+	if (req->padding1 || req->padding2 || req->enable > 1)
+		ec = -KVM_EINVAL;
+	else if (req->event_id >= KVMI_NUM_EVENTS)
+		ec = -KVM_EINVAL;
+	else if (!test_bit(req->event_id, Kvmi_known_vm_events))
+		ec = -KVM_EINVAL;
+	else if (!is_event_allowed(kvmi, req->event_id))
+		ec = -KVM_EPERM;
+	else
+		ec = kvmi_cmd_vm_control_events(kvmi, req->event_id,
+						req->enable == 1);
+
+	return kvmi_msg_vm_reply(kvmi, msg, ec, NULL, 0);
+}
+
 /*
  * These commands are executed by the receiving thread/worker.
  */
 static int(*const msg_vm[])(struct kvm_introspection *,
 			    const struct kvmi_msg_hdr *, const void *) = {
-	[KVMI_GET_VERSION]      = handle_get_version,
-	[KVMI_VM_CHECK_COMMAND] = handle_check_command,
-	[KVMI_VM_CHECK_EVENT]   = handle_check_event,
-	[KVMI_VM_GET_INFO]      = handle_get_info,
+	[KVMI_GET_VERSION]       = handle_get_version,
+	[KVMI_VM_CHECK_COMMAND]  = handle_check_command,
+	[KVMI_VM_CHECK_EVENT]    = handle_check_event,
+	[KVMI_VM_CONTROL_EVENTS] = handle_vm_control_events,
+	[KVMI_VM_GET_INFO]       = handle_get_info,
 };
 
 static bool is_vm_command(u16 id)
