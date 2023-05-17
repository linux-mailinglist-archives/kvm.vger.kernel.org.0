Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2391C7065A8
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 12:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjEQKxF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 06:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbjEQKxD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 06:53:03 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 618A665B8
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 03:52:32 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id 46e09a7af769-6ab087111faso259552a34.3
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 03:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1684320738; x=1686912738;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dngHPbj2taaPJ4zw9A5mqBI4KkyH0kWROuwSLqGu8yk=;
        b=hhJMV2B/9IECgQ/g5k2ORQgtn3BFx5Q+JH9ZsPimeep693CUL+Yhrp9qWBgfPXOwuA
         IGEVUOqs/1RmZZvlpo3LcnjMMz1ot3DIrKBpKIe7H7+29xCziA5NHgAPM5X8KBu9hkXL
         3d5uvRUJGuFqWO2/Hyic6B4ZgZjvQaBxjEPeEs6MQ/LW6e3LnvL2kVWDEMEHGPuJQKdR
         e9t6teptOJ080uzvjf1/A+x1Qvggt2qlUbTh9sxWuEjBzc2K3zIPxpmZ/2cAdvpPKY65
         qfd7y59JC2siNhnEh5hROKUlGVM4L0rVrBZpeIh72aSdOzBkETJQj3rslUifMlrvKRqy
         NHXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684320738; x=1686912738;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dngHPbj2taaPJ4zw9A5mqBI4KkyH0kWROuwSLqGu8yk=;
        b=h0hjiGyqLC2aTVeEfgD1Z0DxwQNNrmr01TnX4Xu6AsHGCtdQpFNOrI/6xHhNBkjAGW
         yUmKlE8fOSBWmhz8Inpskl5k/2pJmcfa9nwM48Jop0m1/S1s2ldc2tV531glb709VgLf
         O5CcuFoRcIsBOYzXHE6zeqydGXlIvE9mEIOezRHQQzNBOl9Ontb1Si2fReY+kqihEDGq
         USdI0m1MNrbrmcg/gfSv8gE7PNMDyLGZ9Sj8cq0vnJOfEVklQpmnzqOV0RpBHkIBAGKh
         VTh9xXqTQhGPZRlcdCqRwkeOUKDB9cr56NeuRanLxbbmDvMqVO1dP6ZFfwemYZ22MquN
         aYPA==
X-Gm-Message-State: AC+VfDwJvkv4Acer1RtmOQOWWYFM2zCG1TB+i/teV75lrIzuBZaoguO4
        dMyUIB5fDmWdzVZUq2WOkkbt/Q==
X-Google-Smtp-Source: ACHHUZ7iW57UFKs2B+H+HTziLMq4Hsfch0k6W2ytbGMiOsnhlc7TT1jZY7AMNSqNdoo7LbtyfYN0+w==
X-Received: by 2002:a05:6830:1482:b0:6aa:fdcc:47b with SMTP id s2-20020a056830148200b006aafdcc047bmr13476623otq.33.1684320737680;
        Wed, 17 May 2023 03:52:17 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id w1-20020a9d77c1000000b006ade3815527sm2279896otl.22.2023.05.17.03.52.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 03:52:17 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 06/10] RISC-V: KVM: Implement device interface for AIA irqchip
Date:   Wed, 17 May 2023 16:21:31 +0530
Message-Id: <20230517105135.1871868-7-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230517105135.1871868-1-apatel@ventanamicro.com>
References: <20230517105135.1871868-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We implement KVM device interface for in-kernel AIA irqchip so that
user-space can use KVM device ioctls to create, configure, and destroy
in-kernel AIA irqchip.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_aia.h  | 132 +++++--
 arch/riscv/include/uapi/asm/kvm.h |  36 ++
 arch/riscv/kvm/Makefile           |   1 +
 arch/riscv/kvm/aia.c              |  11 +
 arch/riscv/kvm/aia_device.c       | 622 ++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h          |   2 +
 6 files changed, 762 insertions(+), 42 deletions(-)
 create mode 100644 arch/riscv/kvm/aia_device.c

