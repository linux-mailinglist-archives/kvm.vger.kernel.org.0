Return-Path: <kvm+bounces-36569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 158B8A1BC2C
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 19:32:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 588EB16CC87
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 18:32:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D2E321D003;
	Fri, 24 Jan 2025 18:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ewsMC/du"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2086.outbound.protection.outlook.com [40.107.236.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9874421C178;
	Fri, 24 Jan 2025 18:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737743501; cv=fail; b=lgE/kgMQnkTmorL3YrwFJmAD0e6+XBqSS24EOlkg6KZk/jg8PPvqDAnC77rklI/Q/MmMGzMMGVVMHr0Tc5U7mupLbPSc5NK7m4YZmwL2XGDCKQZMzluGNU0jQdxJB/yuSOa1Fy7bYyJ34e9yHE7euJ/sZmO8vKwxm1Y6keDC7N4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737743501; c=relaxed/simple;
	bh=YDcvHxq2botZi81D6AEE9wbFhLPHVtZeJaVsIZtR6o4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tWK03GQt5Q0jziK+k/D1l7vsJlqAUtC999H24nz30CQVz0zm52tLuu5W108Pq4Hu752FaXvlSBveKBpS6/eUDq7OKUSXPNV9cmhFKXmovYGN2O+RkE7ToY00OJZb71vypDVJ9Jt2wlDgCEcLW+yteKcfQy838EN6pp0IC2boZO8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ewsMC/du; arc=fail smtp.client-ip=40.107.236.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vUMcs2utO4c/uCXSqgNWfJR5Tx2G/7IXLm2yR+C7GfGJSSy7VKgkmfmZGFXS1RWlpM3iOwlvoU5/YUmyU6kawnAsgunCDSQCkSlfKiQhQNOP8G9+6dtJnwAIj19ZI3wpc5p/Kax3MxcXMOwFDak2Rc3jKisn9NquNbxKonObGTGpUqsqsygMgUfNgHIGc37ko51TP3RicqS+Z+RYd5NApFckLbgRVB+O+l4WKUtc1B9tlWDilIlfutsSaa8VmR8zNNkN/IoW+Cw0icmE1XZ7Y85PdjkvbaZajRdW5ZZr4AvdOlscZsBMGuSe8G0AfWzNoDPARL8CmLNvyEle3AE7ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hDUePpC+uBA5jmjoJiISfzCOb5fJDGl6q2+V7qsG1QU=;
 b=JJA4rIRqZaWhtkVsQxKA9Tq+gGxUpOOlcayA9wMx6NB4FMXSLUtnhd2dWfgy8UMZWIapnkZViAuq61Hr0YaR33aYLCygyRqfpIM+vyWZoy5eJ+Ca2UokAu/zPfBLuy0pAMYleVK0TVl6QcSXMuiIfh1Mt+uaJR/46Dv4DJ6LUFBkKftIqY+oTLZLnSFpU/H7iq/Q2EdzOGfmSY0uCFsZSM2rwNQ85BnUQm1Fxj7/FOOPpZDwXIZAwsZeQL7ukKYT/eD6+jnpLqEE1zxD4LqJVsDVXdULVgpexidOrs80IA7OSPEjZvJz2bQephAlf6IwjkWGnNlJlTAyhrayqiTnRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hDUePpC+uBA5jmjoJiISfzCOb5fJDGl6q2+V7qsG1QU=;
 b=ewsMC/duVr1IXfk3JV20MvT3H1x1ZFo43J6m/rrjLNuB2YqHunfkMjZ4Tue1YUt1QzrKVRCAL4j3ei+vThB0ocO4bNES8C73s3E+BcA15e/gK6bGrHAOQJzHqpzlW3O/tCRaoGy8G3+cmFcMUrHPFcw9/tGVYqGF9S41XpSjDSFqYn/xuOELQTOgwWm55BUvi4Os93csY7jnmJAHSmVNKGrivDufYeZWaPEQZyQXM9qckkoMEFR4/AVVjPaf2u/TZ8BzsNYKmRUJlWi0DhjLjfG+WF1waySKRWqaozoCWu+N1+hfHE2FhB2lJnyHS0+ZGdQrIFlj7Z+dMWtXppHQMw==
