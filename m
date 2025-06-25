Return-Path: <kvm+bounces-50735-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 88791AE8A37
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 18:44:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E7A521BC4BE4
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 16:43:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55CC72D5417;
	Wed, 25 Jun 2025 16:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UzmM54+z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15EA1C8610;
	Wed, 25 Jun 2025 16:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750869746; cv=fail; b=mpjsGsY/h/T1mTwwgQBCV2nkDIVLwNKfmtHI7BIhlWiKtYGd7YFgbku5foC7DPRcdGzttsl6p2Zt5rhgAAYJi2mEMhQB/7vKaVH4+C1PjQGQYvFZaVjqyUr0XWRneJgMTE27s+3aDaRqJKd552l+QRPQ63qsfg14oTpBDKNlNL0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750869746; c=relaxed/simple;
	bh=I+qnbNu0LkLRqbgBVzJWKvXzwE1unXyaqdvAM5RFVmo=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JCwpkjcFT0tp9f2Hb0scEfxgRAWseWVhoX9ma0oEKq6e7lZqjkg3Gnuned+pD6I1AJiUtxzigUgW5n/wPzLoI6jTYKqghci7tN0Kv3FiJlJ/CIr9hbeCDF5QmuAdBjF/RvOeM9Np7TJvJf2cqQjEX+abH8ie945a2hQYQeQtasw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UzmM54+z; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750869743; x=1782405743;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=I+qnbNu0LkLRqbgBVzJWKvXzwE1unXyaqdvAM5RFVmo=;
  b=UzmM54+zjuSdP6foa02qc29sNpsq9RVRkTrabr3+IjBm8Rb0RvRraLXv
   ea18XjBNy4LC0+QCSh8sFG4m+Urc1QUttWtleJL+/PB0W5h5iH8ynu7Q/
   LT9q3u7yt1epEYT2vCoucRPz8UAJd7uGwRLhIEJjgDW90ISMdaohjJ2Vx
   YGjcLY21z915gvV3Vu6onn37QwSn4MuuAqewA4lL7kBW1o6uTq6XKNUPh
   e7qGng+2OX0Yt5B8w3Q24tsGfN9CDRQS2KJ/izQftmchfpDKrk6HhyUUq
   4a6UmG7kX4TD94ru2MOBUwdNn6vCEXK1PsgvV7cC0k/pfiagFP7Gzq4aA
   A==;
X-CSE-ConnectionGUID: 05c4hy+kSau9ArrTEZRmmg==
X-CSE-MsgGUID: 6RbA/KptTHaokLbIusIyGQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11475"; a="78579433"
X-IronPort-AV: E=Sophos;i="6.16,265,1744095600"; 
   d="scan'208";a="78579433"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 09:42:23 -0700
