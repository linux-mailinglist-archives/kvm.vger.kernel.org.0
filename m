Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84A6430FA23
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 18:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238678AbhBDRrH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 12:47:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58353 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238156AbhBDRZB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Feb 2021 12:25:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612459409;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hgTkIqcV2QARSGi+NWdgeQuWmRUNa3RAFDdhKKRVfbE=;
        b=hHyvaAg9OU/0wCccSi1db5xgk6FkofDpKY3/NjdD5tvvgd/OoNzuOzbnUlIPl5tAFY3tv/
        WOvU8qSH0S970i+Ij6szeTMk3Y/ohW2jnTSV5zq+kP3tTHM7VtTbsW8nJGLZpP9q6jPfVt
        eEw0OpgWOVcGfJ9D/1Z4NH6az371uOE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-b_CJKPpVNRetDV9O_mSYRg-1; Thu, 04 Feb 2021 12:23:25 -0500
X-MC-Unique: b_CJKPpVNRetDV9O_mSYRg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4B8F81800D41;
        Thu,  4 Feb 2021 17:23:24 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-213.ams2.redhat.com [10.36.113.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2BEB160937;
        Thu,  4 Feb 2021 17:23:22 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        Xie Yongji <xieyongji@bytedance.com>, kvm@vger.kernel.org,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH v3 07/13] vdpa_sim: cleanup kiovs in vdpasim_free()
Date:   Thu,  4 Feb 2021 18:22:24 +0100
Message-Id: <20210204172230.85853-8-sgarzare@redhat.com>
In-Reply-To: <20210204172230.85853-1-sgarzare@redhat.com>
References: <20210204172230.85853-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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

