Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 723DA3F613C
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 17:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237998AbhHXPEw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 11:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237850AbhHXPEv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 11:04:51 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E0DC061757
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 08:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=H6bc2DFw+iQkXXMDFqXtOFID3yuBeRaW+aZik5kBSoU=; b=uHC5mrIA49Z59G6SkGeJTzJ3Q4
        PkwtdYEFVm9hAQrIU4b5/7t4tsIMJeV1oEFKca9nF9tP97A14ixi8k/lqgUDngLALAp2MZqYf5MEh
        uh8lbZgeRgUWr03jcZRrVC9Lcci/FdHDSfbC+01g4faGdPoAfhpjN/TGVl+wkqpsi4o6BhmLBkqel
        B8Jl1k7jbI2ivxdQ7pVpzjMkS95Kkod8l97wV7c9P46e/WO+BmCBVZgO+pmP+UgQOUkQhRbDpwn9o
        o/e9Df8FoymIGDxBeNTfeVWSg2emMY+QpLJ/Xga5wYl/hSlkUfAhMengk+UGkTCdD6T2Fb28we8b8
        4PPUdWtA==;
Received: from [2001:4bb8:193:fd10:b8ba:7bad:652e:75fa] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mIXwj-00BCog-BJ; Tue, 24 Aug 2021 15:03:00 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org
Subject: [PATCH 12/14] vfio/spapr_tce: reject mediated devices
Date:   Tue, 24 Aug 2021 16:46:47 +0200
Message-Id: <20210824144649.1488190-13-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824144649.1488190-1-hch@lst.de>
References: <20210824144649.1488190-1-hch@lst.de>
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
---
 drivers/vfio/vfio_iommu_spapr_tce.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
index 7567328d347d25..779d4e985d825f 100644
--- a/drivers/vfio/vfio_iommu_spapr_tce.c
+++ b/drivers/vfio/vfio_iommu_spapr_tce.c
@@ -1246,6 +1246,9 @@ static int tce_iommu_attach_group(void *iommu_data,
 	struct iommu_table_group *table_group;
 	struct tce_iommu_group *tcegrp = NULL;
 
+	if (flags & VFIO_MEDIATED)
+		return -EINVAL;
+
 	mutex_lock(&container->lock);
 
 	/* pr_debug("tce_vfio: Attaching group #%u to iommu %p\n",
-- 
2.30.2

