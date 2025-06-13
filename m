Return-Path: <kvm+bounces-49438-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EB81AD90E8
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 17:14:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E1C5A1BC3A8D
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 15:14:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78BBF1E885A;
	Fri, 13 Jun 2025 15:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MornT9SM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2049.outbound.protection.outlook.com [40.107.237.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56ED233E1;
	Fri, 13 Jun 2025 15:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749827639; cv=fail; b=lfo92brc40+hNmTohIKpPQlhN5dIyrTMUBweRmdPAYY0PFk7e3qi+PkIA/SBf8MSXAyD23TvUQcJYPahAOF+MlrXnvUCe1w5mMyhPv/aWNWDktfyx9o22wz7tG9B0nJ0hUE4unyEZ+qxA6wSl0o/qKvJXyjBQ9i1zSoq/qw06Oo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749827639; c=relaxed/simple;
	bh=h/oRpe3sVTo/XdGTtW6Xt2BXsBT3CFV8WmCI7y7D5VU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=G6YfW/dIdM3M1IjfVr/ks64Jv5nGIl//31cJsEKADDNjvpsoAqTvwzP2d2/q7xnU2FSc42PZ7DW2Pj2An3FW+rq+JKLFdOc+rmPfNLmjyCfc4w5ZAVwSUuZAbJ1L3gQSLSzWgcUbJgDxcMMNQW7ep8xhwUvKHXS7QrXxXMToeSw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MornT9SM; arc=fail smtp.client-ip=40.107.237.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pDxAnnzFUZlR8WnPSojvvjtcutfHJ8T0lZnV5Su/98/t61YmKMochVsCBxNjaCak/ANIpaJ7fihLJf4lKLGtDBC4+z/BKt0EZ4jPtvlifBIIaB4g/WvSK0J1xEtXhc4v+iNHPrpMEn3KK1MCsm8HYrFF2rRJttx8hyilTY8ov0ZwgXyKUS2rSat8BwUvubcw8rKO/hI0Vv0V8tF9iZYynOw6jU1U4R1HIf+jz02FGQI/TROFUO4/OF3gMUOqLYjTB7iZNjzvTIz27I9ZatCmONddn140LwRwBdc27LVNq/7PPDAiPYFld1EH3CLX4RxuguLw906c6NF1xamiR5xfMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VxU45rtOzqs8Ul5mKOH0dgLFA7f+A0I+h8fKLCzqFyM=;
 b=kXwzEg4xR80G2qX7LiUvsX0S4tHOOlnP+SVdyaaLrKRrbDRW8sQ9OV1xBuKrW+IAAlo/4JRNxJIKUVn3q1F6CMiX2KcrxmsNdav4NcEmc61kKT1qNe2DG3eXlMLMH5+YxLn8uJCBUIZYChG1sNOLXTU8GKDQXll/pKAvotzdd7fbg0bfL7kyF0YkuJhQcogHj2+DHiH/cUfwTI67xK0ASb6WNaURffJxWCkCXhrt2R7E2DBasDwJIPBWUAx2ciy+70bLTgZfUVvYQljjOQ+MYk9me0FcXwE3nnmCXHtWvA9JfxPE7p263CEKnTeSaSiF3piPSuBhv4oQm3ZyUzlH+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VxU45rtOzqs8Ul5mKOH0dgLFA7f+A0I+h8fKLCzqFyM=;
 b=MornT9SMh5e4P88Pt1ulRw11IIeNBuKnYubBth64Ym+T0bqRn4rcJm0gVoLUfimk5yLO0deKOZi/Qo+pHamssyzLmyaDozmedLpfPqOM6UKdrTMU+HRPW6YNALVAebuQCmEG9bsom7HEc7cdJa/jIw0WnTHDKolI4HB7w+lTWZM0EzsA4xQgfaDgmbgwiqNTQbs86SCL3y55Tg5E93e40Dd1vp2ZlMf0BUZJIn/Nb3N0wqhwJSazuBwtV7vFti27/gjHXQK7ZqOtFKV+qFzW9iF6VbHdLcF34HNeXpQKJNJ+4qyO30glN4dC2NYvjYVb2go6awNJf76bNGJeqZQX1w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SN7PR12MB6671.namprd12.prod.outlook.com (2603:10b6:806:26d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.23; Fri, 13 Jun
 2025 15:13:53 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%4]) with mapi id 15.20.8792.038; Fri, 13 Jun 2025
 15:13:53 +0000
