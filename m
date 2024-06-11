Return-Path: <kvm+bounces-19328-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 47253903E64
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 16:08:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E412D285D45
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 14:08:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91FE817D88D;
	Tue, 11 Jun 2024 14:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fWixwjtt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E781DDF4;
	Tue, 11 Jun 2024 14:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718114904; cv=fail; b=T1wzosijC8Wt3PO6+2hJdkRHkAykbd2SmlMGRvwDTHK8HOF5BaGi7UySP8JXVfOe6rtgagAYipKBk1wlrwpcnaEJbAOebW9pDh6ZRdikkrGF3g129Pc9TBPTAXrU25/GLl/PE4q72ubJEyUL5msF2mLRvNbQJg2f8guPYt9HYww=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718114904; c=relaxed/simple;
	bh=+ui+qdqDkTj1BjDSrolkJ+pHYXp84vyYAQQnBqB05BE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TTy4YR+AZmbn4rxeRWyIgNOUYyu0YCUfQNaGsaQ3VV3tpeOl4nIcazQnov5YTDYJvXIfW51WBU1arl8K082xpgL3TKLVRqUp4JNrWT7O/2qVKVZihwUR1wT/T+l3sXJ//RNcYaHpN6BdrlD0sdQStbKscVgjphEag9rEH1k4AxU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fWixwjtt; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718114902; x=1749650902;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=+ui+qdqDkTj1BjDSrolkJ+pHYXp84vyYAQQnBqB05BE=;
  b=fWixwjttgzG+imIqUSyjwx25BIP2n5OJbRlD6EDbjRxllUAtGfxlo5m4
   vbcA3KKKrC0aa/iAz3BHCgOoTZJY2SQKewEG7U0QM7XD88t9SRZ8BtlSV
   fLeo9vqjqtqCJXT/8Ey/IcSExI8oSlwRBxbIfQ4O2UwkxmiRVVtRHM2tf
   XckmjCTGifCdftkbK4Bp9k1LEebaWJ8TPPlA/h7MskwtRI3Rxt+bB/cvj
   zc5/9iM14YbRc5BMG3f01+iXi3qSqDlIPG/tpqTfrXaYhmls4XDUb5cq5
   73vgfMHtSdE6yunfNoZ2I9UZ41XHAPX0f2d3dIexDWCyR/2s80y1k5W+K
   A==;
X-CSE-ConnectionGUID: z9q7N7lKTIWUWHBwa2719g==
X-CSE-MsgGUID: puwIZouVR9CGdvr6AfmB0Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11099"; a="18686320"
X-IronPort-AV: E=Sophos;i="6.08,230,1712646000"; 
   d="scan'208";a="18686320"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2024 07:08:21 -0700
