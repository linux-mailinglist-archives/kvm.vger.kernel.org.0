Return-Path: <kvm+bounces-49423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 995FFAD8F3C
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 16:19:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D4560171C21
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 14:13:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6942B2E11D4;
	Fri, 13 Jun 2025 14:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XkEuHb3Z"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2081.outbound.protection.outlook.com [40.107.102.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D942E11A2;
	Fri, 13 Jun 2025 14:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749823983; cv=fail; b=qOGbovwtP2+MB5UEIH3yNhPxPPTLU0SNZbnTDPRaKQ50WpijW+HiS42TbA+CcjfLRseNu8Jaq22gaai8T9hKd7MRuHbYFuZQfK8jpJ+2VxWlue5Bl9s2Pee+Ey3NzIT1H+TeX6NTpqlFMd1H3dfMIk+1TBX3Xn4IJJv7fBJpeeQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749823983; c=relaxed/simple;
	bh=qoyuljyFOhG78ZCJtMBCDYziR7pP2FTRxKz/LMQUaHw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=d2gYoU6tjGocF6bLV5cuFn4KvrgecCJ9OGa+5TvSVS/Yfo/0aok6WZW0/slTRs2aqxx2WdG3PAE9NsLVaZfGQ5D65mE3vgKlH5wEEaT9X6IT3GuG97WkSdU/dk1WPzGB/QZ6Oh6DSmOpWJnRYgitIBAt2PpQ8ABzK/aqNfHfSso=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XkEuHb3Z; arc=fail smtp.client-ip=40.107.102.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bKIQ6sw0YefHns5avtj4t0a/PAkkASwVmhGQfL5vG2LePHCYXgYPFLrhbw7LUTZHxdpGZeY2CX3/lEuOTkiRkgD2ELI4jV2Ejit33Ro4QWoGKmC+fBc239m16UEZZ2zji0rum6iz6t54AlB7uM3srwCF4cBTu8QT82xgPuK6zMBA0peKiPwI9ZK0qqM77ACOWV9VjbZ+9SbOrS2NA4nj3i7ZbCjcMhMFWY90CLs8GRYzGJT7SesSf+B4dWOS/rjw5fitMMc9oQOV/Kai8BXKrVN6xrLVXd7whlFRO/wTuAtQ5e+m0jY6gN/9J/1ogSTwFQ9qPFvPGBX3qwQJWbaiQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MeWsCKYpdCBi2C5td4fUcHqGaRalI75VmSK8PVmjuoQ=;
 b=sBjJuQiXHKHpMQGdApqELE2RLHMStF/omTnAIv+/ZUyok/wCPU/Ai3VSYezUXFm7Jzj8lS+4vW0aWsrMJNwkRzZusXkpQPOOArDaeE/jWtvFjzIZ+uYq+VH0tVzttm7bnjAjCIj6G/ZD+RanbCugYOFPlhsAgGjJcL5xom9Tapd9M4oMCzqjiWbYNs8tjqcGc6HfhwwptDU+TaqFa6uFpuDJWUfxaeVrcs8LYAxm3JPWoVWNcGduLVh365K6unPiQGmovs7AKDDBEc9kgG6JNXUVJY2I5IlRd97cfh5I3u5HaHqcocUUFtYv+QVyM5cK2Sj+uol1g3kUCpus637REQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MeWsCKYpdCBi2C5td4fUcHqGaRalI75VmSK8PVmjuoQ=;
 b=XkEuHb3ZFFbRjOqlFdXJx3vADYGni/pN/ebUEC2dXQZlMg4MQZ3V5WW6P8ROJ5CJRugyK4oAVBvAd6xa59EGqlyYSFAzNZwWilzP8NY7lQ7LlXEfonnFVJcbsQ9jrLjUvuczdgK6O/zNO1sqWZTlziq+2RvRUpMcuPqq0b2bQ5/aF2CZLWSs1bCLFdf9AjQHbh9cvuFyJ77fwgiCrlfFli6RkVIdBuXrZk2X5GBNQPZAI/R5rIHfK9piEHgDkFS+SvQV+yyrbJyZHf1FPZxIoLsoWzLEer+gta9nUEJVvOL7oFn8ZQmiz+ehSKNCsCYOSO627N/nhBqj+Ara3oqKWg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM4PR12MB5939.namprd12.prod.outlook.com (2603:10b6:8:6a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.23; Fri, 13 Jun
 2025 14:12:59 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8835.023; Fri, 13 Jun 2025
 14:12:59 +0000
Date: Fri, 13 Jun 2025 11:12:57 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Peter Xu <peterx@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Zi Yan <ziy@nvidia.com>, Alex Mastro <amastro@fb.com>,
	David Hildenbrand <david@redhat.com>,
	Nico Pache <npache@redhat.com>, Huacai Chen <chenhuacai@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>, loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org
Subject: Re: [PATCH 2/5] mm/hugetlb: Remove prepare_hugepage_range()
Message-ID: <20250613141257.GI1174925@nvidia.com>
References: <20250613134111.469884-1-peterx@redhat.com>
 <20250613134111.469884-3-peterx@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250613134111.469884-3-peterx@redhat.com>
X-ClientProxiedBy: YT4PR01CA0032.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fe::24) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DM4PR12MB5939:EE_
X-MS-Office365-Filtering-Correlation-Id: fd53e9a4-9264-4b21-cf24-08ddaa846688
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cL5u3fNug6tdyhrHRH3rH5eq+ecUUT4KJCVxXycNeSg9ig44bai+oujIlpsr?=
 =?us-ascii?Q?aCHt9rRi29F4aA2RVGY8eolmVBO4IvxLAI0+lqUlkt8ebzCKAI9PMoWc3yI7?=
 =?us-ascii?Q?wz3CPUXdV0TqML5n8gcWOQf1wa0A7GYOOxIBymC/lI/+SWpWGjwpNWRZTFXr?=
 =?us-ascii?Q?7il9nPUUUkdNi764PSFxgs1WMHRk2ucl+siS9gaTvJNgK7/Wzw7ru4Gu4UQy?=
 =?us-ascii?Q?Ih7C1WiDxsa1Xn27r3eVvWRzWxmiqYC58v/0T/kRsBzS4ewRZXArM+U/ePR+?=
 =?us-ascii?Q?bZaH07HGpiGFivprPzuFShfoa6S9dWGY20WsuWmkKKxiqE5djDnXL+3wu6lR?=
 =?us-ascii?Q?atSDrBCjfqoGZoDEoM1VoQOicU3keu0CZ5LYeHfDEIrrtBsl+LFiO7axGDgi?=
 =?us-ascii?Q?uAq84pkittxWAM/DiSfeNt0pXsfSAbWoa+N6lY5x/mI5bNqvs+5m6VULdhjk?=
 =?us-ascii?Q?UtL7pSaW1zijJ7VUh1CY4jkRUWAaKwCUXGHCYkGyvCMOm4COOFSuOZsmf9c0?=
 =?us-ascii?Q?kQsTzCUrioYnw5d4Yp0fZvXqywpqoU7eGXFoTEit+2q7DRLSEG/enqKoy/wf?=
 =?us-ascii?Q?hkS/1vRG5M5mQB2aCFAp2TcY+zWg4RkvMXUiwIm3yGH5HFkcKGka3MOVRLy3?=
 =?us-ascii?Q?ykh7YDNqwuFsUjvSBE+JUQ9EQweRriqBxuj2YCS4omYSY4+O1O05S67Z+15w?=
 =?us-ascii?Q?AR6/2kaUSAPAiSfMhJO8ezNXqlcRjJ92FlRo6EVjyh+8kDp3nW3tJNeKol/w?=
 =?us-ascii?Q?aUsjepW3CVeAhhOE1cRHetJBAZaoUJgflYhNlRrvR1ApjIdtSsFNU0wag/lH?=
 =?us-ascii?Q?uVgXNcAckEIWL1SZ8nngbDvpj32tx1scTO8SrZVaEdWVlbSm1krzAKG8B4uD?=
 =?us-ascii?Q?ieSsBvj/klmeSEGhd34HjLvETGGok5QcGcS8j9NvtFMqtUDFQa0mFmKAN6a2?=
 =?us-ascii?Q?sadTrrN+QTeTAd+zuJOAfaqFsaxSdIC5+Aq6SiE0kBDQLVQxAA15qz7SlrYU?=
 =?us-ascii?Q?7SM+4gyaAKv8keXwzKYXcu0PYmCd/Zm8cwETygzUVzDdAeZtetT9H6jk9SBt?=
 =?us-ascii?Q?VZlAZrVDyOjn602nDQ1ibcCc5MtOcP2AX81e2QrGaYozQNIJg2CcL5Hd5Av6?=
 =?us-ascii?Q?mftQQujUaRUlOEHICBK+k2gYXbylSaiVRM+NViUpDKB/23QEUdkJOtXASlxf?=
 =?us-ascii?Q?iMbgGJhhNXgeYMotHiCIbykUKnLcvfv7zN3cH5qWlqkGCwJqpxJjUtSq1ZFG?=
 =?us-ascii?Q?CpLqu6sdNuzyab61uLa9dVw8vSY8NJnpyH55rz7VfTQ1TxQzmQ6c8XNvkNSB?=
 =?us-ascii?Q?07AXzsR1JD1d/lwmUvYzx7uWhbU0dG8jLcTgWPe3FZHlzYy5K+k5XiMeS+ZF?=
 =?us-ascii?Q?R7QClTTBUlmBKzI+lM8Ilo0+CD0j6uB0srUtUnGbbkanbj5Gaw+/wHiOwfFS?=
 =?us-ascii?Q?k/w09K54kAs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gG3ugECSVEndciSREFpzIZwY6MIPQhDpa/t02ocUNY7mrXpUw5QPaJLFMF0p?=
 =?us-ascii?Q?0WKABWLn1ZZEECplRL09DP3Nm0lS3KYh3ILurWXkoxzz2tQ/1HMCoO+c1PdI?=
 =?us-ascii?Q?LMrkMm9CM+17rMsgyXQThDo9I4ep58CWD5N2moSgGrdJyVz/GhzwLzmSLj49?=
 =?us-ascii?Q?59C1vbtIQ6Lg76SIGValfusWxn5+HgncEKcCmp02nxbHxJ8PEJM7HKBe8yL3?=
 =?us-ascii?Q?w46AzvjXdGKJKlTEEeoArglak9hrH56RWt4BKhOlhCNao5WxGUDFaWN8ytUJ?=
 =?us-ascii?Q?o/lmTic1d344qMLw/2EdaZupDc9wr35g0r8L9KOyecbLMdhbEyxmwLV0Rw+2?=
 =?us-ascii?Q?mxjjX0iEWx4q7wEHUVXWM/V0E5bEnJY42+kh+jqfC3/44GTU+KS2f5wckb7W?=
 =?us-ascii?Q?NDf7qhM2MvBd06SNmbaVgw9+Jvsx6Eh54cPFtpQVlStzQZf1QLZzbxawsGxZ?=
 =?us-ascii?Q?esmrNijn2iWqtkQIvCcTnFVYThfmDT9mvBVpBJl+ua1O1Z2itGTHRFN15Cfn?=
 =?us-ascii?Q?yzNO0u5cvo6FS88jHOPkGyHMzrOgY79Ff3iC3+RPm4pkbWX2p19KWDDV8azM?=
 =?us-ascii?Q?TyHULwHUqYefPeDdoPmaKL+V2t9hKTPhhh4KeHvR0butHvWq4qkjqypGLPyA?=
 =?us-ascii?Q?1ZbMIvHpUNxLtB3sE1nlGgj8X2Metb2ScJ4tLooGmm7Fc0jyMrvWaNfpbBtA?=
 =?us-ascii?Q?BixEckf2fAqGeT04QLaXFxgUS9noSd9/96+6pIBh6uI8dG7VAdFgpP7F/uk4?=
 =?us-ascii?Q?GVFb2fuYHmJBPeJpIOtTS8fb3hJm620d5pBouLHjv1/ICWPKz3Bl92R/zhdf?=
 =?us-ascii?Q?OUYQndiDTP340JZaElBr1Y5ycx5HWSGXTr3L1qB9tdnIs/hhkeeGH7y5OHVw?=
 =?us-ascii?Q?6xNSmBJZXZHYV7qBx1l1/qNowsaedAAy+lrS7MpVrD8d7uwu2KIHNnmyzbEo?=
 =?us-ascii?Q?mRNHsY2F40jBFAnXVaK0fjRXv864uZ/Jspvn97JlCkXCb6/epCAOQBPsTzu4?=
 =?us-ascii?Q?sNp1qKZvISaL5jmruu7TXVBxZqAKm1V2FKw9EIDJq1odKmk7jB6tX9UnvdD0?=
 =?us-ascii?Q?/Ps148OHmd4MfKuHabIHFgPovpEVsHHQ66+XqeiahiTgMWd71jS5DF+Pu1YK?=
 =?us-ascii?Q?kBdCMiri3wd5kUb+J912KBqKzZElHiwZJtFIW2epPaEAdHBj84QVcY7GH4rZ?=
 =?us-ascii?Q?lSEBp5WyxgLxf7H4S69/e+1CI1ADGcFFocQJfM+2T30Rvkj/yxUMvsSZob3m?=
 =?us-ascii?Q?IVxu5rYIL15140ZN3zWeTFz7dTEaffmXiS2ZFff7aPt03m9cg3FU2w9bOKzH?=
 =?us-ascii?Q?AosZh2PRJm0pZcjK7+xO20O3ZXe9VIj79oL4AbnVTpUGmUsqHm8O1+4zVwVQ?=
 =?us-ascii?Q?lJettG0qPqLzKP4G7DEKjlPHbXFliHXNww3eto3KryNB8DbjDZNFGAHLnNLX?=
 =?us-ascii?Q?BaDMe/OLTWWS37q9r9bMd+tVjIlZTNfgQHpsnnyg2hkz2F3NTe1myokCVdkW?=
 =?us-ascii?Q?YuBOvN5pgbe0FQASciHR/3RpM5txkqpIOdUuxcwXgHAgVk8NV+GqY7dF+PP/?=
 =?us-ascii?Q?i2aDs8wr3fOPDFVCPt+JRFvl5DV5B0RhZIWZ5fyr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd53e9a4-9264-4b21-cf24-08ddaa846688
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 14:12:59.2339
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eNT2f1hSFShGxZflLGr3eOX1unM2SlPxj1JVlI6XcqlKGy6UZQB0uDe8TM8a71+h
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5939

On Fri, Jun 13, 2025 at 09:41:08AM -0400, Peter Xu wrote:
> Only mips and loongarch implemented this API, however what it does was
> checking against stack overflow for either len or addr.  That's already
> done in arch's arch_get_unmapped_area*() functions, hence not needed.
> 
> It means the whole API is pretty much obsolete at least now, remove it
> completely.
> 
> Cc: Huacai Chen <chenhuacai@kernel.org>
> Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: loongarch@lists.linux.dev
> Cc: linux-mips@vger.kernel.org
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  arch/loongarch/include/asm/hugetlb.h | 14 --------------
>  arch/mips/include/asm/hugetlb.h      | 14 --------------
>  fs/hugetlbfs/inode.c                 |  8 ++------
>  include/asm-generic/hugetlb.h        |  8 --------
>  include/linux/hugetlb.h              |  6 ------
>  5 files changed, 2 insertions(+), 48 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

