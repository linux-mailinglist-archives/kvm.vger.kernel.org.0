Return-Path: <kvm+bounces-49450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D3E8BAD920F
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 17:55:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D0890164EB3
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 15:54:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7073C1E3DCF;
	Fri, 13 Jun 2025 15:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TFb0YF9Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978C521FF35
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 15:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749829979; cv=none; b=RNlQIYe2wSlFWFt4OBcByUpVzL6x7FRgQSiGBR1vpYXumUATauEXRt+tRJFHpnRMEjbUDZoL2zMVar40zCxbPf/nyNYmxq9JwanK+knixQLHCn7bLbsuJSXUN70f2DFlBd/7ikeBbZVMDHdUszGVRAK1LIohXD+6mmyjKw2Vcio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749829979; c=relaxed/simple;
	bh=Lako0OAiwwW3qmvtQn9EFqpnvuUs1QbGAU5WOiOhGB8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bsxNUVyZMMTTu4/ncTeluBLV97piFvW+8M6TK/a2THoe2W9ftpVT/lv/oRs1RMW0/X/rQYENj+IDOZgUksFj385v/k6Yoy05pb8ffEtC4flUTBUEhCxaHRvFYfAHUcZfP//WZORwcLCZqefTb9Qxw1KeAhl/Kztv/CDRCp6w0v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TFb0YF9Y; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3ddafe52d04so59191425ab.1
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 08:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749829977; x=1750434777; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=R6oERwEX9ihIeJP2v6QxDWL9BHMEBqaouPjaqIFm6Iw=;
        b=TFb0YF9YeGY1sW/cBIJRUGAHTbP1v/NJ2LicpCKicQkH1KGbk2qhPB044hjt8/5m8Q
         buPO0Gxxvy8W1YD2Q9ujESFa09RfpbtaxaPW8yy3bk3gSlhv3Y/WYyAgIoLmWKOp0bbO
         +53v3UtCLBuILVoCwwdDXLnMBvk0IPyIffXKCQnCkDkPJuscK0VnVRYtyWwU/n1JqHKY
         CjlvgF6QtHf5X0V+GM0I2zQ6X6KrtNx9YtPy3xWYWBtSvz+2eCBLlWHwPWA3taZ2VOEQ
         jv0IqxhslLf44algDeiRLh3IDLa2/y4rN2Eieq6FjbttCTj8T7/pyPeEujyUsNtUEIm1
         dXOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749829977; x=1750434777;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R6oERwEX9ihIeJP2v6QxDWL9BHMEBqaouPjaqIFm6Iw=;
        b=tf0uhrktpVrlshFOSv/eTTym2GLU65B3xCw2j4mVMOmo1S292k0KYudKDjRElNAMs3
         MVyBCb8PkHNp06BDqpww/L3Dp7a0/3VV7C+ERZSfZie81Iq0gXuH7NWTOxNQYbid/HUw
         vdSHy3cxzdwKnW1uvDTnEj8CypulNBloyPW8cXWZblJlBn8J+l6dLUI1TepbzalNdAqW
         cLm+lCOHF4JPT3vPNwodbSPPn2ZJF/zfUarDCtd2xG7MtVM1BOQUI2r6T6yHYFK1chP4
         wjKqZl5XOkvnWZrv7ERb9PaW9TgL7areybQNGMZaTWpH+bYFEkN6/TxAUK669S7tAnbc
         XJdA==
X-Forwarded-Encrypted: i=1; AJvYcCVbO1PvjWu0isrnshRLLmz7A4La8rQjs/IVz3rVLT/0Vj+aCafJQ0mO2yfcrj6Xf8bBA4k=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEAxpbXzMeWAs9PhejRLHJGLLUntYCXDrtwPb7/RlHQFEeGNl1
	8DknrSIDu+cvBgMEq/1EdmKWFyMA/v4X2ai9gc3KLpRsbj5dBT1kDPWO67s1m4M6tWNlkfzDWpE
	Npuyys1xkew==
X-Google-Smtp-Source: AGHT+IHQ02cONRw6pm1YF1fpfHYYr8pmJ6vodarmPvsSB72Fz6jp9DIzeYQOuK2lpV+1OvcWdDYWazQgvwWV
X-Received: from iobbr11.prod.google.com ([2002:a05:6602:388b:b0:867:6d21:ab61])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6602:29a9:b0:864:4a1b:dfc5
 with SMTP id ca18e2360f4ac-875d3d2c717mr392436439f.9.1749829965739; Fri, 13
 Jun 2025 08:52:45 -0700 (PDT)
