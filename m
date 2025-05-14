Return-Path: <kvm+bounces-46538-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EE10CAB75BD
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 21:22:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9B2191BA6143
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 19:22:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D25929372F;
	Wed, 14 May 2025 19:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UYNIA72q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4346028DB6E
	for <kvm@vger.kernel.org>; Wed, 14 May 2025 19:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747250529; cv=none; b=gWYvrdTf3SAjvG+Ai8kx6UrE4oU53CIG6TLE+jCn09rC1qL/Q+MAuQenec0/b3cdII1JX4EdXD7wdPfOQu9iUVTz9Bd3BynBnmIu1jBS7AzeHuPWUvPK6PVmOiNm56jiC1KAFwgB303LIAI8n5tgtWwsJ28VctfBDGjoyJ/bIig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747250529; c=relaxed/simple;
	bh=lOdxofayiKe/1Vjymgyk3XUfVBPe4mBc2wD0vdOwXzo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SuaQCaFMIfdjIWjoOk5Fprj1SlhXJe5IMk852ws8EmJcmzEuSq7K+gVHkLDh4w/aIgWCraa14LTngwtix6A96jFscSvw0Jx+sPXSd6lNs5pY83+nssBN6vW2v/Uy1IbKnUqa/6gdDPrlvqGCW8isPE7ENu+JB8lU9FY5MLBZZYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UYNIA72q; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-85b5878a66cso21055539f.2
        for <kvm@vger.kernel.org>; Wed, 14 May 2025 12:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747250526; x=1747855326; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=W3MauCW+urlix1RrycVNh0XN4aZXJqzxAZQYVw1ClTM=;
        b=UYNIA72qzxec5Ea+tNSxB2J0VRMAv24bTO35xidFweojbC8XBFbWOszN7CSx08Z6U4
         NW7yp3WfesmtB5bdx+L808KRYayxSUL8EFLi90lWRgWPztL1PlLvBIuzvZBCxCfMU1D5
         9hlRgx72r8ceSxvOUpZ8ADdy13vNxdoKMz0TiMJxKaGAeT4YDLNnctqKYhCBMbzSOR4u
         oCjBt2gECDd7JsrcSDf0xGFFrEM9yOpJvyfPinSqnCjNZhAN+oZbIJrvpPHvhLCXWfP1
         XVUirwY0ZFwlgiKXUaJfApr7iEFWrOCJeZzsNDhwDRUWUmroEhdCCPI1I57ADAsR5oiB
         7wlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747250526; x=1747855326;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W3MauCW+urlix1RrycVNh0XN4aZXJqzxAZQYVw1ClTM=;
        b=Xj5VIfM1y8bkO4L00G+xcwbhtnhlNKG0tHlsUG3tq5cBdVYX7GdzVZT1kV3Jj3zFZA
         SQ/Q9S2GkQ8NqpicrrF41GNMvkNegTUlYML5FDNR/BP1xRdRxk0P/R0jwZHmOyq6aYu+
         UNu7DhJl8v5OuAmeJ8YE+HlCHPB7zAE/1XhPzHfvqtH6jWAAbKYHqaPpHSY1pJxSyIG6
         PSY7RQeBThW5qE5kx3i9l+DYSReaR9V+VRN8u8QjxuePmfEQCxu1cOZCxFP7zhpFGaGY
         8PCi1o6x1KkLK6K2LE5sQlv7gvx/wzhET8+ml4P5EzsxCXczRRJFE9YFvhiNa4rnNhcn
         XehA==
X-Forwarded-Encrypted: i=1; AJvYcCWVP2hc+wApuCnFdgUOibsCx+iPPyuv7x91A+M/A1eukU8JWQh0/f11A+HoDfuvRjgm8Yk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQMSOCHlG/q+A8OF1y1W4FZJ5MOScZVBBXOcHq8dhtpIy4gC+j
	qTxxH2dn75/V8UBiTGhKzRxxBQCTSwqRvzsVucphQmTFTSojCoOPt4fnfHRY8kBPwNwg1Hkp+9p
	09bvzRw==
