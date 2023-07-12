Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6EB8750EA8
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 18:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232258AbjGLQfW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 12:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231537AbjGLQfV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 12:35:21 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0286F1BE4
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:35:17 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-668704a5b5bso6413600b3a.0
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1689179716; x=1691771716;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u69JnhfX2LqGFM+BjoI6Leri8ZBQcCNEYkxpvBK9Bxs=;
        b=bGV+E47bhSLrxcnDwp4hFMtfd++2t6Q5gpMb3GBOfDfqPSIeiYDAI9/VMWIidCAZXf
         5xf9nIx1bcGeOokkGN2kc5hS/vPQONc5zwALObz8+Mk8G7Iz3AVziEwV95TllkEOBHiK
         2+/1Jgv6ILjZrqI5mVjw8KeWp0CWG3Ienndui+GziR10fXRFx21Aa3YwsvfEDw26gme6
         jc1zqzcOjrabFiX1if89uqrm1mfNPHd+tjDEFXtMoP31YURWfcR47hM9IFxH2lOjiegE
         f0Eanx0bb8btUjTHv1oI2pOuHt5yuSXWlo6aGsy00I/aHf4AfHXQ0gK0xaRmwaSq+2eT
         c3Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689179716; x=1691771716;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u69JnhfX2LqGFM+BjoI6Leri8ZBQcCNEYkxpvBK9Bxs=;
        b=d2e+H0SXOVypMQBRrPcNP9LWWl1KFlGln9kGBfWz95tvNxrxkA/4WJJLMYIhzkmmlZ
         CYyO+uXzartmzMB2hzODjtTGPSE6iiU9zaZJoKfhhvCAdT9aqqbYSmiui6lzNDk6uItj
         W3wvUGUsJ7caS2w1eAzDlfg15QAN3slOWeM09H9zrjOyT2CvPtvXBVYCUqT6n46NU8tq
         0FElSqyAULF5JDgcm1p1uhWazLIGEZha18DqBk+jYrSuSojhjLhTdsQ6h/SqWH7pnfRX
         rYMIe7+3eI3wF55RHJ6Iz3KtJlUYd0FyTCyCvtvSj0WDb1hmZi7m58PiYZme2YJsaY9R
         y+xg==
X-Gm-Message-State: ABy/qLYAxqY1PZ7TYUtf+eKvclUYnLnyCj2G8aiSshvAF/H1AxZ4OEM3
        KM8pQND9/OHs5zveqe1VtRei0xpqIog9RlodR1c=
X-Google-Smtp-Source: APBJJlHc6oOplyEF8yOlJMVvVE79RbdKEeyiakJFuP3SCPaRxEfmNQc/Q0/omVmxcj2DjhvS/ch0Xw==
X-Received: by 2002:a05:6a21:33a2:b0:132:c80f:c8ba with SMTP id yy34-20020a056a2133a200b00132c80fc8bamr3067136pzb.41.1689179716165;
        Wed, 12 Jul 2023 09:35:16 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([171.76.82.173])
        by smtp.gmail.com with ESMTPSA id w15-20020a1709027b8f00b001b9df74ba5asm4172164pll.210.2023.07.12.09.35.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 09:35:15 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH v4 2/9] Sync-up headers with Linux-6.4
Date:   Wed, 12 Jul 2023 22:04:54 +0530
Message-Id: <20230712163501.1769737-3-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230712163501.1769737-1-apatel@ventanamicro.com>
References: <20230712163501.1769737-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We sync-up Linux headers to get latest KVM RISC-V headers having
SBI extension enable/disable, Zbb, Zicboz, and Ssaia support.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arm/aarch64/include/asm/kvm.h |  38 ++++++++++++
 include/linux/kvm.h           |  57 +++++++++++-------
 include/linux/virtio_blk.h    | 105 ++++++++++++++++++++++++++++++++++
 include/linux/virtio_config.h |   6 ++
 include/linux/virtio_net.h    |   5 ++
 riscv/include/asm/kvm.h       |  56 +++++++++++++++++-
 x86/include/asm/kvm.h         |  50 ++++++++++++----
 7 files changed, 286 insertions(+), 31 deletions(-)

