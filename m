Return-Path: <kvm+bounces-41372-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B9EAAA66ACC
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 07:49:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 62B7A3BC44C
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 06:48:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65EC41DEFFD;
	Tue, 18 Mar 2025 06:48:35 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37A91DED53;
	Tue, 18 Mar 2025 06:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742280514; cv=none; b=MR5VIfcd/q379lV9ZfWJYTLDQ/iuMS3O2wHP9cXEOoVNl5ftXEaTKGvg/UP9+3/oRuoncpvJ6yJ02bAJ4FQM6qVQg7HQ4cQehDsOonb95Y+TP/JPZEfSuERnqp0kIMr4lvSZGaGAfrnJ1X9pR9L2IrgyxQX+q8skEwhUjb4bnkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742280514; c=relaxed/simple;
	bh=ju7RlEZ4D5RBGkSyvXt5sEZK4+ddfCC9LZ+U5+8aGUU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Thz5Y3AH0XcPvaYXX5vUpn0A3gm+wDUW2S4YJnzpldpDg8WVOoZnx37IZS6KKzC/COxH4shRyph4kO45uCdRACceMkmCvebKgE+atf9bMasCD1fAC82mTB7CodUyVgpvSnEvuntd3917UlEbOAQQ0ju4WaCXD0TaYsqHKndwO1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4ZH2Sj6KhRztQqs;
	Tue, 18 Mar 2025 14:47:01 +0800 (CST)
Received: from kwepemg500006.china.huawei.com (unknown [7.202.181.43])
	by mail.maildlp.com (Postfix) with ESMTPS id 04FAE1800B1;
	Tue, 18 Mar 2025 14:48:30 +0800 (CST)
Received: from huawei.com (10.50.165.33) by kwepemg500006.china.huawei.com
 (7.202.181.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 18 Mar
 2025 14:48:29 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v6 5/5] hisi_acc_vfio_pci: bugfix live migration function without VF device driver
Date: Tue, 18 Mar 2025 14:45:48 +0800
Message-ID: <20250318064548.59043-6-liulongfang@huawei.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20250318064548.59043-1-liulongfang@huawei.com>
References: <20250318064548.59043-1-liulongfang@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemg500006.china.huawei.com (7.202.181.43)

If the VF device driver is not loaded in the Guest OS and we attempt to
perform device data migration, the address of the migrated data will
be NULL.
The live migration recovery operation on the destination side will
access a null address value, which will cause access errors.

Therefore, live migration of VMs without added VF device drivers
does not require device data migration.
In addition, when the queue address data obtained by the destination
is empty, device queue recovery processing will not be performed.

Fixes: b0eed085903e ("hisi_acc_vfio_pci: Add support for VFIO live migratio=
n")
Signed-off-by: Longfang Liu <liulongfang@huawei.com>=0D
Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 21 ++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/=
pci/hisilicon/hisi_acc_vfio_pci.c
index cadc82419dca..68b1c7204cad 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -426,13 +426,6 @@ static int vf_qm_check_match(struct hisi_acc_vf_core_d=
evice *hisi_acc_vdev,
 		return -EINVAL;
 	}
=20
-	ret =3D qm_write_regs(vf_qm, QM_VF_STATE, &vf_data->vf_qm_state, 1);
-	if (ret) {
-		dev_err(dev, "failed to write QM_VF_STATE\n");
-		return ret;
-	}
-
-	hisi_acc_vdev->vf_qm_state =3D vf_data->vf_qm_state;
 	hisi_acc_vdev->match_done =3D true;
 	return 0;
 }
@@ -498,6 +491,13 @@ static int vf_qm_load_data(struct hisi_acc_vf_core_dev=
ice *hisi_acc_vdev,
 	if (migf->total_length < sizeof(struct acc_vf_data))
 		return -EINVAL;
=20
+	ret =3D qm_write_regs(qm, QM_VF_STATE, &vf_data->vf_qm_state, 1);
+	if (ret) {
+		dev_err(dev, "failed to write QM_VF_STATE\n");
+		return -EINVAL;
+	}
+	hisi_acc_vdev->vf_qm_state =3D vf_data->vf_qm_state;
+
 	qm->eqe_dma =3D vf_data->eqe_dma;
 	qm->aeqe_dma =3D vf_data->aeqe_dma;
 	qm->sqc_dma =3D vf_data->sqc_dma;
@@ -506,6 +506,12 @@ static int vf_qm_load_data(struct hisi_acc_vf_core_dev=
ice *hisi_acc_vdev,
 	qm->qp_base =3D vf_data->qp_base;
 	qm->qp_num =3D vf_data->qp_num;
=20
+	if (!vf_data->eqe_dma || !vf_data->aeqe_dma ||
+	    !vf_data->sqc_dma || !vf_data->cqc_dma) {
+		dev_err(dev, "resume dma addr is NULL!\n");
+		return -EINVAL;
+	}
+
 	ret =3D qm_set_regs(qm, vf_data);
 	if (ret) {
 		dev_err(dev, "set VF regs failed\n");
@@ -1531,6 +1537,7 @@ static int hisi_acc_vfio_pci_migrn_init_dev(struct vf=
io_device *core_vdev)
 	hisi_acc_vdev->vf_id =3D pci_iov_vf_id(pdev) + 1;
 	hisi_acc_vdev->pf_qm =3D pf_qm;
 	hisi_acc_vdev->vf_dev =3D pdev;
+	hisi_acc_vdev->vf_qm_state =3D QM_NOT_READY;
 	mutex_init(&hisi_acc_vdev->state_mutex);
 	mutex_init(&hisi_acc_vdev->open_mutex);
=20
--=20
2.24.0


