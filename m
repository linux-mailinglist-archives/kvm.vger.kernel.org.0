Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 646D5602DF6
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 16:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbiJROJp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 10:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbiJROJj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 10:09:39 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 965CB1181D
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 07:09:32 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id bh13so13406742pgb.4
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 07:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DJ8EjICPlgkYNwiFOpcHJ6SbyD+51vA+/JJMHoSStf8=;
        b=DIiVRpTZRgqn7mHHz/kXbgBRQWCfm2s97L3rwVoI4dG6J52yjFY2SVTHFsH8fU6VZm
         /RvPt+tl6WGEYR1ResUPrMS/42KeYVd+pRdp647iicUxX6Aol21OVuRzh2etCbw8qtC/
         l2Nqvqbp7N+XWp/IaQfUpfG9oYts/b8UkmpKeZVlAdSm+lef3CSAAZUWR5AhEk69oWO0
         7uPM4o4hFsmTA18pzNv7e98sM4oFUTNaKp2Y8laRZ7l06c5Jg7qH1qEdIW9szHNQtjWP
         H4YaWNBbOVtmjfEFwfec5UabsSQhkmde/cFciaD9gpBoMyT5oI6e7j+zvC7wMhDKF2pH
         SPHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DJ8EjICPlgkYNwiFOpcHJ6SbyD+51vA+/JJMHoSStf8=;
        b=JBMnTrcz9gC36nbkUM41C4MOlph7xrzhrPz6mFXVHIYXZpOuV2gSmFjdoo5IJCEj0y
         BqFb16NgAbwBpYq9aF8h5GRqXX2AQdG1uEVNTTZwDSbqzD+8eTaY4w3h5ir01v3KFpsM
         SiFIl+rQ1lVlr9FQS/45KCyLX51aCoErC9rAcaQB9/5add0TKTMbuTTPCQ9od2TIlVGS
         IRW9X4vpzoaIo2oPZIiuZ/8TyM3UEQmSKwC99M5bqvSXroXJwm2tAmET3IbDQ44f8gby
         g08j9ztQsuBR+JTiNSmU+Ukx/3R8xNif2qNUsuiH8HcElNwX69IoXrsDngtofIRrg+7W
         zKWw==
X-Gm-Message-State: ACrzQf2I8LCohwfjTYUBBfqouqUeoKHb/Uampt1NlqrzRo/33m5egQNM
        8y6slS6+Rskb63e6IkS2ofxUPA==
X-Google-Smtp-Source: AMsMyM69Uz8/PcJIrUM+0yjYGd50qOw660QtgpbTUtcTNy4NBoT6+fHn1XtOY2k1bdRlyQSxdVWLnw==
X-Received: by 2002:a05:6a00:1828:b0:563:24ea:5728 with SMTP id y40-20020a056a00182800b0056324ea5728mr3201327pfa.3.1666102171473;
        Tue, 18 Oct 2022 07:09:31 -0700 (PDT)
Received: from anup-ubuntu64-vm.. ([171.76.86.161])
        by smtp.gmail.com with ESMTPSA id z15-20020a17090a170f00b002009db534d1sm8119913pjd.24.2022.10.18.07.09.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 07:09:30 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH kvmtool 1/6] Update UAPI headers based on Linux-6.1-rc1
Date:   Tue, 18 Oct 2022 19:38:49 +0530
Message-Id: <20221018140854.69846-2-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221018140854.69846-1-apatel@ventanamicro.com>
References: <20221018140854.69846-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We update all UAPI headers based on Linux-6.1-rc1 so that we can
use latest features.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arm/aarch64/include/asm/kvm.h |  6 ++++--
 include/linux/kvm.h           |  1 +
 include/linux/virtio_blk.h    | 19 +++++++++++++++++++
 include/linux/virtio_net.h    | 14 +++++++-------
 include/linux/virtio_ring.h   | 16 +++++++++++-----
 riscv/include/asm/kvm.h       |  4 ++++
 6 files changed, 46 insertions(+), 14 deletions(-)