diff --git a/arm/aarch64/include/asm/kvm.h b/arm/aarch64/include/asm/kvm.h
index 316917b..f7ddd73 100644
--- a/arm/aarch64/include/asm/kvm.h
+++ b/arm/aarch64/include/asm/kvm.h
@@ -43,6 +43,7 @@
 #define __KVM_HAVE_VCPU_EVENTS
 
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
+#define KVM_DIRTY_LOG_PAGE_OFFSET 64
 
 #define KVM_REG_SIZE(id)						\
 	(1U << (((id) & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT))
@@ -108,6 +109,7 @@ struct kvm_regs {
 #define KVM_ARM_VCPU_SVE		4 /* enable SVE for this CPU */
 #define KVM_ARM_VCPU_PTRAUTH_ADDRESS	5 /* VCPU uses address authentication */
 #define KVM_ARM_VCPU_PTRAUTH_GENERIC	6 /* VCPU uses generic authentication */
+#define KVM_ARM_VCPU_HAS_EL2		7 /* Support nested virtualization */
 
 struct kvm_vcpu_init {
 	__u32 target;
@@ -196,6 +198,15 @@ struct kvm_arm_copy_mte_tags {
 	__u64 reserved[2];
 };
 
+/*
+ * Counter/Timer offset structure. Describe the virtual/physical offset.
+ * To be used with KVM_ARM_SET_COUNTER_OFFSET.
+ */
+struct kvm_arm_counter_offset {
+	__u64 counter_offset;
+	__u64 reserved;
+};
+
 #define KVM_ARM_TAGS_TO_GUEST		0
 #define KVM_ARM_TAGS_FROM_GUEST		1
 
@@ -370,6 +381,10 @@ enum {
 #endif
 };
 
+/* Device Control API on vm fd */
+#define KVM_ARM_VM_SMCCC_CTRL		0
+#define   KVM_ARM_VM_SMCCC_FILTER	0
+
 /* Device Control API: ARM VGIC */
 #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
 #define KVM_DEV_ARM_VGIC_GRP_DIST_REGS	1
@@ -409,6 +424,8 @@ enum {
 #define KVM_ARM_VCPU_TIMER_CTRL		1
 #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
 #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
+#define   KVM_ARM_VCPU_TIMER_IRQ_HVTIMER	2
+#define   KVM_ARM_VCPU_TIMER_IRQ_HPTIMER	3
 #define KVM_ARM_VCPU_PVTIME_CTRL	2
 #define   KVM_ARM_VCPU_PVTIME_IPA	0
 
@@ -467,6 +484,27 @@ enum {
 /* run->fail_entry.hardware_entry_failure_reason codes. */
 #define KVM_EXIT_FAIL_ENTRY_CPU_UNSUPPORTED	(1ULL << 0)
 
+enum kvm_smccc_filter_action {
+	KVM_SMCCC_FILTER_HANDLE = 0,
+	KVM_SMCCC_FILTER_DENY,
+	KVM_SMCCC_FILTER_FWD_TO_USER,
+
+#ifdef __KERNEL__
+	NR_SMCCC_FILTER_ACTIONS
+#endif
+};
+
+struct kvm_smccc_filter {
+	__u32 base;
+	__u32 nr_functions;
+	__u8 action;
+	__u8 pad[15];
+};
+
+/* arm64-specific KVM_EXIT_HYPERCALL flags */
+#define KVM_HYPERCALL_EXIT_SMC		(1U << 0)
+#define KVM_HYPERCALL_EXIT_16BIT	(1U << 1)
+
 #endif
 
 #endif /* __ARM_KVM_H__ */
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 0d5d441..737318b 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -86,14 +86,6 @@ struct kvm_debug_guest {
 /* *** End of deprecated interfaces *** */
 
 
-/* for KVM_CREATE_MEMORY_REGION */
-struct kvm_memory_region {
-	__u32 slot;
-	__u32 flags;
-	__u64 guest_phys_addr;
-	__u64 memory_size; /* bytes */
-};
-
 /* for KVM_SET_USER_MEMORY_REGION */
 struct kvm_userspace_memory_region {
 	__u32 slot;
@@ -104,9 +96,9 @@ struct kvm_userspace_memory_region {
 };
 
 /*
- * The bit 0 ~ bit 15 of kvm_memory_region::flags are visible for userspace,
- * other bits are reserved for kvm internal use which are defined in
- * include/linux/kvm_host.h.
+ * The bit 0 ~ bit 15 of kvm_userspace_memory_region::flags are visible for
+ * userspace, other bits are reserved for kvm internal use which are defined
+ * in include/linux/kvm_host.h.
  */
 #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
 #define KVM_MEM_READONLY	(1UL << 1)
@@ -349,8 +341,13 @@ struct kvm_run {
 			__u64 nr;
 			__u64 args[6];
 			__u64 ret;
-			__u32 longmode;
-			__u32 pad;
+
+			union {
+#ifndef __KERNEL__
+				__u32 longmode;
+#endif
+				__u64 flags;
+			};
 		} hypercall;
 		/* KVM_EXIT_TPR_ACCESS */
 		struct {
@@ -485,6 +482,9 @@ struct kvm_run {
 #define KVM_MSR_EXIT_REASON_INVAL	(1 << 0)
 #define KVM_MSR_EXIT_REASON_UNKNOWN	(1 << 1)
 #define KVM_MSR_EXIT_REASON_FILTER	(1 << 2)
+#define KVM_MSR_EXIT_REASON_VALID_MASK	(KVM_MSR_EXIT_REASON_INVAL   |	\
+					 KVM_MSR_EXIT_REASON_UNKNOWN |	\
+					 KVM_MSR_EXIT_REASON_FILTER)
 			__u32 reason; /* kernel -> user */
 			__u32 index; /* kernel -> user */
 			__u64 data; /* kernel <-> user */
@@ -588,6 +588,8 @@ struct kvm_s390_mem_op {
 		struct {
 			__u8 ar;	/* the access register number */
 			__u8 key;	/* access key, ignored if flag unset */
+			__u8 pad1[6];	/* ignored */
+			__u64 old_addr;	/* ignored if cmpxchg flag unset */
 		};
 		__u32 sida_offset; /* offset into the sida */
 		__u8 reserved[32]; /* ignored */
@@ -600,11 +602,17 @@ struct kvm_s390_mem_op {
 #define KVM_S390_MEMOP_SIDA_WRITE	3
 #define KVM_S390_MEMOP_ABSOLUTE_READ	4
 #define KVM_S390_MEMOP_ABSOLUTE_WRITE	5
+#define KVM_S390_MEMOP_ABSOLUTE_CMPXCHG	6
+
 /* flags for kvm_s390_mem_op->flags */
 #define KVM_S390_MEMOP_F_CHECK_ONLY		(1ULL << 0)
 #define KVM_S390_MEMOP_F_INJECT_EXCEPTION	(1ULL << 1)
 #define KVM_S390_MEMOP_F_SKEY_PROTECTION	(1ULL << 2)
 
+/* flags specifying extension support via KVM_CAP_S390_MEM_OP_EXTENSION */
+#define KVM_S390_MEMOP_EXTENSION_CAP_BASE	(1 << 0)
+#define KVM_S390_MEMOP_EXTENSION_CAP_CMPXCHG	(1 << 1)
+
 /* for KVM_INTERRUPT */
 struct kvm_interrupt {
 	/* in */
@@ -1178,6 +1186,10 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_ZPCI_OP 221
 #define KVM_CAP_S390_CPU_TOPOLOGY 222
 #define KVM_CAP_DIRTY_LOG_RING_ACQ_REL 223
+#define KVM_CAP_S390_PROTECTED_ASYNC_DISABLE 224
+#define KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP 225
+#define KVM_CAP_PMU_EVENT_MASKED_EVENTS 226
+#define KVM_CAP_COUNTER_OFFSET 227
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1267,6 +1279,7 @@ struct kvm_x86_mce {
 #define KVM_XEN_HVM_CONFIG_RUNSTATE		(1 << 3)
 #define KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL	(1 << 4)
 #define KVM_XEN_HVM_CONFIG_EVTCHN_SEND		(1 << 5)
+#define KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG	(1 << 6)
 
 struct kvm_xen_hvm_config {
 	__u32 flags;
@@ -1437,20 +1450,14 @@ struct kvm_vfio_spapr_tce {
 	__s32	tablefd;
 };
 
-/*
- * ioctls for VM fds
- */
-#define KVM_SET_MEMORY_REGION     _IOW(KVMIO,  0x40, struct kvm_memory_region)
 /*
  * KVM_CREATE_VCPU receives as a parameter the vcpu slot, and returns
  * a vcpu fd.
  */
 #define KVM_CREATE_VCPU           _IO(KVMIO,   0x41)
 #define KVM_GET_DIRTY_LOG         _IOW(KVMIO,  0x42, struct kvm_dirty_log)
-/* KVM_SET_MEMORY_ALIAS is obsolete: */
-#define KVM_SET_MEMORY_ALIAS      _IOW(KVMIO,  0x43, struct kvm_memory_alias)
 #define KVM_SET_NR_MMU_PAGES      _IO(KVMIO,   0x44)
-#define KVM_GET_NR_MMU_PAGES      _IO(KVMIO,   0x45)
+#define KVM_GET_NR_MMU_PAGES      _IO(KVMIO,   0x45)  /* deprecated */
 #define KVM_SET_USER_MEMORY_REGION _IOW(KVMIO, 0x46, \
 					struct kvm_userspace_memory_region)
 #define KVM_SET_TSS_ADDR          _IO(KVMIO,   0x47)
@@ -1542,6 +1549,8 @@ struct kvm_s390_ucas_mapping {
 #define KVM_SET_PMU_EVENT_FILTER  _IOW(KVMIO,  0xb2, struct kvm_pmu_event_filter)
 #define KVM_PPC_SVM_OFF		  _IO(KVMIO,  0xb3)
 #define KVM_ARM_MTE_COPY_TAGS	  _IOR(KVMIO,  0xb4, struct kvm_arm_copy_mte_tags)
+/* Available with KVM_CAP_COUNTER_OFFSET */
+#define KVM_ARM_SET_COUNTER_OFFSET _IOW(KVMIO,  0xb5, struct kvm_arm_counter_offset)
 
 /* ioctl for vm fd */
 #define KVM_CREATE_DEVICE	  _IOWR(KVMIO,  0xe0, struct kvm_create_device)
@@ -1740,6 +1749,8 @@ enum pv_cmd_id {
 	KVM_PV_UNSHARE_ALL,
 	KVM_PV_INFO,
 	KVM_PV_DUMP,
+	KVM_PV_ASYNC_CLEANUP_PREPARE,
+	KVM_PV_ASYNC_CLEANUP_PERFORM,
 };
 
 struct kvm_pv_cmd {
@@ -1770,8 +1781,10 @@ struct kvm_xen_hvm_attr {
 	union {
 		__u8 long_mode;
 		__u8 vector;
+		__u8 runstate_update_flag;
 		struct {
 			__u64 gfn;
+#define KVM_XEN_INVALID_GFN ((__u64)-1)
 		} shared_info;
 		struct {
 			__u32 send_port;
@@ -1803,6 +1816,7 @@ struct kvm_xen_hvm_attr {
 	} u;
 };
 
+
 /* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_SHARED_INFO */
 #define KVM_XEN_ATTR_TYPE_LONG_MODE		0x0
 #define KVM_XEN_ATTR_TYPE_SHARED_INFO		0x1
@@ -1810,6 +1824,8 @@ struct kvm_xen_hvm_attr {
 /* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_EVTCHN_SEND */
 #define KVM_XEN_ATTR_TYPE_EVTCHN		0x3
 #define KVM_XEN_ATTR_TYPE_XEN_VERSION		0x4
+/* Available with KVM_CAP_XEN_HVM / KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG */
+#define KVM_XEN_ATTR_TYPE_RUNSTATE_UPDATE_FLAG	0x5
 
 /* Per-vCPU Xen attributes */
 #define KVM_XEN_VCPU_GET_ATTR	_IOWR(KVMIO, 0xca, struct kvm_xen_vcpu_attr)
@@ -1826,6 +1842,7 @@ struct kvm_xen_vcpu_attr {
 	__u16 pad[3];
 	union {
 		__u64 gpa;
+#define KVM_XEN_INVALID_GPA ((__u64)-1)
 		__u64 pad[8];
 		struct {
 			__u64 state;
diff --git a/include/linux/virtio_blk.h b/include/linux/virtio_blk.h
index 58e70b2..3744e4d 100644
--- a/include/linux/virtio_blk.h
+++ b/include/linux/virtio_blk.h
@@ -41,6 +41,7 @@
 #define VIRTIO_BLK_F_DISCARD	13	/* DISCARD is supported */
 #define VIRTIO_BLK_F_WRITE_ZEROES	14	/* WRITE ZEROES is supported */
 #define VIRTIO_BLK_F_SECURE_ERASE	16 /* Secure Erase is supported */
+#define VIRTIO_BLK_F_ZONED		17	/* Zoned block device */
 
 /* Legacy feature bits */
 #ifndef VIRTIO_BLK_NO_LEGACY
@@ -137,6 +138,16 @@ struct virtio_blk_config {
 	/* Secure erase commands must be aligned to this number of sectors. */
 	__virtio32 secure_erase_sector_alignment;
 
+	/* Zoned block device characteristics (if VIRTIO_BLK_F_ZONED) */
+	struct virtio_blk_zoned_characteristics {
+		__virtio32 zone_sectors;
+		__virtio32 max_open_zones;
+		__virtio32 max_active_zones;
+		__virtio32 max_append_sectors;
+		__virtio32 write_granularity;
+		__u8 model;
+		__u8 unused2[3];
+	} zoned;
 } __attribute__((packed));
 
 /*
@@ -174,6 +185,27 @@ struct virtio_blk_config {
 /* Secure erase command */
 #define VIRTIO_BLK_T_SECURE_ERASE	14
 
+/* Zone append command */
+#define VIRTIO_BLK_T_ZONE_APPEND    15
+
+/* Report zones command */
+#define VIRTIO_BLK_T_ZONE_REPORT    16
+
+/* Open zone command */
+#define VIRTIO_BLK_T_ZONE_OPEN      18
+
+/* Close zone command */
+#define VIRTIO_BLK_T_ZONE_CLOSE     20
+
+/* Finish zone command */
+#define VIRTIO_BLK_T_ZONE_FINISH    22
+
+/* Reset zone command */
+#define VIRTIO_BLK_T_ZONE_RESET     24
+
+/* Reset All zones command */
+#define VIRTIO_BLK_T_ZONE_RESET_ALL 26
+
 #ifndef VIRTIO_BLK_NO_LEGACY
 /* Barrier before this op. */
 #define VIRTIO_BLK_T_BARRIER	0x80000000
@@ -193,6 +225,72 @@ struct virtio_blk_outhdr {
 	__virtio64 sector;
 };
 
+/*
+ * Supported zoned device models.
+ */
+
+/* Regular block device */
+#define VIRTIO_BLK_Z_NONE      0
+/* Host-managed zoned device */
+#define VIRTIO_BLK_Z_HM        1
+/* Host-aware zoned device */
+#define VIRTIO_BLK_Z_HA        2
+
+/*
+ * Zone descriptor. A part of VIRTIO_BLK_T_ZONE_REPORT command reply.
+ */
+struct virtio_blk_zone_descriptor {
+	/* Zone capacity */
+	__virtio64 z_cap;
+	/* The starting sector of the zone */
+	__virtio64 z_start;
+	/* Zone write pointer position in sectors */
+	__virtio64 z_wp;
+	/* Zone type */
+	__u8 z_type;
+	/* Zone state */
+	__u8 z_state;
+	__u8 reserved[38];
+};
+
+struct virtio_blk_zone_report {
+	__virtio64 nr_zones;
+	__u8 reserved[56];
+	struct virtio_blk_zone_descriptor zones[];
+};
+
+/*
+ * Supported zone types.
+ */
+
+/* Conventional zone */
+#define VIRTIO_BLK_ZT_CONV         1
+/* Sequential Write Required zone */
+#define VIRTIO_BLK_ZT_SWR          2
+/* Sequential Write Preferred zone */
+#define VIRTIO_BLK_ZT_SWP          3
+
+/*
+ * Zone states that are available for zones of all types.
+ */
+
+/* Not a write pointer (conventional zones only) */
+#define VIRTIO_BLK_ZS_NOT_WP       0
+/* Empty */
+#define VIRTIO_BLK_ZS_EMPTY        1
+/* Implicitly Open */
+#define VIRTIO_BLK_ZS_IOPEN        2
+/* Explicitly Open */
+#define VIRTIO_BLK_ZS_EOPEN        3
+/* Closed */
+#define VIRTIO_BLK_ZS_CLOSED       4
+/* Read-Only */
+#define VIRTIO_BLK_ZS_RDONLY       13
+/* Full */
+#define VIRTIO_BLK_ZS_FULL         14
+/* Offline */
+#define VIRTIO_BLK_ZS_OFFLINE      15
+
 /* Unmap this range (only valid for write zeroes command) */
 #define VIRTIO_BLK_WRITE_ZEROES_FLAG_UNMAP	0x00000001
 
@@ -219,4 +317,11 @@ struct virtio_scsi_inhdr {
 #define VIRTIO_BLK_S_OK		0
 #define VIRTIO_BLK_S_IOERR	1
 #define VIRTIO_BLK_S_UNSUPP	2
+
+/* Error codes that are specific to zoned block devices */
+#define VIRTIO_BLK_S_ZONE_INVALID_CMD     3
+#define VIRTIO_BLK_S_ZONE_UNALIGNED_WP    4
+#define VIRTIO_BLK_S_ZONE_OPEN_RESOURCE   5
+#define VIRTIO_BLK_S_ZONE_ACTIVE_RESOURCE 6
+
 #endif /* _LINUX_VIRTIO_BLK_H */
diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index 3c05162..2c712c6 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -99,6 +99,12 @@
  */
 #define VIRTIO_F_SR_IOV			37
 
+/*
+ * This feature indicates that the driver passes extra data (besides
+ * identifying the virtqueue) in its device notifications.
+ */
+#define VIRTIO_F_NOTIFICATION_DATA	38
+
 /*
  * This feature indicates that the driver can reset a queue individually.
  */
diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index 6cb842e..12c1c96 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -57,7 +57,11 @@
 					 * Steering */
 #define VIRTIO_NET_F_CTRL_MAC_ADDR 23	/* Set MAC address */
 #define VIRTIO_NET_F_NOTF_COAL	53	/* Device supports notifications coalescing */
+#define VIRTIO_NET_F_GUEST_USO4	54	/* Guest can handle USOv4 in. */
+#define VIRTIO_NET_F_GUEST_USO6	55	/* Guest can handle USOv6 in. */
+#define VIRTIO_NET_F_HOST_USO	56	/* Host can handle USO in. */
 #define VIRTIO_NET_F_HASH_REPORT  57	/* Supports hash report */
+#define VIRTIO_NET_F_GUEST_HDRLEN  59	/* Guest provides the exact hdr_len value. */
 #define VIRTIO_NET_F_RSS	  60	/* Supports RSS RX steering */
 #define VIRTIO_NET_F_RSC_EXT	  61	/* extended coalescing info */
 #define VIRTIO_NET_F_STANDBY	  62	/* Act as standby for another device
@@ -130,6 +134,7 @@ struct virtio_net_hdr_v1 {
 #define VIRTIO_NET_HDR_GSO_TCPV4	1	/* GSO frame, IPv4 TCP (TSO) */
 #define VIRTIO_NET_HDR_GSO_UDP		3	/* GSO frame, IPv4 UDP (UFO) */
 #define VIRTIO_NET_HDR_GSO_TCPV6	4	/* GSO frame, IPv6 TCP */
+#define VIRTIO_NET_HDR_GSO_UDP_L4	5	/* GSO frame, IPv4& IPv6 UDP (USO) */
 #define VIRTIO_NET_HDR_GSO_ECN		0x80	/* TCP has ECN set */
 	__u8 gso_type;
 	__virtio16 hdr_len;	/* Ethernet + IP + tcp/udp hdrs */
diff --git a/riscv/include/asm/kvm.h b/riscv/include/asm/kvm.h
index 8985ff2..f92790c 100644
--- a/riscv/include/asm/kvm.h
+++ b/riscv/include/asm/kvm.h
@@ -12,6 +12,7 @@
 #ifndef __ASSEMBLY__
 
 #include <linux/types.h>
+#include <asm/bitsperlong.h>
 #include <asm/ptrace.h>
 
 #define __KVM_HAVE_READONLY_MEM
@@ -49,6 +50,10 @@ struct kvm_sregs {
 struct kvm_riscv_config {
 	unsigned long isa;
 	unsigned long zicbom_block_size;
+	unsigned long mvendorid;
+	unsigned long marchid;
+	unsigned long mimpid;
+	unsigned long zicboz_block_size;
 };
 
 /* CORE registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
@@ -61,7 +66,7 @@ struct kvm_riscv_core {
 #define KVM_RISCV_MODE_S	1
 #define KVM_RISCV_MODE_U	0
 
-/* CSR registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
+/* General CSR registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
 struct kvm_riscv_csr {
 	unsigned long sstatus;
 	unsigned long sie;
@@ -75,6 +80,17 @@ struct kvm_riscv_csr {
 	unsigned long scounteren;
 };
 
+/* AIA CSR registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
+struct kvm_riscv_aia_csr {
+	unsigned long siselect;
+	unsigned long iprio1;
+	unsigned long iprio2;
+	unsigned long sieh;
+	unsigned long siph;
+	unsigned long iprio1h;
+	unsigned long iprio2h;
+};
+
 /* TIMER registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
 struct kvm_riscv_timer {
 	__u64 frequency;
@@ -102,9 +118,29 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_SVINVAL,
 	KVM_RISCV_ISA_EXT_ZIHINTPAUSE,
 	KVM_RISCV_ISA_EXT_ZICBOM,
+	KVM_RISCV_ISA_EXT_ZICBOZ,
+	KVM_RISCV_ISA_EXT_ZBB,
+	KVM_RISCV_ISA_EXT_SSAIA,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
+/*
+ * SBI extension IDs specific to KVM. This is not the same as the SBI
+ * extension IDs defined by the RISC-V SBI specification.
+ */
+enum KVM_RISCV_SBI_EXT_ID {
+	KVM_RISCV_SBI_EXT_V01 = 0,
+	KVM_RISCV_SBI_EXT_TIME,
+	KVM_RISCV_SBI_EXT_IPI,
+	KVM_RISCV_SBI_EXT_RFENCE,
+	KVM_RISCV_SBI_EXT_SRST,
+	KVM_RISCV_SBI_EXT_HSM,
+	KVM_RISCV_SBI_EXT_PMU,
+	KVM_RISCV_SBI_EXT_EXPERIMENTAL,
+	KVM_RISCV_SBI_EXT_VENDOR,
+	KVM_RISCV_SBI_EXT_MAX,
+};
+
 /* Possible states for kvm_riscv_timer */
 #define KVM_RISCV_TIMER_STATE_OFF	0
 #define KVM_RISCV_TIMER_STATE_ON	1
@@ -115,6 +151,8 @@ enum KVM_RISCV_ISA_EXT_ID {
 /* If you need to interpret the index values, here is the key: */
 #define KVM_REG_RISCV_TYPE_MASK		0x00000000FF000000
 #define KVM_REG_RISCV_TYPE_SHIFT	24
+#define KVM_REG_RISCV_SUBTYPE_MASK	0x0000000000FF0000
+#define KVM_REG_RISCV_SUBTYPE_SHIFT	16
 
 /* Config registers are mapped as type 1 */
 #define KVM_REG_RISCV_CONFIG		(0x01 << KVM_REG_RISCV_TYPE_SHIFT)
@@ -128,8 +166,12 @@ enum KVM_RISCV_ISA_EXT_ID {
 
 /* Control and status registers are mapped as type 3 */
 #define KVM_REG_RISCV_CSR		(0x03 << KVM_REG_RISCV_TYPE_SHIFT)
+#define KVM_REG_RISCV_CSR_GENERAL	(0x0 << KVM_REG_RISCV_SUBTYPE_SHIFT)
+#define KVM_REG_RISCV_CSR_AIA		(0x1 << KVM_REG_RISCV_SUBTYPE_SHIFT)
 #define KVM_REG_RISCV_CSR_REG(name)	\
 		(offsetof(struct kvm_riscv_csr, name) / sizeof(unsigned long))
+#define KVM_REG_RISCV_CSR_AIA_REG(name)	\
+	(offsetof(struct kvm_riscv_aia_csr, name) / sizeof(unsigned long))
 
 /* Timer registers are mapped as type 4 */
 #define KVM_REG_RISCV_TIMER		(0x04 << KVM_REG_RISCV_TYPE_SHIFT)
@@ -149,6 +191,18 @@ enum KVM_RISCV_ISA_EXT_ID {
 /* ISA Extension registers are mapped as type 7 */
 #define KVM_REG_RISCV_ISA_EXT		(0x07 << KVM_REG_RISCV_TYPE_SHIFT)
 
+/* SBI extension registers are mapped as type 8 */
+#define KVM_REG_RISCV_SBI_EXT		(0x08 << KVM_REG_RISCV_TYPE_SHIFT)
+#define KVM_REG_RISCV_SBI_SINGLE	(0x0 << KVM_REG_RISCV_SUBTYPE_SHIFT)
+#define KVM_REG_RISCV_SBI_MULTI_EN	(0x1 << KVM_REG_RISCV_SUBTYPE_SHIFT)
+#define KVM_REG_RISCV_SBI_MULTI_DIS	(0x2 << KVM_REG_RISCV_SUBTYPE_SHIFT)
+#define KVM_REG_RISCV_SBI_MULTI_REG(__ext_id)	\
+		((__ext_id) / __BITS_PER_LONG)
+#define KVM_REG_RISCV_SBI_MULTI_MASK(__ext_id)	\
+		(1UL << ((__ext_id) % __BITS_PER_LONG))
+#define KVM_REG_RISCV_SBI_MULTI_REG_LAST	\
+		KVM_REG_RISCV_SBI_MULTI_REG(KVM_RISCV_SBI_EXT_MAX - 1)
+
 #endif
 
 #endif /* __LINUX_KVM_RISCV_H */
diff --git a/x86/include/asm/kvm.h b/x86/include/asm/kvm.h
index 46de10a..1a6a1f9 100644
--- a/x86/include/asm/kvm.h
+++ b/x86/include/asm/kvm.h
@@ -9,6 +9,7 @@
 
 #include <linux/types.h>
 #include <linux/ioctl.h>
+#include <linux/stddef.h>
 
 #define KVM_PIO_PAGE_OFFSET 1
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 2
@@ -53,14 +54,6 @@
 /* Architectural interrupt line count. */
 #define KVM_NR_INTERRUPTS 256
 
-struct kvm_memory_alias {
-	__u32 slot;  /* this has a different namespace than memory slots */
-	__u32 flags;
-	__u64 guest_phys_addr;
-	__u64 memory_size;
-	__u64 target_phys_addr;
-};
-
 /* for KVM_GET_IRQCHIP and KVM_SET_IRQCHIP */
 struct kvm_pic_state {
 	__u8 last_irr;	/* edge detection */
@@ -214,6 +207,8 @@ struct kvm_msr_list {
 struct kvm_msr_filter_range {
 #define KVM_MSR_FILTER_READ  (1 << 0)
 #define KVM_MSR_FILTER_WRITE (1 << 1)
+#define KVM_MSR_FILTER_RANGE_VALID_MASK (KVM_MSR_FILTER_READ | \
+					 KVM_MSR_FILTER_WRITE)
 	__u32 flags;
 	__u32 nmsrs; /* number of msrs in bitmap */
 	__u32 base;  /* MSR index the bitmap starts at */
@@ -222,8 +217,11 @@ struct kvm_msr_filter_range {
 
 #define KVM_MSR_FILTER_MAX_RANGES 16
 struct kvm_msr_filter {
+#ifndef __KERNEL__
 #define KVM_MSR_FILTER_DEFAULT_ALLOW (0 << 0)
+#endif
 #define KVM_MSR_FILTER_DEFAULT_DENY  (1 << 0)
+#define KVM_MSR_FILTER_VALID_MASK (KVM_MSR_FILTER_DEFAULT_DENY)
 	__u32 flags;
 	struct kvm_msr_filter_range ranges[KVM_MSR_FILTER_MAX_RANGES];
 };
@@ -510,8 +508,8 @@ struct kvm_nested_state {
 	 * KVM_{GET,PUT}_NESTED_STATE ioctl values.
 	 */
 	union {
-		struct kvm_vmx_nested_state_data vmx[0];
-		struct kvm_svm_nested_state_data svm[0];
+		__DECLARE_FLEX_ARRAY(struct kvm_vmx_nested_state_data, vmx);
+		__DECLARE_FLEX_ARRAY(struct kvm_svm_nested_state_data, svm);
 	} data;
 };
 
@@ -528,8 +526,40 @@ struct kvm_pmu_event_filter {
 #define KVM_PMU_EVENT_ALLOW 0
 #define KVM_PMU_EVENT_DENY 1
 
+#define KVM_PMU_EVENT_FLAG_MASKED_EVENTS BIT(0)
+#define KVM_PMU_EVENT_FLAGS_VALID_MASK (KVM_PMU_EVENT_FLAG_MASKED_EVENTS)
+
+/*
+ * Masked event layout.
+ * Bits   Description
+ * ----   -----------
+ * 7:0    event select (low bits)
+ * 15:8   umask match
+ * 31:16  unused
+ * 35:32  event select (high bits)
+ * 36:54  unused
+ * 55     exclude bit
+ * 63:56  umask mask
+ */
+
+#define KVM_PMU_ENCODE_MASKED_ENTRY(event_select, mask, match, exclude) \
+	(((event_select) & 0xFFULL) | (((event_select) & 0XF00ULL) << 24) | \
+	(((mask) & 0xFFULL) << 56) | \
+	(((match) & 0xFFULL) << 8) | \
+	((__u64)(!!(exclude)) << 55))
+
+#define KVM_PMU_MASKED_ENTRY_EVENT_SELECT \
+	(GENMASK_ULL(7, 0) | GENMASK_ULL(35, 32))
+#define KVM_PMU_MASKED_ENTRY_UMASK_MASK		(GENMASK_ULL(63, 56))
+#define KVM_PMU_MASKED_ENTRY_UMASK_MATCH	(GENMASK_ULL(15, 8))
+#define KVM_PMU_MASKED_ENTRY_EXCLUDE		(BIT_ULL(55))
+#define KVM_PMU_MASKED_ENTRY_UMASK_MASK_SHIFT	(56)
+
 /* for KVM_{GET,SET,HAS}_DEVICE_ATTR */
 #define KVM_VCPU_TSC_CTRL 0 /* control group for the timestamp counter (TSC) */
 #define   KVM_VCPU_TSC_OFFSET 0 /* attribute for the TSC offset */
 
+/* x86-specific KVM_EXIT_HYPERCALL flags. */
+#define KVM_EXIT_HYPERCALL_LONG_MODE	BIT(0)
+
 #endif /* _ASM_X86_KVM_H */
-- 
2.34.1

