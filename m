Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A35376249F
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 23:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbjGYVlb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 17:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbjGYVl3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 17:41:29 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2063.outbound.protection.outlook.com [40.107.220.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA9411FDD;
        Tue, 25 Jul 2023 14:41:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GkzWsdU5U+5IUiLagqbAsxCpjlvkitUn3pNbjAuHrmhEGyox1wEGbIxdR3z9+WtkD1d+Ha3sJiQ8t+Tgj2+kejW31H9v0MDGpSaPRXYApxeb68udhxKhXJJQhqgzNW+YtvXBAgD6jbNX59Ke5c1lhfQ3m3vTNaN6ODVsAD/YXAMplF8hQKZqLCZ7amkpsYl5u4OmdxwDm0oYmtr4Kog1jLGd2fqlDPZl8aABNoCJPmbsm0ean77K9Z+eZV8pN0Qi5TblgX0wkwVZf1/lse5QOzeztxVw4XB8hx4FswI3HKfEfcYvRSRWWmYqg65ZWQ5a6go03J+1S8j5HEtA3yATlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G0vijT/XJ/dyc9MhhxltkpLxzYXDV9cNRr3iPMxn/As=;
 b=X0QG2U2FisxtJIcQeUi9/CEG+l1ixoGR2TPCbluEI847DIIbL+0R6hFc4psuiqZWuvViEkoj+fOUJHjbwrDcJf+nC8wfJsEvvQNtGCPftU06Zc9Vm6qWIBIVYzB4OqaH38SAeYdMKiimPMennaxZkZ+yTTgnksCvIq4UBO7GxMli2aH7U6w0JVjmKfh9KRV6USk55713gnCeUFtQW7DdZEzbZsJ17bhNFjQT0go1TASZkc5GkUIySu1Xbk0z0uaepK5GjrEgtp6HrR3KNCZWqksXhctW9EvudIYEJUSq99XUoJ4vQ3w+GiweRYiePdGZOHSIgh5n9lJ7q5k/Sb3A8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G0vijT/XJ/dyc9MhhxltkpLxzYXDV9cNRr3iPMxn/As=;
 b=Uy2Co3WCHligMZDSEmfxpGRZM67mDHTnNH8VJo37lnwiLNP0MTJ9rcQthZ7DN2yR05cfDKaJkIE5mHzvSx5trZe2xCuVn0vzPvy3iuFfyOqGcRiNEijYvrEXpv/b+UCtI6HZkkVU1n48b7q/HXqBtUEsTGRhqQsBd2rZYAdHUNk=
Received: from BN9P220CA0010.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:13e::15)
 by PH7PR12MB7161.namprd12.prod.outlook.com (2603:10b6:510:200::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.32; Tue, 25 Jul
 2023 21:41:22 +0000
Received: from BN8NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13e:cafe::9e) by BN9P220CA0010.outlook.office365.com
 (2603:10b6:408:13e::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.33 via Frontend
 Transport; Tue, 25 Jul 2023 21:41:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT055.mail.protection.outlook.com (10.13.177.62) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6631.29 via Frontend Transport; Tue, 25 Jul 2023 21:41:21 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Tue, 25 Jul
 2023 16:40:44 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>
CC:     <simon.horman@corigine.com>, <brett.creeley@amd.com>,
        <shannon.nelson@amd.com>
Subject: [PATCH v13 vfio 4/7] vfio/pds: Add VFIO live migration support
Date:   Tue, 25 Jul 2023 14:40:22 -0700
Message-ID: <20230725214025.9288-5-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230725214025.9288-1-brett.creeley@amd.com>
References: <20230725214025.9288-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT055:EE_|PH7PR12MB7161:EE_
X-MS-Office365-Filtering-Correlation-Id: b80d810a-1538-47c0-9333-08db8d57e357
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mbqhsKRfRXimbMnhykgdvC8kAGDIcAX4nvHVbDZ0g4ZYwaqPD1B3BRBuFr2UCewxTbN926qNBEN5jGbEFAN1hk56r8KroIZjOqguoZ7FwMF3ZQwhoYP8pGIyLtce0eCNiHJdA+0vG5G66db767+xLa6+NEhwqF3+87EOTuxmqzSXh2sU5eR0uEaGRrU9zNZ6yXj18tmu6nHjotbOk9QdPLTY67Wuk7m5B3Aer5ImgyX4k0zVCCHMKQT74aR9mV4lyCRfbPi95aOouNRmejBwE096JW1moMttIpE3s4OD3HaZ6YcmLrB1DV538Fpqr6+gpLSTFwZu/Bme9GRnaS4oZ2MIWwDsi9Vg+PJwvWC0oGCrYJTQ4hI/ivLPugoZrqizlZZ6iD5yD+Dp2s6ckWO+0ui1uBKZOg6ovkMO02fDP7LgM24FXyOd05NJoyg8aQaklCQ6GyHSaLWKnBWmQkW9WsbVZ7uhvSD33k0rhIvVcTB3YuDdN6lSj7FyG8SwIXr26mL6xpSeK2tXpngTfhtKZ5kG4es+QnBxtIJC696Xi4p1OO+VjWGm9X7bbfMESoKtugpY1x3L7+zibfgc7zCCp2amMuyV6lL3Q0HpWPKTDJY9coTzBN0kegxQQn5QxkGauMKsRhNu3czNMXo1hxAlRAVcqtlzsyZitnSx4QFuAOvBS9YNtdHBoUNnavpF/n2jtahxhMp9BC3Ux6dCehBvASzT9QZW0BJzBY5q2WlMqZO0bWAsP55mjayTMjDLMJqP1oWPp7C+PDgHyjDVBoQZmQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(396003)(136003)(376002)(82310400008)(451199021)(36840700001)(46966006)(40470700004)(40480700001)(2906002)(6666004)(4326008)(36756003)(30864003)(44832011)(8676002)(70206006)(41300700001)(54906003)(316002)(70586007)(110136005)(16526019)(47076005)(426003)(82740400003)(81166007)(356005)(478600001)(40460700003)(8936002)(86362001)(186003)(2616005)(83380400001)(26005)(5660300002)(336012)(1076003)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2023 21:41:21.8426
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b80d810a-1538-47c0-9333-08db8d57e357
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7161
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add live migration support via the VFIO subsystem. The migration
implementation aligns with the definition from uapi/vfio.h and uses
the pds_core PF's adminq for device configuration.

The ability to suspend, resume, and transfer VF device state data is
included along with the required admin queue command structures and
implementations.

PDS_LM_CMD_SUSPEND and PDS_LM_CMD_SUSPEND_STATUS are added to support
the VF device suspend operation.

PDS_LM_CMD_RESUME is added to support the VF device resume operation.

PDS_LM_CMD_STATE_SIZE is added to determine the exact size of the VF
device state data.

PDS_LM_CMD_SAVE is added to get the VF device state data.

PDS_LM_CMD_RESTORE is added to restore the VF device with the
previously saved data from PDS_LM_CMD_SAVE.

PDS_LM_CMD_HOST_VF_STATUS is added to notify the DSC/firmware when
a migration is in/not-in progress from the host's perspective. The
DSC/firmware can use this to clear/setup any necessary state related
to a migration.

Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/vfio/pci/pds/Makefile   |   1 +
 drivers/vfio/pci/pds/cmds.c     | 324 ++++++++++++++++++++++++
 drivers/vfio/pci/pds/cmds.h     |   8 +-
 drivers/vfio/pci/pds/lm.c       | 434 ++++++++++++++++++++++++++++++++
 drivers/vfio/pci/pds/lm.h       |  41 +++
 drivers/vfio/pci/pds/pci_drv.c  |  13 +
 drivers/vfio/pci/pds/vfio_dev.c | 120 ++++++++-
 drivers/vfio/pci/pds/vfio_dev.h |  11 +
 include/linux/pds/pds_adminq.h  | 197 +++++++++++++++
 9 files changed, 1147 insertions(+), 2 deletions(-)
 create mode 100644 drivers/vfio/pci/pds/lm.c
 create mode 100644 drivers/vfio/pci/pds/lm.h

diff --git a/drivers/vfio/pci/pds/Makefile b/drivers/vfio/pci/pds/Makefile
index 91587c7fe8f9..47750bb31ea2 100644
--- a/drivers/vfio/pci/pds/Makefile
+++ b/drivers/vfio/pci/pds/Makefile
@@ -5,5 +5,6 @@ obj-$(CONFIG_PDS_VFIO_PCI) += pds-vfio-pci.o
 
 pds-vfio-pci-y := \
 	cmds.o		\
+	lm.o		\
 	pci_drv.o	\
 	vfio_dev.o
diff --git a/drivers/vfio/pci/pds/cmds.c b/drivers/vfio/pci/pds/cmds.c
index 198e8e2ed002..e33c43d62791 100644
--- a/drivers/vfio/pci/pds/cmds.c
+++ b/drivers/vfio/pci/pds/cmds.c
@@ -3,6 +3,7 @@
 
 #include <linux/io.h>
 #include <linux/types.h>
+#include <linux/delay.h>
 
 #include <linux/pds/pds_common.h>
 #include <linux/pds/pds_core_if.h>
@@ -11,6 +12,31 @@
 #include "vfio_dev.h"
 #include "cmds.h"
 
+#define SUSPEND_TIMEOUT_S		5
+#define SUSPEND_CHECK_INTERVAL_MS	1
+
+static int pds_vfio_client_adminq_cmd(struct pds_vfio_pci_device *pds_vfio,
+				      union pds_core_adminq_cmd *req,
+				      union pds_core_adminq_comp *resp,
+				      bool fast_poll)
+{
+	union pds_core_adminq_cmd cmd = {};
+	int err;
+
+	/* Wrap the client request */
+	cmd.client_request.opcode = PDS_AQ_CMD_CLIENT_CMD;
+	cmd.client_request.client_id = cpu_to_le16(pds_vfio->client_id);
+	memcpy(cmd.client_request.client_cmd, req,
+	       sizeof(cmd.client_request.client_cmd));
+
+	err = pdsc_adminq_post(pds_vfio->pdsc, &cmd, resp, fast_poll);
+	if (err && err != -EAGAIN)
+		dev_err(pds_vfio_to_dev(pds_vfio),
+			"client admin cmd failed: %pe\n", ERR_PTR(err));
+
+	return err;
+}
+
 int pds_vfio_register_client_cmd(struct pds_vfio_pci_device *pds_vfio)
 {
 	struct pci_dev *pdev = pds_vfio_to_pci_dev(pds_vfio);
@@ -42,3 +68,301 @@ void pds_vfio_unregister_client_cmd(struct pds_vfio_pci_device *pds_vfio)
 
 	pds_vfio->client_id = 0;
 }
+
+static int
+pds_vfio_suspend_wait_device_cmd(struct pds_vfio_pci_device *pds_vfio)
+{
+	union pds_core_adminq_cmd cmd = {
+		.lm_suspend_status = {
+			.opcode = PDS_LM_CMD_SUSPEND_STATUS,
+			.vf_id = cpu_to_le16(pds_vfio->vf_id),
+		},
+	};
+	struct device *dev = pds_vfio_to_dev(pds_vfio);
+	union pds_core_adminq_comp comp = {};
+	unsigned long time_limit;
+	unsigned long time_start;
+	unsigned long time_done;
+	int err;
+
+	time_start = jiffies;
+	time_limit = time_start + HZ * SUSPEND_TIMEOUT_S;
+	do {
+		err = pds_vfio_client_adminq_cmd(pds_vfio, &cmd, &comp, true);
+		if (err != -EAGAIN)
+			break;
+
+		msleep(SUSPEND_CHECK_INTERVAL_MS);
+	} while (time_before(jiffies, time_limit));
+
+	time_done = jiffies;
+	dev_dbg(dev, "%s: vf%u: Suspend comp received in %d msecs\n", __func__,
+		pds_vfio->vf_id, jiffies_to_msecs(time_done - time_start));
+
+	/* Check the results */
+	if (time_after_eq(time_done, time_limit)) {
+		dev_err(dev, "%s: vf%u: Suspend comp timeout\n", __func__,
+			pds_vfio->vf_id);
+		err = -ETIMEDOUT;
+	}
+
+	return err;
+}
+
+int pds_vfio_suspend_device_cmd(struct pds_vfio_pci_device *pds_vfio, u8 type)
+{
+	union pds_core_adminq_cmd cmd = {
+		.lm_suspend = {
+			.opcode = PDS_LM_CMD_SUSPEND,
+			.vf_id = cpu_to_le16(pds_vfio->vf_id),
+			.type = type,
+		},
+	};
+	struct device *dev = pds_vfio_to_dev(pds_vfio);
+	union pds_core_adminq_comp comp = {};
+	int err;
+
+	dev_dbg(dev, "vf%u: Suspend device\n", pds_vfio->vf_id);
+
+	/*
+	 * The initial suspend request to the firmware starts the device suspend
+	 * operation and the firmware returns success if it's started
+	 * successfully.
+	 */
+	err = pds_vfio_client_adminq_cmd(pds_vfio, &cmd, &comp, true);
+	if (err) {
+		dev_err(dev, "vf%u: Suspend failed: %pe\n", pds_vfio->vf_id,
+			ERR_PTR(err));
+		return err;
+	}
+
+	/*
+	 * The subsequent suspend status request(s) check if the firmware has
+	 * completed the device suspend process.
+	 */
+	return pds_vfio_suspend_wait_device_cmd(pds_vfio);
+}
+
+int pds_vfio_resume_device_cmd(struct pds_vfio_pci_device *pds_vfio, u8 type)
+{
+	union pds_core_adminq_cmd cmd = {
+		.lm_resume = {
+			.opcode = PDS_LM_CMD_RESUME,
+			.vf_id = cpu_to_le16(pds_vfio->vf_id),
+			.type = type,
+		},
+	};
+	struct device *dev = pds_vfio_to_dev(pds_vfio);
+	union pds_core_adminq_comp comp = {};
+
+	dev_dbg(dev, "vf%u: Resume device\n", pds_vfio->vf_id);
+
+	return pds_vfio_client_adminq_cmd(pds_vfio, &cmd, &comp, true);
+}
+
+int pds_vfio_get_lm_state_size_cmd(struct pds_vfio_pci_device *pds_vfio, u64 *size)
+{
+	union pds_core_adminq_cmd cmd = {
+		.lm_state_size = {
+			.opcode = PDS_LM_CMD_STATE_SIZE,
+			.vf_id = cpu_to_le16(pds_vfio->vf_id),
+		},
+	};
+	struct device *dev = pds_vfio_to_dev(pds_vfio);
+	union pds_core_adminq_comp comp = {};
+	int err;
+
+	dev_dbg(dev, "vf%u: Get migration status\n", pds_vfio->vf_id);
+
+	err = pds_vfio_client_adminq_cmd(pds_vfio, &cmd, &comp, false);
+	if (err)
+		return err;
+
+	*size = le64_to_cpu(comp.lm_state_size.size);
+	return 0;
+}
+
+static int pds_vfio_dma_map_lm_file(struct device *dev,
+				    enum dma_data_direction dir,
+				    struct pds_vfio_lm_file *lm_file)
+{
+	struct pds_lm_sg_elem *sgl, *sge;
+	struct scatterlist *sg;
+	dma_addr_t sgl_addr;
+	size_t sgl_size;
+	int err;
+	int i;
+
+	if (!lm_file)
+		return -EINVAL;
+
+	/* dma map file pages */
+	err = dma_map_sgtable(dev, &lm_file->sg_table, dir, 0);
+	if (err)
+		return err;
+
+	lm_file->num_sge = lm_file->sg_table.nents;
+
+	/* alloc sgl */
+	sgl_size = lm_file->num_sge * sizeof(struct pds_lm_sg_elem);
+	sgl = kzalloc(sgl_size, GFP_KERNEL);
+	if (!sgl) {
+		err = -ENOMEM;
+		goto out_unmap_sgtable;
+	}
+
+	/* fill sgl */
+	sge = sgl;
+	for_each_sgtable_dma_sg(&lm_file->sg_table, sg, i) {
+		sge->addr = cpu_to_le64(sg_dma_address(sg));
+		sge->len = cpu_to_le32(sg_dma_len(sg));
+		dev_dbg(dev, "addr = %llx, len = %u\n", sge->addr, sge->len);
+		sge++;
+	}
+
+	sgl_addr = dma_map_single(dev, sgl, sgl_size, DMA_TO_DEVICE);
+	if (dma_mapping_error(dev, sgl_addr)) {
+		err = -EIO;
+		goto out_free_sgl;
+	}
+
+	lm_file->sgl = sgl;
+	lm_file->sgl_addr = sgl_addr;
+
+	return 0;
+
+out_free_sgl:
+	kfree(sgl);
+out_unmap_sgtable:
+	lm_file->num_sge = 0;
+	dma_unmap_sgtable(dev, &lm_file->sg_table, dir, 0);
+	return err;
+}
+
+static void pds_vfio_dma_unmap_lm_file(struct device *dev,
+				       enum dma_data_direction dir,
+				       struct pds_vfio_lm_file *lm_file)
+{
+	if (!lm_file)
+		return;
+
+	/* free sgl */
+	if (lm_file->sgl) {
+		dma_unmap_single(dev, lm_file->sgl_addr,
+				 lm_file->num_sge * sizeof(*lm_file->sgl),
+				 DMA_TO_DEVICE);
+		kfree(lm_file->sgl);
+		lm_file->sgl = NULL;
+		lm_file->sgl_addr = DMA_MAPPING_ERROR;
+		lm_file->num_sge = 0;
+	}
+
+	/* dma unmap file pages */
+	dma_unmap_sgtable(dev, &lm_file->sg_table, dir, 0);
+}
+
+int pds_vfio_get_lm_state_cmd(struct pds_vfio_pci_device *pds_vfio)
+{
+	union pds_core_adminq_cmd cmd = {
+		.lm_save = {
+			.opcode = PDS_LM_CMD_SAVE,
+			.vf_id = cpu_to_le16(pds_vfio->vf_id),
+		},
+	};
+	struct pci_dev *pdev = pds_vfio_to_pci_dev(pds_vfio);
+	struct device *pdsc_dev = &pci_physfn(pdev)->dev;
+	union pds_core_adminq_comp comp = {};
+	struct pds_vfio_lm_file *lm_file;
+	int err;
+
+	dev_dbg(&pdev->dev, "vf%u: Get migration state\n", pds_vfio->vf_id);
+
+	lm_file = pds_vfio->save_file;
+
+	err = pds_vfio_dma_map_lm_file(pdsc_dev, DMA_FROM_DEVICE, lm_file);
+	if (err) {
+		dev_err(&pdev->dev, "failed to map save migration file: %pe\n",
+			ERR_PTR(err));
+		return err;
+	}
+
+	cmd.lm_save.sgl_addr = cpu_to_le64(lm_file->sgl_addr);
+	cmd.lm_save.num_sge = cpu_to_le32(lm_file->num_sge);
+
+	err = pds_vfio_client_adminq_cmd(pds_vfio, &cmd, &comp, false);
+	if (err)
+		dev_err(&pdev->dev, "failed to get migration state: %pe\n",
+			ERR_PTR(err));
+
+	pds_vfio_dma_unmap_lm_file(pdsc_dev, DMA_FROM_DEVICE, lm_file);
+
+	return err;
+}
+
+int pds_vfio_set_lm_state_cmd(struct pds_vfio_pci_device *pds_vfio)
+{
+	union pds_core_adminq_cmd cmd = {
+		.lm_restore = {
+			.opcode = PDS_LM_CMD_RESTORE,
+			.vf_id = cpu_to_le16(pds_vfio->vf_id),
+		},
+	};
+	struct pci_dev *pdev = pds_vfio_to_pci_dev(pds_vfio);
+	struct device *pdsc_dev = &pci_physfn(pdev)->dev;
+	union pds_core_adminq_comp comp = {};
+	struct pds_vfio_lm_file *lm_file;
+	int err;
+
+	dev_dbg(&pdev->dev, "vf%u: Set migration state\n", pds_vfio->vf_id);
+
+	lm_file = pds_vfio->restore_file;
+
+	err = pds_vfio_dma_map_lm_file(pdsc_dev, DMA_TO_DEVICE, lm_file);
+	if (err) {
+		dev_err(&pdev->dev,
+			"failed to map restore migration file: %pe\n",
+			ERR_PTR(err));
+		return err;
+	}
+
+	cmd.lm_restore.sgl_addr = cpu_to_le64(lm_file->sgl_addr);
+	cmd.lm_restore.num_sge = cpu_to_le32(lm_file->num_sge);
+
+	err = pds_vfio_client_adminq_cmd(pds_vfio, &cmd, &comp, false);
+	if (err)
+		dev_err(&pdev->dev, "failed to set migration state: %pe\n",
+			ERR_PTR(err));
+
+	pds_vfio_dma_unmap_lm_file(pdsc_dev, DMA_TO_DEVICE, lm_file);
+
+	return err;
+}
+
+void pds_vfio_send_host_vf_lm_status_cmd(struct pds_vfio_pci_device *pds_vfio,
+					 enum pds_lm_host_vf_status vf_status)
+{
+	union pds_core_adminq_cmd cmd = {
+		.lm_host_vf_status = {
+			.opcode = PDS_LM_CMD_HOST_VF_STATUS,
+			.vf_id = cpu_to_le16(pds_vfio->vf_id),
+			.status = vf_status,
+		},
+	};
+	struct device *dev = pds_vfio_to_dev(pds_vfio);
+	union pds_core_adminq_comp comp = {};
+	int err;
+
+	dev_dbg(dev, "vf%u: Set host VF LM status: %u", pds_vfio->vf_id,
+		vf_status);
+	if (vf_status != PDS_LM_STA_IN_PROGRESS &&
+	    vf_status != PDS_LM_STA_NONE) {
+		dev_warn(dev, "Invalid host VF migration status, %d\n",
+			 vf_status);
+		return;
+	}
+
+	err = pds_vfio_client_adminq_cmd(pds_vfio, &cmd, &comp, false);
+	if (err)
+		dev_warn(dev, "failed to send host VF migration status: %pe\n",
+			 ERR_PTR(err));
+}
diff --git a/drivers/vfio/pci/pds/cmds.h b/drivers/vfio/pci/pds/cmds.h
index 4c592afccf89..a0ec169f18a1 100644
--- a/drivers/vfio/pci/pds/cmds.h
+++ b/drivers/vfio/pci/pds/cmds.h
@@ -6,5 +6,11 @@
 
 int pds_vfio_register_client_cmd(struct pds_vfio_pci_device *pds_vfio);
 void pds_vfio_unregister_client_cmd(struct pds_vfio_pci_device *pds_vfio);
-
+int pds_vfio_suspend_device_cmd(struct pds_vfio_pci_device *pds_vfio, u8 type);
+int pds_vfio_resume_device_cmd(struct pds_vfio_pci_device *pds_vfio, u8 type);
+int pds_vfio_get_lm_state_size_cmd(struct pds_vfio_pci_device *pds_vfio, u64 *size);
+int pds_vfio_get_lm_state_cmd(struct pds_vfio_pci_device *pds_vfio);
+int pds_vfio_set_lm_state_cmd(struct pds_vfio_pci_device *pds_vfio);
+void pds_vfio_send_host_vf_lm_status_cmd(struct pds_vfio_pci_device *pds_vfio,
+					 enum pds_lm_host_vf_status vf_status);
 #endif /* _CMDS_H_ */
diff --git a/drivers/vfio/pci/pds/lm.c b/drivers/vfio/pci/pds/lm.c
new file mode 100644
index 000000000000..7e319529cf74
--- /dev/null
+++ b/drivers/vfio/pci/pds/lm.c
@@ -0,0 +1,434 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
+
+#include <linux/anon_inodes.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/highmem.h>
+#include <linux/vfio.h>
+#include <linux/vfio_pci_core.h>
+
+#include "vfio_dev.h"
+#include "cmds.h"
+
+static struct pds_vfio_lm_file *
+pds_vfio_get_lm_file(const struct file_operations *fops, int flags, u64 size)
+{
+	struct pds_vfio_lm_file *lm_file = NULL;
+	unsigned long long npages;
+	struct page **pages;
+	void *page_mem;
+	const void *p;
+
+	if (!size)
+		return NULL;
+
+	/* Alloc file structure */
+	lm_file = kzalloc(sizeof(*lm_file), GFP_KERNEL);
+	if (!lm_file)
+		return NULL;
+
+	/* Create file */
+	lm_file->filep =
+		anon_inode_getfile("pds_vfio_lm", fops, lm_file, flags);
+	if (!lm_file->filep)
+		goto out_free_file;
+
+	stream_open(lm_file->filep->f_inode, lm_file->filep);
+	mutex_init(&lm_file->lock);
+
+	/* prevent file from being released before we are done with it */
+	get_file(lm_file->filep);
+
+	/* Allocate memory for file pages */
+	npages = DIV_ROUND_UP_ULL(size, PAGE_SIZE);
+	pages = kmalloc_array(npages, sizeof(*pages), GFP_KERNEL);
+	if (!pages)
+		goto out_put_file;
+
+	page_mem = kvzalloc(ALIGN(size, PAGE_SIZE), GFP_KERNEL);
+	if (!page_mem)
+		goto out_free_pages_array;
+
+	p = page_mem - offset_in_page(page_mem);
+	for (unsigned long long i = 0; i < npages; i++) {
+		if (is_vmalloc_addr(p))
+			pages[i] = vmalloc_to_page(p);
+		else
+			pages[i] = kmap_to_page((void *)p);
+		if (!pages[i])
+			goto out_free_page_mem;
+
+		p += PAGE_SIZE;
+	}
+
+	/* Create scatterlist of file pages to use for DMA mapping later */
+	if (sg_alloc_table_from_pages(&lm_file->sg_table, pages, npages, 0,
+				      size, GFP_KERNEL))
+		goto out_free_page_mem;
+
+	lm_file->size = size;
+	lm_file->pages = pages;
+	lm_file->npages = npages;
+	lm_file->page_mem = page_mem;
+	lm_file->alloc_size = npages * PAGE_SIZE;
+
+	return lm_file;
+
+out_free_page_mem:
+	kvfree(page_mem);
+out_free_pages_array:
+	kfree(pages);
+out_put_file:
+	fput(lm_file->filep);
+	mutex_destroy(&lm_file->lock);
+out_free_file:
+	kfree(lm_file);
+
+	return NULL;
+}
+
+static void pds_vfio_put_lm_file(struct pds_vfio_lm_file *lm_file)
+{
+	mutex_lock(&lm_file->lock);
+
+	lm_file->size = 0;
+	lm_file->alloc_size = 0;
+
+	/* Free scatter list of file pages */
+	sg_free_table(&lm_file->sg_table);
+
+	kvfree(lm_file->page_mem);
+	lm_file->page_mem = NULL;
+	kfree(lm_file->pages);
+	lm_file->pages = NULL;
+
+	mutex_unlock(&lm_file->lock);
+
+	/* allow file to be released since we are done with it */
+	fput(lm_file->filep);
+}
+
+void pds_vfio_put_save_file(struct pds_vfio_pci_device *pds_vfio)
+{
+	if (!pds_vfio->save_file)
+		return;
+
+	pds_vfio_put_lm_file(pds_vfio->save_file);
+	pds_vfio->save_file = NULL;
+}
+
+void pds_vfio_put_restore_file(struct pds_vfio_pci_device *pds_vfio)
+{
+	if (!pds_vfio->restore_file)
+		return;
+
+	pds_vfio_put_lm_file(pds_vfio->restore_file);
+	pds_vfio->restore_file = NULL;
+}
+
+static struct page *pds_vfio_get_file_page(struct pds_vfio_lm_file *lm_file,
+					   unsigned long offset)
+{
+	unsigned long cur_offset = 0;
+	struct scatterlist *sg;
+	unsigned int i;
+
+	/* All accesses are sequential */
+	if (offset < lm_file->last_offset || !lm_file->last_offset_sg) {
+		lm_file->last_offset = 0;
+		lm_file->last_offset_sg = lm_file->sg_table.sgl;
+		lm_file->sg_last_entry = 0;
+	}
+
+	cur_offset = lm_file->last_offset;
+
+	for_each_sg(lm_file->last_offset_sg, sg,
+		    lm_file->sg_table.orig_nents - lm_file->sg_last_entry, i) {
+		if (offset < sg->length + cur_offset) {
+			lm_file->last_offset_sg = sg;
+			lm_file->sg_last_entry += i;
+			lm_file->last_offset = cur_offset;
+			return nth_page(sg_page(sg),
+					(offset - cur_offset) / PAGE_SIZE);
+		}
+		cur_offset += sg->length;
+	}
+
+	return NULL;
+}
+
+static int pds_vfio_release_file(struct inode *inode, struct file *filp)
+{
+	struct pds_vfio_lm_file *lm_file = filp->private_data;
+
+	mutex_lock(&lm_file->lock);
+	lm_file->filep->f_pos = 0;
+	lm_file->size = 0;
+	mutex_unlock(&lm_file->lock);
+	mutex_destroy(&lm_file->lock);
+	kfree(lm_file);
+
+	return 0;
+}
+
+static ssize_t pds_vfio_save_read(struct file *filp, char __user *buf,
+				  size_t len, loff_t *pos)
+{
+	struct pds_vfio_lm_file *lm_file = filp->private_data;
+	ssize_t done = 0;
+
+	if (pos)
+		return -ESPIPE;
+	pos = &filp->f_pos;
+
+	mutex_lock(&lm_file->lock);
+	if (*pos > lm_file->size) {
+		done = -EINVAL;
+		goto out_unlock;
+	}
+
+	len = min_t(size_t, lm_file->size - *pos, len);
+	while (len) {
+		size_t page_offset;
+		struct page *page;
+		size_t page_len;
+		u8 *from_buff;
+		int err;
+
+		page_offset = (*pos) % PAGE_SIZE;
+		page = pds_vfio_get_file_page(lm_file, *pos - page_offset);
+		if (!page) {
+			if (done == 0)
+				done = -EINVAL;
+			goto out_unlock;
+		}
+
+		page_len = min_t(size_t, len, PAGE_SIZE - page_offset);
+		from_buff = kmap_local_page(page);
+		err = copy_to_user(buf, from_buff + page_offset, page_len);
+		kunmap_local(from_buff);
+		if (err) {
+			done = -EFAULT;
+			goto out_unlock;
+		}
+		*pos += page_len;
+		len -= page_len;
+		done += page_len;
+		buf += page_len;
+	}
+
+out_unlock:
+	mutex_unlock(&lm_file->lock);
+	return done;
+}
+
+static const struct file_operations pds_vfio_save_fops = {
+	.owner = THIS_MODULE,
+	.read = pds_vfio_save_read,
+	.release = pds_vfio_release_file,
+	.llseek = no_llseek,
+};
+
+static int pds_vfio_get_save_file(struct pds_vfio_pci_device *pds_vfio)
+{
+	struct device *dev = &pds_vfio->vfio_coredev.pdev->dev;
+	struct pds_vfio_lm_file *lm_file;
+	u64 size;
+	int err;
+
+	/* Get live migration state size in this state */
+	err = pds_vfio_get_lm_state_size_cmd(pds_vfio, &size);
+	if (err) {
+		dev_err(dev, "failed to get save status: %pe\n", ERR_PTR(err));
+		return err;
+	}
+
+	dev_dbg(dev, "save status, size = %lld\n", size);
+
+	if (!size) {
+		dev_err(dev, "invalid state size\n");
+		return -EIO;
+	}
+
+	lm_file = pds_vfio_get_lm_file(&pds_vfio_save_fops, O_RDONLY, size);
+	if (!lm_file) {
+		dev_err(dev, "failed to create save file\n");
+		return -ENOENT;
+	}
+
+	dev_dbg(dev, "size = %lld, alloc_size = %lld, npages = %lld\n",
+		lm_file->size, lm_file->alloc_size, lm_file->npages);
+
+	pds_vfio->save_file = lm_file;
+
+	return 0;
+}
+
+static ssize_t pds_vfio_restore_write(struct file *filp, const char __user *buf,
+				      size_t len, loff_t *pos)
+{
+	struct pds_vfio_lm_file *lm_file = filp->private_data;
+	loff_t requested_length;
+	ssize_t done = 0;
+
+	if (pos)
+		return -ESPIPE;
+
+	pos = &filp->f_pos;
+
+	if (*pos < 0 ||
+	    check_add_overflow((loff_t)len, *pos, &requested_length))
+		return -EINVAL;
+
+	mutex_lock(&lm_file->lock);
+
+	while (len) {
+		size_t page_offset;
+		struct page *page;
+		size_t page_len;
+		u8 *to_buff;
+		int err;
+
+		page_offset = (*pos) % PAGE_SIZE;
+		page = pds_vfio_get_file_page(lm_file, *pos - page_offset);
+		if (!page) {
+			if (done == 0)
+				done = -EINVAL;
+			goto out_unlock;
+		}
+
+		page_len = min_t(size_t, len, PAGE_SIZE - page_offset);
+		to_buff = kmap_local_page(page);
+		err = copy_from_user(to_buff + page_offset, buf, page_len);
+		kunmap_local(to_buff);
+		if (err) {
+			done = -EFAULT;
+			goto out_unlock;
+		}
+		*pos += page_len;
+		len -= page_len;
+		done += page_len;
+		buf += page_len;
+		lm_file->size += page_len;
+	}
+out_unlock:
+	mutex_unlock(&lm_file->lock);
+	return done;
+}
+
+static const struct file_operations pds_vfio_restore_fops = {
+	.owner = THIS_MODULE,
+	.write = pds_vfio_restore_write,
+	.release = pds_vfio_release_file,
+	.llseek = no_llseek,
+};
+
+static int pds_vfio_get_restore_file(struct pds_vfio_pci_device *pds_vfio)
+{
+	struct device *dev = &pds_vfio->vfio_coredev.pdev->dev;
+	struct pds_vfio_lm_file *lm_file;
+	u64 size;
+
+	size = sizeof(union pds_lm_dev_state);
+	dev_dbg(dev, "restore status, size = %lld\n", size);
+
+	if (!size) {
+		dev_err(dev, "invalid state size");
+		return -EIO;
+	}
+
+	lm_file = pds_vfio_get_lm_file(&pds_vfio_restore_fops, O_WRONLY, size);
+	if (!lm_file) {
+		dev_err(dev, "failed to create restore file");
+		return -ENOENT;
+	}
+	pds_vfio->restore_file = lm_file;
+
+	return 0;
+}
+
+struct file *
+pds_vfio_step_device_state_locked(struct pds_vfio_pci_device *pds_vfio,
+				  enum vfio_device_mig_state next)
+{
+	enum vfio_device_mig_state cur = pds_vfio->state;
+	int err;
+
+	if (cur == VFIO_DEVICE_STATE_STOP && next == VFIO_DEVICE_STATE_STOP_COPY) {
+		err = pds_vfio_get_save_file(pds_vfio);
+		if (err)
+			return ERR_PTR(err);
+
+		err = pds_vfio_get_lm_state_cmd(pds_vfio);
+		if (err) {
+			pds_vfio_put_save_file(pds_vfio);
+			return ERR_PTR(err);
+		}
+
+		return pds_vfio->save_file->filep;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_STOP_COPY && next == VFIO_DEVICE_STATE_STOP) {
+		pds_vfio_put_save_file(pds_vfio);
+		pds_vfio_send_host_vf_lm_status_cmd(pds_vfio, PDS_LM_STA_NONE);
+		return NULL;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_STOP && next == VFIO_DEVICE_STATE_RESUMING) {
+		err = pds_vfio_get_restore_file(pds_vfio);
+		if (err)
+			return ERR_PTR(err);
+
+		return pds_vfio->restore_file->filep;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_RESUMING && next == VFIO_DEVICE_STATE_STOP) {
+		err = pds_vfio_set_lm_state_cmd(pds_vfio);
+		if (err)
+			return ERR_PTR(err);
+
+		pds_vfio_put_restore_file(pds_vfio);
+		return NULL;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_RUNNING && next == VFIO_DEVICE_STATE_RUNNING_P2P) {
+		pds_vfio_send_host_vf_lm_status_cmd(pds_vfio,
+						    PDS_LM_STA_IN_PROGRESS);
+		err = pds_vfio_suspend_device_cmd(pds_vfio,
+						  PDS_LM_SUSPEND_RESUME_TYPE_P2P);
+		if (err)
+			return ERR_PTR(err);
+
+		return NULL;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_RUNNING_P2P && next == VFIO_DEVICE_STATE_RUNNING) {
+		err = pds_vfio_resume_device_cmd(pds_vfio,
+						 PDS_LM_SUSPEND_RESUME_TYPE_FULL);
+		if (err)
+			return ERR_PTR(err);
+
+		pds_vfio_send_host_vf_lm_status_cmd(pds_vfio, PDS_LM_STA_NONE);
+		return NULL;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_STOP && next == VFIO_DEVICE_STATE_RUNNING_P2P) {
+		err = pds_vfio_resume_device_cmd(pds_vfio,
+						 PDS_LM_SUSPEND_RESUME_TYPE_P2P);
+		if (err)
+			return ERR_PTR(err);
+
+		return NULL;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_RUNNING_P2P && next == VFIO_DEVICE_STATE_STOP) {
+		err = pds_vfio_suspend_device_cmd(pds_vfio,
+						  PDS_LM_SUSPEND_RESUME_TYPE_FULL);
+		if (err)
+			return ERR_PTR(err);
+		return NULL;
+	}
+
+	return ERR_PTR(-EINVAL);
+}
diff --git a/drivers/vfio/pci/pds/lm.h b/drivers/vfio/pci/pds/lm.h
new file mode 100644
index 000000000000..13be893198b7
--- /dev/null
+++ b/drivers/vfio/pci/pds/lm.h
@@ -0,0 +1,41 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
+
+#ifndef _LM_H_
+#define _LM_H_
+
+#include <linux/fs.h>
+#include <linux/mutex.h>
+#include <linux/scatterlist.h>
+#include <linux/types.h>
+
+#include <linux/pds/pds_common.h>
+#include <linux/pds/pds_adminq.h>
+
+struct pds_vfio_lm_file {
+	struct file *filep;
+	struct mutex lock;	/* protect live migration data file */
+	u64 size;		/* Size with valid data */
+	u64 alloc_size;		/* Total allocated size. Always >= len */
+	void *page_mem;		/* memory allocated for pages */
+	struct page **pages;	/* Backing pages for file */
+	unsigned long long npages;
+	struct sg_table sg_table;	/* SG table for backing pages */
+	struct pds_lm_sg_elem *sgl;	/* DMA mapping */
+	dma_addr_t sgl_addr;
+	u16 num_sge;
+	struct scatterlist *last_offset_sg;	/* Iterator */
+	unsigned int sg_last_entry;
+	unsigned long last_offset;
+};
+
+struct pds_vfio_pci_device;
+
+struct file *
+pds_vfio_step_device_state_locked(struct pds_vfio_pci_device *pds_vfio,
+				  enum vfio_device_mig_state next);
+
+void pds_vfio_put_save_file(struct pds_vfio_pci_device *pds_vfio);
+void pds_vfio_put_restore_file(struct pds_vfio_pci_device *pds_vfio);
+
+#endif /* _LM_H_ */
diff --git a/drivers/vfio/pci/pds/pci_drv.c b/drivers/vfio/pci/pds/pci_drv.c
index 928903a84f27..c1739edd261a 100644
--- a/drivers/vfio/pci/pds/pci_drv.c
+++ b/drivers/vfio/pci/pds/pci_drv.c
@@ -72,11 +72,24 @@ static const struct pci_device_id pds_vfio_pci_table[] = {
 };
 MODULE_DEVICE_TABLE(pci, pds_vfio_pci_table);
 
+static void pds_vfio_pci_aer_reset_done(struct pci_dev *pdev)
+{
+	struct pds_vfio_pci_device *pds_vfio = pds_vfio_pci_drvdata(pdev);
+
+	pds_vfio_reset(pds_vfio);
+}
+
+static const struct pci_error_handlers pds_vfio_pci_err_handlers = {
+	.reset_done = pds_vfio_pci_aer_reset_done,
+	.error_detected = vfio_pci_core_aer_err_detected,
+};
+
 static struct pci_driver pds_vfio_pci_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = pds_vfio_pci_table,
 	.probe = pds_vfio_pci_probe,
 	.remove = pds_vfio_pci_remove,
+	.err_handler = &pds_vfio_pci_err_handlers,
 	.driver_managed_dma = true,
 };
 
diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
index ce42f0b461b3..b37ef96a7fd8 100644
--- a/drivers/vfio/pci/pds/vfio_dev.c
+++ b/drivers/vfio/pci/pds/vfio_dev.c
@@ -4,6 +4,7 @@
 #include <linux/vfio.h>
 #include <linux/vfio_pci_core.h>
 
+#include "lm.h"
 #include "vfio_dev.h"
 
 struct pci_dev *pds_vfio_to_pci_dev(struct pds_vfio_pci_device *pds_vfio)
@@ -11,6 +12,11 @@ struct pci_dev *pds_vfio_to_pci_dev(struct pds_vfio_pci_device *pds_vfio)
 	return pds_vfio->vfio_coredev.pdev;
 }
 
+struct device *pds_vfio_to_dev(struct pds_vfio_pci_device *pds_vfio)
+{
+	return &pds_vfio_to_pci_dev(pds_vfio)->dev;
+}
+
 struct pds_vfio_pci_device *pds_vfio_pci_drvdata(struct pci_dev *pdev)
 {
 	struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
@@ -19,6 +25,98 @@ struct pds_vfio_pci_device *pds_vfio_pci_drvdata(struct pci_dev *pdev)
 			    vfio_coredev);
 }
 
+static void pds_vfio_state_mutex_unlock(struct pds_vfio_pci_device *pds_vfio)
+{
+again:
+	spin_lock(&pds_vfio->reset_lock);
+	if (pds_vfio->deferred_reset) {
+		pds_vfio->deferred_reset = false;
+		if (pds_vfio->state == VFIO_DEVICE_STATE_ERROR) {
+			pds_vfio->state = VFIO_DEVICE_STATE_RUNNING;
+			pds_vfio_put_restore_file(pds_vfio);
+			pds_vfio_put_save_file(pds_vfio);
+		}
+		spin_unlock(&pds_vfio->reset_lock);
+		goto again;
+	}
+	mutex_unlock(&pds_vfio->state_mutex);
+	spin_unlock(&pds_vfio->reset_lock);
+}
+
+void pds_vfio_reset(struct pds_vfio_pci_device *pds_vfio)
+{
+	spin_lock(&pds_vfio->reset_lock);
+	pds_vfio->deferred_reset = true;
+	if (!mutex_trylock(&pds_vfio->state_mutex)) {
+		spin_unlock(&pds_vfio->reset_lock);
+		return;
+	}
+	spin_unlock(&pds_vfio->reset_lock);
+	pds_vfio_state_mutex_unlock(pds_vfio);
+}
+
+static struct file *
+pds_vfio_set_device_state(struct vfio_device *vdev,
+			  enum vfio_device_mig_state new_state)
+{
+	struct pds_vfio_pci_device *pds_vfio =
+		container_of(vdev, struct pds_vfio_pci_device,
+			     vfio_coredev.vdev);
+	struct file *res = NULL;
+
+	mutex_lock(&pds_vfio->state_mutex);
+	while (new_state != pds_vfio->state) {
+		enum vfio_device_mig_state next_state;
+
+		int err = vfio_mig_get_next_state(vdev, pds_vfio->state,
+						  new_state, &next_state);
+		if (err) {
+			res = ERR_PTR(err);
+			break;
+		}
+
+		res = pds_vfio_step_device_state_locked(pds_vfio, next_state);
+		if (IS_ERR(res))
+			break;
+
+		pds_vfio->state = next_state;
+
+		if (WARN_ON(res && new_state != pds_vfio->state)) {
+			res = ERR_PTR(-EINVAL);
+			break;
+		}
+	}
+	pds_vfio_state_mutex_unlock(pds_vfio);
+
+	return res;
+}
+
+static int pds_vfio_get_device_state(struct vfio_device *vdev,
+				     enum vfio_device_mig_state *current_state)
+{
+	struct pds_vfio_pci_device *pds_vfio =
+		container_of(vdev, struct pds_vfio_pci_device,
+			     vfio_coredev.vdev);
+
+	mutex_lock(&pds_vfio->state_mutex);
+	*current_state = pds_vfio->state;
+	pds_vfio_state_mutex_unlock(pds_vfio);
+	return 0;
+}
+
+static int pds_vfio_get_device_state_size(struct vfio_device *vdev,
+					  unsigned long *stop_copy_length)
+{
+	*stop_copy_length = PDS_LM_DEVICE_STATE_LENGTH;
+	return 0;
+}
+
+static const struct vfio_migration_ops pds_vfio_lm_ops = {
+	.migration_set_state = pds_vfio_set_device_state,
+	.migration_get_state = pds_vfio_get_device_state,
+	.migration_get_data_size = pds_vfio_get_device_state_size
+};
+
 static int pds_vfio_init_device(struct vfio_device *vdev)
 {
 	struct pds_vfio_pci_device *pds_vfio =
@@ -37,6 +135,9 @@ static int pds_vfio_init_device(struct vfio_device *vdev)
 
 	pds_vfio->vf_id = vf_id;
 
+	vdev->migration_flags = VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_P2P;
+	vdev->mig_ops = &pds_vfio_lm_ops;
+
 	pci_id = PCI_DEVID(pdev->bus->number, pdev->devfn);
 	dev_dbg(&pdev->dev,
 		"%s: PF %#04x VF %#04x vf_id %d domain %d pds_vfio %p\n",
@@ -57,17 +158,34 @@ static int pds_vfio_open_device(struct vfio_device *vdev)
 	if (err)
 		return err;
 
+	mutex_init(&pds_vfio->state_mutex);
+	pds_vfio->state = VFIO_DEVICE_STATE_RUNNING;
+
 	vfio_pci_core_finish_enable(&pds_vfio->vfio_coredev);
 
 	return 0;
 }
 
+static void pds_vfio_close_device(struct vfio_device *vdev)
+{
+	struct pds_vfio_pci_device *pds_vfio =
+		container_of(vdev, struct pds_vfio_pci_device,
+			     vfio_coredev.vdev);
+
+	mutex_lock(&pds_vfio->state_mutex);
+	pds_vfio_put_restore_file(pds_vfio);
+	pds_vfio_put_save_file(pds_vfio);
+	mutex_unlock(&pds_vfio->state_mutex);
+	mutex_destroy(&pds_vfio->state_mutex);
+	vfio_pci_core_close_device(vdev);
+}
+
 static const struct vfio_device_ops pds_vfio_ops = {
 	.name = "pds-vfio",
 	.init = pds_vfio_init_device,
 	.release = vfio_pci_core_release_dev,
 	.open_device = pds_vfio_open_device,
-	.close_device = vfio_pci_core_close_device,
+	.close_device = pds_vfio_close_device,
 	.ioctl = vfio_pci_core_ioctl,
 	.device_feature = vfio_pci_core_ioctl_feature,
 	.read = vfio_pci_core_read,
diff --git a/drivers/vfio/pci/pds/vfio_dev.h b/drivers/vfio/pci/pds/vfio_dev.h
index 824832aa1513..31bd14de0c91 100644
--- a/drivers/vfio/pci/pds/vfio_dev.h
+++ b/drivers/vfio/pci/pds/vfio_dev.h
@@ -7,19 +7,30 @@
 #include <linux/pci.h>
 #include <linux/vfio_pci_core.h>
 
+#include "lm.h"
+
 struct pdsc;
 
 struct pds_vfio_pci_device {
 	struct vfio_pci_core_device vfio_coredev;
 	struct pdsc *pdsc;
 
+	struct pds_vfio_lm_file *save_file;
+	struct pds_vfio_lm_file *restore_file;
+	struct mutex state_mutex; /* protect migration state */
+	enum vfio_device_mig_state state;
+	spinlock_t reset_lock; /* protect reset_done flow */
+	u8 deferred_reset;
+
 	int vf_id;
 	u16 client_id;
 };
 
 const struct vfio_device_ops *pds_vfio_ops_info(void);
 struct pds_vfio_pci_device *pds_vfio_pci_drvdata(struct pci_dev *pdev);
+void pds_vfio_reset(struct pds_vfio_pci_device *pds_vfio);
 
 struct pci_dev *pds_vfio_to_pci_dev(struct pds_vfio_pci_device *pds_vfio);
+struct device *pds_vfio_to_dev(struct pds_vfio_pci_device *pds_vfio);
 
 #endif /* _VFIO_DEV_H_ */
diff --git a/include/linux/pds/pds_adminq.h b/include/linux/pds/pds_adminq.h
index bcba7fda3cc9..9c79b3c8fc47 100644
--- a/include/linux/pds/pds_adminq.h
+++ b/include/linux/pds/pds_adminq.h
@@ -818,6 +818,194 @@ struct pds_vdpa_set_features_cmd {
 	__le64 features;
 };
 
+#define PDS_LM_DEVICE_STATE_LENGTH		65536
+#define PDS_LM_CHECK_DEVICE_STATE_LENGTH(X) \
+			PDS_CORE_SIZE_CHECK(union, PDS_LM_DEVICE_STATE_LENGTH, X)
+
+/*
+ * enum pds_lm_cmd_opcode - Live Migration Device commands
+ */
+enum pds_lm_cmd_opcode {
+	PDS_LM_CMD_HOST_VF_STATUS  = 1,
+
+	/* Device state commands */
+	PDS_LM_CMD_STATE_SIZE	   = 16,
+	PDS_LM_CMD_SUSPEND         = 18,
+	PDS_LM_CMD_SUSPEND_STATUS  = 19,
+	PDS_LM_CMD_RESUME          = 20,
+	PDS_LM_CMD_SAVE            = 21,
+	PDS_LM_CMD_RESTORE         = 22,
+};
+
+/**
+ * struct pds_lm_cmd - generic command
+ * @opcode:	Opcode
+ * @rsvd:	Word boundary padding
+ * @vf_id:	VF id
+ * @rsvd2:	Structure padding to 60 Bytes
+ */
+struct pds_lm_cmd {
+	u8     opcode;
+	u8     rsvd;
+	__le16 vf_id;
+	u8     rsvd2[56];
+};
+
+/**
+ * struct pds_lm_state_size_cmd - STATE_SIZE command
+ * @opcode:	Opcode
+ * @rsvd:	Word boundary padding
+ * @vf_id:	VF id
+ */
+struct pds_lm_state_size_cmd {
+	u8     opcode;
+	u8     rsvd;
+	__le16 vf_id;
+};
+
+/**
+ * struct pds_lm_state_size_comp - STATE_SIZE command completion
+ * @status:		Status of the command (enum pds_core_status_code)
+ * @rsvd:		Word boundary padding
+ * @comp_index:		Index in the desc ring for which this is the completion
+ * @size:		Size of the device state
+ * @rsvd2:		Word boundary padding
+ * @color:		Color bit
+ */
+struct pds_lm_state_size_comp {
+	u8     status;
+	u8     rsvd;
+	__le16 comp_index;
+	union {
+		__le64 size;
+		u8     rsvd2[11];
+	} __packed;
+	u8     color;
+};
+
+enum pds_lm_suspend_resume_type {
+	PDS_LM_SUSPEND_RESUME_TYPE_FULL = 0,
+	PDS_LM_SUSPEND_RESUME_TYPE_P2P = 1,
+};
+
+/**
+ * struct pds_lm_suspend_cmd - SUSPEND command
+ * @opcode:	Opcode PDS_LM_CMD_SUSPEND
+ * @rsvd:	Word boundary padding
+ * @vf_id:	VF id
+ * @type:	Type of suspend (enum pds_lm_suspend_resume_type)
+ */
+struct pds_lm_suspend_cmd {
+	u8     opcode;
+	u8     rsvd;
+	__le16 vf_id;
+	u8     type;
+};
+
+/**
+ * struct pds_lm_suspend_status_cmd - SUSPEND status command
+ * @opcode:	Opcode PDS_AQ_CMD_LM_SUSPEND_STATUS
+ * @rsvd:	Word boundary padding
+ * @vf_id:	VF id
+ * @type:	Type of suspend (enum pds_lm_suspend_resume_type)
+ */
+struct pds_lm_suspend_status_cmd {
+	u8 opcode;
+	u8 rsvd;
+	__le16 vf_id;
+	u8 type;
+};
+
+/**
+ * struct pds_lm_resume_cmd - RESUME command
+ * @opcode:	Opcode PDS_LM_CMD_RESUME
+ * @rsvd:	Word boundary padding
+ * @vf_id:	VF id
+ * @type:	Type of resume (enum pds_lm_suspend_resume_type)
+ */
+struct pds_lm_resume_cmd {
+	u8     opcode;
+	u8     rsvd;
+	__le16 vf_id;
+	u8     type;
+};
+
+/**
+ * struct pds_lm_sg_elem - Transmit scatter-gather (SG) descriptor element
+ * @addr:	DMA address of SG element data buffer
+ * @len:	Length of SG element data buffer, in bytes
+ * @rsvd:	Word boundary padding
+ */
+struct pds_lm_sg_elem {
+	__le64 addr;
+	__le32 len;
+	__le16 rsvd[2];
+};
+
+/**
+ * struct pds_lm_save_cmd - SAVE command
+ * @opcode:	Opcode PDS_LM_CMD_SAVE
+ * @rsvd:	Word boundary padding
+ * @vf_id:	VF id
+ * @rsvd2:	Word boundary padding
+ * @sgl_addr:	IOVA address of the SGL to dma the device state
+ * @num_sge:	Total number of SG elements
+ */
+struct pds_lm_save_cmd {
+	u8     opcode;
+	u8     rsvd;
+	__le16 vf_id;
+	u8     rsvd2[4];
+	__le64 sgl_addr;
+	__le32 num_sge;
+} __packed;
+
+/**
+ * struct pds_lm_restore_cmd - RESTORE command
+ * @opcode:	Opcode PDS_LM_CMD_RESTORE
+ * @rsvd:	Word boundary padding
+ * @vf_id:	VF id
+ * @rsvd2:	Word boundary padding
+ * @sgl_addr:	IOVA address of the SGL to dma the device state
+ * @num_sge:	Total number of SG elements
+ */
+struct pds_lm_restore_cmd {
+	u8     opcode;
+	u8     rsvd;
+	__le16 vf_id;
+	u8     rsvd2[4];
+	__le64 sgl_addr;
+	__le32 num_sge;
+} __packed;
+
+/**
+ * union pds_lm_dev_state - device state information
+ * @words:	Device state words
+ */
+union pds_lm_dev_state {
+	__le32 words[PDS_LM_DEVICE_STATE_LENGTH / sizeof(__le32)];
+};
+
+enum pds_lm_host_vf_status {
+	PDS_LM_STA_NONE = 0,
+	PDS_LM_STA_IN_PROGRESS,
+	PDS_LM_STA_MAX,
+};
+
+/**
+ * struct pds_lm_host_vf_status_cmd - HOST_VF_STATUS command
+ * @opcode:	Opcode PDS_LM_CMD_HOST_VF_STATUS
+ * @rsvd:	Word boundary padding
+ * @vf_id:	VF id
+ * @status:	Current LM status of host VF driver (enum pds_lm_host_status)
+ */
+struct pds_lm_host_vf_status_cmd {
+	u8     opcode;
+	u8     rsvd;
+	__le16 vf_id;
+	u8     status;
+};
+
 union pds_core_adminq_cmd {
 	u8     opcode;
 	u8     bytes[64];
@@ -844,6 +1032,13 @@ union pds_core_adminq_cmd {
 	struct pds_vdpa_vq_init_cmd	  vdpa_vq_init;
 	struct pds_vdpa_vq_reset_cmd	  vdpa_vq_reset;
 
+	struct pds_lm_suspend_cmd	  lm_suspend;
+	struct pds_lm_suspend_status_cmd  lm_suspend_status;
+	struct pds_lm_resume_cmd	  lm_resume;
+	struct pds_lm_state_size_cmd	  lm_state_size;
+	struct pds_lm_save_cmd		  lm_save;
+	struct pds_lm_restore_cmd	  lm_restore;
+	struct pds_lm_host_vf_status_cmd  lm_host_vf_status;
 };
 
 union pds_core_adminq_comp {
@@ -868,6 +1063,8 @@ union pds_core_adminq_comp {
 
 	struct pds_vdpa_vq_init_comp	  vdpa_vq_init;
 	struct pds_vdpa_vq_reset_comp	  vdpa_vq_reset;
+
+	struct pds_lm_state_size_comp	  lm_state_size;
 };
 
 #ifndef __CHECKER__
-- 
2.17.1

