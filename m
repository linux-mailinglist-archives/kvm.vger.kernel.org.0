Return-Path: <kvm+bounces-11536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 442A9877FC8
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 13:16:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 682291C21198
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 12:16:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 456713C684;
	Mon, 11 Mar 2024 12:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="s0czAKY7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2040.outbound.protection.outlook.com [40.107.93.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42A03C47B
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 12:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710159374; cv=fail; b=ZaCBjRE35CRUXOlvwgn3aUMsFhlkHoVH4/vWxpv6Y3+Tc6FJHT1TDQje4beRSn8bPODyGb5J6FLTU270s+b+TUsI0dtkAHYhG6FQ2ePY8hTPf/Wmt0qP36Q7i+gbvZxEoXM1KVJS5Mruqw4mpy5gP+vsF+EjMpqdaKvNPthGvwg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710159374; c=relaxed/simple;
	bh=o071ATZYOtOa9HK0Goylb7YSxp91ngnYqoUHdjtk08w=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=c61zZrRJj3cgBWqGgRrPMsXV3wLMcyRCwkxd+7aomppJS8YwjFHplbK7UAQLmXqqtLGndIN8Zr53joATwzlHebvz7Q+CIHVs6DuX4DMEze4q5ohwtdGfvILYPnnw+/KTOXWhct0S+LKgItXoPoRIqaLwpgrQUuEehhK3W4rtDfU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=s0czAKY7; arc=fail smtp.client-ip=40.107.93.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CdFIPWZbW35cnjoWZxVS/lcsWz3PCbDlY8cXZrWAA67UGR9nYFWOBTx55t7x+mnpks1PQbqNbTRFmQ2u73R9uPkJkJ+riaIeoJw9/rZKr5kH873NfxIbWmFKl1Xifj5TT6C7oWGvLCusMHov+hY+2cMg9x2fm1GmYF7gDvKYqd64c4mEvp5YwSfjTjYeV2juWHdJGbKZldg2nWYK4OwNz8Ih+SKA13qrLbQlDzHc6VyJ9BfS1VgUwmyvLPIMK+fpjoQUNCWqEJCpyBjHiHPdmSDf5/FevpJ7COVgcqIUGNBQz65RTQaoconcZCM9IJ5OkmorLDBVCCZ2Oc5MLGtRKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tnYlo/jpCzeKmtItcUAolkia80g+SLSC9y26UXblya4=;
 b=NjH8huwgq90mOy1TjhaO7fvbW/liNmLCgN0sRhhHMP93Vn141IeRc3QbzDfdufXQIs/hlWwaR05+G5acPk7aw0NA6/q+Qr8eMsxfEyejteMVnYGLTrA1LxbxgS+vIWl86jjGHIgCYxghqLV4HhRoshVSK9dH61KthsUT3BhIOig1BxdAqfuaPMDq//ZTHIvldRSS3nrV3BE91WXAFn78FDhbrO8mXdayneioAllCNFvcqvbNiid7ldvcqaw4Fv+EWJAdSfWqI1ILfhAjD0CzxkjQeP6XWrfETPY54OJvimKCMDwqG06C9f3CLQQSiNjyOi/T93tMPhe+CBsIlJ7CVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=nongnu.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tnYlo/jpCzeKmtItcUAolkia80g+SLSC9y26UXblya4=;
 b=s0czAKY7and0gp6ScASvukO9okw370PvrQJhBGOjlld3YqG3W2KVcUAk4tScx97h5ORWLp2YZ9/Mzj4aKYT9cIf7QUy4XLVgdis/uNliLO0EuiQw9PV6sOlTL8SH3cpIEBpc11i3++KiVpkiI5jYA6ctng196CubXUcBRlXLsC47jGNDHL/HSpHXe1r8PT3OMfb8DLc5IrWdPyLphzHqx6y/imJrPxdtn85yTwYAHUJxQYdeJeahITVE4via4idFk2vjyUhgc+ZibAoVYNVDzlQb4Icuh5eoyNEI/ZzqaxojNBgW0ls4AZOWYSIMxTj0y2a3Y7M5aKtQgwCSxR+FnA==
