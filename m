Return-Path: <kvm+bounces-23574-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CC16D94AF82
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 20:19:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 29DEBB2158C
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 18:19:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D57D13E02E;
	Wed,  7 Aug 2024 18:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TiRSO24m"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2050.outbound.protection.outlook.com [40.107.95.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7077618EBF;
	Wed,  7 Aug 2024 18:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723054767; cv=fail; b=RLwMAzX2DdzEyCGa7PzGrGCR2Mcn5Ylx/tR5RN4jnl+j7R88E51qB7D2lfjZaBjfwSn7zEf0Fsv7fQAj4rzbp92eKboxkDRG8Grx961kvmOD9aFYJQhjNo5cQ2yNGFbZRl1neL0Hb6cnerunh7OkGUTdczDA/DD3X3wsGtqP88Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723054767; c=relaxed/simple;
	bh=ekKm0SudydNjyRpCcC2mMuFLsly9MBAZA5eALeH8Cfo=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=LC21+zIh78EAcbzNk0aVeKfPCuU2vbqjBD6c2Tg0Dlk2yWyquvmwvFThYRdSXa6OWsk+geWcI+oGLOtKPb4yHj0U0uvhG2IoiyiJBMlmM9K3bQQfpdVxQUB8pV9mvhsrWisCfjURycb+V1ufXNcvrqRMYIZXPB3wqdKE1gMMHUc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TiRSO24m; arc=fail smtp.client-ip=40.107.95.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PZD2dneXl7aRfcMCCiRAIPRPsU5cWns9eTeDw6nwBr7KaB76gJRQ5F5QbOKuAMA81XbP9BfoBSf39B7hBii50CTpcIzfJd8MvTmEtHZah3VsRafdZ3dlS6E8Iq1Tfba3sF5C7ZE4VmoG2jcYWFmu+t+BkQYbYVd3iaArBz4Gt31sv5RtLHk3CQLxO1AJqIrnL9fm2vu/gESv3RsL8XEEYGFFScJ375UyVyZ/m5Iu2EVNADz8hZzDG1oOJHWdMZ2iPyuf6AnmidheyfMny15ZMZ//f0aec7thuGR24MRqW9CikMJ2WYA0zEq1aGGPH0lTJe6P9Jzi6NHHp1wzb9xMrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K6WD6jm0UK5sPcjCZ/fAfsvVddmEtM5mTSnj/pU/fSs=;
 b=dAo1jF7KG0nOJtjh7ui3+d1EG9M5PIPY5LhXq3KDWJUdBu1fE8eq4U3y2PijV3OaLoce8IQWwpSJ5gW5AIETPIl+om+8lipMHiNRNO1pRET0ROsn15UyeZazhxK1Pe6NM3JV30Iy4xmKNZOf2hGv9etvlX1EKMVtko7m8mCd4icMb2ujYV8wMRsvxYRrEmDVDfRvJtncsyfekG6hqoaMK8yJG76xgCsJ86eEYwfmXjECl2ARCKsWdbDJRHkkgvUBBkAV4eCoeGU3GGVM2QwNukpSyAU0G1Cd0hqZGlMyCAfYHfuaiYCUSmj9YO6kY6938txE3L05QAgYafRO9MhpOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K6WD6jm0UK5sPcjCZ/fAfsvVddmEtM5mTSnj/pU/fSs=;
 b=TiRSO24m7dozQzgLo81vMKEdKGmMkc8d5kOr/KxWhNytbvHwcS3IRoUM8Qsi0mxL3ZD7f4rytk4zwFlcqRDS4vWtzqrp5rV8SimCm4W/cp40LlAxVU0ZSQJ/6PfK1mOQhikjeNkTsO5w0Y+sbJD/qdTI+EAvE/xvHl0WS/NYHIIabiKoyGVRyiFBidoPvWXIPGBulZK/Zge4aHqfQYniqgLhrmufFnTyqZtr3o8BAQVEys8t7shFzDg0z57jhm1JdTt14XbqznaSBneo1v6Z7irMLhjYLB8YZLC0ssDWdZ87HEqAo2lsAyyCj3qWM1ji2vul+Uwzw/sgj7kIahgcQQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by CH3PR12MB9021.namprd12.prod.outlook.com (2603:10b6:610:173::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.26; Wed, 7 Aug
 2024 18:19:22 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7849.008; Wed, 7 Aug 2024
 18:19:22 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev
Subject: [PATCH] iommu: Allow ATS to work on VFs when the PF uses IDENTITY
Date: Wed,  7 Aug 2024 15:19:20 -0300
Message-ID: <0-v1-0fb4d2ab6770+7e706-ats_vf_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P221CA0022.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::16) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|CH3PR12MB9021:EE_
X-MS-Office365-Filtering-Correlation-Id: c6b83c53-c14a-49b2-af7c-08dcb70d75ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Aa8NvXcflQhh130WjwGP+h3PjACK7Ww14i7qDFMoG0H43DXG6ge0jlwbaoRO?=
 =?us-ascii?Q?VkJ11cXMCUVnflx2XaOPFBhC8LeJB3O66mhX3vVegyKFTwFK6C2g9oLGTpJM?=
 =?us-ascii?Q?QFHvcuBSuroLvzVgB2S8oBw+EgmUH1JaP1Qc8I7TA1l8P7GRUVVCA497i7lo?=
 =?us-ascii?Q?/He2T2fPi7dgDYIqooB3RYxBc2hMw6kMCdqU5Lh9yqihmNXyG+m1L9kcKnp2?=
 =?us-ascii?Q?EE3zOrgfkMU4p11R4CGX+nKrDobu7Ps0ZkAdVnskAJt9Nfv6Vi+wWcZ341Z+?=
 =?us-ascii?Q?hCnnuxwdVhfDt/kH55B+bDInSvFO67h7k6vo0XVVZw567S3dPzGMQmNetA7U?=
 =?us-ascii?Q?Xlo/d5VshLwwc0GB/+Na8w+CUPrso53UhfRfO46EA62SsxtacccnNHXwwcsO?=
 =?us-ascii?Q?V4kHtjYgTKtzdxUYkN+huzFb0XTxBPKLvlqeHKmXFhMUublMvO3Ejb9tRVl+?=
 =?us-ascii?Q?B6lzYHFTUT15N3cc1uyTUSAn3tBcjXcryzLKSTQJy44HVF/ksdYuYT/2jHfJ?=
 =?us-ascii?Q?og7mvNiD49srR0bkU6cZNDcOhf+smQH2DL78ahbtDiB2YwJIBg0aeCKvK/A8?=
 =?us-ascii?Q?iQpOVdTyF96OHNjpKu9xBxLLyoxkJYJUKk83GhzGa/hW6p5J1q6SaAO9ftIq?=
 =?us-ascii?Q?tcAfEqn6S2xamwgyDvWXWJgSUnxmPf4cV7uTPjXbkqrpEdoyqMT+LvmbFMNI?=
 =?us-ascii?Q?URJwbjI+LQtnttxfch2MZQFDRD3UAGhNeEuZp43YUTjB0Q0U9KgCkva5Ks+1?=
 =?us-ascii?Q?TaouL/uwZHVnZrZGNAMVotk33K/IJkscqOGnFDxHLajOITerBbyKPXF4fAwx?=
 =?us-ascii?Q?uYaqtbwyp6Bt6pJdmFM1f1aDVtQfU0hAc7tje9COqmdJcdGLiNAQDUiqK/Yv?=
 =?us-ascii?Q?NdsBDSrDGjMVkM1HQAotzxj4VZMVsLDoOdb2DqdW8RiejLgIpCYxnTbw9f9g?=
 =?us-ascii?Q?zcxQ8f1VZidTUf2fq2gVltfzNZ0o+PmBjpRGIstMcNYYFJWWRc0feeKJcvm+?=
 =?us-ascii?Q?pMmBJ2JJN5g7WDZ6gUkxqafiKfU6Fsa54p/XkPq2g1c4JLdDQHAichpXwG/3?=
 =?us-ascii?Q?GN4xqnbKnhePvTFx1alspt+dbxib3BfmP3rNLDq9NL4lXCBj6cs4qwnZcdMw?=
 =?us-ascii?Q?SXlvVVafDcuBm2OxhxnYGFvv7HyoPYFiJd/6IggJe/ESK7/5qWqE8x0+tnNN?=
 =?us-ascii?Q?hemAi+w+6sRWIXvx2d1YpNsmT5z36CTsKM91j0iDaaX/Y0j6Mnr8iIhbnKcT?=
 =?us-ascii?Q?jZ/kUNtpnswFMuKDyLtnZ4aJ09ZrGmtUo7FOdMwk44HYtITluwD5UStKDXmy?=
 =?us-ascii?Q?QzbYsiz1kOOTAKaT9e3u1rYlPvaDxq29KHFNOGUhh8lXaAXvS/IuyMN9zqyA?=
 =?us-ascii?Q?wvh55DkFCxua/h1ifJkDOO0zVNBy?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7NyOWYTxbLyJp31ovh0C+tp0KtgV3ZCpNEtgbasDC9qrPsHkYzwJnTFxaDvB?=
 =?us-ascii?Q?laL6vSqLgsQQGw/hD3A6cRk703rd1H150oard3vXyr8YXVJyJvqxSU9OLzyo?=
 =?us-ascii?Q?5Yyt4dPc3Eb1aS0+G1BP7RLiAbElx1Z2Kvp1v8nC/lCDDiFZQFHVjKn8PaR1?=
 =?us-ascii?Q?M/lkey5G3b/zmKv4RV9Ns4Blm/mWTRFMS3X+1hGFBHDl4mc44+IhADuXNqyi?=
 =?us-ascii?Q?WZtB2uO51Sg8RYimz8ye7/EfeSXiCHBk8M8JI3zT3l84Tx2N8SHuwIaXJDrd?=
 =?us-ascii?Q?F61L7vTQq907dgcOaVUh7ngw5wKd8QCtYa8pTMg7rn2pUrLeFTq5BYJYQQpN?=
 =?us-ascii?Q?RAGdnkHZx45X4DoLIKb7wC+4i+oqU5wt30DAV68fySHowqmep6fBglqcwxMv?=
 =?us-ascii?Q?pT5TEZVItzNO/vJ47WIu9JxkrqCvkvmVy9zI/mydIfFezeGXDerJR3fCGJro?=
 =?us-ascii?Q?4dGNH0hr1TB45f94rxkj55Apag8Z+1FZ/cP1ClWo+Eug0bjl6N8RRoJ5k/F6?=
 =?us-ascii?Q?QX0vdAqduwz7hpSCE2kz5Y+BmXHaSjKD8AjnFXZwjLayktkNHn60v4jvzm/h?=
 =?us-ascii?Q?paNHcu0UJo2aImqdJPB06g6gWTIaXQhuL3HrsL6WMY8zAjtG8zhl0Gh8we5R?=
 =?us-ascii?Q?9EIsLbVjpP6hpyo+krLJ7svYSPLi0np3szHHKvw4PQV4VRi06zzpw+N2eyF+?=
 =?us-ascii?Q?qxAylQDpGGINcgVqir6aQ5CYNC7McaqjcqOdoXkt+HaJaJCHLcS55WW4PM/h?=
 =?us-ascii?Q?FoSm2M0Mibi75bwl1D9iC00Zagtpu2RrsQKCWW09rsE8LOAybdb4QpiDOOTn?=
 =?us-ascii?Q?2ZD7/QBIOQABlPw8neXWeBQd+TgWg9WRtZB+F9HNroysDmRUM0LwZOcHAqw/?=
 =?us-ascii?Q?peDpxlcrN4h+aChfeOH9NXj/RUDikW7wFjTfZGCdrVMObB3m2mjJgrKUuzTk?=
 =?us-ascii?Q?5yYI/vK6iGkp1wexIalURbUs0NCm+/y8Y4xSy1K6xTg23OKOQZGR8FC1EpTY?=
 =?us-ascii?Q?Qsyn+unRBEDM78FLWozJJvtsO1bTpPeLTd6KyuammmqtDUqEg/zWHvp37QkV?=
 =?us-ascii?Q?+dRLMiQNAE54cLRiIzxt2vNKe2iWME99dSr0KaJeVB+4kYsapkZa90RaZRuj?=
 =?us-ascii?Q?ATjtAEJVFE1CEjC9up2/QyBoS0alIQEpAy0UWDW3pu7GBJKA0u7se3RbcpqW?=
 =?us-ascii?Q?sPh29XmYO2q7cwwnl4RrnLsg+fmnfibOErvMWk8DFUsARLVXeSbCuklKTTms?=
 =?us-ascii?Q?HtFIzLG1NoV8sLWzphPBbRYSkkZUhaDMmGOsPGRW7O33cyuERXpUDoOKpz5y?=
 =?us-ascii?Q?WkqRO1IQqfg0lwWQneIqFNF4ER1QpVtbPkVqPj02WjOt4DyEsFYBVo73MSfH?=
 =?us-ascii?Q?TpC7uaOz/9OfxMsJUSF81Yx/UxqsUqqd79GicvIeg64aUTI0lRIZNanuj3CC?=
 =?us-ascii?Q?+7bxQrSWovtVN+X8PjTTf8P1HQVvAUU6/XFrnRosSczppT8mh9DJGNWZQl2B?=
 =?us-ascii?Q?K1eZopdkBwNROFdm5nhKUikd8Ts/NFesDri/R8INobs/i+kCuyQDVHJe5Pjl?=
 =?us-ascii?Q?fI+qaCCQVlJKds++ce0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6b83c53-c14a-49b2-af7c-08dcb70d75ce
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2024 18:19:21.9982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1HD6Tq665n11cFFmvCaodTCfM3pkR4kOiZu6iWrB0YXiZs4DpOmhrmhr+jRvjwOf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9021

