Return-Path: <kvm+bounces-37715-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71B5BA2F78B
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 19:43:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0ED07162CCA
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 18:43:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B23F2586F9;
	Mon, 10 Feb 2025 18:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZZbs283w"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F313C2566C0;
	Mon, 10 Feb 2025 18:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739212921; cv=none; b=bJ0vheExTBRJ9NqbVnH3Fx2n88Ak6hyBPoSjt2nWBx8TSN3qmaCGl4WY+3OodG8yYwUxsl0AZlt1ivVAg38cIcfIrxkgif2G9bW1L8EWGWdKLeROv+HQ8PHz4IotQ7JqvyS+tB1fRb/rX0r6xXpoNOIhkPbDgG2P9uQNADL8oA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739212921; c=relaxed/simple;
	bh=6C8aCRS04x5u5T3h7cL8zL2oGz5G0K3xDOgLrqXvewo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OjY1TorhBaSng5Y5YtpH9ra/4v8fK9sk4nGlmi+o8BKCuQlXWkIcPvfr48uMRkPOvMw384QlLb4zUEQP2Gy34Tcak0bQiGEtfhrGWjleZo3hV6wJ4VZhGf2kn0swKpo/ghyUzcepEEnjkxur8IVt3vbLQ7DljLkrghC+SP+Kx5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZZbs283w; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA684C4CEE7;
	Mon, 10 Feb 2025 18:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739212920;
	bh=6C8aCRS04x5u5T3h7cL8zL2oGz5G0K3xDOgLrqXvewo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZZbs283wsWh1NKwAFkAt8h2nEndX8ibQKL9Nf/X8abK4SBMbw2R+79SGRHYJI1JHM
	 vTnUvigFDjajRD+ebEgb6OgF9L7K9n9h/Ixreneessg2P9qAQcDbzQw4PHh+hyHECl
	 cFsuEuStlFM2WKQIdjacwgQ37N2Uy01F+BaacygLRfj2EIJB6t7mvDVdQyzWePayeT
	 TEt/2XwKxHS3USag3Wua9MkrPMwF70T/KYFbhd7kFk6p0PYc3Ey68FmMUmc93nO0Tw
	 pRMQiwf113Y9Ar4budGNjZmmUhjFjekg6TNm0ISbzu8vrGvE81UZ2eAyjaM1CdmWIo
	 d3PsXKKWD9MDA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1thYjG-002g2I-QT;
	Mon, 10 Feb 2025 18:41:58 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH 07/18] KVM: arm64: Compute FGT masks from KVM's own FGT tables
Date: Mon, 10 Feb 2025 18:41:38 +0000
Message-Id: <20250210184150.2145093-8-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250210184150.2145093-1-maz@kernel.org>
References: <20250210184150.2145093-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

In the process of decoupling KVM's view of the FGT bits from the
wider architectural state, use KVM's own FGT tables to build
a synthitic view of what is actually known.

This allows for some checking along the way.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_arm.h  |   4 ++
 arch/arm64/include/asm/kvm_host.h |  14 ++++
 arch/arm64/kvm/emulate-nested.c   | 102 ++++++++++++++++++++++++++++++
 3 files changed, 120 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 8d94a6c0ed5c4..e424085f2aaca 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -359,6 +359,10 @@
 #define __HAFGRTR_EL2_MASK	(GENMASK(49, 17) | GENMASK(4, 0))
 #define __HAFGRTR_EL2_nMASK	~(__HAFGRTR_EL2_RES0 | __HAFGRTR_EL2_MASK)
 
+/* Because the sysreg file mixes R and W... */
+#define HFGRTR_EL2_RES0		HFGxTR_EL2_RES0
+#define HFGWTR_EL2_RES0		(HFGRTR_EL2_RES0 | __HFGRTR_ONLY_MASK)
+
 /* Similar definitions for HCRX_EL2 */
 #define __HCRX_EL2_RES0         HCRX_EL2_RES0
 #define __HCRX_EL2_MASK		(BIT(6))
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7cfa024de4e34..4e67d4064f409 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -569,6 +569,20 @@ struct kvm_sysreg_masks {
 	} mask[NR_SYS_REGS - __SANITISED_REG_START__];
 };
 
