Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38522199EFF
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 21:29:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731343AbgCaT24 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 15:28:56 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:30162 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730548AbgCaT21 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 31 Mar 2020 15:28:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585682906;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0GUPuc0LB1+DwbqXNlKtNDBywCBrn0kzY5vXvoKJhT0=;
        b=baZCKiyJGTOfegPkP9nnj/qM0OAeLD4ITJrjFXrgrv9347aWuA1J/4lYxIJawlPdhS/dyF
        le1b4QPp7fKaDxqgZXvIyZI9G9tuYGxPy187KBQkuUM0jWbDUD0VeibpPNclXIfGuNSCGs
        yZvwpffhmQxSHv6GW0zSHN3BEkgJ2G4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-zdMphn8ePVq7hL0SqzGSUg-1; Tue, 31 Mar 2020 15:28:25 -0400
X-MC-Unique: zdMphn8ePVq7hL0SqzGSUg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7726518A6ECF;
        Tue, 31 Mar 2020 19:28:23 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-112-92.ams2.redhat.com [10.36.112.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3368A98A52;
        Tue, 31 Mar 2020 19:28:21 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        kvm list <kvm@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH v3 4/8] vhost: batching fetches
Date:   Tue, 31 Mar 2020 21:28:00 +0200
Message-Id: <20200331192804.6019-5-eperezma@redhat.com>
In-Reply-To: <20200331192804.6019-1-eperezma@redhat.com>
References: <20200331192804.6019-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>

With this patch applied, new and old code perform identically.

Lots of extra optimizations are now possible, e.g.
we can fetch multiple heads with copy_from/to_user now.
We can get rid of maintaining the log array.  Etc etc.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
---
 drivers/vhost/test.c  |  2 +-
 drivers/vhost/vhost.c | 47 ++++++++++++++++++++++++++++++++++++++-----
 drivers/vhost/vhost.h |  5 ++++-
 3 files changed, 47 insertions(+), 7 deletions(-)

diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index 394e2e5c772d..4b00cd4266ad 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -119,7 +119,7 @@ static int vhost_test_open(struct inode *inode, struc=
t file *f)
 	dev =3D &n->dev;
 	vqs[VHOST_TEST_VQ] =3D &n->vqs[VHOST_TEST_VQ];
 	n->vqs[VHOST_TEST_VQ].handle_kick =3D handle_vq_kick;
-	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV,
+	vhost_dev_init(dev, vqs, VHOST_TEST_VQ_MAX, UIO_MAXIOV + 64,
 		       VHOST_TEST_PKT_WEIGHT, VHOST_TEST_WEIGHT);
