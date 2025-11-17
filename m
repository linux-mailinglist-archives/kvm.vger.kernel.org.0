Return-Path: <kvm+bounces-63343-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 48A5AC6321D
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 10:21:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id D67EA3511D3
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 09:16:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3C6425A2B5;
	Mon, 17 Nov 2025 09:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vkd2qkPc"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4264326927;
	Mon, 17 Nov 2025 09:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763370941; cv=none; b=old43poR31dj21KNQVteWGOr8X6XIldW2E9YBHWOTmYx13xyz4D1xYbZgc7Mf5eODdBTp3pAGX27RNLY3FaHS+X/HN/ZCiCcS8K5DW5G3+gW98aRKLANuU1Qtk2yZMlYSQlRv+HzgpGptKTE/Ki88GObWFuDtO4MQd030EkRwr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763370941; c=relaxed/simple;
	bh=CVwY6QjTysUk+TJ+4eWGwF3UQ2kV890ZxMoP0eVGLxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VtLIX7koNEptO9x9iEQERPvDOd7Nl1mU85E3Lkq/yf3iqCXYiyJF98Aa3Qpgqi7GkIjE48Fdwx3312tp7B1QWTPlQU3NFAM6Crz4DKcRJFz47apDDdY/3F04SYvAeRKsro7egirlCzFEhCyKruHr+A20atD0dEUkuS5tkNiWJPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vkd2qkPc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A157C4AF60;
	Mon, 17 Nov 2025 09:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763370941;
	bh=CVwY6QjTysUk+TJ+4eWGwF3UQ2kV890ZxMoP0eVGLxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vkd2qkPc31XBQ+7SbDtXvamJWJ43A7BJdn+dV2uT2p7Zs9fKZGPGU24M6qYDcmzLs
	 RgzDbjV7c9nDTc3/5wDvifImZyMOqfUsKERE2K8JL9s/tXcz1s3ZSNTV3kN5osa7JU
	 phG64a9cDptRjou9J1AHGf+H0mmRgqjsHPNCZtB9o8P1799ifkGP/IQCghpicReD1E
	 SQcsP92gzWG4f5b9Xb7ydBtklcBFEp7QBbWdjtI7mXnBIrKAj+t9VFXAARul6UN560
	 Z7XvcGBFm92UoS02Y+IrBd2hZ+dOMrKneR0G8er4bjtqWOUkYJz68fBbTpm25Prcw2
	 OCeps4j0qs34g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vKvKl-00000005lB2-1pUi;
	Mon, 17 Nov 2025 09:15:39 +0000
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
Subject: [PATCH v3 4/5] KVM: arm64: GICv3: Remove vgic_hcr workaround handling leftovers
Date: Mon, 17 Nov 2025 09:15:26 +0000
Message-ID: <20251117091527.1119213-5-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251117091527.1119213-1-maz@kernel.org>
References: <20251117091527.1119213-1-maz@kernel.org>
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

There's a bizarre or'ing of a 0 with the guest's ICH_HCR_EL2's
value, which is a leftover from the host workaround merging
code. Just kill it.

Fixes: ca30799f7c2d0 ("KVM: arm64: Turn vgic-v3 errata traps into a patched-in constant")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v3-nested.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgic-v3-nested.c
index bf37fd3198ba7..40f7a37e0685c 100644
--- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
+++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
@@ -323,10 +323,9 @@ static void vgic_v3_create_shadow_state(struct kvm_vcpu *vcpu,
 					struct vgic_v3_cpu_if *s_cpu_if)
 {
 	struct vgic_v3_cpu_if *host_if = &vcpu->arch.vgic_cpu.vgic_v3;
-	u64 val = 0;
 	int i;
 
-	s_cpu_if->vgic_hcr = __vcpu_sys_reg(vcpu, ICH_HCR_EL2) | val;
+	s_cpu_if->vgic_hcr = __vcpu_sys_reg(vcpu, ICH_HCR_EL2);
 	s_cpu_if->vgic_vmcr = __vcpu_sys_reg(vcpu, ICH_VMCR_EL2);
 	s_cpu_if->vgic_sre = host_if->vgic_sre;
 
-- 
2.47.3


