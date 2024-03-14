Return-Path: <kvm+bounces-11841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23CA687C4F9
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 23:07:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4727D1C214CE
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 22:07:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1446C768FC;
	Thu, 14 Mar 2024 22:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QQQe5nnn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A84E74BE8;
	Thu, 14 Mar 2024 22:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710454056; cv=fail; b=jQK62olY9ZZkbptAKlV1qa92KlG4wRyBNNF6hd2IEQrFuhQYGdRGF+1bMlWCHF7kNyOogQibvUk1aJnVhSzPwEvVgcPDuzIrTii31BTyWJGxeWOyO27wmnm4h7uLBh9f3kTiDTGAXfwKH3u5xFPLW3Pwa5r17boHBkzuB+IEfhE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710454056; c=relaxed/simple;
	bh=db3Qid7BKPlxfQZmwyniMSepdtk0gpbn/m4ZkuISdgo=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=I+kpxwDA+By3IuCm4RnGjg1SwEEfA+fNBHUqcLf/pGVK6PXSTGeqfkQfwftAg9J1eTRQECHww9gKf7JF9gLEKlFfBnIRV47iEP4tJ5Q9x2j51V5L7/q3KKLnVhvZw6yGOSAm8Ov0255R8fSqcv1/V1guk4mjgcyLuCYU8OZdNZE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QQQe5nnn; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710454054; x=1741990054;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=db3Qid7BKPlxfQZmwyniMSepdtk0gpbn/m4ZkuISdgo=;
  b=QQQe5nnnCXYOMr6o+BkxkIQcdOHZzXR6aoOBIkXYpYbBvtefSk1vPobo
   cgkmelRL9Y1Xf6EyiHFmKt7fBxAcHoPP65NtPLNHx+XHLt9+UY8hEA2sZ
   x5czAH2hwT9W0SV5ePColsDLN8tOlK1BH/vELRsnJcfXTK3IxHwjleHNi
   gmJrxLeveb0+ZUEhjD8UBPcJV+CUlzlAiboBoxiLmD1Zn14iEjI9IFWpN
   Wm+Aael11ONwC04mb2qMWHu9cAy4KfAgOaVTjaDw3vb/BKfuH0VdoEL5n
   eGCzm85sB3GkBnH+7LVEeEDo/mTZN3TJs3wwT43jvrHCUfiYXST4Q/Rbo
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11013"; a="8241979"
X-IronPort-AV: E=Sophos;i="6.07,126,1708416000"; 
   d="scan'208";a="8241979"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 15:07:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,126,1708416000"; 
   d="scan'208";a="12363799"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Mar 2024 15:07:32 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 14 Mar 2024 15:07:31 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 14 Mar 2024 15:07:31 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 14 Mar 2024 15:07:31 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 14 Mar 2024 15:07:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gxs5krIHfXS8Clk00eGw+qhDr7tvGuikeKKq3n9s6aQ6bfTFOfbdGX50D+pPGbjVO/1ncnMXrX7Y1fSH+zZ+TzWtWEhyFQU8kHujoLWtBVQcRSiSmB7jlmoOOaXWbL+SHPRhkgI6gNA0gncl08ngp2WcMIZCbJFM8GNHOyFreMNt44ym+M0H+apEhmRJoXYq3MmttTMIqd+tDdvt1qo/tYDd0iesGu49pLQNZBkY1hndr5gWxvxzvFpNeCyoGk8GG+Kms1+i1kuUaHYBSzU/2v5XUoHhnYrQb+xRj+lzZOOklhyLHJD81DRh5+o0j8gU0AaP2rQkhCLQv7D8bROT1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bPtctFigCcoR+2p2apDHmeXYl+1WGDgDFqdXGLCpLeY=;
 b=VQwDkjlMdioKtBSVNPHcEHEb3nxd0Ik+8Nw4tUntM6EZU47yi5vrprIMN/tujMp934QAL1nk3SllJCOhEV8R7m6c/mJ9VVH2Kr2FjgsC3fTug+bewa4n8BIE0JMqbx4Q3FAZxi8zNYjoz+3lhx4m8fAc7eTRnwAHydiOCthzy6DgWGiZC7FDedTBF3/JisGdNIa1ndLPzd+ABF1cmJ8zbPqWRLKzVJAARob++XpjQw5if/L/2KVaJOEUMHPha5QqkWjqgU7dbYI8t+mMxSBGcp6mqdFupFY3josyPHVgsXsF6pMyEoD0rB3dxRgwYN1ejoW1Xen6tqiNdSNrCgAZ2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH3PR11MB7722.namprd11.prod.outlook.com (2603:10b6:610:122::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.18; Thu, 14 Mar
 2024 22:07:27 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7386.015; Thu, 14 Mar 2024
 22:07:27 +0000
Message-ID: <8f6d7c14-5341-4d13-9538-d34a18d3c117@intel.com>
Date: Fri, 15 Mar 2024 11:07:18 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] KVM: x86/mmu: x86: Don't overflow lpage_info when
 checking attributes
