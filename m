Return-Path: <kvm+bounces-29539-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BC0EF9ACDEE
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 17:03:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7DDB9283F7B
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 15:03:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B603B205AD1;
	Wed, 23 Oct 2024 14:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="buAYQNXr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E38201031;
	Wed, 23 Oct 2024 14:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729695235; cv=none; b=Ol2K5izh7oOgIZDiw5qqdh6KkKT1nYrdK7jTKmszw265ugNiPiLitMuHUwR34bFfM5D1atDdNENzGq6+enrXNBGRfAmm7b5wgzt/wLUpb7wdr5BybczfWxBi6ntult5ads/ZcUM8gXOCioHNwM595cIRzNVIrCuQlW0F3xmEJYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729695235; c=relaxed/simple;
	bh=iEUI3OefKCYJFOSoEjBNdqE75OBAN4/6dLCG/GX/j98=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ik5DrDcqYaR8edGaYndh/koHpN+qn5c7Zw9WEjsJzmvLWDmVGfO2mxyIdy0ICEiAmCBFsJ6TYofb7JBo95NSB4olPFdiCfGdgdE9wagjh4Urw+jwROjcM1ULzm3pyJnc25nFqs83Pi06uzq/N30wxmh48txyFJiruTqaaRV6h0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=buAYQNXr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3EA2C4CEE8;
	Wed, 23 Oct 2024 14:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729695234;
	bh=iEUI3OefKCYJFOSoEjBNdqE75OBAN4/6dLCG/GX/j98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=buAYQNXrCKLIAniXatriI9shEhovLxcIunYqkjYdAO4TQ+z4lS+RLUCeklqUvF5HC
	 DxkwGBx74vvu7mxF3KOsx+PXOR0qCm+3pVvTCgjChcnaDnJP2+CrRzWjaa12W9sun1
	 VjJOh4+zhQ5yERrX83eZld3HvcumBe/h9NXAWJQcFWKZv/rZZG5kxVvR/h9yipoRma
	 ppEosL4M+ShTtLYD/emgFkBOJnjOtwMpoKkd6y0t/PJ8824cFq58mB/mMucKoIhMvg
	 CJyia2OcJR03DsGP/9Na715TH2IZQ0XfSkmosKqO7jAvEFLdCdb021J1zLQMZOUcrd
	 b50lgrQye4+2A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1t3ckD-0068vz-75;
	Wed, 23 Oct 2024 15:53:53 +0100
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
Subject: [PATCH v5 18/37] KVM: arm64: Add AT fast-path support for S1PIE
Date: Wed, 23 Oct 2024 15:53:26 +0100
Message-Id: <20241023145345.1613824-19-maz@kernel.org>
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

Emulating AT using AT instructions requires that the live state
matches the translation regime the AT instruction targets.

If targeting the EL1&0 translation regime and that S1PIE is
supported, we also need to restore that state (covering TCR2_EL1,
PIR_EL1, and PIRE0_EL1).

Add the required system register switcheroo.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/at.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index f04677127fbc0..b9d0992e91972 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -412,6 +412,9 @@ struct mmu_config {
 	u64	ttbr1;
 	u64	tcr;
 	u64	mair;
+	u64	tcr2;
+	u64	pir;
+	u64	pire0;
 	u64	sctlr;
 	u64	vttbr;
 	u64	vtcr;
@@ -424,6 +427,13 @@ static void __mmu_config_save(struct mmu_config *config)
 	config->ttbr1	= read_sysreg_el1(SYS_TTBR1);
 	config->tcr	= read_sysreg_el1(SYS_TCR);
 	config->mair	= read_sysreg_el1(SYS_MAIR);
+	if (cpus_have_final_cap(ARM64_HAS_TCR2)) {
+		config->tcr2	= read_sysreg_el1(SYS_TCR2);
+		if (cpus_have_final_cap(ARM64_HAS_S1PIE)) {
+			config->pir	= read_sysreg_el1(SYS_PIR);
+			config->pire0	= read_sysreg_el1(SYS_PIRE0);
+		}
+	}
 	config->sctlr	= read_sysreg_el1(SYS_SCTLR);
 	config->vttbr	= read_sysreg(vttbr_el2);
 	config->vtcr	= read_sysreg(vtcr_el2);
@@ -444,6 +454,13 @@ static void __mmu_config_restore(struct mmu_config *config)
 	write_sysreg_el1(config->ttbr1,	SYS_TTBR1);
 	write_sysreg_el1(config->tcr,	SYS_TCR);
 	write_sysreg_el1(config->mair,	SYS_MAIR);
+	if (cpus_have_final_cap(ARM64_HAS_TCR2)) {
+		write_sysreg_el1(config->tcr2, SYS_TCR2);
+		if (cpus_have_final_cap(ARM64_HAS_S1PIE)) {
+			write_sysreg_el1(config->pir, SYS_PIR);
+			write_sysreg_el1(config->pire0, SYS_PIRE0);
+		}
+	}
 	write_sysreg_el1(config->sctlr,	SYS_SCTLR);
 	write_sysreg(config->vttbr,	vttbr_el2);
 	write_sysreg(config->vtcr,	vtcr_el2);
@@ -914,6 +931,13 @@ static u64 __kvm_at_s1e01_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 	write_sysreg_el1(vcpu_read_sys_reg(vcpu, TTBR1_EL1),	SYS_TTBR1);
 	write_sysreg_el1(vcpu_read_sys_reg(vcpu, TCR_EL1),	SYS_TCR);
 	write_sysreg_el1(vcpu_read_sys_reg(vcpu, MAIR_EL1),	SYS_MAIR);
+	if (kvm_has_feat(vcpu->kvm, ID_AA64MMFR3_EL1, TCRX, IMP)) {
+		write_sysreg_el1(vcpu_read_sys_reg(vcpu, TCR2_EL1), SYS_TCR2);
+		if (kvm_has_feat(vcpu->kvm, ID_AA64MMFR3_EL1, S1PIE, IMP)) {
+			write_sysreg_el1(vcpu_read_sys_reg(vcpu, PIR_EL1), SYS_PIR);
+			write_sysreg_el1(vcpu_read_sys_reg(vcpu, PIRE0_EL1), SYS_PIRE0);
+		}
+	}
 	write_sysreg_el1(vcpu_read_sys_reg(vcpu, SCTLR_EL1),	SYS_SCTLR);
 	__load_stage2(mmu, mmu->arch);
 
-- 
2.39.2


