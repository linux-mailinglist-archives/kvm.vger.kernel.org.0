Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 021614BE365
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 18:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356673AbiBULnD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 06:43:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356675AbiBULmn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 06:42:43 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B786F1B78D;
        Mon, 21 Feb 2022 03:42:20 -0800 (PST)
Received: from fraeml745-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K2KzP3868z682g5;
        Mon, 21 Feb 2022 19:37:37 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml745-chm.china.huawei.com (10.206.15.226) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 21 Feb 2022 12:42:18 +0100
Received: from A2006125610.china.huawei.com (10.47.91.169) by
 lhreml710-chm.china.huawei.com (10.201.108.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 21 Feb 2022 11:42:12 +0000
From:   Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
CC:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <cohuck@redhat.com>, <mgurtovoy@nvidia.com>, <yishaih@nvidia.com>,
        <linuxarm@huawei.com>, <liulongfang@huawei.com>,
        <prime.zeng@hisilicon.com>, <jonathan.cameron@huawei.com>,
        <wangzhou1@hisilicon.com>
Subject: [PATCH v5 8/8] hisi_acc_vfio_pci: Use its own PCI reset_done error handler
Date:   Mon, 21 Feb 2022 11:40:43 +0000
Message-ID: <20220221114043.2030-9-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20220221114043.2030-1-shameerali.kolothum.thodi@huawei.com>
References: <20220221114043.2030-1-shameerali.kolothum.thodi@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.47.91.169]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Register private handler for pci_error_handlers.reset_done and update
state accordingly.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 56 ++++++++++++++++++-
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  4 +-
 2 files changed, 56 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index 6ad41375ac71..d485fac69577 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -885,6 +885,26 @@ hisi_acc_vf_set_device_state(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 	return ERR_PTR(-EINVAL);
 }
 
+/*
+ * This function is called in all state_mutex unlock cases to
+ * handle a 'deferred_reset' if exists.
+ */
+static void hisi_acc_vf_state_mutex_unlock(struct hisi_acc_vf_core_device *hisi_acc_vdev)
+{
+again:
+	spin_lock(&hisi_acc_vdev->reset_lock);
+	if (hisi_acc_vdev->deferred_reset) {
+		hisi_acc_vdev->deferred_reset = false;
+		spin_unlock(&hisi_acc_vdev->reset_lock);
+		hisi_acc_vdev->vf_qm_state = QM_NOT_READY;
+		hisi_acc_vdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
+		hisi_acc_vf_disable_fds(hisi_acc_vdev);
+		goto again;
+	}
+	mutex_unlock(&hisi_acc_vdev->state_mutex);
+	spin_unlock(&hisi_acc_vdev->reset_lock);
+}
+
 static struct file *
 hisi_acc_vfio_pci_set_device_state(struct vfio_device *vdev,
 				   enum vfio_device_mig_state new_state)
@@ -915,7 +935,7 @@ hisi_acc_vfio_pci_set_device_state(struct vfio_device *vdev,
 			break;
 		}
 	}
-	mutex_unlock(&hisi_acc_vdev->state_mutex);
+	hisi_acc_vf_state_mutex_unlock(hisi_acc_vdev);
 	return res;
 }
 
@@ -928,10 +948,35 @@ hisi_acc_vfio_pci_get_device_state(struct vfio_device *vdev,
 
 	mutex_lock(&hisi_acc_vdev->state_mutex);
 	*curr_state = hisi_acc_vdev->mig_state;
-	mutex_unlock(&hisi_acc_vdev->state_mutex);
+	hisi_acc_vf_state_mutex_unlock(hisi_acc_vdev);
 	return 0;
 }
 
+static void hisi_acc_vf_pci_aer_reset_done(struct pci_dev *pdev)
+{
+	struct hisi_acc_vf_core_device *hisi_acc_vdev = dev_get_drvdata(&pdev->dev);
+
+	if (hisi_acc_vdev->core_device.vdev.migration_flags !=
+				VFIO_MIGRATION_STOP_COPY)
+		return;
+
+	/*
+	 * As the higher VFIO layers are holding locks across reset and using
+	 * those same locks with the mm_lock we need to prevent ABBA deadlock
+	 * with the state_mutex and mm_lock.
+	 * In case the state_mutex was taken already we defer the cleanup work
+	 * to the unlock flow of the other running context.
+	 */
+	spin_lock(&hisi_acc_vdev->reset_lock);
+	hisi_acc_vdev->deferred_reset = true;
+	if (!mutex_trylock(&hisi_acc_vdev->state_mutex)) {
+		spin_unlock(&hisi_acc_vdev->reset_lock);
+		return;
+	}
+	spin_unlock(&hisi_acc_vdev->reset_lock);
+	hisi_acc_vf_state_mutex_unlock(hisi_acc_vdev);
+}
+
 static int hisi_acc_vf_qm_init(struct hisi_acc_vf_core_device *hisi_acc_vdev)
 {
 	struct vfio_pci_core_device *vdev = &hisi_acc_vdev->core_device;
@@ -1250,12 +1295,17 @@ static const struct pci_device_id hisi_acc_vfio_pci_table[] = {
 
 MODULE_DEVICE_TABLE(pci, hisi_acc_vfio_pci_table);
 
+static const struct pci_error_handlers hisi_acc_vf_err_handlers = {
+	.reset_done = hisi_acc_vf_pci_aer_reset_done,
+	.error_detected = vfio_pci_core_aer_err_detected,
+};
+
 static struct pci_driver hisi_acc_vfio_pci_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = hisi_acc_vfio_pci_table,
 	.probe = hisi_acc_vfio_pci_probe,
 	.remove = hisi_acc_vfio_pci_remove,
-	.err_handler = &vfio_pci_core_err_handlers,
+	.err_handler = &hisi_acc_vf_err_handlers,
 };
 
 module_pci_driver(hisi_acc_vfio_pci_driver);
diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
index 4aedea108152..ae560732e2da 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
@@ -101,6 +101,7 @@ struct hisi_acc_vf_migration_file {
 
 struct hisi_acc_vf_core_device {
 	struct vfio_pci_core_device core_device;
+	u8 deferred_reset:1;
 	/* for migration state */
 	struct mutex state_mutex;
 	enum vfio_device_mig_state mig_state;
@@ -110,7 +111,8 @@ struct hisi_acc_vf_core_device {
 	struct hisi_qm vf_qm;
 	u32 vf_qm_state;
 	int vf_id;
-
+	/* for reset handler */
+	spinlock_t reset_lock;
 	struct hisi_acc_vf_migration_file *resuming_migf;
 	struct hisi_acc_vf_migration_file *saving_migf;
 };
-- 
2.25.1

