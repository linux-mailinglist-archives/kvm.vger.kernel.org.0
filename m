Return-Path: <kvm+bounces-65574-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2169ACB0A77
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 18:00:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E9887323D22B
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 16:54:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C7D5330B00;
	Tue,  9 Dec 2025 16:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="R/Vd3IZY"
X-Original-To: kvm@vger.kernel.org
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012007.outbound.protection.outlook.com [52.101.48.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B6332FA2D;
	Tue,  9 Dec 2025 16:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765299198; cv=fail; b=Ej221SF50yBVqR1i/sZLnjrU0FvqhqF1MEAiUqrvpK3muvEywn0grIaB+fJ2lDUDokmZmt0fpHh1lgtvpJDgysqWHDfi9O5vq3qm6uXEm/nyfYDvIwD9MK6S+tirNCZYBZf0LpbdC3K2qT5qMhJyA551UJKAHVJ0Nu/4f27tCps=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765299198; c=relaxed/simple;
	bh=q7TT0WiKBIg/2HCITOZmfCyRYiZfFHh2clZZ/nSETGA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IxyQQqVWe08EEOlz1dnIMD2GYntV7L6mVt8pJJ2I4f3FDSIuC3JiRDsfCj0hJAC33I5vBxJVshc7AjU+/A9X2I5hJCzN9rAesIeb69escnoGSNM8ZQqOrxBYgRS9crGenM4HlawMcxDjbvLWPrZiO1dZbUPttfLNW3lYMe1N6hw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=R/Vd3IZY; arc=fail smtp.client-ip=52.101.48.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j38lMJnuQC3S2PSiDTQCsQ+1/OmkCTXT2Ouiu4qS2jUfvcfp/jYPaJy2kAl6wgvUeOKdbikOA7X/6iT6E7usK1A1T86yWmcuP4pHwvnvlNARq2jEKsIQoX6FIcgxsCB+eZ08HhcNTRUP8JdM8iRJTsaBu1J5orWbW4z+zWqCQr5b0geBlEY+KDLlRJZcrAXu4PB3W8IKJdonYsogPQjzEQ1glsXFPwDDjP1feTZ/u2MRSMOjM01x/8i/bXb44O2b8uMwjVIQbvehKUk10p4oHcqu7TNQmYZVUVzFOJKXZBicZinvZE0+G2RIJYN1BOKc99ZdYjLhqMFiw68I12/y0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H+wxjLkkEC1MkIDazcv7DRsiT2Cba9T35qc2AOF+czg=;
 b=scScSdt4TNvoqcssDVnkhvWz1zIOgQF+MSBmZxpwH3MyFSabXS9Pzs3P/Dpng44SiEgWUeI2vf5WV6do6oWLA3bnMz4aBa6k3f18PX4uthoEALBIN6RZ36kksGG37PhL75xd6E6+40vsgd9DVIrqobJ5IlMDnGexHCvDLfL8qs9MDARkACJlIxfuo3gbaS1Wd2CJg0AIiGj7eMBKcwE9cMPbBvL3ouhC3oQEVbxU+SFyzJc2V+ONEGBFg0BlnxZhoqYsKvUCzfqPUzzmudQhtUsT+nbq6ozoI1uqZBGzms5dKTMQWX9jhn1ykty1ZZIKnj3D3DF2S5dgpgVBuTidAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H+wxjLkkEC1MkIDazcv7DRsiT2Cba9T35qc2AOF+czg=;
 b=R/Vd3IZYgLuQzUmToqwlfJ3A2nhqXCEuW6AOgfkMLvjaHJFB643Qk2kF/EcB9zA03kay8IkaJDLCbq/fW5K7tZV8jY6m6h1xXm2/eaACIqUrmkvo3fVb1cZ+rnDrt7HVklyYIdwXnA2UZUhUQEhl1oJQEOgZZY+xzT9iWNP/N3ufpMK55GgrUhltF3pxHgPThKYT7hElfz4ub3qCh0P+nvcUOhVvo0QLYqqp07312wPoZvbSKBJOwtOjyD/KCXbzvAHtQklx5SJ4hsrWI+GscfOOhrjXsj4b4wleYV5YGgMxg87TPKXHEajQN7M3mZVP66hD4I82eWsh0WePUpfmYg==
Received: from BN0PR03CA0035.namprd03.prod.outlook.com (2603:10b6:408:e7::10)
 by LV2PR12MB5990.namprd12.prod.outlook.com (2603:10b6:408:170::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.6; Tue, 9 Dec
 2025 16:53:08 +0000
Received: from BN2PEPF000044A3.namprd02.prod.outlook.com
 (2603:10b6:408:e7:cafe::a9) by BN0PR03CA0035.outlook.office365.com
 (2603:10b6:408:e7::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.14 via Frontend Transport; Tue,
 9 Dec 2025 16:52:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN2PEPF000044A3.mail.protection.outlook.com (10.167.243.154) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9412.4 via Frontend Transport; Tue, 9 Dec 2025 16:53:08 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 9 Dec
 2025 08:52:43 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 9 Dec
 2025 08:52:42 -0800
Received: from nvidia-4028GR-scsim.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 9 Dec 2025 08:52:35 -0800
From: <mhonap@nvidia.com>
To: <aniketa@nvidia.com>, <ankita@nvidia.com>, <alwilliamson@nvidia.com>,
	<vsethi@nvidia.com>, <jgg@nvidia.com>, <mochs@nvidia.com>,
	<skolothumtho@nvidia.com>, <alejandro.lucero-palau@amd.com>,
	<dave@stgolabs.net>, <jonathan.cameron@huawei.com>, <dave.jiang@intel.com>,
	<alison.schofield@intel.com>, <vishal.l.verma@intel.com>,
	<ira.weiny@intel.com>, <dan.j.williams@intel.com>, <jgg@ziepe.ca>,
	<yishaih@nvidia.com>, <kevin.tian@intel.com>
CC: <cjia@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <kjaju@nvidia.com>, <linux-kernel@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, <kvm@vger.kernel.org>, <mhonap@nvidia.com>
Subject: [RFC v2 15/15] cxl/mem: Fix NULL pointer deference in memory device paths
Date: Tue, 9 Dec 2025 22:20:19 +0530
Message-ID: <20251209165019.2643142-16-mhonap@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251209165019.2643142-1-mhonap@nvidia.com>
References: <20251209165019.2643142-1-mhonap@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A3:EE_|LV2PR12MB5990:EE_
X-MS-Office365-Filtering-Correlation-Id: 059a33e9-2a73-4d89-9669-08de37436e5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|1800799024|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8L58uRmshPkYNMbSBo/QAWeaG/ZmGTY/yfUeHswM9nBMaVAigFvCS2X9dd0Z?=
 =?us-ascii?Q?SgyHxmHgJkjJWhrKF9k6vFdGHqP4e0V1ywYyQ+B96n1d9MS4SSkSxxy8TmPn?=
 =?us-ascii?Q?aYRRaF+bBk8ORAim7kKWXq57HgA3ZucYqEDurmnow8Q0EsFfE9V+jmznF7/m?=
 =?us-ascii?Q?4cUnwcRZWi+buWgqg8WpMHLFNAJwaQ2Fr81iYLftUXDTBM6tM6ch/Tmx6eqK?=
 =?us-ascii?Q?ixyorP7Yj2nB/ElnozGOtJ8hSwXrQWWAOqsQvrULetH9J4iDh8adO7xEDixo?=
 =?us-ascii?Q?Gc4hA5aMcPCcP7VsdGB6T3FMjnHYL5odcu/Cs2E6eajmeSLfxq4Dxjt9iKmc?=
 =?us-ascii?Q?4F763btCgShflk72OXYpZXjAGwxzXbl8X4NBzKOQyMg95gGqLsRRo3FsTOPL?=
 =?us-ascii?Q?lIdJ6nYS6kvijE9oYWtdPAa9mn8WW/s4POvt/9js8AZwYbuaa6ERTxKmdV5G?=
 =?us-ascii?Q?jFOkM/7H/D1a0NdwDlsTW4IS0SrgTdWpTmPtzRSvl0DLXgjBauNshoh5WFqa?=
 =?us-ascii?Q?+JgW55+lAflnwlm0Ade9GmeWv9i7U8DGxGIeTdAucaIWdl6Ry5yHKiVs3F5s?=
 =?us-ascii?Q?qUxVO5imfa724qtK3ev9cB2mrVKmm4eUOlfE8tt00Qc0wq2fdIYLEOktbIuT?=
 =?us-ascii?Q?hvyoU6iJ/dckdf2zLC3pfaIFe60pbOhrQ7JjPM/kLhY0EwFIo9xPUTtMvH29?=
 =?us-ascii?Q?YWytzr59dOZUY3IHPYx3AeBkrmgJ9bMlhY6KjTI7O1kPpx4dUk8At0D0dhRN?=
 =?us-ascii?Q?nIW/C3TGUdpx0REVA5s4KOVngNaaZAoydnPwD2Ghd6HSlIlj7bz77yU8STTD?=
 =?us-ascii?Q?RuiCikKKXsSKZB0lQ+NrZaKZGO967eG6upwtx0pOahq8dwfgGuc4GNw5+ES9?=
 =?us-ascii?Q?RA2i7HOZjYwDmzS860YqnHVWkH4BMSLrO1aWvf0+CQRjEiVRHtchIL43uBoJ?=
 =?us-ascii?Q?66pqXMdeBZofZh71tHIPwxEMrvq+iO7k9AQtGDMiQ+j1CuhYlduBDIrHxRA2?=
 =?us-ascii?Q?VaaG5rGiAJ5PE21W/k2QhKE7GcWt3xokg85mVa+AelEKcZydbi0qDyuHANoC?=
 =?us-ascii?Q?QvmCYckqqkzDC/6/iWdRbH20V6qrKBF1uFCtKNh66a/mwMblTerGFjwI8bIS?=
 =?us-ascii?Q?7OFz7aKXMnUuqjPTLSYsdpdnEPd21FLzrIOUaFARjt8pRzOa8BVi6WxtKGvD?=
 =?us-ascii?Q?bomRRoaUOgU/JOCnp1B0wQu3DrEz+U5r/8jUfoKjZH1HaTgyXlRrwVRJUTon?=
 =?us-ascii?Q?pBcpQTgGp2l3QwSLCjC9Ro9+vqGVEfQjyO+28IV9uBt9SRKSQ8rfc5KbyjOm?=
 =?us-ascii?Q?LWOTzyipFhFAA5H1fAPMdNu0hVmCRC/CfTIsPpcbDLS1+ztL0mo9ulZ6ml8v?=
 =?us-ascii?Q?outDt+NdSx6NkzybIDzkAL3jHLHJ+kmo9M+C0ca+jU39XPBtZVItEHNtSZBN?=
 =?us-ascii?Q?CKQ12IH6eDKDlm5+bUpH3n/edfni6GbuVfNe7PsGgGZPTHmhJTGBy+kISorc?=
 =?us-ascii?Q?C2+smYzUt6/3Qr+4hnMRTZuOA1lOk6GstCTy5LhnfWmMSEhmtyJOqgUXSd/A?=
 =?us-ascii?Q?LCi3D0ZMVYDYRrUjlv8BWeuDVuQqSv5E0p1bz0rd?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(1800799024)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 16:53:08.5187
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 059a33e9-2a73-4d89-9669-08de37436e5b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A3.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5990

From: Manish Honap <mhonap@nvidia.com>

Add NULL pointer validation in CXL memory device code paths that can
be triggered during error scenarios and device cleanup operations.

Two crash scenarios have been identified during VFIO-CXL testing:

1. __cxlmd_free() can be called with a NULL cxlmd pointer during
   error handling paths in device probe/remove sequences. This leads
   to a NULL pointer dereference when accessing cxlmd->cxlds.

2. cxl_memdev_has_poison_cmd() can receive a cxlmd where the
   conversion to cxl_memdev_state via to_cxl_memdev_state() returns
   NULL. This occurs when the device state hasn't been fully
   initialized yet, causing a crash when test_bit() attempts to
   access mds->poison.enabled_cmds.

Fix by adding defensive NULL checks:
- In __cxlmd_free(), return early if cxlmd is NULL to avoid
  dereferencing an invalid pointer
- In cxl_memdev_has_poison_cmd(), validate mds before accessing
  the poison.enabled_cmds bitmap

Signed-off-by: Manish Honap <mhonap@nvidia.com>
---
 drivers/cxl/core/memdev.c | 2 +-
 drivers/cxl/mem.c         | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
index d281843fb2f4..eb694203a259 100644
--- a/drivers/cxl/core/memdev.c
+++ b/drivers/cxl/core/memdev.c
@@ -207,7 +207,7 @@ bool cxl_memdev_has_poison_cmd(struct cxl_memdev *cxlmd,
 {
 	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlmd->cxlds);
 
-	return test_bit(cmd, mds->poison.enabled_cmds);
+	return (mds) ? test_bit(cmd, mds->poison.enabled_cmds) : false;
 }
 
 static int cxl_get_poison_by_memdev(struct cxl_memdev *cxlmd)
diff --git a/drivers/cxl/mem.c b/drivers/cxl/mem.c
index d91d08d25bc4..d5a942ba97b2 100644
--- a/drivers/cxl/mem.c
+++ b/drivers/cxl/mem.c
@@ -188,6 +188,9 @@ static int cxl_mem_probe(struct device *dev)
 
 static void __cxlmd_free(struct cxl_memdev *cxlmd)
 {
+	if (!cxlmd)
+		return;
+
 	cxlmd->cxlds->cxlmd = NULL;
 	put_device(&cxlmd->dev);
 	kfree(cxlmd);
-- 
2.25.1


