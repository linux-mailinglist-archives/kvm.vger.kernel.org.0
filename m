Return-Path: <kvm+bounces-36565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C1825A1BC24
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 19:31:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3216F3AD38D
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 18:31:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FD9421C175;
	Fri, 24 Jan 2025 18:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MeA7/zSg"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2089.outbound.protection.outlook.com [40.107.212.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5210821ADD4;
	Fri, 24 Jan 2025 18:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737743498; cv=fail; b=okq1rz25P/6z4Wx9eH2pErRH0vWZTqUgYHKQyfT8FGJb5q/S8rq8kQfDRZf7SanbfDR+wTIULoscKJERQ84ZlRnsoFQDWXGIWZiGf/2I9do0LG5Zm0NVJQ6ZZFDNyvGyXE3WMzU/ztShHB+5RQs6GDZOsjN0f5RbOzJT45mIGpc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737743498; c=relaxed/simple;
	bh=25frWz6E9qzJrdUA7y/bA33HODC1GGhpzua8cX5x4mQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qZa6UdpUbXzgHuMgivJawGqgPQLdjAIJubqt0P8NqNR0tNcNyP1vG/hHg9AJT+2MlZv/sVA/3G9Rr86zYz6c06kISbjIiNgwiFXUXxFxmVIUngW0DewKgOizxDjbVjGFu+FatMYT68ekGzwdjs5nN1ZdsLINCJEQq003jfg5p20=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MeA7/zSg; arc=fail smtp.client-ip=40.107.212.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RStFHNxp6B0W4pEkqg/Wd4t1zK7z/qKhIaHjTVuhtWmviBU9kXwVZUzDY3KXWB+/W8hClpuumJiK9pqGUL8iZqE7KPtJD5OPlHEhUitbWQpeVK2hDrfPbbG9VoFC9qoypIYkqjsf23VbxQpqCp+OOv9pdtsZSvVqHipytf1IwyNMEIi6DUytlr7qtLrT8zYvP84QnQri4Y8c6ApGiNOjwyYfRLcgTSk5+9kYfVCz2W9X5Czhf6Ns/Agqd6HNlygTvNxeUoz3pm6TjZohDPCG+JgOLvHbTIBN/xPCf1n2yj7YVA4BiKjEQbeUJR+TiZsBDTBTfmQ71EX9wC2jvEQlEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VtniKdu3qv2osqCpUpwQFA8+cObXJHXS3+82q8Z7Nz0=;
 b=WODxw8wXAmqKs4v/tS0WGW7dpKEbWaeC9gDuyAqGTiucJlnSNwaLTNJ2mneza+xzDjRhuq181zE+nuMtsyWRw4oe9OdTD398nwMy4WGl/lQ3iZ+rRB4MYog0u1s7lIpgMbCVdttEh55W+5NEAhjmgszV4XaRpt6C3tV/OvhEXi3HTcZwY46SCwI8dE29swDN/+r3Pro5DH2CFrE6470QoTqEeVomrWiJKk4j23h2p4UNYdtIwS78U8u1w/6P4SjcjG/HO1Mjy0BKS+9JyCs5mdAZtnn0c5djml8NRATgmCDkkPfxMTqAAPtOPrnoCuzBoqscbRPWoS8K83XQJlyOpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VtniKdu3qv2osqCpUpwQFA8+cObXJHXS3+82q8Z7Nz0=;
 b=MeA7/zSg0WH3qgKhPKv0XaYmqtbo9GvMqWjBhYdSlNhXaVDFVPCzmV7fFKX9uX1sxriszzN4cwW/z5Nsw4lWXru+hvuzYibMhb8GvqfsGszRzBvpiVuk11L2HLwouoFh5o4nir8NeuQkoQ6LLfg67O8oB3W4oXE5X45yDZUSx0uoqbW45wbmN4f58OHway9nA0503K+t7vMLhtcXhe6ayx35XnRaqNkDaWkFv1oQ7ontJb/RcV4U0hVq3aqfoL3DORPyR2HNiJxQRqM3lfxIWCyWEi79UmiXmTJ4EVkuMogfd39noo/PJ3jJsn4x3ZZMdoX1jmhBBn41tmBZPN/QXg==
