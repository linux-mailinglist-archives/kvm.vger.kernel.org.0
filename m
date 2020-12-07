Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 092D92D1B0C
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 21:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbgLGUsM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 15:48:12 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:42572 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727148AbgLGUsL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 15:48:11 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 3630A305D464;
        Mon,  7 Dec 2020 22:46:18 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 144273072785;
        Mon,  7 Dec 2020 22:46:18 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v11 37/81] KVM: introspection: add KVMI_VM_CHECK_COMMAND and KVMI_VM_CHECK_EVENT
Date:   Mon,  7 Dec 2020 22:45:38 +0200
Message-Id: <20201207204622.15258-38-alazar@bitdefender.com>
In-Reply-To: <20201207204622.15258-1-alazar@bitdefender.com>
References: <20201207204622.15258-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These commands are used to check what introspection commands and events
are supported (kernel) and allowed (device manager).

These are alternative methods to KVMI_GET_VERSION in checking if the
introspection supports a specific command/event.

As with the KVMI_GET_VERSION command, these two commands can never be
disallowed by the device manager.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 62 +++++++++++++++++++
 include/uapi/linux/kvmi.h                     | 16 ++++-
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 45 ++++++++++++++
 virt/kvm/introspection/kvmi.c                 | 19 ++++++
 virt/kvm/introspection/kvmi_int.h             |  2 +
 virt/kvm/introspection/kvmi_msg.c             | 40 +++++++++++-
 6 files changed, 182 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index d3d672a07872..13169575f75f 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -250,3 +250,65 @@ larger messages.
 The introspection tool should use this command to identify the features
 supported by the kernel side and what messages must be used for event
 replies.
+
+2. KVMI_VM_CHECK_COMMAND
+------------------------
+
+:Architectures: all
+:Versions: >= 1
+:Parameters:
+
+::
+
+	struct kvmi_vm_check_command {
+		__u16 id;
+		__u16 padding1;
+		__u32 padding2;
+	};
+
+:Returns:
+
+::
+
+	struct kvmi_error_code;
+
+Checks if the command specified by ``id`` is supported and allowed.
+
+This command is always allowed.
+
+:Errors:
+
+* -KVM_ENOENT - the command specified by ``id`` is unsupported
+* -KVM_EPERM - the command specified by ``id`` is disallowed
+* -KVM_EINVAL - the padding is not zero
+
+3. KVMI_VM_CHECK_EVENT
+----------------------
+
+:Architectures: all
+:Versions: >= 1
+:Parameters:
+
+::
+
+	struct kvmi_vm_check_event {
+		__u16 id;
+		__u16 padding1;
+		__u32 padding2;
+	};
+
+:Returns:
+
+::
+
+	struct kvmi_error_code;
+
+Checks if the event specified by ``id`` is supported and allowed.
+
+This command is always allowed.
+
+:Errors:
+
+* -KVM_ENOENT - the event specified by ``id`` is unsupported
+* -KVM_EPERM - the event specified by ``id`` is disallowed
+* -KVM_EINVAL - the padding is not zero
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 77dd727dfe18..0c2d0cedde6f 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -17,7 +17,9 @@ enum {
 #define KVMI_VCPU_MESSAGE_ID(id) (((id) << 1) | 1)
 
 enum {
-	KVMI_GET_VERSION = KVMI_VM_MESSAGE_ID(1),
+	KVMI_GET_VERSION      = KVMI_VM_MESSAGE_ID(1),
+	KVMI_VM_CHECK_COMMAND = KVMI_VM_MESSAGE_ID(2),
+	KVMI_VM_CHECK_EVENT   = KVMI_VM_MESSAGE_ID(3),
 
 	KVMI_NEXT_VM_MESSAGE
 };
@@ -53,4 +55,16 @@ struct kvmi_get_version_reply {
 	__u32 max_msg_size;
 };
 
+struct kvmi_vm_check_command {
+	__u16 id;
+	__u16 padding1;
+	__u32 padding2;
+};
+
+struct kvmi_vm_check_event {
+	__u16 id;
+	__u16 padding1;
+	__u32 padding2;
+};
+
 #endif /* _UAPI__LINUX_KVMI_H */
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 30acd3a2d030..cd8f16a3ce3a 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -93,6 +93,8 @@ static void hook_introspection(struct kvm_vm *vm)
 	do_hook_ioctl(vm, Kvm_socket, EEXIST);
 
 	set_command_perm(vm, KVMI_GET_VERSION, disallow, EPERM);
+	set_command_perm(vm, KVMI_VM_CHECK_COMMAND, disallow, EPERM);
+	set_command_perm(vm, KVMI_VM_CHECK_EVENT, disallow, EPERM);
 	set_command_perm(vm, all_IDs, allow_inval, EINVAL);
 	set_command_perm(vm, all_IDs, disallow, 0);
 	set_command_perm(vm, all_IDs, allow, 0);
@@ -241,6 +243,47 @@ static void test_cmd_get_version(void)
 	pr_debug("Max message size: %u\n", rpl.max_msg_size);
 }
 
