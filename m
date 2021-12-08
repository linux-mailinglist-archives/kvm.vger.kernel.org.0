Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FAB546BEF3
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 16:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238706AbhLGPOf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 10:14:35 -0500
Received: from mga03.intel.com ([134.134.136.65]:53832 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238673AbhLGPOO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 10:14:14 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="237536580"
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="237536580"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2021 07:10:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="461290237"
Received: from icx.bj.intel.com ([10.240.192.117])
  by orsmga003.jf.intel.com with ESMTP; 07 Dec 2021 07:10:19 -0800
From:   Yang Zhong <yang.zhong@intel.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        yang.zhong@intel.com
Subject: [PATCH 19/19] kvm: x86: Add AMX CPUIDs support
Date:   Tue,  7 Dec 2021 19:03:59 -0500
Message-Id: <20211208000359.2853257-20-yang.zhong@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211208000359.2853257-1-yang.zhong@intel.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jing Liu <jing2.liu@intel.com>

Extend CPUID emulation to support XFD, AMX_TILE, AMX_INT8 and
AMX_BF16. Adding those bits into kvm_cpu_caps finally activates all
previous logics in this series.

Signed-off-by: Jing Liu <jing2.liu@intel.com>
Signed-off-by: Yang Zhong <yang.zhong@intel.com>
---
 arch/x86/include/asm/cpufeatures.h |  2 ++
 arch/x86/kvm/cpuid.c               | 16 +++++++++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index d5b5f2ab87a0..da872b6f8d8b 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -299,7 +299,9 @@
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
 #define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* AVX VNNI instructions */
 #define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* AVX512 BFLOAT16 instructions */
+#define X86_FEATURE_AMX_BF16		(18*32+22) /* AMX bf16 Support */
 #define X86_FEATURE_AMX_TILE		(18*32+24) /* AMX tile Support */
+#define X86_FEATURE_AMX_INT8		(18*32+25) /* AMX int8 Support */
 
 /* AMD-defined CPU features, CPUID level 0x80000008 (EBX), word 13 */
 #define X86_FEATURE_CLZERO		(13*32+ 0) /* CLZERO instruction */
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index ea51b986ee67..7bb56cc89aa7 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -510,7 +510,8 @@ void kvm_set_cpu_caps(void)
 		F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
 		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
 		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM) |
-		F(SERIALIZE) | F(TSXLDTRK) | F(AVX512_FP16)
+		F(SERIALIZE) | F(TSXLDTRK) | F(AVX512_FP16) |
+		F(AMX_TILE) | F(AMX_INT8) | F(AMX_BF16)
 	);
 
 	/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
@@ -529,7 +530,7 @@ void kvm_set_cpu_caps(void)
 	);
 
 	kvm_cpu_cap_mask(CPUID_D_1_EAX,
-		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | F(XSAVES)
+		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | F(XSAVES) | F(XFD)
 	);
 
 	kvm_cpu_cap_init_scattered(CPUID_12_EAX,
@@ -655,6 +656,8 @@ static struct kvm_cpuid_entry2 *do_host_cpuid(struct kvm_cpuid_array *array,
 	case 0x14:
 	case 0x17:
 	case 0x18:
+	case 0x1d:
+	case 0x1e:
 	case 0x1f:
 	case 0x8000001d:
 		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
@@ -779,6 +782,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		}
 		break;
 	case 9:
+	case 0x1e: /* TMUL information */
 		break;
 	case 0xa: { /* Architectural Performance Monitoring */
 		struct x86_pmu_capability cap;
@@ -914,7 +918,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		break;
 	/* Intel PT */
 	case 0x14:
-		if (!kvm_cpu_cap_has(X86_FEATURE_INTEL_PT)) {
+		if ((function == 0x14 && !kvm_cpu_cap_has(X86_FEATURE_INTEL_PT)) ||
+		    (function == 0x1d && !kvm_cpu_cap_has(X86_FEATURE_AMX_TILE))) {
 			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
 			break;
 		}
@@ -924,6 +929,11 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 				goto out;
 		}
 		break;
+	/* Intel AMX TILE */
+	case 0x1d:
+		if (!kvm_cpu_cap_has(X86_FEATURE_AMX_TILE))
+			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
+		break;
 	case KVM_CPUID_SIGNATURE: {
 		const u32 *sigptr = (const u32 *)KVM_SIGNATURE;
 		entry->eax = KVM_CPUID_FEATURES;
