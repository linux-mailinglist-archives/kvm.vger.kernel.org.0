Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51B616D3181
	for <lists+kvm@lfdr.de>; Sat,  1 Apr 2023 16:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbjDAOon (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Apr 2023 10:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbjDAOoh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Apr 2023 10:44:37 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3A61EFDF;
        Sat,  1 Apr 2023 07:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680360276; x=1711896276;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YnqwCmUnJONgJFdKsiHKUFDBA391yTcmtY6vXjL8rkQ=;
  b=do/TFGCButuEbNH1P+6buzg+ezIftyLw7y1EH+Aqn/FdR9KcLFSB/eas
   /qHr8cOJiQg+TPuZ8CCeE/0KL6lE8kCwPtDytCw5zXJQ0KZeKMT5A41IA
   EcDPrd9JpOpH19rfh+Yf3TwPocJ2XoGlgMpqTVcpSEU2HzNI2w9FaMchX
   zRatX43KhJmB00aobolPzzZuL/tKp9WvShhMkS/kXRvFKmLJ0//8a8poJ
   ST6wq0gQ7lL2fgq5aBL/pbYwSqSur4LftkUOhZJ4pMV3/bzeZxDU8x/O9
   jY4RGimPtt+Zt+jTEXo9/B92J+h1E9ypnsbLRGyR2vtQXOltkI7v4w105
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10667"; a="340385119"
X-IronPort-AV: E=Sophos;i="5.98,310,1673942400"; 
   d="scan'208";a="340385119"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2023 07:44:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10667"; a="662705837"
X-IronPort-AV: E=Sophos;i="5.98,310,1673942400"; 
   d="scan'208";a="662705837"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga006.jf.intel.com with ESMTP; 01 Apr 2023 07:44:35 -0700
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com, kevin.tian@intel.com
Cc:     joro@8bytes.org, robin.murphy@arm.com, cohuck@redhat.com,
        eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
        mjrosato@linux.ibm.com, chao.p.peng@linux.intel.com,
        yi.l.liu@intel.com, yi.y.sun@linux.intel.com, peterx@redhat.com,
        jasowang@redhat.com, shameerali.kolothum.thodi@huawei.com,
        lulu@redhat.com, suravee.suthikulpanit@amd.com,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com
Subject: [PATCH v3 06/12] vfio: Refine vfio file kAPIs for vfio PCI hot reset
Date:   Sat,  1 Apr 2023 07:44:23 -0700
Message-Id: <20230401144429.88673-7-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230401144429.88673-1-yi.l.liu@intel.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This prepares vfio core to accept vfio device file from the vfio PCI
hot reset path. vfio_file_is_group() is still kept for KVM usage.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/group.c             | 32 ++++++++++++++------------------
 drivers/vfio/pci/vfio_pci_core.c |  4 ++--
 drivers/vfio/vfio.h              |  2 ++
 drivers/vfio/vfio_main.c         | 29 +++++++++++++++++++++++++++++
 include/linux/vfio.h             |  1 +
 5 files changed, 48 insertions(+), 20 deletions(-)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index 27d5ba7cf9dc..d0c95d033605 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -745,6 +745,15 @@ bool vfio_device_has_container(struct vfio_device *device)
 	return device->group->container;
 }
 
+struct vfio_group *vfio_group_from_file(struct file *file)
+{
+	struct vfio_group *group = file->private_data;
+
+	if (file->f_op != &vfio_group_fops)
+		return NULL;
+	return group;
+}
+
 /**
  * vfio_file_iommu_group - Return the struct iommu_group for the vfio group file
  * @file: VFIO group file
@@ -755,13 +764,13 @@ bool vfio_device_has_container(struct vfio_device *device)
  */
 struct iommu_group *vfio_file_iommu_group(struct file *file)
 {
-	struct vfio_group *group = file->private_data;
+	struct vfio_group *group = vfio_group_from_file(file);
 	struct iommu_group *iommu_group = NULL;
 
 	if (!IS_ENABLED(CONFIG_SPAPR_TCE_IOMMU))
 		return NULL;
 
-	if (!vfio_file_is_group(file))
+	if (!group)
 		return NULL;
 
 	mutex_lock(&group->group_lock);
@@ -775,12 +784,12 @@ struct iommu_group *vfio_file_iommu_group(struct file *file)
 EXPORT_SYMBOL_GPL(vfio_file_iommu_group);
 
 /**
- * vfio_file_is_group - True if the file is usable with VFIO aPIS
+ * vfio_file_is_group - True if the file is a vfio group file
  * @file: VFIO group file
  */
 bool vfio_file_is_group(struct file *file)
 {
-	return file->f_op == &vfio_group_fops;
+	return vfio_group_from_file(file);
 }
 EXPORT_SYMBOL_GPL(vfio_file_is_group);
 
@@ -842,23 +851,10 @@ void vfio_file_set_kvm(struct file *file, struct kvm *kvm)
 }
 EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
 
