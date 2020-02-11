Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F03D91596EE
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 18:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbgBKRwR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 12:52:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:55064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730510AbgBKRwQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 12:52:16 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC8CE206D7;
        Tue, 11 Feb 2020 17:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581443535;
        bh=ZhtAktcHS7kLOup2NvpgDOoQKcyB6JCtjzXZAdkr4Qk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UgmYJQkYC3hHZJHVYsXADtdBJ9q7i1ZljH1Cn7dGgIgnysQiQloSvOcetNdf210gF
         Ea1E2EcQDCcWYA2yPtLqXuCONQR9i5234p48LVdWC/1k6o0j8E5vLS1Qb7n56zdq1y
         7JRG3UJ6sByguvvASvGAHxQ9+rooSbNix/z5nHlQ=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j1Zfo-004O7k-0J; Tue, 11 Feb 2020 17:50:12 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v2 32/94] KVM: arm64: nv: Filter out unsupported features from ID regs
Date:   Tue, 11 Feb 2020 17:48:36 +0000
Message-Id: <20200211174938.27809-33-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200211174938.27809-1-maz@kernel.org>
References: <20200211174938.27809-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As there is a number of features that we either can't support,
or don't want to support right away with NV, let's add some
basic filtering so that we don't advertize silly things to the
EL2 guest.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h |   6 ++
 arch/arm64/include/asm/sysreg.h     |  11 +++
 arch/arm64/kvm/nested.c             | 115 ++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c           |   5 +-
 4 files changed, 136 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 5911a713c7dd..c258572b5ed4 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -16,4 +16,10 @@ extern bool __forward_traps(struct kvm_vcpu *vcpu, unsigned int reg,
 extern bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit);
 extern bool forward_nv_traps(struct kvm_vcpu *vcpu);
 
+struct sys_reg_params;
+struct sys_reg_desc;
+
+void access_nested_id_reg(struct kvm_vcpu *v, struct sys_reg_params *p,
+			  const struct sys_reg_desc *r);
+
 #endif /* __ARM64_KVM_NESTED_H */
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 260c1cf683a2..360ef9e8dfe4 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -646,6 +646,9 @@
 #define ID_AA64PFR0_CSV3_SHIFT		60
 #define ID_AA64PFR0_CSV2_SHIFT		56
 #define ID_AA64PFR0_DIT_SHIFT		48
+#define ID_AA64PFR0_AMU_SHIFT		44
+#define ID_AA64PFR0_MPAM_SHIFT		40
+#define ID_AA64PFR0_SEL2_SHIFT		36
 #define ID_AA64PFR0_SVE_SHIFT		32
 #define ID_AA64PFR0_RAS_SHIFT		28
 #define ID_AA64PFR0_GIC_SHIFT		24
@@ -667,7 +670,9 @@
 #define ID_AA64PFR0_EL0_32BIT_64BIT	0x2
 
 /* id_aa64pfr1 */
+#define ID_AA64PFR1_MTE_SHIFT		8
 #define ID_AA64PFR1_SSBS_SHIFT		4
+#define ID_AA64PFR1_BT_SHIFT		0
 
 #define ID_AA64PFR1_SSBS_PSTATE_NI	0
 #define ID_AA64PFR1_SSBS_PSTATE_ONLY	1
@@ -721,6 +726,8 @@
 #endif
 
 /* id_aa64mmfr1 */
+#define ID_AA64MMFR1_XNX_SHIFT		28
+#define ID_AA64MMFR1_SpecSEI_SHIFT	24
 #define ID_AA64MMFR1_PAN_SHIFT		20
 #define ID_AA64MMFR1_LOR_SHIFT		16
 #define ID_AA64MMFR1_HPD_SHIFT		12
@@ -733,9 +740,13 @@
 
 /* id_aa64mmfr2 */
 #define ID_AA64MMFR2_E0PD_SHIFT		60
+#define ID_AA64MMFR2_EVT_SHIFT		56
+#define ID_AA64MMFR2_BBM_SHIFT		52
 #define ID_AA64MMFR2_FWB_SHIFT		40
 #define ID_AA64MMFR2_AT_SHIFT		32
+#define ID_AA64MMFR2_ST_SHIFT		28
 #define ID_AA64MMFR2_NV_SHIFT		24
+#define ID_AA64MMFR2_CCIDX_SHIFT	20
 #define ID_AA64MMFR2_LVA_SHIFT		16
 #define ID_AA64MMFR2_IESB_SHIFT		12
 #define ID_AA64MMFR2_LSM_SHIFT		8
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index c5e695cf81fb..cecea8d91196 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -20,6 +20,10 @@
 #include <linux/kvm_host.h>
 
 #include <asm/kvm_emulate.h>
