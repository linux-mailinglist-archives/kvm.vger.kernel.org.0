Return-Path: <kvm+bounces-6985-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AAB5383BB87
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 09:15:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5AA5828F972
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 08:15:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 521AD175A5;
	Thu, 25 Jan 2024 08:15:39 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7964217582;
	Thu, 25 Jan 2024 08:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706170538; cv=none; b=NrnGAGklOwq46whU4RB4LDIyXsjcAJJMj2AG0rg9BcfOEriarfo8gHYphCvmNqCzpy1xpg4IDv76Fl0+pzl0mu5Rxps9OIA6REKGSkrtEOoyPFKM0O0T4x9dMGI1vSyPkSUYFcaiRt2z33dKO95e7KOR7ynCvFkDQCs1yQuzxds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706170538; c=relaxed/simple;
	bh=2Mnmsrws7j2bALjmtLm5phwAYplPSp9pNlf8diFcayY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tZ/oxWeheYltgX9nAx5CzpQ428nRChtrv+s/YofbBNFSbU7ya8YiTSM4WqQXinUlJYSs9us0LrPsawZN29C42ZWotxSqQ6hyfUKOeowzrxmeWZbfYuz+7/9EAIjEqyV+k/N7zcNOL900RVok//5PgtHrAdmBd2WBUIbLjQaACnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4TLD6l45c7z1FJrP;
	Thu, 25 Jan 2024 16:11:11 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (unknown [7.193.23.191])
	by mail.maildlp.com (Postfix) with ESMTPS id 13A021A0172;
	Thu, 25 Jan 2024 16:15:34 +0800 (CST)
Received: from huawei.com (10.50.165.33) by kwepemm600005.china.huawei.com
 (7.193.23.191) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 25 Jan
 2024 16:15:33 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH 2/3] hisi_acc_vfio_pci: register debugfs for hisilicon migration driver
Date: Thu, 25 Jan 2024 16:10:30 +0800
Message-ID: <20240125081031.48707-3-liulongfang@huawei.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20240125081031.48707-1-liulongfang@huawei.com>
References: <20240125081031.48707-1-liulongfang@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
---
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 190 ++++++++++++++++++
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |   5 +
 2 files changed, 195 insertions(+)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index 5f6e01571a7b..2cbbc52b7377 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -15,6 +15,7 @@
 #include <linux/anon_inodes.h>
 
 #include "hisi_acc_vfio_pci.h"
+#include "../../vfio.h"
 
 /* Return 0 on VM acc device ready, -ETIMEDOUT hardware timeout */
 static int qm_wait_dev_not_ready(struct hisi_qm *qm)
@@ -617,6 +618,18 @@ hisi_acc_check_int_state(struct hisi_acc_vf_core_device *hisi_acc_vdev)
 	}
 }
 
