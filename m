Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68A8051CFAD
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 05:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388765AbiEFDhk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 23:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346609AbiEFDhS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 23:37:18 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 194024614F;
        Thu,  5 May 2022 20:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651808017; x=1683344017;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GErNHkbzaEC9OnwKG/vCE6C1fQAfuOt3me7dwWAabbs=;
  b=OdJQzTfjy6YZuywW/wqvc3HGePK7y74NifKyqWPUWjAty97v7+/DbBeC
   3VhKKV+gXRqkUKyTWc7tdhks34ehSM1dBeub3EZ+vHnZcsQt9Ji5tqXfH
   aeI/4ABuTcOEynRqu2hY82eloDLpLdr82k3dNiWF0/mCzsR79r49JQnxu
   eHJigvvqZ5IAceVeffklSQwqyzx4S9i4G58rukKWpN8kU+ZH38O1/XWF0
   Ar73PlRV4QbBaBrFbDlUcwx1MWPjpiV1LNU418Uec9MEBdHUyFLWwTfRD
   VcwMlO6V1++m1HHXqx4PgL6eUSI/QtMS0rPh4C/954IF3FARdYRadcQT2
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="248241449"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="248241449"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 20:33:36 -0700
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="632745215"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 20:33:36 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        kan.liang@linux.intel.com, like.xu.linux@gmail.com,
        vkuznets@redhat.com, wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>,
        Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v11 16/16] KVM: x86/cpuid: Advertise Arch LBR feature in CPUID
Date:   Thu,  5 May 2022 23:33:05 -0400
Message-Id: <20220506033305.5135-17-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220506033305.5135-1-weijiang.yang@intel.com>
References: <20220506033305.5135-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
---
 arch/x86/kvm/cpuid.c | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 63870f78ed16..be4eb4e5e1fc 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -102,6 +102,16 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu,
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
 
 	/*
 	 * Exposing dynamic xfeatures to the guest requires additional
@@ -598,7 +608,7 @@ void kvm_set_cpu_caps(void)
 		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
 		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM) |
 		F(SERIALIZE) | F(TSXLDTRK) | F(AVX512_FP16) |
-		F(AMX_TILE) | F(AMX_INT8) | F(AMX_BF16)
+		F(AMX_TILE) | F(AMX_INT8) | F(AMX_BF16) | F(ARCH_LBR)
 	);
 
 	/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
@@ -1044,6 +1054,27 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
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

