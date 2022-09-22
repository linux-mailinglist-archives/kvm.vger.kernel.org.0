Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9D85E61E6
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 14:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbiIVMBD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 08:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231394AbiIVMAy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 08:00:54 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E7F3B774C
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 05:00:53 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MYDLd6Q72zpVLT;
        Thu, 22 Sep 2022 19:58:01 +0800 (CST)
Received: from kwepemm600008.china.huawei.com (7.193.23.88) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 20:00:51 +0800
Received: from huawei.com (10.175.100.227) by kwepemm600008.china.huawei.com
 (7.193.23.88) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 22 Sep
 2022 20:00:50 +0800
From:   Shang XiaoJing <shangxiaojing@huawei.com>
To:     <yishaih@nvidia.com>, <jgg@ziepe.ca>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
        <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <kvm@vger.kernel.org>
CC:     <shangxiaojing@huawei.com>
Subject: [PATCH -next] vfio/mlx5: Switch to use module_pci_driver() macro
Date:   Thu, 22 Sep 2022 20:35:07 +0800
Message-ID: <20220922123507.11222-1-shangxiaojing@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.227]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600008.china.huawei.com (7.193.23.88)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since pci provides the helper macro module_pci_driver(), we may replace
the module_init/exit with it.

Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
---
 drivers/vfio/pci/mlx5/main.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 759a5f5f7b3f..42bfa2678b81 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -654,18 +654,7 @@ static struct pci_driver mlx5vf_pci_driver = {
 	.driver_managed_dma = true,
 };
 
-static void __exit mlx5vf_pci_cleanup(void)
-{
-	pci_unregister_driver(&mlx5vf_pci_driver);
-}
-
-static int __init mlx5vf_pci_init(void)
-{
-	return pci_register_driver(&mlx5vf_pci_driver);
-}
-
-module_init(mlx5vf_pci_init);
-module_exit(mlx5vf_pci_cleanup);
+module_pci_driver(mlx5vf_pci_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Max Gurtovoy <mgurtovoy@nvidia.com>");
-- 
2.17.1

