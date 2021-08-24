Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4D63F60F8
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 16:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237972AbhHXOxe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 10:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237582AbhHXOxe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 10:53:34 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD04AC061757
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 07:52:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=U8V/R5gY8lltv5RvWYC6boW0jKSCqAJ0HwM73NAh9F4=; b=GDuY+qAy2/So1YNSvtK96F4vEE
        ltsk7k+2qcgkW2tZkR6rNOEhddzXYoh6ilzzLvO323l0sg9VlOsceBc7bUH5bxthsXxfGVnB9H6NN
        SvWGa81ngJiY+V56g/mjhiedpnNNkXI/SPK5R5U9N7PLD3dAZ5oNseoVKVGqOO3W+RZJxdP1qDiH2
        SwV1spvNM1UVGVfRbctawsu11ErDFz9li2hcz7NPOZfSZJFGtDVEZDngd8Dmlx2sZ3eWEjh9yHZps
        TAUPtJnL/V0hc3rVXs+IDsVExrvwUMflr0721y/jyxXLNHVpbqXNJHTKrmbwnTa3IF6t463ygY0dS
        Qwexg1Rw==;
Received: from [2001:4bb8:193:fd10:b8ba:7bad:652e:75fa] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mIXlW-00BCBj-Qd; Tue, 24 Aug 2021 14:51:23 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org
Subject: [PATCH 03/14] vfio: remove the iommudata check in vfio_noiommu_attach_group
Date:   Tue, 24 Aug 2021 16:46:38 +0200
Message-Id: <20210824144649.1488190-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824144649.1488190-1-hch@lst.de>
References: <20210824144649.1488190-1-hch@lst.de>
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

