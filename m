Return-Path: <kvm+bounces-1991-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C3B67EFFD8
	for <lists+kvm@lfdr.de>; Sat, 18 Nov 2023 14:29:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ED0CE1F232E8
	for <lists+kvm@lfdr.de>; Sat, 18 Nov 2023 13:29:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFEE015AE8;
	Sat, 18 Nov 2023 13:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="SSdRq56D"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0ECE12B
	for <kvm@vger.kernel.org>; Sat, 18 Nov 2023 05:29:06 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id 5614622812f47-3b3f6dd612cso1867462b6e.3
        for <kvm@vger.kernel.org>; Sat, 18 Nov 2023 05:29:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1700314146; x=1700918946; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PfztcIfAr8pr+m+aWMHfv3S2mlPSUodw8lRVq7LhLYg=;
        b=SSdRq56DJU/2/RQb1pavCXeug1qbe3CZx+ygD3DYxyA2GcVHA3L7arF0eGj3od/IG6
         9WZDwfdqYWPLab25OUmVeqQHK9yN2aQdJIQ2GkiGPQ+7O7wfn6urJWR5h/79L+9rzxY5
         1sh2IcUPCykfH+1EbPm/FfHnk1Zu7T9M72thsTZlsrD5x1XCkUrCwP60cMnqiECDynlV
         gaY18DoG27kzuMEtplViW3RbMecDNeL3kukIZCwQy/37LP1jOcDmpxaun078GAo47zL8
         t9nXpVTqvJ4AM1dWvIybEsfCujoHM7m4NzAf6kLxvmgHwvvhCk4V3YS1McvUF4HPgP1F
         R5RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700314146; x=1700918946;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PfztcIfAr8pr+m+aWMHfv3S2mlPSUodw8lRVq7LhLYg=;
        b=jeU5LQAIpeyytLE35nbdco65ARqJhySATcPLJj2L63bTrRVOcV1gdPBCVvr5pVdKQ7
         EuM2GQcpQX7/kP9gwPWz9GB3IMnlq49NSbB2rKWkrIJm+nJBwLc7Yy99ihR+upH/CyMj
         AXB7X6WAZRNPxLaEWcWsKHqVnjFkJ+w7nWi5ubb8hhrrPFcvyl9D9n1Jy5Cdh6gFRhPy
         Mt9mmB7OaAkfu+3PnXidym+SIYSaiupLJuq7fT7p0euY+j71EiCmMZzz6C8XL2Yr9umv
         1vWqwblZR4M3B5bHVx+oRnSz/uv2W5tacIdH7c7zRqZWSZNmKEW9ZIsswaVhxzGhBlMc
         hsTA==
X-Gm-Message-State: AOJu0YyDceOLgqfQVqN3qEjpubaL5KuDJNXwz3p9VMVt++9G4xWCzpHf
	8v4ns1La+GV8vphBh54l6pc1ZA==
X-Google-Smtp-Source: AGHT+IEowvLo7mV0tttiAkn14zrKqon4EK97v4BYKd0YIn+N+9OuKzWrPMEoPMYyy3mGbiHJJObW3w==
X-Received: by 2002:a05:6808:1818:b0:3ab:84f0:b491 with SMTP id bh24-20020a056808181800b003ab84f0b491mr3649098oib.19.1700314145821;
        Sat, 18 Nov 2023 05:29:05 -0800 (PST)
Received: from anup-ubuntu-vm.localdomain ([171.76.80.108])
        by smtp.gmail.com with ESMTPSA id k25-20020a63ba19000000b005b944b20f34sm2627262pgf.85.2023.11.18.05.29.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Nov 2023 05:29:05 -0800 (PST)
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
Subject: [kvmtool PATCH v3 1/6] Sync-up header with Linux-6.6 for KVM RISC-V
Date: Sat, 18 Nov 2023 18:58:42 +0530
Message-Id: <20231118132847.758785-2-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231118132847.758785-1-apatel@ventanamicro.com>
References: <20231118132847.758785-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We sync-up Linux headers to get latest KVM RISC-V headers having
V, Svnapot, AIA and other extensions.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 include/linux/kvm.h        | 19 ++++++--
 include/linux/virtio_net.h | 14 ++++++
 riscv/include/asm/kvm.h    | 97 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 126 insertions(+), 4 deletions(-)

diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 737318b..13065dd 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -1190,6 +1190,8 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP 225
 #define KVM_CAP_PMU_EVENT_MASKED_EVENTS 226
 #define KVM_CAP_COUNTER_OFFSET 227
