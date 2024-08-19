Return-Path: <kvm+bounces-24528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A51C956CF4
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 16:16:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E12761F24CBA
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 14:16:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D151616CD02;
	Mon, 19 Aug 2024 14:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fk/8Heem"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2063.outbound.protection.outlook.com [40.107.243.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE0615CD75
	for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 14:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724076993; cv=fail; b=hrAZQYXdM2+nCdEMd8YXS6xsRvpb7AaL5MzBy/bHure+eCmpOWj/lUx9KcBACfAD5ddsbxhew0Hpc+kIQOJOhDJAzLjQQQV6XmxToU4AE5p6p78A4LqOuRw/7r3zeWoVY/spLq5opPhXaySF0q7ONw59PHH/y2fVZ2ybq08CU40=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724076993; c=relaxed/simple;
	bh=Phq8QptvDfgvKH6vvi4bpy0vIg7UN2vd0Yc2K7Z93DE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=l0aeM43GX1RTSffASV/2tWQ63z0v3a8a75RiTwUjUdlJi0CEeDdZp4fmX40GuDFKCk6uGoC41KOTI3wHxOq1N2Hz8PVbPbDtbP9X4WdGLydejwgn5xoJSUmP+DBZcNj6sXmXGRnkQUIuOKZQyRwFibwqcyheJWiZ/1srH/TTa6k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fk/8Heem; arc=fail smtp.client-ip=40.107.243.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fop5xc1ytx9TKQiI9lxQaV+ruoM+hV44PDf0U7tGOd6jlcuVUDYjYoGOYADB4mGdSSoAy/AM5iYtzmnVy7ugKWPAOn+9xFxfG5Gt6jD0ubD9d+GHYPMfPp8FmdE2C8utLdWJpqCGTzWp9cWjC7uKlXBuuuX6f+J16j3kE7azLpTj4H6vgrI7IRmRCgWJvFiY1tMomhJ/updANGMcBvXN8BYeV3zP9fxYMHyMX3Jd1S5qBn+EJ2OBivhgAzSwJCAnMWa3hYPX12YgnLYtHA9U9EMTimjf/Fy4+/tBoKBWIIl9QfS2PY3xQG0cGRNdTUX1J5GWJNvhOy/BipCfdjMZwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gYM54ZUC4PJHBblFG7GjXWlWg0srE4+k1wBWqeR8WC0=;
 b=wmhLH1EAU4VM15XF9iUDgl358U4MPJRaeYfDtA8q54OYgwfJH7/+Bpi4kRRyW5uIbreYUajMTaHSGmsWP5Yrw5B3Nd016PV69cK951ot+QqnwsG3eeOyV8IYDEXXi02iJS2TjNzQB/D9E/hST9sEsEwwE15+TeT7pe9k2QkzUn/xhVcNpFlmMbBa4MfL9PnMomrWS0nOrtTmvTmkvU+LZ2f5wG05DWExZrgJRvk96aZSnijjDN4mxe65AhUyuqr1BlwmZdr042T5Wn9ACsNxWJzoHXO2jVbkMf5Ct+mc2Qcpcpm7rznQD1EXchdjkfcAI6tjhLzZyEAEtWgo6nJPDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gYM54ZUC4PJHBblFG7GjXWlWg0srE4+k1wBWqeR8WC0=;
 b=fk/8HeempvGzVf+gbmVzC6h5UJ/AXI6ZbIg86+k8G/X7ZwY153Q7Q1fNon4xLWrLgSr3sz1/GSeBobJoTOvRNWcx2fSbXvJ3A6n0y7vpF2rsTwLULSxLumPLNv8tdqfvx+Ru/Wx9gnS3U18t3Y9e5B1aV6B+EXL2iPtt9WeRE72sL5oGTAAVf1WrcXCJWhaJs8/RZB6ChU+yVF47PmneZWjLZXSlWXpwmE1GidzdfX8+klLnb2dRgFIdRG3YhPFx+3uTW+q0tFPlysYp0yJcrqoCIT9zgoIrChTJqDCOREi8Z7dp0wd/D6rdKkB4919HQsYF2ULJ1BG3ktenkhj3NQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by MN2PR12MB4064.namprd12.prod.outlook.com (2603:10b6:208:1d3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.20; Mon, 19 Aug
 2024 14:16:20 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7875.019; Mon, 19 Aug 2024
 14:16:20 +0000
Date: Mon, 19 Aug 2024 11:16:19 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Christoph Hellwig <hch@lst.de>, iommu@lists.linux.dev,
	Joao Martins <joao.m.martins@oracle.com>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	linux-mm@kvack.org, Pasha Tatashin <pasha.tatashin@soleen.com>,
	Peter Xu <peterx@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Sean Christopherson <seanjc@google.com>,
	Tina Zhang <tina.zhang@intel.com>
Subject: Re: [PATCH 09/16] iommupt: Add a kunit test for Generic Page Table
 and the IOMMU implementation
Message-ID: <20240819141619.GA3094258@nvidia.com>
References: <9-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com>
 <292a7ed2-a2a0-4dce-9741-b7169402b290@quicinc.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <292a7ed2-a2a0-4dce-9741-b7169402b290@quicinc.com>
X-ClientProxiedBy: MN0P222CA0027.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:531::35) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|MN2PR12MB4064:EE_
X-MS-Office365-Filtering-Correlation-Id: 78e84a69-fa1c-47cc-2b0f-08dcc0597f45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+NOJWaFZ1sLZkoGiXNdmmISvjZb37DKG8NizhWzjGm7XzEBybXrNGV8yjZs+?=
 =?us-ascii?Q?ctZzQl34LyX1Z4ZK2JAeGWrxsa9AqmoHwwkKFFpcnVMKZDdxrl2T8AEXXqSk?=
 =?us-ascii?Q?O8qIgIfFGJveOmyIMTmQYOMsTmD/ek0a+Q8qTKmJmhM1VR/H7aBJKPQzxF+P?=
 =?us-ascii?Q?bi6JsEUOKmSuwMjbQFyQCSpqkvxlkncPVvK7y1CYhwUYNqpkQjVOCC+5R7me?=
 =?us-ascii?Q?LipW6fSFnQyyNPwbfxNp6WYqEwdsiPb+4mlP6niQROvZyo7rPKATkw4Z4HGn?=
 =?us-ascii?Q?hhcLvfq2qQuJrnmM5Sr5itJaxXEwSHvcKzfWPQ3sjc2rCNLTCYKfRYWhnc3j?=
 =?us-ascii?Q?+JKP2g/3YEEy7T8zJcdpMGNC5SrIg6GlTolHncM9azIcMs3ipi5SuRjJLL1f?=
 =?us-ascii?Q?t/AY0n/KSwgtUpqMBWKYgCNxVQbu++pVnpVtFzbJo7UEU/6P9uu3WQYO1ukF?=
 =?us-ascii?Q?B40G+fyp63Zr3nIdPlK/sA1KdZojWg5epDaApcDmAdkFHk5aw1zbKDNIXTLu?=
 =?us-ascii?Q?EvYIDZc/1OzodD96+XIMZ7KPQwuVF3zoWIJL3v4Ae7ZwoEvxymk8+m8d/wun?=
 =?us-ascii?Q?s4tDdxTDZQmdAb83LJUUeV7hSDlumxggfz16q1tXJ0jqEog7yrou/9A0eS6m?=
 =?us-ascii?Q?py/G5i0lv6ImhgTTM9ZfrXehWYHemcMVzE89ZU7B0nKymQVuPbbvTxWsF7G5?=
 =?us-ascii?Q?6ZTvb697qBxeg3m76O/inF8BG1DU0WPQ5MCoE3/HciY2LlFXoQhT94cxlBwM?=
 =?us-ascii?Q?qOUk1Xpl4KJ03YmfA3HVIVXFnqr12Gj2PmpxwbfUk22WeZImzrOyr3UHR0oD?=
 =?us-ascii?Q?9fz2MK1lWX8fDEnokPsGyoshdqoKZnXtqoWfjv+tbUl8kcX++wjnjn4sDoEt?=
 =?us-ascii?Q?aOdESSKKXoy7pimM+GjLN5Rb0WgEMMKT4O6hR4idkmWkWexMoo1kkTs1tLYz?=
 =?us-ascii?Q?qNfj2Zs+m4MgyU3xlgbI1EMnQq+GK/Wr4DuBIvhWizSNWM+gL+dQAyZDWepa?=
 =?us-ascii?Q?kp6ZUROhTIxwZi9K8gZJViRY8AFjwJaRIw0Qijt8xwd7BRNkyZ9+GlWRio+a?=
 =?us-ascii?Q?WVAkdVZjGmlA+eL2U3WA2pA+omTmay6sMCMTP3jvoXJlnBoS9vmtBBtPXLM0?=
 =?us-ascii?Q?aVfR1PDjOJyMqk8K6B5uwTrpQ3c0//jPfMP5fXhPfaXwSVFsj3CqjdTrgcb3?=
 =?us-ascii?Q?Oi4K+U4fbZO836YfYI4OxJuoefTeFHvCveuUbUdratpIy8TSoBviKQ4DvZov?=
 =?us-ascii?Q?OkuSmglJ5SKjKUlsg2T5Bf5uW9o9rzLJArrL+OthkQqgly3a7jdrzmkKOoJp?=
 =?us-ascii?Q?rhI34yWxQuuXhlbwDs/RJ3izJ0evjs4mmG1PJFmWLEpxFQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7j67n9cK2VvUJm5vKjRKwHdGuCmtS9qSVe6gDbVBIYfX/WAi0KMuLPCRAkma?=
 =?us-ascii?Q?/Wu+35W/p0Yzj8S2a8ad2TOYJUmTEekhYbLmWfi9Fm7l8pnCpKkaZyGo1PQn?=
 =?us-ascii?Q?M9I6ES9KjdpcxvzsAu7yISCZVsWijd0x/aOI3CO1bwvA70apmDtQocEFM6gi?=
 =?us-ascii?Q?V0VQYmKqJ6BQHp/PWGZDNhi+0tfetIdmd6kSN2mXzJQJwmaSIANWM9q2kkU6?=
 =?us-ascii?Q?CbuMgQeTLWEdvtOywI/HW2SOCcKZ0TJhRSkYnrNt7N1Jb+1A2BtcdLwTGzY4?=
 =?us-ascii?Q?h387+ZQgI55q1s9Kn3p7TwwBv9AXSaEtinvKeH5eBtUc/oSS3XS3T5GrtMf7?=
 =?us-ascii?Q?J9bzG4NSgO7VwZQ4Vwm/9Iec9zK2KE6QV6Alc3V5JEyZHILL0+3+orucYUQO?=
 =?us-ascii?Q?2aVV8upF9DPyVrN4GNQt5qpoLasKosevslEJgr92cjXMDd9/Zxa5FurXJ/nG?=
 =?us-ascii?Q?tQj64dqQTyPeZ+80gTmf5UhS/mbEuYkMbGFiTAbTVvMcXHc9dKQSj7+s07Le?=
 =?us-ascii?Q?kEjJiUW9Q+N3cAEbaQwSMAQf9+GSMdsz2f9a/W96Y8nDWAjkg3ekT7M9jCJu?=
 =?us-ascii?Q?9xedsRaFU5qXQxL1g2ugIPiu/D6lbnhNVeHjl421mcEUf5C/Kb4pk35JZH2X?=
 =?us-ascii?Q?kU0efPcplj6Kuh7WBPT2EwoBfnvQx8iMyRd+PdzcbAgEtNNsT8yg9Vnu7mRB?=
 =?us-ascii?Q?AHId4kcBS9FOlsYjj8ANTrn+tr6+9/I2L5xZkZqISa+gKiyQqfvZI7WAAaed?=
 =?us-ascii?Q?MwMEQfnwBUwMs1/TdInrrl77MYQwB0MiBeHJ3ju4pXOyvzOWOZ3fbzIMewNk?=
 =?us-ascii?Q?fNfccLMJkOZamnBmhzGtN+uLrhgwu1qs3qLnA3NBhLg6E5q4vs+j8EZW4YuV?=
 =?us-ascii?Q?DcMt2W3FhkMdM04Fbt4NHaGCgPZSZlWYI7+X8ME/4MMNwkxDGWZeE2eBJaQ0?=
 =?us-ascii?Q?16MKRNijEmoYxhyFC6XzsOXeXEXyWVuursCW5o6bugofZMWD3hsGgeyKQF3c?=
 =?us-ascii?Q?eAQzK+ZxYCp/+HC02k3yg6loUAZEQmKcd0cX3iIdPCf76/Re6y6+WBeuaBle?=
 =?us-ascii?Q?6Im8KTnlZP5k34rGExFQeYr3dr/xC7GBQOB6BmLd2OskGU5tKzI53JMsc/+p?=
 =?us-ascii?Q?cVAqoXX7cbPn2fK2QhBxBvJZyy0cSb2Md1zw8K3zoqT8JujL0ka38r6UnBw+?=
 =?us-ascii?Q?2onIY/NsDLP7ruKSjFFDy8PypWvLOosVmJNZh/jzSmavnJysPTIHk1Cm0eta?=
 =?us-ascii?Q?a7PhbD6y9waF34b6vyvf/xu6Quywnb2fF2GNV/H+5IRWT4ruBgTbbuAqOWfY?=
 =?us-ascii?Q?m7s9E1DRVvU6fxN6EBmWMcKO02T7NoMb9q233wX3m8Vbq7o8SKEryry840KN?=
 =?us-ascii?Q?jOnVjzfR/g26d68GCR3HO4krgu5Yu8BCBrwEgXa0k/htRofP3JLU+BcajIEL?=
 =?us-ascii?Q?0quDH3GEDsl7IiD0/ESr8spHufT7iSdhLeUbV7Z/64o6H/TymID4dZECMrlv?=
 =?us-ascii?Q?5Gf/VYiIPoSIXjyvwJlMwUc0jn7oA7IAvRI1U/mLzb99p3ARYyolPxGk19OU?=
 =?us-ascii?Q?Wk+lABeYnbb6LD3gWIlJ3bIS4HMLnEDQuPSuCyON?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78e84a69-fa1c-47cc-2b0f-08dcc0597f45
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2024 14:16:20.1256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c1h+SME5m64TM7qo0CdqepNvAOjkTsfqF7XpjDj6oOdiLS4zAaQC4yR3M1dPR72g
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4064

