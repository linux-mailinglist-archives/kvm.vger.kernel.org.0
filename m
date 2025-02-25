Return-Path: <kvm+bounces-39086-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FEFBA4353C
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 07:30:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 30EE47A86F4
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 06:27:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C0ED257438;
	Tue, 25 Feb 2025 06:28:26 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638FB256C9B;
	Tue, 25 Feb 2025 06:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740464905; cv=none; b=cKgMY0+JabL7+YwOgOrFDKbqV1c5mK6Gd0m1PafhH0fl1wADq186CbG+feCNhSAz9zmogr/z1Vac5A2zIN1ottKxTMkt/MeVJJKxpb83YHtk8INmDIBXvd3CKBdez050K8yzyOwtESgjxAX+JwfwKU2wNO6qMpykAOAzJv9n/hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740464905; c=relaxed/simple;
	bh=i2aezSjGBhs0C0QdFWRapJiWHrp6/7+gnK/jlM+Xg30=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EEGLYHbZiYZR1xK905l/dTU/e+71ESf/0Vy43m8bdEVY0SDKyNDbqnusNvTf27tzhhyrvWvATzrEnK4ZmugpUtjoQyd3/CLM7jMUfAEkva6P8mqlUt4OKs5+NHUHjw1U+wWCgatVKYSfAqP1OAgVAXbmZevOHsDVAbNRdX0iNTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Z26zJ4RYdz21p5x;
	Tue, 25 Feb 2025 14:25:16 +0800 (CST)
Received: from kwepemg500006.china.huawei.com (unknown [7.202.181.43])
	by mail.maildlp.com (Postfix) with ESMTPS id B4EE1180069;
	Tue, 25 Feb 2025 14:28:20 +0800 (CST)
Received: from huawei.com (10.50.165.33) by kwepemg500006.china.huawei.com
 (7.202.181.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 25 Feb
 2025 14:28:20 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v4 1/5] hisi_acc_vfio_pci: fix XQE dma address error
Date: Tue, 25 Feb 2025 14:27:53 +0800
Message-ID: <20250225062757.19692-2-liulongfang@huawei.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20250225062757.19692-1-liulongfang@huawei.com>
References: <20250225062757.19692-1-liulongfang@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemg500006.china.huawei.com (7.202.181.43)

The dma addresses of EQE and AEQE are wrong after migration and
results in guest kernel-mode encryption services  failure.
Comparing the definition of hardware registers, we found that
there was an error when the data read from the register was
combined into an address. Therefore, the address combination
sequence needs to be corrected.

Even after fixing the above problem, we still have an issue
where the Guest from an old kernel can get migrated to
new kernel and may result in wrong data.

In order to ensure that the address is correct after migration,
if an old magic number is detected, the dma address needs to be
updated.

Fixes: b0eed085903e ("hisi_acc_vfio_pci: Add support for VFIO live migration")
Signed-off-by: Longfang Liu <liulongfang@huawei.com>
---
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 40 ++++++++++++++++---
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    | 14 ++++++-
 2 files changed, 46 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index 451c639299eb..35316984089b 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -350,6 +350,31 @@ static int vf_qm_func_stop(struct hisi_qm *qm)
 	return hisi_qm_mb(qm, QM_MB_CMD_PAUSE_QM, 0, 0, 0);
 }
 
