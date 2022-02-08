Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBA044ADA08
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 14:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352731AbiBHNgz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 08:36:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbiBHNgv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 08:36:51 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F9FC03FEDA;
        Tue,  8 Feb 2022 05:36:51 -0800 (PST)
Received: from fraeml735-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JtP7942wcz685QH;
        Tue,  8 Feb 2022 21:31:49 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml735-chm.china.huawei.com (10.206.15.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Feb 2022 14:36:49 +0100
Received: from A2006125610.china.huawei.com (10.202.227.178) by
 lhreml710-chm.china.huawei.com (10.201.108.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Feb 2022 13:36:42 +0000
From:   Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
CC:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <cohuck@redhat.com>, <mgurtovoy@nvidia.com>, <yishaih@nvidia.com>,
        <linuxarm@huawei.com>, <liulongfang@huawei.com>,
        <prime.zeng@hisilicon.com>, <jonathan.cameron@huawei.com>,
        <wangzhou1@hisilicon.com>
Subject: [RFC v4 6/8] crypto: hisilicon/qm: Add helper to retrieve the PF qm data
Date:   Tue, 8 Feb 2022 13:34:23 +0000
Message-ID: <20220208133425.1096-7-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20220208133425.1096-1-shameerali.kolothum.thodi@huawei.com>
References: <20220208133425.1096-1-shameerali.kolothum.thodi@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.202.227.178]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Provides a new interface to retrieve the PF QM data associated
with a ACC VF dev. This makes use of the  pci_iov_get_pf_drvdata()
to get PF drvdata safely. Introduces helpers to retrieve the ACC
PF dev struct pci_driver pointers as this is an input into the
pci_iov_get_pf_drvdata().

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c |  6 ++++
 drivers/crypto/hisilicon/qm.c             | 38 +++++++++++++++++++++++
 drivers/crypto/hisilicon/sec2/sec_main.c  |  6 ++++
 drivers/crypto/hisilicon/zip/zip_main.c   |  6 ++++
 include/linux/hisi_acc_qm.h               |  6 ++++
 5 files changed, 62 insertions(+)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index ba4043447e53..80fb9ef8c571 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -1189,6 +1189,12 @@ static struct pci_driver hpre_pci_driver = {
 	.driver.pm		= &hpre_pm_ops,
 };
 
+struct pci_driver *hisi_hpre_get_pf_driver(void)
+{
+	return &hpre_pci_driver;
+}
+EXPORT_SYMBOL(hisi_hpre_get_pf_driver);
+
 static void hpre_register_debugfs(void)
 {
 	if (!debugfs_initialized())
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 8c29f9fba573..b2858a6f925a 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -5999,6 +5999,44 @@ void hisi_qm_put_dfx_access(struct hisi_qm *qm)
 }
 EXPORT_SYMBOL_GPL(hisi_qm_put_dfx_access);
 
+struct hisi_qm *hisi_qm_get_pf_qm(struct pci_dev *pdev)
+{
+	struct hisi_qm	*pf_qm;
+	struct pci_driver *(*fn)(void) = NULL;
+
+	if (!pdev->is_virtfn)
+		return NULL;
+
+	switch (pdev->device) {
+	case PCI_DEVICE_ID_HUAWEI_SEC_VF:
+		fn = symbol_get(hisi_sec_get_pf_driver);
+		break;
+	case PCI_DEVICE_ID_HUAWEI_HPRE_VF:
+		fn = symbol_get(hisi_hpre_get_pf_driver);
+		break;
+	case PCI_DEVICE_ID_HUAWEI_ZIP_VF:
+		fn = symbol_get(hisi_zip_get_pf_driver);
+		break;
+	default:
+		return NULL;
+	}
+
+	if (!fn)
+		return NULL;
+
+	pf_qm = pci_iov_get_pf_drvdata(pdev, fn());
+
+	if (pdev->device == PCI_DEVICE_ID_HUAWEI_SEC_VF)
+		symbol_put(hisi_sec_get_pf_driver);
+	else if (pdev->device == PCI_DEVICE_ID_HUAWEI_HPRE_VF)
+		symbol_put(hisi_hpre_get_pf_driver);
+	else
+		symbol_put(hisi_zip_get_pf_driver);
+
+	return !IS_ERR(pf_qm) ? pf_qm : NULL;
+}
+EXPORT_SYMBOL_GPL(hisi_qm_get_pf_qm);
+
 /**
  * hisi_qm_pm_init() - Initialize qm runtime PM.
  * @qm: pointer to accelerator device.
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index ab806fb481ac..d8fb5c2b3482 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -1087,6 +1087,12 @@ static struct pci_driver sec_pci_driver = {
 	.driver.pm = &sec_pm_ops,
 };
 
+struct pci_driver *hisi_sec_get_pf_driver(void)
+{
+	return &sec_pci_driver;
+}
+EXPORT_SYMBOL(hisi_sec_get_pf_driver);
+
 static void sec_register_debugfs(void)
 {
 	if (!debugfs_initialized())
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index f4a517728385..b6ccc7e8f37e 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -1010,6 +1010,12 @@ static struct pci_driver hisi_zip_pci_driver = {
 	.driver.pm		= &hisi_zip_pm_ops,
 };
 
+struct pci_driver *hisi_zip_get_pf_driver(void)
+{
+	return &hisi_zip_pci_driver;
+}
+EXPORT_SYMBOL(hisi_zip_get_pf_driver);
+
 static void hisi_zip_register_debugfs(void)
 {
 	if (!debugfs_initialized())
diff --git a/include/linux/hisi_acc_qm.h b/include/linux/hisi_acc_qm.h
index 8befb59c6fb3..6dbc5df2923b 100644
--- a/include/linux/hisi_acc_qm.h
+++ b/include/linux/hisi_acc_qm.h
@@ -476,4 +476,10 @@ void hisi_qm_pm_init(struct hisi_qm *qm);
 int hisi_qm_get_dfx_access(struct hisi_qm *qm);
 void hisi_qm_put_dfx_access(struct hisi_qm *qm);
 void hisi_qm_regs_dump(struct seq_file *s, struct debugfs_regset32 *regset);
+
+/* Used by VFIO ACC live migration driver */
+struct hisi_qm *hisi_qm_get_pf_qm(struct pci_dev *pdev);
+struct pci_driver *hisi_sec_get_pf_driver(void);
+struct pci_driver *hisi_hpre_get_pf_driver(void);
+struct pci_driver *hisi_zip_get_pf_driver(void);
 #endif
-- 
2.17.1

