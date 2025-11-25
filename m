Return-Path: <kvm+bounces-64529-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 600ABC8637E
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 18:32:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8ED104E7605
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 17:32:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1669C32C95A;
	Tue, 25 Nov 2025 17:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DzdSPHxG"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012040.outbound.protection.outlook.com [40.93.195.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76A032A3F2;
	Tue, 25 Nov 2025 17:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764091863; cv=fail; b=XXEjLGVRlJQVaPn8AAM5U+oSLXypyWHESFNprYAUoXDG0du4vcC9Rsj0fhzu1JiYAslIYX5ux6ut/4vX3A0lW/ldDieVFRX+cntqXBF9LOw3tXDUkA/A/Ome9gb9rql8aDPiChxq4VAZRXhbFgMb0+7n6nfENuefdjS0VNxPDtQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764091863; c=relaxed/simple;
	bh=VWUtznwwQ4TPOZf9f/DxaKtBxgRaY4uJCDhNMi2nlAI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cwxe9WtmflquT1DRU795NYvZ/p+IbVWSsfOlmGDz2dcpZeZ9r/oU/uHvaA7ivDiuRQ2r2GfqdAFnM9z339cbJSra/1j22MmEIQTdyZ37O9mMlSkFfrMOqCg172nLwOWXeRiE/K2rFnshGZNxfxw/aJvPZTg92JZvVOMd2j/lP2U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DzdSPHxG; arc=fail smtp.client-ip=40.93.195.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NKP+u6t+rXvnf6BVYC1+Z60DD3GhtJbJyQlWxwZewjvL+ZY1vSYYykXpcm1sL4VgIBZoFZq/athUjlHbnr+7oRhA/ek7SSwqSA6b0iuLJb+uOGQ7VupihwgN7lWQnf2XIAfcpy1Q0vmnRJYpSQL/5PcKe40g7MKn4b6dy8vpCQbtl20g+8/4wjxY8bUlnNHadOfSfoWcYtPXSAkF8fji3KWZtfIOQyg7EY62bXky/nAOhQYxwHeZ2Ch9krEP+1OZ25gs75S2ILFziC5rdix/8/2gnk45KakTIax34ccdob2t/K8ePawjLk2EY4Dt8AEaTRYEJf/pganT3fMztJxM5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GC/6JAEm5hpEUJlTksMtISorSug+48FMIZWgByTLsFs=;
 b=GvIzie+qVPZTcdVeNAHc48XP784XGXnNPNCaTZUHG/nSVpLV333lfeqAsP71UW9pi/Msm0ym6Tvg/20R4zkuy4NA/51sjzt3cXMEkD8/hS+esmUhNiBEfxWMNFciWS0mbtQ2s+7QRGJYNxtZY1QptysiPfJ4LIwhdL+vOnXwoFKS2obM+bpegaJ1xeYcdobtgwj149UeTcAXM/wEY1msBgw3EL+AKQNG+4BvcqRHasZ+rBGzKcudI7/DN/1xPy5D2lLrlU6pQ4T7hBbX7qOUHp/0OBnrBpeutC3IysGXtPD9eiUyZ7rg9N8vVefq+jhaexLTRPzno7TE5CSyQ5120Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GC/6JAEm5hpEUJlTksMtISorSug+48FMIZWgByTLsFs=;
 b=DzdSPHxG7okcwb4PicX5jc2XrTN2Sz0VvpSBxMLOgaf6Hqw3YcWsNYvK+ifbC307hQ6uASbTkt/VHpBMd+gkl5R5v2YWb1Shn7fnhgbOtA9uj2bwhkT83sRZWoF2qGm5igAEpcrpGFLnktOoNzAvwJz+Oned7zv0UH0WWkO5ZfV9W71qzUQesf8lNzwCzdw4FCGxcC8FPWHy9zD/DifPtejwIql/2WRpqHmJMpRxJbT0PZ85FAKp5znWYA6ME8a39vUqA7OEmQwbwJv7dBz3FbBauNceH4qnepmAJbzo0Ubq4yYoLKepQGEUpi/NHrUH1piqzGcECSirrq4dhfi5Yw==
