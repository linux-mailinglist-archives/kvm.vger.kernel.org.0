Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3684F228ABD
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731473AbgGUVQj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:16:39 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37924 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731388AbgGUVQQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:16:16 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id BDC88305D4FB;
        Wed, 22 Jul 2020 00:09:29 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 9C5F2304FA12;
        Wed, 22 Jul 2020 00:09:29 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 67/84] KVM: introspection: add KVMI_VM_GET_MAX_GFN
Date:   Wed, 22 Jul 2020 00:09:05 +0300
Message-Id: <20200721210922.7646-68-alazar@bitdefender.com>
In-Reply-To: <20200721210922.7646-1-alazar@bitdefender.com>
References: <20200721210922.7646-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ștefan Șicleru <ssicleru@bitdefender.com>

The introspection tool will use this command to get the memory address
range for which it can set access restrictions.

Signed-off-by: Ștefan Șicleru <ssicleru@bitdefender.com>
Co-developed-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 19 +++++++++++++++++++
 include/uapi/linux/kvmi.h                     |  6 ++++++
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 12 ++++++++++++
 virt/kvm/introspection/kvmi_msg.c             | 13 +++++++++++++
 4 files changed, 50 insertions(+)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 4263a9ac90e4..7da8efd18b89 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -789,6 +789,25 @@ exception.
 * -KVM_EBUSY - another *KVMI_VCPU_INJECT_EXCEPTION*-*KVMI_EVENT_TRAP* pair
                is in progress
 
+17. KVMI_VM_GET_MAX_GFN
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
+memory slots allocated by KVM. Stricly speaking, the returned value refers
+to the first inaccessible GFN, next to the maximum accessible GFN.
+
 Events
 ======
 
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index faf4624d7a97..2a4cc8c41465 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -37,6 +37,8 @@ enum {
 	KVMI_VCPU_CONTROL_CR       = 15,
 	KVMI_VCPU_INJECT_EXCEPTION = 16,
 
+	KVMI_VM_GET_MAX_GFN = 17,
+
 	KVMI_NUM_MESSAGES
 };
 
@@ -149,6 +151,10 @@ struct kvmi_vm_control_cleanup {
 	__u32 padding3;
 };
 
+struct kvmi_vm_get_max_gfn_reply {
+	__u64 gfn;
+};
+
 struct kvmi_event {
 	__u16 size;
 	__u16 vcpu;
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 9abf4ec0d09a..105adf75a68d 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -1420,6 +1420,17 @@ static void test_cmd_vcpu_inject_exception(struct kvm_vm *vm)
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
+	pr_info("max_gfn: 0x%llx\n", rpl.gfn);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	srandom(time(0));
@@ -1445,6 +1456,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vm_control_cleanup(vm);
 	test_cmd_vcpu_control_cr(vm);
 	test_cmd_vcpu_inject_exception(vm);
+	test_cmd_vm_get_max_gfn();
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 63efb85ff1ae..18bc1a711845 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -322,6 +322,18 @@ static int handle_vm_control_cleanup(struct kvm_introspection *kvmi,
 	return kvmi_msg_vm_reply(kvmi, msg, ec, NULL, 0);
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
  * These commands are executed by the receiving thread.
  */
@@ -334,6 +346,7 @@ static int(*const msg_vm[])(struct kvm_introspection *,
 	[KVMI_VM_CONTROL_CLEANUP] = handle_vm_control_cleanup,
 	[KVMI_VM_CONTROL_EVENTS]  = handle_vm_control_events,
 	[KVMI_VM_GET_INFO]        = handle_vm_get_info,
+	[KVMI_VM_GET_MAX_GFN]     = handle_vm_get_max_gfn,
 	[KVMI_VM_READ_PHYSICAL]   = handle_vm_read_physical,
 	[KVMI_VM_WRITE_PHYSICAL]  = handle_vm_write_physical,
 };
