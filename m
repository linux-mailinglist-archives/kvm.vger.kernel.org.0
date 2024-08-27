Return-Path: <kvm+bounces-25172-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DC12961217
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 17:27:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DCD02B23A47
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 15:27:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5757C1CEAB9;
	Tue, 27 Aug 2024 15:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H/0zlJlU"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739881CE6E5;
	Tue, 27 Aug 2024 15:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772332; cv=none; b=CEfxCe7jNzRkE0OL9blODs+Z0oLFp0NfDYkADq7bFOoVlyDm3IWEYG+Yh2Rrt3iSa8N4vRlBj9kJQb+D1tI7++zD+XMQq5ivHhAahWyrbEBWdjjE6JINbbkwyuqT1MU6xV4nj6r1hO2bwNeA/klEMw1gZgXz9/iiiUbDWkER9Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772332; c=relaxed/simple;
	bh=BxpnRe/5vi3kuAz7M5vtppXSNYJAvrbyFnLC7DM+wXE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WIJYJvlxGlzX86XmrokEvi9z2oD4QhhZyYS5+k3hWX2C1aiQYEGueBcVp5loslS3ZaeDzpAjQ3u0Ggta/xyzax/YPrFg+C6OO6CTay99fmPoGI5RJGV7mLWo1N2FOZqC7Ta/0xEidUd/GSsrJ04BrcrCLfYwxVXLBBKzB5+EEH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H/0zlJlU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8916C61071;
	Tue, 27 Aug 2024 15:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724772331;
	bh=BxpnRe/5vi3kuAz7M5vtppXSNYJAvrbyFnLC7DM+wXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H/0zlJlUdTGgv1YsEc6o3/PmCyR7ARlbFhvpsxvypQSWXWf1L6dimgsPOeYFRX66y
	 dgVdxAPm5Zxxkb+tE6d4zRJptNf2RDuT4CLbWhjMc48RqvQVM/PjixDBTGo0GyMLf8
	 /MoBgkajLnu01dy1XGiSp6R8Wj5vvvi1FW+iGN9uC0WFW4Ni+/JB38yujxWf1UFUei
	 FjOlnnzwcVdBRyFWiyrCQC4QwALAdwwyXhWykqGYUenED3dIEPc6p/SUO4cMDkQ6me
	 6sml/jZ3hVSmIrGQPphMq+qkm8vm1nOCpIiBGOdPH6bAfRUt+5twFgrfuvFUBQfX6T
	 U4HYoyMa4RC+A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1siy4X-007HOs-1m;
	Tue, 27 Aug 2024 16:25:29 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexander Potapenko <glider@google.com>
Subject: [PATCH v2 08/11] KVM: arm64: Honor guest requested traps in GICv3 emulation
Date: Tue, 27 Aug 2024 16:25:14 +0100
Message-Id: <20240827152517.3909653-9-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240827152517.3909653-1-maz@kernel.org>
References: <20240827152517.3909653-1-maz@kernel.org>
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

On platforms that require emulation of the CPU interface, we still
need to honor the traps requested by the guest (ICH_HCR_EL2 as well
as the FGTs for ICC_IGRPEN{0,1}_EL1.

Check for these bits early and lail out if any trap applies.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vgic-v3-sr.c | 72 +++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index c9ab76652c32..39f6363caa1f 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -1042,6 +1042,75 @@ static void __vgic_v3_write_ctlr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 	write_gicreg(vmcr, ICH_VMCR_EL2);
 }
 
+static bool __vgic_v3_check_trap_forwarding(struct kvm_vcpu *vcpu,
+					    u32 sysreg, bool is_read)
+{
+	u64 ich_hcr;
+
+	if (!vcpu_has_nv(vcpu) || is_hyp_ctxt(vcpu))
+		return false;
+
+	ich_hcr = __vcpu_sys_reg(vcpu, ICH_HCR_EL2);
+
+	switch (sysreg) {
+	case SYS_ICC_IGRPEN0_EL1:
+		if (is_read &&
+		    (__vcpu_sys_reg(vcpu, HFGRTR_EL2) & HFGxTR_EL2_ICC_IGRPENn_EL1))
+			return true;
+
+		if (!is_read &&
+		    (__vcpu_sys_reg(vcpu, HFGWTR_EL2) & HFGxTR_EL2_ICC_IGRPENn_EL1))
+			return true;
+
+		fallthrough;
+
+	case SYS_ICC_AP0Rn_EL1(0):
+	case SYS_ICC_AP0Rn_EL1(1):
+	case SYS_ICC_AP0Rn_EL1(2):
+	case SYS_ICC_AP0Rn_EL1(3):
+	case SYS_ICC_BPR0_EL1:
+	case SYS_ICC_EOIR0_EL1:
+	case SYS_ICC_HPPIR0_EL1:
+	case SYS_ICC_IAR0_EL1:
+		return ich_hcr & ICH_HCR_TALL0;
+
+	case SYS_ICC_IGRPEN1_EL1:
+		if (is_read &&
+		    (__vcpu_sys_reg(vcpu, HFGRTR_EL2) & HFGxTR_EL2_ICC_IGRPENn_EL1))
+			return true;
+
+		if (!is_read &&
+		    (__vcpu_sys_reg(vcpu, HFGWTR_EL2) & HFGxTR_EL2_ICC_IGRPENn_EL1))
+			return true;
+
+		fallthrough;
+
+	case SYS_ICC_AP1Rn_EL1(0):
+	case SYS_ICC_AP1Rn_EL1(1):
+	case SYS_ICC_AP1Rn_EL1(2):
+	case SYS_ICC_AP1Rn_EL1(3):
+	case SYS_ICC_BPR1_EL1:
+	case SYS_ICC_EOIR1_EL1:
+	case SYS_ICC_HPPIR1_EL1:
+	case SYS_ICC_IAR1_EL1:
+		return ich_hcr & ICH_HCR_TALL1;
+
+	case SYS_ICC_DIR_EL1:
+		if (ich_hcr & ICH_HCR_TDIR)
+			return true;
+
+		fallthrough;
+
+	case SYS_ICC_RPR_EL1:
+	case SYS_ICC_CTLR_EL1:
+	case SYS_ICC_PMR_EL1:
+		return ich_hcr & ICH_HCR_TC;
+
+	default:
+		return false;
+	}
+}
+
 int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
 {
 	int rt;
@@ -1065,6 +1134,9 @@ int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
 
 	is_read = (esr & ESR_ELx_SYS64_ISS_DIR_MASK) == ESR_ELx_SYS64_ISS_DIR_READ;
 
+	if (__vgic_v3_check_trap_forwarding(vcpu, sysreg, is_read))
+		return 0;
+
 	switch (sysreg) {
 	case SYS_ICC_IAR0_EL1:
 	case SYS_ICC_IAR1_EL1:
-- 
2.39.2


