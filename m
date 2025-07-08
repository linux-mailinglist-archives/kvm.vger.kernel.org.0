Return-Path: <kvm+bounces-51734-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A9C5AFC3AF
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 09:10:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E3969189E29E
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 07:10:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59866259CA9;
	Tue,  8 Jul 2025 07:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y+gcnUDr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52512566F7
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 07:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751958593; cv=none; b=rK1poQo1mwxB1O+NOCgQRvwmOxc3oi7Xw9mDopNS0CpjUtc4xTJUqrAQx90wskqXuMuWxS7hy8LNZ2esv8kkSEMgGBXvq1wZPKiAHkUPMhPPzJJHi9HdvaYB5QDBygUw+bxdCZxXeKFMBJp1EcFamGZWYDk6qs0m96YA2ccqC1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751958593; c=relaxed/simple;
	bh=4tQZtc8Mrj4aHAlFWngEwJnrdT/JDpWluKjZ+zwkOCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jgohzts4zMeNTr3OmiUEu82LOIUJ1lsKiXvSGzPvFDIDxHVaGTnAqBqVwH0QYyGxaHp1buotR8cHWINmivDIYBf8qKKmZPQkLfT3/5yOt91Nt0oJ/oQpzqiXq43Sud28KiilTqGADQKgHtusWOn+VZbUxBadhOng7X4lb0HyFao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y+gcnUDr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751958590;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zfpXDGfEZk3AL4T+Cy90ZW6S5BbKJPubJmGaYburefI=;
	b=Y+gcnUDrqK6cubYol1ZS8M0AM5rfjTRBYnYSbNc2//b0b3kCPU37bJ68RyEYdueq0POXZt
	qiJ4jV9SVmfvRrGiQwnqfkiouzdWGcs6J9OCFuP5moFQgTQ6mCU5Gmio/3ASdSF8m8oLUJ
	s7P6pDAp0IVlZaKpuZpkY1a67JAh700=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-641-4QBLoDTrO_qqWQJMXa0pTw-1; Tue,
 08 Jul 2025 03:09:47 -0400
X-MC-Unique: 4QBLoDTrO_qqWQJMXa0pTw-1
X-Mimecast-MFC-AGG-ID: 4QBLoDTrO_qqWQJMXa0pTw_1751958585
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 972F718011FE;
	Tue,  8 Jul 2025 07:09:45 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.44.32.252])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0EB1B195608F;
	Tue,  8 Jul 2025 07:09:39 +0000 (UTC)
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
Subject: [PATCH v7 net-next 4/9] vhost-net: allow configuring extended features
Date: Tue,  8 Jul 2025 09:09:00 +0200
Message-ID: <3f854bf58546e8c4745bdd90e05f8a2d1fb57d2a.1751874094.git.pabeni@redhat.com>
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

Use the extended feature type for 'acked_features' and implement
two new ioctls operation allowing the user-space to set/query an
unbounded amount of features.

The actual number of processed features is limited by VIRTIO_FEATURES_MAX
and attempts to set features above such limit fail with
EOPNOTSUPP.

Note that: the legacy ioctls implicitly truncate the negotiated
features to the lower 64 bits range and the 'acked_backend_features'
field don't need conversion, as the only negotiated feature there
is in the low 64 bit range.

Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
v6 -> v7:
  - revert back to copy_from_user() to avoid a csky arch warning

v5 -> v6:
  - deal with overflows with size_mul()

v4 -> v5:
  - simpler VHOST_GET_FEATURES_ARRAY impl && fix
  - use get_user() when possible

v3 -> v4:
  - use a single static (lower case) constant instead of enum and old def
  - simpler VHOST_GET_FEATURES_ARRAY impl
  - avoid using virtio_features_and_not

v2 -> v3:
  - virtio_features_t -> u64[2]
  - add __counted_by annotation to vhost_features_array

v1 -> v2:
  - change the ioctl to use an extensible API
