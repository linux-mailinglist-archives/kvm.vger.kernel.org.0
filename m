Return-Path: <kvm+bounces-63941-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B469C75B7E
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:36:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5FF35346139
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:31:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDA1E3A79B6;
	Thu, 20 Nov 2025 17:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tZUzvQss"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DAC73A1D02;
	Thu, 20 Nov 2025 17:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763659562; cv=none; b=XlQdJbfjswmiZbQqRSJeNlrk8q9y6FIrbiRbDM4mxp5KK1yIHEzM47hCJgVCnC2xDp+OeKftgjp2mQcfi6ZeBqcahlkmUuyHmOSbHJjCedVBjhygTDyhKWYsdrPwHBRUg9OdXE0xZcboEMzG2aB8ekcrGZiuH+9QLUUhRpvyK48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763659562; c=relaxed/simple;
	bh=Mq07eAWTjNFWwCWLXG/M5L6neRDcPrbJTdf7eK+vuY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Caca9vIGMzvYDEyr+cptoXSavrSaT8x9M+5rqFmDLmueVWSiIy02uKKqz/ggw4QAvIbG+kRJ1BuMZDZsDseMBGYnH/cvOpVWw+BWZ5dv3lar7kPQLcgeleMn2v0XEGdNUfG6vwJBOCWWxXb2amupZ36KMwFpZuRfXsASRj1sgw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tZUzvQss; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1889C19421;
	Thu, 20 Nov 2025 17:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763659561;
	bh=Mq07eAWTjNFWwCWLXG/M5L6neRDcPrbJTdf7eK+vuY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tZUzvQss5zCfc6s51p9gSmYwujtIwZc3uR+LoCN6WiCrCw4y8qjwf2kRtyRvI5Ufi
	 44cN4f8rju+bUzXelr/oiR9rA+ka092B6HR+WTqDk58be/WjzIEF0R1BNUO4btm6ZM
	 z3avuyYqL0F/ZLG2cfyaFZSBSEOGWGQnk3SJ4GmtmMQSA8ktnvACCG/GgE1H4yrkvu
	 7vemJotSqIZns/tprYrG/LI7rIWANlTQrP6x1qAns15FuhM2clDuhJEuQwJaipp57d
	 yPc2IaqJSFU9C8wm4Yj37CaqB/TkEwlQHazchvVa/k9+NnWwWlhxTkCTz5QoMAuCkz
	 6tsEnGl7zRL7A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vM8Pw-00000006y6g-0naW;
	Thu, 20 Nov 2025 17:26:00 +0000
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
Subject: [PATCH v4 26/49] KVM: arm64: Use MI to detect groups being enabled/disabled
Date: Thu, 20 Nov 2025 17:25:16 +0000
Message-ID: <20251120172540.2267180-27-maz@kernel.org>
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

Add the maintenance interrupt to force an exit when the guest
enables/disables individual groups, so that we can resort the
ap_list accordingly.

Tested-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v2.c | 5 +++++
 arch/arm64/kvm/vgic/vgic-v3.c | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
index 18856186be7be..9a2de03f74c30 100644
--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -39,6 +39,11 @@ void vgic_v2_configure_hcr(struct kvm_vcpu *vcpu,
 		cpuif->vgic_hcr |= GICH_HCR_LRENPIE;
 	if (irqs_outside_lrs(als))
 		cpuif->vgic_hcr |= GICH_HCR_UIE;
+
+	cpuif->vgic_hcr |= (cpuif->vgic_vmcr & GICH_VMCR_ENABLE_GRP0_MASK) ?
+		GICH_HCR_VGrp0DIE : GICH_HCR_VGrp0EIE;
+	cpuif->vgic_hcr |= (cpuif->vgic_vmcr & GICH_VMCR_ENABLE_GRP1_MASK) ?
+		GICH_HCR_VGrp1DIE : GICH_HCR_VGrp1EIE;
 }
 
 static bool lr_signals_eoi_mi(u32 lr_val)
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 780cc92c79e04..312226cc2565d 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -39,6 +39,11 @@ void vgic_v3_configure_hcr(struct kvm_vcpu *vcpu,
 
 	if (!als->nr_sgi)
 		cpuif->vgic_hcr |= ICH_HCR_EL2_vSGIEOICount;
+
+	cpuif->vgic_hcr |= (cpuif->vgic_vmcr & ICH_VMCR_ENG0_MASK) ?
+		ICH_HCR_EL2_VGrp0DIE : ICH_HCR_EL2_VGrp0EIE;
+	cpuif->vgic_hcr |= (cpuif->vgic_vmcr & ICH_VMCR_ENG1_MASK) ?
+		ICH_HCR_EL2_VGrp1DIE : ICH_HCR_EL2_VGrp1EIE;
 }
 
 static bool lr_signals_eoi_mi(u64 lr_val)
-- 
2.47.3


