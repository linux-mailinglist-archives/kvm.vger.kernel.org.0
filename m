Return-Path: <kvm+bounces-27223-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1214E97DA94
	for <lists+kvm@lfdr.de>; Sat, 21 Sep 2024 00:36:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 52C78B2193D
	for <lists+kvm@lfdr.de>; Fri, 20 Sep 2024 22:36:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D107818D655;
	Fri, 20 Sep 2024 22:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cphrbCjq"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2058.outbound.protection.outlook.com [40.107.237.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5278918C93D;
	Fri, 20 Sep 2024 22:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726871716; cv=fail; b=OnmBRu9mwtNhbVmYcTZdldkbYiarggwr4hkjDZCR3ZAy9TWG8S4pqg88PjIK5bTsuXnAOIkU0hajX2Ur+FlksnM9KuEwndbW3sO6pV2LvodUi3uLBl9NjqDY9tXUFSFsVaUYahHvv10X/TfX67tx9RWAgdbBXHZ90l78uG3lwhI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726871716; c=relaxed/simple;
	bh=cOL9T9VqgBapCd3Lkbt5w0Mm1ggmFmBbuHT8D281++0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mVHHcf5shc5fqbac3GP8whaAjNjtHxM8jtsoOOw8g/DKqkmUaXZjnGizmou9yMwrMKzuu5ZOZqBlU6uEnHxEAQcpIBjy+CJqiNDt/v711pLYUdTf8vVKi7ftUMkbTUS5q/y53RsvXvON9y833CUgchrhgLIFsM+PyIuB+Evqtj0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cphrbCjq; arc=fail smtp.client-ip=40.107.237.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KU1BzTZcexnq19Ad0480PBbP9dSSzvkQ4wHJlSEJL51dU3N9QiV24bN5j/T9sw+Bszi//1LTQCnJ5Rqbn1Ho+iyAdVjGlxnSgvD/DpAiluxmqMd1GGIdcg2d3jaI+XeQx1JG/V9sT3Gnu36HxkvEctHKrCBu8ts02eoBLHOE568UAxTcPJxYvzltnm8F7N2fVFxyZU3Qocuk3sDggPpsQ37ZytQM2W4WH352pIXjWXZSdgVXyC0jRtA9IBnWp4TRWNpfKILnABaBO3GiHzz3ir/dx2JiiUznT+ACHepdtrwi+wqFRHGhKW9ZplCrpVB94FoPspK6v1msxaMQMXUo2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IZjwt1pYXCgMGCEf4dmwKVwcDryN1NIpG6JfXRMHVlU=;
 b=tBPxW4dHJgtNRSF7YuslsiCMAle7oee+DDsGR1EzkdmTrHlSUj0og12emar+40poFLaKlAjgT4BVfH6FuHQgT702QW/uu8NKtlozYKErZ1UAP74+iO7ziU6BKpP1IDNbhPmNtUKt1ah51JbU78OrLTF4l2b7JFVada3eIMptMmTbkWB8nuSD63LnG01ao6cLjN1PxJQQ251k+8eM1qb10XBf9qMDutuyhtNlJitvMPuyaYs9VhwxoNqwmV+4Nrq+ybJ2BJkdxUyHyzGU8vWxQs4Ns55hH3p7YLjthV3utBOd/28+miGTKZgrXxqkKr/LnmLFPDJVJQAi0llu7YMgag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IZjwt1pYXCgMGCEf4dmwKVwcDryN1NIpG6JfXRMHVlU=;
 b=cphrbCjqv1mosCC6held0g4xl50yLAb2q38fEiWqSGsoIz4xARkp+D3BufnK03BUvGzQbL3NXVigUnQ20bKU91bqGaCplvxwVGxtjA9ew22grBupYbOs72RTrE9zZ/99WBIrjM2enwyYs4Rd5tOhwzrHRdBlNB36ADyE8mRuDj6tL/XQkdC9FpAseX8IsU7F3oLi7yGzGFzGdfH5PhjMCPrYR5zGr+fLRY5yRczF9xOHm62bFFoMrskT7dTs3uTOyEH8S3yrKSUuS5YtscmoGYxVWQgwZ2ZfPn+N/Kx2TkYmUxvMAmLiVgiToteb9X7yBa1sKsRDJP4jrXoCaNQiuA==
