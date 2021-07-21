Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1413D13B4
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 18:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233187AbhGUPg5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 11:36:57 -0400
Received: from mail-bn8nam12on2070.outbound.protection.outlook.com ([40.107.237.70]:7360
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232890AbhGUPg4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jul 2021 11:36:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nVixLUBY6FnHvSBeiMO1LNA/n5RCrmrUQdCjdXa8mjLs7zE4heFUQ+Z27dssTuH6iowS65kwWwRESperUe3hSC6XpQpQWvNsEq17CDHWD3JRwUK1PjgKGwdAWfqDf7PTO3yH61p3Df5eJsoBm25S9mWC0CtRFvjIjJBUK5fVaMNFEW2Rxcg5DDBe52GDGemKyxGPUwTGQA3ILYzL9FMXdbbhiJM55iuZvKUBaaBfJfg4MPFXqDeVPmYj+wkckFSKIM+X7biycS8dNXIA3m8V5TZ5K5dR4M4JrRwjotiPrd4Z/78f9hv4VxUg2BO49bYkbepq6OCxtVvaMSenFaQj4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jFGdMLqtQz7j257Z35dI7FaXU6yqAVkeZe9paxiisqM=;
 b=UjF9swvmKs2vCuyNxdezv/oXoBJMbXrPOj96lJ9UgW82AD9LtjKIRDXCJ5qSZm8r5akPjsKKtpS9elXU8gby/VI7kLk+ZyvI9Li23Gl0//OuPMBSVHCz+xzeDRZXXFFBCS3avhkgWcHsR4eZjtno39EZbnnGBYeH/00HuNwsrkhSDxYyZGMtPGYOJ65bqaUvYevMgtKF+gVHat+7Hp0V9qxRcMUDyH3TFYiHuhzqLZEtOMSw0RE0PmeGKB1rG0iJaaN7oPt12E9vgzzUVLQUopRSWJf5LtNcKgneS8EC2nN/fyMbU/eRKn9Jz00mxK0H7kBhgyjSQCn+iOlXxlJJyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jFGdMLqtQz7j257Z35dI7FaXU6yqAVkeZe9paxiisqM=;
 b=hx3h53e/qpey3/HEQQ03rVY4PMdwa4lLX6Umlhdsmi+W3PrG8sQctIkwkJQmaScDBIIzSMM4S4J83WXGKZY9mnP2XXOIopAjgbpyPmX9OD8RnAzYp3QccCKyo14JJoXS9VJ/lXUpGIRlCy805jqLdvZfDdedsPeJexhUsItqpxuW0LifOkcbU8G3GKytFfD7NMLY7ueZMV3wLFVA4ZEgtaTxmEyvwPO8Dv2Lg7NcsM9tbvB+Ht+cd3XjEi+/QLidcWn5GssStbYxkKx9L5ZvUFCCOjOGQHyZY57pbKl8uQ5d3WZ16DsdDH12zcmnihlr6hQciND4Yx7EOtBvPMPpZQ==
Received: from DM5PR17CA0053.namprd17.prod.outlook.com (2603:10b6:3:13f::15)
 by DM4PR12MB5230.namprd12.prod.outlook.com (2603:10b6:5:399::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Wed, 21 Jul
 2021 16:17:31 +0000
Received: from DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:13f:cafe::7a) by DM5PR17CA0053.outlook.office365.com
 (2603:10b6:3:13f::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend
 Transport; Wed, 21 Jul 2021 16:17:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT004.mail.protection.outlook.com (10.13.172.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Wed, 21 Jul 2021 16:17:31 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Jul
 2021 09:17:30 -0700
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 21 Jul 2021 16:17:26 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <bhelgaas@google.com>, <corbet@lwn.net>,
        <alex.williamson@redhat.com>, <diana.craciun@oss.nxp.com>,
        <kwankhede@nvidia.com>, <eric.auger@redhat.com>,
        <masahiroy@kernel.org>, <michal.lkml@markovi.net>
CC:     <linux-pci@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-kbuild@vger.kernel.org>, <mgurtovoy@nvidia.com>,
        <jgg@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <leonro@nvidia.com>
Subject: [PATCH 02/12] vfio/pci: Rename vfio_pci_private.h to vfio_pci_core.h
Date:   Wed, 21 Jul 2021 19:15:59 +0300
Message-ID: <20210721161609.68223-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210721161609.68223-1-yishaih@nvidia.com>
References: <20210721161609.68223-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba130c34-b622-4b6f-8243-08d94c630a90
X-MS-TrafficTypeDiagnostic: DM4PR12MB5230:
X-Microsoft-Antispam-PRVS: <DM4PR12MB52302A9C99C12BBE53AD1BCDC3E39@DM4PR12MB5230.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5PIxlHLXgsbQwxOVJqnw6/HKxceDpFG50cQQEC/+8KL/0OrVAkrQiHvemx+frwfvX+sUSGh5KPPozbO8HIaVEBqzNqf8OMSZG0oKGH6wtJTKzgHJZG/CkmoWbwsdtMuv0RDGnO8FX0Avm7GoikYvRupGs8WaAuGBYhrftqm2EgLS7pVFxD6ORcrzF1xipXQEG70nNaOT4qon5vaUkYvaELFlw+xO8rtSp7DsFLZW3GE4DstXN7PB6e0pTe507nOc2oQozwTXeog+0aKGJ7uLBJ0F/MSA2K8dVExDq5wevDnp7ZbODu7l/M3ZINofFYoIhB/0Cd+XZeVwZhayIsx3fL5UbcmB1y82lFJLUhlbTeQT6JlLBvWSk0Vn1pl/thmAHawEy+R7p3irNmO71VN6f5B2xzuM+tC48+jja4oto2Zns5J1vNMqgRzSrllejhVi3EUyzoyoT4v24WfRIGpBMhzxH7ZOU9avhHn4PzoC1GV/LXXcT5iKmyuSLK1Vqh2tjG+HdzKVUnHKA5t4FWisDotOoT3HfmqLXCaRZJf6JhRfug7fXS8FGoKSfToL+PsMkOOsA/MmZLrJKTgBxOPBzXZCjO2kapAdFbeZjscNsZP3GlibGOTJNTS6J5t7VaTba+RJ0H+brDys2iaavg7IjtI3/K488X18bMhwDWcceAKwxls87N7qW1LBh6y0ZXddTiLbLOAfPvrIwyDHyim7UcO5bw6ztwrLFuj+/QcE4Ag=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(136003)(376002)(346002)(36840700001)(46966006)(36860700001)(316002)(110136005)(83380400001)(8936002)(6666004)(7636003)(1076003)(86362001)(82310400003)(70206006)(356005)(70586007)(2906002)(36756003)(478600001)(54906003)(7416002)(82740400003)(5660300002)(186003)(26005)(336012)(107886003)(4326008)(47076005)(426003)(8676002)(7696005)(2616005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2021 16:17:31.0912
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ba130c34-b622-4b6f-8243-08d94c630a90
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5230
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Max Gurtovoy <mgurtovoy@nvidia.com>

This is a preparation patch for separating the vfio_pci driver to a
subsystem driver and a generic pci driver. This patch doesn't change any
logic.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_config.c                       | 2 +-
 drivers/vfio/pci/vfio_pci_core.c                         | 2 +-
 drivers/vfio/pci/{vfio_pci_private.h => vfio_pci_core.h} | 6 +++---
 drivers/vfio/pci/vfio_pci_igd.c                          | 2 +-
 drivers/vfio/pci/vfio_pci_intrs.c                        | 2 +-
 drivers/vfio/pci/vfio_pci_rdwr.c                         | 2 +-
 drivers/vfio/pci/vfio_pci_zdev.c                         | 2 +-
 7 files changed, 9 insertions(+), 9 deletions(-)
 rename drivers/vfio/pci/{vfio_pci_private.h => vfio_pci_core.h} (98%)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 70e28efbc51f..0bc269c0b03f 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -26,7 +26,7 @@
 #include <linux/vfio.h>
 #include <linux/slab.h>
 
-#include "vfio_pci_private.h"
+#include "vfio_pci_core.h"
 
 /* Fake capability ID for standard config space */
 #define PCI_CAP_ID_BASIC	0
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index d751d38f2175..51eb96375e98 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -28,7 +28,7 @@
 #include <linux/nospec.h>
 #include <linux/sched/mm.h>
 
-#include "vfio_pci_private.h"
+#include "vfio_pci_core.h"
 
 #define DRIVER_VERSION  "0.2"
 #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_core.h
similarity index 98%
rename from drivers/vfio/pci/vfio_pci_private.h
rename to drivers/vfio/pci/vfio_pci_core.h
index 70414b6c904d..ef26e781961d 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_core.h
@@ -15,8 +15,8 @@
 #include <linux/uuid.h>
 #include <linux/notifier.h>
 
-#ifndef VFIO_PCI_PRIVATE_H
-#define VFIO_PCI_PRIVATE_H
+#ifndef VFIO_PCI_CORE_H
+#define VFIO_PCI_CORE_H
 
 #define VFIO_PCI_OFFSET_SHIFT   40
 
@@ -205,4 +205,4 @@ static inline int vfio_pci_info_zdev_add_caps(struct vfio_pci_device *vdev,
 }
 #endif
 
-#endif /* VFIO_PCI_PRIVATE_H */
+#endif /* VFIO_PCI_CORE_H */
diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
index aa0a29fd2762..d57c409b4033 100644
--- a/drivers/vfio/pci/vfio_pci_igd.c
+++ b/drivers/vfio/pci/vfio_pci_igd.c
@@ -15,7 +15,7 @@
 #include <linux/uaccess.h>
 #include <linux/vfio.h>
 
-#include "vfio_pci_private.h"
+#include "vfio_pci_core.h"
 
 #define OPREGION_SIGNATURE	"IntelGraphicsMem"
 #define OPREGION_SIZE		(8 * 1024)
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 869dce5f134d..df1e8c8c274c 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -20,7 +20,7 @@
 #include <linux/wait.h>
 #include <linux/slab.h>
 
-#include "vfio_pci_private.h"
+#include "vfio_pci_core.h"
 
 /*
  * INTx
diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index a0b5fc8e46f4..667e82726e75 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -17,7 +17,7 @@
 #include <linux/vfio.h>
 #include <linux/vgaarb.h>
 
-#include "vfio_pci_private.h"
+#include "vfio_pci_core.h"
 
 #ifdef __LITTLE_ENDIAN
 #define vfio_ioread64	ioread64
diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
index 7b011b62c766..ecae0c3d95a0 100644
--- a/drivers/vfio/pci/vfio_pci_zdev.c
+++ b/drivers/vfio/pci/vfio_pci_zdev.c
@@ -19,7 +19,7 @@
 #include <asm/pci_clp.h>
 #include <asm/pci_io.h>
 
-#include "vfio_pci_private.h"
+#include "vfio_pci_core.h"
 
 /*
  * Add the Base PCI Function information to the device info region.
-- 
2.18.1

