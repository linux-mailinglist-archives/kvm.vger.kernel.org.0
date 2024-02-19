Return-Path: <kvm+bounces-9057-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A175B859F85
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 10:21:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D62A283DEB
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 09:21:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 429B225779;
	Mon, 19 Feb 2024 09:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A8ok9AVu"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B287123765;
	Mon, 19 Feb 2024 09:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708334424; cv=none; b=Vg4vq+H7YqWlpZ9X73l0lsqD+r4ON2rTperag2D9+Pyd1GEelEIlLV2NZGRfV8b1Vfi6Z6SAuyoR6qhX9UX7V5pAE4TBDxVX8cv/fFxokU1/BH4lrTRk92AV1sUzXq0676W9TPfa1FFb0V45dwg6Eza7mdGMlvWNt8b58lFvjDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708334424; c=relaxed/simple;
	bh=gHuw6gM0kxaTDkdludLUngX+0zZfHKbDwECjHkZh6xs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ocZVrbWetWL1DnefTXE66Dv7ufkS0VmKuZlQT9kSvEMFIyV2JTPsLcXRQbuvRsaHhfDOQk48peOn2cj/3stKnMCrurgJ5vUt5aNgOuNEGhSQsCwJGZzWPe+u9gKeDc2J3H4y4vXMojl/7hieFf+gEd39AygBeX1TsJxvgQRJivo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A8ok9AVu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 671B1C43141;
	Mon, 19 Feb 2024 09:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708334424;
	bh=gHuw6gM0kxaTDkdludLUngX+0zZfHKbDwECjHkZh6xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A8ok9AVuLASRtCeECwevq3T7az8dloz4F58X2n4txtC+nzXPNCaGOB4+W9SQoRTj3
	 HqosrySHNBYwnlJA7ze6Vplik6S3GYFhpiw4qS1+X8FgP4kPpL7PG1rW5fOqTc6ca9
	 1VaFpzjWtPF4TcNeatQORbYYf0gBMSnNgr5dHK7dEmbycxSe3p14Mpj1VZJJKjN3I/
	 fCpWkiTCPkoBchr4+I/ge1+BGIscR9d60OrfPz/3+QitUML7CjnqNEA/3ZlEXz95d3
	 gXuPiT16HRLhrCNWW/TM7Peg4aMw6zdcaDYGN2jhU2aR3DXroKydy+RDhyyEbS/2ml
	 hLqnQgg10uyCw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rbzp0-004WBZ-J5;
	Mon, 19 Feb 2024 09:20:22 +0000
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
Subject: [PATCH 06/13] KVM: arm64: nv: Fast-track 'InHost' exception returns
Date: Mon, 19 Feb 2024 09:20:07 +0000
Message-Id: <20240219092014.783809-7-maz@kernel.org>
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

A significant part of the FEAT_NV extension is to trap ERET
instructions so that the hypervisor gets a chance to switch
from a vEL2 L1 guest to an EL1 L2 guest.

But this also has the unfortunate consequence of trapping ERET
in unsuspecting circumstances, such as staying at vEL2 (interrupt
handling while being in the guest hypervisor), or returning to host
userspace in the case of a VHE guest.

Although we already make some effort to handle these ERET quicker
by not doing the put/load dance, it is still way too far down the
line for it to be efficient enough.