Content-Language: en-US
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <chao.p.peng@linux.intel.com>,
	<isaku.yamahata@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20240314212902.2762507-1-rick.p.edgecombe@intel.com>
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240314212902.2762507-1-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR04CA0313.namprd04.prod.outlook.com
 (2603:10b6:303:82::18) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|CH3PR11MB7722:EE_
X-MS-Office365-Filtering-Correlation-Id: 9588ce74-dd37-4783-42f0-08dc4473224e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RTfX8srEImvQsn9qPSUsLDQvz4Vkvd88LlIcP/cnfZoVS8RG2x0GrwefjfyG9V1T5+HtB1fUQQRUyhhXzSBjcnSuyJdI64ZmafkVwkJSF2U8E6p/FoICk7buivwwwfGgbTyFJNTk2HW6T8vQaWa5tRrjelTHMNZDLz00Za64hrGoWdsKvxV6VDcz4z/yW/VbltmnQ+Uh8VrYDzt1GI3H7lq8W9hwDqngTrZ3/YSiiXlM+IUpz8yhq7euNoOuMgUT7iIVfoo63E5WYAy9isp/yhb2NdHREr3LDLXruiTPHL13/hY0TgoL3skT9gdDAkhl2Dh6tdVkuot4M5ezniSisL3OdoVZVNcKXaJf6voIXVhXYiSzB8cDs94h4uPRjB5SjPaBsYpyCVhFHUfJgmCIDs7ZZfH8Tpj4KIqDmZ0Ss9DFmEPBXgi1HoFVlHnOSKBEfEXwEOvlQHjqQGnLG/m1HC79FnC/8IMGpviF3YEA57QZy9/bHvneZboEZ1LnHruvd1JpQQjLbmDilWGjsD6PpYYQMCFB57ryqRI72lP3TopY1wfynHe8QklF0WxiPBbs6/jT/j38YqYA2zsrN7Q1BX2COjlIUddZK+SHjFG4sTVZLkqCr/m6PpVRrlet3X7MGMsnF9CB0yyVfedQ6ULajcYPUD0gBQ0spZdMyNwfmds=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OXF5RWF6S2ZjRWtnUklwNW1vRmw5YjUzM1dka0NjdEYveXBYZmJwSGRqNTda?=
 =?utf-8?B?cSthMEc5T1F5MkFhTnZ2cUVzVkwwOUF5QVpEUWNRNXhES1ZuTzVZeE93ektS?=
 =?utf-8?B?Q0dRek1UY3JyZFloSGhZQXBxTFY2VmticHZIMnZqZVRJUUkvbkFFUTJGejYv?=
 =?utf-8?B?ZkdQQ21nbTNLOEpTMkxrZlJ6cE9CZ2FFdGsyZEptZkFzbUhRa2FlUVpnclM2?=
 =?utf-8?B?VytVZWR6WXdaRjNkd1RtbE1Takk0OG5BeUhQK2xyenlTaVJzcmtYNHpZeFY0?=
 =?utf-8?B?bDhaNGFxT3F5bUtmcnZYZnYzOVFaVTIrR1Z2QzVBZDhYRmtwZGdSTHg0NnVD?=
 =?utf-8?B?Y3kvakxOYXZ3UzRTYTV5WTNhOEV6VnJQMW1Dd1RVREZCQ3dIR1VXLzdWRDNr?=
 =?utf-8?B?Y0ZQNzBHMER3SnBaMXM3bWdSdG1DaEZLWTVHbWFQa1Jub2p1WTkzcm10Ykxv?=
 =?utf-8?B?Qm1JR3krUEI3TG1xenZvcTZ4WUVCTDRxMEhiUU1kdkRtNkhCWWxrcUtUckJ3?=
 =?utf-8?B?YUwyVDh0S09oK2ZHN2JrN0Y3OGpwSUVBNy8xSWZBemZnQjBhL0pXampoTGl3?=
 =?utf-8?B?WDFmeE1qRmNobUhxMHhWT29OSHYyK0dEc2xpT3VUU25kWHhETVREL2p0OVRZ?=
 =?utf-8?B?Z0RHNElnT2hUZlFwcHlpYTZEMW5OS0MvNHVGMTZkTWFobDdQZzd2ZFMwVW5s?=
 =?utf-8?B?RWFISVFtRU9sRTF5dlFrbWNZdGJRVnRTdGRDVkdqODhLVGJOOGVZdmhQbHF0?=
 =?utf-8?B?QTdvUStoVWxoSTdCczRXcklTVEJzbnpZTUx1bG5QOEJiVkZhSjUxbXNBR0U5?=
 =?utf-8?B?eGt2NVdhTzNZYlo1L01oeUlTbUhLM1FsSE1LM2pwclN1SVovWmg3L0tSZzdJ?=
 =?utf-8?B?dWxvNGdxNitiUW15N1Nta0JXall1aGViYW5UbHNINTh5bXVjeGhJc2Y4QmJ1?=
 =?utf-8?B?anowQlFjYnFWQmszY0ROV29BS0ZNMHJiRWxkUEV5Z3c1SlNxYS8wUXovbEdK?=
 =?utf-8?B?Q1Aza0ZGbzZmSE9ZeFRYenVDQ3VtRXZYdTVsNlc5YkpIU3R6NzZkRGFrS1dJ?=
 =?utf-8?B?anZxMmtCZkVFUjhsSE5lY3o4QkFaSUliQVA0R2hyWUcwZkRscXc2c0xRazFj?=
 =?utf-8?B?OWNDN0JmcXVOWVdObDc3NFNaQUkxY2NiNUl1bmJyZ3pQZU5ZVzZOV0loWG1Z?=
 =?utf-8?B?bDJ6Y0lEN0FocEl0dmZNVm1POFlYb1hTY3NKL3pnUUJnSG9DdGVSeS9iQlFE?=
 =?utf-8?B?QnhCbUVjNzlXaVUwUWpHN2o5SjUzWGdVUlZJR0ZqVnR3WG5CTWMvMndEYUcz?=
 =?utf-8?B?OXFJemIvQ3lBaXF0UUFkZUY1SzMxd0xDcUdNQUZSZmdGaklTSUY0T1Z3UWh1?=
 =?utf-8?B?QjhEejllZTEzdThBV2oyZk44RjRHeGJBVktZT3RGQkY5TmNMVDUxZjRIUG1w?=
 =?utf-8?B?akYyWW5zaktsVnlXSEF1RXBndE1Yb0had2c4dUhjRVRSYWNrOEMyeUVqd050?=
 =?utf-8?B?ZDBWOEtDZ0s0b1hwZ2daQmJvWWdLanpIdlptc3VQMW9URnYxdC9lWHVpNjZt?=
 =?utf-8?B?TXE2eGtCQTEvbVZ5ZktOTXFTSGdqVlVpSlNTVE15SEFBelg3V0VoTmZrWFVM?=
 =?utf-8?B?T1FsYXNBbGpIdGlKT2RQTDhEalM1SzB6V2o2Q3l5YjB5V1FiTHR1Y2MrTnB6?=
 =?utf-8?B?VThxeGIzOXZOUUh4OTU3ZUExSnk2eXVBN2xTbWZYT05HUmJEdE12ci9hVXpo?=
 =?utf-8?B?cTVsdWJrUnQ1Q1FOSUVkcHU4SENKTTQwQ1B4MVoxdXBsZ0Nmc3FZMlNubnhD?=
 =?utf-8?B?ajBFTEhxczJZdXlPTkJoZzRKL0VoLzhNNlZkMDQvSFN0Vk0yOVNtb0JtYmZS?=
 =?utf-8?B?V2k2K0x1N2ZFYWRHdzh3T1RDY0UyU3BLaGJzWGZtY2RuMWx6S1NUQm5LeU1j?=
 =?utf-8?B?Q00xK2cwQkxzVmpkZnorM002YjY4aThrWjNGeWVOWlhHeWhHQTl2RkJ5VjFF?=
 =?utf-8?B?dEZXVTdISTErdG1od2ZmZnJJbXVKRGdZM2pRWXpLd3lqUWkxZ0hyUUdwcjBQ?=
 =?utf-8?B?YnpGZyt1MDZ5RDZUSEdzWlV4RUcvQ05GcGw5SzhOYjNDQ0dkUmZKK3JwOG5v?=
 =?utf-8?Q?buEqTBk9yQwQBw1mXNAmay2Gr?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9588ce74-dd37-4783-42f0-08dc4473224e
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2024 22:07:26.9035
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2mcApI6P4u+hg16xpspfSKE+pPWfKeyZc6ua4rElXT2WQZCHyAGxyJeTCPppLVqLSZLspkCUe+wMgyGJnyaH4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7722
X-OriginatorOrg: intel.com



