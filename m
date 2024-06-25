Return-Path: <kvm+bounces-20479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B4EF091690B
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 15:36:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E69F31C25C3A
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 13:36:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5552F1607A4;
	Tue, 25 Jun 2024 13:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j07EHgQ5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7107C161B43;
	Tue, 25 Jun 2024 13:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719322524; cv=none; b=R1D9KbBs6QT7PnxB60DHlVCWCd/G5ZarV+HkrD6zqFSXRt5GwTbhIHqPK5e9ZCmeAs0cFVCwxROJbyXYW6szvGc1djAtQ+8bX4nfC4ymZ0AElXz9n1/GCvXuN/wZsdQ24M4wO+GJLRCeis3gnsHRUbEPhw3e2odTZI6zJncFcI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719322524; c=relaxed/simple;
	bh=T2CXo4D4ISy0D/ALYS9ezM0wHkOH2cIDAXg9SuVgoHo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BCQb2IVtgQ+jKwlTNTQJsQW2rAfbYjrc6NwMBp2RXC72WSzarTvEJB3DlBies6Y/h5LhSWyr9UognjtNAl51/qtLOn7N/cOoNPXFF4i9Efr7JG0xMtbq6Z8N2Gibuhf7ixivOuyOdm2jfDaA9eeGPrBkWtiUMG6noz4r9fKUeiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j07EHgQ5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0583CC4AF09;
	Tue, 25 Jun 2024 13:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719322524;
	bh=T2CXo4D4ISy0D/ALYS9ezM0wHkOH2cIDAXg9SuVgoHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j07EHgQ5Xkn4rLuGZkzAZLLsaxQpEQlKHfKGIkGglBmWSEFFfsF+ZzDC1DY0oVxIM
	 MM6x72LEICDrnl33D6uGj5fWglR3o2Aq117RpU1geG5r9AEKduIEkTRlZZBvzPYYNh
	 ES2J+YBWmK1rRJ8bEZ57hOQGNuh1GT8m3SW0h1v0WU/9uWrLQIrPR/df7md8Xb0YQW
	 usmb/2JdCuhQJ2hNq8EMDbwq2ftB0lLTbVRzVO16RBWNPXxfktrh3wibOzlDGudnCF
	 +lQNwX4tcfzqc8GxHCD0xZJXJBZ4Rf+LBzI9n8nzqSFAs2Vb5rIq+uWvZk2lysewrv
	 FrUbgwTBLruVw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sM6KQ-007A6l-6n;
	Tue, 25 Jun 2024 14:35:22 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>
Subject: [PATCH 02/12] arm64: Add PAR_EL1 field description
Date: Tue, 25 Jun 2024 14:35:01 +0100
Message-Id: <20240625133508.259829-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240625133508.259829-1-maz@kernel.org>
References: <20240625133508.259829-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com
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
index be41528194569..15c073359c9e9 100644
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


