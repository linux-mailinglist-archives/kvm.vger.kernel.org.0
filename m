Return-Path: <kvm+bounces-46185-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC1DDAB3BE2
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 17:22:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 52AE717F901
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 15:22:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5089E23C4E7;
	Mon, 12 May 2025 15:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZjTTW62s"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B329B66E;
	Mon, 12 May 2025 15:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747063335; cv=fail; b=M9Kfz8gM9R1D6HaKcqLRoskx+wu+HHOzHQDhOE9wpH1nEmTaCv4BjCavY44PzHyc8MazUJ0WGecwAIN4i0VIeZ+DBDVgXHy6QyODD8wRhjXeIKez0TxJXQ8xf1CkubL4YVKjXH9L+VYhez+0LiSkUaFARtQ2oWpeoC51CGK+cw0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747063335; c=relaxed/simple;
	bh=CXIuSYayZD6wkSlB89r9mex1aN4Zv4xAKaMsxmU1XiU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=V0YMeGP4hwdcV02jBKRVueEhtB/ChLEX+o1QjRNAN2tsDJjRPWp/fxvJRlJKlwkOjQfvBE+Sp1BzgJSZSnnCYdgbV7pHBinmvBnc7Bm54xJkUFkv71vaHfFvEo3g5hvLJxXKIry6pAytVcjWSmtVEJzlYqcge68yDLi+ebA09Qw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZjTTW62s; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747063334; x=1778599334;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=CXIuSYayZD6wkSlB89r9mex1aN4Zv4xAKaMsxmU1XiU=;
  b=ZjTTW62sBj1W2wX753ZgVCbLXqdkF8zxdsWZmUfvjGJRWIagICXjvXqD
   GtwiEo7MKEdowCrGuKIooc0xxFuN0JZIdsNLMrRWtyXOD9WIYcKxBLPwU
   Jv/8BgdjDh+RZgj8O/J5EZih1RjS4olmdLSOW/3JGWTX3SzymqS7+lgQN
   oXhT2s5qgrlW0dicrfIl3wzMWBYeXgd9oBrgSKn8T4f5kLHQKx4CQJwkP
   58wAvccEiz9oqpFQ0OZOwkGn6zeq5ZIuQARrhwY3kO2L863nkUsT4P0rb
   FEqpFSarbfPinLFifX8VM8f8YNRm8DFgzLKGqff8ZDbdMHFutSGc1md4R
   w==;
X-CSE-ConnectionGUID: rXVBfvFxQrWWJn0XJM8Zag==
X-CSE-MsgGUID: XbiKTLjJQ9SLh4f07ZB/Hg==
X-IronPort-AV: E=McAfee;i="6700,10204,11431"; a="48860259"
X-IronPort-AV: E=Sophos;i="6.15,282,1739865600"; 
   d="scan'208";a="48860259"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2025 08:22:10 -0700
