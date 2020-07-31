Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F190233D5B
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 04:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731287AbgGaCm5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 22:42:57 -0400
Received: from mga12.intel.com ([192.55.52.136]:47518 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731301AbgGaCm4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 22:42:56 -0400
IronPort-SDR: Zqu9U4nMzrpMFzNTVcHA1rtJMYiZZlV7j39bNfZ9RSuRpkE9Bfe2uHBS3/LK24BJTnJxL+J8Eg
 JCAeHKLzbOOQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="131290137"
X-IronPort-AV: E=Sophos;i="5.75,416,1589266800"; 
   d="scan'208";a="131290137"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 19:42:56 -0700
IronPort-SDR: gtMWMFR5+tmNh4gk8Mt2LPSwMpN0fKS1wn5aFH3h5GXnQ2YjMH1IUI71/3dy21G0BkqTv/QUuT
 EnRnlxak4CjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,416,1589266800"; 
   d="scan'208";a="304806036"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga002.jf.intel.com with ESMTP; 30 Jul 2020 19:42:53 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, xiaoyao.li@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org
Cc:     robert.hu@intel.com, Robert Hoo <robert.hu@linux.intel.com>
Subject: [RFC PATCH 9/9] KVM:x86: Remove kvm_update_cpuid_runtime()
Date:   Fri, 31 Jul 2020 10:42:27 +0800
Message-Id: <1596163347-18574-10-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1596163347-18574-1-git-send-email-robert.hu@linux.intel.com>
References: <1596163347-18574-1-git-send-email-robert.hu@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/kvm/cpuid.c | 45 ---------------------------------------------
 arch/x86/kvm/cpuid.h |  1 -
 2 files changed, 46 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 1d206aa..d7f5a6d 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -172,49 +172,6 @@ static void kvm_update_lapic_timer_mode(struct kvm_vcpu *vcpu)
 	}
 }
 
-void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
-{
-	struct kvm_cpuid_entry2 *best;
-
-	best = kvm_find_cpuid_entry(vcpu, 1, 0);
-	if (best) {
-		/* Update OSXSAVE bit */
-		if (boot_cpu_has(X86_FEATURE_XSAVE))
-			cpuid_entry_change(best, X86_FEATURE_OSXSAVE,
-				   kvm_read_cr4_bits(vcpu, X86_CR4_OSXSAVE));
-
-		cpuid_entry_change(best, X86_FEATURE_APIC,
-			   vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE);
-	}
-
-	best = kvm_find_cpuid_entry(vcpu, 7, 0);
-	if (best && boot_cpu_has(X86_FEATURE_PKU) && best->function == 0x7)
-		cpuid_entry_change(best, X86_FEATURE_OSPKE,
-				   kvm_read_cr4_bits(vcpu, X86_CR4_PKE));
-
-	best = kvm_find_cpuid_entry(vcpu, 0xD, 0);
-	if (best)
-		best->ebx = xstate_required_size(vcpu->arch.xcr0, false);
-
-	best = kvm_find_cpuid_entry(vcpu, 0xD, 1);
-	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
-		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
-		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
-
-	best = kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES, 0);
-	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
-		(best->eax & (1 << KVM_FEATURE_PV_UNHALT)))
-		best->eax &= ~(1 << KVM_FEATURE_PV_UNHALT);
-
-	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT)) {
-		best = kvm_find_cpuid_entry(vcpu, 0x1, 0);
-		if (best)
-			cpuid_entry_change(best, X86_FEATURE_MWAIT,
-					   vcpu->arch.ia32_misc_enable_msr &
-					   MSR_IA32_MISC_ENABLE_MWAIT);
-	}
-}
-
 static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	kvm_x86_ops.vcpu_after_set_cpuid(vcpu);
@@ -314,7 +271,6 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
 	}
 
 	cpuid_fix_nx_cap(vcpu);
-	kvm_update_cpuid_runtime(vcpu);
 	kvm_vcpu_after_set_cpuid(vcpu);
 
 	kvfree(cpuid_entries);
@@ -342,7 +298,6 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
 		goto out;
 	}
 
-	kvm_update_cpuid_runtime(vcpu);
 	kvm_vcpu_after_set_cpuid(vcpu);
 out:
 	return r;
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 7eabb44..7ef46bc 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -15,7 +15,6 @@
 void kvm_mwait_update_cpuid(struct kvm_vcpu *vcpu, bool set);
 void kvm_xcr0_update_cpuid(struct kvm_vcpu *vcpu);
 
-void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu);
 struct kvm_cpuid_entry2 *kvm_find_cpuid_entry(struct kvm_vcpu *vcpu,
 					      u32 function, u32 index);
 int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
-- 
1.8.3.1