+struct fgt_masks {
+	const char	*str;
+	u64		mask;
+	u64		nmask;
+	u64		res0;
+};
+
+extern struct fgt_masks hfgrtr_masks;
+extern struct fgt_masks hfgwtr_masks;
+extern struct fgt_masks hfgitr_masks;
+extern struct fgt_masks hdfgrtr_masks;
+extern struct fgt_masks hdfgwtr_masks;
+extern struct fgt_masks hafgrtr_masks;
+
 struct kvm_cpu_context {
 	struct user_pt_regs regs;	/* sp = sp_el0 */
 
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 607d37bab70b4..bbfe89c37a86e 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2033,6 +2033,101 @@ static u32 encoding_next(u32 encoding)
 	return sys_reg(op0 + 1, 0, 0, 0, 0);
 }
 
+#define FGT_MASKS(__n, __m)						\
+	struct fgt_masks __n = { .str = #__m, .res0 = __m, }
+
+FGT_MASKS(hfgrtr_masks, HFGRTR_EL2_RES0);
+FGT_MASKS(hfgwtr_masks, HFGWTR_EL2_RES0);
+FGT_MASKS(hfgitr_masks, HFGITR_EL2_RES0);
+FGT_MASKS(hdfgrtr_masks, HDFGRTR_EL2_RES0);
+FGT_MASKS(hdfgwtr_masks, HDFGWTR_EL2_RES0);
+FGT_MASKS(hafgrtr_masks, HAFGRTR_EL2_RES0);
+
+static __init bool aggregate_fgt(union trap_config tc)
+{
+	struct fgt_masks *rmasks, *wmasks;
+
+	switch (tc.fgt) {
+	case HFGxTR_GROUP:
+		rmasks = &hfgrtr_masks;
+		wmasks = &hfgwtr_masks;
+		break;
+	case HDFGRTR_GROUP:
+		rmasks = &hdfgrtr_masks;
+		wmasks = &hdfgwtr_masks;
+		break;
+	case HAFGRTR_GROUP:
+		rmasks = &hafgrtr_masks;
+		wmasks = NULL;
+		break;
+	case HFGITR_GROUP:
+		rmasks = &hfgitr_masks;
+		wmasks = NULL;
+		break;
+	}
+
+	/*
+	 * A bit can be reserved in either the R or W register, but
+	 * not both.
+	 */
+	if ((BIT(tc.bit) & rmasks->res0) &&
+	    (!wmasks || (BIT(tc.bit) & wmasks->res0)))
+		return false;
+
+	if (tc.pol)
+		rmasks->mask |= BIT(tc.bit) & ~rmasks->res0;
+	else
+		rmasks->nmask |= BIT(tc.bit) & ~rmasks->res0;
+
+	if (wmasks) {
+		if (tc.pol)
+			wmasks->mask |= BIT(tc.bit) & ~wmasks->res0;
+		else
+			wmasks->nmask |= BIT(tc.bit) & ~wmasks->res0;
+	}
+
+	return true;
+}
+
+static __init int check_fgt_masks(struct fgt_masks *masks)
+{
+	unsigned long duplicate = masks->mask & masks->nmask;
+	u64 res0 = masks->res0;
+	int ret = 0;
+
+	if (duplicate) {
+		int i;
+
+		for_each_set_bit(i, &duplicate, 64) {
+			kvm_err("%s[%d] bit has both polarities\n",
+				masks->str, i);
+		}
+
+		ret = -EINVAL;
+	}
+
+	masks->res0 = ~(masks->mask | masks->nmask);
+	if (masks->res0 != res0)
+		kvm_info("Implicit %s = %016llx, expecting %016llx\n",
+			 masks->str, masks->res0, res0);
+
+	return ret;
+}
+
+static __init int check_all_fgt_masks(int ret)
+{
+	int err = 0;
+
+	err |= check_fgt_masks(&hfgrtr_masks);
+	err |= check_fgt_masks(&hfgwtr_masks);
+	err |= check_fgt_masks(&hfgitr_masks);
+	err |= check_fgt_masks(&hdfgrtr_masks);
+	err |= check_fgt_masks(&hdfgwtr_masks);
+	err |= check_fgt_masks(&hafgrtr_masks);
+
+	return ret ?: err;
+}
+
 int __init populate_nv_trap_config(void)
 {
 	int ret = 0;
@@ -2097,8 +2192,15 @@ int __init populate_nv_trap_config(void)
 			ret = xa_err(prev);
 			print_nv_trap_error(fgt, "Failed FGT insertion", ret);
 		}
+
+		if (!aggregate_fgt(tc)) {
+			ret = -EINVAL;
+			print_nv_trap_error(fgt, "FGT bit is reserved", ret);
+		}
 	}
 
+	ret = check_all_fgt_masks(ret);
+
 	kvm_info("nv: %ld fine grained trap handlers\n",
 		 ARRAY_SIZE(encoding_to_fgt));
 
-- 
2.39.2


