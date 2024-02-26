Return-Path: <kvm+bounces-9802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 292F68670BA
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 11:24:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D887B28DAD2
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:24:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE83656B7F;
	Mon, 26 Feb 2024 10:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bhi0kD2Z"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F375811A;
	Mon, 26 Feb 2024 10:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708942071; cv=none; b=WGYPXyGuauvP6oDSDaotywYLxmbWWeVasIkq6kXsEji3O5uy7guGO+l42Se9mv2aI/Q3xfEGCLTWHBJ+saYK5IVRrZYEzvERnM7sdRJtzLtpQD1O+A5oC3Qt+wTUu7mEM/F4S2PwhxSuHxUdl5ASUdcGNtQ8TU+hwD7wLW3sQr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708942071; c=relaxed/simple;
	bh=nex5gH5tTCMxgjNnQWHLjiNo0+HbQsY+jyRrPhCJzDg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lEZsfnjQk0dgiw3gABLyKTbMPSOoT0q3dbDxSNsdvNeYswI3aoGlRZp29OOlhqtzRW3xfWHPIOqWB/A+bIkjv6oBoniQ35Ky5pfuykIkFeIKVpIpgt1WxtSZweCJahPsFaQPdwmFsfteowfeC7EYCSyT3vYk+3Og9HYV6nrvubo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bhi0kD2Z; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F737C433F1;
	Mon, 26 Feb 2024 10:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708942070;
	bh=nex5gH5tTCMxgjNnQWHLjiNo0+HbQsY+jyRrPhCJzDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bhi0kD2Zl4pcEnY1uKd3gXL+/9TlmeMFMvhR7cY2dpUr02+INp1LywrMozEXVaLiD
	 Iimn+1bQalYURd+ZF57nhgjzRTLsO4P3lUlWNgj1RR7/Bgz+UgwN8hfgGg9TnmG/mi
	 7wQMVGnL4aXtXcZS7LMKD1jgv3/yTmoB0ZlT+cp48gUOag4iUVq/vjlVO1POpi4myH
	 NtZcFRiSU4wGcu8Nv4N4xiSXYvCc+F+bbGQeTzq6ldp5x+aP/OpCPDGv2p7yF4joLL
	 QTcg9eOkA2+fq2bJ2JJVg2X+aIriVxT+iIMsjuGO9WJKSkeWQ1YpGXHol954J0nsvE
	 bUou7zVwMJanQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1reXti-006nQ5-Fu;
	Mon, 26 Feb 2024 10:07:46 +0000
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
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v2 12/13] KVM: arm64: nv: Handle ERETA[AB] instructions
Date: Mon, 26 Feb 2024 10:06:00 +0000
Message-Id: <20240226100601.2379693-13-maz@kernel.org>
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
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, will@kernel.org, catalin.marinas@arm.com
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
index 63a74c0330f1..72d733c74a38 100644
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
+	if (esr_iss_is_eretax(esr) && !kvm_auth_eretax(vcpu, &elr)) {
+		/*
+		 * Oh no, ERETAx failed to authenticate.  If we have
+		 * FPACCOMBINE, deliver an exception right away.  If we
+		 * don't, then let the mangled ELR value trickle down the
+		 * ERET handling, and the guest will have a little surprise.
+		 */
+		if (kvm_has_pauth(vcpu->kvm, FPACCOMBINE)) {
+			esr &= ESR_ELx_ERET_ISS_ERETA;
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
+	if (!esr_iss_is_eretax(esr))
+		elr = __vcpu_sys_reg(vcpu, ELR_EL2);
 
 	trace_kvm_nested_eret(vcpu, elr, spsr);
 
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 1ba2f788b2c3..407bdfbb572b 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -248,7 +248,8 @@ static int kvm_handle_ptrauth(struct kvm_vcpu *vcpu)
 
 static int kvm_handle_eret(struct kvm_vcpu *vcpu)
 {
-	if (esr_iss_is_eretax(kvm_vcpu_get_esr(vcpu)))
+	if (esr_iss_is_eretax(kvm_vcpu_get_esr(vcpu)) &&
+	    !vcpu_has_ptrauth(vcpu))
 		return kvm_handle_ptrauth(vcpu);
 
 	/*
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 3ea9bdf6b555..49d36666040e 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -208,7 +208,8 @@ void kvm_vcpu_put_vhe(struct kvm_vcpu *vcpu)
 
 static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
-	u64 spsr, mode;
+	u64 esr = kvm_vcpu_get_esr(vcpu);
+	u64 spsr, elr, mode;
 
 	/*
 	 * Going through the whole put/load motions is a waste of time
@@ -242,10 +243,18 @@ static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
 		return false;
 	}
 
+	/* If ERETAx fails, take the slow path */
+	if (esr_iss_is_eretax(esr)) {
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


