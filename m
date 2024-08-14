Return-Path: <kvm+bounces-24133-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9944E951B06
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 14:40:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5EC9B281B9F
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 12:40:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43DB31B012B;
	Wed, 14 Aug 2024 12:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mERaRwis"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2083.outbound.protection.outlook.com [40.107.101.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FC41E498;
	Wed, 14 Aug 2024 12:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723639249; cv=fail; b=alz4wTAQuPsCaJyoCHwR2byIoZrf3Zp9kAlYrhvuCrh4U7u36D4Aq4IQnk+3gCw+/KRS+F3F6pq0J5Ge7PH/4/CuIxI6gDZfXm5Yn1HGQUriAknKyPBtsTRbo48c0zRd4AEPUmoDz95QSE939QMyVF1eCX5P1CkQESk7YgVx92A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723639249; c=relaxed/simple;
	bh=en0+UAlMmP0tBN2ZVHE2alpC1k8QisLonvHNc//Dy7s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=AYxLnuBzZXIRlrNpucl34Dfl8NqgPoOs5Oz3oDYq/7w+BgFnr2CpB+2mh3lVELAFKSYZ/OEKVDj++9Te6gq9rraB4Ht4WZwV+xj6I2vvd+VhBdXiUckq19UlA7eQKs96baoICFMNCjYC0MEplEMIozf5M2T7/aEsjaZLjvmYlHg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mERaRwis; arc=fail smtp.client-ip=40.107.101.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F0HhYDh4Mss/4eBbXT0A7Nrqpj+nGoKc9NVGvyJHkBiAWhzyJmt93T5ipinX28MzwYnpNtkVCXIanV+xoWz0vJuj/MT4Mt6U0PakWz3eycEGi3yAJpOjk5e7hhIKIw0hb/UGStRsRzgCzFfGp/V8+bBMj/HiMMtlkx8VnmbVcVOF6IegQV4j97QTx3rQQncsmUd5U8DHPmZeVNBj41B7enXF9bY9inpnDWN8vN7bOFtfSMGsbak9IkoBEIBeJ2S6030HSh+sO1xc9tVirrrs4H7qWMCuXHiFoOSvdfIArralcejdtMABNk83ICoNG94S6RIR6Cu+9zRK9uqc2fW+eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b00+kxEp4AYLJT3bjfT+dzLgpjcj6suB4PfgU+iyD4M=;
 b=sSGOrntGRJK3bNUSOPYfcg1HNr169FBbwkVOebV+9se9DwxNeFCT0hMNnSrZLay6cR5LeaYEOzQ0OJQCTF8ZgXYyQqVI9ghzKcK1YHx4H50/LzXxZ9vBNX9tKcOv8jOZpKHm8ZXilyFpbUFPBggfgCYLuRQ1/Tpmpr5lcy2FI8aORVOBkZCcrxxhme2G7KBCurB1viRI7+Dxp5HPtIz0chzvPqq4tyqMkJndB3KWa0/YdGCHKKi4zfLKL+FrbxlpEsnNhLqILT/i4FRqj1pYBQsCTkdnkyCKv4OBxww1U0v4D1mdvQZGI8iT4TBf4+5ul+KCeWTAx8VTMMiBxEIr2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b00+kxEp4AYLJT3bjfT+dzLgpjcj6suB4PfgU+iyD4M=;
 b=mERaRwisPrnL6jQLCtnCvjQJ49V8gJQg1F5RYIDSIJPmgGOP2kVM5gOm5OEaK+QZC65iIynnhiPGQHhVU7RHJ8fYYl+GxE9LS8V7FH0Lq5/FuL460JAyuWUv68wIovU6e29DaCM8Ji9pzL+YMPWmMweJ9GL0rMQx5YfNc5ZivpR5uSMZQ03djmJpQ3iB04CZd5v0v0lTu9lraa1x2O3pBwmoHVMNNVhgETmletjY0qQPQxaoQTg4InNO/kVCuuZjmWGivou2w7eJOn561Wjm+Ft0L6FK9o7IEJ3JD781Z7gFbfN0I7RKa2ba+XQEb8GY5ZmV5zsBkSHVncQvDwp3rg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB7767.namprd12.prod.outlook.com (2603:10b6:8:100::16)
 by PH7PR12MB7332.namprd12.prod.outlook.com (2603:10b6:510:20f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.22; Wed, 14 Aug
 2024 12:40:42 +0000
Received: from DM4PR12MB7767.namprd12.prod.outlook.com
 ([fe80::55c8:54a0:23b5:3e52]) by DM4PR12MB7767.namprd12.prod.outlook.com
 ([fe80::55c8:54a0:23b5:3e52%3]) with mapi id 15.20.7849.021; Wed, 14 Aug 2024
 12:40:42 +0000
Date: Wed, 14 Aug 2024 09:40:41 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Peter Xu <peterx@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
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
	David Hildenbrand <david@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH 04/19] mm: Allow THP orders for PFNMAPs
Message-ID: <20240814124041.GE2032816@nvidia.com>
References: <20240809160909.1023470-1-peterx@redhat.com>
 <20240809160909.1023470-5-peterx@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240809160909.1023470-5-peterx@redhat.com>
