Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBCB92D21A1
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 04:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbgLHD4a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 22:56:30 -0500
Received: from mga14.intel.com ([192.55.52.115]:59706 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726556AbgLHD4a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 22:56:30 -0500
IronPort-SDR: 4bap6LJ9XyrO89KUGzw447xJzLX16Qtg8D16T+ztHbArfNdwWKIKUVPhgHz2lTWiXKTNA2HjSF
 Y6uovgLArv+Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9828"; a="173060180"
X-IronPort-AV: E=Sophos;i="5.78,401,1599548400"; 
   d="scan'208";a="173060180"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2020 19:55:35 -0800
IronPort-SDR: nvu23G2qECChJTtgThqTte/uySMynDEZAW3ErrvTP74P9lLCwnVcbuKlTKjyTAxbe68EorHFUQ
 s5xHgsHIFkFg==
X-IronPort-AV: E=Sophos;i="5.78,401,1599548400"; 
   d="scan'208";a="363469717"
Received: from km-skylake-client-platform.sc.intel.com ([10.3.52.146])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2020 19:55:34 -0800
From:   Kyung Min Park <kyung.min.park@intel.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        jmattson@google.com, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com, kyung.min.park@intel.com,
        cathy.zhang@intel.com
Subject: [PATCH 1/2] Enumerate AVX512 FP16 CPUID feature flag
Date:   Mon,  7 Dec 2020 19:34:40 -0800
Message-Id: <20201208033441.28207-2-kyung.min.park@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201208033441.28207-1-kyung.min.park@intel.com>
References: <20201208033441.28207-1-kyung.min.park@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enumerate AVX512 Half-precision floating point (FP16) CPUID feature
flag. Compared with using FP32, using FP16 cut the number of bits
required for storage in half, reducing the exponent from 8 bits to 5,
and the mantissa from 23 bits to 10. Using FP16 also enables developers
to train and run inference on deep learning models fast when all
precision or magnitude (FP32) is not needed.

A processor supports AVX512 FP16 if CPUID.(EAX=7,ECX=0):EDX[bit 23]
is present. The AVX512 FP16 requires AVX512BW feature be implemented
since the instructions for manipulating 32bit masks are associated with
AVX512BW.

The only in-kernel usage of this is kvm passthrough. The CPU feature
flag is shown as "avx512_fp16" in /proc/cpuinfo.

Signed-off-by: Kyung Min Park <kyung.min.park@intel.com>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kernel/cpu/cpuid-deps.c   | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index b6b9b3407c22..bec37ec7101e 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -375,6 +375,7 @@
 #define X86_FEATURE_TSXLDTRK		(18*32+16) /* TSX Suspend Load Address Tracking */
 #define X86_FEATURE_PCONFIG		(18*32+18) /* Intel PCONFIG */
 #define X86_FEATURE_ARCH_LBR		(18*32+19) /* Intel ARCH LBR */
+#define X86_FEATURE_AVX512_FP16		(18*32+23) /* AVX512 FP16 */
 #define X86_FEATURE_SPEC_CTRL		(18*32+26) /* "" Speculation Control (IBRS + IBPB) */
 #define X86_FEATURE_INTEL_STIBP		(18*32+27) /* "" Single Thread Indirect Branch Predictors */
 #define X86_FEATURE_FLUSH_L1D		(18*32+28) /* Flush L1D cache */
diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid-deps.c
index d502241995a3..42af31b64c2c 100644
--- a/arch/x86/kernel/cpu/cpuid-deps.c
+++ b/arch/x86/kernel/cpu/cpuid-deps.c
@@ -69,6 +69,7 @@ static const struct cpuid_dep cpuid_deps[] = {
 	{ X86_FEATURE_CQM_MBM_TOTAL,		X86_FEATURE_CQM_LLC   },
 	{ X86_FEATURE_CQM_MBM_LOCAL,		X86_FEATURE_CQM_LLC   },
 	{ X86_FEATURE_AVX512_BF16,		X86_FEATURE_AVX512VL  },
+	{ X86_FEATURE_AVX512_FP16,		X86_FEATURE_AVX512BW  },
 	{ X86_FEATURE_ENQCMD,			X86_FEATURE_XSAVES    },
 	{ X86_FEATURE_PER_THREAD_MBA,		X86_FEATURE_MBA       },
 	{}
-- 
2.17.1

