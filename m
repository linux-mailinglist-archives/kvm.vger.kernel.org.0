Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C62797310DE
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 09:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244969AbjFOHfe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 03:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245178AbjFOHfA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 03:35:00 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE9E42D73
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 00:34:29 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1b3c578c602so31337765ad.2
        for <kvm@vger.kernel.org>; Thu, 15 Jun 2023 00:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1686814469; x=1689406469;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NwO5wYN1w5TATPv4eKfzhxcMf0t/5mA6O0is8eCDj4I=;
        b=kGoN5P2dzjM6VyzhQDtDDPc/RqumyRWRevCZB0lJ0iAkXcz40wAl7+0oMGIq7AnAlQ
         huAZ4qeBAlJRCuH7LA/9/W961J8SKDyrWRWF9DadY+u7ZBcGPBlB90/eLDoU+JzYSwq/
         izmZSPCp4uPS6ZQzQOIOjMzOcajsPGkvcuL+IOW9lpGxBBCJY8Pa2+99VdTY7TK0zAPu
         VEBUlHaPWdEmEOin2hF2vVJ1u9jVGaPmduODLGQ0RYTmlwDr7C3N1j9B/zkDa80qPML5
         shcslfc1jn+3tpU6qPeaOs/QqcnrKXVNfYgfjwxxFg4WLgBKHB2rY9rlJhpiUFm+JaMP
         K0bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686814469; x=1689406469;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NwO5wYN1w5TATPv4eKfzhxcMf0t/5mA6O0is8eCDj4I=;
        b=KmX32hgriOOXwRez8EmWpEH0JgLlOgMSEdSxrkHEWaG9FA83zKBDwoWePRF7GSKUkL
         0a48Mvmb6BaGt4Q5L9hv0Pn3njO6/H6hcUBTWeRuzmr9G3uJQdS3iy+iImOZTKUKdvgF
         VN0C1R84D5DfGixo9XSLRfnQLhp2nlgN3hY5h3S/B0EnqeZBpl4eZUQfz/Yskkyf+iaZ
         eGQNO8jplJ6NBqOkyw/dKzOGiXMOMaNXF/BBNIpzLGyXBxbZqRYMkneY3Qy6zSW+LQBC
         IHHLGNKO6wC6CqITjLrQWEYCM0S+R/lX+ouVtjlMrSEn1ILBxoKxRPCZRDh/eO+xugJL
         frQw==
X-Gm-Message-State: AC+VfDx/T+/iiSj2Pj91zXSSCxxyfEFevUjp+buvfJ2DrtA1CBnj8/td
        LLw/afoO7qfb8mYKLnHs2hdIQg==
X-Google-Smtp-Source: ACHHUZ4+fpw9v3b9+CDDN8KzkgoO92jhEaJj2s2l2W7Nb4/d3WXidiPCblEyGbx2Z4njRPIddKVlzg==
X-Received: by 2002:a17:902:f543:b0:1b3:e77b:f70d with SMTP id h3-20020a170902f54300b001b3e77bf70dmr8718741plf.29.1686814468796;
        Thu, 15 Jun 2023 00:34:28 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([106.51.83.242])
        by smtp.gmail.com with ESMTPSA id ji1-20020a170903324100b001b016313b1dsm8049855plb.86.2023.06.15.00.34.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jun 2023 00:34:28 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH v3 08/10] RISC-V: KVM: Expose APLIC registers as attributes of AIA irqchip
Date:   Thu, 15 Jun 2023 13:03:51 +0530
Message-Id: <20230615073353.85435-9-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230615073353.85435-1-apatel@ventanamicro.com>
References: <20230615073353.85435-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
 arch/riscv/include/uapi/asm/kvm.h |  6 +++++
 arch/riscv/kvm/aia_aplic.c        | 43 +++++++++++++++++++++++++++++++
 arch/riscv/kvm/aia_device.c       | 25 ++++++++++++++++++
 4 files changed, 77 insertions(+)

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
index 047c8fc5bd71..9ed822fc5589 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -249,6 +249,12 @@ enum KVM_RISCV_SBI_EXT_ID {
 #define KVM_DEV_RISCV_AIA_GRP_CTRL		2
 #define KVM_DEV_RISCV_AIA_CTRL_INIT		0
 
+/*
+ * The device attribute type contains the memory mapped offset of the
+ * APLIC register (range 0x0000-0x3FFF) and it must be 4-byte aligned.
+ */
+#define KVM_DEV_RISCV_AIA_GRP_APLIC		3
+
 /* One single KVM irqchip, ie. the AIA */
 #define KVM_NR_IRQCHIPS			1
 
diff --git a/arch/riscv/kvm/aia_aplic.c b/arch/riscv/kvm/aia_aplic.c
index eecd8f4abe21..39e72aa016a4 100644
--- a/arch/riscv/kvm/aia_aplic.c
+++ b/arch/riscv/kvm/aia_aplic.c
@@ -501,6 +501,49 @@ static struct kvm_io_device_ops aplic_iodoev_ops = {
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
index 7ab555121872..c649ad6e8e0a 100644
--- a/arch/riscv/kvm/aia_device.c
+++ b/arch/riscv/kvm/aia_device.c
@@ -365,6 +365,15 @@ static int aia_set_attr(struct kvm_device *dev, struct kvm_device_attr *attr)
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
 
@@ -412,6 +421,20 @@ static int aia_get_attr(struct kvm_device *dev, struct kvm_device_attr *attr)
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
 
@@ -448,6 +471,8 @@ static int aia_has_attr(struct kvm_device *dev, struct kvm_device_attr *attr)
 			return 0;
 		}
 		break;
+	case KVM_DEV_RISCV_AIA_GRP_APLIC:
+		return kvm_riscv_aia_aplic_has_attr(dev->kvm, attr->attr);
 	}
 
 	return -ENXIO;
-- 
2.34.1

