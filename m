Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABB219B588
	for <lists+kvm@lfdr.de>; Wed,  1 Apr 2020 20:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732677AbgDASbh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Apr 2020 14:31:37 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29602 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732979AbgDASbf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Apr 2020 14:31:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585765893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IrU9ncNjbn1K5Fs1mRXL7NsJC/LkFAIBP9NEw8v9ThY=;
        b=TN9b3/A9EEp+w/4Af3WaWwplxpgnFd9+C19O4ktwSMGuAILpEtZMl2EU1XOUatohF2Az5Z
        lXPhCkLOssM4t9WbpsoQL/9iyUajibVOS1pk1Vi6kHRHStd9rY/yTF+i5DlZgX7dEqJwNF
        wci/C5czKs+RE6LogUkg4j1DfoW8lh8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-bbq3A0CKOfGR4ZFxbLRNPg-1; Wed, 01 Apr 2020 14:31:31 -0400
X-MC-Unique: bbq3A0CKOfGR4ZFxbLRNPg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5AC31149C3;
        Wed,  1 Apr 2020 18:31:30 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-113-73.ams2.redhat.com [10.36.113.73])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0058F99DEE;
        Wed,  1 Apr 2020 18:31:27 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        kvm list <kvm@vger.kernel.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH v4 1/7] vhost: option to fetch descriptors through an independent struct
Date:   Wed,  1 Apr 2020 20:31:12 +0200
Message-Id: <20200401183118.8334-2-eperezma@redhat.com>
In-Reply-To: <20200401183118.8334-1-eperezma@redhat.com>
References: <20200401183118.8334-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>

The idea is to support multiple ring formats by converting
to a format-independent array of descriptors.

This costs extra cycles, but we gain in ability
to fetch a batch of descriptors in one go, which
is good for code cache locality.

When used, this causes a minor performance degradation,
it's been kept as simple as possible for ease of review.
A follow-up patch gets us back the performance by adding batching.

To simplify benchmarking, I kept the old code around so one can switch
back and forth between old and new code. This will go away in the final
submission.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
---
 drivers/vhost/vhost.c | 297 +++++++++++++++++++++++++++++++++++++++++-
 drivers/vhost/vhost.h |  16 +++
 2 files changed, 312 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index d450e16c5c25..56593ba6decc 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -298,6 +298,7 @@ static void vhost_vq_reset(struct vhost_dev *dev,
 			   struct vhost_virtqueue *vq)
 {
 	vq->num =3D 1;
+	vq->ndescs =3D 0;
 	vq->desc =3D NULL;
 	vq->avail =3D NULL;
 	vq->used =3D NULL;
@@ -368,6 +369,9 @@ static int vhost_worker(void *data)
=20
 static void vhost_vq_free_iovecs(struct vhost_virtqueue *vq)
 {
+	kfree(vq->descs);
+	vq->descs =3D NULL;
+	vq->max_descs =3D 0;
 	kfree(vq->indirect);
 	vq->indirect =3D NULL;
 	kfree(vq->log);
@@ -384,6 +388,10 @@ static long vhost_dev_alloc_iovecs(struct vhost_dev =
*dev)
=20
 	for (i =3D 0; i < dev->nvqs; ++i) {
 		vq =3D dev->vqs[i];
+		vq->max_descs =3D dev->iov_limit;
+		vq->descs =3D kmalloc_array(vq->max_descs,
+					  sizeof(*vq->descs),
+					  GFP_KERNEL);
 		vq->indirect =3D kmalloc_array(UIO_MAXIOV,
 					     sizeof(*vq->indirect),
 					     GFP_KERNEL);
@@ -391,7 +399,7 @@ static long vhost_dev_alloc_iovecs(struct vhost_dev *=
dev)
 					GFP_KERNEL);
 		vq->heads =3D kmalloc_array(dev->iov_limit, sizeof(*vq->heads),
 					  GFP_KERNEL);
-		if (!vq->indirect || !vq->log || !vq->heads)
+		if (!vq->indirect || !vq->log || !vq->heads || !vq->descs)
 			goto err_nomem;
 	}
 	return 0;
@@ -2277,6 +2285,293 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 }
 EXPORT_SYMBOL_GPL(vhost_get_vq_desc);
