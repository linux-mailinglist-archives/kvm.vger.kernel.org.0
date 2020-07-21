Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3D5E228AB2
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731431AbgGUVQb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:16:31 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37854 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731394AbgGUVQS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:16:18 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id B4A8C305D507;
        Wed, 22 Jul 2020 00:09:31 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 8E51F304FA13;
        Wed, 22 Jul 2020 00:09:31 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 79/84] KVM: introspection: extend KVMI_GET_VERSION with struct kvmi_features
Date:   Wed, 22 Jul 2020 00:09:17 +0300
Message-Id: <20200721210922.7646-80-alazar@bitdefender.com>
In-Reply-To: <20200721210922.7646-1-alazar@bitdefender.com>
References: <20200721210922.7646-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is used by the introspection tool to check the hardware support
for the single step feature.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst                | 13 ++++++++++++-
 arch/x86/include/uapi/asm/kvmi.h               |  5 +++++
 arch/x86/kvm/kvmi.c                            |  5 +++++
 include/uapi/linux/kvmi.h                      |  1 +
 tools/testing/selftests/kvm/x86_64/kvmi_test.c |  5 +++++
 virt/kvm/introspection/kvmi_int.h              |  1 +
 virt/kvm/introspection/kvmi_msg.c              |  2 ++
 7 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index b2e2a9edda77..47387f297029 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -254,9 +254,20 @@ The vCPU commands start with::
 	struct kvmi_get_version_reply {
 		__u32 version;
 		__u32 padding;
+		struct kvmi_features features;
 	};
 
-Returns the introspection API version.
+For x86
+
+::
+
+	struct kvmi_features {
+		__u8 singlestep;
+		__u8 padding[7];
+	};
+
+Returns the introspection API version and some of the features supported
+by the hardware.
 
 This command is always allowed and successful.
 
diff --git a/arch/x86/include/uapi/asm/kvmi.h b/arch/x86/include/uapi/asm/kvmi.h
index 1bb13da61dbf..32af803f1d70 100644
--- a/arch/x86/include/uapi/asm/kvmi.h
+++ b/arch/x86/include/uapi/asm/kvmi.h
@@ -145,4 +145,9 @@ struct kvmi_event_msr_reply {
 	__u64 new_val;
 };
 
+struct kvmi_features {
+	__u8 singlestep;
+	__u8 padding[7];
+};
+
 #endif /* _UAPI_ASM_X86_KVMI_H */
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 8fbf1720749b..672a113b3bf4 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -1350,3 +1350,8 @@ static void kvmi_track_flush_slot(struct kvm *kvm, struct kvm_memory_slot *slot,
 
 	kvmi_put(kvm);
 }
+
+void kvmi_arch_features(struct kvmi_features *feat)
+{
+	feat->singlestep = !!kvm_x86_ops.control_singlestep;
+}
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index dc7ba12498b7..a84affbafa67 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -101,6 +101,7 @@ struct kvmi_error_code {
 struct kvmi_get_version_reply {
 	__u32 version;
 	__u32 padding;
+	struct kvmi_features features;
 };
 
 struct kvmi_vm_check_command {
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 21b3f7a459c8..eabe7dae149e 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -56,6 +56,8 @@ struct vcpu_worker_data {
 	bool restart_on_shutdown;
 };
 
+static struct kvmi_features features;
+
 typedef void (*fct_pf_event)(struct kvm_vm *vm, struct kvmi_msg_hdr *hdr,
 				struct pf_ev *ev,
 				struct vcpu_reply *rpl);
@@ -437,7 +439,10 @@ static void test_cmd_get_version(void)
 		    "Unexpected KVMI version %d, expecting %d\n",
 		    rpl.version, KVMI_VERSION);
 
+	features = rpl.features;
+
 	pr_info("KVMI version: %u\n", rpl.version);
+	pr_info("\tsinglestep: %u\n", features.singlestep);
 }
 
 static void cmd_vm_check_command(__u16 id, __u16 padding, int expected_err)
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 9f2341fe21d5..68b8d60a7fac 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -138,5 +138,6 @@ void kvmi_arch_update_page_tracking(struct kvm *kvm,
 				    struct kvmi_mem_access *m);
 void kvmi_arch_hook(struct kvm *kvm);
 void kvmi_arch_unhook(struct kvm *kvm);
+void kvmi_arch_features(struct kvmi_features *feat);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 0a0d10b43f2d..e754cee48912 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -148,6 +148,8 @@ static int handle_get_version(struct kvm_introspection *kvmi,
 	memset(&rpl, 0, sizeof(rpl));
 	rpl.version = kvmi_version();
 
+	kvmi_arch_features(&rpl.features);
+
 	return kvmi_msg_vm_reply(kvmi, msg, 0, &rpl, sizeof(rpl));
 }
 
