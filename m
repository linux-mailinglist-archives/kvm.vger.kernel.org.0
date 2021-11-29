Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B974C4623AA
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 22:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232573AbhK2Vtx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 16:49:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232339AbhK2Vrw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 16:47:52 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86BA3C091D2B
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 12:07:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 12814CE13D8
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 20:07:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CA76C53FD1;
        Mon, 29 Nov 2021 20:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638216426;
        bh=cJeHssu6W6tbH2sGWKdERubXg5G7pf2q9AVmfzXNOeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iH5Ls/9sv96MP0xvUNz8SkNdcxHqbG7BxO4FafXsNJxPmSTbocopJ82UiwN3F5eaN
         4SZVH6nomQkVcIJ+y2XCUxjxzm999MLme+wbfZ/py5bvreC+m+SR2V0SpFm5K8zrlN
         GAAtqkUXPU+VTlXq28wmfK5Ll5GDD7Hh0tVfXX0pcCi9fSacKbFBSi3OC9OLMOHVWI
         nD4Gr41GypD+6Z289lrQGYhDx8nuK5Bl5koqfL+j2vZ+kySHhAaBdM437KtAXupuBs
         mrl+kEX3CIL5hIgGljkEhB60taK6geIYxbo7vl4OcmH7ZlJzp5aQbJSAXXL/9v0rWC
         Hu1Y4forKNFPg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mrmqy-008gvR-Qx; Mon, 29 Nov 2021 20:02:20 +0000
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
Subject: [PATCH v5 36/69] KVM: arm64: nv: Filter out unsupported features from ID regs
Date:   Mon, 29 Nov 2021 20:01:17 +0000
Message-Id: <20211129200150.351436-37-maz@kernel.org>
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

As there is a number of features that we either can't support,
or don't want to support right away with NV, let's add some
basic filtering so that we don't advertize silly things to the
EL2 guest.

Whilst we are at it, avertize ARMv8.4-TTL as well as ARMv8.5-GTG.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h |   6 ++
 arch/arm64/kvm/nested.c             | 152 ++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c           |   4 +-
 arch/arm64/kvm/sys_regs.h           |   2 +
 4 files changed, 163 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 07c15f51cf86..026ddaad972c 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -67,4 +67,10 @@ extern bool __forward_traps(struct kvm_vcpu *vcpu, unsigned int reg,
 extern bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit);
 extern bool forward_nv_traps(struct kvm_vcpu *vcpu);
 
+struct sys_reg_params;
+struct sys_reg_desc;
+
+void access_nested_id_reg(struct kvm_vcpu *v, struct sys_reg_params *p,
+			  const struct sys_reg_desc *r);
+
 #endif /* __ARM64_KVM_NESTED_H */
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 42a96c8d2adc..19b674983e13 100644
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
@@ -38,3 +42,151 @@ int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe)
 
 	return -EINVAL;
 }
