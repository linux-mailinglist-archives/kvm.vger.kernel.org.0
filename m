Return-Path: <kvm+bounces-32837-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC1979E09C1
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 18:23:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AACD0162C09
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 17:23:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CDE91DE3A2;
	Mon,  2 Dec 2024 17:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kf0VHJ8i"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6815B1DDC0C;
	Mon,  2 Dec 2024 17:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733160140; cv=none; b=I3up9angp/aCIfQC6x+VmN4CTmHTaL57SP6x1Uy/XuoWhgIfGWgkhlJM0l+MczzqsMgVxh/RdCe0C2R8mrR8J7g7iy3U45GSTJx/8O2gIY7Ia4vjsTI1yyx8ANy2PXjyN6B+35AEv4ffNAy9b0sg908UYtZWWz7DgeYtUP4jXnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733160140; c=relaxed/simple;
	bh=HmEk0RAxHAj5K5OGiepCVArlYvZ8T1KHJ8vERxPf9yQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Pv0pahL9o46xU/HTbpUQ4fay9ao9O5eaJZ3rHEJ7FT7A/LR0SACYPAkoVH5ZQNO7Z8MCtp2U+6rF0g7V8xAWTWCKcGgMd9o5elDJ9Z69gR1pS2M6w9/8hjKetp4m4k4qaIMPNx7Oa18FXI5i2pVF+9lbOBwj0Td9vwphw6mdvhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kf0VHJ8i; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D15C4CEE1;
	Mon,  2 Dec 2024 17:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733160139;
	bh=HmEk0RAxHAj5K5OGiepCVArlYvZ8T1KHJ8vERxPf9yQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kf0VHJ8iDQjtz83w10Wm8bbChUEcKiR4XCQQdhTXoK9kNWIUVGhG65cax0AuXfoqa
	 LPqOz0uqAAAfQOkjPduyGKu06ycbgXWKIgvPZ54XfuTKrwJCC/h+Xdahpzwmtm0bjT
	 pD2iBlHQfSLD7raP2j/G8MzXJRyFM2clA0KZEKh+yJ27cCMysjvZNSDnVZgMVv7SJE
	 L9IRb5ZfPu0HJysaRHgbP50jZyPgtSjq9cZaAxpAmDmLYAYT4e7TYDkde887yac8dI
	 AUkW3r58XWaAzL5Mhj8cuM+ID/gpidhnzrE8Bs6owSApvXbEA70ht9SH8Da96MwBcv
	 QpzEBgMPFfo2g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tIA7l-00HQcf-5H;
	Mon, 02 Dec 2024 17:22:17 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH 07/11] KVM: arm64: Handle counter access early in non-HYP context
Date: Mon,  2 Dec 2024 17:21:30 +0000
Message-Id: <20241202172134.384923-8-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241202172134.384923-1-maz@kernel.org>
References: <20241202172134.384923-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, andersson@kernel.org, christoffer.dall@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We already deal with CNTPCT_EL0 accesses in non-HYP context.
Let's add CNTVCT_EL0 as a good measure.

This is also an opportunity to simplify things and make it
plain that this code is only for non-HYP context handling.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 34 +++++++++++++++----------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 30e572de28749..719479b42b329 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -506,7 +506,7 @@ static inline u64 compute_counter_value(struct arch_timer_context *ctxt)
 	return arch_timer_read_cntpct_el0() - timer_get_offset(ctxt);
 }
 
-static bool kvm_hyp_handle_cntpct(struct kvm_vcpu *vcpu)
+static bool kvm_handle_cntxct(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_context *ctxt;
 	u32 sysreg;
@@ -516,18 +516,19 @@ static bool kvm_hyp_handle_cntpct(struct kvm_vcpu *vcpu)
 	 * We only get here for 64bit guests, 32bit guests will hit
 	 * the long and winding road all the way to the standard
 	 * handling. Yes, it sucks to be irrelevant.
+	 *
+	 * Also, we only deal with non-hypervisor context here (either
+	 * an EL1 guest, or a non-HYP context of an EL2 guest).
 	 */
+	if (is_hyp_ctxt(vcpu))
+		return false;
+
 	sysreg = esr_sys64_to_sysreg(kvm_vcpu_get_esr(vcpu));
 
 	switch (sysreg) {
 	case SYS_CNTPCT_EL0:
 	case SYS_CNTPCTSS_EL0:
 		if (vcpu_has_nv(vcpu)) {
-			if (is_hyp_ctxt(vcpu)) {
-				ctxt = vcpu_hptimer(vcpu);
-				break;
-			}
-
 			/* Check for guest hypervisor trapping */
 			val = __vcpu_sys_reg(vcpu, CNTHCTL_EL2);
 			if (!vcpu_el2_e2h_is_set(vcpu))
@@ -539,16 +540,23 @@ static bool kvm_hyp_handle_cntpct(struct kvm_vcpu *vcpu)
 
 		ctxt = vcpu_ptimer(vcpu);
 		break;
+	case SYS_CNTVCT_EL0:
+	case SYS_CNTVCTSS_EL0:
+		if (vcpu_has_nv(vcpu)) {
+			/* Check for guest hypervisor trapping */
+			val = __vcpu_sys_reg(vcpu, CNTHCTL_EL2);
+
+			if (val & CNTHCTL_EL1TVCT)
+				return false;
+		}
+
+		ctxt = vcpu_vtimer(vcpu);
+		break;
 	default:
 		return false;
 	}
 
-	val = arch_timer_read_cntpct_el0();
-
-	if (ctxt->offset.vm_offset)
-		val -= *kern_hyp_va(ctxt->offset.vm_offset);
-	if (ctxt->offset.vcpu_offset)
-		val -= *kern_hyp_va(ctxt->offset.vcpu_offset);
+	val = compute_counter_value(ctxt);
 
 	vcpu_set_reg(vcpu, kvm_vcpu_sys_get_rt(vcpu), val);
 	__kvm_skip_instr(vcpu);
@@ -593,7 +601,7 @@ static bool kvm_hyp_handle_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code)
 	    __vgic_v3_perform_cpuif_access(vcpu) == 1)
 		return true;
 
-	if (kvm_hyp_handle_cntpct(vcpu))
+	if (kvm_handle_cntxct(vcpu))
 		return true;
 
 	return false;
-- 
2.39.2


