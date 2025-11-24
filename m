Return-Path: <kvm+bounces-64382-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 560C8C805C5
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 13:08:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BDA653AC465
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 12:03:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 611C83043C0;
	Mon, 24 Nov 2025 11:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ebd8k6iW"
X-Original-To: kvm@vger.kernel.org
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012045.outbound.protection.outlook.com [52.101.43.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88037302CDE;
	Mon, 24 Nov 2025 11:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763985590; cv=fail; b=hQHxFwP9CFtZP+amDTIt0UKywHUo+mooSBxesPJUL8PvArJGdZzx3cc9zW+idmaX6MSsHi+y+Iy1aP+FCMOa1Fr/lT853pBT42bXGKCkSMBRWKlfacEEHfV5uFDZ/o4l7R6Iv5nipny+Z8QLP/tfQEHQ5IeHR99Gey1zdCJcgok=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763985590; c=relaxed/simple;
	bh=hsMvkEiZ6HcNIfRpNMUsG6rdy4givnq1Bj6hxFF0dM8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OLdEI756t6cUunfvswoGO1Gwyvy6fhp7awXgWY+vNuMahBO58s01hAaBhzCtcs32Yo39fxFJ0t3l1bbKh8qBPswl+/MVS7Oeco+LXssidxyKp3aolCvGZ9XvZpIg1geM3ipwUTHA8aRaD4sDkYcKKMSlHfSrxsmCc1qzNxP44rg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ebd8k6iW; arc=fail smtp.client-ip=52.101.43.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mg4U9lfHvEECwa04P4x7HM1MId3/cJ6QFpOZrdMago/MYsMXQA4b6oyjs2obBIZ+6wYbJ+9usHJ3oYZDmCMXul+Pe4H76QdL4RSZ3jtbodUjCy2wP5Wj43t4lzJFjQA/YY9AWu88AI/IA2PXBOSQN7ezXmVI9y0SYzNR8blmOrgvj100BJiFjcWmmdz3zxae5WkZHeo3TNfL9j2aqY1ngYVCFpAe9Q+K73hypiwLcb6hlhSUpYoeF5kdDuMeDyh5Cji5L0FQQrXkY+RF3t1114uphdApRuHY9VKVdnofLLgxeam2UdYF92Nz2P4PnElhmn20T2lw7X1NiATce6JsJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2lF9O568PCsBk749MUO+UTq4GK0KrVdMqXo/olGG0Bc=;
 b=SZbFDC+gd0KXxEJClfystc8Tc9N2dC3VProwm/bdtcJY8isKFqmDTXyQpXnBaS/JOuxMS/nL9GO4esyGLiqQ6Y9ZErNKtcyTVEmVURXiETELQx2GLC4+LB0akS83lEVGxB3hUM0gHI/RBsi1Y0unV6i/xw+j0Rs1U2mLC6JQZCxOkqJpgRMIMNztX+uFG3IFW4+1O1X7HsZUG2gkm5Y0azEu/ys0F65DWRiG0sYaSBiNgnAn+SeC9e3OYP7TxspffXhdC2wScbhIZeCPFbj6bhGhcHkVN49ag/+WKpkRGJ+q2+MOSPC/H1MDtVDV023v95p762z4zBAUKxjLY82GZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2lF9O568PCsBk749MUO+UTq4GK0KrVdMqXo/olGG0Bc=;
 b=Ebd8k6iWcAZstD3kUht94ahe61AXvZxSC6PdAF8XPJkIcmrJ09VMkW0h37b4qn7wfTKBcErbURCYYV44PaglZfAcOgUpCWMC+EeDHui2MFDAtVG9baJUz3TzB/akPZywTLsHHbL6Bd+Ec5XMCKj4i0ZRrYEdicJIJs+JBieAqmwl7tF9gtrqLqhljgfA2U+qBPtKmPIN/tbylKzZBkafcFAjJnqs6BlzDyEYnR8o7W+fPTveegzc+8qDUj7W/hh5xpGN3ZhYvA+zABV5dJuT3oyPQEyqnz+HNmNib6MY79nyWT1nEmE+wnFMg90EfiETMhbTaUy9AqPqgAJJbPxVVw==
Received: from BN0PR08CA0025.namprd08.prod.outlook.com (2603:10b6:408:142::10)
 by BL1PR12MB5969.namprd12.prod.outlook.com (2603:10b6:208:398::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 11:59:44 +0000
Received: from BN3PEPF0000B076.namprd04.prod.outlook.com
 (2603:10b6:408:142:cafe::b7) by BN0PR08CA0025.outlook.office365.com
 (2603:10b6:408:142::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.17 via Frontend Transport; Mon,
 24 Nov 2025 11:59:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN3PEPF0000B076.mail.protection.outlook.com (10.167.243.121) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Mon, 24 Nov 2025 11:59:44 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 24 Nov
 2025 03:59:31 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 24 Nov 2025 03:59:30 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Mon, 24 Nov 2025 03:59:30 -0800
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
Subject: [PATCH v5 5/7] vfio/nvgrace-gpu: split the code to wait for GPU ready
Date: Mon, 24 Nov 2025 11:59:24 +0000
Message-ID: <20251124115926.119027-6-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251124115926.119027-1-ankita@nvidia.com>
References: <20251124115926.119027-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B076:EE_|BL1PR12MB5969:EE_
X-MS-Office365-Filtering-Correlation-Id: 3196303d-6402-4c3a-9f05-08de2b50f569
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qNEc/dlv4vgmWlsphnVcX1K46zoZVPGeAgf3bGcHx/awTqMtoMe5rQ6Q2e/8?=
 =?us-ascii?Q?oA8bFzSSapQ9+HQGvLwWjB9fShhACGSX99toYNln3oArGBB6fZ6w2DGGqnlX?=
 =?us-ascii?Q?HXTEUHykgVAHmh3gzxec0IbBBF0vpWEirUwG+HZPQgYcepxZHJMnudgWZIYv?=
 =?us-ascii?Q?WGsvF4K46/f9NV1rW7P/bn+tnl8hq1sNXVawoZJifrU4VaqMl65vXTyz0rfG?=
 =?us-ascii?Q?FXG0BrYhcFx3oYtGFGsPddLInubgak9mEBzG2c1BkY1PX8frlbQhHWpV3TlV?=
 =?us-ascii?Q?K07Rizc26JmWrWOLvT9+thNI63o67Io/4RVfcqlx6zAhjlmSpShcdbvPnwao?=
 =?us-ascii?Q?33TpxRrYr8lpc8Iwt1hTXRRXuKqjuVLE0LN3uwPxB9NcrghFK9xbde86hCOe?=
 =?us-ascii?Q?Y4ZSD2qEc0e/1spj20WY6kA8MmnU8Wrvz2JL48DsKtaV3FzT8MgernbFvrr7?=
 =?us-ascii?Q?OQgu1FTO5Xr+Q4gdKNHFWj6JkXD2bjh2y47+biSwocXt96FQFSCagdJz3aTE?=
 =?us-ascii?Q?B0JWxQMtjaosAZlDsGVHD82EErGu6GQ3Odj+eWFn4gMg6vf6zPV4xnFyw6YK?=
 =?us-ascii?Q?yBPuQ+T7lsq6CTzc5kxmbCtFlfDWGePF0YcOe0tuvAIW+fMS3IJT3kdT2IuX?=
 =?us-ascii?Q?UF9XgHJymKCb97arw7xGdhTysREveFQwDtoJj1yqudX3n6jE8Z8MCb0JJufN?=
 =?us-ascii?Q?IaKHFqix9TkKH5ab4y59jhn81YW6tBU1ddY4e/0fR+o/AS6HzpJtl9Sh4Hy0?=
 =?us-ascii?Q?TPKFDitPbN3GJ0XLkVA+zriP9mVB2PewusK4PTlZ7HWqlaH4DnsdQS/TyVXL?=
 =?us-ascii?Q?RuBxTbaWcqzZRgCqC9ZTkC6KHI5pdupvuS3qjwT1j7xojUpOBojKkJ+Alypk?=
 =?us-ascii?Q?gwzTE9bjnkTGsh89TMDJL4bNweQacCeDtUp0LuqpAH4sYXmDBhEVZ1ip08VO?=
 =?us-ascii?Q?XJfbNWb8ba8EqyY7RMD5JKBt+mDVF6hSt0v5kbIVWVT8K+y8uPdj80wWJ0kb?=
 =?us-ascii?Q?v79NJxHaZilrQ8cCnFgYcgvQ2br/7p2vFld+gtm1CbTXszdLrea11xMCX0s9?=
 =?us-ascii?Q?5PL38lHXLChJcZK4ZtLeuyLoR/vHysXsLdKgRWraCEdcVyM9w13K8fUfvdND?=
 =?us-ascii?Q?bE/B4C9hmY44rVL0QHAVSerybiDnTey7m7i8zhOGSCQVkb6zIDs69sZDJzN7?=
 =?us-ascii?Q?J4Eo2KimlgWFIjHwWC6b+nNTpQnQCXZx9xn0lZ7moCTHa3iGpgasn/BSA1Ks?=
 =?us-ascii?Q?ENTlI1QtndeaQvqceenE+6kBy3DwyDL1T1a6660FkwCQsIKVPAzBym3IluWU?=
 =?us-ascii?Q?UQgk7Am1khAGcLndI9mrwUcY3+g7Q0SzDH+2qZ34pDZNZ6xhqt/RUARAdeOt?=
 =?us-ascii?Q?CYMG7hNk1m0Y9fQgYk2Pq7Ys2m5YuAnGokYqbfD44vLDwONWPNAr6N7bWifB?=
 =?us-ascii?Q?0lBCACowNL0pW6Xh8h00uHCETMRHEBEUfVbJyQzKgXznRSedJz/gVHoVtBSQ?=
 =?us-ascii?Q?HnoYqgU6MvI6zFXP6oCH+N5gh7I59v3ztX7WFWsT4UyxlycA5N8i0KgPBYfr?=
 =?us-ascii?Q?ZNd22/OFRDPPXnBpss0=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 11:59:44.5620
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3196303d-6402-4c3a-9f05-08de2b50f569
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B076.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5969

From: Ankit Agrawal <ankita@nvidia.com>

Split the function that check for the GPU device being ready on
the probe.

Move the code to wait for the GPU to be ready through BAR0 register
reads to a separate function. This would help reuse the code.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 33 ++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index c84c01954c9e..3e45b8bd1a89 100644
--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -130,6 +130,24 @@ static void nvgrace_gpu_close_device(struct vfio_device *core_vdev)
 	vfio_pci_core_close_device(core_vdev);
 }
 
+static int nvgrace_gpu_wait_device_ready(void __iomem *io)
+{
+	unsigned long timeout = jiffies + msecs_to_jiffies(POLL_TIMEOUT_MS);
+	int ret = -ETIME;
+
+	do {
+		if ((ioread32(io + C2C_LINK_BAR0_OFFSET) == STATUS_READY) &&
+		    (ioread32(io + HBM_TRAINING_BAR0_OFFSET) == STATUS_READY)) {
+			ret = 0;
+			goto ready_check_exit;
+		}
+		msleep(POLL_QUANTUM_MS);
+	} while (!time_after(jiffies, timeout));
+
+ready_check_exit:
+	return ret;
+}
+
 static vm_fault_t nvgrace_gpu_vfio_pci_huge_fault(struct vm_fault *vmf,
 						  unsigned int order)
 {
@@ -930,9 +948,8 @@ static bool nvgrace_gpu_has_mig_hw_bug(struct pci_dev *pdev)
  * Ensure that the BAR0 region is enabled before accessing the
  * registers.
  */
-static int nvgrace_gpu_wait_device_ready(struct pci_dev *pdev)
+static int nvgrace_gpu_probe_check_device_ready(struct pci_dev *pdev)
 {
-	unsigned long timeout = jiffies + msecs_to_jiffies(POLL_TIMEOUT_MS);
 	void __iomem *io;
 	int ret = -ETIME;
 
@@ -950,16 +967,8 @@ static int nvgrace_gpu_wait_device_ready(struct pci_dev *pdev)
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
@@ -976,7 +985,7 @@ static int nvgrace_gpu_probe(struct pci_dev *pdev,
 	u64 memphys, memlength;
 	int ret;
 
-	ret = nvgrace_gpu_wait_device_ready(pdev);
+	ret = nvgrace_gpu_probe_check_device_ready(pdev);
 	if (ret)
 		return ret;
 
-- 
2.34.1


