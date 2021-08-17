Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7244A3EE81F
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 10:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239044AbhHQIMf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 04:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238727AbhHQIMa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 04:12:30 -0400
Received: from mail-wm1-x34a.google.com (mail-wm1-x34a.google.com [IPv6:2a00:1450:4864:20::34a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21884C06179A
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 01:11:57 -0700 (PDT)
Received: by mail-wm1-x34a.google.com with SMTP id m13-20020a7bcf2d000000b002e6cd9941a9so701582wmg.1
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 01:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=8n83SYPJFagVj2+maLVaB3cngisvORRV9MwxIVnJLmI=;
        b=QK/oT43c/HyLP/flGctPFGgv7ERt829+s64w8tFk/HXu62cv5ewT8zROH3wOTe2tvj
         /aS4rS4XvL+VdJ9fohamgn6Nyg59PZxWDrodzia7PUArQfMO26PTAh+H6xoSWEEE3mr9
         dDmCJJ0j+3nII+H807f9g0TIew5R2UMyYDEfLyjS2RBXhILL7blWPMY7mBzm07CD2FZV
         R8adqZDTDufewJarzOCN7pgqdsv7Vx+iayW4OdoLDVJoz3VzmOcOn+/+N4eEAJqA5HBX
         c3eEB1npKGLlrrR/cCsOka1MAFIAwLC4Wyfv2oF357gfPE6pnUPWzc5uT0kVfitF8n0b
         Bl7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=8n83SYPJFagVj2+maLVaB3cngisvORRV9MwxIVnJLmI=;
        b=k2bwFLCjAf1Iqw6jItlq97pcR5Roxo7coQqNKAcbT5HEn77eryqTnctg7WjlIqkkZa
         0bSvxAD/5wQoQaTnfwWwEfYBNvBbqBtbxIApfUzTCQeJSJzx5VS1tyUMYbse72pJJhpk
         nK2A3dNzEi+1b3+1CJTif8Ur9xOmirN6WKfQqW6KRQ1aMkrroRwzkVcSvEGMi2ZQp2qq
         6FzweJ9l+g/N5eFlDnn4T4XOvraF63Ndje5hkM07TQ8kUWnoT6nBj3mJ/zEJr25uGyU6
         KOY9axfpWAccRc1Zv2tMX+GZy/gsURmZ/z/Jl+LSr9D57eh9JXtoIJcUDCZFxyCIzYgH
         rq2w==
X-Gm-Message-State: AOAM530vAQZoxBCkQl4sfaMpAEo7f5HCraj4n8mw8rYrw/OBeH2tmDPN
        L6HbBZeaTIST5IYiRCNTbBfXT++Ydw==
X-Google-Smtp-Source: ABdhPJyTMMnMvo44W4iioAshOfXYGiB/EBOESDhi7wJydM3Tnpejk+WoPKZaFjTVp97hac/tbSdCEeXM2g==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:600c:5116:: with SMTP id
 o22mr227673wms.0.1629187915361; Tue, 17 Aug 2021 01:11:55 -0700 (PDT)
Date:   Tue, 17 Aug 2021 09:11:28 +0100
In-Reply-To: <20210817081134.2918285-1-tabba@google.com>
Message-Id: <20210817081134.2918285-10-tabba@google.com>
Mime-Version: 1.0
References: <20210817081134.2918285-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v4 09/15] KVM: arm64: Add feature register flag definitions
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, oupton@google.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add feature register flag definitions to clarify which features
might be supported.

Consolidate the various ID_AA64PFR0_ELx flags for all ELs.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/cpufeature.h |  4 ++--
 arch/arm64/include/asm/sysreg.h     | 12 ++++++++----
 arch/arm64/kernel/cpufeature.c      |  8 ++++----
 3 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 9bb9d11750d7..b7d9bb17908d 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -602,14 +602,14 @@ static inline bool id_aa64pfr0_32bit_el1(u64 pfr0)
 {
 	u32 val = cpuid_feature_extract_unsigned_field(pfr0, ID_AA64PFR0_EL1_SHIFT);
 
-	return val == ID_AA64PFR0_EL1_32BIT_64BIT;
+	return val == ID_AA64PFR0_ELx_32BIT_64BIT;
 }
 
 static inline bool id_aa64pfr0_32bit_el0(u64 pfr0)
 {
 	u32 val = cpuid_feature_extract_unsigned_field(pfr0, ID_AA64PFR0_EL0_SHIFT);
 
-	return val == ID_AA64PFR0_EL0_32BIT_64BIT;
+	return val == ID_AA64PFR0_ELx_32BIT_64BIT;
 }
 
 static inline bool id_aa64pfr0_sve(u64 pfr0)
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 53a93a9c5253..f84a00f5874d 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -784,14 +784,13 @@
 #define ID_AA64PFR0_AMU			0x1
 #define ID_AA64PFR0_SVE			0x1
 #define ID_AA64PFR0_RAS_V1		0x1
+#define ID_AA64PFR0_RAS_V1P1		0x2
 #define ID_AA64PFR0_FP_NI		0xf
 #define ID_AA64PFR0_FP_SUPPORTED	0x0
 #define ID_AA64PFR0_ASIMD_NI		0xf
 #define ID_AA64PFR0_ASIMD_SUPPORTED	0x0
-#define ID_AA64PFR0_EL1_64BIT_ONLY	0x1
-#define ID_AA64PFR0_EL1_32BIT_64BIT	0x2
-#define ID_AA64PFR0_EL0_64BIT_ONLY	0x1
-#define ID_AA64PFR0_EL0_32BIT_64BIT	0x2
+#define ID_AA64PFR0_ELx_64BIT_ONLY	0x1
+#define ID_AA64PFR0_ELx_32BIT_64BIT	0x2
 
 /* id_aa64pfr1 */
 #define ID_AA64PFR1_MPAMFRAC_SHIFT	16
@@ -847,12 +846,16 @@
 #define ID_AA64MMFR0_ASID_SHIFT		4
 #define ID_AA64MMFR0_PARANGE_SHIFT	0
 
+#define ID_AA64MMFR0_ASID_8		0x0
+#define ID_AA64MMFR0_ASID_16		0x2
+
 #define ID_AA64MMFR0_TGRAN4_NI		0xf
 #define ID_AA64MMFR0_TGRAN4_SUPPORTED	0x0
 #define ID_AA64MMFR0_TGRAN64_NI		0xf
 #define ID_AA64MMFR0_TGRAN64_SUPPORTED	0x0
 #define ID_AA64MMFR0_TGRAN16_NI		0x0
 #define ID_AA64MMFR0_TGRAN16_SUPPORTED	0x1
+#define ID_AA64MMFR0_PARANGE_40		0x2
 #define ID_AA64MMFR0_PARANGE_48		0x5
 #define ID_AA64MMFR0_PARANGE_52		0x6
 
@@ -900,6 +903,7 @@
 #define ID_AA64MMFR2_CNP_SHIFT		0
 
 /* id_aa64dfr0 */
+#define ID_AA64DFR0_MTPMU_SHIFT		48
 #define ID_AA64DFR0_TRBE_SHIFT		44
 #define ID_AA64DFR0_TRACE_FILT_SHIFT	40
 #define ID_AA64DFR0_DOUBLELOCK_SHIFT	36
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 0ead8bfedf20..5b59fe5e26e4 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -239,8 +239,8 @@ static const struct arm64_ftr_bits ftr_id_aa64pfr0[] = {
 	S_ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_FP_SHIFT, 4, ID_AA64PFR0_FP_NI),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL3_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL2_SHIFT, 4, 0),
