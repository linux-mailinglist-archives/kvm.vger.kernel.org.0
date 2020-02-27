Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E93A170EEE
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2020 04:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728303AbgB0DUN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 22:20:13 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10701 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728220AbgB0DUN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 22:20:13 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 90D6C3EA773AAD8D60D2;
        Thu, 27 Feb 2020 11:20:08 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Thu, 27 Feb 2020
 11:19:59 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <sean.j.christopherson@intel.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>
CC:     <linmiaohe@huawei.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH v2] KVM: X86: deprecate obsolete KVM_GET_CPUID2 ioctl
Date:   Thu, 27 Feb 2020 11:21:28 +0800
Message-ID: <1582773688-4956-1-git-send-email-linmiaohe@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.105.18]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

When kvm_vcpu_ioctl_get_cpuid2() fails, we set cpuid->nent to the value of
vcpu->arch.cpuid_nent. But this is in vain as cpuid->nent is not copied to
userspace by copy_to_user() from call site. Also cpuid->nent is not updated
to indicate how many entries were retrieved on success case. So this ioctl
is straight up broken. And in fact, it's not used anywhere. So it should be
deprecated.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 arch/x86/kvm/cpuid.c           | 20 --------------------
 arch/x86/kvm/cpuid.h           |  3 ---
 arch/x86/kvm/x86.c             | 16 ++--------------
 include/uapi/linux/kvm.h       |  1 +
 tools/include/uapi/linux/kvm.h |  1 +
 5 files changed, 4 insertions(+), 37 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b1c469446b07..5e041a1282b8 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -261,26 +261,6 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
 	return r;
 }
 
-int kvm_vcpu_ioctl_get_cpuid2(struct kvm_vcpu *vcpu,
-			      struct kvm_cpuid2 *cpuid,
-			      struct kvm_cpuid_entry2 __user *entries)
-{
-	int r;
-
-	r = -E2BIG;
-	if (cpuid->nent < vcpu->arch.cpuid_nent)
-		goto out;
-	r = -EFAULT;
-	if (copy_to_user(entries, &vcpu->arch.cpuid_entries,
-			 vcpu->arch.cpuid_nent * sizeof(struct kvm_cpuid_entry2)))
-		goto out;
-	return 0;
-
-out:
-	cpuid->nent = vcpu->arch.cpuid_nent;
-	return r;
-}
-
 static __always_inline void cpuid_mask(u32 *word, int wordnum)
 {
 	reverse_cpuid_check(wordnum);
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 7366c618aa04..76555de38e1b 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -19,9 +19,6 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
 int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
 			      struct kvm_cpuid2 *cpuid,
 			      struct kvm_cpuid_entry2 __user *entries);
-int kvm_vcpu_ioctl_get_cpuid2(struct kvm_vcpu *vcpu,
-			      struct kvm_cpuid2 *cpuid,
-			      struct kvm_cpuid_entry2 __user *entries);
 bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
 	       u32 *ecx, u32 *edx, bool check_limit);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ddd1d296bd20..a6d99abedb2c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4295,21 +4295,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 					      cpuid_arg->entries);
 		break;
 	}
+	/* KVM_GET_CPUID2 is deprecated, should not be used. */
 	case KVM_GET_CPUID2: {
-		struct kvm_cpuid2 __user *cpuid_arg = argp;
-		struct kvm_cpuid2 cpuid;
-
-		r = -EFAULT;
-		if (copy_from_user(&cpuid, cpuid_arg, sizeof(cpuid)))
-			goto out;
-		r = kvm_vcpu_ioctl_get_cpuid2(vcpu, &cpuid,
-					      cpuid_arg->entries);
-		if (r)
-			goto out;
-		r = -EFAULT;
-		if (copy_to_user(cpuid_arg, &cpuid, sizeof(cpuid)))
-			goto out;
-		r = 0;
+		r = -EINVAL;
 		break;
 	}
 	case KVM_GET_MSRS: {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 4b95f9a31a2f..61524780603d 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1380,6 +1380,7 @@ struct kvm_s390_ucas_mapping {
 #define KVM_GET_LAPIC             _IOR(KVMIO,  0x8e, struct kvm_lapic_state)
 #define KVM_SET_LAPIC             _IOW(KVMIO,  0x8f, struct kvm_lapic_state)
 #define KVM_SET_CPUID2            _IOW(KVMIO,  0x90, struct kvm_cpuid2)
+/* KVM_GET_CPUID2 is deprecated, should not be used. */
 #define KVM_GET_CPUID2            _IOWR(KVMIO, 0x91, struct kvm_cpuid2)
 /* Available with KVM_CAP_VAPIC */
 #define KVM_TPR_ACCESS_REPORTING  _IOWR(KVMIO, 0x92, struct kvm_tpr_access_ctl)
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index f0a16b4adbbd..2ef719af4c57 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -1379,6 +1379,7 @@ struct kvm_s390_ucas_mapping {
 #define KVM_GET_LAPIC             _IOR(KVMIO,  0x8e, struct kvm_lapic_state)
 #define KVM_SET_LAPIC             _IOW(KVMIO,  0x8f, struct kvm_lapic_state)
 #define KVM_SET_CPUID2            _IOW(KVMIO,  0x90, struct kvm_cpuid2)
+/* KVM_GET_CPUID2 is deprecated, should not be used. */
 #define KVM_GET_CPUID2            _IOWR(KVMIO, 0x91, struct kvm_cpuid2)
 /* Available with KVM_CAP_VAPIC */
 #define KVM_TPR_ACCESS_REPORTING  _IOWR(KVMIO, 0x92, struct kvm_tpr_access_ctl)
-- 
2.19.1

