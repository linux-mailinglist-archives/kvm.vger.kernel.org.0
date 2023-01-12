Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3A4C667F17
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 20:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240540AbjALT1b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 14:27:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240331AbjALT0y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 14:26:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E417113FBE
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 11:21:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0720B82017
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 19:20:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36CC6C433D2;
        Thu, 12 Jan 2023 19:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673551258;
        bh=VL4xLu71i4RFt+hY9iomcETQiuYx+UcpFwhY44hinnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=evVak96A3e0rknlklhfg0RAjDRcxXQ9ru5F/BDRdaOwXrOlSg1Hp5Hd1IK+hSo3np
         DvFTrQRttOAbA9aY7R+66sPC3o+0TNiZVZI1YvhjruuHP3L0MGX1Cx7MFgOOd4iFAp
         0cdVe/r5bfIPANXvho9/x5ceoIMamhP46f/Yz9l5GSnIPSxyjvQO3DgdjUpF1C4aAg
         bOUxMiN7imY7HFNGKCrC9k6jK5ced7+DpRRImkNDiRxhJJx/CmDX00p3B6v3YmsBKe
         e/gzmnryV3YDH7/9HUYGvDJTiF48ZsukbXB/uDmBZJXBNadrhnvcpch6Jt6SaUao1U
         Bi+V+EfShANkA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pG375-001IWu-Fc;
        Thu, 12 Jan 2023 19:19:48 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v7 32/68] KVM: arm64: nv: Filter out unsupported features from ID regs
Date:   Thu, 12 Jan 2023 19:18:51 +0000
Message-Id: <20230112191927.1814989-33-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230112191927.1814989-1-maz@kernel.org>
References: <20230112191927.1814989-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As there is a number of features that we either can't support,
or don't want to support right away with NV, let's add some
basic filtering so that we don't advertize silly things to the
EL2 guest.

Whilst we are at it, advertize ARMv8.4-TTL as well as ARMv8.5-GTG.

Reviewed-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h |   6 ++
 arch/arm64/kvm/Makefile             |   2 +-
 arch/arm64/kvm/nested.c             | 162 ++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c           |   3 +
 4 files changed, 172 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/kvm/nested.c

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 2fe5847b401f..f2820c82e956 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -65,4 +65,10 @@ extern bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit);
 extern bool forward_nv_traps(struct kvm_vcpu *vcpu);
 extern bool forward_nv1_traps(struct kvm_vcpu *vcpu);
 
+struct sys_reg_params;
+struct sys_reg_desc;
+
+void access_nested_id_reg(struct kvm_vcpu *v, struct sys_reg_params *p,
+			  const struct sys_reg_desc *r);
+
 #endif /* __ARM64_KVM_NESTED_H */
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 31b07f2b2186..c0c050e53157 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -14,7 +14,7 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
 	 inject_fault.o va_layout.o handle_exit.o \
 	 guest.o debug.o reset.o sys_regs.o stacktrace.o \
 	 vgic-sys-reg-v3.o fpsimd.o pkvm.o \
