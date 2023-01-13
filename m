Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE988669F52
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 18:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbjAMRNy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 12:13:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbjAMRNZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 12:13:25 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF6E89BEA;
        Fri, 13 Jan 2023 09:11:47 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30DGHISV003143;
        Fri, 13 Jan 2023 17:11:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=rmB3tNOfF0Nb80BWV6tyA3MrK480SPOHdQYPYzfIaAw=;
 b=tk+WdoeNY3GHmvOEt47ul0guggng+K3Y1oW3457egKdKkbBsAcre6o6U2KZYqlWm4hiE
 ZjH7n42XNtY3EmepVBAtgM+VBi7HuIkFEAVL3plggkG+sSITzVJAAN+v/eDsLlpdfYvH
 4e3QL/jkNR+k04P6PR5biPDTWcu4tzHLfCAS6LR5AnvKGetKQtZWFj+4hMfktmFTluZf
 s6avs9eiSM+hzf5ZW0wHEkqwXYNu0suPVRMfh2KB60AYhBAhgFo2XZVWZuf9B+kWhevU
 /96sDhL1vAnhNZ4Rpp2968qgX7FhwGuydXZYSnzoN0YxcH6d7qErm4vFsNuksB2rELgb wA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n3apk1e3h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Jan 2023 17:11:39 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30DGLBT3018627;
        Fri, 13 Jan 2023 17:11:38 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n3apk1e38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Jan 2023 17:11:38 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30DF4L7i014717;
        Fri, 13 Jan 2023 17:11:37 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([9.208.130.102])
        by ppma01dal.us.ibm.com (PPS) with ESMTPS id 3n1kv5n01y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Jan 2023 17:11:37 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
        by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30DHBZNJ197232
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Jan 2023 17:11:36 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B715B58043;
        Fri, 13 Jan 2023 17:11:35 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 380B25805F;
        Fri, 13 Jan 2023 17:11:33 +0000 (GMT)
Received: from li-2311da4c-2e09-11b2-a85c-c003041e9174.ibm.com.com (unknown [9.160.94.233])
        by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 13 Jan 2023 17:11:33 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, pbonzini@redhat.com
Cc:     jgg@nvidia.com, cohuck@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@linux.ibm.com,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com, david@redhat.com,
        akrowiak@linux.ibm.com, jjherne@linux.ibm.com, pasic@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com, seanjc@google.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] vfio: fix potential deadlock on vfio group lock
Date:   Fri, 13 Jan 2023 12:11:32 -0500
Message-Id: <20230113171132.86057-1-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9vANe1Lemnb7dlBI2iIfePB6DG5MqF7U
X-Proofpoint-GUID: S_fuYn6ObG9fDFiFS789j50vp3mf3-hc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-13_08,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 clxscore=1015 suspectscore=0 mlxlogscore=999 lowpriorityscore=0
 phishscore=0 mlxscore=0 malwarescore=0 impostorscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301130110
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently it is possible that the final put of a KVM reference comes from
vfio during its device close operation.  This occurs while the vfio group
lock is held; however, if the vfio device is still in the kvm device list,
then the following call chain could result in a deadlock:

kvm_put_kvm
 -> kvm_destroy_vm
  -> kvm_destroy_devices
   -> kvm_vfio_destroy
    -> kvm_vfio_file_set_kvm
     -> vfio_file_set_kvm
      -> group->group_lock/group_rwsem

Avoid this scenario by having vfio core code acquire a KVM reference
the first time a device is opened and hold that reference until the
device fd is closed, at a point after the group lock has been released.

Fixes: 421cfe6596f6 ("vfio: remove VFIO_GROUP_NOTIFY_SET_KVM")
Reported-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
Changes from v2:
* Re-arrange vfio_kvm_set_kvm_safe error path to still trigger
  device_open with device->kvm=NULL (Alex)
* get device->dev_set->lock when checking device->open_count (Alex)
* but don't hold it over the kvm_put_kvm (Jason)
* get kvm_put symbol upfront and stash it in device until close (Jason)
* check CONFIG_HAVE_KVM to avoid build errors on architectures without
  KVM support

Changes from v1:
* Re-write using symbol get logic to get kvm ref during first device
  open, release the ref during device fd close after group lock is
  released
* Drop kvm get/put changes to drivers; now that vfio core holds a
  kvm ref until sometime after the device_close op is called, it
  should be fine for drivers to get and put their own references to it.
---
 drivers/vfio/group.c     |  6 ++--
 drivers/vfio/vfio_main.c | 78 +++++++++++++++++++++++++++++++++++++---
 include/linux/vfio.h     |  2 +-
 3 files changed, 77 insertions(+), 9 deletions(-)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index bb24b2f0271e..2b0da82f82f4 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -165,9 +165,9 @@ static int vfio_device_group_open(struct vfio_device *device)
 	}
 
 	/*
-	 * Here we pass the KVM pointer with the group under the lock.  If the
-	 * device driver will use it, it must obtain a reference and release it
-	 * during close_device.
+	 * Here we pass the KVM pointer with the group under the lock.  A
+	 * reference will be obtained the first time the device is opened and
+	 * will be held until the device fd is closed.
 	 */
 	ret = vfio_device_open(device, device->group->iommufd,
 			       device->group->kvm);
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 5177bb061b17..dbdf16903d52 100644
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
@@ -344,6 +347,57 @@ static bool vfio_assert_device_open(struct vfio_device *device)
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
+static void vfio_kvm_put_kvm(struct vfio_device *device, struct kvm *kvm)
+{
+	if (WARN_ON(!device->put_kvm))
+		return;
+
+	device->put_kvm(kvm);
+
+	device->put_kvm = NULL;
+
+	symbol_put(kvm_put_kvm);
+}
+#else
+static bool vfio_kvm_get_kvm_safe(struct vfio_device *device, struct kvm *kvm)
+{
+	return false;
+}
+
+static void vfio_kvm_put_kvm(struct vfio_device *device, struct kvm *kvm)
+{
+
+}
+#endif
+
 static int vfio_device_first_open(struct vfio_device *device,
 				  struct iommufd_ctx *iommufd, struct kvm *kvm)
 {
@@ -361,16 +415,21 @@ static int vfio_device_first_open(struct vfio_device *device,
 	if (ret)
 		goto err_module_put;
 
-	device->kvm = kvm;
+	if (kvm && vfio_kvm_get_kvm_safe(device, kvm))
+		device->kvm = kvm;
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
+		vfio_kvm_put_kvm(device, device->kvm);
+		device->kvm = NULL;
+	}
 	if (iommufd)
 		vfio_iommufd_unbind(device);
 	else
@@ -387,7 +446,6 @@ static void vfio_device_last_close(struct vfio_device *device,
 
 	if (device->ops->close_device)
 		device->ops->close_device(device);
-	device->kvm = NULL;
 	if (iommufd)
 		vfio_iommufd_unbind(device);
 	else
@@ -462,9 +520,19 @@ static inline void vfio_device_pm_runtime_put(struct vfio_device *device)
 static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 {
 	struct vfio_device *device = filep->private_data;
+	struct kvm *kvm = NULL;
 
 	vfio_device_group_close(device);
 
+	mutex_lock(&device->dev_set->lock);
+	if (device->open_count == 0 && device->kvm) {
+		kvm = device->kvm;
+		device->kvm = NULL;
+	}
+	mutex_unlock(&device->dev_set->lock);
+	if (kvm)
+		vfio_kvm_put_kvm(device, kvm);
+
 	vfio_device_put_registration(device);
 
 	return 0;
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
2.39.0

