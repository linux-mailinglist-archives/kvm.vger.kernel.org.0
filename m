Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1AE0307873
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 15:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231803AbhA1Oo1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 09:44:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53423 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231877AbhA1OoF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Jan 2021 09:44:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611844958;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g3g1OmTgyQKpO44PG/KohyJWQoMIoCRfwQDA6iGRUjI=;
        b=CvebcFefNLFNjw6t4rklmexZYNBq6MMnAtGka1JADuz6mR9IZfPxXhApbNVhwNglBO6Qc+
        3tSltNROupVylicdoLa/JOg+vFrOxrWPNGkePZgIddXl3yXtFb04iHwiEejEal61vV1DLn
        Wpxfnsu2JzLBBFdxHMEAN+snarDz33o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-eVSp1GIAMzW-og4lhkqnbw-1; Thu, 28 Jan 2021 09:42:36 -0500
X-MC-Unique: eVSp1GIAMzW-og4lhkqnbw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 45580107ACF5;
        Thu, 28 Jan 2021 14:42:35 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-219.ams2.redhat.com [10.36.113.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A45D06267D;
        Thu, 28 Jan 2021 14:42:29 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     Xie Yongji <xieyongji@bytedance.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH RFC v2 06/10] vdpa_sim: cleanup kiovs in vdpasim_free()
Date:   Thu, 28 Jan 2021 15:41:23 +0100
Message-Id: <20210128144127.113245-7-sgarzare@redhat.com>
In-Reply-To: <20210128144127.113245-1-sgarzare@redhat.com>
References: <20210128144127.113245-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vringh_getdesc_iotlb() allocates memory to store the kvec, that
is freed with vringh_kiov_cleanup().

vringh_getdesc_iotlb() is able to reuse a kvec previously allocated,
so in order to avoid to allocate the kvec for each request, we are
not calling vringh_kiov_cleanup() when we finished to handle a
request, but we should call it when we free the entire device.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index 53238989713d..a7aeb5d01c3e 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -562,8 +562,15 @@ static int vdpasim_dma_unmap(struct vdpa_device *vdpa, u64 iova, u64 size)
 static void vdpasim_free(struct vdpa_device *vdpa)
 {
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
+	int i;
 
 	cancel_work_sync(&vdpasim->work);
+
+	for (i = 0; i < vdpasim->dev_attr.nvqs; i++) {
+		vringh_kiov_cleanup(&vdpasim->vqs[i].out_iov);
+		vringh_kiov_cleanup(&vdpasim->vqs[i].in_iov);
+	}
+
 	put_iova_domain(&vdpasim->iova);
 	iova_cache_put();
 	kvfree(vdpasim->buffer);
-- 
2.29.2

