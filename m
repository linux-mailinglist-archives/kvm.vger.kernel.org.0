Return-Path: <kvm+bounces-37944-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3237EA31C11
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 03:30:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 34EC318823AD
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 02:30:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDC6F1D435F;
	Wed, 12 Feb 2025 02:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jaaymYMj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1305F2AE69;
	Wed, 12 Feb 2025 02:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739327390; cv=fail; b=TqgqUrclG6GlwlA57bJlNrlEKoDvaa4jBQuwiFScJtOsbpwPzf8PWNO1frv0s8rDHwdsxzGxnxav+XAhW+XNRvVGeEjCfynr3rxhmPQCULneqNN0brBEpJXMyxBYR3WyRr8iJAulqDIwp41V3cnPkqk+YpXPdTQc2uFh4f/Sdyk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739327390; c=relaxed/simple;
	bh=WzE912URGieu+euYPgf0h2VGJrMrnhDVg6bxgnm1zuI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=VY2REeVpopkGM7oUeMOBKEbOX8IbPEW/tKGRXkr+3NIiavlclUfxMxaNBWqcrtWhAa4qF+APiSVCs3hpJJB7xdXn0FCgndWv3ah1rc8xZ3ON3Jn/g0GN/jF3Eo8ntwLqP1kstzoXAT0Ic3O6KOR4djTT5Cr+ZnxOca0Sz/PUh10=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jaaymYMj; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739327389; x=1770863389;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=WzE912URGieu+euYPgf0h2VGJrMrnhDVg6bxgnm1zuI=;
  b=jaaymYMjhqwZZ9uHE52GWAYipft1YlvFyxnS48mikWoh6nzJRRpzDE8t
   ruKf2St3w10TC2QDmSqDmq/LwMAfg2edf6DLXiBaCsaWIwTbLmwiH4/1k
   isJ3BkTWjbl3IjRV6Fb2nJ6a1vMdBlFRsafm9fgnDLawalHHreGhuIZg9
   MHcWcmCt62gTYY4/15p3M9/zinBgHg9H33nLAWqeoZ1E/IIE577VDtddt
   umL8VnmLQjvDIuGOi7zINPNNU30JpT3cxOdRdJTZYXLXVMOWMbZzNX1eS
   juKw58DiJtdH1VrqRjCfXzVS33K/b4N2/fBoreTLbJ3USV1NxnnKwpJF5
   w==;
X-CSE-ConnectionGUID: OowMgqvPQO2UQoCdMPwNLQ==
X-CSE-MsgGUID: FOG4hOJVRMyVzbu8kvIulA==
X-IronPort-AV: E=McAfee;i="6700,10204,11342"; a="65325055"
X-IronPort-AV: E=Sophos;i="6.13,279,1732608000"; 
   d="scan'208";a="65325055"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2025 18:29:48 -0800