+static void hisi_acc_vf_migf_save(struct hisi_acc_vf_migration_file *dst_migf,
+	struct hisi_acc_vf_migration_file *src_migf)
+{
+	if (!dst_migf)
+		return;
+
+	dst_migf->disabled = false;
+	dst_migf->total_length = src_migf->total_length;
+	memcpy(&dst_migf->vf_data, &src_migf->vf_data,
+		    sizeof(struct acc_vf_data));
+}
+
 static void hisi_acc_vf_disable_fd(struct hisi_acc_vf_migration_file *migf)
 {
 	mutex_lock(&migf->lock);
@@ -629,12 +642,16 @@ static void hisi_acc_vf_disable_fd(struct hisi_acc_vf_migration_file *migf)
 static void hisi_acc_vf_disable_fds(struct hisi_acc_vf_core_device *hisi_acc_vdev)
 {
 	if (hisi_acc_vdev->resuming_migf) {
+		hisi_acc_vf_migf_save(hisi_acc_vdev->debug_migf,
+						hisi_acc_vdev->resuming_migf);
 		hisi_acc_vf_disable_fd(hisi_acc_vdev->resuming_migf);
 		fput(hisi_acc_vdev->resuming_migf->filp);
 		hisi_acc_vdev->resuming_migf = NULL;
 	}
 
 	if (hisi_acc_vdev->saving_migf) {
+		hisi_acc_vf_migf_save(hisi_acc_vdev->debug_migf,
+						hisi_acc_vdev->saving_migf);
 		hisi_acc_vf_disable_fd(hisi_acc_vdev->saving_migf);
 		fput(hisi_acc_vdev->saving_migf->filp);
 		hisi_acc_vdev->saving_migf = NULL;
@@ -1175,6 +1192,7 @@ static int hisi_acc_vf_qm_init(struct hisi_acc_vf_core_device *hisi_acc_vdev)
 	if (!vf_qm->io_base)
 		return -EIO;
 
+	mutex_init(&hisi_acc_vdev->enable_mutex);
 	vf_qm->fun_type = QM_HW_VF;
 	vf_qm->pdev = vf_dev;
 	mutex_init(&vf_qm->mailbox_lock);
@@ -1325,6 +1343,172 @@ static long hisi_acc_vfio_pci_ioctl(struct vfio_device *core_vdev, unsigned int
 	return vfio_pci_core_ioctl(core_vdev, cmd, arg);
 }
 
+static int hisi_acc_vf_debug_check(struct seq_file *seq, struct vfio_device *vdev)
+{
+	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(vdev);
+	struct hisi_acc_vf_migration_file *migf = hisi_acc_vdev->debug_migf;
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
+	if (!vdev->open_count) {
+		seq_printf(seq, "%s\n", "device not opened!");
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
+	ret = hisi_acc_vf_debug_check(seq, vdev);
+	if (ret)
+		return 0;
+
+	mutex_lock(&hisi_acc_vdev->enable_mutex);
+	ret = qm_wait_dev_not_ready(vf_qm);
+	if (ret) {
+		mutex_unlock(&hisi_acc_vdev->enable_mutex);
+		seq_printf(seq, "%s\n", "VF device not ready!");
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
+	int ret;
+
+	ret = hisi_acc_vf_debug_check(seq, vdev);
+	if (ret)
+		return 0;
+
+	mutex_lock(&hisi_acc_vdev->enable_mutex);
+	ret = vf_qm_state_save(hisi_acc_vdev, migf);
+	if (ret) {
+		mutex_unlock(&hisi_acc_vdev->enable_mutex);
+		seq_printf(seq, "%s\n", "failed to save device data!");
+		return 0;
+	}
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
@@ -1353,7 +1537,9 @@ static void hisi_acc_vfio_pci_close_device(struct vfio_device *core_vdev)
 	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(core_vdev);
 	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
 
+	mutex_lock(&hisi_acc_vdev->enable_mutex);
 	iounmap(vf_qm->io_base);
+	mutex_unlock(&hisi_acc_vdev->enable_mutex);
 	vfio_pci_core_close_device(core_vdev);
 }
 
@@ -1444,6 +1630,9 @@ static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device
 	ret = vfio_pci_core_register_device(&hisi_acc_vdev->core_device);
 	if (ret)
 		goto out_put_vdev;
+
+	if (ops == &hisi_acc_vfio_pci_migrn_ops)
+		hisi_acc_vfio_debug_init(hisi_acc_vdev);
 	return 0;
 
 out_put_vdev:
@@ -1456,6 +1645,7 @@ static void hisi_acc_vfio_pci_remove(struct pci_dev *pdev)
 	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_drvdata(pdev);
 
 	vfio_pci_core_unregister_device(&hisi_acc_vdev->core_device);
+	hisi_acc_vf_debugfs_exit(hisi_acc_vdev);
 	vfio_put_device(&hisi_acc_vdev->core_device.vdev);
 }
 
diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
index c58fc5861492..38327b97d535 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
@@ -116,5 +116,10 @@ struct hisi_acc_vf_core_device {
 	spinlock_t reset_lock;
 	struct hisi_acc_vf_migration_file *resuming_migf;
 	struct hisi_acc_vf_migration_file *saving_migf;
+
+	/* To make sure the device is enabled */
+	struct mutex enable_mutex;
+	/* For debugfs */
+	struct hisi_acc_vf_migration_file *debug_migf;
 };
 #endif /* HISI_ACC_VFIO_PCI_H */
-- 
2.24.0


