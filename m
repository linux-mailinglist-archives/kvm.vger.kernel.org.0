Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 380AF1AEBB9
	for <lists+kvm@lfdr.de>; Sat, 18 Apr 2020 12:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgDRKX6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Apr 2020 06:23:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57124 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726054AbgDRKW4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Apr 2020 06:22:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587205375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NTpuDlc6qvgZkv1wgOF0V1ahvk1X+aQkxyfimEc4tRM=;
        b=DElKJzmZG+Tl/eXVTxO+72qxzeuK+OwEjXjgvjBozIXMqE1teq1oig7xRw7szsQUQe+shu
        HlV4Aiu22bHy08G+D3xd2bB7KFR0EYNGfCeIJFSbvXWqrBnmuAKaJu0oKrJom0mQY5OzNm
        hqyW95Bc15+Va7AbGKbm6k4SfsgAvS0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-2j2JnosrPRypXaWZa6e8Ag-1; Sat, 18 Apr 2020 06:22:48 -0400
X-MC-Unique: 2j2JnosrPRypXaWZa6e8Ag-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 938378017F5;
        Sat, 18 Apr 2020 10:22:47 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-112-94.ams2.redhat.com [10.36.112.94])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3E6641001DC2;
        Sat, 18 Apr 2020 10:22:42 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        kvm list <kvm@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: [PATCH v3 6/8] tools/virtio: Extract virtqueue initialization in vq_reset
Date:   Sat, 18 Apr 2020 12:22:15 +0200
Message-Id: <20200418102217.32327-7-eperezma@redhat.com>
In-Reply-To: <20200418102217.32327-1-eperezma@redhat.com>
References: <20200418102217.32327-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
index 0a247ba3b899..bc16c818bda3 100644
--- a/tools/virtio/virtio_test.c
+++ b/tools/virtio/virtio_test.c
@@ -94,6 +94,19 @@ void vhost_vq_setup(struct vdev_info *dev, struct vq_i=
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
+	memset(info->ring, 0, vring_size(num, 4096));
+	vring_init(&info->vring, num, info->ring, 4096);
+	info->vq =3D __vring_new_virtqueue(info->idx, info->vring, vdev, true,
+					 false, vq_notify, vq_callback, "test");
+	assert(info->vq);
+	info->vq->priv =3D info;
+}
+
 static void vq_info_add(struct vdev_info *dev, int num)
 {
 	struct vq_info *info =3D &dev->vqs[dev->nvqs];
@@ -103,13 +116,7 @@ static void vq_info_add(struct vdev_info *dev, int n=
um)
 	info->call =3D eventfd(0, EFD_NONBLOCK);
 	r =3D posix_memalign(&info->ring, 4096, vring_size(num, 4096));
 	assert(r >=3D 0);
-	memset(info->ring, 0, vring_size(num, 4096));
-	vring_init(&info->vring, num, info->ring, 4096);
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

