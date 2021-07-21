Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753CA3D13AC
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 18:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232908AbhGUPgw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 11:36:52 -0400
Received: from mail-mw2nam12on2087.outbound.protection.outlook.com ([40.107.244.87]:20801
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232785AbhGUPgv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jul 2021 11:36:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KlxbUdakZaHKsd9hOiz0JA6s2gY+jOG2L8Erwn5h27JzrBparcREu80Hiwn6detQFMCrUygi2a6YsSf8vyj/RiNb93lnPUFyoiSLDo3ezDVp1/OJfbc5FxdbyzESRG5hS1kNMcVWMWz7lKnzTEkaxS1eK3hE7Yt7S8UfXMhUp6NPT3ZCDetKfdw86maawNxMyrOClf+k6ENV/KQSRoX6DEDIdLqMFxeQsMfvlZwQsBDFvBJg65/XX8a7CBcHPUjqoZv1cBsxK7JhG+GjseQkGIFKgM2ttYighMpodfTdrdoZo1ppePQ7wKlyCcIyn4KuzCaDn3xN3SBsVI21Lcsmrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8zp+Wv3I6Lwwlt2ddO5B9K3CvX1Q/7KFCOBAY9VFDsM=;
 b=lW0wlUXfli7wgLmHyLD2oOF9Pqhel0vNUujM0PmF4fl0vfWFlSt0mPqoVd6IyjZVtvroF1OOjD8VJIOhp/1ErcaLR/EVpDt7Mi+I4QE5nE1N4mMwemU14oqX9nDL+H1P5ZeY5oUWshSR1Rpi+pnNmn3FkEhlkzxo5CRz5aQV9MHt1EzLuCsG5SRIc+RqVT6EHCP67w61G8e4e2agMgheepBwF1DhmeCJ5dCxJDwob5OnsEumwruDf2+o7cGNj9U1iazCGJaO0GhsCrGKt0d7pHZ8BCk7dfbkt+QIZLmf/BIrAcV1A1cuukS7L976JfnaYM19XSWD5ofLhKoSzgIJMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8zp+Wv3I6Lwwlt2ddO5B9K3CvX1Q/7KFCOBAY9VFDsM=;
 b=Mnqmt/zEsvVxhhb1kpEbtOO0ajK1/3n7UnidLHXWzfgbzF1oVWMmjMtdR8NkO8xjU7RevoXxUbSCc6nIhA8JFP1p9xniw+2x7z1v6s7ltb5YfN5j24m/pJxaCcrSnyMupBRuBBS1GJWbhvsgDlFU7fKNMv0dqQ2dyqJD3iBiSMlYyx9Ea2XSJTi2tFZrAvLdUAqdlhGy4xpSYtzkEl7Mm6cRq+cMVymbtf46/T0tGxJUXxSoATu/rvZW52vcLHTiHKur3JUctVXeQFqGiOORnr61YZ3a6r0UwMdqxYbBdEWzE0ehefs9O9+jpzkLRFDGeU2/8ARZ7chEjXTFK0IlKw==
Received: from MW4PR03CA0014.namprd03.prod.outlook.com (2603:10b6:303:8f::19)
 by DM6PR12MB3194.namprd12.prod.outlook.com (2603:10b6:5:184::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.29; Wed, 21 Jul
 2021 16:17:27 +0000
Received: from CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::c3) by MW4PR03CA0014.outlook.office365.com
 (2603:10b6:303:8f::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24 via Frontend
 Transport; Wed, 21 Jul 2021 16:17:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT030.mail.protection.outlook.com (10.13.174.125) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Wed, 21 Jul 2021 16:17:26 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Jul
 2021 16:17:25 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 21 Jul 2021 16:17:21 +0000
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
Subject: [PATCH 01/12] vfio/pci: Rename vfio_pci.c to vfio_pci_core.c
Date:   Wed, 21 Jul 2021 19:15:58 +0300
Message-ID: <20210721161609.68223-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210721161609.68223-1-yishaih@nvidia.com>
References: <20210721161609.68223-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef56841b-b3f5-4845-dcf1-08d94c6307c9
X-MS-TrafficTypeDiagnostic: DM6PR12MB3194:
X-Microsoft-Antispam-PRVS: <DM6PR12MB31946CB701D4A8CE5940D579C3E39@DM6PR12MB3194.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2n8CBhOj1naUfC3TqcAT6yOfgpN7OAo/hK+lr6r4hlH+hSEikMv8CQrEV9LuJ89nUT2cDWmWHznlimnQQmpeKTv8EX0g/Af6gH0zCA5L/ImulzjY9kOocOwodyS3LeuOepmUG91UiE+QT6SqyHjGZdTqrmaafR0Kn4aln373uAHzgO55G+GWI+WkA+d5je8wnfvRknGDTQLKPXWLHQFWLALja69CaBw67O3dRlKx93MIqpUNTZYbWIqUfqlbl/OSmLUyC+cp5XeJezBCV7yW8F8EmbI2gTWqAfwq6qPjLGZOmAj2z1Aq0w5DVBZ4GwcqkpMv9hvQsrwrtbWavzo7kaAQYz3e9SCUbYLe8EDBxOIk/B0VBU7GP1Czqrs9EcX2mV6rPlBncO9WpCWNuizJuPAfIjKBvEaUQXu92JgzFS/eN9vvSnY0cv9h4x17dZcxyTo2Em/Az/JMv9/L9qqyXGIvnnkAtg6ZB5HHvWHPoIiS+bA13zFKR2NKwFPdMomwbqVLeV6uobg5pB9/L1+kSEVowKqJdVcjG0Ip5NupcuHKdDAVk4WWl5Sx93K7GGw32VRuVNJgKPBdnP/rzSehsdUF61RH+HG5jfbzrpqcRAcHu7PM/SUCkRiqmk/hcp+vpedhjwnH5tlayqZpm8+WNcqpl7Tq+Hcu1trpjt5CtmdHwA/Y0/vp4pC7J4aIeZka31SNKLou8pOaaAaCqLOjIl2H8r7Sdp88I3ERZ5p/w9w=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(8676002)(7696005)(82310400003)(54906003)(356005)(7636003)(186003)(70586007)(70206006)(36860700001)(107886003)(36756003)(47076005)(508600001)(316002)(5660300002)(36906005)(1076003)(4326008)(7416002)(336012)(426003)(2906002)(2616005)(6666004)(110136005)(86362001)(8936002)(26005)(83380400001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2021 16:17:26.4769
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ef56841b-b3f5-4845-dcf1-08d94c6307c9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3194
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

