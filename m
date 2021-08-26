Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFBC13F895A
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 15:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231875AbhHZNuE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 09:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbhHZNuD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 09:50:03 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A41C061757
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 06:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=wOMJ3wM1RSJrSJxQNcsqgw3rWyngt+Kpgr9OnhK8cA8=; b=MngNAAqbAjxMZphor/g0nf82Cf
        P6/k+D237HlxtVP0du5h3hkqMEwCRLcrV0Z5tU0PoPHcVQ4r0KWqtGMXAXwf0Az44FTw7DOMIBkNl
        6bW+WLFLlVinvpwWhEhslxedXenaSHg/uyRyoJRKJhi4F4Xw6LqSxZISvxUbNYwucWNFaqTs0lCKE
        iQM3xlEG6fyVSOg5cs+mVI+KNYH3jxRBEtEL9VB2/CGt2/JyR8Lz2AZ9+vrpzO7L3b4u+D6mdvtNO
        EXljD+R7DtH/zpBJE2TdHY8LGZFXkuTUsxLIRXpZxeFAmUA9avpOMVof4YS3MmMqkUf3pZRB/9lm0
        VvGukM6A==;
Received: from [2001:4bb8:193:fd10:d9d9:6c15:481b:99c4] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJFj2-00DLeX-Sv; Thu, 26 Aug 2021 13:47:34 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH 12/14] vfio/spapr_tce: reject mediated devices
Date:   Thu, 26 Aug 2021 15:34:22 +0200
Message-Id: <20210826133424.3362-13-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210826133424.3362-1-hch@lst.de>
References: <20210826133424.3362-1-hch@lst.de>
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
index 7567328d347d25..0fbce1bcb6493b 100644
--- a/drivers/vfio/vfio_iommu_spapr_tce.c
+++ b/drivers/vfio/vfio_iommu_spapr_tce.c
@@ -1246,6 +1246,9 @@ static int tce_iommu_attach_group(void *iommu_data,
 	struct iommu_table_group *table_group;
 	struct tce_iommu_group *tcegrp = NULL;
 
+	if (flags & VFIO_EMULATED_IOMMU)
+		return -EINVAL;
+
 	mutex_lock(&container->lock);
 
 	/* pr_debug("tce_vfio: Attaching group #%u to iommu %p\n",
-- 
2.30.2

