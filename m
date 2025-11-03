Return-Path: <kvm+bounces-61873-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E59EAC2D4D8
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 17:58:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B6A13189C3FB
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 16:57:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84C6E32143F;
	Mon,  3 Nov 2025 16:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MHK5f4cW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389C531E0ED;
	Mon,  3 Nov 2025 16:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762188930; cv=none; b=rIH7uNvAk7S5DlyNjHs0ZTvedDItwQGWyiqzQi4AuEn4wSyTU5bgsnO5/oRLsqjHpxDrSdyfqOzamOd/EWjuAPqZf1qRbHbhqR035TS3XpuZeWcwb/uOo5KHTh62trdkg9HJtvyy0LV39CXGHi99eBRjkkAy1JPM2dYDm+f89rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762188930; c=relaxed/simple;
	bh=v01Vg22EJGqDANe+d5iFLhgxo6rRA09Yj1ZORRZolzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rPwkefNWHohC0Nc4TVmxD8q9k5Q/XtESkL6xMSDg4R88etGowN2MHsVhxvtkWr06cDZffIgSEa9LNggAvV5lkPMmG34hgjAeDcnCMbK2oitQdC11i8CLRAiVzMfzLltrtcdjMqwW/5HOCH6nv1hhP28BhlmkFFxKv+CfHrKNPzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MHK5f4cW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D026BC16AAE;
	Mon,  3 Nov 2025 16:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762188929;
	bh=v01Vg22EJGqDANe+d5iFLhgxo6rRA09Yj1ZORRZolzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MHK5f4cWAfzeHfwjlMfH2dS/2qJhujfljbX041jtbRl4cMS/gcbJ7FHCtPSHfe5HW
	 VLWe2wgmR4XoOkVBLVdd4JhUzn+0faii5NDAjtspvXdPWzg++EvB1hUgDq1Z7BhxBt
	 AHktNgD4pYgVx36XvXXHuF59rfbKw3RYFBb0ktjOi0iwywcNOLTa2wpam1VOlg/I3M
	 2P+NplRAGR/dpvy4ZqRfF/ikPDjbX2tpxkMwOYhfWSKWED0GyKLjfoLWFe1K/whusq
	 CCZxnspxIIemQlFYfGbPU8b5S2C3TRu8i68WIp/cEQWSqFYAlEMcCw932aSTSM6C07
	 0ZDdheYfSPfAA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vFxq4-000000021VN-08T3;
	Mon, 03 Nov 2025 16:55:28 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>
Subject: [PATCH 14/33] KVM: arm64: GICv2: Preserve EOIcount on exit
Date: Mon,  3 Nov 2025 16:54:58 +0000
Message-ID: <20251103165517.2960148-15-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251103165517.2960148-1-maz@kernel.org>
References: <20251103165517.2960148-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, christoffer.dall@arm.com, Volodymyr_Babchuk@epam.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

EOIcount is how the virtual CPU interface signals that the guest
is deactivating interrupts outside of the LRs when EOImode==0.

We therefore need to preserve that information so that we can find
out what actually needs deactivating, just like we already do on
GICv3.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v2.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
index 74efacba38d42..5cfbe58983428 100644
--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -437,6 +437,12 @@ void vgic_v2_save_state(struct kvm_vcpu *vcpu)
 		return;
 
 	if (used_lrs) {
+		if (vcpu->arch.vgic_cpu.vgic_v2.vgic_hcr & GICH_HCR_LRENPIE) {
+			u32 val = readl_relaxed(base + GICH_HCR);
+
+			vcpu->arch.vgic_cpu.vgic_v2.vgic_hcr &= ~GICH_HCR_EOICOUNT;
+			vcpu->arch.vgic_cpu.vgic_v2.vgic_hcr |= val & GICH_HCR_EOICOUNT;
+		}
 		save_lrs(vcpu, base);
 		writel_relaxed(0, base + GICH_HCR);
 	}
-- 
2.47.3


