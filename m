Return-Path: <kvm+bounces-28965-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CD3099FE32
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 03:24:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE9521C24429
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 01:24:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B543D136352;
	Wed, 16 Oct 2024 01:24:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7745A28EA;
	Wed, 16 Oct 2024 01:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729041873; cv=none; b=OEUs6GhKoLnaJBF1HACMA0kdYbSLXLQZzhA/+dpjmzZ2hIZYJP9aaNdz3FMPrUpgGees7WmRt878/ywehElcgXx/1Z8w4FRykswAr2NGiA5m0AwFM29Y2VR8dUug16GfRapsnhvWzQtjfKLeqFG3ULjoYvOGU24x6fuMnTlRaeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729041873; c=relaxed/simple;
	bh=89zysdWO9QHwVicNvFBVQwWlrUkig269PlzLhTNYCVU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RV0Wz1rrQAk4JyAs1VUWaiOLitx7O3AYtygd1k2zHRnz8dmjFsgzRxowNkI2cMqeNXZDyXv7d1BOdCyj28H061jjxxt92oic9ckAGpLK097BFTNRkkmOZdoDNKQlok1QsRlI1n7M6FPUS1r8GB4e3P0uMddPlNaXNfdvoSYwXGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4XStWX3pl8zyTM8;
	Wed, 16 Oct 2024 09:23:04 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (unknown [7.193.23.191])
	by mail.maildlp.com (Postfix) with ESMTPS id 052FB1401E0;
	Wed, 16 Oct 2024 09:24:28 +0800 (CST)
Received: from huawei.com (10.50.165.33) by kwepemm600005.china.huawei.com
 (7.193.23.191) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 16 Oct
 2024 09:24:27 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v10 2/4] hisi_acc_vfio_pci: create subfunction for data reading
Date: Wed, 16 Oct 2024 09:23:06 +0800
Message-ID: <20241016012308.14108-3-liulongfang@huawei.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20241016012308.14108-1-liulongfang@huawei.com>
References: <20241016012308.14108-1-liulongfang@huawei.com>
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

This patch generates the code for the operation of reading data from
the device into a sub-function.
Then, it can be called during the device status data saving phase of
the live migration process and the device status data reading function
in debugfs.
Thereby reducing the redundant code of the driver.

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 54 +++++++++++--------
 1 file changed, 33 insertions(+), 21 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index 45351be8e270..a8c53952d82e 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -486,31 +486,11 @@ static int vf_qm_load_data(struct hisi_acc_vf_core_device *hisi_acc_vdev,
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
@@ -536,6 +516,38 @@ static int vf_qm_state_save(struct hisi_acc_vf_core_device *hisi_acc_vdev,
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
+	struct device *dev = &vf_qm->pdev->dev;
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
+	ret = vf_qm_cache_wb(vf_qm);
+	if (ret) {
+		dev_err(dev, "failed to writeback QM Cache!\n");
+		return ret;
+	}
+
+	ret = vf_qm_read_data(vf_qm, vf_data);
+	if (ret)
+		return -EINVAL;
+
 	migf->total_length = sizeof(struct acc_vf_data);
 	return 0;
 }
-- 
2.24.0


