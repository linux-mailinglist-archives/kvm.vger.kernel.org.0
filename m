Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC1E3169CBD
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 04:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbgBXDpx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Feb 2020 22:45:53 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10674 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727215AbgBXDpx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Feb 2020 22:45:53 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id B7642D7FA239ADBD3D93;
        Mon, 24 Feb 2020 11:45:50 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Mon, 24 Feb 2020
 11:45:40 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <sean.j.christopherson@intel.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>
CC:     <linmiaohe@huawei.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH RESEND] KVM: X86: eliminate obsolete KVM_GET_CPUID2 ioctl
Date:   Mon, 24 Feb 2020 11:47:12 +0800
Message-ID: <1582516032-5161-1-git-send-email-linmiaohe@huawei.com>
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

KVM_GET_CPUID2 ioctl is straight up broken and not used anywhere. Remove
it directly.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 arch/x86/kvm/cpuid.c           | 20 --------------------
 arch/x86/kvm/cpuid.h           |  3 ---
 arch/x86/kvm/x86.c             | 17 -----------------
 include/uapi/linux/kvm.h       |  1 -
 tools/include/uapi/linux/kvm.h |  1 -
 5 files changed, 42 deletions(-)

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
index fbabb2f06273..ddcc51b89e2c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4286,23 +4286,6 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 					      cpuid_arg->entries);
 		break;
 	}
-	case KVM_GET_CPUID2: {
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
-		break;
-	}
 	case KVM_GET_MSRS: {
 		int idx = srcu_read_lock(&vcpu->kvm->srcu);
 		r = msr_io(vcpu, argp, do_get_msr, 1);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 4b95f9a31a2f..b37b8c1f300e 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1380,7 +1380,6 @@ struct kvm_s390_ucas_mapping {
 #define KVM_GET_LAPIC             _IOR(KVMIO,  0x8e, struct kvm_lapic_state)
 #define KVM_SET_LAPIC             _IOW(KVMIO,  0x8f, struct kvm_lapic_state)
 #define KVM_SET_CPUID2            _IOW(KVMIO,  0x90, struct kvm_cpuid2)
-#define KVM_GET_CPUID2            _IOWR(KVMIO, 0x91, struct kvm_cpuid2)
 /* Available with KVM_CAP_VAPIC */
 #define KVM_TPR_ACCESS_REPORTING  _IOWR(KVMIO, 0x92, struct kvm_tpr_access_ctl)
 /* Available with KVM_CAP_VAPIC */
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index f0a16b4adbbd..431106dedd2c 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -1379,7 +1379,6 @@ struct kvm_s390_ucas_mapping {
 #define KVM_GET_LAPIC             _IOR(KVMIO,  0x8e, struct kvm_lapic_state)
 #define KVM_SET_LAPIC             _IOW(KVMIO,  0x8f, struct kvm_lapic_state)
 #define KVM_SET_CPUID2            _IOW(KVMIO,  0x90, struct kvm_cpuid2)
-#define KVM_GET_CPUID2            _IOWR(KVMIO, 0x91, struct kvm_cpuid2)
 /* Available with KVM_CAP_VAPIC */
 #define KVM_TPR_ACCESS_REPORTING  _IOWR(KVMIO, 0x92, struct kvm_tpr_access_ctl)
 /* Available with KVM_CAP_VAPIC */
-- 
2.19.1