X-Google-Smtp-Source: AGHT+IEy09eku3jD263yCQYKQ2rr3/0cu+Cf3UzUC6jmBnOz4zk6Mpi7GLuEdzeaZ4KU1bn0EY+ScGzWk8y2
X-Received: from ilsx3.prod.google.com ([2002:a05:6e02:743:b0:3d9:367f:729a])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6e02:3784:b0:3d9:5d50:e3b1
 with SMTP id e9e14a558f8ab-3db6f7f1597mr60756865ab.18.1747250526441; Wed, 14
 May 2025 12:22:06 -0700 (PDT)
Date: Wed, 14 May 2025 19:21:57 +0000
In-Reply-To: <20250514192159.1751538-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250514192159.1751538-1-rananta@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250514192159.1751538-2-rananta@google.com>
Subject: [PATCH 1/3] kvm: arm64: Add support for KVM_DEV_ARM_VGIC_CONFIG_GICV4 attr
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Raghavendra Rao Anata <rananta@google.com>, Mingwei Zhang <mizhang@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

When kvm-arm.vgic_v4_enable=1, KVM adds support for direct interrupt
injection by default to all the VMs in the system, aka GICv4. A
shortcoming of the GIC architecture is that there's an absolute limit on
the number of vPEs that can be tracked by the ITS. It is possible that
an operator is running a mix of VMs on a system, only wanting to provide
a specific class of VMs with hardware interrupt injection support.

To support this, introduce a GIC attribute, KVM_DEV_ARM_VGIC_CONFIG_GICV4,
for the userspace to enable or disable vGICv4 for a given VM. Make the
interface backward compatible by leaving vGICv4 enabled by default.

Suggested-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 arch/arm64/include/uapi/asm/kvm.h     |  7 +++++
 arch/arm64/kvm/vgic/vgic-init.c       |  3 +++
 arch/arm64/kvm/vgic/vgic-its.c        |  2 +-
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 39 +++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-mmio-v3.c    | 12 ++++-----
 arch/arm64/kvm/vgic/vgic-v3.c         | 16 +++++++++--
 arch/arm64/kvm/vgic/vgic-v4.c         |  8 +++---
 include/kvm/arm_vgic.h                |  5 ++++
 8 files changed, 79 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index af9d9acaf997..6762683f7e0f 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -428,6 +428,13 @@ enum {
 #define   KVM_DEV_ARM_ITS_RESTORE_TABLES        2
 #define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
 #define   KVM_DEV_ARM_ITS_CTRL_RESET		4
+#define   KVM_DEV_ARM_VGIC_CONFIG_GICV4	5
+
+enum {
+	KVM_DEV_ARM_VGIC_CONFIG_GICV4_UNAVAILABLE = 0,
+	KVM_DEV_ARM_VGIC_CONFIG_GICV4_DISABLE,
+	KVM_DEV_ARM_VGIC_CONFIG_GICV4_ENABLE,
+};
 
 /* Device Control API on vcpu fd */
 #define KVM_ARM_VCPU_PMU_V3_CTRL	0
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 1f33e71c2a73..cd345df2271f 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -132,6 +132,9 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 
 	kvm->arch.vgic.in_kernel = true;
 	kvm->arch.vgic.vgic_model = type;
+	kvm->arch.vgic.gicv4_config = kvm_vgic_global_state.has_gicv4 ?
+				      KVM_DEV_ARM_VGIC_CONFIG_GICV4_ENABLE :
+				      KVM_DEV_ARM_VGIC_CONFIG_GICV4_UNAVAILABLE;
 
 	kvm->arch.vgic.vgic_dist_base = VGIC_ADDR_UNDEF;
 
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index fb96802799c6..bba635e4e851 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2242,7 +2242,7 @@ static int vgic_its_save_itt(struct vgic_its *its, struct its_device *device)
 		 * have direct access to that state without GICv4.1.
 		 * Let's simply fail the save operation...
 		 */
-		if (ite->irq->hw && !kvm_vgic_global_state.has_gicv4_1)
+		if (ite->irq->hw && !kvm_vm_has_gicv4_1(its->dev->kvm))
 			return -EACCES;
 
 		ret = vgic_its_save_ite(its, device, ite, gpa);
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index 359094f68c23..f03b80fc816e 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -279,6 +279,33 @@ static int vgic_set_common_attr(struct kvm_device *dev,
 			unlock_all_vcpus(dev->kvm);
 			mutex_unlock(&dev->kvm->lock);
 			return r;
+		case KVM_DEV_ARM_VGIC_CONFIG_GICV4: {
+			u8 __user *uaddr = (u8 __user *)(long)attr->addr;
+			u8 val;
+
+			if (!kvm_vgic_global_state.has_gicv4)
+				return -ENXIO;
+
+			if (get_user(val, uaddr))
+				return -EFAULT;
+
+			if (vgic_initialized(dev->kvm) &&
+				val != dev->kvm->arch.vgic.gicv4_config)
+				return -EBUSY;
+
+			switch (val) {
+			case KVM_DEV_ARM_VGIC_CONFIG_GICV4_ENABLE:
+			case KVM_DEV_ARM_VGIC_CONFIG_GICV4_DISABLE:
+				mutex_lock(&dev->kvm->arch.config_lock);
+				dev->kvm->arch.vgic.gicv4_config = val;
+				mutex_unlock(&dev->kvm->arch.config_lock);
+				break;
+			default:
+				return -EINVAL;
+			}
+
+			return 0;
+		}
 		}
 		break;
 	}
