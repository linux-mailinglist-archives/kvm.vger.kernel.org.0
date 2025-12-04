Return-Path: <kvm+bounces-65259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AB45BCA3133
	for <lists+kvm@lfdr.de>; Thu, 04 Dec 2025 10:48:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 109C4302831F
	for <lists+kvm@lfdr.de>; Thu,  4 Dec 2025 09:48:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6463338593;
	Thu,  4 Dec 2025 09:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mt3uTq4Z"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA583358A2;
	Thu,  4 Dec 2025 09:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764841717; cv=none; b=lZnYfcFUOB/LY0SUyr0nT1FF6kh6qlkS3kzX2+b3cil8LesPftuco6Esa6JjXEPwA4tmCd1VfnoFjjQ1jdNLCyMmD6+jehJGCDH+lvxmFEwa9ZGEVsKpuQuO7qKZUyc7I11gvlpajWPoXWsjk22NoWl8uON4+67M6VR72Z+BEe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764841717; c=relaxed/simple;
	bh=lBM9O1xiYp3upt+sE8CBR/zZAFQ7xYSFnh/kkG4Fd4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CCP9ujHeFgVXh3HbaE6gOVjuXChYbBshW3WQahoEbE7giitAb6wYnHopcfr9Rd/6r8bsBn8bOZ8rWfrMACcYAPPMy+Khh3fBr4YoPvZyz+JtyS5Rh8V8IfyS6bEm09VH83Z5JWpao/TwptzwmrxzjwtPQIZncL4SEekiDWvjhS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mt3uTq4Z; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 726F3C16AAE;
	Thu,  4 Dec 2025 09:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764841716;
	bh=lBM9O1xiYp3upt+sE8CBR/zZAFQ7xYSFnh/kkG4Fd4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mt3uTq4Z3eQXVCPXV2/ehrLJtZnB9aiRZFdoW4rNOprmtT35H1R2vXiVHakAjmMjO
	 7flF5tb0gcaKGv8xC165cGDsZqFP9eqiQ9GKUZ02IHSrdxEIN/8/PfsCWPCKlfbdDf
	 SLZbBCdbXCfc0zkIWHbPEcWzmINHFeVWG5owVIycH1pmoHdnO3Lv2sJ22DH9fvgDRQ
	 uhmUrL8Hj/4QfxpHDJjH8hC+a5vBqfCo7qOcFFQbG5fpC+bplZyYK5LkiciHqhSy0b
	 RhKoD1NM07Y4CHrthr9ID5csnPpdec7gActD5TVKiwhLShW4BULMZphQamKkJGFClL
	 thKqH5t6ad43w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vR5ww-0000000AP90-2bbb;
	Thu, 04 Dec 2025 09:48:34 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>
Subject: [PATCH v3 2/9] KVM: arm64: Add trap routing for GMID_EL1
Date: Thu,  4 Dec 2025 09:47:59 +0000
Message-ID: <20251204094806.3846619-3-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251204094806.3846619-1-maz@kernel.org>
References: <20251204094806.3846619-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, ben.horgan@arm.com, yaoyuan@linux.alibaba.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

HCR_EL2.TID5 is currently ignored by the trap routing infrastructure.
Wire it in the routing table so that GMID_EL1, the sole register
trapped by this bit, is correctly handled in the NV case.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 834f13fb1fb7d..616eb6ad68701 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -70,6 +70,7 @@ enum cgt_group_id {
 	CGT_HCR_ENSCXT,
 	CGT_HCR_TTLBIS,
 	CGT_HCR_TTLBOS,
+	CGT_HCR_TID5,
 
 	CGT_MDCR_TPMCR,
 	CGT_MDCR_TPM,
@@ -308,6 +309,12 @@ static const struct trap_bits coarse_trap_bits[] = {
 		.mask		= HCR_TTLBOS,
 		.behaviour	= BEHAVE_FORWARD_RW,
 	},
+	[CGT_HCR_TID5] = {
+		.index		= HCR_EL2,
+		.value		= HCR_TID5,
+		.mask		= HCR_TID5,
+		.behaviour	= BEHAVE_FORWARD_RW,
+	},
 	[CGT_MDCR_TPMCR] = {
 		.index		= MDCR_EL2,
 		.value		= MDCR_EL2_TPMCR,
@@ -665,6 +672,7 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
 	SR_TRAP(SYS_CCSIDR2_EL1,	CGT_HCR_TID2_TID4),
 	SR_TRAP(SYS_CLIDR_EL1,		CGT_HCR_TID2_TID4),
 	SR_TRAP(SYS_CSSELR_EL1,		CGT_HCR_TID2_TID4),
+	SR_TRAP(SYS_GMID_EL1,		CGT_HCR_TID5),
 	SR_RANGE_TRAP(SYS_ID_PFR0_EL1,
 		      sys_reg(3, 0, 0, 7, 7), CGT_HCR_TID3),
 	SR_TRAP(SYS_ICC_SGI0R_EL1,	CGT_HCR_IMO_FMO_ICH_HCR_TC),
-- 
2.47.3


