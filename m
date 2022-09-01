Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 005845A8FFA
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 09:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233810AbiIAHVh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 03:21:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233775AbiIAHVL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 03:21:11 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B1D745058;
        Thu,  1 Sep 2022 00:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662016803; x=1693552803;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4GrXAaifpXzgg//H1+UwiOeapsBx1vO9t/zGuQpTQzc=;
  b=BRAf8KKNWafIYqaXdPYqLEifZNe52r+EFxi4L5FEFqQc3BWndO9lET0A
   SNUitHHunnrNhTiqKMI8iPF+S6B0yr3/KtQfa8C8OjUEDd95G3emAzWEg
   RTlOFqgK4Ur8Up8f+s3EqACLBlX5+ZM0ZFWOCd/q2ifyKMBtxFQzMMUpL
   h3RS2aDoNz/uV0e1STf4BJ63vm1SOzQtGZTZu3ToaUEwxMyGZIvGvzJ7Q
   cfOzLz7Q40pSRRcXLgZLLUt8xLoSbv8GjZcU+6UrwC68tuaxFaJXGF/q5
   oAyIdoxWoB7qMh1eeJ+pWf1TaUpo1JMwvEIGrs55wqaw7W8W49lkwqiHS
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="381934167"
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="381934167"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 00:19:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="673720736"
Received: from sqa-gate.sh.intel.com (HELO michael.clx.dev.tsp.org) ([10.239.48.212])
  by fmsmga008.fm.intel.com with ESMTP; 01 Sep 2022 00:19:24 -0700
From:   Kevin Tian <kevin.tian@intel.com>
To:     Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Longfang Liu <liulongfang@huawei.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Yishai Hadas <yishaih@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Abhishek Sahu <abhsahu@nvidia.com>,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH v2 13/15] vfio/ccw: Use the new device life cycle helpers
Date:   Thu,  1 Sep 2022 22:37:45 +0800
Message-Id: <20220901143747.32858-14-kevin.tian@intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20220901143747.32858-1-kevin.tian@intel.com>
References: <20220901143747.32858-1-kevin.tian@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ccw is the only exception which cannot use vfio_alloc_device() because
its private device structure is designed to serve both mdev and parent.
Life cycle of the parent is managed by css_driver so vfio_ccw_private
must be allocated/freed in css_driver probe/remove path instead of
conforming to vfio core life cycle for mdev.

Given that use a wait/completion scheme so the mdev remove path waits
after vfio_put_device() until receiving a completion notification from
@release. The completion indicates that all active references on
vfio_device have been released.

After that point although free of vfio_ccw_private is delayed to
css_driver it's at least guaranteed to have no parallel reference on
released vfio device part from other code paths.

memset() in @probe is removed. vfio_device is either already cleared
when probed for the first time or cleared in @release from last probe.

The right fix is to introduce separate structures for mdev and parent,
but this won't happen in short term per prior discussions.

Remove vfio_init/uninit_group_dev() as no user now.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/s390/cio/vfio_ccw_ops.c     | 52 +++++++++++++++++++++++++----
 drivers/s390/cio/vfio_ccw_private.h |  3 ++
 drivers/vfio/vfio_main.c            | 23 +++----------
 include/linux/vfio.h                |  3 --
 4 files changed, 53 insertions(+), 28 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index 4a806a2273b5..9f8486c0d3d3 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -87,6 +87,15 @@ static struct attribute_group *mdev_type_groups[] = {
 	NULL,
 };
 
