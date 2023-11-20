Return-Path: <kvm+bounces-2103-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DAB77F1415
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 14:14:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EAA76B218BE
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 13:14:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11019208DF;
	Mon, 20 Nov 2023 13:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sD+R8KgA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925351F933;
	Mon, 20 Nov 2023 13:10:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE56C433C9;
	Mon, 20 Nov 2023 13:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700485859;
	bh=8ctKsk9L4ScfcppD+bZ1xcTjVk3VbyIGuTga2jLbA5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sD+R8KgAjwONT/Wu1GetZn8gVwSLSUFMTuvZcpbxeqESM/H4GlPWMIJNl/K0/LNiY
	 QI9lRyqs7ygcin0FbKCWtBGUR8brJ/2L/2sCEeW4p5FbwoBBTGNSN5tKXYrRCRltb0
	 wJb9A8UKRJNDaO+b/vCiDb0+QRbiUGDG3oGfPRsz1DxPGq0muZx/M22miIck65cNEA
	 WfOAUCFRk8AEMCvnbDoGvWBqr4Tj4Q3zq1eoRguOlZMOACZcjHSFenYVDtX0MTzp5w
	 /nXxyrRL6HcRV8SphMZZ0wCWLzfC36MSfDytw48cV1JaXKangfaArC11SQLfl0wJgu
	 t2H0odFqo5R9w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r543F-00EjnU-At;
	Mon, 20 Nov 2023 13:10:57 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Darren Hart <darren@os.amperecomputing.com>,
	Jintack Lim <jintack@cs.columbia.edu>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Miguel Luis <miguel.luis@oracle.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v11 32/43] KVM: arm64: nv: vgic: Allow userland to set VGIC maintenance IRQ
Date: Mon, 20 Nov 2023 13:10:16 +0000
Message-Id: <20231120131027.854038-33-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231120131027.854038-1-maz@kernel.org>
References: <20231120131027.854038-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

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
 tools/arch/arm/include/uapi/asm/kvm.h         |  1 +
 4 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v3.rst b/Documentation/virt/kvm/devices/arm-vgic-v3.rst
index 5817edb4e046..e860498b1e35 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v3.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v3.rst
@@ -291,8 +291,18 @@ Groups:
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
index 89d2fc872d9f..4e0ab0e84ca9 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -403,6 +403,7 @@ enum {
 #define KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS 6
 #define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO  7
 #define KVM_DEV_ARM_VGIC_GRP_ITS_REGS 8
+#define KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ  9
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
 			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index f48b8dab8b3d..1cefcaadd479 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -298,6 +298,12 @@ static int vgic_get_common_attr(struct kvm_device *dev,
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
@@ -512,7 +518,7 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 	struct vgic_reg_attr reg_attr;
 	gpa_t addr;
 	struct kvm_vcpu *vcpu;
-	bool uaccess;
+	bool uaccess, post_init = true;
 	u32 val;
 	int ret;
 
@@ -528,6 +534,9 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 		/* Sysregs uaccess is performed by the sysreg handling code */
 		uaccess = false;
 		break;
+	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ:
+		post_init = false;
+		fallthrough;
 	default:
 		uaccess = true;
 	}
@@ -547,7 +556,7 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 
 	mutex_lock(&dev->kvm->arch.config_lock);
 
-	if (unlikely(!vgic_initialized(dev->kvm))) {
+	if (post_init != vgic_initialized(dev->kvm)) {
 		ret = -EBUSY;
 		goto out;
 	}
@@ -577,6 +586,19 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
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
@@ -603,6 +625,7 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
 	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
 	case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO:
+	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ:
 		return vgic_v3_attr_regs_access(dev, attr, true);
 	default:
 		return vgic_set_common_attr(dev, attr);
@@ -617,6 +640,7 @@ static int vgic_v3_get_attr(struct kvm_device *dev,
 	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
 	case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO:
+	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ:
 		return vgic_v3_attr_regs_access(dev, attr, false);
 	default:
 		return vgic_get_common_attr(dev, attr);
@@ -640,6 +664,7 @@ static int vgic_v3_has_attr(struct kvm_device *dev,
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
 		return vgic_v3_has_attr_regs(dev, attr);
 	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
+	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ:
 		return 0;
 	case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO: {
 		if (((attr->attr & KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK) >>
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
2.39.2


