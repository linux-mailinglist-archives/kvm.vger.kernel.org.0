Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50E5468844F
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 17:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232029AbjBBQZN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 11:25:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231571AbjBBQZG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 11:25:06 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E9269B11;
        Thu,  2 Feb 2023 08:24:58 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 312GNZOl015920;
        Thu, 2 Feb 2023 16:24:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=fzK2oWxGj48xnYpg/AL72GuG0XS2mZ2eR2RwM1Ogl6A=;
 b=K6la3fSZlb/Lf5HYZ41FMF4rhIv4dUTmIh1xGkqgapFkDuTttl/yv/MnfMjIYXMBxlcb
 S97wdYejOK6IBNyzGq3807aTSNYMfD2SXi50BTndblVFpy0h7NwliBsMqosJK8u5nkZB
 AsKuksrK8mQe7vXa7NpZF9aFQ3yOeg/aXyOF1N5saT1b+XSKf3eJTx1u5kIvaBYVSVx6
 U31F4GpDAy+HLwxL8aXmzgjhKDZ44pmqt7u89vIdqcJq6nsZ+91apo9ybBGRFN956Vws
 GuX/AfdI2ZbMbRXw7KDwzCCmUgsaoCC3RlQ1st6BHtxuHou4923JBPfqejx24u3i8o14 pQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ngegwbwku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Feb 2023 16:24:50 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 312FEZNp003424;
        Thu, 2 Feb 2023 16:24:50 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ngegwbwke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Feb 2023 16:24:49 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 312F6BxM008452;
        Thu, 2 Feb 2023 16:24:48 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([9.208.130.101])
        by ppma04dal.us.ibm.com (PPS) with ESMTPS id 3ncvw33fgx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Feb 2023 16:24:48 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
        by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 312GOl566357670
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Feb 2023 16:24:47 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6CA4358061;
        Thu,  2 Feb 2023 16:24:47 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2FE25805A;
        Thu,  2 Feb 2023 16:24:45 +0000 (GMT)
Received: from li-2311da4c-2e09-11b2-a85c-c003041e9174.ibm.com.com (unknown [9.65.253.123])
        by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  2 Feb 2023 16:24:45 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, pbonzini@redhat.com,
        yi.l.liu@intel.com, jgg@nvidia.com
Cc:     cohuck@redhat.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, akrowiak@linux.ibm.com,
        jjherne@linux.ibm.com, pasic@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com, seanjc@google.com,
        kevin.tian@intel.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] vfio: fix deadlock between group lock and kvm lock
Date:   Thu,  2 Feb 2023 11:24:42 -0500
Message-Id: <20230202162442.78216-1-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: NnuhXHeZbpwQwNNnUjIfoo7hXWVih8FY
X-Proofpoint-GUID: 4i-hlKKCT3KD8sTol1scOd6mtmDRRsmK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-02_10,2023-02-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 suspectscore=0 adultscore=0 bulkscore=0 impostorscore=0
 mlxscore=0 mlxlogscore=999 phishscore=0 spamscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302020143
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After 51cdc8bc120e, we have another deadlock scenario between the
kvm->lock and the vfio group_lock with two different codepaths acquiring
the locks in different order.  Specifically in vfio_open_device, vfio
holds the vfio group_lock when issuing device->ops->open_device but some
drivers (like vfio-ap) need to acquire kvm->lock during their open_device
routine;  Meanwhile, kvm_vfio_release will acquire the kvm->lock first
before calling vfio_file_set_kvm which will acquire the vfio group_lock.

To resolve this, let's remove the need for the vfio group_lock from the
kvm_vfio_release codepath.  This is done by introducing a new spinlock to
protect modifications to the vfio group kvm pointer, and acquiring a kvm
ref from within vfio while holding this spinlock, with the reference held
until the last close for the device in question.

Fixes: 51cdc8bc120e ("kvm/vfio: Fix potential deadlock on vfio group_lock")
Reported-by: Anthony Krowiak <akrowiak@linux.ibm.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
Changes from v2:
* Relocate the new functions back to vfio_main and externalize to call
  from group (Kevin) since cdev will need this too
* s/vfio_kvm_*_kvm/vfio_device_*_kvm/ and only pass device as input.
  Handle new kvm_ref_lock directly inside vfio_device_get_kvm (Alex)
* Add assert_lockdep_held for dev_set lock (Alex)
* Internalize error paths for vfio_device_get_kvm_safe and now return
  void - either device->kvm is set with a ref taken or is NULL (Alex)
* Other flow suggestions to make the call path cleaner - Thanks! (Alex)
* Can't pass group->kvm to vfio_device_open, as it references the value
  outside of new lock.  Pass device->kvm to minimize changes in this
  fix (Alex, Yi)
