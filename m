Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3B75A36CC
	for <lists+kvm@lfdr.de>; Sat, 27 Aug 2022 11:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345500AbiH0Jwi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Aug 2022 05:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234680AbiH0JwL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Aug 2022 05:52:11 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3ADB6D39;
        Sat, 27 Aug 2022 02:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661593911; x=1693129911;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=glP8uqQ+ukBhUAO9NPjw12U1FmEtYqp1qrOFocVTOpY=;
  b=aJyd8wdB5z7HJnJQs5yZp89iH8hg6ncZWHgangALfdoimLu+gsEYRTTB
   4PPzPhSnk2TYeYZ/3a5cRHxC3UT0p+FUmZ7JxptTJa4yNwiDK3W1PBT3D
   5rD4n7sQzEl7kL4JL2VncVHlZ7Ueuv7OCFFJgDWOj10PiMG66NhSNNYz+
   WRy0gIjTmUIv5Y7EsbP3rsItW2EY82IbVw1LK0HSJ1G4ih+4+3ab6w2OC
   i4IBeqeQ8mRst0kw3bd1AJyUwv0Xgoo6F0t6cuuD5Klz+39a1x3z9esvu
   dqyuXgJWTsz/6fNRemLusd7pRjCGTet/rb83Uc3uaySM/Ad9cpMNZU/hM
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10451"; a="292230193"
X-IronPort-AV: E=Sophos;i="5.93,267,1654585200"; 
   d="scan'208";a="292230193"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2022 02:51:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,267,1654585200"; 
   d="scan'208";a="640354039"
Received: from sqa-gate.sh.intel.com (HELO michael.clx.dev.tsp.org) ([10.239.48.212])
  by orsmga008.jf.intel.com with ESMTP; 27 Aug 2022 02:51:40 -0700
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
Subject: [PATCH 14/15] vfio: Rename vfio_device_put() and vfio_device_try_get()
Date:   Sun, 28 Aug 2022 01:10:36 +0800
Message-Id: <20220827171037.30297-15-kevin.tian@intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20220827171037.30297-1-kevin.tian@intel.com>
References: <20220827171037.30297-1-kevin.tian@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With the addition of vfio_put_device() now the names become confusing.

vfio_put_device() is clear from object life cycle p.o.v given kref.

vfio_device_put()/vfio_device_try_get() are helpers for tracking
users on a registered device.

Now rename them:

 - vfio_device_put() -> vfio_device_put_registration()
 - vfio_device_try_get() -> vfio_device_try_get_registration()

Signed-off-by: Kevin Tian <kevin.tian@intel.com>
---
 drivers/vfio/vfio_main.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 15a612153c13..0c5d120aeced 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -452,13 +452,13 @@ static void vfio_group_get(struct vfio_group *group)
  * Device objects - create, release, get, put, search
  */
 /* Device reference always implies a group reference */
-static void vfio_device_put(struct vfio_device *device)
+static void vfio_device_put_registration(struct vfio_device *device)
 {
 	if (refcount_dec_and_test(&device->refcount))
 		complete(&device->comp);
 }
 
-static bool vfio_device_try_get(struct vfio_device *device)
+static bool vfio_device_try_get_registration(struct vfio_device *device)
 {
 	return refcount_inc_not_zero(&device->refcount);
 }
@@ -470,7 +470,8 @@ static struct vfio_device *vfio_group_get_device(struct vfio_group *group,
 
 	mutex_lock(&group->device_lock);
 	list_for_each_entry(device, &group->device_list, group_next) {
-		if (device->dev == dev && vfio_device_try_get(device)) {
+		if (device->dev == dev &&
+		    vfio_device_try_get_registration(device)) {
 			mutex_unlock(&group->device_lock);
 			return device;
 		}
@@ -668,7 +669,7 @@ static int __vfio_register_dev(struct vfio_device *device,
 	if (existing_device) {
 		dev_WARN(device->dev, "Device already exists on group %d\n",
 			 iommu_group_id(group->iommu_group));
-		vfio_device_put(existing_device);
+		vfio_device_put_registration(existing_device);
 		if (group->type == VFIO_NO_IOMMU ||
 		    group->type == VFIO_EMULATED_IOMMU)
 			iommu_group_remove_device(device->dev);
@@ -727,7 +728,7 @@ static struct vfio_device *vfio_device_get_from_name(struct vfio_group *group,
 			ret = !strcmp(dev_name(it->dev), buf);
 		}
 
-		if (ret && vfio_device_try_get(it)) {
+		if (ret && vfio_device_try_get_registration(it)) {
 			device = it;
 			break;
 		}
@@ -747,7 +748,7 @@ void vfio_unregister_group_dev(struct vfio_device *device)
 	bool interrupted = false;
 	long rc;
 
-	vfio_device_put(device);
+	vfio_device_put_registration(device);
 	rc = try_wait_for_completion(&device->comp);
 	while (rc <= 0) {
 		if (device->ops->request)
@@ -1283,7 +1284,7 @@ static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
 err_put_fdno:
 	put_unused_fd(fdno);
 err_put_device:
-	vfio_device_put(device);
+	vfio_device_put_registration(device);
 	return ret;
 }
 
@@ -1458,7 +1459,7 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 
 	vfio_device_unassign_container(device);
 
-	vfio_device_put(device);
+	vfio_device_put_registration(device);
 
 	return 0;
 }
-- 
2.21.3

