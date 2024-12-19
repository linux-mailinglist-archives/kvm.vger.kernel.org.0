Return-Path: <kvm+bounces-34128-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 05BE59F783C
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 10:21:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E9728164E3F
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 09:20:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0026422257E;
	Thu, 19 Dec 2024 09:20:18 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353E022147A;
	Thu, 19 Dec 2024 09:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734600017; cv=none; b=rddr34m3ydcJqvIKwtHAWCFrP03Wl6iaINgPyknEHE3uKY2QlXgyxcQUsF/qNnU7X8KcLfRsZjhekuxGgnrEfXAJ5oBBOD4KT9vwsUBfxA5+2X99SqUeTMWKD3GAv4sEZBiIdRELyKfBfdk+2kHZTN8zVHRABDx/5DHRUoZTtk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734600017; c=relaxed/simple;
	bh=3aOCMcExKSwPvRwWxBM/nVNwCKgoDEymiGzYRImEMac=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QkjbTuhwyMvYQ3Kfu8cBzeJ6ie7/1GkEFy8s/CyMxMscf3+rXQxsMejV2n9fHiL0cmVcPb0sxJJoEQUwwuFrePbaLWX5ylrgiVCVdhKUyQUjVHyEWYQOc8XwVOQK0TNLQvZRZFi73F9m093XK0r4EK0sFslClozHnEv1hCpquxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4YDQ1P5N1zz1sptf;
	Thu, 19 Dec 2024 17:17:29 +0800 (CST)
Received: from dggemv704-chm.china.huawei.com (unknown [10.3.19.47])
	by mail.maildlp.com (Postfix) with ESMTPS id 3E3591401E9;
	Thu, 19 Dec 2024 17:20:06 +0800 (CST)
Received: from kwepemn100017.china.huawei.com (7.202.194.122) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 19 Dec 2024 17:20:06 +0800
Received: from huawei.com (10.50.165.33) by kwepemn100017.china.huawei.com
 (7.202.194.122) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 19 Dec
 2024 17:20:05 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v2 2/5] hisi_acc_vfio_pci: add eq and aeq interruption restore
Date: Thu, 19 Dec 2024 17:17:57 +0800
Message-ID: <20241219091800.41462-3-liulongfang@huawei.com>
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
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemn100017.china.huawei.com (7.202.194.122)

In order to ensure that the task packets of the accelerator
device are not lost during the migration process, it is necessary
to send an EQ and AEQ command to the device after the live migration
is completed and to update the completion position of the task queue.

Let the device recheck the completed tasks data and if there are
uncollected packets, device resend a task completion interrupt
to the software.

Fixes:b0eed085903e("hisi_acc_vfio_pci: Add support for VFIO live migration")
Signed-off-by: Longfang Liu <liulongfang@huawei.com>
---
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index 8518efea3a52..4c8f1ae5b636 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -463,6 +463,19 @@ static int vf_qm_get_match_data(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 	return 0;
 }
 
+static void vf_qm_xeqc_save(struct hisi_qm *qm,
+			    struct hisi_acc_vf_migration_file *migf)
+{
+	struct acc_vf_data *vf_data = &migf->vf_data;
+	u16 eq_head, aeq_head;
+
+	eq_head = vf_data->qm_eqc_dw[0] & 0xFFFF;
+	qm_db(qm, 0, QM_DOORBELL_CMD_EQ, eq_head, 0);
+
+	aeq_head = vf_data->qm_aeqc_dw[0] & 0xFFFF;
+	qm_db(qm, 0, QM_DOORBELL_CMD_AEQ, aeq_head, 0);
+}
+
 static int vf_qm_load_data(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 			   struct hisi_acc_vf_migration_file *migf)
 {
@@ -571,6 +584,9 @@ static int vf_qm_state_save(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 		return -EINVAL;
 
 	migf->total_length = sizeof(struct acc_vf_data);
+	/* Save eqc and aeqc interrupt information */
+	vf_qm_xeqc_save(vf_qm, migf);
+
 	return 0;
 }
 
-- 
2.24.0


