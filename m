Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08AF349F94D
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 13:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbiA1MUi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 07:20:38 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36762 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244625AbiA1MUe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jan 2022 07:20:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3A9161AE3
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 12:20:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26BCEC340E6;
        Fri, 28 Jan 2022 12:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643372433;
        bh=3PY/KiEXKKxLcqJJPlQhFgcYakO73uXAksXsPPX1TEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nwa6CGkV+djEijpXdwjDSR0bvqCR2aogT9mu2Fo/9VRP3ivIoT6+zby1CyA3Uq6kJ
         4872551kq28nueVIv2lbUxsQh4FGVcYoUCBPyFtF24CcajgW4CNES8D1uq1XhqEjbq
         4sGaFssdqWhLXab7nD5IKpWoBmOzlMBmZuBLzA9juSsu65Cqoh1RGsMjPCwzExejLY
         4iotwqBbjC2E8hDxhXjd1GlFcwbi7yN9pS4O0hBWphYq6EkBgflfpafeMzBUkZ1oal
         UShwbOgHST8vQUNcRbsWAmSz5O0/2xF4ENx3uh1jMexbcfSIDZKp8nvtwTiR0pSf5B
         T3IAEHjx3xdfQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nDQDw-003njR-FZ; Fri, 28 Jan 2022 12:19:28 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Chase Conklin <chase.conklin@arm.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        karl.heubaum@oracle.com, mihai.carabas@oracle.com,
        miguel.luis@oracle.com, kernel-team@android.com
Subject: [PATCH v6 12/64] KVM: arm64: nv: Add non-VHE-EL2->EL1 translation helpers
Date:   Fri, 28 Jan 2022 12:18:20 +0000
Message-Id: <20220128121912.509006-13-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220128121912.509006-1-maz@kernel.org>
References: <20220128121912.509006-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org, gankulkarni@os.amperecomputing.com, chase.conklin@arm.com, linux@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, karl.heubaum@oracle.com, mihai.carabas@oracle.com, miguel.luis@oracle.com, kernel-team@android.com
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
 arch/arm64/include/asm/kvm_nested.h | 54 +++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index fd601ea68d13..5a85be6d8eb3 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -2,6 +2,7 @@
 #ifndef __ARM64_KVM_NESTED_H
 #define __ARM64_KVM_NESTED_H
 
+#include <linux/bitfield.h>
 #include <linux/kvm_host.h>
 
 static inline bool vcpu_has_nv(const struct kvm_vcpu *vcpu)
@@ -11,4 +12,57 @@ static inline bool vcpu_has_nv(const struct kvm_vcpu *vcpu)
 		test_bit(KVM_ARM_VCPU_HAS_EL2, vcpu->arch.features));
 }
 
+/* Translation helpers from non-VHE EL2 to EL1 */
+static inline u64 tcr_el2_ps_to_tcr_el1_ips(u64 tcr_el2)
+{
+	return (u64)FIELD_GET(TCR_EL2_PS_MASK, tcr_el2) << TCR_IPS_SHIFT;
+}
+
+static inline u64 translate_tcr_el2_to_tcr_el1(u64 tcr)
+{
+	return TCR_EPD1_MASK |				/* disable TTBR1_EL1 */
+	       ((tcr & TCR_EL2_TBI) ? TCR_TBI0 : 0) |
+	       tcr_el2_ps_to_tcr_el1_ips(tcr) |
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
+	if (cptr_el2 & CPTR_EL2_TTA)
+		cpacr_el1 |= CPACR_EL1_TTA;
+	if (!(cptr_el2 & CPTR_EL2_TFP))
+		cpacr_el1 |= CPACR_EL1_FPEN;
+	if (!(cptr_el2 & CPTR_EL2_TZ))
+		cpacr_el1 |= CPACR_EL1_ZEN;
+
+	return cpacr_el1;
+}
+
+static inline u64 translate_sctlr_el2_to_sctlr_el1(u64 val)
+{
+	/* Only preserve the minimal set of bits we support */
+	val &= (SCTLR_ELx_M | SCTLR_ELx_A | SCTLR_ELx_C | SCTLR_ELx_SA |
+		SCTLR_ELx_I | SCTLR_ELx_IESB | SCTLR_ELx_WXN | SCTLR_ELx_EE);
+	val |= SCTLR_EL1_RES1;
+
+	return val;
+}
+
+static inline u64 translate_ttbr0_el2_to_ttbr0_el1(u64 ttbr0)
+{
+	/* Clear the ASID field */
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

