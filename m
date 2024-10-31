Return-Path: <kvm+bounces-30125-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D16D19B7102
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 01:21:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5723B1F21EDF
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 00:21:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2CEF28370;
	Thu, 31 Oct 2024 00:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ASMsFzGC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2061.outbound.protection.outlook.com [40.107.102.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A78C2F2;
	Thu, 31 Oct 2024 00:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730334071; cv=fail; b=M+zpXvqjKS6tdQDy/lBcdiyaRQXVW5nmci75DAID3AmXyhm0UXHZq+aBsi6AlvSqJL8cLBspnqCUju7FHlYd/vCY/oOkT1C6MSjbNXpgujpx30RVX95kO73QWvRLbyshQ7kz50rGJqYnR3o8judqkRE7ogdceRC9KfZZ8VtuUY4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730334071; c=relaxed/simple;
	bh=gRKPzD1uzrYin9g7cwzs2e8RJAJf5PUA+8CVv9yBCRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HnFVv8UhOb8go2J7k+mpkra/+vFWLwV9q/8P5QD8HomH6UY9Xrh5hIR6fnFdlQxxUyMEdSPS/N9llvPmOx86VnVOZpk4rCCZ0Im/zRB5zJk2085VnV39Gs1j7wBeAgLW2OOohoPl/cuPtppTvcTceB4bziJ9kYIVYS13HJ/sbv4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ASMsFzGC; arc=fail smtp.client-ip=40.107.102.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W/ubqxXfunUO1q1vF/yJawsv7ARTR81KndSBFSHsxiT68nC/REYx02cdzlN2pv6MW0km+9CsgTxNsuLKHyBFNz6GNImLU033dciF3IAm8mV+bR+m50s4LaUdK34COFWlo4PgBhfFIT4Lop0lPG2guaKZmAuSWNKPxfBb4pYIiP1FE01OTLyidn0XF/C89oYy6ixWptQkKybIbVcUmwTtPKZr8WfT93caL3yWrUW6wKNOFBq/t4rgU0OtS6ONlbfFoInqnuUzhGOMYYVkOHmaEtC6AlEVpBwIKI5tm/0fj70Chj/alxL1btcwwb8VysOAHJmhXNROwGdFTvRaWIK6Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p/pQvFN1E6CSh+ESHFxjV6j9hTUQ+5sG8/EiS8/We/0=;
 b=WjwmiiUi+iCTaA0FpFogTG0ihA4DE+VcsCtgvJjDh64/Zx5TswvRB4BjTf5Vl0At8Zsd2QfQlyKWSQgLlouRxvnOKyRlksGr42IFTkRWKze4NpZkpgRRaAbytTI5PRIPEbowB4knsquZJSStyIxlGHTeyDg11POFuhs/7Dmlxfa+I0giWr2ggMFAD0ioWGd23znr2SaXppYtK9HiI/RJ6P/iBqQKaBECTm0fH7iGh1pGXqY/W1OeT2rGSkIeN8hCgumtskN8Yek8bPNGrzF+ZrL2GZrKIW7yLpOKZMMNuFw3q6G2FqjVO2zxLc6i3wBG9pSjWm+4isj29hnWqiZ6yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p/pQvFN1E6CSh+ESHFxjV6j9hTUQ+5sG8/EiS8/We/0=;
 b=ASMsFzGCMgwL7x2KomBrjDPVNEtkzQ+rk7eAo15Vobu75AxHbr4LdisrM4WY+V57kHQU1rPH5UXnwCD1D61cmQpjs0at6+psTBSMM5CgbiCL9NhN7urzUBO9qtOxEcBTGxAkMhmFtT4Ph90/PBk33T+S5LU8ZCttiTvH/QCJiqJkrEbA497VPQ5NuQ0TvnKqYnkZDG6Qc8SeCnCyFS5eaueyn4EZ9Tog3bLS7Xw/M6+pEa8xAX8Zh6gWeOpQhHQ6BknoYmTvpUcG6nCjmUplFlCCiXTjP5tGdzsMvNke8Sip47kt2nSwtkA2rQ+YmgDk8ZBVN75KGeWL2EFQAjdEkA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM4PR12MB7573.namprd12.prod.outlook.com (2603:10b6:8:10f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.32; Thu, 31 Oct
 2024 00:20:58 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8093.018; Thu, 31 Oct 2024
 00:20:58 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: acpica-devel@lists.linux.dev,
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
	Donald Dutile <ddutile@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v4 04/12] iommu/arm-smmu-v3: Report IOMMU_CAP_ENFORCE_CACHE_COHERENCY for CANWBS
Date: Wed, 30 Oct 2024 21:20:48 -0300
Message-ID: <4-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <0-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0286.namprd03.prod.outlook.com
 (2603:10b6:408:f5::21) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DM4PR12MB7573:EE_
X-MS-Office365-Filtering-Correlation-Id: 07b97890-df5a-4909-cbab-08dcf941e3d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?deVc6mg7N5T4meGHVdXtoziRSgqkjsnCooe7d+PAf56e9doBeBaVl8qMCZ8D?=
 =?us-ascii?Q?QIu5PRYbLauqJ22NEa8DbISEmM6hnayK+mRvK+gGQ7VT+f6gn4JYbHp42Lc0?=
 =?us-ascii?Q?2j/w3kH0hwXLFlrJEqhZ3rraCNNL8SLgKJSw29y2LaGnx+p5Q8PwwXK8yiS3?=
 =?us-ascii?Q?vaCuc2lyT1VYLOKlWqSk4rwbQEnD5sn4SEIpNeiDeC4abClYtEyYANIgxitA?=
 =?us-ascii?Q?A4Xh2ksHXxfsQwiWHuJU3JIrpIDhQ/hIPy/rzoJ7b+RSl03Ek7iUSNQie5hB?=
 =?us-ascii?Q?CtR9wVm+LoXJwcUtUVbW9IjIPBtR+7XSESaNHCKK8bnIdtblYTReo00pN6bC?=
 =?us-ascii?Q?Tt/jxLqGqCT5m+dZb0QNqgwykSkuKUKn2yI5VlfoDDewKi3A7FjE230C+UDj?=
 =?us-ascii?Q?PsLILDyJmhzb7v/3guuObvUPfWg4Knq+jE6jkumKk9DUl6npgwaj9lq6+agw?=
 =?us-ascii?Q?YoBb/4EYbxJEEhFwgrFRUZjHNXKRuKJjaL1nhouk223bLBo21bOu+bT9skV5?=
 =?us-ascii?Q?bib0tFcYCtratJyJeF4dCGEhUAt3HkjqJEB/yESaRHKlTdmstiIpK26432Uf?=
 =?us-ascii?Q?kBqyZDDyzFJxHlEDy86p7bp/yjMAK7ydtaCXbFN8dX8WsVhrWwL5ZySpKg41?=
 =?us-ascii?Q?jj5Lizvvx/IFUWurFSkMEpwjt81SBIEq0ZamtpMuKw6xtXPMXxd5a/iG4Fra?=
 =?us-ascii?Q?BOA9l7DeNE+SSLlhU3K7zEBeBwOYcQedn8LUjPv0+fcvTl0t/H7GKHf9V7/q?=
 =?us-ascii?Q?2qxEiYbscZPziquzXlnlsCE5+RfLUQlrfMDf5HB3v/3NxviCYCooRzs9omrX?=
 =?us-ascii?Q?niRgMRnVqhI56SXbZ/T08GeI94wX53mVvzN5ilEYIj7sL6wuzf+c04QlRJ18?=
 =?us-ascii?Q?ZVX1dO3K72fTR5hPyrf0U4zTj6XrW4L+99sbJhiak898OEuvtMqj1XrzdUEI?=
 =?us-ascii?Q?13/2pOl6//IRf3Czkf886rPtMkyZHUygLRJBvUEk7RE5yfK0JhwVS8AYa+06?=
 =?us-ascii?Q?gx4zduhTcfSeLsi1uZm3UNQSC1moY0u5AuV7DgA8SHNCAn4xNFADo14H0uH9?=
 =?us-ascii?Q?ha/YzMqxK1zyfg1vcWghGfg8Kn/YGxIeHIqycPCEH0aTjqxPZQyJseO5cwhV?=
 =?us-ascii?Q?z0oK7nwxjV5qh+62/0i0DTuWjrsZ239618K2TNXz/h1+PqYYBRS/WoHEeV1O?=
 =?us-ascii?Q?BUdyIcbK4FyGp1qSQ9ZfO1YNsjdwxQlsKBKmXll1W4r/5MGXZZswryF7rI/G?=
 =?us-ascii?Q?kuSV+eaePqD/fSX/MQmu2d6JaMOx/1c7WNCC8M4XCfsfTIPMpjWa5P257gTn?=
 =?us-ascii?Q?hZJf1pI92zDU7C9ym5GRrk8q1M0meCaSUpyeqTCdKhOTFSL8wPA189yr8s7o?=
 =?us-ascii?Q?JUJzmcY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Rj6W7zY74x2ubIP4IAKrQfJ/vtkv799UURBb3TVa12gh7sv1KbyEKL1WvFXO?=
 =?us-ascii?Q?7lSDpKEYgMlkOWEWXIiKC8BC6F9LTnWWu70gTPonA/giqCQWoQXbuu4Led1u?=
 =?us-ascii?Q?1m2gcwb6gpt+Mx+2gA7TfmKI30KSrLoP9GX+kxUL0mhhpOFQ4ue/VwnsNPGW?=
 =?us-ascii?Q?nXQUsPHH/VUqLnCa7T2g3sl47EX5Be4zOzmlITr0efb9r6snlFQ/wuz5MP/w?=
 =?us-ascii?Q?cj4SHsxtmoqUqUSIKKOPGLlTq13r8a7AUn940QHAxfguvTuvYtzBY5R45HV4?=
 =?us-ascii?Q?X+tH0FR3ojM14BqHqn8eteVniDn6L5h3qJ2VEIciHX/iJ8vd5lwgrPScGK+T?=
 =?us-ascii?Q?Sa5+4XHSmngPbGZbR4KUc4x0q7NbzcvS19Hn/wAyWOKAiZbTp5BKbvWaCjn0?=
 =?us-ascii?Q?BAulOmscpAq9BS71T5xnzIiYPgEoP/gRuCBxsIgPiH8dVPXqI6yJRqZaqvYd?=
 =?us-ascii?Q?lDrqnbuXkOgSOGqnhy3+JW6wjy8damz36CP6lRcYgqCq6zqTyYxkr3kpkoFA?=
 =?us-ascii?Q?0m33heOLtdL+U4K5jg6QWTy+P7c/wxN+fedDZ7lr7ba+zZjdOEv34n4Ykp+y?=
 =?us-ascii?Q?HiPj7ElB7BotjAjbE3bCT7ReLs9ldgPiZJdhuWzrMneNrn55gbIGYM8d406i?=
 =?us-ascii?Q?XC3rMghpamTQaEsEqDfxykN00UNIgNYy1kcZ8zsRa10Xed3Jc8BjD+jZ8LPr?=
 =?us-ascii?Q?dcC8LH0Z7JaMk1xmMoyMlLH4yXs/MRumONXilo5ycdPi5qwaAzRd3BIb8Zct?=
 =?us-ascii?Q?ZRtIcpBccpN0vDkz8DV7xyQeWnO0RlG0M1SS7CXZqSabqdxPiU7IH/Ht5Ub0?=
 =?us-ascii?Q?CeHC9UsXEWMSaYnEPVb4JYraFMNjPgRjGkwgqPe4yaWgdoEGIYG4yjr8mzKM?=
 =?us-ascii?Q?pGH9D5JCNA/V1EKjmPeqp/wmklij3WvFXXpmWgMlGV+k9T0HVfODCHrNEXrg?=
 =?us-ascii?Q?CIUppO/UnADPSNqxf2dwQN1ziwu7JhyFNscuYQyrRT9W8SZG7reH0cztpgYe?=
 =?us-ascii?Q?cX9QAxM5WVBLyp1WVTGS4T4qZ+hbJCzQ5V13o65vp5DwR5WmKwU6UsUYMYXJ?=
 =?us-ascii?Q?gnNYrGt4ZA+U/JwYIhKOYFKIjBpeloMtwiTNtnaPJT5nX6cpTECLWjofU+JA?=
 =?us-ascii?Q?dOBBdEmZ5BZgsji0Y2FPYzVOvGq+dt6bFOW1h0FNGYBwg1b1mjkNn8zmiC68?=
 =?us-ascii?Q?F7Zml9k0VDIgGCGSP52OMUbo9+ENrH70j0QALccCHR5Z0aJ1hmZxQp5Hb+M3?=
 =?us-ascii?Q?D77u4GqNl+B4THj6eS1D42QBQSlAJTeWIGftiO02ZGCsenFMgVUbNjqg0jbx?=
 =?us-ascii?Q?8kVc/t1iWe54fDzenYQ2TgTm8auxvnDDXSndsYDpH8go8FzGaOW8Mqw0ff9Q?=
 =?us-ascii?Q?F8oEXiVisVesIBGpQhcrK+FvxKDEwXrL4XN6UUPXbY5SJX7bY1LFOJYrOzvs?=
 =?us-ascii?Q?JwesURFwoASnqwTt4N110owKFTso4gbYZbczvhx3dlq7JXyXSvk3lzwLbSkn?=
 =?us-ascii?Q?uVcEc7TRgNIcR2mnBt8lC+PzAneBsk5mlqj8am1n9Igg5DVvyLWjm2L+Vpkc?=
 =?us-ascii?Q?la3cDT2tjBbj18H1qdE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07b97890-df5a-4909-cbab-08dcf941e3d8
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2024 00:20:57.2449
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5o+YCaV0Gavu1wcfyUBAdVF7INg3D/f9aKASGYS/EaXLpQUz6HjMbvEpB87xfITW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7573

HW with CANWBS is always cache coherent and ignores PCI No Snoop requests
as well. This meets the requirement for IOMMU_CAP_ENFORCE_CACHE_COHERENCY,
so let's return it.

Implement the enforce_cache_coherency() op to reject attaching devices
that don't have CANWBS.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Reviewed-by: Donald Dutile <ddutile@redhat.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 31 +++++++++++++++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  7 +++++
 2 files changed, 38 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index acf250aeb18b27..38725810c14eeb 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2293,6 +2293,8 @@ static bool arm_smmu_capable(struct device *dev, enum iommu_cap cap)
 	case IOMMU_CAP_CACHE_COHERENCY:
 		/* Assume that a coherent TCU implies coherent TBUs */
 		return master->smmu->features & ARM_SMMU_FEAT_COHERENCY;
+	case IOMMU_CAP_ENFORCE_CACHE_COHERENCY:
+		return arm_smmu_master_canwbs(master);
 	case IOMMU_CAP_NOEXEC:
 	case IOMMU_CAP_DEFERRED_FLUSH:
 		return true;
@@ -2303,6 +2305,26 @@ static bool arm_smmu_capable(struct device *dev, enum iommu_cap cap)
 	}
 }
 
