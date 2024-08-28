Return-Path: <kvm+bounces-25308-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C635F96366A
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 01:47:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 19A88B24752
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 23:47:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FE051AC446;
	Wed, 28 Aug 2024 23:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kFJGEt9N"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2089.outbound.protection.outlook.com [40.107.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A4D130A47;
	Wed, 28 Aug 2024 23:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724888818; cv=fail; b=M6OqQzAhOrJF8WiPbnI2hGuEgUjfZOEbVkOqwua+T9UlKxFdx2gMLMRJZX9Stj2CWEua7Y5IzosG/uQF2GEzR8GJnZdW5jXVgElGqrt06l8+jxJbkiEBxwnpZEfTqzsTYAiBqIRyYOzRBRVROmEVFsHvUkVwpR0bHpQ7BI/U14w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724888818; c=relaxed/simple;
	bh=GYlymF5OE1jYAaksOhNFzVoucmkJwUpMAvJ5NjE/nKI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dLY8V4DF90tU8++GAtq4KGR/WaUYX7Ux1koqo/Jshiy90btKsj6iUEm7Ff0BehbjjFGSsvIAr94uvd49VbCez0xy1T2g/HBovr10mFaMj/FVcJk5ahre1eClHg1aAqQ7Gtl6oejbbilD3Mi4GPFGo+KC3U072nGqDqV+mD5ZnZE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kFJGEt9N; arc=fail smtp.client-ip=40.107.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rUqJl8mGKke4Fk9solRSmFWysdg/SsIIO+VV49hEQFBdNWnS0/SIxi+IwKfKfxR0eOF1x4PaD/yjVoC8ruDJY6z+yqs79pialf4rQh65ttuT2oyRE29tU5+40cxZwWJuEaDp2a9F/rX9ZnVnP85Nlb2id7yjt0WyNYHiS8ODjZJ77Ha/FRwzqU3lTvSw6BUeObLImreZVmN137vN6bvBqn9zPzVCF0VTF5AMdi/x3EdLhMxIZ4G9CfXNCgbFThNmkyMkL/H1jKGHmFwgdTmS0fpPW6f+/6wkD68WEJy/F65gLUtzCkDqvqg/Eqb3E9fR5xhHztV+2INmm1QEQpZi9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DOZDZbFCfEiTYKflQb07eFNA4ALCkhEqd9bCLekOTHw=;
 b=Dmyo6qD49aP49f/u873eKcpjyFmU9KGIbw+uP32Vou2JrLsaseoDhAH+S1aUoRyuljYuwEbcOyTR6XPwd2ce0sIFs8zSiDlSgfAKvLEml5W9lWwValrEyGW3sj/bbBqJ2B8zcrX6VW8/DNC2ZcW5AfzqWqh12KC2M8sfErVVaKOvEa5Dm6me+wlzNcYLRyCr22vABjWXSFRmQXrUvY9jhlgTJD7XduaE5GoLtrzcfApupyXzp/qOXAmiEiqcranXfAa5/nHbMXqT2ma8lM6HBo40srZJRqOsFKBm33TtUNwuTv8odHAr6YSzLDXlp45g41WvPUCLITt0yHBSCrMgQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DOZDZbFCfEiTYKflQb07eFNA4ALCkhEqd9bCLekOTHw=;
 b=kFJGEt9NtWzHL1KUgsjaVy3mLAzOkEQE8B7qH3IOXQC+7YIdz30Ei9ZTBsqmycqmisvppnvjcOJNOtQGRvWAzmlHoQVRFf0893g2A1+DmmbMzz4v3O+p10JhyyzVPHeT1T6OT6HSpWdmvXm5nlwHmgSnN9P78HUlH9xa0Mjqf+KodVe8xZEfBBoP4LtqS9ExpiHyXx4lv0wIHfWi0DF31HEKAOVvkIpJsuAYwpcjidpPW39QLbgGZ8B2b2Tpfagyr1MkpVhJ1Pug1skM0Ds4dZc/eHzkW27sBvr8Jof5lCVAW68Y1ZVG9jz570PBwQpYFyniEycXWFZL5gqr/2tdkw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by MN0PR12MB6365.namprd12.prod.outlook.com (2603:10b6:208:3c2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.26; Wed, 28 Aug
 2024 23:46:53 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.027; Wed, 28 Aug 2024
 23:46:53 +0000
Date: Wed, 28 Aug 2024 20:46:52 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Gavin Shan <gshan@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>, x86@kernel.org,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Alistair Popple <apopple@nvidia.com>, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>, Borislav Petkov <bp@alien8.de>,
	Zi Yan <ziy@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>,
	Yan Zhao <yan.y.zhao@intel.com>, Will Deacon <will@kernel.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v2 06/19] mm/pagewalk: Check pfnmap for folio_walk_start()
