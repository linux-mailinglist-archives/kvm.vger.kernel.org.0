Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBAD1978F8
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729843AbgC3KUj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:20:39 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:43882 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729455AbgC3KUG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 06:20:06 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id D9A5430644BA;
        Mon, 30 Mar 2020 13:12:55 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 8905E305B7A0;
        Mon, 30 Mar 2020 13:12:55 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v8 44/81] KVM: introspection: add KVMI_VM_GET_INFO
Date:   Mon, 30 Mar 2020 13:12:31 +0300
Message-Id: <20200330101308.21702-45-alazar@bitdefender.com>
In-Reply-To: <20200330101308.21702-1-alazar@bitdefender.com>
References: <20200330101308.21702-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

For now, this command returns only the number of online vCPUs.

The introspection tool uses the vCPU index on commands related to
vCPUs.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst                | 18 ++++++++++++++++++
 include/uapi/linux/kvmi.h                      |  6 ++++++
 tools/testing/selftests/kvm/x86_64/kvmi_test.c | 15 +++++++++++++++
 virt/kvm/introspection/kvmi_msg.c              | 13 +++++++++++++
 4 files changed, 52 insertions(+)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 5db38848c6d4..36b34e09d2c2 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -320,3 +320,21 @@ This command is always allowed.
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
index b47de1733e49..bfa1526798e6 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -17,6 +17,7 @@ enum {
 	KVMI_GET_VERSION      = 2,
 	KVMI_VM_CHECK_COMMAND = 3,
 	KVMI_VM_CHECK_EVENT   = 4,
+	KVMI_VM_GET_INFO      = 5,
 
 	KVMI_NUM_MESSAGES
 };
@@ -64,4 +65,9 @@ struct kvmi_vm_check_event {
 	__u32 padding2;
 };
 
+struct kvmi_vm_get_info_reply {
+	__u32 vcpu_count;
+	__u32 padding[3];
+};
+
 #endif /* _UAPI__LINUX_KVMI_H */
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index f434a9611857..ba58081bfec4 100644
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
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 4fc8b7a0b6d9..ceec31ae4581 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -159,6 +159,18 @@ static int handle_check_event(struct kvm_introspection *kvmi,
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
@@ -167,6 +179,7 @@ static int(*const msg_vm[])(struct kvm_introspection *,
 	[KVMI_GET_VERSION]      = handle_get_version,
 	[KVMI_VM_CHECK_COMMAND] = handle_check_command,
 	[KVMI_VM_CHECK_EVENT]   = handle_check_event,
+	[KVMI_VM_GET_INFO]      = handle_get_info,
 };
 
 static bool is_vm_command(u16 id)
