Return-Path: <kvm+bounces-24136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 99E84951B5A
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 15:05:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ECBBFB25CBF
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 13:05:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BB6E1B140F;
	Wed, 14 Aug 2024 13:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SF+UXVc3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2047.outbound.protection.outlook.com [40.107.93.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2741109;
	Wed, 14 Aug 2024 13:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723640742; cv=fail; b=g6y/H9pag+a+6b5RZmHf3X1t0vBqmzmCvR73M4DuB9U60MHWK75NEDe4hGyT+1jmqx7cZGKqzcuROBgeE+j+6lyDH93ZHVw7hY29d7v1RCJQXsVIg2Cp+eDmrXL6QYrl7/e2t0BSGYv151gUaEkQxUTKaT5fu1SA6Fu/X2WzC1g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723640742; c=relaxed/simple;
	bh=0VZ4p6gVeHmZmUjD6MN/GOkTeDnqnBiYBoCqScdozMY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=O0U+IHpOqqwtOUJDM+PYsBDPpzUQQZHrwX9ihG56Hwt6J7LuOzCC1D5Kz/mxLIR5OHZcelte7LfDWkLuZARHQuZpRy0fg54cE/SHss+Ab/DRlo1NNy9ebaPO2Wqf2A4kMMOR/S2DysQgNaEXR6RhzzR7y1LTDZUbIxPvpy5Z38Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SF+UXVc3; arc=fail smtp.client-ip=40.107.93.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MkJUro2JTMp/y2vm1+YCvm4Wk1vW+GCDFk0oxSkDQKn+DsWVpJDZVvw99B98o4xrSvPlAIfnYpQhZmpMY0ES0q64ATRPz13bS+MDb0PtwgWxXg8tu/4QIIxkEH6EzCwvfd3u4LBEFzpgf3Ym3j82B3nxcNCttwjisMK0c+mOJeyG74xXyE5plVWTWgMQA+3nFJYP2QJpP9fG8r3t93NbNCbTVw0p5JLZ9D/S5Uevdv9eUSEBExzgUV3lYRLnLOqDXncC+YZrrDDxPTAL4RTwIfr8nStEtywoD1I+LFFiCX62MnTGE/rEGv4CyXXL/Qvdp8LWoHCVxyk9w4UOIYMTdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wi0llm+6f3vgmT8JX82VLigwwMTE7K59M07f0wMF3m8=;
 b=GP26lG6YMOir0FRTYudH55/vCPI5KtNcgTJH/Xmm+34gBjyIvX6xJeGfJr/bbfjscyPKAPxfheEqJSGV19VyQdO84tG6vzJvOcd+aGGV4GhVzMtJPOEauqQ10Z0dOWMRLSZwFXKJ/5JDY0tdrVc2Gde991w2AgwgrUHEMz+VnDaY+rzLe/ohlp6SXpnxSPDGSbz46VD3bf8vGgv2ra9WgeXA5/MdQ8ogOVTyc+mLhqRJAt6MZGGKd14LRSQhT4XYyvfxt0Q11wRucU7Ju18GAmzdzKs0KurR3gawLYNZAiuIzru/XVVVoxi5x9UppPb0Buim6+IYtbZaa4ct03Udug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wi0llm+6f3vgmT8JX82VLigwwMTE7K59M07f0wMF3m8=;
 b=SF+UXVc3s3fEMn1sQwj/hwa2BGzKXywS3VXsRCslYN0oJ2y2nztMIbrL6gnTiAkI0zTLDTPkhis802i5hlLAnZcUQPVrIoFauEvitFj/SVtfQyWgwPoO1AqyPW0AinJu/3KTv3gCaiPfN9We3kpzkioMJ+Abf5GhnJzWGZqM/0BH/jCLz4PtYExS72pr0CKISmMXyFmoXHhlTcgwpD5DOwWivQStQoWWclnrBua3QbVN5pn/1qO/96289OBZcEd3g27blR+NpKwSMt+u39tkfa5Qd9DXylTTgS7ZupGALGtFVOMTefRM8kw0dRa23zj/QjeefqwbGfmCxWenKdjKgA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB7767.namprd12.prod.outlook.com (2603:10b6:8:100::16)
 by SJ0PR12MB6854.namprd12.prod.outlook.com (2603:10b6:a03:47c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.18; Wed, 14 Aug
 2024 13:05:37 +0000
Received: from DM4PR12MB7767.namprd12.prod.outlook.com
 ([fe80::55c8:54a0:23b5:3e52]) by DM4PR12MB7767.namprd12.prod.outlook.com
 ([fe80::55c8:54a0:23b5:3e52%3]) with mapi id 15.20.7849.021; Wed, 14 Aug 2024
 13:05:37 +0000
Date: Wed, 14 Aug 2024 10:05:25 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	linux-arm-kernel@lists.infradead.org, x86@kernel.org,
	Will Deacon <will@kernel.org>, Gavin Shan <gshan@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: Re: [PATCH 06/19] mm/pagewalk: Check pfnmap early for
 folio_walk_start()
Message-ID: <20240814130525.GH2032816@nvidia.com>
References: <20240809160909.1023470-1-peterx@redhat.com>
 <20240809160909.1023470-7-peterx@redhat.com>
 <b103edb7-c41b-4a5b-9d9f-9690c5b25eb7@redhat.com>
 <ZrZJqd8FBLU_GqFH@x1n>
 <d9d1b682-cf3c-4808-ba50-56c75a406dae@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9d1b682-cf3c-4808-ba50-56c75a406dae@redhat.com>
X-ClientProxiedBy: CP6P284CA0076.BRAP284.PROD.OUTLOOK.COM
 (2603:10d6:103:1a9::11) To IA0PR12MB7773.namprd12.prod.outlook.com
 (2603:10b6:208:431::15)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB7767:EE_|SJ0PR12MB6854:EE_
X-MS-Office365-Filtering-Correlation-Id: f51edd19-ed39-44d4-d0f9-08dcbc61c901
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qtlDbHhn89iCLS601jF8gpJyVfd7o2xmI66DhEn5RCkrerbhA6k9igdqCf+s?=
 =?us-ascii?Q?w0th6Cb9TjHVF9dlEEyK2i1UBXOF7U15kx/FQIy5d+N7WAqDiLneTJmivhmJ?=
 =?us-ascii?Q?fmjgsRJ3Ka8RhURRBdDy5wkheRL+qsmpcOv4X4zlee3DZ+YPWqvV7HBod0qK?=
 =?us-ascii?Q?H8yad1OwfVcQTj3iBjWBvzirFAkFcOqF4Tb9MBbjyf1F08YWvGe3d6HUNpjp?=
 =?us-ascii?Q?mak5VK2jRwIMeLrBk0NKvPHxnqIH3X3KSYVS7JRakJ3vevOSy2F5VpTYZufW?=
 =?us-ascii?Q?haVvEC/c2EiBjEQXEDQ8YNTOFsQ3VYkfu7KW491Jrbk7wjh3q1rxH4aCR+Mp?=
 =?us-ascii?Q?ZxztgIxDy9jxRSpDftEMOBjLlm+24cSnxngkr6yH+fIqzq4kWhHTlgguBTMW?=
 =?us-ascii?Q?fuUD8GbqMtBj8k6qaWblTJHLk/2JKnMV5OXijzwNDV6lX1y32qCVQDKrWl6q?=
 =?us-ascii?Q?YSTHlVU542OYifMezLp+eAwj11SQ8EsTD0AcSPSZzs9w/ZJAVpU07kve3mfO?=
 =?us-ascii?Q?oVoO9TDnTAe5cMHempWYEOwaj6/1bGIRlz6x8eQgmBcYe1O7hOL8ZF58H5ok?=
 =?us-ascii?Q?5ixEcd3eH2OUaTZa3W3GNdIIDIAGyyIG6x7qOGu0D04dQDe9tjsbkrjQ25rs?=
 =?us-ascii?Q?GRyJ4IFGzG27UWlsiToCiib3CVKrzuUkJyedUu9CXArUGvGSR6g1txyH5Xj9?=
 =?us-ascii?Q?AFUVn3ewFiKMQgOvtLrHHN3zeYdzF7H2L3EO4ev6/to1vRF2FeXOeXTjbA5I?=
 =?us-ascii?Q?fvcM3ZO5mUEYxM3eYr7/dWEqSVDh1DoJVbObSrN3N5Pv0kTc/Dsawcle0kH8?=
 =?us-ascii?Q?rFyBy4cxLHv61ke9vCRqK8ExBQJf7CmjahIW8WPHJjS8OaB0ThRwlhB8I6D1?=
 =?us-ascii?Q?wSGoWpYHFXl/NBFDoe0Y1+stNUvBBuQZVx/IM1vieBtP+K6r65JqquTtgpPg?=
 =?us-ascii?Q?jzenEL6pI1n+YrRvM9IgrkzMY3Ac64wGjur2IPYwnQ8eBBI2qc4532Pqola0?=
 =?us-ascii?Q?aI5lJC0wnvb8/75Ntttcp2u7g7UNGp4tQoUfbm3LvRRqKu/qBkl2tFx7UPLr?=
 =?us-ascii?Q?3IkCfRpsdv418lurZWzV9DfK8Gv1lSrt+krSHegdVy1G8ZEd5LSUGlCdqMDh?=
 =?us-ascii?Q?VYkxvGOJeJkmG9KhjQdtTIU15Jl+rIX81a2/urTlWxDD6X19r0ASdtWomh3k?=
 =?us-ascii?Q?Sr1Ef2IketBTbIHfcmh4mTodJihAwc9oaSBTfyzU1kxgDXOGzhM4EsZTBKz2?=
 =?us-ascii?Q?enb0815dsPx8oFUS7VbYX46SUPDApzniFT8rQPBTk5MSbBq6q9QAYaVXJTdD?=
 =?us-ascii?Q?t3BJBloyTLhSgrE+CqMydISuURHTHdVs4DoscDK5VzajLQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB7767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?K0N8ArdCwWuDSKQp2lYCYiVDXfAPYtMh2u9dzGmBUktOODAT4W/tauythKfN?=
 =?us-ascii?Q?bc51ev+bZM9RSP7qZRIRz1vKAjG3erlft3FNbp1rfAk2xvSwYtcmadJQ9jkW?=
 =?us-ascii?Q?V8Eaj0cbVvRjTz5J1dpxbiDCdFD7+y9u+1xwZEZTWBqI6lMhTs1X5ylpW6ad?=
 =?us-ascii?Q?N3+eRi+FIW5qb6XttjoIpC6THBJaUB8AJVZCPsBuyiFVxspqLKA+t3V1L/xO?=
 =?us-ascii?Q?gv/7OxJsLkMrh//Zlk/aEVI1G5cimcxIhLXknWBcfB1+Oqk5A6tRNtafIFB7?=
 =?us-ascii?Q?Vn1J1M8rRyz/Ybyx8jNGudDH7UyrMacl8SKTv/QHsEYq8TBntm3siJ5Bg3oD?=
 =?us-ascii?Q?pMMyH5sz6KdQfEPT6qu2ExsCrKXwEYPcVO+Z+96A44AEivOh9xSRAVssN18D?=
 =?us-ascii?Q?4VeQHRELIB02fUVfrMUuqlebBMuv/FqTqmU2eeJP+vZLaLEgm3EvtABgPwmd?=
 =?us-ascii?Q?46kdujE/aAxfmnhtBSmPT6qhwfa5n6WTjV1LjEfEnQpWHWBUE/iy3o2gwSyD?=
 =?us-ascii?Q?axwJAgZv2hOgHVTnO6mqO/JUCo3yHPbRQ0r/ZxbQg8nQx2Rpx3BhuMPZzz25?=
 =?us-ascii?Q?nCu2IzwY0Zha1fUjYGv83A21HbEH19I+klHJF9DiV3YzqPKS3zs+EdG9RtqK?=
 =?us-ascii?Q?yHM5jamILfZZO40cv+9b41+jR3aC/ahMYYGXi8oYQBnYBrVrHfF2m5wLU0S9?=
 =?us-ascii?Q?flO3bLQdmn7nbJcZR8J9j30WT9RjswtGgaedXfOsIdKzghZ3DZckPcje8o3G?=
 =?us-ascii?Q?63K7oz6zfwMAbaCGzNbKt7BVNm9QO7kiaIzzVprH54bQEyx7pp71VL8We8Q4?=
 =?us-ascii?Q?LxJwq1YfXM6nDcSb3FyaeuDWx6efqTpFcD//isL7mBzBX2dxl5vwDrktZnMV?=
 =?us-ascii?Q?RfFpO2PftTQly0LhWeqVIl1bAzGuYFIATBACB6AWo694pGdczgmnqvp6z1ot?=
 =?us-ascii?Q?B6+lxuSD+6UZyNmWn4oPpB8tvDFag+515ezYERQd9oWn/OvCdGmfz+DoOvfJ?=
 =?us-ascii?Q?Q14/Zr62mjM9oFWm/6eIzRIMQznm9hycZUseZcpmkcw2lXLmHl38hrdEmDL2?=
 =?us-ascii?Q?M7XBeJDdbrb0xyogWLMte8W4Wupbk1U2++I7l5VOBtqAswvsyQQjGKBI9KFA?=
 =?us-ascii?Q?s+siRR23WIHbTlEEV9gXbbCh/4xk9vOALCVyglgguRZBriHkl5ZHVQXjt5Ks?=
 =?us-ascii?Q?nx1pYc9vNgKKWSPMV+PwYstK6n/aEhjkWRkmQ3ZzGpwZzJhiOaow6thY+wUq?=
 =?us-ascii?Q?bvt3sJpp59FtqHAeO/u/kURrjOssi5xrB6LTHWLY64Z6tkKIJi4AWYG5JH6X?=
 =?us-ascii?Q?oHlI3bR+HFihGhajq4DeimDXTOKqUOQdyk4XjdyAVcb0510BTj4f5bQrgPhc?=
 =?us-ascii?Q?44wVTtgalXSaCknwkdNtn+u+HZRqrH3kb5d0xkVgKjady+om2wCxX+oWWZlB?=
 =?us-ascii?Q?zOudYWSFTGhCJkSVacTsqX4icPBjsNjS9S3QZxMPGPjbEXS8hfE8fSoeDc64?=
 =?us-ascii?Q?70zRTvcp4iDYnmiYUe14lNGY3zqAlY021pJ6ZEFjsJwsOm6CJ23XJwrDI2GP?=
 =?us-ascii?Q?LBcJ9jCg8g7/SHat2fNK+Al0oyCpkkW4wKvRdEKG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f51edd19-ed39-44d4-d0f9-08dcbc61c901
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB7773.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2024 13:05:37.3241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rHeaDL/k9/OFnTvjZ/qFv0qhpyTCXS3hHuHwrUETWh026w0LtV/Rcaz9vcpjURCF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6854

On Fri, Aug 09, 2024 at 07:25:36PM +0200, David Hildenbrand wrote:

> > > That is in general not what we want, and we still have some places that
> > > wrongly hard-code that behavior.
> > > 
> > > In a MAP_PRIVATE mapping you might have anon pages that we can happily walk.
> > > 
> > > vm_normal_page() / vm_normal_page_pmd() [and as commented as a TODO,
> > > vm_normal_page_pud()] should be able to identify PFN maps and reject them,
> > > no?
> > 
> > Yep, I think we can also rely on special bit.

It is more than just relying on the special bit..

VM_PFNMAP/VM_MIXEDMAP should really only be used inside
vm_normal_page() because thay are, effectively, support for a limited
emulation of the special bit on arches that don't have them. There are
a bunch of weird rules that are used to try and make that work
properly that have to be followed.

On arches with the sepcial bit they should possibly never be checked
since the special bit does everything you need.

Arguably any place reading those flags out side of vm_normal_page/etc
is suspect.

> > Here I chose to follow gup-slow, and I suppose you meant that's also wrong?
> 
> I assume just nobody really noticed, just like nobody noticed that
> walk_page_test() skips VM_PFNMAP (but not VM_IO :) ).

Like here..

> > And, just curious: is there any use case you're aware of that can benefit
> > from caring PRIVATE pfnmaps yet so far, especially in this path?
> 
> In general MAP_PRIVATE pfnmaps is not really useful on things like MMIO.
> 
> There was a discussion (in VM_PAT) some time ago whether we could remove
> MAP_PRIVATE PFNMAPs completely [1]. At least some users still use COW
> mappings on /dev/mem, although not many (and they might not actually write
> to these areas).

I've squashed many bugs where kernel drivers don't demand userspace
use MAP_SHARED when asking for a PFNMAP, and of course userspace has
gained the wrong flags too. I don't know if anyone needs this, but it
has crept wrongly into the API.

Maybe an interesting place to start is a warning printk about using an
obsolete feature and see where things go from there??

Jason

