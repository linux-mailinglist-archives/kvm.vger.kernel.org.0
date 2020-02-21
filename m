Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFBE167F89
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 15:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728754AbgBUOEM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 09:04:12 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:52632 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728228AbgBUOEL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Feb 2020 09:04:11 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 48B6B38CB97C8456B5DC;
        Fri, 21 Feb 2020 22:03:59 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Fri, 21 Feb 2020
 22:03:52 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <sean.j.christopherson@intel.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <hpa@zytor.com>
CC:     <linmiaohe@huawei.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: [PATCH] KVM: X86: eliminate some meaningless code
Date:   Fri, 21 Feb 2020 22:05:26 +0800
Message-ID: <1582293926-23388-1-git-send-email-linmiaohe@huawei.com>
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
userspace by copy_to_user() from call site. Get rid of this meaningless
assignment and further cleanup the var r and out jump label.

On the other hand, when kvm_vcpu_ioctl_get_cpuid2() succeeds, we do not
change the content of struct cpuid. We can avoid copy_to_user() from call
site as struct cpuid remain unchanged.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 arch/x86/kvm/cpuid.c | 14 ++++----------
 arch/x86/kvm/x86.c   |  6 ------
 2 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b1c469446b07..b83cedc63328 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -265,20 +265,14 @@ int kvm_vcpu_ioctl_get_cpuid2(struct kvm_vcpu *vcpu,
 			      struct kvm_cpuid2 *cpuid,
 			      struct kvm_cpuid_entry2 __user *entries)
 {
-	int r;
-
-	r = -E2BIG;
 	if (cpuid->nent < vcpu->arch.cpuid_nent)
-		goto out;
-	r = -EFAULT;
+		return -E2BIG;
+
 	if (copy_to_user(entries, &vcpu->arch.cpuid_entries,
 			 vcpu->arch.cpuid_nent * sizeof(struct kvm_cpuid_entry2)))
-		goto out;
-	return 0;
+		return -EFAULT;
 
-out:
-	cpuid->nent = vcpu->arch.cpuid_nent;
-	return r;
+	return 0;
 }
 
 static __always_inline void cpuid_mask(u32 *word, int wordnum)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fbabb2f06273..683c54e7be36 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4295,12 +4295,6 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 			goto out;
 		r = kvm_vcpu_ioctl_get_cpuid2(vcpu, &cpuid,
 					      cpuid_arg->entries);
-		if (r)
-			goto out;
-		r = -EFAULT;
-		if (copy_to_user(cpuid_arg, &cpuid, sizeof(cpuid)))
-			goto out;
-		r = 0;
 		break;
 	}
 	case KVM_GET_MSRS: {
-- 
2.19.1

