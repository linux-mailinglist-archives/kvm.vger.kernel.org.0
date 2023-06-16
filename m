Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1B65732C31
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 11:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344052AbjFPJki (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 05:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343872AbjFPJjy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 05:39:54 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 256A12728;
        Fri, 16 Jun 2023 02:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686908393; x=1718444393;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=75yOAnfFQYXol7+/zRc9bLgt67cNmgu3dtj/juK5NKk=;
  b=DI85DYOlUoDkGZU2Gmqb+xjAjD4jwY/7OBBECZrDs9r1nB3JzXqIU360
   JFXATfgdC9TH7iAkzvVK5jscZGCDi10r8viBvj1vxs4JAodLYAWxtGtyT
   foJsG2IyhrzTHE+38OVhQzguZxlwKeQ/ddGkah5mh72RQyoikhug8rzb8
   ue+0WHUQn4LdDgcI2wRZP8gK3QmT5Kg5VbwJ9PzvPgJAr25P0G8UTVvll
   Naaa3l1mqFVUT/rna+97bbMZPgO510EwWcVQK5KWUTB+deDqPsuRmJeWQ
   TRo+Duf9y5HwY/zz8ZtyAThD6IuFyh5W5D9C1RanZcFuHNwqjsh73yhBh
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="361700132"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="361700132"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 02:39:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="715951002"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="715951002"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga007.fm.intel.com with ESMTP; 16 Jun 2023 02:39:51 -0700
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
        yanting.jiang@intel.com, zhenzhong.duan@intel.com,
        clegoate@redhat.com
Subject: [PATCH v13 02/22] vfio: Refine vfio file kAPIs for KVM
Date:   Fri, 16 Jun 2023 02:39:26 -0700
Message-Id: <20230616093946.68711-3-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230616093946.68711-1-yi.l.liu@intel.com>
References: <20230616093946.68711-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This prepares for making the below kAPIs to accept both group file
and device file instead of only vfio group file.

  bool vfio_file_enforced_coherent(struct file *file);
  void vfio_file_set_kvm(struct file *file, struct kvm *kvm);

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Terrence Xu <terrence.xu@intel.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/group.c     | 53 +++++++++++++---------------------------
 drivers/vfio/vfio.h      |  3 +++
 drivers/vfio/vfio_main.c | 49 +++++++++++++++++++++++++++++++++++++
 include/linux/vfio.h     |  1 +
 virt/kvm/vfio.c          | 10 ++++----
 5 files changed, 75 insertions(+), 41 deletions(-)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index fbba9fc15e57..b56e19d2a02d 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -754,6 +754,15 @@ bool vfio_device_has_container(struct vfio_device *device)
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
@@ -764,13 +773,13 @@ bool vfio_device_has_container(struct vfio_device *device)
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
@@ -784,33 +793,20 @@ struct iommu_group *vfio_file_iommu_group(struct file *file)
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
@@ -828,28 +824,13 @@ bool vfio_file_enforced_coherent(struct file *file)
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
 	spin_lock(&group->kvm_ref_lock);
 	group->kvm = kvm;
 	spin_unlock(&group->kvm_ref_lock);
 }
-EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
 
 /**
  * vfio_file_has_dev - True if the VFIO file is a handle for device
@@ -860,9 +841,9 @@ EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
  */
 bool vfio_file_has_dev(struct file *file, struct vfio_device *device)
 {
-	struct vfio_group *group = file->private_data;
+	struct vfio_group *group = vfio_group_from_file(file);
 
-	if (!vfio_file_is_group(file))
+	if (!group)
 		return false;
 
 	return group == device->group;
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 87d3dd6b9ef9..b1e327a85a32 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -90,6 +90,9 @@ void vfio_device_group_unregister(struct vfio_device *device);
 int vfio_device_group_use_iommu(struct vfio_device *device);
 void vfio_device_group_unuse_iommu(struct vfio_device *device);
 void vfio_device_group_close(struct vfio_device *device);
+struct vfio_group *vfio_group_from_file(struct file *file);
+bool vfio_group_enforced_coherent(struct vfio_group *group);
+void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm);
 bool vfio_device_has_container(struct vfio_device *device);
 int __init vfio_group_init(void);
 void vfio_group_cleanup(void);
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 39c1158ffef0..4665791aa2eb 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1190,6 +1190,55 @@ const struct file_operations vfio_device_fops = {
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
+ * vfio_file_enforced_coherent - True if the DMA associated with the VFIO file
+ *        is always CPU cache coherent
+ * @file: VFIO group file or VFIO device file
+ *
+ * Enforced coherency means that the IOMMU ignores things like the PCIe no-snoop
+ * bit in DMA transactions. A return of false indicates that the user has
+ * rights to access additional instructions such as wbinvd on x86.
+ */
+bool vfio_file_enforced_coherent(struct file *file)
+{
+	struct vfio_group *group;
+
+	group = vfio_group_from_file(file);
+	if (group)
+		return vfio_group_enforced_coherent(group);
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(vfio_file_enforced_coherent);
+
+/**
+ * vfio_file_set_kvm - Link a kvm with VFIO drivers
+ * @file: VFIO group file or VFIO device file
+ * @kvm: KVM to link
+ *
+ * When a VFIO device is first opened the KVM will be available in
+ * device->kvm if one was associated with the file.
+ */
+void vfio_file_set_kvm(struct file *file, struct kvm *kvm)
+{
+	struct vfio_group *group;
+
+	group = vfio_group_from_file(file);
+	if (group)
+		vfio_group_set_kvm(group, kvm);
+}
+EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
+
 /*
  * Sub-module support
  */
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 7079911edfb1..06a5221949c5 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -272,6 +272,7 @@ int vfio_mig_get_next_state(struct vfio_device *device,
  */
 struct iommu_group *vfio_file_iommu_group(struct file *file);
 bool vfio_file_is_group(struct file *file);
+bool vfio_file_is_valid(struct file *file);
 bool vfio_file_enforced_coherent(struct file *file);
 void vfio_file_set_kvm(struct file *file, struct kvm *kvm);
 bool vfio_file_has_dev(struct file *file, struct vfio_device *device);
diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index 9584eb57e0ed..b33c7b8488b3 100644
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
+	/* Ensure the FD is a vfio FD. */
+	if (!kvm_vfio_file_is_valid(filp)) {
 		ret = -EINVAL;
 		goto err_fput;
 	}
-- 
2.34.1

