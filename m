Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 791CC19790A
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729698AbgC3KUC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:20:02 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:43776 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729526AbgC3KUA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 06:20:00 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 95E2F305D3D2;
        Mon, 30 Mar 2020 13:13:01 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 728AD305B7A1;
        Mon, 30 Mar 2020 13:13:01 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v8 76/81] KVM: introspection: extend KVMI_GET_VERSION with struct kvmi_features
Date:   Mon, 30 Mar 2020 13:13:03 +0300
Message-Id: <20200330101308.21702-77-alazar@bitdefender.com>
In-Reply-To: <20200330101308.21702-1-alazar@bitdefender.com>
References: <20200330101308.21702-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is used by the introspection tool to check the hardware support
for single step.

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
index 3952aef9af9c..b211ae0ed86a 100644
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
 
 This command is always allowed and successful (if the introspection is
 built in kernel).
diff --git a/arch/x86/include/uapi/asm/kvmi.h b/arch/x86/include/uapi/asm/kvmi.h
index e4d591912f37..0bdf70cc8fc7 100644
--- a/arch/x86/include/uapi/asm/kvmi.h
+++ b/arch/x86/include/uapi/asm/kvmi.h
@@ -139,4 +139,9 @@ struct kvmi_event_msr_reply {
 	__u64 new_val;
 };
 
+struct kvmi_features {
+	__u8 singlestep;
+	__u8 padding[7];
+};
+
 #endif /* _UAPI_ASM_X86_KVMI_H */
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 06829e1c5737..d7e1c0690c43 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -1199,6 +1199,11 @@ bool kvmi_arch_pf_event(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 	return ret;
 }
 
+void kvmi_arch_features(struct kvmi_features *feat)
+{
+	feat->singlestep = !!kvm_x86_ops->control_singlestep;
+}
+
 bool kvmi_arch_pf_of_interest(struct kvm_vcpu *vcpu)
 {
 	return kvm_x86_ops->spt_fault(vcpu) &&
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index df192936b017..caf166e7ddff 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -97,6 +97,7 @@ struct kvmi_error_code {
 struct kvmi_get_version_reply {
 	__u32 version;
 	__u32 padding;
+	struct kvmi_features features;
 };
 
 struct kvmi_vm_check_command {
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 48cb546234c0..d4cfe595821d 100644
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
@@ -372,7 +374,10 @@ static void test_cmd_get_version(void)
 		    "Unexpected KVMI version %d, expecting %d\n",
 		    rpl.version, KVMI_VERSION);
 
+	features = rpl.features;
+
 	DEBUG("KVMI version: %u\n", rpl.version);
+	DEBUG("\tsinglestep: %u\n", features.singlestep);
 }
 
 static int cmd_check_command(__u16 id)
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 639d14811933..e0cb58c60697 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -127,5 +127,6 @@ int kvmi_arch_cmd_set_page_access(struct kvm_introspection *kvmi,
 bool kvmi_arch_pf_event(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 			u8 access);
 bool kvmi_arch_pf_of_interest(struct kvm_vcpu *vcpu);
+void kvmi_arch_features(struct kvmi_features *feat);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 10d4e40387ef..71a67154542f 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -182,6 +182,8 @@ static int handle_get_version(struct kvm_introspection *kvmi,
 	memset(&rpl, 0, sizeof(rpl));
 	rpl.version = KVMI_VERSION;
 
+	kvmi_arch_features(&rpl.features);
+
 	return kvmi_msg_vm_reply(kvmi, msg, 0, &rpl, sizeof(rpl));
 }
 
