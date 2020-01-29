Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E247414D3DB
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 00:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727339AbgA2Xr3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 18:47:29 -0500
Received: from mga06.intel.com ([134.134.136.31]:46692 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727180AbgA2Xqs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 18:46:48 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2020 15:46:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,379,1574150400"; 
   d="scan'208";a="309551747"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga001.jf.intel.com with ESMTP; 29 Jan 2020 15:46:44 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 18/26] KVM: x86: Handle INVPCID CPUID adjustment in vendor code
Date:   Wed, 29 Jan 2020 15:46:32 -0800
Message-Id: <20200129234640.8147-19-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200129234640.8147-1-sean.j.christopherson@intel.com>
References: <20200129234640.8147-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the INVPCID CPUID adjustments into vendor code to eliminate an
instance of the undesirable "unsigned f_* = *_supported ? F(*) : 0"
pattern in the common CPUID handling code.  Drop ->invpcid_supported()
since CPUID adjustment was the only user.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/cpuid.c            |  3 +--
 arch/x86/kvm/svm.c              |  7 +------
 arch/x86/kvm/vmx/vmx.c          | 10 +++-------
 4 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 39ee83f42935..b9c871c03bf5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1145,7 +1145,6 @@ struct kvm_x86_ops {
 	u64 (*get_mt_mask)(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
 	int (*get_lpage_level)(void);
 	bool (*rdtscp_supported)(void);
-	bool (*invpcid_supported)(void);
 
 	void (*set_tdp_cr3)(struct kvm_vcpu *vcpu, unsigned long cr3);
 
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index aa03dc665a44..07526b81658e 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -321,7 +321,6 @@ static int __do_cpuid_func_emulated(struct kvm_cpuid_entry2 *entry,
 
 static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry, int index)
 {
-	unsigned f_invpcid = kvm_x86_ops->invpcid_supported() ? F(INVPCID) : 0;
 	unsigned f_umip = kvm_x86_ops->umip_emulated() ? F(UMIP) : 0;
 	unsigned f_intel_pt = kvm_x86_ops->pt_supported() ? F(INTEL_PT) : 0;
 	unsigned f_la57;
@@ -330,7 +329,7 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry, int index)
 	/* cpuid 7.0.ebx */
 	const u32 kvm_cpuid_7_0_ebx_x86_features =
 		F(FSGSBASE) | F(BMI1) | F(HLE) | F(AVX2) | F(SMEP) |
-		F(BMI2) | F(ERMS) | f_invpcid | F(RTM) | F(MPX) | F(RDSEED) |
+		F(BMI2) | F(ERMS) | F(INVPCID) | F(RTM) | F(MPX) | F(RDSEED) |
 		F(ADX) | F(SMAP) | F(AVX512IFMA) | F(AVX512F) | F(AVX512PF) |
 		F(AVX512ER) | F(AVX512CD) | F(CLFLUSHOPT) | F(CLWB) | F(AVX512DQ) |
 		F(SHA_NI) | F(AVX512BW) | F(AVX512VL) | f_intel_pt;
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index f64c2c1f9d1f..4ea530ff6a0c 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -6061,6 +6061,7 @@ static void svm_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
 		break;
 	case 0x7:
 		cpuid_entry_clear(entry, X86_FEATURE_MPX);
+		cpuid_entry_clear(entry, X86_FEATURE_INVPCID);
 		break;
 	case 0x80000001:
 		if (nested)
@@ -6099,11 +6100,6 @@ static bool svm_rdtscp_supported(void)
 	return boot_cpu_has(X86_FEATURE_RDTSCP);
 }
 
-static bool svm_invpcid_supported(void)
-{
-	return false;
-}
-
 static bool svm_xsaves_supported(void)
 {
 	return boot_cpu_has(X86_FEATURE_XSAVES);
@@ -7485,7 +7481,6 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.cpuid_update = svm_cpuid_update,
 
 	.rdtscp_supported = svm_rdtscp_supported,
-	.invpcid_supported = svm_invpcid_supported,
 	.xsaves_supported = svm_xsaves_supported,
 	.umip_emulated = svm_umip_emulated,
 	.pt_supported = svm_pt_supported,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f33bf519690e..14e5031772e5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1656,11 +1656,6 @@ static bool vmx_rdtscp_supported(void)
 	return cpu_has_vmx_rdtscp();
 }
 
-static bool vmx_invpcid_supported(void)
-{
-	return cpu_has_vmx_invpcid();
-}
-
 /*
  * Swap MSR entry in host/guest MSR entry array.
  */
@@ -4071,7 +4066,7 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
 		}
 	}
 
-	if (vmx_invpcid_supported()) {
+	if (cpu_has_vmx_invpcid()) {
 		/* Exposing INVPCID only when PCID is exposed */
 		bool invpcid_enabled =
 			guest_cpuid_has(vcpu, X86_FEATURE_INVPCID) &&
@@ -7144,6 +7139,8 @@ static void vmx_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
 	case 0x7:
 		if (!kvm_mpx_supported())
 			cpuid_entry_clear(entry, X86_FEATURE_MPX);
+		if (!cpu_has_vmx_invpcid())
+			cpuid_entry_clear(entry, X86_FEATURE_INVPCID);
 		break;
 	default:
 		break;
@@ -7885,7 +7882,6 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.cpuid_update = vmx_cpuid_update,
 
 	.rdtscp_supported = vmx_rdtscp_supported,
-	.invpcid_supported = vmx_invpcid_supported,
 
 	.set_supported_cpuid = vmx_set_supported_cpuid,
 
-- 
2.24.1

