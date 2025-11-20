Return-Path: <kvm+bounces-63920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 23E82C75AB9
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:29:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id 80A162D16F
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:29:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9CA0371A01;
	Thu, 20 Nov 2025 17:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rPeGkt1M"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3614D2E8E04;
	Thu, 20 Nov 2025 17:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763659557; cv=none; b=twsvY73YopnT6WYPDsZgBhKPlXSjIVQUinr6RL08zaThlG+/8J/zIQ1bWrILX02VnB87bVHW8YUtKBkxOh+OqgbLIM2IW0D2ZmdaRupGkxq03hASpwh4AsTLYVSKi7L9No608wbonk5c9eFrXM3EVFgyuXHdvjgVp9kMWkY7YFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763659557; c=relaxed/simple;
	bh=7kelRFjUgActU5xiSytoyYN0KOzE8BSz1DCcl/nj/Cs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqUe1AVwsaXLDcjvuGxCRuNcrXE3pJbA+RsS6qsklHAJif4qFXIWe640KxVqV1dUBT7KCa47KiF3An+6KnHCCIKQt9cOA8UC0rOowVy+GTVlylI6qGrBuLdfkudvvRSAGsxSIi8LOTK7DhHrkbeWRpq3l9FhYDWTmXm14S1whzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rPeGkt1M; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AEE9C4CEF1;
	Thu, 20 Nov 2025 17:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763659557;
	bh=7kelRFjUgActU5xiSytoyYN0KOzE8BSz1DCcl/nj/Cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rPeGkt1Mc8suuivKBw2eE2Q5GiLSLTVsunNR300EHpY821ccGVjT6GLbTtUh61gRK
	 hiOx7m093SnTkw1qkviRqgDD1u5Y/Psns/YXx2yeJxf2L1tpPwjr5X5ojar143sarx
	 E8+R1zoRTp1y1918iLV7Jpo5PmJwT2JueMFS+bqmwa0yTSmasV3j57NOcYaOVHIb5j
	 8+oJiYjfkbgaTxLuJK8HlwB0+bHRvHZDogrKIiVpziU31TiLJj/QH9DDHPfjKty83A
	 6/rr9GNDbP4lNv6MBZqY46hMcwztBlXLg6BjAo5s0TcU2gDqqXWDcLepM4RSmXd1nn
	 qBCeCKRJXZ70Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vM8Pq-00000006y6g-4BxX;
	Thu, 20 Nov 2025 17:25:55 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v4 05/49] KVM: arm64: vgic-v3: Fix GICv3 trapping in protected mode
Date: Thu, 20 Nov 2025 17:24:55 +0000
Message-ID: <20251120172540.2267180-6-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251120172540.2267180-1-maz@kernel.org>
References: <20251120172540.2267180-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, christoffer.dall@arm.com, tabba@google.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

As we are about to start trapping a bunch of extra things, augment
the pKVM trap description with all the registers trapped by ICH_HCR_EL2.TC,
making them legal instead of resulting in a UNDEF injection in the guest.

While we're at it, ensure that pKVM captures the vgic model so that it
can be checked by the emulation code.

Tested-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c     | 3 +++
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 5 +++++
 2 files changed, 8 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 43bde061b65de..8911338961c5b 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -337,6 +337,9 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
 	/* CTR_EL0 is always under host control, even for protected VMs. */
 	hyp_vm->kvm.arch.ctr_el0 = host_kvm->arch.ctr_el0;
 
+	/* Preserve the vgic model so that GICv3 emulation works */
+	hyp_vm->kvm.arch.vgic.vgic_model = host_kvm->arch.vgic.vgic_model;
+
 	if (test_bit(KVM_ARCH_FLAG_MTE_ENABLED, &host_kvm->arch.flags))
 		set_bit(KVM_ARCH_FLAG_MTE_ENABLED, &kvm->arch.flags);
 
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 82da9b03692d4..3108b5185c204 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -444,6 +444,8 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
 
 	/* Scalable Vector Registers are restricted. */
 
+	HOST_HANDLED(SYS_ICC_PMR_EL1),
+
 	RAZ_WI(SYS_ERRIDR_EL1),
 	RAZ_WI(SYS_ERRSELR_EL1),
 	RAZ_WI(SYS_ERXFR_EL1),
@@ -457,9 +459,12 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
 
 	/* Limited Ordering Regions Registers are restricted. */
 
+	HOST_HANDLED(SYS_ICC_DIR_EL1),
+	HOST_HANDLED(SYS_ICC_RPR_EL1),
 	HOST_HANDLED(SYS_ICC_SGI1R_EL1),
 	HOST_HANDLED(SYS_ICC_ASGI1R_EL1),
 	HOST_HANDLED(SYS_ICC_SGI0R_EL1),
+	HOST_HANDLED(SYS_ICC_CTLR_EL1),
 	{ SYS_DESC(SYS_ICC_SRE_EL1), .access = pvm_gic_read_sre, },
 
 	HOST_HANDLED(SYS_CCSIDR_EL1),
-- 
2.47.3


