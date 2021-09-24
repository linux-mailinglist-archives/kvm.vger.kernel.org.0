Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF85D417845
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 18:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347369AbhIXQOh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 12:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347349AbhIXQOd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 12:14:33 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03550C061571
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 09:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=eSAMvoEJbfMDB2IF4eZtXFWRM/PtkYX5QfAd7bvX4xk=; b=M/kN10HfOpzgRaWO7R+JqJX4xB
        QMouKZ7jkLBld9N3aeiqGgNJWLcIKzO3iVJHLtkgyEfGooCU8a5OerAwRIWQz7yOA7GCmXYm979Jf
        fFEa7suiMlHce51kDXiAwmB7g2EKNT79++G+fEqvBA/ijo9P3om5Ntd+hIM9eyC7rjfctC2pzoFbv
        wGblhoCW2E3gzzjCIab6TwDZb5b+zJUua79cG2PumYtNHk3sUSt/K23o3eKRvmog4I4mXrHl4VGWN
        mt1xcnKi6gKRx83hwPUhTs+oDQUR8UVVVUH/tla4Q9bZtuzsohfQKHB0u4afr/K0NC5HtXEWoR/nv
        rRGlz+CQ==;
Received: from [2001:4bb8:184:72db:e8f6:c47e:192b:5622] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mTnmH-007Nbp-96; Fri, 24 Sep 2021 16:10:37 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Terrence Xu <terrence.xu@intel.com>, kvm@vger.kernel.org
Subject: [PATCH 13/15] vfio/iommu_type1: initialize pgsize_bitmap in ->open
Date:   Fri, 24 Sep 2021 17:57:03 +0200
Message-Id: <20210924155705.4258-14-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210924155705.4258-1-hch@lst.de>
References: <20210924155705.4258-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ensure pgsize_bitmap is always valid by initializing it to ULONG_MAX
in vfio_iommu_type1_open and remove the now pointless update for
the external domain case in vfio_iommu_type1_attach_group, which was
just setting pgsize_bitmap to ULONG_MAX when only external domains
were attached.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/vfio/vfio_iommu_type1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index a48e9f597cb213..2c698e1a29a1d8 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2196,7 +2196,6 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 		if (!iommu->external_domain) {
 			INIT_LIST_HEAD(&domain->group_list);
 			iommu->external_domain = domain;
-			vfio_update_pgsize_bitmap(iommu);
 		} else {
 			kfree(domain);
 		}
@@ -2582,6 +2581,7 @@ static void *vfio_iommu_type1_open(unsigned long arg)
 	mutex_init(&iommu->lock);
 	BLOCKING_INIT_NOTIFIER_HEAD(&iommu->notifier);
 	init_waitqueue_head(&iommu->vaddr_wait);
+	iommu->pgsize_bitmap = ULONG_MAX;
 
 	return iommu;
 }
-- 
2.30.2

