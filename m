Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F96F5F9B6
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2019 16:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727810AbfGDOHY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jul 2019 10:07:24 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39601 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727771AbfGDOHW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jul 2019 10:07:22 -0400
Received: by mail-wr1-f66.google.com with SMTP id x4so6769815wrt.6;
        Thu, 04 Jul 2019 07:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b9PKvROTCzaBJV6B7Sp+mExZhIpg0LDSLdi+vyBoXgQ=;
        b=VoBg8fDcWKIW6YiB2TKfvuNwkOq2BeG7G1ojXxYpaA/rhGNLcpCQLYHn+RNSuGrRIt
         2d6z9OCFF34mBT0Ce2jCZ8KTeV7LCsgYnjkY2IUkZZjdXUJ5upxeRscRZc8R4BnxNAcq
         feXQ847Wm2rjgvBa3kp0Byi/FTgarhkOoCaXv1yKKv7WJxmB4ehs9vfwPqLKXEpNK1aY
         koNzIarjDRU9QZR54fRte6bBiSm+Mhuu3a5+11ep6d6YClPfQy6ZlUX//PGRSYrfmd4L
         hkAiZSErfoGOPxmCivZUum79gEc8m2Qz0NnDT3xQjy0pG3X6ySQembLqGW/tyTztcyfV
         IJMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=b9PKvROTCzaBJV6B7Sp+mExZhIpg0LDSLdi+vyBoXgQ=;
        b=NH8kVLWu5AXaTD0e2KbhZE7tcwIhWfHDrVY9xWsR97JggxQdgh65EHTEAeJdIl2L/2
         Gsa8drDsYhYlo5K+o/S0rRe1B3vXgLxEaOUD9F3m0qFwZLDz0vfErwMDJAeqiIJzNRnD
         0ZHw64LM4Is/79QlonjOh+vo4MhuTZKszSgkgoCzoZe97L5m4+I1bf3WQf6f8M4+Mv3K
         SOoREGJyGQu2N59Pq5oEXmss9cBUnHDaK3Ld/Rz7PdBGwzQ/O1KO3WataJZbXcDFQZN9
         CMLP8vHOP1avjZGNr12oarcblbSyhDJg+8EF1xJAagkvv32tcA/zl/e9VFKPWR2wuPBn
         fknA==
X-Gm-Message-State: APjAAAUuv0rygChHGXKt4yKLn6ljlUwLREyqnqOy3O8fOpR3FeeBraze
        woshZ7ovRyyFssJh/5tjEMMuQZxFzGE=
X-Google-Smtp-Source: APXvYqyvlrT/3XknaP4SA4nyKwW1Pnfje0B5QNpgpGRECeV7m0/kD6FvrglDRXcjwZ/nIFwlqLLOrA==
X-Received: by 2002:a5d:4d10:: with SMTP id z16mr21451453wrt.112.1562249239355;
        Thu, 04 Jul 2019 07:07:19 -0700 (PDT)
