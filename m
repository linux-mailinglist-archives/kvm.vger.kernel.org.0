Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D105E540443
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 19:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345364AbiFGRDa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 13:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345351AbiFGRDX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 13:03:23 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BBA91FF588
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 10:03:22 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9BBC81480;
        Tue,  7 Jun 2022 10:03:22 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 362703F66F;
        Tue,  7 Jun 2022 10:03:21 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
To:     will@kernel.org
Cc:     andre.przywara@arm.com, alexandru.elisei@arm.com,
        kvm@vger.kernel.org, suzuki.poulose@arm.com,
        sasha.levin@oracle.com, jean-philippe@linaro.org
Subject: [PATCH kvmtool 06/24] virtio: Add config access helpers
Date:   Tue,  7 Jun 2022 18:02:21 +0100
Message-Id: <20220607170239.120084-7-jean-philippe.brucker@arm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607170239.120084-1-jean-philippe.brucker@arm.com>
References: <20220607170239.120084-1-jean-philippe.brucker@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

At the moment device-specific config access is tailored for a Linux
guest, that performs any access in 8 bits. But config access can have
any size, and modern virtio drivers must use the size of the accessed
field. Add helpers that generalize config accesses.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 include/kvm/virtio.h |  3 +++
 virtio/core.c        | 38 ++++++++++++++++++++++++++++++++++++++
 virtio/mmio.c        | 30 ++----------------------------
 virtio/pci.c         | 41 ++++-------------------------------------
 4 files changed, 47 insertions(+), 65 deletions(-)

diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
index 24179ecc..cc4ba1d6 100644
--- a/include/kvm/virtio.h
+++ b/include/kvm/virtio.h
@@ -236,6 +236,9 @@ void virtio_init_device_vq(struct kvm *kvm, struct virtio_device *vdev,
 			   struct virt_queue *vq, size_t nr_descs);
 void virtio_exit_vq(struct kvm *kvm, struct virtio_device *vdev, void *dev,
 		    int num);
+bool virtio_access_config(struct kvm *kvm, struct virtio_device *vdev, void *dev,
+			  unsigned long offset, void *data, size_t size,
+			  bool is_write);
 void virtio_set_guest_features(struct kvm *kvm, struct virtio_device *vdev,
 			       void *dev, u32 features);
 void virtio_notify_status(struct kvm *kvm, struct virtio_device *vdev,
diff --git a/virtio/core.c b/virtio/core.c
index d6f2c689..be0f6f8d 100644
--- a/virtio/core.c
+++ b/virtio/core.c
@@ -282,6 +282,44 @@ void virtio_notify_status(struct kvm *kvm, struct virtio_device *vdev,
 		vdev->ops->notify_status(kvm, dev, ext_status);
 }
 
+bool virtio_access_config(struct kvm *kvm, struct virtio_device *vdev,
+			  void *dev, unsigned long offset, void *data,
+			  size_t size, bool is_write)
+{
+	void *in, *out, *config;
+	size_t config_size = vdev->ops->get_config_size(kvm, dev);
+
+	if (WARN_ONCE(offset + size > config_size,
+		      "Config access offset (%lu) is beyond config size (%zu)\n",
+		      offset, config_size))
+		return false;
+
+	config = vdev->ops->get_config(kvm, dev) + offset;
+
+	in = is_write ? data : config;
+	out = is_write ? config : data;
+
+	switch (size) {
+	case 1:
+		*(u8 *)out = *(u8 *)in;
+		break;
+	case 2:
+		*(u16 *)out = *(u16 *)in;
+		break;
+	case 4:
+		*(u32 *)out = *(u32 *)in;
+		break;
+	case 8:
+		*(u64 *)out = *(u64 *)in;
+		break;
+	default:
+		WARN_ONCE(1, "%s: invalid access size\n", __func__);
+		return false;
+	}
+
+	return true;
+}
+
 int virtio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 		struct virtio_ops *ops, enum virtio_trans trans,
 		int device_id, int subsys_id, int class)
