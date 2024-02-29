Return-Path: <kvm+bounces-10555-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EFA6986D6A2
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 23:12:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 74CE61F24515
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 22:12:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5228F74BEC;
	Thu, 29 Feb 2024 22:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P1AMk4gL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71BC216FF5F;
	Thu, 29 Feb 2024 22:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709244735; cv=fail; b=gihiQtIsbcdyuZdgJWC5EpyxfowQWB7JblgOytTqi/4rTj1/wD+DkAk4gF48VEIQqm4SirTXRB6hxY+VCDFlBf0ee8pipP/QZ4iqxDIt06DaOeuLYv62MPeVqySVLC5nSMKRb/XOO/LcbDuvJD+CZ5nKsxpGhv6+v/+YNHyybxc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709244735; c=relaxed/simple;
	bh=tAJhvDuagGoBsIwyxmUGa+PeBSVnYbOnjI1a9ESuG1Y=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SCFKXvZJT376DRiPqaFPS4/tkf+VVIC1S5AI6C4AhFWZDgqcZI8AdK2OzxXEF1QOPQ8yYSqboYFSiOvmZI4BYhPXXGn/RuPjlmr8DorZZHRIkawDQuxaJ1xyPiXEK9JZZ0NOFVcHqRZLOgu80PtrDvowfrs9cLbJMJBMajuel4A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P1AMk4gL; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709244731; x=1740780731;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tAJhvDuagGoBsIwyxmUGa+PeBSVnYbOnjI1a9ESuG1Y=;
  b=P1AMk4gL+eG0nKbO22E2IZIz0DO3TjOXpCdspryS9JkkmWBMOCZ8s4Gr
   YZ2yZNDxAiz+Ic9ZK0j7OsdOqwGWu4iMOOS1U3A7lSYHkju/iia/rl6rq
   EL5TKUwvH0ZDog39hIJ6cOEkXS9ov6W15VUGCnOs8dPC1VXmzyYy9Aod8
   n1TWGB4d3Z/AxTjHVPKisvwHq88e4nh5ZgKzaTOZo2Q+KNqNcQ9LRbeFt
   L9TvlZZH/lFos2w7Bf1ewLJAAJ9Xqbr9H/QVMGQZJu0yQyTuYd3f0woVf
   8zpxwYg5Hcgxf/xzbAT69s4y8rR8kx/jpmJj4KJ2WpfZBAD5Wst+f8Ts4
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10999"; a="3622257"
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="3622257"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 14:12:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="31164316"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Feb 2024 14:12:09 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 29 Feb 2024 14:12:08 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 29 Feb 2024 14:12:08 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 29 Feb 2024 14:12:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WfV/zF5LzFUT5KuzbjWrVkZD6C5N3bZaiT1B4SBx5YkF4gcchocc5tTJIgLQw5rPFTqk65uMFOTU+ALeTEhlI/aqM7GPh89TUqwlDmX5OHV3uvySvhLdaMWLksq+6YEWdvtXeBvsj3KfgWhJOcSRbIynkrJ79H76/McXJMquqw/Eih4OJHkIiUSgYb+Mct1K7o5J/Szl9jwQ0G0F87JSSbQ3/VEq7/jgACYpulIQPKDBp0lR3Kd7EEkL81ZBiB/12qghA5lkuYv2mS6uiagqoXP8DBCh4j0OQTG71fFK7kBlUs/iKdDrs7y/rUq9K4AtZYm6guFRB/jUNVymhYuVZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lv/UGnBL98Y6+y9FozQ02nJi7fl8BxctB1IM7SAi3A8=;
 b=gPtUPXCHRjq3U3cfFLV/tNe4knzUKBcL4v+UTVyn6zLOyu5b67TJFcqzIYfa7Wza/bh+NE/jAtwv9c/cIQpWhCSW3gie2GeHn/Ifjbr4XbU5I1WJyewcnqI/wq9A97Z4DbBaxRygIduNY12eQdEA8Yrz7znq3YMlU1/S7FfsB5rH65f2b4AK6rqyQOQThW4bjBwq9/K/BRgD2tUOwufrUbptu0lGiUllY+woj/2RDIMMW6kuc7wKZ08jXl5CORk4a80OKJyruo+6czu4oZpZId5JTYphSY3VTnWSxzuoLp++uGE99U1MJDWas+j2JQyfCgWHI74xrUCYgX3gBOfbPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BN9PR11MB5243.namprd11.prod.outlook.com (2603:10b6:408:134::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.25; Thu, 29 Feb
 2024 22:12:07 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7339.024; Thu, 29 Feb 2024
 22:12:06 +0000
Message-ID: <3779953f-4d07-41d7-b450-bbc2afffaa43@intel.com>
Date: Fri, 1 Mar 2024 11:11:57 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/16] KVM: x86/mmu: WARN if upper 32 bits of legacy #PF
 error code are non-zero
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Yan Zhao
	<yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, "Michael
 Roth" <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, Chao
 Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, David
 Matlack <dmatlack@google.com>
