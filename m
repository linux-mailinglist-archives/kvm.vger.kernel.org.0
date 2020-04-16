Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83ADC1ABA93
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 09:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440875AbgDPH6K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 03:58:10 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:45820 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2439911AbgDPH5S (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Apr 2020 03:57:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587023837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bdhOBCEl4eFdpUqKoAGyqIbQDwv6pzTPA4cNsDQtl/I=;
        b=AaSOw14XwCg/BlhRgsJ3uVtEfBSLw+rFa/fDuF8pge/afty9J/Ey48Cp9IV8DQ/2OXQrI6
        9T8nQo9wI+ND0rkQxl5NeuKoU8UOd2QTRMQsFccoKVAzWfS+F9Lzq7EzvRNutS50a0fx7y
        rsA5oZqJwWTrKkc/x74/32bzk/YzWI8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288-6j42YKquNzOJyXnjBZ3A_A-1; Thu, 16 Apr 2020 03:57:15 -0400
X-MC-Unique: 6j42YKquNzOJyXnjBZ3A_A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89DE91005509;
        Thu, 16 Apr 2020 07:57:14 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-112-194.ams2.redhat.com [10.36.112.194])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2D4817E7C0;
        Thu, 16 Apr 2020 07:57:11 +0000 (UTC)
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
Subject: [PATCH v2 7/8] tools/virtio: Reset index in virtio_test --reset.
Date:   Thu, 16 Apr 2020 09:56:42 +0200
Message-Id: <20200416075643.27330-8-eperezma@redhat.com>
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

This way behavior for vhost is more like a VM.

Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
---
 tools/virtio/virtio_test.c | 33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/tools/virtio/virtio_test.c b/tools/virtio/virtio_test.c
index 18d5347003eb..dca64d36a882 100644
--- a/tools/virtio/virtio_test.c
+++ b/tools/virtio/virtio_test.c
@@ -20,7 +20,6 @@
 #include "../../drivers/vhost/test.h"
=20
 #define RANDOM_BATCH -1
-#define RANDOM_RESET -1
=20
 /* Unused */
 void *__kmalloc_fake, *__kfree_ignore_start, *__kfree_ignore_end;
@@ -49,6 +48,7 @@ struct vdev_info {
=20
 static const struct vhost_vring_file no_backend =3D { .fd =3D -1 },
 				     backend =3D { .fd =3D 1 };
+static const struct vhost_vring_state null_state =3D {};
=20
 bool vq_notify(struct virtqueue *vq)
 {
@@ -174,14 +174,19 @@ static void run_test(struct vdev_info *dev, struct =
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
@@ -224,10 +229,24 @@ static void run_test(struct vdev_info *dev, struct =
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
@@ -249,7 +268,9 @@ static void run_test(struct vdev_info *dev, struct vq=
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
@@ -312,7 +333,7 @@ static void help(void)
 		" [--no-virtio-1]"
 		" [--delayed-interrupt]"
 		" [--batch=3Drandom/N]"
-		" [--reset=3Drandom/N]"
+		" [--reset=3DN]"
 		"\n");
 }
=20
@@ -360,11 +381,9 @@ int main(int argc, char **argv)
 		case 'r':
 			if (!optarg) {
 				reset =3D 1;
-			} else if (0 =3D=3D strcmp(optarg, "random")) {
-				reset =3D RANDOM_RESET;
 			} else {
 				reset =3D strtol(optarg, NULL, 10);
-				assert(reset >=3D 0);
+				assert(reset > 0);
 				assert(reset < (long)INT_MAX + 1);
 			}
 			break;
--=20
2.18.1

