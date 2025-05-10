Return-Path: <kvm+bounces-46111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14F9EAB2221
	for <lists+kvm@lfdr.de>; Sat, 10 May 2025 10:15:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 21DD04E45AB
	for <lists+kvm@lfdr.de>; Sat, 10 May 2025 08:15:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48CE91EA7EB;
	Sat, 10 May 2025 08:15:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F3AF1E2853;
	Sat, 10 May 2025 08:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746864928; cv=none; b=YDVut6/AlivRMFbTncLU3qjSR6nGoSHUF+phJuPILvdtru92v8Y/Y+AlO1h+QepqPeD1Yz7tKErNyIxebvG6CB85sgJZE7OTkNXt8ABtzLg7KDDpanzXHkJr4j07g2S8cDM5qe6ltCjXTAyhdoUS1EDuCKyEOJ/y0HWmihoCsaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746864928; c=relaxed/simple;
	bh=VXGH4gHfoq5zBVBDrUGxQPKyMbZKpfTr9hgObAwt+ig=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lRQbbWaJ8xR228qw1ngbrnZfDqAtfUmYrzrXWmI0Mz6vGWwxYW8sPTFQZByU/6bPQ2RPQ/v3snZkFR1VEeMvvKKysKYrv9oKETfzim9IymqGjkicXaqfd5maZz8Yr/yzdHE0kPa6DpVCxWiwPogp8XrEnxPL4C2/si+qLBuKv5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Zvdwz2NPCz27hF3;
	Sat, 10 May 2025 16:16:03 +0800 (CST)
Received: from kwepemg500006.china.huawei.com (unknown [7.202.181.43])
	by mail.maildlp.com (Postfix) with ESMTPS id C95CA1800B1;
	Sat, 10 May 2025 16:15:16 +0800 (CST)
Received: from huawei.com (10.50.165.33) by kwepemg500006.china.huawei.com
 (7.202.181.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sat, 10 May
 2025 16:15:16 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v8 6/6] hisi_acc_vfio_pci: update function return values.
Date: Sat, 10 May 2025 16:11:55 +0800
Message-ID: <20250510081155.55840-7-liulongfang@huawei.com>
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
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemg500006.china.huawei.com (7.202.181.43)

In this driver file, many functions call sub-functions and use ret
to store the error code of the sub-functions.
However, instead of directly returning ret to the caller, they use a
converted error code, which prevents the end-user from clearly
understanding the root cause of the error.
Therefore, the code needs to be modified to directly return the error
code from the sub-functions.

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 29 ++++++++++---------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index d12a350440d3..2149f49aeec7 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -190,9 +190,10 @@ static int qm_set_regs(struct hisi_qm *qm, struct acc_vf_data *vf_data)
 	int ret;
 
 	/* Check VF state */
-	if (unlikely(hisi_qm_wait_mb_ready(qm))) {
+	ret = hisi_qm_wait_mb_ready(qm);
+	if (unlikely(ret)) {
 		dev_err(&qm->pdev->dev, "QM device is not ready to write\n");
-		return -EBUSY;
+		return ret;
 	}
 
 	ret = qm_write_regs(qm, QM_VF_AEQ_INT_MASK, &vf_data->aeq_int_mask, 1);
@@ -325,13 +326,15 @@ static void qm_dev_cmd_init(struct hisi_qm *qm)
 static int vf_qm_cache_wb(struct hisi_qm *qm)
 {
 	unsigned int val;
+	int ret;
 
 	writel(0x1, qm->io_base + QM_CACHE_WB_START);
-	if (readl_relaxed_poll_timeout(qm->io_base + QM_CACHE_WB_DONE,
+	ret = readl_relaxed_poll_timeout(qm->io_base + QM_CACHE_WB_DONE,
 				       val, val & BIT(0), MB_POLL_PERIOD_US,
-				       MB_POLL_TIMEOUT_US)) {
+				       MB_POLL_TIMEOUT_US);
+	if (ret) {
 		dev_err(&qm->pdev->dev, "vf QM writeback sqc cache fail\n");
-		return -EINVAL;
+		return ret;
 	}
 
 	return 0;
@@ -392,7 +395,7 @@ static int vf_qm_check_match(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 	ret = vf_qm_version_check(vf_data, dev);
 	if (ret) {
 		dev_err(dev, "failed to match ACC_DEV_MAGIC\n");
-		return -EINVAL;
+		return ret;
 	}
 
 	if (vf_data->dev_id != hisi_acc_vdev->vf_dev->device) {
@@ -404,7 +407,7 @@ static int vf_qm_check_match(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 	ret = qm_get_vft(vf_qm, &vf_qm->qp_base);
 	if (ret <= 0) {
 		dev_err(dev, "failed to get vft qp nums\n");
-		return -EINVAL;
+		return ret;
 	}
 
 	if (ret != vf_data->qp_num) {
@@ -501,7 +504,7 @@ static int vf_qm_load_data(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 	ret = qm_write_regs(qm, QM_VF_STATE, &vf_data->vf_qm_state, 1);
 	if (ret) {
 		dev_err(dev, "failed to write QM_VF_STATE\n");
-		return -EINVAL;
+		return ret;
 	}
 	hisi_acc_vdev->vf_qm_state = vf_data->vf_qm_state;
 
@@ -542,7 +545,7 @@ static int vf_qm_read_data(struct hisi_qm *vf_qm, struct acc_vf_data *vf_data)
 
 	ret = qm_get_regs(vf_qm, vf_data);
 	if (ret)
-		return -EINVAL;
+		return ret;
 
 	/* Every reg is 32 bit, the dma address is 64 bit. */
 	vf_data->eqe_dma = vf_data->qm_eqc_dw[QM_XQC_ADDR_HIGH];
@@ -556,13 +559,13 @@ static int vf_qm_read_data(struct hisi_qm *vf_qm, struct acc_vf_data *vf_data)
 	ret = qm_get_sqc(vf_qm, &vf_data->sqc_dma);
 	if (ret) {
 		dev_err(dev, "failed to read SQC addr!\n");
-		return -EINVAL;
+		return ret;
 	}
 
 	ret = qm_get_cqc(vf_qm, &vf_data->cqc_dma);
 	if (ret) {
 		dev_err(dev, "failed to read CQC addr!\n");
-		return -EINVAL;
+		return ret;
 	}
 
 	return 0;
@@ -588,7 +591,7 @@ static int vf_qm_state_save(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 
 	ret = vf_qm_read_data(vf_qm, vf_data);
 	if (ret)
-		return -EINVAL;
+		return ret;
 
 	migf->total_length = sizeof(struct acc_vf_data);
 	/* Save eqc and aeqc interrupt information */
@@ -1379,7 +1382,7 @@ static int hisi_acc_vf_debug_check(struct seq_file *seq, struct vfio_device *vde
 	ret = qm_wait_dev_not_ready(vf_qm);
 	if (ret) {
 		seq_puts(seq, "VF device not ready!\n");
-		return -EBUSY;
+		return ret;
 	}
 
 	return 0;
-- 
2.24.0


