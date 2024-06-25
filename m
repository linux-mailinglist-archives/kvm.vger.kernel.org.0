Return-Path: <kvm+bounces-20483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3413691690F
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 15:37:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E28A128AA34
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 13:37:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68EEF16F915;
	Tue, 25 Jun 2024 13:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xpzyr36q"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE6C16B3A0;
	Tue, 25 Jun 2024 13:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719322525; cv=none; b=YDvojlvIwv7vqQ6LgazOA0YU2eLO9ygqW+L6xkNfZ1SgmMPkIGqWcYM4lMBf1+OCFC8TIRagg6Whs4ovpStAAk6vwb8ftHq4DB/X56lN63XmEuMX71LNHrelHsKifn6tWCR1/b67Im1y+6maCYVr8EbFjmrr5bRqHUGfGYCN/Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719322525; c=relaxed/simple;
	bh=GYYU7oaazXbNaqz2ULj2k5bsMFiur2S8hJufSai2nx4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kHup9P4WziDKpyfeoChe9MK26nPlnGQeR2JRfRC3O9tw/oxbp4IVGDJhHhDDvBPi1iLfqs5Soahn91w6xgHVpxlcXrbm6JGx5D5RSJx95MIyHZ3leYC/YEb+GhPB8gspMub8puQaK6zHuUUWVevyp8AlDSKr5QxQwmhmzB6G9KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xpzyr36q; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD8A6C4AF0D;
	Tue, 25 Jun 2024 13:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719322524;
	bh=GYYU7oaazXbNaqz2ULj2k5bsMFiur2S8hJufSai2nx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xpzyr36qQjQUJMMnP7fnMA9Ks5+IJtwuMhwkX9wE+iek3+SvXAVtZyFJLNZeA5EUf
	 sqpMNtyUWDGsLGo+fEb+dLWJXU6eRXR2OBs3PkVUb6WHKb9LURkRJQ5OtyS7fF/xUH
	 p+8W/FcrWU/zy/iZ0L0s/q2Hek63XEMqoTW011y80UyBOpxTO8KrkbNLlJW04hsAQd
	 g+dKyWXKgjVAPZ9cRO8/6b/VSKlOCuEfInyqyNQcuadX1lPwaxCpO+63VSN9HF9oAH
	 4MT8fvBwm5+hSFAHVK5zhhdw22N4saA3LXtFsIEcjajAhKMPOOklOhWe0CLodqKLDA
	 zE1VFYnj4Yg7Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sM6KR-007A6l-2e;
	Tue, 25 Jun 2024 14:35:23 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>
Subject: [PATCH 07/12] KVM: arm64: nv: Add basic emulation of AT S1E2{R,W}
Date: Tue, 25 Jun 2024 14:35:06 +0100
Message-Id: <20240625133508.259829-8-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240625133508.259829-1-maz@kernel.org>
References: <20240625133508.259829-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com
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
 arch/arm64/kvm/at.c              | 57 ++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 9b6c9f4f4d885..6ec0622969766 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -237,6 +237,7 @@ extern int __kvm_tlbi_s1e2(struct kvm_s2_mmu *mmu, u64 va, u64 sys_encoding);
 
 extern void __kvm_timer_set_cntvoff(u64 cntvoff);
 extern void __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr);
+extern void __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr);
 
 extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index eb0aa49e61f68..147df5a9cc4e0 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -195,3 +195,60 @@ void __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 
 	write_unlock(&vcpu->kvm->mmu_lock);
 }
+
+void __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
+{
+	struct kvm_s2_mmu *mmu;
+	unsigned long flags;
+	u64 val, hcr, par;
+	bool fail;
+
+	write_lock(&vcpu->kvm->mmu_lock);
+
+	mmu = &vcpu->kvm->arch.mmu;
+
+	/*
+	 * We've trapped, so everything is live on the CPU. As we will
+	 * be switching context behind everybody's back, disable
+	 * interrupts...
+	 */
+	local_irq_save(flags);
+
+	val = hcr = read_sysreg(hcr_el2);
+	val &= ~HCR_TGE;
+	val |= HCR_VM;
+
+	if (!vcpu_el2_e2h_is_set(vcpu))
+		val |= HCR_NV | HCR_NV1;
+
+	write_sysreg(val, hcr_el2);
+	isb();
+
+	switch (op) {
+	case OP_AT_S1E2R:
+		fail = __kvm_at(OP_AT_S1E1R, vaddr);
+		break;
+	case OP_AT_S1E2W:
+		fail = __kvm_at(OP_AT_S1E1W, vaddr);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		fail = true;
+	}
+
+	isb();
+
+	if (!fail)
+		par = read_sysreg_par();
+	else
+		par = SYS_PAR_EL1_F;
+
+	write_sysreg(hcr, hcr_el2);
+	isb();
+
+	local_irq_restore(flags);
+
+	write_unlock(&vcpu->kvm->mmu_lock);
+
+	vcpu_write_sys_reg(vcpu, par, PAR_EL1);
+}
-- 
2.39.2


