Return-Path: <kvm+bounces-40146-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB74EA4F978
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 10:04:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 06C513AD88D
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 09:04:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3FC3201001;
	Wed,  5 Mar 2025 09:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F5KhqJQ/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70F91FC7D1;
	Wed,  5 Mar 2025 09:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741165473; cv=fail; b=Q2tdtMkbA/njOo7as2OSnzbwLzz5EARPmx4NEjA5wibLJ2voJFtdaXs8Cm7Ty+gr0aJgUSV5G38Hilbz28J3MXengDb88bCcdkNFt5KwdBw7CDaPO5A31Y5VX8GgNhq0Tq9XxTib+5NscuUZwPNIwY71sojKnCYXLayJ2QxWFmI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741165473; c=relaxed/simple;
	bh=I0oXqjz+EA3bNHUVS4wzZB2LElAiuTEv2wnzP7Sbs4I=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ri4R9G2FzTURlUBD/mlPu3ODbymHz5uam3jX7V3w/M8pn1EJhAjGOHdbDYLN4+Ss5oN4SLmnfF4kB1gBRKSpn+NWYIgn1ZMYNuQ+LnCW5h3j7msMZ1zAznsdiRPb6UWluCJ7wb+azHXdibjZ+DyjMObxxy111A7aLVzqMWCuDyI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F5KhqJQ/; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741165472; x=1772701472;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=I0oXqjz+EA3bNHUVS4wzZB2LElAiuTEv2wnzP7Sbs4I=;
  b=F5KhqJQ/p5fk5emid+da5eV3j2vaQIeQC77ERNfFDdH2qcJ4Tm7QGCLx
   ILYFvYSk9JWVLC9PTIPNHddC7yYcd+QtQQwTOI30VXsvQeHMr0zjocIJi
   Tqhkun/HBRawvvW3RpKIfp0ZtS3WQbWCEwZjxZM79oxghlyyS2X0HGJ6l
   0CQZFodVLlGDZtGfa1rRaoOWa7lRwC6qtIGB+HvN6AUUstJuFGYz6SyUB
   ACFBapu5xJSgdHIf7y/nQakIFpNM+idh6+6/pie0mw0LrKlfsHeXyyRnj
   1jtzzuXnuqqcDnDEGRw5jguDdKUo0mhEzYqKidU4aUeu/KWM0HhgTIgd7
   g==;
X-CSE-ConnectionGUID: ucEPtR4fRQSE+aGcFwJsrA==
X-CSE-MsgGUID: SwFpxy8dSdSoAnRSbX2DAg==
X-IronPort-AV: E=McAfee;i="6700,10204,11363"; a="59530822"
X-IronPort-AV: E=Sophos;i="6.14,222,1736841600"; 
   d="scan'208";a="59530822"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2025 01:04:31 -0800
