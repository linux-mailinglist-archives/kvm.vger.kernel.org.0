Return-Path: <kvm+bounces-56903-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CBF32B461C0
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 20:07:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 80A041CC0211
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 18:07:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 437C937C109;
	Fri,  5 Sep 2025 18:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oPcaisD3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2077.outbound.protection.outlook.com [40.107.94.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6989303A1B;
	Fri,  5 Sep 2025 18:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757095605; cv=fail; b=ATdvEbqyTtCf+wR2GVroxpYb66dHTcsW82bSgCh0ciO9du6E3AK4MpnVqs0hP41mWVoNZhU+JtX1XVCs6DaZpwXjg0HTxKDafAjR68pp91PFEtLRhA90ZTqp/77S+YwkhBX7GXnfoRynKmCgpRRjL5IWSTCc7H2wg1tMRZj9AKA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757095605; c=relaxed/simple;
	bh=zjjazzdNW2zUt82O3kKmWoJPtEyfAP5P7uN7VOUMpts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MhAo5lumqt1I9Y5ivsJFRwaivNAqaafIYLNFkUPRPafZqFJe3cPiWmuqem8k9M7CkLFDWAvTvjVPrUGMJgpJmuu01rGBBvsplTjaiRZkKjLX3zeG7BbgS9PzRXYYQL+Xu66codl5kdjjltSI8P25GK9CvnDlNYVRbSHMoK8fRQk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oPcaisD3; arc=fail smtp.client-ip=40.107.94.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rROcQ9uAbpWGENlxLVBUweY+rnlwLHGWdUedGwKsOhEY1mROHwvcTayKE3SZcNeWpca7ypKeNghGcwPn0cR16mH7nOwjVrzBpi/KLpTAx5PHX1D5IHPwnX9e+pD9POUbbbEUDJL6nGSUuu8QhqMKfOndOOyZO0D17bMYgp10BO4Ng9AiHj2ySR0oaCephGJVaVHqegZUDYu8cEFCSnnd1u6w3jUvOHpSQfzzdnCxdINSvthld2xddCirrFzNOWSkSfrHSdLhxYHiP/1i6bXAvuEUzSmL913jmrVPTF5GjBCwt83z9tzRRn+QPRihF1I45NxVpk3+1z9yWHQEelcmQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GKpz5qFwgsAE6V7dFiX3bP6z0M90YynfmoV5aqLZJWY=;
 b=igE/a8tuGoHUJnQl6dKvh+13L7FikBuQT2s0AD8CgrakiAh8giX2Jbt8QSHlKIkPPskK8Lp/UTIrAQdrurnMq633pJ9E6cG6NbPpSXNLGFF327N1sWb5M21wqkXL4uFk0dr0twMDH9yXFYwlfw6clFSKFVPEVw9dH1dOE5/Jk6oh2SNcdVKVYqhaGYth+1/Tw09AZCCw38DsFPWaa6F8TveU4zccy8N2qnxRkTe/fi+z42Y9xhUuWOcCWRpYigsoZiYPRMEEBVgny7dGRlLjLUGLJMr9R6ic853yiwH2o5/KsZrwQfIjGd6//yvmEKat/W7Q5Mg3KkMNuE/ZRwn/ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GKpz5qFwgsAE6V7dFiX3bP6z0M90YynfmoV5aqLZJWY=;
 b=oPcaisD3Jq+S+rwuH76U/maPCEgq51+TMHRfkjRryeiUJ6G3aHmbHSOf0rsodhSiQdIaXghsjCGDMuBJJ+vLOSwMwvHM9b8maFHCo9WDFDdAAUyQCm5h9u0ZJ5OehQOtRznDC9UHvxt1Pd1tYpqtC5VUBP1aaONz9c4cPB+vSm4jPLTmWVzU67D70qjtEFoa/dBcselnljuiPdmUMS9SaN3iJxc+VGwR8XeqNhARy2M96uwm+/1fF2GavZXlWzSWnj42RWmTya7Tktk3hsM/3fHi8cOejWvcbyBNobxbtfJ/Pihn7qgSfla452WCxqr90fFyw2Bsa6eiJusaQ2QSDg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by SA1PR12MB6776.namprd12.prod.outlook.com (2603:10b6:806:25b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Fri, 5 Sep
 2025 18:06:36 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9094.017; Fri, 5 Sep 2025
 18:06:36 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Donald Dutile <ddutile@redhat.com>,
	galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org,
	maorg@nvidia.com,
	patches@lists.linux.dev,
	tdave@nvidia.com,
	Tony Zhu <tony.zhu@intel.com>
Subject: [PATCH v3 01/11] PCI: Move REQ_ACS_FLAGS into pci_regs.h as PCI_ACS_ISOLATED
Date: Fri,  5 Sep 2025 15:06:16 -0300
Message-ID: <1-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
In-Reply-To: <0-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0152.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ac::9) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|SA1PR12MB6776:EE_
X-MS-Office365-Filtering-Correlation-Id: 5157623a-3c50-4d5e-d783-08ddeca6f1d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?faptjRjnXZ7uJoYKHG1vbadC9R2Z7eWfjfKBDFcKr26Q+R79+t1mNFo7DttA?=
 =?us-ascii?Q?yuFpP94KZqHrVr4Lg7Wqz/borM6TiRbFr2KE6eVBMg+WsjQ2Jl8MLQNhIByD?=
 =?us-ascii?Q?zs/nK1XJIn5ET1J2IVfTI4qmJPUNd7cXAtWMRfTvjwAZNkJPFgVsvchLVQ4E?=
 =?us-ascii?Q?pu4TaNbrW9OFY1nrvljRXZTqZMEArnbHm26Jdwm8H/nCMEFAoCpU71/qsBYi?=
 =?us-ascii?Q?3GMaQUn2YTgRcaF+iC6CZhWYW0kORBqc4d2WzKuGEo74d5IwoEyiuZm3lmZ1?=
 =?us-ascii?Q?cNsd9l+3DMQNh5TdYF4XuO8gq8cmTz5UWX4BnFEXLF0/Re2uDbm4A5vdNObf?=
 =?us-ascii?Q?Fi+5Kuc5NKlrlQnXBNjxyCG2fTSldPk8Dy91YO/+77A7CstaW1WYrw+s65+y?=
 =?us-ascii?Q?gEwEXBErwRILTmraQfwV2UlGgAdOi3RXcNgqXzH3bi5cSdLRiezXy9FS5HOz?=
 =?us-ascii?Q?Wlruxp9oqvrBVhSA+ryhhkZ14/QsKcS5Fpt+xIBuZ1Xu27rGHnVsndkySaxt?=
 =?us-ascii?Q?3++VJAN549pyYM7odofqU6LLxKbw5fXz3qExbjzC205HZC8f+fUiTpb4LjwX?=
 =?us-ascii?Q?mBiY7Z8J3qeHV9eh6DxIs/MYwbe5sQuCC5bYY4U5nQEKV0dpIO4mkDCwzFQk?=
 =?us-ascii?Q?Rn/hVRyioFI/Sgy+m4IXqgeW/Q4mj8mAOQ8vD9x4+SOXCNhFCANoA6+B+8ln?=
 =?us-ascii?Q?IQCC0r6AO3zEjdRtG9qkGMfeW8B/yuvYHcltx4ysIhH1MX+U9hWEMuUW7YBY?=
 =?us-ascii?Q?/kTFfkwfoodFRj2rr/POHb4li77vRv9xXyoFJFj20BLvkWZAydkxqx4EW9Cu?=
 =?us-ascii?Q?nBZGLz2dx6I3ujcDIInKW9YbX1mW2wudVg40SQ8ORjsVZAFUbyMSmExiIfLZ?=
 =?us-ascii?Q?2D6MndaYs3b3PwGkRqA31RIvsjFlqHNdtqGJiBWe6HkKpJMWN7ah3rGWzUOd?=
 =?us-ascii?Q?HzNdybM4pPg6dAeoIfidzkrLu7LRYj0h3Nt8vndc5rLTpAavuZYEz+xsZ9u0?=
 =?us-ascii?Q?P8dqrwtwSFPtND+/vGQgDsbRfD1VyHKrU4WrK3rksRjGu6RK0tqVAvSO2GDu?=
 =?us-ascii?Q?CF0KqbkO6AaVz9OcSD541vlaHTtlQuXcwpXHLERRqDM/vpVuyHwmBJpFy5VH?=
 =?us-ascii?Q?dWv0+WDyDVc5k1b8N/zatGjz1Dr1Z13QGOWIydtk+gUuOJUSOPeDuJy0lWsk?=
 =?us-ascii?Q?2y+aUVzjqFLjY62qnsKUpQK403XpXKuzRRrYWdKvlJ4PdrEEa3WgCF6gXlRY?=
 =?us-ascii?Q?L4924MtwMo/fLAbJL6Q3CRej2+SXHur/aUSrc3YtvqDLHe8wFF3Uo7jXHhxF?=
 =?us-ascii?Q?kQ34OI6mLcbsPxZd2WbpZzRwle89m2vWttW+Xvn/Wp3DxTcBmgcE+F5J16bJ?=
 =?us-ascii?Q?iJVr6LAdD+s85Z1FsevWbUo8ivekDY1VE6JrPpL+12K/ccC7a3SlKtjOGvU4?=
 =?us-ascii?Q?YaMUuLVqZV0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KKNEIommCU7p2j+K1ZokdbBQqxjYHRDx4AfvHUWxGSVoLe8ixhp16Glix4fd?=
 =?us-ascii?Q?8SfluOE1tPPAlofrOw99OkD4Fm/qpKWFC9QPCbncJ9NTxY1ePMRbIsyMtwTS?=
 =?us-ascii?Q?M7l7oPcFugo+qXTNTCUONap8gfuptdjycT8MrKpd9oPauCGhMimaW4x1jOq1?=
 =?us-ascii?Q?8PC+wTVLbyqGHwKiQkD1m97X+baaQ1BOXQlUimPB6BWMVOVWG9bsWFeKJXpY?=
 =?us-ascii?Q?UKiuosZeDvyVIrbGGgV0YVpfM4U13fyZz1xXT3r0qNnNFpguZ6plvqiRQzPc?=
 =?us-ascii?Q?TqQY0A2pWlPR09V8wZl4l8fOhxDGj9DVytQ3NHslrfWpMwzw3g9fsGVuilgB?=
 =?us-ascii?Q?Ff7ryhmnA3JnYR+Vuddx78KP/fjSMh0cUGBuEpZTKCjQTncEiwi6dRE/mBaK?=
 =?us-ascii?Q?AvSQL++XXZljAprmCMvpel/cpmOyf63xY5z8t4o+8O3muAYw+qL9Tb0MzUn+?=
 =?us-ascii?Q?ALxP7nqhHo1nvfR5gjPeeokiB9/zz00buGriP3AMDp9fkWHb+czhZprWFu2H?=
 =?us-ascii?Q?MrySAd/o28j9XMe1f/QMQJ8gHDI4MNFOwe22rQeAVA5Xd3buKNYxevzjAkfg?=
 =?us-ascii?Q?1l3+ZtBGCiSsHSmPe8UJKj4/iHICBIqisxoEWXDnmoNj0+/SgL+9dHO77pFh?=
 =?us-ascii?Q?PCUzZf5lDFsuJkLO/hPARwTr8BNDYAATVX76ZO03ct/6XvPboZRt9T0usTCA?=
 =?us-ascii?Q?zOyGQYez54h0rDw1qRDOVdVi4SNH4pMBp9b0sXdcy1HKhEzKm8oJ73bvVzjc?=
 =?us-ascii?Q?EPwemRrWogimDeMIz+daFG6s6xSRnQ5prw3u7sbKXwrwIxc9ILm7Z5iw6Q2N?=
 =?us-ascii?Q?lPqCqHYLuFjgHlacLDnudgTgIBvzbmL7lc2SM+ZqTj12yDnH7GpmgeDTuDeN?=
 =?us-ascii?Q?yKYPEZWNub4YZOJEwSPVOVAq54C8T0eOo9XKGg+mdVvV660yPtIDaQaj01z9?=
 =?us-ascii?Q?s5h+hTms4aa1ePRcvtuKjs6O+GOaSdiCV467mf+2ujP3mnI9k5wkIH5jyES0?=
 =?us-ascii?Q?zu01TbMFzV5sAJNmvaKY0TpFxBg4Ya5nymC1Q4iP9glVBmuqOvT7K3G27fyX?=
 =?us-ascii?Q?Tw8hB8JFjqpjP6sBmiZiQmpu0k7ISdWXgZC9HKI+GMuVPzAI7ubYRLsx+Hi4?=
 =?us-ascii?Q?B6b3FqaL4C8tNN7s0ETN5tIbVGiUs7ZGQBQ+x2EURhXiKht6R4nSTY5Bl0N6?=
 =?us-ascii?Q?ULmHStgAY15R6f3AhAv+llftEFvN3lb64uUiSiDNIo3573lMt1qDxsOy1FEH?=
 =?us-ascii?Q?bvUKWAti2TKgaVNIXSWR3m0AJFVnHvXe1/BAGPZ08zGfZYEUzWlgRBq9HQsn?=
 =?us-ascii?Q?6uL5W//uXPSsAJQ/j4r/1DwSzrwzQm/J01LSsFM+1rqeTXmN42Pb2UE2QXxC?=
 =?us-ascii?Q?8AWSLQR2fc+9Bh4MSXL1A0DY8xKQmqbV5w6TIFsTdbmkc9h0tkrxi+BwoHZZ?=
 =?us-ascii?Q?rmh1pfu92df8dYPVhAAlouvSSJRfLCEy5gdTW0yVaNBnWYC/TdtDzwxk/IoH?=
 =?us-ascii?Q?8kd6EOuLyXHV3uCNPdNeq8j8kY0e1YUw/rqCocTSpBL0IM8WLgBXkD4bEohd?=
 =?us-ascii?Q?v3KcVmHSZL+lvb7YOns=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5157623a-3c50-4d5e-d783-08ddeca6f1d3
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 18:06:32.3483
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: moJ8RTnWH0rSm8SnJngUfNmzvsqJuJCTzME6o0eKaTbXJ8BAolmga3FIOAAc4MxJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6776

The next patch wants to use this constant, share it.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu.c         | 16 +++-------------
 include/uapi/linux/pci_regs.h | 10 ++++++++++
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 060ebe330ee163..2a47ddb01799c1 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1408,16 +1408,6 @@ EXPORT_SYMBOL_GPL(iommu_group_id);
 static struct iommu_group *get_pci_alias_group(struct pci_dev *pdev,
 					       unsigned long *devfns);
 
-/*
- * To consider a PCI device isolated, we require ACS to support Source
- * Validation, Request Redirection, Completer Redirection, and Upstream
- * Forwarding.  This effectively means that devices cannot spoof their
- * requester ID, requests and completions cannot be redirected, and all
- * transactions are forwarded upstream, even as it passes through a
- * bridge where the target device is downstream.
- */
-#define REQ_ACS_FLAGS   (PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF)
-
 /*
  * For multifunction devices which are not isolated from each other, find
  * all the other non-isolated functions and look for existing groups.  For
@@ -1430,13 +1420,13 @@ static struct iommu_group *get_pci_function_alias_group(struct pci_dev *pdev,
 	struct pci_dev *tmp = NULL;
 	struct iommu_group *group;
 
-	if (!pdev->multifunction || pci_acs_enabled(pdev, REQ_ACS_FLAGS))
+	if (!pdev->multifunction || pci_acs_enabled(pdev, PCI_ACS_ISOLATED))
 		return NULL;
 
 	for_each_pci_dev(tmp) {
 		if (tmp == pdev || tmp->bus != pdev->bus ||
 		    PCI_SLOT(tmp->devfn) != PCI_SLOT(pdev->devfn) ||
-		    pci_acs_enabled(tmp, REQ_ACS_FLAGS))
+		    pci_acs_enabled(tmp, PCI_ACS_ISOLATED))
 			continue;
 
 		group = get_pci_alias_group(tmp, devfns);
@@ -1580,7 +1570,7 @@ struct iommu_group *pci_device_group(struct device *dev)
 		if (!bus->self)
 			continue;
 
-		if (pci_acs_path_enabled(bus->self, NULL, REQ_ACS_FLAGS))
+		if (pci_acs_path_enabled(bus->self, NULL, PCI_ACS_ISOLATED))
 			break;
 
 		pdev = bus->self;
diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
index f5b17745de607d..6095e7d7d4cc48 100644
--- a/include/uapi/linux/pci_regs.h
+++ b/include/uapi/linux/pci_regs.h
@@ -1009,6 +1009,16 @@
 #define PCI_ACS_CTRL		0x06	/* ACS Control Register */
 #define PCI_ACS_EGRESS_CTL_V	0x08	/* ACS Egress Control Vector */
 
+/*
+ * To consider a PCI device isolated, we require ACS to support Source
+ * Validation, Request Redirection, Completer Redirection, and Upstream
+ * Forwarding.  This effectively means that devices cannot spoof their
+ * requester ID, requests and completions cannot be redirected, and all
+ * transactions are forwarded upstream, even as it passes through a
+ * bridge where the target device is downstream.
+ */
+#define PCI_ACS_ISOLATED (PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF)
+
 /* SATA capability */
 #define PCI_SATA_REGS		4	/* SATA REGs specifier */
 #define  PCI_SATA_REGS_MASK	0xF	/* location - BAR#/inline */
-- 
2.43.0


