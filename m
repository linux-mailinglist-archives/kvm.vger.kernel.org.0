Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48CFE3E946F
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 17:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232999AbhHKPUP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 11:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232791AbhHKPUO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Aug 2021 11:20:14 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C158FC061765
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 08:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=U8V/R5gY8lltv5RvWYC6boW0jKSCqAJ0HwM73NAh9F4=; b=Dtck4Qql28JYUBKCxivM9UPsPz
        XMHW4HB4Y5WDHSEPS7yUF/qvC1q5O8YrF3tieus9LDD7fGDE4zgtj7qBRoMxC7nmxNC26zZCBvqGr
        sK2N7TH7RGQwgmpPeUkCXgAzDjS4r53MJ9kVaJlNgfjEZvDQF/Wk71LHeDZ3Kz/kzH9DExEiJQsK5
        jlZ2K8zj2ffOIZ+nCfiBx8FEcGHaih/fKyOjYwmuEkZQoJRVzau8E91pE2yRguutZZkJnttmgbY4W
        hVnqNNr4YVQJeBkXjeMxa1OmOZ+xL1oLfGmwaqUOt7vA7cf31H6UbH/n6oPsZUTkeT9in+0Pbx4LZ
        CXzITCSA==;
Received: from [2001:4bb8:184:6215:ac7b:970b:bd9c:c36c] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mDpzN-00DYNV-SG; Wed, 11 Aug 2021 15:18:07 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org
Subject: [PATCH 03/14] vfio: remove the iommudata check in vfio_noiommu_attach_group
Date:   Wed, 11 Aug 2021 17:14:49 +0200
Message-Id: <20210811151500.2744-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210811151500.2744-1-hch@lst.de>
References: <20210811151500.2744-1-hch@lst.de>
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
---
 drivers/vfio/vfio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 6705349ed93378..00aeef5bb29abd 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -250,7 +250,7 @@ static long vfio_noiommu_ioctl(void *iommu_data,
 static int vfio_noiommu_attach_group(void *iommu_data,
 				     struct iommu_group *iommu_group)
 {
-	return iommu_group_get_iommudata(iommu_group) == &noiommu ? 0 : -EINVAL;
+	return 0;
 }
 
 static void vfio_noiommu_detach_group(void *iommu_data,
-- 
2.30.2

