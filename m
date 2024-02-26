Return-Path: <kvm+bounces-9794-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C3758670AF
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:24:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6E3A01C25A3C
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:24:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF85C56761;
	Mon, 26 Feb 2024 10:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cC2qBCcx"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0158456462;
	Mon, 26 Feb 2024 10:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708942057; cv=none; b=PbYDEZb3puL+9RA4nFXHKufz2A/NgYfktfa7wWXvOVkkmeotky6ZSmDQp3VTR71XBJ+pjAaYGppwus++DTC4D9I3cJpcDgzUn/9i6+C6lkMgHN/tKmDMgcPG+KCvRA9QPu5JF9wRG+GsiuZqfxKlAnQ/eBCGNMIeohvT98SQxE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708942057; c=relaxed/simple;
	bh=xE8hNSFxmpy+AAOQpa+KgTdZLT8PINd+Cx6eo/7x5E0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=StrSbj/OwWoKk3lbLLvaTpAD9poQ1JkdXrmAaIC/93pRqwrjs0bIXhntLWVyTJ5iIn8SW9bxospsm1CMm1vHQgjqr5zs87lUDYKxmJQDdCiGLn2riGuON+80i4zFYH3yiK2Qj3NafMPYWHlfgYE31iHX650csjs2kMLMLqUG2nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cC2qBCcx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7811C433B2;
	Mon, 26 Feb 2024 10:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708942056;
	bh=xE8hNSFxmpy+AAOQpa+KgTdZLT8PINd+Cx6eo/7x5E0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cC2qBCcx8wsDkz9YIrtcHyS/IY5QAc6BXLAmBrR8ONrIT8gCrTyX792sdadejF+XR
	 GoCv2XZIYRdSS/0RbiAsf38vhSC4M3IJTa3mT3heOQmzxczx8U690nTKfbppYMyOUP
	 dxR64yAjo4Vsj1JWBNQvQ+wKLAD2v+cYyRJsDaEiDCP/BLNx0oKaILGJGFgUc5gJpR
	 nwVLJEx7mEnGYriHRSyzkIrW+72Czt/8Y/AlcaQssw3cW1QKtJo+Lxv4sRN0fn8s50
	 kNKW5dQyNX7NlF74YXdeJTLxEcetAoosmroezMYxhZjV4+cU0oy5U8p97VTp9qYL5l
	 iAOWNHyOLMQ4w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1reXtW-006nQ5-MF;
	Mon, 26 Feb 2024 10:07:34 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jintack Lim <jintack.lim@linaro.org>
Subject: [PATCH v2 05/13] KVM: arm64: nv: Add trap forwarding for ERET and SMC
Date: Mon, 26 Feb 2024 10:05:53 +0000
Message-Id: <20240226100601.2379693-6-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240226100601.2379693-1-maz@kernel.org>
References: <20240226100601.2379693-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, will@kernel.org, catalin.marinas@arm.com, jintack.lim@linaro.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Honor the trap forwarding bits for both ERET and SMC, using a new
helper that checks for common conditions.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Co-developed-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h |  1 +
 arch/arm64/kvm/emulate-nested.c     | 27 +++++++++++++++++++++++++++
 arch/arm64/kvm/handle_exit.c        |  7 +++++++
 3 files changed, 35 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index c77d795556e1..dbc4e3a67356 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -60,6 +60,7 @@ static inline u64 translate_ttbr0_el2_to_ttbr0_el1(u64 ttbr0)
 	return ttbr0 & ~GENMASK_ULL(63, 48);
 }
 
+extern bool forward_smc_trap(struct kvm_vcpu *vcpu);
 
 int kvm_init_nv_sysregs(struct kvm *kvm);
 
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 4697ba41b3a9..2d80e81ae650 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2117,6 +2117,26 @@ bool triage_sysreg_trap(struct kvm_vcpu *vcpu, int *sr_index)
 	return true;
 }
 
+static bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit)
+{
+	bool control_bit_set;
+
+	if (!vcpu_has_nv(vcpu))
+		return false;
+
+	control_bit_set = __vcpu_sys_reg(vcpu, HCR_EL2) & control_bit;
+	if (!is_hyp_ctxt(vcpu) && control_bit_set) {
+		kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
+		return true;
+	}
+	return false;
+}
+
+bool forward_smc_trap(struct kvm_vcpu *vcpu)
+{
+	return forward_traps(vcpu, HCR_TSC);
+}
+
 static u64 kvm_check_illegal_exception_return(struct kvm_vcpu *vcpu, u64 spsr)
 {
 	u64 mode = spsr & PSR_MODE_MASK;
@@ -2155,6 +2175,13 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
 	u64 spsr, elr, mode;
 	bool direct_eret;
 
+	/*
+	 * Forward this trap to the virtual EL2 if the virtual
+	 * HCR_EL2.NV bit is set and this is coming from !EL2.
+	 */
+	if (forward_traps(vcpu, HCR_NV))
+		return;
+
 	/*
 	 * Going through the whole put/load motions is a waste of time
 	 * if this is a VHE guest hypervisor returning to its own
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 15221e481ccd..6a88ec024e2f 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -55,6 +55,13 @@ static int handle_hvc(struct kvm_vcpu *vcpu)
 
 static int handle_smc(struct kvm_vcpu *vcpu)
 {
+	/*
+	 * Forward this trapped smc instruction to the virtual EL2 if
+	 * the guest has asked for it.
+	 */
+	if (forward_smc_trap(vcpu))
+		return 1;
+
 	/*
 	 * "If an SMC instruction executed at Non-secure EL1 is
 	 * trapped to EL2 because HCR_EL2.TSC is 1, the exception is a
-- 
2.39.2


