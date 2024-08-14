Return-Path: <kvm+bounces-24135-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D8C31951B0A
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 14:42:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 950C2282DB0
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 12:42:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F6051B0124;
	Wed, 14 Aug 2024 12:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="i0+MJokz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2056.outbound.protection.outlook.com [40.107.100.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA19C15C9;
	Wed, 14 Aug 2024 12:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723639354; cv=fail; b=TiHoxuKnHLq5BYQ9K4RI2Ax52h62EKVP+Dc+Hi0XkOtIPILMQBQr+ioBLwqwDz7YJTvw70SF59FatwrTM+OERXQaVnDdL39Btm6RVYsxyueISQCPOGKCJEly4LD73049aqSfxjueEVCicGwGn63cgQXOp1WK1BEa0hVgScYWxmc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723639354; c=relaxed/simple;
	bh=OtbE+gN7VLKHhPmGKFuDXZSYEImpt04IzJNj2PZTk8U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=EW4l9OIamdHBJULwOP5p3sFmSF4NCT6+Ih0XwgjegEZElnz0k/6395A1XI3q1PVcjbaoB7woTqBEPeUwh1S2mUQRDOXXsx/t5NfggNR+HkdRUN7VJRDfVL6OeUJ5MwGqqNWfUbYw+irReMSlaO45UM16+BU5EbLmzrsOmrDLnyo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=i0+MJokz; arc=fail smtp.client-ip=40.107.100.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jwEuKdz5dXRn8rfnwAZ+8kAuy8anFnI6EFsgvuUyrWps5K2gypheezCtH+rpgTA0HF4dqJTCLKGKyqcbtCa+WsBdfZSRHMOSig/qOZcL+l/P2IDekyeBHt0Q+8ek0Mtyy/1ZHzG3MtToKvpqEGTxO8/6oU0YgMx4O/bynWC1Z79/8arsjym8Lj9KdTzSiW5h1wj9o/AtnZSOSNfmfCTRBWhLJ8cQhqrFF+8OyEZaTPpLCDgkS0Dg7asxxYtMqJo2BR0I7kGHKiZJVe/hbBQJyhm/4lvqrAJnjxGRt1QysucWv07NaP8/i1i3Pl8sU3yzQ6UyI2O9TdOn5n1ww0RRaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vs1o0DYcMXSCx5ZUIAdv59kopVKVpCJTuuEjfuMvEZc=;
 b=Sc7S1cjwsUlE5enq1ij93ywPD0Kodc2ESdOySPeAOjDbpXDPt3HVzI5a1khaFZaujRTyX7bOPCrEG5+e1xuwq+ry/4TEJJa8AorqvqXbsrNCdZ+qWoEAdawS8fRbo9kJ5P34wrlerO0npZD1XsohvTRLLNj3l2kNfyEEf8H5a9gpI1sGzeWuZ1aXo0JaIMDa+aZH2tOGyXM6cI6E7gAC6hWWt7hMiSiGNZ+aE9bMgEWKvNlMMJbbaf2GTV1oOC30j5yuoPPRh5OOVt9/ncnmR/QvIG/9ZA9s5fMLGytlKAtOTmM8ksWxuSeQkMYf+NZh8xJJCWcic1csO8Cz50a06g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vs1o0DYcMXSCx5ZUIAdv59kopVKVpCJTuuEjfuMvEZc=;
 b=i0+MJokz2EP1AmT8TGmwq5mWIXyyHkSPSh8nDJGDzVSbVLOnITCdjbgPhcnBSduzJzy6yjP4PC8y7FJJh4xLWqu8zgjK/xeqwZmaU2u+2qtbS1xkNYEkqtJWOY3un4a4GimICUrvBpTzHD7E+97/mPl6N69YpLQ4zv/7bezrno8yW4Tgi/grLdN1FcoiKb6wHzoIeeiNMB0qm0im5McW/wyWz/HOMAtWtFf3GuwYDdV3mkaUPSwHO12OKMFOh8yRJ8pEUMoUEpkNDztzninciL0aBMQv+YlYSzq+rII8sgqicmEq0uc0zwPCcReq165ctyPuD3+KeVuFJcgfVEqqxw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB7767.namprd12.prod.outlook.com (2603:10b6:8:100::16)
 by PH7PR12MB7332.namprd12.prod.outlook.com (2603:10b6:510:20f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.22; Wed, 14 Aug
 2024 12:42:29 +0000
Received: from DM4PR12MB7767.namprd12.prod.outlook.com
 ([fe80::55c8:54a0:23b5:3e52]) by DM4PR12MB7767.namprd12.prod.outlook.com
 ([fe80::55c8:54a0:23b5:3e52%3]) with mapi id 15.20.7849.021; Wed, 14 Aug 2024
 12:42:29 +0000
Date: Wed, 14 Aug 2024 09:42:28 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
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
Subject: Re: [PATCH 05/19] mm/gup: Detect huge pfnmap entries in gup-fast
Message-ID: <20240814124228.GG2032816@nvidia.com>
References: <20240809160909.1023470-1-peterx@redhat.com>
 <20240809160909.1023470-6-peterx@redhat.com>
 <67d734e4-86ea-462b-b389-6dc14c0b66f9@redhat.com>
 <ZrZK_Pk1fMGUCLUN@x1n>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZrZK_Pk1fMGUCLUN@x1n>
X-ClientProxiedBy: BL1PR13CA0248.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::13) To DM4PR12MB7767.namprd12.prod.outlook.com
 (2603:10b6:8:100::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB7767:EE_|PH7PR12MB7332:EE_
X-MS-Office365-Filtering-Correlation-Id: 07c4975b-71dd-4c2a-1a86-08dcbc5e8ef9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6ZF7datA4fEtyWcte6Oj6ZNaqXKCIqMgOpuHTNF2Q7EmI8ef55i1TsL/94+5?=
 =?us-ascii?Q?+ktxU4tOTGlR96NW7U5smpt1vPliOXRdRtJUcEMFNAIegDuBOhIPftYOgLXM?=
 =?us-ascii?Q?CaPa/qrY/ZOxP1ITllejpnc8Kmx5IZK4DRgxJ0qsghEUJ/KxyVpCR1oM3cJi?=
 =?us-ascii?Q?qvuBlnF0wpYjI/frO3VJNdC0UgkHEny0HHhqLv5xPLDRC8smnUwxbdEmpzJW?=
 =?us-ascii?Q?XzBRf95Jqxp7ag3tSYqsdPIGAST8B+tDqYmp8PpJP7+IHuOYIckB8cHvDMH6?=
 =?us-ascii?Q?SzE3kdUgpyDlCc/vHezNCt07QkNN8NKJDQfMoa8/KB0GUA5c/wLT0+UjTEVk?=
 =?us-ascii?Q?2qQIkSkMq6m0OvRmJKIwMjpr/5F1cwwbKPKJCPcBU3ydUxI2m1eSd4C9FG59?=
 =?us-ascii?Q?Zg4UxoAS9eKT1TG2Y4Wn1TO9Oiq6Xo/Un499oTjCLW5fLeF9MF9xThS6j6+f?=
 =?us-ascii?Q?yrW8foDNtV9bUApMWwDkZPM/wlyLizBEJhtNHnrhJSUorMK7VSfU0BHV/D10?=
 =?us-ascii?Q?XJ7+GFox/z2UuCopIuoGmWpQeeOIc1NMEqbi0AeN8HhQwoTIJDg0rGtQ8elx?=
 =?us-ascii?Q?hBfWdDVrst10lFTG2wS1AMAmCgzwQYJOp0QaIRkS4vFCfR12BtR8oshS2Xaq?=
 =?us-ascii?Q?FEmBSXaG3Wd+EK3jd09vVh2AajFn6nf4a2OKXxWzV0aqfJkj9Xy2Zo7lKX5D?=
 =?us-ascii?Q?mwbqHnlF2dFOKO6Dj+aPG3EygY22XY856yE26HbyndF5vhCxOSrYutExX2nc?=
 =?us-ascii?Q?WBg6MwubJqg9Tv/ajArNnNoAAG+U2CGPCzjp5o9+wR1NTW31V1lqlIgfvuVu?=
 =?us-ascii?Q?Wh2QNMtSUBf7vwtb/46V6KfX7xkAPsX2gMFWGy7UhmY8kV3hT3iDbhjlkr1m?=
 =?us-ascii?Q?hbDYLrvVX9EQuaB1bTstDv9iGf2J6P1RcEFx372y0fvMHssxX8Yvo5vYQl3/?=
 =?us-ascii?Q?d8tSjhBLD5rVqLKdFnkSYHarb0FS5wCdCIxzkcQpdvu34LhVAtaD8BkmjoRO?=
 =?us-ascii?Q?uR7lFpOiA0Y5z+GevDmtgykW9ggS1cgbt2DMOMsET/nNhZ8+NuaF86JGs7/p?=
 =?us-ascii?Q?J2dV2PzTOODE6sB6eDaLNUYdkD7aV43J2FFD+1fu8hb6xOc77rV4r0Q05c2i?=
 =?us-ascii?Q?vfU7bq+Js6XO1ri8mFgK0XZdLxFwYJD6VmblcMROGX2yZYW0V5MNyOrLAZ7Y?=
 =?us-ascii?Q?V+Jwx6+Nuwxhe9AONmxIo9in8S+bahcN89+NCOKWZL7Mr52lkezKPbXP+mk5?=
 =?us-ascii?Q?lZJ1V6WxxdsCCyz7mIKiE86JfLbbM2DH1TI88nr+zlG+xALPlWkzpaAB3vj+?=
 =?us-ascii?Q?8pxmA2vCQIcXWn7dIQNRgEgvhEXGfzn/GY7Eo1aTL91EvA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB7767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1bTD8lw0DKJIgfqg08GElbgSzylUYo7JJj5k2jpGKwP8OcOnJhdtpTexXaZD?=
 =?us-ascii?Q?PhA/nkPPePInmEhKajc0IoxmulcVCcWilHVgpgF97heApdZzy53KexAZiLus?=
 =?us-ascii?Q?V7v6H3Ygzt5+WZuGj/lyJ0tVfGPGYmHf8rmtbhL0XwM8r6Gq0W0mApa7u6x5?=
 =?us-ascii?Q?iY7DNRdCH7Awhv1mOXtRtZOl9HWt2Bxusvee5eMwgBeUtFA1iD4qmD6tD0cN?=
 =?us-ascii?Q?b9XY1ldf5DfdWfgOgX4kU2HdPxvqpWnYRVlD8q4grcVAnaksEeDsi44HJXco?=
 =?us-ascii?Q?IBd6AFyU9KazXhPjze2f3w21GJmTEz8JtAohVl/mg1bk0iDlKj4HHLZJOrNI?=
 =?us-ascii?Q?vWjC8cgrN48UJTVNRque2frQC1URfE808wtZd+KNXV3gY66/LJ17z7jYwbdZ?=
 =?us-ascii?Q?K/2AihRQQLVGwjieG3Eh9IgoHApjiJGtBPptqLHN4xNvpdkRfLEMkOfBzAAT?=
 =?us-ascii?Q?x7baXBoK8u6pLF20YFxOELn2E7IRwybuzoaw8UnwgDwauOqGOfJpsKYc55kh?=
 =?us-ascii?Q?VajfxdWEQbSayJGLUmu0mQqQ3zRxbWplsL/PLfIs3EVa0bxMbWhVj6+8FxNS?=
 =?us-ascii?Q?TVDFcqzpyLk/WuXzBCV/8egDQEkjTW3SHaUwwzGrq192Jz/XO1HcnYnafXuP?=
 =?us-ascii?Q?kfJIs+HUqfE/h/7TdnR5fXeoueYsDCzTpm4a6vBbPvQmQycXr8NCz20QSvS3?=
 =?us-ascii?Q?HJ4wPsOQ+RvSxZmCON/j763xiYUsNZYhCFnhAZoDHYlDIUbTrcO4fdxwRE6w?=
 =?us-ascii?Q?tSAqxEy4FjDy+9KXhMB4FGEbn5H4UtugAs6P9zVzVhqJllL2PwjGY2dq/NJG?=
 =?us-ascii?Q?jPKpcv5HSOspF/knF4aZCUifemUfW8GdTLZwQKoSsO2SfMZMnO/D+QKqkika?=
 =?us-ascii?Q?5Vrw96VLSfi7zvxGtWJv3ngJEllhjYqtBGI5jjtC2g6XjDsXhDO7PbdxOITX?=
 =?us-ascii?Q?0QnG6z1T3l+aBoNFk7Wjjz8cT2alVBqd0Hjq9pX0VAlv6PDjn8WjtK5VgUKf?=
 =?us-ascii?Q?iMtoEqgs5tkOKPX7Thn8bIbkAjAqxYFW3xmKAr9IARv0lx1t+uSsxO+rhDKV?=
 =?us-ascii?Q?aAkVUzFgdYGQx5GhhIBRHMGfCqfILE1zStQlHYbMIkzPpKsVEJBtQpGDUW2j?=
 =?us-ascii?Q?0Wx7mGhnCeJehkcAQiEpnXGQC8btw9nBajdOkJ51OYAJMoeGqDxxhQMOe5bw?=
 =?us-ascii?Q?0+RugjFCV86soRhI8rtqO/AvT0cG3nB5oXbNXEzTr50F+AwdJyNjDtlBUMDb?=
 =?us-ascii?Q?k+dGylJNSjqlwChyTOjc6c12ydhOJz6EOB3k0wXvAMdKQoyZ9tl23bXMb/o0?=
 =?us-ascii?Q?GbJt78gmLU2B57L1HILW0NOEZlnMpnQeOPcdsNI3Abg15B/1HAStRGqIkiuU?=
 =?us-ascii?Q?Qruhlz+dHwz0QVgFec2I6TVh5J5K6WWne+5T9JjXak80iIFOFzEX1id7XTgs?=
 =?us-ascii?Q?O0MfyxpUjb8flk1Sd7htc6r3Zp/SblkxeLXlsuvpu+kl9oFpxqu8NgmpCJ1b?=
 =?us-ascii?Q?+McoNXdh78AfX+VO3FZjLkr+HBjf1NscoDpZgmSblZ80a+XMQlRNToQHz7zW?=
 =?us-ascii?Q?TVfv/9YU8YEccXr+jaoVtGS5G26CNhaAzx25llO+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07c4975b-71dd-4c2a-1a86-08dcbc5e8ef9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB7767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2024 12:42:29.2838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s32oaLwVqe/qbqrINZVp7NkUbMnbKAtj7nGPkhvNN3F1LWRXdNJvvUDeiT9rTByr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7332

On Fri, Aug 09, 2024 at 12:59:40PM -0400, Peter Xu wrote:
> > In gup_fast_pte_range() we check after checking pte_devmap(). Do we want to
> > do it in a similar fashion here, or is there a reason to do it differently?
> 
> IIUC they should behave the same, as the two should be mutual exclusive so
> far.  E.g. see insert_pfn():

Yes, agree no functional difference, but David has a point to try to
keep the logic structurally the same in all pte/pmd/pud copies.

> 	if (pfn_t_devmap(pfn))
> 		entry = pte_mkdevmap(pfn_t_pte(pfn, prot));
> 	else
> 		entry = pte_mkspecial(pfn_t_pte(pfn, prot));
> 
> It might change for sure if Alistair move on with the devmap work, though..
> these two always are processed together now, so I hope that won't add much
> burden which series will land first, then we may need some care on merging
> them.  I don't expect anything too tricky in merge if that was about
> removal of the devmap bits.

Removing pte_mkdevmap can only make things simpler :)

Jason

