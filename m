Return-Path: <kvm+bounces-49440-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DB10AD9104
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 17:20:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 044891BC3691
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 15:20:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B04EB1E1DE7;
	Fri, 13 Jun 2025 15:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Fswzhq3q"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2070.outbound.protection.outlook.com [40.107.212.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC5D2B9A9;
	Fri, 13 Jun 2025 15:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749827980; cv=fail; b=N6Hsa2XwZh9IPlCXnnnSeqAzLot4rHvnc+PchMnHR9AhTeTzq7JI0BT65a99q8VorsUa9gSUvE+EB/v6W1RAtMEeziYM2HouSd2bnVmoTENvPfWZ1egy2TnYleAn1SP7KuF4JMfCRmlTycEgkBIsVkOfxZspJQR1LKfRy5kYEvk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749827980; c=relaxed/simple;
	bh=AQJt3MlXzs0bHAfOwJ+2EBhm24uMX6Nu2plJfJd6Jjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HA/Hwk+p9POWDHK6xlfCxPYO8IGmxRPS2Zz2eAid/Q7ucq1eQfBysf/qsQz6SRKnUKy/EQiUuJt7V+EA4xWGRGAYVRAnz1Do8H/7wq5wwzA4IDAsDC7O6S/tvlNcVoP+3OgRnoUv1iBenxuvxXBbt9Q189RFCQYrJmrja307xXQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Fswzhq3q; arc=fail smtp.client-ip=40.107.212.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oLQztZ9bq6hLaO9EDq4+th7yNiOSL9QzHstz+DDrzXTAto6jd/0Dficc6KfLwG4jLXRr5M7Tuv+/7bKHEoZwMBZ5Skonr3zhXFaEkEACkkXwmnY1bvlLX3g2i6R9cHbObsmz4bEn418rwj20I3XyDLAJJmqGHpYJi8imTOR4QLovM3aU4k2o7lnhm1SB2X0mIZai5eO81j11KhuxSxfHQwwb/rQUThACtUHt4FM5SAnSbv4wHl3kfkPuB5Nc+LQBXPawvXBlWS6eaRQywrvyDq93EXlMkmskwEjMJc94CZN38/k4acAPZL/ClThwWgKouiGNTDeIrSnFaXofsZFa4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KZ1zOfNTiJSSTiqa9Aq+QnutjUU5TURa2pzrPDnJGSs=;
 b=T+EEWYY7d40IyifSUiTIYLw/dgDSoLB/OT69HoPzcisAQCpv7D0vbR4aQWnF3ll7fiRYmHAdHriCtChFphHfK7F4jn6xCkGVWcHZpaW4f6zJ3sK4yUUcUDWnB3oyW6DJTjSzzs7dMm09CaNSu6gr01CPHmS4AfF+OaES8/Zr7nPkBOGooWRUKGtbCK2ibdGEVLF2XYBheVF9AFYetGrM3kxOXWcVnCTP8VjA355cYd7cNyex3RJ2+NheXdmVWQrGdcPYFHkhqNdRgg8oP638O5Ak7s7CGKAkdasJjoL8v28pjAvTgvBl18Bcp/mAXLjftHIO7ZKGgjDXUWJlJhIJtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KZ1zOfNTiJSSTiqa9Aq+QnutjUU5TURa2pzrPDnJGSs=;
 b=Fswzhq3qukGPzBh9sZpN4Mk3mCRVPCHpXW2yzhVeiIyRQSXRd4o0rM08BFHLYt5brI6BBwq0yaFxvrld+FrocnFCzdSQSDEF/3/+8xWCK2cpdtXfKpIpEoyn8qfj03w6FAoRkiP19mbpnr4Zhih31GZnc2cTDzD+i7WNaMqUOMsvb/o9efTaemb9FpOjPKeH/zZnFy14Amb6xm/yOY6iWrjzs6nywh1O2R5N2UyTTWevrJVYStMwAW9K1CDCcDEvS55qnqqpOGL1x5kDld2dYrthJhiA60t+I3QnpVVlxBm58fGvBeRVVWs+2mAQZNWcR5F0zrMaZMZ2M+oD3eDOcg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB8272.namprd12.prod.outlook.com (2603:10b6:8:fc::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.19; Fri, 13 Jun 2025 15:19:34 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%4]) with mapi id 15.20.8792.038; Fri, 13 Jun 2025
 15:19:34 +0000
