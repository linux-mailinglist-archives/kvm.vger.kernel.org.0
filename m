Return-Path: <kvm+bounces-3065-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 21B1E80043E
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 08:02:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8B23DB2120F
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 07:02:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DA3911729;
	Fri,  1 Dec 2023 07:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eukLmNnO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ABF2171A;
	Thu, 30 Nov 2023 23:01:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701414119; x=1732950119;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qx6oz5mOe9Oj6LZQL5XS/NXjupiBqCnMDvO29e4JqyU=;
  b=eukLmNnOTFwNrRXIfLuweHRriMQU1IBnYah8zaCn3a4SvY8+RpwRfO/e
   OTIosEro7BQDxl98vpTSu63VjhrS297jRp833iyr7lL5Ofvpc6uz/gZ+f
   fD22auPKRzZ7jyX7FmAhhZ+jXRIAc5uOd4EiT5A1vabaqH8PGwUDwi8aT
   lc7W0alS5gX0ZSUWXmbuTsinpvYEyGTBLVIx2B5cU9sTEwXaNywR+Dqdm
   GpSF/IaRdzeavdFyry9BlHWb6RnNeph8xMvSLhF5LeDQzPADK2DCGoRan
   VGEPx0hUzakZsXKaPchvjWNsLj9dF+ZUvPkEkGH/gH9822j+dDYqAyogJ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="392317568"
X-IronPort-AV: E=Sophos;i="6.04,241,1695711600"; 
   d="scan'208";a="392317568"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 23:01:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="769576231"
X-IronPort-AV: E=Sophos;i="6.04,241,1695711600"; 
   d="scan'208";a="769576231"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Nov 2023 23:01:58 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Thu, 30 Nov 2023 23:01:58 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Thu, 30 Nov 2023 23:01:58 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Thu, 30 Nov 2023 23:01:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y7pXW7d6Yz5ckLLAL8viESeTe4qUZM+5yNiGrHA1zMXXxWgCIx5btxDrfT45gL2VrE6eh7S8RanNOAAu5y/sJgq191zkzEjOoBGFyLv109rx/ubqpgeJ5cAUwFxf1i0sBpWfSf2q8Jeg6XNqa1oomjecitQWWLGl5ZtRcxr7K8/z5zGNLXNlYhusrXvwOXUU2ct8FO0L8yODKE0AzuwyUmzZ//fERPTD+VneCiLifW0hxxpK2gZ4wZYYtTwJ1G0u8lEsgeWBHIZ8sFsBI3BEddHftVad9L6w2/Fz8ZY22maWeuwY7BxucnwcUnoecfXy6A4wwe+A5Q5huGZmTdNWOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V3qSBSnkZO663k0L/0OOsdrB7PLliMmTRtYRLFftRew=;
 b=QkllO+BOjyRM8IOAhU9qZS3pdasQZy4uVFAKwOAVzjSnFyD+ZfreK0SHtXUID6TZpQg35vd5KAP32cFlA5cxb3y2Dk9l0z02QXoAo3AmE3ndJ4RivzQUBoFkF9gVcq2zLJn68IfB8o4S8J/TWjwKwtqhQer7Aj7hsQvGis5/vGnOw9ut9iGr6OsvZ9fd6II6KaOMiQaOri0+O1Fk6r4/Ektx85zbYWavisR/iGn7fbamvGbzJMrD211VRYTxW4rheQGhP03+Dig+nIk2cqGw2GG1KQJMMK9fEKJx0pUnrpy/FMFr/9jMqw0x097yXI7qjqjIHfsEdwsfiahf2C8+dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SA0PR11MB4717.namprd11.prod.outlook.com (2603:10b6:806:9f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.24; Fri, 1 Dec
 2023 07:01:50 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8%2]) with mapi id 15.20.7046.027; Fri, 1 Dec 2023
 07:01:50 +0000
Message-ID: <ba6dc90a-64a7-4124-a9b9-c600f3bdbd19@intel.com>
Date: Fri, 1 Dec 2023 15:01:38 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 03/26] x86/fpu/xstate: Add CET supervisor mode state
 support
