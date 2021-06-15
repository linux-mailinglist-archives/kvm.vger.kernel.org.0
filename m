Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE8A63A80F2
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 15:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbhFONm6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 09:42:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbhFONmj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 09:42:39 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EED4C061155
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 06:40:08 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id r8-20020a0562140c88b0290242bf8596feso10141940qvr.8
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 06:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=VfQdAQ7uIcnnol8WP3MAJ1Qz658s3J1UAqg2ZESplQg=;
        b=GB/OvLpHWQYkKpx5cgIPjSsgiCO/0SeHHg00IV+R5EwwGvpPUuJ3NyWsINgNyYiLdN
         mlosuQ5GgTlh/ZcIpP+badUaqisRGZC2wpy9jO/4zvpbzRgJbl4PbzOcCG2RCFZe60d1
         Qr/RiVEUELDt7POppvOCqJWRfXeT9spPt802g4JxuiCMJvc8RpbjYWNU0liaknwaxKuL
         6EKmTmWVU3arkrg0YeIB9RUg3H4ErXxDjyw1IZuhm0sOT1kg/ptyaR86/nKC7qJbkACd
         m7eihAKvPfx3vCyQ4Ji7W6wzuN2vBQb06Qo9agdogEOTRo+KJba8K4R1anCGuQJdk8Fl
         exAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VfQdAQ7uIcnnol8WP3MAJ1Qz658s3J1UAqg2ZESplQg=;
        b=TRtVqvce7lO3a8EAF3D2Smm+ZrP4/mdbumDK4ISNDZL8eakoBAKezRh10iZcxNP8iR
         WHB9kN9atc8IAhPzziP6JqXFn1kKrZnY+WO6UTSpG/aX2SDNLw5SQ6sDqdmGgbCHRkbh
         Q4kGPqI4Lf5ej8n3S42Tf8gzNaLErPpQ9mvXFp21NhqG5S1JXs36Q/K6f2A6prFRwlcB
         vr1XTB3pGyOI2ZKL74e5AY9EVQKAV07rxlhCPO0Dox3FdANeEM/qW1c5gHRkHltmDAlm
         UHjPxWR8BFBqXO3jwwpX1GmPzAldkR8ym0Knt8En+BkPBP9l2HuM2rAXf1iWOPFwuBw2
         57iQ==
X-Gm-Message-State: AOAM531RuqYVvimQPiGtJGU0ls9rHUW1o021S8ZpHKQ+SZaEpX2bjYeP
        rrpqu8spQt5DCZHUsddKCPKyXV82Wg==
X-Google-Smtp-Source: ABdhPJw8Gldeq6H0br2wzbB7/Hq61EgLe84lN0RJB8PupfGJ53qUB5Sd72DFkV2IO1ScQLocofjUKZqheg==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:ad4:450b:: with SMTP id k11mr4520634qvu.0.1623764407702;
 Tue, 15 Jun 2021 06:40:07 -0700 (PDT)
Date:   Tue, 15 Jun 2021 14:39:44 +0100
In-Reply-To: <20210615133950.693489-1-tabba@google.com>
Message-Id: <20210615133950.693489-8-tabba@google.com>
Mime-Version: 1.0
References: <20210615133950.693489-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH v2 07/13] KVM: arm64: Add config register bit definitions
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

Add hardware configuration register bit definitions for HCR_EL2
and MDCR_EL2. Future patches toggle these hyp configuration
register bits to trap on certain accesses.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_arm.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index bee1ba6773fb..a78090071f1f 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -12,7 +12,11 @@
 #include <asm/types.h>
 
 /* Hyp Configuration Register (HCR) bits */
+#define HCR_TID5	(UL(1) << 58)
+#define HCR_DCT		(UL(1) << 57)
 #define HCR_ATA		(UL(1) << 56)
+#define HCR_AMVOFFEN	(UL(1) << 51)
+#define HCR_FIEN	(UL(1) << 47)
 #define HCR_FWB		(UL(1) << 46)
 #define HCR_API		(UL(1) << 41)
 #define HCR_APK		(UL(1) << 40)
@@ -55,6 +59,7 @@
 #define HCR_PTW		(UL(1) << 2)
 #define HCR_SWIO	(UL(1) << 1)
 #define HCR_VM		(UL(1) << 0)
+#define HCR_RES0	((UL(1) << 48) | (UL(1) << 39))
 
 /*
  * The bits we set in HCR:
@@ -276,11 +281,21 @@
 #define CPTR_EL2_TZ	(1 << 8)
 #define CPTR_NVHE_EL2_RES1	0x000032ff /* known RES1 bits in CPTR_EL2 (nVHE) */
 #define CPTR_EL2_DEFAULT	CPTR_NVHE_EL2_RES1
+#define CPTR_NVHE_EL2_RES0	(GENMASK_ULL(63, 32) |	\
+				 GENMASK_ULL(29, 21) |	\
+				 GENMASK_ULL(19, 14) |	\
+				 (UL(1) << 11))
 
 /* Hyp Debug Configuration Register bits */
 #define MDCR_EL2_E2TB_MASK	(UL(0x3))
 #define MDCR_EL2_E2TB_SHIFT	(UL(24))
+#define MDCR_EL2_HPMFZS		(UL(1) << 36)
+#define MDCR_EL2_HPMFZO		(UL(1) << 29)
+#define MDCR_EL2_MTPME		(UL(1) << 28)
+#define MDCR_EL2_TDCC		(UL(1) << 27)
+#define MDCR_EL2_HCCD		(UL(1) << 23)
 #define MDCR_EL2_TTRF		(UL(1) << 19)
+#define MDCR_EL2_HPMD		(UL(1) << 17)
 #define MDCR_EL2_TPMS		(UL(1) << 14)
 #define MDCR_EL2_E2PB_MASK	(UL(0x3))
 #define MDCR_EL2_E2PB_SHIFT	(UL(12))
@@ -292,6 +307,12 @@
 #define MDCR_EL2_TPM		(UL(1) << 6)
 #define MDCR_EL2_TPMCR		(UL(1) << 5)
 #define MDCR_EL2_HPMN_MASK	(UL(0x1F))
+#define MDCR_EL2_RES0		(GENMASK_ULL(63, 37) |	\
+				 GENMASK_ULL(35, 30) |	\
+				 GENMASK_ULL(25, 24) |	\
+				 GENMASK_ULL(22, 20) |	\
+				 (UL(1) << 18) |	\
+				 GENMASK_ULL(16, 15))
 
 /* For compatibility with fault code shared with 32-bit */
 #define FSC_FAULT	ESR_ELx_FSC_FAULT
-- 
2.32.0.272.g935e593368-goog