diff --git a/arm/aarch64/include/asm/kvm.h b/arm/aarch64/include/asm/kvm.h
index 3bb1343..316917b 100644
--- a/arm/aarch64/include/asm/kvm.h
+++ b/arm/aarch64/include/asm/kvm.h
@@ -75,9 +75,11 @@ struct kvm_regs {
 
 /* KVM_ARM_SET_DEVICE_ADDR ioctl id encoding */
 #define KVM_ARM_DEVICE_TYPE_SHIFT	0
-#define KVM_ARM_DEVICE_TYPE_MASK	(0xffff << KVM_ARM_DEVICE_TYPE_SHIFT)
+#define KVM_ARM_DEVICE_TYPE_MASK	GENMASK(KVM_ARM_DEVICE_TYPE_SHIFT + 15, \
+						KVM_ARM_DEVICE_TYPE_SHIFT)
 #define KVM_ARM_DEVICE_ID_SHIFT		16
-#define KVM_ARM_DEVICE_ID_MASK		(0xffff << KVM_ARM_DEVICE_ID_SHIFT)
+#define KVM_ARM_DEVICE_ID_MASK		GENMASK(KVM_ARM_DEVICE_ID_SHIFT + 15, \
+						KVM_ARM_DEVICE_ID_SHIFT)
 
 /* Supported device IDs */
 #define KVM_ARM_DEVICE_VGIC_V2		0
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index eed0315..0d5d441 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -1177,6 +1177,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_VM_DISABLE_NX_HUGE_PAGES 220
 #define KVM_CAP_S390_ZPCI_OP 221
 #define KVM_CAP_S390_CPU_TOPOLOGY 222
+#define KVM_CAP_DIRTY_LOG_RING_ACQ_REL 223
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/include/linux/virtio_blk.h b/include/linux/virtio_blk.h
index d888f01..58e70b2 100644
--- a/include/linux/virtio_blk.h
+++ b/include/linux/virtio_blk.h
@@ -40,6 +40,7 @@
 #define VIRTIO_BLK_F_MQ		12	/* support more than one vq */
 #define VIRTIO_BLK_F_DISCARD	13	/* DISCARD is supported */
 #define VIRTIO_BLK_F_WRITE_ZEROES	14	/* WRITE ZEROES is supported */
+#define VIRTIO_BLK_F_SECURE_ERASE	16 /* Secure Erase is supported */
 
 /* Legacy feature bits */
 #ifndef VIRTIO_BLK_NO_LEGACY
@@ -121,6 +122,21 @@ struct virtio_blk_config {
 	__u8 write_zeroes_may_unmap;
 
 	__u8 unused1[3];
+
+	/* the next 3 entries are guarded by VIRTIO_BLK_F_SECURE_ERASE */
+	/*
+	 * The maximum secure erase sectors (in 512-byte sectors) for
+	 * one segment.
+	 */
+	__virtio32 max_secure_erase_sectors;
+	/*
+	 * The maximum number of secure erase segments in a
+	 * secure erase command.
+	 */
+	__virtio32 max_secure_erase_seg;
+	/* Secure erase commands must be aligned to this number of sectors. */
+	__virtio32 secure_erase_sector_alignment;
+
 } __attribute__((packed));
 
 /*
@@ -155,6 +171,9 @@ struct virtio_blk_config {
 /* Write zeroes command */
 #define VIRTIO_BLK_T_WRITE_ZEROES	13
 
+/* Secure erase command */
+#define VIRTIO_BLK_T_SECURE_ERASE	14
+
 #ifndef VIRTIO_BLK_NO_LEGACY
 /* Barrier before this op. */
 #define VIRTIO_BLK_T_BARRIER	0x80000000
diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index 29ced55..6cb842e 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -56,7 +56,7 @@
 #define VIRTIO_NET_F_MQ	22	/* Device supports Receive Flow
 					 * Steering */
 #define VIRTIO_NET_F_CTRL_MAC_ADDR 23	/* Set MAC address */
