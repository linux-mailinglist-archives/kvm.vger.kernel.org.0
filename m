Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 530D05A368C
	for <lists+kvm@lfdr.de>; Sat, 27 Aug 2022 11:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234398AbiH0Jun (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Aug 2022 05:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234460AbiH0Ju0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Aug 2022 05:50:26 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E885F107;
        Sat, 27 Aug 2022 02:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661593819; x=1693129819;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FZ5hdZT6robo7+uwQVVe3h+/xlMhsTaJHT0t2T4polI=;
  b=Msp5MKqnMKZoNt2esPDZA38SD0OWPU6Uo74mF+VTe4Onvt3kM3qRUaYa
   Hk2HHeYBe9fS2Auv9fzgof2843fqWGo7sfwL+aaDSPa1AlWJyFEHouthn
   s+jMmODROlcJcaYG/SOwrREzh6RzxsMOijw1QZFDxjMf4Zhob4Z2HXWTs
   W1FUlvkZJ4hzX8ZsvYYpWOkcum4R8IAtNoXdbUcEZz0mbZ3VTQThNuS7c
   BUMHoJcVNuQVwCbOIsfT/AwSh0HMLDfCz2BuI+mYY0cNkZFrAyf+v7o8d
   VNsWVxj1+1ykko4uhZanfF+joIQs+LrnZ1aZFHS1XQvvr9OeCdIU7fLt3
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10451"; a="358616811"
X-IronPort-AV: E=Sophos;i="5.93,267,1654585200"; 
   d="scan'208";a="358616811"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2022 02:50:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,267,1654585200"; 
   d="scan'208";a="640353832"
Received: from sqa-gate.sh.intel.com (HELO michael.clx.dev.tsp.org) ([10.239.48.212])
  by orsmga008.jf.intel.com with ESMTP; 27 Aug 2022 02:50:04 -0700
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
Subject: [PATCH 03/15] vfio/mlx5: Use the new device life cycle helpers
Date:   Sun, 28 Aug 2022 01:10:25 +0800
Message-Id: <20220827171037.30297-4-kevin.tian@intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20220827171037.30297-1-kevin.tian@intel.com>
References: <20220827171037.30297-1-kevin.tian@intel.com>
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

From: Yi Liu <yi.l.liu@intel.com>

mlx5 has its own @init/@release for handling migration cap.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
Signed-off-by: Kevin Tian <kevin.tian@intel.com>
---
 drivers/vfio/pci/mlx5/main.c | 49 ++++++++++++++++++++++++++----------
 1 file changed, 36 insertions(+), 13 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index a9b63d15c5d3..96d1f974f0b5 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -579,8 +579,35 @@ static const struct vfio_migration_ops mlx5vf_pci_mig_ops = {
 	.migration_get_state = mlx5vf_pci_get_device_state,
 };
 
+static int mlx5vf_pci_init_dev(struct vfio_device *core_vdev)
+{
+	struct mlx5vf_pci_core_device *mvdev = container_of(
+		core_vdev, struct mlx5vf_pci_core_device, core_device.vdev);
+	int ret;
+
+	ret = vfio_pci_core_init_dev(core_vdev);
+	if (ret)
+		return ret;
+
+	mlx5vf_cmd_set_migratable(mvdev, &mlx5vf_pci_mig_ops);
+
+	return 0;
+
+}
+
+static void mlx5vf_pci_release_dev(struct vfio_device *core_vdev)
+{
+	struct mlx5vf_pci_core_device *mvdev = container_of(
+		core_vdev, struct mlx5vf_pci_core_device, core_device.vdev);
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
@@ -598,21 +625,19 @@ static int mlx5vf_pci_probe(struct pci_dev *pdev,
 	struct mlx5vf_pci_core_device *mvdev;
 	int ret;
 
-	mvdev = kzalloc(sizeof(*mvdev), GFP_KERNEL);
-	if (!mvdev)
-		return -ENOMEM;
-	vfio_pci_core_init_device(&mvdev->core_device, pdev, &mlx5vf_pci_ops);
-	mlx5vf_cmd_set_migratable(mvdev, &mlx5vf_pci_mig_ops);
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
 
@@ -621,9 +646,7 @@ static void mlx5vf_pci_remove(struct pci_dev *pdev)
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