-/**
- * vfio_file_has_dev - True if the VFIO file is a handle for device
- * @file: VFIO file to check
- * @device: Device that must be part of the file
- *
- * Returns true if given file has permission to manipulate the given device.
- */
-bool vfio_file_has_dev(struct file *file, struct vfio_device *device)
+bool vfio_group_has_dev(struct vfio_group *group, struct vfio_device *device)
 {
-	struct vfio_group *group = file->private_data;
-
-	if (!vfio_file_is_group(file))
-		return false;
-
 	return group == device->group;
 }
-EXPORT_SYMBOL_GPL(vfio_file_has_dev);
 
 static char *vfio_devnode(const struct device *dev, umode_t *mode)
 {
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index b68fcba67a4b..2a510b71edcb 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1308,8 +1308,8 @@ vfio_pci_ioctl_pci_hot_reset_groups(struct vfio_pci_core_device *vdev,
 			break;
 		}
 
-		/* Ensure the FD is a vfio group FD.*/
-		if (!vfio_file_is_group(file)) {
+		/* Ensure the FD is a vfio FD. vfio group or vfio device */
+		if (!vfio_file_is_valid(file)) {
 			fput(file);
 			ret = -EINVAL;
 			break;
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 7b19c621e0e6..c0aeea24fbd6 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -84,6 +84,8 @@ void vfio_device_group_unregister(struct vfio_device *device);
 int vfio_device_group_use_iommu(struct vfio_device *device);
 void vfio_device_group_unuse_iommu(struct vfio_device *device);
 void vfio_device_group_close(struct vfio_device *device);
+struct vfio_group *vfio_group_from_file(struct file *file);
+bool vfio_group_has_dev(struct vfio_group *group, struct vfio_device *device);
 bool vfio_device_has_container(struct vfio_device *device);
 int __init vfio_group_init(void);
 void vfio_group_cleanup(void);
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 89497c933490..fe7446805afd 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1154,6 +1154,35 @@ const struct file_operations vfio_device_fops = {
 	.mmap		= vfio_device_fops_mmap,
 };
 
+/**
+ * vfio_file_is_valid - True if the file is valid vfio file
+ * @file: VFIO group file or VFIO device file
+ */
+bool vfio_file_is_valid(struct file *file)
+{
+	return vfio_group_from_file(file);
+}
+EXPORT_SYMBOL_GPL(vfio_file_is_valid);
+
+/**
+ * vfio_file_has_dev - True if the VFIO file is a handle for device
+ * @file: VFIO file to check
+ * @device: Device that must be part of the file
+ *
+ * Returns true if given file has permission to manipulate the given device.
+ */
+bool vfio_file_has_dev(struct file *file, struct vfio_device *device)
+{
+	struct vfio_group *group;
+
+	group = vfio_group_from_file(file);
+	if (!group)
+		return false;
+
+	return vfio_group_has_dev(group, device);
+}
+EXPORT_SYMBOL_GPL(vfio_file_has_dev);
+
 /*
  * Sub-module support
  */
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 97a1174b922f..f8fb9ab25188 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -258,6 +258,7 @@ int vfio_mig_get_next_state(struct vfio_device *device,
  */
 struct iommu_group *vfio_file_iommu_group(struct file *file);
 bool vfio_file_is_group(struct file *file);
+bool vfio_file_is_valid(struct file *file);
 bool vfio_file_enforced_coherent(struct file *file);
 void vfio_file_set_kvm(struct file *file, struct kvm *kvm);
 bool vfio_file_has_dev(struct file *file, struct vfio_device *device);
-- 
2.34.1