X-CSE-ConnectionGUID: fMKtjozcRLeedxrx5uN4QA==
X-CSE-MsgGUID: Q7HX7UPUQ0agNY+GH4VVRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,282,1739865600"; 
   d="scan'208";a="142175174"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2025 08:22:10 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 12 May 2025 08:22:09 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 12 May 2025 08:22:09 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 12 May 2025 08:22:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GVkUKYW6qkEiSkiXx1ukYxKqlwL6ULDUoCobudLkfyzu1uoU6o7WzBks0V+Ph94Y2N47iONngktCeXnOH7n08iMAdhZeiIBzNbJD7/yUeDCdKYT+Td38yOiZZ6jta4KlHovOhUPMDhHN0j2TW0UQ2X1sRk5GP/s2g95iNF6e3K4xbwnSp0hWEaNtNSYDRSxx8+aYkQl3w+dyEFA2JlRvScIk/r/hq+tGk+woujx+NMsaO+BqV9SJx1Vz1SgcBwlBjTJW/fBAx8q9PxKLR57jfUZC9Z7TG/kxQB+Clm9ExKOWwpqAoTyGgXMQuOVaZwyhG19yjXr5DqjEhwFF/1USNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Np3gxxvY/Lz1TsiuCQOBp/3MXxIhX3/9a8tcXqZHo4g=;
 b=R6aPJUDbshcNGylZZekJQMX/DL/n8KH1iui7m0xPRAyWsd0JNZbTfo7PwM9h7n4ZxoNMTDoXoSu0fe2kJuSFZdXIIxr9mulmmJT9c7PTQibqJ0ibhrNZufBtlOEN7YXVw3/BxPMz6ufVOA3WTTIzas+LW5PDWvsI3ReJjGU00XldjvgxMQBemn4wPns6U55IQ/uoFS5hTm9rcc5GSjfkU4KCJ5YEkAJZ6mVTn09NDJb2zGAD5TlkWNWT07KOiw4j9rn/NxoEhyCYSmZAsIQP0btvO/UJWz4XiKjcxrbH8ruHSgNiswSg11RgFpfS7E1d/0GwZbY4ye0JNIPsZwe6Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DM4PR11MB5230.namprd11.prod.outlook.com (2603:10b6:5:39a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Mon, 12 May
 2025 15:22:05 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8699.019; Mon, 12 May 2025
 15:22:05 +0000
Date: Mon, 12 May 2025 23:21:53 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<tglx@linutronix.de>, <dave.hansen@intel.com>, <pbonzini@redhat.com>,
	<peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>,
	<chang.seok.bae@intel.com>, <xin3.li@intel.com>, Ingo Molnar
	<mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter
 Anvin" <hpa@zytor.com>, Eric Biggers <ebiggers@google.com>, Kees Cook
	<kees@kernel.org>
Subject: Re: [PATCH v7 3/6] x86/fpu: Initialize guest fpstate and FPU pseudo
 container from guest defaults
Message-ID: <aCISETY5C7V6Pfyt@intel.com>
References: <20250512085735.564475-1-chao.gao@intel.com>
 <20250512085735.564475-4-chao.gao@intel.com>
 <aCIB3nZSUTBXr80O@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aCIB3nZSUTBXr80O@google.com>
X-ClientProxiedBy: SGXP274CA0001.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::13)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DM4PR11MB5230:EE_
X-MS-Office365-Filtering-Correlation-Id: d8e1e8d8-261c-4f28-a85f-08dd9168c0f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?9UKeYytom6Vx7w8RNh95i11wFgeDJ9JO0ZOUtf6lKNyA0cRCaNNVytMmlpZr?=
 =?us-ascii?Q?SRYpMuzeEsCGLTWFYGrXU+zGbH5ybqGhxDv1m2GVoUCC7cOfY3K0BPHQ3ARI?=
 =?us-ascii?Q?/hbbVhI2MZZHZwxCBxfIu2259BpFgsh2J3gTR84DppVMPV5gdKG0ckqBPiGc?=
 =?us-ascii?Q?rZ3g7DxAMzGhMWMxE67t+wbHTC6sB9RX9AOhtD5TQOmxJMTNjJLVl7ssSHw9?=
 =?us-ascii?Q?RWAoxU1VyUAMw8vKMp2hG4QM1wuGhtIB7tgzOHY4tCIhNdIFge+GZHDf9e3e?=
 =?us-ascii?Q?cZAVNKTwNVA5nVAZqQUW2wZ4fmncvAbUR7wQlM8/ccr7e9e5JKwu87AThhgd?=
 =?us-ascii?Q?RiDNvy6hy6meeqkFVU7dKISkkzlvkwCQVb3PGyOto5LjqorKyo+6fxH7JjhE?=
 =?us-ascii?Q?kA+kWDJFWwCbIxi+dHvUtsL8UIKbX49RZP0xbV3r+cQ6tWQXIsSa0M1hn4Hm?=
 =?us-ascii?Q?mcAjTfhXjBcCcuW1oOOrnyPorXT9uhfXS932WAMjruL7phNFnLgNPOqGny+/?=
 =?us-ascii?Q?a6TOoGllaBW1HOPA+LkUuA84GIozE/Qdc3UMHYNJKlaB8nRwi1xApkSlpMho?=
 =?us-ascii?Q?Efz1CtVdBKtPvEfgRZ+futy3hojharQl1MG3ISvbGyYybwFGOzPK2RTcOS0h?=
 =?us-ascii?Q?CUvQq+4qZUCwA9o2rj87epN2e0SPHx2McT1H1etTypGs5MCJu7LiZugT4Zil?=
 =?us-ascii?Q?oHP4H4LFXygrPDyCPeXuvoMbwrz6TEWH7xUfi+1w5mt28GFj6/rCNYWEYtOr?=
 =?us-ascii?Q?Hn+IWBlJGXOfjgZzygb/r1AN3D322D7xvsU1f6KkcbcW8mPK7M/DW1AVm9Tp?=
 =?us-ascii?Q?FYuxQPZV5ZuB5tXUh6D+OU42yOepaAZX4i03YWOrCstMoTjc2+9Gj2ZviQOW?=
 =?us-ascii?Q?l/rA2G95NhVmAFbfdv/1Pz9DwUsPc7zkV+6EqxyC850FbTgcSmCwE/7A6l5B?=
 =?us-ascii?Q?wvknsVV+UGTmkReuYGg1k//Be6WjHijBtG+1+J3/pNHeUY+kPqc3YB5XpOWd?=
 =?us-ascii?Q?uS6OYo1xT9f1YRr41if/CE2Urp2IEB4GBZUJ6CRkY6ZRXl4vk9tUS5oUDJhD?=
 =?us-ascii?Q?EksQfHu6osAyFmHDtXmqCxwC6fc7/UG3qiwXzE5p4Ex3QGLKbsG/Oz0XV13H?=
 =?us-ascii?Q?NfXDDLI22Rl7LMPZ0iT6pLyr0LlKqZQM6SWJhqEAtJl9f/otBEAwomBftifu?=
 =?us-ascii?Q?/72akTdYTEJRdQYxDgK4qwFSjJ+8E/EQ+w//wXq9VibPAIQrxLGD3Bpqvg9p?=
 =?us-ascii?Q?YJY3OLeO3DVIiUXcguDcrzJ5PhORVgj7HjYriSmoEX6aA3+3iffJKWP7Uc84?=
 =?us-ascii?Q?y3EKijHNFV0NNgl5sPCX4PSzq/4AOyedyfodr46HMV7BZcvLe+qaNqaaSTAs?=
 =?us-ascii?Q?E0md7weke9VZEfE5IaYur0pabB3PCslhfFWhTf/VOSydgX4Sgk4p8MfjN6TC?=
 =?us-ascii?Q?Do18RlMtjj4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P6Qx3drVT7TjbEUhyE1hy9Eq5ZFRvB9Qr2Q81MqeTZliM60Y544Fjq7Tapi2?=
 =?us-ascii?Q?oONhrqWyZkiF4PIMsIHQRCTSRzi1HPEZx/XXBzmTDib16sOrEj2DaMcUPZh6?=
 =?us-ascii?Q?RPFplyBUIjOIYp5oocNK+5u7hWF72rn+aRzRYET39JVb8xXzx5vCT9NUVXXe?=
 =?us-ascii?Q?dShQGB6GnAAsUObrLn6xA20IXJqvjSpm4NT5mjDe9J862tI8n4/jHDqVwuax?=
 =?us-ascii?Q?Pjq1sX+xy0d+7cI0Y727KLk4J7mVO9QBOh5HSmDN6Wb00Z4lNwudWDn9iMLi?=
 =?us-ascii?Q?xwiQZG4Yo7Vl8W2fOhjYHJ42XNCKoT71r3btofqzvbd8IIyPsEsUXTwvrnpZ?=
 =?us-ascii?Q?fvfZxAWIueA7FxmynGMR/biHtTcLkE4Dqlk9o2Sv51zInkwj4IxKQLbuuqiD?=
 =?us-ascii?Q?Hr5HKJ4NSDakalrcNMvNjfZppIdjLNp26hXhS6fOKuR+3uT1XCyzR6BBoUhQ?=
 =?us-ascii?Q?zYesPzJhNaTkDAqH04IIOkmx3dITzdN3DID5g+wtHYcGW96df1lubM1kCK9W?=
 =?us-ascii?Q?GoI9FEDGp3ThUtvFWUMtkTBgW2PnZg8tGzh+U4X6elNk2rjYQqzTgV2sMn+k?=
 =?us-ascii?Q?PikyjFKF+4OAbY0jxMhkyTS4S8dak8yhsexBoGAiWoxJTfhRY1KoAqvtr2Cx?=
 =?us-ascii?Q?NYsO5uqK9L3MgGfLy7ZdmoaY7FVmcQmM1OWn2k/vBKPeiSseW8hABMcT1Cla?=
 =?us-ascii?Q?aPmGteWgWeivD0uFNJadethhGlvnGw/GPUUNNnAdV811b7yhlSnqH+rC+Klc?=
 =?us-ascii?Q?Ymq9BpBCZWsehUQNuhAvvYQGVfP+BZrLPXsoAI14RSlt6aWJBWPPUrgVNQ2n?=
 =?us-ascii?Q?NllexEOULVXUAm8/dUpx2KwbjwktUZ2wHT/uBcN3IkClpiH3enCGoKjF9uQA?=
 =?us-ascii?Q?DK8vEYGRkbEremjKhuFVbTgwOvbld6T8TdZ8VyvrFSFL1estVFQlJky4K5JU?=
 =?us-ascii?Q?zWoGa0tDmeImwZbB6KEGJ6JwGCMWl+5tc2y8pjS9vf3xrp3c19x4+H3jUndW?=
 =?us-ascii?Q?dsHlyz068hXHkM9TzKihCQOIIY/YvXGaHJS5DZMcVUV4QOQoZzlUn+ilL0OK?=
 =?us-ascii?Q?c8Ij4YpfimDaNmYjxbX1CzhGK4VCl/B3i1MgFMs3ETJfDVk/sOG9cd2qrf/s?=
 =?us-ascii?Q?IF4vW0o9b3CB8UyNyNrbYBZl6sewKNjWpCPLL0nvhm8Z6D+Bu0XS16OVG+pg?=
 =?us-ascii?Q?EEu+tYFMJPKKizzwpMDbyW+BpsRCS2Y8/ILKJIABZJMMLXZntd989KhXft5o?=
 =?us-ascii?Q?GfSFy09sCm8qCHu8pH4rlB+vTqcNhVQE4dMUcIdmsubtDbKDen/hAwdlUVYI?=
 =?us-ascii?Q?Xr8PTFQyW4RKFgbVyq0GAdKwpq2mzafxLKEpu84D6Mh2g55iAaKfuQa4gV0E?=
 =?us-ascii?Q?yKlm1DSujto+Hatue94ATDXGDx4QxmqSOHIjhYpgvRKif0tQmZTFrFLWRB3f?=
 =?us-ascii?Q?noVN4aHhdiz75Vw1HcnQ4Fi6jHuE2xxjByBAva7M99eurvgLHNoaMew/26jD?=
 =?us-ascii?Q?ZesETMmlILDGF34dkT8kYl5FQ0f/J59xCRxOJ3kbA/fn7KsldeQYRdu3sb49?=
 =?us-ascii?Q?PwlT57fmEdqvJX8Ouc9Igvugsp5cKwVQqXsxcC+x?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d8e1e8d8-261c-4f28-a85f-08dd9168c0f4
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2025 15:22:05.8135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9YRLj8PH6pYfh7ahsAmojGCGJBdNR2Rd6Ktu3F/eqbL1WSImIMp+MLNHDRbiFJPyGAOnbxSYJi1l9D/oeBIllQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5230
X-OriginatorOrg: intel.com

