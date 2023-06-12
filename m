Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC76172B7C8
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 07:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235982AbjFLFmL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 01:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235962AbjFLFlK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 01:41:10 -0400
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF58D10D4
        for <kvm@vger.kernel.org>; Sun, 11 Jun 2023 22:40:33 -0700 (PDT)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-1a67ea77c3bso767530fac.3
        for <kvm@vger.kernel.org>; Sun, 11 Jun 2023 22:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1686548432; x=1689140432;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PZnZ5+OjGREkSkyG6QnA5JwIHZ1MgkxpDO0yDwMpGdU=;
        b=BVZUdpHJAykoMWigPWWyjUrFI1QVlNWpuDtR/RhvEgtN/yRE06Nnb7dSKcsGKyOJa/
         jz5L4/2GHGpvwkPheEdBHOam1CWKf5GMaM5oeLZyGaJkTO7NntxQms4ETpTjZ6AWaOtB
         GS6gbz52bkwjsGjEgVRSVDlUkln0xRe5ZMVuATJhW/BHqUfUTvsm4d7beOfHNuKBrM9K
         qis6jwuik+WWVpcMcGLIpO8bjrdVkqBiAYuDljpfd07GmjvwFpvIEQQl4pIVaOClvx47
         lQ+/6Hc8C3o7773N6Nl2MhCCluuT7+a9oaJye807d+MNARqK8G41qFHwXg7EsnC/bLDA
         RKIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686548432; x=1689140432;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PZnZ5+OjGREkSkyG6QnA5JwIHZ1MgkxpDO0yDwMpGdU=;
        b=dNhF0nA78xcimPTgkfoF0fWX29JIDNIulxEencTv3ZkPxmHV/fLUyJc9njlIq3iBY8
         g/PXJKvVC3FDgKzHNvynREWMvl1doYW8I/NZUp+enT1Y4mUhu472Pwk3Aiq8+t0goZ99
         HDGYIBLv3saweXyUokE1QakBD+KvpXdTPb0bLLgGPlHckHV30MF4KkRBzhaoqBfxWONE
         rkts5FK8uWDaQCAoMvlnZpYAlKKWZ3tJDHSfIlPTs/MoPmn6wascYAh01DiQJWRMEkKs
         2+1Ngj3TihKI+wFPBEKY6CH/NwRatqaBCIcdvKyoYcMnKrLw3d3Bkf+wp0W5zyOEKT46
         71ew==
X-Gm-Message-State: AC+VfDzEWfWFIzjOhX1SHAvbZxZVDvAWiCguKy8GzSC0+l6qrn2lVITy
        Mj39PoiG5juCzeVM1wKrcG4iQA==
X-Google-Smtp-Source: ACHHUZ4edMeLTd1bFBAWvO0cBHaggZHgbET5p1vxNEV7k50958TwGfBsk5xAqFOawHCu2dUHdkoU0g==
X-Received: by 2002:a05:6870:a89a:b0:1a0:bbee:c1de with SMTP id eb26-20020a056870a89a00b001a0bbeec1demr4268965oab.1.1686548432345;
        Sun, 11 Jun 2023 22:40:32 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id lv19-20020a056871439300b001a30d846520sm5534869oab.7.2023.06.11.22.40.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jun 2023 22:40:32 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>,
        Atish Patra <atishp@rivosinc.com>
Subject: [PATCH v2 10/10] RISC-V: KVM: Expose IMSIC registers as attributes of AIA irqchip
Date:   Mon, 12 Jun 2023 11:09:32 +0530
Message-Id: <20230612053932.58604-11-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230612053932.58604-1-apatel@ventanamicro.com>
References: <20230612053932.58604-1-apatel@ventanamicro.com>
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

We expose IMSIC registers as KVM device attributes of the in-kernel
AIA irqchip device. This will allow KVM user-space to save/restore
IMISC state of each VCPU using KVM device ioctls().

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/kvm_aia.h  |   3 +
 arch/riscv/include/uapi/asm/kvm.h |  17 +++
 arch/riscv/kvm/aia_device.c       |  29 ++++-
 arch/riscv/kvm/aia_imsic.c        | 170 ++++++++++++++++++++++++++++++
 4 files changed, 217 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_aia.h b/arch/riscv/include/asm/kvm_aia.h
index a4f6ebf90e31..1f37b600ca47 100644
--- a/arch/riscv/include/asm/kvm_aia.h
+++ b/arch/riscv/include/asm/kvm_aia.h
@@ -97,6 +97,9 @@ int kvm_riscv_vcpu_aia_imsic_update(struct kvm_vcpu *vcpu);
 int kvm_riscv_vcpu_aia_imsic_rmw(struct kvm_vcpu *vcpu, unsigned long isel,
 				 unsigned long *val, unsigned long new_val,
 				 unsigned long wr_mask);
