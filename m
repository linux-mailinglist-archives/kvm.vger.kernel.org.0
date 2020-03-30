Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94ADC197926
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729705AbgC3KVt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:21:49 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:43750 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729325AbgC3KT4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 06:19:56 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 843CE30644B8;
        Mon, 30 Mar 2020 13:12:55 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 53C0C305B7A1;
        Mon, 30 Mar 2020 13:12:55 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v8 43/81] KVM: introspection: add KVMI_VM_CHECK_COMMAND and KVMI_VM_CHECK_EVENT
Date:   Mon, 30 Mar 2020 13:12:30 +0300
Message-Id: <20200330101308.21702-44-alazar@bitdefender.com>
In-Reply-To: <20200330101308.21702-1-alazar@bitdefender.com>
References: <20200330101308.21702-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These commands are used to check what introspection commands and events
are supported (by kernel) and allowed (by userspace).

These are alternative methods to KVMI_GET_VERSION in checking if the
introspection supports a specific command/event.

As with the KVMI_GET_VERSION command, these two can never be disallowed
by userspace.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 62 +++++++++++++++++++
 include/uapi/linux/kvmi.h                     | 16 ++++-
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 55 ++++++++++++++++
 virt/kvm/introspection/kvmi.c                 |  9 +++
 virt/kvm/introspection/kvmi_int.h             |  2 +
 virt/kvm/introspection/kvmi_msg.c             | 49 ++++++++++++++-
 6 files changed, 191 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index d848e56f42e9..5db38848c6d4 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -258,3 +258,65 @@ replies. These messages might be extended in futures versions and while
 the kernel will accept shorter messages (older versions) or bigger
 messages (newer versions, ignoring the extra information) it will not
 accept bigger/newer event replies.
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
index b0a5b72d3936..b47de1733e49 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -14,7 +14,9 @@ enum {
 };
 
 enum {
-	KVMI_GET_VERSION = 2,
+	KVMI_GET_VERSION      = 2,
+	KVMI_VM_CHECK_COMMAND = 3,
+	KVMI_VM_CHECK_EVENT   = 4,
 
 	KVMI_NUM_MESSAGES
 };
@@ -50,4 +52,16 @@ struct kvmi_get_version_reply {
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
index 327272e266ff..f434a9611857 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -201,6 +201,59 @@ static void test_cmd_get_version(void)
 	DEBUG("KVMI version: %u\n", rpl.version);
 }
 
