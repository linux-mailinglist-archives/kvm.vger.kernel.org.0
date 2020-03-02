Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 848FA1768B3
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 00:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727465AbgCBX6w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 18:58:52 -0500
Received: from mga02.intel.com ([134.134.136.20]:25524 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727479AbgCBX53 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 18:57:29 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 15:57:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="243384716"
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
Subject: [PATCH v2 31/66] KVM: x86: Handle INVPCID CPUID adjustment in VMX code
Date:   Mon,  2 Mar 2020 15:56:34 -0800
Message-Id: <20200302235709.27467-32-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302235709.27467-1-sean.j.christopherson@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the INVPCID CPUID adjustments into VMX to eliminate an instance of
the undesirable "unsigned f_* = *_supported ? F(*) : 0" pattern in the
common CPUID handling code.  Drop ->invpcid_supported(), CPUID
adjustment was the only user.

No functional change intended.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/cpuid.c            |  3 +--
 arch/x86/kvm/svm.c              |  6 ------
 arch/x86/kvm/vmx/vmx.c          | 10 +++-------
 4 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b0bd6bd3838a..96ea76e0a69f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1150,7 +1150,6 @@ struct kvm_x86_ops {
 	u64 (*get_mt_mask)(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
 	int (*get_lpage_level)(void);
 	bool (*rdtscp_supported)(void);
-	bool (*invpcid_supported)(void);
 
 	void (*set_tdp_cr3)(struct kvm_vcpu *vcpu, unsigned long cr3);
 
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 43f76b36f461..983eec22d2f5 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -339,7 +339,6 @@ static int __do_cpuid_func_emulated(struct kvm_cpuid_array *array, u32 func)
 
 static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry)
 {
-	unsigned f_invpcid = kvm_x86_ops->invpcid_supported() ? F(INVPCID) : 0;
 	unsigned f_umip = kvm_x86_ops->umip_emulated() ? F(UMIP) : 0;
 	unsigned f_intel_pt = kvm_x86_ops->pt_supported() ? F(INTEL_PT) : 0;
 	unsigned f_la57;
@@ -348,7 +347,7 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry)
 	/* cpuid 7.0.ebx */
 	const u32 kvm_cpuid_7_0_ebx_x86_features =
 		F(FSGSBASE) | F(BMI1) | F(HLE) | F(AVX2) | F(SMEP) |
-		F(BMI2) | F(ERMS) | f_invpcid | F(RTM) | 0 /*MPX*/ | F(RDSEED) |
+		F(BMI2) | F(ERMS) | 0 /*INVPCID*/ | F(RTM) | 0 /*MPX*/ | F(RDSEED) |
 		F(ADX) | F(SMAP) | F(AVX512IFMA) | F(AVX512F) | F(AVX512PF) |
 		F(AVX512ER) | F(AVX512CD) | F(CLFLUSHOPT) | F(CLWB) | F(AVX512DQ) |
 		F(SHA_NI) | F(AVX512BW) | F(AVX512VL) | f_intel_pt;
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 728b90c1a68b..c0e0dd7acb1f 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -6071,11 +6071,6 @@ static bool svm_rdtscp_supported(void)
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
@@ -7456,7 +7451,6 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.cpuid_update = svm_cpuid_update,
 
 	.rdtscp_supported = svm_rdtscp_supported,
-	.invpcid_supported = svm_invpcid_supported,
 	.xsaves_supported = svm_xsaves_supported,
 	.umip_emulated = svm_umip_emulated,
 	.pt_supported = svm_pt_supported,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ef3a63ce8a6a..67958c27b7c0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1692,11 +1692,6 @@ static bool vmx_rdtscp_supported(void)
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
@@ -4094,7 +4089,7 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
 		}
 	}
 
-	if (vmx_invpcid_supported()) {
+	if (cpu_has_vmx_invpcid()) {
 		/* Exposing INVPCID only when PCID is exposed */
 		bool invpcid_enabled =
 			guest_cpuid_has(vcpu, X86_FEATURE_INVPCID) &&
@@ -7134,6 +7129,8 @@ static void vmx_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
 	case 0x7:
 		if (boot_cpu_has(X86_FEATURE_MPX) && kvm_mpx_supported())
 			cpuid_entry_set(entry, X86_FEATURE_MPX);
+		if (boot_cpu_has(X86_FEATURE_INVPCID) && cpu_has_vmx_invpcid())
+			cpuid_entry_set(entry, X86_FEATURE_INVPCID);
 		break;
 	default:
 		break;
@@ -7919,7 +7916,6 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.cpuid_update = vmx_cpuid_update,
 
 	.rdtscp_supported = vmx_rdtscp_supported,
-	.invpcid_supported = vmx_invpcid_supported,
 
 	.set_supported_cpuid = vmx_set_supported_cpuid,
 
-- 
2.24.1