+int kvm_riscv_aia_imsic_rw_attr(struct kvm *kvm, unsigned long type,
+				bool write, unsigned long *val);
+int kvm_riscv_aia_imsic_has_attr(struct kvm *kvm, unsigned long type);
 void kvm_riscv_vcpu_aia_imsic_reset(struct kvm_vcpu *vcpu);
 int kvm_riscv_vcpu_aia_imsic_inject(struct kvm_vcpu *vcpu,
 				    u32 guest_index, u32 offset, u32 iid);
diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index 9ed822fc5589..61d7fecc4899 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -255,6 +255,23 @@ enum KVM_RISCV_SBI_EXT_ID {
  */
 #define KVM_DEV_RISCV_AIA_GRP_APLIC		3
 
+/*
+ * The lower 12-bits of the device attribute type contains the iselect
+ * value of the IMSIC register (range 0x70-0xFF) whereas the higher order
+ * bits contains the VCPU id.
+ */
+#define KVM_DEV_RISCV_AIA_GRP_IMSIC		4
+#define KVM_DEV_RISCV_AIA_IMSIC_ISEL_BITS	12
+#define KVM_DEV_RISCV_AIA_IMSIC_ISEL_MASK	\
+		((1U << KVM_DEV_RISCV_AIA_IMSIC_ISEL_BITS) - 1)
+#define KVM_DEV_RISCV_AIA_IMSIC_MKATTR(__vcpu, __isel)	\
+		(((__vcpu) << KVM_DEV_RISCV_AIA_IMSIC_ISEL_BITS) | \
+		 ((__isel) & KVM_DEV_RISCV_AIA_IMSIC_ISEL_MASK))
+#define KVM_DEV_RISCV_AIA_IMSIC_GET_ISEL(__attr)	\
+		((__attr) & KVM_DEV_RISCV_AIA_IMSIC_ISEL_MASK)
+#define KVM_DEV_RISCV_AIA_IMSIC_GET_VCPU(__attr)	\
+		((__attr) >> KVM_DEV_RISCV_AIA_IMSIC_ISEL_BITS)
+
 /* One single KVM irqchip, ie. the AIA */
 #define KVM_NR_IRQCHIPS			1
 
diff --git a/arch/riscv/kvm/aia_device.c b/arch/riscv/kvm/aia_device.c
index 17dba92a90e1..ac7bd98301a3 100644
--- a/arch/riscv/kvm/aia_device.c
+++ b/arch/riscv/kvm/aia_device.c
@@ -326,7 +326,7 @@ static int aia_set_attr(struct kvm_device *dev, struct kvm_device_attr *attr)
 	u32 nr;
 	u64 addr;
 	int nr_vcpus, r = -ENXIO;
-	unsigned long type = (unsigned long)attr->attr;
+	unsigned long v, type = (unsigned long)attr->attr;
 	void __user *uaddr = (void __user *)(long)attr->addr;
 
 	switch (attr->group) {
@@ -373,6 +373,15 @@ static int aia_set_attr(struct kvm_device *dev, struct kvm_device_attr *attr)
 		r = kvm_riscv_aia_aplic_set_attr(dev->kvm, type, nr);
 		mutex_unlock(&dev->kvm->lock);
 
+		break;
+	case KVM_DEV_RISCV_AIA_GRP_IMSIC:
+		if (copy_from_user(&v, uaddr, sizeof(v)))
+			return -EFAULT;
+
+		mutex_lock(&dev->kvm->lock);
+		r = kvm_riscv_aia_imsic_rw_attr(dev->kvm, type, true, &v);
+		mutex_unlock(&dev->kvm->lock);
+
 		break;
 	}
 
@@ -385,7 +394,7 @@ static int aia_get_attr(struct kvm_device *dev, struct kvm_device_attr *attr)
 	u64 addr;
 	int nr_vcpus, r = -ENXIO;
 	void __user *uaddr = (void __user *)(long)attr->addr;
-	unsigned long type = (unsigned long)attr->attr;
+	unsigned long v, type = (unsigned long)attr->attr;
 
 	switch (attr->group) {
 	case KVM_DEV_RISCV_AIA_GRP_CONFIG:
@@ -434,6 +443,20 @@ static int aia_get_attr(struct kvm_device *dev, struct kvm_device_attr *attr)
 		if (copy_to_user(uaddr, &nr, sizeof(nr)))
 			return -EFAULT;
 
+		break;
+	case KVM_DEV_RISCV_AIA_GRP_IMSIC:
+		if (copy_from_user(&v, uaddr, sizeof(v)))
+			return -EFAULT;
+
+		mutex_lock(&dev->kvm->lock);
+		r = kvm_riscv_aia_imsic_rw_attr(dev->kvm, type, false, &v);
+		mutex_unlock(&dev->kvm->lock);
+		if (r)
+			return r;
+
+		if (copy_to_user(uaddr, &v, sizeof(v)))
+			return -EFAULT;
+
 		break;
 	}
 
@@ -472,6 +495,8 @@ static int aia_has_attr(struct kvm_device *dev, struct kvm_device_attr *attr)
 		break;
 	case KVM_DEV_RISCV_AIA_GRP_APLIC:
 		return kvm_riscv_aia_aplic_has_attr(dev->kvm, attr->attr);
+	case KVM_DEV_RISCV_AIA_GRP_IMSIC:
+		return kvm_riscv_aia_imsic_has_attr(dev->kvm, attr->attr);
 	}
 
 	return -ENXIO;
