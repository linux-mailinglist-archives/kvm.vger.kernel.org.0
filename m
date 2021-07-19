Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A874F3CE51A
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 18:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243017AbhGSPrn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 11:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350266AbhGSPpq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 11:45:46 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE16C0225B1
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 08:38:10 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 132-20020a25158a0000b029055791ebe1e6so26126547ybv.20
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 09:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=gj5azJ/ULXVcRTckLTYz4tzYt46atrxa1NlVggC1Nmc=;
        b=LHtfRYwLX9nQwkfUKOswjmlWdg5rsMjtYduQo4pdQJPUIUGISuTCceoDTnWBdXbtKY
         PcF5qwXUmbJQ3xFqiQrZancOO9Kye/UKkIIUd+uqStOA+EbRjShQ2VT1U/VHALXwB/Yr
         bCt/x2uRgW63pw34dMXL7ENNzIYkf8O0kM12GdNvSZEQ3nU5gY+Zzco0i+kj1xrCg1rI
         z4hgo9VtaoncdacrrY8f+3APWGzbakN+pQ7zLc5kTSUXNZWYQDT1AnOoDB4l3287TbUu
         7H+GP9/co87qpbeGNDVnwjsd1RB/P+ES/zJp9dsnmCQSa97toNB2NUKNfnI8w3MLB0AU
         rXDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=gj5azJ/ULXVcRTckLTYz4tzYt46atrxa1NlVggC1Nmc=;
        b=skqvRhxLua2AM6Og/o5df6uzAKUjgzSvf4ZOR114v+3U1cn7z/f8xjrNFKLym4PA+t
         J4ktyXHd8QDyXAP/HozO91U9zFa9JPIIPDhkhGyseWaPhhnq3fBf3P3DEJRibEvA+nmA
         Vc5pnlRHR+BVL7Og++NKJB6om55NQnXlYgCapYiQ92GestTDnH0Z5OFjjljl+B6nxSB+
         ijBD48KAvuBjXXe/WN7ovEA7nDUgL4abJ6FvJS95igha+2oIZr30D787/Wm2gAWp+68h
         Wx7CyjpjRFzvob1MrLGbkryvBYH8mpl9uz7McfIGsXHVFilvOawwPSfQXqkFYdAIazkb
         nKqA==
X-Gm-Message-State: AOAM533HhmycSyPuoO294JKAoxwjlNvQD5VN0ErzBii2Br2pvvTLRUrC
        UbNaL2koxrLAXyX91g4hZpgB8oiELg==
X-Google-Smtp-Source: ABdhPJyvBo0xrNE2JiKYrS+c1sAe20vSLOrHLMh9ty2cNjsLsVeW9KuuuUUBMIH7s3qqfMMxGZ4+xHb/7g==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a25:e08a:: with SMTP id x132mr33206480ybg.511.1626710634535;
 Mon, 19 Jul 2021 09:03:54 -0700 (PDT)
Date:   Mon, 19 Jul 2021 17:03:34 +0100
In-Reply-To: <20210719160346.609914-1-tabba@google.com>
Message-Id: <20210719160346.609914-4-tabba@google.com>
Mime-Version: 1.0
References: <20210719160346.609914-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v3 03/15] KVM: arm64: MDCR_EL2 is a 64-bit register
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

Fix the places in KVM that treat MDCR_EL2 as a 32-bit register.
More recent features (e.g., FEAT_SPEv1p2) use bits above 31.

No functional change intended.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_arm.h   | 20 ++++++++++----------
 arch/arm64/include/asm/kvm_asm.h   |  2 +-
 arch/arm64/include/asm/kvm_host.h  |  2 +-
 arch/arm64/kvm/debug.c             |  2 +-
 arch/arm64/kvm/hyp/nvhe/debug-sr.c |  2 +-
 arch/arm64/kvm/hyp/vhe/debug-sr.c  |  2 +-
 6 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index d436831dd706..6a523ec83415 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -281,18 +281,18 @@
 /* Hyp Debug Configuration Register bits */
 #define MDCR_EL2_E2TB_MASK	(UL(0x3))
 #define MDCR_EL2_E2TB_SHIFT	(UL(24))
