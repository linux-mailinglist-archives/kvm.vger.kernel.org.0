Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB40377DD8
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 10:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbhEJIRo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 04:17:44 -0400
Received: from mga12.intel.com ([192.55.52.136]:42745 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230337AbhEJIRe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 04:17:34 -0400
IronPort-SDR: 515elyuTgXRH2YCqsahl5h4UYYMPoUiqAweyiWkreeUbzVD8j94yn8BsUshfWHkN6QSXDga1Ww
 MN9Gmdsuy8fg==
X-IronPort-AV: E=McAfee;i="6200,9189,9979"; a="178727788"
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; 
   d="scan'208";a="178727788"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2021 01:16:30 -0700
IronPort-SDR: hXKafvspW1pQBlUYORye/xXDDtkLRVELPqjZlCDcZwZHZa8vZrXkMc4KUB1pFS4DaYsVdA/5Qd
 PM4dSE0el0Vg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; 
   d="scan'208";a="408250895"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by orsmga002.jf.intel.com with ESMTP; 10 May 2021 01:16:28 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, weijiang.yang@intel.com,
        wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RESEND PATCH v4 06/10] KVM: x86: Expose Architectural LBR CPUID leaf
Date:   Mon, 10 May 2021 16:15:30 +0800
Message-Id: <20210510081535.94184-7-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510081535.94184-1-like.xu@linux.intel.com>
References: <20210510081535.94184-1-like.xu@linux.intel.com>
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
index 9a48f138832d..e7527b6cadb4 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -475,7 +475,7 @@ void kvm_set_cpu_caps(void)
 		F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
 		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
 		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM) |
-		F(SERIALIZE) | F(TSXLDTRK) | F(AVX512_FP16)
+		F(SERIALIZE) | F(TSXLDTRK) | F(AVX512_FP16) | F(ARCH_LBR)
 	);
 
 	/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
@@ -886,6 +886,29 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
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
index 74f0b302f4a2..f88c6e8f7a3a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7370,6 +7370,8 @@ static __init void vmx_set_cpu_caps(void)
 		kvm_cpu_cap_clear(X86_FEATURE_INVPCID);
 	if (vmx_pt_mode_is_host_guest())
 		kvm_cpu_cap_check_and_set(X86_FEATURE_INTEL_PT);
+	if (!cpu_has_vmx_arch_lbr())
+		kvm_cpu_cap_clear(X86_FEATURE_ARCH_LBR);
 
 	if (!enable_sgx) {
 		kvm_cpu_cap_clear(X86_FEATURE_SGX);
-- 
2.31.1