X-ClientProxiedBy: MN0P222CA0027.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:531::35) To DM4PR12MB7767.namprd12.prod.outlook.com
 (2603:10b6:8:100::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB7767:EE_|PH7PR12MB7332:EE_
X-MS-Office365-Filtering-Correlation-Id: 32aa35af-c6d8-442f-7afe-08dcbc5e4f7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vfJmJozffoNZmsb1xB60cWIE3bzx1ryxuIhXUXIJQzps84W2Kgq4jhXmsXFI?=
 =?us-ascii?Q?AwXONWvs3oaaRPwQ6DTA9YEbmOEo2G79MhoBAl33mgg40424QlX//E4gqp9K?=
 =?us-ascii?Q?vGuC5zK560xD/k7eUOj2E00MfdzYYG7KAjOzcNChKgTcTFm9MdKMnRsHKv5d?=
 =?us-ascii?Q?3wX84MdmZ9ck3b9JsH36P/9tDbniibp598wp1+Z941mRAO5T5CjLr0edttor?=
 =?us-ascii?Q?b0glnfvVwwdjJWq5H4ACd5DknG4TqY2NqLWDYfZ9VBM8JhKQFM14ccwqnfQY?=
 =?us-ascii?Q?5V/c6gVdFNchuaJa56ft17QzV6/pjh+9OM3QV/4scm6EbeDrPo+nHUBpTOrU?=
 =?us-ascii?Q?z4KWjUrELwuiu1nbrgho3zBn7s//HgRKbhKHNiWrnmQlqlxRwHxOGVZXfzv7?=
 =?us-ascii?Q?3+MT/xVrdcyxZTna6j4VmTrqbITsngJPHVV7HHv17dFEPtR0G+8lum8KIfSz?=
 =?us-ascii?Q?zdKBAU/obSd71UtH8Ff4yyZ3dkcYwK9nF+uLE4yg8eaelPp0zwKCT3VHzM5K?=
 =?us-ascii?Q?ZEFW1JhpCNe3o/A+8tdm9yPJCa3XQNuQm1fOekyNSiwqE8uoSkjlYsuC8YGz?=
 =?us-ascii?Q?9NlN9fzZp/uaWBl8yc7NvUIT+2Zyp4Q0YfcyreqsM6xUGWwTn0XawT+jGXYX?=
 =?us-ascii?Q?2GV9rmnSUzYa5zU0TzTnB/sSuDFNliQ8OHmVSweh/qMh56yqbZhHS6cWWBGF?=
 =?us-ascii?Q?GHJQOONhtmL7R1df4KEFAwJkhY7Ypls/faGvRd9ISaAbyvorzZIhsaxSAAgo?=
 =?us-ascii?Q?SUVOnVfNG4o1fQxiO4NDeo522Ycw9tTim27iw7ndC6hkPVDC1S5LJzsxdurr?=
 =?us-ascii?Q?l+qNEa+IN4X4v5a9+aL6RUKKk+gEQmWKH4vF5kGjZr8gTZOY4pWGZwkPsTUS?=
 =?us-ascii?Q?Ag5cJ5L5wbd49rYDVn4XLa1rjqCJXT/tDUX2P9JZanDe1DfqrB/ApUjww7NK?=
 =?us-ascii?Q?sP/jSJHMnINkJ8ur78p1faukXMbt0nUksHA7EdoCCOLZllErw8dk/G7G+XUb?=
 =?us-ascii?Q?6R+SABB2vKesPB+OjZceiyYBgfcwZxRD95asAva2aNAwk1Pa4VpS24Zm/J/N?=
 =?us-ascii?Q?Lv02wpIxP7Ukw8SqIWSzpqh8N4AtYE34/qWUuqcxtuHEc6ViwzPlcm4HVvvh?=
 =?us-ascii?Q?TPRAZAV1Mw2NCb4gKNqTcCNLaT2TRR8hxudidvampb6crETIGgGJjGDtE7VM?=
 =?us-ascii?Q?RgYaFHQP8V20q5EJEW/kvzs+34REHFTEB6iy/5DdC1cDYA5fUKALIdVH7Owt?=
 =?us-ascii?Q?07wxo7GyCJcr6XPR8vdw0V7hcOfTxMEDpaySfu3sQu+9GZkpMgoj0BgXhbbB?=
 =?us-ascii?Q?IGcBjJvyb0FNW1QdNlf8RVftQ23lpXT4k/edUCzf5Vyd2g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB7767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8sk3O21+9WZXsHp1HLnfin3ZHJB4qGNhiAaPcpZJ6fwJWSKDJJvetred7vtX?=
 =?us-ascii?Q?svo4TOAhbAZj10JhyhH/TK7QwSwpsnKlqS1PysE0PB2aAeyZGXkpygzHyDow?=
 =?us-ascii?Q?54RXZkZOj0HLBQrw5vN8d7PWupk2rIPxJAV0uLnhggGaf7vs4iMByMh+Fl/o?=
 =?us-ascii?Q?qw+rhPpH3COxVcRzjepWmv0mLkGyxtgNglJZJKgoI/nK00FF+AAryC6MRIOf?=
 =?us-ascii?Q?bFATjDUUS/RaQ37SBZ7LcwQqOP2tKtgChWxgxdzNXmJhU5FejDtDZs0CL5Tn?=
 =?us-ascii?Q?WTBGyXb1QLAoXdQU55UjlrHkSCH1+V5pziHo22m2a4CKmokIdDXwoype36Lg?=
 =?us-ascii?Q?liiCWbFSkLT+pLQyGzTVzx84jmH8H6qMrZtWK7i3+OzAVLGalLASdexnKYWB?=
 =?us-ascii?Q?k3fUX8PT4YzVs38GQwTOBYBRNhBZS3Kb/yMKWC/HscL2loj20sdf04GZj+Yr?=
 =?us-ascii?Q?MqiJ1gBF5wmfM2HwFT8D7OUbr4GPJj5O1JjL6jCIvP8g3jepo7YXJwdDwPnj?=
 =?us-ascii?Q?Rk/w1pXJAGnlzCwMEhlmEf+RKx8lUPg/M4J68oNuEoRjk0uO++0/kT75Fie1?=
 =?us-ascii?Q?THBNc0raQ9a/zCQO1nsdu3QiIbkp+xmnQqwxsMwwdeKDCpqiz7W1RXVN45h6?=
 =?us-ascii?Q?/FFDlASXqYOwqpqu45gleQVhfAQLEn5AHX5oAaMONdR+i3a94tap33U13gzz?=
 =?us-ascii?Q?4iMhRTAKCUozYWjqrfyu16xmwsbt/WwFkz0AWxjxOcm2nqd1qkD6aVcW+Bpj?=
 =?us-ascii?Q?tqsPfvMcbJa2d0bDm96ArN9zwaRVjb9nyXm0VNNrQX/IXCZri1pGxjPOs0uH?=
 =?us-ascii?Q?wGQVYVwXEzZcTseQMydWNWj7I6riRVIOAcTC495sy+XMSkxYn8pliBQGZuqK?=
 =?us-ascii?Q?/UGeiEhPFRWzO8yMrU/KVjtGQZ/ah+iTno8fI0vJ3MRRP7+hDn5HfseDz7/Q?=
 =?us-ascii?Q?9c/t8NrjAMGeA7r2ymnvOeYo+Cc0R9PcufUYy/yZ6RjFIoQkaBRhXRAHcygg?=
 =?us-ascii?Q?yV2tPXBpIIY7huBl2YsA3HPrw5yLK9uNYAtNu9+edmfHjAiW7C6Qsf15+Qsc?=
 =?us-ascii?Q?6YUF7BmyoWGg4tfk8LIZIz+11IAGTfT1GlIYx0LQgCQHhB7td5szPD2YfG9n?=
 =?us-ascii?Q?i9c1cTAvNrZejfOenzNsD9Q9uOkFG8WgZWWEe3nCcD/4eaCf5OhJP7TIQEIY?=
 =?us-ascii?Q?RafLro1/TleUoH17cb33cbGvIQgd2/cBjcDJ46u4LuW5UThR24oM4cs9nk93?=
 =?us-ascii?Q?ynygeUhlTiWdRZkCdcm4BNGotdKrt6zKZcgiv0s7sjh9dVGKjNGVJUO2JoK3?=
 =?us-ascii?Q?/13tlA29bYZjDC0SBV9NwXB9Fdajoe9zaLkF4L89/yY0R7DwR/htwYHSD4Qw?=
 =?us-ascii?Q?Dl7oWqlGbuV9pi0mwaemayR9n2D8DKjCPYDhrLdYlJw6NPoPNhSL7zZqV0wA?=
 =?us-ascii?Q?raPUca7iJOQdcJsSl85cuPMm9E01crUTWJTgRYUAdwLuz5T2nBzxyXMuJaD7?=
 =?us-ascii?Q?PeGJBfBiaWYVnwTQZ+H5uSNPPBdSMDylOu1JhWhPCZbxRKKfC+PxmdHUCCrd?=
 =?us-ascii?Q?7g4tGuRZh4x/f/lI142lzmeWmRqaTntGjU+rudyb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32aa35af-c6d8-442f-7afe-08dcbc5e4f7b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB7767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2024 12:40:42.8022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qgcmuwrs9PHYY1/7OGlor+RIA1g+it3/B8gMYSGtQcNV+vNukvlaKW6InD62MsSj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7332

On Fri, Aug 09, 2024 at 12:08:54PM -0400, Peter Xu wrote:
> This enables PFNMAPs to be mapped at either pmd/pud layers.  Generalize the
> dax case into vma_is_special_huge() so as to cover both.  Meanwhile, rename
> the macro to THP_ORDERS_ALL_SPECIAL.
> 
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Gavin Shan <gshan@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  include/linux/huge_mm.h | 6 +++---
>  mm/huge_memory.c        | 4 ++--
>  2 files changed, 5 insertions(+), 5 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

