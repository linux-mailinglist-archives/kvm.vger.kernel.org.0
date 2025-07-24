Return-Path: <kvm+bounces-53340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 37830B10118
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 08:51:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4FB1F7AD80C
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 06:49:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB218221267;
	Thu, 24 Jul 2025 06:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PklKuUNm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ACCC273F9;
	Thu, 24 Jul 2025 06:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753339857; cv=fail; b=eXU2QiEbzJiJjLmLG7dUG5D2pPueyws+1y5clTmHoCXQAYslgrS+r1+VL0l1p4nwmcK82qzLUtQWRe6gR486em//cJl33DM6CuiTlZ+ezcmg6faN/HNkLA4CJbdbN9pfWdtn6hZGrEbpuzUQfaJDdfGNU76EmG9GHFz6SsQsh0Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753339857; c=relaxed/simple;
	bh=8y8lK5BXY7oGW4tO+KaBk19W3Nioccc6Q6OtyV209hI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nTAltER/cKES853KWcrz89uEONoa3Kypdzmx5gFnQt0AWxyJS+t53vaL52N6SzJkAq/Dl/bGxIrxdLpacCG+5QztZxbp7WwN9WsCUqVnxrer6Cz5DogxiyprcAAKNgkCxn/vwZaEmoSgPdpTUxFyx++QF90mDPe90jY5ZYwznOM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PklKuUNm; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753339856; x=1784875856;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=8y8lK5BXY7oGW4tO+KaBk19W3Nioccc6Q6OtyV209hI=;
  b=PklKuUNmVEvsiKuF1aIZMS6s3XEh9Q+vlBSoJuG8PO2BIBdKR+NdYCvu
   BrDE0afxBz3aLLwhPhlT4oOLsk4jnusksbVDEU6HsGupP6PPio7TqIupR
   FVVaaFPOh+ptzigV0IGeyJch0V/W0BZUGHcpg6MXUNBNHB4nL54Jzev2G
   0S92Qw2C5jG5KP9pq3ZLaYUGGQ7nQbcqT3ZxX/tcsAnVkSQEJN72X2DaC
   2HyoDpM2fyrAP5tnIvtXwwCRQB2T2NuB1Li1Q3uwaYs+2hgGdI3uB8o1P
   b2g1uPVUrL+HtiXxIPK2qR5M3BGXKKE2C6qWSt/55U2jBArMZP0SxgeIo
   g==;
X-CSE-ConnectionGUID: 1IrWc+MeS6CAQ5ez7Cfq7w==
X-CSE-MsgGUID: JEtguE5aQp29vwIYIM/8Lg==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="73094765"
X-IronPort-AV: E=Sophos;i="6.16,336,1744095600"; 
   d="scan'208";a="73094765"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 23:50:55 -0700
