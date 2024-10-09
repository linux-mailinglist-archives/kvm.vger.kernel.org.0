Return-Path: <kvm+bounces-28282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C79E299717B
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 18:30:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 32904B232F9
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 16:30:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A6401E22FE;
	Wed,  9 Oct 2024 16:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="L0abM61l"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2079.outbound.protection.outlook.com [40.107.237.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F16B1E2013;
	Wed,  9 Oct 2024 16:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728491017; cv=fail; b=RBIMTDCEarVnX4uUThPD7RX8u4nfU9d3a7Ug/ashXbvCF2qmouTyJ537icQN06iL0vzo4ILkR1OXfMbKsuIWALdLQ0vW8RwZJpBCnjx5BhHcTeQK1k8gQjy+WXtRPW15FB2hC9AH+TNRQtQY6/wotLAaNvRIqsp4xRNbRvJCGJU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728491017; c=relaxed/simple;
	bh=d4scfK/awn6fiN+nl4ph6GbOw9++bWGOjgYGwfK9yFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Yw/niIBp/MhZ9NI9/gQrGozzoriI0PSZVCbJuD1vc8GrtuSmYUxb9Rbu5UJWTIVsHYdxiyeiDHjbPkIfNDzBUxCuTlRHAc806pyozs49LKq9yDuFD0bak900A5tuJIeRcMFh98bWCJqTNaq6Eh0wb1xJ972Dmzyzx8DLnlpIFuE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=L0abM61l; arc=fail smtp.client-ip=40.107.237.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VjpZAG7muyJcbbsEc6VJDy2rdTRtDpPsgoUmh2WjScWn96jIYzbH1PNOrqNbFT8La6z6K15zj/ta4p2aRXVM2FhRN5F59CVev5pPHWnKGmUI5cwuItypZXaC9hOULxjpNfQ5i9esGJ10FhInPY7kJITjPdyqts+GTo5ScKZoWRrxhFBeCMtSZdPxA7rKlVkZVKL53H6+M69OXOpfQ3CTWFRqJ2SjnUE7AVeVZvLGcUZtLJ6CBxOaZy7CWsxMwdO9cLNI6lZrysepIR7d5DZCD+ItdKl7gYYZfOL2ghzsmd42cXiVXu2mKacOG3is05H3mZ/JpVq96vZSo8oKd7JuDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SlLcOotZn7KIOaZEjh+wsvcl99WKrYuATj4rVYT/KFo=;
 b=RX1CkfmEg3SZOG3G6vJdJS+7z/dfdoCuQKyxBwopRGl/s5o3xB6mv9o/XvrbrSs+ATJR/PB2hzK3A/SIGjszs2wkSE7GTTD2u6H5RABGImJSp5N3QKX1Ph4L23Fv+dhmL9bmx2xj3Z5a3gfPuZxYFtS/LkyMWhsUd+pdu5cuAIAGbb2fss9Mj8DHvK8HSjnyjl8f3SfzAaXmyQF51iTp5ROKxNisFX6oemwfm4LB7eQqAtGMFSVr8eFpR9X8R+COxt66L7fFRz4CSpT215R5Vt+LnEwLLD5Djuonz7NlECH7DXcsfUZeGARLaGd1vacT4I/S5F1oFfbDHk7UI+qcww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SlLcOotZn7KIOaZEjh+wsvcl99WKrYuATj4rVYT/KFo=;
 b=L0abM61li+IwBHOnjEj57Ld2YA3fd2R/WjAgNnMoyrGNwhVzHhCZe+2V2HPWZ4kHmDdPG6eid/0sH5Dy28+OY675bi2WH7ljsSPxpSrKBgEd6PwQiZ5HlBLUvuRPD37EdTHP6mo+jzRmLrC8huGX2pwYDp3Xhg2qTNXfo+wpomUrrE54lQ9OpVVg1laAumNkpDCW3a/QnN3SvHrkdzCbn2QWUAwCjregTeLglcm0OD80gNJnJNYQmbmB6r1AcSCpfwYVDh1nPRuDCGePRhxrGh0pWQzjbhZT2QPd7ZkFP+6T8/r56U1C+TfgkO1Dvzq7UyP+u4imRDEJLktQFJzcIA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SJ1PR12MB6073.namprd12.prod.outlook.com (2603:10b6:a03:488::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Wed, 9 Oct
 2024 16:23:21 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8048.013; Wed, 9 Oct 2024
 16:23:21 +0000
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
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v3 6/9] iommu/arm-smmu-v3: Implement IOMMU_HWPT_ALLOC_NEST_PARENT
Date: Wed,  9 Oct 2024 13:23:12 -0300
Message-ID: <6-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <0-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL6PEPF0001641A.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1004:0:6) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SJ1PR12MB6073:EE_
X-MS-Office365-Filtering-Correlation-Id: 21fe00e8-0e1a-4953-213a-08dce87eaed4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EigncHmRPu74f2uvlLsm8lh+jcdT7adM4Y02T9GwFuNoD2EH3xkIr411UqiM?=
 =?us-ascii?Q?U+EswcQOW4YK8PfGKPQBmPD7yrGxnc6wh/uEDZcEVZZMNm5zU19KiG7lqWzR?=
 =?us-ascii?Q?o+GdsV3BUK1SYUhTsT0jMKJJG1B/SKCOdN0snjchxJB1gxkwgQ8fnM3rGXeP?=
 =?us-ascii?Q?7XblDx+U/8aGv5HTsT3UD8hVFOhxkcG80ktrO4Q1Bn/YLHin9Yz+JGk4VQa5?=
 =?us-ascii?Q?jCfn/y31NQMSpfvaDnoO/1A5LdcrEbskkQLnZhdlhlW54ReTCQWGRdBS+sRe?=
 =?us-ascii?Q?IHvsMPfluD/uOq5KGW4luOoUnAjj7+FFm4ZOJFlWRy2QCFUR7ojv1lni5c9B?=
 =?us-ascii?Q?ficDE6hPYNNapZxIDldya+50LSDJsVzs3EqwmVOmBq3U2XsNqU3D+zTbPI1r?=
 =?us-ascii?Q?12JMEeQBUlhMNgbLmprJ8onASS3x1fgAI/Q1o/yydioIa6NQB+PNeNkgfPKO?=
 =?us-ascii?Q?KhkQMVeXU9jSUdmn3uCQ0zRziKvNYXrCzNZZv++cxcpd75+3yLzIkxvtxW+u?=
 =?us-ascii?Q?PsLxXPTfe3Hj5cUggrdiKyq3bIDbf0FiG/PgZ9ahS7KkO+8+AfUYB6BQR3xe?=
 =?us-ascii?Q?f8gm9isSes7cX6Mz9lwy3qYUqVMbw4k3hZ9JgCKwWuklo/cSmJmnP24vZ64O?=
 =?us-ascii?Q?EvLTWO0270A+csHJ/81h1pdIlDjHfWWgdFBW8WDGLcT5kbBS2Jk/UHL8d+rz?=
 =?us-ascii?Q?BJNfGPaGyhjccYcqpuAnwguAFHXlgm65KLGva5jirDuU9iqj10QRO6RZlz9E?=
 =?us-ascii?Q?mDNq/toZ0unKdpbvVzdd6UjzexyCJ5RE9f9asQonKgJcL7UpTdhZ/M8Kw8/c?=
 =?us-ascii?Q?B0RuibcmrzlZpo+6j0B5dHqEv3OcLYaZdIq70J6GS/PwXuChRHRHoEtanJ/l?=
 =?us-ascii?Q?22m+uwlCVLAPAckzixBqOkrA8SMd8O+FNa97HRZoYx2BmypUsGQVbhCG3kKk?=
 =?us-ascii?Q?P1OLnJC4nGWgLwe725s+EVI6Tftrv99ymFCUtnh45PXOPrd5K0vXMOrR/JKE?=
 =?us-ascii?Q?p+n7j7rKCLEnxJtwlpeX6MOZGtTylqgVwrrDIPxCsC37xv8gGj2zwJaEl2mF?=
 =?us-ascii?Q?bxi2Kv0f/lXilHYFYsh6zoRgfcfHzxnD43D8Ce7iwuKQ8nbooTIQbP+a6cYg?=
 =?us-ascii?Q?+7h+ec5jgJLkYY0AIip6yiKRJTL/0iReYjpo78Qb0zBUgYWjaKin9vf86bXd?=
 =?us-ascii?Q?2fdEmBHWG2npgHKXADK2hCGLqP37ehyA4r+HTIk7an/H+xt+hZ9TNRKXFE6l?=
 =?us-ascii?Q?mXaG61FGucIlMCPJYK6+uZBG6kOabOdQgFi9KnUh6Mfk3leB7DaW2PgeKqaf?=
 =?us-ascii?Q?+fiTTsJWeqJHEJOZYY4cPE1R?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uWaSKc6V7eDdh4iQywFbqQEKY9bcRbzA0dDIDj8oewfEwWGzy70/0TRnM021?=
 =?us-ascii?Q?Wr3BZwXVANadJThAoy8sYGEa6b4ite/xi3DssWsJUl9tHKqO+L4/R9k7BWIj?=
 =?us-ascii?Q?E/MGP8HkANpo+MCNlxz5zhQwoUw4Gi/k9bkAUebuYpYBIRlS8BdOrvVEuWcm?=
 =?us-ascii?Q?AvfW30wEKVD9IkVZu2wZunWJB7BalcQNuuq58Pq0eD8POIojumnAT8E/MRyS?=
 =?us-ascii?Q?VGWelIzuVfNXOyDzpCPzdNbwtQtaOSy2SyRAAUQLTIDkwg0AttuEsLmpfkGV?=
 =?us-ascii?Q?xTGca59tvzvxD9RJmrWsNeUJwrLP9W13zPZHs+1MeZJo3TX8+yHa+jDroI1u?=
 =?us-ascii?Q?730Ydi08LRX9LHSh/bOsHKVTC5dMLUS4yX8zB+B805uqSXSgtN2srhOpcEk0?=
 =?us-ascii?Q?Sm/r5Xf+fkxbD5xeRIEFr5zinormw1pECrIHOApu0PrtuXFZu/0aCP2RZVX3?=
 =?us-ascii?Q?Xk19B0DynPqzulj9y/DCG5xy4Fb2eaTHQZxoqRxNMa5HroebZB5/DHkwYFxW?=
 =?us-ascii?Q?ZO0zIAXnzEI2D9TXLaFJ/v10NcqOkrwECdRa3jwgf6pEq0Y4PPLuKtm6rGe/?=
 =?us-ascii?Q?/mLjlfnBs8+TvqlnVMtTREpWXD8eOEfUHu0s5TKiFo9tCccFg71w5MD+A454?=
 =?us-ascii?Q?2wbUyjULXUoKIIXgLAXzHQpSSghkOpJvuSgICFrHsPVEWBXMugno4C7U5lWp?=
 =?us-ascii?Q?19nwAnyccLBtRjxT8vitt+vvYZ5AE5m6g35CocUvtDnKAuWaF5suAsLjvgQB?=
 =?us-ascii?Q?lcni7+YMOKGuvaABFKtZLeGTrvwqL1MPnTK2h8un+okwVyLmawvla9IIPlgd?=
 =?us-ascii?Q?qf6oRF44o8j1znGh5+BWRHB1jy3dr2jPRyYAKXkrwXBajYCjTUnao7eCBDXj?=
 =?us-ascii?Q?KyVVFTE5wcHY0Ky6C1MFGOjXZoMIAMls6o+9exNyP9QMcc3hv7RoBUzdcTww?=
 =?us-ascii?Q?rPCymf7/QRkGwR9ABAhBd2aX/5XM2b251FuAd5M/tawbJFXiA+oVjlw9r0eR?=
 =?us-ascii?Q?RmdjeGR23W9AA48goS3Qp9QxFJLBtNG5g+r+ST7gzJ+nUiIwNV2LWI+X6X0g?=
 =?us-ascii?Q?oXR/mRROSnZr2Nt/yLGskb7mDLq4rSxLbqfT64hSBHZX6fb5GdvUyvQJJ2p4?=
 =?us-ascii?Q?tbxwJgIr7d31PnUfivdPwfSyU8pzbQxMD7ObsQbaEN4RuvMh2a13WdpCE2QN?=
 =?us-ascii?Q?1ll9PSn/E4nzpTveizf5LskzTVFnxs1numYB0cMEnUkNLUqdWWYVzhBNglQf?=
 =?us-ascii?Q?AIRD5bUL+MAyhpWy0gTQUuMAr4Zqf2pMpsbFpdjy979Q0NXsUytXUdyf4E1B?=
 =?us-ascii?Q?agkrbtqITNRXvKPBLDCgDQIHsgc+T6Gqk+JX5IRXM0Wusqw4GtcBxpxBOpJy?=
 =?us-ascii?Q?tUeC9zHlLJBnTSmMRPf8LCu9348ktj+6fb37jhqTgVUeGhti1iwbEF4zAqus?=
 =?us-ascii?Q?VmrRJXU8dHedQjvH5BlqUH+zttODlNK5pb/IN43Ql759P1xil18dqDQlM4UG?=
 =?us-ascii?Q?V1hzgkaqWwFD+yzL0jOx8bM3nsK/Mul4fvG9/MNfJak8O5PSAOa7rx6mFC0a?=
 =?us-ascii?Q?GdcatElrTWCvDMxiC1U=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21fe00e8-0e1a-4953-213a-08dce87eaed4
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 16:23:17.7939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7e5WfGQIzrqh7kpVor/W3PumPuSt60ZHXEJTFdgUFS9CdjxwhF3Mcf5KtKl7j+ii
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6073

