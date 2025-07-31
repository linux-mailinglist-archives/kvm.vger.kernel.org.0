Return-Path: <kvm+bounces-53794-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CADFDB1701A
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 13:05:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F13F817FDBC
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 11:05:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 911842BEC29;
	Thu, 31 Jul 2025 11:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NB/X6OgP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0552BE05A;
	Thu, 31 Jul 2025 11:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753959924; cv=fail; b=GTSlaG+tvtqSIaD3zjUzlREFN26zlIm/9wvkhQzhBXYwWRNPLHRow6E8eInWQIm4RFYfWL5TUR3hyZINE1DhVATVzSzxm05fBowDkg8yK8FuqhFf8RIGKoKASIPHwZyfMcV0HdulCZjAEp158lp9hR3Wr/3bPbTHc97aJcuVZH4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753959924; c=relaxed/simple;
	bh=sVDMPyDB+HShhjPRzUpue16nI64UWNHkMWqryNcj1mE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PCVFaXy6UvZ16Lngv/VDW8z/+Q5aNBwznRipEAfnSe4P/wU+ecuFtkc/fVA3n9Vv89fAy7DYo8iZJL7BsdgrmoT5BipX7UA7ic3rgAR8d8sCfyKrHJlnBi4XzoHVcpSg7fAUJ9NFaGOW0+ZVZFItPyWoR2Ydmy4OjXcO+tju4j0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NB/X6OgP; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753959923; x=1785495923;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=sVDMPyDB+HShhjPRzUpue16nI64UWNHkMWqryNcj1mE=;
  b=NB/X6OgPEtKFVPGCpCpxyReElw5fSqRz9zAXK7eyuOM4ykpMJaSp8vjL
   pAnArw2sKTPvuBo1NsknuIsfWgouyP2wHXw1XQp29zxpST7KOzLe1gK1D
   s3Ac0pcbPuWD1aqrth3XUg4ZjfR9ZFQK2pYLFtAqlQbVLoiAToIoHtsT9
   0vV0ksdJ8Asl3RqSO1pZIC12ApWNTKLX23rbhfm78aoBdAjTsEkNXn8pe
   MYtkzC636brZwA/ZNaIEnqkIMZijAtpMNcBGX6juj+W7BxQYKLuACqc3n
   kR3+R01Etk4qh3o+MNO7+25td80Mh8wGLwF65zDfpo4btrusLGxlcUpNo
   g==;
X-CSE-ConnectionGUID: EpIkdvqSSJKBQIe9Kvp69g==
X-CSE-MsgGUID: RcP2m1GaQdeWAKOZeJeGpA==
X-IronPort-AV: E=McAfee;i="6800,10657,11507"; a="56211142"
X-IronPort-AV: E=Sophos;i="6.16,353,1744095600"; 
   d="scan'208";a="56211142"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 04:05:22 -0700
