Return-Path: <kvm+bounces-35792-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A401A152D0
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 16:24:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8BCFA167D9F
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 15:24:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A4A315CD74;
	Fri, 17 Jan 2025 15:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QZmXugUz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2071.outbound.protection.outlook.com [40.107.243.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069AD198831;
	Fri, 17 Jan 2025 15:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737127429; cv=fail; b=h5NF4bYeTAsqySW74jpimS6pdGds0yigcBaMifNIROnd3WrlgwbYJsl73mQR3DiAh5AdykCRkRqCkrV8Vbmduw1QrZqs7kDplxp6W0hmWg/vkNJV0RXMeI0yBYZVPr36/r9NbE+CmvlAvnIxiZOiDTGNTA9hogQ7/2gZvMuh9Co=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737127429; c=relaxed/simple;
	bh=KE+g5KOfNv/wwbYz50H63xEARZMAlRtsNSEylYtNkrI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QNhlytXovPfH0MZEuT07o5LvFmIiufjLZ3voBhOl9aRXEGwHxu2NSOBLW/HxR7dKIbQ8ScCgMeOO/l64l6gIIElKRSP+MNCTt7ZzZ+5rpQ7EPDVMcpHdmRN72VD3AFYDIG5SxnaytPIdldbgY6jUNekV8xjITVOfNkf9eLmPV6U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QZmXugUz; arc=fail smtp.client-ip=40.107.243.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oTZX/soWDy9r8BXlamU/iaCUO2LOxSY4kMGfaL1BY0OsYqfXz6oOS8l5JjMAu/Y1OnA9KCM6M+M+uFBsKkEltsLutzDeQnqoWC8SV+dbqm/5v+sE0kjdA0mLP/lWZWSLKy+x2ZMWrVpLHujAbXpybDhU42j87AUfXVChMTNAEYWgmKhKFHWQm+bW/Vb15rRsq8wBy7aVhiMQk6zIX/r5NDLjKz5Lqfn4ifi9B8e1nPWLyLn0tdrCRXSIsCbaDx1iHruID1QNC+UGIC1T+Fw75kgq69BwdRVKsK27LWY235NlQUDzQ8Ldmmwm5csOrtu3HyQimx0fMgZM15wC/U46zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qQetDipuxeBacwszxRph9MRiCoK6bb3drTetpBsMQng=;
 b=aAjtebu6hzCyDs4yyf7NXXR/cV/F0AKi2KaiQAkRrCX07ThFFPuLNEZHuIHRcXPFqbK52GIKHkwq8GBhsnfhKX+x+iF4OvnLT1OnFTfP/26XwbZawhK7LGd//J0Vz+iX1ZaUJtfzf2ti2B6+qaVCDQiUTd6qe2d+v7p0Zgs8qzY8yDRgZW6vZ63Vg2ySjfx6xBLpR5o1O5nqY5Lau0R+xDEdOIvIGWmosekPAszw7fFrfSjeMAY9V1wyo8T5BvIS6EY/T+twQ8w8dzpyspB6iSvsdxu7GDMsyJX+zSJxpFrOoiV/6tip4ykLyrZL+YPoY8yes1aO5rtzS+gRat7s0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qQetDipuxeBacwszxRph9MRiCoK6bb3drTetpBsMQng=;
 b=QZmXugUzsk/UNTjHnCZpVR6T6zmPIVptZFgjiiBSoMdfS+y5V2rnkkb04EPa1VbYH/zQKwYIim5mL1YXZ/Zb8XhB3iPHXuhW0PRBz5V6GRmL+acJB7UfApWNR9PkvJrwS1VhUURi55hyRyPNrw+hV6gIje0x792F2FK15Sa3jjSr+K8KmALe+Tbgcc4xE+QkNJoBI9+a5qVaSMeCsxL1YTuoQ+DolOGcvQAAYzx/QiWI0WsJQTtQRSduKjx2mCFcmBxyYd3CUruove3UyMeUHAbI8ZyT/M0IshrS5To6VANghwGWq3H1TRxsLORRbJmj4BoabrB6NRsLNGWiGBsuqA==
Received: from BN1PR10CA0026.namprd10.prod.outlook.com (2603:10b6:408:e0::31)
 by SJ0PR12MB8166.namprd12.prod.outlook.com (2603:10b6:a03:4e2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.14; Fri, 17 Jan
 2025 15:23:41 +0000
Received: from BN1PEPF00005FFF.namprd05.prod.outlook.com
 (2603:10b6:408:e0:cafe::dc) by BN1PR10CA0026.outlook.office365.com
 (2603:10b6:408:e0::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8356.16 via Frontend Transport; Fri,
 17 Jan 2025 15:23:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN1PEPF00005FFF.mail.protection.outlook.com (10.167.243.231) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8356.11 via Frontend Transport; Fri, 17 Jan 2025 15:23:40 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 17 Jan
 2025 07:23:37 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 17 Jan 2025 07:23:36 -0800
Received: from localhost.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 17 Jan 2025 07:23:36 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<kevin.tian@intel.com>, <zhiw@nvidia.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v3 1/3] vfio/nvgrace-gpu: Read dvsec register to determine need for uncached resmem
Date: Fri, 17 Jan 2025 15:23:32 +0000
Message-ID: <20250117152334.2786-2-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250117152334.2786-1-ankita@nvidia.com>
References: <20250117152334.2786-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00005FFF:EE_|SJ0PR12MB8166:EE_
X-MS-Office365-Filtering-Correlation-Id: 081e1a21-7265-418e-651d-08dd370aec39
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+272kHZ0Wh5oxAsY533gj5fH9w8feJg4FpOKkMPvBRChOB7AYyRaFiDCLGWK?=
 =?us-ascii?Q?JvpvV681OBxKwkOcM+0Y3fhk+y38J8QyS+3G/0zcaPQ4vPytIU3LWRpCVLdD?=
 =?us-ascii?Q?nipMIcNcu+n0vnbi3SxWVnZqpJE25+o9uxAnjNO7UjuEb2s2LsP2RIVy02Cs?=
 =?us-ascii?Q?MF7G5k0dt2xS1r85aRZ2jq/aufHZQCLylnWs/pQ8I/n4uCJWmr/GIp5LfzLW?=
 =?us-ascii?Q?tCMblQ7tN2uGyATZVZjl+uTkv6LZX6uUUqWnwfzAmNilHESTeUxDdgnEaEHz?=
 =?us-ascii?Q?Ju1s4SmRL3n+koIQvoKOPX9kcZ9XYvCnfcjmp9ALd3Cr3R6oWUZ3N+zx0FYR?=
 =?us-ascii?Q?ufZunp+xnyJ5jOwL09dfz62gG3wY771Ll7VoH9ZKEa0tOV9wQs2VLloOEbdB?=
 =?us-ascii?Q?na8HiPQ4zJVubJh0iNGmxlryWqxEayXOP/ndlQ1vWtoiupRyg1koQjygJJhv?=
 =?us-ascii?Q?eQwPBZWBFdgF+I+iTW3z8YPOuEgMR9qm1M0Z0HSbKGma5morFPoWvWJL8VrW?=
 =?us-ascii?Q?9UVajIslGH+CpHxRFWwgC7LPjyz3IkyDisR27i61/05nIzPiUpCIe5uFGtF6?=
 =?us-ascii?Q?adlmyOfLOfJULSdLpAaXtFFfu9LGQQx0y3crS7cX6HP1lbGlAb7Yz+Kri5Zj?=
 =?us-ascii?Q?w4HlT08ExkmXKs1IjMqH21IpsDXrGm5tWN4Qh/WEq3S3jiFnuQ7WpZesO6IK?=
 =?us-ascii?Q?IueE6y3uvqaIjQjAt9eXsor4j9Z/ddEksFWwGRRnuepJxS3QilDhkt+UnPz2?=
 =?us-ascii?Q?V1FBk8f13vfeRG6PIfQBhQACfvcioJtMzDUdm//osJT6e14oetUIWgAqq/Nk?=
 =?us-ascii?Q?WD7ee1+QQZK53rmv0Eu4+EwqQ9od+WxvvOBkbmwxKhAmlclrvFJT+wBC2btP?=
 =?us-ascii?Q?gffGev0iOVWtUbPQ/nb232SFxq6U8idn+S/GNv7LJ5sNF1H2dADT334T5qzd?=
 =?us-ascii?Q?NR1Puj6okyycF0fA3281VJpwdnYcC3vxFlwtlZBWYg4t40XTdwD7c5KLBQcl?=
 =?us-ascii?Q?O2AT5a5eP9yPo0s98gpA+wF04ZjX3y6Ws+5iF06sUkgalPZcoPyDrb5BhNMI?=
 =?us-ascii?Q?cj3kdqsGj1ASdi0cXVhdYR/M728D/hDGFthd3rkvOTuHY1Y0Vh0mjz5TCIhx?=
 =?us-ascii?Q?/IOEOrW+oMTB4caxbKsQseBq4YIRdohNmwP4bLPkZFQ/K5Zr0shpgSMmjbsl?=
 =?us-ascii?Q?QE/Jud6J0VVslE8oquMpYfhCG7gz9t20qAqv3m/3meP9h9kcS+63riSBmP3Q?=
 =?us-ascii?Q?vGkn6M7ej4tEBCZZsipwKNLOp8kACRaJuGteCvyWHzjkT0F0ApNzMSnvL2sl?=
 =?us-ascii?Q?40fWd3BHPWNjuuw+WcfWrQRoaMXeEBFqG/kqoRr9IB+K4wU0mskpagDiGFdJ?=
 =?us-ascii?Q?jheRXrF5SZb8jYC1qm/rl8MBOq10cSvuzHIthYhaLBG0fWn4mlFPs2W138l5?=
 =?us-ascii?Q?L7T95t85YR1PgFFCSdFIHoBof4en6T9hGEa6XP92ECUvyc+NajEw5UJg+3HI?=
 =?us-ascii?Q?CYBGte54d7GQSOs=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2025 15:23:40.6988
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 081e1a21-7265-418e-651d-08dd370aec39
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00005FFF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8166

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


