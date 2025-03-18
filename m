Return-Path: <kvm+bounces-41368-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 13950A66AC1
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 07:46:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5F83A17BD87
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 06:46:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23A181DE8B9;
	Tue, 18 Mar 2025 06:46:38 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396AA42A83;
	Tue, 18 Mar 2025 06:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742280397; cv=none; b=D+T6A0lySDbTZOVSS7xV2vK/wHVJUKpHviS37hXglN2Opfp+2QzharfJaLX5HJnDVZoWoW0DO5YjBPMRnqORwvByWpLq8ztvredjyUnhl7bCKTMtiKWB2DKpBf7QanHxjwUH/w5BxFLtc4TL94ZUnbIBRsfVe2QK3TIntzFuWhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742280397; c=relaxed/simple;
	bh=rKzOLe8huGISi5dVyZUghbvaAVF8929hy5DzFg3bxeI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RJbL7PPwKQJbT3rbNSwxa5xWdO3pv57kDsMkxkz8ciHhVkQW86/puYNnR7WiluxUUqQprFHQWOpIFYsLYeHwgOawIXDeDgb10NoM1ZZxd9xUMGRuxkTvW8WGat8QdBNI+xcGgPi/3K6xmJ5QqjzZcUEesGk1NFxu7Mu8KmmhVBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4ZH2NJ2r3XzDt8y;
	Tue, 18 Mar 2025 14:43:12 +0800 (CST)
Received: from kwepemg500006.china.huawei.com (unknown [7.202.181.43])
	by mail.maildlp.com (Postfix) with ESMTPS id 09F061401F4;
	Tue, 18 Mar 2025 14:46:26 +0800 (CST)
Received: from huawei.com (10.50.165.33) by kwepemg500006.china.huawei.com
 (7.202.181.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 18 Mar
 2025 14:46:25 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v6 1/5] hisi_acc_vfio_pci: fix XQE dma address error
Date: Tue, 18 Mar 2025 14:45:44 +0800
Message-ID: <20250318064548.59043-2-liulongfang@huawei.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20250318064548.59043-1-liulongfang@huawei.com>
References: <20250318064548.59043-1-liulongfang@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
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

Fixes: b0eed085903e ("hisi_acc_vfio_pci: Add support for VFIO live migratio=
n")
Signed-off-by: Longfang Liu <liulongfang@huawei.com>=0D
Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 41 ++++++++++++++++---
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    | 14 ++++++-
 2 files changed, 47 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/=
pci/hisilicon/hisi_acc_vfio_pci.c
index 451c639299eb..304dbdfa0e95 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -350,6 +350,32 @@ static int vf_qm_func_stop(struct hisi_qm *qm)
 	return hisi_qm_mb(qm, QM_MB_CMD_PAUSE_QM, 0, 0, 0);
 }
=20
+static int vf_qm_version_check(struct acc_vf_data *vf_data, struct device =
*dev)
+{
+	switch (vf_data->acc_magic) {
+	case ACC_DEV_MAGIC_V2:
+		if (vf_data->major_ver !=3D ACC_DRV_MAJOR_VER) {
+			dev_info(dev, "migration driver version<%u.%u> not match!\n",
+				 vf_data->major_ver, vf_data->minor_ver);
+			return -EINVAL;
+		}
+		break;
+	case ACC_DEV_MAGIC_V1:
+		/* Correct dma address */
+		vf_data->eqe_dma =3D vf_data->qm_eqc_dw[QM_XQC_ADDR_HIGH];
+		vf_data->eqe_dma <<=3D QM_XQC_ADDR_OFFSET;
+		vf_data->eqe_dma |=3D vf_data->qm_eqc_dw[QM_XQC_ADDR_LOW];
+		vf_data->aeqe_dma =3D vf_data->qm_aeqc_dw[QM_XQC_ADDR_HIGH];
+		vf_data->aeqe_dma <<=3D QM_XQC_ADDR_OFFSET;
+		vf_data->aeqe_dma |=3D vf_data->qm_aeqc_dw[QM_XQC_ADDR_LOW];
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
@@ -363,7 +389,8 @@ static int vf_qm_check_match(struct hisi_acc_vf_core_de=
vice *hisi_acc_vdev,
 	if (migf->total_length < QM_MATCH_SIZE || hisi_acc_vdev->match_done)
 		return 0;
=20
-	if (vf_data->acc_magic !=3D ACC_DEV_MAGIC) {
+	ret =3D vf_qm_version_check(vf_data, dev);
+	if (ret) {
 		dev_err(dev, "failed to match ACC_DEV_MAGIC\n");
 		return -EINVAL;
 	}
@@ -418,7 +445,9 @@ static int vf_qm_get_match_data(struct hisi_acc_vf_core=
_device *hisi_acc_vdev,
 	int vf_id =3D hisi_acc_vdev->vf_id;
 	int ret;
=20
-	vf_data->acc_magic =3D ACC_DEV_MAGIC;
+	vf_data->acc_magic =3D ACC_DEV_MAGIC_V2;
+	vf_data->major_ver =3D ACC_DRV_MAJOR_VER;
+	vf_data->minor_ver =3D ACC_DRV_MINOR_VER;
 	/* Save device id */
 	vf_data->dev_id =3D hisi_acc_vdev->vf_dev->device;
=20
@@ -496,12 +525,12 @@ static int vf_qm_read_data(struct hisi_qm *vf_qm, str=
uct acc_vf_data *vf_data)
 		return -EINVAL;
=20
 	/* Every reg is 32 bit, the dma address is 64 bit. */
-	vf_data->eqe_dma =3D vf_data->qm_eqc_dw[1];
+	vf_data->eqe_dma =3D vf_data->qm_eqc_dw[QM_XQC_ADDR_HIGH];
 	vf_data->eqe_dma <<=3D QM_XQC_ADDR_OFFSET;
-	vf_data->eqe_dma |=3D vf_data->qm_eqc_dw[0];
-	vf_data->aeqe_dma =3D vf_data->qm_aeqc_dw[1];
+	vf_data->eqe_dma |=3D vf_data->qm_eqc_dw[QM_XQC_ADDR_LOW];
+	vf_data->aeqe_dma =3D vf_data->qm_aeqc_dw[QM_XQC_ADDR_HIGH];
 	vf_data->aeqe_dma <<=3D QM_XQC_ADDR_OFFSET;
-	vf_data->aeqe_dma |=3D vf_data->qm_aeqc_dw[0];
+	vf_data->aeqe_dma |=3D vf_data->qm_aeqc_dw[QM_XQC_ADDR_LOW];
=20
 	/* Through SQC_BT/CQC_BT to get sqc and cqc address */
 	ret =3D qm_get_sqc(vf_qm, &vf_data->sqc_dma);
diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h b/drivers/vfio/=
pci/hisilicon/hisi_acc_vfio_pci.h
index 245d7537b2bc..91002ceeebc1 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
@@ -39,6 +39,9 @@
 #define QM_REG_ADDR_OFFSET	0x0004
=20
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
=20
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
=20
 	/* QM RW regs */
 	u32 aeq_int_mask;
--=20
2.24.0


