Return-Path: <kvm+bounces-64717-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BE2B5C8B92F
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 20:29:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E1D43A5859
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 19:29:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CE17340DB9;
	Wed, 26 Nov 2025 19:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hqJ9j57X"
X-Original-To: kvm@vger.kernel.org
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013020.outbound.protection.outlook.com [40.93.196.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F86333FE20;
	Wed, 26 Nov 2025 19:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764185345; cv=fail; b=GZdi7YfH/NFYncU/8pPjPXCcmmaPj3y2+/cjFhFUkhYQmUYhNKR7ZoEe3/keW/PpXn6tQNeyw3mi5Nk3aiMIcohoW+49+SQT637oJEG2oSco5aYBH+w4C1OSzI4JLEiy9dMatN5Le/hNEkK17XMTZhaG4dJ36TzuVLO+DejhLhE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764185345; c=relaxed/simple;
	bh=b0p3wi8GBj+fw0mWBWmogPVwpARnQo4pEbO2QBSZ0HI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PWQrUR7qL7mb8hqyZQgGfSmRVKowVt5bkP0j6iKMXtYfPWRQshpSok90d7Glh52Nxk1YGQ/GL4hCDpui2A3pbQS/n4E8w5XqDj5h5komeUP1lwIu+zbokBT/ftYNHdlWS/1uda1pc8/ACPgfocFqViK5HeK4KP7OiehHb4GN0bE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hqJ9j57X; arc=fail smtp.client-ip=40.93.196.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VUkTlzKBUPBjbsyi1XM/Ldg5j8m8/nHrIIk+hl3bCqKd5mjkZccZ9PtyFeBvCm4EU7s15zwmIJ0OJwFbgUsqDbZj15Ck+9B2ND+J4r7cAlDdyObV+0Vk3XDZkXDrZ33ni+L2QCKRih11gcJNlFPkdemR14cLrd2AK/kie9Y5gdHWiNxacLBXqpE7UYrmTqsVGrremU+HvkZxkRdZUnUZctMUASumKIWfxjzkJO3cw/LveFuMrKZ7gkrHR7kohNZ1+8TbuqcUzjjzwjPVwtj9xRvNsNKUyYpjsfrkEzrhc4oyXhJZp7pDRTmWs9/neCYU96BULldaFvVDiGo7kkMYRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bmd/FucWpId7632iP4376tIwH3LfEJ/HD8Iqn26vVVg=;
 b=pnAY/M5vL6UXBxwVv23ryNWyhJaY0wzcp55IvMAHhEdvmHWR1hxhRt8564nzxOtUlZZI7P/NKbTrGoFo7k/i41/A/ptpQa5kqVR2j1ShN0TV2VPgmvJvVEnFZUV1gUOve4uDoNYAquibGpn6LUpU89nFB7Q5KlaDvXmAN8fe+JlEcWgwhP9AVefQ58VH9vX+F2g5TqS52Mu4k8bFJuz3nG1db8iWHVUwsKftNfz+piV2cE6UboUd+DjwB8eBEulv0lV1fnO/8ncwVvuhU5JJC892lbkshxX+MTiNsuj01YJJdZXyek1RBlHe9FaY5cbwZxtgkXiOittlNIjClE0FbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bmd/FucWpId7632iP4376tIwH3LfEJ/HD8Iqn26vVVg=;
 b=hqJ9j57XNo2jTBjOBxI2gvqbXuYm9LP8XXx8Pi8e9HMwY4OCuzVc0jUkPnbzgJ/okniyP5PmoVDSUqVm1mdaReLzvPHA3r8qkK82pVwWTLO3J93GeLcTCvVFm1vNBf39tjlszyYhjkjS+do5y7QwQXUDR6kmWVsAfuxkZp214lKreef4Vg0CpcYios9X4jvj2o/WmsJYjd/W15ET0ZyRWenvafhfKcBOlWVf8YUU3xCNe21P3Shit+pgMdORGJw9w78rrvnADY4TzGg/w0nOQWKzM4f02kspbWJydEzVfgF7QqL6rtDLRmz+cfbPJ3zeFbDIJvi4TLCVh4RVECRKFw==
Received: from SJ0PR03CA0159.namprd03.prod.outlook.com (2603:10b6:a03:338::14)
 by MW4PR12MB5626.namprd12.prod.outlook.com (2603:10b6:303:169::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Wed, 26 Nov
 2025 19:28:58 +0000
Received: from SJ1PEPF000023D6.namprd21.prod.outlook.com
 (2603:10b6:a03:338:cafe::82) by SJ0PR03CA0159.outlook.office365.com
 (2603:10b6:a03:338::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.11 via Frontend Transport; Wed,
 26 Nov 2025 19:28:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ1PEPF000023D6.mail.protection.outlook.com (10.167.244.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.0 via Frontend Transport; Wed, 26 Nov 2025 19:28:58 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 26 Nov
 2025 11:28:49 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Wed, 26 Nov 2025 11:28:48 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Wed, 26 Nov 2025 11:28:48 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@ziepe.ca>, <yishaih@nvidia.com>,
	<skolothumtho@nvidia.com>, <kevin.tian@intel.com>, <alex@shazbot.org>,
	<aniketa@nvidia.com>, <vsethi@nvidia.com>, <mochs@nvidia.com>
CC: <Yunxiang.Li@amd.com>, <yi.l.liu@intel.com>,
	<zhangdongdong@eswincomputing.com>, <avihaih@nvidia.com>,
	<bhelgaas@google.com>, <peterx@redhat.com>, <pstanner@redhat.com>,
	<apopple@nvidia.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<cjia@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <danw@nvidia.com>, <dnigam@nvidia.com>, <kjaju@nvidia.com>
Subject: [PATCH v8 5/6] vfio/nvgrace-gpu: Inform devmem unmapped after reset
Date: Wed, 26 Nov 2025 19:28:45 +0000
Message-ID: <20251126192846.43253-6-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251126192846.43253-1-ankita@nvidia.com>
References: <20251126192846.43253-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D6:EE_|MW4PR12MB5626:EE_
X-MS-Office365-Filtering-Correlation-Id: 65a66b21-cfd4-4851-f4e7-08de2d220be1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IlmdJo0xuTn6Lr1KKB1bnGjBvOQb7iEZtRK536VBHwBb6C0AsVPokbNxOwrr?=
 =?us-ascii?Q?6+zPcBFMQYAWcRx0yZxmsFSvgMY7qAt/2T6W3nvVxm1wd+vB4qc150UT2iEu?=
 =?us-ascii?Q?qJMw3QKv43+PVcN+OarlZ2fawGBKguL7JhVe2vUT70cJSmWiO79eUeVcsLjv?=
 =?us-ascii?Q?fkKEzOt2UDOX/uTAmgW2MFSS5bGtVypeVto7Pq1nYc0rOhdrxV2ii9ToxTto?=
 =?us-ascii?Q?TT9QHJ8I9VQR2qkhMyn59l/fAp5BJIvIv8XQbjl72nKeMM66FetXGpLJL5vT?=
 =?us-ascii?Q?b28qCEXq34J38Cl3htdt0QID2frZmOZ9ac2+K8ilKKr9assUycY8U69Yks38?=
 =?us-ascii?Q?dTIFwmwbMcwjBv3N2K0BATJGFTPf8I3l2tGD9QafZx9wGceH3unQK8SfLIMg?=
 =?us-ascii?Q?di6JBdlCDYCVLnCj+iTlmzXc8dNxMik5IGDMdrqmY4vMAOGEP89z+ZPTxbyw?=
 =?us-ascii?Q?Acv3lfFfKeSmw5wc1IXBgJZsql8PBEktwDCpv7STVIrM0tzKm4uyMBlSVqsQ?=
 =?us-ascii?Q?c7D4PF9OPKf8f+aI7g8MQRKakfANeDWgG/XV54a7+z9Ftzr+/owiLMgfELr5?=
 =?us-ascii?Q?8Zon9ih8EGgUab0Q/aB+Dm/XcZqIRPrLQdrmWWH+/w9pEOne/Sd6Xk/azLyV?=
 =?us-ascii?Q?167Ns/LfU6TvRXr8GHbVPI7eJdIOkP5+mFOVaoX+/2Iubl2ITTt2sieMMLQo?=
 =?us-ascii?Q?KH4uailUa+/5DcfbVzUijLCkzApnaWbUinw7ag5Qrfx6apWap3FqB0h624Z/?=
 =?us-ascii?Q?3o8GlK50Sa2UUlinUiq7IcggHG461EWzF8x6/W882wSpXWdlHpjkEBP0CI8M?=
 =?us-ascii?Q?T/9/w1m87FLVzbmkmTimdK+xyC/BQyBj3R72OdTTIw37HzDL06f80Z+eywl6?=
 =?us-ascii?Q?l27kBWh+PU7FgUxTH3/E7JJA40eGM2FX85TAPy9EjnwrkGr/2rkAMirf/Hrk?=
 =?us-ascii?Q?HmkPmXvvt0b1+wFMZv5zAtOst/AVMwLK3d+uQmowWTJyMwStix2OI7FTA8i7?=
 =?us-ascii?Q?Ru1s0mjrFXCWIyt9I2QPKy0M6VsmBOZ7Apn3/nvpxMm9ppkhhqLylG/6CngT?=
 =?us-ascii?Q?lfAQ5J822BpLSOF9AssX2ZdVnULkaycBJNThz3Yl34uBXGFjs1mnYFiP4HTD?=
 =?us-ascii?Q?Dq9Rm4u98B41dw96DyighlkDmIIzhdsKTa7lrYrAq+ALRjiNQiqyUmSWKNiu?=
 =?us-ascii?Q?F5qgNRIESLjxg7r/gC82xQbPjVgojEpf31mgw10EJK9cb1BUBCPpICeHJ76G?=
 =?us-ascii?Q?1w7+cTWG3N8CpOKumJszdHUds6Wfb+GRYBY+prJNA2LIidCbNDD451ZRQ3/i?=
 =?us-ascii?Q?OEONvSp+BQ8cHlxgnNg1WK2Q0t7kIaWV+ybi/Jk40BZZyjF4pji8ocivkhup?=
 =?us-ascii?Q?Ifujbk6ctps/OeUlZ0oTo5T+6AsH0k8AesWNzPSphjaBU0vIrh+lr29BQTVz?=
 =?us-ascii?Q?bZIDtBn6NzZ9a/0vO6jVBgc3XScM4GLFWv16C+tNzVusM6eblWd+kbO2wl5c?=
 =?us-ascii?Q?N0gzOon7WG4umoSa6YT44U0Nw3nl2hHEnYOMDTnWdVo8vy5aDkKdkznVJ4w4?=
 =?us-ascii?Q?+r+slF1FWpKR6dnYVwM=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 19:28:58.4517
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 65a66b21-cfd4-4851-f4e7-08de2d220be1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D6.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5626

From: Ankit Agrawal <ankita@nvidia.com>

Introduce a new flag reset_done to notify that the GPU has just
been reset and the mapping to the GPU memory is zapped.

Implement the reset_done handler to set this new variable. It
will be used later in the patches to wait for the GPU memory
to be ready before doing any mapping or access.

Cc: Jason Gunthorpe <jgg@ziepe.ca>
Reviewed-by: Shameer Kolothum <skolothumtho@nvidia.com>
Suggested-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index 059ac599dc71..bf0a3b65c72e 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -58,6 +58,8 @@ struct nvgrace_gpu_pci_core_device {
 	/* Lock to control device memory kernel mapping */
 	struct mutex remap_lock;
 	bool has_mig_hw_bug;
+	/* GPU has just been reset */
+	bool reset_done;
 };
 
 static void nvgrace_gpu_init_fake_bar_emu_regs(struct vfio_device *core_vdev)
@@ -1044,12 +1046,34 @@ static const struct pci_device_id nvgrace_gpu_vfio_pci_table[] = {
 
 MODULE_DEVICE_TABLE(pci, nvgrace_gpu_vfio_pci_table);
 
+/*
+ * The GPU reset is required to be serialized against the *first* mapping
+ * faults and read/writes accesses to prevent potential RAS events logging.
+ *
+ * First fault or access after a reset needs to poll device readiness,
+ * flag that a reset has occurred.
+ */
+static void nvgrace_gpu_vfio_pci_reset_done(struct pci_dev *pdev)
+{
+	struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
+	struct nvgrace_gpu_pci_core_device *nvdev =
+		container_of(core_device, struct nvgrace_gpu_pci_core_device,
+			     core_device);
+
+	nvdev->reset_done = true;
+}
+
+static const struct pci_error_handlers nvgrace_gpu_vfio_pci_err_handlers = {
+	.reset_done = nvgrace_gpu_vfio_pci_reset_done,
+	.error_detected = vfio_pci_core_aer_err_detected,
+};
+
 static struct pci_driver nvgrace_gpu_vfio_pci_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = nvgrace_gpu_vfio_pci_table,
 	.probe = nvgrace_gpu_probe,
 	.remove = nvgrace_gpu_remove,
-	.err_handler = &vfio_pci_core_err_handlers,
+	.err_handler = &nvgrace_gpu_vfio_pci_err_handlers,
 	.driver_managed_dma = true,
 };
 
-- 
2.34.1


