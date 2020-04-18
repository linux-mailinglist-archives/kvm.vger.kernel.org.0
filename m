Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32CAB1AEBC2
	for <lists+kvm@lfdr.de>; Sat, 18 Apr 2020 12:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgDRKYn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Apr 2020 06:24:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57812 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725983AbgDRKWl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Apr 2020 06:22:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587205359;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BDGQ+vnTVFGn9TVgolSt1bfIz8O9bB41pVMjf36t0iE=;
        b=C9lLh2lLLVNFR87W/yps7ocj0sR9uqrqdimw6olXP6XjHa/HlJ9tMyGYsFGLJX2KJOMKyr
        5urDphIqUXbXibeC8PeTTQJ54yroK77KdVOVquHI6q6XTNPe+JXggHnpvjjUZyhBUZyewU
        j7AJxl9mxdUpzAQGKFxuTLax6sC//yo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-177-C5AFofX2OT-XupaHthE7JA-1; Sat, 18 Apr 2020 06:22:35 -0400
X-MC-Unique: C5AFofX2OT-XupaHthE7JA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D43B8017F6;
        Sat, 18 Apr 2020 10:22:34 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-112-94.ams2.redhat.com [10.36.112.94])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B6A101036D1B;
        Sat, 18 Apr 2020 10:22:29 +0000 (UTC)
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
Subject: [PATCH v3 2/8] tools/virtio: Add --batch option
Date:   Sat, 18 Apr 2020 12:22:11 +0200
Message-Id: <20200418102217.32327-3-eperezma@redhat.com>
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

This allow to test vhost having >1 buffers in flight

Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
Link: https://lore.kernel.org/r/20200401183118.8334-5-eperezma@redhat.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 tools/virtio/virtio_test.c | 47 ++++++++++++++++++++++++++++++--------
 1 file changed, 37 insertions(+), 10 deletions(-)

diff --git a/tools/virtio/virtio_test.c b/tools/virtio/virtio_test.c
index b427def67e7e..c30de9088f3c 100644
--- a/tools/virtio/virtio_test.c
+++ b/tools/virtio/virtio_test.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #define _GNU_SOURCE
 #include <getopt.h>
+#include <limits.h>
 #include <string.h>
 #include <poll.h>
 #include <sys/eventfd.h>
@@ -152,11 +153,11 @@ static void wait_for_interrupt(struct vdev_info *de=
v)
 }
=20
 static void run_test(struct vdev_info *dev, struct vq_info *vq,
-		     bool delayed, int bufs)
+		     bool delayed, int batch, int bufs)
 {
 	struct scatterlist sl;
 	long started =3D 0, completed =3D 0;
-	long completed_before;
+	long completed_before, started_before;
 	int r, test =3D 1;
 	unsigned len;
 	long long spurious =3D 0;
@@ -165,28 +166,42 @@ static void run_test(struct vdev_info *dev, struct =
vq_info *vq,
 	for (;;) {
 		virtqueue_disable_cb(vq->vq);
 		completed_before =3D completed;
+		started_before =3D started;
 		do {
-			if (started < bufs) {
+			while (started < bufs &&
+			       (started - completed) < batch) {
 				sg_init_one(&sl, dev->buf, dev->buf_size);
 				r =3D virtqueue_add_outbuf(vq->vq, &sl, 1,
 							 dev->buf + started,
 							 GFP_ATOMIC);
-				if (likely(r =3D=3D 0)) {
-					++started;
-					if (unlikely(!virtqueue_kick(vq->vq)))
+				if (unlikely(r !=3D 0)) {
+					if (r =3D=3D -ENOSPC &&
+					    started > started_before)
+						r =3D 0;
+					else
 						r =3D -1;
+					break;
 				}
-			} else
+
+				++started;
+
+				if (unlikely(!virtqueue_kick(vq->vq))) {
+					r =3D -1;
+					break;
+				}
+			}
+
+			if (started >=3D bufs)
 				r =3D -1;
=20
 			/* Flush out completed bufs if any */
-			if (virtqueue_get_buf(vq->vq, &len)) {
+			while (virtqueue_get_buf(vq->vq, &len)) {
 				++completed;
 				r =3D 0;
 			}
=20
 		} while (r =3D=3D 0);
-		if (completed =3D=3D completed_before)
+		if (completed =3D=3D completed_before && started =3D=3D started_before=
)
 			++spurious;
 		assert(completed <=3D bufs);
 		assert(started <=3D bufs);
@@ -244,6 +259,11 @@ const struct option longopts[] =3D {
 		.name =3D "no-delayed-interrupt",
 		.val =3D 'd',
 	},
+	{
+		.name =3D "batch",
+		.val =3D 'b',
+		.has_arg =3D required_argument,
+	},
 	{
 	}
 };
@@ -255,6 +275,7 @@ static void help(void)
 		" [--no-event-idx]"
 		" [--no-virtio-1]"
 		" [--delayed-interrupt]"
+		" [--batch=3DN]"
 		"\n");
 }
=20
@@ -263,6 +284,7 @@ int main(int argc, char **argv)
 	struct vdev_info dev;
 	unsigned long long features =3D (1ULL << VIRTIO_RING_F_INDIRECT_DESC) |
 		(1ULL << VIRTIO_RING_F_EVENT_IDX) | (1ULL << VIRTIO_F_VERSION_1);
+	long batch =3D 1;
 	int o;
 	bool delayed =3D false;
=20
@@ -289,6 +311,11 @@ int main(int argc, char **argv)
 		case 'D':
 			delayed =3D true;
 			break;
+		case 'b':
+			batch =3D strtol(optarg, NULL, 10);
+			assert(batch > 0);
+			assert(batch < (long)INT_MAX + 1);
+			break;
 		default:
 			assert(0);
 			break;
@@ -298,6 +325,6 @@ int main(int argc, char **argv)
 done:
 	vdev_info_init(&dev, features);
 	vq_info_add(&dev, 256);
-	run_test(&dev, &dev.vqs[0], delayed, 0x100000);
+	run_test(&dev, &dev.vqs[0], delayed, batch, 0x100000);
 	return 0;
 }
--=20
2.18.1

