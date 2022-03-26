Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E94284E7F43
	for <lists+kvm@lfdr.de>; Sat, 26 Mar 2022 07:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbiCZGEU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 26 Mar 2022 02:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbiCZGEK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 26 Mar 2022 02:04:10 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E0DDFDD0
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 23:02:34 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KQSx26PS0zCr7K;
        Sat, 26 Mar 2022 14:00:22 +0800 (CST)
Received: from dggpeml100016.china.huawei.com (7.185.36.216) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 26 Mar 2022 14:02:32 +0800
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
Subject: [PATCH v6 4/5] Revert "vfio: Avoid disabling and enabling vectors repeatedly in VFIO migration"
Date:   Sat, 26 Mar 2022 14:02:25 +0800
Message-ID: <20220326060226.1892-5-longpeng2@huawei.com>
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
index 6f49e71cd4..6801391cf6 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -572,9 +572,6 @@ static void vfio_msix_vector_release(PCIDevice *pdev, unsigned int nr)
 
 static void vfio_msix_enable(VFIOPCIDevice *vdev)
 {
-    PCIDevice *pdev = &vdev->pdev;
-    unsigned int nr, max_vec = 0;
-
     vfio_disable_interrupts(vdev);
 
     vdev->msi_vectors = g_new0(VFIOMSIVector, vdev->msix->entries);
@@ -593,22 +590,11 @@ static void vfio_msix_enable(VFIOPCIDevice *vdev)
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
2.23.0

