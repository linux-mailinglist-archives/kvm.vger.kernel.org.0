Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59345635BCE
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 12:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237158AbiKWLdg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 06:33:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236962AbiKWLdb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 06:33:31 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F62285A1D;
        Wed, 23 Nov 2022 03:33:29 -0800 (PST)
Received: from frapeml100002.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4NHJpj19r3z6H7DX;
        Wed, 23 Nov 2022 19:30:53 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 frapeml100002.china.huawei.com (7.182.85.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 12:33:27 +0100
Received: from A2006125610.china.huawei.com (10.202.227.178) by
 lhrpeml500005.china.huawei.com (7.191.163.240) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 11:33:22 +0000
From:   Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <kevin.tian@intel.com>,
        <linuxarm@huawei.com>, <liulongfang@huawei.com>,
        <prime.zeng@hisilicon.com>
Subject: [PATCH 3/4] hisi_acc_vfio_pci: Move the dev compatibility tests for early check
Date:   Wed, 23 Nov 2022 11:32:35 +0000
Message-ID: <20221123113236.896-4-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20221123113236.896-1-shameerali.kolothum.thodi@huawei.com>
References: <20221123113236.896-1-shameerali.kolothum.thodi@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.202.227.178]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instead of waiting till data transfer is complete to perform dev
compatibility, do it as soon as we have enough data to perform the
check. This will be useful when we enable the support for PRE_COPY.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 19 +++++++------------
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  1 +
 2 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index c8658636a84c..9a51f41e1d2a 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -360,8 +360,8 @@ static int vf_qm_check_match(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 	u32 que_iso_state;
 	int ret;
 
-	if (migf->total_length < QM_MATCH_SIZE)
-		return -EINVAL;
+	if (migf->total_length < QM_MATCH_SIZE || hisi_acc_vdev->match_done)
+		return 0;
 
 	if (vf_data->acc_magic != ACC_DEV_MAGIC) {
 		dev_err(dev, "failed to match ACC_DEV_MAGIC\n");
@@ -406,6 +406,7 @@ static int vf_qm_check_match(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 	}
 
 	hisi_acc_vdev->vf_qm_state = vf_data->vf_qm_state;
+	hisi_acc_vdev->match_done = true;
 	return 0;
 }
 
@@ -493,10 +494,6 @@ static int vf_qm_state_save(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 	struct device *dev = &vf_qm->pdev->dev;
 	int ret;
 
-	ret = vf_qm_get_match_data(hisi_acc_vdev, vf_data);
-	if (ret)
-		return ret;
-
 	if (unlikely(qm_wait_dev_not_ready(vf_qm))) {
 		/* Update state and return with match data */
 		vf_data->vf_qm_state = QM_NOT_READY;
@@ -673,12 +670,6 @@ static int hisi_acc_vf_load_state(struct hisi_acc_vf_core_device *hisi_acc_vdev)
 	struct hisi_acc_vf_migration_file *migf = hisi_acc_vdev->resuming_migf;
 	int ret;
 
-	/* Check dev compatibility */
-	ret = vf_qm_check_match(hisi_acc_vdev, migf);
-	if (ret) {
-		dev_err(dev, "failed to match the VF!\n");
-		return ret;
-	}
 	/* Recover data to VF */
 	ret = vf_qm_load_data(hisi_acc_vdev, migf);
 	if (ret) {
@@ -732,6 +723,10 @@ static ssize_t hisi_acc_vf_resume_write(struct file *filp, const char __user *bu
 	*pos += len;
 	done = len;
 	migf->total_length += len;
+
+	ret = vf_qm_check_match(migf->hisi_acc_vdev, migf);
+	if (ret)
+		done = -EFAULT;
 out_unlock:
 	mutex_unlock(&migf->lock);
 	return done;
diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
index 11d51345f5b5..dcabfeec6ca1 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
@@ -98,6 +98,7 @@ struct hisi_acc_vf_migration_file {
 
 struct hisi_acc_vf_core_device {
 	struct vfio_pci_core_device core_device;
+	u8 match_done:1;
 	u8 deferred_reset:1;
 	/* For migration state */
 	struct mutex state_mutex;
-- 
2.34.1

