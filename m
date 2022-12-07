Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7787664548A
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 08:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbiLGHYO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 02:24:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbiLGHXn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 02:23:43 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF24276
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 23:23:39 -0800 (PST)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NRpZ74szfzgYvH;
        Wed,  7 Dec 2022 15:19:27 +0800 (CST)
Received: from huawei.com (10.175.100.227) by kwepemi500016.china.huawei.com
 (7.221.188.220) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 7 Dec
 2022 15:23:37 +0800
From:   Shang XiaoJing <shangxiaojing@huawei.com>
To:     <kwankhede@nvidia.com>, <alex.williamson@redhat.com>,
        <kraxel@redhat.com>, <kvm@vger.kernel.org>
CC:     <shangxiaojing@huawei.com>
Subject: [PATCH] samples: vfio-mdev: Fix missing pci_disable_device() in mdpy_fb_probe()
Date:   Wed, 7 Dec 2022 15:21:28 +0800
Message-ID: <20221207072128.30344-1-shangxiaojing@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.227]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemi500016.china.huawei.com (7.221.188.220)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add missing pci_disable_device() in fail path of mdpy_fb_probe().

Fixes: cacade1946a4 ("sample: vfio mdev display - guest driver")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
---
 samples/vfio-mdev/mdpy-fb.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/samples/vfio-mdev/mdpy-fb.c b/samples/vfio-mdev/mdpy-fb.c
index 9ec93d90e8a5..a7b3a30058e5 100644
--- a/samples/vfio-mdev/mdpy-fb.c
+++ b/samples/vfio-mdev/mdpy-fb.c
@@ -109,7 +109,7 @@ static int mdpy_fb_probe(struct pci_dev *pdev,
 
 	ret = pci_request_regions(pdev, "mdpy-fb");
 	if (ret < 0)
-		return ret;
+		goto err_disable_dev;
 
 	pci_read_config_dword(pdev, MDPY_FORMAT_OFFSET, &format);
 	pci_read_config_dword(pdev, MDPY_WIDTH_OFFSET,	&width);
@@ -191,6 +191,9 @@ static int mdpy_fb_probe(struct pci_dev *pdev,
 err_release_regions:
 	pci_release_regions(pdev);
 
+err_disable_dev:
+	pci_disable_device(pdev);
+
 	return ret;
 }
 
-- 
2.17.1