-	 arch_timer.o trng.o vmid.o emulate-nested.o \
+	 arch_timer.o trng.o vmid.o emulate-nested.o nested.o \
 	 vgic/vgic.o vgic/vgic-init.o \
 	 vgic/vgic-irqfd.o vgic/vgic-v2.o \
 	 vgic/vgic-v3.o vgic/vgic-v4.o \
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
new file mode 100644
index 000000000000..f7ec27c27a4f
--- /dev/null
+++ b/arch/arm64/kvm/nested.c
@@ -0,0 +1,162 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2017 - Columbia University and Linaro Ltd.
+ * Author: Jintack Lim <jintack.lim@linaro.org>
+ */
+
+#include <linux/kvm.h>
+#include <linux/kvm_host.h>
+
+#include <asm/kvm_emulate.h>
+#include <asm/kvm_nested.h>
+#include <asm/sysreg.h>
+
+#include "sys_regs.h"
+
+/* Protection against the sysreg repainting madness... */
+#define NV_FTR(r, f)		ID_AA64##r##_EL1_##f
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
+	val = p->regval;
+
+	switch (id) {
+	case SYS_ID_AA64ISAR0_EL1:
+		/* Support everything but TME, O.S. and Range TLBIs */
+		val &= ~(NV_FTR(ISAR0, TLB)		|
+			 NV_FTR(ISAR0, TME));
+		break;
+
+	case SYS_ID_AA64ISAR1_EL1:
+		/* Support everything but PtrAuth and Spec Invalidation */
+		val &= ~(GENMASK_ULL(63, 56)	|
+			 NV_FTR(ISAR1, SPECRES)	|
+			 NV_FTR(ISAR1, GPI)	|
+			 NV_FTR(ISAR1, GPA)	|
+			 NV_FTR(ISAR1, API)	|
+			 NV_FTR(ISAR1, APA));
+		break;
+
+	case SYS_ID_AA64PFR0_EL1:
+		/* No AMU, MPAM, S-EL2, RAS or SVE */
+		val &= ~(GENMASK_ULL(55, 52)	|
+			 NV_FTR(PFR0, AMU)	|
+			 NV_FTR(PFR0, MPAM)	|
+			 NV_FTR(PFR0, SEL2)	|
+			 NV_FTR(PFR0, RAS)	|
+			 NV_FTR(PFR0, SVE)	|
+			 NV_FTR(PFR0, EL3)	|
+			 NV_FTR(PFR0, EL2)	|
+			 NV_FTR(PFR0, EL1));
+		/* 64bit EL1/EL2/EL3 only */
+		val |= FIELD_PREP(NV_FTR(PFR0, EL1), 0b0001);
+		val |= FIELD_PREP(NV_FTR(PFR0, EL2), 0b0001);
+		val |= FIELD_PREP(NV_FTR(PFR0, EL3), 0b0001);
+		break;
+
+	case SYS_ID_AA64PFR1_EL1:
+		/* Only support SSBS */
+		val &= NV_FTR(PFR1, SSBS);
+		break;
+
+	case SYS_ID_AA64MMFR0_EL1:
+		/* Hide ECV, FGT, ExS, Secure Memory */
+		val &= ~(GENMASK_ULL(63, 43)		|
+			 NV_FTR(MMFR0, TGRAN4_2)	|
+			 NV_FTR(MMFR0, TGRAN16_2)	|
+			 NV_FTR(MMFR0, TGRAN64_2)	|
+			 NV_FTR(MMFR0, SNSMEM));
+
+		/* Disallow unsupported S2 page sizes */
+		switch (PAGE_SIZE) {
+		case SZ_64K:
+			val |= FIELD_PREP(NV_FTR(MMFR0, TGRAN16_2), 0b0001);
+			fallthrough;
+		case SZ_16K:
+			val |= FIELD_PREP(NV_FTR(MMFR0, TGRAN4_2), 0b0001);
+			fallthrough;
+		case SZ_4K:
+			/* Support everything */
+			break;
+		}
+		/*
+		 * Since we can't support a guest S2 page size smaller than
+		 * the host's own page size (due to KVM only populating its
+		 * own S2 using the kernel's page size), advertise the
+		 * limitation using FEAT_GTG.
+		 */
+		switch (PAGE_SIZE) {
+		case SZ_4K:
+			val |= FIELD_PREP(NV_FTR(MMFR0, TGRAN4_2), 0b0010);
+			fallthrough;
+		case SZ_16K:
+			val |= FIELD_PREP(NV_FTR(MMFR0, TGRAN16_2), 0b0010);
+			fallthrough;
+		case SZ_64K:
+			val |= FIELD_PREP(NV_FTR(MMFR0, TGRAN64_2), 0b0010);
+			break;
+		}
+		/* Cap PARange to 48bits */
+		tmp = FIELD_GET(NV_FTR(MMFR0, PARANGE), val);
+		if (tmp > 0b0101) {
+			val &= ~NV_FTR(MMFR0, PARANGE);
+			val |= FIELD_PREP(NV_FTR(MMFR0, PARANGE), 0b0101);
+		}
+		break;
+
+	case SYS_ID_AA64MMFR1_EL1:
+		val &= (NV_FTR(MMFR1, PAN)	|
+			NV_FTR(MMFR1, LO)	|
+			NV_FTR(MMFR1, HPDS)	|
+			NV_FTR(MMFR1, VH)	|
+			NV_FTR(MMFR1, VMIDBits));
+		break;
+
+	case SYS_ID_AA64MMFR2_EL1:
+		val &= ~(NV_FTR(MMFR2, EVT)	|
+			 NV_FTR(MMFR2, BBM)	|
+			 NV_FTR(MMFR2, TTL)	|
+			 GENMASK_ULL(47, 44)	|
+			 NV_FTR(MMFR2, ST)	|
+			 NV_FTR(MMFR2, CCIDX)	|
+			 NV_FTR(MMFR2, VARange));
+
+		/* Force TTL support */
+		val |= FIELD_PREP(NV_FTR(MMFR2, TTL), 0b0001);
+		break;
+
+	case SYS_ID_AA64DFR0_EL1:
+		/* Only limited support for PMU, Debug, BPs and WPs */
+		val &= (NV_FTR(DFR0, PMUVer)	|
+			NV_FTR(DFR0, WRPs)	|
+			NV_FTR(DFR0, BRPs)	|
+			NV_FTR(DFR0, DebugVer));
+
+		/* Cap Debug to ARMv8.1 */
+		tmp = FIELD_GET(NV_FTR(DFR0, DebugVer), val);
+		if (tmp > 0b0111) {
+			val &= ~NV_FTR(DFR0, DebugVer);
+			val |= FIELD_PREP(NV_FTR(DFR0, DebugVer), 0b0111);
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
index dd18ae004007..b1dc62dc894d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1449,6 +1449,9 @@ static bool access_id_reg(struct kvm_vcpu *vcpu,
 		return write_to_read_only(vcpu, p, r);
 
 	p->regval = read_id_reg(vcpu, r);
+	if (vcpu_has_nv(vcpu))
+		access_nested_id_reg(vcpu, p, r);
+
 	return true;
 }
 
-- 
2.34.1

