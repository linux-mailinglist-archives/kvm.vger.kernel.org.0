Return-Path: <kvm+bounces-39088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E966A43541
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 07:30:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 237353B7AE4
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 06:30:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37249257AD8;
	Tue, 25 Feb 2025 06:29:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9199E256C9A;
	Tue, 25 Feb 2025 06:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740464967; cv=none; b=a9Fo2hBdNv9p2+jzRvq+8KPNnmYHgolztqR6ApSwbWpWMegHjucerj9Q8jftC9APlgdcOVs707bj9LTSloV5hTOkswFb6GCYQjEojXqOGetYdyMx+N8Q+froo8JJyWlzMw/H8HlgAcAPKRfOyIeA0LQA/RnBE7qCop9vSaOoi24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740464967; c=relaxed/simple;
	bh=pn5qt+qjSMOk2Lz6y1NpX3BN+oBw7D7B45eJPKSGXEg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iTJN8znSylY0VRpgnx/KWduU/fL1Xgsau4mUKbRadVrpW9ieqxpHac4LV5GZJ3B2UW1P6j6/aYWOxsgL66IAw7QBRQ4QZHjZR3wOv9H8NF2bZ6ZyAvxtkfaLmUToOJNe/URESAw0UE1obeRZZsaj+yoYUjBvL8fmUI7LiK9kSOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Z26yb0LjyzdbB5;
	Tue, 25 Feb 2025 14:24:39 +0800 (CST)
Received: from kwepemg500006.china.huawei.com (unknown [7.202.181.43])
	by mail.maildlp.com (Postfix) with ESMTPS id E0B3C140203;
	Tue, 25 Feb 2025 14:29:22 +0800 (CST)
Received: from huawei.com (10.50.165.33) by kwepemg500006.china.huawei.com
 (7.202.181.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 25 Feb
 2025 14:29:22 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v4 3/5] hisi_acc_vfio_pci: bugfix cache write-back issue
Date: Tue, 25 Feb 2025 14:27:55 +0800
Message-ID: <20250225062757.19692-4-liulongfang@huawei.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20250225062757.19692-1-liulongfang@huawei.com>
References: <20250225062757.19692-1-liulongfang@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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
index 235b584e7335..54c59c92df13 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -565,7 +565,6 @@ static int vf_qm_state_save(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 {
 	struct acc_vf_data *vf_data = &migf->vf_data;
 	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
-	struct device *dev = &vf_qm->pdev->dev;
 	int ret;
 
 	if (unlikely(qm_wait_dev_not_ready(vf_qm))) {
@@ -579,12 +578,6 @@ static int vf_qm_state_save(struct hisi_acc_vf_core_device *hisi_acc_vdev,
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
@@ -1011,6 +1004,13 @@ static int hisi_acc_vf_stop_device(struct hisi_acc_vf_core_device *hisi_acc_vdev
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


