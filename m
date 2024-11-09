Return-Path: <kvm+bounces-31336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B80399C2A5C
	for <lists+kvm@lfdr.de>; Sat,  9 Nov 2024 06:49:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3D3001F22345
	for <lists+kvm@lfdr.de>; Sat,  9 Nov 2024 05:49:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26077146A66;
	Sat,  9 Nov 2024 05:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ABe8A5CN"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2057.outbound.protection.outlook.com [40.107.96.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B0A143C63;
	Sat,  9 Nov 2024 05:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731131349; cv=fail; b=F3ISVQdx+njaGXW++yCRJCRZ3jhSMTSxwQf+oF8tgIcFimzS1X33csoWoLpjIGHZ7/+4kDdgjAadIHex5s12wluBVNWmX+qWmaZP1lHD1VJAC4MHzvWUfmJwhgyPcjtKSI43RUDUHXBh5pWxDX3hbqC0ADEbAoB0v78flC8lNZM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731131349; c=relaxed/simple;
	bh=eZLahTikRNRUaHH4pZY2Hw9vVCJ6h1D4j0g5q8bvhZ0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ytg9RLqJQ7MDDQmJn4LMzqYb4YJqG0HIGD3c7hsf/mDnRpTtTGcnq7DoaUKMlHmEJaTmk9lOGR9/S+ZjNl6CYOqMmIM3PzrcaSo9skB+NE4W2K2VxlAWsABAbTYIZPv/j+YcKo7hpm/zuGxGX5zQLCjzbc2YpVg9s+EchB07IIY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ABe8A5CN; arc=fail smtp.client-ip=40.107.96.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uP9PeMqGyWX6FsyOgYUqEvv/zYwq2y4WIx2SnVAdeSqRgAztttpifcrtaCYKBPFnxq0kPLqIrpEcIaG8C0hHIlg2u8ppzd55NSaW8/c2zm2UmTLj/3j5JCJBP/A8t5+YHPYRiW6c47Iu51/BZ8bjO8JF8+rTr1b7IGspypCkj0w0EONXUdrJhiFx4hG0w7KPdIcEjXUAMDjoResiBi3md0rWp25CpEt0dOZLIV6s22Z+y47WaBNkOrPmFy7gCMbMkIT+tVppDia7e+ufoRu94HP03VTc0ybyi5V37lz70iQsKvDDBDNbo9hjQTQ5T6plK5EQwNnaeB4nJ6ymZUpsSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XSeFbvMpl5Yo9vXT0GJbfiR8ITLquv0llC5EFsauH+Q=;
 b=Q/MF8RseTUJZzj+6OREdyQK7I+h7AIk7lHhuclH8KGVSsfB+f0I6KrcLS3R7WoqveCK64Ca7qZx0+bZBrwiZ1ZKhqxCXVZdf5GqdN3cXAjQoj3lFEzfSXU1HdhyAnh2LIzGpAsttRSny3XT+cITJoljSsvyOus3kHYEOjWcNHLiTIvJQE/Azo5jJL85Q3XMoAYY8iEWhafiftM4/nyc2ppo+LJ0YIrm4VglZdqxsrZ6/vFSAx0cw77nfsQjvI1yVYYzJ8Y/VHvrgKARclq3sp+XsTSi8hJ7NtnHu43wkV4/JCm22BADqqFy1Jnjet7aBhK+EX2eQFmLav0rXuSzRPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XSeFbvMpl5Yo9vXT0GJbfiR8ITLquv0llC5EFsauH+Q=;
 b=ABe8A5CNg4f2JUiwPo5a4XC+M8LeIGGugk0pFY/ApX5tYMHf5IYnSsy+laCkTvVxBbbsvzKkiVbeNddGdnLImnPld/Db5t9Gj1ihElYmFOYKqnCESLHXZ0p/RO+0BcQ4+j3rcJlM0i+RMylEQwylJPQzBzwCP7Vl2k6/c9JkP/wibV6O32hyWBg2Eb+20G7/hM7TXKnwbSDHTN7pBxH5VVzMuNQFZfUrxHAtUIF7jVFwJajLQe6uNCzLKJ4lzF7VWNwM4jP7BXOtJG2PmTS8Coo6wQRfJbC6mQv4WSClD46d4K6PFM6Ww9CibZ+CLW5jly65r8sGFxG679NvlZnISQ==
