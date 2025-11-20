Return-Path: <kvm+bounces-63953-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A76FC75BA5
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:38:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 83D194E23E9
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:32:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E38363A9C08;
	Thu, 20 Nov 2025 17:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zxya5X6Y"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64BFA3A8D5A;
	Thu, 20 Nov 2025 17:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763659565; cv=none; b=X9tEbmaBsU5qLzCSuenMnykdO9cD5+XdxFc6Yawe3M3nsXPSIZYqdEJX96Pfc8VYySxnxRv+Y4Y4wDl8ujufz6Y5uXuidt6uFsJMdhONb45rAywGb2kCWuPSDC5GEPfDN5NbnnxrTTHqrxgVrD3GzqpP5Dzla9OdR7epstWQqm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763659565; c=relaxed/simple;
	bh=cRS4kAA0Vgfod9v7K2vTkuWwsLyxveyvdNB8H0bRqHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lxn7m/IkCJHQ9jmIDTO8jFwjLlZfTwu8OMziogGk9ccBIjx1HH5zfJTyUnpfM7MPgP7c4jKGT1jlLbj+HhsabvVdUNu3f/iAP2JZJKwu1/N9aX7awBhednBnw5jxuFjbv0U3QQMkLMsIrUmkc+ACHhxa3YpyB4/9/lL9zdL4vKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zxya5X6Y; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41396C4CEF1;
	Thu, 20 Nov 2025 17:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763659565;
	bh=cRS4kAA0Vgfod9v7K2vTkuWwsLyxveyvdNB8H0bRqHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zxya5X6YMY8GZqybGkaVqNlwhhOOD6oftaLqcSVIAQLhywKOrMBCJNy52kr3YQFc0
	 OmDTBlMlCL8Twt38AwQqaG2WX/GHMGA+3vhbL0VBTWMAfSQNUcWwRFNi1Va32xdjTe
	 3KXKSQLpzbLSTIj26yMrItyk26yL1q9lXB+P1cyFBB/JRnNrk/mV5obEPNW34gQWhz
	 euupH/JKmBVpUb/TssemEiFy1orxqlkPwNpc8LaCwGiyTQQxQu960iNIGJlIXxyiJI
	 Dm9MoA316KS7Kov4LrpQEHTu3KBMzFEiqnm1g9o8/uSoB5TTlsTuorTCUe9aLIqNw8
	 qgzNYR8W/Ir3A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vM8Pz-00000006y6g-1rYM;
	Thu, 20 Nov 2025 17:26:03 +0000
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
Subject: [PATCH v4 39/49] KVM: arm64: GICv2: Always trap GICV_DIR register
Date: Thu, 20 Nov 2025 17:25:29 +0000
Message-ID: <20251120172540.2267180-40-maz@kernel.org>
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

Since we can't decide to trap the DIR register on a per-vcpu basis,
always trap the second page of the GIC CPU interface. Yes, this is
costly. On the bright side, no sane SW should use EOImode==1 on
GICv2...

Tested-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c | 4 ++++
 arch/arm64/kvm/vgic/vgic-v2.c            | 2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
index 78579b31a4205..5fd99763b54de 100644
--- a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
+++ b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
@@ -63,6 +63,10 @@ int __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
 		return -1;
 	}
 
+	/* Handle deactivation as a normal exit */
+	if ((fault_ipa - vgic->vgic_cpu_base) >= GIC_CPU_DEACTIVATE)
+		return 0;
+
 	rd = kvm_vcpu_dabt_get_rd(vcpu);
 	addr  = kvm_vgic_global_state.vcpu_hyp_va;
 	addr += fault_ipa - vgic->vgic_cpu_base;
diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
index bc52d44a573d5..585491fbda807 100644
--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -457,7 +457,7 @@ int vgic_v2_map_resources(struct kvm *kvm)
 	if (!static_branch_unlikely(&vgic_v2_cpuif_trap)) {
 		ret = kvm_phys_addr_ioremap(kvm, dist->vgic_cpu_base,
 					    kvm_vgic_global_state.vcpu_base,
-					    KVM_VGIC_V2_CPU_SIZE, true);
+					    KVM_VGIC_V2_CPU_SIZE - SZ_4K, true);
 		if (ret) {
 			kvm_err("Unable to remap VGIC CPU to VCPU\n");
 			return ret;
-- 
2.47.3


