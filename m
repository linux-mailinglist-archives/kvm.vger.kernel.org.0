Return-Path: <kvm+bounces-50135-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A860AE2120
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 19:41:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 30F0216EEE5
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 17:41:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6282E2E172A;
	Fri, 20 Jun 2025 17:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="If1qlrjM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4951D2E8E1E
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 17:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750441243; cv=none; b=tH0QIN9cR2ieTHJEvPDvVeG1AVODir/C3UEbKYkn00CG86dYnMJzJdzkXxy/64WwkqxL6YxM9DAWxJvtWlVqoHEEslDDtlioOnxg42TM9YcXEf70hvSzLAn0aMAWDFwwMUHx82Dk0L4aoCIo68S9wcVcN+XUR/224jU7HaIUQa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750441243; c=relaxed/simple;
	bh=gEUfdJoTiA5Inux9sOwicIzDitBz+Z2BbGCZqo1P4sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dn0phhfAYkjoJMXTLdjm0PwGvwwOJZy87jNiPV6ZeB5EyjowP40nVFwo9vC6tSO9LV84emKXB2bI3u5Vre732eO2iBuzxWgBUHdtRuyc/GRMscHCQlRpYUN1IGC3LHc6ysgOcZwpXKDr7dwly5I/8oBsUyHmg9bgFnYPB5cQZYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=If1qlrjM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750441240;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kWDwDNhRV2BjaqYJ9qNzAQtnKMX/abnzhv3in92MW84=;
	b=If1qlrjMWSz+OZpCVR2ZQM9+RC08p9SWtfy3kTKfjRJiQUf9I2YkvcBr8n3dLW06wNy++F
	3oMpvBqPVQzuIziq5po4vJkj4qrdrhRV2IYDaWx6Qrb5aJx9hnOQUW0fpR9z1a2IFhVOev
	GTze2Cp3w6TPF57kwEEhp5iW6XWEGOo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-616-k4nDHaaOPV-ISyp1ol9CFw-1; Fri,
 20 Jun 2025 13:40:35 -0400
X-MC-Unique: k4nDHaaOPV-ISyp1ol9CFw-1
X-Mimecast-MFC-AGG-ID: k4nDHaaOPV-ISyp1ol9CFw_1750441233
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 697E118002E4;
	Fri, 20 Jun 2025 17:40:33 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.45.224.100])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2486819560AB;
	Fri, 20 Jun 2025 17:40:27 +0000 (UTC)
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
	kvm@vger.kernel.org
Subject: [PATCH v5 net-next 2/9] virtio: introduce extended features
Date: Fri, 20 Jun 2025 19:39:46 +0200
Message-ID: <49710e86c027d7832363e42a36b4b865aaf907ef.1750436464.git.pabeni@redhat.com>
In-Reply-To: <cover.1750436464.git.pabeni@redhat.com>
References: <cover.1750436464.git.pabeni@redhat.com>
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

Introduce extended features as a fixed size array of u64. To minimize
the diffstat allows legacy driver to access the low 64 bits via a
transparent union.

Introduce an extended get_extended_features configuration callback
that devices supporting the extended features range must implement in
place of the traditional one.

Note that legacy and transport features don't need any change, as
they are always in the low 64 bit range.

Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
v4 -> v5:
  - add kdoc for features_array
  - avoid line longer than 80 chars

v3 -> v4:
  - moved bit sanity check in virtio_features_*
  - replaced BUG_ON with WARN_ON_ONCE
  - *_and_not -> _andnot
  - short circuit features comparison

v2 -> v3:
  - uint128_t -> u64[2];

v1 -> v2:
  - let u64 VIRTIO_BIT() cope with higher bit values
  - add .get_features128 instead of changing .get_features signature
