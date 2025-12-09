Return-Path: <kvm+bounces-65560-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DF802CB0A5E
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 17:56:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 84515312C995
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 16:51:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B53E4329C6D;
	Tue,  9 Dec 2025 16:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eXJCWKex"
X-Original-To: kvm@vger.kernel.org
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010023.outbound.protection.outlook.com [40.93.198.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71763002A9;
	Tue,  9 Dec 2025 16:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765299096; cv=fail; b=emn3E5AIn+Kda+bjnv1kvNcSqmwqedN9xWEZyOTCMCXngb45f12UbTOQXjAaUP6nRBii3eYRrDP4XIg7SCImAtv9D/18L2VdoiqNHflyDsMkocK2gaYveeQMjsvWwHkXHYL0Ps7iQM1s0AlgOPEwbjwpxYwgVsYXIxgTmfUZLME=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765299096; c=relaxed/simple;
	bh=HmZk1Sa1C2FunV/jPRVZirmqdx0gQWw89s+PWkewmTM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iZS5wrVOBGBhr76B4xwPlCqbHvDrytimA9cPfBQL3Ld4SsaymCosBPDzneKwFeARcpc7/feX0iuKRINExyXurBCdnRgokBAy+BrMcX6VP6lnF+2J6qQRWykAkuVlkpeKVTS+BHbz7VEfh0gb4kF9xvoV+yVo3JNcS1whGF369QE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eXJCWKex; arc=fail smtp.client-ip=40.93.198.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pjOGXRT+PQPXS/nX6MhV9x63+2oXOp36yUSHmO2Q28IK2yzeH1fxIarftHq0I8syb/l7C5Z4donRS2835XQQSTLD7Tr9L/09k5/nQB/4O+9xePfPHEPgdCc4YLJoE7DtWYnSZvX7izx021R76kfQa3jewisrhxHkhSh2VDCYr8fr1ELj4u1Z40bYJf3Q+88ZOm0b6X/IMjSMC2NLWVdSTQojTvqX7e4dRr4umHZhUA9KPYE4C7MeNtqhXurvqFQdHl/WkvFVc5bAmkigsXrLH0JT7Fw+9LilP5r+s68Wgm+kRz2tYWz+0L9x64gYWdqGbT6/xqTMQiaecPMYRwMUmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HyUU4Oc5ayVI+tqmPNu9i1i6Ktq53SoLcTNWapWyrvs=;
 b=pqpkiGVebP2RP2jgQcd3TO6BLVQWcI7PngqoYFJTsKOCfWMd9t44QcljMb6aJ6Vr1CHcce0jTp9q71B2VOk9Ac9BXiR73TPAUDWucMfSrOpVwMPqTTb/FNTdNnhWHuOgreTFDe0rN4SrHZODHWHFeW7h2EPV3+LkzGVq12JAATQNU3HAeoQ+oivgFJttD1R7oKp/z/hNtOR2juUqu2tGGLvj37+msKCgKGR6GRnXKiEcS/tE/fe+0mG6qW3myN4ZV+kqwqEoxBDruRmTjba1F18Qy6joQ79DnKvdbZg7Ncn9gACw08bXMI24tjufp91b5qWOmzdCLD7DDdm45IWQcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HyUU4Oc5ayVI+tqmPNu9i1i6Ktq53SoLcTNWapWyrvs=;
 b=eXJCWKextIdGOWUx9s3qTDlS3FiH3UII5qoyoWM8L9+ZMvjhseVBxPZEEw111qjI9r2dUmXjysMdKdwhLrnQfErFi/f70JYonsMHoy+OZnG0ie0t17rnm4sl1wx31ntp2n/baJEnCR9HX3FsHNVoDgXVZ8lch5OwiLAeug8yyw+zjNb7PGpI/zDgTdmKrewzBIxcL5wiWfkyhyFJ7Mcq15TRavy/KNN2r1V8Geupfcx1PFM/FSvcKKiO8EKkRkCODGq7dyo9g5zG3XS5PPCAJv1N/57vCeGcfbIYbkhGub7y/XEQN2JcH8Ka8IgQj9MFnFmyGk8cpHpqM4DrzirWsQ==
Received: from BN9PR03CA0451.namprd03.prod.outlook.com (2603:10b6:408:139::6)
 by MW4PR12MB7213.namprd12.prod.outlook.com (2603:10b6:303:22a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Tue, 9 Dec
 2025 16:51:28 +0000
Received: from BN2PEPF0000449F.namprd02.prod.outlook.com
 (2603:10b6:408:139:cafe::d4) by BN9PR03CA0451.outlook.office365.com
 (2603:10b6:408:139::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.14 via Frontend Transport; Tue,
 9 Dec 2025 16:51:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN2PEPF0000449F.mail.protection.outlook.com (10.167.243.150) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9412.4 via Frontend Transport; Tue, 9 Dec 2025 16:51:28 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 9 Dec
 2025 08:51:04 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 9 Dec
 2025 08:51:04 -0800
Received: from nvidia-4028GR-scsim.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 9 Dec 2025 08:50:57 -0800
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
Subject: [RFC v2 02/15] cxl: introduce cxl_get_hdm_reg_info()
Date: Tue, 9 Dec 2025 22:20:06 +0530
Message-ID: <20251209165019.2643142-3-mhonap@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF0000449F:EE_|MW4PR12MB7213:EE_
X-MS-Office365-Filtering-Correlation-Id: 54652a73-8650-4190-8458-08de374332a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|7416014|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IX0KlodpSQ7o65COLyqWY3lXMbuR0m1fXd+DQXD6ezVjv3Ki6QzU0JvbLq6W?=
 =?us-ascii?Q?I3KUzuYF27h/hzrg8EC4tSqFZsU6EHIO06aVvBQe6R5KnypstXwf7PEC4ODO?=
 =?us-ascii?Q?/Tm7+EjsWmdzJYYP4Dhkm2fKy5/TTkKo75ycntqfkT/J/v/BDqmA1Z/mU1zR?=
 =?us-ascii?Q?bkR9QveNV3GgQY7UG8vRdnXVDAFo0xhDCw8QZEF1UrvChh6iSIgTfaDwlxP7?=
 =?us-ascii?Q?N4CaTG4XOI3lCWYbgeD+xd4J74gzGYsRW1GSCUd2gefOHIYEgSzXRJQFubq1?=
 =?us-ascii?Q?cDR4ebfBaLq459lVgl9foa852d2RZKeetSEKfPr/HgRX1bsbTF//vfFK0N0A?=
 =?us-ascii?Q?QzoX3x4Y2F+OAmAFIOkooINauyICx1JVvFFVTeHvCw448DOLVR+CgbfbtElu?=
 =?us-ascii?Q?P8hi15PXsyd673UAxgQ/b8I7pwKgLqzSiBVgNiABZEQaQRkCMxyTW1pecA9M?=
 =?us-ascii?Q?pHAdvsBt40PzBAwuP8+nheucbr88vvSsRe+2+oFqDXXePRAeeV7TM2lTJ6HU?=
 =?us-ascii?Q?1cQNPLZLddWgVqYAl6w9ONn8aYbGYU5tyw1iG696L/NsDcCjIHUWjIMEZqRt?=
 =?us-ascii?Q?B+TovwmLcBmqLPAKP4rFtXseNClemqsqhs1H873HR+Jiu989cIqlkm5LAPwD?=
 =?us-ascii?Q?XFrIgwAjuqoMvraLgzoM9S47Qa6d/l9f6JFstZrLx0uWVDukEL4uc6DQunje?=
 =?us-ascii?Q?691CnQLAltC0HvHxPsIEve7dKNRR7bbPNKL6R/mJC+YCIqHixbv4HMBU1Kz/?=
 =?us-ascii?Q?T7V/zPIz+GYdTlDjdjQ6jxJxLJLWt3nq0XcZ1Gz+Gi5Sw08d5nNt8J6xQLbq?=
 =?us-ascii?Q?4xvygc5OTJQy/pEE5BCk7rE6nx7316gtBybuoxKWXl9NQoLsWWpBAOrggQgw?=
 =?us-ascii?Q?tIyVg/b7+v2H0/oigWd8Gg0BiSyJm3xDcnQVn3k/j6Jnb3xfy/xI22jyQz9v?=
 =?us-ascii?Q?A42qHjbqwOKXHIMtgPCCIF78y24U873Z/jxprgiorYCCpcJPzwbADH4BJsjQ?=
 =?us-ascii?Q?mGTx/rpRMW1i+QvSvgbLSsghhUOH4Ydz+pAAWnEKomerwLy/AWGUZMBg5QcV?=
 =?us-ascii?Q?62a7uJ0c8WrLIXYhukJQCz/6Gt9lOYdYB/iIELVLaPOHbrS6+rMUI5TPsc9l?=
 =?us-ascii?Q?UzAtWsojRKlKcQMmMfQVx2xC9B/nusGWbkLLAXErwvDObuOG+Z9zeXJwif8a?=
 =?us-ascii?Q?n3s1jOVpTPjJP6OqpKMs+SXODG5ku2W5VdacVSYuOewCnO0iYoFoEu6Hsm65?=
 =?us-ascii?Q?TvgXKBbEvVJBG2XRMa8Kv9LJ/LP3SS4e05HLJw7O7JceoNmLdNnkopcnhgbe?=
 =?us-ascii?Q?bvfCViAzP3c+TPtkeiJg1stdJ/IJM2dEKWNiXbJq/iJHggPJVvr+k5V85jUH?=
 =?us-ascii?Q?hMg/6jaI734j5Lm4H1JRart5hLNNcluPqwMYYX1jGFmMOU9eV6AQxekJhNF9?=
 =?us-ascii?Q?K8jnL3Vv3IOWtGxZ2L67er3267m/d1qS1lVwnLVP7cMs2mhBkufF1QuApRXw?=
 =?us-ascii?Q?N9Y0/sEkYQIOyWLsMNkE281NU2z3WsXxReZ0051vUIvaLKB5emm/PxKSOZNI?=
 =?us-ascii?Q?Be15gmzVA8bs6xiIDb5HsCr8mwFE9w+SFoOS+UeP?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(7416014)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 16:51:28.3246
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 54652a73-8650-4190-8458-08de374332a3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000449F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7213

From: Zhi Wang <zhiw@nvidia.com>

CXL core has the information of what CXL register groups a device has.
When initializing the device, the CXL core probes the register groups
and saves the information. The probing sequence is quite complicated.

vfio-cxl requires the HDM register information to emualte the HDM decoder
registers.

Introduce cxl_get_hdm_reg_info() for vfio-cxl to leverage the HDM
register information in the CXL core. Thus, it doesn't need to implement
its own probing sequence.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
Signed-off-by: Manish Honap <mhonap@nvidia.com>
---
 drivers/cxl/core/pci.c | 28 ++++++++++++++++++++++++++++
 include/cxl/cxl.h      |  4 ++++
 2 files changed, 32 insertions(+)

diff --git a/drivers/cxl/core/pci.c b/drivers/cxl/core/pci.c
index a0cda2a8fdba..f998096050cf 100644
--- a/drivers/cxl/core/pci.c
+++ b/drivers/cxl/core/pci.c
@@ -532,6 +532,34 @@ int cxl_hdm_decode_init(struct cxl_dev_state *cxlds, struct cxl_hdm *cxlhdm,
 }
 EXPORT_SYMBOL_NS_GPL(cxl_hdm_decode_init, "CXL");
 
+int cxl_get_hdm_reg_info(struct cxl_dev_state *cxlds, u64 *count, u64 *offset,
+			 u64 *size)
+{
+	struct cxl_component_reg_map *map =
+		&cxlds->reg_map.component_map;
+	struct pci_dev *pdev = to_pci_dev(cxlds->dev);
+	int d = cxlds->cxl_dvsec;
+	u16 cap;
+	int rc;
+
+	if (!map->hdm_decoder.valid) {
+		*count = *offset = *size = 0;
+		return 0;
+	}
+
+	*offset = map->hdm_decoder.offset;
+	*size = map->hdm_decoder.size;
+
+	rc = pci_read_config_word(pdev,
+				  d + PCI_DVSEC_CXL_CAP_OFFSET, &cap);
+	if (rc)
+		return rc;
+
+	*count = FIELD_GET(PCI_DVSEC_CXL_HDM_COUNT_MASK, cap);
+	return 0;
+}
+EXPORT_SYMBOL_NS_GPL(cxl_get_hdm_reg_info, "CXL");
+
 #define CXL_DOE_TABLE_ACCESS_REQ_CODE		0x000000ff
 #define   CXL_DOE_TABLE_ACCESS_REQ_CODE_READ	0
 #define CXL_DOE_TABLE_ACCESS_TABLE_TYPE		0x0000ff00
diff --git a/include/cxl/cxl.h b/include/cxl/cxl.h
index f18194b9e3e2..d84405afc72e 100644
--- a/include/cxl/cxl.h
+++ b/include/cxl/cxl.h
@@ -289,4 +289,8 @@ int cxl_decoder_detach(struct cxl_region *cxlr,
 		       enum cxl_detach_mode mode);
 struct range;
 int cxl_get_region_range(struct cxl_region *region, struct range *range);
+
+int cxl_get_hdm_reg_info(struct cxl_dev_state *cxlds, u64 *count, u64 *offset,
+			 u64 *size);
+
 #endif /* __CXL_CXL_H__ */
-- 
2.25.1


