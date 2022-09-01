Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1070B5A8FC1
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 09:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233798AbiIAHSe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 03:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233761AbiIAHSS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 03:18:18 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A37A612692F;
        Thu,  1 Sep 2022 00:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662016690; x=1693552690;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=d9HV5kRnZmeL8WOt4MMISsBwTXV0aLXgH/DZUxxhT4Y=;
  b=dXFhiHQx+BkeHjIhkDJ4RL808xweInJFRI962T47GJJiO50Mezj4kf8u
   FqRLa4UwADY4U8DXTx2k4YBpouLb4jpYjzMcm/WuHwxNQ5ROBAU5gx3kv
   PXzDEGMTX9RMYzM5MRxI5fYrpaM7z7qQzVkkOy8MgW1E5ndeT7pu3vW+X
   OUSSfymYlBmRMlx8hv/gaw1wlfiyYdbcVPmn9QHf774Hqvv9WTNZ6O9iK
   grWdKDJaIa4xLQApQHgEfFkrMOKG1yZvFzYEXastsrNImbYkuYQNT1M25
   8FVq0WiCbVNfZM9xgs04P4+RHdGOgAlpq+rQ/ws42inCghQLWzQrjSpBo
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="321782991"
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="321782991"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 00:18:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="673720045"
Received: from sqa-gate.sh.intel.com (HELO michael.clx.dev.tsp.org) ([10.239.48.212])
  by fmsmga008.fm.intel.com with ESMTP; 01 Sep 2022 00:17:59 -0700
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
Subject: [PATCH v2 04/15] vfio/hisi_acc: Use the new device life cycle helpers
Date:   Thu,  1 Sep 2022 22:37:36 +0800
Message-Id: <20220901143747.32858-5-kevin.tian@intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20220901143747.32858-1-kevin.tian@intel.com>
References: <20220901143747.32858-1-kevin.tian@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yi Liu <yi.l.liu@intel.com>

Tidy up @probe so all migration specific initialization logic is moved
to migration specific @init callback.

Remove vfio_pci_core_{un}init_device() given no user now.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
Signed-off-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 80 +++++++++----------
 drivers/vfio/pci/vfio_pci_core.c              | 30 -------
 include/linux/vfio_pci_core.h                 |  4 -
 3 files changed, 37 insertions(+), 77 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index ea762e28c1cc..f6e9c6b52eaa 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -1213,8 +1213,28 @@ static const struct vfio_migration_ops hisi_acc_vfio_pci_migrn_state_ops = {
 	.migration_get_state = hisi_acc_vfio_pci_get_device_state,
 };
 
