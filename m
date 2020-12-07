Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A637A2D1B09
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 21:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbgLGUsK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 15:48:10 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:42570 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727154AbgLGUsK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 15:48:10 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 6462F305D465;
        Mon,  7 Dec 2020 22:46:18 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 3D47C3072784;
        Mon,  7 Dec 2020 22:46:18 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v11 38/81] KVM: introspection: add KVMI_VM_GET_INFO
Date:   Mon,  7 Dec 2020 22:45:39 +0200
Message-Id: <20201207204622.15258-39-alazar@bitdefender.com>
In-Reply-To: <20201207204622.15258-1-alazar@bitdefender.com>
References: <20201207204622.15258-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

This command returns the number of online vCPUs.

The introspection tool uses the vCPU index to specify to which vCPU
the introspection command applies to.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 18 ++++++++++
 include/uapi/linux/kvmi.h                     |  6 ++++
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 35 +++++++++++++++++--
 virt/kvm/introspection/kvmi_msg.c             | 13 +++++++
 4 files changed, 69 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 13169575f75f..6f8583d4aeb2 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -312,3 +312,21 @@ This command is always allowed.
 * -KVM_ENOENT - the event specified by ``id`` is unsupported
 * -KVM_EPERM - the event specified by ``id`` is disallowed
 * -KVM_EINVAL - the padding is not zero
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
index 0c2d0cedde6f..e06a7b80d4d9 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -20,6 +20,7 @@ enum {
 	KVMI_GET_VERSION      = KVMI_VM_MESSAGE_ID(1),
 	KVMI_VM_CHECK_COMMAND = KVMI_VM_MESSAGE_ID(2),
 	KVMI_VM_CHECK_EVENT   = KVMI_VM_MESSAGE_ID(3),
+	KVMI_VM_GET_INFO      = KVMI_VM_MESSAGE_ID(4),
 
 	KVMI_NEXT_VM_MESSAGE
 };
@@ -67,4 +68,9 @@ struct kvmi_vm_check_event {
 	__u32 padding2;
 };
 
+struct kvmi_vm_get_info_reply {
+	__u32 vcpu_count;
+	__u32 padding[3];
+};
+
 #endif /* _UAPI__LINUX_KVMI_H */
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index cd8f16a3ce3a..d60ee23fa833 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -80,6 +80,16 @@ static void set_command_perm(struct kvm_vm *vm, __s32 id, __u32 allow,
 		 "KVM_INTROSPECTION_COMMAND");
 }
 
+static void disallow_command(struct kvm_vm *vm, __s32 id)
+{
+	set_command_perm(vm, id, 0, 0);
+}
+
+static void allow_command(struct kvm_vm *vm, __s32 id)
+{
+	set_command_perm(vm, id, 1, 0);
+}
+
 static void hook_introspection(struct kvm_vm *vm)
 {
 	__u32 allow = 1, disallow = 0, allow_inval = 2;
@@ -256,12 +266,16 @@ static void cmd_vm_check_command(__u16 id, int expected_err)
 			expected_err);
 }
 
-static void test_cmd_vm_check_command(void)
+static void test_cmd_vm_check_command(struct kvm_vm *vm)
 {
-	__u16 valid_id = KVMI_GET_VERSION, invalid_id = 0xffff;
+	__u16 valid_id = KVMI_VM_GET_INFO, invalid_id = 0xffff;
 
 	cmd_vm_check_command(valid_id, 0);
 	cmd_vm_check_command(invalid_id, -KVM_ENOENT);
+
+	disallow_command(vm, valid_id);
+	cmd_vm_check_command(valid_id, -KVM_EPERM);
+	allow_command(vm, valid_id);
 }
 
 static void cmd_vm_check_event(__u16 id, int expected_err)
@@ -284,6 +298,20 @@ static void test_cmd_vm_check_event(void)
 	cmd_vm_check_event(invalid_id, -KVM_ENOENT);
 }
 
+static void test_cmd_vm_get_info(void)
+{
+	struct kvmi_vm_get_info_reply rpl;
+	struct kvmi_msg_hdr req;
+
+	test_vm_command(KVMI_VM_GET_INFO, &req, sizeof(req), &rpl,
+			sizeof(rpl), 0);
+	TEST_ASSERT(rpl.vcpu_count == 1,
+		    "Unexpected number of vCPU count %u\n",
+		    rpl.vcpu_count);
+
+	pr_debug("vcpu count: %u\n", rpl.vcpu_count);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	setup_socket();
@@ -291,8 +319,9 @@ static void test_introspection(struct kvm_vm *vm)
 
 	test_cmd_invalid();
 	test_cmd_get_version();
-	test_cmd_vm_check_command();
+	test_cmd_vm_check_command(vm);
 	test_cmd_vm_check_event();
+	test_cmd_vm_get_info();
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 6538c7af710a..f0f5058403dd 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -150,6 +150,18 @@ static int handle_vm_check_event(struct kvm_introspection *kvmi,
 	return kvmi_msg_vm_reply(kvmi, msg, ec, NULL, 0);
 }
 
+static int handle_vm_get_info(struct kvm_introspection *kvmi,
+			      const struct kvmi_msg_hdr *msg,
+			      const void *req)
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
  * These commands are executed by the receiving thread.
  */
@@ -157,6 +169,7 @@ static kvmi_vm_msg_fct const msg_vm[] = {
 	[KVMI_GET_VERSION]      = handle_get_version,
 	[KVMI_VM_CHECK_COMMAND] = handle_vm_check_command,
 	[KVMI_VM_CHECK_EVENT]   = handle_vm_check_event,
+	[KVMI_VM_GET_INFO]      = handle_vm_get_info,
 };
 
 static kvmi_vm_msg_fct get_vm_msg_handler(u16 id)
