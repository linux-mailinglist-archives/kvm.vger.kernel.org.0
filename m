Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 562F02B8BEA
	for <lists+kvm@lfdr.de>; Thu, 19 Nov 2020 08:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbgKSHEJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Nov 2020 02:04:09 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8115 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726117AbgKSHEI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Nov 2020 02:04:08 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Cc9dG4jk7zLnZL;
        Thu, 19 Nov 2020 15:03:46 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Thu, 19 Nov 2020 15:04:00 +0800
From:   Qinglang Miao <miaoqinglang@huawei.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Qinglang Miao <miaoqinglang@huawei.com>
Subject: [PATCH] samples: vfio-mdev: fix return value of error branch in mdpy_fb_probe()
Date:   Thu, 19 Nov 2020 15:08:43 +0800
Message-ID: <20201119070843.1074-1-miaoqinglang@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

pci_release_regions() should be called in these error branches, so
I set ret and use goto err_release_regions intead of simply return
-EINVAL.

Fixes: cacade1946a4 ("sample: vfio mdev display - guest driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
---
 samples/vfio-mdev/mdpy-fb.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/samples/vfio-mdev/mdpy-fb.c b/samples/vfio-mdev/mdpy-fb.c
index 21dbf63d6..c944a6697 100644
--- a/samples/vfio-mdev/mdpy-fb.c
+++ b/samples/vfio-mdev/mdpy-fb.c
@@ -117,15 +117,18 @@ static int mdpy_fb_probe(struct pci_dev *pdev,
 	if (format != DRM_FORMAT_XRGB8888) {
 		pci_err(pdev, "format mismatch (0x%x != 0x%x)\n",
 			format, DRM_FORMAT_XRGB8888);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_release_regions;
 	}
 	if (width < 100	 || width > 10000) {
 		pci_err(pdev, "width (%d) out of range\n", width);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_release_regions;
 	}
 	if (height < 100 || height > 10000) {
 		pci_err(pdev, "height (%d) out of range\n", height);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_release_regions;
 	}
 	pci_info(pdev, "mdpy found: %dx%d framebuffer\n",
 		 width, height);
-- 
2.23.0