For SMMUv3 the parent must be a S2 domain, which can be composed
into a IOMMU_DOMAIN_NESTED.

In future the S2 parent will also need a VMID linked to the VIOMMU and
even to KVM.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 996774d461aea2..80847fa386fcd2 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3114,7 +3114,8 @@ arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
 			   const struct iommu_user_data *user_data)
 {
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
-	const u32 PAGING_FLAGS = IOMMU_HWPT_ALLOC_DIRTY_TRACKING;
+	const u32 PAGING_FLAGS = IOMMU_HWPT_ALLOC_DIRTY_TRACKING |
+				 IOMMU_HWPT_ALLOC_NEST_PARENT;
 	struct arm_smmu_domain *smmu_domain;
 	int ret;
 
@@ -3127,6 +3128,14 @@ arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
 	if (IS_ERR(smmu_domain))
 		return ERR_CAST(smmu_domain);
 
+	if (flags & IOMMU_HWPT_ALLOC_NEST_PARENT) {
+		if (!(master->smmu->features & ARM_SMMU_FEAT_NESTING)) {
+			ret = -EOPNOTSUPP;
+			goto err_free;
+		}
+		smmu_domain->stage = ARM_SMMU_DOMAIN_S2;
+	}
+
 	smmu_domain->domain.type = IOMMU_DOMAIN_UNMANAGED;
 	smmu_domain->domain.ops = arm_smmu_ops.default_domain_ops;
 	ret = arm_smmu_domain_finalise(smmu_domain, master->smmu, flags);
-- 
2.46.2


