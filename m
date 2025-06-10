Return-Path: <kvm+bounces-48790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9ECF1AD2E01
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 08:34:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 657E016C830
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 06:34:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A620279785;
	Tue, 10 Jun 2025 06:34:41 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC41121C9F7;
	Tue, 10 Jun 2025 06:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749537281; cv=none; b=If80BmOc4khMLflljqLDVesvYaQYN8cWx9l6iBu5LMleDYdiJlaW8rvxavDVPOrurexfrOYFKwTXfCP7wvTGFth3E1OvboGJXUQlHDFJTzZlX9SpByFiVufZ9j3OO2uHwn6fkOG2H1sY0H0NSkI+hkdzLOZUxP1/P55izFRjILU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749537281; c=relaxed/simple;
	bh=nPgidSGebTL16iwfoShmFFKxM63JCoP3soHIhlPSKss=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cFpoXIJHG9R5tXhRdyy7xx+B8xY1gSdqTlzXIv8NqIi2UDfpoN/hLroF6Rjsq7AbUxaiC/bvm9zCY5MqB2IMKelpaiOmW5Ktpbc3XCiRIXWXdr1uTkpU8cBv4f8nSveZfbyHfuIGAMyRZmOkOwj4NSQMq3fpiIndzpFvVnIYUec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4bGfB0149Qz2ZP60;
	Tue, 10 Jun 2025 14:33:12 +0800 (CST)
Received: from kwepemg500006.china.huawei.com (unknown [7.202.181.43])
	by mail.maildlp.com (Postfix) with ESMTPS id 84F87140277;
	Tue, 10 Jun 2025 14:34:29 +0800 (CST)
Received: from huawei.com (10.50.165.33) by kwepemg500006.china.huawei.com
 (7.202.181.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 10 Jun
 2025 14:34:28 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v4 2/3] migration: qm updates BAR configuration
Date: Tue, 10 Jun 2025 14:32:50 +0800
Message-ID: <20250610063251.27526-3-liulongfang@huawei.com>
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
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemg500006.china.huawei.com (7.202.181.43)

On the new hardware platform, the configuration region for the
live migration function of the accelerator device is no longer
placed in the VF, but is instead placed in the PF.

Therefore, the configuration region of the live migration function
needs to be opened when the QM driver is loaded. When the QM driver
is uninstalled, the driver needs to clear this configuration.

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index d3f5d108b898..0a8888304e15 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -242,6 +242,9 @@
 #define QM_QOS_MAX_CIR_U		6
 #define QM_AUTOSUSPEND_DELAY		3000
 
+#define QM_MIG_REGION_SEL		0x100198
+#define QM_MIG_REGION_EN		0x1
+
  /* abnormal status value for stopping queue */
 #define QM_STOP_QUEUE_FAIL		1
 #define	QM_DUMP_SQC_FAIL		3
@@ -3004,11 +3007,36 @@ static void qm_put_pci_res(struct hisi_qm *qm)
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
@@ -5630,6 +5658,7 @@ int hisi_qm_init(struct hisi_qm *qm)
 		goto err_free_qm_memory;
 
 	qm_cmd_init(qm);
+	hisi_mig_region_enable(qm);
 
 	return 0;
 
-- 
2.24.0