From: Zi Yan <ziy@nvidia.com>
To: Peter Xu <peterx@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Alex Mastro <amastro@fb.com>,
 David Hildenbrand <david@redhat.com>, Nico Pache <npache@redhat.com>,
 Huacai Chen <chenhuacai@kernel.org>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org
Subject: Re: [PATCH 2/5] mm/hugetlb: Remove prepare_hugepage_range()
Date: Fri, 13 Jun 2025 11:13:50 -0400
X-Mailer: MailMate (2.0r6263)
Message-ID: <050B65EF-6A1E-44A8-87D5-152FA9A60641@nvidia.com>
In-Reply-To: <20250613134111.469884-3-peterx@redhat.com>
References: <20250613134111.469884-1-peterx@redhat.com>
 <20250613134111.469884-3-peterx@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN9PR03CA0902.namprd03.prod.outlook.com
 (2603:10b6:408:107::7) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SN7PR12MB6671:EE_
X-MS-Office365-Filtering-Correlation-Id: 12f99950-7032-44b5-9800-08ddaa8ce8f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gHndY1DVImthgFTL9xqSbzdInbIO+25JewNjY5lG0YLkMcXFOfXmjIjd9X77?=
 =?us-ascii?Q?cw75I2NzEXzaZLdk7qCfnfh3LKzZZMwa8lZgROENXP4TkEERs7RHJozSBMlx?=
 =?us-ascii?Q?6cLjcgKwp2G5pCGVaFLmzovR+BRp079MlHNPIBmeIPzvlN3GXL1yNDAT5Cv9?=
 =?us-ascii?Q?XrZKLl+AsOcQLrwl2i5krF8Aut2aOKsHTkP1wpbHUf9r6RjlSFKbm5IG0LpW?=
 =?us-ascii?Q?DMtrlGpc4DmsFer+L/feWAABftFocwtRNUsARPBbNJL1tcKLFZvM/H/YTwQR?=
 =?us-ascii?Q?v8g/vg57g4rttfqtI1XIVYa4o5N/EgifNcWGXCy8bt+O2DvW+WjcWXFPYxIv?=
 =?us-ascii?Q?eTaZfFTtwz3DWtpOwg4fLMmnPFNB9qWK0imGi3LGCq1wkdkqU/27WkRad7n/?=
 =?us-ascii?Q?SzNmY6vykFHXcNmu7JN5+NbqMTp0HKZMtRsdtrx2dgP0SHmzz3kBtajXJt6d?=
 =?us-ascii?Q?ZnedVYy0LR0a+oabDMlpnLrvOVeQlnpXHFoEaHng+WUzE3zL/wkeLX0uAvP2?=
 =?us-ascii?Q?DnWco1oSVITzC3fIF/y8NHj1u2WYS/CIQgCnxIMty/NkhmAyRwgoEzvGpHmU?=
 =?us-ascii?Q?9gsUCaJcHAdXZiE6B6idGLaT9EuDKHiiEfwEUvoHxw9PEHdnduIhIX5sjR0I?=
 =?us-ascii?Q?JXe9gnwrsgL/nR17p6T4X9BNsTotpJr57pGibsMFaGd+zaD7WByOsSsSF+Tn?=
 =?us-ascii?Q?ukfB19Qv01VltZXFTkpX4VUs3qmFOd0tf/4lUybAREXfKctlNPA74IzWq6BC?=
 =?us-ascii?Q?kNbWSYkCx8k8NAD6oKkkQDHeMoraPrteTe6iEGgEQ3APQ0zW6QeXL0EV4eXe?=
 =?us-ascii?Q?EngxyqoQ8btZIXv3TbEC82vBmaRepKxvrEougih4uu3RIXabnTtT45agtZfO?=
 =?us-ascii?Q?svH0agSHuXeFQNuqi9lG9DbNmu8qsALVF3ErEUf07WULrpClMBenY0s0Tfbv?=
 =?us-ascii?Q?Bsy7Wc5TVQlA6yLTVihdGTBlUwzHeMJVS1l9OWvqzqLZUqGA8iW81wE8Xgek?=
 =?us-ascii?Q?+LIZpmT0kOKt2dWvzLLiIJgNkhBXaEOf2HLBz5fovpHxMfEG9mdDjckyGYnH?=
 =?us-ascii?Q?XLoz+HTRk6OiMdmTjysZCpAnDz0PhT6NUzlkzI0zUxCjI26fKIoiOmp/9Imt?=
 =?us-ascii?Q?vNaRhVa1EMuemOxwQmqebeD01952n4ndGe91IXcXCw7puwR+FTfBaGHg1+qJ?=
 =?us-ascii?Q?8cuviUd5gpfbyi/PThyTrsfKVtDzyBgr7ItXoXfvRnCszx3WqQJ8o3fZVWej?=
 =?us-ascii?Q?9HdnvwBj57e+O68VGuzfHM1f7O/4hp3W3aspFvhYpVFgGlq6Ymbr0C+FIrL9?=
 =?us-ascii?Q?wIciUI3MdoPgAeids2eSJ4bsW4uHpH47c0QLSaO2MD0FUW3QNckGI8tRxlzc?=
 =?us-ascii?Q?Cp27MQ8d5TtWv53Y0GlsuoKn8xaHP/V3z1ZtZFoQA8I30UVo+E+4WTsvWbIs?=
 =?us-ascii?Q?KAcitjHades=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/h0KaskP5yza7sr01akcblN9Ei73ENY7uZmYouruDLuE5S99FV8dr/pi409D?=
 =?us-ascii?Q?SkAnFwQ80P48WE0h6nrU5HEu5SmSrpwFK6fO8wDVz9nxLCqcUMkwzOMXsmpm?=
 =?us-ascii?Q?7ARGL4NOLqK9M183aqGV2b8/lkjCXWlK3wY75HdJlhbwM6ys6juZCFvju7FL?=
 =?us-ascii?Q?7I4M586Ked0Lsfm8VJyxyMnyZQNtgPkpRy9Bdoa5gWD8DL+flmdW5MgULnzF?=
 =?us-ascii?Q?yxW3YcRz4uw71v6P0PpLntKu2djmVuXraCQ7RE1ukEYx0tWYH33PXycQkjS9?=
 =?us-ascii?Q?7IVzzV01RQyqUsKGymWIE2yXqyMEcoiXJRTxVv2mRsdb80/ZaWUrqelw279Z?=
 =?us-ascii?Q?7CVnPBRwWZuPypHUBORKjEUyJ5SE+gfc/1TIodi4LJI8n8iNM/ZXlzfzjho/?=
 =?us-ascii?Q?AUzSZ99qDmoVDmozOhlk8BQJNWnjwSqsWeJdYouHRuQaBHLzRX+PirTOwhAS?=
 =?us-ascii?Q?5hx/lEI+V2TXqh5FkveOot2u0yCGzHPVuwQscCOfIWSs6As3ntZjbmczCguH?=
 =?us-ascii?Q?LKX+GM3DwMm0dgyV81dnXuss+HG+mV4Q3ioVZiuSHVpi2FJqJ4sF6yyLMiKb?=
 =?us-ascii?Q?bY+dU7iqPI1ivzkd3UCWbmX+Vun2ED3JnsKews+PJiUkeLDgZJgux3Q0zzBp?=
 =?us-ascii?Q?/BYsk9OoNM2ErFyokJipT4SxIavyOoUSX6CsOTQ7O1W+DKMWMh7syg3YaJDQ?=
 =?us-ascii?Q?q6CzpOw3xEdUV+ZZbjJC+9rjLeCyq7vRdkVz1pTKzQB84DHs6xrxi5Mqd+cC?=
 =?us-ascii?Q?QBq86aa/7GqtGL8rgII1/oyDSQCgFkEVbXGVY71C/f1Z3Dsyquc7Eldhu4Wx?=
 =?us-ascii?Q?sgzwL2YPwnmVNGvqyL9UYmH3Qzmp2rmRzXmThv48Sy+ZKx8ytmkKPjah4iT7?=
 =?us-ascii?Q?J0fwfTCQO301JT53Kt0c6FIzVW79WFnsD3DlRlDs57dHiUvwemV7+wziF8NY?=
 =?us-ascii?Q?LaiewDImNQfacHWr6JObg7Y70ythIB8fPirxwcz7vfpTuTp2IlrpIwgU66vh?=
 =?us-ascii?Q?tse81zWn15uyl6Dmc5f6rhWtakABAO1zDr4VL8K7XzoakIFyK11ZZFJxRGU5?=
 =?us-ascii?Q?ZRYz/G2NB8bm78TAouQZ8fCH286Mi3B0KXS9u3BH/fX7R+vO+e4KBU5skpGL?=
 =?us-ascii?Q?qTM1w9daZiqEhGqWALqm4tHiYlRZXsNpBSWN+qaseGpMx0Z0bFRZPwQ74Jnb?=
 =?us-ascii?Q?V4ZJ+VcNVhj1ITkrGFQFyX6oJc/ti4nVl/G+Ncq2L9myVStidl1nhSaJF+uL?=
 =?us-ascii?Q?lt45RPWtsjHnDzsWARl5NxYo6kgEZKyim0ZYFlR3JD5jI0+PHggOLG0Osja1?=
 =?us-ascii?Q?sElifIXKEE12ju36U3FwVVfcSlYpH+qXLOx5pEQq+fwBFfmkbeypGTGV2cj8?=
 =?us-ascii?Q?j/9s05kWytiS034vLfDeOY7RFl/e5LifVRWQ6Eef6wmVR8R1BXRstO7/wPit?=
 =?us-ascii?Q?L81W5zovEFf0Dx4aZ1kyvg3kxWxLY3SZ/ijCEKwsKSDn2H4eXIBsfSAdiogb?=
 =?us-ascii?Q?8wAFTsd22zQp/aF7xd1R96txyltU+jCEC9oBgBPd5SvuCBcz0Vp7y9s05t4E?=
 =?us-ascii?Q?No2K4U7T8hbyx46E4eg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12f99950-7032-44b5-9800-08ddaa8ce8f4
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 15:13:53.8131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U7zSUUI6WA3E7fMV8+2L+r1OzTZ7utIHGfbesgTGAgMxlDB2JgYh9SrFPoB2tLxV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6671

