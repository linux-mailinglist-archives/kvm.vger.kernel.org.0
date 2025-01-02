Return-Path: <kvm+bounces-34465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 107B29FF5AC
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 04:09:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D7F203A296F
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 03:09:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0ECB5DF49;
	Thu,  2 Jan 2025 03:09:18 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B3DB652;
	Thu,  2 Jan 2025 03:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735787357; cv=none; b=LIDycFVpwZWt2Kh0nr+CFsv25F/PfY/vBpM8//bQVF6ezR0K5JCBTQfeN/24wGUUIuk7u6EZr1ObWjzZ/YcWltFfYsFBqVUVRNgCuPubtxESAHybTuPu/1lrRi9sLfs8D4/lxxOIYpHGvkSbkzgIphY9PE5x7Zm+OSjJ46D6pFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735787357; c=relaxed/simple;
	bh=Pg8L30lq/NkgbHqyt/NECpFAklf7/zec18VgJCgT7Hw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CRqUyhGojBT84DXwXVOj6SmkiqL0EDW5moZwXPjtU8+YISM4ipYmwqJsH6goSzIQ34eu8Tiqll4OgRSLHg8zVEYZ2BZNcHBnNa2nGVbd8HYhxigFDF7YjfqbOCoiYffsyE7R/97yIpFP4daRiIkSv2h6hKDYXxHOTrp+xpkh8TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4YNs5n1NZZz1W3LP;
	Thu,  2 Jan 2025 11:05:33 +0800 (CST)
Received: from dggemv704-chm.china.huawei.com (unknown [10.3.19.47])
	by mail.maildlp.com (Postfix) with ESMTPS id D196C18010B;
	Thu,  2 Jan 2025 11:09:06 +0800 (CST)
Received: from kwepemn100017.china.huawei.com (7.202.194.122) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 2 Jan 2025 11:09:06 +0800
Received: from huawei.com (10.50.165.33) by kwepemn100017.china.huawei.com
 (7.202.194.122) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 2 Jan
 2025 11:09:06 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v3 3/5] hisi_acc_vfio_pci: bugfix cache write-back issue
Date: Thu, 2 Jan 2025 11:07:27 +0800
Message-ID: <20250102030729.34115-4-liulongfang@huawei.com>
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
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemn100017.china.huawei.com (7.202.194.122)

At present, cache write-back is placed in the device data
copy stage after stopping the device operation.
Writing back to the cache at this stage will cause the data
obtained by the cache to be written back to be empty.

In order to ensure that the cache data is written back
successfully, the data needs to be written back into the
stop device stage.

Fixes:b0eed085903e("hisi_acc_vfio_pci: Add support for VFIO live migration")
Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index 4c8f1ae5b636..c057c0e24693 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -559,7 +559,6 @@ static int vf_qm_state_save(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 {
 	struct acc_vf_data *vf_data = &migf->vf_data;
 	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
-	struct device *dev = &vf_qm->pdev->dev;
 	int ret;
 
 	if (unlikely(qm_wait_dev_not_ready(vf_qm))) {
@@ -573,12 +572,6 @@ static int vf_qm_state_save(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 	vf_data->vf_qm_state = QM_READY;
 	hisi_acc_vdev->vf_qm_state = vf_data->vf_qm_state;
 
-	ret = vf_qm_cache_wb(vf_qm);
-	if (ret) {
-		dev_err(dev, "failed to writeback QM Cache!\n");
-		return ret;
-	}
-
 	ret = vf_qm_read_data(vf_qm, vf_data);
 	if (ret)
 		return -EINVAL;
@@ -1005,6 +998,13 @@ static int hisi_acc_vf_stop_device(struct hisi_acc_vf_core_device *hisi_acc_vdev
 		dev_err(dev, "failed to check QM INT state!\n");
 		return ret;
 	}
+
+	ret = vf_qm_cache_wb(vf_qm);
+	if (ret) {
+		dev_err(dev, "failed to writeback QM cache!\n");
+		return ret;
+	}
+
 	return 0;
 }
 
-- 
2.24.0


