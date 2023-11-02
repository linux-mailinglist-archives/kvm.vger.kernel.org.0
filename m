Return-Path: <kvm+bounces-383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3ED427DF204
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 13:08:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E6B46281B29
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 12:08:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EA37171B5;
	Thu,  2 Nov 2023 12:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dfpX7nPt"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D9215AED
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 12:07:55 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2075.outbound.protection.outlook.com [40.107.237.75])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B02F1A8;
	Thu,  2 Nov 2023 05:07:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CaAF9ZIFkENhsE19xEJfRii38X7TZSx3dQTJVUeBdSl4zNkWZPZHVVGeQf2xLdbtSmW58B1gAwwYmmHRca5MUU6Bjk5YT7YOf9Y2mQBqwT0gEDm7f2qCZ8z43IhdDB95n1BWNRamhAQKcGW8+W/2ZjRYNceEsA5JA72pbHcmrZam77a9l8xlTg1d/WN3PoyrYKhvmUCiPca6NBxnx/0PoZRs99fWx/oTgl6wzRl+GPnICO3+xu2y4cg2nCqb/435UYmtr2gW6VjaKCZ6h8/FgUGsPS8JZnP/5LR8oJ+RwxSu9GakqCfWM69IOdjaUxueT9V8hooIGRySjn699jbKGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V6qs6SWybJpSzGLEKk/bbviaU9NFutxrNzXiSDZmEEU=;
 b=l4vmZelL6xqqzweMPgqFyhtveiNPADGyGLjHLtl5EeIkjYotsdPDVGC3trQF+8kVy1OIA/ZZQv9Hjj5I4bbRG/pmymrdF1vtl9VRh/APnrgSMHO7I1pRapGs5WTknk0FDgds947CHWUSXe67iXkkAQkhEZZRvOOMdQh9RHQz69u4TXeG/kam6vbtLOi1z9rqPXbtpZOrE5RQYpq2WkKuuH1ONxxQ0uzZw28dy5v7K8LA1HfweEnjdGHwjZMtrYcXO4rDKm+O9yEfAiKmvGJMODxSUX2D1ODVRJRlAcEjP85KR65s6GUXR/3qVX0JZmcjMtCOFEcctYGTX0TiLKaZlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V6qs6SWybJpSzGLEKk/bbviaU9NFutxrNzXiSDZmEEU=;
 b=dfpX7nPtJvy4o8wjtVFPoEC4Vz6NExZWZPkVUi8C2PAc8H0dWJUCUyxIVzD7UmN2wZ+Fu1UjM9y1YJxOO6oQe+lztLuPsL2j4GPnA+HajytZ8HgeNTgioQQuC2aaPXA8uJiQJsX7JqzfYyH9GLHsz373NQTZ8cAnExeev/B/aDI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 SJ0PR12MB6829.namprd12.prod.outlook.com (2603:10b6:a03:47b::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6933.26; Thu, 2 Nov 2023 12:07:48 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::93cc:c27:4af6:b78c]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::93cc:c27:4af6:b78c%2]) with mapi id 15.20.6954.019; Thu, 2 Nov 2023
 12:07:48 +0000
Message-ID: <5d8040b2-c761-4cea-a2ec-39319603e94a@amd.com>
Date: Thu, 2 Nov 2023 17:37:36 +0530
User-Agent: Mozilla Thunderbird
Reply-To: nikunj@amd.com
Subject: Re: [PATCH v5 13/14] x86/tsc: Mark Secure TSC as reliable clocksource
Content-Language: en-US
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
 thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org, bp@alien8.de,
 mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 dionnaglaze@google.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20231030063652.68675-1-nikunj@amd.com>
 <20231030063652.68675-14-nikunj@amd.com>
 <57d63309-51cd-4138-889d-43fbdf5ec790@intel.com>
 <ae267e31-5722-4784-9146-28bb13ca7cf5@amd.com>
 <20231102103306.v7ydmrobd5ibs4yn@box.shutemov.name>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20231102103306.v7ydmrobd5ibs4yn@box.shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0058.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:22::33) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|SJ0PR12MB6829:EE_