On Fri, Aug 16, 2024 at 10:55:50AM -0700, Jeff Johnson wrote:
> On 8/15/24 08:11, Jason Gunthorpe wrote:
> > This intends to have high coverage of the page table format functions and
> > the IOMMU implementation itself, exercising the various corner cases.
> > 
> > The kunit can be run in the kunit framework, using commands like:
> > 
> > tools/testing/kunit/kunit.py run --build_dir build_kunit_arm64 --arch arm64 --make_options LD=ld.lld-18  --make_options 'CC=clang-18 --target=aarch64-linux-gnu' --kunitconfig ./drivers/iommu/generic_pt/.kunitconfig
> > tools/testing/kunit/kunit.py run --build_dir build_kunit_uml --make_options CC=gcc-13 --kunitconfig ./drivers/iommu/generic_pt/.kunitconfig --kconfig_add CONFIG_WERROR=n
> > tools/testing/kunit/kunit.py run --build_dir build_kunit_x86_64 --arch x86_64 --kunitconfig ./drivers/iommu/generic_pt/.kunitconfig
> > tools/testing/kunit/kunit.py run --build_dir build_kunit_i386 --arch i386 --kunitconfig ./drivers/iommu/generic_pt/.kunitconfig
> > tools/testing/kunit/kunit.py run --build_dir build_kunit_i386pae --arch i386 --kunitconfig ./drivers/iommu/generic_pt/.kunitconfig --kconfig_add CONFIG_X86_PAE=y
> > 
> > There are several interesting corner cases on the 32 bit platforms that
> > need checking.
> > 
> > FIXME: further improve the tests
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> ...
> 
> > +kunit_test_suites(&NS(iommu_suite));
> > +
> > +MODULE_LICENSE("GPL");
> > +MODULE_IMPORT_NS(GENERIC_PT_IOMMU);
> 
> Since commit 1fffe7a34c89 ("script: modpost: emit a warning when the
> description is missing"), a module without a MODULE_DESCRIPTION() will
> result in a warning when built with make W=1. Recently, multiple
> developers have been eradicating these warnings treewide, and very few
> are left, so please don't introduce a new one :)

Yep, I fixed them all

Thanks,
Jason

