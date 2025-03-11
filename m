Return-Path: <kvm+bounces-40768-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E28C2A5C139
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 13:32:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 759AE162FF2
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 12:29:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F7EB2586C2;
	Tue, 11 Mar 2025 12:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lLHCwEYX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3C1257429;
	Tue, 11 Mar 2025 12:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741696039; cv=fail; b=O5WQ3U2mP+48L+L+PaAiz8EcpXGmpycvk4m3WqTSB0P/yFMSSlDeqGRnDiY4WsQcwZj/kEyKm4ba26pHsuuIRhJrwELh25SYha3F3gcFScVarlIjP+ppBR2qcB+CIgGULiG6Dp43Q9U9MYPLbG5CsNR/R2Ymyo5s7JOMxsWSLHE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741696039; c=relaxed/simple;
	bh=nElNXvtrKm4C7GkSoNq9bAGITbu0ybxlglk6UyhhzkU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=vC6TxmochG3nRDVJrfoQaYxsSjsnylZdhrQq9Dwp3arga6X13BjLaPRboQLbgZR8MZX+dVyHp0ACYbsjQZSgSGefCuqvP8pPC6UmRm4wcENsBjiH2CIlVd1rVcPrF8dQOtYglDMphvKYnJGR1bkIxCF9xqP7w3Pm5CfrlTw+Yqw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lLHCwEYX; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741696038; x=1773232038;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=nElNXvtrKm4C7GkSoNq9bAGITbu0ybxlglk6UyhhzkU=;
  b=lLHCwEYXSOKGBn/MAjnSrD6L1UUqSlpX0HikS59uNY1yYgblQfxmWOMz
   VEWDM/KcoJghPXbNQDOkSP3njCeK05D3s8cxBefnqx3ScM2jWD4eKUSD0
   qLpPbb1oJVVNnbYr/57YdnWmetVrnM9DB73npvXWWEgALm2kQLBh/pezF
   g89h97Dy58xZ3tKStHYtXtpyfUFoRDGctA7OEi+uyviv86Ibk5gDKx3MX
   3uOOL9kTJa20px8g3d2z+gG4qVPT3zjRxIwN+hmNUmeW0zN8IjrTsIkB8
   sgnt02PKBy0iWdpcDr2Gd3rZwAHmOE0lfRNw4d9NUMbQMegF8a2oZolGJ
   w==;
X-CSE-ConnectionGUID: 1Uqd/XXCRd++QQDg6kDK9g==
X-CSE-MsgGUID: lCjKAJcMTKutpSiZPUr4Gw==
X-IronPort-AV: E=McAfee;i="6700,10204,11369"; a="46379217"
X-IronPort-AV: E=Sophos;i="6.14,239,1736841600"; 
   d="scan'208";a="46379217"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2025 05:27:17 -0700