+static int vf_qm_version_check(struct acc_vf_data *vf_data, struct device *dev)
+{
+	switch (vf_data->acc_magic) {
+	case ACC_DEV_MAGIC_V2:
+		if (vf_data->major_ver < ACC_DRV_MAJOR_VER ||
+		    vf_data->minor_ver < ACC_DRV_MINOR_VER)
+			dev_info(dev, "migration driver version not match!\n");
+			return -EINVAL;
+		break;
+	case ACC_DEV_MAGIC_V1:
+		/* Correct dma address */
+		vf_data->eqe_dma = vf_data->qm_eqc_dw[QM_XQC_ADDR_HIGH];
+		vf_data->eqe_dma <<= QM_XQC_ADDR_OFFSET;
+		vf_data->eqe_dma |= vf_data->qm_eqc_dw[QM_XQC_ADDR_LOW];
+		vf_data->aeqe_dma = vf_data->qm_aeqc_dw[QM_XQC_ADDR_HIGH];
+		vf_data->aeqe_dma <<= QM_XQC_ADDR_OFFSET;
+		vf_data->aeqe_dma |= vf_data->qm_aeqc_dw[QM_XQC_ADDR_LOW];
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int vf_qm_check_match(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 			     struct hisi_acc_vf_migration_file *migf)
 {
@@ -363,7 +388,8 @@ static int vf_qm_check_match(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 	if (migf->total_length < QM_MATCH_SIZE || hisi_acc_vdev->match_done)
 		return 0;
 
-	if (vf_data->acc_magic != ACC_DEV_MAGIC) {
+	ret = vf_qm_version_check(vf_data, dev);
+	if (ret) {
 		dev_err(dev, "failed to match ACC_DEV_MAGIC\n");
 		return -EINVAL;
 	}
@@ -418,7 +444,9 @@ static int vf_qm_get_match_data(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 	int vf_id = hisi_acc_vdev->vf_id;
 	int ret;
 
-	vf_data->acc_magic = ACC_DEV_MAGIC;
+	vf_data->acc_magic = ACC_DEV_MAGIC_V2;
+	vf_data->major_ver = ACC_DRV_MAR;
+	vf_data->minor_ver = ACC_DRV_MIN;
 	/* Save device id */
 	vf_data->dev_id = hisi_acc_vdev->vf_dev->device;
 
@@ -496,12 +524,12 @@ static int vf_qm_read_data(struct hisi_qm *vf_qm, struct acc_vf_data *vf_data)
 		return -EINVAL;
 
 	/* Every reg is 32 bit, the dma address is 64 bit. */
-	vf_data->eqe_dma = vf_data->qm_eqc_dw[1];
+	vf_data->eqe_dma = vf_data->qm_eqc_dw[QM_XQC_ADDR_HIGH];
 	vf_data->eqe_dma <<= QM_XQC_ADDR_OFFSET;
-	vf_data->eqe_dma |= vf_data->qm_eqc_dw[0];
-	vf_data->aeqe_dma = vf_data->qm_aeqc_dw[1];
+	vf_data->eqe_dma |= vf_data->qm_eqc_dw[QM_XQC_ADDR_LOW];
+	vf_data->aeqe_dma = vf_data->qm_aeqc_dw[QM_XQC_ADDR_HIGH];
 	vf_data->aeqe_dma <<= QM_XQC_ADDR_OFFSET;
-	vf_data->aeqe_dma |= vf_data->qm_aeqc_dw[0];
+	vf_data->aeqe_dma |= vf_data->qm_aeqc_dw[QM_XQC_ADDR_LOW];
 
 	/* Through SQC_BT/CQC_BT to get sqc and cqc address */
 	ret = qm_get_sqc(vf_qm, &vf_data->sqc_dma);
diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
index 245d7537b2bc..91002ceeebc1 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
@@ -39,6 +39,9 @@
 #define QM_REG_ADDR_OFFSET	0x0004
 
 #define QM_XQC_ADDR_OFFSET	32U
+#define QM_XQC_ADDR_LOW	0x1
+#define QM_XQC_ADDR_HIGH	0x2
+
 #define QM_VF_AEQ_INT_MASK	0x0004
 #define QM_VF_EQ_INT_MASK	0x000c
 #define QM_IFC_INT_SOURCE_V	0x0020
@@ -50,10 +53,15 @@
 #define QM_EQC_DW0		0X8000
 #define QM_AEQC_DW0		0X8020
 
+#define ACC_DRV_MAJOR_VER 1
+#define ACC_DRV_MINOR_VER 0
+
+#define ACC_DEV_MAGIC_V1	0XCDCDCDCDFEEDAACC
+#define ACC_DEV_MAGIC_V2	0xAACCFEEDDECADEDE
+
 struct acc_vf_data {
 #define QM_MATCH_SIZE offsetofend(struct acc_vf_data, qm_rsv_state)
 	/* QM match information */
-#define ACC_DEV_MAGIC	0XCDCDCDCDFEEDAACC
 	u64 acc_magic;
 	u32 qp_num;
 	u32 dev_id;
@@ -61,7 +69,9 @@ struct acc_vf_data {
 	u32 qp_base;
 	u32 vf_qm_state;
 	/* QM reserved match information */
-	u32 qm_rsv_state[3];
+	u16 major_ver;
+	u16 minor_ver;
+	u32 qm_rsv_state[2];
 
 	/* QM RW regs */
 	u32 aeq_int_mask;
-- 
2.24.0


