Return-Path: <kvm+bounces-31694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D5FC29C66A4
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 02:24:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 87E77284AF9
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 01:24:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D3FA208A7;
	Wed, 13 Nov 2024 01:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hx68Jqh9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2082.outbound.protection.outlook.com [40.107.92.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D5513AC1;
	Wed, 13 Nov 2024 01:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731461046; cv=fail; b=rEYN2sdJWZXYRobieB1jKLPBHHpHYtjkpp12ogD1lyOD+VjwWPgEGgHVGE83sdNvohIeW1Q1rzrMjNvtp/pRkPDNPFYz1iPO9Sd6Q/oHTfu+hcqNFJpFdnDlgXYjLnJ3FzuRsTkrDJ3u+sPMOJsmAO40UvOUlFjYBrwbbyTHGgs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731461046; c=relaxed/simple;
	bh=OzurwswRstyXsUro7KBZWh042XDXluUyppIEEjZJ62w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=u/L6qfjrRMMtT1R5lxjDcOkmu8V9nUhiZYNlxLAR+ok0GMvbcz3hVLaZC+gnH08Tevjzgn/0nRMdutA6MEyjZgNvxbtHj3ca7O1PjZFY5oHpcChDYsyXisCjmlJIqK8XKL5Z7JDVerHuPz1dNTNTLxJsshnUCK/eWfiawplbpWs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hx68Jqh9; arc=fail smtp.client-ip=40.107.92.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eR4SyD/puqmtAdp59/ct8liDQ/vSeRDqeC8t4OAf2eax0j1HboOpJU7l6Q2xjZqFNXMTn5DlVOmWCwoMm6Pa7TbW1r4cO/jCmvEwMwkmhuNRZkqvLFJDEG/4E9U2x4eOinYlb4wKWuJtfSTDPS1De0YLbkteTecTFVrNW9Qo333u6a0inVRSdXhe9smUrY5i2K31EvdWFHK8q1wRqX+ADJdUWYuTboYPeEO/WmsNBfAvxw5IqIadcor5xRf4vXU9/tt0ZcfT9/XK2kjxb3kN55PQp4Z6jxl7Pmd+f05uDejlDn7xXKGO5crlYOpYaPDzdHppiZROlKIYYlOXLJqR+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b4cbtluAKzhqVQkdGeAcasRaz27N6SUf8SAX8PBut2A=;
 b=Z9OaBGtzbu/MOrwZo7tjDfKVL0rv/CO/qUMMoEcriHKC1XyEMJwYuz3qAjQvYE+o6Wrcr1fAtU51rG881ojTWfa9cA9or5ZTA0EGtnz8+WxQq7CMbWWf/DoW0IZAamxVqKtuVlyvjhLEEkFvwKMbDHbv65C1uSfJMuaJGNn55aGHz8DK7f5Mno6QCBAq7rs3w8gDu3C8Rooc51tkaoNTiGMA5H8CLyr8olfooqUHFnWq0+AHFelDYT0G7/wh64S3nPRnkUWPLfOVeWEBOIxamCb0xNMjmoxDg0/y6ptgKdPt1Yw8JjZwx0FpiKuuNB4lOvEzJ4cE082g/vqCg94coQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b4cbtluAKzhqVQkdGeAcasRaz27N6SUf8SAX8PBut2A=;
 b=hx68Jqh9LMEIA7g48yUlpz55emjL65a47fa13nKJCSFI7QrdSw0mt4A7q8+FuQZAmv+XPkKnceMV9cAGeKznTt892vl63/xRRgUoycNaqu+7DtzPPc3Z9mIxHpsEO7JKvCH7JaXn/osrN6kY9LbekTnaAYzQ8nSGqLdb/tb+UkvnLn2JqoBeM+GanIiZn/7W91R0yIODI0+/SJEb+8UO/lGUsGzdUW932qeUYsU8oASSzqpDm/ZECBEOj5QrCM4G0mUBGy7rPU2MztV2S5dU1NKdLqtCxxdM9uVPh8LmZdfeT6bjKCNiAy2WsCm6IEDuCDkAml1A0saZjAHlKl8N5w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MW6PR12MB9018.namprd12.prod.outlook.com (2603:10b6:303:241::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Wed, 13 Nov
 2024 01:24:00 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8137.027; Wed, 13 Nov 2024
 01:24:00 +0000
Date: Tue, 12 Nov 2024 21:23:59 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Zhangfei Gao <zhangfei.gao@linaro.org>
Cc: acpica-devel@lists.linux.dev, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
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
Message-ID: <20241113012359.GB35230@nvidia.com>
References: <0-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
 <20241112182938.GA172989@nvidia.com>
 <CABQgh9HOHzeRF7JfrXrRAcGB53o29HkW9rnVTf4JefeVWDvzyQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABQgh9HOHzeRF7JfrXrRAcGB53o29HkW9rnVTf4JefeVWDvzyQ@mail.gmail.com>
X-ClientProxiedBy: BN9PR03CA0978.namprd03.prod.outlook.com
 (2603:10b6:408:109::23) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MW6PR12MB9018:EE_
X-MS-Office365-Filtering-Correlation-Id: 33a3ae27-c115-48af-6df1-08dd0381da49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?p8Eag2cILiJOhnTgkaSH5Rcd9qkCyAfRC9ZEONIGej3JDfq7cPH7ohiqxOA3?=
 =?us-ascii?Q?+EztISr92GhRxhnsa/BXxX7QEP37wMtg0j5+Hj5X2jW/M+tve8Y26N6pyrBM?=
 =?us-ascii?Q?ealhURkQaVAbbQ9FEEssZdiosqIbr96K2BhLnaxUGJ6dUh0RJxuOtlRfDJ1w?=
 =?us-ascii?Q?FRssrnNyfbq/xFvtQbQ9pSU5LNplb0/t/lkb6Ny+qqEjrnNKnUelmCoHQpUu?=
 =?us-ascii?Q?t2zncNU0UYz1/Dq/yCgI8a5K0bnFMt9552hAOehwPGysG5qLl4CIHC9kjE7z?=
 =?us-ascii?Q?82enrGKr0KtVXQkqR+gqZACf6TdmHz/qQxvgE3FxJeFPf9m19bzT/dl1Z5F6?=
 =?us-ascii?Q?lRcshUbzExK+ex2YE3Z9sdaSpspDgr1/xl8cYPMrhIyK5MwQ9QhdjRoy7Jg8?=
 =?us-ascii?Q?Fxpv+BmauabQBmYSV7EXVuJaMw2Vsonh91bn7y19sWkcZQYA4/5mhiWE+hhP?=
 =?us-ascii?Q?kbX/Oe5eR3IMEGZ67+fe8OxGFC/RVY8t9PWGBCbhqTovcrthrWquXgr/CQ79?=
 =?us-ascii?Q?nCVmDry4Ksl1xvSleyOdgjgGytv/5z3a3ikwGodBjggUX+fnOhBzky+8S+qM?=
 =?us-ascii?Q?qVpNKGtZijKXuhqvgtGMooyHpgsNL3go++kj64WNoF9IB6b6/8mQpdIlli6D?=
 =?us-ascii?Q?+M4hBEDz2RCRgyAZsn/IvNt/7OSD7kNG22GuGBQKj36z8Vsqma/IGtDJXktw?=
 =?us-ascii?Q?r7c2hL/Ivhj2kLYP6SUW0PhAvrK8aVn+MZtNizoBhR2TKS0V6Vf8wxwlsTH1?=
 =?us-ascii?Q?r7i/s7qmKwdl4wyeZw3zlQ87xH6L/4+ho/+13KWyKqvwAo/i540BL0kvpcgB?=
 =?us-ascii?Q?ePZmKdzhAe1wWuPf7hyoReBDm8LJJ8y+ZAxk7WWpbbw0gOL4+v8UqHxF4vNq?=
 =?us-ascii?Q?GABb3qdMjOtvQtYkhH3tUu/j1JCcC9zwhZN2QHUumB54fkoSKN9nbplvQLZ+?=
 =?us-ascii?Q?94ZbyVfe5KIw7kqtdeyl0Rdwz1H9ghZhh+b19l0vdr3TxZonYPriND3j3UOl?=
 =?us-ascii?Q?Imk1Ad4OkxuECxy1x0XtzpHNJp7RyD2R/qc/yQBkP2ppZsIak3kkQdcCVSIi?=
 =?us-ascii?Q?MQNjW4NDXXccpWS6BhEQChoVq7DAvv24eU1sYrfakOyidKTlGux/MaTyAJWe?=
 =?us-ascii?Q?7YsEXgt8XAHbyid8D25goiuYnwxyvTBwvZybY51mpsx8jmQ3L8DZu1lacGDy?=
 =?us-ascii?Q?5GGPIhzBSthPebX4DwDb+RKtNisqeSThIkNDtGbCTUcLYqClkI8Tta5c4Eda?=
 =?us-ascii?Q?aJsycoE8/RwqXfMyoj9XwiK+cFA8wP1pODjg7qZsH/c3tWap/+llqUtZKmxV?=
 =?us-ascii?Q?0/CTE3aChYiKrnqZUeN/hLqJ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BmN5CmoLKPb4/1HPL/25/QfSJjV3RRc6R9bz00TuoovF5pM0S9h5euNJxgOy?=
 =?us-ascii?Q?CA+wG6PK/Y43UMrC704UWwsmgLKpiLy5ap5Bq2nUc62B7bfohHXDZ4PiB3Tk?=
 =?us-ascii?Q?dHnodEb1Cx6RCjwbL3LVZN0a8opeNvpz6WJTmriu3A5hov8cuIkbTd5jO0xq?=
 =?us-ascii?Q?QZkJ9qnjl9GImQ4XvhRtbYtkykVlSAwHGBXgmUKynCgGxqqqTK6r7WuNXurz?=
 =?us-ascii?Q?8ebgJGLHzS+JQwqrRmQllIYDQuSeInZICEzvyvDwY9LvgiiQO4z/oYSJj8se?=
 =?us-ascii?Q?JGseDMzY2zk1AxqztdniW9OoBWLDG8NUZ0nt7mZpk78q6y8CuaxyMPbQI6ky?=
 =?us-ascii?Q?mvGyLG3CD8OQrLW4IDm7466c5PCELt2pmB6la6zL/etMEUzdXHkS12CUyv2y?=
 =?us-ascii?Q?LGx7nY2yMUcx1hhKMx6PXUbv/UUGVL3Qpy2oh0sQg0LRcWm+w5qNxGISmL5x?=
 =?us-ascii?Q?lFqeLyvqm0uKM2Y2Piw26DGSvBH9OlFteZx2FF7cxaXyrhmyXSST3OxxNP4T?=
 =?us-ascii?Q?RzjudRT7ffB72hq8gr/HRyRIKTvg/5LCjfzY7L01N/JGdlJ+bxIzAWnThItY?=
 =?us-ascii?Q?tayzJPgXRaD6KJtcA3Mc4YvUOQprndVPnkSVFPnCvEMxWAoae2fpfE2FD/DW?=
 =?us-ascii?Q?jXEu44xRr290F7rPEE3QVpnlIGOBGjmeYC6+qXeDiAK8LNvvrx7HKbd9z25k?=
 =?us-ascii?Q?O77G3b8RVOz5WgeXRicsdgkJk5SILgEiqug4Xf/mvE5WRLpb216JuNNFQcHu?=
 =?us-ascii?Q?z0KmIjkojg0BjaSHeuRf7J4FvIp0aMYlXpitRw143mCo5nQYo9dwBuh21OjH?=
 =?us-ascii?Q?ff0vfReJnOAoN3HEZeJLtZVlWq5htaynpl020hq/dZFPHRSUz9Rg1iutimi7?=
 =?us-ascii?Q?nTERvVZpcWaigeOVRQ7k7v7F+0gboSacrl6Kdad0U/Uo59Z7e/tHsIICI8nF?=
 =?us-ascii?Q?gwJLuelimBr5wAXD/eyf6IMqw/m7N58mJ4otyBbwpsrWmzdENwsyzGAYEJvX?=
 =?us-ascii?Q?GhphNq3DPYWrJErg7fDcAadqXQY3+X+m3IYm9/UjjHLz7fJ8vRS0F8zQhlUn?=
 =?us-ascii?Q?SBmejdOqJd9q38qSNM6xGEKIVLv2q91b5vrXGdeX+d401cV/YQ0g9CvF+TNM?=
 =?us-ascii?Q?9mFREO0jqPP0J3qTc72cgbm3C90I3qq5Dp5gdGNdBfCj17oYEaJifZ7Py1hr?=
 =?us-ascii?Q?o4D01lI7WOX+NOUXnLwahCi4H+T2/5iaorOYabFoMk/sKEzpdTxEweO22nHt?=
 =?us-ascii?Q?2r7PehgZGSpckblF382lAKrcHFDkAhbMNFnrT+D63fIL83kbpGJyyYuGC2u6?=
 =?us-ascii?Q?SFoPYMxjJn0VJCzm87AyShjuH+dDRjbfQWLx7BW/aJ2rTkCi49dNamAKwonP?=
 =?us-ascii?Q?OMJZLfYfBkFg6ojEH9KbO4JUQ9WapjFeLzWQeHcYIcS045FhPdcYaRxFn3Az?=
 =?us-ascii?Q?fohc55fTeq7tx11FMW8Ls+7GiNws+8Q7ydx3wbMFBwZknbR1BK/U28gy439j?=
 =?us-ascii?Q?XkfxXPA9LnPP/sCxDNLvLegA7+Dr8PCxmTM317+pTdqLoE9VCbynASXoVfUX?=
 =?us-ascii?Q?nMZ+Zu0qVUqG8fDnw7nvJtdcTB4eOe3XMHymN8hk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33a3ae27-c115-48af-6df1-08dd0381da49
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2024 01:24:00.6182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EGlZ8Jo3A0j0gOLQcsq4QY9PheW7q9PslEQrwkzUzscolW2dueArdkFykME1Mqet
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB9018

On Wed, Nov 13, 2024 at 09:01:41AM +0800, Zhangfei Gao wrote:
> On Wed, 13 Nov 2024 at 02:29, Jason Gunthorpe <jgg@nvidia.com> wrote:
> >
> > On Wed, Oct 30, 2024 at 09:20:44PM -0300, Jason Gunthorpe wrote:
> > > Jason Gunthorpe (7):
> > >   iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED
> > >   iommu/arm-smmu-v3: Use S2FWB for NESTED domains
> > >   iommu/arm-smmu-v3: Allow ATS for IOMMU_DOMAIN_NESTED
> > >
> > > Nicolin Chen (5):
> > >   iommu/arm-smmu-v3: Support IOMMU_VIOMMU_ALLOC
> > >   iommu/arm-smmu-v3: Support IOMMU_HWPT_INVALIDATE using a VIOMMU object
> >
> > Applied to iommufd for-next along with all the dependencies and the
> > additional hunk Zhangfei pointed out.
> 
> Thanks Jason, I have verified on aarch64 based on your
> jason/smmuv3_nesting branch

Great, thanks

> https://github.com/Linaro/linux-kernel-uadk/tree/6.12-wip
> https://github.com/Linaro/qemu/tree/6.12-wip
> 
> Still need this hack
> https://github.com/Linaro/linux-kernel-uadk/commit/eaa194d954112cad4da7852e29343e546baf8683
>
> One is adding iommu_dev_enable/disable_feature IOMMU_DEV_FEAT_SVA,
> which you have patchset before.

Yes, I have a more complete version of that here someplace. Need some
help on vt-d but hope to get that done next cycle.

> The other is to temporarily ignore S2FWB or CANWBS.

Yes, ideally you should do that in the device FW, or perhaps via the
Linux ACPI patching?

Jason

