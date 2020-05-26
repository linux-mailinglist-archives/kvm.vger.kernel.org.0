Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 677191B8CF2
	for <lists+kvm@lfdr.de>; Sun, 26 Apr 2020 08:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbgDZGkE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Apr 2020 02:40:04 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3299 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726108AbgDZGkE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Apr 2020 02:40:04 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 912E0C13748A6CD909A3;
        Sun, 26 Apr 2020 14:40:02 +0800 (CST)
Received: from DESKTOP-FJ48AOJ.china.huawei.com (10.173.221.6) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Sun, 26 Apr 2020 14:39:52 +0800
From:   Yingtai Xie <xieyingtai@huawei.com>
To:     <kwankhede@nvidia.com>
CC:     <alex.williamson@redhat.com>, <kvm@vger.kernel.org>,
        <xieyingtai@huawei.com>, <wu.wubin@huawei.com>
Subject: [PATCH] vfio/mdev: Add vfio-mdev device request interface
Date:   Sun, 26 Apr 2020 14:35:42 +0800
Message-ID: <20200426063542.16548-1-xieyingtai@huawei.com>
X-Mailer: git-send-email 2.8.3.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.173.221.6]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is setup the same way as vfio-pci to indicate
userspace that the device should be released.

Signed-off-by: Yingtai Xie <xieyingtai@huawei.com>
---
 drivers/vfio/mdev/vfio_mdev.c | 10 ++++++++++
 include/linux/mdev.h          |  4 ++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.c
index 30964a4e0..74695c116 100644
--- a/drivers/vfio/mdev/vfio_mdev.c
+++ b/drivers/vfio/mdev/vfio_mdev.c
@@ -98,6 +98,15 @@ static int vfio_mdev_mmap(void *device_data, struct vm_area_struct *vma)
 	return parent->ops->mmap(mdev, vma);
 }
 
+static void vfio_mdev_request(void *device_data, unsigned int count)
+{
+	struct mdev_device *mdev = device_data;
+	struct mdev_parent *parent = mdev->parent;
+
+	if (likely(!parent->ops->request))
+		parent->ops->request(mdev, count);
+}
+
 static const struct vfio_device_ops vfio_mdev_dev_ops = {
 	.name		= "vfio-mdev",
 	.open		= vfio_mdev_open,
@@ -106,6 +115,7 @@ static const struct vfio_device_ops vfio_mdev_dev_ops = {
 	.read		= vfio_mdev_read,
 	.write		= vfio_mdev_write,
 	.mmap		= vfio_mdev_mmap,
+	.request	= vfio_mdev_request,
 };
 
 static int vfio_mdev_probe(struct device *dev)
diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index 0ce30ca78..1ab0b0b9b 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -72,6 +72,9 @@ struct device *mdev_get_iommu_device(struct device *dev);
  * @mmap:		mmap callback
  *			@mdev: mediated device structure
  *			@vma: vma structure
+ * @request	request callback
+ *			@mdev: mediated device structure
+ *			@count: counter to allow driver to release the device
  * Parent device that support mediated device should be registered with mdev
  * module with mdev_parent_ops structure.
  **/
@@ -92,6 +95,7 @@ struct mdev_parent_ops {
 	long	(*ioctl)(struct mdev_device *mdev, unsigned int cmd,
 			 unsigned long arg);
 	int	(*mmap)(struct mdev_device *mdev, struct vm_area_struct *vma);
+	int	(*request)(struct mdev_device *mdev, unsigned int count);
 };
 
 /* interface for exporting mdev supported type attributes */
-- 
2.19.1


