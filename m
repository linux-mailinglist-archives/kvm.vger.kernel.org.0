Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 673864C653D
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 10:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234178AbiB1JDW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 04:03:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234268AbiB1JDJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 04:03:09 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACFF7140A0;
        Mon, 28 Feb 2022 01:02:30 -0800 (PST)
Received: from fraeml740-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K6Z9y5kPjz67N4y;
        Mon, 28 Feb 2022 17:01:26 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml740-chm.china.huawei.com (10.206.15.221) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 28 Feb 2022 10:02:28 +0100
Received: from A2006125610.china.huawei.com (10.47.94.1) by
 lhreml710-chm.china.huawei.com (10.201.108.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 28 Feb 2022 09:02:20 +0000
From:   Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
CC:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <cohuck@redhat.com>, <mgurtovoy@nvidia.com>, <yishaih@nvidia.com>,
        <linuxarm@huawei.com>, <liulongfang@huawei.com>,
        <prime.zeng@hisilicon.com>, <jonathan.cameron@huawei.com>,
        <wangzhou1@hisilicon.com>
Subject: [PATCH v6 05/10] hisi_acc_vfio_pci: Restrict access to VF dev BAR2 migration region
Date:   Mon, 28 Feb 2022 09:01:16 +0000
Message-ID: <20220228090121.1903-6-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20220228090121.1903-1-shameerali.kolothum.thodi@huawei.com>
References: <20220228090121.1903-1-shameerali.kolothum.thodi@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.47.94.1]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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

Hence, introduce a separate struct vfio_device_ops for migration
support which will override the ioctl/read/write/mmap methods to
hide the migration region and limit the access only to the
functional register space.

This will be used in subsequent patches when we add migration
support to the driver.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 126 ++++++++++++++++++
 1 file changed, 126 insertions(+)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index 8129c3457b3b..582ee4fa4109 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -13,6 +13,119 @@
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
+	if (cmd == VFIO_DEVICE_GET_REGION_INFO) {
+		struct vfio_pci_core_device *vdev =
+			container_of(core_vdev, struct vfio_pci_core_device, vdev);
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
@@ -28,6 +141,19 @@ static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
 	return 0;
 }
 
+static const struct vfio_device_ops hisi_acc_vfio_pci_migrn_ops = {
+	.name = "hisi-acc-vfio-pci-migration",
+	.open_device = hisi_acc_vfio_pci_open_device,
+	.close_device = vfio_pci_core_close_device,
+	.ioctl = hisi_acc_vfio_pci_ioctl,
+	.device_feature = vfio_pci_core_ioctl_feature,
+	.read = hisi_acc_vfio_pci_read,
+	.write = hisi_acc_vfio_pci_write,
+	.mmap = hisi_acc_vfio_pci_mmap,
+	.request = vfio_pci_core_request,
+	.match = vfio_pci_core_match,
+};
+
 static const struct vfio_device_ops hisi_acc_vfio_pci_ops = {
 	.name = "hisi-acc-vfio-pci",
 	.open_device = hisi_acc_vfio_pci_open_device,
-- 
2.25.1

