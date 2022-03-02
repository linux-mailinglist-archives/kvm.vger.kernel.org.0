Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0BB4CABF3
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 18:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244100AbiCBRc2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 12:32:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244109AbiCBRcG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 12:32:06 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4CAED0481;
        Wed,  2 Mar 2022 09:31:04 -0800 (PST)
Received: from fraeml738-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K81Nt2QlQz67xfM;
        Thu,  3 Mar 2022 01:30:54 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml738-chm.china.huawei.com (10.206.15.219) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 2 Mar 2022 18:31:02 +0100
Received: from A2006125610.china.huawei.com (10.47.91.128) by
 lhreml710-chm.china.huawei.com (10.201.108.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 2 Mar 2022 17:30:55 +0000
From:   Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
CC:     <linux-pci@vger.kernel.org>, <alex.williamson@redhat.com>,
        <jgg@nvidia.com>, <cohuck@redhat.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <linuxarm@huawei.com>,
        <liulongfang@huawei.com>, <prime.zeng@hisilicon.com>,
        <jonathan.cameron@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH v7 09/10] hisi_acc_vfio_pci: Add support for VFIO live migration
Date:   Wed, 2 Mar 2022 17:29:02 +0000
Message-ID: <20220302172903.1995-10-shameerali.kolothum.thodi@huawei.com>
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

VMs assigned with HiSilicon ACC VF devices can now perform live migration
if the VF devices are bind to the hisi_acc_vfio_pci driver.

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 drivers/vfio/pci/hisilicon/Kconfig            |    7 +
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 1128 ++++++++++++++++-
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  112 ++
 3 files changed, 1229 insertions(+), 18 deletions(-)
 create mode 100644 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h

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
index 582ee4fa4109..f733aa0b1a5b 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -12,6 +12,1039 @@
 #include <linux/pci.h>
 #include <linux/vfio.h>
 #include <linux/vfio_pci_core.h>
