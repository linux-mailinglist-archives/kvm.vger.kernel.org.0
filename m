Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9ABC3F5948
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 09:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235784AbhHXHoA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 03:44:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:63753 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235470AbhHXHnj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 03:43:39 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10085"; a="217260219"
X-IronPort-AV: E=Sophos;i="5.84,346,1620716400"; 
   d="scan'208";a="217260219"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 00:41:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,346,1620716400"; 
   d="scan'208";a="473402233"
Received: from michael-optiplex-9020.sh.intel.com ([10.239.159.182])
  by orsmga008.jf.intel.com with ESMTP; 24 Aug 2021 00:41:17 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, vkuznets@redhat.com, wei.w.wang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v8 15/15] KVM: x86/cpuid: Advise Arch LBR feature in CPUID
Date:   Tue, 24 Aug 2021 15:56:17 +0800
Message-Id: <1629791777-16430-16-git-send-email-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1629791777-16430-1-git-send-email-weijiang.yang@intel.com>
References: <1629791777-16430-1-git-send-email-weijiang.yang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add Arch LBR feature bit in CPU cap-mask to expose the feature.
Only max LBR depth is supported for guest, and it's consistent
with host Arch LBR settings.

Co-developed-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/cpuid.c | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 03025eea1524..d98ebefd5d72 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -88,6 +88,16 @@ static int kvm_check_cpuid(struct kvm_cpuid_entry2 *entries, int nent)
 		if (vaddr_bits != 48 && vaddr_bits != 57 && vaddr_bits != 0)
 			return -EINVAL;
 	}
+	best = cpuid_entry2_find(entries, nent, 0x1c, 0);
+	if (best) {
+		unsigned int eax, ebx, ecx, edx;
+
+		/* Reject user-space CPUID if depth is different from host's.*/
+		cpuid_count(0x1c, 0, &eax, &ebx, &ecx, &edx);
+
+		if ((best->eax & 0xff) != BIT(fls(eax & 0xff) - 1))
+			return -EINVAL;
+	}
 
 	return 0;
 }
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