From: Zi Yan <ziy@nvidia.com>
To: Peter Xu <peterx@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Alex Mastro <amastro@fb.com>,
 David Hildenbrand <david@redhat.com>, Nico Pache <npache@redhat.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>
Subject: Re: [PATCH 3/5] mm: Rename __thp_get_unmapped_area to
 mm_get_unmapped_area_aligned
Date: Fri, 13 Jun 2025 11:19:30 -0400
X-Mailer: MailMate (2.0r6263)
Message-ID: <AC89F7C8-C6D5-46AF-BF2E-35D81A3F4928@nvidia.com>
In-Reply-To: <20250613134111.469884-4-peterx@redhat.com>
References: <20250613134111.469884-1-peterx@redhat.com>
 <20250613134111.469884-4-peterx@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN9PR03CA0492.namprd03.prod.outlook.com
 (2603:10b6:408:130::17) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB8272:EE_
X-MS-Office365-Filtering-Correlation-Id: c40ad728-8a7e-41c0-ce34-08ddaa8db3cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qFirMqJ2xJEeLRLm6CMcy2GfzV/yqnSbcn7Yz8PeaiKRjbGQtSOr+/k0S4y4?=
 =?us-ascii?Q?NgHTWwRsurq+2R0ZOgD1Guv7I0AT8gMe652X7NYliw87cnUUdGjuPk4vQPVX?=
 =?us-ascii?Q?eOGJW/TJ9qo5j8wydibxsu12VZarp69PUaABJtbTm4cn1Yp/xwVhgXFjjzrM?=
 =?us-ascii?Q?gFxJ9x25DHnCIs37bc6dFa2Qfv2l/46P/RBESGre7IdgA91opdFIeAdTYcwn?=
 =?us-ascii?Q?nSqS5D0M8lfHeu/mp6wBOFJl8eJLAWZkYi+f4dS8KU9QnfA57EM2k/5qJNPb?=
 =?us-ascii?Q?tCriQL1CckqhuqQr+A6n02SnXR1buY7tUn/6Nb0LbHhQzCpQeUvYeJh3aKbd?=
 =?us-ascii?Q?oeX9Cm2us5MYI8RC8W7IftAYh2NkG5065SPVLVaU+cWIQYjmqKuH0Ew2HyIm?=
 =?us-ascii?Q?9D05IdwnXJ48ZH9MHmiFMFflw/wUoXoHItPPTPOQWjG6zFMENfb7K/6qHpuN?=
 =?us-ascii?Q?pj1D1rhvouZ1G1XsAY6UDbVGDBatwDSQnkDm9kmF0ZLAR/P36q995LgPhl1S?=
 =?us-ascii?Q?H7s2mdWMt/1uXLH4BknuY390H3zFgv6Y2BjWD7Wad6HyzW1qhUhd5X4V/jrM?=
 =?us-ascii?Q?ghUQzCZnmchz46GR+sNJFkhDRBgJMtCduxbCz97P4VoWyg4YjT+kmQjUkJcD?=
 =?us-ascii?Q?zgt6tF+tfaXTx2ogr07lwYAlkaS+uDd7bFIHqvdOYdw+zMdQ7tc2GfGCvta5?=
 =?us-ascii?Q?ROnX3kuLxjb+hZ+hq9UQJlBWjuRIIVmvrGC9Ve8a3Egulaiz09LBac951tKg?=
 =?us-ascii?Q?OEfcgec5wajifPu+junY8BtpUsmEdhgvn8Pk35FvkfWfcFcJcUr/UMNJgUGp?=
 =?us-ascii?Q?d77joHf18oIfw0k05NFkhrDCIldKqvNRw4HxzN+6Yc8/riRVCtxhkFwQum5g?=
 =?us-ascii?Q?c7hONa5TiE8Waqbv9Lsj0ssnSw2ubCf6zutBzuUvx3h+4VYiA5CdRvh4Segr?=
 =?us-ascii?Q?gtTrMoGsTouVhoYe7bQzujFOrMQrpoTlkMY35v0KLBgKU7+oDtMKvLFYchWl?=
 =?us-ascii?Q?NHvAkjm9xZi1aw5YVO8VATWyf8fXoqh2lbN/oVqFqUN2kDuJmcFdsZxL2zbT?=
 =?us-ascii?Q?ElnhCmmc86PoHA+Y65fsqna3Vo0C5NKjgU9Q6gx3a6njGrlx5GL88vuszVhr?=
 =?us-ascii?Q?jIboin6hzP2AYPsssm54mwoCcdZVB3cyE8AA5PDvIO2EnvstDuEtOAqoTy9i?=
 =?us-ascii?Q?I2mhqTsnRWV8DkPOYF/tC34SdkfglhGInobuHgbNmW+HlBhwhObuyZjytdK9?=
 =?us-ascii?Q?PWbpYlHUeWrtpjTQB0prgscvypHeFdNPXIKliy1GL9QbHbBG2nlKLqM4JALb?=
 =?us-ascii?Q?LATawjh+NTqUIa7nfzX3mlK8+pK2ksRidPjjbF0O1173MSxmNnNaz5nR2Ow5?=
 =?us-ascii?Q?QJxXKtAoM0uD6CDRK4RtvuTSkGE8M/ZAcejWD9GjsnYrWM0944+R0TziyQbZ?=
 =?us-ascii?Q?gstChxg9psc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sPQkOVd9vQNZz14igch13d43PSsf4ed06N2tsOMw1LKG/mfpUxonNLb9sCUv?=
 =?us-ascii?Q?SWj+I41c5niMZsYVC5TSh92nGN0RCevT8FmKBVB16p5bDh6TyI7t5y0qDQ/y?=
 =?us-ascii?Q?56kOsV4TLfdJtjQlFWNxUC7iJM3+9pBJ6M1OQFvlbsbH1zSS5+qcJm0mAM8G?=
 =?us-ascii?Q?hjGoAErvkW57TOhoaTAqexVgI4a4eRwI2G+tDzB5s8EUtcH20+JjT3IJ164R?=
 =?us-ascii?Q?lyiZKsHy5QLyDdJJPHNkebR3krssXFPaI+6Hx059JIAz5l5Oxef0rJJVgKyc?=
 =?us-ascii?Q?4RWHgk+HpfeeLT0gXQDVyCQnb3C4xyawNqLSn19t8a1gxoT60KJu2KDLgR38?=
 =?us-ascii?Q?CxHKMskNaJ6rTiv2W4eJo19iREy0l25JGiUUP8tiPgR6wzRZUyf6VpiuRx3y?=
 =?us-ascii?Q?/toINe8lF4i3nRnicndS0iVYywWld+DY73h6bVAJVjL8iUApaIOSwglb32LQ?=
 =?us-ascii?Q?0pU/yWr/xLgJFhHsnd+UG7uoB3mfXdQTrOmGlGtXmDP3VIAkG7QwaN3ds8EJ?=
 =?us-ascii?Q?Q3WrDuJtc9gYSQ+HttRnvMcJjD38/jI4SuMIv3EMAX7MBb2oLLxT7+nig4y1?=
 =?us-ascii?Q?Tx5/FA4NP8BtrB9WJV/H4nJYACr6y52DI9DsaMQyatnNhfnQcmzvX+zKPRAF?=
 =?us-ascii?Q?H0lHLHMjNI/8oRnFLAIA/k15WMlFHd1uo1OSlRJrnfkX1leObzHrsbmGpwml?=
 =?us-ascii?Q?+pCbw+JfMWvUvj4CM6AlA+NtRyCkKDxT87lFOrtKgva9U1vJMRmvmCrOKTHs?=
 =?us-ascii?Q?Yu3M5Lu40Q63gdavd17/ins+igWPzu+iZqqBRgSOjL6ThnlAoVXMcRdIj6G4?=
 =?us-ascii?Q?prGpFRKMReGYUPoKi8ntq4IIBYJOuNuy8l6aob7vHyUI8X571BZAz+WnF9ka?=
 =?us-ascii?Q?tuiDd94E9vRkuQym1Nrzt1LzsHNUCuxs8kjJo4woxfQ3UXr8Tk/dkFZKoIGQ?=
 =?us-ascii?Q?3u24HE959Z7TCAnNuB9nq4fpKDrbhzQOqy3i7oRnjFsxKh4tw+k5VB9Jd2gV?=
 =?us-ascii?Q?yOy+igw4eg1wosbfDzo6msM58bFF08PKrmQCWMcWqJgeCl1izhTVhgHBTxyf?=
 =?us-ascii?Q?KDrvxHznR6IcU7KBZgm+l3sxRuKC33YgLLelrZwXjzYrQSFocJrFUCeKUhlI?=
 =?us-ascii?Q?kAzbR5YHdq2doMhzNESs+WG8Z/iQ2KkoZFGA9Ro9EZuNWWxpT5NETQD57ZcD?=
 =?us-ascii?Q?pytZlFJuEAEIYhpOGYmG2cb6IZieHqsT+mj/r6lz0jHmnV6eiqzNeIB1uHty?=
 =?us-ascii?Q?ExsjwYqgNJXydqxtIOgbYMNPMZLtl0lmQg4UIc8roDx+RhOfkC0U2V8DOD87?=
 =?us-ascii?Q?o916x93pLgOps5qh2svXSPHR34LxUfQzmLsJrjdmbq/F62mmJtpzyMLp9Veq?=
 =?us-ascii?Q?YO50mby8ru9oiuw7KMO5eOnHEeN/xjitveHPBZ5za/FFhjliNg5nXCE6VwTY?=
 =?us-ascii?Q?Cf03Rsr2427NaoEEYZ8hhkKyFjN7wYSOef2gwoE1IsuTBcBE75clrngrNBf5?=
 =?us-ascii?Q?SYAM0nd9PkY6Ufh5uFuH7tJKmCVHzuF5xZD9LVtFva8mHsLV4zn5Hu3ZQ8hI?=
 =?us-ascii?Q?0TK7nDE7Sc4L2a7z+Kt65POIp3WqsF9uk8M77eI4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c40ad728-8a7e-41c0-ce34-08ddaa8db3cb
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 15:19:34.1077
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZhhbpQ8bOkz2+0abAl4eVVjp+HMS+nX+4J7ETzp8H0LPZUW8v/VJjQM/tGwdoN+W
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8272

