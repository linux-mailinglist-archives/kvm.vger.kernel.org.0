Return-Path: <kvm+bounces-5515-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CDF8D8229F3
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 10:10:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D06F21C2312E
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 09:10:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD3A2182CA;
	Wed,  3 Jan 2024 09:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UREQhJAo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE344182A9;
	Wed,  3 Jan 2024 09:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704273044; x=1735809044;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fpXElntSOe6zFTMcqdwW03QL2v5uonwPi8BfvCS3e38=;
  b=UREQhJAo1t6JjPR8D71qm8Zc13KR5pFiudjKfg0wlaxs57DBJGAY8m4f
   i7kM/oj2fwOdC4JuejsflGke/QCsruASvkiLKzcrbR4dAdaYMyAQqZdPi
   JrAMMP39bJq/m0EyHgosEPjCLGsRq85mU1AYr9fC9IeUBwNRWlpYNYsac
   7MmQFwl8ZpxO0P3E0OgI98cSot5sJN7AaoWzRn/AkR4/XfLcyyOymfSpQ
   cIMrbGGBMDsFNlisaYqIKqz8TSGjVPygsD9fNguEiWWtnTjkWIoAvmeMS
   xC3YObGyeUf3aETLSJmu8r17iKccJ+4MKRGURvRN/ISnLxRnyVZfe8066
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10941"; a="399755784"
X-IronPort-AV: E=Sophos;i="6.04,327,1695711600"; 
   d="scan'208";a="399755784"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2024 01:10:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10941"; a="953174045"
X-IronPort-AV: E=Sophos;i="6.04,327,1695711600"; 
   d="scan'208";a="953174045"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Jan 2024 01:10:44 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 3 Jan 2024 01:10:43 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 3 Jan 2024 01:10:43 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 3 Jan 2024 01:10:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dzBQYBAVsPfC/SnMVMHTFZltSGAqgvsgHkK9AurG/Yggbu0T5Q04f3ex9XOttQN6I+0CoTTuMoKd/S31wUZ7vYw6/un0vJ1z2M9ItwLgKM9Qda9klscrWIUnEYNV9k1+3HdU3uMfR32KsjNwfDUfaj1oKeyyy+bGP/EP7xUiXXoIVli11ObCRD4OPrPbaVMwwGJ13wBnrhAzarhKmW/6g9yqLivY+jT4895c/5rzrrgoaMzZXm6Wogkr3VRijX6EQnWwkKTQWvMsyGK+YFeXA551HK62ZE6szK6EC9MCY7fsgIYQ6jj5Q9sqbEAa1xxLmG++5OzR9MnqO+gelpQ+3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3frK93o+kthWrOdXaX4QNQl9nqUEKBSIp3WCLriphzs=;
 b=jX7aACBmEr8c7Vk8j9ttItkBVMpi5RZo8KBSAG7SeZBvF2BxIF1gO+9U4j7/9AtzQfvvLJowmUCJhjM/ZDoZlaxnoeq89UgGJz7Br0Z17wia4+GuBTK23czqmXvlndMFHEPCTHpLVr7TYcgS0zLwXarTzcvcAdIYL5nBXpZBMLCCeSzWGwl2f1AIums0jj4G6lW0NWrRMbvA31j9dAu208k0AhAU2ZcKDCCtmlo0cNnYIJYOlLfuuzBlEAR+0LUx3b+WfWA9tMIfXuIkPucM+RMknyTczzSE95mrY1vV0GDm22mWBxoM3f63MkIsuN02WKQIsfQt/Yb+p4smtctceg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by PH7PR11MB7608.namprd11.prod.outlook.com (2603:10b6:510:269::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.25; Wed, 3 Jan
 2024 09:10:36 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::819:818b:9159:3af1]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::819:818b:9159:3af1%3]) with mapi id 15.20.7159.013; Wed, 3 Jan 2024
 09:10:36 +0000
Message-ID: <10c8f734-79a1-478d-8e5e-f81786b6aeec@intel.com>
Date: Wed, 3 Jan 2024 17:10:24 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 04/26] x86/fpu/xstate: Introduce
 XFEATURE_MASK_KERNEL_DYNAMIC xfeature set
Content-Language: en-US
To: Maxim Levitsky <mlevitsk@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<dave.hansen@intel.com>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<peterz@infradead.org>, <chao.gao@intel.com>, <rick.p.edgecombe@intel.com>,
	<john.allen@amd.com>
