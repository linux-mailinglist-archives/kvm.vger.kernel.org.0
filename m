Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F345F331F2E
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 07:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbhCIGXB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 01:23:01 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:13585 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbhCIGWf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 01:22:35 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DvlSv01FRz17Hqs;
        Tue,  9 Mar 2021 14:20:47 +0800 (CST)
Received: from DESKTOP-7FEPK9S.china.huawei.com (10.174.184.135) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Tue, 9 Mar 2021 14:22:24 +0800
From:   Shenming Lu <lushenming@huawei.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Eric Auger <eric.auger@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <iommu@lists.linux-foundation.org>, <linux-api@vger.kernel.org>
CC:     Kevin Tian <kevin.tian@intel.com>, <yi.l.liu@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Barry Song <song.bao.hua@hisilicon.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>,
        <zhukeqian1@huawei.com>, <lushenming@huawei.com>
Subject: [RFC PATCH v2 6/6] vfio: Add nested IOPF support
Date:   Tue, 9 Mar 2021 14:22:07 +0800
Message-ID: <20210309062207.505-7-lushenming@huawei.com>
X-Mailer: git-send-email 2.27.0.windows.1
In-Reply-To: <20210309062207.505-1-lushenming@huawei.com>
References: <20210309062207.505-1-lushenming@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.184.135]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To set up nested mode, drivers such as vfio_pci have to register
a handler to receive stage/level 1 faults from the IOMMU, but
since currently each device can only have one iommu dev fault
handler, and if stage 2 IOPF is already enabled (VFIO_IOMMU_ENABLE_IOPF),
we choose to update the registered handler (a combined one) via
flags (set IOPF_REPORT_NESTED_L1_CONCERNED), and further deliver
the received stage 1 faults in the handler to the guest through
a newly added vfio_device_ops callback.

Signed-off-by: Shenming Lu <lushenming@huawei.com>
---
 drivers/vfio/vfio.c             | 83 +++++++++++++++++++++++++++++++++
 drivers/vfio/vfio_iommu_type1.c | 37 +++++++++++++++
 include/linux/vfio.h            |  9 ++++
 3 files changed, 129 insertions(+)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 77b29bbd3027..c6a01d947d0d 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -2389,6 +2389,89 @@ int vfio_iommu_dev_fault_handler(struct iommu_fault *fault, void *data)
 }
 EXPORT_SYMBOL_GPL(vfio_iommu_dev_fault_handler);
 