References: <20240228024147.41573-1-seanjc@google.com>
 <20240228024147.41573-7-seanjc@google.com>
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240228024147.41573-7-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0098.namprd03.prod.outlook.com
 (2603:10b6:303:b7::13) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|BN9PR11MB5243:EE_
X-MS-Office365-Filtering-Correlation-Id: a2125dfc-3628-41ca-517e-08dc39737762
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oK8b+1JlOzzDM/zG3Sm9irkrFYqQ92+JUWrIYxKHNFRPO7qjp0XCEjzPwacm+SvpLnzkK7/ZakMf3spvissdi+IbmoX24mdLJIlO/qW+Hp0xr1jtTjkNBvehYLXtkF+Rv5yUJIVuktXovtily9JSWqv+lnqKyvRQJUMnZnZAzqL3gyyFJt/KSDKjTOOfGV6twESAuWRtFFevNkW9vq+KdUIBMqC3mpXkSmnn2MctOmi+xSGAtVOXpquG2N4hrt4s47wC2hFdvzlAdimgn/aIQnCpq0BS2iZm621VAUck9Kmn0zf1rBu8nfR3KxYVDkgk5hEHomG01j5nnLTmdIAngRkPTLlPfKOWNdRpVA4oZo8yjHk2mwCpjptIxkySglLv4wh31CJfSphY8Vz+qNZRINJWHxe3dqjAzNEE3ypT4wmKFpvjeeF3dB706RYRbKsbmbfgSY7LWLMmIokoiKtawBnwbjsXVHraTXCQmKfFmU2brJfauFkvTLf7LQs4oyqUvPQYjew4CdmOmcTAzqZKC+8tXoDaK9SzoHwodS+LqbHxCjplVzhtkvbyCuqSNlFY+oe15OphPu985EGIi2d6AHHdvHHz+XoCqCiW/onxhkLb3f6Pyb47saxMLJXZJucD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QVl6Z0RSZFNmakxKa0QyK3NtTldUS1o0cDMxRGZKTzM3UGYrTlUvMnUyZ1o2?=
 =?utf-8?B?U3A3MU5ieFoyTHk1YkRvSWhlOWFsQmMydjZNM0sxbzJhbUhtT2hDdE9GTUlk?=
 =?utf-8?B?UENkMEpRVnl3aVVaTGxXeW8zRU5PeitOMnZobmRMTHNsaWUvZDVsR2ZYSjZO?=
 =?utf-8?B?UGpIcHVNb2gzeENsOEg5VW9zM0g1d3Z5d29IcTVKUHlpSDR5WkgxeXZGcVNM?=
 =?utf-8?B?MHJ4V0YxUlk3d0dZWjJZU3VHZWxLVTJFN2ZsWVZpL2J1ekRXMjR1MWl6ZHpO?=
 =?utf-8?B?OTd0T2laOW42QXV2bWdkaWdTbXV3bUJKZEs3M0psSlppbW9makU3QWhncUZP?=
 =?utf-8?B?bDNNQ3lJMFNnQ2xLd1VJanRGZisyUDFqSG1Qam9rcnpsdWR5QkE1M1YvVnFN?=
 =?utf-8?B?aHBsMDFVckZZMkd2WGw4cksvWFg5T28vNUdkY0pTQm9UT29Fd3p2TnZYejNy?=
 =?utf-8?B?WGpDM1Jjb1UyN1Y3MEZmWFM4OXE3OHBxS3J5VmhHQnVvSmdoTU8zK1hoTDAx?=
 =?utf-8?B?T09EeUl5QmJXYkVxbVluMmxXU3BoOHVEU04vSzg0Z1c2cEMvZ3VMVWFOd3Q5?=
 =?utf-8?B?YlBQS3ZyTTF4ZHVyTFppMTZ3YXJkY2l1bXBZSUFpWmZ4K0grL05uQWRGNE9T?=
 =?utf-8?B?RndGTlE5eHVWMlhvU3BtYkZWdjZSQ3ZQME5vMnAzUnM3d3RvL3kwWjFBOTRR?=
 =?utf-8?B?cUFRcjlKL2w5QkM0L3QwTnVPQXpPeW10U09SbUx1dE9pWXJTb1MxT3VKVUJU?=
 =?utf-8?B?dDJqSERMTjJ6NytrWEQwNW8vcDhob0hDNHo1MFZCaWM4b3lzRlZpNGpLMjM5?=
 =?utf-8?B?c29FaXc3WEpUWE9EMzBIejFpTU5xZmR2ekgrS2M4Z0NHcWhDbng1d1hnbmk4?=
 =?utf-8?B?K2kxcXBlcnJYOUphd0hJS3pmSzdhVGZGeUxMOFBhOGV3SzNpOVN4bkR4dHBV?=
 =?utf-8?B?ZUFQQ2JNdkZvZGRSeE91T3hqS1NmMkZBWUxSMSswb2ErcVhObS95eGVJbHVO?=
 =?utf-8?B?dmNmOXNNcFQ1M1o1NkNYMU5sV3pzQjNEeTNVVkFxR1J6NG4wLzMrZVZ2QWFl?=
 =?utf-8?B?bmk3eG1lR2NQU0RLMThIMVFtY0ZiQXF2ak1EVmJ5djRCVjFoc0RMT3I2aXAr?=
 =?utf-8?B?ZGJPRERYaU1QYXovL21zWG1VRjRUL2JMYlZ6ck9IUi96UmFWQVd0NUdOYjND?=
 =?utf-8?B?S3hkbVRSQi9OcS9CQzhEeXpQZlJiZ1RNazczVno0UDV5Q0JYeU02UGpxeUl4?=
 =?utf-8?B?RlBFREVyeXBSczBSSkkzNW5jK09XNDQ5ZXB5Ny9sbkVmdTFuekVuaU1xR2Nr?=
 =?utf-8?B?RjUvN0NaQ2plZTBvUEZ1Z2ZoSi9wRWRsMVJDb2tRVlhWb2dlankxZUFNMTRH?=
 =?utf-8?B?VXdpWDJ0dVhJaWNVU3lqZlhISjNER2syNE1weHhZTnJTd1N6dTdwdm80eHNS?=
 =?utf-8?B?NTY1eTdsNFllZzd6dkRYNXpZTlplaXRlYUtzTjZMdjlsdjJPMWZEVTJIV0RX?=
 =?utf-8?B?QWFGZEZiT3h2UWRQRUZZQXJnKzFFSEdXUkpwZ05pSVNkc2E3eW16c01uNlk5?=
 =?utf-8?B?RTI1OG1udThFYzlyMGY2Y2F6a0U4dzU1MVNnRk5MM29JTGFhVFRBZVJqRWs2?=
 =?utf-8?B?KzA1ZnFtTkdLNHNpS0lpUStNbnkwZHFBc0k5T0djRXJGcXFxQkczcXc4cGlj?=
 =?utf-8?B?elpwZVRtMHRsS213dC9rQ2tUeGpPOW5ScDIzTlhPR01zK2o0R201S2lTRUU5?=
 =?utf-8?B?a0V5QjZHdnE3NG8xN0RKNC9UeVY0aGdYYnUybWw3T284MWt6WGQ2MjdTM3ZF?=
 =?utf-8?B?RXFmdTFFVFpJbnNxSXJhVGdVcitqT2Q2ZDA2Rkx3citvdjRVUjNUbzVRdGUw?=
 =?utf-8?B?YnZOK256UWUvQUtpR3NaSFphT0VwSjU2bDRCZDlLaTNtSHZReDZ2NGhqM1FN?=
 =?utf-8?B?UDdZVkN3ZXlwVnBCNmlvY0FsUlFQanNCREVmb3MydjFJekcwcHYrVzNzY2g5?=
 =?utf-8?B?RnVjYkMwVjRtMVlzNzZKeUEzNmdYdVdpOWF0S3E2U0VIenZTZEhYRG5SblNY?=
 =?utf-8?B?UFg4TEpQbjZUSEhHWjJvRTdwUG5ZSzFpUHExVGVJLzFLYXV4NGQzZmk3aHEx?=
 =?utf-8?Q?F9jB6XFXe/7CFvvl/y2NXVSpK?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a2125dfc-3628-41ca-517e-08dc39737762
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Feb 2024 22:12:06.8394
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WQ1UCqC2zQpHk2DyfrBepgpf9cBbjgmAd9sALQBGTOAtuxuvtQLNur3NQfNkDkvuyNVqwTdInIjop/A91CuyOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5243
X-OriginatorOrg: intel.com



