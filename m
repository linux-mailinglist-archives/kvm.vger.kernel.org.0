Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51A35408545
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 09:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237590AbhIMHXG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 03:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237554AbhIMHXG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 03:23:06 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C59C061574
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 00:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=u+Fwh3FY3v88AJUR/voPvS9eUvIwQdqL+LN9kAeUZgo=; b=erUTCWFjAELBHqqBTyv/CPuLSU
        puXzNJWXMwFuY3pAE0AOZLk4r6Aj/e1Nw9x0by1SMD0aIKu3gRg9e3Sbod+jWZxy5Ny3qGV0RYqgN
        RKTI51mVcz2HH7yxHZX6Y+4opylrZgsmHfOjzxeiQlRIbD/ip9JF8MHDic/kmEwC9sKO4tBGLT+9q
        b8kI5Umig0EtXQJ9ic686orl7x4pDdaRIF5ufRM/eHIoXmsJSv65/cNx62VTafZSFBP3Hcjm/PKL2
        sZsPKb1lqyzJhmJ6bVbUkBjNIW4Y66VhUxD4+e+X3EctYbKm2xMHjCQdbZwgk70vYJP8w/jNtQj71
        5GAFPCHw==;
Received: from 213-225-6-64.nat.highway.a1.net ([213.225.6.64] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mPgFr-00DGRY-Ho; Mon, 13 Sep 2021 07:20:09 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Terrence Xu <terrence.xu@intel.com>, kvm@vger.kernel.org,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH 03/14] vfio: remove the iommudata check in vfio_noiommu_attach_group
Date:   Mon, 13 Sep 2021 09:15:55 +0200
Message-Id: <20210913071606.2966-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913071606.2966-1-hch@lst.de>
References: <20210913071606.2966-1-hch@lst.de>
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
index faf8e0d637bb94..8bd4b0b96b94a3 100644
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

