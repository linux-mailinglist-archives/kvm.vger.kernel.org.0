Return-Path: <kvm+bounces-49449-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AB29AD920D
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 17:55:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1FE331E5026
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 15:54:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D287227574;
	Fri, 13 Jun 2025 15:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Kg645UMD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com [209.85.166.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD691E3DCF
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 15:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749829978; cv=none; b=q7OIy8hiQx16RYXBuN9WnWQ+cvjHO9WE0tnMpOqA2w01JQQaK5EVmp+rPggJO/xzPP4DpxIdIEI3jv3uzLCIZ+7lzZQuXTQmUwHp6Nkec2kVvfuHyTTOxu5mktgM+p1zRDgCSe4dyFYA2E30IycVptLfq0Yttz+Yvv4h0ZjrBJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749829978; c=relaxed/simple;
	bh=vxkacs+qUolHE8ofOSXElM6uFZzrXDwx3yDd3lw+TdE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oTe8Wm9LKWzDToF0m4+vMuVeKH+a+qouPqTwM3YfBizduRqcF1Q5uV1sYy7mtGkMig/vK9zNkZb90pnxwysiGThFacUaI/IaUvnZSyJfDbb4Itiw0y2yNEQvn7sq+mxJQeyXNrR28dwWF76WXcXs+c/U5PGDc9il+YIj0Hi0Rc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Kg645UMD; arc=none smtp.client-ip=209.85.166.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-il1-f202.google.com with SMTP id e9e14a558f8ab-3ddf66427f8so39296035ab.2
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 08:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749829976; x=1750434776; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OFF6SOp13MfI+rKYc7dCezNEaDk/WUOkhnG6IJMmr80=;
        b=Kg645UMD5Al2JdimJtX+fWBrF7WLVF+k6Od+MRlWVrWRXRUlFv6/C0HbftavRly7TP
         pt28jSaVtEWQWSKk6ewNBj0x8k7a41xeak2cP5QSfOs+NyLUiFkKE0la80pIH7SoEplI
         TcwHC4J4iKb0Hkj8ZcKH3t/l8WnIcqCQ4LXJVcmIIPUf9bhbuLAp7SLxNrq31qwvnTW7
         ZM4DVDgbTTdt53eu5XGNMd8scqs7QKeDnnemLXVa+N2ntPNTSrpTjXWa2BklvzMTerHF
         UYvkjuwM7ZMgD2651kDfj2+Am6yDuFX6120bgaCnyQvvqyTHC/dTtpXtMralEAPy/xP4
         GGcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749829976; x=1750434776;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OFF6SOp13MfI+rKYc7dCezNEaDk/WUOkhnG6IJMmr80=;
        b=TG+x1g/ut0iudRbW7UinD8YduNdr5z5ELAmT77KXfvTLSH0jNkmpmd0PrpB482wbLQ
         mhQ4/LwvnMj7JylaMaC1FPXZ2aQPdWNmpAypOgPA6HfSk7bI4aSpnrC+bqAV8VAidV37
         Hoja6HXA8xTn1Zus8bBSIQxW42UOyDBUovtZ+z9ncYy/eAtgouOCVOvWlQgIMb5VRfcM
         U41vIbjcLfzeEUCsr8oskCSEMqv8dwUwCyqzTnJawS/jdth2A9TYuwOljTa9/FekNd7W
         J+hKyhFRWSRQqTrNbjjaKQcUIK0BGMso2kzJTpE/oC/LbZkg2im2XSNdSPRMIPzA7x0k
         SjNg==
X-Forwarded-Encrypted: i=1; AJvYcCUiv04QjaRXvRvEP7Myv05LZviiUnOV+P4kUEjRuL4hckm6RhqRQWQRFreM3LL9C3XK4lY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyF5Xqly32p/0PDV89aLCQhPppQKw+EKPb7w/PDXeKIOMQXkUG5
	b96pBb73Ge9kVIG8aiKpMOFTmyFczmcRUGLlWHArQGps0JdSHjJ7Tsc3b1oYlQgcyaMhNgiZxqB
	WnCxLuIP29A==
X-Google-Smtp-Source: AGHT+IG8T3q/TFMjMeVIYD6samTw89/uinTNnuWwzxHnuwndVMxgoAdLhGBoyVqCfis1o5KW9rTeoIB0iQbo
X-Received: from oabkz22.prod.google.com ([2002:a05:6871:4096:b0:2bc:69a2:7ea5])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6870:a3c6:b0:2d6:667c:511f
 with SMTP id 586e51a60fabf-2eaf05ca75amr171809fac.9.1749829964975; Fri, 13
 Jun 2025 08:52:44 -0700 (PDT)
Date: Fri, 13 Jun 2025 15:52:36 +0000
In-Reply-To: <20250613155239.2029059-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250613155239.2029059-1-rananta@google.com>
X-Mailer: git-send-email 2.50.0.rc2.692.g299adb8693-goog
Message-ID: <20250613155239.2029059-3-rananta@google.com>
Subject: [PATCH v3 2/4] KVM: arm64: vgic-v3: Consolidate MAINT_IRQ handling
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Raghavendra Rao Anata <rananta@google.com>, Mingwei Zhang <mizhang@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Oliver Upton <oliver.upton@linux.dev>

Consolidate the duplicated handling of the VGICv3 maintenance IRQ
attribute as a regular GICv3 attribute, as it is neither a register nor
a common attribute.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 51 +++++++++++++--------------
 1 file changed, 25 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index f9ae790163fb..e28cf68a49c3 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -303,12 +303,6 @@ static int vgic_get_common_attr(struct kvm_device *dev,
 			     VGIC_NR_PRIVATE_IRQS, uaddr);
 		break;
 	}