+#define KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE 228
+#define KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES 229
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1416,9 +1418,16 @@ struct kvm_device_attr {
 	__u64	addr;		/* userspace address of attr data */
 };
 
-#define  KVM_DEV_VFIO_GROUP			1
-#define   KVM_DEV_VFIO_GROUP_ADD			1
-#define   KVM_DEV_VFIO_GROUP_DEL			2
+#define  KVM_DEV_VFIO_FILE			1
+
+#define   KVM_DEV_VFIO_FILE_ADD			1
+#define   KVM_DEV_VFIO_FILE_DEL			2
+
+/* KVM_DEV_VFIO_GROUP aliases are for compile time uapi compatibility */
+#define  KVM_DEV_VFIO_GROUP	KVM_DEV_VFIO_FILE
+
+#define   KVM_DEV_VFIO_GROUP_ADD	KVM_DEV_VFIO_FILE_ADD
+#define   KVM_DEV_VFIO_GROUP_DEL	KVM_DEV_VFIO_FILE_DEL
 #define   KVM_DEV_VFIO_GROUP_SET_SPAPR_TCE		3
 
 enum kvm_device_type {
@@ -1442,6 +1451,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_XIVE		KVM_DEV_TYPE_XIVE
 	KVM_DEV_TYPE_ARM_PV_TIME,
 #define KVM_DEV_TYPE_ARM_PV_TIME	KVM_DEV_TYPE_ARM_PV_TIME
+	KVM_DEV_TYPE_RISCV_AIA,
+#define KVM_DEV_TYPE_RISCV_AIA		KVM_DEV_TYPE_RISCV_AIA
 	KVM_DEV_TYPE_MAX,
 };
 
