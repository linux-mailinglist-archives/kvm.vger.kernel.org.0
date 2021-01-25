Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF41F302342
	for <lists+kvm@lfdr.de>; Mon, 25 Jan 2021 10:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbhAYJbz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jan 2021 04:31:55 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:11862 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbhAYJ31 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 04:29:27 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DPP6m65prz7Znb;
        Mon, 25 Jan 2021 17:03:44 +0800 (CST)
Received: from DESKTOP-7FEPK9S.china.huawei.com (10.174.186.182) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Mon, 25 Jan 2021 17:04:48 +0800
From:   Shenming Lu <lushenming@huawei.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Eric Auger <eric.auger@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>,
        <lushenming@huawei.com>
Subject: [RFC PATCH v1 3/4] vfio: Try to enable IOPF for VFIO devices
Date:   Mon, 25 Jan 2021 17:04:01 +0800
Message-ID: <20210125090402.1429-4-lushenming@huawei.com>
X-Mailer: git-send-email 2.27.0.windows.1
In-Reply-To: <20210125090402.1429-1-lushenming@huawei.com>
References: <20210125090402.1429-1-lushenming@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.186.182]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If IOMMU_DEV_FEAT_IOPF is set for the VFIO device, which means that
the delivering of page faults of this device from the IOMMU is enabled,
we register the VFIO page fault handler to complete the whole faulting
path (HW+SW). And add a iopf_enabled field in struct vfio_device to
record it.

Signed-off-by: Shenming Lu <lushenming@huawei.com>
---
 drivers/vfio/vfio.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index ff7797260d0f..fd885d99ee0f 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -97,6 +97,7 @@ struct vfio_device {
 	struct vfio_group		*group;
 	struct list_head		group_next;
 	void				*device_data;
+	bool				iopf_enabled;
 };
 
 #ifdef CONFIG_VFIO_NOIOMMU
@@ -532,6 +533,21 @@ static struct vfio_group *vfio_group_get_from_dev(struct device *dev)
 /**
  * Device objects - create, release, get, put, search
  */
+
+static void vfio_device_enable_iopf(struct vfio_device *device)
+{
+	struct device *dev = device->dev;
+
+	if (!iommu_dev_has_feature(dev, IOMMU_DEV_FEAT_IOPF))
+		return;
+
+	if (WARN_ON(iommu_register_device_fault_handler(dev,
+					vfio_iommu_dev_fault_handler, dev)))
+		return;
+
+	device->iopf_enabled = true;
+}
+
 static
 struct vfio_device *vfio_group_create_device(struct vfio_group *group,
 					     struct device *dev,
@@ -549,6 +565,8 @@ struct vfio_device *vfio_group_create_device(struct vfio_group *group,
 	device->group = group;
 	device->ops = ops;
 	device->device_data = device_data;
+	/* By default try to enable IOPF */
+	vfio_device_enable_iopf(device);
 	dev_set_drvdata(dev, device);
 
 	/* No need to get group_lock, caller has group reference */
@@ -573,6 +591,8 @@ static void vfio_device_release(struct kref *kref)
 	mutex_unlock(&group->device_lock);
 
 	dev_set_drvdata(device->dev, NULL);
+	if (device->iopf_enabled)
+		WARN_ON(iommu_unregister_device_fault_handler(device->dev));
 
 	kfree(device);
 
-- 
2.19.1

