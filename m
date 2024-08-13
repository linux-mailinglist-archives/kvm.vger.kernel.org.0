Return-Path: <kvm+bounces-23966-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9021895020B
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 12:08:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B0FE11C219ED
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 10:08:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E7C319B5B8;
	Tue, 13 Aug 2024 10:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CYnAmRaK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2DC19B3C7;
	Tue, 13 Aug 2024 10:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723543585; cv=none; b=dMCugQzKDeNVCZ9ahV/x4Mzvj6af9qMyCr3bpebjuEN+CMr9AiRSNgx1X9DdOk/R1yUaC9FP6mIgv5KfBi0j2vqeupi4aEJ+SeHBS7MoL/I+PUu9dH5qFsP7qJzlf/R//nkJEOjsJQ1EN6AwOWYcZTrc4IqEME3QB81r0tri+DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723543585; c=relaxed/simple;
	bh=EF8aKuuoQKZ+bIKTimqLMEUEDhCJhIZkBeFL7Woj37A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TDyhhXwRL7NeSGu+K8o7u5dwCtDzvpVP0MUFaazyG1ljHVw3z/g48XAYqWJHPZi6U+ZUJ1xWTQ3i638CrWs9CS1e2pmjOmYIUl4S5pv/jwaWPJlwZT0LS/uyq7vker482IKTn5116dCKnz4qjHCm7nz7+u+Vk9yi2DtxvOl1spw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CYnAmRaK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5800C4AF12;
	Tue, 13 Aug 2024 10:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723543584;
	bh=EF8aKuuoQKZ+bIKTimqLMEUEDhCJhIZkBeFL7Woj37A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CYnAmRaKh1hM9oRJWCiOyhpiKd/fR72/gOY+p0EEWcqQSvRHaRAorXoMIM71pb+Pk
	 xA0fbr/tTeOaiVzNXlbuQbLGMC6IK5sB2U8e6njbnq1kWTNN1D0l2pbRIEBisu0/bj
	 pjzbQAtGhkxcajkeeFQ4zzPCN4SXKeA1t98XFIuw9TGCyejA1QKxuaTofjv+0gGB+i
	 uad5+3l7rz9f3OqtL32A5N4sp577xTuHrmoDVDIQxP2t87mYk32pecfKBMW+Nz9UoR
	 gu2pT6NbIc/iu68KlVXhLwAxUxTrNBKlQJXycqCt96TilyjcsfEgIR7oWIvTBp0nnu
	 +h83LHfjphQzg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sdoQ2-003INM-2k;
	Tue, 13 Aug 2024 11:06:22 +0100
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
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Przemyslaw Gaj <pgaj@cadence.com>
Subject: [PATCH v3 11/18] KVM: arm64: nv: Add basic emulation of AT S1E2{R,W}
Date: Tue, 13 Aug 2024 11:05:33 +0100
Message-Id: <20240813100540.1955263-12-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240813100540.1955263-1-maz@kernel.org>
References: <20240813100540.1955263-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, anshuman.khandual@arm.com, pgaj@cadence.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Similar to our AT S1E{0,1} emulation, we implement the AT S1E2
handling.

This emulation of course suffers from the same problems, but is
somehow simpler due to the lack of PAN2 and the fact that we are
guaranteed to execute it from the correct context.

Co-developed-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h |  1 +
 arch/arm64/kvm/at.c              | 51 ++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 9b6c9f4f4d88..6ec062296976 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -237,6 +237,7 @@ extern int __kvm_tlbi_s1e2(struct kvm_s2_mmu *mmu, u64 va, u64 sys_encoding);
 
 extern void __kvm_timer_set_cntvoff(u64 cntvoff);
 extern void __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr);
+extern void __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr);
 
 extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 92df948350e1..34736c1fe398 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -164,3 +164,54 @@ void __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 
 	vcpu_write_sys_reg(vcpu, par, PAR_EL1);
 }
+
+void __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
+{
+	u64 par;
+
+	/*
+	 * We've trapped, so everything is live on the CPU. As we will be
+	 * switching context behind everybody's back, disable interrupts...
+	 */
+	scoped_guard(write_lock_irqsave, &vcpu->kvm->mmu_lock) {
+		struct kvm_s2_mmu *mmu;
+		u64 val, hcr;
+		bool fail;
+
+		mmu = &vcpu->kvm->arch.mmu;
+
+		val = hcr = read_sysreg(hcr_el2);
+		val &= ~HCR_TGE;
+		val |= HCR_VM;
+
+		if (!vcpu_el2_e2h_is_set(vcpu))
+			val |= HCR_NV | HCR_NV1;
+
+		write_sysreg(val, hcr_el2);
+		isb();
+
+		par = SYS_PAR_EL1_F;
+
+		switch (op) {
+		case OP_AT_S1E2R:
+			fail = __kvm_at(OP_AT_S1E1R, vaddr);
+			break;
+		case OP_AT_S1E2W:
+			fail = __kvm_at(OP_AT_S1E1W, vaddr);
+			break;
+		default:
+			WARN_ON_ONCE(1);
+			fail = true;
+		}
+
+		isb();
+
+		if (!fail)
+			par = read_sysreg_par();
+
+		write_sysreg(hcr, hcr_el2);
+		isb();
+	}
+
+	vcpu_write_sys_reg(vcpu, par, PAR_EL1);
+}
-- 
2.39.2


