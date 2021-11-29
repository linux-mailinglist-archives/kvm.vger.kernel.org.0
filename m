Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD2CA462338
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 22:24:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbhK2V2B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 16:28:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbhK2VZu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 16:25:50 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 768AFC091D34
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 12:07:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E343BCE1415
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 20:07:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39F8EC53FCF;
        Mon, 29 Nov 2021 20:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638216438;
        bh=rMT0KBgk12w5iRVerxRsvVEXfThM4QCeR6Jk8Pujwmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rifcdI6l8WjhlLYjlt/9A6EMsAB9GdnMU4eiuEtIzAO1i/Od2g3mO2w5RNtVwWDmN
         IbgHIgjjF/nnq/AOrbHots+bw1v33BrnB6KkshFZr3oN7U4utMAn1W1fS3MiLo3tJ4
         DdIps38jYXnRL60ZU4nSFdsA54J1lwTHKrbpkWUfDEWTBc0A6FysveNj3NIhwGhapf
         CluvdxALrXbCF49TKgQMIpNo3kIGtT6tOJ0fGGE/h7+F0nHOgeuvNkn0f+99X+384a
         MHBs9P7WgrW2wk2j31MhSTgDAnnqdoxarLwLnBu/w2fbhoMJYf8xyJNK3ZESGxZURK
         HxqdXh7NDbQRg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mrmqs-008gvR-OK; Mon, 29 Nov 2021 20:02:14 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH v5 17/69] KVM: arm64: nv: Add non-VHE-EL2->EL1 translation helpers
Date:   Mon, 29 Nov 2021 20:00:58 +0000
Message-Id: <20211129200150.351436-18-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211129200150.351436-1-maz@kernel.org>
References: <20211129200150.351436-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org, gankulkarni@os.amperecomputing.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some EL2 system registers immediately affect the current execution
of the system, so we need to use their respective EL1 counterparts.
For this we need to define a mapping between the two. In general,
this only affects non-VHE guest hypervisors, as VHE system registers
are compatible with the EL1 counterparts.

These helpers will get used in subsequent patches.

Co-developed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h | 50 +++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 1028ac65a897..67a2c0d05233 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -2,6 +2,7 @@
 #ifndef __ARM64_KVM_NESTED_H
 #define __ARM64_KVM_NESTED_H
 
+#include <linux/bitfield.h>
 #include <linux/kvm_host.h>
 
 static inline bool nested_virt_in_use(const struct kvm_vcpu *vcpu)
@@ -11,4 +12,53 @@ static inline bool nested_virt_in_use(const struct kvm_vcpu *vcpu)
 		test_bit(KVM_ARM_VCPU_HAS_EL2, vcpu->arch.features));
 }
 
+/* Translation helpers from non-VHE EL2 to EL1 */
+static inline u64 tcr_el2_ips_to_tcr_el1_ps(u64 tcr_el2)
+{
+	return (u64)FIELD_GET(TCR_EL2_PS_MASK, tcr_el2) << TCR_IPS_SHIFT;
+}
+
+static inline u64 translate_tcr_el2_to_tcr_el1(u64 tcr)
+{
+	return TCR_EPD1_MASK |				/* disable TTBR1_EL1 */
+	       ((tcr & TCR_EL2_TBI) ? TCR_TBI0 : 0) |
+	       tcr_el2_ips_to_tcr_el1_ps(tcr) |
+	       (tcr & TCR_EL2_TG0_MASK) |
+	       (tcr & TCR_EL2_ORGN0_MASK) |
+	       (tcr & TCR_EL2_IRGN0_MASK) |
+	       (tcr & TCR_EL2_T0SZ_MASK);
+}
+
+static inline u64 translate_cptr_el2_to_cpacr_el1(u64 cptr_el2)
+{
+	u64 cpacr_el1 = 0;
+
+	if (!(cptr_el2 & CPTR_EL2_TFP))
+		cpacr_el1 |= CPACR_EL1_FPEN;
+	if (cptr_el2 & CPTR_EL2_TTA)
+		cpacr_el1 |= CPACR_EL1_TTA;
+	if (!(cptr_el2 & CPTR_EL2_TZ))
+		cpacr_el1 |= CPACR_EL1_ZEN;
+
+	return cpacr_el1;
+}
+
+static inline u64 translate_sctlr_el2_to_sctlr_el1(u64 sctlr)
+{
+	/* Bit 20 is RES1 in SCTLR_EL1, but RES0 in SCTLR_EL2 */
+	return sctlr | BIT(20);
+}
+
+static inline u64 translate_ttbr0_el2_to_ttbr0_el1(u64 ttbr0)
+{
+	/* Force ASID to 0 (ASID 0 or RES0) */
+	return ttbr0 & ~GENMASK_ULL(63, 48);
+}
+
+static inline u64 translate_cnthctl_el2_to_cntkctl_el1(u64 cnthctl)
+{
+	return ((FIELD_GET(CNTHCTL_EL1PCTEN | CNTHCTL_EL1PCEN, cnthctl) << 10) |
+		(cnthctl & (CNTHCTL_EVNTI | CNTHCTL_EVNTDIR | CNTHCTL_EVNTEN)));
+}
+
 #endif /* __ARM64_KVM_NESTED_H */
-- 
2.30.2