=20
 	f->private_data =3D n;
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 56c5253056ee..1646b1ce312a 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -303,6 +303,7 @@ static void vhost_vq_reset(struct vhost_dev *dev,
 {
 	vq->num =3D 1;
 	vq->ndescs =3D 0;
+	vq->first_desc =3D 0;
 	vq->desc =3D NULL;
 	vq->avail =3D NULL;
 	vq->used =3D NULL;
@@ -371,6 +372,11 @@ static int vhost_worker(void *data)
 	return 0;
 }
=20
+static int vhost_vq_num_batch_descs(struct vhost_virtqueue *vq)
+{
+	return vq->max_descs - UIO_MAXIOV;
+}
+
 static void vhost_vq_free_iovecs(struct vhost_virtqueue *vq)
 {
 	kfree(vq->descs);
@@ -393,6 +399,9 @@ static long vhost_dev_alloc_iovecs(struct vhost_dev *=
dev)
 	for (i =3D 0; i < dev->nvqs; ++i) {
 		vq =3D dev->vqs[i];
 		vq->max_descs =3D dev->iov_limit;
+		if (vhost_vq_num_batch_descs(vq) < 0) {
+			return -EINVAL;
+		}
 		vq->descs =3D kmalloc_array(vq->max_descs,
 					  sizeof(*vq->descs),
 					  GFP_KERNEL);
@@ -1643,6 +1652,7 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigne=
d int ioctl, void __user *arg
 		vq->last_avail_idx =3D s.num;
 		/* Forget the cached index value. */
 		vq->avail_idx =3D vq->last_avail_idx;
+		vq->ndescs =3D vq->first_desc =3D 0;
 		break;
 	case VHOST_GET_VRING_BASE:
 		s.index =3D idx;
@@ -2211,7 +2221,7 @@ static int fetch_indirect_descs(struct vhost_virtqu=
eue *vq,
 	return 0;
 }
=20
-static int fetch_descs(struct vhost_virtqueue *vq)
+static int fetch_buf(struct vhost_virtqueue *vq)
 {
 	unsigned int i, head, found =3D 0;
 	struct vhost_desc *last;
@@ -2224,7 +2234,11 @@ static int fetch_descs(struct vhost_virtqueue *vq)
 	/* Check it isn't doing very strange things with descriptor numbers. */
 	last_avail_idx =3D vq->last_avail_idx;
=20
-	if (vq->avail_idx =3D=3D vq->last_avail_idx) {
+	if (unlikely(vq->avail_idx =3D=3D vq->last_avail_idx)) {
+		/* If we already have work to do, don't bother re-checking. */
+		if (likely(vq->ndescs))
+			return vq->num;
+
 		if (unlikely(vhost_get_avail_idx(vq, &avail_idx))) {
 			vq_err(vq, "Failed to access avail idx at %p\n",
 				&vq->avail->idx);
@@ -2315,6 +2329,24 @@ static int fetch_descs(struct vhost_virtqueue *vq)
 	return 0;
 }
=20
+static int fetch_descs(struct vhost_virtqueue *vq)
+{
+	int ret =3D 0;
+
+	if (unlikely(vq->first_desc >=3D vq->ndescs)) {
+		vq->first_desc =3D 0;
+		vq->ndescs =3D 0;
+	}
+
+	if (vq->ndescs)
+		return 0;
+
+	while (!ret && vq->ndescs <=3D vhost_vq_num_batch_descs(vq))
+		ret =3D fetch_buf(vq);
+
+	return vq->ndescs ? 0 : ret;
+}
+
 /* This looks in the virtqueue and for the first available buffer, and c=
onverts
  * it to an iovec for convenient access.  Since descriptors consist of s=
ome
  * number of output then some number of input descriptors, it's actually=
 two
@@ -2340,7 +2372,7 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 	if (unlikely(log))
 		*log_num =3D 0;
=20
-	for (i =3D 0; i < vq->ndescs; ++i) {
+	for (i =3D vq->first_desc; i < vq->ndescs; ++i) {
 		unsigned iov_count =3D *in_num + *out_num;
 		struct vhost_desc *desc =3D &vq->descs[i];
 		int access;
@@ -2386,14 +2418,19 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 		}
=20
 		ret =3D desc->id;
+
+		if (!(desc->flags & VRING_DESC_F_NEXT))
+			break;
 	}
=20
-	vq->ndescs =3D 0;
+	vq->first_desc =3D i + 1;
=20
 	return ret;
=20
 err:
-	vhost_discard_vq_desc(vq, 1);
+	for (i =3D vq->first_desc; i < vq->ndescs; ++i)
+		if (!(vq->descs[i].flags & VRING_DESC_F_NEXT))
+			vhost_discard_vq_desc(vq, 1);
 	vq->ndescs =3D 0;
=20
 	return ret;
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 1dbb5e44fba4..e1caca605c56 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -100,6 +100,7 @@ struct vhost_virtqueue {
=20
 	struct vhost_desc *descs;
 	int ndescs;
+	int first_desc;
 	int max_descs;
=20
 	const struct vhost_umem_node *meta_iotlb[VHOST_NUM_ADDRS];
@@ -242,7 +243,7 @@ ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
 int vhost_init_device_iotlb(struct vhost_dev *d, bool enabled);
=20
 #define vq_err(vq, fmt, ...) do {                                  \
-		pr_debug(pr_fmt(fmt), ##__VA_ARGS__);       \
+		pr_err(pr_fmt(fmt), ##__VA_ARGS__);       \
 		if ((vq)->error_ctx)                               \
 				eventfd_signal((vq)->error_ctx, 1);\
 	} while (0)
@@ -268,6 +269,8 @@ static inline void vhost_vq_set_backend(struct vhost_=
virtqueue *vq,
 					void *private_data)
 {
 	vq->private_data =3D private_data;
+	vq->ndescs =3D 0;
+	vq->first_desc =3D 0;
 }
=20
 /**
--=20
2.18.1

