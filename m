Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC94D2D611D
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 17:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392215AbgLJQFE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 11:05:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:33713 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389270AbgLJQEw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 11:04:52 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 319E423E23;
        Thu, 10 Dec 2020 16:03:39 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1knOMw-0008Di-TH; Thu, 10 Dec 2020 16:00:39 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: [PATCH v3 12/66] KVM: arm64: nv: Add non-VHE-EL2->EL1 translation helpers
Date:   Thu, 10 Dec 2020 15:59:08 +0000
Message-Id: <20201210160002.1407373-13-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210160002.1407373-1-maz@kernel.org>
References: <20201210160002.1407373-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
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
2.29.2

