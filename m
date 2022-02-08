Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65D8D4AD9FD
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 14:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350353AbiBHNgY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 08:36:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351911AbiBHNgV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 08:36:21 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC097C03FEF3;
        Tue,  8 Feb 2022 05:36:18 -0800 (PST)
Received: from fraeml740-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JtPCW0sVyz67NvB;
        Tue,  8 Feb 2022 21:35:35 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml740-chm.china.huawei.com (10.206.15.221) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Feb 2022 14:36:17 +0100
Received: from A2006125610.china.huawei.com (10.202.227.178) by
 lhreml710-chm.china.huawei.com (10.201.108.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Feb 2022 13:36:10 +0000
From:   Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
CC:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <cohuck@redhat.com>, <mgurtovoy@nvidia.com>, <yishaih@nvidia.com>,
        <linuxarm@huawei.com>, <liulongfang@huawei.com>,
        <prime.zeng@hisilicon.com>, <jonathan.cameron@huawei.com>,
        <wangzhou1@hisilicon.com>
Subject: [RFC v4 2/8] crypto: hisilicon/qm: Move few definitions to common header
Date:   Tue, 8 Feb 2022 13:34:19 +0000
Message-ID: <20220208133425.1096-3-shameerali.kolothum.thodi@huawei.com>
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

From: Longfang Liu <liulongfang@huawei.com>

Move Doorbell and Mailbox definitions to common header
file. Also export QM mailbox functions.

This will be useful when we introduce VFIO PCI HiSilicon
ACC live migration driver.

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 32 +++++------------------------
 include/linux/hisi_acc_qm.h   | 38 +++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+), 27 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index ed23e1d3fa27..8c29f9fba573 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -33,23 +33,6 @@
 #define QM_ABNORMAL_EVENT_IRQ_VECTOR	3
 
 /* mailbox */
-#define QM_MB_CMD_SQC			0x0
-#define QM_MB_CMD_CQC			0x1
-#define QM_MB_CMD_EQC			0x2
-#define QM_MB_CMD_AEQC			0x3
-#define QM_MB_CMD_SQC_BT		0x4
-#define QM_MB_CMD_CQC_BT		0x5
-#define QM_MB_CMD_SQC_VFT_V2		0x6
-#define QM_MB_CMD_STOP_QP		0x8
-#define QM_MB_CMD_SRC			0xc
-#define QM_MB_CMD_DST			0xd
-
-#define QM_MB_CMD_SEND_BASE		0x300
-#define QM_MB_EVENT_SHIFT		8
-#define QM_MB_BUSY_SHIFT		13
-#define QM_MB_OP_SHIFT			14
-#define QM_MB_CMD_DATA_ADDR_L		0x304
-#define QM_MB_CMD_DATA_ADDR_H		0x308
 #define QM_MB_PING_ALL_VFS		0xffff
 #define QM_MB_CMD_DATA_SHIFT		32
 #define QM_MB_CMD_DATA_MASK		GENMASK(31, 0)
@@ -103,19 +86,12 @@
 #define QM_DB_CMD_SHIFT_V1		16
 #define QM_DB_INDEX_SHIFT_V1		32
 #define QM_DB_PRIORITY_SHIFT_V1		48
-#define QM_DOORBELL_SQ_CQ_BASE_V2	0x1000
-#define QM_DOORBELL_EQ_AEQ_BASE_V2	0x2000
 #define QM_QUE_ISO_CFG_V		0x0030
 #define QM_PAGE_SIZE			0x0034
 #define QM_QUE_ISO_EN			0x100154
 #define QM_CAPBILITY			0x100158
 #define QM_QP_NUN_MASK			GENMASK(10, 0)
 #define QM_QP_DB_INTERVAL		0x10000
-#define QM_QP_MAX_NUM_SHIFT		11
-#define QM_DB_CMD_SHIFT_V2		12
-#define QM_DB_RAND_SHIFT_V2		16
-#define QM_DB_INDEX_SHIFT_V2		32
-#define QM_DB_PRIORITY_SHIFT_V2		48
 
 #define QM_MEM_START_INIT		0x100040
 #define QM_MEM_INIT_DONE		0x100044
