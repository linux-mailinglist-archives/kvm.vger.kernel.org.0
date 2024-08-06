Return-Path: <kvm+bounces-23452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B48A949C69
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 01:41:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D1051282FFF
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 23:41:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECB90178361;
	Tue,  6 Aug 2024 23:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qeQop9My"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2078.outbound.protection.outlook.com [40.107.92.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F369176ADC;
	Tue,  6 Aug 2024 23:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722987694; cv=fail; b=Nz1+5VOvnMUH5U5fzvDjAY0KYgwV1U3CAYcc913+B/eZlH75lMYD7fowIzV/IAFu7iGUpV/CVOVd52yb1JaZK9l5I8A15VT3KkbIRTMKv9QrYoT0/DYTDpmQglUvJgWZmilPdbkT32KNxZhFaDY6KEViLc6pMouhGNz66xOlixg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722987694; c=relaxed/simple;
	bh=9zNKoHNh6fP0fqXGUmscopBXhaFfPocTnnmQyYWmhl8=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Vp6Z9lg2bKt6hOaykUsKFY64x21fSiaoHYqmiEtWTt7VeGg/yN4Ag35l01CM8pBHEStz3kJUHyn/jSBh8Fb2a5jUL9wNJ8YdlZ7ko8GaccaSYNgjwqBMWef4BlGua9H0VOyB5x5dDSPsvJJmqq4j9hOdLwIrNZdmJHo0kNglB5Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qeQop9My; arc=fail smtp.client-ip=40.107.92.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Uud/dldgf82qbHzCn7nS88NlGMxEYYQjUhm2jayK0mfA5V6naFEgQ0GHmVwh7ijC4FXawRucVPLa0OUctEdJ6r9fW9gOtt13bD/gcTrD4JLkPBrTNOhcYZxvZqJPCO2ZVR2eRC+eUVjz+BNghUQfFWXQNL8wQadnaq2Sy04xRIGrogkvjC/sWAYcHJVRvLAspWjP4qoEsU3t296oR9YMr5GeSrSG+nRUvSajpbqY0f6oUqKoXtPY6qdRatnjyDiFAuJHf+JzuTWyl7mPYhnZEovXdUybFO9z4fq0+CaUfqy1hmklE7kmCxjrTafAxlpbjyWkh5b8nJ6nDnTRgo6UbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kQnOObQ2Tw+DASc46sbnZDsJpR8alMQbzKHA9EuyZLQ=;
 b=vyGLD+i/IkIVJG58TYcmkoBRzvdxsH+zvwv80U5OB3nsCG1vBpCEAVkou5VP8jTnnRFFwDbhw4VJGvbGEw+4osj3YopRgG3Ndgt6B1PxwsGcsLt7/g8Ugsu/4kl/UXuvUd9DxNZoukTIWTvhB8MfsPYPEzKXqFlmwkEhKlkpe0pyjBKKkvXoqMpc380u5WUjemJHAX4CEn5PLeFhSa6CP9DcgBfnbD1PmZxDOgphu8VomojjoQWWVq75JUEjzw/e2kRwDuwZSmELF5Wz99m+NJf9mkcfjir+aARM7KHoRuVCE/q+UKVadU3BsojMVPfXeA6HMR3uBs6blxKnAnpR8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kQnOObQ2Tw+DASc46sbnZDsJpR8alMQbzKHA9EuyZLQ=;
 b=qeQop9MyzYfn6bYVIZrgpnuKa2mVwy7bSkYbfZVPAixTXqMwZVlvlH0dgcLPomFU4zNXQjDTRNNrSWsPlYVfp0ZxbhIQtSHELp8PODv+WFC0zWobcR3Bvs4lOE5Nd5IRkT/+nYDGQgx9NIffYNHP5jIKdWvvIHniwklfAsoRks3H9YU91J73dS5nCm0AAPYUfgGrMQli3mBk1yOcIeEDP/bsi3HbjgfHSXJMuLpC9gR59nYwVzxfmEWf0NhslvL1VDsWkCZsyxEfLEe0spBlveInIPeaWx6ECZcNbZVg+ycwomeYAOrRBeL6QZdEzbHRa17pEmN7+1nSUd8CtEW+0g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by DS0PR12MB9422.namprd12.prod.outlook.com (2603:10b6:8:1bb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.27; Tue, 6 Aug
 2024 23:41:24 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7849.008; Tue, 6 Aug 2024
 23:41:24 +0000
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
Subject: [PATCH 0/8] Initial support for SMMUv3 nested translation
Date: Tue,  6 Aug 2024 20:41:13 -0300
Message-ID: <0-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN7PR06CA0048.namprd06.prod.outlook.com
 (2603:10b6:408:34::25) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|DS0PR12MB9422:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a02c72c-d302-419b-41b6-08dcb6714804
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|366016|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?G5xULkvCiGOhwA0en24Bf5nJWqRHZ0vE7YXvCgCriW6PR0AOzhpD0yyKI8JR?=
 =?us-ascii?Q?AgcxvUQ8C32Q/+rSs1P9Z6BxvzITP73gXu6Shzc0UEu4u21HJHaEnBIv4zSH?=
 =?us-ascii?Q?YUymfPTvmltsI1VSy9RcOtKrpBbmJiSZSeTedt9GBokoE0helixQV2gW3pGq?=
 =?us-ascii?Q?G5bJNfOxr2pU1nLE12SbRLVR7+NM2OkBS/ybwrtCyBSSUHmwNuz1QHKq9juP?=
 =?us-ascii?Q?dOH8dUi315mK6BpxjTiGXXHnF+YYRu3X4qCKUuS6yjeDiGuUS0vyQAY4414j?=
 =?us-ascii?Q?IeAKlcFqkyi2Vn4Gd75CmNPMK3CY7XkcamgrCq6XZdYxfARhn1hhk6vj1is9?=
 =?us-ascii?Q?VCpLApGzidPFM+lGv2VW6ZuvnOAh1SbKunYF0PVXVTLuCP8jkT7R7mVGlrga?=
 =?us-ascii?Q?2dbXxCRFnisM+tUn9xRxQ+y2dABI1SU9MMnEA+51RYCFs5G1OZ7XHXr/j+s8?=
 =?us-ascii?Q?SqYunZGwucCqYMqgBmm2MtSleYzUSuGwVmfw/x6oMCLmfR6sMovXLR846X4r?=
 =?us-ascii?Q?gjywOZqM1dE1POby21fHR/5AT5gei0S00UoqKLCfBQ4Cl9gMaFI2v4mQLUwM?=
 =?us-ascii?Q?P9G6xJDaZWfZmdfAyst7Ext8tdzeGauZsIcbCf6q6t7qh9MQf6sjwcGHR5fn?=
 =?us-ascii?Q?gWQwSNGhyA5b7KUt6u7QB3YdA2H0Poc5u2L+LXzcKtd4+eIcIpwWxdFOr99d?=
 =?us-ascii?Q?gX+tXsMMkNdUzrhZmiJW5NCc84xfl8gW6dQc4AiMFeHPrFlB8gk2084VPc39?=
 =?us-ascii?Q?vfCqs/8pOSxGeo5W1ppYLrzwnGBdy8xInE1+CP7KkQ36TQun0Ho6x41LxHPl?=
 =?us-ascii?Q?Z8xI4mgXmXe2GERYFy0FxohgCPmC4O4V0e7K+m/ZadisPtJKSKW1neBs3bqO?=
 =?us-ascii?Q?JrZYrLFnK7I2e+FH0kJg+joweDyAYfdAxK4IxZzt/5vOfg8BRk7wOupA4Xf6?=
 =?us-ascii?Q?c3h0sF02HdqXwI9iziYXAtAT1/cDQB6H61qRKyYftb4/UL2FXzlaXrLrm9a5?=
 =?us-ascii?Q?4Fj+XEpU06euxeHmTrUTC3JTuxHugxlIGsKO/65vAr9CxJGKr9as9FkO70T/?=
 =?us-ascii?Q?P+Be89oNHMOLh7K1yOKBoGehCRKRpy4xNKxVQELC/TDQY07JLvK6cZcaLnAU?=
 =?us-ascii?Q?q0ZwfWZsCU/6Uc1Yj4I3FMkPamddRbIiL5xbzYpIDDh00EGdumYjnlj1hrK5?=
 =?us-ascii?Q?BjVg4Y92o6uG9krm8PPfTGZVqbyizlhqZWDN4sbA0kP+w40f9LsVOg20suf0?=
 =?us-ascii?Q?05qlgM3p98kJKuVD69TVo0iE+nhbMRyL0KWNxMg3y1R8jtSk8l523aFspNrD?=
 =?us-ascii?Q?6PU8ZgrkFRLZUTxIgpvgSTBXnhsfaMqD5xemM4WwapT6i1qX3DEDePaAVfhk?=
 =?us-ascii?Q?q86L3P6/f71PMzoMuZLIjvr3z4EnKhM3vAMo39E28xY3mwbX3g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VbOQyB92vMJkJ574gBSR5wRYPnhooisn03LIKZeKs9DCHEsTgMQg76HMvsSM?=
 =?us-ascii?Q?NDBMkLxrrxpcNpJThL0KRBhBbcNx3LfTLKTuondzq3cvrlIZLi8u7XdGETGv?=
 =?us-ascii?Q?SP50+SKKxn2LY+K44tWte6etSv1poEmTcjJKS5q/dhdRw3f7p813kTE0Qz43?=
 =?us-ascii?Q?teH0mB3wn0sN1TGNcMJZSvbt6qy8f0rrCsQGEI0pr7g7G8WaEGSgFoSK6O+B?=
 =?us-ascii?Q?q4TSTldxTC6TQmcs42ipmbo1eABWq6R/F1BhKIr3PsvO+O7bNgz514hBP5zG?=
 =?us-ascii?Q?KAw8U0bA+lhDzD9KpS1AYxsR+LLq/3pT3RKjp5Fx8tQaA0/F35zNhcnNloMh?=
 =?us-ascii?Q?bZwxFSIqtrBwj9ZKtX5MO7V7hqLs27/58aPXUIzzHTQb3mnOqwkOMUxutWNE?=
 =?us-ascii?Q?L2XXvr72rFwmJ/u3PpejlKVDdONQKGIXYE1wmjO9woqJNvv+rDHV7/5dgf1a?=
 =?us-ascii?Q?abwD0cRk8HXW4Dh0SbNpkB9quphLRtv/6YEkURDjQxj++MF29E7OgNfX84kj?=
 =?us-ascii?Q?Djt6zjQ1KjIg/Hc7/eMVzffSxJPCKsJ8VN3S+wNQwxGr3mkgThwFmRVXyrxB?=
 =?us-ascii?Q?1Ld00Mn8Bdt4yOB2OoHUtmAf7bPcgcEaenb1cV4uuPnoZ+Ts3W0T95ljQnAW?=
 =?us-ascii?Q?TAziulO5X8gQKNZt2fxmLzkAzsKHO6h1Hu1+mN7UhjG9ZulpYxbJEs4K1iPB?=
 =?us-ascii?Q?EM82VxmYvebtjEsPR+Sg5jWlQJzOKX51Ax6HdugTGxptnd8qyC0O39reOcq7?=
 =?us-ascii?Q?DUh06pdQrpBe0Nxq34jBBoUVFN8dqwj1PQPCdJAWXKGoa66D6BxM4xEkac2v?=
 =?us-ascii?Q?iK44YTfDy7itxnz8viKLt6BayQP0GjYNXpICXrd8DP1hCHGQ2DcUfh+qNtXj?=
 =?us-ascii?Q?JnmOTuWUUNaE16x3bgp5AOYbwmMAeSmHrvF1vUy+/n45nYvhGpZMSibC+rGh?=
 =?us-ascii?Q?zVytOd/lfG278gWHla/uhsJukCEn8HAHcwbWrD78Idd6wNWoGkadreesQwSW?=
 =?us-ascii?Q?YqU6jujR7NWOw9D5GZJLLqcZOdX6xSw2lCOhSUFvl5JQg5wFQabPy7Ux1kAS?=
 =?us-ascii?Q?QT8wBlMVSGSvpTVk3PP99k9df/eEYKOzPLXTqpy8kEIyA371S/kftoflIadR?=
 =?us-ascii?Q?AFYhDdYyD9kd1LqNU0yBPnBCNHZgzKvIKQ6jVPgmIWKLVteUtzvO6Gtqg9fN?=
 =?us-ascii?Q?QVFPII7AQ/XTyZpHTSrUZIrYjCdJfb/rv5upAV4i/zs60QzNMUWCIc4DG9w4?=
 =?us-ascii?Q?E/pyLsacZjpX12gyQQgY7Sbafk2LAoA8UcJX6kLQtton1MSRPCveomvdObBm?=
 =?us-ascii?Q?OXglcgDxwU2FWKMl5v+3S0/1UAqeTnvcQjFW2f5PDq2KSYjUUbvh1+vPpScY?=
 =?us-ascii?Q?3tUbIKa9x1jBaC1F7JF6LBaFG1y7PVcaDDwwWMW3PKE1IofosP2NGwSO0aSL?=
 =?us-ascii?Q?O+jUlNv+rxI9G7oUQ+AdaXBBIXQ2TDElclu9Xtnv4eaUvPr7b8kmakDMek+i?=
 =?us-ascii?Q?XMGGheiJFPSdh07YaJ91Of2fUMraHOOzmXpl2Vsd7BVIpdlvO+3O6hXtQrT2?=
 =?us-ascii?Q?+rYhbt2ZMNPn0kqSSgE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a02c72c-d302-419b-41b6-08dcb6714804
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2024 23:41:23.6382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mDm1JHpOGPjhPRZqOXT0l3BTuSTXnc7+SM1r/3ydAm7j+KzLg7rxm0m2VeFCcDvQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9422

This brings support for the IOMMFD ioctls:

 - IOMMU_GET_HW_INFO
 - IOMMU_HWPT_ALLOC_NEST_PARENT
 - IOMMU_DOMAIN_NESTED
 - ops->enforce_cache_coherency()

This is quite straightforward as the nested STE can just be built in the
special NESTED domain op and fed through the generic update machinery.

The design allows the user provided STE fragment to control several
aspects of the translation, including putting the STE into a "virtual
bypass" or a aborting state. This duplicates functionality available by
other means, but it allows trivially preserving the VMID in the STE as we
eventually move towards the VIOMMU owning the VMID.

Nesting support requires the system to either support S2FWB or the
stronger CANWBS ACPI flag. This is to ensure the VM cannot bypass the
cache and view incoherent data, currently VFIO lacks any cache flushing
that would make this safe.

Yan has a series to add some of the needed infrastructure for VFIO cache
flushing here:

 https://lore.kernel.org/linux-iommu/20240507061802.20184-1-yan.y.zhao@intel.com/

Which may someday allow relaxing this further.

Remove VFIO_TYPE1_NESTING_IOMMU since it was never used and superseded by
this.

This is the first series in what will be several to complete nesting
support. At least:
 - IOMMU_RESV_SW_MSI related fixups
 - VIOMMU object support to allow ATS invalidations
 - vCMDQ hypervisor support for direct invalidation queue assignment
 - KVM pinned VMID using VIOMMU for vBTM
 - Cross instance S2 sharing
 - Virtual Machine Structure using VIOMMU (for vMPAM?)
 - Fault forwarding support through IOMMUFD's fault fd for vSVA

It is enough to allow significant amounts of qemu work to progress.

This is on github: https://github.com/jgunthorpe/linux/commits/smmuv3_nesting

Jason Gunthorpe (5):
  vfio: Remove VFIO_TYPE1_NESTING_IOMMU
  iommu/arm-smmu-v3: Use S2FWB when available
  iommu/arm-smmu-v3: Report IOMMU_CAP_ENFORCE_CACHE_COHERENCY for CANWBS
  iommu/arm-smmu-v3: Implement IOMMU_HWPT_ALLOC_NEST_PARENT
  iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED

Nicolin Chen (3):
  ACPI/IORT: Support CANWBS memory access flag
  iommu/arm-smmu-v3: Support IOMMU_GET_HW_INFO via struct
    arm_smmu_hw_info
  iommu/arm-smmu-v3: Add arm_smmu_cache_invalidate_user

 drivers/acpi/arm64/iort.c                   |  13 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 398 ++++++++++++++++++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  27 ++
 drivers/iommu/arm/arm-smmu/arm-smmu.c       |  16 -
 drivers/iommu/io-pgtable-arm.c              |  24 +-
 drivers/iommu/iommu.c                       |  10 -
 drivers/iommu/iommufd/vfio_compat.c         |   7 +-
 drivers/vfio/vfio_iommu_type1.c             |  12 +-
 include/acpi/actbl2.h                       |   1 +
 include/linux/io-pgtable.h                  |   2 +
 include/linux/iommu.h                       |  54 ++-
 include/uapi/linux/iommufd.h                |  79 ++++
 include/uapi/linux/vfio.h                   |   2 +-
 13 files changed, 572 insertions(+), 73 deletions(-)


base-commit: e5e288d94186b266b062b3e44c82c285dfe68712
-- 
2.46.0


