Return-Path: <kvm+bounces-52278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 975B3B039D4
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 10:49:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F2B5D3BC160
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 08:48:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7930823F43C;
	Mon, 14 Jul 2025 08:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RvqlLGs5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4D823C4EA
	for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 08:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752482900; cv=none; b=mCUmu7j4Hzr844CJA8cfBaCfWDFlwZIynoA6Di7YTKUbVfubUfWvJaQg70f4jcn4eWO8P+t8CTiZsuKD479VkAQpSiovTihpjKFiFQwv6Sd8v3QftHVmQegWlQMJCVkJ+265aFvIq+WVTCeuf4uydTXk58q7JrcMxN+Haabw0So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752482900; c=relaxed/simple;
	bh=bwdfDoRxyHGVVjKGPu7wOFQTDY9zubbN3MwG3Z5sGHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TU5NiJ4px1j+lxEX/+QNOt9f3Zl9K9ix5xRraciigV3Z6za3uX5djHk9zCEATbAl2uOmfQOeIXQfECCsYNaEZ3/S+7gei4DiI/aaGuRCJ6UhLJX3+ASBt9Vpn7xixwQE43c2F1kEJlpk7bYJ9FA4roWsinsk6FauZnNmiFeoikg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RvqlLGs5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752482897;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FzHRPDotMJHlnxA29tvLG0UVmrddComarSQgy5WlSJA=;
	b=RvqlLGs5rKlARf3CDvq3uGtY5X2y24cfIYceqLjDyOmQ/irMI2lUb/JOEXMk7bBoe1oVok
	XjiCwk60asen5oj3rKLImaYcU0t40y6JJdglmRNChSbfU7WsnPF38c1ko3CLS4Cmt+TmKU
	ZWyDAaN+4kbcVhgesgPoe2ud63z+LUE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-686-KueP441INkmPmRu3Vv850A-1; Mon,
 14 Jul 2025 04:48:16 -0400
X-MC-Unique: KueP441INkmPmRu3Vv850A-1
X-Mimecast-MFC-AGG-ID: KueP441INkmPmRu3Vv850A_1752482895
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F0D6F19560B2;
	Mon, 14 Jul 2025 08:48:14 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.112.55])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1A27F1803AF2;
	Mon, 14 Jul 2025 08:48:10 +0000 (UTC)
From: Jason Wang <jasowang@redhat.com>
To: mst@redhat.com,
	jasowang@redhat.com,
	eperezma@redhat.com
Cc: kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jonah.palmer@oracle.com
Subject: [PATCH net-next V2 2/3] vhost: basic in order support
Date: Mon, 14 Jul 2025 16:47:54 +0800
Message-ID: <20250714084755.11921-3-jasowang@redhat.com>
In-Reply-To: <20250714084755.11921-1-jasowang@redhat.com>
References: <20250714084755.11921-1-jasowang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

This patch adds basic in order support for vhost. Two optimizations
are implemented in this patch:

1) Since driver uses descriptor in order, vhost can deduce the next
   avail ring head by counting the number of descriptors that has been
   used in next_avail_head. This eliminate the need to access the
   available ring in vhost.

2) vhost_add_used_and_singal_n() is extended to accept the number of
   batched buffers per used elem. While this increases the times of
   userspace memory access but it helps to reduce the chance of
   used ring access of both the driver and vhost.

Vhost-net will be the first user for this.

Acked-by: Jonah Palmer <jonah.palmer@oracle.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/net.c   |   6 ++-
 drivers/vhost/vhost.c | 120 ++++++++++++++++++++++++++++++++++--------
 drivers/vhost/vhost.h |   8 ++-
 3 files changed, 109 insertions(+), 25 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 9dbd88eb9ff4..2199ba3b191e 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -374,7 +374,8 @@ static void vhost_zerocopy_signal_used(struct vhost_net *net,
 	while (j) {
 		add = min(UIO_MAXIOV - nvq->done_idx, j);
 		vhost_add_used_and_signal_n(vq->dev, vq,
-					    &vq->heads[nvq->done_idx], add);
+					    &vq->heads[nvq->done_idx],
+					    NULL, add);
 		nvq->done_idx = (nvq->done_idx + add) % UIO_MAXIOV;
 		j -= add;
 	}
@@ -457,7 +458,8 @@ static void vhost_net_signal_used(struct vhost_net_virtqueue *nvq)
 	if (!nvq->done_idx)
 		return;
 
-	vhost_add_used_and_signal_n(dev, vq, vq->heads, nvq->done_idx);
+	vhost_add_used_and_signal_n(dev, vq, vq->heads, NULL,
+				    nvq->done_idx);
 	nvq->done_idx = 0;
 }
 
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index d1d3912f4804..dd7963eb6cf0 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -364,6 +364,7 @@ static void vhost_vq_reset(struct vhost_dev *dev,
 	vq->avail = NULL;
 	vq->used = NULL;
 	vq->last_avail_idx = 0;
+	vq->next_avail_head = 0;
 	vq->avail_idx = 0;
 	vq->last_used_idx = 0;
 	vq->signalled_used = 0;
@@ -455,6 +456,8 @@ static void vhost_vq_free_iovecs(struct vhost_virtqueue *vq)
 	vq->log = NULL;
 	kfree(vq->heads);
 	vq->heads = NULL;
+	kfree(vq->nheads);
+	vq->nheads = NULL;
 }
 
 /* Helper to allocate iovec buffers for all vqs. */
