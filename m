Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82240E9A83
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2019 11:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbfJ3K4t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Oct 2019 06:56:49 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:59254 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726761AbfJ3K4s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Oct 2019 06:56:48 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id AD30DCE6CB8B683BAC3B;
        Wed, 30 Oct 2019 18:56:45 +0800 (CST)
Received: from huawei.com (10.175.105.18) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Wed, 30 Oct 2019
 18:56:39 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <eric.auger@redhat.com>, <aik@ozlabs.ru>, <mpe@ellerman.id.au>,
        <bhelgaas@google.com>, <tglx@linutronix.de>, <hexin.op@gmail.com>
CC:     <linmiaohe@huawei.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] VFIO: PCI: eliminate unnecessary overhead in vfio_pci_reflck_find
Date:   Wed, 30 Oct 2019 18:57:10 +0800
Message-ID: <1572433030-6267-1-git-send-email-linmiaohe@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.105.18]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

The driver of the pci device may not equal to vfio_pci_driver,
but we fetch vfio_device from pci_dev unconditionally in func
vfio_pci_reflck_find. This overhead, such as the competition
of vfio.group_lock, can be eliminated by check pci_dev_driver
with vfio_pci_driver first.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 drivers/vfio/pci/vfio_pci.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 379a02c36e37..1e21970543a6 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -1466,15 +1466,14 @@ static int vfio_pci_reflck_find(struct pci_dev *pdev, void *data)
 	struct vfio_device *device;
 	struct vfio_pci_device *vdev;
 
-	device = vfio_device_get_from_dev(&pdev->dev);
-	if (!device)
-		return 0;
-
 	if (pci_dev_driver(pdev) != &vfio_pci_driver) {
-		vfio_device_put(device);
 		return 0;
 	}
 
+	device = vfio_device_get_from_dev(&pdev->dev);
+	if (!device)
+		return 0;
+
 	vdev = vfio_device_data(device);
 
 	if (vdev->reflck) {
-- 
2.19.1

