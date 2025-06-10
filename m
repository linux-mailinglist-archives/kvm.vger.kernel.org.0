Return-Path: <kvm+bounces-48789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 156ECAD2DFF
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 08:34:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9BB9C16A210
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 06:34:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40D4727978B;
	Tue, 10 Jun 2025 06:34:05 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A90C21C9F7;
	Tue, 10 Jun 2025 06:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749537244; cv=none; b=HvTMXErYJgmkGMZWx1eCsYN/FSM4vG95q6JAZXtLSe6GkKcmTpZv7Fh8hSuM/dcLznsGRT1fCueOMvYYK4+iY/f40EvR7aK/35oPdxGc5p8ju/ZS16sRIcpMOj8i/AkJnM4KxOqg3L0UEjW2RaQmX8Fzw2628a4haNmoAU9z1n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749537244; c=relaxed/simple;
	bh=EWXX3F8XAcVfbtY3Ud+J4+SJRGRYZ/zbjBjUP2SpD+0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PcpbqYfRQ+ewmoP/Gp9lRPvUhb3QkT59GRP9Jz/0UxvnXVpWkRff/j1dwrfYxRlq57Znnt70rkKJR+PyCy8cjpgo3auV4PrzIwMppLhCJeHxoKFx5aTc3/drqvjZbCw2oOjs0WmlF8jMZGoNqzWRAVc3Yy0+nWg5/bOLpJPSSVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4bGf6R5HPKz2Cf86;
	Tue, 10 Jun 2025 14:30:07 +0800 (CST)
Received: from kwepemg500006.china.huawei.com (unknown [7.202.181.43])
	by mail.maildlp.com (Postfix) with ESMTPS id 74A3E140119;
	Tue, 10 Jun 2025 14:33:58 +0800 (CST)
Received: from huawei.com (10.50.165.33) by kwepemg500006.china.huawei.com
 (7.202.181.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 10 Jun
 2025 14:33:57 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v4 1/3] migration: update BAR space size
Date: Tue, 10 Jun 2025 14:32:49 +0800
Message-ID: <20250610063251.27526-2-liulongfang@huawei.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20250610063251.27526-1-liulongfang@huawei.com>
References: <20250610063251.27526-1-liulongfang@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemg500006.china.huawei.com (7.202.181.43)

On the new hardware platform, the live migration configuration region
is moved from VF to PF. The VF's own configuration space is
restored to the complete 64KB, and there is no need to divide the
size of the BAR configuration space equally.

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
---
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 36 ++++++++++++++-----
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index 2149f49aeec7..b16115f590fd 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -1250,6 +1250,28 @@ static struct hisi_qm *hisi_acc_get_pf_qm(struct pci_dev *pdev)
 	return !IS_ERR(pf_qm) ? pf_qm : NULL;
 }
 
+static size_t hisi_acc_get_resource_len(struct vfio_pci_core_device *vdev,
+					unsigned int index)
+{
+	struct hisi_acc_vf_core_device *hisi_acc_vdev =
+			hisi_acc_drvdata(vdev->pdev);
+
+	/*
+	 * On the old HW_V3 device, the ACC VF device BAR2
+	 * region encompasses both functional register space
+	 * and migration control register space.
+	 * only the functional region should be report to Guest.
+	 *
+	 * On the new HW device, the migration control register
+	 * has been moved to the PF device BAR2 region.
+	 * The VF device BAR2 is entirely functional register space.
+	 */
+	if (hisi_acc_vdev->pf_qm->ver == QM_HW_V3)
+		return (pci_resource_len(vdev->pdev, index) >> 1);
+
+	return pci_resource_len(vdev->pdev, index);
+}
+
 static int hisi_acc_pci_rw_access_check(struct vfio_device *core_vdev,
 					size_t count, loff_t *ppos,
 					size_t *new_count)
@@ -1260,8 +1282,9 @@ static int hisi_acc_pci_rw_access_check(struct vfio_device *core_vdev,
 
 	if (index == VFIO_PCI_BAR2_REGION_INDEX) {
 		loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
-		resource_size_t end = pci_resource_len(vdev->pdev, index) / 2;
+		resource_size_t end;
 
+		end = hisi_acc_get_resource_len(vdev, index);
 		/* Check if access is for migration control region */
 		if (pos >= end)
 			return -EINVAL;
@@ -1282,8 +1305,9 @@ static int hisi_acc_vfio_pci_mmap(struct vfio_device *core_vdev,
 	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
 	if (index == VFIO_PCI_BAR2_REGION_INDEX) {
 		u64 req_len, pgoff, req_start;
-		resource_size_t end = pci_resource_len(vdev->pdev, index) / 2;
+		resource_size_t end;
 
+		end = PAGE_ALIGN(hisi_acc_get_resource_len(vdev, index));
 		req_len = vma->vm_end - vma->vm_start;
 		pgoff = vma->vm_pgoff &
 			((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
@@ -1330,7 +1354,6 @@ static long hisi_acc_vfio_pci_ioctl(struct vfio_device *core_vdev, unsigned int
 	if (cmd == VFIO_DEVICE_GET_REGION_INFO) {
 		struct vfio_pci_core_device *vdev =
 			container_of(core_vdev, struct vfio_pci_core_device, vdev);
-		struct pci_dev *pdev = vdev->pdev;
 		struct vfio_region_info info;
 		unsigned long minsz;
 
@@ -1345,12 +1368,7 @@ static long hisi_acc_vfio_pci_ioctl(struct vfio_device *core_vdev, unsigned int
 		if (info.index == VFIO_PCI_BAR2_REGION_INDEX) {
 			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
 
-			/*
-			 * ACC VF dev BAR2 region consists of both functional
-			 * register space and migration control register space.
-			 * Report only the functional region to Guest.
-			 */
-			info.size = pci_resource_len(pdev, info.index) / 2;
+			info.size = hisi_acc_get_resource_len(vdev, info.index);
 
 			info.flags = VFIO_REGION_INFO_FLAG_READ |
 					VFIO_REGION_INFO_FLAG_WRITE |
-- 
2.24.0