X-CSE-ConnectionGUID: PI2CNpguT9WQNQjSphLIJA==
X-CSE-MsgGUID: qQ5Z8uS0Qm+sEEz5i5t1qA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,353,1744095600"; 
   d="scan'208";a="167416069"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 04:05:20 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 31 Jul 2025 04:05:19 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Thu, 31 Jul 2025 04:05:19 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.55)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 31 Jul 2025 04:05:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DY18UJP+TVefL7UMtiTwAiPiU9EJpirxbTZd3aNJFiZK+zvuhN/6dtoXnVfMZ+uB7VBP4qx5BPnr6nlPhYlPpjiD17XnXpBhHtCcHCwy3PsWScVbpOPzu4RIin1MxzkVKBKaUWZjBME9WWQqjeY2aAc4wtSQ0GwM4FgEGGXi0n+Yyt41TA0f2n55C1s6Hr2784iXL8JuFN+sjCJTznBandYVmqT6GGshqIZhcNKEGAtkp8EnpR8WeWotowQ35jPZq+dgxfYDvNk4dop2au1JqDh0UQ68occ+rN63vKn7UeaqZDHkg/Xz6H+4xiMgNTVtGFERipFbjfpYeVgPy2Bzpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sVDMPyDB+HShhjPRzUpue16nI64UWNHkMWqryNcj1mE=;
 b=HpTaPWxi8BaDcCaZU/ZSCHV7kT9aXRDoT4erwmPyxqgYbsAnfWuDVN8mF+0g9QsmmVjFWKNCCI2ZKRppUf5n0Yqt7bcU+IqZc9jScL5WDV4zoNAkzozKwRZ5KcJ5SYE4TMRwU92aClhd2QLajdxoZYA7Wyge4gbx7dUlIeXoizL7SrrTQJCF3Q+3d61AYk44IWQb0mVWd7cmebT1nOw86iZpY0sx4w0LgjbokSBErCTeE6z4rcCXs+mjbZkWuDOEYSvPdCBZX8BRUYD28uUuUEeFp8TWQie7CUu+jN28dcVN3kLu2uNRBaF/p5lUm/5Z6LMEosr5IUh6QgHqxppY/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH8PR11MB6562.namprd11.prod.outlook.com (2603:10b6:510:1c1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.27; Thu, 31 Jul
 2025 11:04:32 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8989.013; Thu, 31 Jul 2025
 11:04:32 +0000
Date: Thu, 31 Jul 2025 19:04:22 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Xin Li (Intel)" <xin@zytor.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH v1 3/4] KVM: VMX: Handle the immediate form of MSR
 instructions
Message-ID: <aItNtifaItfXhXnu@intel.com>
References: <20250730174605.1614792-1-xin@zytor.com>
 <20250730174605.1614792-4-xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250730174605.1614792-4-xin@zytor.com>
X-ClientProxiedBy: SI2P153CA0020.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::19) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH8PR11MB6562:EE_
X-MS-Office365-Filtering-Correlation-Id: a249d4c6-211e-499b-bc9b-08ddd0220705
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?iHZ+SjC6QzPycjfE2SaAdM5+Dkb++N0aqS0SeHolpz8e2LAIjlMLC2qx7ngv?=
 =?us-ascii?Q?wsINOBEYf2J+5okdPIv0UYnkVholQKFdKyGSzTspYkgZ+Pf5sel4XeTaVoZF?=
 =?us-ascii?Q?93lCANgFz7VpRfwbcv7/F5CvsSl51XROLbu4GejCcIoCFlOQEzYxAKA8F3wr?=
 =?us-ascii?Q?8gMV+K9p6sFL82I+kAyLit420v46OcoofvMCVB/i6LwNa2ef/XuSsS7L4pf2?=
 =?us-ascii?Q?QXnnDtWIG7gNQNpvJO6bGxkgfhvmgnlDBCowBCPm1awsnxUc3fSWUbM2vmOK?=
 =?us-ascii?Q?TTwl/2iaDipQHcS0XTJMm9HnzTtOYi2jxkwNP/7gAX/pBvk9DM67XL6G3e11?=
 =?us-ascii?Q?L3kXmntKrfzPu75F9BgDiUu1Ja8eRws0jxaQh6mdf5eXXpvHkBcyaGtCrxTN?=
 =?us-ascii?Q?lMLfvwkZOxb3qTZNWxX6zHX1FtqLPrnSnbUF7/kwV4aoik4NZzAlRZuy5Tv3?=
 =?us-ascii?Q?+sQB8LpKo0d4YEa7rq54NhJ31tsWJAwVGemuDf+s2JG0+2fopiywuf9JafCu?=
 =?us-ascii?Q?CiJU3lDKRx4e+IdQ0eMCDH81/0bWqhqqeb+jgAqah9pdBXy5apodygVDdTs0?=
 =?us-ascii?Q?tH0Hy8y47Tdfl7k0NDbS5YlvynyvuBFWSRWJihMeFmWjFFdACNpPKGmr8Bpz?=
 =?us-ascii?Q?1FLsDa6e1PU2dh90jkeTCY5gbrTSIl9dt4SiKXdALT+I71uj7X6BLWZexfpP?=
 =?us-ascii?Q?k/jpwgk7Ak6A6KGgHq9qCXWm1sb3ueFMM0U5Jrz9LShDBj9gwSefWYek1Cbi?=
 =?us-ascii?Q?PnVjWv96MveTaOR6mF6P7G/Ug7odC7RCxkbZQCWr/aGFjq90Gz5QOYoYzVbA?=
 =?us-ascii?Q?Kpjy3GkdcmrD5mCzubiiW2AyP0/MVJezgchLYDEuwy4+karWGaMV93BmAjU8?=
 =?us-ascii?Q?cFD+Ad6OLlHwp8wo/aRrb8AeCYtp/fra8h7p3kJQyeVtbq7Q5eDWVo3bdKOv?=
 =?us-ascii?Q?zwLfsViO/d8x8F5rIes+PGFirGLmMZa5QChhtQd8GuC0juEhiOWE3zDaj1ef?=
 =?us-ascii?Q?8ZrgYKRO028UP+jOlaWSlIimwWaUOGgNhJ5cB3HUiOx3SuYiomE0LcBdQysI?=
 =?us-ascii?Q?jIduD6yPEEWbdaM1z/EGPMb/0WXylI6F5aKkVZJq1XXwhvqQQUTMIjqmtKP7?=
 =?us-ascii?Q?IVY+NhBfjXWoaAElNQZQZ/uBrN6NW387yi7ZafACvuFgX1R1Ye6onx17jasw?=
 =?us-ascii?Q?TfIDs31e5HVmwzgddx3d2ELSSg5FaCp2zLjYISS2Oya3eK/jwhfLjsEPlZdD?=
 =?us-ascii?Q?FFzxuNolkmPeCdPBEQAevomPUbftuWafErxfb/+D0tg5nypfjV3+5DmVEGEk?=
 =?us-ascii?Q?KffiNsnIh6x6AsLJeVXLl+7PtR66O1DuuSdGftn3TpT4uYz3YJ8BSCxUzlHF?=
 =?us-ascii?Q?SNl3uboXRVw8igHNfsIjdNxDqCVNDoefDViDuL3iJiQ+1yxQi4pzendv71qg?=
 =?us-ascii?Q?C0k0WjyIO8I=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oo2/rLD1UqiDRNvx6njNh47r6EmWguSRTJVRRdrAWgYmFTWZMVh4Cuy/5+rb?=
 =?us-ascii?Q?REMH+ED33ZaXv5wEIn3UCee6fndXIyR4qmk22CsbNlAmyKyInwXI//0/UiR1?=
 =?us-ascii?Q?6u6fojuxZveM2IjrXG1WeOSVlpz3UrIuNJhPSyoqcK1Ocsi+Ejw+YKTQFDs4?=
 =?us-ascii?Q?tHmaZN4g9jqaLvaqL4uvtrb7o6bs+XoS3KkDJxc/K4qr+Y3/41fzRPMnr+uE?=
 =?us-ascii?Q?G1K3/TrGBdeUCuGWT96BNqMyGB783I3s2IvNAIKBBvwBtngBsu+6JskUxNml?=
 =?us-ascii?Q?GOLnXGsNCDCN/2zUD0xZ3zLHsQeI1DPYZ4DZCKLW+1V8m7/uW7nDyjpklg9W?=
 =?us-ascii?Q?wxtNAGULk/pgL22DbZVMYh8wPrytdAe0OsGfUvrFkxj9ii9wlBuQKPlpaK1M?=
 =?us-ascii?Q?u03jvUX8Xa1pqSWQsVgoK0A9yhGEkW/7ku3b2HzsttOtQMEhN9iDv2sDauQO?=
 =?us-ascii?Q?UUeTpVICtI4xG+RxPcbzp2qgY+MPHhDsfZq/MBSdd4e+Htlk83BcztYv1Wp1?=
 =?us-ascii?Q?iLxZO8fIBD+HklWGAmUYv4+tbINBUHVZ4U9MZOfet+ItnxPWEGuXl+aIS+/4?=
 =?us-ascii?Q?n7lv55zHemUTa+tllGnFF63y8X4xfcCck/ux5dBOm8YZijnnPoCPrm0X2y+a?=
 =?us-ascii?Q?59dfeYbsoPbr/948GXK9XuVnhkYYH5SKASU12FvpLooPy9ew93E0zmB+C5dl?=
 =?us-ascii?Q?hbEO8/bmDnlHBxSXLHu/eI/c5cYOaLe7fCS5ZOIyuZGqxvIsEmWA6lz8de+X?=
 =?us-ascii?Q?HNOvVnUyV8OnUj+/ts/XlXjoyr62W6fUVf1Iq3MUrm2vd8GakhUsVFpRf13V?=
 =?us-ascii?Q?a50NpcogK3UaPwI5GUJMl+C3zblTjA+FpYbkVik+j/HriPlkpjp5UbQIE35K?=
 =?us-ascii?Q?RjVZQOkUAAwWS2ngEfn1tMfGq4/Ilixnpb26q5czg2meWumHukE6RT36hXdD?=
 =?us-ascii?Q?X6JrX6EOXA7dbEtMo7tgud5JHw4cs7a9BXii6RATqoJvLeiG0sEX2quPmD9i?=
 =?us-ascii?Q?K8BcV1PZbY5pXfxD3pENClCYRVDH/Yv4dPZ6WIZTqeqSEGEPE88m3tMrzWy8?=
 =?us-ascii?Q?oP3jKpr8h8m7ZPlcKUlQwBM4A/GEqHts/pNKH5+XvEjvTRDjd/DH9Dx8KWI/?=
 =?us-ascii?Q?Blvbz1sIPWwxxUSJzO9wGsVPFXUaCHS4cyyPH/VNuLvM3WIahd41cEHs4ioS?=
 =?us-ascii?Q?YfTLusNrHTL+ii9QIANJx/L9tVBbldafbA1dkX6ndXGSpm5ONzJuIxx/gcXV?=
 =?us-ascii?Q?jiunZCxZMVJ23qNq4w+IBgUfd4iWrRzocyH9rdRK9Acfi/38i22luT3wtEtV?=
 =?us-ascii?Q?2QqR8BPDjipLWxJK4qKREokkpUREy2hfR7vXYywjXc0uq+FmcaO7lT6mdhjo?=
 =?us-ascii?Q?FL2DuWBThfELyGDu/fC6m6HUo6tC68XCN6FAu93bLHzPzgs/2m4lJ/0TqHMh?=
 =?us-ascii?Q?hRiBW1Xju33TBfgxFjmmZB2uBcf3UQekrUWJknC8Nbbnblob+xnkaOU6ermt?=
 =?us-ascii?Q?RlkiCLrvTzZaYtv8nZFkOXvHUuK8tFmcj2Q1UqBaSK65hzLv7BGbQjEDmD7/?=
 =?us-ascii?Q?g+mYiCUoz2C7MijWGuA1dEuYF4MWHkOXqAHK/yr3?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a249d4c6-211e-499b-bc9b-08ddd0220705
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2025 11:04:32.3442
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ttzcm7yP9UnSs19+/SHNTAlL7UnXCm6Sqkm6RqPsB/b5m04wEAxsVifbb3o2Cd4mblQBzkK20ubs0TdD08526Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6562
X-OriginatorOrg: intel.com

On Wed, Jul 30, 2025 at 10:46:04AM -0700, Xin Li (Intel) wrote:
>Handle two newly introduced VM exit reasons associated with the
>immediate form of MSR instructions.
>
>For proper virtualization of the immediate form of MSR instructions,
>Intel VMX architecture adds the following changes:

The CPUID feature bit also indicates support for the two new VM-exit reasons.
Therefore, KVM needs to reflect EXIT_REASON_MSR_READ/WRITE_IMM VM-exits to
L1 guests in nested cases if KVM claims it supports the new form of MSR
instructions.

I'm also wondering if the emulator needs to support this new instruction. I
suppose it does.

