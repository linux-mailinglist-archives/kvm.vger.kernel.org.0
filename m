Return-Path: <kvm+bounces-40470-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CB21A577AE
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 03:45:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 678631709EE
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 02:45:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C901114F9F4;
	Sat,  8 Mar 2025 02:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ay4p4haA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5783814D2BB;
	Sat,  8 Mar 2025 02:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741401906; cv=fail; b=odE4ypVLKh1DSjJvDl5TG4h/edNYrDrK3vmmyBjw1eG9BA/RwOIAbpLPzS7+CdW39EgeMKlf5cuep4RBeGVLJokV0ODhF7+hKQ+ZTVmA9QSk5z+MCO/PcgJ51gVJGw9sUk3Z2O48WFEqO1z5/3OnYf295D5lHQRDrf+0IQSXKr8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741401906; c=relaxed/simple;
	bh=56GUI1Qh4MM+AOhlPa4Fiy4OcJHuY+x3BobTzbu4Oas=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ByIcsVw4ttPSICpUvKJRBufK5ETBh5YXHulRGuNn8EDzCGOfLPTaqccMR0KmYvNZ/LruYFjqfZYCAyU0ytkTbLdxC4InGUXPT80ecZHIyF57oFtbczuEmn37xbl8c41++W+6Qi4QeCmMM1jHvolnHarky6mP/8exgXuE2TllXRU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ay4p4haA; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741401904; x=1772937904;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=56GUI1Qh4MM+AOhlPa4Fiy4OcJHuY+x3BobTzbu4Oas=;
  b=Ay4p4haAoiyXRn2yEL7G3y9AhbGS6z3vryD4QV96cSqhHSMLT4xgUk1K
   t47qunIx/p6UVeqU/fQJyDw8ZwSMzVnQzXKL83HAmnCDgAccmA0RVAsy+
   Aq9TYdfydl8rcXjdIeXx1vnfPwxZve0ZmVehPTYVB25UHNxUMSk6xuxZk
   6TBOJz1vvP3u1uKkxtQWchf5IENY1i/g+wg4zLdCBArB097nd4pKZJzoq
   8K5Qd31hJZGAq++lPolbHqXcN56Wm5VJj58C0Ci3WLyEyUh/UolhaiDee
   Ejz9nFFZUD1azXueBmmTiq84c5HBI9TI/Q/5k27ZGsyKT6qV+5YerPp56
   w==;
X-CSE-ConnectionGUID: vCuVSWu3Ryq8UiAUhXX2Nw==
X-CSE-MsgGUID: BM2AsPEXTGGYGWizqybkOw==
X-IronPort-AV: E=McAfee;i="6700,10204,11366"; a="52674474"
X-IronPort-AV: E=Sophos;i="6.14,231,1736841600"; 
   d="scan'208";a="52674474"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2025 18:45:03 -0800
