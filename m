Return-Path: <kvm+bounces-52324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86498B03E9B
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 14:27:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5530617E098
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 12:27:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82E8724DCEF;
	Mon, 14 Jul 2025 12:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tIpowd8s"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83FC248867;
	Mon, 14 Jul 2025 12:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752496004; cv=none; b=Hw8j89n6WoKKT8nmrKrCO7LIsh9T+40Pq9CKm0SsXkI6W18V7yA2ZB0/CmvIsXadl6t53mZHfUL9DIXYMKgfLjt+9X1nSa6Nf397RLhmOl6zBsTb0cBztq8FMVJTqBl9ZuhQEmaGbik5JhCPXouZkq/rkkqxyPonubQ1tzssRFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752496004; c=relaxed/simple;
	bh=oPzbGHGeVu+nT4YQkdz1GWTqOXl99JZGFHJpmPxIG3A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qruxHCvZRQK6HYx1VsnQhbaEh1Rw3u2UREdgnr+rTSPG1ivuLENCNvKBh9PnsbKR1ZTlS732LYYARRH5+CK8z3E//USCWVgDFDgmHmQmeSj1dA/8qcN+NsfSe7xufFwsrUyYiJA+669VK376nwaSwcLRjwKAZLUJCRgFQxY6BTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tIpowd8s; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A10FC4CEF4;
	Mon, 14 Jul 2025 12:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752496004;
	bh=oPzbGHGeVu+nT4YQkdz1GWTqOXl99JZGFHJpmPxIG3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tIpowd8sTbXVc+WpSEVQI/e2BJ2BKNX294WLuYUB2pFUV6VVI5W1dftQxOGADlvVl
	 cTaLx2Bm/xq2cqRsGVibOsuGFEtYXWLTtVOwrsxFTAQi7mRx+7JDrAiNuM7J0OUsGt
	 FhAkPK9eGLeFEGVTAGTlTyy7r2Q8oCRhP+7h60yJK2BdQ0mhI9L0Z3Su4zCPUGesH8
	 Zg+mcRU/hRoAqp4Xw/AfR5Q9N3nAz4Lk0F2fU7zPBnQbU6OBE01C84V2+Juuq5flfT
	 KUfjcEtxE7xQnrcPu4U7IBwroj1264Z4T5dRzSWGXywP6pcgaoSwcf8ZP+ZcEXoxp5
	 AE4yr9V2En9vw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ubIGY-00FW7V-PE;
	Mon, 14 Jul 2025 13:26:42 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH 06/11] KVM: arm64: Expose GICv3 EL2 registers via KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS
Date: Mon, 14 Jul 2025 13:26:29 +0100
Message-Id: <20250714122634.3334816-7-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250714122634.3334816-1-maz@kernel.org>
References: <20250714122634.3334816-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com, peter.maydell@linaro.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Expose all the GICv3 EL2 registers through the usual GICv3 save/restore
interface, making it possible for a VMM to access the EL2 state.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic-sys-reg-v3.c | 113 +++++++++++++++++++++++++++++++
 1 file changed, 113 insertions(+)

diff --git a/arch/arm64/kvm/vgic-sys-reg-v3.c b/arch/arm64/kvm/vgic-sys-reg-v3.c
index 6f40225c4a3ff..75aee0148936f 100644
--- a/arch/arm64/kvm/vgic-sys-reg-v3.c
+++ b/arch/arm64/kvm/vgic-sys-reg-v3.c
@@ -297,6 +297,91 @@ static int get_gic_sre(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 	return 0;
 }
 
