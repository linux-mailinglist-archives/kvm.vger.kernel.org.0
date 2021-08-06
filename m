Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAA23E2422
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 09:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243863AbhHFHas (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 03:30:48 -0400
Received: from mga05.intel.com ([192.55.52.43]:16349 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241718AbhHFHac (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Aug 2021 03:30:32 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10067"; a="299913837"
X-IronPort-AV: E=Sophos;i="5.84,299,1620716400"; 
   d="scan'208";a="299913837"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 00:29:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,299,1620716400"; 
   d="scan'208";a="513102566"
Received: from michael-optiplex-9020.sh.intel.com ([10.239.159.182])
  by FMSMGA003.fm.intel.com with ESMTP; 06 Aug 2021 00:29:54 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        vkuznets@redhat.com, wei.w.wang@intel.com, like.xu.linux@gmail.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v7 15/15] KVM: x86/cpuid: Advise Arch LBR feature in CPUID
Date:   Fri,  6 Aug 2021 15:42:25 +0800
Message-Id: <1628235745-26566-16-git-send-email-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1628235745-26566-1-git-send-email-weijiang.yang@intel.com>
References: <1628235745-26566-1-git-send-email-weijiang.yang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add Arch LBR feature bit in CPU cap-mask to expose the feature.
Currently only max LBR depth is available for guest, and it's
consistent with host Arch LBR settings.

Co-developed-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/cpuid.c | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 03025eea1524..1ee3014b8977 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -202,6 +202,16 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		best->ecx |= XFEATURE_MASK_FPSSE;
 	}
 
+	best = kvm_find_cpuid_entry(vcpu, 0x1c, 0);
+	if (best) {
+		unsigned int eax, ebx, ecx, edx;
+
+		/* Make sure guest only sees the supported arch lbr depth. */
+		cpuid_count(0x1c, 0, &eax, &ebx, &ecx, &edx);
+		best->eax &= ~0xff;
+		best->eax |= BIT(fls(eax & 0xff) - 1);
+	}
+
 	kvm_update_pv_runtime(vcpu);
 
 	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
@@ -490,7 +500,7 @@ void kvm_set_cpu_caps(void)
 		F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
 		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
 		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM) |
-		F(SERIALIZE) | F(TSXLDTRK) | F(AVX512_FP16)
+		F(SERIALIZE) | F(TSXLDTRK) | F(AVX512_FP16) | F(ARCH_LBR)
 	);
 
 	/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
@@ -903,6 +913,27 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 				goto out;
 		}
 		break;
+	/* Architectural LBR */
+	case 0x1c: {
+		u32 lbr_depth_mask = entry->eax & 0xff;
+
+		if (!lbr_depth_mask ||
+		    !kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR)) {
+			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
+			break;
+		}
+		/*
+		 * KVM only exposes the maximum supported depth, which is the
+		 * fixed value used on the host side.
+		 * KVM doesn't allow VMM userspace to adjust LBR depth because
+		 * guest LBR emulation depends on the configuration of host LBR
+		 * driver.
+		 */
+		lbr_depth_mask = BIT((fls(lbr_depth_mask) - 1));
+		entry->eax &= ~0xff;
+		entry->eax |= lbr_depth_mask;
+		break;
+	}
 	case KVM_CPUID_SIGNATURE: {
 		static const char signature[12] = "KVMKVMKVM\0\0";
 		const u32 *sigptr = (const u32 *)signature;
-- 
2.25.1

