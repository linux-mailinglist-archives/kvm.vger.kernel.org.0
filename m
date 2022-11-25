Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76BAA6383DA
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 07:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbiKYGKc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 01:10:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiKYGKO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 01:10:14 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B0C220FC;
        Thu, 24 Nov 2022 22:10:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669356612; x=1700892612;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uj6HM1hQ0tM0PgUYcKz/8p4PHCsF17smG+1Rma8X0Ak=;
  b=Yt1g5DEN6KsaWsu/re+tUyKxHUPOO/UqT5t2+lo+i8T93739D1OWm6+w
   bL3j+QCi0sqvJdUUoMs/20pM+gJCe8LjnQEwYy3SZwAg+5niTPm8cdC9j
   ee00VLQb6J1HXW85Is+XAnWEzbdF3SVgBTy9kGEBVo1qpyF2R0IEbCc3x
   T2wfRA4bV3W6/qg8QDYYyUYgFiYRmHuMGQYVen2pRCFrg4jCoctQtD+7A
   Hlx4MmYIRQRcZOpLHzE+38mXbyarszQX4sqzgnnak+Nzc8s0rWnL5Xu53
   MPPvwoJ6UBxpRXQAo3b62RVqfiEInGY35BQRBEBMzoTofqdivbLzehcGs
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="313116844"
X-IronPort-AV: E=Sophos;i="5.96,192,1665471600"; 
   d="scan'208";a="313116844"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 22:10:10 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="784838516"
X-IronPort-AV: E=Sophos;i="5.96,192,1665471600"; 
   d="scan'208";a="784838516"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 22:10:09 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, jmattson@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     like.xu.linux@gmail.com, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, weijiang.yang@intel.com,
        Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v2 15/15] KVM: x86/cpuid: Advertise Arch LBR feature in CPUID
Date:   Thu, 24 Nov 2022 23:06:04 -0500
Message-Id: <20221125040604.5051-16-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20221125040604.5051-1-weijiang.yang@intel.com>
References: <20221125040604.5051-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add Arch LBR feature bit in CPU cap-mask to expose the feature.
Only max LBR depth is supported for guest, and it's consistent
with host Arch LBR settings.

Co-developed-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
---
 arch/x86/kvm/cpuid.c | 36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 85e3df6217af..60b3c591d462 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -134,6 +134,19 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu,
 		if (vaddr_bits != 48 && vaddr_bits != 57 && vaddr_bits != 0)
 			return -EINVAL;
 	}
+	if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR)) {
+		best = cpuid_entry2_find(entries, nent, 0x1c, 0);
+		if (best) {
+			unsigned int eax, ebx, ecx, edx;
+
+			/* Reject user-space CPUID if depth is different from host's.*/
+			cpuid_count(0x1c, 0, &eax, &ebx, &ecx, &edx);
+
+			if ((eax & 0xff) &&
+			    (best->eax & 0xff) != BIT(fls(eax & 0xff) - 1))
+				return -EINVAL;
+		}
+	}
 
 	/*
 	 * Exposing dynamic xfeatures to the guest requires additional
@@ -652,7 +665,7 @@ void kvm_set_cpu_caps(void)
 		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
 		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM) |
 		F(SERIALIZE) | F(TSXLDTRK) | F(AVX512_FP16) |
-		F(AMX_TILE) | F(AMX_INT8) | F(AMX_BF16)
+		F(AMX_TILE) | F(AMX_INT8) | F(AMX_BF16) | F(ARCH_LBR)
 	);
 
 	/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
@@ -1074,6 +1087,27 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
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
 	/* Intel AMX TILE */
 	case 0x1d:
 		if (!kvm_cpu_cap_has(X86_FEATURE_AMX_TILE)) {
-- 
2.27.0

