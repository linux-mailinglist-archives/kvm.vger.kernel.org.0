Return-Path: <kvm+bounces-25767-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AC8596A303
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 17:40:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9DF011C22DE7
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 15:40:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF37018E052;
	Tue,  3 Sep 2024 15:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jvU272r1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23ED518C92D;
	Tue,  3 Sep 2024 15:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725377924; cv=none; b=KbgB6ZyuZJJv8crqCOq0o6UfxjyvYf8EQoGnF7kK/qsmjbjsice6orgZbn0qMVPtlgObqj3URVQ9n57cAPKzP28ULow55FP944fhiPT3rzilwsSfe9uqsAfEnwJsWst3gCg3VEWRgLZ41WXn2CmbEBkZ6q1nT3zxV/UePOe/lgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725377924; c=relaxed/simple;
	bh=uSYy4/G7+cpYtPVwsLakcewzkxa6RwV1FsQc7LKoyms=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HU5MuhI+EcbozWml7/8+Tnp17mwIrUwoad8fZICK3FT1jb9Eh/Ow0p7EfbCd81lC2j6G+tdTY7HBPwfBhpMxIZWpT4RLgblZrcVB03MOCibBQ+eYJ5RNoQORzhpoCbhU6KF6nfWujLdB9aF3X8KvTv/1wu57FCR2s1nvwc7RwCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jvU272r1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A08F4C4CECE;
	Tue,  3 Sep 2024 15:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725377923;
	bh=uSYy4/G7+cpYtPVwsLakcewzkxa6RwV1FsQc7LKoyms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jvU272r1wwDrDWuoK3xnvVQA7d3aMvpWvfSAdyynJTHgZQL8wCzEKkCCOGa9kn7bF
	 kjKEOZKfwLbCs7nhop720zITOlkrOLXpheK12arBJ3eedL0B2XvQbXWSTDkGJOKIne
	 F2VeRHc7aSuily7u0oxScN9z+6Re3Rgcbu8A7mlc9xnoI58c4t+itCGCt4GELTM9AB
	 W1jvKz0ACfJBxl3eERRApGvV8qtPkhQkXB2nQzVGpsMVsv/H1F4tfs/6nCaBN4y6Wt
	 AixDkeT/BDG7q19GTe5J/C58S+ZL4Gr4IWe46onKHkWeHprNMOkJ0iGyM89EBO1upH
	 8nH8wboFO+sag==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1slVc9-009Hr9-Ub;
	Tue, 03 Sep 2024 16:38:42 +0100
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
Subject: [PATCH v2 16/16] KVM: arm64: Rely on visibility to let PIR*_ELx/TCR2_ELx UNDEF
Date: Tue,  3 Sep 2024 16:38:34 +0100
Message-Id: <20240903153834.1909472-17-maz@kernel.org>
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

With a visibility defined for these registers, there is no need
to check again for S1PIE or TCRX being implemented as perform_access()
already handles it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 36 +++---------------------------------
 1 file changed, 3 insertions(+), 33 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index bcc7c4c6620f..2783c1d2a13a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -346,18 +346,6 @@ static bool access_rw(struct kvm_vcpu *vcpu,
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
@@ -424,12 +412,6 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
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
@@ -448,18 +430,6 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
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
@@ -2865,7 +2835,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(TTBR0_EL2, access_rw, reset_val, 0),
 	EL2_REG(TTBR1_EL2, access_rw, reset_val, 0),
 	EL2_REG(TCR_EL2, access_rw, reset_val, TCR_EL2_RES1),
-	EL2_REG_FILTERED(TCR2_EL2, access_tcr2_el2, reset_val, TCR2_EL2_RES1,
+	EL2_REG_FILTERED(TCR2_EL2, access_rw, reset_val, TCR2_EL2_RES1,
 			 tcr2_el2_visibility),
 	EL2_REG_VNCR(VTTBR_EL2, reset_val, 0),
 	EL2_REG_VNCR(VTCR_EL2, reset_val, 0),
@@ -2898,9 +2868,9 @@ static const struct sys_reg_desc sys_reg_descs[] = {
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