+int vfio_iommu_dev_fault_handler_unregister_nested(struct device *dev)
+{
+	struct vfio_container *container;
+	struct vfio_group *group;
+	struct vfio_iommu_driver *driver;
+	int ret;
+
+	if (!dev)
+		return -EINVAL;
+
+	group = vfio_group_get_from_dev(dev);
+	if (!group)
+		return -ENODEV;
+
+	ret = vfio_group_add_container_user(group);
+	if (ret)
+		goto out;
+
+	container = group->container;
+	driver = container->iommu_driver;
+	if (likely(driver && driver->ops->unregister_hdlr_nested))
+		ret = driver->ops->unregister_hdlr_nested(container->iommu_data,
+							  dev);
+	else
+		ret = -ENOTTY;
+
+	vfio_group_try_dissolve_container(group);
+
+out:
+	vfio_group_put(group);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vfio_iommu_dev_fault_handler_unregister_nested);
+
+/*
+ * Register/Update the VFIO page fault handler
+ * to receive nested stage/level 1 faults.
+ */
+int vfio_iommu_dev_fault_handler_register_nested(struct device *dev)
+{
+	struct vfio_container *container;
+	struct vfio_group *group;
+	struct vfio_iommu_driver *driver;
+	int ret;
+
+	if (!dev)
+		return -EINVAL;
+
+	group = vfio_group_get_from_dev(dev);
+	if (!group)
+		return -ENODEV;
+
+	ret = vfio_group_add_container_user(group);
+	if (ret)
+		goto out;
+
+	container = group->container;
+	driver = container->iommu_driver;
+	if (likely(driver && driver->ops->register_hdlr_nested))
+		ret = driver->ops->register_hdlr_nested(container->iommu_data,
+							dev);
+	else
+		ret = -ENOTTY;
+
+	vfio_group_try_dissolve_container(group);
+
+out:
+	vfio_group_put(group);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vfio_iommu_dev_fault_handler_register_nested);
+
+int vfio_transfer_dev_fault(struct device *dev, struct iommu_fault *fault)
+{
+	struct vfio_device *device = dev_get_drvdata(dev);
+
+	if (unlikely(!device->ops->transfer))
+		return -EOPNOTSUPP;
+
+	return device->ops->transfer(device->device_data, fault);
+}
+EXPORT_SYMBOL_GPL(vfio_transfer_dev_fault);
+
 /**
  * Module/class support
  */
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 8d14ced649a6..62ad4a47de4a 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -3581,6 +3581,13 @@ static int vfio_iommu_type1_dma_map_iopf(void *iommu_data,
 	enum iommu_page_response_code status = IOMMU_PAGE_RESP_INVALID;
 	struct iommu_page_response resp = {0};
 
+	/*
+	 * When configured in nested mode, further deliver
+	 * stage/level 1 faults to the guest.
+	 */
+	if (iommu->nesting && !(fault->prm.flags & IOMMU_FAULT_PAGE_REQUEST_L2))
+		return vfio_transfer_dev_fault(dev, fault);
+
 	mutex_lock(&iommu->lock);
 
 	dma = vfio_find_dma(iommu, iova, PAGE_SIZE);
@@ -3654,6 +3661,34 @@ static int vfio_iommu_type1_dma_map_iopf(void *iommu_data,
 	return 0;
 }
 
+static int vfio_iommu_type1_register_hdlr_nested(void *iommu_data,
+						 struct device *dev)
+{
+	struct vfio_iommu *iommu = iommu_data;
+
+	if (iommu->iopf_enabled)
+		return iommu_update_device_fault_handler(dev, ~0,
+					IOPF_REPORT_NESTED_L1_CONCERNED);
+	else
+		return iommu_register_device_fault_handler(dev,
+					vfio_iommu_dev_fault_handler,
+					IOPF_REPORT_NESTED |
+					IOPF_REPORT_NESTED_L1_CONCERNED,
+					dev);
+}
+
+static int vfio_iommu_type1_unregister_hdlr_nested(void *iommu_data,
+						   struct device *dev)
+{
+	struct vfio_iommu *iommu = iommu_data;
+
+	if (iommu->iopf_enabled)
+		return iommu_update_device_fault_handler(dev,
+					~IOPF_REPORT_NESTED_L1_CONCERNED, 0);
+	else
+		return iommu_unregister_device_fault_handler(dev);
+}
+
 static const struct vfio_iommu_driver_ops vfio_iommu_driver_ops_type1 = {
 	.name			= "vfio-iommu-type1",
 	.owner			= THIS_MODULE,
@@ -3670,6 +3705,8 @@ static const struct vfio_iommu_driver_ops vfio_iommu_driver_ops_type1 = {
 	.group_iommu_domain	= vfio_iommu_type1_group_iommu_domain,
 	.notify			= vfio_iommu_type1_notify,
 	.dma_map_iopf		= vfio_iommu_type1_dma_map_iopf,
+	.register_hdlr_nested	= vfio_iommu_type1_register_hdlr_nested,
+	.unregister_hdlr_nested	= vfio_iommu_type1_unregister_hdlr_nested,
 };
 
 static int __init vfio_iommu_type1_init(void)
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 73af317a4343..60e935e4851b 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -29,6 +29,7 @@
  * @match: Optional device name match callback (return: 0 for no-match, >0 for
  *         match, -errno for abort (ex. match with insufficient or incorrect
  *         additional args)
+ * @transfer: Optional. Transfer the received faults to the guest for nested mode.
  */
 struct vfio_device_ops {
 	char	*name;
@@ -43,6 +44,7 @@ struct vfio_device_ops {
 	int	(*mmap)(void *device_data, struct vm_area_struct *vma);
 	void	(*request)(void *device_data, unsigned int count);
 	int	(*match)(void *device_data, char *buf);
+	int	(*transfer)(void *device_data, struct iommu_fault *fault);
 };
 
 extern struct iommu_group *vfio_iommu_group_get(struct device *dev);
@@ -102,6 +104,10 @@ struct vfio_iommu_driver_ops {
 	int		(*dma_map_iopf)(void *iommu_data,
 					struct iommu_fault *fault,
 					struct device *dev);
+	int		(*register_hdlr_nested)(void *iommu_data,
+						struct device *dev);
+	int		(*unregister_hdlr_nested)(void *iommu_data,
+						  struct device *dev);
 };
 
 extern int vfio_register_iommu_driver(const struct vfio_iommu_driver_ops *ops);
@@ -164,6 +170,9 @@ struct kvm;
 extern void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm);
 
 extern int vfio_iommu_dev_fault_handler(struct iommu_fault *fault, void *data);
+extern int vfio_iommu_dev_fault_handler_unregister_nested(struct device *dev);
+extern int vfio_iommu_dev_fault_handler_register_nested(struct device *dev);
+extern int vfio_transfer_dev_fault(struct device *dev, struct iommu_fault *fault);
 
 /*
  * Sub-module helpers
-- 
2.19.1

