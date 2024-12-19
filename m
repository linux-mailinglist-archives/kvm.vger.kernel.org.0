Return-Path: <kvm+bounces-34131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A97F9F78A2
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 10:38:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E0B07166BA7
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 09:38:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25B57221D99;
	Thu, 19 Dec 2024 09:38:32 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D401FCCFF;
	Thu, 19 Dec 2024 09:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734601111; cv=none; b=T2l/sXLzR8U+h4xM6vtB/Y5NXsPjvzfFKGcdz0scnjs6EZAPt/G9pYK4SFdhVx2nRrrSh0nJKfleqex00EUWYUp15PK64tygLuj/v9IXmfIz1Hgn1RcJRdYFkSVEhfotr4z0GAmrsUN2+QCEmpKaiw+vcEA7Krf0F802uCho3jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734601111; c=relaxed/simple;
	bh=f8+dIajzyYAPrZ4LmaSjXo5dzhdutroeMqfDZfR+H6s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SPDznf89z3PMIvmtVbU5XuYY3Uiyxf6J7d6r3njNOM23STB8qhb/Y2q5f/o0+kbjSSgXNcUV8EtAPDb4vZsWRFG5U0j7Vl5TGjatKoS4FGzliaBssDdGK8R6GeHJJ1bxHuiS/JCG31GoveB6wUt4l6YgXI3TRy2Haa2KKblAPCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4YDQ2R1Yqlz16Pht;
	Thu, 19 Dec 2024 17:18:23 +0800 (CST)
Received: from dggemv704-chm.china.huawei.com (unknown [10.3.19.47])
	by mail.maildlp.com (Postfix) with ESMTPS id 206511400CA;
	Thu, 19 Dec 2024 17:21:39 +0800 (CST)
Received: from kwepemn100017.china.huawei.com (7.202.194.122) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 19 Dec 2024 17:21:38 +0800
Received: from huawei.com (10.50.165.33) by kwepemn100017.china.huawei.com
 (7.202.194.122) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 19 Dec
 2024 17:21:38 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v2 5/5] hisi_acc_vfio_pci: bugfix live migration function without VF device driver
Date: Thu, 19 Dec 2024 17:18:00 +0800
Message-ID: <20241219091800.41462-6-liulongfang@huawei.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20241219091800.41462-1-liulongfang@huawei.com>
References: <20241219091800.41462-1-liulongfang@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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


