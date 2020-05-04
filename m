Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD4B41C45D8
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 20:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730821AbgEDS1o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 14:27:44 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:6452 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730700AbgEDS1o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 14:27:44 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5eb05e200000>; Mon, 04 May 2020 11:25:36 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 04 May 2020 11:27:43 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 04 May 2020 11:27:43 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 4 May
 2020 18:27:43 +0000
Received: from kwankhede-dev.nvidia.com (10.124.1.5) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 4 May 2020 18:27:36 +0000
From:   Kirti Wankhede <kwankhede@nvidia.com>
To:     <alex.williamson@redhat.com>, <cjia@nvidia.com>
CC:     <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>, <cohuck@redhat.com>,
        <dgilbert@redhat.com>, <jonathan.davies@nutanix.com>,
        <eauger@redhat.com>, <aik@ozlabs.ru>, <pasic@linux.ibm.com>,
        <felipe@nutanix.com>, <Zhengxiao.zx@Alibaba-inc.com>,
        <shuangtai.tst@alibaba-inc.com>, <Ken.Xue@amd.com>,
        <zhi.a.wang@intel.com>, <yan.y.zhao@intel.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
        "Kirti Wankhede" <kwankhede@nvidia.com>
Subject: [PATCH v1 1/2] Sample mtty: Add sysfs interface to pin pages
Date:   Mon, 4 May 2020 23:24:19 +0530
Message-ID: <1588614860-16330-2-git-send-email-kwankhede@nvidia.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1588614860-16330-1-git-send-email-kwankhede@nvidia.com>
References: <1588614860-16330-1-git-send-email-kwankhede@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1588616736; bh=LM7O/QtPrNroYPHMAw1tDGhJJm1iWHCvYUgOsUsGJ7U=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=hpPDYMTIWyA3RSFu+DgJWyk3YbCP/vjKSL74Gb5ZdospGbspIf2/V1Feypa9UgNrU
         aePDwyyivOy/Ul61M29DEr6mv+M0TWUs7YlRQKLdAZVcQ1ROs5FV/ciu60/Ht/P1a9
         a9+p2Z6J2cG6zY0CSzOiqV73QCUFztxnN5KFzO2ymaDrnfIGGE7T4lzRcUcrH9dM7H
         yRAHOBcevjE9pUCPVU7GBlH87wfVnKxpP7+27dRC1J/xOrPVlkKA/IjIsS4ZzUap6y
         xreQplhyETU3I/mkFFnVKzWVkOkZ9M/cSc0NXReD93bmy8LkO9HDoi5V6mtoDp6QMi
         d9m1JVpb8j5QA==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Added sysfs interface to pin pages which will be used to test migration
when vendor driver pins pages.

Read on pin_pages shows number of pages pinned:
 $ cat /sys/bus/mdev/devices/<mdev UUID>/vendor/pin_pages
Pinned 0x0 pages

Write gpfn to pin_pages to pin that page. One page pinned on write
 $ echo 0x20 > /sys/bus/mdev/devices/<mdev UUID>/vendor/pin_pages

Limitation: Buffer for 2GB system memory is created to track pinned
pages.

This is for testing purpose only.

Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
---
 samples/vfio-mdev/mtty.c | 176 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 175 insertions(+), 1 deletion(-)

diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
index ce84a300a4da..bf666cce5bb7 100644
--- a/samples/vfio-mdev/mtty.c
+++ b/samples/vfio-mdev/mtty.c
@@ -64,6 +64,10 @@
 				(((u64)(1) << MTTY_VFIO_PCI_OFFSET_SHIFT) - 1)
 #define MAX_MTTYS	24
 
+/* Maximum pages of 4K for upto 2G RAM can be pinned */
+#define MAX_GPFN_COUNT	(512 * 1024)
+#define PFN_NULL	(~0UL)
+
 /*
  * Global Structures
  */