+static bool arm_smmu_enforce_cache_coherency(struct iommu_domain *domain)
+{
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	struct arm_smmu_master_domain *master_domain;
+	unsigned long flags;
+	bool ret = true;
+
+	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
+	list_for_each_entry(master_domain, &smmu_domain->devices,
+			    devices_elm) {
+		if (!arm_smmu_master_canwbs(master_domain->master)) {
+			ret = false;
+			break;
+		}
+	}
+	smmu_domain->enforce_cache_coherency = ret;
+	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
+	return ret;
+}
+
 struct arm_smmu_domain *arm_smmu_domain_alloc(void)
 {
 	struct arm_smmu_domain *smmu_domain;
@@ -2731,6 +2753,14 @@ static int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
 		 * one of them.
 		 */
 		spin_lock_irqsave(&smmu_domain->devices_lock, flags);
+		if (smmu_domain->enforce_cache_coherency &&
+		    !arm_smmu_master_canwbs(master)) {
+			spin_unlock_irqrestore(&smmu_domain->devices_lock,
+					       flags);
+			kfree(master_domain);
+			return -EINVAL;
+		}
+
 		if (state->ats_enabled)
 			atomic_inc(&smmu_domain->nr_ats_masters);
 		list_add(&master_domain->devices_elm, &smmu_domain->devices);
@@ -3493,6 +3523,7 @@ static struct iommu_ops arm_smmu_ops = {
 	.owner			= THIS_MODULE,
 	.default_domain_ops = &(const struct iommu_domain_ops) {
 		.attach_dev		= arm_smmu_attach_dev,
+		.enforce_cache_coherency = arm_smmu_enforce_cache_coherency,
 		.set_dev_pasid		= arm_smmu_s1_set_dev_pasid,
 		.map_pages		= arm_smmu_map_pages,
 		.unmap_pages		= arm_smmu_unmap_pages,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 1e9952ca989f87..06e3d88932df12 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -811,6 +811,7 @@ struct arm_smmu_domain {
 	/* List of struct arm_smmu_master_domain */
 	struct list_head		devices;
 	spinlock_t			devices_lock;
+	bool				enforce_cache_coherency : 1;
 
 	struct mmu_notifier		mmu_notifier;
 };
@@ -893,6 +894,12 @@ int arm_smmu_init_one_queue(struct arm_smmu_device *smmu,
 int arm_smmu_cmdq_init(struct arm_smmu_device *smmu,
 		       struct arm_smmu_cmdq *cmdq);
 
+static inline bool arm_smmu_master_canwbs(struct arm_smmu_master *master)
+{
+	return dev_iommu_fwspec_get(master->dev)->flags &
+	       IOMMU_FWSPEC_PCI_RC_CANWBS;
+}
+
 #ifdef CONFIG_ARM_SMMU_V3_SVA
 bool arm_smmu_sva_supported(struct arm_smmu_device *smmu);
 bool arm_smmu_master_sva_supported(struct arm_smmu_master *master);
-- 
2.43.0


