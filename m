Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8B71155D83
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727690AbgBGSQu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:16:50 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40634 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727582AbgBGSQu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:50 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 6D030305D346;
        Fri,  7 Feb 2020 20:16:40 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 619E23052074;
        Fri,  7 Feb 2020 20:16:40 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v7 40/78] KVM: introspection: add KVMI_GET_VERSION
Date:   Fri,  7 Feb 2020 20:15:58 +0200
Message-Id: <20200207181636.1065-41-alazar@bitdefender.com>
In-Reply-To: <20200207181636.1065-1-alazar@bitdefender.com>
References: <20200207181636.1065-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This command should be used by the introspection tool to identify the
commands/events supported by the KVMi subsystem and, most important,
what messages must be used for event replies. These messages might be
extended in future versions. The kernel side will accept smaller/older
or bigger/newer command messages, but not bigger/newer event replies.

The KVMI_GET_VERSION command is always allowed and any attempt
from userspace to explicitly disallow this command through
KVM_INTROSPECTION_COMMAND will get -EPERM (unless userspace chooses to
disable all commands, using id=-1, in which case KVMI_GET_VERSION is
silently allowed, without an error).

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 27 +++++++++++++++++++
 include/uapi/linux/kvmi.h                     | 10 +++++++
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 25 +++++++++++++++++
 virt/kvm/introspection/kvmi.c                 | 14 ++++++++++
 virt/kvm/introspection/kvmi_int.h             |  4 ++-
 virt/kvm/introspection/kvmi_msg.c             | 13 +++++++++
 6 files changed, 92 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 4aa77ae0c3c5..36f8cd4a836d 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -224,3 +224,30 @@ device etc.). It is up to the user to determine, using the guest operating
 system data structures, the areas that are safe to access (code, stack, heap
 etc.).
 
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
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 7620fdbf4749..ee817cb05cc6 100644
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
 
@@ -33,4 +38,9 @@ struct kvmi_error_code {
 	__u32 padding;
 };
 
+struct kvmi_get_version_reply {
+	__u32 version;
+	__u32 padding;
+};
+
 #endif /* _UAPI__LINUX_KVMI_H */
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 1793582b7e10..733e82478f6e 100644
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
index 706372e9e56a..8597b6ef0cfb 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -76,6 +76,8 @@ alloc_kvmi(struct kvm *kvm, const struct kvm_introspection_hook *hook)
 	BUILD_BUG_ON(sizeof(hook->uuid) != sizeof(kvmi->uuid));
 	memcpy(&kvmi->uuid, &hook->uuid, sizeof(kvmi->uuid));
 
+	set_bit(KVMI_GET_VERSION, kvmi->cmd_allow_mask);
+
 	kvmi->kvm = kvm;
 
 	return kvmi;
@@ -299,6 +301,18 @@ int kvmi_ioctl_command(struct kvm *kvm, void __user *argp)
 	bitmap_from_u64(known, KVMI_KNOWN_COMMANDS);
 	bitmap_and(requested, requested, known, KVMI_NUM_COMMANDS);
 
+	if (!allow) {
+		DECLARE_BITMAP(always_allowed, KVMI_NUM_COMMANDS);
+
+		if (id == KVMI_GET_VERSION)
+			return -EPERM;
+
+		set_bit(KVMI_GET_VERSION, always_allowed);
+
+		bitmap_andnot(requested, requested, always_allowed,
+			      KVMI_NUM_COMMANDS);
+	}
+
 	off_bitmap = offsetof(struct kvm_introspection, cmd_allow_mask);
 
 	return kvmi_ioctl_feature(kvm, allow, requested, off_bitmap,
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 46ba90cb5e66..947af4615fa5 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -20,7 +20,9 @@
 
 #define KVMI_KNOWN_EVENTS 0
 
-#define KVMI_KNOWN_COMMANDS 0
+#define KVMI_KNOWN_COMMANDS ( \
+			  BIT(KVMI_GET_VERSION) \
+		)
 
 #define KVMI(kvm) ((struct kvm_introspection *)((kvm)->kvmi))
 
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index ed095fcf50bc..81e42c65da16 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -9,6 +9,7 @@
 #include "kvmi_int.h"
 
 static const char *const msg_IDs[] = {
+	[KVMI_GET_VERSION] = "KVMI_GET_VERSION",
 };
 
 static bool is_known_message(u16 id)
@@ -116,11 +117,23 @@ static bool is_command_allowed(struct kvm_introspection *kvmi, int id)
 	return test_bit(id, kvmi->cmd_allow_mask);
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
 
 static bool is_vm_message(u16 id)
