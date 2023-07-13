Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21CE8751563
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 02:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233011AbjGMAiB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 20:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232801AbjGMAh5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 20:37:57 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2075.outbound.protection.outlook.com [40.107.92.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 060912102;
        Wed, 12 Jul 2023 17:37:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e6qMlAnYxBRlnZlFwFS+gWOe2cghrzeoPDRy1WDyP8bq06cEdxXNuPwUzsZzf5dLzzI1R0RinHUKjPF0S3/ULjZG9ZLxkK+7SVOlWytqYjXXpAtdfacYVCxHm9ckJvU6ZBvyKPs09Myk1trnmxVAF3HqYve4xBFvXkRMmkIq8scjpWNuO0kHf7fBJ6jfdJhxc1AkRWNKss8gwfF/t6ZYiLejpHaoGN2XR5TRYZihh0cv2ZPcEq9YS/j3bvYdY8EAM1V3XWOBgjO+YhkdOTE9oob04FdreyIhriLWwE90fFh5NWhswksftEhCsWsMsCaKL4XLuWGgFHVHhQqY1B+1Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ad9eew3UxzXlhFCK0o+Gt1Yk0iZEZrBshErmLHK32Y4=;
 b=FxqIna4Q9ySTD/9bTTQIPGqZ1AnaG1iVzhJTmPPrGsZmdQwDfV8fnvrjDZGrYDa/JkSDQIcQ84pdk1Bo+ZSESRzvBQogxixepHAlGRxDw94C07SwVYi0FKq2hL1Apz/Oi0bjtMiyHYdZLxmi38QPiQfnvWSsQdY+pxPsg2q6iY4uibEg68V+YgR8Cxfy9UqGHfetLEKLavXEEW+8eqbdTEo4cLLPAj4zl3ss04u9a5kz91giMGVU+kHgt4nkygOI+TeScPHzAt7CTROo4uB8mzEsU2hzRhNyaiVEDYblxW//QYz8wGi6fFXdOYnj5kIo52xb+9f/xb1rfOL4VHTV3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ad9eew3UxzXlhFCK0o+Gt1Yk0iZEZrBshErmLHK32Y4=;
 b=Vy5s2arvhgAl9kw/lnKWEt+MJnBJXyR9MkpQeKQSVJJfUpDzsO3jqUM6iQFxDNrCjnS34ouosHm+Fd2Jk1Olvdh39N5Fgag+OyEpD4gJRwk31w247bW8pWg9qByTKLNCFVuDuRM4aBe+RXJQQ4AZyNGkWjfz4UNF4cghlQ6FyQA=
Received: from MW4PR04CA0097.namprd04.prod.outlook.com (2603:10b6:303:83::12)
 by DM6PR12MB4265.namprd12.prod.outlook.com (2603:10b6:5:211::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.20; Thu, 13 Jul
 2023 00:37:50 +0000
Received: from CO1NAM11FT093.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:83:cafe::e0) by MW4PR04CA0097.outlook.office365.com
 (2603:10b6:303:83::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.20 via Frontend
 Transport; Thu, 13 Jul 2023 00:37:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT093.mail.protection.outlook.com (10.13.175.59) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6588.24 via Frontend Transport; Thu, 13 Jul 2023 00:37:50 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 12 Jul
 2023 19:37:48 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>
CC:     <brett.creeley@amd.com>, <shannon.nelson@amd.com>
Subject: [PATCH v11 vfio 3/7] vfio/pds: register with the pds_core PF
Date:   Wed, 12 Jul 2023 17:37:23 -0700
Message-ID: <20230713003727.11226-4-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230713003727.11226-1-brett.creeley@amd.com>
References: <20230713003727.11226-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT093:EE_|DM6PR12MB4265:EE_
X-MS-Office365-Filtering-Correlation-Id: 2640e14c-4f7a-4c65-da3c-08db8339633a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nzGJNIwftcVCJwp2rnIB5b6dUUfXa7asQy8qaKIDg0sGtNb1qhXSZPH1Vv4VPnUBEbiAGRek1WG4Ibo6GIRM4halYN9krNPyJ3Lda9z2E+FSM9LKj71b8tGY4sqknQSn0OQnqdhHq+6ifbZHmPnv5lxiT87aN/cXtGPuiNgfNDpFDdTejJNRACWTapjZG+EIfLCLy2PQiggIxvjeYHqGazorzdP1l4lS4SSU2jJVGrQ0PeKjhrf4fRTvo7ATHFoSKCG6IWe6OCxXcQXhnJwjUTcsDhQJqiu3n2JJGSJ1l1rdcz7IfzXoQ7vKdZUjXHTSp69n3eKCXV9VRDNW4YmwDc7SLafcHXLxFdKi2NpvlvStDxPA+5Xc/ydLxVYjFrJCplygnSo7CQ9xPq4FLOsbYkNuB3sAXujaRE6m1IXkoW2l6ALSk3/VvNizZgW77qFE1T/Y/+5oqcY9p3pzgV5UqNdDUN/hNR1UTj+A32go373w0KnIBPJMijmqLUi4Y6GZOGO3aaIbyoBfiUDioiy76McyL/lNsCCN38iKBq6xQfaJM8VJeKDQlSAkJ+povglbMfdZjMnhHyLe6pJnhyZgnMh1G6DHmiluW2nGb25fBlp+ztkECsf5CJfeO7xsZMoqrlheNZMkrsm5Gx/6/bpeJW+e9SM1MxnB4t/f4TV/SiCz0Fpk6r4MPyHQItUuFhtRMHpPBS74XUgknKEGVOBVpA/fO0DV5ptonJZfDVtpyryyjTDKpVMSGOdlcJUb1VWqMvo6CRhgrtRUIpq7JRAk4A==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(396003)(39860400002)(136003)(451199021)(40470700004)(36840700001)(46966006)(47076005)(83380400001)(36860700001)(41300700001)(426003)(2616005)(44832011)(110136005)(16526019)(186003)(36756003)(336012)(40460700003)(2906002)(5660300002)(81166007)(82740400003)(356005)(26005)(4326008)(8936002)(40480700001)(8676002)(1076003)(316002)(86362001)(82310400005)(70206006)(54906003)(70586007)(478600001)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2023 00:37:50.2670
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2640e14c-4f7a-4c65-da3c-08db8339633a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT093.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4265
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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
---
 drivers/vfio/pci/pds/Makefile   |  1 +
 drivers/vfio/pci/pds/cmds.c     | 44 +++++++++++++++++++++++++++++++++
 drivers/vfio/pci/pds/cmds.h     | 10 ++++++++
 drivers/vfio/pci/pds/pci_drv.c  | 19 ++++++++++++++
 drivers/vfio/pci/pds/pci_drv.h  |  9 +++++++
 drivers/vfio/pci/pds/vfio_dev.c | 13 +++++++++-
 drivers/vfio/pci/pds/vfio_dev.h |  6 +++++
 include/linux/pds/pds_common.h  |  3 ++-
 8 files changed, 103 insertions(+), 2 deletions(-)
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
index 000000000000..d6925bceed26
--- /dev/null
+++ b/drivers/vfio/pci/pds/cmds.c
@@ -0,0 +1,44 @@
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
+	int ci;
+
+	snprintf(devname, sizeof(devname), "%s.%d-%u", PDS_LM_DEV_NAME,
+		 pci_domain_nr(pdev->bus),
+		 PCI_DEVID(pdev->bus->number, pdev->devfn));
+
+	ci = pds_client_register(pci_physfn(pdev), devname);
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
+	int err;
+
+	err = pds_client_unregister(pci_physfn(pdev), pds_vfio->client_id);
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
index 4670ddda603a..928903a84f27 100644
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
@@ -27,13 +31,27 @@ static int pds_vfio_pci_probe(struct pci_dev *pdev,
 		return PTR_ERR(pds_vfio);
 
 	dev_set_drvdata(&pdev->dev, &pds_vfio->vfio_coredev);
+	pds_vfio->pdsc = pdsc_get_pf_struct(pdev);
+	if (IS_ERR_OR_NULL(pds_vfio->pdsc)) {
+		err = PTR_ERR(pds_vfio->pdsc) ?: -ENODEV;
+		goto out_put_vdev;
+	}
 
 	err = vfio_pci_core_register_device(&pds_vfio->vfio_coredev);
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
@@ -43,6 +61,7 @@ static void pds_vfio_pci_remove(struct pci_dev *pdev)
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
index 7c125643f5d9..5299cfb262d5 100644
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
 
 	err = vfio_pci_core_init_dev(vdev);
 	if (err)
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
index a4d4b65778d1..824832aa1513 100644
--- a/drivers/vfio/pci/pds/vfio_dev.h
+++ b/drivers/vfio/pci/pds/vfio_dev.h
@@ -7,13 +7,19 @@
 #include <linux/pci.h>
 #include <linux/vfio_pci_core.h>
 
+struct pdsc;
+
 struct pds_vfio_pci_device {
 	struct vfio_pci_core_device vfio_coredev;
+	struct pdsc *pdsc;
 
 	int vf_id;
+	u16 client_id;
 };
 
 const struct vfio_device_ops *pds_vfio_ops_info(void);
 struct pds_vfio_pci_device *pds_vfio_pci_drvdata(struct pci_dev *pdev);
 
+struct pci_dev *pds_vfio_to_pci_dev(struct pds_vfio_pci_device *pds_vfio);
+
 #endif /* _VFIO_DEV_H_ */
diff --git a/include/linux/pds/pds_common.h b/include/linux/pds/pds_common.h
index 435c8e8161c2..255c7c186bf5 100644
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
+#define PDS_LM_DEV_NAME		PDS_CORE_DRV_NAME "." PDS_DEV_TYPE_LM_STR "." PDS_DEV_TYPE_VFIO_STR
 
 int pdsc_register_notify(struct notifier_block *nb);
 void pdsc_unregister_notify(struct notifier_block *nb);
-- 
2.17.1

