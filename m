Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58D44228AD6
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731492AbgGUVR2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:17:28 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37790 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731294AbgGUVQI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:16:08 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 2EE8A305D679;
        Wed, 22 Jul 2020 00:09:25 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 0908E304FA15;
        Wed, 22 Jul 2020 00:09:25 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 41/84] KVM: introspection: add KVMI_GET_VERSION
Date:   Wed, 22 Jul 2020 00:08:39 +0300
Message-Id: <20200721210922.7646-42-alazar@bitdefender.com>
In-Reply-To: <20200721210922.7646-1-alazar@bitdefender.com>
References: <20200721210922.7646-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The kernel side will accept older and newer versions of an introspection
command (having a smaller/larger message size), but it will not
accept newer versions for event replies (larger messages). Even if the
introspection tool can use the KVMI_GET_VERSION command to check the
supported features of the introspection API, the most important usage
of this command is to avoid sending newer versions of event replies that
the kernel side doesn't know.

Any attempt from the device manager to explicitly disallow this command
through the KVM_INTROSPECTION_COMMAND ioctl will get -EPERM, unless all
commands are disallowed (using id=-1) in which case KVMI_GET_VERSION is
silently allowed, without error.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 37 +++++++++++++++++++
 include/uapi/linux/kvmi.h                     | 10 +++++
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 26 +++++++++++++
 virt/kvm/introspection/kvmi.c                 | 27 ++++++++++++--
 virt/kvm/introspection/kvmi_msg.c             | 12 ++++++
 5 files changed, 108 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index f3d16971ba2b..41fd48222bcb 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -224,3 +224,40 @@ device-specific memory (DMA, emulated MMIO, reserved by a passthrough
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
+This command is always allowed and successful.
+
+The messages used for introspection commands/events might be extended
+in future versions and while the kernel will accept commands with
+shorter messages (older versions) or larger messages (newer versions,
+ignoring the extra information), it will not accept event replies with
+larger/newer messages.
+
+The introspection tool should use this command to identify the features
+supported by the kernel side and what messages must be used for event
+replies.
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 9bfff484fd6f..896fcb6abf2c 100644
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
+	KVMI_GET_VERSION = 1,
+
 	KVMI_NUM_MESSAGES
 };
 
@@ -39,4 +44,9 @@ struct kvmi_error_code {
 	__u32 padding;
 };
 
+struct kvmi_get_version_reply {
+	__u32 version;
+	__u32 padding;
+};
+
 #endif /* _UAPI__LINUX_KVMI_H */
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 9c591e0d9c8a..d15eccc330e5 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -98,6 +98,7 @@ static void hook_introspection(struct kvm_vm *vm)
 	do_hook_ioctl(vm, Kvm_socket, no_padding, 0);
 	do_hook_ioctl(vm, Kvm_socket, no_padding, EEXIST);
 
+	set_command_perm(vm, KVMI_GET_VERSION, disallow, EPERM);
 	set_command_perm(vm, all_IDs, allow_inval, EINVAL);
 	set_command_perm(vm, all_IDs, disallow, 0);
 	set_command_perm(vm, all_IDs, allow, 0);
@@ -213,12 +214,37 @@ static void test_cmd_invalid(void)
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
+	pr_info("KVMI version: %u\n", rpl.version);
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
index 547d3388ff8a..c44aa49dc6b5 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -11,6 +11,8 @@
 #define KVMI_NUM_COMMANDS KVMI_NUM_MESSAGES
 #define KVMI_MSG_SIZE_ALLOC (sizeof(struct kvmi_msg_hdr) + KVMI_MSG_SIZE)
 
+static DECLARE_BITMAP(Kvmi_always_allowed_commands, KVMI_NUM_COMMANDS);
+
 static struct kmem_cache *msg_cache;
 
 void *kvmi_msg_alloc(void)
@@ -49,8 +51,16 @@ bool kvmi_is_command_allowed(struct kvm_introspection *kvmi, u16 id)
 	return id < KVMI_NUM_COMMANDS && test_bit(id, kvmi->cmd_allow_mask);
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
 
@@ -94,6 +104,9 @@ alloc_kvmi(struct kvm *kvm, const struct kvm_introspection_hook *hook)
 	BUILD_BUG_ON(sizeof(hook->uuid) != sizeof(kvmi->uuid));
 	memcpy(&kvmi->uuid, &hook->uuid, sizeof(kvmi->uuid));
 
+	bitmap_copy(kvmi->cmd_allow_mask, Kvmi_always_allowed_commands,
+		    KVMI_NUM_COMMANDS);
+
 	kvmi->kvm = kvm;
 
 	return kvmi;
@@ -303,8 +316,8 @@ int kvmi_ioctl_event(struct kvm *kvm,
 	return err;
 }
 
-static void kvmi_control_allowed_commands(struct kvm_introspection *kvmi,
-					  s32 id, bool allow)
+static int kvmi_control_allowed_commands(struct kvm_introspection *kvmi,
+					 s32 id, bool allow)
 {
 	s32 all_commands = -1;
 
@@ -315,10 +328,16 @@ static void kvmi_control_allowed_commands(struct kvm_introspection *kvmi,
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
@@ -337,7 +356,7 @@ int kvmi_ioctl_command(struct kvm *kvm,
 
 	kvmi = KVMI(kvm);
 	if (kvmi)
-		kvmi_control_allowed_commands(kvmi, id, allow);
+		err = kvmi_control_allowed_commands(kvmi, id, allow);
 	else
 		err = -EFAULT;
 
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 4e7b55ec7071..386636aa9832 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -98,11 +98,23 @@ static int kvmi_msg_vm_reply(struct kvm_introspection *kvmi,
 	return kvmi_msg_reply(kvmi, msg, err, rpl, rpl_size);
 }
 
+static int handle_get_version(struct kvm_introspection *kvmi,
+			      const struct kvmi_msg_hdr *msg, const void *req)
+{
+	struct kvmi_get_version_reply rpl;
+
+	memset(&rpl, 0, sizeof(rpl));
+	rpl.version = kvmi_version();
+
+	return kvmi_msg_vm_reply(kvmi, msg, 0, &rpl, sizeof(rpl));
+}
+
 /*
  * These commands are executed by the receiving thread.
  */
 static int(*const msg_vm[])(struct kvm_introspection *,
 			    const struct kvmi_msg_hdr *, const void *) = {
+	[KVMI_GET_VERSION] = handle_get_version,
 };
 
 static bool is_vm_command(u16 id)
