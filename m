Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73E42471979
	for <lists+kvm@lfdr.de>; Sun, 12 Dec 2021 10:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbhLLJZD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Dec 2021 04:25:03 -0500
Received: from smtp179.sjtu.edu.cn ([202.120.2.179]:41494 "EHLO
        smtp179.sjtu.edu.cn" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbhLLJZC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Dec 2021 04:25:02 -0500
X-Greylist: delayed 430 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Dec 2021 04:25:02 EST
Received: from proxy01.sjtu.edu.cn (smtp185.sjtu.edu.cn [202.120.2.185])
        by smtp179.sjtu.edu.cn (Postfix) with ESMTPS id 654FE100888E1;
        Sun, 12 Dec 2021 17:17:50 +0800 (CST)
Received: from localhost (localhost [127.0.0.1])
        by proxy01.sjtu.edu.cn (Postfix) with ESMTP id 425E720426994;
        Sun, 12 Dec 2021 17:17:50 +0800 (CST)
X-Virus-Scanned: amavisd-new at proxy01.sjtu.edu.cn
Received: from proxy01.sjtu.edu.cn ([127.0.0.1])
        by localhost (proxy01.sjtu.edu.cn [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id qRjsQwV-nyd3; Sun, 12 Dec 2021 17:17:50 +0800 (CST)
Received: from ubuntu.localdomain (unknown [101.82.107.170])
        (Authenticated sender: billsjc@sjtu.edu.cn)
        by proxy01.sjtu.edu.cn (Postfix) with ESMTPSA id 7762920424208;
        Sun, 12 Dec 2021 17:17:43 +0800 (CST)
From:   Jiacheng Shi <billsjc@sjtu.edu.cn>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Jiacheng Shi <billsjc@sjtu.edu.cn>
Subject: [PATCH] vfio/iommu_type1: replace kfree with kvfree
Date:   Sun, 12 Dec 2021 01:16:00 -0800
Message-Id: <20211212091600.2560-1-billsjc@sjtu.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Variables allocated by kvzalloc should not be freed by kfree.
Because they may be allocated by vmalloc.
So we replace kfree with kvfree here.

Fixes: d6a4c185660c ("vfio iommu: Implementation of ioctl for dirty pages tracking")
Signed-off-by: Jiacheng Shi <billsjc@sjtu.edu.cn>
---
 drivers/vfio/vfio_iommu_type1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index f17490ab238f..9394aa9444c1 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -256,7 +256,7 @@ static int vfio_dma_bitmap_alloc(struct vfio_dma *dma, size_t pgsize)
 
 static void vfio_dma_bitmap_free(struct vfio_dma *dma)
 {
-	kfree(dma->bitmap);
+	kvfree(dma->bitmap);
 	dma->bitmap = NULL;
 }
 
-- 
2.17.1

