Return-Path: <kvm+bounces-26520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 677449754B0
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 15:54:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9E4CDB2AECC
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 13:54:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FDDF1A76CE;
	Wed, 11 Sep 2024 13:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fle5f1xz"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 046A51A3A8E;
	Wed, 11 Sep 2024 13:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726062720; cv=none; b=RDpCaXF/M1R/GsGvDj44uZGDTeetYvBn2A1W8p68jF68mfmnWWVPkfJm5sFFMSfRxdU35gT2H/j5ztQHYwZv5pTOHnRSlRlaGArdr+A4FUEqQdnEWzPDdE+phrJvcTcVZHKI5tJ7R7YwuGMEqPv64YQVHU3MA2keYd1HiyGJ2zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726062720; c=relaxed/simple;
	bh=57Ajd65Hi9YFD4sBh6x5FEibW7iXHMCQquTFiU3EAus=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RM9BPXr4a+nd5+p6rKkECsMEtRt9nA0nhNV37X8jKSOhMsRiw1CrhK4WJocM7YWeCEHAejPXjDYnEUVk9iW7osLdxVR5DJoFspNomYvEvQrZx03D4pFcve7zXGw8psd8WwmT8b58WntK0DpYjLgqt3cpkrl0BGWCbNJx5Srf+s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fle5f1xz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C227EC4CED1;
	Wed, 11 Sep 2024 13:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726062719;
	bh=57Ajd65Hi9YFD4sBh6x5FEibW7iXHMCQquTFiU3EAus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fle5f1xzdWUy9/YIKqYp5M/N8tYwmaLqplAJL712KQ6ZZ9eLM1lOBtVuxKWW8RU5X
	 aNHVuRU1U28l+tSiv5oDe9VKOqipgWe0cXdwfyKaDX0D/lNQP6FK72NwnDZZTJE1Zy
	 Xv+YDfQdDKpkgH+A/rGc3Ok6aBbM/FMjIvh8pHHwlh2XFWztABCSX9iQ8HEJzKdNf8
	 6yyZDoVACVzl8TQAacrGvHET3KHDvrP3ma31SJDpxVDu/GSSUj4yw3DvGZY7bcWF8w
	 //gDysvPF3Gy/TF1Bf6ucshPilC9bo67qCBndK3+wOuET4M8QjemIwA8eaPKjakvcJ
	 cTVXZA12REvPw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1soNlF-00C7tL-Sq;
	Wed, 11 Sep 2024 14:51:57 +0100
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
Subject: [PATCH v3 08/24] KVM: arm64: Extend masking facility to arbitrary registers
Date: Wed, 11 Sep 2024 14:51:35 +0100
Message-Id: <20240911135151.401193-9-maz@kernel.org>
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
index 5265a1a929514..bb65da14963d4 100644
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
@@ -481,7 +484,11 @@ enum vcpu_sysreg {
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
@@ -537,7 +544,7 @@ struct kvm_sysreg_masks {
 	struct {
 		u64	res0;
 		u64	res1;
-	} mask[NR_SYS_REGS - __VNCR_START__];
+	} mask[NR_SYS_REGS - __SANITISED_REG_START__];
 };
 
 struct kvm_cpu_context {
@@ -977,13 +984,13 @@ static inline u64 *___ctxt_sys_reg(const struct kvm_cpu_context *ctxt, int r)
 
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
index 133cc2f9530df..fd9ddd0d31400 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -909,15 +909,15 @@ static void limit_nv_id_regs(struct kvm *kvm)
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
@@ -928,7 +928,11 @@ u64 kvm_vcpu_sanitise_vncr_reg(const struct kvm_vcpu *vcpu, enum vcpu_sysreg sr)
 
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
index e4ce1e1c19bef..8fce896685b9c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -181,6 +181,9 @@ u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
 
 		/* Get the current version of the EL1 counterpart. */
 		WARN_ON(!__vcpu_read_sys_reg_from_cpu(el1r, &val));
+		if (reg >= __SANITISED_REG_START__)
+			val = kvm_vcpu_apply_reg_masks(vcpu, reg, val);
+
 		return val;
 	}
 
-- 
2.39.2


