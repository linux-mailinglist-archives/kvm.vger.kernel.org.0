Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93CF91768F1
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 01:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbgCBX50 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 18:57:26 -0500
Received: from mga17.intel.com ([192.55.52.151]:37738 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727291AbgCBX50 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 18:57:26 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 15:57:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="243384777"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 02 Mar 2020 15:57:23 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 51/66] KVM: x86: Set emulated/transmuted feature bits via kvm_cpu_caps
Date:   Mon,  2 Mar 2020 15:56:54 -0800
Message-Id: <20200302235709.27467-52-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302235709.27467-1-sean.j.christopherson@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set emulated and transmuted (set based on other features) feature bits
via kvm_cpu_caps now that the CPUID output for KVM_GET_SUPPORTED_CPUID
is direcly overidden with kvm_cpu_caps.

Note, VMX emulation of UMIP already sets kvm_cpu_caps.

No functional change intended.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c   | 72 +++++++++++++++++++++---------------------
 arch/x86/kvm/svm.c     | 18 +++--------
 arch/x86/kvm/vmx/vmx.c | 18 +----------
 3 files changed, 42 insertions(+), 66 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 5fef02dbf4e1..c0ee0cb33a37 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -315,6 +315,8 @@ void kvm_set_cpu_caps(void)
 		0 /* Reserved*/ | F(AES) | F(XSAVE) | 0 /* OSXSAVE */ | F(AVX) |
 		F(F16C) | F(RDRAND)
 	);
+	/* KVM emulates x2apic in software irrespective of host support. */
+	kvm_cpu_cap_set(X86_FEATURE_X2APIC);
 
 	kvm_cpu_cap_mask(CPUID_1_EDX,
 		F(FPU) | F(VME) | F(DE) | F(PSE) |
@@ -351,6 +353,17 @@ void kvm_set_cpu_caps(void)
 		F(MD_CLEAR)
 	);
 
+	/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
+	kvm_cpu_cap_set(X86_FEATURE_TSC_ADJUST);
+	kvm_cpu_cap_set(X86_FEATURE_ARCH_CAPABILITIES);
+
+	if (boot_cpu_has(X86_FEATURE_IBPB) && boot_cpu_has(X86_FEATURE_IBRS))
+		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL);
+	if (boot_cpu_has(X86_FEATURE_STIBP))
+		kvm_cpu_cap_set(X86_FEATURE_INTEL_STIBP);
+	if (boot_cpu_has(X86_FEATURE_AMD_SSBD))
+		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
+
 	kvm_cpu_cap_mask(CPUID_7_1_EAX,
 		F(AVX512_BF16)
 	);
@@ -384,6 +397,29 @@ void kvm_set_cpu_caps(void)
 		F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON)
 	);
 
