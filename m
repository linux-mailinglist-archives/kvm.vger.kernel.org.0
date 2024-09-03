Return-Path: <kvm+bounces-25766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E116396A301
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 17:40:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0927F1C23C33
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 15:40:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E098418E043;
	Tue,  3 Sep 2024 15:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zc0Rvt5j"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA3018BC13;
	Tue,  3 Sep 2024 15:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725377923; cv=none; b=BFI9AiVe25gwX0UzbCuBTrXidwoApGBt6fVBP8qBxUeTrD0zw4EYDwiGWR6KrQmfbqSOGsTXsuHvllSRaRVonmWh4CKWHQQwpCpFRxnTKdDzr0FBzXgBbsQbdKVjybiHPynTMC12KuhoA3n/Mr7/6eC49gW0tG2ErHrvBJb/8nY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725377923; c=relaxed/simple;
	bh=XZRuBXpKDTewP1m+ZwmBcrN124YwmKZ/2B8z+zw/Bm0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CNS/uM4HWJOtytE01t7q4dbu/P1xFxb3CbQABXUkV+zX3zGK7Fh80quvF3KRbkaOc21AACcpf3KXSJdFYC8ecuDIQ55Dc6kEHwK9p7ZCDPbQ1aWtonGFvUJ9fp6jNTfWEWYWtPgzFjERFGvg3xX692LIa8xWnukozA/nntzll28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zc0Rvt5j; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E10C4CEC6;
	Tue,  3 Sep 2024 15:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725377923;
	bh=XZRuBXpKDTewP1m+ZwmBcrN124YwmKZ/2B8z+zw/Bm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zc0Rvt5jb2XJmyKnsRMqq22c2yd3F4BQcv1moKgsyWr2RUcSDZBzAnan56eYG9L2H
	 Xttmxcr9VXUHdJpYGacG54UkKuvIn9gRNWDeAO/brdEK1H76q5szfUu5VwOCWGXzB5
	 Je2emINMgnDtkrYoNEAIgHKsV/n8ZitPrKtXwK4Yxi8IrYwCH5g/JLVf0sNt+QRoYN
	 cooHVyTN3WZAdt7Si01EmbDlapQI06V4Q5/44+ciW+a9pa7fGz3Rv64a6lD0+342XH
	 Ug/U4kPtgpa4mOJNBdYuOv/kSbBPrIyVc6EcHXWmQeAoTbIzpBS3CmA7QWC2FnFrf9
	 qHVI4Qsub+nUw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1slVc9-009Hr9-Np;
	Tue, 03 Sep 2024 16:38:41 +0100
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
Subject: [PATCH v2 15/16] KVM: arm64: Hide S1PIE registers from userspace when disabled for guests
Date: Tue,  3 Sep 2024 16:38:33 +0100
Message-Id: <20240903153834.1909472-16-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240903153834.1909472-1-maz@kernel.org>
References: <20240903153834.1909472-1-maz@kernel.org>
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

From: Mark Brown <broonie@kernel.org>

When the guest does not support S1PIE we should not allow any access
to the system registers it adds in order to ensure that we do not create
spurious issues with guest migration. Add a visibility operation for these
registers.

Fixes: 86f9de9db178 ("KVM: arm64: Save/restore PIE registers")
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20240822-kvm-arm64-hide-pie-regs-v2-3-376624fa829c@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/kvm/sys_regs.c         | 35 ++++++++++++++++++++++++++-----
 2 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7889e5f4009f..fd161d41df52 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1479,4 +1479,7 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
 #define kvm_has_tcr2(k)				\
 	(kvm_has_feat((k), ID_AA64MMFR3_EL1, TCRX, IMP))
 
+#define kvm_has_s1pie(k)				\
+	(kvm_has_feat((k), ID_AA64MMFR3_EL1, S1PIE, IMP))
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 64562b0c2359..bcc7c4c6620f 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2340,6 +2340,27 @@ static unsigned int tcr2_el2_visibility(const struct kvm_vcpu *vcpu,
 	return tcr2_visibility(vcpu, rd);
 }
 
+static unsigned int s1pie_visibility(const struct kvm_vcpu *vcpu,
+				     const struct sys_reg_desc *rd)
+{
+	if (kvm_has_s1pie(vcpu->kvm))
+		return 0;
+
+	return REG_HIDDEN;
+}
+
+static unsigned int s1pie_el2_visibility(const struct kvm_vcpu *vcpu,
+					 const struct sys_reg_desc *rd)
+{
+	unsigned int r;
+
+	r = el2_visibility(vcpu, rd);
+	if (r)
+		return r;
+
+	return s1pie_visibility(vcpu, rd);
+}
+
 /*
  * Architected system registers.
  * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
@@ -2577,8 +2598,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_PMMIR_EL1), trap_raz_wi },
 
 	{ SYS_DESC(SYS_MAIR_EL1), access_vm_reg, reset_unknown, MAIR_EL1 },
-	{ SYS_DESC(SYS_PIRE0_EL1), NULL, reset_unknown, PIRE0_EL1 },
-	{ SYS_DESC(SYS_PIR_EL1), NULL, reset_unknown, PIR_EL1 },
+	{ SYS_DESC(SYS_PIRE0_EL1), NULL, reset_unknown, PIRE0_EL1,
+	  .visibility = s1pie_visibility },
+	{ SYS_DESC(SYS_PIR_EL1), NULL, reset_unknown, PIR_EL1,
+	  .visibility = s1pie_visibility },
 	{ SYS_DESC(SYS_AMAIR_EL1), access_vm_reg, reset_amair_el1, AMAIR_EL1 },
 
 	{ SYS_DESC(SYS_LORSA_EL1), trap_loregion },
@@ -2875,8 +2898,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(HPFAR_EL2, access_rw, reset_val, 0),
 
 	EL2_REG(MAIR_EL2, access_rw, reset_val, 0),
-	EL2_REG(PIRE0_EL2, check_s1pie_access_rw, reset_val, 0),
-	EL2_REG(PIR_EL2, check_s1pie_access_rw, reset_val, 0),
+	EL2_REG_FILTERED(PIRE0_EL2, check_s1pie_access_rw, reset_val, 0,
+			 s1pie_el2_visibility),
+	EL2_REG_FILTERED(PIR_EL2, check_s1pie_access_rw, reset_val, 0,
+			 s1pie_el2_visibility),
 	EL2_REG(AMAIR_EL2, access_rw, reset_val, 0),
 
 	EL2_REG(VBAR_EL2, access_rw, reset_val, 0),
@@ -4751,7 +4776,7 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
 		kvm->arch.fgu[HFGITR_GROUP] |= (HFGITR_EL2_ATS1E1RP |
 						HFGITR_EL2_ATS1E1WP);
 
-	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, S1PIE, IMP))
+	if (!kvm_has_s1pie(kvm))
 		kvm->arch.fgu[HFGxTR_GROUP] |= (HFGxTR_EL2_nPIRE0_EL1 |
 						HFGxTR_EL2_nPIR_EL1);
 
-- 
2.39.2


