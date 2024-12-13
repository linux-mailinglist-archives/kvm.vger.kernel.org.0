Return-Path: <kvm+bounces-33680-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EF5D9F023D
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 02:30:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EDEDF28286D
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 01:30:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A903B2AE8B;
	Fri, 13 Dec 2024 01:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q9TU2t1B"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC401373;
	Fri, 13 Dec 2024 01:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734053445; cv=fail; b=smeSh7EHnzR05lPwC/PqxTZu78/PaSXOp7frbtEH9+hfVQBp/aBA9sX/vHphDglHKAhk8XHdvU1B1jkZjHXPq1oL3c1aB8aWc/VaPtCAMWkok5/ZNQ5EH6Tcv96wxGKV1HCOZv6VNfCscn31T7qNBFfJ1AWoL3J+k7Cj0KIyHcc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734053445; c=relaxed/simple;
	bh=j0HgcO2RHOWuJ9GJqFdfSlYKITgDdDFADK68QqZ6p/A=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GEcb8YREQ2Ypdwvn8erx+hcpIuaUWsujmQgMXEsR/cef7WfCpogs8murz21CvsuuSDEwd7nqvERFZun6ksxb5k2rsODECoXJ/R/6pSdoYO2fsDVfeRtcUfEUjj3lgvOH3L5PEnt+7swgNwLdXt7bjPkBv/WS/hSFtxUfh1cpUac=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q9TU2t1B; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734053444; x=1765589444;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=j0HgcO2RHOWuJ9GJqFdfSlYKITgDdDFADK68QqZ6p/A=;
  b=Q9TU2t1Bhdux2J3qk0K3PTlsEy88zTsaOIlAeQw3ThQPS5nh8LvNakEB
   roWzQFaKnP79yYDUX8UTkSXw9hMm8IbDMLhIii3kH7Fm/NsN3JKGiEEzS
   6TOP4CsFpyEduB/5Kl6FDppzUnvNO7amN4hHvdPRM+Ixm4RDq4rr1Siyw
   PbgnlBya6+UYw55qe13BAJJPeHbAOd0bALXCd0up2B1v2PHMUcp5visGZ
   gL4UvBErsQdOhbRSiTBOV8nGhSaXKggUyXVawm/tF7Y3KxXkvaoBTPQTt
   W1WG2ftgILOu9B+sgc7vrT8GTodDXxZStHDQbz0yJ0ihxMZPPvNgdgB0R
   A==;
X-CSE-ConnectionGUID: zNrM1RiYQc2oVf56eRXAgw==
X-CSE-MsgGUID: IOnw55QlRHiQfdcsAkzf3Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11284"; a="38277275"
X-IronPort-AV: E=Sophos;i="6.12,230,1728975600"; 
   d="scan'208";a="38277275"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2024 17:30:43 -0800
X-CSE-ConnectionGUID: +6/wfkqkQ2ibrzn0Xq34qg==
X-CSE-MsgGUID: VqvPK2V9QsWjCsvaOQGv/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,230,1728975600"; 
   d="scan'208";a="101425843"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Dec 2024 17:30:43 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 12 Dec 2024 17:30:42 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Thu, 12 Dec 2024 17:30:42 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.48) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 12 Dec 2024 17:30:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rQemuHqBnCWqMY6P4PnAdkG6ySgAE2KAQ6ROO4HNNxT1URGXE3P2GdTGXSJ4AhPN9s4cKuRcfxeTRv6O2oKTKZMjtHR+chszkCE1hdTmSAk0ZzzuR9yd4xIt+Q4P6PmMOk8KrQ4XNwQ59SeYgTukDxQEokqDcHUxcj+09mggndcPa/CMDLVvJe6hAXVfrsEifQ77KbuMZESykRM5Wtqdrago9ZtIN4X6cU2Z9aMWicZAt5iT1R9xW1PyD9Q4b05Kk88YEhz8JPpFlVk22SxK4irAaLvYgO3+SbT+fo45kTiQbFJvDUor736SL2elWYSZwev0N/SlnMUiA91dJfOW4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iF8NGVAF1mYfqgSbBg9v738SRNDrEohxCeGXJ0cR/TI=;
 b=vRZdKUc8X1JiMJOPJH/u1hWaxuo1RFR5XLFHBB0Q+hAH+0cE8pI/Q7vCl3JtXjUZecgvnJn4UcLXbduwji60jGAs++67XIPN0hSGMGETQntobRhRilQyyCIJaw5WQQJNJTpg6euKZDx8pw1hbc9CBl0uejn3ynHu9eFi+BDSc8fqyPT5/gCShVSO6SC/6sri2LW8sklP+H+ey2WBoouC9bUgNHnomMeW50/Ddkzow7SUvesFLTpNLtADDqfqZXUsD0uW2KE8ffylSj5bNOW+HGPt5uB5ZWU0Sx5Mp2ypeFwLeJ2UifuwEHHWsLXpRz3hN8hS9SAXw8u6VDxEkdgt2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA1PR11MB5899.namprd11.prod.outlook.com (2603:10b6:806:22a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.20; Fri, 13 Dec
 2024 01:30:36 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%2]) with mapi id 15.20.8251.015; Fri, 13 Dec 2024
 01:30:36 +0000
