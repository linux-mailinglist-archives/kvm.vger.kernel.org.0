Return-Path: <kvm+bounces-61390-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 92FACC1A6BA
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 13:55:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B2A44582196
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 12:48:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33A2E3644BA;
	Wed, 29 Oct 2025 12:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="m13q6ii/"
X-Original-To: kvm@vger.kernel.org
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A360036449D;
	Wed, 29 Oct 2025 12:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761740752; cv=none; b=nOh+BK7k5S/+Ad/23a9iJ2H8eUKsuyFKt++XTZ6ZU3OLQjmTbYmjMWn6N4MRcDRU0LtStRlRhATJcfpwz4AFeon7IqvPD1OonHec/TVADQVAHsAMJZM4HXMSMtU9gYE3asS0HOerfXEPAdWNCk6X18z7sBVe0SyTH1MNI7kAHH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761740752; c=relaxed/simple;
	bh=PtupePlo8OMYijM47FMUPpaeBCPL3qNmrhyukyehrP8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ICTM7VwsFaKCGvaXU+lB6NzBJPGTAq8THa5ioMVBKYMZnAIMfay3uPbrEX7nqANcwvYaup7gf0c7caiF3fcCP27mLHwDNojaLmlqoaC7r4lEqhv8nFJSmHusubxK5q3fqOkUBZyQPAdCzmqoChcC9xYwCGD6PVFTmsjU5HxVGIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=m13q6ii/; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=lSjBVyPWQ1aQpf9+1QsVhcNZ8+OyV4cyPdLCxMIC7Ls=;
	b=m13q6ii/xTQ+jk3zRXepaxdZCpPtBCOOGkjPiUkSV6xcb+7Fn7bPSxvObn3dDY99AJV7xvFMs
	XdVD8UPq+NUQQrg28MA8VOoQu+SPgVX/t3nPQNxcenwRxnHiQECPRN9jTMRAKD7YHbKAvkzCzT2
	ZFphqeY74xB7VqsSQK/k2S4=
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4cxRK01dPCz12LJn;
	Wed, 29 Oct 2025 20:25:08 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id 641941402C4;
	Wed, 29 Oct 2025 20:25:45 +0800 (CST)
Received: from huawei.com (10.90.31.46) by dggpemf500015.china.huawei.com
 (7.185.36.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 29 Oct
 2025 20:25:44 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<herbert@gondor.apana.org.au>, <shameerkolothum@gmail.com>,
	<jonathan.cameron@huawei.com>
CC: <linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>,
	<liulongfang@huawei.com>
Subject: [PATCH v11 2/2] hisi_acc_vfio_pci: adapt to new migration configuration
Date: Wed, 29 Oct 2025 20:24:41 +0800
Message-ID: <20251029122441.3063127-3-liulongfang@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20251029122441.3063127-1-liulongfang@huawei.com>
References: <20251029122441.3063127-1-liulongfang@huawei.com>
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
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 130 +++++++++++++-----
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  23 +++-
 2 files changed, 114 insertions(+), 39 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index fde33f54e99e..498cb7d1c9e5 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -125,9 +125,25 @@ static int qm_get_cqc(struct hisi_qm *qm, u64 *addr)
 	return 0;
 }
 
+static void qm_xqc_reg_offsets(struct hisi_qm *qm,
+			       u32 *eqc_addr, u32 *aeqc_addr)
+{
+	struct hisi_acc_vf_core_device *hisi_acc_vdev =
+		container_of(qm, struct hisi_acc_vf_core_device, vf_qm);
+
+	if (hisi_acc_vdev->drv_mode == HW_ACC_MIG_VF_CTRL) {
+		*eqc_addr = QM_EQC_VF_DW0;
+		*aeqc_addr = QM_AEQC_VF_DW0;
+	} else {
+		*eqc_addr = QM_EQC_PF_DW0;
+		*aeqc_addr = QM_AEQC_PF_DW0;
+	}
+}
+
 static int qm_get_regs(struct hisi_qm *qm, struct acc_vf_data *vf_data)
 {
 	struct device *dev = &qm->pdev->dev;
+	u32 eqc_addr, aeqc_addr;
 	int ret;
 
 	ret = qm_read_regs(qm, QM_VF_AEQ_INT_MASK, &vf_data->aeq_int_mask, 1);
@@ -167,15 +183,16 @@ static int qm_get_regs(struct hisi_qm *qm, struct acc_vf_data *vf_data)
 		return ret;
 	}
 
+	qm_xqc_reg_offsets(qm, &eqc_addr, &aeqc_addr);
 	/* QM_EQC_DW has 7 regs */
-	ret = qm_read_regs(qm, QM_EQC_DW0, vf_data->qm_eqc_dw, 7);
+	ret = qm_read_regs(qm, eqc_addr, vf_data->qm_eqc_dw, 7);
 	if (ret) {
 		dev_err(dev, "failed to read QM_EQC_DW\n");
 		return ret;
 	}
 
 	/* QM_AEQC_DW has 7 regs */
