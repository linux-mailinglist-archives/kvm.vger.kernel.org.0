Return-Path: <kvm+bounces-61389-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 335B2C1A7AA
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 14:03:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 41512587024
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 12:45:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A2053358CE;
	Wed, 29 Oct 2025 12:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="gpHV/DPp"
X-Original-To: kvm@vger.kernel.org
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B24F34F47A;
	Wed, 29 Oct 2025 12:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761740725; cv=none; b=Ux4H7tShU1crhqjXIsBIniigiV9H7uAEPEBRD2+sfoSjW5hz5GqHAdRMsX2hnOQ5as5r1JD0ZM715fIpAgMkuYWr+QPsR5pyoTmIn1GyzIG9/5ZqW2GEzIvD0UI3Ik+4Sp1Ai6eYq+M19PM6GQVwZNblrUn/zmz4JjzqydNRyHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761740725; c=relaxed/simple;
	bh=N0fKrga/9ZrRSK58UnOVSOIYKbAWXH05g1TXql8H/0A=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FoithHjAzWny72A/1WXC3QfhrxTVcU25b8nNrmIxL2PYAB8+6bZUDibBWZrb90rCxhmpDD5YrhtY0AJddxvZ2nYyXi8YTCa5kxvMdEyek52CgLlLNeSgjAzroALdxygOqyFSqPPM0cRotkpkTI72AijtGLzSBzXtbcxqzSGin3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=gpHV/DPp; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=4lZ7W/AJQKzFvzfkI8m0+Z5zcmH8GpfmoJ9YqHPB62E=;
	b=gpHV/DPpAbYD9zLwr7ZQC/BCYjmIolvdBIPYuhdO6OiUM8/VLWyqanWnaL+r1V77RHKiFEY1W
	t4gXl4kB3d2w+Ao4t9JZ7nLKc4uKTvaSDClc4/Fomn6s1eiM25hDaavwmvu/YDnqRMJ6hWvp14X
	EWHb0cC1DqV56kvL5roA56E=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4cxRJX508SzRhTt;
	Wed, 29 Oct 2025 20:24:44 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id E65B418048E;
	Wed, 29 Oct 2025 20:25:13 +0800 (CST)
Received: from huawei.com (10.90.31.46) by dggpemf500015.china.huawei.com
 (7.185.36.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 29 Oct
 2025 20:25:13 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<herbert@gondor.apana.org.au>, <shameerkolothum@gmail.com>,
	<jonathan.cameron@huawei.com>
CC: <linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>,
	<liulongfang@huawei.com>
Subject: [PATCH v11 1/2] crypto: hisilicon - qm updates BAR configuration
Date: Wed, 29 Oct 2025 20:24:40 +0800
Message-ID: <20251029122441.3063127-2-liulongfang@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20251029122441.3063127-1-liulongfang@huawei.com>
References: <20251029122441.3063127-1-liulongfang@huawei.com>
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
index a5b96adf2d1e..f0fd0c3698eb 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -3019,11 +3019,36 @@ static void qm_put_pci_res(struct hisi_qm *qm)
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
@@ -5725,6 +5750,7 @@ int hisi_qm_init(struct hisi_qm *qm)
 		goto err_free_qm_memory;
 
 	qm_cmd_init(qm);
+	hisi_mig_region_enable(qm);
 
 	return 0;
 
@@ -5863,6 +5889,7 @@ static int qm_rebuild_for_resume(struct hisi_qm *qm)
 	}
 
 	qm_cmd_init(qm);
+	hisi_mig_region_enable(qm);
 	hisi_qm_dev_err_init(qm);
 	/* Set the doorbell timeout to QM_DB_TIMEOUT_CFG ns. */
 	writel(QM_DB_TIMEOUT_SET, qm->io_base + QM_DB_TIMEOUT_CFG);
diff --git a/include/linux/hisi_acc_qm.h b/include/linux/hisi_acc_qm.h
index c4690e365ade..aa0129d20c51 100644
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


