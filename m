Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2BB4683740
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 21:06:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbjAaUGy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 15:06:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjAaUGu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 15:06:50 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6677858970;
        Tue, 31 Jan 2023 12:06:49 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30VJfhxP031025;
        Tue, 31 Jan 2023 20:06:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=TwHzldObEz+5RQ/VzeFhEVpSmjlABZyZ2m/0uUaWkF8=;
 b=PXDaF9LSUKrV1cn/nt5xNPSRgvX9JadUV/2fc6uHia2AIIcxURosIFNf7NSD9YU0buB2
 40DPnwZPRlowH6mKP7y4lSnQwx0zL/7acFgL5l0DLAxICWjII+QZO6kCeDXduJDsNVod
 JRoB/HBwe/Z4gR8nPbdk1cChK/14+4WbAWGeVN8urz7Y/J986XzW5h0D7Bj4zryJMR2r
 kesIEqG7Dox2MkGie21IrHzSRusmwI7JZ2mKx6Xtcakx02+KPHIGlSPBTezcfRyZhQJD
 3/B8pHvCx7XKLh/Kd8qg9gAqX4jA3IXP6Bz8lu9JiLWtZ2TeZY7lHLLOm4IezpCfujKW vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nf94rgqwx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 Jan 2023 20:06:42 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30VJqUGt003028;
        Tue, 31 Jan 2023 20:06:41 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nf94rgqwq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 Jan 2023 20:06:41 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30VJ21K6005472;
        Tue, 31 Jan 2023 20:06:40 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([9.208.129.117])
        by ppma02wdc.us.ibm.com (PPS) with ESMTPS id 3ncvv1sutx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 Jan 2023 20:06:40 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
        by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30VK6bWx48890216
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Jan 2023 20:06:38 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE8A458058;
        Tue, 31 Jan 2023 20:06:37 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E32B758063;
        Tue, 31 Jan 2023 20:06:35 +0000 (GMT)
Received: from li-2311da4c-2e09-11b2-a85c-c003041e9174.ibm.com.com (unknown [9.160.16.25])
        by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 31 Jan 2023 20:06:35 +0000 (GMT)
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
Subject: [PATCH] vfio: fix deadlock between group lock and kvm lock
Date:   Tue, 31 Jan 2023 15:06:35 -0500
Message-Id: <20230131200635.44227-1-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nZAnx8FhILQv_NXIXleyKkQ3KZlNG1r-
X-Proofpoint-ORIG-GUID: x2Bw0ErTpieONMc0n7MHKahXmg7ncVvv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-31_08,2023-01-31_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 impostorscore=0 clxscore=1015 adultscore=0 lowpriorityscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 suspectscore=0 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301310175
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
 drivers/vfio/group.c     | 14 +++----
 drivers/vfio/vfio.h      |  5 ++-
 drivers/vfio/vfio_main.c | 88 ++++++++++++++++++++++++++++++++++++----
 include/linux/vfio.h     |  2 +-
 4 files changed, 88 insertions(+), 21 deletions(-)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index bb24b2f0271e..8f67d33e0e8d 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -164,13 +164,7 @@ static int vfio_device_group_open(struct vfio_device *device)
 		goto out_unlock;
 	}
 
-	/*
-	 * Here we pass the KVM pointer with the group under the lock.  If the
-	 * device driver will use it, it must obtain a reference and release it
-	 * during close_device.
-	 */
-	ret = vfio_device_open(device, device->group->iommufd,
-			       device->group->kvm);
+	ret = vfio_device_open(device, device->group);
 
 out_unlock:
 	mutex_unlock(&device->group->group_lock);
