Return-Path: <kvm+bounces-46110-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5452AB221F
	for <lists+kvm@lfdr.de>; Sat, 10 May 2025 10:15:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AE98416BF98
	for <lists+kvm@lfdr.de>; Sat, 10 May 2025 08:15:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EA5C1EB5CB;
	Sat, 10 May 2025 08:15:06 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD4E1E9B0B;
	Sat, 10 May 2025 08:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746864905; cv=none; b=O2u1Zlqpn78Wn5yuGm8xKitenB0uCHc4NvwxhCRemtmvMEKoRUM6Ss9PlgYOFRjBnxffMiI7acXZ6iz2HOEfvs9Xf01skPnUrBrhb/kVCgStfRZzm7e+FoDs7pwZkzcRc1XBEGRV7sBfdvrEtCZyV16Elb8usqqgwiTNoH+O72o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746864905; c=relaxed/simple;
	bh=dkYYHw3JXtqYb0l7FvQRydGnN1GI1HNQqbs7a0Dklrg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VYS80kTsyHeGF99o3aNEU5GO4yU4lt1QKwFI1Id0RjSVr4lC8KL1h+HHjBaMp0xijBQPD24yv2UYXYGkj00gv0hKtOHf1YpbNaqHsDb+o+wNGMqom19+EBerR2N7g1shr/6j1w1hw1PeyYshQh5oDgXCebnLdVAKGBofVMJlDpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Zvdsw6bbQz13LV3;
	Sat, 10 May 2025 16:13:24 +0800 (CST)
Received: from kwepemg500006.china.huawei.com (unknown [7.202.181.43])
	by mail.maildlp.com (Postfix) with ESMTPS id D64E9180489;
	Sat, 10 May 2025 16:14:45 +0800 (CST)
Received: from huawei.com (10.50.165.33) by kwepemg500006.china.huawei.com
 (7.202.181.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sat, 10 May
 2025 16:14:45 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v8 5/6] hisi_acc_vfio_pci: bugfix live migration function without VF device driver
Date: Sat, 10 May 2025 16:11:54 +0800
Message-ID: <20250510081155.55840-6-liulongfang@huawei.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20250510081155.55840-1-liulongfang@huawei.com>
References: <20250510081155.55840-1-liulongfang@huawei.com>
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


