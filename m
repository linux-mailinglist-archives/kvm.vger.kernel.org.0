Return-Path: <kvm+bounces-11622-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 52343878CF7
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 03:21:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 71D421C20E7D
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 02:21:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1A0279C8;
	Tue, 12 Mar 2024 02:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MD4NUM1Q"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F293D6FB2;
	Tue, 12 Mar 2024 02:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710210092; cv=fail; b=WHTwvYY9fmdJHZg0eHxU2WMbrJwaZ03c7GPE9QMmcIT0NxAe/UcON5lFndoBIYgCwgGpD12ZquygWNkRuRueQNuk3Nni4Fo733WXwLh1JsGybHgqvyVj2KoLNNx8E0SbiaTm2N1Gr5zfEv2opdAE4xluvHxgATI1K1i8bJgd0yM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710210092; c=relaxed/simple;
	bh=rZKgg/EzfO6KS+2Frow/7fGQ1K/t68B7hFjT8rdnXjA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jcaO+iwgKjFDToxOeyNzkm+gk7J8gqRz0WgmYZRzJuOzmZP/fxoFiZ7n3ncpvmDGldvXaBBK+qwLPOSKarP/UK+hUdQJY5PYEpGkIMRUmZTQ6HVJSIBOGzD3GpyQev1dXargbBQGg/4JK+WA/CcwQiKSICBxsimRMqCmO4bTDmY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MD4NUM1Q; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710210090; x=1741746090;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rZKgg/EzfO6KS+2Frow/7fGQ1K/t68B7hFjT8rdnXjA=;
  b=MD4NUM1QB5mwYcO4proGu6S7f4acKFvdYakXh8NuyZPBbBgJXxZ/+K90
   InsiVQTdy7B+b+3t9UOAbv0REeWWrOuu6D11weK3/oDmye+aIYvA9tOce
   hAoEOVzBsfzewwvBcpk5LFQXoTWtZqwDOCxLErJhbOni1C52qiS0r8g2t
   6Oe+5/89UmjLFR3VP4e+N+UsDN/X7qTuqGmVNUTLB1TAQWacdYr0yQGcp
   DXFs0AS6N9Bz4YTBPwAQV3t+wGv0JYxBum+pzqZ7WbNYFta6oSbnL83ZT
   Z+E06Hw5aDb38kbNv/iz6cF3HKFQznPjVx5iuFaj9XlWPl1kGOPKbDSxk
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11010"; a="4756370"
X-IronPort-AV: E=Sophos;i="6.07,118,1708416000"; 
   d="scan'208";a="4756370"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 19:21:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,118,1708416000"; 
   d="scan'208";a="15981566"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Mar 2024 19:21:29 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 11 Mar 2024 19:21:28 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 11 Mar 2024 19:21:28 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 11 Mar 2024 19:21:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LL8sIeLrheXjHp8iWIAaPGstpIvz/z6vAexeacswHTLUviqF1cmV5YXLuApuJMxtRiRwlIPJL8hcMk3epljK/shjLIdNTChoo2DQ9T5/8NjdfAcVrAJdKXCNXzFDC6z8krINdL4VBPMOxCe89uNSOM2oH9zV4DFVqsUn7BZI6n0msGfV9Q/AaTSWd8c515a6bSY070hBWhsQfNe+aU00RgQLqmiUdf6oNiAfmlZVSIGAHDu/eq/dFlijBrzMbJ4ievjsjiq3++9TMZVBeQ8468AqtmxibM0OZh6YFD51AQjdhuRliqlzd0Woot/WJ5gtpUydOdW15AsSUTPgXBuFPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oQ64RizL75lqzdEfyoP427KLicbloMm9ZZmmKzlfi3U=;
 b=NZtUM/4wXpXfXbs7jxyp/uTO5QfbFZdv6FRVs6yNqT9BHGu5EG6DO/BhncFFGUG3+b//kOhdF/404hhVb0KX/aSEEpf5x8Qv5OiV6FjKaELazbsnc/z3G2dD3r1zjJ7meWfOz1q/4tWeIDIEDpViqEkEGUBCef48lWz/mKbAegRgnjlDket1pACshhkRLIE29osjEHKnsTWIW0jBBAIyO1CjmOSsQyGoHwZG8yIlUpNkmv/RQUHh+uvD0EetmRaHUIrBDyoh4z1wg4uEWsaOHEWdtk2lPPmqJcP8eSl2WcpUBQAPAgFbXBFBX/jPsOhdQ+11b7DMQeDT8fiH+SINLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4820.namprd11.prod.outlook.com (2603:10b6:303:6f::8)
 by CH0PR11MB5233.namprd11.prod.outlook.com (2603:10b6:610:e0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.15; Tue, 12 Mar
 2024 02:21:26 +0000
Received: from CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::65ce:9835:2c02:b61b]) by CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::65ce:9835:2c02:b61b%7]) with mapi id 15.20.7386.016; Tue, 12 Mar 2024
 02:21:25 +0000
