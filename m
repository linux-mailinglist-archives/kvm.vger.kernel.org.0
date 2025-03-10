Return-Path: <kvm+bounces-40629-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B1E5AA59440
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 13:26:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D182F3AA07D
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 12:26:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A80DF22A4EC;
	Mon, 10 Mar 2025 12:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r1C5CBBv"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88D6229B17;
	Mon, 10 Mar 2025 12:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741609514; cv=none; b=PGqEID2kSSGLlN8xmezhYQ8pO6BSXHGT1NgkF2nZMaIkWyM/dt71Ic8p0b2v8wHP5Ly4G3VA3/0P2SnwtIkI7XpjDQyCwKQnFF/1T7ZpNJ7BiR+ph6EMJTC/RkneTV9D/9I2Scb+kwNWuKyecJN6qzRbtxFyIJ3enhvzwpKAXog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741609514; c=relaxed/simple;
	bh=f9XQRQuULxKzE9X/XvGWnwafyLw7l1Eqzg+ZWKrvZ6w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NjNBl5sSRKi1UJZbJwdg89PN2/2PyFIrPRT9byoe1T18ivHq5wCus0Q4XI5eFjcAqcbPcUVFyicfaRuujDBVf0EbGeNuFqtGPljAJKntsLkK1VKXBZzN3qSMgIPdpzpXcGPJPZ0j5uwZsFozqUnL+f71DbhbIKlPlanGO9iFk0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r1C5CBBv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E70DC4CEEF;
	Mon, 10 Mar 2025 12:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741609514;
	bh=f9XQRQuULxKzE9X/XvGWnwafyLw7l1Eqzg+ZWKrvZ6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r1C5CBBvJ0lnXDmq+fkEdQLccWMG17M6AVjrLEA5Xq+BQgXkbwfznqMH1pjmZffV+
	 /jQ9ZRg5INcWWvDI4IOczany+FrInaig04H2lFFEwKQ8IBh/AxXgHGHt15yj8CvJvx
	 BmaAysa19gih6xUTabeMlWaGyQxVWIfqZoj0meeE4AIFqmHBywBlp44yy3g1JbVDkY
	 e0U2gUsmDI6vWNBdZrINqlHN1VNBiCRpalDHmddGtmaQO728zySLEXjS++vBmkZ+VS
	 kWjG0/ZtBHngnP7bdpCMB8K6XXIAMWRnU9ULomDEO7MIMXgBKk+OtNt0veP49qPxOQ
	 2YSb6kKISSexw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1trcC0-00CAea-6V;
	Mon, 10 Mar 2025 12:25:12 +0000
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
Subject: [PATCH v2 09/23] KVM: arm64: Compute FGT masks from KVM's own FGT tables
Date: Mon, 10 Mar 2025 12:24:51 +0000
Message-Id: <20250310122505.2857610-10-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250310122505.2857610-1-maz@kernel.org>
References: <20250310122505.2857610-1-maz@kernel.org>
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
index 52bd4abc2a85d..9ff6fda07a68e 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -362,6 +362,10 @@
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
index 3a7ec98ef1238..657fb8243ea63 100644
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


