Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEC322C3C7E
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 10:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728229AbgKYJl7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 04:41:59 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:57200 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727838AbgKYJl6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Nov 2020 04:41:58 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 3B879305D3E9;
        Wed, 25 Nov 2020 11:35:55 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 1F6A83072784;
        Wed, 25 Nov 2020 11:35:55 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v10 76/81] KVM: introspection: extend KVMI_GET_VERSION with struct kvmi_features
Date:   Wed, 25 Nov 2020 11:35:55 +0200
Message-Id: <20201125093600.2766-77-alazar@bitdefender.com>
In-Reply-To: <20201125093600.2766-1-alazar@bitdefender.com>
References: <20201125093600.2766-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is used by the introspection tool to check the hardware support
for the single step feature.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst                | 15 +++++++++++++--
 arch/x86/include/uapi/asm/kvmi.h               |  5 +++++
 arch/x86/kvm/kvmi.c                            |  5 +++++
 include/uapi/linux/kvmi.h                      |  1 +
 tools/testing/selftests/kvm/x86_64/kvmi_test.c |  6 ++++++
 virt/kvm/introspection/kvmi_int.h              |  1 +
 virt/kvm/introspection/kvmi_msg.c              |  2 ++
 7 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index bdcc9066ae28..991922897f1d 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -243,10 +243,21 @@ The vCPU commands start with::
 	struct kvmi_get_version_reply {
 		__u32 version;
 		__u32 max_msg_size;
+		struct kvmi_features features;
 	};
 
-Returns the introspection API version and the largest accepted message
-size (useful for variable length messages).
+For x86
+
+::
+
+	struct kvmi_features {
+		__u8 singlestep;
+		__u8 padding[7];
+	};
+
+Returns the introspection API version, the largest accepted message size
+(useful for variable length messages) and some of the hardware supported
+features.
 
 This command is always allowed and successful.
 
diff --git a/arch/x86/include/uapi/asm/kvmi.h b/arch/x86/include/uapi/asm/kvmi.h
index 705e90c2137a..54d21e3c18c4 100644
--- a/arch/x86/include/uapi/asm/kvmi.h
+++ b/arch/x86/include/uapi/asm/kvmi.h
@@ -159,4 +159,9 @@ struct kvmi_vcpu_event_msr_reply {
 	__u64 new_val;
 };
 
+struct kvmi_features {
+	__u8 singlestep;
+	__u8 padding[7];
+};
+
 #endif /* _UAPI_ASM_X86_KVMI_H */
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index cd64762643d6..e0302883aec5 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -1081,3 +1081,8 @@ static void kvmi_track_flush_slot(struct kvm *kvm, struct kvm_memory_slot *slot,
 
 	kvmi_put(kvm);
 }
+
+void kvmi_arch_features(struct kvmi_features *feat)
+{
+	feat->singlestep = !!kvm_x86_ops.control_singlestep;
+}
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 3b432b37b17c..43631ed2b06c 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -103,6 +103,7 @@ struct kvmi_error_code {
 struct kvmi_get_version_reply {
 	__u32 version;
 	__u32 max_msg_size;
+	struct kvmi_features features;
 };
 
 struct kvmi_vm_check_command {
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index e36b574c264e..9984b0247ae9 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -59,6 +59,8 @@ struct vcpu_worker_data {
 	bool restart_on_shutdown;
 };
 
+static struct kvmi_features features;
+
 typedef void (*fct_pf_event)(struct kvm_vm *vm, struct kvmi_msg_hdr *hdr,
 				struct pf_ev *ev,
 				struct vcpu_reply *rpl);
@@ -443,6 +445,10 @@ static void test_cmd_get_version(void)
 
 	pr_debug("KVMI version: %u\n", rpl.version);
 	pr_debug("Max message size: %u\n", rpl.max_msg_size);
+
+	features = rpl.features;
+
+	pr_debug("singlestep support: %u\n", features.singlestep);
 }
 
 static void cmd_vm_check_command(__u16 id, int expected_err)
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index bf6545e66425..a51e7e4ed511 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -121,5 +121,6 @@ void kvmi_arch_update_page_tracking(struct kvm *kvm,
 				    struct kvmi_mem_access *m);
 void kvmi_arch_hook(struct kvm *kvm);
 void kvmi_arch_unhook(struct kvm *kvm);
+void kvmi_arch_features(struct kvmi_features *feat);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 276b898912fd..ee887ade62cb 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -134,6 +134,8 @@ static int handle_get_version(struct kvm_introspection *kvmi,
 	rpl.version = kvmi_version();
 	rpl.max_msg_size = KVMI_MAX_MSG_SIZE;
 
+	kvmi_arch_features(&rpl.features);
+
 	return kvmi_msg_vm_reply(kvmi, msg, 0, &rpl, sizeof(rpl));
 }
 
