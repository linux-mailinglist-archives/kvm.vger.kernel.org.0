Return-Path: <kvm+bounces-29549-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 550A79ACDF9
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 17:04:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C698AB26169
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 15:04:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC79E20408D;
	Wed, 23 Oct 2024 14:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RBb7PCTZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD5820697F;
	Wed, 23 Oct 2024 14:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729695237; cv=none; b=aMIzLOSe0IEpaUAnTK5Jqarp75M6nF/3+o5/q6KI2FsT+g/esO8yKKICmRXwYWG90BbrpMeAROWtDUWh+pIpFxRDZCSx0JoQm/7WGxnOkBQqjNcJsaApMt1QxrV161EFPqiPLkHRNrkPaqd3qIjy0zfm+1f+ua/Q+l+im1BiODM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729695237; c=relaxed/simple;
	bh=miQZHZgbW1sasFdsH6OWS+k+yOuBiQ+dexB+f0U9p1o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=B+S6oZMmq5Wm71z8OuM5XM0Ra2cXwOCz8Ras4zjnvjnebiBSB8kzJsAe0ApyE0fgk4SG74VUb5om0tT63cQYTDm7t1C5E+ilhctjNU8O6vKuepym9SFkLrE0Vye6MqBHBelpLsf172f2qd85AUTjAAUrHfthuuQ4UnoprUJQpX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RBb7PCTZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E671C4CEE6;
	Wed, 23 Oct 2024 14:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729695236;
	bh=miQZHZgbW1sasFdsH6OWS+k+yOuBiQ+dexB+f0U9p1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RBb7PCTZzRz6Z610kDvj2hDycCs4Mpw+6Sw2CqIpVSx4VFIAT+P8wD0ecnzS7Tdbi
	 yhUM9KisKDDS5wmItyJQj3zg6zNDeVTmuwPw/AFndY83+p/nNao+iLtgDJ78hni2go
	 Eb0xXg5KutYS2BEtosfirtahVCPHn5Rz03O2huotZcDLBk15aWJqdQqIK5PPc9BITC
	 dpMJES9/HrGyn6uq8DLRAL91cQx7nlu4EQXnPmco9vVJ9k98e471n/QTgweRGrI8rW
	 9ju8f5ma+iaNovc3AyCPlR7FeyG/snWLBuAOAqg7DFZ3JhaycpMVj5XRxnoLuLk+L+
	 ZlqFoAMMbhmsw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1t3ckE-0068vz-T3;
	Wed, 23 Oct 2024 15:53:54 +0100
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
Subject: [PATCH v5 26/37] KVM: arm64: Rely on visibility to let PIR*_ELx/TCR2_ELx UNDEF
Date: Wed, 23 Oct 2024 15:53:34 +0100
Message-Id: <20241023145345.1613824-27-maz@kernel.org>
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

With a visibility defined for these registers, there is no need
to check again for S1PIE or TCRX being implemented as perform_access()
already handles it.

Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 34 +++-------------------------------
 1 file changed, 3 insertions(+), 31 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 85b465c9ec8fd..6c20de8607b2d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -369,18 +369,6 @@ static bool access_rw(struct kvm_vcpu *vcpu,
 	return true;
 }
 
-static bool check_s1pie_access_rw(struct kvm_vcpu *vcpu,
-				  struct sys_reg_params *p,
-				  const struct sys_reg_desc *r)
-{
-	if (!kvm_has_s1pie(vcpu->kvm)) {
-		kvm_inject_undefined(vcpu);
-		return false;
-	}
-
-	return access_rw(vcpu, p, r);
-}
-
 /*
  * See note at ARMv7 ARM B1.14.4 (TL;DR: S/W ops are not easily virtualized).
  */
@@ -445,10 +433,6 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
 	bool was_enabled = vcpu_has_cache_enabled(vcpu);
 	u64 val, mask, shift;
 
-	if (reg_to_encoding(r) == SYS_TCR2_EL1 &&
-	    !kvm_has_tcr2(vcpu->kvm))
-		return undef_access(vcpu, p, r);
-
 	BUG_ON(!p->is_write);
 
 	get_access_mask(r, &mask, &shift);
@@ -467,18 +451,6 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
 	return true;
 }
 
-static bool access_tcr2_el2(struct kvm_vcpu *vcpu,
-			    struct sys_reg_params *p,
-			    const struct sys_reg_desc *r)
-{
-	if (!kvm_has_tcr2(vcpu->kvm)) {
-		kvm_inject_undefined(vcpu);
-		return false;
-	}
-
-	return access_rw(vcpu, p, r);
-}
-
 static bool access_actlr(struct kvm_vcpu *vcpu,
 			 struct sys_reg_params *p,
 			 const struct sys_reg_desc *r)
@@ -2904,7 +2876,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(TTBR0_EL2, access_rw, reset_val, 0),
 	EL2_REG(TTBR1_EL2, access_rw, reset_val, 0),
 	EL2_REG(TCR_EL2, access_rw, reset_val, TCR_EL2_RES1),
-	EL2_REG_FILTERED(TCR2_EL2, access_tcr2_el2, reset_val, TCR2_EL2_RES1,
+	EL2_REG_FILTERED(TCR2_EL2, access_rw, reset_val, TCR2_EL2_RES1,
 			 tcr2_el2_visibility),
 	EL2_REG_VNCR(VTTBR_EL2, reset_val, 0),
 	EL2_REG_VNCR(VTCR_EL2, reset_val, 0),
@@ -2933,9 +2905,9 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(HPFAR_EL2, access_rw, reset_val, 0),
 
 	EL2_REG(MAIR_EL2, access_rw, reset_val, 0),
-	EL2_REG_FILTERED(PIRE0_EL2, check_s1pie_access_rw, reset_val, 0,
+	EL2_REG_FILTERED(PIRE0_EL2, access_rw, reset_val, 0,
 			 s1pie_el2_visibility),
-	EL2_REG_FILTERED(PIR_EL2, check_s1pie_access_rw, reset_val, 0,
+	EL2_REG_FILTERED(PIR_EL2, access_rw, reset_val, 0,
 			 s1pie_el2_visibility),
 	EL2_REG(AMAIR_EL2, access_rw, reset_val, 0),
 
-- 
2.39.2