PCI ATS has a global Smallest Translation Unit field that is located in
the PF but shared by all of the VFs.

The expectation is that the STU will be set to the root port's global STU
capability which is driven by the IO page table configuration of the iommu
HW. Today it becomes set when the iommu driver first enables ATS.

Thus, to enable ATS on the VF, the PF must have already had the correct
STU programmed, even if ATS is off on the PF.

Unfortunately the PF only programs the STU when the PF enables ATS. The
iommu drivers tend to leave ATS disabled when IDENTITY translation is
being used.

Thus we can get into a state where the PF is setup to use IDENTITY with
the DMA API while the VF would like to use VFIO with a PAGING domain and
have ATS turned on. This fails because the PF never loaded a PAGING domain
and so it never setup the STU, and the VF can't do it.

The simplest solution is to have the iommu driver set the ATS STU when it
probes the device. This way the ATS STU is loaded immediately at boot time
to all PFs and there is no issue when a VF comes to use it.

Add a new call pci_prepare_ats() which should be called by iommu drivers
in their probe_device() op for every PCI device if the iommu driver
supports ATS. This will setup the STU based on whatever page size
capability the iommu HW has.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/iommu.c                   |  3 ++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  6 ++++
 drivers/iommu/intel/iommu.c                 |  1 +
 drivers/pci/ats.c                           | 33 +++++++++++++++++++++
 include/linux/pci-ats.h                     |  1 +
 5 files changed, 44 insertions(+)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index b19e8c0f48fa25..98054497d343bc 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2203,6 +2203,9 @@ static struct iommu_device *amd_iommu_probe_device(struct device *dev)
 
 	iommu_completion_wait(iommu);
 
