Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FEA81AEBB6
	for <lists+kvm@lfdr.de>; Sat, 18 Apr 2020 12:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgDRKX4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Apr 2020 06:23:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43132 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726067AbgDRKW7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Apr 2020 06:22:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587205377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3lpbQnvyYAiZDMr8jgPD/xRUBOFhpQbJdeCf00ry9Oo=;
        b=ieJkVHnwQyaj5J283T/rDbzW8+s0NEX2nO9BckSnXIY0ldcHOkdZeDdJoSiaSprYrDhZ/D
        BfoGCRDkNgJ7yDxJvX6z79MLTogoUdxcNPzxGfdBpEPPse0mceogooekN7YX5mwUFe1dyN
        sQ6rMBVBzvilYbyyJKE0VatpvCloBUQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261-A_0BIWvgNwmlRfFa6cISHg-1; Sat, 18 Apr 2020 06:22:54 -0400
X-MC-Unique: A_0BIWvgNwmlRfFa6cISHg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C9CBA18B9FC1;
        Sat, 18 Apr 2020 10:22:52 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-112-94.ams2.redhat.com [10.36.112.94])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EE8581000325;
        Sat, 18 Apr 2020 10:22:47 +0000 (UTC)
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
Subject: [PATCH v3 7/8] tools/virtio: Reset index in virtio_test --reset.
Date:   Sat, 18 Apr 2020 12:22:16 +0200
Message-Id: <20200418102217.32327-8-eperezma@redhat.com>
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

This way behavior for vhost is more like a VM.

Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
---
 tools/virtio/virtio_test.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/tools/virtio/virtio_test.c b/tools/virtio/virtio_test.c
index bc16c818bda3..82902fc3ba2a 100644
--- a/tools/virtio/virtio_test.c
+++ b/tools/virtio/virtio_test.c
@@ -48,6 +48,7 @@ struct vdev_info {
=20
 static const struct vhost_vring_file no_backend =3D { .fd =3D -1 },
 				     backend =3D { .fd =3D 1 };
+static const struct vhost_vring_state null_state =3D {};
=20
 bool vq_notify(struct virtqueue *vq)
 {
@@ -173,14 +174,19 @@ static void run_test(struct vdev_info *dev, struct =
vq_info *vq,
 	unsigned len;
 	long long spurious =3D 0;
 	const bool random_batch =3D batch =3D=3D RANDOM_BATCH;
+
 	r =3D ioctl(dev->control, VHOST_TEST_RUN, &test);
 	assert(r >=3D 0);
+	if (!reset_n) {
+		next_reset =3D INT_MAX;
+	}
+
 	for (;;) {
 		virtqueue_disable_cb(vq->vq);
 		completed_before =3D completed;
 		started_before =3D started;
 		do {
-			const bool reset =3D reset_n && completed > next_reset;
+			const bool reset =3D completed > next_reset;
 			if (random_batch)
 				batch =3D (random() % vq->vring.num) + 1;
=20
@@ -223,10 +229,24 @@ static void run_test(struct vdev_info *dev, struct =
vq_info *vq,
 			}
=20
 			if (reset) {
+				struct vhost_vring_state s =3D { .index =3D 0 };
+
+				vq_reset(vq, vq->vring.num, &dev->vdev);
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
@@ -248,7 +268,9 @@ static void run_test(struct vdev_info *dev, struct vq=
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

