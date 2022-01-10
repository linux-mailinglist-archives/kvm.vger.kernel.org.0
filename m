Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1EC6488FF5
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 07:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238887AbiAJGFK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 01:05:10 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:37454 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238871AbiAJGFI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Jan 2022 01:05:08 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R291e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=shirong@linux.alibaba.com;NM=1;PH=DS;RN=25;SR=0;TI=SMTPD_---0V1LvBNz_1641794698;
Received: from localhost.localdomain(mailfrom:shirong@linux.alibaba.com fp:SMTPD_---0V1LvBNz_1641794698)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 10 Jan 2022 14:05:04 +0800
From:   Shirong Hao <shirong@linux.alibaba.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.co, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        brijesh.singh@amd.com, thomas.lendacky@amd.com, john.allen@amd.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        srutherford@google.com, ashish.kalra@amd.com, natet@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, zhang.jia@linux.alibaba.com,
        Shirong Hao <shirong@linux.alibaba.com>
Subject: [PATCH 1/3] KVM: X86: Introduce KVM_HC_VM_HANDLE hypercall
Date:   Mon, 10 Jan 2022 14:04:43 +0800
Message-Id: <20220110060445.549800-2-shirong@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220110060445.549800-1-shirong@linux.alibaba.com>
References: <20220110060445.549800-1-shirong@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This hypercall is used by the SEV guest to get the firmware handle.

Signed-off-by: Shirong Hao <shirong@linux.alibaba.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm/svm.c          | 11 +++++++++++
 arch/x86/kvm/x86.c              |  7 ++++++-
 include/uapi/linux/kvm_para.h   |  1 +
 4 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2164b9f4c7b0..fe745f4e6954 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1493,6 +1493,7 @@ struct kvm_x86_ops {
 	int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
 
 	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
+	int (*vm_handle)(struct kvm *kvm);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d0f68d11ec70..c0eb310cb4c3 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4576,6 +4576,16 @@ static int svm_vm_init(struct kvm *kvm)
 	return 0;
 }
 
+static int sev_vm_handle(struct kvm *kvm)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+
+	if (!sev_guest(kvm))
+		return -ENOTTY;
+
+	return sev->handle;
+}
+
 static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.name = "kvm_amd",
 
@@ -4705,6 +4715,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.complete_emulated_msr = svm_complete_emulated_msr,
 
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
+	.vm_handle = sev_vm_handle,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0cf1082455df..24acf0f2a539 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8906,7 +8906,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		a3 &= 0xFFFFFFFF;
 	}
 
-	if (static_call(kvm_x86_get_cpl)(vcpu) != 0) {
+	if (static_call(kvm_x86_get_cpl)(vcpu) != 0 && nr != KVM_HC_VM_HANDLE) {
 		ret = -KVM_EPERM;
 		goto out;
 	}
@@ -8965,6 +8965,11 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		vcpu->arch.complete_userspace_io = complete_hypercall_exit;
 		return 0;
 	}
+	case KVM_HC_VM_HANDLE:
+		ret = -KVM_ENOSYS;
+		if (kvm_x86_ops.vm_handle)
+			ret = kvm_x86_ops.vm_handle(vcpu->kvm);
+		break;
 	default:
 		ret = -KVM_ENOSYS;
 		break;
diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
index 960c7e93d1a9..b64469a12707 100644
--- a/include/uapi/linux/kvm_para.h
+++ b/include/uapi/linux/kvm_para.h
@@ -30,6 +30,7 @@
 #define KVM_HC_SEND_IPI		10
 #define KVM_HC_SCHED_YIELD		11
 #define KVM_HC_MAP_GPA_RANGE		12
+#define KVM_HC_VM_HANDLE		13
 
 /*
  * hypercalls use architecture specific
-- 
2.27.0

