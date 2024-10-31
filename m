Return-Path: <kvm+bounces-30129-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C3579B710B
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 01:22:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 83F05B2155F
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 00:22:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4965E42AA5;
	Thu, 31 Oct 2024 00:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="p03UlZ0Y"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2061.outbound.protection.outlook.com [40.107.101.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18E6335C7;
	Thu, 31 Oct 2024 00:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730334077; cv=fail; b=BXCK+pjoab6pb03sg67aZE9Cs7y6ekrCdDhXv1ZHTgSN3C83fzetz/aI1vmXiwaerQQWUMFY/XbP+JOVzoKbQr8cdcyssg0FSH1nVCLTbmuOolksAnzzRts9DX7p2hqAIbdBeL1/CxojgwIUhTNy5IS22viwIez62JJPvcBrQKg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730334077; c=relaxed/simple;
	bh=5YlgqYr1sAP7mYAMbnmW5KBNORgsrxIxjMRw5FwdKRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mvRFj7QWSKAKUIZNQkGwYeSxNwdTeTo3bjFsL6QthAyymkjGNwa/Ab0qv7W3AH/l0FWhACadxTPtmXtkel2tfVYzt9QNyrB6+rqN95dPN11VtrkfWINXTkbTqTVNcGMgS4/AgFd52vkoXVjspfvqRjdTvC93wy/KYMqQHg0i1wQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=p03UlZ0Y; arc=fail smtp.client-ip=40.107.101.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gew262BELVcVKxGyoX8aLnDE2mbUFSn201B88cr2BGu8qdFsPBDxf+8vQjjj+vUOYpqGnykw1Clo8CmSS/5iUZbR00HvRt0+SGjCHwdL0Vwmm0PT17QVCKY2uvDJQ69neqRkJD2DYmnwbL8ZUDVe1QMh1mAR4Fsh8Hk4XiHkmO6b8cD+1WRtr209HMZWcULBGDryYbk5qOa6zKNNnBhRzZA2K90BpdI7yljBFl3a0HhziBuaKKixodoSzGWK/0CpxGF1tlu3bT9gXflGBGXZ62TozcBO3RkGBo+Dj7P8jRIdgCoHwPZ5izAB8/RNqDRiLaC2bOkgz3qG5bFpJetr1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yRZgX+TD2Dgdjk98AertAXjeTWaJZxm5hmfuxt/4kwo=;
 b=Ega77o+B9ILet7p65Ws8tIHAFGwxOfzmoZNcYCTstdi4Yd5p72YIrWXJZLwoCK3RJCkXvfVF2WRXCGvuAwZukNpszeOQC7p//bDqqBGmYYt9aNyAw1U5mq8ytuLtafYJxH6WL8TQfN5dcatb2RABEpVqfqE7oaLBGB8vvfYgh4maFFEaP+TeEx681Vx79gQlG4olE/AgyvXuJFJ6EooBQw9TzPU1lqoGalOsAaQfR69OKDrtn9R7v+TUdI12+BG+9wPxji/JRrWFt4sv5x92umwjoBJ2C+Rbovc4GcLuuebPeVnKPekTAAOjqYtB87gd+vvAf63cgugUXhKtvCO+4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yRZgX+TD2Dgdjk98AertAXjeTWaJZxm5hmfuxt/4kwo=;
 b=p03UlZ0YrjW4hBAI29NEm5BdhdgrixS6fyK630YRS49jeScjplY3GKhuDJRK7Bw52s/w7buaSzap02KLnIYRUOkF3ZCxCYZpZi11kW5qpdFptTxX9cnj9R63z7U7Pg9hghlG/elq3YCmfBFNZlxSo2bUvkxk2jyLVHppMenb8eWXX4qnvqLBJySz25dddu9GX5PrxR+flZO1VaiiiRoBDcFkhqFLToHV9KSXOfiAQsL7+VbI1dTJs8oZBUtKeb20oCHg8m7PjbMOOSRtNNSdY18QYeADFFpAn4CqLqfSe3kEODJMqnRqo/PA2ujvUZG8NoFDBWF0Z69amyK7H0ywqw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM4PR12MB7573.namprd12.prod.outlook.com (2603:10b6:8:10f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.32; Thu, 31 Oct
 2024 00:20:59 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8093.018; Thu, 31 Oct 2024
 00:20:59 +0000
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
Subject: [PATCH v4 10/12] iommu/arm-smmu-v3: Use S2FWB for NESTED domains
Date: Wed, 30 Oct 2024 21:20:54 -0300
Message-ID: <10-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
In-Reply-To: <0-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR03CA0014.namprd03.prod.outlook.com
 (2603:10b6:208:23a::19) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DM4PR12MB7573:EE_
X-MS-Office365-Filtering-Correlation-Id: 5dee156e-cf9c-4db9-17c9-08dcf941e441
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TDppOOF6YMWaudYqpSIOhMWiivwO87ahxiv1USsysjrYz+Lo0R+x3pUYes+a?=
 =?us-ascii?Q?k4X9eYTXvN0ocBsn02rgfMKNXxsVRubI2I7fljWn8C2WKoplXI1t//kn/aBD?=
 =?us-ascii?Q?eNqhwcdmuKHMZfiEp0rWFwQ17ROkRL++TNHY72YqXH2K2U2F97ktIisom5tz?=
 =?us-ascii?Q?+w/OmUIh0A9zhuey7Efebb6JQD9QvO3e0txe0aGZts5wNFu+q36awNlcGaw+?=
 =?us-ascii?Q?e6pLMs8Y5/jZB9maLIEvfFlY5cJrEBxS9H+MCOK7Kyd8apsM3D40CXr8UF1g?=
 =?us-ascii?Q?Q8zCu+o/uyJIpkI/vVqBYSmOz6kIGC1MGwYYKs3AsEYkUXMbar0HDxmNG51c?=
 =?us-ascii?Q?0xTghfTP9KxreQXVur6DG+H2DmD8iKUbnVGOUEWuw2r+TlW57/PKUF/mXl99?=
 =?us-ascii?Q?03eF2tfyVMI2FYu/eIXP3H2xvNTRKlSk3gh6XuKq+444qw/szRO0Fl6RWI04?=
 =?us-ascii?Q?waUH3YuYPZumK7I0FFHuQbdN8ZQ0gaI7sBbjYiHqjqd6xD4C+EzwwiwacO65?=
 =?us-ascii?Q?myVP+M++tzrPU20yqX4ixwzdIhdCPgETchv4PoWvlmBxyvh8JAcE3KMyc69a?=
 =?us-ascii?Q?fPzvmYD1hDj1vDPOI1CuDNBsQ+Ruwr1ZvJEGrsHS2V2WRaWEm4/0k6jXQo8A?=
 =?us-ascii?Q?NHgGTq9D08CnM7vrR1a1VeqGwfPD77lyr3ulx0+lPqcMcEOoN+vW8JQ7kJZV?=
 =?us-ascii?Q?3sv5YlfcYEDYuCylP9ML3rRMbSGDkvZ0uciAZinHvxEc/TMGhX9T9ZwL3Jry?=
 =?us-ascii?Q?UEvC0ainBsSxegjI/NUMWxAlY9jIQxanC1ywcnyzxlwDk2vUVv3AXUvZP5NU?=
 =?us-ascii?Q?Fm2piOCBC/RHaeT7uTS9M+J8FON2CvHPmtrfksPaRa01+PVsuXc1oAcGPSQI?=
 =?us-ascii?Q?UXV0m/jfdp2Jy9+2G7UxbHM/7b3QjPKqrE87a5QumyNthmyRctgHkOs/bZeE?=
 =?us-ascii?Q?Op7Wc7abOL+mlCzVLUz+pkGlk10S3PiO+FrH1YSQC9FfbVuOLswTqv9AwEJ+?=
 =?us-ascii?Q?1LK1+xbtdYqBWz93vJohALhJphyANckz8p/RL/SgM4KE8LwnUAYa8S7/Xya+?=
 =?us-ascii?Q?scXITyEwEPelaBV9/tS+Ngli+nA17Qg14pHBHTwBiqPmPgiEB20gld+22tUy?=
 =?us-ascii?Q?2ctD75+ZGIOF6rO9SLhL19OAoLbmY934JZe3ysfPbIE0dSf7bATYVkBoaTLE?=
 =?us-ascii?Q?mnBxP+YwV8LefSya74o4NB50qngfl2JSTwdCRdlYkcQJHETJAT03yd5G7enl?=
 =?us-ascii?Q?LcpAd87uNXfWJ0ABglDEN81kb8tqrlJcZZat65GRN5OwN517Kumvg8pDtv+X?=
 =?us-ascii?Q?pM+fvz88yMt+VXpmamjbD+n2AHVB11ecH+QoYogo+wVoKo5gVw+P7ggFHaMn?=
 =?us-ascii?Q?2T3YHRo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gNuw1/ADpdp4JKt3JVnRfpuA1O4LRQIJInzWzziK4jyqyRNK0StrCPDHkCxY?=
 =?us-ascii?Q?Z7KFzHix7I1LRT9Hdg16vwjGEs5B3UscmxxOeFiQzdK6tn4XsW1E5r8t+ZjO?=
 =?us-ascii?Q?qbm0WFvKrbsdUB6y2gN/FPmjLojGCPRB5rQXTEi6exGK7W/OzGn25XrrX96J?=
 =?us-ascii?Q?xWoDSS8tpiXHo5BG3p6Na7MyKzM9O4Itb6G7WNsQJCx1+7+Ytdq3cJEWhiFo?=
 =?us-ascii?Q?JBjPFzgKpHCzhzjs6HLVzzWP+7Yp5qWrOmb2b7SOhHTyRXylWrOUd4qsRQsA?=
 =?us-ascii?Q?1eBYPf8WPGLgtKWX8xWXXEY7Nt5ADYAPsw/v5p3Yn+0D5eRL08T+9fblE576?=
 =?us-ascii?Q?xXbrEiEnWvPCBMMAQHNEV7ISoxEaHYvfhMe3neKDwbMpLUXG/YEXv1T9u/Hc?=
 =?us-ascii?Q?1nUtMhhO5wb/fnt1ksk85/Mwdf1FnyXw8IwqZXtl3Jl/9KhPGnaq8jCkdRgM?=
 =?us-ascii?Q?ndoKOBFTqK40NwgWdTmrLYzpxjSleeBVjUvz8P9yJ/tbENV4FMZitbFGesGY?=
 =?us-ascii?Q?SfzGYhHyluMPGCKW4uYE+GwHW1O2J6dzeFE5ReCuZjMeRN5pPeCQI7g6VaBV?=
 =?us-ascii?Q?A8DZL/RAj+D5XaGbdJAgFxlM2KFM74pSdL84EwK5xM8WQNmuuEnf8u063B3R?=
 =?us-ascii?Q?+Pj+gXqyHOZUn1W+UWu/cu2/W3yuTW/2fHUdYUaQj4xURIrHfvtk2H7bkKdi?=
 =?us-ascii?Q?6NYxjfXRe2aAvPIdi3KJbpeYKhjwBcu9NckVgKSk+s0CWHpY/U0PnrsUF5Xk?=
 =?us-ascii?Q?8gscip9B82sniT/HOnkevNK5EceQ50qNyegSbGySrbMp+sOQP9XwKZVRmVU2?=
 =?us-ascii?Q?MnBChGzz3Higwg2jS4UXyfQX9LbOAkukeXhnaLwLtdPw6v5MRDT0dg6ialuf?=
 =?us-ascii?Q?Q1cHKAYEqsIi8b44ey1DDRA3SBC5yqGshJ9WcBEp5y6rJQJbGQegZiP3xKvP?=
 =?us-ascii?Q?scI+Y8dvrjoyo5+LC7ye4dvrj9jZYe3/lOwUTP6glafA1Wj8elUU3v/OP3FV?=
 =?us-ascii?Q?ya5Pb/PKa4tlaCyGrU6YSRYQPpEB3gC2hmlzCvqC4TLPnYe62XylpVG00OGy?=
 =?us-ascii?Q?mNcy2+j4cUzG8MAwilNfGTeam0Jxh1bkxpNjJdjZwas4KE24qTjOn7x4FVlR?=
 =?us-ascii?Q?qzJWsKwvLgtHPluNNNYKMl9NDMVandtanmbn9glMn4niKBmAGSq0f3oNTQlL?=
 =?us-ascii?Q?tCIz7GjM9BrpyMzTD7eJR/sHJJt7wMNjFSx6aP8pH0V/JtqiNEr7SKLJK3vb?=
 =?us-ascii?Q?JXn2SU7mblfpMiSzdEPI5fcx2pGbo3VWgD+JgCLCXM92rY5QM6C1+R1yqF5E?=
 =?us-ascii?Q?RX68aMAdk3F9k0jlNOEdQAz5AP34vlN9ZMbPBfombCX3GtTpLKECrS0GJ0C0?=
 =?us-ascii?Q?pZCvso+Xe5qp28s+adeU02NV+i5yCHtBgjtShLppTTwKhmaeK+mOfDf2KIOS?=
 =?us-ascii?Q?ALv1vDnS8RuxVU0P5mTaoFMGzupiF8jYH+Q1B6rlnAUdxl81vPJAoVAsBraR?=
 =?us-ascii?Q?hIAKHoNkKFPr1f7JemkkPVBCvZ8YMy8yQzefXYO0iFg3k+gN/aELZndQJVSA?=
 =?us-ascii?Q?r+2ADXbrWRbW1+8Gygo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dee156e-cf9c-4db9-17c9-08dcf941e441
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2024 00:20:57.9935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BK42XmdFcZI37/CvddPOWh3nzvqiYMkzKxYxfJ544g0V23aqUFTTG9xCV1vNk/ie
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7573

Force Write Back (FWB) changes how the S2 IOPTE's MemAttr field
works. When S2FWB is supported and enabled the IOPTE will force cachable
access to IOMMU_CACHE memory when nesting with a S1 and deny cachable
access when !IOMMU_CACHE.

When using a single stage of translation, a simple S2 domain, it doesn't
change things for PCI devices as it is just a different encoding for the
existing mapping of the IOMMU protection flags to cachability attributes.
For non-PCI it also changes the combining rules when incoming transactions
have inconsistent attributes.

However, when used with a nested S1, FWB has the effect of preventing the
guest from choosing a MemAttr in it's S1 that would cause ordinary DMA to
bypass the cache. Consistent with KVM we wish to deny the guest the
ability to become incoherent with cached memory the hypervisor believes is
cachable so we don't have to flush it.

Allow NESTED domains to be created if the SMMU has S2FWB support and use
S2FWB for NESTING_PARENTS. This is an additional option to CANWBS.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Reviewed-by: Donald Dutile <ddutile@redhat.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     |  7 +++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  8 +++++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  3 +++
 drivers/iommu/io-pgtable-arm.c                | 27 ++++++++++++++-----
 include/linux/io-pgtable.h                    |  2 ++
 5 files changed, 38 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
index 0b9fffc5b2f09b..b835ecce7f611d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
@@ -214,9 +214,12 @@ struct iommufd_viommu *arm_vsmmu_alloc(struct device *dev,
 	 * Must support some way to prevent the VM from bypassing the cache
 	 * because VFIO currently does not do any cache maintenance. canwbs
 	 * indicates the device is fully coherent and no cache maintenance is
-	 * ever required, even for PCI No-Snoop.
+	 * ever required, even for PCI No-Snoop. S2FWB means the S1 can't make
+	 * things non-coherent using the memattr, but No-Snoop behavior is not
+	 * effected.
 	 */
-	if (!arm_smmu_master_canwbs(master))
+	if (!arm_smmu_master_canwbs(master) &&
+	    !(smmu->features & ARM_SMMU_FEAT_S2FWB))
 		return ERR_PTR(-EOPNOTSUPP);
 
 	vsmmu = iommufd_viommu_alloc(ictx, struct arm_vsmmu, core,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 53f12b9d78ab21..de598d66b5c272 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1046,7 +1046,8 @@ void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits)
 	/* S2 translates */
 	if (cfg & BIT(1)) {
 		used_bits[1] |=
-			cpu_to_le64(STRTAB_STE_1_EATS | STRTAB_STE_1_SHCFG);
+			cpu_to_le64(STRTAB_STE_1_S2FWB | STRTAB_STE_1_EATS |
+				    STRTAB_STE_1_SHCFG);
 		used_bits[2] |=
 			cpu_to_le64(STRTAB_STE_2_S2VMID | STRTAB_STE_2_VTCR |
 				    STRTAB_STE_2_S2AA64 | STRTAB_STE_2_S2ENDI |
@@ -1654,6 +1655,8 @@ void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 		FIELD_PREP(STRTAB_STE_1_EATS,
 			   ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0));
 
+	if (pgtbl_cfg->quirks & IO_PGTABLE_QUIRK_ARM_S2FWB)
+		target->data[1] |= cpu_to_le64(STRTAB_STE_1_S2FWB);
 	if (smmu->features & ARM_SMMU_FEAT_ATTR_TYPES_OVR)
 		target->data[1] |= cpu_to_le64(FIELD_PREP(STRTAB_STE_1_SHCFG,
 							  STRTAB_STE_1_SHCFG_INCOMING));
@@ -2472,6 +2475,9 @@ static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
 		pgtbl_cfg.oas = smmu->oas;
 		fmt = ARM_64_LPAE_S2;
 		finalise_stage_fn = arm_smmu_domain_finalise_s2;
+		if ((smmu->features & ARM_SMMU_FEAT_S2FWB) &&
+		    (flags & IOMMU_HWPT_ALLOC_NEST_PARENT))
+			pgtbl_cfg.quirks |= IO_PGTABLE_QUIRK_ARM_S2FWB;
 		break;
 	default:
 		return -EINVAL;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 3fabe187ea7815..5a025d310dbeb5 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -58,6 +58,7 @@ struct arm_smmu_device;
 #define IDR1_SIDSIZE			GENMASK(5, 0)
 
 #define ARM_SMMU_IDR3			0xc
+#define IDR3_FWB			(1 << 8)
 #define IDR3_RIL			(1 << 10)
 
 #define ARM_SMMU_IDR5			0x14
@@ -265,6 +266,7 @@ static inline u32 arm_smmu_strtab_l2_idx(u32 sid)
 #define STRTAB_STE_1_S1COR		GENMASK_ULL(5, 4)
 #define STRTAB_STE_1_S1CSH		GENMASK_ULL(7, 6)
 
+#define STRTAB_STE_1_S2FWB		(1UL << 25)
 #define STRTAB_STE_1_S1STALLD		(1UL << 27)
 
 #define STRTAB_STE_1_EATS		GENMASK_ULL(29, 28)
@@ -740,6 +742,7 @@ struct arm_smmu_device {
 #define ARM_SMMU_FEAT_ATTR_TYPES_OVR	(1 << 20)
 #define ARM_SMMU_FEAT_HA		(1 << 21)
 #define ARM_SMMU_FEAT_HD		(1 << 22)
+#define ARM_SMMU_FEAT_S2FWB		(1 << 23)
 	u32				features;
 
 #define ARM_SMMU_OPT_SKIP_PREFETCH	(1 << 0)
diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
index 0e67f1721a3d98..74f58c6ac30cbd 100644
--- a/drivers/iommu/io-pgtable-arm.c
+++ b/drivers/iommu/io-pgtable-arm.c
@@ -106,6 +106,18 @@
 #define ARM_LPAE_PTE_HAP_FAULT		(((arm_lpae_iopte)0) << 6)
 #define ARM_LPAE_PTE_HAP_READ		(((arm_lpae_iopte)1) << 6)
 #define ARM_LPAE_PTE_HAP_WRITE		(((arm_lpae_iopte)2) << 6)
+/*
+ * For !FWB these code to:
+ *  1111 = Normal outer write back cachable / Inner Write Back Cachable
+ *         Permit S1 to override
+ *  0101 = Normal Non-cachable / Inner Non-cachable
+ *  0001 = Device / Device-nGnRE
+ * For S2FWB these code:
+ *  0110 Force Normal Write Back
+ *  0101 Normal* is forced Normal-NC, Device unchanged
+ *  0001 Force Device-nGnRE
+ */
+#define ARM_LPAE_PTE_MEMATTR_FWB_WB	(((arm_lpae_iopte)0x6) << 2)
 #define ARM_LPAE_PTE_MEMATTR_OIWB	(((arm_lpae_iopte)0xf) << 2)
 #define ARM_LPAE_PTE_MEMATTR_NC		(((arm_lpae_iopte)0x5) << 2)
 #define ARM_LPAE_PTE_MEMATTR_DEV	(((arm_lpae_iopte)0x1) << 2)
@@ -458,12 +470,16 @@ static arm_lpae_iopte arm_lpae_prot_to_pte(struct arm_lpae_io_pgtable *data,
 	 */
 	if (data->iop.fmt == ARM_64_LPAE_S2 ||
 	    data->iop.fmt == ARM_32_LPAE_S2) {
-		if (prot & IOMMU_MMIO)
+		if (prot & IOMMU_MMIO) {
 			pte |= ARM_LPAE_PTE_MEMATTR_DEV;
-		else if (prot & IOMMU_CACHE)
-			pte |= ARM_LPAE_PTE_MEMATTR_OIWB;
-		else
+		} else if (prot & IOMMU_CACHE) {
+			if (data->iop.cfg.quirks & IO_PGTABLE_QUIRK_ARM_S2FWB)
+				pte |= ARM_LPAE_PTE_MEMATTR_FWB_WB;
+			else
+				pte |= ARM_LPAE_PTE_MEMATTR_OIWB;
+		} else {
 			pte |= ARM_LPAE_PTE_MEMATTR_NC;
+		}
 	} else {
 		if (prot & IOMMU_MMIO)
 			pte |= (ARM_LPAE_MAIR_ATTR_IDX_DEV
@@ -1035,8 +1051,7 @@ arm_64_lpae_alloc_pgtable_s2(struct io_pgtable_cfg *cfg, void *cookie)
 	struct arm_lpae_io_pgtable *data;
 	typeof(&cfg->arm_lpae_s2_cfg.vtcr) vtcr = &cfg->arm_lpae_s2_cfg.vtcr;
 
-	/* The NS quirk doesn't apply at stage 2 */
-	if (cfg->quirks)
+	if (cfg->quirks & ~(IO_PGTABLE_QUIRK_ARM_S2FWB))
 		return NULL;
 
 	data = arm_lpae_alloc_pgtable(cfg);
diff --git a/include/linux/io-pgtable.h b/include/linux/io-pgtable.h
index b1ecfc3cd5bcc0..ce86b09ae80f18 100644
--- a/include/linux/io-pgtable.h
+++ b/include/linux/io-pgtable.h
@@ -87,6 +87,7 @@ struct io_pgtable_cfg {
 	 *	attributes set in the TCR for a non-coherent page-table walker.
 	 *
 	 * IO_PGTABLE_QUIRK_ARM_HD: Enables dirty tracking in stage 1 pagetable.
+	 * IO_PGTABLE_QUIRK_ARM_S2FWB: Use the FWB format for the MemAttrs bits
 	 */
 	#define IO_PGTABLE_QUIRK_ARM_NS			BIT(0)
 	#define IO_PGTABLE_QUIRK_NO_PERMS		BIT(1)
@@ -95,6 +96,7 @@ struct io_pgtable_cfg {
 	#define IO_PGTABLE_QUIRK_ARM_TTBR1		BIT(5)
 	#define IO_PGTABLE_QUIRK_ARM_OUTER_WBWA		BIT(6)
 	#define IO_PGTABLE_QUIRK_ARM_HD			BIT(7)
+	#define IO_PGTABLE_QUIRK_ARM_S2FWB		BIT(8)
 	unsigned long			quirks;
 	unsigned long			pgsize_bitmap;
 	unsigned int			ias;
-- 
2.43.0


