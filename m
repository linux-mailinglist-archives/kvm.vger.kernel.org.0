Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE29C5BF4A3
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 05:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbiIUD1i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 23:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbiIUD1F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 23:27:05 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21E0B7EFD3;
        Tue, 20 Sep 2022 20:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663730824; x=1695266824;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PLSizuz9vDeeSGCdeRUVMPA4v5McibZrBDgsqbk0XEw=;
  b=HpTZgTrjTFUDpW0SVCUPoGl1PmVbF1jAt8UxxBOvYA4ggHlLrF7dp5fo
   rdJedwW7SaN2YKk1uLlXS26owSbiqDVHEQnNdKXUCYIZIXAmgf9cERTrb
   6f47BBH8oJraKdTPyW1Bho52dpLw1numlIPXvSRFxPfbsvy3UO6d+lwMg
   9Wbq2/ZLO9L6zxN8g01J27agrylBBKl9MO3kYS8P5FBfB75i5rDwBkBu3
   ciUOQuWtACBCgJDhlhlKOl9q/wPviXks1OnDvoOIbrTu60V4m6HNE+brt
   nCzkH5OxWaUETsNU1+mW7/747t48T3UlxL0nCgAeZdugFqYNFdLZy2hAT
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10476"; a="326198272"
X-IronPort-AV: E=Sophos;i="5.93,332,1654585200"; 
   d="scan'208";a="326198272"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2022 20:27:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,332,1654585200"; 
   d="scan'208";a="761574218"
Received: from sqa-gate.sh.intel.com (HELO michael.clx.dev.tsp.org) ([10.239.48.212])
  by fmsmga001.fm.intel.com with ESMTP; 20 Sep 2022 20:26:55 -0700
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
        Christoph Hellwig <hch@infradead.org>,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH v4 05/15] vfio/mdpy: Use the new device life cycle helpers
Date:   Wed, 21 Sep 2022 18:43:51 +0800
Message-Id: <20220921104401.38898-6-kevin.tian@intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20220921104401.38898-1-kevin.tian@intel.com>
References: <20220921104401.38898-1-kevin.tian@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yi Liu <yi.l.liu@intel.com>

and manage mdpy_count inside @init/@release.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
Signed-off-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
---
 samples/vfio-mdev/mdpy.c | 81 +++++++++++++++++++++++-----------------
 1 file changed, 47 insertions(+), 34 deletions(-)

diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
index e8c46eb2e246..bb2af1ec0f7c 100644
--- a/samples/vfio-mdev/mdpy.c
+++ b/samples/vfio-mdev/mdpy.c
@@ -216,61 +216,77 @@ static int mdpy_reset(struct mdev_state *mdev_state)
 	return 0;
 }
 
-static int mdpy_probe(struct mdev_device *mdev)
+static int mdpy_init_dev(struct vfio_device *vdev)
 {
+	struct mdev_state *mdev_state =
+		container_of(vdev, struct mdev_state, vdev);
+	struct mdev_device *mdev = to_mdev_device(vdev->dev);
 	const struct mdpy_type *type =
 		&mdpy_types[mdev_get_type_group_id(mdev)];
-	struct device *dev = mdev_dev(mdev);
-	struct mdev_state *mdev_state;
 	u32 fbsize;
-	int ret;
+	int ret = -ENOMEM;
 
 	if (mdpy_count >= max_devices)
-		return -ENOMEM;
-
-	mdev_state = kzalloc(sizeof(struct mdev_state), GFP_KERNEL);
-	if (mdev_state == NULL)
-		return -ENOMEM;
-	vfio_init_group_dev(&mdev_state->vdev, &mdev->dev, &mdpy_dev_ops);
+		return ret;
 
 	mdev_state->vconfig = kzalloc(MDPY_CONFIG_SPACE_SIZE, GFP_KERNEL);
-	if (mdev_state->vconfig == NULL) {
-		ret = -ENOMEM;
-		goto err_state;
-	}
+	if (!mdev_state->vconfig)
+		return ret;
 
 	fbsize = roundup_pow_of_two(type->width * type->height * type->bytepp);
 
 	mdev_state->memblk = vmalloc_user(fbsize);
-	if (!mdev_state->memblk) {
-		ret = -ENOMEM;
-		goto err_vconfig;
-	}
-	dev_info(dev, "%s: %s (%dx%d)\n", __func__, type->name, type->width,
-		 type->height);
+	if (!mdev_state->memblk)
+		goto out_vconfig;
 
 	mutex_init(&mdev_state->ops_lock);
 	mdev_state->mdev = mdev;
-	mdev_state->type    = type;
+	mdev_state->type = type;
 	mdev_state->memsize = fbsize;
 	mdpy_create_config_space(mdev_state);
 	mdpy_reset(mdev_state);
 
+	dev_info(vdev->dev, "%s: %s (%dx%d)\n", __func__, type->name, type->width,
+		 type->height);
+
 	mdpy_count++;
+	return 0;
+
+out_vconfig:
+	kfree(mdev_state->vconfig);
+	return ret;
+}
+
+static int mdpy_probe(struct mdev_device *mdev)
+{
+	struct mdev_state *mdev_state;
+	int ret;
+
+	mdev_state = vfio_alloc_device(mdev_state, vdev, &mdev->dev,
+				       &mdpy_dev_ops);
+	if (IS_ERR(mdev_state))
+		return PTR_ERR(mdev_state);
 
 	ret = vfio_register_emulated_iommu_dev(&mdev_state->vdev);
 	if (ret)
-		goto err_mem;
+		goto err_put_vdev;
 	dev_set_drvdata(&mdev->dev, mdev_state);
 	return 0;
-err_mem:
+
+err_put_vdev:
+	vfio_put_device(&mdev_state->vdev);
+	return ret;
+}
+
+static void mdpy_release_dev(struct vfio_device *vdev)
+{
+	struct mdev_state *mdev_state =
+		container_of(vdev, struct mdev_state, vdev);
+
+	mdpy_count--;
 	vfree(mdev_state->memblk);
-err_vconfig:
 	kfree(mdev_state->vconfig);
-err_state:
-	vfio_uninit_group_dev(&mdev_state->vdev);
-	kfree(mdev_state);
-	return ret;
+	vfio_free_device(vdev);
 }
 
 static void mdpy_remove(struct mdev_device *mdev)
@@ -280,12 +296,7 @@ static void mdpy_remove(struct mdev_device *mdev)
 	dev_info(&mdev->dev, "%s\n", __func__);
 
 	vfio_unregister_group_dev(&mdev_state->vdev);
-	vfree(mdev_state->memblk);
-	kfree(mdev_state->vconfig);
-	vfio_uninit_group_dev(&mdev_state->vdev);
-	kfree(mdev_state);
-
-	mdpy_count--;
+	vfio_put_device(&mdev_state->vdev);
 }
 
 static ssize_t mdpy_read(struct vfio_device *vdev, char __user *buf,
@@ -708,6 +719,8 @@ static struct attribute_group *mdev_type_groups[] = {
 };
 
 static const struct vfio_device_ops mdpy_dev_ops = {
+	.init = mdpy_init_dev,
+	.release = mdpy_release_dev,
 	.read = mdpy_read,
 	.write = mdpy_write,
 	.ioctl = mdpy_ioctl,
-- 
2.21.3

