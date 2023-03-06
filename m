Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B305E6ABEFE
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 13:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbjCFMDm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 07:03:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbjCFMDh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 07:03:37 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842D91E5CD
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 04:03:35 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id h14so8547105wru.4
        for <kvm@vger.kernel.org>; Mon, 06 Mar 2023 04:03:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112; t=1678104214;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EcYvXsX9BDvRsAMkLCutb/mxJegXnEsqufZwCKPPSWU=;
        b=EisX+/XR8eWYQrSrb1fvzTMV8o3UdilJiuunyUwgZder+upWOZobUSvPvWHsvAUh9l
         L/rx2pL9Pb2sk58XeWsTKw/0aQtfOas4zNk+Dy/wMig6rh4vhQkwdHqqYu8Af8ENw65L
         ImRNxXCZU5kDX4gb/efN0PAtC59SNNGvDqRQqKdH7o8Ogg6qF1WAvLCSqswI9zX7RbVy
         HzE1kWYye8/QOgLZPnwj9XhON/evjRa7gn4iH7VzvGMhT3wnLVW2dI2Eu+gXwddfrGuG
         96qg62rWtInKC4pousM1024rMFcxdAeCujxMuz8O+SY9/XYimB7OWFDLq/l6wirGVCG2
         vOvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678104214;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EcYvXsX9BDvRsAMkLCutb/mxJegXnEsqufZwCKPPSWU=;
        b=h3nxvCrVh1I96KTy1oQuarRkYp0r8Gi8r0JqRUUSJ/ICrLJ/3ILM3a2YuZwy5Jxu7E
         yKb69RmfWGYOL+yKN/2Sv+Hx6zxYKIgiG+VF3EYVsgIpcS1CpOEQMq/GcnJGnmDLm5Xp
         oqvTt4wuK3v4R5BhN9mmZcH9v93ui94cvITukrR6nFxLLOhj/DrT2cyQFNv6iHolwlIb
         h2EXfP4NmGc55VXzEOw9iTsRs0yMJEKTKKMkpBQ4hzpkzjiEdnjViXr5fAjhIQONFxIF
         3tzCJ0CoQaug9CT9Q3nJqsoFoMLdb6jZklJ8cAO0u/jL2RowvhU5l/Ole9aS1PvueEwD
         MLfg==
X-Gm-Message-State: AO0yUKW/aLbfJ1lhhgYk7JzivRTiLMNTN39mmj8swM9AGTdRi4JXmAlU
        rEhNaPnGPOmx/OTZZjsC7MQmJg==
X-Google-Smtp-Source: AK7set/SMvcl6mQs4rTalvjyKqpue8aSCFcZ3HosTUKZRyTEnmDacpQOF3E502WDSJmIO9yItsU/Hw==
X-Received: by 2002:a5d:650d:0:b0:2bf:ae19:d8e4 with SMTP id x13-20020a5d650d000000b002bfae19d8e4mr6694975wru.16.1678104214045;
        Mon, 06 Mar 2023 04:03:34 -0800 (PST)
Received: from localhost.localdomain (cpc90948-gill19-2-0-cust524.20-1.cable.virginm.net. [81.105.82.13])
        by smtp.gmail.com with ESMTPSA id k7-20020a05600c080700b003e21ba8684dsm10106959wmp.26.2023.03.06.04.03.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 04:03:33 -0800 (PST)
From:   Rajnesh Kanwal <rkanwal@rivosinc.com>
To:     rkanwal@rivosinc.com, atishp@rivosinc.com
Cc:     apatel@ventanamicro.com, kvm@vger.kernel.org,
        alexandru.elisei@arm.com, will@kernel.org,
        julien.thierry.kdev@gmail.com, maz@kernel.org,
        andre.przywara@arm.com, jean-philippe@linaro.org
Subject: [PATCH kvmtool 1/1] Add virtio-transport option and deprecate force-pci and virtio-legacy.
Date:   Mon,  6 Mar 2023 12:03:29 +0000
Message-Id: <20230306120329.535320-1-rkanwal@rivosinc.com>
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

