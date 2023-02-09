Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFB9691001
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 19:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjBISLD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 13:11:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjBISK7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 13:10:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B830C68AE0
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 10:10:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89D3B61B36
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 18:10:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D34DFC433D2;
        Thu,  9 Feb 2023 18:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675966243;
        bh=bhUAipcAdT40cbO5DvZljPS6d9sI1RT1hfGx8VdrfGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WOHpmhl/uNrVXUh7w6NPDCOoDcspUfc6x3znLI+4s7CzkOmAHHv9MoYW5yZ1it6P9
         MrBtYdMt2sd8sxEKuQN8jkIXG1NpF33/Dz+j24pWCT9CF8lztFNWSYg6cLg5TBs7Sy
         cblkcLmo6Nrgk41cQBnctlrHh456Wt8d/d0hvHhnMdjAu6cCJ6NlIDfSR9athZECo0
         mDRLIUaIxssfhTdl/08KPnIy4puFHcturxJJx8eJ0U52wo1J8i6+cMlmqt8iygjBKy
         zuQB0rJkSXDnqSRGKyuzzo1MhkJQmrSbvlaY/5eWVHwIblnCQAXl1DiANqWIX/xnTP
         UgEZOLybVdMXg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pQBC6-0093r7-3C;
        Thu, 09 Feb 2023 17:58:50 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 17/18] KVM: arm64: nv: Filter out unsupported features from ID regs
Date:   Thu,  9 Feb 2023 17:58:19 +0000
Message-Id: <20230209175820.1939006-18-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230209175820.1939006-1-maz@kernel.org>
References: <20230209175820.1939006-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, catalin.marinas@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, rmk+kernel@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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

Whilst we are at it, advertize FEAT_TTL as well as FEAT_GTG, which
the NV implementation will implement.

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
index fd601ea68d13..8fb67f032fd1 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -11,4 +11,10 @@ static inline bool vcpu_has_nv(const struct kvm_vcpu *vcpu)
 		test_bit(KVM_ARM_VCPU_HAS_EL2, vcpu->arch.features));
 }
 
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
index f5dd4f4eaaf0..82c1f8d786f7 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1223,6 +1223,9 @@ static bool access_id_reg(struct kvm_vcpu *vcpu,
 		return write_to_read_only(vcpu, p, r);
 
 	p->regval = read_id_reg(vcpu, r);
+	if (vcpu_has_nv(vcpu))
+		access_nested_id_reg(vcpu, p, r);
+
 	return true;
 }
 
-- 
2.34.1

