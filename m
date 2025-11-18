Return-Path: <kvm+bounces-63509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A418C6812B
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 08:53:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id CF31B382937
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 07:45:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3215306D4A;
	Tue, 18 Nov 2025 07:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="k0t0WHsA"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011043.outbound.protection.outlook.com [40.93.194.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202223054FB;
	Tue, 18 Nov 2025 07:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763451889; cv=fail; b=lJ6BsCl1LmPq+bAWd5f4dnAEXT2khgiXAAuh2JszbdaBmowMPRn5GYD6eTVHZ/t0aJ7IxQtFre1ul+FxqGETxWrMPWvEziosiDaReYNvsrjicLKCgDN7P5szwqOaUuIaM5I/mTLjvNc7lQao32h8ZV8nJzx8sRaO36jel3eWKT4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763451889; c=relaxed/simple;
	bh=s4HOoPpw+F+uz/UUWetkyfr/GLjgmA2Hy6U7sCP17qM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ObBj4bGwEIb8X7iM4C4t2D2vdLPqSeltoe7QOqc7EN02QxXioBJPCiAvdp2KyyfeyGcoEaLf8GAX+O+A7iJlUm7ckXU+EGOkO3NDDNCHOWROsbSGWgusFiioMBB1Io7k3QKY541HhF2ajBNQmA61ezStdSQn/ydhhTs1TDobMn0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=k0t0WHsA; arc=fail smtp.client-ip=40.93.194.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w2GI5LxEUuJKLNWAQ1vnsg9T3QBd+C7EOv+q7VnrmgyVEDqxke0iHG98Az94pt7WBP6/EpPiWiwUejlc2THSUQHJnl4gNbBGdjrwfENU+E2jMk6wNm7exNcwjoCnjf82Hb8j5T44wWxOC68uQeDrA8xaWAH27ganlX/7qgXn5Hcips07g4QPnbHLFaKW0dlykDtcu2efPC69WehhwZrOyUhyM1CZTw1tS/s7Abphqp60NupgYQ+b5TZJWSCZw1N3erKNUm/U5QaR27vurJiK8iebsZ5Iaos65h6ms8w69kl7C08/hiAKi542HbSdDo6WPBWjS4aJHV04KuxIagEn+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r+jXZfFaj/mBZfU6QapQukJMNEemAubukfYwvP8TYRI=;
 b=tpQzH2vQHeAPevEJDTE2TDLK+9qLmuAigKJ4rnmXv/kfQ7lInnHpchwIOLMkK9MBoP2yBKz7mwpE6FgjK90mGzMpgyZncE9cs3XVTKrfajgLkynjOlFv6uBofGhbpfJpCB1LolQpLIFoWC5WqdABUERFqpK8GwXHigexRy3puxfgBpQrl7+H9fZ7i2bjZ+gbUWgx805J9pzbdekVusIUYZ9RcSR2beBFiarU1JAeSPVX4ahAf/zxx0iRt3di7G1u/wcOgh5LWQMQWJLP6oORwsxhIxOnMv8EdtopdjI8VbWFcmOrfPQ4IwDGnTkR7n+R8uYTuDmc0H61j8RoMvRM2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r+jXZfFaj/mBZfU6QapQukJMNEemAubukfYwvP8TYRI=;
 b=k0t0WHsAN9flZh4vqTt8s0Og7a7wnnuV7fwRZ49gU8SEvYOHpWEItybCIJIWFd4H+xp/3zUpgxuY3hzbmh/Xkm0xV54rCDepL1lL1ZhOO457LJxz3k/yhRnBt4Zf29qTeOk4lekw4d2JkgZxPdYYVOMC8Us3OiPOTuzDeIcXq9xKJTI+ixuY5vLBmmLiFqArh/g0MZVU6D8Uquf4AnKBbKjwp1v5Zg1kTVZowtbNxRSc2F1WKBXrp7XPZQ4YdK6LdYcF6Q2/UPHH8yWC9QITjD7HsK3/m6MzNAYRNbcb1HiQ8Bsdsf13603gpy2uUuqhj2JYUTFErBfphcErl4RMPQ==
Received: from CH0PR04CA0107.namprd04.prod.outlook.com (2603:10b6:610:75::22)
 by DS0PR12MB7900.namprd12.prod.outlook.com (2603:10b6:8:14e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.21; Tue, 18 Nov
 2025 07:44:40 +0000
Received: from CH1PEPF0000AD77.namprd04.prod.outlook.com
 (2603:10b6:610:75:cafe::7) by CH0PR04CA0107.outlook.office365.com
 (2603:10b6:610:75::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.10 via Frontend Transport; Tue,
 18 Nov 2025 07:44:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH1PEPF0000AD77.mail.protection.outlook.com (10.167.244.55) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Tue, 18 Nov 2025 07:44:40 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 17 Nov
 2025 23:44:25 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 17 Nov
 2025 23:44:24 -0800
Received: from
 gb-nvl-073-compute01.l16.internal032k18.bmc032b17.internal032f11.internal032huang.bmc032l04.bmc
 (10.127.8.11) by mail.nvidia.com (10.129.68.7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20 via Frontend Transport; Mon, 17 Nov 2025 23:44:24 -0800
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
Subject: [PATCH v2 2/6] vfio: export function to map the VMA
Date: Tue, 18 Nov 2025 07:44:18 +0000
Message-ID: <20251118074422.58081-3-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251118074422.58081-1-ankita@nvidia.com>
References: <20251118074422.58081-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD77:EE_|DS0PR12MB7900:EE_
X-MS-Office365-Filtering-Correlation-Id: 642d5776-9fe9-42bb-617c-08de267654d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6dOMcUfb0FGlzxgfpW/CtzusPelmaejrZXpzjrKOKLH5pTz3DgO9vB/P+vDy?=
 =?us-ascii?Q?aPkVF9LLWYZh9Plfm1NmHDtiP6SGNmEPDHZVIm1uBJGdDT3YobVBslLyjaWo?=
 =?us-ascii?Q?ARGvlX9s4y0uG1JJUWvdxjbVu4B8ixHeq57XMZWpiIrFEDOwP/N74FE4Uehw?=
 =?us-ascii?Q?seh0BgNLEonQjRNDnanLWhLO3Jow/1yfHCAdxf3bREJcMl/ef7heGqa1+JSN?=
 =?us-ascii?Q?TYeUNhlDkbX2ULVSdVr6D1ElaxjT9F6lVBZDeSMe2u3QoEFfsr2fxOEcNy3W?=
 =?us-ascii?Q?O/xC5UvbOLLeqjMut9y3VCvR9BH/kjzzaTWLcxc4W23GoUqYhupxTQ7FMCQR?=
 =?us-ascii?Q?MDBJmTa+US8nIqmsis8CbXCKpiZh5Sc+g+mVyaboMgf344/Wb3Hi/dGdIfsC?=
 =?us-ascii?Q?YZ20M1TuJ6hXFRpDbc2AiurWSMYBt5+rZ2n4cQ000nQoavM2Q793jv3A59In?=
 =?us-ascii?Q?GJOTpZml2w0xs39xtEs8AFDW6n8AaYo9UUqtinvGyOJvpEEh1+FsG8AUr6HF?=
 =?us-ascii?Q?5W97K0WwMvCK0Vrm2FZTQAvhqo6p5NId3VwvHkGNAr3eTMwlxbHMT4ev6Mdd?=
 =?us-ascii?Q?yMDlmT22/rTLQIdpVbp4BHg6wGjRjrQNYkIcK5AbQ6VDRTTSpneuvKVge9U+?=
 =?us-ascii?Q?Wl0d7GHmbBZ+8Pa8NjjuVuW4/URnFgjD++mzafjJHxZanVZGTcE0gtKOJGgh?=
 =?us-ascii?Q?r98k/pPD2IW8z6wmPPrg1sf+siq73iRYKeoEQYzfJLBMS8XjxVzThdB9n14o?=
 =?us-ascii?Q?UNt4pRzUvtvgsU+IELe4H13Uy8c+AI0QAxXqYcfe/Vgpx0ELYKAL6ob2WV0q?=
 =?us-ascii?Q?aFsJLnhjBu41sRG7MsFmKhxp0Hp+ufJrYd7f43vu2bFen+JiYlcZyV/r30qE?=
 =?us-ascii?Q?Lbnza+LJA86Wg1KScxhQh2N4iIDfvVDYKYAeeHaDtfhUgc1fHPRJYvB2Na8B?=
 =?us-ascii?Q?HuPqLuiVAKzaACvVPkwyG08GQG/qzwdnNSHyLSOt1+fd2L5DgYogePnhg1oV?=
 =?us-ascii?Q?/jDN8tS4B9RYIpjrTgNba+pWbuXbwmKCPmiQo8X7BKfhXbJXB7HXHoB3nC/k?=
 =?us-ascii?Q?B42oOCwk1/toUrAJ4OYO7KvNI+yemWDUVqDIswD9LJm+6V5nc3NVtECeH07Q?=
 =?us-ascii?Q?83MmqbOR3LtrJtWJVYy7vckAQrTbPIyMF7tuw2uJ/cs3ceC+2u0UVwx0/CTA?=
 =?us-ascii?Q?NwgUb7eJ+gZP/QW6cfh+fYQtWxn42bx5QGNbgtraaC7fCVRC+vKAWygvZtRD?=
 =?us-ascii?Q?fp76SSjidAkM/omfu2EzgGMiQz8elV8pi744TEu98K8IEDMFbh0Q/f9OfhRq?=
 =?us-ascii?Q?ZctIgbjkSUQr10zJciF21OtHStCf0xGP14MkjsLSkJMVBu79mlEOOumv6aBf?=
 =?us-ascii?Q?VsDnzRK41Ngbw6Tu+VIdSY23eeNe2vA2A2REcDV1dEdMAg+FvZXzTn7KqA7v?=
 =?us-ascii?Q?ykIJp7taZIOuvvhnx18UV/RD0V82gPJv1jRxAQNIc3E6tOfXwW98+HOx+TT+?=
 =?us-ascii?Q?81A4nmrwGcS0X6iP+YRQF7pNeOQOOhUFiNT9MsFo7J7eqnU1V/6MQh8nge8L?=
 =?us-ascii?Q?fd+gxnLSK/WX+r4G3pU=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2025 07:44:40.2513
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 642d5776-9fe9-42bb-617c-08de267654d0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD77.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7900

From: Ankit Agrawal <ankita@nvidia.com>

Take out the implementation to map the VMA to the PTE/PMD/PUD
as a separate function.

Export the function to be used by nvgrace-gpu module.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 46 ++++++++++++++++++++------------
 include/linux/vfio_pci_core.h    |  2 ++
 2 files changed, 31 insertions(+), 17 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 7dcf5439dedc..29dcf78905a6 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1640,6 +1640,34 @@ static unsigned long vma_to_pfn(struct vm_area_struct *vma)
 	return (pci_resource_start(vdev->pdev, index) >> PAGE_SHIFT) + pgoff;
 }
 
+vm_fault_t vfio_pci_map_pfn(struct vm_fault *vmf,
+			    unsigned long pfn,
+			    unsigned int order)
+{
+	vm_fault_t ret;
+
+	switch (order) {
+	case 0:
+		ret = vmf_insert_pfn(vmf->vma, vmf->address, pfn);
+		break;
+#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
+	case PMD_ORDER:
+		ret = vmf_insert_pfn_pmd(vmf, pfn, false);
+		break;
+#endif
+#ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
+	case PUD_ORDER:
+		ret = vmf_insert_pfn_pud(vmf, pfn, false);
+		break;
+#endif
+	default:
+		ret = VM_FAULT_FALLBACK;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vfio_pci_map_pfn);
+
 static vm_fault_t vfio_pci_mmap_huge_fault(struct vm_fault *vmf,
 					   unsigned int order)
 {
@@ -1662,23 +1690,7 @@ static vm_fault_t vfio_pci_mmap_huge_fault(struct vm_fault *vmf,
 	if (vdev->pm_runtime_engaged || !__vfio_pci_memory_enabled(vdev))
 		goto out_unlock;
 
-	switch (order) {
-	case 0:
-		ret = vmf_insert_pfn(vma, vmf->address, pfn);
-		break;
-#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
-	case PMD_ORDER:
-		ret = vmf_insert_pfn_pmd(vmf, pfn, false);
-		break;
-#endif
-#ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
-	case PUD_ORDER:
-		ret = vmf_insert_pfn_pud(vmf, pfn, false);
-		break;
-#endif
-	default:
-		ret = VM_FAULT_FALLBACK;
-	}
+	ret = vfio_pci_map_pfn(vmf, pfn, order);
 
 out_unlock:
 	up_read(&vdev->memory_lock);
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index f541044e42a2..058acded858b 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -119,6 +119,8 @@ ssize_t vfio_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
 		size_t count, loff_t *ppos);
 ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *buf,
 		size_t count, loff_t *ppos);
+vm_fault_t vfio_pci_map_pfn(struct vm_fault *vmf, unsigned long pfn,
+			    unsigned int order);
 int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma);
 void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count);
 int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf);
-- 
2.34.1