Date: Fri, 13 Dec 2024 09:30:25 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov
	<vkuznets@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>,
	<kvm@vger.kernel.org>, <linux-sgx@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>, "Hou
 Wenlong" <houwenlong.hwl@antgroup.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>,
	"Binbin Wu" <binbin.wu@linux.intel.com>, Yang Weijiang
	<weijiang.yang@intel.com>, Robert Hoo <robert.hoo.linux@gmail.com>
Subject: Re: [PATCH v3 05/57] KVM: x86: Account for KVM-reserved CR4 bits
 when passing through CR4 on VMX
Message-ID: <Z1uOMdYiWz68LAPo@intel.com>
References: <20241128013424.4096668-1-seanjc@google.com>
 <20241128013424.4096668-6-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241128013424.4096668-6-seanjc@google.com>
X-ClientProxiedBy: SG2PR06CA0214.apcprd06.prod.outlook.com
 (2603:1096:4:68::22) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA1PR11MB5899:EE_
X-MS-Office365-Filtering-Correlation-Id: 71a264fb-e954-4edc-51a4-08dd1b15bead
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?fQZCSzQt39gV/nHNSTD6B7YWplTo+QmDAQIWg6AI/ncCFEeOUq2AAcjVWvQg?=
 =?us-ascii?Q?uhEfXrfsG6SPPfe4WNA3RGuQkRVJHwSTdebOdn5Vq45H0/WLPc+zjS6sin94?=
 =?us-ascii?Q?E/ic6oqJOw8hYgNbJ1E5YghLgFduP+kujwOCJNx18nwNi/uMMVS+BMqAU8As?=
 =?us-ascii?Q?h8RmwerlstfEK1zhLcAiKWSClqPqDsjdjMvlusT/SMDoPTZ9lzHKue0ehCpZ?=
 =?us-ascii?Q?5HLwEdaRRYd1ouygpyqtjTR1nSh0zpZYdjEhvkutmrbXkOl0bJwAcU9ksFsl?=
 =?us-ascii?Q?9ILFHsVWiSWEwhqQcAtCvbEiHxUenmfK5s4yCbxmsc6S9N+qPci7QAE7GSXc?=
 =?us-ascii?Q?vPU245dsmWfozwA7I5PZQRKDl7UbQbS9IuGPlv5M5VIqxVzpfEhHNGQ0PJNE?=
 =?us-ascii?Q?ulg3roAtnG4YnTD45OfgNVHVU2uv7TJsmA1XLgkSPya+l61boxvAlJ2JOOyz?=
 =?us-ascii?Q?BHRJCuxFvC3TrI6qhnlNKUvkdRaxp3OKol5MB8ud5E8CrwcJlgH+EN058oXK?=
 =?us-ascii?Q?Fo3kUXBWyzpa83/843p6qF+WhKYhgrW3kQsCWhIioThP0LKZ/RORjmBfHG+2?=
 =?us-ascii?Q?7KQXyu5SFqchIXGbg8gBr/G6KL61KeYRpg8l5IPJqUuHP82V/OXONTpiA8no?=
 =?us-ascii?Q?kDW1uL4hp1/2d4OFnbtaubdfRJ/2JGWHeIjmmbW9Jn5OWRYDD6YTSzXVx464?=
 =?us-ascii?Q?5DDgD20JzDUJnZSj8IsJi/75cOe1LBRW7mtKvRVrYsRfAEWSfBpYjJpMmDX0?=
 =?us-ascii?Q?DBQQwM4EQCecKf16cf7zzfLskiMsGeZPtspbo/jLp+uZCKy5+HU3TzMNzlFg?=
 =?us-ascii?Q?lyG3Nada2vL2wIhqYpsllBHlsj5hkfhfOnxmeTr64RJ+FSn4BIi6BiFAEAUR?=
 =?us-ascii?Q?JrcsU1pkhIk7wt2fXqyBEG0xK73m95MBfrJY+2TGJDBXvpbEQgSnehSqBIvy?=
 =?us-ascii?Q?wi07UbMrWauhc/xjxQCjbWX/0eW4yx4k1aZqLRhSB7zH64X4mKQg8Y31yErZ?=
 =?us-ascii?Q?Qae7F93+JoNVU0Cacqk3G0DZGt/x9GFjnqUukO2RBwSqG7k03inexIzpcNnC?=
 =?us-ascii?Q?SpJ14sel5LfQ/0iZaATac4/rFkpqBOxSSBshmnYb/Q4cbWIgjJZ3Z49aRmaM?=
 =?us-ascii?Q?9547mYCyeibAFOufzyjTIcNqxge28N/pKS5q24zO/mZyUpyAhQFjGdTrmV2e?=
 =?us-ascii?Q?6ZV5MmZmCXm6Wz4vgN3hnT57LOu0MpL/3mvCbCwMwC+04nU5qDDazlMNr8jh?=
 =?us-ascii?Q?SlyWzUnHyQE0JtCM0uQ88j1zaPn0+OOS1b313H3LLix/1ZPxd2pTKZ4HrkqA?=
 =?us-ascii?Q?Ocs/hcwryKtHTMH/TEZyvYSTkTFlr4CBi3Q35tTHXbmW2A=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GYKioX5043gZRrUM6LXwfb6Gc3rrX3cxLwBmZx/UuAaSwxYbOs3CehfezEKk?=
 =?us-ascii?Q?WJ9rw7Na0NPZhl4TyfqHJNZWTjbGiMIOBc0n6XDhGcl7cPboHi2MBQHUJCQt?=
 =?us-ascii?Q?36Qr9eoG4H/W0EfJYEzAnbtHozjwmKswDEjFedQgm6NyulloA3HrlROqwQHU?=
 =?us-ascii?Q?8h4ujDyW7Yy2fB5z7gkXrPv7BhGv3mcZHoXynPSpaCK/lLQf8N280ybbokQO?=
 =?us-ascii?Q?+O6XQdreElseFHFHZ7wSdIXn8dwuNcoiNt44mhhMp1DLat8EGUbo6c/vSaIn?=
 =?us-ascii?Q?Gripyyd18luBW3q92SyUvJi6XCMjPvAYbjhegKgdbtLeK3pwyPIJ5jpKUnTn?=
 =?us-ascii?Q?0e9b6M53j90mqPf/wyWORaOojHsl+lyih47I/Zq3gM+VOGs0LX6iYLsC49g7?=
 =?us-ascii?Q?3/PJQoL+zVPr0a7x0qkxBdIexB0bDolrKIsniITZJc0i4ZTUL48gGBnEYUct?=
 =?us-ascii?Q?Elu+XluaDaBOqk9EiWEWjpjSEpMsdLLxrnZ13vPPpqJc3jaIXL708sxzhM+O?=
 =?us-ascii?Q?tB1DzACSdQKYjW69gwhnZYe6gZPU3yaGPcYwLzBI6hKDI5MRn31U0b9y3ctO?=
 =?us-ascii?Q?81d9qezqtRU6uNPNad1NVNZeKKe95n7ntTY5rc88IQBHfikff6espZOEpqQt?=
 =?us-ascii?Q?NuEOcoc59Y3ZkZiYBiwwi1RuIGBpGA54fv4PaKhs4BAn+stLaT1GllMaSjH/?=
 =?us-ascii?Q?DnZjfIl1m6Ae3JgWDmPPso3L4xWjmgv77ZMklTrz1s6FSIXHDnD0m4blZ5yo?=
 =?us-ascii?Q?92YdMcXktrRGA1EJTkuKvprDpZe9RjSI/7ZxThTrRwM4E2Q/zLCsShqzDmAR?=
 =?us-ascii?Q?fkkSspeZ+cpb0wJ1q8AiS8hHfnSR6SJIihgA0aPs9nMel0oeHlM3dmCEB25H?=
 =?us-ascii?Q?z2bbEuS4ucj/XwkBKvwtfwumDwcOOilEnFMUZm/NJ0gs9etTJKTPJTAXMlcu?=
 =?us-ascii?Q?HcM5QIK+H6fIl47QhqznDl+esnia4xq4ZxKp//htLh7DnLJocGHtEWNPXWi8?=
 =?us-ascii?Q?IDrqYj485NWJ0ZrO2i1ygHvaYcTrpVjc+/pBI497haOK0eCCpdpCSNSCapmr?=
 =?us-ascii?Q?Fhf3hAOOZ2S3NQa++MrKyRycxijq6dUGyqPeU8kXpWP+brjsFp73OXCBdDmb?=
 =?us-ascii?Q?1N3NddF7TK3w6r1qa6dsxXWNBoMgmLlE+wqD4EzrDNZ+8cVDn7QfqNuG0ibK?=
 =?us-ascii?Q?gvPQrIH7zhFiSnXK24cNOZ1GG0xaU3SgQXIv7ScOCM1gAAmcGO4QqXR1E9X/?=
 =?us-ascii?Q?p111yXkYfGXu56L++PkDyKKQw1REYE5Jvk0Vz+KNlQNjwqjDcuaeF6i53SuS?=
 =?us-ascii?Q?HiDAIhO//KewsXdJgS0JfLlv1b2IUf57S+hhFSJ8Ru8K8Z4OOUieJ8/MIT7f?=
 =?us-ascii?Q?GE/rvbnzh8ymKgjE2HdEmzfamMmMRXmPwOR4pupxwyFRtJcPUy2JWEu70L0Q?=
 =?us-ascii?Q?dnVMibPGzkrLgbjx3agTJn0jLgiHNls3jbPKbR3kC2jRdMtevHMW4PIQs2Yp?=
 =?us-ascii?Q?XBJlIDJJsRJCJznA0cOnxhC5ozpOek/9cGmFIfJLUiVlmPTVBN3kRROvA31i?=
 =?us-ascii?Q?+XGvWzUZLA1nzQ9UFw5XJR+vwrWZIhznY3qON7qz?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 71a264fb-e954-4edc-51a4-08dd1b15bead
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2024 01:30:36.5438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gmnO7ilTYdVIZdj9UxgDoGlGIPMGWD4y/B1K++YUdZzO3YLh2xL8f0WEyNbYjgWbclRDP8h6aNnLgmKWDdXt6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5899
X-OriginatorOrg: intel.com

