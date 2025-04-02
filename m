Return-Path: <kvm+bounces-42476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5775FA7913C
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 16:32:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D2C7188C46C
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 14:31:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2F9723BCF5;
	Wed,  2 Apr 2025 14:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RAZ2TlMW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6B72D7BF;
	Wed,  2 Apr 2025 14:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743604294; cv=fail; b=sNt33kk8QTv/JiKpTZmw+BtpHSwIvyaxuIn8aE9r4EoJ96ED7KYPoJy5558ZEIFgpeJXjGvjd0w8llqlIG5U3+WtqOlQD+X9xjWCEfn5pUKb7Yuu2EPTtDJ/jbNTsZvL9PwGOzh3OQl8+f9VbhJL9sIffpXhXNFx6AcRxUHXvvo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743604294; c=relaxed/simple;
	bh=A7F4EfVQjGbzTcU56LBjwjz8l+1W4xoRG/FXVaD3Tk4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XRi/dAqwsAVbg47V22pQubKWWAulPSyV/dRLh+/U+gMjefgs8/8G/x8hKn0lhHi7BsquugCkkuhA2plUyiglaxyBmTtJZXmBgzYtZwaWMbyrd8Fy0g3DulYfzzyAFxtYTH1IzicD8+Hjj/iFHKJyKYY5WgrjBEV6ompWg8ooO6I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RAZ2TlMW; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743604292; x=1775140292;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=A7F4EfVQjGbzTcU56LBjwjz8l+1W4xoRG/FXVaD3Tk4=;
  b=RAZ2TlMWfXEfKjUw8TwR9ECX28zC7wxksm/hO83/2RSdjgnYI4NxhLuH
   TCUyq5hG3dcRNNEOv5scIzHRY48KP+HdistpeszHy8gZ7scP51qPVY/xE
   yH+tX5Z+bI1nkdV6xw7DlSI4FZbAzBCofO5ZXK0GuWHixAcfE7c8UuMWo
   p+ZnJH9CaIaYsg4LCw/iEQlZBo7SkseJIpJESa4jrn8cTVcJ3k/N/tsxq
   rkkKze/xria1o4BrH1aFsJTxAbp79Jh808t/MLIL23lLE6o7twGtZIwCZ
   0tqvyURQofUkWhh2f3FTYSioSJdC3NDt4g/w4pzTAwwEVjIB3amLKJKw1
   w==;
X-CSE-ConnectionGUID: MQaUApjuQb2nB7BmbUXiLA==
X-CSE-MsgGUID: UBCdCdlQQX2GoAVZ0nzeyw==
X-IronPort-AV: E=McAfee;i="6700,10204,11392"; a="45146511"
X-IronPort-AV: E=Sophos;i="6.15,182,1739865600"; 
   d="scan'208";a="45146511"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2025 07:31:31 -0700
