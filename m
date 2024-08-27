Return-Path: <kvm+bounces-25182-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 41C39961357
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 17:52:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C1F661F23E1C
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 15:52:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE55F1CFEA7;
	Tue, 27 Aug 2024 15:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tvlkB2cL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2050.outbound.protection.outlook.com [40.107.92.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3378C1CEABA;
	Tue, 27 Aug 2024 15:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724773919; cv=fail; b=Z1u4vsllLNTF6wW9jmK3N/QtmBJIhabHK/w1xNoFa7J2/6DRkg130oCshAZBYqN7/UCGdLTgcy5QgeW9xfy6PP79VhUR9nJb7k5OM4Ej1o35qR4anUBIxId0wDkv2sd05fQsgaTjZMm8o52TDRIwL7qIczoWbAFiM7zMny+cCHA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724773919; c=relaxed/simple;
	bh=HeFIv0oNDQoWR7S7W805V7J8yMY8RmolvArjw97BQbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AxbByRSndCXUXGJB9KWKFRcrUKvVSoz8xd15mpdixqbJxzdmd+66b9J8mFvzTl7ECke5RkUiWheKcBH/hPHzmG7352yd7zp+ar0ksbhZTqCELnx0lDMPs4W71qT4bV1AFg3ySWfbhOzaizBaMTM2JHP9NvIplRi19mAB6Az0/0Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tvlkB2cL; arc=fail smtp.client-ip=40.107.92.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KF7fxDDerVSIwglNDARPh3nTuX9sy3UTEHbQR7S5m3IuN9c3qiW2gcUGd0S0MBG6wmGOW5zNOIWIHuYkar6wb5My7JEa6SbP0BmaizyfnkONtIKAGA5ggIotx91ok7gYBsaTIaur3S/Mc2M/t5Pforsl2ptLGIPWF43S7IS4gDy4DJuEUQGu02lCdCdYg1ZXUSrI0A6vD0AMlMGxCVFTumCAjz20OhKdHsJNdJ2150LCcrCIxPZfhWZ5D8WYQwsHi9tV3yt2Ap8bJY0D9OurrtdpKeZLwTt8oZ8UN/CWI1BNgjzPegGvx8SHg38SbIyLQPLgfs0kx8wxUhlzIm4VeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MTEAzwifAPFD26IA6itYKo5ysivjMYWPhikwJ+7Gtyc=;
 b=MD4qBfqHmgT9JPvm6PA0z4pyaimVcRHr1wlNVHvSyV5x9gbBOCEiC0UujsHRTUs0dY2OwLfqM+9RyqrUi/n0Zubg3y2dDBNsDCqQLAsEZJ07NTQ7mFtgPId/wd5UfPGE5n6tTs+dPPqXebLJHEgGYKXqb1bfk1J5hFBg0JLs3/FEetKoogQOUCPWr/GOKj0fQQcNeKcZCScoRnC7mzKHd1fT2G1MUrW6vblEZnyH4SQzanRvxRRtd563yiFz75YHQ31bHIouwa4FfuCIg9YsVYcwQhvYnTt1CQt/wX3dWSqBsOpbDcRfCQpRglcFEEJ+qzDDthz2vMI3zbCOSnAvVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MTEAzwifAPFD26IA6itYKo5ysivjMYWPhikwJ+7Gtyc=;
 b=tvlkB2cLKzwM7X3wlC5WW9lOubMu1o8E4FGRAuam1g/baWQu/WFH07pnTJR5QEQYBkNd3DSMHZic2ms+2GiRLxiekjWGjL6X7xwIfFzSx/9iaFXxpONLPGftneWdVsKSFv/pvYI4A6ZHPYpdzvKRM7HFqEEFsd2Kdv0zGB3Pk80UDhjWI5WsfIuquNsTnBninlnwSS3cPe8sqNOiII2gIsrwMAwU7QkpzsH1NBrKoFSRUJ8aYPvsuyD8LWNZ56Sg9BOB4+Sgyd/9LbxjCjQs6OPJjaGVyh+PLj3p3T577YDs8hrfwZdAAri1JFvZ/6TuOwDxieH0xWbUj5XSXT+f+g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SN7PR12MB6790.namprd12.prod.outlook.com (2603:10b6:806:269::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.24; Tue, 27 Aug
 2024 15:51:46 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.021; Tue, 27 Aug 2024
 15:51:46 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: acpica-devel@lists.linux.dev,
	Hanjun Guo <guohanjun@huawei.com>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org,
	Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v2 5/8] iommu/arm-smmu-v3: Report IOMMU_CAP_ENFORCE_CACHE_COHERENCY for CANWBS
Date: Tue, 27 Aug 2024 12:51:35 -0300
Message-ID: <5-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0114.namprd03.prod.outlook.com
 (2603:10b6:408:fd::29) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SN7PR12MB6790:EE_
X-MS-Office365-Filtering-Correlation-Id: 48b96551-a508-4ad5-efd8-08dcc6b024a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cXZXD+6VGBu01YIf84EfHXKS++Pys3BsQ3+4jI9ghLEzHnnrJFJoHy4pBdf1?=
 =?us-ascii?Q?NubHmi2dQMAnZtSuRrXGEJmoRnQxIh0+6damDSQxLVSL0eJCGucIpfxqmkS8?=
 =?us-ascii?Q?A491ESsjyyxZ35YbayYoLPvYm4hyNyhOGA/LLJLnh7+9/k44T9af0I7QYT5X?=
 =?us-ascii?Q?LMfW86x1Sq4lhD/web29adKD1Ur/YPcusA0/3rLtCmwshSUtQBk4Sh7UDckB?=
 =?us-ascii?Q?f+iBPNuU+1+afmBJzpUaEsAdjvvD6v3/tMHQgixnL3RwJ/SHrbKyqMNl25rE?=
 =?us-ascii?Q?cbLvGpkYyjgLB1cfldhkU93TUfGsfUO313DTk2eQahdenLtRMXPKum3TcT/s?=
 =?us-ascii?Q?aEJc3IOM6sYF7sYepVaNOrN3P7oqfpA7QMuDJjHK+Bm69/IRucG8FUZ+5dPz?=
 =?us-ascii?Q?Qml1Ff/op2bmdMTTncTzGLUKsZK0ghUhkVdLd18SX0utCS2ewvnv8df9ShSP?=
 =?us-ascii?Q?vpYJED1wQbD7CVV2X2YZJ9ZJRkfbH4d67EpLKFboNXMDJg1H2TXSwq2sVDGi?=
 =?us-ascii?Q?PDVO2mMMbSdYZgXX+K/7+A7h2aAmR02SSffSt5R8IoyDxelPAdK+tmmQ0nc9?=
 =?us-ascii?Q?LzvxnSGrjFjeEOcKh3PQ3m0k+QAC87l9fNhcX0n01n52gXVoAw2fkF+XkcWL?=
 =?us-ascii?Q?9KxlkgjFRrfIJVAKfCUNOifgtf9igxbUQhdftJMCh8K4epVExo1A85VDkUVk?=
 =?us-ascii?Q?rOeYZGRHdBQWJpswHDJvzP9QuVZoegGpA4ZawAqmLcS0HhDL/H4l88U0ZMGm?=
 =?us-ascii?Q?4qM9NohzzwV0jePTp7vzCvwXSISDKRFNaGObDRY+mfSj7r7bdoqrhUKMJ0Pk?=
 =?us-ascii?Q?JIsvkd7wKGftGpjl/A9Y/63AGjH7Cx8OVbUPYtc4iy0Hjo8kHMBQSSi9h+DR?=
 =?us-ascii?Q?5Ioe5LWq85exTYZx0J9/dkRzs8mHFxb8G6rG4tFBQezIVE8lxg9fmF/5L2Su?=
 =?us-ascii?Q?vqjvNtHGODwrccTq8hst4prrHgXXze96dsIhWx1zEBpQbN07fOcQW9+6mAq/?=
 =?us-ascii?Q?G5NOsStPTQ9sBdDtIQaRm9xSeMak8GzwCg/pFIv85UOH3hgYsKrgl02UUFqF?=
 =?us-ascii?Q?1RxEHQj741GMOuoPy6OGPn51GJmN+TBeT40DM9FSke0JFSP9+GScxAOJG1hp?=
 =?us-ascii?Q?oNIu9P2p+TwAACH+mma6pFZbAi+VVqVHL6/pnqIrKK2Nbz5BIj5z7ZNvtFIA?=
 =?us-ascii?Q?r0ewkTLiywoXZiRLIY0gQEUPRAVaXQ6XahKJtkDCiZchUwj6ES+ku86rGwlY?=
 =?us-ascii?Q?Q2W5dH7RLkuRtO38jTOpLqsG97s8NMT3KkLrqVOe4c1Dt/WXxb1l5I/eBQy4?=
 =?us-ascii?Q?gTcnSUJ09iaBQi8YveSLvAA+tkpLerhuZiHOxNgaF3iulVMiTzcldwQHNcTb?=
 =?us-ascii?Q?xnH4iCbXiIgdCkzAdAke3R4+2YxB?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6gietZMWsw+PGzqTyf9837iy8wgehwLmkjzqpYPVOFvJO7YQt/TK3jfxO1Oh?=
 =?us-ascii?Q?Wx8H4VBeRXwOA4hPZCK4x+sYtNd6lGZbo8QSW0K+/lkSLoz7hw0B0+rpBbSI?=
 =?us-ascii?Q?Xcg+jpitHfrCW4zfSFW86fB6fIC5DtZWL2tzxar3e4z1Z71c2dWRWYPmQ0Yh?=
 =?us-ascii?Q?k+Gb3UVXcV3ZXYxLjvg/KlsxFEX2UnlkT5OEkDCf0chrfWXYs6C8fEpfuEUg?=
 =?us-ascii?Q?rLzLs5V5pwy26/mZtstzxAzPEJPHdIwPLexmhSawABjlPctVrl82R76AFNgv?=
 =?us-ascii?Q?0tRiYky4X6pLkIhNeyr+odrZExYKpVVkc25bLvrNq7ANx/ma/dM84HIJbUoE?=
 =?us-ascii?Q?pZsG3cAWcGfzyHThm+qomZwuHtYS56Iri6HgSfPmPYdDEDfaAEOhY2P8ZjQi?=
 =?us-ascii?Q?mH9aMyEXBzaH8QLgLM+YIp+7F+mTYvgYgrZGig/wkcwePNz5TXf3N0G2MmDE?=
 =?us-ascii?Q?UR9FsBKUaRZiUsJOdEi6S0pdGSsM3Jh+3HdtAx13EcVVBlRSWmNRKeN7A6hr?=
 =?us-ascii?Q?QgxwO6BxOY2SWJiRUIpIUoeeCtFF5kbz4R+nTkP/rz193BPSVvpmV5q8XGbY?=
 =?us-ascii?Q?l8gaeUBQQ+dXCifgpzuO9Fp81Eux4s6xb4kipzPJyN9oriqUk5olGe8pmbOa?=
 =?us-ascii?Q?hGLH067B6K7BCXpVo46riNPn1e/kgz1nqL1wwB/Ka/bHFizZghdaaliDI09h?=
 =?us-ascii?Q?GTXD1dbez5FDeoQ4TCoXVYg3fN5muLCsqTPQ0UBGIFGwY6AeyHgJTwCi5n9a?=
 =?us-ascii?Q?PPq729+bkrO4HinaNW+k2vtJXcD56y2GFYLR9iBO0S+3mm5Wn2aFVRYIn1mr?=
 =?us-ascii?Q?VYFBf1CkVyaOAy/WFzJdHBm7sEWlgCN6BZAEfFWQAEwzzGGP83Ddbf42JviC?=
 =?us-ascii?Q?x9Y8pVCsy2wGQZOIJ4Xz+99/zcZihO9P9SYejz5QdlkDtbRYKSJlwKJ1/LpP?=
 =?us-ascii?Q?/BYfOzhCUQSv6x6pK38MgZdvHahi8fpge6KKQL9LSgcXSDH2BKC3pPJsNxP+?=
 =?us-ascii?Q?5NV9qR9JbE55cuVCAAxOzSy+vQ/aZBQ5s871gVj7gAoTlQpY/naTxnQM5cU6?=
 =?us-ascii?Q?eNpP162pcXunYwj/TsMAE4gHgB8jYyxzv1gTyiMMWbQo+Oo2LVwrM3LuwoPs?=
 =?us-ascii?Q?J2hkvRGkvKbPI3uL2zHkY0RMKnEwA8mociag9mpForjYz1xoeCECj+NC9wa2?=
 =?us-ascii?Q?kLe75jBr3SNdy1EoN00jU6MzY6hdu1WKImlNFW9Wu1TkXpPA4dIDflc7GqIX?=
 =?us-ascii?Q?aKjQxTaKf2Iew0Okw6KDZzHci2dUBgaARLQVBXaSa1O9rntF4uiN3h9TB0SS?=
 =?us-ascii?Q?/QgDMbw3/q4Oa4YqPnNvIR4FMiWX4w/qvJ0nuDbtQdxt3piOdRcbE+6Ih/tm?=
 =?us-ascii?Q?KjmJVnSqwqG3T8GAYdyk86voMmE5xe/NVmIdV4kRzugaaLUffQA4poP6Xkbz?=
 =?us-ascii?Q?+F+ROsEq+w4N8br+vCkKjqCRVyGMpgG4AglDnNLEXwY3geFm2Bh7WFe67y6s?=
 =?us-ascii?Q?OHetwfQM5K+45qNQyKfBl2tzp5GPF7rbFzvTJ3bS0iNMaHkfM+k3yPCu1MvD?=
 =?us-ascii?Q?A/GsupG7UfXizbHVKPnUz7qwTEVVEcMAPhs+oICK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48b96551-a508-4ad5-efd8-08dcc6b024a8
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2024 15:51:41.2450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TdWwNA075Pvqu/TW5w/sVWolm5U13jua6Vzjimz5cWpwhu4pYEeuvpeg73AoHMsh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6790

HW with CANWBS is always cache coherent and ignores PCI No Snoop requests
as well. This meets the requirement for IOMMU_CAP_ENFORCE_CACHE_COHERENCY,
so let's return it.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 35 +++++++++++++++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  1 +
 2 files changed, 36 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index e2b97ad6d74b03..c2021e821e5cb6 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2253,6 +2253,9 @@ static bool arm_smmu_capable(struct device *dev, enum iommu_cap cap)
 	case IOMMU_CAP_CACHE_COHERENCY:
 		/* Assume that a coherent TCU implies coherent TBUs */
 		return master->smmu->features & ARM_SMMU_FEAT_COHERENCY;
+	case IOMMU_CAP_ENFORCE_CACHE_COHERENCY:
+		return dev_iommu_fwspec_get(dev)->flags &
+		       IOMMU_FWSPEC_PCI_RC_CANWBS;
 	case IOMMU_CAP_NOEXEC:
 	case IOMMU_CAP_DEFERRED_FLUSH:
 		return true;
@@ -2263,6 +2266,28 @@ static bool arm_smmu_capable(struct device *dev, enum iommu_cap cap)
 	}
 }
 
