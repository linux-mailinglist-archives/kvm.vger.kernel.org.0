Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12EFE42CFAA
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 02:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhJNAv2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 20:51:28 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:24310 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbhJNAv2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 20:51:28 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HV9fG5K1wzYd2n;
        Thu, 14 Oct 2021 08:44:54 +0800 (CST)
Received: from dggpeml100016.china.huawei.com (7.185.36.216) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 14 Oct 2021 08:49:23 +0800
Received: from DESKTOP-27KDQMV.china.huawei.com (10.174.148.223) by
 dggpeml100016.china.huawei.com (7.185.36.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 14 Oct 2021 08:49:22 +0800
From:   "Longpeng(Mike)" <longpeng2@huawei.com>
To:     <alex.williamson@redhat.com>, <pbonzini@redhat.com>
CC:     <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
        <arei.gonglei@huawei.com>, "Longpeng(Mike)" <longpeng2@huawei.com>
Subject: [PATCH v4 5/6] Revert "vfio: Avoid disabling and enabling vectors repeatedly in VFIO migration"
Date:   Thu, 14 Oct 2021 08:48:51 +0800
Message-ID: <20211014004852.1293-6-longpeng2@huawei.com>
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
index aeeb6cd..0bd832b 100644
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

