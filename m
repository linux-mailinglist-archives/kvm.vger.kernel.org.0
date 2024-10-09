Return-Path: <kvm+bounces-28292-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14A39997304
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 19:28:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6AF8282A13
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 17:28:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAFE01A2630;
	Wed,  9 Oct 2024 17:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="c7JBs9fe"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2062.outbound.protection.outlook.com [40.107.223.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA4D197558;
	Wed,  9 Oct 2024 17:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728494895; cv=fail; b=CB1SFyIQytEO8C0cs1oDhXkjYHzar/wcgIxXNnrB2C1/me1FvTsztCV6QmlR/szG48JOJm5lZPYchTpasmnD/AzskU7QooiMND+hOaqCdf5GZNpwj1R6ZfjiSZ/3syEN5V6AFwz+otalKJl1aY75pUrRxYYxAdHr7kJSW2JkC+8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728494895; c=relaxed/simple;
	bh=QX1vNjGbnYSfzUTyeV4EwzTUn7NydqdVoDa2SgKzf4Y=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aPdlvayKEgOPJE1nNMIC6n/kcbmdO3jCaNYm/NT5ZUiG1o+x5/iMubmS7NEo097BD6a3t9WIpr3Ptg+BbpZfy1lCYCySeTEzZ2/Sf4rOMa7DiiUq2LwSMYn6TLAwsI2/NBQ44qnmLGiRNbiUWCN/7T3VreKvxaRNcDPIHu3/jMg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=c7JBs9fe; arc=fail smtp.client-ip=40.107.223.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u0wPjXVmEUXEkNpZirP2qXWiWAyDlicEL7gDiJK7EcGHxKvjWNyks9ZbjVolUtM5Le4sU4qvigRGVR0bLDbkgr9TmpJIIHtRC74ORF5WnRP1X0BVViEHG8t7ByW/ZPqhxYCd9lHoJSgJOf70DZddGzTU35SHSxrrP2cS83/K8mpm8XP+Ecta0oS9oC6i0uadD3UmuGTx/ZiDq8gIVut7g/2giOpFLlY5PEmlWl/sUDto9Y3j39hHrCGo7TLTay1VPTTfGkATYCzZwYfVW8OECg7OWGsy2egovq6ypbwj0+EArDawWdEvuBOQeFcMKKafclOI1JLnPiwDSlRMPAxVcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9+I8g27+zxsgg18AXgSUIlfkq5h822uAKrQ9GtEmcfc=;
 b=rvJyxcfa3slLsMBEl91jjMytVNYhhE/MFPYGtl/vKBzujOOG8Dab4WLh4O9fm5pzKo9NzPYnX/ZXuqdolAkouyaG6tCLyURLwSbs0xrhj2SYR2Et4VR8sQTbqh2L7ZdFc28SjtRhUZlPIwTmGKWuvkkqZ9hRYQVssChP5SZq/cCLv7b0s3IcQCdrk2iHnCRlUPU0ro4aulS3cP3G9oAn6uriCRjqdFw+hMSgVD0UB7P4DYBwojtx76Mafkn59nhZQ1bF1N4M16K1M2JfwtJwKfrShoKIAVC7jNKjPPVy38fEDjioaE50XUzufB1NrVqCOKUAox/pXX8YKbglo7rIjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9+I8g27+zxsgg18AXgSUIlfkq5h822uAKrQ9GtEmcfc=;
 b=c7JBs9feX3S5zVcjsJw4x53gVhUYJUR/i+SY/ET9ENJ4PDrtc6MhuZd9ECXCgJbE7FBI0OJBfSefOkz5L5rudI79ZEeffN2RwRog/JmO2WNbiqyF42bYDJYfHkIel+Hf+SXkabyqJFktkB7Ekb8liUTMIJ8W6MXTKwKEXTaUn/S6lCZ5KfpdIVkvEeBs9rl4ZEHl64piy939mouC34PuDUNgTO/FYzk3tGUBv5TO/N74op/AnwxdvXaxx2wFUVkWo7aY713aRAokXpQZeDgciogE57gLuUXlB9PhbqV+2TFjX7AihgV3TAFHxjWcJSP6yghUKCr2OW33BEyWdd7W5A==
Received: from MN2PR02CA0010.namprd02.prod.outlook.com (2603:10b6:208:fc::23)
 by DM6PR12MB4402.namprd12.prod.outlook.com (2603:10b6:5:2a5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.18; Wed, 9 Oct
 2024 17:28:06 +0000
Received: from BN3PEPF0000B36D.namprd21.prod.outlook.com
 (2603:10b6:208:fc:cafe::3f) by MN2PR02CA0010.outlook.office365.com
 (2603:10b6:208:fc::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.17 via Frontend
 Transport; Wed, 9 Oct 2024 17:28:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN3PEPF0000B36D.mail.protection.outlook.com (10.167.243.164) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8069.0 via Frontend Transport; Wed, 9 Oct 2024 17:28:05 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 9 Oct 2024
 10:27:46 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 9 Oct 2024
 10:27:46 -0700
Received: from Asurada-Nvidia (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 9 Oct 2024 10:27:44 -0700
Date: Wed, 9 Oct 2024 10:27:42 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <acpica-devel@lists.linux.dev>, Hanjun Guo <guohanjun@huawei.com>,
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Kevin Tian
	<kevin.tian@intel.com>, <kvm@vger.kernel.org>, Len Brown <lenb@kernel.org>,
	<linux-acpi@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	"Lorenzo Pieralisi" <lpieralisi@kernel.org>, "Rafael J. Wysocki"
	<rafael@kernel.org>, Robert Moore <robert.moore@intel.com>, Robin Murphy
	<robin.murphy@arm.com>, Sudeep Holla <sudeep.holla@arm.com>, Will Deacon
	<will@kernel.org>, "Alex Williamson" <alex.williamson@redhat.com>, Eric Auger
	<eric.auger@redhat.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, "Mostafa
 Saleh" <smostafa@google.com>
Subject: Re: [PATCH v3 8/9] iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED
Message-ID: <Zwa9DmEduyLjiB2U@Asurada-Nvidia>
References: <0-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
 <8-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B36D:EE_|DM6PR12MB4402:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f979c66-b350-447c-f261-08dce887bc0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MqwkRvBjV3ZUFuV0xqyL+lWY/U105OQfJxjk8zTF/J3zkhtQAlCMUnrdkUvV?=
 =?us-ascii?Q?Mn7/NfSmm2y+UN5zZyhe1a5cJO20Qonll1t+U2nWbjTZaVW+qcYuzaw7OI/0?=
 =?us-ascii?Q?Xe50bFzDZK+aUNcI0s053pDaly/8+KFqRR8jzPKQaJeuClT4LOuQ0hYaofzl?=
 =?us-ascii?Q?+ZaQfIFLzPXsURYCFQPeciqDvlPxrait8rIHAa+vdJImTBXB1C9RVZf0gDpR?=
 =?us-ascii?Q?30Pt4slxxxKPXC3ulOzuRfiAWSFJWggzU79YPDq9Di1ecbSQadmi5iDFgLFX?=
 =?us-ascii?Q?nYSZPLTYqgPsxUGgrdxqQf6VBedyir4d1UwnY01fBDJgqI2d8MyCwTENgD2+?=
 =?us-ascii?Q?gVLWP4RqbPl3/zZPnP5uQDBCC3Z3WVVU9DrWfCK333k/ZDHbIMu9fMZ/0s6j?=
 =?us-ascii?Q?pJUr0zu7XE/36r48mgfZqI3wz9iTKToshj/n0Odug3+hHY3daLVAOGJ6+qtB?=
 =?us-ascii?Q?Z6gEC29AKuCDyu4ELFgSQnTCGG2GRM0SdYga37Vne/HCmRY0CjomkOVmxVMZ?=
 =?us-ascii?Q?IZDJrl+9O8G1gCcweqoXqnUbjR1IwjvSwyMPuGVCuvusaFbtd0v7ecfn8cIT?=
 =?us-ascii?Q?V66l9Jy+tI/IO9xLlG4gb+MUiNI+/N2g1bJFkQxaSf3ueVDyWud9njRgIvVu?=
 =?us-ascii?Q?sMUzR0uwYRBL0vCCyAcR1dGahVRNMkRA7hNWQo9DAEviK5zHAJ3xbnisR6yt?=
 =?us-ascii?Q?pN5GHi6d/LZFsHVYmCq7daTucxrcNmDVKjAwB4EGLVITwSADNwqGP8y5BYl/?=
 =?us-ascii?Q?yvBGonleCwTaEo51isTpzpqM4qXlW+nY0Cw+8mVgY2Oi3ERl3IRFyoG8QMSj?=
 =?us-ascii?Q?F0x7mRdsB/u24kfenrkVTNEFzvf2FQWobWrkqhm+ti2jfrv5o4fho80ZXqiK?=
 =?us-ascii?Q?4l1N5Qz5Go/iigT50Z32/UbFhiIvHMpWZXsMM43eJnh+ZcmJzoL6kCQd5GqB?=
 =?us-ascii?Q?i50oaYsNoy8Hm2sw4OrR7aZ7JQgN3ecTqpUK6t1rI15nGKWG4hycyuBSOV2u?=
 =?us-ascii?Q?ExNDMGcWBU3iYy9iamGI8eoSvxpTM4yyO8CFD+0EaLjQ0r9K5tk/QLbTYv1V?=
 =?us-ascii?Q?7HfiomLEOFlk6XIGtCq/vknUHeqMnEIWRfmtB3U+l8tfv4xR7TfvTcmhnlb0?=
 =?us-ascii?Q?PUXmkFtuKDZkDG8lN4H04D0OOkv008t+f7uRE76mQAlapY+2h3rs+QFPcpEN?=
 =?us-ascii?Q?By1mdmbh0fMi5Dryc9oO5UFeBwpfnmQUxic2FjKEg6fDGq/V37Iy4Kthce+x?=
 =?us-ascii?Q?KSJhRgIR+HzH+MuuxiPUtBQvRFDgG0dsocOSSwlH9LhKVJU2ORkOHuj/33qh?=
 =?us-ascii?Q?dzUZSA6aSRT2Kyamsex77pnefPzakscYUBgQRDgB8plGZTwIJG4wwHZPNK9B?=
 =?us-ascii?Q?scpCL2ET0iWKz60RTnf1J/kc/zvq?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 17:28:05.1127
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f979c66-b350-447c-f261-08dce887bc0f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B36D.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4402

On Wed, Oct 09, 2024 at 01:23:14PM -0300, Jason Gunthorpe wrote:
> For SMMUv3 a IOMMU_DOMAIN_NESTED is composed of a S2 iommu_domain acting
> as the parent and a user provided STE fragment that defines the CD table
> and related data with addresses translated by the S2 iommu_domain.
> 
> The kernel only permits userspace to control certain allowed bits of the
> STE that are safe for user/guest control.
> 
> IOTLB maintenance is a bit subtle here, the S1 implicitly includes the S2
> translation, but there is no way of knowing which S1 entries refer to a
> range of S2.
> 
> For the IOTLB we follow ARM's guidance and issue a CMDQ_OP_TLBI_NH_ALL to
> flush all ASIDs from the VMID after flushing the S2 on any change to the
> S2.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index b4b03206afbf48..eb401a4adfedc8 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -2614,8 +2624,7 @@ static void arm_smmu_disable_pasid(struct arm_smmu_master *master)
>  
>  static struct arm_smmu_master_domain *
>  arm_smmu_find_master_domain(struct arm_smmu_domain *smmu_domain,
> -			    struct arm_smmu_master *master,
> -			    ioasid_t ssid)
> +			    struct arm_smmu_master *master, ioasid_t ssid)
>  {
>  	struct arm_smmu_master_domain *master_domain;

Looks like we mixed a cosmetic change :)

Thanks
Nicolin

