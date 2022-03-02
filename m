Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59ED94CABF4
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 18:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244015AbiCBRbv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 12:31:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244067AbiCBRbd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 12:31:33 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF041D3AC3;
        Wed,  2 Mar 2022 09:30:40 -0800 (PST)
Received: from fraeml741-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K81M94xFQz67Ns0;
        Thu,  3 Mar 2022 01:29:25 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml741-chm.china.huawei.com (10.206.15.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 2 Mar 2022 18:30:38 +0100
Received: from A2006125610.china.huawei.com (10.47.91.128) by
 lhreml710-chm.china.huawei.com (10.201.108.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 2 Mar 2022 17:30:31 +0000
From:   Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
CC:     <linux-pci@vger.kernel.org>, <alex.williamson@redhat.com>,
        <jgg@nvidia.com>, <cohuck@redhat.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <linuxarm@huawei.com>,
        <liulongfang@huawei.com>, <prime.zeng@hisilicon.com>,
        <jonathan.cameron@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH v7 06/10] hisi_acc_vfio_pci: Add helper to retrieve the struct pci_driver
Date:   Wed, 2 Mar 2022 17:28:59 +0000
Message-ID: <20220302172903.1995-7-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20220302172903.1995-1-shameerali.kolothum.thodi@huawei.com>
References: <20220302172903.1995-1-shameerali.kolothum.thodi@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.47.91.128]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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

struct pci_driver pointer is an input into the pci_iov_get_pf_drvdata().
Introduce helpers to retrieve the ACC PF dev struct pci_driver pointers
as we use this in ACC vfio migration driver.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c | 6 ++++++
 drivers/crypto/hisilicon/sec2/sec_main.c  | 6 ++++++
 drivers/crypto/hisilicon/zip/zip_main.c   | 6 ++++++
 include/linux/hisi_acc_qm.h               | 5 +++++
 4 files changed, 23 insertions(+)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 3589d8879b5e..36ab30e9e654 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -1190,6 +1190,12 @@ static struct pci_driver hpre_pci_driver = {
 	.driver.pm		= &hpre_pm_ops,
 };
 
+struct pci_driver *hisi_hpre_get_pf_driver(void)
+{
+	return &hpre_pci_driver;
+}
+EXPORT_SYMBOL_GPL(hisi_hpre_get_pf_driver);
+
 static void hpre_register_debugfs(void)
 {
 	if (!debugfs_initialized())
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 311a8747b5bf..421a405ca337 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -1088,6 +1088,12 @@ static struct pci_driver sec_pci_driver = {
 	.driver.pm = &sec_pm_ops,
 };
 
+struct pci_driver *hisi_sec_get_pf_driver(void)
+{
+	return &sec_pci_driver;
+}
+EXPORT_SYMBOL_GPL(hisi_sec_get_pf_driver);
+
 static void sec_register_debugfs(void)
 {
 	if (!debugfs_initialized())
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 66decfe07282..4534e1e107d1 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -1012,6 +1012,12 @@ static struct pci_driver hisi_zip_pci_driver = {
 	.driver.pm		= &hisi_zip_pm_ops,
 };
 
+struct pci_driver *hisi_zip_get_pf_driver(void)
+{
+	return &hisi_zip_pci_driver;
+}
+EXPORT_SYMBOL_GPL(hisi_zip_get_pf_driver);
+
 static void hisi_zip_register_debugfs(void)
 {
 	if (!debugfs_initialized())
diff --git a/include/linux/hisi_acc_qm.h b/include/linux/hisi_acc_qm.h
index 8befb59c6fb3..70706c1fb7b6 100644
--- a/include/linux/hisi_acc_qm.h
+++ b/include/linux/hisi_acc_qm.h
@@ -476,4 +476,9 @@ void hisi_qm_pm_init(struct hisi_qm *qm);
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

