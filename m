Return-Path: <kvm+bounces-51083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EE38AED7ED
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 10:56:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5BFB17A4B5B
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 08:54:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F05923F40A;
	Mon, 30 Jun 2025 08:55:54 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C1314F70;
	Mon, 30 Jun 2025 08:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751273753; cv=none; b=d0AVG8DW6FWLD+GT60imzJwgi3PAYeJkVLfkWAPWwmrivF5vDTMOTGwlHKzK5RD354+o1uxzWs3R2Fv2XtCnBSqA9JE/2I5UZ2KC1MjdBHKpYyUZFzwnDwEjRMtwMkjp96Iqxuzc2pB58udzQe6Cp2XS/R73M1B8vf/18OXiwPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751273753; c=relaxed/simple;
	bh=G1Cx2REDsDBM6SXkK8f/x4mPcGqU9e2FEG9c86xREDY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FcOD5Il4sqbgIKmbXx/gOdIW1CDwQnv6p4/9Dr4Cyf/FVP6I3LgE8v+OJOO+Bj3d4IDuzFBJwezx2Erabl7MpE6qCcK95aze4zpVfsO5oLd+uPncBzIC17HTEpQceoZaX7mDwMVoFDt4BTOFBD8dssf5e5uZeX4D++Z8nyhV8cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4bW0LS0j9Nz13MhP;
	Mon, 30 Jun 2025 16:53:20 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id 3477B1402C8;
	Mon, 30 Jun 2025 16:55:47 +0800 (CST)
Received: from huawei.com (10.50.165.33) by dggpemf500015.china.huawei.com
 (7.185.36.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 30 Jun
 2025 16:55:46 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v5 3/3] migration: adapt to new migration configuration
Date: Mon, 30 Jun 2025 16:54:02 +0800
Message-ID: <20250630085402.7491-4-liulongfang@huawei.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20250630085402.7491-1-liulongfang@huawei.com>
References: <20250630085402.7491-1-liulongfang@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemf500015.china.huawei.com (7.185.36.143)

On new platforms greater than QM_HW_V3, the migration region has been
relocated from the VF to the PF. The driver must also be modified
accordingly to adapt to the new hardware device.

Utilize the PF's I/O base directly on the new hardware platform,
and no mmap operation is required. If it is on an old platform,
the driver needs to be compatible with the old solution.

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
---
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 166 ++++++++++++------
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |   7 +
 2 files changed, 120 insertions(+), 53 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index 1ddc9dbadb70..3aec3b92787f 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -125,6 +125,72 @@ static int qm_get_cqc(struct hisi_qm *qm, u64 *addr)
 	return 0;
 }
 