-	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ: {
-		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
-
-		r = put_user(dev->kvm->arch.vgic.mi_intid, uaddr);
-		break;
-	}
 	}
 
 	return r;
@@ -523,7 +517,7 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 	struct vgic_reg_attr reg_attr;
 	gpa_t addr;
 	struct kvm_vcpu *vcpu;
-	bool uaccess, post_init = true;
+	bool uaccess;
 	u32 val;
 	int ret;
 
@@ -539,9 +533,6 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 		/* Sysregs uaccess is performed by the sysreg handling code */
 		uaccess = false;
 		break;
-	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ:
-		post_init = false;
-		fallthrough;
 	default:
 		uaccess = true;
 	}
@@ -561,7 +552,7 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 
 	mutex_lock(&dev->kvm->arch.config_lock);
 
-	if (post_init != vgic_initialized(dev->kvm)) {
+	if (!vgic_initialized(dev->kvm)) {
 		ret = -EBUSY;
 		goto out;
 	}
@@ -591,19 +582,6 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 		}
 		break;
 	}
-	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ:
-		if (!is_write) {
-			val = dev->kvm->arch.vgic.mi_intid;
-			ret = 0;
-			break;
-		}
-
-		ret = -EINVAL;
-		if ((val < VGIC_NR_PRIVATE_IRQS) && (val >= VGIC_NR_SGIS)) {
-			dev->kvm->arch.vgic.mi_intid = val;
-			ret = 0;
-		}
-		break;
 	default:
 		ret = -EINVAL;
 		break;
@@ -630,8 +608,24 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
 	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
 	case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO:
-	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ:
 		return vgic_v3_attr_regs_access(dev, attr, true);
+	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ: {
+		u32 __user *uaddr = (u32 __user *)attr->addr;
+		u32 val;
+
+		if (get_user(val, uaddr))
+			return -EFAULT;
+
+		guard(mutex)(&dev->kvm->arch.config_lock);
+		if (vgic_initialized(dev->kvm))
+			return -EBUSY;
+
+		if ((val < VGIC_NR_SGIS) || (val >= VGIC_NR_PRIVATE_IRQS))
+			return -EINVAL;
+
+		dev->kvm->arch.vgic.mi_intid = val;
+		return 0;
+	}
 	default:
 		return vgic_set_common_attr(dev, attr);
 	}
@@ -645,8 +639,13 @@ static int vgic_v3_get_attr(struct kvm_device *dev,
 	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
 	case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO:
-	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ:
 		return vgic_v3_attr_regs_access(dev, attr, false);
+	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ: {
+		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
+
+		guard(mutex)(&dev->kvm->arch.config_lock);
+		return put_user(dev->kvm->arch.vgic.mi_intid, uaddr);
+	}
 	default:
 		return vgic_get_common_attr(dev, attr);
 	}
-- 
2.50.0.rc2.692.g299adb8693-goog


