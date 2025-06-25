Return-Path: <kvm+bounces-50746-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 90429AE8CDF
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 20:44:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D3516188D8FD
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 18:44:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1221B2E62D2;
	Wed, 25 Jun 2025 18:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="e/WXQNxs"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2078.outbound.protection.outlook.com [40.107.96.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF112DAFB0;
	Wed, 25 Jun 2025 18:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750876921; cv=fail; b=kfzNa9oUP5Qa+7uL76h43/oGfDaEsEELOh+S6lJk80/TSINi3Kk6W032+0/wcsoz3OlfYPtkL5aa6YxDCbkCdbljfo0JxP41pKaXfcBUFxePg/j/XayGLg2MS0kzzZefr1Nc/+ybDJQiOJ9EUIJntKVa0eCIE7SMgVQmMOlr3PE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750876921; c=relaxed/simple;
	bh=IlXnoN4qoLAI6IuhEZEBJF9b20xozvsk5Xpt+klJoj8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nKnsBZtsr1IM/KcMHgwVKhtZ254i0h+u2JwxGAeeIN72+U/+TFic1ULpr2Cm15mvqsJXB5EURRxfw+V0IB89Uw33gg2dLg0Hv0VMHkzv9UBvB1I7eb19Lga0YjLBu3q/71apCOnxRhMq68Cts5oCtezNMUH6uit3wcQ1xZqnuLw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=e/WXQNxs; arc=fail smtp.client-ip=40.107.96.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WSVAkUN18zh+ELs2XBHCGEAuDy9B4xURuVJ2Onepd415/p3CiTbsrSkF27l25y1E5qwKHWgTSKEdDNP1fVuxsTBuWZb1nhLfroupMjMEzMMuY1n1dvwItD3RiIQuLQZwqRSyA7pCLfT7lZs5bGosvX04dBBsmPCHCzBx61X9Rf3m5tGfzqc4Ii3H2lLiMuZsrQP6WysvDnRRZsCTRH2gfvB8iGlzkRK3zwrDBffk2XpQiTOwPJuARRFVw2ILQ89cp7koXwxR4TO4mVPd2rFSjayZLPl4paDHZbxzOU7fo5mTJs4UwpPWFYJ2lwG838+zN5BQLJY3Wx2GXBx/+yrEqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WpyoHBT7ypVueAGtEuJR8/NwjIilTpVVwKMjKKlidMs=;
 b=eXMZBuV8r5G8WbmVow33U7ZBqRL692NEs1cz/aDUdNnNcxHaSD2qyw8CVokkiUXfT0iagUJfP3A3vt6D99pbTSI+hCRh9amfRVNv4p6aLJl4niYw4StEKyxanKWpG0UE4An8ZJMTVFUO80bCp81bNZafebiqoVslAYsB/B6KyuR5QdktU+4MF6YGxOIJKMK7oLksNudquOfOIGTKGeNx4owcBNf4p6rivl9Ij7RnW1t4eM8wg/we/Cf+eFw7XHvFgJsiKXbvuGtAzn5+WQ/c0gK9m9h8vXg0vryeoDS1ZtyMYJxopj+mTVBMFFcci0VzraQ6eI1mCjz5o+vIyueEHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WpyoHBT7ypVueAGtEuJR8/NwjIilTpVVwKMjKKlidMs=;
 b=e/WXQNxsETaodgDyYwiWG0deaUKW8JkQyxNfEBqVQenoqnXVMswjzlEH1WBeA136NFJEYYTUB6y523mewp2H1wC2WYy9hlHdSMPhGGo4CsftupgeM5VdzI0JI0uFJwRdRGvWh7L/ULjiI4hVFOB5y/H43Thtae0HLU8Y3xFqj8WNGs+KGPecVOBrcG1Mqq7fmKOSwLZoPDgMxJ9JoyRy7PkEFLJe6i/gSKuy2k2J87wqVBo+zru5cwcgP5iLGBOHvAp3Ei9Xw7attUd3pAHO+PG/ZYIYRhQDLe7ursdBF5iYTqZXJEJhp4d5jPHggiUyZgep5+wfotQkpvE1pdjvGQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SA1PR12MB6894.namprd12.prod.outlook.com (2603:10b6:806:24d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Wed, 25 Jun
 2025 18:41:57 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8835.027; Wed, 25 Jun 2025
 18:41:56 +0000
Date: Wed, 25 Jun 2025 15:41:54 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Peter Xu <peterx@redhat.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	kvm@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Zi Yan <ziy@nvidia.com>, Alex Mastro <amastro@fb.com>,
	David Hildenbrand <david@redhat.com>,
	Nico Pache <npache@redhat.com>
Subject: Re: [PATCH 5/5] vfio-pci: Best-effort huge pfnmaps with !MAP_FIXED
 mappings
Message-ID: <20250625184154.GI167785@nvidia.com>
References: <20250618174641.GB1629589@nvidia.com>
 <aFMQZru7l2aKVsZm@x1.local>
 <20250619135852.GC1643312@nvidia.com>
 <aFQkxg08fs7jwXnJ@x1.local>
 <20250619184041.GA10191@nvidia.com>
 <aFsMhnejq4fq6L8N@x1.local>
 <20250624234032.GC167785@nvidia.com>
 <aFtHbXFO1ZpAsnV8@x1.local>
 <20250625130711.GH167785@nvidia.com>
 <aFwt6wjuDzbWM4_C@x1.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFwt6wjuDzbWM4_C@x1.local>
X-ClientProxiedBy: MN2PR20CA0019.namprd20.prod.outlook.com
 (2603:10b6:208:e8::32) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SA1PR12MB6894:EE_
X-MS-Office365-Filtering-Correlation-Id: d1ef8696-83b8-4741-d15d-08ddb417f613
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bOMnjbxMP7WhJXQziWUDbhgCDk/rq+Nl+IkURe4o+2U0p8A4Y5iItV8ddcPs?=
 =?us-ascii?Q?NfDAooEmlrKG5KdwnEU9flHIHV7m8CIpuc26UtF2atFbsRM95wuBiapeHK5b?=
 =?us-ascii?Q?zj96sICkW/DjwuHNGKWCzL4/o5hJyuurWzepLx+2U3S1fmc74puBlpEmi2Zi?=
 =?us-ascii?Q?3BRTwEJ05tu6R0eh6/HE76jQc7ncU1n4GF39fCDvoUzV18TAHDPa/fy+w0JF?=
 =?us-ascii?Q?i029F/a/rpZ78UZLBZEdUflAeKbTcOCp6j3HMM8HtiKfz56qvZMP0K2GXOxc?=
 =?us-ascii?Q?VNV6CxCwLoA6n8rAELGXSM/iQRtyA/iOf8zw32LeoDCGFF2jLS+IT8ChZGMO?=
 =?us-ascii?Q?tF0xHG46VAZnCQOsqj7XXcSUTTJ25davOYnJYhZHKpRNMBtAmWh6JziRgL3K?=
 =?us-ascii?Q?LQsnyQofs2vRMy5emMiWAck3lI+9R+R0jwJ1gsGcURx2z5L+vH/N2h4lG45F?=
 =?us-ascii?Q?9MpP/D3Q9dJeSDxlSTGrjJxvR3+u5Cd/tFXWlAAS0ZegJ3wOSihh/TtsGrYD?=
 =?us-ascii?Q?8Vojd6LGd+07/I0lY2NPZXloYs/Moc/ES1rrD/KI/yJbIoZILWoAgk/sO7JS?=
 =?us-ascii?Q?q5YsjvHCrsMJXXmhyiMT1cCx+NTy8UA6gGlOtsvmZq44G657J+6PrC5Biilw?=
 =?us-ascii?Q?IgLs52Ary/BfBrHnbpPUWMNCKI1TOsJ7TQgHXIrdBBiFpS9lDyBjtLjci0H7?=
 =?us-ascii?Q?QGKvx0ZqscO5OJCMJ0hpsXN7qHyahnqbuRWtIVrFqoUEDmNoEGOuDdQiOs+v?=
 =?us-ascii?Q?laayWmS4Ifn1a5nmpgVZ1QdkdQsXfYgAYGqmPssw/4e4xtPRkDnBk8UPWynv?=
 =?us-ascii?Q?JOaM/cUtNNSUJo23ihFrQqj7LByuPMxElR1XeMzyJnXnj2NT94/PtKNaSWQh?=
 =?us-ascii?Q?6Xt9I/Vlcavirn0aBAXqFiEKIS+dcn5uCdwuCOhK0PgWBwf+oiuF8GdPh88t?=
 =?us-ascii?Q?cJMGohnE2V3ttucDKcPyQU0zm4GwaL7XL7WF8mYV/ZNByAUeV+Eueiwe6l6g?=
 =?us-ascii?Q?aAcIo0OFvA4UM5fBgkN/ETGMvbewEBb4RkHm25TNh6P/v5TLCNmaQ1svMnkf?=
 =?us-ascii?Q?eyHnnf9hHebkIbdubJ6Jet8C0a9Kmcdfc0gs0kWbkLiDpq5jZRbOE8pYVsom?=
 =?us-ascii?Q?yrsegXue54DBF6zbEYKp+UL9qo6pHJK0fnDU0V1u6mZHE8CmZLZq5XyzShgd?=
 =?us-ascii?Q?E9DeZ5Xd9MegyeRJ/jnwJ+UiKAqTdh+1ltVp9vnjKXNvoVNEmpOlNv1vWEOf?=
 =?us-ascii?Q?wqobhxCvAfUPiOIn/saHNFDgumrKBeEG6k7tlvsRAPjoAWiCL9N50I0aT32+?=
 =?us-ascii?Q?yuUy8N22v0d5cSWFGQY2efWcrkpFb8qEmA5eSIZvdfcGEz/s69Vy9DxE5swh?=
 =?us-ascii?Q?fbyLkDZMT7yiA8ov4gR5YoQa1i8X4aLICKX+rWeUsGOZueXBf/tIAzdNSp3Q?=
 =?us-ascii?Q?x3O9ffvl15g=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VMUXPk+4EHcwatUlv2IfSr4M2uZXPoSDwGRJs4VekfxZ1eRZEEvuvj1x6Q0/?=
 =?us-ascii?Q?t7d03H8lzZp5hv827cDFaMEA/SpQKj4NNK3OuKkJwRx6t+SNNwrd6zwhKYiP?=
 =?us-ascii?Q?c9uLI/qJrjlKI2irXwLFCQFfi6HdnKSEIJMrhPfppWVcOpFEhlR4nllCEaHv?=
 =?us-ascii?Q?wkCHMLwTdmgWw+cUeiRG56PVf6U8at73skZfDxOoujLa6rNmPRyQeZqUmHwE?=
 =?us-ascii?Q?d8CyJRQtVLPpBA2X/fWIhNTEoGPyO0K9wlD71FQsJ6NHXqKGgKD5DbBDLrgW?=
 =?us-ascii?Q?vhZhkk47NI9Z742FnX/Ln8+54tL0j9CWJCYLEI94AgmMg7hSzm9t98fsCVwx?=
 =?us-ascii?Q?uRQ3fHH4BdRQddV+j0gzyqykTV2oVldUbJPC8cyx1jTUg4yQO6Mg4z1vZL/b?=
 =?us-ascii?Q?G40MkVtt5tSr+JW/HJtJ+XJLLioIH/5IShBW9r6TrmV1NrKSCLLbEuLLKTht?=
 =?us-ascii?Q?QAqCT/mxR+uwrMeGAergRwLZcJJeSDx0e8cH3cNTwlIC5Frd3UvGfzDKyk1j?=
 =?us-ascii?Q?Ud13BDelRI6bLN1WX3nzF8EkNWd1pGWFkSf0OomrE/1ztovlmUercZxNwcat?=
 =?us-ascii?Q?6l9dV5mPDpeKkVPtX32eadNJMz5jxOmgZpHQ1OKX/wFTelbMHsJZc2ZZjnxE?=
 =?us-ascii?Q?qp4PkiN06/1U5mJB8enDKISDub9JVvQ/Qfcv+uk9IUFOCz6osfkewT5Eamsx?=
 =?us-ascii?Q?zOKdadZnaaL7TApRoft+paUAal5swcH83E4nmURdXvlZzhuC7WL41Jv6+9YW?=
 =?us-ascii?Q?X2il116gbwF62+3DaodEJzJ/rHffBvrK7chaJFamvDkUa8R7peG/lJK23hhi?=
 =?us-ascii?Q?nzKtQoNHG6shxHeXjRiXPMCjsJvkEfd88cfc6c8v/IWSza3D99kCUL8BHaM8?=
 =?us-ascii?Q?pUsQ7+1ZuPMcWy3CoB1VNFg2sCPGrXR2EM7//6hVeKCUxGDD8Db/dbLj9Okd?=
 =?us-ascii?Q?slDXxOwM2ppsR97NclZ/rp9ldDLOrvmuWAqfdJ82Nn536TQmIg4qw++tje37?=
 =?us-ascii?Q?fpYgWfc4PdHJy14Q+BnrtQo+Lk2ykPTDooAL1Gk8kziCMMhnx9wCzKNZ1nWQ?=
 =?us-ascii?Q?MMo28BDi+OJetm6yPlYCHzlHzvUVLPl9vO/d37nFuI2urS7Nir8jAXx4SEko?=
 =?us-ascii?Q?zKFzXvYRXMSAsS3PDNChSslgamYRuUm5+JrmxZsKmyKskn47pxLb54HujFaB?=
 =?us-ascii?Q?HDE6GlbcwFLvF7hwhmQ3c/4Ugb417LB24rhOoH8LZkGMBlqCU3amG+9WtbVc?=
 =?us-ascii?Q?G8/JGB6Pjw2UlYUXkJbL2NgjbA7mKm81t9VDnoD1QJwmDQ/ImunWXGq4X1Fk?=
 =?us-ascii?Q?kQInwasZMQL+xIMo+rCsVpFX5/MUWKU82RL8XoyEgR72qgAIOQZe4lvlx+fl?=
 =?us-ascii?Q?SRc+0mnc8n/rJspCSCUblmU+iUKfMmjwCdhVvgCQ2bUUsupXitUhNLWj/LR9?=
 =?us-ascii?Q?DooslSvRpVpSPAkvA03jFs0Rd0HdvBJXR5PsJsvvJJ9EfkvKGf1Ww4MuSzCE?=
 =?us-ascii?Q?ZjFKaSkqZbpwqEKr+U+u3x1Fv8JzRXD1tfttgXrySX+wS+aZsePg0kOubR58?=
 =?us-ascii?Q?omummgctbpiV7ifb+O+WnKezY66Hi+Xn8PmaLsrd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1ef8696-83b8-4741-d15d-08ddb417f613
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2025 18:41:56.6368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0f8dgDmPjYekoTPtjjN6FAhrY2jpiPfOGxrcq12CSqM8lPtMFkDa1mSb1m4/szk/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6894

On Wed, Jun 25, 2025 at 01:12:11PM -0400, Peter Xu wrote:

> After I read the two use cases, I mostly agree.  Just one trivial thing to
> mention, it may not be direct map but vmap() (see io_region_init_ptr()).

If it is vmapped then this is all silly, you should vmap and mmmap
using the same cache colouring and, AFAIK, pgoff is how this works for
purely userspace.

Once vmap'd it should determine the cache colour and set the pgoff
properly, then everything should already work no?

> It already does, see (io_uring_get_unmapped_area(), of parisc):
> 
> 	/*
> 	 * Do not allow to map to user-provided address to avoid breaking the
> 	 * aliasing rules. Userspace is not able to guess the offset address of
> 	 * kernel kmalloc()ed memory area.
> 	 */
> 	if (addr)
> 		return -EINVAL;
> 
> I do not know whoever would use MAP_FIXED but with addr=0.  So failing
> addr!=0 should literally stop almost all MAP_FIXED already.

Maybe but also it is not right to not check MAP_FIXED directly.. And
addr is supposed to be a hint for non-fixed mode so it is weird to
-EINVAL when you can ignore the hint??

> Going back to the topic of this series - I think the new API would work for
> io_uring and parisc too if I can return phys_pgoff, here what parisc would
> need is:

The best solution is to fix the selection of normal pgoff so it has
consistent colouring of user VMAs and kernel vmaps. Either compute a
pgoff that matches the vmap (hopefully easy if it is not uABI) or
teach the kernel vmap how to respect a "pgoff" to set the cache
colouring just like the user VMA's do (AFIACR).

But I think this is getting maybe too big and I'd just introduce the
new API and not try to convert this hard stuff. The above explanation
how it could be fixed should be enough??

Jason

