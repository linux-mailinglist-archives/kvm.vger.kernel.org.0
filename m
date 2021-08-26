Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B81313F891F
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 15:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241040AbhHZNkB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 09:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231371AbhHZNjz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 09:39:55 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB99C061757
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 06:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=eN/+KvzSZNvHy0+wq4CetUXHeTpEHLZMtI58VYyqtpM=; b=mXDTBFE2TFsD6Dxe1nuyiAoRim
        Nsu2dyPR9gYmoFGrb4UjrPm/T3hE9PGVbIL9BQBf3jbLWPS0sF3lCV3jtnZRAvnR/pSYKAkqRaE6M
        Si8pIV24ykwwlw1s0cOur4JKZdP7qhVGKWZq5U9fIuOuiyYDSh4k4uK8z6onzKv7blgEh2i5I2pHd
        GUld4qQlbdgFyfogeghAJEfVc8VIT7cEYA5D2DGeXLLsT/JoTp8Otfj1NKqjlQIJbAx7sp5fjfmsG
        Gf7U/htQX2ED/2lFODP0FXqlPutR85Nh7pFJ0iZcjy5317vhHwgjnu/xy0y1XTtR+VqkiRNM2TbjZ
        sUxSSD5Q==;
Received: from [2001:4bb8:193:fd10:d9d9:6c15:481b:99c4] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJFZ0-00DL3L-RK; Thu, 26 Aug 2021 13:37:15 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH 03/14] vfio: remove the iommudata check in vfio_noiommu_attach_group
Date:   Thu, 26 Aug 2021 15:34:13 +0200
Message-Id: <20210826133424.3362-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210826133424.3362-1-hch@lst.de>
References: <20210826133424.3362-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vfio_noiommu_attach_group has two callers:

 1) __vfio_container_attach_groups is called by vfio_ioctl_set_iommu,
    which just called vfio_iommu_driver_allowed
 2) vfio_group_set_container requires already checks ->noiommu on the
    vfio_group, which is propagated from the iommudata in
    vfio_create_group

so this check is entirely superflous and can be removed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 drivers/vfio/vfio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index e53756743f1b6a..18e4c7906d1b3f 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -240,7 +240,7 @@ static long vfio_noiommu_ioctl(void *iommu_data,
 static int vfio_noiommu_attach_group(void *iommu_data,
 				     struct iommu_group *iommu_group)
 {
-	return iommu_group_get_iommudata(iommu_group) == &noiommu ? 0 : -EINVAL;
+	return 0;
 }
 
 static void vfio_noiommu_detach_group(void *iommu_data,
-- 
2.30.2

