Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D44A54E7F42
	for <lists+kvm@lfdr.de>; Sat, 26 Mar 2022 07:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbiCZGER (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 26 Mar 2022 02:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbiCZGEJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 26 Mar 2022 02:04:09 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF7FDFD5F
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 23:02:33 -0700 (PDT)
Received: from dggpeml500021.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4KQStv6sbKz9stq;
        Sat, 26 Mar 2022 13:58:31 +0800 (CST)
Received: from dggpeml100016.china.huawei.com (7.185.36.216) by
 dggpeml500021.china.huawei.com (7.185.36.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 26 Mar 2022 14:02:30 +0800
Received: from DESKTOP-27KDQMV.china.huawei.com (10.174.148.223) by
 dggpeml100016.china.huawei.com (7.185.36.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 26 Mar 2022 14:02:30 +0800
From:   "Longpeng(Mike)" <longpeng2@huawei.com>
To:     <alex.williamson@redhat.com>
CC:     <pbonzini@redhat.com>, <qemu-devel@nongnu.org>,
        <kvm@vger.kernel.org>, <arei.gonglei@huawei.com>,
        <huangzhichao@huawei.com>, <yechuan@huawei.com>,
        "Longpeng(Mike)" <longpeng2@huawei.com>
Subject: [PATCH v6 1/5] vfio: simplify the conditional statements in vfio_msi_enable
Date:   Sat, 26 Mar 2022 14:02:22 +0800
Message-ID: <20220326060226.1892-2-longpeng2@huawei.com>
X-Mailer: git-send-email 2.25.0.windows.1
In-Reply-To: <20220326060226.1892-1-longpeng2@huawei.com>
References: <20220326060226.1892-1-longpeng2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.148.223]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml100016.china.huawei.com (7.185.36.216)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's unnecessary to test against the specific return value of
VFIO_DEVICE_SET_IRQS, since any positive return is an error
indicating the number of vectors we should retry with.

Signed-off-by: Longpeng(Mike) <longpeng2@huawei.com>
---
 hw/vfio/pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
index d07a4e99b1..1433989aeb 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -653,7 +653,7 @@ retry:
     if (ret) {
         if (ret < 0) {
             error_report("vfio: Error: Failed to setup MSI fds: %m");
-        } else if (ret != vdev->nr_vectors) {
+        } else {
             error_report("vfio: Error: Failed to enable %d "
                          "MSI vectors, retry with %d", vdev->nr_vectors, ret);
         }
@@ -671,7 +671,7 @@ retry:
         g_free(vdev->msi_vectors);
         vdev->msi_vectors = NULL;
 
-        if (ret > 0 && ret != vdev->nr_vectors) {
+        if (ret > 0) {
             vdev->nr_vectors = ret;
             goto retry;
         }
-- 
2.23.0

