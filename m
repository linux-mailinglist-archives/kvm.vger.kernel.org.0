Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C783E443E43
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 09:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbhKCITx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 04:19:53 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:14709 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231512AbhKCITr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 04:19:47 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HkfhR5F61zZcXL;
        Wed,  3 Nov 2021 16:15:03 +0800 (CST)
Received: from dggpeml100016.china.huawei.com (7.185.36.216) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 3 Nov 2021 16:17:08 +0800
Received: from DESKTOP-27KDQMV.china.huawei.com (10.174.148.223) by
 dggpeml100016.china.huawei.com (7.185.36.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 3 Nov 2021 16:17:08 +0800
From:   "Longpeng(Mike)" <longpeng2@huawei.com>
To:     <alex.williamson@redhat.com>, <pbonzini@redhat.com>
CC:     <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
        <arei.gonglei@huawei.com>, "Longpeng(Mike)" <longpeng2@huawei.com>
Subject: [PATCH v5 5/6] Revert "vfio: Avoid disabling and enabling vectors repeatedly in VFIO migration"
Date:   Wed, 3 Nov 2021 16:16:56 +0800
Message-ID: <20211103081657.1945-6-longpeng2@huawei.com>
X-Mailer: git-send-email 2.25.0.windows.1
In-Reply-To: <20211103081657.1945-1-longpeng2@huawei.com>
References: <20211103081657.1945-1-longpeng2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.148.223]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml100016.china.huawei.com (7.185.36.216)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit ecebe53fe993 ("vfio: Avoid disabling and enabling vectors
repeatedly in VFIO migration") avoids inefficiently disabling and
enabling vectors repeatedly and lets the unmasked vectors be enabled
one by one.

But we want to batch multiple routes and defer the commit, and only
commit once outside the loop of setting vector notifiers, so we
cannot enable the vectors one by one in the loop now.

Revert that commit and we will take another way in the next patch,
it can not only avoid disabling/enabling vectors repeatedly, but
also satisfy our requirement of defer to commit.

Signed-off-by: Longpeng(Mike) <longpeng2@huawei.com>
---
 hw/vfio/pci.c | 20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
index 1ff84e6..69ad081 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -569,9 +569,6 @@ static void vfio_msix_vector_release(PCIDevice *pdev, unsigned int nr)
 
 static void vfio_msix_enable(VFIOPCIDevice *vdev)
 {
-    PCIDevice *pdev = &vdev->pdev;
-    unsigned int nr, max_vec = 0;
-
     vfio_disable_interrupts(vdev);
 
     vdev->msi_vectors = g_new0(VFIOMSIVector, vdev->msix->entries);
@@ -590,22 +587,11 @@ static void vfio_msix_enable(VFIOPCIDevice *vdev)
      * triggering to userspace, then immediately release the vector, leaving
      * the physical device with no vectors enabled, but MSI-X enabled, just
      * like the guest view.
-     * If there are already unmasked vectors (in migration resume phase and
-     * some guest startups) which will be enabled soon, we can allocate all
-     * of them here to avoid inefficiently disabling and enabling vectors
-     * repeatedly later.
      */
-    if (!pdev->msix_function_masked) {
-        for (nr = 0; nr < msix_nr_vectors_allocated(pdev); nr++) {
-            if (!msix_is_masked(pdev, nr)) {
-                max_vec = nr;
-            }
-        }
-    }
-    vfio_msix_vector_do_use(pdev, max_vec, NULL, NULL);
-    vfio_msix_vector_release(pdev, max_vec);
+    vfio_msix_vector_do_use(&vdev->pdev, 0, NULL, NULL);
+    vfio_msix_vector_release(&vdev->pdev, 0);
 
-    if (msix_set_vector_notifiers(pdev, vfio_msix_vector_use,
+    if (msix_set_vector_notifiers(&vdev->pdev, vfio_msix_vector_use,
                                   vfio_msix_vector_release, NULL)) {
         error_report("vfio: msix_set_vector_notifiers failed");
     }
-- 
1.8.3.1