-#define MDCR_EL2_TTRF		(1 << 19)
-#define MDCR_EL2_TPMS		(1 << 14)
+#define MDCR_EL2_TTRF		(UL(1) << 19)
+#define MDCR_EL2_TPMS		(UL(1) << 14)
 #define MDCR_EL2_E2PB_MASK	(UL(0x3))
 #define MDCR_EL2_E2PB_SHIFT	(UL(12))
-#define MDCR_EL2_TDRA		(1 << 11)
-#define MDCR_EL2_TDOSA		(1 << 10)
-#define MDCR_EL2_TDA		(1 << 9)
-#define MDCR_EL2_TDE		(1 << 8)
-#define MDCR_EL2_HPME		(1 << 7)
-#define MDCR_EL2_TPM		(1 << 6)
-#define MDCR_EL2_TPMCR		(1 << 5)
-#define MDCR_EL2_HPMN_MASK	(0x1F)
+#define MDCR_EL2_TDRA		(UL(1) << 11)
+#define MDCR_EL2_TDOSA		(UL(1) << 10)
+#define MDCR_EL2_TDA		(UL(1) << 9)
+#define MDCR_EL2_TDE		(UL(1) << 8)
+#define MDCR_EL2_HPME		(UL(1) << 7)
+#define MDCR_EL2_TPM		(UL(1) << 6)
+#define MDCR_EL2_TPMCR		(UL(1) << 5)
+#define MDCR_EL2_HPMN_MASK	(UL(0x1F))
 
 /* For compatibility with fault code shared with 32-bit */
 #define FSC_FAULT	ESR_ELx_FSC_FAULT
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 9f0bf2109be7..63ead9060ab5 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -210,7 +210,7 @@ extern u64 __vgic_v3_read_vmcr(void);
 extern void __vgic_v3_write_vmcr(u32 vmcr);
 extern void __vgic_v3_init_lrs(void);
 
-extern u32 __kvm_get_mdcr_el2(void);
+extern u64 __kvm_get_mdcr_el2(void);
 
 #define __KVM_EXTABLE(from, to)						\
 	"	.pushsection	__kvm_ex_table, \"a\"\n"		\
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 347781f99b6a..4d2d974c1522 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -289,7 +289,7 @@ struct kvm_vcpu_arch {
 
 	/* HYP configuration */
 	u64 hcr_el2;
-	u32 mdcr_el2;
+	u64 mdcr_el2;
 
 	/* Exception Information */
 	struct kvm_vcpu_fault_info fault;
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index d5e79d7ee6e9..db9361338b2a 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -21,7 +21,7 @@
 				DBG_MDSCR_KDE | \
 				DBG_MDSCR_MDE)
 
-static DEFINE_PER_CPU(u32, mdcr_el2);
+static DEFINE_PER_CPU(u64, mdcr_el2);
 
 /**
  * save/restore_guest_debug_regs
diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
index 7d3f25868cae..df361d839902 100644
--- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
@@ -109,7 +109,7 @@ void __debug_switch_to_host(struct kvm_vcpu *vcpu)
 	__debug_switch_to_host_common(vcpu);
 }
 
-u32 __kvm_get_mdcr_el2(void)
+u64 __kvm_get_mdcr_el2(void)
 {
 	return read_sysreg(mdcr_el2);
 }
diff --git a/arch/arm64/kvm/hyp/vhe/debug-sr.c b/arch/arm64/kvm/hyp/vhe/debug-sr.c
index f1e2e5a00933..289689b2682d 100644
--- a/arch/arm64/kvm/hyp/vhe/debug-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/debug-sr.c
@@ -20,7 +20,7 @@ void __debug_switch_to_host(struct kvm_vcpu *vcpu)
 	__debug_switch_to_host_common(vcpu);
 }
 
-u32 __kvm_get_mdcr_el2(void)
+u64 __kvm_get_mdcr_el2(void)
 {
 	return read_sysreg(mdcr_el2);
 }
-- 
2.32.0.402.g57bb445576-goog

