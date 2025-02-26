Return-Path: <kvm+bounces-39398-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 22066A46C2D
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 21:18:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1772816DC3E
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 20:18:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C51025C6FA;
	Wed, 26 Feb 2025 20:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lgjpW3TW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2077.outbound.protection.outlook.com [40.107.223.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D6425A2A9;
	Wed, 26 Feb 2025 20:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740601013; cv=fail; b=Zdfavd/znstQp6ZLWCS+cRxnRONArNelnt63388nJaSmhtv9cOatRoW8M8rF0TH5cTKTA15zVu6m2+89Lu9IXKsRqIf8TMb75ijaV4R2UKnUQiUTO8Mtbz9b/x0GxIJWxE+O3NdBUVmnJuXusB/vf3wGD6bUAXlJVHKsjhe/je0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740601013; c=relaxed/simple;
	bh=Qu5Mwut372S13myttPITGdgYmfoNnbw5dl9oOKCuLUo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mv/bsRfs6BSYU7Wsz9KJ1R7/Uw6MvGahMOW1cycibVdu3ofP8whnHx44gUYU170XdJyxCzr+QfFtgHIjPOY+JKwGhfmxUH/x4Uhl8YW/66Woyqyx5eRsdMWqw2BI4GCmmyTkBYnboHTfqeVItneN4EwU0zoLtP/fNdv9+jzRKlo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lgjpW3TW; arc=fail smtp.client-ip=40.107.223.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jhXYfssChm5kmJg+zDJkdke3ChYr/Te3jcok/jdQA2BjUV3ZPqozW0MjwyL9XiaAfwfkRCqAGYeb3yE498wQG2sdrHUR6EQ+r4D0iyr93RAep/nw1o+R3Qnq4PARIk30tNEjzm7d46N91P5AgiBl0d6noYvTapJ8ggPHfEO95VCDXiENvZ158FD7lNk1UJUNHKZ+UoZaeZbeT9m0fJXDxmqdsu/umPTxRQyOY3lT4O3qxgJofpVvb3WzekObfbzFDpQUFvziaX7s9dF3HiPqYv0GYG4Zx7h9UY+ICG5mH094KOs7t30xgjKZKoM8vIqRAsnBFMIM8mkzrkUjwpp1mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Aeg6ooCKjnGO8bNeBStLml4+yoRoi1aSlEKouCdPsic=;
 b=cjHVAH0hHM2hqRxW0WodeU46KgzEzRSE08MarMQX7MKlhrR4+fzuU6oMHc5+HG0d99RUomOEsKQyXeBHuJqJBBPi8V/CCamDpe5UwYSBU8/A+bkhatFDAg+gC2Hi2RHatvvKJt9WNuwtnZk7tW/NCF2yoH0DyZKE8r/Z3Yk6xaSXPig9IrxzB5y28PrYoUL+WQ95417uBDiODKPYCbxwKhEXa9/CVr0yzMApv+sIffzH78PeUR0VaZ7pRM21sgplYJUdtLqOMgmFtYdSodRGqToiiIhju1TH/T4qbo8QDcZBOr3NnkyoWg6xytfXsmuX3MHttfPnnn+0TvLerfSFuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=arm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aeg6ooCKjnGO8bNeBStLml4+yoRoi1aSlEKouCdPsic=;
 b=lgjpW3TW91HKsIMeUcCbD8W4AVLSwW8u69afDsfGpHW+Tqow/kEDCHVcCuHerCzr6yzTffa8jI5BWdDErSbgoWqhV8W6pvjy2vpF7mIIWGo/g/dZw12RgPjS9t6NDd3tU9nC7vdXB35krkzGWjqj0hWqtcOMPsrha69EPpR1nuBhgMnO589IUgfJhcZTv/MFcbf6d6ix5mqgDs6HctQ/u6eBo14f6vyBPcK8GQ/N5dz1GMwyHawFPbN5zzE6NFIR9teLOz1zwtbgPebKPOMuH6D9JwEqN6PN90AqOLYRTMrj7lwjWlkklKHhbjeML74iXezJ0YbPvhjcJ1YfbKlKHQ==
Received: from CY8PR11CA0035.namprd11.prod.outlook.com (2603:10b6:930:4a::21)
 by SJ1PR12MB6241.namprd12.prod.outlook.com (2603:10b6:a03:458::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.19; Wed, 26 Feb
 2025 20:16:46 +0000
Received: from CY4PEPF0000EE32.namprd05.prod.outlook.com
 (2603:10b6:930:4a:cafe::27) by CY8PR11CA0035.outlook.office365.com
 (2603:10b6:930:4a::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.20 via Frontend Transport; Wed,
 26 Feb 2025 20:16:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CY4PEPF0000EE32.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8489.16 via Frontend Transport; Wed, 26 Feb 2025 20:16:45 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 26 Feb
 2025 12:16:30 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 26 Feb 2025 12:16:29 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Wed, 26 Feb 2025 12:16:29 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <robin.murphy@arm.com>, <joro@8bytes.org>, <will@kernel.org>,
	<alex.williamson@redhat.com>
CC: <jgg@nvidia.com>, <iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
Subject: [PATCH v1 4/4] iommu: Turn iova_cookie to dma-iommu private pointer
Date: Wed, 26 Feb 2025 12:16:07 -0800
Message-ID: <c51c2543992b686934f7daab56a3f1c6c46ad206.1740600272.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1740600272.git.nicolinc@nvidia.com>
References: <cover.1740600272.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE32:EE_|SJ1PR12MB6241:EE_
X-MS-Office365-Filtering-Correlation-Id: 513b3c9c-a891-48e5-6212-08dd56a27e3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8H7ZD4lE63MBmzrSnWoeedn0q6ziubudiGIAdZADToJSIKjMBbx2sPtHfZDR?=
 =?us-ascii?Q?7rIMb5jAfVu1A33WIb06fN2zJVy13MBT3qZUk/gGgTDVqmlT8m5jFqqmQD28?=
 =?us-ascii?Q?nfI//ds55pK41EoFQMkuKQ3Dlu5W5TRtGXCXrEXM1LXyMun9QWzfyFHnt80x?=
 =?us-ascii?Q?SJpJT+ldRzU4wefWEmL5w3Y+77pbQTkF1bYj3cXa5b7pP0YGDqOXyGoPZQ3z?=
 =?us-ascii?Q?sg5IXdO4CN7J8TVbwJe+cZMpIf4Ya040PhaUTrOjpK9mQzpa4ga6hKFyE2U9?=
 =?us-ascii?Q?zX6KLXz95ydHdy3eE++zCRkzxFxHquvvNxctywDmqGhwLEzxz3C4xF2FWnDg?=
 =?us-ascii?Q?NQCPgeeLxlkzdyYr9Yz5jCzmMU5VE1dNLYJu+aog5eklVhfJHE9+hb+Ynpfm?=
 =?us-ascii?Q?WbZcstjDCGrGDKma9N4ak9FlCaWWOceH7oYUrx+T1hkG++/JJieFDksujaM/?=
 =?us-ascii?Q?L4aXzZ/ckBMvSUxKqHvTjRh3QR0D1VVRWzZu2n1wuJxC/dI0ES1bWRitpqWC?=
 =?us-ascii?Q?gbNbGHV446Gr87Epps773aLYPKS8JsMOsODpIE+0s4BNXsvXbphWQrpNC9aQ?=
 =?us-ascii?Q?QoK4QbddguDS+4nP7I2BJ+2MAdE1qABO+SiOlrY6bjR23kyv2sGWOhGwhMwt?=
 =?us-ascii?Q?lrs+tk78SOvPO5qoK020oENJM9sCoK6fgkOBD7ZhYVgcZ1WZmfoLugkGe/hZ?=
 =?us-ascii?Q?rMn2n23UPXlyKKniaG/qo7keyxLBwSfc1l045s5wJJJNU057pj9ogypFB682?=
 =?us-ascii?Q?k+NlbhuGMDyib16xvOOMlJ0O5E6cKnbqIp8kPhxCYeIUn+96L/7igDe8fJ1q?=
 =?us-ascii?Q?vjXVINsS2TJThWOr0jMBiU8pUxdm0DIkiVG7AVHUUWd6YQfslBDOct1iaaFL?=
 =?us-ascii?Q?DoB3/14XppxvoBzxOA0ukaaxzORY52O1hcGem9zwusT93zKYadljLnznlJyb?=
 =?us-ascii?Q?I8A2Rlxydz4X+UhDqsTwUHPnI6iT+jBR4FDcq0x2eL6hJEJGh/Z4n4nVqGAg?=
 =?us-ascii?Q?3MdccPmHUPfDTlzhEy5s64QD4m6r4tkjDl7PfgR/8tk4cnREIBxhsMlA3Sf0?=
 =?us-ascii?Q?DJVluKySsRXYYNXe4ZncRGPEz7k2+3r8Ru45cEogflWscyyHvsP6rMXLPR3t?=
 =?us-ascii?Q?Fdp6JLBUbUCsKmcSEU8kBky3NUG0yu8J3QuM5aUi6MK17fcBkYyyIIso8Wdq?=
 =?us-ascii?Q?Xweyh4CIwvHk1C85akdesnKC38HvbBF9Z8PDZN+9yS2kwVQXKrxhTq/WWp42?=
 =?us-ascii?Q?MmZzODK5B1TYgzXO14PUCF2jFUxXli3wcfnR6ZM7fI64i5YEZnKa/CCj47ZN?=
 =?us-ascii?Q?Ffhep7fF2C1PeeEuxW8HzHMw0AAoI4Lj8gwje7FTEJWawpp2N9ZnDvumbM7N?=
 =?us-ascii?Q?64MJfbpfrTGZYoXfxaMAT39ltYx8iZZPtQpBYOW72VKuEfcsaArTllq6rlun?=
 =?us-ascii?Q?jPE847VU0Rc5EaexcDLxq5RMWlS1bUNouEkZgigoGQOdm8qK7v2fm7/Nv42j?=
 =?us-ascii?Q?cYydsKiwpxSpGEc=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2025 20:16:45.7845
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 513b3c9c-a891-48e5-6212-08dd56a27e3f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE32.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6241

Now that iommufd does not rely on dma-iommu.c for any purpose. We can
combine the dma-iommu.c iova_cookie and the iommufd_hwpt under the same
union. This union is effectively 'owner data' and can be used by the
entity that allocated the domain. Note that legacy vfio type1 flows
continue to use dma-iommu.c for sw_msi and still need iova_cookie.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 include/linux/iommu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 6f66980e0c86..c2f9dc0572da 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -216,7 +216,6 @@ struct iommu_domain {
 	const struct iommu_ops *owner; /* Whose domain_alloc we came from */
 	unsigned long pgsize_bitmap;	/* Bitmap of page sizes in use */
 	struct iommu_domain_geometry geometry;
-	struct iommu_dma_cookie *iova_cookie;
 	int (*iopf_handler)(struct iopf_group *group);
 
 #if IS_ENABLED(CONFIG_IRQ_MSI_IOMMU)
@@ -225,6 +224,7 @@ struct iommu_domain {
 #endif
 
 	union { /* Pointer usable by owner of the domain */
+		struct iommu_dma_cookie *iova_cookie; /* dma-iommu */
 		struct iommufd_hw_pagetable *iommufd_hwpt; /* iommufd */
 	};
 	union { /* Fault handler */
-- 
2.43.0