@@ -693,7 +669,7 @@ static void qm_mb_pre_init(struct qm_mailbox *mailbox, u8 cmd,
 }
 
 /* return 0 mailbox ready, -ETIMEDOUT hardware timeout */
-static int qm_wait_mb_ready(struct hisi_qm *qm)
+int qm_wait_mb_ready(struct hisi_qm *qm)
 {
 	u32 val;
 
@@ -701,6 +677,7 @@ static int qm_wait_mb_ready(struct hisi_qm *qm)
 					  val, !((val >> QM_MB_BUSY_SHIFT) &
 					  0x1), POLL_PERIOD, POLL_TIMEOUT);
 }
+EXPORT_SYMBOL_GPL(qm_wait_mb_ready);
 
 /* 128 bit should be written to hardware at one time to trigger a mailbox */
 static void qm_mb_write(struct hisi_qm *qm, const void *src)
@@ -745,8 +722,8 @@ static int qm_mb_nolock(struct hisi_qm *qm, struct qm_mailbox *mailbox)
 	return -EBUSY;
 }
 
-static int qm_mb(struct hisi_qm *qm, u8 cmd, dma_addr_t dma_addr, u16 queue,
-		 bool op)
+int qm_mb(struct hisi_qm *qm, u8 cmd, dma_addr_t dma_addr, u16 queue,
+	  bool op)
 {
 	struct qm_mailbox mailbox;
 	int ret;
@@ -762,6 +739,7 @@ static int qm_mb(struct hisi_qm *qm, u8 cmd, dma_addr_t dma_addr, u16 queue,
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(qm_mb);
 
 static void qm_db_v1(struct hisi_qm *qm, u16 qn, u8 cmd, u16 index, u8 priority)
 {
diff --git a/include/linux/hisi_acc_qm.h b/include/linux/hisi_acc_qm.h
index 3068093229a5..8befb59c6fb3 100644
--- a/include/linux/hisi_acc_qm.h
+++ b/include/linux/hisi_acc_qm.h
@@ -34,6 +34,40 @@
 #define QM_WUSER_M_CFG_ENABLE		0x1000a8
 #define WUSER_M_CFG_ENABLE		0xffffffff
 
+/* mailbox */
+#define QM_MB_CMD_SQC                   0x0
+#define QM_MB_CMD_CQC                   0x1
+#define QM_MB_CMD_EQC                   0x2
+#define QM_MB_CMD_AEQC                  0x3
+#define QM_MB_CMD_SQC_BT                0x4
+#define QM_MB_CMD_CQC_BT                0x5
+#define QM_MB_CMD_SQC_VFT_V2            0x6
+#define QM_MB_CMD_STOP_QP               0x8
+#define QM_MB_CMD_SRC                   0xc
+#define QM_MB_CMD_DST                   0xd
+
+#define QM_MB_CMD_SEND_BASE		0x300
+#define QM_MB_EVENT_SHIFT               8
+#define QM_MB_BUSY_SHIFT		13
+#define QM_MB_OP_SHIFT			14
+#define QM_MB_CMD_DATA_ADDR_L		0x304
+#define QM_MB_CMD_DATA_ADDR_H		0x308
+#define QM_MB_MAX_WAIT_CNT		6000
+
+/* doorbell */
+#define QM_DOORBELL_CMD_SQ              0
+#define QM_DOORBELL_CMD_CQ              1
+#define QM_DOORBELL_CMD_EQ              2
+#define QM_DOORBELL_CMD_AEQ             3
+
+#define QM_DOORBELL_SQ_CQ_BASE_V2	0x1000
+#define QM_DOORBELL_EQ_AEQ_BASE_V2	0x2000
+#define QM_QP_MAX_NUM_SHIFT             11
+#define QM_DB_CMD_SHIFT_V2		12
+#define QM_DB_RAND_SHIFT_V2		16
+#define QM_DB_INDEX_SHIFT_V2		32
+#define QM_DB_PRIORITY_SHIFT_V2		48
+
 /* qm cache */
 #define QM_CACHE_CTL			0x100050
 #define SQC_CACHE_ENABLE		BIT(0)
@@ -414,6 +448,10 @@ pci_ers_result_t hisi_qm_dev_slot_reset(struct pci_dev *pdev);
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

