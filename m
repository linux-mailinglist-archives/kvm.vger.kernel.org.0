Return-Path: <kvm+bounces-15490-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B4A68ACC5C
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 13:54:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E72261F246F8
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 11:54:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B945E146D44;
	Mon, 22 Apr 2024 11:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PPKniy3t"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2045.outbound.protection.outlook.com [40.107.95.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB12146A67
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 11:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713786881; cv=fail; b=QmjCpfm/77B/tF2NPxnpcDQ6f8awtJ0iVApHBYbmOLA7XGA3fWEXtTAXWynCjS2rizUuAizaqJRQM6lQsSYTn3J0soO1aED+iUSOyCOnwNO7Q24UzDXZRNKwBK14cGgwR+vs5jnCD7Jc0eszFOTpmXopg+bmZF8w7S6KnI5M/8A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713786881; c=relaxed/simple;
	bh=yo/hulfklXIrIYPp85008ZZ4PfewtPbC+TlBEIctTVM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Ztd3KnaFtaCV0QuPuoRpw1ylU3ZUWLp9cW7C2PleTl+7R7s7uQ/paqamn9jqdrKvHBTY04VGlEXlK7CbaGDpPG5piF/lQ34drnOyQkdkERFhFGWQKSfoob7YorWZFWEM5FIjHZiqc3NxCw2YWhw4I7xauaVmaEnMPprs8q/OZUA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PPKniy3t; arc=fail smtp.client-ip=40.107.95.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=isgQQ/vtDAEEXCOAQzKi8cno1cIe0Ir6MkMIUHZB0S5Jht3ScHqEEpd5tfwpGErMHaA5nihaG4vBMBjk8yX8c+drVBy+BGf3DrATdwdC91m+KYqcxNVRYUMeRGDj+R0fr5HkwrlZ/IssrTqhygra8whrxhbVR3CleRfe9lqPxnH5EKvi7dg1Uz1cD8xszIhZPslx3lFYXSo2artfEyTz6YkyV7JdUejw13ybSKr8nDNQM/XSNCVewwAbUjmE2ND/D4jZcZQi/2Aw7B1Cb8QN6KAEbccjwnyI9+mRhAsPXgyFSD9tgVjYM15LUWQ75A8u5waVZwRvEZbIzLyWkBxfrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8tXRi6XA5aN65UqneMDqXr4LavLawHFzsi0AYDYp9p0=;
 b=VVhUDOKLyGw7VVodnek3VqMHpF6vvMOhKSZmxaCmhx4YdAjIr0CyQTrEGPsyB9TREIsx47+makKNb7exwyZhvreYtWkTJJwHEa/5BKK06Ef73ib4T6+e6PzFIOB36w39tn+pXHx/7LXJubHrq3dUhZS/AozhkVQWsCF3VSQ9k3mIL/JjKgaLpsoQI28L9t8DX4J2f671Bm7e+mX57tWxmwwkK/uFzKGG2M45yQZQGUBJkMLHm2/JU0Z59CjYmFfh8esBo7lWlY5k5ZdIUMfAMfbLltus5xYBNgUijB7CWR5AcntL5iqjV9BFNA0r/atYbkYA25Au5YP99zjm5UHbCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8tXRi6XA5aN65UqneMDqXr4LavLawHFzsi0AYDYp9p0=;
 b=PPKniy3tEoVFrIxAfnkassNScDufDEmX+9du1BDXRKB8sJTHEPUdTFJv2trSFnIWj+ry8/w/yM550v4y36MVGqSagm7YB5nDyC0frsD1Kju30L76Ndtoq98N3420ImC+3uhQUUJ/02D7sYlNG4ZbZtfD9hjFGYPLQlx1ZWLZAj0tb3kgKHsxZ72m3uEPJ/W6xbpnmXmLvO2E5pHg8cvjbfpmK41oz7G5zfWvqRn/vlwgIxyU/qJ0fgbn+I37ASKLLX3HWLWd7w9Nbh4scZ9TtM9JZJzx0mp7LaZPZFXhXyOIedV0lAL3OctEvrOhJtYp4JunF3nC8OAddmn8Ir8u7Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by LV3PR12MB9266.namprd12.prod.outlook.com (2603:10b6:408:21b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Mon, 22 Apr
 2024 11:54:37 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7472.044; Mon, 22 Apr 2024
 11:54:37 +0000
Date: Mon, 22 Apr 2024 08:54:35 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Anthony Krowiak <akrowiak@linux.ibm.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Chaitanya Kulkarni <chaitanyak@nvidia.com>,
	Cornelia Huck <cohuck@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	Eric Auger <eric.auger@redhat.com>,
	Eric Farman <farman@linux.ibm.com>, iommu@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jason Herne <jjherne@linux.ibm.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	Lixiao Yang <lixiao.yang@intel.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Yi Liu <yi.l.liu@intel.com>, Yu He <yu.he@intel.com>,
	Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH v6 16/19] iommufd: Add kernel support for testing iommufd