X-CSE-ConnectionGUID: Ibot+EsiSyyoTE9EAypXcw==
X-CSE-MsgGUID: A+Fv53aTS96LuBCRt60DuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,239,1736841600"; 
   d="scan'208";a="124480958"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Mar 2025 05:27:17 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 11 Mar 2025 05:27:16 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 11 Mar 2025 05:27:16 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 11 Mar 2025 05:27:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=geokOZ92PeY4DNDfDIiXIkAU2o8QYsZvQefVKtXN7eDbwwYoU6EEiSdbK7DeLAh2/Ib5v0EUCAjDEhn65aVcSFzCdNtK8X/gRyWYCx31g6+VVRulVcO3E9PqSoKOEjFCMoM0jLzFwXaf6iKWbZUK8Vh/VL4lB4z/CBsoKtRmuf3vQnJ3Jw6QJI48JWcvk1ceaCQ6V2jhveYrUis0EDkakE4+W48OgWrvDbwVGenbBoV4aNhPYEEWkhDNfVIn5Oi9CXk5jPyo5NYZ09824Ic+x/FWlkGCNlb0glt0aO7mRw99mYWoUB60xo3J2454bMpu339XFCB2STYKExHcGdIfzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q/tV5humYl8kGoLM4TetUNkdlYep6ck4pQHJEjVFRLA=;
 b=l15tBjJeaWkVpAQT7qNd4eOHy0ItYViZiO1dLxk2qnv4WVyyYCMrlA84egZw2tqMXG5HzssU1vqM6nwNg+ZSOCovHPFcIdOGYBp6AejyoYTrht6aRuQaJnzSePw73jXKzx6q/tfpbpwHvg+zQ5LdXPSOZQIdOvGI69agjkpi7pVNtLdd51uY8fo4d0/keD6lzarlUBQWTkDXS5xtj0uSqvqcFIE+8SPAqFp4bVnoPjXuXadymwJ+ndWvCycV49ZOQzZr1qry/nyIx7qT/qVU3j331sMgc1HNf6TugWZoTsDbjjAgv/x5LAewoCL6Xg0iTwQIzl/gY+D4zB3HORAJ3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CO1PR11MB5105.namprd11.prod.outlook.com (2603:10b6:303:9f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Tue, 11 Mar
 2025 12:27:14 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8511.026; Tue, 11 Mar 2025
 12:27:14 +0000
Date: Tue, 11 Mar 2025 20:27:04 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Chang S. Bae" <chang.seok.bae@intel.com>
CC: <tglx@linutronix.de>, <dave.hansen@intel.com>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>
Subject: Re: [PATCH v3 09/10] x86/fpu/xstate: Introduce
 XFEATURE_MASK_KERNEL_DYNAMIC xfeature set
Message-ID: <Z9AsGFF2Rs0lCC9/@intel.com>
References: <20250307164123.1613414-1-chao.gao@intel.com>
 <20250307164123.1613414-10-chao.gao@intel.com>
 <e15d1074-d5ec-431d-86e5-a58bc6297df8@intel.com>
 <Z85hPxSAYAAmv16p@intel.com>
 <7bee70fd-b2b9-4466-a694-4bf3486b19c7@intel.com>
 <Z85+PPhKnkdN9pD6@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z85+PPhKnkdN9pD6@intel.com>
X-ClientProxiedBy: KL1PR02CA0006.apcprd02.prod.outlook.com
 (2603:1096:820:c::11) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CO1PR11MB5105:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a8f1f82-fdd4-4f13-f12b-08dd60980e0e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?HPsqln8Luu5GSbPLxvz72JqOOQzOKtihuWO1jRj0AEutrdtoPoXG3yeYehvH?=
 =?us-ascii?Q?KYatQWfhH5bKKWVqBZfrZKOskX2wSSdv5dhxS7CyjJ8GguIoLa2cZdEVJAiB?=
 =?us-ascii?Q?jhsUDemehA4TROijc8foBLavyn4zDelPMNUZA03uwjj6IxZH7AJhoDWFnjLI?=
 =?us-ascii?Q?iLVrCno7pLAT3PUlhhTVDdErQiqDUvkwLih+D0OZn8xv5a9FB3V5PTNwcYr1?=
 =?us-ascii?Q?Mj6/bgHRiMwAqoRJTEMl0NyFwOr0RQswtpOAYVkCX400P72Owvp+TVQT3p/b?=
 =?us-ascii?Q?YtoKgs6M9265uMQgENIlzN2CCYjY3nZXoofzZVW0xf9HWDUn+LxNFk2wXorO?=
 =?us-ascii?Q?BaLiIS9V+GlSJE/EluYk7s0G2ScYmysX5blYB34WQMPhp7y2GEvoYKyg7Pkc?=
 =?us-ascii?Q?L8uLg2LMETgxZ6Oxx31nycQmkEwuksu9k71mQjve3ONw2rDJPN3YpqiXmwZq?=
 =?us-ascii?Q?AYZnwt3IzQAc5ECNPS7kYuLU5Ttf2ZrXcWWhimeM6iZ8XyYPqwMuk8ggsdt4?=
 =?us-ascii?Q?RKZDI3VJxLs8M9xqS8yka1ZK2s8JpF5eBY/A88MNPVNMaCyzFrg3wjxe+m5Y?=
 =?us-ascii?Q?It+YCa6Ud6FTMUf7SGEzWmUUTFosrWU5OyUmMOEtzVOF839UUSSXrPuESInv?=
 =?us-ascii?Q?VvRIX7kTvzDoJ5t6JlECQgnsjCgPeX5QIuhN1hVWd6NvwFnG8AuxEhjEi/Fq?=
 =?us-ascii?Q?TqGwMH316NkaumljNGhZG92aWwG14OAgZ2aQc7zfEKgR/t9YIgH9WEshFfOg?=
 =?us-ascii?Q?m9D8JWqhZKQ4XkwrbjqAaPQxcLX6NJ1H6IeP9ChJS+VNx7oghCiN96UzxpIJ?=
 =?us-ascii?Q?QIWJtFurzoy0lciQ+STMOo7yyqIp0x9bxTK+KCHwAJqIynRuGX6CIG8XhDXY?=
 =?us-ascii?Q?FBWAyfXvc+6ZIx3swgPmZ9MZkCNLKTjg8adjjyR0rsDZfWN5b3xXvmM09W9L?=
 =?us-ascii?Q?BierzQ7lhmYpQh3mvzeUSqvt0gd83EbVj7wKfgthGsY42Kt6ddwHN2J3GpQf?=
 =?us-ascii?Q?uBCnxCIHqMyjcp8/aLGElDmXVBYeRMT8wygF8gFw8S1pxs7W3MhlQ7Sg4hnf?=
 =?us-ascii?Q?zNTguaoKKuNphKvmeDpVH2xsdZTU620pkS0MZeYpEPUW6Lt/tB0DwzC05hnP?=
 =?us-ascii?Q?uo4Z6kD/tf0e7YqbT1N626QwLQ8vDVxFilJzFIoObpQS1JxRDAnfflm/wQlx?=
 =?us-ascii?Q?T+ERrdqPOup/G0Buuixxc4bhM3oxxETcEYVM9Ap43n8iBI6ZhOIkI/STfLsZ?=
 =?us-ascii?Q?KtTftUGjjNQ8z8t14pHhSw9bTQIqirabalfrRRxyfpXoVBhDyF7hs2B1kyTv?=
 =?us-ascii?Q?2CfxP+4SyW4ApWK7WNFBSxncOmQhifvwTmJL9znok/uq+Ce2Ue1nfQTGpgij?=
 =?us-ascii?Q?1hsZnQanbpQz0c6GCUXeebExbuMFCJZ1NViyQL7Xci4+Lz21Kg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Px+VUnX/VpCkBdVtbB6TwK6DUgkO3gcFNDZkKFvXx0jHF2qMP8cWnSVQEieL?=
 =?us-ascii?Q?EqhU+mzr37Ir12asG8Y1al0T+TcK+kJu/712Dy9oOhMykMkk+P8yrizOGeGV?=
 =?us-ascii?Q?HKa9AYHJo1JT0cgS7ZffwOXjJ/iIdVA3lspEPBzDaKnhfhpTzHrHIsUiLWTs?=
 =?us-ascii?Q?USOIg7mz+7WpvqPZfqYUNLfgaVbpIkdjLVPhVcu+vPHrojI3D158J0UQLtVb?=
 =?us-ascii?Q?yUe2+zrDMVwIxCErpLSpu9FfLrD77skyV5xprfZzUHUHlHJoXbLN8yKq/Ih8?=
 =?us-ascii?Q?aHPVgW4XaC1g2xAW4B/eUVekmcpMxm1RobduZAoIOJfOqunX+z50Ta9T/DTI?=
 =?us-ascii?Q?L57IPYj+DtZLEhq21msAIG+sGQpaI2RJR3Pg9SSqfFiUHujY5oqlJD9//vOz?=
 =?us-ascii?Q?IY/H84Xw+UdHhLThH44i0KqJAxDXjyC1/FB32MQoVCoeV7Z4Iu12kOz0X7BU?=
 =?us-ascii?Q?37ouGdhmHSsgmOFAAWu54c3GUmLTSqLdU7rWbfyYm9yljNAzaxnmOZNQGSHe?=
 =?us-ascii?Q?oiKg/t2z16H4QE3v+VCq35FXk7pzmEjMRgbbydLa6KQXtfYIL/3s6UY8Ee7W?=
 =?us-ascii?Q?gLdgHyQmOA4QtvFYPje/vL8Gh8rB4BQL68tcGa2qiNPd7Ae3nfqmd9gY2H3r?=
 =?us-ascii?Q?NcnK3h6oIL3izUJ0oCY9msSezSa3WBQxNGgrRj6G5oC1iR8ZM8aaVE6Dl4/s?=
 =?us-ascii?Q?A2qZuIIz8WEVnWQBx2Qc+cImb1V9YFx/qpXDA3mrWOUQ2yeRazYTd6AMUeE+?=
 =?us-ascii?Q?U7f0SOmdBGWX7b9kSL69I8zolYCP41kKxXnwPUbuXMgZseiP4c2VGKAHdgeE?=
 =?us-ascii?Q?7jLSTxpxxrTz6sFhMSEgmJoEjMj1Y3HSdatD/MBdQF5UG9qfa8WrIfqfdtCR?=
 =?us-ascii?Q?pE0FoQi6ZiA9w3dLge5TAakJj/tqEDw7HYYcKtB5ircQncGaWJ3kIZt16cXK?=
 =?us-ascii?Q?4K9rVJ2pEFJXzD0WCZNwPwczcpf671FLm9CwOeY7yzwx30qC6vGxLktSugXs?=
 =?us-ascii?Q?lQARlCJkgGtPOJUkFxJYjq1ACkcs9f1L7gOHyIjgcGuKRwX67oUEdxD5pUNk?=
 =?us-ascii?Q?+YzkLp43UZocQ6HmPpZu1doSgipu6OZnZy3ibQ8kMDymd6qwuPlKwErrjpR8?=
 =?us-ascii?Q?5idEJ8CwR/Uff9mYqs+M31giENNMd9aplmBjm08gTMhfBLCOvp/2T1r9+oMf?=
 =?us-ascii?Q?aNYbxjMvxLOJZjuJUSSw5hrNdazDNhGgE7prkpLmnX5XJcjN29SEcro6cPex?=
 =?us-ascii?Q?lr5dUEAWAA51rzhH68km2UKSsNrT9ceaNaERlh6hkR2T3iBPFaNpZaPSO/fG?=
 =?us-ascii?Q?j1iQN8VIFCGts0BNGn5GWzPeENcVmXdeM4PoGmEcn4G9POnHjEbwCaek71kA?=
 =?us-ascii?Q?55XLGa1jGXKK5d3W+8AAIjllOQKnVpzehoSE3CMp+EeO6yP0wvnP/8VnXNII?=
 =?us-ascii?Q?WYwlxRgebAwavR5l03iPOHESHFRMkqC07X6LnmokTxkeFuvdjh5TRr37lbRQ?=
 =?us-ascii?Q?DS5Rb/LW3ej4Uph3ZTVmLqhOWeGDcskthkPAeksoK7xGTC85Gt1gDVSYqSf6?=
 =?us-ascii?Q?C6/ZO7bQSwd/lZYJ8dUyPzFeC8Ft3U1pSGewZ5OT?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a8f1f82-fdd4-4f13-f12b-08dd60980e0e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2025 12:27:14.5168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mLHN0RwV4qIi9xIbpAxZCTmLpff/Owx9t+lUqo5LJldYN9FO7FQhEdx+YoTbfic/XJIob3xRDuy6IQhEQ/Bz0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5105
X-OriginatorOrg: intel.com

On Mon, Mar 10, 2025 at 01:53:09PM +0800, Chao Gao wrote:
>On Sun, Mar 09, 2025 at 10:20:47PM -0700, Chang S. Bae wrote:
>>On 3/9/2025 8:49 PM, Chao Gao wrote:
>>> 
>>> It was suggested by Sean [1].
>>...
>>> [1]: https://lore.kernel.org/kvm/ZTf5wPKXuHBQk0AN@google.com/
>>
>>But, you're defining a kernel "dynamic" feature while introducing a
>>"guest-only" xfeature concept. Both seem to be mixed together with this
>>patch. Why not call it as a guest-only feature? That's what Sean was
>>suggesting, no?
>
>Yes. I agree that we should call it as a guest-only feature. That's also why I
>included a note in this patch below the "---" to seek feedback on the naming:
>
>	I am tempted to rename XFEATURE_MASK_KERNEL_DYNAMIC to
>	XFEATURE_MASK_GUEST_ONLY. But I am not sure if this was discussed
>	and rejected.
>
>Thanks for confirming that the renaming is necessary.

Hi Chang,

I dug through the history and found a discussion about the naming at:

https://lore.kernel.org/all/893ac578-baaf-4f4f-96ee-e012dfc073a8@intel.com/#t

I think I should revise the changelog to call out why 'DYNAMIC' is preferred
over 'GUEST' and reference that discussion.