+#include <asm/kvm_nested.h>
+#include <asm/sysreg.h>
+
+#include "sys_regs.h"
 
 /*
  * Inject wfx to the virtual EL2 if this is not from the virtual EL2 and
@@ -38,3 +42,114 @@ int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe)
 
 	return -EINVAL;
 }
+
+#define FEATURE(x)	(GENMASK_ULL(x##_SHIFT + 3, x##_SHIFT))
+
+/*
+ * Our emulated CPU doesn't support all the possible features. For the
+ * sake of simplicity (and probably mental sanity), wipe out a number
+ * of feature bits we don't intend to support for the time being.
+ * This list should get updated as new features get added to the NV
+ * support, and new extension to the architecture.
+ *
+ * Revisit: Implement as a whitelist rather than a blacklist?
+ */
+void access_nested_id_reg(struct kvm_vcpu *v, struct sys_reg_params *p,
+			  const struct sys_reg_desc *r)
+{
+	u32 id = sys_reg((u32)r->Op0, (u32)r->Op1,
+			 (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
+	u64 val, tmp;
+
+	if (!nested_virt_in_use(v))
+		return;
+
+	val = p->regval;
+
+	switch (id) {
+	case SYS_ID_AA64DFR0_EL1:
+		/* No SPE */
+		val &= ~FEATURE(ID_AA64DFR0_PMSVER);
+		/* Cap PMU to ARMv8.1 */
+		tmp = FIELD_GET(FEATURE(ID_AA64DFR0_PMUVER), val);
+		if (tmp > 0b0100) {
+			val &= FEATURE(ID_AA64DFR0_PMUVER);
+			val |= FIELD_PREP(FEATURE(ID_AA64DFR0_PMUVER), 0b0100);
+		}
+		/* No trace */
+		val &= FEATURE(ID_AA64DFR0_TRACEVER);
+		/* Cap Debug to ARMv8.1 */
+		tmp = FIELD_GET(FEATURE(ID_AA64DFR0_DEBUGVER), val);
+		if (tmp > 0b0111) {
+			val &= FEATURE(ID_AA64DFR0_DEBUGVER);
+			val |= FIELD_PREP(FEATURE(ID_AA64DFR0_DEBUGVER), 0b0111);
+		}
+		break;
+
+	case SYS_ID_AA64ISAR1_EL1:
+		/* No PtrAuth */
+		val &= ~(FEATURE(ID_AA64ISAR1_APA) |
+			 FEATURE(ID_AA64ISAR1_API) |
+			 FEATURE(ID_AA64ISAR1_GPA) |
+			 FEATURE(ID_AA64ISAR1_GPI));
+		break;
+
+	case SYS_ID_AA64MMFR0_EL1:
+		/* Cap PARange to 40bits */
+		tmp = FIELD_GET(FEATURE(ID_AA64MMFR0_PARANGE), val);
+		if (tmp > 0b0010) {
+			val &= ~FEATURE(ID_AA64MMFR0_PARANGE);
+			val |= FIELD_PREP(FEATURE(ID_AA64MMFR0_PARANGE), 0b0010);
+		}
+		break;
+
+	case SYS_ID_AA64MMFR1_EL1:
+		/* No XNX */
+		val &= ~FEATURE(ID_AA64MMFR1_XNX);
+		/* No RAS */
+		val &= ~FEATURE(ID_AA64MMFR1_SpecSEI);
+		/* No Hierarchical Permission Disable */
+		val &= ~FEATURE(ID_AA64MMFR1_HPD);
+		/* No Hardward Access flags and Dirty Bit State update */
+		val &= ~FEATURE(ID_AA64MMFR1_HADBS);
+		break;
+
+	case SYS_ID_AA64MMFR2_EL1:
+		/* No ARMv8.2-EVT */
+		val &= ~FEATURE(ID_AA64MMFR2_EVT);
+		/* No ARMv8.4-TTRem */
+		val &= ~FEATURE(ID_AA64MMFR2_BBM);
+		/* No ARMv8.4-TTST */
+		val &= ~FEATURE(ID_AA64MMFR2_ST);
+		/* No ARMv8.3-CCIDX */
+		val &= ~FEATURE(ID_AA64MMFR2_CCIDX);
+		/* No ARMv8.2-LVA */
+		val &= ~FEATURE(ID_AA64MMFR2_LVA);
+		break;
+
+	case SYS_ID_AA64PFR0_EL1:
+		/* No AMU */
+		val &= ~FEATURE(ID_AA64PFR0_AMU);
+		/* No MPAM */
+		val &= ~FEATURE(ID_AA64PFR0_MPAM);
+		/* No Secure EL2 */
+		val &= ~FEATURE(ID_AA64PFR0_SEL2);
+		/* No RAS */
+		val &= ~FEATURE(ID_AA64PFR0_RAS);
+		/* No SVE */
+		val &= ~FEATURE(ID_AA64PFR0_SVE);
+		/* EL2 is AArch64 only */
+		val &= ~FEATURE(ID_AA64PFR0_EL2);
+		val |= FIELD_PREP(FEATURE(ID_AA64PFR0_EL2), 0b0001);
+		break;
+
+	case SYS_ID_AA64PFR1_EL1:
+		/* No MTE */
+		val &= ~FEATURE(ID_AA64PFR1_MTE);
+		/* No BT */
+		val &= ~FEATURE(ID_AA64PFR1_BT);
+		break;
+	}
+
+	p->regval = val;
+}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 435340a49634..966eb31a84e6 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1414,7 +1414,10 @@ static bool access_id_reg(struct kvm_vcpu *vcpu,
 			  struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
-	return __access_id_reg(vcpu, p, r, false);
+	bool ret = __access_id_reg(vcpu, p, r, false);
+
+	access_nested_id_reg(vcpu, p, r);
+	return ret;
 }
 
 static bool access_raz_id_reg(struct kvm_vcpu *vcpu,
-- 
2.20.1

