Return-Path: <kvm+bounces-23930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CE2A94FC4C
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 05:35:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8CE511F22B87
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 03:35:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31D9F1CF9B;
	Tue, 13 Aug 2024 03:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Fmh7kCD3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ADE31CF8B;
	Tue, 13 Aug 2024 03:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723520121; cv=fail; b=RXYi2CbHcWez0Ph47Tzmmm1doF5UGLKlabXUwUhZnzr0eH5UyVMTgXjEhTY2gNpIqd12KbaioAoHMedaWq8uWBVmLDuTBTJwHZVMvoAzpPXWBJ463i8IrArOHcrJoOUtLDIwPipYuDyZVAMWyQ51TmWF4kI4pNx0Q+voks7h3ZY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723520121; c=relaxed/simple;
	bh=IqSDee/+TvhtjKMDxkYAmJ6CaUgICGJ5uuoqlB6Qxu4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tnQuS7UZIFKHXw6LbSqsYWcQZBhLIWNj+tCaHxMas+IPg/WehM4aNKQ1QUQLoHb0ZZALe3jQE5IFUlfVdUOSrw2QiBCQ3xZYtn96FK1XuQynDiMu1fNWOFeqqPx4FEjHkEAfTBNm9SJb5mM0VDhN3vBGL9JPbQIKfYAcbM6cBkI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Fmh7kCD3; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723520120; x=1755056120;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=IqSDee/+TvhtjKMDxkYAmJ6CaUgICGJ5uuoqlB6Qxu4=;
  b=Fmh7kCD3roHsSjf9BGop0H2Q4K0mXqr5LuziNXdUScaL3Wt2HYYIbgqa
   qL4JfsNi/ba/+bwNmB2DPcW88WT2pGmPJY+rlUwZnDMcQ+QrcK+8xgLXe
   cSmP49vC7kwnMiIzPXyI9YVush/fCHATy7mH2Su/2EyBep4w9zq1esAq3
   nc8A7jsSbrxwU4b+aigMAcZva8fyJo1F0Zck4AaThnKEXVMTxa0RQK5sd
   zmjRcoEMwu6fg9IN5SO/Igyh/yqVi/rmrHGRyeWfiiyYwk6PlFfsXdzff
   VRCcv1JIw091YaE8bwwM1ucFUE7XoNa7RpbQo+lBLSREimJucoRLU/xiO
   A==;
X-CSE-ConnectionGUID: YiUveRYqSQ6Dp94pkyGRwA==
X-CSE-MsgGUID: jIUZ7AuORzCaAWab+Ryu1g==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="24569470"
X-IronPort-AV: E=Sophos;i="6.09,285,1716274800"; 
   d="scan'208";a="24569470"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 20:35:19 -0700
X-CSE-ConnectionGUID: LimBKSjoTJe0Aqw7+ayshg==
X-CSE-MsgGUID: HW3J/3/kQyOhl/qEjq/c8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,285,1716274800"; 
   d="scan'208";a="58482750"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Aug 2024 20:35:20 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 12 Aug 2024 20:35:17 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 12 Aug 2024 20:35:17 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 12 Aug 2024 20:35:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IPxbRKgp5WjYtPDU15+SlPSY8LMzD3Zm1dECc5mA0B1JDV59nYh91BE0ShS8ueENeDuJmlh21dPWA31omoQWfXMc7S6/zIfTuLZV6vJRgzG5LGlXH6jSHdycGhAeTR7BdiFzMMxU+l/cGfkP5m314Q6wypziKn3YaRbRPHUm6j/i21clQNKTBDVwUtaMUcZz6IwBA+NQUZO9dtDg5PmMyu+Qm7Let0QirJnkgSTVAieAUXwACuF0jDNuyC/DrnKvTYmETlKOboxaMfFY5GinEn6FDb7y+Udnn7YBO6oKQCJl1qrjreu47toKx9JJMIBpIQG8Lph38k18NSnnto/Txw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+So7nW9/HYtPHKnbLhhXxXUfIIa+WC4Ni9H+FuhxJVA=;
 b=Rq1NWIHWXJUOlJmQX2d8Vki7AlUgHOHQ76Gkd8iQAri8gg385u0SmLyoNFRh6Q76aScSXoOvF/94R4fV1x41Q3o/aW2YbAGEgi8oNBFtPRI7Jlv+Uogr8Kp2vTsbpli+YPeKuX8ngHu9OC+xd0Fo0PJ1ZAm39pcyGUkoUbGxuMM5mvxIrRmStCQUnZLHZWFv6mjzowYBsKNYkwLk1/4iMAXKju/6haoZk9yCSJoI0BPl+SiaQnugzCxgkxzHmJCq8y2wrehfte4EO7Mjjgy+tTCC05Mct41+KdVyFa/Id/jS+RsoudBAuPGDtgimM3btOrbc9kOxXhUeuUq5EiCT7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH0PR11MB5014.namprd11.prod.outlook.com (2603:10b6:510:31::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.31; Tue, 13 Aug
 2024 03:35:14 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%6]) with mapi id 15.20.7828.023; Tue, 13 Aug 2024
 03:35:14 +0000
