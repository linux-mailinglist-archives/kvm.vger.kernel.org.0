Return-Path: <kvm+bounces-29543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9861C9ACDF3
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 17:03:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C75DE1C23149
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 15:03:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1009D206E61;
	Wed, 23 Oct 2024 14:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BNqTecft"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095651CFEB3;
	Wed, 23 Oct 2024 14:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729695236; cv=none; b=FVF8/KyoOayEXjhMMq5U1EojKZEfHf5tkS5Z4xp7kuN3swUB9SUch0C5rPQjymxnDtDIqPWuE69xO6NKgjF1CcYUVKEFQDImGLWJeGLdgl1FhMXp3akHyVi8UoFjGu6DJWC5sTlB7f6MeChvDEC1DrqRxO6oIOmvAuA5gomoNeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729695236; c=relaxed/simple;
	bh=rAYE/pTG5IPhfJrFpLrgXvimEya8Y322Dd8HVgtMsAY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XrFrfsr0lA8ViCgqqwh6f6pBlO+7vH3vPn8Z7T+wD4V5FYi9Q6agyoSBuUv1BigjaCByDP9qt95nmLx9UIOXYy4leyvQxWOeDW6KbfBJrByI7M4b2SWa2PDW+Tmbk/PtXztgHjT4lSJf49cRK3AZ0gHVv9I7hCldaz2EheqkMgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BNqTecft; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0CACC4CEE7;
	Wed, 23 Oct 2024 14:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729695235;
	bh=rAYE/pTG5IPhfJrFpLrgXvimEya8Y322Dd8HVgtMsAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BNqTecftSXpsZ/shgLZyHd7S9tS8oGDDQkr6il5bW0YJy/NHcYTYgJpBBHVw3kHPJ
	 hwgcG0COiIrS9we8/HiFMBkqQBz9NUkxL2chR3DRG1K3eJLBpb5Wr/1ifWKcIH59xb
	 sF/9hiC9MBsJIQX3sxMvEq/XgeAcVe5JmhstjVbAvnNlueIi7dM9Zr2fr8n0Xin/Yu
	 al3j2dvlq4mJ3A/AKMTBbiaUaZDljTWyf9StqKNUdBM4KhBmGfwyNhqs440RXa2xPu
	 DxFjqlkJkRGZ7ooXvoCmrySViXptd03pH07hfEAap2uj8DZ0jSSqFVrvCE3wco6tGH
	 BKsADg1q8wqng==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1t3ckE-0068vz-7n;
	Wed, 23 Oct 2024 15:53:54 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v5 23/37] KVM: arm64: Define helper for EL2 registers with custom visibility
Date: Wed, 23 Oct 2024 15:53:31 +0100
Message-Id: <20241023145345.1613824-24-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241023145345.1613824-1-maz@kernel.org>
References: <20241023145345.1613824-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, alexandru.elisei@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

From: Mark Brown <broonie@kernel.org>

In preparation for adding more visibility filtering for EL2 registers add
a helper macro like EL2_REG() which allows specification of a custom
visibility operation.

Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20240822-kvm-arm64-hide-pie-regs-v2-1-376624fa829c@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index dfbfae40c53c5..cfb1e58a31c06 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2164,6 +2164,15 @@ static bool bad_redir_trap(struct kvm_vcpu *vcpu,
 	.val = v,				\
 }
 
+#define EL2_REG_FILTERED(name, acc, rst, v, filter) {	\
+	SYS_DESC(SYS_##name),			\
+	.access = acc,				\
+	.reset = rst,				\
+	.reg = name,				\
+	.visibility = filter,			\
+	.val = v,				\
+}
+
 #define EL2_REG_VNCR(name, rst, v)	EL2_REG(name, bad_vncr_trap, rst, v)
 #define EL2_REG_REDIR(name, rst, v)	EL2_REG(name, bad_redir_trap, rst, v)
 
@@ -2854,8 +2863,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG_VNCR(HFGITR_EL2, reset_val, 0),
 	EL2_REG_VNCR(HACR_EL2, reset_val, 0),
 
-	{ SYS_DESC(SYS_ZCR_EL2), .access = access_zcr_el2, .reset = reset_val,
-	  .visibility = sve_el2_visibility, .reg = ZCR_EL2 },
+	EL2_REG_FILTERED(ZCR_EL2, access_zcr_el2, reset_val, 0,
+			 sve_el2_visibility),
 
 	EL2_REG_VNCR(HCRX_EL2, reset_val, 0),
 
-- 
2.39.2


