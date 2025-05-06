Return-Path: <kvm+bounces-45635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 07962AACB59
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 18:46:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DDD7C1C07253
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 16:46:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34BD7287510;
	Tue,  6 May 2025 16:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g5s1yPtz"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556F2286D76;
	Tue,  6 May 2025 16:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746549853; cv=none; b=ByrdPFKyoNgIS4ArAYVrnGeW1L2lR8CO5UqLGjLGUA+SdpZb1ZrLkqugauNNBv3KynHPkzJfsF/ZtGReObaHQ6Xz6Fo69dBDa+TdiiK9XOEYQOcBrILbxDd74IrJAEvXU1kOD+HnwHR9jIVVuDw4Em/Kgsy8TIo8k7XsTPiOzTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746549853; c=relaxed/simple;
	bh=xw/w3V9CUbh6dadR2+rCO1kqsM8ZOa8PQNMsMiGppFE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bPjvmvxzCiKE7Qm+rYI1q8rCuMC91EXiDEyXndx2X0mDYs4nB5nHOVFRXl/jIQM0lWisCli4JXPCWVUTBzyuaZzPhvDVXH0BSV3suYex0EDkOVafzV6up2drCX+RdFf5Ub1E/PvpQSTXzUyjX2HMSikXae7OfEsPUcHiRB/PZAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g5s1yPtz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34714C4CEE4;
	Tue,  6 May 2025 16:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746549853;
	bh=xw/w3V9CUbh6dadR2+rCO1kqsM8ZOa8PQNMsMiGppFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g5s1yPtzLXdtwFDlS8L9X7iI9QWbgfng5RqCLzs/S9tB1TBegVgX5FVd5gaL9LkpJ
	 DTMAcQkjDxtXwV+lKbW3AhOErrIJ6LhnRT0Qh2dm1joqvZvhO4ItCbukklyXuiPDOo
	 k3IQ6Uzj0h+lYkNIkbPIEe8jkZrxZWPhknK09PcYAC3o/K7Of1EhfP2PcYXBMu23Lz
	 CgMrQAdOx6mG/eKY61UmUxxAQ7BuTlr75TduaiDXw+9ZAf3Fs9Ivk9if5TDsI2gGRr
	 eJbXBlxhjIBKIb2jxfF1l65LSA4L2Z145L4NBKcrq6BU2gia4BCQbDio1WmQkMAOIJ
	 08xvrFk59QYzQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uCLOt-00CJkN-BR;
	Tue, 06 May 2025 17:44:11 +0100
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
	Catalin Marinas <catalin.marinas@arm.com>,
	Ben Horgan <ben.horgan@arm.com>
Subject: [PATCH v4 23/43] KVM: arm64: Add description of FGT bits leading to EC!=0x18
Date: Tue,  6 May 2025 17:43:28 +0100
Message-Id: <20250506164348.346001-24-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250506164348.346001-1-maz@kernel.org>
References: <20250506164348.346001-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com, ben.horgan@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The current FTP tables are only concerned with the bits generating
ESR_ELx.EC==0x18. However, we want an exhaustive view of what KVM
really knows about.

So let's add another small table that provides that extra information.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 36 +++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 528b33fcfcfd6..c30d970bf81cb 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -1279,16 +1279,21 @@ enum fg_filter_id {
 	__NR_FG_FILTER_IDS__
 };
 
-#define SR_FGF(sr, g, b, p, f)					\
-	{							\
-		.encoding	= sr,				\
-		.end		= sr,				\
-		.tc		= {				\
+#define __FGT(g, b, p, f)					\
+		{						\
 			.fgt = g ## _GROUP,			\
 			.bit = g ## _EL2_ ## b ## _SHIFT,	\
 			.pol = p,				\
 			.fgf = f,				\
-		},						\
+		}
+
+#define FGT(g, b, p)		__FGT(g, b, p, __NO_FGF__)
+
+#define SR_FGF(sr, g, b, p, f)					\
+	{							\
+		.encoding	= sr,				\
+		.end		= sr,				\
+		.tc		= __FGT(g, b, p, f),		\
 		.line = __LINE__,				\
 	}
 
@@ -1989,6 +1994,18 @@ static const struct encoding_to_trap_config encoding_to_fgt[] __initconst = {
 	SR_FGT(SYS_AMEVCNTR0_EL0(0),	HAFGRTR, AMEVCNTR00_EL0, 1),
 };
 
+/*
+ * Additional FGTs that do not fire with ESR_EL2.EC==0x18. This table
+ * isn't used for exception routing, but only as a promise that the
+ * trap is handled somewhere else.
+ */
+static const union trap_config non_0x18_fgt[] __initconst = {
+	FGT(HFGITR, nGCSSTR_EL1, 0),
+	FGT(HFGITR, SVC_EL1, 1),
+	FGT(HFGITR, SVC_EL0, 1),
+	FGT(HFGITR, ERET, 1),
+};
+
 static union trap_config get_trap_config(u32 sysreg)
 {
 	return (union trap_config) {
@@ -2203,6 +2220,13 @@ int __init populate_nv_trap_config(void)
 		}
 	}
 
+	for (int i = 0; i < ARRAY_SIZE(non_0x18_fgt); i++) {
+		if (!aggregate_fgt(non_0x18_fgt[i])) {
+			ret = -EINVAL;
+			kvm_err("non_0x18_fgt[%d] is reserved\n", i);
+		}
+	}
+
 	ret = check_all_fgt_masks(ret);
 
 	kvm_info("nv: %ld fine grained trap handlers\n",
-- 
2.39.2