On 15/03/2024 10:29 am, Rick Edgecombe wrote:
> Fix KVM_SET_MEMORY_ATTRIBUTES to not overflow lpage_info array and trigger
> KASAN splat, as seen in the private_mem_conversions_test selftest.
> 
> When memory attributes are set on a GFN range, that range will have
> specific properties applied to the TDP. A huge page cannot be used when
> the attributes are inconsistent, so they are disabled for those the
> specific huge pages. For internal KVM reasons, huge pages are also not
> allowed to span adjacent memslots regardless of whether the backing memory
> could be mapped as huge.
> 
> What GFNs support which huge page sizes is tracked by an array of arrays
> 'lpage_info' on the memslot, of ‘kvm_lpage_info’ structs. Each index of
> lpage_info contains a vmalloc allocated array of these for a specific
> supported page size. The kvm_lpage_info denotes whether a specific huge
> page (GFN and page size) on the memslot is supported. These arrays include
> indices for unaligned head and tail huge pages.
> 
> Preventing huge pages from spanning adjacent memslot is covered by
> incrementing the count in head and tail kvm_lpage_info when the memslot is
> allocated, but disallowing huge pages for memory that has mixed attributes
> has to be done in a more complicated way. During the
> KVM_SET_MEMORY_ATTRIBUTES ioctl KVM updates lpage_info for each memslot in
> the range that has mismatched attributes. KVM does this a memslot at a
> time, and marks a special bit, KVM_LPAGE_MIXED_FLAG, in the kvm_lpage_info
> for any huge page. This bit is essentially a permanently elevated count.
> So huge pages will not be mapped for the GFN at that page size if the
> count is elevated in either case: a huge head or tail page unaligned to
> the memslot or if KVM_LPAGE_MIXED_FLAG is set because it has mixed
> attributes.
> 
> To determine whether a huge page has consistent attributes, the
> KVM_SET_MEMORY_ATTRIBUTES operation checks an xarray to make sure it
> consistently has the incoming attribute. Since level - 1 huge pages are
> aligned to level huge pages, it employs an optimization. As long as the
> level - 1 huge pages are checked first, it can just check these and assume
> that if each level - 1 huge page contained within the level sized huge
> page is not mixed, then the level size huge page is not mixed. This
> optimization happens in the helper hugepage_has_attrs().
> 
> Unfortunately, although the kvm_lpage_info array representing page size
> 'level' will contain an entry for an unaligned tail page of size level,
> the array for level - 1  will not contain an entry for each GFN at page
> size level. The level - 1 array will only contain an index for any
> unaligned region covered by level - 1 huge page size, which can be a
> smaller region. So this causes the optimization to overflow the level - 1
> kvm_lpage_info and perform a vmalloc out of bounds read.
> 
> In some cases of head and tail pages where an overflow could happen,
> callers skip the operation completely as KVM_LPAGE_MIXED_FLAG is not
> required to prevent huge pages as discussed earlier. But for memslots that
> are smaller than the 1GB page size, it does call hugepage_has_attrs(). In
> this case the huge page is both the head and tail page. The issue can be
> observed simply by compiling the kernel with CONFIG_KASAN_VMALLOC and
> running the selftest “private_mem_conversions_test”, which produces the
> output like the following:
> 
> BUG: KASAN: vmalloc-out-of-bounds in hugepage_has_attrs+0x7e/0x110
> Read of size 4 at addr ffffc900000a3008 by task private_mem_con/169
> Call Trace:
>    dump_stack_lvl
>    print_report
>    ? __virt_addr_valid
>    ? hugepage_has_attrs
>    ? hugepage_has_attrs
>    kasan_report
>    ? hugepage_has_attrs
>    hugepage_has_attrs
>    kvm_arch_post_set_memory_attributes
>    kvm_vm_ioctl
> 
> It is a little ambiguous whether the unaligned head page (in the bug case
> also the tail page) should be expected to have KVM_LPAGE_MIXED_FLAG set.
> It is not functionally required, as the unaligned head/tail pages will
> already have their kvm_lpage_info count incremented. The comments imply
> not setting it on unaligned head pages is intentional, so fix the callers
> to skip trying to set KVM_LPAGE_MIXED_FLAG in this case, and in doing so
> not call hugepage_has_attrs().
> 
> Cc: stable@vger.kernel.org
> Fixes: 90b4fe17981e ("KVM: x86: Disallow hugepages when memory attributes are mixed")
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>

Reviewed-by: Kai Huang <kai.huang@intel.com>

> ---
> v2:
>   - Drop function rename (Sean)
>   - Clarify in commit log that this is only head pages that are also tail
>     pages (Sean)
> ---
>   arch/x86/kvm/mmu/mmu.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 0544700ca50b..42e7de604bb6 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -7388,7 +7388,8 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
>   			 * by the memslot, KVM can't use a hugepage due to the
>   			 * misaligned address regardless of memory attributes.
>   			 */
> -			if (gfn >= slot->base_gfn) {
> +			if (gfn >= slot->base_gfn &&
> +			    gfn + nr_pages <= slot->base_gfn + slot->npages) {
>   				if (hugepage_has_attrs(kvm, slot, gfn, level, attrs))
>   					hugepage_clear_mixed(slot, gfn, level);
>   				else

