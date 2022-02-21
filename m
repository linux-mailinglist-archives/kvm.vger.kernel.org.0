Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0C94BE8D3
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 19:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356664AbiBULmm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 06:42:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356655AbiBULmY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 06:42:24 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97B3B1C121;
        Mon, 21 Feb 2022 03:41:57 -0800 (PST)
Received: from fraeml702-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K2Kyy3gkYz67wfW;
        Mon, 21 Feb 2022 19:37:14 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml702-chm.china.huawei.com (10.206.15.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Mon, 21 Feb 2022 12:41:55 +0100
Received: from A2006125610.china.huawei.com (10.47.91.169) by
 lhreml710-chm.china.huawei.com (10.201.108.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 21 Feb 2022 11:41:49 +0000
From:   Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
CC:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <cohuck@redhat.com>, <mgurtovoy@nvidia.com>, <yishaih@nvidia.com>,
        <linuxarm@huawei.com>, <liulongfang@huawei.com>,
        <prime.zeng@hisilicon.com>, <jonathan.cameron@huawei.com>,
        <wangzhou1@hisilicon.com>
Subject: [PATCH v5 6/8] hisi_acc_vfio_pci: Add helper to retrieve the PF qm data
Date:   Mon, 21 Feb 2022 11:40:41 +0000
Message-ID: <20220221114043.2030-7-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20220221114043.2030-1-shameerali.kolothum.thodi@huawei.com>
References: <20220221114043.2030-1-shameerali.kolothum.thodi@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.47.91.169]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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

Provides a helper function to retrieve the PF QM data associated
with a ACC VF dev. This makes use of the  pci_iov_get_pf_drvdata()
to get PF drvdata safely. Introduces helpers to retrieve the ACC
PF dev struct pci_driver pointers as this is an input into the
pci_iov_get_pf_drvdata().

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c     |  6 ++++
 drivers/crypto/hisilicon/sec2/sec_main.c      |  6 ++++
 drivers/crypto/hisilicon/zip/zip_main.c       |  6 ++++
 drivers/vfio/pci/hisilicon/Kconfig            |  7 +++++
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 30 +++++++++++++++++++
 include/linux/hisi_acc_qm.h                   |  5 ++++
 6 files changed, 60 insertions(+)

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
diff --git a/drivers/vfio/pci/hisilicon/Kconfig b/drivers/vfio/pci/hisilicon/Kconfig
index d5acaf74a878..02811364a7a7 100644
--- a/drivers/vfio/pci/hisilicon/Kconfig
+++ b/drivers/vfio/pci/hisilicon/Kconfig
@@ -2,6 +2,13 @@
 config HISI_ACC_VFIO_PCI
 	tristate "VFIO PCI support for HiSilicon ACC devices"
 	depends on (ARM64 && VFIO_PCI_CORE) || (COMPILE_TEST && 64BIT)
+	depends on PCI && PCI_MSI
+	depends on UACCE || UACCE=n
+	depends on ACPI
+	select CRYPTO_DEV_HISI_QM
+	select CRYPTO_DEV_HISI_HPRE
+	select CRYPTO_DEV_HISI_SEC2
+	select CRYPTO_DEV_HISI_ZIP
 	help
 	  This provides generic PCI support for HiSilicon ACC devices
 	  using the VFIO framework.
diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index 585eb84684c9..9c87ab74bf7f 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -13,6 +13,36 @@
 #include <linux/vfio.h>
 #include <linux/vfio_pci_core.h>
 
+static struct hisi_qm *hisi_acc_get_pf_qm(struct pci_dev *pdev)
+{
+	struct hisi_qm	*pf_qm;
+	struct pci_driver *pf_driver;
+
+	if (!pdev->is_virtfn)
+		return NULL;
+
+	switch (pdev->device) {
+	case PCI_DEVICE_ID_HUAWEI_SEC_VF:
+		pf_driver = hisi_sec_get_pf_driver();
+		break;
+	case PCI_DEVICE_ID_HUAWEI_HPRE_VF:
+		pf_driver = hisi_hpre_get_pf_driver();
+		break;
+	case PCI_DEVICE_ID_HUAWEI_ZIP_VF:
+		pf_driver = hisi_zip_get_pf_driver();
+		break;
+	default:
+		return NULL;
+	}
+
+	if (!pf_driver)
+		return NULL;
+
+	pf_qm = pci_iov_get_pf_drvdata(pdev, pf_driver);
+
+	return !IS_ERR(pf_qm) ? pf_qm : NULL;
+}
+
 static int hisi_acc_pci_rw_access_check(struct vfio_device *core_vdev,
 					size_t count, loff_t *ppos,
 					size_t *new_count)
diff --git a/include/linux/hisi_acc_qm.h b/include/linux/hisi_acc_qm.h
index 5eb1e87ccd70..393ef17d306e 100644
--- a/include/linux/hisi_acc_qm.h
+++ b/include/linux/hisi_acc_qm.h
@@ -477,4 +477,9 @@ void hisi_qm_pm_init(struct hisi_qm *qm);
 int hisi_qm_get_dfx_access(struct hisi_qm *qm);
 void hisi_qm_put_dfx_access(struct hisi_qm *qm);
 void hisi_qm_regs_dump(struct seq_file *s, struct debugfs_regset32 *regset);
+
+/* Used by VFIO ACC live migration driver */
+struct pci_driver *hisi_sec_get_pf_driver(void);
+struct pci_driver *hisi_hpre_get_pf_driver(void);
+struct pci_driver *hisi_zip_get_pf_driver(void);
 #endif
-- 
2.25.1

