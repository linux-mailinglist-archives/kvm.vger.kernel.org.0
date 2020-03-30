Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7EB197930
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729882AbgC3KWF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:22:05 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:43788 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729242AbgC3KTy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 06:19:54 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 5182A30644AC;
        Mon, 30 Mar 2020 13:12:55 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 1E59D305B7A0;
        Mon, 30 Mar 2020 13:12:55 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v8 42/81] KVM: introspection: add KVMI_GET_VERSION
Date:   Mon, 30 Mar 2020 13:12:29 +0300
Message-Id: <20200330101308.21702-43-alazar@bitdefender.com>
In-Reply-To: <20200330101308.21702-1-alazar@bitdefender.com>
References: <20200330101308.21702-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This command is used to identify the commands/events supported
by the introspection subsystem and it is always allowed.
Any attempt from userspace to explicitly disallow this command through
the KVM_INTROSPECTION_COMMAND ioctl will get -EPERM, unless userspace
disables all commands, using id=-1, in which case KVMI_GET_VERSION is
silently allowed, without error.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 35 +++++++++++++++++++
 include/uapi/linux/kvmi.h                     | 10 ++++++
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 25 +++++++++++++
 virt/kvm/introspection/kvmi.c                 | 27 +++++++++++---
 virt/kvm/introspection/kvmi_msg.c             | 12 +++++++
 5 files changed, 105 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index efde4b771586..d848e56f42e9 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -223,3 +223,38 @@ device-specific memory (DMA, emulated MMIO, reserved by a passthrough
 device etc.). It is up to the user to determine, using the guest operating
 system data structures, the areas that are safe to access (code, stack, heap
 etc.).
+
+Commands
+--------
+
+The following C structures are meant to be used directly when communicating
+over the wire. The peer that detects any size mismatch should simply close
+the connection and report the error.
+
+1. KVMI_GET_VERSION
+-------------------
+
+:Architectures: all
+:Versions: >= 1
+:Parameters: none
+:Returns:
+
+::
+
+	struct kvmi_error_code;
+	struct kvmi_get_version_reply {
+		__u32 version;
+		__u32 padding;
+	};
+
+Returns the introspection API version.
+
+This command is always allowed and successful (if the introspection is
+built in kernel).
+
+The userspace should use this command to identify the commands/events
+supported by the kernel side and what messages must be used for event
+replies. These messages might be extended in futures versions and while
+the kernel will accept shorter messages (older versions) or bigger
+messages (newer versions, ignoring the extra information) it will not
+accept bigger/newer event replies.
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 6fdaa92393a4..b0a5b72d3936 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -6,11 +6,16 @@
  * KVMI structures and definitions
  */
 
+#include <linux/kernel.h>
+#include <linux/types.h>
+
 enum {
 	KVMI_VERSION = 0x00000001
 };
 
 enum {
+	KVMI_GET_VERSION = 2,
+
 	KVMI_NUM_MESSAGES
 };
 
@@ -40,4 +45,9 @@ struct kvmi_error_code {
 	__u32 padding;
 };
 
+struct kvmi_get_version_reply {
+	__u32 version;
+	__u32 padding;
+};
+
 #endif /* _UAPI__LINUX_KVMI_H */
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 4c1fe67c8e35..327272e266ff 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -177,12 +177,37 @@ static void test_cmd_invalid(void)
 		-r, kvm_strerror(-r));
 }
 
+static void test_vm_command(int cmd_id, struct kvmi_msg_hdr *req,
+			    size_t req_size, void *rpl, size_t rpl_size)
+{
+	int r;
+
+	r = do_command(cmd_id, req, req_size, rpl, rpl_size);
+	TEST_ASSERT(r == 0,
+		    "Command %d failed, error %d (%s)\n",
+		    cmd_id, -r, kvm_strerror(-r));
+}
+
+static void test_cmd_get_version(void)
+{
+	struct kvmi_get_version_reply rpl;
+	struct kvmi_msg_hdr req;
+
+	test_vm_command(KVMI_GET_VERSION, &req, sizeof(req), &rpl, sizeof(rpl));
+	TEST_ASSERT(rpl.version == KVMI_VERSION,
+		    "Unexpected KVMI version %d, expecting %d\n",
+		    rpl.version, KVMI_VERSION);
+
+	DEBUG("KVMI version: %u\n", rpl.version);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	setup_socket();
 	hook_introspection(vm);
 
 	test_cmd_invalid();
+	test_cmd_get_version();
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 88d29408fbf1..8cd66b1dac02 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -10,6 +10,8 @@
 
 #define KVMI_MSG_SIZE_ALLOC (sizeof(struct kvmi_msg_hdr) + KVMI_MSG_SIZE)
 
+static DECLARE_BITMAP(Kvmi_always_allowed_commands, KVMI_NUM_COMMANDS);
+
 static struct kmem_cache *msg_cache;
 
 void *kvmi_msg_alloc(void)
@@ -43,8 +45,16 @@ static int kvmi_cache_create(void)
 	return 0;
 }
 