-	ret = qm_read_regs(qm, QM_AEQC_DW0, vf_data->qm_aeqc_dw, 7);
+	ret = qm_read_regs(qm, aeqc_addr, vf_data->qm_aeqc_dw, 7);
 	if (ret) {
 		dev_err(dev, "failed to read QM_AEQC_DW\n");
 		return ret;
@@ -187,6 +204,7 @@ static int qm_get_regs(struct hisi_qm *qm, struct acc_vf_data *vf_data)
 static int qm_set_regs(struct hisi_qm *qm, struct acc_vf_data *vf_data)
 {
 	struct device *dev = &qm->pdev->dev;
+	u32 eqc_addr, aeqc_addr;
 	int ret;
 
 	/* Check VF state */
@@ -239,15 +257,16 @@ static int qm_set_regs(struct hisi_qm *qm, struct acc_vf_data *vf_data)
 		return ret;
 	}
 
+	qm_xqc_reg_offsets(qm, &eqc_addr, &aeqc_addr);
 	/* QM_EQC_DW has 7 regs */
-	ret = qm_write_regs(qm, QM_EQC_DW0, vf_data->qm_eqc_dw, 7);
+	ret = qm_write_regs(qm, eqc_addr, vf_data->qm_eqc_dw, 7);
 	if (ret) {
 		dev_err(dev, "failed to write QM_EQC_DW\n");
 		return ret;
 	}
 
 	/* QM_AEQC_DW has 7 regs */
-	ret = qm_write_regs(qm, QM_AEQC_DW0, vf_data->qm_aeqc_dw, 7);
+	ret = qm_write_regs(qm, aeqc_addr, vf_data->qm_aeqc_dw, 7);
 	if (ret) {
 		dev_err(dev, "failed to write QM_AEQC_DW\n");
 		return ret;
@@ -1186,34 +1205,52 @@ static int hisi_acc_vf_qm_init(struct hisi_acc_vf_core_device *hisi_acc_vdev)
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
 
@@ -1250,6 +1287,28 @@ static struct hisi_qm *hisi_acc_get_pf_qm(struct pci_dev *pdev)
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
@@ -1260,8 +1319,9 @@ static int hisi_acc_pci_rw_access_check(struct vfio_device *core_vdev,
 
 	if (index == VFIO_PCI_BAR2_REGION_INDEX) {
 		loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
-		resource_size_t end = pci_resource_len(vdev->pdev, index) / 2;
+		resource_size_t end;
 
+		end = hisi_acc_get_resource_len(vdev, index);
 		/* Check if access is for migration control region */
 		if (pos >= end)
 			return -EINVAL;
@@ -1282,8 +1342,9 @@ static int hisi_acc_vfio_pci_mmap(struct vfio_device *core_vdev,
 	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
 	if (index == VFIO_PCI_BAR2_REGION_INDEX) {
 		u64 req_len, pgoff, req_start;
-		resource_size_t end = pci_resource_len(vdev->pdev, index) / 2;
+		resource_size_t end;
 
+		end = hisi_acc_get_resource_len(vdev, index);
 		req_len = vma->vm_end - vma->vm_start;
 		pgoff = vma->vm_pgoff &
 			((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
@@ -1330,7 +1391,6 @@ static long hisi_acc_vfio_pci_ioctl(struct vfio_device *core_vdev, unsigned int
 	if (cmd == VFIO_DEVICE_GET_REGION_INFO) {
 		struct vfio_pci_core_device *vdev =
 			container_of(core_vdev, struct vfio_pci_core_device, vdev);
-		struct pci_dev *pdev = vdev->pdev;
 		struct vfio_region_info info;
 		unsigned long minsz;
 
@@ -1345,12 +1405,7 @@ static long hisi_acc_vfio_pci_ioctl(struct vfio_device *core_vdev, unsigned int
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
@@ -1521,7 +1576,8 @@ static void hisi_acc_vfio_pci_close_device(struct vfio_device *core_vdev)
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
index 91002ceeebc1..419a378c3d1d 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
@@ -50,8 +50,10 @@
 #define QM_QUE_ISO_CFG_V	0x0030
 #define QM_PAGE_SIZE		0x0034
 
-#define QM_EQC_DW0		0X8000
-#define QM_AEQC_DW0		0X8020
+#define QM_EQC_VF_DW0		0X8000
+#define QM_AEQC_VF_DW0		0X8020
+#define QM_EQC_PF_DW0		0x1c00
+#define QM_AEQC_PF_DW0		0x1c20
 
 #define ACC_DRV_MAJOR_VER 1
 #define ACC_DRV_MINOR_VER 0
@@ -59,6 +61,22 @@
 #define ACC_DEV_MAGIC_V1	0XCDCDCDCDFEEDAACC
 #define ACC_DEV_MAGIC_V2	0xAACCFEEDDECADEDE
 
+#define QM_MIG_REGION_OFFSET		0x180000
+#define QM_MIG_REGION_SIZE		0x2000
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
@@ -125,6 +143,7 @@ struct hisi_acc_vf_core_device {
 	struct pci_dev *vf_dev;
 	struct hisi_qm *pf_qm;
 	struct hisi_qm vf_qm;
+	int drv_mode;
 	/*
 	 * vf_qm_state represents the QM_VF_STATE register value.
 	 * It is set by Guest driver for the ACC VF dev indicating
-- 
2.33.0


