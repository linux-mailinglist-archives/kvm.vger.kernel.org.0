Return-Path: <kvm+bounces-39579-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FD91A48102
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 15:25:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7A72218943B4
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 14:17:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 587E0238D21;
	Thu, 27 Feb 2025 14:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kJEUp7R9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A25140E30;
	Thu, 27 Feb 2025 14:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740665666; cv=fail; b=rwJdp+j0tGXzioh+2AYJzlWehPzPYWnD0yEnz03WR8Gjulf7UEyYPegvR7HfgwSH3dei5TeCoI2uzBlv3/tROEyB9wiM+gGS37PCrVJh3Xb1tMoQpZhXsjvFZitgCCJ7+zLc/4Wblxp632kYvvQQkuwrLZ5YlsaXtYEIobut2aU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740665666; c=relaxed/simple;
	bh=NBMxLT5tBKdVlVQQXmOG6WYUCLA5uvlGWJdVPGj/ag0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GlMW+GJFce63KEKIWOmMVZwYm6AmwkDicMezt0D0GZHYkrjiD3v7GqJD8HzwDqd7RjexiqCGwmR9+MnKb6um7BebpXNiHDLsq6VkIs9n+EFrcPoQAiV6dSSjp5GcpXFJWKD/v5/HfGvHfAXrmfu5/+1B6uPTHbcHOlfaRcHA6oI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kJEUp7R9; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740665665; x=1772201665;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NBMxLT5tBKdVlVQQXmOG6WYUCLA5uvlGWJdVPGj/ag0=;
  b=kJEUp7R9vU/37zQSPVE/dZciJyB27Jl0tz5fbZEc1oI0WPRX10AmxLI/
   dA2hA3HaTXJ32qlJp67k0MLQpJEKWKYgETpkJXzS+slskCGDUZpbEwjSh
   MPuxb780H4ef9l8Cbyr8KmLpFsh73BNzI3irTnYssE2T9PbQWsKk9ks6u
   4dKvuFnQU3NpwfgOPXNLk7pJxHOOrJzVndfU7ycc68IY2fdiDU+nP74GJ
   Oo72oM5wZrzGvw2oGkmZ3EPheq5zMJPdHB75N09SGJUDAxdSKQJQCbqmh
   XUVK3Kbfew+0CCYlOVjo8KHXitzEFe3lj+Co+cNilEJe0MldWfG2PRQNq
   A==;
X-CSE-ConnectionGUID: Pi4bzna0Q0e3ZPo1onhn4w==
X-CSE-MsgGUID: aOr00EPgS5K6vrWvzfyhww==
X-IronPort-AV: E=McAfee;i="6700,10204,11358"; a="52195625"
X-IronPort-AV: E=Sophos;i="6.13,319,1732608000"; 
   d="scan'208";a="52195625"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2025 06:14:10 -0800
