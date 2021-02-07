Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF5A3312219
	for <lists+kvm@lfdr.de>; Sun,  7 Feb 2021 08:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbhBGG7o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Feb 2021 01:59:44 -0500
Received: from mga07.intel.com ([134.134.136.100]:48424 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229760AbhBGG7O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Feb 2021 01:59:14 -0500
IronPort-SDR: Fplw0Ks5A0an3AWPRLceVCe15xtKJFXWq5HCn/GUJ7pJvRnNd9nILgywvw6yxGHDtkhZjV11gd
 Q51vK/Zb0QTA==
X-IronPort-AV: E=McAfee;i="6000,8403,9887"; a="245660856"
X-IronPort-AV: E=Sophos;i="5.81,159,1610438400"; 
   d="scan'208";a="245660856"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2021 22:54:54 -0800
IronPort-SDR: JI3+I43vA2iN7QPW06eqGbRN+vVN5uA+8qX27WliyfFBVddv2eYOem6wEolA3qKJMYGLhCyELL
 avaRFN++rIlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,159,1610438400"; 
   d="scan'208";a="410376680"
Received: from vmmteam.bj.intel.com ([10.240.193.86])
  by fmsmga004.fm.intel.com with ESMTP; 06 Feb 2021 22:54:53 -0800
From:   Jing Liu <jing2.liu@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, jing2.liu@intel.com
Subject: [PATCH RFC 6/7] kvm: x86: Add AMX_TILE, AMX_INT8 and AMX_BF16 support
Date:   Sun,  7 Feb 2021 10:42:55 -0500
Message-Id: <20210207154256.52850-7-jing2.liu@linux.intel.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20210207154256.52850-1-jing2.liu@linux.intel.com>
References: <20210207154256.52850-1-jing2.liu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Intel introduces AMX architecture in SPR platform, which includes
AMX_TILE, AMX_INT8 and AMX_BF16 support.

Exposes these features to KVM guest.

Signed-off-by: Jing Liu <jing2.liu@linux.intel.com>
---
 arch/x86/kvm/cpuid.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index ee1fac0a865e..1b3ea9195a75 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -423,7 +423,8 @@ void kvm_set_cpu_caps(void)
 		F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
 		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
 		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM) |
-		F(SERIALIZE) | F(TSXLDTRK)
+		F(SERIALIZE) | F(TSXLDTRK) |
+		F(AMX_TILE) | F(AMX_INT8) | F(AMX_BF16)
 	);
 
 	/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
@@ -544,6 +545,8 @@ static struct kvm_cpuid_entry2 *do_host_cpuid(struct kvm_cpuid_array *array,
 	case 0x14:
 	case 0x17:
 	case 0x18:
+	case 0x1d:
+	case 0x1e:
 	case 0x1f:
 	case 0x8000001d:
 		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
@@ -667,6 +670,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		break;
 	case 9:
 		break;
+	case 0x1e:
+		break;
 	case 0xa: { /* Architectural Performance Monitoring */
 		struct x86_pmu_capability cap;
 		union cpuid10_eax eax;
@@ -766,9 +771,12 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			entry->edx = 0;
 		}
 		break;
+	/* Intel AMX TILE */
+	case 0x1d:
 	/* Intel PT */
 	case 0x14:
-		if (!kvm_cpu_cap_has(X86_FEATURE_INTEL_PT)) {
+		if ((function == 0x14 && !kvm_cpu_cap_has(X86_FEATURE_INTEL_PT)) ||
+		    (function == 0x1d && !kvm_cpu_cap_has(X86_FEATURE_AMX_TILE))) {
 			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
 			break;
 		}
-- 
2.18.4

