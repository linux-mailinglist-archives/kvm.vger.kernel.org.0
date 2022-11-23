Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCEB3635BCD
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 12:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236737AbiKWLdb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 06:33:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237204AbiKWLdT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 06:33:19 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A8A5CD28;
        Wed, 23 Nov 2022 03:33:14 -0800 (PST)
Received: from frapeml100006.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4NHJpQ460Dz67JVF;
        Wed, 23 Nov 2022 19:30:38 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 frapeml100006.china.huawei.com (7.182.85.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 12:33:13 +0100
Received: from A2006125610.china.huawei.com (10.202.227.178) by
 lhrpeml500005.china.huawei.com (7.191.163.240) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 11:33:07 +0000
From:   Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <kevin.tian@intel.com>,
        <linuxarm@huawei.com>, <liulongfang@huawei.com>,
        <prime.zeng@hisilicon.com>
Subject: [PATCH 1/4] hisi_acc_vfio_pci: Add support for precopy IOCTL
Date:   Wed, 23 Nov 2022 11:32:33 +0000
Message-ID: <20221123113236.896-2-shameerali.kolothum.thodi@huawei.com>
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

PRECOPY IOCTL in the case of HiSiIicon ACC driver can be used to
perform the device compatibility check earlier during migration.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 52 +++++++++++++++++++
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  1 +
 2 files changed, 53 insertions(+)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index 0c0c0c7f0521..f3b74a06edb6 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -764,9 +764,58 @@ hisi_acc_vf_pci_resume(struct hisi_acc_vf_core_device *hisi_acc_vdev)
 
 	stream_open(migf->filp->f_inode, migf->filp);
 	mutex_init(&migf->lock);
+	migf->hisi_acc_vdev = hisi_acc_vdev;
 	return migf;
 }
 
+static long hisi_acc_vf_precopy_ioctl(struct file *filp,
+				      unsigned int cmd, unsigned long arg)
+{
+	struct hisi_acc_vf_migration_file *migf = filp->private_data;
+	struct hisi_acc_vf_core_device *hisi_acc_vdev = migf->hisi_acc_vdev;
+	loff_t *pos = &filp->f_pos;
+	struct vfio_precopy_info info;
+	unsigned long minsz;
+	int ret;
+
+	if (cmd != VFIO_MIG_GET_PRECOPY_INFO)
+		return -ENOTTY;
+
+	minsz = offsetofend(struct vfio_precopy_info, dirty_bytes);
+
+	if (copy_from_user(&info, (void __user *)arg, minsz))
+		return -EFAULT;
+	if (info.argsz < minsz)
+		return -EINVAL;
+
+	mutex_lock(&hisi_acc_vdev->state_mutex);
+	if (hisi_acc_vdev->mig_state != VFIO_DEVICE_STATE_PRE_COPY) {
+		mutex_unlock(&hisi_acc_vdev->state_mutex);
+		return -EINVAL;
+	}
+
+	mutex_lock(&migf->lock);
+
+	if (migf->disabled) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	if (*pos > migf->total_length) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	info.dirty_bytes = 0;
+	info.initial_bytes = migf->total_length - *pos;
+
+	ret = copy_to_user((void __user *)arg, &info, minsz) ? -EFAULT : 0;
+out:
+	mutex_unlock(&migf->lock);
+	mutex_unlock(&hisi_acc_vdev->state_mutex);
+	return ret;
+}
+
 static ssize_t hisi_acc_vf_save_read(struct file *filp, char __user *buf, size_t len,
 				     loff_t *pos)
 {
@@ -807,6 +856,8 @@ static ssize_t hisi_acc_vf_save_read(struct file *filp, char __user *buf, size_t
 static const struct file_operations hisi_acc_vf_save_fops = {
 	.owner = THIS_MODULE,
 	.read = hisi_acc_vf_save_read,
+	.unlocked_ioctl = hisi_acc_vf_precopy_ioctl,
+	.compat_ioctl = compat_ptr_ioctl,
 	.release = hisi_acc_vf_release_file,
 	.llseek = no_llseek,
 };
@@ -832,6 +883,7 @@ hisi_acc_vf_stop_copy(struct hisi_acc_vf_core_device *hisi_acc_vdev)
 
 	stream_open(migf->filp->f_inode, migf->filp);
 	mutex_init(&migf->lock);
+	migf->hisi_acc_vdev = hisi_acc_vdev;
 
 	ret = vf_qm_state_save(hisi_acc_vdev, migf);
 	if (ret) {
diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
index 67343325b320..11d51345f5b5 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
@@ -91,6 +91,7 @@ struct hisi_acc_vf_migration_file {
 	struct mutex lock;
 	bool disabled;
 
+	struct hisi_acc_vf_core_device *hisi_acc_vdev;
 	struct acc_vf_data vf_data;
 	size_t total_length;
 };
-- 
2.34.1

