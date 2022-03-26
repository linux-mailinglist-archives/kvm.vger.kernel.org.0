Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 843F24E7F41
	for <lists+kvm@lfdr.de>; Sat, 26 Mar 2022 07:02:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbiCZGEO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 26 Mar 2022 02:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbiCZGEJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 26 Mar 2022 02:04:09 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79625DFD64
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 23:02:33 -0700 (PDT)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4KQStw6nRBz9stg;
        Sat, 26 Mar 2022 13:58:32 +0800 (CST)
Received: from dggpeml100016.china.huawei.com (7.185.36.216) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 26 Mar 2022 14:02:31 +0800
Received: from DESKTOP-27KDQMV.china.huawei.com (10.174.148.223) by
 dggpeml100016.china.huawei.com (7.185.36.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 26 Mar 2022 14:02:31 +0800
From:   "Longpeng(Mike)" <longpeng2@huawei.com>
To:     <alex.williamson@redhat.com>
CC:     <pbonzini@redhat.com>, <qemu-devel@nongnu.org>,
        <kvm@vger.kernel.org>, <arei.gonglei@huawei.com>,
        <huangzhichao@huawei.com>, <yechuan@huawei.com>,
        "Longpeng(Mike)" <longpeng2@huawei.com>
Subject: [PATCH v6 3/5] vfio: simplify the failure path in vfio_msi_enable
Date:   Sat, 26 Mar 2022 14:02:24 +0800
Message-ID: <20220326060226.1892-4-longpeng2@huawei.com>
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

Use vfio_msi_disable_common to simplify the error handling
in vfio_msi_enable.

Signed-off-by: Longpeng(Mike) <longpeng2@huawei.com>
---
 hw/vfio/pci.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
index a1916e2e36..6f49e71cd4 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -47,6 +47,7 @@
 
 static void vfio_disable_interrupts(VFIOPCIDevice *vdev);
 static void vfio_mmap_set_enabled(VFIOPCIDevice *vdev, bool enabled);
+static void vfio_msi_disable_common(VFIOPCIDevice *vdev);
 
 /*
  * Disabling BAR mmaping can be slow, but toggling it around INTx can
@@ -658,24 +659,12 @@ retry:
                          "MSI vectors, retry with %d", vdev->nr_vectors, ret);
         }
 
-        for (i = 0; i < vdev->nr_vectors; i++) {
-            VFIOMSIVector *vector = &vdev->msi_vectors[i];
-            if (vector->virq >= 0) {
-                vfio_remove_kvm_msi_virq(vector);
-            }
-            qemu_set_fd_handler(event_notifier_get_fd(&vector->interrupt),
-                                NULL, NULL, NULL);
-            event_notifier_cleanup(&vector->interrupt);
-        }
-
-        g_free(vdev->msi_vectors);
-        vdev->msi_vectors = NULL;
+        vfio_msi_disable_common(vdev);
 
         if (ret > 0) {
             vdev->nr_vectors = ret;
             goto retry;
         }
-        vdev->nr_vectors = 0;
 
         /*
          * Failing to setup MSI doesn't really fall within any specification.
@@ -683,7 +672,6 @@ retry:
          * out to fall back to INTx for this device.
          */
         error_report("vfio: Error: Failed to enable MSI");
-        vdev->interrupt = VFIO_INT_NONE;
 
         return;
     }
-- 
2.23.0

