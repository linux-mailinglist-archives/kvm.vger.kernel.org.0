Return-Path: <kvm+bounces-26526-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E9659754B6
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 15:55:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EFEC0B23F9C
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 13:55:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD61D1ABEA7;
	Wed, 11 Sep 2024 13:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BqF8PIPo"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DFFD1A7AF6;
	Wed, 11 Sep 2024 13:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726062721; cv=none; b=cjFu3umK13tNlEDfx/FWPpDzV0nbwbe1Igno5GOEAwVIurrQu3QTGTSHqHQH2u8WjlGvZ9WKga3DypwA+KODoGrU6X7e098swc+QF5VAG62vtYhDMEezZUm8L1/ODsSVtmqPF3cSg/j966Yw627oFaM8dssq0uMIEbQFWTCkwhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726062721; c=relaxed/simple;
	bh=PTUzu+KadUY07TjmmveL7BnYa56xmn8W8GB86+YtGDU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZIuHwSXMe9mb3YWJ6ZYmt4uJ2Idx+GkXz4MWzl18Ge7tYE0bzaKdD8nObN1F3X28TirEmOqVFmo5JgWCmdB8Ho5YSZdDCcDXIqLi3Ofk8sMmqAXq4R5T5lFczxzr62U8lUbe/iYZ+Pwx38Sr8wrlOKm233J7Y7pc/ZsX4u1IHlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BqF8PIPo; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D5C0C4CEC7;
	Wed, 11 Sep 2024 13:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726062721;
	bh=PTUzu+KadUY07TjmmveL7BnYa56xmn8W8GB86+YtGDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BqF8PIPo5x+6knSjQwrjTre3OK3VvcwpWDzu8cIx6lUBc/sjm0XSA/C0RdgQq1Y9s
	 2ZQcPKOOLenmJvueGw4JGJKECicObHmF4SBBZ6NkYebs19iNFQZAcmAbLcbRZfSwr2
	 hXxmBtJQJAeUZUO3OxVY1qNfmdt3prPj+YH0aLIzMD4wz3gWkmoWXagweyCiluKuTO
	 Jf9ETqKOhviPKIkleKQiXWuBD94E89t7tGRjCyjrF+cndfaig9OHJKyFkqW7WS/NQb
	 6Xr1OZ4zE8cQ5bPWi6YfTX6qT6ONvyhKsJWR83q2lcFKx3MFldUbapSbcpkPPTC1om
	 HHMb53IMPzglQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1soNlH-00C7tL-OE;
	Wed, 11 Sep 2024 14:51:59 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v3 17/24] KVM: arm64: Add AT fast-path support for S1PIE
Date: Wed, 11 Sep 2024 14:51:44 +0100
Message-Id: <20240911135151.401193-18-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240911135151.401193-1-maz@kernel.org>
References: <20240911135151.401193-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, broonie@kernel.org
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
index 39f0e87a340e8..73b2ee662f371 100644
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


