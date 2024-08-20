Return-Path: <kvm+bounces-24633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E689E9587BA
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 15:19:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 80954B21EB5
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 13:18:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D71C01917F6;
	Tue, 20 Aug 2024 13:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HeypVupP"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F5519048C;
	Tue, 20 Aug 2024 13:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724159889; cv=none; b=FPE6n5emjyqTadwgfjxqltkCLHm0yWgizs9stbgLikt6XwxWaSf91OqgMCSx93gpj8C3k2CsYGNlBflY9ZLlrOOAjByPRUWcPI9tm7e5JX3fyWVVn5Ll2nLx6oVODloXrfMezUlvkV8AH9m7fKQOBD4pF3q3xoRlUmNvy1f/gqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724159889; c=relaxed/simple;
	bh=mcDksh3U4KLI5FYXHkvHzDVOLwp0prVY32Ojy0Do63s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=t/h17oF+2PD/s7OOGuqBxt+1unhBKsE/VVm2zT9tp4k9s5/u/+kjA9rNrshsPFVLb/kMgg1RgdGQEPwfX/f24q051zTlll0/zsn+QIWAQDAV7Ni/kH6JMaVrFj/lv4GovGbhqVOaWYP1iS7lLIBGIFgD02c/PVxDmtfitojOiOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HeypVupP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB192C4AF12;
	Tue, 20 Aug 2024 13:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724159889;
	bh=mcDksh3U4KLI5FYXHkvHzDVOLwp0prVY32Ojy0Do63s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HeypVupPBTc/dbLmV6NEDrBtyAUZgrHs38t1Li59AYc8kKscqQ5ADoylXAKJTWw4T
	 gJ6zntrJfo+oj4ItodH3QO05gkM4w4epqJiBQ5kpDkRx6IoXeb/4a78A15B0nWSvCu
	 oXEiH9mFcoKX2JXPDOhmL8DKFesiKDKN30eiTd4eo1tS4uHSE6NYSCn1w11rCzDwVu
	 0VY8txl0UZpnScMBPNL+dQOtFL9UgRfCCHq6IdxevoUYIDKUmODbk7WYiMBPoF1ylT
	 oQQKzemp4uK1aUTgBuMtYKCdPmeGaKfBlLzx7TZDwYrkFZGiu95EOnVD9/FfzdXGg/
	 /ygZJA1z6PxTw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sgOkQ-005HMQ-W7;
	Tue, 20 Aug 2024 14:18:07 +0100
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
Subject: [PATCH v4 5/8] KVM: arm64: Honor trap routing for FPMR
Date: Tue, 20 Aug 2024 14:17:59 +0100
Message-Id: <20240820131802.3547589-6-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240820131802.3547589-1-maz@kernel.org>
References: <20240820131802.3547589-1-maz@kernel.org>
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
index 05166eccea0a..ee280239f14f 100644
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


