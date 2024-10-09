Return-Path: <kvm+bounces-28318-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 087DA99753B
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 21:01:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6211FB238BA
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 19:01:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7AD31E2841;
	Wed,  9 Oct 2024 19:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HvDaA+Ph"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6AA1E1C3E;
	Wed,  9 Oct 2024 19:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728500444; cv=none; b=eQbtt6uxKOv444NsJDBjtqNlpeEn22GOWhsSmEaoMO38ri+GylQi0BbcxljodPg7ELMGyjchGUNyp4fwj+LQ5q0iuJ4bFSmY9Nk3WWG3FsLKzwdtteo2lA4UvX+sJkdX4vNvwGIMCgJ+Qgf+eh1oW+hUt8QUHwlFsYvzEU/3FQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728500444; c=relaxed/simple;
	bh=qgl95QioFvsUmyfTslZFoefHDVM9JNr0Jgcb3kh5g6A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WrfcV8BbXYjG/fYoOL6OXDaSvzFNogGe2ShPtrMn/KPhc4kosVFO0t/qui7HKGwPtxl6fiJc99ovzcfZKGVpD4y9HuYyDpcP9pPqIRqA/6c0bgtJLvvphpEs6fQLRXQtm84Hne+OeSo5YCumOx7WgI3YhM0DlJd/b2WqKojJlK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HvDaA+Ph; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47CEAC4CECE;
	Wed,  9 Oct 2024 19:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728500444;
	bh=qgl95QioFvsUmyfTslZFoefHDVM9JNr0Jgcb3kh5g6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HvDaA+Phe66K5iTT+ILuFkMpUBnOG9SfSJuUbF1eEcYriJ361ID9BBAcsmWYYF/Nz
	 AThmsThl3aQItq6q5PWwFgczF6pXEhdgZf18YCI6kUgqG5JldHZxoBZjcxGds5BET5
	 Fe4EZx3wLcILf8vYSMYPrIg1pNHD7N9i9x7IsIiIOhQrqF759s4vd1oIGRVcjD6xyk
	 tG4bTRRADjARubQHIZ3DrWsB4459tF9rbRuHE2SrByOcH6rw+GK23150CV6bU6WIpg
	 /cD+iQeHDy0UbLAqB3+VHx2hhmI+fuNhBMNi/JXeT27EiH/hwQe7Yn5USiac2gbFrJ
	 Np2uThIh3cfsw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sybvO-001wcY-EV;
	Wed, 09 Oct 2024 20:00:42 +0100
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
Subject: [PATCH v4 09/36] KVM: arm64: Extend masking facility to arbitrary registers
Date: Wed,  9 Oct 2024 19:59:52 +0100
Message-Id: <20241009190019.3222687-10-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241009190019.3222687-1-maz@kernel.org>
References: <20241009190019.3222687-1-maz@kernel.org>
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

We currently only use the masking (RES0/RES1) facility for VNCR
registers, as they are memory-based and thus easy to sanitise.

But we could apply the same thing to other registers if we:

- split the sanitisation from __VNCR_START__
- apply the sanitisation when reading from a HW register

This involves a new "marker" in the vcpu_sysreg enum, which
defines the point at which the sanitisation applies (the VNCR
registers being of course after this marker).

