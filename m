Return-Path: <kvm+bounces-22923-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 07133944832
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 11:27:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B61A92823A3
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 09:27:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A275183CAB;
	Thu,  1 Aug 2024 09:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="diuaXWeL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8161A257D;
	Thu,  1 Aug 2024 09:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722504156; cv=none; b=T6MoV/EcJC/RQWqytn5bWTyNDt/kVrWO1W8WWxd8dhsmy+36DcHvv1srcS8O7GUCgfup9/Mq3cYhR6qxA+VH7ZicVQUvQeAvdrMZDsPBP1+BRbRsvnW9wmqmXTJAGiB5UPu3GwY18hqoOp0R3ER8ck0vsuFvQE+v6+yh03JifnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722504156; c=relaxed/simple;
	bh=grh5Q/rcvt9bAWN63AYijQmUwGmeLeQjuYTHuxc1Nk8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oOshkMRZUGJvSO0TxMJFvkQKWhwV+1YGKPfdyEa2cdm7FXz+Y7WZwg9uz6wZ3JNtTdG+4qhRMPppnbA3Nn+hBmY4UkFV6WQAiC+0AANkusdiijgfcgi6cEVV5XjG4XKUjATHTl65Up1DEc6T8oq1Rj9RoV/PVPXsPrZBSLFXRsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=diuaXWeL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB22FC4AF0B;
	Thu,  1 Aug 2024 09:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722504156;
	bh=grh5Q/rcvt9bAWN63AYijQmUwGmeLeQjuYTHuxc1Nk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=diuaXWeLk4Ohsvr0yKsLwqK0W6xqTKeb8QMX6z8USlIlKOvqIgS1OMMvLo3D3XDOe
	 0NeEe6YHR+Yzn7vWd0Os15fMEsXKgyk97vMTzLWWXLWJkSzVNwuVP5tbnbYb7Hlky5
	 I3PTFT9saPpUnL9r5C+khf9pdphPQPry2HlW4sdnl18KEl5aXJKNDRC/wPqp0jeZ1W
	 /hO2qlkM9KJCBQUnZGT5K13sqC3VSDn/5QgdfTw/bHygK9oQ/IZ41qdGK0GGnOhhzh
	 /QiP7rpM/7iou97jd9T1A7jLElhtYR0WQQ+7i5vElNN1M6BX3c19saMFZ73PI2ot/o
	 KG/m1Knl27mrg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sZRyZ-00HKNZ-NJ;
	Thu, 01 Aug 2024 10:19:59 +0100
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
Subject: [PATCH v2 1/8] KVM: arm64: Move SVCR into the sysreg array
Date: Thu,  1 Aug 2024 10:19:48 +0100
Message-Id: <20240801091955.2066364-2-maz@kernel.org>
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
index a33f5996ca9f..e244e3176b56 100644
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
index c53e5b14038d..e6425414d301 100644
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
index c90324060436..2dc6cab43b2f 100644
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