+static int qm_get_xqc_regs(struct hisi_acc_vf_core_device *hisi_acc_vdev,
+			   struct acc_vf_data *vf_data)
+{
+	struct hisi_qm *qm = &hisi_acc_vdev->vf_qm;
+	struct device *dev = &qm->pdev->dev;
+	u32 eqc_addr, aeqc_addr;
+	int ret;
+
+	if (qm->ver == QM_HW_V3) {
+		eqc_addr = QM_EQC_DW0;
+		aeqc_addr = QM_AEQC_DW0;
+	} else {
+		eqc_addr = QM_EQC_PF_DW0;
+		aeqc_addr = QM_AEQC_PF_DW0;
+	}
+
+	/* QM_EQC_DW has 7 regs */
+	ret = qm_read_regs(qm, eqc_addr, vf_data->qm_eqc_dw, 7);
+	if (ret) {
+		dev_err(dev, "failed to read QM_EQC_DW\n");
+		return ret;
+	}
+
+	/* QM_AEQC_DW has 7 regs */
+	ret = qm_read_regs(qm, aeqc_addr, vf_data->qm_aeqc_dw, 7);
+	if (ret) {
+		dev_err(dev, "failed to read QM_AEQC_DW\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int qm_set_xqc_regs(struct hisi_acc_vf_core_device *hisi_acc_vdev,
+			   struct acc_vf_data *vf_data)
+{
+	struct hisi_qm *qm = &hisi_acc_vdev->vf_qm;
+	struct device *dev = &qm->pdev->dev;
+	u32 eqc_addr, aeqc_addr;
+	int ret;
+
+	if (qm->ver == QM_HW_V3) {
+		eqc_addr = QM_EQC_DW0;
+		aeqc_addr = QM_AEQC_DW0;
+	} else {
+		eqc_addr = QM_EQC_PF_DW0;
+		aeqc_addr = QM_AEQC_PF_DW0;
+	}
+
+	/* QM_EQC_DW has 7 regs */
+	ret = qm_write_regs(qm, eqc_addr, vf_data->qm_eqc_dw, 7);
+	if (ret) {
+		dev_err(dev, "failed to write QM_EQC_DW\n");
+		return ret;
+	}
+
+	/* QM_AEQC_DW has 7 regs */
+	ret = qm_write_regs(qm, aeqc_addr, vf_data->qm_aeqc_dw, 7);
+	if (ret) {
+		dev_err(dev, "failed to write QM_AEQC_DW\n");
+		return ret;
+	}
+
+	return 0;
+}
+
 static int qm_get_regs(struct hisi_qm *qm, struct acc_vf_data *vf_data)
 {
 	struct device *dev = &qm->pdev->dev;
@@ -167,20 +233,6 @@ static int qm_get_regs(struct hisi_qm *qm, struct acc_vf_data *vf_data)
 		return ret;
 	}
 
-	/* QM_EQC_DW has 7 regs */
-	ret = qm_read_regs(qm, QM_EQC_DW0, vf_data->qm_eqc_dw, 7);
-	if (ret) {
-		dev_err(dev, "failed to read QM_EQC_DW\n");
-		return ret;
-	}
-
-	/* QM_AEQC_DW has 7 regs */
-	ret = qm_read_regs(qm, QM_AEQC_DW0, vf_data->qm_aeqc_dw, 7);
-	if (ret) {
-		dev_err(dev, "failed to read QM_AEQC_DW\n");
-		return ret;
-	}
-
 	return 0;
 }
 
@@ -239,20 +291,6 @@ static int qm_set_regs(struct hisi_qm *qm, struct acc_vf_data *vf_data)
 		return ret;
 	}
 
-	/* QM_EQC_DW has 7 regs */
-	ret = qm_write_regs(qm, QM_EQC_DW0, vf_data->qm_eqc_dw, 7);
-	if (ret) {
-		dev_err(dev, "failed to write QM_EQC_DW\n");
-		return ret;
-	}
-
-	/* QM_AEQC_DW has 7 regs */
-	ret = qm_write_regs(qm, QM_AEQC_DW0, vf_data->qm_aeqc_dw, 7);
-	if (ret) {
-		dev_err(dev, "failed to write QM_AEQC_DW\n");
-		return ret;
-	}
-
 	return 0;
 }
 
@@ -522,6 +560,10 @@ static int vf_qm_load_data(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 		return ret;
 	}
 