+static int hisi_acc_vfio_pci_migrn_init_dev(struct vfio_device *core_vdev)
+{
+	struct hisi_acc_vf_core_device *hisi_acc_vdev = container_of(core_vdev,
+			struct hisi_acc_vf_core_device, core_device.vdev);
+	struct pci_dev *pdev = to_pci_dev(core_vdev->dev);
+	struct hisi_qm *pf_qm = hisi_acc_get_pf_qm(pdev);
+
+	hisi_acc_vdev->vf_id = pci_iov_vf_id(pdev) + 1;
+	hisi_acc_vdev->pf_qm = pf_qm;
+	hisi_acc_vdev->vf_dev = pdev;
+	mutex_init(&hisi_acc_vdev->state_mutex);
+
+	core_vdev->migration_flags = VFIO_MIGRATION_STOP_COPY;
+	core_vdev->mig_ops = &hisi_acc_vfio_pci_migrn_state_ops;
+
+	return vfio_pci_core_init_dev(core_vdev);
+}
+
 static const struct vfio_device_ops hisi_acc_vfio_pci_migrn_ops = {
 	.name = "hisi-acc-vfio-pci-migration",
+	.init = hisi_acc_vfio_pci_migrn_init_dev,
+	.release = vfio_pci_core_release_dev,
 	.open_device = hisi_acc_vfio_pci_open_device,
 	.close_device = hisi_acc_vfio_pci_close_device,
 	.ioctl = hisi_acc_vfio_pci_ioctl,
@@ -1228,6 +1248,8 @@ static const struct vfio_device_ops hisi_acc_vfio_pci_migrn_ops = {
 
 static const struct vfio_device_ops hisi_acc_vfio_pci_ops = {
 	.name = "hisi-acc-vfio-pci",
+	.init = vfio_pci_core_init_dev,
+	.release = vfio_pci_core_release_dev,
 	.open_device = hisi_acc_vfio_pci_open_device,
 	.close_device = vfio_pci_core_close_device,
 	.ioctl = vfio_pci_core_ioctl,
@@ -1239,63 +1261,36 @@ static const struct vfio_device_ops hisi_acc_vfio_pci_ops = {
 	.match = vfio_pci_core_match,
 };
 
-static int
-hisi_acc_vfio_pci_migrn_init(struct hisi_acc_vf_core_device *hisi_acc_vdev,
-			     struct pci_dev *pdev, struct hisi_qm *pf_qm)
-{
-	int vf_id;
-
-	vf_id = pci_iov_vf_id(pdev);
-	if (vf_id < 0)
-		return vf_id;
-
-	hisi_acc_vdev->vf_id = vf_id + 1;
-	hisi_acc_vdev->core_device.vdev.migration_flags =
-					VFIO_MIGRATION_STOP_COPY;
-	hisi_acc_vdev->pf_qm = pf_qm;
-	hisi_acc_vdev->vf_dev = pdev;
-	mutex_init(&hisi_acc_vdev->state_mutex);
-
-	return 0;
-}
-
 static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct hisi_acc_vf_core_device *hisi_acc_vdev;
+	const struct vfio_device_ops *ops = &hisi_acc_vfio_pci_ops;
 	struct hisi_qm *pf_qm;
+	int vf_id;
 	int ret;
 
-	hisi_acc_vdev = kzalloc(sizeof(*hisi_acc_vdev), GFP_KERNEL);
-	if (!hisi_acc_vdev)
-		return -ENOMEM;
-
 	pf_qm = hisi_acc_get_pf_qm(pdev);
 	if (pf_qm && pf_qm->ver >= QM_HW_V3) {
-		ret = hisi_acc_vfio_pci_migrn_init(hisi_acc_vdev, pdev, pf_qm);
-		if (!ret) {
-			vfio_pci_core_init_device(&hisi_acc_vdev->core_device, pdev,
-						  &hisi_acc_vfio_pci_migrn_ops);
-			hisi_acc_vdev->core_device.vdev.mig_ops =
-					&hisi_acc_vfio_pci_migrn_state_ops;
-		} else {
+		vf_id = pci_iov_vf_id(pdev);
+		if (vf_id >= 0)
+			ops = &hisi_acc_vfio_pci_migrn_ops;
+		else
 			pci_warn(pdev, "migration support failed, continue with generic interface\n");
-			vfio_pci_core_init_device(&hisi_acc_vdev->core_device, pdev,
-						  &hisi_acc_vfio_pci_ops);
-		}
-	} else {
-		vfio_pci_core_init_device(&hisi_acc_vdev->core_device, pdev,
-					  &hisi_acc_vfio_pci_ops);
 	}
 
+	hisi_acc_vdev = vfio_alloc_device(hisi_acc_vf_core_device,
+					  core_device.vdev, &pdev->dev, ops);
+	if (IS_ERR(hisi_acc_vdev))
+		return PTR_ERR(hisi_acc_vdev);
+
 	dev_set_drvdata(&pdev->dev, &hisi_acc_vdev->core_device);
 	ret = vfio_pci_core_register_device(&hisi_acc_vdev->core_device);
 	if (ret)
-		goto out_free;
+		goto out_put_vdev;
 	return 0;
 
-out_free:
-	vfio_pci_core_uninit_device(&hisi_acc_vdev->core_device);
-	kfree(hisi_acc_vdev);
+out_put_vdev:
+	vfio_put_device(&hisi_acc_vdev->core_device.vdev);
 	return ret;
 }
 
@@ -1304,8 +1299,7 @@ static void hisi_acc_vfio_pci_remove(struct pci_dev *pdev)
 	struct hisi_acc_vf_core_device *hisi_acc_vdev = hssi_acc_drvdata(pdev);
 
 	vfio_pci_core_unregister_device(&hisi_acc_vdev->core_device);
-	vfio_pci_core_uninit_device(&hisi_acc_vdev->core_device);
-	kfree(hisi_acc_vdev);
+	vfio_put_device(&hisi_acc_vdev->core_device.vdev);
 }
 
 static const struct pci_device_id hisi_acc_vfio_pci_table[] = {
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 708b61d1b364..f29d780e327e 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1860,36 +1860,6 @@ void vfio_pci_core_release_dev(struct vfio_device *core_vdev)
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_release_dev);
 
-void vfio_pci_core_init_device(struct vfio_pci_core_device *vdev,
-			       struct pci_dev *pdev,
-			       const struct vfio_device_ops *vfio_pci_ops)
-{
-	vfio_init_group_dev(&vdev->vdev, &pdev->dev, vfio_pci_ops);
-	vdev->pdev = pdev;
-	vdev->irq_type = VFIO_PCI_NUM_IRQS;
-	mutex_init(&vdev->igate);
-	spin_lock_init(&vdev->irqlock);
-	mutex_init(&vdev->ioeventfds_lock);
-	INIT_LIST_HEAD(&vdev->dummy_resources_list);
-	INIT_LIST_HEAD(&vdev->ioeventfds_list);
-	mutex_init(&vdev->vma_lock);
-	INIT_LIST_HEAD(&vdev->vma_list);
-	INIT_LIST_HEAD(&vdev->sriov_pfs_item);
-	init_rwsem(&vdev->memory_lock);
-}
-EXPORT_SYMBOL_GPL(vfio_pci_core_init_device);
-
-void vfio_pci_core_uninit_device(struct vfio_pci_core_device *vdev)
-{
-	mutex_destroy(&vdev->igate);
-	mutex_destroy(&vdev->ioeventfds_lock);
-	mutex_destroy(&vdev->vma_lock);
-	vfio_uninit_group_dev(&vdev->vdev);
-	kfree(vdev->region);
-	kfree(vdev->pm_save);
-}
-EXPORT_SYMBOL_GPL(vfio_pci_core_uninit_device);
-
 int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 98c8c66e2400..9f10ff34b2ba 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -230,13 +230,9 @@ static inline void vfio_pci_zdev_close_device(struct vfio_pci_core_device *vdev)
 void vfio_pci_core_set_params(bool nointxmask, bool is_disable_vga,
 			      bool is_disable_idle_d3);
 void vfio_pci_core_close_device(struct vfio_device *core_vdev);
-void vfio_pci_core_init_device(struct vfio_pci_core_device *vdev,
-			       struct pci_dev *pdev,
-			       const struct vfio_device_ops *vfio_pci_ops);
 int vfio_pci_core_init_dev(struct vfio_device *core_vdev);
 void vfio_pci_core_release_dev(struct vfio_device *core_vdev);
 int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev);
-void vfio_pci_core_uninit_device(struct vfio_pci_core_device *vdev);
 void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev);
 extern const struct pci_error_handlers vfio_pci_core_err_handlers;
 int vfio_pci_core_sriov_configure(struct vfio_pci_core_device *vdev,
-- 
2.21.3

