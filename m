Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 367BF2C3C8C
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 10:43:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728550AbgKYJmF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 04:42:05 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:57196 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728235AbgKYJmC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Nov 2020 04:42:02 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 9BB64305D516;
        Wed, 25 Nov 2020 11:35:48 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 79AB93072784;
        Wed, 25 Nov 2020 11:35:48 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v10 36/81] KVM: introspection: add KVMI_GET_VERSION
Date:   Wed, 25 Nov 2020 11:35:15 +0200
Message-Id: <20201125093600.2766-37-alazar@bitdefender.com>
In-Reply-To: <20201125093600.2766-1-alazar@bitdefender.com>
References: <20201125093600.2766-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When handling introspection commands from tools built with older or
newer versions of the introspection API, the receiving thread silently
accepts smaller/larger messages, but it replies with messages related to
current/kernel version. Smaller introspection event replies are accepted
too. However, larger messages for event replies are not allowed.

Even if an introspection tool can use the API version returned by the
KVMI_GET_VERSION command to check the supported features, the most
important usage of this command is to avoid sending newer versions of
event replies that the kernel side doesn't know. On larger messages,
the introspection socket will be closed.

Any attempt from the device manager to explicitly disallow this command
through the KVM_INTROSPECTION_COMMAND ioctl will get -EPERM, unless all
commands are disallowed (using id=-1), in which case KVMI_GET_VERSION
is silently allowed, without error.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 38 +++++++++++++++++++
 include/uapi/linux/kvmi.h                     | 10 +++++
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 35 +++++++++++++++++
 virt/kvm/introspection/kvmi.c                 | 27 +++++++++++--
 virt/kvm/introspection/kvmi_msg.c             | 13 +++++++
 5 files changed, 119 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index ae6bbf37aef3..d3d672a07872 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -212,3 +212,41 @@ device-specific memory (DMA, emulated MMIO, reserved by a passthrough
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
+		__u32 max_msg_size;
+	};
+
+Returns the introspection API version and the largest accepted message
+size (useful for variable length messages).
+
+This command is always allowed and successful.
+
+The messages used for introspection commands/events might be extended
+in future versions and while the kernel will accept commands with
+shorter messages (older versions) or larger messages (newer versions,
+ignoring the extra information), it will not accept event replies with
+larger messages.
+
+The introspection tool should use this command to identify the features
+supported by the kernel side and what messages must be used for event
+replies.
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 2b37eee82c52..77dd727dfe18 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -6,6 +6,9 @@
  * KVMI structures and definitions
  */
 
+#include <linux/kernel.h>
+#include <linux/types.h>
+
 enum {
 	KVMI_VERSION = 0x00000001
 };
@@ -14,6 +17,8 @@ enum {
 #define KVMI_VCPU_MESSAGE_ID(id) (((id) << 1) | 1)
 
 enum {
+	KVMI_GET_VERSION = KVMI_VM_MESSAGE_ID(1),
+
 	KVMI_NEXT_VM_MESSAGE
 };
 
@@ -43,4 +48,9 @@ struct kvmi_error_code {
 	__u32 padding;
 };
 
+struct kvmi_get_version_reply {
+	__u32 version;
+	__u32 max_msg_size;
+};
+
 #endif /* _UAPI__LINUX_KVMI_H */
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 95bd0a60eb47..30acd3a2d030 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -92,6 +92,7 @@ static void hook_introspection(struct kvm_vm *vm)
 	do_hook_ioctl(vm, Kvm_socket, 0);
 	do_hook_ioctl(vm, Kvm_socket, EEXIST);
 
+	set_command_perm(vm, KVMI_GET_VERSION, disallow, EPERM);
 	set_command_perm(vm, all_IDs, allow_inval, EINVAL);
 	set_command_perm(vm, all_IDs, disallow, 0);
 	set_command_perm(vm, all_IDs, allow, 0);
@@ -207,12 +208,46 @@ static void test_cmd_invalid(void)
 		-r, kvm_strerror(-r));
 }
 
