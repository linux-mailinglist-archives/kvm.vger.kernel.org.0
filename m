Return-Path: <kvm+bounces-62451-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EBAABC44419
	for <lists+kvm@lfdr.de>; Sun, 09 Nov 2025 18:20:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 90FF83B6D05
	for <lists+kvm@lfdr.de>; Sun,  9 Nov 2025 17:18:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0946330EF87;
	Sun,  9 Nov 2025 17:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O8P2YQsi"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6DD30DD02;
	Sun,  9 Nov 2025 17:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762708597; cv=none; b=Kh9W493CSvIqBJfPzkpbdbrqvxmArgR9uEh/5qg5KIZJkTEr7Ao9BVvtr8gYSnqgIfqUHWuqxXJgi7ibw/8+qJ6K8kZ2P9q749nyX4GFOns4KK2bqj7nRpb1unJzSAzCPrTOIIfj9P81vUfyjEBrFln/waiozdFwuw9qHx/jy2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762708597; c=relaxed/simple;
	bh=KaV8WuYjga/OBqyYenYZWM5x2h8cMy0LZ9LYeamx33E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p0Ecck3CYmydn6mKeKZenapOjej/OIXUARUP+LBlzaj+Yb3rplhLhEnLM+1+qAvIMDNPYUlRR2F1/j3KTuCIV0j7mXGXZ7SSg5H8FMG0CANZrVgso6jd9yGQw+DHT844bBVglpMVv+ZxanZlGo2rnY3r/7A2vxP3jqQomX8Avek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O8P2YQsi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6886C116B1;
	Sun,  9 Nov 2025 17:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762708596;
	bh=KaV8WuYjga/OBqyYenYZWM5x2h8cMy0LZ9LYeamx33E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O8P2YQsi0c9XQBj5qKH4Qhf4NgroiU7/cfPDVtI3/KTiJWyinM5l6jquQ+tTMr2Iv
	 0XuJEAcyjNvfg5To6x2H0wqfx7+LoTrxGEKBxec1QS7x+5xKyVx3IylMHjODnOwjAu
	 oo46aU/Y/UzyDi6vRBQIdfkH9fvy7alhDaUDvwtwLnvMNmmuvtk40nAXRQDDHINUF2
	 m7yjWruZWMid68S2NA7MoOQhv6isBdMs54iCdTudYxpml/lKpz4dycsYi4I2zMCKKh
	 2mrH3t5Do27dlMQIsbbhuhHx2blesKU0DdhAfd1/d3/7ojs3NE7+PRF64KDNhKS+GN
	 K5qA1W4S5/T+g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vI91n-00000003exw-0Jr6;
	Sun, 09 Nov 2025 17:16:35 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>
Subject: [PATCH v2 29/45] KVM: arm64: GICv3: Set ICH_HCR_EL2.TDIR when interrupts overflow LR capacity
Date: Sun,  9 Nov 2025 17:16:03 +0000
Message-ID: <20251109171619.1507205-30-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251109171619.1507205-1-maz@kernel.org>
References: <20251109171619.1507205-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, christoffer.dall@arm.com, Volodymyr_Babchuk@epam.com, yaoyuan@linux.alibaba.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Now that we are ready to handle deactivation through ICV_DIR_EL1,
set the trap bit if we have active interrupts outside of the LRs.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v3.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 1026031f22ff9..26e17ed057f00 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -42,6 +42,13 @@ void vgic_v3_configure_hcr(struct kvm_vcpu *vcpu,
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