References: <20231221140239.4349-1-weijiang.yang@intel.com>
 <20231221140239.4349-5-weijiang.yang@intel.com>
 <ff50b8907eb6aa475b4572f6ec03355cb0d3d2a9.camel@redhat.com>
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ff50b8907eb6aa475b4572f6ec03355cb0d3d2a9.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0031.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::11) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|PH7PR11MB7608:EE_
X-MS-Office365-Filtering-Correlation-Id: b86975c8-59c6-46ce-8745-08dc0c3bd896
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rdSC4ks2KjhlkP/ffi0CRwTAHJIdQtHloEGQkiFhPe+Vxt1kG6QtnkMa+oGjjerTkKiBJhGGqLA9thvQllzu7BA4TyBFRqY/8HkFYLdpuHqdbtChIw78Bfqyo+x7Elbx1kknWHL+L56hcHc31vQbfRCtHuInfdT8VLFta+JKOrVOUOBmOLutjetd4pCRPd77MEd0bLd5XD7rnyG7tL9J6D4+Cfb2b4FYxn4uieff+Y3Y5jp0Xx36SLL+J93BCdjrN3EEKo965+dvYGhJsrPoPerjK4dQ/UXbrd67Yw880mg49VwGyylZKJWL4antoka/DIQ1K1F0/k5cmVfqyhSRhPF9B9gmcrZjM7dbRNy8lIs7VOwEqsLmgq4ZzoXYSX5zotK+NqGRd8FafHp0xibPAiAgwwm865gZHQ1XUDurwbJndltykUW9nmY8JRXgdxD2N80zHM8IgXt+35bfvJe6tbS17tlpbb2p7LaZifLjnbBhghbYelj7SeIefhLy3NhYBJQ5sksxTSQX/FyaxurjlOe1+FnSTKeaDv7Hil8/DnQwdmkX1xhLLgL4d3BpmF/lg5ow2yDvEnPExDFODr9hINn73OfZFIbU2O75JDlmJlI4OduRSJtQ/qs5vPff8kZ7FTR3B5PY4Tu92d7bTgSCMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(396003)(136003)(39860400002)(376002)(230922051799003)(451199024)(1800799012)(186009)(64100799003)(26005)(4001150100001)(2616005)(82960400001)(38100700002)(8936002)(8676002)(5660300002)(316002)(2906002)(4326008)(41300700001)(6666004)(6916009)(83380400001)(6486002)(66946007)(6512007)(478600001)(66556008)(6506007)(86362001)(53546011)(66476007)(31696002)(36756003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SDV1QmFCc3ZBa0Y4R3kycHM4eEtpdUdxM1dmbHYyOHl1UVlFVmhIL2liRzZC?=
 =?utf-8?B?Y0JoYmM2dlUzTUZBNnJRdmM4KzNBVlFGOGgxV3FDc1ZzRDRzZ00wQmt0dVI3?=
 =?utf-8?B?cGRFcjRtYTFpTFNIVStyTGY4VkVZOVB3eGo3eGdzNlBDUVArRmVyWGVXWmxQ?=
 =?utf-8?B?SFUwT2JXYWNiY2hhTU9YTXJvOWp2dVBFaG84RkRqdTFENEN1N0dwK1JhOVhl?=
 =?utf-8?B?cEtueHNRUUp3OThSQk0wRTlGT0Z2cEE4dWpuVnlnK054bjcrclpHZW8wdWN5?=
 =?utf-8?B?YkdBNCtKbFVUME01VWxteFpXTjhQRmE2Z3BCeXQwbkI4eGhrMDVXWTQzdTJw?=
 =?utf-8?B?NWJuZFZlZzNtaEhBYWJlaW9vRWhvdUppcHVmSVNsa1hvQkF6d0JVbUtuUy9M?=
 =?utf-8?B?eGpGU3NIaysrQXpZZlorNXh5QlZEOHJDaktYaGx0RzZpWHo4YXdjWFgvV3Uw?=
 =?utf-8?B?SEM1MHl3Z1hYMEFQQ1JiY0VyVGRsTEhQRnQ1LzFEVmtEdVlnUmdQYW1aK1lq?=
 =?utf-8?B?NUkzVXBuYitXRzdKS1N3ZncxZEJvTkJKZVJCeG9PY21wU0tEZlBoVEdSeEw4?=
 =?utf-8?B?bHM1eUtGMEU2T2l3cERVZzV1aU5kaVhlLzEya0t2dm9DaURYbHZ3MnBVQTl6?=
 =?utf-8?B?ck9CRlFqNTBIWjFjdzhPcmVFaFVxREpuRnVzSWI2RkUzLzZtellGM1liMzVU?=
 =?utf-8?B?eUp4Q3l5NE9QbitZTVR0MHpSVTBOQUZlbSszcVNRUElGL3oyWGRJMjNJc0JD?=
 =?utf-8?B?UU1xV2VaejJSekFJNHhXMDkyQ245aU94eG1TREVVZ0JXdHo4bGxwOFZjTmRh?=
 =?utf-8?B?QXZxdXcyTmdRZGJFd0VScUI1Y284UDFUalp2TWtwbnZkN1U2MnpyU1JDeG5Z?=
 =?utf-8?B?dnJXWG5kY1htUjUxMGFCN0VPTXhnWGdvdkkybTJrSG82QXIzVjdGODJEZGxP?=
 =?utf-8?B?SUVSdGx5azVMUmlSTlJ4eUxER3FaNWcvb3owcDl3VklpVmdpbmpoTENDZncw?=
 =?utf-8?B?c3FraEJleHdSUFFIano1NFlrWkw5MDlSdXNYN0hyVzlaNGxKaUdndzBwZmRL?=
 =?utf-8?B?aVpEYVZvQVJ6UHh4R3FpYXBKTFNkaWRHNU1oK3FIMmxDM0F3SWRsOHBsTHRJ?=
 =?utf-8?B?NmlIQkFyY05ZTk0vbmtSN3JtUEdxdDNyNmVyUExoZEJPZmd1b2dkb0s0Tk1I?=
 =?utf-8?B?ZEk2QkJXM2hRbjYvM0VZeDZSZDVnZU9mQ2JMb01YbW83SmdyM0U5d2o4VTNI?=
 =?utf-8?B?WXdrTktndnNoQzNxZmJ0WW83ZmNsSndsbHEwRlJHVUxlY0NoV3hnV25pd3dJ?=
 =?utf-8?B?WElabVBpemsvUHdyWWo5U1FYSmN4UkMxdU1GaU9aR25GQUFmdlhiV2FSUzNF?=
 =?utf-8?B?eVowWFpZSERKeXJGZHVyYVFvNEwyNnBPUlYrbG8wTEh1ekJrMDNQcXpCZVk3?=
 =?utf-8?B?Y2ZaNWxXZjhOOExQV0dkdUNWZ2tkazB6cjdRSnZnL0gxUnNKdEhwZlFCRmpk?=
 =?utf-8?B?enlrZjhsNkUycGx6NE5lUzJhWWhFTUh0ajlGVGlaNVJEZEZtMCt0OStwWkk0?=
 =?utf-8?B?eXVQbUViYnRWd1dXQWl5dENSU2RQd1pJZ2dieXJ0Slg0Tnl1bUZldXBPUnA4?=
 =?utf-8?B?K0NpZzJINytJZzFYVTRiTTFnSFZIMnU4RkFXczJsVXUwQWtqZndRWGpZS01x?=
 =?utf-8?B?WVkrb1Vqa1VnaTdqYTIzVlNoQ2xlRitOc3k3VkczL25XdnZnd2NuczBGaVVy?=
 =?utf-8?B?Z1ZhbU9yTDVkWS9RV20zTGtOdGd2MEgzMzE2T05pcGZla0UrUEFlMzRpaHJT?=
 =?utf-8?B?OGxZNVErVVhlNTJBbUIrSU5ZbGtyc1YrbHhYaXoxdVBtTHJiOSt1T3NySWFD?=
 =?utf-8?B?L3g3N0x5MVVNaEFXMDdta1VQR2NoUENtZEJaQVVIVFdydWl1SE5wZkZESWVB?=
 =?utf-8?B?Yjg3KzBoZTNEK2l5NXlYOU15Uy94bThUYTBSeHdpbkpDbFpwMUNsd3AyVkdr?=
 =?utf-8?B?V2NwNG5yZ0dualYwdkdleU1BaHFHVnRUaWJ3KzdSVFdFMFFwNldHQVp6YUVN?=
 =?utf-8?B?VERVTHI4QmZwSmNvV0g2cVlIejJiUEJtS29GZWVTSTRnQWN5NTFheDhTUUtF?=
 =?utf-8?B?emlCTmRYdno2SnhIb1h0enFMVlpOTGYzdWlMQUM4TXJ0bXQ2TGNCUmxLZ0FJ?=
 =?utf-8?B?S2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b86975c8-59c6-46ce-8745-08dc0c3bd896
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2024 09:10:35.9435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cg9TlSBSZp9t7QiU5qHc0MdYs4bwZF3+1I/9LY91Y6BDHPtSpqTzzt0HCu1oKcDr+zxvRUef6/oNJ0ZNEayTqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7608
X-OriginatorOrg: intel.com

On 1/3/2024 6:25 AM, Maxim Levitsky wrote:
> On Thu, 2023-12-21 at 09:02 -0500, Yang Weijiang wrote:
>> Define a new XFEATURE_MASK_KERNEL_DYNAMIC mask to specify the features
>> that can be optionally enabled by kernel components. This is similar to
>> XFEATURE_MASK_USER_DYNAMIC in that it contains optional xfeatures that
>> can allows the FPU buffer to be dynamically sized. The difference is that
>> the KERNEL variant contains supervisor features and will be enabled by
>> kernel components that need them, and not directly by the user. Currently
>> it's used by KVM to configure guest dedicated fpstate for calculating
>> the xfeature and fpstate storage size etc.
>>
>> The kernel dynamic xfeatures now only contain XFEATURE_CET_KERNEL, which
>> is supported by host as they're enabled in kernel XSS MSR setting but
>> relevant CPU feature, i.e., supervisor shadow stack, is not enabled in
>> host kernel therefore it can be omitted for normal fpstate by default.
>>
>> Remove the kernel dynamic feature from fpu_kernel_cfg.default_features
>> so that the bits in xstate_bv and xcomp_bv are cleared and xsaves/xrstors
>> can be optimized by HW for normal fpstate.
>>
>> Suggested-by: Dave Hansen <dave.hansen@intel.com>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>>   arch/x86/include/asm/fpu/xstate.h | 5 ++++-
>>   arch/x86/kernel/fpu/xstate.c      | 1 +
>>   2 files changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/include/asm/fpu/xstate.h b/arch/x86/include/asm/fpu/xstate.h
>> index 3b4a038d3c57..a212d3851429 100644
>> --- a/arch/x86/include/asm/fpu/xstate.h
>> +++ b/arch/x86/include/asm/fpu/xstate.h
>> @@ -46,9 +46,12 @@
>>   #define XFEATURE_MASK_USER_RESTORE	\
>>   	(XFEATURE_MASK_USER_SUPPORTED & ~XFEATURE_MASK_PKRU)
>>   
>> -/* Features which are dynamically enabled for a process on request */
>> +/* Features which are dynamically enabled per userspace request */
>>   #define XFEATURE_MASK_USER_DYNAMIC	XFEATURE_MASK_XTILE_DATA
>>   
>> +/* Features which are dynamically enabled per kernel side request */
>> +#define XFEATURE_MASK_KERNEL_DYNAMIC	XFEATURE_MASK_CET_KERNEL
>> +
>>   /* All currently supported supervisor features */
>>   #define XFEATURE_MASK_SUPERVISOR_SUPPORTED (XFEATURE_MASK_PASID | \
>>   					    XFEATURE_MASK_CET_USER | \
>> diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
>> index 03e166a87d61..ca4b83c142eb 100644
>> --- a/arch/x86/kernel/fpu/xstate.c
>> +++ b/arch/x86/kernel/fpu/xstate.c
>> @@ -824,6 +824,7 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
>>   	/* Clean out dynamic features from default */
>>   	fpu_kernel_cfg.default_features = fpu_kernel_cfg.max_features;
>>   	fpu_kernel_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
>> +	fpu_kernel_cfg.default_features &= ~XFEATURE_MASK_KERNEL_DYNAMIC;
>>   
>>   	fpu_user_cfg.default_features = fpu_user_cfg.max_features;
>>   	fpu_user_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
>
> I still think that we should consider adding XFEATURE_MASK_CET_KERNEL to
> XFEATURE_MASK_INDEPENDENT or at least have a good conversation on why this doesn't make sense,

Hi, Maxim,
Thanks for continuously adding feedback on this series! Appreciated!

I think the discussion is not closed at this point but need maintainers to indicate the preferred approach,
so far I'm following previous alignment that reached in community discussion, but it's still open for
discussion.

IMHO, folding XFEATURE_MASK_CET_KERNEL into XFEATURE_MASK_INDEPENDENT isn't necessarily cheap, we may have to touch more code that works pretty fine these days. In terms of KVM part, currently after VM-exit, guest arch-lbr MSRs are not saved/restored unless vCPU thread is preempted and host kernel arch-lbr save/restore code will handle the MSRs. But for guest CET supervisor xstate, host kernel doesn't have similar mechanism to handle CET supervisor MSRs, so require relatively "eager" handling after VM-exit. If we mix two different flavors in XFEATURE_MASK_INDEPENDENT, it would make it harder to handle guest xstates. Note, arch-lbr support for guest hasn't been upstreamed yet, it's based on my previous upstream solution. Maybe I missed something but it looks like true for the two guest features.
> but I also don't intend to fight over this, as long as the code works.
>
> Best regards,
> 	Maxim Levitsky
>


