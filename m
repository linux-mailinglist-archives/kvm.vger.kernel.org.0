Return-Path: <kvm+bounces-37719-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 560DBA2F78C
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 19:43:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0641E163B17
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 18:43:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A6562586FB;
	Mon, 10 Feb 2025 18:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FRVtVYcD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80F52580CF;
	Mon, 10 Feb 2025 18:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739212921; cv=none; b=Xp6TSWhRd4JtMIaUh+XcZqQ77J1b8IA/A9j8McBQBPb6iwBvoPyH5qEhnPVi6b9LsCAtLjnhTHxHVinLcA8omjHR3Uto5AF3nAVcEJVZPy2yXPxy2a3iFeYKFKhlqSmMQIGzcDfAtbHY99j6gAlLjOgIJG6ks2rLCvf8GV5ekC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739212921; c=relaxed/simple;
	bh=JoVlWRgVnY+j9LNB7Hewwr7ScankrSkCZVdzMJAowdw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PHVybTnoOmTNCzvrnZfGptb+widxAU/R4G4rXZJAR5ijMSW7vAa6kbyWayOEBnQnQR6cWxM1aHQtNE/YlFPZ9AY8yAZRwuRmOheOgVl1dmgJPgfllAEw7vw8+W78ogVu7Nv0bzopiFvCBdZ6SIIeqknVgu9JsqvbBKusV3eUce8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FRVtVYcD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12052C4CED1;
	Mon, 10 Feb 2025 18:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739212921;
	bh=JoVlWRgVnY+j9LNB7Hewwr7ScankrSkCZVdzMJAowdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FRVtVYcDoe5z4kQ62EbJ8KMf2Y5SiHgvBE9s48t3SWrALqE+az43AjJC5fmKN8tti
	 PmHNR3cTocCL6/Vrbcr9ZySjDpYvpJCAArz5IOhZseDUNrNzp9qU8voR4sh3tecark
	 vFHfffifTejg4BWnV/Qnaz4jkBnHFqgBiDUyV6BsWQypYjkTtVffq457C0C1RzIQyv
	 zCAhCM8VGvROW8dOaJ+j923/l7i80Yl7PRy444kj9aT3bNNxw76tf2RYMtg9dSv0Cl
	 ISO5IWSreYByFox7tHjvZ3y7wrE6AuA3TNr2YiYl9XkMIxBrfWhIG6W36CcTSAjSQN
	 2xuw/QVQvInrA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1thYjH-002g2I-2D;
	Mon, 10 Feb 2025 18:41:59 +0000
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
Subject: [PATCH 08/18] KVM: arm64: Add description of FGT bits leading to EC!=0x18
Date: Mon, 10 Feb 2025 18:41:39 +0000
Message-Id: <20250210184150.2145093-9-maz@kernel.org>
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


