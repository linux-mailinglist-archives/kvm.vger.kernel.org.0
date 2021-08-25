Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 203DA3F7AD4
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 18:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241646AbhHYQlE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 12:41:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237319AbhHYQlE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 12:41:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 410E7C061757
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 09:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=vCkH8llpWDueT5TLArkUVhiYLuQxLbYGiOucUBacphc=; b=Onlp8tSz8hwr79mCRv/5U1MYqO
        DTZeUjjwQNY/DQcafJrnsW+GVWQt5rIc1F6Ly+rpWSnhdQ/nvXcFSByGko7fwRRLRAaIQxO7ZBGG1
        Hcd/xJ3SgRm+dM5hXJ36FrqPpt3Stvzg5ZayXRaK0LvKKXC3RCN1XmzuyH+rWDF3JmT0SLVLqBa4a
        bSamVcZEbkEcd32YBtfiDzfEgmxBzi999UIUrubjSlteqPCp2OkCMjF85AXQg7Hyu3sSZEaCkEjF6
        mNS0VLKtSlvc3SUwryINC+cCkz5e7ebABD4Je61Qt8pdgtPzpD/hKmgQLlAwElsRBGUxETM/qfeUe
        /m67UW5g==;
Received: from [2001:4bb8:193:fd10:a3f9:5689:21a4:711f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mIvu3-00CTzj-TV; Wed, 25 Aug 2021 16:37:46 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 12/14] vfio/spapr_tce: reject mediated devices
Date:   Wed, 25 Aug 2021 18:19:13 +0200
Message-Id: <20210825161916.50393-13-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210825161916.50393-1-hch@lst.de>
References: <20210825161916.50393-1-hch@lst.de>
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

