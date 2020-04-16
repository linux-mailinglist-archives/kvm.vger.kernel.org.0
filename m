Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 161191ABA92
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 09:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440848AbgDPH5P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 03:57:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25772 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2440794AbgDPH5F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 03:57:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587023823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J/bW9r45TOwsNmE8eTZdikVBjfTc4MSQA0VtKPvgd54=;
        b=ihOJa4RGup7av+25PmlIlPN5MpEn6vlDwpiIg6QPPStKpNGaU/ob+Uz8Ikmxj2x0MwFPKr
        rvnG+3XM2JHhTwOzJiQDfJB5MDlABthJtFUFiL1W/VO6JONnkLJmgT6/ep51c9snyGINyp
        LHzVTeDFeKFwIcJnyW65BkE4tNLolh0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-YgMnOMW2PYamKI8TvnTRkQ-1; Thu, 16 Apr 2020 03:57:02 -0400
X-MC-Unique: YgMnOMW2PYamKI8TvnTRkQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF545801E5E;
        Thu, 16 Apr 2020 07:57:00 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-112-194.ams2.redhat.com [10.36.112.194])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 726E17E7C0;
        Thu, 16 Apr 2020 07:56:58 +0000 (UTC)
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
Subject: [PATCH v2 3/8] vhost: Replace vq->private_data access by backend accesors
Date:   Thu, 16 Apr 2020 09:56:38 +0200
Message-Id: <20200416075643.27330-4-eperezma@redhat.com>
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

This function still places backend directly in private_data, instead of
use the accesors created on ("cbfc8f21b49a vhost: Create accessors for
virtqueues private_data"). Using accesor.

Fixes: ("7ce8cc28ce48 tools/virtio: Add --reset=3Drandom")

Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
---
 drivers/vhost/test.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index 251ca723ac3f..789c096e454b 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -265,7 +265,7 @@ static int vhost_test_set_features(struct vhost_test =
*n, u64 features)
=20
 static long vhost_test_set_backend(struct vhost_test *n, unsigned index,=
 int fd)
 {
-	static void *private_data;
+	static void *backend;
=20
 	const bool enable =3D fd !=3D -1;
 	struct vhost_virtqueue *vq;
@@ -290,11 +290,11 @@ static long vhost_test_set_backend(struct vhost_tes=
t *n, unsigned index, int fd)
 	}
 	if (!enable) {
 		vhost_poll_stop(&vq->poll);
-		private_data =3D vq->private_data;
-		vq->private_data =3D NULL;
+		backend =3D vhost_vq_get_backend(vq);
+		vhost_vq_set_backend(vq, NULL);
 	} else {
 		r =3D vhost_vq_init_access(vq);
-		vq->private_data =3D private_data;
+		vhost_vq_set_backend(vq, backend);
 		if (r =3D=3D 0)
 			r =3D vhost_poll_start(&vq->poll, vq->kick);
 	}
--=20
2.18.1

