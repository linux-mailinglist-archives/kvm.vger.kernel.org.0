Return-Path: <kvm+bounces-30747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CFFE9BD0E1
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 16:44:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD6B9287FB7
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 15:44:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F4AE13B2B8;
	Tue,  5 Nov 2024 15:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rnQuM2DZ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2074.outbound.protection.outlook.com [40.107.94.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34522126C0F
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 15:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730821450; cv=fail; b=IpJXI+ZaX4eWjn/sp6tflWqKf8W/GZyPnVjPyE49RazsXVood7TY0pGwwzH9D1aZzBmOQvzufn3IMvWE70aiJS1mcae9XjC3TCySOWaUpLCXhuk9NdQGU4n2CsjzXx8DH5tEjhyYwIznSV6rdsE9DjjjO8Ysq7fkOyvhto9brvM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730821450; c=relaxed/simple;
	bh=QLcCBMkhYp6t3tK76mLGJD+IkyGPFljSuOTEOnw4pwc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=DV1jashFjKQ/ymhpfXZoNsK9hS0BAeT0+5sua6KlegckAK58tYYfxLy12AOQyC54fOH9qq1WQXzQ7G9qQJst9BbASHDDRFhBqZvnsrwypjXy05q05CT2G5al/6h5DedRvb/1/ox+OIKg3JXNXWuwXFSiwYP3rG5Pf8v30bV1Z/g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rnQuM2DZ; arc=fail smtp.client-ip=40.107.94.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TPWOcxyq4PtgTDvvN3EXSlviXwnn/3L0rQIocSiIt7PMvIMwfGaM8qjjcGTyloQ5MdzoiWwU67uixxqlrQBHqUr4ziPINELCBjsnSw75eHLUxqJAJJXp0eGbpYR+/AHyRtuz24LCF/+RhGqdFCbsIYHWVL7yt5pJFpDw17XDJ34nC6d7l8v5VBCiooUbhwNvwqO9OKquwK+yEDVcjW0rEhTjXsu5tz2qyXCzggNc+JBeN9F5YJcYg1Ohj3xURyn7U0hhDEIkXb7RdYusj9Gp3D2fCTq6AmPOWEm1ivickRBeHJ3A3TbVxn8ZkVtcqVJJvUEQf2BSh52QWgTlJyDWRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IW7Qnrr9Wg32xeKXff+3cZKCeZGkKfwoZvplaUmkhL4=;
 b=RC+fI+rvmJlsjDCINVYlJ+cF/FHgAz+Mbp688E4Hx2qlJavWsCsuB4/JHaSCOvSdOn5daE278lHzUhZ0rqliBOBfJW0GFD/VK0wUyfmjn/hhfvRyxQesjCLnup/bmhMq7WZZVqhpTb8tfy4HlK7VmtQ03rN5wJcnVYOE7wxsj7oXWLrV8uX/4jFV1n0pf/JSKyeo2qlJdQQWzxaIMp024jXKMPa+PFuIwQJdscZKdom32seUKUDW8Pr3fMiPj+Cdfz7XYAORPgj8fPgSSFp3mplUD7VztnkhGzcKFqP6uS6NFloU3NCaas5Oq2CRh2HtAZM/MoxKDKsRbxMRRUEFUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IW7Qnrr9Wg32xeKXff+3cZKCeZGkKfwoZvplaUmkhL4=;
 b=rnQuM2DZFCRj6AWolKrptnz/rwW1Kqd559vR9AvysJyZwmZLQNBkQe4G82OxZh6yrpnRCXFgtcrAUnXMjYocOT4cNyXZm7Jgn//t/5VrIpudx1N0uQi/+OPYkDeho8ThWeS3V/MJawdjun5Jmkxd3l6nwQjadTpTcFjVgOrm9nj0HitbJmN9hCPFtDw+uiI0Z2fMFWmHesOXqkGylWXDmx9dofNOiylj3ZBtmpyL+whw8HQyalOJ4Dz8ud7jofTs2bnZdHQBetr5jboBwZvCLgDonCbCwC4Rqq890VxvqjhD5txCNzHLHu4U8AcwydTGnP1zuXG/uj4vOSHxjKwVJQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS0PR12MB7701.namprd12.prod.outlook.com (2603:10b6:8:133::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.18; Tue, 5 Nov
 2024 15:44:05 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8137.018; Tue, 5 Nov 2024
 15:44:05 +0000
Date: Tue, 5 Nov 2024 11:44:03 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: joro@8bytes.org, kevin.tian@intel.com, baolu.lu@linux.intel.com,
	alex.williamson@redhat.com, eric.auger@redhat.com,
	nicolinc@nvidia.com, kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
	zhenzhong.duan@intel.com, vasant.hegde@amd.com, will@kernel.org
Subject: Re: [PATCH v3 6/7] iommu/amd: Make the blocked domain support PASID
Message-ID: <20241105154403.GJ458827@nvidia.com>
References: <20241104132033.14027-1-yi.l.liu@intel.com>
 <20241104132033.14027-7-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241104132033.14027-7-yi.l.liu@intel.com>
X-ClientProxiedBy: BN7PR06CA0041.namprd06.prod.outlook.com
 (2603:10b6:408:34::18) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS0PR12MB7701:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b2a2b3d-08a4-42af-cc28-08dcfdb0ad9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QtdqK+AdhVzl1LlFbpn8jfhrpzPgev/GapPElQ0qXObLRknt8hZAlJtWHCql?=
 =?us-ascii?Q?YvWMYIlYPGF/sFIJuL1IfhOn6AUH7ZP6v76WXqHENkHZk83EKuOZ9LRLhKUt?=
 =?us-ascii?Q?wEpnBqAsPpnLAZ9AlDfGCMhThJQfig/yD4AimB3FfkyGPfv0SMyk9j1WnJua?=
 =?us-ascii?Q?Qkk8aRrrktM5dYy5dOzHEge4C0Zolal1/oNsEzWNpKkFA6nGEE+17UesO841?=
 =?us-ascii?Q?Ixnbd9R3BQ4AO7DmCtdI9/ba7lIvXcjh1Ubfm+gmnHyUnJIq+79Gf3l4ZHI5?=
 =?us-ascii?Q?KnwIRaeCytDVyozLfG5wiX3jiJK3BjbxTsB38xE9+gn8LZpS5FhzV7yjlQLB?=
 =?us-ascii?Q?gJYRGUfQb9u8CK1W5DiXIAAEMOI1exsZZpup1w8vCh0v51l0JR6Lav7oWcGt?=
 =?us-ascii?Q?wy2upZ72lvu0C7xTY9M3/Pn1JFwuwSmrLierfGG77ax4iTBpiJlouIxFoPPA?=
 =?us-ascii?Q?UCGRYRMywhF51ctKd8GoOnKiPD1jGnH7G0+IR2Fjr0voDEQfPWOeAagZ67kv?=
 =?us-ascii?Q?0m8+0Zc+Vgkg1pxABM4We2+Ct6Tbm9u7/jNHbBB7tk/o9Pucw/B5swQqfR4p?=
 =?us-ascii?Q?dxy82HwfXsClJkInasg4uziDpLL3qrJs2E5JK8eqOsvnvDVlL5sV2+CvbCnx?=
 =?us-ascii?Q?kXd+WU7ieLEfRAhq08F788ZfwZuw4qotFYU9Gk29ceQDoqRUigEs6Vl0RKSO?=
 =?us-ascii?Q?b14C9SBnQB1rtFpTUrbn/IS/tDyvkpObnBk23NN02ev+jSDgjdTLGu7drH8v?=
 =?us-ascii?Q?4ieWN2+WoiTBQjTLI2I3Q6d2E2hjqWrR8OpqYjQiECCVcEXG/T4vZFc0geFh?=
 =?us-ascii?Q?eyarfowCIr65olPqEBtJYmNtsXmmt2OTS8sNLu17v6xgom3YEBkkJ/9F44Qv?=
 =?us-ascii?Q?ok+3KlAblggMlH+bwer7Tgm7SWUegDHkqkfRy1dvzePNzSLRUec/3QWzKzPe?=
 =?us-ascii?Q?OlHJFfC88w6WuMpjwS32OfnTwYZBAyo4mMtk0n+gJzccwS7/oLQFdLs9kjPz?=
 =?us-ascii?Q?UqvkdEtzqOghVhcycly/gdYvC1DCEMqPHJ7Ac3KKVYqx/6gWWBOZZ7pvm4B9?=
 =?us-ascii?Q?n42Ahn3ADFeQ+6iIWZtpTnnnOsyTw4J4YL0zbEKc7fvQOuTd2f1G11YPzvkD?=
 =?us-ascii?Q?jQEvsCRRox7/14q8t+hh00w5ciWVgkUDz6hHGsr1LQT1bqsCJUxW0qfT94HA?=
 =?us-ascii?Q?SRcKbGBARBwwhMV0kgqWTxy+lRgbr7RAUCSPZ/wYNowT11ziNFqwMtrVezQ9?=
 =?us-ascii?Q?pZhhHaQOJhC3+Tqb2LibgVcOIHNTlC50NUZ4oNhxbuXNXX7T7Y6P6wUCrSN9?=
 =?us-ascii?Q?Vfg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+02bRwTIfNiRZhGiVwjp4yd2NCvbqLnyUwr9YTOIoJwmNlbh3Y18yhxJSVVj?=
 =?us-ascii?Q?Pumxy5a1ULP0j3fl6lSJZ5QxgtezROGFh34JrEGanFnm6YSePlEoVQcz3Oev?=
 =?us-ascii?Q?wbCdiq7QhlJtROCIOBuYlCXxudz2zcicy0dk/V1IhY9we0PJQmiWt5duD+/O?=
 =?us-ascii?Q?eFK5uosSfS0ol938534e5GlY1FK80Nn8/PJINIQOLj8NfA8CNIco7qQh5BTR?=
 =?us-ascii?Q?18n82wAH20TnUSu1vOuWpn3hX7fog5njscuOS7+ngLwu6jHPdaf/kwXY0DFV?=
 =?us-ascii?Q?g+sB9WirHAPq4KA7iDyZMcRBgpExY6KcgtXc8ia90l4bAFP4MpmIw8Y3983U?=
 =?us-ascii?Q?1JfIPPzgnma3x9aZX0qyKQCVwnFVW6b0f+3BIP573lu77ik3vuUXjsTByrdY?=
 =?us-ascii?Q?DRixh1XnQAyueSEL8PykcXQdfWhYqNgaHt1e3o/LnuBP/vvAS0yx46PXHcwA?=
 =?us-ascii?Q?vgWhpyN6BKbeMHpfj/jf3EBP/+IlApzOjxCrXU4aqwGR4vgaLitH1AMrKac4?=
 =?us-ascii?Q?eQqL/gJH5OqGbYHU0nY31VAljY0B4PLbNc4cQkxRW9XmvjjgJMA1WaJt7L71?=
 =?us-ascii?Q?plYzXMaotMGRNGhanpSfBXrJ3ZngKxQ/44ki7Zzjct26q18SuhZ36Xe+ra+M?=
 =?us-ascii?Q?mjvkvuEe3oCHE3IOQo2NYWwPev7Wt6Hn+uuBw4fm18wNZxybhm/o4u3J+uVo?=
 =?us-ascii?Q?wWRTSDSBiOvtfI3mK2WOr4xRS2s225ml6pQIMLIA+xw3q2226NAYEy0oVbRc?=
 =?us-ascii?Q?qz9WNqVXEQjoa75iYSmYKgPcBcFcCyiZpTs5gqRv7SwxR1xrskc2nLMuW9DX?=
 =?us-ascii?Q?mV54p4efrC6tcF4qdu4eJQFxTrgJiodhTv0skQCsAs7QiIyftvkC9C0F3qkv?=
 =?us-ascii?Q?85ZSfRbNCFiO5Q0sBNZgX6VoN1dh1k5wzx74NTCsgpXMpD9IXOdSP4PND+JF?=
 =?us-ascii?Q?7r0kwMhXyDyMZWf/2NTsAOIbVjgmeOF0yQDO5OSnlCANU6Kiv9u4Y0Tuu4m7?=
 =?us-ascii?Q?9N3swWE/XtS8tN/ZH20TotBeVLXiq/RL0eSliGZT36zG1W/jEKrTAhRI7+wl?=
 =?us-ascii?Q?HL4cgeodo4wsUrezQ4VqZz6SyimwUb74kLz0w/X3L1yVpqWJkgHMPI0fa0WH?=
 =?us-ascii?Q?fZjWt59bLgobVQpINc8249gelh0oTO/s3iV9Yf4JM3weaLjTKk8pQjIiZuSI?=
 =?us-ascii?Q?53qjQ1Ny7dfr/p4QJ+v/VJWT7rO7k1APGBSwo6drCMgPZiwjOmcgihDUMXLJ?=
 =?us-ascii?Q?OI/Ky7QCHz+FARQRNa6+1kzZnvejsHTqLpRL92pGaeGtN+8J8J5G2/JAr7uL?=
 =?us-ascii?Q?lltswFZQ8B+JufJPnCGNKv1rSvD/Yi3v4b0+FWEq/sexjpbyQyzsKwlNXwz2?=
 =?us-ascii?Q?/SltFXoQvUz4j+cuw9K+hFkLhLehOl4aQsneZb2EOwuUJJNKsHXiWsUI5Uc4?=
 =?us-ascii?Q?soESBt+auXx0wcl+xfa4gUaC7/uLkHrOPQ4V9v1I+XiACMz3CSgJuZ31Eoy5?=
 =?us-ascii?Q?Ub+U0rFX1KoXeZ/P95xlzFgTA3iOkPEvV2eJPXrpbEabxbID6QdQMUd1Lkd8?=
 =?us-ascii?Q?YwSBONo9oftExYe4zAo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b2a2b3d-08a4-42af-cc28-08dcfdb0ad9c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 15:44:05.0190
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SDKLDr9OyndJKKB/yOE+8trkzPINxG+mPsDQCu7FBY0XcQH662YxoEcxzWQNN7Iu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7701

On Mon, Nov 04, 2024 at 05:20:32AM -0800, Yi Liu wrote:
> The blocked domain can be extended to park PASID of a device to be the
> DMA blocking state. By this the remove_dev_pasid() op is dropped.
> 
> Remove PASID from old domain and device GCR3 table. No need to attach
> PASID to the blocked domain as clearing PASID from GCR3 table will make
> sure all DMAs for that PASID are blocked.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/iommu/amd/iommu.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

