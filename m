Return-Path: <kvm+bounces-21098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC4CA92A5F9
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 17:45:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3BB5CB217F9
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 15:45:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D44D6145324;
	Mon,  8 Jul 2024 15:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XKz2zPN+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012AD1422CA;
	Mon,  8 Jul 2024 15:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720453495; cv=none; b=A9Pn8/Bh5zLN6VLzsj//hYIuUyp2hEnT4+sjVlKdiy/GJU1DOcf8cEfbNY69+CRG7dgp+AwTiJCjs1wzrT5dLCSQq0nxbVoeKF2hndlx4i0cg3FFyfCqALr4duaR6PQkqmiszk62eo6Uy4v6bY4syv5FyXzCSVUX4u6mXPEeL3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720453495; c=relaxed/simple;
	bh=iFWcrgnnLVyozv323EWmLqXVQmcY+xMWCYUY9LRYxjs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BP80wbYNyPD/kW3J1PXf+jfzj3b7XNHgJAQdL9oJW+DLHvlXW2Xadu4vFGWIZ+FsGpv1Q4o4CPbpsRqgffTovb/vpD4q2uYPtDWlu2BwpiFf3Z7NN+c4TCezdX8hxWLy4ymVhfEiK6spEEfHIxjv02UvOS/VcRoSUt4shx36Vdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XKz2zPN+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A56CC32786;
	Mon,  8 Jul 2024 15:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720453494;
	bh=iFWcrgnnLVyozv323EWmLqXVQmcY+xMWCYUY9LRYxjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XKz2zPN+vPcCH67ovDxSFL6OpG2f86/OM9Xo5c3U6TJzZwtEgfAOX83JVRGXqI2ky
	 wh3DicfoZwDxI+ziJQnB1oJUU7gg/OVjeLLSPrqfauo2REzOfdOf7KaUWqjMqirWIV
	 S6DG54LTYqfEeT49tm9G2Fm6CRvFazsKMsU9LRN82GnAtRcnqvyKaJuFc8XVm0Fa5y
	 5ZFzeN00V/H+My/dd63QRJioSoE51bAXLYLPbk0udH+QUAbc3nR44ZILKHS/Q7LlRt
	 naJmtkvzvyHRqL+CKywml44rJ/prl5NEk4fnI+kYc8+GNyGdw6DvasShABpiV8EuIm
	 IinGCKI8l5+WQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sQqXs-00Ae1P-QA;
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
Subject: [PATCH 2/7] KVM: arm64: Move FPMR into the sysreg array
Date: Mon,  8 Jul 2024 16:44:33 +0100
Message-Id: <20240708154438.1218186-3-maz@kernel.org>
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

Just like SVCR, FPMR is currently stored at the wrong location.

Let's move it where it belongs.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  2 +-
 arch/arm64/kvm/fpsimd.c           |  2 +-
 arch/arm64/kvm/sys_regs.c         | 10 ++++++++++
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0b3d7697ca0a7..a14c18e8b173a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -448,6 +448,7 @@ enum vcpu_sysreg {
 
 	/* FP/SIMD/SVE */
 	SVCR,
+	FPMR,
 
 	/* 32bit specific registers. */
 	DACR32_EL2,	/* Domain Access Control Register */
@@ -667,7 +668,6 @@ struct kvm_vcpu_arch {
 	void *sve_state;
 	enum fp_type fp_type;
 	unsigned int sve_max_vl;
-	u64 fpmr;
 
 	/* Stage 2 paging state used by the hardware on next switch */
 	struct kvm_s2_mmu *hw_mmu;
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index e6425414d301f..4cb8ad5d69a80 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -135,7 +135,7 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
 		fp_state.sve_vl = vcpu->arch.sve_max_vl;
 		fp_state.sme_state = NULL;
 		fp_state.svcr = &__vcpu_sys_reg(vcpu, SVCR);
-		fp_state.fpmr = &vcpu->arch.fpmr;
+		fp_state.fpmr = &__vcpu_sys_reg(vcpu, FPMR);
 		fp_state.fp_type = &vcpu->arch.fp_type;
 
 		if (vcpu_has_sve(vcpu))
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 2dc6cab43b2f8..326262abc2ff4 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1678,6 +1678,15 @@ static unsigned int sme_visibility(const struct kvm_vcpu *vcpu,
 	return REG_HIDDEN;
 }
 
+static unsigned int fp8_visibility(const struct kvm_vcpu *vcpu,
+				   const struct sys_reg_desc *rd)
+{
+	if (kvm_has_feat(vcpu->kvm, ID_AA64PFR2_EL1, FPMR, IMP))
+		return 0;
+
+	return REG_HIDDEN;
+}
+
 static u64 read_sanitised_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
 					  const struct sys_reg_desc *rd)
 {
@@ -2545,6 +2554,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 			     CTR_EL0_DminLine_MASK |
 			     CTR_EL0_IminLine_MASK),
 	{ SYS_DESC(SYS_SVCR), undef_access, reset_val, SVCR, 0, .visibility = sme_visibility  },
+	{ SYS_DESC(SYS_FPMR), undef_access, reset_val, FPMR, 0, .visibility = fp8_visibility },
 
 	{ PMU_SYS_REG(PMCR_EL0), .access = access_pmcr, .reset = reset_pmcr,
 	  .reg = PMCR_EL0, .get_user = get_pmcr, .set_user = set_pmcr },
-- 
2.39.2


