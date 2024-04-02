Return-Path: <kvm+bounces-13324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 17A18894A00
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 05:31:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C222C28744E
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 03:31:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E546C171C9;
	Tue,  2 Apr 2024 03:30:55 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10362168B1;
	Tue,  2 Apr 2024 03:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712028655; cv=none; b=EHVw/vpBM6w+sTh+RFFEeiNwSghEZIppYUNMPCMhWaXetJDbj4w4EjmJDKk1/wb5Mhi5sTNIxNU3aGCbuYG2SwgmlZmTqNKgDOtu73U7ZYTy4vnMQSglU08ockrTosQ0Cot0Lys6tTfKZgnoMjH8SfZ86lxf8R7qJdN2G3sBdZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712028655; c=relaxed/simple;
	bh=u5QTTpaYG0K1k3QmSdagR9F2OdZcR7rkpj/PsxhimlU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jSS4HAaO5Il4sS7ouDGVSFbfsz6HWOcstogpfd7tlGrtCAG5GPwhV/NlAprtDnCZwmtqTRp0VAKN3pSwJhf/Sh9rjurTRYiJP3f/3YwlXSbXKphpmZCahShBQYnsjf2bh67MeEhDGvZykrjilN8yx4c7xtPI0AKZvsrvF9m02DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4V7tck1Dn6z1R9bF;
	Tue,  2 Apr 2024 11:28:06 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (unknown [7.193.23.191])
	by mail.maildlp.com (Postfix) with ESMTPS id 14E59140155;
	Tue,  2 Apr 2024 11:30:51 +0800 (CST)
Received: from huawei.com (10.50.165.33) by kwepemm600005.china.huawei.com
 (7.193.23.191) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Tue, 2 Apr
 2024 11:30:50 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v4 3/4] hisi_acc_vfio_pci: register debugfs for hisilicon migration driver
Date: Tue, 2 Apr 2024 11:24:31 +0800
Message-ID: <20240402032432.41004-4-liulongfang@huawei.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20240402032432.41004-1-liulongfang@huawei.com>
References: <20240402032432.41004-1-liulongfang@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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
    |            +--attr
    |            +--data
    |            +--save
    |            +--cmd_state
    |
    +---<dev_name2>
         +---migration
             +--state
             +--hisi_acc
                 +--attr
                 +--data
                 +--save
                 +--cmd_state

data file: used to get the migration data from the driver
attr file: used to get device attributes parameters from the driver
save file: used to read the data of the live migration device and save
it to the driver.
cmd_state: used to get the cmd channel state for the device.

+----------------+        +--------------+       +---------------+
| migration dev  |        |   src  dev   |       |   dst  dev    |
+-------+--------+        +------+-------+       +-------+-------+
        |                        |                       |
        |                        |                       |
        |                        |                       |
        |                        |                       |
  save  |                 +------v-------+       +-------v-------+
        |                 |  saving_mif  |       | resuming_migf |
        |                 |     file     |       |     file      |
        |                 +------+-------+       +-------+-------+
        |                        |                       |
        |        mutex           |                       |
+-------v--------+               |                       |
|                |               |                       |
| debug_migf file<---------------+-----------------------+
|                |             copy
+-------+--------+
        |
   cat  |
        |
+-------v--------+
|     user       |
+----------------+

In debugfs scheme. The driver creates a separate debug_migf file.
It is completely separated from the two files of live migration,
thus preventing debugfs data from interfering with migration data.
Moreover, it only performs read operations on the device.

For serialization of debugfs:
First, it only writes data when performing a debugfs save operation.
Second, it is only copied from the file on the migration device
when the live migration is complete.
These two operations are mutually exclusive through mutex.

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
---
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 204 ++++++++++++++++++
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  11 +
 2 files changed, 215 insertions(+)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index bf358ba94b5d..9f563a31a2a1 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -15,6 +15,7 @@
 #include <linux/anon_inodes.h>
 
 #include "hisi_acc_vfio_pci.h"
+#include "../../vfio.h"
 
 /* Return 0 on VM acc device ready, -ETIMEDOUT hardware timeout */
 static int qm_wait_dev_not_ready(struct hisi_qm *qm)
@@ -618,6 +619,22 @@ hisi_acc_check_int_state(struct hisi_acc_vf_core_device *hisi_acc_vdev)
 	}
 }
 