For these cases, it would ideal to ERET directly, no question asked.
Of course, we can't do that. But the next best thing is to do it as
early as possible, in fixup_guest_exit(), much as we would handle
FPSIMD exceptions.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 29 +++-------------------
 arch/arm64/kvm/hyp/vhe/switch.c | 44 +++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 2d80e81ae650..63a74c0330f1 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2172,8 +2172,7 @@ static u64 kvm_check_illegal_exception_return(struct kvm_vcpu *vcpu, u64 spsr)
 
 void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
 {
-	u64 spsr, elr, mode;
-	bool direct_eret;
+	u64 spsr, elr;
 
 	/*
 	 * Forward this trap to the virtual EL2 if the virtual
@@ -2182,33 +2181,11 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
 	if (forward_traps(vcpu, HCR_NV))
 		return;
 
-	/*
-	 * Going through the whole put/load motions is a waste of time
-	 * if this is a VHE guest hypervisor returning to its own
-	 * userspace, or the hypervisor performing a local exception
-	 * return. No need to save/restore registers, no need to
-	 * switch S2 MMU. Just do the canonical ERET.
-	 */
-	spsr = vcpu_read_sys_reg(vcpu, SPSR_EL2);
-	spsr = kvm_check_illegal_exception_return(vcpu, spsr);
-
-	mode = spsr & (PSR_MODE_MASK | PSR_MODE32_BIT);
-
-	direct_eret  = (mode == PSR_MODE_EL0t &&
-			vcpu_el2_e2h_is_set(vcpu) &&
-			vcpu_el2_tge_is_set(vcpu));
-	direct_eret |= (mode == PSR_MODE_EL2h || mode == PSR_MODE_EL2t);
-
-	if (direct_eret) {
-		*vcpu_pc(vcpu) = vcpu_read_sys_reg(vcpu, ELR_EL2);
-		*vcpu_cpsr(vcpu) = spsr;
-		trace_kvm_nested_eret(vcpu, *vcpu_pc(vcpu), spsr);
-		return;
-	}
-
 	preempt_disable();
 	kvm_arch_vcpu_put(vcpu);
 
+	spsr = __vcpu_sys_reg(vcpu, SPSR_EL2);
+	spsr = kvm_check_illegal_exception_return(vcpu, spsr);
 	elr = __vcpu_sys_reg(vcpu, ELR_EL2);
 
 	trace_kvm_nested_eret(vcpu, elr, spsr);
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 29f59c374f7a..0c175516d114 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -205,6 +205,49 @@ void kvm_vcpu_put_vhe(struct kvm_vcpu *vcpu)
 	__vcpu_put_switch_sysregs(vcpu);
 }
 
+static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+	u64 spsr, mode;
+
+	/*
+	 * Going through the whole put/load motions is a waste of time
+	 * if this is a VHE guest hypervisor returning to its own
+	 * userspace, or the hypervisor performing a local exception
+	 * return. No need to save/restore registers, no need to
+	 * switch S2 MMU. Just do the canonical ERET.
+	 *
+	 * Unless the trap has to be forwarded further down the line,
+	 * of course...
+	 */
+	if (__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_NV)
+		return false;
+
+	spsr = read_sysreg_el1(SYS_SPSR);
+	mode = spsr & (PSR_MODE_MASK | PSR_MODE32_BIT);
+
+	switch (mode) {
+	case PSR_MODE_EL0t:
+		if (!(vcpu_el2_e2h_is_set(vcpu) && vcpu_el2_tge_is_set(vcpu)))
+			return false;
+		break;
+	case PSR_MODE_EL2t:
+		mode = PSR_MODE_EL1t;
+		break;
+	case PSR_MODE_EL2h:
+		mode = PSR_MODE_EL1h;
+		break;
+	default:
+		return false;
+	}
+
+	spsr = (spsr & ~(PSR_MODE_MASK | PSR_MODE32_BIT)) | mode;
+
+	write_sysreg_el2(spsr, SYS_SPSR);
+	write_sysreg_el2(read_sysreg_el1(SYS_ELR), SYS_ELR);
+
+	return true;
+}
+
 static const exit_handler_fn hyp_exit_handlers[] = {
 	[0 ... ESR_ELx_EC_MAX]		= NULL,
 	[ESR_ELx_EC_CP15_32]		= kvm_hyp_handle_cp15_32,
@@ -215,6 +258,7 @@ static const exit_handler_fn hyp_exit_handlers[] = {
 	[ESR_ELx_EC_DABT_LOW]		= kvm_hyp_handle_dabt_low,
 	[ESR_ELx_EC_WATCHPT_LOW]	= kvm_hyp_handle_watchpt_low,
 	[ESR_ELx_EC_PAC]		= kvm_hyp_handle_ptrauth,
+	[ESR_ELx_EC_ERET]		= kvm_hyp_handle_eret,
 	[ESR_ELx_EC_MOPS]		= kvm_hyp_handle_mops,
 };
 
-- 
2.39.2