@@ -141,6 +145,10 @@ struct mdev_state {
 	struct mutex rxtx_lock;
 	struct vfio_device_info dev_info;
 	int nr_ports;
+
+	/* List of pinned gpfns, gpfn as index and content is translated hpfn */
+	unsigned long *gpfn_to_hpfn;
+	struct notifier_block nb;
 };
 
 static struct mutex mdev_list_lock;
@@ -745,6 +753,17 @@ static int mtty_create(struct kobject *kobj, struct mdev_device *mdev)
 		return -ENOMEM;
 	}
 
+	mdev_state->gpfn_to_hpfn =
+		 kzalloc(sizeof(unsigned long) * MAX_GPFN_COUNT, GFP_KERNEL);
+	if (mdev_state->gpfn_to_hpfn == NULL) {
+		kfree(mdev_state->vconfig);
+		kfree(mdev_state);
+		return -ENOMEM;
+	}
+
+	memset(mdev_state->gpfn_to_hpfn, ~0,
+	       sizeof(unsigned long) * MAX_GPFN_COUNT);
+
 	mutex_init(&mdev_state->ops_lock);
 	mdev_state->mdev = mdev;
 	mdev_set_drvdata(mdev, mdev_state);
@@ -769,6 +788,7 @@ static int mtty_remove(struct mdev_device *mdev)
 		if (mdev_state == mds) {
 			list_del(&mdev_state->next);
 			mdev_set_drvdata(mdev, NULL);
+			kfree(mdev_state->gpfn_to_hpfn);
 			kfree(mdev_state->vconfig);
 			kfree(mdev_state);
 			ret = 0;
@@ -1246,15 +1266,95 @@ static long mtty_ioctl(struct mdev_device *mdev, unsigned int cmd,
 	return -ENOTTY;
 }
 
+static void unpin_pages_all(struct mdev_state *mdev_state)
+{
+	struct mdev_device *mdev = mdev_state->mdev;
+	unsigned long i;
+
+	mutex_lock(&mdev_state->ops_lock);
+	for (i = 0; i < MAX_GPFN_COUNT; i++) {
+		if (mdev_state->gpfn_to_hpfn[i] != PFN_NULL) {
+			int ret;
+
+			ret = vfio_unpin_pages(mdev_dev(mdev), &i, 1);
+			if (ret <= 0) {
+				pr_err("%s: 0x%lx unpin error %d\n",
+					 __func__, i, ret);
+				continue;
+			}
+			mdev_state->gpfn_to_hpfn[i] = PFN_NULL;
+		}
+	}
+	mutex_unlock(&mdev_state->ops_lock);
+}
+
+static int unmap_notifier(struct notifier_block *nb, unsigned long action,
+			  void *data)
+{
+	if (action == VFIO_IOMMU_NOTIFY_DMA_UNMAP) {
+		struct mdev_state *mdev_state = container_of(nb,
+							 struct mdev_state, nb);
+		struct mdev_device *mdev = mdev_state->mdev;
+		struct vfio_iommu_type1_dma_unmap *unmap = data;
+		unsigned long start = unmap->iova >> PAGE_SHIFT;
+		unsigned long end = (unmap->iova + unmap->size) >> PAGE_SHIFT;
+		unsigned long i;
+
+		mutex_lock(&mdev_state->ops_lock);
+		for (i = start; i < end; i++) {
+			if (mdev_state->gpfn_to_hpfn[i] != PFN_NULL) {
+				int ret;
+
+				ret = vfio_unpin_pages(mdev_dev(mdev), &i, 1);
+				if (ret <= 0) {
+					pr_err("%s: 0x%lx unpin error %d\n",
+							__func__, i, ret);
+					continue;
+				}
+				mdev_state->gpfn_to_hpfn[i] = PFN_NULL;
+			}
+		}
+		mutex_unlock(&mdev_state->ops_lock);
+
+	}
+	return 0;
+}
+
 static int mtty_open(struct mdev_device *mdev)
 {
+	unsigned long events = VFIO_IOMMU_NOTIFY_DMA_UNMAP;
+	struct mdev_state *mdev_state;
+	int ret;
+
 	pr_info("%s\n", __func__);
-	return 0;
+
+	if (!mdev)
+		return -EINVAL;
+
+	mdev_state = mdev_get_drvdata(mdev);
+	if (!mdev_state)
+		return -ENODEV;
+
+	mdev_state->nb.notifier_call = unmap_notifier;
+
+	ret = vfio_register_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY, &events,
+				     &mdev_state->nb);
+	return ret;
 }
 
 static void mtty_close(struct mdev_device *mdev)
 {
+	struct mdev_state *mdev_state;
+
 	pr_info("%s\n", __func__);
+
+	mdev_state = mdev_get_drvdata(mdev);
+	if (!mdev_state)
+		return;
+
+	unpin_pages_all(mdev_state);
+	vfio_unregister_notifier(mdev_dev(mdev), VFIO_IOMMU_NOTIFY,
+				 &mdev_state->nb);
 }
 
 static ssize_t
