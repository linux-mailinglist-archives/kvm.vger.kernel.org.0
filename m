Return-Path: <kvm+bounces-25838-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5116496B472
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 10:24:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D7AF28858B
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 08:24:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6321186603;
	Wed,  4 Sep 2024 08:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lK8Pv7uV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75DF17279E;
	Wed,  4 Sep 2024 08:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725438280; cv=none; b=Znl40fCKC2xi/cJcu24V+b6nD8fhGiz3XNZsO9Ja7cWAuXIMvUs7zK0ESqovu+o0mK4TJaMlOlZ4jm8vhNRALMc+peo2NgjOw9OSn0Gy60PAQMnpNk/Pyv2FOJeKqKpR00Z1gzrje/t3ZlQmUaHcBu6SV+WNIU1YsQkKCjmI1mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725438280; c=relaxed/simple;
	bh=xIxn7pFaazMnNLaow2U2RFpl78qYQZADsRhk/aFuMDA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dRnbaldaKbpU8BhCPlwFn2pmWVCZ4rfEstXEjXF/E3PfZVTo12yeP4oOQRkVUK+VTPV7ud4QcnHz8/0iW9+PdEYRxbFiBz2K0k9NqXDVcwUsPdhOQ5X7PUFfpzf2ls39KomtuXwPwnezNMHeqAhfZRIReBznQ6i0VA4UgVATUNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lK8Pv7uV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90313C4AF0C;
	Wed,  4 Sep 2024 08:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725438280;
	bh=xIxn7pFaazMnNLaow2U2RFpl78qYQZADsRhk/aFuMDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lK8Pv7uVaM8ay9ZRDgWSyp/oCUG9wsKhrj29HfzCgqFOc53VoOqiSC5bN3al2MWYo
	 DB4ljJGq70CvJR2+NuvmR9npIOHuen01PxZoL+e/NnGw/aiBse9PFjjv7SO3ibaKUg
	 XErXRAz0nGfW1Fc2IsXd2X0QFgT1sEwxdphtH2u+cPicKtJzHGWotgE2ZfbK51Viv7
	 SpxZCJ37q2O5pBG8JLmpcaHPnURqglF+o8BnG+7tcLP3DnhAbhjMkdQMan8DTqk2Tr
	 xH9ZoNQLCI5IkAH2gxK+fYTckbHv++jlu6THNuh82k8wq4zIGmGq9DdeUKDy+AVUdu
	 r1ANSNNMST3Jg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sllJe-009VF3-LD;
	Wed, 04 Sep 2024 09:24:38 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 2/3] KVM: arm64: Simplify visibility handling of AArch32 SPSR_*
Date: Wed,  4 Sep 2024 09:24:18 +0100
Message-Id: <20240904082419.1982402-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240904082419.1982402-1-maz@kernel.org>
References: <20240904082419.1982402-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Since SPSR_* are not associated with any register in the sysreg array,
nor do they have .get_user()/.set_user() helpers, they are invisible to
userspace with that encoding.

Therefore hidden_user_visibility() serves no purpose here, and can be
safely removed.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 5328fac8d547..2586ad29eaa0 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2795,14 +2795,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_SP_EL1), access_sp_el1},
 
 	/* AArch32 SPSR_* are RES0 if trapped from a NV guest */
-	{ SYS_DESC(SYS_SPSR_irq), .access = trap_raz_wi,
-	  .visibility = hidden_user_visibility },
-	{ SYS_DESC(SYS_SPSR_abt), .access = trap_raz_wi,
-	  .visibility = hidden_user_visibility },
-	{ SYS_DESC(SYS_SPSR_und), .access = trap_raz_wi,
-	  .visibility = hidden_user_visibility },
-	{ SYS_DESC(SYS_SPSR_fiq), .access = trap_raz_wi,
-	  .visibility = hidden_user_visibility },
+	{ SYS_DESC(SYS_SPSR_irq), .access = trap_raz_wi },
+	{ SYS_DESC(SYS_SPSR_abt), .access = trap_raz_wi },
+	{ SYS_DESC(SYS_SPSR_und), .access = trap_raz_wi },
+	{ SYS_DESC(SYS_SPSR_fiq), .access = trap_raz_wi },
 
 	{ SYS_DESC(SYS_IFSR32_EL2), undef_access, reset_unknown, IFSR32_EL2 },
 	EL2_REG(AFSR0_EL2, access_rw, reset_val, 0),
-- 
2.39.2