On 28/02/2024 3:41 pm, Sean Christopherson wrote:
> WARN if bits 63:32 are non-zero when handling an intercepted legacy #PF,

I found "legacy #PF" is a little bit confusing but I couldn't figure out 
a better name either :-)

> as the error code for #PF is limited to 32 bits (and in practice, 16 bits
> on Intel CPUS).  This behavior is architectural, is part of KVM's ABI
> (see kvm_vcpu_events.error_code), and is explicitly documented as being
> preserved for intecerpted #PF in both the APM:
> 
>    The error code saved in EXITINFO1 is the same as would be pushed onto
>    the stack by a non-intercepted #PF exception in protected mode.
> 
> and even more explicitly in the SDM as VMCS.VM_EXIT_INTR_ERROR_CODE is a
> 32-bit field.
> 
> Simply drop the upper bits of hardware provides garbage, as spurious

"of" -> "if" ?

> information should do no harm (though in all likelihood hardware is buggy
> and the kernel is doomed).
> 
> Handling all upper 32 bits in the #PF path will allow moving the sanity
> check on synthetic checks from kvm_mmu_page_fault() to npf_interception(),
> which in turn will allow deriving PFERR_PRIVATE_ACCESS from AMD's
> PFERR_GUEST_ENC_MASK without running afoul of the sanity check.
> 
> Note, this also why Intel uses bit 15 for SGX (highest bit on Intel CPUs)

"this" -> "this is" ?

> and AMD uses bit 31 for RMP (highest bit on AMD CPUs); using the highest
> bit minimizes the probability of a collision with the "other" vendor,
> without needing to plumb more bits through microcode.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 7807bdcd87e8..5d892bd59c97 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4553,6 +4553,13 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
>   	if (WARN_ON_ONCE(fault_address >> 32))
>   		return -EFAULT;
>   #endif
> +	/*
> +	 * Legacy #PF exception only have a 32-bit error code.  Simply drop the

"have" -> "has" ?

> +	 * upper bits as KVM doesn't use them for #PF (because they are never
> +	 * set), and to ensure there are no collisions with KVM-defined bits.
> +	 */
> +	if (WARN_ON_ONCE(error_code >> 32))
> +		error_code = lower_32_bits(error_code);
>   
>   	vcpu->arch.l1tf_flush_l1d = true;
>   	if (!flags) {
Reviewed-by: Kai Huang <kai.huang@intel.com>

