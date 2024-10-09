Return-Path: <kvm+bounces-28277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07B9499716E
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 18:29:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 276A31C22BB2
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 16:29:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D60D81E0DCE;
	Wed,  9 Oct 2024 16:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="d50cU2wX"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2079.outbound.protection.outlook.com [40.107.237.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A727282F1
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 16:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728491006; cv=fail; b=GwJJIckELKACH8VS41E9kwA73E2xScwN40bQJPmjWXQekuq0PbepFozi00LQECvEScRWbePEdOxhDeGy47kNDOz1QZK+EtZECxZujHIfaMMJOStWNoNav997Iwlzkk+KUx6w4kZhh8wPXKI0nk9SEVAiTv8/W/XXuv7WmWAcOr0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728491006; c=relaxed/simple;
	bh=HLgJSx9zNbLKmh+2CXeB+LrMw50jskRmGn9phyJNGss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kko308Pn+80nxQqcMNPgKFUVkgQpAgt8BKhTBSHhmEtain49aRbBQItPLonjLAC6yZT3rrt+SQkXKWN43te5ucSpbOFz2++8vG4cDpRB9a5GXLZWrktyPh6DBxzTC0/OYEubZALX1FNABkAIFFLn4lDoNgOQn2srTL3WMIv/3KU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=d50cU2wX; arc=fail smtp.client-ip=40.107.237.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Cmx28ZrbUKKO+Y7gFTAHRm7ADUT8xShV6LoOR2t3MAYBv00OvEoNwV3VqP7JvyB+C9h8PxdFQS+SNzKoETsDtVs0941eLxHWEiGiJA9jCImnVjidBhFX0cbGL/dS9rVH4PhMakQSmAUwX2XpvIl9K13trVvmMWAY1HRFH1iTdGmT/KfRbvQ84M4qP4NDp+TbFWZIwo1d2AQiSbON4+CSRNWRZFz+ja5nxYQxQYz05hVGJiDnSsp71dKNqHwVQ1vmy+BHbxkLfm2j9XCgsvZoAlFHELeJnAyfL8J1i/xqRm5OJk9pxB8kynbi9gQaJm8jWGSymy7xLt1x3VEQeHdSMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UpiN5oo4z3lvMmB3amQBIgcZf9ooTUIzQ5WEgszjOO4=;
 b=VG6E62Xwwpz/sXSNgW+HOkpkADSdpss8iRuB7qAeF74kb4RMV0jICG/D5VcZTg6EWqsHCV5pW1sWK+oOXCX9YHlo58dDOfAx7eBmy29l9f1nl/mL3ag+mN22FlyMAoow57koLkINMCl4kRt3AZnc8lkpYwVCILqYg/T//VNahVPvFGwQ9kuDprKINQbLPb2xrivVU8w/IbO7xcl70KUqEdmXzOpCzp1VgncnV927BYt1t1k9jUlttUATs5jMx36sQ+vjoTr758yeF7/LYCkYSjW7rUmC7AyRgUs2u+qFYpqGiSMK+zhZWXcvopsB/Uov1divB+vBZuuMa9gqCkNsOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UpiN5oo4z3lvMmB3amQBIgcZf9ooTUIzQ5WEgszjOO4=;
 b=d50cU2wXXX4tpCgnPtBgw3FI+ThGtUmAiTH1UQ5VGYyTasQgEhYu2wCWokHn23qcV8EXFUzvuzAfSo5MQGPxiiy0BEH+XFXKNJFxIgG6eeOkYmFMcmZr6KOMxSSZlYjy43ohiSfWCzS6rojnuVWBQZJ5GCzF8Fl03LavhdeTe4q/+0BjDqafU2Ymhe8t+8oMPwzvRfwlhCGJ2ACwVavlxKndRy7zhe2LxPIVSlJFcgSiB1AsPJ+dodEOaBcVr25bIBiAqP9yyM9zWojGKkCYieC/vMxvtVYOyDh1yaPS6+ErHfGBZJhJB6QOmCTCrH3k5YSiZqVSooL2f7NJQ3CkyQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SJ1PR12MB6073.namprd12.prod.outlook.com (2603:10b6:a03:488::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Wed, 9 Oct
 2024 16:23:16 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8048.013; Wed, 9 Oct 2024
 16:23:16 +0000
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
Subject: [PATCH v3 4/9] iommu/arm-smmu-v3: Report IOMMU_CAP_ENFORCE_CACHE_COHERENCY for CANWBS
Date: Wed,  9 Oct 2024 13:23:10 -0300
Message-ID: <4-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <0-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0025.namprd13.prod.outlook.com
 (2603:10b6:208:256::30) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SJ1PR12MB6073:EE_
X-MS-Office365-Filtering-Correlation-Id: fdaad5cd-7566-4a9b-e640-08dce87eae34
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8l7TPVPIUxftarXeh6xoov6stLFcFUajRZ0AQWDehlA6lXrgcjTufwTLqjzy?=
 =?us-ascii?Q?J6+vTAvzAnqEp2zoeAWzSwBUJlYk/xueKOThrwFrzwEF3zWZRGg1+0yHuCcf?=
 =?us-ascii?Q?4uYafoGk0aMRA7M7kXpV1rcuidZ1o/8vnJKneDNg2EoIql3r74f1/J0i5h2L?=
 =?us-ascii?Q?stUAHJtBLk40dINnIjAoZcYOKrFb3NaiEJgB6weX/LM2z9nfuXTqyeTY0PmY?=
 =?us-ascii?Q?1L7q4ZKi7u3fjmnqPaj4FHL6ylkB8knc6dtJiOFouD2fncckchmPsIYT5jAf?=
 =?us-ascii?Q?Rha5TI9CzwKd6GXGlrQ6UUVRZ4+u8pdyiMAhSqB8CBzkfN5XkzYjr+vUChWf?=
 =?us-ascii?Q?PG6kkSAObZrKANrybdC+qv6rvBR+YbM8wNwd3q4ErKivW2GTemZxOJN7sev7?=
 =?us-ascii?Q?2QJZKD27y2vpCZ9lUkcQc3ayUAZyDt2wLOBuGEgzOT9ZLk2VUV0eY/7da00j?=
 =?us-ascii?Q?+Rl/YSxToBrYAwdex8ToiHAjjv9fb8/zd2RcT+bPvas5IWz8YnB/NFsbykkD?=
 =?us-ascii?Q?jI+TgwDeEt6pVZgCFWHGJyQq4u3tJ7fpCOYNQKsJrW1k1OQ599u3fTgQW0Xb?=
 =?us-ascii?Q?rQ5mJiLwR7aGTxmIZU0Xs5jhZylv1c+KFV9+7vgb15l6cw7/R+L9s/yeVoGR?=
 =?us-ascii?Q?XIcdN0R3k8r02u4HKVThCOwqxzNXDkcUs9RowfVD0+NINIAX9esvxKNbTsXI?=
 =?us-ascii?Q?Pd+7DKoPMHhIwerLhgsBnSJWB8bcJkbZxSWRVqHLcL9IcPvP/mdxHnBQqOKp?=
 =?us-ascii?Q?zQoCbi9L1sljX5My+bM8Awdex83X+7ersGi/nfw7267wHQ3U/AcaJCRJulmV?=
 =?us-ascii?Q?8fmbAu77azMrpDo1gOPnyf9KDtUJEc2+L9jaoQcSOGXjk3WXHebizXXf3C6a?=
 =?us-ascii?Q?vigoUbg2/A9W8kW+qoU9lwGMv4jGHzA4HFx/WlSTWFMuvLSX4Am43NaDryzK?=
 =?us-ascii?Q?IV4mA0mi9phA678pAeFoG6nydDZR/NUiB49PY1ubxBvB5ifiZkYaDKR8xapp?=
 =?us-ascii?Q?sjSuz8OVkdKSvXJJJKy+6zboesR/35WlCOlk3XL8dsxvJAW4k4O/M8VIp+Ws?=
 =?us-ascii?Q?PNmm02jPeuk47Mhaet4va2fjJsKcc7PjH79pQQHFleT1J2/YP3jnzyC4PTrT?=
 =?us-ascii?Q?f3efqe3idUH01vkbDBNGQGE4X9UH2wzvz6ZT00tYWXul9qJERTXGuxXYFdzd?=
 =?us-ascii?Q?SqNBpqmf+CxZXyoUd/X5OxWHQYilPe3AJBquuBugHJKy8FDqyyT0ZSnNgFxh?=
 =?us-ascii?Q?DcWNg/fYhEYhQMY4kzcElYbkf0+FTmtHUj9hmIzF38yXgINqhHkUFRp5ovRG?=
 =?us-ascii?Q?YpLKPU9LcW/qCC9/RyeucMhr?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ipMbwgG8999eMqS3NGhX+qqv1Dyqc41YuoLPJdhYlwQe7YkpcKRoxDnD9qyD?=
 =?us-ascii?Q?u32nhr9PfRsk0zyER77xTXurjj7hS3NMsHdDFulrNW/QP6bxLNK5gRlCZw0O?=
 =?us-ascii?Q?GfoJrdiuzzHZEEr/wRtofgBuivnX7bQuSx2ctCIno96a0HWoEk4fss7Ch2dV?=
 =?us-ascii?Q?FIWPR8Tmg5U41uXFT4TaPUZ2FhwqxaPRg/p7MclbsoRjvajx3zYjr7DnNjp6?=
 =?us-ascii?Q?ZPThQ5KgAKdKE85utyqPOcVZBqjK+SynLH+J8Mrg8smDQRCHgAd9e1cDE/F1?=
 =?us-ascii?Q?k4cgG/sbGmqOAu9e7EMRAFQrHefDiqesG9Cg/zmk2VInJ1ff0eQwUcBTwXiC?=
 =?us-ascii?Q?+7We7kE7InMJTTD7KIeSG/rPp2es4NT3vEveZLgeLGAB6wdY5dgaFaroivET?=
 =?us-ascii?Q?aCqipEOA6JeBhJgE5ps8fIR8F4kt0nWiRs9rX0X1/4FJijopWNsrdBD7w39X?=
 =?us-ascii?Q?DxDnSI/Ki6eGFGs8thP7FAaTgAut4jMg8gJXLqe0Riwqzz7/ha1DuWe32/xA?=
 =?us-ascii?Q?CJZs+DR4hrSXyOkwYc75L8HPd1z2CpiU5u2voabN/2PihaTTGZYfmFmxvBhI?=
 =?us-ascii?Q?bW5CJ3oC2CaeXEATapJyh5YPA4vIM2IRCXNp34rCIWG7i7o5nKDUIHLiRrAv?=
 =?us-ascii?Q?QQz6bwsm2kuAAVs86AxEujQ79bY8CwZXBjhWIValVkgQlKa2sH1gfkKTckH0?=
 =?us-ascii?Q?myEk7RJttI7n3AaLEvO/Xj37AVa1uCQYDzKnBeqORW6yhbnAr4UmqQXw4+e9?=
 =?us-ascii?Q?g1XnTgLvF4sRkcqeqvbBCMfEqMPQKUu+ba679ReA5/YdN56E7ywb2g7Zw1Uk?=
 =?us-ascii?Q?A1EG9UlACM0xUSMP0UJwHgijEcHpnFaEB8wkdmbrnqnABq1mDIodG7ncHZv+?=
 =?us-ascii?Q?Cn6YGxt5j60KApK72Y+cfhkxZkIWuEfna2c2tx544P163v0oahltI+Be9cFy?=
 =?us-ascii?Q?gomImmxxD+WaSnXt2fL/hZLnjPofNLNsvSDTNyrzIYIE6IToztxBu7y0/mBP?=
 =?us-ascii?Q?bRaxDlvuSwgPlepk0JIwLyDjESjBhmvSyPKrVvtothFioLhjn15DndJZ/CyT?=
 =?us-ascii?Q?UfxOj3eeu9QKbVWG+IkpiL73UlfFnL/Y3uAORwj5u2Ax5/FWD8FlWH7bXBcj?=
 =?us-ascii?Q?RIyuJqo1S2ghaiT/UKehoXrZShL5Tjeyw/qDeBivxJsZhJ7SOL0+fr9x2dE6?=
 =?us-ascii?Q?HqhmDiWJ1fdKS9oqstdkUYGDiZZNK9cm+tk3plJcccGggPCBGma4xRxKXTbk?=
 =?us-ascii?Q?+ZnIWu9wSXj+1uG3/+mCfKCv67eVIEHDLmQ8pma3Rm0+ZZJBXNEH+DQ3KGyf?=
 =?us-ascii?Q?fL88jINY5JUawCK3+A8XAvRFo8T+u5y4CwF2lwfyddKgJTYG8NAyeIXvor9n?=
 =?us-ascii?Q?S+W2VObMzqbQcz9HmF1BzxsHlU+YCBGMHzu/IwdHaTJqt7A/Nlnzrpgd5f3L?=
 =?us-ascii?Q?Kmu9osBP7ms9k3oEeagACF4tf1Af9ySJNB0qkkJFHFNzrTMDwCijtExZ3R7l?=
 =?us-ascii?Q?IjdThyQNmzdqYTE8oxqF8UMC/VB8Z1QTFRy2C0RpB31bHmCVOQSWrYIw7M9Q?=
 =?us-ascii?Q?YVeogeFfeju0Oh4w88g=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdaad5cd-7566-4a9b-e640-08dce87eae34
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 16:23:16.7719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tu/QoKBeEhfnrbPFzNBLBXOeGfW+110zvi186QV1iyiwNeRfUD/vW7PhqP66UKjH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6073

HW with CANWBS is always cache coherent and ignores PCI No Snoop requests
as well. This meets the requirement for IOMMU_CAP_ENFORCE_CACHE_COHERENCY,
so let's return it.

Implement the enforce_cache_coherency() op to reject attaching devices
that don't have CANWBS.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
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
2.46.2