Received: from SA0PR12CA0003.namprd12.prod.outlook.com (2603:10b6:806:6f::8)
 by CH3PR12MB7691.namprd12.prod.outlook.com (2603:10b6:610:151::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.17; Fri, 24 Jan
 2025 18:31:32 +0000
Received: from SN1PEPF00026369.namprd02.prod.outlook.com
 (2603:10b6:806:6f:cafe::74) by SA0PR12CA0003.outlook.office365.com
 (2603:10b6:806:6f::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.20 via Frontend Transport; Fri,
 24 Jan 2025 18:31:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SN1PEPF00026369.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8377.8 via Frontend Transport; Fri, 24 Jan 2025 18:31:31 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 24 Jan
 2025 10:31:15 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 24 Jan 2025 10:31:14 -0800
Received: from localhost.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 24 Jan 2025 10:31:14 -0800
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
Subject: [PATCH v6 1/4] vfio/nvgrace-gpu: Read dvsec register to determine need for uncached resmem
Date: Fri, 24 Jan 2025 18:30:59 +0000
Message-ID: <20250124183102.3976-2-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00026369:EE_|CH3PR12MB7691:EE_
X-MS-Office365-Filtering-Correlation-Id: 59de7d8c-b333-4d03-9a55-08dd3ca5531a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bebRb/YNa0C9gxxAIfSM/fL6sY9h6ec9e2bgh1MnaTGVbjJH0w2WlJx9ODJC?=
 =?us-ascii?Q?csZnoQS5MsUBTg4JCUKAXUxHcoT4QDswOZzHLCI9ndkUdTLdzO7Ershomx7m?=
 =?us-ascii?Q?1fOZxbjtv0aRaqv91izZDxmMnxyhl1Iwqmb2/gHOt2dg96OdE3EdceTLN4ZC?=
 =?us-ascii?Q?n7Ign/9SyqY96fm9sOTBrDBIg+etJXwVvaxAQKL975J3o4TcP+gO9j+aPPjx?=
 =?us-ascii?Q?pGJqJpAHBUa66GK7RHzshieihsVUNCQWvG3AlYtq7J1ubvZA9JVTVl23pqex?=
 =?us-ascii?Q?9zmR2TcOdDam0a2XVsmxqsnTpJoBV7fbgmDtjgetaGiCKUnQjz8uh0CIsg6R?=
 =?us-ascii?Q?OLO7Et94gGpZ5X6ZkDlS/jAl1vnjhjiNXTqicbALvFke2e5N5CqzdU2lfOlY?=
 =?us-ascii?Q?e9xz7LHsVLup8fRZU7FAlrxuNGleuIvYkTeGPxkgDypE69qEGq3JrvhRr9Jh?=
 =?us-ascii?Q?K05alDuOlUbO0sacDBPPLDoLIgFYTwOoCI5PB3LvTxW+SMJ2y4bxSr+0jLCh?=
 =?us-ascii?Q?fbeCzvlbOZ3GHKJ+DkjsvBy15bLwSwXzCEoYLyR3JE9vonz4QgswS2ar+Nrg?=
 =?us-ascii?Q?iu9eb08bai0CIZew0tNavn83Np6sOnbXcQ2cqWSpgoxdQYXz9LMxMzmBXKH/?=
 =?us-ascii?Q?BMY9foV5FA+h/kBvpHveBsAhrfFshnXOPA1jxXUHfTPO2wZyqIW1HPdxObNX?=
 =?us-ascii?Q?t2XHbqf4bC485bFmfrArNI7tB0ol0lI6hKWGd36h7lq5l3eI/Mdo7skTVKp1?=
 =?us-ascii?Q?zNv24m5ICBYudErQYwl+jFgv3KtbJnDJfAYhr7I4G93YcUjUtexWZsdMGzgn?=
 =?us-ascii?Q?CC0onHidrxC7rrQWx2KY1LzLKhTVB3wFliW7l/7lFH+7hT+L4iSB+NNOlzpH?=
 =?us-ascii?Q?E9LHhNsMGXvoiLVzr81K6WoHPuUIlxC+L+7Fh97G8XIuxdRboG9QOEzE4rFc?=
 =?us-ascii?Q?+9WXKaQsnhTaHtom/2YtWBPFOcAs+ux0bMMa6+l6DYIXI8RTV3e4ioysevUB?=
 =?us-ascii?Q?iOWtOAfLNi05midzgTMNM9iJ8+JgPs7Amqj5Mstvyq+jT9zQ6W+nz3lLPSyM?=
 =?us-ascii?Q?qoKc3+gbD1G0ShZ1+qi7rY9NTxEEb4wlPHy49Fg6DEt8e9mkC28wAhXyPEsp?=
 =?us-ascii?Q?cLZty/CoaXtavTjjFTb44m5yd3003+MIsz87PHF/Ny/aYOEZs7lWkQSsuw2A?=
 =?us-ascii?Q?RRk6Iaz9h11Y8iDZDXl8mYLB+wv+CeHBsYMM6HFRaU617LL5q1/N0LovpHcb?=
 =?us-ascii?Q?v6u9/j5gK8mQujsGwE6cZRkctQIMq4npbh5N4mzm+l1el4sKWE2zqlZ3vkdp?=
 =?us-ascii?Q?4a5zcWHnZV49EGiz/c2Z4NHdPWRQTZZ4AtOnGG+jcpgii+VvgeGoWNNZXwyV?=
 =?us-ascii?Q?7H++Z3qYbitjmagMwvUZkNMSWTjG2AJxeu4ebH/NQkLuQrE63scGST3iGTIV?=
 =?us-ascii?Q?yp+8/roq9l9Vw2qO2WTe3+s1AOqvUsLOkontd4f0IOIhe0s1XHdtgmY/am9o?=
 =?us-ascii?Q?fg1ry5hu6NZNBoc=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2025 18:31:31.7219
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 59de7d8c-b333-4d03-9a55-08dd3ca5531a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00026369.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7691

From: Ankit Agrawal <ankita@nvidia.com>

NVIDIA's recently introduced Grace Blackwell (GB) Superchip is a
continuation with the Grace Hopper (GH) superchip that provides a
cache coherent access to CPU and GPU to each other's memory with
an internal proprietary chip-to-chip cache coherent interconnect.

There is a HW defect on GH systems to support the Multi-Instance
GPU (MIG) feature [1] that necessiated the presence of a 1G region
with uncached mapping carved out from the device memory. The 1G
region is shown as a fake BAR (comprising region 2 and 3) to
workaround the issue. This is fixed on the GB systems.

The presence of the fix for the HW defect is communicated by the
device firmware through the DVSEC PCI config register with ID 3.
The module reads this to take a different codepath on GB vs GH.

Scan through the DVSEC registers to identify the correct one and use
it to determine the presence of the fix. Save the value in the device's
nvgrace_gpu_pci_core_device structure.

Link: https://www.nvidia.com/en-in/technologies/multi-instance-gpu/ [1]

CC: Jason Gunthorpe <jgg@nvidia.com>
CC: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index a467085038f0..b76368958d1c 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -23,6 +23,11 @@
 /* A hardwired and constant ABI value between the GPU FW and VFIO driver. */
 #define MEMBLK_SIZE SZ_512M
 
+#define DVSEC_BITMAP_OFFSET 0xA
+#define MIG_SUPPORTED_WITH_CACHED_RESMEM BIT(0)
+
+#define GPU_CAP_DVSEC_REGISTER 3
+
 /*
  * The state of the two device memory region - resmem and usemem - is
  * saved as struct mem_region.
@@ -46,6 +51,7 @@ struct nvgrace_gpu_pci_core_device {
 	struct mem_region resmem;
 	/* Lock to control device memory kernel mapping */
 	struct mutex remap_lock;
+	bool has_mig_hw_bug;
 };
 
 static void nvgrace_gpu_init_fake_bar_emu_regs(struct vfio_device *core_vdev)
@@ -812,6 +818,26 @@ nvgrace_gpu_init_nvdev_struct(struct pci_dev *pdev,
 	return ret;
 }
 
+static bool nvgrace_gpu_has_mig_hw_bug(struct pci_dev *pdev)
+{
+	int pcie_dvsec;
+	u16 dvsec_ctrl16;
+
+	pcie_dvsec = pci_find_dvsec_capability(pdev, PCI_VENDOR_ID_NVIDIA,
+					       GPU_CAP_DVSEC_REGISTER);
+
+	if (pcie_dvsec) {
+		pci_read_config_word(pdev,
+				     pcie_dvsec + DVSEC_BITMAP_OFFSET,
+				     &dvsec_ctrl16);
+
+		if (dvsec_ctrl16 & MIG_SUPPORTED_WITH_CACHED_RESMEM)
+			return false;
+	}
+
+	return true;
+}
+
 static int nvgrace_gpu_probe(struct pci_dev *pdev,
 			     const struct pci_device_id *id)
 {
@@ -832,6 +858,8 @@ static int nvgrace_gpu_probe(struct pci_dev *pdev,
 	dev_set_drvdata(&pdev->dev, &nvdev->core_device);
 
 	if (ops == &nvgrace_gpu_pci_ops) {
+		nvdev->has_mig_hw_bug = nvgrace_gpu_has_mig_hw_bug(pdev);
+
 		/*
 		 * Device memory properties are identified in the host ACPI
 		 * table. Set the nvgrace_gpu_pci_core_device structure.
-- 
2.34.1


