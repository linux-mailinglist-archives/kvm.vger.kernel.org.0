Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A637196CFF
	for <lists+kvm@lfdr.de>; Sun, 29 Mar 2020 13:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbgC2Leb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Mar 2020 07:34:31 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:26197 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727772AbgC2Le1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 29 Mar 2020 07:34:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585481666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gyk3XBFVNqrZeb6Db2CN+XT0HUnMRWoYG+qv7WrVWPw=;
        b=MfzrGzdt9ZVapkYzxtWHukhpQ2h1eFX8ijgjHvGuNgZS+PJIsDhUEaP8qY4Z08XtzAtf/s
        pjEoWSfVu1cSXoyn8gCb6RdNn0fDGOTCm5a+tYi0K9UPEI6z9W8Y0BypmEdCop+Nq6A4Jv
        T1pdIPp13hzVB0kmGW74JzBXGXYk2ts=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-388-f5uRcixoOLCY9BFlzu3tew-1; Sun, 29 Mar 2020 07:34:22 -0400
X-MC-Unique: f5uRcixoOLCY9BFlzu3tew-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0F61B13FE;
        Sun, 29 Mar 2020 11:34:21 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-112-95.ams2.redhat.com [10.36.112.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 295A45C1B5;
        Sun, 29 Mar 2020 11:34:13 +0000 (UTC)
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
Subject: [PATCH 2/6] tools/virtio: Add --batch=random option
Date:   Sun, 29 Mar 2020 13:33:55 +0200
Message-Id: <20200329113359.30960-3-eperezma@redhat.com>
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

So we can test with non-deterministic batches in flight.

Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
---
 tools/virtio/virtio_test.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/tools/virtio/virtio_test.c b/tools/virtio/virtio_test.c
index c30de9088f3c..b0dd73db5cbf 100644
--- a/tools/virtio/virtio_test.c
+++ b/tools/virtio/virtio_test.c
@@ -19,6 +19,8 @@
 #include <linux/virtio_ring.h>
 #include "../../drivers/vhost/test.h"
=20
+#define RANDOM_BATCH -1
+
 /* Unused */
 void *__kmalloc_fake, *__kfree_ignore_start, *__kfree_ignore_end;
=20
@@ -161,6 +163,7 @@ static void run_test(struct vdev_info *dev, struct vq=
_info *vq,
 	int r, test =3D 1;
 	unsigned len;
 	long long spurious =3D 0;
+	const bool random_batch =3D batch =3D=3D RANDOM_BATCH;
 	r =3D ioctl(dev->control, VHOST_TEST_RUN, &test);
 	assert(r >=3D 0);
 	for (;;) {
@@ -168,6 +171,10 @@ static void run_test(struct vdev_info *dev, struct v=
q_info *vq,
 		completed_before =3D completed;
 		started_before =3D started;
 		do {
+			const bool reset =3D reset_n && completed > next_reset;
+			if (random_batch)
+				batch =3D (random() % vq->vring.num) + 1;
+
 			while (started < bufs &&
 			       (started - completed) < batch) {
 				sg_init_one(&sl, dev->buf, dev->buf_size);
@@ -275,7 +282,7 @@ static void help(void)
 		" [--no-event-idx]"
 		" [--no-virtio-1]"
 		" [--delayed-interrupt]"
-		" [--batch=3DN]"
+		" [--batch=3Drandom/N]"
 		"\n");
 }
=20
@@ -312,9 +319,13 @@ int main(int argc, char **argv)
 			delayed =3D true;
 			break;
 		case 'b':
-			batch =3D strtol(optarg, NULL, 10);
-			assert(batch > 0);
-			assert(batch < (long)INT_MAX + 1);
+			if (0 =3D=3D strcmp(optarg, "random")) {
+				batch =3D RANDOM_BATCH;
+			} else {
+				batch =3D strtol(optarg, NULL, 10);
+				assert(batch > 0);
+				assert(batch < (long)INT_MAX + 1);
+			}
 			break;
 		default:
 			assert(0);
--=20
2.18.1

