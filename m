Return-Path: <kvm+bounces-46925-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9859DABA6E7
	for <lists+kvm@lfdr.de>; Sat, 17 May 2025 02:04:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 454C51BC81E3
	for <lists+kvm@lfdr.de>; Sat, 17 May 2025 00:04:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E15B3D6D;
	Sat, 17 May 2025 00:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LOkEsCTQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2080.outbound.protection.outlook.com [40.107.94.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E60910E0;
	Sat, 17 May 2025 00:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747440255; cv=fail; b=sAB6D+BW5ODjxvOnrWaIc9pyvVW6frQGne+ByDYhAPMiraVhZUYyHfjL23BaCKrDRB5oI2Ks2r2rNogqg69ABexKvgqYTppTmf41X0P7lP6ZRXRs+uAnelgeQH1STX6RBKyd8LWKZdj94HkNSnyhzb+z6iPXPIFNgmGou9QlIiU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747440255; c=relaxed/simple;
	bh=sPQvuPLo6pskgYU809kUZXUPulKuuwrVQyGmO7C6yuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gakjzTl73N62oJ+gJoDa2xUqxpgzA4VMnm99KpQAkMEBd+vROzTr30DAbS6PLuyO2olJpq2APVHTtXDcKdbbJwx8ziDjwQqWqpE6HXfV4XYeB5XkqxMAaPgM2gnaZE+UCV2kU//3WHfnOdpVVf3VY6ZrvIDVxWrMBagviNf3EYQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LOkEsCTQ; arc=fail smtp.client-ip=40.107.94.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bXBbbiL6dS2Krkgttg0E/boPA/egQ+NlCXYtwxkxEiwn53eYLEVtveY3qfk+3kP6uv/7IMMn+FWP07ui+yi5E4OwB22qtnpWp+5orIEavCt2G+AHQY+rr7XkukP8iuktLShUsXvvR85SnB2IYyTQrIrnRuNVkFprDh2Rmyep57qpGAzy4TOZSFAmYQxCyEuKuBCvC0iFdPLKLI/cEabOmXakPkZiTaAnwzzmhTPyzc3/74DIBRYrFXskeQDHPkOJpr5xyuosLPLSkuj5X2Z6hrVb5ZgcsHtnrmLmOpXHgBozUWx17iFDukQCb1K8KXuA4rqsjEVeH9fjioXMwWUTxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WJ2i0mHY1ti9CPnp+P9KZk5uZcidOzWjM1GRVyl/AsI=;
 b=PPr+UnsN4KKh2a9TlrqSrYzaZrkoz6CSPHdIQJ/lUcPg07DC3xEtNqrx6IuGdAWZ/uXCMKeg3Hwp5gjpcQvSld44ZKzDhCrwglQY2w5JzwbNNQHF5TlSsu1nQZepjqAi6+GFjbYorrsX4yAxrU38MvAcwnwFhUCaMgGhrAywhuRW5DRcPSZdjcNEurxcUyFvb/hLdFC3ALvhVvrLQ69TT640kwfLwe/fcQZZBf9wgoZOtZMJmrvkwLo9H8RmXPEpuEBWevKqDSIn+yQgLYvsZmDMzwDok5up1RUukOYeJZlA7e+ebW5MTO1EV1WIQa+uo+jz9Vgoa05J7ZSqr/g3Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WJ2i0mHY1ti9CPnp+P9KZk5uZcidOzWjM1GRVyl/AsI=;
 b=LOkEsCTQIGYdF+VOEt5UajRtASiWqvQRxnJr+jhvMvqyMP5w2sibM5W5/vICCk0DHOArsDUd0qUDAObU366aavNaJffooxQJrg3zg11JZUjjqWaXw29oe28cd6RUQnS8QJ/vxr+oxg/8Wykuct/bCao5uA8xL79sxfiuKo3VzYii7orc68s87qJNZhR9XSMPEMt05dKqxwfcm/9rUEjMx748lu6In7RduIvF16IKXrVCfxoPjrdVVqe56aITx3bn1yPxtkJjCgFGrT+BJGSlUNqpFL57kiZeJR2ugkW7XvRojlEh97wnkjMsdmM6i4QRfw9SmNYQYtWRaqxXwymj7w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BN5PR12MB9464.namprd12.prod.outlook.com (2603:10b6:408:2ab::10)
 by DM6PR12MB4434.namprd12.prod.outlook.com (2603:10b6:5:2ad::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.33; Sat, 17 May
 2025 00:04:09 +0000
Received: from BN5PR12MB9464.namprd12.prod.outlook.com
 ([fe80::e83f:10b6:1259:d000]) by BN5PR12MB9464.namprd12.prod.outlook.com
 ([fe80::e83f:10b6:1259:d000%4]) with mapi id 15.20.8722.027; Sat, 17 May 2025
 00:04:09 +0000
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
Date: Fri, 16 May 2025 20:02:46 -0400
X-Mailer: MailMate (2.0r6255)
Message-ID: <818174C5-0FA3-4FA2-880D-FF5C1102B2B1@nvidia.com>
In-Reply-To: <0454761b-ec54-4cc8-9d01-b783e2e58f9e@redhat.com>
References: <20250516123946.1648026-1-david@redhat.com>
 <20250516123946.1648026-2-david@redhat.com>
 <60DDE99E-E09D-4BD4-AC58-569186E45660@nvidia.com>
 <0454761b-ec54-4cc8-9d01-b783e2e58f9e@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR20CA0017.namprd20.prod.outlook.com
 (2603:10b6:208:e8::30) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN5PR12MB9464:EE_|DM6PR12MB4434:EE_
X-MS-Office365-Filtering-Correlation-Id: 67b26675-3b93-48f6-9e95-08dd94d628ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8AEJeHS+FfEMdjudEYfARwiMOm8K7v4ZS5diVfInI15Sym0vY8cYYQ686i1F?=
 =?us-ascii?Q?6UMwuihbli+Rj8vcPXG59KZQ0wIcUV+djwHt58kEI4gGyI2BDDvzKgDFRboE?=
 =?us-ascii?Q?6Agkr5EvsN+tth0vBRZv1RRqJY3Qc3CVRhdv8gGyPBL13AfVvaEIbUKps+T1?=
 =?us-ascii?Q?iYCekWCOqiPk2ZRH7+AFRQTFlz6jRrOE3YGtcjlAGgclcSzRE0NV0LFfDlrz?=
 =?us-ascii?Q?ap4k5by57fEcHJ4e1UFvctAhDmbMfXI964BHrAUsdPwPLYXKGlzBXFGdUcAH?=
 =?us-ascii?Q?jlTsxW1qbrh26tGQlPIBEEP7r1htM1jkZbSdskZeR1ha19n4Vsaso0OFS/A4?=
 =?us-ascii?Q?nQplCH9r2GvS/4/q9TfwG3tBc7aEuqbixMfqLemZHmUcMMqOv3LN4hfYsCI3?=
 =?us-ascii?Q?HFskCfWhk7kYoDacIGoKX1fEn4MTTIMkvYAfE78bHJsk2xOS8Srtk3xPm6BA?=
 =?us-ascii?Q?tSEUb42FzAjLudBc1bTH9e61SgaP3U0HRiLaNoYVpBl8b7woJsVWc7DbIgJ3?=
 =?us-ascii?Q?Fk5eSGecadEN3Tg3pDy2yLphgeLdh5DkRIF/cVIz6OmxTm5lA8UxARvU14iI?=
 =?us-ascii?Q?v7rfV9nblqY8XG85pJDuj45lgRtR2gGlJWBrIsNNgmLNUm3RckO6rnvFgixD?=
 =?us-ascii?Q?pu0WkRaUBsAhm5V+DspEjHh5o+gFe/ee47g3AVbRIYB/aA8+VoXqhKuBGlNA?=
 =?us-ascii?Q?0R7dtYnijva/YHK96aox6lbGjC/WcJkS0jsVthR2fvbuAc5yZhpT2Rze02o0?=
 =?us-ascii?Q?z0tV8tQ+vSaJQqxlk0JbkBwaQTR3BBBTNQV6GE52NgdBtr9PmVvAL8M3bWft?=
 =?us-ascii?Q?muj9nZdFUgbV46OmOK/rmboBSvef6kT/WIQz0gGN5A26uv1D+/NMPFB7QsX8?=
 =?us-ascii?Q?YaMprsik5UuPxazXsLWUnoMc81z1Mc40QLWms0cCOzve72BnhKU8wTg8/OCu?=
 =?us-ascii?Q?spNIrfvGHqYFUSQFy3qeX8bJEwWSYL5dAMFiVX8hAnZYNwuDTH9xz4tlANHS?=
 =?us-ascii?Q?PyvXYMcNoNRAKWGlpMbgBkpWP111c2BnaGRdBizO7sg7Jw6EW6mJlXtMAyoJ?=
 =?us-ascii?Q?lVkQNGiXbyxqx+uXukhg/qQsmk70knWEua1p3M5L+8DmMF8F1nwNH4FxrcRZ?=
 =?us-ascii?Q?P1CP0iJ/js/saJqfI2x8ZK2MxMKjyWzu2HgTq//4Vw6K8lGQfDkd15p6jzoA?=
 =?us-ascii?Q?oYiezBsu7fA6ew40rIg/xBwG0CLDbVZrJaL2L49qtkqdj/6GFLTpNkRAvIZ3?=
 =?us-ascii?Q?WbZWHvpEhUblytpJg/u0nVZvL+wEo8y5J79xd6PBJTXp9ATC8LyMAfD2zDTp?=
 =?us-ascii?Q?Q1eANoa167YE8vltsx1nIOFf88fmHcsCcq5oDAnEzQIFTkGviVCBR207JrMp?=
 =?us-ascii?Q?8O7lWkNEMo3mqEO3wBFfMxrVclcKmF9WzbB80X1ZAQkyjLsPQE6WB/u0xjmJ?=
 =?us-ascii?Q?zlRMTtlilvo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN5PR12MB9464.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CA8K+3D/Ex7ZePCJKgEVGgnDH9VjpZZK3sqVt5FZqLXvaK3DHxqmf5L2hErZ?=
 =?us-ascii?Q?pHoqtyTuDsHsvmTYB7d8LzVCR+7DDcRb2boT0Bh1q+mpay8fUdKrdcxy37Tx?=
 =?us-ascii?Q?zyAi710H9MYmCSczaxa/maLyVCt+JZgwlf+71HQucNi0ZyjiytSGUeCdNnJn?=
 =?us-ascii?Q?rgI147xH3TxgXQVdpwb6K8uYBMiNUoY0q9KTptev15bZkK7SKfG/UvE+Esb1?=
 =?us-ascii?Q?RcQHJBS4Rs8BAQmerOruYqs2DD26R4OxaFjGlNOXbuLmpDvkYGSx65JSTlOv?=
 =?us-ascii?Q?UCZJUcmnNgIo31ppAcUz43JuuGBc9lBymgLrcTFwqbrQywvrG39HHzy9aoDZ?=
 =?us-ascii?Q?wDyNk1Yu6UkgHS7Y3qKZxeR6Ki+hvUyJBWqFiFv1Rju3ZseSLoeVBDFyFutj?=
 =?us-ascii?Q?qq9ZHPo7K644s05CrflLavFAQUgySCVMUwIZnnJ2XlYuUwSBbTzYekrRydVH?=
 =?us-ascii?Q?3iBV1TvPR6wupZb09jslbKDuiv/1RqB9wVh0hM9I7IqH1a9d14N2hhjOybW1?=
 =?us-ascii?Q?8vFiryrcduMe9x6B6gCUyyCLRzLE6OHIodBiSHMgne3uLZgwKKeXz2vIkxky?=
 =?us-ascii?Q?ED7Q4vRBWZsD7SBD2591JOkdXmdjnRoqDOKKodoa/m9QCjvvKm8e5dVjtgdl?=
 =?us-ascii?Q?G62Y2IwYycQByfcxim3EinRADbPWShVa1xiqzgktjLVDacnunyKdVYo1ebMi?=
 =?us-ascii?Q?/lEFFKpZIk7AbTG18iHCgbayoe0JB/OMBVWZ+Wm0HWh+b99mBTurJtFp+brp?=
 =?us-ascii?Q?l/om6tkqHTVBU1ak4gYyk7iD02nEA5OCe3DCiR91ZaofARBPRGeucuZC0hV6?=
 =?us-ascii?Q?U0uQFvX1WmILMKpmzg41WqZDaCyuLhypz6KZI0obnOREUgE7IzHQiXoTSjrt?=
 =?us-ascii?Q?P9hVb6r+dozMyeyfRQMAfIXjaoCPgt/kZLNOFIdnuutNetHJcg8wP4c3JG3G?=
 =?us-ascii?Q?pY9S/kHqfOg+hWc0FURx/2o4helGDrHJTXWQAZDyUg0SLHIGafdyYp7n3KUr?=
 =?us-ascii?Q?nY1kwUC3XEwcfua0XLnMm8hA69mIumIoJRCN1qk3LnyeVRObLJZc8Lmqwj7/?=
 =?us-ascii?Q?OnZF/EZFOEjwsHSgiBDje5PK3qs4gPYShcH1XhjOoAO78d7CI6FBbsDHRzlg?=
 =?us-ascii?Q?WkUNFRMbO90YDLue1NVWjFUBsBfJ1HE3p9Q/epgSQo2svXAIxoxmcrf2Qido?=
 =?us-ascii?Q?KGuvTGRO3KDAQs1eZrUiDDCK8LtX6B7eZVzyprq/GvyJ1yCLWpt49fSK4CSy?=
 =?us-ascii?Q?gWe+8rXVd7F83ZBqsdQ2M06gOeR5Z+LdWJn1zZWiURDOUWQ8VE7Hdoj54rQC?=
 =?us-ascii?Q?FnzwQQ1OKV/2H7jsLSMxXgmNBZJ0+q8u6lfCRJMkziJPQT84Yde8tfEE/NBJ?=
 =?us-ascii?Q?pe1pfaBkxEnLl3cQpfIKYTn2Pw0oXp7h8HYnDb/h+4iX18Ov06ucm3UZSO3G?=
 =?us-ascii?Q?hWNAtCeKmED7Ajp3wr3hnO/Pmhurg4dNKNdkn2tekrqqX0XXcxrBQd8WT6Iq?=
 =?us-ascii?Q?rNUa2dHW/zC7zn2ScrA6i+G2f9V8Gn0dvHJ7DZgYV6c57VlUZFZ0vk5f9MDe?=
 =?us-ascii?Q?HmCA70Cnfg3dALGsgmGNoubn+vPtjg2ScCmEaU7N?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67b26675-3b93-48f6-9e95-08dd94d628ba
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2025 00:02:48.5395
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +0oCx87W+UOzUDvWDLMpcWybDJbsqS6qcn1dz71Bl3wIUMiWoKwA3va8zLwQqukU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4434

On 16 May 2025, at 17:20, David Hildenbrand wrote:

> On 16.05.25 23:08, Zi Yan wrote:
>> On 16 May 2025, at 8:39, David Hildenbrand wrote:
>>
>>> If s390_wiggle_split_folio() returns 0 because splitting a large foli=
o
>>> succeeded, we will return 0 from make_hva_secure() even though a retr=
y
>>> is required. Return -EAGAIN in that case.
>>>
>>> Otherwise, we'll return 0 from gmap_make_secure(), and consequently f=
rom
>>> unpack_one(). In kvm_s390_pv_unpack(), we assume that unpacking
>>> succeeded and skip unpacking this page. Later on, we run into issues
>>> and fail booting the VM.
>>>
>>> So far, this issue was only observed with follow-up patches where we
>>> split large pagecache XFS folios. Maybe it can also be triggered with=

>>> shmem?
>>>
>>> We'll cleanup s390_wiggle_split_folio() a bit next, to also return 0
>>> if no split was required.
>>>
>>> Fixes: d8dfda5af0be ("KVM: s390: pv: fix race when making a page secu=
re")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>> ---
>>>   arch/s390/kernel/uv.c | 5 ++++-
>>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
>>> index 9a5d5be8acf41..2cc3b599c7fe3 100644
>>> --- a/arch/s390/kernel/uv.c
>>> +++ b/arch/s390/kernel/uv.c
>>> @@ -393,8 +393,11 @@ int make_hva_secure(struct mm_struct *mm, unsign=
ed long hva, struct uv_cb_header
>>>   	folio_walk_end(&fw, vma);
>>>   	mmap_read_unlock(mm);
>>>
>>> -	if (rc =3D=3D -E2BIG || rc =3D=3D -EBUSY)
>>> +	if (rc =3D=3D -E2BIG || rc =3D=3D -EBUSY) {
>>>   		rc =3D s390_wiggle_split_folio(mm, folio, rc =3D=3D -E2BIG);
>>> +		if (!rc)
>>> +			rc =3D -EAGAIN;
>>
>> Why not just folio_put() then jump back to the beginning of the
>> function to do the retry? This could avoid going all the way back
>> to kvm_s390_unpack().
>
> Hi, thanks for the review.
>
> We had a pretty optimized version with such tricks before Claudio refac=
tored it in:
>
> commit 5cbe24350b7d8ef6d466a37d56b07ae643c622ca
> Author: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Date:   Thu Jan 23 15:46:17 2025 +0100
>
>     KVM: s390: move pv gmap functions into kvm
>
>
>
> In particular, one relevant hunk was:
>
> -       switch (rc) {
> -       case -E2BIG:
> -               folio_lock(folio);
> -               rc =3D split_folio(folio);
> -               folio_unlock(folio);
> -               folio_put(folio);
> -
> -               switch (rc) {
> -               case 0:
> -                       /* Splitting succeeded, try again immediately. =
*/
> -                       goto again;
> -               case -EAGAIN:
> -                       /* Additional folio references. */
> -                       if (drain_lru(&drain_lru_called))
> -                               goto again;
> -                       return -EAGAIN;
>
>
>
> Claudio probably had a good reason to rewrite the code -- and I hope we=
'll be able to rip all of that out soon, so ...
>
> ... minimal changes until then :)

Got it. Acked-by: Zi Yan <ziy@nvidia.com>

--
Best Regards,
Yan, Zi

