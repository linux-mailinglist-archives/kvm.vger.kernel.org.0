Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4BC4244D8
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 19:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239125AbhJFRnM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 13:43:12 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53558 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239228AbhJFRmj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 13:42:39 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 222AD307CAF7;
        Wed,  6 Oct 2021 20:31:08 +0300 (EEST)
Received: from localhost (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 09454305FFA0;
        Wed,  6 Oct 2021 20:31:08 +0300 (EEST)
X-Is-Junk-Enabled: fGZTSsP0qEJE2AIKtlSuFiRRwg9xyHmJ
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v12 35/77] KVM: introspection: add KVMI_VM_GET_INFO
Date:   Wed,  6 Oct 2021 20:30:31 +0300
Message-Id: <20211006173113.26445-36-alazar@bitdefender.com>
In-Reply-To: <20211006173113.26445-1-alazar@bitdefender.com>
References: <20211006173113.26445-1-alazar@bitdefender.com>
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
index 57f68ff60eb9..2ada3d9bc230 100644
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
@@ -263,12 +273,16 @@ static void cmd_vm_check_command(__u16 id, int expected_err)
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
@@ -291,6 +305,20 @@ static void test_cmd_vm_check_event(void)
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
@@ -298,8 +326,9 @@ static void test_introspection(struct kvm_vm *vm)
 
 	test_cmd_invalid();
 	test_cmd_get_version();
-	test_cmd_vm_check_command();
+	test_cmd_vm_check_command(vm);
 	test_cmd_vm_check_event();
+	test_cmd_vm_get_info();
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 16dda34d1acd..795495340dc0 100644
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
@@ -157,6 +169,7 @@ static const kvmi_vm_msg_fct msg_vm[] = {
 	[KVMI_GET_VERSION]      = handle_get_version,
 	[KVMI_VM_CHECK_COMMAND] = handle_vm_check_command,
 	[KVMI_VM_CHECK_EVENT]   = handle_vm_check_event,
+	[KVMI_VM_GET_INFO]      = handle_vm_get_info,
 };
 
 static kvmi_vm_msg_fct get_vm_msg_handler(u16 id)
