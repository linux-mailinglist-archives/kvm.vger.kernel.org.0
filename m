Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85399155DBD
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbgBGSSM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:18:12 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40708 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727590AbgBGSQt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:49 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 7F7CF305D348;
        Fri,  7 Feb 2020 20:16:40 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 71E5B3052076;
        Fri,  7 Feb 2020 20:16:40 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v7 42/78] KVM: introspection: add KVMI_VM_GET_INFO
Date:   Fri,  7 Feb 2020 20:16:00 +0200
Message-Id: <20200207181636.1065-43-alazar@bitdefender.com>
In-Reply-To: <20200207181636.1065-1-alazar@bitdefender.com>
References: <20200207181636.1065-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

For now, this command returns only the number of online vCPUs.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst                | 18 ++++++++++++++++++
 include/uapi/linux/kvmi.h                      |  6 ++++++
 tools/testing/selftests/kvm/x86_64/kvmi_test.c | 15 +++++++++++++++
 virt/kvm/introspection/kvmi_int.h              |  1 +
 virt/kvm/introspection/kvmi_msg.c              | 14 ++++++++++++++
 5 files changed, 54 insertions(+)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 9205f51fa5a0..0a7266fed564 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -313,3 +313,21 @@ This command is always allowed.
 * -KVM_EPERM - the event specified by ``id`` is disallowed
 * -KVM_EINVAL - padding is not zero
 * -KVM_EINVAL - the event specified by ``id`` is not known
+
+4. KVMI_VM_GET_INFO
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
+	struct kvmi_vm_get_info_reply {
+		__u32 vcpu_count;
+		__u32 padding[3];
+	};
+
+Returns the number of online vCPUs.
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index ba550e9fae2e..b7e45d4601a5 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -17,6 +17,7 @@ enum {
 	KVMI_GET_VERSION      = 2,
 	KVMI_VM_CHECK_COMMAND = 3,
 	KVMI_VM_CHECK_EVENT   = 4,
+	KVMI_VM_GET_INFO      = 5,
 
 	KVMI_NUM_MESSAGES
 };
@@ -57,4 +58,9 @@ struct kvmi_vm_check_event {
 	__u32 padding2;
 };
 
+struct kvmi_vm_get_info_reply {
+	__u32 vcpu_count;
+	__u32 padding[3];
+};
+
 #endif /* _UAPI__LINUX_KVMI_H */
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index e3e51fe3f85f..7e59ebca1517 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -254,6 +254,20 @@ static void test_cmd_check_event(void)
 		-r, kvm_strerror(-r));
 }
 
+static void test_cmd_get_vm_info(void)
+{
+	struct kvmi_vm_get_info_reply rpl;
+	struct kvmi_msg_hdr req;
+
+	test_vm_command(KVMI_VM_GET_INFO, &req, sizeof(req), &rpl,
+			sizeof(rpl));
+	TEST_ASSERT(rpl.vcpu_count == 1,
+		    "Unexpected number of vCPU count %u\n",
+		    rpl.vcpu_count);
+
+	DEBUG("vcpu count: %u\n", rpl.vcpu_count);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	setup_socket();
@@ -263,6 +277,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_get_version();
 	test_cmd_check_command();
 	test_cmd_check_event();
+	test_cmd_get_vm_info();
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index feb83b8d0f12..3c1a397d07a1 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -24,6 +24,7 @@
 			  BIT(KVMI_GET_VERSION) \
 			| BIT(KVMI_VM_CHECK_COMMAND) \
 			| BIT(KVMI_VM_CHECK_EVENT) \
+			| BIT(KVMI_VM_GET_INFO) \
 		)
 
 #define KVMI(kvm) ((struct kvm_introspection *)((kvm)->kvmi))
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index b7da5cc7286f..a8f524e67f1c 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -12,6 +12,7 @@ static const char *const msg_IDs[] = {
 	[KVMI_GET_VERSION]      = "KVMI_GET_VERSION",
 	[KVMI_VM_CHECK_COMMAND] = "KVMI_VM_CHECK_COMMAND",
 	[KVMI_VM_CHECK_EVENT]   = "KVMI_VM_CHECK_EVENT",
+	[KVMI_VM_GET_INFO]      = "KVMI_VM_GET_INFO",
 };
 
 static bool is_known_message(u16 id)
@@ -168,6 +169,18 @@ static int handle_check_event(struct kvm_introspection *kvmi,
 	return kvmi_msg_vm_reply(kvmi, msg, ec, NULL, 0);
 }
 
+static int handle_get_info(struct kvm_introspection *kvmi,
+			   const struct kvmi_msg_hdr *msg,
+			   const void *req)
+{
+	struct kvmi_vm_get_info_reply rpl;
+
+	memset(&rpl, 0, sizeof(rpl));
+	rpl.vcpu_count = atomic_read(&kvmi->kvm->online_vcpus);
+
+	return kvmi_msg_vm_reply(kvmi, msg, 0, &rpl, sizeof(rpl));
+}
+
 /*
  * These commands are executed by the receiving thread/worker.
  */
@@ -176,6 +189,7 @@ static int(*const msg_vm[])(struct kvm_introspection *,
 	[KVMI_GET_VERSION]      = handle_get_version,
 	[KVMI_VM_CHECK_COMMAND] = handle_check_command,
 	[KVMI_VM_CHECK_EVENT]   = handle_check_event,
+	[KVMI_VM_GET_INFO]      = handle_get_info,
 };
 
 static bool is_vm_message(u16 id)