X-MS-Office365-Filtering-Correlation-Id: 64657847-66b6-44b3-2535-08dbdb9c5462
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	zOFXtk+r5FZwuFMTgFPzMwRS7TD8V2XLat76cE3ieC2y2s6nA2wvL8aU9dB1ADUkn4Sw9LY6/52b3KzQUR3wCbValV6ub7rJrKDhnYgPY0apuqLov5M4okoAyL/T3r1xPeQmHipiR6R1WCY9NPdmgNNSR+FIGrz1Sv7rYTXnLMEboA063ukiAmVSHFMP0QfHIHAIiERbx0ErfJX4uh/5KzgCb/RsKsNGRhXNiGaA6i6hVQ1NhP/Y/Y5eDIn/3QCyIot96UZWum4BDPBl83EzkVhnTbefAVV/3mDTJpcNxvxkpqi/R2NK8xuQYBG6je35+jq0oHslDCPmTksHoKWsQPtjczqz+GWwsElTQbl+5DyHMwCkyGzO/RF82Pq1dWEO7ZTI8GNUZR4wFFMqBXAqPkxNaZiI3EH+qSNsQQ8bfQJXMiU1mK4lH7IMsGIoio2QjPmvIjHJEAzJ2Ul28U6HEktqZk/TAncIvDs6XD7vH9ZKYxT+TOsgBztbt97pQHyZxe2dxxRWAOLJjAayEBcuTu//EsCv/6bm8uATRjy9qz2/mEjocE7coJmfLiUWImmxgGolepTtlHWJ/yfdNQd3mCvYOZuv7PG/W/ptjgol+wZQBan1Bo9kjHM8SvnKSsIiid/nto0Jz5vX7jo88h7z5A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(366004)(396003)(39860400002)(136003)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(6506007)(6512007)(53546011)(31696002)(83380400001)(6666004)(38100700002)(2616005)(36756003)(26005)(66946007)(41300700001)(66556008)(66476007)(316002)(6916009)(7416002)(4326008)(5660300002)(478600001)(31686004)(8936002)(2906002)(6486002)(3450700001)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R0xsMXVtNjFkbzRwcXJScnhlb0hsN05OVWVjSFBJRXQrZWZNSmdVR0U3L1Zw?=
 =?utf-8?B?eW5ZUEhTQ2s5cWxXR1NsWTR5bGNtQmhkU1NLbVFCOU1DUDBxVjRZRXFTVmdt?=
 =?utf-8?B?ZVJ4N2hpbTRFTDh3cVBLZDBoeXRzN2lDbGFPeStJeW9zMk4vNWE2S29DR054?=
 =?utf-8?B?Z1kwU0k4VlJUSFZTOENjeFgyTXNCQW0zYlNJOFpISjkwakV0RncwUkZPbHZF?=
 =?utf-8?B?bExEZVd6dmM0dHdzQkwvTWpxdnRqREM0SFZqMkY4QzVpaDR5bFZINk1laUhr?=
 =?utf-8?B?K0xqRyt4OEY4U25SYVRYQzRkaklGdmtNNUpmUXhQZHpPbzMzbUJtUk9ZSEhz?=
 =?utf-8?B?a2YwbXArREtxNW9OS2Q5TG0zMHM4YS9uRGZlK1hUSFVzSk1XTElqdm1QUnV6?=
 =?utf-8?B?N05qejlxeStkWkJ1ZXZ1ODZqR3BwZ3NNY2pxMXA3TjRRQkl3dG9NcTdnWks4?=
 =?utf-8?B?NHVycUM0OUhEM3ZTRHhBR2g5OUs5dm5IWjF5MFVYdnlxYzZPd01GZ3V3eitz?=
 =?utf-8?B?VVdvamhpT1VTMWs0SDF1QlJ3U3NlSTJvWXN0NUcxekdqL2EwRFA2ejBCR0tQ?=
 =?utf-8?B?UDZ6aEJtaXdVR1g3U1owMWxBZXJtMmg4UEw1RTgzOW9ZU0NTTWZPeS93eFc4?=
 =?utf-8?B?ZTVhK2VPSFBWM2NSOTBQWTdJdWhnMi9ZVldDVjB3V0ZIY0VHUjQxMkcxMFF2?=
 =?utf-8?B?dHh0ZlloZjdTQ2plRFdwOXlFRFJyRE85c0tZc1VmSkIvQldqMWh6ZjR1Z3c0?=
 =?utf-8?B?ekdCSzFlek1US0dVY2hIaWtsY1BNWWRmcmxpSHd0M3IxRE1FUUZJMm9RRDRo?=
 =?utf-8?B?clhQelpIVGYrV3N0RmNZUzVOUFJqK3RTdTdKdTJyeEdOMlhjZ3ZqcU93cUhu?=
 =?utf-8?B?eUpweTlJMzFSTGVBQjF5MXpIMldvZ0hVOGgwSDNPTlptbFpwMEN4T2dsdzlR?=
 =?utf-8?B?MlViU09nc0RZUnorMXVHYlFBYkx2a21pbWZMMWF3SXhCSUhlcDZJRHVKTy9z?=
 =?utf-8?B?U2lFaXVkTWM4VnZodTRCQXhWc2cydk1EMXpNUmdEem53UUVTNlVtMVpNblMr?=
 =?utf-8?B?QjgrOE9LM3NjUzJuUmh1VmovTzdIR2ZyOEQ1TmdGTXRkbndsQnY0RGFDc29u?=
 =?utf-8?B?K0dhVWlvV29GZFdYUnJyY2Z1VlRFeUJtSjlYRTJ5NDhOMm52THYzNDRsSHZX?=
 =?utf-8?B?RVBIWUR4WWhGeEhWK1g3YUQwTUk5ZjR3TlEyUUpDNng2cE5yUWlEdGxsRTk5?=
 =?utf-8?B?QWs5TmNvM0J1NGVGSDF0aUwxQ1MrR3QzVXRidnp4dU9saUZFaVp0SnBLQVp2?=
 =?utf-8?B?c1BuTTBMMmZJL0JlcFB1Wk5BdTFyQlhQYlJaWTkyUUgwVStoWEhpci9GemEw?=
 =?utf-8?B?bWhTQmlpR29YaFI4WXpDaHRzTWlpdkh0UVRyVFZqWXFIa3pGTDdZazM3Tndy?=
 =?utf-8?B?RVlneEdZRk56ZFM5emQrQXRKaWZMNmY2YTNTME1vRmV0WHBkeW1WaDRMRTVp?=
 =?utf-8?B?UXlzN0ZUY3I5dlp6cm9YVjIySEx2YUtsSXNYT3FCM1lDSXR5N1VkV2JMcmlh?=
 =?utf-8?B?ek9YekJVNStWWGp6YVE1SGVGaTgvYVNOSG0vMk9ZRjIxWDlSWHhCNk5hZ0p5?=
 =?utf-8?B?ZUJjcDBSSk43enFlYTZ3cHJhSk9hbms1VVVWcExSV2tvZllvMEdCMksyV1Ba?=
 =?utf-8?B?S0p0Mm5RYjBGQkFTa25OeGROVkVJbXBQSXJCUzltTW0rM0oycXF0QS9RTWJD?=
 =?utf-8?B?SVhObkFUdGhydHRsVnpzTGlMY1lsSVIyeUlsaGsvaXNTaHRJT1JYZlNtWVRn?=
 =?utf-8?B?bm9kOTJPZkllK3hKQnZCY0tJczZqaEtUR0xSZ1FJb3pFTXVMRWtzRTI1Q2pF?=
 =?utf-8?B?NlJpUnUrUXpEdzZXY3lQcW1Pb3dJVktaTWdVa3lvSUMxYVhtWTgvYkVnVVFO?=
 =?utf-8?B?ZEE5N3BhOTBZbTRSSFhxSEVKZXlrQ3lMM3R3ZE9mZ1l6M1FBaXZXZXhFaEEx?=
 =?utf-8?B?S08vczlsUDY2Yms2ek9kZmN1NWdvWk00ZGtDZ3BLcjZORlloL1RZZ05OS1VD?=
 =?utf-8?B?KzVKdkdXdE1hUlhEdWx5dTMrNEF2c1dOZ0MzanM5ZDZ0TDVPODBRS2ZCY3cr?=
 =?utf-8?Q?bFzd5pocEJ1J6/KQVWqgEKD0J?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64657847-66b6-44b3-2535-08dbdb9c5462
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2023 12:07:48.4070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L+GkXbwAh0sGJLC7hOfprGdCFwNuKLTYfGTum9Mo/+vwi3a9nRfZEhE0TkDcQ+ScuqClrEmXHVPiT5+qNFygzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6829