Content-Language: en-US
To: Maxim Levitsky <mlevitsk@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<dave.hansen@intel.com>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<peterz@infradead.org>, <chao.gao@intel.com>, <rick.p.edgecombe@intel.com>,
	<john.allen@amd.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
 <20231124055330.138870-4-weijiang.yang@intel.com>
 <13aaf1272737737c29ab1de22438695637944d24.camel@redhat.com>
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <13aaf1272737737c29ab1de22438695637944d24.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0148.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::28) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SA0PR11MB4717:EE_
X-MS-Office365-Filtering-Correlation-Id: d063bb87-991c-4f29-3dbb-08dbf23b6442
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fLns0fEw6CRVt4LrKmsv/VkEiN6LhEOcam/98kIw0n0/Gc7fZNgxbBdt9W6z4gMmQas4icLG6BDgKkmv1oOG0xA/5MOoOpJpJDTg9WQ0g3LAlvWfrz5tIOpHJbuEBlv7SayXLQ8h+ALsnjnsmaoFHFC3eJ5OsphZ4nI4iOLU5QcK3hSbRt6p+Q8Rcu7I03evVbwmJJPrguE81hsbHv4FyvThyDsafHQm7fxMP85dEucngll8d8bTTTZ5C0xBBilEFiT8kOZs7r+KILEVczsQFWnvDsFsa05WaCFMOrlioUnHtiIyUgBeGr4upyNLZJ3wJlkbX/UQe3I4+vhRRZ49/nIE/9qkXIGYnllktw8bPW6ZaonjIi/6TM5fJglMcDDl41Y2IkVpYxrF460MFh/OSngiISJhssPipwR6ElpqP8PuQgIC6MUNZDWA65yFyjU6nxWd7c3zJW9E2HZP1XJGUKSDNoSkuAdhATVragrrp2EvPrlaxlWpC/jnAAbj3QVJbra9ve/A/KDyrbtOyhYaWmI+snGWrHfglHDkszV66dM5HXhD3QXumwOhj7nB4guTi/aBo4GlUj9vJn0Jn6mLlYg3Gm7NNkKY/CIIRmMOAugIy2qd1ywhBUtyBzzM3lN++lR0f2CfttJ6fI34F1hndiszxWpmBmVXGxUtkqgbl7UEayREKjTip2K34EgaWI9y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(376002)(396003)(136003)(346002)(230273577357003)(230173577357003)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(86362001)(6506007)(26005)(6666004)(53546011)(2616005)(6512007)(4001150100001)(8936002)(5660300002)(8676002)(41300700001)(6486002)(478600001)(2906002)(966005)(4326008)(316002)(66556008)(6916009)(66476007)(31696002)(83380400001)(36756003)(66946007)(38100700002)(82960400001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MGdWQ0RENytQb0N6d0lZZVVWc0Y0dk9adTBGYnZXYVpKZ1lWN2dSSExaelo0?=
 =?utf-8?B?RmlKNTBMZXc4Y1doaEducWlPWGlDS0dDYm5UVldrcTFrSEl2ajlUNHFBTW5B?=
 =?utf-8?B?UlQ1M3c3dm9mdVg4a1ZSaU5JcGZMeUhyS3ZKNDhIRnhDYWZjcmxOQi8vMnBr?=
 =?utf-8?B?ZGg5NXJ0NXJjV3NYUVQ5SWlweEhoMGE2WkttNk5YNVF4NXYwUnZtSmtuMVdz?=
 =?utf-8?B?V2ZFUmVIeHVZQTZQaGt4N3hlcVNtLysvVXhQVTJDRStkSHNsV2ZoUENtZ1pP?=
 =?utf-8?B?M1FCRXhYWXpMejlRdHRNV3d4aVpQYld5MWV0SzVEY1A2Y3o2ZjFVMzBrL0xq?=
 =?utf-8?B?QWF3Rm4yeHA3bmNYRGNnU1JVUS9jNy9Zb3dreVFrdzc1clZwZXZ4b1E5b3Qv?=
 =?utf-8?B?dWVMcktpMDhIUlVSUVhjVWMyZnJZSUJWOWV5VmtVQkRzeTBqeVRaNU9vWmJh?=
 =?utf-8?B?Yk4zWVNuMU81dnFUUEdTK3dlT2lwbWpaTGlObXhXVWdYcms1dXNqdTE4UHA4?=
 =?utf-8?B?QXZWN0pIUm1NdEtESTl5YThVUjBwak9yVWZBdWY2Zzg4WktnVndKWmdtT1ZX?=
 =?utf-8?B?TjllbC85KzE0MVZPeThYZWszZ3VGcWRUZVhLR0JCbEUxTDN6ajlUMDREMTIr?=
 =?utf-8?B?TzV5Qm9YeFQ3Q1AydGRBQkZXUExXa1hHNTFTelBnT2pKZVVYS1hORjV6OEtP?=
 =?utf-8?B?dHIyRk5rRU4wRXZDeXBSakZEclFpSERJQWVXZW54Qk91Q1RWR1R2aVk1dEhR?=
 =?utf-8?B?NzdUNzVid205NmhYYlpTTXlaYUpBOGFGR3VoZmNNTjZtTzk4WHUxZzFldlZD?=
 =?utf-8?B?VGxJWTg2THRSRmlESEdodk5ZOVYrcFNHWGNyQThzdmxXYkpxNDR2RFR2bHdt?=
 =?utf-8?B?Q051cER2VGVxYkoxMVo5ZDlYY2QxWUpjNzhQMTdjL0JmbzR0WVphcDRuZjBP?=
 =?utf-8?B?UWp2NTNHVWloV2Y5L05SejJ0UlVVUlZiSkRqZ2JVbGZQSDNaNGpCaUNnMkU5?=
 =?utf-8?B?Sk8xUGhVaUtHWjFVanV0bVZOUVVkdWpRYUM3VDN2Q3RraDZTYzJxQi96OGVu?=
 =?utf-8?B?TDVCVVFvdEFKaGVWR05qMkorQzhCWTZuNlkrRHNqVHViSVZTM01PNVgxL1Nl?=
 =?utf-8?B?cEM3eU9zci9ueW9ZbXBGT3hjaytGNWlXS0ZhV0RKT0FhdXNTYUwrSDZyRnVT?=
 =?utf-8?B?eGlMSDNWR1R1R1pXT0dubDI2TFJiQ3Q3ekxaNkNkWXJ5MVFrQ0UwZW1veDMz?=
 =?utf-8?B?OWtVdmwwUkxGVlhCbFE1a0NBT1owZHk5NTBsZ0VhYWZzYWJlcThuYU9IaXZT?=
 =?utf-8?B?VWxjbmNLeVlUcmFxOGpiMHloZ0YzZm5TMDR2MU95RXd0NUpWT1I4TGt1a3E5?=
 =?utf-8?B?bEpqWFRvZWJvSTE5QWxxaVpYcVhkblk1OEtCZ0dIVFo4cVZ4dEdLcTloeEhO?=
 =?utf-8?B?QXl6MzZST2NYTTJNRi9GZVdnY2JudysxcFEvYTdtdzJBSW5WWWx1bGxpNmZE?=
 =?utf-8?B?SEswY1FnUThGOWFDMXM3dkV1bVd3SmN6c3J1dE9wNTRJOTlOcGx1d3NOa01w?=
 =?utf-8?B?aXoya1BYejczNTM1YWpsSnkzeXRrdEo4aWYzd200RFA3SUQraFV4Z0RROXdy?=
 =?utf-8?B?ZkJqOEc1QmNxMmtYZUhoK21kY0hzczN1eDlXWlVmQlBzQjN3K3kvdzBNaTAv?=
 =?utf-8?B?TUVkNExrbmw4WWJzMjhseXRUaFcrNzVJMVFKMTZOQmxIZG5iYTNwS3pXS1lC?=
 =?utf-8?B?NTRIUG82SDg4ZjNVaWtmbldtU2ZZa1NhOWZNWjM0VkxRdGFLSDN3RURrNzJP?=
 =?utf-8?B?TnNrelJ5Q3NPZm9JWXRZb3Z5NXVFQlhMT3RiU29MdHlhRWt0RWJvbXkyU2g3?=
 =?utf-8?B?WFZxYTA5S2ZUb1JXODRwNlFzVFR3Y1ZvU0xaTk9NRzRvUzZDNklUY3VxOXVX?=
 =?utf-8?B?RmRoc1VFMWF0a1dHOVNOUUcwNW04SWdoeDd4NTFpQzliVVJkcU13ZSt3TThY?=
 =?utf-8?B?UlZDcXFzcCtrSmllaCt6ZnBVRkw2VFJ0SEdsaHNsNE5YVUNuUitGZmhZaFNt?=
 =?utf-8?B?QS9BU1dwUDRBeHZ2NGV2cWxMZVdvM2FkeldOb2k4KzJZaFRTOWFxUmFwaytY?=
 =?utf-8?B?ZkVYclFMTDl5Rm5XWnpzelNYczVXdzNGa25PZlpEdEV6RGhkUEg5OHZJaElV?=
 =?utf-8?B?K0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d063bb87-991c-4f29-3dbb-08dbf23b6442
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2023 07:01:50.4323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ntxcn621CfMidAakchuf2QoiMb68woUThxLz9S+kXW0cr9IYGOvoH0xrBMtgaoEaD5PvRecY6Fjzn//ww9zw+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4717
X-OriginatorOrg: intel.com

On 12/1/2023 1:27 AM, Maxim Levitsky wrote:
> On Fri, 2023-11-24 at 00:53 -0500, Yang Weijiang wrote:
>> Add supervisor mode state support within FPU xstate management framework.
>> Although supervisor shadow stack is not enabled/used today in kernel,KVM
>> requires the support because when KVM advertises shadow stack feature to
>> guest, architecturally it claims the support for both user and supervisor
>> modes for guest OSes(Linux or non-Linux).
>>
>> CET supervisor states not only includes PL{0,1,2}_SSP but also IA32_S_CET
>> MSR, but the latter is not xsave-managed. In virtualization world, guest
>> IA32_S_CET is saved/stored into/from VM control structure. With supervisor
>> xstate support, guest supervisor mode shadow stack state can be properly
>> saved/restored when 1) guest/host FPU context is swapped 2) vCPU
>> thread is sched out/in.
>>
>> The alternative is to enable it in KVM domain, but KVM maintainers NAKed
>> the solution. The external discussion can be found at [*], it ended up
>> with adding the support in kernel instead of KVM domain.
>>
>> Note, in KVM case, guest CET supervisor state i.e., IA32_PL{0,1,2}_MSRs,
>> are preserved after VM-Exit until host/guest fpstates are swapped, but
>> since host supervisor shadow stack is disabled, the preserved MSRs won't
>> hurt host.
>>
>> [*]: https://lore.kernel.org/all/806e26c2-8d21-9cc9-a0b7-7787dd231729@intel.com/
>>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>>   arch/x86/include/asm/fpu/types.h  | 14 ++++++++++++--
>>   arch/x86/include/asm/fpu/xstate.h |  6 +++---
>>   arch/x86/kernel/fpu/xstate.c      |  6 +++++-
>>   3 files changed, 20 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/fpu/types.h b/arch/x86/include/asm/fpu/types.h
>> index eb810074f1e7..c6fd13a17205 100644
>> --- a/arch/x86/include/asm/fpu/types.h
>> +++ b/arch/x86/include/asm/fpu/types.h
>> @@ -116,7 +116,7 @@ enum xfeature {
>>   	XFEATURE_PKRU,
>>   	XFEATURE_PASID,
>>   	XFEATURE_CET_USER,
>> -	XFEATURE_CET_KERNEL_UNUSED,
>> +	XFEATURE_CET_KERNEL,
>>   	XFEATURE_RSRVD_COMP_13,
>>   	XFEATURE_RSRVD_COMP_14,
>>   	XFEATURE_LBR,
>> @@ -139,7 +139,7 @@ enum xfeature {
>>   #define XFEATURE_MASK_PKRU		(1 << XFEATURE_PKRU)
>>   #define XFEATURE_MASK_PASID		(1 << XFEATURE_PASID)
>>   #define XFEATURE_MASK_CET_USER		(1 << XFEATURE_CET_USER)
>> -#define XFEATURE_MASK_CET_KERNEL	(1 << XFEATURE_CET_KERNEL_UNUSED)
>> +#define XFEATURE_MASK_CET_KERNEL	(1 << XFEATURE_CET_KERNEL)
>>   #define XFEATURE_MASK_LBR		(1 << XFEATURE_LBR)
>>   #define XFEATURE_MASK_XTILE_CFG		(1 << XFEATURE_XTILE_CFG)
>>   #define XFEATURE_MASK_XTILE_DATA	(1 << XFEATURE_XTILE_DATA)
>> @@ -264,6 +264,16 @@ struct cet_user_state {
>>   	u64 user_ssp;
>>   };
>>   
>> +/*
>> + * State component 12 is Control-flow Enforcement supervisor states
>> + */
>> +struct cet_supervisor_state {
>> +	/* supervisor ssp pointers  */
>> +	u64 pl0_ssp;
>> +	u64 pl1_ssp;
>> +	u64 pl2_ssp;
>> +};
>> +
>>   /*
>>    * State component 15: Architectural LBR configuration state.
>>    * The size of Arch LBR state depends on the number of LBRs (lbr_depth).
>> diff --git a/arch/x86/include/asm/fpu/xstate.h b/arch/x86/include/asm/fpu/xstate.h
>> index d4427b88ee12..3b4a038d3c57 100644
>> --- a/arch/x86/include/asm/fpu/xstate.h
>> +++ b/arch/x86/include/asm/fpu/xstate.h
>> @@ -51,7 +51,8 @@
>>   
>>   /* All currently supported supervisor features */
>>   #define XFEATURE_MASK_SUPERVISOR_SUPPORTED (XFEATURE_MASK_PASID | \
>> -					    XFEATURE_MASK_CET_USER)
>> +					    XFEATURE_MASK_CET_USER | \
>> +					    XFEATURE_MASK_CET_KERNEL)
>>   
>>   /*
>>    * A supervisor state component may not always contain valuable information,
>> @@ -78,8 +79,7 @@
>>    * Unsupported supervisor features. When a supervisor feature in this mask is
>>    * supported in the future, move it to the supported supervisor feature mask.
>>    */
>> -#define XFEATURE_MASK_SUPERVISOR_UNSUPPORTED (XFEATURE_MASK_PT | \
>> -					      XFEATURE_MASK_CET_KERNEL)
>> +#define XFEATURE_MASK_SUPERVISOR_UNSUPPORTED (XFEATURE_MASK_PT)
>>   
>>   /* All supervisor states including supported and unsupported states. */
>>   #define XFEATURE_MASK_SUPERVISOR_ALL (XFEATURE_MASK_SUPERVISOR_SUPPORTED | \
>> diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
>> index 6e50a4251e2b..b57d909facca 100644
>> --- a/arch/x86/kernel/fpu/xstate.c
>> +++ b/arch/x86/kernel/fpu/xstate.c
>> @@ -51,7 +51,7 @@ static const char *xfeature_names[] =
>>   	"Protection Keys User registers",
>>   	"PASID state",
>>   	"Control-flow User registers",
>> -	"Control-flow Kernel registers (unused)",
>> +	"Control-flow Kernel registers",
>>   	"unknown xstate feature",
>>   	"unknown xstate feature",
>>   	"unknown xstate feature",
>> @@ -73,6 +73,7 @@ static unsigned short xsave_cpuid_features[] __initdata = {
>>   	[XFEATURE_PT_UNIMPLEMENTED_SO_FAR]	= X86_FEATURE_INTEL_PT,
>>   	[XFEATURE_PKRU]				= X86_FEATURE_OSPKE,
>>   	[XFEATURE_PASID]			= X86_FEATURE_ENQCMD,
>> +	[XFEATURE_CET_KERNEL]			= X86_FEATURE_SHSTK,
>>   	[XFEATURE_XTILE_CFG]			= X86_FEATURE_AMX_TILE,
>>   	[XFEATURE_XTILE_DATA]			= X86_FEATURE_AMX_TILE,
>>   };
>> @@ -277,6 +278,7 @@ static void __init print_xstate_features(void)
>>   	print_xstate_feature(XFEATURE_MASK_PKRU);
>>   	print_xstate_feature(XFEATURE_MASK_PASID);
>>   	print_xstate_feature(XFEATURE_MASK_CET_USER);
>> +	print_xstate_feature(XFEATURE_MASK_CET_KERNEL);
>>   	print_xstate_feature(XFEATURE_MASK_XTILE_CFG);
>>   	print_xstate_feature(XFEATURE_MASK_XTILE_DATA);
>>   }
>> @@ -346,6 +348,7 @@ static __init void os_xrstor_booting(struct xregs_state *xstate)
>>   	 XFEATURE_MASK_BNDCSR |			\
>>   	 XFEATURE_MASK_PASID |			\
>>   	 XFEATURE_MASK_CET_USER |		\
>> +	 XFEATURE_MASK_CET_KERNEL |		\
>>   	 XFEATURE_MASK_XTILE)
>>   
>>   /*
>> @@ -546,6 +549,7 @@ static bool __init check_xstate_against_struct(int nr)
>>   	case XFEATURE_PASID:	  return XCHECK_SZ(sz, nr, struct ia32_pasid_state);
>>   	case XFEATURE_XTILE_CFG:  return XCHECK_SZ(sz, nr, struct xtile_cfg);
>>   	case XFEATURE_CET_USER:	  return XCHECK_SZ(sz, nr, struct cet_user_state);
>> +	case XFEATURE_CET_KERNEL: return XCHECK_SZ(sz, nr, struct cet_supervisor_state);
>>   	case XFEATURE_XTILE_DATA: check_xtile_data_against_struct(sz); return true;
>>   	default:
>>   		XSTATE_WARN_ON(1, "No structure for xstate: %d\n", nr);
> Any reason why my reviewed-by was not added to this patch?

My apology again! I missed the Reviewed-by tag for this patch!

Appreciated for your careful review for this series!

> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
>
> Best regards,
> 	Maxim Levitsky
>
>
>


