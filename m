Return-Path: <kvm+bounces-3070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B5185800504
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 08:50:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D88C51C20CF7
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 07:50:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EF2A15AF1;
	Fri,  1 Dec 2023 07:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A53tIrpW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4145F128;
	Thu, 30 Nov 2023 23:50:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701417010; x=1732953010;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TQypFe4cmLpL8dPVSh7VAX6tPQl5OFQm29gDdv00P2A=;
  b=A53tIrpWvNPkCZPeMHwwwfiovLLPFboTHqsGzj75RGvX/igoJ2Qd3lDf
   yB9B41t6IWux2A0yOqq7n0ytq+TvbSYFVjSghhjVl1MS8dzbdaGsGTW0P
   lsYKxOUbahMvQdxZ71yeB/z0Mo9tNkZrNhdm0q9CQCVFIk59weRg0rcj3
   t741XKVE7niJeQQrZOFMp9A57ZU+XnzIb3dEmhjGU75dkcr07ev6tqtgn
   1C4/DVH+VkIpnx1Q02p6PwPv9GYvn/ODjMsWGgEkuCGLhV3/9+4rhoHQs
   foGSu2Tuuli+5AZ1kspFUH1IzEcA22D///I4pM8xOYu5tr5c3uv+JOO3o
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="6699541"
X-IronPort-AV: E=Sophos;i="6.04,241,1695711600"; 
   d="scan'208";a="6699541"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 23:49:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="943005849"
X-IronPort-AV: E=Sophos;i="6.04,241,1695711600"; 
   d="scan'208";a="943005849"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Nov 2023 23:49:53 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Thu, 30 Nov 2023 23:49:53 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Thu, 30 Nov 2023 23:49:53 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Thu, 30 Nov 2023 23:49:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B23U9AVrVDzMfL82z0l80gv0+foCsegiP6fffWjUdmEykPtfVvpBBK55PwXd9AyxvS58Rn25HCKZ/k82IfbhVK23V1pSRb6mEMrHLrYABXsAbAw99FnXCXbqkKL0H1UFmoyOlYsdVwo7n/Q13E8dF2xG8d9L76a1YyZV5RKsePEg8liGjgbehvAOIoi2o7bKAVWoLhzDamEf8tdpwc+yXa0esBpedpwV9iiFbM/GHvz3DtdBKk2DDhQKkSmErwrruO0dMXeoySU+n1ZR7KG/1bNgf7PD/Kcpi+5fhO1dfHiLeCLhW8EFNIv4lgXcDt8133kvt9XYOeJLVM4xfX6KAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BdJGIZ4Z6/OCjP9YMUmGfVAnkWu9fRb6xKxPEk5i+UI=;
 b=T16YyBYx41zf7MTT3CU4Ju1UlLFzQlSHI45rkr0LeiKwLR+ZS/3FPZBD70S0VMwWasRTwxWhSbp3sAqig91Ej6JS32f3KEMQc+B51Nz3k8F40rim+CHEAl+Pw34LnbzwpAHFVer+rD8Ofx6TPQBbhwG6AJ7tg4ffKqttwyJgTCPmbzlXf0KdM/PuHyTmqyVQa9t5qpDq9nvTXDdWpOua9C/WNLtWkstWmbId//vIEmS/1QmheWAQ5H0dEFptcUJDwALBr/8cBXun70hNE2zN9R1HqwIYf/nkSUaznn2svwIAv7EiTCN6ycGaE0dF5sQdZHO0F6nIHMD7dfud5B0gng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DS0PR11MB7999.namprd11.prod.outlook.com (2603:10b6:8:123::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.22; Fri, 1 Dec
 2023 07:49:46 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ea04:122f:f20c:94e8%2]) with mapi id 15.20.7046.027; Fri, 1 Dec 2023
 07:49:46 +0000
Message-ID: <9a7052ca-9c67-45b5-ba23-dbd23e69722c@intel.com>
Date: Fri, 1 Dec 2023 15:49:36 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 04/26] x86/fpu/xstate: Introduce
 XFEATURE_MASK_KERNEL_DYNAMIC xfeature set
