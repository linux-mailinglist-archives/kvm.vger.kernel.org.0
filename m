Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA5D02C3CBE
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 10:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728461AbgKYJm5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 04:42:57 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:57144 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727971AbgKYJl6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Nov 2020 04:41:58 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 6A508305D462;
        Wed, 25 Nov 2020 11:35:49 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 487D03072785;
        Wed, 25 Nov 2020 11:35:49 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v10 41/81] KVM: introspection: add KVMI_VM_CONTROL_EVENTS
Date:   Wed, 25 Nov 2020 11:35:20 +0200
Message-Id: <20201125093600.2766-42-alazar@bitdefender.com>
In-Reply-To: <20201125093600.2766-1-alazar@bitdefender.com>
References: <20201125093600.2766-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

By default, all introspection VM events are disabled. The introspection
tool must explicitly enable the VM events it wants to receive. With this
command it can enable/disable any VM event (e.g. KVMI_VM_EVENT_UNHOOK)
if allowed by the device manager.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 42 ++++++++++++++--
 include/linux/kvmi_host.h                     |  2 +
 include/uapi/linux/kvmi.h                     | 16 +++++--
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 48 +++++++++++++++++++
 virt/kvm/introspection/kvmi.c                 | 30 +++++++++++-
 virt/kvm/introspection/kvmi_int.h             |  3 ++
 virt/kvm/introspection/kvmi_msg.c             | 29 +++++++++--
 7 files changed, 158 insertions(+), 12 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index e9c40c7ae154..b4ce7db32150 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -332,10 +332,44 @@ This command is always allowed.
 
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
+	KVMI_VM_EVENT_UNHOOK
+
+:Errors:
+
+* -KVM_EINVAL - the padding is not zero
+* -KVM_EINVAL - the event ID is unknown (use *KVMI_VM_CHECK_EVENT* first)
+* -KVM_EPERM - the access is disallowed (use *KVMI_VM_CHECK_EVENT* first)
+
 Events
 ======
 
 The VM introspection events are sent using the KVMI_VM_EVENT message id.
+No event is sent unless it is explicitly enabled.
 The message data begins with a common structure having the event id::
 
 	struct kvmi_event_hdr {
@@ -359,6 +393,8 @@ Specific event data can follow this common structure.
 
 :Returns: none
 
-This event is sent when the device manager has to pause/stop/migrate the
-guest (see **Unhooking**).  The introspection tool has a chance to unhook
-and close the KVMI channel (signaling that the operation can proceed).
+This event is sent when the device manager has to pause/stop/migrate
+the guest (see **Unhooking**) and the introspection has been enabled for
+this event (see **KVMI_VM_CONTROL_EVENTS**). The introspection tool has
+a chance to unhook and close the introspection socket (signaling that
+the operation can proceed).
diff --git a/include/linux/kvmi_host.h b/include/linux/kvmi_host.h
index 6476c7d6a4d3..a59307dac6bf 100644
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
index 18fb51078d48..9a10ef2cd890 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -19,10 +19,11 @@ enum {
 enum {
 	KVMI_VM_EVENT = KVMI_VM_MESSAGE_ID(0),
 
-	KVMI_GET_VERSION      = KVMI_VM_MESSAGE_ID(1),
-	KVMI_VM_CHECK_COMMAND = KVMI_VM_MESSAGE_ID(2),
-	KVMI_VM_CHECK_EVENT   = KVMI_VM_MESSAGE_ID(3),
-	KVMI_VM_GET_INFO      = KVMI_VM_MESSAGE_ID(4),
+	KVMI_GET_VERSION       = KVMI_VM_MESSAGE_ID(1),
+	KVMI_VM_CHECK_COMMAND  = KVMI_VM_MESSAGE_ID(2),
+	KVMI_VM_CHECK_EVENT    = KVMI_VM_MESSAGE_ID(3),
+	KVMI_VM_GET_INFO       = KVMI_VM_MESSAGE_ID(4),
+	KVMI_VM_CONTROL_EVENTS = KVMI_VM_MESSAGE_ID(5),
 
 	KVMI_NEXT_VM_MESSAGE
 };
@@ -82,4 +83,11 @@ struct kvmi_event_hdr {
 	__u16 padding[3];
 };
 
+struct kvmi_vm_control_events {
+	__u16 event_id;
+	__u8 enable;
+	__u8 padding1;
+	__u32 padding2;
+};
+
 #endif /* _UAPI__LINUX_KVMI_H */
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 01b260379c2a..430685a3371e 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -332,6 +332,31 @@ static void trigger_event_unhook_notification(struct kvm_vm *vm)
 		errno, strerror(errno));
 }
 