+static void cmd_vm_check_command(__u16 id, int expected_err)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vm_check_command cmd;
+	} req = {};
+
+	req.cmd.id = id;
+
+	test_vm_command(KVMI_VM_CHECK_COMMAND, &req.hdr, sizeof(req), NULL, 0,
+			expected_err);
+}
+
+static void test_cmd_vm_check_command(void)
+{
+	__u16 valid_id = KVMI_GET_VERSION, invalid_id = 0xffff;
+
+	cmd_vm_check_command(valid_id, 0);
+	cmd_vm_check_command(invalid_id, -KVM_ENOENT);
+}
+
+static void cmd_vm_check_event(__u16 id, int expected_err)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vm_check_event cmd;
+	} req = {};
+
+	req.cmd.id = id;
+
+	test_vm_command(KVMI_VM_CHECK_EVENT, &req.hdr, sizeof(req), NULL, 0,
+			expected_err);
+}
+
+static void test_cmd_vm_check_event(void)
+{
+	__u16 invalid_id = 0xffff;
+
+	cmd_vm_check_event(invalid_id, -KVM_ENOENT);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	setup_socket();
@@ -248,6 +291,8 @@ static void test_introspection(struct kvm_vm *vm)
 
 	test_cmd_invalid();
 	test_cmd_get_version();
+	test_cmd_vm_check_command();
+	test_cmd_vm_check_event();
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index a9095a834ba3..d103061b5da6 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -16,6 +16,7 @@
 #define KVMI_MSG_SIZE_ALLOC (sizeof(struct kvmi_msg_hdr) + KVMI_MAX_MSG_SIZE)
 
 static DECLARE_BITMAP(Kvmi_always_allowed_commands, KVMI_NUM_COMMANDS);
+static DECLARE_BITMAP(Kvmi_known_events, KVMI_NUM_EVENTS);
 
 static struct kmem_cache *msg_cache;
 
@@ -55,15 +56,33 @@ bool kvmi_is_command_allowed(struct kvm_introspection *kvmi, u16 id)
 	return id < KVMI_NUM_COMMANDS && test_bit(id, kvmi->cmd_allow_mask);
 }
 
+bool kvmi_is_event_allowed(struct kvm_introspection *kvmi, u16 id)
+{
+	return id < KVMI_NUM_EVENTS && test_bit(id, kvmi->event_allow_mask);
+}
+
+bool kvmi_is_known_event(u16 id)
+{
+	return id < KVMI_NUM_EVENTS && test_bit(id, Kvmi_known_events);
+}
+
 static void kvmi_init_always_allowed_commands(void)
 {
 	bitmap_zero(Kvmi_always_allowed_commands, KVMI_NUM_COMMANDS);
 	set_bit(KVMI_GET_VERSION, Kvmi_always_allowed_commands);
+	set_bit(KVMI_VM_CHECK_COMMAND, Kvmi_always_allowed_commands);
+	set_bit(KVMI_VM_CHECK_EVENT, Kvmi_always_allowed_commands);
+}
+
+static void kvmi_init_known_events(void)
+{
+	bitmap_zero(Kvmi_known_events, KVMI_NUM_EVENTS);
 }
 
 int kvmi_init(void)
 {
 	kvmi_init_always_allowed_commands();
+	kvmi_init_known_events();
 
 	return kvmi_cache_create();
 }
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 206aaf93f8ba..1e1d1fad4035 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -23,5 +23,7 @@ bool kvmi_msg_process(struct kvm_introspection *kvmi);
 void *kvmi_msg_alloc(void);
 void kvmi_msg_free(void *addr);
 bool kvmi_is_command_allowed(struct kvm_introspection *kvmi, u16 id);
+bool kvmi_is_event_allowed(struct kvm_introspection *kvmi, u16 id);
+bool kvmi_is_known_event(u16 id);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 57708da2af20..6538c7af710a 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -12,6 +12,8 @@ typedef int (*kvmi_vm_msg_fct)(struct kvm_introspection *kvmi,
 			       const struct kvmi_msg_hdr *msg,
 			       const void *req);
 
+static bool is_vm_command(u16 id);
+
 bool kvmi_sock_get(struct kvm_introspection *kvmi, int fd)
 {
 	struct socket *sock;
@@ -114,11 +116,47 @@ static int handle_get_version(struct kvm_introspection *kvmi,
 	return kvmi_msg_vm_reply(kvmi, msg, 0, &rpl, sizeof(rpl));
 }
 
+static int handle_vm_check_command(struct kvm_introspection *kvmi,
+				   const struct kvmi_msg_hdr *msg,
+				   const void *_req)
+{
+	const struct kvmi_vm_check_command *req = _req;
+	int ec = 0;
+
+	if (req->padding1 || req->padding2)
+		ec = -KVM_EINVAL;
+	else if (!is_vm_command(req->id))
+		ec = -KVM_ENOENT;
+	else if (!kvmi_is_command_allowed(kvmi, req->id))
+		ec = -KVM_EPERM;
+
+	return kvmi_msg_vm_reply(kvmi, msg, ec, NULL, 0);
+}
+
+static int handle_vm_check_event(struct kvm_introspection *kvmi,
+				 const struct kvmi_msg_hdr *msg,
+				 const void *_req)
+{
+	const struct kvmi_vm_check_event *req = _req;
+	int ec = 0;
+
+	if (req->padding1 || req->padding2)
+		ec = -KVM_EINVAL;
+	else if (!kvmi_is_known_event(req->id))
+		ec = -KVM_ENOENT;
+	else if (!kvmi_is_event_allowed(kvmi, req->id))
+		ec = -KVM_EPERM;
+
+	return kvmi_msg_vm_reply(kvmi, msg, ec, NULL, 0);
+}
+
 /*
  * These commands are executed by the receiving thread.
  */
 static kvmi_vm_msg_fct const msg_vm[] = {
-	[KVMI_GET_VERSION] = handle_get_version,
+	[KVMI_GET_VERSION]      = handle_get_version,
+	[KVMI_VM_CHECK_COMMAND] = handle_vm_check_command,
+	[KVMI_VM_CHECK_EVENT]   = handle_vm_check_event,
 };
 
 static kvmi_vm_msg_fct get_vm_msg_handler(u16 id)
