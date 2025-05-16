Return-Path: <kvm+bounces-46879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CDE1BABA4FB
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 23:08:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AEC4B3B5015
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 21:08:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD3F8280016;
	Fri, 16 May 2025 21:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cEk/7aOd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2064.outbound.protection.outlook.com [40.107.223.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C13118C937;
	Fri, 16 May 2025 21:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747429699; cv=fail; b=U6HJhahkaglcbmsRHXO1Z+tCJbPOpZvUaHsWnGDGAIl4aethL0XRcppWGey0mSIHxlNqMFMNZh1EE52QAaNlbyte2tLKeeieXU6b8gs7MO5SPzKssBuw8z4J1LVMhMmOmuuNEw6BTy4wjEft++MLaMbdAkvlJzoKjSXHeqoL91Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747429699; c=relaxed/simple;
	bh=+iUw407Mf/ZSvnXSvmc69p5sKKrdwGg0OuAUXLYXD7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=d6oUWjVA0/oTvXstKX05i0rMOdOl2p7JXqptZ+NgcyDcDdiNMP8psGZ37utcstdNNiumLOk1mzfIwPvaEIQc1I/YLxgRcgcYvSTpLMa7G7bHsbvLGM5GqicBYqb6YLYQyoZMnD/FP1fBSotHMeSuKmgKaomRhvjkNlpIZAMEw8k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cEk/7aOd; arc=fail smtp.client-ip=40.107.223.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F+X4AmnAUO7uIRd+FMsWYDoqDotx8IVqk0PUBIrRF7bi0pUlkp6UDB2g+zxKUarXnYT5A87Mf4+Sx8Mu/DRVVJVrOV3eqfKInOs0PMRlkxEgp4Q6iVRccOFXt0cKZWfQL9wL/qCjj0tAyyt9RBRR1Izn63NNhEV9qPUFsWEw4Iu1JqICvpNKTCWiYJ1fYgNVRGBEuicYcYkKjlUhWZQUDRYjGRFidiKLMT9zdq0SVE8IoDa6aRFVve8S/8WSlnLfBCvB0v+KH8NsupanEqvpfk7DwLmr8t5VXWa8vJ3prDXh2cfw7eP7UIFYG4zSbCOJJ40ppNsUVLfs191DDGDL7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dBsPHUCbeX4N4xN+J6t6ViZvShX6Lewhw7VoKMfWNfg=;
 b=j69sE/QSMNRZyehBENDNDmwgy9E0fwJ5bqAYJjr2sh88g8S5zy31YjLheJ8dgbjPEthCiIexZTXguvyYd/U6RYCMPv5hudyp9WfeQ/vDzSMFh/aRPnjtjWa0zWoyJPtojMhZnDReBw3rz/rve3jB/mgC1PhooRh85wsgL122ZpXebRWKLYM7/UhQg0wxDJi6jDOlJaSP7mtYIEMiceVwCN9YigVz4jUFCeHQtAfe8FZXnt7X77YSz5WKTmTXfr030/zwZZWPy2mcEq4Oi2nX76uLxaeEiObHMTmCeQ47iUqIz5q4MTk3Gq7nk3ZEwQJ+g5arVHESQuIA5Q0UUB1Ltw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dBsPHUCbeX4N4xN+J6t6ViZvShX6Lewhw7VoKMfWNfg=;
 b=cEk/7aOdUj3XJGODMoIk4k/gDYTqW/CKXTm+MvlGlNUW1T8itkgbEmfBbAZqWZe6gCyIi6M84CpCDzcUu7BEL1/L9zbGDtKO4bSqyBVUJHkQ7zGjRpNbbM7i0GPDUB4YZOy9D0NhMhfW+gw2n2WnfGgx4mWOP7zugr4aKVIIXBs5Sc+AZwKUyzuB1xxvVAJjlgHokp/SouKg7sg+o/KPa0jKnfDLirvjAP4MUZifeBakUPlzpzNLjxPdJlZNhDComzgwVkjpXLxBjI6H0lA9+ljg2I/w9/fm1aOdxRJsEKMVphwmMFHmthmcHMJCuB8ZNFybkbBwaUbGmXmtkzjeLA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DM6PR12MB4369.namprd12.prod.outlook.com (2603:10b6:5:2a1::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8722.31; Fri, 16 May 2025 21:08:13 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.8722.031; Fri, 16 May 2025
 21:08:13 +0000
From: Zi Yan <ziy@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
 kvm@vger.kernel.org, linux-mm@kvack.org,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
 Matthew Wilcox <willy@infradead.org>,
 Sebastian Mitterle <smitterl@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH v1 1/3] s390/uv: don't return 0 from make_hva_secure() if
 the operation was not successful
Date: Fri, 16 May 2025 17:08:10 -0400
X-Mailer: MailMate (2.0r6255)
Message-ID: <60DDE99E-E09D-4BD4-AC58-569186E45660@nvidia.com>
In-Reply-To: <20250516123946.1648026-2-david@redhat.com>
References: <20250516123946.1648026-1-david@redhat.com>
 <20250516123946.1648026-2-david@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN9PR03CA0709.namprd03.prod.outlook.com
 (2603:10b6:408:ef::24) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DM6PR12MB4369:EE_
X-MS-Office365-Filtering-Correlation-Id: f3e02449-6307-4374-7022-08dd94bdc521
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?17lRT6IcUKwTRFUQj2zFnEyaT0VNnvVW0u4XYtl5lI5aYzM8onxYkf6R5WBc?=
 =?us-ascii?Q?yARU3+uOjSpkImK9WCugDpwXVvz1Flevm6DaFcCYt8y0bMa8j3D2SOry6Ytb?=
 =?us-ascii?Q?kpggS3AqviC6I8qu2MN0UEKI9CN/YDY8oRxCF9iouA2Ye+wHIjWrCwVQ9OL/?=
 =?us-ascii?Q?qlBuF3aaaW9/dXrh4/lEKVX0mvJinOvUX75mUGehegJNCniGWzufWbglTyUs?=
 =?us-ascii?Q?4t8RHPF51rgotSxEwU1aJ7obQewz9JtwUfgRD9i4yEMWeO1X2Vs78fWGHbYH?=
 =?us-ascii?Q?oxpSWlDRVoa3FygnobwtbwJCi6OpLxBIDYgoHgJtMltOyH542U9q6xWjM2L/?=
 =?us-ascii?Q?7tEadDcf+gAlK5x5NHcjxR8UgbfnCJrrLygDqxM3rdTuB46g/5uh2tDrZY3D?=
 =?us-ascii?Q?y23YKOqIJM8gShBQHaSsx/83VxVvmTCZWu4Y1C8aKUVhYWrIHVtSKG6TihM3?=
 =?us-ascii?Q?9+jutC07BowBm2fXwRgpOOx8qggvzc2VGownuYWvKcslQUDPGmNy0Dudd065?=
 =?us-ascii?Q?3vKHBMM8mCu7jDPxyR2h6fyzz5KE6vsw1pzvAicTDWp/trojPRnD5hPPMDHI?=
 =?us-ascii?Q?Liq7aBaJky8hYuzWYuAZ6y3NZ33DTjGAHutHiehSQJg7F1tmXhxEDa+4JKkA?=
 =?us-ascii?Q?qUk0/Q9lMmjLRHVphbJKqsGWFHBnpXgKfflfImJCWVo2Hqio/atWkgzwshRw?=
 =?us-ascii?Q?Qs8/xHqxFfZx900OyDomQN+cg0k9jx52itkKqwdDXLZUnBLKkgaL5uhYkL6d?=
 =?us-ascii?Q?jzv1GcfGHIpjUdvlspigRK/az2349ddvvty/mz9icQZVbMieF7VbHAwTMnKD?=
 =?us-ascii?Q?UFtVNRVLZnGAXbpmnyPWegfHMvPXFW7Hd4XNTSKxtyuw7QtYRR55V/fM0Vyb?=
 =?us-ascii?Q?L7bfDIvCZ0Rl245KvasQ35W1G5wkwwTn0FEvjfVaUFFaywaFcQQU+QtFAHew?=
 =?us-ascii?Q?iCbkkTASeW5EI+lWDKSbFjSP3CzOaERb6qRddL3KmvscdOavlqdzxoxbsSqa?=
 =?us-ascii?Q?GYGw/rEx6alcf+/FJ9nesYjptB1P9WFY4QZj3uQEsvapOpEvpbrrnl9t2AeN?=
 =?us-ascii?Q?W9DZRLxjoMLdPzcrIuwqDpQJg0EbTjjLpXRDkUWx3WhROnll6rvTtQNzpS/L?=
 =?us-ascii?Q?kdlkepfoW+A6PCtgl/8Qr456mhwNsgX7RSza3rusMRPuCzl60EW9GTVguXPq?=
 =?us-ascii?Q?T+wj52fuQITUuh4IElHjA8jDNLGHH4wWI90QDyIdJ3af5ybvyCTfA9KaCiVi?=
 =?us-ascii?Q?bDkd396RhLLFglqIlXNJ2hghyhdcv/vL5LwP2/NKOboLqSOFZYaYis9maPGC?=
 =?us-ascii?Q?A31faZcelfwW4Cc4LuxSFYSLPqsecTWSknMjeFLXPggwiwnNn/zLSG22Xsih?=
 =?us-ascii?Q?dtIdmu1slE6eIWWX7eG31mE8hFc5XKK/M9hrKij0AZGZIbLrs3CXrMSfJ+FG?=
 =?us-ascii?Q?unKegN+RsLE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9q6K1okCQr1JsiDu5DYir5Fy7IZjdSxVHuKByZHvKFd5FLPGUxAaSG+wEAm7?=
 =?us-ascii?Q?PncoeGM7GZsv53gn730R0nIHLhbxWEKLEk9zLU99OSAxQdDbM6sUqNlltEpz?=
 =?us-ascii?Q?LntRZbdtT3k4vVc4fXWKMtTG8fr/aSBPquXXzWj2VivX2/2F6YGqnBLYK0x1?=
 =?us-ascii?Q?PV1viyPK7QVw24/ohvItsL8n4EATseZfsmWgyRx0As66+ze0AGVlclp+qbvN?=
 =?us-ascii?Q?w7qVZoJShHRXLWE+wa+uBGRkJ+IfqjcqguysYX0IwydA3i4rAeU2CmgBn2iw?=
 =?us-ascii?Q?v7RHOGxfW34ZvgSzhhdc881zjW6cyICpLOH/oPuRYh4HuP4YfNx1wtPqWrBH?=
 =?us-ascii?Q?SdYE9/5USJlkEu677x2DY/DBHB0owDemM/SHWlRbqK6nlGXM5fviGqxTAYDy?=
 =?us-ascii?Q?YfUHUSNErx/uue0WUf7auO/Ild4/o+IEM3E3Ba2ZY/tqiruZpkHcijWKs4Be?=
 =?us-ascii?Q?xwfWXV7ESeHKNZd5PACaQEU7d4jOq5LcuWRK3hJpBGsiQVzjrwahQDy0QQJD?=
 =?us-ascii?Q?mZPl6lLkvT3HEHAusAr1MaBqF55c16pvYyxusTkPM8G5/tBg/OTxH+ZXB1u8?=
 =?us-ascii?Q?De8GHP0s8+aVa6M/MYv3h/PfJa2RJi9giykpi4Ih91IgFB1KfjphRwTmTHlj?=
 =?us-ascii?Q?JTP7gyevOoIPe8rakV2G02CvfJtzPQl4ndN8ACGPey9gZH5dEAgC6vuqFRHN?=
 =?us-ascii?Q?2/ZbnW3fZObBJBkW6UEKXd/24kblMZHThCdI5bRgb+KxGx8H/6V4LZuGWU/x?=
 =?us-ascii?Q?9Iq0fZzV3SHy2kdfLxTqdD8OGvH3h4Sru/oefOy6xiC+m7g38c44hrESrNGE?=
 =?us-ascii?Q?AYYViI4zIGmK2goH4N9PQ8Iz5w7ma4qrm+gRw9wJXvqWyLY0NQ4DDVyTevoW?=
 =?us-ascii?Q?c9ug1kwfI21iLR+QwUodXE8/WA8bXOINnOd4cryvdH7IhOy9gNjY/iyto7AX?=
 =?us-ascii?Q?KFd3Tga5MuuEQIszWfk8Zqn4ZCEpbbb+CZ4UuVT++V35r9gdDUhgugfBohXh?=
 =?us-ascii?Q?2g1t0ahf41fBYvYFsgz8YAWkA6vZaiFdv2RxEUvHCJU5fOu1EP/hQ0izLHzG?=
 =?us-ascii?Q?657ey8xlVMsaMI6oJH9LtiST83HPLp0KIKBa3xt73uIQZ0kbqHIc/gs8SRka?=
 =?us-ascii?Q?oZjaTyKNGAH2moM4nt9OVcwVcnRZ4KixUVakddQCPc8HSUC+U4C4B6h8PmmL?=
 =?us-ascii?Q?o5enkjZ/o3bXzydyni07/kgZefWcQNHEINvAviZXFOFre1wV13VqvhfnD0FU?=
 =?us-ascii?Q?69onMSn2oXrbBQzi54wT+L6iQEGE9Ns5XlYlE8lYlpF2imXC83cGkckRfxkp?=
 =?us-ascii?Q?dOhFNS7ny7ye7UjqQsZvvO3FKhqvsHoNjFoZFBBZ4GbB625uNkC2ucacEWdE?=
 =?us-ascii?Q?oK5VkMhVYqzYb9IgRLxcNrdUewBs3T8zYtfh2DBf8Dis4nETEhFBGHieYNL2?=
 =?us-ascii?Q?7rglsSLKOgKoY0+Kn5UJCOA5IwLtkV0JhJcdo2+mi7ckep7ydmSR7wC5/XbU?=
 =?us-ascii?Q?EKZH2JbRzyRROQ1VZ+1qbr9cXjwI97ZWzPcXUrLwqRqIB9vyxw6IsKoNengX?=
 =?us-ascii?Q?tTykky7R00+Dj8qPg+nkw8AXTIbb079Wuke5CmBM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3e02449-6307-4374-7022-08dd94bdc521
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2025 21:08:13.4986
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3cp/Dar2mR+1HJ8De9pIbS5Clx754Ca2pj8S92UvaovdwUvjOQlrKZV7vdAayrZl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4369

On 16 May 2025, at 8:39, David Hildenbrand wrote:

> If s390_wiggle_split_folio() returns 0 because splitting a large folio
> succeeded, we will return 0 from make_hva_secure() even though a retry
> is required. Return -EAGAIN in that case.
>
> Otherwise, we'll return 0 from gmap_make_secure(), and consequently fro=
m
> unpack_one(). In kvm_s390_pv_unpack(), we assume that unpacking
> succeeded and skip unpacking this page. Later on, we run into issues
> and fail booting the VM.
>
> So far, this issue was only observed with follow-up patches where we
> split large pagecache XFS folios. Maybe it can also be triggered with
> shmem?
>
> We'll cleanup s390_wiggle_split_folio() a bit next, to also return 0
> if no split was required.
>
> Fixes: d8dfda5af0be ("KVM: s390: pv: fix race when making a page secure=
")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  arch/s390/kernel/uv.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index 9a5d5be8acf41..2cc3b599c7fe3 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -393,8 +393,11 @@ int make_hva_secure(struct mm_struct *mm, unsigned=
 long hva, struct uv_cb_header
>  	folio_walk_end(&fw, vma);
>  	mmap_read_unlock(mm);
>
> -	if (rc =3D=3D -E2BIG || rc =3D=3D -EBUSY)
> +	if (rc =3D=3D -E2BIG || rc =3D=3D -EBUSY) {
>  		rc =3D s390_wiggle_split_folio(mm, folio, rc =3D=3D -E2BIG);
> +		if (!rc)
> +			rc =3D -EAGAIN;

Why not just folio_put() then jump back to the beginning of the
function to do the retry? This could avoid going all the way back
to kvm_s390_unpack().

> +	}
>  	folio_put(folio);
>
>  	return rc;
> -- =

> 2.49.0


--
Best Regards,
Yan, Zi