+static int cmd_check_command(__u16 id)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vm_check_command cmd;
+	} req = {};
+
+	req.cmd.id = id;
+
+	return do_command(KVMI_VM_CHECK_COMMAND, &req.hdr, sizeof(req), NULL,
+			     0);
+}
+
+static void test_cmd_check_command(void)
+{
+	__u16 valid_id = KVMI_GET_VERSION;
+	__u16 invalid_id = 0xffff;
+	int r;
+
+	r = cmd_check_command(valid_id);
+	TEST_ASSERT(r == 0,
+		"KVMI_VM_CHECK_COMMAND failed, error %d (%s)\n",
+		-r, kvm_strerror(-r));
+
+	r = cmd_check_command(invalid_id);
+	TEST_ASSERT(r == -KVM_ENOENT,
+		"KVMI_VM_CHECK_COMMAND didn't failed with -KVM_ENOENT, error %d (%s)\n",
+		-r, kvm_strerror(-r));
+}
+
+static int cmd_check_event(__u16 id)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vm_check_event cmd;
+	} req = {};
+
+	req.cmd.id = id;
+
+	return do_command(KVMI_VM_CHECK_EVENT, &req.hdr, sizeof(req), NULL, 0);
+}
+
+static void test_cmd_check_event(void)
+{
+	__u16 invalid_id = 0xffff;
+	int r;
+
+	r = cmd_check_event(invalid_id);
+	TEST_ASSERT(r == -KVM_ENOENT,
+		"KVMI_VM_CHECK_EVENT didn't failed with -KVM_ENOENT, error %d (%s)\n",
+		-r, kvm_strerror(-r));
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	setup_socket();
@@ -208,6 +261,8 @@ static void test_introspection(struct kvm_vm *vm)
 
 	test_cmd_invalid();
 	test_cmd_get_version();
+	test_cmd_check_command();
+	test_cmd_check_event();
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 8cd66b1dac02..5c17f548b457 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -11,6 +11,7 @@
 #define KVMI_MSG_SIZE_ALLOC (sizeof(struct kvmi_msg_hdr) + KVMI_MSG_SIZE)
 
 static DECLARE_BITMAP(Kvmi_always_allowed_commands, KVMI_NUM_COMMANDS);
+DECLARE_BITMAP(Kvmi_known_events, KVMI_NUM_EVENTS);
 
 static struct kmem_cache *msg_cache;
 
@@ -49,11 +50,19 @@ static void setup_always_allowed_commands(void)
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
index 36f5e504e791..f755c66ceecc 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -16,6 +16,8 @@
 #define kvmi_err(kvmi, fmt, ...) \
 	kvm_info("%pU ERROR: " fmt, &kvmi->uuid, ## __VA_ARGS__)
 
+extern DECLARE_BITMAP(Kvmi_known_events, KVMI_NUM_EVENTS);
+
 #define KVMI(kvm) ((kvm)->kvmi)
 
 /* kvmi_msg.c */
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 9efcd896f0c6..4fc8b7a0b6d9 100644
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
@@ -114,12 +116,57 @@ static int handle_get_version(struct kvm_introspection *kvmi,
 	return kvmi_msg_vm_reply(kvmi, msg, 0, &rpl, sizeof(rpl));
 }
 
+static int handle_check_command(struct kvm_introspection *kvmi,
+				const struct kvmi_msg_hdr *msg,
+				const void *_req)
+{
+	const struct kvmi_vm_check_command *req = _req;
+	int ec = 0;
+
+	if (req->padding1 || req->padding2)
+		ec = -KVM_EINVAL;
+	else if (!is_vm_command(req->id))
+		ec = -KVM_ENOENT;
+	else if (!is_command_allowed(kvmi, req->id))
+		ec = -KVM_EPERM;
+
+	return kvmi_msg_vm_reply(kvmi, msg, ec, NULL, 0);
+}
+
+static bool is_event_known(u16 id)
+{
+	return id < KVMI_NUM_EVENTS && test_bit(id, Kvmi_known_events);
+}
+
+static bool is_event_allowed(struct kvm_introspection *kvmi, u16 id)
+{
+	return id < KVMI_NUM_EVENTS && test_bit(id, kvmi->event_allow_mask);
+}
+
+static int handle_check_event(struct kvm_introspection *kvmi,
+			      const struct kvmi_msg_hdr *msg, const void *_req)
+{
+	const struct kvmi_vm_check_event *req = _req;
+	int ec = 0;
+
+	if (req->padding1 || req->padding2)
+		ec = -KVM_EINVAL;
+	else if (!is_event_known(req->id))
+		ec = -KVM_ENOENT;
+	else if (!is_event_allowed(kvmi, req->id))
+		ec = -KVM_EPERM;
+
+	return kvmi_msg_vm_reply(kvmi, msg, ec, NULL, 0);
+}
+
 /*
  * These commands are executed by the receiving thread/worker.
  */
 static int(*const msg_vm[])(struct kvm_introspection *,
 			    const struct kvmi_msg_hdr *, const void *) = {
-	[KVMI_GET_VERSION] = handle_get_version,
+	[KVMI_GET_VERSION]      = handle_get_version,
+	[KVMI_VM_CHECK_COMMAND] = handle_check_command,
+	[KVMI_VM_CHECK_EVENT]   = handle_check_event,
 };
 
 static bool is_vm_command(u16 id)
