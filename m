Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3303CE51E
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 18:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344988AbhGSPrr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 11:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350264AbhGSPpq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 11:45:46 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74955C0ABCA6
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 08:38:21 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id d9-20020ac84e290000b0290256a44e9034so9600461qtw.22
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 09:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=V9acI6EDUhR6tDfpqD9I6jrvJeuKAdMZUkQ+s858Nww=;
        b=BTpC1hwjiWVrUEkLbLdoxGFsQTsMQ7ua3qjmKq/cWq8pEdtqNoaW1vlJJr/8xIcdGW
         51tQOla73fd6ozBrfWwYvU0fK7r4h2tePvxtQPbPru4f1iWcoMPyT//2OXb5xJXcrfqE
         1SP8DZ1RGUOTDRVjV41OZd4ZWeitV/jtLi0aD5igfY9HwuF9Gqr3/G94dawfUHvXF+n4
         +Ne/qeTtowBLUGLppz/g3dF6GlHFHI7UvavDhFMcsQe9k+B0+rgDuHt/y6XME9JECePm
         9dPiB/I11y4V43mNctHB9+dR85b5cj49lv/wMFuuZcrYFhRc5D99vGZDsiqenb7SYaUf
         M+cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=V9acI6EDUhR6tDfpqD9I6jrvJeuKAdMZUkQ+s858Nww=;
        b=LknAriT3i1HCKuVI4cznzuPTVGh2YVdUz8isXLBadxKSMmwrCXz3salsDdWD8ho5kF
         mQrYLj2summQ7qTkBVjWiLLRUJDzqDO1CqtqCoEzSP8AfGdhG+ySaNR7SSVSUC+6J+DY
         jCrIDLMa3dGlW+I6uN183t5aK5ivoYfHl1lOQRbnxt+tl1TjsNGWaIvNPNTjOosqfJuL
         1BQ/6WXAmkpZV3gqnoJ0586RTHKtthaajBPgM0SLr2iKyW0H5Pdp2vFRWZ8H2F9StEpW
         r1B9NGFqINpuUT8CsnMXpM2xiT9P3ZHjrsLcHAs6vUudFENBX+SqDAHbpV2nl3pK9K1m
         2/Pw==
X-Gm-Message-State: AOAM531T7S8L+KIAS9aEMywiNucXcGnq4vDj5IeijH0tCe8oW6LunIL/
        x1rLC1GBijBxXY6D/82a4ApDfvt86A==
X-Google-Smtp-Source: ABdhPJyyKsZdgx86oOpgbZLiHegl5Y1zod3kRSEavOWe7KLm5NM5K6J05rrWMdpFS4IHz+JdQ3I7DZHEMg==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a0c:a321:: with SMTP id u30mr25473018qvu.57.1626710644424;
 Mon, 19 Jul 2021 09:04:04 -0700 (PDT)
Date:   Mon, 19 Jul 2021 17:03:39 +0100
In-Reply-To: <20210719160346.609914-1-tabba@google.com>
Message-Id: <20210719160346.609914-9-tabba@google.com>
Mime-Version: 1.0
References: <20210719160346.609914-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v3 08/15] KVM: arm64: Add feature register flag definitions
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com, tabba@google.com
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
index 326f49e7bd42..0b773037251c 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -784,14 +784,13 @@
 #define ID_AA64PFR0_AMU			0x1
 #define ID_AA64PFR0_SVE			0x1
 #define ID_AA64PFR0_RAS_V1		0x1
+#define ID_AA64PFR0_RAS_ANY		0xf
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
2.32.0.402.g57bb445576-goog