+static void hisi_acc_vf_migf_save(struct hisi_acc_vf_core_device *hisi_acc_vdev,
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
+		    sizeof(struct acc_vf_data));
+	mutex_unlock(&hisi_acc_vdev->enable_mutex);
+}
+
 static void hisi_acc_vf_disable_fd(struct hisi_acc_vf_migration_file *migf)
 {
 	mutex_lock(&migf->lock);
@@ -630,12 +647,14 @@ static void hisi_acc_vf_disable_fd(struct hisi_acc_vf_migration_file *migf)
 static void hisi_acc_vf_disable_fds(struct hisi_acc_vf_core_device *hisi_acc_vdev)
 {
 	if (hisi_acc_vdev->resuming_migf) {
+		hisi_acc_vf_migf_save(hisi_acc_vdev, hisi_acc_vdev->resuming_migf);
 		hisi_acc_vf_disable_fd(hisi_acc_vdev->resuming_migf);
 		fput(hisi_acc_vdev->resuming_migf->filp);
 		hisi_acc_vdev->resuming_migf = NULL;
 	}
 
 	if (hisi_acc_vdev->saving_migf) {
+		hisi_acc_vf_migf_save(hisi_acc_vdev, hisi_acc_vdev->saving_migf);
 		hisi_acc_vf_disable_fd(hisi_acc_vdev->saving_migf);
 		fput(hisi_acc_vdev->saving_migf->filp);
 		hisi_acc_vdev->saving_migf = NULL;
@@ -1144,6 +1163,7 @@ static int hisi_acc_vf_qm_init(struct hisi_acc_vf_core_device *hisi_acc_vdev)
 	if (!vf_qm->io_base)
 		return -EIO;
 
+	mutex_init(&hisi_acc_vdev->enable_mutex);
 	vf_qm->fun_type = QM_HW_VF;
 	vf_qm->pdev = vf_dev;
 	mutex_init(&vf_qm->mailbox_lock);
@@ -1294,6 +1314,181 @@ static long hisi_acc_vfio_pci_ioctl(struct vfio_device *core_vdev, unsigned int
 	return vfio_pci_core_ioctl(core_vdev, cmd, arg);
 }
 
+static int hisi_acc_vf_debug_check(struct seq_file *seq, struct vfio_device *vdev)
+{
+	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(vdev);
+	struct hisi_acc_vf_migration_file *migf = hisi_acc_vdev->debug_migf;
+	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
+	int ret;
+
+	if (!vdev->mig_ops || !migf) {
+		seq_printf(seq, "%s\n", "device does not support live migration!");
+		return -EINVAL;
+	}
+
+	/**
+	 * When the device is not opened, the io_base is not mapped.
+	 * The driver cannot perform device read and write operations.
+	 */
+	if (hisi_acc_vdev->dev_opened != DEV_OPEN) {
+		seq_printf(seq, "%s\n", "device not opened!");
+		return -EINVAL;
+	}
+
+	ret = qm_wait_dev_not_ready(vf_qm);
+	if (ret) {
+		seq_printf(seq, "%s\n", "VF device not ready!");
+		return -EINVAL;
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
+		return 0;
+	}
+
+	value = readl(vf_qm->io_base + QM_MB_CMD_SEND_BASE);
+	mutex_unlock(&hisi_acc_vdev->enable_mutex);
+	seq_printf(seq, "%s:0x%llx\n", "mailbox cmd channel state is OK", value);
+
+	return 0;
+}
+
+static int hisi_acc_vf_debug_save(struct seq_file *seq, void *data)
+{
+	struct device *vf_dev = seq->private;
+	struct vfio_pci_core_device *core_device = dev_get_drvdata(vf_dev);
+	struct vfio_device *vdev = &core_device->vdev;
+	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(vdev);
+	struct hisi_acc_vf_migration_file *migf = hisi_acc_vdev->debug_migf;
+	struct acc_vf_data *vf_data = &migf->vf_data;
+	int ret;
+
+	mutex_lock(&hisi_acc_vdev->enable_mutex);
+	ret = hisi_acc_vf_debug_check(seq, vdev);
+	if (ret) {
+		mutex_unlock(&hisi_acc_vdev->enable_mutex);
+		return 0;
+	}
+
+	vf_data->vf_qm_state = QM_READY;
+	ret = vf_qm_read_data(&hisi_acc_vdev->vf_qm, vf_data);
+	if (ret) {
+		mutex_unlock(&hisi_acc_vdev->enable_mutex);
+		seq_printf(seq, "%s\n", "failed to save device data!");
+		return 0;
+	}
+
+	migf->total_length = sizeof(struct acc_vf_data);
+	mutex_unlock(&hisi_acc_vdev->enable_mutex);
+	seq_printf(seq, "%s\n", "successful to save device data!");
+
+	return 0;
+}
+
+static int hisi_acc_vf_data_read(struct seq_file *seq, void *data)
+{
+	struct device *vf_dev = seq->private;
+	struct vfio_pci_core_device *core_device = dev_get_drvdata(vf_dev);
+	struct vfio_device *vdev = &core_device->vdev;
+	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(vdev);
+	struct hisi_acc_vf_migration_file *debug_migf = hisi_acc_vdev->debug_migf;
+	size_t vf_data_sz = offsetofend(struct acc_vf_data, padding);
+
+	if (debug_migf && debug_migf->total_length)
+		seq_hex_dump(seq, "Mig Data:", DUMP_PREFIX_OFFSET, 16, 1,
+				(unsigned char *)&debug_migf->vf_data,
+				vf_data_sz, false);
+	else
+		seq_printf(seq, "%s\n", "device not migrated!");
+
+	return 0;
+}
+
+static int hisi_acc_vf_attr_read(struct seq_file *seq, void *data)
+{
+	struct device *vf_dev = seq->private;
+	struct vfio_pci_core_device *core_device = dev_get_drvdata(vf_dev);
+	struct vfio_device *vdev = &core_device->vdev;
+	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(vdev);
+	struct hisi_acc_vf_migration_file *debug_migf = hisi_acc_vdev->debug_migf;
+
+	if (debug_migf && debug_migf->total_length) {
+		seq_printf(seq,
+			 "acc device:\n"
+			 "device  state: %d\n"
+			 "device  ready: %u\n"
+			 "data    valid: %d\n"
+			 "data     size: %lu\n",
+			 hisi_acc_vdev->mig_state,
+			 hisi_acc_vdev->vf_qm_state,
+			 debug_migf->disabled,
+			 debug_migf->total_length);
+	} else {
+		seq_printf(seq, "%s\n", "device not migrated!");
+	}
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
+	if (!debugfs_initialized())
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
+		dev_err(dev, "failed to lookup migration debugfs file!\n");
+		return -ENODEV;
+	}
+
+	vfio_hisi_acc = debugfs_create_dir("hisi_acc", vfio_dev_migration);
+	debugfs_create_devm_seqfile(dev, "data", vfio_hisi_acc,
+				  hisi_acc_vf_data_read);
+	debugfs_create_devm_seqfile(dev, "attr", vfio_hisi_acc,
+				  hisi_acc_vf_attr_read);
+	debugfs_create_devm_seqfile(dev, "cmd_state", vfio_hisi_acc,
+				  hisi_acc_vf_debug_cmd);
+	debugfs_create_devm_seqfile(dev, "save", vfio_hisi_acc,
+				  hisi_acc_vf_debug_save);
+
+	return 0;
+}
+
+static void hisi_acc_vf_debugfs_exit(struct hisi_acc_vf_core_device *hisi_acc_vdev)
+{
+	if (!debugfs_initialized())
+		return;
+
+	kfree(hisi_acc_vdev->debug_migf);
+}
+
 static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
 {
 	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(core_vdev);
@@ -1311,9 +1506,11 @@ static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
 			return ret;
 		}
 		hisi_acc_vdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
+		hisi_acc_vdev->dev_opened = DEV_OPEN;
 	}
 
 	vfio_pci_core_finish_enable(vdev);
+
 	return 0;
 }
 
