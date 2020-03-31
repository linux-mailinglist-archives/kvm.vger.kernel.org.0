Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55DD9199D7A
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 20:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbgCaSAZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 14:00:25 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:23894 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726403AbgCaSAZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 31 Mar 2020 14:00:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585677623;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ejq1qV0bZ7JSSzHx+BezIAPlzBsCmIZo0gnP311dA2E=;
        b=gb9R5Yr8Cv/ZT3fJ9VfkehQ8ZpLfm2c7wKXXyE4Cd5mO0+vgn1A6hHQcwcObubQYqP2rdP
        fOkLCodGWH+sA++J+edW0tEW+rvSCZgKtfMx9M7QjZlBLvIxXRozoDCeXOnQWXbo1B27BS
        z3HntV5JRsHf8Im7bA4X+nEbI7O9i7M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-sZyTbHyOOkO-4k3-p-BSeg-1; Tue, 31 Mar 2020 14:00:20 -0400
X-MC-Unique: sZyTbHyOOkO-4k3-p-BSeg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B8475107ACC7;
        Tue, 31 Mar 2020 18:00:18 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-112-92.ams2.redhat.com [10.36.112.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2926F608E7;
        Tue, 31 Mar 2020 18:00:15 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH v2 1/8] vhost: Create accessors for virtqueues private_data
Date:   Tue, 31 Mar 2020 19:59:59 +0200
Message-Id: <20200331180006.25829-2-eperezma@redhat.com>
In-Reply-To: <20200331180006.25829-1-eperezma@redhat.com>
References: <20200331180006.25829-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
---
 drivers/vhost/net.c   | 28 +++++++++++++++-------------
 drivers/vhost/vhost.h | 28 ++++++++++++++++++++++++++++
 drivers/vhost/vsock.c | 14 +++++++-------
 3 files changed, 50 insertions(+), 20 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index e158159671fa..6c5e7a6f712c 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -424,7 +424,7 @@ static void vhost_net_disable_vq(struct vhost_net *n,
 	struct vhost_net_virtqueue *nvq =3D
 		container_of(vq, struct vhost_net_virtqueue, vq);
 	struct vhost_poll *poll =3D n->poll + (nvq - n->vqs);
-	if (!vq->private_data)
+	if (!vhost_vq_get_backend_opaque(vq))
 		return;
 	vhost_poll_stop(poll);
 }
