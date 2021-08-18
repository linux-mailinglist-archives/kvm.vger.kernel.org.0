Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFFD3F07EA
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 17:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239506AbhHRPSO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 11:18:14 -0400
Received: from mail-mw2nam12on2074.outbound.protection.outlook.com ([40.107.244.74]:26848
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239509AbhHRPSH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 11:18:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NRt4+E0PIo2tDYHR7wE8rK9hdWQnijjSVfesFS6gpkzb4F8P7ZCv+KcMCJ3lmn7Xyyn4081Z3uCozhakZ5nrua736dotL+2m/8EUdcwgi3jHjfajKNSI/5qMfmw2SHqcNlJmJwjPRdEMwnDohW+CVJmCKX7IRgXcMoo9CLfSJ0aGbuDlHuzsUgbDLW9xC2svFcgVsC5aK5XwAc28EarOQqSia26Vr1lfZX8WogfkY7Qb5TRAp4tp/+50jTxj1cPfuoXNEw+nHQr3gkplu7d4zqZfGyL6a6JbqXLfYTQAPgiF2uC6SFhyvFVzUTf4jGFu0JOJeIuo8xVHEBzlB8R+lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hcoz+mtO8t1q9AsRo4d5AWcflMVS8b8syDqG8CJho7c=;
 b=CZ4JiShfuv4hfojW7Hd0FCcFVven8QAmBX1fLGVVVnFTIbmYgtXmB+QXyWV9jqCGUIda+3i9OcWM5a9PsIeYlavfofSEhW865khBqeRuMfUpGNVZ8HpY9NK0z8mBsD8iamfTw8Hx7yfYPfdzo9crkA8bYrkibNuoChdWf0wEkoJEMmVLT9vvYjreLM12ddA8rQjV0hdjutAbsuqo+gC9Hn37GEWEuSOjK3S50BB+la84cYVOdwXQHmhRxkxHaEQtrcy+1twI2iKGegTPtKOFPkQDm1cdhvxXoeQZ+CYEpBM0xshcrgil/ZXhB9mlklQpu6Ui5dvQDPxXJTCgRJb9gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hcoz+mtO8t1q9AsRo4d5AWcflMVS8b8syDqG8CJho7c=;
 b=TUMibnXyZQwUkJMinQqiiF9KVoGAlOB1m96Z01uAPCRiYsy6ttzvWgitKSTyDGqFmkKGQ3qqTjAEG47usPMy4Q7OKsVWnzrKjPLf6xTSHdY46HjTeu14RLD5eYG3QunyCvn5bwp/zK/0gqoTPOFvv2BHbl+a0/xsbDOz5fZRz1R9EYOOmfjLCY+LZUuX3uyK7qOdFH+pzSlw/vfSU1bHdZ3rbXFJP6Elm9Vg12lv2BqWDi9M/l6+qgRfdQCOHIh+URXM0ylU1794OuF+7hL0kDJe1MlTUmbPqs/pPp4dWnKNsKzltE1UKegVVAXL7rzHM9F27y70b8UXxrsHkhMQJg==
Received: from BN8PR04CA0057.namprd04.prod.outlook.com (2603:10b6:408:d4::31)
 by MN2PR12MB3424.namprd12.prod.outlook.com (2603:10b6:208:cc::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Wed, 18 Aug
 2021 15:17:31 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:d4:cafe::4e) by BN8PR04CA0057.outlook.office365.com
 (2603:10b6:408:d4::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Wed, 18 Aug 2021 15:17:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT019.mail.protection.outlook.com (10.13.176.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 15:17:28 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 18 Aug
 2021 15:17:28 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 18 Aug 2021 15:17:24 +0000
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
Subject: [PATCH V2 10/12] vfio: Use select for eventfd
Date:   Wed, 18 Aug 2021 18:16:04 +0300
Message-ID: <20210818151606.202815-11-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210818151606.202815-1-yishaih@nvidia.com>
References: <20210818151606.202815-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 93ecfdf9-0232-419d-094c-08d9625b4b1d
X-MS-TrafficTypeDiagnostic: MN2PR12MB3424:
X-Microsoft-Antispam-PRVS: <MN2PR12MB342493F66A01CA6617B9058EC3FF9@MN2PR12MB3424.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OzAHiu8DVFQJfonJlTz5kOAcvJmj7FBxYviflg9EXJBTMBOt6xTVa2tp6gStS3WSMEH91tQp1ubcZ+7FBSt67GcXmm20j0/8Y/8arOq14Paq1sbxuLiaqJk+ARsKztdndNJpk45o3CYmR7zajSPL70Wd+hNDZX1C8m2gdHiswoywtUqvWDDl2U5uWPoyHVHUMD0qWSV7wt4LoQK3tx0dJrBzOusYBgl/HlS4Fmu0ZKUYd6Y1lnGXeNsp4jFUxAUsJzkOP3IxFUJUTQU3TYinMdP5M2JpuWQcBR5dbQIvk4pBjDBFinsxrAAxhpgqHpw2JCH8FqxK4Ay1161jAJScLWnQCV9mSVP9DBZzYsf/NVpYx6af+80c8e32C5bC4it2HUcqVd3JGcXbQfiwKPfQCfgOxk8ngTxqU2N3B+/8koGnF2lhwdjKrpkPNpCpTXi+nynvLXfhLBNUimuvxTH+MFzy5gQUq3y+MAn/cGPijwb73vt8nXgHaPYbRs159+ra81A1SOtqaavUEhLB9bK1ZB1cgInr9yyUhcYwNl57P+ls/0qTm3oKUx81rYRabe/Z3nQCi3av/zO9KCW9SYEWbnDKIOVopdyTn87/F+GcyyKbSf/bCWTXzaSQDyJJ7ULcwfi4fkh4tHkP4uz9ilHKn3zc/ReOjNivQtT58F3kaVRjbxmOth7iAQ/2ojKV7rWc0S5sWe40dw7yC9n/WSezFjQTe15JQiwOthZfhQ9BGoM=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(316002)(336012)(83380400001)(426003)(26005)(36756003)(86362001)(82310400003)(54906003)(7416002)(4326008)(2616005)(2906002)(6666004)(36906005)(8936002)(8676002)(107886003)(1076003)(186003)(5660300002)(110136005)(70206006)(7696005)(7636003)(356005)(47076005)(36860700001)(70586007)(508600001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 15:17:28.9696
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 93ecfdf9-0232-419d-094c-08d9625b4b1d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3424
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

