Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68FA66C14CA
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 15:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbjCTOck (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 10:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbjCTOcg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 10:32:36 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F149444BE
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 07:32:33 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id h17so10552663wrt.8
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 07:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112; t=1679322752;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=e4rw82ASEnMf9RFG0s9fYPBcw0wuC45MeHL9uAXE5Oc=;
        b=10hkOaZM0dRnfpRnYbpcotfcniWBnn7MeeNk7ve+fXBfCT8IucgGYv3fNb5oU6fFQP
         do0Jqar/zEt0CN1W2bXwEQY5vAZR2KJS4zecz8sYK3c4VE2bTp1zS/lOVhHmzU6iEupV
         N5yDGXLdrt2b26HP/qXk4mhxFRAQvHZ932GJxSetB9MfE+amxov6uxghz51WGHW0ocWl
         gl6yMrSixcw/B04uQGUmQK718brq9dsR73wXoeiVl122+QMp/m/tJ7EkPdjchflxTEWm
         64WaNng1XEHmpc/hsI+AEDsKeHiwo+bHKzUv/rrdLwq10nzgfj2z8fGA06CoVXSiDRZy
         n/uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679322752;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e4rw82ASEnMf9RFG0s9fYPBcw0wuC45MeHL9uAXE5Oc=;
        b=aMd7S+x+Hbqq/pKkmNctfVP1qZ7PvgrUfWDiLCc6g2bvc9lMyq9jJb6rYg45Vcry3h
         UH2yRK9zngCsBEzBhAiUqxXEKB4vi/6i1BT+TNBkyjoBWL0V8696RWbjudAm6xjLK9/q
         xTvoFi2SIud44dDTi3jNS8/4rSojWqp3cB3Os5erJEJYi9y0ndC0dm4WvqalGn+bZ1ip
         rimqYJLCPF54HxN9rmlz2zptzQc6uFJK+n+DCgQfz8qjWWkC5fG/zzh9nwuUMBP0O6zG
         IEZRqjZ1bd93fdcoct1BemuXyZE+M6iGUCNMwO3Du+ij5F3KnvGkIGG1OMVT/cE32o0y
         Zcfg==
X-Gm-Message-State: AO0yUKXPS8WExBeY7GII8NSEcp1FtDpPvNTrJkIIY+ETg8p+28BlY/Ea
        uBuQjN/0DgfTazkPLlL4zPr/Pw==
X-Google-Smtp-Source: AK7set/oMj+FxFj7C+rpiMB9/7SiD/i9eGwAyP2JXmvf0oE+4xFEhnR7EgepeGSPtO3m6fn/nvar8A==
X-Received: by 2002:a05:6000:505:b0:2d4:951:ef09 with SMTP id a5-20020a056000050500b002d40951ef09mr7623754wrf.48.1679322752388;
        Mon, 20 Mar 2023 07:32:32 -0700 (PDT)
Received: from localhost.localdomain (cpc98982-watf12-2-0-cust57.15-2.cable.virginm.net. [82.26.13.58])
        by smtp.gmail.com with ESMTPSA id v6-20020a5d6106000000b002c55521903bsm9007953wrt.51.2023.03.20.07.32.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 07:32:31 -0700 (PDT)
From:   Rajnesh Kanwal <rkanwal@rivosinc.com>
To:     rkanwal@rivosinc.com
Cc:     atishp@rivosinc.com, apatel@ventanamicro.com, kvm@vger.kernel.org,
        alexandru.elisei@arm.com, will@kernel.org,
        julien.thierry.kdev@gmail.com, maz@kernel.org,
        andre.przywara@arm.com, jean-philippe@linaro.org
Subject: [PATCH kvmtool v3] Add virtio-transport option and deprecate force-pci and virtio-legacy.
Date:   Mon, 20 Mar 2023 14:32:24 +0000
Message-Id: <20230320143224.404220-1-rkanwal@rivosinc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a follow-up patch for [0] which proposed the --force-pci option
for riscv. As per the discussion it was concluded to add virtio-tranport
option taking in four options (pci, pci-legacy, mmio, mmio-legacy).

With this change force-pci and virtio-legacy are both deprecated and
arm's default transport changes from MMIO to PCI as agreed in [0].
This is also true for riscv.

Nothing changes for other architectures.

[0]: https://lore.kernel.org/all/20230118172007.408667-1-rkanwal@rivosinc.com/

Signed-off-by: Rajnesh Kanwal <rkanwal@rivosinc.com>
---
 arm/include/arm-common/kvm-arch.h        |  5 ----
 arm/include/arm-common/kvm-config-arch.h |  8 +++----
 builtin-run.c                            | 17 ++++++++++++--
 include/kvm/kvm-config.h                 |  2 +-
 include/kvm/kvm.h                        |  6 -----
 include/kvm/virtio.h                     |  2 ++
 riscv/include/kvm/kvm-arch.h             |  3 ---
 virtio/9p.c                              |  2 +-
 virtio/balloon.c                         |  2 +-
 virtio/blk.c                             |  2 +-
 virtio/console.c                         |  2 +-
 virtio/core.c                            | 30 ++++++++++++++++++++++++
 virtio/net.c                             |  4 ++--
 virtio/rng.c                             |  2 +-
 virtio/scsi.c                            |  2 +-
 virtio/vsock.c                           |  2 +-
 16 files changed, 61 insertions(+), 30 deletions(-)

diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
index b2ae373..60eec02 100644
--- a/arm/include/arm-common/kvm-arch.h
+++ b/arm/include/arm-common/kvm-arch.h
@@ -80,11 +80,6 @@
 
 #define KVM_VM_TYPE		0
 
-#define VIRTIO_DEFAULT_TRANS(kvm)					\
-	((kvm)->cfg.arch.virtio_trans_pci ?				\
-	 ((kvm)->cfg.virtio_legacy ? VIRTIO_PCI_LEGACY : VIRTIO_PCI) :	\
-	 ((kvm)->cfg.virtio_legacy ? VIRTIO_MMIO_LEGACY : VIRTIO_MMIO))
-
 #define VIRTIO_RING_ENDIAN	(VIRTIO_ENDIAN_LE | VIRTIO_ENDIAN_BE)
 
 #define ARCH_HAS_PCI_EXP	1
diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/arm-common/kvm-config-arch.h
index 9949bfe..87f5035 100644
--- a/arm/include/arm-common/kvm-config-arch.h
+++ b/arm/include/arm-common/kvm-config-arch.h
@@ -7,7 +7,6 @@ struct kvm_config_arch {
 	const char	*dump_dtb_filename;
 	const char	*vcpu_affinity;
 	unsigned int	force_cntfrq;
-	bool		virtio_trans_pci;
 	bool		aarch32_guest;
 	bool		has_pmuv3;
 	bool		mte_disabled;
@@ -28,9 +27,10 @@ int irqchip_parser(const struct option *opt, const char *arg, int unset);
 		     "Specify Generic Timer frequency in guest DT to "		\
 		     "work around buggy secure firmware *Firmware should be "	\
 		     "updated to program CNTFRQ correctly*"),			\
-	OPT_BOOLEAN('\0', "force-pci", &(cfg)->virtio_trans_pci,		\
-		    "Force virtio devices to use PCI as their default "		\
-		    "transport"),						\
+	OPT_CALLBACK_NOOPT('\0', "force-pci", NULL, '\0',			\
+			   "Force virtio devices to use PCI as their default "	\
+			   "transport (Deprecated: Use --virtio-transport "	\
+			   "option instead)", virtio_transport_parser, kvm),	\
         OPT_CALLBACK('\0', "irqchip", &(cfg)->irqchip,				\
 		     "[gicv2|gicv2m|gicv3|gicv3-its]",				\
 		     "Type of interrupt controller to emulate in the guest",	\
diff --git a/builtin-run.c b/builtin-run.c
index bb7e6e8..941ae0e 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -162,6 +162,12 @@ static int mem_parser(const struct option *opt, const char *arg, int unset)
 	" in megabytes (M)"
 #endif
 
+#if defined(CONFIG_ARM) || defined(CONFIG_ARM64) || defined(CONFIG_RISCV)
+#define VIRTIO_TRANS_OPT_HELP_SHORT    "[pci|pci-legacy|mmio|mmio-legacy]"
+#else
+#define VIRTIO_TRANS_OPT_HELP_SHORT    "[pci|pci-legacy]"
+#endif
+
 #define BUILD_OPTIONS(name, cfg, kvm)					\
 	struct option name[] = {					\
 	OPT_GROUP("Basic options:"),					\
@@ -200,8 +206,15 @@ static int mem_parser(const struct option *opt, const char *arg, int unset)
 			" rootfs"),					\
 	OPT_STRING('\0', "hugetlbfs", &(cfg)->hugetlbfs_path, "path",	\
 			"Hugetlbfs path"),				\
-	OPT_BOOLEAN('\0', "virtio-legacy", &(cfg)->virtio_legacy,	\
-		    "Use legacy virtio transport"),			\
+	OPT_CALLBACK_NOOPT('\0', "virtio-legacy",			\
+			   &(cfg)->virtio_transport, '\0',		\
+			   "Use legacy virtio transport (Deprecated:"	\
+			   " Use --virtio-transport option instead)",	\
+			   virtio_transport_parser, NULL),		\
+	OPT_CALLBACK('\0', "virtio-transport", &(cfg)->virtio_transport,\
+		     VIRTIO_TRANS_OPT_HELP_SHORT,		        \
+		     "Type of virtio transport",			\
+		     virtio_transport_parser, NULL),			\
 									\
 	OPT_GROUP("Kernel options:"),					\
 	OPT_STRING('k', "kernel", &(cfg)->kernel_filename, "kernel",	\
diff --git a/include/kvm/kvm-config.h b/include/kvm/kvm-config.h
index 368e6c7..592b035 100644
--- a/include/kvm/kvm-config.h
+++ b/include/kvm/kvm-config.h
@@ -64,7 +64,7 @@ struct kvm_config {
 	bool no_dhcp;
 	bool ioport_debug;
 	bool mmio_debug;
-	bool virtio_legacy;
+	int virtio_transport;
 };
 
 #endif
diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
index 3872dc6..eb23e2f 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -45,12 +45,6 @@ struct kvm_cpu;
 typedef void (*mmio_handler_fn)(struct kvm_cpu *vcpu, u64 addr, u8 *data,
 				u32 len, u8 is_write, void *ptr);
 
-/* Archs can override this in kvm-arch.h */
-#ifndef VIRTIO_DEFAULT_TRANS
-#define VIRTIO_DEFAULT_TRANS(kvm) \
-	((kvm)->cfg.virtio_legacy ? VIRTIO_PCI_LEGACY : VIRTIO_PCI)
-#endif
-
 enum {
 	KVM_VMSTATE_RUNNING,
 	KVM_VMSTATE_PAUSED,
diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
index 94bddef..0e8c7a6 100644
--- a/include/kvm/virtio.h
+++ b/include/kvm/virtio.h
@@ -248,4 +248,6 @@ void virtio_set_guest_features(struct kvm *kvm, struct virtio_device *vdev,
 void virtio_notify_status(struct kvm *kvm, struct virtio_device *vdev,
 			  void *dev, u8 status);
 
+int virtio_transport_parser(const struct option *opt, const char *arg, int unset);
+
 #endif /* KVM__VIRTIO_H */
diff --git a/riscv/include/kvm/kvm-arch.h b/riscv/include/kvm/kvm-arch.h
index 1e130f5..4106099 100644
--- a/riscv/include/kvm/kvm-arch.h
+++ b/riscv/include/kvm/kvm-arch.h
@@ -46,9 +46,6 @@
 
 #define KVM_VM_TYPE		0
 
-#define VIRTIO_DEFAULT_TRANS(kvm) \
-	((kvm)->cfg.virtio_legacy ? VIRTIO_MMIO_LEGACY : VIRTIO_MMIO)
-
 #define VIRTIO_RING_ENDIAN	VIRTIO_ENDIAN_LE
 
 #define ARCH_HAS_PCI_EXP	1
diff --git a/virtio/9p.c b/virtio/9p.c
index 19b66df..b809bcd 100644
--- a/virtio/9p.c
+++ b/virtio/9p.c
@@ -1552,7 +1552,7 @@ int virtio_9p__init(struct kvm *kvm)
 
 	list_for_each_entry(p9dev, &devs, list) {
 		r = virtio_init(kvm, p9dev, &p9dev->vdev, &p9_dev_virtio_ops,
-				VIRTIO_DEFAULT_TRANS(kvm), PCI_DEVICE_ID_VIRTIO_9P,
+				kvm->cfg.virtio_transport, PCI_DEVICE_ID_VIRTIO_9P,
 				VIRTIO_ID_9P, PCI_CLASS_9P);
 		if (r < 0)
 			return r;
diff --git a/virtio/balloon.c b/virtio/balloon.c
index 3a73432..01d1982 100644
--- a/virtio/balloon.c
+++ b/virtio/balloon.c
@@ -279,7 +279,7 @@ int virtio_bln__init(struct kvm *kvm)
 	memset(&bdev.config, 0, sizeof(struct virtio_balloon_config));
 
 	r = virtio_init(kvm, &bdev, &bdev.vdev, &bln_dev_virtio_ops,
-			VIRTIO_DEFAULT_TRANS(kvm), PCI_DEVICE_ID_VIRTIO_BLN,
+			kvm->cfg.virtio_transport, PCI_DEVICE_ID_VIRTIO_BLN,
 			VIRTIO_ID_BALLOON, PCI_CLASS_BLN);
 	if (r < 0)
 		return r;
diff --git a/virtio/blk.c b/virtio/blk.c
index 2d06391..f3c34f3 100644
--- a/virtio/blk.c
+++ b/virtio/blk.c
@@ -329,7 +329,7 @@ static int virtio_blk__init_one(struct kvm *kvm, struct disk_image *disk)
 	list_add_tail(&bdev->list, &bdevs);
 
 	r = virtio_init(kvm, bdev, &bdev->vdev, &blk_dev_virtio_ops,
-			VIRTIO_DEFAULT_TRANS(kvm), PCI_DEVICE_ID_VIRTIO_BLK,
+			kvm->cfg.virtio_transport, PCI_DEVICE_ID_VIRTIO_BLK,
 			VIRTIO_ID_BLOCK, PCI_CLASS_BLK);
 	if (r < 0)
 		return r;
diff --git a/virtio/console.c b/virtio/console.c
index d29319c..11a22a9 100644
--- a/virtio/console.c
+++ b/virtio/console.c
@@ -229,7 +229,7 @@ int virtio_console__init(struct kvm *kvm)
 		return 0;
 
 	r = virtio_init(kvm, &cdev, &cdev.vdev, &con_dev_virtio_ops,
-			VIRTIO_DEFAULT_TRANS(kvm), PCI_DEVICE_ID_VIRTIO_CONSOLE,
+			kvm->cfg.virtio_transport, PCI_DEVICE_ID_VIRTIO_CONSOLE,
 			VIRTIO_ID_CONSOLE, PCI_CLASS_CONSOLE);
 	if (r < 0)
 		return r;
diff --git a/virtio/core.c b/virtio/core.c
index ea0e5b6..568243a 100644
--- a/virtio/core.c
+++ b/virtio/core.c
@@ -21,6 +21,36 @@ const char* virtio_trans_name(enum virtio_trans trans)
 	return "unknown";
 }
 
+int virtio_transport_parser(const struct option *opt, const char *arg, int unset)
+{
+	enum virtio_trans *type = opt->value;
+	struct kvm *kvm;
+
+	if (!strcmp(opt->long_name, "virtio-transport")) {
+		if (!strcmp(arg, "pci")) {
+			*type = VIRTIO_PCI;
+		} else if (!strcmp(arg, "pci-legacy")) {
+			*type = VIRTIO_PCI_LEGACY;
+#if defined(CONFIG_ARM) || defined(CONFIG_ARM64) || defined(CONFIG_RISCV)
+		} else if (!strcmp(arg, "mmio")) {
+			*type = VIRTIO_MMIO;
+		} else if (!strcmp(arg, "mmio-legacy")) {
+			*type = VIRTIO_MMIO_LEGACY;
+#endif
+		} else {
+			pr_err("virtio-transport: unknown type \"%s\"\n", arg);
+			return -1;
+		}
+	} else if (!strcmp(opt->long_name, "virtio-legacy")) {
+		*type = VIRTIO_PCI_LEGACY;
+	} else if (!strcmp(opt->long_name, "force-pci")) {
+		kvm = opt->ptr;
+		kvm->cfg.virtio_transport = VIRTIO_PCI;
+	}
+
+	return 0;
+}
+
 void virt_queue__used_idx_advance(struct virt_queue *queue, u16 jump)
 {
 	u16 idx = virtio_guest_to_host_u16(queue, queue->vring.used->idx);
diff --git a/virtio/net.c b/virtio/net.c
index a5e0cea..8749ebf 100644
--- a/virtio/net.c
+++ b/virtio/net.c
@@ -928,10 +928,10 @@ done:
 
 static int virtio_net__init_one(struct virtio_net_params *params)
 {
-	int i, r;
+	enum virtio_trans trans = params->kvm->cfg.virtio_transport;
 	struct net_dev *ndev;
 	struct virtio_ops *ops;
-	enum virtio_trans trans = VIRTIO_DEFAULT_TRANS(params->kvm);
+	int i, r;
 
 	ndev = calloc(1, sizeof(struct net_dev));
 	if (ndev == NULL)
diff --git a/virtio/rng.c b/virtio/rng.c
index 63ab8fc..8f85d5e 100644
--- a/virtio/rng.c
+++ b/virtio/rng.c
@@ -173,7 +173,7 @@ int virtio_rng__init(struct kvm *kvm)
 	}
 
 	r = virtio_init(kvm, rdev, &rdev->vdev, &rng_dev_virtio_ops,
-			VIRTIO_DEFAULT_TRANS(kvm), PCI_DEVICE_ID_VIRTIO_RNG,
+			kvm->cfg.virtio_transport, PCI_DEVICE_ID_VIRTIO_RNG,
 			VIRTIO_ID_RNG, PCI_CLASS_RNG);
 	if (r < 0)
 		goto cleanup;
diff --git a/virtio/scsi.c b/virtio/scsi.c
index 0286b86..893dfe6 100644
--- a/virtio/scsi.c
+++ b/virtio/scsi.c
@@ -264,7 +264,7 @@ static int virtio_scsi_init_one(struct kvm *kvm, struct disk_image *disk)
 	list_add_tail(&sdev->list, &sdevs);
 
 	r = virtio_init(kvm, sdev, &sdev->vdev, &scsi_dev_virtio_ops,
-			VIRTIO_DEFAULT_TRANS(kvm), PCI_DEVICE_ID_VIRTIO_SCSI,
+			kvm->cfg.virtio_transport, PCI_DEVICE_ID_VIRTIO_SCSI,
 			VIRTIO_ID_SCSI, PCI_CLASS_BLK);
 	if (r < 0)
 		return r;
diff --git a/virtio/vsock.c b/virtio/vsock.c
index 18b45f3..a108e63 100644
--- a/virtio/vsock.c
+++ b/virtio/vsock.c
@@ -285,7 +285,7 @@ static int virtio_vsock_init_one(struct kvm *kvm, u64 guest_cid)
 	list_add_tail(&vdev->list, &vdevs);
 
 	r = virtio_init(kvm, vdev, &vdev->vdev, &vsock_dev_virtio_ops,
-		    VIRTIO_DEFAULT_TRANS(kvm), PCI_DEVICE_ID_VIRTIO_VSOCK,
+		    kvm->cfg.virtio_transport, PCI_DEVICE_ID_VIRTIO_VSOCK,
 		    VIRTIO_ID_VSOCK, PCI_CLASS_VSOCK);
 	if (r < 0)
 	    return r;
-- 
2.25.1