@@ -1322,7 +1519,10 @@ static void hisi_acc_vfio_pci_close_device(struct vfio_device *core_vdev)
 	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(core_vdev);
 	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
 
+	hisi_acc_vdev->dev_opened = DEV_CLOSE;
+	mutex_lock(&hisi_acc_vdev->enable_mutex);
 	iounmap(vf_qm->io_base);
+	mutex_unlock(&hisi_acc_vdev->enable_mutex);
 	vfio_pci_core_close_device(core_vdev);
 }
 
@@ -1413,6 +1613,9 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device
 	ret = vfio_pci_core_register_device(&hisi_acc_vdev->core_device);
 	if (ret)
 		goto out_put_vdev;
+
+	if (ops == &hisi_acc_vfio_pci_migrn_ops)
+		hisi_acc_vfio_debug_init(hisi_acc_vdev);
 	return 0;
 
 out_put_vdev:
@@ -1425,6 +1628,7 @@ static void hisi_acc_vfio_pci_remove(struct pci_dev *pdev)
 	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_drvdata(pdev);
 
 	vfio_pci_core_unregister_device(&hisi_acc_vdev->core_device);
+	hisi_acc_vf_debugfs_exit(hisi_acc_vdev);
 	vfio_put_device(&hisi_acc_vdev->core_device.vdev);
 }
 
diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
index 7a9dc87627cd..3a20d81d105c 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
@@ -52,6 +52,11 @@
 #define QM_EQC_DW0		0X8000
 #define QM_AEQC_DW0		0X8020
 
+enum acc_dev_state {
+	DEV_CLOSE = 0x0,
+	DEV_OPEN,
+};
+
 struct acc_vf_data {
 #define QM_MATCH_SIZE offsetofend(struct acc_vf_data, qm_rsv_state)
 	/* QM match information */
@@ -114,5 +119,11 @@ struct hisi_acc_vf_core_device {
 	int vf_id;
 	struct hisi_acc_vf_migration_file *resuming_migf;
 	struct hisi_acc_vf_migration_file *saving_migf;
+
+	/* To make sure the device is enabled */
+	struct mutex enable_mutex;
+	bool dev_opened;
+	/* For debugfs */
+	struct hisi_acc_vf_migration_file *debug_migf;
 };
 #endif /* HISI_ACC_VFIO_PCI_H */
-- 
2.24.0