Message-ID: <20240828234652.GD3773488@nvidia.com>
References: <20240826204353.2228736-1-peterx@redhat.com>
 <20240826204353.2228736-7-peterx@redhat.com>
 <9f9d7e96-b135-4830-b528-37418ae7bbfd@redhat.com>
 <Zs8zBT1aDh1v9Eje@x1n>
 <c1d8220c-e292-48af-bbab-21f4bb9c7dc5@redhat.com>
 <Zs9-beA-eTuXTfN6@x1n>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zs9-beA-eTuXTfN6@x1n>
X-ClientProxiedBy: MN2PR08CA0026.namprd08.prod.outlook.com
 (2603:10b6:208:239::31) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|MN0PR12MB6365:EE_
X-MS-Office365-Filtering-Correlation-Id: c6001332-7438-43ee-181a-08dcc7bbb1b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iU/g7S2AQbd1zGabID22DYdnb17UssOJ8Xuef/aLRDPb0ZznTiCKSPSESBci?=
 =?us-ascii?Q?K1ERXwRs/mYo/F7MZJ8hMCpePhkhBkN7+WQGR1pG6TMIyJHYRwuOL6piwYXT?=
 =?us-ascii?Q?pXRmcstTiiNubId9QLeZHxosupXc23Cys2iAHPiP5rQ3MXFbAxUGbRm+5c2k?=
 =?us-ascii?Q?lPMm6GdsCaH2/mCoGRNFPR44VbRdxIk2EKtkfT/ISCDUL6QioeRZ8cXYGF6d?=
 =?us-ascii?Q?T2mzo1j8T1cQd+vrC6WphQv6aMgc4RK/p0/AEOLgFrnugcwKP1Imyzd+H4Ci?=
 =?us-ascii?Q?ItQBOX12kBCbd/TAO3YnCWZ1NpGXbHXEZ2AZYQucfTOuUEcFujQ69MiEA5oF?=
 =?us-ascii?Q?Thb8e7WmsuWVFtrliWgduwfVsOHk4qC7v32wGqR7srVXmY2LihGXo0jEyyoX?=
 =?us-ascii?Q?6XwiOAeT2wY0b6HmAiN7qSh21UGPM/rqXQyiK5NN3VYJYUy+KCEdUPDaS+m+?=
 =?us-ascii?Q?M6i6s5KYjPRog0M85iRbhIaa+zl1cbDuKWETkuAALoGeA3+JTkd77rDWLQzz?=
 =?us-ascii?Q?k3C58h454bHwbeL23z4mWHHWCRNPJbH355jJVhKjJhV+QsN1VaBzKoC0PbeV?=
 =?us-ascii?Q?7DCadOit1H1h9lvxk/UfnxAja9LVvJWlDRoR9/IBMxA3kN3BBfB+RiyJoyUF?=
 =?us-ascii?Q?7AXKz5nCGO1hmfOJOrexYbwc2wY93FH14KigHwOuG18FLH8/cNzilMUS+12S?=
 =?us-ascii?Q?Vv2QrwAIEN31qjHG4Gu42nu7RQnbZ9kfD8dkkk4gWxaXHvu+DV5dJEf3kRfr?=
 =?us-ascii?Q?nLlNh0OS7mOmEjsRLDr2vs5ZTJzsplckfx6p3zMwWo8BVstvuuNVdoSV5OuC?=
 =?us-ascii?Q?+VRd1WNUWt2dd9TTivWQ9NtQ1Dfwd0tBlfzINyBBeCytX7XAJT7nwxRo8F9V?=
 =?us-ascii?Q?TRswdcUVdReWF7nso1cXgpIBCayYpHtNM0DILmtdZq+6QGmB5USIqSwVouk6?=
 =?us-ascii?Q?3ZGgz3JYACJ3Uxd6Na2fNQT7CkfO418jtmrXV3PljrNGHODWL1tYjY3ul42n?=
 =?us-ascii?Q?OsY9v3c9UrWXvdZX+WlC/G0ODzs6T1B30pgqxMs6j5TyZWpqQq0ezgWBtD/y?=
 =?us-ascii?Q?m1FxBFhoAVzj/QV8KFHMS9KtgC5RPv8PTH1ekfzXySFm2yWrndkgqcmzwsDc?=
 =?us-ascii?Q?AXoUPepXR0IItHuT3GOzvZnQ1mqg9l+jgDGfBbcFdqS3p10uSFvryAgJi2FI?=
 =?us-ascii?Q?zVx/yn2O3MkKXN14+FbBmECjfeQCkyuVGbcQJNjTCpD/HpZlPOWtSod7z/du?=
 =?us-ascii?Q?O5/RKSi0gVYeVvMPKr9gtOWaclt/s+bBjv88wvy/8zVJANlX7BWEExSg6I+a?=
 =?us-ascii?Q?TyNa05y0usPqbTXUun55DRlQISOb/HAFqaNcKmfdACcA0w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?L/WmZcK4l43JBypQeYZH3IEOfeL9uMHc5YzsVGg0htOc65Czlv9hQ4kb6RTL?=
 =?us-ascii?Q?r5jHrZGFbMqBSWuiG8KaiSp2lNFeXkiWaeC6fp9t/cMgjjDcMBlBshvU1IvL?=
 =?us-ascii?Q?V0+SoUhRF7kDFxxlDu5KViPlvPr+eC83yq31DnRDclAQr4xn4J8ZB3IrcxHo?=
 =?us-ascii?Q?Kzfsnf8mCbTPrslwM82R42CZnK4KW+groRRXh3juaM/075CIZWvpEG+QdGhX?=
 =?us-ascii?Q?tLVJ4OPfAc+rYCbXzMpSj8rnZfoMX3OYN/lTcZZLbTM2ldSwVCmw41IUGCIj?=
 =?us-ascii?Q?Li8jQ2valr3UFPYFmm4z7eoh55b0DCCv2GkyANHO6M9h4vZCWfqwBZpOllWH?=
 =?us-ascii?Q?CVeKZbeDIXBiLgbHqakSc1bOkxG2du90zTnlr9JXvwaCbPzo7S2IIif+Put3?=
 =?us-ascii?Q?KxPILoYzaVE0RhYGiCL4EMVKfy5eCzZN7e7NTtbatH1ZAyHHazIkQ9GxyfGO?=
 =?us-ascii?Q?e+fk3wS6VEuFWiXfQ278DbMyqlnBimW9BtEqt1gR/rd/rLaoqoAlEOrzF8xO?=
 =?us-ascii?Q?tQcxbi8guPeuuJxsH3jiAU2M2AAQ/7bl67kSvjbAPwP+2fuso4ZySyuiLYOv?=
 =?us-ascii?Q?Wu8Hk+vc+u617wX8gQh5Ikuezv3us5ayNmYsFG2mpbC0GtPe+HmwKKP+rZNa?=
 =?us-ascii?Q?O8e1TD6/X5ABHomrsAvqEiE2u0VonTcPIWl4WBEfBCMkptMrQ0NY7JhOWIgT?=
 =?us-ascii?Q?mn9Og6dgrdzbWa7D5Vs44Dx+x6qyauqRSIUUk0En6ZgmdVadEah3ucfVvoFH?=
 =?us-ascii?Q?mxonZNZt5XYacY8yRrr6V3nIxrIj7shRwaz63UWNJbOJ4moP9aVQb7EbahgJ?=
 =?us-ascii?Q?Xa0gCNKbhjFEKlxeWve9un/ziyC5qf6qwC3Qhdwq0Z4pItkm5TRb61pVBiyg?=
 =?us-ascii?Q?l4j0Cah77CCspD4xgPICkKTx454fU0Qtqm0ezPPbfA5d20snNTAPM1Fvl4aN?=
 =?us-ascii?Q?4+yF6F8+DmSYzGr4J7iOM3gdzdhyZorgsTO7FqGy0mARquq0sWMuW4tdbiGn?=
 =?us-ascii?Q?PXozMT6dGcq5D7aJFehJHOyIkjYCY9PZr7b0aZCh59meusubJz5EPUNTD+5a?=
 =?us-ascii?Q?fRfj7YGQkB7vRRIyF8o8IedYAscgHOrtL+bAJFIYNa/fm8geiwtpRag87dhv?=
 =?us-ascii?Q?ggi0G+8iQ78zIA+qRlmnj4p06uLR6IVmxMoSkJSQnady07/0mCiTQUtGQ0Tq?=
 =?us-ascii?Q?F2vE809FkBevsP/T29lBgUL0maKBJz0JCXEDaRGo5Q06FgoqFazbje8PUVbq?=
 =?us-ascii?Q?BU2meZ/pFLxS0ENeMkB76d9/k45jShoenX5+HGlmU1QGX/Y9A7Y7G11n9m7Z?=
 =?us-ascii?Q?eG3Ua1ciJbYECQYioOlBxrO695YJnElCXR5dcYSlL62fDdw32IA6A0Vl/ys1?=
 =?us-ascii?Q?nbJ0iE2OOElKHwR77z/t69Dp/zALvolG+aL53kznBMm6YG1rbuTgEfEeN5EP?=
 =?us-ascii?Q?G1cbLOFxYfy/AFLM9v0T4fYnZ+T7wfY2lcFm8WSNPcZRzm22Lj6Fo9eFIT7v?=
 =?us-ascii?Q?jrgVctYXk4tjjLb77o54AHLLluic/vueE5EuO7coy+OTYL8aiUxmUE3BsAda?=
 =?us-ascii?Q?oj2UIRZIkAVp+ZAI3Qah2nuZUxln1YZx+Vl0DOM1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6001332-7438-43ee-181a-08dcc7bbb1b7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2024 23:46:53.5444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jv8lcX4EQ1ngHBQiSuUpB5/7CcFs3Zem5Y4oY0zR7lRAIQiT9mvA0VN1jbAhXJzL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6365

