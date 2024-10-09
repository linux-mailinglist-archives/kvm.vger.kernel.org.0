Return-Path: <kvm+bounces-28333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A941997549
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 21:03:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CBC87B2653B
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 19:03:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58D4B1E5726;
	Wed,  9 Oct 2024 19:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sRYdeNTW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B1AE1E47B3;
	Wed,  9 Oct 2024 19:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728500447; cv=none; b=UGz0P1vv5EyDYcXCnbqCoPip8OapJty8OAGGg8pnMEtvGf02NaGsPJHqIrbXdKz+Xakv/m+h9GLquin5ZQ7BIXV0UATOSO+vcIyvRbaOKiXJnXZMbD4TRTyTtIfL8gZnf9VA5pJH1qxgmEYHA4/z/SdAbonjyBUODHkCPe/uXDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728500447; c=relaxed/simple;
	bh=epoT6/esI1Jik2zpZgz5IDoFxGAgX4t7Ypv2JmRszAE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=t4h/QWmerQ70KtJxw6Uu3oHXT6FtUQYfZIFhln1eNwgvsVFZxqIWJNcSJo5rLhTMwpGAh+PI8AxiE1Bp+qBjyUbU0ZVrGq7CfHbLLq6MSGZOyw5CSprmxwzO3/RD6ztMIe2+pbuTYG60HwZaL7jHbN9thCc9SeX1eAynokLU/qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sRYdeNTW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE6FC4CEC3;
	Wed,  9 Oct 2024 19:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728500447;
	bh=epoT6/esI1Jik2zpZgz5IDoFxGAgX4t7Ypv2JmRszAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sRYdeNTWvgb0As/wtSBa1wBYt3PxHFusxxXyEA7oYJsmDIv5ZmgI1hg0XyvUuKhmX
	 YTeRIlkoM6w9UkGL1g3KhoZ2/TykrO4lZWeCGBrOaqLY7XIhEnE/inrx9GclGxnpjT
	 8GqzEwJQ2vTHCwa4LKzkIjm733qHegmYEXKeE1M6h3sGrSyXUmcdWM43RWQRnd8sUy
	 HD/iS86AzpbedxvJc66z/y0+Nsta/Kjh/KWKAGZXdZw1FfzozSul9M7/E8MhId7X0Q
	 Yy6QCGZz+g20c49Lr+yzQ5OrAf0iICRqiZMK9zY/BWP2ha0UXVzk1kcUbXDeckl+ej
	 7/Enb1xBEo+fg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sybvR-001wcY-FU;
	Wed, 09 Oct 2024 20:00:45 +0100
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
Subject: [PATCH v4 23/36] KVM: arm64: Hide TCR2_EL1 from userspace when disabled for guests
Date: Wed,  9 Oct 2024 20:00:06 +0100
Message-Id: <20241009190019.3222687-24-maz@kernel.org>
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

From: Mark Brown <broonie@kernel.org>

When the guest does not support FEAT_TCR2 we should not allow any access
to it in order to ensure that we do not create spurious issues with guest
migration. Add a visibility operation for it.

Fixes: fbff56068232 ("KVM: arm64: Save/restore TCR2_EL1")
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20240822-kvm-arm64-hide-pie-regs-v2-2-376624fa829c@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/kvm/sys_regs.c         | 29 ++++++++++++++++++++++++++---
 2 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 1a5477181447c..197a7a08b3af5 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1511,4 +1511,7 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
 	(system_supports_fpmr() &&			\
 	 kvm_has_feat((k), ID_AA64PFR2_EL1, FPMR, IMP))
 
+#define kvm_has_tcr2(k)				\
+	(kvm_has_feat((k), ID_AA64MMFR3_EL1, TCRX, IMP))
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 170a5bed68fe3..6226949b5bc79 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2348,6 +2348,27 @@ static unsigned int s1poe_visibility(const struct kvm_vcpu *vcpu,
 	return REG_HIDDEN;
 }
 
+static unsigned int tcr2_visibility(const struct kvm_vcpu *vcpu,
+				    const struct sys_reg_desc *rd)
+{
+	if (kvm_has_tcr2(vcpu->kvm))
+		return 0;
+
+	return REG_HIDDEN;
+}
+
+static unsigned int tcr2_el2_visibility(const struct kvm_vcpu *vcpu,
+				    const struct sys_reg_desc *rd)
+{
+	unsigned int r;
+
+	r = el2_visibility(vcpu, rd);
+	if (r)
+		return r;
+
+	return tcr2_visibility(vcpu, rd);
+}
+
 /*
  * Architected system registers.
  * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
@@ -2532,7 +2553,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_TTBR0_EL1), access_vm_reg, reset_unknown, TTBR0_EL1 },
 	{ SYS_DESC(SYS_TTBR1_EL1), access_vm_reg, reset_unknown, TTBR1_EL1 },
 	{ SYS_DESC(SYS_TCR_EL1), access_vm_reg, reset_val, TCR_EL1, 0 },
-	{ SYS_DESC(SYS_TCR2_EL1), access_vm_reg, reset_val, TCR2_EL1, 0 },
+	{ SYS_DESC(SYS_TCR2_EL1), access_vm_reg, reset_val, TCR2_EL1, 0,
+	  .visibility = tcr2_visibility },
 
 	PTRAUTH_KEY(APIA),
 	PTRAUTH_KEY(APIB),
@@ -2869,7 +2891,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(TTBR0_EL2, access_rw, reset_val, 0),
 	EL2_REG(TTBR1_EL2, access_rw, reset_val, 0),
 	EL2_REG(TCR_EL2, access_rw, reset_val, TCR_EL2_RES1),
-	EL2_REG(TCR2_EL2, access_tcr2_el2, reset_val, TCR2_EL2_RES1),
+	EL2_REG_FILTERED(TCR2_EL2, access_tcr2_el2, reset_val, TCR2_EL2_RES1,
+			 tcr2_el2_visibility),
 	EL2_REG_VNCR(VTTBR_EL2, reset_val, 0),
 	EL2_REG_VNCR(VTCR_EL2, reset_val, 0),
 
@@ -4738,7 +4761,7 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
 		if (kvm_has_feat(kvm, ID_AA64ISAR2_EL1, MOPS, IMP))
 			vcpu->arch.hcrx_el2 |= (HCRX_EL2_MSCEn | HCRX_EL2_MCE2);
 
-		if (kvm_has_feat(kvm, ID_AA64MMFR3_EL1, TCRX, IMP))
+		if (kvm_has_tcr2(kvm))
 			vcpu->arch.hcrx_el2 |= HCRX_EL2_TCR2En;
 
 		if (kvm_has_fpmr(kvm))
-- 
2.39.2


