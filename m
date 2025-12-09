Return-Path: <kvm+bounces-65565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F1593CB0A6A
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 17:58:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9606630EFE9F
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 16:53:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A440932AABC;
	Tue,  9 Dec 2025 16:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="k9LLCQ/W"
X-Original-To: kvm@vger.kernel.org
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010048.outbound.protection.outlook.com [52.101.193.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2BF9329E71;
	Tue,  9 Dec 2025 16:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765299133; cv=fail; b=AojuyA+AbBFYGjYNAvAHcuzP6BOSwm9OfiuH2ZeWLF0roHNFGMSofRx8At3Ea1d/tskcStl44a+M+J1vUMbird9sse12Uli/vZMxn9SQdFU9CyiRhIDJwYgjjVWmfJNL1HXJwAB138anujOXG1ddGyQsnPkrgRaBpe9ix0o4xgw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765299133; c=relaxed/simple;
	bh=JDa3FakmOyI6yLONqrbhqzMDEy5mw6f2KcVVmJOJKow=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sz0wZvI0GZpztbX+O30RPLl7UMJnLShLeqmNwcqxFpxwdRHibZUAwhpNyfvZ/DUC+tCLIU5V1ksXhyZZcW0s7S0JnxoIUi75FmX5tXmBpo9H0xTC2cKrcV9MWx1TSqOTopdnLMVdzLayuesWs5cFyftoi1JW4y3YXgs1C7r7zpY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=k9LLCQ/W; arc=fail smtp.client-ip=52.101.193.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r4z7siPEh7TWCG5ME76PKavrCx3vKik3Uk6a5msB2S8K0Phz7Ndw0ymVqF2usGfZiPgwOkcewstPrGFBSNn4pIcd7Xul4Y2Fy1HOf0R8v4ZF3MHadXXYLEBXlUzNGdsP71n0U+qEG+2pOBGayrHmOfNsubNCuqMkRsziIE7n/Ci01quXCzcasKlUyfdImdMbBBJeD7s+oUBzNm/Tv2+7ibpnZOKLWznUKvXUh9X4kXRkgF8diu4kNUsBfGSeO+5cKYm8e5K7+kUg4v6eT/zDQMiaDOn0wKr/CLCHjhL0ESyTLfNGMokCUPTxl/KoH8GCmP/s0AIq/ZJF2KXDAfqygA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y/snwP4BuGyz2eSwZtk+MooEvLbQHXKvsUdpfLw5Tw4=;
 b=Fexi7KAR5AQbbtMO2woiR3ArZYj0FuCmAUmr25U6t0n58+6i+171EYCI869m5qPBW03QDdQT18IyseSjUhC6sCoOqUYOWxky2+ptJLZwTLsXnkK08uA6Y42z7hag5nEpYwtJ6db6smbvQ+2dzRTv9/R/YHkHbyu5h2IDJ0WPOBdIfORIwPyNioxjmAmIxqOYGP1S8Wwk+Yoxa269WRYmW8b3VJzKtvVsbYirXTkPY2jMLA/3/pl+tTMh6zwmF4be/DIdpdo8IJ1ApEYwHt3f2gFlOyrl2Uvyxlb1BaWe7vvw5r7vJjpUTFeyrmubNlb1qDhZv4YTzhAPqurYYiluug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y/snwP4BuGyz2eSwZtk+MooEvLbQHXKvsUdpfLw5Tw4=;
 b=k9LLCQ/WfBjU+EShHeM5ecFNTvID14OMb24RJVWxACkWLGrDPgPE98eOJCKTLdwVgCFnxhB1Clhe4P7JTl5e3Dxo6Y9Ye3nJ20bUCn9qmljalT5NbRhq1GZNTEfMJUYibbsKmb77F5HLBrcxF+UOM5enlad+CRwzvOV7O/MwAtpgL/JbqjeMxg4/mXK/c4ul+yaYtOZg6mOnp6R9qq29lK3g7mvnM+fEZaXmPwVkLSgvInJsruNAzpXxAiwTRZXLSGBeWeYJv3daOCCQ5jflHqSAUjewtwUYeYg5tkFCsZEbOeZXqu+SPg1lxmW46JCooWxT8WSFi7Ow2+UCxBj0XQ==
Received: from BN9P221CA0027.NAMP221.PROD.OUTLOOK.COM (2603:10b6:408:10a::21)
 by PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Tue, 9 Dec
 2025 16:52:07 +0000
Received: from BN2PEPF000044A4.namprd02.prod.outlook.com
 (2603:10b6:408:10a:cafe::48) by BN9P221CA0027.outlook.office365.com
 (2603:10b6:408:10a::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.14 via Frontend Transport; Tue,
 9 Dec 2025 16:51:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN2PEPF000044A4.mail.protection.outlook.com (10.167.243.155) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9412.4 via Frontend Transport; Tue, 9 Dec 2025 16:52:07 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 9 Dec
 2025 08:51:42 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 9 Dec
 2025 08:51:42 -0800
Received: from nvidia-4028GR-scsim.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 9 Dec 2025 08:51:35 -0800
From: <mhonap@nvidia.com>
To: <aniketa@nvidia.com>, <ankita@nvidia.com>, <alwilliamson@nvidia.com>,
	<vsethi@nvidia.com>, <jgg@nvidia.com>, <mochs@nvidia.com>,
	<skolothumtho@nvidia.com>, <alejandro.lucero-palau@amd.com>,
	<dave@stgolabs.net>, <jonathan.cameron@huawei.com>, <dave.jiang@intel.com>,
	<alison.schofield@intel.com>, <vishal.l.verma@intel.com>,
	<ira.weiny@intel.com>, <dan.j.williams@intel.com>, <jgg@ziepe.ca>,
	<yishaih@nvidia.com>, <kevin.tian@intel.com>
CC: <cjia@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <kjaju@nvidia.com>, <linux-kernel@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, <kvm@vger.kernel.org>, <mhonap@nvidia.com>
Subject: [RFC v2 07/15] vfio/cxl: expose CXL region to the userspace via a new VFIO device region
Date: Tue, 9 Dec 2025 22:20:11 +0530
Message-ID: <20251209165019.2643142-8-mhonap@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251209165019.2643142-1-mhonap@nvidia.com>
References: <20251209165019.2643142-1-mhonap@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A4:EE_|PH8PR12MB7277:EE_
X-MS-Office365-Filtering-Correlation-Id: 2222d2a3-973f-437c-ba96-08de374349e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DrFh6usQcfqN/jdveIKqzd0USd1CGbN/2gAJHi1N/rVQ+TJ3UUFGOzUfHcWK?=
 =?us-ascii?Q?nFsY/wzNDMK3XenCaTvAfoSree9vzfQ27E2BuZnZFwD/MKXZYI0mY4Fu5P/w?=
 =?us-ascii?Q?JtWupjOUoY0KN52DnPyCk1/4y8rBeGG+NREDEkokB5DiEfKWrCCA/thT6OIT?=
 =?us-ascii?Q?1KOx+IH2pqA0d0RTKm0IQcfDbUx/zalK9Jr+KrBurtiB7MqGnOToR1R3w57s?=
 =?us-ascii?Q?QJg56n5Kaj4uuqToo+gRVB8JMtUHNnrOklte91LtbQG1H89S0KORtMaiw3cv?=
 =?us-ascii?Q?1+XsQ5SuyBehWLK/wiQXO/KOXvrwjkm+m7BtBvrn3iHyAgy3cInW9VHtZc4W?=
 =?us-ascii?Q?UXmh0UNs8EOi4ALClXwnqXBFIZ4688tptZInxh1hjXMlGeuBOV7hLeaqeHT6?=
 =?us-ascii?Q?XAYDDhiqXGqLu/ufRrSBPSVYmMDkXnpLgSad8HOFa5Pgh4eRdwEwn8ag9IBG?=
 =?us-ascii?Q?+uvf/NX+GrOf+VlYqq+s8CH/k5rAsN7jPwoXdrMJYAGjiTdoZ7ZCQrYHBU61?=
 =?us-ascii?Q?yDhTSOvoMlYZID3qbY7IPWa24LSH4SPa035tcJNshC3vLoRpaHJHme4HTFPz?=
 =?us-ascii?Q?V18ueF2ZmN9BHiuB3VqFHyxHJesU2BcbTDJmJRRO9O5Fd9vz2p+VKkJVjS2P?=
 =?us-ascii?Q?4t0zQYgeNG+GaJPpUwohACzDu6Yr9ut3j/A2lXZH6HS9EyOyA+s1gqytaZBb?=
 =?us-ascii?Q?daPLiyocnN4Fuv2ftnajYfixQOttGJGUniE7N/Kw8fkX5K1qYiiDksmGa3aj?=
 =?us-ascii?Q?URCewVQD5awQ5MEORD6K6XKod9ywtpHyguXGvbszhh85sHM9WMBX2BtuFISP?=
 =?us-ascii?Q?0Bb7F8HjwQC1XEQKtQP94hL8H749w/kwnyf+R/PIUZi6mJCEKCzHM6TRX+y3?=
 =?us-ascii?Q?KfJ5yXG5A32sNUxI+CMRYaXX3TPKo74ksDbXOtjLJZXlOwyLHuOKpD+2l2Km?=
 =?us-ascii?Q?MMxxPIsF2u0EdNRAzKDEltj2HPP5mlHn3IZN0C3FXz3kTrxL4y3Gp7WCkMzO?=
 =?us-ascii?Q?uWfBIaUQ07ZU4d1kcV5fJYVtcCEnk+P60IsVh59pj2/Q8oov9Zbl/WchGQd5?=
 =?us-ascii?Q?wEWI/bw6Hf2hlmlSVLLXXZcCo9gC1+Jt8yqjkajChfr6E2S+YFNJzUGsG8FR?=
 =?us-ascii?Q?KDbYg4A4zc1KqFONU0a+hNbVzbvcaBge//bCuOZOF67Uvv0L1cRRug6qwrbF?=
 =?us-ascii?Q?bCF4tu+4K++gb84cbEpqdAVk3yrPbNe34gTFIQBmwkcnQ7IEwoNZYVq+Kbc9?=
 =?us-ascii?Q?fbth+s1OM0F11cXfKijSZ+ihFiWtVkyDSxndDHOxh0UDENY15gCeKDmu/qh2?=
 =?us-ascii?Q?gCf88IgzqO7WQWLngoR4IwLS+veCISJJbKEP+MVAzzkzzEYzzeKFRAvH6Jzq?=
 =?us-ascii?Q?M/L2w7B00Q/qvO8iZWRpJm1NojS4Dwalm4ZDLRSS3AxFinh4i/VFkRifzTbD?=
 =?us-ascii?Q?vOMQkcqCdA16pyYRLdMpGSfOwSLlwRPvkWvML3YzkIwmtnK7cJASvfir43II?=
 =?us-ascii?Q?cc10siPl+JI9HH03II0gO8Ny6c4/1817LCsm3CoXWcm6jYCI1Dlf+uglmGJr?=
 =?us-ascii?Q?SQYGTVb2H5uJboPEXth6540uu1esG7XfnSh7KCWR?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 16:52:07.3514
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2222d2a3-973f-437c-ba96-08de374349e5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A4.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7277

From: Manish Honap <mhonap@nvidia.com>

To directly access the device memory, a CXL region is required. Creating
a CXL region requires to configure HDM decoders on the path to map the
access of HPA level by level and evetually hit the DPA in the CXL
topology.

For the userspace, e.g. QEMU, to access the CXL region, the region is
required to be exposed via VFIO interfaces.

Introduce a new VFIO device region and region ops to expose the created
CXL region when initialize the device in the vfio-cxl-core. Introduce a
new sub region type for the userspace to identify a CXL region.

Co-developed-by: Zhi Wang <zhiw@nvidia.com>
Signed-off-by: Zhi Wang <zhiw@nvidia.com>
Signed-off-by: Manish Honap <mhonap@nvidia.com>
---
 drivers/vfio/pci/vfio_cxl_core.c | 122 +++++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_core.c |   3 +-
 include/linux/vfio_pci_core.h    |   5 ++
 include/uapi/linux/vfio.h        |   4 +
 4 files changed, 133 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_cxl_core.c b/drivers/vfio/pci/vfio_cxl_core.c
index cf53720c0cb7..35d95de47fa8 100644
--- a/drivers/vfio/pci/vfio_cxl_core.c
+++ b/drivers/vfio/pci/vfio_cxl_core.c
@@ -231,6 +231,128 @@ void vfio_cxl_core_destroy_cxl_region(struct vfio_cxl_core_device *cxl)
 }
 EXPORT_SYMBOL_GPL(vfio_cxl_core_destroy_cxl_region);
 
+static int vfio_cxl_region_mmap(struct vfio_pci_core_device *pci,
+				struct vfio_pci_region *region,
+				struct vm_area_struct *vma)
+{
+	struct vfio_cxl_region *cxl_region = region->data;
+	u64 req_len, pgoff, req_start, end;
+	int ret;
+
+	if (!(region->flags & VFIO_REGION_INFO_FLAG_MMAP))
+		return -EINVAL;
+
+	if (!(region->flags & VFIO_REGION_INFO_FLAG_READ) &&
+	    (vma->vm_flags & VM_READ))
+		return -EPERM;
+
+	if (!(region->flags & VFIO_REGION_INFO_FLAG_WRITE) &&
+	    (vma->vm_flags & VM_WRITE))
+		return -EPERM;
+
+	pgoff = vma->vm_pgoff &
+		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
+
+	if (check_sub_overflow(vma->vm_end, vma->vm_start, &req_len) ||
+	    check_add_overflow(PHYS_PFN(cxl_region->addr), pgoff, &req_start) ||
+	    check_add_overflow(PFN_PHYS(pgoff), req_len, &end))
+		return -EOVERFLOW;
+
+	if (end > cxl_region->size)
+		return -EINVAL;
+
+	if (cxl_region->noncached)
+		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+	vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
+
+	vm_flags_set(vma, VM_ALLOW_ANY_UNCACHED | VM_IO | VM_PFNMAP |
+		     VM_DONTEXPAND | VM_DONTDUMP);
+
+	ret = remap_pfn_range(vma, vma->vm_start, req_start,
+			      req_len, vma->vm_page_prot);
+	if (ret)
+		return ret;
+
+	vma->vm_pgoff = req_start;
+
+	return 0;
+}
+
+static ssize_t vfio_cxl_region_rw(struct vfio_pci_core_device *core_dev,
+				  char __user *buf, size_t count, loff_t *ppos,
+				  bool iswrite)
+{
+	unsigned int i = VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIONS;
+	struct vfio_cxl_region *cxl_region = core_dev->region[i].data;
+	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
+
+	if (!count)
+		return 0;
+
+	return vfio_pci_core_do_io_rw(core_dev, false,
+				      cxl_region->vaddr,
+				      (char __user *)buf, pos, count,
+				      0, 0, iswrite);
+}
+
+static void vfio_cxl_region_release(struct vfio_pci_core_device *vdev,
+				    struct vfio_pci_region *region)
+{
+}
+
+static const struct vfio_pci_regops vfio_cxl_regops = {
+	.rw             = vfio_cxl_region_rw,
+	.mmap           = vfio_cxl_region_mmap,
+	.release        = vfio_cxl_region_release,
+};
+
+int vfio_cxl_core_register_cxl_region(struct vfio_cxl_core_device *cxl)
+{
+	struct vfio_pci_core_device *pci = &cxl->pci_core;
+	struct vfio_cxl *cxl_core = cxl->cxl_core;
+	u32 flags;
+	int ret;
+
+	if (WARN_ON(!cxl_core->region.region || cxl_core->region.vaddr))
+		return -EEXIST;
+
+	cxl_core->region.vaddr = ioremap(cxl_core->region.addr, cxl_core->region.size);
+	if (!cxl_core->region.addr)
+		return -EFAULT;
+
+	flags = VFIO_REGION_INFO_FLAG_READ |
+		VFIO_REGION_INFO_FLAG_WRITE |
+		VFIO_REGION_INFO_FLAG_MMAP;
+
+	ret = vfio_pci_core_register_dev_region(pci,
+						PCI_VENDOR_ID_CXL |
+						VFIO_REGION_TYPE_PCI_VENDOR_TYPE,
+						VFIO_REGION_SUBTYPE_CXL,
+						&vfio_cxl_regops,
+						cxl_core->region.size, flags,
+						&cxl_core->region);
+	if (ret) {
+		iounmap(cxl_core->region.vaddr);
+		cxl_core->region.vaddr = NULL;
+		return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vfio_cxl_core_register_cxl_region);
+
+void vfio_cxl_core_unregister_cxl_region(struct vfio_cxl_core_device *cxl)
+{
+	struct vfio_cxl *cxl_core = cxl->cxl_core;
+
+	if (WARN_ON(!cxl_core->region.region || !cxl_core->region.vaddr))
+		return;
+
+	iounmap(cxl_core->region.vaddr);
+	cxl_core->region.vaddr = NULL;
+}
+EXPORT_SYMBOL_GPL(vfio_cxl_core_unregister_cxl_region);
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 7dcf5439dedc..c0695b5db66d 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1698,12 +1698,13 @@ static vm_fault_t vfio_pci_mmap_page_fault(struct vm_fault *vmf)
 	return vfio_pci_mmap_huge_fault(vmf, 0);
 }
 
-static const struct vm_operations_struct vfio_pci_mmap_ops = {
+const struct vm_operations_struct vfio_pci_mmap_ops = {
 	.fault = vfio_pci_mmap_page_fault,
 #ifdef CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP
 	.huge_fault = vfio_pci_mmap_huge_fault,
 #endif
 };
+EXPORT_SYMBOL_GPL(vfio_pci_mmap_ops);
 
 int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma)
 {
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index a343b91d2580..3474835f5d65 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -102,6 +102,7 @@ struct vfio_cxl_region {
 	struct cxl_region *region;
 	u64 size;
 	u64 addr;
+	void *vaddr;
 	bool noncached;
 };
 
@@ -203,6 +204,8 @@ vfio_pci_core_to_cxl(struct vfio_pci_core_device *pci)
 	return container_of(pci, struct vfio_cxl_core_device, pci_core);
 }
 
+extern const struct vm_operations_struct vfio_pci_mmap_ops;
+
 int vfio_cxl_core_enable(struct vfio_cxl_core_device *cxl,
 			 struct vfio_cxl_dev_info *info);
 void vfio_cxl_core_finish_enable(struct vfio_cxl_core_device *cxl);
@@ -210,5 +213,7 @@ void vfio_cxl_core_disable(struct vfio_cxl_core_device *cxl);
 void vfio_cxl_core_close_device(struct vfio_device *vdev);
 int vfio_cxl_core_create_cxl_region(struct vfio_cxl_core_device *cxl, u64 size);
 void vfio_cxl_core_destroy_cxl_region(struct vfio_cxl_core_device *cxl);
+int vfio_cxl_core_register_cxl_region(struct vfio_cxl_core_device *cxl);
+void vfio_cxl_core_unregister_cxl_region(struct vfio_cxl_core_device *cxl);
 
 #endif /* VFIO_PCI_CORE_H */
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 75100bf009ba..95be987d2ed5 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -372,6 +372,10 @@ struct vfio_region_info_cap_type {
 /* sub-types for VFIO_REGION_TYPE_GFX */
 #define VFIO_REGION_SUBTYPE_GFX_EDID            (1)
 
+/* 1e98 vendor PCI sub-types */
+/* sub-type for VFIO CXL region */
+#define VFIO_REGION_SUBTYPE_CXL                 (1)
+
 /**
  * struct vfio_region_gfx_edid - EDID region layout.
  *
-- 
2.25.1


