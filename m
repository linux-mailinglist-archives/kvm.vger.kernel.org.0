Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 677F514D3DC
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 00:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbgA2Xr3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 18:47:29 -0500
Received: from mga06.intel.com ([134.134.136.31]:46690 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727179AbgA2Xqs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 18:46:48 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2020 15:46:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,379,1574150400"; 
   d="scan'208";a="309551743"
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
Subject: [PATCH 17/26] KVM: x86: Handle MPX CPUID adjustment in vendor code
Date:   Wed, 29 Jan 2020 15:46:31 -0800
Message-Id: <20200129234640.8147-18-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200129234640.8147-1-sean.j.christopherson@intel.com>
References: <20200129234640.8147-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the MPX CPUID adjustments into vendor code to eliminate an instance
of the undesirable "unsigned f_* = *_supported ? F(*) : 0" pattern in
the common CPUID handling code.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c   |  3 +--
 arch/x86/kvm/svm.c     |  3 +++
 arch/x86/kvm/vmx/vmx.c | 14 ++++++++++++--
 3 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 2d75410092e6..aa03dc665a44 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -322,7 +322,6 @@ static int __do_cpuid_func_emulated(struct kvm_cpuid_entry2 *entry,
 static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry, int index)
 {
 	unsigned f_invpcid = kvm_x86_ops->invpcid_supported() ? F(INVPCID) : 0;
-	unsigned f_mpx = kvm_mpx_supported() ? F(MPX) : 0;
 	unsigned f_umip = kvm_x86_ops->umip_emulated() ? F(UMIP) : 0;
 	unsigned f_intel_pt = kvm_x86_ops->pt_supported() ? F(INTEL_PT) : 0;
 	unsigned f_la57;
@@ -331,7 +330,7 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry, int index)
 	/* cpuid 7.0.ebx */
 	const u32 kvm_cpuid_7_0_ebx_x86_features =
 		F(FSGSBASE) | F(BMI1) | F(HLE) | F(AVX2) | F(SMEP) |
-		F(BMI2) | F(ERMS) | f_invpcid | F(RTM) | f_mpx | F(RDSEED) |
+		F(BMI2) | F(ERMS) | f_invpcid | F(RTM) | F(MPX) | F(RDSEED) |
 		F(ADX) | F(SMAP) | F(AVX512IFMA) | F(AVX512F) | F(AVX512PF) |
 		F(AVX512ER) | F(AVX512CD) | F(CLFLUSHOPT) | F(CLWB) | F(AVX512DQ) |
 		F(SHA_NI) | F(AVX512BW) | F(AVX512VL) | f_intel_pt;
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index fee2af01ba21..f64c2c1f9d1f 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -6059,6 +6059,9 @@ static void svm_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
 		if (avic)
 			cpuid_entry_clear(entry, X86_FEATURE_X2APIC);
 		break;
+	case 0x7:
+		cpuid_entry_clear(entry, X86_FEATURE_MPX);
+		break;
 	case 0x80000001:
 		if (nested)
 			cpuid_entry_set(entry, X86_FEATURE_SVM);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d21b2eccf3fe..f33bf519690e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7136,8 +7136,18 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
 
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
+		if (!kvm_mpx_supported())
+			cpuid_entry_clear(entry, X86_FEATURE_MPX);
+		break;
+	default:
+		break;
+	}
 }
 
 static void vmx_request_immediate_exit(struct kvm_vcpu *vcpu)
-- 
2.24.1