X-CSE-ConnectionGUID: D4Sam08MT6OszjeLsC79Qw==
X-CSE-MsgGUID: +1uv+HRPT6u/gzoPptfaTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,230,1712646000"; 
   d="scan'208";a="39333499"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Jun 2024 07:08:21 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 11 Jun 2024 07:08:20 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 11 Jun 2024 07:08:20 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 11 Jun 2024 07:08:20 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 11 Jun 2024 07:08:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZPPqIFyihxPq1pnFcjIc2eTX0RQmuKu6imOFqAGrTNNGX2feM42eAkJ0Tjg6oWQqnQE1TbKAcIrmfPa79U4c/k4j5QHUoUoaoCpenIdh4UbdjUiHKbSXACx28qjc21i0bVGZHyZyToMVe+F/C2TD/YnztDEVaiftFCId39SEwzSroHR9ZOTX2WYnUmQ8IA2MY+3U9szOnTRZxFsGwHshspjkUSE3HLakRKs326zqT12HUgmsdEDDqUGzVall8r0768qORK3FOFsN/yNeEVwj1KIDy7s7G0thtGtmFBTU9AImXqf0rj9MbiwAV+niIM2JaOajBTR8WVXfmwPpSmTkGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WawxywLUw2viEIxz+HTJI5tZFB3EbsV1D/cJv/T4nY8=;
 b=Iz5RoP/XvB/UN0nWfF5dQwPY3smD7G89LG1/5TpcLWcAj95P+UdhssHe2W1/pQOpPTP/D3FVsOPstVvlc5mqPcBJmf1OCHUzFPTOWtYM3bK5Zps5suUKSn5FpmxCXfAXyj2fbL7njt2TAJBCqFdks/brhi2ENyE8lkpC0wEggzfYwrVALsz+x4cObTrJrK6t+Thu2OrPvoQuMAlKNpI2CI4j/G9+nPSe++IRc5rz+Zh7G+xuyzfzFljQwxHabZ+dlbNLrclM9kLSNVHKDdSt1mgws2RcdjE9bbGRRA1HSHePgn6EeCT1VfLAMVmxSL70809u3KcS2ollS9FABjolnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by IA1PR11MB6347.namprd11.prod.outlook.com (2603:10b6:208:388::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Tue, 11 Jun
 2024 14:08:16 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.7633.036; Tue, 11 Jun 2024
 14:08:16 +0000
Date: Tue, 11 Jun 2024 22:08:06 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<daniel.sneddon@linux.intel.com>, <pawan.kumar.gupta@linux.intel.com>, "Zhang
 Chen" <chen.zhang@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC PATCH v3 09/10] KVM: VMX: Advertise
 MITI_CTRL_BHB_CLEAR_SEQ_S_SUPPORT
Message-ID: <ZmhaRr5Lr4pOHcm7@chao-email>
References: <20240410143446.797262-1-chao.gao@intel.com>
 <20240410143446.797262-10-chao.gao@intel.com>
 <ZmepkZfLIvj_st5W@google.com>
 <ZmgrkMLuComwPl1X@chao-email>
 <ZmhSeZpyoYxACs-n@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZmhSeZpyoYxACs-n@google.com>
X-ClientProxiedBy: SI2PR01CA0013.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::9) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|IA1PR11MB6347:EE_
X-MS-Office365-Filtering-Correlation-Id: fb1657f9-cada-4323-4394-08dc8a1ff09c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|7416005|376005|366007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?jVqc/xAR5BpyLJmD4LywBUgL6AHShl7/hiqT2W48g5oxCbTGfLb4qoCFgkG4?=
 =?us-ascii?Q?7THQK+3lHrIO1CWBR51k989Vony8/hyNQCCTVbvik33nXSh2bwmpUwZ0iDYc?=
 =?us-ascii?Q?U7RvIdcZNiImx576RxnJaa8ErkE/Q0eTbp7uZMntj6swQ0GMZEWvNc9fMliO?=
 =?us-ascii?Q?UQ9biXe1Cq/zs+SA3It0c6yOXaqXDSuBYx9oGfre5ROVmtz5Mfk/SQ6sTg1Y?=
 =?us-ascii?Q?th7bPsGDSCDGo5hv98bO4IcL+D4E3y3ySawk3LExJxUTLeMe/zmtoDddzvSj?=
 =?us-ascii?Q?TxqB7sCqgPoWSjmuiA9rd1LAjqG62hn1c18ll/Jt+ZEXJIsZ4qHWKW2Estx/?=
 =?us-ascii?Q?uFC/2KXG85n/H68aLTK8uimcN5ECfZpSnbSxl+gKxI6SsJR1enuxXq441IdV?=
 =?us-ascii?Q?ZQ+XXo8rwBuhhs9X1w0521X4bB40XQJ8+RRD4DM/sTcSYP4nNN/bN1WzhVOt?=
 =?us-ascii?Q?xA490m4jUesEYRGb43tYzmRGiRovWfox/N8r+X12ukXDKc4qK5Yn1iCa/GiY?=
 =?us-ascii?Q?S+zqYfC+WyvsnL2uC5v3LqRXomiA1jsNA9gq4mGZvPJgAsMDNvRemCJWcYz8?=
 =?us-ascii?Q?AFME18x4iOt4HBQ+BEBGJbC3xki2TL1yVVosF/ySKrfThl2Wv7NCHhUKZh2i?=
 =?us-ascii?Q?PbsMGMTKl6h/yo1df9mWVD4M1PHEzZA9pKqAwvpom1JApfYkUip1LcTsXVAx?=
 =?us-ascii?Q?H8IURi/XjC7ulVjduxGjdtsIyk8/uiGiuMJEz5Afe/NFj8fyQ7mokikf9sjE?=
 =?us-ascii?Q?GBsG1b6aVWM+1wxe3akr41zILIFPkfBsvFPLqHJY/28AWsnw0bupirU+1/n9?=
 =?us-ascii?Q?LbwHzDOBaSgI0Ah+I18W46bb4Wx76cJnSz4upIUy8/sP9f1tOy3siwTBgvFZ?=
 =?us-ascii?Q?+SndNcDRBpmiZGPOCz7/5FdLqvx0tVPl65196MPSRCxhzhZVlw5zPRXGRQbq?=
 =?us-ascii?Q?OZil4M+ZP6y85+gIHx43pj331h866fZYEweKzOUVicUNnErQ/CMlOPerCTMn?=
 =?us-ascii?Q?y9P5Q4gBjbSOoD0jL01skw8AveTaBV4CLOGGazCEscBmdm0lvvgKkksVhsNF?=
 =?us-ascii?Q?cAvb/8YTeAjn8mo+GKhY3PwudVOzwlFVkUHNXXpDeQl2TMH3jN5q8XwVINzO?=
 =?us-ascii?Q?7qGsuVHzZV8wbyJRgGAWdhYMnhDLxFnjaQpIAMgRTmGlmdI55+/3S1KIzT2W?=
 =?us-ascii?Q?/ZZEbADIdE3BT7y/YETutPhG+8x1ZUdRk3lM5QR2yPLVd52esC3eAU1mVfhJ?=
 =?us-ascii?Q?8G8u8TAhGLXR+igBiR6diPTfc/SxlYfOFl7xnp71eHYZ5v31cEb7sleiLiLq?=
 =?us-ascii?Q?vlcmcv73vnt5ZWLa7VCdoweu?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ze9L/CMsf5KTOGMDOL2QriDaCy71EdF/y9kzsOOxr98m5RUNf75K1odjXlSs?=
 =?us-ascii?Q?3T5Joeq4GRnOgxa1MmPCWGwxGjekrywN9A7VgEMJw+q7nJE7T1EJFJfcFpN7?=
 =?us-ascii?Q?OtkGLZdUGWhzEny27bWiD5WtINR6KMXprRGi87uirsieitsHrjVlamVVQd4D?=
 =?us-ascii?Q?a6Z8kd188HCKBwOJJwujhjPS4nt272RSIwKTX9aBH44qtVYo66XynEWBT08W?=
 =?us-ascii?Q?YJ7+Ply2f4jE01LuvLGtpjOWShYkGpxo6B0aVBI20LPQ9EDepcsijgYseJA7?=
 =?us-ascii?Q?U3JPkFnoqrrQMAdxDc6xApFUglGe9YtHZRgjaFvg6BaR07OJNA2M77VJtWZH?=
 =?us-ascii?Q?vZtezx6ybGVPZKCgLDaUu1JUdUFCYzCuwQPXvvQvR2jCc6mVRsilcRqBPyll?=
 =?us-ascii?Q?W7JKYUObwKqyJm3pnR+TAwm7sRAeenJ57odA7d1msgfzxh947vm6wyEUCpPW?=
 =?us-ascii?Q?beHOsoa/+Njkmw0h/ZweeOC/X0j3B5+l6tPjo83e5FCTCIDr59jd0yaFNPm+?=
 =?us-ascii?Q?jbSbZp0hRWiqsFDD9e2u2ZJ0ELGCTYAMwG3DaMsfOK7dcY7VcV+IHsOtQpU/?=
 =?us-ascii?Q?pLUWviNB7WrOF0D6WkbBYvqjsU28VIYzI8h7ARKclDfQ6PulaQ6fY4fpVXpK?=
 =?us-ascii?Q?ZH7vP001m6bU+oL7UNM+u9Ty0EaGbYub6yduJl8rHncGpxbXrAdsfmv9JbqC?=
 =?us-ascii?Q?VLUh9tgblYbo3W+aIBd/IuQpmtAObXb2NYoxHXtd9jH7GcqQENveAZSI9lM7?=
 =?us-ascii?Q?RPvS+pT6Yee/VTq8hSNanOxKNxumueQ1OGxsW76ih1a7nFaPV+JZAAyoUKlL?=
 =?us-ascii?Q?M2EFRCZ5eLTPIYC2cNXVTWpGvS9sxutyd7DXtV7ab6fbqLtr/Ry4mxDFi8RD?=
 =?us-ascii?Q?atZ8l3+101510hir5WjpfN6a6KSUBBI3RE1wjYpK9nXBEXspJuIa0Th8NOxk?=
 =?us-ascii?Q?X78u2UA8CPMeuHI0DKjXcNs7x0vKh5o4PLgIiJ/ferEMf2c9y0hpUIVS/RYZ?=
 =?us-ascii?Q?OkUzxplz6oZuIewZjscButDFMZBaRmkXDhaylQngT+160eOERYWpKMjIUyf1?=
 =?us-ascii?Q?IuLwLrUEDiEUW3+OcLdtN+Y0M2iI2OWiWJWfTvB6er/L84PGI9xpoBiXslRI?=
 =?us-ascii?Q?LRf+oo747QvpIIvdMbN7xnA8bMn34OnRiNNd6qAB2tFJ2sYcF4Dq3HIgrYMn?=
 =?us-ascii?Q?lACvHWlrTITW52XM3yX4frC80VkwgsBlPn5JEN8bDJbUG3LhTo3pCxUJCi2A?=
 =?us-ascii?Q?pib4hrUe1L5uyFv7hM5xs9oV4nceFSSlPt2QhqGAmODTn8x/JOp+cQSMGi/1?=
 =?us-ascii?Q?RFPO7S7OnnXtgbC5Mk2dXB7H+Kw8RKYHsz0gRl1Xrz3UuqV7E9eiesy6+8J6?=
 =?us-ascii?Q?jc3t/IAEj6sRTIGGWxsc6VQgLtTXEjDuMkq0dd5h6R0ST771f0wjQ3dR4Ysu?=
 =?us-ascii?Q?2ew5B1FYtr0C6mHhmW+KCifGq3ghqu4qcEFla7650YmUewAjNDVe0XwZeZwR?=
 =?us-ascii?Q?0YuT3nVNgu6IB8+pciSpz/NKYbm70c/5iaIF6sNsL96ylzwQywJxJWZgMhCQ?=
 =?us-ascii?Q?bw1IcXa/xJVtLbYDWumKdCY754vRnIFrXXQx8BHh?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fb1657f9-cada-4323-4394-08dc8a1ff09c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2024 14:08:16.7228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +waK+mTT0iWoGNcy8gGskNdrgWgjZl59OWxIHAcQRYvaJMLqZaVCI/L267upe/ErXj7r4eT5bV2C0QwAb+3ntQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6347