diff --git a/virtio/mmio.c b/virtio/mmio.c
index 77289e2b..268a4391 100644
--- a/virtio/mmio.c
+++ b/virtio/mmio.c
@@ -98,33 +98,6 @@ int virtio_mmio_signal_config(struct kvm *kvm, struct virtio_device *vdev)
 	return 0;
 }
 
-static void virtio_mmio_device_specific(struct kvm_cpu *vcpu,
-					u64 addr, u8 *data, u32 len,
-					u8 is_write, struct virtio_device *vdev)
-{
-	struct virtio_mmio *vmmio = vdev->virtio;
-	u8 *config;
-	size_t config_size;
-	u32 i;
-
-	config = vdev->ops->get_config(vmmio->kvm, vmmio->dev);
-	config_size = vdev->ops->get_config_size(vmmio->kvm, vmmio->dev);
-
-	/* Prevent invalid accesses which go beyond the config */
-	if (config_size < addr + len) {
-		WARN_ONCE(1, "Offset (%llu) Length (%u) goes beyond config size (%zu).\n",
-			addr, len, config_size);
-		return;
-	}
-
-	for (i = 0; i < len; i++) {
-		if (is_write)
-			config[addr + i] = *(u8 *)data + i;
-		else
-			data[i] = config[addr + i];
-	}
-}
-
 #define vmmio_selected_vq(vdev, vmmio) \
 	(vdev)->ops->get_vq((vmmio)->kvm, (vmmio)->dev, (vmmio)->hdr.queue_sel)
 
@@ -263,7 +236,8 @@ static void virtio_mmio_mmio_callback(struct kvm_cpu *vcpu,
 
 	if (offset >= VIRTIO_MMIO_CONFIG) {
 		offset -= VIRTIO_MMIO_CONFIG;
-		virtio_mmio_device_specific(vcpu, offset, data, len, is_write, ptr);
+		virtio_access_config(vmmio->kvm, vdev, vmmio->dev, offset, data,
+				     len, is_write);
 		return;
 	}
 
diff --git a/virtio/pci.c b/virtio/pci.c
index 20b16228..85018e79 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -135,25 +135,8 @@ static bool virtio_pci__specific_data_in(struct kvm *kvm, struct virtio_device *
 
 		return true;
 	} else if (type == VIRTIO_PCI_O_CONFIG) {
-		u8 cfg;
-		size_t config_size;
-
-		config_size = vdev->ops->get_config_size(kvm, vpci->dev);
-		if (config_offset + size > config_size) {
-			/* Access goes beyond the config size, so return failure. */
-			WARN_ONCE(1, "Config access offset (%u) is beyond config size (%zu)\n",
-				config_offset, config_size);
-			return false;
-		}
-
-		/* TODO: Handle access lengths beyond one byte */
-		if (size != 1) {
-			WARN_ONCE(1, "Size (%u) not supported\n", size);
-			return false;
-		}
-		cfg = vdev->ops->get_config(kvm, vpci->dev)[config_offset];
-		ioport__write8(data, cfg);
-		return true;
+		return virtio_access_config(kvm, vdev, vpci->dev, config_offset,
+					    data, size, false);
 	}
 
 	return false;
@@ -290,24 +273,8 @@ static bool virtio_pci__specific_data_out(struct kvm *kvm, struct virtio_device
 
 		return true;
 	} else if (type == VIRTIO_PCI_O_CONFIG) {
-		size_t config_size;
-
-		config_size = vdev->ops->get_config_size(kvm, vpci->dev);
-		if (config_offset + size > config_size) {
-			/* Access goes beyond the config size, so return failure. */
-			WARN_ONCE(1, "Config access offset (%u) is beyond config size (%zu)\n",
-				config_offset, config_size);
-			return false;
-		}
-
-		/* TODO: Handle access lengths beyond one byte */
-		if (size != 1) {
-			WARN_ONCE(1, "Size (%u) not supported\n", size);
-			return false;
-		}
-		vdev->ops->get_config(kvm, vpci->dev)[config_offset] = *(u8 *)data;
-
-		return true;
+		return virtio_access_config(kvm, vdev, vpci->dev, config_offset,
+					    data, size, true);
 	}
 
 	return false;
-- 
2.36.1

