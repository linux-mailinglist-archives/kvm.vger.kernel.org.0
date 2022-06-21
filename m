Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E04FB552AEF
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 08:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345659AbiFUGVX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 02:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236786AbiFUGVW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 02:21:22 -0400
Received: from unicom145.biz-email.net (unicom145.biz-email.net [210.51.26.145])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D705FB9;
        Mon, 20 Jun 2022 23:21:18 -0700 (PDT)
Received: from ([60.208.111.195])
        by unicom145.biz-email.net ((D)) with ASMTP (SSL) id PCQ00014;
        Tue, 21 Jun 2022 14:21:14 +0800
Received: from localhost.localdomain (10.200.104.97) by
 jtjnmail201609.home.langchao.com (10.100.2.9) with Microsoft SMTP Server id
 15.1.2308.27; Tue, 21 Jun 2022 14:21:13 +0800
From:   Bo Liu <liubo03@inspur.com>
To:     <alex.williamson@redhat.com>, <cohuck@redhat.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Bo Liu <liubo03@inspur.com>
Subject: [PATCH] vfio: check vfio_register_iommu_driver() return value
Date:   Tue, 21 Jun 2022 02:21:12 -0400
Message-ID: <20220621062112.5771-1-liubo03@inspur.com>
X-Mailer: git-send-email 2.18.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.200.104.97]
tUid:   20226211421144bb9c9353ee79c24a77567bb9572c972
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As vfio_register_iommu_driver() can fail, we should check the return value.

Signed-off-by: Bo Liu <liubo03@inspur.com>
---
 drivers/vfio/vfio.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 61e71c1154be..7d4b6dfafd27 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -2159,10 +2159,16 @@ static int __init vfio_init(void)
 	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
 
 #ifdef CONFIG_VFIO_NOIOMMU
-	vfio_register_iommu_driver(&vfio_noiommu_ops);
+	ret = vfio_register_iommu_driver(&vfio_noiommu_ops);
+	if (ret)
+		goto err_driver_register;
 #endif
 	return 0;
 
+#ifdef CONFIG_VFIO_NOIOMMU
+err_driver_register:
+	unregister_chrdev_region(vfio.group_devt, MINORMASK + 1);
+#endif
 err_alloc_chrdev:
 	class_destroy(vfio.class);
 	vfio.class = NULL;
-- 
2.27.0

