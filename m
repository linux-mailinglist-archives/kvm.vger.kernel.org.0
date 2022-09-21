Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDBE5BF4A5
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 05:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbiIUD1Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 23:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231236AbiIUD0y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 23:26:54 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 761EE7E827;
        Tue, 20 Sep 2022 20:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663730808; x=1695266808;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+yssjGnk2Zp3MQF/9zrQ2m7m/7YA8Wye4MlvVDEJ0Mk=;
  b=Uj6Y4nLk1Uj3jIykKBlzSUEpYjGcwYkT47zrH2vybhSJzn8NgOjxwVfi
   u5NS+0NrJUneLAujLQJDiFc2tMo2t5tv7QrJSsFHhUI1ozmRDYoAs+5ib
   ITmbo1twHUxKD6Cfz+rIlMUioQXrRgCt62Ish0RquyvWhxbb3oFOmA0wo
   NCgjMzZKR7W5cJicBvpPiK9vepugHeyxKLoYJY2sCIsRbWEPOKA8BoYeP
   ILmlAFc56BUPATFmErw9r/oeWvbdbqOwA3z5knl+62tZBxnWnTM4qOk5N
   wzL5CDafm9MtrzcsnHrn4doThzCxaJ5rqEB3UkCMh1CT/eEK15pDsgUwp
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10476"; a="282933639"
X-IronPort-AV: E=Sophos;i="5.93,332,1654585200"; 
   d="scan'208";a="282933639"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2022 20:26:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,332,1654585200"; 
   d="scan'208";a="761574172"
Received: from sqa-gate.sh.intel.com (HELO michael.clx.dev.tsp.org) ([10.239.48.212])
  by fmsmga001.fm.intel.com with ESMTP; 20 Sep 2022 20:26:39 -0700
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
Subject: [PATCH v4 03/15] vfio/mlx5: Use the new device life cycle helpers
Date:   Wed, 21 Sep 2022 18:43:49 +0800
Message-Id: <20220921104401.38898-4-kevin.tian@intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20220921104401.38898-1-kevin.tian@intel.com>
References: <20220921104401.38898-1-kevin.tian@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yi Liu <yi.l.liu@intel.com>

mlx5 has its own @init/@release for handling migration cap.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
Signed-off-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/pci/mlx5/main.c | 50 ++++++++++++++++++++++++++----------
 1 file changed, 36 insertions(+), 14 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 759a5f5f7b3f..fd6ccb8454a2 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -585,8 +585,35 @@ static const struct vfio_log_ops mlx5vf_pci_log_ops = {
 	.log_read_and_clear = mlx5vf_tracker_read_and_clear,
 };
 
+static int mlx5vf_pci_init_dev(struct vfio_device *core_vdev)
+{
+	struct mlx5vf_pci_core_device *mvdev = container_of(core_vdev,
+			struct mlx5vf_pci_core_device, core_device.vdev);
+	int ret;
+
+	ret = vfio_pci_core_init_dev(core_vdev);
+	if (ret)
+		return ret;
+
+	mlx5vf_cmd_set_migratable(mvdev, &mlx5vf_pci_mig_ops,
+				  &mlx5vf_pci_log_ops);
+
+	return 0;
+}
+
+static void mlx5vf_pci_release_dev(struct vfio_device *core_vdev)
+{
+	struct mlx5vf_pci_core_device *mvdev = container_of(core_vdev,
+			struct mlx5vf_pci_core_device, core_device.vdev);
+
+	mlx5vf_cmd_remove_migratable(mvdev);
+	vfio_pci_core_release_dev(core_vdev);
+}
+
 static const struct vfio_device_ops mlx5vf_pci_ops = {
 	.name = "mlx5-vfio-pci",
+	.init = mlx5vf_pci_init_dev,
+	.release = mlx5vf_pci_release_dev,
 	.open_device = mlx5vf_pci_open_device,
 	.close_device = mlx5vf_pci_close_device,
 	.ioctl = vfio_pci_core_ioctl,
@@ -604,22 +631,19 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
 	struct mlx5vf_pci_core_device *mvdev;
 	int ret;
 
-	mvdev = kzalloc(sizeof(*mvdev), GFP_KERNEL);
-	if (!mvdev)
-		return -ENOMEM;
-	vfio_pci_core_init_device(&mvdev->core_device, pdev, &mlx5vf_pci_ops);
-	mlx5vf_cmd_set_migratable(mvdev, &mlx5vf_pci_mig_ops,
-				  &mlx5vf_pci_log_ops);
+	mvdev = vfio_alloc_device(mlx5vf_pci_core_device, core_device.vdev,
+				  &pdev->dev, &mlx5vf_pci_ops);
+	if (IS_ERR(mvdev))
+		return PTR_ERR(mvdev);
+
 	dev_set_drvdata(&pdev->dev, &mvdev->core_device);
 	ret = vfio_pci_core_register_device(&mvdev->core_device);
 	if (ret)
-		goto out_free;
+		goto out_put_vdev;
 	return 0;
 
-out_free:
-	mlx5vf_cmd_remove_migratable(mvdev);
-	vfio_pci_core_uninit_device(&mvdev->core_device);
-	kfree(mvdev);
+out_put_vdev:
+	vfio_put_device(&mvdev->core_device.vdev);
 	return ret;
 }
 
@@ -628,9 +652,7 @@ static void mlx5vf_pci_remove(struct pci_dev *pdev)
 	struct mlx5vf_pci_core_device *mvdev = mlx5vf_drvdata(pdev);
 
 	vfio_pci_core_unregister_device(&mvdev->core_device);
-	mlx5vf_cmd_remove_migratable(mvdev);
-	vfio_pci_core_uninit_device(&mvdev->core_device);
-	kfree(mvdev);
+	vfio_put_device(&mvdev->core_device.vdev);
 }
 
 static const struct pci_device_id mlx5vf_pci_table[] = {
-- 
2.21.3