X-OriginatorOrg: intel.com

On Tue, Jun 11, 2024 at 06:34:49AM -0700, Sean Christopherson wrote:
>On Tue, Jun 11, 2024, Chao Gao wrote:
>> >I continue find all of this unpalatable.  The guest tells KVM what software
>> >mitigations the guest is using, and then KVM is supposed to translate that into
>> >some hardware functionality?  And merge that with userspace's own overrides?
>> 
>> Yes. It is ugly. I will drop all Intel-defined stuff from KVM. Actually, I
>> wanted to punt to userspace ...
>> 
>> >
>> >Blech.
>> >
>> >With KVM_CAP_FORCE_SPEC_CTRL, I don't see any reason for KVM to support the
>> >Intel-defined virtual MSRs.  If the userspace VMM wants to play nice with the
>> >Intel-defined stuff, then userspace can advertise the MSRs and use an MSR filter
>> >to intercept and "emulate" the MSRs.  They should be set-and-forget MSRs, so
>> >there's no need for KVM to handle them for performance reasons.
>> 
>> ... I had this idea of implementing policy-related stuff in userspace, and I wrote
>> in the cover-letter:
>> 
>> 	"""
>> 	1. the KVM<->userspace ABI defined in patch 1
>> 
>> 	I am wondering if we can allow the userspace to configure the mask
>> 	and the shadow value during guest's lifetime and do it on a vCPU basis.
>> 	this way, in conjunction with "virtual MSRs" or any other interfaces,
>> 	the usespace can adjust hardware mitigations applied to the guest during
>> 	guest's lifetime e.g., for the best performance.
>> 	"""
>
>Gah, sorry, I speed read the cover letter and didn't take the time to process that.
>
>> As said, this requires some tweaks to KVM_CAP_FORCE_SPEC_CTRL, such as making
>> the mask and shadow values adjustable and applicable on a per-vCPU basis. The
>> tweaks are not necessarily for Intel-defined virtual MSRs; if there were other
>> preferable interfaces, they could also benefit from these changes.
>> 
>> Any objections to these tweaks to KVM_CAP_FORCE_SPEC_CTRL?
>
>Why does KVM_CAP_FORCE_SPEC_CTRL need to be per-vCPU?  Won't the CPU bugs and
>mitigations be system-wide / VM-wide?

Because spec_ctrl is per-vCPU and Intel-defined virtual MSRs are also per-vCPU.
i.e., a guest __can__ configure different values to virtual MSRs on different
vCPUs even though a sane guest won't do this. If KVM doesn't want to rule out
the possibility of supporting Intel-defined virtual MSRs in userspace or any
other per-vCPU interfaces, KVM_CAP_FORCE_SPEC_CTRL needs to be per-vCPU.

implementation-wise, being per-vCPU is simpler because, otherwise, once userspace
adjusts the hardware mitigations to enforce, KVM needs to kick all vCPUs. This
will add more complexity.

And IMO, requiring guests to deploy same mitigations on vCPUs is an unnecessary
limitation.