X-CSE-ConnectionGUID: 9oFYMLL6RtGekuUTjNojIQ==
X-CSE-MsgGUID: ++kCXeKtQXyS2oUlbxC3Dg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,222,1736841600"; 
   d="scan'208";a="119304942"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Mar 2025 01:04:30 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 5 Mar 2025 01:04:30 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 5 Mar 2025 01:04:30 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 5 Mar 2025 01:04:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z3T+qAXd71B6rpcPpXkxLqtDqKgTXtLQLdR2va53U4TCwnv2xcEVdy1ks/EMl+Y6cHy1Mahl0RT4TybYSxIc1v/5xZ0DML5J/H6vrHIZS+KMXpfkg6zVAzxr4HvjYxy318EppciKjUh8oRGStN08Tbe1pngSE+CIbsm00FYVuTgqRjd3fUezFBW2nOtQrwE+gzx8NMRdYsVEdrrhAz0fYAgZGQ89GJhj7nFYw9EwByuNL0GZHybFWnbl5MCtLfk8wn7eDXKWppUgFK05YWfiir2JEyTMEmy6RbX06i3OvC+DVPukxW38e6VEEGh2ZzV6YFlB8zIq7HSkByVR47xRzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l8JQ5e6AjFu4Io6/93r1za6j87CRCTdCWELUfCwvKww=;
 b=x7ICnKtYYlPuj8uuo3o64hKLAylgdAoOci1vmfRK+xqc2AnmGVcRGxWo8waIY8w2wsFhHyGbTUYKB9EZMEpNiSgWMMhZsN40T7EaDbQxUDyERLZsyFGM2SvYreFfN70KR2uMqKGRUo0jU7R1zyOT2Ed4Yv05nv1URquCOcEpCie4P4EMacS43/JFvHIMvBUsL2CXwkkoPPdjoq/lxBizZfTjqScS65kKAdt3HtAdwGjJdT5d82KjuXG5je2B51jE88xxcZgJghkzWqv8buh57Bm8lzPEzCCOSNr34DI1XLv1+7GC+d/MGK+dDOD04mxz438HjIzl4d4oKIFV2CALRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA2PR11MB4828.namprd11.prod.outlook.com (2603:10b6:806:110::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.18; Wed, 5 Mar
 2025 09:04:26 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8511.017; Wed, 5 Mar 2025
 09:04:26 +0000
Date: Wed, 5 Mar 2025 17:04:15 +0800
From: Chao Gao <chao.gao@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: <tglx@linutronix.de>, <x86@kernel.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<peterz@infradead.org>, <rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>
Subject: Re: [PATCH v2 5/6] x86/fpu/xstate: Create guest fpstate with guest
 specific config
Message-ID: <Z8gTj/9y2ovvN8Z1@intel.com>
References: <20241126101710.62492-1-chao.gao@intel.com>
 <20241126101710.62492-6-chao.gao@intel.com>
 <d6127d2e-ea95-4e52-b3db-b39203bad935@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d6127d2e-ea95-4e52-b3db-b39203bad935@intel.com>
X-ClientProxiedBy: SI2PR02CA0033.apcprd02.prod.outlook.com
 (2603:1096:4:195::20) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA2PR11MB4828:EE_
X-MS-Office365-Filtering-Correlation-Id: 19b45291-ec78-4d86-2854-08dd5bc4baa3
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?f5O2qqLX+ZErRmzuNn07fpfeFlx0ngCXXt+m9aJS4rWxmd7BZmMVbrX2njsk?=
 =?us-ascii?Q?35Rd1HXOYliy2BUDe2z96Yz62U7bcofNgKisAmpO/AiWUB54rIb1gFRMJBfX?=
 =?us-ascii?Q?4tdRrAPkCrTzmWL6BhQjwgYsBECdjIrs2cv1vYbJMa6BynQAvDMwMz7iTHVM?=
 =?us-ascii?Q?/dZXi+lugB8hALZ8Hi8YkfS2sBAavBSSm5LZWnlpsK9TPQ3T0mHPI9ar9LH2?=
 =?us-ascii?Q?L2/6XyXjS5VHoflOJwNe5sHar1Tzq8o/zaps2wJnLiyklGLyTzgJ0S8Q/kZ5?=
 =?us-ascii?Q?0IytpR5O5gyt8Mu5GaRku12BKujTv57Z2lJWtn/aeo3itZ6fPPyWOax02LuX?=
 =?us-ascii?Q?g0SczE9DLwSsZpHD6Xhtzzi/pj6KCbRYXqvclFWPihBlsSSBuQ+DpX9V6HR5?=
 =?us-ascii?Q?JgST8Byl6QdDloEDqxNPV/740CjOqMUUKR3NEmQ/Rq/GcknOJwkB09vO4adN?=
 =?us-ascii?Q?bSECyRjKOAFvG/c+XxsgmPeuPu5iOJZ9jzMZoL8o/g06RHn4qg0xgqG4G5Ol?=
 =?us-ascii?Q?OTX45/cSz++jzVdp0hsK0DOQLds/lta3kRbCcDgXgtcC/LYdqyYB53Fylpn6?=
 =?us-ascii?Q?iW+2EnkzO1gaxpR8h1ENiESVRrFf53TTPReR6I3V18PS3cHpZcr3IDrGHFAz?=
 =?us-ascii?Q?XDXoIhYO65uRZN9v/mdR7jqF9Im7FijujZQLYiLCz0mqQW6E3qvJuDz+mTXp?=
 =?us-ascii?Q?GIwxEMlCL+EFPPx9XJIBYrFzUnxa3IQI0utnYgnIcylkSUeFxjKrlnCrjOrm?=
 =?us-ascii?Q?N9/maCtqRsKm3nXEr45q/2WMv6WAoWinfix0EoqqJ6FxmOotr3UxFRfUcluM?=
 =?us-ascii?Q?/5sKFXFTtmd1NJqrsUZhi4XGAda2PUlhfUEJrteYmnRZ8uU0GSwQ0NJshMOp?=
 =?us-ascii?Q?XOPabmHAhS1gzGybYiRxVd2SQa8m/inQHGiuNP6IzfPcO8uxuTfhk70Xh6Sy?=
 =?us-ascii?Q?KcVeJ39YZOzGofnHZK3FE9fzglUGqquD1ncvVYaIw9nQLHmXkRVylbB/mM7V?=
 =?us-ascii?Q?L6ljvsE67+XyWykihYEx5fu91QMe+tP3TMZgw7+KFVz6aNzEBPYHCTPvJbnC?=
 =?us-ascii?Q?E0hhCpWBeArRGX8Q/i86TQFQoLZywi649Jt7ScuN72s7/VP3Enexcb+eI65H?=
 =?us-ascii?Q?Jld98yy5NVoFKWAqnEvR+1li/Tl7HcLK6bGHJHQ8xCUfdtPYeuE/JGhRGAHw?=
 =?us-ascii?Q?2op1cDgLJwCwy1YordktwHHhFlAhw+wJEEDtEfDBHgVS0qxARBbE4ktwIoWj?=
 =?us-ascii?Q?FfmlXX06CnQSMHB85syk9HyiYC8iTi/Y0EJKd4XB5J+Dpq7NXUpyFLGUCJo7?=
 =?us-ascii?Q?Y6C8QkCDSLozyCUUeb5WqbnagCCnWdGh0CXnpXS7/baXushnUgshbGQO8MMP?=
 =?us-ascii?Q?yD3uRuTqbhMo+gcuc1PehBFtRhac?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HP/Wlq5TxGAONaPkAbaWkq7CA36ekOoKwgE0cbvmH1LH5aV6C07B6vV+XXK9?=
 =?us-ascii?Q?mPtuXmix2kN6THAUDtG1610YeY8Eijr89AQemJHQiSfxWy3E5FDEIMxWLjXV?=
 =?us-ascii?Q?WKjQx8OiKwMILN9mHJjbAKzzAoZw8jSdUAZSMenTaptqDYHID2eomAmP/W7g?=
 =?us-ascii?Q?GSJ9qiqzwJevLordUv+Axerpd8qlp5iHNx9czIU9QzzoDJf/uBc+GyrK9Yiq?=
 =?us-ascii?Q?iIwRxElzqIMcYDKGN3Lb2Sncvt7mPaRoOvdjpCFe2qakrWrBYNomF8GjYwRo?=
 =?us-ascii?Q?CGdwA0HodHZtoAi6qGAzlxWNBCQKGq5+71Ch/EaeB9imv7B7ovj2ZiEVVNic?=
 =?us-ascii?Q?BlY66bQq+lmD7BFwHGgUPdEXSZdEg1tR2KKL3i0yglF0TaAmgIVGa6QZXtUd?=
 =?us-ascii?Q?ralSbzqGcdr4l1TUhwKLSWRK+8gf44Tgj5nPmxHxk7Jfh1KypqrM6kdve1u6?=
 =?us-ascii?Q?B1c9OJo3Xx5G3Y5la41YpBCv+cV1pavX6g8yTHTCvXKEJp7bPcEL0bo5HQT/?=
 =?us-ascii?Q?F0ozuF+fzqoxgzyh5dtpwraxqDPX74lOgNtw0XEwVsR3qFesD1Jj/8yfUcr4?=
 =?us-ascii?Q?Q+QGB/aAXMIBMKOm2oSoC+xQlUN8hAjaUDYMvc6jQUXLwHDrf4DhL6IAVqH0?=
 =?us-ascii?Q?Ryt4TAHr6bQSI9V/B/ahzv3J7xwPhemwgDgHe2PG4Xqw6PDrx55DaBSWzzY0?=
 =?us-ascii?Q?FgRiIv1Gg2ftkZokvfHQhkpvjIoax2+eUKzZ7VcQ8LdTY18i+Rt7gem/+4i4?=
 =?us-ascii?Q?xNgXujAAN/oM3x8ehdje9isaOBdNqlciLOjCm4JiX8l0O8Zftd4D8DFISP8Y?=
 =?us-ascii?Q?fl3knRyMYUqbOy+vSOrEOXiU+aOBZWaBfEmE/CFo5/Yv/LOEy5rS6/isR/YS?=
 =?us-ascii?Q?OKU2ZJaQbwtJhEbXHHtsZuGJSGpzFzON4Hp4M5VGlvFmNbd2twWvafiDdS1F?=
 =?us-ascii?Q?DBZRjU4enjgiJIbh/rsBsygyxjBwM6BjRHhNhrqQdXkM5tdJmno7OKz3VNkK?=
 =?us-ascii?Q?lImm6py9o4o+ApMhGojeJa7+8E43/TeQTtBzqI2eh75hzEIux4JeGYJ8Sf/0?=
 =?us-ascii?Q?LUY3W7fVGBhmht9ZWJXypIXjqKeAqHZ6fY/RqjG/tVoPvJs5kkv2P32aaMt8?=
 =?us-ascii?Q?CqSieCa/w9ys2y5xbgpEco9Hj5kH1qFahQHNDycItNWrC2ZlCFX+JWNVYA5O?=
 =?us-ascii?Q?04bvYrByYfKn0evvPS8WxnO0vIEj4OhillltXyCCUQgMpJKABwspUVXWtTsI?=
 =?us-ascii?Q?OZ7RomekFp6vRhGjElsgLwF17YYTuZJOYnZIlRO6Ho2QXCI/Y50NutOS0M1i?=
 =?us-ascii?Q?3Ubb62rli6deKaC3N1GHkmHWbpvCgoTHk7/ARrpvWLMM7XGWLlUmIvOZQPef?=
 =?us-ascii?Q?I5wD6VZAQRLYczWyQ1JpJQDdOVdWgAR7/PvM/6llybKS153r6903rc2TPQ5v?=
 =?us-ascii?Q?kU6pKDstO/+fh1KB3W1UNWtMlRFSUpGoKf0ETAEzF9dsaMn8KkBUeY6hzYe0?=
 =?us-ascii?Q?/bo7syQ7ybezi714yEsI2bulpdf6hsiwOuleCRKDXgd/Cu7y2gE4DUuw0WDg?=
 =?us-ascii?Q?fMD29ie3dX/bGVb7J3Nyp0DY2hZtBxjFlffwcS4c?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 19b45291-ec78-4d86-2854-08dd5bc4baa3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2025 09:04:26.0682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UIPh8884Z0Z813Ork1gfIcOn/oAFuWkeavbC83v6z1GTcjIqqgyYSL88TGEM3cexULkUh5X1y9pg+0zo4Czjrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4828
X-OriginatorOrg: intel.com

On Tue, Mar 04, 2025 at 03:02:04PM -0800, Dave Hansen wrote:
>On 11/26/24 02:17, Chao Gao wrote:
>> From: Yang Weijiang <weijiang.yang@intel.com>
>> 
>> Use fpu_guest_cfg to calculate guest fpstate settings, open code for
>> __fpstate_reset() to avoid using kernel FPU config.
>> 
>> Below configuration steps are currently enforced to get guest fpstate:
>> 1) Kernel sets up guest FPU settings in fpu__init_system_xstate().
>> 2) User space sets vCPU thread group xstate permits via arch_prctl().
>> 3) User space creates guest fpstate via __fpu_alloc_init_guest_fpstate()
>>    for vcpu thread.
>> 4) User space enables guest dynamic xfeatures and re-allocate guest
>>    fpstate.
>> 
>> By adding kernel dynamic xfeatures in above #1 and #2, guest xstate area
>> size is expanded to hold (fpu_kernel_cfg.default_features | kernel dynamic
>> xfeatures | user dynamic xfeatures), then host xsaves/xrstors can operate
>> for all guest xfeatures.
>
>These changelogs have a lot of content, but they're honestly not helping
>my along here very much.

Will revise the changelog.

[...]

>> +bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
>> +{
>> +	if (!__fpu_alloc_init_guest_fpstate(gfpu))
>> +		return false;
>>  
>>  	/*
>>  	 * KVM sets the FP+SSE bits in the XSAVE header when copying FPU state
>
>This series is starting to look backward to me.
>
>The normal way you do these things is that you introduce new
>abstractions and refactor the code. Then you go adding features.
>
>For instance, this series should spend a few patches introducing
>'fpu_guest_cfg' and using it before ever introducing the concept of a
>dynamic xfeature.

This suggestion makes sense to me. Will do.