X-CSE-ConnectionGUID: pCG8utvpQE+zUAC7C5XpgA==
X-CSE-MsgGUID: MnASKozPQXCF5ndueyfsvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,319,1732608000"; 
   d="scan'208";a="122155709"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Feb 2025 06:14:10 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 27 Feb 2025 06:14:09 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 27 Feb 2025 06:14:09 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 27 Feb 2025 06:14:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tOkL/+C7Ox1CYw/sCcaM4n66FCQWvMUXijpF3Gl0HvdAbJNUG8w2yLKUdiEJw4FISsFjJylww0kSuO/7YC/cJA3xxqs7peOnNNv9p7YlDXX2/LRqeWmVBUyUp1GmXmiGYJLDVCi7nrxRT0BzZdnwzYo+MOhIT8pk3VkjVKTX1/G+UiTdeUUoQucRGULZBKqwzFNKmNw66V+8CR1Cdh5wlKRx96v1FuRTxiYevWZ6heDjCUo6ADNt1Iu6TA3vG9K01c4zcxgOU9hdmDTxh+pWqB4z2kMtkaCcDaUH3Zl3tv35GjehSiIA4JMxI/b9dd+USMqDUgmlNwTIpb4EvdQVRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fCaplqXeykd0rItvuTCDKwXBXmSfLGaiG7NkilC41gg=;
 b=r5l4KKaG/wmdqXMKMhR/hVjWpXnPdtVZKLz+phXsfIb8A9WRdmfD7+IjK1XHJLeEzp4O0Ovg3mJWrtd41rFmGMl5Y5PyLBFIEXCwa4F5nUwdsUAGTouFvTlrdKhiUCqFYm8F55uQynQ6z/pnDSZMWLoRKQo6oH7W6SIkOQgvSRX/P0dMixYPNdBrph6bijZwlo700KWyYA2ezkgKhrinpIy+EuDGIgfN+W3tekgaBmTKBtly/2l38zsip1nQ26C3RgVUnAyugy/gTacuHMSEPmKrWUvNgtPpt8je9twJRqU3LCrZKzn8ceGzbiu/XHUUJsfutlH8oNdYaRD+cCfhHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3605.namprd11.prod.outlook.com (2603:10b6:a03:f5::33)
 by CY5PR11MB6186.namprd11.prod.outlook.com (2603:10b6:930:26::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Thu, 27 Feb
 2025 14:14:07 +0000
Received: from BYAPR11MB3605.namprd11.prod.outlook.com
 ([fe80::1c0:cc01:1bf0:fb89]) by BYAPR11MB3605.namprd11.prod.outlook.com
 ([fe80::1c0:cc01:1bf0:fb89%4]) with mapi id 15.20.8489.019; Thu, 27 Feb 2025
 14:14:07 +0000
Message-ID: <1cc904fd-db40-424a-8b40-44f086a6804b@intel.com>
Date: Thu, 27 Feb 2025 16:13:56 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 01/12] x86/virt/tdx: Make tdh_vp_enter() noinstr
To: Paolo Bonzini <pbonzini@redhat.com>, <seanjc@google.com>
CC: <kvm@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
	<kai.huang@intel.com>, <reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@linux.intel.com>, <binbin.wu@linux.intel.com>,
	<dmatlack@google.com>, <isaku.yamahata@intel.com>, <nik.borisov@suse.com>,
	<linux-kernel@vger.kernel.org>, <yan.y.zhao@intel.com>, <chao.gao@intel.com>,
	<weijiang.yang@intel.com>, <dave.hansen@linux.intel.com>, <x86@kernel.org>
References: <20250129095902.16391-1-adrian.hunter@intel.com>
 <20250129095902.16391-2-adrian.hunter@intel.com>
 <0c2bb665-93ee-4f46-ac28-5dbd1dd2b9a2@redhat.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <0c2bb665-93ee-4f46-ac28-5dbd1dd2b9a2@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MR1P264CA0145.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:54::10) To BYAPR11MB3605.namprd11.prod.outlook.com
 (2603:10b6:a03:f5::33)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3605:EE_|CY5PR11MB6186:EE_
