Return-Path: <kvm+bounces-43132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C235BA85259
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 06:02:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4DA9019E0324
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 04:01:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF0F627CB37;
	Fri, 11 Apr 2025 04:01:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086681624D0;
	Fri, 11 Apr 2025 04:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744344076; cv=none; b=s+PL41+lMUF8GsZbngiwmdAsopVfipzj+1L4aFKFui2uRJAs1dIQCmK3im+dbmq19ScDnDALaldKc8ycyuww98XAjxclPHOigUedyoAmY2t+du/9g8Tg9x85/Xg1lMI6w5kEv4JsC2LYOAUvil9EFEVup/OB8+isJJWL9AcLXoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744344076; c=relaxed/simple;
	bh=RE1GKSJYC4+voiVb9yP2Gn4VIMyTKSBLMoJcSC5qnAM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YBij1KB+o9F4rJTrgAaq5svR4gqfjWi8X739zaLhZS5iTFcCD8RxaQjk8te2+PMWCJRrtIKshOVD6XHBAEg4FRHgnkCaDFI5xoR1Ba0YBsa7nj/foFESofBm4g7pmQ5SjhLMSQ1fEacytX+09xC/o9zitqUSdHFed9i43LKol+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4ZYjfy6hnlz27hHS;
	Fri, 11 Apr 2025 12:01:46 +0800 (CST)
Received: from kwepemg500006.china.huawei.com (unknown [7.202.181.43])
	by mail.maildlp.com (Postfix) with ESMTPS id 20798140277;
	Fri, 11 Apr 2025 12:01:06 +0800 (CST)
Received: from huawei.com (10.50.165.33) by kwepemg500006.china.huawei.com
 (7.202.181.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 11 Apr
 2025 12:01:05 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v7 4/6] hisi_acc_vfio_pci: bugfix the problem of uninstalling driver
Date: Fri, 11 Apr 2025 11:59:05 +0800
Message-ID: <20250411035907.57488-5-liulongfang@huawei.com>
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
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemg500006.china.huawei.com (7.202.181.43)

In a live migration scenario. If the number of VFs at the
destination is greater than the source, the recovery operation
will fail and qemu will not be able to complete the process and
exit after shutting down the device FD.

This will cause the driver to be unable to be unloaded normally due
to abnormal reference counting of the live migration driver caused
by the abnormal closing operation of fd.

Therefore, make sure the migration file descriptor references are
always released when the device is closed.

Fixes: b0eed085903e ("hisi_acc_vfio_pci: Add support for VFIO live migration")
Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index d96446f499ed..cadc82419dca 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -1508,6 +1508,7 @@ static void hisi_acc_vfio_pci_close_device(struct vfio_device *core_vdev)
 	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(core_vdev);
 	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
 
+	hisi_acc_vf_disable_fds(hisi_acc_vdev);
 	mutex_lock(&hisi_acc_vdev->open_mutex);
 	hisi_acc_vdev->dev_opened = false;
 	iounmap(vf_qm->io_base);
-- 
2.24.0


