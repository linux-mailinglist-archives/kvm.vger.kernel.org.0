Return-Path: <kvm+bounces-44433-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F81EA9DAA2
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 14:30:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 70A7B1BA73AD
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 12:31:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B581253354;
	Sat, 26 Apr 2025 12:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rfclUTbi"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7350F253321;
	Sat, 26 Apr 2025 12:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745670536; cv=none; b=A06nP6Edw3GsuPIXn6htGcHwuRPh6dMG8csjouuMdKcMV11DGdZF4j97TNs1P0bCDgKjlpfbT1R6w2487aTfa9Y1eTMN4WzkCpWtAY7qziZevNFF4aiUn7JSoa1Yh2V7ciX/eGtxX46xO6bOsRjLzKSMOBMEFkZPD7AxUnNdKUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745670536; c=relaxed/simple;
	bh=A+mC25ye+oG3XUc8UJjrY3RBuqusPdAowX5mWr8jlBI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hhERXFkkXZ0UKkKBBaWxfowXaOD5cLtTicSYFzZGiD4dt2Bh2JCRxTyb7lRTR0m4OJYhBHju0NyZdyMg7g15zwnAXiB4rmZYhuSIr7p9xYvXni1HlGx//s14BfMzl/+Ao4u7vK/E6ou9cEA9su2ghXioe4XM57ZFvZriW9xZd2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rfclUTbi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B63C4CEEA;
	Sat, 26 Apr 2025 12:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745670536;
	bh=A+mC25ye+oG3XUc8UJjrY3RBuqusPdAowX5mWr8jlBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rfclUTbiIJw4FLjMWJsQpH6g+pK4VQWuAcgh6EhKjW6940++ZijS8COPv//4xxVX7
	 +fb+1QiyJ7cjji99PefkylhtE9fVt9aEC44Qm+xydeRz16hTha+AY6ydTmDTIGpGTQ
	 tPjT22/McKtmG8/jOPznzalV3MUUnU2fp/B91oWWlruQtk/dUX67exEVhkTZ3/Kzpd
	 n6WqInsiYMrg0xqNSkDBBXxIDY6GAOwk3aWKkthMFNnErm9+HruHem7OfR1gIWyj3z
	 Y/ulmn+sFEM932FNK9NKwAEK/easerfkMHwMYwboI1Ab03nMAg4lXk8aeeiNUGBR8v
	 a13HZAOIh+Idg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1u8eeM-0092VH-Dt;
	Sat, 26 Apr 2025 13:28:54 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v3 21/42] KVM: arm64: Compute FGT masks from KVM's own FGT tables
Date: Sat, 26 Apr 2025 13:28:15 +0100
Message-Id: <20250426122836.3341523-22-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250426122836.3341523-1-maz@kernel.org>
References: <20250426122836.3341523-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

In the process of decoupling KVM's view of the FGT bits from the
wider architectural state, use KVM's own FGT tables to build
a synthetic view of what is actually known.

This allows for some checking along the way.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  14 ++++
 arch/arm64/kvm/emulate-nested.c   | 106 ++++++++++++++++++++++++++++++
 2 files changed, 120 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7a1ef5be7efb2..95fedd27f4bb8 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -607,6 +607,20 @@ struct kvm_sysreg_masks {
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
index 52a2d63a667c9..528b33fcfcfd6 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2033,6 +2033,105 @@ static u32 encoding_next(u32 encoding)
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
+	case HFGRTR_GROUP:
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
+	static struct fgt_masks * const masks[] __initconst = {
+		&hfgrtr_masks,
+		&hfgwtr_masks,
+		&hfgitr_masks,
+		&hdfgrtr_masks,
+		&hdfgwtr_masks,
+		&hafgrtr_masks,
+	};
+	int err = 0;
+
+	for (int i = 0; i < ARRAY_SIZE(masks); i++)
+		err |= check_fgt_masks(masks[i]);
+
+	return ret ?: err;
+}
+
 int __init populate_nv_trap_config(void)
 {
 	int ret = 0;
@@ -2097,8 +2196,15 @@ int __init populate_nv_trap_config(void)
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


