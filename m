Return-Path: <kvm+bounces-28966-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D27BD99FE36
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 03:25:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 530B31F217F0
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 01:25:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70F7F1339A4;
	Wed, 16 Oct 2024 01:25:10 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1E128EA;
	Wed, 16 Oct 2024 01:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729041910; cv=none; b=YVVDv+kV+gw8wMphb2Vq6P/6USrYYHqZxq9mdNq35QLoxkFA8mu0I65vWPBi0Ct5/omnXBIznI2eI8Z9o+mRI1MbSYAGlM4GU12XtupM3IQJlPve5r9QXVF/WMmUmOH3Rw+PZWGkwYa0x4bOBHzdpusnjmqNDVOhxZrAStRaxyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729041910; c=relaxed/simple;
	bh=MxOg9ryxztX9iBKG32clD283r0qniipTDc3JLshiqGs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q72rCpg3DOsoBVzuly6g+krCy6t3I1sdCJ6Hk0UD72mY9wLIFQaUCUN5nE5d6wbuB6Qnx2BiFO8pXHAylhD3gNf6tHZARRsiBLhtuAp3Fkp37jXJZmNBnfeUJ6nz6ZNDlBU4A/Z1gsCXqOxTxNFhmIj8hB0Ja0ltxBDiGgbXlWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4XStXv2654z20qRh;
	Wed, 16 Oct 2024 09:24:15 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (unknown [7.193.23.191])
	by mail.maildlp.com (Postfix) with ESMTPS id 03DDB180042;
	Wed, 16 Oct 2024 09:24:59 +0800 (CST)
Received: from huawei.com (10.50.165.33) by kwepemm600005.china.huawei.com
 (7.193.23.191) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 16 Oct
 2024 09:24:58 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v10 3/4] hisi_acc_vfio_pci: register debugfs for hisilicon migration driver
Date: Wed, 16 Oct 2024 09:23:07 +0800
Message-ID: <20241016012308.14108-4-liulongfang@huawei.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20241016012308.14108-1-liulongfang@huawei.com>
References: <20241016012308.14108-1-liulongfang@huawei.com>
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
        |                 |  saving_migf |       | resuming_migf |
  read  |                 |     file     |       |     file      |
        |                 +------+-------+       +-------+-------+
        |                        |          copy         |
        |                        +------------+----------+
        |                                     |
+-------v--------+                    +-------v--------+
|   data buffer  |                    |   debug_migf   |
+-------+--------+                    +-------+--------+
        |                                     |
   cat  |                                 cat |
+-------v--------+                    +-------v--------+
|   dev_data     |                    |   migf_data    |
+----------------+                    +----------------+

When accessing debugfs, user can obtain the most recent status data
of the device through the "dev_data" file. It can read recent
complete status data of the device. If the current device is being
migrated, it will wait for it to complete.
The data for the last completed migration function will be stored
in debug_migf. Users can read it via "migf_data".

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
---
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 203 ++++++++++++++++++
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |   7 +
 2 files changed, 210 insertions(+)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index a8c53952d82e..747bcc503d16 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -627,15 +627,30 @@ static void hisi_acc_vf_disable_fd(struct hisi_acc_vf_migration_file *migf)
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
+	dst_migf->total_length = src_migf->total_length;
+	memcpy(&dst_migf->vf_data, &src_migf->vf_data,
+		sizeof(struct acc_vf_data));
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
@@ -1294,6 +1309,180 @@ static long hisi_acc_vfio_pci_ioctl(struct vfio_device *core_vdev, unsigned int
 	return vfio_pci_core_ioctl(core_vdev, cmd, arg);
 }
 
