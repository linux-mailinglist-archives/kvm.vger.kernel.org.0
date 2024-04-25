Return-Path: <kvm+bounces-15919-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C24DD8B22C6
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 15:30:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7FC962841EB
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 13:30:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AC4114A4F4;
	Thu, 25 Apr 2024 13:29:30 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15C9149C61;
	Thu, 25 Apr 2024 13:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714051770; cv=none; b=HEaKMfB/wS8zdLorhuq+yBKuXhf4MfaXphUFxb1qMRKiPpLJq6rtUUgijRyAbXGKEPZFtbtox8HgcaMixRNoLdAeyAMq5tKXcmgcEFw3CKINce+g2Z1ifF3T75gjLcwuNnPs7FWiMycET6SiQQ97ZHU84HuMNFRDcgAK7JMnmCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714051770; c=relaxed/simple;
	bh=ek7iSkZeQhEAXZowAd/rNzDaNByG1nPmFY7C4c+Vep0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GtWayg8YNRNgX5/H79zlDi6LdyAJrF8sJqRJzy77lqaHXQHKJFyh4wSZBVKGA6iZM+7M54396GPQDq6X68giJPhZ2e/DWa1W2mOPLSbd0QZw3B/V4Wfa13HPhrwDXpv/oipE/AU1YoDjaG3a+8RdTb3UNhOOWyr7CuvgcPoog8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4VQGrh4HPbzcb3w;
	Thu, 25 Apr 2024 21:28:20 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (unknown [7.193.23.191])
	by mail.maildlp.com (Postfix) with ESMTPS id AFF36180073;
	Thu, 25 Apr 2024 21:29:25 +0800 (CST)
Received: from huawei.com (10.50.165.33) by kwepemm600005.china.huawei.com
 (7.193.23.191) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Thu, 25 Apr
 2024 21:29:25 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v6 2/5] hisi_acc_vfio_pci: modify the register location of the XQC address
Date: Thu, 25 Apr 2024 21:23:19 +0800
Message-ID: <20240425132322.12041-3-liulongfang@huawei.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20240425132322.12041-1-liulongfang@huawei.com>
References: <20240425132322.12041-1-liulongfang@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600005.china.huawei.com (7.193.23.191)

According to the latest hardware register specification. The DMA
addresses of EQE and AEQE are not at the front of their respective
register groups, but start from the second.
So, previously fetching the value starting from the first register
would result in an incorrect address.

Therefore, the register location from which the address is obtained
needs to be modified.

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
---
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 8 ++++----
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h | 3 +++
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index 45351be8e270..0c7e31076ff4 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -516,12 +516,12 @@ static int vf_qm_state_save(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 		return -EINVAL;
 
 	/* Every reg is 32 bit, the dma address is 64 bit. */
-	vf_data->eqe_dma = vf_data->qm_eqc_dw[1];
+	vf_data->eqe_dma = vf_data->qm_eqc_dw[QM_XQC_ADDR_HIGH];
 	vf_data->eqe_dma <<= QM_XQC_ADDR_OFFSET;
-	vf_data->eqe_dma |= vf_data->qm_eqc_dw[0];
-	vf_data->aeqe_dma = vf_data->qm_aeqc_dw[1];
+	vf_data->eqe_dma |= vf_data->qm_eqc_dw[QM_XQC_ADDR_LOW];
+	vf_data->aeqe_dma = vf_data->qm_aeqc_dw[QM_XQC_ADDR_HIGH];
 	vf_data->aeqe_dma <<= QM_XQC_ADDR_OFFSET;
-	vf_data->aeqe_dma |= vf_data->qm_aeqc_dw[0];
+	vf_data->aeqe_dma |= vf_data->qm_aeqc_dw[QM_XQC_ADDR_LOW];
 
 	/* Through SQC_BT/CQC_BT to get sqc and cqc address */
 	ret = qm_get_sqc(vf_qm, &vf_data->sqc_dma);
diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
index 5bab46602fad..f887ab98581c 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
@@ -38,6 +38,9 @@
 #define QM_REG_ADDR_OFFSET	0x0004
 
 #define QM_XQC_ADDR_OFFSET	32U
+#define QM_XQC_ADDR_LOW	0x1
+#define QM_XQC_ADDR_HIGH	0x2
+
 #define QM_VF_AEQ_INT_MASK	0x0004
 #define QM_VF_EQ_INT_MASK	0x000c
 #define QM_IFC_INT_SOURCE_V	0x0020
-- 
2.24.0


