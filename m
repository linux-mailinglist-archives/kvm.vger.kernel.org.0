Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE76E417837
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 18:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347310AbhIXQM6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 12:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347304AbhIXQM4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 12:12:56 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE4F4C061571
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 09:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=cJ1ZxhFtsLsKOPHRjiYAbO7o1k/MNWsHvtOV8/xlbvM=; b=C4WYRW/DuSr1eG15pxP8Fz3arq
        ar116C2cX0wZ9Y14j/sTXEwRHse87hpamrIgdKIHfuFRMk45Q++nu4ipz0A6p+Le7KR1KLV0Qoq1O
        RTBmm/1FMPiIo49fA4ZiYNkljZN+Bk7GLahoC0JO2yfXo2ghrXQf3qciX/4RHEvg5mL3V3P14P8pw
        cGCSs4FIHaAUQckdLHonAs7Um6YgZua9SEp7UTFZH2rsfgyjZ/EdunoYj8kMdsyLDc/5KH/z4DcSp
        SFNJtkOaAP3b6qE5l/7VASRn0dktTatpwWrtjuL/nTmPTQRM4qVtnOz5qXFYHNK/QXDnJ93MU8ACD
        z+lky14A==;
Received: from [2001:4bb8:184:72db:e8f6:c47e:192b:5622] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mTnlX-007NZX-7r; Fri, 24 Sep 2021 16:09:44 +0000
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
Subject: [PATCH 12/15] vfio/spapr_tce: reject mediated devices
Date:   Fri, 24 Sep 2021 17:57:02 +0200
Message-Id: <20210924155705.4258-13-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210924155705.4258-1-hch@lst.de>
References: <20210924155705.4258-1-hch@lst.de>
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

