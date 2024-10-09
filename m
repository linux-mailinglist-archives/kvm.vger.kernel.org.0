Return-Path: <kvm+bounces-28336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F82299754C
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 21:03:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A3EE71C20CD1
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 19:03:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB67A1E6310;
	Wed,  9 Oct 2024 19:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ass0Lweb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58821E490B;
	Wed,  9 Oct 2024 19:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728500447; cv=none; b=ItF0sHkA++fAHX8trX0FlFs2W9ik+XVarOHBoj8Sl4zZBI6wWpDWuYAi1hQLFgvphf2ux0Eb5INYFV44HYsy7ya99VH2KxUIZCyC9UZ2aXqenhC8O/1gKZzvvIbteLDvXVbsS2LpBZ74oNJcb6CDamEpgKZ2dz7miNTf5pU5dG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728500447; c=relaxed/simple;
	bh=esawiB4pint59b2PVHFhbfucY1Re3ij8MlHEdNWXFU4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=M4XvtXd2YlZg22yTT0N8fVZ9TH7VE2pi3hoJE1G0A13E4f7kyQDnkhiVhEWoKv5entvyJWAbLuPCnr86KMD8PlDz4hnjKB27N5xaAEEQeLeR7C2cwYAiRHZ7LXiJJIq3DebPL8MIkYEnW/uUPtaapqvEme+Gwttvesh87l9mXoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ass0Lweb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9329C4CECF;
	Wed,  9 Oct 2024 19:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728500447;
	bh=esawiB4pint59b2PVHFhbfucY1Re3ij8MlHEdNWXFU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ass0LwebBEV6ajl54kfCGkB6cGF+0OIIHGAn0WTZD2x8ueLCMks5PNuB3le2/wIi3
	 I9I7lS6z3ZqvI+ePGMSnKJVShzqON2JKuIE1bqSjUdBYzYVKidpDz5uJLJ/JU3X8pI
	 H1ZDqWPdVPUNXUzy+1QVECNZ81kMXDxV9jrTN6Agfn+IoXzJ/L8p+kwAgMbVkLqyvQ
	 EFl2yOa+s+xZNwOlihtglqiy1GWWm/dQJIrFdGNXzH0UDH07ui3CesCOwG5K1a2AxP
	 NBD03iTBtoOi5Wow7TwWQaikX4FaUzmv35c6R8tdAZ2Kb23U3fF0M6snyAyEv1vZll
	 ohBMVVcrtr58g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sybvR-001wcY-Uw;
	Wed, 09 Oct 2024 20:00:46 +0100
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
Subject: [PATCH v4 25/36] KVM: arm64: Rely on visibility to let PIR*_ELx/TCR2_ELx UNDEF
Date: Wed,  9 Oct 2024 20:00:08 +0100
Message-Id: <20241009190019.3222687-26-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241009190019.3222687-1-maz@kernel.org>
References: <20241009190019.3222687-1-maz@kernel.org>
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

With a visibility defined for these registers, there is no need
to check again for S1PIE or TCRX being implemented as perform_access()
already handles it.

Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 34 +++-------------------------------
 1 file changed, 3 insertions(+), 31 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 090194bf1d8d5..b5c2662662af9 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -369,18 +369,6 @@ static bool access_rw(struct kvm_vcpu *vcpu,
 	return true;
 }
 
-static bool check_s1pie_access_rw(struct kvm_vcpu *vcpu,
-				  struct sys_reg_params *p,
-				  const struct sys_reg_desc *r)
-{
-	if (!kvm_has_feat(vcpu->kvm, ID_AA64MMFR3_EL1, S1PIE, IMP)) {
-		kvm_inject_undefined(vcpu);
-		return false;
-	}
-
-	return access_rw(vcpu, p, r);
-}
-
 /*
  * See note at ARMv7 ARM B1.14.4 (TL;DR: S/W ops are not easily virtualized).
  */
@@ -445,10 +433,6 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
 	bool was_enabled = vcpu_has_cache_enabled(vcpu);
 	u64 val, mask, shift;
 
-	if (reg_to_encoding(r) == SYS_TCR2_EL1 &&
-	    !kvm_has_feat(vcpu->kvm, ID_AA64MMFR3_EL1, TCRX, IMP))
-		return undef_access(vcpu, p, r);
-
 	BUG_ON(!p->is_write);
 
 	get_access_mask(r, &mask, &shift);
@@ -467,18 +451,6 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
 	return true;
 }
 
-static bool access_tcr2_el2(struct kvm_vcpu *vcpu,
-			    struct sys_reg_params *p,
-			    const struct sys_reg_desc *r)
-{
-	if (!kvm_has_feat(vcpu->kvm, ID_AA64MMFR3_EL1, TCRX, IMP)) {
-		kvm_inject_undefined(vcpu);
-		return false;
-	}
-
-	return access_rw(vcpu, p, r);
-}
-
 static bool access_actlr(struct kvm_vcpu *vcpu,
 			 struct sys_reg_params *p,
 			 const struct sys_reg_desc *r)
@@ -2914,7 +2886,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(TTBR0_EL2, access_rw, reset_val, 0),
 	EL2_REG(TTBR1_EL2, access_rw, reset_val, 0),
 	EL2_REG(TCR_EL2, access_rw, reset_val, TCR_EL2_RES1),
-	EL2_REG_FILTERED(TCR2_EL2, access_tcr2_el2, reset_val, TCR2_EL2_RES1,
+	EL2_REG_FILTERED(TCR2_EL2, access_rw, reset_val, TCR2_EL2_RES1,
 			 tcr2_el2_visibility),
 	EL2_REG_VNCR(VTTBR_EL2, reset_val, 0),
 	EL2_REG_VNCR(VTCR_EL2, reset_val, 0),
@@ -2943,9 +2915,9 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(HPFAR_EL2, access_rw, reset_val, 0),
 
 	EL2_REG(MAIR_EL2, access_rw, reset_val, 0),
-	EL2_REG_FILTERED(PIRE0_EL2, check_s1pie_access_rw, reset_val, 0,
+	EL2_REG_FILTERED(PIRE0_EL2, access_rw, reset_val, 0,
 			 s1pie_el2_visibility),
-	EL2_REG_FILTERED(PIR_EL2, check_s1pie_access_rw, reset_val, 0,
+	EL2_REG_FILTERED(PIR_EL2, access_rw, reset_val, 0,
 			 s1pie_el2_visibility),
 	EL2_REG(AMAIR_EL2, access_rw, reset_val, 0),
 
-- 
2.39.2


