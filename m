Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA93133C224
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 17:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbhCOQgT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 12:36:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50255 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232775AbhCOQft (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Mar 2021 12:35:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615826149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LWvD7piRcIEtTdvbzFeHb0ltjVOF/yZl48RApoWhQM0=;
        b=gMzTKK8PdfnH5AeAgA2fVIyib9+NDiTlZBYwwa+x4vcGtX3xh/0jbDeS4ZVaZQYaEuc/I9
        sLDwxlEMBrMgv6MA1lWeS/xSYbOAPkLPEL4PZmLjObtMQ89WL266JVWLXD7cPc+YkJYfAE
        F/DS2ZEXGqCq0l6+ubrwA/0E6lYp33A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-515-sVc_84YzO02y-b7S15pccQ-1; Mon, 15 Mar 2021 12:35:47 -0400
X-MC-Unique: sVc_84YzO02y-b7S15pccQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A03F5800C78;
        Mon, 15 Mar 2021 16:35:45 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-114-1.ams2.redhat.com [10.36.114.1])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4D8115B4A8;
        Mon, 15 Mar 2021 16:35:43 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     netdev@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        Jason Wang <jasowang@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v4 07/14] vdpa_sim: cleanup kiovs in vdpasim_free()
Date:   Mon, 15 Mar 2021 17:34:43 +0100
Message-Id: <20210315163450.254396-8-sgarzare@redhat.com>
In-Reply-To: <20210315163450.254396-1-sgarzare@redhat.com>
References: <20210315163450.254396-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vringh_getdesc_iotlb() allocates memory to store the kvec, that
is freed with vringh_kiov_cleanup().

vringh_getdesc_iotlb() is able to reuse a kvec previously allocated,
so in order to avoid to allocate the kvec for each request, we are
not calling vringh_kiov_cleanup() when we finished to handle a
request, but we should call it when we free the entire device.

Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index a92c08880098..14dc2d3d983e 100644
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
2.30.2

