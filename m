Return-Path: <kvm+bounces-52680-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 50CE9B0822F
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 03:16:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AC18B1A60900
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 01:16:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E91D1DB54C;
	Thu, 17 Jul 2025 01:16:03 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F35EEC3;
	Thu, 17 Jul 2025 01:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752714962; cv=none; b=KyKm0y+sauXZQyOf5uES+EEEm6Mgmz8RbI/Px0TjIplrUn5SdJmxd1NBVqQ7bET27DWri1CHCEbCzJI6A0r9fjcoDx95Lw29eN5U0XWiKYikF4zLFonOOlIJqqoZMuZ8P4lENCA9hreVPIwhJCLhXlfUXKZ0dv2lzECODP66AeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752714962; c=relaxed/simple;
	bh=kX8p29fRyaJPk2EIWuLKTwuO0xBrAj8alcB2MG8ss9U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HjUwYKwTc5HGI/mT11kWkrwEA44myqOTJn925rd3J0iBiffI97zBezlz97VW1dXSOUFjfKy6cv/tNaBUDB8Ir+gbC1XT7m7zI9mlvtPHq1nY2XICyj9oiQtzJ1VQKLJkDnXN/P4nPPCyhceGeGqobDySo44zRggNIBQ5k75PAbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4bjFKc3nzHz13MhC;
	Thu, 17 Jul 2025 09:13:08 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id 4A5CD140132;
	Thu, 17 Jul 2025 09:15:57 +0800 (CST)
Received: from huawei.com (10.50.165.33) by dggpemf500015.china.huawei.com
 (7.185.36.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 17 Jul
 2025 09:15:57 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<herbert@gondor.apana.org.au>, <shameerali.kolothum.thodi@huawei.com>,
	<jonathan.cameron@huawei.com>
CC: <linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>,
	<liulongfang@huawei.com>
Subject: [PATCH v6 1/3] migration: update BAR space size
Date: Thu, 17 Jul 2025 09:15:00 +0800
Message-ID: <20250717011502.16050-2-liulongfang@huawei.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20250717011502.16050-1-liulongfang@huawei.com>
References: <20250717011502.16050-1-liulongfang@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemf500015.china.huawei.com (7.185.36.143)

On new platforms greater than QM_HW_V3, the live migration configuration
region is moved from VF to PF. The VF's own configuration space is
restored to the complete 64KB, and there is no need to divide the
size of the BAR configuration space equally.

Signed-off-by: Longfang Liu <liulongfang@huawei.com>=0D
Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 36 ++++++++++++++-----
 1 file changed, 27 insertions(+), 9 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/=
pci/hisilicon/hisi_acc_vfio_pci.c
index 2149f49aeec7..515ff87f9ed9 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -1250,6 +1250,28 @@ static struct hisi_qm *hisi_acc_get_pf_qm(struct pci=
_dev *pdev)
 	return !IS_ERR(pf_qm) ? pf_qm : NULL;
 }
=20
+static size_t hisi_acc_get_resource_len(struct vfio_pci_core_device *vdev,
+					unsigned int index)
+{
+	struct hisi_acc_vf_core_device *hisi_acc_vdev =3D
+			hisi_acc_drvdata(vdev->pdev);
+
+	/*
+	 * On the old HW_V3 device, the ACC VF device BAR2
+	 * region encompasses both functional register space
+	 * and migration control register space.
+	 * only the functional region should be report to Guest.
+	 */
+	if (hisi_acc_vdev->pf_qm->ver =3D=3D QM_HW_V3)
+		return (pci_resource_len(vdev->pdev, index) >> 1);
+	/*
+	 * On the new HW device, the migration control register
+	 * has been moved to the PF device BAR2 region.
+	 * The VF device BAR2 is entirely functional register space.
+	 */
+	return pci_resource_len(vdev->pdev, index);
+}
+
 static int hisi_acc_pci_rw_access_check(struct vfio_device *core_vdev,
 					size_t count, loff_t *ppos,
 					size_t *new_count)
@@ -1260,8 +1282,9 @@ static int hisi_acc_pci_rw_access_check(struct vfio_d=
evice *core_vdev,
=20
 	if (index =3D=3D VFIO_PCI_BAR2_REGION_INDEX) {
 		loff_t pos =3D *ppos & VFIO_PCI_OFFSET_MASK;
-		resource_size_t end =3D pci_resource_len(vdev->pdev, index) / 2;
+		resource_size_t end;
=20
+		end =3D hisi_acc_get_resource_len(vdev, index);
 		/* Check if access is for migration control region */
 		if (pos >=3D end)
 			return -EINVAL;
@@ -1282,8 +1305,9 @@ static int hisi_acc_vfio_pci_mmap(struct vfio_device =
*core_vdev,
 	index =3D vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
 	if (index =3D=3D VFIO_PCI_BAR2_REGION_INDEX) {
 		u64 req_len, pgoff, req_start;
-		resource_size_t end =3D pci_resource_len(vdev->pdev, index) / 2;
+		resource_size_t end;
=20
+		end =3D hisi_acc_get_resource_len(vdev, index);
 		req_len =3D vma->vm_end - vma->vm_start;
 		pgoff =3D vma->vm_pgoff &
 			((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
@@ -1330,7 +1354,6 @@ static long hisi_acc_vfio_pci_ioctl(struct vfio_devic=
e *core_vdev, unsigned int
 	if (cmd =3D=3D VFIO_DEVICE_GET_REGION_INFO) {
 		struct vfio_pci_core_device *vdev =3D
 			container_of(core_vdev, struct vfio_pci_core_device, vdev);
-		struct pci_dev *pdev =3D vdev->pdev;
 		struct vfio_region_info info;
 		unsigned long minsz;
=20
@@ -1345,12 +1368,7 @@ static long hisi_acc_vfio_pci_ioctl(struct vfio_devi=
ce *core_vdev, unsigned int
 		if (info.index =3D=3D VFIO_PCI_BAR2_REGION_INDEX) {
 			info.offset =3D VFIO_PCI_INDEX_TO_OFFSET(info.index);
=20
-			/*
-			 * ACC VF dev BAR2 region consists of both functional
-			 * register space and migration control register space.
-			 * Report only the functional region to Guest.
-			 */
-			info.size =3D pci_resource_len(pdev, info.index) / 2;
+			info.size =3D hisi_acc_get_resource_len(vdev, info.index);
=20
 			info.flags =3D VFIO_REGION_INFO_FLAG_READ |
 					VFIO_REGION_INFO_FLAG_WRITE |
--=20
2.24.0