This is a follow-up patch for [0] which introduced --force-pci option
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
 builtin-run.c                            | 11 +++++++--
 include/kvm/kvm-config.h                 |  2 +-
 include/kvm/kvm.h                        |  6 +----
 include/kvm/virtio.h                     |  2 ++
 riscv/include/kvm/kvm-arch.h             |  3 ---
 virtio/core.c                            | 29 ++++++++++++++++++++++++
 8 files changed, 46 insertions(+), 20 deletions(-)

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
index 9949bfe..2e620fd 100644
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
+			   "transport [Deprecated: Use --virtio-transport "	\
+			   "option instead]", virtio_tranport_parser, kvm),	\
         OPT_CALLBACK('\0', "irqchip", &(cfg)->irqchip,				\
 		     "[gicv2|gicv2m|gicv3|gicv3-its]",				\
 		     "Type of interrupt controller to emulate in the guest",	\
diff --git a/builtin-run.c b/builtin-run.c
index bb7e6e8..50e8796 100644
--- a/builtin-run.c
+++ b/builtin-run.c
@@ -200,8 +200,15 @@ static int mem_parser(const struct option *opt, const char *arg, int unset)
 			" rootfs"),					\
 	OPT_STRING('\0', "hugetlbfs", &(cfg)->hugetlbfs_path, "path",	\
 			"Hugetlbfs path"),				\
-	OPT_BOOLEAN('\0', "virtio-legacy", &(cfg)->virtio_legacy,	\
-		    "Use legacy virtio transport"),			\
+	OPT_CALLBACK_NOOPT('\0', "virtio-legacy",			\
+			   &(cfg)->virtio_transport, '\0',		\
+			   "Use legacy virtio transport [Deprecated:"	\
+			   " Use --virtio-transport option instead]",	\
+			   virtio_tranport_parser, NULL),		\
+	OPT_CALLBACK('\0', "virtio-transport", &(cfg)->virtio_transport,\
+		     "[pci|pci-legacy|mmio|mmio-legacy]",		\
+		     "Type of virtio transport",			\
+		     virtio_tranport_parser, NULL),			\
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
index 3872dc6..7015def 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -45,11 +45,7 @@ struct kvm_cpu;
 typedef void (*mmio_handler_fn)(struct kvm_cpu *vcpu, u64 addr, u8 *data,
 				u32 len, u8 is_write, void *ptr);
 
-/* Archs can override this in kvm-arch.h */
-#ifndef VIRTIO_DEFAULT_TRANS
-#define VIRTIO_DEFAULT_TRANS(kvm) \
-	((kvm)->cfg.virtio_legacy ? VIRTIO_PCI_LEGACY : VIRTIO_PCI)
-#endif
+#define VIRTIO_DEFAULT_TRANS(kvm) (kvm)->cfg.virtio_transport
 
 enum {
 	KVM_VMSTATE_RUNNING,
diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
index 94bddef..4a733f5 100644
--- a/include/kvm/virtio.h
+++ b/include/kvm/virtio.h
@@ -248,4 +248,6 @@ void virtio_set_guest_features(struct kvm *kvm, struct virtio_device *vdev,
 void virtio_notify_status(struct kvm *kvm, struct virtio_device *vdev,
 			  void *dev, u8 status);
 
+int virtio_tranport_parser(const struct option *opt, const char *arg, int unset);
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
diff --git a/virtio/core.c b/virtio/core.c
index ea0e5b6..4b863c7 100644
--- a/virtio/core.c
+++ b/virtio/core.c
@@ -21,6 +21,35 @@ const char* virtio_trans_name(enum virtio_trans trans)
 	return "unknown";
 }
 
+int virtio_tranport_parser(const struct option *opt, const char *arg, int unset)
+{
+	enum virtio_trans *type = opt->value;
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
+		struct kvm *kvm = opt->ptr;
+		kvm->cfg.virtio_transport = VIRTIO_PCI;
+	}
+
+	return 0;
+}
+
 void virt_queue__used_idx_advance(struct virt_queue *queue, u16 jump)
 {
 	u16 idx = virtio_guest_to_host_u16(queue, queue->vring.used->idx);
-- 
2.25.1