+static int vfio_ccw_mdev_init_dev(struct vfio_device *vdev)
+{
+	struct vfio_ccw_private *private =
+		container_of(vdev, struct vfio_ccw_private, vdev);
+
+	init_completion(&private->release_comp);
+	return 0;
+}
+
 static int vfio_ccw_mdev_probe(struct mdev_device *mdev)
 {
 	struct vfio_ccw_private *private = dev_get_drvdata(mdev->dev.parent);
@@ -98,9 +107,9 @@ static int vfio_ccw_mdev_probe(struct mdev_device *mdev)
 	if (atomic_dec_if_positive(&private->avail) < 0)
 		return -EPERM;
 
-	memset(&private->vdev, 0, sizeof(private->vdev));
-	vfio_init_group_dev(&private->vdev, &mdev->dev,
-			    &vfio_ccw_dev_ops);
+	ret = vfio_init_device(&private->vdev, &mdev->dev, &vfio_ccw_dev_ops);
+	if (ret)
+		return ret;
 
 	VFIO_CCW_MSG_EVENT(2, "sch %x.%x.%04x: create\n",
 			   private->sch->schid.cssid,
@@ -109,16 +118,33 @@ static int vfio_ccw_mdev_probe(struct mdev_device *mdev)
 
 	ret = vfio_register_emulated_iommu_dev(&private->vdev);
 	if (ret)
-		goto err_atomic;
+		goto err_put_vdev;
 	dev_set_drvdata(&mdev->dev, private);
 	return 0;
 
-err_atomic:
-	vfio_uninit_group_dev(&private->vdev);
+err_put_vdev:
+	vfio_put_device(&private->vdev);
 	atomic_inc(&private->avail);
 	return ret;
 }
 
+static void vfio_ccw_mdev_release_dev(struct vfio_device *vdev)
+{
+	struct vfio_ccw_private *private =
+		container_of(vdev, struct vfio_ccw_private, vdev);
+
+	/*
+	 * We cannot free vfio_ccw_private here because it includes
+	 * parent info which must be free'ed by css driver.
+	 *
+	 * Use a workaround by memset'ing the core device part and
+	 * then notifying the remove path that all active references
+	 * to this device have been released.
+	 */
+	memset(vdev, 0, sizeof(*vdev));
+	complete(&private->release_comp);
+}
+
 static void vfio_ccw_mdev_remove(struct mdev_device *mdev)
 {
 	struct vfio_ccw_private *private = dev_get_drvdata(mdev->dev.parent);
@@ -130,7 +156,17 @@ static void vfio_ccw_mdev_remove(struct mdev_device *mdev)
 
 	vfio_unregister_group_dev(&private->vdev);
 
-	vfio_uninit_group_dev(&private->vdev);
+	vfio_put_device(&private->vdev);
+	/*
+	 * Wait for all active references on mdev are released so it
+	 * is safe to defer kfree() to a later point.
+	 *
+	 * TODO: the clean fix is to split parent/mdev info from ccw
+	 * private structure so each can be managed in its own life
+	 * cycle.
+	 */
+	wait_for_completion(&private->release_comp);
+
 	atomic_inc(&private->avail);
 }
 
@@ -592,6 +628,8 @@ static void vfio_ccw_mdev_request(struct vfio_device *vdev, unsigned int count)
 }
 
 static const struct vfio_device_ops vfio_ccw_dev_ops = {
+	.init = vfio_ccw_mdev_init_dev,
+	.release = vfio_ccw_mdev_release_dev,
 	.open_device = vfio_ccw_mdev_open_device,
 	.close_device = vfio_ccw_mdev_close_device,
 	.read = vfio_ccw_mdev_read,
diff --git a/drivers/s390/cio/vfio_ccw_private.h b/drivers/s390/cio/vfio_ccw_private.h
index cd24b7fada91..63d9202b29c7 100644
--- a/drivers/s390/cio/vfio_ccw_private.h
+++ b/drivers/s390/cio/vfio_ccw_private.h
@@ -88,6 +88,7 @@ struct vfio_ccw_crw {
  * @req_trigger: eventfd ctx for signaling userspace to return device
  * @io_work: work for deferral process of I/O handling
  * @crw_work: work for deferral process of CRW handling
+ * @release_comp: synchronization helper for vfio device release
  */
 struct vfio_ccw_private {
 	struct vfio_device vdev;
@@ -113,6 +114,8 @@ struct vfio_ccw_private {
 	struct eventfd_ctx	*req_trigger;
 	struct work_struct	io_work;
 	struct work_struct	crw_work;
+
+	struct completion	release_comp;
 } __aligned(8);
 
 int vfio_ccw_sch_quiesce(struct subchannel *sch);
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index c9d982131265..957d9f286550 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -481,28 +481,13 @@ static struct vfio_device *vfio_group_get_device(struct vfio_group *group,
 /*
  * VFIO driver API
  */
-void vfio_init_group_dev(struct vfio_device *device, struct device *dev,
-			 const struct vfio_device_ops *ops)
-{
-	init_completion(&device->comp);
-	device->dev = dev;
-	device->ops = ops;
-}
-EXPORT_SYMBOL_GPL(vfio_init_group_dev);
-
-void vfio_uninit_group_dev(struct vfio_device *device)
-{
-	vfio_release_device_set(device);
-}
-EXPORT_SYMBOL_GPL(vfio_uninit_group_dev);
-
 /* Release helper called by vfio_put_device() */
 void vfio_device_release(struct kref *kref)
 {
 	struct vfio_device *device =
 			container_of(kref, struct vfio_device, kref);
 
-	vfio_uninit_group_dev(device);
+	vfio_release_device_set(device);
 
 	/*
 	 * kvfree() cannot be done here due to a life cycle mess in
@@ -560,7 +545,9 @@ int vfio_init_device(struct vfio_device *device, struct device *dev,
 {
 	int ret;
 
-	vfio_init_group_dev(device, dev, ops);
+	init_completion(&device->comp);
+	device->dev = dev;
+	device->ops = ops;
 
 	if (ops->init) {
 		ret = ops->init(device);
@@ -572,7 +559,7 @@ int vfio_init_device(struct vfio_device *device, struct device *dev,
 	return 0;
 
 out_uninit:
-	vfio_uninit_group_dev(device);
+	vfio_release_device_set(device);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(vfio_init_device);
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index e1e9e8352903..f03447c8774d 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -160,9 +160,6 @@ static inline void vfio_put_device(struct vfio_device *device)
 	kref_put(&device->kref, vfio_device_release);
 }
 
-void vfio_init_group_dev(struct vfio_device *device, struct device *dev,
-			 const struct vfio_device_ops *ops);
-void vfio_uninit_group_dev(struct vfio_device *device);
 int vfio_register_group_dev(struct vfio_device *device);
 int vfio_register_emulated_iommu_dev(struct vfio_device *device);
 void vfio_unregister_group_dev(struct vfio_device *device);
-- 
2.21.3

