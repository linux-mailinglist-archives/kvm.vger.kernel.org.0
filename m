Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F583196CF9
	for <lists+kvm@lfdr.de>; Sun, 29 Mar 2020 13:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728120AbgC2LeU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Mar 2020 07:34:20 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:45225 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728113AbgC2LeT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 29 Mar 2020 07:34:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585481658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FFJYGGwUu9B8h+W1ItcNL0y6xF04SMRsuHG1jktXLH4=;
        b=PLtrQ8uziCAMWyeHZXbg7QetMFztB8/Sl/A6hFeoXqF6DOkpUgPh4OmsPYzrjAyfTwY+pE
        ok+0qaO+Sc5kUYOWrA5Ucc+MLJjtm3kqenqJYAGmc57TZX+32T/mv5UWllrrY0mWvUvEkZ
        0Z8tEs4JoVL6VOkRuws5/IgINCrkEeA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-swojiZ69Pxe0wVSPYtiZMg-1; Sun, 29 Mar 2020 07:34:14 -0400
X-MC-Unique: swojiZ69Pxe0wVSPYtiZMg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E0EA107ACC9;
        Sun, 29 Mar 2020 11:34:13 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-112-95.ams2.redhat.com [10.36.112.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 857725C1BE;
        Sun, 29 Mar 2020 11:34:10 +0000 (UTC)
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
Subject: [PATCH 1/6] tools/virtio: Add --batch option
Date:   Sun, 29 Mar 2020 13:33:54 +0200
Message-Id: <20200329113359.30960-2-eperezma@redhat.com>
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

This allow to test vhost having >1 buffers in flight

Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
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