X-CSE-ConnectionGUID: qEHDLwGwSgK/4bixZiO4ag==
X-CSE-MsgGUID: sktJoBqoTg+IkNZa3YBdkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,231,1736841600"; 
   d="scan'208";a="124404259"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Mar 2025 18:45:03 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Fri, 7 Mar 2025 18:45:03 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 7 Mar 2025 18:45:03 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 7 Mar 2025 18:45:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VsK6S280rmmGYT28rZuQoDMGe3FsHo4D1brrcTCCn9n47IV/KNnJhCozbXDU6Zxo9rMPZcS22Tbltvez3AyNavNL+Lzehga39MVyaNUUDQyG2alO5io4mEFJNb9qeIHXBXC1Pzg6rpjI1eY3505Wh54j1msLCUZlBKqB5n3Czy6LvKSHnX9LyHQuyKvP9WhkeqWFyXGFj6iUBa+SnmibxjKOdaP4BQHjn/d5sXg8sseEeiIPsojJAhqtG+bKFZ5OuxANiN08tzoEfgH2j8U7L6UjO6Z5QZ/n5Kh343HIqdr8PqZabEd2QN9CX+YepC11MmSrpTiKCmKTztC5AYj69A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QIEfjG4X6i68vXV7ZRpR7/GPWHNqIju2eZcBNU/0nTY=;
 b=DJ72L/PNndy0fgQ86EtZt9uduxmmKhphrI20IgP6EMjoUYdiWwI7fjhBhpuNBcSceR2SxZeAG2T00u3qtPaKVBDRzFwGZmhlThL/9MVACnQK6Gp6KrCr/9OuxRNf7vYkcVUxPWAdUlPFyT56WHDx9RTuPHKdY0oTwGK92vDPCH7VpQRboDbTo3LySMmJhsbU1t+aHm7cn5ZQf+g3BoUjVzf1pdeJdOeFHe22CrHBPOvtxTYowlID8u0M5CGGi6d0LM1P2vx2qQVghGX8vXgFnjc7YHLRLsoek6RH6vp5wGZ51GW5Y9O4W1AcGmF0eV5gNQtH5Fmbu5peuqk1oVNwUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA2PR11MB5209.namprd11.prod.outlook.com (2603:10b6:806:110::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.22; Sat, 8 Mar
 2025 02:44:55 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8511.017; Sat, 8 Mar 2025
 02:44:54 +0000
Date: Sat, 8 Mar 2025 10:44:43 +0800
From: Chao Gao <chao.gao@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: <tglx@linutronix.de>, <x86@kernel.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>
Subject: Re: [PATCH v3 03/10] x86/fpu/xstate: Correct xfeatures cache in
 guest pseudo fpu container
Message-ID: <Z8uvG9d59kevJcXR@intel.com>
References: <20250307164123.1613414-1-chao.gao@intel.com>
 <20250307164123.1613414-4-chao.gao@intel.com>
 <8f94cb20-68a3-48ca-ae4d-c6609d63e30a@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8f94cb20-68a3-48ca-ae4d-c6609d63e30a@intel.com>
X-ClientProxiedBy: SG2PR01CA0130.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::34) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA2PR11MB5209:EE_
X-MS-Office365-Filtering-Correlation-Id: c92fd486-862d-4b60-66c7-08dd5deb3522
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?o5g/dwmJWF0vQAY3BZnAjR5C0Djd1gyp661P8KNZpJTPILF/bnSayBlFVAyP?=
 =?us-ascii?Q?H2nZleXsOT5eBOxYG43SeKYsqJ5I1vBFCKNXJotRc4G5nICaYtV/ysyJRS2i?=
 =?us-ascii?Q?6Mm3T1+63jmnEJsb2iv3RLNj+qCDpxr4e8hV4oWD8BdKVGrtorWvnr7BN/kx?=
 =?us-ascii?Q?2xvQq7C5KraKX1EQVoTvBYXMfck2A+AtQtWnLw056oi973DfDgRBKhJzkLzv?=
 =?us-ascii?Q?r3CSDOCVsQeQ9vOg1m4V3odFSiSS0mNpUZOvBcWlHSoCTFYpDVtKZMd+KYzZ?=
 =?us-ascii?Q?K0tuq953kWQApCLZRhLmnSXoRx77BzNW6kYuEWMcxirbqZR2TLQuSvHTPePD?=
 =?us-ascii?Q?bvVWzDefiLWNieKDWDfaAjqNFH8EfZYkyS02uWeR57LjkDcIG8fRdOCmUaUz?=
 =?us-ascii?Q?SqviQ79uHmlrbsaEPOGqeF24u2XIDd1DYi4+t0bAVhodYLTVntcvZ6C1m5DA?=
 =?us-ascii?Q?F/AV+UGaEZ7lyNFiaAqEzC0pe2sj4L8L7mHcBK0H5Jz1tY5j93hzJ12OlCVG?=
 =?us-ascii?Q?pJuJY2lOYbXO1Y0ikfeMp/VOSLg1UbXg5rfzQJkJBtrWYsWQBGeg3SLgPS8n?=
 =?us-ascii?Q?CpIF5HG8PLu7O7hD3JMxYMWJ6MopMwMS8dnuNgmUpKwWzx+D7RRBUx2b1Ojm?=
 =?us-ascii?Q?mzFj5Zt6ayxa76TwW3pP8uVvUDWm7fFvTZMVENvbvV2NaMYyHFyscslK6Cjr?=
 =?us-ascii?Q?poJB1FXykAxyYXcWXhieqGZf5Wv8nAt+DnXhNlnr/rOPX1WUYiv1n5MuHQfk?=
 =?us-ascii?Q?cEMzEBezTFICrftQGAou7ax6h7RVRjzTaPl3147q/7Hu1ieJtESJ4XXphUAR?=
 =?us-ascii?Q?BQuGji047fR4WH4xG3Z2tMIsZcKEkhG+Qto1yrF0kcUmzoxpzIkynEwQvhlg?=
 =?us-ascii?Q?bWYQxxmjYtZYuvadeFvv73mndg8EKAl+XudHUk0SmcQVHXWJWt3QwMajo+zb?=
 =?us-ascii?Q?8OgoaL6t5w9gVPovcKbayjBKHTIDOtH92U+MUjgtc4Bj6dS3x+mexX91bddg?=
 =?us-ascii?Q?yqIYOuk39hKDu43InHoPbMwK/OJz/NY+kogV4Q9aVbc2Z0n6epNffSSqmOju?=
 =?us-ascii?Q?eXEdO753HPaiqyNcqvLiSm8rtNGoZzU0x0V3/XlSem+n7xAyOAJE45DJR2sF?=
 =?us-ascii?Q?d8SKp/NQ40tl+9Mpoucx8ReDubpvFUZiJ3OeXlmthC1208LnPIzukY5lVmg9?=
 =?us-ascii?Q?dacRFomcBlhLhGRY3fZKUatAvJiQv9XQLzGp4FLu+nhzi4FGfNK8ZHBAmJVZ?=
 =?us-ascii?Q?sh6sNsfdY0PxmCNOjIHJqSnvXMi867/+CM9mnQfToA3f15Hn0Qo/LKuTMFb/?=
 =?us-ascii?Q?ikA2NoXJCHpU4QbXMCbBiIB4LBZG7GsDBEdNCrnZSKYEf8CNMuW/Z7p29pr0?=
 =?us-ascii?Q?NgVVLFI0tKEEb+2pTTmI/o8J0Rjb?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VWIBBLbKYfVU5bylN5gG8tSY1YWvNHi1/OcVxs/j3NdInzOLVmNK/2nDWVjy?=
 =?us-ascii?Q?5+WxOCiuHyrG9wKUOueJkQcXd0s0ZiEmFtlnaXMXagEz948I15rGx33DyjkJ?=
 =?us-ascii?Q?5kHTvpQPeNuEOw0+CqNGUcONPN968d7BqljL0Ghi6hfv1/2Cmj6Ga0CC+JjT?=
 =?us-ascii?Q?RU2T3/TgCd87/zAQWI39sFXGLD9mTxBRjp9uhJxKmS9LeLBmT3XNJMGS4vkW?=
 =?us-ascii?Q?3OzqCdF8vRqehPsOG5vGY5WvC8CyRWLthoJv6LclaBluO2Oi935JUPzYmnai?=
 =?us-ascii?Q?w2r4A5rS0ROmFbOzxZ+i40Kz2q/tn9ucopKbLxT9h8PMO0dXNHfxQKCjFa6e?=
 =?us-ascii?Q?dKSV8Xhr3hU2PpofgUc0fihSda/HA07W+2T9O9v9w8kyr3W429UjqM/XRTpC?=
 =?us-ascii?Q?CQlFa1HbJpeWUnMXaHdT2fJsfoCWm70RKk258lJXvEd2I8Cy64sh9e4apXlX?=
 =?us-ascii?Q?AAGu6Ki14Jojk/h4WNykbdB1DbI+KEJV5iHoWP7BGpdeiADxzHVBppDdSmUn?=
 =?us-ascii?Q?Lbpm3ClM1tCAGLOl9Chzk/m2iQuxIm4hH0nviUT5gi+qqFoRDFJpz2zgu681?=
 =?us-ascii?Q?gVrnrX+KdYa66K946ngsRtzCBr+JUityeBza8oxb22kC2Icqze8yK949VB+6?=
 =?us-ascii?Q?5sNTR6OBVz4dvF4topNEAXAplLjKlFNSUxhmdO5tO7f8SnvTIw5TEvHlz+ID?=
 =?us-ascii?Q?rW6gFSoWNplZ4KOLE9W5vAJG2/qXjCjf6wCtgjrYPop45pdQRgcE2k8lD/31?=
 =?us-ascii?Q?/bXCaNESZbMN0/JK2tP9rT1zv61kQcbHchu0R9FvxP9PDvDD5c1z3A3qA3br?=
 =?us-ascii?Q?JavoY39WJ8vaEuiTmj0pPrmX1yBgcjTbBx6KuNH9jGjDVcln+ESpSoRaZebC?=
 =?us-ascii?Q?iWqSd+1iGo6hjsrQrl3hQbBHon5sIRBPzMuO5dbWTmym5XnXVA8cFxwJ4fV1?=
 =?us-ascii?Q?YAcM5vg8ub2SKGfY66kfX8baFewovHXrd46MW8l8yDT8a/JuV3mXZD/R285Y?=
 =?us-ascii?Q?ESZOMARS7icqwhiYIRcixY9vH/TpyEnfTfNth/GeR8V14K006StrwAk9KEl3?=
 =?us-ascii?Q?ERisGxpzuxVH2ooqg5D+UqoaasB+DtdF0IPccH3VK0G3cJSZd7e2gxJcRQFn?=
 =?us-ascii?Q?hpDsflt4q29tMzYNNm7nizGifwJF5QnmtXOsLseggP9Ls98rwYYVZ/9StMf1?=
 =?us-ascii?Q?ZMrR4X3ODXk899TU/cp4ljatLTl25bHGHdFK7MgyTH22e04j4ORJyckBFpd8?=
 =?us-ascii?Q?foG7jaJFm9qJ/JbjBWVYoVts3OHGD12+ba73JER+2Ams5QYgrdwJVqCDtUSC?=
 =?us-ascii?Q?o3903gbTtIamL7osuT0IjQ+1GYd4ML3K8/VqUKcPG/s+Rf4eVA9z5OZCUESw?=
 =?us-ascii?Q?AWtz8o4NYMLwzSLeXTr0kcHgABY4BVvjLqeyEfml+/MhQPAdLO3FtO3+SPCD?=
 =?us-ascii?Q?bn5GDIjTwDdwKRYp/M4ktbuR3R/EpBwOESMraj7z5vLpOci74nFihIQ8c6jQ?=
 =?us-ascii?Q?7z9tCyf1u3fyY0rCytrHr6x5WTJrLJPRytKEYsTKZFf+DFibmWdaIdp9j2lw?=
 =?us-ascii?Q?jlocnJEqITZmSfh8h2epIrARuxIHu+u0MmEGfm5M?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c92fd486-862d-4b60-66c7-08dd5deb3522
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2025 02:44:54.7722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wE1QnBJeez/2fCI7gUJFGfRxJ+Nw95JfsXH4OnbYyGsV8rU/mJ0K0jE4rL7C1DODWMEdIO9EMcYMXfxsZwn84Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5209
X-OriginatorOrg: intel.com

