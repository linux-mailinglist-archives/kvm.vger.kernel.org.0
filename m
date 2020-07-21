Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD72A228AED
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731283AbgGUVSL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:18:11 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37860 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731219AbgGUVQC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:16:02 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 56507305D67A;
        Wed, 22 Jul 2020 00:09:25 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 34280304FA12;
        Wed, 22 Jul 2020 00:09:25 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 42/84] KVM: introspection: add KVMI_VM_CHECK_COMMAND and KVMI_VM_CHECK_EVENT
Date:   Wed, 22 Jul 2020 00:08:40 +0300
Message-Id: <20200721210922.7646-43-alazar@bitdefender.com>
In-Reply-To: <20200721210922.7646-1-alazar@bitdefender.com>
References: <20200721210922.7646-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
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
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 59 ++++++++++++++++++
 virt/kvm/introspection/kvmi.c                 | 14 +++++
 virt/kvm/introspection/kvmi_int.h             |  1 +
 virt/kvm/introspection/kvmi_msg.c             | 45 +++++++++++++-
 6 files changed, 195 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 41fd48222bcb..a2cda3268da0 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -261,3 +261,65 @@ larger/newer messages.
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
index 896fcb6abf2c..e55a0fa66ac5 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -14,7 +14,9 @@ enum {
 };
 
 enum {
-	KVMI_GET_VERSION = 1,
+	KVMI_GET_VERSION      = 1,
+	KVMI_VM_CHECK_COMMAND = 2,
+	KVMI_VM_CHECK_EVENT   = 3,
 
 	KVMI_NUM_MESSAGES
 };
@@ -49,4 +51,16 @@ struct kvmi_get_version_reply {
 	__u32 padding;
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
index d15eccc330e5..28216c4e8b9d 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -99,6 +99,8 @@ static void hook_introspection(struct kvm_vm *vm)
 	do_hook_ioctl(vm, Kvm_socket, no_padding, EEXIST);
 
 	set_command_perm(vm, KVMI_GET_VERSION, disallow, EPERM);
+	set_command_perm(vm, KVMI_VM_CHECK_COMMAND, disallow, EPERM);
+	set_command_perm(vm, KVMI_VM_CHECK_EVENT, disallow, EPERM);
 	set_command_perm(vm, all_IDs, allow_inval, EINVAL);
 	set_command_perm(vm, all_IDs, disallow, 0);
 	set_command_perm(vm, all_IDs, allow, 0);
@@ -238,6 +240,61 @@ static void test_cmd_get_version(void)
 	pr_info("KVMI version: %u\n", rpl.version);
 }
 
+static void cmd_vm_check_command(__u16 id, __u16 padding, int expected_err)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vm_check_command cmd;
+	} req = {};
+	int r;
+
+	req.cmd.id = id;
+	req.cmd.padding1 = padding;
+	req.cmd.padding2 = padding;
+
+	r = do_command(KVMI_VM_CHECK_COMMAND, &req.hdr, sizeof(req), NULL, 0);
+	TEST_ASSERT(r == expected_err,
+		"KVMI_VM_CHECK_COMMAND failed, error %d (%s), expected %d\n",
+		-r, kvm_strerror(-r), expected_err);
+}
+
+static void test_cmd_vm_check_command(void)
+{
+	__u16 valid_id = KVMI_GET_VERSION, invalid_id = 0xffff;
+	__u16 padding = 1, no_padding = 0;
+
+	cmd_vm_check_command(valid_id, no_padding, 0);
+	cmd_vm_check_command(valid_id, padding, -KVM_EINVAL);
+	cmd_vm_check_command(invalid_id, no_padding, -KVM_ENOENT);
+}
+
+static void cmd_vm_check_event(__u16 id, __u16 padding, int expected_err)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vm_check_event cmd;
+	} req = {};
+	int r;
+
+	req.cmd.id = id;
+	req.cmd.padding1 = padding;
+	req.cmd.padding2 = padding;
+
+	r = do_command(KVMI_VM_CHECK_EVENT, &req.hdr, sizeof(req), NULL, 0);
+	TEST_ASSERT(r == expected_err,
+		"KVMI_VM_CHECK_EVENT failed, error %d (%s), expected %d\n",
+		-r, kvm_strerror(-r), expected_err);
+}
+
+static void test_cmd_vm_check_event(void)
+{
+	__u16 invalid_id = 0xffff;
+	__u16 padding = 1, no_padding = 0;
+
+	cmd_vm_check_event(invalid_id, padding, -KVM_EINVAL);
+	cmd_vm_check_event(invalid_id, no_padding, -KVM_ENOENT);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	setup_socket();
@@ -245,6 +302,8 @@ static void test_introspection(struct kvm_vm *vm)
 
 	test_cmd_invalid();
 	test_cmd_get_version();
+	test_cmd_vm_check_command();
+	test_cmd_vm_check_event();
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index c44aa49dc6b5..f5ca49167f70 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -12,6 +12,7 @@
 #define KVMI_MSG_SIZE_ALLOC (sizeof(struct kvmi_msg_hdr) + KVMI_MSG_SIZE)
 
 static DECLARE_BITMAP(Kvmi_always_allowed_commands, KVMI_NUM_COMMANDS);
+static DECLARE_BITMAP(Kvmi_known_events, KVMI_NUM_EVENTS);
 
 static struct kmem_cache *msg_cache;
 
@@ -51,15 +52,28 @@ bool kvmi_is_command_allowed(struct kvm_introspection *kvmi, u16 id)
 	return id < KVMI_NUM_COMMANDS && test_bit(id, kvmi->cmd_allow_mask);
 }
 
