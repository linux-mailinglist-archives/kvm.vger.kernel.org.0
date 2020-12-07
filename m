Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48C592D1B2F
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 21:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbgLGUsp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 15:48:45 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:42608 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727410AbgLGUso (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 15:48:44 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 6D2CA30462E4;
        Mon,  7 Dec 2020 22:46:23 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 44FDF3072784;
        Mon,  7 Dec 2020 22:46:23 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v11 64/81] KVM: introspection: add KVMI_VM_GET_MAX_GFN
Date:   Mon,  7 Dec 2020 22:46:05 +0200
Message-Id: <20201207204622.15258-65-alazar@bitdefender.com>
In-Reply-To: <20201207204622.15258-1-alazar@bitdefender.com>
References: <20201207204622.15258-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ștefan Șicleru <ssicleru@bitdefender.com>

The introspection tool will use this command to get the memory address
range for which it can set access restrictions.

Signed-off-by: Ștefan Șicleru <ssicleru@bitdefender.com>
Co-developed-by: Nicușor Cîțu <nicu.citu@icloud.com>
Signed-off-by: Nicușor Cîțu <nicu.citu@icloud.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 19 +++++++++++++++++++
 include/uapi/linux/kvmi.h                     |  5 +++++
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 12 ++++++++++++
 virt/kvm/introspection/kvmi_msg.c             | 13 +++++++++++++
 4 files changed, 49 insertions(+)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index e688ac387faf..ecf4207b42d0 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -777,6 +777,25 @@ exception.
 * -KVM_EBUSY - another *KVMI_VCPU_INJECT_EXCEPTION*-*KVMI_VCPU_EVENT_TRAP*
                pair is in progress
 
+17. KVMI_VM_GET_MAX_GFN
+-----------------------
+
+:Architectures: all
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
+memory slots. Stricly speaking, the returned value refers to the first
+inaccessible GFN, next to the maximum accessible GFN.
+
 Events
 ======
 
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 263d98a5903e..d0e06363c407 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -29,6 +29,7 @@ enum {
 	KVMI_VM_WRITE_PHYSICAL  = KVMI_VM_MESSAGE_ID(7),
 	KVMI_VM_PAUSE_VCPU      = KVMI_VM_MESSAGE_ID(8),
 	KVMI_VM_CONTROL_CLEANUP = KVMI_VM_MESSAGE_ID(9),
+	KVMI_VM_GET_MAX_GFN     = KVMI_VM_MESSAGE_ID(10),
 
 	KVMI_NEXT_VM_MESSAGE
 };
@@ -177,4 +178,8 @@ struct kvmi_vm_control_cleanup {
 	__u8 padding[7];
 };
 
+struct kvmi_vm_get_max_gfn_reply {
+	__u64 gfn;
+};
+
 #endif /* _UAPI__LINUX_KVMI_H */
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index dc9f2f0d99e8..b4565802db22 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -1322,6 +1322,17 @@ static void test_cmd_vcpu_inject_exception(struct kvm_vm *vm)
 	disable_vcpu_event(vm, KVMI_VCPU_EVENT_BREAKPOINT);
 }
 
+static void test_cmd_vm_get_max_gfn(void)
+{
+	struct kvmi_vm_get_max_gfn_reply rpl;
+	struct kvmi_msg_hdr req;
+
+	test_vm_command(KVMI_VM_GET_MAX_GFN, &req, sizeof(req),
+			&rpl, sizeof(rpl), 0);
+
+	pr_debug("max_gfn: 0x%llx\n", rpl.gfn);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	srandom(time(0));
@@ -1347,6 +1358,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vm_control_cleanup(vm);
 	test_cmd_vcpu_control_cr(vm);
 	test_cmd_vcpu_inject_exception(vm);
+	test_cmd_vm_get_max_gfn();
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 14ced3d8f648..30692d84a247 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -290,6 +290,18 @@ static int handle_vm_control_cleanup(struct kvm_introspection *kvmi,
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
@@ -300,6 +312,7 @@ static kvmi_vm_msg_fct const msg_vm[] = {
 	[KVMI_VM_CONTROL_CLEANUP] = handle_vm_control_cleanup,
 	[KVMI_VM_CONTROL_EVENTS]  = handle_vm_control_events,
 	[KVMI_VM_GET_INFO]        = handle_vm_get_info,
+	[KVMI_VM_GET_MAX_GFN]     = handle_vm_get_max_gfn,
 	[KVMI_VM_PAUSE_VCPU]      = handle_vm_pause_vcpu,
 	[KVMI_VM_READ_PHYSICAL]   = handle_vm_read_physical,
 	[KVMI_VM_WRITE_PHYSICAL]  = handle_vm_write_physical,
