Return-Path: <kvm+bounces-58641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AD934B9A185
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 15:45:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6E6FE324E6E
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 13:45:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B090B30595A;
	Wed, 24 Sep 2025 13:45:27 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A43C1DE2A5
	for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 13:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758721527; cv=none; b=PkMmSKZ7gvM6Fh8B5xGdb4r+xDsM37vwKf12silcwfTVNSaqUGdFnKDrCplgZmBL7EhTnaI2qBQQ8kgOITyv7VkX8B0bQm/jZdkruuaz4qsPeoFQIIk7Br1YbiPZsO95j8TCyAUIsnjbbjJxDGNWRTGMJB/NRo11DBk059xVgKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758721527; c=relaxed/simple;
	bh=9pUk0NZLaa5y9fPVHJkmua2ydiwGI3xDIt2tXJf9hOs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WANLP/UBroYBglSbFDdsRui63s8H8wdX+HIOszxHAXK7VPQb7zjgraePZNFMrIvBLfVisw/Hf6AHiRoQgWH9MUKljYCxPiI3pasHVyquhuqqm3iq9X2MvhBx4qO+5plGJ0C1ah9+p72BPcdRA3fwNv3WhldsSOg9yUmLBPuQkIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BDBB41CE2;
	Wed, 24 Sep 2025 06:45:16 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.manchester.arm.com [10.33.8.67])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E57CB3F5A1;
	Wed, 24 Sep 2025 06:45:23 -0700 (PDT)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH kvmtool v4 3/7] arm64: nested: Add support for setting maintenance IRQ
Date: Wed, 24 Sep 2025 14:45:07 +0100
Message-Id: <20250924134511.4109935-4-andre.przywara@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250924134511.4109935-1-andre.przywara@arm.com>
References: <20250924134511.4109935-1-andre.przywara@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Uses the new VGIC KVM device attribute to set the maintenance IRQ.
This is fixed to use PPI 9, as a platform decision made by kvmtool,
matching the SBSA recommendation.
Use the opportunity to pass the kvm pointer to gic__generate_fdt_nodes(),
as this simplifies the call and allows us access to the nested_virt on
the way.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm64/arm-cpu.c         |  2 +-
 arm64/gic.c             | 26 ++++++++++++++++++++++++--
 arm64/include/kvm/gic.h |  2 +-
 3 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/arm64/arm-cpu.c b/arm64/arm-cpu.c
index 69bb2cb2c..0843ac051 100644
--- a/arm64/arm-cpu.c
+++ b/arm64/arm-cpu.c
@@ -14,7 +14,7 @@ static void generate_fdt_nodes(void *fdt, struct kvm *kvm)
 {
 	int timer_interrupts[4] = {13, 14, 11, 10};
 
-	gic__generate_fdt_nodes(fdt, kvm->cfg.arch.irqchip);
+	gic__generate_fdt_nodes(fdt, kvm);
 	timer__generate_fdt_nodes(fdt, kvm, timer_interrupts);
 	pmu__generate_fdt_nodes(fdt, kvm);
 }
diff --git a/arm64/gic.c b/arm64/gic.c
index b0d3a1abb..e35986c06 100644
--- a/arm64/gic.c
+++ b/arm64/gic.c
@@ -11,6 +11,8 @@
 
 #define IRQCHIP_GIC 0
 
+#define GIC_MAINT_IRQ	9
+
 static int gic_fd = -1;
 static u64 gic_redists_base;
 static u64 gic_redists_size;
@@ -302,10 +304,15 @@ static int gic__init_gic(struct kvm *kvm)
 
 	int lines = irq__get_nr_allocated_lines();
 	u32 nr_irqs = ALIGN(lines, 32) + GIC_SPI_IRQ_BASE;
+	u32 maint_irq = GIC_PPI_IRQ_BASE + GIC_MAINT_IRQ;
 	struct kvm_device_attr nr_irqs_attr = {
 		.group	= KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
 		.addr	= (u64)(unsigned long)&nr_irqs,
 	};
