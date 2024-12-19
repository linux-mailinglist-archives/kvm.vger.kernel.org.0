Return-Path: <kvm+bounces-34130-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2462C9F7864
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 10:25:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2A2817A6808
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 09:23:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B51C822489F;
	Thu, 19 Dec 2024 09:21:18 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04995223E9B;
	Thu, 19 Dec 2024 09:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734600078; cv=none; b=eTrgKFotwy83oyrnPiCO5ygBNVWFM4H2T7cmsmzEk2krWHAe+HOrW426hTu2Tz9sUNq5aBroL/x+IgR+TuI0rlL+p80Cbw1/i1+JHLKf4iWA19NbBT3U8jZYwHMiFGc9wIz/whTHxaOfaXHCpVsd7YXmgwPIP+YgSIcF8d002tI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734600078; c=relaxed/simple;
	bh=fo2ZJz5XkiWYYwc7jkTrQE2mhbFJSaU57p6y6BXBcYg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uhIGx04yze5IMBH1Zv1JZQ6pfjvXNwTxW5LUJoMn7kfEOtREgayGvV8nva//xWnNfYqn+pcFyjuadpc5q+b8UCRXGHc34D8Uilx9h0HpY6fKq2rFnQZ2wdtk45w0EL1J3oeiepATP8/ceb8hjY4B1PVAtkHImozeAludAI38aF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4YDQ2C3FXdzFrck;
	Thu, 19 Dec 2024 17:18:11 +0800 (CST)
Received: from dggemv711-chm.china.huawei.com (unknown [10.1.198.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 1DCE3180A9E;
	Thu, 19 Dec 2024 17:21:08 +0800 (CST)
Received: from kwepemn100017.china.huawei.com (7.202.194.122) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 19 Dec 2024 17:21:07 +0800
Received: from huawei.com (10.50.165.33) by kwepemn100017.china.huawei.com
 (7.202.194.122) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 19 Dec
 2024 17:21:07 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v2 4/5] hisi_acc_vfio_pci: bugfix the problem of uninstalling driver
Date: Thu, 19 Dec 2024 17:17:59 +0800
Message-ID: <20241219091800.41462-5-liulongfang@huawei.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20241219091800.41462-1-liulongfang@huawei.com>
References: <20241219091800.41462-1-liulongfang@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemn100017.china.huawei.com (7.202.194.122)

In a live migration scenario. If the number of VFs at the
destination is greater than the source, the recovery operation
will fail and qemu will not be able to complete the process and
exit after shutting down the device FD.

This will cause the driver to be unable to be unloaded normally due
to abnormal reference counting of the live migration driver caused
by the abnormal closing operation of fd.

Fixes:b0eed085903e("hisi_acc_vfio_pci: Add support for VFIO live migration")
Signed-off-by: Longfang Liu <liulongfang@huawei.com>
---
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index c057c0e24693..8d9e07ebf4fd 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -1501,6 +1501,7 @@ static void hisi_acc_vfio_pci_close_device(struct vfio_device *core_vdev)
 	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(core_vdev);
 	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
 
+	hisi_acc_vf_disable_fds(hisi_acc_vdev);
 	mutex_lock(&hisi_acc_vdev->open_mutex);
 	hisi_acc_vdev->dev_opened = false;
 	iounmap(vf_qm->io_base);
-- 
2.24.0


