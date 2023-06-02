Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11E6B72019C
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 14:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235325AbjFBMRT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 08:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjFBMRN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 08:17:13 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F0E61B9;
        Fri,  2 Jun 2023 05:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685708232; x=1717244232;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=L+P/q3b3LFmumsK5DCjc9ezErZRHT0KUeIQ5K0Z6vO8=;
  b=SNcmWWAbu/PFqclWDrlcGwU0Jkt0CVADVIc1dZugR3W8C5eN+J0+7Uur
   AaUEFMy9sog7mwdSPqXUzsMKlPY97IuatQE+NMqBL8WSClUYoJZAqcO03
   HSyS7gOy6t1UL+pXw24yQIqAu7OudoyXZE2g7jFLVvEFeRd7oDqKmhtFV
   I7V4B+kserdjJMwqTGs5lis0qcfiKqmGHe19IIgZ4rJfCI6jF3V0wqYrK
   q/PFpfBdTkJ0dB8nwJ6B6+bn3PFPnuGfSZS3paM5BZW/KxOyGXyBQRL+w
   QiYyF4imzztVbCZutYfblN3BGIiGTgAH+64RsiownJzu9Mrx4JKGTqsJW
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="384136493"
X-IronPort-AV: E=Sophos;i="6.00,212,1681196400"; 
   d="scan'208";a="384136493"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 05:16:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="1037947260"
X-IronPort-AV: E=Sophos;i="6.00,212,1681196400"; 
   d="scan'208";a="1037947260"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga005.fm.intel.com with ESMTP; 02 Jun 2023 05:16:57 -0700
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
Subject: [PATCH v12 03/24] vfio: Accept vfio device file in the KVM facing kAPI
Date:   Fri,  2 Jun 2023 05:16:32 -0700
Message-Id: <20230602121653.80017-4-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230602121653.80017-1-yi.l.liu@intel.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This makes the vfio file kAPIs to accept vfio device files, also a
preparation for vfio device cdev support.

For the kvm set with vfio device file, kvm pointer is stored in struct
vfio_device_file, and use kvm_ref_lock to protect kvm set and kvm
pointer usage within VFIO. This kvm pointer will be set to vfio_device
after device file is bound to iommufd in the cdev path.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Terrence Xu <terrence.xu@intel.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Tested-by: Yanting Jiang <yanting.jiang@intel.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/vfio.h      |  2 ++
 drivers/vfio/vfio_main.c | 36 +++++++++++++++++++++++++++++++++++-
 2 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index b1e327a85a32..69e1a0692b06 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -18,6 +18,8 @@ struct vfio_container;
 
 struct vfio_device_file {
 	struct vfio_device *device;
+	spinlock_t kvm_ref_lock; /* protect kvm field */
+	struct kvm *kvm;
 };
 
 void vfio_device_put_registration(struct vfio_device *device);
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 4665791aa2eb..8ef9210ad2aa 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -429,6 +429,7 @@ vfio_allocate_device_file(struct vfio_device *device)
 		return ERR_PTR(-ENOMEM);
 
 	df->device = device;
+	spin_lock_init(&df->kvm_ref_lock);
 
 	return df;
 }
@@ -1190,13 +1191,23 @@ const struct file_operations vfio_device_fops = {
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
  * vfio_file_is_valid - True if the file is valid vfio file
  * @file: VFIO group file or VFIO device file
  */
 bool vfio_file_is_valid(struct file *file)
 {
-	return vfio_group_from_file(file);
+	return vfio_group_from_file(file) ||
+	       vfio_device_from_file(file);
 }
 EXPORT_SYMBOL_GPL(vfio_file_is_valid);
 
@@ -1211,16 +1222,36 @@ EXPORT_SYMBOL_GPL(vfio_file_is_valid);
  */
 bool vfio_file_enforced_coherent(struct file *file)
 {
+	struct vfio_device *device;
 	struct vfio_group *group;
 
 	group = vfio_group_from_file(file);
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
+
+	/*
+	 * The kvm is first recorded in the vfio_device_file, and will
+	 * be propagated to vfio_device::kvm when the file is bound to
+	 * iommufd successfully in the vfio device cdev path.
+	 */
+	spin_lock(&df->kvm_ref_lock);
+	df->kvm = kvm;
+	spin_unlock(&df->kvm_ref_lock);
+}
+
 /**
  * vfio_file_set_kvm - Link a kvm with VFIO drivers
  * @file: VFIO group file or VFIO device file
@@ -1236,6 +1267,9 @@ void vfio_file_set_kvm(struct file *file, struct kvm *kvm)
 	group = vfio_group_from_file(file);
 	if (group)
 		vfio_group_set_kvm(group, kvm);
+
+	if (vfio_device_from_file(file))
+		vfio_device_file_set_kvm(file, kvm);
 }
 EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
 
-- 
2.34.1

