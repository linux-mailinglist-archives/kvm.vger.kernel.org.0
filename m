Return-Path: <kvm+bounces-27222-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B7CB597DA93
	for <lists+kvm@lfdr.de>; Sat, 21 Sep 2024 00:35:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3576BB21A44
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 22:35:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70F3418CC1F;
	Fri, 20 Sep 2024 22:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KTfl7yNs"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2052.outbound.protection.outlook.com [40.107.236.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 008BE18A6D3;
	Fri, 20 Sep 2024 22:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726871714; cv=fail; b=Dp1YvspHygfbq0PgeQ+Pk7gStA1ae+/nIpBIeDPd61XdE//wycx0TRJpeyVmuW++MIxhB72+t4XE1Rh36/Yd9AES/e1GRcaKmG7MeTSMf7Q/gN6o39yjdRF9kzP9QgIiybsjs03BEWcxRPs9o72lqjXConFDMoUko0x5qsN13z0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726871714; c=relaxed/simple;
	bh=3FJ+wEiysLCQ56DMR7pDImSavuwsQIQisuk1b47zCA0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VxS3KkEzR0SHk8lTBfX3mWzxbL22NXo0EZ3lTiuHq/j1xmiTQv+jXW2dwEs0MQcNmtlM2RcFIlCCi728DAwnehNiCMcWzlVHEnMFVgo/v4BTpfdM+90W0axINmRIUtD4u7TayzFuJBFXbUCnmDzotzHJxyT1Zx51+oc0EYQuHE4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KTfl7yNs; arc=fail smtp.client-ip=40.107.236.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K4fCh37/Nc6JP4e1fFjkGumvK2M0B5GQPB2p073anS/XP0xBAzTsQI8HG1FIEdIKFK/mn8aqy6lZ/BEohIOJj1bqv1DnAm4Qf5uvI3Xg0GcF461vcDNZxhGW9ycPhY21aX6iCqlap4L6J1lzqHr9OTdBcsTWH0JEabCFIQxBP1FI+bm/J4QZUGCRuCMscI7rHr33i6bVJlz0ldsneHEizbO+yaU9Il4Y/+VAAEU/ytHX+oDKiaW1z0a0+N95TxNKjedeq4c0xlWMFC52B/tn3pieEhv9t4Q4iKnkK/rRat7tdEjHz2Iq8rBAfDY2nFH0hPdFkSRJteZLRhwgX5xkWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dgzxLMZN7EzbADKMTn3VwSAg5y6IGbA7pknUGYtRBKs=;
 b=Qn1nnWWrcSO3ijfa0tGodzrdmW48wfcjkgAF54jXeVunyB7rxQXC75konGABVK2taW6hD5b9n2KKaHSjoQ+mfBctH/SS1OwWMV6ismyhj/JE733OQAcR+BSZLN57BUlALyJ1s3V84oK33LUDfVhX6sfRrcokIXvtxEhVJT1nv7SKSUSoppdt1F9Jwy/sIPeq7NDUbhwkBUg+RwhpcAH6e8NrE479MPxFq3fT9Y6GDwkvKVZpPk+iOe9AhFAJDsKWURlgzRPniSEr9V8HS0tQjxx7JB9+39/3Q6oAuPZRsT5J6Lecmr1Ezj+H7Jqn3AiQD5KHKKGxfbTImsZ49wKtGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dgzxLMZN7EzbADKMTn3VwSAg5y6IGbA7pknUGYtRBKs=;
 b=KTfl7yNs2uA6AurjoDRvtJo0LEjOG642+23yzPeNBndqdAFN/YtmjGgsnRgR/H11y9BCxPNdW368BIYElCx+Y7yzqwqEHfAG97BZduVg2lTXqDyuSNlcSvrWHiLTS5vALPmRR32RNHdQu67TAX2TT//td3oGEDiHwGsyW6xan1ijcbFbVe9SVJGemqr/T3tbQeZxbDeGdahwq5dO6pyc+wISu2KT23LZu0QPHd6+MkTh7vQIRuCY8Ew8wPpmA1DfStIEZuMtQaPNSwsWddDRLYR+iIiURfnFxePIwNboXTfnm7cd9z0Gra0cuxIfYBsMUm+jgGBQuYOPa22GBmoLCA==
