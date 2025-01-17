Return-Path: <kvm+bounces-35885-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7D94A159F2
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 00:37:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C4BE51691CA
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 23:37:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC2C61DE8AA;
	Fri, 17 Jan 2025 23:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RTHBNKE1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2059.outbound.protection.outlook.com [40.107.243.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219E51A7255;
	Fri, 17 Jan 2025 23:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737157045; cv=fail; b=g1qVyO7AO5LRQ80WzA8GP8aXcLlIYyDTeCzsIQTAUxe7Uqo+MjL8mpuOHFP1Osds/tdb6inmOXFSMvjaYjOlSTYfas5UBL0ZUa1uyH3B8LMyVxfWGEDhBlU9j5loHqCQA6TP7D6pXGebOixYpuPDxE4CSim5TpPXQdQWVHmjRRY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737157045; c=relaxed/simple;
	bh=KE+g5KOfNv/wwbYz50H63xEARZMAlRtsNSEylYtNkrI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qSDYMAsAXtqm4AN+tArSxdA5eEpATILYit6e4FUKdjkKj1gyKmgTXukTc6GUFLRJPNJH/QlxGvnLvYKd0NTUV1UUX2HIF8qmklmh3hca6YLDbwk83MJpVnCOktuy2nhyhd75uuU/XnbsjccOsrWdi7WTlCjGGmffRxedx5m2Nas=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RTHBNKE1; arc=fail smtp.client-ip=40.107.243.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ueQNTd4zazXASqGPsxA02AjCyjJI2uW3vxGUjnO+Z0OVnZCMzZTsX1dpzHZg6tMNtIREoLnzEjFv9iISmZekdMMW5vS+liRuw98xwKiBgmKJvWdD6hL5CGGJCW0CEnVdgOSpzRzRRZx4+mU5PDr2OwFRu/Mc7zjgeQF4VIPbJl+R+KIMkKzlDPRqdFqMYxjjXGM0Q4mFN1f/Erck11Aq3Yy3gl3N7vVyLWvjQW2pabkNN6U+QAZ75by1yRJ2GTIS+511hAe22D6CpTWFLygEfE+oSTR96MRyaMwF+i4zdmF9vYNjTlGSjyC0xwxNBi1Xtx136n6W7V2Rst9PKjgTfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qQetDipuxeBacwszxRph9MRiCoK6bb3drTetpBsMQng=;
 b=CKO3tXofuYuDyrKczU/qewJkIYehezn5UbHuy+kpMRQ8ENCQ06nRqcu67Pcvs2Jqu1xVOvZ+ItxD4y82HFCsYKoN8eZ36hnXOm+AMGPQ80/tGrAD73H2qAx++r+i9J3XLgsQwU3Iw0oTMoKP4GjZwvCZxBXCXl6GcYGktFsUct6n7qAv38r8L7BlPdHVdIcqlV3n07i4kaTOUCrfjLO+qSsr0zC9lCMV+bx3dGSn+w6YAdzpFwd5oy6O1mgf88G9JdS7UKxNt/vZEk6rR9gvaBm/f4bPhbvR0iCCEcKTC7MRKdliYvU3Ac2VidFceh0QRmIlVNNAm5D45R7i0yBogQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qQetDipuxeBacwszxRph9MRiCoK6bb3drTetpBsMQng=;
 b=RTHBNKE1X9Z2yJwmVwE1PioiA8bvFjxnugH4qEMG20sowyJ4Z3z5SBG9mcZSKpkkfnDQPyZPpTyNR+cO5fy6+t5dTbqnsq9R1xnGc9BNQsW5N5Z6nkcqnCL9P1fI2roWYEyibdyEDJk2UOgXb1ROn/fJnPUrBUmPZ3vzBjUwcAWoookK1Cl84WHlJqWRkKBO6WyxI2L9J7h+gjWZrIvwT4JCsBSbw1B/DQNeshqyFjSUtKaDIl0l/Lbm6Gud0Ci+V9AUcfSwCdMjMbovKB/QlCyeNF6exM4RZw6X7BqihzX/hvdK05+AeYz7RQnSd7l6GPCS0Cdfp8ACYBfLUHpG3A==
Received: from CH3P220CA0002.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:1e8::13)
 by CH3PR12MB7716.namprd12.prod.outlook.com (2603:10b6:610:145::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.16; Fri, 17 Jan
 2025 23:37:18 +0000
Received: from CH3PEPF0000000D.namprd04.prod.outlook.com
 (2603:10b6:610:1e8:cafe::4c) by CH3P220CA0002.outlook.office365.com
 (2603:10b6:610:1e8::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8356.16 via Frontend Transport; Fri,
 17 Jan 2025 23:37:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH3PEPF0000000D.mail.protection.outlook.com (10.167.244.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8377.8 via Frontend Transport; Fri, 17 Jan 2025 23:37:18 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 17 Jan
 2025 15:37:09 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 17 Jan
 2025 15:37:08 -0800
Received: from localhost.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 17 Jan 2025 15:37:08 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<kevin.tian@intel.com>, <zhiw@nvidia.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v4 1/3] vfio/nvgrace-gpu: Read dvsec register to determine need for uncached resmem
Date: Fri, 17 Jan 2025 23:37:02 +0000
Message-ID: <20250117233704.3374-2-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250117233704.3374-1-ankita@nvidia.com>
References: <20250117233704.3374-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000D:EE_|CH3PR12MB7716:EE_
X-MS-Office365-Filtering-Correlation-Id: c56853d3-43bb-437a-df2c-08dd374fe1f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cNoTqdG3FbguPsC4Z2SrcaRmVA3DIlHpZ14l0a6iKOKEcKThwnVNSbp9GfFR?=
 =?us-ascii?Q?S/fF1PLk33sNSe86t++81Cj8hzUcRkJdKJqhXSuIUKVmHxn8ZLKtyR6fBYTt?=
 =?us-ascii?Q?5aYwG5shHOYdhoQ6sewBEvla8ecXsdmb1PJ0SdCyOQus6A0xyzwWi3AVkeAG?=
 =?us-ascii?Q?mQtxXNgw8UaI9h2APJ0xnuReOxvqpo6ZusJX+eB77+JU7qtHqhy/+sgD8IPM?=
 =?us-ascii?Q?Ob72wG2BB6p+fIS6XS3ZhIkiQEldA/YDntzpIZoZquV6HQpaFJtAV1JdwYRf?=
 =?us-ascii?Q?aiKNH1w0blGnK5+OvD1qAcRnZsqV65fXy1LXQHkUBbOmOrdhoLWT7BlnukGC?=
 =?us-ascii?Q?lNJgEqopZkxuGwW8Kqt0jf9dThIlW916L5e+RGjy4+Hr3zyBDzxxI51qUqWH?=
 =?us-ascii?Q?Di6n399dtzxFYan5xHe0D4AqZHWm3066xKpSM477X5uuxxwXYKr5Z49HI7oR?=
 =?us-ascii?Q?/3p0LAAHac7hTahX2gZOnrl14ev68+nroi57iPe0nNm5wZ9Ps/w4GxANesr3?=
 =?us-ascii?Q?WlGOENHmhMdaoHafx7Nal4KM8tLVHr2jW7eu4A9ar0cAMSvRB/LXWl3Pj9iz?=
 =?us-ascii?Q?GQcDwG707gqsOzvtqOm2wYyCZGIw7kWIyziYlOouEQaHvUFVgoD1wcb5HKC0?=
 =?us-ascii?Q?updsVM9sT9g03P/AVIEITA1Yi7+ObjRrWRZCyHlXsx8JcbX6AmbTekodVJQU?=
 =?us-ascii?Q?CMKq6afi/jNSUkS4xSZruFgB8cIQSEBDmgU7dcgHZbqwA/jVkkMK5XrsRT0r?=
 =?us-ascii?Q?1EyWrwrXV1pmnAnWMfe7UkG8wLyd30jyGmedZM8bwGbvKiNsbBpg5CH0X9SA?=
 =?us-ascii?Q?MIxXyHYGkdy6IY1dROeHAaTIrwRgzTe9M1qbtE+nUrCPiueBrnr/haf3rNHE?=
 =?us-ascii?Q?YM3UOTq/hA6PmMbEV1kVc3F8TpDeWFyL50QpLf267PxQA7ukelwDTCda2Oc9?=
 =?us-ascii?Q?mjbOEeqRYzT5RH7pH60In3FRjbwDdg4XFq6F9/droXaXyzUa8AqYtLtlXg9B?=
 =?us-ascii?Q?ZXMrfgSKvEQesbXtLp2thMsm329O7pnWexokiUo1m5tRMJy3p3cX7IP2heJk?=
 =?us-ascii?Q?U5C9MTAoloDyEfLLC4LFZTkVml5vYuTbKdissupn6iU3WlzHo/gwV9c1cmU5?=
 =?us-ascii?Q?bDBVbj3pa/g/3l3k5c+gU+R27nXMZI0JFiFEx7/kinfFq+M5lquhRkj7r2SF?=
 =?us-ascii?Q?KkaiQ6GxmMIeMkZ1WiCtczWvoTBMmO4LpaVIoYjYE/9lmKnVz++qz5o38Gvr?=
 =?us-ascii?Q?hVlelKj95JK3rppqB2pmVi0XKwsGAZAh2N9foiqzMkeJIK5GR2h7SlCsKy98?=
 =?us-ascii?Q?u9iZvh56r4BgRVrxADgJ8ar+Dmac51XFTmi3RpKgnk2SeOkLa26gDhi+N1g5?=
 =?us-ascii?Q?NTqvpu14gOH0zbZ5wzYpwoqMtsB9/9NxF19LOP5eQH9bh62QQK2M6vw/Px2M?=
 =?us-ascii?Q?0RcdeY1F5BJh5RSo/7Um8RdIq5T+fPT0Ww2z0qx9BAQyhqzCeZjUJcqjX2ZG?=
 =?us-ascii?Q?G5nneAvW5ketoJQ=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2025 23:37:18.7690
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c56853d3-43bb-437a-df2c-08dd374fe1f5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000D.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7716

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