X-CSE-ConnectionGUID: +KYgp7JvS1iIHDRiaCDGWg==
X-CSE-MsgGUID: +1CNIHRqR86yQBvbwphoLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,265,1744095600"; 
   d="scan'208";a="151880998"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 09:42:22 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 09:42:22 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 25 Jun 2025 09:42:22 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.43) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 09:42:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kGpVZWCvY92zU9glds5eEiYrSn7aDfs+qNzFEo0q/OvHVLQRldKC0KLF/euOA7tRnK2g/BhTMkME1WjUCOLvZSESqdU7yZkYL0BJkhcp8P5VEgtMJCebfYCUGDFs+Ta5eWLQ1LZolzZDwFwcWouGXFxfw/K/fNolaJASbzXdky+36PKByLjHo8kQE1XoBRG6Qaq9NyCOYpCjc6FLDKzFIQsJnroS+ESg7V36fd5C3joCmvt6apJW7ImmQDmJXZXZL4iv4vfUL/pRP50dXyqJCS7+SqV213i8KLVCRAXIYYkUv3n8vdromsx13t3K2CtKEZSGW5Biq+IlIYxU2wVjtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xctDZDBt2VAILAoV8vHnrdROawkhmV39uhw3+6bEMhk=;
 b=bOBTPQfRVtMH9cY4Cd/8WyL1vD/5O8zcNbRtFGq/vekb+7ZikY6bqpXXbFZDOWIDv4W07HEHNnT3ugK2TUYjw3Obq7B6+SjlyiazF1CGA03CsLe/VAT8h/rnsP4MX28g5TmjZGOZsgYAzDYVWrzbKxabvTGn9DgqdmtiKTo53kOy2mCR6b8jjUCTU3BzoKM58WAEAO+uYfd6lrVYXu8FpegfOBHuPSGJW0z2Jh+Tj8aqncIFiv4b5oEveWle04LMpnlzHyR1GURSBEL1NS1SWHznsmbkYtn8iaf2cWJ4f4pZwyCGHG1JMNN+rqSlO6xPTySGrqxTZohSKP+1dKrrDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BN7PR11MB2708.namprd11.prod.outlook.com (2603:10b6:406:a9::11)
 by SA1PR11MB6893.namprd11.prod.outlook.com (2603:10b6:806:2b4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.23; Wed, 25 Jun
 2025 16:42:18 +0000
Received: from BN7PR11MB2708.namprd11.prod.outlook.com
 ([fe80::6790:e12f:b391:837d]) by BN7PR11MB2708.namprd11.prod.outlook.com
 ([fe80::6790:e12f:b391:837d%5]) with mapi id 15.20.8857.026; Wed, 25 Jun 2025
 16:42:18 +0000
Message-ID: <6de76911-5007-4170-bf74-e1d045c68465@intel.com>
Date: Wed, 25 Jun 2025 19:42:11 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] KVM: TDX: Do not clear poisoned pages
To: Dave Hansen <dave.hansen@intel.com>
CC: Tony Luck <tony.luck@intel.com>, <pbonzini@redhat.com>,
	<seanjc@google.com>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, H Peter Anvin
	<hpa@zytor.com>, <linux-edac@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <kai.huang@intel.com>,
	<reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@linux.intel.com>, <binbin.wu@linux.intel.com>,
	<isaku.yamahata@intel.com>, <yan.y.zhao@intel.com>, <chao.gao@intel.com>,
	Vishal Annapurve <vannapurve@google.com>, <rick.p.edgecombe@intel.com>
References: <20250618120806.113884-1-adrian.hunter@intel.com>
 <20250618120806.113884-3-adrian.hunter@intel.com>
 <68938275-3f6a-46fc-9b38-2c916fdec3d6@intel.com>
 <CAGtprH_cVwWhfXFkM-=rVzQZ0CpY_zcnkF=q5x1n_9Bzm1xKfw@mail.gmail.com>
 <bc492cb2-1d30-4a30-9eb9-d48b09cd29a9@intel.com>
 <8f05cd1c-74cf-4370-a39c-8e06cdf2c921@intel.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park,
 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 -
 4, Domiciled in Helsinki
In-Reply-To: <8f05cd1c-74cf-4370-a39c-8e06cdf2c921@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DUZPR01CA0006.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:3c3::13) To BN7PR11MB2708.namprd11.prod.outlook.com
 (2603:10b6:406:a9::11)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN7PR11MB2708:EE_|SA1PR11MB6893:EE_
