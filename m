Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B128D17308F
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 06:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgB1Fml (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Feb 2020 00:42:41 -0500
Received: from mga14.intel.com ([192.55.52.115]:55983 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725911AbgB1Fml (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Feb 2020 00:42:41 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Feb 2020 21:42:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,493,1574150400"; 
   d="scan'208";a="257009675"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.60])
  by orsmga002.jf.intel.com with ESMTP; 27 Feb 2020 21:42:37 -0800
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: Remove superfluous brackets in kvm_arch_dev_ioctl()
Date:   Fri, 28 Feb 2020 13:25:27 +0800
Message-Id: <20200228052527.148384-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove unnecessary brackets from the case statements in
kvm_arch_dev_ioctl().

The brackets are visually confusing and error-prone, e.g., brackets of
case KVM_X86_GET_MCE_CAP_SUPPORTED accidently includes case
KVM_GET_MSR_FEATURE_INDEX_LIST and KVM_GET_MSRS.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/x86.c | 33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ddd1d296bd20..9efd693189df 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3412,14 +3412,16 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 long kvm_arch_dev_ioctl(struct file *filp,
 			unsigned int ioctl, unsigned long arg)
 {
-	void __user *argp = (void __user *)arg;
+	struct kvm_msr_list __user *user_msr_list;
+	struct kvm_cpuid2 __user *cpuid_arg;
+	struct kvm_msr_list msr_list;
+	struct kvm_cpuid2 cpuid;
+	unsigned int n;
 	long r;
 
 	switch (ioctl) {
-	case KVM_GET_MSR_INDEX_LIST: {
-		struct kvm_msr_list __user *user_msr_list = argp;
-		struct kvm_msr_list msr_list;
-		unsigned n;
+	case KVM_GET_MSR_INDEX_LIST:
+		user_msr_list = (void __user *)arg;
 
 		r = -EFAULT;
 		if (copy_from_user(&msr_list, user_msr_list, sizeof(msr_list)))
@@ -3441,11 +3443,9 @@ long kvm_arch_dev_ioctl(struct file *filp,
 			goto out;
 		r = 0;
 		break;
-	}
 	case KVM_GET_SUPPORTED_CPUID:
-	case KVM_GET_EMULATED_CPUID: {
-		struct kvm_cpuid2 __user *cpuid_arg = argp;
-		struct kvm_cpuid2 cpuid;
+	case KVM_GET_EMULATED_CPUID:
+		cpuid_arg = (void __user *)arg;
 
 		r = -EFAULT;
 		if (copy_from_user(&cpuid, cpuid_arg, sizeof(cpuid)))
@@ -3461,18 +3461,15 @@ long kvm_arch_dev_ioctl(struct file *filp,
 			goto out;
 		r = 0;
 		break;
-	}
-	case KVM_X86_GET_MCE_CAP_SUPPORTED: {
+	case KVM_X86_GET_MCE_CAP_SUPPORTED:
 		r = -EFAULT;
-		if (copy_to_user(argp, &kvm_mce_cap_supported,
+		if (copy_to_user((void __user *)arg, &kvm_mce_cap_supported,
 				 sizeof(kvm_mce_cap_supported)))
 			goto out;
 		r = 0;
 		break;
-	case KVM_GET_MSR_FEATURE_INDEX_LIST: {
-		struct kvm_msr_list __user *user_msr_list = argp;
-		struct kvm_msr_list msr_list;
-		unsigned int n;
+	case KVM_GET_MSR_FEATURE_INDEX_LIST:
+		user_msr_list = (void __user *)arg;
 
 		r = -EFAULT;
 		if (copy_from_user(&msr_list, user_msr_list, sizeof(msr_list)))
@@ -3490,11 +3487,9 @@ long kvm_arch_dev_ioctl(struct file *filp,
 			goto out;
 		r = 0;
 		break;
-	}
 	case KVM_GET_MSRS:
-		r = msr_io(NULL, argp, do_get_msr_feature, 1);
+		r = msr_io(NULL, (void __user *)arg, do_get_msr_feature, 1);
 		break;
-	}
 	default:
 		r = -EINVAL;
 	}
-- 
2.19.1