@@ -309,6 +336,16 @@ static int vgic_get_common_attr(struct kvm_device *dev,
 		r = put_user(dev->kvm->arch.vgic.mi_intid, uaddr);
 		break;
 	}
+	case KVM_DEV_ARM_VGIC_GRP_CTRL: {
+		switch (attr->attr) {
+		case KVM_DEV_ARM_VGIC_CONFIG_GICV4: {
+			u8 __user *uaddr = (u8 __user *)(long)attr->addr;
+
+			r = put_user(dev->kvm->arch.vgic.gicv4_config, uaddr);
+			break;
+		}
+		}
+	}
 	}
 
 	return r;
@@ -684,6 +721,8 @@ static int vgic_v3_has_attr(struct kvm_device *dev,
 			return 0;
 		case KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES:
 			return 0;
+		case KVM_DEV_ARM_VGIC_CONFIG_GICV4:
+			return 0;
 		}
 	}
 	return -ENXIO;
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index ae4c0593d114..66b365f59c51 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -50,8 +50,8 @@ bool vgic_has_its(struct kvm *kvm)
 
 bool vgic_supports_direct_msis(struct kvm *kvm)
 {
-	return (kvm_vgic_global_state.has_gicv4_1 ||
-		(kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm)));
+	return kvm_vm_has_gicv4(kvm) &&
+		(kvm_vgic_global_state.has_gicv4_1 || vgic_has_its(kvm));
 }
 
 /*
@@ -86,7 +86,7 @@ static unsigned long vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
 		}
 		break;
 	case GICD_TYPER2:
-		if (kvm_vgic_global_state.has_gicv4_1 && gic_cpuif_has_vsgi())
+		if (kvm_vm_has_gicv4_1(vcpu->kvm) && gic_cpuif_has_vsgi())
 			value = GICD_TYPER2_nASSGIcap;
 		break;
 	case GICD_IIDR:
@@ -119,7 +119,7 @@ static void vgic_mmio_write_v3_misc(struct kvm_vcpu *vcpu,
 		dist->enabled = val & GICD_CTLR_ENABLE_SS_G1;
 
 		/* Not a GICv4.1? No HW SGIs */
-		if (!kvm_vgic_global_state.has_gicv4_1 || !gic_cpuif_has_vsgi())
+		if (!kvm_vm_has_gicv4_1(vcpu->kvm) || !gic_cpuif_has_vsgi())
 			val &= ~GICD_CTLR_nASSGIreq;
 
 		/* Dist stays enabled? nASSGIreq is RO */
