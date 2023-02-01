Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 313E9686ECE
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 20:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232053AbjBATU3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 14:20:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjBATU2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 14:20:28 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D87D57B425;
        Wed,  1 Feb 2023 11:20:26 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 311JEUT4024229;
        Wed, 1 Feb 2023 19:20:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=YuB+XZFk1tj11n3e62TybXK00ZA/KR8cB3x9GN4pGc8=;
 b=IAAd60r/ln9sUTl16WvgJJP6qiVGK7uvqwk/7rSaDc50wYHmXDuRtYYvoh7vI6rjXRn6
 PlXKaSDmdz/FGh1rdF7p5DICvffs1OzQhVEcja1Lzz6argncReEpjl8YdBR95dgoyJFL
 ku0oG+p6ZnLNZ4OiQvrvU4yjMY4Bdv2+f9NG3l3EmL/jImjVLozw/nI8Hy9b+jViH0YF
 gNx1U0oXXMmnQV5zqhaORf6fCfFVRvcyqNY3dkLZfxNM2WfslyhpvLslHRFEBwkMHpqo
 8nK5N4SHH3RSLRJiHo/M93NQsKf02UN8d+nnY47OMRLkYyZuN8XdNDoFa1+YCW+YIdPF tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nfx14r7br-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Feb 2023 19:20:23 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 311JEaBi025054;
        Wed, 1 Feb 2023 19:20:22 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nfx14r7b1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Feb 2023 19:20:22 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 311J3ARZ019280;
        Wed, 1 Feb 2023 19:20:21 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([9.208.129.116])
        by ppma02dal.us.ibm.com (PPS) with ESMTPS id 3ncvuqw5gq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Feb 2023 19:20:21 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
        by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 311JKJbQ6947558
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Feb 2023 19:20:19 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 444D55805D;
        Wed,  1 Feb 2023 19:20:19 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 799955805C;
        Wed,  1 Feb 2023 19:20:16 +0000 (GMT)
Received: from li-2311da4c-2e09-11b2-a85c-c003041e9174.ibm.com (unknown [9.65.253.123])
        by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  1 Feb 2023 19:20:16 +0000 (GMT)
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
Subject: [PATCH v2] vfio: fix deadlock between group lock and kvm lock
Date:   Wed,  1 Feb 2023 14:20:10 -0500
Message-Id: <20230201192010.42748-1-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4AAuk-Wx7-2D4cHh7xNnIWNct1PDUoVa
X-Proofpoint-GUID: XyO83ZUnXd5TGtsgaSZxVIM0ceERQwbX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-01_04,2023-01-31_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 mlxscore=0 phishscore=0
 impostorscore=0 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302010161
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
Changes from v1:
* use spin_lock instead of spin_lock_irqsave (Jason)
* clear device->kvm_put as part of vfio_kvm_put_kvm (Yi)
* Re-arrange code to avoid referencing the group contents from within
  vfio_main (Kevin) which meant moving most of the code in this patch 
  to group.c along with getting/dropping of the dev_set lock
---
 drivers/vfio/group.c     | 90 +++++++++++++++++++++++++++++++++++++---
 drivers/vfio/vfio.h      |  1 +
 drivers/vfio/vfio_main.c | 11 ++---
 include/linux/vfio.h     |  2 +-
 4 files changed, 91 insertions(+), 13 deletions(-)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index bb24b2f0271e..52f434861294 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -13,6 +13,9 @@
 #include <linux/vfio.h>
 #include <linux/iommufd.h>
 #include <linux/anon_inodes.h>
+#ifdef CONFIG_HAVE_KVM
+#include <linux/kvm_host.h>
+#endif
 #include "vfio.h"
 
 static struct vfio {
@@ -154,6 +157,55 @@ static int vfio_group_ioctl_set_container(struct vfio_group *group,
 	return ret;
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
+	device->put_kvm = NULL;
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
 static int vfio_device_group_open(struct vfio_device *device)
 {
 	int ret;
@@ -164,14 +216,32 @@ static int vfio_device_group_open(struct vfio_device *device)
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
+	if (device->open_count == 0) {
+		spin_lock(&device->group->kvm_ref_lock);
+		if (device->group->kvm &&
+		    vfio_kvm_get_kvm_safe(device, device->group->kvm))
+			device->kvm = device->group->kvm;
+		spin_unlock(&device->group->kvm_ref_lock);
+	}
+
 	ret = vfio_device_open(device, device->group->iommufd,
 			       device->group->kvm);
 
+	if (ret && device->kvm && device->open_count == 0) {
+		vfio_kvm_put_kvm(device);
+		device->kvm = NULL;
+	}
+
+	mutex_unlock(&device->dev_set->lock);
+
 out_unlock:
 	mutex_unlock(&device->group->group_lock);
 	return ret;
@@ -180,7 +250,16 @@ static int vfio_device_group_open(struct vfio_device *device)
 void vfio_device_group_close(struct vfio_device *device)
 {
 	mutex_lock(&device->group->group_lock);
+	mutex_lock(&device->dev_set->lock);
+
 	vfio_device_close(device, device->group->iommufd);
+
+	if (device->kvm && device->open_count == 0) {
+		vfio_kvm_put_kvm(device);
+		device->kvm = NULL;
+	}
+
+	mutex_unlock(&device->dev_set->lock);
 	mutex_unlock(&device->group->group_lock);
 }
 
@@ -450,6 +529,7 @@ static struct vfio_group *vfio_group_alloc(struct iommu_group *iommu_group,
 
 	refcount_set(&group->drivers, 1);
 	mutex_init(&group->group_lock);
+	spin_lock_init(&group->kvm_ref_lock);
 	INIT_LIST_HEAD(&group->device_list);
 	mutex_init(&group->device_lock);
 	group->iommu_group = iommu_group;
@@ -803,9 +883,9 @@ void vfio_file_set_kvm(struct file *file, struct kvm *kvm)
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
index f8219a438bfb..20c6bc249cb8 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -74,6 +74,7 @@ struct vfio_group {
 	struct file			*opened_file;
 	struct blocking_notifier_head	notifier;
 	struct iommufd_ctx		*iommufd;
+	spinlock_t			kvm_ref_lock;
 };
 
 int vfio_device_set_group(struct vfio_device *device,
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 5177bb061b17..14dbf781ea8c 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -361,7 +361,6 @@ static int vfio_device_first_open(struct vfio_device *device,
 	if (ret)
 		goto err_module_put;
 
-	device->kvm = kvm;
 	if (device->ops->open_device) {
 		ret = device->ops->open_device(device);
 		if (ret)
@@ -370,7 +369,6 @@ static int vfio_device_first_open(struct vfio_device *device,
 	return 0;
 
 err_unuse_iommu:
-	device->kvm = NULL;
 	if (iommufd)
 		vfio_iommufd_unbind(device);
 	else
@@ -387,7 +385,6 @@ static void vfio_device_last_close(struct vfio_device *device,
 
 	if (device->ops->close_device)
 		device->ops->close_device(device);
-	device->kvm = NULL;
 	if (iommufd)
 		vfio_iommufd_unbind(device);
 	else
@@ -400,14 +397,14 @@ int vfio_device_open(struct vfio_device *device,
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
@@ -415,12 +412,12 @@ int vfio_device_open(struct vfio_device *device,
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

