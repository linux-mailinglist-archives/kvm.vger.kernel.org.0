Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9677730C5
	for <lists+kvm@lfdr.de>; Mon,  7 Aug 2023 22:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbjHGU6d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Aug 2023 16:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbjHGU6b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Aug 2023 16:58:31 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2063.outbound.protection.outlook.com [40.107.100.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E5810FF;
        Mon,  7 Aug 2023 13:58:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HO1J6fUr/wB+Xz9cwAVL07glrXFHw0hv8wJgKXoHIdbxVcyCu65S2+NgZnJFkdzgbt/ePoTIKqP5lnZ5E7HJB7u893WxY7Vd9ZMbodXZ1QzZdcURqrKX6lk5I9j9xKh0cDlJecTIH9UqtAKNlgXoPGOWBUq0Zx+yvEPtzlV3lejvlMsiFxsgI0itMtlw5YSL1slM0IlU16e1W61ft9gr6/x/ERs3s/rN8Sf3hn7tStIHC4OZjcjt0IgmrpbNLRhGe2chi3ryCeMS6neRZ/0Df5tE2vkXnfR0BU+C9MD0cMNvEnseBEtW2za7gcDh8j+XZi9KCmEG7DCjRkheYvrLOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A5fC8tUUVlgf9tM3K6DLLlNysW7+Zv0ovH9DuwvD3vY=;
 b=NJfGxildBqjuN0T8xede8Pm+rtUcIX8zWPxZK0QLOaiGQRrbY5WJ1YAWEtdN4nGNldYu+Z19LkqGU9rukWJFqfC1xd9fiubi741jBhuExVd9KPlaq3nC3Rl9Gd5/G0laMxQ9EB+mhr0ifLmXEL4pXH8lBBIAcMWZ3csgWdN3GZoA8HLMF8nbUBsydxz+Jdfjan9DGbtvUDTSgt7gKIJLgA0pViKhswqn9RLPoJO+3WnIQW8xxtu3E5dHZQNbPcudPSWovkieEwFGSh0q4bXKe9FfgxvOy1k+Mq9Y0l+BtiCXAG3khetzT4YfzOdPwB23KW8x3UpPZgEX8R6bH+xgoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A5fC8tUUVlgf9tM3K6DLLlNysW7+Zv0ovH9DuwvD3vY=;
 b=iUQrnRWvK4SpU+fEMqNpxUmeUrMnFlogJ8UJgh3MHbiQxPX2L1P9cOje9yjTh82a3demzGYdPKFXyUM19ZMGrEVnOahQoDUK5k9sLSIQgl88YB9E3fmtEJW58NSrA3lnPW+g94WNBnpXbgrcayPMeRWDlji8QnkQmhQFoEtIsQo=
Received: from BY3PR05CA0060.namprd05.prod.outlook.com (2603:10b6:a03:39b::35)
 by IA1PR12MB7520.namprd12.prod.outlook.com (2603:10b6:208:42f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.25; Mon, 7 Aug
 2023 20:58:26 +0000
Received: from MWH0EPF000989E6.namprd02.prod.outlook.com
 (2603:10b6:a03:39b:cafe::69) by BY3PR05CA0060.outlook.office365.com
 (2603:10b6:a03:39b::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.16 via Frontend
 Transport; Mon, 7 Aug 2023 20:58:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000989E6.mail.protection.outlook.com (10.167.241.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6652.20 via Frontend Transport; Mon, 7 Aug 2023 20:58:25 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 7 Aug
 2023 15:58:23 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>
CC:     <horms@kernel.org>, <brett.creeley@amd.com>,
        <shannon.nelson@amd.com>
Subject: [PATCH v14 vfio 4/8] vfio/pds: register with the pds_core PF
Date:   Mon, 7 Aug 2023 13:57:51 -0700
Message-ID: <20230807205755.29579-5-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230807205755.29579-1-brett.creeley@amd.com>
References: <20230807205755.29579-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000989E6:EE_|IA1PR12MB7520:EE_
X-MS-Office365-Filtering-Correlation-Id: 211ad162-f70b-4cde-aa15-08db97890af7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zOqQuBGObBUE8RUlMy11wNM1MVlQNOOv/PQscYfVMvGCCa2UXD0jtHibpA09KXr/YTjAlsQ27lmrQpao3O0w8uvLLucHtsZMI+YrNxg8dvbfkOjZKnml7324smACEteJluQL5c531mAo0JiUNO+bjeelroluUy+rhfc5M4SgEQgdnrlut39ZI2ydijxVou49a893lkrcAreIiy276ZhjfJR43Cn4HV/TdhNYDQmT3pb/ghhLcAkNK0ti2eEw9DLqhsp1nI0K/rtvXCXAmdBkC2TWo2smOLfJAcb45A9BmyEwY5/qOyDcSd4p7aBTANIHw/TIptWpjagQ6eYWD93cD4lWQB5XaYl9YTnGUqQXCt8pA9HCQqHGWZ4rt/oZU5rk7JeDgCiJB/CBGBUp+6+dYBQRmwsiRmR3j6YrVvsFG+8qyC+rEhLaqBDcB+446ik/Ytbq+kAHUtjXOQ0URr++NIOoKXcTGswGCo7449Hxq8VnCBlMXHotVUUEWZezj3GIXCK/v8nTNEmFbHTuuG7iLGiTynUtGCKVdxHayGAYiGRS3G1ycxbYa5KMBo0q8f3J+GSBOxQBkP0tt9YSh1EhQhV9tKotQS6fIpldIlQ22xoXZOVIJFGepqSCDgCMv0hiVKmQUieeUjQxHPpNdaEaM/C4vn1aQ3sIYj5zPZIfG2DdGwSPqTjP/PBlPwfBjFAyfZCK6UMHpEMwfEqoqDCaR9uyuAzi7lFIUyxKHcjb4seOWs0vGN1Oj+BLzMAVuhTsuvcCNdG6R3iM5JiwWw7ORg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(39860400002)(396003)(451199021)(1800799003)(186006)(82310400008)(40470700004)(36840700001)(46966006)(81166007)(40480700001)(40460700003)(2616005)(4326008)(110136005)(54906003)(6666004)(478600001)(86362001)(82740400003)(356005)(26005)(36756003)(1076003)(316002)(5660300002)(8936002)(44832011)(8676002)(41300700001)(2906002)(70206006)(16526019)(70586007)(336012)(47076005)(426003)(83380400001)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2023 20:58:25.1811
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 211ad162-f70b-4cde-aa15-08db97890af7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: MWH0EPF000989E6.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7520
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pds_core driver will supply adminq services, so find the PF
and register with the DSC services.

Use the following commands to enable a VF:
echo 1 > /sys/bus/pci/drivers/pds_core/$PF_BDF/sriov_numvfs

Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Simon Horman <horms@kernel.org>
---
 drivers/vfio/pci/pds/Makefile   |  1 +
 drivers/vfio/pci/pds/cmds.c     | 54 +++++++++++++++++++++++++++++++++
 drivers/vfio/pci/pds/cmds.h     | 10 ++++++
 drivers/vfio/pci/pds/pci_drv.c  | 14 +++++++++
 drivers/vfio/pci/pds/pci_drv.h  |  9 ++++++
 drivers/vfio/pci/pds/vfio_dev.c | 13 +++++++-
 drivers/vfio/pci/pds/vfio_dev.h |  3 ++
 include/linux/pds/pds_common.h  |  3 +-
 8 files changed, 105 insertions(+), 2 deletions(-)
 create mode 100644 drivers/vfio/pci/pds/cmds.c
 create mode 100644 drivers/vfio/pci/pds/cmds.h
 create mode 100644 drivers/vfio/pci/pds/pci_drv.h

diff --git a/drivers/vfio/pci/pds/Makefile b/drivers/vfio/pci/pds/Makefile
index e5e53a6d86d1..91587c7fe8f9 100644
--- a/drivers/vfio/pci/pds/Makefile
+++ b/drivers/vfio/pci/pds/Makefile
@@ -4,5 +4,6 @@
 obj-$(CONFIG_PDS_VFIO_PCI) += pds-vfio-pci.o
 
 pds-vfio-pci-y := \
+	cmds.o		\
 	pci_drv.o	\
 	vfio_dev.o
diff --git a/drivers/vfio/pci/pds/cmds.c b/drivers/vfio/pci/pds/cmds.c
new file mode 100644
index 000000000000..7f1618aa765d
--- /dev/null
+++ b/drivers/vfio/pci/pds/cmds.c
@@ -0,0 +1,54 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
+
+#include <linux/io.h>
+#include <linux/types.h>
+
+#include <linux/pds/pds_common.h>
+#include <linux/pds/pds_core_if.h>
+#include <linux/pds/pds_adminq.h>
+
+#include "vfio_dev.h"
+#include "cmds.h"
+
+int pds_vfio_register_client_cmd(struct pds_vfio_pci_device *pds_vfio)
+{
+	struct pci_dev *pdev = pds_vfio_to_pci_dev(pds_vfio);
+	char devname[PDS_DEVNAME_LEN];
+	struct pdsc *pdsc;
+	int ci;
+
+	snprintf(devname, sizeof(devname), "%s.%d-%u", PDS_VFIO_LM_DEV_NAME,
+		 pci_domain_nr(pdev->bus),
+		 PCI_DEVID(pdev->bus->number, pdev->devfn));
+
+	pdsc = pdsc_get_pf_struct(pdev);
+	if (IS_ERR(pdsc))
+		return PTR_ERR(pdsc);
+
+	ci = pds_client_register(pdsc, devname);
+	if (ci < 0)
+		return ci;
+
+	pds_vfio->client_id = ci;
+
+	return 0;
+}
+
+void pds_vfio_unregister_client_cmd(struct pds_vfio_pci_device *pds_vfio)
+{
+	struct pci_dev *pdev = pds_vfio_to_pci_dev(pds_vfio);
+	struct pdsc *pdsc;
+	int err;
+
+	pdsc = pdsc_get_pf_struct(pdev);
+	if (IS_ERR(pdsc))
+		return;
+
+	err = pds_client_unregister(pdsc, pds_vfio->client_id);
+	if (err)
+		dev_err(&pdev->dev, "unregister from DSC failed: %pe\n",
+			ERR_PTR(err));
+
+	pds_vfio->client_id = 0;
+}
diff --git a/drivers/vfio/pci/pds/cmds.h b/drivers/vfio/pci/pds/cmds.h
new file mode 100644
index 000000000000..4c592afccf89
--- /dev/null
+++ b/drivers/vfio/pci/pds/cmds.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
+
+#ifndef _CMDS_H_
+#define _CMDS_H_
+
+int pds_vfio_register_client_cmd(struct pds_vfio_pci_device *pds_vfio);
+void pds_vfio_unregister_client_cmd(struct pds_vfio_pci_device *pds_vfio);
+
+#endif /* _CMDS_H_ */
diff --git a/drivers/vfio/pci/pds/pci_drv.c b/drivers/vfio/pci/pds/pci_drv.c
index 4670ddda603a..d9d2725e2faa 100644
--- a/drivers/vfio/pci/pds/pci_drv.c
+++ b/drivers/vfio/pci/pds/pci_drv.c
@@ -8,9 +8,13 @@
 #include <linux/types.h>
 #include <linux/vfio.h>
 
+#include <linux/pds/pds_common.h>
 #include <linux/pds/pds_core_if.h>
+#include <linux/pds/pds_adminq.h>
 
 #include "vfio_dev.h"
+#include "pci_drv.h"
+#include "cmds.h"
 
 #define PDS_VFIO_DRV_DESCRIPTION	"AMD/Pensando VFIO Device Driver"
 #define PCI_VENDOR_ID_PENSANDO		0x1dd8
@@ -32,8 +36,17 @@ static int pds_vfio_pci_probe(struct pci_dev *pdev,
 	if (err)
 		goto out_put_vdev;
 
+	err = pds_vfio_register_client_cmd(pds_vfio);
+	if (err) {
+		dev_err(&pdev->dev, "failed to register as client: %pe\n",
+			ERR_PTR(err));
+		goto out_unregister_coredev;
+	}
+
 	return 0;
 
+out_unregister_coredev:
+	vfio_pci_core_unregister_device(&pds_vfio->vfio_coredev);
 out_put_vdev:
 	vfio_put_device(&pds_vfio->vfio_coredev.vdev);
 	return err;
@@ -43,6 +56,7 @@ static void pds_vfio_pci_remove(struct pci_dev *pdev)
 {
 	struct pds_vfio_pci_device *pds_vfio = pds_vfio_pci_drvdata(pdev);
 
+	pds_vfio_unregister_client_cmd(pds_vfio);
 	vfio_pci_core_unregister_device(&pds_vfio->vfio_coredev);
 	vfio_put_device(&pds_vfio->vfio_coredev.vdev);
 }
diff --git a/drivers/vfio/pci/pds/pci_drv.h b/drivers/vfio/pci/pds/pci_drv.h
new file mode 100644
index 000000000000..e79bed12ed14
--- /dev/null
+++ b/drivers/vfio/pci/pds/pci_drv.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
+
+#ifndef _PCI_DRV_H
+#define _PCI_DRV_H
+
+#include <linux/pci.h>
+
+#endif /* _PCI_DRV_H */
diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
index 6d7ff1e07373..ce42f0b461b3 100644
--- a/drivers/vfio/pci/pds/vfio_dev.c
+++ b/drivers/vfio/pci/pds/vfio_dev.c
@@ -6,6 +6,11 @@
 
 #include "vfio_dev.h"
 
+struct pci_dev *pds_vfio_to_pci_dev(struct pds_vfio_pci_device *pds_vfio)
+{
+	return pds_vfio->vfio_coredev.pdev;
+}
+
 struct pds_vfio_pci_device *pds_vfio_pci_drvdata(struct pci_dev *pdev)
 {
 	struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
@@ -20,7 +25,7 @@ static int pds_vfio_init_device(struct vfio_device *vdev)
 		container_of(vdev, struct pds_vfio_pci_device,
 			     vfio_coredev.vdev);
 	struct pci_dev *pdev = to_pci_dev(vdev->dev);
-	int err, vf_id;
+	int err, vf_id, pci_id;
 
 	vf_id = pci_iov_vf_id(pdev);
 	if (vf_id < 0)
@@ -32,6 +37,12 @@ static int pds_vfio_init_device(struct vfio_device *vdev)
 
 	pds_vfio->vf_id = vf_id;
 
+	pci_id = PCI_DEVID(pdev->bus->number, pdev->devfn);
+	dev_dbg(&pdev->dev,
+		"%s: PF %#04x VF %#04x vf_id %d domain %d pds_vfio %p\n",
+		__func__, pci_dev_id(pdev->physfn), pci_id, vf_id,
+		pci_domain_nr(pdev->bus), pds_vfio);
+
 	return 0;
 }
 
diff --git a/drivers/vfio/pci/pds/vfio_dev.h b/drivers/vfio/pci/pds/vfio_dev.h
index a4d4b65778d1..ba4ee8c0eda3 100644
--- a/drivers/vfio/pci/pds/vfio_dev.h
+++ b/drivers/vfio/pci/pds/vfio_dev.h
@@ -11,9 +11,12 @@ struct pds_vfio_pci_device {
 	struct vfio_pci_core_device vfio_coredev;
 
 	int vf_id;
+	u16 client_id;
 };
 
 const struct vfio_device_ops *pds_vfio_ops_info(void);
 struct pds_vfio_pci_device *pds_vfio_pci_drvdata(struct pci_dev *pdev);
 
+struct pci_dev *pds_vfio_to_pci_dev(struct pds_vfio_pci_device *pds_vfio);
+
 #endif /* _VFIO_DEV_H_ */
diff --git a/include/linux/pds/pds_common.h b/include/linux/pds/pds_common.h
index 04427dcc0a59..30581e2e04cc 100644
--- a/include/linux/pds/pds_common.h
+++ b/include/linux/pds/pds_common.h
@@ -34,12 +34,13 @@ enum pds_core_vif_types {
 
 #define PDS_DEV_TYPE_CORE_STR	"Core"
 #define PDS_DEV_TYPE_VDPA_STR	"vDPA"
-#define PDS_DEV_TYPE_VFIO_STR	"VFio"
+#define PDS_DEV_TYPE_VFIO_STR	"vfio"
 #define PDS_DEV_TYPE_ETH_STR	"Eth"
 #define PDS_DEV_TYPE_RDMA_STR	"RDMA"
 #define PDS_DEV_TYPE_LM_STR	"LM"
 
 #define PDS_VDPA_DEV_NAME	PDS_CORE_DRV_NAME "." PDS_DEV_TYPE_VDPA_STR
+#define PDS_VFIO_LM_DEV_NAME	PDS_CORE_DRV_NAME "." PDS_DEV_TYPE_LM_STR "." PDS_DEV_TYPE_VFIO_STR
 
 struct pdsc;
 
-- 
2.17.1