---
 drivers/vhost/net.c              | 87 ++++++++++++++++++++++++--------
 drivers/vhost/vhost.c            |  2 +-
 drivers/vhost/vhost.h            |  4 +-
 include/uapi/linux/vhost.h       |  7 +++
 include/uapi/linux/vhost_types.h |  5 ++
 5 files changed, 82 insertions(+), 23 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 9dbd88eb9ff4..4aa2930382ad 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -69,12 +69,12 @@ MODULE_PARM_DESC(experimental_zcopytx, "Enable Zero Copy TX;"
 
 #define VHOST_DMA_IS_DONE(len) ((__force u32)(len) >= (__force u32)VHOST_DMA_DONE_LEN)
 
-enum {
-	VHOST_NET_FEATURES = VHOST_FEATURES |
-			 (1ULL << VHOST_NET_F_VIRTIO_NET_HDR) |
-			 (1ULL << VIRTIO_NET_F_MRG_RXBUF) |
-			 (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
-			 (1ULL << VIRTIO_F_RING_RESET)
+static const u64 vhost_net_features[VIRTIO_FEATURES_DWORDS] = {
+	VHOST_FEATURES |
+	(1ULL << VHOST_NET_F_VIRTIO_NET_HDR) |
+	(1ULL << VIRTIO_NET_F_MRG_RXBUF) |
+	(1ULL << VIRTIO_F_ACCESS_PLATFORM) |
+	(1ULL << VIRTIO_F_RING_RESET),
 };
 
 enum {
@@ -1606,16 +1606,17 @@ static long vhost_net_reset_owner(struct vhost_net *n)
 	return err;
 }
 
-static int vhost_net_set_features(struct vhost_net *n, u64 features)
+static int vhost_net_set_features(struct vhost_net *n, const u64 *features)
 {
 	size_t vhost_hlen, sock_hlen, hdr_len;
 	int i;
 
-	hdr_len = (features & ((1ULL << VIRTIO_NET_F_MRG_RXBUF) |
-			       (1ULL << VIRTIO_F_VERSION_1))) ?
-			sizeof(struct virtio_net_hdr_mrg_rxbuf) :
-			sizeof(struct virtio_net_hdr);
-	if (features & (1 << VHOST_NET_F_VIRTIO_NET_HDR)) {
+	hdr_len = virtio_features_test_bit(features, VIRTIO_NET_F_MRG_RXBUF) ||
+		  virtio_features_test_bit(features, VIRTIO_F_VERSION_1) ?
+		  sizeof(struct virtio_net_hdr_mrg_rxbuf) :
+		  sizeof(struct virtio_net_hdr);
+
+	if (virtio_features_test_bit(features, VHOST_NET_F_VIRTIO_NET_HDR)) {
 		/* vhost provides vnet_hdr */
 		vhost_hlen = hdr_len;
 		sock_hlen = 0;
@@ -1625,18 +1626,19 @@ static int vhost_net_set_features(struct vhost_net *n, u64 features)
 		sock_hlen = hdr_len;
 	}
 	mutex_lock(&n->dev.mutex);
-	if ((features & (1 << VHOST_F_LOG_ALL)) &&
+	if (virtio_features_test_bit(features, VHOST_F_LOG_ALL) &&
 	    !vhost_log_access_ok(&n->dev))
 		goto out_unlock;
 
-	if ((features & (1ULL << VIRTIO_F_ACCESS_PLATFORM))) {
+	if (virtio_features_test_bit(features, VIRTIO_F_ACCESS_PLATFORM)) {
 		if (vhost_init_device_iotlb(&n->dev))
 			goto out_unlock;
 	}
 
 	for (i = 0; i < VHOST_NET_VQ_MAX; ++i) {
 		mutex_lock(&n->vqs[i].vq.mutex);
-		n->vqs[i].vq.acked_features = features;
+		virtio_features_copy(n->vqs[i].vq.acked_features_array,
+				     features);
 		n->vqs[i].vhost_hlen = vhost_hlen;
 		n->vqs[i].sock_hlen = sock_hlen;
 		mutex_unlock(&n->vqs[i].vq.mutex);
@@ -1673,12 +1675,13 @@ static long vhost_net_set_owner(struct vhost_net *n)
 static long vhost_net_ioctl(struct file *f, unsigned int ioctl,
 			    unsigned long arg)
 {
+	u64 all_features[VIRTIO_FEATURES_DWORDS];
 	struct vhost_net *n = f->private_data;
 	void __user *argp = (void __user *)arg;
 	u64 __user *featurep = argp;
 	struct vhost_vring_file backend;
-	u64 features;
-	int r;
+	u64 features, count, copied;
+	int r, i;
 
 	switch (ioctl) {
 	case VHOST_NET_SET_BACKEND:
@@ -1686,16 +1689,60 @@ static long vhost_net_ioctl(struct file *f, unsigned int ioctl,
 			return -EFAULT;
 		return vhost_net_set_backend(n, backend.index, backend.fd);
 	case VHOST_GET_FEATURES:
-		features = VHOST_NET_FEATURES;
+		features = vhost_net_features[0];
 		if (copy_to_user(featurep, &features, sizeof features))
 			return -EFAULT;
 		return 0;
 	case VHOST_SET_FEATURES:
 		if (copy_from_user(&features, featurep, sizeof features))
 			return -EFAULT;
-		if (features & ~VHOST_NET_FEATURES)
+		if (features & ~vhost_net_features[0])
 			return -EOPNOTSUPP;
-		return vhost_net_set_features(n, features);
+
+		virtio_features_from_u64(all_features, features);
+		return vhost_net_set_features(n, all_features);
+	case VHOST_GET_FEATURES_ARRAY:
+		if (copy_from_user(&count, featurep, sizeof(count)))
+			return -EFAULT;
+
+		/* Copy the net features, up to the user-provided buffer size */
+		argp += sizeof(u64);
+		copied = min(count, VIRTIO_FEATURES_DWORDS);
+		if (copy_to_user(argp, vhost_net_features,
+				 copied * sizeof(u64)))
+			return -EFAULT;
+
+		/* Zero the trailing space provided by user-space, if any */
+		if (clear_user(argp, size_mul(count - copied, sizeof(u64))))
+			return -EFAULT;
+		return 0;
+	case VHOST_SET_FEATURES_ARRAY:
+		if (copy_from_user(&count, featurep, sizeof(count)))
+			return -EFAULT;
+
+		virtio_features_zero(all_features);
+		argp += sizeof(u64);
+		copied = min(count, VIRTIO_FEATURES_DWORDS);
+		if (copy_from_user(all_features, argp, copied * sizeof(u64)))
+			return -EFAULT;
+
+		/*
+		 * Any feature specified by user-space above
+		 * VIRTIO_FEATURES_MAX is not supported by definition.
+		 */
+		for (i = copied; i < count; ++i) {
+			if (copy_from_user(&features, featurep + 1 + i,
+					   sizeof(features)))
+				return -EFAULT;
+			if (features)
+				return -EOPNOTSUPP;
+		}
+
+		for (i = 0; i < VIRTIO_FEATURES_DWORDS; i++)
+			if (all_features[i] & ~vhost_net_features[i])
+				return -EOPNOTSUPP;
+
+		return vhost_net_set_features(n, all_features);
 	case VHOST_GET_BACKEND_FEATURES:
 		features = VHOST_NET_BACKEND_FEATURES;
 		if (copy_to_user(featurep, &features, sizeof(features)))
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 3a5ebb973dba..1094256a943c 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -372,7 +372,7 @@ static void vhost_vq_reset(struct vhost_dev *dev,
 	vq->log_used = false;
 	vq->log_addr = -1ull;
 	vq->private_data = NULL;
-	vq->acked_features = 0;
+	virtio_features_zero(vq->acked_features_array);
 	vq->acked_backend_features = 0;
 	vq->log_base = NULL;
 	vq->error_ctx = NULL;
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index bb75a292d50c..d1aed35c4b07 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -133,7 +133,7 @@ struct vhost_virtqueue {
 	struct vhost_iotlb *umem;
 	struct vhost_iotlb *iotlb;
 	void *private_data;
-	u64 acked_features;
+	VIRTIO_DECLARE_FEATURES(acked_features);
 	u64 acked_backend_features;
 	/* Log write descriptors */
 	void __user *log_base;
@@ -291,7 +291,7 @@ static inline void *vhost_vq_get_backend(struct vhost_virtqueue *vq)
 
 static inline bool vhost_has_feature(struct vhost_virtqueue *vq, int bit)
 {
-	return vq->acked_features & (1ULL << bit);
+	return virtio_features_test_bit(vq->acked_features_array, bit);
 }
 
 static inline bool vhost_backend_has_feature(struct vhost_virtqueue *vq, int bit)
diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index d4b3e2ae1314..d6ad01fbb8d2 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -235,4 +235,11 @@
  */
 #define VHOST_VDPA_GET_VRING_SIZE	_IOWR(VHOST_VIRTIO, 0x82,	\
 					      struct vhost_vring_state)
+
+/* Extended features manipulation */
+#define VHOST_GET_FEATURES_ARRAY _IOR(VHOST_VIRTIO, 0x83, \
+				       struct vhost_features_array)
+#define VHOST_SET_FEATURES_ARRAY _IOW(VHOST_VIRTIO, 0x83, \
+				       struct vhost_features_array)
+
 #endif
diff --git a/include/uapi/linux/vhost_types.h b/include/uapi/linux/vhost_types.h
index d7656908f730..1c39cc5f5a31 100644
--- a/include/uapi/linux/vhost_types.h
+++ b/include/uapi/linux/vhost_types.h
@@ -110,6 +110,11 @@ struct vhost_msg_v2 {
 	};
 };
 
+struct vhost_features_array {
+	__u64 count; /* number of entries present in features array */
+	__u64 features[] __counted_by(count);
+};
+
 struct vhost_memory_region {
 	__u64 guest_phys_addr;
 	__u64 memory_size; /* bytes */
-- 
2.49.0


