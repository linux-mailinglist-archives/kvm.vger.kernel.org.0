Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF2C83F3FD6
	for <lists+kvm@lfdr.de>; Sun, 22 Aug 2021 16:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234103AbhHVOho (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Aug 2021 10:37:44 -0400
Received: from mail-dm6nam10on2071.outbound.protection.outlook.com ([40.107.93.71]:34624
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233450AbhHVOhn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Aug 2021 10:37:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cg6AdfoWbrCnoaqd1MZ+HjqFy1OdHmA+jnLWD2RKjfyUo/zXEDVVdo0zG3oCNH5r0l9AvAOgPVu4fMj8D/TJBUbV012KIEWkVVlTUA5h8AwkpiT5tkQds+3CsyRgLFdbLzRU1ZwsobyzosVvsrezdPB5+l2Z2OsoUygutZlktbaC7liEhhsUVZ33gz/FHYD+lrUjfW6DyFn1bweXzkehjZ+KFnURQPrpyZUYJ5N2no+sQ9nFJfRpffXA9pm9QrQZhBlEKo9IXgDwNnFMI5IY2venL/+SJoVxTBX/tVwRW7Wper4Ok4ibpHJeb5NfyStm3V4b/Hkfuq4iq5gVSAmEpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8zp+Wv3I6Lwwlt2ddO5B9K3CvX1Q/7KFCOBAY9VFDsM=;
 b=FtGFH/YeMFBlpaLbbv5r5j911ANyFwk3w9ULt4apY3Ltk9FpkyXfmw949Jx427brflQQkYRdVd8ZcJ3TVhKs6xz2d0nVgRCS9HVNTAFzvYnYSzmw1vrh/sW7k1EuAw8l7RgLsdOoBeU7HFu3TdRS7uXqowE24hJJgI7oCTvLcGFpy/YZnE9yJXBQz82twhz6q7DvT8W0PNmK5YJPoXzH3gSaiFsrS5zZJUYimEOwF4nSHipUDQtxE37urLX3oHbQ548/i5+ke/vGK3i6PsMIjVrYV5ktyDVZl0LeIwfm12NeP+jACwCH2DZbSzKiGaUMTbF5i2QuvtGjsNsuWpnnZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8zp+Wv3I6Lwwlt2ddO5B9K3CvX1Q/7KFCOBAY9VFDsM=;
 b=jD2LTorMiyJkvgxIcw/U1b+p0crRmJCkXSNIpXADiW7Hj2mlJz0gAntAByU5Ncn0NgPuXPXrFCKmffcz1wMMeYEtxKetmUPLBJMvt9FFWl3QQt1706x9IyrCfV2cvbPaHKLRUgodeKTT+PPNo644JpVA2OcTAaCJdvXL3dejTVro9rR3RbkS5G9T3t24T+abctEBhpWgypVrxp9OYa0eaw02+0KDz1YK1oa6q9/dspfktbUr4JhAm5sxowRQH2SmqIkh4fA0mBRHTiwnWKkWw9o+0X3c7Le5Fyco5C4n1N09QstP6Sp25kws9Eq6q5Rn44OB45GkWBY0iWU6jUqHPQ==
Received: from DM6PR07CA0050.namprd07.prod.outlook.com (2603:10b6:5:74::27) by
 CY4PR12MB1189.namprd12.prod.outlook.com (2603:10b6:903:38::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4436.22; Sun, 22 Aug 2021 14:36:59 +0000
Received: from DM6NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:74:cafe::ca) by DM6PR07CA0050.outlook.office365.com
 (2603:10b6:5:74::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Sun, 22 Aug 2021 14:36:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT058.mail.protection.outlook.com (10.13.172.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4436.19 via Frontend Transport; Sun, 22 Aug 2021 14:36:59 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 22 Aug
 2021 14:36:58 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 22 Aug 2021 14:36:54 +0000
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
Subject: [PATCH V3 01/13] vfio/pci: Rename vfio_pci.c to vfio_pci_core.c
Date:   Sun, 22 Aug 2021 17:35:50 +0300
Message-ID: <20210822143602.153816-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210822143602.153816-1-yishaih@nvidia.com>
References: <20210822143602.153816-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 353fca82-8a6a-49b1-a16f-08d9657a4c98
X-MS-TrafficTypeDiagnostic: CY4PR12MB1189:
X-Microsoft-Antispam-PRVS: <CY4PR12MB11897949E2A4A74EA2E82FF5C3C39@CY4PR12MB1189.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RFwdcpzxUBa1F6CKSiNMm9Zk6Mb3W9nz+GTLT47O3IOA4MFmUSlsXBg0SgwQWupGPBEpG0BL/Fa3/XaqfxqB50npTNvmYYQbTbUcNRHfvIoNjYGs8YV6Jqkok7HUFAhLkPee30RLi0j2XaJfQeosBYyMjyvR814Ggam9nBUcTwut28XPmW8Dq7emHSx8zNHJFi5P7ptrpu3ycZQN1n3MzgRL4WRFi3s76sbtYKf8pXCQ5dxvE1xrvhERbo8t0QJrjEHLzq1YqP/FVlgHL4OqOZ409Se/+mQ8ugGqYcFee7138RKKDOOd4rx+l6q8/Q0449AwZvt1+Fuworq3F58HClHz4Z9RRuvDXHlbub4BadgMty6mDlUgkkz69JpYsy7rSJYSy5gK9pTieeL4mTNqjKMIFSs0LgecwSZuyxUnLoZgkdrSX5XaGw5yttxyxIxaRFXwW/1oKbTsXybs7N/iUwUzTAVdzLntGDv0weTSssdBqP0Z/DF0Zaor7NdlNpDSM4QZP+ThgWfn0CctCZCvFYYed2Y3qHXVh24ywK6hX7RXBWUHAHPAyczdcV6ABXc4xuZcXLbSo3XqaNu4f4YcAYNy57t8DUCHXXXaVaecNa1WzIT8UcG/TLLSgus1NerkmEWY3/rdv6g29PqO90pJ0qjbdCbP43ipsNfgFsvyBm23tYSWK5JO90AYosQIVytUpHvmCDCtrNOqht9DlzatVjQDXxU8WF39J15Fp/DU0XY=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(346002)(396003)(46966006)(36840700001)(6666004)(4326008)(2616005)(8676002)(8936002)(7636003)(36756003)(107886003)(86362001)(83380400001)(47076005)(2906002)(426003)(7416002)(356005)(7696005)(82740400003)(478600001)(70586007)(36906005)(1076003)(336012)(26005)(186003)(54906003)(110136005)(82310400003)(70206006)(36860700001)(316002)(5660300002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2021 14:36:59.4013
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 353fca82-8a6a-49b1-a16f-08d9657a4c98
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1189
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