Received: from BN9P223CA0014.NAMP223.PROD.OUTLOOK.COM (2603:10b6:408:10b::19)
 by BY5PR12MB4306.namprd12.prod.outlook.com (2603:10b6:a03:206::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.35; Mon, 11 Mar
 2024 12:16:05 +0000
Received: from BN2PEPF000044A6.namprd04.prod.outlook.com
 (2603:10b6:408:10b:cafe::4d) by BN9P223CA0014.outlook.office365.com
 (2603:10b6:408:10b::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.35 via Frontend
 Transport; Mon, 11 Mar 2024 12:16:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN2PEPF000044A6.mail.protection.outlook.com (10.167.243.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7386.12 via Frontend Transport; Mon, 11 Mar 2024 12:16:05 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 11 Mar
 2024 05:15:53 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.12; Mon, 11 Mar 2024 05:15:52 -0700
Received: from vkale-dev-linux.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Mon, 11 Mar 2024 05:15:49 -0700
From: Vinayak Kale <vkale@nvidia.com>
To: <qemu-devel@nongnu.org>
CC: <alex.williamson@redhat.com>, <mst@redhat.com>,
	<marcel.apfelbaum@gmail.com>, <avihaih@nvidia.com>, <acurrid@nvidia.com>,
	<cjia@nvidia.com>, <zhiw@nvidia.com>, <targupta@nvidia.com>,
	<kvm@vger.kernel.org>, Vinayak Kale <vkale@nvidia.com>
Subject: [PATCH v2] vfio/pci: migration: Skip config space check for vendor specific capability during restore/load
Date: Mon, 11 Mar 2024 17:45:19 +0530
Message-ID: <20240311121519.1481732-1-vkale@nvidia.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A6:EE_|BY5PR12MB4306:EE_
X-MS-Office365-Filtering-Correlation-Id: 53078364-ad67-4d3d-1441-08dc41c50684
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	NXXpz8nRrLWeXJ3x4b+r5erAp2lUoRh+h8LJQ2iGL+8xQUm3ToCF6fEi72Qv1cO2UQEHOTt6tU1L324sYWylGVCogg4AXkwAzzJFtBIFNvEzNscdnPtcRQpycBx5M9j0CnrsUJHDYkyKQfuFPX9SrkX5F55Zn9xG2tCeUX6B5cMyybZ7P7YlWtKR8xM5U+dnM7m+UmPsleiiBIIpJXE9GhsgJ9FYwDNJuqhmebebGnK4ukgKwrDuaOLCU1p9MdbUYCils5aXAFsIObc6KxSUNTMcjAA7IkNyZE9j0mEbMl0NYSj1ZoToa+K0NdrY36XUe+wUUNSt0aa4Ye1yxrWPqf+NOsgmOcpO2+/jVgfbrEZN2kjd3EDDPL+IxkYsJJWSFORBnwzv1CAXg6FHO+uqPJWu+SsQkM+1bvR3NLxGX3bSfj52p3gEI07PHQvEpehdOKMGvgqQw+uaqKlheyvXKaxhcUiZaasAF2uB5H3+8lUELxN0qR3xsbneLTaRLSwkcGH3ZN1wOYZTjUPGcYFIld0roESEjSqXdgl3S8s/qy5xHDJeHg3w+jqyWKixMlxyEi7492zzkmYVV7nk/pJzi8MC6QAi3WHaet1UDq21OeLsWMDYfHHwnfpULFcdqwaGQI9bQlrcfwHFI8rgkLW9FJGMVTNS4GFRtCyUSe2zHdNqxm+NR93TvLt+sE/3QsqpOds2u8k17yHq6DiKn5D/YXk6oUhbM5/vVKJj7BUJzK81Faj8xHq5msWOLOd6XSLy
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(82310400014)(376005)(1800799015)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2024 12:16:05.1574
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 53078364-ad67-4d3d-1441-08dc41c50684
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A6.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4306

In case of migration, during restore operation, qemu checks config space of the
pci device with the config space in the migration stream captured during save
operation. In case of config space data mismatch, restore operation is failed.

config space check is done in function get_pci_config_device(). By default VSC
(vendor-specific-capability) in config space is checked.

Ideally qemu should not check VSC for VFIO-PCI device during restore/load as
qemu is not aware of VSC ABI.

This patch skips the check for VFIO-PCI device by clearing pdev->cmask[] for VSC
offsets. If cmask[] is not set for an offset, then qemu skips config space check
for that offset.

Signed-off-by: Vinayak Kale <vkale@nvidia.com>
---
Version History
v1->v2:
    - Limited scope of change to vfio-pci devices instead of all pci devices.

 hw/vfio/pci.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
index d7fe06715c..9edaff4b37 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -2132,6 +2132,22 @@ static void vfio_check_af_flr(VFIOPCIDevice *vdev, uint8_t pos)
     }
 }
 
+static int vfio_add_vendor_specific_cap(VFIOPCIDevice *vdev, int pos,
+                                        uint8_t size, Error **errp)
+{
+    PCIDevice *pdev = &vdev->pdev;
+
+    pos = pci_add_capability(pdev, PCI_CAP_ID_VNDR, pos, size, errp);
+    if (pos < 0) {
+        return pos;
+    }
+
+    /* Exempt config space check for VSC during restore/load  */
+    memset(pdev->cmask + pos, 0, size);
+
+    return pos;
+}
+
 static int vfio_add_std_cap(VFIOPCIDevice *vdev, uint8_t pos, Error **errp)
 {
     PCIDevice *pdev = &vdev->pdev;
@@ -2199,6 +2215,9 @@ static int vfio_add_std_cap(VFIOPCIDevice *vdev, uint8_t pos, Error **errp)
         vfio_check_af_flr(vdev, pos);
         ret = pci_add_capability(pdev, cap_id, pos, size, errp);
         break;
+    case PCI_CAP_ID_VNDR:
+        ret = vfio_add_vendor_specific_cap(vdev, pos, size, errp);
+        break;
     default:
         ret = pci_add_capability(pdev, cap_id, pos, size, errp);
         break;
-- 
2.34.1


