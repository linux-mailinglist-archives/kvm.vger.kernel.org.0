Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4904CC9DC
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 00:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235616AbiCCXM1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 18:12:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235368AbiCCXMX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 18:12:23 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 588D6673EE
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 15:11:37 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id g39so11102636lfv.10
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 15:11:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oA6xyu3ogYw0nSByGA21Lw5hc/VmPkl/56Z5A2HJfbg=;
        b=QoYXUkDz/AThGRUFf4cxtv2/+StUVjqbVOaSdUQ8/62gJgGhWC4HYSlkd8VsGXAsdO
         HnP8vbdjdQtaq0cQKlgJpQzonABf/vimA2ds4jytvBA5FAJ2rMjVt5pkPYSQvh4L/e9P
         QUdxybWnojNUIqHBKLsvoO4ZpGVidqe/j9ZueqrBgBqum3wisqVwlF6LI+IaPH6FOEzc
         dPPScofZEM2SC3lDNZ+Sa/qI7Fpbe93SVt5g+34PVmh+QbLLtQ+GqRL0Z2oxhF56vHF8
         bkny7dHm6XaScL9WT7IFQH2empdIyM4TPe5t0YzI+3Hh418d8368vlOlOWbd8s+1HHu6
         febg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oA6xyu3ogYw0nSByGA21Lw5hc/VmPkl/56Z5A2HJfbg=;
        b=UGMpqCRMOydt5mDwoDIJXJR6NYoHgTPSatT557jpu5KBbQkyJKvVXuwVlE2mXyTcW0
         XL2SndoAA1hHa3JogK/iI1ypXZ/urRjSLKX4uL/qwyUAE+1e8rdAq0pvyw3bsOz4J21z
         tHUc/hqTD91ITYsRZ+jzDt6So7AngahEEd1vTAoQf+7m7t8TgLzI+qG25nHFiO7jnHEZ
         EhoDvFCyC5PsW+jpi2kzecSBSxjIcz/f1/cX/w4JgbZRdGXQ9niwkurLWH58vprhGz3L
         FHfjBoNRHILlE1N23PcZRV5qA+gcj0fA0s1G6WyPkgxGKtZbf816H8luOJpawqBEfhnX
         kBng==
X-Gm-Message-State: AOAM531oPSXCnyb/RPS2kNYL+drQKB09riDcSHJqzA2un4ISHr+8woet
        RMCogkdEjBYImLY4RIXSF6R0M33UJd0=
X-Google-Smtp-Source: ABdhPJz/5Oiar8wpwDQupnIme61O2C+2hyE+aHbmd7FZro4vFGYLWKyH7fPbvf64ks+S9DA9cQOKRA==
X-Received: by 2002:a05:6512:1194:b0:43e:8e84:4eca with SMTP id g20-20020a056512119400b0043e8e844ecamr22566366lfr.611.1646349095539;
        Thu, 03 Mar 2022 15:11:35 -0800 (PST)
Received: from localhost.localdomain (88-115-234-153.elisa-laajakaista.fi. [88.115.234.153])
        by smtp.gmail.com with ESMTPSA id g13-20020a2ea4ad000000b0023382d8819esm725264ljm.69.2022.03.03.15.11.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 15:11:35 -0800 (PST)
From:   Martin Radev <martin.b.radev@gmail.com>
To:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, andre.przywara@arm.com,
        alexandru.elisei@arm.com
Cc:     Martin Radev <martin.b.radev@gmail.com>
Subject: [PATCH kvmtool 3/5] virtio: Check for overflows in QUEUE_NOTIFY and QUEUE_SEL
Date:   Fri,  4 Mar 2022 01:10:48 +0200
Message-Id: <20220303231050.2146621-4-martin.b.radev@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220303231050.2146621-1-martin.b.radev@gmail.com>
References: <20220303231050.2146621-1-martin.b.radev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch checks for overflows in QUEUE_NOTIFY and QUEUE_SEL in
the PCI and MMIO operation handling paths. Further, the return
value type of get_vq_count is changed from int to uint since negative
doesn't carry any semantic meaning.

Signed-off-by: Martin Radev <martin.b.radev@gmail.com>
---
 include/kvm/virtio.h |  2 +-
 virtio/9p.c          |  2 +-
 virtio/balloon.c     |  2 +-
 virtio/blk.c         |  2 +-
 virtio/console.c     |  2 +-
 virtio/mmio.c        | 20 ++++++++++++++++++--
 virtio/net.c         |  4 ++--
 virtio/pci.c         | 21 ++++++++++++++++++---
 virtio/rng.c         |  2 +-
 virtio/scsi.c        |  2 +-
 virtio/vsock.c       |  2 +-
 11 files changed, 46 insertions(+), 15 deletions(-)

diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
index 3880e74..ad274ac 100644
--- a/include/kvm/virtio.h
+++ b/include/kvm/virtio.h
@@ -187,7 +187,7 @@ struct virtio_ops {
 	size_t (*get_config_size)(struct kvm *kvm, void *dev);
 	u32 (*get_host_features)(struct kvm *kvm, void *dev);
 	void (*set_guest_features)(struct kvm *kvm, void *dev, u32 features);
-	int (*get_vq_count)(struct kvm *kvm, void *dev);
+	unsigned int (*get_vq_count)(struct kvm *kvm, void *dev);
 	int (*init_vq)(struct kvm *kvm, void *dev, u32 vq, u32 page_size,
 		       u32 align, u32 pfn);
 	void (*exit_vq)(struct kvm *kvm, void *dev, u32 vq);
diff --git a/virtio/9p.c b/virtio/9p.c
index 6074f3a..7374f1e 100644
--- a/virtio/9p.c
+++ b/virtio/9p.c
@@ -1469,7 +1469,7 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
 	return size;
 }
 
-static int get_vq_count(struct kvm *kvm, void *dev)
+static unsigned int get_vq_count(struct kvm *kvm, void *dev)
 {
 	return NUM_VIRT_QUEUES;
 }
diff --git a/virtio/balloon.c b/virtio/balloon.c
index 5bcd6ab..450b36a 100644
--- a/virtio/balloon.c
+++ b/virtio/balloon.c
@@ -251,7 +251,7 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
 	return size;
 }
 
-static int get_vq_count(struct kvm *kvm, void *dev)
+static unsigned int get_vq_count(struct kvm *kvm, void *dev)
 {
 	return NUM_VIRT_QUEUES;
 }
diff --git a/virtio/blk.c b/virtio/blk.c
index af71c0c..46ee028 100644
--- a/virtio/blk.c
+++ b/virtio/blk.c
@@ -291,7 +291,7 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
 	return size;
 }
 
-static int get_vq_count(struct kvm *kvm, void *dev)
+static unsigned int get_vq_count(struct kvm *kvm, void *dev)
 {
 	return NUM_VIRT_QUEUES;
 }
diff --git a/virtio/console.c b/virtio/console.c
index dae6034..8315808 100644
--- a/virtio/console.c
+++ b/virtio/console.c
@@ -216,7 +216,7 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
 	return size;
 }
 
-static int get_vq_count(struct kvm *kvm, void *dev)
+static unsigned int get_vq_count(struct kvm *kvm, void *dev)
 {
 	return VIRTIO_CONSOLE_NUM_QUEUES;
 }
