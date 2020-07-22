Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20757229C8C
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 18:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730625AbgGVQBn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 12:01:43 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37958 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730381AbgGVQBm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Jul 2020 12:01:42 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 360CB305D678;
        Wed, 22 Jul 2020 19:01:33 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.6])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 2AB37305FFA1;
        Wed, 22 Jul 2020 19:01:33 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v1 31/34] KVM: introspection: add #VE host capability checker
Date:   Wed, 22 Jul 2020 19:01:18 +0300
Message-Id: <20200722160121.9601-32-alazar@bitdefender.com>
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

Add one more field to struct kvmi_features in order to publish #VE
capabilities on the host as indicated by kvm_ve_supported flag.

Signed-off-by: Ștefan Șicleru <ssicleru@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst                | 5 +++--
 arch/x86/include/uapi/asm/kvmi.h               | 3 ++-
 arch/x86/kvm/kvmi.c                            | 1 +
 tools/testing/selftests/kvm/x86_64/kvmi_test.c | 1 +
 4 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 658c9df01469..caa51fccc463 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -265,11 +265,12 @@ For x86
 		__u8 singlestep;
 		__u8 vmfunc;
 		__u8 eptp;
-		__u8 padding[5];
+		__u8 ve;
+		__u8 padding[4];
 	};
 
 Returns the introspection API version and some of the features supported
-by the hardware (eg. alternate EPT views).
+by the hardware (eg. alternate EPT views, virtualization exception).
 
 This command is always allowed and successful.
 
diff --git a/arch/x86/include/uapi/asm/kvmi.h b/arch/x86/include/uapi/asm/kvmi.h
index fc35da900778..56992dacfb69 100644
--- a/arch/x86/include/uapi/asm/kvmi.h
+++ b/arch/x86/include/uapi/asm/kvmi.h
@@ -151,7 +151,8 @@ struct kvmi_features {
 	__u8 singlestep;
 	__u8 vmfunc;
 	__u8 eptp;
-	__u8 padding[5];
+	__u8 ve;
+	__u8 padding[4];
 };
 
 struct kvmi_vcpu_get_ept_view_reply {
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 27fd732cff29..3e8c83623703 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -1383,6 +1383,7 @@ void kvmi_arch_features(struct kvmi_features *feat)
 			kvm_x86_ops.get_vmfunc_status();
 	feat->eptp = kvm_x86_ops.get_eptp_switching_status &&
 			kvm_x86_ops.get_eptp_switching_status();
+	feat->ve = kvm_ve_supported;
 }
 
 bool kvmi_arch_start_singlestep(struct kvm_vcpu *vcpu)
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index d808cb61463d..4e099cbfcf4e 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -459,6 +459,7 @@ static void test_cmd_get_version(void)
 	pr_info("\tsinglestep: %u\n", features.singlestep);
 	pr_info("\tvmfunc: %u\n", features.vmfunc);
 	pr_info("\teptp: %u\n", features.eptp);
+	pr_info("\tve: %u\n", features.ve);
 }
 
 static void cmd_vm_check_command(__u16 id, __u16 padding, int expected_err)
