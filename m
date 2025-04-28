Return-Path: <kvm+bounces-44520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 238C9A9E67D
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 05:26:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 428A03B0A34
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 03:26:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D7C21991CB;
	Mon, 28 Apr 2025 03:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HrtK1rW+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE83B2CCDB;
	Mon, 28 Apr 2025 03:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745810794; cv=fail; b=enmx6GcoNUCuuXNZKXi8EK2EdJNKjWndq2zGXIqmKWczKZdg2na8uGpjK2uSfSy1PTIzQA73fSrT4Z+E0dSfpzav5Wn2jFyyrXIvA+H5gi1bFnVjZ3FCbp17UDYiZZj5ogXGZT1CJz2zvZPyZFetpX1VFg0mrRldxK1HXvg/a7A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745810794; c=relaxed/simple;
	bh=4A8sLSHprtJSxhIZ71IN6yTVtHKIdz7Yd+nZnfaY4Sg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=msN8S2LA19K+QRKZJYC6OT/bXJB7RgF+qVWUcthRjuFwHPHPsI9uqPrAb92tUHv9xoFN0cXN98kMEk608nHMwyuUFVYEZHKCuK2rYdu5lP6031FBv/ORT7JffS9NqUT26otJhyxoLLMl/UfjGBUMB7Yo/Pvw3PPGBMJg7tXHXuE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HrtK1rW+; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745810792; x=1777346792;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=4A8sLSHprtJSxhIZ71IN6yTVtHKIdz7Yd+nZnfaY4Sg=;
  b=HrtK1rW+Co0pPJuLQLRFhvubYqoqAR++WP/nQC60g3QqwJDgm644ji/2
   ESa2JU3u52vKBRsqa/qSlCavnXivsRfWhv9qaCPCdsvXKFKE23tueCR9A
   BczAkrGmTWd2446rib8KpgMxXxlZ6xra0I2oDfgsJkQI9g8JD2QhQ3vWK
   lZYdf8YYHDQ7JfzrXBGzj56hWllO7KNsuAhUWgbAShBB885qJGPHtk48W
   98AOYDmxXrsjBykWaxANbqtMyOInCvEwjZnLJvbZxShFnAM3Rc7MCJsD0
   1tOt+ZaJjrOqpZLqrRV3s6TGNkmhwZiTn29Y71HhXXAca/06cy+YStcZb
   Q==;
X-CSE-ConnectionGUID: 4t1wERlFSwe+QD0ABa1Okg==
X-CSE-MsgGUID: WDZiQf4GQTK8NxED2cpS4A==
X-IronPort-AV: E=McAfee;i="6700,10204,11416"; a="64922734"
X-IronPort-AV: E=Sophos;i="6.15,245,1739865600"; 
   d="scan'208";a="64922734"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2025 20:26:31 -0700
X-CSE-ConnectionGUID: dcaiDHUjT2qMm8DVtlB91A==
X-CSE-MsgGUID: SbTvNgw1T8OG6WpFQNg32g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,245,1739865600"; 
   d="scan'208";a="138210454"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2025 20:26:31 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sun, 27 Apr 2025 20:26:30 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 27 Apr 2025 20:26:30 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 27 Apr 2025 20:26:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kAeFu0CyGd04V7GO/cKMkBMSTlJfvotYslQT4GKfq30kFokBkuBO/FWFlLehQRpMFomYoHo4hqqKZiASHj2M7Fx5wMZ+xj+g+dECfcHf34zHJk6aw980LapX9PgcuOo55JRwTNknTbVof7Y4JuTLR4m6MyU3mJAcRA7Gjxwq7O+7rTcGuZ/b3yDYrjYddkguGegcfjus5PSGC8cZaBI4oIw17cp40L4P44borGKfaxmubi5smYz5iTsfOLV6g8xWM04Mh2T493362Jn4DQyOIkW7nBaQBYdh+bFiiKAK15JKhi19UtJlZm+U/Q45auIQ5CYzoZ6D30dJG/md6GIzBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4vMzi4qmgGjjI0Uw/oI1wghrhhfSyZa50HrfOI14O7E=;
 b=AGkEpDrqgnPzyp2/fPPdjaOEOOtYEQBAKwQ+G6AD0p17wjv0PUPyza930fMph2svcfFQbTdDmYW1ksgWME+gp+sgne2xQHAh/7a1UdR6DZfXqZj+tE5uyhBFGjXDZL8t+UDJP77XQ5/zem0lgmLggmjZ2EK31BTa1NZCyaEfdNmDwfN+zn7UMYfIsZFqEz2+gKUda2xvC2qclVZA9hX9Q99P23nh0vSTd6twfF6o1iI2a/bTgu2Zs64awiP6119tyNSEfbb03CFPERcCv1MbhoorqtDRFkX8CDhcNXJhQ3snSoq667I9TM1WTEBiZPbLq0Q4iVlkUjoz3WJ20U7Nrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by MW5PR11MB5764.namprd11.prod.outlook.com (2603:10b6:303:197::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.27; Mon, 28 Apr
 2025 03:26:26 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8678.028; Mon, 28 Apr 2025
 03:26:26 +0000
Date: Mon, 28 Apr 2025 11:26:12 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "ebiggers@google.com" <ebiggers@google.com>, "Dave
 Hansen" <dave.hansen@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, Stanislav Spassov <stanspas@amazon.de>,
	"levymitchell0@gmail.com" <levymitchell0@gmail.com>,
	"samuel.holland@sifive.com" <samuel.holland@sifive.com>, Xin3 Li
	<xin3.li@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Weijiang Yang <weijiang.yang@intel.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"john.allen@amd.com" <john.allen@amd.com>, "mlevitsk@redhat.com"
	<mlevitsk@redhat.com>, Chang Seok Bae <chang.seok.bae@intel.com>,
	"vigbalas@amd.com" <vigbalas@amd.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "bp@alien8.de"
	<bp@alien8.de>, "aruna.ramakrishna@oracle.com"
	<aruna.ramakrishna@oracle.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v5 3/7] x86/fpu/xstate: Differentiate default features
 for host and guest FPUs
