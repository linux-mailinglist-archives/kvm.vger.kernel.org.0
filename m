Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6CBB66DF52
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 14:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbjAQNu0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 08:50:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbjAQNt7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 08:49:59 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A442621A33
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 05:49:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673963391; x=1705499391;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3tu+bI5XmKXqC2Ajzd3Ehhi/Qb+BLxnMybciEIZr7wI=;
  b=jMvhRXoxrtRLzQHH0d5XidodgDW2sH87oteAVE9Tle/LxD53br1FSNw6
   pApcrk97Tt+53KzVn+El1EbePc45CmXXU2AHTYm21Vcg1UGP/W/aptYTh
   eFMXIDaZSUCiM+RrOXTKAN5Yo1ol0UnElFYc44kdeuuMqwvOV+Ee5W7Ye
   Z8qJsGFyzgbuegVzLC1UOzcOBQvqSK4SRITkQT2QomvWBGnQ313w50DED
   cg5LHc5mkKWdXqmjtDp0w/ju75RmZc6+gcgeH/TQDpgu3nqfUpHlPvzgv
   wl7HuT8WM/C/pF/1S5lL8QmjGLs/cR3W8Z6TqYiW9UJO/p0+6wFIXzH90
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="326766394"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="326766394"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2023 05:49:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="652551022"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="652551022"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orsmga007.jf.intel.com with ESMTP; 17 Jan 2023 05:49:49 -0800
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com
Cc:     kevin.tian@intel.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.l.liu@intel.com,
        yi.y.sun@linux.intel.com, peterx@redhat.com, jasowang@redhat.com,
        suravee.suthikulpanit@amd.com
Subject: [PATCH 03/13] vfio: Accept vfio device file in the driver facing kAPI
Date:   Tue, 17 Jan 2023 05:49:32 -0800
Message-Id: <20230117134942.101112-4-yi.l.liu@intel.com>
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

This makes the vfio file kAPIs to accepte vfio device files, also a
preparation for vfio device cdev support.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/vfio.h      |  1 +
 drivers/vfio/vfio_main.c | 51 ++++++++++++++++++++++++++++++++++++----
 2 files changed, 48 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index ef5de2872983..53af6e3ea214 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -18,6 +18,7 @@ struct vfio_container;
 
 struct vfio_device_file {
 	struct vfio_device *device;
+	struct kvm *kvm;
 };
 
 void vfio_device_put_registration(struct vfio_device *device);
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 1aedfbd15ca0..dc08d5dd62cc 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1119,13 +1119,23 @@ const struct file_operations vfio_device_fops = {
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
 
@@ -1140,15 +1150,37 @@ EXPORT_SYMBOL_GPL(vfio_file_is_valid);
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
+		return device_iommu_capable(device->dev,
+					    IOMMU_CAP_ENFORCE_CACHE_COHERENCY);
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
@@ -1157,10 +1189,14 @@ EXPORT_SYMBOL_GPL(vfio_file_enforced_coherent);
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
 
@@ -1173,10 +1209,17 @@ EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
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