On Fri, Mar 07, 2025 at 09:48:25AM -0800, Dave Hansen wrote:
>On 3/7/25 08:41, Chao Gao wrote:
>> The xfeatures field in struct fpu_guest is designed to track the enabled
>> xfeatures for guest FPUs. However, during allocation in
>> fpu_alloc_guest_fpstate(), gfpu->xfeatures is initialized to
>> fpu_user_cfg.default_features, while the corresponding
>> fpstate->xfeatures is set to fpu_kernel_cfg.default_features
>> 
>> Correct the mismatch to avoid confusion.
>> 
>> Note this mismatch does not cause any functional issues. The
>> gfpu->xfeatures is checked in fpu_enable_guest_xfd_features() to
>> verify if XFD features are already enabled:
>> 
>> 	xfeatures &= ~guest_fpu->xfeatures;
>> 	if (!xfeatures)
>> 		return 0;
>> 
>> It gets updated in fpstate_realloc() after enabling some XFD features:
>> 
>> 	guest_fpu->xfeatures |= xfeatures;
>> 
>> So, backport is not needed.
>
>I don't have any great suggestions for improving this, but I just don't
>seem to find this changelog compelling. I can't put my finger on it, though.
>
>I think I'd find it more convincing if you argued what the *CORRECT*
>value is and why rather than just arguing for consistency with a random
>value. I also don't get the pivot over the XFD for explaining why it is

fpstate->xfeatures isn't a random value. It is the RFBM, right? see os_xsave().

The xfeatures in the guest FPU pesudo container (gfpu->xfeatures) is to track
enabled xfeatures of the guest FPU. I think "enabled" refers to RFBM because
only enabled features need save/restore. so gfpu->xfeatures should be
consistent with fpstate->xfeatures.

They become misaligned during allocation. Specifically, gfpu->xfeatures does
not track any supervisor features. Excluding all _supervisor_ features is
harmless, as the value is solely used to check if XFD features, which are all
_user_ features, are already enabled in fpu_enable_guest_xfd_features(). It
just causes confusion.

>harmless. XFD isn't even used in most cases, so I'd find a justification
>separate from XFD more compelling.
>

To me, there is a discrepancy between the field's name and the value it holds.
We have two options to fix it:

1. rename @xfeatures in struct fpu_guest to @user_xfeatures and update the
   comment above to state the field only tracks enabled _user_ features.

2. ensure @xfeatures in struct fpu_guest matches fpstate->xfeatures

this patch implements the option #2.