+	ret = qm_set_xqc_regs(hisi_acc_vdev, vf_data);
+	if (ret)
+		return ret;
+
 	ret = hisi_qm_mb(qm, QM_MB_CMD_SQC_BT, qm->sqc_dma, 0, 0);
 	if (ret) {
 		dev_err(dev, "set sqc failed\n");
@@ -589,6 +631,10 @@ static int vf_qm_state_save(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 	vf_data->vf_qm_state = QM_READY;
 	hisi_acc_vdev->vf_qm_state = vf_data->vf_qm_state;
 
+	ret = qm_get_xqc_regs(hisi_acc_vdev, vf_data);
+	if (ret)
+		return ret;
+
 	ret = vf_qm_read_data(vf_qm, vf_data);
 	if (ret)
 		return ret;
@@ -1186,34 +1232,47 @@ static int hisi_acc_vf_qm_init(struct hisi_acc_vf_core_device *hisi_acc_vdev)
 {
 	struct vfio_pci_core_device *vdev = &hisi_acc_vdev->core_device;
 	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
+	struct hisi_qm *pf_qm = hisi_acc_vdev->pf_qm;
 	struct pci_dev *vf_dev = vdev->pdev;
 
-	/*
-	 * ACC VF dev BAR2 region consists of both functional register space
-	 * and migration control register space. For migration to work, we
-	 * need access to both. Hence, we map the entire BAR2 region here.
-	 * But unnecessarily exposing the migration BAR region to the Guest
-	 * has the potential to prevent/corrupt the Guest migration. Hence,
-	 * we restrict access to the migration control space from
-	 * Guest(Please see mmap/ioctl/read/write override functions).
-	 *
-	 * Please note that it is OK to expose the entire VF BAR if migration
-	 * is not supported or required as this cannot affect the ACC PF
-	 * configurations.
-	 *
-	 * Also the HiSilicon ACC VF devices supported by this driver on
-	 * HiSilicon hardware platforms are integrated end point devices
-	 * and the platform lacks the capability to perform any PCIe P2P
-	 * between these devices.
-	 */
+	if (pf_qm->ver == QM_HW_V3) {
+		/*
+		 * ACC VF dev BAR2 region consists of both functional register space
+		 * and migration control register space. For migration to work, we
+		 * need access to both. Hence, we map the entire BAR2 region here.
+		 * But unnecessarily exposing the migration BAR region to the Guest
+		 * has the potential to prevent/corrupt the Guest migration. Hence,
+		 * we restrict access to the migration control space from
+		 * Guest(Please see mmap/ioctl/read/write override functions).
+		 *
+		 * Please note that it is OK to expose the entire VF BAR if migration
+		 * is not supported or required as this cannot affect the ACC PF
+		 * configurations.
+		 *
+		 * Also the HiSilicon ACC VF devices supported by this driver on
+		 * HiSilicon hardware platforms are integrated end point devices
+		 * and the platform lacks the capability to perform any PCIe P2P
+		 * between these devices.
+		 */
 
-	vf_qm->io_base =
-		ioremap(pci_resource_start(vf_dev, VFIO_PCI_BAR2_REGION_INDEX),
-			pci_resource_len(vf_dev, VFIO_PCI_BAR2_REGION_INDEX));
-	if (!vf_qm->io_base)
-		return -EIO;
+		vf_qm->io_base =
+			ioremap(pci_resource_start(vf_dev, VFIO_PCI_BAR2_REGION_INDEX),
+				pci_resource_len(vf_dev, VFIO_PCI_BAR2_REGION_INDEX));
+		if (!vf_qm->io_base)
+			return -EIO;
 
-	vf_qm->fun_type = QM_HW_VF;
+		vf_qm->fun_type = QM_HW_VF;
+		vf_qm->ver = pf_qm->ver;
+	} else {
+		/*
+		 * On hardware platforms greater than QM_HW_V3, the migration function
+		 * register is placed in the BAR2 configuration region of the PF,
+		 * and each VF device occupies 8KB of configuration space.
+		 */
+		vf_qm->io_base = pf_qm->io_base + QM_MIG_REGION_OFFSET +
+				 hisi_acc_vdev->vf_id * QM_MIG_REGION_SIZE;
+		vf_qm->fun_type = QM_HW_PF;
+	}
 	vf_qm->pdev = vf_dev;
 	mutex_init(&vf_qm->mailbox_lock);
 
@@ -1539,7 +1598,8 @@ static void hisi_acc_vfio_pci_close_device(struct vfio_device *core_vdev)
 	hisi_acc_vf_disable_fds(hisi_acc_vdev);
 	mutex_lock(&hisi_acc_vdev->open_mutex);
 	hisi_acc_vdev->dev_opened = false;
-	iounmap(vf_qm->io_base);
+	if (vf_qm->ver == QM_HW_V3)
+		iounmap(vf_qm->io_base);
 	mutex_unlock(&hisi_acc_vdev->open_mutex);
 	vfio_pci_core_close_device(core_vdev);
 }
diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
index 91002ceeebc1..348f8bb5b42c 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
@@ -59,6 +59,13 @@
 #define ACC_DEV_MAGIC_V1	0XCDCDCDCDFEEDAACC
 #define ACC_DEV_MAGIC_V2	0xAACCFEEDDECADEDE
 
+#define QM_MIG_REGION_OFFSET		0x180000
+#define QM_MIG_REGION_SIZE		0x2000
+
+#define QM_SUB_VERSION_ID		0x100210
+#define QM_EQC_PF_DW0			0x1c00
+#define QM_AEQC_PF_DW0			0x1c20
+
 struct acc_vf_data {
 #define QM_MATCH_SIZE offsetofend(struct acc_vf_data, qm_rsv_state)
 	/* QM match information */
-- 
2.24.0