---
 drivers/virtio/virtio.c         | 43 +++++++++-------
 drivers/virtio/virtio_debug.c   | 27 +++++-----
 include/linux/virtio.h          |  9 ++--
 include/linux/virtio_config.h   | 43 ++++++++--------
 include/linux/virtio_features.h | 88 +++++++++++++++++++++++++++++++++
 5 files changed, 156 insertions(+), 54 deletions(-)
 create mode 100644 include/linux/virtio_features.h

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index 95d5d7993e5b..5c48788cdbec 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -53,7 +53,7 @@ static ssize_t features_show(struct device *_d,
 
 	/* We actually represent this as a bitstring, as it could be
 	 * arbitrary length in future. */
-	for (i = 0; i < sizeof(dev->features)*8; i++)
+	for (i = 0; i < VIRTIO_FEATURES_MAX; i++)
 		len += sysfs_emit_at(buf, len, "%c",
 			       __virtio_test_bit(dev, i) ? '1' : '0');
 	len += sysfs_emit_at(buf, len, "\n");
@@ -272,22 +272,22 @@ static int virtio_dev_probe(struct device *_d)
 	int err, i;
 	struct virtio_device *dev = dev_to_virtio(_d);
 	struct virtio_driver *drv = drv_to_virtio(dev->dev.driver);
-	u64 device_features;
-	u64 driver_features;
+	u64 device_features[VIRTIO_FEATURES_DWORDS];
+	u64 driver_features[VIRTIO_FEATURES_DWORDS];
 	u64 driver_features_legacy;
 
 	/* We have a driver! */
 	virtio_add_status(dev, VIRTIO_CONFIG_S_DRIVER);
 
 	/* Figure out what features the device supports. */
-	device_features = dev->config->get_features(dev);
+	virtio_get_features(dev, device_features);
 
 	/* Figure out what features the driver supports. */
-	driver_features = 0;
+	virtio_features_zero(driver_features);
 	for (i = 0; i < drv->feature_table_size; i++) {
 		unsigned int f = drv->feature_table[i];
-		BUG_ON(f >= 64);
-		driver_features |= (1ULL << f);
+		if (!WARN_ON_ONCE(f >= VIRTIO_FEATURES_MAX))
+			virtio_features_set_bit(driver_features, f);
 	}
 
 	/* Some drivers have a separate feature table for virtio v1.0 */
@@ -295,24 +295,29 @@ static int virtio_dev_probe(struct device *_d)
 		driver_features_legacy = 0;
 		for (i = 0; i < drv->feature_table_size_legacy; i++) {
 			unsigned int f = drv->feature_table_legacy[i];
-			BUG_ON(f >= 64);
-			driver_features_legacy |= (1ULL << f);
+			if (!WARN_ON_ONCE(f >= 64))
+				driver_features_legacy |= (1ULL << f);
 		}
 	} else {
-		driver_features_legacy = driver_features;
+		driver_features_legacy = driver_features[0];
 	}
 
-	if (device_features & (1ULL << VIRTIO_F_VERSION_1))
-		dev->features = driver_features & device_features;
-	else
-		dev->features = driver_features_legacy & device_features;
+	if (virtio_features_test_bit(device_features, VIRTIO_F_VERSION_1)) {
+		for (i = 0; i < VIRTIO_FEATURES_DWORDS; ++i)
+			dev->features_array[i] = driver_features[i] &
+						 device_features[i];
+	} else {
+		virtio_features_from_u64(dev->features_array,
+					 driver_features_legacy &
+					 device_features[0]);
+	}
 
 	/* When debugging, user may filter some features by hand. */
 	virtio_debug_device_filter_features(dev);
 
 	/* Transport features always preserved to pass to finalize_features. */
 	for (i = VIRTIO_TRANSPORT_F_START; i < VIRTIO_TRANSPORT_F_END; i++)
-		if (device_features & (1ULL << i))
+		if (virtio_features_test_bit(device_features, i))
 			__virtio_set_bit(dev, i);
 
 	err = dev->config->finalize_features(dev);
