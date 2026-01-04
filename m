Return-Path: <kvm+bounces-66980-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E6004CF0B0E
	for <lists+kvm@lfdr.de>; Sun, 04 Jan 2026 08:08:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A254F301EC6B
	for <lists+kvm@lfdr.de>; Sun,  4 Jan 2026 07:08:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B2592EA156;
	Sun,  4 Jan 2026 07:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="DyG6dOt1"
X-Original-To: kvm@vger.kernel.org
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17611EEA55;
	Sun,  4 Jan 2026 07:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767510496; cv=none; b=P44aeYR9d3+g0EDbDwrUxdWvGF3qnykMKo9OQRcJmaOouxbkpk+YcDYlOdBlsWDgrDcP7fPhKqjYiyDw51NbT9lc50QyGp9hIORlJ1jE5+nPfGUv2Yp1p9zXfsJ85d3d6Tc9yeAERNL36j8PKaIJ1Ygr6f2eETXSLiisq2oLeAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767510496; c=relaxed/simple;
	bh=WBwnOcUl/xssJGTTP8exQMaj2WD7Lg4rRSYxjmvd9/g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ewFRrgYNiVyHhUm4mC3Vt/sGan275wm1yQEFA+S204DDwX7iM8cVCXvY9t2CwG8X+pRCSPIBPmzbUylM/Iop7RNz+HyvMdrPIlKxuGwaZ8HrA5qbeOWrKgt29zj0aLf876C0RCj95A3CZZbIRbTQGawpNR2FjLfApasIvS2n38Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=DyG6dOt1; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=I/ZN+17KSILnRKc9JdIcWXQNtNFNMtaQKhkBwwLWLZ0=;
	b=DyG6dOt1xo/sEZO/KBD62S2p3iuSYzuD2+fYy1UHVXmPrt+DTv/IPgj+uz73/58sLMx45TEHm
	RUZPYTL65Mcz7XMoQk+RkcK7mykeHMoWTbCcnLHUNlrIEprEdP9OLS7Q25kf+STfiV3OKTU3/L+
	FDR47Xze0aZrDlFWQZ9dheQ=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dkT3J63qTz1T4Gh;
	Sun,  4 Jan 2026 15:05:32 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id 2BEC140538;
	Sun,  4 Jan 2026 15:08:10 +0800 (CST)
Received: from huawei.com (10.90.31.46) by dggpemf500015.china.huawei.com
 (7.185.36.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sun, 4 Jan
 2026 15:08:09 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<liulongfang@huawei.com>
Subject: [PATCH 2/4] hisi_acc_vfio_pci: update status after RAS error
Date: Sun, 4 Jan 2026 15:07:04 +0800
Message-ID: <20260104070706.4107994-3-liulongfang@huawei.com>
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

After a RAS error occurs on the accelerator device, the accelerator
device will be reset. The live migration state will be abnormal
after reset, and the original state needs to be restored during
the reset process.
Therefore, reset processing needs to be performed in a live
migration scenario.

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
---
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index d55365b21f78..e782c2274871 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -1212,8 +1212,7 @@ static void hisi_acc_vf_pci_aer_reset_done(struct pci_dev *pdev)
 	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_drvdata(pdev);
 	struct hisi_qm *qm = hisi_acc_vdev->pf_qm;
 
-	if (hisi_acc_vdev->core_device.vdev.migration_flags !=
-				VFIO_MIGRATION_STOP_COPY)
+	if (!hisi_acc_vdev->core_device.vdev.mig_ops)
 		return;
 
 	if (hisi_acc_vdev->set_reset_flag)
-- 
2.24.0


