Return-Path: <kvm+bounces-66044-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C984CBFFDC
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 22:43:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BDF29301C89A
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 21:43:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E8E132E68E;
	Mon, 15 Dec 2025 21:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WvtLejFw"
X-Original-To: kvm@vger.kernel.org
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010017.outbound.protection.outlook.com [40.93.198.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5076532AAA1;
	Mon, 15 Dec 2025 21:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765834976; cv=fail; b=Pcjv4SuAEzl6dZVbygPtzhoTCMoIn8Iuq1oSCY1NdZtK/aH9Ja6KyAqoOu+7UTIzVqEt9D+5rFRCSAr8AtBvLkr5T1WJKOIJks8z5XWHZmDXa0dFqhGhk4axDaXGSliblfnEF5ocCm0e00Ws2All9K6pBA+zy9ScP8u9lkQbJo0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765834976; c=relaxed/simple;
	bh=enX62P+Z1CJCU+wnB+smW6I2tjGKLaOuJ9Pd8DZ9QkM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ITAa4P9hPhlBWqbieO9S6G3+SgDv/mBZlxwtiE4hW4sfPWsqE0aQoJ9/GFSa70zSe/2wzjvxtMoPwHbAX9eRsl/Q6eat168ehosqNUPZ876/3UOtRC+PTR22NgcXIpW/X5OI3yHgrkdjPUIIQbUKgaZsx5tFtUznikk+tXBFRXU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WvtLejFw; arc=fail smtp.client-ip=40.93.198.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tCdn5afVVreLbJtsE1+YRpQgZBjRicxaXKJI+z772u2liTjydh5yNCBswBAWRICEt3J9zSkpsAoXepy/KC9O0yN4AzG1B3a6DFnc8hL5IegetMzWclUKPPUIZEmwTuGr+mR0t4YmlJBBRTA7kXYFlYXRzMtGF0JoNHDOh3kTb62admoypVii+wKHRpEsZ5mWYN8gU5FDDjt3tGQ4/GmIzK2PhsGDPBL+n4Ag9tqwpZHgMBjZQ/+Fub+4ztZJcAkjKHGvFWwZEFCUIYEDGJ3i2GONuv1Fgz0/nE5jxvRlDEQR6Kc7iZmCexOvFSg5FgpcmuNWokRmaOaRXME5bHd3Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kMbAcIrIpAgpZI8/c4tK1VP8mG4A61RCTWdwM7bY/ms=;
 b=guP5a/pP8b3AQUclS5XjqnZLAGGRqg+mrsP5tay6IPHPJrXsNDIvbIcDgoGLapHyROiiE1WdHYdT0ZVSoF8jhgt8ztaFXGWDEr29BwKQCw2LC1q4UvcNKmzcbHFTunCi4KHl4dGCh4yweT2k0BYnNk6SqPG0qiwNzpVdp3CIOwcxdjQVnCcu/nmYXACRe+61IeLrco6qPfE3S6FREKA7AtQN9uw2sNtbo1V47ZyS8sUowiyIukrngvUbvwLRittyrLxCvkFwkihQC4v2yWe3gFARDpOTp0WuFeq57r23WemAeIgs1tzlwZwhVbpAL5lLgAsY4nnDFG4OWeoOG7ezNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=8bytes.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kMbAcIrIpAgpZI8/c4tK1VP8mG4A61RCTWdwM7bY/ms=;
 b=WvtLejFw/qawORChQemmiWEYLqWDucpJsZeIsijCK4BPUUnZ7XrSuL5Ruoj5T65rSpEtvfkozsB5m53mzEeR7GQU+0MLZFdUIBsqx6S4dhYm4JL54f/fgAZz+BuFLSVRDngsXyeUdupms0TXdEYzraFL7TBBrj1iHys4zmufzxqIyv780N9pYFFewzk0tl9FuFkYt5MSWXWYjOhQqW+8RbU9wjLqd0Q5WmP3CEB9mg/ObvJQHWuTnFEB3yMMebUkJYXIcCjqlutncvLaA2F1yerZtR+nWjyDnq5gkKOIPKEpEt9iyxMgBVj7pNFY7YAVg2ooLUfBg7wW61knH968KA==
Received: from MN0P223CA0003.NAMP223.PROD.OUTLOOK.COM (2603:10b6:208:52b::30)
 by PH7PR12MB5853.namprd12.prod.outlook.com (2603:10b6:510:1d4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 21:42:48 +0000
Received: from BL6PEPF0001AB52.namprd02.prod.outlook.com
 (2603:10b6:208:52b:cafe::c8) by MN0P223CA0003.outlook.office365.com
 (2603:10b6:208:52b::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.13 via Frontend Transport; Mon,
 15 Dec 2025 21:42:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL6PEPF0001AB52.mail.protection.outlook.com (10.167.241.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Mon, 15 Dec 2025 21:42:47 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 15 Dec
 2025 13:42:33 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 15 Dec 2025 13:42:33 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Mon, 15 Dec 2025 13:42:32 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <joro@8bytes.org>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <afael@kernel.org>,
	<lenb@kernel.org>, <bhelgaas@google.com>, <alex@shazbot.org>,
	<jgg@nvidia.com>, <kevin.tian@intel.com>, <baolu.lu@linux.intel.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
	<patches@lists.linux.dev>, <pjaroszynski@nvidia.com>, <vsethi@nvidia.com>,
	<helgaas@kernel.org>, <etzhao1900@gmail.com>
Subject: [PATCH v8 4/5] iommu: Introduce pci_dev_reset_iommu_prepare/done()
Date: Mon, 15 Dec 2025 13:42:19 -0800
Message-ID: <e5dff289a0ae10e317d87466074aeb0d9ba9c06c.1765834788.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1765834788.git.nicolinc@nvidia.com>
References: <cover.1765834788.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB52:EE_|PH7PR12MB5853:EE_
X-MS-Office365-Filtering-Correlation-Id: 248d2175-fa85-449b-064d-08de3c22e370
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KorelxFBWNEQO8zAGpdigs/MYpeHPxso3c86XPMSeoLtoWbwjk67f/xSGTka?=
 =?us-ascii?Q?eb/X+Uy3v7QA2D1S3J1emYA+WiBgr2Jm8iE6aHtvlMnIN1KDA8+JM128rt4n?=
 =?us-ascii?Q?rzHISWl1M5fedVSnLK4k17WCE0fRm2C7+xn7NwucaoyMwieq6E0ahj/wgRwy?=
 =?us-ascii?Q?roy3XFDRv6BoJtsNavUmTIQLraM9/AWzSAHpc/nI9gKjsY2JOfaUNguHVMIi?=
 =?us-ascii?Q?qnmkThgbhTmz1Zd30I41RqrD8Gcx002w2+fAomnXF/n0ghccOj3AtkdaOM0f?=
 =?us-ascii?Q?UipIGF3/Fae/G4pHF7oW/qfaQxWtwjJSDjVv12CsaRmKUXgydfoTC99GLoOl?=
 =?us-ascii?Q?fWL4l6PWLFTVbXSmc0R1SacCgxP+0d4eSZqpBKRzvI2W8allKouhCGX6i46b?=
 =?us-ascii?Q?a/7N494rfG08Kza9pL39K0lSNZ9Djh27j6aMjA2q3yQzG1Dbo+rnT+Z7JoHS?=
 =?us-ascii?Q?e5fW7TB+f5BegeAN1WNC8mFUo9lbRmAB5xFmXWXKNXY/8oO6duek4QT4+tcQ?=
 =?us-ascii?Q?+XiES1hBAuZbIl/Q1ReDe6sHZSF90cwtGSay7eW4RB4QdLW9ineB1nOgZ77I?=
 =?us-ascii?Q?Rf2x7z5NdKwKt+JC1Y0ZWZCGbaZhLIbzqdyhafG4PgDgHXKBQ2ZIQsgo5Ut9?=
 =?us-ascii?Q?xpjnyLLQPZcvwYM1GM89idNG0l0sI6r4CSOpc/M9LpT3/pAbn6qUWDalyW2Z?=
 =?us-ascii?Q?fL71MmGQ4d5EZj2TtiI4zIRShNBMClDZhuS87KhIq6jcRyMzAQNxMAWa0zX0?=
 =?us-ascii?Q?/JIJ/m+eXTNr7S5yPkmtmHJrQ+kr6DZqfHN9ph4fXYW8RzCqoWTOcZnz79qS?=
 =?us-ascii?Q?LcKsHf/jc881shmP6B+TO7Hq8caKHPKnIS3cuNmICFfm1zWk49WduE2otXcL?=
 =?us-ascii?Q?HuC5KtRWHvmt5FgxlbT8WBHyG/n3SBVc5JcHFANu7l++ZMQF45nDfbWZvpk8?=
 =?us-ascii?Q?FVt9EZkcAuB0+m5I0IA1nLWrorCKYlWr5OIf/EAWdmjrJk89x4xOPDelhym1?=
 =?us-ascii?Q?6K8sGy7920rvv1HJm7Fx+sLrov17Krtb388p8u3KPhoE1pLOr8w/OwS20ihA?=
 =?us-ascii?Q?G5yYBCvLhw863ZBX4Th4l7j6PJ2dGyqBtsCXNjqebOUEbnzXHdDMG2aNiZGx?=
 =?us-ascii?Q?lXr/X+tSfOVHy6J3j1URv6cm7CGrC06J3+/Q0LZ/EqqZwv0lSoypkzZl80I/?=
 =?us-ascii?Q?N6fIVhs0Zq3A9FM6yICvuqezCMEu3bzkCY9nDRj8uQpWwPxbkwbjj2QjOG7I?=
 =?us-ascii?Q?m4aL+SsmhbxqxqKLpyBj1kgR8iPONtohkVAxH7SjbWDCRLkZxWk9WFh/15Px?=
 =?us-ascii?Q?HmHQc9+ngc88ZQ85rjXsKe4TZZaaCLcwOckRc0tvTtkXw4KRmq+OxpBU9FU5?=
 =?us-ascii?Q?McS95eA6D/7PhY+6DT49sCaMFLiJFECf01L/SW6b+icJgNBh4sOCEKTe2q8L?=
 =?us-ascii?Q?cRHC3PsFqoLfyJSx3gk11BsGt5K0lwCQU43u82+vDBrUoh0/ldPtV2X6P08f?=
 =?us-ascii?Q?35bze/FDRynY9hI+Z3Mo1CC/K94607LtrTj3JZYDkV8+nyidR6GU4aWLSLpg?=
 =?us-ascii?Q?XAzhnJ2J61Y3lPQxThs=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2025 21:42:47.3679
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 248d2175-fa85-449b-064d-08de3c22e370
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB52.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5853

PCIe permits a device to ignore ATS invalidation TLPs while processing a
reset. This creates a problem visible to the OS where an ATS invalidation
command will time out. E.g. an SVA domain will have no coordination with a
reset event and can racily issue ATS invalidations to a resetting device.

The OS should do something to mitigate this as we do not want production
systems to be reporting critical ATS failures, especially in a hypervisor
environment. Broadly, OS could arrange to ignore the timeouts, block page
table mutations to prevent invalidations, or disable and block ATS.

The PCIe r6.0, sec 10.3.1 IMPLEMENTATION NOTE recommends SW to disable and
block ATS before initiating a Function Level Reset. It also mentions that
other reset methods could have the same vulnerability as well.

Provide a callback from the PCI subsystem that will enclose the reset and
have the iommu core temporarily change all the attached RID/PASID domains
group->blocking_domain so that the IOMMU hardware would fence any incoming
ATS queries. And IOMMU drivers should also synchronously stop issuing new
ATS invalidations and wait for all ATS invalidations to complete. This can
avoid any ATS invaliation timeouts.

However, if there is a domain attachment/replacement happening during an
ongoing reset, ATS routines may be re-activated between the two function
calls. So, introduce a new resetting_domain in the iommu_group structure
to reject any concurrent attach_dev/set_dev_pasid call during a reset for
a concern of compatibility failure. Since this changes the behavior of an
attach operation, update the uAPI accordingly.

Note that there are two corner cases:
 1. Devices in the same iommu_group
    Since an attachment is always per iommu_group, this means that any
    sibling devices in the iommu_group cannot change domain, to prevent
    race conditions.
 2. An SR-IOV PF that is being reset while its VF is not
    In such case, the VF itself is already broken. So, there is no point
    in preventing PF from going through the iommu reset.

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 include/linux/iommu.h     |  13 +++
 include/uapi/linux/vfio.h |   4 +
 drivers/iommu/iommu.c     | 173 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 190 insertions(+)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index ff097df318b9..54b8b48c762e 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -1188,6 +1188,10 @@ void iommu_detach_device_pasid(struct iommu_domain *domain,
 			       struct device *dev, ioasid_t pasid);
 ioasid_t iommu_alloc_global_pasid(struct device *dev);
 void iommu_free_global_pasid(ioasid_t pasid);
+
+/* PCI device reset functions */
+int pci_dev_reset_iommu_prepare(struct pci_dev *pdev);
+void pci_dev_reset_iommu_done(struct pci_dev *pdev);
 #else /* CONFIG_IOMMU_API */
 
 struct iommu_ops {};
@@ -1511,6 +1515,15 @@ static inline ioasid_t iommu_alloc_global_pasid(struct device *dev)
 }
 
 static inline void iommu_free_global_pasid(ioasid_t pasid) {}
+
+static inline int pci_dev_reset_iommu_prepare(struct pci_dev *pdev)
+{
+	return 0;
+}
+
+static inline void pci_dev_reset_iommu_done(struct pci_dev *pdev)
+{
+}
 #endif /* CONFIG_IOMMU_API */
 
 #ifdef CONFIG_IRQ_MSI_IOMMU
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index ac2329f24141..bb7b89330d35 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -964,6 +964,10 @@ struct vfio_device_bind_iommufd {
  * hwpt corresponding to the given pt_id.
  *
  * Return: 0 on success, -errno on failure.
+ *
+ * When a device is resetting, -EBUSY will be returned to reject any concurrent
+ * attachment to the resetting device itself or any sibling device in the IOMMU
+ * group having the resetting device.
  */
 struct vfio_device_attach_iommufd_pt {
 	__u32	argsz;
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 672597100e9a..0665dedd91b2 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -61,6 +61,11 @@ struct iommu_group {
 	int id;
 	struct iommu_domain *default_domain;
 	struct iommu_domain *blocking_domain;
+	/*
+	 * During a group device reset, @resetting_domain points to the physical
+	 * domain, while @domain points to the attached domain before the reset.
+	 */
+	struct iommu_domain *resetting_domain;
 	struct iommu_domain *domain;
 	struct list_head entry;
 	unsigned int owner_cnt;
@@ -2195,6 +2200,15 @@ int iommu_deferred_attach(struct device *dev, struct iommu_domain *domain)
 
 	guard(mutex)(&dev->iommu_group->mutex);
 
+	/*
+	 * This is a concurrent attach during a device reset. Reject it until
+	 * pci_dev_reset_iommu_done() attaches the device to group->domain.
+	 *
+	 * Note that this might fail the iommu_dma_map(). But there's nothing
+	 * more we can do here.
+	 */
+	if (dev->iommu_group->resetting_domain)
+		return -EBUSY;
 	return __iommu_attach_device(domain, dev, NULL);
 }
 
@@ -2253,6 +2267,17 @@ struct iommu_domain *iommu_driver_get_domain_for_dev(struct device *dev)
 
 	lockdep_assert_held(&group->mutex);
 
+	/*
+	 * Driver handles the low-level __iommu_attach_device(), including the
+	 * one invoked by pci_dev_reset_iommu_done() re-attaching the device to
+	 * the cached group->domain. In this case, the driver must get the old
+	 * domain from group->resetting_domain rather than group->domain. This
+	 * prevents it from re-attaching the device from group->domain (old) to
+	 * group->domain (new).
+	 */
+	if (group->resetting_domain)
+		return group->resetting_domain;
+
 	return group->domain;
 }
 EXPORT_SYMBOL_GPL(iommu_driver_get_domain_for_dev);
@@ -2409,6 +2434,13 @@ static int __iommu_group_set_domain_internal(struct iommu_group *group,
 	if (WARN_ON(!new_domain))
 		return -EINVAL;
 
+	/*
+	 * This is a concurrent attach during a device reset. Reject it until
+	 * pci_dev_reset_iommu_done() attaches the device to group->domain.
+	 */
+	if (group->resetting_domain)
+		return -EBUSY;
+
 	/*
 	 * Changing the domain is done by calling attach_dev() on the new
 	 * domain. This switch does not have to be atomic and DMA can be
@@ -3527,6 +3559,16 @@ int iommu_attach_device_pasid(struct iommu_domain *domain,
 		return -EINVAL;
 
 	mutex_lock(&group->mutex);
+
+	/*
+	 * This is a concurrent attach during a device reset. Reject it until
+	 * pci_dev_reset_iommu_done() attaches the device to group->domain.
+	 */
+	if (group->resetting_domain) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+
 	for_each_group_device(group, device) {
 		/*
 		 * Skip PASID validation for devices without PASID support
@@ -3610,6 +3652,16 @@ int iommu_replace_device_pasid(struct iommu_domain *domain,
 		return -EINVAL;
 
 	mutex_lock(&group->mutex);
+
+	/*
+	 * This is a concurrent attach during a device reset. Reject it until
+	 * pci_dev_reset_iommu_done() attaches the device to group->domain.
+	 */
+	if (group->resetting_domain) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+
 	entry = iommu_make_pasid_array_entry(domain, handle);
 	curr = xa_cmpxchg(&group->pasid_array, pasid, NULL,
 			  XA_ZERO_ENTRY, GFP_KERNEL);
@@ -3867,6 +3919,127 @@ int iommu_replace_group_handle(struct iommu_group *group,
 }
 EXPORT_SYMBOL_NS_GPL(iommu_replace_group_handle, "IOMMUFD_INTERNAL");
 
+/**
+ * pci_dev_reset_iommu_prepare() - Block IOMMU to prepare for a PCI device reset
+ * @pdev: PCI device that is going to enter a reset routine
+ *
+ * The PCIe r6.0, sec 10.3.1 IMPLEMENTATION NOTE recommends to disable and block
+ * ATS before initiating a reset. This means that a PCIe device during the reset
+ * routine wants to block any IOMMU activity: translation and ATS invalidation.
+ *
+ * This function attaches the device's RID/PASID(s) the group->blocking_domain,
+ * setting the group->resetting_domain. This allows the IOMMU driver pausing any
+ * IOMMU activity while leaving the group->domain pointer intact. Later when the
+ * reset is finished, pci_dev_reset_iommu_done() can restore everything.
+ *
+ * Caller must use pci_dev_reset_iommu_prepare() with pci_dev_reset_iommu_done()
+ * before/after the core-level reset routine, to unset the resetting_domain.
+ *
+ * Return: 0 on success or negative error code if the preparation failed.
+ *
+ * These two functions are designed to be used by PCI reset functions that would
+ * not invoke any racy iommu_release_device(), since PCI sysfs node gets removed
+ * before it notifies with a BUS_NOTIFY_REMOVED_DEVICE. When using them in other
+ * case, callers must ensure there will be no racy iommu_release_device() call,
+ * which otherwise would UAF the dev->iommu_group pointer.
+ */
+int pci_dev_reset_iommu_prepare(struct pci_dev *pdev)
+{
+	struct iommu_group *group = pdev->dev.iommu_group;
+	unsigned long pasid;
+	void *entry;
+	int ret;
+
+	if (!pci_ats_supported(pdev) || !dev_has_iommu(&pdev->dev))
+		return 0;
+
+	guard(mutex)(&group->mutex);
+
+	/* Re-entry is not allowed */
+	if (WARN_ON(group->resetting_domain))
+		return -EBUSY;
+
+	ret = __iommu_group_alloc_blocking_domain(group);
+	if (ret)
+		return ret;
+
+	/* Stage RID domain at blocking_domain while retaining group->domain */
+	if (group->domain != group->blocking_domain) {
+		ret = __iommu_attach_device(group->blocking_domain, &pdev->dev,
+					    group->domain);
+		if (ret)
+			return ret;
+	}
+
+	/*
+	 * Stage PASID domains at blocking_domain while retaining pasid_array.
+	 *
+	 * The pasid_array is mostly fenced by group->mutex, except one reader
+	 * in iommu_attach_handle_get(), so it's safe to read without xa_lock.
+	 */
+	xa_for_each_start(&group->pasid_array, pasid, entry, 1)
+		iommu_remove_dev_pasid(&pdev->dev, pasid,
+				       pasid_array_entry_to_domain(entry));
+
+	group->resetting_domain = group->blocking_domain;
+	return ret;
+}
+EXPORT_SYMBOL_GPL(pci_dev_reset_iommu_prepare);
+
+/**
+ * pci_dev_reset_iommu_done() - Restore IOMMU after a PCI device reset is done
+ * @pdev: PCI device that has finished a reset routine
+ *
+ * After a PCIe device finishes a reset routine, it wants to restore its IOMMU
+ * IOMMU activity, including new translation as well as cache invalidation, by
+ * re-attaching all RID/PASID of the device's back to the domains retained in
+ * the core-level structure.
+ *
+ * Caller must pair it with a successful pci_dev_reset_iommu_prepare().
+ *
+ * Note that, although unlikely, there is a risk that re-attaching domains might
+ * fail due to some unexpected happening like OOM.
+ */
+void pci_dev_reset_iommu_done(struct pci_dev *pdev)
+{
+	struct iommu_group *group = pdev->dev.iommu_group;
+	unsigned long pasid;
+	void *entry;
+
+	if (!pci_ats_supported(pdev) || !dev_has_iommu(&pdev->dev))
+		return;
+
+	guard(mutex)(&group->mutex);
+
+	/* pci_dev_reset_iommu_prepare() was bypassed for the device */
+	if (!group->resetting_domain)
+		return;
+
+	/* pci_dev_reset_iommu_prepare() was not successfully called */
+	if (WARN_ON(!group->blocking_domain))
+		return;
+
+	/* Re-attach RID domain back to group->domain */
+	if (group->domain != group->blocking_domain) {
+		WARN_ON(__iommu_attach_device(group->domain, &pdev->dev,
+					      group->blocking_domain));
+	}
+
+	/*
+	 * Re-attach PASID domains back to the domains retained in pasid_array.
+	 *
+	 * The pasid_array is mostly fenced by group->mutex, except one reader
+	 * in iommu_attach_handle_get(), so it's safe to read without xa_lock.
+	 */
+	xa_for_each_start(&group->pasid_array, pasid, entry, 1)
+		WARN_ON(__iommu_set_group_pasid(
+			pasid_array_entry_to_domain(entry), group, pasid,
+			group->blocking_domain));
+
+	group->resetting_domain = NULL;
+}
+EXPORT_SYMBOL_GPL(pci_dev_reset_iommu_done);
+
 #if IS_ENABLED(CONFIG_IRQ_MSI_IOMMU)
 /**
  * iommu_dma_prepare_msi() - Map the MSI page in the IOMMU domain
-- 
2.43.0