X-CSE-ConnectionGUID: Owm3rtajSpWY5yCkiWFnXQ==
X-CSE-MsgGUID: i8j+N8TqQP6WVfKJShaGnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,182,1739865600"; 
   d="scan'208";a="126698778"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2025 07:31:30 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Wed, 2 Apr 2025 07:31:30 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Wed, 2 Apr 2025 07:31:30 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 2 Apr 2025 07:31:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jIk8wwsqBfGuv5loe2ZNdJh1uOH1C34mcdfsxdeDkP6/eGVO5ixffGCn4PaLtvZ/pq+xejze3BXn4+ItCbxRaaweWjKPeOjRnV/mljMdJMdCuqiPV5+iVYq1LvAmgDen5mHXut6dcgepXTLnYd+V++kvtuoVtmw1gtIdTIMvEJM3gGDkDyglYlELQ3I9jkt4THjA54rAypTyRHtY189c7coy4ieDqYOBdAkyahY7EWeem+0oXVwcE0H8sG3tlz23wdresNzjHD+vOS/f40eFX5uIVGi0PLkNCb53L3WtduJNV8C07CLxfCEaUEg/Q7FEJ5y06SyzAtor920FTdjOVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sAK5E8PRFUBAVPGLj1BUoAHvsVssaYsOsXnFYB3B/UQ=;
 b=TKrdm9cwBk7E0Yt7d8cuZtBiaYBJP52voEsK1Iy9vX7OCGb/aHuTxZzrICgekAY1g3QXJLkzeI60V6ac9Jouj0jGkJj+uuCBszmHgCGboDjGIHHNEyiTJC1jr8fHjmgpGyM4ODhvKvMxOi8D+v6Uienec8D8PWEP9bn4tcfajij/AAMwdu/EVu4baz3TsNoGSYOTwXW1SjY8Jr+9WGXtfOIZNGVSkR7VlnkL46ABAU1aX1mhoTmfIbAeNcJeBF5Jlwx2sLXZfn2jh+1cqjXb44iQX8c+rNt+FIIFnLXBl7QqIgDDpUc38EPLNfP6v5vdOteqnBzIRpDFdDs6sh2Fyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DM4PR11MB6477.namprd11.prod.outlook.com (2603:10b6:8:88::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.49; Wed, 2 Apr
 2025 14:30:42 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8534.048; Wed, 2 Apr 2025
 14:30:42 +0000
Date: Wed, 2 Apr 2025 22:30:28 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Chang S. Bae" <chang.seok.bae@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<tglx@linutronix.de>, <dave.hansen@intel.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>,
	<xin3.li@intel.com>, Ingo Molnar <mingo@redhat.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, "Aruna
 Ramakrishna" <aruna.ramakrishna@oracle.com>, Mitchell Levy
	<levymitchell0@gmail.com>, Adamos Ttofari <attofari@amazon.de>, Uros Bizjak
	<ubizjak@gmail.com>
Subject: Re: [PATCH v4 8/8] x86/fpu/xstate: Warn if guest-only supervisor
 states are detected in normal fpstate
Message-ID: <Z+1KBN+s3CWdTN60@intel.com>
References: <20250318153316.1970147-1-chao.gao@intel.com>
 <20250318153316.1970147-9-chao.gao@intel.com>
 <ec953e80-a39e-4d42-b75e-6f995289a669@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ec953e80-a39e-4d42-b75e-6f995289a669@intel.com>
X-ClientProxiedBy: SI2PR02CA0022.apcprd02.prod.outlook.com
 (2603:1096:4:195::23) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DM4PR11MB6477:EE_
X-MS-Office365-Filtering-Correlation-Id: 13e941c9-a904-4ddc-7d2f-08dd71f2f285
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?LuFna6bw3N2dhU2ztyWyzJoetRCLEJ7V2sC19UsZBqgIKqeXbTHcvKv9t22U?=
 =?us-ascii?Q?909stdznbVkFlCB5r6xkCmPYRrjEeBc/AFcWyVLPt0GsMJgDAxX3GoQ1eQ2u?=
 =?us-ascii?Q?gECFP3CWfBn64UrMahT4c3w2R9IEbYw94sEHYlQ5J8TM+8m/xRvaSTU947ZQ?=
 =?us-ascii?Q?J8HamvmlJWLukPyjzmisxByS1k4gBV/6KnvIKjZOVX1XA6vx1kMgL5AFg4Ph?=
 =?us-ascii?Q?Sb1lrAWVpvzokGHDBwqnn4yqn4thTmLAFFPaZ3na24h8FlZBh5V5LMCgB5Tm?=
 =?us-ascii?Q?m2/TOov3q8DwjdXihybcBgm6pkHX6oE+mUHmwjuQw4OZ7bGQF77ay+RCYS2x?=
 =?us-ascii?Q?0s9LNIgEt6iuzx9azrDLacVT2M9KfpVjT1dphT6y9w8TAtDlkXlABj3HoQ3W?=
 =?us-ascii?Q?apPVKhgsKy3aQj29DUVyefb6yPCfV4nWzfVefOiDyp23CR2C3mb86jctdCcu?=
 =?us-ascii?Q?bYI25GjdHZLV2AA1YhY2J1t2xFPQ8xjEfonEggBIZ7RTtNKoAq20LTCVEYaO?=
 =?us-ascii?Q?O3lGdj4G0qMgx2a/QhjVYFyjgComIdx+8s1oa/5dwSMwIrBfn74tbu1L20Ct?=
 =?us-ascii?Q?k4ZNLu44HzW0ghdyhJlnvIG9LRJjKO19FYTU6dkjAiI3rNDqLGqfkYpA+52S?=
 =?us-ascii?Q?HYaTj+JgQ8Zj7hfzHXlYJe4VExm8PjXjuwij0IuTjlhA2njo4G3T2vKknWsZ?=
 =?us-ascii?Q?IXuuJNuubkoiX6thy1O7Evu2f/7VWRT66iT8j203q3YDHRujsTHXDP1adxPT?=
 =?us-ascii?Q?xt02qYjdyTKG5T1AYWYaQQ4hSZJlrDz5LY8sLzxSzwIbF0Bf6P4apuQ6/tHd?=
 =?us-ascii?Q?CKsMUDi4FUHR7NGOU3rQTZ5VPYavxIHQ7GGLjuXvepthpN1DeuJu7F7qOGnA?=
 =?us-ascii?Q?DgZ/DCYgKj/xzYdLy04+8YechAHeTE3kcLqKoryOCqahXCRXQzmRIXEgIOq7?=
 =?us-ascii?Q?M3r3AMvGyqnuQ71ixsJn3l78E6o9u48SBu0Iejo5MYQXJSZDWrHj3hH9drNT?=
 =?us-ascii?Q?nHmetLjKD29+5H0FyhHImWlM6V6s/9U99vEp+T5EE2WnISXrgSvgoGwyPkRg?=
 =?us-ascii?Q?QlY+Y3ynQUDZS4jziPWCmcyJ98Amf+P7+Eu+tKrlnChMu+bLADdP6UEg9ucr?=
 =?us-ascii?Q?DJiC0KOCHgLBKRBD2n56K30eZVxgBceURrJAeICCo2jdCYpo8r2zHJPZLZOB?=
 =?us-ascii?Q?QBFJWT0OsJfM6BsbR87yEOWwsl9Gysp+mWAYdFHYsP8fbrRujGfeyP5I/aw0?=
 =?us-ascii?Q?poY2UGaXF/kc+er9oHDlEDh2JVygDQs7FDFymS4Dd/HqAQRZTwYCFip/ZL3E?=
 =?us-ascii?Q?9VfBP9nZoYWPSsq4G0xVJoHTiuX3fv5OcU6ESO1EUEC8NauO5cAxH1wJSEPv?=
 =?us-ascii?Q?kCoBeBwp8LBQTjSWaYOJJ9scDnJ8jJLWZhJLdK2nDP4pWLxNLdul77huF/LB?=
 =?us-ascii?Q?uE7VHGR9C2I=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XeSmDUofZc3KavSpatYyb55pjNX0AQGU6Phs9HWhWvqxdqCgwUUsmPEaNyDz?=
 =?us-ascii?Q?Aol8LM7GA2HF5Vi0Xgb/q+tz0o+UAQLYPqTwSyHVnIEGwLivLFd+BI++TTr+?=
 =?us-ascii?Q?7M9AHkDIRxFYBMN0pNGxw+zdLrex6M1g+UCzXwZ+lRkMSvG5rEzS+tQ4NYBp?=
 =?us-ascii?Q?FyiNQRoNUpcVCWTh2hfRNiYjbhFhOZMWzpdpajNQQJvVhJasYvvEajhzi9S9?=
 =?us-ascii?Q?dIjf9fZ8EV5ZolRFP8t9hzIE2KhbY8ItIsPDb6B+Sq2XbLvDHPf/aoh0oPiU?=
 =?us-ascii?Q?h61+OuhBrFm0bMLD2v5R6Kz+lKp0hq8SfyyzjaYIBGOcaZXGwKOd9x78T/b2?=
 =?us-ascii?Q?T3NzO4RAFwfC9c7isD65HnDrisx5IfvmmyuSt6xz+QzT9zssLsA93ycIkiKr?=
 =?us-ascii?Q?Nxp1lzXDbbvvhY46As8D5P+lD1lcZZ3sAyc0XQQApzlTAKy+6Z8qqPoa34me?=
 =?us-ascii?Q?+sLndVb0UnoJ2LqNR7aTxcwLla84vBznSVh3Tr318sGDsRhJ2kQF42WWlMaF?=
 =?us-ascii?Q?irlvLIB9NZYm4zeHJQzcOuWNRh4l4xYo6A7HxQD+Hpfy5G+120Ijpq+XNUKf?=
 =?us-ascii?Q?8OHAiHjl3SY/4HixWkt2aGc53tVoyhx0hdqlL6jBs/7zbJWh+W9iso0TgeW/?=
 =?us-ascii?Q?8ywpBsCvCNAnC7rN+sQx8eTzjZVgYuGPGWmn4SLHM9F2+gBEw8lT6uA/5cGn?=
 =?us-ascii?Q?Td7Itu0BK5ny5cQ4Aw/mjHGdQO0CVqZykjSKdPDoueE8VEiyIM+ZVoZK/nFL?=
 =?us-ascii?Q?U51O8rxLCgRPfP5Y1QT7Oy5toAO36/a+/NSIXcy9MBAYLNI+ECAsyVQSnERt?=
 =?us-ascii?Q?vzgr3ckjXMlhmuaT5y7PV/ktv5X7HM/QCoAa7lFGX6+ldqjOVZr4UOHkuiMh?=
 =?us-ascii?Q?+chHQC2STZoaUI76caYW4C27dgIfRMT9NeG+jS52XB3dTIrouMOKn/N96CCG?=
 =?us-ascii?Q?23HjNU59WEsjF7xuwrA3P91iEgPVnUck+hoTrpAx6BFRbx6O1ZIupPbM44w+?=
 =?us-ascii?Q?yQU8rHbj5mTUJkNsTP2IgKIn2lbyV8hMoq3IopgGZdheN7tdVNTXnYJxEpGI?=
 =?us-ascii?Q?nUtqZrcCGUVPlH14MSP+yqYKwj2mmfds0JwJxA0sG9PtYryNi3QVgx9b/dkP?=
 =?us-ascii?Q?jFjR0OjWs1qmO6MC4bpsqy5/lkGqTXjUlOgAVZYE7aZpt2O3ZrbVzEFjOrfP?=
 =?us-ascii?Q?2iWgAfuCylmymcGBolORKcYJ8H0dlZ3m+zK9s4CncNrKZPpkFmx28JYYq1oV?=
 =?us-ascii?Q?i0iZAIDtuFxhYoRvnjfGlOewWQ52nOGnCJMkeIFfn06OUxBv9qdJagEl4Jiy?=
 =?us-ascii?Q?pV5XKLA7FN1XAhxXB0YCZM5Leagz3ztcWDp8Tcs5DvySkRw+zyjnQzU6Eukc?=
 =?us-ascii?Q?zawjmYqJDmAlAGh6SqhB1+7p408qug6VnaExjYcOpXsBguyRvvL+iSWqPh4c?=
 =?us-ascii?Q?B3nsp1vvsR2AOFt+ZdT2LHAiSduVWWtEGAP2aUrCUdWRoAbtGIRs+V+oBfo9?=
 =?us-ascii?Q?Yxkqxi1Im8T0N6Ti15fSl9Ouu1GpiW/w5x8Iuu49z4vkxV6wPgg7kiRnm1Al?=
 =?us-ascii?Q?ZHZ7agBegvvPwdWFEAq2NfbR05KEkcNyDOmhNXRY?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 13e941c9-a904-4ddc-7d2f-08dd71f2f285
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2025 14:30:42.4241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J3YNYbkvuhCrGBJDa9X5ZNVbX89Af5CwGiTIRJvEY2YMOUn2A/kutZnGCMbI99h/KweUiwplVfSiFZ8nkN7eZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6477
X-OriginatorOrg: intel.com

On Tue, Apr 01, 2025 at 10:17:08AM -0700, Chang S. Bae wrote:
>On 3/18/2025 8:31 AM, Chao Gao wrote:
>> +	WARN_ON_FPU(!fpstate->is_guest && (mask & XFEATURE_MASK_SUPERVISOR_GUEST));
>
>Did you check xfeatures_mask_supervisor()? I think you might want to
>introduce a similar wrapper to reference the enabled features (max_features)
>here.

Are you suggesting something like this:

static inline u64 xfeatures_mask_guest_supervisor(void)
{
	return fpu_kernel_cfg.max_features & XFEATURE_MASK_SUPERVISOR_GUEST;
}

and do
	WARN_ON_FPU(!fpstate->is_guest && (mask & xfeatures_mask_guest_supervisor()));

?

If so, I don't think it's necessary. The check in the current patch is actually
stricter and could catch more errors than the suggested one.

>
>Also, have you audited other code paths to ensure that no additional guard
>like this is needed? Can you summarize your audit process?

I didn't audit all code paths. I took over this patch and made only very slight
modifications to it. Anyway, thanks for asking this.

The goal is to ensure that guest-only _supervisor_ features are not enabled in
non-guest FPUs.

There are two potential solutions:

a) Check the enabled features during save/restore operations, i.e., when
   executing XSAVES/XRSTORS instructions. This patch adopts this solution, but
   it is partial.

XSAVES/XRSTORS instructions are executed in following places:

  1) os_xrstor_booting()
  2) xsaves()
  3) xrstors()
  4) os_xrstor_safe()
  5) os_xsave()
  6) os_xrstor()
  7) os_xrstor_supervisor()

#2 and #3 are not applicable because they handle independent features only,
which are not associated with guest or non-guest FPUs.

Checks can be applied to #1 and #4-#7, although #1 needs to be refactored first
to accept an fpstate argument.

b) Check the enabled features during initialization and reallocation, i.e.,
whenever fpstate->xfeatures is assigned some value in following functions:

  __fpstate_reset()
  __fpstate_guest_reset()
  fpu__init_system_xstate()
  fpstate_realloc()

We can add a check within these functions or integrate the check into
xstate_init_xcomp_bv(), as it is always called after fpstate->xfeatures is
updated.

IMO, option b) is slightly better because it can catch errors earlier than
option a), allowing the call trace to accurately reflect how the issue arose.

Chang, which option do you prefer, or do you have any other suggestions?

>
>Thanks,
>Chang

