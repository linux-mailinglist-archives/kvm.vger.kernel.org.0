Return-Path: <kvm+bounces-24597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EECA9958399
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 12:07:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 298971C23C90
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 10:07:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A3AB18E044;
	Tue, 20 Aug 2024 10:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p62dr4lJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 628FA18E033;
	Tue, 20 Aug 2024 10:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724148379; cv=none; b=QgJsNyzxgl72iVs8sIbteTzbM1aJOgBdh1QT+ZHhteTP58q/BXK3dCDDfY1pfK04s9TDVSY+HySeyzni9Cw4E6OdY1tk4W/J+qBUGZ8r93TnDZxSsooqHNuPQFKAozVTIY0HK4C/aXRyabiaIAUp1lrK/t2HDOeVXorSzOIhN8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724148379; c=relaxed/simple;
	bh=OTQWz+14CWJzbCdaBvVt32KcLcs3BWNnPhezDAhJ4rE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kzWBYMu1leWJBE3LNhEmov3y8vRBYK2Vt4729nYWKqTep5EZSUu9cEaYTM1+xY9F3m1CJvToN4IMvmXHW+CGpdWGnVHuJAWsv0MqtuQFOd2AYBtrZpvfqUsnJ0PLPdMEnYnpSM8UnoA+5XvXMf6Kx4LR1LcX95AgFZeG/2CCJpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p62dr4lJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45386C4AF09;
	Tue, 20 Aug 2024 10:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724148379;
	bh=OTQWz+14CWJzbCdaBvVt32KcLcs3BWNnPhezDAhJ4rE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p62dr4lJGXNmdxGrFa59qSi07RYH5qJVe6VPxr/GkVncUsyghvkl+5H/SBjRSeCTO
	 5gJdDGA+RZFzWN695IOWtxVOfHAIpppHnvJyp9KDi7c7dq08SoGJfJeyzLhU7d9yoj
	 LcmlabxTAtgeYwV1OcgueZ8cUNYcxvUZhxNHiOBRF4l+6QVp0k//FbV72D4M13OOx4
	 1kpGuP5ayyHEYBQGOf2jzfrpljnPYdw2b9imsb/K4mF8VXMZKNn9zzsQNUN3es+FmN
	 k4RX5zHGhyqnGuXRPoGyxQTAf2Vb9TOvEFC8opCceaGXIWa8CPZetkzd2ycBflKrVG
	 Cxej1IDdGoY2g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sgLkk-005Dk2-9e;
	Tue, 20 Aug 2024 11:06:16 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexander Potapenko <glider@google.com>
Subject: [PATCH 09/12] KVM: arm64: Honor guest requested traps in GICv3 emulation
Date: Tue, 20 Aug 2024 11:03:46 +0100
Message-Id: <20240820100349.3544850-10-maz@kernel.org>
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

On platforms that require emulation of the CPU interface, we still
need to honor the traps requested by the guest (ICH_HCR_EL2 as well
as the FGTs for ICC_IGRPEN{0,1}_EL1.

Check for these bits early and lail out if any trap applies.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vgic-v3-sr.c | 72 +++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index a184def8f5ad..a01138a663ae 100644
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