X-CSE-ConnectionGUID: t6FQ2ux/RrCiSR455CKhvQ==
X-CSE-MsgGUID: 9+GzBnRoQ4OuLcLCSWll5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,336,1744095600"; 
   d="scan'208";a="160403166"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 23:50:55 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 23 Jul 2025 23:50:54 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Wed, 23 Jul 2025 23:50:54 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.49)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 23 Jul 2025 23:50:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aGG5SurKf88OaOptKDBbnatWcC88W5BwTAT/8BZp3vyfB3pG/F14dOQyRE1FsdUrJVHtJ3XFXdErE2A8HjWtkKLzJCaV1ZNxGTreduspCobZmcktJdimhVhcvBuo71vROwq+/qmDM38pHQB8KwAH7AbFhVOeVKsBWeI3tItaHhQQEYuZylGR06S00gJno/p7bvIq7GLUBt8iu/JLcpLqFdPvHldr7Vmpdn741/FdgSW7L40WXgqD5gkexQ3SXDF2y/YkiYRmZ6yjXxh89Sq9Yh4DIVm6tOKwX0/Y0zeR/EcgaTunGNlW7EQ5gux6JySRN+LSeTUGC9mYDChAAYLxTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=94CFFbi2u9aHAVYBJbf1RoKDd9qjiMlUWEcvAyJEqBY=;
 b=nTfeEvmhe+IYAM9VgR+x0ME20yu3X/vBui18Zmhy9JU+CDeaN/w3sAvXFRKUxJSDq/+uMUk9eTORh9qpap2V+7AvhhFTQyoVacM74wUG630EGb4tLnrG/FO9wq4BAZLk+NyNOeKnh5kU4EAsPBq0HkaUZGImeCv8Ct4fmHUan/dwRROD3fPUxEAgp2FZPDvPXBTGYYLRV3k4BssookTYXIIBhi04R5mbStPk+GrnHqss9iLXGRPhAEzfJOQO6onBTJGdKAgZ+gWDW1Hsgw8n1yJWuff0USDd/yQrxa+CHQPoBcvy3bxwiPXKWvVZ4CZkrj5RBhDs9Yj0JYqLlVJg6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH0PR11MB5927.namprd11.prod.outlook.com (2603:10b6:510:14e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Thu, 24 Jul
 2025 06:50:19 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8964.019; Thu, 24 Jul 2025
 06:50:18 +0000
Date: Thu, 24 Jul 2025 14:50:06 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Xin Li (Intel)" <xin@zytor.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<corbet@lwn.net>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <andrew.cooper3@citrix.com>,
	<hch@infradead.org>
Subject: Re: [PATCH v5 20/23] KVM: nVMX: Add FRED VMCS fields to nested VMX
 context handling
Message-ID: <aIHXngnkcJIY0TUw@intel.com>
References: <20250723175341.1284463-1-xin@zytor.com>
 <20250723175341.1284463-21-xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250723175341.1284463-21-xin@zytor.com>
X-ClientProxiedBy: SI1PR02CA0058.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::9) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH0PR11MB5927:EE_
X-MS-Office365-Filtering-Correlation-Id: d8abb66a-677c-431f-ae95-08ddca7e5a59
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?zsmKYUKiPsxNxpFmpacYUtNtwjlQbo70PBiHopprkPZvLR6TsxHMBqTSYiQY?=
 =?us-ascii?Q?tydzN54gZ9z1OelOSh0zxTJHR+5kxVJQGQ/ul/u6aQ/K0EwB7iJY2gPkttww?=
 =?us-ascii?Q?mtvOjuMfIhu9b3hfno5NoaMIsayRHXhMsiIZSOWcnMaSRQCwflyEZJlSC1Lv?=
 =?us-ascii?Q?SLO1+hugB9J19rtkiKV1LBlIteJY5W2PFEzkKYmkJ83qRcRWnCaWUchB8XYN?=
 =?us-ascii?Q?eIgiF8Ibne/9Vk+TvgROIDUuff82MwnAvDf/eC9WCyp99X4u+mqbgXgV3bxz?=
 =?us-ascii?Q?VmvuC4+cO52r+u2Sp7sYczKRUIUG3BB+r5qOoAeucF9sPkf2zXBzGJ+uDBVu?=
 =?us-ascii?Q?gIHU/+KV4T1dWU/tUNq8Radxi7emj56w/WIJ4WtBNjmQMHm5fE4oLnSQfahL?=
 =?us-ascii?Q?SQ+zx+fB0w1FepNQm9aCk4uCqG0eEosR+74O+mZvGPpz1mie7L55Eg4tsj4m?=
 =?us-ascii?Q?33NTMBXpmWUHdeb+de3JuWPTVDC5qNcO8UNSfsoBLyT1X9XdDmtj+HGLhchG?=
 =?us-ascii?Q?zbXvoz03qNK9ON0wKMCukcFRW7a54Gqd68QojRViq9IwE+lTdZx/AXy7/VZ8?=
 =?us-ascii?Q?zG+aaxHpi8YXXQ01w0lN151eblPSto3+ZOtzNJT6vjftab8sRm5U+rBSYN72?=
 =?us-ascii?Q?7daeflCkNkPuKP6nlvGnhEV82GiQ0rRuhMn5tK4G1u5km9octf5JGBmmCvwn?=
 =?us-ascii?Q?gLvgecVdxnYsbd+hawhETKQRHDQtQ7ADEC2mP1gv/YqkWsxuROXE/iBrs1eh?=
 =?us-ascii?Q?k3KHVL6VaGMXMXNt+XM0xxu+FNMNiIcou2xMClSdV8I851q1fBce1BFIQyco?=
 =?us-ascii?Q?Ih6Gi7SByrUqjZQqFvYDHnTpGoGqFK9DaOX37jIkKnRSbWLpgN6ndzwvsjDU?=
 =?us-ascii?Q?jCBcGwPP0Afkp3NC7tIEk58L+LEmKC5a6NwASm5D+agZolhqoKSfbBKHVdAo?=
 =?us-ascii?Q?2pl22XKv/jc3PWcCugmiWMkQ+Mv76eWO8nUIgDjJ/5xey5CWFiSSjqllrFBI?=
 =?us-ascii?Q?BTl93+jhLq5/NRyFv4NLtuLNagnTLKdAWvzxiOAgN1B7S8+r3hgCeSotI4nD?=
 =?us-ascii?Q?IL5eI9QeL5knOnRVh2e4qPlG/qDI9EZvBvCdwMQDcciUzm63bcZHMd6LldfT?=
 =?us-ascii?Q?64Kl+bCn3XIWnfqcQ2AsQzrDJHicwV4y+pfxS4eYCt07lVs3II0AeSMe3i1X?=
 =?us-ascii?Q?8UCX968MQ35oHiIxhk2FDznsiuPHEkNLzxcEeVoGXXfuwVzZCjKa8M51YCsU?=
 =?us-ascii?Q?D7TOsEL1umVA/0WAQmAdes//8RatlaX4mxUvxOe8IlWoRoMXK7ZpIPoKFryA?=
 =?us-ascii?Q?qovpVKUat2l2CBM6REE07myX62EulZ7nd2mLRCYFjAyAI6Ty+KtdCrw50+yn?=
 =?us-ascii?Q?2eM/OantDxmD6Q1YeUbVDfkac7gnXXCIZ2uXB8ySCmh55/SMjQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OYmzW5Bj6y8kxBHCwyJILVJDV8uShHWOdw2FAP2HBTK7895Arljo6+Pp8WHZ?=
 =?us-ascii?Q?G/KGxpL/hBR/DAEsuu6h/qgdRZMnFlgZoaQkF62w2i1n6GRFEXH9P2yAuVvU?=
 =?us-ascii?Q?tVHeQ/LWjDdFtxlcBHnPoethFSlTL5mWPGz+DZ71nznzb6bw0QD0DZbkMr8j?=
 =?us-ascii?Q?bmII3qFF4vN+bKoIwMMlUHfCNN+VbDQx8d0qDPLTSlp3lqMrQ9JRbEdkfd9U?=
 =?us-ascii?Q?rrfilJKdk/Nx9j+3AYO+oRGBg+ZIyJ/Y/VhOJyjSvSaS+JwdzjEJvWCo+Zpp?=
 =?us-ascii?Q?bCvHl7q7r+fM5nS1qIwNvGq8kYrQvOCnBk8FcmMJQq453Hrq5E/xyvu3O5WX?=
 =?us-ascii?Q?MJN0ghmMMPrRk+YpY6AUCxTwffAXsNPHItu1drBMeVakKWNxw0gyuVTNaCJD?=
 =?us-ascii?Q?DP2rC6BYZFgnnWQVvR2EbaHQDwvUvJzwQJr5zM3amUntaIpocAC7MsFyVufq?=
 =?us-ascii?Q?XQChF53+CSJ3lM2nXzs0McUNixLdVgeG/bhEfqU+jZe+7qVU682QapxtI65s?=
 =?us-ascii?Q?pjpquUF+sL2amvcZ5H7TX3TotbO/erWC18bB1xKs6OzVp8IZoLUp+LAqQz6z?=
 =?us-ascii?Q?dIMmAwxtzmKFP+I231FH1O/f0UL892kuyTEx23cvCm6MdKjmBKM9fTn3k3CO?=
 =?us-ascii?Q?gbr86gNfng2f8kG6s8v7kUbN/UD8mY/qRnW+Tnpn9n+P9KkD/VqKxV0jDDgD?=
 =?us-ascii?Q?sycro7RKRcSDNGMvJrzN+Eg6UeUZ4pLc/GHgiB1Sp3IvbA5C4UJIb5bR7wjT?=
 =?us-ascii?Q?tSwn/doj02MU0yXStq6pTxKU8Il5NBToMiHueS5v5vqs3XVx5V9mL6j8rZyk?=
 =?us-ascii?Q?CvRuf26+dU/Liof5X6HRd7kBjNrDh99GaS0rnUrB349aHvSQuxrJNUJrswpK?=
 =?us-ascii?Q?+O8ZFWY9F2NV3CiMoNWqrKXmYaNurAgxEQnxYDtJxkizIomuvDXdYEPTXtGh?=
 =?us-ascii?Q?u9lThYt80R9gs/WHfNk741l22LME4pb3K1LP27BbyymfXDm6xO7868wQPfkG?=
 =?us-ascii?Q?PLBx0J4wUeAk0QAgxHNN6mPWZZDzB0eoKyWBljRrWJ8DZ00mVtkR3pnrEV5R?=
 =?us-ascii?Q?pBaSgZSNusnqYPINXQM8cWOFCj/BI0LE0ooxhtwfT17QEM5uuujcZNPubAfM?=
 =?us-ascii?Q?fYM32u7uWZ2XlLcjiomqNgJz4NVKgbKQjwNgc2vL4nCdaH32XBzHZrgVsCd6?=
 =?us-ascii?Q?Ub3qTyWGTkXNJTgJJPD+CuGQDNc4dhNsGGCiUDdjsy2TnasiRS0u/d/IYGzD?=
 =?us-ascii?Q?za+rdh4wA8/8eoNoaSHYsCh9qaauan5NGgLWqqrDkRcTYmmyn3zQve49yRNH?=
 =?us-ascii?Q?j17BkKe06H5LkSyIUWjRmoAZABUzi57WBll2W7FJpQwBQq53lib3hy/TDYD2?=
 =?us-ascii?Q?VsVwxsaXi47z0IH8SYs2BxLR6eWdI+PsSmRHnr98BdaZDphBXLXph7aOVhSj?=
 =?us-ascii?Q?EU0Va6c8iMjm8GBg7WMsjK7P8dASXpRA3x7Z7CzJyEW8ADHbHV6fSs3LUWbt?=
 =?us-ascii?Q?FfaB+AsxpNhmur/4k0Qyf2U57xjko6JoH1YosirFXOMhFsFwFrfLLWTE9/Vh?=
 =?us-ascii?Q?SajBVKQAsftFcfy9lPT8ALHUT/LYl4lTOz9UO6ev?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d8abb66a-677c-431f-ae95-08ddca7e5a59
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2025 06:50:18.8832
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M343JmU4L+i66B+PDLvq6kAIUYb72kwkTmyGabCTVk2cu60Ik2TOdvqt41KU1rXFOIeb9jqF9aaJ29VPTA/F+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5927
X-OriginatorOrg: intel.com

