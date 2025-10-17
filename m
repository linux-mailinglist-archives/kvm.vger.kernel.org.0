Return-Path: <kvm+bounces-60285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id E0845BE7B5C
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 11:29:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 41A3A567874
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 09:24:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D8D73321CB;
	Fri, 17 Oct 2025 09:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="qObsKY+x"
X-Original-To: kvm@vger.kernel.org
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D182D94A0;
	Fri, 17 Oct 2025 09:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760692328; cv=none; b=JrUUcEDoq93RlmSDxP+fBTC4kHmNWCm9B/dw6Gjc/1jlvq6TSA45OAKmkmzSNp+75ev4djLho4+Ul09Pccro7UVI9tTwCz9ruf0kNjjQnio3jfnoBEm6W6krTbrX8Uc3QeYRp3PaRrU9kJgb8/lcitbw9uPoQadGsfyjoaEKCW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760692328; c=relaxed/simple;
	bh=Bsf/CFaPhX5d78usVbawAxCdAb6tZOE2paxGRBcz/uM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TvUSDXQy/IiTyxzHd/OCs8M1/PRqIt9aC59FnmkYhnv9mgaZ6e17JFPFK6GoS0n6tMjhfpOmLKJYGwjLfmR5FLPo55W20YMaiWZOGxECDH0PFqnRM0xLLYOHk/WuYKKWTM08BVnCe6+HKFzrMGu06gJ8nFClLMH5UGnp3XGuSoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=qObsKY+x; arc=none smtp.client-ip=113.46.200.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=GR4TYOxILkj2V5x3l1mHGIRwyu/oYGdO6Gs/VoTL4yM=;
	b=qObsKY+xvHY/dxj0JwDIvjRbMCBO8ejD3xm52MMtlOjiRnSH9QFuaiaNEkfcPj6Q/xCDqSB2w
	GwC2CRtJrCsm6vN3uq55r5HZYN+pJJN7oxbMcfyCQrWJUDw/hOKcI61eFjUYRl5VHiHck3QV6w6
	bb4jJiu/wKIbWXsLWqIANZI=
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cnzbJ5GRXzKm5G;
	Fri, 17 Oct 2025 17:11:40 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id 2916D1A016C;
	Fri, 17 Oct 2025 17:12:02 +0800 (CST)