Message-ID: <c7be9930-26e7-454c-87f6-c8cdf2fce481@intel.com>
Date: Tue, 12 Mar 2024 10:21:28 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 022/130] KVM: x86/vmx: Refactor KVM VMX module
 init/exit functions
Content-Language: en-US
To: Isaku Yamahata <isaku.yamahata@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, Kai Huang <kai.huang@intel.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>,
	<isaku.yamahata@linux.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <11d5ae6a1102a50b0e773fc7efd949bb0bd2b776.1708933498.git.isaku.yamahata@intel.com>
 <aa5359e5-46a3-48d0-b4af-3b812b4c93ae@intel.com>
 <20240312021524.GG935089@ls.amr.corp.intel.com>
From: Yin Fengwei <fengwei.yin@intel.com>
In-Reply-To: <20240312021524.GG935089@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0049.apcprd02.prod.outlook.com
 (2603:1096:4:196::7) To CO1PR11MB4820.namprd11.prod.outlook.com
 (2603:10b6:303:6f::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4820:EE_|CH0PR11MB5233:EE_
X-MS-Office365-Filtering-Correlation-Id: cc98b6e7-d243-4882-6d13-08dc423b1e32
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9rMUfC1XoPHUTL2548j80kXWEejWFrBEOxAZBqllxKp4MbyAk8Dz6b82Cpu2wXqLU+7JbLNHYNa4WNoGFAf9OhMidJfFONJ4TByBqSzpOEiku+JzEfzYEGbo37HGx2RW6ZrZCGVPeBWl7vNvrP0RpQtV0/7YnuyezD/KruJiRrWi3G/8eck8syytzAbnr0+Nb/ayLOo4xfwp8TU/K7Vr3b4VLbsSOgi3puwzKlVm9vgXhMW+E8smCH66Y8NWZvSaFwk4LIGypxLPFtQzAgiRj2pm8SJ4lgZXgN68ogFeJNtvbN+C45MvxeE+hhpCWVLa3J9QNzIwaDQEG3ZzKX76keJmrenVHIfKXDhfmWZGGRwsWHl9uwH3djMpSFxj9fUMVp1DuBHnyTD4lw/EJHPXZCcZ0o6jrT8Cq5cHZDZjGGDDmCf7aGIpPEAh9oFf86Jeb9aXJI0Rqv/+Cn3yvirA/LJAH+9z4FYGFgD7/PTBR5eEHP1A7PLkFdDVrqOoZqFpbBOpMSd/77aaoJHpUwcG9loHYPxWIof4OKhzf4viWzE3g08zujjbSvtVF8olHqVnVpdPhdt8L3oZgLZSJ9SHLqbK10IiiFKrghRL4mUMQfZCX2vUgGWDxS4sGtuMTXQT4aLApJRdDbH6XZhWBywVbk16k6wkgc/jNNA5Oz6UPuM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4820.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dDJnR2M1SExOUnZEemk1U1UxSFVCYnRURHB3SjJZL3VqeDduNXJzNW1hMThw?=
 =?utf-8?B?WXQzUy9mYUgxdXdOWGM4WTNCUTUzN0QwV04yb3YzdmNUZkVzenNUSHNUUVE2?=
 =?utf-8?B?ZndIbzhtVXh2aTg1eW9SU0RNSk52U3JPbUhSamxBZC9iWHdTaGZ1SWNObVFo?=
 =?utf-8?B?OXJQMll3VDdBS3puQXZXQUw4SCtjL1FzTDE1T25rNWFoKytzd09SNWRkSHZI?=
 =?utf-8?B?NWR0b2xCVkV4TytGOERzZnJKaVByQ08ySDlqVDBKSWVLTlB0VFlrT0k1ZStt?=
 =?utf-8?B?N0FZMmFaemRCSjNFeVEvMjMyY0ROMlFlZkNMcVcxb3lPeE1XSGRjOGRRNkNT?=
 =?utf-8?B?MUVFelJIRkR6bUVXTlhqY3lyN2VibHJWenQ3K1JqNkxUTC9xMWZHdS91emNV?=
 =?utf-8?B?M3dQV1RYZHJNSE5MR2FacCtvRW5zeWhsa0wrVjQ0SGRRVGZCQmRFS0lrK0Z0?=
 =?utf-8?B?d3JJZnhwaU02SDh3bFBWQUxlS0RJY2hzc2JBdzU0L1JETFN1bk1HTGFQQlNp?=
 =?utf-8?B?c2s0VWRISHVTQU9QWjNNb05Mc1NlZVRFWFlWd20vZXhDb3NuNndiYU02K015?=
 =?utf-8?B?bzZIZ3Q0djRVNk5jaTZ6ZFIwNkRUSWNveUVyUHl4Um81dG5ldGh0NWpqVXZp?=
 =?utf-8?B?bERCaEx5d1FQMXR6UlhHWFVtQkRqOG1tK1RjdnNNdVJSdHpXTG1BN2cxZktI?=
 =?utf-8?B?VGtUZkJHcWduVWJlaXNCbjR4TG5UNGtXZGRKbU9jZW5zc0NhQUFJdUh6VUJB?=
 =?utf-8?B?a1c2Tk1FZDFVMGd4UXBqTFNpUEkrdzAvMEY4YThOd21oajNBYm5keUt2a29Z?=
 =?utf-8?B?YjRQRWhLc2xZUko5cDRKOGxLUU1GWmtKakFqSEIrMzh1VjhkeExWTnZrdW1q?=
 =?utf-8?B?QVJub0s0U3R4RDdLS0hpbkdTYTd1MU5venNjaEs2Z1J1cTFmeVcwbk0vMXRk?=
 =?utf-8?B?T0dTcEkrenJhdnpQZWxtQmxQcklBL0t6TW5acjRNMW0rMHlYQ3NPVjY4Yk9N?=
 =?utf-8?B?THAxeFF3dytkcUVuRVdZZWdJek51U1czMDRZV040a0hsSmZ0ZG05S0hYMEg4?=
 =?utf-8?B?UEVRbTRieHMxbWRjYVNWOW0zMVZwL25peVE4cVgwN0M1QStraTljdlRLc3k4?=
 =?utf-8?B?UGhQaXZQRVE3NVFoNTZOeTJSMlprVjZnVm5qcW44c2YxUUhzbmNpWXZsa29j?=
 =?utf-8?B?R2VrZXh1Q3RtUE9POXAzMHhtdUdSdTUycjJPejRiZ08wY294NFNlZ1I0KzY2?=
 =?utf-8?B?OHQrTHhoUVZLTWVkYXhRcGsydlp3YjlwdzdlcVZYbXVrRW9Dc1JoWURtM2wz?=
 =?utf-8?B?RTlkN1o3NlZUTHRaWllCeGY5TlJOYzhMeDlESWpyem1OMnBFUGdzVXZ6UVlD?=
 =?utf-8?B?dXZlcjlKZHFJc0pwTTdiSVpKSGNuWVh0Vy9uY3hwbEVWb1BkRld4NkVWZVVi?=
 =?utf-8?B?SUNNVUtmVzkrTk5EeHZEQ0Q4bERrQ050OWgwQUIvZUNFcDl6dFBRalVjWEZk?=
 =?utf-8?B?Tklua2Q3b1dJbXllR01XZXU1WDQzaEJZYUJMazU0QkdqdWZIWFRaQm1YV1ZM?=
 =?utf-8?B?MlFJZEx0eFZ6d2VLQ1p1MzRaWFhyemJVcTlEZUEzVWhHb0FvQnowcHFYZ3NB?=
 =?utf-8?B?UU54NmJoRWhxRHlJRWxQMHFuR1A3d0xmdThoSjgxWWJXRDAvU2lKRWN5aitD?=
 =?utf-8?B?V1VPY3V4cDN1cmVmNm52d0RpWE4yK09udHZ5Wjgra2Z1d1VXNFdxOTZGczJH?=
 =?utf-8?B?YnJtcmRGTjV4dEx3SWs2dzRjVDVZSzUrYmYvOTRlS1Facm5oa1VFdlBjaFM3?=
 =?utf-8?B?T25KaHBkZ0JzUGRsc2s1SWZjUGI4bEsxd0l1cjQvZmNuSEVHdS9MUXpwcVBa?=
 =?utf-8?B?bkVzMzVJUElJYUc5OUxFUWY1UjNYelZOYXhZOVBlUXJ0Ti95Yjh1cHRZcEJU?=
 =?utf-8?B?VnU2dFp4MFl5Lyt2NzduMnNmNG12azhQcnhYdEVCVTJZUUJlMy9RcFdxSlhK?=
 =?utf-8?B?T1VCRWI3MW5pL3VFcTRoMU1zeFhORHhmR1U3UlBycENRMlBIbVBISGZHZkU5?=
 =?utf-8?B?eXFNSFU5Q29pSmdmV1d0RFEvRTVBZkJRNlMxWjRTQlIwQXVEeWFqOFJXRXEy?=
 =?utf-8?B?NFlIWVU4YXdtSUtDdFRsVCtyWkYzR0ZTUW1iOWJ5UGFkTnlrLzlxK3Y0eEZy?=
 =?utf-8?B?MWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cc98b6e7-d243-4882-6d13-08dc423b1e32
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4820.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2024 02:21:25.8297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QNz3A3vBbJupSw1mNU5kqvlpRsUtGvGMdTycAlcRg5KvUjSvkZWuCWD72EZ3h2UKq4HEaspy0s0Zi36YCqnIGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5233
X-OriginatorOrg: intel.com



On 3/12/24 10:15, Isaku Yamahata wrote:
>>> -
>>> -	__vmx_exit();
>>> -}
>>> -module_exit(vmx_exit);
>>> -
>>> -static int __init vmx_init(void)
>>> +int __init vmx_init(void)
>>>   {
>>>   	int r, cpu;
>>> -	if (!kvm_is_vmx_supported())
>>> -		return -EOPNOTSUPP;
>>> -
>>> -	/*
>>> -	 * Note, hv_init_evmcs() touches only VMX knobs, i.e. there's nothing
>>> -	 * to unwind if a later step fails.
>>> -	 */
>>> -	hv_init_evmcs();
>>> -
>>> -	/* vmx_hardware_disable() accesses loaded_vmcss_on_cpu. */
>>> -	for_each_possible_cpu(cpu)
>>> -		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
>>> -
>>> -	r = kvm_x86_vendor_init(&vt_init_ops);
>>> -	if (r)
>>> -		return r;
>>> -
>>>   	/*
>>>   	 * Must be called after common x86 init so enable_ept is properly set
>>>   	 * up. Hand the parameter mitigation value in which was stored in
>> I am wondering whether the first sentence of above comment should be
>> moved to vt_init()? So vt_init() has whole information about the init
>> sequence.
> If we do so, we should move the call of "vmx_setup_l1d_flush() to vt_init().
> I hesitated to remove static of vmx_setup_l1d_flush().
I meant this one:
 "Must be called after common x86 init so enable_ept is properly set up"

Not necessary to move vmx_setup_l1d_flush().

Regards
Yin, Fengwei


> -- 