@@ -1613,7 +1624,7 @@ struct kvm_s390_ucas_mapping {
 #define KVM_GET_DEBUGREGS         _IOR(KVMIO,  0xa1, struct kvm_debugregs)
 #define KVM_SET_DEBUGREGS         _IOW(KVMIO,  0xa2, struct kvm_debugregs)
 /*
- * vcpu version available with KVM_ENABLE_CAP
+ * vcpu version available with KVM_CAP_ENABLE_CAP
  * vm version available with KVM_CAP_ENABLE_CAP_VM
  */
 #define KVM_ENABLE_CAP            _IOW(KVMIO,  0xa3, struct kvm_enable_cap)
diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index 12c1c96..cc65ef0 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -56,6 +56,7 @@
 #define VIRTIO_NET_F_MQ	22	/* Device supports Receive Flow
 					 * Steering */
 #define VIRTIO_NET_F_CTRL_MAC_ADDR 23	/* Set MAC address */
+#define VIRTIO_NET_F_VQ_NOTF_COAL 52	/* Device supports virtqueue notification coalescing */
 #define VIRTIO_NET_F_NOTF_COAL	53	/* Device supports notifications coalescing */
 #define VIRTIO_NET_F_GUEST_USO4	54	/* Guest can handle USOv4 in. */
 #define VIRTIO_NET_F_GUEST_USO6	55	/* Guest can handle USOv6 in. */
@@ -391,5 +392,18 @@ struct virtio_net_ctrl_coal_rx {
 };
 
 #define VIRTIO_NET_CTRL_NOTF_COAL_RX_SET		1
+#define VIRTIO_NET_CTRL_NOTF_COAL_VQ_SET		2
+#define VIRTIO_NET_CTRL_NOTF_COAL_VQ_GET		3
+
+struct virtio_net_ctrl_coal {
+	__le32 max_packets;
+	__le32 max_usecs;
+};
+
+struct  virtio_net_ctrl_coal_vq {
+	__le16 vqn;
+	__le16 reserved;
+	struct virtio_net_ctrl_coal coal;
+};
 
 #endif /* _UAPI_LINUX_VIRTIO_NET_H */
diff --git a/riscv/include/asm/kvm.h b/riscv/include/asm/kvm.h
index f92790c..992c5e4 100644
--- a/riscv/include/asm/kvm.h
+++ b/riscv/include/asm/kvm.h
@@ -15,6 +15,7 @@
 #include <asm/bitsperlong.h>
 #include <asm/ptrace.h>
 
+#define __KVM_HAVE_IRQ_LINE
 #define __KVM_HAVE_READONLY_MEM
 
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
@@ -54,6 +55,7 @@ struct kvm_riscv_config {
 	unsigned long marchid;
 	unsigned long mimpid;
 	unsigned long zicboz_block_size;
+	unsigned long satp_mode;
 };
 
 /* CORE registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
@@ -121,6 +123,14 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_ZICBOZ,
 	KVM_RISCV_ISA_EXT_ZBB,
 	KVM_RISCV_ISA_EXT_SSAIA,
+	KVM_RISCV_ISA_EXT_V,
+	KVM_RISCV_ISA_EXT_SVNAPOT,
+	KVM_RISCV_ISA_EXT_ZBA,
+	KVM_RISCV_ISA_EXT_ZBS,
+	KVM_RISCV_ISA_EXT_ZICNTR,
+	KVM_RISCV_ISA_EXT_ZICSR,
+	KVM_RISCV_ISA_EXT_ZIFENCEI,
+	KVM_RISCV_ISA_EXT_ZIHPM,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
@@ -190,6 +200,15 @@ enum KVM_RISCV_SBI_EXT_ID {
 
 /* ISA Extension registers are mapped as type 7 */
 #define KVM_REG_RISCV_ISA_EXT		(0x07 << KVM_REG_RISCV_TYPE_SHIFT)
+#define KVM_REG_RISCV_ISA_SINGLE	(0x0 << KVM_REG_RISCV_SUBTYPE_SHIFT)
+#define KVM_REG_RISCV_ISA_MULTI_EN	(0x1 << KVM_REG_RISCV_SUBTYPE_SHIFT)
+#define KVM_REG_RISCV_ISA_MULTI_DIS	(0x2 << KVM_REG_RISCV_SUBTYPE_SHIFT)
+#define KVM_REG_RISCV_ISA_MULTI_REG(__ext_id)	\
+		((__ext_id) / __BITS_PER_LONG)
+#define KVM_REG_RISCV_ISA_MULTI_MASK(__ext_id)	\
+		(1UL << ((__ext_id) % __BITS_PER_LONG))
+#define KVM_REG_RISCV_ISA_MULTI_REG_LAST	\
+		KVM_REG_RISCV_ISA_MULTI_REG(KVM_RISCV_ISA_EXT_MAX - 1)
 
 /* SBI extension registers are mapped as type 8 */
 #define KVM_REG_RISCV_SBI_EXT		(0x08 << KVM_REG_RISCV_TYPE_SHIFT)
@@ -203,6 +222,84 @@ enum KVM_RISCV_SBI_EXT_ID {
 #define KVM_REG_RISCV_SBI_MULTI_REG_LAST	\
 		KVM_REG_RISCV_SBI_MULTI_REG(KVM_RISCV_SBI_EXT_MAX - 1)
 
+/* V extension registers are mapped as type 9 */
+#define KVM_REG_RISCV_VECTOR		(0x09 << KVM_REG_RISCV_TYPE_SHIFT)
+#define KVM_REG_RISCV_VECTOR_CSR_REG(name)	\
+		(offsetof(struct __riscv_v_ext_state, name) / sizeof(unsigned long))
+#define KVM_REG_RISCV_VECTOR_REG(n)	\
+		((n) + sizeof(struct __riscv_v_ext_state) / sizeof(unsigned long))
+
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
+
+/*
+ * Modes of RISC-V AIA device:
+ * 1) EMUL (aka Emulation): Trap-n-emulate IMSIC
+ * 2) HWACCEL (aka HW Acceleration): Virtualize IMSIC using IMSIC guest files
+ * 3) AUTO (aka Automatic): Virtualize IMSIC using IMSIC guest files whenever
+ *    available otherwise fallback to trap-n-emulation
+ */
+#define KVM_DEV_RISCV_AIA_MODE_EMUL		0
+#define KVM_DEV_RISCV_AIA_MODE_HWACCEL		1
+#define KVM_DEV_RISCV_AIA_MODE_AUTO		2
+
+#define KVM_DEV_RISCV_AIA_IDS_MIN		63
+#define KVM_DEV_RISCV_AIA_IDS_MAX		2048
+#define KVM_DEV_RISCV_AIA_SRCS_MAX		1024
+#define KVM_DEV_RISCV_AIA_GROUP_BITS_MAX	8
+#define KVM_DEV_RISCV_AIA_GROUP_SHIFT_MIN	24
+#define KVM_DEV_RISCV_AIA_GROUP_SHIFT_MAX	56
+#define KVM_DEV_RISCV_AIA_HART_BITS_MAX		16
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
+/*
+ * The device attribute type contains the memory mapped offset of the
+ * APLIC register (range 0x0000-0x3FFF) and it must be 4-byte aligned.
+ */
+#define KVM_DEV_RISCV_AIA_GRP_APLIC		3
+
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
+/* One single KVM irqchip, ie. the AIA */
+#define KVM_NR_IRQCHIPS			1
+
 #endif
 
 #endif /* __LINUX_KVM_RISCV_H */
-- 
2.34.1


