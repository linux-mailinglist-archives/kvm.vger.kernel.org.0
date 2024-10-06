Return-Path: <kvm+bounces-28034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F2790991DD6
	for <lists+kvm@lfdr.de>; Sun,  6 Oct 2024 12:29:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 20B011C212CA
	for <lists+kvm@lfdr.de>; Sun,  6 Oct 2024 10:29:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 405BF17ADE3;
	Sun,  6 Oct 2024 10:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rhHji62F"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2080.outbound.protection.outlook.com [40.107.237.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C316217921D;
	Sun,  6 Oct 2024 10:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728210481; cv=fail; b=neL9yXpH5F6CROdn2hnt0SaKZOwvDiK12mUAoB7mkueo8Ycpxdha29tNb0Zp3ZlkLwMZMgn+o6UIi8x+ZXX7HaGm44Z1BBvfK+9eW56c20QKZwcwiWU8pPb72CyRFVLm2/oRz803rkCUPlEmfHT+fLB7n3GfAApWbWULIC35jQg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728210481; c=relaxed/simple;
	bh=XF5lDtBot0P4pWLf8DwKRI0uudKWxdf3zzws7FUVYEc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mtlxl4MMGtU0qdMEDm6/0ZUn3vu7gx43ME770jxh55+b/jm6GxfuL6Mg890lJPXiiZTuJazOb4kHaUzzMqLcPivgSbMlLrdQYgHB1CZ4s56UbvHW7TlpcJeTYVHOocHjsp22KRj9qm25JTFp/664kAyle39kCo0gEpUMmiI1tfs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rhHji62F; arc=fail smtp.client-ip=40.107.237.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jZx8cu6c2sxl2Gfu4Alryrg5Yim4MTXHhnC14YTgzKdm08fqAccoj09O+wuN85oyM+7/eqYV+ZEaaT4x98FAL9yg+pVRtDBlGhSyYFR6Ks78M4DZusqxur6SLJ90RpLhfnPnuUxtmPMstJhxD/GYjMWFAxA2jaZjO3HzTIEfIlF6xrJPPTpDn6VTdV74YdtoUqj36Wru9r6B3XjgtfQ29md3SSOMl0pEPGFERwQNMcRKKOVdA+AoFAkJDV5O505mBW/0Vrz6HWzKWgSY5uNkj3H9bgzQjDHe3NqzHsRumE7e24QkJ0nfAVh7oyLu31G0jHHRnYfb9s5PFm8iPDbv3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a4mE10onXOhqVJ/p2RjSiijJfYNSPjekABgGum3zBSM=;
 b=d3IzvxQAQw979nsR84IKwZjLIHFpfpTAX1ZyTFernBP8H3pAvBOmogzgmUwQA8NZ4Z5M+nwTmhhLu6R/pV8ub7Ge3qgLrfK+sGrof5x6bwHv2Tg55FIFFE9yrtiZtDeG3QLBKSEgB442GO4q7lgw9pDUVT4NIjErcACLbbFKsAQGj4GsE6J3we8OoOErxnidcVu0GjXJN7CMND1sXGRdMFMncJvSed797dtUmWzoZidZVfo7VnVpIpaTYsyfOPaNBzZa6TTZVVkyly3vKQzMGophaBljPoNBhp8AXlY7ys9+YhX3Bed1N0fskkAHlFODvB3G1LWDdLVknq1VufIwYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a4mE10onXOhqVJ/p2RjSiijJfYNSPjekABgGum3zBSM=;
 b=rhHji62F0DT/TlVqBDgkbDgaHo1VQFsnRcCHMiEyPUZ7b/c+uGPbp5tW+GvYcB1GxXM003j8yUWtxVHPLyCCztX6TxTEysu6mRUfMaqRFtznehqM1Sd4XSFJpuEd1iYBy+1PjiKMSo+mHsG9qS+SHPlhCFqfVHPZUJk2eY16712rTMmkcYDz60HXL02Ioiha+1rnv7imPx+8Mv1CYQbYJ1ft+ELZfliCMuVbDJOY6SinmZK4+Iq3+h8S2VmvQesSVbewOU4OK+wvcGC88I5kgrIhueRfeTTLlq/dVz0dG6CNBY32+CeJb1dR1S054eGfq4VfTuzXML5uzUy57s4dmQ==
