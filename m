Return-Path: <kvm+bounces-53962-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CC40B1AECD
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 08:52:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C9D907ADA5C
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 06:51:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 341DA22576C;
	Tue,  5 Aug 2025 06:52:25 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2F5221571;
	Tue,  5 Aug 2025 06:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754376744; cv=none; b=SWgvJ2n2ybLt5LeLgKr/dZ5rk5GoFohlQvi75TKa3RQVlacMhxmFQxkYrxe9HHYmnWHpX13/OKNQii9T8JvVrPJYZSyL9Ub0HWqA9KNKP2XXtM6iF470yIunZmD5Q/QZc7LCZ/KdwmT+4Jh+22YMROLSFAatu3EOjbl3hdSn1vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754376744; c=relaxed/simple;
	bh=5D97KnmkJhmHWowy32+sKgydeWlWSW7EIvxRuhDs5Vk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tqnXkeUWK/TxCEHg3+YBiYlUxnvOhIJCw7w9WLZYhuQLgSF4HiTbgk4n/wGhJKMXg1Md80TLGubEgFbzLi1O9DD6MJ4OUKFqK3xgUiEbnKNf7iNC8BUoAqeezQwvfd7JWBdNzGqgISoCyr0266PhgqHG8gX3TyAAw72uWvxDHOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4bx3s80yssz14MF8;
	Tue,  5 Aug 2025 14:47:56 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id 579671401F3;
	Tue,  5 Aug 2025 14:52:12 +0800 (CST)
Received: from huawei.com (10.90.31.46) by dggpemf500015.china.huawei.com
 (7.185.36.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 5 Aug
 2025 14:52:11 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<herbert@gondor.apana.org.au>, <shameerali.kolothum.thodi@huawei.com>,
	<jonathan.cameron@huawei.com>
CC: <linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>,
	<liulongfang@huawei.com>
Subject: [PATCH v7 2/3] migration: qm updates BAR configuration
Date: Tue, 5 Aug 2025 14:51:05 +0800
Message-ID: <20250805065106.898298-3-liulongfang@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20250805065106.898298-1-liulongfang@huawei.com>
References: <20250805065106.898298-1-liulongfang@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf500015.china.huawei.com (7.185.36.143)

On new platforms greater than QM_HW_V3, the configuration region for the
live migration function of the accelerator device is no longer
placed in the VF, but is instead placed in the PF.

Therefore, the configuration region of the live migration function
needs to be opened when the QM driver is loaded. When the QM driver
is uninstalled, the driver needs to clear this configuration.

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>=0D
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/hisilicon/qm.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 7c41f9593d03..b5ce9b1e9c56 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -242,6 +242,9 @@
 #define QM_QOS_MAX_CIR_U		6
 #define QM_AUTOSUSPEND_DELAY		3000
=20
+#define QM_MIG_REGION_SEL		0x100198
+#define QM_MIG_REGION_EN		0x1
+
  /* abnormal status value for stopping queue */
 #define QM_STOP_QUEUE_FAIL		1
 #define	QM_DUMP_SQC_FAIL		3
@@ -3004,11 +3007,36 @@ static void qm_put_pci_res(struct hisi_qm *qm)
 	pci_release_mem_regions(pdev);
 }
=20
+static void hisi_mig_region_clear(struct hisi_qm *qm)
+{
+	u32 val;
+
+	/* Clear migration region set of PF */
+	if (qm->fun_type =3D=3D QM_HW_PF && qm->ver > QM_HW_V3) {
+		val =3D readl(qm->io_base + QM_MIG_REGION_SEL);
+		val &=3D ~BIT(0);
+		writel(val, qm->io_base + QM_MIG_REGION_SEL);
+	}
+}
+
+static void hisi_mig_region_enable(struct hisi_qm *qm)
+{
+	u32 val;
+
+	/* Select migration region of PF */
+	if (qm->fun_type =3D=3D QM_HW_PF && qm->ver > QM_HW_V3) {
+		val =3D readl(qm->io_base + QM_MIG_REGION_SEL);
+		val |=3D QM_MIG_REGION_EN;
+		writel(val, qm->io_base + QM_MIG_REGION_SEL);
+	}
+}
+
 static void hisi_qm_pci_uninit(struct hisi_qm *qm)
 {
 	struct pci_dev *pdev =3D qm->pdev;
=20
 	pci_free_irq_vectors(pdev);
+	hisi_mig_region_clear(qm);
 	qm_put_pci_res(qm);
 	pci_disable_device(pdev);
 }
@@ -5630,6 +5658,7 @@ int hisi_qm_init(struct hisi_qm *qm)
 		goto err_free_qm_memory;
=20
 	qm_cmd_init(qm);
+	hisi_mig_region_enable(qm);
=20
 	return 0;
=20
--=20
2.24.0