+bool kvmi_is_known_event(u8 id)
+{
+	return id < KVMI_NUM_EVENTS && test_bit(id, Kvmi_known_events);
+}
+
 static void setup_always_allowed_commands(void)
 {
 	bitmap_zero(Kvmi_always_allowed_commands, KVMI_NUM_COMMANDS);
 	set_bit(KVMI_GET_VERSION, Kvmi_always_allowed_commands);
+	set_bit(KVMI_VM_CHECK_COMMAND, Kvmi_always_allowed_commands);
+	set_bit(KVMI_VM_CHECK_EVENT, Kvmi_always_allowed_commands);
+}
+
+static void setup_known_events(void)
+{
+	bitmap_zero(Kvmi_known_events, KVMI_NUM_EVENTS);
 }
 
 int kvmi_init(void)
 {
 	setup_always_allowed_commands();
+	setup_known_events();
 
 	return kvmi_cache_create();
 }
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 5e4eabeefc5b..0bca4bd0a415 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -30,5 +30,6 @@ bool kvmi_msg_process(struct kvm_introspection *kvmi);
 void *kvmi_msg_alloc(void);
 void kvmi_msg_free(void *addr);
 bool kvmi_is_command_allowed(struct kvm_introspection *kvmi, u16 id);
+bool kvmi_is_known_event(u8 id);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 386636aa9832..86c356afc154 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -8,6 +8,8 @@
 #include <linux/net.h>
 #include "kvmi_int.h"
 
+static bool is_vm_command(u16 id);
+
 bool kvmi_sock_get(struct kvm_introspection *kvmi, int fd)
 {
 	struct socket *sock;
@@ -109,12 +111,53 @@ static int handle_get_version(struct kvm_introspection *kvmi,
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
+static bool is_event_allowed(struct kvm_introspection *kvmi, u16 id)
+{
+	return id < KVMI_NUM_EVENTS && test_bit(id, kvmi->event_allow_mask);
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
+	else if (!is_event_allowed(kvmi, req->id))
+		ec = -KVM_EPERM;
+
+	return kvmi_msg_vm_reply(kvmi, msg, ec, NULL, 0);
+}
+
 /*
  * These commands are executed by the receiving thread.
  */
 static int(*const msg_vm[])(struct kvm_introspection *,
 			    const struct kvmi_msg_hdr *, const void *) = {
-	[KVMI_GET_VERSION] = handle_get_version,
+	[KVMI_GET_VERSION]      = handle_get_version,
+	[KVMI_VM_CHECK_COMMAND] = handle_vm_check_command,
+	[KVMI_VM_CHECK_EVENT]   = handle_vm_check_event,
 };
 
 static bool is_vm_command(u16 id)
