Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D52A23B9EBF
	for <lists+kvm@lfdr.de>; Fri,  2 Jul 2021 12:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbhGBKCV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 06:02:21 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3345 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231800AbhGBKCR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 06:02:17 -0400
Received: from fraeml737-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GGVfK0tKFz6GBCj;
        Fri,  2 Jul 2021 17:49:13 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml737-chm.china.huawei.com (10.206.15.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 2 Jul 2021 11:59:43 +0200
Received: from A2006125610.china.huawei.com (10.47.85.147) by
 lhreml710-chm.china.huawei.com (10.201.108.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 2 Jul 2021 10:59:37 +0100
From:   Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
CC:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <mgurtovoy@nvidia.com>, <linuxarm@huawei.com>,
        <liulongfang@huawei.com>, <prime.zeng@hisilicon.com>,
        <yuzenghui@huawei.com>, <jonathan.cameron@huawei.com>,
        <wangzhou1@hisilicon.com>
Subject: [RFC v2 3/4] crypto: hisilicon/qm - Export mailbox functions for common use
Date:   Fri, 2 Jul 2021 10:58:48 +0100
Message-ID: <20210702095849.1610-4-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20210702095849.1610-1-shameerali.kolothum.thodi@huawei.com>
References: <20210702095849.1610-1-shameerali.kolothum.thodi@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.47.85.147]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Longfang Liu <liulongfang@huawei.com>

Export QM mailbox functions so that they can be used from HiSilicon
ACC vfio live migration driver in follow-up patch.

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 8 +++++---
 drivers/crypto/hisilicon/qm.h | 4 ++++
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index ce439a0c66c9..87fc0199705e 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -492,7 +492,7 @@ static bool qm_qp_avail_state(struct hisi_qm *qm, struct hisi_qp *qp,
 }
 
 /* return 0 mailbox ready, -ETIMEDOUT hardware timeout */
-static int qm_wait_mb_ready(struct hisi_qm *qm)
+int qm_wait_mb_ready(struct hisi_qm *qm)
 {
 	u32 val;
 
@@ -500,6 +500,7 @@ static int qm_wait_mb_ready(struct hisi_qm *qm)
 					  val, !((val >> QM_MB_BUSY_SHIFT) &
 					  0x1), POLL_PERIOD, POLL_TIMEOUT);
 }
+EXPORT_SYMBOL_GPL(qm_wait_mb_ready);
 
 /* 128 bit should be written to hardware at one time to trigger a mailbox */
 static void qm_mb_write(struct hisi_qm *qm, const void *src)
@@ -523,8 +524,8 @@ static void qm_mb_write(struct hisi_qm *qm, const void *src)
 		     : "memory");
 }
 
-static int qm_mb(struct hisi_qm *qm, u8 cmd, dma_addr_t dma_addr, u16 queue,
-		 bool op)
+int qm_mb(struct hisi_qm *qm, u8 cmd, dma_addr_t dma_addr, u16 queue,
+	  bool op)
 {
 	struct qm_mailbox mailbox;
 	int ret = 0;
@@ -563,6 +564,7 @@ static int qm_mb(struct hisi_qm *qm, u8 cmd, dma_addr_t dma_addr, u16 queue,
 		atomic64_inc(&qm->debug.dfx.mb_err_cnt);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(qm_mb);
 
 static void qm_db_v1(struct hisi_qm *qm, u16 qn, u8 cmd, u16 index, u8 priority)
 {
diff --git a/drivers/crypto/hisilicon/qm.h b/drivers/crypto/hisilicon/qm.h
index acefdf8b3a50..18b010d5452d 100644
--- a/drivers/crypto/hisilicon/qm.h
+++ b/drivers/crypto/hisilicon/qm.h
@@ -396,6 +396,10 @@ pci_ers_result_t hisi_qm_dev_slot_reset(struct pci_dev *pdev);
 void hisi_qm_reset_prepare(struct pci_dev *pdev);
 void hisi_qm_reset_done(struct pci_dev *pdev);
 
+int qm_wait_mb_ready(struct hisi_qm *qm);
+int qm_mb(struct hisi_qm *qm, u8 cmd, dma_addr_t dma_addr, u16 queue,
+	  bool op);
+
 struct hisi_acc_sgl_pool;
 struct hisi_acc_hw_sgl *hisi_acc_sg_buf_map_to_hw_sgl(struct device *dev,
 	struct scatterlist *sgl, struct hisi_acc_sgl_pool *pool,
-- 
2.17.1

