Return-Path: <kvm+bounces-48354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 34C56ACD24F
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 03:05:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E447B16C9BD
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 01:05:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94FC823E346;
	Wed,  4 Jun 2025 00:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SKW5VkwK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E0119D06A;
	Wed,  4 Jun 2025 00:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998625; cv=fail; b=ENG6gAro5Oic+WlYoc5RvlsKbQqPejs62iECvsz8tOPaSFQ/OH6V+lorgAQSs6eYG3qKxqEcs5w7ik69Wh3GWHYcEz7XFtbyleRsBsZF4jrdWo0gJmIHRc8Q8AEmNvKaq3Q1/L8jNBb72LE3cf6WJFdMFoEbBwBWBEBE7dVtBPI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998625; c=relaxed/simple;
	bh=yNkL1dw3Coz2JuzxTczsKJrDoE2okTjc4CFppFuwQVs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Vq2gn/Tg/EMJwmhaHNAZZrpkJHV/pWZQSjMwnLxh0CtgbUJIobxZAhCSPNxtn1y6uT/RSOfsroeOZRL5UHPVLWxIUVF5bbhSqPdTGdHFhPXl243vAOYaWkbB6+5S3Z8nSPQlFzPt9CqdQscF6kel781+D4Q3VtOE33Q5bCW3DZ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SKW5VkwK; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748998624; x=1780534624;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=yNkL1dw3Coz2JuzxTczsKJrDoE2okTjc4CFppFuwQVs=;
  b=SKW5VkwKG9JOQhJLpgIudPBXy8ekw5tzcLtr8b8rAVnJ3/bYDy77G+/D
   ChNy32oUsct4olPJwdHcRwcep+RMccPXP72FV5hYd8VPkSc1QpqgCfaiW
   7TQHid8VoTjXWvyxXoqbW04Ngdfg76w2yz1OfuavlxfVQpC+/CmytkPFo
   79KjHGaP7F684yON8+U1aIGi1AJk4MzWQwNbL8VChZZct22osCZ0+wNps
   SL2Cr+Nn9aoBf3amScAT7pmqz1VMTVb9BfbQt5csRH/b5abLU0FFHq3Sg
   m16WeVpbAZk42XM62zqkru0E+ByaCMBbck8897a89hepPiM30NOtL/lmI
   w==;
X-CSE-ConnectionGUID: 6umWQEnpR36D+RGioAOG2A==
X-CSE-MsgGUID: 2EDlzELHTLueGeU1AMcP7g==
X-IronPort-AV: E=McAfee;i="6700,10204,11453"; a="51059204"
X-IronPort-AV: E=Sophos;i="6.16,207,1744095600"; 
   d="scan'208";a="51059204"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 17:57:03 -0700
