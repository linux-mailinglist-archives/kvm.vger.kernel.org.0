Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4B50196D04
	for <lists+kvm@lfdr.de>; Sun, 29 Mar 2020 13:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728175AbgC2Lel (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Mar 2020 07:34:41 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:50752 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728152AbgC2Lek (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 29 Mar 2020 07:34:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585481678;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JSw0KMBvuDoMQV+mDTD5nU1w9qdk9B6Qfod2YKyKWFE=;
        b=Qps+66Te0dBfKIxSlC61ipiQDeAoxmZ5sd8Mt4wr335fRhbbnUdhk/wxFB4l0mJd2a9fEq
        ZoSb2hPDyE2n3y8COBnPt+VoWJhGaMVOMmOIt1L468ZwIzsxb/hkuVlr2xH5ds+zThdGHi
        fMZyYi1CLgcHDWYRF4rmM7bQdvXhxeA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-bGLeV0i8MIKRXEXFWUDn8A-1; Sun, 29 Mar 2020 07:34:35 -0400
X-MC-Unique: bGLeV0i8MIKRXEXFWUDn8A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AC2408017CE;
        Sun, 29 Mar 2020 11:34:33 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-112-95.ams2.redhat.com [10.36.112.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 883755C1BE;
        Sun, 29 Mar 2020 11:34:25 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/6] tools/virtio: Make --reset reset ring idx
Date:   Sun, 29 Mar 2020 13:33:57 +0200
Message-Id: <20200329113359.30960-5-eperezma@redhat.com>
In-Reply-To: <20200329113359.30960-1-eperezma@redhat.com>
References: <20200329113359.30960-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
---
 drivers/virtio/virtio_ring.c | 18 ++++++++++++++++++
 include/linux/virtio.h       |  2 ++
 tools/virtio/linux/virtio.h  |  2 ++
 tools/virtio/virtio_test.c   | 28 +++++++++++++++++++++++++++-
 4 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 867c7ebd3f10..aba44ac3f0d6 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -1810,6 +1810,24 @@ int virtqueue_add_inbuf_ctx(struct virtqueue *vq,
 }
 EXPORT_SYMBOL_GPL(virtqueue_add_inbuf_ctx);
=20
+void virtqueue_reset_free_head(struct virtqueue *_vq)
+{
+	struct vring_virtqueue *vq =3D to_vvq(_vq);
+
+	// vq->last_used_idx =3D 0;
+	vq->num_added =3D 0;
+
+	vq->split.queue_size_in_bytes =3D 0;
+	vq->split.avail_flags_shadow =3D 0;
+	vq->split.avail_idx_shadow =3D 0;
+
+	memset(vq->split.desc_state, 0, vq->split.vring.num *
+			sizeof(struct vring_desc_state_split));
+
+	vq->free_head =3D 0;
+}
+EXPORT_SYMBOL_GPL(virtqueue_reset_free_head);
+
 /**
  * virtqueue_kick_prepare - first half of split virtqueue_kick call.
  * @_vq: the struct virtqueue
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 15f906e4a748..286a0048fbeb 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -58,6 +58,8 @@ int virtqueue_add_sgs(struct virtqueue *vq,
 		      void *data,
 		      gfp_t gfp);
=20
+void virtqueue_reset_free_head(struct virtqueue *vq);
+
 bool virtqueue_kick(struct virtqueue *vq);
=20
 bool virtqueue_kick_prepare(struct virtqueue *vq);
diff --git a/tools/virtio/linux/virtio.h b/tools/virtio/linux/virtio.h
index b751350d4ce8..cf2e9ccf4de2 100644
--- a/tools/virtio/linux/virtio.h
+++ b/tools/virtio/linux/virtio.h
@@ -43,6 +43,8 @@ int virtqueue_add_inbuf(struct virtqueue *vq,
 			void *data,
 			gfp_t gfp);
=20
+void virtqueue_reset_free_head(struct virtqueue *vq);
+
 bool virtqueue_kick(struct virtqueue *vq);
=20
 void *virtqueue_get_buf(struct virtqueue *vq, unsigned int *len);
diff --git a/tools/virtio/virtio_test.c b/tools/virtio/virtio_test.c
index 93d81cd64ba0..bf21ece30594 100644
--- a/tools/virtio/virtio_test.c
+++ b/tools/virtio/virtio_test.c
@@ -49,6 +49,7 @@ struct vdev_info {
=20
 static const struct vhost_vring_file no_backend =3D { .fd =3D -1 },
 				     backend =3D { .fd =3D 1 };
+static const struct vhost_vring_state null_state =3D {};
=20
 bool vq_notify(struct virtqueue *vq)
 {
@@ -218,10 +219,33 @@ static void run_test(struct vdev_info *dev, struct =
vq_info *vq,
 			}
=20
 			if (reset) {
+				struct vhost_vring_state s =3D { .index =3D 0 };
+				int i;
+				vq->vring.avail->idx =3D 0;
+				vq->vq->num_free =3D vq->vring.num;
+
+				// Put everything in free lists.
+				for (i =3D 0; i < vq->vring.num-1; i++)
+					vq->vring.desc[i].next =3D
+						cpu_to_virtio16(&dev->vdev,
+								i + 1);
+				vq->vring.desc[vq->vring.num-1].next =3D 0;
+				virtqueue_reset_free_head(vq->vq);
+
+				r =3D ioctl(dev->control, VHOST_GET_VRING_BASE,
+					  &s);
+				assert(!r);
+
+				s.num =3D 0;
+				r =3D ioctl(dev->control, VHOST_SET_VRING_BASE,
+					  &null_state);
+				assert(!r);
+
 				r =3D ioctl(dev->control, VHOST_TEST_SET_BACKEND,
 					  &backend);
 				assert(!r);
=20
+				started =3D completed;
                                 while (completed > next_reset)
 					next_reset +=3D completed;
 			}
@@ -243,7 +267,9 @@ static void run_test(struct vdev_info *dev, struct vq=
_info *vq,
 	test =3D 0;
 	r =3D ioctl(dev->control, VHOST_TEST_RUN, &test);
 	assert(r >=3D 0);
-	fprintf(stderr, "spurious wakeups: 0x%llx\n", spurious);
+	fprintf(stderr,
+		"spurious wakeups: 0x%llx started=3D0x%lx completed=3D0x%lx\n",
+		spurious, started, completed);
 }
=20
 const char optstring[] =3D "h";
--=20
2.18.1