Date: Tue, 13 Aug 2024 11:35:06 +0800
From: Chao Gao <chao.gao@intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kai.huang@intel.com>, <isaku.yamahata@gmail.com>,
	<tony.lindgren@linux.intel.com>, <xiaoyao.li@intel.com>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 11/25] KVM: TDX: Report kvm_tdx_caps in
 KVM_TDX_CAPABILITIES
Message-ID: <ZrrUanu3xYZyIshY@chao-email>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-12-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240812224820.34826-12-rick.p.edgecombe@intel.com>
X-ClientProxiedBy: SG2PR02CA0047.apcprd02.prod.outlook.com
 (2603:1096:3:18::35) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH0PR11MB5014:EE_
X-MS-Office365-Filtering-Correlation-Id: 314826d7-9fea-424d-a31a-08dcbb48f1b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?G7JhWFT2EsPIz2BC+ZNQyTwyw/z79Jbp8iJZpoZFcVG/aurnd6M7VbGLIlYx?=
 =?us-ascii?Q?SMGwBKjSrlXNoTwstDBS3KelGuXvtcmetOfBAZFdqfkZOExyxHO6j1Yhboaf?=
 =?us-ascii?Q?jZFV6IgiVVfeYa00FidJ9SLs8K9Win9v1VN6dMC+j0/kNTf+/J0RJbBlqItB?=
 =?us-ascii?Q?mAYKvz+TOLM0WAxVWWxwsR6f3QlCkfWpe9XUFN8nzS3SUXm1BdfiziaPGk8i?=
 =?us-ascii?Q?q2vL3YZHNGLabFYIgbhgEDNj/PE0TgR1ZapuPn9SAiYaWTPSfRGfsCccEOq8?=
 =?us-ascii?Q?Xk9JINsDcrtfSPARBaCiFZemdbEYwCPUnP8/m3tZXJAwB3nuJqC/pMMRNtXO?=
 =?us-ascii?Q?Xt7GPxL2ekge7IAGtwNvWfJKGlDd1bDZHp4v/LEsaJa/n5KMtGJdPMp3C0ct?=
 =?us-ascii?Q?L0Gw1xDNVRWKkoQ/I9zsyedNn0mJSaNPfS+XIE/E5ttqfpwZ3m/3ygvpN6Sp?=
 =?us-ascii?Q?IajA33V4b676LW01baGQ/hhn/k+yt64Ikgi9BT5KCVnoP/6BPshp03E/OiYd?=
 =?us-ascii?Q?klnlUgrhZyxQ6P13Q37VZ9kvfkUtJ2NSTfkgNyK6rTJhJu4EyjqwkmEisW0v?=
 =?us-ascii?Q?rbVMWGA/3QE8+sn4JQGWLdBbCd19inbod4RwL1YmtvlFJLFHijpf8WBUGiMY?=
 =?us-ascii?Q?pm5GA1u1JmLZSV4YxknAFV566VeaAD16SUH9mbyk27HssLErZ0AZxUdhUNrL?=
 =?us-ascii?Q?jBmPWbj6x1wZjL5Z5y0cOJnnTqQSTmWhFZPfvC9x1extkIu/QOaKXfPCfrjF?=
 =?us-ascii?Q?Nm2nlwLENIHLrnRqviO5i7pK09oDEzRIOv870kSrRWARB6NEGzZzyCTeL6a3?=
 =?us-ascii?Q?NiK5RMDBa+xl6NgAPD8/pmqBnEjmqoVVsy52wTfUNS5Oi1ERv+fr0KbdDq9m?=
 =?us-ascii?Q?GN0FzbuA4HXnujLwmY/Etx8T5qS8cKPy6afjg8QH7XAf+mPfmEoS4rbS/u+v?=
 =?us-ascii?Q?oTZuk58qOt7xbIvG6f5sM3uzfKme+Q871KqvU9cLZ9aV1xILGv9wwtcx/02Z?=
 =?us-ascii?Q?x6EuqMo2wR5bdC7ntV2G+67Uir0j1PfBhlSxaI0DCb8GlF/LguNcrLNpq0zA?=
 =?us-ascii?Q?ARzsNBLz0JFQD/PFkVGSN396vaDa1VdbVObLgSsIfJA8orCFjUG+iS6niJl9?=
 =?us-ascii?Q?HI3RNOn8tbATSX/hoRbyXEjlBVKkQ4j9GsS3lGS29GhaVlnYOPZIOocUB8oH?=
 =?us-ascii?Q?+CR+1XAGwsx3TEElBpJ5H4J6PV5gDoArLGdcckKyGm7QaJzmaPmg8BwlwbsN?=
 =?us-ascii?Q?BZG2QambRpYfcobSqS8TlUhZ0JDI+kXAk295Yj0pmQv7Jkit2EEX6PoZyQG8?=
 =?us-ascii?Q?4GJvM3BBSqrBRDaXIXiZC6wDAZQRr9dkkVvRr8ktJYDu+g=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IEazWb8UNIM/eVqAoiNd/vUsfPnghpkeKB6IHMOgtrRAvndLeu7zlKtKUzaa?=
 =?us-ascii?Q?Q8iffUp002JOCtU25X0fLMhviSrXxNgtv7kxHc1p5uCHZo8bC+kNkq9079rT?=
 =?us-ascii?Q?gDU5E2QscuzfSedj3RsZ+QgFUvJ6nbgMgZZik74QUVDoFXSUxcpRy1HlNIaU?=
 =?us-ascii?Q?m0s8gUArEgwvONT7R+coApXxnUS7F8Y2Vo0MXayF8jbBrGzSdGX/rjZjIWlA?=
 =?us-ascii?Q?cBANS0UmkDAoL4dSUabn32j6UBnLQC3QgfWUZYuMRqyZkYKK/PE74v+hBgUG?=
 =?us-ascii?Q?L1G6Bt9DGZwx3vNNFh6BTqSmi8sbRBfsSimpNDxBXkKLCCao5DCYvQU6FzhT?=
 =?us-ascii?Q?S1gtfOgmXn2hhGsZ2EVFNBmcxXzWx0l3M70krOfoBbL0pvb16zQAuaXJ+FkC?=
 =?us-ascii?Q?TjV3vJzqDey22u42HLsD/kYt7HxyWy2mqOtkX32pYwyc8jRDLQ3HrsH8TF5C?=
 =?us-ascii?Q?eEH6nDFjtN9f0tK1RYzccbXsubnVctTweL12QRKK8NFOqYEfg8ZfRIQ0lZfH?=
 =?us-ascii?Q?WJiq7dG9Vis6Cvwwkr05/DXN82ZGQr4UXQGJ4c+bVd25+y2j0TJYv9xu4JdT?=
 =?us-ascii?Q?++/MGxTkNvlEowWRBKyK0KqWbssFI26zrOcRAHOFzRcJ2rkhtB5g3OHlzs0d?=
 =?us-ascii?Q?NSjELeycRP27kHo0uLxNmsZ/j4Ge8ZVezD0eRKkXYcypvMb4XjmybUkIgpys?=
 =?us-ascii?Q?qLiIle7b/anSjJyi5TgyLx6NOPbeSc1t4HMOPzJZzOwZX++mBHQQgcz+dCQy?=
 =?us-ascii?Q?6iGAxwfo1fpckUShfJkIS8tgXZvc5zA6SWVw/j3GsUlzUISm9exFiO410bPQ?=
 =?us-ascii?Q?1O/3+eu3WpUIxu8c1KCyQ7MVyw+LN56s88tqyjaqh1nqKseY6jCjOIIjegZS?=
 =?us-ascii?Q?Wt4w4gEf3bjur9CQgyXCAzk/XS5WXyMjrEVx6lVH/qElPvThHJ04KCE5kK+N?=
 =?us-ascii?Q?SsS8CZTVCfFmoma2xv8ld5uePqCXcxos24Mzuao1Hzci7L8+G5gC2Q+/LEWC?=
 =?us-ascii?Q?KeYnwOxgD2w+kCe7aob8WatXOuj6ojTLkXtp+zFblws011+gzBX1mAufY5E8?=
 =?us-ascii?Q?HPzWG/CougESQGDQYqqXzvfw0/nZUxz65yHZJ0up46XH4YYdSFZYuhKnN8HT?=
 =?us-ascii?Q?Jb6+qmPPIvK7r5uMs5eTA7vebTmDdWRJy/op2nxp7UBQqNr738T8TSuiKUwi?=
 =?us-ascii?Q?yMKkjWSeq1x89blIg/2a6/uWLouysQT0ARkVAM83l5ShhVesglGzA1DngMB7?=
 =?us-ascii?Q?Uq/ZKbz4FIMuDu9/YzSQZV3zt1vCdQ4VxQo9lb4Re9EfaJCDMOd/7tWHwYyb?=
 =?us-ascii?Q?2onwA5pmhRFEuqqpxuSixYT0opQ891p/6zN+nf1MvLuj/LHJvyCRBthiVrkR?=
 =?us-ascii?Q?zxVK/Lhk1oIg2tSGJs86bTABQhe1MjTPwS+nLMxJWKKwDc8gs16a514APIZM?=
 =?us-ascii?Q?uGdV1KXDV3Qd/vI8sBqaLd1WZ9TmDb8euyWEBZMBdrl8NDJOJ50pY2tVxuS+?=
 =?us-ascii?Q?m/is6p5tyvjBY+3HI8ejqpHjYFI9oAvTpjM63hboSVl1PEnUCymvnzD4K+82?=
 =?us-ascii?Q?xMxd5BVNqHZTwQ7T7vJZy/CvZ3QIhccWlhB5t9KI?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 314826d7-9fea-424d-a31a-08dcbb48f1b1
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2024 03:35:14.8464
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sDtZO5XyHv1x4Mi9ukv999qh5v+5YBaS8W3JrYtjwmWq0F6YWzF5JMZ4RJPVA07bkAj53b4/EyT1k+VWpqbhug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5014
X-OriginatorOrg: intel.com