X-CSE-ConnectionGUID: f0/ur6tnQNK2izkBcLGswA==
X-CSE-MsgGUID: IzjhoLuESras9k4G0x7rag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,279,1732608000"; 
   d="scan'208";a="117768752"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Feb 2025 18:29:48 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 11 Feb 2025 18:29:47 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 11 Feb 2025 18:29:47 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 11 Feb 2025 18:29:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DO6qtLO7+1ZkEAlacepYX3S2Ii/O7li2e85oAHO+4AHdR0iyWC0ki13Sej9WwmLCdSIHm3Js5NPuIjwrcRnHe8UfytfbDRj3rG9+C1WpYkGQUn7P4ggsQ9Gl+7k2Fk9j3RRwyIB0ZkilV2WWXTu4gASMMTtYjJKqnKubqpbGFFbv9RHYOY54FJ74aVWD0IreeuwQ8dW/KCAurCjfoIddAKC1acopk1XIZJgNwTTKTNyt9tHe3asbDp9ICU2EHdlhjO+h976m9gukrN0tX4Ck5rPeky7WZeVJDt/GPrmzl5ezrTlP0ESb25dYlRFWKVZz2VQrpXNFmbf6njlh+O/mIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hk/lZngYBLMtQkNHtF59IPje7Ndn+nIBw4kvMeVXo40=;
 b=DWxoI5W6LfbMrfZjtOQ/EyCmmUTVQIDMz9dOsV09AX2nFbQYl3hv42WoU2zdBsemn4nrEmS5BIc3K1rgeYAeb5gSRXwl04LfTNeyjdnINzJKeRJ2vPdNc9/P332zfjxv6Wd9XrbRyyltJp5SBFISty5Jln5uP/UfJnorPWsDn1pD80pwxJW2JuFAAIoZDiOrQNt50GpSLzgus+H2DeTZVspfaDqZas2bMisY2zSdPFvGHgcIX9Trq3xmnDrFu+kFm8hkzNW6X8oDOHkByXUhI69OGB9mQKa8eYfoWpa6mykT7EQfVtlETNskdST2DN8jDqUvQJCHF/2GwhwIXLKPsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH8PR11MB6609.namprd11.prod.outlook.com (2603:10b6:510:1cc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.14; Wed, 12 Feb
 2025 02:29:04 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8422.015; Wed, 12 Feb 2025
 02:29:04 +0000
Date: Wed, 12 Feb 2025 10:28:53 +0800
From: Chao Gao <chao.gao@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <kai.huang@intel.com>,
	<adrian.hunter@intel.com>, <reinette.chatre@intel.com>,
	<xiaoyao.li@intel.com>, <tony.lindgren@intel.com>,
	<isaku.yamahata@intel.com>, <yan.y.zhao@intel.com>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 8/8] KVM: TDX: Handle TDX PV MMIO hypercall
Message-ID: <Z6wHZdQ3YtVhmrZs@intel.com>
References: <20250211025442.3071607-1-binbin.wu@linux.intel.com>
 <20250211025442.3071607-9-binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250211025442.3071607-9-binbin.wu@linux.intel.com>