Message-ID: <aA71VD0NgLZMmNGi@intel.com>
References: <20250410072605.2358393-1-chao.gao@intel.com>
 <20250410072605.2358393-4-chao.gao@intel.com>
 <f53bea9b13bd8351dc9bba5e443d5e4f4934555d.camel@intel.com>
 <aAtG13wd35yMNahd@intel.com>
 <4a4b1f18d585c7799e5262453e4cfa2cf47c3175.camel@intel.com>
 <aAwdQ759Y6V7SGhv@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aAwdQ759Y6V7SGhv@google.com>
X-ClientProxiedBy: KL1PR01CA0046.apcprd01.prod.exchangelabs.com
 (2603:1096:820:1::34) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|MW5PR11MB5764:EE_
X-MS-Office365-Filtering-Correlation-Id: d21da4a3-154d-4d90-9f4a-08dd86047546
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?s56StiaL6UhM59KB3HaN0Jj6rlu2j3NLsJgWHQlHQZWGcsfskaYLnwqJ9iQP?=
 =?us-ascii?Q?APbeo2rWn0O3gaENy+mTNRPRPEq//UY0uZr5Xo45hZMFZKvbBqvhcuRWj/II?=
 =?us-ascii?Q?Q2nbxFVbXvVbYf8wXfAsjknD8zUPqRX9z1qb5lYnhz6eHYsNjbwpO1TSx2VP?=
 =?us-ascii?Q?IC0Grntl0h+W8y73r77qsPN+PWCrVENPWj4qWrJ1qiuBbCp77UIvFxX3QotE?=
 =?us-ascii?Q?UCkcX5FrEYcwmlSJzFJUHSXJ+knETOXgjWMcGUz9le6+PZY+eMGOuIY9Mxju?=
 =?us-ascii?Q?ss7qVZ9+G8rbVmS4aKCESquvuc4xh5E5sNfQaJlIoPzKpturRD7qcN75/It3?=
 =?us-ascii?Q?X7cbYsipMVU9FZGsFY6DZb6AhI8t+EEovyXd/v0T0YZ7ikO2k1Xm2g9RmXnG?=
 =?us-ascii?Q?FhTV08MMSZK3d3vSDB/gTRAPKD2QyJoGYXwrKsbKvy4am7VqqmrXWTyJPybC?=
 =?us-ascii?Q?HzLSNcHlzyhthKoRK5aVORNw6YlSm/sVrYceJFE5LsTJYbNCzSbp6Lt2fTaN?=
 =?us-ascii?Q?z/kSKDBBPPGX2QEjyQBSK+FLppui3zBLUkFoSzHsQC51t2z+0zhpqYfA2rFa?=
 =?us-ascii?Q?txoHENRp13rnyTKfCrdsNWF2aMeeTWVG7o+eMqYuGAzL7XvlYyWYvMLIxBFt?=
 =?us-ascii?Q?kOTQE4empL/smOPXnfyq9Gh9jKZkt+E5gC8sm/WyNF4Ik1OB2/CYXEKYoHZa?=
 =?us-ascii?Q?xyNS4WPJXz9b/zIeNVl2ZNuDDcrxmT7XCOjYx7rk0v4R4r0Mv76g2j8KAKOx?=
 =?us-ascii?Q?/w3dXuQhWxZBLFSGOetPUHKwm7JZxLYw+ijJTl8alhpjtzW8TqipAJDKx5Be?=
 =?us-ascii?Q?bWAwk7GeZauWiQb+/r83LNpzIukPWS12J4YGIeL9E35HjYmnJyPQ5r5X3dNx?=
 =?us-ascii?Q?cVNhW1wpZwJsOofSpOFqyyeB4Fa5todl8MqXzkMbPmTC5oBMhxyvlnwRJa8m?=
 =?us-ascii?Q?l2wyGuNoPzV9CoXH0uYgCqANcfwlQHa5Jt/fa9r76jqlZDnmeekekOUCciZ4?=
 =?us-ascii?Q?QUjCFmPSxBPNE5qJd7afX1EUtRbOjRa323nJM3QSJmTz0s/1cSeXSpZVKcF9?=
 =?us-ascii?Q?ZiQGM/duCbSOBqs0BHJdo7wsnHdCm191QFdcLHumtCjj4FcGDoVjqYq4Wd3t?=
 =?us-ascii?Q?dU3OeGMkq4uSeSlvvAN12vPpuUJMpmZeCzlXRD+zfCrJ9wS+H0yJegR8KQPd?=
 =?us-ascii?Q?M2+EOt6iyUMKq321nefqVrL7sjCUjpz7aFrsK5a1jXa5C4Hz+MMRg7x/Lqki?=
 =?us-ascii?Q?HrAxFMCCJ4JggdthEFEvCbyYV5V5FK5EDpBNttJt4aMFtjnbT6wVJHz+gPLR?=
 =?us-ascii?Q?OIGG63vK07LuXWkeOSFJQeQss+Xl2sMpyef/zebUaezQUZD/HhJ23Q7i1GjN?=
 =?us-ascii?Q?xC8465QuL30v0z6feo/i06KCbdNx/v5bSsdTFjoR+QIh/2HF9VRjUkrHbc77?=
 =?us-ascii?Q?GTDomGIp+88=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fShDdXM15DSYzMD3SQcBni7zQxMLHiCHG4xZDr7wHZmq2Rk30rT0O3o58X0g?=
 =?us-ascii?Q?+OLC2Rj11oS2uWf5fI7KnTKTJPsC/yVABgm5NFwS7ZvLryPOPAqjyL7/kCQA?=
 =?us-ascii?Q?MgS6TR3FQI4ZHR1ydGD04H7g96YLsBUzBI9wWn9ZxbAJ7F+urQMGXppHjl6O?=
 =?us-ascii?Q?uBd71VLO5UgfWoFrXgwLyQ17Zb24k7n84vXP4YY0BhyQIyyNJbAv6xztrgJK?=
 =?us-ascii?Q?yTe8fnFqGPX4jEbnyS+ZcrA5/eu478lL+ZqOr0qEZriPZytpY5E+aKPx2829?=
 =?us-ascii?Q?dX55X6rP4IicATuFYnBU00iWEugfMM3CzSh5DRTd7W7VhtN/6D+hVmNHlA7h?=
 =?us-ascii?Q?/hLZfoKzuii5CVunv2k3nZutWJ7NWVyyTk5asAB08whOvmg6Jaq4IkxyIUWu?=
 =?us-ascii?Q?bT5cFGwTYqoIofOLcnVSI7lC6PVD91suwsiX2AE/mEb1qT81T0lwOvQiUCwD?=
 =?us-ascii?Q?vD9A+GhhnzCtG2LHPt4Gs+vyQzkPI71LJhi/PtQphfXQAhVpbSclZMQi+G8R?=
 =?us-ascii?Q?K1SANWGvMk98lyKnNA4ScEoJcn+196/+sbVXZ/N1ksgPz+CFjyIetMRK5JjW?=
 =?us-ascii?Q?pxtGcxy6K3gMtukaerxfQcwJsFtFEAGet6TUSVVsrJ8/Lh5xSuHPUAsPa/z9?=
 =?us-ascii?Q?iL4+BxkrLADj7qNpVw56vIHPPtdwah0Yw7W9xmrXvogiUj7yvtfvwJR0xm2E?=
 =?us-ascii?Q?f6vFtTxTymcaFLtKGr3GL9ryVlfW6/CJoqMmZqjIfNhFXfjySKa3ahCb6lmU?=
 =?us-ascii?Q?510OQ4Skz9As+2Eo2WmKB/LMJZc1vV1znjTmcWLp772Q436E0wo6zBHYiMsa?=
 =?us-ascii?Q?NBd1M9n5tEcrR5EL0moIgWuH1AzrWwiJllIdd0dDxeh5oZLvMCtgd/bk9TmV?=
 =?us-ascii?Q?rB3FPZBUkHgI0vKjhvt2//ZxJN5pWru9oJY0L9uC2f681RIGt0gJ6ggEjO96?=
 =?us-ascii?Q?ApKC0CkMs6pI961ay1Wly5mwRSHZFS117W6S3T0MGOJArR75nqjt/ms2xtpd?=
 =?us-ascii?Q?dlCwslBO5arARiRgQuRvAWTLxn1QEbxa26OByxykHLP1pt1eZG0qv0j3wqzd?=
 =?us-ascii?Q?diJpia2C6TlkAEWQn2yAd5ep2aW7FLkUbozDTFW52jOPlX8MpkrcUqbyaOTh?=
 =?us-ascii?Q?dliN4fno4xS30ZwBHmNL1j7bvcWotndpE/Eo5juBpKrQu1cocKwK9WuF1Q3p?=
 =?us-ascii?Q?yTINOF/Qixw76lHswuiX5Rm9prEJj+rNiDHqvdNFqObxMfyD9vv5e0kpcYDz?=
 =?us-ascii?Q?Ryo/Jkc3o69ytX9ltO4ZxaZ8zLX+sGCUKNppgQtxlmZr8nWgb/tY6AaV/7m6?=
 =?us-ascii?Q?fVbFc9syY7AYTTweHBNuIqdaSF7Hfac3ApZ/HV2jEaIxnTp1b4IuuEJt3Xbe?=
 =?us-ascii?Q?zHVEcTOYe4n1LxXLrvLj1TX9WfRD4QcIpVtGBvw3570ZlGjJX6TN67W4PCXi?=
 =?us-ascii?Q?toYlLfvJ8qgKiKgtoRQV7pi2j+KemkuJV4UEsFVIJrBG+Xy2yAvnMXI6r7JC?=
 =?us-ascii?Q?8TNhfg/VzDmLtxK8A1FkCbzW+WU0jj4aVoD27hnN+bC3U9aodxtXxdvIbhH5?=
 =?us-ascii?Q?KGjoa63C/ZLTmXyhVNJ7vn+gzo+VBSEAuKfqCo+B?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d21da4a3-154d-4d90-9f4a-08dd86047546
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2025 03:26:26.4252
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: btJWT2LIhgfSBkXYnHyqSYNLTYw/p0grI4e+6+sOqsqmIFhBH6KIJvlkyX4suq5HqdEoeo5UrJ7MLEd35/kj3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5764
X-OriginatorOrg: intel.com

