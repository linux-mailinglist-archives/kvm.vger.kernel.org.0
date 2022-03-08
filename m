Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C82624D13EF
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 10:54:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345524AbiCHJzf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 04:55:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235300AbiCHJze (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 04:55:34 -0500
X-Greylist: delayed 182 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Mar 2022 01:54:35 PST
Received: from cmccmta2.chinamobile.com (cmccmta2.chinamobile.com [221.176.66.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6492C3F33B;
        Tue,  8 Mar 2022 01:54:35 -0800 (PST)
Received: from spf.mail.chinamobile.com (unknown[172.16.121.13]) by rmmx-syy-dmz-app07-12007 (RichMail) with SMTP id 2ee762272721fbf-9b593; Tue, 08 Mar 2022 17:51:31 +0800 (CST)
X-RM-TRANSID: 2ee762272721fbf-9b593
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[223.108.79.97])
        by rmsmtp-syy-appsvr07-12007 (RichMail) with SMTP id 2ee7622727171ce-2a1ab;
        Tue, 08 Mar 2022 17:51:31 +0800 (CST)
X-RM-TRANSID: 2ee7622727171ce-2a1ab
From:   jianchunfu <jianchunfu@cmss.chinamobile.com>
To:     alex.williamson@redhat.com
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        jianchunfu <jianchunfu@cmss.chinamobile.com>
Subject: [PATCH] drivers:vfio: make the logic cleaner with braket
Date:   Tue,  8 Mar 2022 17:49:46 +0800
Message-Id: <20220308094946.139059-1-jianchunfu@cmss.chinamobile.com>
X-Mailer: git-send-email 2.18.4
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use braket to avoid identifying operators in function
vfio_iova_dirty_bitmap() and vfio_dma_do_unmap()
when there are too many field values.

Signed-off-by: jianchunfu <jianchunfu@cmss.chinamobile.com>
---
 drivers/vfio/vfio_iommu_type1.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 9394aa944..199547012 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1251,7 +1251,7 @@ static int vfio_iova_dirty_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
 		return -EINVAL;
 
 	dma = vfio_find_dma(iommu, iova + size - 1, 0);
-	if (dma && dma->iova + dma->size != iova + size)
+	if (dma && (dma->iova + dma->size) != (iova + size))
 		return -EINVAL;
 
 	for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
@@ -1363,7 +1363,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 			goto unlock;
 
 		dma = vfio_find_dma(iommu, iova + size - 1, 0);
-		if (dma && dma->iova + dma->size != iova + size)
+		if (dma && (dma->iova + dma->size) != (iova + size))
 			goto unlock;
 	}
 
@@ -2958,7 +2958,7 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
 			ret = -EINVAL;
 			goto out_unlock;
 		}
-		if (!range.size || range.size & (iommu_pgsize - 1)) {
+		if (!range.size || (range.size & (iommu_pgsize - 1))) {
 			ret = -EINVAL;
 			goto out_unlock;
 		}
-- 
2.18.4