Received: from BL1P221CA0010.NAMP221.PROD.OUTLOOK.COM (2603:10b6:208:2c5::14)
 by LV3PR12MB9409.namprd12.prod.outlook.com (2603:10b6:408:21d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Tue, 25 Nov
 2025 17:30:38 +0000
Received: from BL02EPF0001A0FB.namprd03.prod.outlook.com
 (2603:10b6:208:2c5:cafe::4f) by BL1P221CA0010.outlook.office365.com
 (2603:10b6:208:2c5::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.11 via Frontend Transport; Tue,
 25 Nov 2025 17:30:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL02EPF0001A0FB.mail.protection.outlook.com (10.167.242.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Tue, 25 Nov 2025 17:30:38 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 25 Nov
 2025 09:30:15 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 25 Nov 2025 09:30:14 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Tue, 25 Nov 2025 09:30:14 -0800
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
Subject: [PATCH v6 4/6] vfio/nvgrace-gpu: split the code to wait for GPU ready
Date: Tue, 25 Nov 2025 17:30:11 +0000
Message-ID: <20251125173013.39511-5-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251125173013.39511-1-ankita@nvidia.com>
References: <20251125173013.39511-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FB:EE_|LV3PR12MB9409:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b86e6a9-730c-4ae9-3378-08de2c485967
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|1800799024|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Dco4A6jvd6I6x+tuIzxVkAW1gEchdXoM4DRna6s/iymz5iwhnhBsi7EmWVHh?=
 =?us-ascii?Q?1ZKwaZdE7zyAr8p0WQqW3hoIbaSH71w5NPckWE8RL2OzepnHpTNC6FWbwoMF?=
 =?us-ascii?Q?WVq4KHZb/lypG/72L6RYhmxVQMxX/ChAS4P7dVHqypUmtluLGQj1gElfgqpV?=
 =?us-ascii?Q?3dEAwKdidtCrhRqvxzIKaEHvohueTkAJ7XOETPO+S3EwRgwLcI9I8NS3ZOuH?=
 =?us-ascii?Q?OhV7yhBrSiAElbk1VFvQJ7JhzHL/K0RxhmGm5YEcLWaZgmvF4FQjOiXqsR6c?=
 =?us-ascii?Q?eitqKvduOPu3HPkk7HoRxf+tfJR7J3iKjeH5FjuoyTsxDxNV7CNsejU8HB1j?=
 =?us-ascii?Q?wxRfBu5C0qFRC6IyptNbQAaNzF6QDp7sVDPQVKk73sVTjrysrTKb0hpyOB1K?=
 =?us-ascii?Q?Iws+kC23Scd8wefZ0HvGeB/Hk3q5A64i9EhqnP4BgGRaJAY5j1C+dblfFZSs?=
 =?us-ascii?Q?PWY74rv54GOAal2PGzX1svmMUR+0mdR4ElqcXJs45IbzWJNyH8sjGe5p7Q4k?=
 =?us-ascii?Q?b/aVKy13mh9sOyTrbTDF9yRbo/0YgIWdqSiuP+a4twAPop24D9E85NcsZ1LB?=
 =?us-ascii?Q?6Iv54Zjz/Wj78eKCAO+5RS2naf9XjXhy+7NuZalx1lpHIWHfeS2jp6rf4yYb?=
 =?us-ascii?Q?bGHEujMZtFmNaVaWYJjoki4ePSga+PORf9Wpqvq0ds4r17+J7ZfaveG59+0R?=
 =?us-ascii?Q?iCrLTNgO3mjgyk+5Zm81Dx5Nt9ivphOj5hZsdTYBRZ6zKyhp5deNPPzULUXT?=
 =?us-ascii?Q?t/Evm/g2rpocXsnOW8djWuDYoOF0JWsqQJuvz7URIfhSSuqv1xhDQ0GA5iw3?=
 =?us-ascii?Q?pG1DQ4ESQRdrK13ucRGYfol8+6NCqpR/7Hbcw4gkLus0DhJn2ZoceX/gnq4H?=
 =?us-ascii?Q?jad/pVV8SM+kAYHjSv94MXWNk6qJnws/3ypBgtjZ4hR7bJuiZnL4jyjpjnmP?=
 =?us-ascii?Q?3jtSw2V9+1LeqpJtn00wjXInaDXNI00afgzt9LIjY55hTCXA2q2stqghUXtw?=
 =?us-ascii?Q?b8UwuSLpv0ttncPiaaV5kkFdESFCrFNwCJXBtSEqzLASdmagrDUtbUuD9xMA?=
 =?us-ascii?Q?6kJPuYaGka1TEW4XGNc64hoVnEaj7gYgSpoLTWULqyYV7wCRaWUAFb7kyKZR?=
 =?us-ascii?Q?WKa9uIiL9GGwD75Lf6CWPSq7PSL0eZUDJyvq96m9PFis9VDfPhJBBUVbdlYm?=
 =?us-ascii?Q?/HmxH/xvfoL+2vQvNMxRnPKPpX4YqIUxfuFXXcCSqWjVPVk1MIZcNA8qFeGf?=
 =?us-ascii?Q?LWb7eGrp+bY391G8hWTgyWxN6Ts242z3jlxc2r1xIhKA6C9GkXAyG3LePace?=
 =?us-ascii?Q?2oMqFpnIl33kQkn4TTrzga9AnGgLWSNqJ3ffTx1s2tiMwdFspTvaozRq8Axc?=
 =?us-ascii?Q?fjdoaZPg8emXMFxAg1wAslDn21SUzcH9Tnq5pwfdapi9p8WdH8B5k/I9HgxU?=
 =?us-ascii?Q?rGrWov0Z7cpjUxzKdx9V1GE3N5XURPS1TRENvv94HF9AyvPEAixQEyRaRy2X?=
 =?us-ascii?Q?RwJgp3Nj8mQIOlqjj6q3rQO+YG8wlx9hFvubMNbrB/+hWaRyhVfkTlwQjj1C?=
 =?us-ascii?Q?UYZH8a20EB8wPtu45c4=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(1800799024)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2025 17:30:38.1198
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b86e6a9-730c-4ae9-3378-08de2c485967
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FB.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9409

From: Ankit Agrawal <ankita@nvidia.com>

Split the function that check for the GPU device being ready on
the probe.

Move the code to wait for the GPU to be ready through BAR0 register
reads to a separate function. This would help reuse the code.

Reviewed-by: Shameer Kolothum <skolothumtho@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index 8a982310b188..2b736cb82f38 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -130,6 +130,20 @@ static void nvgrace_gpu_close_device(struct vfio_device *core_vdev)
 	vfio_pci_core_close_device(core_vdev);
 }
 
+static int nvgrace_gpu_wait_device_ready(void __iomem *io)
+{
+	unsigned long timeout = jiffies + msecs_to_jiffies(POLL_TIMEOUT_MS);
+
+	do {
+		if ((ioread32(io + C2C_LINK_BAR0_OFFSET) == STATUS_READY) &&
+		    (ioread32(io + HBM_TRAINING_BAR0_OFFSET) == STATUS_READY))
+			return 0;
+		msleep(POLL_QUANTUM_MS);
+	} while (!time_after(jiffies, timeout));
+
+	return -ETIME;
+}
+
 static unsigned long addr_to_pgoff(struct vm_area_struct *vma,
 				   unsigned long addr)
 {
@@ -933,9 +947,8 @@ static bool nvgrace_gpu_has_mig_hw_bug(struct pci_dev *pdev)
  * Ensure that the BAR0 region is enabled before accessing the
  * registers.
  */
-static int nvgrace_gpu_wait_device_ready(struct pci_dev *pdev)
+static int nvgrace_gpu_probe_check_device_ready(struct pci_dev *pdev)
 {
-	unsigned long timeout = jiffies + msecs_to_jiffies(POLL_TIMEOUT_MS);
 	void __iomem *io;
 	int ret = -ETIME;
 
@@ -953,16 +966,8 @@ static int nvgrace_gpu_wait_device_ready(struct pci_dev *pdev)
 		goto iomap_exit;
 	}
 
-	do {
-		if ((ioread32(io + C2C_LINK_BAR0_OFFSET) == STATUS_READY) &&
-		    (ioread32(io + HBM_TRAINING_BAR0_OFFSET) == STATUS_READY)) {
-			ret = 0;
-			goto reg_check_exit;
-		}
-		msleep(POLL_QUANTUM_MS);
-	} while (!time_after(jiffies, timeout));
+	ret = nvgrace_gpu_wait_device_ready(io);
 
-reg_check_exit:
 	pci_iounmap(pdev, io);
 iomap_exit:
 	pci_release_selected_regions(pdev, 1 << 0);
@@ -979,7 +984,7 @@ static int nvgrace_gpu_probe(struct pci_dev *pdev,
 	u64 memphys, memlength;
 	int ret;
 
-	ret = nvgrace_gpu_wait_device_ready(pdev);
+	ret = nvgrace_gpu_probe_check_device_ready(pdev);
 	if (ret)
 		return ret;
 
-- 
2.34.1


