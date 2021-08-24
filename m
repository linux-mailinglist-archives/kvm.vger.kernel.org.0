Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B612F3F6141
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 17:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238081AbhHXPGu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 11:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237966AbhHXPGt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 11:06:49 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A32CCC061757
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 08:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=1VNBK0D56SUo2dHkmlJ33YIGrsDG4gY27rkWRbTafAE=; b=q26kwGeqzNjnNyXMahBApnKGVg
        ZjxvJLdz/wy2Q7+ALiU9bZ/G8E23b+XcbqRCAm7hKp5IQsoCB8xISiPkhyfJHUDP6690xsn02eahB
        he3Fdv+hJUidR4GC+FDIJiJa5FC53/XhL0OgiBu38gp5TJOSfTwciWMfLIGBvFPvsMDEsdGmr7X2H
        Xa8vJpIredgrVxeCxUmsgY6r95tiOawsAYvple5Z7m3mKN4e5rJGvd2xnsk7xRFv1IcnkCAQwTuBG
        gmacVL29Re4qoTMvAsDLAOoezewKA2IVk6tbt0NtxhFIQ7wEeMjTqeqMtLf+PHhkj7woyFvTK8pYo
        GoEezaGw==;
Received: from [2001:4bb8:193:fd10:b8ba:7bad:652e:75fa] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mIXyW-00BCu1-Oh; Tue, 24 Aug 2021 15:04:39 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org
Subject: [PATCH 14/14] vfio/iommu_type1: remove IS_IOMMU_CAP_DOMAIN_IN_CONTAINER
Date:   Tue, 24 Aug 2021 16:46:49 +0200
Message-Id: <20210824144649.1488190-15-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824144649.1488190-1-hch@lst.de>
References: <20210824144649.1488190-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

IS_IOMMU_CAP_DOMAIN_IN_CONTAINER just obsfucated the checks being
performed, so open code it in the callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/vfio/vfio_iommu_type1.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 205f13c05b236e..42bd902243eca5 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -144,9 +144,6 @@ struct vfio_regions {
 	size_t len;
 };
 
-#define IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)	\
-					(!list_empty(&iommu->domain_list))
-
 #define DIRTY_BITMAP_BYTES(n)	(ALIGN(n, BITS_PER_TYPE(u64)) / BITS_PER_BYTE)
 
 /*
@@ -884,7 +881,7 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 	 * already pinned and accounted. Accounting should be done if there is no
 	 * iommu capable domain in the container.
 	 */
-	do_accounting = !IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu);
+	do_accounting = list_empty(&iommu->domain_list);
 
 	for (i = 0; i < npage; i++) {
 		struct vfio_pfn *vpfn;
@@ -973,7 +970,7 @@ static int vfio_iommu_type1_unpin_pages(void *iommu_data,
 
 	mutex_lock(&iommu->lock);
 
-	do_accounting = !IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu);
+	do_accounting = list_empty(&iommu->domain_list);
 	for (i = 0; i < npage; i++) {
 		struct vfio_dma *dma;
 		dma_addr_t iova;
@@ -1094,7 +1091,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
 	if (!dma->size)
 		return 0;
 
-	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu))
+	if (list_empty(&iommu->domain_list))
 		return 0;
 
 	/*
@@ -1671,7 +1668,7 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	vfio_link_dma(iommu, dma);
 
 	/* Don't pin and map if container doesn't contain IOMMU capable domain*/
-	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu))
+	if (list_empty(&iommu->domain_list))
 		dma->size = size;
 	else
 		ret = vfio_pin_map_dma(iommu, dma, size);
@@ -2477,7 +2474,7 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 		kfree(group);
 
 		if (list_empty(&iommu->mediated_groups) &&
-		    !IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
+		    list_empty(&iommu->domain_list)) {
 			WARN_ON(iommu->notifier.head);
 			vfio_iommu_unmap_unpin_all(iommu);
 		}
-- 
2.30.2

