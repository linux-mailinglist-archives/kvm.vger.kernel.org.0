Return-Path: <kvm+bounces-34464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 18B2E9FF5AA
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 04:08:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1ACC53A290B
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 03:08:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C2CFDDD2;
	Thu,  2 Jan 2025 03:08:47 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C38C610D;
	Thu,  2 Jan 2025 03:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735787326; cv=none; b=lOXSbMhg6bA2URwiXNsgppKsUGJhBsqTp+An3nD3nvtZbQZg9EKTTPAsGP/WuzAznqrViuHE54Jc2FkrgUymzyeUIrXQc6ixNZVV5fa3qOAM2nSRpGkSwUYFoJrOszlg/WeGnbZcpabuhiLeeQF5pl+0OWmX0YQl1b8WgGDE7C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735787326; c=relaxed/simple;
	bh=FhH0L4DtIsOzYNWVKFla1ufGRuogZqBWRRFSxPZqhWU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mr8yQOLtxAWH6pvj2/lKI3LI73BowCkbcPD3hs4bY9lkBkTl5ABtARc8gihNNSkaBh4f6aOKYcq5UYimV8gUzLywN8hF9kO45GLWRQDjaOv0G+pMrohvDvkDHUI2HMwcspkujOOr/ek5731H5FIe/NoivM8i1uaBBDBDQkxYdgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4YNs5y5DWnz1kxZX;
	Thu,  2 Jan 2025 11:05:42 +0800 (CST)
Received: from dggemv711-chm.china.huawei.com (unknown [10.1.198.66])
	by mail.maildlp.com (Postfix) with ESMTPS id E693B180041;
	Thu,  2 Jan 2025 11:08:35 +0800 (CST)
Received: from kwepemn100017.china.huawei.com (7.202.194.122) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 2 Jan 2025 11:08:35 +0800
Received: from huawei.com (10.50.165.33) by kwepemn100017.china.huawei.com
 (7.202.194.122) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 2 Jan
 2025 11:08:35 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v3 2/5] hisi_acc_vfio_pci: add eq and aeq interruption restore
Date: Thu, 2 Jan 2025 11:07:26 +0800
Message-ID: <20250102030729.34115-3-liulongfang@huawei.com>
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
Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
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


