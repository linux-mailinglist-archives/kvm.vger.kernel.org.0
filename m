Return-Path: <kvm+bounces-11264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD3728747E9
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 07:09:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 34CAE287809
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 06:09:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5FEB1BF58;
	Thu,  7 Mar 2024 06:09:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354FA1BDED;
	Thu,  7 Mar 2024 06:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709791768; cv=none; b=FmBQWXKNVLt4vbRlzWOg2RlsFbfFT9jBc4Cn2gKteCrsNNqmwxEH3AK/mzxe3yHP/b1aeK8Pmmrc1kP1KrLZEHEunE9TIOWDhf0+0cWoKWoMKuOoAJfTdLyUpEJflDfBl+jrZiZ8/eWO07GnH4rJfp4JohjxaoEsU+g5+mkGnF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709791768; c=relaxed/simple;
	bh=dimXEiaO2oBHfWr6n9+6kktbMz4JPa8H1hZm1YRrlZ4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J2tZYQlnrxDuj0NH7Y/cbm1AjHyIK3UB6FGgew9beQ6oCEZHIp6mDoAcizID5ZIT+Le415rQ3/oclMvMIhFb+WQYySQdkQ7Is3C+OCsOWH6N5bXnNYKCIZOqhc35QhVBT0ZymxxKPKwA5EmiewFJ4DDT8ZdlJsUtEHQtYhfTQmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4TqzQg10j5z1FLvD;
	Thu,  7 Mar 2024 14:09:15 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (unknown [7.193.23.191])
	by mail.maildlp.com (Postfix) with ESMTPS id 20C0F1402CA;
	Thu,  7 Mar 2024 14:09:24 +0800 (CST)
Received: from huawei.com (10.50.165.33) by kwepemm600005.china.huawei.com
 (7.193.23.191) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Thu, 7 Mar
 2024 14:09:23 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v3 2/4] hisi_acc_vfio_pci: Create subfunction for data reading
Date: Thu, 7 Mar 2024 14:03:51 +0800
Message-ID: <20240307060353.16095-3-liulongfang@huawei.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20240307060353.16095-1-liulongfang@huawei.com>
References: <20240307060353.16095-1-liulongfang@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600005.china.huawei.com (7.193.23.191)

During the live migration process. It needs to obtain various status
data of drivers and devices. In order to facilitate calling it in the
debugfs function. For all operations that read data from device registers,
the driver creates a subfunction.
Also fixed the location of address data.

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
---
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 55 ++++++++++---------
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  3 +
 2 files changed, 33 insertions(+), 25 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index 45351be8e270..1881f3fa9266 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -486,42 +486,22 @@ static int vf_qm_load_data(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 	return 0;
 }
 
-static int vf_qm_state_save(struct hisi_acc_vf_core_device *hisi_acc_vdev,
-			    struct hisi_acc_vf_migration_file *migf)
+static int vf_qm_read_data(struct hisi_qm *vf_qm, struct acc_vf_data *vf_data)
 {
-	struct acc_vf_data *vf_data = &migf->vf_data;
-	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
 	struct device *dev = &vf_qm->pdev->dev;
 	int ret;
 
-	if (unlikely(qm_wait_dev_not_ready(vf_qm))) {
-		/* Update state and return with match data */
-		vf_data->vf_qm_state = QM_NOT_READY;
-		hisi_acc_vdev->vf_qm_state = vf_data->vf_qm_state;
-		migf->total_length = QM_MATCH_SIZE;
-		return 0;
-	}
-
-	vf_data->vf_qm_state = QM_READY;
-	hisi_acc_vdev->vf_qm_state = vf_data->vf_qm_state;
-
-	ret = vf_qm_cache_wb(vf_qm);
-	if (ret) {
-		dev_err(dev, "failed to writeback QM Cache!\n");
-		return ret;
-	}
-
 	ret = qm_get_regs(vf_qm, vf_data);
 	if (ret)
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
@@ -536,6 +516,31 @@ static int vf_qm_state_save(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 		return -EINVAL;
 	}
 
+	return 0;
+}
+
+static int vf_qm_state_save(struct hisi_acc_vf_core_device *hisi_acc_vdev,
+			    struct hisi_acc_vf_migration_file *migf)
+{
+	struct acc_vf_data *vf_data = &migf->vf_data;
+	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
+	int ret;
+
+	if (unlikely(qm_wait_dev_not_ready(vf_qm))) {
+		/* Update state and return with match data */
+		vf_data->vf_qm_state = QM_NOT_READY;
+		hisi_acc_vdev->vf_qm_state = vf_data->vf_qm_state;
+		migf->total_length = QM_MATCH_SIZE;
+		return 0;
+	}
+
+	vf_data->vf_qm_state = QM_READY;
+	hisi_acc_vdev->vf_qm_state = vf_data->vf_qm_state;
+
+	ret = vf_qm_read_data(vf_qm, vf_data);
+	if (ret)
+		return -EINVAL;
+
 	migf->total_length = sizeof(struct acc_vf_data);
 	return 0;
 }
diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
index 5bab46602fad..7a9dc87627cd 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
@@ -38,6 +38,9 @@
 #define QM_REG_ADDR_OFFSET	0x0004
 
 #define QM_XQC_ADDR_OFFSET	32U
+#define QM_XQC_ADDR_LOW		0x1
+#define QM_XQC_ADDR_HIGH	0x2
+
 #define QM_VF_AEQ_INT_MASK	0x0004
 #define QM_VF_EQ_INT_MASK	0x000c
 #define QM_IFC_INT_SOURCE_V	0x0020
-- 
2.24.0