Message-ID: <20240422115435.GB45353@nvidia.com>
References: <16-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
 <6860aa59-3a8b-74ca-3c33-2f3ec936075@linux-m68k.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6860aa59-3a8b-74ca-3c33-2f3ec936075@linux-m68k.org>
X-ClientProxiedBy: BL1PR13CA0073.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::18) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|LV3PR12MB9266:EE_
X-MS-Office365-Filtering-Correlation-Id: e2bb2ee8-cc62-44a5-a238-08dc62c2fbe4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?m5dzLfdVBvkj7Tvd9UVzyBNPAy9RNkDNFkndCDYfruyNub/cvXffbWK2/2TZ?=
 =?us-ascii?Q?aXSVnp9ecFvh4vvDXzTWhvwe854ISr5dKMTXa0o1D3uUFyptal2NNRa6p16T?=
 =?us-ascii?Q?4ktVsiEzLq6jNWoRKYaxqbv6ZskWKJy/3xAsJLeqBobP6zQJ+v65WT+rXqLb?=
 =?us-ascii?Q?RoTDBM9tpwGh2YCxoE/2Hl5RLAT6H03M3+/tjGS4dBa86X+WBpJwMI1jR3Pr?=
 =?us-ascii?Q?adUKerr+SH0UE+J1Hyme5wnhIEiGCgxB3WHjBQfLSW/YTr/GT4Zs7gJJMR0b?=
 =?us-ascii?Q?a1BdgWqbHWKjal7txxtmar364vfA5OMY9N2rE1vUDHjYjoAIWldvTMoQ2FN7?=
 =?us-ascii?Q?YIg1iKNkk5dmxLDKPKt/tf1hVRrk/gZoDEQGgUZaWKVzPr4okedXVBuDxdqB?=
 =?us-ascii?Q?K+uODxUbKiWvVBRMxSiyHFN+E8ZSCty+xbjKKpLsksd/o633b8YeShLhzYfu?=
 =?us-ascii?Q?Q8Te7FOaz/UG/0YI40E9gBIP4DOKe4IF52ARxF5KHuifZbXf2+alL8ZhbdJE?=
 =?us-ascii?Q?g4l+xbRFXl60Hp47aU7JIAXXgqmRrzxKy4vyCOInkc5lmHtZ27Dw/uZwe4Pg?=
 =?us-ascii?Q?5QIg5eL+4iVIsJyNhEiaBstD8auJODmGtDGldWWHX56sHYYj76GAohcKTR4+?=
 =?us-ascii?Q?5dGIUHj9Q84H+35k0kuiMIP8YOFWF6OPMBLgiERrUwaJaiCILIL4bG3O78rq?=
 =?us-ascii?Q?rIJFsgJkWz2+WCS0u6+ivgh6CDqrOrdNTl7I38uEfW3vIEZQUPiYkuDs2eHp?=
 =?us-ascii?Q?q3dQbZFnY7TL0IjsabSuKJmSb4P32f/c/Wa8w1DokgRI9kfkO1lxAvonnGVu?=
 =?us-ascii?Q?ITQoU5VutgQwAoyWOAPc+glMvQEE5iHQM0pP2QjoC54dKdv9SJKoNvkgQPC3?=
 =?us-ascii?Q?AjOCGdcQWa6T0n7Qvs/2QUwW9KptFXjElKDTzPZDxDofv89oViRvmH6tNkqo?=
 =?us-ascii?Q?/JawXAJ9e2/o5sOmR3S3a9FuwkGzprvcQCQ+XQLG2SlF4hwDlbzdezLloyno?=
 =?us-ascii?Q?zSWV8UQvjveqzAjuDJDtAg/Chh+omYvnb0jb/4mtquQ81C7UxluQwiRWf4S1?=
 =?us-ascii?Q?gcwY/4b7UO+C5reHHM3Qo0II15tx89Rw/0nYBnANNHEvq0kwFogZbC438Ub/?=
 =?us-ascii?Q?Rkd6kFttwJZj/ZWTaIuBk11DVQvfZQYuwtn/dkWjvFejHicZMpBiWEEIcfho?=
 =?us-ascii?Q?cnO70rFsfS2KYQ0lvx00rL37HaBp7FyCWQgKGrjV7y/lTl79GLAnYlmojhqh?=
 =?us-ascii?Q?PJ66BR7sKguK+MoIvWdHDffn6wnsLvkDiqeyD9qgTQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?azCe/Z9Lgu+eKwpsJ53afnTasDFuwabJ3Jyr3pkzRq6a/Rr4XeeerUFjay4Z?=
 =?us-ascii?Q?oobHe2v5PlLOt861iE6w6Xd1WQYm19NbkPDscLSFODbGYTweOOy5r9uTgure?=
 =?us-ascii?Q?pXywFxBZGhRkhs3IxwHtBcImEwBG/MqK++NSLfOlqo2w4coODBVm4vCFUzUr?=
 =?us-ascii?Q?KaoJl1jF2O9gMMocHs4NqVK5PRnkHHs1il85Xrh5kIPe+2ZQhRP74t7WJt0D?=
 =?us-ascii?Q?aRa6khgAdDdCp201jCZrayspib82iVbuk5Tmmvf9fFNlkh7BJ7cEsp3c57Lv?=
 =?us-ascii?Q?5Ym2jSEM7PAjAfYWaYwnEjIk5S9PZTf7YhwmkwuFuAwqRwpU+OwNulF/uUzV?=
 =?us-ascii?Q?21/ANl05VV0z4RlPyai66eQmixK+hUP8NbTPpenZbeLP4sryQT/BVYhSzUIK?=
 =?us-ascii?Q?5PZ0VYyxwD3BcX9ifLbNwfGPPKXhqWhZaSxuUA547dknprl1OQHdbfZjKK/p?=
 =?us-ascii?Q?tuIljtLME51pFh4aRJ6T5WHAV7nzrbOVwDxGi/2lN1a3iUH/LGAreORS9x3Z?=
 =?us-ascii?Q?dQnJTKiVGQsq34fetn+MIyP/PxhSm+W9UnHsWveZHJNemgHjKurRxhH8MDDY?=
 =?us-ascii?Q?JGJzpYD3oSqT41X5SthcPhRYVvc1h+Ac9PfHXxCUOPhaBjZzmo4X8hcLTStB?=
 =?us-ascii?Q?OIkhe703rKYPOmf+QZwyHwmvFyqxz4MhDwu/aUx9zrEYYftJPbvfGiyJ6jD6?=
 =?us-ascii?Q?u27itlOgzndAon9jr1Deh6lM9sLiAfXJKRU7u3pLkpZiRL1nuSo/hkJEPny3?=
 =?us-ascii?Q?U1GBum6OW/ebqoPeyMtFBLbxYLqXfsmdfPR3TamIyVAyndOel84D8AYUt5Wm?=
 =?us-ascii?Q?Q/vsZywR9eK2M1Ho4+vXA+8pOB6ceAAtXff6FFFZ2lk1amv0ZsDBd3imi3BG?=
 =?us-ascii?Q?W0i6OD59+9NscdMtPgcaRqIDZkw5jf9ohNRvkz/3KTkNyOsijGhYUk12w8SU?=
 =?us-ascii?Q?qZ2s+Ucyk7c0pprucgv/lz17UBtrbWdYCzI0A0dhp1FUaH2W1sgl7nB8aP5K?=
 =?us-ascii?Q?iDB+c9COUmVGrLU9NJdeyf5L0GRgf1Cz0RruQnZ6752U8iyQaN4HofukrAnR?=
 =?us-ascii?Q?cT+x557EWvduL32PCW6x94wENTryaWI6NGJUlR7pZHbO4rl2n+u7sBJFF4XF?=
 =?us-ascii?Q?Yjn/uceX3ACb4wLt8W9FPRAbUy8bmRuLFZOM4/DNvtcSyeiLsdIQeqnfzd/u?=
 =?us-ascii?Q?U4SmPnsHDaUIUJ1Yem33elhalJYg8VnLcxGuMFVrwDIoXvBtI9F0v6g8tyYb?=
 =?us-ascii?Q?hI+Hxvo1vk2JFwWBpF7kuqr1JlGvldDt7fCJuvNT7DT5LOP+LifspYjIwj70?=
 =?us-ascii?Q?ooHH3ib3IrnA/lNb/ga0bG5fR7qSlamyQ7q40j0bm57oGt61prnTQMrjPykC?=
 =?us-ascii?Q?NAp1hV7SnLaRp9I1T8Tjfi5tMMvkmrJHhdffIL/+yyqcHViPzqM85BmBM1N2?=
 =?us-ascii?Q?eDmkL9zQqFeVVLPD+sFQTckLpEqJhPokvG/XpPwr3VyDr7oXuRz4+VBvhDTY?=
 =?us-ascii?Q?wx1dkvhYryHovTQ+uiR/6SV3kfQ6Q9pP5epPk+mDODX78iN87RxC2XAEUpkD?=
 =?us-ascii?Q?h1VigwLGKaOscmF7h5Gnm9TF397lbr71Ge/jwG7M?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2bb2ee8-cc62-44a5-a238-08dc62c2fbe4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2024 11:54:37.0303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /laOGhvLns+mCeFRhNX550T0s9kr+9uQHwbMrvUiYPFWcp1a0kYmIFphldD0DApW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9266

On Mon, Apr 22, 2024 at 09:27:18AM +0200, Geert Uytterhoeven wrote:
> > +if IOMMUFD
> > +config IOMMUFD_TEST
> > +	bool "IOMMU Userspace API Test support"
> > +	depends on DEBUG_KERNEL
> > +	depends on FAULT_INJECTION
> > +	depends on RUNTIME_TESTING_MENU
> > +	default n
> > +	help
> > +	  This is dangerous, do not enable unless running
> > +	  tools/testing/selftests/iommu
> > +endif
> 
> How dangerous is this?
> I.e. is it now unsafe to run an allyesconfig or allmodconfig kernel?

Depends what you mean by unsafe? This is less unsafe than /dev/mem,
for instance.. It does nothing unless poked by userspace.

> Probably this symbol should be tristate?

It is not a seperate module.

Jason

