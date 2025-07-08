Return-Path: <kvm+bounces-51733-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 15AD7AFC3A6
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 09:10:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D9CA17FC6F
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 07:10:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C62B825A354;
	Tue,  8 Jul 2025 07:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SP2nLkTS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A4F2571B8
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 07:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751958586; cv=none; b=kC5zbL2EdIK6vWFTSQun2xKR+7ftyrohWPy0qqWkdTffKQIvrz/9jVs7VxQ8cyiboDxcwcsYrOUwAqQPRliTxNg0Ua6zFjsdSZeqUsN9xJn4cBGHXC5ILBy/4ecf0/skQlor78DZBmMVUrGAFN5HRZJgReO4eLOQydClPzhqVic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751958586; c=relaxed/simple;
	bh=UJHi09MPL3kIZKOseAwotCZyseJCyzbsUABYX0rCz9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TPb4fr6s6WdJJ5nir8mXssITLjev0c+HYxFPEhelALjlJMTSD9mDW4ZbnK8WJnCdZyivHPHFSl3DFemDkey6cHtH6d6QLWvp2iooDHc0NXtx2qYzczQiFAX1J3O5mPQFlv5JwLc7tc3OrXEo30KyixNPaDRCyo5kQnsN+1t0VP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SP2nLkTS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751958583;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kNRM/ceMqfAIhZa/7YlKPMiXxg4kVTH+tlmxEWddQvU=;
	b=SP2nLkTSTElRtpDVP7sNFkjRvtGdr3fDoFTUHFe5F8fN6uOmJ/nIK/soxMrtUvmyKyAc2s
	WOBi+38minMZ5RzyPv6YpS84KFGqvNKIxZlqF4SOr3j5ZWvb8PNqWOvZhIafxuCu92m7EP
	jgtyIKurFr2vacoeORIr4LLkTiDCDz8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-34-WDnqefvLMl6fwtSM0Q4F9A-1; Tue,
 08 Jul 2025 03:09:41 -0400
X-MC-Unique: WDnqefvLMl6fwtSM0Q4F9A-1
X-Mimecast-MFC-AGG-ID: WDnqefvLMl6fwtSM0Q4F9A_1751958579
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7E05318011F9;
	Tue,  8 Jul 2025 07:09:39 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.44.32.252])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BA77A195608F;
	Tue,  8 Jul 2025 07:09:33 +0000 (UTC)
From: Paolo Abeni <pabeni@redhat.com>
To: netdev@vger.kernel.org
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Yuri Benditovich <yuri.benditovich@daynix.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Jonathan Corbet <corbet@lwn.net>,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [PATCH v7 net-next 3/9] virtio_pci_modern: allow configuring extended features
Date: Tue,  8 Jul 2025 09:08:59 +0200
Message-ID: <85daf7502c9af6e648e0cfeb23d73bf87f4c9de8.1751874094.git.pabeni@redhat.com>
In-Reply-To: <cover.1751874094.git.pabeni@redhat.com>
References: <cover.1751874094.git.pabeni@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

The virtio specifications allows for up to 128 bits for the
device features. Soon we are going to use some of the 'extended'
bits features (above 64) for the virtio_net driver.

Extend the virtio pci modern driver to support configuring the full
virtio features range, replacing the unrolled loops reading and
writing the features space with explicit one bounded to the actual
features space size in word and implementing the get_extended_features
callback.

Note that in vp_finalize_features() we only need to cache the lower
64 features bits, to process the transport features.

Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
v3 -> v4:
  - dropped unneeded check in vp_modern_get_features()

v2 -> v3:
  - virtio_features_t -> u64 *

v1 -> v2:
  - use get_extended_features
---
 drivers/virtio/virtio_pci_modern.c     | 10 ++--
 drivers/virtio/virtio_pci_modern_dev.c | 69 +++++++++++++++-----------
 include/linux/virtio_pci_modern.h      | 43 ++++++++++++++--
 3 files changed, 84 insertions(+), 38 deletions(-)

diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index 7182f43ed055..dd0e65f71d41 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -22,11 +22,11 @@
 
 #define VIRTIO_AVQ_SGS_MAX	4
 
-static u64 vp_get_features(struct virtio_device *vdev)
+static void vp_get_features(struct virtio_device *vdev, u64 *features)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
 
-	return vp_modern_get_features(&vp_dev->mdev);
+	vp_modern_get_extended_features(&vp_dev->mdev, features);
 }
 
 static int vp_avq_index(struct virtio_device *vdev, u16 *index, u16 *num)