X-CSE-ConnectionGUID: vpfcCSU7RSyfyJglR7S03g==
X-CSE-MsgGUID: 4jEJ3+reQG+/fgnjF07WDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,207,1744095600"; 
   d="scan'208";a="150176772"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 17:57:03 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 3 Jun 2025 17:57:02 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 3 Jun 2025 17:57:02 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.71)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 3 Jun 2025 17:57:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RqKszMzuATdAdPhxF4q5Sm19lme3eMGdU0hHynUETb2Xpo+DGaewRtHUXq9UBXBVcmu15Wm60DRkTz8NrH5JM+9HaJOMXHTATxPTxKpsi3VX1oiSWUbYHS2Mn2sMG7F9VLg1JUYGBjmY1h5aCEB8M23wSxcARZsuH9X9CsGli2YnXfxI6Hgjs+ce1XECRtIrqIV/wjCpES8FVy2NjFzaRgOyx5NMaVxZh0UOZSjMdHh0nsFNmPWi89wWj2DsjZuAV2XjNIdkGOPA2Ug6wHtipnx5DnOTItx8fRgToSTQmE1XsHQ1Z/Wm+WaTQgJl1Rgmnk4tsCVHXQjotKm/kS+u8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yNkL1dw3Coz2JuzxTczsKJrDoE2okTjc4CFppFuwQVs=;
 b=JYN5uCw4uE379djmqts9TFY/vrqVHu1OX+w+AzM2dab/dWL8AeQufbch/MXVBowiyEODgsk4rixS6jxoC99sx5k7H/rP79zszZlOY1kYlV8yiAJ5PeWp3l6+YDy3jmhvtJrtPe0n3rEX1kEYRJTeW/ui600LWCcw50lKjv1BfZ8FuH9dGlJuK5BHz7o4ZLGRWqD3vRniMEe/ItB/aFjkE65NOCZdyyN9KI5kS9OybsBQSFULKx+SrOWUvPbGLkqTLF26zaxGuvVqx30oD1tv492IjJxah6dxT/Ze5ZiOLFnhhpdYZJbn/SQBfEX0swJhLSawGwYqIbcx4sCpVVtTpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by IA3PR11MB8919.namprd11.prod.outlook.com (2603:10b6:208:576::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.33; Wed, 4 Jun
 2025 00:56:25 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8769.031; Wed, 4 Jun 2025
 00:56:25 +0000
Date: Wed, 4 Jun 2025 08:56:12 +0800
From: Chao Gao <chao.gao@intel.com>
To: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<tglx@linutronix.de>, <dave.hansen@intel.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>
CC: <peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>,
	<chang.seok.bae@intel.com>, <xin3.li@intel.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, Eric Biggers <ebiggers@google.com>, "H. Peter
 Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Kees Cook
	<kees@kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>, Mitchell Levy
	<levymitchell0@gmail.com>, Nikolay Borisov <nik.borisov@suse.com>, "Oleg
 Nesterov" <oleg@redhat.com>, Sohil Mehta <sohil.mehta@intel.com>, "Stanislav
 Spassov" <stanspas@amazon.de>, Vignesh Balasubramanian <vigbalas@amd.com>
Subject: Re: [PATCH v8 0/6] Introduce CET supervisor state support
Message-ID: <aD+ZrBoJcrGRzjy0@intel.com>
References: <20250522151031.426788-1-chao.gao@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250522151031.426788-1-chao.gao@intel.com>
X-ClientProxiedBy: TYCP286CA0009.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:26c::11) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|IA3PR11MB8919:EE_
X-MS-Office365-Filtering-Correlation-Id: 09493d27-7aa5-498c-4818-08dda302a152
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?kOTodHVNxyegjUeOiBRFP5s5pZOa1D6PDTZSfSW6DuMOX3DUmHzgfiKGck0t?=
 =?us-ascii?Q?XSuGaODdmZaQCHioR4l1xw+ORnaNcPg2ThoA16Bz+9YmqX+huA7E1nHD53tB?=
 =?us-ascii?Q?9c3WlnTGqJDl9neNq0qR85/er9rJnAvZ7sDV0YFSINoEQuWupoUKNAXoBYhi?=
 =?us-ascii?Q?ZQ5c04GrmK7dDkclk9s8JH2Wb6GOWqZWq2ZoSzMPaFkalJ2fghS2lfAZrAov?=
 =?us-ascii?Q?as1EKg2mXTSOTcRmipVXJTVNmSn14MRJVaAOqoyVxR5hsVJ2HHKwIAbYhEy7?=
 =?us-ascii?Q?On2ppDFrLIUlVeuVC42YUDT64iISPbcEJF1fZYBScSGhK/bb8rgNgRoLdQNN?=
 =?us-ascii?Q?dCmAgVnG5nLRsueBK0hT8lzL/jvBF2HcIrY+b6ichZx2Foz/XE8tony7OAKp?=
 =?us-ascii?Q?V1w/NdiUjomve2CKTzr324m++xt9vKDKKlopD3wvwxYePg/hOXRpX2OSFLcj?=
 =?us-ascii?Q?cfl1NQ6r9bLQu63XTOYxlgT/0KNahEW/IB4W8OPs2TanAaTUC38Q0M4eeUXQ?=
 =?us-ascii?Q?UL9cOLIFlX/DI6nq8GmCz3dxdlRs3JRHjkl0NSQKnB9+/p61/d/tJRkT0jJG?=
 =?us-ascii?Q?/vzExR2c6vJNSRCY+V2cNk0k3kHtf4EmGfP3p0cdCvH8FT/H6jZ+/VbhCvgd?=
 =?us-ascii?Q?/6r3xoHe9akQtkmRI64xxKr9ICd1715tZcAW+qhDTatz8clOBcP9NZROBFHp?=
 =?us-ascii?Q?EiaqCUAbefn0LKaevBVYTjbLB5gMxR+rhmx0k+Q/zTOCZGEdMuR19SKLleSe?=
 =?us-ascii?Q?Z7b3M2b9iXr+mLN3P3lZpAigF5nX1WiES2W+jF1zromIZaoJjRuPARubuq/J?=
 =?us-ascii?Q?t9aOq3c6BvWzxSuzMHoxDBxHGry8QSF9CHyOrPQt9oz1ZmdgIaw67+2I6xe+?=
 =?us-ascii?Q?0t9fKHEvGg8iy2bH2dflIWhZDxJZ7wcoIuhUMQAX43A2bUhoyc5/A5n0P/cQ?=
 =?us-ascii?Q?UlhJxqjV97qDeKzjalsOhxvmU3MRy11vtFYdu9rZ3tly8gi5wczIv7CKbPEt?=
 =?us-ascii?Q?qq/jmVuAKc7L2mfTi98bgWwSeimGxA5SoGqERBXUFI1LmtLqxOEz6uZNDYU/?=
 =?us-ascii?Q?OSQ1SuQ4Jb9W59qdLLYLcZnHho6AHwRZug9vRa1tDkwHDtZpjuOgB5jxm0Yy?=
 =?us-ascii?Q?qka+4D5vOQVitxceO1x3xxeBvnLQIsTrujvEexcTTg17y2vS85htfFG2Efr/?=
 =?us-ascii?Q?MIxbl+i1XcZNRMgZkyu2waIDicCT7qjFj/ko4RCunEhrugHHhn4/M/fZ14NL?=
 =?us-ascii?Q?rwQGxSnPKo9fgEydwG3yQisJk7xVnCVK7CRGCmc3uNiw7danJ4OoVSpLMtD5?=
 =?us-ascii?Q?rnBVQH8WLcUyN1lA53jAMoPwNmBXSJynMyrNadkCnD9sMv9HCXZF0OU9A+i3?=
 =?us-ascii?Q?ZZdEeqUSauBnvKo2C27kezURrFjP14Wdqhc1mmrSCO4X+DHzHDL3nhyAE565?=
 =?us-ascii?Q?0vE0ySqae2Q=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gTjejPJjpXd+o3RQ72u02o600fY1wJ7VZPiYcLGvZjWBDjenPiORavjIW+KS?=
 =?us-ascii?Q?IY16ytbq57GK9cPnNhxxpefd/Vdqm4PN3+jROQwMRPVT4cZdpKhPe67eAKv+?=
 =?us-ascii?Q?UtthmaOigZgx+nGKTMbiM5hQGWQu5GlwULHG5SgQkVVV5grVIkH6sLfLvFzn?=
 =?us-ascii?Q?sc/P056xoX536DmOpFGy0idHhgluDKdlh6jdVQQDjHG3pV89kBFnygDZ5kdF?=
 =?us-ascii?Q?aEVEMaCQOJRz/AxySXNL9kU5+OXkeTyHh99A4ylYUDOs3aGuacH0CsKzmZqc?=
 =?us-ascii?Q?4zvFytlOcihv3EZPCvCqSo5dcIju4DfCoAto18MMoo1XqNMs7sdL0gqyzJmF?=
 =?us-ascii?Q?6O+PbmTXJn5owNLNe73SsaboQwwynBVQ1XFAY36lm3FV8jmKtFRtS0Nqk/Aa?=
 =?us-ascii?Q?lNwFjoedJMmjoGhdEjjCE4OTjJAyiSoxPMqf0pIwCa7dR53whJY/Y5JuYpjF?=
 =?us-ascii?Q?EZ27y3Az22JYkmEOPNU9eLjj2Dcb6iX2O2HuTpUDHHIjfTAT2hjosij974dF?=
 =?us-ascii?Q?kiUOsKP2OZmE3sP4XBmKyRechXUiGl4yyh4/u9XTC1WhHdcaPHg80XxTV11M?=
 =?us-ascii?Q?/LFlBxwejKa7o7s+rjPid2Bm19J05ifXL9u0fYbFG3iXTQ4LSC7wT+ZwAoaq?=
 =?us-ascii?Q?uNko72eAh/tOCitC48Vi4MNbXG5+qK/CvTyHkJJWY40p0FNPWoTw6hCi+pkb?=
 =?us-ascii?Q?b88oFnTqj4o30tjPdh8QYe7ncwj2yhFHHAmUOrR72D3beWDvEI7Uq7E84Dx4?=
 =?us-ascii?Q?Fcx1NTyKn1jXwsSwlMsoWLYjC7KQh4f6LjaJ4pGG9VXUC2jW2s5jwpLTfNTO?=
 =?us-ascii?Q?3Kc63jE0hOFXvATT9mDudvTv91DDKIF3KehShlngwJsixbaTDLgNa634o63x?=
 =?us-ascii?Q?lWeL9M5KG3h2p0DCv6RAxnMcJhdMzCrro3Cfs41Hk4OAgus6L0QgglsAX5I1?=
 =?us-ascii?Q?Ks/s2Vtw8evF2yYIO0bkOft6/MXqpvxNbSDcf2TPCqKRW1UohAgsIVuneufw?=
 =?us-ascii?Q?Dod1z5/gSi8ryjbKPx86bBeVQ5OVGgQf2C3t4BXIsO9XfN/XuyrnASXxBF88?=
 =?us-ascii?Q?GqTTQ9Ll1FH+yRgVynSqEh0LhpJOHMjg+1T1jCR0TweYIiiC04V1F15jU6k2?=
 =?us-ascii?Q?TgO+g9qFkzKaGSFprfcAW5cqQqV6Tp88a8DdTo1MF/w2mz48wbXlG+LZuIwZ?=
 =?us-ascii?Q?KILySzs8jDLCXUHGR2tBXRyke9Bw9lHj5gClykqWY5jG/1svq6X24Tlxpy6E?=
 =?us-ascii?Q?8jjgtpkedKxgpBz9DPdu/siz2NObJwnPZ1mo/3cajYduCN+2MXz2muaDAWA5?=
 =?us-ascii?Q?SMe818RvG1VdUasnZmkCGn8KyOnkEUIaYSnNmExB5hbVbbXmqjt9cew7G8if?=
 =?us-ascii?Q?FdeyKJ59DdFkY1wZUqZB42JaCtiuXJe8EMVNfmS3DmIPdnyYZNpaT4hivkym?=
 =?us-ascii?Q?RdCHrWoHbOZer6tMgHBNBfFBsq6fPtKyOpH0MBw0m/HIgXn+C3rzmCV3nz69?=
 =?us-ascii?Q?J3Xz4Ql3MP9an43u7stjQ0rVzkzqbVGvYaQkBevToag3/Ufv4BI9C/uWmXM1?=
 =?us-ascii?Q?J4sdBPjUG1SKdcSjNT3o/2FQVXuhvI8zlAxNaIrr?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 09493d27-7aa5-498c-4818-08dda302a152
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 00:56:25.1545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E5w91p1b06I8RZlQQB5VbgQT7CjNm4i8Gehi+1LOkzxaGbq3A4ad6m1QkUX+JmtRCQVPhqIkazkgeFGwFfQAPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB8919
X-OriginatorOrg: intel.com

On Thu, May 22, 2025 at 08:10:03AM -0700, Chao Gao wrote:
>Dear maintainers and reviewers,
>
>I kindly request your consideration for merging this series. Most of
>patches have received Reviewed-by/Acked-by tags.

Looks like we now have AMD RB and the other issue (reported by Sean) was
pre-existing. x86 maintainers, please consider applying.

