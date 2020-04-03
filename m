Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E534819DC14
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 18:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404632AbgDCQvx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 12:51:53 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30134 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2404628AbgDCQvx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Apr 2020 12:51:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585932712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=X2YzNwxGjX7RUhG5xjgh2bTQxpqtEuU8/vbNLpGIK/g=;
        b=QrzQqfnJv5fA715dt86lvJaMgkn/mrTYiNetcwvHgBJrIV7GtAkcvKolrXoXy48yY+4na7
        2s0YHJRMlMsZATy1EBnkjh/WR4QyFAb2xlG1LVbYbFX4Y1zKJWiN/p08RxRn5h+9QOavW8
        8H3vTrL/ICRyosfotzP9hAVVDONoBB8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-mnMUANtrPPeJ7OnLqubzmg-1; Fri, 03 Apr 2020 12:51:50 -0400
X-MC-Unique: mnMUANtrPPeJ7OnLqubzmg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 42B718017CE;
        Fri,  3 Apr 2020 16:51:49 +0000 (UTC)
Received: from eperezma.remote.csb (ovpn-113-28.ams2.redhat.com [10.36.113.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C8B0418A85;
        Fri,  3 Apr 2020 16:51:44 +0000 (UTC)
From:   =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 5/8] tools/virtio: Use __vring_new_virtqueue in virtio_test.c
Date:   Fri,  3 Apr 2020 18:51:16 +0200
Message-Id: <20200403165119.5030-6-eperezma@redhat.com>
In-Reply-To: <20200403165119.5030-1-eperezma@redhat.com>
References: <20200403165119.5030-1-eperezma@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As updated in 2a2d1382fe9d
---
 tools/virtio/virtio_test.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/tools/virtio/virtio_test.c b/tools/virtio/virtio_test.c
index 38aa5316b266..9b730434997c 100644
--- a/tools/virtio/virtio_test.c
+++ b/tools/virtio/virtio_test.c
@@ -106,10 +106,9 @@ static void vq_info_add(struct vdev_info *dev, int num)
 	assert(r >= 0);
 	memset(info->ring, 0, vring_size(num, 4096));
 	vring_init(&info->vring, num, info->ring, 4096);
-	info->vq = vring_new_virtqueue(info->idx,
-				       info->vring.num, 4096, &dev->vdev,
-				       true, false, info->ring,
-				       vq_notify, vq_callback, "test");
+	info->vq =
+		__vring_new_virtqueue(info->idx, info->vring, &dev->vdev, true,
+				      false, vq_notify, vq_callback, "test");
 	assert(info->vq);
 	info->vq->priv = info;
 	vhost_vq_setup(dev, info);
-- 
2.18.1