Received: from huawei.com (10.90.31.46) by dggpemf500015.china.huawei.com
 (7.185.36.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 17 Oct
 2025 17:12:01 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<herbert@gondor.apana.org.au>, <shameerkolothum@gmail.com>,
	<jonathan.cameron@huawei.com>
CC: <linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>,
	<liulongfang@huawei.com>
Subject: [PATCH v10 2/2] hisi_acc_vfio_pci: adapt to new migration configuration
Date: Fri, 17 Oct 2025 17:10:57 +0800
Message-ID: <20251017091057.3770403-3-liulongfang@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20251017091057.3770403-1-liulongfang@huawei.com>
References: <20251017091057.3770403-1-liulongfang@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500015.china.huawei.com (7.185.36.143)

On new platforms greater than QM_HW_V3, the migration region has been
relocated from the VF to the PF. The VF's own configuration space is
restored to the complete 64KB, and there is no need to divide the
size of the BAR configuration space equally. The driver should be
modified accordingly to adapt to the new hardware device.

On the older hardware platform QM_HW_V3, the live migration configuration
region is placed in the latter 32K portion of the VF's BAR2 configuration
space. On the new hardware platform QM_HW_V4, the live migration
configuration region also exists in the same 32K area immediately following
the VF's BAR2, just like on QM_HW_V3.

However, access to this region is now controlled by hardware. Additionally,
a copy of the live migration configuration region is present in the PF's
BAR2 configuration space. On the new hardware platform QM_HW_V4, when an
older version of the driver is loaded, it behaves like QM_HW_V3 and uses
the configuration region in the VF, ensuring that the live migration
function continues to work normally. When the new version of the driver is
loaded, it directly uses the configuration region in the PF. Meanwhile,
hardware configuration disables the live migration configuration region
in the VF's BAR2: reads return all 0xF values, and writes are silently
ignored.

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Reviewed-by: Shameer Kolothum <shameerkolothum@gmail.com>
---
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 205 ++++++++++++------
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  21 ++
 2 files changed, 165 insertions(+), 61 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index fde33f54e99e..55233e62cb1d 100644
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
+	if (hisi_acc_vdev->drv_mode == HW_ACC_MIG_VF_CTRL) {
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
+	if (hisi_acc_vdev->drv_mode == HW_ACC_MIG_VF_CTRL) {
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
@@ -1186,34 +1232,52 @@ static int hisi_acc_vf_qm_init(struct hisi_acc_vf_core_device *hisi_acc_vdev)
 {
 	struct vfio_pci_core_device *vdev = &hisi_acc_vdev->core_device;
 	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
+	struct hisi_qm *pf_qm = hisi_acc_vdev->pf_qm;
 	struct pci_dev *vf_dev = vdev->pdev;
+	u32 val;
 
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
+	val = readl(pf_qm->io_base + QM_MIG_REGION_SEL);
+	if (pf_qm->ver > QM_HW_V3 && (val & QM_MIG_REGION_EN))
+		hisi_acc_vdev->drv_mode = HW_ACC_MIG_PF_CTRL;
+	else
+		hisi_acc_vdev->drv_mode = HW_ACC_MIG_VF_CTRL;
 
-	vf_qm->io_base =
-		ioremap(pci_resource_start(vf_dev, VFIO_PCI_BAR2_REGION_INDEX),
-			pci_resource_len(vf_dev, VFIO_PCI_BAR2_REGION_INDEX));
-	if (!vf_qm->io_base)
-		return -EIO;
+	if (hisi_acc_vdev->drv_mode == HW_ACC_MIG_PF_CTRL) {
+		/*
+		 * On hardware platforms greater than QM_HW_V3, the migration function
+		 * register is placed in the BAR2 configuration region of the PF,
+		 * and each VF device occupies 8KB of configuration space.
+		 */
+		vf_qm->io_base = pf_qm->io_base + QM_MIG_REGION_OFFSET +
+				 hisi_acc_vdev->vf_id * QM_MIG_REGION_SIZE;
+	} else {
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
+	}
 	vf_qm->fun_type = QM_HW_VF;
+	vf_qm->ver = pf_qm->ver;
 	vf_qm->pdev = vf_dev;
 	mutex_init(&vf_qm->mailbox_lock);
 
@@ -1250,6 +1314,28 @@ static struct hisi_qm *hisi_acc_get_pf_qm(struct pci_dev *pdev)
 	return !IS_ERR(pf_qm) ? pf_qm : NULL;
 }
 
+static size_t hisi_acc_get_resource_len(struct vfio_pci_core_device *vdev,
+					unsigned int index)
+{
+	struct hisi_acc_vf_core_device *hisi_acc_vdev =
+			hisi_acc_drvdata(vdev->pdev);
+
+	/*
+	 * On the old HW_ACC_MIG_VF_CTRL mode device, the ACC VF device
+	 * BAR2 region encompasses both functional register space
+	 * and migration control register space.
+	 * only the functional region should be report to Guest.
+	 */
+	if (hisi_acc_vdev->drv_mode == HW_ACC_MIG_VF_CTRL)
+		return (pci_resource_len(vdev->pdev, index) >> 1);
+	/*
+	 * On the new HW device, the migration control register
+	 * has been moved to the PF device BAR2 region.
+	 * The VF device BAR2 is entirely functional register space.
+	 */
+	return pci_resource_len(vdev->pdev, index);
+}
+
 static int hisi_acc_pci_rw_access_check(struct vfio_device *core_vdev,
 					size_t count, loff_t *ppos,
 					size_t *new_count)
@@ -1260,8 +1346,9 @@ static int hisi_acc_pci_rw_access_check(struct vfio_device *core_vdev,
 
 	if (index == VFIO_PCI_BAR2_REGION_INDEX) {
 		loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
-		resource_size_t end = pci_resource_len(vdev->pdev, index) / 2;
+		resource_size_t end;
 
+		end = hisi_acc_get_resource_len(vdev, index);
 		/* Check if access is for migration control region */
 		if (pos >= end)
 			return -EINVAL;
@@ -1282,8 +1369,9 @@ static int hisi_acc_vfio_pci_mmap(struct vfio_device *core_vdev,
 	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
 	if (index == VFIO_PCI_BAR2_REGION_INDEX) {
 		u64 req_len, pgoff, req_start;
-		resource_size_t end = pci_resource_len(vdev->pdev, index) / 2;
+		resource_size_t end;
 
+		end = hisi_acc_get_resource_len(vdev, index);
 		req_len = vma->vm_end - vma->vm_start;
 		pgoff = vma->vm_pgoff &
 			((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
@@ -1330,7 +1418,6 @@ static long hisi_acc_vfio_pci_ioctl(struct vfio_device *core_vdev, unsigned int
 	if (cmd == VFIO_DEVICE_GET_REGION_INFO) {
 		struct vfio_pci_core_device *vdev =
 			container_of(core_vdev, struct vfio_pci_core_device, vdev);
-		struct pci_dev *pdev = vdev->pdev;
 		struct vfio_region_info info;
 		unsigned long minsz;
 
@@ -1345,12 +1432,7 @@ static long hisi_acc_vfio_pci_ioctl(struct vfio_device *core_vdev, unsigned int
 		if (info.index == VFIO_PCI_BAR2_REGION_INDEX) {
 			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
 
-			/*
-			 * ACC VF dev BAR2 region consists of both functional
-			 * register space and migration control register space.
-			 * Report only the functional region to Guest.
-			 */
-			info.size = pci_resource_len(pdev, info.index) / 2;
+			info.size = hisi_acc_get_resource_len(vdev, info.index);
 
 			info.flags = VFIO_REGION_INFO_FLAG_READ |
 					VFIO_REGION_INFO_FLAG_WRITE |
@@ -1521,7 +1603,8 @@ static void hisi_acc_vfio_pci_close_device(struct vfio_device *core_vdev)
 	hisi_acc_vf_disable_fds(hisi_acc_vdev);
 	mutex_lock(&hisi_acc_vdev->open_mutex);
 	hisi_acc_vdev->dev_opened = false;
-	iounmap(vf_qm->io_base);
+	if (hisi_acc_vdev->drv_mode == HW_ACC_MIG_VF_CTRL)
+		iounmap(vf_qm->io_base);
 	mutex_unlock(&hisi_acc_vdev->open_mutex);
 	vfio_pci_core_close_device(core_vdev);
 }
diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
index 91002ceeebc1..d287abe3dd31 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
@@ -59,6 +59,26 @@
 #define ACC_DEV_MAGIC_V1	0XCDCDCDCDFEEDAACC
 #define ACC_DEV_MAGIC_V2	0xAACCFEEDDECADEDE
 
+#define QM_MIG_REGION_OFFSET		0x180000
+#define QM_MIG_REGION_SIZE		0x2000
+
+#define QM_SUB_VERSION_ID		0x100210
+#define QM_EQC_PF_DW0			0x1c00
+#define QM_AEQC_PF_DW0			0x1c20
+
+/**
+ * On HW_ACC_MIG_VF_CTRL mode, the configuration domain supporting live
+ * migration functionality is located in the latter 32KB of the VF's BAR2.
+ * The Guest is only provided with the first 32KB of the VF's BAR2.
+ * On HW_ACC_MIG_PF_CTRL mode, the configuration domain supporting live
+ * migration functionality is located in the PF's BAR2, and the entire 64KB
+ * of the VF's BAR2 is allocated to the Guest.
+ */
+enum hw_drv_mode {
+	HW_ACC_MIG_VF_CTRL = 0,
+	HW_ACC_MIG_PF_CTRL,
+};
+
 struct acc_vf_data {
 #define QM_MATCH_SIZE offsetofend(struct acc_vf_data, qm_rsv_state)
 	/* QM match information */
@@ -125,6 +145,7 @@ struct hisi_acc_vf_core_device {
 	struct pci_dev *vf_dev;
 	struct hisi_qm *pf_qm;
 	struct hisi_qm vf_qm;
+	int drv_mode;
 	/*
 	 * vf_qm_state represents the QM_VF_STATE register value.
 	 * It is set by Guest driver for the ACC VF dev indicating
-- 
2.33.0