On Wed, Aug 28, 2024 at 03:45:49PM -0400, Peter Xu wrote:

> Meanwhile I'm actually not 100% sure pte_special is only needed in
> gup-fast.  See vm_normal_page() and for VM_PFNMAP when pte_special bit is
> not defined:
> 
> 		} else {
> 			unsigned long off;
> 			off = (addr - vma->vm_start) >> PAGE_SHIFT;
> 			if (pfn == vma->vm_pgoff + off) <------------------ [1]
> 				return NULL;
> 			if (!is_cow_mapping(vma->vm_flags))
> 				return NULL;
> 		}
> 
> I suspect things can go wrong when there's assumption on vm_pgoff [1].  At
> least vfio-pci isn't storing vm_pgoff for the base PFN, so this check will
> go wrong when pte_special is not supported on any arch but when vfio-pci is
> present.  I suspect more drivers can break it.

I think that is a very important point.

IIRC this was done magically in one of the ioremap pfns type calls,
and if VFIO is using fault instead it won't do it.

This probably needs more hand holding for the driver somehow..

> So I wonder if it's really the case in real life that only gup-fast would
> need the special bit.  It could be that we thought it like that, but nobody
> really seriously tried run it without special bit yet to see things broke.

Indeed.

What arches even use the whole 'special but not special' system?

Can we start banning some of this stuff on non-special arches?

Jason

