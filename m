Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5561ABA98
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 09:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441049AbgDPH6a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 03:58:30 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:33057 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2440834AbgDPH5N (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Apr 2020 03:57:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587023831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ykITk4fxK46D6AMrZatD/OE634nsOv7eweYKlbWRBw8=;
        b=H4K3SBoYjiV3cKFwnFv+Z1ahNok6aOXZEpiakbbCQ9QBnYIYNE9kqWQNnAFTYy50k7Y/cm
        hNiDIEfvdFBx3qJS3RrKd6d/eoWEaGg02zRxPzG0bbxH7PtQkpWksoDHXOoTlvu4RjeHKb
        BSJ4QcqgdONgdlgwwu0we9RBfrVNEuI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-Hw17gpxjPcefP6o9UzMOdw-1; Thu, 16 Apr 2020 03:57:07 -0400
X-MC-Unique: Hw17gpxjPcefP6o9UzMOdw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 58C73DB81;
        Thu, 16 Apr 2020 07:57:06 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-112-194.ams2.redhat.com [10.36.112.194])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EF0BA7E7C0;
        Thu, 16 Apr 2020 07:57:03 +0000 (UTC)
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
Subject: [PATCH v2 5/8] tools/virtio: Use __vring_new_virtqueue in virtio_test.c
Date:   Thu, 16 Apr 2020 09:56:40 +0200
Message-Id: <20200416075643.27330-6-eperezma@redhat.com>
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

As updated in ("2a2d1382fe9d virtio: Add improved queue allocation API")

Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
---
 tools/virtio/virtio_test.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/tools/virtio/virtio_test.c b/tools/virtio/virtio_test.c
index 1d5144590df6..d9827b640c21 100644
--- a/tools/virtio/virtio_test.c
+++ b/tools/virtio/virtio_test.c
@@ -106,10 +106,9 @@ static void vq_info_add(struct vdev_info *dev, int n=
um)
 	assert(r >=3D 0);
 	memset(info->ring, 0, vring_legacy_size(num, 4096));
 	vring_legacy_init(&info->vring, num, info->ring, 4096);
-	info->vq =3D vring_new_virtqueue(info->idx,
-				       info->vring.num, 4096, &dev->vdev,
-				       true, false, info->ring,
-				       vq_notify, vq_callback, "test");
+	info->vq =3D
+		__vring_new_virtqueue(info->idx, info->vring, &dev->vdev, true,
+				      false, vq_notify, vq_callback, "test");
 	assert(info->vq);
 	info->vq->priv =3D info;
 	vhost_vq_setup(dev, info);
--=20
2.18.1