On 13 Jun 2025, at 9:41, Peter Xu wrote:

> Only mips and loongarch implemented this API, however what it does was
> checking against stack overflow for either len or addr.  That's already=

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
>
> diff --git a/arch/loongarch/include/asm/hugetlb.h b/arch/loongarch/incl=
ude/asm/hugetlb.h
> index 4dc4b3e04225..ab68b594f889 100644
> --- a/arch/loongarch/include/asm/hugetlb.h
> +++ b/arch/loongarch/include/asm/hugetlb.h
> @@ -10,20 +10,6 @@
>
>  uint64_t pmd_to_entrylo(unsigned long pmd_val);
>
> -#define __HAVE_ARCH_PREPARE_HUGEPAGE_RANGE
> -static inline int prepare_hugepage_range(struct file *file,
> -					 unsigned long addr,
> -					 unsigned long len)
> -{
> -	unsigned long task_size =3D STACK_TOP;
> -
> -	if (len > task_size)
> -		return -ENOMEM;
> -	if (task_size - len < addr)
> -		return -EINVAL;
> -	return 0;
> -}
> -
>  #define __HAVE_ARCH_HUGE_PTE_CLEAR
>  static inline void huge_pte_clear(struct mm_struct *mm, unsigned long =
addr,
>  				  pte_t *ptep, unsigned long sz)
> diff --git a/arch/mips/include/asm/hugetlb.h b/arch/mips/include/asm/hu=
getlb.h
> index fbc71ddcf0f6..8c460ce01ffe 100644
> --- a/arch/mips/include/asm/hugetlb.h
> +++ b/arch/mips/include/asm/hugetlb.h
> @@ -11,20 +11,6 @@
>
>  #include <asm/page.h>
>
> -#define __HAVE_ARCH_PREPARE_HUGEPAGE_RANGE
> -static inline int prepare_hugepage_range(struct file *file,
> -					 unsigned long addr,
> -					 unsigned long len)
> -{
> -	unsigned long task_size =3D STACK_TOP;
> -
> -	if (len > task_size)
> -		return -ENOMEM;

arch_get_unmapped_area_topdown() has this check.

> -	if (task_size - len < addr)
> -		return -EINVAL;

For this one, arch_get_unmapped_area_topdown() instead will try to
provide a different addr if the check fails.

So this patch changes the original code behavior, right?
If yes, it is worth spelling it out in the commit log.

Otherwise, Reviewed-by: Zi Yan <ziy@nvidia.com>


Best Regards,
Yan, Zi

