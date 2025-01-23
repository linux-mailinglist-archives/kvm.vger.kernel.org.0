Return-Path: <kvm+bounces-36415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31A8EA1A937
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 18:50:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF5363AB5AB
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 17:49:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA9C91ADC61;
	Thu, 23 Jan 2025 17:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="h2afOBu9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2068.outbound.protection.outlook.com [40.107.244.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A263153BFC;
	Thu, 23 Jan 2025 17:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737654564; cv=fail; b=km9BdO2NYwdBLB3e8M11zySk8Xce/xpsw7MD1aimFobgPUOzgl1P5XV5E4jKgKLdr8VIeXcuSw0tDCUwuSzjXxjSWVwajKBItnGNTaGHsJ1CTMWGsaEbQedO1j0QdcglxQwn44GodKlKhjMsAeMjQwzH63YcxUzNkfiO7TFNpok=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737654564; c=relaxed/simple;
	bh=E1GbxivRprkcuBhGVK+F/YT/Y3Ioy/tY8cMsWdfmh8Q=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PqSSJvw5ry655aORpPFDKRqoe+RGUn587zp8IrNSfCJFWF7zuf6UqlSYQg1VSK6mV2dgUeyhVWmEgoEoSfkXsuUKnY68hJfvV0dKFtpo5wBw4oX8+jfTip5Ey1R3vs98IqOmAbx6HTJvAj59mBbQnFFELcFsc+HqKoEDjo1K/1s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=h2afOBu9; arc=fail smtp.client-ip=40.107.244.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PBZTvSgMortp86/ua+aWpuOZCmHhTXVI2uKx6pQOCW69BouAJeiOsUkHWDpYQSKdReAJGVhdfV3ositsyomWIRnGoxJJhCNWFFlWzalZW4qPyA4G/GkMZ5oYJ8Fq8qlPH0/xkVT8JTcpUeslT3SQN1uo4oKHkFFJfQrk1LwZfgOtXhLl8CcOhvd4ezUxDAOVpztZVSR2dW6zv/h0o8nimWNUIRvK4yFvlYWURVOWAn/nxk9O1Be5TbL9dmOYJTLhv4Lu+NT3DyYBiG6UdbHlMCnwL7hDDcZ8l4/iE8K2q8EYFDmWtCZQStsdjDTfUkSe7kSP0KqWetZOsyVJQAoKhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kguMAxnoawyPIcGqy48La7PKpCBrvN8LGimLfCejLwk=;
 b=MBfi1AxHrK/4ko7DEoPmYiFoHQj+/fFHTVZT1YfeUts3ILFwtw5nmLKXe8bjYZhcKblNyZTmmoA/ywkCRc7k72z/KD42BKSYMxFrG3WQJB3VsoQusaEzXCqKMWG+NJpKCj2pS6yNWpVWCkAbKd1DgCD5hBp/OY+7qUUYH7M/zR1qy08QouqK3PqW/McaOhAwMDJTScPrPsgFvDSbSOFA3IdnsImwXYS+PihEzoLrNSSmuAaVF9rwHnxIgoqCxcBiMcLlo2qEtuyY2cX4pnjYme3OPNcKhWWVs048S4RjlHLbhbNJxUyr+Fvd2yrMOh5XB+alYAoOFeuMDeU7rCSMsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kguMAxnoawyPIcGqy48La7PKpCBrvN8LGimLfCejLwk=;
 b=h2afOBu9APZwJ+Tq1rMO5BcmRSc474iwZ7PU7//Fk0J2ClmhPnEotR8SNR3iNfaomMkUWwdA6Bw+KPr6Hz3WjVvDol3lI5OC/DNNzoWuIcphgya3Cf0dfOk3x3B+siGTSpuFLOPG6pBpBElsTC8vlJQyFIubZ6A5jRBgNjZToNTPDBlGcNluzAbNjb3AKE7/vetu16gnnyrzmaj9dhMti0SsL4KNqdfGhwaF1CcyvpTM3WPzW2vghwPzUkOnhOHiDLcKYU0iEag26FH0zXSsKeGEqXIckT0oVyTdS5YK7mN9YytfIa0IN2dyK/zxXMxSrxaizBAKhxOUbbVYVMxAnQ==