@@ -1293,8 +1393,82 @@ sample_mdev_dev_show(struct device *dev, struct device_attribute *attr,
 
 static DEVICE_ATTR_RO(sample_mdev_dev);
 
+static ssize_t
+pin_pages_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct mdev_device *mdev = mdev_from_dev(dev);
+	struct mdev_state *mdev_state;
+	int i, count = 0;
+
+	if (!mdev)
+		return -EINVAL;
+
+	mdev_state = mdev_get_drvdata(mdev);
+	if (!mdev_state)
+		return -EINVAL;
+
+	mutex_lock(&mdev_state->ops_lock);
+	for (i = 0; i < MAX_GPFN_COUNT; i++) {
+		if (mdev_state->gpfn_to_hpfn[i] != PFN_NULL)
+			count++;
+	}
+	mutex_unlock(&mdev_state->ops_lock);
+	return sprintf(buf, "Pinned 0x%x pages\n", count);
+}
+
+static ssize_t
+pin_pages_store(struct device *dev, struct device_attribute *attr,
+		const char *buf, size_t count)
+{
+	struct mdev_device *mdev = mdev_from_dev(dev);
+	struct mdev_state *mdev_state;
+	unsigned long gpfn, hpfn;
+	int ret;
+
+	if (!mdev)
+		return -EINVAL;
+
+	mdev_state = mdev_get_drvdata(mdev);
+	if (!mdev_state)
+		return -EINVAL;
+
+	ret = kstrtoul(buf, 0, &gpfn);
+	if (ret)
+		return ret;
+
+	if (gpfn >= MAX_GPFN_COUNT) {
+		pr_err("Error 0x%lx > 0x%lx\n",
+		       gpfn, (unsigned long)MAX_GPFN_COUNT);
+		return -EINVAL;
+	}
+
+	mutex_lock(&mdev_state->ops_lock);
+
+	if (mdev_state->gpfn_to_hpfn[gpfn] != PFN_NULL) {
+		ret = -EEXIST;
+		goto out;
+	}
+
+	ret = vfio_pin_pages(mdev_dev(mdev), &gpfn, 1,
+			     IOMMU_READ | IOMMU_WRITE, &hpfn);
+
+	if (ret <= 0) {
+		pr_err("Failed to pin, ret %d\n", ret);
+		goto out;
+	}
+
+	mdev_state->gpfn_to_hpfn[gpfn] = hpfn;
+	ret = count;
+out:
+	mutex_unlock(&mdev_state->ops_lock);
+	return ret;
+}
+
+static DEVICE_ATTR_RW(pin_pages);
+
 static struct attribute *mdev_dev_attrs[] = {
 	&dev_attr_sample_mdev_dev.attr,
+	&dev_attr_pin_pages.attr,
 	NULL,
 };
 
-- 
2.7.0