+	/*
+	 * AMD has separate bits for each SPEC_CTRL bit.
+	 * arch/x86/kernel/cpu/bugs.c is kind enough to
+	 * record that in cpufeatures so use them.
+	 */
+	if (boot_cpu_has(X86_FEATURE_IBPB))
+		kvm_cpu_cap_set(X86_FEATURE_AMD_IBPB);
+	if (boot_cpu_has(X86_FEATURE_IBRS))
+		kvm_cpu_cap_set(X86_FEATURE_AMD_IBRS);
+	if (boot_cpu_has(X86_FEATURE_STIBP))
+		kvm_cpu_cap_set(X86_FEATURE_AMD_STIBP);
+	if (boot_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD))
+		kvm_cpu_cap_set(X86_FEATURE_AMD_SSBD);
+	if (!boot_cpu_has_bug(X86_BUG_SPEC_STORE_BYPASS))
+		kvm_cpu_cap_set(X86_FEATURE_AMD_SSB_NO);
+	/*
+	 * The preference is to use SPEC CTRL MSR instead of the
+	 * VIRT_SPEC MSR.
+	 */
+	if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) &&
+	    !boot_cpu_has(X86_FEATURE_AMD_SSBD))
+		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
+
 	/*
 	 * Hide all SVM features by default, SVM will set the cap bits for
 	 * features it emulates and/or exposes for L1.
@@ -492,9 +528,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 	case 1:
 		cpuid_entry_override(entry, CPUID_1_EDX);
 		cpuid_entry_override(entry, CPUID_1_ECX);
-		/* we support x2apic emulation even if host does not support
-		 * it since we emulate x2apic in software */
-		cpuid_entry_set(entry, X86_FEATURE_X2APIC);
 		break;
 	case 2:
 		/*
@@ -540,17 +573,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		cpuid_entry_override(entry, CPUID_7_ECX);
 		cpuid_entry_override(entry, CPUID_7_EDX);
 
-		/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
-		cpuid_entry_set(entry, X86_FEATURE_TSC_ADJUST);
-		cpuid_entry_set(entry, X86_FEATURE_ARCH_CAPABILITIES);
-
-		if (boot_cpu_has(X86_FEATURE_IBPB) && boot_cpu_has(X86_FEATURE_IBRS))
-			cpuid_entry_set(entry, X86_FEATURE_SPEC_CTRL);
-		if (boot_cpu_has(X86_FEATURE_STIBP))
-			cpuid_entry_set(entry, X86_FEATURE_INTEL_STIBP);
-		if (boot_cpu_has(X86_FEATURE_AMD_SSBD))
-			cpuid_entry_set(entry, X86_FEATURE_SPEC_CTRL_SSBD);
-
 		/* KVM only supports 0x7.0 and 0x7.1, capped above via min(). */
 		if (entry->eax == 1) {
 			entry = do_host_cpuid(array, function, 1);
@@ -722,28 +744,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		entry->eax = g_phys_as | (virt_as << 8);
 		entry->edx = 0;
 		cpuid_entry_override(entry, CPUID_8000_0008_EBX);
-		/*
-		 * AMD has separate bits for each SPEC_CTRL bit.
-		 * arch/x86/kernel/cpu/bugs.c is kind enough to
-		 * record that in cpufeatures so use them.
-		 */
-		if (boot_cpu_has(X86_FEATURE_IBPB))
-			cpuid_entry_set(entry, X86_FEATURE_AMD_IBPB);
-		if (boot_cpu_has(X86_FEATURE_IBRS))
-			cpuid_entry_set(entry, X86_FEATURE_AMD_IBRS);
-		if (boot_cpu_has(X86_FEATURE_STIBP))
-			cpuid_entry_set(entry, X86_FEATURE_AMD_STIBP);
-		if (boot_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD))
-			cpuid_entry_set(entry, X86_FEATURE_AMD_SSBD);
-		if (!boot_cpu_has_bug(X86_BUG_SPEC_STORE_BYPASS))
-			cpuid_entry_set(entry, X86_FEATURE_AMD_SSB_NO);
-		/*
-		 * The preference is to use SPEC CTRL MSR instead of the
-		 * VIRT_SPEC MSR.
-		 */
-		if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) &&
-		    !boot_cpu_has(X86_FEATURE_AMD_SSBD))
-			cpuid_entry_set(entry, X86_FEATURE_VIRT_SSBD);
 		break;
 	}
 	case 0x80000019:
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 964331106e9a..d351007eb7f9 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1377,6 +1377,11 @@ static __init void svm_set_cpu_caps(void)
 	if (nested)
 		kvm_cpu_cap_set(X86_FEATURE_SVM);
 
+	/* CPUID 0x80000008 */
+	if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) ||
+	    boot_cpu_has(X86_FEATURE_AMD_SSBD))
+		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
+
 	/* CPUID 0x8000000A */
 	/* Support next_rip if host supports it */
 	kvm_cpu_cap_check_and_set(X86_FEATURE_NRIPS);
@@ -6047,22 +6052,9 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
 					 APICV_INHIBIT_REASON_NESTED);
 }
 
-/*
- * Vendor specific emulation must be handled via ->set_supported_cpuid(), not
- * svm_set_cpu_caps(), as capabilities configured during hardware_setup() are
- * masked against hardware/kernel support, i.e. they'd be lost.
- *
- * Note, setting a flag based on a *different* feature, e.g. setting VIRT_SSBD
- * if LS_CFG_SSBD or AMD_SSBD is supported, is effectively emulation.
- */
 static void svm_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
 {
 	switch (entry->function) {
-	case 0x80000008:
-		if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) ||
-		    boot_cpu_has(X86_FEATURE_AMD_SSBD))
-			cpuid_entry_set(entry, X86_FEATURE_VIRT_SSBD);
-		break;
 	case 0x8000000A:
 		entry->eax = 1; /* SVM revision 1 */
 		entry->ebx = 8; /* Lets support 8 ASIDs in case we add proper
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index be2aecda733b..d5a5e8f987c8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7119,25 +7119,9 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
 	}
 }
 
-/*
- * Vendor specific emulation must be handled via ->set_supported_cpuid(), not
- * vmx_set_cpu_caps(), as capabilities configured during hardware_setup() are
- * masked against hardware/kernel support, i.e. they'd be lost.
- */
 static void vmx_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
 {
-	switch (entry->function) {
-	case 0x7:
-		/*
-		 * UMIP needs to be manually set even though vmx_set_cpu_caps()
-		 * also sets UMIP since do_host_cpuid() will drop it.
-		 */
-		if (vmx_umip_emulated())
-			cpuid_entry_set(entry, X86_FEATURE_UMIP);
-		break;
-	default:
-		break;
-	}
+
 }
 
 static __init void vmx_set_cpu_caps(void)
-- 
2.24.1