diff --git a/virtio/mmio.c b/virtio/mmio.c
index 0094856..d3555b4 100644
--- a/virtio/mmio.c
+++ b/virtio/mmio.c
@@ -175,13 +175,22 @@ static void virtio_mmio_config_out(struct kvm_cpu *vcpu,
 {
 	struct virtio_mmio *vmmio = vdev->virtio;
 	struct kvm *kvm = vmmio->kvm;
+	unsigned int vq_count = vdev->ops->get_vq_count(kvm, vmmio->dev);
 	u32 val = 0;
 
 	switch (addr) {
 	case VIRTIO_MMIO_HOST_FEATURES_SEL:
 	case VIRTIO_MMIO_GUEST_FEATURES_SEL:
+		val = ioport__read32(data);
+		*(u32 *)(((void *)&vmmio->hdr) + addr) = val;
+		break;
 	case VIRTIO_MMIO_QUEUE_SEL:
 		val = ioport__read32(data);
+		if (val >= vq_count) {
+			WARN_ONCE(1, "QUEUE_SEL value (%u) is larger than VQ count (%u)\n",
+				val, vq_count);
+			break;
+		}
 		*(u32 *)(((void *)&vmmio->hdr) + addr) = val;
 		break;
 	case VIRTIO_MMIO_STATUS:
@@ -227,6 +236,11 @@ static void virtio_mmio_config_out(struct kvm_cpu *vcpu,
 		break;
 	case VIRTIO_MMIO_QUEUE_NOTIFY:
 		val = ioport__read32(data);
+		if (val >= vq_count) {
+			WARN_ONCE(1, "QUEUE_NOTIFY value (%u) is larger than VQ count (%u)\n",
+				val, vq_count);
+			break;
+		}
 		vdev->ops->notify_vq(vmmio->kvm, vmmio->dev, val);
 		break;
 	case VIRTIO_MMIO_INTERRUPT_ACK:
@@ -346,10 +360,12 @@ int virtio_mmio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 
 int virtio_mmio_reset(struct kvm *kvm, struct virtio_device *vdev)
 {
-	int vq;
+	unsigned int vq;
 	struct virtio_mmio *vmmio = vdev->virtio;
+	unsigned int vq_count;
 
-	for (vq = 0; vq < vdev->ops->get_vq_count(kvm, vmmio->dev); vq++)
+	vq_count = vdev->ops->get_vq_count(kvm, vmmio->dev);
+	for (vq = 0; vq < vq_count; vq++)
 		virtio_mmio_exit_vq(kvm, vdev, vq);
 
 	return 0;
diff --git a/virtio/net.c b/virtio/net.c
index ec5dc1f..8dd523f 100644
--- a/virtio/net.c
+++ b/virtio/net.c
@@ -755,11 +755,11 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
 	return size;
 }
 
-static int get_vq_count(struct kvm *kvm, void *dev)
+static unsigned int get_vq_count(struct kvm *kvm, void *dev)
 {
 	struct net_dev *ndev = dev;
 
-	return ndev->queue_pairs * 2 + 1;
+	return ndev->queue_pairs * 2U + 1U;
 }
 
 static struct virtio_ops net_dev_virtio_ops = {
diff --git a/virtio/pci.c b/virtio/pci.c
index 0b5cccd..9a6cbf3 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -329,9 +329,11 @@ static bool virtio_pci__data_out(struct kvm_cpu *vcpu, struct virtio_device *vde
 	struct virtio_pci *vpci;
 	struct kvm *kvm;
 	u32 val;
+	unsigned int vq_count;
 
 	kvm = vcpu->kvm;
 	vpci = vdev->virtio;
+	vq_count = vdev->ops->get_vq_count(kvm, vpci->dev);
 
 	switch (offset) {
 	case VIRTIO_PCI_GUEST_FEATURES:
@@ -351,10 +353,21 @@ static bool virtio_pci__data_out(struct kvm_cpu *vcpu, struct virtio_device *vde
 		}
 		break;
 	case VIRTIO_PCI_QUEUE_SEL:
-		vpci->queue_selector = ioport__read16(data);
+		val = ioport__read16(data);
+		if (val >= vq_count) {
+			WARN_ONCE(1, "QUEUE_SEL value (%u) is larger than VQ count (%u)\n",
+				val, vq_count);
+			return false;
+		}
+		vpci->queue_selector = val;
 		break;
 	case VIRTIO_PCI_QUEUE_NOTIFY:
 		val = ioport__read16(data);
+		if (val >= vq_count) {
+			WARN_ONCE(1, "QUEUE_SEL value (%u) is larger than VQ count (%u)\n",
+				val, vq_count);
+			return false;
+		}
 		vdev->ops->notify_vq(kvm, vpci->dev, val);
 		break;
 	case VIRTIO_PCI_STATUS:
@@ -647,10 +660,12 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 
 int virtio_pci__reset(struct kvm *kvm, struct virtio_device *vdev)
 {
-	int vq;
+	unsigned int vq;
+	unsigned int vq_count;
 	struct virtio_pci *vpci = vdev->virtio;
 
-	for (vq = 0; vq < vdev->ops->get_vq_count(kvm, vpci->dev); vq++)
+	vq_count = vdev->ops->get_vq_count(kvm, vpci->dev);
+	for (vq = 0; vq < vq_count; vq++)
 		virtio_pci_exit_vq(kvm, vdev, vq);
 
 	return 0;
diff --git a/virtio/rng.c b/virtio/rng.c
index c7835a0..75b682e 100644
--- a/virtio/rng.c
+++ b/virtio/rng.c
@@ -147,7 +147,7 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
 	return size;
 }
 
-static int get_vq_count(struct kvm *kvm, void *dev)
+static unsigned int get_vq_count(struct kvm *kvm, void *dev)
 {
 	return NUM_VIRT_QUEUES;
 }
diff --git a/virtio/scsi.c b/virtio/scsi.c
index 8f1c348..60432cc 100644
--- a/virtio/scsi.c
+++ b/virtio/scsi.c
@@ -176,7 +176,7 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
 	return size;
 }
 
-static int get_vq_count(struct kvm *kvm, void *dev)
+static unsigned int get_vq_count(struct kvm *kvm, void *dev)
 {
 	return NUM_VIRT_QUEUES;
 }
diff --git a/virtio/vsock.c b/virtio/vsock.c
index 34397b6..64b4e95 100644
--- a/virtio/vsock.c
+++ b/virtio/vsock.c
@@ -204,7 +204,7 @@ static void notify_vq_gsi(struct kvm *kvm, void *dev, u32 vq, u32 gsi)
 		die_perror("VHOST_SET_VRING_CALL failed");
 }
 
-static int get_vq_count(struct kvm *kvm, void *dev)
+static unsigned int get_vq_count(struct kvm *kvm, void *dev)
 {
 	return VSOCK_VQ_MAX;
 }
-- 
2.25.1

