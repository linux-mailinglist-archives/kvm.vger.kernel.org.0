Return-Path: <kvm+bounces-24612-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AAB79584C8
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 12:39:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 20CE21F266E3
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 10:39:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EEAF18F2C0;
	Tue, 20 Aug 2024 10:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tq4p+ZPO"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34CCC18E763;
	Tue, 20 Aug 2024 10:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724150288; cv=none; b=kqEtR8Nw7ASvzXf5ikLr5zR75ePnW9RS1tDd4hQfcEvTLpfZ0gGicbWttfPqa0QLolOjtzg7Wjkx3j82iCVHfgMxz35KwaDGhZhE/Y3xfus73RhhWE13DseGqEUz4qOoIA2OY16qUN4pLVRTGqzUAmIu7o0x+XOyE2/EmWRRUl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724150288; c=relaxed/simple;
	bh=EF8aKuuoQKZ+bIKTimqLMEUEDhCJhIZkBeFL7Woj37A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aQBKt9euUgi2TJLg7ZXILenVf+5xDh4WFCzLb5N9PAdIzpO0Y962pASv4rvVc94LUrKzjU69xeAuADlPKlHq3xDlGLRF5QmEl5avc47b3wRkBkECajUUtBlH3eforGfUeqbN/2xtaR2f/ww7QIlNXGztlybFFbNrpYqL3oL4IxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tq4p+ZPO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17552C4AF09;
	Tue, 20 Aug 2024 10:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724150288;
	bh=EF8aKuuoQKZ+bIKTimqLMEUEDhCJhIZkBeFL7Woj37A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tq4p+ZPOgugKLJqTkikFgVyDwKrzLOpYzYupoLfEyDZNHNB4TzzMrb/PvQ1dVfWh9
	 NRkKnNE9X+EF4R3DGcM0kSwew6dVe9ZRSEXkJceUXqQBAR1NJ8SKi1+jKfkeRyhrfZ
	 WZmPtpnG8QFD6WffNf8ihzhmH6XF9pJ9qhsFg2iMv2rIyPGvpQBklVTDI10deA1qzd
	 AbO48iQ9c+ocqFzkT86hJCAtdlFynXI8jx7boKLopFk0eHWGr12i/9PmWi9Y6Upsvj
	 ZV1oEjD1aRG+Vu3hfkrciCLhkoTM9gbPQ1KsfI+uKlpPbMkor5rogQyG0vyB6yBSAc
	 XmSfC/AWetlNQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sgMFa-005Ea3-8e;
	Tue, 20 Aug 2024 11:38:06 +0100
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
	Przemyslaw Gaj <pgaj@cadence.com>,
	Jintack Lim <jintack.lim@linaro.org>
Subject: [PATCH v4 11/18] KVM: arm64: nv: Add basic emulation of AT S1E2{R,W}
Date: Tue, 20 Aug 2024 11:37:49 +0100
Message-Id: <20240820103756.3545976-12-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240820103756.3545976-1-maz@kernel.org>
References: <20240820103756.3545976-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, anshuman.khandual@arm.com, pgaj@cadence.com, jintack.lim@linaro.org
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


