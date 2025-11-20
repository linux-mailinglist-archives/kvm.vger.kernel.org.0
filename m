Return-Path: <kvm+bounces-63917-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D5221C75B43
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:34:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A8EA7361DC5
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:28:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 732B23242D0;
	Thu, 20 Nov 2025 17:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T6noQmbj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889153751B5;
	Thu, 20 Nov 2025 17:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763659556; cv=none; b=WroxTprtbVXgNSeCpOHNoy51XRofXq0eaNVRGBEzAJUjevig4ly3bh3/ELoAE0pi9UnykIoY7mUzF39QoKyifOOGwWmRRWGq9rDF7xNyEiaoGPmhWq2qxKmYu1lmIr2/6GlXqN080XETTBvJLralizQyALKbHgfx60V9NJ6+hMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763659556; c=relaxed/simple;
	bh=IOHO43jIEbpZ6exgIFp7G66rSWGZrGpoQxbfZnY9qH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lurq1UOEirkc4PFokA+tvqjfCJTYfiFRBk0KQFpLhIOsMWwnptMm0EA9oH/qnSWb4ARrS1qoCEQe+1JeYnee/WfTKN0PsoUUwo0Ah9TB6xGLadaDC4FbLRk2hJPC338rMEPUfc87a3fEhXSN3jLrHMjgs6GVkKE5iXRqJJ+Ssvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T6noQmbj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35CA2C19421;
	Thu, 20 Nov 2025 17:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763659556;
	bh=IOHO43jIEbpZ6exgIFp7G66rSWGZrGpoQxbfZnY9qH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T6noQmbjh2ZSHgRNeHXmad4h7H1wCYx1kSyoQoVbVya7x+TBgCnweEjPNEvvM23tL
	 ACd4InInLMH/QCKhYsvDvyHP9N3xMu84VwQ/rLmtdwKUrnOpdhLGv8sSGnMWG+1gNp
	 RQSJbvfbixUBIzozs4E4riRwGJfAbX1lO7C3R0LSiV9WfD+HWs+iUb793VXBnTxl+6
	 /GnYVnQ0TUXta0xijqrm6JMR4Sg9voN8ntjvctC3pi8oJwvTBz24J+mbkUEeSI+Hwy
	 5QaKH9sxEbVoOAlNHcBOQKwcvpFoR8lGA94rV2Bd7gdhbLjcLwcX9Q11NNmttAwTP7
	 3pRsvWIm2UlgA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vM8Pq-00000006y6g-10ZB;
	Thu, 20 Nov 2025 17:25:54 +0000
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
Subject: [PATCH v4 02/49] irqchip/gic: Expose CPU interface VA to KVM
Date: Thu, 20 Nov 2025 17:24:52 +0000
Message-ID: <20251120172540.2267180-3-maz@kernel.org>
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

Future changes will require KVM to be able to perform deactivations
by writing to the physical CPU interface. Add the corresponding
VA to the kvm_info structure, and let KVM stash it.

Tested-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v2.c         | 1 +
 drivers/irqchip/irq-gic.c             | 3 +++
 include/kvm/arm_vgic.h                | 3 +++
 include/linux/irqchip/arm-vgic-info.h | 2 ++
 4 files changed, 9 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
index 381673f03c395..441efef80d609 100644
--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -385,6 +385,7 @@ int vgic_v2_probe(const struct gic_kvm_info *info)
 
 	kvm_vgic_global_state.can_emulate_gicv2 = true;
 	kvm_vgic_global_state.vcpu_base = info->vcpu.start;
+	kvm_vgic_global_state.gicc_base = info->gicc_base;
 	kvm_vgic_global_state.type = VGIC_V2;
 	kvm_vgic_global_state.max_gic_vcpus = VGIC_V2_MAX_CPUS;
 
diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 1269ab8eb726a..ec70c84e9f91d 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -1459,6 +1459,8 @@ static void __init gic_of_setup_kvm_info(struct device_node *node)
 	if (ret)
 		return;
 
+	gic_v2_kvm_info.gicc_base = gic_data[0].cpu_base.common_base;
+
 	if (static_branch_likely(&supports_deactivate_key))
 		vgic_set_kvm_info(&gic_v2_kvm_info);
 }
@@ -1620,6 +1622,7 @@ static void __init gic_acpi_setup_kvm_info(void)
 		return;
 
 	gic_v2_kvm_info.maint_irq = irq;
+	gic_v2_kvm_info.gicc_base = gic_data[0].cpu_base.common_base;
 
 	vgic_set_kvm_info(&gic_v2_kvm_info);
 }
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 7a0b972eb1b12..577723f5599bd 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -59,6 +59,9 @@ struct vgic_global {
 	/* virtual control interface mapping, HYP VA */
 	void __iomem		*vctrl_hyp;
 
+	/* Physical CPU interface, kernel VA */
+	void __iomem		*gicc_base;
+
 	/* Number of implemented list registers */
 	int			nr_lr;
 
diff --git a/include/linux/irqchip/arm-vgic-info.h b/include/linux/irqchip/arm-vgic-info.h
index a470a73a805aa..67d9d960273b9 100644
--- a/include/linux/irqchip/arm-vgic-info.h
+++ b/include/linux/irqchip/arm-vgic-info.h
@@ -24,6 +24,8 @@ struct gic_kvm_info {
 	enum gic_type	type;
 	/* Virtual CPU interface */
 	struct resource vcpu;
+	/* GICv2 GICC VA */
+	void __iomem	*gicc_base;
 	/* Interrupt number */
 	unsigned int	maint_irq;
 	/* No interrupt mask, no need to use the above field */
-- 
2.47.3


