Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6983866DF54
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 14:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbjAQNu3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 08:50:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230392AbjAQNt7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 08:49:59 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 734653B3F9
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 05:49:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673963389; x=1705499389;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xZCDLpcAU+pgu0tfTQfQ6zxZJmCJs2fpuoPmOAEP5GE=;
  b=mZIwp0XBrGvPHKMgJaHkZOiAKBTwOApAl0SJdJ+Qqw7mlUq1vxuXeisT
   1wqGTeHKHhsE/rq5WE8abavCiCnbNax8Oj4VkekKD6ltlYDei/VDtilbo
   ymZzGOtzW4ZijMb8bkdJGNNIRuhmsRNsBcel72JhsitG/4C+WT+/FeB7K
   yB9DarVbN06Sjr1LfqsTnwo8Vzmwz3UNqHUsvIg854PSepU3S9qc697ft
   ZvuXSm7CDiIl9ikTWrSuGYjxOo+kc3WJshhP01s5Spm+GzDKeDZQZTkOQ
   acbfSLEW7lZz9wRIpb9D3bj8hTu579vdJua5Mx8QIyg9idCcGwYbjN0PK
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="326766386"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="326766386"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2023 05:49:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="652551017"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="652551017"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga007.jf.intel.com with ESMTP; 17 Jan 2023 05:49:48 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com, peterx@redhat.com, jasowang@redhat.com,
        suravee.suthikulpanit@amd.com
Subject: [PATCH 02/13] vfio: Refine vfio file kAPIs
Date:   Tue, 17 Jan 2023 05:49:31 -0800
Message-Id: <20230117134942.101112-3-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230117134942.101112-1-yi.l.liu@intel.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This prepares for making the below kAPIs to accept both group file
and device file instead of only vfio group file.

  bool vfio_file_enforced_coherent(struct file *file);
  void vfio_file_set_kvm(struct file *file, struct kvm *kvm);
  bool vfio_file_has_dev(struct file *file, struct vfio_device *device);

Besides above change, vfio_file_is_group() is renamed to be
vfio_file_is_valid().

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/group.c             | 74 ++++++++------------------------
 drivers/vfio/pci/vfio_pci_core.c |  4 +-
 drivers/vfio/vfio.h              |  4 ++
 drivers/vfio/vfio_main.c         | 62 ++++++++++++++++++++++++++
 include/linux/vfio.h             |  2 +-
 virt/kvm/vfio.c                  | 10 ++---
 6 files changed, 92 insertions(+), 64 deletions(-)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index 8fdb7e35b0a6..d83cf069d290 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -721,6 +721,15 @@ bool vfio_device_has_container(struct vfio_device *device)
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
@@ -731,13 +740,13 @@ bool vfio_device_has_container(struct vfio_device *device)
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
@@ -750,34 +759,11 @@ struct iommu_group *vfio_file_iommu_group(struct file *file)
 }
 EXPORT_SYMBOL_GPL(vfio_file_iommu_group);
 
-/**
- * vfio_file_is_group - True if the file is usable with VFIO aPIS
- * @file: VFIO group file
- */
-bool vfio_file_is_group(struct file *file)
-{
-	return file->f_op == &vfio_group_fops;
-}
-EXPORT_SYMBOL_GPL(vfio_file_is_group);
-
-/**
- * vfio_file_enforced_coherent - True if the DMA associated with the VFIO file
- *        is always CPU cache coherent
- * @file: VFIO group file
- *
- * Enforced coherency means that the IOMMU ignores things like the PCIe no-snoop
- * bit in DMA transactions. A return of false indicates that the user has
- * rights to access additional instructions such as wbinvd on x86.
- */
-bool vfio_file_enforced_coherent(struct file *file)
+bool vfio_group_enforced_coherent(struct vfio_group *group)
 {
-	struct vfio_group *group = file->private_data;
 	struct vfio_device *device;
 	bool ret = true;
 
-	if (!vfio_file_is_group(file))
-		return true;
-
 	/*
 	 * If the device does not have IOMMU_CAP_ENFORCE_CACHE_COHERENCY then
 	 * any domain later attached to it will also not support it. If the cap
@@ -795,46 +781,22 @@ bool vfio_file_enforced_coherent(struct file *file)
 	mutex_unlock(&group->device_lock);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(vfio_file_enforced_coherent);
 
-/**
- * vfio_file_set_kvm - Link a kvm with VFIO drivers
- * @file: VFIO group file
- * @kvm: KVM to link
- *
- * When a VFIO device is first opened the KVM will be available in
- * device->kvm if one was associated with the group.
- */
-void vfio_file_set_kvm(struct file *file, struct kvm *kvm)
+void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm)
 {
-	struct vfio_group *group = file->private_data;
-
-	if (!vfio_file_is_group(file))
-		return;
-
+	/*
+	 * When a VFIO device is first opened the KVM will be available in
+	 * device->kvm if one was associated with the group.
+	 */
 	mutex_lock(&group->group_lock);
 	group->kvm = kvm;
 	mutex_unlock(&group->group_lock);
 }
-EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
 
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
index 26a541cc64d1..985c6184a587 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1319,8 +1319,8 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 			break;
 		}
 
-		/* Ensure the FD is a vfio group FD.*/
-		if (!vfio_file_is_group(file)) {
+		/* Ensure the FD is a vfio FD.*/
+		if (!vfio_file_is_valid(file)) {
 			fput(file);
 			ret = -EINVAL;
 			break;
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 1091806bc89d..ef5de2872983 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -90,6 +90,10 @@ void vfio_device_group_unregister(struct vfio_device *device);
 int vfio_device_group_use_iommu(struct vfio_device *device);
 void vfio_device_group_unuse_iommu(struct vfio_device *device);
 void vfio_device_group_close(struct vfio_device *device);
+struct vfio_group *vfio_group_from_file(struct file *file);
+bool vfio_group_enforced_coherent(struct vfio_group *group);
+void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm);
+bool vfio_group_has_dev(struct vfio_group *group, struct vfio_device *device);
 bool vfio_device_has_container(struct vfio_device *device);
 int __init vfio_group_init(void);
 void vfio_group_cleanup(void);
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index ee54c9ae0af4..1aedfbd15ca0 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1119,6 +1119,68 @@ const struct file_operations vfio_device_fops = {
 	.mmap		= vfio_device_fops_mmap,
 };
 
+/**
+ * vfio_file_is_valid - True if the file is usable with VFIO aPIS
+ * @file: VFIO group file or VFIO device file
+ */
+bool vfio_file_is_valid(struct file *file)
+{
+	return vfio_group_from_file(file);
+}
+EXPORT_SYMBOL_GPL(vfio_file_is_valid);
+
+/**
+ * vfio_file_enforced_coherent - True if the DMA associated with the VFIO file
+ *        is always CPU cache coherent
+ * @file: VFIO group or device file
+ *
+ * Enforced coherency means that the IOMMU ignores things like the PCIe no-snoop
+ * bit in DMA transactions. A return of false indicates that the user has
+ * rights to access additional instructions such as wbinvd on x86.
+ */
+bool vfio_file_enforced_coherent(struct file *file)
+{
+	struct vfio_group *group = vfio_group_from_file(file);
+
+	if (group)
+		return vfio_group_enforced_coherent(group);
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(vfio_file_enforced_coherent);
+
+/**
+ * vfio_file_set_kvm - Link a kvm with VFIO drivers
+ * @file: VFIO group file or device file
+ * @kvm: KVM to link
+ *
+ */
+void vfio_file_set_kvm(struct file *file, struct kvm *kvm)
+{
+	struct vfio_group *group = vfio_group_from_file(file);
+
+	if (group)
+		vfio_group_set_kvm(group, kvm);
+}
+EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
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
+	struct vfio_group *group = vfio_group_from_file(file);
+
+	if (group)
+		return vfio_group_has_dev(group, device);
+	return false;
+}
+EXPORT_SYMBOL_GPL(vfio_file_has_dev);
+
 /*
  * Sub-module support
  */
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 35be78e9ae57..46edd6e6c0ba 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -241,7 +241,7 @@ int vfio_mig_get_next_state(struct vfio_device *device,
  * External user API
  */
 struct iommu_group *vfio_file_iommu_group(struct file *file);
-bool vfio_file_is_group(struct file *file);
+bool vfio_file_is_valid(struct file *file);
 bool vfio_file_enforced_coherent(struct file *file);
 void vfio_file_set_kvm(struct file *file, struct kvm *kvm);
 bool vfio_file_has_dev(struct file *file, struct vfio_device *device);
diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index 495ceabffe88..868930c7a59b 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -64,18 +64,18 @@ static bool kvm_vfio_file_enforced_coherent(struct file *file)
 	return ret;
 }
 
-static bool kvm_vfio_file_is_group(struct file *file)
+static bool kvm_vfio_file_is_valid(struct file *file)
 {
 	bool (*fn)(struct file *file);
 	bool ret;
 
-	fn = symbol_get(vfio_file_is_group);
+	fn = symbol_get(vfio_file_is_valid);
 	if (!fn)
 		return false;
 
 	ret = fn(file);
 
-	symbol_put(vfio_file_is_group);
+	symbol_put(vfio_file_is_valid);
 
 	return ret;
 }
@@ -154,8 +154,8 @@ static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
 	if (!filp)
 		return -EBADF;
 
-	/* Ensure the FD is a vfio group FD.*/
-	if (!kvm_vfio_file_is_group(filp)) {
+	/* Ensure the FD is a vfio FD.*/
+	if (!kvm_vfio_file_is_valid(filp)) {
 		ret = -EINVAL;
 		goto err_fput;
 	}
-- 
2.34.1