Changes from v1:
* use spin_lock instead of spin_lock_irqsave (Jason)
* clear device->kvm_put as part of vfio_kvm_put_kvm (Yi)
* Re-arrange code to avoid referencing the group contents from within
  vfio_main (Kevin) which meant moving most of the code in this patch 
  to group.c along with getting/dropping of the dev_set lock
---
 drivers/vfio/group.c     | 32 ++++++++++++++----
 drivers/vfio/vfio.h      | 14 ++++++++
 drivers/vfio/vfio_main.c | 70 ++++++++++++++++++++++++++++++++++++----
 include/linux/vfio.h     |  2 +-
 4 files changed, 103 insertions(+), 15 deletions(-)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index bb24b2f0271e..7fed4233ca23 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -164,13 +164,23 @@ static int vfio_device_group_open(struct vfio_device *device)
 		goto out_unlock;
 	}
 
+	mutex_lock(&device->dev_set->lock);
+
 	/*
-	 * Here we pass the KVM pointer with the group under the lock.  If the
-	 * device driver will use it, it must obtain a reference and release it
-	 * during close_device.
+	 * Before the first device open, get the KVM pointer currently
+	 * associated with the group (if there is one) and obtain a reference
+	 * now that will be held until the open_count reaches 0 again.  Save
+	 * the pointer in the device for use by drivers.
 	 */
-	ret = vfio_device_open(device, device->group->iommufd,
-			       device->group->kvm);
+	if (device->open_count == 0)
+		vfio_device_get_kvm_safe(device);
+
+	ret = vfio_device_open(device, device->group->iommufd, device->kvm);
+
+	if (device->open_count == 0)
+		vfio_device_put_kvm(device);
+
+	mutex_unlock(&device->dev_set->lock);
 
 out_unlock:
 	mutex_unlock(&device->group->group_lock);
@@ -180,7 +190,14 @@ static int vfio_device_group_open(struct vfio_device *device)
 void vfio_device_group_close(struct vfio_device *device)
 {
 	mutex_lock(&device->group->group_lock);
+	mutex_lock(&device->dev_set->lock);
+
 	vfio_device_close(device, device->group->iommufd);
+
+	if (device->open_count == 0)
+		vfio_device_put_kvm(device);
+
+	mutex_unlock(&device->dev_set->lock);
 	mutex_unlock(&device->group->group_lock);
 }
 
@@ -450,6 +467,7 @@ static struct vfio_group *vfio_group_alloc(struct iommu_group *iommu_group,
 
 	refcount_set(&group->drivers, 1);
 	mutex_init(&group->group_lock);
+	spin_lock_init(&group->kvm_ref_lock);
 	INIT_LIST_HEAD(&group->device_list);
 	mutex_init(&group->device_lock);
 	group->iommu_group = iommu_group;
@@ -803,9 +821,9 @@ void vfio_file_set_kvm(struct file *file, struct kvm *kvm)
 	if (!vfio_file_is_group(file))
 		return;
 
-	mutex_lock(&group->group_lock);
+	spin_lock(&group->kvm_ref_lock);
 	group->kvm = kvm;
-	mutex_unlock(&group->group_lock);
+	spin_unlock(&group->kvm_ref_lock);
 }
 EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
 
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index f8219a438bfb..20d715b0a3a8 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -74,6 +74,7 @@ struct vfio_group {
 	struct file			*opened_file;
 	struct blocking_notifier_head	notifier;
 	struct iommufd_ctx		*iommufd;
+	spinlock_t			kvm_ref_lock;
 };
 
 int vfio_device_set_group(struct vfio_device *device,
@@ -251,4 +252,17 @@ extern bool vfio_noiommu __read_mostly;
 enum { vfio_noiommu = false };
 #endif
 
+#ifdef CONFIG_HAVE_KVM
+void vfio_device_get_kvm_safe(struct vfio_device *device);
+void vfio_device_put_kvm(struct vfio_device *device);
+#else
+static inline void vfio_device_get_kvm_safe(struct vfio_device *device)
+{
+}
+
+static inline void vfio_device_put_kvm(struct vfio_device *device)
+{
+}
+#endif
+
 #endif
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 5177bb061b17..4762550e9f42 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -16,6 +16,9 @@
 #include <linux/fs.h>
 #include <linux/idr.h>
 #include <linux/iommu.h>
+#ifdef CONFIG_HAVE_KVM
+#include <linux/kvm_host.h>
+#endif
 #include <linux/list.h>
 #include <linux/miscdevice.h>
 #include <linux/module.h>
@@ -338,6 +341,62 @@ void vfio_unregister_group_dev(struct vfio_device *device)
 }
 EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
 