Received: from donizetti.redhat.com (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.gmail.com with ESMTPSA id n5sm4458060wmi.21.2019.07.04.07.07.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 04 Jul 2019 07:07:18 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jing2.liu@linux.intel.com
Subject: [PATCH 2/5] KVM: cpuid: extract do_cpuid_7_mask and support multiple subleafs
Date:   Thu,  4 Jul 2019 16:07:12 +0200
Message-Id: <20190704140715.31181-3-pbonzini@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190704140715.31181-1-pbonzini@redhat.com>
References: <20190704140715.31181-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CPUID function 7 has multiple subleafs.  Instead of having nested
switch statements, move the logic to filter supported features to
a separate function, and call it for each subleaf.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	Here you would have something like entry->eax = min(entry->eax, 1)
	when adding subleaf 1.

 arch/x86/kvm/cpuid.c | 128 +++++++++++++++++++++++++++----------------
 1 file changed, 81 insertions(+), 47 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index ddffc56c39b4..1c6b9a4a74de 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -328,6 +328,71 @@ static int __do_cpuid_func_emulated(struct kvm_cpuid_entry2 *entry,
 	return 0;
 }
 
+static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry, int index)
+{
+	unsigned f_invpcid = kvm_x86_ops->invpcid_supported() ? F(INVPCID) : 0;
+	unsigned f_mpx = kvm_mpx_supported() ? F(MPX) : 0;
+	unsigned f_umip = kvm_x86_ops->umip_emulated() ? F(UMIP) : 0;
+	unsigned f_intel_pt = kvm_x86_ops->pt_supported() ? F(INTEL_PT) : 0;
+	unsigned f_la57;
+
+	/* cpuid 7.0.ebx */
+	const u32 kvm_cpuid_7_0_ebx_x86_features =
+		F(FSGSBASE) | F(BMI1) | F(HLE) | F(AVX2) | F(SMEP) |
+		F(BMI2) | F(ERMS) | f_invpcid | F(RTM) | f_mpx | F(RDSEED) |
+		F(ADX) | F(SMAP) | F(AVX512IFMA) | F(AVX512F) | F(AVX512PF) |
+		F(AVX512ER) | F(AVX512CD) | F(CLFLUSHOPT) | F(CLWB) | F(AVX512DQ) |
+		F(SHA_NI) | F(AVX512BW) | F(AVX512VL) | f_intel_pt;
+
+	/* cpuid 7.0.ecx*/
+	const u32 kvm_cpuid_7_0_ecx_x86_features =
+		F(AVX512VBMI) | F(LA57) | F(PKU) | 0 /*OSPKE*/ |
+		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
+		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
+		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B);
+
+	/* cpuid 7.0.edx*/
+	const u32 kvm_cpuid_7_0_edx_x86_features =
+		F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
+		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
+		F(MD_CLEAR);
+
+	switch (index) {
+	case 0:
+		entry->eax = 0;
+		entry->ebx &= kvm_cpuid_7_0_ebx_x86_features;
+		cpuid_mask(&entry->ebx, CPUID_7_0_EBX);
+		/* TSC_ADJUST is emulated */
+		entry->ebx |= F(TSC_ADJUST);
+
+		entry->ecx &= kvm_cpuid_7_0_ecx_x86_features;
+		f_la57 = entry->ecx & F(LA57);
+		cpuid_mask(&entry->ecx, CPUID_7_ECX);
+		/* Set LA57 based on hardware capability. */
+		entry->ecx |= f_la57;
+		entry->ecx |= f_umip;
+		/* PKU is not yet implemented for shadow paging. */
+		if (!tdp_enabled || !boot_cpu_has(X86_FEATURE_OSPKE))
+			entry->ecx &= ~F(PKU);
+
+		entry->edx &= kvm_cpuid_7_0_edx_x86_features;
+		cpuid_mask(&entry->edx, CPUID_7_EDX);
+		/*
+		 * We emulate ARCH_CAPABILITIES in software even
+		 * if the host doesn't support it.
+		 */
+		entry->edx |= F(ARCH_CAPABILITIES);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		entry->eax = 0;
+		entry->ebx = 0;
+		entry->ecx = 0;
+		entry->edx = 0;
+		break;
+	}
+}
+
 static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 				  int *nent, int maxnent)
 {
@@ -342,12 +407,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 	unsigned f_lm = 0;
 #endif
 	unsigned f_rdtscp = kvm_x86_ops->rdtscp_supported() ? F(RDTSCP) : 0;
-	unsigned f_invpcid = kvm_x86_ops->invpcid_supported() ? F(INVPCID) : 0;
-	unsigned f_mpx = kvm_mpx_supported() ? F(MPX) : 0;
 	unsigned f_xsaves = kvm_x86_ops->xsaves_supported() ? F(XSAVES) : 0;
-	unsigned f_umip = kvm_x86_ops->umip_emulated() ? F(UMIP) : 0;
 	unsigned f_intel_pt = kvm_x86_ops->pt_supported() ? F(INTEL_PT) : 0;
-	unsigned f_la57 = 0;
 
 	/* cpuid 1.edx */
 	const u32 kvm_cpuid_1_edx_x86_features =
@@ -400,31 +461,10 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 		F(ACE2) | F(ACE2_EN) | F(PHE) | F(PHE_EN) |
 		F(PMM) | F(PMM_EN);
 
-	/* cpuid 7.0.ebx */
-	const u32 kvm_cpuid_7_0_ebx_x86_features =
-		F(FSGSBASE) | F(BMI1) | F(HLE) | F(AVX2) | F(SMEP) |
-		F(BMI2) | F(ERMS) | f_invpcid | F(RTM) | f_mpx | F(RDSEED) |
-		F(ADX) | F(SMAP) | F(AVX512IFMA) | F(AVX512F) | F(AVX512PF) |
-		F(AVX512ER) | F(AVX512CD) | F(CLFLUSHOPT) | F(CLWB) | F(AVX512DQ) |
-		F(SHA_NI) | F(AVX512BW) | F(AVX512VL) | f_intel_pt;
-
 	/* cpuid 0xD.1.eax */
 	const u32 kvm_cpuid_D_1_eax_x86_features =
 		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1) | f_xsaves;
 
-	/* cpuid 7.0.ecx*/
-	const u32 kvm_cpuid_7_0_ecx_x86_features =
-		F(AVX512VBMI) | F(LA57) | F(PKU) | 0 /*OSPKE*/ |
-		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
-		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
-		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B);
-
-	/* cpuid 7.0.edx*/
-	const u32 kvm_cpuid_7_0_edx_x86_features =
-		F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
-		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
-		F(MD_CLEAR);
-
 	/* all calls to cpuid_count() should be made on the same cpu */
 	get_cpu();
 
@@ -496,30 +536,24 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 		entry->ecx = 0;
 		entry->edx = 0;
 		break;
+	/* function 7 has additional index. */
 	case 7: {
+		int i;
+
 		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
-		entry->eax = 0;
-		/* Mask ebx against host capability word 9 */
-		entry->ebx &= kvm_cpuid_7_0_ebx_x86_features;
-		cpuid_mask(&entry->ebx, CPUID_7_0_EBX);
-		// TSC_ADJUST is emulated
-		entry->ebx |= F(TSC_ADJUST);
-		entry->ecx &= kvm_cpuid_7_0_ecx_x86_features;
-		f_la57 = entry->ecx & F(LA57);
-		cpuid_mask(&entry->ecx, CPUID_7_ECX);
-		/* Set LA57 based on hardware capability. */
-		entry->ecx |= f_la57;
-		entry->ecx |= f_umip;
-		/* PKU is not yet implemented for shadow paging. */
-		if (!tdp_enabled || !boot_cpu_has(X86_FEATURE_OSPKE))
-			entry->ecx &= ~F(PKU);
-		entry->edx &= kvm_cpuid_7_0_edx_x86_features;
-		cpuid_mask(&entry->edx, CPUID_7_EDX);
-		/*
-		 * We emulate ARCH_CAPABILITIES in software even
-		 * if the host doesn't support it.
-		 */
-		entry->edx |= F(ARCH_CAPABILITIES);
+		for (i = 0; ; ) {
+			do_cpuid_7_mask(&entry[i], i);
+			if (i == entry->eax)
+				break;
+			if (*nent >= maxnent)
+				goto out;
+
+			++i;
+			do_cpuid_1_ent(&entry[i], function, i);
+			entry[i].flags |=
+			       KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
+			++*nent;
+		}
 		break;
 	}
 	case 9:
-- 
2.21.0


