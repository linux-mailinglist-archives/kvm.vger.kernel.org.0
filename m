Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 080E91ABA87
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 09:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440876AbgDPH5W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 03:57:22 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29910 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2440796AbgDPH5Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 03:57:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587023835;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gavfKGuNl7br7RXb7XSyuq0WG8m5khS0l1y8vD9u01c=;
        b=ikHbNatUX9nVUVc6CTbYhlzguMdMZMUBksI0SW2Mq1myzpmOwamfePmbjoQo/SsdXhiM+2
        C4FBWNGtTwrAhS3DzeRO7kWAE/pDYxoRH1bTH9PNzEz6IyhM47GiOB/CbbLrMxu+dFkPcU
        Bqx2ywR90guDVMWEi4nm8iyuNnDJAxE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-tkGFXRgxOSOh6b_CqJMs6A-1; Thu, 16 Apr 2020 03:57:13 -0400
X-MC-Unique: tkGFXRgxOSOh6b_CqJMs6A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C72601005509;
        Thu, 16 Apr 2020 07:57:11 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-112-194.ams2.redhat.com [10.36.112.194])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 67EA37E7C0;
        Thu, 16 Apr 2020 07:57:06 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 6/8] tools/virtio: Extract virtqueue initialization in vq_reset
Date:   Thu, 16 Apr 2020 09:56:41 +0200
Message-Id: <20200416075643.27330-7-eperezma@redhat.com>
In-Reply-To: <20200416075643.27330-1-eperezma@redhat.com>
References: <20200416075643.27330-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

So we can reset after that in the main loop.

Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
---
 tools/virtio/virtio_test.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/tools/virtio/virtio_test.c b/tools/virtio/virtio_test.c
index d9827b640c21..18d5347003eb 100644
--- a/tools/virtio/virtio_test.c
+++ b/tools/virtio/virtio_test.c
@@ -95,6 +95,19 @@ void vhost_vq_setup(struct vdev_info *dev, struct vq_i=
nfo *info)
 	assert(r >=3D 0);
 }
=20
+static void vq_reset(struct vq_info *info, int num, struct virtio_device=
 *vdev)
+{
+	if (info->vq)
+		vring_del_virtqueue(info->vq);
+
+	memset(info->ring, 0, vring_legacy_size(num, 4096));
+	vring_legacy_init(&info->vring, num, info->ring, 4096);
+	info->vq =3D __vring_new_virtqueue(info->idx, info->vring, vdev, true,
+					 false, vq_notify, vq_callback, "test");
+	assert(info->vq);
+	info->vq->priv =3D info;
+}
+
 static void vq_info_add(struct vdev_info *dev, int num)
 {
 	struct vq_info *info =3D &dev->vqs[dev->nvqs];
@@ -104,13 +117,7 @@ static void vq_info_add(struct vdev_info *dev, int n=
um)
 	info->call =3D eventfd(0, EFD_NONBLOCK);
 	r =3D posix_memalign(&info->ring, 4096, vring_legacy_size(num, 4096));
 	assert(r >=3D 0);
-	memset(info->ring, 0, vring_legacy_size(num, 4096));
-	vring_legacy_init(&info->vring, num, info->ring, 4096);
-	info->vq =3D
-		__vring_new_virtqueue(info->idx, info->vring, &dev->vdev, true,
-				      false, vq_notify, vq_callback, "test");
-	assert(info->vq);
-	info->vq->priv =3D info;
+	vq_reset(info, num, &dev->vdev);
 	vhost_vq_setup(dev, info);
 	dev->fds[info->idx].fd =3D info->call;
 	dev->fds[info->idx].events =3D POLLIN;
--=20
2.18.1