+#ifdef CONFIG_HAVE_KVM
+void vfio_device_get_kvm_safe(struct vfio_device *device)
+{
+	void (*pfn)(struct kvm *kvm);
+	bool (*fn)(struct kvm *kvm);
+	bool ret;
+
+	lockdep_assert_held(&device->dev_set->lock);
+
+	spin_lock(&device->group->kvm_ref_lock);
+	if (!device->group->kvm)
+		goto unlock;
+
+	pfn = symbol_get(kvm_put_kvm);
+	if (WARN_ON(!pfn))
+		goto unlock;
+
+	fn = symbol_get(kvm_get_kvm_safe);
+	if (WARN_ON(!fn)) {
+		symbol_put(kvm_put_kvm);
+		goto unlock;
+	}
+
+	ret = fn(device->group->kvm);
+	symbol_put(kvm_get_kvm_safe);
+	if (!ret) {
+		symbol_put(kvm_put_kvm);
+		goto unlock;
+	}
+
+	device->put_kvm = pfn;
+	device->kvm = device->group->kvm;
+
+unlock:
+	spin_unlock(&device->group->kvm_ref_lock);
+}
+
+void vfio_device_put_kvm(struct vfio_device *device)
+{
+	lockdep_assert_held(&device->dev_set->lock);
+
+	if (!device->kvm)
+		return;
+
+	if (WARN_ON(!device->put_kvm))
+		goto clear;
+
+	device->put_kvm(device->kvm);
+	device->put_kvm = NULL;
+	symbol_put(kvm_put_kvm);
+
+clear:
+	device->kvm = NULL;
+}
+#endif
+
 /* true if the vfio_device has open_device() called but not close_device() */
 static bool vfio_assert_device_open(struct vfio_device *device)
 {
@@ -361,7 +420,6 @@ static int vfio_device_first_open(struct vfio_device *device,
 	if (ret)
 		goto err_module_put;
 
-	device->kvm = kvm;
 	if (device->ops->open_device) {
 		ret = device->ops->open_device(device);
 		if (ret)
@@ -370,7 +428,6 @@ static int vfio_device_first_open(struct vfio_device *device,
 	return 0;
 
 err_unuse_iommu:
-	device->kvm = NULL;
 	if (iommufd)
 		vfio_iommufd_unbind(device);
 	else
@@ -387,7 +444,6 @@ static void vfio_device_last_close(struct vfio_device *device,
 
 	if (device->ops->close_device)
 		device->ops->close_device(device);
-	device->kvm = NULL;
 	if (iommufd)
 		vfio_iommufd_unbind(device);
 	else
@@ -400,14 +456,14 @@ int vfio_device_open(struct vfio_device *device,
 {
 	int ret = 0;
 
-	mutex_lock(&device->dev_set->lock);
+	lockdep_assert_held(&device->dev_set->lock);
+
 	device->open_count++;
 	if (device->open_count == 1) {
 		ret = vfio_device_first_open(device, iommufd, kvm);
 		if (ret)
 			device->open_count--;
 	}
-	mutex_unlock(&device->dev_set->lock);
 
 	return ret;
 }
@@ -415,12 +471,12 @@ int vfio_device_open(struct vfio_device *device,
 void vfio_device_close(struct vfio_device *device,
 		       struct iommufd_ctx *iommufd)
 {
-	mutex_lock(&device->dev_set->lock);
+	lockdep_assert_held(&device->dev_set->lock);
+
 	vfio_assert_device_open(device);
 	if (device->open_count == 1)
 		vfio_device_last_close(device, iommufd);
 	device->open_count--;
-	mutex_unlock(&device->dev_set->lock);
 }
 
 /*
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 35be78e9ae57..87ff862ff555 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -46,7 +46,6 @@ struct vfio_device {
 	struct vfio_device_set *dev_set;
 	struct list_head dev_set_list;
 	unsigned int migration_flags;
-	/* Driver must reference the kvm during open_device or never touch it */
 	struct kvm *kvm;
 
 	/* Members below here are private, not for driver use */
@@ -58,6 +57,7 @@ struct vfio_device {
 	struct list_head group_next;
 	struct list_head iommu_entry;
 	struct iommufd_access *iommufd_access;
+	void (*put_kvm)(struct kvm *kvm);
 #if IS_ENABLED(CONFIG_IOMMUFD)
 	struct iommufd_device *iommufd_device;
 	struct iommufd_ctx *iommufd_ictx;
-- 
2.39.1

