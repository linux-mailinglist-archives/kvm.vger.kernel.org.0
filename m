Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5C217065AE
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 12:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbjEQKxP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 06:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbjEQKxL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 06:53:11 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F3F161B7
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 03:52:43 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id 46e09a7af769-6ab0a21dd01so271154a34.0
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 03:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1684320747; x=1686912747;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kUsqFBRSizZOBbNz09TlCKcbFhTjGXkGkHhT7XXk9dc=;
        b=UbgZS/Tz5hnb69o2g+omOdrV7tfYg+sEssYVWHXO/bJ+7Blf4jWHzp7/ULMtpNODbx
         ewic8n6XLnfOl2E9hv0RmHdpHNd7uFFnl+LYnKVUnqmOry4HBNI71om8UMKpRSss7/nc
         a1FEZ2C0SEs9Q129ddmu1hKZVe4YlPc31Bzvwnsb2WCTgHlk5QlsR86abLM+AjoNcniH
         Bv2xJUPQXogOqUkidVXnHfidhDGrHvW/s/iZ06W/7zChZry7rtJsQa6mL8A2QFj/JL/O
         zJA3+GU6TC3ke6HHZk+rgcErvZh2GpTsjVra2i0Km4eQNZ4tnLL6hzfedT2xPEKGLpr3
         cWQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684320747; x=1686912747;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kUsqFBRSizZOBbNz09TlCKcbFhTjGXkGkHhT7XXk9dc=;
        b=OlVakNCClD2Qb2sPdHPW/tg3RKbeNVEjHxVHsCkP5ed1Ia1LbwENjPIgJYH/DYQjc8
         pU+j6y7a/Tb2fOqyo9zBjZBBpmK9da8tqMjtUWo2Dt4doVYphm2DiuwwrJ7fw+fATOLr
         3w7Z8RsPe3fNwNtjh0RIpVav2pjad4qXMa+nEH0JW/z7tCNyo/GG5mC5uHMs3zAfbKpv
         f2YxVCZPhFXYzs0IDIgORJeL2YPUzYdHSs5OUMqNX4QshKT/WHGP7LBODuTT4FqNbSF5
         TBVHDOt2wHx67rZgDd3FsKPb7Yl+7DuijdFitILhkg9Dw9el8beKC/L7gJwc3GqZXdR/
         yyig==
X-Gm-Message-State: AC+VfDw6FTy3G4lO2Os9OkGPmRK9jDGPsXW1qkXncz57B8kI08WFyhEE
        oc3NNyWInqNNqDhRejyAdhGpGQ==
X-Google-Smtp-Source: ACHHUZ5ofDP1vXCukQa6GbbjvjT2ZVP8jTk8TIE1d+Gh1bRqzPLNCYWotHjDi0hHaPUREQ1i3EvT4w==
X-Received: by 2002:a05:6830:55:b0:6ad:8322:7460 with SMTP id d21-20020a056830005500b006ad83227460mr6048951otp.9.1684320747057;
        Wed, 17 May 2023 03:52:27 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id w1-20020a9d77c1000000b006ade3815527sm2279896otl.22.2023.05.17.03.52.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 03:52:26 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 08/10] RISC-V: KVM: Expose APLIC registers as attributes of AIA irqchip
Date:   Wed, 17 May 2023 16:21:33 +0530
Message-Id: <20230517105135.1871868-9-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230517105135.1871868-1-apatel@ventanamicro.com>
References: <20230517105135.1871868-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We expose APLIC registers as KVM device attributes of the in-kernel
AIA irqchip device. This will allow KVM user-space to save/restore
APLIC state using KVM device ioctls().

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_aia.h  |  3 +++
 arch/riscv/include/uapi/asm/kvm.h |  2 ++
 arch/riscv/kvm/aia_aplic.c        | 43 +++++++++++++++++++++++++++++++
 arch/riscv/kvm/aia_device.c       | 25 ++++++++++++++++++
 4 files changed, 73 insertions(+)

diff --git a/arch/riscv/include/asm/kvm_aia.h b/arch/riscv/include/asm/kvm_aia.h
index f6bd8523395f..ba939c0054aa 100644
--- a/arch/riscv/include/asm/kvm_aia.h
+++ b/arch/riscv/include/asm/kvm_aia.h
@@ -129,6 +129,9 @@ static inline void kvm_riscv_vcpu_aia_imsic_cleanup(struct kvm_vcpu *vcpu)
 {
 }
 