On 13 Jun 2025, at 9:41, Peter Xu wrote:

> This function is pretty handy for any type of VMA to provide a size-ali=
gned
> VMA address when mmap().  Rename the function and export it.
>
> About the rename:
>
>   - Dropping "THP" because it doesn't really have much to do with THP
>     internally.
>
>   - The suffix "_aligned" imply it is a helper to generate aligned virt=
ual
>     address based on what is specified (which can be not PMD_SIZE).
>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  include/linux/huge_mm.h | 14 +++++++++++++-
>  mm/huge_memory.c        |  6 ++++--
>  2 files changed, 17 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 2f190c90192d..706488d92bb6 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -339,7 +339,10 @@ unsigned long thp_get_unmapped_area(struct file *f=
ilp, unsigned long addr,
>  unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigne=
d long addr,
>  		unsigned long len, unsigned long pgoff, unsigned long flags,
>  		vm_flags_t vm_flags);
> -
> +unsigned long mm_get_unmapped_area_aligned(struct file *filp,
> +		unsigned long addr, unsigned long len,
> +		loff_t off, unsigned long flags, unsigned long size,
> +		vm_flags_t vm_flags);
>  bool can_split_folio(struct folio *folio, int caller_pins, int *pextra=
_pins);
>  int split_huge_page_to_list_to_order(struct page *page, struct list_he=
ad *list,
>  		unsigned int new_order);
> @@ -543,6 +546,15 @@ thp_get_unmapped_area_vmflags(struct file *filp, u=
nsigned long addr,
>  	return 0;
>  }
>
> +static inline unsigned long
> +mm_get_unmapped_area_aligned(struct file *filp,
> +			     unsigned long addr, unsigned long len,
> +			     loff_t off, unsigned long flags, unsigned long size,
> +			     vm_flags_t vm_flags)
> +{
> +	return 0;
> +}
> +
>  static inline bool
>  can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins=
)
>  {
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 4734de1dc0ae..52f13a70562f 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1088,7 +1088,7 @@ static inline bool is_transparent_hugepage(const =
struct folio *folio)
>  		folio_test_large_rmappable(folio);
>  }
>
> -static unsigned long __thp_get_unmapped_area(struct file *filp,
> +unsigned long mm_get_unmapped_area_aligned(struct file *filp,
>  		unsigned long addr, unsigned long len,
>  		loff_t off, unsigned long flags, unsigned long size,

Since you added aligned suffix, renaming size to alignment might
help improve readability.

Otherwise, Reviewed-by: Zi Yan <ziy@nvidia.com>


Best Regards,
Yan, Zi