@@ -450,6 +444,7 @@ static struct vfio_group *vfio_group_alloc(struct iommu_group *iommu_group,
 
 	refcount_set(&group->drivers, 1);
 	mutex_init(&group->group_lock);
+	spin_lock_init(&group->kvm_ref_lock);
 	INIT_LIST_HEAD(&group->device_list);
 	mutex_init(&group->device_lock);
 	group->iommu_group = iommu_group;
@@ -799,13 +794,14 @@ EXPORT_SYMBOL_GPL(vfio_file_enforced_coherent);
 void vfio_file_set_kvm(struct file *file, struct kvm *kvm)
 {
 	struct vfio_group *group = file->private_data;
+	unsigned long flags;
 
 	if (!vfio_file_is_group(file))
 		return;
 
-	mutex_lock(&group->group_lock);
+	spin_lock_irqsave(&group->kvm_ref_lock, flags);
 	group->kvm = kvm;
-	mutex_unlock(&group->group_lock);
+	spin_unlock_irqrestore(&group->kvm_ref_lock, flags);
 }
 EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
 
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index f8219a438bfb..d153ad35de24 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -15,11 +15,11 @@ struct iommufd_ctx;
 struct iommu_group;
 struct vfio_device;
 struct vfio_container;
+struct vfio_group;
 
 void vfio_device_put_registration(struct vfio_device *device);
 bool vfio_device_try_get_registration(struct vfio_device *device);
-int vfio_device_open(struct vfio_device *device,
-		     struct iommufd_ctx *iommufd, struct kvm *kvm);
+int vfio_device_open(struct vfio_device *device, struct vfio_group *group);
 void vfio_device_close(struct vfio_device *device,
 		       struct iommufd_ctx *iommufd);
 
@@ -74,6 +74,7 @@ struct vfio_group {
 	struct file			*opened_file;
 	struct blocking_notifier_head	notifier;
 	struct iommufd_ctx		*iommufd;
+	spinlock_t			kvm_ref_lock;
 };
 
 int vfio_device_set_group(struct vfio_device *device,
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 5177bb061b17..b0defb0d0d87 100644
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
@@ -344,9 +347,59 @@ static bool vfio_assert_device_open(struct vfio_device *device)
 	return !WARN_ON_ONCE(!READ_ONCE(device->open_count));
 }
 
+#ifdef CONFIG_HAVE_KVM
+static bool vfio_kvm_get_kvm_safe(struct vfio_device *device, struct kvm *kvm)
+{
+	void (*pfn)(struct kvm *kvm);
+	bool (*fn)(struct kvm *kvm);
+	bool ret;
+
+	pfn = symbol_get(kvm_put_kvm);
+	if (WARN_ON(!pfn))
+		return false;
+
+	fn = symbol_get(kvm_get_kvm_safe);
+	if (WARN_ON(!fn)) {
+		symbol_put(kvm_put_kvm);
+		return false;
+	}
+
+	ret = fn(kvm);
+	if (ret)
+		device->put_kvm = pfn;
+	else
+		symbol_put(kvm_put_kvm);
+
+	symbol_put(kvm_get_kvm_safe);
+
+	return ret;
+}
+
+static void vfio_kvm_put_kvm(struct vfio_device *device)
+{
+	if (WARN_ON(!device->kvm || !device->put_kvm))
+		return;
+
+	device->put_kvm(device->kvm);
+	symbol_put(kvm_put_kvm);
+}
+
+#else
+static bool vfio_kvm_get_kvm_safe(struct vfio_device *device, struct kvm *kvm)
+{
+	return false;
+}
+
+static void vfio_kvm_put_kvm(struct vfio_device *device)
+{
+}
+#endif
+
 static int vfio_device_first_open(struct vfio_device *device,
-				  struct iommufd_ctx *iommufd, struct kvm *kvm)
+				  struct vfio_group *group)
 {
+	struct iommufd_ctx *iommufd = group->iommufd;
+	unsigned long flags;
 	int ret;
 
 	lockdep_assert_held(&device->dev_set->lock);
@@ -361,16 +414,30 @@ static int vfio_device_first_open(struct vfio_device *device,
 	if (ret)
 		goto err_module_put;
 
-	device->kvm = kvm;
+	/*
+	 * Get the KVM pointer currently associated with the group, if there
+	 * is one, and obtain a reference now that will be held until the
+	 * open_count reaches 0.  Save the pointer in the device for use by
+	 * drivers.
+	 */
+	spin_lock_irqsave(&group->kvm_ref_lock, flags);
+	if (group->kvm && vfio_kvm_get_kvm_safe(device, group->kvm))
+		device->kvm = group->kvm;
+	spin_unlock_irqrestore(&group->kvm_ref_lock, flags);
+
 	if (device->ops->open_device) {
 		ret = device->ops->open_device(device);
 		if (ret)
-			goto err_unuse_iommu;
+			goto err_put_kvm;
 	}
 	return 0;
 
-err_unuse_iommu:
-	device->kvm = NULL;
+err_put_kvm:
+	if (device->kvm) {
+		vfio_kvm_put_kvm(device);
+		device->put_kvm = NULL;
+		device->kvm = NULL;
+	}
 	if (iommufd)
 		vfio_iommufd_unbind(device);
 	else
@@ -387,7 +454,11 @@ static void vfio_device_last_close(struct vfio_device *device,
 
 	if (device->ops->close_device)
 		device->ops->close_device(device);
-	device->kvm = NULL;
+	if (device->kvm) {
+		vfio_kvm_put_kvm(device);
+		device->kvm = NULL;
+		device->put_kvm = NULL;
+	}
 	if (iommufd)
 		vfio_iommufd_unbind(device);
 	else
@@ -395,15 +466,14 @@ static void vfio_device_last_close(struct vfio_device *device,
 	module_put(device->dev->driver->owner);
 }
 
-int vfio_device_open(struct vfio_device *device,
-		     struct iommufd_ctx *iommufd, struct kvm *kvm)
+int vfio_device_open(struct vfio_device *device, struct vfio_group *group)
 {
 	int ret = 0;
 
 	mutex_lock(&device->dev_set->lock);
 	device->open_count++;
 	if (device->open_count == 1) {
-		ret = vfio_device_first_open(device, iommufd, kvm);
+		ret = vfio_device_first_open(device, group);
 		if (ret)
 			device->open_count--;
 	}
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

