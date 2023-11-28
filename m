Return-Path: <kvm+bounces-2632-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BDF687FBD7C
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 15:56:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73F852816D0
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 14:56:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B55BA5C08F;
	Tue, 28 Nov 2023 14:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Ac1l3+8S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DAFB170B
	for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 06:56:42 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1cf7a8ab047so42855595ad.1
        for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 06:56:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1701183402; x=1701788202; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PbBabCqpKOAriwFvw90VUy4f2fqStiwMYR6pxTnYCDM=;
        b=Ac1l3+8SMVmRHWMcbKGDXqQniiLC2yjJ9swRquTj8EHPOxQKb9d4oY32DZ/oD4uoUN
         vsfO6iWevn0b/suFCCZKDv/pfHBo84t/EQgNyDrUv0ISjtF6hg2CJUrOqCzYJ9mP+MyP
         WjRJKt+RAHg4KbVTNbh/qJt1fZz/jMEWgSKHpt84Z4+i8fGlOVob6ju48ZhSeHCaBYFo
         aVEYXQv6XGVmkbCmXyH4KFnOCxgYCRKIsi9ITXfIFDe8/45M/+86VSz7TrxM1DiHsFTy
         LPl9Zw9SI8+x1foD9FQWLALAKz7cdtZA7R3p2dUJORdXWP0D5ILvt7c+eBbk86d4QcZX
         cyvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701183402; x=1701788202;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PbBabCqpKOAriwFvw90VUy4f2fqStiwMYR6pxTnYCDM=;
        b=LbJPq5T568O89+zsGLv5f3lWWdf9GOHOwIb7segm17ZWt6ypc9AD1ljNI4VyB7rXuT
         U7rqGL3PDSNvybCsNkUkieb2C08cE9P/5oUnDnCDDuf04SJQClDjvXV1oABc+GeIZTtE
         0FQJ8E3uiA2YZyNoo0E3wWNj0cSI0YQx/b4UirU4VvSlWC35S/dQQn30BWhfWRwRPVDJ
         Hs7qIY3fsHxkErsRcZ4t8ozTOMLOJKu485DJ6mZPo8jIpENrU6uxrLOI7c3IMLfYQNP5
         Q++jEz1waa7YCN114yPpt95D5eua4lzRLv4ydUGRw3ayU2FsrhUvkcFoJtxaGB0CUHaq
         QV2A==
X-Gm-Message-State: AOJu0YzN9DzJ/az+doxpAfSNLL+pG4S7VF4yJmt2KzQ/llmIfjVr/l71
	Ab4QGzZupipGr/Qkh+3f/KB7xA==
X-Google-Smtp-Source: AGHT+IFF37L7mMJpBw0n+wS2iRyFYetjeJokx3+I/4QyQ+stNQxHarf0QWVq5euPcDcRmpAXeUet0g==
X-Received: by 2002:a17:902:d38d:b0:1cf:a4e8:d2a1 with SMTP id e13-20020a170902d38d00b001cfa4e8d2a1mr13329156pld.42.1701183401668;
        Tue, 28 Nov 2023 06:56:41 -0800 (PST)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id j1-20020a170902c08100b001ab39cd875csm9023580pld.133.2023.11.28.06.56.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Nov 2023 06:56:41 -0800 (PST)
From: Anup Patel <apatel@ventanamicro.com>
To: Will Deacon <will@kernel.org>,
	julien.thierry.kdev@gmail.com,
	maz@kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH 01/10] Sync-up header with Linux-6.7-rc3 for KVM RISC-V
Date: Tue, 28 Nov 2023 20:26:19 +0530
Message-Id: <20231128145628.413414-2-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231128145628.413414-1-apatel@ventanamicro.com>
References: <20231128145628.413414-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We sync-up Linux headers to get latest KVM RISC-V headers having
Zba, Zbs, Zicntr, Zifencei, Zihpm, Smstateen, XVentanaCondOps Zicond,
and SBI DBCN support.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arm/aarch64/include/asm/kvm.h | 32 ++++++++++++++++++++++++++++++++
 include/linux/kvm.h           | 11 +++++++++++
 include/linux/virtio_config.h |  5 +++++
 include/linux/virtio_pci.h    | 11 +++++++++++
 riscv/include/asm/kvm.h       | 12 ++++++++++++
 5 files changed, 71 insertions(+)

