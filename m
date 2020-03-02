Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 744251768A9
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 00:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727767AbgCBX6e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 18:58:34 -0500
Received: from mga02.intel.com ([134.134.136.20]:25521 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727490AbgCBX5a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 18:57:30 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 15:57:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="243384722"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 02 Mar 2020 15:57:22 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 33/66] KVM: x86: Handle PKU CPUID adjustment in VMX code
Date:   Mon,  2 Mar 2020 15:56:36 -0800
Message-Id: <20200302235709.27467-34-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302235709.27467-1-sean.j.christopherson@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the setting of the PKU CPUID bit into VMX to eliminate an instance
of the undesirable "unsigned f_* = *_supported ? F(*) : 0" pattern in
the common CPUID handling code.  Drop ->pku_supported(), CPUID
adjustment was the only user.

Note, some AMD CPUs now support PKU, but SVM doesn't yet support
exposing it to a guest.

No functional change intended.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 1 -
 arch/x86/kvm/cpuid.c            | 5 -----
 arch/x86/kvm/svm.c              | 6 ------
 arch/x86/kvm/vmx/capabilities.h | 5 -----
 arch/x86/kvm/vmx/vmx.c          | 6 +++++-
 5 files changed, 5 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 96ea76e0a69f..449695788351 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1172,7 +1172,6 @@ struct kvm_x86_ops {
 	bool (*xsaves_supported)(void);
 	bool (*umip_emulated)(void);
 	bool (*pt_supported)(void);
-	bool (*pku_supported)(void);
 
 	int (*check_nested_events)(struct kvm_vcpu *vcpu, bool external_intr);
 	void (*request_immediate_exit)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 35451ea0a690..9c2e20a76ca8 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -341,7 +341,6 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry)
 {
 	unsigned f_intel_pt = kvm_x86_ops->pt_supported() ? F(INTEL_PT) : 0;
 	unsigned f_la57;
-	unsigned f_pku = kvm_x86_ops->pku_supported() ? F(PKU) : 0;
 
 	/* cpuid 7.0.ebx */
 	const u32 kvm_cpuid_7_0_ebx_x86_features =
@@ -381,10 +380,6 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry)
 		cpuid_entry_mask(entry, CPUID_7_ECX);
 		/* Set LA57 based on hardware capability. */
 		entry->ecx |= f_la57;
-		entry->ecx |= f_pku;
-		/* PKU is not yet implemented for shadow paging. */
-		if (!tdp_enabled || !boot_cpu_has(X86_FEATURE_OSPKE))
-			cpuid_entry_clear(entry, X86_FEATURE_PKU);
 
 		entry->edx &= kvm_cpuid_7_0_edx_x86_features;
 		cpuid_entry_mask(entry, CPUID_7_EDX);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index c0e0dd7acb1f..0725a67e3480 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -6091,11 +6091,6 @@ static bool svm_has_wbinvd_exit(void)
 	return true;
 }
 
-static bool svm_pku_supported(void)
-{
-	return false;
-}
-
 #define PRE_EX(exit)  { .exit_code = (exit), \
 			.stage = X86_ICPT_PRE_EXCEPT, }
 #define POST_EX(exit) { .exit_code = (exit), \
@@ -7454,7 +7449,6 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.xsaves_supported = svm_xsaves_supported,
 	.umip_emulated = svm_umip_emulated,
 	.pt_supported = svm_pt_supported,
-	.pku_supported = svm_pku_supported,
 
 	.set_supported_cpuid = svm_set_supported_cpuid,
 
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index c00e26570198..8903475f751e 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -146,11 +146,6 @@ static inline bool vmx_umip_emulated(void)
 		SECONDARY_EXEC_DESC;
 }
 
-static inline bool vmx_pku_supported(void)
-{
-	return boot_cpu_has(X86_FEATURE_PKU);
-}
-
 static inline bool cpu_has_vmx_rdtscp(void)
 {
 	return vmcs_config.cpu_based_2nd_exec_ctrl &
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f4efc45810b8..49a1cac7bf0c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7133,6 +7133,11 @@ static void vmx_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
 			cpuid_entry_set(entry, X86_FEATURE_INVPCID);
 		if (vmx_umip_emulated())
 			cpuid_entry_set(entry, X86_FEATURE_UMIP);
+
+		/* PKU is not yet implemented for shadow paging. */
+		if (enable_ept && boot_cpu_has(X86_FEATURE_PKU) &&
+		    boot_cpu_has(X86_FEATURE_OSPKE))
+			cpuid_entry_set(entry, X86_FEATURE_PKU);
 		break;
 	default:
 		break;
@@ -7933,7 +7938,6 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.xsaves_supported = vmx_xsaves_supported,
 	.umip_emulated = vmx_umip_emulated,
 	.pt_supported = vmx_pt_supported,
-	.pku_supported = vmx_pku_supported,
 
 	.request_immediate_exit = vmx_request_immediate_exit,
 
-- 
2.24.1

