Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 475513F85A8
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 12:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241695AbhHZKlR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 06:41:17 -0400
Received: from mail-mw2nam08on2057.outbound.protection.outlook.com ([40.107.101.57]:65313
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241761AbhHZKlP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 06:41:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fiVfLdRw5PGKv8mSjkeT/mP5O9cj5vQkGgnJf7XCqxAPYb8lvxlsr+aRvgBi5Be2xwfGTrf412/1PzzbqzhqnUhpOaEfRnwQeV5FPRoTjWo0HQfBD7bMRed/+r4z5NPvu5l/MLWgqMjOEdBnAqhD58vYDBeqQjGzp883oRtNzHjg9l0Lssi5wcxUfrQy/8O5L/G83MUOvg5GLnHXEpKLM4VSYvtgDDpoOGn8YNxrYlbcKuKazQgx7x0Db2sBKzDUzRotD37cE2ZUYKd44SUVzcCkyld0/anAjzIs5YaBmJ2uwdemP1SH0vWYka38WKUOhhRCT2xSQ3sg325UhSc52w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qq8MDX/Lemmw+9kZjIRfmtnw8GQqbNfSjeX5RtUsCf8=;
 b=Uhf4D15PVC492v3MG+1Dr/SdlPO+GJk0Vk5d3o17aWf1hMvE6VwF3Nhd4vHaVgbuPfn/rO2N/EaiKUdf4tlXqvQI5NTxDuHiwruXJwgOod6NmOe6hjPE/anqCHBCZUzC75K5pGTmd3LAx3ALwOC5N675SR64TrD1Vidd15i02xDlvq64oZ5GaY4+sq2KeRzLmBCmIrC83k6jp7HMw+E+L6e+Nkervzxn08sh1lcwTihbA503+c1fAXMCRkzPTDiyXdHwZ4B4nnx/dAupC2M8eMYfdv5dlIsOljbTzivItHOV71xhZeWhNk+jPHxHx6onGGbae+Z34VGLVgBLfi644g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qq8MDX/Lemmw+9kZjIRfmtnw8GQqbNfSjeX5RtUsCf8=;
 b=L6G13qAkzVTeTnggn06GKh2wHcYezBvuL+2h2v0jfzzP34ZEsCBLOhfvQuFRCgF5LDWZK4cuJRDQzEDhiRfo2fFlryV+1vZwPpIWn6mTE8O5dfBtb/XJkQCX/HrWFSxNzm0WkUtPln1NQrl7YIu54aO3v/Os5TE14Dr4LPiQ2VOK4q0JZjEoG1uUyM2oaz0TDeOIk6hJAYulxw7Df8KCqKYEqppED32CMUCmUhof7NUe/hl1Mf/TNtNhSEo0NHmklN8BwRYYri+RYdFzY1T7LBV7F9CseTe+dNJ77CPkIAc3m3xOMEREruq4RWsNgQM8ZhFvXyui1fWNv9mh6JatzQ==
Received: from MWHPR12CA0066.namprd12.prod.outlook.com (2603:10b6:300:103::28)
 by DM6PR12MB3065.namprd12.prod.outlook.com (2603:10b6:5:3c::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.18; Thu, 26 Aug
 2021 10:40:26 +0000
Received: from CO1NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:103:cafe::40) by MWHPR12CA0066.outlook.office365.com
 (2603:10b6:300:103::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.18 via Frontend
 Transport; Thu, 26 Aug 2021 10:40:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT037.mail.protection.outlook.com (10.13.174.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4457.17 via Frontend Transport; Thu, 26 Aug 2021 10:40:26 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 26 Aug
 2021 10:40:25 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 26 Aug 2021 10:40:21 +0000
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
Subject: [PATCH V5 11/13] vfio: Use select for eventfd
Date:   Thu, 26 Aug 2021 13:39:10 +0300
Message-ID: <20210826103912.128972-12-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210826103912.128972-1-yishaih@nvidia.com>
References: <20210826103912.128972-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9e9df54-c643-41df-a41e-08d9687dea5f
X-MS-TrafficTypeDiagnostic: DM6PR12MB3065:
X-Microsoft-Antispam-PRVS: <DM6PR12MB306513366CFE9FE615C84271C3C79@DM6PR12MB3065.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vV2VhqpqZIqxl2E8Zr0xOOC5wsUmsBntOGbeyJN8n45AxMd+tKixxzI2iQ3EdcQLT9/rp7Td0OEswjwLZwxfur5hLHVPK44Cm8dnWk+bZ98kgIfFD7CjBE4VgXMvN5ctocEK7zUUXPS9GV1x6S9w6ria++Yxwtq9BK8QyXBX/8rdZq1kDYDegVTiIHEgsThIXHGJDiELwVpSw4lPcgYieedJHpuZh58wcwwnuAwfgQU5iQdu5pAz7Rl20MvEZEp6dyxm3yej4X8VjsIzzn+NmWBdexmu/syp49TN3ISvsuenRhLUhlvJlwGKuq3OnIqPCLSPVF82YzDXFO4PDf3Fh62cmGtrfRGbDiDgPS2k4SQNr2K7PHPka1iNHBsirxCSWu51IBIFEAJGCMFN0N+CD4DyHzi2+a9QSMRhrNzbO/UOlLGwKIW4+EX70oJsq4PZTi2EWIO30bamyXC1AOgZiC3eZdqeYF5+OEX4LhMTllDi2dstP9tG4j7CZX+Qmlo+KQavsY/kuIy2zJvbmrf0/HwsMqftduZgC8qn2J/88+DyrtQusrB2VTt0kvdbQNaZA99QI3TOV6YKFHmM8zyBzF2Prew5I1XUfw9dZfA/2y4K5s8uOTBPbh7Xe6ive1RX/XvgRbh9IiSS0BANmSL0b9krY9efQNDIJ4egXgeBZucd/evTz7dES/cCs03agMdqpQhSACk1TWKh7xa+qm3CYh0hLH8m56y2Gh0K9BRIr94=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(136003)(346002)(376002)(46966006)(36840700001)(86362001)(36860700001)(1076003)(26005)(186003)(47076005)(6666004)(478600001)(426003)(83380400001)(336012)(82310400003)(70206006)(5660300002)(8936002)(54906003)(8676002)(356005)(70586007)(316002)(110136005)(36906005)(2616005)(7636003)(2906002)(82740400003)(7696005)(7416002)(4326008)(36756003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2021 10:40:26.0913
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9e9df54-c643-41df-a41e-08d9687dea5f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3065
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

If VFIO_VIRQFD is required then turn on eventfd automatically.
The majority of kconfig users of the EVENTFD use select not depends on.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