X-MS-Office365-Filtering-Correlation-Id: fa2885dc-f743-4e11-cded-08dd5738ff03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?OXl2c2NsZW04S0ViZWpuY0piek8rUWNpUFF2OGhlZUdaTHhzMG1nOVdCbkUz?=
 =?utf-8?B?VzI1aHZ1OGk2U2hsWUd1QXhuVG0wbkN3WlYxMWM4VzRlS1kzbit3UzZ0eWth?=
 =?utf-8?B?WFNGZ2ZYa3VnaVhCYVZtS04vbTZqYytYc2dkNDZCc1hNSDdRU204SFd2L0Jv?=
 =?utf-8?B?bFRTaXVkdEZKL0U2L0ZhcmozM0FkVCs1dUZmdGs2ZjFVTUphM1ZGaDlOMDA1?=
 =?utf-8?B?b1V3cCsyWXhqcVVZalRBQzdYTkhXK05USXJpQmRCWmFidytrL3o2SnE5dlNU?=
 =?utf-8?B?T1FSVEd4MjhlQnlweDZXV2NBL1JwUTh2ZGpKajdHSW5TcThPNC9BRjhpTGZr?=
 =?utf-8?B?b3BEVkJUaHU4bjg5RGRFQVE0eitaUDhHVzlKVHBpQlJ2VldYbDF0YnNNRGZ6?=
 =?utf-8?B?d29QUDljTTFFQmswdjk1M25oQUlRd25QRzNZOTZZdmlHUFp0OVNEN1dFZU9V?=
 =?utf-8?B?SGY1cUpUb0pSTW5sMWtpUWFCVDdrNnArYTJmbld1SjBFMTZjdHhDZGhRemVa?=
 =?utf-8?B?SngzSDA0NHNNV3oyQUFQa0VHZ2N0UlRmL3hvMXVNWkh4Tkc5SFczZ3l0ak1F?=
 =?utf-8?B?TlBJQkNkUy85dGVpa2NpOHhROWdzazNMUmxhNHdib1lYamNHRzhLWDVpMHFy?=
 =?utf-8?B?V1RPRU9relRRLzY4K005RkZGVVA5Q1RnWmJtL1RjRXRaMGI0d00xa0Jlckg3?=
 =?utf-8?B?SFVHaEd0LzEvdzE3NWZYeEVJa0JZeTdmdW1talpPWWZQcnFCQnVJQWRTM3hO?=
 =?utf-8?B?VXhsYU9Ec3I5TFBuODArVm45SGlZcUJKclJLMjI0Q2FLTm5sSnJkVDBDbmpD?=
 =?utf-8?B?Mk4xMGJabUtONkI4YmlLb0FoNGJMWlBrRkZEQ094TVg3aGQycmdrQ2I0cUNx?=
 =?utf-8?B?eThtc2xJQ2xKR0tUMXg3ZkR0ZDRFM0ZNOUtGSTVqN2ptdWpMZW5taE1YYUtm?=
 =?utf-8?B?aTJwVDVKUFU1RENoOU9jMkl4REY4WjA4bEdQMWtJQkpjeXRoaStncXQrbk1q?=
 =?utf-8?B?eVVpaUs1OFNCa3NhMEI4aFdsL0lZK3htUjdyOWhWTzdheXN3Wk42YnZJWVZI?=
 =?utf-8?B?bGsxeFVYeko1YXplVXNQVDNOL0Z3bjFmcU9KZVcrRlRMQ0FSQjVsOThCdVBK?=
 =?utf-8?B?UW00Y3NVNGMxeGlnWk4rZHIwYWpQYWZ2c2Rqb1duZ2w0bllENDdhcCtRRWk4?=
 =?utf-8?B?SllkTGFWQXlxemFJWkNWRWQ4aFZscnBkcHFFbFdBb0RpcUVNeHgzYm9qUmow?=
 =?utf-8?B?UDZvRUFvWnVYVHFNU2wrNDl2OFFDb20xaDhDUWhyTE9ZdnBNRnNpVS9CcDJF?=
 =?utf-8?B?Y1B6MGZicitRU0JEQzRxQ0FHZVZyUlpIUWhUdEtpdHFaQUxwN0pnZVNVakxJ?=
 =?utf-8?B?SDllZm9mRUlMOXAwQUFhREhZbzBVUzZDQWdMS2o4SU1tSHZyTEVsWEtOUUNU?=
 =?utf-8?B?K2dVU2xoaDNKaWE0V1ZSM3VnQ0R5bXBlRWFJU3NVcnpoK1RweGtqdkMrb0Y5?=
 =?utf-8?B?cENGc3FyUW43bUd2VUFqMk90OUZ6OWorSEE1MTBEYkd5S0pPTDFtV0o4MWFk?=
 =?utf-8?B?b3FWS3RWamNqa1BWUjZmT0VKelNIa1NnQ0Nwb1M3MzM1czd1d05rWnZvWlZo?=
 =?utf-8?B?VlVDYUdvRU1KV1Z6dG1HTTZvcjcxOFZmVENxQUFiOGFUUEMyUUJDMXQ5ZmpZ?=
 =?utf-8?B?UGUvd2lkdE5rVTl2NkRRKzlZMzlyN1JEUGhoc3NhcW56MXpMa3lXb2lIN2Jh?=
 =?utf-8?B?dUlIbnBsMDlBK2tNeWtxUUxtLzBCRUR5eUlQZXlkc0tSVHZEbnR4UmtzdnJ4?=
 =?utf-8?B?Vk1EdmFIMmNDd1Azb21MOXp1cWRTRUxMMkF2YjN0WkNzSGdOaThqNVFRQUY2?=
 =?utf-8?Q?nJjnnwzUxd7Hq?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3605.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aEtNKzU2eWhzVWd2cFhhbmZ1R2JCMjdHZDZ1ci9RSXduWkpDeVZWK3k1Mlc4?=
 =?utf-8?B?WVBnQ2tVRk56Vko3bytDN1RtbGJGWmhMTlJiR1pRcWJFaUZBZ3BBODJDWmlW?=
 =?utf-8?B?R1lFYzZBQWVwT1NPR0YyVGVoVHFJTVhJT25Qc0dueHZHVWV2TUxWNnpwNzVz?=
 =?utf-8?B?cHg0T3V6MnJKMTJGcXF3dGp3NmZKRXBEUk9jdUpIdE8yb0l5aE10c3VYSG5Q?=
 =?utf-8?B?Q01DM1hXMGdZUEZjWCtuMGI2RTZRS2psWnJnR2hkZ3FJcURUaGpGSDdheE9a?=
 =?utf-8?B?TUx2K01xYzNCMmF4K0I1REtVUHhsMHNmWExZZktXNjBDMjFXUy91d0lvUE94?=
 =?utf-8?B?akZObTBPSmVFamtBcFR6bzdLSDkrWGtNQUtuZW82c3VHb1FSa2pGbFRZa1hG?=
 =?utf-8?B?d3pNaEl5cmtPTG1VVjB3eldZQ0prbW1tZThmMXBIa1U1WG5lL0ZaVXdaSEpE?=
 =?utf-8?B?L0NCM3QzbnNKaEpmcE5kZDBlNEZUbDQrdFBoRmhLdWkxcW54ZWNJNWlpV2ZK?=
 =?utf-8?B?QUdKZFFyNkdIM2JjZ2p2ZGdvcXpwdThaeVFsaklBb3dqSklUZXR1RUR5QmRp?=
 =?utf-8?B?c2RUTmVNOEpPNmFnUW9jbnNYdHZUK0tvbHQvbDM0OGNyVFZ0L0pEd212Rm9D?=
 =?utf-8?B?RkhBZnBoTEIvcTl2RWgwMW0xVmFzcWMzbXJvNy9DUERMUVFpVTgxdmlmQ25o?=
 =?utf-8?B?VCtaQ2RDYVAwK29ORjcxWVFuMFlpR3p6SHlWbWhpZHFBN2xlWXNZOVM2azQ3?=
 =?utf-8?B?dGF6RUNIdmo3Qm1NbzlTRzBLMnU4elNsRS8vU1k4S3JRclFvb1pqKzJnYXBT?=
 =?utf-8?B?Sy9vR1RjcHVrbG44TjYrdGdadEZaZmV4cit4UWlBNXRFZUdobmd1MXQzQ0dK?=
 =?utf-8?B?WU5pK0czU2dkcmE5bkVlS05Jc3dJZWRLb2dHNVZwU1R0SHh1cFZuUTAvTHhB?=
 =?utf-8?B?c3I4Rmd6TjZaSUwyQVB5aEZjNkQzbDNZK1ZZQVp5ZzVwYVhHYzlDcUhGUVZr?=
 =?utf-8?B?djduV3lJQUhvUE1DS2hxM2NkTWdDaGk0MFc4VzlJaWNFc2s2ZlJQL1FaUUF1?=
 =?utf-8?B?bE5ZSmFkZEs2bnYvZGlQd0ZVQk9HRFd3ODFOdThOcEV2dUNCOWFGQ0M1YlhW?=
 =?utf-8?B?UEJud1lTYWpTdEVJY2ZiTkFvZlJvcVFxWjNJQmYxMWNTaE1UQ1FFekw0ejVs?=
 =?utf-8?B?MUpDSHI5aGpSaVhJejBFWGVuMFY0UDgrWmpNeGlPTEpEVWZiQytaakZxL3dO?=
 =?utf-8?B?M3JGUDB5YmlNQVhwVm5SNlBGYUY2Y2RkYWpDR1NNbnVBY3N2TS80a29KUmFQ?=
 =?utf-8?B?U0QxcC9YUHpWSU1HN1AySlNJVk5NNGJheit0cStmTWNYc1BpTFZNeHFDWjlV?=
 =?utf-8?B?UVFQbFhhelBYWG1lRmdHcldmS0dZSklvL1FqQzE4ZHZ4akY5cVhlMTBrMnhC?=
 =?utf-8?B?U2xiNFF5UUtMSldiQjlTd0FyT1FUZW13dXF3M0NtT21QZnRMVEJ3VjRpTlVK?=
 =?utf-8?B?SGtvSUx2cDBHL1Zabmdtelp1SURlTWlvRThLWUYvTERZcVhaUm9rV1JmSUNF?=
 =?utf-8?B?d2RuVzNOeWtXZW9LY1gwa3ZoSkxmcDFnN3haaS9pTERmMmdsV29aeFBjNW1C?=
 =?utf-8?B?cGM5em14NEg5MEp0SlNreUFacGVudXQ5b09ZcThtaUZsVE02OU5xVldmYmVE?=
 =?utf-8?B?UzRDOTRBQlQ5aHRES3ZqM1k4U0VocWJwTmRCWFRhaWdiTlJVSTNVZm1WUmJH?=
 =?utf-8?B?Z0FXRzQyR1JZb3g1cDQvQVl4cTlzRFVTS3NxNHNjVkxiaTdRMlFpL2NVdzMy?=
 =?utf-8?B?VndnVmRBTEc5N2h0K3JGU0RkMzk4b0NOS2U1aEZXa1piUDBTY1FzcUlON2tD?=
 =?utf-8?B?c3d3TjlKcnM4c2RjblVyS3ZpSzF0NEtKcjRlZ1JMVGF4MnlOZ1V0S3k5Y1VL?=
 =?utf-8?B?SmJFVUFqMVlLNFROUW5IZVgrMHpOS2NhUTczVzJRcmdpOGh4Q3J1NFhLMkxJ?=
 =?utf-8?B?L21ydlN5K09tKzdzT20rczJlKzNzbVVDV21LQ2V3MkF1UjIyNWwxT2dhVUdt?=
 =?utf-8?B?Q3psa2xVb0NKUld4R1k0UXRzYmNxeEd3bnhDaUZQWTE0cnlVUisrUFpoU2J0?=
 =?utf-8?B?Q1RZWnFTVFJFOGUzamtqR0NXY0NrNjJlOWplMm9zdWc0Q2J3RllRZXU5dXR4?=
 =?utf-8?B?YXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fa2885dc-f743-4e11-cded-08dd5738ff03
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3605.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2025 14:14:06.8925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MjcAEqi4TKeXpvhitfk2mGSkokHVIrGLwKDuGT/6EZqM459NsWd2hkJUpvi3OA20LErO+vTZr51CkRnwpAF9SQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6186
X-OriginatorOrg: intel.com

On 16/02/25 20:26, Paolo Bonzini wrote:
> On 1/29/25 10:58, Adrian Hunter wrote:
>> Make tdh_vp_enter() noinstr because KVM requires VM entry to be noinstr
>> for 2 reasons:
>>   1. The use of context tracking via guest_state_enter_irqoff() and
>>      guest_state_exit_irqoff()
>>   2. The need to avoid IRET between VM-exit and NMI handling in order to
>>      avoid prematurely releasing NMI inhibit.
>>
>> Consequently make __seamcall_saved_ret() noinstr also. Currently
>> tdh_vp_enter() is the only caller of __seamcall_saved_ret().
>>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> 
> This can be squashed into "x86/virt/tdx: Add SEAMCALL wrapper to enter/exit TDX guest"; I did that in kvm-coco-queue.

We have re-based on kvm-coco-queue so we in-sync on this.

