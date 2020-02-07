Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56A28155D9F
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbgBGSR0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:17:26 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40738 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727704AbgBGSQy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:54 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 80651305D35D;
        Fri,  7 Feb 2020 20:16:41 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 7363C3052073;
        Fri,  7 Feb 2020 20:16:41 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v7 63/78] KVM: introspection: add KVMI_VM_GET_MAX_GFN
Date:   Fri,  7 Feb 2020 20:16:21 +0200
Message-Id: <20200207181636.1065-64-alazar@bitdefender.com>
In-Reply-To: <20200207181636.1065-1-alazar@bitdefender.com>
References: <20200207181636.1065-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ștefan Șicleru <ssicleru@bitdefender.com>

The introspection tool can use this to set access restrictions for a
wide range of guest addresses.

Signed-off-by: Ștefan Șicleru <ssicleru@bitdefender.com>
Co-developed-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 20 +++++++++++++++++++
 include/uapi/linux/kvmi.h                     |  6 ++++++
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 12 +++++++++++
 virt/kvm/introspection/kvmi_int.h             |  1 +
 virt/kvm/introspection/kvmi_msg.c             | 14 +++++++++++++
 5 files changed, 53 insertions(+)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 9a902a94ed28..c1badcde1662 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -735,6 +735,26 @@ order to be notified about the effective injected expection.
 * -KVM_EBUSY - another *KVMI_VCPU_INJECT_EXCEPTION* command was issued and no
   corresponding *KVMI_EVENT_TRAP* (if enabled) has been provided yet.
 
+16. KVMI_VM_GET_MAX_GFN
+-----------------------
+
+:Architecture: all
+:Versions: >= 1
+:Parameters: none
+:Returns:
+
+::
+
+        struct kvmi_error_code;
+        struct kvmi_vm_get_max_gfn_reply {
+                __u64 gfn;
+        };
+
+Provides the maximum GFN allocated to the VM by walking through all
+memory slots allocated by KVM, considering all address spaces indicated
+by KVM_ADDRESS_SPACE_NUM. Stricly speaking, the returned value refers
+to the first inaccessible GFN, next to the maximum accessible GFN.
+
 Events
 ======
 
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index fcbb19020c70..70d5a67badef 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -35,6 +35,8 @@ enum {
 	KVMI_VCPU_CONTROL_CR       = 15,
 	KVMI_VCPU_INJECT_EXCEPTION = 16,
 
+	KVMI_VM_GET_MAX_GFN = 17,
+
 	KVMI_NUM_MESSAGES
 };
 
@@ -130,6 +132,10 @@ struct kvmi_vcpu_control_events {
 	__u32 padding2;
 };
 
+struct kvmi_vm_get_max_gfn_reply {
+	__u64 gfn;
+};
+
 struct kvmi_event {
 	__u16 size;
 	__u16 vcpu;
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 6c9d1f3f927c..2852e6894e81 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -1229,6 +1229,17 @@ static void test_cmd_vcpu_inject_exception(struct kvm_vm *vm)
 	disable_vcpu_event(vm, KVMI_EVENT_BREAKPOINT);
 }
 
+static void test_cmd_vm_get_max_gfn(void)
+{
+	struct kvmi_vm_get_max_gfn_reply rpl;
+	struct kvmi_msg_hdr req;
+
+	test_vm_command(KVMI_VM_GET_MAX_GFN, &req, sizeof(req),
+			&rpl, sizeof(rpl));
+
+	DEBUG("max_gfn: 0x%llx\n", rpl.gfn);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	setup_socket();
@@ -1252,6 +1263,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_event_breakpoint(vm);
 	test_cmd_vcpu_control_cr(vm);
 	test_cmd_vcpu_inject_exception(vm);
+	test_cmd_vm_get_max_gfn();
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 9784477db46c..65a5801f143c 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -37,6 +37,7 @@
 			| BIT(KVMI_VM_CHECK_EVENT) \
 			| BIT(KVMI_VM_CONTROL_EVENTS) \
 			| BIT(KVMI_VM_GET_INFO) \
+			| BIT(KVMI_VM_GET_MAX_GFN) \
 			| BIT(KVMI_VM_READ_PHYSICAL) \
 			| BIT(KVMI_VM_WRITE_PHYSICAL) \
 			| BIT(KVMI_VCPU_GET_INFO) \
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 8d77e6a7794d..94fab70b56fa 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -23,6 +23,7 @@ static const char *const msg_IDs[] = {
 	[KVMI_VM_CHECK_EVENT]        = "KVMI_VM_CHECK_EVENT",
 	[KVMI_VM_CONTROL_EVENTS]     = "KVMI_VM_CONTROL_EVENTS",
 	[KVMI_VM_GET_INFO]           = "KVMI_VM_GET_INFO",
+	[KVMI_VM_GET_MAX_GFN]        = "KVMI_VM_GET_MAX_GFN",
 	[KVMI_VM_READ_PHYSICAL]      = "KVMI_VM_READ_PHYSICAL",
 	[KVMI_VM_WRITE_PHYSICAL]     = "KVMI_VM_WRITE_PHYSICAL",
 	[KVMI_VCPU_CONTROL_CR]       = "KVMI_VCPU_CONTROL_CR",
@@ -336,6 +337,18 @@ static int handle_pause_vcpu(struct kvm_introspection *kvmi,
 	return kvmi_msg_vm_reply(kvmi, msg, err, NULL, 0);
 }
 
+static int handle_vm_get_max_gfn(struct kvm_introspection *kvmi,
+				 const struct kvmi_msg_hdr *msg,
+				 const void *req)
+{
+	struct kvmi_vm_get_max_gfn_reply rpl;
+
+	memset(&rpl, 0, sizeof(rpl));
+	rpl.gfn = kvm_get_max_gfn(kvmi->kvm);
+
+	return kvmi_msg_vm_reply(kvmi, msg, 0, &rpl, sizeof(rpl));
+}
+
 /*
  * These commands are executed by the receiving thread/worker.
  */
@@ -346,6 +359,7 @@ static int(*const msg_vm[])(struct kvm_introspection *,
 	[KVMI_VM_CHECK_EVENT]    = handle_check_event,
 	[KVMI_VM_CONTROL_EVENTS] = handle_vm_control_events,
 	[KVMI_VM_GET_INFO]       = handle_get_info,
+	[KVMI_VM_GET_MAX_GFN]    = handle_vm_get_max_gfn,
 	[KVMI_VM_READ_PHYSICAL]  = handle_read_physical,
 	[KVMI_VM_WRITE_PHYSICAL] = handle_write_physical,
 	[KVMI_VCPU_PAUSE]        = handle_pause_vcpu,
