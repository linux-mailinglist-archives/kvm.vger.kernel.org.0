Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5476E4ADA06
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 14:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350794AbiBHNgw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 08:36:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357179AbiBHNgr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 08:36:47 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E219EC03FEF2;
        Tue,  8 Feb 2022 05:36:42 -0800 (PST)
Received: from fraeml737-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JtP841F7bz67Mww;
        Tue,  8 Feb 2022 21:32:36 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml737-chm.china.huawei.com (10.206.15.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Feb 2022 14:36:40 +0100
Received: from A2006125610.china.huawei.com (10.202.227.178) by
 lhreml710-chm.china.huawei.com (10.201.108.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Feb 2022 13:36:34 +0000
From:   Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
CC:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <cohuck@redhat.com>, <mgurtovoy@nvidia.com>, <yishaih@nvidia.com>,
        <linuxarm@huawei.com>, <liulongfang@huawei.com>,
        <prime.zeng@hisilicon.com>, <jonathan.cameron@huawei.com>,
        <wangzhou1@hisilicon.com>
Subject: [RFC v4 5/8] hisi_acc_vfio_pci: Restrict access to VF dev BAR2 migration region
Date:   Tue, 8 Feb 2022 13:34:22 +0000
Message-ID: <20220208133425.1096-6-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20220208133425.1096-1-shameerali.kolothum.thodi@huawei.com>
References: <20220208133425.1096-1-shameerali.kolothum.thodi@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.202.227.178]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

HiSilicon ACC VF device BAR2 region consists of both functional
register space and migration control register space. From a
security point of view, it's not advisable to export the migration
control region to Guest.

Hence, override the ioctl/read/write/mmap methods to hide the
migration region and limit the access only to the functional register
space.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 drivers/vfio/pci/hisi_acc_vfio_pci.c | 122 ++++++++++++++++++++++++++-
 1 file changed, 118 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisi_acc_vfio_pci.c
index 8b59e628110e..563ed2cc861f 100644
--- a/drivers/vfio/pci/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisi_acc_vfio_pci.c
@@ -13,6 +13,120 @@
 #include <linux/vfio.h>
 #include <linux/vfio_pci_core.h>
 
+static int hisi_acc_pci_rw_access_check(struct vfio_device *core_vdev,
+					size_t count, loff_t *ppos,
+					size_t *new_count)
+{
+	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
+	struct vfio_pci_core_device *vdev =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+
+	if (index == VFIO_PCI_BAR2_REGION_INDEX) {
+		loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
+		resource_size_t end = pci_resource_len(vdev->pdev, index) / 2;
+
+		/* Check if access is for migration control region */
+		if (pos >= end)
+			return -EINVAL;
+
+		*new_count = min(count, (size_t)(end - pos));
+	}
+
+	return 0;
+}
+
+static int hisi_acc_vfio_pci_mmap(struct vfio_device *core_vdev,
+				  struct vm_area_struct *vma)
+{
+	struct vfio_pci_core_device *vdev =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+	unsigned int index;
+
+	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
+	if (index == VFIO_PCI_BAR2_REGION_INDEX) {
+		u64 req_len, pgoff, req_start;
+		resource_size_t end = pci_resource_len(vdev->pdev, index) / 2;
+
+		req_len = vma->vm_end - vma->vm_start;
+		pgoff = vma->vm_pgoff &
+			((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
+		req_start = pgoff << PAGE_SHIFT;
+
+		if (req_start + req_len > end)
+			return -EINVAL;
+	}
+
+	return vfio_pci_core_mmap(core_vdev, vma);
+}
+
+static ssize_t hisi_acc_vfio_pci_write(struct vfio_device *core_vdev,
+				       const char __user *buf, size_t count,
+				       loff_t *ppos)
+{
+	size_t new_count = count;
+	int ret;
+
+	ret = hisi_acc_pci_rw_access_check(core_vdev, count, ppos, &new_count);
+	if (ret)
+		return ret;
+
+	return vfio_pci_core_write(core_vdev, buf, new_count, ppos);
+}
+
+static ssize_t hisi_acc_vfio_pci_read(struct vfio_device *core_vdev,
+				      char __user *buf, size_t count,
+				      loff_t *ppos)
+{
+	size_t new_count = count;
+	int ret;
+
+	ret = hisi_acc_pci_rw_access_check(core_vdev, count, ppos, &new_count);
+	if (ret)
+		return ret;
+
+	return vfio_pci_core_read(core_vdev, buf, new_count, ppos);
+}
+
+static long hisi_acc_vfio_pci_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
+				    unsigned long arg)
+{
+	struct vfio_pci_core_device *vdev =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+
+	if (cmd == VFIO_DEVICE_GET_REGION_INFO) {
+		struct pci_dev *pdev = vdev->pdev;
+		struct vfio_region_info info;
+		unsigned long minsz;
+
+		minsz = offsetofend(struct vfio_region_info, offset);
+
+		if (copy_from_user(&info, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (info.argsz < minsz)
+			return -EINVAL;
+
+		if (info.index == VFIO_PCI_BAR2_REGION_INDEX) {
+			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+
+			/*
+			 * ACC VF dev BAR2 region consists of both functional
+			 * register space and migration control register space.
+			 * Report only the functional region to Guest.
+			 */
+			info.size = pci_resource_len(pdev, info.index) / 2;
+
+			info.flags = VFIO_REGION_INFO_FLAG_READ |
+					VFIO_REGION_INFO_FLAG_WRITE |
+					VFIO_REGION_INFO_FLAG_MMAP;
+
+			return copy_to_user((void __user *)arg, &info, minsz) ?
+					    -EFAULT : 0;
+		}
+	}
+	return vfio_pci_core_ioctl(core_vdev, cmd, arg);
+}
+
 static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
 {
 	struct vfio_pci_core_device *vdev =
@@ -32,10 +146,10 @@ static const struct vfio_device_ops hisi_acc_vfio_pci_ops = {
 	.name = "hisi-acc-vfio-pci",
 	.open_device = hisi_acc_vfio_pci_open_device,
 	.close_device = vfio_pci_core_close_device,
-	.ioctl = vfio_pci_core_ioctl,
-	.read = vfio_pci_core_read,
-	.write = vfio_pci_core_write,
-	.mmap = vfio_pci_core_mmap,
+	.ioctl = hisi_acc_vfio_pci_ioctl,
+	.read = hisi_acc_vfio_pci_read,
+	.write = hisi_acc_vfio_pci_write,
+	.mmap = hisi_acc_vfio_pci_mmap,
 	.request = vfio_pci_core_request,
 	.match = vfio_pci_core_match,
 };
-- 
2.17.1

