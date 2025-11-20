Return-Path: <kvm+bounces-63945-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BA61C75BAE
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:38:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 541C44ED73F
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:31:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0254C3A5E63;
	Thu, 20 Nov 2025 17:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dkjMSsRk"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E4F368296;
	Thu, 20 Nov 2025 17:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763659563; cv=none; b=gcXBBK+jQwDZXnAO4FQ2fIv/1zzb8OUnexA//KkQ7ULMZpkWXt1KhHDhlge7+Ab5gUwqzwhbT3vC3SSVwPuIHUSQ2iD0aH9sAbCIz/L4ApdXG6zw/5eLmPlQSeC3+iszLeZcPh4ipy6ZhFT6b/6jh+9BDui0pKo1pUpm7lBfj3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763659563; c=relaxed/simple;
	bh=dWDeyae6N77yEGNAKHiIA8aFG+UfJsUWjTDlzOcR5Z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y4nZAwRXprbCYVBqlshULyiPV6vRdjeTBjCG92Ah68gskZnTFewQvfcmLq1ywJE1/2c9WUhQLpaXrrOPYf2pxGhMobxTHQdVIrD5EaPoVSfJ+eu4f2JKrmO2g0hvZlVyjoEqckKcaj0uPbvkfs3gkGbv10XbUW2xiu4ffNFr+fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dkjMSsRk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C40C116D0;
	Thu, 20 Nov 2025 17:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763659563;
	bh=dWDeyae6N77yEGNAKHiIA8aFG+UfJsUWjTDlzOcR5Z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dkjMSsRk3fJw+aKn4gvxuLDa68dhzMojiTFGq7Z19Y+gDLq9Of1FPK+gHarTXf2I8
	 fn9D8v5pj1/vdpHZc8X2T3GCU9es/8SLVg4GchurG/kkxp9rpOAf5zxIkH5pyCWcCh
	 VRs7/H7bwjv0f5c0kbNudHBLc5gbb6/gXErHGFYtMqnzyYAM9KVdTKktBKpxqm+i/c
	 hxrC3wzi9Kah5fYmGT+FEaZJEp8jnWTmrem6M5LNHQxttWFeOFDdQs8sbd76Y4S7Gu
	 ZkWEIwSdyTLrCgj8i3TFgLiUD1JD303HdJuVFQXcy+KnrVLfTnaFYrCduTdtyHM06V
	 R8NkRWYrnvbGg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vM8Px-00000006y6g-0reG;
	Thu, 20 Nov 2025 17:26:01 +0000
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
Subject: [PATCH v4 30/49] KVM: arm64: GICv3: Set ICH_HCR_EL2.TDIR when interrupts overflow LR capacity
Date: Thu, 20 Nov 2025 17:25:20 +0000
Message-ID: <20251120172540.2267180-31-maz@kernel.org>
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

Now that we are ready to handle deactivation through ICV_DIR_EL1,
set the trap bit if we have active interrupts outside of the LRs.

Tested-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v3.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 9fcee5121fe5e..09f86bf6fe7b8 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -45,6 +45,13 @@ void vgic_v3_configure_hcr(struct kvm_vcpu *vcpu,
 		ICH_HCR_EL2_VGrp0DIE : ICH_HCR_EL2_VGrp0EIE;
 	cpuif->vgic_hcr |= (cpuif->vgic_vmcr & ICH_VMCR_ENG1_MASK) ?
 		ICH_HCR_EL2_VGrp1DIE : ICH_HCR_EL2_VGrp1EIE;
+
+	/*
+	 * Note that we set the trap irrespective of EOIMode, as that
+	 * can change behind our back without any warning...
+	 */
+	if (irqs_active_outside_lrs(als))
+		cpuif->vgic_hcr |= ICH_HCR_EL2_TDIR;
 }
 
 static bool lr_signals_eoi_mi(u64 lr_val)
-- 
2.47.3


