Return-Path: <kvm+bounces-9063-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 75797859F8A
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 10:21:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E17651F21BAE
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 09:21:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D89B28DA4;
	Mon, 19 Feb 2024 09:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SLf4iyGL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE64E2556D;
	Mon, 19 Feb 2024 09:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708334425; cv=none; b=PZqzB4j1bw9vHq+fqp+lG/IB54ONz58d7uA+D4DAAsDLuLjKT+Owqy/2ZiNh1O/QMVIbSUIhh0NXngQn325XxfY9N1IkapACvUxE5gbxjSDRhxyaP7LCzd20z8vnPZ3PDHPm5wHZBjbsqWAZk+MGcHRBFpa+zrDiwgeNhgBXZj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708334425; c=relaxed/simple;
	bh=OYPSocZuCqbnboXmvuNV+6G4knkRpU04HiJL92gq5RY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IzRMLmaZXsLpZ1wOL0YidTMuokdRk/BsCC/JzYvdwsK+3NQCXa0yBMUZc3svNIzoVQtsUrPr6tCOJO7/s3BzAFMw3TYfeRwtYDw4/FjC/LfM5NocGJTwC5u7kZl2uuR4/6JxsmlxAQBQDlWYoqxTmj8wC1Am0N30UjMxl+xNVJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SLf4iyGL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E71C433B1;
	Mon, 19 Feb 2024 09:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708334425;
	bh=OYPSocZuCqbnboXmvuNV+6G4knkRpU04HiJL92gq5RY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SLf4iyGLDiyhA4/8Ayj8pCGhvPqLy7pOK0WfryjZQLSwDsJgM5hs47r0AK/35i88m
	 KnlQ6l0KckmfYYLQ6Jy+0wySlgCUMxUPMB3a87gG/8OXPYlDJp2wieIaGAb5GvbtGu
	 nGM4Dem0GX1k3D5z3wEAvb04XScjzKqwpONBxL0KDYQzFxMbLEP+mGDUt5S3mp39wF
	 vVaBpK9/o5U85ILq+PUrBL4U82HFxnd8kmsEhUGIYRpjhM6TSB1Q3Iva/lTdGSA0Em
	 Tuago5QIn9aMV6kW3QsB2RlnnwX/qxywsZS/tvHQyCW3miyJw3f8kQEb8MKHakpapn
	 +lZfDdwb1z/AQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rbzp1-004WBZ-NZ;
	Mon, 19 Feb 2024 09:20:23 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 12/13] KVM: arm64: nv: Handle ERETA[AB] instructions
Date: Mon, 19 Feb 2024 09:20:13 +0000
Message-Id: <20240219092014.783809-13-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240219092014.783809-1-maz@kernel.org>
References: <20240219092014.783809-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Now that we have some emulation in place for ERETA[AB], we can
plug it into the exception handling machinery.

As for a bare ERET, an "easy" ERETAx instruction is processed as
a fixup, while something that requires a translation regime
transition or an exception delivery is left to the slow path.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 22 ++++++++++++++++++++--
 arch/arm64/kvm/handle_exit.c    |  3 ++-
 arch/arm64/kvm/hyp/vhe/switch.c | 13 +++++++++++--
 3 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 63a74c0330f1..6fc3b7580b24 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2172,7 +2172,7 @@ static u64 kvm_check_illegal_exception_return(struct kvm_vcpu *vcpu, u64 spsr)
 
 void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
 {
-	u64 spsr, elr;
+	u64 spsr, elr, esr;
 
 	/*
 	 * Forward this trap to the virtual EL2 if the virtual
@@ -2181,12 +2181,30 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
 	if (forward_traps(vcpu, HCR_NV))
 		return;
 
+	/* Check for an ERETAx */
+	esr = kvm_vcpu_get_esr(vcpu);
+	if ((esr & ESR_ELx_ERET_ISS_ERETA) && !kvm_auth_eretax(vcpu, &elr)) {
+		/*
+		 * Oh no, ERETAx failed to authenticate.  If we have
+		 * FPACCOMBINE, deliver an exception right away.  If we
+		 * don't, then let the mangled ELR value trickle down the
+		 * ERET handling, and the guest will have a little surprise.
+		 */
+		if (kvm_has_pauth(vcpu->kvm, FPACCOMBINE)) {
+			esr &= ESR_ELx_ERET_ISS_ERETAB;
+			esr |= FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_FPAC);
+			kvm_inject_nested_sync(vcpu, esr);
+			return;
+		}
+	}
+
 	preempt_disable();
 	kvm_arch_vcpu_put(vcpu);
 
 	spsr = __vcpu_sys_reg(vcpu, SPSR_EL2);
 	spsr = kvm_check_illegal_exception_return(vcpu, spsr);
-	elr = __vcpu_sys_reg(vcpu, ELR_EL2);
+	if (!(esr & ESR_ELx_ERET_ISS_ERETA))
+		elr = __vcpu_sys_reg(vcpu, ELR_EL2);
 
 	trace_kvm_nested_eret(vcpu, elr, spsr);
 
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 556af771a9e9..998838da7c32 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -248,7 +248,8 @@ static int kvm_handle_ptrauth(struct kvm_vcpu *vcpu)
 
 static int kvm_handle_eret(struct kvm_vcpu *vcpu)
 {
-	if (kvm_vcpu_get_esr(vcpu) & ESR_ELx_ERET_ISS_ERETA)
+	if ((kvm_vcpu_get_esr(vcpu) & ESR_ELx_ERET_ISS_ERETA) &&
+	    !vcpu_has_ptrauth(vcpu))
 		return kvm_handle_ptrauth(vcpu);
 
 	/*
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index a6c61d2ffc35..04592cd56e4b 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -207,7 +207,8 @@ void kvm_vcpu_put_vhe(struct kvm_vcpu *vcpu)
 
 static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
-	u64 spsr, mode;
+	u64 esr = kvm_vcpu_get_esr(vcpu);
+	u64 spsr, elr, mode;
 
 	/*
 	 * Going through the whole put/load motions is a waste of time
@@ -241,10 +242,18 @@ static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
 		return false;
 	}
 
+	/* If ERETAx fails, take the slow path */
+	if (esr & ESR_ELx_ERET_ISS_ERETA) {
+		if (!(vcpu_has_ptrauth(vcpu) && kvm_auth_eretax(vcpu, &elr)))
+			return false;
+	} else {
+		elr = read_sysreg_el1(SYS_ELR);
+	}
+
 	spsr = (spsr & ~(PSR_MODE_MASK | PSR_MODE32_BIT)) | mode;
 
 	write_sysreg_el2(spsr, SYS_SPSR);
-	write_sysreg_el2(read_sysreg_el1(SYS_ELR), SYS_ELR);
+	write_sysreg_el2(elr, SYS_ELR);
 
 	return true;
 }
-- 
2.39.2


