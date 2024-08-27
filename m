Return-Path: <kvm+bounces-25178-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C943796134D
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 17:52:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B30E1F22949
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 15:52:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 153201CDFBD;
	Tue, 27 Aug 2024 15:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mesdruqH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2048.outbound.protection.outlook.com [40.107.93.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0AC71C57B1;
	Tue, 27 Aug 2024 15:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724773914; cv=fail; b=App0vTthBQTg9+TdALszaC3uowTRS6XxbU/Mcaoy69q3uWiUl5sn4Kju3wu/G0mO3WSqucZsVmBMf1C6lAfRmXdoHIbJiiekQZVurMLiR+VnThnG/cRbemvhaJy//+ZUriYJStodlyBDkw9imWZGN0jV+NjELNcsPy3IILQ+cB8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724773914; c=relaxed/simple;
	bh=Ri2/NMwnwWi8WDwuf12GXet2Hrc6eubq6GGWo6CYZlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GeXRPutnj1ZNQTO4Bs9ur75HffSQ1i/FjYtadPjccRnHPwfqX+K4Zddc39idcl+Iy7HU1M3Y0BiHxIxqWZcgXFhmmQ9tvk8/TbUs+DQdBeru5pqwVOqnuuToQeEL7WKBEzBuOrasaZQOLd9zkmva299TNzmbjZJH45rb8zwkFpY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mesdruqH; arc=fail smtp.client-ip=40.107.93.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MregP5V+7P1wm2903JaROGy8dXHOX2oY1nsYi7A60byiF/5+f2+WMyYyGrCnIlTGNGdQ9tJfhQCb9rAYkem1P6ryLC19rI0W88gWrQ6Vtjevj/J7Ns8WXQmBpr5BeW2FHUSbzY2NkE8FgT4BLgSQattXdEbDaKpYZdkXYeJ2AJS7Lg124J7+8ZOWw4ATr0ERAO48ammofb1jZrl4UIgGCQfVIFbJJbhK6atUPR3Yw3TnJAnjznuMYTl8U+e4Re0w75pwZlT+JZOHeUm5iKoi+CLxuDnKA6ueRBUy9wUy31gncotP0Dr6qOrbHs5PhzxW9lvYj1ohMj1jQ0FWzPOnXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RrTvQUvj2jJ9+pTQwnr/tbUoQjdFTfD+BV6H43CS0+M=;
 b=bI627sIRY68DCyDgsgvhUEb4S3q7m80opGE4EPGdgHMO32dtGy831+kikwY5BAKXBPPz7JNoElSg+9zX0p/PnIMU2PayKLXvv/V459WzVNJCqwyWJu8nFucaHn+Eiv5tazJwF6nbqUkFMvdS1hYKLed/TSouOqJ34wLqG+6+784jWifxR3SjbDcuF8Cq032XUhh9xcKhO4uzI6bajA1z2GWWecSQVsRVblz725XwFG/LmA4kXb6fmvOu3HqGcLNYdEGJafI5vviKWugcu8Ax8hV+PzOdQMpWnch3bcbspfKHBgDIjleqZl754PQ/AeLLAkz6DMTyTBnWK47tZIFgvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RrTvQUvj2jJ9+pTQwnr/tbUoQjdFTfD+BV6H43CS0+M=;
 b=mesdruqHppZNB2t6y5qi/iM34H23aVigcX7UAmbQk6jSyU1VqVbtqnl4m+3/cGNpYP9Roe3tCenJ5gkeCcCkoNG8MPm5fSMwf6g1eNtBB7iKtspdUbU8rVzBbibQb5XFyDfyoSD6Ky5IZuh2niU78J2Bs+maJO5nRjLEPWIbDD2dH3BTPg+e2PgAugHL2b49skS7eaR5ZGSeF8jJICxSmZuWcDmuCZib7a2hqcA+LZnT+eGpSWoMy5DPZId1oxw+7OEbfmOhtv33i7qY23yXROgFIzafSq35YD/bpsoCJk7KtwAT6KDU8DtBlJlL4XtyMdYxIO2HlHODvWAwdJYR4g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SN7PR12MB6790.namprd12.prod.outlook.com (2603:10b6:806:269::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.24; Tue, 27 Aug
 2024 15:51:42 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.021; Tue, 27 Aug 2024
 15:51:42 +0000
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
Subject: [PATCH v2 6/8] iommu/arm-smmu-v3: Support IOMMU_GET_HW_INFO via struct arm_smmu_hw_info
Date: Tue, 27 Aug 2024 12:51:36 -0300
Message-ID: <6-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0890.namprd03.prod.outlook.com
 (2603:10b6:408:13c::25) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SN7PR12MB6790:EE_
X-MS-Office365-Filtering-Correlation-Id: f41d5432-d9bd-4fc3-7358-08dcc6b023e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oYkFcClMbDjIDSyS7d60yFTrgzW8w/PEIqUcNIp4jX4Eiv0myRFp/Gf2H91F?=
 =?us-ascii?Q?qj/yMtsRWfUEQPh+wv47a3BzJsYq7kbiC+3uRM2HYqT1+JfwP6XWoJM/EW3D?=
 =?us-ascii?Q?uNHlE9JDBi+Jx8QXL/SKRq+hvpHeJyq0WvVF01Wk4IIThGoxTvcxxW7bmE5V?=
 =?us-ascii?Q?M1RYzvwAGAizsliD1XLXzdjrZIaRCFrds+3R+3t9aPwU4SiKP4PdywVYRs4Y?=
 =?us-ascii?Q?Y2TvyrZ5Jea3Qhc8eXWsFVJ8DdMGcZCksacJtyFVp0rAD28AiGEiafBduea8?=
 =?us-ascii?Q?UJn+/jr4RfhlJ7cvwPwgU7cXiFC77tDbCdE57KOYxpq+7v1gbL09pjLZxI5+?=
 =?us-ascii?Q?XtC/BVOPbADh/+NCGIWtaQv7v2wMOCVxuDcyprAxlu++NxRwhB8jIPfmnIRi?=
 =?us-ascii?Q?lSVyxE/GKdXjAxfT020opXE5tfls2Sh16XVQ8Lr/eNK/CUhnIA2GGlLRk6fI?=
 =?us-ascii?Q?gCZVeAFPd1iGnXVWeUDwzxl5Bfwjsh4pHCJkoyX0Wdl0KflqD2Hy5u+ghkpY?=
 =?us-ascii?Q?roYNhx/uVABJTSLiV6l2YBmaXWDc51SZdfAI5X7qgkcjQFndhPM/myzdrP1i?=
 =?us-ascii?Q?XSancdDTtzww5voZfH/S9Y1JQYBsrstqrqv+z9O8UFVtNoEPttF24/RmlFHd?=
 =?us-ascii?Q?IuCSAVeWor1HqYeBJL3ZHiiKi/20mFGN0LLP0Bw18L6YF4KcHfAWL+fUsU1g?=
 =?us-ascii?Q?7u0p90VX2vS526f59GXbYcLLRgVE05/qUNiR8ibkRbigAm1X4el7XN22CvPP?=
 =?us-ascii?Q?ixNVjz7u4vm2yZfimaF+/O9dcIWMeGuAu/VtzugnfsEZE9PeYBq6VqFtfhJT?=
 =?us-ascii?Q?/hwuusnyWy9lP2x7GHHeIMldj55dMDHuyS5K4AkhaMI/TyM3aD/ZG8RVlT4h?=
 =?us-ascii?Q?7gLcKMpVb6aSv1wZ8C//Xt1Oa8CZn6kb4jfN3fpOCvR2D3NELs6x0yY2Jw+2?=
 =?us-ascii?Q?NoYXERddceumPrmWsyV4+Ra+dWHMgxmP4fQ9zTSgRdvNyvCxBmNO7JbM+Zl9?=
 =?us-ascii?Q?GhC3J2aE+kcRt3Ccq7aQSMErAyUks6ihk682Upyu86OrwH8s25NCAntqJ+kc?=
 =?us-ascii?Q?E5oKIwFTLZXXZ3kEJZ4QtJdOlA4FUXsA1QsjRX6atTUPfrYgL34daI6UiNNB?=
 =?us-ascii?Q?iulecHdQqy7c9hU5gOO9pSt/LU7qadsQIyQqL1gvSHj7k6FoCLuqnck/7avZ?=
 =?us-ascii?Q?nyNdePnElNcrsL8ah9H4GWvnu6Ler3h63LVxeJZ6KuooUT3qq59cajWsnahf?=
 =?us-ascii?Q?2wNqMdBXNxI6e7xe+NFYSS4EyzgHi4b6mMyw9+5DSUTDhBttyVb/2lO1m8BU?=
 =?us-ascii?Q?ikbukjbOI18vz7kSFFqWdQFCWJM03gAyiQiBZ1nTVKIRZwbmIfrL+EII5/St?=
 =?us-ascii?Q?Mdnf2849TOxr5bPBHc/97m3malLZ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zEpyRSkcjbNh6ChUQSKNbIjxxh5Pa17S6su2R6yRH389LYabefNqKwO+Hxf9?=
 =?us-ascii?Q?6jfKx+AaAlCSDogOnKDl76Lf3Ni5rhJmpcwy4FSPBmq4iX021KOdypLBsklm?=
 =?us-ascii?Q?GEOBl+IOrrernr3rHEivwjhFS8HA3c7noE835NbN/9yadcYpxW4lIFLzJKni?=
 =?us-ascii?Q?bjwUhnx4dwPIlvuQc5v0AGHsbUTcDGHqWpEebdLSmBqMyWEb+wqwPepMX3c6?=
 =?us-ascii?Q?O6zlH3eReKnm889Vqd6JyfbsBgDAkXNqSyXhh3k2DpW9X7+LWX7KQJbftlPf?=
 =?us-ascii?Q?8UcHTeBUHFmlOT8IUKosH2i5D0xC74JTc6Nq+lYYwsjueWOM4xAk9bcBvj9P?=
 =?us-ascii?Q?c2InFvWFeHI3nrc6de0PzgcbbYQZBfOf8m21ukxZudxdxQFA9QOcUS84QiG2?=
 =?us-ascii?Q?hPVDpnR3LH5HVSb3l9jlBFfs3cVjRnFXh3TmNj3BCxuUm86UANnOmWVDzhVM?=
 =?us-ascii?Q?lWCvdsN3plsNz0KG6c1r5+KuYUcoWFkTEYzNotP0lZ9G5DTPRil+C8CHxu6d?=
 =?us-ascii?Q?Wjl3XIquFNylyE/Axo5v63rmZpFHLjnnaKaQcmPUhWfkbUSbkiMwtRnb7wMI?=
 =?us-ascii?Q?hcIP8feZRkpE8GByhTiDr56UnHGVboYrjh6RKsLQ6KHx3Pi2kgiVkROqjmQC?=
 =?us-ascii?Q?/veIXW7CjIxZ2xSLKqyEkeEpP6O5m91QSjcVwWo4pPlMk5Eyc/LxzMMerGiW?=
 =?us-ascii?Q?ecV9R29s+EfroCsYqzjz9IYcNd0g+c9buFaQJ3cn6jVwY2Mfn3zyeJLaCUYf?=
 =?us-ascii?Q?zRHmdqoFGwLSGnwHOhcFVhO2ofADStV1CSUh6a1yGZruIeRxL6LsUcamQbxZ?=
 =?us-ascii?Q?tDQdjf5oB15fKFvluPIHWoDefX9ZIx8sokC8IecVkHviu0h0URKaW0kIdXpB?=
 =?us-ascii?Q?A89C8PxrYUaRZblwsaB0QeEjGH9X5oMAWZ+JS9vxAgFfw8GUp0tHERCKKf3P?=
 =?us-ascii?Q?Ts25WT9DG+5oYA/zHK38UzRTOVdBYUvl/1I+njtU+b10KkE1YFRU6odt7dHl?=
 =?us-ascii?Q?5U5Sa195SThjh3k2+6Pv1nfO70J0W3Ffmh95wOEKnTPh8hHCgiEhm7+Px/HP?=
 =?us-ascii?Q?ZixOSkoY09h5k4dWLO6pkdwd4uDp11lHzomvoqSp7xNiolH98vPqHpDYXCc4?=
 =?us-ascii?Q?HnryX2v/735+melfeDX8DCmm9SRhW4w4vH3Kp3QPa6EF6Cmvx0ZWwvjIad8k?=
 =?us-ascii?Q?VJy6rAra8Quvrpwuydl8RXooK7n6fj1Kn8dDqY8CppLtiom7mHQmlTAu+HNJ?=
 =?us-ascii?Q?1UZBEvjyQiFMIj3LipUiRu4kpAlRiph0lX8SqWqkatNY0gvL4D6l1Y8X2j9G?=
 =?us-ascii?Q?ehcbcKAzAVDsWLsvMbVQGfO4lj1890gMGQriMlu5jCWwDmYiQN/3EHXSpflR?=
 =?us-ascii?Q?WgIYnOVBSipawfEdFfs7UwKSmvdFWS1NSFRgY82qAnQ0xaQzAJcKQ3owhthd?=
 =?us-ascii?Q?OlARxvsE/cUXBXQhcjaVeZrrptvTmcSwqz6n+ntob6ghjwwAE4L6msRHtc+7?=
 =?us-ascii?Q?KHgl0nazi94qwxKgLvJW0fBJfpXCNGqVBjGcUiBfFMB07r/jlF/VOHuwO+kZ?=
 =?us-ascii?Q?gKDnEH+NpN0O0XwK4aKQdbraWSSiIXnmU9Anfa6q?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f41d5432-d9bd-4fc3-7358-08dcc6b023e9
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2024 15:51:40.0192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cO854w2fC3F2tr6aiEhUsv+BN16j39kYiGXerTx4YLVg6sjyWZqvr0buenBtLBFz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6790

From: Nicolin Chen <nicolinc@nvidia.com>

For virtualization cases the IDR/IIDR/AIDR values of the actual SMMU
instance need to be available to the VMM so it can construct an
appropriate vSMMUv3 that reflects the correct HW capabilities.

For userspace page tables these values are required to constrain the valid
values within the CD table and the IOPTEs.

The kernel does not sanitize these values. If building a VMM then
userspace is required to only forward bits into a VM that it knows it can
implement. Some bits will also require a VMM to detect if appropriate
kernel support is available such as for ATS and BTM.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 24 ++++++++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  2 ++
 include/uapi/linux/iommufd.h                | 35 +++++++++++++++++++++
 3 files changed, 61 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index c2021e821e5cb6..ec2fcdd4523a26 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2288,6 +2288,29 @@ static bool arm_smmu_enforce_cache_coherency(struct iommu_domain *domain)
 	return ret;
 }
 
+static void *arm_smmu_hw_info(struct device *dev, u32 *length, u32 *type)
+{
+	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+	struct iommu_hw_info_arm_smmuv3 *info;
+	u32 __iomem *base_idr;
+	unsigned int i;
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return ERR_PTR(-ENOMEM);
+
+	base_idr = master->smmu->base + ARM_SMMU_IDR0;
+	for (i = 0; i <= 5; i++)
+		info->idr[i] = readl_relaxed(base_idr + i);
+	info->iidr = readl_relaxed(master->smmu->base + ARM_SMMU_IIDR);
+	info->aidr = readl_relaxed(master->smmu->base + ARM_SMMU_AIDR);
+
+	*length = sizeof(*info);
+	*type = IOMMU_HW_INFO_TYPE_ARM_SMMUV3;
+
+	return info;
+}
+
 struct arm_smmu_domain *arm_smmu_domain_alloc(void)
 {
 	struct arm_smmu_domain *smmu_domain;
@@ -3467,6 +3490,7 @@ static struct iommu_ops arm_smmu_ops = {
 	.identity_domain	= &arm_smmu_identity_domain,
 	.blocked_domain		= &arm_smmu_blocked_domain,
 	.capable		= arm_smmu_capable,
+	.hw_info		= arm_smmu_hw_info,
 	.domain_alloc_paging    = arm_smmu_domain_alloc_paging,
 	.domain_alloc_sva       = arm_smmu_sva_domain_alloc,
 	.domain_alloc_user	= arm_smmu_domain_alloc_user,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 45882f65bfcad0..4b05c81b181a82 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -80,6 +80,8 @@
 #define IIDR_REVISION			GENMASK(15, 12)
 #define IIDR_IMPLEMENTER		GENMASK(11, 0)
 
+#define ARM_SMMU_AIDR			0x1C
+
 #define ARM_SMMU_CR0			0x20
 #define CR0_ATSCHK			(1 << 4)
 #define CR0_CMDQEN			(1 << 3)
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index 4dde745cfb7e29..83b6e1cd338d8f 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -484,15 +484,50 @@ struct iommu_hw_info_vtd {
 	__aligned_u64 ecap_reg;
 };
 
+/**
+ * struct iommu_hw_info_arm_smmuv3 - ARM SMMUv3 hardware information
+ *                                   (IOMMU_HW_INFO_TYPE_ARM_SMMUV3)
+ *
+ * @flags: Must be set to 0
+ * @__reserved: Must be 0
+ * @idr: Implemented features for ARM SMMU Non-secure programming interface
+ * @iidr: Information about the implementation and implementer of ARM SMMU,
+ *        and architecture version supported
+ * @aidr: ARM SMMU architecture version
+ *
+ * For the details of @idr, @iidr and @aidr, please refer to the chapters
+ * from 6.3.1 to 6.3.6 in the SMMUv3 Spec.
+ *
+ * User space should read the underlying ARM SMMUv3 hardware information for
+ * the list of supported features.
+ *
+ * Note that these values reflect the raw HW capability, without any insight if
+ * any required kernel driver support is present. Bits may be set indicating the
+ * HW has functionality that is lacking kernel software support, such as BTM. If
+ * a VMM is using this information to construct emulated copies of these
+ * registers it should only forward bits that it knows it can support.
+ *
+ * In future, presence of required kernel support will be indicated in flags.
+ */
+struct iommu_hw_info_arm_smmuv3 {
+	__u32 flags;
+	__u32 __reserved;
+	__u32 idr[6];
+	__u32 iidr;
+	__u32 aidr;
+};
+
 /**
  * enum iommu_hw_info_type - IOMMU Hardware Info Types
  * @IOMMU_HW_INFO_TYPE_NONE: Used by the drivers that do not report hardware
  *                           info
  * @IOMMU_HW_INFO_TYPE_INTEL_VTD: Intel VT-d iommu info type
+ * @IOMMU_HW_INFO_TYPE_ARM_SMMUV3: ARM SMMUv3 iommu info type
  */
 enum iommu_hw_info_type {
 	IOMMU_HW_INFO_TYPE_NONE = 0,
 	IOMMU_HW_INFO_TYPE_INTEL_VTD = 1,
+	IOMMU_HW_INFO_TYPE_ARM_SMMUV3 = 2,
 };
 
 /**
-- 
2.46.0


