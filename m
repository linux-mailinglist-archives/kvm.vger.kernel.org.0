Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D06DD176910
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 01:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727731AbgCCACY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 19:02:24 -0500
Received: from mga17.intel.com ([192.55.52.151]:37738 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727076AbgCBX5Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 18:57:24 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 15:57:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="243384713"
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
Subject: [PATCH v2 30/66] KVM: x86: Handle MPX CPUID adjustment in VMX code
Date:   Mon,  2 Mar 2020 15:56:33 -0800
Message-Id: <20200302235709.27467-31-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302235709.27467-1-sean.j.christopherson@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the MPX CPUID adjustments into VMX to eliminate an instance of the
undesirable "unsigned f_* = *_supported ? F(*) : 0" pattern in the
common CPUID handling code.

Note, to maintain existing behavior, VMX must manually check for kernel
support for MPX by querying boot_cpu_has(X86_FEATURE_MPX).  Previously,
do_cpuid_7_mask() masked MPX based on boot_cpu_data by invoking
cpuid_mask() on the associated cpufeatures word, but cpuid_mask() runs
prior to executing vmx_set_supported_cpuid().

No functional change intended.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c   |  3 +--
 arch/x86/kvm/vmx/vmx.c | 14 ++++++++++++--
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 04343c54a419..43f76b36f461 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -340,7 +340,6 @@ static int __do_cpuid_func_emulated(struct kvm_cpuid_array *array, u32 func)
 static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry)
 {
 	unsigned f_invpcid = kvm_x86_ops->invpcid_supported() ? F(INVPCID) : 0;
-	unsigned f_mpx = kvm_mpx_supported() ? F(MPX) : 0;
 	unsigned f_umip = kvm_x86_ops->umip_emulated() ? F(UMIP) : 0;
 	unsigned f_intel_pt = kvm_x86_ops->pt_supported() ? F(INTEL_PT) : 0;
 	unsigned f_la57;
@@ -349,7 +348,7 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry)
 	/* cpuid 7.0.ebx */
 	const u32 kvm_cpuid_7_0_ebx_x86_features =
 		F(FSGSBASE) | F(BMI1) | F(HLE) | F(AVX2) | F(SMEP) |
-		F(BMI2) | F(ERMS) | f_invpcid | F(RTM) | f_mpx | F(RDSEED) |
+		F(BMI2) | F(ERMS) | f_invpcid | F(RTM) | 0 /*MPX*/ | F(RDSEED) |
 		F(ADX) | F(SMAP) | F(AVX512IFMA) | F(AVX512F) | F(AVX512PF) |
 		F(AVX512ER) | F(AVX512CD) | F(CLFLUSHOPT) | F(CLWB) | F(AVX512DQ) |
 		F(SHA_NI) | F(AVX512BW) | F(AVX512VL) | f_intel_pt;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 44724e8d0b88..ef3a63ce8a6a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7126,8 +7126,18 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
 
 static void vmx_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
 {
-	if (entry->function == 1 && nested)
-		entry->ecx |= feature_bit(VMX);
+	switch (entry->function) {
+	case 0x1:
+		if (nested)
+			cpuid_entry_set(entry, X86_FEATURE_VMX);
+		break;
+	case 0x7:
+		if (boot_cpu_has(X86_FEATURE_MPX) && kvm_mpx_supported())
+			cpuid_entry_set(entry, X86_FEATURE_MPX);
+		break;
+	default:
+		break;
+	}
 }
 
 static void vmx_request_immediate_exit(struct kvm_vcpu *vcpu)
-- 
2.24.1

