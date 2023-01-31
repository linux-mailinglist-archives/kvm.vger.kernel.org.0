Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2F54682931
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 10:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbjAaJm1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 04:42:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232255AbjAaJmZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 04:42:25 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC65366A2
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 01:41:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 55643CE1CCA
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 09:41:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A5D0C433D2;
        Tue, 31 Jan 2023 09:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675158104;
        bh=NQLd+kx2LypSnl9dYhw+RFVUBmaP9stvi5I5iXIIKUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UUjSto7JkCOi6T85SzTiaOjWe2d/JMgCVe647t0KCMo6VEIz6NUt4kbsvFRQXm1UI
         su7aU1rkqm2UnMGFY8BdByZElYjC+qfgTbtLCNrx+FMmspjP6e20ygOBooAEosmGW3
         KDgThZlDH/sz4EWcVHuJatEmCLLH+CNnJKl+8DrUezAPCnKTljGT6YUkwWdggfVDt4
         6SDp6JYsfaekJhQCokt2zEBJsd0AkKEanP5yffBhnGFp/xd16snbp2+PPsdUEmoilE
         UGF7SA9f4WKQz6W9fjrDdZBRysK3EZ4sWZfmjgWVOqP0hm0WzOiojSUIHYRedR4+JQ
         UnrRRj5vwjtWg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pMmts-0067U2-Cp;
        Tue, 31 Jan 2023 09:26:00 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v8 50/69] KVM: arm64: nv: vgic: Allow userland to set VGIC maintenance IRQ
Date:   Tue, 31 Jan 2023 09:24:45 +0000
Message-Id: <20230131092504.2880505-51-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230131092504.2880505-1-maz@kernel.org>
References: <20230131092504.2880505-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Andre Przywara <andre.przywara@arm.com>

The VGIC maintenance IRQ signals various conditions about the LRs, when
the GIC's virtualization extension is used.
So far we didn't need it, but nested virtualization needs to know about
this interrupt, so add a userland interface to setup the IRQ number.
The architecture mandates that it must be a PPI, on top of that this code
only exports a per-device option, so the PPI is the same on all VCPUs.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
[added some bits of documentation]
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 .../virt/kvm/devices/arm-vgic-v3.rst          | 12 +++++++-
 arch/arm64/include/uapi/asm/kvm.h             |  1 +
 arch/arm64/kvm/vgic/vgic-kvm-device.c         | 29 +++++++++++++++++--
 include/kvm/arm_vgic.h                        |  3 ++
 tools/arch/arm/include/uapi/asm/kvm.h         |  1 +
 5 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v3.rst b/Documentation/virt/kvm/devices/arm-vgic-v3.rst
index 51e5e5762571..1901e651cc00 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v3.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v3.rst
@@ -284,8 +284,18 @@ Groups:
       |    Aff3    |    Aff2    |    Aff1    |    Aff0    |
 
   Errors:
-
     =======  =============================================
     -EINVAL  vINTID is not multiple of 32 or info field is
 	     not VGIC_LEVEL_INFO_LINE_LEVEL
     =======  =============================================
+
+  KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ
+   Attributes:
+
+    The attr field of kvm_device_attr encodes the following values:
+
+      bits:     | 31   ....    5 | 4  ....  0 |
+      values:   |      RES0      |   vINTID   |
+
+    The vINTID specifies which interrupt is generated when the vGIC
+    must generate a maintenance interrupt. This must be a PPI.
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index f8129c624b07..8bf7b1a62e23 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -390,6 +390,7 @@ enum {
 #define KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS 6
 #define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO  7
 #define KVM_DEV_ARM_VGIC_GRP_ITS_REGS 8
+#define KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ  9
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
 			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index edeac2380591..0cc40b492ee1 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -288,6 +288,12 @@ static int vgic_get_common_attr(struct kvm_device *dev,
 			     VGIC_NR_PRIVATE_IRQS, uaddr);
 		break;
 	}
+	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ: {
+		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
+
+		r = put_user(dev->kvm->arch.vgic.maint_irq, uaddr);
+		break;
+	}
 	}
 
 	return r;
@@ -541,7 +547,7 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 	struct vgic_reg_attr reg_attr;
 	gpa_t addr;
 	struct kvm_vcpu *vcpu;
-	bool uaccess;
+	bool uaccess, post_init = true;
 	u32 val;
 	int ret;
 
@@ -557,6 +563,9 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 		/* Sysregs uaccess is performed by the sysreg handling code */
 		uaccess = false;
 		break;
+	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ:
+		post_init = false;
+		fallthrough;
 	default:
 		uaccess = true;
 	}
@@ -569,7 +578,7 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 
 	mutex_lock(&dev->kvm->lock);
 
-	if (unlikely(!vgic_initialized(dev->kvm))) {
+	if (post_init != vgic_initialized(dev->kvm)) {
 		ret = -EBUSY;
 		goto out;
 	}
@@ -604,6 +613,19 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 		}
 		break;
 	}
+	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ:
+		if (!is_write) {
+			val = dev->kvm->arch.vgic.maint_irq;
+			ret = 0;
+			break;
+		}
+
+		ret = -EINVAL;
+		if ((val < VGIC_NR_PRIVATE_IRQS) && (val >= VGIC_NR_SGIS)) {
+			dev->kvm->arch.vgic.maint_irq = val;
+			ret = 0;
+		}
+		break;
 	default:
 		ret = -EINVAL;
 		break;
@@ -629,6 +651,7 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
 	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
 	case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO:
+	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ:
 		return vgic_v3_attr_regs_access(dev, attr, true);
 	default:
 		return vgic_set_common_attr(dev, attr);
@@ -643,6 +666,7 @@ static int vgic_v3_get_attr(struct kvm_device *dev,
 	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
 	case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO:
+	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ:
 		return vgic_v3_attr_regs_access(dev, attr, false);
 	default:
 		return vgic_get_common_attr(dev, attr);
@@ -666,6 +690,7 @@ static int vgic_v3_has_attr(struct kvm_device *dev,
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
 		return vgic_v3_has_attr_regs(dev, attr);
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
+	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ:
 		return 0;
 	case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO: {
 		if (((attr->attr & KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK) >>
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index a466cda3a739..38643d9b3813 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -243,6 +243,9 @@ struct vgic_dist {
 
 	int			nr_spis;
 
+	/* The GIC maintenance IRQ for nested hypervisors. */
+	u32			maint_irq;
+
 	/* base addresses in guest physical address space: */
 	gpa_t			vgic_dist_base;		/* distributor */
 	union {
diff --git a/tools/arch/arm/include/uapi/asm/kvm.h b/tools/arch/arm/include/uapi/asm/kvm.h
index 03cd7c19a683..d5dd96902817 100644
--- a/tools/arch/arm/include/uapi/asm/kvm.h
+++ b/tools/arch/arm/include/uapi/asm/kvm.h
@@ -246,6 +246,7 @@ struct kvm_vcpu_events {
 #define KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS 6
 #define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO  7
 #define KVM_DEV_ARM_VGIC_GRP_ITS_REGS	8
+#define KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ	9
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
 			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
-- 
2.34.1

