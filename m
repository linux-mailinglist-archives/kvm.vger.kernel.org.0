Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ADD03D13DD
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 18:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233381AbhGUPhc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 11:37:32 -0400
Received: from mail-mw2nam12on2086.outbound.protection.outlook.com ([40.107.244.86]:26305
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233815AbhGUPhb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jul 2021 11:37:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mNUJD2bvgU8bCtHHygHHxoL2g2bJW1+XdlLvSdOnBLkJMhsONBdQA/yvIJUgv88flFnrTTDKMzAR0fV2IPrAxjP9VGhgAWqhZr/3g0eDkuNl45NDR8drWBF6LA9eWTBDDum9NFywXR/PqnmpA4AAteQ1FEmGt2qwStpfZgkqJOEFDPC61qUKQ8D54hvzSakB2n2GgpfX9tQBad+kVya/Szoyh8IJelqK+jHnVjDmLdhwNwmImjY8DEVj2oBQ4A5vqCs49fgLgvPIz0B6NDVScnPvsFHGIUAX/Xt6cl+AujBF070YgGrd1Ozvt62Z07UmLNr1wYF7M7pZWGUaKoVb1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hcoz+mtO8t1q9AsRo4d5AWcflMVS8b8syDqG8CJho7c=;
 b=KtJsY+4Y4/BjxJ1EOF70T557QNKd4pEq7Hh8KWJP2sgydRsAyQpK41hoPVV8kfpYIL2Cgp/jn31j1oIS2c6+Alv9ImKF996LCjc8PqYfxo9qFsHUD2GXNPbPqHg9V2kri6quJvQnGde0swIO+kZ659GBvVfjmQ7rNtgwqkFlWlticwjzZl0wZ+XLnGzHRlfz+RnhfKYvaOwTz9CrkCYn9d7ypfgkOdw51PxrSmxMd3yu14RsUDkmLKoNq+qG88QIZG14JsYU2wffu90w6sgWrewE2jWb3vlnKNfUkXXX088x9Bc1fyhnIN6TudxnVsouB6dFKtYyl/ocIev2H8Okjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hcoz+mtO8t1q9AsRo4d5AWcflMVS8b8syDqG8CJho7c=;
 b=R94RJbLAo1XilL3TWKvv3dh7dRlrH3owBoDG/1nFJ1mis6Cre0ExRWPu7GRDPP7AasNsI4wF1RjCzVKqWCZaBhj1h8IMFV4h8iSQn8lJJMonr72d8XTgLhnnlZa5b9vzVMGicEmhBbldVpykUd8E0ndEZPWs5pWkQQIewQuofjrCl2S9kL4pKGAkM7S8gh6Rs84YdZ2LYnvxk5ySggHJIuW9Ij+k5OvdwjUeY/QcjuMutgrusiSJmBSjO4ADemsvuFS24fsJZf8R79X+6FAXnAjzByY3qWOlKj2HQwiLcu6mjfNboOWaOAig1iO5cdFjC4fQGPoLHepfGmfnt1rq3g==
Received: from MW4PR03CA0028.namprd03.prod.outlook.com (2603:10b6:303:8f::33)
 by BL1PR12MB5253.namprd12.prod.outlook.com (2603:10b6:208:30b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23; Wed, 21 Jul
 2021 16:18:06 +0000
Received: from CO1NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::e4) by MW4PR03CA0028.outlook.office365.com
 (2603:10b6:303:8f::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23 via Frontend
 Transport; Wed, 21 Jul 2021 16:18:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT005.mail.protection.outlook.com (10.13.174.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Wed, 21 Jul 2021 16:18:05 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Jul
 2021 16:18:05 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 21 Jul 2021 16:18:01 +0000
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
Subject: [PATCH 10/12] vfio: Use select for eventfd
Date:   Wed, 21 Jul 2021 19:16:07 +0300
Message-ID: <20210721161609.68223-11-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210721161609.68223-1-yishaih@nvidia.com>
References: <20210721161609.68223-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e61cc900-8c7f-469b-9845-08d94c631f36
X-MS-TrafficTypeDiagnostic: BL1PR12MB5253:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5253D72D46BCA45A6D5E2804C3E39@BL1PR12MB5253.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sUFtm07ZUX1cF6FFNetlWe4NiNGkzhKJAT3MVlOCSrEPOxTCzVBgAHMNayl5c9n1lY3PCco9QHexQ2OSMp+hXKy+tlsOmDv0THvGohMwJ4tSgnyiwfNncUb6ipGSu7a9Tntodd8njeXaVZgKv+111c0NA873IlBc0XlYjw7WKNDit6ruuDSF7j9WHuKHdZ1J+QGGLzectTWsp/AIt8ez/iPwbwgLF+laNQMG8i92oxUZFxgd1Zyxt6HX0rY8U6Ajqxh705mErOU6StrhDFJnGSVLW07XWUK0x068mZ0TfCt3rZT0uOhn6GHDa69VYC92BCGteCeNfRz5dysRblou3sEZMImWGpXehy9gD5mloFQavrX9r/se1V/uDLeEzRgaMdkz4poLtUmfNASrp4l/XDFgOHp3AABM0J8hjFYfzAz4PlMIvWkmThDm3yfPezYVMSlbtppnTG7VP0uz+CTsfMbbKnOXbD54Q5aEVuGO22+wUurY/cCq5/LjNbz3JjuZsUkEvnNSVnmBKZd8+DvNXysC9FC+ubtIXCFBkyKU5r2Gz7wA2ZLPyg1zmce9zUXmC7n8IGpJ/NZW+RVuuLTIncgDAX879sU0shx3FoJc2agwgvTb95m+AEx/EBvgk3wCi1cM8SoiwDsF7XkoIsz7GlKgF2Y0ddOIhcdHfwudnhU3xlI2dX5R938y2nKPUkMFq3ThUuIUNBj0kqL9xpLazfjcB0SaI2fBlD+xPBtM+6s=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(136003)(396003)(36840700001)(46966006)(82310400003)(316002)(83380400001)(356005)(8936002)(336012)(36906005)(426003)(1076003)(186003)(2616005)(70206006)(47076005)(478600001)(54906003)(70586007)(7636003)(7416002)(4326008)(110136005)(36860700001)(26005)(5660300002)(36756003)(2906002)(86362001)(107886003)(7696005)(8676002)(82740400003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2021 16:18:05.7631
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e61cc900-8c7f-469b-9845-08d94c631f36
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5253
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

If VFIO_VIRQFD is required then turn on eventfd automatically.
The majority of kconfig users of the EVENTFD use select not depends on.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/Kconfig          | 3 ++-
 drivers/vfio/fsl-mc/Kconfig   | 3 ++-
 drivers/vfio/pci/Kconfig      | 2 +-
 drivers/vfio/platform/Kconfig | 2 +-
 4 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index e44bf736e2b2..698ca35b3f03 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -16,7 +16,8 @@ config VFIO_SPAPR_EEH
 
 config VFIO_VIRQFD
 	tristate
-	depends on VFIO && EVENTFD
+	depends on VFIO
+	select EVENTFD
 	default n
 
 menuconfig VFIO
diff --git a/drivers/vfio/fsl-mc/Kconfig b/drivers/vfio/fsl-mc/Kconfig
index b1a527d6b6f2..6df66813c882 100644
--- a/drivers/vfio/fsl-mc/Kconfig
+++ b/drivers/vfio/fsl-mc/Kconfig
@@ -1,6 +1,7 @@
 config VFIO_FSL_MC
 	tristate "VFIO support for QorIQ DPAA2 fsl-mc bus devices"
-	depends on VFIO && FSL_MC_BUS && EVENTFD
+	depends on VFIO && FSL_MC_BUS
+	select EVENTFD
 	help
 	  Driver to enable support for the VFIO QorIQ DPAA2 fsl-mc
 	  (Management Complex) devices. This is required to passthrough
diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 5e2e1b9a9fd3..d208a95a2767 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config VFIO_PCI
 	tristate "VFIO support for PCI devices"
-	depends on VFIO && PCI && EVENTFD
+	depends on VFIO && PCI
 	depends on MMU
 	select VFIO_VIRQFD
 	select IRQ_BYPASS_MANAGER
diff --git a/drivers/vfio/platform/Kconfig b/drivers/vfio/platform/Kconfig
index ab341108a0be..7f78eb96a5d5 100644
--- a/drivers/vfio/platform/Kconfig
+++ b/drivers/vfio/platform/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config VFIO_PLATFORM
 	tristate "VFIO support for platform devices"
-	depends on VFIO && EVENTFD && (ARM || ARM64 || COMPILE_TEST)
+	depends on VFIO && (ARM || ARM64 || COMPILE_TEST)
 	select VFIO_VIRQFD
 	help
 	  Support for platform devices with VFIO. This is required to make
-- 
2.18.1

