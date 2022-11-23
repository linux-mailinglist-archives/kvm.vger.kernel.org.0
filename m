Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A66F7635BCF
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 12:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235751AbiKWLdd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 06:33:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236693AbiKWLdW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 06:33:22 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C6CC27CD1;
        Wed, 23 Nov 2022 03:33:22 -0800 (PST)
Received: from frapeml100005.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4NHJpY4mrpz6889H;
        Wed, 23 Nov 2022 19:30:45 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 frapeml100005.china.huawei.com (7.182.85.132) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 12:33:20 +0100
Received: from A2006125610.china.huawei.com (10.202.227.178) by
 lhrpeml500005.china.huawei.com (7.191.163.240) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 11:33:15 +0000
From:   Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <kevin.tian@intel.com>,
        <linuxarm@huawei.com>, <liulongfang@huawei.com>,
        <prime.zeng@hisilicon.com>
Subject: [PATCH 2/4] hisi_acc_vfio_pci: Introduce support for PRE_COPY state transitions
Date:   Wed, 23 Nov 2022 11:32:34 +0000
Message-ID: <20221123113236.896-3-shameerali.kolothum.thodi@huawei.com>
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

The saving_migf is open in PRE_COPY state if it is supported and reads
initial device match data. hisi_acc_vf_stop_copy() is refactored to
make use of common code.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 74 ++++++++++++++++++-
 1 file changed, 71 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index f3b74a06edb6..c8658636a84c 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -863,7 +863,7 @@ static const struct file_operations hisi_acc_vf_save_fops = {
 };
 
 static struct hisi_acc_vf_migration_file *
-hisi_acc_vf_stop_copy(struct hisi_acc_vf_core_device *hisi_acc_vdev)
+hisi_acc_open_saving_migf(struct hisi_acc_vf_core_device *hisi_acc_vdev)
 {
 	struct hisi_acc_vf_migration_file *migf;
 	int ret;
@@ -885,7 +885,7 @@ hisi_acc_vf_stop_copy(struct hisi_acc_vf_core_device *hisi_acc_vdev)
 	mutex_init(&migf->lock);
 	migf->hisi_acc_vdev = hisi_acc_vdev;
 
-	ret = vf_qm_state_save(hisi_acc_vdev, migf);
+	ret = vf_qm_get_match_data(hisi_acc_vdev, &migf->vf_data);
 	if (ret) {
 		fput(migf->filp);
 		return ERR_PTR(ret);
@@ -894,6 +894,44 @@ hisi_acc_vf_stop_copy(struct hisi_acc_vf_core_device *hisi_acc_vdev)
 	return migf;
 }
 
+static struct hisi_acc_vf_migration_file *
+hisi_acc_vf_pre_copy(struct hisi_acc_vf_core_device *hisi_acc_vdev)
+{
+	struct hisi_acc_vf_migration_file *migf;
+
+	migf = hisi_acc_open_saving_migf(hisi_acc_vdev);
+	if (IS_ERR(migf))
+		return migf;
+
+	migf->total_length = QM_MATCH_SIZE;
+	return migf;
+}
+
+static struct hisi_acc_vf_migration_file *
+hisi_acc_vf_stop_copy(struct hisi_acc_vf_core_device *hisi_acc_vdev, bool open)
+{
+	int ret;
+	struct hisi_acc_vf_migration_file *migf = NULL;
+
+	if (open) {
+		/*
+		 * Userspace didn't use PRECOPY support. Hence saving_migf
+		 * is not opened yet.
+		 */
+		migf = hisi_acc_open_saving_migf(hisi_acc_vdev);
+		if (IS_ERR(migf))
+			return migf;
+	} else {
+		migf = hisi_acc_vdev->saving_migf;
+	}
+
+	ret = vf_qm_state_save(hisi_acc_vdev, migf);
+	if (ret)
+		return ERR_PTR(ret);
+
+	return open ? migf : NULL;
+}
+
 static int hisi_acc_vf_stop_device(struct hisi_acc_vf_core_device *hisi_acc_vdev)
 {
 	struct device *dev = &hisi_acc_vdev->vf_dev->dev;
@@ -921,6 +959,31 @@ hisi_acc_vf_set_device_state(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 	u32 cur = hisi_acc_vdev->mig_state;
 	int ret;
 
+	if (cur == VFIO_DEVICE_STATE_RUNNING && new == VFIO_DEVICE_STATE_PRE_COPY) {
+		struct hisi_acc_vf_migration_file *migf;
+
+		migf = hisi_acc_vf_pre_copy(hisi_acc_vdev);
+		if (IS_ERR(migf))
+			return ERR_CAST(migf);
+		get_file(migf->filp);
+		hisi_acc_vdev->saving_migf = migf;
+		return migf->filp;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_PRE_COPY && new == VFIO_DEVICE_STATE_STOP_COPY) {
+		struct hisi_acc_vf_migration_file *migf;
+
+		ret = hisi_acc_vf_stop_device(hisi_acc_vdev);
+		if (ret)
+			return ERR_PTR(ret);
+
+		migf = hisi_acc_vf_stop_copy(hisi_acc_vdev, false);
+		if (IS_ERR(migf))
+			return ERR_CAST(migf);
+
+		return NULL;
+	}
+
 	if (cur == VFIO_DEVICE_STATE_RUNNING && new == VFIO_DEVICE_STATE_STOP) {
 		ret = hisi_acc_vf_stop_device(hisi_acc_vdev);
 		if (ret)
@@ -931,7 +994,7 @@ hisi_acc_vf_set_device_state(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 	if (cur == VFIO_DEVICE_STATE_STOP && new == VFIO_DEVICE_STATE_STOP_COPY) {
 		struct hisi_acc_vf_migration_file *migf;
 
-		migf = hisi_acc_vf_stop_copy(hisi_acc_vdev);
+		migf = hisi_acc_vf_stop_copy(hisi_acc_vdev, true);
 		if (IS_ERR(migf))
 			return ERR_CAST(migf);
 		get_file(migf->filp);
@@ -963,6 +1026,11 @@ hisi_acc_vf_set_device_state(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 		return NULL;
 	}
 
+	if (cur == VFIO_DEVICE_STATE_PRE_COPY && new == VFIO_DEVICE_STATE_RUNNING) {
+		hisi_acc_vf_disable_fds(hisi_acc_vdev);
+		return NULL;
+	}
+
 	if (cur == VFIO_DEVICE_STATE_STOP && new == VFIO_DEVICE_STATE_RUNNING) {
 		hisi_acc_vf_start_device(hisi_acc_vdev);
 		return NULL;
-- 
2.34.1

