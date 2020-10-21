Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82AE4294A33
	for <lists+kvm@lfdr.de>; Wed, 21 Oct 2020 11:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437405AbgJUJKe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 05:10:34 -0400
Received: from mga07.intel.com ([134.134.136.100]:58976 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437394AbgJUJKe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Oct 2020 05:10:34 -0400
IronPort-SDR: Ug2OLLaEm9qv2D0buPssireTsHJeXKjMaRvlymKM/6esIUPFWsmJwlhzVG39IUbc72HgT7dweF
 eD1zqjMQ76mA==
X-IronPort-AV: E=McAfee;i="6000,8403,9780"; a="231530451"
X-IronPort-AV: E=Sophos;i="5.77,400,1596524400"; 
   d="scan'208";a="231530451"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2020 02:10:33 -0700
IronPort-SDR: tMZbMCOZMTAJWmDKwTyS5jrOHwhEJiknIRork/qlu827POBFzwi2VTflRiVYCmKOcdQIXRYb1x
 VqvUNqj+XeWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,400,1596524400"; 
   d="scan'208";a="522682439"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga006.fm.intel.com with ESMTP; 21 Oct 2020 02:10:31 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     sean.j.christopherson@intel.com, pbonzini@redhat.com,
        xiaoyao.li@intel.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org
Cc:     kvm@vger.kernel.org, robert.hu@intel.com,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH v2 3/7] kvm: x86: Extract kvm_osxsave_update_cpuid() and kvm_pke_update_cpuid() from kvm_update_cpuid_runtime()
Date:   Wed, 21 Oct 2020 17:10:06 +0800
Message-Id: <1603271410-71343-4-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1603271410-71343-1-git-send-email-robert.hu@linux.intel.com>
References: <1603271410-71343-1-git-send-email-robert.hu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

And substitute kvm_update_cpuid_runtime() invocations in kvm_set_cr4(),
enter_smm() and __set_sregs() with them accordingly.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/kvm/cpuid.c | 11 +++++++++++
 arch/x86/kvm/cpuid.h |  2 ++
 arch/x86/kvm/x86.c   | 24 +++++++++++++++---------
 3 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 6d5cd03..18cd27a 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -82,11 +82,22 @@ static inline void guest_cpuid_change(struct kvm_vcpu *vcpu, u32 function,
 		cpuid_entry_change(e, feature, set);
 }
 
+void kvm_osxsave_update_cpuid(struct kvm_vcpu *vcpu, bool set)
+{
+	if (boot_cpu_has(X86_FEATURE_XSAVE))
+		guest_cpuid_change(vcpu, 1, 0, X86_FEATURE_OSXSAVE, set);
+}
+
 void kvm_apic_base_update_cpuid(struct kvm_vcpu *vcpu, bool set)
 {
 	guest_cpuid_change(vcpu, 1, 0, X86_FEATURE_APIC, set);
 }
 
+void kvm_pke_update_cpuid(struct kvm_vcpu *vcpu, bool set)
+{
+	if (boot_cpu_has(X86_FEATURE_PKU))
+		guest_cpuid_change(vcpu, 7, 0, X86_FEATURE_OSPKE, set);
+}
 
 void kvm_xcr0_update_cpuid(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 845544e..98ea431 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -9,6 +9,8 @@
 extern u32 kvm_cpu_caps[NCAPINTS] __read_mostly;
 void kvm_set_cpu_caps(void);
 
+void kvm_osxsave_update_cpuid(struct kvm_vcpu *vcpu, bool set);
+void kvm_pke_update_cpuid(struct kvm_vcpu *vcpu, bool set);
 void kvm_apic_base_update_cpuid(struct kvm_vcpu *vcpu, bool set);
 void kvm_xcr0_update_cpuid(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cd41bec..5e9a51d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1008,8 +1008,10 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	    (!(cr4 & X86_CR4_PCIDE) && (old_cr4 & X86_CR4_PCIDE)))
 		kvm_mmu_reset_context(vcpu);
 
-	if ((cr4 ^ old_cr4) & (X86_CR4_OSXSAVE | X86_CR4_PKE))
-		kvm_update_cpuid_runtime(vcpu);
+	if ((cr4 ^ old_cr4) & X86_CR4_OSXSAVE)
+		kvm_osxsave_update_cpuid(vcpu, !!(cr4 & X86_CR4_OSXSAVE));
+	if ((cr4 ^ old_cr4) & X86_CR4_PKE)
+		kvm_pke_update_cpuid(vcpu, !!(cr4 & X86_CR4_PKE));
 
 	return 0;
 }
@@ -8177,6 +8179,8 @@ static void enter_smm(struct kvm_vcpu *vcpu)
 	vcpu->arch.cr0 = cr0;
 
 	kvm_x86_ops.set_cr4(vcpu, 0);
+	kvm_osxsave_update_cpuid(vcpu, false);
+	kvm_pke_update_cpuid(vcpu, false);
 
 	/* Undocumented: IDT limit is set to zero on entry to SMM.  */
 	dt.address = dt.size = 0;
@@ -8214,7 +8218,6 @@ static void enter_smm(struct kvm_vcpu *vcpu)
 		kvm_x86_ops.set_efer(vcpu, 0);
 #endif
 
-	kvm_update_cpuid_runtime(vcpu);
 	kvm_mmu_reset_context(vcpu);
 }
 
@@ -9193,7 +9196,7 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 {
 	struct msr_data apic_base_msr;
 	int mmu_reset_needed = 0;
-	int cpuid_update_needed = 0;
+	ulong old_cr4 = 0;
 	int pending_vec, max_bits, idx;
 	struct desc_ptr dt;
 	int ret = -EINVAL;
@@ -9227,12 +9230,15 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 	kvm_x86_ops.set_cr0(vcpu, sregs->cr0);
 	vcpu->arch.cr0 = sregs->cr0;
 
-	mmu_reset_needed |= kvm_read_cr4(vcpu) != sregs->cr4;
-	cpuid_update_needed |= ((kvm_read_cr4(vcpu) ^ sregs->cr4) &
-				(X86_CR4_OSXSAVE | X86_CR4_PKE));
+	old_cr4 = kvm_read_cr4(vcpu);
+	mmu_reset_needed |= old_cr4 != sregs->cr4;
+
 	kvm_x86_ops.set_cr4(vcpu, sregs->cr4);
-	if (cpuid_update_needed)
-		kvm_update_cpuid_runtime(vcpu);
+
+	if ((old_cr4 ^ sregs->cr4) & X86_CR4_OSXSAVE)
+		kvm_osxsave_update_cpuid(vcpu, !!(sregs->cr4 & X86_CR4_OSXSAVE));
+	if ((old_cr4 ^ sregs->cr4) & X86_CR4_PKE)
+		kvm_pke_update_cpuid(vcpu, !!(sregs->cr4 & X86_CR4_PKE));
 
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
 	if (is_pae_paging(vcpu)) {
-- 
1.8.3.1