+
+/*
+ * Our emulated CPU doesn't support all the possible features. For the
+ * sake of simplicity (and probably mental sanity), wipe out a number
+ * of feature bits we don't intend to support for the time being.
+ * This list should get updated as new features get added to the NV
+ * support, and new extension to the architecture.
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
+	case SYS_ID_AA64ISAR0_EL1:
+		/* Support everything but O.S. and Range TLBIs */
+		val &= ~(FEATURE(ID_AA64ISAR0_TLB)	|
+			 GENMASK_ULL(27, 24)		|
+			 GENMASK_ULL(3, 0));
+		break;
+
+	case SYS_ID_AA64ISAR1_EL1:
+		/* Support everything but PtrAuth and Spec Invalidation */
+		val &= ~(GENMASK_ULL(63, 56)		|
+			 FEATURE(ID_AA64ISAR1_SPECRES)	|
+			 FEATURE(ID_AA64ISAR1_GPI)	|
+			 FEATURE(ID_AA64ISAR1_GPA)	|
+			 FEATURE(ID_AA64ISAR1_API)	|
+			 FEATURE(ID_AA64ISAR1_APA));
+		break;
+
+	case SYS_ID_AA64PFR0_EL1:
+		/* No AMU, MPAM, S-EL2, RAS or SVE */
+		val &= ~(GENMASK_ULL(55, 52)		|
+			 FEATURE(ID_AA64PFR0_AMU)	|
+			 FEATURE(ID_AA64PFR0_MPAM)	|
+			 FEATURE(ID_AA64PFR0_SEL2)	|
+			 FEATURE(ID_AA64PFR0_RAS)	|
+			 FEATURE(ID_AA64PFR0_SVE)	|
+			 FEATURE(ID_AA64PFR0_EL3)	|
+			 FEATURE(ID_AA64PFR0_EL2));
+		/* 64bit EL2/EL3 only */
+		val |= FIELD_PREP(FEATURE(ID_AA64PFR0_EL2), 0b0001);
+		val |= FIELD_PREP(FEATURE(ID_AA64PFR0_EL3), 0b0001);
+		break;
+
+	case SYS_ID_AA64PFR1_EL1:
+		/* Only support SSBS */
+		val &= FEATURE(ID_AA64PFR1_SSBS);
+		break;
+
+	case SYS_ID_AA64MMFR0_EL1:
+		/* Hide ECV, FGT, ExS, Secure Memory */
+		val &= ~(GENMASK_ULL(63, 43)			|
+			 FEATURE(ID_AA64MMFR0_TGRAN4_2)		|
+			 FEATURE(ID_AA64MMFR0_TGRAN16_2)	|
+			 FEATURE(ID_AA64MMFR0_TGRAN64_2)	|
+			 FEATURE(ID_AA64MMFR0_SNSMEM));
+
+		/* Disallow unsupported S2 page sizes */
+		switch (PAGE_SIZE) {
+		case SZ_64K:
+			val |= FIELD_PREP(FEATURE(ID_AA64MMFR0_TGRAN16_2), 0b0001);
+			fallthrough;
+		case SZ_16K:
+			val |= FIELD_PREP(FEATURE(ID_AA64MMFR0_TGRAN4_2), 0b0001);
+			fallthrough;
+		case SZ_4K:
+			/* Support everything */
+			break;
+		}
+		/* Advertize supported S2 page sizes */
+		switch (PAGE_SIZE) {
+		case SZ_4K:
+			val |= FIELD_PREP(FEATURE(ID_AA64MMFR0_TGRAN4_2), 0b0010);
+			fallthrough;
+		case SZ_16K:
+			val |= FIELD_PREP(FEATURE(ID_AA64MMFR0_TGRAN16_2), 0b0010);
+			fallthrough;
+		case SZ_64K:
+			val |= FIELD_PREP(FEATURE(ID_AA64MMFR0_TGRAN64_2), 0b0010);
+			break;
+		}
+		/* Cap PARange to 40bits */
+		tmp = FIELD_GET(FEATURE(ID_AA64MMFR0_PARANGE), val);
+		if (tmp > 0b0010) {
+			val &= ~FEATURE(ID_AA64MMFR0_PARANGE);
+			val |= FIELD_PREP(FEATURE(ID_AA64MMFR0_PARANGE), 0b0010);
+		}
+		break;
+
+	case SYS_ID_AA64MMFR1_EL1:
+		val &= (FEATURE(ID_AA64MMFR1_PAN)	|
+			FEATURE(ID_AA64MMFR1_LOR)	|
+			FEATURE(ID_AA64MMFR1_HPD)	|
+			FEATURE(ID_AA64MMFR1_VHE)	|
+			FEATURE(ID_AA64MMFR1_VMIDBITS));
+		break;
+
+	case SYS_ID_AA64MMFR2_EL1:
+		val &= ~(FEATURE(ID_AA64MMFR2_EVT)	|
+			 FEATURE(ID_AA64MMFR2_BBM)	|
+			 FEATURE(ID_AA64MMFR2_TTL)	|
+			 GENMASK_ULL(47, 44)		|
+			 FEATURE(ID_AA64MMFR2_ST)	|
+			 FEATURE(ID_AA64MMFR2_CCIDX)	|
+			 FEATURE(ID_AA64MMFR2_LVA));
+
+		/* Force TTL support */
+		val |= FIELD_PREP(FEATURE(ID_AA64MMFR2_TTL), 0b0001);
+		break;
+
+	case SYS_ID_AA64DFR0_EL1:
+		/* Only limited support for PMU, Debug, BPs and WPs */
+		val &= (FEATURE(ID_AA64DFR0_PMSVER)	|
+			FEATURE(ID_AA64DFR0_WRPS)	|
+			FEATURE(ID_AA64DFR0_BRPS)	|
+			FEATURE(ID_AA64DFR0_DEBUGVER));
+
+		/* Cap PMU to ARMv8.1 */
+		tmp = FIELD_GET(FEATURE(ID_AA64DFR0_PMUVER), val);
+		if (tmp > 0b0100) {
+			val &= ~FEATURE(ID_AA64DFR0_PMUVER);
+			val |= FIELD_PREP(FEATURE(ID_AA64DFR0_PMUVER), 0b0100);
+		}
+		/* Cap Debug to ARMv8.1 */
+		tmp = FIELD_GET(FEATURE(ID_AA64DFR0_DEBUGVER), val);
+		if (tmp > 0b0111) {
+			val &= ~FEATURE(ID_AA64DFR0_DEBUGVER);
+			val |= FIELD_PREP(FEATURE(ID_AA64DFR0_DEBUGVER), 0b0111);
+		}
+		break;
+
+	default:
+		/* Unknown register, just wipe it clean */
+		val = 0;
+		break;
+	}
+
+	p->regval = val;
+}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 9deedd5a058f..19b33ccb61b8 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1431,8 +1431,10 @@ static bool access_id_reg(struct kvm_vcpu *vcpu,
 			  const struct sys_reg_desc *r)
 {
 	bool raz = sysreg_visible_as_raz(vcpu, r);
+	bool ret = __access_id_reg(vcpu, p, r, raz);
 
-	return __access_id_reg(vcpu, p, r, raz);
+	access_nested_id_reg(vcpu, p, r);
+	return ret;
 }
 
 static bool access_raz_id_reg(struct kvm_vcpu *vcpu,
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index cc0cc95a0280..d260c26b1834 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -201,4 +201,6 @@ const struct sys_reg_desc *find_reg_by_id(u64 id,
 	CRn(sys_reg_CRn(reg)), CRm(sys_reg_CRm(reg)),	\
 	Op2(sys_reg_Op2(reg))
 
+#define FEATURE(x)	(GENMASK_ULL(x##_SHIFT + 3, x##_SHIFT))
+
 #endif /* __ARM64_KVM_SYS_REGS_LOCAL_H__ */
-- 
2.30.2

