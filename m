Return-Path: <kvm+bounces-26535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E8EB39754C0
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 15:56:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB344281AB1
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 13:56:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41EA11AD40D;
	Wed, 11 Sep 2024 13:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t9uKhXmr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A5F21AC454;
	Wed, 11 Sep 2024 13:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726062723; cv=none; b=aeE0PbWXhfo74B9lHwDNOxXbIO0PvYeXb/OCYAlAvro8rQiSHhUUfQ/1OEGCp6u/unCJlP/YpIvlQi85ZNJphH1tswNDBQFqh460YpsLKBWL30UR1x3a/cpjsHw3kiu9z+OKckm5elDqSvkuvJvRZ4CfotacXXwBmlGQsoJANZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726062723; c=relaxed/simple;
	bh=6fUfxlZvENDHy8WhKhH+zIyfrC51DoyzQlLrr2TDlsI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=m2cgTIj/DiMVXEEouaDdc9c3xGOt+N0l7FI/kTgvZ1k3u4yJvAceLhQqiGSB50wzIE43FmykEL7adpqsD0ZJkNXPWBAzxa+XEHsyjxSnKT6bclehZfyvRHjlu+zvFBaiwh/3TXbJvsE7pFa1iaZXODj6bNGYsSP1jKkt1lsz7sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t9uKhXmr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF5A3C4CEC0;
	Wed, 11 Sep 2024 13:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726062723;
	bh=6fUfxlZvENDHy8WhKhH+zIyfrC51DoyzQlLrr2TDlsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t9uKhXmrxTmQfV14nzO62ZYLhW1hudiS2HSrLRzcPlWZEoOv9++dH96dOx0XZ07HV
	 Xr1qUst9nDlaFvGGcYWv0eDw73Jshc9hIHQyfeFqRKSMGTek46x3wEeqB+VJTTt5fM
	 RkOce4b49pelCLlSnnwtVLU0o9s2x9ZrjFtQTh0axZT55GTdBLeOzWNJxB7++q1D8r
	 coztuHa6e2XQZwm2ZwSvsSCA6ylGeQi1wklCqUW2zYNwp0UpfBanoW8iSk7JQyjZM8
	 Ot4iEHlG7zAIxZwSdDLZQ0isJaaWBN0yPPJl+LoERgj59pcZRxznv7+ze2Qnnt0Y12
	 xZkCDXYijdrkQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1soNlJ-00C7tL-8X;
	Wed, 11 Sep 2024 14:52:01 +0100
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
Subject: [PATCH v3 24/24] KVM: arm64: Rely on visibility to let PIR*_ELx/TCR2_ELx UNDEF
Date: Wed, 11 Sep 2024 14:51:51 +0100
Message-Id: <20240911135151.401193-25-maz@kernel.org>
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

With a visibility defined for these registers, there is no need
to check again for S1PIE or TCRX being implemented as perform_access()
already handles it.

Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 36 +++---------------------------------
 1 file changed, 3 insertions(+), 33 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index d8fb894832776..e467cfb91549b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -361,18 +361,6 @@ static bool access_rw(struct kvm_vcpu *vcpu,
 	return true;
 }
 
-static bool check_s1pie_access_rw(struct kvm_vcpu *vcpu,
-				  struct sys_reg_params *p,
-				  const struct sys_reg_desc *r)
-{
-	if (!kvm_has_feat(vcpu->kvm, ID_AA64MMFR3_EL1, S1PIE, IMP)) {
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
@@ -439,12 +427,6 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
 	bool was_enabled = vcpu_has_cache_enabled(vcpu);
 	u64 val, mask, shift;
 
-	if (reg_to_encoding(r) == SYS_TCR2_EL1 &&
-	    !kvm_has_feat(vcpu->kvm, ID_AA64MMFR3_EL1, TCRX, IMP)) {
-		kvm_inject_undefined(vcpu);
-		return false;
-	}
-
 	BUG_ON(!p->is_write);
 
 	get_access_mask(r, &mask, &shift);
@@ -463,18 +445,6 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
 	return true;
 }
 
-static bool access_tcr2_el2(struct kvm_vcpu *vcpu,
-			    struct sys_reg_params *p,
-			    const struct sys_reg_desc *r)
-{
-	if (!kvm_has_feat(vcpu->kvm, ID_AA64MMFR3_EL1, TCRX, IMP)) {
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
@@ -2880,7 +2850,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(TTBR0_EL2, access_rw, reset_val, 0),
 	EL2_REG(TTBR1_EL2, access_rw, reset_val, 0),
 	EL2_REG(TCR_EL2, access_rw, reset_val, TCR_EL2_RES1),
-	EL2_REG_FILTERED(TCR2_EL2, access_tcr2_el2, reset_val, TCR2_EL2_RES1,
+	EL2_REG_FILTERED(TCR2_EL2, access_rw, reset_val, TCR2_EL2_RES1,
 			 tcr2_el2_visibility),
 	EL2_REG_VNCR(VTTBR_EL2, reset_val, 0),
 	EL2_REG_VNCR(VTCR_EL2, reset_val, 0),
@@ -2913,9 +2883,9 @@ static const struct sys_reg_desc sys_reg_descs[] = {
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