Whle we are at it, rename kvm_vcpu_sanitise_vncr_reg() to
kvm_vcpu_apply_reg_masks(), which is vaguely more explicit,
and harden set_sysreg_masks() against setting masks for
random registers...

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 19 +++++++++++++------
 arch/arm64/kvm/nested.c           | 12 ++++++++----
 arch/arm64/kvm/sys_regs.c         |  3 +++
 3 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 1adf68971bb17..7f409dfc5cd4a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -367,7 +367,7 @@ struct kvm_arch {
 
 	u64 ctr_el0;
 
-	/* Masks for VNCR-baked sysregs */
+	/* Masks for VNCR-backed and general EL2 sysregs */
 	struct kvm_sysreg_masks	*sysreg_masks;
 
 	/*
@@ -401,6 +401,9 @@ struct kvm_vcpu_fault_info {
 	r = __VNCR_START__ + ((VNCR_ ## r) / 8),	\
 	__after_##r = __MAX__(__before_##r - 1, r)
 
+#define MARKER(m)				\
+	m, __after_##m = m - 1
+
 enum vcpu_sysreg {
 	__INVALID_SYSREG__,   /* 0 is reserved as an invalid value */
 	MPIDR_EL1,	/* MultiProcessor Affinity Register */
@@ -487,7 +490,11 @@ enum vcpu_sysreg {
 	CNTHV_CTL_EL2,
 	CNTHV_CVAL_EL2,
 
-	__VNCR_START__,	/* Any VNCR-capable reg goes after this point */
+	/* Anything from this can be RES0/RES1 sanitised */
+	MARKER(__SANITISED_REG_START__),
+
+	/* Any VNCR-capable reg goes after this point */
+	MARKER(__VNCR_START__),
 
 	VNCR(SCTLR_EL1),/* System Control Register */
 	VNCR(ACTLR_EL1),/* Auxiliary Control Register */
@@ -547,7 +554,7 @@ struct kvm_sysreg_masks {
 	struct {
 		u64	res0;
 		u64	res1;
-	} mask[NR_SYS_REGS - __VNCR_START__];
+	} mask[NR_SYS_REGS - __SANITISED_REG_START__];
 };
 
 struct kvm_cpu_context {
@@ -995,13 +1002,13 @@ static inline u64 *___ctxt_sys_reg(const struct kvm_cpu_context *ctxt, int r)
 
 #define ctxt_sys_reg(c,r)	(*__ctxt_sys_reg(c,r))
 
-u64 kvm_vcpu_sanitise_vncr_reg(const struct kvm_vcpu *, enum vcpu_sysreg);
+u64 kvm_vcpu_apply_reg_masks(const struct kvm_vcpu *, enum vcpu_sysreg, u64);
 #define __vcpu_sys_reg(v,r)						\
 	(*({								\
 		const struct kvm_cpu_context *ctxt = &(v)->arch.ctxt;	\
 		u64 *__r = __ctxt_sys_reg(ctxt, (r));			\
-		if (vcpu_has_nv((v)) && (r) >= __VNCR_START__)		\
-			*__r = kvm_vcpu_sanitise_vncr_reg((v), (r));	\
+		if (vcpu_has_nv((v)) && (r) >= __SANITISED_REG_START__)	\
+			*__r = kvm_vcpu_apply_reg_masks((v), (r), *__r);\
 		__r;							\
 	}))
 
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index f9e30dd34c7a1..b20b3bfb9caec 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -908,15 +908,15 @@ static void limit_nv_id_regs(struct kvm *kvm)
 	kvm_set_vm_id_reg(kvm, SYS_ID_AA64DFR0_EL1, val);
 }
 
-u64 kvm_vcpu_sanitise_vncr_reg(const struct kvm_vcpu *vcpu, enum vcpu_sysreg sr)
+u64 kvm_vcpu_apply_reg_masks(const struct kvm_vcpu *vcpu,
+			     enum vcpu_sysreg sr, u64 v)
 {
-	u64 v = ctxt_sys_reg(&vcpu->arch.ctxt, sr);
 	struct kvm_sysreg_masks *masks;
 
 	masks = vcpu->kvm->arch.sysreg_masks;
 
 	if (masks) {
-		sr -= __VNCR_START__;
+		sr -= __SANITISED_REG_START__;
 
 		v &= ~masks->mask[sr].res0;
 		v |= masks->mask[sr].res1;
@@ -927,7 +927,11 @@ u64 kvm_vcpu_sanitise_vncr_reg(const struct kvm_vcpu *vcpu, enum vcpu_sysreg sr)
 
 static void set_sysreg_masks(struct kvm *kvm, int sr, u64 res0, u64 res1)
 {
-	int i = sr - __VNCR_START__;
+	int i = sr - __SANITISED_REG_START__;
+
+	BUILD_BUG_ON(!__builtin_constant_p(sr));
+	BUILD_BUG_ON(sr < __SANITISED_REG_START__);
+	BUILD_BUG_ON(sr >= NR_SYS_REGS);
 
 	kvm->arch.sysreg_masks->mask[i].res0 = res0;
 	kvm->arch.sysreg_masks->mask[i].res1 = res1;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 932d2fb7a52a0..d9c20563cae93 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -189,6 +189,9 @@ u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
 
 		/* Get the current version of the EL1 counterpart. */
 		WARN_ON(!__vcpu_read_sys_reg_from_cpu(el1r, &val));
+		if (reg >= __SANITISED_REG_START__)
+			val = kvm_vcpu_apply_reg_masks(vcpu, reg, val);
+
 		return val;
 	}
 
-- 
2.39.2


