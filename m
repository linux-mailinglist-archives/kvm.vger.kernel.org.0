Return-Path: <kvm+bounces-34094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CA959F7294
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 03:28:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0C30E188BD4E
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 02:28:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9504F78F52;
	Thu, 19 Dec 2024 02:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eHBcoX/9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E828E433C0;
	Thu, 19 Dec 2024 02:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734575275; cv=fail; b=Fq3s9oU0C+/LoYJ3xBsQNFBLnZpIFPghWQUP3QaT7v9iFRl5uUM8m4q7OcvwqdxvPCte2pvSaWC46450EKZ3ZBMpDiZ4/sbnf7YsiX0vUIiDoDviUqB1NZWgDLYvP7JwIPianA3XutcIJyXXpnYhziwPeJgnpKpbg0k9R9o9T4g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734575275; c=relaxed/simple;
	bh=pHgiLmuNeUQQ/6Xm/u6QvLdHqBZbPyye6rBhhVdOaHQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FokLfLI69iCpQMDSyW5IRHYCNHrrDsU/D79YOhIIucyDTcAY3CLzr9lXGfI3cg8TZdhehOnRAjjg9v9mxTs/RVM7SAttWneV5D4vVG2P3hOY6aoQg2IETjbvEBOD+HNbtCG1eORwi+TacaosuysqW4qnStm1jSHDPIjJuQFArZc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eHBcoX/9; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734575273; x=1766111273;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=pHgiLmuNeUQQ/6Xm/u6QvLdHqBZbPyye6rBhhVdOaHQ=;
  b=eHBcoX/9s2/pIE98vPA10IywlPCKQSmmaXmBFKPvjTsByvADR0pibXKT
   CFfQjX0PzpZJMPwI6FVlmzMgwTpk9H5JuOB9gU1d/n4i173RIuDtzqSzB
   ZD1/LUMPtaT4dawgGjVRzEiq9GBE0xy/oh7s9mi+f+KVYB57WvAEsyKcw
   jNoM3hTKAsdFnQ69wlBjfXBqZJO1oLmFSRe0pfL3b1EqR8y43VJIpSHBQ
   pU+bSchPXXJlznCdHZELyEdJ+JgINJl0B9/pHEClhAMHH4NL7fBru74gJ
   G9hI8CXUa+PJVH1FxF5z5hWliccnq2xq3Pv16OJVey2T19po0/SKqCwhL
   Q==;
X-CSE-ConnectionGUID: NdV8Lnx7R6SITDNSizD/5Q==
X-CSE-MsgGUID: YVeDjZDJQBaXpWrBDZgvFQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11290"; a="38855362"
X-IronPort-AV: E=Sophos;i="6.12,246,1728975600"; 
   d="scan'208";a="38855362"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2024 18:27:52 -0800
