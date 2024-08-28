Return-Path: <kvm+bounces-25296-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 71CF996312E
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 21:48:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EC4F22868C3
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 19:47:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D147E1ABEC4;
	Wed, 28 Aug 2024 19:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mwe8p9L1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2057.outbound.protection.outlook.com [40.107.94.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A64125BA;
	Wed, 28 Aug 2024 19:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724874471; cv=fail; b=uT9kqRP5dQUN9qJhDzjtS76UVmNe4Hhhs2fb8BMu2QTsZD0lJShWVdxsvKRN2XTKVs9o7jhB2rSpP8KzEoncyZe6h0w9KSX2jufr/jDaoBcdqXgg/g4siHdeEgYrvLROkaY+NNitEehMzWZsbgFYE/ktfTy//O65jiobuN7t2hA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724874471; c=relaxed/simple;
	bh=WxkCoWcl5vdYbEz1zhwmjSYnKl53fLuAIdMMBTM6HRQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uwhgpypWoHOglbIrZUdIbe46/SB0gR/GQxRZAID8VO+crdiEQgL46At7zK/HhfsA9B7LW5/pSHTB7DQmKWwlXYMKxYtY/RfIiBjiz66Vgwo5MVk8Qx9dUhWnfpjCVQPZLNEilUXaraMQHZ5iUVtx1NXgDx5+fkBObzQErPuCsDM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mwe8p9L1; arc=fail smtp.client-ip=40.107.94.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MxbBurpFvkGFo/0j70qQ+kDfK5FfapAudGxhBfQ4k+m16MrHRSghieppBCJH75S6bl6/ThC8zKBocoqOwZMLvwoPOc9LWn7ebQl6xbj3MLq169WuGyYMrF6U81qS9fZ6jhK+DNMAcg3Gib48v4itUXbvDZS/E1Fv/0fav/75Ft0u+90lOFTQBQDafPW4dckhJV3UPB90HlaUp7m0Gsh2eg5CBh3z6SG/qS/UaGZ70UDKJ42LNM2wgcvakTOwq0viP/pdukZBlcOyLqJfex9HsJNWUiMWGgmJGOraqPuoPi+KhVdtgyElSmC3p3kfMe/VSqr7ZZWZO1q4mIaq8XltCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/kMWr+JM6EHaPoCU9Pu7dCGEQ2cPpjuKSvSsnsL3r9c=;
 b=OBhpx+NpNsXYDxkCF7N5d5pJb1CYzPBNp+D20wyuSpHm6OtiCccH1ODZIZj53s+xYyNfJE9UUIlP+iWXGKYHQQAUcPvT4lewRyNaRP/W0j6C+Ykkq/g41ZtFdw5eNZicsHh3qWVzCamwMq2Ijv5vztGYNdWq9gfHwLmAUNF4PqDNIg8rUgE4ImYoXAdmcsaE7MeIcBbMtg5Jl6CdaUtzlNyTyKVzMRsRmNE6lOPEplHqxcLH3rd/luNzyMcFKMIjL3Vg2k08eXVvJHW4VkkXRITJ/1uEmq6wpQza/lXzYr9zXeD0Bc/FBYjOkuG29CSFRFNyjquyCZuFo0fGG76SDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/kMWr+JM6EHaPoCU9Pu7dCGEQ2cPpjuKSvSsnsL3r9c=;
 b=mwe8p9L1AYlSNbPvCriDWTUmJiF/vjmJAfiXTEfEfxQOKwRxuRxN01wu1gTtOBpXB/kW/Casng2R8MhYQ2fA8C6HdFWm2DJA5kcWKDV/EwNADxkfjuZsYWrZWGbZdFaBxB8w1VIJ/tUHWy7xMEa2Ytmq8J7AfEq9XsxmzkpJC/C0jMLdDtHpjVJZntZf7GHN0JtsmdVNsDlt0jDRpEiY0Zjek0ZiJAMp0DwWkWLQD5r/efxROjyPgaOCfTx1QA/k5Kka5bEZjrpPsBbQN4kpoMbprXGxryINOEHHzd6xjD0lHFkn/MIGovhewHEowoT5JxW4EbNbTolreOShSCAEwQ==
Received: from PH8PR07CA0015.namprd07.prod.outlook.com (2603:10b6:510:2cd::20)
 by PH7PR12MB9103.namprd12.prod.outlook.com (2603:10b6:510:2f5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.26; Wed, 28 Aug
 2024 19:47:44 +0000
Received: from MWH0EPF000A672E.namprd04.prod.outlook.com
 (2603:10b6:510:2cd:cafe::74) by PH8PR07CA0015.outlook.office365.com
 (2603:10b6:510:2cd::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.29 via Frontend
 Transport; Wed, 28 Aug 2024 19:46:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 MWH0EPF000A672E.mail.protection.outlook.com (10.167.249.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Wed, 28 Aug 2024 19:47:43 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 28 Aug
 2024 12:47:37 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 28 Aug 2024 12:47:37 -0700
Received: from Asurada-Nvidia (10.127.8.13) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 28 Aug 2024 12:47:36 -0700
Date: Wed, 28 Aug 2024 12:47:35 -0700
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
	<patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 2/8] iommu/arm-smmu-v3: Use S2FWB when available
Message-ID: <Zs9+1wTLFCJGm3gm@Asurada-Nvidia>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <2-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <Zs4tffQ9twCLL9+6@Asurada-Nvidia>
 <20240828183037.GC3773488@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240828183037.GC3773488@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A672E:EE_|PH7PR12MB9103:EE_
X-MS-Office365-Filtering-Correlation-Id: e1b884fb-2178-40ad-96f1-08dcc79a48b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UrzA1/nVyJet2Dbg93TJP05rMzT2O2nq8GzVB+VWpf3UEgr/5QzlYdF6DtaA?=
 =?us-ascii?Q?An6/EsSviM2gNoJYBq65jTEoYQvs4VDQtVm7hJX0+c7ScOob8CaCx/BLXe0a?=
 =?us-ascii?Q?UOZKUFgOO958GJfNPgaImqVtGGorg0BWuIpz1lKUvhN72IhNMsKjS0Vk/Lzc?=
 =?us-ascii?Q?Yx5gw8ra+XXGFF5B7O1muW+N5BRvOVMEjhDDoxqlYeh6e24XAmfjYs+ehf1v?=
 =?us-ascii?Q?UMNFVFzNjUnJz/Xs+BG9fZKY/pWMY5QYu8m6KArhSSSuy7JNM7NxK97QYcWi?=
 =?us-ascii?Q?zIgNLAeIw8VaUnCPyuZw+Du0jQqJWYb3PxYNZXG8WoAb+NPs7osa4D7TRHyl?=
 =?us-ascii?Q?Ce//i+W40kXW1SiQUNkLZyKXW3uvMK+CCZtyRnWjWlZoYkDEgwVK9RsmhKVT?=
 =?us-ascii?Q?dDbAThxQ3fMyC4QjpnzGA2rKaslFOW0KHWYlr6m5JgMqf6SAQl+4PQSoen4i?=
 =?us-ascii?Q?nTiLtRscX+Y2hSVvoRhKw3KfmKpq+6iaWB7Rb5jCjRZaXMp20CoK6JA8ulcA?=
 =?us-ascii?Q?LGmP+xGIMJxpkVbAQONUsfhHAGbvEJDzP1fAGSipWT3g4NG1ubTOiAzR1mz1?=
 =?us-ascii?Q?uNrT5b5uQNsejPxBSR9YQxcuwC32AFBnzYcrZ6DH0nSRYxXMCmbAJ/FKfrUN?=
 =?us-ascii?Q?13TyNhL4DZvBjZyEZRJ4FU5HJogl1uxlVra2pY97RxBeg6LWM1KCo0UBMd+N?=
 =?us-ascii?Q?TM5/1pMzgMibR94Q7OCNMmPOVJQ7MAPZUEKeQvH6IFfndL0oeFGcVsd7ENJJ?=
 =?us-ascii?Q?bx9/sCqDwccF7faSuhZ08pdsVOCw5Q8RfqLRO1vB1bb8UlNmxQink2fLDO36?=
 =?us-ascii?Q?PIdYLTRYcuLyuSakmgnyv2On0Yl5HQ5FGmSESYG6wIrE5gsAHX6MlKBvZiZS?=
 =?us-ascii?Q?rzU2X863SjFInZnPwZHIePbf6WSXlHvViyLI+bhKthH16l5u39Hdp9wXDMTq?=
 =?us-ascii?Q?UlbJEAvOdJQq9zbH+5fsVB/6xLFLyQiYMeF08MOvvrdITWfWE6atMJcJ/OQN?=
 =?us-ascii?Q?l92F5rzSsqhFDdU+0qloduV0vjPbieJJVzRGyLsHFGdJc9ygJQ26wU/3oxB6?=
 =?us-ascii?Q?BLhDLwY3uTWCKM5TVeqjteX01V5ScjdIU1XjJHnUj0f/LX1WGIRYiUN2BofT?=
 =?us-ascii?Q?EmpOzTtK+ykhD941vtb7jC/pBU5mOp84SRpTJf+knBFmNYSO2yRqND56pGO3?=
 =?us-ascii?Q?13GkLQQlPejVszU/qfxSwWwfEMDyxPxrRFx99Rrc+0BXGJhlK7OL7QXAXtOB?=
 =?us-ascii?Q?UpXwsrb2g+n4ELhBeQsuI9YAUQbPqX9Zl1P73ZXl+YDAqM92Mvm0L/6kRv7B?=
 =?us-ascii?Q?k9oX46VXzikgeiz0EjclEejRbcSw8fnEDB0UU+tYdVtOcK0zCfQbvJxTAAgN?=
 =?us-ascii?Q?FKibgsK2aHBu8CswvGySk+IW5zqhaPbhQuaM96SFYhf8bhZeLnjWbT21Qsub?=
 =?us-ascii?Q?o+FeozyKIRj9V5vxFCFsk4V9g9O7ff2z?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2024 19:47:43.7566
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e1b884fb-2178-40ad-96f1-08dcc79a48b0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A672E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9103

On Wed, Aug 28, 2024 at 03:30:37PM -0300, Jason Gunthorpe wrote:
> On Tue, Aug 27, 2024 at 12:48:13PM -0700, Nicolin Chen wrote:
> > Hi Jason,
> > 
> > On Tue, Aug 27, 2024 at 12:51:32PM -0300, Jason Gunthorpe wrote:
> > > diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
> > > index f5d9fd1f45bf49..9b3658aae21005 100644
> > > --- a/drivers/iommu/io-pgtable-arm.c
> > > +++ b/drivers/iommu/io-pgtable-arm.c
> > > @@ -106,6 +106,18 @@
> > >  #define ARM_LPAE_PTE_HAP_FAULT		(((arm_lpae_iopte)0) << 6)
> > >  #define ARM_LPAE_PTE_HAP_READ		(((arm_lpae_iopte)1) << 6)
> > >  #define ARM_LPAE_PTE_HAP_WRITE		(((arm_lpae_iopte)2) << 6)
> > > +/*
> > > + * For !FWB these code to:
> > > + *  1111 = Normal outer write back cachable / Inner Write Back Cachable
> > > + *         Permit S1 to override
> > > + *  0101 = Normal Non-cachable / Inner Non-cachable
> > > + *  0001 = Device / Device-nGnRE
> > > + * For S2FWB these code:
> > > + *  0110 Force Normal Write Back
> > > + *  0101 Normal* is forced Normal-NC, Device unchanged
> > > + *  0001 Force Device-nGnRE
> > > + */
> > > +#define ARM_LPAE_PTE_MEMATTR_FWB_WB	(((arm_lpae_iopte)0x6) << 2)
> > 
> > The other part looks good. Yet, would you mind sharing the location
> > that defines this 0x6 explicitly?
> 
> I'm looking at an older one ARM DDI 0487F.c
> 
> D5.5.5 Stage 2 memory region type and Cacheability attributes when FEAT_S2FWB is implemented
> 
> The text talks about the bits in the PTE, not relative to the MEMATTR
> field, so 6 << 2 encodes to:
> 
>  543210
>  011000
> 
> Then see table D5-40 Effect of bit[4] == 1 on Cacheability and Memory Type)
> 
>  Bit[5] = 0 = is RES0.
>  Bit[4] = 1 = determines the interpretation of bits [3:2].
>  Bits[3:2] == 10 == Normal Write-Back 
> 
> Here Bit means 'bit of the PTE' because the MemAttr does not have 5
> bits.
> 
> > Where it has the followings in D8.6.6:
> >  "For stage 2 translations, if FEAT_MTE_PERM is not implemented, then
> >   FEAT_S2FWB has all of the following effects on the MemAttr[3:2] bits:
> >    - MemAttr[3] is RES0.
> >    - The value of MemAttr[2] determines the interpretation of the
> >      MemAttr[1:0] bits.
> 
> And here the text switches from talking about the PTE bits to the
> Field bits. MemAttr[3] == PTE[5], and the above text matches D5.5
> 
> The use of numbering schemes relative to the start of the field and
> also relative to the PTE is tricky.

I download the version F.c, and the chapter looks cleaner than
the one in K.a. I guess the FEAT_MTE_PERM complicates that...

I double checked the K.a doc, and found a piece of pseudocode
that seems to confirm 0b0110 (0x6) is the correct value:

MemoryAttributes AArch64.S2ApplyFWBMemAttrs(MemoryAttributes s1_memattrs,
					    S2TTWParams walkparams,
					    bits(N) descriptor)
	MemoryAttributes memattrs;
	s2_attr = descriptor<5:2>;
	s2_sh = if walkparams.ds == '1' then walkparams.sh else descriptor<9:8>;
	s2_fnxs = descriptor<11>;
	if s2_attr<2> == '0' then // S2 Device, S1 any
		s2_device = DecodeDevice(s2_attr<1:0>);
		memattrs.memtype = MemType_Device;
		if s1_memattrs.memtype == MemType_Device then
			memattrs.device = S2CombineS1Device(s1_memattrs.device, s2_device);
		else
			memattrs.device = s2_device;
		memattrs.xs = s1_memattrs.xs;
	elsif s2_attr<1:0> == '11' then // S2 attr = S1 attr
		memattrs = s1_memattrs;
	elsif s2_attr<1:0> == '10' then // Force writeback

Thanks
Nicolin

