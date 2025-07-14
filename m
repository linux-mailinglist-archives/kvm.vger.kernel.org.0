Return-Path: <kvm+bounces-52326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 877FDB03E9F
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 14:27:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B1BA3B1B30
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 12:27:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82D9E24DCEC;
	Mon, 14 Jul 2025 12:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L4jQPYOu"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D87248F65;
	Mon, 14 Jul 2025 12:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752496005; cv=none; b=UY3h1dqACAqzxHPkcW+DxBB8DYjVi61SfxaH/kkpemEThStq4+BGOSYFcBJnCl0G+7Uuwa1JV5lHQktzZy0G+hwocVX4dyoOwfHU/sNkCZja2PNdbGlQVlRIEqmkF+xIQDrCJOi/cpt5gF6f268tzRYKFRtOfAHJH17WtHOJAfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752496005; c=relaxed/simple;
	bh=FOYwHiBT5QVQJ9jDY0O9ag4nCSvXJIc+wXsyBYpsq6g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=scS0KGaxlJ+xfHdXeCrkjc60Kgz889+lIT59c1TApYDabRGJ/B6itOQc0Hg5gAZiwEz/B9y+vz+nV6pJq+SjpBvV9fh+5SYHlyRoWrKSn4Xj0AFK/x+ZOtn2HGrVgTIPaHX/Hz+VTiULOb4zCt51tIr2AUy4LvDe9oGg4HR8DWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L4jQPYOu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26157C4CEFA;
	Mon, 14 Jul 2025 12:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752496005;
	bh=FOYwHiBT5QVQJ9jDY0O9ag4nCSvXJIc+wXsyBYpsq6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L4jQPYOubPvQLodK8M03GmQQHzEWlUK2ezHkvD7SbVcgN33Q+3kP9yEqojxOkglZh
	 ec0DF45wx1tU7EQcXPGOqjss9DIwOJhH/Iul1V6aDm9GTE27YgIS8EMqExJK76DSaR
	 tGhZV0yzMm+eRfdSYT5uqyoY8QCnIZUGOiHUHX8ajvUJJIBvii+gUxKPzCKa+hHZrs
	 5ovadAhUYNcWBZ+ZyMxBG0MXtr0pokVgyEJKUvwOGqa337D4YGY0XhEv23/JcbcZa6
	 AVnBlTC7qDT3KtmFL9Qj0xfvp1Lcc4voo+/gvU/MEHA/ZEjpyNDYsG4v7PurRLIyUr
	 qMPmQx3HpJUcw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ubIGZ-00FW7V-CJ;
	Mon, 14 Jul 2025 13:26:43 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH 09/11] KVM: arm64: selftests: get-reg-list: Simplify feature dependency
Date: Mon, 14 Jul 2025 13:26:32 +0100
Message-Id: <20250714122634.3334816-10-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250714122634.3334816-1-maz@kernel.org>
References: <20250714122634.3334816-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com, peter.maydell@linaro.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Describing the dependencies between registers and features is on
the masochistic side of things, with hard-coded values that would
be better taken from the existing description.

Add a couple of helpers to that effect, and repaint the dependency
array. More could be done to improve this test, but my interest is
wearing  thin...

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 .../selftests/kvm/arm64/get-reg-list.c        | 52 ++++++++-----------
 1 file changed, 22 insertions(+), 30 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/get-reg-list.c b/tools/testing/selftests/kvm/arm64/get-reg-list.c
index d01798b6b3b47..a35b01d08cc63 100644
--- a/tools/testing/selftests/kvm/arm64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/arm64/get-reg-list.c
@@ -15,6 +15,12 @@
 #include "test_util.h"
 #include "processor.h"
 
+#define SYS_REG(r)	ARM64_SYS_REG(sys_reg_Op0(SYS_ ## r),	\
+				      sys_reg_Op1(SYS_ ## r),	\
+				      sys_reg_CRn(SYS_ ## r),	\
+				      sys_reg_CRm(SYS_ ## r),	\
+				      sys_reg_Op2(SYS_ ## r))
+
 struct feature_id_reg {
 	__u64 reg;
 	__u64 id_reg;
@@ -22,37 +28,23 @@ struct feature_id_reg {
 	__u64 feat_min;
 };
 
-static struct feature_id_reg feat_id_regs[] = {
-	{
-		ARM64_SYS_REG(3, 0, 2, 0, 3),	/* TCR2_EL1 */
-		ARM64_SYS_REG(3, 0, 0, 7, 3),	/* ID_AA64MMFR3_EL1 */
-		0,
-		1
-	},
-	{
-		ARM64_SYS_REG(3, 0, 10, 2, 2),	/* PIRE0_EL1 */
-		ARM64_SYS_REG(3, 0, 0, 7, 3),	/* ID_AA64MMFR3_EL1 */
-		8,
-		1
-	},
-	{
-		ARM64_SYS_REG(3, 0, 10, 2, 3),	/* PIR_EL1 */
-		ARM64_SYS_REG(3, 0, 0, 7, 3),	/* ID_AA64MMFR3_EL1 */
-		8,
-		1
-	},
-	{
-		ARM64_SYS_REG(3, 0, 10, 2, 4),	/* POR_EL1 */
-		ARM64_SYS_REG(3, 0, 0, 7, 3),	/* ID_AA64MMFR3_EL1 */
-		16,
-		1
-	},
-	{
-		ARM64_SYS_REG(3, 3, 10, 2, 4),	/* POR_EL0 */
-		ARM64_SYS_REG(3, 0, 0, 7, 3),	/* ID_AA64MMFR3_EL1 */
-		16,
-		1
+#define FEAT(id, f, v)					\
+	.id_reg		= SYS_REG(id),			\
+	.feat_shift	= id ## _ ## f ## _SHIFT,	\
+	.feat_min	= id ## _ ## f ## _ ## v
+
+#define REG_FEAT(r, id, f, v)			\
+	{					\
+		.reg = SYS_REG(r),		\
+		FEAT(id, f, v)			\
 	}
+
+static struct feature_id_reg feat_id_regs[] = {
+	REG_FEAT(TCR2_EL1,	ID_AA64MMFR3_EL1, TCRX, IMP),
+	REG_FEAT(PIRE0_EL1,	ID_AA64MMFR3_EL1, S1PIE, IMP),
+	REG_FEAT(PIR_EL1,	ID_AA64MMFR3_EL1, S1PIE, IMP),
+	REG_FEAT(POR_EL1,	ID_AA64MMFR3_EL1, S1POE, IMP),
+	REG_FEAT(POR_EL0,	ID_AA64MMFR3_EL1, S1POE, IMP),
 };
 
 bool filter_reg(__u64 reg)
-- 
2.39.2