On Wed, Nov 27, 2024 at 05:33:32PM -0800, Sean Christopherson wrote:
>Drop x86.c's local pre-computed cr4_reserved bits and instead fold KVM's
>reserved bits into the guest's reserved bits.  This fixes a bug where VMX's
>set_cr4_guest_host_mask() fails to account for KVM-reserved bits when
>deciding which bits can be passed through to the guest.  In most cases,
>letting the guest directly write reserved CR4 bits is ok, i.e. attempting
>to set the bit(s) will still #GP, but not if a feature is available in
>hardware but explicitly disabled by the host, e.g. if FSGSBASE support is
>disabled via "nofsgsbase".
>
>Note, the extra overhead of computing host reserved bits every time
>userspace sets guest CPUID is negligible.  The feature bits that are
>queried are packed nicely into a handful of words, and so checking and
>setting each reserved bit costs in the neighborhood of ~5 cycles, i.e. the
>total cost will be in the noise even if the number of checked CR4 bits
>doubles over the next few years.  In other words, x86 will run out of CR4
>bits long before the overhead becomes problematic.
>
>Note #2, __cr4_reserved_bits() starts from CR4_RESERVED_BITS, which is
>why the existing __kvm_cpu_cap_has() processing doesn't explicitly OR in
>CR4_RESERVED_BITS (and why the new code doesn't do so either).
>
>Fixes: 2ed41aa631fc ("KVM: VMX: Intercept guest reserved CR4 bits to inject #GP fault")
>Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
>Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

