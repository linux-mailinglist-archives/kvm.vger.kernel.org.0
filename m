Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7060F1AEBBE
	for <lists+kvm@lfdr.de>; Sat, 18 Apr 2020 12:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726136AbgDRKYW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Apr 2020 06:24:22 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52800 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726025AbgDRKWr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Apr 2020 06:22:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587205366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UESdyrXT+qLtkr29FvZrw/ATFVQJjMdAGWcplfhsfoM=;
        b=huwLXI96FaA2w+9MyArkaR/czJ3FthBYTjBHG/AlWL+8KFsuw8KCQQHNo/WBZP/+xVoK8I
        +20WOrnyHrmMZJRrl81rOpZ5i7i4GJf3H4rpTOzdxWKnA8PlIj49gvV/jvefiSWAsJSGE9
        R51KrtJ3bK8bbcSgDtHfF8abGqngphc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-126-6ocvjgO7Nei7k3OHZb0Rew-1; Sat, 18 Apr 2020 06:22:43 -0400
X-MC-Unique: 6ocvjgO7Nei7k3OHZb0Rew-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 46AFD1005509;
        Sat, 18 Apr 2020 10:22:42 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-112-94.ams2.redhat.com [10.36.112.94])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E51421000325;
        Sat, 18 Apr 2020 10:22:39 +0000 (UTC)
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
Subject: [PATCH v3 5/8] tools/virtio: Use __vring_new_virtqueue in virtio_test.c
Date:   Sat, 18 Apr 2020 12:22:14 +0200
Message-Id: <20200418102217.32327-6-eperezma@redhat.com>
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

As updated in ("2a2d1382fe9d virtio: Add improved queue allocation API")

Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
---
 tools/virtio/virtio_test.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/tools/virtio/virtio_test.c b/tools/virtio/virtio_test.c
index 6bc3e172cc9b..0a247ba3b899 100644
--- a/tools/virtio/virtio_test.c
+++ b/tools/virtio/virtio_test.c
@@ -105,10 +105,9 @@ static void vq_info_add(struct vdev_info *dev, int n=
um)
 	assert(r >=3D 0);
 	memset(info->ring, 0, vring_size(num, 4096));
 	vring_init(&info->vring, num, info->ring, 4096);
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

