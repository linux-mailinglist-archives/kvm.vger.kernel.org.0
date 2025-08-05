Return-Path: <kvm+bounces-53963-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1340EB1AECF
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 08:52:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 32C6716CD18
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 06:52:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CF07221F32;
	Tue,  5 Aug 2025 06:52:49 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECB9A927;
	Tue,  5 Aug 2025 06:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754376768; cv=none; b=Q0EnZaahH6SJwS0kewALrJbeGtXwqdgSCpBFDxg2Fg1x43B0igkz29+236HG8m6MZidTFr8CsgtqX5a4MjUJf3TQUMPQy9UenLhsqlBlcGto13PiKPz7fo/kzCHzIDO6xzxU95NlmsKYq8pBmiUsiQlCLYrtt/wlOrzYtRi2LpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754376768; c=relaxed/simple;
	bh=dOMNrFkdF3d/bghtMW/jDThJaP82j14On+OkxCJkibU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ChF3lOnjHUr+hBObsKT7Jvh8+/UxNDtBI5VK0oT/FtpXChye3muTNeVpw+W/bQuw37w8wxKJYNMbzz+OaB9lF7/isXeadEu8Y/bTAndduHe616pPfsMVdmZZmeJcmM6+2d0n7yjL5qVtGDaCimvCPGcp86xwg+i/eepvQk+EZVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4bx3rz72m6z14M9N;
	Tue,  5 Aug 2025 14:47:47 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id B93031402E9;
	Tue,  5 Aug 2025 14:52:43 +0800 (CST)
Received: from huawei.com (10.90.31.46) by dggpemf500015.china.huawei.com
 (7.185.36.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 5 Aug
 2025 14:52:43 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<herbert@gondor.apana.org.au>, <shameerali.kolothum.thodi@huawei.com>,
	<jonathan.cameron@huawei.com>
CC: <linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>,
	<liulongfang@huawei.com>
Subject: [PATCH v7 3/3] migration: adapt to new migration configuration
Date: Tue, 5 Aug 2025 14:51:06 +0800
Message-ID: <20250805065106.898298-4-liulongfang@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20250805065106.898298-1-liulongfang@huawei.com>
References: <20250805065106.898298-1-liulongfang@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf500015.china.huawei.com (7.185.36.143)

On new platforms greater than QM_HW_V3, the migration region has been
relocated from the VF to the PF. The driver must also be modified
accordingly to adapt to the new hardware device.

On the older hardware platform QM_HW_V3, the live migration configuration
region is placed in the latter 32K portion of the VF's BAR2 configuration
space. On the new hardware platform QM_HW_V4, the live migration
configuration region also exists in the same 32K area immediately following
the VF's BAR2, just like on QM_HW_V3.

However, access to this region is now controlled by hardware. Additionally,
a copy of the live migration configuration region is present in the PF's BAR2
configuration space. On the new hardware platform QM_HW_V4, when an older
version of the driver is loaded, it behaves like QM_HW_V3 and uses the
configuration region in the VF, ensuring that the live migration function
continues to work normally. When the new version of the driver is loaded,
it directly uses the configuration region in the PF. Meanwhile, hardware
configuration disables the live migration configuration region in the VF's
BAR2: reads return all 0xF values, and writes are silently ignored.

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 164 ++++++++++++------
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |   7 +
 2 files changed, 118 insertions(+), 53 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index ddb3fd4df5aa..a20785bcea62 100644
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
@@ -1186,34 +1232,45 @@ static int hisi_acc_vf_qm_init(struct hisi_acc_vf_core_device *hisi_acc_vdev)
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
-
-	vf_qm->io_base =
-		ioremap(pci_resource_start(vf_dev, VFIO_PCI_BAR2_REGION_INDEX),
-			pci_resource_len(vf_dev, VFIO_PCI_BAR2_REGION_INDEX));
-	if (!vf_qm->io_base)
-		return -EIO;
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
 
+		vf_qm->io_base =
+			ioremap(pci_resource_start(vf_dev, VFIO_PCI_BAR2_REGION_INDEX),
+				pci_resource_len(vf_dev, VFIO_PCI_BAR2_REGION_INDEX));
+		if (!vf_qm->io_base)
+			return -EIO;
+	} else {
+		/*
+		 * On hardware platforms greater than QM_HW_V3, the migration function
+		 * register is placed in the BAR2 configuration region of the PF,
+		 * and each VF device occupies 8KB of configuration space.
+		 */
+		vf_qm->io_base = pf_qm->io_base + QM_MIG_REGION_OFFSET +
+				 hisi_acc_vdev->vf_id * QM_MIG_REGION_SIZE;
+	}
 	vf_qm->fun_type = QM_HW_VF;
+	vf_qm->ver = pf_qm->ver;
 	vf_qm->pdev = vf_dev;
 	mutex_init(&vf_qm->mailbox_lock);
 
@@ -1539,7 +1596,8 @@ static void hisi_acc_vfio_pci_close_device(struct vfio_device *core_vdev)
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


