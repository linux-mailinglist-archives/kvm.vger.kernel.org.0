Return-Path: <kvm+bounces-56528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 61776B3F242
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 04:26:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 972A518936AB
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 02:26:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FB8D2D7DCF;
	Tue,  2 Sep 2025 02:25:44 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B91CA5E;
	Tue,  2 Sep 2025 02:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756779943; cv=none; b=U3ZywF43y3dntLkShgiudZvgFitisTHya9EwQdj0yNWeZOlpRD+1HaTjDtAzDf69a3JAyi95kI+Oiq2z7N6EDOHeHIqteXszZoLdsix8ahRyiTjOTEtOiJHIfVq0qykdvY4/uHMgr8LfAVBwrsRbvdnmyKC6jRl0VUwDwDCyecY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756779943; c=relaxed/simple;
	bh=EtBuwrwxbZUQfOMKM9Xw9OWCOnlyVrR1H8gaiEcvc14=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y0BcKgBGRdPGtN63r+SZxGpapaYPEAZdnJ0cAwzFrOSA3yI5Aux7/B2mT12TycxCP7RTcteJNKEUb8ebM5qrnm9JgeNQ5ysU3X3YqpGCx3uhza+2flz3zO1bl87PjayYamwjefRXvPT7xCzRUEmovxwg0ZZwiSxnHU/jaW/HgvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4cG8jP0z9Zz14MQl;
	Tue,  2 Sep 2025 10:25:29 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id 9F1FF180495;
	Tue,  2 Sep 2025 10:25:38 +0800 (CST)
Received: from huawei.com (10.90.31.46) by dggpemf500015.china.huawei.com
 (7.185.36.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 2 Sep
 2025 10:25:37 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerkolothum@gmail.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v9 1/2] crypto: hisilicon - qm updates BAR configuration
Date: Tue, 2 Sep 2025 10:25:04 +0800
Message-ID: <20250902022505.2034408-2-liulongfang@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20250902022505.2034408-1-liulongfang@huawei.com>
References: <20250902022505.2034408-1-liulongfang@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500015.china.huawei.com (7.185.36.143)

On new platforms greater than QM_HW_V3, the configuration region for the
live migration function of the accelerator device is no longer
placed in the VF, but is instead placed in the PF.

Therefore, the configuration region of the live migration function
needs to be opened when the QM driver is loaded. When the QM driver
is uninstalled, the driver needs to clear this configuration.

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Reviewed-by: Shameer Kolothum <shameerkolothum@gmail.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/hisilicon/qm.c | 27 +++++++++++++++++++++++++++
 include/linux/hisi_acc_qm.h   |  3 +++
 2 files changed, 30 insertions(+)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 2e4ee7ecfdfb..51f5f68ec8bb 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -3003,11 +3003,36 @@ static void qm_put_pci_res(struct hisi_qm *qm)
 	pci_release_mem_regions(pdev);
 }
 
+static void hisi_mig_region_clear(struct hisi_qm *qm)
+{
+	u32 val;
+
+	/* Clear migration region set of PF */
+	if (qm->fun_type == QM_HW_PF && qm->ver > QM_HW_V3) {
+		val = readl(qm->io_base + QM_MIG_REGION_SEL);
+		val &= ~BIT(0);
+		writel(val, qm->io_base + QM_MIG_REGION_SEL);
+	}
+}
+
+static void hisi_mig_region_enable(struct hisi_qm *qm)
+{
+	u32 val;
+
+	/* Select migration region of PF */
+	if (qm->fun_type == QM_HW_PF && qm->ver > QM_HW_V3) {
+		val = readl(qm->io_base + QM_MIG_REGION_SEL);
+		val |= QM_MIG_REGION_EN;
+		writel(val, qm->io_base + QM_MIG_REGION_SEL);
+	}
+}
+
 static void hisi_qm_pci_uninit(struct hisi_qm *qm)
 {
 	struct pci_dev *pdev = qm->pdev;
 
 	pci_free_irq_vectors(pdev);
+	hisi_mig_region_clear(qm);
 	qm_put_pci_res(qm);
 	pci_disable_device(pdev);
 }
@@ -5629,6 +5654,7 @@ int hisi_qm_init(struct hisi_qm *qm)
 		goto err_free_qm_memory;
 
 	qm_cmd_init(qm);
+	hisi_mig_region_enable(qm);
 
 	return 0;
 
@@ -5767,6 +5793,7 @@ static int qm_rebuild_for_resume(struct hisi_qm *qm)
 	}
 
 	qm_cmd_init(qm);
+	hisi_mig_region_enable(qm);
 	hisi_qm_dev_err_init(qm);
 	/* Set the doorbell timeout to QM_DB_TIMEOUT_CFG ns. */
 	writel(QM_DB_TIMEOUT_SET, qm->io_base + QM_DB_TIMEOUT_CFG);
diff --git a/include/linux/hisi_acc_qm.h b/include/linux/hisi_acc_qm.h
index 0c4c84b8c3be..b3c01815aab0 100644
--- a/include/linux/hisi_acc_qm.h
+++ b/include/linux/hisi_acc_qm.h
@@ -99,6 +99,9 @@
 
 #define QM_DEV_ALG_MAX_LEN		256
 
+#define QM_MIG_REGION_SEL		0x100198
+#define QM_MIG_REGION_EN		0x1
+
 /* uacce mode of the driver */
 #define UACCE_MODE_NOUACCE		0 /* don't use uacce */
 #define UACCE_MODE_SVA			1 /* use uacce sva mode */
-- 
2.33.0


