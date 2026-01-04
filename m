Return-Path: <kvm+bounces-66982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 17434CF0B1D
	for <lists+kvm@lfdr.de>; Sun, 04 Jan 2026 08:09:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 25F54301E1BF
	for <lists+kvm@lfdr.de>; Sun,  4 Jan 2026 07:09:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBD792DC339;
	Sun,  4 Jan 2026 07:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="mnh0jAwI"
X-Original-To: kvm@vger.kernel.org
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8261EEA55;
	Sun,  4 Jan 2026 07:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767510564; cv=none; b=pcQVLQ/4K02XLJWgWqGw1qx2LCS6e/UVsZ1pu0v6sCIjHxfKGnxLCW/6VHL6qSHp02JjZi67YeyZ4KUPDKDyNVx9MbhroA3Dg7qZuRLEPjQqTVPfuHx2U9XkGmHuiYljhGK+KJWFwbfIqG88r5ZjzR34rZTYHEm7+fGfxW1Lcgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767510564; c=relaxed/simple;
	bh=yo4s7tNHJPYzEeNHy5USwxfrEjAlLe8Wyca+9lI7Sqw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eZ6Wm/XdsDJ9jSk23jwgN8o7UbU6DmFwDBSoUpq/tzQbpxMeroSHRS2S7Vp+hAfZgnopP3nb+aLkZ5YYbIfxeVdD0WhlurSnTL0LxkgWmUnf47jTgdcZB8G4cawQxXUAim9fgAT4rZANFy/msei1ibptYRw8GbO2qlRpN9lbXzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=mnh0jAwI; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=K2Rn//20dzEeCrYi224axDNWkg8lyp1rwlU1LUEqigs=;
	b=mnh0jAwINorMSexBIwFFbSXeqPdFInVDb361qn3sdmeEYOD6BVMfbYkoKTgME86dMxHac8148
	GxkRD8lHUM8KtrN0S29mzljWtv4Iu6l4f+UWiMa/6w5Bkkh0YFV6iRS+Qpq6bRTDM98lqcJQkV6
	M+3j7MBTci0cnfCFRO12EmE=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4dkT3Z40r9zcZxv;
	Sun,  4 Jan 2026 15:05:46 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id B9C0540569;
	Sun,  4 Jan 2026 15:09:12 +0800 (CST)
Received: from huawei.com (10.90.31.46) by dggpemf500015.china.huawei.com
 (7.185.36.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sun, 4 Jan
 2026 15:09:11 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<liulongfang@huawei.com>
Subject: [PATCH 4/4] hisi_acc_vfio_pci: fix the queue parameter anomaly issue
Date: Sun, 4 Jan 2026 15:07:06 +0800
Message-ID: <20260104070706.4107994-5-liulongfang@huawei.com>
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

When the number of QPs initialized by the device, as read via vft, is zero,
it indicates either an abnormal device configuration or an abnormal read
result.
Returning 0 directly in this case would allow the live migration operation
to complete successfully, leading to incorrect parameter configuration after
migration and preventing the service from recovering normal functionality.
Therefore, in such situations, an error should be returned to roll back the
live migration operation.

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
---
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index 394f1952a7ed..e0cc20f5f38b 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -406,7 +406,7 @@ static int vf_qm_check_match(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 	struct hisi_qm *pf_qm = hisi_acc_vdev->pf_qm;
 	struct device *dev = &vf_qm->pdev->dev;
 	u32 que_iso_state;
-	int ret;
+	int qp_num, ret;
 
 	if (migf->total_length < QM_MATCH_SIZE || hisi_acc_vdev->match_done)
 		return 0;
@@ -423,18 +423,18 @@ static int vf_qm_check_match(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 	}
 
 	/* VF qp num check */
-	ret = qm_get_vft(vf_qm, &vf_qm->qp_base);
-	if (ret <= 0) {
+	qp_num = qm_get_vft(vf_qm, &vf_qm->qp_base);
+	if (qp_num <= 0) {
 		dev_err(dev, "failed to get vft qp nums\n");
-		return ret;
+		return -EINVAL;
 	}
 
-	if (ret != vf_data->qp_num) {
+	if (qp_num != vf_data->qp_num) {
 		dev_err(dev, "failed to match VF qp num\n");
 		return -EINVAL;
 	}
 
-	vf_qm->qp_num = ret;
+	vf_qm->qp_num = qp_num;
 
 	/* VF isolation state check */
 	ret = qm_read_regs(pf_qm, QM_QUE_ISO_CFG_V, &que_iso_state, 1);
-- 
2.24.0


