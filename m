Return-Path: <kvm+bounces-64678-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C3C7CC8AC96
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 17:00:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 6EE783561EA
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 16:00:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96B5733C53E;
	Wed, 26 Nov 2025 16:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NZmF4txm"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA6833B6ED;
	Wed, 26 Nov 2025 16:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764172801; cv=none; b=Y0qwWwCzZj3ONG4K3FtGMzfhnFOi2B4/GumZIA3eUpLX4gZ3Du2OGQq1PsdUfvS3OGNXQeagfbtRevScz6hIhoeMw76CSOrzbNehK0dJO6xXyYWz3uC/RofDBFPTTVJeAQjIF2S/kQeXfKjREpDRIJhOt8+XphUUwFGyURQCZN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764172801; c=relaxed/simple;
	bh=sJ9Nj0RO2E3MleSVWlAJM1EaUuH0Yx6I5YRixpnnKkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cGB9iLKjQg0i9R3MybLJ8gcQ39bUMws7h6UYa9rmZLmYdq2p1MEM6WXfO9es83VdxENG96t8x1vIIhxFanaXjAxZMW2dHdvHT92up995bHWKZ6wmAwqdwUXQ+8kth/D2iH9NetASq1GtqJRkWfmaUwaxExbIMcO/aS8GRn9LJUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NZmF4txm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45745C4CEF7;
	Wed, 26 Nov 2025 16:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764172801;
	bh=sJ9Nj0RO2E3MleSVWlAJM1EaUuH0Yx6I5YRixpnnKkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NZmF4txmq6wWCNGsVXXWCTVwE7bQLTDTxBkd+P70S1S4Lnw+c2XKern/AJTYf+5wi
	 Si++rC+wE0WhYYGtHwE4UA6fCKOGXuCqp6kwNlZntstO3sEj9DbXm1R6pYR4G2gBXa
	 IvP4HYHzesIm4/T2zbg24iDbnzf7Wp9fVwMPIBbAxeART6B0o+Vs+ccdP5dzrIMC1X
	 sBJ15AVEalPCod7BhDkzLC/M1x5mwJnpRKpa5xZV9BSxYIn72m7AT1gjMnF24fs4Wp
	 31B6r2z4kwNHK82X7xYUnwWWHpRvaXpImj5lMbUDr6kRTWC3jSNOw2MbNlVTQN3LYG
	 LmKTgF35lPFzg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vOHvy-00000008WrH-2KuL;
	Wed, 26 Nov 2025 15:59:58 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ben Horgan <ben.horgan@arm.com>
Subject: [PATCH v2 1/5] KVM: arm64: Add routing/handling for GMID_EL1
Date: Wed, 26 Nov 2025 15:59:47 +0000
Message-ID: <20251126155951.1146317-2-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251126155951.1146317-1-maz@kernel.org>
References: <20251126155951.1146317-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, ben.horgan@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

HCR_EL2.TID5 is currently ignored by the trap routing infrastructure,
and we currently don't handle GMID_EL1 either (the only register trapped
by TID5).

Wire both the trap bit and a default UNDEF handler.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 8 ++++++++
 arch/arm64/kvm/sys_regs.c       | 1 +
 2 files changed, 9 insertions(+)

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
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 8ae2bca816148..9e4c46fbfd802 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3400,6 +3400,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_CLIDR_EL1), access_clidr, reset_clidr, CLIDR_EL1,
 	  .set_user = set_clidr, .val = ~CLIDR_EL1_RES0 },
 	{ SYS_DESC(SYS_CCSIDR2_EL1), undef_access },
+	{ SYS_DESC(SYS_GMID_EL1), undef_access },
 	{ SYS_DESC(SYS_SMIDR_EL1), undef_access },
 	IMPLEMENTATION_ID(AIDR_EL1, GENMASK_ULL(63, 0)),
 	{ SYS_DESC(SYS_CSSELR_EL1), access_csselr, reset_unknown, CSSELR_EL1 },
-- 
2.47.3


