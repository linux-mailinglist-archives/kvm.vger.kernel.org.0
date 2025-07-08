Return-Path: <kvm+bounces-51728-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53140AFC31F
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 08:49:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D86A942504C
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 06:48:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72788227EAA;
	Tue,  8 Jul 2025 06:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UhyMGAee"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16E62264CF
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 06:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751957320; cv=none; b=qsnY9cLNDDygeFntM5/zB4T7cOBt/YfzXm6usylFop+FCg0RUO36wfBJhOw5Y/Fmk2OJocDVJpi5w8UalXE5X04oQhI/WOKGmRpWGos3vvn1pV0xqgqDS+jiQ0z9/2SQ+7rwrFO3lS7FtMlvlijWyh/xMdb1dx3eUU1p1r/Vw4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751957320; c=relaxed/simple;
	bh=Xa+Dr0xa8OhtWcB403K0vBX5a/plYjfANueuy6bB4U8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xs63mJ9bkWFbwIAAS1CLqIZFtNNWm95gkcdmiC8CY9hoXKBDTCj1jE/Ks5pGX7Xgp9zw28ftN6zryoTMnx3nCBXi+yyQZSIjGtj5H8Fv1BkLAFHdV6TQpTHifpKnwEMnY/fjadzSzpJBryQCtVFrGCyuX6Yr0T1OO2JYCJO8oII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UhyMGAee; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751957317;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cdJTt8kUxyLhklAXD2nDm7x6/Dvbfcd8Q0xrLMB8L9E=;
	b=UhyMGAeeX3PsfFnMDfhEG/Mx2k/8sr9QeaRSs6eQwScnxL6QMAOBdQBsspdNO4t0GhFAHN
	gWZPZjYFsWOLPNupypPr4mIya5PRkTnsF7OosW0qhuc3IZ8vc18TwP4rCHJovcr8pTyJw5
	T84nRXoSF1NV3IsbDJdBHLPNyb7pkHc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-693-RGsLEBcoPHeTg23s_XtQxw-1; Tue,
 08 Jul 2025 02:48:34 -0400
X-MC-Unique: RGsLEBcoPHeTg23s_XtQxw-1
X-Mimecast-MFC-AGG-ID: RGsLEBcoPHeTg23s_XtQxw_1751957313
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 49B9E180028B;
	Tue,  8 Jul 2025 06:48:33 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.112.173])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2BDC819560B2;
	Tue,  8 Jul 2025 06:48:28 +0000 (UTC)
From: Jason Wang <jasowang@redhat.com>
To: mst@redhat.com,
	jasowang@redhat.com,
	eperezma@redhat.com
Cc: kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jonah.palmer@oracle.com
Subject: [PATCH net-next 1/2] vhost: basic in order support
Date: Tue,  8 Jul 2025 14:48:18 +0800
Message-ID: <20250708064819.35282-2-jasowang@redhat.com>
In-Reply-To: <20250708064819.35282-1-jasowang@redhat.com>
References: <20250708064819.35282-1-jasowang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

This patch adds basic in order support for vhost. Two optimizations
are implemented in this patch:

1) Since driver uses descriptor in order, vhost can deduce the next
   avail ring head by counting the number of descriptors that has been
   used in next_avail_head. This eliminate the need to access the
   available ring in vhost.

2) vhost_add_used_and_singal_n() is extended to accept the number of
   batched buffers per used elem. While this increases the times of
   usersapce memory access but it helps to reduce the chance of
   used ring access of both the driver and vhost.

Vhost-net will be the first user for this.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/net.c   |   6 ++-
 drivers/vhost/vhost.c | 121 +++++++++++++++++++++++++++++++++++-------
 drivers/vhost/vhost.h |   8 ++-
 3 files changed, 111 insertions(+), 24 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 7cbfc7d718b3..4f9c67f17b49 100644
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
index 3a5ebb973dba..c7ed069fc49e 100644
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
 
@@ -2757,10 +2772,10 @@ static int __vhost_add_used_n(struct vhost_virtqueue *vq,
 	return 0;
 }
 
-/* After we've used one of their buffers, we tell them about it.  We'll then
- * want to notify the guest, using eventfd. */
-int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem *heads,
-		     unsigned count)
+static int vhost_add_used_n_ooo(struct vhost_virtqueue *vq,
+				struct vring_used_elem *heads,
+				u16 *nheads,
+				unsigned count)
 {
 	int start, n, r;
 
@@ -2775,6 +2790,70 @@ int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem *heads,
 	}
 	r = __vhost_add_used_n(vq, heads, count);
 
+	return r;
+}
+
+static int vhost_add_used_n_in_order(struct vhost_virtqueue *vq,
+				     struct vring_used_elem *heads,
+				     u16 *nheads,
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
+		r = vhost_add_used_n_ooo(vq, heads, nheads, count);
+	else
+		r = vhost_add_used_n_in_order(vq, heads, nheads, count);
+
 	/* Make sure buffer is written before we update index. */
 	smp_wmb();
 	if (vhost_put_used_idx(vq)) {
@@ -2853,9 +2932,11 @@ EXPORT_SYMBOL_GPL(vhost_add_used_and_signal);
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
index bb75a292d50c..dca9f309d396 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -103,6 +103,8 @@ struct vhost_virtqueue {
 	 * Values are limited to 0x7fff, and the high bit is used as
 	 * a wrap counter when using VIRTIO_F_RING_PACKED. */
 	u16 last_avail_idx;
+	/* Next avail ring head when VIRTIO_F_IN_ORDER is neogitated */
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
2.31.1


