Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D90B73CE512
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 18:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241593AbhGSPrk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 11:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350267AbhGSPpq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 11:45:46 -0400
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91EC7C0ABCA7
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 08:38:24 -0700 (PDT)
Received: by mail-wr1-x44a.google.com with SMTP id k3-20020a5d52430000b0290138092aea94so8966557wrc.20
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 09:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=vw+9k8TKpKtQTjxQwt2hnUGZ2NjHx/OJWiEJkCkz1N4=;
        b=sLPNtiMKmja20KaICWALYJ4ofuflIkIOE7nOQiX2tSdy3n44fa65SqsexcWWzl79/k
         Z7NBRtSnzz84wnQ6qLdJBL9GKE6UqQRfIh9ZD/Zoc8s71akMHsfvR8BYC9nCYfsXApFF
         MIS5H9GeVm2hzhNrZefd/v7Iq5w9JKQ+ZNYm981SW4oHqDsDNDynCD92CM8+0qbF0RdZ
         6XxEFgfBgwlbMM19NhgJBIln16v5px7eZiRLqfqSDmJiQl05wtPSSWN7FF6W6wdd5xTW
         PJBOFw3SNSRE5rRfXYRnucerBoTwqihx1C3ukxGoX4Azbb2q1755m61BUT1R25v9ql7K
         3rpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=vw+9k8TKpKtQTjxQwt2hnUGZ2NjHx/OJWiEJkCkz1N4=;
        b=gTlgrkaQkv08qsY4WApew54feNdgj4+6spL09pwGGDAYJQ6jsqq/n6j1QUpQCuYc0T
         Z6AaWG6cHop/cc0c9FC4JHamRbYHKbQDZ4QZYoHyaY47cDjxfrpvXEuGtCOCS3/axulb
         y0bDVvP20se0z49LuUlPwOtoAG7S/HmnIunbkVA3LVAl4Xv+gYuaCLM5mp5PFRPmzPzS
         nc4tGHE0W5EcllZNSuMgynPNqcITSmVfLksYdBOU+4cW4p/Spfn+BMabbtGDEOdPQlXQ
         I2fBwVjadfLTvtrPMJvnxBWaPC0asQ7Zi79bM4IpS8uNJvrMXE5eMdFpXw+mD4NzdE/n
         dKjQ==
X-Gm-Message-State: AOAM533RLbMwpSSWiuXKUSbw6AuR4H+sjONag1Yrsim7Nvvtbr+vgkUn
        5RCi81SVAV21EcrdVHpH40iTm17AaA==
X-Google-Smtp-Source: ABdhPJwqgGr1dc9ElvS+DtbtyF4398Jwb9HePJzbzjhsmwOOPQEhoV8D79HvGRx3Y9ug0QbreOeQr0qtmQ==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:adf:ea0f:: with SMTP id q15mr30547671wrm.145.1626710646765;
 Mon, 19 Jul 2021 09:04:06 -0700 (PDT)
Date:   Mon, 19 Jul 2021 17:03:40 +0100
In-Reply-To: <20210719160346.609914-1-tabba@google.com>
Message-Id: <20210719160346.609914-10-tabba@google.com>
Mime-Version: 1.0
References: <20210719160346.609914-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v3 09/15] KVM: arm64: Add config register bit definitions
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
 arch/arm64/include/asm/kvm_arm.h | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index a928b2dc0b0f..327120c0089f 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -12,8 +12,13 @@
 #include <asm/types.h>
 
 /* Hyp Configuration Register (HCR) bits */
+
+#define HCR_TID5	(UL(1) << 58)
+#define HCR_DCT		(UL(1) << 57)
 #define HCR_ATA_SHIFT	56
 #define HCR_ATA		(UL(1) << HCR_ATA_SHIFT)
+#define HCR_AMVOFFEN	(UL(1) << 51)
+#define HCR_FIEN	(UL(1) << 47)
 #define HCR_FWB		(UL(1) << 46)
 #define HCR_API		(UL(1) << 41)
 #define HCR_APK		(UL(1) << 40)
@@ -56,6 +61,7 @@
 #define HCR_PTW		(UL(1) << 2)
 #define HCR_SWIO	(UL(1) << 1)
 #define HCR_VM		(UL(1) << 0)
+#define HCR_RES0	((UL(1) << 48) | (UL(1) << 39))
 
 /*
  * The bits we set in HCR:
@@ -277,11 +283,21 @@
 #define CPTR_EL2_TZ	(1 << 8)
 #define CPTR_NVHE_EL2_RES1	0x000032ff /* known RES1 bits in CPTR_EL2 (nVHE) */
 #define CPTR_EL2_DEFAULT	CPTR_NVHE_EL2_RES1
+#define CPTR_NVHE_EL2_RES0	(GENMASK(63, 32) |	\
+				 GENMASK(29, 21) |	\
+				 GENMASK(19, 14) |	\
+				 BIT(11))
 
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
@@ -293,6 +309,12 @@
 #define MDCR_EL2_TPM		(UL(1) << 6)
 #define MDCR_EL2_TPMCR		(UL(1) << 5)
 #define MDCR_EL2_HPMN_MASK	(UL(0x1F))
+#define MDCR_EL2_RES0		(GENMASK(63, 37) |	\
+				 GENMASK(35, 30) |	\
+				 GENMASK(25, 24) |	\
+				 GENMASK(22, 20) |	\
+				 BIT(18) |		\
+				 GENMASK(16, 15))
 
 /* For compatibility with fault code shared with 32-bit */
 #define FSC_FAULT	ESR_ELx_FSC_FAULT
-- 
2.32.0.402.g57bb445576-goog