diff --git a/arm/aarch64/include/asm/kvm.h b/arm/aarch64/include/asm/kvm.h
index f7ddd73..89d2fc8 100644
--- a/arm/aarch64/include/asm/kvm.h
+++ b/arm/aarch64/include/asm/kvm.h
@@ -505,6 +505,38 @@ struct kvm_smccc_filter {
 #define KVM_HYPERCALL_EXIT_SMC		(1U << 0)
 #define KVM_HYPERCALL_EXIT_16BIT	(1U << 1)
 
+/*
+ * Get feature ID registers userspace writable mask.
+ *
+ * From DDI0487J.a, D19.2.66 ("ID_AA64MMFR2_EL1, AArch64 Memory Model
+ * Feature Register 2"):
+ *
+ * "The Feature ID space is defined as the System register space in
+ * AArch64 with op0==3, op1=={0, 1, 3}, CRn==0, CRm=={0-7},
+ * op2=={0-7}."
+ *
+ * This covers all currently known R/O registers that indicate
+ * anything useful feature wise, including the ID registers.
+ *
+ * If we ever need to introduce a new range, it will be described as
+ * such in the range field.
+ */
+#define KVM_ARM_FEATURE_ID_RANGE_IDX(op0, op1, crn, crm, op2)		\
+	({								\
+		__u64 __op1 = (op1) & 3;				\
+		__op1 -= (__op1 == 3);					\
+		(__op1 << 6 | ((crm) & 7) << 3 | (op2));		\
+	})
+
+#define KVM_ARM_FEATURE_ID_RANGE	0
+#define KVM_ARM_FEATURE_ID_RANGE_SIZE	(3 * 8 * 8)
+
+struct reg_mask_range {
+	__u64 addr;		/* Pointer to mask array */
+	__u32 range;		/* Requested range */
+	__u32 reserved[13];
+};
+
 #endif
 
 #endif /* __ARM_KVM_H__ */
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 13065dd..211b86d 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -264,6 +264,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_RISCV_SBI        35
 #define KVM_EXIT_RISCV_CSR        36
 #define KVM_EXIT_NOTIFY           37
+#define KVM_EXIT_LOONGARCH_IOCSR  38
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -336,6 +337,13 @@ struct kvm_run {
 			__u32 len;
 			__u8  is_write;
 		} mmio;
+		/* KVM_EXIT_LOONGARCH_IOCSR */
+		struct {
+			__u64 phys_addr;
+			__u8  data[8];
+			__u32 len;
+			__u8  is_write;
+		} iocsr_io;
 		/* KVM_EXIT_HYPERCALL */
 		struct {
 			__u64 nr;
@@ -1192,6 +1200,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_COUNTER_OFFSET 227
 #define KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE 228
 #define KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES 229
+#define KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES 230
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1362,6 +1371,7 @@ struct kvm_dirty_tlb {
 #define KVM_REG_ARM64		0x6000000000000000ULL
 #define KVM_REG_MIPS		0x7000000000000000ULL
 #define KVM_REG_RISCV		0x8000000000000000ULL
+#define KVM_REG_LOONGARCH	0x9000000000000000ULL
 
 #define KVM_REG_SIZE_SHIFT	52
 #define KVM_REG_SIZE_MASK	0x00f0000000000000ULL
@@ -1562,6 +1572,7 @@ struct kvm_s390_ucas_mapping {
 #define KVM_ARM_MTE_COPY_TAGS	  _IOR(KVMIO,  0xb4, struct kvm_arm_copy_mte_tags)
 /* Available with KVM_CAP_COUNTER_OFFSET */
 #define KVM_ARM_SET_COUNTER_OFFSET _IOW(KVMIO,  0xb5, struct kvm_arm_counter_offset)
+#define KVM_ARM_GET_REG_WRITABLE_MASKS _IOR(KVMIO,  0xb6, struct reg_mask_range)
 
 /* ioctl for vm fd */
 #define KVM_CREATE_DEVICE	  _IOWR(KVMIO,  0xe0, struct kvm_create_device)
diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index 2c712c6..8881aea 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -105,6 +105,11 @@
  */
 #define VIRTIO_F_NOTIFICATION_DATA	38
 
+/* This feature indicates that the driver uses the data provided by the device
+ * as a virtqueue identifier in available buffer notifications.
+ */
+#define VIRTIO_F_NOTIF_CONFIG_DATA	39
+
 /*
  * This feature indicates that the driver can reset a queue individually.
  */
diff --git a/include/linux/virtio_pci.h b/include/linux/virtio_pci.h
index f703afc..44f4dd2 100644
--- a/include/linux/virtio_pci.h
+++ b/include/linux/virtio_pci.h
@@ -166,6 +166,17 @@ struct virtio_pci_common_cfg {
 	__le32 queue_used_hi;		/* read-write */
 };
 
+/*
+ * Warning: do not use sizeof on this: use offsetofend for
+ * specific fields you need.
+ */
+struct virtio_pci_modern_common_cfg {
+	struct virtio_pci_common_cfg cfg;
+
+	__le16 queue_notify_data;	/* read-write */
+	__le16 queue_reset;		/* read-write */
+};
+
 /* Fields in VIRTIO_PCI_CAP_PCI_CFG: */
 struct virtio_pci_cfg_cap {
 	struct virtio_pci_cap cap;
diff --git a/riscv/include/asm/kvm.h b/riscv/include/asm/kvm.h
index 992c5e4..60d3b21 100644
--- a/riscv/include/asm/kvm.h
+++ b/riscv/include/asm/kvm.h
@@ -80,6 +80,7 @@ struct kvm_riscv_csr {
 	unsigned long sip;
 	unsigned long satp;
 	unsigned long scounteren;
+	unsigned long senvcfg;
 };
 
 /* AIA CSR registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
@@ -93,6 +94,11 @@ struct kvm_riscv_aia_csr {
 	unsigned long iprio2h;
 };
 
+/* Smstateen CSR for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
+struct kvm_riscv_smstateen_csr {
+	unsigned long sstateen0;
+};
+
 /* TIMER registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
 struct kvm_riscv_timer {
 	__u64 frequency;
@@ -131,6 +137,8 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_ZICSR,
 	KVM_RISCV_ISA_EXT_ZIFENCEI,
 	KVM_RISCV_ISA_EXT_ZIHPM,
+	KVM_RISCV_ISA_EXT_SMSTATEEN,
+	KVM_RISCV_ISA_EXT_ZICOND,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
@@ -148,6 +156,7 @@ enum KVM_RISCV_SBI_EXT_ID {
 	KVM_RISCV_SBI_EXT_PMU,
 	KVM_RISCV_SBI_EXT_EXPERIMENTAL,
 	KVM_RISCV_SBI_EXT_VENDOR,
+	KVM_RISCV_SBI_EXT_DBCN,
 	KVM_RISCV_SBI_EXT_MAX,
 };
 
@@ -178,10 +187,13 @@ enum KVM_RISCV_SBI_EXT_ID {
 #define KVM_REG_RISCV_CSR		(0x03 << KVM_REG_RISCV_TYPE_SHIFT)
 #define KVM_REG_RISCV_CSR_GENERAL	(0x0 << KVM_REG_RISCV_SUBTYPE_SHIFT)
 #define KVM_REG_RISCV_CSR_AIA		(0x1 << KVM_REG_RISCV_SUBTYPE_SHIFT)
+#define KVM_REG_RISCV_CSR_SMSTATEEN	(0x2 << KVM_REG_RISCV_SUBTYPE_SHIFT)
 #define KVM_REG_RISCV_CSR_REG(name)	\
 		(offsetof(struct kvm_riscv_csr, name) / sizeof(unsigned long))
 #define KVM_REG_RISCV_CSR_AIA_REG(name)	\
 	(offsetof(struct kvm_riscv_aia_csr, name) / sizeof(unsigned long))
+#define KVM_REG_RISCV_CSR_SMSTATEEN_REG(name)  \
+	(offsetof(struct kvm_riscv_smstateen_csr, name) / sizeof(unsigned long))
 
 /* Timer registers are mapped as type 4 */
 #define KVM_REG_RISCV_TIMER		(0x04 << KVM_REG_RISCV_TYPE_SHIFT)
-- 
2.34.1