Date: Fri, 13 Jun 2025 15:52:37 +0000
In-Reply-To: <20250613155239.2029059-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250613155239.2029059-1-rananta@google.com>
X-Mailer: git-send-email 2.50.0.rc2.692.g299adb8693-goog
Message-ID: <20250613155239.2029059-4-rananta@google.com>
Subject: [PATCH v3 3/4] KVM: arm64: Introduce attribute to control GICD_TYPER2.nASSGIcap
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Raghavendra Rao Anata <rananta@google.com>, Mingwei Zhang <mizhang@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

KVM unconditionally advertises GICD_TYPER2.nASSGIcap (which internally
implies vSGIs) on GICv4.1 systems. Allow userspace to change whether a
VM supports the feature. Only allow changes prior to VGIC initialization
as at that point vPEs need to be allocated for the VM.

For convenience, bundle support for vLPIs and vSGIs behind this feature,
allowing userspace to control vPE allocation for VMs in environments
that may be constrained on vPE IDs.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 .../virt/kvm/devices/arm-vgic-v3.rst          | 29 +++++++++++++++
 arch/arm64/include/uapi/asm/kvm.h             |  3 ++
 arch/arm64/kvm/vgic/vgic-init.c               |  3 ++
 arch/arm64/kvm/vgic/vgic-kvm-device.c         | 37 +++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-mmio-v3.c            | 10 ++++-
 arch/arm64/kvm/vgic/vgic-v3.c                 |  5 ++-
 arch/arm64/kvm/vgic/vgic-v4.c                 |  2 +-
 include/kvm/arm_vgic.h                        |  3 ++
 8 files changed, 88 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v3.rst b/Documentation/virt/kvm/devices/arm-vgic-v3.rst
index e860498b1e35..049d77eae591 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v3.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v3.rst
@@ -306,3 +306,32 @@ Groups:
 
     The vINTID specifies which interrupt is generated when the vGIC
     must generate a maintenance interrupt. This must be a PPI.
+
+  KVM_DEV_ARM_VGIC_GRP_FEATURES
+   Attributes:
+
+    KVM_DEV_ARM_VGIC_FEATURE_nASSGIcap
+      Control whether support for SGIs without an active state is exposed
+      to the VM. attr->addr points to a __u8 value which indicates whether
+      he feature is enabled / disabled.
+
+      A value of 0 indicates that the feature is disabled. A nonzero value
+      indicates that the feature is enabled.
+
+      This attribute can only be set prior to initializing the VGIC (i.e.
+      KVM_DEV_ARM_VGIC_CTRL_INIT).
+
+      Support for SGIs without an active state depends on hardware support.
+      Userspace can discover support for the feature by reading the
+      attribute after creating a VGICv3. It is possible that
+      KVM_DEV_ARM_VGIC_CTRL_INIT can later fail if this feature is enabled
+      and KVM is unable to allocate GIC vPEs for the VM.
+
+  Errors:
+
+    =======  ========================================================
+    -ENXIO   Invalid attribute in attr->attr
+    -EFAULT  Invalid user address in attr->addr
+    -EBUSY   The VGIC has already been initialized
+    -EINVAL  KVM doesn't support the requested feature setting
+    =======  ========================================================
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index ed5f3892674c..41e9ce412afd 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -417,6 +417,7 @@ enum {
 #define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO  7
 #define KVM_DEV_ARM_VGIC_GRP_ITS_REGS 8
 #define KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ  9
+#define KVM_DEV_ARM_VGIC_GRP_FEATURES 10
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
 			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
@@ -429,6 +430,8 @@ enum {
 #define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
 #define   KVM_DEV_ARM_ITS_CTRL_RESET		4
 
+#define   KVM_DEV_ARM_VGIC_FEATURE_nASSGIcap	0
+
 /* Device Control API on vcpu fd */
 #define KVM_ARM_VCPU_PMU_V3_CTRL	0
 #define   KVM_ARM_VCPU_PMU_V3_IRQ		0
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 5e0e4559004b..944e24750ac4 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -157,6 +157,9 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 
 	kvm->arch.vgic.in_kernel = true;
 	kvm->arch.vgic.vgic_model = type;
+	if (type == KVM_DEV_TYPE_ARM_VGIC_V3)
+		kvm->arch.vgic.nassgicap = kvm_vgic_global_state.has_gicv4_1 &&
+					   gic_cpuif_has_vsgi();
 
 	kvm->arch.vgic.vgic_dist_base = VGIC_ADDR_UNDEF;
 
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index e28cf68a49c3..629f56063a13 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -626,6 +626,26 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
 		dev->kvm->arch.vgic.mi_intid = val;
 		return 0;
 	}
+	case KVM_DEV_ARM_VGIC_GRP_FEATURES: {
+		u8 __user *uaddr = (u8 __user *)attr->addr;
+		u8 val;
+
+		if (attr->attr != KVM_DEV_ARM_VGIC_FEATURE_nASSGIcap)
+			return -ENXIO;
+
+		if (get_user(val, uaddr))
+			return -EFAULT;
+
+		guard(mutex)(&dev->kvm->arch.config_lock);
+		if (vgic_initialized(dev->kvm))
+			return -EBUSY;
+
+		if (!(kvm_vgic_global_state.has_gicv4_1 && gic_cpuif_has_vsgi()) && val)
+			return -EINVAL;
+
+		dev->kvm->arch.vgic.nassgicap = val;
+		return 0;
+	}
 	default:
 		return vgic_set_common_attr(dev, attr);
 	}
