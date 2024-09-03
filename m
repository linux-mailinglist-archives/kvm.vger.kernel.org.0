Return-Path: <kvm+bounces-25764-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 86F6396A2FF
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 17:40:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 091DD1F2A22B
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 15:40:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32FF918CBF8;
	Tue,  3 Sep 2024 15:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HJkhVXnF"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5561B18BBB5;
	Tue,  3 Sep 2024 15:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725377923; cv=none; b=dlCQV20ulVaTMKGfMFYi4bgCBWNI2wDJ5UC81z22U/k84mXvMlOw4/1EnA8M79HpxA058X0yOq+q/hYe6epSW0irdjSTmu62NvpvSCbQkaqqtxo2c6RJCtZi5Y3DmdDrlC103Vwznk+as2rvBBa9mVt8S2rMDMhsInSvWI8JlA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725377923; c=relaxed/simple;
	bh=xBg/7T72vlqqBclk67wUqwBMmLhylo5lATNxzLaP5sc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Xii4NajPga63Pg9lLahZuI1LU8QmVrzlCgUnZ4JoWRxtevyiska3NcuIgBF8ZK6Vz5qySC9/VsBWUYF/ZYd9ttAwp9yKUdBV97zf9zhnfeiviKPQ5LS1qV44ZVIQul/cR1vp0nAe9UI2jGulkzodoEfy9gSS7kpQGUnPcVz7OSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HJkhVXnF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A10C4CECC;
	Tue,  3 Sep 2024 15:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725377923;
	bh=xBg/7T72vlqqBclk67wUqwBMmLhylo5lATNxzLaP5sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HJkhVXnFKj8ypVgSw0297pRrdu4LVmIyptyOG+ZnRLjannTx/NDeT4l3IyiZ3YUrw
	 rYjFdWLiqNal2Qwr25kTrEKCwJ9EA/BWCj+CGNpyKzCPI0WJHg5Eo4zO1114eTgZ4r
	 Kv/stVtiVD9pRdMFdbO1U9LZ3r2XQnyTEsjWvRAVqVZ51iG7HOIFEhw9FD5JEKM671
	 eH8WK9uMBNAkPVpw/VVVLzqj5pTSybgRVXS/YnYuhT6Yq71mzsOLXjvUCwre51a48v
	 5Iy5U7j8p4qRf5qGNLT1nXVxOiA0JSNDZuWdtEuqp/Y9wiTg3x7fKLtscCoJNolaZB
	 EWTsWuXw6EV3w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1slVc9-009Hr9-Gx;
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
Subject: [PATCH v2 14/16] KVM: arm64: Hide TCR2_EL1 from userspace when disabled for guests
Date: Tue,  3 Sep 2024 16:38:32 +0100
Message-Id: <20240903153834.1909472-15-maz@kernel.org>
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

When the guest does not support FEAT_TCR2 we should not allow any access
to it in order to ensure that we do not create spurious issues with guest
migration. Add a visibility operation for it.

Fixes: fbff56068232 ("KVM: arm64: Save/restore TCR2_EL1")
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20240822-kvm-arm64-hide-pie-regs-v2-2-376624fa829c@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/kvm/sys_regs.c         | 29 ++++++++++++++++++++++++++---
 2 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index ab4c675b491d..7889e5f4009f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1476,4 +1476,7 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
 		(pa + pi + pa3) == 1;					\
 	})
 
+#define kvm_has_tcr2(k)				\
+	(kvm_has_feat((k), ID_AA64MMFR3_EL1, TCRX, IMP))
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 4ee74e2d4f08..64562b0c2359 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2319,6 +2319,27 @@ static bool access_zcr_el2(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static unsigned int tcr2_visibility(const struct kvm_vcpu *vcpu,
+				    const struct sys_reg_desc *rd)
+{
+	if (kvm_has_tcr2(vcpu->kvm))
+		return 0;
+
+	return REG_HIDDEN;
+}
+
+static unsigned int tcr2_el2_visibility(const struct kvm_vcpu *vcpu,
+				    const struct sys_reg_desc *rd)
+{
+	unsigned int r;
+
+	r = el2_visibility(vcpu, rd);
+	if (r)
+		return r;
+
+	return tcr2_visibility(vcpu, rd);
+}
+
 /*
  * Architected system registers.
  * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
@@ -2503,7 +2524,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_TTBR0_EL1), access_vm_reg, reset_unknown, TTBR0_EL1 },
 	{ SYS_DESC(SYS_TTBR1_EL1), access_vm_reg, reset_unknown, TTBR1_EL1 },
 	{ SYS_DESC(SYS_TCR_EL1), access_vm_reg, reset_val, TCR_EL1, 0 },
-	{ SYS_DESC(SYS_TCR2_EL1), access_vm_reg, reset_val, TCR2_EL1, 0 },
+	{ SYS_DESC(SYS_TCR2_EL1), access_vm_reg, reset_val, TCR2_EL1, 0,
+	  .visibility = tcr2_visibility },
 
 	PTRAUTH_KEY(APIA),
 	PTRAUTH_KEY(APIB),
@@ -2820,7 +2842,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(TTBR0_EL2, access_rw, reset_val, 0),
 	EL2_REG(TTBR1_EL2, access_rw, reset_val, 0),
 	EL2_REG(TCR_EL2, access_rw, reset_val, TCR_EL2_RES1),
-	EL2_REG(TCR2_EL2, access_tcr2_el2, reset_val, TCR2_EL2_RES1),
+	EL2_REG_FILTERED(TCR2_EL2, access_tcr2_el2, reset_val, TCR2_EL2_RES1,
+			 tcr2_el2_visibility),
 	EL2_REG_VNCR(VTTBR_EL2, reset_val, 0),
 	EL2_REG_VNCR(VTCR_EL2, reset_val, 0),
 
@@ -4679,7 +4702,7 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
 		if (kvm_has_feat(kvm, ID_AA64ISAR2_EL1, MOPS, IMP))
 			vcpu->arch.hcrx_el2 |= (HCRX_EL2_MSCEn | HCRX_EL2_MCE2);
 
-		if (kvm_has_feat(kvm, ID_AA64MMFR3_EL1, TCRX, IMP))
+		if (kvm_has_tcr2(kvm))
 			vcpu->arch.hcrx_el2 |= HCRX_EL2_TCR2En;
 	}
 
-- 
2.39.2