diff --git a/arch/riscv/kvm/aia_imsic.c b/arch/riscv/kvm/aia_imsic.c
index 2dc09dcb8ab5..8f108cfa80e5 100644
--- a/arch/riscv/kvm/aia_imsic.c
+++ b/arch/riscv/kvm/aia_imsic.c
@@ -277,6 +277,33 @@ static u32 imsic_mrif_topei(struct imsic_mrif *mrif, u32 nr_eix, u32 nr_msis)
 	return 0;
 }
 
+static int imsic_mrif_isel_check(u32 nr_eix, unsigned long isel)
+{
+	u32 num = 0;
+
+	switch (isel) {
+	case IMSIC_EIDELIVERY:
+	case IMSIC_EITHRESHOLD:
+		break;
+	case IMSIC_EIP0 ... IMSIC_EIP63:
+		num = isel - IMSIC_EIP0;
+		break;
+	case IMSIC_EIE0 ... IMSIC_EIE63:
+		num = isel - IMSIC_EIE0;
+		break;
+	default:
+		return -ENOENT;
+	};
+#ifndef CONFIG_32BIT
+	if (num & 0x1)
+		return -EINVAL;
+#endif
+	if ((num / 2) >= nr_eix)
+		return -EINVAL;
+
+	return 0;
+}
+
 static int imsic_mrif_rmw(struct imsic_mrif *mrif, u32 nr_eix,
 			  unsigned long isel, unsigned long *val,
 			  unsigned long new_val, unsigned long wr_mask)
@@ -407,6 +434,86 @@ static void imsic_vsfile_read(int vsfile_hgei, int vsfile_cpu, u32 nr_eix,
 			 imsic_vsfile_local_read, &idata, 1);
 }
 