diff --git a/arch/riscv/include/asm/kvm_aia.h b/arch/riscv/include/asm/kvm_aia.h
index 3bc0a0e47a15..a1281ebc9b92 100644
--- a/arch/riscv/include/asm/kvm_aia.h
+++ b/arch/riscv/include/asm/kvm_aia.h
@@ -20,6 +20,33 @@ struct kvm_aia {
 
 	/* In-kernel irqchip initialized */
 	bool		initialized;
+
+	/* Virtualization mode (Emulation, HW Accelerated, or Auto) */
+	u32		mode;
+
+	/* Number of MSIs */
+	u32		nr_ids;
+
+	/* Number of wired IRQs */
+	u32		nr_sources;
+
+	/* Number of group bits in IMSIC address */
+	u32		nr_group_bits;
+
+	/* Position of group bits in IMSIC address */
+	u32		nr_group_shift;
+
+	/* Number of hart bits in IMSIC address */
+	u32		nr_hart_bits;
+
+	/* Number of guest bits in IMSIC address */
+	u32		nr_guest_bits;
+
+	/* Guest physical address of APLIC */
+	gpa_t		aplic_addr;
+
+	/* Internal state of APLIC */
+	void		*aplic_state;
 };
 
 struct kvm_vcpu_aia_csr {
@@ -38,8 +65,19 @@ struct kvm_vcpu_aia {
 
 	/* CPU AIA CSR context upon Guest VCPU reset */
 	struct kvm_vcpu_aia_csr guest_reset_csr;
+
+	/* Guest physical address of IMSIC for this VCPU */
+	gpa_t		imsic_addr;
+
+	/* HART index of IMSIC extacted from guest physical address */
+	u32		hart_index;
+
+	/* Internal state of IMSIC for this VCPU */
+	void		*imsic_state;
 };
 
+#define KVM_RISCV_AIA_UNDEF_ADDR	(-1)
+
 #define kvm_riscv_aia_initialized(k)	((k)->arch.aia.initialized)
 
 #define irqchip_in_kernel(k)		((k)->arch.aia.in_kernel)
@@ -50,10 +88,17 @@ DECLARE_STATIC_KEY_FALSE(kvm_riscv_aia_available);
 #define kvm_riscv_aia_available() \
 	static_branch_unlikely(&kvm_riscv_aia_available)
 
+extern struct kvm_device_ops kvm_riscv_aia_device_ops;
+
 static inline void kvm_riscv_vcpu_aia_imsic_release(struct kvm_vcpu *vcpu)
 {
 }
 
+static inline int kvm_riscv_vcpu_aia_imsic_update(struct kvm_vcpu *vcpu)
+{
+	return 1;
+}
+
 #define KVM_RISCV_AIA_IMSIC_TOPEI	(ISELECT_MASK + 1)
 static inline int kvm_riscv_vcpu_aia_imsic_rmw(struct kvm_vcpu *vcpu,
 					       unsigned long isel,
@@ -64,6 +109,41 @@ static inline int kvm_riscv_vcpu_aia_imsic_rmw(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static inline void kvm_riscv_vcpu_aia_imsic_reset(struct kvm_vcpu *vcpu)
+{
+}
+
+static inline int kvm_riscv_vcpu_aia_imsic_inject(struct kvm_vcpu *vcpu,
+						  u32 guest_index, u32 offset,
+						  u32 iid)
+{
+	return 0;
+}
+
+static inline int kvm_riscv_vcpu_aia_imsic_init(struct kvm_vcpu *vcpu)
+{
+	return 0;
+}
+
+static inline void kvm_riscv_vcpu_aia_imsic_cleanup(struct kvm_vcpu *vcpu)
+{
+}
+
+static inline int kvm_riscv_aia_aplic_inject(struct kvm *kvm,
+					     u32 source, bool level)
+{
+	return 0;
+}
+
+static inline int kvm_riscv_aia_aplic_init(struct kvm *kvm)
+{
+	return 0;
+}
+
+static inline void kvm_riscv_aia_aplic_cleanup(struct kvm *kvm)
+{
+}
+
 #ifdef CONFIG_32BIT
 void kvm_riscv_vcpu_aia_flush_interrupts(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_aia_sync_interrupts(struct kvm_vcpu *vcpu);
@@ -99,50 +179,18 @@ int kvm_riscv_vcpu_aia_rmw_ireg(struct kvm_vcpu *vcpu, unsigned int csr_num,
 { .base = CSR_SIREG,      .count = 1, .func = kvm_riscv_vcpu_aia_rmw_ireg }, \
 { .base = CSR_STOPEI,     .count = 1, .func = kvm_riscv_vcpu_aia_rmw_topei },
 
-static inline int kvm_riscv_vcpu_aia_update(struct kvm_vcpu *vcpu)
-{
-	return 1;
-}
-
-static inline void kvm_riscv_vcpu_aia_reset(struct kvm_vcpu *vcpu)
-{
-}
-
-static inline int kvm_riscv_vcpu_aia_init(struct kvm_vcpu *vcpu)
-{
-	return 0;
-}
-
-static inline void kvm_riscv_vcpu_aia_deinit(struct kvm_vcpu *vcpu)
-{
-}
-
-static inline int kvm_riscv_aia_inject_msi_by_id(struct kvm *kvm,
-						 u32 hart_index,
-						 u32 guest_index, u32 iid)
-{
-	return 0;
-}
-
-static inline int kvm_riscv_aia_inject_msi(struct kvm *kvm,
-					   struct kvm_msi *msi)
-{
-	return 0;
-}
+int kvm_riscv_vcpu_aia_update(struct kvm_vcpu *vcpu);
+void kvm_riscv_vcpu_aia_reset(struct kvm_vcpu *vcpu);
+int kvm_riscv_vcpu_aia_init(struct kvm_vcpu *vcpu);
+void kvm_riscv_vcpu_aia_deinit(struct kvm_vcpu *vcpu);
 
-static inline int kvm_riscv_aia_inject_irq(struct kvm *kvm,
-					   unsigned int irq, bool level)
-{
-	return 0;
-}
+int kvm_riscv_aia_inject_msi_by_id(struct kvm *kvm, u32 hart_index,
+				   u32 guest_index, u32 iid);
+int kvm_riscv_aia_inject_msi(struct kvm *kvm, struct kvm_msi *msi);
+int kvm_riscv_aia_inject_irq(struct kvm *kvm, unsigned int irq, bool level);
 
-static inline void kvm_riscv_aia_init_vm(struct kvm *kvm)
-{
-}
-
-static inline void kvm_riscv_aia_destroy_vm(struct kvm *kvm)
-{
-}
+void kvm_riscv_aia_init_vm(struct kvm *kvm);
+void kvm_riscv_aia_destroy_vm(struct kvm *kvm);
 
 int kvm_riscv_aia_alloc_hgei(int cpu, struct kvm_vcpu *owner,
 			     void __iomem **hgei_va, phys_addr_t *hgei_pa);
diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index 332d4a274891..57f8d8bb498e 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -204,6 +204,42 @@ enum KVM_RISCV_SBI_EXT_ID {
 #define KVM_REG_RISCV_SBI_MULTI_REG_LAST	\
 		KVM_REG_RISCV_SBI_MULTI_REG(KVM_RISCV_SBI_EXT_MAX - 1)
 
+/* Device Control API: RISC-V AIA */
+#define KVM_DEV_RISCV_APLIC_ALIGN		0x1000
+#define KVM_DEV_RISCV_APLIC_SIZE		0x4000
+#define KVM_DEV_RISCV_APLIC_MAX_HARTS		0x4000
+#define KVM_DEV_RISCV_IMSIC_ALIGN		0x1000
+#define KVM_DEV_RISCV_IMSIC_SIZE		0x1000
+
+#define KVM_DEV_RISCV_AIA_GRP_CONFIG		0
+#define KVM_DEV_RISCV_AIA_CONFIG_MODE		0
+#define KVM_DEV_RISCV_AIA_CONFIG_IDS		1
+#define KVM_DEV_RISCV_AIA_CONFIG_SRCS		2
+#define KVM_DEV_RISCV_AIA_CONFIG_GROUP_BITS	3
+#define KVM_DEV_RISCV_AIA_CONFIG_GROUP_SHIFT	4
+#define KVM_DEV_RISCV_AIA_CONFIG_HART_BITS	5
+#define KVM_DEV_RISCV_AIA_CONFIG_GUEST_BITS	6
+#define KVM_DEV_RISCV_AIA_MODE_EMUL		0
+#define KVM_DEV_RISCV_AIA_MODE_HWACCEL		1
+#define KVM_DEV_RISCV_AIA_MODE_AUTO		2
+#define KVM_DEV_RISCV_AIA_IDS_MIN		63
+#define KVM_DEV_RISCV_AIA_IDS_MAX		2048
+#define KVM_DEV_RISCV_AIA_SRCS_MAX		1024
+#define KVM_DEV_RISCV_AIA_GROUP_BITS_MAX	8
+#define KVM_DEV_RISCV_AIA_GROUP_SHIFT_MIN	24
+#define KVM_DEV_RISCV_AIA_GROUP_SHIFT_MAX	56
+#define KVM_DEV_RISCV_AIA_HART_BITS_MAX	16
+#define KVM_DEV_RISCV_AIA_GUEST_BITS_MAX	8
+
+#define KVM_DEV_RISCV_AIA_GRP_ADDR		1
+#define KVM_DEV_RISCV_AIA_ADDR_APLIC		0
+#define KVM_DEV_RISCV_AIA_ADDR_IMSIC(__vcpu)	(1 + (__vcpu))
+#define KVM_DEV_RISCV_AIA_ADDR_MAX		\
+		(1 + KVM_DEV_RISCV_APLIC_MAX_HARTS)
+
+#define KVM_DEV_RISCV_AIA_GRP_CTRL		2
+#define KVM_DEV_RISCV_AIA_CTRL_INIT		0
+
 /* One single KVM irqchip, ie. the AIA */
 #define KVM_NR_IRQCHIPS			1
 
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index 8031b8912a0d..dd69ebe098bd 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -27,3 +27,4 @@ kvm-y += vcpu_sbi_hsm.o
 kvm-y += vcpu_timer.o
 kvm-$(CONFIG_RISCV_PMU_SBI) += vcpu_pmu.o vcpu_sbi_pmu.o
 kvm-y += aia.o
+kvm-y += aia_device.o
diff --git a/arch/riscv/kvm/aia.c b/arch/riscv/kvm/aia.c
index 18c442c15ff2..585a3b42c52c 100644
--- a/arch/riscv/kvm/aia.c
+++ b/arch/riscv/kvm/aia.c
@@ -631,6 +631,14 @@ int kvm_riscv_aia_init(void)
 	if (rc)
 		return rc;
 
+	/* Register device operations */
+	rc = kvm_register_device_ops(&kvm_riscv_aia_device_ops,
+				     KVM_DEV_TYPE_RISCV_AIA);
+	if (rc) {
+		aia_hgei_exit();
+		return rc;
+	}
+
 	/* Enable KVM AIA support */
 	static_branch_enable(&kvm_riscv_aia_available);
 
@@ -642,6 +650,9 @@ void kvm_riscv_aia_exit(void)
 	if (!kvm_riscv_aia_available())
 		return;
 
+	/* Unregister device operations */
+	kvm_unregister_device_ops(KVM_DEV_TYPE_RISCV_AIA);
+
 	/* Cleanup the HGEI state */
 	aia_hgei_exit();
 }
diff --git a/arch/riscv/kvm/aia_device.c b/arch/riscv/kvm/aia_device.c
new file mode 100644
index 000000000000..a151fb357887
--- /dev/null
+++ b/arch/riscv/kvm/aia_device.c
@@ -0,0 +1,622 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2021 Western Digital Corporation or its affiliates.
+ * Copyright (C) 2022 Ventana Micro Systems Inc.
+ *
+ * Authors:
+ *	Anup Patel <apatel@ventanamicro.com>
+ */
+
+#include <linux/bits.h>
+#include <linux/kvm_host.h>
+#include <linux/uaccess.h>
+#include <asm/kvm_aia_imsic.h>
+
+static void unlock_vcpus(struct kvm *kvm, int vcpu_lock_idx)
+{
+	struct kvm_vcpu *tmp_vcpu;
+
+	for (; vcpu_lock_idx >= 0; vcpu_lock_idx--) {
+		tmp_vcpu = kvm_get_vcpu(kvm, vcpu_lock_idx);
+		mutex_unlock(&tmp_vcpu->mutex);
+	}
+}
+
+static void unlock_all_vcpus(struct kvm *kvm)
+{
+	unlock_vcpus(kvm, atomic_read(&kvm->online_vcpus) - 1);
+}
+
+static bool lock_all_vcpus(struct kvm *kvm)
+{
+	struct kvm_vcpu *tmp_vcpu;
+	unsigned long c;
+
+	kvm_for_each_vcpu(c, tmp_vcpu, kvm) {
+		if (!mutex_trylock(&tmp_vcpu->mutex)) {
+			unlock_vcpus(kvm, c - 1);
+			return false;
+		}
+	}
+
+	return true;
+}
+
+static int aia_create(struct kvm_device *dev, u32 type)
+{
+	int ret;
+	unsigned long i;
+	struct kvm *kvm = dev->kvm;
+	struct kvm_vcpu *vcpu;
+
+	if (irqchip_in_kernel(kvm))
+		return -EEXIST;
+
+	ret = -EBUSY;
+	if (!lock_all_vcpus(kvm))
+		return ret;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (vcpu->arch.ran_atleast_once)
+			goto out_unlock;
+	}
+	ret = 0;
+
+	kvm->arch.aia.in_kernel = true;
+
+out_unlock:
+	unlock_all_vcpus(kvm);
+	return ret;
+}
+
+static void aia_destroy(struct kvm_device *dev)
+{
+	kfree(dev);
+}
+
+static int aia_config(struct kvm *kvm, unsigned long type,
+		      u32 *nr, bool write)
+{
+	struct kvm_aia *aia = &kvm->arch.aia;
+
+	/* Writes can only be done before irqchip is initialized */
+	if (write && kvm_riscv_aia_initialized(kvm))
+		return -EBUSY;
+
+	switch (type) {
+	case KVM_DEV_RISCV_AIA_CONFIG_MODE:
+		if (write) {
+			switch (*nr) {
+			case KVM_DEV_RISCV_AIA_MODE_EMUL:
+				break;
+			case KVM_DEV_RISCV_AIA_MODE_HWACCEL:
+			case KVM_DEV_RISCV_AIA_MODE_AUTO:
+				/*
+				 * HW Acceleration and Auto modes only
+				 * supported on host with non-zero guest
+				 * external interrupts (i.e. non-zero
+				 * VS-level IMSIC pages).
+				 */
+				if (!kvm_riscv_aia_nr_hgei)
+					return -EINVAL;
+				break;
+			default:
+				return -EINVAL;
+			};
+			aia->mode = *nr;
+		} else
+			*nr = aia->mode;
+		break;
+	case KVM_DEV_RISCV_AIA_CONFIG_IDS:
+		if (write) {
+			if ((*nr < KVM_DEV_RISCV_AIA_IDS_MIN) ||
+			    (*nr >= KVM_DEV_RISCV_AIA_IDS_MAX) ||
+			    (*nr & KVM_DEV_RISCV_AIA_IDS_MIN) ||
+			    (kvm_riscv_aia_max_ids <= *nr))
+				return -EINVAL;
+			aia->nr_ids = *nr;
+		} else
+			*nr = aia->nr_ids;
+		break;
+	case KVM_DEV_RISCV_AIA_CONFIG_SRCS:
+		if (write) {
+			if ((*nr >= KVM_DEV_RISCV_AIA_SRCS_MAX) ||
+			    (*nr >= kvm_riscv_aia_max_ids))
+				return -EINVAL;
+			aia->nr_sources = *nr;
+		} else
+			*nr = aia->nr_sources;
+		break;
+	case KVM_DEV_RISCV_AIA_CONFIG_GROUP_BITS:
+		if (write) {
+			if (*nr >= KVM_DEV_RISCV_AIA_GROUP_BITS_MAX)
+				return -EINVAL;
+			aia->nr_group_bits = *nr;
+		} else
+			*nr = aia->nr_group_bits;
+		break;
+	case KVM_DEV_RISCV_AIA_CONFIG_GROUP_SHIFT:
+		if (write) {
+			if ((*nr < KVM_DEV_RISCV_AIA_GROUP_SHIFT_MIN) ||
+			    (*nr >= KVM_DEV_RISCV_AIA_GROUP_SHIFT_MAX))
+				return -EINVAL;
+			aia->nr_group_shift = *nr;
+		} else
+			*nr = aia->nr_group_shift;
+		break;
+	case KVM_DEV_RISCV_AIA_CONFIG_HART_BITS:
+		if (write) {
+			if (*nr >= KVM_DEV_RISCV_AIA_HART_BITS_MAX)
+				return -EINVAL;
+			aia->nr_hart_bits = *nr;
+		} else
+			*nr = aia->nr_hart_bits;
+		break;
+	case KVM_DEV_RISCV_AIA_CONFIG_GUEST_BITS:
+		if (write) {
+			if (*nr >= KVM_DEV_RISCV_AIA_GUEST_BITS_MAX)
+				return -EINVAL;
+			aia->nr_guest_bits = *nr;
+		} else
+			*nr = aia->nr_guest_bits;
+		break;
+	default:
+		return -ENXIO;
+	};
+
+	return 0;
+}
+
+static int aia_aplic_addr(struct kvm *kvm, u64 *addr, bool write)
+{
+	struct kvm_aia *aia = &kvm->arch.aia;
+
+	if (write) {
+		/* Writes can only be done before irqchip is initialized */
+		if (kvm_riscv_aia_initialized(kvm))
+			return -EBUSY;
+
+		if (*addr & (KVM_DEV_RISCV_APLIC_ALIGN - 1))
+			return -EINVAL;
+
+		aia->aplic_addr = *addr;
+	} else
+		*addr = aia->aplic_addr;
+
+	return 0;
+}
+
+static int aia_imsic_addr(struct kvm *kvm, u64 *addr,
+			  unsigned long vcpu_idx, bool write)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vcpu_aia *vcpu_aia;
+
+	vcpu = kvm_get_vcpu(kvm, vcpu_idx);
+	if (!vcpu)
+		return -EINVAL;
+	vcpu_aia = &vcpu->arch.aia_context;
+
+	if (write) {
+		/* Writes can only be done before irqchip is initialized */
+		if (kvm_riscv_aia_initialized(kvm))
+			return -EBUSY;
+
+		if (*addr & (KVM_DEV_RISCV_IMSIC_ALIGN - 1))
+			return -EINVAL;
+	}
+
+	mutex_lock(&vcpu->mutex);
+	if (write)
+		vcpu_aia->imsic_addr = *addr;
+	else
+		*addr = vcpu_aia->imsic_addr;
+	mutex_unlock(&vcpu->mutex);
+
+	return 0;
+}
+
+static gpa_t aia_imsic_ppn(struct kvm_aia *aia, gpa_t addr)
+{
+	u32 h, l;
+	gpa_t mask = 0;
+
+	h = aia->nr_hart_bits + aia->nr_guest_bits +
+	    IMSIC_MMIO_PAGE_SHIFT - 1;
+	mask = GENMASK_ULL(h, 0);
+
+	if (aia->nr_group_bits) {
+		h = aia->nr_group_bits + aia->nr_group_shift - 1;
+		l = aia->nr_group_shift;
+		mask |= GENMASK_ULL(h, l);
+	}
+
+	return (addr & ~mask) >> IMSIC_MMIO_PAGE_SHIFT;
+}
+
+static u32 aia_imsic_hart_index(struct kvm_aia *aia, gpa_t addr)
+{
+	u32 hart, group = 0;
+
+	hart = (addr >> (aia->nr_guest_bits + IMSIC_MMIO_PAGE_SHIFT)) &
+		GENMASK_ULL(aia->nr_hart_bits - 1, 0);
+	if (aia->nr_group_bits)
+		group = (addr >> aia->nr_group_shift) &
+			GENMASK_ULL(aia->nr_group_bits - 1, 0);
+
+	return (group << aia->nr_hart_bits) | hart;
+}
+
+static int aia_init(struct kvm *kvm)
+{
+	int ret, i;
+	unsigned long idx;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vcpu_aia *vaia;
+	struct kvm_aia *aia = &kvm->arch.aia;
+	gpa_t base_ppn = KVM_RISCV_AIA_UNDEF_ADDR;
+
+	/* Irqchip can be initialized only once */
+	if (kvm_riscv_aia_initialized(kvm))
+		return -EBUSY;
+
+	/* We might be in the middle of creating a VCPU? */
+	if (kvm->created_vcpus != atomic_read(&kvm->online_vcpus))
+		return -EBUSY;
+
+	/* Number of sources should be less than or equals number of IDs */
+	if (aia->nr_ids < aia->nr_sources)
+		return -EINVAL;
+
+	/* APLIC base is required for non-zero number of sources */
+	if (aia->nr_sources && aia->aplic_addr == KVM_RISCV_AIA_UNDEF_ADDR)
+		return -EINVAL;
+
+	/* Initialize APLIC */
+	ret = kvm_riscv_aia_aplic_init(kvm);
+	if (ret)
+		return ret;
+
+	/* Iterate over each VCPU */
+	kvm_for_each_vcpu(idx, vcpu, kvm) {
+		vaia = &vcpu->arch.aia_context;
+
+		/* IMSIC base is required */
+		if (vaia->imsic_addr == KVM_RISCV_AIA_UNDEF_ADDR) {
+			ret = -EINVAL;
+			goto fail_cleanup_imsics;
+		}
+
+		/* All IMSICs should have matching base PPN */
+		if (base_ppn == KVM_RISCV_AIA_UNDEF_ADDR)
+			base_ppn = aia_imsic_ppn(aia, vaia->imsic_addr);
+		if (base_ppn != aia_imsic_ppn(aia, vaia->imsic_addr)) {
+			ret = -EINVAL;
+			goto fail_cleanup_imsics;
+		}
+
+		/* Update HART index of the IMSIC based on IMSIC base */
+		vaia->hart_index = aia_imsic_hart_index(aia,
+							vaia->imsic_addr);
+
+		/* Initialize IMSIC for this VCPU */
+		ret = kvm_riscv_vcpu_aia_imsic_init(vcpu);
+		if (ret)
+			goto fail_cleanup_imsics;
+	}
+
+	/* Set the initialized flag */
+	kvm->arch.aia.initialized = true;
+
+	return 0;
+
+fail_cleanup_imsics:
+	for (i = idx - 1; i >= 0; i--) {
+		vcpu = kvm_get_vcpu(kvm, i);
+		if (!vcpu)
+			continue;
+		kvm_riscv_vcpu_aia_imsic_cleanup(vcpu);
+	}
+	kvm_riscv_aia_aplic_cleanup(kvm);
+	return ret;
+}
+
+static int aia_set_attr(struct kvm_device *dev, struct kvm_device_attr *attr)
+{
+	u32 nr;
+	u64 addr;
+	int nr_vcpus, r = -ENXIO;
+	unsigned long type = (unsigned long)attr->attr;
+	void __user *uaddr = (void __user *)(long)attr->addr;
+
+	switch (attr->group) {
+	case KVM_DEV_RISCV_AIA_GRP_CONFIG:
+		if (copy_from_user(&nr, uaddr, sizeof(nr)))
+			return -EFAULT;
+
+		mutex_lock(&dev->kvm->lock);
+		r = aia_config(dev->kvm, type, &nr, true);
+		mutex_unlock(&dev->kvm->lock);
+
+		break;
+
+	case KVM_DEV_RISCV_AIA_GRP_ADDR:
+		if (copy_from_user(&addr, uaddr, sizeof(addr)))
+			return -EFAULT;
+
+		nr_vcpus = atomic_read(&dev->kvm->online_vcpus);
+		mutex_lock(&dev->kvm->lock);
+		if (type == KVM_DEV_RISCV_AIA_ADDR_APLIC)
+			r = aia_aplic_addr(dev->kvm, &addr, true);
+		else if (type < KVM_DEV_RISCV_AIA_ADDR_IMSIC(nr_vcpus))
+			r = aia_imsic_addr(dev->kvm, &addr,
+			    type - KVM_DEV_RISCV_AIA_ADDR_IMSIC(0), true);
+		mutex_unlock(&dev->kvm->lock);
+
+		break;
+
+	case KVM_DEV_RISCV_AIA_GRP_CTRL:
+		switch (type) {
+		case KVM_DEV_RISCV_AIA_CTRL_INIT:
+			mutex_lock(&dev->kvm->lock);
+			r = aia_init(dev->kvm);
+			mutex_unlock(&dev->kvm->lock);
+			break;
+		}
+
+		break;
+	}
+
+	return r;
+}
+
+static int aia_get_attr(struct kvm_device *dev, struct kvm_device_attr *attr)
+{
+	u32 nr;
+	u64 addr;
+	int nr_vcpus, r = -ENXIO;
+	void __user *uaddr = (void __user *)(long)attr->addr;
+	unsigned long type = (unsigned long)attr->attr;
+
+	switch (attr->group) {
+	case KVM_DEV_RISCV_AIA_GRP_CONFIG:
+		if (copy_from_user(&nr, uaddr, sizeof(nr)))
+			return -EFAULT;
+
+		mutex_lock(&dev->kvm->lock);
+		r = aia_config(dev->kvm, type, &nr, false);
+		mutex_unlock(&dev->kvm->lock);
+		if (r)
+			return r;
+
+		if (copy_to_user(uaddr, &nr, sizeof(nr)))
+			return -EFAULT;
+
+		break;
+	case KVM_DEV_RISCV_AIA_GRP_ADDR:
+		if (copy_from_user(&addr, uaddr, sizeof(addr)))
+			return -EFAULT;
+
+		nr_vcpus = atomic_read(&dev->kvm->online_vcpus);
+		mutex_lock(&dev->kvm->lock);
+		if (type == KVM_DEV_RISCV_AIA_ADDR_APLIC)
+			r = aia_aplic_addr(dev->kvm, &addr, false);
+		else if (type < KVM_DEV_RISCV_AIA_ADDR_IMSIC(nr_vcpus))
+			r = aia_imsic_addr(dev->kvm, &addr,
+			    type - KVM_DEV_RISCV_AIA_ADDR_IMSIC(0), false);
+		mutex_unlock(&dev->kvm->lock);
+		if (r)
+			return r;
+
+		if (copy_to_user(uaddr, &addr, sizeof(addr)))
+			return -EFAULT;
+
+		break;
+	}
+
+	return r;
+}
+
+static int aia_has_attr(struct kvm_device *dev, struct kvm_device_attr *attr)
+{
+	int nr_vcpus;
+
+	switch (attr->group) {
+	case KVM_DEV_RISCV_AIA_GRP_CONFIG:
+		switch (attr->attr) {
+		case KVM_DEV_RISCV_AIA_CONFIG_MODE:
+		case KVM_DEV_RISCV_AIA_CONFIG_IDS:
+		case KVM_DEV_RISCV_AIA_CONFIG_SRCS:
+		case KVM_DEV_RISCV_AIA_CONFIG_GROUP_BITS:
+		case KVM_DEV_RISCV_AIA_CONFIG_GROUP_SHIFT:
+		case KVM_DEV_RISCV_AIA_CONFIG_HART_BITS:
+		case KVM_DEV_RISCV_AIA_CONFIG_GUEST_BITS:
+			return 0;
+		}
+		break;
+	case KVM_DEV_RISCV_AIA_GRP_ADDR:
+		nr_vcpus = atomic_read(&dev->kvm->online_vcpus);
+		if (attr->attr == KVM_DEV_RISCV_AIA_ADDR_APLIC)
+			return 0;
+		else if (attr->attr < KVM_DEV_RISCV_AIA_ADDR_IMSIC(nr_vcpus))
+			return 0;
+		break;
+	case KVM_DEV_RISCV_AIA_GRP_CTRL:
+		switch (attr->attr) {
+		case KVM_DEV_RISCV_AIA_CTRL_INIT:
+			return 0;
+		}
+		break;
+	}
+
+	return -ENXIO;
+}
+
+struct kvm_device_ops kvm_riscv_aia_device_ops = {
+	.name = "kvm-riscv-aia",
+	.create = aia_create,
+	.destroy = aia_destroy,
+	.set_attr = aia_set_attr,
+	.get_attr = aia_get_attr,
+	.has_attr = aia_has_attr,
+};
+
+int kvm_riscv_vcpu_aia_update(struct kvm_vcpu *vcpu)
+{
+	/* Proceed only if AIA was initialized successfully */
+	if (!kvm_riscv_aia_initialized(vcpu->kvm))
+		return 1;
+
+	/* Update the IMSIC HW state before entering guest mode */
+	return kvm_riscv_vcpu_aia_imsic_update(vcpu);
+}
+
+void kvm_riscv_vcpu_aia_reset(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_aia_csr *csr = &vcpu->arch.aia_context.guest_csr;
+	struct kvm_vcpu_aia_csr *reset_csr =
+				&vcpu->arch.aia_context.guest_reset_csr;
+
+	if (!kvm_riscv_aia_available())
+		return;
+	memcpy(csr, reset_csr, sizeof(*csr));
+
+	/* Proceed only if AIA was initialized successfully */
+	if (!kvm_riscv_aia_initialized(vcpu->kvm))
+		return;
+
+	/* Reset the IMSIC context */
+	kvm_riscv_vcpu_aia_imsic_reset(vcpu);
+}
+
+int kvm_riscv_vcpu_aia_init(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_aia *vaia = &vcpu->arch.aia_context;
+
+	if (!kvm_riscv_aia_available())
+		return 0;
+
+	/*
+	 * We don't do any memory allocations over here because these
+	 * will be done after AIA device is initialized by the user-space.
+	 *
+	 * Refer, aia_init() implementation for more details.
+	 */
+
+	/* Initialize default values in AIA vcpu context */
+	vaia->imsic_addr = KVM_RISCV_AIA_UNDEF_ADDR;
+	vaia->hart_index = vcpu->vcpu_idx;
+
+	return 0;
+}
+
+void kvm_riscv_vcpu_aia_deinit(struct kvm_vcpu *vcpu)
+{
+	/* Proceed only if AIA was initialized successfully */
+	if (!kvm_riscv_aia_initialized(vcpu->kvm))
+		return;
+
+	/* Cleanup IMSIC context */
+	kvm_riscv_vcpu_aia_imsic_cleanup(vcpu);
+}
+
+int kvm_riscv_aia_inject_msi_by_id(struct kvm *kvm, u32 hart_index,
+				   u32 guest_index, u32 iid)
+{
+	unsigned long idx;
+	struct kvm_vcpu *vcpu;
+
+	/* Proceed only if AIA was initialized successfully */
+	if (!kvm_riscv_aia_initialized(kvm))
+		return -EBUSY;
+
+	/* Inject MSI to matching VCPU */
+	kvm_for_each_vcpu(idx, vcpu, kvm) {
+		if (vcpu->arch.aia_context.hart_index == hart_index)
+			return kvm_riscv_vcpu_aia_imsic_inject(vcpu,
+							       guest_index,
+							       0, iid);
+	}
+
+	return 0;
+}
+
+int kvm_riscv_aia_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
+{
+	gpa_t tppn, ippn;
+	unsigned long idx;
+	struct kvm_vcpu *vcpu;
+	u32 g, toff, iid = msi->data;
+	struct kvm_aia *aia = &kvm->arch.aia;
+	gpa_t target = (((gpa_t)msi->address_hi) << 32) | msi->address_lo;
+
+	/* Proceed only if AIA was initialized successfully */
+	if (!kvm_riscv_aia_initialized(kvm))
+		return -EBUSY;
+
+	/* Convert target address to target PPN */
+	tppn = target >> IMSIC_MMIO_PAGE_SHIFT;
+
+	/* Extract and clear Guest ID from target PPN */
+	g = tppn & (BIT(aia->nr_guest_bits) - 1);
+	tppn &= ~((gpa_t)(BIT(aia->nr_guest_bits) - 1));
+
+	/* Inject MSI to matching VCPU */
+	kvm_for_each_vcpu(idx, vcpu, kvm) {
+		ippn = vcpu->arch.aia_context.imsic_addr >>
+					IMSIC_MMIO_PAGE_SHIFT;
+		if (ippn == tppn) {
+			toff = target & (IMSIC_MMIO_PAGE_SZ - 1);
+			return kvm_riscv_vcpu_aia_imsic_inject(vcpu, g,
+							       toff, iid);
+		}
+	}
+
+	return 0;
+}
+
+int kvm_riscv_aia_inject_irq(struct kvm *kvm, unsigned int irq, bool level)
+{
+	/* Proceed only if AIA was initialized successfully */
+	if (!kvm_riscv_aia_initialized(kvm))
+		return -EBUSY;
+
+	/* Inject interrupt level change in APLIC */
+	return kvm_riscv_aia_aplic_inject(kvm, irq, level);
+}
+
+void kvm_riscv_aia_init_vm(struct kvm *kvm)
+{
+	struct kvm_aia *aia = &kvm->arch.aia;
+
+	if (!kvm_riscv_aia_available())
+		return;
+
+	/*
+	 * We don't do any memory allocations over here because these
+	 * will be done after AIA device is initialized by the user-space.
+	 *
+	 * Refer, aia_init() implementation for more details.
+	 */
+
+	/* Initialize default values in AIA global context */
+	aia->mode = (kvm_riscv_aia_nr_hgei) ?
+		KVM_DEV_RISCV_AIA_MODE_AUTO : KVM_DEV_RISCV_AIA_MODE_EMUL;
+	aia->nr_ids = kvm_riscv_aia_max_ids - 1;
+	aia->nr_sources = 0;
+	aia->nr_group_bits = 0;
+	aia->nr_group_shift = KVM_DEV_RISCV_AIA_GROUP_SHIFT_MIN;
+	aia->nr_hart_bits = 0;
+	aia->nr_guest_bits = 0;
+	aia->aplic_addr = KVM_RISCV_AIA_UNDEF_ADDR;
+}
+
+void kvm_riscv_aia_destroy_vm(struct kvm *kvm)
+{
+	/* Proceed only if AIA was initialized successfully */
+	if (!kvm_riscv_aia_initialized(kvm))
+		return;
+
+	/* Cleanup APLIC context */
+	kvm_riscv_aia_aplic_cleanup(kvm);
+}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 737318b1c1d9..27ccd07898e1 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1442,6 +1442,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_XIVE		KVM_DEV_TYPE_XIVE
 	KVM_DEV_TYPE_ARM_PV_TIME,
 #define KVM_DEV_TYPE_ARM_PV_TIME	KVM_DEV_TYPE_ARM_PV_TIME
+	KVM_DEV_TYPE_RISCV_AIA,
+#define KVM_DEV_TYPE_RISCV_AIA		KVM_DEV_TYPE_RISCV_AIA
 	KVM_DEV_TYPE_MAX,
 };
 
-- 
2.34.1

