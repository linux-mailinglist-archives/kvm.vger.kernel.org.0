Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A57D3155DAA
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727895AbgBGSRr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:17:47 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40710 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727598AbgBGSQv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:51 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 94210305D34A;
        Fri,  7 Feb 2020 20:16:40 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 8A9003052068;
        Fri,  7 Feb 2020 20:16:40 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v7 44/78] KVM: introspection: add KVMI_VM_CONTROL_EVENTS
Date:   Fri,  7 Feb 2020 20:16:02 +0200
Message-Id: <20200207181636.1065-45-alazar@bitdefender.com>
In-Reply-To: <20200207181636.1065-1-alazar@bitdefender.com>
References: <20200207181636.1065-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With this command the introspection tool enables/disables VM events
(ie. KVMI_EVENT_UNHOOK), because no event (neither VM event, nor vCPU
event) will be sent to the introspection tool unless enabled/requested.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 44 +++++++++++++++--
 include/linux/kvmi_host.h                     |  2 +
 include/uapi/linux/kvmi.h                     | 18 +++++--
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 48 +++++++++++++++++++
 virt/kvm/introspection/kvmi.c                 | 14 ++++++
 virt/kvm/introspection/kvmi_int.h             |  9 ++++
 virt/kvm/introspection/kvmi_msg.c             | 43 +++++++++++++----
 7 files changed, 161 insertions(+), 17 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 949e940487ab..7039f4d2b782 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -333,11 +333,45 @@ This command is always allowed.
 
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
+* -KVM_EINVAL - the event ID is invalid/unknown (use *KVMI_VM_CHECK_EVENT* first)
+* -KVM_EINVAL - padding is not zero
+* -KVM_EPERM - the access is restricted by the host
+
 Events
 ======
 
 All introspection events (VM or vCPU related) are sent
-using the *KVMI_EVENT* message id.
+using the *KVMI_EVENT* message id. No event will be sent unless
+it is explicitly enabled.
 
 The *KVMI_EVENT_UNHOOK* event doesn't have a reply and share the kvmi_event
 structure, for consistency with the vCPU events.
@@ -391,6 +425,8 @@ Specific data can follow these common structures.
 
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
index e74240aff5b7..da9bf30ae513 100644
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
@@ -68,6 +69,13 @@ struct kvmi_vm_get_info_reply {
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
index f5d67fd0cde8..23dba71e7dc6 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -298,15 +298,62 @@ static void receive_event(struct kvmi_msg_hdr *hdr, struct kvmi_event *ev,
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
@@ -320,6 +367,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_check_event();
 	test_cmd_get_vm_info();
 	test_event_unhook(vm);
+	test_cmd_vm_control_events();
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 74e3e1aa326b..9d246152c5e8 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -331,6 +331,9 @@ static bool kvmi_unhook_event(struct kvm_introspection *kvmi)
 {
 	int err;
 
+	if (!is_vm_event_enabled(kvmi, KVMI_EVENT_UNHOOK))
+		return false;
+
 	err = kvmi_msg_send_unhook(kvmi);
 
 	return !err;
@@ -354,3 +357,14 @@ int kvmi_ioctl_preunhook(struct kvm *kvm)
 
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
index 3ea8e8250f7d..d1c143334626 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -29,11 +29,18 @@
 			  BIT(KVMI_GET_VERSION) \
 			| BIT(KVMI_VM_CHECK_COMMAND) \
 			| BIT(KVMI_VM_CHECK_EVENT) \
+			| BIT(KVMI_VM_CONTROL_EVENTS) \
 			| BIT(KVMI_VM_GET_INFO) \
 		)
 
 #define KVMI(kvm) ((struct kvm_introspection *)((kvm)->kvmi))
 
+static inline bool is_vm_event_enabled(struct kvm_introspection *kvmi,
+					int event)
+{
+	return test_bit(event, kvmi->vm_event_enable_mask);
+}
+
 /* kvmi_msg.c */
 bool kvmi_sock_get(struct kvm_introspection *kvmi, int fd);
 void kvmi_sock_shutdown(struct kvm_introspection *kvmi);
@@ -45,5 +52,7 @@ int kvmi_msg_send_unhook(struct kvm_introspection *kvmi);
 void *kvmi_msg_alloc(void);
 void *kvmi_msg_alloc_check(size_t size);
 void kvmi_msg_free(void *addr);
+int kvmi_cmd_vm_control_events(struct kvm_introspection *kvmi,
+				unsigned int event_id, bool enable);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index dbc2ba9a1399..79b26853b5cb 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -9,10 +9,11 @@
 #include "kvmi_int.h"
 
 static const char *const msg_IDs[] = {
-	[KVMI_GET_VERSION]      = "KVMI_GET_VERSION",
-	[KVMI_VM_CHECK_COMMAND] = "KVMI_VM_CHECK_COMMAND",
-	[KVMI_VM_CHECK_EVENT]   = "KVMI_VM_CHECK_EVENT",
-	[KVMI_VM_GET_INFO]      = "KVMI_VM_GET_INFO",
+	[KVMI_GET_VERSION]       = "KVMI_GET_VERSION",
+	[KVMI_VM_CHECK_COMMAND]  = "KVMI_VM_CHECK_COMMAND",
+	[KVMI_VM_CHECK_EVENT]    = "KVMI_VM_CHECK_EVENT",
+	[KVMI_VM_CONTROL_EVENTS] = "KVMI_VM_CONTROL_EVENTS",
+	[KVMI_VM_GET_INFO]       = "KVMI_VM_GET_INFO",
 };
 
 static bool is_known_message(u16 id)
@@ -181,15 +182,41 @@ static int handle_get_info(struct kvm_introspection *kvmi,
 	return kvmi_msg_vm_reply(kvmi, msg, 0, &rpl, sizeof(rpl));
 }
 
+static int handle_vm_control_events(struct kvm_introspection *kvmi,
+				    const struct kvmi_msg_hdr *msg,
+				    const void *_req)
+{
+	const struct kvmi_vm_control_events *req = _req;
+	DECLARE_BITMAP(known_events, KVMI_NUM_EVENTS);
+	int ec;
+
+	bitmap_from_u64(known_events, KVMI_KNOWN_VM_EVENTS);
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
+		ec = kvmi_cmd_vm_control_events(kvmi, req->event_id,
+						req->enable);
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
 
 static bool is_vm_message(u16 id)
