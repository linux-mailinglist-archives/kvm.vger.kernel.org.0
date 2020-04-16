Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9031C1ABA86
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 09:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440867AbgDPH5T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 03:57:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33765 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2439656AbgDPH5K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 03:57:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587023828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=idl26PH4x2DDa3aO5wcLhHmY07eZSjGnVzySfXlVtnM=;
        b=dI23tCu81lGatxoSU2aGVQsy8S/w+VoaULsHIlxGtpmEwKzLH9urzLnwoHd/CpIAQSdANf
        5HDBRoFZY+1XqR3eBDvMf3Z94TkrLURSAPHcAajqf8gPAK9mKFQxgYEsJJUbEkHH82ezxJ
        kATphb3TXdCZDIOMt9U40nVCbVqOaq4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-488-1NCnUh1hM8KXoG3rcApRbA-1; Thu, 16 Apr 2020 03:57:05 -0400
X-MC-Unique: 1NCnUh1hM8KXoG3rcApRbA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 988288024D6;
        Thu, 16 Apr 2020 07:57:03 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-112-194.ams2.redhat.com [10.36.112.194])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 33E8B7E7C0;
        Thu, 16 Apr 2020 07:57:01 +0000 (UTC)
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
Subject: [PATCH v2 4/8] vhost: Fix bad order in vhost_test_set_backend at enable
Date:   Thu, 16 Apr 2020 09:56:39 +0200
Message-Id: <20200416075643.27330-5-eperezma@redhat.com>
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

The reset was not done properly: A init call was given with no active
backend. This solves that.

Fixes: ("7c48601a3d4d tools/virtio: Add --reset=3Drandom")

Signed-off-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
---
 drivers/vhost/test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index 789c096e454b..6aed0cab8b17 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -293,8 +293,8 @@ static long vhost_test_set_backend(struct vhost_test =
*n, unsigned index, int fd)
 		backend =3D vhost_vq_get_backend(vq);
 		vhost_vq_set_backend(vq, NULL);
 	} else {
-		r =3D vhost_vq_init_access(vq);
 		vhost_vq_set_backend(vq, backend);
+		r =3D vhost_vq_init_access(vq);
 		if (r =3D=3D 0)
 			r =3D vhost_poll_start(&vq->poll, vq->kick);
 	}
--=20
2.18.1

