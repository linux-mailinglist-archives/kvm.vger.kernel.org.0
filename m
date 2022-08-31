Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 159B45A8AF0
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 03:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232879AbiIABhj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 21:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232746AbiIABhN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 21:37:13 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 361DC15C352;
        Wed, 31 Aug 2022 18:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661996232; x=1693532232;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+sz4qCGDcJYgZIdr5901G2HgOpmFGac0nu48tJ2pZNA=;
  b=DQRPjDlFFIVgE+UvyxEMWa6afFV8Kv2lWAUrrxewkcQIDDB/gOkYGaFZ
   FSp10jzqHQTTvkkjedAKEMa9bFLQrPAJf/qEDuBBa8VMtdVIZvUO8zSZO
   8cIWXaCf2bHQpWb52ciS+wqntfAd8GMAVz3uoJWp5LZ+Onk/2ty2Yfvbd
   2fe2rFWUGfB2m55QXbis+CosrpEzBlOPYzh9wsTBoY1LAvIApWNuHm5Zn
   nuuJJ6EDmACAEtkbzcPIlYI0Q26FnBbzlbq1yoazFRGtpm9zDjFyXV1rT
   8eMTDMaeYTZ7LByNfajEYMasOuttRNo5/GwvRfxoAVJrcCbW1Lviokop9
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="321735109"
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="321735109"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 18:37:03 -0700
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="754626059"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 18:37:03 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org
Cc:     like.xu.linux@gmail.com, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH 15/15] KVM: x86/cpuid: Advertise Arch LBR feature in CPUID
Date:   Wed, 31 Aug 2022 18:34:38 -0400
Message-Id: <20220831223438.413090-16-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220831223438.413090-1-weijiang.yang@intel.com>
References: <20220831223438.413090-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
Message-Id: <20220517154100.29983-17-weijiang.yang@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/cpuid.c | 36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 9ca592e969e3..cf2a0b28c239 100644
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
@@ -631,7 +644,7 @@ void kvm_set_cpu_caps(void)
 		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
 		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM) |
 		F(SERIALIZE) | F(TSXLDTRK) | F(AVX512_FP16) |
-		F(AMX_TILE) | F(AMX_INT8) | F(AMX_BF16)
+		F(AMX_TILE) | F(AMX_INT8) | F(AMX_BF16) | F(ARCH_LBR)
 	);
 
 	/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
@@ -1055,6 +1068,27 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
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