@@ -472,7 +475,9 @@ static long vhost_dev_alloc_iovecs(struct vhost_dev *dev)
 					GFP_KERNEL);
 		vq->heads = kmalloc_array(dev->iov_limit, sizeof(*vq->heads),
 					  GFP_KERNEL);
-		if (!vq->indirect || !vq->log || !vq->heads)
+		vq->nheads = kmalloc_array(dev->iov_limit, sizeof(*vq->nheads),
+					   GFP_KERNEL);
+		if (!vq->indirect || !vq->log || !vq->heads || !vq->nheads)
 			goto err_nomem;
 	}
 	return 0;
@@ -1990,14 +1995,15 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
 			break;
 		}
 		if (vhost_has_feature(vq, VIRTIO_F_RING_PACKED)) {
-			vq->last_avail_idx = s.num & 0xffff;
+			vq->next_avail_head = vq->last_avail_idx =
+					      s.num & 0xffff;
 			vq->last_used_idx = (s.num >> 16) & 0xffff;
 		} else {
 			if (s.num > 0xffff) {
 				r = -EINVAL;
 				break;
 			}
-			vq->last_avail_idx = s.num;
+			vq->next_avail_head = vq->last_avail_idx = s.num;
 		}
 		/* Forget the cached index value. */
 		vq->avail_idx = vq->last_avail_idx;
@@ -2590,11 +2596,12 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 		      unsigned int *out_num, unsigned int *in_num,
 		      struct vhost_log *log, unsigned int *log_num)
 {
+	bool in_order = vhost_has_feature(vq, VIRTIO_F_IN_ORDER);
 	struct vring_desc desc;
 	unsigned int i, head, found = 0;
 	u16 last_avail_idx = vq->last_avail_idx;
 	__virtio16 ring_head;
-	int ret, access;
+	int ret, access, c = 0;
 
 	if (vq->avail_idx == vq->last_avail_idx) {
 		ret = vhost_get_avail_idx(vq);
@@ -2605,17 +2612,21 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 			return vq->num;
 	}
 
-	/* Grab the next descriptor number they're advertising, and increment
-	 * the index we've seen. */
-	if (unlikely(vhost_get_avail_head(vq, &ring_head, last_avail_idx))) {
-		vq_err(vq, "Failed to read head: idx %d address %p\n",
-		       last_avail_idx,
-		       &vq->avail->ring[last_avail_idx % vq->num]);
-		return -EFAULT;
+	if (in_order)
+		head = vq->next_avail_head & (vq->num - 1);
+	else {
+		/* Grab the next descriptor number they're
+		 * advertising, and increment the index we've seen. */
+		if (unlikely(vhost_get_avail_head(vq, &ring_head,
+						  last_avail_idx))) {
+			vq_err(vq, "Failed to read head: idx %d address %p\n",
+				last_avail_idx,
+				&vq->avail->ring[last_avail_idx % vq->num]);
+			return -EFAULT;
+		}
+		head = vhost16_to_cpu(vq, ring_head);
 	}
 
-	head = vhost16_to_cpu(vq, ring_head);
-
 	/* If their number is silly, that's an error. */
 	if (unlikely(head >= vq->num)) {
 		vq_err(vq, "Guest says index %u > %u is available",
@@ -2658,6 +2669,7 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 						"in indirect descriptor at idx %d\n", i);
 				return ret;
 			}
+			++c;
 			continue;
 		}
 
@@ -2693,10 +2705,12 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 			}
 			*out_num += ret;
 		}
+		++c;
 	} while ((i = next_desc(vq, &desc)) != -1);
 
 	/* On success, increment avail index. */
 	vq->last_avail_idx++;
+	vq->next_avail_head += c;
 
 	/* Assume notifications from guest are disabled at this point,
 	 * if they aren't we would need to update avail_event index. */
@@ -2720,8 +2734,9 @@ int vhost_add_used(struct vhost_virtqueue *vq, unsigned int head, int len)
 		cpu_to_vhost32(vq, head),
 		cpu_to_vhost32(vq, len)
 	};
+	u16 nheads = 1;
 
-	return vhost_add_used_n(vq, &heads, 1);
+	return vhost_add_used_n(vq, &heads, &nheads, 1);
 }
 EXPORT_SYMBOL_GPL(vhost_add_used);
 
@@ -2757,10 +2772,9 @@ static int __vhost_add_used_n(struct vhost_virtqueue *vq,
 	return 0;
 }
 
-/* After we've used one of their buffers, we tell them about it.  We'll then
- * want to notify the guest, using eventfd. */
-int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem *heads,
-		     unsigned count)
+static int vhost_add_used_n_ooo(struct vhost_virtqueue *vq,
+				struct vring_used_elem *heads,
+				unsigned count)
 {
 	int start, n, r;
 
@@ -2773,7 +2787,69 @@ int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem *heads,
 		heads += n;
 		count -= n;
 	}