+static void test_vm_command(int cmd_id, struct kvmi_msg_hdr *req,
+			    size_t req_size, void *rpl, size_t rpl_size,
+			    int expected_err)
+{
+	int r;
+
+	r = do_command(cmd_id, req, req_size, rpl, rpl_size);
+	TEST_ASSERT(r == expected_err,
+		    "Command %d failed, error %d (%s) instead of %d (%s)\n",
+		    cmd_id, -r, kvm_strerror(-r),
+		    expected_err, kvm_strerror(expected_err));
+}
+
+static void cmd_vm_get_version(struct kvmi_get_version_reply *ver)
+{
+	struct kvmi_msg_hdr req;
+
+	test_vm_command(KVMI_GET_VERSION, &req, sizeof(req), ver, sizeof(*ver), 0);
+}
+
+static void test_cmd_get_version(void)
+{
+	struct kvmi_get_version_reply rpl;
+
+	cmd_vm_get_version(&rpl);
+	TEST_ASSERT(rpl.version == KVMI_VERSION,
+		    "Unexpected KVMI version %d, expecting %d\n",
+		    rpl.version, KVMI_VERSION);
+
+	pr_debug("KVMI version: %u\n", rpl.version);
+	pr_debug("Max message size: %u\n", rpl.max_msg_size);
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
index 8b3ba3a236af..520be9478697 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -15,6 +15,8 @@
 
 #define KVMI_MSG_SIZE_ALLOC (sizeof(struct kvmi_msg_hdr) + KVMI_MAX_MSG_SIZE)
 
+static DECLARE_BITMAP(Kvmi_always_allowed_commands, KVMI_NUM_COMMANDS);
+
 static struct kmem_cache *msg_cache;
 
 void *kvmi_msg_alloc(void)
@@ -53,8 +55,16 @@ bool kvmi_is_command_allowed(struct kvm_introspection *kvmi, u16 id)
 	return id < KVMI_NUM_COMMANDS && test_bit(id, kvmi->cmd_allow_mask);
 }
 
+static void kvmi_init_always_allowed_commands(void)
+{
+	bitmap_zero(Kvmi_always_allowed_commands, KVMI_NUM_COMMANDS);
+	set_bit(KVMI_GET_VERSION, Kvmi_always_allowed_commands);
+}
+
 int kvmi_init(void)
 {
+	kvmi_init_always_allowed_commands();
+
 	return kvmi_cache_create();
 }
 
@@ -98,6 +108,9 @@ kvmi_alloc(struct kvm *kvm, const struct kvm_introspection_hook *hook)
 	BUILD_BUG_ON(sizeof(hook->uuid) != sizeof(kvmi->uuid));
 	memcpy(&kvmi->uuid, &hook->uuid, sizeof(kvmi->uuid));
 
+	bitmap_copy(kvmi->cmd_allow_mask, Kvmi_always_allowed_commands,
+		    KVMI_NUM_COMMANDS);
+
 	kvmi->kvm = kvm;
 
 	return kvmi;
@@ -304,8 +317,8 @@ int kvmi_ioctl_event(struct kvm *kvm,
 	return err;
 }
 
-static void kvmi_control_allowed_commands(struct kvm_introspection *kvmi,
-					  s32 id, bool allow)
+static int kvmi_control_allowed_commands(struct kvm_introspection *kvmi,
+					 s32 id, bool allow)
 {
 	s32 all_commands = -1;
 
@@ -316,10 +329,16 @@ static void kvmi_control_allowed_commands(struct kvm_introspection *kvmi,
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
 
 int kvmi_ioctl_command(struct kvm *kvm,
@@ -338,7 +357,7 @@ int kvmi_ioctl_command(struct kvm *kvm,
 
 	kvmi = KVMI(kvm);
 	if (kvmi)
-		kvmi_control_allowed_commands(kvmi, id, allow);
+		err = kvmi_control_allowed_commands(kvmi, id, allow);
 	else
 		err = -EFAULT;
 
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 38a5a4a84d5d..57708da2af20 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -102,10 +102,23 @@ static int kvmi_msg_vm_reply(struct kvm_introspection *kvmi,
 	return kvmi_msg_reply(kvmi, msg, err, rpl, rpl_size);
 }
 
+static int handle_get_version(struct kvm_introspection *kvmi,
+			      const struct kvmi_msg_hdr *msg, const void *req)
+{
+	struct kvmi_get_version_reply rpl;
+
+	memset(&rpl, 0, sizeof(rpl));
+	rpl.version = kvmi_version();
+	rpl.max_msg_size = KVMI_MAX_MSG_SIZE;
+
+	return kvmi_msg_vm_reply(kvmi, msg, 0, &rpl, sizeof(rpl));
+}
+
 /*
  * These commands are executed by the receiving thread.
  */
 static kvmi_vm_msg_fct const msg_vm[] = {
+	[KVMI_GET_VERSION] = handle_get_version,
 };
 
 static kvmi_vm_msg_fct get_vm_msg_handler(u16 id)
