Return-Path: <kvm+bounces-22921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B88E0944830
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 11:27:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 74707286ED7
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 09:26:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADD861A2C27;
	Thu,  1 Aug 2024 09:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FbldfUJ2"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC638173331;
	Thu,  1 Aug 2024 09:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722504155; cv=none; b=hbRP+mhqryrj7k3wbGYF3RfEs70dSMzKMGiWC6gYwVAFgqKT1T4mKXF/7I82sKbGfuXAB5QPNtbWQBk4XfQfRRE0762wM7+aBYMe1OV3RHkVSX6vYNiu0gTC7m4Snp4W/0N9rng1b01K+0NaX0AcMbtgFbOgFfj5opXeq+07cus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722504155; c=relaxed/simple;
	bh=7fX/laNfN6aIbZht6rIbXQ1P0/oITbrzKHKH8jxO0Z4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qCl++WT4KmYnUqsgUE+glOEJwp/ht+hZRIW0X+s3RfMrqnqlmZ6uSl+JOQyfnTjZlIhTLpIill40x2PVfLIHFEo5O44zXv9oI4vb2UN7yuJmu/zLi+YmojK1ZYi6OISjUi23sWCqUENKA7vu9F5Wu2MiwvBo58gaAS705GFFHqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FbldfUJ2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83237C4AF0A;
	Thu,  1 Aug 2024 09:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722504155;
	bh=7fX/laNfN6aIbZht6rIbXQ1P0/oITbrzKHKH8jxO0Z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FbldfUJ2xkpNnHzq1U7hAwr+Udwl9ABGSSQCU/JzSiBR0mhCMEavwViSCw8NIPaaF
	 MqpC92SsoguMFeoAtGMAljqONe/CZ+hAXDpDjrGA4ToYQk4yBQyVCi89e5XTo0Kz6J
	 04s73D49IxsFFs1Wy/S+TLZOmqHwUOaFMhji2c5WjNAbhu8d+OZj8Q2hRcy7Ra6gz8
	 5BE8VJ7WGKKv6g5Ix4t9/PxGGQh0Odgalk4luJsyCTvlMCRY4WVyXtDlc568VrPzwo
	 N+UYVVCntoIemck03T+0GApE2FPAEBvUqjj/9sgzh19xMm8c3bNsgzBTQ2d5hpiLQx
	 St0cvpC9t4IOQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sZRya-00HKNZ-8l;
	Thu, 01 Aug 2024 10:20:00 +0100
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
Subject: [PATCH v2 3/8] KVM: arm64: Move FPMR into the sysreg array
Date: Thu,  1 Aug 2024 10:19:50 +0100
Message-Id: <20240801091955.2066364-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240801091955.2066364-1-maz@kernel.org>
References: <20240801091955.2066364-1-maz@kernel.org>
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


