Return-Path: <kvm+bounces-66979-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 574F9CF0B05
	for <lists+kvm@lfdr.de>; Sun, 04 Jan 2026 08:07:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B62BC30161ED
	for <lists+kvm@lfdr.de>; Sun,  4 Jan 2026 07:07:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CA352E9ED8;
	Sun,  4 Jan 2026 07:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="d2SZgZZN"
X-Original-To: kvm@vger.kernel.org
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951C72E6CDF;
	Sun,  4 Jan 2026 07:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767510464; cv=none; b=MJwkNom0jLty7b8kgENd82++FtrMb84fRlZRiqEYT4SB1swAlAbXqJTudNOKXkFBGaIK18AEhm2ja4QRZAIzSwYE8tQdVGf2uqohxd7zt6NGpK313PQpSyNcN+gCugcOLEvU31o+XH8X8Ja6opZA8YrWFLJVlWsmfcScLbkdUM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767510464; c=relaxed/simple;
	bh=1I9fiQQKn/r6ZMl9tMlG08CeECkvMyeglzDaCBSNhZA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lOiCTeBA54MgnjGYAViibIFUhNbhCLs9yYMo6I9kOHJlSsOQZefgcebj6UMTCq0qeiWMC82cc+07mIxRiB78cB8j7wfh845YrdrAIh+ncploVibur0ddbr/n0zLbxGqLPnG1IzwsWVfQSYZq2fDsCYWBHLdZux4RItJB7sbGi7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=d2SZgZZN; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=MY21NmVmBerMnxMn0j8Xq/Okw5AfIrPkLBbQSpUUHJk=;
	b=d2SZgZZNxZGChycuecwcXRguPDdTUHICmsEq8W7t8/YYhMqJqN/XSg9uCj5HG6cMks/Va4MxS
	Vccl+tFx4jCco/CA+nss2+SK/CEk/RuyFK7z3pJHktsptZNxd8bhvZmicBQCGkrE1aabYAZjrF6
	aGvQllv64GyyF57FsjQ4RNw=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4dkT233CDjz1K97Q;
	Sun,  4 Jan 2026 15:04:27 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id EC34C40565;
	Sun,  4 Jan 2026 15:07:38 +0800 (CST)
Received: from huawei.com (10.90.31.46) by dggpemf500015.china.huawei.com
 (7.185.36.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sun, 4 Jan
 2026 15:07:38 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<liulongfang@huawei.com>
Subject: [PATCH 1/4] hisi_acc_vfio_pci: fix VF reset timeout issue
Date: Sun, 4 Jan 2026 15:07:03 +0800
Message-ID: <20260104070706.4107994-2-liulongfang@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20260104070706.4107994-1-liulongfang@huawei.com>
References: <20260104070706.4107994-1-liulongfang@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf500015.china.huawei.com (7.185.36.143)

From: Weili Qian <qianweili@huawei.com>

If device error occurs during live migration, qemu will
reset the VF. At this time, VF reset and device reset are performed
simultaneously. The VF reset will timeout. Therefore, the QM_RESETTING
flag is used to ensure that VF reset and device reset are performed
serially.

Fixes: b0eed085903e ("hisi_acc_vfio_pci: Add support for VFIO live migration")
Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 24 +++++++++++++++++++
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  2 ++
 2 files changed, 26 insertions(+)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index fe2ffcd00d6e..d55365b21f78 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -1188,14 +1188,37 @@ hisi_acc_vfio_pci_get_device_state(struct vfio_device *vdev,
 	return 0;
 }
 
+static void hisi_acc_vf_pci_reset_prepare(struct pci_dev *pdev)
+{
+	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_drvdata(pdev);
+	struct hisi_qm *qm = hisi_acc_vdev->pf_qm;
+	struct device *dev = &qm->pdev->dev;
+	u32 delay = 0;
+
+	/* All reset requests need to be queued for processing */
+	while (test_and_set_bit(QM_RESETTING, &qm->misc_ctl)) {
+		msleep(1);
+		if (++delay > QM_RESET_WAIT_TIMEOUT) {
+			dev_err(dev, "reset prepare failed\n");
+			return;
+		}
+	}
+
+	hisi_acc_vdev->set_reset_flag = true;
+}
+
 static void hisi_acc_vf_pci_aer_reset_done(struct pci_dev *pdev)
 {
 	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_drvdata(pdev);
+	struct hisi_qm *qm = hisi_acc_vdev->pf_qm;
 
 	if (hisi_acc_vdev->core_device.vdev.migration_flags !=
 				VFIO_MIGRATION_STOP_COPY)
 		return;
 
+	if (hisi_acc_vdev->set_reset_flag)
+		clear_bit(QM_RESETTING, &qm->misc_ctl);
+
 	mutex_lock(&hisi_acc_vdev->state_mutex);
 	hisi_acc_vf_reset(hisi_acc_vdev);
 	mutex_unlock(&hisi_acc_vdev->state_mutex);
@@ -1746,6 +1769,7 @@ static const struct pci_device_id hisi_acc_vfio_pci_table[] = {
 MODULE_DEVICE_TABLE(pci, hisi_acc_vfio_pci_table);
 
 static const struct pci_error_handlers hisi_acc_vf_err_handlers = {
+	.reset_prepare = hisi_acc_vf_pci_reset_prepare,
 	.reset_done = hisi_acc_vf_pci_aer_reset_done,
 	.error_detected = vfio_pci_core_aer_err_detected,
 };
diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
index cd55eba64dfb..a3d91a31e3d8 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
@@ -27,6 +27,7 @@
 
 #define ERROR_CHECK_TIMEOUT		100
 #define CHECK_DELAY_TIME		100
+#define QM_RESET_WAIT_TIMEOUT  60000
 
 #define QM_SQC_VFT_BASE_SHIFT_V2	28
 #define QM_SQC_VFT_BASE_MASK_V2		GENMASK(15, 0)
@@ -128,6 +129,7 @@ struct hisi_acc_vf_migration_file {
 struct hisi_acc_vf_core_device {
 	struct vfio_pci_core_device core_device;
 	u8 match_done;
+	bool set_reset_flag;
 	/*
 	 * io_base is only valid when dev_opened is true,
 	 * which is protected by open_mutex.
-- 
2.24.0


