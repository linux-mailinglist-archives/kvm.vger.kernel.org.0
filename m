Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11A3630FA17
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 18:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238430AbhBDRZW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 12:25:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57119 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238487AbhBDRYq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Feb 2021 12:24:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612459400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g6wh1LMLhZTu6Il2A+W8xiD5xAyI/ci9mY9NolndzMM=;
        b=IkJVTg2b9Ba3hVbSIq5yvsmv6tIox2ai5btSOGFXokkjJwbA90+/fjCg3sYqxx7Bi7Lir2
        uZoOla2ohyFK5oicqQvw/8mzhVe0vyio1z0LUJk/9cKVOLDk2tIbTEIZEgkOgaGudbiOkX
        S+raRPF8B2erzEFlEH/4LpsMckViS+U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-502-8SAnTcfHMPiFLLJRk6Pj2A-1; Thu, 04 Feb 2021 12:23:18 -0500
X-MC-Unique: 8SAnTcfHMPiFLLJRk6Pj2A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 00370801965;
        Thu,  4 Feb 2021 17:23:17 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-213.ams2.redhat.com [10.36.113.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8F95060937;
        Thu,  4 Feb 2021 17:23:08 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        Xie Yongji <xieyongji@bytedance.com>, kvm@vger.kernel.org,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH v3 04/13] vringh: explain more about cleaning riov and wiov
Date:   Thu,  4 Feb 2021 18:22:21 +0100
Message-Id: <20210204172230.85853-5-sgarzare@redhat.com>
In-Reply-To: <20210204172230.85853-1-sgarzare@redhat.com>
References: <20210204172230.85853-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

riov and wiov can be reused with subsequent calls of vringh_getdesc_*().

Let's add a paragraph in the documentation of these functions to better
explain when riov and wiov need to be cleaned up.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vhost/vringh.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index bee63d68201a..2a88e087afd8 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -662,7 +662,10 @@ EXPORT_SYMBOL(vringh_init_user);
  * *head will be vrh->vring.num.  You may be able to ignore an invalid
  * descriptor, but there's not much you can do with an invalid ring.
  *
- * Note that you may need to clean up riov and wiov, even on error!
+ * Note that you can reuse riov and wiov with subsequent calls. Content is
+ * overwritten and memory reallocated if more space is needed.
+ * When you don't have to use riov and wiov anymore, you should clean up them
+ * calling vringh_iov_cleanup() to release the memory, even on error!
  */
 int vringh_getdesc_user(struct vringh *vrh,
 			struct vringh_iov *riov,
@@ -932,7 +935,10 @@ EXPORT_SYMBOL(vringh_init_kern);
  * *head will be vrh->vring.num.  You may be able to ignore an invalid
  * descriptor, but there's not much you can do with an invalid ring.
  *
- * Note that you may need to clean up riov and wiov, even on error!
+ * Note that you can reuse riov and wiov with subsequent calls. Content is
+ * overwritten and memory reallocated if more space is needed.
+ * When you don't have to use riov and wiov anymore, you should clean up them
+ * calling vringh_kiov_cleanup() to release the memory, even on error!
  */
 int vringh_getdesc_kern(struct vringh *vrh,
 			struct vringh_kiov *riov,
@@ -1292,7 +1298,10 @@ EXPORT_SYMBOL(vringh_set_iotlb);
  * *head will be vrh->vring.num.  You may be able to ignore an invalid
  * descriptor, but there's not much you can do with an invalid ring.
  *
- * Note that you may need to clean up riov and wiov, even on error!
+ * Note that you can reuse riov and wiov with subsequent calls. Content is
+ * overwritten and memory reallocated if more space is needed.
+ * When you don't have to use riov and wiov anymore, you should clean up them
+ * calling vringh_kiov_cleanup() to release the memory, even on error!
  */
 int vringh_getdesc_iotlb(struct vringh *vrh,
 			 struct vringh_kiov *riov,
-- 
2.29.2

