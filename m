Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E87F630DC3B
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 15:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232713AbhBCOHL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 09:07:11 -0500
Received: from mga06.intel.com ([134.134.136.31]:50302 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232569AbhBCOG5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 09:06:57 -0500
IronPort-SDR: gUkjARQ9dLSVzq0CHyo477+/7v7N51NOf8XZbHH8HKWhnOTZdbUsLu9PrQXqTlV6ZB0t7oHFaF
 ULLKnYxzkNRw==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="242555134"
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="242555134"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 06:03:54 -0800
IronPort-SDR: C3doJmNYuXbGOy+oZ4nO3lskPms/uDl+mx+Xy4Uho6Fm4uWlDl6VRCmDUn1xCrecBTqm43NLYE
 OfUY3VVq76MA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="371490702"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by fmsmga008.fm.intel.com with ESMTP; 03 Feb 2021 06:03:52 -0800
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/4] KVM: x86: Expose Architectural LBR CPUID and its XSAVES bit
Date:   Wed,  3 Feb 2021 21:57:14 +0800
Message-Id: <20210203135714.318356-5-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210203135714.318356-1-like.xu@linux.intel.com>
References: <20210203135714.318356-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If CPUID.(EAX=07H, ECX=0):EDX[19] is exposed to 1, the KVM supports Arch
LBRs and CPUID leaf 01CH indicates details of the Arch LBRs capabilities.
As the first step, KVM only exposes the current LBR depth on the host for
guest, which is likely to be the maximum supported value on the host.

If KVM supports XSAVES, the CPUID.(EAX=0DH, ECX=1):EDX:ECX[bit 15]
is also exposed to 1, which means the availability of support for Arch
LBR configuration state save and restore. When available, guest software
operating at CPL=0 can use XSAVES/XRSTORS manage supervisor state
component Arch LBR for own purposes once IA32_XSS [bit 15] is set.
XSAVE support for Arch LBRs is enumerated in CPUID.(EAX=0DH, ECX=0FH).

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/cpuid.c   | 23 +++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c |  2 ++
 arch/x86/kvm/x86.c     | 10 +++++++++-
 3 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 944f518ca91b..900149eec42d 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -778,6 +778,29 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			entry->edx = 0;
 		}
 		break;
+	/* Architectural LBR */
+	case 0x1c:
+	{
+		u64 lbr_depth_mask = 0;
+
+		if (!kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR)) {
+			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
+			break;
+		}
+
+		/*
+		 * KVM only exposes the maximum supported depth,
+		 * which is also the fixed value used on the host.
+		 *
+		 * KVM doesn't allow VMM user sapce to adjust depth
+		 * per guest, because the guest LBR emulation depends
+		 * on the implementation of the host LBR driver.
+		 */
+		lbr_depth_mask = 1UL << fls(entry->eax & 0xff);
+		entry->eax &= ~0xff;
+		entry->eax |= lbr_depth_mask;
+		break;
+	}
 	/* Intel PT */
 	case 0x14:
 		if (!kvm_cpu_cap_has(X86_FEATURE_INTEL_PT)) {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9ddf0a14d75c..c22175d9564e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7498,6 +7498,8 @@ static __init void vmx_set_cpu_caps(void)
 		kvm_cpu_cap_check_and_set(X86_FEATURE_INVPCID);
 	if (vmx_pt_mode_is_host_guest())
 		kvm_cpu_cap_check_and_set(X86_FEATURE_INTEL_PT);
+	if (cpu_has_vmx_arch_lbr())
+		kvm_cpu_cap_check_and_set(X86_FEATURE_ARCH_LBR);
 
 	if (vmx_umip_emulated())
 		kvm_cpu_cap_set(X86_FEATURE_UMIP);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 667d0042d0b7..107f2e72f526 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10385,8 +10385,16 @@ int kvm_arch_hardware_setup(void *opaque)
 
 	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
 		supported_xss = 0;
-	else
+	else {
 		supported_xss &= host_xss;
+		/*
+		 * The host doesn't always set ARCH_LBR bit to hoss_xss since this
+		 * Arch_LBR component is used on demand in the Arch LBR driver.
+		 * Check e649b3f0188f "Support dynamic supervisor feature for LBR".
+		 */
+		if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
+			supported_xss |= XFEATURE_MASK_LBR;
+	}
 
 	/* Update CET features now that supported_xss is finalized. */
 	if (!kvm_cet_supported()) {
-- 
2.29.2

