Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C20D42CFA8
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 02:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbhJNAv1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 20:51:27 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:25134 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbhJNAv0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 20:51:26 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HV9jW14Ryz1DHZC;
        Thu, 14 Oct 2021 08:47:43 +0800 (CST)
Received: from dggpeml100016.china.huawei.com (7.185.36.216) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 14 Oct 2021 08:49:21 +0800
Received: from DESKTOP-27KDQMV.china.huawei.com (10.174.148.223) by
 dggpeml100016.china.huawei.com (7.185.36.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 14 Oct 2021 08:49:20 +0800
From:   "Longpeng(Mike)" <longpeng2@huawei.com>
To:     <alex.williamson@redhat.com>, <pbonzini@redhat.com>
CC:     <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
        <arei.gonglei@huawei.com>, "Longpeng(Mike)" <longpeng2@huawei.com>
Subject: [PATCH v4 3/6] vfio: simplify the failure path in vfio_msi_enable
Date:   Thu, 14 Oct 2021 08:48:49 +0800
Message-ID: <20211014004852.1293-4-longpeng2@huawei.com>
X-Mailer: git-send-email 2.25.0.windows.1
In-Reply-To: <20211014004852.1293-1-longpeng2@huawei.com>
References: <20211014004852.1293-1-longpeng2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.148.223]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml100016.china.huawei.com (7.185.36.216)
X-CFilter-Loop: Reflected
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
index a4985c0..aeeb6cd 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -47,6 +47,7 @@
 
 static void vfio_disable_interrupts(VFIOPCIDevice *vdev);
 static void vfio_mmap_set_enabled(VFIOPCIDevice *vdev, bool enabled);
+static void vfio_msi_disable_common(VFIOPCIDevice *vdev);
 
 /*
  * Disabling BAR mmaping can be slow, but toggling it around INTx can
@@ -655,24 +656,12 @@ retry:
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
@@ -680,7 +669,6 @@ retry:
          * out to fall back to INTx for this device.
          */
         error_report("vfio: Error: Failed to enable MSI");
-        vdev->interrupt = VFIO_INT_NONE;
 
         return;
     }
-- 
1.8.3.1