+	if (dev_is_pci(dev))
+		pci_prepare_ats(to_pci_dev(dev), PAGE_SHIFT);
+
 	return iommu_dev;
 }
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index a31460f9f3d421..9bc50bded5af72 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3295,6 +3295,12 @@ static struct iommu_device *arm_smmu_probe_device(struct device *dev)
 	    smmu->features & ARM_SMMU_FEAT_STALL_FORCE)
 		master->stall_enabled = true;
 
+	if (dev_is_pci(dev)) {
+		unsigned int stu = __ffs(smmu->pgsize_bitmap);
+
+		pci_prepare_ats(to_pci_dev(dev), stu);
+	}
+
 	return &smmu->iommu;
 
 err_free_master:
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 9ff8b83c19a3e2..ad81db026ab236 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4091,6 +4091,7 @@ static struct iommu_device *intel_iommu_probe_device(struct device *dev)
 
 	dev_iommu_priv_set(dev, info);
 	if (pdev && pci_ats_supported(pdev)) {
+		pci_prepare_ats(pdev, VTD_PAGE_SHIFT);
 		ret = device_rbtree_insert(iommu, info);
 		if (ret)
 			goto free;
diff --git a/drivers/pci/ats.c b/drivers/pci/ats.c
index c570892b209095..87fa03540b8a21 100644
--- a/drivers/pci/ats.c
+++ b/drivers/pci/ats.c
@@ -47,6 +47,39 @@ bool pci_ats_supported(struct pci_dev *dev)
 }
 EXPORT_SYMBOL_GPL(pci_ats_supported);
 
