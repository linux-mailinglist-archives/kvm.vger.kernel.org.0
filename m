Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 309ECADA5F
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2019 15:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404932AbfIINta (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Sep 2019 09:49:30 -0400
Received: from foss.arm.com ([217.140.110.172]:50782 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404916AbfIINta (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Sep 2019 09:49:30 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9B93E1BB0;
        Mon,  9 Sep 2019 06:49:29 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 471783F59C;
        Mon,  9 Sep 2019 06:49:27 -0700 (PDT)
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 15/17] KVM: arm/arm64: vgic: Use a single IO device per redistributor
Date:   Mon,  9 Sep 2019 14:48:05 +0100
Message-Id: <20190909134807.27978-16-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190909134807.27978-1-maz@kernel.org>
References: <20190909134807.27978-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Auger <eric.auger@redhat.com>

At the moment we use 2 IO devices per GICv3 redistributor: one
one for the RD_base frame and one for the SGI_base frame.

Instead we can use a single IO device per redistributor (the 2
frames are contiguous). This saves slots on the KVM_MMIO_BUS
which is currently limited to NR_IOBUS_DEVS (1000).

This change allows to instantiate up to 512 redistributors and may
speed the guest boot with a large number of VCPUs.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 include/kvm/arm_vgic.h           |  1 -
 virt/kvm/arm/vgic/vgic-init.c    |  1 -
 virt/kvm/arm/vgic/vgic-mmio-v3.c | 81 ++++++++++----------------------
 3 files changed, 24 insertions(+), 59 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index ded50a30e2d5..af4f09c02bf1 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -314,7 +314,6 @@ struct vgic_cpu {
 	 * parts of the redistributor.
 	 */
 	struct vgic_io_device	rd_iodev;
-	struct vgic_io_device	sgi_iodev;
 	struct vgic_redist_region *rdreg;
 
 	/* Contains the attributes and gpa of the LPI pending tables. */
diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 9175bfd83263..958e2f0d2207 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -193,7 +193,6 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
 	int i;
 
 	vgic_cpu->rd_iodev.base_addr = VGIC_ADDR_UNDEF;
-	vgic_cpu->sgi_iodev.base_addr = VGIC_ADDR_UNDEF;
 
 	INIT_LIST_HEAD(&vgic_cpu->ap_list_head);
 	raw_spin_lock_init(&vgic_cpu->ap_list_lock);
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index fdcfb7ae4491..7dfd15dbb308 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -517,7 +517,8 @@ static const struct vgic_register_region vgic_v3_dist_registers[] = {
 		VGIC_ACCESS_32bit),
 };
 
-static const struct vgic_register_region vgic_v3_rdbase_registers[] = {
+static const struct vgic_register_region vgic_v3_rd_registers[] = {
+	/* RD_base registers */
 	REGISTER_DESC_WITH_LENGTH(GICR_CTLR,
 		vgic_mmio_read_v3r_ctlr, vgic_mmio_write_v3r_ctlr, 4,
 		VGIC_ACCESS_32bit),
@@ -542,44 +543,42 @@ static const struct vgic_register_region vgic_v3_rdbase_registers[] = {
 	REGISTER_DESC_WITH_LENGTH(GICR_IDREGS,
 		vgic_mmio_read_v3_idregs, vgic_mmio_write_wi, 48,
 		VGIC_ACCESS_32bit),
-};
-
-static const struct vgic_register_region vgic_v3_sgibase_registers[] = {
-	REGISTER_DESC_WITH_LENGTH(GICR_IGROUPR0,
+	/* SGI_base registers */
+	REGISTER_DESC_WITH_LENGTH(SZ_64K + GICR_IGROUPR0,
 		vgic_mmio_read_group, vgic_mmio_write_group, 4,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICR_ISENABLER0,
+	REGISTER_DESC_WITH_LENGTH(SZ_64K + GICR_ISENABLER0,
 		vgic_mmio_read_enable, vgic_mmio_write_senable, 4,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICR_ICENABLER0,
+	REGISTER_DESC_WITH_LENGTH(SZ_64K + GICR_ICENABLER0,
 		vgic_mmio_read_enable, vgic_mmio_write_cenable, 4,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH_UACCESS(GICR_ISPENDR0,
+	REGISTER_DESC_WITH_LENGTH_UACCESS(SZ_64K + GICR_ISPENDR0,
 		vgic_mmio_read_pending, vgic_mmio_write_spending,
 		vgic_v3_uaccess_read_pending, vgic_v3_uaccess_write_pending, 4,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH_UACCESS(GICR_ICPENDR0,
+	REGISTER_DESC_WITH_LENGTH_UACCESS(SZ_64K + GICR_ICPENDR0,
 		vgic_mmio_read_pending, vgic_mmio_write_cpending,
 		vgic_mmio_read_raz, vgic_mmio_uaccess_write_wi, 4,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH_UACCESS(GICR_ISACTIVER0,
+	REGISTER_DESC_WITH_LENGTH_UACCESS(SZ_64K + GICR_ISACTIVER0,
 		vgic_mmio_read_active, vgic_mmio_write_sactive,
 		NULL, vgic_mmio_uaccess_write_sactive,
 		4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH_UACCESS(GICR_ICACTIVER0,
+	REGISTER_DESC_WITH_LENGTH_UACCESS(SZ_64K + GICR_ICACTIVER0,
 		vgic_mmio_read_active, vgic_mmio_write_cactive,
 		NULL, vgic_mmio_uaccess_write_cactive,
 		4, VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICR_IPRIORITYR0,
+	REGISTER_DESC_WITH_LENGTH(SZ_64K + GICR_IPRIORITYR0,
 		vgic_mmio_read_priority, vgic_mmio_write_priority, 32,
 		VGIC_ACCESS_32bit | VGIC_ACCESS_8bit),
-	REGISTER_DESC_WITH_LENGTH(GICR_ICFGR0,
+	REGISTER_DESC_WITH_LENGTH(SZ_64K + GICR_ICFGR0,
 		vgic_mmio_read_config, vgic_mmio_write_config, 8,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICR_IGRPMODR0,
+	REGISTER_DESC_WITH_LENGTH(SZ_64K + GICR_IGRPMODR0,
 		vgic_mmio_read_raz, vgic_mmio_write_wi, 4,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICR_NSACR,
+	REGISTER_DESC_WITH_LENGTH(SZ_64K + GICR_NSACR,
 		vgic_mmio_read_raz, vgic_mmio_write_wi, 4,
 		VGIC_ACCESS_32bit),
 };
@@ -609,9 +608,8 @@ int vgic_register_redist_iodev(struct kvm_vcpu *vcpu)
 	struct vgic_dist *vgic = &kvm->arch.vgic;
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	struct vgic_io_device *rd_dev = &vcpu->arch.vgic_cpu.rd_iodev;
-	struct vgic_io_device *sgi_dev = &vcpu->arch.vgic_cpu.sgi_iodev;
 	struct vgic_redist_region *rdreg;
-	gpa_t rd_base, sgi_base;
+	gpa_t rd_base;
 	int ret;
 
 	if (!IS_VGIC_ADDR_UNDEF(vgic_cpu->rd_iodev.base_addr))
@@ -633,52 +631,31 @@ int vgic_register_redist_iodev(struct kvm_vcpu *vcpu)
 	vgic_cpu->rdreg = rdreg;
 
 	rd_base = rdreg->base + rdreg->free_index * KVM_VGIC_V3_REDIST_SIZE;
-	sgi_base = rd_base + SZ_64K;
 
 	kvm_iodevice_init(&rd_dev->dev, &kvm_io_gic_ops);
 	rd_dev->base_addr = rd_base;
 	rd_dev->iodev_type = IODEV_REDIST;
-	rd_dev->regions = vgic_v3_rdbase_registers;
-	rd_dev->nr_regions = ARRAY_SIZE(vgic_v3_rdbase_registers);
+	rd_dev->regions = vgic_v3_rd_registers;
+	rd_dev->nr_regions = ARRAY_SIZE(vgic_v3_rd_registers);
 	rd_dev->redist_vcpu = vcpu;
 
 	mutex_lock(&kvm->slots_lock);
 	ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, rd_base,
-				      SZ_64K, &rd_dev->dev);
+				      2 * SZ_64K, &rd_dev->dev);
 	mutex_unlock(&kvm->slots_lock);
 
 	if (ret)
 		return ret;
 
-	kvm_iodevice_init(&sgi_dev->dev, &kvm_io_gic_ops);
-	sgi_dev->base_addr = sgi_base;
-	sgi_dev->iodev_type = IODEV_REDIST;
-	sgi_dev->regions = vgic_v3_sgibase_registers;
-	sgi_dev->nr_regions = ARRAY_SIZE(vgic_v3_sgibase_registers);
-	sgi_dev->redist_vcpu = vcpu;
-
-	mutex_lock(&kvm->slots_lock);
-	ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, sgi_base,
-				      SZ_64K, &sgi_dev->dev);
-	if (ret) {
-		kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS,
-					  &rd_dev->dev);
-		goto out;
-	}
-
 	rdreg->free_index++;
-out:
-	mutex_unlock(&kvm->slots_lock);
-	return ret;
+	return 0;
 }
 
 static void vgic_unregister_redist_iodev(struct kvm_vcpu *vcpu)
 {
 	struct vgic_io_device *rd_dev = &vcpu->arch.vgic_cpu.rd_iodev;
-	struct vgic_io_device *sgi_dev = &vcpu->arch.vgic_cpu.sgi_iodev;
 
 	kvm_io_bus_unregister_dev(vcpu->kvm, KVM_MMIO_BUS, &rd_dev->dev);
-	kvm_io_bus_unregister_dev(vcpu->kvm, KVM_MMIO_BUS, &sgi_dev->dev);
 }
 
 static int vgic_register_all_redist_iodevs(struct kvm *kvm)
@@ -828,8 +805,8 @@ int vgic_v3_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
 		iodev.base_addr = 0;
 		break;
 	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:{
-		iodev.regions = vgic_v3_rdbase_registers;
-		iodev.nr_regions = ARRAY_SIZE(vgic_v3_rdbase_registers);
+		iodev.regions = vgic_v3_rd_registers;
+		iodev.nr_regions = ARRAY_SIZE(vgic_v3_rd_registers);
 		iodev.base_addr = 0;
 		break;
 	}
@@ -987,21 +964,11 @@ int vgic_v3_redist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 			   int offset, u32 *val)
 {
 	struct vgic_io_device rd_dev = {
-		.regions = vgic_v3_rdbase_registers,
-		.nr_regions = ARRAY_SIZE(vgic_v3_rdbase_registers),
+		.regions = vgic_v3_rd_registers,
+		.nr_regions = ARRAY_SIZE(vgic_v3_rd_registers),
 	};
 
-	struct vgic_io_device sgi_dev = {
-		.regions = vgic_v3_sgibase_registers,
-		.nr_regions = ARRAY_SIZE(vgic_v3_sgibase_registers),
-	};
-
-	/* SGI_base is the next 64K frame after RD_base */
-	if (offset >= SZ_64K)
-		return vgic_uaccess(vcpu, &sgi_dev, is_write, offset - SZ_64K,
-				    val);
-	else
-		return vgic_uaccess(vcpu, &rd_dev, is_write, offset, val);
+	return vgic_uaccess(vcpu, &rd_dev, is_write, offset, val);
 }
 
 int vgic_v3_line_level_info_uaccess(struct kvm_vcpu *vcpu, bool is_write,
-- 
2.20.1