@@ -320,14 +325,15 @@ static int virtio_dev_probe(struct device *_d)
 		goto err;
 
 	if (drv->validate) {
-		u64 features = dev->features;
+		u64 features[VIRTIO_FEATURES_DWORDS];
 
+		virtio_features_copy(features, dev->features_array);
 		err = drv->validate(dev);
 		if (err)
 			goto err;
 
 		/* Did validation change any features? Then write them again. */
-		if (features != dev->features) {
+		if (!virtio_features_equal(features, dev->features_array)) {
 			err = dev->config->finalize_features(dev);
 			if (err)
 				goto err;
@@ -701,6 +707,9 @@ EXPORT_SYMBOL_GPL(virtio_device_reset_done);
 
 static int virtio_init(void)
 {
+	BUILD_BUG_ON(offsetof(struct virtio_device, features) !=
+		     offsetof(struct virtio_device, features_array[0]));
+
 	if (bus_register(&virtio_bus) != 0)
 		panic("virtio bus registration failed");
 	virtio_debug_init();
diff --git a/drivers/virtio/virtio_debug.c b/drivers/virtio/virtio_debug.c
index 95c8fc7705bb..d58713ddf2e5 100644
--- a/drivers/virtio/virtio_debug.c
+++ b/drivers/virtio/virtio_debug.c
@@ -8,13 +8,13 @@ static struct dentry *virtio_debugfs_dir;
 
 static int virtio_debug_device_features_show(struct seq_file *s, void *data)
 {
+	u64 device_features[VIRTIO_FEATURES_DWORDS];
 	struct virtio_device *dev = s->private;
-	u64 device_features;
 	unsigned int i;
 
-	device_features = dev->config->get_features(dev);
-	for (i = 0; i < BITS_PER_LONG_LONG; i++) {
-		if (device_features & (1ULL << i))
+	virtio_get_features(dev, device_features);
+	for (i = 0; i < VIRTIO_FEATURES_MAX; i++) {
+		if (virtio_features_test_bit(device_features, i))
 			seq_printf(s, "%u\n", i);
 	}
 	return 0;
@@ -26,8 +26,8 @@ static int virtio_debug_filter_features_show(struct seq_file *s, void *data)
 	struct virtio_device *dev = s->private;
 	unsigned int i;
 
-	for (i = 0; i < BITS_PER_LONG_LONG; i++) {
-		if (dev->debugfs_filter_features & (1ULL << i))
+	for (i = 0; i < VIRTIO_FEATURES_MAX; i++) {
+		if (virtio_features_test_bit(dev->debugfs_filter_features, i))
 			seq_printf(s, "%u\n", i);
 	}
 	return 0;
@@ -39,7 +39,7 @@ static int virtio_debug_filter_features_clear(void *data, u64 val)
 	struct virtio_device *dev = data;
 
 	if (val == 1)
-		dev->debugfs_filter_features = 0;
+		virtio_features_zero(dev->debugfs_filter_features);
 	return 0;
 }
 
@@ -50,9 +50,10 @@ static int virtio_debug_filter_feature_add(void *data, u64 val)
 {
 	struct virtio_device *dev = data;
 
-	if (val >= BITS_PER_LONG_LONG)
+	if (val >= VIRTIO_FEATURES_MAX)
 		return -EINVAL;
-	dev->debugfs_filter_features |= BIT_ULL_MASK(val);
+
+	virtio_features_set_bit(dev->debugfs_filter_features, val);
 	return 0;
 }
 
@@ -63,9 +64,10 @@ static int virtio_debug_filter_feature_del(void *data, u64 val)
 {
 	struct virtio_device *dev = data;
 
-	if (val >= BITS_PER_LONG_LONG)
+	if (val >= VIRTIO_FEATURES_MAX)
 		return -EINVAL;
-	dev->debugfs_filter_features &= ~BIT_ULL_MASK(val);
+
+	virtio_features_clear_bit(dev->debugfs_filter_features, val);
 	return 0;
 }
 
@@ -91,7 +93,8 @@ EXPORT_SYMBOL_GPL(virtio_debug_device_init);
 
 void virtio_debug_device_filter_features(struct virtio_device *dev)
 {
-	dev->features &= ~dev->debugfs_filter_features;
+	virtio_features_andnot(dev->features_array, dev->features_array,
+			       dev->debugfs_filter_features);
 }
 EXPORT_SYMBOL_GPL(virtio_debug_device_filter_features);
 
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 64cb4b04be7a..04b90c88d164 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -11,6 +11,7 @@
 #include <linux/gfp.h>
 #include <linux/dma-mapping.h>
 #include <linux/completion.h>
+#include <linux/virtio_features.h>
 
 /**
  * struct virtqueue - a queue to register buffers for sending or receiving.
@@ -141,7 +142,9 @@ struct virtio_admin_cmd {
  * @config: the configuration ops for this device.
  * @vringh_config: configuration ops for host vrings.
  * @vqs: the list of virtqueues for this device.
- * @features: the features supported by both driver and device.
+ * @features: the 64 lower features supported by both driver and device.
+ * @features_array: the full features space supported by both driver and
+ *		    device.
  * @priv: private pointer for the driver's use.
  * @debugfs_dir: debugfs directory entry.
  * @debugfs_filter_features: features to be filtered set by debugfs.
@@ -159,11 +162,11 @@ struct virtio_device {
 	const struct virtio_config_ops *config;
 	const struct vringh_config_ops *vringh_config;
 	struct list_head vqs;
-	u64 features;
+	VIRTIO_DECLARE_FEATURES(features);
 	void *priv;
 #ifdef CONFIG_VIRTIO_DEBUG
 	struct dentry *debugfs_dir;
-	u64 debugfs_filter_features;
+	u64 debugfs_filter_features[VIRTIO_FEATURES_DWORDS];
 #endif
 };
 
diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index b3e1d30c765b..918cf25cd3c6 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -77,7 +77,11 @@ struct virtqueue_info {
  *      vdev: the virtio_device
  * @get_features: get the array of feature bits for this device.
  *	vdev: the virtio_device
- *	Returns the first 64 feature bits (all we currently need).
+ *	Returns the first 64 feature bits.
+ * @get_extended_features:
+ *      vdev: the virtio_device
+ *      Returns the first VIRTIO_FEATURES_MAX feature bits (all we currently
+ *      need).
  * @finalize_features: confirm what device features we'll be using.
  *	vdev: the virtio_device
  *	This sends the driver feature bits to the device: it can change
@@ -121,6 +125,8 @@ struct virtio_config_ops {
 	void (*del_vqs)(struct virtio_device *);
 	void (*synchronize_cbs)(struct virtio_device *);
 	u64 (*get_features)(struct virtio_device *vdev);
+	void (*get_extended_features)(struct virtio_device *vdev,
+				      u64 *features);
 	int (*finalize_features)(struct virtio_device *vdev);
 	const char *(*bus_name)(struct virtio_device *vdev);
 	int (*set_vq_affinity)(struct virtqueue *vq,
@@ -147,13 +153,7 @@ void virtio_check_driver_offered_feature(const struct virtio_device *vdev,
 static inline bool __virtio_test_bit(const struct virtio_device *vdev,
 				     unsigned int fbit)
 {
-	/* Did you forget to fix assumptions on max features? */
-	if (__builtin_constant_p(fbit))
-		BUILD_BUG_ON(fbit >= 64);
-	else
-		BUG_ON(fbit >= 64);
-
-	return vdev->features & BIT_ULL(fbit);
+	return virtio_features_test_bit(vdev->features_array, fbit);
 }
 
 /**
@@ -164,13 +164,7 @@ static inline bool __virtio_test_bit(const struct virtio_device *vdev,
 static inline void __virtio_set_bit(struct virtio_device *vdev,
 				    unsigned int fbit)
 {
-	/* Did you forget to fix assumptions on max features? */
-	if (__builtin_constant_p(fbit))
-		BUILD_BUG_ON(fbit >= 64);
-	else
-		BUG_ON(fbit >= 64);
-
-	vdev->features |= BIT_ULL(fbit);
+	virtio_features_set_bit(vdev->features_array, fbit);
 }
 
 /**
@@ -181,13 +175,7 @@ static inline void __virtio_set_bit(struct virtio_device *vdev,
 static inline void __virtio_clear_bit(struct virtio_device *vdev,
 				      unsigned int fbit)
 {
-	/* Did you forget to fix assumptions on max features? */
-	if (__builtin_constant_p(fbit))
-		BUILD_BUG_ON(fbit >= 64);
-	else
-		BUG_ON(fbit >= 64);
-
-	vdev->features &= ~BIT_ULL(fbit);
+	virtio_features_clear_bit(vdev->features_array, fbit);
 }
 
 /**
@@ -204,6 +192,17 @@ static inline bool virtio_has_feature(const struct virtio_device *vdev,
 	return __virtio_test_bit(vdev, fbit);
 }
 
+static inline void virtio_get_features(struct virtio_device *vdev,
+				       u64 *features)
+{
+	if (vdev->config->get_extended_features) {
+		vdev->config->get_extended_features(vdev, features);
+		return;
+	}
+
+	virtio_features_from_u64(features, vdev->config->get_features(vdev));
+}
+
 /**
  * virtio_has_dma_quirk - determine whether this device has the DMA quirk
  * @vdev: the device
diff --git a/include/linux/virtio_features.h b/include/linux/virtio_features.h
new file mode 100644
index 000000000000..f748f2f87de8
--- /dev/null
+++ b/include/linux/virtio_features.h
@@ -0,0 +1,88 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_VIRTIO_FEATURES_H
+#define _LINUX_VIRTIO_FEATURES_H
+
+#include <linux/bits.h>
+
+#define VIRTIO_FEATURES_DWORDS	2
+#define VIRTIO_FEATURES_MAX	(VIRTIO_FEATURES_DWORDS * 64)
+#define VIRTIO_FEATURES_WORDS	(VIRTIO_FEATURES_DWORDS * 2)
+#define VIRTIO_BIT(b)		BIT_ULL((b) & 0x3f)
+#define VIRTIO_DWORD(b)		((b) >> 6)
+#define VIRTIO_DECLARE_FEATURES(name)			\
+	union {						\
+		u64 name;				\
+		u64 name##_array[VIRTIO_FEATURES_DWORDS];\
+	}
+
+static inline bool virtio_features_chk_bit(unsigned int bit)
+{
+	if (__builtin_constant_p(bit)) {
+		/*
+		 * Don't care returning the correct value: the build
+		 * will fail before any bad features access
+		 */
+		BUILD_BUG_ON(bit >= VIRTIO_FEATURES_MAX);
+	} else {
+		if (WARN_ON_ONCE(bit >= VIRTIO_FEATURES_MAX))
+			return false;
+	}
+	return true;
+}
+
+static inline bool virtio_features_test_bit(const u64 *features,
+					    unsigned int bit)
+{
+	return virtio_features_chk_bit(bit) &&
+	       !!(features[VIRTIO_DWORD(bit)] & VIRTIO_BIT(bit));
+}
+
+static inline void virtio_features_set_bit(u64 *features,
+					   unsigned int bit)
+{
+	if (virtio_features_chk_bit(bit))
+		features[VIRTIO_DWORD(bit)] |= VIRTIO_BIT(bit);
+}
+
+static inline void virtio_features_clear_bit(u64 *features,
+					     unsigned int bit)
+{
+	if (virtio_features_chk_bit(bit))
+		features[VIRTIO_DWORD(bit)] &= ~VIRTIO_BIT(bit);
+}
+
+static inline void virtio_features_zero(u64 *features)
+{
+	memset(features, 0, sizeof(features[0]) * VIRTIO_FEATURES_DWORDS);
+}
+
+static inline void virtio_features_from_u64(u64 *features, u64 from)
+{
+	virtio_features_zero(features);
+	features[0] = from;
+}
+
+static inline bool virtio_features_equal(const u64 *f1, const u64 *f2)
+{
+	int i;
+
+	for (i = 0; i < VIRTIO_FEATURES_DWORDS; ++i)
+		if (f1[i] != f2[i])
+			return false;
+	return true;
+}
+
+static inline void virtio_features_copy(u64 *to, const u64 *from)
+{
+	memcpy(to, from, sizeof(to[0]) * VIRTIO_FEATURES_DWORDS);
+}
+
+static inline void virtio_features_andnot(u64 *to, const u64 *f1, const u64 *f2)
+{
+	int i;
+
+	for (i = 0; i < VIRTIO_FEATURES_DWORDS; i++)
+		to[i] = f1[i] & ~f2[i];
+}
+
+#endif
-- 
2.49.0