+int kvm_riscv_aia_aplic_set_attr(struct kvm *kvm, unsigned long type, u32 v);
+int kvm_riscv_aia_aplic_get_attr(struct kvm *kvm, unsigned long type, u32 *v);
+int kvm_riscv_aia_aplic_has_attr(struct kvm *kvm, unsigned long type);
 int kvm_riscv_aia_aplic_inject(struct kvm *kvm, u32 source, bool level);
 int kvm_riscv_aia_aplic_init(struct kvm *kvm);
 void kvm_riscv_aia_aplic_cleanup(struct kvm *kvm);
diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index 57f8d8bb498e..e80210c2220b 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -240,6 +240,8 @@ enum KVM_RISCV_SBI_EXT_ID {
 #define KVM_DEV_RISCV_AIA_GRP_CTRL		2
 #define KVM_DEV_RISCV_AIA_CTRL_INIT		0
 
+#define KVM_DEV_RISCV_AIA_GRP_APLIC		3
+
 /* One single KVM irqchip, ie. the AIA */
 #define KVM_NR_IRQCHIPS			1
 
diff --git a/arch/riscv/kvm/aia_aplic.c b/arch/riscv/kvm/aia_aplic.c
index 1b0a4df64815..ed9102dfba77 100644
--- a/arch/riscv/kvm/aia_aplic.c
+++ b/arch/riscv/kvm/aia_aplic.c
@@ -499,6 +499,49 @@ static struct kvm_io_device_ops aplic_iodoev_ops = {
 	.write = aplic_mmio_write,
 };
 
+int kvm_riscv_aia_aplic_set_attr(struct kvm *kvm, unsigned long type, u32 v)
+{
+	int rc;
+
+	if (!kvm->arch.aia.aplic_state)
+		return -ENODEV;
+
+	rc = aplic_mmio_write_offset(kvm, type, v);
+	if (rc)
+		return rc;
+
+	return 0;
+}
+
+int kvm_riscv_aia_aplic_get_attr(struct kvm *kvm, unsigned long type, u32 *v)
+{
+	int rc;
+
+	if (!kvm->arch.aia.aplic_state)
+		return -ENODEV;
+
+	rc = aplic_mmio_read_offset(kvm, type, v);
+	if (rc)
+		return rc;
+
+	return 0;
+}
+
+int kvm_riscv_aia_aplic_has_attr(struct kvm *kvm, unsigned long type)
+{
+	int rc;
+	u32 val;
+
+	if (!kvm->arch.aia.aplic_state)
+		return -ENODEV;
+
+	rc = aplic_mmio_read_offset(kvm, type, &val);
+	if (rc)
+		return rc;
+
+	return 0;
+}
+
 int kvm_riscv_aia_aplic_init(struct kvm *kvm)
 {
 	int i, ret = 0;
diff --git a/arch/riscv/kvm/aia_device.c b/arch/riscv/kvm/aia_device.c
index a151fb357887..17dba92a90e1 100644
--- a/arch/riscv/kvm/aia_device.c
+++ b/arch/riscv/kvm/aia_device.c
@@ -364,6 +364,15 @@ static int aia_set_attr(struct kvm_device *dev, struct kvm_device_attr *attr)
 			break;
 		}
 
+		break;
+	case KVM_DEV_RISCV_AIA_GRP_APLIC:
+		if (copy_from_user(&nr, uaddr, sizeof(nr)))
+			return -EFAULT;
+
+		mutex_lock(&dev->kvm->lock);
+		r = kvm_riscv_aia_aplic_set_attr(dev->kvm, type, nr);
+		mutex_unlock(&dev->kvm->lock);
+
 		break;
 	}
 
@@ -411,6 +420,20 @@ static int aia_get_attr(struct kvm_device *dev, struct kvm_device_attr *attr)
 		if (copy_to_user(uaddr, &addr, sizeof(addr)))
 			return -EFAULT;
 
+		break;
+	case KVM_DEV_RISCV_AIA_GRP_APLIC:
+		if (copy_from_user(&nr, uaddr, sizeof(nr)))
+			return -EFAULT;
+
+		mutex_lock(&dev->kvm->lock);
+		r = kvm_riscv_aia_aplic_get_attr(dev->kvm, type, &nr);
+		mutex_unlock(&dev->kvm->lock);
+		if (r)
+			return r;
+
+		if (copy_to_user(uaddr, &nr, sizeof(nr)))
+			return -EFAULT;
+
 		break;
 	}
 
@@ -447,6 +470,8 @@ static int aia_has_attr(struct kvm_device *dev, struct kvm_device_attr *attr)
 			return 0;
 		}
 		break;
+	case KVM_DEV_RISCV_AIA_GRP_APLIC:
+		return kvm_riscv_aia_aplic_has_attr(dev->kvm, attr->attr);
 	}
 
 	return -ENXIO;
-- 
2.34.1

