Return-Path: <kvm+bounces-43134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C07D3A8525C
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 06:02:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8AA4C46892C
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 04:02:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0465327CCCC;
	Fri, 11 Apr 2025 04:02:14 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620D0279342;
	Fri, 11 Apr 2025 04:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744344133; cv=none; b=uKoXZ+rTDyTNA1jARUNJqSPGjvNHjSxVCMb+10hJb5Ylq2GQCJHLtnY+/ZqjVqj/JVZxFCV0bIMJ7+ZseNgv+9WGNh/vbfhazZqYQ6fModXBeMcMZ7Zs0izYf+mjiF6o/1r0VNBQOV9UCnUaFtZJFHnmcZYtLuPsAxE+I1EkeEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744344133; c=relaxed/simple;
	bh=kadHSvnHgTTxWB2kgSevoG/A3mXS+77jQRArLfz5qqQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uooLGqQX0T3Oie769Y+gUA1z49svm9SWKPBpFwaRkLkdXEDCgP/sr8UdT2hCJCgtlhROFNWFgUti62FYVwTJHC5KiFAZhujNfUcpIKThdZ+CVfMbS8WOQe49D4ZBR+7DXsoymhdl9wSf/dhEHzHuTd7+ianQQLnEEE0LZ1nzIlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4ZYjfY0RGHz1d1Bf;
	Fri, 11 Apr 2025 12:01:25 +0800 (CST)
Received: from kwepemg500006.china.huawei.com (unknown [7.202.181.43])
	by mail.maildlp.com (Postfix) with ESMTPS id 109021400CA;
	Fri, 11 Apr 2025 12:02:08 +0800 (CST)
Received: from huawei.com (10.50.165.33) by kwepemg500006.china.huawei.com
 (7.202.181.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 11 Apr
 2025 12:02:07 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v7 6/6] hisi_acc_vfio_pci: update function return values.
Date: Fri, 11 Apr 2025 11:59:07 +0800
Message-ID: <20250411035907.57488-7-liulongfang@huawei.com>
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
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemg500006.china.huawei.com (7.202.181.43)

In this driver file, many functions call sub-functions and use ret
to store the error code of the sub-functions.
However, instead of directly returning ret to the caller, they use a
converted error code, which prevents the end-user from clearly
understanding the root cause of the error.
Therefore, the code needs to be modified to directly return the error
code from the sub-functions.

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
---
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index d12a350440d3..c63e302ac092 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -392,7 +392,7 @@ static int vf_qm_check_match(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 	ret = vf_qm_version_check(vf_data, dev);
 	if (ret) {
 		dev_err(dev, "failed to match ACC_DEV_MAGIC\n");
-		return -EINVAL;
+		return ret;
 	}
 
 	if (vf_data->dev_id != hisi_acc_vdev->vf_dev->device) {
@@ -404,7 +404,7 @@ static int vf_qm_check_match(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 	ret = qm_get_vft(vf_qm, &vf_qm->qp_base);
 	if (ret <= 0) {
 		dev_err(dev, "failed to get vft qp nums\n");
-		return -EINVAL;
+		return ret;
 	}
 
 	if (ret != vf_data->qp_num) {
@@ -501,7 +501,7 @@ static int vf_qm_load_data(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 	ret = qm_write_regs(qm, QM_VF_STATE, &vf_data->vf_qm_state, 1);
 	if (ret) {
 		dev_err(dev, "failed to write QM_VF_STATE\n");
-		return -EINVAL;
+		return ret;
 	}
 	hisi_acc_vdev->vf_qm_state = vf_data->vf_qm_state;
 
@@ -542,7 +542,7 @@ static int vf_qm_read_data(struct hisi_qm *vf_qm, struct acc_vf_data *vf_data)
 
 	ret = qm_get_regs(vf_qm, vf_data);
 	if (ret)
-		return -EINVAL;
+		return ret;
 
 	/* Every reg is 32 bit, the dma address is 64 bit. */
 	vf_data->eqe_dma = vf_data->qm_eqc_dw[QM_XQC_ADDR_HIGH];
@@ -556,13 +556,13 @@ static int vf_qm_read_data(struct hisi_qm *vf_qm, struct acc_vf_data *vf_data)
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
@@ -588,7 +588,7 @@ static int vf_qm_state_save(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 
 	ret = vf_qm_read_data(vf_qm, vf_data);
 	if (ret)
-		return -EINVAL;
+		return ret;
 
 	migf->total_length = sizeof(struct acc_vf_data);
 	/* Save eqc and aeqc interrupt information */
@@ -1379,7 +1379,7 @@ static int hisi_acc_vf_debug_check(struct seq_file *seq, struct vfio_device *vde
 	ret = qm_wait_dev_not_ready(vf_qm);
 	if (ret) {
 		seq_puts(seq, "VF device not ready!\n");
-		return -EBUSY;
+		return ret;
 	}
 
 	return 0;
-- 
2.24.0