On Mon, Aug 12, 2024 at 03:48:06PM -0700, Rick Edgecombe wrote:
>From: Xiaoyao Li <xiaoyao.li@intel.com>
>
>Report raw capabilities of TDX module to userspace isn't so useful
>and incorrect, because some of the capabilities might not be supported
>by KVM.
>
>Instead, report the KVM capp'ed capbilities to userspace.
>
>Removed the supported_gpaw field. Because CPUID.0x80000008.EAX[23:16] of
>KVM_SUPPORTED_CPUID enumerates the 5 level EPT support, i.e., if GPAW52
>is supported or not. Note, GPAW48 should be always supported. Thus no
>need for explicit enumeration.
>
>Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
>---
>uAPI breakout v1:
> - Code change due to previous patches changed to use exported 'struct
>   tdx_sysinfo' pointer.
>---
> arch/x86/include/uapi/asm/kvm.h | 14 +++----------
> arch/x86/kvm/vmx/tdx.c          | 36 ++++++++-------------------------
> 2 files changed, 11 insertions(+), 39 deletions(-)
>
>diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
>index c9eb2e2f5559..2e3caa5a58fd 100644
>--- a/arch/x86/include/uapi/asm/kvm.h
>+++ b/arch/x86/include/uapi/asm/kvm.h
>@@ -961,18 +961,10 @@ struct kvm_tdx_cpuid_config {
> 	__u32 edx;
> };
> 
>-/* supported_gpaw */
>-#define TDX_CAP_GPAW_48	(1 << 0)
>-#define TDX_CAP_GPAW_52	(1 << 1)
>-
> struct kvm_tdx_capabilities {
>-	__u64 attrs_fixed0;
>-	__u64 attrs_fixed1;
>-	__u64 xfam_fixed0;
>-	__u64 xfam_fixed1;
>-	__u32 supported_gpaw;
>-	__u32 padding;
>-	__u64 reserved[251];
>+	__u64 supported_attrs;
>+	__u64 supported_xfam;
>+	__u64 reserved[254];

I wonder why this patch and patch 9 weren't squashed together. Many changes
added by patch 9 are removed here.

> 
> 	__u32 nr_cpuid_configs;
> 	struct kvm_tdx_cpuid_config cpuid_configs[];
>diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>index d89973e554f6..f9faec217ea9 100644
>--- a/arch/x86/kvm/vmx/tdx.c
>+++ b/arch/x86/kvm/vmx/tdx.c
>@@ -49,7 +49,7 @@ static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
> 	const struct tdx_sysinfo_td_conf *td_conf = &tdx_sysinfo->td_conf;
> 	struct kvm_tdx_capabilities __user *user_caps;
> 	struct kvm_tdx_capabilities *caps = NULL;
>-	int i, ret = 0;
>+	int ret = 0;
> 
> 	/* flags is reserved for future use */
> 	if (cmd->flags)
>@@ -70,39 +70,19 @@ static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
> 		goto out;
> 	}
> 
>-	*caps = (struct kvm_tdx_capabilities) {
>-		.attrs_fixed0 = td_conf->attributes_fixed0,
>-		.attrs_fixed1 = td_conf->attributes_fixed1,
>-		.xfam_fixed0 = td_conf->xfam_fixed0,
>-		.xfam_fixed1 = td_conf->xfam_fixed1,
>-		.supported_gpaw = TDX_CAP_GPAW_48 |
>-		((kvm_host.maxphyaddr >= 52 &&
>-		  cpu_has_vmx_ept_5levels()) ? TDX_CAP_GPAW_52 : 0),
>-		.nr_cpuid_configs = td_conf->num_cpuid_config,
>-		.padding = 0,
>-	};
>+	caps->supported_attrs = kvm_tdx_caps->supported_attrs;
>+	caps->supported_xfam = kvm_tdx_caps->supported_xfam;
>+	caps->nr_cpuid_configs = kvm_tdx_caps->num_cpuid_config;
> 
> 	if (copy_to_user(user_caps, caps, sizeof(*caps))) {
> 		ret = -EFAULT;
> 		goto out;
> 	}
> 
>-	for (i = 0; i < td_conf->num_cpuid_config; i++) {
>-		struct kvm_tdx_cpuid_config cpuid_config = {
>-			.leaf = (u32)td_conf->cpuid_config_leaves[i],
>-			.sub_leaf = td_conf->cpuid_config_leaves[i] >> 32,
>-			.eax = (u32)td_conf->cpuid_config_values[i].eax_ebx,
>-			.ebx = td_conf->cpuid_config_values[i].eax_ebx >> 32,
>-			.ecx = (u32)td_conf->cpuid_config_values[i].ecx_edx,
>-			.edx = td_conf->cpuid_config_values[i].ecx_edx >> 32,
>-		};
>-
>-		if (copy_to_user(&(user_caps->cpuid_configs[i]), &cpuid_config,
>-					sizeof(struct kvm_tdx_cpuid_config))) {
>-			ret = -EFAULT;
>-			break;
>-		}
>-	}
>+	if (copy_to_user(user_caps->cpuid_configs, &kvm_tdx_caps->cpuid_configs,
>+			 kvm_tdx_caps->num_cpuid_config *
>+			 sizeof(kvm_tdx_caps->cpuid_configs[0])))
>+		ret = -EFAULT;
> 
> out:
> 	/* kfree() accepts NULL. */
>-- 
>2.34.1
>
>

