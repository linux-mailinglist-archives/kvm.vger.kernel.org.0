Return-Path: <kvm+bounces-28033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 09EAB991DD1
	for <lists+kvm@lfdr.de>; Sun,  6 Oct 2024 12:28:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 95EC3282FEC
	for <lists+kvm@lfdr.de>; Sun,  6 Oct 2024 10:28:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54DCC1779BB;
	Sun,  6 Oct 2024 10:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="l3NvyuY0"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2076.outbound.protection.outlook.com [40.107.223.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3530175D5D;
	Sun,  6 Oct 2024 10:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728210472; cv=fail; b=OWhkZbvBmf3b9mZzF9eGbO+8hz2+K/HbZWdfyC2ktxYfYHj26uZXR2nNi5O7w9yv7GT6SVQlNDLt5P5qVPfnpupSKwYaf2gfdBSPeOd6K7sHznGmUmJSPUh8i4+cVubni2TIKS/OUlsO6LaS7eZH1irgAvanNC4aV58LCTXeZA8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728210472; c=relaxed/simple;
	bh=BSMFMO9m+ZXmyobPZF2qsXOOTgj7FmQ4v+jIfLX8roI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ACfbQzlWkNsR4jHmnoPVqCZwZhzLYfg/3P4SziSp1KE26TpdUy3lnvi7pF4NnBfoG0kcTWsAXP8ES4dUjs1p7yWkgu1gyP0zvqougFRnBgwPUuecP4LuETt2dQVsL1EAVbANuWmMfVhLY+IZweO6kz5MmQNPgui1BPwwfGgCIdM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=l3NvyuY0; arc=fail smtp.client-ip=40.107.223.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WS2jAFkApRwj7n75Ts9kr7iis263dmn/ocbChO2Z7LO+MVLU2HmxzQQtQCKe1poZ81KV4BwS7mn/IFH3cMxxPBIqXHegHRFo/pxbdaAoPKB2dYgPgTfpVbIjwYzxIBKQdSxEEMI8EMK2uO0WXHeRLAFTB0MVjtWr7V/KSUPrv07jzNxoZHP5xsEFhJV4MkLzI8Wti1src+eHV5SgZT30MeYAlfVDK7xhS+fNTy/BT1mbGkkSdYsWhcNvaxaTxpimp9qZ1u25XLe3mJA61oHqq/TPCoZKKmdGCAu9mK0qKIueicZfTSuVV72qUg3KWeGpc2XiXBJsT3o+0uYLv1ym0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d7bPqviz6+5cqd0rKLMG/BRUCaOeRJ6OrYm2s36h5tM=;
 b=d1YREzKHedUFtcaYjNXGi9VTHxQoj19V7y50mK83b6y8+UYH0sK30UInIS/uGbs+UfkJbWYF1uAWuZg6nXbcGOcKAqssvcyBaIy0oMmbGclVhELmBL17A6MmGolhwvD7QWN5rgMzKVgZP8xLWh6/v1FUUqFb70nPC8AlcwBfvGbstsxuUGcvG4Uao1lb2MZwLVq8txjKaZNe3WjAgp0PUT5D4FhA23+AYyAhCbjsZ0LV26PqRCMowlU4msoNSiRjKCzWcBLKPgA7P7TmpmlKz370DqVUpaaxrMOBIHaByXlE2Vp3gXMr0fQtMXj3UpOEOf09PXncWSkjqgP06JPdHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d7bPqviz6+5cqd0rKLMG/BRUCaOeRJ6OrYm2s36h5tM=;
 b=l3NvyuY0Nb/FGHkck6a1rpuydjmbJMtwAUnRw9+O9JHmo6fJVl8AQFEx77iCCXkP3bTRVbjWVqMT0Ci6NbSdhHoPyqRnap1gEbCaZ/10pIkmetZqaqBgcYhJrrtEYqQFv6qgmNI9kDScu7QUHVR1o0z9W/eDBirIBjkZ+l9i0pVhl6mD1kokJ3+pozJjCx5YS8WEDFjO0YkGrpO+5QkehdPeC723W+kfybjZTkV2jxKgEET0jjzJQniOBJsCJZhTNAkN+YXFvl14ioMvVX+8+MgRRmeHcsYJpznfu9Ai1yq1ozrV/KAHxZiFGfChFnHD7UMenqWRQ8qVNG6eaHDHKQ==
Received: from MN2PR10CA0028.namprd10.prod.outlook.com (2603:10b6:208:120::41)
 by DM4PR12MB5722.namprd12.prod.outlook.com (2603:10b6:8:5d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.20; Sun, 6 Oct
 2024 10:27:45 +0000
Received: from BL6PEPF0001AB74.namprd02.prod.outlook.com
 (2603:10b6:208:120:cafe::46) by MN2PR10CA0028.outlook.office365.com
 (2603:10b6:208:120::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.20 via Frontend
 Transport; Sun, 6 Oct 2024 10:27:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL6PEPF0001AB74.mail.protection.outlook.com (10.167.242.167) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8048.13 via Frontend Transport; Sun, 6 Oct 2024 10:27:45 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 6 Oct 2024
 03:27:41 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Sun, 6 Oct 2024 03:27:40 -0700
Received: from localhost.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Sun, 6 Oct 2024 03:27:40 -0700
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<kevin.tian@intel.com>, <zhiw@nvidia.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v1 1/3] vfio/nvgrace-gpu: Read dvsec register to determine need for uncached resmem
Date: Sun, 6 Oct 2024 10:27:20 +0000
Message-ID: <20241006102722.3991-2-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241006102722.3991-1-ankita@nvidia.com>
References: <20241006102722.3991-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB74:EE_|DM4PR12MB5722:EE_
X-MS-Office365-Filtering-Correlation-Id: 6211f000-147b-4f91-da83-08dce5f1848e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IKCEIgik4Pd2erOqslnXAq/sqT4uaaVq4Rb+OML/Xu4+sWly7wR/SbwoQBoC?=
 =?us-ascii?Q?uIYG9PA+4keC2DCe535DvCAGBPxxjb8AkKb9kzdUFqqpciwfF0uePXX8dX1W?=
 =?us-ascii?Q?eVkWlTJGN0dk7yvUxQN+c77FH9aSUKTjaBCpcvO5VgNKyFNIzs1/nHN8BtVc?=
 =?us-ascii?Q?RD63kzG/uhhAiSoMIj+fusSZKhgT+8F/VpFIBFCJObEzMECeoG578YjCqbkK?=
 =?us-ascii?Q?GItmW7orX9wLr6l0a4/4fUgyfD28+SGhFbtmFv0k0BVjCk6DmAppdLjUwMtm?=
 =?us-ascii?Q?rH6Ob6nm/lEArpIKWu9EjMeJgbSvFcxCEJSwrEhpeOtzEMeCWUUk/svPDBYh?=
 =?us-ascii?Q?QEUAVj/IuP9pwDX4QtQTNSRpM1HcI1vqYfC9LglfZ6glhsaESbSA22Nkl5KD?=
 =?us-ascii?Q?ySdr7HQBvI3wKFbO/O3YtRRvfCcYntfTRa7pYjwqq+MucCioC6hUYIGFXBj0?=
 =?us-ascii?Q?By30XBwZ/3p/EPGtiwQ3vEHxOLwsswy0Epy0WRCEE5QwhSl/riaiH3p5lDN8?=
 =?us-ascii?Q?3hSdGNqmAXeC1NgRkdqRXDP9y7wmLv7K5uzVodN1iVQfsvxsG2yoi0fOGbEs?=
 =?us-ascii?Q?5C803uznIct9BfUHtUkAhQWyoHZF3HuanhViqiA6yl8Ub/3h33PieuaKEI5U?=
 =?us-ascii?Q?zigX1RWPWkqJmQ7awMdspnS5MpIWp9nfZ191+57nplBxwnypPCsL63Fxj9Gl?=
 =?us-ascii?Q?8as7bBEISyeNL3+EItKkVCGLPbY3pNq73XqQFSmERQy2954BTLJARCd+KqVI?=
 =?us-ascii?Q?P+flScya5TguUIVyYzDge6F8T5sGyb5TFfEaDQehkgzHYLPL5pQrFLlvn4cT?=
 =?us-ascii?Q?p7DFO92Ir8h+LNsJpv7lJhy/K5sJ7W0aaFJ/gLcPHmtpcuxSzYZJBjVtk0NS?=
 =?us-ascii?Q?Gt4dwECoNeKbvPm2oj/FGzZjFPPWVuBCJsaouWn3hrRaHIuHZzDc8x+5Nk/L?=
 =?us-ascii?Q?wB5AYxJpx1RAIFwia+TxovCC9pENuBoyLrDr0URNu/hPXyf0oD+Diy6efHei?=
 =?us-ascii?Q?UEe9DYum7mTcl/Y8ZTki1rTxhWroanV4nc6Lj0bOkERefdf7deSlPAd7azpk?=
 =?us-ascii?Q?9RJiaxkszFCoc3id1ccps+kL/CPx7TxU19fie/9UY4mOFmd1qC050ElAPZQj?=
 =?us-ascii?Q?tUPJbbLyWonKYZ0s0EJDQE71BqsS0pPwjbe3DW+SnqBy79tSNlRfuexQqxO9?=
 =?us-ascii?Q?mZKYbt+QcJwtLrDRmX+uTzoaPQhMjnwSf1vB3W5Of2Ihf7UfYIHWy0E213C1?=
 =?us-ascii?Q?Lyi+W3R3Ml445PU5YI0cOscMoYds56C8yyRt/w4AlYLcgHlWv4Ygq/R9jMZa?=
 =?us-ascii?Q?MDnpJVCcikj1Et0yb8HKe3vfZTkN/ebUX62oEJDJ2weKEga9D0DMFs5TA2EV?=
 =?us-ascii?Q?zkoXb9M1sDkKoNUsWZbXNqa8woFf?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2024 10:27:45.1570
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6211f000-147b-4f91-da83-08dce5f1848e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB74.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5722

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
index a7fd018aa548..c23db6eaf979 100644
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
@@ -866,6 +894,8 @@ static const struct pci_device_id nvgrace_gpu_vfio_pci_table[] = {
 	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2342) },
 	/* GH200 480GB */
 	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2345) },
+	/* GB200 SKU */
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_NVIDIA, 0x2941) },
 	{}
 };
 
-- 
2.34.1