+static bool arm_smmu_enforce_cache_coherency(struct iommu_domain *domain)
+{
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	struct arm_smmu_master_domain *master_domain;
+	unsigned long flags;
+	bool ret = false;
+
+	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
+	list_for_each_entry(master_domain, &smmu_domain->devices,
+			    devices_elm) {
+		if (!(dev_iommu_fwspec_get(master_domain->master->dev)->flags &
+		      IOMMU_FWSPEC_PCI_RC_CANWBS))
+			goto out;
+	}
+
+	smmu_domain->enforce_cache_coherency = true;
+	ret = true;
+out:
+	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
+	return ret;
+}
+
 struct arm_smmu_domain *arm_smmu_domain_alloc(void)
 {
 	struct arm_smmu_domain *smmu_domain;
@@ -2693,6 +2718,15 @@ static int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
 		 * one of them.
 		 */
 		spin_lock_irqsave(&smmu_domain->devices_lock, flags);
+		if (smmu_domain->enforce_cache_coherency &&
+		    !(dev_iommu_fwspec_get(master->dev)->flags &
+		      IOMMU_FWSPEC_PCI_RC_CANWBS)) {
+			kfree(master_domain);
+			spin_unlock_irqrestore(&smmu_domain->devices_lock,
+					       flags);
+			return -EINVAL;
+		}
+
 		if (state->ats_enabled)
 			atomic_inc(&smmu_domain->nr_ats_masters);
 		list_add(&master_domain->devices_elm, &smmu_domain->devices);
@@ -3450,6 +3484,7 @@ static struct iommu_ops arm_smmu_ops = {
 	.owner			= THIS_MODULE,
 	.default_domain_ops = &(const struct iommu_domain_ops) {
 		.attach_dev		= arm_smmu_attach_dev,
+		.enforce_cache_coherency = arm_smmu_enforce_cache_coherency,
 		.set_dev_pasid		= arm_smmu_s1_set_dev_pasid,
 		.map_pages		= arm_smmu_map_pages,
 		.unmap_pages		= arm_smmu_unmap_pages,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 7e8d2f36faebf3..45882f65bfcad0 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -787,6 +787,7 @@ struct arm_smmu_domain {
 	/* List of struct arm_smmu_master_domain */
 	struct list_head		devices;
 	spinlock_t			devices_lock;
+	bool				enforce_cache_coherency : 1;
 
 	struct mmu_notifier		mmu_notifier;
 };
-- 
2.46.0