+struct imsic_vsfile_rw_data {
+	int hgei;
+	int isel;
+	bool write;
+	unsigned long val;
+};
+
+static void imsic_vsfile_local_rw(void *data)
+{
+	struct imsic_vsfile_rw_data *idata = data;
+	unsigned long new_hstatus, old_hstatus, old_vsiselect;
+
+	old_vsiselect = csr_read(CSR_VSISELECT);
+	old_hstatus = csr_read(CSR_HSTATUS);
+	new_hstatus = old_hstatus & ~HSTATUS_VGEIN;
+	new_hstatus |= ((unsigned long)idata->hgei) << HSTATUS_VGEIN_SHIFT;
+	csr_write(CSR_HSTATUS, new_hstatus);
+
+	switch (idata->isel) {
+	case IMSIC_EIDELIVERY:
+		if (idata->write)
+			imsic_vs_csr_write(IMSIC_EIDELIVERY, idata->val);
+		else
+			idata->val = imsic_vs_csr_read(IMSIC_EIDELIVERY);
+		break;
+	case IMSIC_EITHRESHOLD:
+		if (idata->write)
+			imsic_vs_csr_write(IMSIC_EITHRESHOLD, idata->val);
+		else
+			idata->val = imsic_vs_csr_read(IMSIC_EITHRESHOLD);
+		break;
+	case IMSIC_EIP0 ... IMSIC_EIP63:
+	case IMSIC_EIE0 ... IMSIC_EIE63:
+#ifndef CONFIG_32BIT
+		if (idata->isel & 0x1)
+			break;
+#endif
+		if (idata->write)
+			imsic_eix_write(idata->isel, idata->val);
+		else
+			idata->val = imsic_eix_read(idata->isel);
+		break;
+	default:
+		break;
+	}
+
+	csr_write(CSR_HSTATUS, old_hstatus);
+	csr_write(CSR_VSISELECT, old_vsiselect);
+}
+
+static int imsic_vsfile_rw(int vsfile_hgei, int vsfile_cpu, u32 nr_eix,
+			   unsigned long isel, bool write,
+			   unsigned long *val)
+{
+	int rc;
+	struct imsic_vsfile_rw_data rdata;
+
+	/* We can only access register if we have a IMSIC VS-file */
+	if (vsfile_cpu < 0 || vsfile_hgei <= 0)
+		return -EINVAL;
+
+	/* Check IMSIC register iselect */
+	rc = imsic_mrif_isel_check(nr_eix, isel);
+	if (rc)
+		return rc;
+
+	/* We can only access register on local CPU */
+	rdata.hgei = vsfile_hgei;
+	rdata.isel = isel;
+	rdata.write = write;
+	rdata.val = (write) ? *val : 0;
+	on_each_cpu_mask(cpumask_of(vsfile_cpu),
+			 imsic_vsfile_local_rw, &rdata, 1);
+
+	if (!write)
+		*val = rdata.val;
+
+	return 0;
+}
+
 static void imsic_vsfile_local_clear(int vsfile_hgei, u32 nr_eix)
 {
 	u32 i;
@@ -758,6 +865,69 @@ int kvm_riscv_vcpu_aia_imsic_rmw(struct kvm_vcpu *vcpu, unsigned long isel,
 	return rc;
 }
 
+int kvm_riscv_aia_imsic_rw_attr(struct kvm *kvm, unsigned long type,
+				bool write, unsigned long *val)
+{
+	u32 isel, vcpu_id;
+	unsigned long flags;
+	struct imsic *imsic;
+	struct kvm_vcpu *vcpu;
+	int rc, vsfile_hgei, vsfile_cpu;
+
+	if (!kvm_riscv_aia_initialized(kvm))
+		return -ENODEV;
+
+	vcpu_id = KVM_DEV_RISCV_AIA_IMSIC_GET_VCPU(type);
+	vcpu = kvm_get_vcpu_by_id(kvm, vcpu_id);
+	if (!vcpu)
+		return -ENODEV;
+
+	isel = KVM_DEV_RISCV_AIA_IMSIC_GET_ISEL(type);
+	imsic = vcpu->arch.aia_context.imsic_state;
+
+	read_lock_irqsave(&imsic->vsfile_lock, flags);
+
+	rc = 0;
+	vsfile_hgei = imsic->vsfile_hgei;
+	vsfile_cpu = imsic->vsfile_cpu;
+	if (vsfile_cpu < 0) {
+		if (write) {
+			rc = imsic_mrif_rmw(imsic->swfile, imsic->nr_eix,
+					    isel, NULL, *val, -1UL);
+			imsic_swfile_extirq_update(vcpu);
+		} else
+			rc = imsic_mrif_rmw(imsic->swfile, imsic->nr_eix,
+					    isel, val, 0, 0);
+	}
+
+	read_unlock_irqrestore(&imsic->vsfile_lock, flags);
+
+	if (!rc && vsfile_cpu >= 0)
+		rc = imsic_vsfile_rw(vsfile_hgei, vsfile_cpu, imsic->nr_eix,
+				     isel, write, val);
+
+	return rc;
+}
+
+int kvm_riscv_aia_imsic_has_attr(struct kvm *kvm, unsigned long type)
+{
+	u32 isel, vcpu_id;
+	struct imsic *imsic;
+	struct kvm_vcpu *vcpu;
+
+	if (!kvm_riscv_aia_initialized(kvm))
+		return -ENODEV;
+
+	vcpu_id = KVM_DEV_RISCV_AIA_IMSIC_GET_VCPU(type);
+	vcpu = kvm_get_vcpu_by_id(kvm, vcpu_id);
+	if (!vcpu)
+		return -ENODEV;
+
+	isel = KVM_DEV_RISCV_AIA_IMSIC_GET_ISEL(type);
+	imsic = vcpu->arch.aia_context.imsic_state;
+	return imsic_mrif_isel_check(imsic->nr_eix, isel);
+}
+
 void kvm_riscv_vcpu_aia_imsic_reset(struct kvm_vcpu *vcpu)
 {
 	struct imsic *imsic = vcpu->arch.aia_context.imsic_state;
-- 
2.34.1