>> Hmm, interesting. I guess there are two things.
>> 1. Should CET_S be part of KVM_GET_XSAVE instead of via MSRs ioctls? It never
>> was in the KVM CET patches.
>> 2. A feature mask far away in the FPU code controls KVM's xsave ABI.
>> 
>> For (1), does any userspace depend on their not being supervisor features? (i.e.
>> tries to restore the guest FPU for emulation or something). There probably are
>> some advantages to keeping supervisor features out of it, or at least a separate
>> ioctl.
>
>CET_S probably shouldn't be in XSAVE ABI, because that would technically leak
>kernel state to userspace for the non-KVM use case.

ok. thanks for the clarification.

>I assume the kernel has
>bigger problems if CET_S is somehow tied to a userspace task.

To be clear, CET_S here refers to the CET supervisor state, which includes SSP
pointers for privilege levels 0 through 2. The IA32_S_CET MSR is not part of
that state.

>
>For KVM, it's just the one MSR, and KVM needs to support save/restore of that MSR
>no matter what, so supporting it via XSAVE would be more work, a bit sketchy, and
>create yet another way for userspace to do weird things when saving/restoring vCPU
>state.

Agreed. One more issue of including CET_S into KVM_GET/SET_XSAVE{2} is:

XSAVE UABI buffers adhere to the standard format defined by the SDM, which
never includes supervisor states. Attempting to incorporate supervisor states
into UABI buffers would lead to many issues, such as deviating from the
standard format and the need to define offsets for each supervisor state.

