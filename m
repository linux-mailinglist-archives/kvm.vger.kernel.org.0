Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A11E23406B
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 09:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731783AbgGaHqZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 03:46:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:55479 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731847AbgGaHqY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 03:46:24 -0400
IronPort-SDR: /dg0grk4nntUPv7mguLk2fvQ7aLsMSo+GXSXJVpRMTzRrdkSiV3C0oIzKSXyTCh3Iw8fqRIK0W
 ApCloWeW1PlA==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="149570546"
X-IronPort-AV: E=Sophos;i="5.75,417,1589266800"; 
   d="scan'208";a="149570546"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2020 00:46:23 -0700
IronPort-SDR: mTjKe2EyTrpcOAEWUYf7cP83Dco3zl414hR8QtrWi17ZOTT5X1fQZ5WtppiF9tmQlwf1kOTTSq
 RqnTgoZ4APRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,417,1589266800"; 
   d="scan'208";a="323160625"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga002.fm.intel.com with ESMTP; 31 Jul 2020 00:46:21 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, wei.w.wang@intel.com,
        linux-kernel@vger.kernel.org, Like Xu <like.xu@linux.intel.com>
Subject: [PATCH 6/6] KVM: x86: Expose Architectural LBR CPUID and its XSAVES bit
Date:   Fri, 31 Jul 2020 15:44:02 +0800
Message-Id: <20200731074402.8879-7-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200731074402.8879-1-like.xu@linux.intel.com>
References: <20200731074402.8879-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
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
 arch/x86/kvm/cpuid.c   | 19 +++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c |  2 ++
 arch/x86/kvm/x86.c     |  6 ++++++
 3 files changed, 27 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 7d92854082a1..578ef0719182 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -713,6 +713,25 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
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
+		lbr_depth_mask = 1UL << fls(entry->eax & 0xff);
+		/*
+		 * KVM only exposes the maximum supported depth,
+		 * which is also the value used by the host Arch LBR driver.
+		 */
+		entry->eax &= ~0xff;
+		entry->eax |= lbr_depth_mask;
+		break;
+	}
 	/* Intel PT */
 	case 0x14:
 		if (!kvm_cpu_cap_has(X86_FEATURE_INTEL_PT)) {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3843aebf4efb..98bad0dbfdf1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7409,6 +7409,8 @@ static __init void vmx_set_cpu_caps(void)
 		kvm_cpu_cap_check_and_set(X86_FEATURE_INVPCID);
 	if (vmx_pt_mode_is_host_guest())
 		kvm_cpu_cap_check_and_set(X86_FEATURE_INTEL_PT);
+	if (cpu_has_vmx_arch_lbr())
+		kvm_cpu_cap_check_and_set(X86_FEATURE_ARCH_LBR);
 
 	if (vmx_umip_emulated())
 		kvm_cpu_cap_set(X86_FEATURE_UMIP);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8a58d0355a99..4da3f9ee96a6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -184,6 +184,8 @@ static struct kvm_shared_msrs __percpu *shared_msrs;
 				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
 				| XFEATURE_MASK_PKRU)
 
+#define KVM_SUPPORTED_XSS_ARCH_LBR  (1ULL << 15)
+
 u64 __read_mostly host_efer;
 EXPORT_SYMBOL_GPL(host_efer);
 
@@ -9803,6 +9805,10 @@ int kvm_arch_hardware_setup(void *opaque)
 
 	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
 		supported_xss = 0;
+	else {
+		if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
+			supported_xss |= KVM_SUPPORTED_XSS_ARCH_LBR;
+	}
 
 #define __kvm_cpu_cap_has(UNUSED_, f) kvm_cpu_cap_has(f)
 	cr4_reserved_bits = __cr4_reserved_bits(__kvm_cpu_cap_has, UNUSED_);
-- 
2.21.3

