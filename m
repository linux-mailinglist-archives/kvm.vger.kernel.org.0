Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5BD1BA636
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 16:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbgD0OUJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 10:20:09 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:56270 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727824AbgD0OUI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 10:20:08 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 677F97D47990EB50A228;
        Mon, 27 Apr 2020 22:20:01 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Mon, 27 Apr 2020 22:19:51 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>
CC:     Wei Yongjun <weiyongjun1@huawei.com>, <kvm@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH -next] samples: vfio-mdev: fix error return code in mdpy_fb_probe()
Date:   Mon, 27 Apr 2020 14:21:10 +0000
Message-ID: <20200427142110.56121-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix to return negative error code -ENOMEM from the error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 samples/vfio-mdev/mdpy-fb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/samples/vfio-mdev/mdpy-fb.c b/samples/vfio-mdev/mdpy-fb.c
index 21dbf63d6e41..d4abc0594dbd 100644
--- a/samples/vfio-mdev/mdpy-fb.c
+++ b/samples/vfio-mdev/mdpy-fb.c
@@ -131,8 +131,10 @@ static int mdpy_fb_probe(struct pci_dev *pdev,
 		 width, height);
 
 	info = framebuffer_alloc(sizeof(struct mdpy_fb_par), &pdev->dev);
-	if (!info)
+	if (!info) {
+		ret = -ENOMEM;
 		goto err_release_regions;
+	}
 	pci_set_drvdata(pdev, info);
 	par = info->par;



