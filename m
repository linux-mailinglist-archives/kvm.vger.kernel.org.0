Return-Path: <kvm+bounces-15921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CC75A8B22D0
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 15:31:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84064283456
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 13:31:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 093E8149C70;
	Thu, 25 Apr 2024 13:30:35 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E86149C58;
	Thu, 25 Apr 2024 13:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714051834; cv=none; b=mkcxNh70km/WnZPcR9iX+5SIhKo0qLdX5/1ql2sSLZhEYCprDEIlbHfhJGij2R3k7fmKo070xTrxsDJ6+7eSSyI4CmSCjSNCsW9g25KB/pxXpdryYYvRRmqqQPkq0UrCO1RzEcvMZBi5eL5wyJt7SZZXb/2L+V1AItj07tVHWPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714051834; c=relaxed/simple;
	bh=BHWsyTvLsqlVEXVvfoo7SdClSgWyr1ev3Dy2GAJ8x2k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aCooVjIBGC0FtAdlcc8PixjqSRULMZRU9qs4cic5ukatoknTp9MfXXochhqMHlVanr40niLsA0NQ+XQW4m2HfXqcyxv6X+Xs2Cr0M3ATUp7QAozRp21ye8Wf2ydKCrn3wonkiocYLuQiQ+ok7WBSp4J8d8Y7JOOdyCbZOZ8CzZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4VQGst3zwqzcbXn;
	Thu, 25 Apr 2024 21:29:22 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (unknown [7.193.23.191])
	by mail.maildlp.com (Postfix) with ESMTPS id A43611800AA;
	Thu, 25 Apr 2024 21:30:27 +0800 (CST)
Received: from huawei.com (10.50.165.33) by kwepemm600005.china.huawei.com
 (7.193.23.191) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Thu, 25 Apr
 2024 21:30:27 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v6 4/5] hisi_acc_vfio_pci: register debugfs for hisilicon migration driver
Date: Thu, 25 Apr 2024 21:23:21 +0800
Message-ID: <20240425132322.12041-5-liulongfang@huawei.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20240425132322.12041-1-liulongfang@huawei.com>
References: <20240425132322.12041-1-liulongfang@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600005.china.huawei.com (7.193.23.191)

On the debugfs framework of VFIO, if the CONFIG_VFIO_DEBUGFS macro is
enabled, the debug function is registered for the live migration driver
of the HiSilicon accelerator device.

After registering the HiSilicon accelerator device on the debugfs
framework of live migration of vfio, a directory file "hisi_acc"
of debugfs is created, and then three debug function files are
created in this directory:

   vfio
    |
    +---<dev_name1>
    |    +---migration
    |        +--state
    |        +--hisi_acc
    |            +--dev_data
    |            +--migf_data
    |            +--cmd_state
    |
    +---<dev_name2>
         +---migration
             +--state
             +--hisi_acc
                 +--dev_data
                 +--migf_data
                 +--cmd_state

dev_data file: read device data that needs to be migrated from the
current device in real time
migf_data file: read the migration data of the last live migration
from the current driver.
cmd_state: used to get the cmd channel state for the device.

+----------------+        +--------------+       +---------------+
| migration dev  |        |   src  dev   |       |   dst  dev    |
+-------+--------+        +------+-------+       +-------+-------+
        |                        |                       |
        |                 +------v-------+       +-------v-------+
        |                 |  saving_mif  |       | resuming_migf |
  read  |                 |     file     |       |     file      |
        |                 +------+-------+       +-------+-------+
        |                        |          copy         |
        |                        +------------+----------+
        |                                     |
+-------v---------+                   +-------v--------+
|   data buffer   |                   |   debug_migf   |
+-------+---------+                   +-------+--------+
        |                                     |
   cat  |                                 cat |
+-------v--------+                    +-------v--------+
|   dev_data     |                    |   migf_data    |
+----------------+                    +----------------+

When accessing debugfs, user can obtain the real-time status data
of the device through the "dev_data" file. It will directly read
the device status data and will not affect the live migration
function. Its data is stored in the allocated memory buffer,
and the memory is released after data returning to user mode.

To obtain the data of the last complete migration, user need to
obtain it through the "migf_data" file. Since the live migration
data only exists during the migration process, it is destroyed
after the migration is completed.
In order to save this data, a debug_migf file is created in the
driver. At the end of the live migration process, copy the data
to debug_migf.

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
---
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 225 ++++++++++++++++++
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |   7 +
 2 files changed, 232 insertions(+)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index bf358ba94b5d..656b3d975940 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -627,15 +627,33 @@ static void hisi_acc_vf_disable_fd(struct hisi_acc_vf_migration_file *migf)
 	mutex_unlock(&migf->lock);
 }
 
