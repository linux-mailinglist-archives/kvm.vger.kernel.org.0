Return-Path: <kvm+bounces-25166-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 804F596120E
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 17:26:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E58F280FF6
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 15:26:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 280601CDA35;
	Tue, 27 Aug 2024 15:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dKIEpYeF"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0FC1C8FDE;
	Tue, 27 Aug 2024 15:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772330; cv=none; b=GtOTA2ejxhf/9YG+DCZE4MChoOO0+vFSNK/MNTTssmjfW1sWoCJQVFmlJ9OXaW1fJr2GzXiuAwhs7Q6STfYZgbAHhQ5IypLudeSLsHDN3RilifXXA6d+rxwiymneZRk1A9mBv8FbNnaL6h7XBA6OKAZXCgoryzMiZgyXVYSicmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772330; c=relaxed/simple;
	bh=4n/+s411kWwvNuV2Jukar/q0K7WaawJrCS7LOSB5a8I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WIAls1Uk5+dn3hf4IQo9zwwjLwmo4bs1y3iaChmhcT3v3ByJmcLqZFgCcL8eEGutEHUgvIFkVdLiTF+/EFtRxF4r8bnOyUi6vQLaQjEydKqEIRLID/O6+yNpYD3hlSyQqjDMVadfes1ObPxt3+K4IvkqBjSa40sA0be+7dxYDQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dKIEpYeF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4769DC4DDEF;
	Tue, 27 Aug 2024 15:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724772330;
	bh=4n/+s411kWwvNuV2Jukar/q0K7WaawJrCS7LOSB5a8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dKIEpYeFsuZl/7Ogld7uH04vPOYsfPKJzPFiKF5LrXlyMeMnTgxehMKOX9F8zJtxA
	 z1SuZSDrWgkPEjvmd5JHQAPmuNWrG8OIW04Lk1fuqhjMx51V4drXy7EGZ4uMqPjsKA
	 S8ZOXxGmIZmbiKACxZjvrqNg+mOLVOhEabS8nlnEW4h3ze0E5EBZi4+MyJPPz3PuhA
	 kyNt4f3NJnLrLAYdz3YUTHVrdAbf13qNe+W1P7rmWI27jjrfr6IwpbSDYpVHW3jgVn
	 GP+ZNewnu+EAPJ/NPc++7h9TVIW759g18O9y04xpGu4kqEY1EBVgN/vk1bo63JE9FN
	 QR0vV43bS1wbw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1siy4W-007HOs-CQ;
	Tue, 27 Aug 2024 16:25:28 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexander Potapenko <glider@google.com>
Subject: [PATCH v2 05/11] KVM: arm64: Zero ID_AA64PFR0_EL1.GIC when no GICv3 is presented to the guest
Date: Tue, 27 Aug 2024 16:25:11 +0100
Message-Id: <20240827152517.3909653-6-maz@kernel.org>
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

In order to be consistent, we shouldn't advertise a GICv3 when none
is actually usable by the guest.

Wipe the feature when these conditions apply, and allow the field
to be written from userspace.

This now allows us to rewrite the kvm_has_gicv3 helper() in terms
of kvm_has_feat(), given that it is always evaluated at runtime.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c  | 8 +++++++-
 arch/arm64/kvm/vgic/vgic.h | 4 +---
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index bc2d54da3827..e9d8e916e3af 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2365,7 +2365,6 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 		   ID_AA64PFR0_EL1_MPAM |
 		   ID_AA64PFR0_EL1_SVE |
 		   ID_AA64PFR0_EL1_RAS |
-		   ID_AA64PFR0_EL1_GIC |
 		   ID_AA64PFR0_EL1_AdvSIMD |
 		   ID_AA64PFR0_EL1_FP), },
 	ID_SANITISED(ID_AA64PFR1_EL1),
@@ -4634,6 +4633,13 @@ int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu)
 
 	guard(mutex)(&kvm->arch.config_lock);
 
+	if (!(static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif) &&
+	      irqchip_in_kernel(kvm) &&
+	      kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)) {
+		kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] &= ~ID_AA64PFR0_EL1_GIC_MASK;
+		kvm->arch.id_regs[IDREG_IDX(SYS_ID_PFR1_EL1)] &= ~ID_PFR1_EL1_GIC_MASK;
+	}
+
 	if (vcpu_has_nv(vcpu)) {
 		int ret = kvm_init_nv_sysregs(kvm);
 		if (ret)
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index c72c38b44234..f2486b4d9f95 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -350,9 +350,7 @@ void vcpu_set_ich_hcr(struct kvm_vcpu *vcpu);
 
 static inline bool kvm_has_gicv3(struct kvm *kvm)
 {
-	return (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif) &&
-		irqchip_in_kernel(kvm) &&
-		kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3);
+	return kvm_has_feat(kvm, ID_AA64PFR0_EL1, GIC, IMP);
 }
 
 #endif
-- 
2.39.2