@@ -437,7 +437,7 @@ static int vhost_net_enable_vq(struct vhost_net *n,
 	struct vhost_poll *poll =3D n->poll + (nvq - n->vqs);
 	struct socket *sock;
=20
-	sock =3D vq->private_data;
+	sock =3D vhost_vq_get_backend_opaque(vq);
 	if (!sock)
 		return 0;
=20
@@ -524,7 +524,7 @@ static void vhost_net_busy_poll(struct vhost_net *net=
,
 		return;
=20
 	vhost_disable_notify(&net->dev, vq);
-	sock =3D rvq->private_data;
+	sock =3D vhost_vq_get_backend_opaque(rvq);
=20
 	busyloop_timeout =3D poll_rx ? rvq->busyloop_timeout:
 				     tvq->busyloop_timeout;
@@ -570,8 +570,10 @@ static int vhost_net_tx_get_vq_desc(struct vhost_net=
 *net,
=20
 	if (r =3D=3D tvq->num && tvq->busyloop_timeout) {
 		/* Flush batched packets first */
-		if (!vhost_sock_zcopy(tvq->private_data))
-			vhost_tx_batch(net, tnvq, tvq->private_data, msghdr);
+		if (!vhost_sock_zcopy(vhost_vq_get_backend_opaque(tvq)))
+			vhost_tx_batch(net, tnvq,
+				       vhost_vq_get_backend_opaque(tvq),
+				       msghdr);
=20
 		vhost_net_busy_poll(net, rvq, tvq, busyloop_intr, false);
=20
@@ -685,7 +687,7 @@ static int vhost_net_build_xdp(struct vhost_net_virtq=
ueue *nvq,
 	struct vhost_virtqueue *vq =3D &nvq->vq;
 	struct vhost_net *net =3D container_of(vq->dev, struct vhost_net,
 					     dev);
-	struct socket *sock =3D vq->private_data;
+	struct socket *sock =3D vhost_vq_get_backend_opaque(vq);
 	struct page_frag *alloc_frag =3D &net->page_frag;
 	struct virtio_net_hdr *gso;
 	struct xdp_buff *xdp =3D &nvq->xdp[nvq->batched_xdp];
@@ -952,7 +954,7 @@ static void handle_tx(struct vhost_net *net)
 	struct socket *sock;
=20
 	mutex_lock_nested(&vq->mutex, VHOST_NET_VQ_TX);
-	sock =3D vq->private_data;
+	sock =3D vhost_vq_get_backend_opaque(vq);
 	if (!sock)
 		goto out;
=20
@@ -1121,7 +1123,7 @@ static void handle_rx(struct vhost_net *net)
 	int recv_pkts =3D 0;
=20
 	mutex_lock_nested(&vq->mutex, VHOST_NET_VQ_RX);
-	sock =3D vq->private_data;
+	sock =3D vhost_vq_get_backend_opaque(vq);
 	if (!sock)
 		goto out;
=20
@@ -1344,9 +1346,9 @@ static struct socket *vhost_net_stop_vq(struct vhos=
t_net *n,
 		container_of(vq, struct vhost_net_virtqueue, vq);
=20
 	mutex_lock(&vq->mutex);
-	sock =3D vq->private_data;
+	sock =3D vhost_vq_get_backend_opaque(vq);
 	vhost_net_disable_vq(n, vq);
-	vq->private_data =3D NULL;
+	vhost_vq_set_backend_opaque(vq, NULL);
 	vhost_net_buf_unproduce(nvq);
 	nvq->rx_ring =3D NULL;
 	mutex_unlock(&vq->mutex);
@@ -1528,7 +1530,7 @@ static long vhost_net_set_backend(struct vhost_net =
*n, unsigned index, int fd)
 	}
=20
 	/* start polling new socket */
-	oldsock =3D vq->private_data;
+	oldsock =3D vhost_vq_get_backend_opaque(vq);
 	if (sock !=3D oldsock) {
 		ubufs =3D vhost_net_ubuf_alloc(vq,
 					     sock && vhost_sock_zcopy(sock));
@@ -1538,7 +1540,7 @@ static long vhost_net_set_backend(struct vhost_net =
*n, unsigned index, int fd)
 		}
=20
 		vhost_net_disable_vq(n, vq);
-		vq->private_data =3D sock;
+		vhost_vq_set_backend_opaque(vq, sock);
 		vhost_net_buf_unproduce(nvq);
 		r =3D vhost_vq_init_access(vq);
 		if (r)
@@ -1575,7 +1577,7 @@ static long vhost_net_set_backend(struct vhost_net =
*n, unsigned index, int fd)
 	return 0;
=20
 err_used:
-	vq->private_data =3D oldsock;
+	vhost_vq_set_backend_opaque(vq, oldsock);
 	vhost_net_enable_vq(n, vq);
 	if (ubufs)
 		vhost_net_ubuf_put_wait_and_free(ubufs);
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index a123fd70847e..0808188f7e8f 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -244,6 +244,34 @@ enum {
 			 (1ULL << VIRTIO_F_VERSION_1)
 };
=20
+/**
+ * vhost_vq_set_backend_opaque - Set backend opaque.
+ *
+ * @vq            Virtqueue.
+ * @private_data  The private data.
+ *
+ * Context: Need to call with vq->mutex acquired.
+ */
+static inline void vhost_vq_set_backend_opaque(struct vhost_virtqueue *v=
q,
+					       void *private_data)
+{
+	vq->private_data =3D private_data;
+}
+
+/**
+ * vhost_vq_get_backend_opaque - Get backend opaque.
+ *
+ * @vq            Virtqueue.
+ * @private_data  The private data.
+ *
+ * Context: Need to call with vq->mutex acquired.
+ * Return: Opaque previously set with vhost_vq_set_backend_opaque.
+ */
+static inline void *vhost_vq_get_backend_opaque(struct vhost_virtqueue *=
vq)
+{
+	return vq->private_data;
+}
+
 static inline bool vhost_has_feature(struct vhost_virtqueue *vq, int bit=
)
 {
 	return vq->acked_features & (1ULL << bit);
diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index c2d7d57e98cf..6e20dbe14acd 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -91,7 +91,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
=20
 	mutex_lock(&vq->mutex);
=20
-	if (!vq->private_data)
+	if (!vhost_vq_get_backend_opaque(vq))
 		goto out;
=20
 	/* Avoid further vmexits, we're already processing the virtqueue */
@@ -440,7 +440,7 @@ static void vhost_vsock_handle_tx_kick(struct vhost_w=
ork *work)
=20
 	mutex_lock(&vq->mutex);
=20
-	if (!vq->private_data)
+	if (!vhost_vq_get_backend_opaque(vq))
 		goto out;
=20
 	vhost_disable_notify(&vsock->dev, vq);
@@ -533,8 +533,8 @@ static int vhost_vsock_start(struct vhost_vsock *vsoc=
k)
 			goto err_vq;
 		}
=20
-		if (!vq->private_data) {
-			vq->private_data =3D vsock;
+		if (!vhost_vq_get_backend_opaque(vq)) {
+			vhost_vq_set_backend_opaque(vq, vsock);
 			ret =3D vhost_vq_init_access(vq);
 			if (ret)
 				goto err_vq;
@@ -547,14 +547,14 @@ static int vhost_vsock_start(struct vhost_vsock *vs=
ock)
 	return 0;
=20
 err_vq:
-	vq->private_data =3D NULL;
+	vhost_vq_set_backend_opaque(vq, NULL);
 	mutex_unlock(&vq->mutex);
=20
 	for (i =3D 0; i < ARRAY_SIZE(vsock->vqs); i++) {
 		vq =3D &vsock->vqs[i];
=20
 		mutex_lock(&vq->mutex);
-		vq->private_data =3D NULL;
+		vhost_vq_set_backend_opaque(vq, NULL);
 		mutex_unlock(&vq->mutex);
 	}
 err:
@@ -577,7 +577,7 @@ static int vhost_vsock_stop(struct vhost_vsock *vsock=
)
 		struct vhost_virtqueue *vq =3D &vsock->vqs[i];
=20
 		mutex_lock(&vq->mutex);
-		vq->private_data =3D NULL;
+		vhost_vq_set_backend_opaque(vq, NULL);
 		mutex_unlock(&vq->mutex);
 	}
=20
--=20
2.18.1

