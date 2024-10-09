Return-Path: <kvm+bounces-28334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 856AF99754A
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 21:03:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 066231F254B9
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 19:03:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 997261E3DEF;
	Wed,  9 Oct 2024 19:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ty+/wyUu"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40501E47C2;
	Wed,  9 Oct 2024 19:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728500447; cv=none; b=MVhgdFnmsx7OTRXnIHi7QuOn/fpPieHOFnbUsg7AjEoBrSVRKlNVlTo26f9GTTs1iV4gxzl399C5l9qwPugq+tYQTrdd99kaXYa9iGlhZVUtrypRHvuBZTbdS9j415xlUKwe6hhqzQyCv72cT16AnUdjs+t9rdjGGYvfhHqP0fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728500447; c=relaxed/simple;
	bh=iEUI3OefKCYJFOSoEjBNdqE75OBAN4/6dLCG/GX/j98=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XQsuewD2itnUtWPI3FHd2qA81WB1RJtF9S3BHapEwABvxH0VPuRzl/w4Acz/em/+Xi8+cNVbOoXzjCtoYfb6MPwv+i4Y2SwNjkdvtFtuhJkF9em6PmBt6MRyxVDoyhjuIogvC5ZxcXqHM6sHQw10mlUuuv5tY4HDHgmTzBlGx+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ty+/wyUu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 334F8C4CEDE;
	Wed,  9 Oct 2024 19:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728500446;
	bh=iEUI3OefKCYJFOSoEjBNdqE75OBAN4/6dLCG/GX/j98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ty+/wyUuAT5XRb76XfW9QtAeZ2hoMRTSi5sLt2TJE1PjDRF7+dgd7em1MHJowZioD
	 nFswA53NZoqTJeRFSxApjku6qku8RmH0PLQ6VOoX7gt3w1kZ4eSg1JxAc7jp3p/0xA
	 AnZtubpBaNq9Xn0ouPfEyCsMsekbYoIgtPW1MHjii1HRryQwWe6k/OgGsPaxTVetYb
	 KwKz1C8YUTSF/CflpwiFjgARUCQnH7lp/yjDGkW1OUbmg0OfJz7FjLecvYFKY8AhP5
	 yIkT+aXK+8Z8WafDs4jm30c60TFqoT54mvi/JaSsFSWJhk4AGv27xIpsPR1NQe9Qis
	 ZVWLDb/SAJ7wQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sybvQ-001wcY-BK;
	Wed, 09 Oct 2024 20:00:44 +0100
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
Subject: [PATCH v4 18/36] KVM: arm64: Add AT fast-path support for S1PIE
Date: Wed,  9 Oct 2024 20:00:01 +0100
Message-Id: <20241009190019.3222687-19-maz@kernel.org>
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


