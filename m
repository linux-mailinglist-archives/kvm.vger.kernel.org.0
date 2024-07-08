Return-Path: <kvm+bounces-21100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA2A392A5F8
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 17:45:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 943B0283FE1
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 15:45:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7296145325;
	Mon,  8 Jul 2024 15:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eM2Lm+0T"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01337143729;
	Mon,  8 Jul 2024 15:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720453495; cv=none; b=qstOUUuc6n6CLWZG6iXPA/dcda/BA2wW6dxjZCYsprvBLDZRSpqJ4lJfmsijxiw6naRhS/eQLLL1n6qhoJJQ5WG5GP8zPsSokDC3JyD0SHY0autlzKSMBi8k6rfy9RbUk94ObtlRg0qAsPEQOEe8XqxSD1ofkEqxd9uET1DImAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720453495; c=relaxed/simple;
	bh=z+XPKWi16ciRyxOZ+JoGHM1luReodmKcD3K070W/iM0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hoUEA7ah6hAd/ccRNYxWxV2sJJ8Esvn4c4/+jhsXsiw/O7DcMuygX1GLiFNZNgCOf/GD68gSiLKe00tj5s9EmaNdeLbfoqg+CNjV5W06m7s4VisToTxXWhaSDDvvXUD6fGAXWh6/wB0oA12RRTlSALeG61nZtQsV2THJRc1/R+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eM2Lm+0T; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A536C116B1;
	Mon,  8 Jul 2024 15:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720453494;
	bh=z+XPKWi16ciRyxOZ+JoGHM1luReodmKcD3K070W/iM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eM2Lm+0T9sDaXxYc64rGyTgOqgCVKgHzPAPV0Abww0GRMVvBgfmh9a3TpIpJLhhXZ
	 0qLhfpqfvWVD0RLQX4Vj6nVh+jD3MuG3rW2+zLEUesS6z8/N3M3W2QP6Nz3dn3TU6p
	 ZtXA8X8ymgliMvFUVu5xlRzj2kdK3nMdJuDZVwUamxw0jz+8j6u/6c0/ex7wPZH7oa
	 oSKyBBAp+u/5sZ6O+sZgUD7BtT3MILDIzC+LGe8bw7g7HQ15v10Jb0xpypI9qbiPeS
	 cdif+VCclm+Kr3k3AMNqWP7dm9oxEoC6V6p4cqMDSuQOq2mWC425jW4sTIa7IoTOfy
	 /ZOa6mfWscL6g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sQqXs-00Ae1P-Hk;
	Mon, 08 Jul 2024 16:44:52 +0100
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
Subject: [PATCH 1/7] KVM: arm64: Move SVCR into the sysreg array
Date: Mon,  8 Jul 2024 16:44:32 +0100
Message-Id: <20240708154438.1218186-2-maz@kernel.org>
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

SVCR is just a system register, and has no purpose being outside
of the sysreg array. If anything, it only makes it more difficult
to eventually support SME one day. If ever.

Move it into the array with its little friends, and associate it
with a visibility predicate.

Although this is dead code, it at least paves the way for the
next set of FP-related extensions.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  4 +++-
 arch/arm64/kvm/fpsimd.c           |  2 +-
 arch/arm64/kvm/sys_regs.c         | 11 ++++++++++-
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 25a3b72fbacf2..0b3d7697ca0a7 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -446,6 +446,9 @@ enum vcpu_sysreg {
 	GCR_EL1,	/* Tag Control Register */
 	TFSRE0_EL1,	/* Tag Fault Status Register (EL0) */
 
+	/* FP/SIMD/SVE */
+	SVCR,
+
 	/* 32bit specific registers. */
 	DACR32_EL2,	/* Domain Access Control Register */
 	IFSR32_EL2,	/* Instruction Fault Status Register */
@@ -664,7 +667,6 @@ struct kvm_vcpu_arch {
 	void *sve_state;
 	enum fp_type fp_type;
 	unsigned int sve_max_vl;
-	u64 svcr;
 	u64 fpmr;
 
 	/* Stage 2 paging state used by the hardware on next switch */
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index c53e5b14038dc..e6425414d301f 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -134,7 +134,7 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
 		fp_state.sve_state = vcpu->arch.sve_state;
 		fp_state.sve_vl = vcpu->arch.sve_max_vl;
 		fp_state.sme_state = NULL;
-		fp_state.svcr = &vcpu->arch.svcr;
+		fp_state.svcr = &__vcpu_sys_reg(vcpu, SVCR);
 		fp_state.fpmr = &vcpu->arch.fpmr;
 		fp_state.fp_type = &vcpu->arch.fp_type;
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c90324060436b..2dc6cab43b2f8 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1669,6 +1669,15 @@ static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
 	return REG_HIDDEN;
 }
 
+static unsigned int sme_visibility(const struct kvm_vcpu *vcpu,
+				   const struct sys_reg_desc *rd)
+{
+	if (kvm_has_feat(vcpu->kvm, ID_AA64PFR1_EL1, SME, IMP))
+		return 0;
+
+	return REG_HIDDEN;
+}
+
 static u64 read_sanitised_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 					  const struct sys_reg_desc *rd)
 {
@@ -2535,7 +2544,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 			     CTR_EL0_IDC_MASK |
 			     CTR_EL0_DminLine_MASK |
 			     CTR_EL0_IminLine_MASK),
-	{ SYS_DESC(SYS_SVCR), undef_access },
+	{ SYS_DESC(SYS_SVCR), undef_access, reset_val, SVCR, 0, .visibility = sme_visibility  },
 
 	{ PMU_SYS_REG(PMCR_EL0), .access = access_pmcr, .reset = reset_pmcr,
 	  .reg = PMCR_EL0, .get_user = get_pmcr, .set_user = set_pmcr },
-- 
2.39.2