X-MS-Office365-Filtering-Correlation-Id: c75042cf-6065-416c-7acc-08ddb4073fbb
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZXUzWU40bmRBbzZEM05xWGVHZ2VxWnljemdQbzY2Z2lBM2I5TWIvZkE1MmJU?=
 =?utf-8?B?bHl3cU5Dbm5mUXZsdDV0djJ0VWx1V3cwUzFmL1ByNW52OUF0VDZId3UyMENX?=
 =?utf-8?B?U0w0UWNTbFFVNmk3UE94aUFnc1RUcEJkMzJWZkdTaW15c3lNR2VYWUNzem9Q?=
 =?utf-8?B?UWVwQXIxZTI0aWlwdjViOG5BcVN1M1lFbjdRbUxpUis4MjNSZzg5eHZmS0Ev?=
 =?utf-8?B?RDE5N1Mrc2Jid2dkMTFINFZ5Qmk1Y2E5Z3hxUVdCRHlIT0JCMkdSZjd1aXRq?=
 =?utf-8?B?QzBIOFFXWjZJSzBSL0pIcnpKUWJ6WkdBdDVPQWVnQW82VXgxTS90UlZPUWo5?=
 =?utf-8?B?eERFdnEwazl0MEZFeldDdm5KRWNVaDNJYm9yV2dYb29kbkdQamhQQ0gydjZ5?=
 =?utf-8?B?OHNVYmtLeWkrQ1hYK29MTVY0cDczLzdqOFJuajdpd2MrQlhYbU9kNFk0RTZ6?=
 =?utf-8?B?RG5ZOGVmdGVBNHNYd243eWI4enFJRnVteTdCT2pNSURBQ0dCRmlhRUVBYkVP?=
 =?utf-8?B?R0ZqbllvdUhCV3UrSUVTTHNJYmxOWUxkYXVoT0REWE44SXBNSkdvTFkrMkF0?=
 =?utf-8?B?QXNSdjFiZHV2UFoydGNjS2wvZW5PUS9OWGlYQ1QrM1BnYlpuL1hySVRtN0Zl?=
 =?utf-8?B?YmZwTnM4VC91MGJSSWlhWlRvYVQyUmRqYnFTdVlYclh1a05NSlNqVTR0V20x?=
 =?utf-8?B?bEgxMTAwL0FtVldYczVacG9ORHZTRHFwN0hXNlR1b05xVk5BUlNPZVQ2VHhk?=
 =?utf-8?B?SU0rZi9HcU9WYUxPeStGRkJCRGUrNW1aTlROYkRWM2h2bE5KZDdvRExicjhp?=
 =?utf-8?B?UUxOb3NxN1JSS0JoeE1HdnFpS3pQNzNrWVFIdEd5djVVMUJraEJJc29GM1Br?=
 =?utf-8?B?N29jN001VkF4TlhPS1dna1BBQlNUNnpvTG5CWUFRekhxbkZLSkdQWUloWnBY?=
 =?utf-8?B?U0djZXlRSWJJT3NlRk5qUFNNRm54elZsazNqSDJhVG56QWxsTDR0RzEwU1hG?=
 =?utf-8?B?SElXTTRlL2hzSnpIRDNSa0FsaTk4dmU0a280WU9hUVVFc2wzRFlFZDNYR1NS?=
 =?utf-8?B?OFQzUU9zcE5pZk5OSk8wZjNDeEtZd0ZtSTgzZzRQeERBcXYxYlcyR08xSXJ6?=
 =?utf-8?B?VUJVZTBaeFJCTzFsb0xuczkvZ0JkTVF1dU5PNzF4OW84eCtZVFV0SkpORHA3?=
 =?utf-8?B?N3IwQXVNUWVwR1hvYXQrbGdlakkzOUVLWjFVSFkwTEFEOUFGenNTc0JxOXZw?=
 =?utf-8?B?THFpeHVQcGxCZ1hhbE5LWkV1bzlXZ1MvQU9Cak5SblZIQm1WK3RMeEcvVHd0?=
 =?utf-8?B?ZDBKanZ3TjV4VGl5LzB2Zk9pR2daL2FjYmFOcnVDYTVHcDJ0bldDTjJENmhx?=
 =?utf-8?B?NEFieUVtT3BkT3hTdHhzQW5ZNGE0YUVEVk9mZW9jZXIxbHZpKzMxemt4NzVU?=
 =?utf-8?B?UVJMR21uWEpMQ3lyTnRwbXo2VGpXRjlVWEoweFh0dGZUZ2wrbUVBWmFQalpr?=
 =?utf-8?B?RUtjbWtKRDduSm9ucVRFdjk2eEZvaDdDS3RLcXBVbWRoSGNRSm5oMTJJN2Fh?=
 =?utf-8?B?U1JaT294ZlpoRVZLSUlPalFoVnZ0YUplak9BYUJxRm0wUVFMbDJhSkZ2Z0FS?=
 =?utf-8?B?azArMzNLQ3ZMbUJVTjN5dW5KM1FydHRHVGhyTlVTVjc4YU5FZDBRNU1BSDBI?=
 =?utf-8?B?SW1UaUJ4SzZST3NhTlZlNC9FUXBJSzVTTWE2Z2UxVnNqSmlqSG9Ka1cxR0dw?=
 =?utf-8?B?NmZNSU5RcFpXSjZPZnhvOHdqTUY0Y2lRSmNMTGRNeFpqZTY1Q2NIODFGM1R0?=
 =?utf-8?B?Vmh4ZU1IUmhyb3VHS2E0RDU5cldlT0tFYkIzSmZKNkNJY29pei96ZzdtZnRL?=
 =?utf-8?B?ejVqbE1XZ3lQUTNiS3BPaDFYaTZXbExXSDJ6Zm1NTUZyOVVnUlJvTXpNdHUx?=
 =?utf-8?Q?3rlK7WoERl0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR11MB2708.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dWpwWHNNMUVvaUI2Vm9wb1RBanNtZ1BBTS9tSU9VRzdLT0o1SFpXajhvSkNm?=
 =?utf-8?B?b2t4dmtJVElTSGorWUFscldQakp0WG9QZWlsSzNBS01SNzNqNWNxQWxLQ1dw?=
 =?utf-8?B?YUZ4MHNXMVQxV0JLaWxJdmVHV1VFeGNxYnJNMEJUV3dpTmpORTdSem5abERr?=
 =?utf-8?B?TmI5blBIZmU5VytZL2tCRHdwNzVianIxc1pVQUZoSTYvbHhxNlJnb29HV2VU?=
 =?utf-8?B?ZlMzai96clRlZVZ6QmpCbFpqOUlqQ3BvUDlxMGkvaDVaWGNjTUM0aG4rT01D?=
 =?utf-8?B?eDJFMFdjMnVZMjRaUi9LcFQ3NUpUVTMvdHRsMTdWWUU2SDdsNVRENUhpU3RU?=
 =?utf-8?B?eitFM29zNlprejF2K2prOHBYcFhLVm9JcDF6amVaaUIxT0x4TkNvb0FVa1Nz?=
 =?utf-8?B?ZnBKY2xXcHdCSG5rUkVKZUNiaDQxUmlXbFkrVVBPUW9iTVp6ZzZKeXFPYlZR?=
 =?utf-8?B?bTVkU2tLeHdoRm5CZTdtYWFRRFZLR0dQRWREVGpnbUlhM2FjS3IxSVRNOGw2?=
 =?utf-8?B?cWFycWVTL2hFMXF3Z2tVZHdUZXNNL3h3ejNIN0VKYUpwYk9paU44Z283RGVY?=
 =?utf-8?B?MGZSUEM5Mk5YSEtXUC9TL1RXMFMyYW1POFNRMTJ5K3g0TTE2clNzTEdyV3Fo?=
 =?utf-8?B?dGpPMWlRa1VZdi8xZ0xESlg3YnhxOFZKZWQ3Y3lWL3JvR0tQM01aZm93Z2dq?=
 =?utf-8?B?YTMvbmwvZFVteTR1a2ttS1BaTC9nbi9pZVd1bUtIRFk0dFJyUlJ6ZVZObjlu?=
 =?utf-8?B?QWY4N1J0K3k5SVR4YmxLQjdLYkliU0lDWG13NTlDQ3I2eFp1eUcycXFsbW1Z?=
 =?utf-8?B?YncwZWY1NEdySytzaEdvY3NjbXFMVTFhNUpKYWYyOGd4SE1WQi9NdkNmRmpj?=
 =?utf-8?B?dUlOSUlXVjRWSnJTaUloRUdzRFVZRndIMUpiVmJnd2JNbDBmN0pTR1pueURM?=
 =?utf-8?B?SUNDQ3o0OUhqM3I5TEJ5SGhmZEVMODlubVV5MGpsdnQ2M3Z6dktlbGNVK0Zn?=
 =?utf-8?B?L3pyYU1wZ3hqOENPaW9aenpPRWNzdGhsTFhOc0JDbnI0U1FSejR4RWFmQWRF?=
 =?utf-8?B?WkZqNDNPclpWbFo5aVNwS21tYVNzdDZpblFLUmQ5cmwwdEptQjdiUjBFOE9M?=
 =?utf-8?B?VkJyWjRmMmpLMWtZRk8vNk9lZjI1NVBsWGU5Wlg3cFNBaGp0OXFzaTRlUDJH?=
 =?utf-8?B?ZWt6MXh5OHo3U2RKRnJndnNweGY1RmZBZ0VCc25wSHpsVmt0ZVZaOTBpeEZ3?=
 =?utf-8?B?cEMxVGtyM2kwNEUzMnROUFgxdkw4ZTdZWlJ4TTA4cWEwRWRsQnN3anlSRHpL?=
 =?utf-8?B?c2hTZTJYd1I5dXFzeWxWOGNlN1pIOU5HajhwMlNocjg2OWxzM3dkazBjNVNj?=
 =?utf-8?B?aGNncTdwMXFUcTl6WFdvR1kzTnlXaFR4UytFOTV6Z1JLTzdEaDdheEUxZm5C?=
 =?utf-8?B?RkZSUDA4ZSt4WE0zRkRuZTJQSTI3QmcveVVpd3h1NXhjYW1qRzUxOXd0ajVy?=
 =?utf-8?B?Wmwvbk81ZVozM2FRamtITWhmZGtiMXAwcXhNNXlQV3d3VEdNNFVXc0wwSnlO?=
 =?utf-8?B?V0w4VXYvaUNHaEt2WTcraEMxY2JtZ2FwdzAraUJaeG5RRHNvNzNyMXhVZExM?=
 =?utf-8?B?Q0xqVUVMK0NsdFdOWXZXa3c3cnptTm1VL1psOFZGdEFST2l5a2t6TVVTaDRt?=
 =?utf-8?B?Z2lPcW1jd2tVdndCZjBCQWFEbXJ1NUVXRGFETjlhWFEzQUdQbGRpUnZrbC9D?=
 =?utf-8?B?SHI5VjFXd2VIQTcyayt2cUNFTHRiRFN2VmNCQzRsbXE4MUF3SmFPOUIwWVps?=
 =?utf-8?B?T0t0TXBGam9Za21oS3JLUTFMb3J6LzZqaWZyZ1A1QjR5a2dyUTEwczFGcUll?=
 =?utf-8?B?V0c0TElsSlg1MkkyYkQ5ZTlDcWl5TXBFSDdiQmtydGVCTGxTeklpMDNPTjg5?=
 =?utf-8?B?bmI5S2FabUdCWlJjdXRLeTZyUjhzbGhlT3NNSjMyT1JweW9WQ0J3NnMwdU5p?=
 =?utf-8?B?ZDFMNlErV09TTnl4TVVHT0VKOEpNOGVsY0s2MFVGTlBKU2RQY0p4RUllZ0Iz?=
 =?utf-8?B?T1hVQ0daeVh2NmEzYVhBdnlnV1F6Y0hLSE1zS3RWR1hSbHhTQ1E2MElOUVZt?=
 =?utf-8?B?V0p3NCs0UFNrVkwrT2cvWWZjcS82S2JYcWttZ2RUbDkxcFBxd2FBVWtmUElK?=
 =?utf-8?B?R2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c75042cf-6065-416c-7acc-08ddb4073fbb
X-MS-Exchange-CrossTenant-AuthSource: BN7PR11MB2708.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2025 16:42:18.6307
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FAy/BLgRehLE8pToL070WP/qtzurfy3ghIKxONw6Z6JFjgvH8zSBe40knvcAVAkt2JeiPEkGXu54zOWAI38cDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6893
X-OriginatorOrg: intel.com

On 25/06/2025 19:31, Dave Hansen wrote:
> On 6/25/25 09:25, Adrian Hunter wrote:
>>> IIUC, even if movdir64b stores contents on hwpoisoned pages, it's not
>>> going to cause any trouble.
>> No.  PageHWPoison(page) means the page should not be touched.  It must
>> be freed back to the allocator where it will never be allocated again.
> 
> What's the end-user-visible effect if the page is touched in this
> specific function in this specific way (with movdir64b)?
> 
> In other words, what does this patch do for end users?

We have another patch that clarifies that.  It turns out we need
to clear pages (MOVDIR64B) only if the platform has the so-called
partial-write errata X86_BUG_TDX_PW_MCE.

It was decided to deal with that issue separately, but maybe it
needs to bundled in the same patch set, now that the discussion
has moved in that direction?


