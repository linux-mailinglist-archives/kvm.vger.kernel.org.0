Return-Path: <kvm+bounces-34467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B8869FF5B1
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 04:10:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 108433A34B9
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 03:10:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FA9EDDD2;
	Thu,  2 Jan 2025 03:10:22 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB289A927;
	Thu,  2 Jan 2025 03:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735787422; cv=none; b=Wu3A2Q9r8O0lcdTb098BFAeyf7FV7cWsz1JvOvszbNf/CDU69EqyqPLm7ES6JA18abhRCzapN5SNlnbxRoEFlis+hYz8foOHlhnvt/2okYPNyKknL5bpRf5kECTo4ERd1ouSTb/rt9zps7RbJB21xdPaM+6ZrlA129EcwpIcVK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735787422; c=relaxed/simple;
	bh=03UJRfDX7tBTTBTDbQpb7tK7rv9wTWIgwczy1nnuBwA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k5dL29FVO0z3P2pnj3MhsK8ZXhM2uFiCzLumGOOW/Ag1uFS2Nd2sKFb5C6yvw5/XYzO6DXeDCdppcpw6to8iHVy+D4Bc5hXX4/EanYjLKp+Pr+T2s4tI58CVnr4aX+1G5VfgtA0/FEjTxvozKPlYLxAjIdQCpVyi16XX7VkfRz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4YNs7r5Y2QzhZXG;
	Thu,  2 Jan 2025 11:07:20 +0800 (CST)
Received: from dggemv711-chm.china.huawei.com (unknown [10.1.198.66])
	by mail.maildlp.com (Postfix) with ESMTPS id C704C180106;
	Thu,  2 Jan 2025 11:10:08 +0800 (CST)
Received: from kwepemn100017.china.huawei.com (7.202.194.122) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 2 Jan 2025 11:10:08 +0800
Received: from huawei.com (10.50.165.33) by kwepemn100017.china.huawei.com
 (7.202.194.122) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 2 Jan
 2025 11:10:08 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v3 5/5] hisi_acc_vfio_pci: bugfix live migration function without VF device driver
Date: Thu, 2 Jan 2025 11:07:29 +0800
Message-ID: <20250102030729.34115-6-liulongfang@huawei.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20250102030729.34115-1-liulongfang@huawei.com>
References: <20250102030729.34115-1-liulongfang@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemn100017.china.huawei.com (7.202.194.122)

If the driver of the VF device is not loaded in the Guest OS,
then perform device data migration. The migrated data address will
be NULL.
The live migration recovery operation on the destination side will
access a null address value, which will cause access errors.

Therefore, live migration of VMs without added VF device drivers
does not require device data migration.
In addition, when the queue address data obtained by the destination
is empty, device queue recovery processing will not be performed.

Fixes:b0eed085903e("hisi_acc_vfio_pci: Add support for VFIO live migration")
Signed-off-by: Longfang Liu <liulongfang@huawei.com>
---
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index 8d9e07ebf4fd..9a5f7e9bc695 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -436,6 +436,7 @@ static int vf_qm_get_match_data(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 				struct acc_vf_data *vf_data)
 {
 	struct hisi_qm *pf_qm = hisi_acc_vdev->pf_qm;
+	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
 	struct device *dev = &pf_qm->pdev->dev;
 	int vf_id = hisi_acc_vdev->vf_id;
 	int ret;
@@ -460,6 +461,13 @@ static int vf_qm_get_match_data(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 		return ret;
 	}
 
+	/* Get VF driver insmod state */
+	ret = qm_read_regs(vf_qm, QM_VF_STATE, &vf_data->vf_qm_state, 1);
+	if (ret) {
+		dev_err(dev, "failed to read QM_VF_STATE!\n");
+		return ret;
+	}
+
 	return 0;
 }
 
@@ -499,6 +507,12 @@ static int vf_qm_load_data(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 	qm->qp_base = vf_data->qp_base;
 	qm->qp_num = vf_data->qp_num;
 
+	if (!vf_data->eqe_dma || !vf_data->aeqe_dma ||
+	    !vf_data->sqc_dma || !vf_data->cqc_dma) {
+		dev_err(dev, "resume dma addr is NULL!\n");
+		return -EINVAL;
+	}
+
 	ret = qm_set_regs(qm, vf_data);
 	if (ret) {
 		dev_err(dev, "set VF regs failed\n");
@@ -721,6 +735,9 @@ static int hisi_acc_vf_load_state(struct hisi_acc_vf_core_device *hisi_acc_vdev)
 	struct hisi_acc_vf_migration_file *migf = hisi_acc_vdev->resuming_migf;
 	int ret;
 
+	if (hisi_acc_vdev->vf_qm_state != QM_READY)
+		return 0;
+
 	/* Recover data to VF */
 	ret = vf_qm_load_data(hisi_acc_vdev, migf);
 	if (ret) {
@@ -1524,6 +1541,7 @@ static int hisi_acc_vfio_pci_migrn_init_dev(struct vfio_device *core_vdev)
 	hisi_acc_vdev->vf_id = pci_iov_vf_id(pdev) + 1;
 	hisi_acc_vdev->pf_qm = pf_qm;
 	hisi_acc_vdev->vf_dev = pdev;
+	hisi_acc_vdev->vf_qm_state = QM_NOT_READY;
 	mutex_init(&hisi_acc_vdev->state_mutex);
 	mutex_init(&hisi_acc_vdev->open_mutex);
 
-- 
2.24.0


