Return-Path: <kvm+bounces-29700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AC4169AFD96
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 11:04:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DDC7A1C25230
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 09:04:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD4071DD0C1;
	Fri, 25 Oct 2024 09:03:21 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBADE1D415C;
	Fri, 25 Oct 2024 09:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729847001; cv=none; b=IsktdRADo6VNUJ4nHeILPWe8ziPaiYEGSHuFwshl5HwD/0wVXPw8iPzWMBC5KCnDb1+MDtKF+IDFCNFRjpxE04P+JYbjQhS6KizYlf/RsYZciv45N+/+Csdl5dWHQ1RpXcEOt9NnClq3gMxrQ3BT1CD7RbeZPlAbRE1Z9zIMSqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729847001; c=relaxed/simple;
	bh=89zysdWO9QHwVicNvFBVQwWlrUkig269PlzLhTNYCVU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hY8t1AZVPoOgtogUKvLeLHU75pv8f/Rzc/LWr4vDI9SSLx/owJLMXfLdY8Oj1db70CHlKffOwnn8XT4Kj2TC4T/eTdCC+lKDxhOw1msrRfzOWuY8OLp25qAjrbWok4JD224oZsFxoOWwmNJU+ICvCbKGoOtlSwF8idPmqQNyE68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4XZcG06Q62zpXGH;
	Fri, 25 Oct 2024 17:01:12 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (unknown [7.193.23.191])
	by mail.maildlp.com (Postfix) with ESMTPS id 778651400E3;
	Fri, 25 Oct 2024 17:03:09 +0800 (CST)
Received: from huawei.com (10.50.165.33) by kwepemm600005.china.huawei.com
 (7.193.23.191) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Fri, 25 Oct
 2024 17:03:08 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v11 2/4] hisi_acc_vfio_pci: create subfunction for data reading
Date: Fri, 25 Oct 2024 17:01:41 +0800
Message-ID: <20241025090143.64472-3-liulongfang@huawei.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20241025090143.64472-1-liulongfang@huawei.com>
References: <20241025090143.64472-1-liulongfang@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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


