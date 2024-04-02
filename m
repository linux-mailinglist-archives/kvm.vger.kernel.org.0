Return-Path: <kvm+bounces-13322-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74B688949FD
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 05:30:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 048612874E6
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 03:30:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DE7017559;
	Tue,  2 Apr 2024 03:29:55 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41436156C2;
	Tue,  2 Apr 2024 03:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712028594; cv=none; b=SAZSjSulzOju0ATer/E28NpW1Pgd3abGgp3l+fqGtQRhWHFFMPOkNI7rvvlfU2WHZ04xmyGRezSWEFqC5dxgRtgFUtrq35EVIoe/m/z78NzTNC8muVTEBSgGGKgU3kMaeJ+R2u5WMrIelz7fONlnED+RZqhLUexlV6BTN5/m4Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712028594; c=relaxed/simple;
	bh=8bcsrA2Lq0ga4FH436fKGxyE6fNRzCVVCCyK4htyjZY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EIZhrzxOqx4KEt59hBKVKDENkZKT/9HKnHN/ANV1vV3VR9A2/9949LVIgc2dKyZP7pCRrn+A/XQZ/On2RA1vCp/GBLao6OvYFpCifJyRq4VfMnfE/bzU7KF5dTEy7v3QL20dLfnxy5mlw0AUkRB7CTR6QCYNgmNWZ3+7pCstgn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4V7tbX0bLWz1R9bF;
	Tue,  2 Apr 2024 11:27:04 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (unknown [7.193.23.191])
	by mail.maildlp.com (Postfix) with ESMTPS id F34661A0172;
	Tue,  2 Apr 2024 11:29:48 +0800 (CST)
Received: from huawei.com (10.50.165.33) by kwepemm600005.china.huawei.com
 (7.193.23.191) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Tue, 2 Apr
 2024 11:29:48 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v4 1/4] hisi_acc_vfio_pci: extract public functions for container_of
Date: Tue, 2 Apr 2024 11:24:29 +0800
Message-ID: <20240402032432.41004-2-liulongfang@huawei.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20240402032432.41004-1-liulongfang@huawei.com>
References: <20240402032432.41004-1-liulongfang@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600005.china.huawei.com (7.193.23.191)

In the current driver, vdev is obtained from struct
hisi_acc_vf_core_device through the container_of function.
This method is used in many places in the driver. In order to
reduce this repetitive operation, It was extracted into
a public function.

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
---
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 21 ++++++++++---------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index 9a3e97108ace..45351be8e270 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -630,6 +630,12 @@ static void hisi_acc_vf_disable_fds(struct hisi_acc_vf_core_device *hisi_acc_vde
 	}
 }
 
+static struct hisi_acc_vf_core_device *hisi_acc_get_vf_dev(struct vfio_device *vdev)
+{
+	return container_of(vdev, struct hisi_acc_vf_core_device,
+			    core_device.vdev);
+}
+
 static void hisi_acc_vf_reset(struct hisi_acc_vf_core_device *hisi_acc_vdev)
 {
 	hisi_acc_vdev->vf_qm_state = QM_NOT_READY;
@@ -1033,8 +1039,7 @@ static struct file *
 hisi_acc_vfio_pci_set_device_state(struct vfio_device *vdev,
 				   enum vfio_device_mig_state new_state)
 {
-	struct hisi_acc_vf_core_device *hisi_acc_vdev = container_of(vdev,
-			struct hisi_acc_vf_core_device, core_device.vdev);
+	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(vdev);
 	enum vfio_device_mig_state next_state;
 	struct file *res = NULL;
 	int ret;
@@ -1075,8 +1080,7 @@ static int
 hisi_acc_vfio_pci_get_device_state(struct vfio_device *vdev,
 				   enum vfio_device_mig_state *curr_state)
 {
-	struct hisi_acc_vf_core_device *hisi_acc_vdev = container_of(vdev,
-			struct hisi_acc_vf_core_device, core_device.vdev);
+	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(vdev);
 
 	mutex_lock(&hisi_acc_vdev->state_mutex);
 	*curr_state = hisi_acc_vdev->mig_state;
@@ -1280,8 +1284,7 @@ static long hisi_acc_vfio_pci_ioctl(struct vfio_device *core_vdev, unsigned int
 
 static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
 {
-	struct hisi_acc_vf_core_device *hisi_acc_vdev = container_of(core_vdev,
-			struct hisi_acc_vf_core_device, core_device.vdev);
+	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(core_vdev);
 	struct vfio_pci_core_device *vdev = &hisi_acc_vdev->core_device;
 	int ret;
 
@@ -1304,8 +1307,7 @@ static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
 
 static void hisi_acc_vfio_pci_close_device(struct vfio_device *core_vdev)
 {
-	struct hisi_acc_vf_core_device *hisi_acc_vdev = container_of(core_vdev,
-			struct hisi_acc_vf_core_device, core_device.vdev);
+	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(core_vdev);
 	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
 
 	iounmap(vf_qm->io_base);
@@ -1320,8 +1322,7 @@ static const struct vfio_migration_ops hisi_acc_vfio_pci_migrn_state_ops = {
 
 static int hisi_acc_vfio_pci_migrn_init_dev(struct vfio_device *core_vdev)
 {
-	struct hisi_acc_vf_core_device *hisi_acc_vdev = container_of(core_vdev,
-			struct hisi_acc_vf_core_device, core_device.vdev);
+	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_get_vf_dev(core_vdev);
 	struct pci_dev *pdev = to_pci_dev(core_vdev->dev);
 	struct hisi_qm *pf_qm = hisi_acc_get_pf_qm(pdev);
 
-- 
2.24.0