=20
+static struct vhost_desc *peek_split_desc(struct vhost_virtqueue *vq)
+{
+	BUG_ON(!vq->ndescs);
+	return &vq->descs[vq->ndescs - 1];
+}
+
+static void pop_split_desc(struct vhost_virtqueue *vq)
+{
+	BUG_ON(!vq->ndescs);
+	--vq->ndescs;
+}
+
+#define VHOST_DESC_FLAGS (VRING_DESC_F_INDIRECT | VRING_DESC_F_WRITE | \
+			  VRING_DESC_F_NEXT)
+static int push_split_desc(struct vhost_virtqueue *vq, struct vring_desc=
 *desc, u16 id)
+{
+	struct vhost_desc *h;
+
+	if (unlikely(vq->ndescs >=3D vq->max_descs))
+		return -EINVAL;
+	h =3D &vq->descs[vq->ndescs++];
+	h->addr =3D vhost64_to_cpu(vq, desc->addr);
+	h->len =3D vhost32_to_cpu(vq, desc->len);
+	h->flags =3D vhost16_to_cpu(vq, desc->flags) & VHOST_DESC_FLAGS;
+	h->id =3D id;
+
+	return 0;
+}
+
+static int fetch_indirect_descs(struct vhost_virtqueue *vq,
+				struct vhost_desc *indirect,
+				u16 head)
+{
+	struct vring_desc desc;
+	unsigned int i =3D 0, count, found =3D 0;
+	u32 len =3D indirect->len;
+	struct iov_iter from;
+	int ret;
+
+	/* Sanity check */
+	if (unlikely(len % sizeof desc)) {
+		vq_err(vq, "Invalid length in indirect descriptor: "
+		       "len 0x%llx not multiple of 0x%zx\n",
+		       (unsigned long long)len,
+		       sizeof desc);
+		return -EINVAL;
+	}
+
+	ret =3D translate_desc(vq, indirect->addr, len, vq->indirect,
+			     UIO_MAXIOV, VHOST_ACCESS_RO);
+	if (unlikely(ret < 0)) {
+		if (ret !=3D -EAGAIN)
+			vq_err(vq, "Translation failure %d in indirect.\n", ret);
+		return ret;
+	}
+	iov_iter_init(&from, READ, vq->indirect, ret, len);
+
+	/* We will use the result as an address to read from, so most
+	 * architectures only need a compiler barrier here. */
+	read_barrier_depends();
+
+	count =3D len / sizeof desc;
+	/* Buffers are chained via a 16 bit next field, so
+	 * we can have at most 2^16 of these. */
+	if (unlikely(count > USHRT_MAX + 1)) {
+		vq_err(vq, "Indirect buffer length too big: %d\n",
+		       indirect->len);
+		return -E2BIG;
+	}
+	if (unlikely(vq->ndescs + count > vq->max_descs)) {
+		vq_err(vq, "Too many indirect + direct descs: %d + %d\n",
+		       vq->ndescs, indirect->len);
+		return -E2BIG;
+	}
+
+	do {
+		if (unlikely(++found > count)) {
+			vq_err(vq, "Loop detected: last one at %u "
+			       "indirect size %u\n",
+			       i, count);
+			return -EINVAL;
+		}
+		if (unlikely(!copy_from_iter_full(&desc, sizeof(desc), &from))) {
+			vq_err(vq, "Failed indirect descriptor: idx %d, %zx\n",
+			       i, (size_t)indirect->addr + i * sizeof desc);
+			return -EINVAL;
+		}
+		if (unlikely(desc.flags & cpu_to_vhost16(vq, VRING_DESC_F_INDIRECT))) =
{
+			vq_err(vq, "Nested indirect descriptor: idx %d, %zx\n",
+			       i, (size_t)indirect->addr + i * sizeof desc);
+			return -EINVAL;
+		}
+
+		push_split_desc(vq, &desc, head);
+	} while ((i =3D next_desc(vq, &desc)) !=3D -1);
+	return 0;
+}
+
+static int fetch_descs(struct vhost_virtqueue *vq)
+{
+	unsigned int i, head, found =3D 0;
+	struct vhost_desc *last;
+	struct vring_desc desc;
+	__virtio16 avail_idx;
+	__virtio16 ring_head;
+	u16 last_avail_idx;
+	int ret;
+
+	/* Check it isn't doing very strange things with descriptor numbers. */
+	last_avail_idx =3D vq->last_avail_idx;
+
+	if (vq->avail_idx =3D=3D vq->last_avail_idx) {
+		if (unlikely(vhost_get_avail_idx(vq, &avail_idx))) {
+			vq_err(vq, "Failed to access avail idx at %p\n",
+				&vq->avail->idx);
+			return -EFAULT;
+		}
+		vq->avail_idx =3D vhost16_to_cpu(vq, avail_idx);
+
+		if (unlikely((u16)(vq->avail_idx - last_avail_idx) > vq->num)) {
+			vq_err(vq, "Guest moved used index from %u to %u",
+				last_avail_idx, vq->avail_idx);
+			return -EFAULT;
+		}
+
+		/* If there's nothing new since last we looked, return
+		 * invalid.
+		 */
+		if (vq->avail_idx =3D=3D last_avail_idx)
+			return vq->num;
+
+		/* Only get avail ring entries after they have been
+		 * exposed by guest.
+		 */
+		smp_rmb();
+	}
+
+	/* Grab the next descriptor number they're advertising */
+	if (unlikely(vhost_get_avail_head(vq, &ring_head, last_avail_idx))) {
+		vq_err(vq, "Failed to read head: idx %d address %p\n",
+		       last_avail_idx,
+		       &vq->avail->ring[last_avail_idx % vq->num]);
+		return -EFAULT;
+	}
+
+	head =3D vhost16_to_cpu(vq, ring_head);
+
+	/* If their number is silly, that's an error. */
+	if (unlikely(head >=3D vq->num)) {
+		vq_err(vq, "Guest says index %u > %u is available",
+		       head, vq->num);
+		return -EINVAL;
+	}
+
+	i =3D head;
+	do {
+		if (unlikely(i >=3D vq->num)) {
+			vq_err(vq, "Desc index is %u > %u, head =3D %u",
+			       i, vq->num, head);
+			return -EINVAL;
+		}
+		if (unlikely(++found > vq->num)) {
+			vq_err(vq, "Loop detected: last one at %u "
+			       "vq size %u head %u\n",
+			       i, vq->num, head);
+			return -EINVAL;
+		}
+		ret =3D vhost_get_desc(vq, &desc, i);
+		if (unlikely(ret)) {
+			vq_err(vq, "Failed to get descriptor: idx %d addr %p\n",
+			       i, vq->desc + i);
+			return -EFAULT;
+		}
+		ret =3D push_split_desc(vq, &desc, head);
+		if (unlikely(ret)) {
+			vq_err(vq, "Failed to save descriptor: idx %d\n", i);
+			return -EINVAL;
+		}
+	} while ((i =3D next_desc(vq, &desc)) !=3D -1);
+
+	last =3D peek_split_desc(vq);
+	if (unlikely(last->flags & VRING_DESC_F_INDIRECT)) {
+		pop_split_desc(vq);
+		ret =3D fetch_indirect_descs(vq, last, head);
+		if (unlikely(ret < 0)) {
+			if (ret !=3D -EAGAIN)
+				vq_err(vq, "Failure detected "
+				       "in indirect descriptor at idx %d\n", head);
+			return ret;
+		}
+	}
+
+	/* Assume notifications from guest are disabled at this point,
+	 * if they aren't we would need to update avail_event index. */
+	BUG_ON(!(vq->used_flags & VRING_USED_F_NO_NOTIFY));
+
+	/* On success, increment avail index. */
+	vq->last_avail_idx++;
+
+	return 0;
+}
+
+/* This looks in the virtqueue and for the first available buffer, and c=
onverts
+ * it to an iovec for convenient access.  Since descriptors consist of s=
ome
+ * number of output then some number of input descriptors, it's actually=
 two
+ * iovecs, but we pack them into one and note how many of each there wer=
e.
+ *
+ * This function returns the descriptor number found, or vq->num (which =
is
+ * never a valid descriptor number) if none was found.  A negative code =
is
+ * returned on error. */
+int vhost_get_vq_desc_batch(struct vhost_virtqueue *vq,
+		      struct iovec iov[], unsigned int iov_size,
+		      unsigned int *out_num, unsigned int *in_num,
+		      struct vhost_log *log, unsigned int *log_num)
+{
+	int ret =3D fetch_descs(vq);
+	int i;
+
+	if (ret)
+		return ret;
+
+	/* Now convert to IOV */
+	/* When we start there are none of either input nor output. */
+	*out_num =3D *in_num =3D 0;
+	if (unlikely(log))
+		*log_num =3D 0;
+
+	for (i =3D 0; i < vq->ndescs; ++i) {
+		unsigned iov_count =3D *in_num + *out_num;
+		struct vhost_desc *desc =3D &vq->descs[i];
+		int access;
+
+		if (desc->flags & ~VHOST_DESC_FLAGS) {
+			vq_err(vq, "Unexpected flags: 0x%x at descriptor id 0x%x\n",
+			       desc->flags, desc->id);
+			ret =3D -EINVAL;
+			goto err;
+		}
+		if (desc->flags & VRING_DESC_F_WRITE)
+			access =3D VHOST_ACCESS_WO;
+		else
+			access =3D VHOST_ACCESS_RO;
+		ret =3D translate_desc(vq, desc->addr,
+				     desc->len, iov + iov_count,
+				     iov_size - iov_count, access);
+		if (unlikely(ret < 0)) {
+			if (ret !=3D -EAGAIN)
+				vq_err(vq, "Translation failure %d descriptor idx %d\n",
+					ret, i);
+			goto err;
+		}
+		if (access =3D=3D VHOST_ACCESS_WO) {
+			/* If this is an input descriptor,
+			 * increment that count. */
+			*in_num +=3D ret;
+			if (unlikely(log && ret)) {
+				log[*log_num].addr =3D desc->addr;
+				log[*log_num].len =3D desc->len;
+				++*log_num;
+			}
+		} else {
+			/* If it's an output descriptor, they're all supposed
+			 * to come before any input descriptors. */
+			if (unlikely(*in_num)) {
+				vq_err(vq, "Descriptor has out after in: "
+				       "idx %d\n", i);
+				ret =3D -EINVAL;
+				goto err;
+			}
+			*out_num +=3D ret;
+		}
+
+		ret =3D desc->id;
+	}
+
+	vq->ndescs =3D 0;
+
+	return ret;
+
+err:
+	vhost_discard_vq_desc(vq, 1);
+	vq->ndescs =3D 0;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vhost_get_vq_desc_batch);
+
 /* Reverse the effect of vhost_get_vq_desc. Useful for error handling. *=
/
 void vhost_discard_vq_desc(struct vhost_virtqueue *vq, int n)
 {
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index f8403bd46b85..20bb95661f94 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -60,6 +60,13 @@ enum vhost_uaddr_type {
 	VHOST_NUM_ADDRS =3D 3,
 };
=20
+struct vhost_desc {
+	u64 addr;
+	u32 len;
+	u16 flags; /* VRING_DESC_F_WRITE, VRING_DESC_F_NEXT */
+	u16 id;
+};
+
 /* The virtqueue structure describes a queue attached to a device. */
 struct vhost_virtqueue {
 	struct vhost_dev *dev;
@@ -71,6 +78,11 @@ struct vhost_virtqueue {
 	struct vring_avail __user *avail;
 	struct vring_used __user *used;
 	const struct vhost_iotlb_map *meta_iotlb[VHOST_NUM_ADDRS];
+
+	struct vhost_desc *descs;
+	int ndescs;
+	int max_descs;
+
 	struct file *kick;
 	struct eventfd_ctx *call_ctx;
 	struct eventfd_ctx *error_ctx;
@@ -175,6 +187,10 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned=
 int ioctl, void __user *arg
 bool vhost_vq_access_ok(struct vhost_virtqueue *vq);
 bool vhost_log_access_ok(struct vhost_dev *);
=20
+int vhost_get_vq_desc_batch(struct vhost_virtqueue *,
+		      struct iovec iov[], unsigned int iov_count,
+		      unsigned int *out_num, unsigned int *in_num,
+		      struct vhost_log *log, unsigned int *log_num);
 int vhost_get_vq_desc(struct vhost_virtqueue *,
 		      struct iovec iov[], unsigned int iov_count,
 		      unsigned int *out_num, unsigned int *in_num,
--=20
2.18.1