Received: from MN2PR05CA0050.namprd05.prod.outlook.com (2603:10b6:208:236::19)
 by DS0PR12MB8413.namprd12.prod.outlook.com (2603:10b6:8:f9::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8377.19; Fri, 24 Jan 2025 18:31:33 +0000
Received: from BL6PEPF0001AB74.namprd02.prod.outlook.com
 (2603:10b6:208:236:cafe::f0) by MN2PR05CA0050.outlook.office365.com
 (2603:10b6:208:236::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.13 via Frontend Transport; Fri,
 24 Jan 2025 18:31:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL6PEPF0001AB74.mail.protection.outlook.com (10.167.242.167) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8377.8 via Frontend Transport; Fri, 24 Jan 2025 18:31:33 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 24 Jan
 2025 10:31:17 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 24 Jan 2025 10:31:17 -0800
Received: from localhost.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 24 Jan 2025 10:31:17 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<kevin.tian@intel.com>, <zhiw@nvidia.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<kjaju@nvidia.com>, <udhoke@nvidia.com>, <dnigam@nvidia.com>,
	<nandinid@nvidia.com>, <anuaggarwal@nvidia.com>, <mochs@nvidia.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 4/4] vfio/nvgrace-gpu: Add GB200 SKU to the devid table
Date: Fri, 24 Jan 2025 18:31:02 +0000
Message-ID: <20250124183102.3976-5-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250124183102.3976-1-ankita@nvidia.com>
References: <20250124183102.3976-1-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB74:EE_|DS0PR12MB8413:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c3d0532-6828-4474-2dbc-08dd3ca553fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?h93Ou6q2TDl70kH4HqiVP3DFm37tzj0vcQLSYWotf5x4H91/bdITOC5h6bUR?=
 =?us-ascii?Q?cpf3g/M1QJbi/XrlEUodvVsJD3EajVWDRJWt0dsNFWK+p1xyXWjQtELK9V9A?=
 =?us-ascii?Q?hnOHag7XgFg6auN+JC3/hd6YWAw10xG1OiZut2DzmpGKxZhj7YiMOlzpvtbR?=
 =?us-ascii?Q?76cQgkD69v3Va4cwKt2TZ0yJ/3LiKN97konyoCdFXtIuZMi4KFhnnebnOD+o?=
 =?us-ascii?Q?NHRQtq2FjO19cuKk/CO+ajas+CyWsDuj4txyZEq1HxCeapfe50VDZEOA1N0O?=
 =?us-ascii?Q?gkwacSjjctJB/8Pwy8r4A0mdF5uq+eSYCb1n8ETEoBw2FirkBLlaf295dcMt?=
 =?us-ascii?Q?PggRbMBS2aln4An4adUCxpSgUZGbdp2ArS2awYRxU9PWbUwCyPP/hNIEMrYr?=
 =?us-ascii?Q?Sk+vXgNpa1kqm5iba9WEMJN0JyuwCS9pE7NqKsq6WQsoEI1MsC7emfT0+dTN?=
 =?us-ascii?Q?bSNHZXqwLZhLD0GS0OWLtTlIzLjf+Arb0M7dUfgb5h8JOharfdhVC0FJUxMK?=
 =?us-ascii?Q?iAeOOvtrsVblMIx7pWihChEp1RZGSKxzmAmD/MrBaX1m7odQieI0ORKeLYok?=
 =?us-ascii?Q?8AVqi+2p/ESvlFxnTsiL/sa3oFOA9gd2rPqsirZE+6CszVsPFxAYz4aBIIh2?=
 =?us-ascii?Q?m6XkkHR3oJESbUGBA0wgphcuSwxVuI5cUC9R+r+FSR52edeMoXahMIECybV+?=
 =?us-ascii?Q?4YrKqzB4rsLrk+oiG+WsjlWGeBpS3r+zZcPWByqWaR0NySpAS4uQzpZYpIw7?=
 =?us-ascii?Q?VAlTjZLPX3WkxxMW1H5+N2QC7uvoPjrAo1MO1mZCsijVB1unJsoJtFAsq7EC?=
 =?us-ascii?Q?tiExeFXbQxeeJb05e4Ks/mLm1iH1YMqri0i9PQ76aioArfZ392LhYiwm+50s?=
 =?us-ascii?Q?l/C8wsZiqznXYxtghNXP3ZYQc68mPgaHBy9oGGaim5maHCb8mKv8WFBxzkNt?=
 =?us-ascii?Q?zkclxpMekEUQZh7ObhFB+VM+SINWZ5Sj5g08Wf+qnr2CxwjEtyKtAZjPgk8w?=
 =?us-ascii?Q?GD04KfLQF/++juIJbeXlBW8AqIWCY8IIV6QH7QhE6BoZ1mQBIJlBJzCxrj2b?=
 =?us-ascii?Q?MY428wIHvQpNvvopO50ewaNPCYzpqd/uDjwAfcdLFZGB49TDUzH2S+j1is5E?=
 =?us-ascii?Q?ghmWRK9DXvYYF/OWaCTlw+9gYVRtG3H6bmJlXwTkTW8Ual3Fj1UZAB/q6Gr0?=
 =?us-ascii?Q?7rsEQn3PKHqmaM1m+TuSPHquBzS0QEXtd6DJ/KPp9z6KR73S5OHV5huWfh/q?=
 =?us-ascii?Q?WOZqh5r9b6ZJTDNt/BcCcoTJ/j2AJlrFryFPKKwm6Ss+csavxpaoSV8Y8KP6?=
 =?us-ascii?Q?mgXF3ZocRfXTrjBesjkFL8YSUPeRMVOFQwCVhXeW6wBkAB1t/t2lzP/s5Cqs?=
 =?us-ascii?Q?EJmYS1vmoPaHDk7Iu8c7+RuDzki+R/s4ZQzuCQik/3UeW73ydqC1RRF/x6Oy?=
 =?us-ascii?Q?YJp5N2L62P+tkgwx8ri4wol+CicuEOE9FECWBc/JGjDMO9bRT4jKgpTiToM0?=
 =?us-ascii?Q?qof3ItmamQHARyY=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2025 18:31:33.1247
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c3d0532-6828-4474-2dbc-08dd3ca553fa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB74.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8413

From: Ankit Agrawal <ankita@nvidia.com>

NVIDIA is productizing the new Grace Blackwell superchip
SKU bearing device ID 0x2941.

Add the SKU devid to nvgrace_gpu_vfio_pci_table.

CC: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index 655a624134cc..e5ac39c4cc6b 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -991,6 +991,8 @@ static const struct pci_device_id nvgrace_gpu_vfio_pci_table[] = {
 	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2345) },
 	/* GH200 SKU */
 	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2348) },
+	/* GB200 SKU */
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2941) },
 	{}
 };
 
-- 
2.34.1


