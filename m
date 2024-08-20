Return-Path: <kvm+bounces-24591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CAE6958394
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 12:06:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DB558B25699
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 10:06:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C11318DF63;
	Tue, 20 Aug 2024 10:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="agnhePuL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29DC18CBFC;
	Tue, 20 Aug 2024 10:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724148373; cv=none; b=nO0iAYpRRT2FPy5WeC2TpyCC/6ay3rWanHfvQ69J4W9FY6+hZVZ5oHqFX3aQrEhXQucn1DE41G8xHI+bBPiHxzekriQGBLoCPYLA//yQDwz81/twOqyAlsYcxTO06dG9PkpfDE8ik7ZrmAY2x88dPicEvJ9uRRDzn8UHxbcYyu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724148373; c=relaxed/simple;
	bh=5qe7KyoVB0A2e1O9vF8i9r+0N7pcUlrm42HzC0GglqA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=twWgi+lIXPB93eYE+Z3iLtAA858nlKU+/iiaWJkn1B1n2rI2Ao8MdGzuXCs0dqeW72tNSZRELgTqbyAP+lTky7HOBYZHAtJmOdqflBU8ZMPStm/+1SRwHofKxT6YWYD8e0/zvooxkuK8QyBl8RFDQYEYyghxdWxGOI3ZZ2cMaAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=agnhePuL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75C3AC4AF09;
	Tue, 20 Aug 2024 10:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724148373;
	bh=5qe7KyoVB0A2e1O9vF8i9r+0N7pcUlrm42HzC0GglqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=agnhePuL10Gvfj9wyY9JicbFVGs2bA7nyE9vmWkWL/QyvWv8jF4yYmEvPd5ZFMq4h
	 ILPaHC4qjP1NDZt8CRR9JQT/BDJzdACXyuKKPub8gkxIvSfIwXDH1mNKVKbyVQu9ql
	 OMUjJZI40AtnwnjXJ+X5QVgynbc2idWCRYJFL/PS4lS8PQrShcYkQL2f+fQ5ulN0N4
	 74n3mbTKBJsf3i0+f7/xe08CZPh2Q+RDUj+x5A1kXRGgr+/9DEl2HxMsotSI75oc9n
	 NTJqYBz/9c39XC33uDCwFFQ718ra0/TfS5SkG9G0WFzIfySTT3+NhMQiSReo8Nk/n0
	 t14XxC7cnv2Fg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sgLkh-005Dk2-9Z;
	Tue, 20 Aug 2024 11:06:11 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexander Potapenko <glider@google.com>
Subject: [PATCH 03/12] KVM: arm64: Force SRE traps when SRE access is not enabled
Date: Tue, 20 Aug 2024 11:03:40 +0100
Message-Id: <20240820100349.3544850-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240820100349.3544850-1-maz@kernel.org>
References: <20240820100349.3544850-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, glider@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We so far only write the ICH_HCR_EL2 config in two situations:

- when we need to emulate the GICv3 CPU interface due to HW bugs

- when we do direct injection, as the virtual CPU interface needs
  to be enabled

This is all good. But it also means that we don't do anything special
when we emulate a GICv2, or that there is no GIC at all.

What happens in this case when the guest uses the GICv3 system
registers? The *guest* gets a trap for a sysreg access (EC=0x18)
while we'd really like it to get an UNDEF.

Fixing this is a bit involved:

- we need to set all the required trap bits (TC, TALL0, TALL1, TDIR)

- for these traps to take effect, we need to (counter-intuitively)
  set ICC_SRE_EL1.SRE to 1 so that the above traps take priority.

Note that doesn't fully work when GICv2 emulation is enabled, as
we cannot set ICC_SRE_EL1.SRE to 1 (it breaks Group0 delivery as
IRQ).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vgic-v3-sr.c | 22 ++++++++++++++++------
 arch/arm64/kvm/vgic/vgic-v3.c   |  5 ++++-
 2 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index 7b397fad26f2..a184def8f5ad 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -268,8 +268,16 @@ void __vgic_v3_activate_traps(struct vgic_v3_cpu_if *cpu_if)
 	 * starting to mess with the rest of the GIC, and VMCR_EL2 in
 	 * particular.  This logic must be called before
 	 * __vgic_v3_restore_state().
+	 *
+	 * However, if the vgic is disabled (ICH_HCR_EL2.EN==0), no GIC is
+	 * provisionned at all. In order to prevent illegal accesses to the
+	 * system registers to trap to EL1 (duh), force ICC_SRE_EL1.SRE to 1
+	 * so that the trap bits can take effect. Yes, we *loves* the GIC.
 	 */
-	if (!cpu_if->vgic_sre) {
+	if (!(cpu_if->vgic_hcr & ICH_HCR_EN)) {
+		write_gicreg(ICC_SRE_EL1_SRE, ICC_SRE_EL1);
+		isb();
+	} else if (!cpu_if->vgic_sre) {
 		write_gicreg(0, ICC_SRE_EL1);
 		isb();
 		write_gicreg(cpu_if->vgic_vmcr, ICH_VMCR_EL2);
@@ -288,8 +296,9 @@ void __vgic_v3_activate_traps(struct vgic_v3_cpu_if *cpu_if)
 	}
 
 	/*
-	 * Prevent the guest from touching the GIC system registers if
-	 * SRE isn't enabled for GICv3 emulation.
+	 * Prevent the guest from touching the ICC_SRE_EL1 system
+	 * register. Note that this may not have any effect, as
+	 * ICC_SRE_EL2.Enable being RAO/WI is a valid implementation.
 	 */
 	write_gicreg(read_gicreg(ICC_SRE_EL2) & ~ICC_SRE_EL2_ENABLE,
 		     ICC_SRE_EL2);
@@ -297,10 +306,11 @@ void __vgic_v3_activate_traps(struct vgic_v3_cpu_if *cpu_if)
 	/*
 	 * If we need to trap system registers, we must write
 	 * ICH_HCR_EL2 anyway, even if no interrupts are being
-	 * injected,
+	 * injected. Note that this also applies if we don't expect
+	 * any system register access (GICv2 or no vgic at all).
 	 */
 	if (static_branch_unlikely(&vgic_v3_cpuif_trap) ||
-	    cpu_if->its_vpe.its_vm)
+	    cpu_if->its_vpe.its_vm || !cpu_if->vgic_sre)
 		write_gicreg(cpu_if->vgic_hcr, ICH_HCR_EL2);
 }
 
@@ -326,7 +336,7 @@ void __vgic_v3_deactivate_traps(struct vgic_v3_cpu_if *cpu_if)
 	 * no interrupts were being injected, and we disable it again here.
 	 */
 	if (static_branch_unlikely(&vgic_v3_cpuif_trap) ||
-	    cpu_if->its_vpe.its_vm)
+	    cpu_if->its_vpe.its_vm || !cpu_if->vgic_sre)
 		write_gicreg(0, ICH_HCR_EL2);
 }
 
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 11718412921f..b217b256853c 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -298,8 +298,11 @@ void vcpu_set_ich_hcr(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *vgic_v3 = &vcpu->arch.vgic_cpu.vgic_v3;
 
-	if (!kvm_has_gicv3(vcpu->kvm))
+	/* Hide GICv3 sysreg if necessary */
+	if (!kvm_has_gicv3(vcpu->kvm)) {
+		vgic_v3->vgic_hcr |= ICH_HCR_TALL0 | ICH_HCR_TALL1 | ICH_HCR_TC;
 		return;
+	}
 
 	if (group0_trap)
 		vgic_v3->vgic_hcr |= ICH_HCR_TALL0;
-- 
2.39.2


