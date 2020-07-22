Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75F43229CB5
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 18:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728956AbgGVQCQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 12:02:16 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:38026 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729191AbgGVQBj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Jul 2020 12:01:39 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 4FF5D305D7FE;
        Wed, 22 Jul 2020 19:01:32 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.6])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 3F05D30003E9;
        Wed, 22 Jul 2020 19:01:32 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v1 12/34] KVM: introspection: extend struct kvmi_features with the EPT views status support
Date:   Wed, 22 Jul 2020 19:00:59 +0300
Message-Id: <20200722160121.9601-13-alazar@bitdefender.com>
In-Reply-To: <20200722160121.9601-1-alazar@bitdefender.com>
References: <20200722160121.9601-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ștefan Șicleru <ssicleru@bitdefender.com>

The introspection tool will use these new fields to check
the hardware support before using the related introspection commands.

Signed-off-by: Ștefan Șicleru <ssicleru@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst                | 6 ++++--
 arch/x86/include/uapi/asm/kvmi.h               | 4 +++-
 arch/x86/kvm/kvmi.c                            | 4 ++++
 tools/testing/selftests/kvm/x86_64/kvmi_test.c | 2 ++
 4 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 62138fa4b65c..234eacec4db1 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -263,11 +263,13 @@ For x86
 
 	struct kvmi_features {
 		__u8 singlestep;
-		__u8 padding[7];
+		__u8 vmfunc;
+		__u8 eptp;
+		__u8 padding[5];
 	};
 
 Returns the introspection API version and some of the features supported
-by the hardware.
+by the hardware (eg. alternate EPT views).
 
 This command is always allowed and successful.
 
diff --git a/arch/x86/include/uapi/asm/kvmi.h b/arch/x86/include/uapi/asm/kvmi.h
index 32af803f1d70..51b399d50a2a 100644
--- a/arch/x86/include/uapi/asm/kvmi.h
+++ b/arch/x86/include/uapi/asm/kvmi.h
@@ -147,7 +147,9 @@ struct kvmi_event_msr_reply {
 
 struct kvmi_features {
 	__u8 singlestep;
-	__u8 padding[7];
+	__u8 vmfunc;
+	__u8 eptp;
+	__u8 padding[5];
 };
 
 #endif /* _UAPI_ASM_X86_KVMI_H */
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 7b3b64d27d18..25c1f8f2e221 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -1356,6 +1356,10 @@ static void kvmi_track_flush_slot(struct kvm *kvm, struct kvm_memory_slot *slot,
 void kvmi_arch_features(struct kvmi_features *feat)
 {
 	feat->singlestep = !!kvm_x86_ops.control_singlestep;
+	feat->vmfunc = kvm_x86_ops.get_vmfunc_status &&
+			kvm_x86_ops.get_vmfunc_status();
+	feat->eptp = kvm_x86_ops.get_eptp_switching_status &&
+			kvm_x86_ops.get_eptp_switching_status();
 }
 
 bool kvmi_arch_start_singlestep(struct kvm_vcpu *vcpu)
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index e968b1a6f969..33fffcb3a171 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -443,6 +443,8 @@ static void test_cmd_get_version(void)
 
 	pr_info("KVMI version: %u\n", rpl.version);
 	pr_info("\tsinglestep: %u\n", features.singlestep);
+	pr_info("\tvmfunc: %u\n", features.vmfunc);
+	pr_info("\teptp: %u\n", features.eptp);
 }
 
 static void cmd_vm_check_command(__u16 id, __u16 padding, int expected_err)
