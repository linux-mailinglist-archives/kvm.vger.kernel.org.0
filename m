Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AADB32C64B
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:02:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355414AbhCDA2S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:28:18 -0500
Received: from mga11.intel.com ([192.55.52.93]:43761 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241878AbhCCOOa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Mar 2021 09:14:30 -0500
IronPort-SDR: 96ek2tpqwODshKPvmeQHkuRjGGibdrf+T3Vfh+pnXDsoOzeCVOWLMsOLldQRA05YEEYCWV2Ahm
 a3wlyxTSVQ9w==
X-IronPort-AV: E=McAfee;i="6000,8403,9911"; a="183819022"
X-IronPort-AV: E=Sophos;i="5.81,220,1610438400"; 
   d="scan'208";a="183819022"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 06:05:44 -0800
IronPort-SDR: hDP6SEP+qjwHtBulaGZZczBYOuxCzPRVu4iSzBF4IThrGP1R8b1m42OvJOTEYo89RaNPbzNfM8
 Ug9Etm5oG91Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,220,1610438400"; 
   d="scan'208";a="399729458"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by fmsmga008.fm.intel.com with ESMTP; 03 Mar 2021 06:05:40 -0800
From:   Like Xu <like.xu@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>, wei.w.wang@intel.com,
        Borislav Petkov <bp@alien8.de>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v3 8/9] KVM: x86: Expose Architectural LBR CPUID leaf
Date:   Wed,  3 Mar 2021 21:57:54 +0800
Message-Id: <20210303135756.1546253-9-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210303135756.1546253-1-like.xu@linux.intel.com>
References: <20210303135756.1546253-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If CPUID.(EAX=07H, ECX=0):EDX[19] is set to 1, then KVM supports Arch
LBRs and CPUID leaf 01CH indicates details of the Arch LBRs capabilities.
Currently, KVM only supports the current host LBR depth for guests,
which is also the maximum supported depth on the host.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/cpuid.c   | 25 ++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.c |  2 ++
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b4247f821277..4473324fe7be 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -450,7 +450,7 @@ void kvm_set_cpu_caps(void)
 		F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
 		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
 		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM) |
-		F(SERIALIZE) | F(TSXLDTRK) | F(AVX512_FP16)
+		F(SERIALIZE) | F(TSXLDTRK) | F(AVX512_FP16) | F(ARCH_LBR)
 	);
 
 	/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
@@ -805,6 +805,29 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 				goto out;
 		}
 		break;
+	/* Architectural LBR */
+	case 0x1c:
+	{
+		u64 lbr_depth_mask = entry->eax & 0xff;
+
+		if (!lbr_depth_mask || !kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR)) {
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
+		lbr_depth_mask = 1UL << (fls(lbr_depth_mask) - 1);
+		entry->eax &= ~0xff;
+		entry->eax |= lbr_depth_mask;
+		break;
+	}
 	case KVM_CPUID_SIGNATURE: {
 		static const char signature[12] = "KVMKVMKVM\0\0";
 		const u32 *sigptr = (const u32 *)signature;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2f307689a14b..034708a3df20 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7258,6 +7258,8 @@ static __init void vmx_set_cpu_caps(void)
 		kvm_cpu_cap_clear(X86_FEATURE_INVPCID);
 	if (vmx_pt_mode_is_host_guest())
 		kvm_cpu_cap_check_and_set(X86_FEATURE_INTEL_PT);
+	if (cpu_has_vmx_arch_lbr())
+		kvm_cpu_cap_check_and_set(X86_FEATURE_ARCH_LBR);
 
 	if (vmx_umip_emulated())
 		kvm_cpu_cap_set(X86_FEATURE_UMIP);
-- 
2.29.2

