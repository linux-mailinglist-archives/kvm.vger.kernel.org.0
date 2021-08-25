Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 049603F7A79
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 18:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbhHYQ2I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 12:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbhHYQ2I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 12:28:08 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27B71C061757
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 09:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=vgsMfhKD9BQS5ViEn8Rk58kUuubwk+dGSv6sQWDQGqI=; b=jOL/4ENPWUpxh4oghb+85xsu3Y
        FQ48JiiROzhpo5kd91soknfnJhu/FddPHsf5hPIsQEtnRO4d2f7s3d+/Txlyz2YT38r6CFGwj25NE
        4E/tR5c8HojkMiX74j1v/aT/rckbGBNQAqFRnKsjOT9ajbf7jiVpTVd6NG2RbGg1hp5hqjGzwH+eF
        DVIXmEBEljDwLtZu/jHiF/wSzumMuNM6OWNkW1ms/fZrjSF0ylSmPoG6pXxx25PwkxqONuv7AuDXr
        tpEMqsoOvPg/L93DW5E4uS3WAp35mYAkodp7ZN+Q20F13XdasVEnCMJBkn7Tpk5vrgDwlPEYg3Wo0
        GrcJyXdQ==;
Received: from [2001:4bb8:193:fd10:a3f9:5689:21a4:711f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mIviJ-00CTBW-Gx; Wed, 25 Aug 2021 16:25:55 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 03/14] vfio: remove the iommudata check in vfio_noiommu_attach_group
Date:   Wed, 25 Aug 2021 18:19:04 +0200
Message-Id: <20210825161916.50393-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210825161916.50393-1-hch@lst.de>
References: <20210825161916.50393-1-hch@lst.de>
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