Received: from MN2PR10CA0005.namprd10.prod.outlook.com (2603:10b6:208:120::18)
 by CY5PR12MB6107.namprd12.prod.outlook.com (2603:10b6:930:28::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.20; Sun, 6 Oct
 2024 10:27:50 +0000
Received: from BL6PEPF0001AB74.namprd02.prod.outlook.com
 (2603:10b6:208:120:cafe::15) by MN2PR10CA0005.outlook.office365.com
 (2603:10b6:208:120::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.20 via Frontend
 Transport; Sun, 6 Oct 2024 10:27:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL6PEPF0001AB74.mail.protection.outlook.com (10.167.242.167) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8048.13 via Frontend Transport; Sun, 6 Oct 2024 10:27:50 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 6 Oct 2024
 03:27:43 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Sun, 6 Oct 2024 03:27:43 -0700
Received: from localhost.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Sun, 6 Oct 2024 03:27:43 -0700
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<kevin.tian@intel.com>, <zhiw@nvidia.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v1 3/3] vfio/nvgrace-gpu: Check the HBM training and C2C link status
Date: Sun, 6 Oct 2024 10:27:22 +0000
Message-ID: <20241006102722.3991-4-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB74:EE_|CY5PR12MB6107:EE_
X-MS-Office365-Filtering-Correlation-Id: 0aee605c-9baa-42d4-5800-08dce5f18793
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VnTe1ftYKl+8XEB0J76i86qrWkg7SFkC+uKSbDYP7cHpYuqdUDu+AIo0dM3a?=
 =?us-ascii?Q?8RhF2jW/fgUe4RgyLbrj5/iy35S4phvmM5ve0s7jms5yhaIk002wfZRQHuXU?=
 =?us-ascii?Q?eIbAVBSWUgGmcP+jkQWUo/+nqOmLYFzTua0pkOsRnoUwv60b3/yg3AvkyRK9?=
 =?us-ascii?Q?Xpw7X60cQuYbmIC6nypVoG7eiy4pC7xPgWJrZTAd9MZOAOnnKJ3PFhUvcCGE?=
 =?us-ascii?Q?g2QMIQFGLERrE5k3UXgJeqYpB5Bzq3kvl5X+7AQOdmZexjCFTiAsP3fdCozt?=
 =?us-ascii?Q?xmdy7x2Gyj+hVC7U8yKnazgMBg+HgXjzXkURQtMyWMZoOyK+uv69rDsN4eHu?=
 =?us-ascii?Q?OHvtWkIo0p7gV/97xQQRIhqNCRrMS2odPlZUGFdOIwu9rgRCtY9PQvzhjG0u?=
 =?us-ascii?Q?dsvUrzrrXYcGzYA2YK02VWRIqdZcllRQuEvqZHVbkn4F8zQTnLTdHLMAb7bl?=
 =?us-ascii?Q?CuZIzjdRYcOmAoBhQDeGHKp7Q5P5zF2LAvtWH8lKRiDCZJ7cGCxPN+cnDgKH?=
 =?us-ascii?Q?0l32Apf1gvhUxV/HuHIAceX50inO2+CZTAZbIkevwva6ET2g4C0pL3EyKzaH?=
 =?us-ascii?Q?0C/ra76tISVuRfEZt2h2X+RSPwMwhTUVPm6bGQwrzOd/PLQcT/RQy8N/+ul5?=
 =?us-ascii?Q?QJdGNuCLocxzBnuYQnFCdeTMSM+lz9dlE4HxvKT/t4FgRVaeBGQKx3RyxsCj?=
 =?us-ascii?Q?iSNFs9rI+ZuuzDDB+ZcInBYP5jVfJQeq+UBNTJTD30Rfd7Xa/ahpebxVo3Kl?=
 =?us-ascii?Q?TsrM+sIcR+UHkRU5TDhuE4eqgs4P4Ro3zZAzzNO4vbjWKZvkzqjl8+6xvq6z?=
 =?us-ascii?Q?VBEgny1zHHfuCMrmeIw+GlohO9KVVCMNtHl4XKcUpTp2wDpgcPNuBxNYKAcn?=
 =?us-ascii?Q?RlQ0xmBCjiuQy8KpmGUG1O3YzGUfPFZ6A06hlTh6iC/RyG4thW1CkfvUJTps?=
 =?us-ascii?Q?tcpPJ/SHaDpPsClCrPogKRoUNJqtzwKRL3sSvHEddHE4oIY3lCD/Aky1N877?=
 =?us-ascii?Q?fnHt4VhKvSdA74l4u2vwdQ3aEX4601nvK8Pht4V/63bU4Vg8VekuZ6zrjsv6?=
 =?us-ascii?Q?cW3zWqG8M18SlHuakAEQALK5TsKtrccZg40TUWPSbxoXPRnX3sqX9YtIumEg?=
 =?us-ascii?Q?jRYo8Ltnqqfg4faBB/VTMutm2H/Y7rOb0LlVc7AGTbhhPX4XzLlN5is77S/N?=
 =?us-ascii?Q?nwh8ygNPos9q18LTWTdtqNZfYiZXVrfeP7eOK2L/3YKe/yVAseKOaDlFhKCm?=
 =?us-ascii?Q?6LZfk+xgkqcp5YxQ8LR+OJwI377OjoD5vQESr2pNUWT2+W/4rKVrln7PGQJF?=
 =?us-ascii?Q?Rf5YcItIJmAjxaePomADIuDvapLMam19KenX+1Fgd4E1voUOCD2JC8H91Td5?=
 =?us-ascii?Q?EWiaoak=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2024 10:27:50.2196
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0aee605c-9baa-42d4-5800-08dce5f18793
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB74.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6107

From: Ankit Agrawal <ankita@nvidia.com>

In contrast to Grace Hopper systems, the HBM training has been moved
out of the UEFI on the Grace Blackwell systems. This reduces the system
bootup time significantly.

The onus of checking whether the HBM training has completed thus falls
on the module.

The HBM training status can be determined from a BAR0 register.
Similarly, another BAR0 register exposes the status of the CPU-GPU
chip-to-chip (C2C) cache coherent interconnect.

Based on testing, 30s is determined to be sufficient to ensure
initialization completion on all the Grace based systems. Thus poll
these register and check for 30s. If the HBM training is not complete
or if the C2C link is not ready, fail the probe.

While the time is not required on Grace Hopper systems, it is
beneficial to make the check to ensure the device is in an
expected state. Hence keeping it generalized to both the generations.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 53 +++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index e3a7eceb6228..5736d8f8caa3 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -5,6 +5,7 @@
 
 #include <linux/sizes.h>
 #include <linux/vfio_pci_core.h>
+#include <linux/delay.h>
 
 /*
  * The device memory usable to the workloads running in the VM is cached
@@ -28,6 +29,13 @@
 
 #define GPU_CAP_DVSEC_REGISTER 3
 
+#define C2C_LINK_BAR0_OFFSET 0x1498
+#define HBM_TRAINING_BAR0_OFFSET 0x200BC
+#define STATUS_READY 0xFF
+
+#define POLL_QUANTUM_MS 1000
+#define POLL_TIMEOUT_MS (30 * 1000)
+
 /*
  * The state of the two device memory region - resmem and usemem - is
  * saved as struct mem_region.
@@ -848,6 +856,47 @@ static bool nvgrace_gpu_has_mig_hw_bug_fix(struct pci_dev *pdev)
 	return false;
 }
 
+/*
+ * To reduce the system bootup time, the HBM training has
+ * been moved out of the UEFI on the Grace-Blackwell systems.
+ *
+ * The onus of checking whether the HBM training has completed
+ * thus falls on the module. The HBM training status can be
+ * determined from a BAR0 register.
+ *
+ * Similarly, another BAR0 register exposes the status of the
+ * CPU-GPU chip-to-chip (C2C) cache coherent interconnect.
+ *
+ * Poll these register and check for 30s. If the HBM training is
+ * not complete or if the C2C link is not ready, fail the probe.
+ *
+ * While the wait is not required on Grace Hopper systems, it
+ * is beneficial to make the check to ensure the device is in an
+ * expected state.
+ */
+static int nvgrace_gpu_check_device_status(struct pci_dev *pdev)
+{
+	void __iomem *io;
+	int time_elasped;
+
+	io = pci_iomap(pdev, 0, ~0UL);
+	if (!io)
+		return -ENOMEM;
+
+	for (time_elasped = 0; time_elasped < POLL_TIMEOUT_MS;
+	     time_elasped += POLL_QUANTUM_MS) {
+		if ((ioread32(io + C2C_LINK_BAR0_OFFSET) == STATUS_READY) &&
+		    (ioread32(io + HBM_TRAINING_BAR0_OFFSET) == STATUS_READY)) {
+			pci_iounmap(pdev, io);
+			return 0;
+		}
+		msleep(POLL_QUANTUM_MS);
+	}
+
+	pci_iounmap(pdev, io);
+	return -ENODEV;
+}
+
 static int nvgrace_gpu_probe(struct pci_dev *pdev,
 			     const struct pci_device_id *id)
 {
@@ -856,6 +905,10 @@ static int nvgrace_gpu_probe(struct pci_dev *pdev,
 	u64 memphys, memlength;
 	int ret;
 
+	ret = nvgrace_gpu_check_device_status(pdev);
+	if (ret)
+		return ret;
+
 	ret = nvgrace_gpu_fetch_memory_property(pdev, &memphys, &memlength);
 	if (!ret)
 		ops = &nvgrace_gpu_pci_ops;
-- 
2.34.1


