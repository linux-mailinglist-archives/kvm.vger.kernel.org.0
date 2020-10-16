Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11484290204
	for <lists+kvm@lfdr.de>; Fri, 16 Oct 2020 11:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406082AbgJPJgB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Oct 2020 05:36:01 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:3984 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2406063AbgJPJgB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Oct 2020 05:36:01 -0400
Received: from dggeme753-chm.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id 746B09A038579EA4BC6A;
        Fri, 16 Oct 2020 17:35:59 +0800 (CST)
Received: from [10.174.184.120] (10.174.184.120) by
 dggeme753-chm.china.huawei.com (10.3.19.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Fri, 16 Oct 2020 17:35:58 +0800
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <alex.williamson@redhat.com>
CC:     <kwankhede@nvidia.com>, <xieyingtai@huawei.com>,
        <lizhengui@huawei.com>, <xuxiaoyang2@huawei.com>
From:   "xuxiaoyang (C)" <xuxiaoyang2@huawei.com>
Subject: [PATCH] vfio iommu type1: Fix memory leak in
 vfio_iommu_type1_pin_pages
Message-ID: <f65f1c3c-c1bc-a44a-15ea-4cb6e43c8b4b@huawei.com>
Date:   Fri, 16 Oct 2020 17:35:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.184.120]
X-ClientProxiedBy: dggeme707-chm.china.huawei.com (10.1.199.103) To
 dggeme753-chm.china.huawei.com (10.3.19.99)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From 099744c26513e386e707faecb3f17726e236d9bc Mon Sep 17 00:00:00 2001
From: Xiaoyang Xu <xuxiaoyang2@huawei.com>
Date: Fri, 16 Oct 2020 15:32:02 +0800
Subject: [PATCH] vfio iommu type1: Fix memory leak in
 vfio_iommu_type1_pin_pages

pfn is not added to pfn_list when vfio_add_to_pfn_list fails.
vfio_unpin_page_external will exit directly without calling
vfio_iova_put_vfio_pfn.This will lead to a memory leak.

Signed-off-by: Xiaoyang Xu <xuxiaoyang2@huawei.com>
---
 drivers/vfio/vfio_iommu_type1.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index c255a6683f31..26f518b02c81 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -640,6 +640,7 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 	unsigned long remote_vaddr;
 	struct vfio_dma *dma;
 	bool do_accounting;
+	int unlocked;

 	if (!iommu || !user_pfn || !phys_pfn)
 		return -EINVAL;
@@ -693,7 +694,9 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,

 		ret = vfio_add_to_pfn_list(dma, iova, phys_pfn[i]);
 		if (ret) {
-			vfio_unpin_page_external(dma, iova, do_accounting);
+			unlocked = put_pfn(phys_pfn[i], dma->prot);
+			if (do_accounting)
+				vfio_lock_acct(dma, -unlocked, true);
 			goto pin_unwind;
 		}

--
2.19.1

