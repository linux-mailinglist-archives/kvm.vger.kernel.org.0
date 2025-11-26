Return-Path: <kvm+bounces-64602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7326AC88261
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 06:28:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59EFE3B53C1
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 05:27:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45B493195FC;
	Wed, 26 Nov 2025 05:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jeRa/acd"
X-Original-To: kvm@vger.kernel.org
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012070.outbound.protection.outlook.com [40.107.200.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB9C31690E;
	Wed, 26 Nov 2025 05:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764134808; cv=fail; b=Coq1eV25CO5Ua2CExUvpAjajyX5xWm5pR5Zib5p0RSawi+dK+CiJch9AYyWr9SYaCEsljs23+xFoi79Olx+GyFRwfKj3sYfxZaFrdZbCuOCxltCAeepFj/IKU4U+tGGnoHdAWC0l1Ilq9jmf5q+YVuN5hSpkMAurstre7FaZWnA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764134808; c=relaxed/simple;
	bh=un7F5tqJ9y+GixGbNE+XnaPeFGQuuCMG8Jn76uuHSyg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KXucV+NOcxanzgluRjQAHiFxW/bRjkILkfSKrUB6/e/UYf2y+X5DQm9CqBwdExJdsIaqlV+Ay2q/OmjVONkjXzN+V5ApWJ0JqXLqtl1kR6tSuJjgTeD90qUY+3pgL8Q+fW8B81EXoYUrHWYexzviq44M/u5XTYuhonzcsldU9m0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jeRa/acd; arc=fail smtp.client-ip=40.107.200.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=knDMqxMXNVwIYIZjKPvbJdZSczfTg37i12bH1ZfxanSOj6GYoqa0u6/cEXoMua15vzG1AAXB1O8Xl8P2sOqwLYw56GdKNPEI4zL6atekSH0hNrz1UhfyRxoUm0RbmnhxIsuNC/T5w8BGSA9XfuFd50M8hfYuvaiLxJ6DwwcDE4zlZKQDzArhRS7QMVf+oyNk/qUF2vg5z599dzehABVd6tVRBmpD707UR+bPPlkTfxc7yEZ0AXcirIw8pabU/2KBx66rA9N7EkKGvKLElthy4zIofiZSDh8RKEvr+r7inbYN3Uamli97XQKdWtJdMJdwQkQl94ojdJX9NtIsLnI5ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e34IgOv5EC8e8+si/b+QVFRQs/uJawYIjvvOOpHLfE4=;
 b=T7QkaT+gODhV9+PNZXt9nmcbATpWoi/v2Jj5+i2x9RpWp2DG7SKQcU+4yKBvRy0QvHMGLNaqNeyB9z0T4VaXd01m4te8jENeKnZeC0Uhv/hgaicRALJenJrACNhf+Z1GU2Lmrf7FGA/uucXv+HQo0c7312zrnzqF4k1NG8Hh65cw88aIO42jJVRDtXh2oWd3Y0Bk5U5zuN1j4Ov6JROqc0gOu2SgxZkVc8bHQnlmO15WaI8hADAYei1ERdePR/3wJzs1Drl/vKWdxwVdklXCuU+IE/XlAJk5lJN07ZkN4t8XaudallkESHEOmltIJUVEOMWRI5sttF8CfDxakxx0fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e34IgOv5EC8e8+si/b+QVFRQs/uJawYIjvvOOpHLfE4=;
 b=jeRa/acdImCjpW7JRT5vBuNH1hPNPnJQWbuugu2ZRsEXqLPbUiSIaU7dYzhwe0RZQtcvJ8zEBoJu3w98l++vdF59BugSU7YvGJVfsNDNry09YsP6YgOOLyxr5SgPz7m2GqSUZ0TCbstR2I4L6nzz2cVHowUtlQQFqd7VEqWiGnwugY6k0AcfIadH3bowIkYGMCEB6YCDYI7TbNp0XQ2eLBx4kLMPcs2qsKz+hK7eDps9xk4Gv19sfG+CHamnx8aGdVyxHyjng7Owv2vKyLYsmcepC2z72t0aA6Cng0IXmJVLfNByYGyRwL2iEi0twX6ttBXZuPetH/85sqsrhgZ/iw==
Received: from SJ0PR13CA0054.namprd13.prod.outlook.com (2603:10b6:a03:2c2::29)
 by BL3PR12MB6644.namprd12.prod.outlook.com (2603:10b6:208:3b1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.12; Wed, 26 Nov
 2025 05:26:40 +0000
Received: from BY1PEPF0001AE17.namprd04.prod.outlook.com
 (2603:10b6:a03:2c2:cafe::1d) by SJ0PR13CA0054.outlook.office365.com
 (2603:10b6:a03:2c2::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.11 via Frontend Transport; Wed,
 26 Nov 2025 05:26:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BY1PEPF0001AE17.mail.protection.outlook.com (10.167.242.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Wed, 26 Nov 2025 05:26:40 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 25 Nov
 2025 21:26:29 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 25 Nov 2025 21:26:29 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Tue, 25 Nov 2025 21:26:29 -0800
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
Subject: [PATCH v7 5/6] vfio/nvgrace-gpu: Inform devmem unmapped after reset
Date: Wed, 26 Nov 2025 05:26:26 +0000
Message-ID: <20251126052627.43335-6-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251126052627.43335-1-ankita@nvidia.com>
References: <20251126052627.43335-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BY1PEPF0001AE17:EE_|BL3PR12MB6644:EE_
X-MS-Office365-Filtering-Correlation-Id: da328c88-db5b-44fd-3154-08de2cac60b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2w8XS0DboTNz1QPpjOBMB2ze0Ps2rUmgz34DUAnN5+H9rCT7zWTlL6ozfxyA?=
 =?us-ascii?Q?EeMkLrWGdHhjWO6/ZWS2sZTfMGuLbALZbDiPaQpRWmT3DhUal6bagQf61hoE?=
 =?us-ascii?Q?M8ZK9CaWwvviVsFLAaXYVbTn1xrFxBpQqmen8h0cbP/HqisgsrSiPaeMN3Fm?=
 =?us-ascii?Q?RH+YPE1YKLq1HOxUFHx3vD0VgFEqHVUk/7W8/f8uLCiLHWzL94YvPSUJyq+I?=
 =?us-ascii?Q?+kjXLUXJiwDcceP2vQEUMOwViYg0AT8PHzmynrHaBP+lst62YulkKBDrKwk0?=
 =?us-ascii?Q?sMXymuwhdKOOz2mv6zt2U8MrKF7Unf+dof63Un5g84bQFhfkgZQOoYf5yRyG?=
 =?us-ascii?Q?yQf5nALsqT1d4E8jpFROUhjBWPYTlhMFh7ECtTNNdJP89vvGMF/2IpG37Wmd?=
 =?us-ascii?Q?qoKQnMlFxDk08cYX7Fs+MaByG0BESvMZEKAXG5eHAQBRRmJAt1YuAmLEUoq8?=
 =?us-ascii?Q?Y/bD4V39+qNxAihWNjHuWhUfiiN8xaGBu+RpiU3heGl9ZG7WkCy006lUDm2N?=
 =?us-ascii?Q?FPDcKvoutryJyPigECjs3Gw3bsvdzMwuO80cDRsLlN1mXnpIvFBSfqcpPCH+?=
 =?us-ascii?Q?1aqgoauCG/TDvfreq3LFNYXUFSRPytslhX6lRZGAQ4mXobkgWJZyn3+pijRp?=
 =?us-ascii?Q?Y5CNolVEwTBpaPyxiLkwn68I0A1Th+KuiO7aPBFEaKyzVzQi2To22ssQyv75?=
 =?us-ascii?Q?x524aaA9tdDSVuCCpUVZSM+rmPM+Q+upWlK+zjD4iKKxnRiNDXtGuVdZ4vxm?=
 =?us-ascii?Q?G+JGSVANdjEQ5XIeYjJaU/k00NAalcey4Wo2Aageem8UZddaVpJj5EXeoL3E?=
 =?us-ascii?Q?IJrEIs2DPESZwPR64z2Z7cn3TJFNUQIouXhLo3+5V4tkPN2DaDeH1TfdW0r+?=
 =?us-ascii?Q?+ss/MV8gjUJI57yiSVh7Uex3WtNTVwPlM24fpswup+xgwWr7u9x0M0A/1bIp?=
 =?us-ascii?Q?6up/zY9V0lS7U1ttCBSNA+lnQY7rj5aFTpCTx4wfzUOxJz+hb08akZ5nkLOU?=
 =?us-ascii?Q?+JRUCapV0rZiEneoTXHPsbBPeyi7OpSUYahBAEG7156uroosdA8vqtLJAbcl?=
 =?us-ascii?Q?vMqg7/rDb6FxNH0GMf+ljm+RRcZNOXuYgKTBkj+3JTiUpT+WSgszp1fKcicg?=
 =?us-ascii?Q?7xhj7D0yer6Yu2SnX9ts1nlOIvlPzxB0/IVJg5+dzLjBMu+QzqofXUWi82tv?=
 =?us-ascii?Q?qTF1xxLzkcs15x2S/DZfjb6raha3i0Y6obWhf0kOPaLS/gtsFZ5/ONyuqxUJ?=
 =?us-ascii?Q?Np9l858UP5L9lNilcF1Y78upR3fjQx3ehbo7DKD82o2M8XOgp99YmcADfZJG?=
 =?us-ascii?Q?9PZDKy1nXCDCtHHUrIzMa3eIE74AWcB5Qbvc7IWfY7WCgyNj4K3YnhklGzMd?=
 =?us-ascii?Q?Y2TBYp5LSadnEF5cMIxsql4p4qP89qRhePEB2dNQK69pwfcDIRDLyFaT2tzu?=
 =?us-ascii?Q?5sk+S+5Om0juvEpv69NLLMNmZPK0qSA3zZ0VMgIruNqw3bwUlEL2lOQCL2pf?=
 =?us-ascii?Q?zuKWQM9T3arcHmlEKcKz5PlNKSb/8+Szp4zBkYH186lFC+TD+Mbt6Goyx0Ih?=
 =?us-ascii?Q?8t/dTvmTcVR8bMa8SrY=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 05:26:40.1368
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: da328c88-db5b-44fd-3154-08de2cac60b3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF0001AE17.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6644

From: Ankit Agrawal <ankita@nvidia.com>

Introduce a new flag reset_done to notify that the GPU has just
been reset and the mapping to the GPU memory is zapped.

Implement the reset_done handler to set this new variable. It
will be used later in the patches to wait for the GPU memory
to be ready before doing any mapping or access.

Cc: Jason Gunthorpe <jgg@ziepe.ca>
Suggested-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index f691deb8e43c..b46984e76be7 100644
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
@@ -1048,12 +1050,34 @@ static const struct pci_device_id nvgrace_gpu_vfio_pci_table[] = {
 
 MODULE_DEVICE_TABLE(pci, nvgrace_gpu_vfio_pci_table);
 
+/*
+ * The GPU reset is required to be serialized against the *first* mapping
+ * faults and read/writes accesses to prevent potential RAS events logging.
+ *
+ * The reset_done implementation is triggered on every reset and is used
+ * set the reset_done variable that assists in achieving the serialization.
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