X-CSE-ConnectionGUID: +VACRtlqSKGJ6pcdS/cgLA==
X-CSE-MsgGUID: XlKPOoFxSUiJ+xxqvOXwiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="102663910"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Dec 2024 18:27:52 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 18 Dec 2024 18:27:50 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Wed, 18 Dec 2024 18:27:50 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 18 Dec 2024 18:27:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=enRS8gH5/N82yDqbrdqnETRcjzon8/A2UDx2lajQsZ0TxkbzbzvOfOHKfHPuyQsx90KSLfPDjER+6xfxj/N6/vJUiCXSvncuRMxqi7Mk1OVCZj1Cg0/bFolkIwYv5FrRMyj6/uTXBE03WGPrTnzULcPnuUwTrsf7CRjEeu+znYDFr/pwLAY8luWpfPj1rAEHhWI9g9ifvoYMlgta35qw4BfvXjlobMogbl+tPpb2VDoGyPO9+/pf3Cv28cS2va2ITPQTHPrt662Mafs7U3FS2MxzAVSjZ5Zfioh5iCXz/YzDpls0nKkhp7rVp19IDuAgGHzV5JCSZ2BzB/vrFdWbaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wS4ptZ1AqSHpPetMoAABaCO5liVLA+rFhZTwi7/lh0k=;
 b=dnJyXjjbGpIb8Ag4621Kvg7knjhjqIk9UP3py4pIWKJOQImLNlt9n+OvFydqol+uqkXkq4+so5ANx8zHkihXM/IrkC1dKnbatdQGoHzrCDpgTPzEGyUPFN77BEPbk+tLzf76IkD/N2StJEcGr/9Kr36Tx1FEgbZ0IewTGiglGMuLpzKIh5qvqEJuFKr/Z8T0+Vdc4dNnQD3NNB8C81CmwhGxNyKUb4KNMCiJ4umXd3jc2x6ZM3r7AL3gWf6NnfG/iWl3m1TUGn5B1jJ/X/uAOjL0SH7n41dCf6b9JWhNb/uDS138OVofBYWaH25hXC7VvsosLCSzS/6dNY3lv29BYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 BY1PR11MB8127.namprd11.prod.outlook.com (2603:10b6:a03:531::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.14; Thu, 19 Dec
 2024 02:27:08 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.8272.005; Thu, 19 Dec 2024
 02:27:08 +0000
Date: Thu, 19 Dec 2024 09:52:46 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<dave.hansen@linux.intel.com>, <rick.p.edgecombe@intel.com>,
	<kai.huang@intel.com>, <adrian.hunter@intel.com>,
	<reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@intel.com>, <binbin.wu@linux.intel.com>,
	<dmatlack@google.com>, <isaku.yamahata@intel.com>,
	<isaku.yamahata@gmail.com>, <nik.borisov@suse.com>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>
Subject: Re: [RFC PATCH 2/2] KVM: TDX: Kick off vCPUs when SEAMCALL is busy
 during TD page removal
Message-ID: <Z2N8bl6ofE2ocQsW@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20241121115139.26338-1-yan.y.zhao@intel.com>
 <20241121115703.26381-1-yan.y.zhao@intel.com>
 <Z2IJP-T8NVsanjNd@google.com>
 <Z2JhXfA14UjC1/fs@yzhao56-desk.sh.intel.com>
 <Z2L0CPLKg9dh6imZ@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z2L0CPLKg9dh6imZ@google.com>
X-ClientProxiedBy: SI2P153CA0009.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::18) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|BY1PR11MB8127:EE_
X-MS-Office365-Filtering-Correlation-Id: dfde2aea-ba36-4c93-c8d8-08dd1fd4a31d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?UKLMysFGDD/Izt70RLqMgpypQtdGo5DjxE2mCtwj2rODO7FntgbiKJnO+Pg7?=
 =?us-ascii?Q?WrGBzJWIgEbxYv7gT8O5uZQpQXr8+AtdZLSTBlqW/LMp5AvFPJCw4+VVhrop?=
 =?us-ascii?Q?uM5ctb6fKbSt6MvRDSUNeDECOjidAeuLDW7RPJm4v81P2FUGrzs1rvqR2qkn?=
 =?us-ascii?Q?WXwhYwjkMHZc7DGSuL93gzU5kpIwlapo+NpMQWHKhCjmxLzhViFaoicjHIJf?=
 =?us-ascii?Q?JH+VtF3w71b7FvhbNuYErAMAlBQsjlcEfr1b1dkcQsqJNVr6Diesd3Fm0nfL?=
 =?us-ascii?Q?QrcJKCHS1z+/6BtXqH4CTX1Y5zXY5/pRSWvYnwHRdMH9QKaVn6MylZ1hSmHC?=
 =?us-ascii?Q?jPd63Yk+XHnaBWqYKmOnIwQ6wSiP2XQwU4eH8Nm0DQtU3TGwk4UVC4Canrxv?=
 =?us-ascii?Q?boe6jwYh3R6+KZ9u4s4VwgjQvoLiTLaYilY7EiTUKhX8IoqtUrCbuT7cKHk1?=
 =?us-ascii?Q?NViPCRgs61vova6pkeDUsPtmXK4kKNnjy7K+/2xgfjXe2xF2qXfn5xEKw4b3?=
 =?us-ascii?Q?Bt2b7u8GN3EUhD+LF/nmhLPt/Z3VQKUur6Z7TjeTTncWtGTKGQw3lV5ZvceW?=
 =?us-ascii?Q?MeFFmUG/yIWvkwnUKl+v+p8LW/sYG1AaLs4l/YsaGghHHyLRVfofDiOd4Jzh?=
 =?us-ascii?Q?x84yRH1XUg5Q1REoSEHYMJ0jkJsqrIXKXLblF4J0wdrr9wUMoeBVhIa7sk97?=
 =?us-ascii?Q?YModTMRYn5e5LnQROw8ENLgXAPqEhwnxGuYDMTi+LK2oBWRj9XT332IIUlYV?=
 =?us-ascii?Q?d2vszsCF1/zcEZUHNcEJRGKeEbuw3yAw97tPFtujhi3t2s1onWfs0gT9A1DB?=
 =?us-ascii?Q?A80Mpe6HBH1xoHbiOJ32sYLnbtacNZhekE38Lg8V6KAP/rmMOwZ8r3e3bbWI?=
 =?us-ascii?Q?lAXtFaX4OcbUWqD2k8sBlv6hc+iUU7LRaRo5xbdygRVv6FudIp2j52rpvXg8?=
 =?us-ascii?Q?ImODGw0E36lYmujZHHtC2mDd9Icfc/8VVk1sqA0yNLaylJh0mt0iT4zEVl+7?=
 =?us-ascii?Q?uVau25e4Z4z9SCZlAHi111+ZbWVrBeu/7nBXiskrSGfGmCuo0e72+FjQE0kf?=
 =?us-ascii?Q?YcVBpQMNajg887nQd6E4STQk8+Sc9VBBilvmsHNNezUki8t2bpikRixCpf6a?=
 =?us-ascii?Q?8hP2qzyB4EbZcRkT7drmUkB4yF07JDDLL4FJuj7JvUPpcOURL9LzuVoX6asF?=
 =?us-ascii?Q?NUlz5uQ3aiMsWb5qba3yLSKfiSZkaPIXLtTq5WsavLcjUOewV0pxh/7L9FRG?=
 =?us-ascii?Q?Pxq07DPaWHco5vT2MNaGj+tt/R2LQCZ6KIVtSkwfObSkW85RWNr6vFAm6XHU?=
 =?us-ascii?Q?OREIrXvVkRk1g/JNCyxisCtUA8CV4f+07LtAdtkJL5np/Q=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?15pxRUcS5KARwM01gucbHQr9yGrKERv2FpUGvBeQKTGhzOhz0WF/oleT0QNy?=
 =?us-ascii?Q?2xXm65LdZWL2jXe1GLAKiJSmBnjMHVaoT6CF94PG9mp4HliFNFrpEl3HHr6W?=
 =?us-ascii?Q?sRoXoLoKS5gi60y9Z7dIfrzazuJSiB7B0KzXr2VZfYN5PGbNe6IV5JF96mYY?=
 =?us-ascii?Q?Htkwbkrgvap+5L7yZwWg8bkYzz+cxsbKqZl4hw6rN6GeMzDbd/vjoa7JYtE1?=
 =?us-ascii?Q?i12vIubcjaS11gBmgipE1+Pr9flrcHo5K19nSieT3WwzUuC/hFEfjQi+SkAA?=
 =?us-ascii?Q?KBQashzPZRltJoD6o3tIZlNFHB+f9KqYXlcYcywneoYFv1YlzpDvqJXdDyy1?=
 =?us-ascii?Q?A7MZ3dDp7dqCLZMHvHT0p8qfoj6X/zlmM1DY4jbop/XHdqvx+eF99bV25Hbw?=
 =?us-ascii?Q?M15FhoAp7vL9jR0Po17COx9wLORyCGpvQp/WD6JMoKcvTdmbD7wpaN+dPYxU?=
 =?us-ascii?Q?TMULL9fqfydWs31ezR3gmTn8SZHMN/I/+OXwauj79VEq6Tac3L1cy9g0ZOrc?=
 =?us-ascii?Q?aiQtEOMghqTWZe4xo8+mC2npmejuigCMwl3Kb/bqd9d9Oyb3XOME51YskTAM?=
 =?us-ascii?Q?KQcuwqAqsEniDp7rSt2/VX1X7lV1/nVSUGeXo7c7zb0YnNc0reLnPTfufNUj?=
 =?us-ascii?Q?ca+UT8H7HAC92etN8g7ZNFq9bEjdZH1oDFlMR9Cje7vdegkk2TK321emiWDv?=
 =?us-ascii?Q?u1JXDbr9BwZvezATur7Dhjk81IN6hDqtllWVkMvzb5KUFysQ7J8O89VMiYJf?=
 =?us-ascii?Q?xo6B+ie4VEk8hyoAYxPDpiQSdAzzUezytJMskHNB824T+e5E0hyMEG0swIQ6?=
 =?us-ascii?Q?UxlsOnLau6YP6Z3xGLNBy/7oK1AXN5Ls+QJmDWdv2t2IBFG7Xh+WA8EqGNlc?=
 =?us-ascii?Q?1ZYKD1avBpMmGEm5kF2G1hrwBRADxfZG7Vxg2x+uld3kdndo01tesnwTKJMQ?=
 =?us-ascii?Q?bgjuwwqP9ByI8WvpZ5AZOu3W2OqFE6nKmJ5fB8PafYtw6efs6fanCZ4chT/a?=
 =?us-ascii?Q?WVocLDDCnK55nCVY+odP7BHjp0JMT655BHKrngzPmcuHLbcQyQOi4QtXi/hO?=
 =?us-ascii?Q?y7ZuhfV6rjBPeOjXEoc4G6NiHxzrBpA0xiGP8HtsAUOQyScD0DsmHq3TocHm?=
 =?us-ascii?Q?wfSqiXryIX7yWSDOvQOSunh1Qg3ezDp7ca7BE8vENLYxSDutGko9eNl4lRS7?=
 =?us-ascii?Q?52e3gfpGIiq0fOYKLqCdxY6PJXoyC5nymb3IgfbEuxOGkFjiIADFwqBA+XVQ?=
 =?us-ascii?Q?1/m+bdlry77w3tJpD6c6IAHuePAZm+KhpWzT6y+VKtot39q6MTnsXh8vpH2X?=
 =?us-ascii?Q?rYWLN17lMGa2+cf6Y+WNzQ6iE6GAtY19i4bKbscU5G0rrmDK8VGoaM4nR8d7?=
 =?us-ascii?Q?G5MYG/fy2sdIkG9rWe+ADyuWIvsWWPj+t2dlsuI6dEjgSYeSn8NUzqeXsz3j?=
 =?us-ascii?Q?4iQaJZnHbGyOV4c6jZY9plXJNGquCklklMcqnklb+k219IRmcWIIdpcKgvMy?=
 =?us-ascii?Q?TXu4gtWmfElqVV/7yDn44xW3lJuuGVLMuGupfiakjdNZwOMHCt+22McMNPPn?=
 =?us-ascii?Q?rff0PxkQaZxKYR0Pj/SmPZuUkKCpcWnySLjIe/OJ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dfde2aea-ba36-4c93-c8d8-08dd1fd4a31d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2024 02:27:08.7924
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sLm/2BW1saO+ZKlbwN+2OV0n/TCQIjDvZyJthqZDUpaUkelzSC3EkH83DN4PdK5z9LYeX1s012TKd9/lj5K+Tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8127
X-OriginatorOrg: intel.com

