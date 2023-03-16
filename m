Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF4E06BD013
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 13:56:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbjCPM4B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 08:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbjCPMzr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 08:55:47 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43092AD3E;
        Thu, 16 Mar 2023 05:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678971340; x=1710507340;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eeNki2LvUnj1IWV3FOLWyxOn7XkpwVKFwrDqJD+u6f8=;
  b=Ks+aZbZvWKUBwgfY04vwqRHEbSNaUqFIT8tYuGXJo0dKQpGWlNvOomCj
   NqJXJEHWDEPTeJq8Xr9bmJYsNTTjomTFuqdFVAhmdDpuL+KO4+JxrBaLJ
   V1g1/weFJpDlMg1fTXPJSbp+wKjym3nzPjRrOGo4V3xX2Q5hURfGYL34X
   7VuNLhHnpmrfKN2Ch88aHX/AX079x1YS8mA1qkxZ0KmvCIkxcw/K9aSd3
   OvvknoLe9lS8i63DREVsWnm0Q1JBb/YNFLB14CP6C/I4xnm8hMvX7hQlU
   I3lXIvPlbJ2aaLpDfShvWX4HABS+VPudSwFueoEcKCZAWk3eoV/FP6AFL
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10650"; a="336667998"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="336667998"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 05:55:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10650"; a="790277743"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="790277743"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga002.fm.intel.com with ESMTP; 16 Mar 2023 05:55:39 -0700
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
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com
Subject: [PATCH v7 02/22] vfio: Refine vfio file kAPIs for KVM
Date:   Thu, 16 Mar 2023 05:55:14 -0700
Message-Id: <20230316125534.17216-3-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230316125534.17216-1-yi.l.liu@intel.com>
References: <20230316125534.17216-1-yi.l.liu@intel.com>
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

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Terrence Xu <terrence.xu@intel.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/group.c     | 36 ++++++---------------------------
 drivers/vfio/vfio.h      |  2 ++
 drivers/vfio/vfio_main.c | 43 ++++++++++++++++++++++++++++++++++++++++
 virt/kvm/vfio.c          | 10 +++++-----
 4 files changed, 56 insertions(+), 35 deletions(-)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index 8a13cea43f49..ede4723c5f72 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -802,24 +802,11 @@ bool vfio_file_is_group(struct file *file)
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
@@ -837,28 +824,17 @@ bool vfio_file_enforced_coherent(struct file *file)
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
 	spin_lock(&group->kvm_ref_lock);
 	group->kvm = kvm;
 	spin_unlock(&group->kvm_ref_lock);
 }
-EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
 
 bool vfio_group_has_dev(struct vfio_group *group, struct vfio_device *device)
 {
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 250fbd3786c5..56ad127ac618 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -92,6 +92,8 @@ void vfio_device_group_unuse_iommu(struct vfio_device *device);
 void vfio_device_group_close(struct vfio_device *device);
 struct vfio_group *vfio_group_from_file(struct file *file);
 bool vfio_group_has_dev(struct vfio_group *group, struct vfio_device *device);
+bool vfio_group_enforced_coherent(struct vfio_group *group);
+void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm);
 bool vfio_device_has_container(struct vfio_device *device);
 int __init vfio_group_init(void);
 void vfio_group_cleanup(void);
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 89722bf87edc..748bde4d74d9 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1219,6 +1219,49 @@ bool vfio_file_has_dev(struct file *file, struct vfio_device *device)
 }
 EXPORT_SYMBOL_GPL(vfio_file_has_dev);
 
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
+	struct vfio_device *device;
+
+	group = vfio_group_from_file(file);
+	if (group)
+		return vfio_group_enforced_coherent(group);
+
+	device = vfio_device_from_file(file);
+	if (device)
+		return device_iommu_capable(device->dev,
+					    IOMMU_CAP_ENFORCE_CACHE_COHERENCY);
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
diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index 9584eb57e0ed..8bac308ba630 100644
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

