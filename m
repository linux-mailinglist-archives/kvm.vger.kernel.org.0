Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 854824CABEB
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 18:31:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235534AbiCBRcQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 12:32:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244085AbiCBRb6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 12:31:58 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D76B7D5576;
        Wed,  2 Mar 2022 09:30:56 -0800 (PST)
Received: from fraeml740-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K81MT4LVhz67ybq;
        Thu,  3 Mar 2022 01:29:41 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml740-chm.china.huawei.com (10.206.15.221) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 2 Mar 2022 18:30:54 +0100
Received: from A2006125610.china.huawei.com (10.47.91.128) by
 lhreml710-chm.china.huawei.com (10.201.108.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 2 Mar 2022 17:30:47 +0000
From:   Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
CC:     <linux-pci@vger.kernel.org>, <alex.williamson@redhat.com>,
        <jgg@nvidia.com>, <cohuck@redhat.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <linuxarm@huawei.com>,
        <liulongfang@huawei.com>, <prime.zeng@hisilicon.com>,
        <jonathan.cameron@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH v7 08/10] crypto: hisilicon/qm: Set the VF QM state register
Date:   Wed, 2 Mar 2022 17:29:01 +0000
Message-ID: <20220302172903.1995-9-shameerali.kolothum.thodi@huawei.com>
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

From: Longfang Liu <liulongfang@huawei.com>

We use VF QM state register to record the status of the QM configuration
state. This will be used in the ACC migration driver to determine whether
we can safely save and restore the QM data.

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 8 ++++++++
 include/linux/hisi_acc_qm.h   | 6 ++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 8c29f9fba573..5a0ac6cb6eeb 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -3492,6 +3492,12 @@ static void hisi_qm_pci_uninit(struct hisi_qm *qm)
 	pci_disable_device(pdev);
 }
 
+static void hisi_qm_set_state(struct hisi_qm *qm, u8 state)
+{
+	if (qm->ver > QM_HW_V2 && qm->fun_type == QM_HW_VF)
+		writel(state, qm->io_base + QM_VF_STATE);
+}
+
 /**
  * hisi_qm_uninit() - Uninitialize qm.
  * @qm: The qm needed uninit.
@@ -3520,6 +3526,7 @@ void hisi_qm_uninit(struct hisi_qm *qm)
 		dma_free_coherent(dev, qm->qdma.size,
 				  qm->qdma.va, qm->qdma.dma);
 	}
+	hisi_qm_set_state(qm, QM_NOT_READY);
 	up_write(&qm->qps_lock);
 
 	qm_irq_unregister(qm);
@@ -3745,6 +3752,7 @@ int hisi_qm_start(struct hisi_qm *qm)
 	if (!ret)
 		atomic_set(&qm->status.flags, QM_START);
 
+	hisi_qm_set_state(qm, QM_READY);
 err_unlock:
 	up_write(&qm->qps_lock);
 	return ret;
diff --git a/include/linux/hisi_acc_qm.h b/include/linux/hisi_acc_qm.h
index 70706c1fb7b6..cae3e02ce23e 100644
--- a/include/linux/hisi_acc_qm.h
+++ b/include/linux/hisi_acc_qm.h
@@ -67,6 +67,7 @@
 #define QM_DB_RAND_SHIFT_V2		16
 #define QM_DB_INDEX_SHIFT_V2		32
 #define QM_DB_PRIORITY_SHIFT_V2		48
+#define QM_VF_STATE			0x60
 
 /* qm cache */
 #define QM_CACHE_CTL			0x100050
@@ -162,6 +163,11 @@ enum qm_debug_file {
 	DEBUG_FILE_NUM,
 };
 
+enum qm_vf_state {
+	QM_READY = 0,
+	QM_NOT_READY,
+};
+
 struct qm_dfx {
 	atomic64_t err_irq_cnt;
 	atomic64_t aeq_irq_cnt;
-- 
2.25.1

