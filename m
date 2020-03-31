Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB21199D8B
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 20:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbgCaSAk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 14:00:40 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:28064 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727902AbgCaSAj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 31 Mar 2020 14:00:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585677638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zxTOiAZFQUIPQ7LwD9H8y4khOH4iGHG3F8Nhf2kTwbA=;
        b=ZHkMM5bM084m4E5nAM5cNXejG69WMoxsv6zrRq1LozEGG6+ivk/jdpP0juhpokSuySqzgo
        xDxXBF087cmaujNKr3/i3DUuX6Zyw3WYvcgernVypnZDWHSRrFxvjOev+iCU3XczSebD36
        8jTrvi2BIjVYqVfZQJQ9g+QU/Jj0I8g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-225-llfWp3qSN2CoYNPvxaoU0g-1; Tue, 31 Mar 2020 14:00:36 -0400
X-MC-Unique: llfWp3qSN2CoYNPvxaoU0g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B1A7DB20;
        Tue, 31 Mar 2020 18:00:35 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-112-92.ams2.redhat.com [10.36.112.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9BBF898A55;
        Tue, 31 Mar 2020 18:00:29 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH v2 6/8] tools/virtio: Add --batch=random option
Date:   Tue, 31 Mar 2020 20:00:04 +0200
Message-Id: <20200331180006.25829-7-eperezma@redhat.com>
In-Reply-To: <20200331180006.25829-1-eperezma@redhat.com>
References: <20200331180006.25829-1-eperezma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

So we can test with non-deterministic batches in flight.

Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
---
 tools/virtio/virtio_test.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/tools/virtio/virtio_test.c b/tools/virtio/virtio_test.c
index c30de9088f3c..4a2b9d11f287 100644
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
@@ -168,6 +171,9 @@ static void run_test(struct vdev_info *dev, struct vq=
_info *vq,
 		completed_before =3D completed;
 		started_before =3D started;
 		do {
+			if (random_batch)
+				batch =3D (random() % vq->vring.num) + 1;
+
 			while (started < bufs &&
 			       (started - completed) < batch) {
 				sg_init_one(&sl, dev->buf, dev->buf_size);
@@ -275,7 +281,7 @@ static void help(void)
 		" [--no-event-idx]"
 		" [--no-virtio-1]"
 		" [--delayed-interrupt]"
-		" [--batch=3DN]"
+		" [--batch=3Drandom/N]"
 		"\n");
 }
=20
@@ -312,9 +318,13 @@ int main(int argc, char **argv)
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