+static void setup_always_allowed_commands(void)
+{
+	bitmap_zero(Kvmi_always_allowed_commands, KVMI_NUM_COMMANDS);
+	set_bit(KVMI_GET_VERSION, Kvmi_always_allowed_commands);
+}
+
 int kvmi_init(void)
 {
+	setup_always_allowed_commands();
+
 	return kvmi_cache_create();
 }
 
@@ -71,6 +81,9 @@ alloc_kvmi(struct kvm *kvm, const struct kvm_introspection_hook *hook)
 	BUILD_BUG_ON(sizeof(hook->uuid) != sizeof(kvmi->uuid));
 	memcpy(&kvmi->uuid, &hook->uuid, sizeof(kvmi->uuid));
 
+	bitmap_copy(kvmi->cmd_allow_mask, Kvmi_always_allowed_commands,
+		    KVMI_NUM_COMMANDS);
+
 	kvmi->kvm = kvm;
 
 	return kvmi;
@@ -282,8 +295,8 @@ int kvmi_ioctl_event(struct kvm *kvm, void __user *argp)
 	return err;
 }
 
-static void kvmi_control_allowed_commands(struct kvm_introspection *kvmi,
-					  int id, bool allow)
+static int kvmi_control_allowed_commands(struct kvm_introspection *kvmi,
+					 int id, bool allow)
 {
 	int all_commands = -1;
 
@@ -294,10 +307,16 @@ static void kvmi_control_allowed_commands(struct kvm_introspection *kvmi,
 			set_bit(id, kvmi->cmd_allow_mask);
 	} else {
 		if (id == all_commands)
-			bitmap_zero(kvmi->cmd_allow_mask, KVMI_NUM_COMMANDS);
+			bitmap_copy(kvmi->cmd_allow_mask,
+				    Kvmi_always_allowed_commands,
+				    KVMI_NUM_COMMANDS);
+		else if (test_bit(id, Kvmi_always_allowed_commands))
+			return -EPERM;
 		else
 			clear_bit(id, kvmi->cmd_allow_mask);
 	}
+
+	return 0;
 }
 
 int kvmi_ioctl_command(struct kvm *kvm, void __user *argp)
@@ -314,7 +333,7 @@ int kvmi_ioctl_command(struct kvm *kvm, void __user *argp)
 
 	kvmi = KVMI(kvm);
 	if (kvmi)
-		kvmi_control_allowed_commands(kvmi, id, allow);
+		err = kvmi_control_allowed_commands(kvmi, id, allow);
 	else
 		err = -EFAULT;
 
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 02fc5d95fef6..9efcd896f0c6 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -103,11 +103,23 @@ static bool is_command_allowed(struct kvm_introspection *kvmi, u16 id)
 	return id < KVMI_NUM_COMMANDS && test_bit(id, kvmi->cmd_allow_mask);
 }
 
+static int handle_get_version(struct kvm_introspection *kvmi,
+			      const struct kvmi_msg_hdr *msg, const void *req)
+{
+	struct kvmi_get_version_reply rpl;
+
+	memset(&rpl, 0, sizeof(rpl));
+	rpl.version = KVMI_VERSION;
+
+	return kvmi_msg_vm_reply(kvmi, msg, 0, &rpl, sizeof(rpl));
+}
+
 /*
  * These commands are executed by the receiving thread/worker.
  */
 static int(*const msg_vm[])(struct kvm_introspection *,
 			    const struct kvmi_msg_hdr *, const void *) = {
+	[KVMI_GET_VERSION] = handle_get_version,
 };
 
 static bool is_vm_command(u16 id)