Received: from MW4PR02CA0018.namprd02.prod.outlook.com (2603:10b6:303:16d::17)
 by SN7PR12MB6691.namprd12.prod.outlook.com (2603:10b6:806:271::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.17; Thu, 23 Jan
 2025 17:49:19 +0000
Received: from CO1PEPF000042AA.namprd03.prod.outlook.com
 (2603:10b6:303:16d:cafe::61) by MW4PR02CA0018.outlook.office365.com
 (2603:10b6:303:16d::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8356.21 via Frontend Transport; Thu,
 23 Jan 2025 17:49:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000042AA.mail.protection.outlook.com (10.167.243.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8377.8 via Frontend Transport; Thu, 23 Jan 2025 17:49:18 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 23 Jan
 2025 09:49:03 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 23 Jan
 2025 09:49:02 -0800
Received: from localhost.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Thu, 23 Jan 2025 09:49:02 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<kevin.tian@intel.com>, <zhiw@nvidia.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<kjaju@nvidia.com>, <anuaggarwal@nvidia.com>, <mochs@nvidia.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 1/3] vfio/nvgrace-gpu: Read dvsec register to determine need for uncached resmem
Date: Thu, 23 Jan 2025 17:48:52 +0000
Message-ID: <20250123174854.3338-2-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250123174854.3338-1-ankita@nvidia.com>
References: <20250123174854.3338-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000042AA:EE_|SN7PR12MB6691:EE_
X-MS-Office365-Filtering-Correlation-Id: 1730a99a-1528-4f4a-729a-08dd3bd642e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jVCy0we6GUKNpn4Vnks/RWxCQc0ET0TMefKDuP4y5WdjCyLdm6JHBHFou1+3?=
 =?us-ascii?Q?QsYrO90Uls1z28N38ERCKO77uQx4BjYDGJsJ4jmLnnFn+0f8hChKiU5A8cdx?=
 =?us-ascii?Q?17J+zi09ShSBRmIWOZGvQFGWbnGxgVu/JxKPbFIj6gqP0wtXb/InvObiX3Ii?=
 =?us-ascii?Q?mpBxX1xcQXgjYRdCTrE20q0X+CTFSOcabxJmtauQrGrKHtKiXyAt6RZJV+rC?=
 =?us-ascii?Q?lzoOQXD+1TpOc9Wic1kCoMGrlObB4r/68jHeolMyKHYlEJ1KJcq7nJzbxTIj?=
 =?us-ascii?Q?NPzoeUDzxGY+9BYEmQx+dU4Y41jApaOFBJzkPq3q9nWqI1uDkVb2F1G0L0NA?=
 =?us-ascii?Q?u/sVIlVjN3QpfpRxLeWlzeDhJA1DXEpOYlm11fYphWoaJHZ/i57h5EX2d+ZK?=
 =?us-ascii?Q?lfKerXIJQm46ObB0lxLalRLQmzx3ZdRc+dL+CuNkzgi8y91NwfrwInXGqawE?=
 =?us-ascii?Q?lCPP92LV/Rd/uMMXRX15rrtXlW+1aAqpAJKXK8g0XmhZfkfMskOLdyPNnFeL?=
 =?us-ascii?Q?HJRemtpxVemzOn7Qbu8BizoaIybs31zk4fVFPJEG/44LhDui0ZYtA0/dkLDc?=
 =?us-ascii?Q?rdLPpQ5bdHSoUZ/o56RzJje7CzzhTlCIp1YaPc9I4NmEEpm5dNIOMTF0ortR?=
 =?us-ascii?Q?QKTLdbJ0Y6El2gUAITNzL2L4xxKp32qF5RJnbRKRBKSz+Kyn+dJ1hcPp+fcP?=
 =?us-ascii?Q?CFZ5qBekuejhv/9YeCtTeWGmIns5wFy/dFr7y6UtwnME8j+lDLN09dzA9tsK?=
 =?us-ascii?Q?RwctKU7JfpniMDwtjm0+fqrcLtFYuYIktmoa2HC5uC+DooBdRUDEqi0oBNR0?=
 =?us-ascii?Q?JT3dRozU0WRJkeyJZ7lPSq95t/NmKCLoZztozcjkBwWVzFQ6z8crQsPvyePG?=
 =?us-ascii?Q?Urqae3dCq4rWSO+09D4HFQPRZNJqWMSmwYs/YnqWJnuBq9rQtmt2+vesStMm?=
 =?us-ascii?Q?tsGfgL4V714/wzhejjzTJzVPsqyp21KNQLhZ7F2WYgydm7xqEEudjnR0ux4y?=
 =?us-ascii?Q?fSLZpfb2zQmoeGb9EKtorY53KG/ThW/DghcidEzPpfcpntLf966bZWqPT41k?=
 =?us-ascii?Q?AuVSu8/ErUE8jU3hCtFt9H8G7NmtJnyeMvnxvkwm/M6xWjxSJq5jVOXqGth7?=
 =?us-ascii?Q?pFm6Tu9bjDJc9dvDhiRqZiNwRnuUy8HxBLz6MhKfL3VNM7iTAmqDcGnZ06pz?=
 =?us-ascii?Q?tb8trTNHI0ao4cw8QuTx4jwmwXE7tA1EBY0ibCIfG+U8JdutnVfBRPH5E+IA?=
 =?us-ascii?Q?31EPSiWWUQcJBuD6ABapBaNXTAynfC1LTCeT3IUm/w8rFs4tmHHXzh3wowq3?=
 =?us-ascii?Q?KhKRWizcNUpY4Mc+YtAKubZp0V1cJS3d4uk32Tst0qWRNBww9r+rlQ+xlCvZ?=
 =?us-ascii?Q?z1HIt5A479E9GEgQTlgaPDtSra0Lmha9NSGQ/v/HCg6JA8G1Uv7KkOORmwgy?=
 =?us-ascii?Q?xO7g17Ss0XNCfY4XFNn2SLrQE/+YiQ4lpuvw0RCOLkKzwljXBI9u8ZGuMbPB?=
 =?us-ascii?Q?+GjHbiiCeem60LQ=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2025 17:49:18.7332
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1730a99a-1528-4f4a-729a-08dd3bd642e9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000042AA.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6691

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
 drivers/vfio/pci/nvgrace-gpu/main.c | 30 +++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index a467085038f0..dde2daa597f8 100644
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


