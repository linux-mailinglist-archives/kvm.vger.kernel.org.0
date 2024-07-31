Return-Path: <kvm+bounces-22808-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C709994368F
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 21:41:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 87C21281C94
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 19:41:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9F58166313;
	Wed, 31 Jul 2024 19:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J3FwwANk"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD70C14A0AE;
	Wed, 31 Jul 2024 19:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722454855; cv=none; b=j/umr4zEIBWaK0r6ZA2a4jJ9maV/OX+UicIQyvINwJ4Gz9ZOLV3Vp2XzvvOBoNiqNdAVp7x6wJnvrOUmrnVt0qAA3u7VYjflhQv9ldhjkqU97QjN/H+tazqHk7vl2NnK8/s+87VQMRPY4XPEKgfpY9Noq5EaX9S7mgEguiw2NpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722454855; c=relaxed/simple;
	bh=N1dfuCYFccAOdWqTfVzbuHnh1OCX3eKrk8hFfdOBjwA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ToMj5IbMSzCJJYrFoUIL1gaZx+6FVCW6M31Lm0c4ldOfpK7S9pWw4VwfMxiyHPCtDLYDqHO5WnKyx1+eln/EgdNlNy4cp/Hbh3b2IJXJ7zBBkGF4OlQtdzLALPOZEKZbX1owKs+TnG/5e41JJBHPn/VTInvaVj/WHblYRFnJyXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J3FwwANk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA34C4AF0C;
	Wed, 31 Jul 2024 19:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722454855;
	bh=N1dfuCYFccAOdWqTfVzbuHnh1OCX3eKrk8hFfdOBjwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J3FwwANk50ryQFoggFcCZvaoLcG6w0iF9A95GuI0uPwaMyUn0Yd/g4+PqTiFSvmLw
	 0Rypku8bQP9d+YUZdROW/SqX3+GDke6HejDl1/Q0AGv2z0kz9Jf10/aDMIi7VlZ+dQ
	 MiU5HtbLWVedfA4/6ry3pBuh1YKu73WWNWS9MDH7dcC6oOJTSZNjM78o7ALxnQPpHT
	 FebbLeoPK/zTFR8Kf/ArsfX+rip6+rMb7l0NK/MtEGygA/wy3am5WHI0rA+YdaVndP
	 GS9xw7nV6nUsbISrgjpwNMEG7beu0YNcz706UIO27mRnTKqsZ05q50lqbKc6gJ5IW2
	 fWnGScAVi2/Hg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sZFBt-00H6Gh-Aa;
	Wed, 31 Jul 2024 20:40:53 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Przemyslaw Gaj <pgaj@cadence.com>
Subject: [PATCH v2 02/17] arm64: Add PAR_EL1 field description
Date: Wed, 31 Jul 2024 20:40:15 +0100
Message-Id: <20240731194030.1991237-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240731194030.1991237-1-maz@kernel.org>
References: <20240731194030.1991237-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, anshuman.khandual@arm.com, pgaj@cadence.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

As KVM is about to grow a full emulation for the AT instructions,
add the layout of the PAR_EL1 register in its non-D128 configuration.

Note that the constants are a bit ugly, as the register has two
layouts, based on the state of the F bit.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/sysreg.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 4a9ea103817e..d9d5e07f768d 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -325,7 +325,25 @@
 #define SYS_PAR_EL1			sys_reg(3, 0, 7, 4, 0)
 
 #define SYS_PAR_EL1_F			BIT(0)
+/* When PAR_EL1.F == 1 */
 #define SYS_PAR_EL1_FST			GENMASK(6, 1)
+#define SYS_PAR_EL1_PTW			BIT(8)
+#define SYS_PAR_EL1_S			BIT(9)
+#define SYS_PAR_EL1_AssuredOnly		BIT(12)
+#define SYS_PAR_EL1_TopLevel		BIT(13)
+#define SYS_PAR_EL1_Overlay		BIT(14)
+#define SYS_PAR_EL1_DirtyBit		BIT(15)
+#define SYS_PAR_EL1_F1_IMPDEF		GENMASK_ULL(63, 48)
+#define SYS_PAR_EL1_F1_RES0		(BIT(7) | BIT(10) | GENMASK_ULL(47, 16))
+#define SYS_PAR_EL1_RES1		BIT(11)
+/* When PAR_EL1.F == 0 */
+#define SYS_PAR_EL1_SH			GENMASK_ULL(8, 7)
+#define SYS_PAR_EL1_NS			BIT(9)
+#define SYS_PAR_EL1_F0_IMPDEF		BIT(10)
+#define SYS_PAR_EL1_NSE			BIT(11)
+#define SYS_PAR_EL1_PA			GENMASK_ULL(51, 12)
+#define SYS_PAR_EL1_ATTR		GENMASK_ULL(63, 56)
+#define SYS_PAR_EL1_F0_RES0		(GENMASK_ULL(6, 1) | GENMASK_ULL(55, 52))
 
 /*** Statistical Profiling Extension ***/
 #define PMSEVFR_EL1_RES0_IMP	\
-- 
2.39.2


