Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE093294A37
	for <lists+kvm@lfdr.de>; Wed, 21 Oct 2020 11:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437415AbgJUJKn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 05:10:43 -0400
Received: from mga14.intel.com ([192.55.52.115]:30783 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437398AbgJUJKn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Oct 2020 05:10:43 -0400
IronPort-SDR: Fkr+o6F9XPJ2lNrdyNs+xVk9qKLMsmmUM91zKmgqeYr9/inYtotVUvUv2lBhgMNHm0hcLILR7X
 Anap8Pjw7V1A==
X-IronPort-AV: E=McAfee;i="6000,8403,9780"; a="166561666"
X-IronPort-AV: E=Sophos;i="5.77,400,1596524400"; 
   d="scan'208";a="166561666"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2020 02:10:42 -0700
IronPort-SDR: s4UPYx2xs+F+JbCm1YM6Q+sRMTMVfVDX3aOqowZd5jcR3VMMobbTJDE5QSpovd43gnLxkO27N4
 uhmpOUBz72Fw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,400,1596524400"; 
   d="scan'208";a="522682482"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga006.fm.intel.com with ESMTP; 21 Oct 2020 02:10:40 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     sean.j.christopherson@intel.com, pbonzini@redhat.com,
        xiaoyao.li@intel.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org
Cc:     kvm@vger.kernel.org, robert.hu@intel.com,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH v2 7/7] kvm: x86: Remove kvm_update_cpuid_runtime()
Date:   Wed, 21 Oct 2020 17:10:10 +0800
Message-Id: <1603271410-71343-8-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1603271410-71343-1-git-send-email-robert.hu@linux.intel.com>
References: <1603271410-71343-1-git-send-email-robert.hu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now kvm_update_cpuid_runtime() has been discerped into previous
extracted functions, and kvm_vcpu_after_set_cpuid() has all necessary
updates for kvm_vcpu_ioctl_set_cpuid2(), remove kvm_update_cpuid_runtime().

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/kvm/cpuid.c | 45 ---------------------------------------------
 arch/x86/kvm/cpuid.h |  1 -
 2 files changed, 46 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 454eda9..8f40148 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -160,49 +160,6 @@ static void kvm_update_lapic_timer_mode(struct kvm_vcpu *vcpu)
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
@@ -302,7 +259,6 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
 	}
 
 	cpuid_fix_nx_cap(vcpu);
-	kvm_update_cpuid_runtime(vcpu);
 	kvm_vcpu_after_set_cpuid(vcpu);
 
 	kvfree(cpuid_entries);
@@ -330,7 +286,6 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
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