X-ClientProxiedBy: SI2PR01CA0001.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::13) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH8PR11MB6609:EE_
X-MS-Office365-Filtering-Correlation-Id: e33f7acf-c290-4557-2c17-08dd4b0d0479
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?pwSzY6o7vF/VvlNLwLmIX/5nwCXgusx02H1B7WWw/nBb9WzuMFCII2WqPAGm?=
 =?us-ascii?Q?ZWlGXmt8dWfkPCUVOtED1WdvgFKcaYRuzP6eY2Tx/aJikNtbM2UfyX2cbHZY?=
 =?us-ascii?Q?PHJrOMFAj4/PesuyfLf5FMSoBfOL9hzwjUcLjIevquINdpWrgxEPwYJZGkMG?=
 =?us-ascii?Q?PhuRMS5r/rlAjkf0MQvkqI1/hyjl4DoWcwouHdP9NkLGg6elNLlysJyRzCGv?=
 =?us-ascii?Q?1MManJwCJmu6BqUW1BTGAZ20PiwA3XKZTVELbdRfRKGOy+8wkelMyL36PV/j?=
 =?us-ascii?Q?q6ef8XmmeVtzM2kfxaVsPnOxn7V71DtK2cz6qnQaj4JuJ+CCOYCrz7LCdWf7?=
 =?us-ascii?Q?3X5sNNJPFeoV4y5v9OHBUabd7j6OA50YMpg9qncUZ5aZcI/bA2lKrmy9rX45?=
 =?us-ascii?Q?YWpuwD7SgnnTLCxKJeVx7DF18K+wjNJXQlM+Nb3mLCXZWfp3ORizHy2YZ/nV?=
 =?us-ascii?Q?7SUKHp8pnRd/83E9wKwMZrphw3X2kT4ZmsY01zLuf/4sXxjDY1LbIEy5hC9j?=
 =?us-ascii?Q?KslVLuPdJGChZP9Pn4PtfDD0WFjEnFlLOW8uUlSOuv5RGtUEFMOypqJXE+bi?=
 =?us-ascii?Q?WFE8r/p+oMegi/yVhyGqKqp/XE6s18MBrXbrlUaPkUCq7j9u0CZlmH8GP7fc?=
 =?us-ascii?Q?iSB/BDrXNtB+4MyvRkBDxhVgWaUzY7pZcE1EkyFnR8+l0Wr8uYWOv3UexGRc?=
 =?us-ascii?Q?od/nGZMBPt/D3YiMSE/NRgSTqNtbqI+D6aZ+FtwrpQWdms873bMr9FqlLXd5?=
 =?us-ascii?Q?relGQ4/l3Sml+xuRLNnhOXfgDNLZbgk/+dHKRBhEetPEKEEgibrPIc31Drd7?=
 =?us-ascii?Q?Uk3J1aBSCfOjJr07zJtKwMQG6QQvllvB1tUsD4+hiT6Cqg3UM+tcU1oJalTC?=
 =?us-ascii?Q?qX+43r6FAeojLS1eiOsMUx52pR2VBsMwjEYoxOZne7bYb2jVW26t6lUSD/yD?=
 =?us-ascii?Q?YMQsIaKYLHAbzkvihuxSv/V98njtH08FdB5yiJeoxIrDdYT6oS3ssNvNC61i?=
 =?us-ascii?Q?119tU8OfEICbGVFngizu5nC5z04MPgk6kYcPBFjLSDHD9kRC2XpZpodhn3a4?=
 =?us-ascii?Q?8nAFytX/SSWj9+jth8sULCxUiqH0h+6zesTYv2RblLh1r8SSWXtI++fOaOCW?=
 =?us-ascii?Q?JDhTMnbPAQgjJE5tMoACJm/q6SNQGHHFOdtsv873yGBVzvJbWGf1LFaGii2v?=
 =?us-ascii?Q?ikJqL2PvGloEc4hKI7dBS822OgWl0Uvp/B7IMxZBaMhN8Dl3QEBPK3S8oFkG?=
 =?us-ascii?Q?qaIw3sEN9GuFc9oD2bDi5wtzQfHn9+K5m7D+v7ubcAtf1TGrQ1NwYo24q3YV?=
 =?us-ascii?Q?+1MNCq1gpwANX/HqxJfIm+HCCy0eCRoXMl2yLoOSro/UcXo4IF3CuVCjFwG2?=
 =?us-ascii?Q?qSFdvJrsFa2bSh6aOivYBSJzD7M+?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2O3IDCBAC7E1KnGRD50F4H0zKSgFnPfeRHCYEDph7rfoGv9/FkfU8lNG3bCH?=
 =?us-ascii?Q?XfKNVQmnJuHehz438vGOrqrq+VLuyQyV2MAjg7ZhQJa9iT6iNUWj41IiKCno?=
 =?us-ascii?Q?gaDjlOBTyZ0GwLQTmYWmlkBF6EL8U0k7gbPCVP34SPD0nQgEabIui1YTz6tI?=
 =?us-ascii?Q?ZHhRcI1J/codtgShOoo+iahz8X075TCgR8QD40PlrEHavuGltgO68L7Ombq0?=
 =?us-ascii?Q?zTcXNxdoapWyw9KzYRdLICc1+pGl9pJCB5diDFlL54Thncoou4aiQbV6iiST?=
 =?us-ascii?Q?SJfvZgN5KM9FBYK6UVXK1uizwPTcDjjJ6W06A9Z1nWDJuj9+Sr6lCpVcaVXX?=
 =?us-ascii?Q?FmcBkkSmRYQof89pZrGBi2p4M4Yvev2rGhT/lrqOBCwvgFwMTBUl/Zbrqc38?=
 =?us-ascii?Q?ehUmQsQ9Y1/RT80fpEBk7APVxrIgEaS/ys1bXAPHH8ZSbhmOUCg893oQeLjR?=
 =?us-ascii?Q?/gE2xh9okDjxnDfKg/0hWbQ8Ql9861sjuXkdLQTPjsuJRjO+y9DlAB1cE/SU?=
 =?us-ascii?Q?NVk/vjDzTefsVY9n54bVwyYuEHkUoOqbRicWZuc+mQgo1tjK23K0APZoTLoO?=
 =?us-ascii?Q?1JSC9X78dH494fTjr2EwML7Zl/TYFBPx/Jb+ZNQC20z/X7MWDv1mRiBUuL95?=
 =?us-ascii?Q?AOqeRy/GYlRZwOdFqtn8rtfpdG0xWvQxXE5Es+vzM2cTMh56IV4Mz/P0CkSv?=
 =?us-ascii?Q?Ks6HB9tO6e62VG1m7VySYBUOrG3+kvRiZr0ba8/GMvLmZvv5oF9TV6MOeYKz?=
 =?us-ascii?Q?/whcGW32o5XZw449okCMwdgdSstZsKNlwliziz1kzAiAe+9g1L+TMNiM3AsB?=
 =?us-ascii?Q?WljAxMIV/TaXaWC+6O+o/sRWm9hNugqcTbV15NJ5xZ7WhUB7ANPyp9iGYvDb?=
 =?us-ascii?Q?8bfgY1/fH/lP8LFOwVHp1Z11NqFTD2elciHAFxPdFqF8MYq/08QnZeAzhz20?=
 =?us-ascii?Q?0wkmrrp7blCUPKvByVEU5TOR6YA67RbPTmyjSx+ksFUkT0OuSjSY74VVe5n3?=
 =?us-ascii?Q?6dkUZOX++ftfnMRRou38eC5u0IzDcPSHAU44a/drr8Mc82Lmf7EMyB2f8Us5?=
 =?us-ascii?Q?eYS1choBhwo7UpNxInDdqyIbOnKaRe0UgTrcleLbwi644dePnfsYQxDKWHCP?=
 =?us-ascii?Q?xnWRXJotyEwb2Ub6qJluv1rGB4LNwrkoZbQ3zosaGByM3TxtuWBYOsvjcWr7?=
 =?us-ascii?Q?UbiorkdaizbubBtrJUg5XMfDUqzng1NBn8P7XYIIpZs1IvGOHLoEiE+z+BbZ?=
 =?us-ascii?Q?2OmQ9LtW4pREVGS+Fv382Uq5GSAs6d9I8YVeF7rjHdLO+C+JGeqruGWr4Sr7?=
 =?us-ascii?Q?0wgsUOJG51GZcXYDyliEwaLuL9u7GQ2fKPRkIuNcA3onI85qFlc1uapz8f+7?=
 =?us-ascii?Q?E57hgOyTmJ+xW2F+XJO6VJnlGWURfCrqQWMurOoyuOK2f+XgRb6HZ1PD4WZ4?=
 =?us-ascii?Q?/kC+OD/rvZOlHSyjhop8r8NXP4jbzklc87nrT8L+QKkb6pwZuCpzpDFfGy0k?=
 =?us-ascii?Q?4gfCxrkB8Yi5w+pNiATKrKo4oBsNLjvWmBb9Jm1eZkk3ALvnAoBBbsbCo7Ww?=
 =?us-ascii?Q?wmgkZPn7BXvoXq+//avM9ooBNgxRk52l5+jr3u+5?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e33f7acf-c290-4557-2c17-08dd4b0d0479
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2025 02:29:03.9886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 17m8lB7SLX1IBhyMG9LY/pTiOv1D9yanl+AZ48AfnRDCBkSrbky70Z3C3WekhDQH9vsmkg3IylzdOr5A1HlWgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6609
X-OriginatorOrg: intel.com

>diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>index f13da28dd4a2..8f3147c6e602 100644
>--- a/arch/x86/kvm/vmx/tdx.c
>+++ b/arch/x86/kvm/vmx/tdx.c
>@@ -849,8 +849,12 @@ static __always_inline u32 tdx_to_vmx_exit_reason(struct kvm_vcpu *vcpu)
> 		if (tdvmcall_exit_type(vcpu))
> 			return EXIT_REASON_VMCALL;
> 
>-		if (tdvmcall_leaf(vcpu) < 0x10000)
>+		if (tdvmcall_leaf(vcpu) < 0x10000) {
>+			if (tdvmcall_leaf(vcpu) == EXIT_REASON_EPT_VIOLATION)
>+				return EXIT_REASON_EPT_MISCONFIG;

IIRC, a TD-exit may occur due to an EPT MISCONFIG. Do you need to distinguish
between a genuine EPT MISCONFIG and a morphed one, and handle them differently?