@@ -646,6 +666,17 @@ static int vgic_v3_get_attr(struct kvm_device *dev,
 		guard(mutex)(&dev->kvm->arch.config_lock);
 		return put_user(dev->kvm->arch.vgic.mi_intid, uaddr);
 	}
+	case KVM_DEV_ARM_VGIC_GRP_FEATURES: {
+		u8 __user *uaddr = (u8 __user *)attr->addr;
+		u8 val;
+
+		if (attr->attr != KVM_DEV_ARM_VGIC_FEATURE_nASSGIcap)
+			return -ENXIO;
+
+		guard(mutex)(&dev->kvm->arch.config_lock);
+		val = dev->kvm->arch.vgic.nassgicap;
+		return put_user(val, uaddr);
+	}
 	default:
 		return vgic_get_common_attr(dev, attr);
 	}
@@ -683,8 +714,14 @@ static int vgic_v3_has_attr(struct kvm_device *dev,
 			return 0;
 		case KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES:
 			return 0;
+		default:
+			return -ENXIO;
 		}
+	case KVM_DEV_ARM_VGIC_GRP_FEATURES:
+		return attr->attr != KVM_DEV_ARM_VGIC_FEATURE_nASSGIcap ?
+		       -ENXIO : 0;
 	}
+
 	return -ENXIO;
 }
 
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 1a9c5b4418b2..43f59e70e1a2 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -50,12 +50,20 @@ bool vgic_has_its(struct kvm *kvm)
 
 bool vgic_supports_direct_msis(struct kvm *kvm)
 {
+	/*
+	 * Deliberately conflate vLPI and vSGI support on GICv4.1 hardware,
+	 * indirectly allowing userspace to control whether or not vPEs are
+	 * allocated for the VM.
+	 */
+	if (kvm_vgic_global_state.has_gicv4_1 && !vgic_supports_direct_sgis(kvm))
+		return false;
+
 	return kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm);
 }
 
 bool vgic_supports_direct_sgis(struct kvm *kvm)
 {
-	return kvm_vgic_global_state.has_gicv4_1 && gic_cpuif_has_vsgi();
+	return kvm->arch.vgic.nassgicap;
 }
 
 /*
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index b9ad7c42c5b0..cb6bda9b3c6c 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -404,7 +404,8 @@ int vgic_v3_save_pending_tables(struct kvm *kvm)
 	 * The above vgic initialized check also ensures that the allocation
 	 * and enabling of the doorbells have already been done.
 	 */
-	if (kvm_vgic_global_state.has_gicv4_1) {
+	if (kvm_vgic_global_state.has_gicv4_1 &&
+	    vgic_supports_direct_irqs(kvm)) {
 		unmap_all_vpes(kvm);
 		vlpi_avail = true;
 	}
@@ -581,7 +582,7 @@ int vgic_v3_map_resources(struct kvm *kvm)
 		return -EBUSY;
 	}
 
-	if (kvm_vgic_global_state.has_gicv4_1)
+	if (vgic_supports_direct_sgis(kvm))
 		vgic_v4_configure_vsgis(kvm);
 
 	return 0;
diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index e7e284d47a77..25e9da9e7a2d 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -245,7 +245,7 @@ int vgic_v4_init(struct kvm *kvm)
 
 	lockdep_assert_held(&kvm->arch.config_lock);
 
-	if (!kvm_vgic_global_state.has_gicv4)
+	if (!vgic_supports_direct_irqs(kvm))
 		return 0; /* Nothing to see here... move along. */
 
 	if (dist->its_vm.vpes)
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 4a34f7f0a864..1b4886f3fb20 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -264,6 +264,9 @@ struct vgic_dist {
 	/* distributor enabled */
 	bool			enabled;
 
+	/* Supports SGIs without active state */
+	bool			nassgicap;
+
 	/* Wants SGIs without active state */
 	bool			nassgireq;
 
-- 
2.50.0.rc2.692.g299adb8693-goog