On Mon, May 12, 2025 at 07:13:08AM -0700, Sean Christopherson wrote:
>On Mon, May 12, 2025, Chao Gao wrote:
>> @@ -535,10 +538,20 @@ void fpstate_init_user(struct fpstate *fpstate)
>>  
>>  static void __fpstate_reset(struct fpstate *fpstate, u64 xfd)
>>  {
>> -	/* Initialize sizes and feature masks */
>> -	fpstate->size		= fpu_kernel_cfg.default_size;
>> +	/*
>> +	 * Initialize sizes and feature masks. Supervisor features and
>> +	 * sizes may diverge between guest FPUs and host FPUs, whereas
>> +	 * user features and sizes are always identical the same.
>
>Pick of of "identical" or "the same" :-)

Sure.

>
>And maybe explain why supervisor features can diverge, while the kernel ensures
>user features are identical?  Ditto for the XFD divergence.  E.g. I think this
>would be accurate (though I may be reading too much into user features):
>
>	/*
>	 * Supervisor features (and thus sizes) may diverge between guest FPUs
>	 * and host FPUs, as some supervisor features are supported for guests
>	 * despite not being utilized by the host.  User features and sizes are
>	 * always identical, which allows for common guest and userspace ABI.
>	 *
>	 * For the host, set XFD to the kernel's desired initialization value.
>	 * For guests, set XFD to its architectural RESET value.
>	 */

Yea, this looks much better.

