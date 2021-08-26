Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B40463F8589
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 12:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241652AbhHZKkv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 06:40:51 -0400
Received: from mail-bn8nam12on2072.outbound.protection.outlook.com ([40.107.237.72]:17888
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241657AbhHZKkt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 06:40:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YUVBPZkVj191qsKgZGGC24n2KfXI1asPPviHALr3rB/UMlFtrtKXHcBEjLqwrFPdWDAQSUWBtxMIXBrtTb7NMdLII1agOts9TlXN1xjMUuqs6HLOvlJoZR6xcoQlSoSgYj+MM4Rqy9iZrlpk9L/1foyJXuTgUtzktuA0LYCW1w4ip9wZgtU9E6U1+0Gp3sx79w6UHGCHuHjggJFrkO/4JI0ZRPTGgrztouB0c2wCZ5lJKunN9/FG/zXkX5vZMmpZZQXlKbcJAVYnm1zTvwHgjY/oz9KXxRjB2okiY6weqZGKlS8IuLL9x4w7Myy92879GudrGBlexdX0KnRV8oFmZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dveIi0ajsHMfzWFTnK533vHAY0F4ue87KHR8bWvHt1c=;
 b=YzHztWFnTGwnN457/rHIZhWLRuhd30vSbSKsefPDjp8sSP0m3JajT6L1mZXsD9y2QfEYk8viI/vCGZInSsLjhjCn9Smu3IiPvJgPYDfS9AgTgERMQz+Js9/MppwwluMo50XwdCmWzUPhVP+VgX/R1NaKMJOhh+G8tvn1urOvFSt654mOlBFmf5K3Yz5m1nZAuMT9fbkW2wLSXgwi53lchsf0QPHMO+LhS2bkkw6o0wsbWTXYq8bVVpCmTMCUdLTR55pt3GkuOhBZcHNWwBrGEj3oGeB8CJaVqqzBNoWuU5VhNqbkqYO89xI8oArPfO6nvIRJZetODWmm+CR64fiyLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dveIi0ajsHMfzWFTnK533vHAY0F4ue87KHR8bWvHt1c=;
 b=nbG4h0ONDIR8hl08Zaqz0F3N+HHmuowA9rxuYkpj5NyzoZxmml7duTkUVQF6jbi35C+O0Sj4ge1NMTPrD/WyUgUmATRUMFUHEFOEGhvXlNM3EGVgNpMiYFXczUyx5Dw+2vaMIhfgoiY85HRWZCURWUetB1rt4MoTi9dZ5/kHpxfeEmKJKrCMEzB3GUwK5LVVZH3lu/x932KiZpdjd8CjMVJ1k2BGT3L3edRTzSIBj66gApHyZeIvFfJZchbgcdzDL6JrxvKVEe/bMcQ1f1cSf59lXC8dx1yYLJ2NP9bnw26FscN4/+g1TzrbboMt4yaG/ly8Naq/30D2GlWnZDKbGg==
Received: from DM5PR13CA0048.namprd13.prod.outlook.com (2603:10b6:3:7b::34) by
 BN6PR12MB1779.namprd12.prod.outlook.com (2603:10b6:404:108::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Thu, 26 Aug
 2021 10:40:00 +0000
Received: from DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:7b:cafe::6d) by DM5PR13CA0048.outlook.office365.com
 (2603:10b6:3:7b::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.6 via Frontend
 Transport; Thu, 26 Aug 2021 10:40:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT048.mail.protection.outlook.com (10.13.173.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4457.17 via Frontend Transport; Thu, 26 Aug 2021 10:40:00 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 26 Aug
 2021 03:39:59 -0700
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 26 Aug 2021 10:39:54 +0000
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
Subject: [PATCH V5 05/13] vfio/pci: Include vfio header in vfio_pci_core.h
Date:   Thu, 26 Aug 2021 13:39:04 +0300
Message-ID: <20210826103912.128972-6-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210826103912.128972-1-yishaih@nvidia.com>
References: <20210826103912.128972-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e506ab4-8b0c-46a4-294c-08d9687ddb1d
X-MS-TrafficTypeDiagnostic: BN6PR12MB1779:
X-Microsoft-Antispam-PRVS: <BN6PR12MB1779199A87F8C76069094F9DC3C79@BN6PR12MB1779.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Oz8ngRSZ4rilxczNq+sR+cq6XsJQ4UVO3t8yduT1HImhAkh0DGd02oziSUWlQ0ywsrENT1A1e6UaTIrlrrVf2dfn82g84mIPw13fLtn+t3Q8jb11MlXGwkTnJOwZsDhFrK52XDkrldN8w9uCNuFWmtMRmEz7+bAHdT2jlNV2/oze7wT0GDYNShSqUrCNt3pSNa6rr+NtdSUOEfdrgqd4Jc7IYSsIwChBPpJ3ZXvLA0HucxMxE/7Y+1pMUNtqPBMVll/EI6uVzNojQBsfWdTtG0pFbyvagXxwAAE9pC/zmggzev++OwnV+WFChLIsHCK64dAusg8Fo20ZL+Zi+OZxMXTs1RG+ktdShHky5G9gjKe4whqX9frLl+4q5F3xnNDn55Sec5l9MVUYy9/k1XRk1Yij9NU5lhlM43V/HrCpkh3jlyy3GmExDy4ZZ+FWEXO39hDysQaoOXglouN1XkpUJ2B5Q9aPxmmnwYTte3qXVEkahVWjsV8UP+G1yBRjfFuU+BQD5fzwDpxsirk3DvEO/nsjpsSezF0I36NS9JTMa2P6+3gY2v12XPTm9fKixIVHCY7CLuXM/czDIVK05Gkyi0O5eyD2JndjoUrhVJIGcD/OrEWyn7rdDFrPDIKT8rbZ7tdKCYhuobrOopiKIKFfAYzHfv8AP9HXizECpJWnNpRri9vspaLa9hNzVz36vXRoi//TZzNtBOvJFsqV508KIavZmBgJYkvzZtA1M4RII5k=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(346002)(376002)(46966006)(36840700001)(54906003)(26005)(110136005)(7636003)(70586007)(47076005)(7416002)(82310400003)(6666004)(4326008)(186003)(36756003)(1076003)(82740400003)(356005)(426003)(70206006)(86362001)(7696005)(5660300002)(2616005)(478600001)(2906002)(8676002)(36860700001)(316002)(8936002)(336012)(83380400001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2021 10:40:00.4828
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e506ab4-8b0c-46a4-294c-08d9687ddb1d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1779
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Max Gurtovoy <mgurtovoy@nvidia.com>

The vfio_device structure is embedded into the vfio_pci_core_device
structure, so there is no reason for not including the header file in
the vfio_pci_core header as well.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 1 -
 drivers/vfio/pci/vfio_pci_core.h | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index ee5c8fe2a324..94f062818e0c 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -23,7 +23,6 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/uaccess.h>
-#include <linux/vfio.h>
 #include <linux/vgaarb.h>
 #include <linux/nospec.h>
 #include <linux/sched/mm.h>
diff --git a/drivers/vfio/pci/vfio_pci_core.h b/drivers/vfio/pci/vfio_pci_core.h
index 2ceaa6e4ca25..17ad048752b6 100644
--- a/drivers/vfio/pci/vfio_pci_core.h
+++ b/drivers/vfio/pci/vfio_pci_core.h
@@ -10,6 +10,7 @@
 
 #include <linux/mutex.h>
 #include <linux/pci.h>
+#include <linux/vfio.h>
 #include <linux/irqbypass.h>
 #include <linux/types.h>
 #include <linux/uuid.h>
-- 
2.18.1

