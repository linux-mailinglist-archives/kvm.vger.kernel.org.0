Return-Path: <kvm+bounces-43131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19470A85256
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 06:01:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E22667AF76F
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 03:59:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04FB527CB3D;
	Fri, 11 Apr 2025 04:00:46 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E2D1624D0;
	Fri, 11 Apr 2025 04:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744344045; cv=none; b=D14JPuUm0dbnuMxxZHa+MmoNyi2yg3uyGL7HN0MjHFm3XTxAJBACzEWgQIFONR/Y8WF5uF5OWuxVQ9A/ttKsPTvH2BjWzeYPU5EwgHXnGZKrqq+oTDVeRlbRm5Oi/v5Z0mHofhhX3fTfapYcsG/ZWis26WG6ShFRDN9iFdK7GuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744344045; c=relaxed/simple;
	bh=3IozYO/eR/kQuw7+sST29tdLq1X0HD/pbb+i53spYM0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EqdmZawSOpZwoYYMCmwNMAk94mNguYPMLtCv1KN5L+5mDFyZmFw6eKcmVRt7875wyGuIu0j0UOPy89f+/OjTwBD4oVJvIH5OBJ6eHXVI6eaM+xGFX+HbmppLHA8Zve8dBaBPYaxqedJ4pDffESeiIuxF9xaZBJgg7chXz5r0a0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4ZYjbz5FFLznfdb;
	Fri, 11 Apr 2025 11:59:11 +0800 (CST)
Received: from kwepemg500006.china.huawei.com (unknown [7.202.181.43])
	by mail.maildlp.com (Postfix) with ESMTPS id 2F14C180B4A;
	Fri, 11 Apr 2025 12:00:35 +0800 (CST)
Received: from huawei.com (10.50.165.33) by kwepemg500006.china.huawei.com
 (7.202.181.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 11 Apr
 2025 12:00:34 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v7 3/6] hisi_acc_vfio_pci: bugfix cache write-back issue
Date: Fri, 11 Apr 2025 11:59:04 +0800
Message-ID: <20250411035907.57488-4-liulongfang@huawei.com>
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
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemg500006.china.huawei.com (7.202.181.43)

At present, cache write-back is placed in the device data
copy stage after stopping the device operation.
Writing back to the cache at this stage will cause the data
obtained by the cache to be written back to be empty.

In order to ensure that the cache data is written back
successfully, the data needs to be written back into the
stop device stage.

Fixes: b0eed085903e ("hisi_acc_vfio_pci: Add support for VFIO live migration")
Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index 80217aea5475..d96446f499ed 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -566,7 +566,6 @@ static int vf_qm_state_save(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 {
 	struct acc_vf_data *vf_data = &migf->vf_data;
 	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
-	struct device *dev = &vf_qm->pdev->dev;
 	int ret;
 
 	if (unlikely(qm_wait_dev_not_ready(vf_qm))) {
@@ -580,12 +579,6 @@ static int vf_qm_state_save(struct hisi_acc_vf_core_device *hisi_acc_vdev,
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
@@ -1012,6 +1005,13 @@ static int hisi_acc_vf_stop_device(struct hisi_acc_vf_core_device *hisi_acc_vdev
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