+static void hisi_acc_debug_migf_copy(struct hisi_acc_vf_core_device *hisi_acc_vdev,
+	struct hisi_acc_vf_migration_file *src_migf)
+{
+	struct hisi_acc_vf_migration_file *dst_migf = hisi_acc_vdev->debug_migf;
+
+	if (!dst_migf)
+		return;
+
+	mutex_lock(&hisi_acc_vdev->enable_mutex);
+	dst_migf->disabled = src_migf->disabled;
+	dst_migf->total_length = src_migf->total_length;
+	memcpy(&dst_migf->vf_data, &src_migf->vf_data,
+		sizeof(struct acc_vf_data));
+	mutex_unlock(&hisi_acc_vdev->enable_mutex);
+}
+
 static void hisi_acc_vf_disable_fds(struct hisi_acc_vf_core_device *hisi_acc_vdev)
 {
 	if (hisi_acc_vdev->resuming_migf) {
+		hisi_acc_debug_migf_copy(hisi_acc_vdev, hisi_acc_vdev->resuming_migf);
 		hisi_acc_vf_disable_fd(hisi_acc_vdev->resuming_migf);
 		fput(hisi_acc_vdev->resuming_migf->filp);
 		hisi_acc_vdev->resuming_migf = NULL;
 	}
 
 	if (hisi_acc_vdev->saving_migf) {
+		hisi_acc_debug_migf_copy(hisi_acc_vdev, hisi_acc_vdev->saving_migf);
 		hisi_acc_vf_disable_fd(hisi_acc_vdev->saving_migf);
 		fput(hisi_acc_vdev->saving_migf->filp);
 		hisi_acc_vdev->saving_migf = NULL;
@@ -1144,6 +1162,7 @@ static int hisi_acc_vf_qm_init(struct hisi_acc_vf_core_device *hisi_acc_vdev)
 	if (!vf_qm->io_base)
 		return -EIO;
 
+	mutex_init(&hisi_acc_vdev->enable_mutex);
 	vf_qm->fun_type = QM_HW_VF;
 	vf_qm->pdev = vf_dev;
 	mutex_init(&vf_qm->mailbox_lock);
@@ -1294,6 +1313,203 @@ static long hisi_acc_vfio_pci_ioctl(struct vfio_device *core_vdev, unsigned int
 	return vfio_pci_core_ioctl(core_vdev, cmd, arg);
 }
 
+static int hisi_acc_vf_debug_check(struct seq_file *seq, struct vfio_device *vdev)
+{
+	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(vdev);
+	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
+	struct device *dev = vdev->dev;
+	int ret;
+
+	if (!vdev->mig_ops) {
+		dev_err(dev, "device does not support live migration!\n");
+		return -EINVAL;
+	}
+
+	/**
+	 * When the device is not opened, the io_base is not mapped.
+	 * The driver cannot perform device read and write operations.
+	 */
+	if (!hisi_acc_vdev->dev_opened) {
+		dev_err(dev, "device not opened!\n");
+		return -EINVAL;
+	}
+
+	ret = qm_wait_dev_not_ready(vf_qm);
+	if (ret) {
+		dev_err(dev, "VF device not ready!\n");
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
+static int hisi_acc_vf_debug_cmd(struct seq_file *seq, void *data)
+{
+	struct device *vf_dev = seq->private;
+	struct vfio_pci_core_device *core_device = dev_get_drvdata(vf_dev);
+	struct vfio_device *vdev = &core_device->vdev;
+	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(vdev);
+	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
+	u64 value;
+	int ret;
+
+	mutex_lock(&hisi_acc_vdev->enable_mutex);
+	ret = hisi_acc_vf_debug_check(seq, vdev);
+	if (ret) {
+		mutex_unlock(&hisi_acc_vdev->enable_mutex);
+		return ret;
+	}
+
+	value = readl(vf_qm->io_base + QM_MB_CMD_SEND_BASE);
+	if (value == QM_MB_CMD_NOT_READY) {
+		mutex_unlock(&hisi_acc_vdev->enable_mutex);
+		dev_err(vf_dev, "mailbox cmd channel not ready!\n");
+		return -EINVAL;
+	}
+	mutex_unlock(&hisi_acc_vdev->enable_mutex);
+	dev_err(vf_dev, "mailbox cmd channel state is OK!\n");
+
+	return 0;
+}
+
+static int hisi_acc_vf_dev_read(struct seq_file *seq, void *data)
+{
+	struct device *vf_dev = seq->private;
+	struct vfio_pci_core_device *core_device = dev_get_drvdata(vf_dev);
+	struct vfio_device *vdev = &core_device->vdev;
+	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(vdev);
+	size_t vf_data_sz = offsetofend(struct acc_vf_data, padding);
+	struct hisi_acc_vf_migration_file *migf = NULL;
+	int ret;
+
+	migf = kzalloc(sizeof(struct hisi_acc_vf_migration_file), GFP_KERNEL);
+	if (!migf)
+		return -ENOMEM;
+
+	mutex_lock(&hisi_acc_vdev->enable_mutex);
+	ret = hisi_acc_vf_debug_check(seq, vdev);
+	if (ret) {
+		mutex_unlock(&hisi_acc_vdev->enable_mutex);
+		goto migf_err;
+	}
+
+	migf->vf_data.vf_qm_state = hisi_acc_vdev->vf_qm_state;
+	ret = vf_qm_read_data(&hisi_acc_vdev->vf_qm, &migf->vf_data);
+	if (ret) {
+		mutex_unlock(&hisi_acc_vdev->enable_mutex);
+		dev_err(vf_dev, "failed to read device data!\n");
+		goto migf_err;
+	}
+	mutex_unlock(&hisi_acc_vdev->enable_mutex);
+
+	if (hisi_acc_vdev->resuming_migf)
+		migf->disabled = hisi_acc_vdev->resuming_migf->disabled;
+	else if (hisi_acc_vdev->saving_migf)
+		migf->disabled = hisi_acc_vdev->saving_migf->disabled;
+	else
+		migf->disabled = true;
+	migf->total_length = sizeof(struct acc_vf_data);
+
+	seq_hex_dump(seq, "Dev Data:", DUMP_PREFIX_OFFSET, 16, 1,
+			(unsigned char *)&migf->vf_data,
+			vf_data_sz, false);
+
+	seq_printf(seq,
+		 "acc device:\n"
+		 "device  ready: %u\n"
+		 "device  opened: %d\n"
+		 "data    valid: %d\n"
+		 "data     size: %lu\n",
+		 hisi_acc_vdev->vf_qm_state,
+		 hisi_acc_vdev->dev_opened,
+		 migf->disabled,
+		 migf->total_length);
+
+migf_err:
+	kfree(migf);
+
+	return ret;
+}
+
+static int hisi_acc_vf_migf_read(struct seq_file *seq, void *data)
+{
+	struct device *vf_dev = seq->private;
+	struct vfio_pci_core_device *core_device = dev_get_drvdata(vf_dev);
+	struct vfio_device *vdev = &core_device->vdev;
+	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(vdev);
+	size_t vf_data_sz = offsetofend(struct acc_vf_data, padding);
+	struct hisi_acc_vf_migration_file *debug_migf = hisi_acc_vdev->debug_migf;
+
+	/* Check whether the live migration operation has been performed */
+	if (debug_migf->total_length < vf_data_sz) {
+		dev_err(vf_dev, "device not migrated!\n");
+		return -EAGAIN;
+	}
+
+	seq_hex_dump(seq, "Mig Data:", DUMP_PREFIX_OFFSET, 16, 1,
+			(unsigned char *)&debug_migf->vf_data,
+			vf_data_sz, false);
+
+	seq_printf(seq,
+		 "acc device:\n"
+		 "device  ready: %u\n"
+		 "device  opened: %d\n"
+		 "data    valid: %d\n"
+		 "data     size: %lu\n",
+		 hisi_acc_vdev->vf_qm_state,
+		 hisi_acc_vdev->dev_opened,
+		 debug_migf->disabled,
+		 debug_migf->total_length);
+
+	return 0;
+}
+
+static int hisi_acc_vfio_debug_init(struct hisi_acc_vf_core_device *hisi_acc_vdev)
+{
+	struct vfio_device *vdev = &hisi_acc_vdev->core_device.vdev;
+	struct dentry *vfio_dev_migration = NULL;
+	struct dentry *vfio_hisi_acc = NULL;
+	struct device *dev = vdev->dev;
+	void *migf = NULL;
+
+	if (!debugfs_initialized() ||
+	    !IS_ENABLED(CONFIG_VFIO_DEBUGFS))
+		return 0;
+
+	migf = kzalloc(sizeof(struct hisi_acc_vf_migration_file), GFP_KERNEL);
+	if (!migf)
+		return -ENOMEM;
+	hisi_acc_vdev->debug_migf = migf;
+
+	vfio_dev_migration = debugfs_lookup("migration", vdev->debug_root);
+	if (!vfio_dev_migration) {
+		kfree(migf);
+		hisi_acc_vdev->debug_migf = NULL;
+		dev_err(dev, "failed to lookup migration debugfs file!\n");
+		return -ENODEV;
+	}
+
+	vfio_hisi_acc = debugfs_create_dir("hisi_acc", vfio_dev_migration);
+	debugfs_create_devm_seqfile(dev, "dev_data", vfio_hisi_acc,
+				  hisi_acc_vf_dev_read);
+	debugfs_create_devm_seqfile(dev, "migf_data", vfio_hisi_acc,
+				  hisi_acc_vf_migf_read);
+	debugfs_create_devm_seqfile(dev, "cmd_state", vfio_hisi_acc,
+				  hisi_acc_vf_debug_cmd);
+
+	return 0;
+}
+
+static void hisi_acc_vf_debugfs_exit(struct hisi_acc_vf_core_device *hisi_acc_vdev)
+{
+	if (!debugfs_initialized() ||
+	    !IS_ENABLED(CONFIG_VFIO_DEBUGFS))
+		return;
+
+	if (hisi_acc_vdev->debug_migf)
+		kfree(hisi_acc_vdev->debug_migf);
+}
+
 static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
 {
 	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(core_vdev);
@@ -1311,9 +1527,11 @@ static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
 			return ret;
 		}
 		hisi_acc_vdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
+		hisi_acc_vdev->dev_opened = true;
 	}
 
 	vfio_pci_core_finish_enable(vdev);
+
 	return 0;
 }
 
@@ -1322,7 +1540,10 @@ static void hisi_acc_vfio_pci_close_device(struct vfio_device *core_vdev)
 	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(core_vdev);
 	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
 
+	hisi_acc_vdev->dev_opened = false;
+	mutex_lock(&hisi_acc_vdev->enable_mutex);
 	iounmap(vf_qm->io_base);
+	mutex_unlock(&hisi_acc_vdev->enable_mutex);
 	vfio_pci_core_close_device(core_vdev);
 }
 
@@ -1413,6 +1634,9 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device
 	ret = vfio_pci_core_register_device(&hisi_acc_vdev->core_device);
 	if (ret)
 		goto out_put_vdev;
+
+	if (ops == &hisi_acc_vfio_pci_migrn_ops)
+		hisi_acc_vfio_debug_init(hisi_acc_vdev);
 	return 0;
 
 out_put_vdev:
@@ -1425,6 +1649,7 @@ static void hisi_acc_vfio_pci_remove(struct pci_dev *pdev)
 	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_drvdata(pdev);
 
 	vfio_pci_core_unregister_device(&hisi_acc_vdev->core_device);
+	hisi_acc_vf_debugfs_exit(hisi_acc_vdev);
 	vfio_put_device(&hisi_acc_vdev->core_device.vdev);
 }
 
diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
index f887ab98581c..93ee8bef32a1 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
@@ -32,6 +32,7 @@
 #define QM_SQC_VFT_BASE_MASK_V2		GENMASK(15, 0)
 #define QM_SQC_VFT_NUM_SHIFT_V2		45
 #define QM_SQC_VFT_NUM_MASK_V2		GENMASK(9, 0)
+#define QM_MB_CMD_NOT_READY	0xffffffff
 
 /* RW regs */
 #define QM_REGS_MAX_LEN		7
@@ -114,5 +115,11 @@ struct hisi_acc_vf_core_device {
 	int vf_id;
 	struct hisi_acc_vf_migration_file *resuming_migf;
 	struct hisi_acc_vf_migration_file *saving_migf;
+
+	/* To make sure the device is enabled */
+	struct mutex enable_mutex;
+	bool dev_opened;
+	/* To save migration data */
+	struct hisi_acc_vf_migration_file *debug_migf;
 };
 #endif /* HISI_ACC_VFIO_PCI_H */
-- 
2.24.0