+static int set_gic_ich_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
+			   u64 val)
+{
+	__vcpu_assign_sys_reg(vcpu, r->reg, val);
+	return 0;
+}
+
+static int get_gic_ich_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
+			    u64 *val)
+{
+	*val = __vcpu_sys_reg(vcpu, r->reg);
+	return 0;
+}
+
+static int set_gic_ich_apr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
+			   u64 val)
+{
+	u8 idx = r->Op2 & 3;
+
+	if (idx > vgic_v3_max_apr_idx(vcpu))
+		return -EINVAL;
+
+	return set_gic_ich_reg(vcpu, r, val);
+}
+
+static int get_gic_ich_apr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
+			    u64 *val)
+{
+	u8 idx = r->Op2 & 3;
+
+	if (idx > vgic_v3_max_apr_idx(vcpu))
+		return -EINVAL;
+
+	return get_gic_ich_reg(vcpu, r, val);
+}
+
+static int set_gic_icc_sre(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
+			   u64 val)
+{
+	if (val != KVM_ICC_SRE_EL2)
+		return -EINVAL;
+	return 0;
+}
+
+static int get_gic_icc_sre(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
+			   u64 *val)
+{
+	*val = KVM_ICC_SRE_EL2;
+	return 0;
+}
+
+static int set_gic_ich_vtr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
+			   u64 val)
+{
+	if (val != kvm_get_guest_vtr_el2())
+		return -EINVAL;
+	return 0;
+}
+
+static int get_gic_ich_vtr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
+			   u64 *val)
+{
+	*val = kvm_get_guest_vtr_el2();
+	return 0;
+}
+
+static unsigned int el2_visibility(const struct kvm_vcpu *vcpu,
+				   const struct sys_reg_desc *rd)
+{
+	return vcpu_has_nv(vcpu) ? 0 : REG_HIDDEN;
+}
+
+#define __EL2_REG(r, acc, i)			\
+	{					\
+		SYS_DESC(SYS_ ## r),		\
+		.get_user = get_gic_ ## acc,	\
+		.set_user = set_gic_ ## acc,	\
+		.reg = i,			\
+		.visibility = el2_visibility,	\
+	}
+
+#define EL2_REG(r, acc)		__EL2_REG(r, acc, r)
+
+#define EL2_REG_RO(r, acc)	__EL2_REG(r, acc, 0)
+
 static const struct sys_reg_desc gic_v3_icc_reg_descs[] = {
 	{ SYS_DESC(SYS_ICC_PMR_EL1),
 	  .set_user = set_gic_pmr, .get_user = get_gic_pmr, },
@@ -328,6 +413,34 @@ static const struct sys_reg_desc gic_v3_icc_reg_descs[] = {
 	  .set_user = set_gic_grpen0, .get_user = get_gic_grpen0, },
 	{ SYS_DESC(SYS_ICC_IGRPEN1_EL1),
 	  .set_user = set_gic_grpen1, .get_user = get_gic_grpen1, },
+	EL2_REG(ICH_AP0R0_EL2, ich_apr),
+	EL2_REG(ICH_AP0R1_EL2, ich_apr),
+	EL2_REG(ICH_AP0R2_EL2, ich_apr),
+	EL2_REG(ICH_AP0R3_EL2, ich_apr),
+	EL2_REG(ICH_AP1R0_EL2, ich_apr),
+	EL2_REG(ICH_AP1R1_EL2, ich_apr),
+	EL2_REG(ICH_AP1R2_EL2, ich_apr),
+	EL2_REG(ICH_AP1R3_EL2, ich_apr),
+	EL2_REG(ICH_HCR_EL2, ich_reg),
+	EL2_REG_RO(ICC_SRE_EL2, icc_sre),
+	EL2_REG_RO(ICH_VTR_EL2, ich_vtr),
+	EL2_REG(ICH_VMCR_EL2, ich_reg),
+	EL2_REG(ICH_LR0_EL2, ich_reg),
+	EL2_REG(ICH_LR1_EL2, ich_reg),
+	EL2_REG(ICH_LR2_EL2, ich_reg),
+	EL2_REG(ICH_LR3_EL2, ich_reg),
+	EL2_REG(ICH_LR4_EL2, ich_reg),
+	EL2_REG(ICH_LR5_EL2, ich_reg),
+	EL2_REG(ICH_LR6_EL2, ich_reg),
+	EL2_REG(ICH_LR7_EL2, ich_reg),
+	EL2_REG(ICH_LR8_EL2, ich_reg),
+	EL2_REG(ICH_LR9_EL2, ich_reg),
+	EL2_REG(ICH_LR10_EL2, ich_reg),
+	EL2_REG(ICH_LR11_EL2, ich_reg),
+	EL2_REG(ICH_LR12_EL2, ich_reg),
+	EL2_REG(ICH_LR13_EL2, ich_reg),
+	EL2_REG(ICH_LR14_EL2, ich_reg),
+	EL2_REG(ICH_LR15_EL2, ich_reg),
 };
 
 static u64 attr_to_id(u64 attr)
-- 
2.39.2