+static int hisi_acc_vf_debug_check(struct seq_file *seq, struct vfio_device *vdev)
+{
+	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(vdev);
+	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
+	int ret;
+
+	lockdep_assert_held(&hisi_acc_vdev->open_mutex);
+	/*
+	 * When the device is not opened, the io_base is not mapped.
+	 * The driver cannot perform device read and write operations.
+	 */
+	if (!hisi_acc_vdev->dev_opened) {
+		seq_printf(seq, "device not opened!\n");
+		return -EINVAL;
+	}
+
+	ret = qm_wait_dev_not_ready(vf_qm);
+	if (ret) {
+		seq_printf(seq, "VF device not ready!\n");
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
+	mutex_lock(&hisi_acc_vdev->open_mutex);
+	ret = hisi_acc_vf_debug_check(seq, vdev);
+	if (ret) {
+		mutex_unlock(&hisi_acc_vdev->open_mutex);
+		return ret;
+	}
+
+	value = readl(vf_qm->io_base + QM_MB_CMD_SEND_BASE);
+	if (value == QM_MB_CMD_NOT_READY) {
+		mutex_unlock(&hisi_acc_vdev->open_mutex);
+		seq_printf(seq, "mailbox cmd channel not ready!\n");
+		return -EINVAL;
+	}
+	mutex_unlock(&hisi_acc_vdev->open_mutex);
+	seq_printf(seq, "mailbox cmd channel ready!\n");
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
+	struct acc_vf_data *vf_data = NULL;
+	int ret;
+
+	mutex_lock(&hisi_acc_vdev->open_mutex);
+	ret = hisi_acc_vf_debug_check(seq, vdev);
+	if (ret) {
+		mutex_unlock(&hisi_acc_vdev->open_mutex);
+		return ret;
+	}
+
+	mutex_lock(&hisi_acc_vdev->state_mutex);
+	vf_data = kzalloc(sizeof(struct acc_vf_data), GFP_KERNEL);
+	if (!vf_data) {
+		ret = -ENOMEM;
+		goto mutex_release;
+	}
+
+	vf_data->vf_qm_state = hisi_acc_vdev->vf_qm_state;
+	ret = vf_qm_read_data(&hisi_acc_vdev->vf_qm, vf_data);
+	if (ret)
+		goto migf_err;
+
+	seq_hex_dump(seq, "Dev Data:", DUMP_PREFIX_OFFSET, 16, 1,
+			(unsigned char *)vf_data,
+			vf_data_sz, false);
+
+	seq_printf(seq,
+		 "acc device:\n"
+		 "guest driver load: %u\n"
+		 "data size: %lu\n",
+		 hisi_acc_vdev->vf_qm_state,
+		 sizeof(struct acc_vf_data));
+
+migf_err:
+	kfree(vf_data);
+mutex_release:
+	mutex_unlock(&hisi_acc_vdev->open_mutex);
+	mutex_unlock(&hisi_acc_vdev->state_mutex);
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
+	if (debug_migf->total_length < QM_MATCH_SIZE) {
+		seq_printf(seq, "device not migrated!\n");
+		return -EAGAIN;
+	}
+
+	seq_hex_dump(seq, "Mig Data:", DUMP_PREFIX_OFFSET, 16, 1,
+			(unsigned char *)&debug_migf->vf_data,
+			vf_data_sz, false);
+
+	seq_printf(seq,
+		 "acc device:\n"
+		 "guest driver load: %u\n"
+		 "device opened: %d\n"
+		 "migrate data length: %lu\n",
+		 hisi_acc_vdev->vf_qm_state,
+		 hisi_acc_vdev->dev_opened,
+		 debug_migf->total_length);
+
+	return 0;
+}
+
+static void hisi_acc_vfio_debug_init(struct hisi_acc_vf_core_device *hisi_acc_vdev)
+{
+	struct vfio_device *vdev = &hisi_acc_vdev->core_device.vdev;
+	struct dentry *vfio_dev_migration = NULL;
+	struct dentry *vfio_hisi_acc = NULL;
+	struct device *dev = vdev->dev;
+	void *migf = NULL;
+
+	if (!debugfs_initialized() ||
+	    !IS_ENABLED(CONFIG_VFIO_DEBUGFS))
+		return;
+
+	vfio_dev_migration = debugfs_lookup("migration", vdev->debug_root);
+	if (!vfio_dev_migration) {
+		dev_err(dev, "failed to lookup migration debugfs file!\n");
+		return;
+	}
+
+	migf = kzalloc(sizeof(struct hisi_acc_vf_migration_file), GFP_KERNEL);
+	if (!migf)
+		return;
+	hisi_acc_vdev->debug_migf = migf;
+
+	vfio_hisi_acc = debugfs_create_dir("hisi_acc", vfio_dev_migration);
+	debugfs_create_devm_seqfile(dev, "dev_data", vfio_hisi_acc,
+				  hisi_acc_vf_dev_read);
+	debugfs_create_devm_seqfile(dev, "migf_data", vfio_hisi_acc,
+				  hisi_acc_vf_migf_read);
+	debugfs_create_devm_seqfile(dev, "cmd_state", vfio_hisi_acc,
+				  hisi_acc_vf_debug_cmd);
+}
+
+static void hisi_acc_vf_debugfs_exit(struct hisi_acc_vf_core_device *hisi_acc_vdev)
+{
+	if (hisi_acc_vdev->debug_migf) {
+		kfree(hisi_acc_vdev->debug_migf);
+		hisi_acc_vdev->debug_migf = NULL;
+	}
+}
+
 static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
 {
 	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(core_vdev);
@@ -1305,12 +1494,16 @@ static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
 		return ret;
 
 	if (core_vdev->mig_ops) {
+		mutex_lock(&hisi_acc_vdev->open_mutex);
 		ret = hisi_acc_vf_qm_init(hisi_acc_vdev);
 		if (ret) {
+			mutex_unlock(&hisi_acc_vdev->open_mutex);
 			vfio_pci_core_disable(vdev);
 			return ret;
 		}
 		hisi_acc_vdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
+		hisi_acc_vdev->dev_opened = true;
+		mutex_unlock(&hisi_acc_vdev->open_mutex);
 	}
 
 	vfio_pci_core_finish_enable(vdev);
@@ -1322,7 +1515,10 @@ static void hisi_acc_vfio_pci_close_device(struct vfio_device *core_vdev)
 	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(core_vdev);
 	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
 
+	mutex_lock(&hisi_acc_vdev->open_mutex);
+	hisi_acc_vdev->dev_opened = false;
 	iounmap(vf_qm->io_base);
+	mutex_unlock(&hisi_acc_vdev->open_mutex);
 	vfio_pci_core_close_device(core_vdev);
 }
 
@@ -1342,6 +1538,7 @@ static int hisi_acc_vfio_pci_migrn_init_dev(struct vfio_device *core_vdev)
 	hisi_acc_vdev->pf_qm = pf_qm;
 	hisi_acc_vdev->vf_dev = pdev;
 	mutex_init(&hisi_acc_vdev->state_mutex);
+	mutex_init(&hisi_acc_vdev->open_mutex);
 
 	core_vdev->migration_flags = VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_PRE_COPY;
 	core_vdev->mig_ops = &hisi_acc_vfio_pci_migrn_state_ops;
@@ -1413,6 +1610,9 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device
 	ret = vfio_pci_core_register_device(&hisi_acc_vdev->core_device);
 	if (ret)
 		goto out_put_vdev;
+
+	if (ops == &hisi_acc_vfio_pci_migrn_ops)
+		hisi_acc_vfio_debug_init(hisi_acc_vdev);
 	return 0;
 
 out_put_vdev:
@@ -1423,8 +1623,11 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device
 static void hisi_acc_vfio_pci_remove(struct pci_dev *pdev)
 {
 	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_drvdata(pdev);
+	struct vfio_device *vdev = &hisi_acc_vdev->core_device.vdev;
 
 	vfio_pci_core_unregister_device(&hisi_acc_vdev->core_device);
+	if (vdev->ops == &hisi_acc_vfio_pci_migrn_ops)
+		hisi_acc_vf_debugfs_exit(hisi_acc_vdev);
 	vfio_put_device(&hisi_acc_vdev->core_device.vdev);
 }
 
diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
index 5bab46602fad..2a78ffd060c3 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
@@ -32,6 +32,7 @@
 #define QM_SQC_VFT_BASE_MASK_V2		GENMASK(15, 0)
 #define QM_SQC_VFT_NUM_SHIFT_V2		45
 #define QM_SQC_VFT_NUM_MASK_V2		GENMASK(9, 0)
+#define QM_MB_CMD_NOT_READY	0xffffffff
 
 /* RW regs */
 #define QM_REGS_MAX_LEN		7
@@ -99,6 +100,8 @@ struct hisi_acc_vf_migration_file {
 struct hisi_acc_vf_core_device {
 	struct vfio_pci_core_device core_device;
 	u8 match_done;
+	/* To make sure the device is opened */
+	bool dev_opened;
 
 	/* For migration state */
 	struct mutex state_mutex;
@@ -111,5 +114,9 @@ struct hisi_acc_vf_core_device {
 	int vf_id;
 	struct hisi_acc_vf_migration_file *resuming_migf;
 	struct hisi_acc_vf_migration_file *saving_migf;
+
+	/* To save migration data */
+	struct hisi_acc_vf_migration_file *debug_migf;
+	struct mutex open_mutex;
 };
 #endif /* HISI_ACC_VFIO_PCI_H */
-- 
2.24.0