@@ -133,7 +133,7 @@ static void vgic_mmio_write_v3_misc(struct kvm_vcpu *vcpu,
 		if (is_hwsgi != dist->nassgireq)
 			vgic_v4_configure_vsgis(vcpu->kvm);
 
-		if (kvm_vgic_global_state.has_gicv4_1 &&
+		if (kvm_vm_has_gicv4_1(vcpu->kvm) &&
 		    was_enabled != dist->enabled)
 			kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_RELOAD_GICv4);
 		else if (!was_enabled && dist->enabled)
@@ -178,7 +178,7 @@ static int vgic_mmio_uaccess_write_v3_misc(struct kvm_vcpu *vcpu,
 		}
 	case GICD_CTLR:
 		/* Not a GICv4.1? No HW SGIs */
-		if (!kvm_vgic_global_state.has_gicv4_1)
+		if (!kvm_vm_has_gicv4_1(vcpu->kvm))
 			val &= ~GICD_CTLR_nASSGIreq;
 
 		dist->enabled = val & GICD_CTLR_ENABLE_SS_G1;
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index b9ad7c42c5b0..bc8cb9184be9 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -20,6 +20,18 @@ static bool common_trap;
 static bool dir_trap;
 static bool gicv4_enable;
 
+int kvm_vm_has_gicv4(struct kvm *kvm)
+{
+	return kvm->arch.vgic.gicv4_config ==
+		KVM_DEV_ARM_VGIC_CONFIG_GICV4_ENABLE;
+}
+
+int kvm_vm_has_gicv4_1(struct kvm *kvm)
+{
+	return (kvm_vm_has_gicv4(kvm) &&
+		kvm_vgic_global_state.has_gicv4_1);
+}
+
 void vgic_v3_set_underflow(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v3;
@@ -404,7 +416,7 @@ int vgic_v3_save_pending_tables(struct kvm *kvm)
 	 * The above vgic initialized check also ensures that the allocation
 	 * and enabling of the doorbells have already been done.
 	 */
-	if (kvm_vgic_global_state.has_gicv4_1) {
+	if (kvm_vm_has_gicv4_1(kvm)) {
 		unmap_all_vpes(kvm);
 		vlpi_avail = true;
 	}
@@ -581,7 +593,7 @@ int vgic_v3_map_resources(struct kvm *kvm)
 		return -EBUSY;
 	}
 
-	if (kvm_vgic_global_state.has_gicv4_1)
+	if (kvm_vm_has_gicv4_1(kvm))
 		vgic_v4_configure_vsgis(kvm);
 
 	return 0;
diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index c7de6154627c..814d54f4ce13 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -86,7 +86,7 @@ static irqreturn_t vgic_v4_doorbell_handler(int irq, void *info)
 	struct kvm_vcpu *vcpu = info;
 
 	/* We got the message, no need to fire again */
-	if (!kvm_vgic_global_state.has_gicv4_1 &&
+	if (!kvm_vm_has_gicv4_1(vcpu->kvm) &&
 	    !irqd_irq_disabled(&irq_to_desc(irq)->irq_data))
 		disable_irq_nosync(irq);
 
@@ -245,7 +245,7 @@ int vgic_v4_init(struct kvm *kvm)
 
 	lockdep_assert_held(&kvm->arch.config_lock);
 
-	if (!kvm_vgic_global_state.has_gicv4)
+	if (!kvm_vm_has_gicv4(kvm))
 		return 0; /* Nothing to see here... move along. */
 
 	if (dist->its_vm.vpes)
@@ -286,7 +286,7 @@ int vgic_v4_init(struct kvm *kvm)
 		 * On GICv4.1, the doorbell is managed in HW and must
 		 * be left enabled.
 		 */
-		if (kvm_vgic_global_state.has_gicv4_1)
+		if (kvm_vm_has_gicv4_1(kvm))
 			irq_flags &= ~IRQ_NOAUTOEN;
 		irq_set_status_flags(irq, irq_flags);
 
@@ -392,7 +392,7 @@ int vgic_v4_load(struct kvm_vcpu *vcpu)
 	 * doorbell interrupt that would still be pending. This is a
 	 * GICv4.0 only "feature"...
 	 */
-	if (!kvm_vgic_global_state.has_gicv4_1)
+	if (!kvm_vm_has_gicv4_1(vcpu->kvm))
 		err = irq_set_irqchip_state(vpe->irq, IRQCHIP_STATE_PENDING, false);
 
 	return err;
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 714cef854c1c..8883dc677674 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -296,6 +296,8 @@ struct vgic_dist {
 	 * else.
 	 */
 	struct its_vm		its_vm;
+
+	u8			gicv4_config;
 };
 
 struct vgic_v2_cpu_if {
@@ -447,4 +449,7 @@ bool vgic_state_is_nested(struct kvm_vcpu *vcpu);
 void kvm_vgic_cpu_up(void);
 void kvm_vgic_cpu_down(void);
 
+int kvm_vm_has_gicv4(struct kvm *kvm);
+int kvm_vm_has_gicv4_1(struct kvm *kvm);
+
 #endif /* __KVM_ARM_VGIC_H */
-- 
2.49.0.1101.gccaa498523-goog


