Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFB291768A1
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 00:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727492AbgCBX6M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 18:58:12 -0500
Received: from mga02.intel.com ([134.134.136.20]:25519 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727512AbgCBX5b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 18:57:31 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 15:57:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="243384749"
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
Subject: [PATCH v2 42/66] KVM: x86: Add a helper to check kernel support when setting cpu cap
Date:   Mon,  2 Mar 2020 15:56:45 -0800
Message-Id: <20200302235709.27467-43-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302235709.27467-1-sean.j.christopherson@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a helper, kvm_cpu_cap_check_and_set(), to query boot_cpu_has() as
part of setting a KVM cpu capability.  VMX in particular has a number of
features that are dependent on both a VMCS capability and kernel
support.

No functional change intended.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/cpuid.h   |  6 ++++++
 arch/x86/kvm/svm.c     |  3 +--
 arch/x86/kvm/vmx/vmx.c | 18 ++++++++----------
 3 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index b899ba4bc918..b5155b8b4897 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -273,4 +273,10 @@ static __always_inline void kvm_cpu_cap_set(unsigned int x86_feature)
 	kvm_cpu_caps[x86_leaf] |= __feature_bit(x86_feature);
 }
 
+static __always_inline void kvm_cpu_cap_check_and_set(unsigned int x86_feature)
+{
+	if (boot_cpu_has(x86_feature))
+		kvm_cpu_cap_set(x86_feature);
+}
+
 #endif
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index a1317e72824d..d2516283f7db 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1379,8 +1379,7 @@ static __init void svm_set_cpu_caps(void)
 
 	/* CPUID 0x8000000A */
 	/* Support next_rip if host supports it */
-	if (boot_cpu_has(X86_FEATURE_NRIPS))
-		kvm_cpu_cap_set(X86_FEATURE_NRIPS);
+	kvm_cpu_cap_check_and_set(X86_FEATURE_NRIPS);
 
 	if (npt_enabled)
 		kvm_cpu_cap_set(X86_FEATURE_NPT);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 208a40e89a3f..a65b977f30d3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7143,18 +7143,16 @@ static __init void vmx_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_VMX);
 
 	/* CPUID 0x7 */
-	if (boot_cpu_has(X86_FEATURE_MPX) && kvm_mpx_supported())
-		kvm_cpu_cap_set(X86_FEATURE_MPX);
-	if (boot_cpu_has(X86_FEATURE_INVPCID) && cpu_has_vmx_invpcid())
-		kvm_cpu_cap_set(X86_FEATURE_INVPCID);
-	if (boot_cpu_has(X86_FEATURE_INTEL_PT) &&
-	    vmx_pt_mode_is_host_guest())
-		kvm_cpu_cap_set(X86_FEATURE_INTEL_PT);
+	if (kvm_mpx_supported())
+		kvm_cpu_cap_check_and_set(X86_FEATURE_MPX);
+	if (cpu_has_vmx_invpcid())
+		kvm_cpu_cap_check_and_set(X86_FEATURE_INVPCID);
+	if (vmx_pt_mode_is_host_guest())
+		kvm_cpu_cap_check_and_set(X86_FEATURE_INTEL_PT);
 
 	/* PKU is not yet implemented for shadow paging. */
-	if (enable_ept && boot_cpu_has(X86_FEATURE_PKU) &&
-	    boot_cpu_has(X86_FEATURE_OSPKE))
-		kvm_cpu_cap_set(X86_FEATURE_PKU);
+	if (enable_ept && boot_cpu_has(X86_FEATURE_OSPKE))
+		kvm_cpu_cap_check_and_set(X86_FEATURE_PKU);
 
 	/* CPUID 0xD.1 */
 	if (!vmx_xsaves_supported())
-- 
2.24.1

