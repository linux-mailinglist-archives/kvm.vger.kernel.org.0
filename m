Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D61D03F857B
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 12:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241566AbhHZKkm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 06:40:42 -0400
Received: from mail-bn8nam11on2049.outbound.protection.outlook.com ([40.107.236.49]:16609
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241542AbhHZKkf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 06:40:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aqZSLvSNn4S03WTD6FLPx+4g9TRpHUOktqeQRIsz77z+BAXTObXhHQRp+Lvmnbps5tttGDF4ffe6pQbN5qhNgOPqLSNpVzTgnuPY081XePEqBI7iVVcN14REuk+TGqjI4k0mh4g1TSjaphHZC91VU+bG6mjjHDCrqXY+98qrZd1/wPDhOEJ2R5TZ34bhw8orhn+L7w+SPkVxZCCDFb2wn2CymAXDtZfjglK46oKWbLxBaRWe+7oBAnm/0nKVdeI/9GbJLJ+7MtZtFN2NG8tXxFYH6FQNX8+A4jo76jovS+ppduZggeKBFw8EKsiQkViYFF4CMd6H3Cmj+IlBTsQlpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tPcaZ4t9qUom1rCQq0+zGKbfPNG1f0EVbXH+DCCt2ZY=;
 b=kuMYkV1z9bwEarnXMX93OQSs9layO5qnXbuqYINXQBdvDi/i3mo2BVD/YNM/412FKNAdTt1BWQh+vJNi7De4EU8SWUJF3FBO1Zpr0lr/zCxtLXsqIPvSoUWZBc3nP6Mx4chkTyikOVpRYLzzyAIseiRbBiq4w8nWgxpG+GC3ntCC3tf+9BEtLG+qf61jBEQuGBAvSLnS3OGUhiHHhFqgGDygbdMdc+kVnwZfp0FfirdMdL/ZpcCU7J59q7GlNHjE5wObYMYaQPHiVZRdIbjkTh4FaALfBEsRR0MhyIdtAa33IPhwCom0N1ei6EXcyruK0MC0UQQFZ843h/MxHVGRnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tPcaZ4t9qUom1rCQq0+zGKbfPNG1f0EVbXH+DCCt2ZY=;
 b=KC/0RSlbB6zISFSVH0R2DA79/GC0sX5QFbyaV/qDdp3OKoAewNAGwlxTD4txWq1XNs1dpzb+3BhLx16kiFGpm6PlMfxworKPSTeXh5eJc57i+wYJLeMe36smU9dOxP3PDUr3FBvlzbNH+rHzxa4VdETiOyqNpxLCKDp7EaTz9Bf5vSBufv9ZlI+9OLZ4zJI4xd6C+FHaXjP6UkkwuToHMBs5fOsq7EHqxkNUveQ8xFwu2VKoyuf/618yHpMVCIK1Ixz5vPjazXPYIJFhLMEhu2QiqEN8sr6x44cIPtOb0gOGKBvSiXduVlbYAhzOehP/o0uOilf8qfmb7h5UQRVWuw==
Received: from MW2PR2101CA0017.namprd21.prod.outlook.com (2603:10b6:302:1::30)
 by CH0PR12MB5369.namprd12.prod.outlook.com (2603:10b6:610:d4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Thu, 26 Aug
 2021 10:39:46 +0000
Received: from CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:302:1:cafe::81) by MW2PR2101CA0017.outlook.office365.com
 (2603:10b6:302:1::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.4 via Frontend
 Transport; Thu, 26 Aug 2021 10:39:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT046.mail.protection.outlook.com (10.13.174.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4457.17 via Frontend Transport; Thu, 26 Aug 2021 10:39:46 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 26 Aug
 2021 10:39:45 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 26 Aug 2021 10:39:41 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <bhelgaas@google.com>, <corbet@lwn.net>,
        <alex.williamson@redhat.com>, <diana.craciun@oss.nxp.com>,
        <kwankhede@nvidia.com>, <eric.auger@redhat.com>,
        <masahiroy@kernel.org>, <michal.lkml@markovi.net>
CC:     <linux-pci@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-kbuild@vger.kernel.org>, <mgurtovoy@nvidia.com>,
        <jgg@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <leonro@nvidia.com>, "Christoph Hellwig" <hch@lst.de>
Subject: [PATCH V5 02/13] vfio/pci: Rename vfio_pci_private.h to vfio_pci_core.h
Date:   Thu, 26 Aug 2021 13:39:01 +0300
Message-ID: <20210826103912.128972-3-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210826103912.128972-1-yishaih@nvidia.com>
References: <20210826103912.128972-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b6112d46-5445-481a-42fe-08d9687dd2a0
X-MS-TrafficTypeDiagnostic: CH0PR12MB5369:
X-Microsoft-Antispam-PRVS: <CH0PR12MB5369B8B479F5E46C655DF022C3C79@CH0PR12MB5369.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NS1PU44/ZHuoI70mNNvVaBB5LP0zKmHFHyzGSbYwHMrv6ho6p5m16MQtMUbU+HnJ0ZxV4IYmC5Sydx1JR+6VPcwN7xf7zEdm0agtOXPfFWtJPmEnf41+Lk4mJObLnBeGjWd1sPVm+4LjE+8jJxNYmMpKCvqRbNpKuWO5wgpKa2/ELrjMt/Lywh9I5sTFjLUrZOMJ0fU3m2XkcEHDbLGKMkbbvS4JDBcjD9UCod34ubHlXwJLieH3Oon1HqSbfQ/1002A6Gi/xCS0WuYph3gq5NcjSbWfjCLfRbB6OhCQacIfC/uXHBPw/GOv1qhBQodcRNcZQSnjaX6o9suMivhv82WOqmwc/yzrABNJHd4fRN1M3jT99T5sTtJ3lGAUp9Lc/+hmcM36xAuYClLr2IcBs2LF8TNgEra0ztnjVKX02IpYJvWDfx4n58Zd/Snsl31E6f10XVQjMaCSoB9mVO31HevyGhoknsD4RjgBWVJX9vKf6ts4bTXUAecr/ciXzKibt3Cga8x8pVjK091Pfs0AfPRDXT9R2UjpcB3izsB9EZWn9JseQpdlPqMWiC4bVSg49kMrz/eTyLYK1a/EjXUOIlElswL3XYXy9EvChVGhjSyphpZjOG4h49a4ZFJIX3LKOv3jZGcIi6576pPUQ1lU6WqZCWhmaKLTLCJA9hes/ys4vui22YmW6psq9bqDLg9PSlljr1wuqZ9uSSw4rl1z//3aBEDwmsl4fp7FPGMORBU=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(136003)(346002)(36840700001)(46966006)(316002)(54906003)(110136005)(2616005)(8676002)(26005)(36906005)(8936002)(70206006)(478600001)(70586007)(7696005)(7416002)(5660300002)(186003)(336012)(426003)(2906002)(6666004)(356005)(7636003)(47076005)(82740400003)(83380400001)(86362001)(36756003)(36860700001)(1076003)(4326008)(82310400003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2021 10:39:46.2005
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b6112d46-5445-481a-42fe-08d9687dd2a0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5369
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Max Gurtovoy <mgurtovoy@nvidia.com>

This is a preparation patch for separating the vfio_pci driver to a
subsystem driver and a generic pci driver. This patch doesn't change any
logic.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
index a4f44ea52fa3..2a5dca0823c4 100644
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

