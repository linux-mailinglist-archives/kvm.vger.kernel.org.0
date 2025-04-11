Return-Path: <kvm+bounces-43133-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C77A5A85258
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 06:01:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EAE569A1B46
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 04:01:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFABB27CB31;
	Fri, 11 Apr 2025 04:01:43 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED62A279326;
	Fri, 11 Apr 2025 04:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744344103; cv=none; b=ufWqoDlLJIByWRFCPVTMaAfACGk0YtkrCn+cn/KvFHbqOW00xAXtAdu5BdeCSBbh4ZZ4J6Jxsv4opEjDWyi6h/Y5WsoP+POM6/g852WBkW06PGvFTGNmt/jVhQSvUXuvTDV352XlMmlHiXbL1hQ+7AUTPPaXPiridsSHVa+amIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744344103; c=relaxed/simple;
	bh=dkYYHw3JXtqYb0l7FvQRydGnN1GI1HNQqbs7a0Dklrg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s2ZehOIE37PmPbadt6wV0E1qYHVDljxDMIbsNWeGgNeVkYnJ/KEJpCN8yCItixlalsWZyIyhohATWPMKo6HWQmlyGc2xgrm+ZhoGmksqob60fpmL7weudyqzbkAiHUR2CdkOuh5LdNGt5T4e40Sye4j0aHpuOKiQAcb+7fdQzrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4ZYjdy0bMpz1d0rc;
	Fri, 11 Apr 2025 12:00:54 +0800 (CST)
Received: from kwepemg500006.china.huawei.com (unknown [7.202.181.43])
	by mail.maildlp.com (Postfix) with ESMTPS id 15524140132;
	Fri, 11 Apr 2025 12:01:37 +0800 (CST)
Received: from huawei.com (10.50.165.33) by kwepemg500006.china.huawei.com
 (7.202.181.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 11 Apr
 2025 12:01:36 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v7 5/6] hisi_acc_vfio_pci: bugfix live migration function without VF device driver
Date: Fri, 11 Apr 2025 11:59:06 +0800
Message-ID: <20250411035907.57488-6-liulongfang@huawei.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20250411035907.57488-1-liulongfang@huawei.com>
References: <20250411035907.57488-1-liulongfang@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemg500006.china.huawei.com (7.202.181.43)

If the VF device driver is not loaded in the Guest OS and we attempt to
perform device data migration, the address of the migrated data will
be NULL.
The live migration recovery operation on the destination side will
access a null address value, which will cause access errors.

Therefore, live migration of VMs without added VF device drivers
does not require device data migration.
In addition, when the queue address data obtained by the destination
is empty, device queue recovery processing will not be performed.

Fixes: b0eed085903e ("hisi_acc_vfio_pci: Add support for VFIO live migration")
Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 22 +++++++++++++------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index cadc82419dca..d12a350440d3 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -426,13 +426,6 @@ static int vf_qm_check_match(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 		return -EINVAL;
 	}
 
-	ret = qm_write_regs(vf_qm, QM_VF_STATE, &vf_data->vf_qm_state, 1);
-	if (ret) {
-		dev_err(dev, "failed to write QM_VF_STATE\n");
-		return ret;
-	}
-
-	hisi_acc_vdev->vf_qm_state = vf_data->vf_qm_state;
 	hisi_acc_vdev->match_done = true;
 	return 0;
 }
@@ -498,6 +491,20 @@ static int vf_qm_load_data(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 	if (migf->total_length < sizeof(struct acc_vf_data))
 		return -EINVAL;
 
+	if (!vf_data->eqe_dma || !vf_data->aeqe_dma ||
+	    !vf_data->sqc_dma || !vf_data->cqc_dma) {
+		dev_info(dev, "resume dma addr is NULL!\n");
+		hisi_acc_vdev->vf_qm_state = QM_NOT_READY;
+		return 0;
+	}
+
+	ret = qm_write_regs(qm, QM_VF_STATE, &vf_data->vf_qm_state, 1);
+	if (ret) {
+		dev_err(dev, "failed to write QM_VF_STATE\n");
+		return -EINVAL;
+	}
+	hisi_acc_vdev->vf_qm_state = vf_data->vf_qm_state;
+
 	qm->eqe_dma = vf_data->eqe_dma;
 	qm->aeqe_dma = vf_data->aeqe_dma;
 	qm->sqc_dma = vf_data->sqc_dma;
@@ -1531,6 +1538,7 @@ static int hisi_acc_vfio_pci_migrn_init_dev(struct vfio_device *core_vdev)
 	hisi_acc_vdev->vf_id = pci_iov_vf_id(pdev) + 1;
 	hisi_acc_vdev->pf_qm = pf_qm;
 	hisi_acc_vdev->vf_dev = pdev;
+	hisi_acc_vdev->vf_qm_state = QM_NOT_READY;
 	mutex_init(&hisi_acc_vdev->state_mutex);
 	mutex_init(&hisi_acc_vdev->open_mutex);
 
-- 
2.24.0


