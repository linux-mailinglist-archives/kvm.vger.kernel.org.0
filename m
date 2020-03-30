Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 197951978EC
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729896AbgC3KU1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:20:27 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:43776 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729716AbgC3KUH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 06:20:07 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id D69333031EBF;
        Mon, 30 Mar 2020 13:12:59 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 8C138305B7A0;
        Mon, 30 Mar 2020 13:12:59 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v8 66/81] KVM: introspection: add KVMI_VM_GET_MAX_GFN
Date:   Mon, 30 Mar 2020 13:12:53 +0300
Message-Id: <20200330101308.21702-67-alazar@bitdefender.com>
In-Reply-To: <20200330101308.21702-1-alazar@bitdefender.com>
References: <20200330101308.21702-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ștefan Șicleru <ssicleru@bitdefender.com>

The introspection tool will use this command to get the address range
for which it can set access restrictions.

Signed-off-by: Ștefan Șicleru <ssicleru@bitdefender.com>
Co-developed-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 20 +++++++++++++++++++
 include/uapi/linux/kvmi.h                     |  6 ++++++
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 12 +++++++++++
 virt/kvm/introspection/kvmi_msg.c             | 14 +++++++++++++
 4 files changed, 52 insertions(+)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index d6a09fac4f52..1c5e256975fe 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -756,6 +756,26 @@ The *KVMI_EVENT_TRAP* event will be sent with the effective injected expection.
 * -KVM_EBUSY - another *KVMI_VCPU_INJECT_EXCEPTION*-*KVMI_EVENT_TRAP* pair
                is in progress
 
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
index 2603fa72154b..d33e8dae0084 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -34,6 +34,8 @@ enum {
 	KVMI_VCPU_CONTROL_CR       = 15,
 	KVMI_VCPU_INJECT_EXCEPTION = 16,
 
+	KVMI_VM_GET_MAX_GFN = 17,
+
 	KVMI_NUM_MESSAGES
 };
 
@@ -140,6 +142,10 @@ struct kvmi_vcpu_control_events {
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
index 6a6ad736db36..66766d112006 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -1232,6 +1232,17 @@ static void test_cmd_vcpu_inject_exception(struct kvm_vm *vm)
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
 	srandom(time(0));
@@ -1256,6 +1267,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_event_breakpoint(vm);
 	test_cmd_vcpu_control_cr(vm);
 	test_cmd_vcpu_inject_exception(vm);
+	test_cmd_vm_get_max_gfn();
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 830430777556..8ae57c87256f 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -26,6 +26,7 @@ static const char *const msg_IDs[] = {
 	[KVMI_VM_CHECK_EVENT]        = "KVMI_VM_CHECK_EVENT",
 	[KVMI_VM_CONTROL_EVENTS]     = "KVMI_VM_CONTROL_EVENTS",
 	[KVMI_VM_GET_INFO]           = "KVMI_VM_GET_INFO",
+	[KVMI_VM_GET_MAX_GFN]        = "KVMI_VM_GET_MAX_GFN",
 	[KVMI_VM_READ_PHYSICAL]      = "KVMI_VM_READ_PHYSICAL",
 	[KVMI_VM_WRITE_PHYSICAL]     = "KVMI_VM_WRITE_PHYSICAL",
 	[KVMI_VCPU_CONTROL_CR]       = "KVMI_VCPU_CONTROL_CR",
@@ -348,6 +349,18 @@ static int handle_pause_vcpu(struct kvm_introspection *kvmi,
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
@@ -358,6 +371,7 @@ static int(*const msg_vm[])(struct kvm_introspection *,
 	[KVMI_VM_CHECK_EVENT]    = handle_check_event,
 	[KVMI_VM_CONTROL_EVENTS] = handle_vm_control_events,
 	[KVMI_VM_GET_INFO]       = handle_get_info,
+	[KVMI_VM_GET_MAX_GFN]    = handle_vm_get_max_gfn,
 	[KVMI_VM_READ_PHYSICAL]  = handle_read_physical,
 	[KVMI_VM_WRITE_PHYSICAL] = handle_write_physical,
 	[KVMI_VCPU_PAUSE]        = handle_pause_vcpu,
