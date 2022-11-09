Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 361F9622613
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 10:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbiKIJBO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 04:01:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbiKIJBM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 04:01:12 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCEDF1DA46;
        Wed,  9 Nov 2022 01:01:10 -0800 (PST)
Received: from kwepemi500008.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4N6f4v5zsszJnTQ;
        Wed,  9 Nov 2022 16:58:07 +0800 (CST)
Received: from huawei.com (10.67.175.83) by kwepemi500008.china.huawei.com
 (7.221.188.139) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 9 Nov
 2022 17:01:08 +0800
From:   ruanjinjie <ruanjinjie@huawei.com>
To:     <jgg@ziepe.ca>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
        <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <ruanjinjie@huawei.com>
Subject: [PATCH -next] vfio/mlx5: use module_pci_driver
Date:   Wed, 9 Nov 2022 16:57:52 +0800
Message-ID: <20221109085752.3543607-1-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.175.83]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500008.china.huawei.com (7.221.188.139)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

mlx5vf_pci_init and mlx5vf_pci_cleanup with module_init and module_exit
calls can be replaced with the module_pci_driver call, as they are similar
to what module_pci_driver does

Signed-off-by: ruanjinjie <ruanjinjie@huawei.com>
---
 drivers/vfio/pci/mlx5/main.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index fd6ccb8454a2..457138b92f13 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -676,18 +676,7 @@ static struct pci_driver mlx5vf_pci_driver = {
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
2.25.1

