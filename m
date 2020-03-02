Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 850291768B1
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 00:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbgCBX6o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 18:58:44 -0500
Received: from mga02.intel.com ([134.134.136.20]:25519 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727491AbgCBX53 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 18:57:29 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 15:57:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="243384728"
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
Subject: [PATCH v2 35/66] KVM: x86: Handle Intel PT CPUID adjustment in VMX code
Date:   Mon,  2 Mar 2020 15:56:38 -0800
Message-Id: <20200302235709.27467-36-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302235709.27467-1-sean.j.christopherson@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the Processor Trace CPUID adjustment into VMX code to eliminate
an instance of the undesirable "unsigned f_* = *_supported ? F(*) : 0"
pattern in the common CPUID handling code, and to pave the way toward
eventually removing ->pt_supported().

No functional change intended.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.c   | 3 +--
 arch/x86/kvm/vmx/vmx.c | 3 +++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index f39efc9d640b..84b9a488a443 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -339,7 +339,6 @@ static int __do_cpuid_func_emulated(struct kvm_cpuid_array *array, u32 func)
 
 static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry)
 {
-	unsigned f_intel_pt = kvm_x86_ops->pt_supported() ? F(INTEL_PT) : 0;
 	unsigned f_la57;
 
 	/* cpuid 7.0.ebx */
@@ -348,7 +347,7 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry)
 		F(BMI2) | F(ERMS) | 0 /*INVPCID*/ | F(RTM) | 0 /*MPX*/ | F(RDSEED) |
 		F(ADX) | F(SMAP) | F(AVX512IFMA) | F(AVX512F) | F(AVX512PF) |
 		F(AVX512ER) | F(AVX512CD) | F(CLFLUSHOPT) | F(CLWB) | F(AVX512DQ) |
-		F(SHA_NI) | F(AVX512BW) | F(AVX512VL) | f_intel_pt;
+		F(SHA_NI) | F(AVX512BW) | F(AVX512VL) | 0 /*INTEL_PT*/;
 
 	/* cpuid 7.0.ecx*/
 	const u32 kvm_cpuid_7_0_ecx_x86_features =
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3bcb09b5efac..1a4ac20797a4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7131,6 +7131,9 @@ static void vmx_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
 			cpuid_entry_set(entry, X86_FEATURE_MPX);
 		if (boot_cpu_has(X86_FEATURE_INVPCID) && cpu_has_vmx_invpcid())
 			cpuid_entry_set(entry, X86_FEATURE_INVPCID);
+		if (boot_cpu_has(X86_FEATURE_INTEL_PT) &&
+		    vmx_pt_mode_is_host_guest())
+			cpuid_entry_set(entry, X86_FEATURE_INTEL_PT);
 		if (vmx_umip_emulated())
 			cpuid_entry_set(entry, X86_FEATURE_UMIP);
 
-- 
2.24.1

