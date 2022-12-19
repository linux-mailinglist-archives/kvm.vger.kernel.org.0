Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9F36508BE
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 09:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbiLSIrp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 03:47:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231596AbiLSIrl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 03:47:41 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32543A1BA
        for <kvm@vger.kernel.org>; Mon, 19 Dec 2022 00:47:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671439660; x=1702975660;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CLQ+4B7UMyeMM/XuhiGdkFvu13fP0IJ7LSgft3Nj9ZA=;
  b=Huh6eF2STqlQYmQ4BKlqFX+Opo6ydft7CF+N5IiWAFtwNlkau6FYbsd/
   td0GY844a+CS7JPz2QwvJrNlkasbM1SJWL1PrDawzxLVu6HutlGu2jveY
   3D0nTf/IzvyvIdJbhbgajSVhQRTJHYdtThUTaHx9sfP7pZ1PRVRIH+zqb
   3LDw8w8knCaq3dyUUaK4t6JGg/VlJL6NhIYt1DHhQxcV+E/JP0anrGgx+
   ggJeOq1e+ZUWayVazl7/r+4KJjFnHACm/Djt5PEAbHtlBVgPz4s9tjFnU
   L/ydj936SjYFTyvI3mwFAhwzjvjSokJoZWlsq/iaPy99gOTX/XblDyktq
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="381528450"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="381528450"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 00:47:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="628233757"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="628233757"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga006.jf.intel.com with ESMTP; 19 Dec 2022 00:47:39 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com, peterx@redhat.com, jasowang@redhat.com
Subject: [RFC 03/12] vfio: Accept vfio device file in the driver facing kAPI
Date:   Mon, 19 Dec 2022 00:47:09 -0800
Message-Id: <20221219084718.9342-4-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221219084718.9342-1-yi.l.liu@intel.com>
References: <20221219084718.9342-1-yi.l.liu@intel.com>
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

This makes the vfio file kAPIs to accepte vfio device files, also a
preparation for vfio device cdev support.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/vfio.h      |  1 +
 drivers/vfio/vfio_main.c | 64 +++++++++++++++++++++++++++++++++++++---
 2 files changed, 61 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 69d0fd7e351e..f0e411995997 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -18,6 +18,7 @@ struct vfio_container;
 
 struct vfio_device_file {
 	struct vfio_device *device;
+	struct kvm *kvm;
 };
 
 void vfio_device_put_registration(struct vfio_device *device);
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 7d13c5f0bfab..481502a6964a 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1029,16 +1029,40 @@ const struct file_operations vfio_device_fops = {
 	.mmap		= vfio_device_fops_mmap,
 };
 
+static struct vfio_device *vfio_device_from_file(struct file *file)
+{
+	struct vfio_device_file *df = file->private_data;
+
+	if (file->f_op != &vfio_device_fops)
+		return NULL;
+	return df->device;
+}
+
 /**
  * vfio_file_is_valid - True if the file is usable with VFIO aPIS
  * @file: VFIO group file or VFIO device file
  */
 bool vfio_file_is_valid(struct file *file)
 {
-	return vfio_group_from_file(file);
+	return vfio_group_from_file(file) ||
+	       vfio_device_from_file(file);
 }
 EXPORT_SYMBOL_GPL(vfio_file_is_valid);
 
+static bool vfio_device_enforced_coherent(struct vfio_device *device)
+{
+	bool ret;
+
+	if (!vfio_device_try_get_registration(device))
+		return true;
+
+	ret = device_iommu_capable(device->dev,
+				   IOMMU_CAP_ENFORCE_CACHE_COHERENCY);
+
+	vfio_device_put_registration(device);
+	return ret;
+}
+
 /**
  * vfio_file_enforced_coherent - True if the DMA associated with the VFIO file
  *        is always CPU cache coherent
@@ -1050,15 +1074,36 @@ EXPORT_SYMBOL_GPL(vfio_file_is_valid);
  */
 bool vfio_file_enforced_coherent(struct file *file)
 {
-	struct vfio_group *group = vfio_group_from_file(file);
+	struct vfio_group *group;
+	struct vfio_device *device;
 
+	group = vfio_group_from_file(file);
 	if (group)
 		return vfio_group_enforced_coherent(group);
 
+	device = vfio_device_from_file(file);
+	if (device)
+		return vfio_device_enforced_coherent(device);
+
 	return true;
 }
 EXPORT_SYMBOL_GPL(vfio_file_enforced_coherent);
 
+static void vfio_device_file_set_kvm(struct file *file, struct kvm *kvm)
+{
+	struct vfio_device_file *df = file->private_data;
+	struct vfio_device *device = df->device;
+
+	/*
+	 * The kvm is first recorded in the df, and will be propagated
+	 * to vfio_device::kvm when the file binds iommufd successfully in
+	 * the vfio device cdev path.
+	 */
+	mutex_lock(&device->dev_set->lock);
+	df->kvm = kvm;
+	mutex_unlock(&device->dev_set->lock);
+}
+
 /**
  * vfio_file_set_kvm - Link a kvm with VFIO drivers
  * @file: VFIO group file or device file
@@ -1067,10 +1112,14 @@ EXPORT_SYMBOL_GPL(vfio_file_enforced_coherent);
  */
 void vfio_file_set_kvm(struct file *file, struct kvm *kvm)
 {
-	struct vfio_group *group = vfio_group_from_file(file);
+	struct vfio_group *group;
 
+	group = vfio_group_from_file(file);
 	if (group)
 		vfio_group_set_kvm(group, kvm);
+
+	if (vfio_device_from_file(file))
+		vfio_device_file_set_kvm(file, kvm);
 }
 EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
 
@@ -1083,10 +1132,17 @@ EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
  */
 bool vfio_file_has_dev(struct file *file, struct vfio_device *device)
 {
-	struct vfio_group *group = vfio_group_from_file(file);
+	struct vfio_group *group;
+	struct vfio_device *vdev;
 
+	group = vfio_group_from_file(file);
 	if (group)
 		return vfio_group_has_dev(group, device);
+
+	vdev = vfio_device_from_file(file);
+	if (device)
+		return vdev == device;
+
 	return false;
 }
 EXPORT_SYMBOL_GPL(vfio_file_has_dev);
-- 
2.34.1

