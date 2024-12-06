Return-Path: <kvm+bounces-33206-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A230C9E6A75
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 10:37:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5AC5028AC3A
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 09:37:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5EB01F9AA0;
	Fri,  6 Dec 2024 09:36:46 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606EC1EF0B5;
	Fri,  6 Dec 2024 09:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733477806; cv=none; b=g15399XIMTH+lIGNEdUVMbvrSJfwOqZvZniaFgbRXqEtfheWXytlhFVRbEqluq/Yzsuv0uOc/TGNfxUZWstraodSvAi6qF+eHiuAf10T06IR1stEC/WfG0xaEbRzxFETIGp2tUSZstlFWLx+KtAMJ0AGJs3+4aK85pRVszuC88I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733477806; c=relaxed/simple;
	bh=f8+dIajzyYAPrZ4LmaSjXo5dzhdutroeMqfDZfR+H6s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VM237VUb2vhgQJuyvkMQyIRI2dLpZwKd2/kkGH2sfbUkInj1VooIJyPcb77rwzCY0Jp1LhGrfDgJi63JN1KN9BdOhIqMFPMBw9nAgkXPzfuydikhHfnImThwrgCI2ufM6Ngiqnos7gY/7nq5qVo1dDYeyt33pOcaCo51tMKJq3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Y4R0s5z4Vz11Pld;
	Fri,  6 Dec 2024 17:34:21 +0800 (CST)
Received: from dggemv711-chm.china.huawei.com (unknown [10.1.198.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 087C8140134;
	Fri,  6 Dec 2024 17:36:41 +0800 (CST)
Received: from kwepemn100017.china.huawei.com (7.202.194.122) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 6 Dec 2024 17:36:40 +0800
Received: from huawei.com (10.50.165.33) by kwepemn100017.china.huawei.com
 (7.202.194.122) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 6 Dec
 2024 17:36:40 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH 5/5] hisi_acc_vfio_pci: bugfix live migration function without VF device driver
Date: Fri, 6 Dec 2024 17:33:12 +0800
Message-ID: <20241206093312.57588-6-liulongfang@huawei.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20241206093312.57588-1-liulongfang@huawei.com>
References: <20241206093312.57588-1-liulongfang@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
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


