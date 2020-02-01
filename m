Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC7E14F9B0
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2020 19:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727223AbgBASwb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Feb 2020 13:52:31 -0500
Received: from mga01.intel.com ([192.55.52.88]:57288 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727102AbgBASw3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Feb 2020 13:52:29 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Feb 2020 10:52:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,390,1574150400"; 
   d="scan'208";a="248075547"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 01 Feb 2020 10:52:26 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 39/61] KVM: SVM: Convert feature updates from CPUID to KVM cpu caps
Date:   Sat,  1 Feb 2020 10:51:56 -0800
Message-Id: <20200201185218.24473-40-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200201185218.24473-1-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the recently introduced KVM CPU caps to propagate SVM-only (kernel)
settings to supported CPUID flags.

Note, setting a flag based on a *different* feature is effectively
emulation, and so must be done at runtime via ->set_supported_cpuid().

Opportunistically add a technically unnecessary break and fix an
indentation issue in svm_set_supported_cpuid().

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/svm.c | 40 +++++++++++++++++++++++-----------------
 1 file changed, 23 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 630520f8adfa..f98a192459f7 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1350,6 +1350,25 @@ static __init void svm_adjust_mmio_mask(void)
 	kvm_mmu_set_mmio_spte_mask(mask, mask, PT_WRITABLE_MASK | PT_USER_MASK);
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
@@ -1462,6 +1481,8 @@ static __init int svm_hardware_setup(void)
 			pr_info("Virtual GIF supported\n");
 	}
 
+	svm_set_cpu_caps();
+
 	return 0;
 
 err:
@@ -6033,17 +6054,9 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
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
@@ -6053,14 +6066,7 @@ static void svm_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
 		entry->ecx = 0; /* Reserved */
 		entry->edx = 0; /* Per default do not support any
 				   additional features */
-
-		/* Support next_rip if host supports it */
-		if (boot_cpu_has(X86_FEATURE_NRIPS))
-			cpuid_entry_set(entry, X86_FEATURE_NRIPS);
-
-		/* Support NPT for the guest if enabled */
-		if (npt_enabled)
-			cpuid_entry_set(entry, X86_FEATURE_NPT);
+		break;
 	}
 }
 
-- 
2.24.1

