Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E19A514D3D1
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 00:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbgA2Xqv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jan 2020 18:46:51 -0500
Received: from mga06.intel.com ([134.134.136.31]:46692 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727165AbgA2Xqu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jan 2020 18:46:50 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2020 15:46:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,379,1574150400"; 
   d="scan'208";a="309551761"
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
Subject: [PATCH 23/26] KVM: x86: Handle Intel PT CPUID adjustment in vendor code
Date:   Wed, 29 Jan 2020 15:46:37 -0800
Message-Id: <20200129234640.8147-24-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200129234640.8147-1-sean.j.christopherson@intel.com>
References: <20200129234640.8147-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the Processor Trace CPUID adjustment into vendor code to eliminate
an instance of the undesirable "unsigned f_* = *_supported ? F(*) : 0"
pattern in the common CPUID handling code, and to pave the way toward
eventually removing ->pt_supported().

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c   | 3 +--
 arch/x86/kvm/svm.c     | 1 +
 arch/x86/kvm/vmx/vmx.c | 2 ++
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 75971c254b4d..eb61a1d83598 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -321,7 +321,6 @@ static int __do_cpuid_func_emulated(struct kvm_cpuid_entry2 *entry,
 
 static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry, int index)
 {
-	unsigned f_intel_pt = kvm_x86_ops->pt_supported() ? F(INTEL_PT) : 0;
 	unsigned f_la57;
 
 	/* cpuid 7.0.ebx */
@@ -330,7 +329,7 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry, int index)
 		F(BMI2) | F(ERMS) | F(INVPCID) | F(RTM) | F(MPX) | F(RDSEED) |
 		F(ADX) | F(SMAP) | F(AVX512IFMA) | F(AVX512F) | F(AVX512PF) |
 		F(AVX512ER) | F(AVX512CD) | F(CLFLUSHOPT) | F(CLWB) | F(AVX512DQ) |
-		F(SHA_NI) | F(AVX512BW) | F(AVX512VL) | f_intel_pt;
+		F(SHA_NI) | F(AVX512BW) | F(AVX512VL) | F(INTEL_PT);
 
 	/* cpuid 7.0.ecx*/
 	const u32 kvm_cpuid_7_0_ecx_x86_features =
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 7d6f46399e5a..350cdf91a576 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -6066,6 +6066,7 @@ static void svm_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
 		cpuid_entry_clear(entry, X86_FEATURE_PKU);
 		cpuid_entry_clear(entry, X86_FEATURE_MPX);
 		cpuid_entry_clear(entry, X86_FEATURE_INVPCID);
+		cpuid_entry_clear(entry, X86_FEATURE_INTEL_PT);
 		break;
 	case 0x80000001:
 		if (nested)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 941ac7296735..35134dbed2f0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7149,6 +7149,8 @@ static void vmx_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
 			cpuid_entry_clear(entry, X86_FEATURE_MPX);
 		if (!cpu_has_vmx_invpcid())
 			cpuid_entry_clear(entry, X86_FEATURE_INVPCID);
+		if (!vmx_pt_mode_is_host_guest())
+			cpuid_entry_clear(entry, X86_FEATURE_INTEL_PT);
 
 		if (vmx_umip_emulated())
 			cpuid_entry_set(entry, X86_FEATURE_UMIP);
-- 
2.24.1

