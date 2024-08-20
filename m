Return-Path: <kvm+bounces-24606-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BEA679584C2
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 12:38:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A23528881C
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 10:38:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5157B18E048;
	Tue, 20 Aug 2024 10:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z1UazADM"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7883118DF95;
	Tue, 20 Aug 2024 10:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724150286; cv=none; b=ClqlQ6U6dU9qcGq7fkCl+JonRzJTpzpjI59TJuq8++ODNR5pTy5JafiyoS/UE3OX0zP5m6KLI4ihv6urNTunN4ofsZhUG1YmEr5NDQIdjPeZsydoYFGnSon7A+e4XOyBULn75xK3uzyORuu9oKEZFeFqC3NmgapzKvVPXB4yCuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724150286; c=relaxed/simple;
	bh=N1dfuCYFccAOdWqTfVzbuHnh1OCX3eKrk8hFfdOBjwA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CSzrjR+SsWnrDM2qCBGpXzSHjLB8mRMpUHlljL7Xl9kPOqn5I7CWHCFVY9yHoH3D6l6IxmBd7IUS1ic40R6CsE7GFQtmXrwXxZmJeEMTFKaGiRCOSXuYhmzWTax/+/704FVHUpw5KcF6EJUr5Xs0S84nL5Eks4fZ6eB2ZRVQFuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z1UazADM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D520C4AF12;
	Tue, 20 Aug 2024 10:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724150286;
	bh=N1dfuCYFccAOdWqTfVzbuHnh1OCX3eKrk8hFfdOBjwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z1UazADMRPi7E+H1rj3TlUL+Szr7Tj7TG5qkhK7Po3jimebGFj2jUaprCg133NzHw
	 EDnIWZc2DIqXn6gD+wq+UjwgqVwpu1QHYEFIryjA6NrKSFBNCwJ8919BpzM0LVm2Hj
	 DVPU3ekRqH0F+62eNFtPCCWDoU/fYlekScz3pFuJPs9jNSI74jEEUEqPYkVW7+Y1yp
	 z7KA5q+5Q6XTKK2HDJJcZDvnsPLOMhdU57OKBf7TxryK+Y0eFrSAzMsFFD5rfrQSj0
	 ZDV/YbobBu0sfwPuWpNGD2ZP/3wcYmy+uGNKEDAQ2ItOmmOPxjperi018v3kOSuh9U
	 zRt2PK1vyvCLQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sgMFX-005Ea3-3x;
	Tue, 20 Aug 2024 11:38:04 +0100
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
Subject: [PATCH v4 02/18] arm64: Add PAR_EL1 field description
Date: Tue, 20 Aug 2024 11:37:40 +0100
Message-Id: <20240820103756.3545976-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240820103756.3545976-1-maz@kernel.org>
References: <20240820103756.3545976-1-maz@kernel.org>
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