-	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_SHIFT, 4, ID_AA64PFR0_EL1_64BIT_ONLY),
-	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL0_SHIFT, 4, ID_AA64PFR0_EL0_64BIT_ONLY),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_SHIFT, 4, ID_AA64PFR0_ELx_64BIT_ONLY),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL0_SHIFT, 4, ID_AA64PFR0_ELx_64BIT_ONLY),
 	ARM64_FTR_END,
 };
 
@@ -1956,7 +1956,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.sys_reg = SYS_ID_AA64PFR0_EL1,
 		.sign = FTR_UNSIGNED,
 		.field_pos = ID_AA64PFR0_EL0_SHIFT,
-		.min_field_value = ID_AA64PFR0_EL0_32BIT_64BIT,
+		.min_field_value = ID_AA64PFR0_ELx_32BIT_64BIT,
 	},
 #ifdef CONFIG_KVM
 	{
@@ -1967,7 +1967,7 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.sys_reg = SYS_ID_AA64PFR0_EL1,
 		.sign = FTR_UNSIGNED,
 		.field_pos = ID_AA64PFR0_EL1_SHIFT,
-		.min_field_value = ID_AA64PFR0_EL1_32BIT_64BIT,
+		.min_field_value = ID_AA64PFR0_ELx_32BIT_64BIT,
 	},
 	{
 		.desc = "Protected KVM",
-- 
2.33.0.rc1.237.g0d66db33f3-goog

