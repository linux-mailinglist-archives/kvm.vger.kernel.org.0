Return-Path: <kvm+bounces-64603-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CEB03C8826D
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 06:28:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA8CA3B13A8
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 05:28:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08BAA31A545;
	Wed, 26 Nov 2025 05:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ev/Wfiuv"
X-Original-To: kvm@vger.kernel.org
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011047.outbound.protection.outlook.com [52.101.52.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52AD63191B5;
	Wed, 26 Nov 2025 05:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764134810; cv=fail; b=OFx751Sg4LA095/WXsZOAKIU0iJQsVujtPkgikDzsDX2BZ82H19wXOIdXBuXgb1PmFooo4ugjC6+al1+5Is0FPzR8mp9ia6no+zvZyXoHdlFu7E3O5dOWIS7IRxJlxWUVYFjdyC/tr1qBCDANQ5i1U2aFNFLEQwG2j5easQ3ZqY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764134810; c=relaxed/simple;
	bh=w+D/XfyvzyQZQv0dLJFK8Adm2mtz6DWZxgEoXxTjy6o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=drP4rM6dYVNZtdY0JgfqoPnkQTsa4ahs1cLZ5fJkefNAmr45N1BEqg/N9wDNsSuRUZL1z2Mbi3JrfZfIxehcU3AlEdXOg2SIjVNn/RDAP2H1RRvJjgsQ11cSCoVjJLQJi/GVjFQ6W3mvXKeLbI3cFLn43v2OIlShq2xCZjb1Nx8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ev/Wfiuv; arc=fail smtp.client-ip=52.101.52.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LKKqB97NLzLji8MeDT/CvWGni+h4Z/Z8p6I2OFrkgdTw5MtA+2JJFGIr5Jzzog8nnawbp7CBjf/3CTpydVIw8VKcPmsXNlPCChPACM/YR5a0dgE39m8tSmAMUvG2lGXAquijTjxUdvRPXWE2Zj59Igvq2FykRvqeQ3PzS/wldZFbb59eVhaz5jc4WxPyrGY1BT3D3CnUu3LSwjVxMz0E7UbgzxDSLuVvRJhkGjSKy4182R27h80/BlA//yWhOunA0Jfo7JYbti8EBGupPP1wgm4P+FkHBCDXRBlnAWMY+EYuz8QmUc4eoebISMH5A1vPGAvoW7aUzeZ0Zq+0JEHHZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zu941IOujL0zw6PpeRqc65+DJIaxyIV0rBM8SvvWQ6I=;
 b=WrIYdfsVUsJ8y+Lm5Nwe6IdfQPDj621N/10x0DD2UNEdBzgMgSy27CENiQ0j8BhRsi5Sr1WWB3WaKO+Z85juoy9BlVrkhHZlaqQxUDyLVRw/mUuMCPV7WBhGRquTfFEuvlMnvTgG7HnMcaUrcpCtFM3ea+I3VN9e810QOw+wumHF+LaWMn+Lj/jpXNrXQsvWCyyBS1mK/uK3T++AiLeEyIhNDz8NLdq7ptn5pHYrPGhyw/s9R0RmwbmoxiuFEsyIssprNqK1vG/doIxnRgQv+i49YZIro2r40RTaQb1ZZmBdCe+pL0R5092WE5fOb7pqmAEuJvlI8Q57xLlFuEQK+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zu941IOujL0zw6PpeRqc65+DJIaxyIV0rBM8SvvWQ6I=;
 b=ev/WfiuvKPTNXk5wYdX84y+YSpI+nKQpgidFXASg6dPIvFIWYXi7n0RKGHwmxztY5ThHlQBuGjBGz/+dX0leR8Gtt25Xb+gekzZsBqcycaCmYiSp/iRbwI3KKc6JcEpWTcmh9ZgjpWnoEBpXJ92sbEtK8VP4Ti7XlnA40eV6yAxPY/fAHtE43as3KcWRGsqx/3+4a7uFmFMVuN2mPOxfYn/wLy1PTkWXCiq2Wx5zM4RfcY4wRo0xyyKFD1kxVWEFtVIOEFT16h0sjHXxh0GQO1HU9pMHQVm0IRlvJXBDie3Z+diS8Hhcp8twON90Z0B5Uo9vrcuOU7tAoWcezGE+kw==
Received: from SN1PR12CA0067.namprd12.prod.outlook.com (2603:10b6:802:20::38)
 by BN7PPF8FCE094C0.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6d8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.12; Wed, 26 Nov
 2025 05:26:43 +0000
Received: from SA2PEPF000015CA.namprd03.prod.outlook.com
 (2603:10b6:802:20:cafe::2e) by SN1PR12CA0067.outlook.office365.com
 (2603:10b6:802:20::38) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.12 via Frontend Transport; Wed,
 26 Nov 2025 05:26:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SA2PEPF000015CA.mail.protection.outlook.com (10.167.241.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Wed, 26 Nov 2025 05:26:43 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 25 Nov
 2025 21:26:29 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 25 Nov 2025 21:26:28 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Tue, 25 Nov 2025 21:26:28 -0800
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
Subject: [PATCH v7 4/6] vfio/nvgrace-gpu: split the code to wait for GPU ready
Date: Wed, 26 Nov 2025 05:26:25 +0000
Message-ID: <20251126052627.43335-5-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF000015CA:EE_|BN7PPF8FCE094C0:EE_
X-MS-Office365-Filtering-Correlation-Id: 341d6ed3-6c27-4079-56a9-08de2cac6292
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XfI00525bUvauKKqXPvD0cS7JATL0GZa1IVAXp8aqAzUP/ZFbuRwxjzu5ZQj?=
 =?us-ascii?Q?TMQXBcrNx19WVrcIXhqXBVlWWZ7Vs/OxMe/BouQ195aLnnjflPyJDfwEhLwh?=
 =?us-ascii?Q?ml8lqMcRRAtzQ5tP68EQmvOhOMSyiVJ1gE8ntiEczYiDnuEmhsxpJ2Pex5QX?=
 =?us-ascii?Q?heL1eJ4TgIs4WRsF+eVHAYX+4nKeV8+2FkMTGPFGSKj9I+LaxhIu/Cdlklib?=
 =?us-ascii?Q?yvpQ663cKRDPlEZaP1MZhkRA8LqCvtX9gT+1Vvh63nt602bXA5diGOmAFBje?=
 =?us-ascii?Q?4Xa18pDuG9ylrp85C2fJHrpecVtX6VgIWFJac0jwFW8YaNj1CCVeMiKaCdft?=
 =?us-ascii?Q?oWX9641PNLvOI5B637HH59W3c9fpFN4c309olImWD+1vP3PmqB/Zg7sYD5xf?=
 =?us-ascii?Q?KxrCBSjTrNEBUbMbTDP+N25MmKSLN+4EsCWCk6ZIL1s5nq4Hws9rzPRjjMQZ?=
 =?us-ascii?Q?+Y/97nlsqreJMaoOCLh+Y3qO6k1jEmoCmiWAt3ZW5+mCm7Y8hwab8rn+eD9l?=
 =?us-ascii?Q?kOgqslo5CmLxMXB/aoAfkLYnE/SOFvk44sDat9xoM0PSDGzvVFVc1tZFNoVh?=
 =?us-ascii?Q?LLi6cnO9yScB8Tu1a81Kc/sT4FT1XIWnaFNVqaou69x/EqdFlP8FD0ZSkIj/?=
 =?us-ascii?Q?ZvjA/XdWfrk3siCKV5/YL3HWBnDe7YFZQXxiQUG8yPgGRZWeAeMExhKxXhiL?=
 =?us-ascii?Q?Do/1NhhbkMstXbcjNG8RL2X6mL8Lfd4sarXw/HFCyA6B0+lINimSIn3Lyq54?=
 =?us-ascii?Q?G44FvPBspkM89Eof04K8mZ0ScPWiUivs4PUTxbK5RfGFFVKC2nrL/AgTLZlD?=
 =?us-ascii?Q?eGO4pcqBLd9MEdbWpalzmzv1WnA8NR3Dns6u1AncizTdFlbuwO87eMf6DJcC?=
 =?us-ascii?Q?/GoJoZurmcf0X889E+m6DRb4th0uIKS8uaXv7QNlxImfj1/lsyOOLMAqd0Ep?=
 =?us-ascii?Q?jz9hT1Fqqh9cPG/fjhulTYffBycwSNirLNkdU2Ge3+LvzCit60KLifsC12Aj?=
 =?us-ascii?Q?NwQATcT3Lh2gB4UNMV7BfQT/h6Sus1zFZAAvbyx/I/rJcmYr3fGlkPleKXNL?=
 =?us-ascii?Q?GP6391x/fUMMTQrct3VAAdmhoikGZ24KnhiVIIxjtZxzXDe3Z7ckTZXousj7?=
 =?us-ascii?Q?8l482YSyAk8l5o8+OSETBtSiLn5w38c6WOONvlNU5i45PPV/hdamJqXGdmEP?=
 =?us-ascii?Q?+IL72sPObKf8BBKc3j9o9214lr8UV/JSqAdyy6h3T9S2S124pGxhKyGeuTaY?=
 =?us-ascii?Q?6H1Y52BAFQ8Vmq3XYA6lB2guhhKYt0/5e6cF74eLtA4BxGUY09LRRNvXB5Pl?=
 =?us-ascii?Q?bFjvTalLVG1BKkJW3Aa7NZ7rKX1SJWhIwxD8DuMZsng8uzXLvqF8xJ2Vsm+r?=
 =?us-ascii?Q?m5whLjk+Q7Av1geNYC35zQVYZ1tr14E8p7mpxIYEaOlI7iVUKRQf0aQNgFxc?=
 =?us-ascii?Q?WmhF7aMAhBxi7dgIp2oLhCAAC/AKzixtZA9Sb1Amag82nTnR8rfqRZQ7fTNZ?=
 =?us-ascii?Q?RyVJGgEArShfxbRaH2a+gYGXFOAQfSgmFSrMLPdMIvi78jL0hSj8gVaN04jp?=
 =?us-ascii?Q?fruAiONr4QBbMh/te4A=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 05:26:43.1328
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 341d6ed3-6c27-4079-56a9-08de2cac6292
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015CA.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPF8FCE094C0

From: Ankit Agrawal <ankita@nvidia.com>

Split the function that check for the GPU device being ready on
the probe.

Move the code to wait for the GPU to be ready through BAR0 register
reads to a separate function. This would help reuse the code.

This also fixes a bug where the return status in case of timeout
gets overridden by return from pci_enable_device. With the fix,
a timeout generate an error as initially intended.

Fixes: d85f69d520e6 ("vfio/nvgrace-gpu: Check the HBM training and C2C link status")

Reviewed-by: Zhi Wang <zhiw@nvidia.com>
Reviewed-by: Shameer Kolothum <skolothumtho@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/nvgrace-gpu/main.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
index ac9551b9e4b6..f691deb8e43c 100644
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
@@ -934,9 +948,8 @@ static bool nvgrace_gpu_has_mig_hw_bug(struct pci_dev *pdev)
  * Ensure that the BAR0 region is enabled before accessing the
  * registers.
  */
-static int nvgrace_gpu_wait_device_ready(struct pci_dev *pdev)
+static int nvgrace_gpu_probe_check_device_ready(struct pci_dev *pdev)
 {
-	unsigned long timeout = jiffies + msecs_to_jiffies(POLL_TIMEOUT_MS);
 	void __iomem *io;
 	int ret = -ETIME;
 
@@ -954,16 +967,8 @@ static int nvgrace_gpu_wait_device_ready(struct pci_dev *pdev)
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
@@ -980,7 +985,7 @@ static int nvgrace_gpu_probe(struct pci_dev *pdev,
 	u64 memphys, memlength;
 	int ret;
 
-	ret = nvgrace_gpu_wait_device_ready(pdev);
+	ret = nvgrace_gpu_probe_check_device_ready(pdev);
 	if (ret)
 		return ret;
 
-- 
2.34.1


