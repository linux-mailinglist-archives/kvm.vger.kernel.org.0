Return-Path: <kvm+bounces-21102-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8165292A5FA
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 17:45:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C5F3284989
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 15:45:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55E9F145A1A;
	Mon,  8 Jul 2024 15:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KsY6F0gR"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0B9143C47;
	Mon,  8 Jul 2024 15:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720453495; cv=none; b=SysbrIj0rm+2pred6jVpGZFUALdHkJa4KLpvFP8LVzX/odaeeFGjE3OKzwB8hLFUwEfK9etoPWgCzlaaCLxc4UMORRtH2auj04j4Uj7ssablQqaC4l0qUsLmtlLhoe237L2Xlf6YEsIuQV0g7visyGjXIIYFT/29EMFgCHmq1O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720453495; c=relaxed/simple;
	bh=1eMOdbXNYwvJnyM8pmY0Pmrc14+KgT3XcJYTFkP+K5s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=f1kNMKuBRiAeCij7bPx5FSoTKAPZlKJaiWW0i3IBteJSbTh8W1DelynEonHmalh/zVFuHffX2yongjxpobqGemqHE5cxE7KOVOMXoYrtbP8rqLLM+NDditdC2vl2n5AR+NTtoX4yUL8Grh40zYI2ShSLZZu9+q90y/khTnRCa+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KsY6F0gR; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20163C4AF0F;
	Mon,  8 Jul 2024 15:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720453495;
	bh=1eMOdbXNYwvJnyM8pmY0Pmrc14+KgT3XcJYTFkP+K5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KsY6F0gRaieUN2Gtu6D1YxODI+vTcdhocQszJrTmSpfdqe8O99gJytex6ywSlqV8J
	 nYnpBktaQsJTWtCipObPZfhTr6p2jLOgLuiEXct5E2MUBJ6jAxYvR0fhekTiRa/S17
	 GMO2E7gBuqRZd27MFHawKaQ1N1XTLMLXivw1YCoBRKZz7XA/w6eyyqMr7ZVMj2a9jN
	 p/rNDdJ3XSGyZteBYA1xo1Q2Dn/dP6QrcqGk8Vr2ZIEdITwD6I41nph8ZD2lbIrpZq
	 fux4+IPAXSpBVFg4RNemb7fpHS5P+5x3l79b88eaGniUvQsi8JdfLTJAbXr2X6P1Ry
	 AI8EXiZsGWtTA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sQqXt-00Ae1P-8S;
	Mon, 08 Jul 2024 16:44:53 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 4/7] KVM: arm64: Honor trap routing for FPMR
Date: Mon,  8 Jul 2024 16:44:35 +0100
Message-Id: <20240708154438.1218186-5-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240708154438.1218186-1-maz@kernel.org>
References: <20240708154438.1218186-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, tabba@google.com, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

HCRX_EL2.EnFPM controls the trapping of FPMR (as well as the validity
of any FP8 instruction, but we don't really care about this last part).

Describe the trap bit so that the exception can be reinjected in a
NV guest.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 05166eccea0a6..ee280239f14f4 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -83,6 +83,7 @@ enum cgt_group_id {
 	CGT_CPTR_TAM,
 	CGT_CPTR_TCPAC,
 
+	CGT_HCRX_EnFPM,
 	CGT_HCRX_TCR2En,
 
 	/*
@@ -372,6 +373,12 @@ static const struct trap_bits coarse_trap_bits[] = {
 		.mask		= CPTR_EL2_TCPAC,
 		.behaviour	= BEHAVE_FORWARD_ANY,
 	},
+	[CGT_HCRX_EnFPM] = {
+		.index		= HCRX_EL2,
+		.value 		= 0,
+		.mask		= HCRX_EL2_EnFPM,
+		.behaviour	= BEHAVE_FORWARD_ANY,
+	},
 	[CGT_HCRX_TCR2En] = {
 		.index		= HCRX_EL2,
 		.value 		= 0,
@@ -1108,6 +1115,7 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initconst = {
 	SR_TRAP(SYS_CNTP_CTL_EL0,	CGT_CNTHCTL_EL1PTEN),
 	SR_TRAP(SYS_CNTPCT_EL0,		CGT_CNTHCTL_EL1PCTEN),
 	SR_TRAP(SYS_CNTPCTSS_EL0,	CGT_CNTHCTL_EL1PCTEN),
+	SR_TRAP(SYS_FPMR,		CGT_HCRX_EnFPM),
 };
 
 static DEFINE_XARRAY(sr_forward_xa);
-- 
2.39.2