Received: from SJ0PR13CA0210.namprd13.prod.outlook.com (2603:10b6:a03:2c3::35)
 by DM6PR12MB4138.namprd12.prod.outlook.com (2603:10b6:5:220::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.22; Fri, 20 Sep
 2024 22:35:08 +0000
Received: from CY4PEPF0000E9D4.namprd03.prod.outlook.com
 (2603:10b6:a03:2c3:cafe::8b) by SJ0PR13CA0210.outlook.office365.com
 (2603:10b6:a03:2c3::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.24 via Frontend
 Transport; Fri, 20 Sep 2024 22:35:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000E9D4.mail.protection.outlook.com (10.167.241.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Fri, 20 Sep 2024 22:35:06 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 20 Sep
 2024 15:34:52 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 20 Sep
 2024 15:34:52 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 20 Sep 2024 15:34:51 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>, <linux-cxl@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<alison.schofield@intel.com>, <dan.j.williams@intel.com>,
	<dave.jiang@intel.com>, <dave@stgolabs.net>, <jonathan.cameron@huawei.com>,
	<ira.weiny@intel.com>, <vishal.l.verma@intel.com>, <alucerop@amd.com>,
	<acurrid@nvidia.com>, <cjia@nvidia.com>, <smitra@nvidia.com>,
	<ankita@nvidia.com>, <aniketa@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC 01/13] cxl: allow a type-2 device not to have memory device registers
Date: Fri, 20 Sep 2024 15:34:34 -0700
Message-ID: <20240920223446.1908673-2-zhiw@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240920223446.1908673-1-zhiw@nvidia.com>
References: <20240920223446.1908673-1-zhiw@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D4:EE_|DM6PR12MB4138:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ea9ad7c-e11e-48ce-84d3-08dcd9c47a4e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3XUeIwtZp6c8mDklwZSH8NSgId07HnE86ZMlV10zXgtEdFv92LqHT2w6JE4K?=
 =?us-ascii?Q?WVD/efZ4Puk9zqgV2FdGlatxsWH57Wrygo0xeMYXnILaAyFIfPCJRLhGv36u?=
 =?us-ascii?Q?d9eu8NEXV3CC+ClR0V80kW+pDcjcN6LJn1nNU5iV39aGnvhVDA2Fw9kpBy3Y?=
 =?us-ascii?Q?pLLtZ8QXwf/H7bXdQr1KrgU34X5I6a0E4SGU26JhPWCeouXXui19CXifVLN3?=
 =?us-ascii?Q?FDJz3kweumIFiorIQ/DMZhW2MJrYBn9aIn9uUzitR5ED0U8kLz8xfr8YQDn5?=
 =?us-ascii?Q?qCJPFWXZVDT0kOwO5S0avcsnb7eE7SzTUKIsYwCpInd8ZdKkjMTwMCIkShrf?=
 =?us-ascii?Q?jUX/Y3NEXVry7xqryr/ZG46Sz8YVy8sDq2E4BF/x6kXBhAlAuuVYnCkDWl71?=
 =?us-ascii?Q?9QqQOSQFpo/UxP3E1fYilOGcWL3ga8BoHnwCS3oRhh6FsHH92g5mL8qo/NMT?=
 =?us-ascii?Q?Nq9crBS6CqVmuctlgXjmTW2pRaWyvO0x+WI7zd29+6q9YYt0PKLE0kxFk+Tq?=
 =?us-ascii?Q?j6piXfpKcG6srmjcjHA7FYoep9jW6ByC+AadVtdX/wKJiVOrglOJR48pY8tx?=
 =?us-ascii?Q?7dL+ZQnGNM4BnealeY+IKM8F+JMkuPjbbZCFsKRzTXoXq/FsXzw/T6QUbXYF?=
 =?us-ascii?Q?qAKV+Olj+uRAegn4eRg197KQOeHZYs4/DXwuBLv1QSiRi3sqz4KHYR1Fo55y?=
 =?us-ascii?Q?ou1YOW2T99+zeX2fbnpfF9Qmpu95BLYsMQ6SqRNQnlfh7f3JQljQ3Fn+74dt?=
 =?us-ascii?Q?6CIiSqf+Zs7Y+YjnaQfy/8JU0YlnTLMlKGPmANQkqFZ2vRg/4FA5lk8ZTZXA?=
 =?us-ascii?Q?I3HjiAbxEh4eloAcWi/ZSAeDVNCX07EVcPVkPmEmRkY6wi+BeLPmmX2+C4oP?=
 =?us-ascii?Q?7hVYdbAxKcroTVl46oQ2y8h83vK8PHHg9xOq2iNvLK3DzVNRA1HJ02Zuvr4K?=
 =?us-ascii?Q?J2z3Ah6hjV6SaWuDh3+6+4VpxuOY8Ke1uryWPnZi/WbJSk4aKZfuNZQxePYc?=
 =?us-ascii?Q?fiCAUlq2poBAGD+2mFnU0vW13HO3929AYHPTHqElKWaCJMQMz7PrRXT8N87A?=
 =?us-ascii?Q?/nDVS3b3GhoCUpCcq37RqUYEZFmvzypccdYIeMN5cY/A55W1DRd8cw9XlGJD?=
 =?us-ascii?Q?fvcSvLJIQeYpiN5XtlVkyWWvWeD/tfUTKu8Mdk/Ul8t1K2mr/1aiGTPRHo6S?=
 =?us-ascii?Q?6jqe88XyRB6RDVb1wdPhGzsIhRE2p7/S/qrjNz12IfUpI+tJEQiet/085/Kp?=
 =?us-ascii?Q?qQ6Mf2TlqLjJLL7FIu8c7wgd/fmk6huEi+uQvtV0pTf03s7OZmHR9PQHANoM?=
 =?us-ascii?Q?fjVv+T3auFgggIO+UHJHUACIUi1hHiBynMYhX2vktk6nnPdlZyiTVzU4bpLJ?=
 =?us-ascii?Q?UYCce0uza9QUuN7r4F/xrq7hA/Bs?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2024 22:35:06.7613
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ea9ad7c-e11e-48ce-84d3-08dcd9c47a4e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4138

CXL memory device registers provide additional information about device
memory and advanced control interface for type-3 device.

However, it is not mandatory for a type-2 device. A type-2 device can
have HDMs but not CXL memory device registers.

Allow a type-2 device not to hanve memory device register when probing
CXL registers.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 drivers/cxl/pci.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index e00ce7f4d0f9..3fbee31995f1 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -529,13 +529,13 @@ int cxl_pci_accel_setup_regs(struct pci_dev *pdev, struct cxl_dev_state *cxlds)
 	int rc;
 
 	rc = cxl_pci_setup_regs(pdev, CXL_REGLOC_RBI_MEMDEV, &map,
-				cxlds->capabilities);
-	if (rc)
-		return rc;
-
-	rc = cxl_map_device_regs(&map, &cxlds->regs.device_regs);
-	if (rc)
-		return rc;
+			cxlds->capabilities);
+	if (!rc) {
+		rc = cxl_map_device_regs(&map, &cxlds->regs.device_regs);
+		if (rc)
+			dev_dbg(&pdev->dev,
+				"Failed to map device registers.\n");
+	}
 
 	rc = cxl_pci_setup_regs(pdev, CXL_REGLOC_RBI_COMPONENT,
 				&cxlds->reg_map, cxlds->capabilities);
-- 
2.34.1