+	struct kvm_device_attr maint_irq_attr = {
+		.group	= KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ,
+		.addr	= (u64)(unsigned long)&maint_irq,
+	};
 	struct kvm_device_attr vgic_init_attr = {
 		.group	= KVM_DEV_ARM_VGIC_GRP_CTRL,
 		.attr	= KVM_DEV_ARM_VGIC_CTRL_INIT,
@@ -325,6 +332,13 @@ static int gic__init_gic(struct kvm *kvm)
 			return ret;
 	}
 
+	if (kvm->cfg.arch.nested_virt &&
+	    !ioctl(gic_fd, KVM_HAS_DEVICE_ATTR, &maint_irq_attr)) {
+		ret = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &maint_irq_attr);
+		if (ret)
+			return ret;
+	}
+
 	irq__routing_init(kvm);
 
 	if (!ioctl(gic_fd, KVM_HAS_DEVICE_ATTR, &vgic_init_attr)) {
@@ -342,7 +356,7 @@ static int gic__init_gic(struct kvm *kvm)
 }
 late_init(gic__init_gic)
 
-void gic__generate_fdt_nodes(void *fdt, enum irqchip_type type)
+void gic__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 {
 	const char *compatible, *msi_compatible = NULL;
 	u64 msi_prop[2];
@@ -350,8 +364,12 @@ void gic__generate_fdt_nodes(void *fdt, enum irqchip_type type)
 		cpu_to_fdt64(ARM_GIC_DIST_BASE), cpu_to_fdt64(ARM_GIC_DIST_SIZE),
 		0, 0,				/* to be filled */
 	};
+	u32 maint_irq[] = {
+		cpu_to_fdt32(GIC_FDT_IRQ_TYPE_PPI), cpu_to_fdt32(GIC_MAINT_IRQ),
+		gic__get_fdt_irq_cpumask(kvm) | IRQ_TYPE_LEVEL_HIGH
+	};
 
-	switch (type) {
+	switch (kvm->cfg.arch.irqchip) {
 	case IRQCHIP_GICV2M:
 		msi_compatible = "arm,gic-v2m-frame";
 		/* fall-through */
@@ -377,6 +395,10 @@ void gic__generate_fdt_nodes(void *fdt, enum irqchip_type type)
 	_FDT(fdt_property_cell(fdt, "#interrupt-cells", GIC_FDT_IRQ_NUM_CELLS));
 	_FDT(fdt_property(fdt, "interrupt-controller", NULL, 0));
 	_FDT(fdt_property(fdt, "reg", reg_prop, sizeof(reg_prop)));
+	if (kvm->cfg.arch.nested_virt) {
+		_FDT(fdt_property(fdt, "interrupts", maint_irq,
+				  sizeof(maint_irq)));
+	}
 	_FDT(fdt_property_cell(fdt, "phandle", PHANDLE_GIC));
 	_FDT(fdt_property_cell(fdt, "#address-cells", 2));
 	_FDT(fdt_property_cell(fdt, "#size-cells", 2));
diff --git a/arm64/include/kvm/gic.h b/arm64/include/kvm/gic.h
index ad8bcbf21..8490cca60 100644
--- a/arm64/include/kvm/gic.h
+++ b/arm64/include/kvm/gic.h
@@ -36,7 +36,7 @@ struct kvm;
 int gic__alloc_irqnum(void);
 int gic__create(struct kvm *kvm, enum irqchip_type type);
 int gic__create_gicv2m_frame(struct kvm *kvm, u64 msi_frame_addr);
-void gic__generate_fdt_nodes(void *fdt, enum irqchip_type type);
+void gic__generate_fdt_nodes(void *fdt, struct kvm *kvm);
 u32 gic__get_fdt_irq_cpumask(struct kvm *kvm);
 
 int gic__add_irqfd(struct kvm *kvm, unsigned int gsi, int trigger_fd,
-- 
2.25.1


