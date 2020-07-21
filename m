Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5343E228AFA
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731223AbgGUVP6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:15:58 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37760 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731183AbgGUVPy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:15:54 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id E3E82305D61A;
        Wed, 22 Jul 2020 00:09:25 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id CB0E6304FA12;
        Wed, 22 Jul 2020 00:09:25 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 45/84] KVM: introspection: add KVMI_VM_CONTROL_EVENTS
Date:   Wed, 22 Jul 2020 00:08:43 +0300
Message-Id: <20200721210922.7646-46-alazar@bitdefender.com>
In-Reply-To: <20200721210922.7646-1-alazar@bitdefender.com>
References: <20200721210922.7646-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

By default, all introspection VM events are disabled. The introspection
tool must explicitly enable the VM events it wants to receive. With
this command (KVMI_VM_CONTROL_EVENTS) it can enable/disable any VM event
(e.g. KVMI_EVENT_UNHOOK) if allowed by the device manager.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 44 +++++++++++++--
 include/linux/kvmi_host.h                     |  2 +
 include/uapi/linux/kvmi.h                     | 16 ++++--
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 54 +++++++++++++++++++
 virt/kvm/introspection/kvmi.c                 | 30 ++++++++++-
 virt/kvm/introspection/kvmi_int.h             |  3 ++
 virt/kvm/introspection/kvmi_msg.c             | 29 ++++++++--
 7 files changed, 165 insertions(+), 13 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 4174c969cb47..4ec0046b4138 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -342,11 +342,45 @@ This command is always allowed.
 
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
@@ -400,6 +434,8 @@ Specific event data can follow these common structures.
 
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
index 8d21e031788e..8e142096ba47 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -18,6 +18,8 @@ struct kvm_introspection {
 	unsigned long *cmd_allow_mask;
 	unsigned long *event_allow_mask;
 
+	unsigned long *vm_event_enable_mask;
+
 	atomic_t ev_seq;
 };
 
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 9fbe52caf96c..f9e2cb8a2c5e 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -17,10 +17,11 @@ enum {
 enum {
 	KVMI_EVENT            = 0,
 
-	KVMI_GET_VERSION      = 1,
-	KVMI_VM_CHECK_COMMAND = 2,
-	KVMI_VM_CHECK_EVENT   = 3,
-	KVMI_VM_GET_INFO      = 4,
+	KVMI_GET_VERSION       = 1,
+	KVMI_VM_CHECK_COMMAND  = 2,
+	KVMI_VM_CHECK_EVENT    = 3,
+	KVMI_VM_GET_INFO       = 4,
+	KVMI_VM_CONTROL_EVENTS = 5,
 
 	KVMI_NUM_MESSAGES
 };
@@ -74,6 +75,13 @@ struct kvmi_vm_get_info_reply {
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
index 3d46d6e6b38c..bb2daaca0291 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -370,15 +370,68 @@ static void receive_event(struct kvmi_msg_hdr *hdr, struct kvmi_event *ev,
 		hdr->size, ev_size);
 }
 
+static void cmd_vm_control_events(__u16 event_id, __u8 enable, __u16 padding,
+				  int expected_err)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vm_control_events cmd;
+	} req = {};
+	int r;
+
+	req.cmd.event_id = event_id;
+	req.cmd.enable = enable;
+	req.cmd.padding1 = padding;
+	req.cmd.padding2 = padding;
+
+	r = do_command(KVMI_VM_CONTROL_EVENTS, &req.hdr, sizeof(req),
+			     NULL, 0);
+	TEST_ASSERT(r == expected_err,
+		"KVMI_VM_CONTROL_EVENTS failed to enable VM event %d, error %d (%s), expected error %d\n",
+		event_id, -r, kvm_strerror(-r), expected_err);
+}
+
+static void enable_vm_event(__u16 event_id)
+{
+	cmd_vm_control_events(event_id, 1, 0, 0);
+}
+
+static void disable_vm_event(__u16 event_id)
+{
+	cmd_vm_control_events(event_id, 0, 0, 0);
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
+static void test_cmd_vm_control_events(struct kvm_vm *vm)
+{
+	__u16 id = KVMI_EVENT_UNHOOK, invalid_id = 0xffff;
+	__u16 padding = 1, no_padding = 0;
+	__u8 enable = 1, enable_inval = 2;
+
+	enable_vm_event(id);
+	disable_vm_event(id);
+
+	cmd_vm_control_events(id, enable, padding, -KVM_EINVAL);
+	cmd_vm_control_events(id, enable_inval, no_padding, -KVM_EINVAL);
+	cmd_vm_control_events(invalid_id, enable, no_padding, -KVM_EINVAL);
+
+	disallow_event(vm, id);
+	cmd_vm_control_events(id, enable, no_padding, -KVM_EPERM);
+	allow_event(vm, id);
 }
 
 static void test_introspection(struct kvm_vm *vm)
@@ -392,6 +445,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vm_check_event(vm);
 	test_cmd_vm_get_info();
 	test_event_unhook(vm);
+	test_cmd_vm_control_events(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index f128b1407c84..5af6ea041035 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -59,6 +59,16 @@ bool kvmi_is_known_event(u8 id)
 	return id < KVMI_NUM_EVENTS && test_bit(id, Kvmi_known_events);
 }
 
+bool kvmi_is_known_vm_event(u8 id)
+{
+	return id < KVMI_NUM_EVENTS && test_bit(id, Kvmi_known_vm_events);
+}
+
+static bool is_vm_event_enabled(struct kvm_introspection *kvmi, int event)
+{
+	return test_bit(event, kvmi->vm_event_enable_mask);
+}
+
 static void setup_always_allowed_commands(void)
 {
 	bitmap_zero(Kvmi_always_allowed_commands, KVMI_NUM_COMMANDS);
@@ -100,6 +110,7 @@ static void free_kvmi(struct kvm *kvm)
 {
 	bitmap_free(kvm->kvmi->cmd_allow_mask);
 	bitmap_free(kvm->kvmi->event_allow_mask);
+	bitmap_free(kvm->kvmi->vm_event_enable_mask);
 
 	kfree(kvm->kvmi);
 	kvm->kvmi = NULL;
@@ -116,9 +127,12 @@ alloc_kvmi(struct kvm *kvm, const struct kvm_introspection_hook *hook)
 
 	kvmi->cmd_allow_mask = bitmap_zalloc(KVMI_NUM_COMMANDS, GFP_KERNEL);
 	kvmi->event_allow_mask = bitmap_zalloc(KVMI_NUM_EVENTS, GFP_KERNEL);
-	if (!kvmi->cmd_allow_mask || !kvmi->event_allow_mask) {
+	kvmi->vm_event_enable_mask = bitmap_zalloc(KVMI_NUM_EVENTS, GFP_KERNEL);
+	if (!kvmi->cmd_allow_mask || !kvmi->event_allow_mask ||
+	    !kvmi->vm_event_enable_mask) {
 		bitmap_free(kvmi->cmd_allow_mask);
 		bitmap_free(kvmi->event_allow_mask);
+		bitmap_free(kvmi->vm_event_enable_mask);
 		kfree(kvmi);
 		return NULL;
 	}
@@ -392,6 +406,9 @@ static bool kvmi_unhook_event(struct kvm_introspection *kvmi)
 {
 	int err;
 
+	if (!is_vm_event_enabled(kvmi, KVMI_EVENT_UNHOOK))
+		return false;
+
 	err = kvmi_msg_send_unhook(kvmi);
 
 	return !err;
@@ -417,3 +434,14 @@ int kvmi_ioctl_preunhook(struct kvm *kvm)
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
index c385dc0eb708..7c503b8ca043 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -32,5 +32,8 @@ void *kvmi_msg_alloc(void);
 void kvmi_msg_free(void *addr);
 bool kvmi_is_command_allowed(struct kvm_introspection *kvmi, u16 id);
 bool kvmi_is_known_event(u8 id);
+bool kvmi_is_known_vm_event(u8 id);
+int kvmi_cmd_vm_control_events(struct kvm_introspection *kvmi,
+				unsigned int event_id, bool enable);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 596f5c02bb8c..a148ed1e767c 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -162,15 +162,36 @@ static int handle_vm_get_info(struct kvm_introspection *kvmi,
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
+	else if (!kvmi_is_known_vm_event(req->event_id))
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
  * These commands are executed by the receiving thread.
  */
 static int(*const msg_vm[])(struct kvm_introspection *,
 			    const struct kvmi_msg_hdr *, const void *) = {
-	[KVMI_GET_VERSION]      = handle_get_version,
-	[KVMI_VM_CHECK_COMMAND] = handle_vm_check_command,
-	[KVMI_VM_CHECK_EVENT]   = handle_vm_check_event,
-	[KVMI_VM_GET_INFO]      = handle_vm_get_info,
+	[KVMI_GET_VERSION]       = handle_get_version,
+	[KVMI_VM_CHECK_COMMAND]  = handle_vm_check_command,
+	[KVMI_VM_CHECK_EVENT]    = handle_vm_check_event,
+	[KVMI_VM_CONTROL_EVENTS] = handle_vm_control_events,
+	[KVMI_VM_GET_INFO]       = handle_vm_get_info,
 };
 
 static bool is_vm_command(u16 id)