@@ -437,7 +437,7 @@ static int vp_finalize_features(struct virtio_device *vdev)
 	if (vp_check_common_size(vdev))
 		return -EINVAL;
 
-	vp_modern_set_features(&vp_dev->mdev, vdev->features);
+	vp_modern_set_extended_features(&vp_dev->mdev, vdev->features_array);
 
 	return 0;
 }
@@ -1234,7 +1234,7 @@ static const struct virtio_config_ops virtio_pci_config_nodev_ops = {
 	.find_vqs	= vp_modern_find_vqs,
 	.del_vqs	= vp_del_vqs,
 	.synchronize_cbs = vp_synchronize_vectors,
-	.get_features	= vp_get_features,
+	.get_extended_features = vp_get_features,
 	.finalize_features = vp_finalize_features,
 	.bus_name	= vp_bus_name,
 	.set_vq_affinity = vp_set_vq_affinity,
@@ -1254,7 +1254,7 @@ static const struct virtio_config_ops virtio_pci_config_ops = {
 	.find_vqs	= vp_modern_find_vqs,
 	.del_vqs	= vp_del_vqs,
 	.synchronize_cbs = vp_synchronize_vectors,
-	.get_features	= vp_get_features,
+	.get_extended_features = vp_get_features,
 	.finalize_features = vp_finalize_features,
 	.bus_name	= vp_bus_name,
 	.set_vq_affinity = vp_set_vq_affinity,
diff --git a/drivers/virtio/virtio_pci_modern_dev.c b/drivers/virtio/virtio_pci_modern_dev.c
index 0d3dbfaf4b23..d665f8f73ea8 100644
--- a/drivers/virtio/virtio_pci_modern_dev.c
+++ b/drivers/virtio/virtio_pci_modern_dev.c
@@ -388,63 +388,74 @@ void vp_modern_remove(struct virtio_pci_modern_device *mdev)
 EXPORT_SYMBOL_GPL(vp_modern_remove);
 
 /*
- * vp_modern_get_features - get features from device
+ * vp_modern_get_extended_features - get features from device
  * @mdev: the modern virtio-pci device
+ * @features: the features array to be filled
  *
- * Returns the features read from the device
+ * Fill the specified features array with the features read from the device
  */
-u64 vp_modern_get_features(struct virtio_pci_modern_device *mdev)
+void vp_modern_get_extended_features(struct virtio_pci_modern_device *mdev,
+				     u64 *features)
 {
 	struct virtio_pci_common_cfg __iomem *cfg = mdev->common;
+	int i;
 
-	u64 features;
+	virtio_features_zero(features);
+	for (i = 0; i < VIRTIO_FEATURES_WORDS; i++) {
+		u64 cur;
 
-	vp_iowrite32(0, &cfg->device_feature_select);
-	features = vp_ioread32(&cfg->device_feature);
-	vp_iowrite32(1, &cfg->device_feature_select);
-	features |= ((u64)vp_ioread32(&cfg->device_feature) << 32);
-
-	return features;
+		vp_iowrite32(i, &cfg->device_feature_select);
+		cur = vp_ioread32(&cfg->device_feature);
+		features[i >> 1] |= cur << (32 * (i & 1));
+	}
 }
-EXPORT_SYMBOL_GPL(vp_modern_get_features);
+EXPORT_SYMBOL_GPL(vp_modern_get_extended_features);
 
 /*
  * vp_modern_get_driver_features - get driver features from device
  * @mdev: the modern virtio-pci device
+ * @features: the features array to be filled
  *
- * Returns the driver features read from the device
+ * Fill the specified features array with the driver features read from the
+ * device
  */
-u64 vp_modern_get_driver_features(struct virtio_pci_modern_device *mdev)
+void
+vp_modern_get_driver_extended_features(struct virtio_pci_modern_device *mdev,
+				       u64 *features)
 {
 	struct virtio_pci_common_cfg __iomem *cfg = mdev->common;
+	int i;
 
-	u64 features;
-
-	vp_iowrite32(0, &cfg->guest_feature_select);
-	features = vp_ioread32(&cfg->guest_feature);
-	vp_iowrite32(1, &cfg->guest_feature_select);
-	features |= ((u64)vp_ioread32(&cfg->guest_feature) << 32);
+	virtio_features_zero(features);
+	for (i = 0; i < VIRTIO_FEATURES_WORDS; i++) {
+		u64 cur;
 
-	return features;
+		vp_iowrite32(i, &cfg->guest_feature_select);
+		cur = vp_ioread32(&cfg->guest_feature);
+		features[i >> 1] |= cur << (32 * (i & 1));
+	}
 }
-EXPORT_SYMBOL_GPL(vp_modern_get_driver_features);
+EXPORT_SYMBOL_GPL(vp_modern_get_driver_extended_features);
 
 /*
- * vp_modern_set_features - set features to device
+ * vp_modern_set_extended_features - set features to device
  * @mdev: the modern virtio-pci device
  * @features: the features set to device
  */
-void vp_modern_set_features(struct virtio_pci_modern_device *mdev,
-			    u64 features)
+void vp_modern_set_extended_features(struct virtio_pci_modern_device *mdev,
+				     const u64 *features)
 {
 	struct virtio_pci_common_cfg __iomem *cfg = mdev->common;
+	int i;
+
+	for (i = 0; i < VIRTIO_FEATURES_WORDS; i++) {
+		u32 cur = features[i >> 1] >> (32 * (i & 1));
 
-	vp_iowrite32(0, &cfg->guest_feature_select);
-	vp_iowrite32((u32)features, &cfg->guest_feature);
-	vp_iowrite32(1, &cfg->guest_feature_select);
-	vp_iowrite32(features >> 32, &cfg->guest_feature);
+		vp_iowrite32(i, &cfg->guest_feature_select);
+		vp_iowrite32(cur, &cfg->guest_feature);
+	}
 }
-EXPORT_SYMBOL_GPL(vp_modern_set_features);
+EXPORT_SYMBOL_GPL(vp_modern_set_extended_features);
 
 /*
  * vp_modern_generation - get the device genreation
diff --git a/include/linux/virtio_pci_modern.h b/include/linux/virtio_pci_modern.h
index c0b1b1ca1163..48bc12d1045b 100644
--- a/include/linux/virtio_pci_modern.h
+++ b/include/linux/virtio_pci_modern.h
@@ -3,6 +3,7 @@
 #define _LINUX_VIRTIO_PCI_MODERN_H
 
 #include <linux/pci.h>
+#include <linux/virtio_config.h>
 #include <linux/virtio_pci.h>
 
 /**
@@ -95,10 +96,44 @@ static inline void vp_iowrite64_twopart(u64 val,
 	vp_iowrite32(val >> 32, hi);
 }
 
-u64 vp_modern_get_features(struct virtio_pci_modern_device *mdev);
-u64 vp_modern_get_driver_features(struct virtio_pci_modern_device *mdev);
-void vp_modern_set_features(struct virtio_pci_modern_device *mdev,
-		     u64 features);
+void
+vp_modern_get_driver_extended_features(struct virtio_pci_modern_device *mdev,
+				       u64 *features);
+void vp_modern_get_extended_features(struct virtio_pci_modern_device *mdev,
+				     u64 *features);
+void vp_modern_set_extended_features(struct virtio_pci_modern_device *mdev,
+				     const u64 *features);
+
+static inline u64
+vp_modern_get_features(struct virtio_pci_modern_device *mdev)
+{
+	u64 features_array[VIRTIO_FEATURES_DWORDS];
+
+	vp_modern_get_extended_features(mdev, features_array);
+	return features_array[0];
+}
+
+static inline u64
+vp_modern_get_driver_features(struct virtio_pci_modern_device *mdev)
+{
+	u64 features_array[VIRTIO_FEATURES_DWORDS];
+	int i;
+
+	vp_modern_get_driver_extended_features(mdev, features_array);
+	for (i = 1; i < VIRTIO_FEATURES_DWORDS; ++i)
+		WARN_ON_ONCE(features_array[i]);
+	return features_array[0];
+}
+
+static inline void
+vp_modern_set_features(struct virtio_pci_modern_device *mdev, u64 features)
+{
+	u64 features_array[VIRTIO_FEATURES_DWORDS];
+
+	virtio_features_from_u64(features_array, features);
+	vp_modern_set_extended_features(mdev, features_array);
+}
+
 u32 vp_modern_generation(struct virtio_pci_modern_device *mdev);
 u8 vp_modern_get_status(struct virtio_pci_modern_device *mdev);
 void vp_modern_set_status(struct virtio_pci_modern_device *mdev,
-- 
2.49.0