Received: from SJ0PR03CA0226.namprd03.prod.outlook.com (2603:10b6:a03:39f::21)
 by MN2PR12MB4390.namprd12.prod.outlook.com (2603:10b6:208:26e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.21; Sat, 9 Nov
 2024 05:49:01 +0000
Received: from SJ1PEPF00001CE9.namprd03.prod.outlook.com
 (2603:10b6:a03:39f:cafe::2c) by SJ0PR03CA0226.outlook.office365.com
 (2603:10b6:a03:39f::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.20 via Frontend
 Transport; Sat, 9 Nov 2024 05:49:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF00001CE9.mail.protection.outlook.com (10.167.242.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.17 via Frontend Transport; Sat, 9 Nov 2024 05:49:00 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 8 Nov 2024
 21:49:00 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 8 Nov 2024 21:48:59 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 8 Nov 2024 21:48:58 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <maz@kernel.org>, <tglx@linutronix.de>, <bhelgaas@google.com>,
	<alex.williamson@redhat.com>
CC: <jgg@nvidia.com>, <leonro@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <robin.murphy@arm.com>,
	<dlemoal@kernel.org>, <kevin.tian@intel.com>, <smostafa@google.com>,
	<andriy.shevchenko@linux.intel.com>, <reinette.chatre@intel.com>,
	<eric.auger@redhat.com>, <ddutile@redhat.com>, <yebin10@huawei.com>,
	<brauner@kernel.org>, <apatel@ventanamicro.com>,
	<shivamurthy.shastri@linutronix.de>, <anna-maria@linutronix.de>,
	<nipun.gupta@amd.com>, <marek.vasut+renesas@mailbox.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: [PATCH RFCv1 3/7] PCI/MSI: Pass in msi_iova to msi_domain_insert_msi_desc
Date: Fri, 8 Nov 2024 21:48:48 -0800
Message-ID: <32fe78c5ec4a08bf0414d80ce9ed9121270b9cb0.1731130093.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1731130093.git.nicolinc@nvidia.com>
References: <cover.1731130093.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE9:EE_|MN2PR12MB4390:EE_
X-MS-Office365-Filtering-Correlation-Id: 11d964e9-49a7-44e8-c6a8-08dd008235bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Iwzk/sRcq3Sfumzqc/pu1OcERoHst/OzZ6ikpkHYwAg0+UivW3AbAHlAeXAy?=
 =?us-ascii?Q?euztMLKZVZG7C/Zw0fwIG3VPTVji3aOh+XTm97mKN/X6H7A5L6rpMQwBSBx8?=
 =?us-ascii?Q?6nvY9+M3OL7wwGCglkdr61xvG9POWqvycIknGPBz7UPMM2K7wqZoBcG9a8rU?=
 =?us-ascii?Q?4tNieO7egF7FqRXQEHObU/rTTYxrWj9FZeqmW/liFDXxD8n9XYDwrdZ+HP48?=
 =?us-ascii?Q?mIGAvUuZcYWiPPgjo5QP8jkgpzNNJLVM8aPGkrelgqOxClUXoWJAmZqnAdfK?=
 =?us-ascii?Q?KIxFuabxpNlpqHBJgzrvnTlyQjr79M2eR4QR0P3jQztC8UtM8qUrBgAsBVLm?=
 =?us-ascii?Q?GQ99zksmcFBNKTdjeFbSzkxggmFiZrXLukjTQ3V2QepSZESzN6d9YqVp2o6T?=
 =?us-ascii?Q?GuP7THPRlaPA0aZBUHVLkOR/evsDfI5CJI8HAijE5w7zy6xQ0LTApwSutvpS?=
 =?us-ascii?Q?gkjoyL014TgWZAFiL5XPIufOrsku4dJUUYw6oiLX2zm8doPAEZYQ9OLQLBgN?=
 =?us-ascii?Q?x57j49krFKpTJ5TB/n3tEJC3m75YricxbRn9clYmH0ZgS0YnmyQEegFArdMi?=
 =?us-ascii?Q?hl0nP+H3BtZfOQouCO6rFQqOy2ywJDj+9F8twXq553CzraveNFTD3Z4MhFOS?=
 =?us-ascii?Q?uwVV8vThi13/7zABwpc4CSNf5lug/TwAFkdeA6mXCPdQMS1hbdInFup/EuM/?=
 =?us-ascii?Q?0Q9eLuC9uinGi5P6cqwB7RQ/gnv+tsNtZX8UrGtMv2csvYBCF3m1fRHzxf25?=
 =?us-ascii?Q?Xg58jUnIwLqv6ZD5C9KSVf5VydsWfDqZoGL35EF8GyFptPAEzSaUjm9Jg6eb?=
 =?us-ascii?Q?/JKAfAS2t1MCnBMxYGkXby82oZPb8dvt3Evd5uRBorJShui+ul5+RjzjW5WV?=
 =?us-ascii?Q?lhLCHRcnBDJjDmCTYyNOfGV4oIRcHGEOmjJAlL1jHO9Av3RcI0rCvrZnvoyW?=
 =?us-ascii?Q?gwDFMQioO+qL5LYXw3uxUgs/Mpsq5fstntra4N5853eY3jYSRRPiNp7wzW7x?=
 =?us-ascii?Q?/S879AlLs8bqdnjpzWX003so5mTiTvTkv1aEg74I/hO3HaEACw/6Oy7kruZ6?=
 =?us-ascii?Q?3o+Tkj2IcvFJBFB4fVkRZCZKH+YKJuJjaIfrXc8m/7RJuZLJVX1SqQFW5qcI?=
 =?us-ascii?Q?YE9XE6VdmXJQC6Mn9qrGQwcGSQsXnnUwV7jfqex3HFnnvgcwJJGfKg1v29sv?=
 =?us-ascii?Q?KzTSIvc9K0VaAWGBnkWv7EwjkHzpPyLDF06cM54A1ydolfN9LbY+a68rm+uj?=
 =?us-ascii?Q?7Xd1mP3mxgK9apVWS9Ty7qLa0GfcSREPEp7/h38Q0krUmDkbw/n1yLCgeLe4?=
 =?us-ascii?Q?L+1Mx+BChu+TJa3YmmG2nSSPCYYwWi1sdAdHg9k3ZxGG5/Wip+5hRKK3D4WU?=
 =?us-ascii?Q?7Ex21NqCU2LOn4UB/0jQv3PLRSryLOFmjPOfwWZniDNC8vgAQA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2024 05:49:00.3675
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 11d964e9-49a7-44e8-c6a8-08dd008235bf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE9.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4390

msi_setup_msi_descs and msix_setup_msi_descs are the two callers of genirq
helper msi_domain_insert_msi_desc that is now ready for a preset msi_iova.

So, do the same in these two callers. Note MSIx supports multiple entries,
so use struct msix_entry to pass msi_iova in.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 include/linux/pci.h   |  1 +
 drivers/pci/msi/msi.c | 18 ++++++++++++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index 573b4c4c2be6..68ebb9d42f7f 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1652,6 +1652,7 @@ int pci_set_vga_state(struct pci_dev *pdev, bool decode,
 struct msix_entry {
 	u32	vector;	/* Kernel uses to write allocated vector */
 	u16	entry;	/* Driver uses to specify entry, OS writes */
+	u64	iova;	/* Kernel uses to override doorbell address */
 };
 
 #ifdef CONFIG_PCI_MSI
diff --git a/drivers/pci/msi/msi.c b/drivers/pci/msi/msi.c
index 3a45879d85db..95caa81d3421 100644
--- a/drivers/pci/msi/msi.c
+++ b/drivers/pci/msi/msi.c
@@ -282,7 +282,7 @@ static void pci_msi_set_enable(struct pci_dev *dev, int enable)
 	pci_write_config_word(dev, dev->msi_cap + PCI_MSI_FLAGS, control);
 }
 
-static int msi_setup_msi_desc(struct pci_dev *dev, int nvec,
+static int msi_setup_msi_desc(struct pci_dev *dev, int nvec, dma_addr_t iova,
 			      struct irq_affinity_desc *masks)
 {
 	struct msi_desc desc;
@@ -312,6 +312,10 @@ static int msi_setup_msi_desc(struct pci_dev *dev, int nvec,
 	else
 		desc.pci.mask_pos = dev->msi_cap + PCI_MSI_MASK_32;
 
+#ifdef CONFIG_IRQ_MSI_IOMMU
+	desc.msi_iova = iova;
+#endif
+
 	/* Save the initial mask status */
 	if (desc.pci.msi_attrib.can_mask)
 		pci_read_config_dword(dev, desc.pci.mask_pos, &desc.pci.msi_mask);
@@ -349,7 +353,7 @@ static int msi_verify_entries(struct pci_dev *dev)
  * which could have been allocated.
  */
 static int msi_capability_init(struct pci_dev *dev, int nvec,
-			       struct irq_affinity *affd)
+			       struct irq_affinity *affd, dma_addr_t iova)
 {
 	struct irq_affinity_desc *masks = NULL;
 	struct msi_desc *entry, desc;
@@ -370,7 +374,7 @@ static int msi_capability_init(struct pci_dev *dev, int nvec,
 		masks = irq_create_affinity_masks(nvec, affd);
 
 	msi_lock_descs(&dev->dev);
-	ret = msi_setup_msi_desc(dev, nvec, masks);
+	ret = msi_setup_msi_desc(dev, nvec, iova, masks);
 	if (ret)
 		goto fail;
 
@@ -456,7 +460,7 @@ int __pci_enable_msi_range(struct pci_dev *dev, int minvec, int maxvec,
 				return -ENOSPC;
 		}
 
-		rc = msi_capability_init(dev, nvec, affd);
+		rc = msi_capability_init(dev, nvec, affd, PHYS_ADDR_MAX);
 		if (rc == 0)
 			return nvec;
 
@@ -625,6 +629,12 @@ static int msix_setup_msi_descs(struct pci_dev *dev, struct msix_entry *entries,
 	memset(&desc, 0, sizeof(desc));
 
 	for (i = 0, curmsk = masks; i < nvec; i++, curmsk++) {
+#ifdef CONFIG_IRQ_MSI_IOMMU
+		if (entries && entries[i].iova)
+			desc.msi_iova = (dma_addr_t)entries[i].iova;
+		else
+			desc.msi_iova = PHYS_ADDR_MAX;
+#endif
 		desc.msi_index = entries ? entries[i].entry : i;
 		desc.affinity = masks ? curmsk : NULL;
 		desc.pci.msi_attrib.is_virtual = desc.msi_index >= vec_count;
-- 
2.43.0


