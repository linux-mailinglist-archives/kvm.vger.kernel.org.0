Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55DDB408561
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 09:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237636AbhIMHbx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 03:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237561AbhIMHbw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 03:31:52 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7313BC061574
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 00:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=cJ1ZxhFtsLsKOPHRjiYAbO7o1k/MNWsHvtOV8/xlbvM=; b=QMXKwY6PvrV/E+8zvhnrn7jyWG
        tYd9VtUowc1yZm+sx3LmUCXOe+/I5KxfvFTvpQRHsEkEfKcSzsykABd183kSFo9PvCJvhTuVK4AIU
        vkkdNaN6zDQRXqLEGI7PttqJt7uGRoRLqy0H5fxwudzF9oqazecyZu9jw83LOwbA4de1XjVwK/OBH
        pFRZXxEj3rAC7gcR042ZnP8wKFWqZIVqVhkbQUNfe4OiaVP+vwAk5ypC09sqnJ5uCYAGM5IiOLaS3
        L2YtxGQksFV6/rS7y+dym5gxDg49xr/WkI/Q/z5QsngPYqIZn63JIyKrCzq2oYbXBRUavSMnJgiUr
        rzKKp9xQ==;
Received: from 213-225-6-64.nat.highway.a1.net ([213.225.6.64] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mPgOG-00DGo3-Eu; Mon, 13 Sep 2021 07:28:40 +0000
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
Subject: [PATCH 12/14] vfio/spapr_tce: reject mediated devices
Date:   Mon, 13 Sep 2021 09:16:04 +0200
Message-Id: <20210913071606.2966-13-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913071606.2966-1-hch@lst.de>
References: <20210913071606.2966-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Unlike the the type1 IOMMU backend, the SPAPR one does not contain any
support for the magic non-IOMMU backed iommu_group used by mediated
devices, so reject them in ->attach_group.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 drivers/vfio/vfio_iommu_spapr_tce.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
index 936a26b13c0b01..708a95e618310c 100644
--- a/drivers/vfio/vfio_iommu_spapr_tce.c
+++ b/drivers/vfio/vfio_iommu_spapr_tce.c
@@ -1246,6 +1246,9 @@ static int tce_iommu_attach_group(void *iommu_data,
 	struct iommu_table_group *table_group;
 	struct tce_iommu_group *tcegrp = NULL;
 
+	if (type == VFIO_EMULATED_IOMMU)
+		return -EINVAL;
+
 	mutex_lock(&container->lock);
 
 	/* pr_debug("tce_vfio: Attaching group #%u to iommu %p\n",
-- 
2.30.2