-	r = __vhost_add_used_n(vq, heads, count);
+	return __vhost_add_used_n(vq, heads, count);
+}
+
+static int vhost_add_used_n_in_order(struct vhost_virtqueue *vq,
+				     struct vring_used_elem *heads,
+				     const u16 *nheads,
+				     unsigned count)
+{
+	vring_used_elem_t __user *used;
+	u16 old, new = vq->last_used_idx;
+	int start, i;
+
+	if (!nheads)
+		return -EINVAL;
+
+	start = vq->last_used_idx & (vq->num - 1);
+	used = vq->used->ring + start;
+
+	for (i = 0; i < count; i++) {
+		if (vhost_put_used(vq, &heads[i], start, 1)) {
+			vq_err(vq, "Failed to write used");
+			return -EFAULT;
+		}
+		start += nheads[i];
+		new += nheads[i];
+		if (start >= vq->num)
+			start -= vq->num;
+	}
+
+	if (unlikely(vq->log_used)) {
+		/* Make sure data is seen before log. */
+		smp_wmb();
+		/* Log used ring entry write. */
+		log_used(vq, ((void __user *)used - (void __user *)vq->used),
+			 (vq->num - start) * sizeof *used);
+		if (start + count > vq->num)
+			log_used(vq, 0,
+				 (start + count - vq->num) * sizeof *used);
+	}
+
+	old = vq->last_used_idx;
+	vq->last_used_idx = new;
+	/* If the driver never bothers to signal in a very long while,
+	 * used index might wrap around. If that happens, invalidate
+	 * signalled_used index we stored. TODO: make sure driver
+	 * signals at least once in 2^16 and remove this. */
+	if (unlikely((u16)(new - vq->signalled_used) < (u16)(new - old)))
+		vq->signalled_used_valid = false;
+	return 0;
+}
+
+/* After we've used one of their buffers, we tell them about it.  We'll then
+ * want to notify the guest, using eventfd. */
+int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem *heads,
+		     u16 *nheads, unsigned count)
+{
+	bool in_order = vhost_has_feature(vq, VIRTIO_F_IN_ORDER);
+	int r;
+
+	if (!in_order || !nheads)
+		r = vhost_add_used_n_ooo(vq, heads, count);
+	else
+		r = vhost_add_used_n_in_order(vq, heads, nheads, count);
 
 	if (r < 0)
 		return r;
@@ -2856,9 +2932,11 @@ EXPORT_SYMBOL_GPL(vhost_add_used_and_signal);
 /* multi-buffer version of vhost_add_used_and_signal */
 void vhost_add_used_and_signal_n(struct vhost_dev *dev,
 				 struct vhost_virtqueue *vq,
-				 struct vring_used_elem *heads, unsigned count)
+				 struct vring_used_elem *heads,
+				 u16 *nheads,
+				 unsigned count)
 {
-	vhost_add_used_n(vq, heads, count);
+	vhost_add_used_n(vq, heads, nheads, count);
 	vhost_signal(dev, vq);
 }
 EXPORT_SYMBOL_GPL(vhost_add_used_and_signal_n);
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index bb75a292d50c..e714ebf9da57 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -103,6 +103,8 @@ struct vhost_virtqueue {
 	 * Values are limited to 0x7fff, and the high bit is used as
 	 * a wrap counter when using VIRTIO_F_RING_PACKED. */
 	u16 last_avail_idx;
+	/* Next avail ring head when VIRTIO_F_IN_ORDER is negoitated */
+	u16 next_avail_head;
 
 	/* Caches available index value from user. */
 	u16 avail_idx;
@@ -129,6 +131,7 @@ struct vhost_virtqueue {
 	struct iovec iotlb_iov[64];
 	struct iovec *indirect;
 	struct vring_used_elem *heads;
+	u16 *nheads;
 	/* Protected by virtqueue mutex. */
 	struct vhost_iotlb *umem;
 	struct vhost_iotlb *iotlb;
@@ -213,11 +216,12 @@ bool vhost_vq_is_setup(struct vhost_virtqueue *vq);
 int vhost_vq_init_access(struct vhost_virtqueue *);
 int vhost_add_used(struct vhost_virtqueue *, unsigned int head, int len);
 int vhost_add_used_n(struct vhost_virtqueue *, struct vring_used_elem *heads,
-		     unsigned count);
+		     u16 *nheads, unsigned count);
 void vhost_add_used_and_signal(struct vhost_dev *, struct vhost_virtqueue *,
 			       unsigned int id, int len);
 void vhost_add_used_and_signal_n(struct vhost_dev *, struct vhost_virtqueue *,
-			       struct vring_used_elem *heads, unsigned count);
+				 struct vring_used_elem *heads, u16 *nheads,
+				 unsigned count);
 void vhost_signal(struct vhost_dev *, struct vhost_virtqueue *);
 void vhost_disable_notify(struct vhost_dev *, struct vhost_virtqueue *);
 bool vhost_vq_avail_empty(struct vhost_dev *, struct vhost_virtqueue *);
-- 
2.39.5


