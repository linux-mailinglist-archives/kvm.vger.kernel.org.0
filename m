Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B49F19DC1D
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 18:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404650AbgDCQv7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 12:51:59 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:57892 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2404638AbgDCQv4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Apr 2020 12:51:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585932715;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=nk4IMYZH5hA+grx8NX+gdSGbc36TSHy3mPL/TXH5NwQ=;
        b=CPt4LxMlUXUh/kRvw4h113OMEcm4GnyN4dGfbClB4gozyVaZgWxdBJ9KHQXaPkDOriss8g
        jJ26GEklJPIBCKkKNDEHyEqtlE7Gp7xjonEagbZDNVjyw06n3B9bYwYQA2Py1nqBTXOdiD
        ai7thVuO9skmahwZYKe6Hq2OC3s0RBc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-463-bacAC-9KM1GftEvSI7fyMA-1; Fri, 03 Apr 2020 12:51:53 -0400
X-MC-Unique: bacAC-9KM1GftEvSI7fyMA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 19AB2800D53;
        Fri,  3 Apr 2020 16:51:52 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-113-28.ams2.redhat.com [10.36.113.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A058518A85;
        Fri,  3 Apr 2020 16:51:49 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 6/8] tools/virtio: Extract virtqueue initialization in vq_reset
Date:   Fri,  3 Apr 2020 18:51:17 +0200
Message-Id: <20200403165119.5030-7-eperezma@redhat.com>
In-Reply-To: <20200403165119.5030-1-eperezma@redhat.com>
References: <20200403165119.5030-1-eperezma@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

So we can reset after that in the main loop
---
 tools/virtio/virtio_test.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/tools/virtio/virtio_test.c b/tools/virtio/virtio_test.c
index 9b730434997c..7b7829e510c0 100644
--- a/tools/virtio/virtio_test.c
+++ b/tools/virtio/virtio_test.c
@@ -95,6 +95,19 @@ void vhost_vq_setup(struct vdev_info *dev, struct vq_info *info)
 	assert(r >= 0);
 }
 
+static void vq_reset(struct vq_info *info, int num, struct virtio_device *vdev)
+{
+	if (info->vq)
+		vring_del_virtqueue(info->vq);
+
+	memset(info->ring, 0, vring_size(num, 4096));
+	vring_init(&info->vring, num, info->ring, 4096);
+	info->vq = __vring_new_virtqueue(info->idx, info->vring, vdev, true,
+					 false, vq_notify, vq_callback, "test");
+	assert(info->vq);
+	info->vq->priv = info;
+}
+
 static void vq_info_add(struct vdev_info *dev, int num)
 {
 	struct vq_info *info = &dev->vqs[dev->nvqs];
@@ -104,13 +117,7 @@ static void vq_info_add(struct vdev_info *dev, int num)
 	info->call = eventfd(0, EFD_NONBLOCK);
 	r = posix_memalign(&info->ring, 4096, vring_size(num, 4096));
 	assert(r >= 0);
-	memset(info->ring, 0, vring_size(num, 4096));
-	vring_init(&info->vring, num, info->ring, 4096);
-	info->vq =
-		__vring_new_virtqueue(info->idx, info->vring, &dev->vdev, true,
-				      false, vq_notify, vq_callback, "test");
-	assert(info->vq);
-	info->vq->priv = info;
+	vq_reset(info, num, &dev->vdev);
 	vhost_vq_setup(dev, info);
 	dev->fds[info->idx].fd = info->call;
 	dev->fds[info->idx].events = POLLIN;
-- 
2.18.1