+static void cmd_vm_control_events(__u16 event_id, __u8 enable,
+				  int expected_err)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vm_control_events cmd;
+	} req = {};
+
+	req.cmd.event_id = event_id;
+	req.cmd.enable = enable;
+
+	test_vm_command(KVMI_VM_CONTROL_EVENTS, &req.hdr, sizeof(req),
+			NULL, 0, expected_err);
+}
+
+static void enable_vm_event(__u16 event_id)
+{
+	cmd_vm_control_events(event_id, 1, 0);
+}
+
+static void disable_vm_event(__u16 event_id)
+{
+	cmd_vm_control_events(event_id, 0, 0);
+}
+
 static void receive_event(struct kvmi_msg_hdr *msg_hdr, u16 msg_id,
 			  struct kvmi_event_hdr *ev_hdr, u16 event_id,
 			  size_t ev_size)
@@ -368,9 +393,31 @@ static void receive_vm_event_unhook(void)
 
 static void test_event_unhook(struct kvm_vm *vm)
 {
+	u16 id = KVMI_VM_EVENT_UNHOOK;
+
+	enable_vm_event(id);
+
 	trigger_event_unhook_notification(vm);
 
 	receive_vm_event_unhook();
+
+	disable_vm_event(id);
+}
+
+static void test_cmd_vm_control_events(struct kvm_vm *vm)
+{
+	__u16 id = KVMI_VM_EVENT_UNHOOK, invalid_id = 0xffff;
+	__u8 enable = 1, enable_inval = 2;
+
+	enable_vm_event(id);
+	disable_vm_event(id);
+
+	cmd_vm_control_events(id, enable_inval, -KVM_EINVAL);
+	cmd_vm_control_events(invalid_id, enable, -KVM_EINVAL);
+
+	disallow_event(vm, id);
+	cmd_vm_control_events(id, enable, -KVM_EPERM);
+	allow_event(vm, id);
 }
 
 static void test_introspection(struct kvm_vm *vm)
@@ -384,6 +431,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vm_check_event(vm);
 	test_cmd_vm_get_info();
 	test_event_unhook(vm);
+	test_cmd_vm_control_events(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 3746fd243bd8..7a0dac2e2f84 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -68,6 +68,16 @@ bool kvmi_is_known_event(u16 id)
 	return id < KVMI_NUM_EVENTS && test_bit(id, Kvmi_known_events);
 }
 
+bool kvmi_is_known_vm_event(u16 id)
+{
+	return id < KVMI_NUM_EVENTS && test_bit(id, Kvmi_known_vm_events);
+}
+
+static bool kvmi_is_vm_event_enabled(struct kvm_introspection *kvmi, u16 id)
+{
+	return id < KVMI_NUM_EVENTS && test_bit(id, kvmi->vm_event_enable_mask);
+}
+
 static void kvmi_init_always_allowed_commands(void)
 {
 	bitmap_zero(Kvmi_always_allowed_commands, KVMI_NUM_COMMANDS);
@@ -110,6 +120,7 @@ static void kvmi_free(struct kvm *kvm)
 {
 	bitmap_free(kvm->kvmi->cmd_allow_mask);
 	bitmap_free(kvm->kvmi->event_allow_mask);
+	bitmap_free(kvm->kvmi->vm_event_enable_mask);
 
 	kfree(kvm->kvmi);
 	kvm->kvmi = NULL;
@@ -126,9 +137,12 @@ kvmi_alloc(struct kvm *kvm, const struct kvm_introspection_hook *hook)
 
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
@@ -399,6 +413,9 @@ static bool kvmi_unhook_event(struct kvm_introspection *kvmi)
 {
 	int err;
 
+	if (!kvmi_is_vm_event_enabled(kvmi, KVMI_VM_EVENT_UNHOOK))
+		return false;
+
 	err = kvmi_msg_send_unhook(kvmi);
 
 	return !err;
@@ -424,3 +441,14 @@ int kvmi_ioctl_preunhook(struct kvm *kvm)
 	mutex_unlock(&kvm->kvmi_lock);
 	return err;
 }
+
+int kvmi_cmd_vm_control_events(struct kvm_introspection *kvmi,
+			       u16 event_id, bool enable)
+{
+	if (enable)
+		set_bit(event_id, kvmi->vm_event_enable_mask);
+	else
+		clear_bit(event_id, kvmi->vm_event_enable_mask);
+
+	return 0;
+}
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 57c22f20e74f..987513d6c1a7 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -26,6 +26,9 @@ void kvmi_msg_free(void *addr);
 bool kvmi_is_command_allowed(struct kvm_introspection *kvmi, u16 id);
 bool kvmi_is_event_allowed(struct kvm_introspection *kvmi, u16 id);
 bool kvmi_is_known_event(u16 id);
+bool kvmi_is_known_vm_event(u16 id);
+int kvmi_cmd_vm_control_events(struct kvm_introspection *kvmi,
+			       u16 event_id, bool enable);
 
 /* arch */
 void kvmi_arch_init_vcpu_events_mask(unsigned long *supported);
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 4acdb595301d..ffd7d95b664f 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -162,14 +162,35 @@ static int handle_vm_get_info(struct kvm_introspection *kvmi,
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
+	else if (!kvmi_is_event_allowed(kvmi, req->event_id))
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
 static kvmi_vm_msg_fct const msg_vm[] = {
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
 
 static kvmi_vm_msg_fct get_vm_msg_handler(u16 id)
