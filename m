Return-Path: <kvm+bounces-40630-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4709FA59441
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 13:26:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E54A3A9547
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 12:26:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A81E022A4EF;
	Mon, 10 Mar 2025 12:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q6SRu8AQ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8900229B18;
	Mon, 10 Mar 2025 12:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741609514; cv=none; b=ZHFFA6zcAj2HlsDv3GHcoa2EKf2sQ7JQIeDPC8R1VOXHNQ7TaafdV0FqLSLFvKg+Oa7YT5VGUWPdRWK2igrYfoukf06wMR8JPveMTqBXhgCahlf7iXJFrUaCB7vJTUGurVD/YZj0wMmZjpbZV7yriDToAVcLUwAudfQf6It2+6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741609514; c=relaxed/simple;
	bh=JoVlWRgVnY+j9LNB7Hewwr7ScankrSkCZVdzMJAowdw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XcaoL81V0OytYJ43xwOWRTcEuDpiHILnQJE8v0jlEjCWgYBC408UWf/q1UhbsyNMheyQJth9SHdV7ZlIS+yK8+q4aoa/IWuGM9A80IAPe9okmAQ5kZaZnaEEhH2EOX+4mS9st2uzT3XYvvkbzdTuoHOrwt4md4uESUpSFowKbM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q6SRu8AQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5291EC4CEE5;
	Mon, 10 Mar 2025 12:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741609514;
	bh=JoVlWRgVnY+j9LNB7Hewwr7ScankrSkCZVdzMJAowdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q6SRu8AQ59hhcwnFWRgYVwQ6Re2+QgSG95nIDpmF1RfjmOD6woAiJYWrnoDPCs6+B
	 DDdv9CWbXnVXV5HYNuxlSUjfzrc0U3jEixB7r0fUYYK5yLmFhs/7aqehS3Q0lEwQ1P
	 m5olg+SgeCa0flCKENego47//y/2nVH08h6JKdr07oTlL7dSIFhlUu6A5Uhou0h01O
	 74zxXnHeSrxsTWVmorXTqCxlOylF+EOpAIu67Ln7UA0eKmO+0VAAfeRh9poZqBbdZN
	 YhjwX2mrug1zFOOUgPHZ6gN0NiNGLfobVXb22N4n+O+whTYjqK17AMYVYA2Ti15yt0
	 nGvSdMg2Z8OUg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1trcC0-00CAea-G3;
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
Subject: [PATCH v2 10/23] KVM: arm64: Add description of FGT bits leading to EC!=0x18
Date: Mon, 10 Mar 2025 12:24:52 +0000
Message-Id: <20250310122505.2857610-11-maz@kernel.org>
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

The current FTP tables are only concerned with the bits generating
ESR_ELx.EC==0x18. However, we want an exhaustive view of what KVM
really knows about.

So let's add another small table that provides that extra information.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index bbfe89c37a86e..4f468759268c0 100644
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
 
@@ -1989,6 +1994,14 @@ static const struct encoding_to_trap_config encoding_to_fgt[] __initconst = {
 	SR_FGT(SYS_AMEVCNTR0_EL0(0),	HAFGRTR, AMEVCNTR00_EL0, 1),
 };
 
+/* Additional FGTs that do not fire with ESR_EL2.EC==0x18 */
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
@@ -2199,6 +2212,13 @@ int __init populate_nv_trap_config(void)
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


