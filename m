Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B682D5BF49B
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 05:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbiIUD1A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 23:27:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbiIUD0m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 23:26:42 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A360474D2;
        Tue, 20 Sep 2022 20:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663730800; x=1695266800;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dLDuI98+thpob8xF2Q1O8MqmB5dG3aZ+N6d84RGyRsU=;
  b=S/mLnyILVrY2htxhO2zKkerOVcQkB3/4r8mn/CUjiK43ApBZXi8iwnKV
   1WOm9EpI7Rv6b8N/i59ydf5QtzHp/yRn4cSvxNXFkLJvKi20mtMvyJdO6
   jgraHKqoyOIZ8un0SSyRTMGfVt4E7kMzMHKxL5KUBIBliP5mTZNErXzbX
   jMAlJPzhyYX8/NTenYddtr2pMxpW3tvPeDVDy86R+mmr4Bl6OcIqyv3NM
   ZOnNiK+yyyPFQfDIKQk1oZcZgo1OE18U45tw//c86FfUcxYHh6DuivuaE
   S+YJAcW70sazCRfPcqNTJ+RuaRX2CPITSOJ20oesmqPTW480LffV369IX
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10476"; a="300721940"
X-IronPort-AV: E=Sophos;i="5.93,332,1654585200"; 
   d="scan'208";a="300721940"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2022 20:26:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,332,1654585200"; 
   d="scan'208";a="761574135"
Received: from sqa-gate.sh.intel.com (HELO michael.clx.dev.tsp.org) ([10.239.48.212])
  by fmsmga001.fm.intel.com with ESMTP; 20 Sep 2022 20:26:31 -0700
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
Subject: [PATCH v4 02/15] vfio/pci: Use the new device life cycle helpers
Date:   Wed, 21 Sep 2022 18:43:48 +0800
Message-Id: <20220921104401.38898-3-kevin.tian@intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20220921104401.38898-1-kevin.tian@intel.com>
References: <20220921104401.38898-1-kevin.tian@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yi Liu <yi.l.liu@intel.com>

Also introduce two pci core helpers as @init/@release for pci drivers:

 - vfio_pci_core_init_dev()
 - vfio_pci_core_release_dev()

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
Signed-off-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/pci/vfio_pci.c      | 20 +++++++++---------
 drivers/vfio/pci/vfio_pci_core.c | 35 ++++++++++++++++++++++++++++++++
 include/linux/vfio_pci_core.h    |  2 ++
 3 files changed, 47 insertions(+), 10 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index d9b5c03f8d5b..1d4919edfbde 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -127,6 +127,8 @@ static int vfio_pci_open_device(struct vfio_device *core_vdev)
 
 static const struct vfio_device_ops vfio_pci_ops = {
 	.name		= "vfio-pci",
+	.init		= vfio_pci_core_init_dev,
+	.release	= vfio_pci_core_release_dev,
 	.open_device	= vfio_pci_open_device,
 	.close_device	= vfio_pci_core_close_device,
 	.ioctl		= vfio_pci_core_ioctl,
@@ -146,20 +148,19 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (vfio_pci_is_denylisted(pdev))
 		return -EINVAL;
 
-	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
-	if (!vdev)
-		return -ENOMEM;
-	vfio_pci_core_init_device(vdev, pdev, &vfio_pci_ops);
+	vdev = vfio_alloc_device(vfio_pci_core_device, vdev, &pdev->dev,
+				 &vfio_pci_ops);
+	if (IS_ERR(vdev))
+		return PTR_ERR(vdev);
 
 	dev_set_drvdata(&pdev->dev, vdev);
 	ret = vfio_pci_core_register_device(vdev);
 	if (ret)
-		goto out_free;
+		goto out_put_vdev;
 	return 0;
 
-out_free:
-	vfio_pci_core_uninit_device(vdev);
-	kfree(vdev);
+out_put_vdev:
+	vfio_put_device(&vdev->vdev);
 	return ret;
 }
 
@@ -168,8 +169,7 @@ static void vfio_pci_remove(struct pci_dev *pdev)
 	struct vfio_pci_core_device *vdev = dev_get_drvdata(&pdev->dev);
 
 	vfio_pci_core_unregister_device(vdev);
-	vfio_pci_core_uninit_device(vdev);
-	kfree(vdev);
+	vfio_put_device(&vdev->vdev);
 }
 
 static int vfio_pci_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 0a801aee2f2d..77d33739c6e8 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -2078,6 +2078,41 @@ static void vfio_pci_vga_uninit(struct vfio_pci_core_device *vdev)
 					      VGA_RSRC_LEGACY_MEM);
 }
 
+int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
+{
+	struct vfio_pci_core_device *vdev =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+
+	vdev->pdev = to_pci_dev(core_vdev->dev);
+	vdev->irq_type = VFIO_PCI_NUM_IRQS;
+	mutex_init(&vdev->igate);
+	spin_lock_init(&vdev->irqlock);
+	mutex_init(&vdev->ioeventfds_lock);
+	INIT_LIST_HEAD(&vdev->dummy_resources_list);
+	INIT_LIST_HEAD(&vdev->ioeventfds_list);
+	mutex_init(&vdev->vma_lock);
+	INIT_LIST_HEAD(&vdev->vma_list);
+	INIT_LIST_HEAD(&vdev->sriov_pfs_item);
+	init_rwsem(&vdev->memory_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vfio_pci_core_init_dev);
+
+void vfio_pci_core_release_dev(struct vfio_device *core_vdev)
+{
+	struct vfio_pci_core_device *vdev =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+
+	mutex_destroy(&vdev->igate);
+	mutex_destroy(&vdev->ioeventfds_lock);
+	mutex_destroy(&vdev->vma_lock);
+	kfree(vdev->region);
+	kfree(vdev->pm_save);
+	vfio_free_device(core_vdev);
+}
+EXPORT_SYMBOL_GPL(vfio_pci_core_release_dev);
+
 void vfio_pci_core_init_device(struct vfio_pci_core_device *vdev,
 			       struct pci_dev *pdev,
 			       const struct vfio_device_ops *vfio_pci_ops)
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 089b603bcfdc..0499ea836058 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -109,6 +109,8 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev);
 void vfio_pci_core_init_device(struct vfio_pci_core_device *vdev,
 			       struct pci_dev *pdev,
 			       const struct vfio_device_ops *vfio_pci_ops);
+int vfio_pci_core_init_dev(struct vfio_device *core_vdev);
+void vfio_pci_core_release_dev(struct vfio_device *core_vdev);
 int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev);
 void vfio_pci_core_uninit_device(struct vfio_pci_core_device *vdev);
 void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev);
-- 
2.21.3

