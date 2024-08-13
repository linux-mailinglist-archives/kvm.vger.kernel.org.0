Return-Path: <kvm+bounces-23979-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A42489502B2
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 12:44:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4AEB01F22574
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 10:44:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C81D19AD73;
	Tue, 13 Aug 2024 10:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DNaKsous"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5159195F3A;
	Tue, 13 Aug 2024 10:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723545850; cv=none; b=b/NUsYxF/Lj4uRmH1tqgYcya7S8ptunNxA/Zl0IeL5J7qKsTM6yBp+dJ6d++v2lQ7j+gS1HSrYHxZD4ugoLBAIFPlHgEzrB12OK6thVuYtBggnXS1W3CT8usoKjAG+8PCpO24itEOBA1KDvfpWsQNgEkKhHYlKgn1rMYQM7hvDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723545850; c=relaxed/simple;
	bh=7fX/laNfN6aIbZht6rIbXQ1P0/oITbrzKHKH8jxO0Z4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ok5Dnz9Ve2o2tk+pwHjeCgoAShGXOnPOrX7u6JuTrGPOOeywY/iFadA6HO190lCjmWM1xFbj5AHlWQOc1BEacoAoPtIDCjg6+UZ7KqTppnMvRHbXXv7+bKff6BEpuaT42GAaVYLCQPQU5FxytOrZuWH9lAo8VzKcdB7ZSHFvvKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DNaKsous; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 614E7C4AF09;
	Tue, 13 Aug 2024 10:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723545850;
	bh=7fX/laNfN6aIbZht6rIbXQ1P0/oITbrzKHKH8jxO0Z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DNaKsousS7j0uD7/2771Rw1USj6CWUx3+F/AyICEpGpsWrMzhTml6g1PRoerXMVmF
	 2LxZA13koXclS78gR3xlnTS9L3cdQ2fB/dmi3M9Nkr2LT1ldUzBpFFS5twXiX5k/pe
	 ozqkK/LESkD8KsnpgInoqpWhSweMJ0iwh8e2iNa52NfJc/KGe7uAQSV8Ctiog2IZeL
	 +R954zHelsy+M2sg1h8O7TqF0l3SWjpD+AgQr+8uuE/8RXEIOIAOWmmkilpG48/fA5
	 XbIJTl4J0ioP9rxkD2krFs57MXHuS3kzHq3oYXJT7SVlDpyNhOKbBoa/4sW0TG3BC9
	 0MJ24qPbu9N8Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sdp0a-003JD1-BD;
	Tue, 13 Aug 2024 11:44:08 +0100
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
Subject: [PATCH v3 3/8] KVM: arm64: Move FPMR into the sysreg array
Date: Tue, 13 Aug 2024 11:43:55 +0100
Message-Id: <20240813104400.1956132-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240813104400.1956132-1-maz@kernel.org>
References: <20240813104400.1956132-1-maz@kernel.org>
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
index e5cf8af54dd6..021f7a1845f2 100644
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
index e6425414d301..4cb8ad5d69a8 100644
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
index 2dc6cab43b2f..79d67f19130d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1678,6 +1678,15 @@ static unsigned int sme_visibility(const struct kvm_vcpu *vcpu,
 	return REG_HIDDEN;
 }
 
+static unsigned int fp8_visibility(const struct kvm_vcpu *vcpu,
+				   const struct sys_reg_desc *rd)
+{
+	if (kvm_has_fpmr(vcpu->kvm))
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