On Wed, Dec 18, 2024 at 08:10:48AM -0800, Sean Christopherson wrote:
> On Wed, Dec 18, 2024, Yan Zhao wrote:
> > On Tue, Dec 17, 2024 at 03:29:03PM -0800, Sean Christopherson wrote:
> > > On Thu, Nov 21, 2024, Yan Zhao wrote:
> > > > For tdh_mem_range_block(), tdh_mem_track(), tdh_mem_page_remove(),
> > > > 
> > > > - Upon detection of TDX_OPERAND_BUSY, retry each SEAMCALL only once.
> > > > - During the retry, kick off all vCPUs and prevent any vCPU from entering
> > > >   to avoid potential contentions.
> > > > 
> > > > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > > > ---
> > > >  arch/x86/include/asm/kvm_host.h |  2 ++
> > > >  arch/x86/kvm/vmx/tdx.c          | 49 +++++++++++++++++++++++++--------
> > > >  2 files changed, 40 insertions(+), 11 deletions(-)
> > > > 
> > > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > > index 521c7cf725bc..bb7592110337 100644
> > > > --- a/arch/x86/include/asm/kvm_host.h
> > > > +++ b/arch/x86/include/asm/kvm_host.h
> > > > @@ -123,6 +123,8 @@
> > > >  #define KVM_REQ_HV_TLB_FLUSH \
> > > >  	KVM_ARCH_REQ_FLAGS(32, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> > > >  #define KVM_REQ_UPDATE_PROTECTED_GUEST_STATE	KVM_ARCH_REQ(34)
> > > > +#define KVM_REQ_NO_VCPU_ENTER_INPROGRESS \
> > > > +	KVM_ARCH_REQ_FLAGS(33, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> > > >  
> > > >  #define CR0_RESERVED_BITS                                               \
> > > >  	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
> > > > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > > > index 60d9e9d050ad..ed6b41bbcec6 100644
> > > > --- a/arch/x86/kvm/vmx/tdx.c
> > > > +++ b/arch/x86/kvm/vmx/tdx.c
> > > > @@ -311,6 +311,20 @@ static void tdx_clear_page(unsigned long page_pa)
> > > >  	__mb();
> > > >  }
> > > >  
> > > > +static void tdx_no_vcpus_enter_start(struct kvm *kvm)
> > > > +{
> > > > +	kvm_make_all_cpus_request(kvm, KVM_REQ_NO_VCPU_ENTER_INPROGRESS);
> > > 
> > > I vote for making this a common request with a more succient name, e.g. KVM_REQ_PAUSE.
> > KVM_REQ_PAUSE looks good to me. But will the "pause" cause any confusion with
> > the guest's pause state?
> 
> Maybe?
> 
> > > And with appropriate helpers in common code.  I could have sworn I floated this
> > > idea in the past for something else, but apparently not.  The only thing I can
> > Yes, you suggested me to implement it via a request, similar to
> > KVM_REQ_MCLOCK_INPROGRESS. [1].
> > (I didn't add your suggested-by tag in this patch because it's just an RFC).
> > 
> > [1] https://lore.kernel.org/kvm/ZuR09EqzU1WbQYGd@google.com/
> > 
> > > find is an old arm64 version for pausing vCPUs to emulated.  Hmm, maybe I was
> > > thinking of KVM_REQ_OUTSIDE_GUEST_MODE?
> > KVM_REQ_OUTSIDE_GUEST_MODE just kicks vCPUs outside guest mode, it does not set
> > a bit in vcpu->requests to prevent later vCPUs entering.
> 
> Yeah, I was mostly just talking to myself. :-)
> 
> > > Anyways, I don't see any reason to make this an arch specific request.
> > After making it non-arch specific, probably we need an atomic counter for the
> > start/stop requests in the common helpers. So I just made it TDX-specific to
> > keep it simple in the RFC.
> 
> Oh, right.  I didn't consider the complications with multiple users.  Hrm.
> 
> Actually, this doesn't need to be a request.  KVM_REQ_OUTSIDE_GUEST_MODE will
> forces vCPUs to exit, at which point tdx_vcpu_run() can return immediately with
> EXIT_FASTPATH_EXIT_HANDLED, which is all that kvm_vcpu_exit_request() does.  E.g.
> have the zap side set wait_for_sept_zap before blasting the request to all vCPU,
Hmm, the wait_for_sept_zap also needs to be set and unset in all vCPUs except
the current one.

> and then in tdx_vcpu_run():
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index b49dcf32206b..508ad6462e6d 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -921,6 +921,9 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
>                 return EXIT_FASTPATH_NONE;
>         }
>  
> +       if (unlikely(READ_ONCE(to_kvm_tdx(vcpu->kvm)->wait_for_sept_zap)))
> +               return EXIT_FASTPATH_EXIT_HANDLED;
> +
>         trace_kvm_entry(vcpu, force_immediate_exit);
>  
>         if (pi_test_on(&tdx->pi_desc)) {
> 
> 
> Ooh, but there's a subtle flaw with that approach.  Unlike kvm_vcpu_exit_request(),
> the above check would obviously happen before entry to the guest, which means that,
> in theory, KVM needs to goto cancel_injection to re-request req_immediate_exit and
> cancel injection:
> 
> 	if (req_immediate_exit)
> 		kvm_make_request(KVM_REQ_EVENT, vcpu);
> 	kvm_x86_call(cancel_injection)(vcpu);
> 
> But!  This actually an opportunity to harden KVM.  Because the TDX module doesn't
> guarantee entry, it's already possible for KVM to _think_ it completely entry to
> the guest without actually having done so.  It just happens to work because KVM
> never needs to force an immediate exit for TDX, and can't do direct injection,
> i.e. can "safely" skip the cancel_injection path.
> 
> So, I think can and should go with the above suggestion, but also add a WARN on
> req_immediate_exit being set, because TDX ignores it entirely.
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index b49dcf32206b..e23cd8231144 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -914,6 +914,9 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
>         struct vcpu_tdx *tdx = to_tdx(vcpu);
>         struct vcpu_vt *vt = to_tdx(vcpu);
>  
> +       /* <comment goes here> */
> +       WARN_ON_ONCE(force_immediate_exit);
Better to put this hardending a separate fix to
commit 37d3baf545cd ("KVM: TDX: Implement TDX vcpu enter/exit path") ?
It's required no matter which approach is chosen for SEPT SEACALL retry.

>         /* TDX exit handle takes care of this error case. */
>         if (unlikely(tdx->state != VCPU_TD_STATE_INITIALIZED)) {
>                 tdx->vp_enter_ret = TDX_SW_ERROR;
> @@ -921,6 +924,9 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
>                 return EXIT_FASTPATH_NONE;
>         }
>  
> +       if (unlikely(to_kvm_tdx(vcpu->kvm)->wait_for_sept_zap))
> +               return EXIT_FASTPATH_EXIT_HANDLED;
> +
>         trace_kvm_entry(vcpu, force_immediate_exit);
>  
>         if (pi_test_on(&tdx->pi_desc)) {
Thanks for this suggestion.
But what's the advantage of this checking wait_for_sept_zap approach?
Is it to avoid introducing an arch specific request?

