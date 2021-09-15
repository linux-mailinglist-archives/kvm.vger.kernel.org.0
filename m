Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC0640C301
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 11:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237379AbhIOJwr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Sep 2021 05:52:47 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3816 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237370AbhIOJwi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Sep 2021 05:52:38 -0400
Received: from fraeml737-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4H8b5W1fG7z67yhZ;
        Wed, 15 Sep 2021 17:49:03 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml737-chm.china.huawei.com (10.206.15.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 15 Sep 2021 11:51:17 +0200
Received: from A2006125610.china.huawei.com (10.47.83.177) by
 lhreml710-chm.china.huawei.com (10.201.108.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 15 Sep 2021 10:51:11 +0100
From:   Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
CC:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <mgurtovoy@nvidia.com>, <linuxarm@huawei.com>,
        <liulongfang@huawei.com>, <prime.zeng@hisilicon.com>,
        <jonathan.cameron@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH v3 2/6] crypto: hisilicon/qm: Move few definitions to common header
Date:   Wed, 15 Sep 2021 10:50:33 +0100
Message-ID: <20210915095037.1149-3-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20210915095037.1149-1-shameerali.kolothum.thodi@huawei.com>
References: <20210915095037.1149-1-shameerali.kolothum.thodi@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.47.83.177]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected
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
index e791a4fe47bc..1a16a2e0af12 100644
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
@@ -99,19 +82,12 @@
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
@@ -596,7 +572,7 @@ static void qm_mb_pre_init(struct qm_mailbox *mailbox, u8 cmd,
 }
 
 /* return 0 mailbox ready, -ETIMEDOUT hardware timeout */
-static int qm_wait_mb_ready(struct hisi_qm *qm)
+int qm_wait_mb_ready(struct hisi_qm *qm)
 {
 	u32 val;
 
@@ -604,6 +580,7 @@ static int qm_wait_mb_ready(struct hisi_qm *qm)
 					  val, !((val >> QM_MB_BUSY_SHIFT) &
 					  0x1), POLL_PERIOD, POLL_TIMEOUT);
 }
+EXPORT_SYMBOL_GPL(qm_wait_mb_ready);
 
 /* 128 bit should be written to hardware at one time to trigger a mailbox */
 static void qm_mb_write(struct hisi_qm *qm, const void *src)
@@ -648,8 +625,8 @@ static int qm_mb_nolock(struct hisi_qm *qm, struct qm_mailbox *mailbox)
 	return -EBUSY;
 }
 
-static int qm_mb(struct hisi_qm *qm, u8 cmd, dma_addr_t dma_addr, u16 queue,
-		 bool op)
+int qm_mb(struct hisi_qm *qm, u8 cmd, dma_addr_t dma_addr, u16 queue,
+	  bool op)
 {
 	struct qm_mailbox mailbox;
 	int ret;
@@ -665,6 +642,7 @@ static int qm_mb(struct hisi_qm *qm, u8 cmd, dma_addr_t dma_addr, u16 queue,
 
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

