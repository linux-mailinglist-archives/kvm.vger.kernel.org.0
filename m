Return-Path: <kvm+bounces-31784-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 171E29C793F
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 17:50:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4E0A6B374C4
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 16:43:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2510B1E1037;
	Wed, 13 Nov 2024 16:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TX8frkOY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2071.outbound.protection.outlook.com [40.107.92.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97021632E5;
	Wed, 13 Nov 2024 16:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731516212; cv=fail; b=jYATiU0hXE9ucv0WOwhS4zd1Y2eqrIF9i54IbR3a3nek327UI3Ve6W8Dg5hNT3JJfBWT9cZftPwrTktziWNxr4VLpyKNClMlo0q8LNwjz0ffUnG4FCxjn+pvkd+CRN4d+n7SB50HMm39HBtMqyYW2520CtvvAz8lGNlALjuyzOU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731516212; c=relaxed/simple;
	bh=Rqx5jNVZtlCdCC50ZjoXchLojjHHEtEqZuwR7678u6c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OIyEPM5pYpcRG7qVm8RAH1AhUPF5xMCFqTu5rqcxWe8I8jYZ/qwG6sDKLGexgUo5AUop3ZoWNkfoEK+/OVPoKIvGXtc4D6MU2RpBAczFwTFU0vWJxiCVoZK9/RJd3SHjdawa83Jpti3NBZvb35Wc/isUPc7epuv3E6hySgB9bYM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TX8frkOY; arc=fail smtp.client-ip=40.107.92.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jLPQlNseW5/MLhlS5ZNbPdmaWSyUWLZ9pMpoMMvfrtoRFX5h9wA8vfcQAfDIzNC23CtisGuuxweBPqqUC3pckJnWmz2G1BYUkCNs+p2oUsy38tvY3d7MGdXtfkAOFhHJJeMtH+f+SQuDNHzfWNnvkQguGxNvwwAAo0o5D7NGgZHW4+TjA8lOz2F5MT1B/9FP2U1ALMd8zAI+d/pfmTgLCZjsqFLKhB8KQXDwh8pLMcELgY84yuCqzbaRMlHXL3lVHglJ4N55jhGWBLlGHAm61pKEz2VNlytWosClnDk/KzOmO8+vyboCqVEXO29TZzvxnpREYTktlXaE/6N4+Tr1kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EyL9HiLOSw57xeufIcjoljyzhTHF2YgBF45CPZz4J+Q=;
 b=Z3wUKICt73r6HenHcG6+hbLjWzfnnCuR0rdrb/ZfXx655tFsdtYgMei9cghA/IpBlJ2QTS30hL6hnU9kMIoOZ0f2UdW07rULASB9Qy13MwzqfoNc3QXliWJ+80wuXRUiyt5pZC0T15kQ3ism5SCbX5YRfX27Yf4emVg3Mtdm8qxGYaAUWyX5XmNvfDyotzTfA94wEhnbTEyAbjOgZhMpION+9fU9nEYeGPfw4KCnwh3Wf20I20oRi+zTUFTSDWjHchmfZmodWyQdPFCXtd8vrN7oZUTYgoti8lLWrrIqXberyLxGLSAzUbTSHD/u5RHs1IcOQ4aeBriBn8UZk2UQTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EyL9HiLOSw57xeufIcjoljyzhTHF2YgBF45CPZz4J+Q=;
 b=TX8frkOYDiuSCvcVB/Jx3Zr9DfSTay1p38m7vSxpnQMXomBQsolI3XE739prXWeW8DeikGU7q5fhKpK9OzxHD8X6xMGaigmq4VERFJoVOwxn/0OkQeRhY/2h38Byb8WkWEIwBOYAUmMuT8Hc1RnlHaufYVJk7mY6P5HuBv4iR6ApdiiCfTyiub5YmU/2Trzw4b+RFnOBbWbDNlANUMFeZJYSft0y67UAzQobEQfcxj9ZkEEkwozcxfYAl6h5iggIau0CkxeHnd/c8cARmwaCfH0nP6UFAdddiGRrPylIhf9R8VWr3Dyhb+/gZv+ZP65hl5+L5ljxY+lK7l3XhAi3dA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by IA1PR12MB6652.namprd12.prod.outlook.com (2603:10b6:208:38a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Wed, 13 Nov
 2024 16:43:17 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8137.027; Wed, 13 Nov 2024
 16:43:17 +0000
Date: Wed, 13 Nov 2024 12:43:16 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: Zhangfei Gao <zhangfei.gao@linaro.org>, acpica-devel@lists.linux.dev,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Donald Dutile <ddutile@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v4 00/12] Initial support for SMMUv3 nested translation
Message-ID: <20241113164316.GL35230@nvidia.com>
References: <0-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
 <20241112182938.GA172989@nvidia.com>
 <CABQgh9HOHzeRF7JfrXrRAcGB53o29HkW9rnVTf4JefeVWDvzyQ@mail.gmail.com>
 <20241113012359.GB35230@nvidia.com>
 <9df3dd17-375a-4327-b2a8-e9f7690d81b1@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9df3dd17-375a-4327-b2a8-e9f7690d81b1@linux.intel.com>
X-ClientProxiedBy: BN8PR04CA0058.namprd04.prod.outlook.com
 (2603:10b6:408:d4::32) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|IA1PR12MB6652:EE_
X-MS-Office365-Filtering-Correlation-Id: 8535e3ba-bddf-4608-ff23-08dd04024633
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hrjfU/7hk+D5jMSN4q/G24qTkQk071QqTqcSzEWr0Yf5F7oiz4p+r9yAgzG4?=
 =?us-ascii?Q?R+mu7PaiCRYEpVD77Fd47F4okx3U44e+JBXKxB3lYsEqp3WYdkkCuyQfP0sg?=
 =?us-ascii?Q?105v6uLZYuy22SKvQ6r3K7LsTqV3FFgNhpoAiAsxvB6JMzT6DaHQ7Rqt3ZXc?=
 =?us-ascii?Q?S3OoHMRE96YkM/U85QQrOD4RjY64dejFUk/VMJ+sCA+7ioVhdMJsNV3+pO/7?=
 =?us-ascii?Q?+IrWJggSLuWbKbJmmRYpUNImjn4RQXuEsm0Fqsk2nZZrDX78e6l69ffp+88O?=
 =?us-ascii?Q?5G/0u+YvDyfIfRiRlwYHLGnsIxeZzpMeV8KcibW0mLKI9rlW/fIoPicIpLQY?=
 =?us-ascii?Q?dI1dIW26X2JGt2FycaTkktijOiWonvQnsGgGzjBUCRvQujfvRcIxB9XXYygc?=
 =?us-ascii?Q?p3iVSu/75fQ0ithngQoNq2X3oHCfk4EVlJcGPP8D01aMqKsnTM/NNGU2+iBT?=
 =?us-ascii?Q?yhh6JbrlLo6krvKEUfNwYLzZMsDiyuTdgS0X8JFvfr9EBGgUsNhrrNpjm5hD?=
 =?us-ascii?Q?0HfszczWDZVCAVZWLmeUv4wBzsnFMl38vzLM9ZJHoRs9qkkgFC2Xm7gsAjpP?=
 =?us-ascii?Q?gsYcVZdUnRyG5cGgBB0hNDujrbSAyEzjn/TvqYUUV5gXCkyhUVTf75rm6MXO?=
 =?us-ascii?Q?pt6js7d9wAnAqCeZ+J1j5wjJkbNjUSSwA82B39OBDHS66SczSpH7Xk/GfnmL?=
 =?us-ascii?Q?TEYiUZcQwKpULToK7bLh43jVnNMWVdWSR+1F1FsBbDXgfuMYHcX3zapPOv3e?=
 =?us-ascii?Q?u2YJxro/h3UmpJdcyKY+cKxAaiMyKLjZvy2ByjKo/POuwt45ffk2VjjtlUKM?=
 =?us-ascii?Q?nvINSMi+9BE+hBv08+gkxy/OKn10WX6DycuIcWZI4NgABLLErbpvIT8J93xw?=
 =?us-ascii?Q?ZD3u4MZ6kWTcC9lz3qj52pZ2DvhlDSl0ympUY8u1nul1ntL0rQC7A36McLNq?=
 =?us-ascii?Q?XlBOEzL8dr1MVXqKpEyqF57VJo2nzWY3Z8GY9enYer/NIcHs+eUavJ3Ez2zh?=
 =?us-ascii?Q?oDYzSXxHy5xOqpn5juhWAt4DozDqhGmNf+8qJ9lepXsYde8LxhYuASBgKFRh?=
 =?us-ascii?Q?kbFuWK4gCPZDf9Xr+2JCseWzdFZZHGhzjd1zBQXjWVsSqZ5mOzawvXFdJQfb?=
 =?us-ascii?Q?unM9Lfq9s7FA6vipNsk0ehXRX5kDomiJfiBH3l63uJVBDcOSHqu7nlxPV1w2?=
 =?us-ascii?Q?NUSPwQSsM9XDJWjam+H9Quh6Z5ZdPyBELL4Q2doPMnbUk6U8NoMp/1zomKs5?=
 =?us-ascii?Q?S2OGxA45fpzivA9TaVL9otL0lgyeHeh8fIymES9KgktismpuTGmXdMRehzRm?=
 =?us-ascii?Q?XEhskCRlMdaTpuujhjEO7gi1?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Mgw2mKec6o8YSHeDHUhTNnKjj0kNIuq++XWgLlHrfj2M08WEc5i61GcQ68Q2?=
 =?us-ascii?Q?NTj3PlkY9uEdjjgYUBrkxnlGBm+BFyQfjNI39M18dMi6jjRIt1sgmLKOYN6B?=
 =?us-ascii?Q?vcMLAc7Xbj7Qa6oWNqzkreGQtGPMUApjCOleR1ZadW0gP0xZjgSH0sH9HLOr?=
 =?us-ascii?Q?q2ffoMWeWAsnk9jekEyblJVALAcoptwgcO0Zorbd0ASa0RN0UlsnB5w3wuKI?=
 =?us-ascii?Q?oQw9WPXoZXoLBW0FNBlCciMuCdYJCTZ8AKFnJ7Ftuzyd/tbV7lKPnwofb33+?=
 =?us-ascii?Q?LoQ4RemEyNoE67K4yboxzT1q2hu6fR9g3FSWXuinWPaMoeI1/7rNrb7rkCq+?=
 =?us-ascii?Q?hO0KPyrqDYaEr6GBJpbrlNUSTYekGBSltvFET8zaBGJpUv/afq5fHrFZgpEy?=
 =?us-ascii?Q?ur4A69X1b0h3h3yRvlxwmiP0vpJAX+W61Gi7wZopbCG8xUqsNJ6v6yhYyDIS?=
 =?us-ascii?Q?GRiFXPguqQFFMoxt9yRXjYU2PGsGEAGFymwvR0NvW5moNlkDa99UiMcpUtMZ?=
 =?us-ascii?Q?cVsUurePGwqvmtRgx6fKiD3/YyOqaaT0i1dPEvagxWDbI6LQWaxdNu1714es?=
 =?us-ascii?Q?zizIvtpdq7OApUVXHI0cAoj62ieseWkV2QmbCEd1DGmYSgIvJiKmEo93PhKO?=
 =?us-ascii?Q?oYAAgfzzxcjiT9RHya0JBQoF9cjHASoNOQgjXFBS1ami+ZLpunMRO53hRVZI?=
 =?us-ascii?Q?UtUlXvrF63RMkcEJbLNyGiynqhlAkKRmdYKPwUkLnlJ8A/153cMZlJ876DgD?=
 =?us-ascii?Q?4wKwWXIoh7N6hnu9ekLD+7o5XZmClhmZQjL3jy/IVfy7ev01O/EWDw/RADIB?=
 =?us-ascii?Q?CKKpigYz6ilx30ZsbSHHpjoB3nr7vGsdPdBryjTXC/Zcn2fQBOw3YCIAlNbb?=
 =?us-ascii?Q?NOWfJvKKYS+aGDU6nQMFWPHLb10PPcJQ2d/rI0r7bU9SScOfuIdXCAkHhE+0?=
 =?us-ascii?Q?1STpnExz/gNtPtOHrkBc+O8gjsuWay7QQVpqs//yip9z/nJpD5GiQjcDuu/T?=
 =?us-ascii?Q?8XDC7g8m6m0S7A7T4ZHuSzWQp12qujbepbWJHKKT4sPewy+9pzOMadpjCyj6?=
 =?us-ascii?Q?YhBwtiEwyxISJ+1u/o623IbOKLRqTnpX2FuEedm+Mr2ZmH5iSBv2NmlK6wwx?=
 =?us-ascii?Q?6+UApEr9iYLWdreXbDfl+y6dBL6fDwwmyMamspkCjdhDtz8/XDOd7UxB8qQ8?=
 =?us-ascii?Q?krAXCoa1ONERjNGHjXEZXkmkZRbk11jjliaAYM2Xs/q+b3SeiAKJ07bi4/ci?=
 =?us-ascii?Q?2mnqirUb29t4GJjY7Vo6eGCF87YsAQuUzMx1MdjRw2PAoAZjO3pnQc54EqMx?=
 =?us-ascii?Q?kqnjpUhLU69ui9+0iSTaabh4viz/iiuKMxNW8iHP1S6QY9cnLyXPMtcsONB8?=
 =?us-ascii?Q?p6BPXX/bmUm895MVBf1lZV74xoLCSL3SX8QFNz9L2H0Gabxb33qbeuFo2lXl?=
 =?us-ascii?Q?81XyvaMMSHuodTdkUCpqY6NIFVzhl3vlP1UT2PajzJ2ExYvdrcpOQ4Z+wVvf?=
 =?us-ascii?Q?MkftZPL+ZelZewGLtfpZ23cu3biAw6iwXPXLmftxvddLNyJPHEYHVtR0fYIs?=
 =?us-ascii?Q?tv8IpApjbymLR43R0dSlRX17vJ9+V+ABHZHVKkGw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8535e3ba-bddf-4608-ff23-08dd04024633
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2024 16:43:17.2945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LtYQkpQMzX3bL9E0mSpsQknO2nJ/2UI/LYVWFQ7kjjnH87GzpRRBX2AIuzr07LoC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6652

On Wed, Nov 13, 2024 at 10:55:41AM +0800, Baolu Lu wrote:
> On 11/13/24 09:23, Jason Gunthorpe wrote:
> > > https://github.com/Linaro/linux-kernel-uadk/tree/6.12-wip
> > > https://github.com/Linaro/qemu/tree/6.12-wip
> > > 
> > > Still need this hack
> > > https://github.com/Linaro/linux-kernel-uadk/commit/
> > > eaa194d954112cad4da7852e29343e546baf8683
> > > 
> > > One is adding iommu_dev_enable/disable_feature IOMMU_DEV_FEAT_SVA,
> > > which you have patchset before.
> > Yes, I have a more complete version of that here someplace. Need some
> > help on vt-d but hope to get that done next cycle.
> 
> Can you please elaborate this a bit more? Are you talking about below
> change

I need your help to remove IOMMU_DEV_FEAT_IOPF from the intel
driver. I have a patch series that eliminates it from all the other
drivers, and I wrote a patch to remove FEAT_SVA from intel..

> +	ret = iommu_dev_enable_feature(idev->dev, IOMMU_DEV_FEAT_SVA);
> +	if (ret)
> +		return ret;
> 
> in iommufd_fault_iopf_enable()?
> 
> I have no idea about why SVA is affected when enabling iopf.

It is ARM not implementing the API correctly. Only SVA turns on the
page fault reporting mechanism.

In the new world the page fault reporting should be managed during
domain attachment. If the domain is fault capable then faults should
be delivered to that domain. That is the correct time to setup the
iopf mechanism as well.

So I fixed that and now ARM and AMD both have no-op implementations of
IOMMU_DEV_FEAT_IOPF and IOMMU_DEV_FEAT_SVA. Thus I'd like to remove it
entirely.

Jason