On 11/2/2023 4:03 PM, Kirill A. Shutemov wrote:
> On Thu, Nov 02, 2023 at 11:23:34AM +0530, Nikunj A. Dadhania wrote:
>> On 10/30/2023 10:48 PM, Dave Hansen wrote:
>>> On 10/29/23 23:36, Nikunj A Dadhania wrote:
>>> ...
>>>> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
>>>> index 15f97c0abc9d..b0a8546d3703 100644
>>>> --- a/arch/x86/kernel/tsc.c
>>>> +++ b/arch/x86/kernel/tsc.c
>>>> @@ -1241,7 +1241,7 @@ static void __init check_system_tsc_reliable(void)
>>>>  			tsc_clocksource_reliable = 1;
>>>>  	}
>>>>  #endif
>>>> -	if (boot_cpu_has(X86_FEATURE_TSC_RELIABLE))
>>>> +	if (boot_cpu_has(X86_FEATURE_TSC_RELIABLE) || cc_platform_has(CC_ATTR_GUEST_SECURE_TSC))
>>>>  		tsc_clocksource_reliable = 1;
>>>
>>> Why can't you just set X86_FEATURE_TSC_RELIABLE?
>>
>> Last time when I tried, I had removed my kvmclock changes and I had set
>> the X86_FEATURE_TSC_RELIABLE similar to Kirill's patch[1], this did not
>> select the SecureTSC.
>>
>> Let me try setting X86_FEATURE_TSC_RELIABLE and retaining my patch for
>> skipping kvmclock.
> 
> kvmclock lowers its rating if TSC is good enough:
> 
> 	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC) &&
> 	    boot_cpu_has(X86_FEATURE_NONSTOP_TSC) &&
> 	    !check_tsc_unstable())
> 		kvm_clock.rating = 299;
> 
> Does your TSC meet the requirements?

I have set TscInvariant (bit 8) in CPUID_8000_0007_edx and TSC is set as reliable.

With this I see kvm_clock rating being lowered, but kvm-clock is still being picked as clock-source.

[    0.000834] kvmclock_init: lowering kvm_clock rating
[    0.002623] clocksource: kvm-clock: mask: 0xffffffffffffffff max_cycles: 0x1cd42e4dffb, max_idle_ns: 881590591483 ns
[    2.295082] clocksource: Switched to clocksource kvm-clock

Regards
Nikunj
 