Content-Language: en-US
To: Maxim Levitsky <mlevitsk@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<dave.hansen@intel.com>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<peterz@infradead.org>, <chao.gao@intel.com>, <rick.p.edgecombe@intel.com>,
	<john.allen@amd.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
 <20231124055330.138870-5-weijiang.yang@intel.com>
 <3c16bb90532fbd2ec95b5a3d42a93bbbf77c4d37.camel@redhat.com>
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <3c16bb90532fbd2ec95b5a3d42a93bbbf77c4d37.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0155.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::35) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DS0PR11MB7999:EE_
X-MS-Office365-Filtering-Correlation-Id: 163e8412-282f-4bf4-9bf3-08dbf2421581
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h6ebAzl3aMNTmztA/tjR37kxdbMtw7a6Z5HbkEYrcicZ6gxO4uirFU5zosW8qmTsEuQ6KAentwFkJzmdPtQ1mNdmc9UTAXgf7mRY0EZbrvgV0AFSoSTWy8I2XEHPW1MGlQl6iVSTBPGZiBvwtmJOTMcmY8FmosqAyhez+WWO1XKGxYXWyVrisYyLWcGnk7JDLIGr7u6NM3UYB++Sx+V3IfqAO6TqoMPVGMZhwcEn75qdc2dGqHGMsIF/0THWpUlEtOtR3PCZRBfgaDrkPks7HDLK3xYLm79vgtma/4mO/rppgb73bSn0V2mz8RhyBW0t/aiVDVjeJvpvRk016Z4CcLBVzIalfgepF4R/NUJgqIIcQpgktnNC36ge3JoKv/So/mbtVG2NqNzboc1OpGy/3HC0k8iFMnw7uDYIg8owTjT01UJPyyPvPX5HV+/28FiOhhvEDp+epdDQKxhCVK6UMp0HgRFGp+qrURCKBTUT0x39elFdho2etLl84k3gQnb3Wf5qnRwLt9YrnKQPs7jhgywg6Ek8Un3Tl22GytVxNT+NN6tEgWfdqAtF22J8EpttvlDVwDzk0y9uEd7Lo8HNlvpSema336iifWGxeRlkn4a8QElFPLBXeI7xWTZcqd9qxBP0pnhv9rQK1LSQCD3NUw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(396003)(376002)(366004)(39860400002)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(6666004)(478600001)(6512007)(2616005)(26005)(66476007)(53546011)(2906002)(4001150100001)(83380400001)(5660300002)(6916009)(41300700001)(6486002)(8936002)(66946007)(66556008)(6506007)(4326008)(316002)(8676002)(82960400001)(36756003)(86362001)(38100700002)(31696002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bnp6RzFJcm1hL1BoMitiQWZ3bVVtemgwVDNxK0k1bkdyMnF3aDZNaHpzMktE?=
 =?utf-8?B?K2czSFMvLy9JSXNDU0VPRFRDUmhqQzN4aVhWcmd2dEhSUXowdGJ0U1BpNE1q?=
 =?utf-8?B?MVl0MkJYY0xnZDVxUEJQNUVWejNBRUZvN0RRZlhzTndkSVdxZEgwNGVsZDRs?=
 =?utf-8?B?T1lLcGdKcDh4TFlCR0lkT2NoeVlzeWRRZzZiUndiZDZPWFRxeFBLQW1BL2VI?=
 =?utf-8?B?NERkcEVlU1dwZUc4bkhVYlFXK2FvRWp2TzRXZGpXMVk3aWljNEFIMkJrUGcy?=
 =?utf-8?B?Z3RjQXpsZ0ZNMHR0Z2FERVpwOURKRVJVV0xQMnNXR2sweG1BRHExSnZZZk9I?=
 =?utf-8?B?d09wMWlVclhKaTF6Q0tHMldwRTluLzl2cW5DaEc2NXl3NkFZZUF4aHFWU2ZZ?=
 =?utf-8?B?dVFBRzhpZmVOSndHS1hGbTUzNXZqOC8yOTZpYitaT3l5NkRQemNWRkluOENT?=
 =?utf-8?B?SmluRnJZaDloNnZyRHpQTDAyV3hWaUd4cjVoU3plaVZnUTdBNGl1bHB1Mytt?=
 =?utf-8?B?MSsrTGhZb2grcHVkY2dDQzNyUE9qZlJ3WGJvQ2JaTjMvUUF3M1pRaFZoc2xE?=
 =?utf-8?B?emZaZHVKdnc3UGJkN29jeGNwejd2UzZ0SlFGQmRuUTdMd3RjNEFPaHNReWJz?=
 =?utf-8?B?bzB1eG8yRVBWWGVOUWE4NXlQLzlkS2JNZVg4S0hqNFpKR1lJdGdxMlJPNUhD?=
 =?utf-8?B?K2R2ZVlpdUlIcmNDVGJmY3lqSUZYZ09sVmRRREczOUc4Y0NzZlFtWmk4dktp?=
 =?utf-8?B?elpQT1FJTXFHMkw4U2hsSFUwWWoxUUNnbTdoQzdnMDhwNHNjaklMdUpmRzBz?=
 =?utf-8?B?OC9FZ0MwdWRZVStQRnZmbmVKbzk2cFQ1SFd6UXhtSC9QYnRPNXV4UC9hTE1X?=
 =?utf-8?B?M1V3YjBHbms0V0JpTS9paWxHRHl2OHoxWk5FdEcyZlc5NW9NcFBCWWZPYUh3?=
 =?utf-8?B?UTZIdkttMkw1Znk5OUVQWURUaVhnMk5lR2orVU9zQnNGa05KYzJWQmpXamhO?=
 =?utf-8?B?VU9OVUdVZyszekM4NGFuM0pDNkRiN0krNFlRRllYclZJNmdqZk5zK1luUnJz?=
 =?utf-8?B?WmRIUElSQkRJdzZZSVFkbzR2NHhTQVNUYm5QbGdCVnAxcXZzNkJIaHdrUWxs?=
 =?utf-8?B?ekJFWjBzYnd1WHEvdlBNNzVTUzJON0QxQXBrcW91MSt0cGRJSVZjUnhSY2JG?=
 =?utf-8?B?UzZ4YVFkcVJQaTFmelFvcEZQVjVKZjNGU2ZVVDEzcDBLamdsajFrUWlXTmdk?=
 =?utf-8?B?Wmc0QTFaNGlKUGptMnNDTFdyY05Cb0RNZnBCZjZ6YzRZTUM2MVVVZjN4ano3?=
 =?utf-8?B?NVNWczFNK3ltYUxUK3JUcGZsZUl6bnZVNXVDT2pEb05YU0ZLSUE2Vlh3eDNr?=
 =?utf-8?B?RzZ1VWdyN0xuemVMQlk3d1RleGFxQnRFNmU3djMyR0VVK2dOdlZFL2ZQaTlS?=
 =?utf-8?B?ZnE3Nm84WEh3QVZKUmp5anhCaWFEanYyUmxrVWM3VWZRNmViVGZ6Y25aSjZv?=
 =?utf-8?B?NU9TRWlwZ3VidHkvL1I2NXJyTmRmNG5EeGU5dU1hZHNLcFhXdTFGL2hQQk5i?=
 =?utf-8?B?cnpWY0d5UFhtUS9uMDFnek8zR3dBZWhKRmFRNU9JNm9SQzBjWm5zUTNrTEFh?=
 =?utf-8?B?djhuKzJWRDJUZVpRbmc0Z0Nrb2ozdEZMZDc4S0k5MmFpU0lxcHpnU05tM29z?=
 =?utf-8?B?Q3FxOHNOSnRYcVIzZ3VybWdMSW5YblNCeE5BMnM3cnhVK1hYOFlSbXIzelJQ?=
 =?utf-8?B?K2dkZzRBcnVsNTFnWGNtK1h6TkF3bXAya05tTWFzb2poblZHcmJGR0J5WDFp?=
 =?utf-8?B?WXhVK2JuNnZKbUlPRW5QbExQSG13Y1cxT1M3VGZOSE04KytIUXd2YzdDYTZq?=
 =?utf-8?B?R09YTFJ5VWNoam93QXJXS2ltU1AyR1RnbWhCRWtoS2g2QW1sQlZjVXdLS2RW?=
 =?utf-8?B?b3pWU3liQlJKdWdBOTljTWJLbld6eGZOYmxEQ3lYd1c1TExFbHJXT1FzUUV2?=
 =?utf-8?B?MTA0R0NXWGttWjlnNStibU5lRHZkSHExMVdObW1KdnVwYk1vZ2RKalRib0dK?=
 =?utf-8?B?MGUvTnBycEZpb01MeithUzNBK0FtQ2hhQWFtWXQ4VWpZTHFwZURKRWZEVkxx?=
 =?utf-8?B?NFFQai9pV0IvWHhSaDNXNU5aS1VoeHNrYzBhc0RGRURaMk5MNFFTYUppc2Np?=
 =?utf-8?B?cnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 163e8412-282f-4bf4-9bf3-08dbf2421581
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2023 07:49:45.7435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s5FkJgZvmLXSJh65QCsBbds3516UwAD8YWVHSyRQv4P+ChtSIyEQZzP8G1JiKlZgnq9FfvWXSTQTNu7mWguNpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7999
X-OriginatorOrg: intel.com

On 12/1/2023 1:33 AM, Maxim Levitsky wrote:
> On Fri, 2023-11-24 at 00:53 -0500, Yang Weijiang wrote:
>> Define new XFEATURE_MASK_KERNEL_DYNAMIC set including the features can be
> I am not sure though that this name is correct, but I don't know if I can
> suggest a better name.

It's a symmetry of XFEATURE_MASK_USER_DYNAMIC ;-)
>> optionally enabled by kernel components, i.e., the features are required by
>> specific kernel components. Currently it's used by KVM to configure guest
>> dedicated fpstate for calculating the xfeature and fpstate storage size etc.
>>
>> The kernel dynamic xfeatures now only contain XFEATURE_CET_KERNEL, which is
>> supported by host as they're enabled in xsaves/xrstors operating xfeature set
>> (XCR0 | XSS), but the relevant CPU feature, i.e., supervisor shadow stack, is
>> not enabled in host kernel so it can be omitted for normal fpstate by default.
>>
>> Remove the kernel dynamic feature from fpu_kernel_cfg.default_features so that
>> the bits in xstate_bv and xcomp_bv are cleared and xsaves/xrstors can be
>> optimized by HW for normal fpstate.
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
> I suggest to explain this a bit better. How about something like that:
>
> "Kernel features that are not enabled by default for all processes, but can
> be still used by some processes, for example to support guest virtualization"

It looks good to me, will apply it in next version, thanks!

> But feel free to keep it as is or propose something else. IMHO this will
> be confusing this way or another.
>
>
> Another question: kernel already has a notion of 'independent features'
> which are currently kernel features that are enabled in IA32_XSS but not present in 'fpu_kernel_cfg.max_features'
>
> Currently only 'XFEATURE_LBR' is in this set. These features are saved/restored manually
> from independent buffer (in case of LBRs, perf code cares for this).
>
> Does it make sense to add CET_S to there as well instead of having XFEATURE_MASK_KERNEL_DYNAMIC,

CET_S here refers to PL{0,1,2}_SSP, right?

IMHO, perf relies on dedicated code to switch LBR MSRs for various reason, e.g., overhead, the feature
owns dozens of MSRs, remove xfeature bit will offload the burden of common FPU/xsave framework.

But CET only has 3 supervisor MSRs and they need to be managed together with user mode MSRs.
Enabling it in common FPU framework would make the switch/swap much easier without additional
support code.

>   and maybe rename the
> 'XFEATURE_MASK_INDEPENDENT' to something like 'XFEATURES_THE_KERNEL_DOESNT_CARE_ABOUT'
> (terrible name, but you might think of a better name)
>
>
>> +#define XFEATURE_MASK_KERNEL_DYNAMIC	XFEATURE_MASK_CET_KERNEL
>> +
>>   /* All currently supported supervisor features */
>>   #define XFEATURE_MASK_SUPERVISOR_SUPPORTED (XFEATURE_MASK_PASID | \
>>   					    XFEATURE_MASK_CET_USER | \
>> diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
>> index b57d909facca..ba4172172afd 100644
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
>
> Best regards,
> 	Maxim Levitsky
>
>
>
>


