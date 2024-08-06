Return-Path: <kvm+bounces-23450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 97AE8949C65
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 01:41:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D9D3282924
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 23:41:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF2E5176AB8;
	Tue,  6 Aug 2024 23:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dxKRNco8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2078.outbound.protection.outlook.com [40.107.92.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214F517625A;
	Tue,  6 Aug 2024 23:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722987690; cv=fail; b=OlExrsMhxeGS0e+4yWAF87TcZmW1e7fpcCkLodOhLSxDi8CWx366gV9GjIUStb104KLcRhsUjMN/VMC4Qi4w9743twUMyDMCgjHfEJCXCy1oe9gU1mNwh/jPm29KCIP5U3W++25k0QBNyI1TRyWmd5nJnkS6FHzBfa2gOiM1a3E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722987690; c=relaxed/simple;
	bh=fm0eMgXPQbtc8kB0elmkmSeVpo3opgh5k98Uyc2U4zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=H5Mq1tnEhviqGG22dQIdIfZIhRUeNFwzw5/Q+gnQrVt8TATM9RClZt06QndDf01NP4LXqmCw/7YkaKSCUGwEzPmUJK0WV8rWyI2ho2WPAfTLIGL3YT+rPE3xPTNm5LplrqoqweGsMUanRQEEBlbeI7w5m7FDDYavgXQpO2BWcV8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dxKRNco8; arc=fail smtp.client-ip=40.107.92.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hchf+4lFLBj6bao8I3DkLUHm6LoVFEYGM+RVn6sAFy0Wb5ZiDRgEyvGLpL6Ie5IlJuSRgAXhHsaM61byl8+BpkMcp8bQvUkfb2MqSR/POnWGBBg50o0hPAVaeBqP3omNd9Zt5nVDyzCEoUwRIf6D+n08Pld2TPl5gac1PhPKSCY5Y3Ubbwgc2zhUB/t4O9HkfejVV6FK1d5mevyLZreAcInG57/kZqw6hsv+dQB/OOl/s9bAer4k1eDr0Wd4mMs4g2yI35ecwj7JrMDcD6ktl9rngYnKjPfqBLR6ypxA4OlXPbiJ7aTnCVLE0ldX9k3AMGRc5Q5Z/f7dzT8x4zZMJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sxJ7bYbfH+piw4qD2+PsYhdNNnsDu2LAPIrP6Tt4Dz4=;
 b=uTVE4Pd/OKSYXp2wC5wsafm9NBD9SwHycAKjdhF35L2B+M+l1qnYpiiF1dtnauVZH8UKCgm5nEG7er4ToGyi4cpcRym2wv7shMVPMLPi7Tg7xWW1rCQYMFmIhPigBrqgdINCji8UFsMJGXbjPgHGQCUDj2f+D0TuOkGG4CDL2ZwfW4R7/RQeuEN1or1I8ypyXIh8nyApb04He2+ofSZPGkNvdkxHG9crNI8Zr9HdSG+lzRHzkZV3tlEaQAehHJyFwPMQyVg3/52VpTrKqzAzz62GJ/FPgTNhxgxjuj2KqarzHF8sGaGEHMFJAYFQd/LlqwGdVahrXsnFnqUEQLEXWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sxJ7bYbfH+piw4qD2+PsYhdNNnsDu2LAPIrP6Tt4Dz4=;
 b=dxKRNco8drz4p1jMmwkGLSaNsAtK7CllOP1r5PG1KplsBHh6HFR4awyM0XdVqVWIpVDEc1Cif1A2C6iBf4POJWSyqanbz2EtzLx4r8gA6df69EOSKFuLd5eaVYmytKqu3c4vrsSqK+2UMhE8b87fkNLyG8FNdjF0iMr/k7Iz+Y/H+PZC7g2rAa7oCaLSeEn0YfXU+atiqZcljSyHuwIMHyidb28V4+7tjApe4qDIjNAIyWNL6ac4WvTndqBL0Pvppt8o6nlcwgEEK4ccqs6F2W4rL2MNDzczd+AkoUh1g38DDvxcDAjzhw21TTfm734/po4bxXX8bUT4olgWJCdtkA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by DS0PR12MB9422.namprd12.prod.outlook.com (2603:10b6:8:1bb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.27; Tue, 6 Aug
 2024 23:41:23 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7849.008; Tue, 6 Aug 2024
 23:41:23 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: acpica-devel@lists.linux.dev,
	Alex Williamson <alex.williamson@redhat.com>,
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
Cc: Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH 5/8] iommu/arm-smmu-v3: Support IOMMU_GET_HW_INFO via struct arm_smmu_hw_info
Date: Tue,  6 Aug 2024 20:41:18 -0300
Message-ID: <5-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <0-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0964.namprd03.prod.outlook.com
 (2603:10b6:408:109::9) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|DS0PR12MB9422:EE_
X-MS-Office365-Filtering-Correlation-Id: c505ee49-181b-49b5-d859-08dcb67147e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|366016|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JVxadVHn+nFm3mZEdyFsih6xNaZgpVv9Y57heZgtK+dBMN8q5FLzQj3m+W/o?=
 =?us-ascii?Q?DW1bLd3tZomjR1NJvDyZZu+7NS8FrdcgHtaP/UxL8vZcrSUm1MRixS7v973l?=
 =?us-ascii?Q?C3yysjyM5oa1ueU6QODmQAkIjC2Z66+EIyxo/5pFA5PNwoIiVzyuE+cb1crX?=
 =?us-ascii?Q?KE50dgSKcgyDBPsoda7Fgg2qM93dDiMvLLI1KZfPZwIG1uBn2v1YGNuwqbq6?=
 =?us-ascii?Q?eKLIZco7z2esLURnPwNxE5SXNNCXbEoT9Pzvj0HsvIPOFa5gKl0uxe71cq4U?=
 =?us-ascii?Q?i2Hwb9ypIlxxrNn49HEMY+ReApuvxjJanl5t/cC4aowHaSQbUmQPNtYBvxrI?=
 =?us-ascii?Q?LUkjZbTZyNv66uPAg0V8X9MLIJeahGjXtuGnlSzFIDnE1pW2pDxy9/i9tdUU?=
 =?us-ascii?Q?MBULBspNHsoA/VJxmVFex7jI9V2Ae1JyrzhH2zlr9s8o7nwKqP0PGNcnAX7H?=
 =?us-ascii?Q?GoAMVWtytB3YMSwU4+jh0Q6WZ2qOxugUxkq6jGFE2AlP5sZkjv9zfW26Hvii?=
 =?us-ascii?Q?He+I05/P8f5Tj+qbCb+DjubCFfdg/9ezTpGTmr/au8xtSMXmHLtUPJ8oyTot?=
 =?us-ascii?Q?c5UU7P3a91hujyn/Gq2HtqkliWRVkefQPKr+my7QBR4Cj5eWhb06EnD+OIGn?=
 =?us-ascii?Q?lFLsqZfy4cHbGsHRKSGigIeGIp0En8pO3883DGWGu7VyUQyethXzVkdJNUvh?=
 =?us-ascii?Q?iXJxYj1g4a0fQh5jPw3nHJXMAoqUNjQ1y7gOeYCVqgudp63EGE83m03PwHVx?=
 =?us-ascii?Q?+c56NsMPxWub4jaPH4/cFeoTM/0g6OLongMSDseU8o20npzlWTKTdZw8+YZp?=
 =?us-ascii?Q?tgIpVAZGkgeAKakqmXLhhZk8cUHRUTxwUoxZPVddXvoOrlE35TJ2KwgBufZ8?=
 =?us-ascii?Q?+buVJ/eRiJDs5OIJWuatM195XqU8BWacyH/gIzwITI2whPdPz55wwBfWlI31?=
 =?us-ascii?Q?gDAg0y9T5zAD7gJb/p9+lEFn4+PPZO3fLOX+rKS8E+GJlH0wDIwF4jtxllB4?=
 =?us-ascii?Q?jaKORCLwsU8BBD0jfe0Ra7XPcamXuoAifVNTahrTzJxDOVKSQW1jUw+o6u7Q?=
 =?us-ascii?Q?rv9ExHgadM29xGWn5J/3O1LYDRriSx6C+stkyrQACMmbyAbwU7iRprvrU8l4?=
 =?us-ascii?Q?8jhRWLNceobCHreCV941K59k3gavK3mccAkWCf2fuOVB4+S2FE2BpQdhzBvU?=
 =?us-ascii?Q?sHnGUym+tieBu9BhcQoF6Xa0XT52/HRudkvwopPjO0Yli/1soCyjhOZGnh0K?=
 =?us-ascii?Q?yh8lNYm1ww6gALFXhl5xvsjNNKUyt2WXiVKe6mBUyYa7CjP1UrvdXgvyUdRD?=
 =?us-ascii?Q?vysHZtLb44ENG8v4BrZSgbS4059FbuAZndduJwbYOOjS3JOALN2+9rB/XBbC?=
 =?us-ascii?Q?QnD/Gz62dh6ODNMdCfHE6YU91nHd?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zM7HJl50qFelmeAMkfr8HOBf+5rmI0fbUcc/SR0I/o+rmVSrcRKbcGtIf8Ao?=
 =?us-ascii?Q?ADmDQTTybG1OGlvCLd3RkVVBiXehruEgUw/plFeZMjSYRKqbok34VVB+1h/s?=
 =?us-ascii?Q?ag+jgIpzc4xGLHm9Vur1ppXmLz52zr3S9jI22q8p+PjQ6AazVpHroLG8lxMe?=
 =?us-ascii?Q?JFDPqDTV7fZ54W6ZkTSwim+hF66uAsOyO+j/4ziTkcJz7myv5bBjrK+GS1wt?=
 =?us-ascii?Q?OgdFJUz5zPHWOlx1q6cSkctC9IfSKaShjkiOg87Ls3H4B58dioQdZgH+Aksy?=
 =?us-ascii?Q?Iom5QeqaiyU33PdBsbS3qQnjRKF9UrLcMxKrhYzyhidpYD2N8r1Un34VCnLc?=
 =?us-ascii?Q?sk+z43abNUpWsXyGwPZAa/dwNGlo4f1dsJsqsL/9WzpUrbyV3zZbtldmc4KS?=
 =?us-ascii?Q?RW1JkXNbKMed66XpL2r57KhBYNgGzJRZeIMQ5G163tFAKEnouvQ7E/AXZGMh?=
 =?us-ascii?Q?Fl0UxKnlCNETR/uPUAOOn0GElkCy+XsA8Cny/xmIi3s75tkHvJYx+ra7B/qd?=
 =?us-ascii?Q?YY5o+N91WjMYWQRsfvsKNxAr0XbfQUokWgMmCh2SI3LOyhj9gPIUBT3H3m87?=
 =?us-ascii?Q?RNtRmZ3kw2Ud65zWOC92Qgi7tuafnFaIIzt8OKcmtttbHaGhkwrlohdHaUHa?=
 =?us-ascii?Q?Zpj0p5QEhrEPA9Ao7ycKDWFWPcao5F0ul2Mvjqfb876nOj73WQTserdVBH//?=
 =?us-ascii?Q?yVQx2kMSEMsHAjymLXaEkgtV38G/rysdqbvSmEIsXjfGRLuzbo75BGlmefLu?=
 =?us-ascii?Q?SDAH9DmB9ty8BsQrIJUB8UDFcvnjiokCYgXXG4RTMtNmqCk/+FqVW6zx/JAy?=
 =?us-ascii?Q?V7QPgT043GIyYwfA9r2kGq4s2IYCed9SFHub0fNat9e9KimO5z9RNcCr4YhV?=
 =?us-ascii?Q?bGWyW/rSXxDBPXiVjcY6El+hvQXZRVJS46S5AFvmji8j59Kvq9xow7ntOFJC?=
 =?us-ascii?Q?6GiZvL9ZPxmkqo/vCYvQIaoXSL2RBrJMD37kwmz2K6rc3lCoZUd62IQZL+5E?=
 =?us-ascii?Q?RXs7SVIu0nXf1p0jmu9rweP+aVPGlGV+I2XUlzkG8cUAzfkLCVrGI9+hg/6g?=
 =?us-ascii?Q?pNwV19O/MnnhKKH4tfsysEnkxWQ6tr5TZg1dC8JdjKC1mFQ5eRgH4jCQLQL3?=
 =?us-ascii?Q?ojZnwpPVddSo3IowglI6w/ySebQwS9EVnUBJ+z9s1e2+Zm9gP2SR2cLMYSFC?=
 =?us-ascii?Q?a1RULTaT6W3zudhIiKk7eHSsIn96OVj3sPVI0N+fFcBc9X911lgR50wHKWKJ?=
 =?us-ascii?Q?EJtP4q3fCvbzuUo4Yh7zpZMh0g91fkgQX7ZDtVHJymsoEqR+zOYyAg1wQVIi?=
 =?us-ascii?Q?JBcktbVi9/DE8OblzBMC660sLAm0VZDuG/Ei1W1eNgjHB7ANuiUKcOGxCXcI?=
 =?us-ascii?Q?/n/41sj+2ZQa/9DMRQ4jA6+dwuOGxDs0Gs8DO9z0NspKRVVyD4KI/83iO26d?=
 =?us-ascii?Q?yc0cy3Ou4zIyjH78571VqkN853YOuMcccc6t03HFvlYoXD6qGsmgRg4Bz4xy?=
 =?us-ascii?Q?Q0+T5d8QFoSfLTkzfl7BzWrCjfqnRhIrzIKQ5/yflHgtZ+Qc+3scXie2q/0D?=
 =?us-ascii?Q?1oI3fG3qpI6VXVyje9k=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c505ee49-181b-49b5-d859-08dcb67147e1
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2024 23:41:23.4456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JAZ+5g+KPZ7R5FLS2HzXA0GJOISYIMlA3qvX4/JroDnTKbYEBD9V2uu/nByAqH7j
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9422

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
index 998c01f4b3d2ee..6bbe4aa7b9511c 100644
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
index 79e1c7a9a218f9..58cd405652e06a 100644
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