Received: from DM6PR02CA0157.namprd02.prod.outlook.com (2603:10b6:5:332::24)
 by MW3PR12MB4396.namprd12.prod.outlook.com (2603:10b6:303:59::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.23; Fri, 20 Sep
 2024 22:35:10 +0000
Received: from CY4PEPF0000E9D2.namprd03.prod.outlook.com
 (2603:10b6:5:332:cafe::2b) by DM6PR02CA0157.outlook.office365.com
 (2603:10b6:5:332::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.29 via Frontend
 Transport; Fri, 20 Sep 2024 22:35:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000E9D2.mail.protection.outlook.com (10.167.241.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Fri, 20 Sep 2024 22:35:09 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 20 Sep
 2024 15:34:55 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 20 Sep
 2024 15:34:55 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 20 Sep 2024 15:34:54 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>, <linux-cxl@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<alison.schofield@intel.com>, <dan.j.williams@intel.com>,
	<dave.jiang@intel.com>, <dave@stgolabs.net>, <jonathan.cameron@huawei.com>,
	<ira.weiny@intel.com>, <vishal.l.verma@intel.com>, <alucerop@amd.com>,
	<acurrid@nvidia.com>, <cjia@nvidia.com>, <smitra@nvidia.com>,
	<ankita@nvidia.com>, <aniketa@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC 03/13] cxl: introduce cxl_find_comp_reglock_offset()
Date: Fri, 20 Sep 2024 15:34:36 -0700
Message-ID: <20240920223446.1908673-4-zhiw@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D2:EE_|MW3PR12MB4396:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b7835c5-a439-446d-0c97-08dcd9c47c0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hGh7L7DHjy9sBdnJjGWSa5cJANF0/btJDsuXj+kReN7AGjdacc+S0CUPCRxe?=
 =?us-ascii?Q?MOdAjKyg+X5lOFpUwSUPa95mUzenNyg5D7uzV/O04WL+Ywap3hR12SQ99Rkw?=
 =?us-ascii?Q?8oqLyS0rX9obtU5H7Vh0tXU924E1ZT9zXuYoIenZtBCQUhylQCGPrmJ57Pu/?=
 =?us-ascii?Q?YCd1YuAVjnAU8Ck/nCWoPU8XSwpmQ+9L1QVNZ3e3zLbX6mUTDCYcp1+SRhRS?=
 =?us-ascii?Q?I2I46niM2fgU7qpm81zl2Epo/S10qNM1TfWEp7Fv0O4lCkqreq38Wiaso59G?=
 =?us-ascii?Q?ePk+j/EB8V8GIuq8+ZuvFy/jZ6+fGEnfdsicV0rCsRgPqluaLqhw5eHX+5O9?=
 =?us-ascii?Q?HwQa/BNT+MjxuM8Ww6jS2Pq3n0T7xj8XZdeCAt+kun5FgM6bC1PkWOakhcCN?=
 =?us-ascii?Q?sG8XWh3gNeeD4U4NxV/TBCkkIAG20CniXQzwg8U/9dXWmB9o0Y7+sOHuHKpp?=
 =?us-ascii?Q?uQBj+T+J6Z5jY0jwVVXxEEZRhCVAl6y0eJFv3ChalfsV0LT1vks3KTEd2up9?=
 =?us-ascii?Q?9Aj0TAEKSn5O+vRYaUzlZGOqC5vh10xyC++5C1O6CAtBLLVdqmP4VnJD3q8y?=
 =?us-ascii?Q?CWln1YXrJdddJvQ+iDvlg8n3N02+hJ0//39H3bf+ttjLiTU9Kxnz2scjOY6s?=
 =?us-ascii?Q?H7dXyj3SzvmCffixMAI4PqnM777nvdGXJv+sAlKY9sPLOcy7gi996OHguDWD?=
 =?us-ascii?Q?7kUCjytnsS+EfTuFD10QjiJeAjV1nkot10hTRTE1fJj6zKC60di9SkrFtq9r?=
 =?us-ascii?Q?XNZxftIhOjRcFA+aTwQQLOsH5HL7FzdD6hjBY/fQ2ffWh/8+bK+LhUavak+k?=
 =?us-ascii?Q?iMVOJm97f36uZ2lHoSWQOhHy79HoPuym92nfX2fZEr8CyYm8UvqW+z3v8dgv?=
 =?us-ascii?Q?LZrhrwtFg2Fs57+hpFEVLLTl2e9lfhyLp+woKWq4g2gRQhEC+9Z1qQ8cj4M3?=
 =?us-ascii?Q?kJGjnmXp6rI9JcXApA2XCE6We0hlDZRD1VNjQMJjRwIsgDuF3bwkGq5xcQo2?=
 =?us-ascii?Q?B/xEjdYnszQRSDDgq8QN2gS6Ydvl/wXQ6OCS5MC/eXTQPj2kDSFA4iRvfwhx?=
 =?us-ascii?Q?og+AcigxmWRfrPeqBHjDI2jPXRbyr0+G4lKDk0fxbAJCoV70VwWSuvSMG+gN?=
 =?us-ascii?Q?z80tm2bjK2xL7n35R5nYOwhYwnKu5yA5N93tPEgD9KRUd/luQlYT+HTn6XYN?=
 =?us-ascii?Q?yb6cSM3z20vVzC4aKsiPxZv5Vn/zJJkzQr/SWaZcQzYhmjsO0XvZatR4wFSN?=
 =?us-ascii?Q?rbgYncKc4R591vz2n1XBKRnlsIZNRe4IWBKlqC8wF/jagVwYY/n8A7jf3RFi?=
 =?us-ascii?Q?UXB8QZR0iPibAl/s93XC4ab8seDJfxkeWE7Z5vRM9TLssgGabtMjJoemH8Co?=
 =?us-ascii?Q?1m4NQVyR/Gc5JDpNb+jHdrB6d3d8?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2024 22:35:09.7008
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b7835c5-a439-446d-0c97-08dcd9c47c0f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D2.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4396

CXL core has the information of what CXL register groups a device
has.When initializing the device, the CXL core probes the register
groups and saves the information. The probing sequence is quite
complicated.

vfio-cxl needs to handle the CXL MMIO BAR specially. E.g. emulate
the HDM decoder register inside the component registers. Thus it
requires to know the offset of the CXL component register to locate
the PCI BAR where the component register sits.

Introduce cxl_find_comp_regblock_offset() for vfio-cxl to leverage the
register information in the CXL core. Thus, it doesn't need to
implement its own probing sequence.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 drivers/cxl/core/regs.c       | 22 ++++++++++++++++++++++
 drivers/cxl/cxl.h             |  1 +
 include/linux/cxl_accel_mem.h |  1 +
 3 files changed, 24 insertions(+)

diff --git a/drivers/cxl/core/regs.c b/drivers/cxl/core/regs.c
index 9d218ebe180d..7db3c8fcd66f 100644
--- a/drivers/cxl/core/regs.c
+++ b/drivers/cxl/core/regs.c
@@ -364,6 +364,28 @@ int cxl_find_regblock(struct pci_dev *pdev, enum cxl_regloc_type type,
 }
 EXPORT_SYMBOL_NS_GPL(cxl_find_regblock, CXL);
 
+/**
+ * cxl_find_comp_regblock_offset() - Locate the offset of component
+ * register blocks
+ * @pdev: The CXL PCI device to enumerate.
+ * @offset: Enumeration output, clobbered on error
+ *
+ * Return: 0 if register block enumerated, negative error code otherwise
+ */
+int cxl_find_comp_regblock_offset(struct pci_dev *pdev, u64 *offset)
+{
+	struct cxl_register_map map;
+	int ret;
+
+	ret = cxl_find_regblock(pdev, CXL_REGLOC_RBI_COMPONENT, &map);
+	if (ret)
+		return ret;
+
+	*offset = map.resource;
+	return 0;
+}
+EXPORT_SYMBOL_NS_GPL(cxl_find_comp_regblock_offset, CXL);
+
 /**
  * cxl_count_regblock() - Count instances of a given regblock type.
  * @pdev: The CXL PCI device to enumerate.
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 5e2b5b3e8f38..33dfdc278b47 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -300,6 +300,7 @@ int cxl_find_regblock_instance(struct pci_dev *pdev, enum cxl_regloc_type type,
 			       struct cxl_register_map *map, int index);
 int cxl_find_regblock(struct pci_dev *pdev, enum cxl_regloc_type type,
 		      struct cxl_register_map *map);
+int cxl_find_comp_regblock_offset(struct pci_dev *pdev, u64 *offset);
 int cxl_setup_regs(struct cxl_register_map *map, uint8_t caps);
 struct cxl_dport;
 resource_size_t cxl_rcd_component_reg_phys(struct device *dev,
diff --git a/include/linux/cxl_accel_mem.h b/include/linux/cxl_accel_mem.h
index db4182fc1936..6f585aae7eb6 100644
--- a/include/linux/cxl_accel_mem.h
+++ b/include/linux/cxl_accel_mem.h
@@ -57,4 +57,5 @@ int cxl_accel_get_region_params(struct cxl_region *region,
 				resource_size_t *start, resource_size_t *end);
 int cxl_get_hdm_info(struct cxl_dev_state *cxlds, u32 *hdm_count,
 		     u64 *hdm_reg_offset, u64 *hdm_reg_size);
+int cxl_find_comp_regblock_offset(struct pci_dev *pdev, u64 *offset);
 #endif
-- 
2.34.1