-#define VIRTIO_NET_F_NOTF_COAL	53	/* Guest can handle notifications coalescing */
+#define VIRTIO_NET_F_NOTF_COAL	53	/* Device supports notifications coalescing */
 #define VIRTIO_NET_F_HASH_REPORT  57	/* Supports hash report */
 #define VIRTIO_NET_F_RSS	  60	/* Supports RSS RX steering */
 #define VIRTIO_NET_F_RSC_EXT	  61	/* extended coalescing info */
@@ -364,24 +364,24 @@ struct virtio_net_hash_config {
  */
 #define VIRTIO_NET_CTRL_NOTF_COAL		6
 /*
- * Set the tx-usecs/tx-max-packets patameters.
- * tx-usecs - Maximum number of usecs to delay a TX notification.
- * tx-max-packets - Maximum number of packets to send before a TX notification.
+ * Set the tx-usecs/tx-max-packets parameters.
  */
 struct virtio_net_ctrl_coal_tx {
+	/* Maximum number of packets to send before a TX notification */
 	__le32 tx_max_packets;
+	/* Maximum number of usecs to delay a TX notification */
 	__le32 tx_usecs;
 };
 
 #define VIRTIO_NET_CTRL_NOTF_COAL_TX_SET		0
 
 /*
- * Set the rx-usecs/rx-max-packets patameters.
- * rx-usecs - Maximum number of usecs to delay a RX notification.
- * rx-max-frames - Maximum number of packets to receive before a RX notification.
+ * Set the rx-usecs/rx-max-packets parameters.
  */
 struct virtio_net_ctrl_coal_rx {
+	/* Maximum number of packets to receive before a RX notification */
 	__le32 rx_max_packets;
+	/* Maximum number of usecs to delay a RX notification */
 	__le32 rx_usecs;
 };
 
diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
index 476d3e5..f8c20d3 100644
--- a/include/linux/virtio_ring.h
+++ b/include/linux/virtio_ring.h
@@ -93,15 +93,21 @@
 #define VRING_USED_ALIGN_SIZE 4
 #define VRING_DESC_ALIGN_SIZE 16
 
-/* Virtio ring descriptors: 16 bytes.  These can chain together via "next". */
+/**
+ * struct vring_desc - Virtio ring descriptors,
+ * 16 bytes long. These can chain together via @next.
+ *
+ * @addr: buffer address (guest-physical)
+ * @len: buffer length
+ * @flags: descriptor flags
+ * @next: index of the next descriptor in the chain,
+ *        if the VRING_DESC_F_NEXT flag is set. We chain unused
+ *        descriptors via this, too.
+ */
 struct vring_desc {
-	/* Address (guest-physical). */
 	__virtio64 addr;
-	/* Length. */
 	__virtio32 len;
-	/* The flags as indicated above. */
 	__virtio16 flags;
-	/* We chain unused descriptors via this, too */
 	__virtio16 next;
 };
 
diff --git a/riscv/include/asm/kvm.h b/riscv/include/asm/kvm.h
index 7351417..8985ff2 100644
--- a/riscv/include/asm/kvm.h
+++ b/riscv/include/asm/kvm.h
@@ -48,6 +48,7 @@ struct kvm_sregs {
 /* CONFIG registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
 struct kvm_riscv_config {
 	unsigned long isa;
+	unsigned long zicbom_block_size;
 };
 
 /* CORE registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
@@ -98,6 +99,9 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_M,
 	KVM_RISCV_ISA_EXT_SVPBMT,
 	KVM_RISCV_ISA_EXT_SSTC,
+	KVM_RISCV_ISA_EXT_SVINVAL,
+	KVM_RISCV_ISA_EXT_ZIHINTPAUSE,
+	KVM_RISCV_ISA_EXT_ZICBOM,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
-- 
2.34.1

