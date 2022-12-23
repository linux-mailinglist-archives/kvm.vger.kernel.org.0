Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB79654CD8
	for <lists+kvm@lfdr.de>; Fri, 23 Dec 2022 08:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbiLWHYa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Dec 2022 02:24:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiLWHY2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Dec 2022 02:24:28 -0500
Received: from mail.nfschina.com (mail.nfschina.com [124.16.136.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CBB92658A;
        Thu, 22 Dec 2022 23:24:27 -0800 (PST)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 785B51E80DA0;
        Fri, 23 Dec 2022 15:19:16 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id FMh5p-cEkS2V; Fri, 23 Dec 2022 15:19:13 +0800 (CST)
Received: from localhost.localdomain (unknown [219.141.250.2])
        (Authenticated sender: kunyu@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 419D41E80D96;
        Fri, 23 Dec 2022 15:19:13 +0800 (CST)
From:   Li kunyu <kunyu@nfschina.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li kunyu <kunyu@nfschina.com>
Subject: [PATCH] vfio_iommu_type1: increase the validity check of function parameters
Date:   Fri, 23 Dec 2022 15:24:18 +0800
Message-Id: <20221223072418.3728-1-kunyu@nfschina.com>
X-Mailer: git-send-email 2.18.2
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Added validity check for count variable, return if count variable does 
not meet the execution condition (do not execute mutex_lock and 
mutex_unlock function).

Signed-off-by: Li kunyu <kunyu@nfschina.com>
---
 drivers/vfio/vfio_iommu_type1.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 23c24fe98c00..9bdf96d932e4 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -3137,6 +3137,9 @@ static int vfio_iommu_type1_dma_rw(void *iommu_data, dma_addr_t user_iova,
 	int ret = 0;
 	size_t done;
 
+	if (count <= 0)
+		return ret;
+
 	mutex_lock(&iommu->lock);
 	while (count > 0) {
 		ret = vfio_iommu_type1_dma_rw_chunk(iommu, user_iova, data,
-- 
2.18.2

