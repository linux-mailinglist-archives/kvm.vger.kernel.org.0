Return-Path: <kvm+bounces-34563-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D298A01AFA
	for <lists+kvm@lfdr.de>; Sun,  5 Jan 2025 18:36:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B9CA63A35DE
	for <lists+kvm@lfdr.de>; Sun,  5 Jan 2025 17:36:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83B2A19F13C;
	Sun,  5 Jan 2025 17:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QOjXTFk1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2044.outbound.protection.outlook.com [40.107.92.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC5129A0;
	Sun,  5 Jan 2025 17:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736098601; cv=fail; b=j9jZbWrF0ertgrACDlThhFSjzRrIbaPyXvbRNbbzkh6oHPhCJmakzQ8tk+TR88ELGH1kjATf2/3R+A/JDT5we015AwiBedMVO6KgYFxtaAjVPntw7xGDkZXAL4HGzBVcAP33kohcQ4mIEv3CWIAy5RuOopJ3g4yVfU0CpX9dTZw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736098601; c=relaxed/simple;
	bh=KE+g5KOfNv/wwbYz50H63xEARZMAlRtsNSEylYtNkrI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YctBEvOwn/GMJN0L6BqCaFZ6ancfumR9DZWNYttHB5BurUnLrNF8mIYmkVi5UuvmrofZ7VZyO60J+SaqVfvsJVinHq3a+xdWOTgHzjBTFBJ+cY5Ax3wq850V+51u2e4RJMBc9TrwPc3iVnnvIeMauKlOLBKhhVq4z+nhm5xMpV8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QOjXTFk1; arc=fail smtp.client-ip=40.107.92.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qz51CNQ0RjlMNwkrGSGxAgD3zSvXEagv+Rv4a8FLHLiX0lA2LEJWVZ781ShuQNG1Jr13jgEntQ2BwNEFNdHf/vl6sdcxDEjP6p5Uel9YRychYDwobKP6UZzAh0mZMQz0YOVofLUVYyD3mqFDdrSCT2cKGe4VLuxuaskuSm3Oy2kQFgHOz2NCJ56EoBY7vq0QOkBFTvmWMTcmC4+tS2nMD8kR6EJauDwKw5f2BO/j2nJjtQWpCmdurmXOQiEkuivVV7miqiAT+D7hAPrxx1y0FeR5UmcTXiIda6JFvjrOU9+xavPStEOSgMmEB63DQs9azUcpcRUxPbuXwsxSdCNsZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qQetDipuxeBacwszxRph9MRiCoK6bb3drTetpBsMQng=;
 b=URX340VOVNAYTnEXjHAIWbtUWTQE7OG+9WQc0cYuDehAzOU6HYlp29dFLjiLHubou4wftSjiNqB9XrFVkqmow16ZQj7t6IGYKQfjh4DyPGEQiUHQ4elP7rM90gUy69kHCyvG1tfj76skBRIFSEmN9YOIx9LxzSmmQjTDLEvnoT+e2TkAYtuO/xoMhgytsdGEw2sbnasIq7dhRWs7Pmf715oztngISoMJZUzFzvm262IhrlSlLHXqQlDIz6DOSwxO99CNOog++ucywbtmmB8IdwAAMSUmpAOUALx+a0cIcJ8699HlGG3CROqzbvD9/Mxbbhb4+3xOj/5X5LEdEeytvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qQetDipuxeBacwszxRph9MRiCoK6bb3drTetpBsMQng=;
 b=QOjXTFk14q1IxA0Zhc55WCMY4SS+IZDEj5zxAi1EwNvcaOFkvpbrYpaqPNdLSkV4VC4H6IsHXe809i9kqyCcUHoWhZ1pwL/k/nUhCxbDVzQ5ManTkuD2ePO1Rmd6Jvr7p+qGkJJ8k9OK83FBMT/Wzgxyq0slKuzpHjdmtFvjB86uaRqsPU0Om5Yy1KXk9483uZWR/J4Le6WGb/x/o69DFg7pRcMEl6fcUyRpf5oayz8fY08//o5ePrLcNk7G1lAHjP9940KhrFTT/C9DXykTbeQCbrHDo6/TgJvc8/yImv/5AGdCsVZj+j9u7Vbffb/bvvTmriN7PMDioY38zTjLCQ==
Received: from MW4PR03CA0113.namprd03.prod.outlook.com (2603:10b6:303:b7::28)
 by SA1PR12MB6797.namprd12.prod.outlook.com (2603:10b6:806:259::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.16; Sun, 5 Jan
 2025 17:36:32 +0000
Received: from SJ1PEPF000023D3.namprd21.prod.outlook.com
 (2603:10b6:303:b7:cafe::78) by MW4PR03CA0113.outlook.office365.com
 (2603:10b6:303:b7::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8314.17 via Frontend Transport; Sun,
 5 Jan 2025 17:36:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF000023D3.mail.protection.outlook.com (10.167.244.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8356.0 via Frontend Transport; Sun, 5 Jan 2025 17:36:31 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 5 Jan 2025
 09:36:18 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 5 Jan 2025
 09:36:17 -0800
Received: from localhost.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Sun, 5 Jan 2025 09:36:17 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<kevin.tian@intel.com>, <zhiw@nvidia.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/3] vfio/nvgrace-gpu: Read dvsec register to determine need for uncached resmem
Date: Sun, 5 Jan 2025 17:36:13 +0000
Message-ID: <20250105173615.28481-2-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250105173615.28481-1-ankita@nvidia.com>
References: <20250105173615.28481-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D3:EE_|SA1PR12MB6797:EE_
X-MS-Office365-Filtering-Correlation-Id: 965f4ebf-2e0e-4c19-6754-08dd2daf7e0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZD7lDx9eCvI2SQMcJ7mPOBx2c8VrSls35C2HIKDHkKW0dB3aVfvvn+pAWaaV?=
 =?us-ascii?Q?+gvbh1g+thVDUBgWakQ3LpYaEpur1yI4WFyuUSonwpm2HLVRjDMnOTl+/vJN?=
 =?us-ascii?Q?NRdoCfLAnaNlKKJtuctGvHRsLPPen9Xu2c4MkBqnhEfSnrtS9on8hJAAYiRK?=
 =?us-ascii?Q?1rwbaXWZ5xH0FX8CTeji9CLha7e3MA0dX9HCLaOOsWuzoWkkG74IP+hFJqZl?=
 =?us-ascii?Q?Fq/PWZ5bXzttRxfJYZKTrg5cxvKzFmdynky+g0p5JRWC++0UYUh+8Rtf+c4Z?=
 =?us-ascii?Q?9yFL+NkgphWLvszXRQd/SH3Jb8Y47ZdImdZNuWtsjTYHLeopZljFrWx6C4Iq?=
 =?us-ascii?Q?gSf0+dtnPgVEOjawzhu7BPBdmpsN08EVE/CFkg4eZ2lZTzzl6LlCCxlus1QF?=
 =?us-ascii?Q?3126U8eZuozq6UkKVKweJTx7Q/5ZxVwXqTrnqdgCv5snDiBjy5FHn8cU7Onr?=
 =?us-ascii?Q?Qji7wi1p6PPPkLB6wyZwG7IQZ48/wsL9czKFrBrJY7OK3xRePlBVisNGBrK3?=
 =?us-ascii?Q?SkHPzh0333sS0yiGyOkHlA2IeJ4i/0UvKlr/wtmLTctPQgGO5BkJt+JYDgRU?=
 =?us-ascii?Q?cG5kQZpSGADF6WptugVrMVZKZk+gAekRZzitTI5uYtebLc4bSZSOlgUrcxyu?=
 =?us-ascii?Q?WkxgAHqJNmdWvZtn0qRAnC9pSLoD+qvI8CRPdi3wXtHXEca4TmbXjJY6jf/Q?=
 =?us-ascii?Q?iL3W60ZI8XVrPb1WrlXuNfkQRkZlvlCdUQ5Yb00mmszdUHSXBfdvIAPB6/56?=
 =?us-ascii?Q?CPIMpbNw6n4agctSCXbM1JUQa2wlHs0RDuZ6lvsbCiJyJg5z+3fAGOwmjdZC?=
 =?us-ascii?Q?nNbk20W4abYTUpws9uA57iM9w7BXH9azXbg8QF4srCQv7ut44sXHZEFS3LcV?=
 =?us-ascii?Q?5XtkMCr2DORaFL821R5bTKjSNeCEG1kgC6MtUrdOka7/5WyUxOqK4exHKY9M?=
 =?us-ascii?Q?S+DItLd1WyUXCBOrGjyILlhnVRwX8KYNIpLvyVLPdPU0IUBngmHITk8sq7ls?=
 =?us-ascii?Q?oW0J9A754RlC9JuYAaOqA1Th9XH36qdSiVMdM9zjPEiz78h3WskYy9/M0fnK?=
 =?us-ascii?Q?8MEOjz7WEbNCGaOrdYuG5mkqtmpqkQKtohSKYan9EuGSkIlp183lY3IJ9R+1?=
 =?us-ascii?Q?y3TKUueJDaGdCtdKp+Cnn4jOcBR16v2RnYlP46HCUAojrXRMpeOQlOgfUpux?=
 =?us-ascii?Q?v9duEpQw92qA/3p+6dTydFF24bIqn9pWLupXlDGdOXu05Ri5c8C5j44fi/mD?=
 =?us-ascii?Q?bdMWemM/kdYJBjqShdrncXknxZQeToOVstdAPvXgR4neYwT+nsttzDF1a+25?=
 =?us-ascii?Q?sYoV9JUcc3ua7g96EP0HzsdPaN9Y2pyiQCPAZiHiiGJFkI/oTzY7FIDeogJ9?=
 =?us-ascii?Q?VUjiHcB848dDvfhVp/ZR5FKKgsta0AmtDbkkRbNw1qMqbJ5YNsHwQVRNMCYT?=
 =?us-ascii?Q?VXeTzeO/YXi/ZBu33H1FrK8JIA62IDEgJdS5zRerLXxgdQur6xpuM/yVXqR8?=
 =?us-ascii?Q?DV9jUJwJDGDrG1c=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2025 17:36:31.2497
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 965f4ebf-2e0e-4c19-6754-08dd2daf7e0c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D3.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6797

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

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 30 +++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index a467085038f0..85eacafaffdf 100644
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
+	bool has_mig_hw_bug_fix;
 };
 
 static void nvgrace_gpu_init_fake_bar_emu_regs(struct vfio_device *core_vdev)
@@ -812,6 +818,26 @@ nvgrace_gpu_init_nvdev_struct(struct pci_dev *pdev,
 	return ret;
 }
 
+static bool nvgrace_gpu_has_mig_hw_bug_fix(struct pci_dev *pdev)
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
+			return true;
+	}
+
+	return false;
+}
+
 static int nvgrace_gpu_probe(struct pci_dev *pdev,
 			     const struct pci_device_id *id)
 {
@@ -832,6 +858,8 @@ static int nvgrace_gpu_probe(struct pci_dev *pdev,
 	dev_set_drvdata(&pdev->dev, &nvdev->core_device);
 
 	if (ops == &nvgrace_gpu_pci_ops) {
+		nvdev->has_mig_hw_bug_fix = nvgrace_gpu_has_mig_hw_bug_fix(pdev);
+
 		/*
 		 * Device memory properties are identified in the host ACPI
 		 * table. Set the nvgrace_gpu_pci_core_device structure.
@@ -868,6 +896,8 @@ static const struct pci_device_id nvgrace_gpu_vfio_pci_table[] = {
 	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2345) },
 	/* GH200 SKU */
 	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2348) },
+	/* GB200 SKU */
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2941) },
 	{}
 };
 
-- 
2.34.1


