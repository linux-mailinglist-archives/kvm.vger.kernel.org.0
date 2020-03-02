Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3188017688C
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 00:57:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbgCBX5Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 18:57:25 -0500
Received: from mga17.intel.com ([192.55.52.151]:37739 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727083AbgCBX5Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 18:57:25 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 15:57:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="243384740"
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
Subject: [PATCH v2 39/66] KVM: SVM: Convert feature updates from CPUID to KVM cpu caps
Date:   Mon,  2 Mar 2020 15:56:42 -0800
Message-Id: <20200302235709.27467-40-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302235709.27467-1-sean.j.christopherson@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the recently introduced KVM CPU caps to propagate SVM-only (kernel)
settings to supported CPUID flags.

Note, there are a few subtleties:

  - Setting a flag based on a *different* feature is effectively
    emulation, and must be done at runtime via ->set_supported_cpuid().

  - CPUID 0x8000000A.EDX is a feature leaf that was previously not
    adjusted by kvm_cpu_cap_mask() because all features are hidden by
    default.

Opportunistically add a technically unnecessary break and fix an
indentation issue in svm_set_supported_cpuid().

No functional change intended.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c |  6 ++++++
 arch/x86/kvm/svm.c   | 51 +++++++++++++++++++++++++++-----------------
 2 files changed, 38 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index f0b6885d2415..e26644d8280b 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -376,6 +376,12 @@ void kvm_set_cpu_caps(void)
 		F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON)
 	);
 
+	/*
+	 * Hide all SVM features by default, SVM will set the cap bits for
+	 * features it emulates and/or exposes for L1.
+	 */
+	kvm_cpu_cap_mask(CPUID_8000_000A_EDX, 0);
+
 	kvm_cpu_cap_mask(CPUID_C000_0001_EDX,
 		F(XSTORE) | F(XSTORE_EN) | F(XCRYPT) | F(XCRYPT_EN) |
 		F(ACE2) | F(ACE2_EN) | F(PHE) | F(PHE_EN) |
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 0725a67e3480..8ce07f6ebe8e 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1367,6 +1367,25 @@ static void svm_hardware_teardown(void)
 	iopm_base = 0;
 }
 
+static __init void svm_set_cpu_caps(void)
+{
+	/* CPUID 0x1 */
+	if (avic)
+		kvm_cpu_cap_clear(X86_FEATURE_X2APIC);
+
+	/* CPUID 0x80000001 */
+	if (nested)
+		kvm_cpu_cap_set(X86_FEATURE_SVM);
+
+	/* CPUID 0x8000000A */
+	/* Support next_rip if host supports it */
+	if (boot_cpu_has(X86_FEATURE_NRIPS))
+		kvm_cpu_cap_set(X86_FEATURE_NRIPS);
+
+	if (npt_enabled)
+		kvm_cpu_cap_set(X86_FEATURE_NPT);
+}
+
 static __init int svm_hardware_setup(void)
 {
 	int cpu;
@@ -1479,6 +1498,8 @@ static __init int svm_hardware_setup(void)
 			pr_info("Virtual GIF supported\n");
 	}
 
+	svm_set_cpu_caps();
+
 	return 0;
 
 err:
@@ -6027,20 +6048,20 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
 					 APICV_INHIBIT_REASON_NESTED);
 }
 
+/*
+ * Vendor specific emulation must be handled via ->set_supported_cpuid(), not
+ * svm_set_cpu_caps(), as capabilities configured during hardware_setup() are
+ * masked against hardware/kernel support, i.e. they'd be lost.
+ *
+ * Note, setting a flag based on a *different* feature, e.g. setting VIRT_SSBD
+ * if LS_CFG_SSBD or AMD_SSBD is supported, is effectively emulation.
+ */
 static void svm_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
 {
 	switch (entry->function) {
-	case 0x1:
-		if (avic)
-			cpuid_entry_clear(entry, X86_FEATURE_X2APIC);
-		break;
-	case 0x80000001:
-		if (nested)
-			cpuid_entry_set(entry, X86_FEATURE_SVM);
-		break;
 	case 0x80000008:
 		if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) ||
-		     boot_cpu_has(X86_FEATURE_AMD_SSBD))
+		    boot_cpu_has(X86_FEATURE_AMD_SSBD))
 			cpuid_entry_set(entry, X86_FEATURE_VIRT_SSBD);
 		break;
 	case 0x8000000A:
@@ -6048,16 +6069,8 @@ static void svm_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
 		entry->ebx = 8; /* Lets support 8 ASIDs in case we add proper
 				   ASID emulation to nested SVM */
 		entry->ecx = 0; /* Reserved */
-		entry->edx = 0; /* Per default do not support any
-				   additional features */
-
-		/* Support next_rip if host supports it */
-		if (boot_cpu_has(X86_FEATURE_NRIPS))
-			cpuid_entry_set(entry, X86_FEATURE_NRIPS);
-
-		/* Support NPT for the guest if enabled */
-		if (npt_enabled)
-			cpuid_entry_set(entry, X86_FEATURE_NPT);
+		/* Note, 0x8000000A.EDX is managed via kvm_cpu_caps. */;
+		break;
 	}
 }
 
-- 
2.24.1

