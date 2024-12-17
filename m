Return-Path: <kvm+bounces-33972-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0459A9F4F28
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 16:18:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 995401885FB6
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 15:16:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 626371F8EF1;
	Tue, 17 Dec 2024 15:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tt3ov10X"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571891F8919;
	Tue, 17 Dec 2024 15:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734448447; cv=none; b=dvZMCVTw4k3iUSUrrfiNdf80AmJK2yPqLWDyeffPvUmW0BMMZLjvlwfeQkbwbl8kuSFNEFPGHaQUdOyoNl9W3uDoAhro3x+ETJzy/rq0rCaG0znWAh2YACugb3Ms6a0oyJsaPiqkiULc6w+uUKhMjVrxg+kWcBEE+lCJsadv/1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734448447; c=relaxed/simple;
	bh=eQQR1n6j6KrLNytPFAXcb7IPj6XBMZpa9cMLnQ5crRs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Sg/LGkXP25nWwRXV0KgQCdBxmqgSzr0E+NjL8LnnpaG9GL3/fvgKL/G9Zhz9Jng6+pfm8RsdFw25KwrjlWp0F/7Dt19AY3iy1xHnuhX+w69OUiBlZNhcc/xipANDwdiU4pg7ekrXqqve3VUbiS5X3VPqAA5lPM4hmVd8bz98W+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tt3ov10X; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C6B4C4CED4;
	Tue, 17 Dec 2024 15:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734448447;
	bh=eQQR1n6j6KrLNytPFAXcb7IPj6XBMZpa9cMLnQ5crRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tt3ov10XgBX6O/xaR/GnjoiM5Vtl4C8D/AZmcuFED5c9lFAd/GTWKqMmyESi+/CHo
	 ESMiHM/uqV+mP+zQfcmzP6CU6A1AfWq8+tuCXqTzFh73PDmv1rWnWzgFlpOH4jQvZa
	 h2omzEiwykESikZf4xIyWQba3FWJhtgY1PzgsTgiLHPIr3RHPdM5iMKLv3bLKBksiv
	 8dyV+Vu1j/KFS+IkbXCP9Q79iOUNfYz/yZ477Km5pk1CeuQmCY2d7xb4LN7GOnw0rp
	 L7/tHildWuIZi35eNYaFUwO67ZfpilH+o5NnV9U+Lm84wAKzXpxqLUBuaeuMvyrTKa
	 yMjBLr9T9k04Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tNZGv-004bWV-GW;
	Tue, 17 Dec 2024 15:14:05 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Eric Auger <eauger@redhat.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH 15/16] KVM: arm64: nv: Fold GICv3 host trapping requirements into guest setup
Date: Tue, 17 Dec 2024 15:13:30 +0000
Message-Id: <20241217151331.934077-16-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241217151331.934077-1-maz@kernel.org>
References: <20241217151331.934077-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, andre.przywara@arm.com, eauger@redhat.com, gankulkarni@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Popular HW that is able to use NV also has a broken vgic implementation
that requires trapping.

On such HW, propagate the host trap bits into the guest's shadow
ICH_HCR_EL2 register, making sure we don't allow an L2 guest to bring
the system down.

This involves a bit of tweaking so that the emulation code correctly
poicks up the shadow state as needed, and to only partially sync
ICH_HCR_EL2 back with the guest state to capture EOIcount.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v3-nested.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgic-v3-nested.c
index b81bfa85ebb19..778ffb62de21c 100644
--- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
+++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
@@ -296,9 +296,19 @@ static void vgic_v3_create_shadow_state(struct kvm_vcpu *vcpu,
 					struct vgic_v3_cpu_if *s_cpu_if)
 {
 	struct vgic_v3_cpu_if *host_if = &vcpu->arch.vgic_cpu.vgic_v3;
+	u64 val = 0;
 	int i;
 
-	s_cpu_if->vgic_hcr = __vcpu_sys_reg(vcpu, ICH_HCR_EL2);
+	/*
+	 * If we're on a system with a broken vgic that requires
+	 * trapping, propagate the trapping requirements.
+	 *
+	 * Ah, the smell of rotten fruits...
+	 */
+	if (static_branch_unlikely(&vgic_v3_cpuif_trap))
+		val = host_if->vgic_hcr & (ICH_HCR_EL2_TALL0 | ICH_HCR_EL2_TALL1 |
+					   ICH_HCR_EL2_TC | ICH_HCR_EL2_TDIR);
+	s_cpu_if->vgic_hcr = __vcpu_sys_reg(vcpu, ICH_HCR_EL2) | val;
 	s_cpu_if->vgic_vmcr = __vcpu_sys_reg(vcpu, ICH_VMCR_EL2);
 	s_cpu_if->vgic_sre = host_if->vgic_sre;
 
@@ -335,6 +345,7 @@ void vgic_v3_put_nested(struct kvm_vcpu *vcpu)
 {
 	struct shadow_if *shadow_if = get_shadow_if();
 	struct vgic_v3_cpu_if *s_cpu_if = &shadow_if->cpuif;
+	u64 val;
 	int i;
 
 	__vgic_v3_save_vmcr_aprs(s_cpu_if);
@@ -345,7 +356,10 @@ void vgic_v3_put_nested(struct kvm_vcpu *vcpu)
 	 * Translate the shadow state HW fields back to the virtual ones
 	 * before copying the shadow struct back to the nested one.
 	 */
-	__vcpu_sys_reg(vcpu, ICH_HCR_EL2) = s_cpu_if->vgic_hcr;
+	val = __vcpu_sys_reg(vcpu, ICH_HCR_EL2);
+	val &= ~ICH_HCR_EL2_EOIcount_MASK;
+	val |= (s_cpu_if->vgic_hcr & ICH_HCR_EL2_EOIcount_MASK);
+	__vcpu_sys_reg(vcpu, ICH_HCR_EL2) = val;
 	__vcpu_sys_reg(vcpu, ICH_VMCR_EL2) = s_cpu_if->vgic_vmcr;
 
 	for (i = 0; i < 4; i++) {
@@ -354,7 +368,7 @@ void vgic_v3_put_nested(struct kvm_vcpu *vcpu)
 	}
 
 	for_each_set_bit(i, &shadow_if->lr_map, kvm_vgic_global_state.nr_lr) {
-		u64 val = __vcpu_sys_reg(vcpu, ICH_LRN(i));
+		val = __vcpu_sys_reg(vcpu, ICH_LRN(i));
 
 		val &= ~ICH_LR_STATE;
 		val |= s_cpu_if->vgic_lr[i] & ICH_LR_STATE;
-- 
2.39.2