+#include <linux/anon_inodes.h>
+
+#include "hisi_acc_vfio_pci.h"
+
+/* return 0 on VM acc device ready, -ETIMEDOUT hardware timeout */
+static int qm_wait_dev_not_ready(struct hisi_qm *qm)
+{
+	u32 val;
+
+	return readl_relaxed_poll_timeout(qm->io_base + QM_VF_STATE,
+				val, !(val & 0x1), MB_POLL_PERIOD_US,
+				MB_POLL_TIMEOUT_US);
+}
+
+/*
+ * Each state Reg is checked 100 times,
+ * with a delay of 100 microseconds after each check
+ */
+static u32 acc_check_reg_state(struct hisi_qm *qm, u32 regs)
+{
+	int check_times = 0;
+	u32 state;
+
+	state = readl(qm->io_base + regs);
+	while (state && check_times < ERROR_CHECK_TIMEOUT) {
+		udelay(CHECK_DELAY_TIME);
+		state = readl(qm->io_base + regs);
+		check_times++;
+	}
+
+	return state;
+}
+
+/* Check the PF's RAS state and Function INT state */
+static int qm_check_int_state(struct hisi_acc_vf_core_device *hisi_acc_vdev)
+{
+	struct hisi_qm *vfqm = &hisi_acc_vdev->vf_qm;
+	struct hisi_qm *qm = hisi_acc_vdev->pf_qm;
+	struct pci_dev *vf_pdev = hisi_acc_vdev->vf_dev;
+	struct device *dev = &qm->pdev->dev;
+	u32 state;
+
+	/* Check RAS state */
+	state = acc_check_reg_state(qm, QM_ABNORMAL_INT_STATUS);
+	if (state) {
+		dev_err(dev, "failed to check QM RAS state!\n");
+		return -EBUSY;
+	}
+
+	/* Check Function Communication state between PF and VF */
+	state = acc_check_reg_state(vfqm, QM_IFC_INT_STATUS);
+	if (state) {
+		dev_err(dev, "failed to check QM IFC INT state!\n");
+		return -EBUSY;
+	}
+	state = acc_check_reg_state(vfqm, QM_IFC_INT_SET_V);
+	if (state) {
+		dev_err(dev, "failed to check QM IFC INT SET state!\n");
+		return -EBUSY;
+	}
+
+	/* Check submodule task state */
+	switch (vf_pdev->device) {
+	case PCI_DEVICE_ID_HUAWEI_SEC_VF:
+		state = acc_check_reg_state(qm, SEC_CORE_INT_STATUS);
+		if (state) {
+			dev_err(dev, "failed to check QM SEC Core INT state!\n");
+			return -EBUSY;
+		}
+		return 0;
+	case PCI_DEVICE_ID_HUAWEI_HPRE_VF:
+		state = acc_check_reg_state(qm, HPRE_HAC_INT_STATUS);
+		if (state) {
+			dev_err(dev, "failed to check QM HPRE HAC INT state!\n");
+			return -EBUSY;
+		}
+		return 0;
+	case PCI_DEVICE_ID_HUAWEI_ZIP_VF:
+		state = acc_check_reg_state(qm, HZIP_CORE_INT_STATUS);
+		if (state) {
+			dev_err(dev, "failed to check QM ZIP Core INT state!\n");
+			return -EBUSY;
+		}
+		return 0;
+	default:
+		dev_err(dev, "failed to detect acc module type!\n");
+		return -EINVAL;
+	}
+}
+
+static int qm_read_reg(struct hisi_qm *qm, u32 reg_addr,
+		       u32 *data, u8 nums)
+{
+	int i;
+
+	if (nums < 1 || nums > QM_REGS_MAX_LEN)
+		return -EINVAL;
+
+	for (i = 0; i < nums; i++) {
+		data[i] = readl(qm->io_base + reg_addr);
+		reg_addr += QM_REG_ADDR_OFFSET;
+	}
+
+	return 0;
+}
+
+static int qm_write_reg(struct hisi_qm *qm, u32 reg,
+			u32 *data, u8 nums)
+{
+	int i;
+
+	if (nums < 1 || nums > QM_REGS_MAX_LEN)
+		return -EINVAL;
+
+	for (i = 0; i < nums; i++)
+		writel(data[i], qm->io_base + reg + i * QM_REG_ADDR_OFFSET);
+
+	return 0;
+}
+
+static int qm_get_vft(struct hisi_qm *qm, u32 *base)
+{
+	u64 sqc_vft;
+	u32 qp_num;
+	int ret;
+
+	ret = qm_mb(qm, QM_MB_CMD_SQC_VFT_V2, 0, 0, 1);
+	if (ret)
+		return ret;
+
+	sqc_vft = readl(qm->io_base + QM_MB_CMD_DATA_ADDR_L) |
+		  ((u64)readl(qm->io_base + QM_MB_CMD_DATA_ADDR_H) <<
+		  QM_XQC_ADDR_OFFSET);
+	*base = QM_SQC_VFT_BASE_MASK_V2 & (sqc_vft >> QM_SQC_VFT_BASE_SHIFT_V2);
+	qp_num = (QM_SQC_VFT_NUM_MASK_V2 &
+		  (sqc_vft >> QM_SQC_VFT_NUM_SHIFT_V2)) + 1;
+
+	return qp_num;
+}
+
+static int qm_get_sqc(struct hisi_qm *qm, u64 *addr)
+{
+	int ret;
+
+	ret = qm_mb(qm, QM_MB_CMD_SQC_BT, 0, 0, 1);
+	if (ret)
+		return ret;
+
+	*addr = readl(qm->io_base + QM_MB_CMD_DATA_ADDR_L) |
+		  ((u64)readl(qm->io_base + QM_MB_CMD_DATA_ADDR_H) <<
+		  QM_XQC_ADDR_OFFSET);
+
+	return 0;
+}
+
+static int qm_get_cqc(struct hisi_qm *qm, u64 *addr)
+{
+	int ret;
+
+	ret = qm_mb(qm, QM_MB_CMD_CQC_BT, 0, 0, 1);
+	if (ret)
+		return ret;
+
+	*addr = readl(qm->io_base + QM_MB_CMD_DATA_ADDR_L) |
+		  ((u64)readl(qm->io_base + QM_MB_CMD_DATA_ADDR_H) <<
+		  QM_XQC_ADDR_OFFSET);
+
+	return 0;
+}
+
+static int qm_rw_regs_read(struct hisi_qm *qm, struct acc_vf_data *vf_data)
+{
+	struct device *dev = &qm->pdev->dev;
+	int ret;
+
+	ret = qm_read_reg(qm, QM_VF_AEQ_INT_MASK, &vf_data->aeq_int_mask, 1);
+	if (ret) {
+		dev_err(dev, "failed to read QM_VF_AEQ_INT_MASK\n");
+		return ret;
+	}
+
+	ret = qm_read_reg(qm, QM_VF_EQ_INT_MASK, &vf_data->eq_int_mask, 1);
+	if (ret) {
+		dev_err(dev, "failed to read QM_VF_EQ_INT_MASK\n");
+		return ret;
+	}
+
+	ret = qm_read_reg(qm, QM_IFC_INT_SOURCE_V,
+			  &vf_data->ifc_int_source, 1);
+	if (ret) {
+		dev_err(dev, "failed to read QM_IFC_INT_SOURCE_V\n");
+		return ret;
+	}
+
+	ret = qm_read_reg(qm, QM_IFC_INT_MASK, &vf_data->ifc_int_mask, 1);
+	if (ret) {
+		dev_err(dev, "failed to read QM_IFC_INT_MASK\n");
+		return ret;
+	}
+
+	ret = qm_read_reg(qm, QM_IFC_INT_SET_V, &vf_data->ifc_int_set, 1);
+	if (ret) {
+		dev_err(dev, "failed to read QM_IFC_INT_SET_V\n");
+		return ret;
+	}
+
+	ret = qm_read_reg(qm, QM_PAGE_SIZE, &vf_data->page_size, 1);
+	if (ret) {
+		dev_err(dev, "failed to read QM_PAGE_SIZE\n");
+		return ret;
+	}
+
+	/* QM_EQC_DW has 7 regs */
+	ret = qm_read_reg(qm, QM_EQC_DW0, vf_data->qm_eqc_dw, 7);
+	if (ret) {
+		dev_err(dev, "failed to read QM_EQC_DW\n");
+		return ret;
+	}
+
+	/* QM_AEQC_DW has 7 regs */
+	ret = qm_read_reg(qm, QM_AEQC_DW0, vf_data->qm_aeqc_dw, 7);
+	if (ret) {
+		dev_err(dev, "failed to read QM_AEQC_DW\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int qm_rw_regs_write(struct hisi_qm *qm, struct acc_vf_data *vf_data)
+{
+	struct device *dev = &qm->pdev->dev;
+	int ret;
+
+	/* check VF state */
+	if (unlikely(qm_wait_mb_ready(qm))) {
+		dev_err(&qm->pdev->dev, "QM device is not ready to write\n");
+		return -EBUSY;
+	}
+
+	ret = qm_write_reg(qm, QM_VF_AEQ_INT_MASK, &vf_data->aeq_int_mask, 1);
+	if (ret) {
+		dev_err(dev, "failed to write QM_VF_AEQ_INT_MASK\n");
+		return ret;
+	}
+
+	ret = qm_write_reg(qm, QM_VF_EQ_INT_MASK, &vf_data->eq_int_mask, 1);
+	if (ret) {
+		dev_err(dev, "failed to write QM_VF_EQ_INT_MASK\n");
+		return ret;
+	}
+
+	ret = qm_write_reg(qm, QM_IFC_INT_SOURCE_V,
+			   &vf_data->ifc_int_source, 1);
+	if (ret) {
+		dev_err(dev, "failed to write QM_IFC_INT_SOURCE_V\n");
+		return ret;
+	}
+
+	ret = qm_write_reg(qm, QM_IFC_INT_MASK, &vf_data->ifc_int_mask, 1);
+	if (ret) {
+		dev_err(dev, "failed to write QM_IFC_INT_MASK\n");
+		return ret;
+	}
+
+	ret = qm_write_reg(qm, QM_IFC_INT_SET_V, &vf_data->ifc_int_set, 1);
+	if (ret) {
+		dev_err(dev, "failed to write QM_IFC_INT_SET_V\n");
+		return ret;
+	}
+
+	ret = qm_write_reg(qm, QM_QUE_ISO_CFG_V, &vf_data->que_iso_cfg, 1);
+	if (ret) {
+		dev_err(dev, "failed to write QM_QUE_ISO_CFG_V\n");
+		return ret;
+	}
+
+	ret = qm_write_reg(qm, QM_PAGE_SIZE, &vf_data->page_size, 1);
+	if (ret) {
+		dev_err(dev, "failed to write QM_PAGE_SIZE\n");
+		return ret;
+	}
+
+	/* QM_EQC_DW has 7 regs */
+	ret = qm_write_reg(qm, QM_EQC_DW0, vf_data->qm_eqc_dw, 7);
+	if (ret) {
+		dev_err(dev, "failed to write QM_EQC_DW\n");
+		return ret;
+	}
+
+	/* QM_AEQC_DW has 7 regs */
+	ret = qm_write_reg(qm, QM_AEQC_DW0, vf_data->qm_aeqc_dw, 7);
+	if (ret) {
+		dev_err(dev, "failed to write QM_AEQC_DW\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static void qm_db(struct hisi_qm *qm, u16 qn, u8 cmd,
+		  u16 index, u8 priority)
+{
+	u64 doorbell;
+	u64 dbase;
+	u16 randata = 0;
+
+	if (cmd == QM_DOORBELL_CMD_SQ || cmd == QM_DOORBELL_CMD_CQ)
+		dbase = QM_DOORBELL_SQ_CQ_BASE_V2;
+	else
+		dbase = QM_DOORBELL_EQ_AEQ_BASE_V2;
+
+	doorbell = qn | ((u64)cmd << QM_DB_CMD_SHIFT_V2) |
+		   ((u64)randata << QM_DB_RAND_SHIFT_V2) |
+		   ((u64)index << QM_DB_INDEX_SHIFT_V2)	 |
+		   ((u64)priority << QM_DB_PRIORITY_SHIFT_V2);
+
+	writeq(doorbell, qm->io_base + dbase);
+}
+
+static int pf_qm_get_qp_num(struct hisi_qm *qm, int vf_id, u32 *rbase)
+{
+	unsigned int val;
+	u64 sqc_vft;
+	u32 qp_num;
+	int ret;
+
+	ret = readl_relaxed_poll_timeout(qm->io_base + QM_VFT_CFG_RDY, val,
+					 val & BIT(0), MB_POLL_PERIOD_US,
+					 MB_POLL_TIMEOUT_US);
+	if (ret)
+		return ret;
+
+	writel(0x1, qm->io_base + QM_VFT_CFG_OP_WR);
+	/* 0 mean SQC VFT */
+	writel(0x0, qm->io_base + QM_VFT_CFG_TYPE);
+	writel(vf_id, qm->io_base + QM_VFT_CFG);
+
+	writel(0x0, qm->io_base + QM_VFT_CFG_RDY);
+	writel(0x1, qm->io_base + QM_VFT_CFG_OP_ENABLE);
+
+	ret = readl_relaxed_poll_timeout(qm->io_base + QM_VFT_CFG_RDY, val,
+					 val & BIT(0), MB_POLL_PERIOD_US,
+					 MB_POLL_TIMEOUT_US);
+	if (ret)
+		return ret;
+
+	sqc_vft = readl(qm->io_base + QM_VFT_CFG_DATA_L) |
+		  ((u64)readl(qm->io_base + QM_VFT_CFG_DATA_H) <<
+		  QM_XQC_ADDR_OFFSET);
+	*rbase = QM_SQC_VFT_BASE_MASK_V2 &
+		  (sqc_vft >> QM_SQC_VFT_BASE_SHIFT_V2);
+	qp_num = (QM_SQC_VFT_NUM_MASK_V2 &
+		  (sqc_vft >> QM_SQC_VFT_NUM_SHIFT_V2)) + 1;
+
+	return qp_num;
+}
+
+static void qm_dev_cmd_init(struct hisi_qm *qm)
+{
+	/* Clear VF communication status registers. */
+	writel(0x1, qm->io_base + QM_IFC_INT_SOURCE_V);
+
+	/* Enable pf and vf communication. */
+	writel(0x0, qm->io_base + QM_IFC_INT_MASK);
+}
+
+static int vf_qm_cache_wb(struct hisi_qm *qm)
+{
+	unsigned int val;
+
+	writel(0x1, qm->io_base + QM_CACHE_WB_START);
+	if (readl_relaxed_poll_timeout(qm->io_base + QM_CACHE_WB_DONE,
+				       val, val & BIT(0), MB_POLL_PERIOD_US,
+				       MB_POLL_TIMEOUT_US)) {
+		dev_err(&qm->pdev->dev, "vf QM writeback sqc cache fail\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void vf_qm_fun_reset(struct hisi_acc_vf_core_device *hisi_acc_vdev,
+			    struct hisi_qm *qm)
+{
+	int i;
+
+	for (i = 0; i < qm->qp_num; i++)
+		qm_db(qm, i, QM_DOORBELL_CMD_SQ, 0, 1);
+}
+
+static int vf_qm_func_stop(struct hisi_qm *qm)
+{
+	return qm_mb(qm, QM_MB_CMD_PAUSE_QM, 0, 0, 0);
+}
+
+static int vf_qm_check_match(struct hisi_acc_vf_core_device *hisi_acc_vdev,
+			     struct hisi_acc_vf_migration_file *migf)
+{
+	struct acc_vf_data *vf_data = &migf->vf_data;
+	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
+	struct hisi_qm *pf_qm = hisi_acc_vdev->pf_qm;
+	struct device *dev = &vf_qm->pdev->dev;
+	u32 que_iso_state;
+	int ret;
+
+	if (migf->total_length < QM_MATCH_SIZE || hisi_acc_vdev->match_done)
+		return 0;
+
+	/* vf acc dev type check */
+	if (vf_data->dev_id != hisi_acc_vdev->vf_dev->device) {
+		dev_err(dev, "failed to match VF devices\n");
+		return -EINVAL;
+	}
+
+	/* vf qp num check */
+	ret = qm_get_vft(vf_qm, &vf_qm->qp_base);
+	if (ret <= 0) {
+		dev_err(dev, "failed to get vft qp nums\n");
+		return -EINVAL;
+	}
+
+	if (ret != vf_data->qp_num) {
+		dev_err(dev, "failed to match VF qp num\n");
+		return -EINVAL;
+	}
+
+	vf_qm->qp_num = ret;
+
+	/* vf isolation state check */
+	ret = qm_read_reg(pf_qm, QM_QUE_ISO_CFG_V, &que_iso_state, 1);
+	if (ret) {
+		dev_err(dev, "failed to read QM_QUE_ISO_CFG_V\n");
+		return ret;
+	}
+
+	if (vf_data->que_iso_cfg != que_iso_state) {
+		dev_err(dev, "failed to match isolation state\n");
+		return ret;
+	}
+
+	hisi_acc_vdev->match_done = 1;
+	return 0;
+}
+
+static int vf_qm_get_match_data(struct hisi_acc_vf_core_device *hisi_acc_vdev,
+				struct hisi_acc_vf_migration_file *migf)
+{
+	struct acc_vf_data *vf_data = &migf->vf_data;
+	struct hisi_qm *pf_qm = hisi_acc_vdev->pf_qm;
+	struct device *dev = &pf_qm->pdev->dev;
+	int vf_id = hisi_acc_vdev->vf_id;
+	int ret;
+
+	/* save device id */
+	vf_data->dev_id = hisi_acc_vdev->vf_dev->device;
+
+	/* vf qp num save from PF */
+	ret = pf_qm_get_qp_num(pf_qm, vf_id, &vf_data->qp_base);
+	if (ret <= 0) {
+		dev_err(dev, "failed to get vft qp nums!\n");
+		return -EINVAL;
+	}
+
+	vf_data->qp_num = ret;
+
+	/* VF isolation state save from PF */
+	ret = qm_read_reg(pf_qm, QM_QUE_ISO_CFG_V, &vf_data->que_iso_cfg, 1);
+	if (ret) {
+		dev_err(dev, "failed to read QM_QUE_ISO_CFG_V!\n");
+		return ret;
+	}
+
+	migf->total_length = QM_MATCH_SIZE;
+
+	return 0;
+}
+
+static void hisi_acc_vf_disable_fd(struct hisi_acc_vf_migration_file *migf)
+{
+	mutex_lock(&migf->lock);
+	migf->disabled = true;
+	migf->total_length = 0;
+	migf->filp->f_pos = 0;
+	mutex_unlock(&migf->lock);
+}
+
+static void hisi_acc_vf_disable_fds(struct hisi_acc_vf_core_device *hisi_acc_vdev)
+{
+	struct hisi_acc_vf_migration_file *resuming_migf = &hisi_acc_vdev->resuming_migf;
+	struct hisi_acc_vf_migration_file *saving_migf = &hisi_acc_vdev->saving_migf;
+
+	if (resuming_migf->filp) {
+		hisi_acc_vf_disable_fd(resuming_migf);
+		fput(resuming_migf->filp);
+	}
+
+	if (saving_migf->filp) {
+		hisi_acc_vf_disable_fd(saving_migf);
+		fput(saving_migf->filp);
+	}
+}
+
+static int hisi_acc_vf_load_state(struct hisi_acc_vf_core_device *hisi_acc_vdev,
+				  struct hisi_acc_vf_migration_file *migf)
+{
+	struct hisi_qm *qm = &hisi_acc_vdev->vf_qm;
+	struct device *dev = &qm->pdev->dev;
+	struct acc_vf_data *vf_data = &migf->vf_data;
+	int ret;
+
+	/* Return if only match data was transferred */
+	if (migf->total_length == QM_MATCH_SIZE) {
+		hisi_acc_vdev->vf_qm_state = QM_NOT_READY;
+		return 0;
+	}
+
+	if (migf->total_length < sizeof(struct acc_vf_data))
+		return -EINVAL;
+
+	qm->eqe_dma = vf_data->eqe_dma;
+	qm->aeqe_dma = vf_data->aeqe_dma;
+	qm->sqc_dma = vf_data->sqc_dma;
+	qm->cqc_dma = vf_data->cqc_dma;
+
+	qm->qp_base = vf_data->qp_base;
+	qm->qp_num = vf_data->qp_num;
+
+	ret = qm_rw_regs_write(qm, vf_data);
+	if (ret) {
+		dev_err(dev, "Set VF regs failed\n");
+		return ret;
+	}
+
+	ret = qm_mb(qm, QM_MB_CMD_SQC_BT, qm->sqc_dma, 0, 0);
+	if (ret) {
+		dev_err(dev, "Set sqc failed\n");
+		return ret;
+	}
+
+	ret = qm_mb(qm, QM_MB_CMD_CQC_BT, qm->cqc_dma, 0, 0);
+	if (ret) {
+		dev_err(dev, "Set cqc failed\n");
+		return ret;
+	}
+
+	qm_dev_cmd_init(qm);
+	return 0;
+}
+
+static int hisi_acc_vf_release_file(struct inode *inode, struct file *filp)
+{
+	struct hisi_acc_vf_migration_file *migf = filp->private_data;
+
+	hisi_acc_vf_disable_fd(migf);
+	mutex_destroy(&migf->lock);
+	kfree(migf);
+	return 0;
+}
+
+static ssize_t hisi_acc_vf_resume_write(struct file *filp, const char __user *buf,
+					size_t len, loff_t *pos)
+{
+	struct hisi_acc_vf_migration_file *migf = filp->private_data;
+	struct hisi_acc_vf_core_device *hisi_acc_vdev = container_of(migf,
+			struct hisi_acc_vf_core_device, resuming_migf);
+	loff_t requested_length;
+	u8 *data = (u8 *)&migf->vf_data;
+	ssize_t done = 0;
+	int ret;
+
+	if (pos)
+		return -ESPIPE;
+	pos = &filp->f_pos;
+
+	if (*pos < 0 ||
+	    check_add_overflow((loff_t)len, *pos, &requested_length))
+		return -EINVAL;
+
+	if (requested_length > sizeof(struct acc_vf_data))
+		return -ENOMEM;
+
+	mutex_lock(&migf->lock);
+	if (migf->disabled) {
+		done = -ENODEV;
+		goto out_unlock;
+	}
+
+	ret = copy_from_user(data + *pos, buf, len);
+	if (ret) {
+		done = -EFAULT;
+		goto out_unlock;
+	}
+	*pos += len;
+	done = len;
+	migf->total_length += len;
+
+	ret = vf_qm_check_match(hisi_acc_vdev, migf);
+	if (ret)
+		done = -EFAULT;
+
+out_unlock:
+	mutex_unlock(&migf->lock);
+	return done;
+}
+
+static const struct file_operations hisi_acc_vf_resume_fops = {
+	.owner = THIS_MODULE,
+	.write = hisi_acc_vf_resume_write,
+	.release = hisi_acc_vf_release_file,
+	.llseek = no_llseek,
+};
+
+static int hisi_acc_vf_pci_resume(struct hisi_acc_vf_core_device *hisi_acc_vdev,
+				  struct hisi_acc_vf_migration_file *migf)
+{
+	migf->filp = anon_inode_getfile("hisi_acc_vf_mig", &hisi_acc_vf_resume_fops, migf,
+					O_WRONLY);
+	if (IS_ERR(migf->filp)) {
+		int err = PTR_ERR(migf->filp);
+
+		return err;
+	}
+
+	stream_open(migf->filp->f_inode, migf->filp);
+	mutex_init(&migf->lock);
+	return 0;
+}
+
+static int hisi_acc_vf_stop_copy(struct hisi_acc_vf_core_device *hisi_acc_vdev,
+				 struct hisi_acc_vf_migration_file *migf)
+{
+	struct acc_vf_data *vf_data = &migf->vf_data;
+	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
+	struct device *dev = &vf_qm->pdev->dev;
+	int ret;
+
+	if (unlikely(qm_wait_dev_not_ready(vf_qm))) {
+		/* Update state and return. */
+		hisi_acc_vdev->vf_qm_state = QM_NOT_READY;
+		return 0;
+	}
+
+	ret = vf_qm_cache_wb(vf_qm);
+	if (ret) {
+		dev_err(dev, "failed to writeback QM Cache!\n");
+		return ret;
+	}
+
+	mutex_lock(&migf->lock);
+	ret = qm_rw_regs_read(vf_qm, vf_data);
+	if (ret) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* Every reg is 32 bit, the dma address is 64 bit. */
+	vf_data->eqe_dma = vf_data->qm_eqc_dw[2];
+	vf_data->eqe_dma <<= QM_XQC_ADDR_OFFSET;
+	vf_data->eqe_dma |= vf_data->qm_eqc_dw[1];
+	vf_data->aeqe_dma = vf_data->qm_aeqc_dw[2];
+	vf_data->aeqe_dma <<= QM_XQC_ADDR_OFFSET;
+	vf_data->aeqe_dma |= vf_data->qm_aeqc_dw[1];
+
+	/* Through SQC_BT/CQC_BT to get sqc and cqc address */
+	ret = qm_get_sqc(vf_qm, &vf_data->sqc_dma);
+	if (ret) {
+		dev_err(dev, "failed to read SQC addr!\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = qm_get_cqc(vf_qm, &vf_data->cqc_dma);
+	if (ret) {
+		dev_err(dev, "failed to read CQC addr!\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	migf->total_length = sizeof(struct acc_vf_data);
+out:
+	mutex_unlock(&migf->lock);
+	return ret;
+}
+
+static int hisi_acc_vf_stop_device(struct hisi_acc_vf_core_device *hisi_acc_vdev)
+{
+	struct device *dev = &hisi_acc_vdev->vf_dev->dev;
+	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
+	int ret;
+
+	ret = vf_qm_func_stop(vf_qm);
+	if (ret) {
+		dev_err(dev, "failed to stop QM VF function!\n");
+		return ret;
+	}
+
+	ret = qm_check_int_state(hisi_acc_vdev);
+	if (ret) {
+		dev_err(dev, "failed to check QM INT state!\n");
+		return ret;
+	}
+	return 0;
+}
+
+static void hisi_acc_vf_start_device(struct hisi_acc_vf_core_device *hisi_acc_vdev)
+{
+	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
+
+	if (hisi_acc_vdev->vf_qm_state != QM_READY)
+		return;
+
+	vf_qm_fun_reset(hisi_acc_vdev, vf_qm);
+}
+
+static long hisi_acc_vf_save_unl_ioctl(struct file *filp,
+				       unsigned int cmd, unsigned long arg)
+{
+	struct hisi_acc_vf_migration_file *migf = filp->private_data;
+	struct hisi_acc_vf_core_device *hisi_acc_vdev = container_of(migf,
+			struct hisi_acc_vf_core_device, saving_migf);
+	loff_t *pos = &filp->f_pos;
+	struct vfio_precopy_info info;
+	unsigned long minsz;
+	int ret;
+
+	if (cmd != VFIO_MIG_GET_PRECOPY_INFO)
+		return -ENOTTY;
+
+	minsz = offsetofend(struct vfio_precopy_info, dirty_bytes);
+
+	if (copy_from_user(&info, (void __user *)arg, minsz))
+		return -EFAULT;
+	if (info.argsz < minsz)
+		return -EINVAL;
+
+	mutex_lock(&hisi_acc_vdev->state_mutex);
+	if (hisi_acc_vdev->mig_state != VFIO_DEVICE_STATE_PRE_COPY) {
+		mutex_unlock(&hisi_acc_vdev->state_mutex);
+		return -EINVAL;
+	}
+
+	mutex_lock(&migf->lock);
+
+	if (migf->disabled) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	if (*pos > migf->total_length) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	info.dirty_bytes = 0;
+	info.initial_bytes = migf->total_length - *pos;
+
+	ret = copy_to_user((void __user *)arg, &info, minsz) ? -EFAULT : 0;
+out:
+	mutex_unlock(&migf->lock);
+	mutex_unlock(&hisi_acc_vdev->state_mutex);
+	return ret;
+}
+
+static ssize_t hisi_acc_vf_save_read(struct file *filp, char __user *buf, size_t len,
+				     loff_t *pos)
+{
+	struct hisi_acc_vf_migration_file *migf = filp->private_data;
+	ssize_t done = 0;
+	int ret;
+
+	if (pos)
+		return -ESPIPE;
+	pos = &filp->f_pos;
+
+	mutex_lock(&migf->lock);
+	if (*pos > migf->total_length) {
+		done = -EINVAL;
+		goto out_unlock;
+	}
+
+	if (migf->disabled) {
+		done = -ENODEV;
+		goto out_unlock;
+	}
+
+	/*
+	 * Check whether dev has reached temporary end of stream in PRE_COPY state
+	 * and return ENOMSG on any further read in this state.
+	 */
+	if (migf->total_length == QM_MATCH_SIZE && *pos == migf->total_length)
+		return -ENOMSG;
+
+	len = min_t(size_t, migf->total_length - *pos, len);
+	if (len) {
+		u8 *data = (u8 *)&migf->vf_data;
+
+		ret = copy_to_user(buf, data + *pos, len);
+		if (ret) {
+			done = -EFAULT;
+			goto out_unlock;
+		}
+		*pos += len;
+		done = len;
+	}
+out_unlock:
+	mutex_unlock(&migf->lock);
+	return done;
+}
+
+static const struct file_operations hisi_acc_vf_save_fops = {
+	.owner = THIS_MODULE,
+	.read = hisi_acc_vf_save_read,
+	.unlocked_ioctl = hisi_acc_vf_save_unl_ioctl,
+	.compat_ioctl = compat_ptr_ioctl,
+	.release = hisi_acc_vf_release_file,
+	.llseek = no_llseek,
+};
+
+static int hisi_acc_vf_pre_copy(struct hisi_acc_vf_core_device *hisi_acc_vdev,
+				struct hisi_acc_vf_migration_file *migf)
+{
+	int ret;
+
+	migf->filp = anon_inode_getfile("hisi_acc_vf_mig", &hisi_acc_vf_save_fops, migf,
+					O_RDONLY);
+	if (IS_ERR(migf->filp)) {
+		int err = PTR_ERR(migf->filp);
+
+		return err;
+	}
+
+	stream_open(migf->filp->f_inode, migf->filp);
+	mutex_init(&migf->lock);
+
+	ret = vf_qm_get_match_data(hisi_acc_vdev, migf);
+	if (ret) {
+		fput(migf->filp);
+		return ret;
+	}
+
+	return 0;
+}
+
+static struct file *
+hisi_acc_vf_set_device_state(struct hisi_acc_vf_core_device *hisi_acc_vdev,
+			     u32 new)
+{
+	u32 cur = hisi_acc_vdev->mig_state;
+	int ret;
+
+	if (cur == VFIO_DEVICE_STATE_RUNNING && new == VFIO_DEVICE_STATE_PRE_COPY) {
+		struct hisi_acc_vf_migration_file *migf = &hisi_acc_vdev->saving_migf;
+
+		ret = hisi_acc_vf_pre_copy(hisi_acc_vdev, migf);
+		if (ret)
+			return ERR_PTR(ret);
+		get_file(migf->filp);
+		return migf->filp;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_PRE_COPY && new == VFIO_DEVICE_STATE_STOP_COPY) {
+		struct hisi_acc_vf_migration_file *migf = &hisi_acc_vdev->saving_migf;
+
+		ret = hisi_acc_vf_stop_device(hisi_acc_vdev);
+		if (ret)
+			return ERR_PTR(ret);
+
+		ret = hisi_acc_vf_stop_copy(hisi_acc_vdev, migf);
+		if (ret)
+			return ERR_PTR(ret);
+		get_file(migf->filp);
+		return migf->filp;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_RUNNING && new == VFIO_DEVICE_STATE_STOP) {
+		ret = hisi_acc_vf_stop_device(hisi_acc_vdev);
+		if (ret)
+			return ERR_PTR(ret);
+		return NULL;
+	}
+
+	if ((cur == VFIO_DEVICE_STATE_STOP_COPY && new == VFIO_DEVICE_STATE_STOP)) {
+		hisi_acc_vf_disable_fds(hisi_acc_vdev);
+		return NULL;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_STOP && new == VFIO_DEVICE_STATE_RESUMING) {
+		struct hisi_acc_vf_migration_file *migf = &hisi_acc_vdev->resuming_migf;
+
+		ret = hisi_acc_vf_pci_resume(hisi_acc_vdev, migf);
+		if (ret)
+			return ERR_PTR(ret);
+		get_file(migf->filp);
+		return migf->filp;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_RESUMING && new == VFIO_DEVICE_STATE_STOP) {
+		struct hisi_acc_vf_migration_file *migf = &hisi_acc_vdev->resuming_migf;
+
+		ret = hisi_acc_vf_load_state(hisi_acc_vdev, migf);
+		if (ret)
+			return ERR_PTR(ret);
+		hisi_acc_vf_disable_fds(hisi_acc_vdev);
+		return NULL;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_PRE_COPY && new == VFIO_DEVICE_STATE_RUNNING) {
+		hisi_acc_vf_disable_fds(hisi_acc_vdev);
+		return NULL;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_STOP  && new == VFIO_DEVICE_STATE_RUNNING) {
+		hisi_acc_vf_start_device(hisi_acc_vdev);
+		return NULL;
+	}
+
+	/*
+	 * vfio_mig_get_next_state() does not use arcs other than the above
+	 */
+
+	WARN_ON(true);
+	return ERR_PTR(-EINVAL);
+}
+
+static struct file *
+hisi_acc_vfio_pci_set_device_state(struct vfio_device *vdev,
+				   enum vfio_device_mig_state new_state)
+{
+	struct hisi_acc_vf_core_device *hisi_acc_vdev = container_of(vdev,
+			struct hisi_acc_vf_core_device, core_device.vdev);
+	enum vfio_device_mig_state next_state;
+	struct file *res = NULL;
+	int ret;
+
+	mutex_lock(&hisi_acc_vdev->state_mutex);
+	while (new_state != hisi_acc_vdev->mig_state) {
+		ret = vfio_mig_get_next_state(vdev,
+					      hisi_acc_vdev->mig_state,
+					      new_state, &next_state);
+		if (ret) {
+			res = ERR_PTR(-EINVAL);
+			break;
+		}
+
+		res = hisi_acc_vf_set_device_state(hisi_acc_vdev, next_state);
+		if (IS_ERR(res))
+			break;
+		hisi_acc_vdev->mig_state = next_state;
+		if (WARN_ON(res && new_state != hisi_acc_vdev->mig_state)) {
+			fput(res);
+			res = ERR_PTR(-EINVAL);
+			break;
+		}
+	}
+	mutex_unlock(&hisi_acc_vdev->state_mutex);
+	return res;
+}
+
+static int
+hisi_acc_vfio_pci_get_device_state(struct vfio_device *vdev,
+				   enum vfio_device_mig_state *curr_state)
+{
+	struct hisi_acc_vf_core_device *hisi_acc_vdev = container_of(vdev,
+			struct hisi_acc_vf_core_device, core_device.vdev);
+
+	mutex_lock(&hisi_acc_vdev->state_mutex);
+	*curr_state = hisi_acc_vdev->mig_state;
+	mutex_unlock(&hisi_acc_vdev->state_mutex);
+	return 0;
+}
+
+static int hisi_acc_vf_qm_init(struct hisi_acc_vf_core_device *hisi_acc_vdev)
+{
+	struct vfio_pci_core_device *vdev = &hisi_acc_vdev->core_device;
+	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
+	struct pci_dev *vf_dev = vdev->pdev;
+
+	/*
+	 * ACC VF dev BAR2 region consists of both functional register space
+	 * and migration control register space. For migration to work, we
+	 * need access to both. Hence, we map the entire BAR2 region here.
+	 * But from a security point of view, we restrict access to the
+	 * migration control space from Guest(Please see mmap/ioctl/read/write
+	 * override functions).
+	 *
+	 * Also the HiSilicon ACC VF devices supported by this driver on
+	 * HiSilicon hardware platforms are integrated end point devices
+	 * and has no capability to perform PCIe P2P.
+	 */
+
+	vf_qm->io_base =
+		ioremap(pci_resource_start(vf_dev, VFIO_PCI_BAR2_REGION_INDEX),
+			pci_resource_len(vf_dev, VFIO_PCI_BAR2_REGION_INDEX));
+	if (!vf_qm->io_base)
+		return -EIO;
+
+	vf_qm->fun_type = QM_HW_VF;
+	vf_qm->pdev = vf_dev;
+	mutex_init(&vf_qm->mailbox_lock);
+
+	return 0;
+}
+
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
 
 static int hisi_acc_pci_rw_access_check(struct vfio_device *core_vdev,
 					size_t count, loff_t *ppos,
@@ -128,23 +1161,42 @@ static long hisi_acc_vfio_pci_ioctl(struct vfio_device *core_vdev, unsigned int
 
 static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
 {
-	struct vfio_pci_core_device *vdev =
-		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+	struct hisi_acc_vf_core_device *hisi_acc_vdev = container_of(core_vdev,
+			struct hisi_acc_vf_core_device, core_device.vdev);
+	struct vfio_pci_core_device *vdev = &hisi_acc_vdev->core_device;
 	int ret;
 
 	ret = vfio_pci_core_enable(vdev);
 	if (ret)
 		return ret;
 
-	vfio_pci_core_finish_enable(vdev);
+	if (core_vdev->ops->migration_set_state) {
+		ret = hisi_acc_vf_qm_init(hisi_acc_vdev);
+		if (ret) {
+			vfio_pci_core_disable(vdev);
+			return ret;
+		}
+		hisi_acc_vdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
+	}
 
+	vfio_pci_core_finish_enable(vdev);
 	return 0;
 }
 
+static void hisi_acc_vfio_pci_close_device(struct vfio_device *core_vdev)
+{
+	struct hisi_acc_vf_core_device *hisi_acc_vdev = container_of(core_vdev,
+			struct hisi_acc_vf_core_device, core_device.vdev);
+	struct hisi_qm *vf_qm = &hisi_acc_vdev->vf_qm;
+
+	iounmap(vf_qm->io_base);
+	vfio_pci_core_close_device(core_vdev);
+}
+
 static const struct vfio_device_ops hisi_acc_vfio_pci_migrn_ops = {
 	.name = "hisi-acc-vfio-pci-migration",
 	.open_device = hisi_acc_vfio_pci_open_device,
-	.close_device = vfio_pci_core_close_device,
+	.close_device = hisi_acc_vfio_pci_close_device,
 	.ioctl = hisi_acc_vfio_pci_ioctl,
 	.device_feature = vfio_pci_core_ioctl_feature,
 	.read = hisi_acc_vfio_pci_read,
@@ -152,6 +1204,8 @@ static const struct vfio_device_ops hisi_acc_vfio_pci_migrn_ops = {
 	.mmap = hisi_acc_vfio_pci_mmap,
 	.request = vfio_pci_core_request,
 	.match = vfio_pci_core_match,
+	.migration_set_state = hisi_acc_vfio_pci_set_device_state,
+	.migration_get_state = hisi_acc_vfio_pci_get_device_state,
 };
 
 static const struct vfio_device_ops hisi_acc_vfio_pci_ops = {
@@ -167,38 +1221,76 @@ static const struct vfio_device_ops hisi_acc_vfio_pci_ops = {
 	.match = vfio_pci_core_match,
 };
 
+static int
+hisi_acc_vfio_pci_migrn_init(struct hisi_acc_vf_core_device *hisi_acc_vdev,
+			     struct pci_dev *pdev, struct hisi_qm *pf_qm)
+{
+	int vf_id;
+
+	vf_id = pci_iov_vf_id(pdev);
+	if (vf_id < 0)
+		return vf_id;
+
+	hisi_acc_vdev->vf_id = vf_id + 1;
+	/*
+	 * We set _PRE_COPY here for an early check on compatibility between
+	 * src and dst devices.
+	 */
+	hisi_acc_vdev->core_device.vdev.migration_flags =
+			(VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_PRE_COPY);
+	hisi_acc_vdev->pf_qm = pf_qm;
+	hisi_acc_vdev->vf_dev = pdev;
+	mutex_init(&hisi_acc_vdev->state_mutex);
+
+	return 0;
+}
+
 static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	struct vfio_pci_core_device *vdev;
+	struct hisi_acc_vf_core_device *hisi_acc_vdev;
+	struct hisi_qm *pf_qm;
 	int ret;
 
-	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
-	if (!vdev)
+	hisi_acc_vdev = kzalloc(sizeof(*hisi_acc_vdev), GFP_KERNEL);
+	if (!hisi_acc_vdev)
 		return -ENOMEM;
 
-	vfio_pci_core_init_device(vdev, pdev, &hisi_acc_vfio_pci_ops);
+	pf_qm = hisi_acc_get_pf_qm(pdev);
+	if (pf_qm && pf_qm->ver >= QM_HW_V3) {
+		ret = hisi_acc_vfio_pci_migrn_init(hisi_acc_vdev, pdev, pf_qm);
+		if (!ret) {
+			vfio_pci_core_init_device(&hisi_acc_vdev->core_device, pdev,
+						  &hisi_acc_vfio_pci_migrn_ops);
+		} else {
+			pci_warn(pdev, "migration support failed, continue with generic interface\n");
+			vfio_pci_core_init_device(&hisi_acc_vdev->core_device, pdev,
+						  &hisi_acc_vfio_pci_ops);
+		}
+	} else {
+		vfio_pci_core_init_device(&hisi_acc_vdev->core_device, pdev,
+					  &hisi_acc_vfio_pci_ops);
+	}
 
-	ret = vfio_pci_core_register_device(vdev);
+	ret = vfio_pci_core_register_device(&hisi_acc_vdev->core_device);
 	if (ret)
 		goto out_free;
 
-	dev_set_drvdata(&pdev->dev, vdev);
-
+	dev_set_drvdata(&pdev->dev, hisi_acc_vdev);
 	return 0;
 
 out_free:
-	vfio_pci_core_uninit_device(vdev);
-	kfree(vdev);
+	vfio_pci_core_uninit_device(&hisi_acc_vdev->core_device);
+	kfree(hisi_acc_vdev);
 	return ret;
 }
 
 static void hisi_acc_vfio_pci_remove(struct pci_dev *pdev)
 {
-	struct vfio_pci_core_device *vdev = dev_get_drvdata(&pdev->dev);
+	struct hisi_acc_vf_core_device *hisi_acc_vdev = dev_get_drvdata(&pdev->dev);
 
-	vfio_pci_core_unregister_device(vdev);
-	vfio_pci_core_uninit_device(vdev);
-	kfree(vdev);
+	vfio_pci_core_unregister_device(&hisi_acc_vdev->core_device);
+	vfio_pci_core_uninit_device(&hisi_acc_vdev->core_device);
+	kfree(hisi_acc_vdev);
 }
 
 static const struct pci_device_id hisi_acc_vfio_pci_table[] = {
@@ -223,4 +1315,4 @@ module_pci_driver(hisi_acc_vfio_pci_driver);
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Liu Longfang <liulongfang@huawei.com>");
 MODULE_AUTHOR("Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>");
-MODULE_DESCRIPTION("HiSilicon VFIO PCI - Generic VFIO PCI driver for HiSilicon ACC device family");
+MODULE_DESCRIPTION("HiSilicon VFIO PCI - VFIO PCI driver with live migration support for HiSilicon ACC device family");
diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
new file mode 100644
index 000000000000..51bc7e92a776
--- /dev/null
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
@@ -0,0 +1,112 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2021 HiSilicon Ltd. */
+
+#ifndef HISI_ACC_VFIO_PCI_H
+#define HISI_ACC_VFIO_PCI_H
+
+#include <linux/hisi_acc_qm.h>
+
+#define MB_POLL_PERIOD_US		10
+#define MB_POLL_TIMEOUT_US		1000
+#define QM_CACHE_WB_START		0x204
+#define QM_CACHE_WB_DONE		0x208
+#define QM_MB_CMD_PAUSE_QM		0xe
+#define QM_ABNORMAL_INT_STATUS		0x100008
+#define QM_IFC_INT_STATUS		0x0028
+#define SEC_CORE_INT_STATUS		0x301008
+#define HPRE_HAC_INT_STATUS		0x301800
+#define HZIP_CORE_INT_STATUS		0x3010AC
+#define QM_QUE_ISO_CFG			0x301154
+
+#define QM_VFT_CFG_RDY			0x10006c
+#define QM_VFT_CFG_OP_WR		0x100058
+#define QM_VFT_CFG_TYPE			0x10005c
+#define QM_VFT_CFG			0x100060
+#define QM_VFT_CFG_OP_ENABLE		0x100054
+#define QM_VFT_CFG_DATA_L		0x100064
+#define QM_VFT_CFG_DATA_H		0x100068
+
+#define ERROR_CHECK_TIMEOUT		100
+#define CHECK_DELAY_TIME		100
+
+#define QM_SQC_VFT_BASE_SHIFT_V2	28
+#define QM_SQC_VFT_BASE_MASK_V2		GENMASK(15, 0)
+#define QM_SQC_VFT_NUM_SHIFT_V2		45
+#define QM_SQC_VFT_NUM_MASK_V2		GENMASK(9, 0)
+
+/* RW regs */
+#define QM_REGS_MAX_LEN		7
+#define QM_REG_ADDR_OFFSET	0x0004
+
+#define QM_XQC_ADDR_OFFSET	32U
+#define QM_VF_AEQ_INT_MASK	0x0004
+#define QM_VF_EQ_INT_MASK	0x000c
+#define QM_IFC_INT_SOURCE_V	0x0020
+#define QM_IFC_INT_MASK		0x0024
+#define QM_IFC_INT_SET_V	0x002c
+#define QM_QUE_ISO_CFG_V	0x0030
+#define QM_PAGE_SIZE		0x0034
+
+#define QM_EQC_DW0		0X8000
+#define QM_AEQC_DW0		0X8020
+
+struct acc_vf_data {
+#define QM_MATCH_SIZE 32L
+	/* QM match information */
+	u32 qp_num;
+	u32 dev_id;
+	u32 que_iso_cfg;
+	u32 qp_base;
+	/* QM reserved match information */
+	u32 qm_rsv_state[4];
+
+	/* QM RW regs */
+	u32 aeq_int_mask;
+	u32 eq_int_mask;
+	u32 ifc_int_source;
+	u32 ifc_int_mask;
+	u32 ifc_int_set;
+	u32 page_size;
+
+	/* QM_EQC_DW has 7 regs */
+	u32 qm_eqc_dw[7];
+
+	/* QM_AEQC_DW has 7 regs */
+	u32 qm_aeqc_dw[7];
+
+	/* QM reserved 5 regs */
+	u32 qm_rsv_regs[5];
+
+	/* qm memory init information */
+	u64 eqe_dma;
+	u64 aeqe_dma;
+	u64 sqc_dma;
+	u64 cqc_dma;
+};
+
+struct hisi_acc_vf_migration_file {
+	struct file *filp;
+	struct mutex lock;
+	bool disabled;
+
+	struct acc_vf_data vf_data;
+	size_t total_length;
+};
+
+struct hisi_acc_vf_core_device {
+	struct vfio_pci_core_device core_device;
+	u8 match_done:1;
+	/* for migration state */
+	struct mutex state_mutex;
+	enum vfio_device_mig_state mig_state;
+	struct pci_dev *pf_dev;
+	struct pci_dev *vf_dev;
+	struct hisi_qm *pf_qm;
+	struct hisi_qm vf_qm;
+	u32 vf_qm_state;
+	int vf_id;
+
+	struct hisi_acc_vf_migration_file resuming_migf;
+	struct hisi_acc_vf_migration_file saving_migf;
+};
+#endif /* HISI_ACC_VFIO_PCI_H */
-- 
2.25.1

