Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB55303407
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 06:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729109AbhAZFMi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 00:12:38 -0500
Received: from mga14.intel.com ([192.55.52.115]:22889 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726167AbhAYJRV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 04:17:21 -0500
IronPort-SDR: wslqyyTAphjGvfXDAbrHffxEoYMsKTt5He+1JqTnUqqb/w97lWtdMJpGwsbxAkclxia4Y7NuWn
 n6STyzAielvg==
X-IronPort-AV: E=McAfee;i="6000,8403,9874"; a="178915797"
X-IronPort-AV: E=Sophos;i="5.79,373,1602572400"; 
   d="scan'208";a="178915797"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 01:07:13 -0800
IronPort-SDR: lVeFJzCtaKsi5mZ78pAEn6lTIoe/roBqEzX/gmjaSZHp0TYOyb+KSsEaI9gSMRT8NMg70e5pwX
 yPYQkv5Fbl/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,373,1602572400"; 
   d="scan'208";a="402223880"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga004.fm.intel.com with ESMTP; 25 Jan 2021 01:07:11 -0800
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Cc:     chang.seok.bae@intel.com, kvm@vger.kernel.org, robert.hu@intel.com,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: [RFC PATCH 06/12] kvm/cpuid: Enumerate KeyLocker feature in KVM
Date:   Mon, 25 Jan 2021 17:06:14 +0800
Message-Id: <1611565580-47718-7-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611565580-47718-1-git-send-email-robert.hu@linux.intel.com>
References: <1611565580-47718-1-git-send-email-robert.hu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In kvm_set_cpu_caps(), add KeyLocker feature enumeration, under the
condition that 1) HW supports this feature 2) host Kernel isn't
enabled with this feature.

Filter out randomization support bit (CPUID.0x19.ECX[1]), as by design it
cannot be supported at this moment.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/kvm/cpuid.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 2fbf4af..5fc6b2c 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -406,9 +406,10 @@ void kvm_set_cpu_caps(void)
 	kvm_cpu_cap_mask(CPUID_7_ECX,
 		F(AVX512VBMI) | F(LA57) | F(PKU) | 0 /*OSPKE*/ | F(RDPID) |
 		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
-		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
-		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/
+		F(VAES) | 0 /*KEYLOCKER*/ | F(VPCLMULQDQ) | F(AVX512_VNNI) |
+		F(AVX512_BITALG) | F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/
 	);
+
 	/* Set LA57 based on hardware capability. */
 	if (cpuid_ecx(7) & F(LA57))
 		kvm_cpu_cap_set(X86_FEATURE_LA57);
@@ -451,6 +452,11 @@ void kvm_set_cpu_caps(void)
 		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | F(XSAVES)
 	);
 
+	kvm_cpu_cap_mask(CPUID_19_EBX, F(KL_INS_ENABLED) | F(KL_WIDE) |
+		F(IWKEY_BACKUP));
+	/* No randomize exposed to guest */
+	kvm_cpu_cap_mask(CPUID_19_ECX, F(IWKEY_NOBACKUP));
+
 	kvm_cpu_cap_mask(CPUID_8000_0001_ECX,
 		F(LAHF_LM) | F(CMP_LEGACY) | 0 /*SVM*/ | 0 /* ExtApicSpace */ |
 		F(CR8_LEGACY) | F(ABM) | F(SSE4A) | F(MISALIGNSSE) |
@@ -784,6 +790,11 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 				goto out;
 		}
 		break;
+	/* KeyLocker */
+	case 0x19:
+		cpuid_entry_override(entry, CPUID_19_ECX);
+		break;
+
 	case KVM_CPUID_SIGNATURE: {
 		static const char signature[12] = "KVMKVMKVM\0\0";
 		const u32 *sigptr = (const u32 *)signature;
-- 
1.8.3.1