+/**
+ * pci_prepare_ats - Setup the PS for ATS
+ * @dev: the PCI device
+ * @ps: the IOMMU page shift
+ *
+ * This must be done by the IOMMU driver on the PF before any VFs are created to
+ * ensure that the VF can have ATS enabled.
+ *
+ * Returns 0 on success, or negative on failure.
+ */
+int pci_prepare_ats(struct pci_dev *dev, int ps)
+{
+	u16 ctrl;
+
+	if (!pci_ats_supported(dev))
+		return -EINVAL;
+
+	if (WARN_ON(dev->ats_enabled))
+		return -EBUSY;
+
+	if (ps < PCI_ATS_MIN_STU)
+		return -EINVAL;
+
+	if (dev->is_virtfn)
+		return 0;
+
+	dev->ats_stu = ps;
+	ctrl = PCI_ATS_CTRL_STU(dev->ats_stu - PCI_ATS_MIN_STU);
+	pci_write_config_word(dev, dev->ats_cap + PCI_ATS_CTRL, ctrl);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pci_prepare_ats);
+
 /**
  * pci_enable_ats - enable the ATS capability
  * @dev: the PCI device
diff --git a/include/linux/pci-ats.h b/include/linux/pci-ats.h
index df54cd5b15db09..d98929c86991be 100644
--- a/include/linux/pci-ats.h
+++ b/include/linux/pci-ats.h
@@ -8,6 +8,7 @@
 /* Address Translation Service */
 bool pci_ats_supported(struct pci_dev *dev);
 int pci_enable_ats(struct pci_dev *dev, int ps);
+int pci_prepare_ats(struct pci_dev *dev, int ps);
 void pci_disable_ats(struct pci_dev *dev);
 int pci_ats_queue_depth(struct pci_dev *dev);
 int pci_ats_page_aligned(struct pci_dev *dev);

base-commit: e7153d9c8cee2f17fdcd011509860717bfa91423
-- 
2.46.0


