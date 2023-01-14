Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4407966A759
	for <lists+kvm@lfdr.de>; Sat, 14 Jan 2023 01:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbjANAEG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 19:04:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbjANAEE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 19:04:04 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5B204D716;
        Fri, 13 Jan 2023 16:04:03 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30DNt0S9021145;
        Sat, 14 Jan 2023 00:04:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=pebRGAVC+dkDU7+HrWNEdoGsEveXfipktrtq3c/Wv18=;
 b=YT27CmBXcSKrSTnkpIpasUbNBf/ARWi7vvPKktjevB9qhrsJmt0tAGwCf60f/LQUB0gD
 UYLOTWeX9hTlqXwjIdAQbwIJ8AD1FPfHhWQoHVy7UlmXwl4p56eVn2At1LFnbXr5Ps2V
 xMddkLGVm2HOxSLIIv2USYwBuoQrxPfRxTigW6gXovuHymT9Mh1uTHLaOTLu//+PU1V7
 J/F85+xuCep8qSBUsgqizeUrtoAErJ0QxGs+cVYSw007Z+hpFMwRpIPhQcjeDgFelT24
 adwLi0M9193k1/mvEbFWAai60rwM8ucTucmXQvkEaSV3ryosFecjg0SAGkf5ahVpbc4C hQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n3hd2856y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 14 Jan 2023 00:04:00 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30E00IXs003434;
        Sat, 14 Jan 2023 00:03:59 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n3hd2856e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 14 Jan 2023 00:03:59 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30DNElU6001732;
        Sat, 14 Jan 2023 00:03:58 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([9.208.130.99])
        by ppma04wdc.us.ibm.com (PPS) with ESMTPS id 3n1kmatkg0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 14 Jan 2023 00:03:58 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
        by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30E03vAI32899818
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Jan 2023 00:03:57 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0EF9958059;
        Sat, 14 Jan 2023 00:03:57 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41EF658055;
        Sat, 14 Jan 2023 00:03:53 +0000 (GMT)
Received: from li-2311da4c-2e09-11b2-a85c-c003041e9174.ibm.com.com (unknown [9.65.223.110])
        by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Sat, 14 Jan 2023 00:03:53 +0000 (GMT)
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
Subject: [PATCH v4] vfio: fix potential deadlock on vfio group lock
Date:   Fri, 13 Jan 2023 19:03:51 -0500
Message-Id: <20230114000351.115444-1-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0edGTxN3xbEPbpEK0r8yN8pop-E30Ibp
X-Proofpoint-GUID: HyJxKZ6KO3NbcwfPqy5FjSLyQ5jtSjtI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-13_11,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 mlxscore=0 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0
 priorityscore=1501 mlxlogscore=999 malwarescore=0 lowpriorityscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301130161
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
the first time a device is opened and hold that reference until right
after the group lock is released after the last device is closed.

Fixes: 421cfe6596f6 ("vfio: remove VFIO_GROUP_NOTIFY_SET_KVM")
Reported-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
Changes from v3:
* Can't check for open_count after the group lock has been dropped because
  it would be possible for the count to change again once the group lock
  is dropped (Jason)
  Solve this by stashing a copy of the kvm and put_kvm while the group
  lock is held, nullifying the device copies of these in device_close()
  as soon as the open_count reaches 0, and then checking to see if the
  device->kvm changed before dropping the group lock.  If it changed
  during close, we can drop the reference using the stashed kvm and put
  function after dropping the group lock.

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
 drivers/vfio/group.c     | 23 +++++++++++++--
 drivers/vfio/vfio.h      |  9 ++++++
 drivers/vfio/vfio_main.c | 61 +++++++++++++++++++++++++++++++++++++---
 include/linux/vfio.h     |  2 +-
 4 files changed, 87 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index bb24b2f0271e..b396c17d7390 100644
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
+	 * will be held until the open_count reaches 0.
 	 */
 	ret = vfio_device_open(device, device->group->iommufd,
 			       device->group->kvm);
@@ -179,9 +179,26 @@ static int vfio_device_group_open(struct vfio_device *device)
 
 void vfio_device_group_close(struct vfio_device *device)
 {
+	void (*put_kvm)(struct kvm *kvm);
+	struct kvm *kvm;
+
 	mutex_lock(&device->group->group_lock);
+	kvm = device->kvm;
+	put_kvm = device->put_kvm;
 	vfio_device_close(device, device->group->iommufd);
+	if (kvm == device->kvm)
+		kvm = NULL;
 	mutex_unlock(&device->group->group_lock);
+
+	/*
+	 * The last kvm reference will trigger kvm_destroy_vm, which can in
+	 * turn re-enter vfio and attempt to acquire the group lock.  Therefore
+	 * we get a copy of the kvm pointer and the put function under the
+	 * group lock but wait to put that reference until after releasing the
+	 * lock.
+	 */
+	if (kvm)
+		vfio_kvm_put_kvm(put_kvm, kvm);
 }
 
 static struct file *vfio_device_open_file(struct vfio_device *device)
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index f8219a438bfb..08a5a23d6fef 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -251,4 +251,13 @@ extern bool vfio_noiommu __read_mostly;
 enum { vfio_noiommu = false };
 #endif
 
+#ifdef CONFIG_HAVE_KVM
+void vfio_kvm_put_kvm(void (*put)(struct kvm *kvm), struct kvm *kvm);
+#else
+static inline void vfio_kvm_put_kvm(void (*put)(struct kvm *kvm),
+				    struct kvm *kvm)
+{
+}
+#endif
+
 #endif
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 5177bb061b17..c6bb07af46b8 100644
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
@@ -344,6 +347,49 @@ static bool vfio_assert_device_open(struct vfio_device *device)
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
+void vfio_kvm_put_kvm(void (*put)(struct kvm *kvm), struct kvm *kvm)
+{
+	if (WARN_ON(!put))
+		return;
+
+	put(kvm);
+	symbol_put(kvm_put_kvm);
+}
+#else
+static bool vfio_kvm_get_kvm_safe(struct vfio_device *device, struct kvm *kvm)
+{
+	return false;
+}
+#endif
+
 static int vfio_device_first_open(struct vfio_device *device,
 				  struct iommufd_ctx *iommufd, struct kvm *kvm)
 {
@@ -361,16 +407,22 @@ static int vfio_device_first_open(struct vfio_device *device,
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
+		vfio_kvm_put_kvm(device->put_kvm, device->kvm);
+		device->put_kvm = NULL;
+		device->kvm = NULL;
+	}
 	if (iommufd)
 		vfio_iommufd_unbind(device);
 	else
@@ -388,6 +440,7 @@ static void vfio_device_last_close(struct vfio_device *device,
 	if (device->ops->close_device)
 		device->ops->close_device(device);
 	device->kvm = NULL;
+	device->put_kvm = NULL;
 	if (iommufd)
 		vfio_iommufd_unbind(device);
 	else
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

