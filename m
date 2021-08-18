Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDD983F07BA
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 17:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239869AbhHRPRa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 11:17:30 -0400
Received: from mail-bn7nam10on2086.outbound.protection.outlook.com ([40.107.92.86]:43072
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239864AbhHRPR1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 11:17:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z+axbfei5kUyphKnKNpxQ1Hl07qENmCWBssZ8JIZhQcopRXawBZ9ZlV3OSpbFEJZYkaKZnGcVRiPcTg2gqk4F903GUuiauB51gh9XAShEZ33evzhoE+A5IznkDwCk7UypueCOVuN6m+Ux6Hzd1eeXhPlbbQ6xiEGp2aj32BjCEEYQlChwbxP3Slv69V5t3iEeJHBB2UmHl2MoGolLzM2NLt21cVvM9SfFySa3uB4cFlBik3L7y4NKriMhfN+LoA7TWdgDgsmVjV90zeD0YjtSmKPbd7ASTI1xL0K1GSKhvSeyq6HRjFdLekmVSoUo8sAEovGzEHXXX1NzAT9GRFqnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8zp+Wv3I6Lwwlt2ddO5B9K3CvX1Q/7KFCOBAY9VFDsM=;
 b=kJ881Vc2E9QX8QvN6WJJwgd3DMcqM4JhMIzyK0XW4KpSYxTIgajfr8trlDNzYN/TYIcdsuWFNEJ5JzPceOrQFDnHyYMRwqSq3YS2+qbaMBFZLvIX3SF7QChTukkqurzFON/ycnd7cYHfGVCOJYduC+whC/abtlC/CwBNbX8Drfi/mbjqF6fBFjlETAKobMakAPqMZWTZy2/59880e6kcg/AFelpZ6mNbuaiq7lK/SUpZVM1m/13Jhnt/CyzMFJCqcrFqSxn4nejYhBUx3JRm7Tgo2zDwpYhtb5i1nQwA4I1ulBsHvDczQ+wzm+ezzUZZpdQceMyK1O3d0EGxUIMfEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8zp+Wv3I6Lwwlt2ddO5B9K3CvX1Q/7KFCOBAY9VFDsM=;
 b=cqzVW/iPeOCnzVIqGnq6IeEdHtpVmVBDPRtdnWw5WuZFLpkaoVpDlg8A7QlXjywQo+EuEf2QHPzhPzmLUGyi3gE3Q9ZBK6z54l5PJRgxuzNlgWFN8miAfeF7vcBohEFEbQRSIf+YxL2BJCQ08hlAUZLtR6/EFVHh8/SEuyTtvc7fiWQCtgzzmbMVEM96R/1Q3YktA27bISVrOIcV+OJc+KfHKJ5IDlN38IUWBM8GR49PPU7oXGoy+NJ+CMjSCi6rmHl5+QxWWwbxpT7v8275UVz6zSnTqodmR+pX5+DQFpOo8qyNuMF0rQKNuBcpjIVIhoyTVT4Fjo9H1CB/wYnHLw==
Received: from BN9PR03CA0063.namprd03.prod.outlook.com (2603:10b6:408:fc::8)
 by BL1PR12MB5302.namprd12.prod.outlook.com (2603:10b6:208:31d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15; Wed, 18 Aug
 2021 15:16:51 +0000
Received: from BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fc:cafe::df) by BN9PR03CA0063.outlook.office365.com
 (2603:10b6:408:fc::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Wed, 18 Aug 2021 15:16:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT005.mail.protection.outlook.com (10.13.176.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 15:16:50 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 18 Aug
 2021 15:16:48 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 18 Aug 2021 15:16:44 +0000
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
Subject: [PATCH V2 01/12] vfio/pci: Rename vfio_pci.c to vfio_pci_core.c
Date:   Wed, 18 Aug 2021 18:15:55 +0300
Message-ID: <20210818151606.202815-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210818151606.202815-1-yishaih@nvidia.com>
References: <20210818151606.202815-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dc6307f7-8e6b-4a1e-2ebf-08d9625b3453
X-MS-TrafficTypeDiagnostic: BL1PR12MB5302:
X-Microsoft-Antispam-PRVS: <BL1PR12MB530297219B45B11B65965040C3FF9@BL1PR12MB5302.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S0RMgQETGbUjiyDcORyA/q0l7FmOOhCYgv8/1kptRD+wMwQuKt52C/IBCqycO4ey2yoyrg5C1FZOQzWVxh7WsgJs5k4cmyriIWmGEmHEJu12ockCtxnGNavOci3/zIkbspySkmp3hJkmVk05r1VDNM7IvL7kkJUmGrSFNyEB1B9PoW5XREkYBFXg3IWzupjvxvMW1ISM67GWTrCwua4y3aQ/t82ut1NOiLPZjX3SY6UPWNu9esnkJXr4fKGUihbfyPPbsdElwi8RuqHgxi9dwAO160hm6Rhzt1NNwybtPyiwBBe/6zUdzcGSZpquNaMJxTIQfWza5PjvSz3F4RQNsy/KKXtuN7oiERWKSg6nJ/pOc3T2cXGlE6VFy88JgOzKaQpoUbelXtl25SIs9Qxw0yzcB2BBwHVjOZe8sIhcIKQILR9tu1ax9bJfArb8FvwST1LWZ3Tdn21Zr/tnPGADPDu92XEUq6mumv/Yme8JrHG3eHh6x2vU9eDQvnbRpVIz/RFaaga90kidCDOkJMIJmgcbJkPKRnxy9tsact6BTC9MuuGcxyGmiGi2XO731/OHpVvcpdcfubbNvn90wfOl8HeGMecNlMBaYB6dL4CN0ycpPd2EzCfVYDovX+Ji3vO0bjIPprBa6aEdQWNHSw/0E0svtx6R7sN82jVxEdoQ9/2gQWwGfb/DtelgYaWRigVvDCENjzIzs3S79/bHtMGrbt5m4iJb9onRQ4oxRrbVnrA=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(376002)(39860400002)(46966006)(36840700001)(107886003)(478600001)(4326008)(186003)(8676002)(82310400003)(7416002)(2906002)(47076005)(86362001)(70206006)(426003)(70586007)(36860700001)(6666004)(356005)(83380400001)(1076003)(2616005)(110136005)(8936002)(336012)(316002)(7696005)(26005)(82740400003)(7636003)(36756003)(5660300002)(54906003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 15:16:50.7449
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dc6307f7-8e6b-4a1e-2ebf-08d9625b3453
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5302
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
 drivers/vfio/pci/Makefile                        | 2 +-
 drivers/vfio/pci/{vfio_pci.c => vfio_pci_core.c} | 0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename drivers/vfio/pci/{vfio_pci.c => vfio_pci_core.c} (100%)

diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index 3ff42093962f..66a40488e967 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
-vfio-pci-y := vfio_pci.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_config.o
+vfio-pci-y := vfio_pci_core.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_config.o
 vfio-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
 vfio-pci-$(CONFIG_S390) += vfio_pci_zdev.o
 
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci_core.c
similarity index 100%
rename from drivers/vfio/pci/vfio_pci.c
rename to drivers/vfio/pci/vfio_pci_core.c
-- 
2.18.1