>@@ -2578,6 +2588,17 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
> 		vmcs_writel(GUEST_IDTR_BASE, vmcs12->guest_idtr_base);
> 
> 		vmx_segment_cache_clear(vmx);
>+
>+		if (nested_cpu_load_guest_fred_states(vmcs12)) {
>+			vmcs_write64(GUEST_IA32_FRED_CONFIG, vmcs12->guest_ia32_fred_config);
>+			vmcs_write64(GUEST_IA32_FRED_RSP1, vmcs12->guest_ia32_fred_rsp1);
>+			vmcs_write64(GUEST_IA32_FRED_RSP2, vmcs12->guest_ia32_fred_rsp2);
>+			vmcs_write64(GUEST_IA32_FRED_RSP3, vmcs12->guest_ia32_fred_rsp3);
>+			vmcs_write64(GUEST_IA32_FRED_STKLVLS, vmcs12->guest_ia32_fred_stklvls);
>+			vmcs_write64(GUEST_IA32_FRED_SSP1, vmcs12->guest_ia32_fred_ssp1);
>+			vmcs_write64(GUEST_IA32_FRED_SSP2, vmcs12->guest_ia32_fred_ssp2);
>+			vmcs_write64(GUEST_IA32_FRED_SSP3, vmcs12->guest_ia32_fred_ssp3);
>+		}

I think we need to snapshot L1's FRED MSR values before nested VM entry and
propagate them to GUEST_IA32_FRED* of VMCS02 for
!nested_cpu_load_guest_fred_states(vmcs12) case. i.e., from guest's view,
FRED MSRs shouldn't change across VM-entry if "Load guest FRED states" isn't
set.

Refer to the comment above 'pre_vmenter_debugctl' definition and also the
CET implmenetation*.

[*]: https://lore.kernel.org/kvm/20250704085027.182163-22-chao.gao@intel.com/

