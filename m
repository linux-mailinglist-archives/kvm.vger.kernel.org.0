Return-Path: <kvm+bounces-737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D4D67E2079
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:54:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B3D78B20C99
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:54:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E5A71A707;
	Mon,  6 Nov 2023 11:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BwOV+M05"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1E31A5A4
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 11:53:58 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2068.outbound.protection.outlook.com [40.107.92.68])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD79E100;
	Mon,  6 Nov 2023 03:53:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h2DB7n5x+eUONN7aLOjigijXIXnGyK0oz4hmK3xZLJneH4SPH0BJz53u2ksuinnv54IgtYxHdyKtxXr5rPWLh0msfKTtLyarj3W91M9pch1XBm75CeyEn2908CaqnRm1IOIsCCvB2nLWF/kcfL9cGgENtIoF3tRv5q5/RYh5Qzl9V27v9DRMmzFf8LVTKJF1cSVjX01GXhCBkDQNQ2zLVApmzmxnWv8+jUN4AT+75KkbHlEaT/EXGlSfHA7YQds0vUjeI399y7zBJDpE+owybnE4tydCNa55bkafzgpoQrUJavoJZyYB+pedCXX7Pp/snlOVzI7zV0MCLhuG1GWWjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CC803RG7GJFm+5UI+HZBOokAL8RnDCQfaPt9NLNt7Ls=;
 b=eUI+ie8Q9dSVRZPmyJisCTxfEbb+t6l1BEW8mbneGhpeaTcnkGPk1phE+6PvVbf8q+Xi+iw0iLdoPaDmMSBQbud1l3JZwzKdGJBaddrWk5CHsvI8c/t2NjMix1GQvAYUdnCA8SkzvWbHEaUmbavkLqtFQh6gyRX4k0SAhPzunyVhwVAocCR0TrrosBXTkG1MhLSGlz1GRLN08yFCsIbLEIbM6bEBGOjIYIMS6DTuB5tykM9H/jI0sJQMLSDXWKJiq46Iu0bBCgQN+mwpAFePWKCnRXBwLSneKwZihRTQDZIYpazabK91b1Si9gpyfwyw4aoi5IkpU/nfdMnmX1YtIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CC803RG7GJFm+5UI+HZBOokAL8RnDCQfaPt9NLNt7Ls=;
 b=BwOV+M0535ziqOe2bMbSQThoqQj4GyFIRjGPKmLydV9o1j7CNZF4tzcnTW5LSYE61ZTw4yJjisquEsNovb7+iaU+uYRNYaaYcKPh2Qvu9LpOQ6dAf9fKtIsUEmZut/YemXiH/dZftrXtk4k9glnaUh7gTO2grn1ks/wHgRsQWdc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 CH0PR12MB5283.namprd12.prod.outlook.com (2603:10b6:610:d6::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6954.28; Mon, 6 Nov 2023 11:53:54 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::93cc:c27:4af6:b78c]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::93cc:c27:4af6:b78c%2]) with mapi id 15.20.6954.028; Mon, 6 Nov 2023
 11:53:54 +0000
Message-ID: <b56a1eb7-4e31-4806-9f5e-31efe7212e04@amd.com>
Date: Mon, 6 Nov 2023 17:23:44 +0530
User-Agent: Mozilla Thunderbird
Reply-To: nikunj@amd.com
Subject: Re: [PATCH v5 13/14] x86/tsc: Mark Secure TSC as reliable clocksource
Content-Language: en-US
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
 seanjc@google.com, pbonzini@redhat.com
Cc: Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
 thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org, bp@alien8.de,
 mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 dionnaglaze@google.com, pgonda@google.com
References: <20231030063652.68675-1-nikunj@amd.com>
 <20231030063652.68675-14-nikunj@amd.com>
 <57d63309-51cd-4138-889d-43fbdf5ec790@intel.com>
 <ae267e31-5722-4784-9146-28bb13ca7cf5@amd.com>
 <20231102103306.v7ydmrobd5ibs4yn@box.shutemov.name>
 <5d8040b2-c761-4cea-a2ec-39319603e94a@amd.com>
 <cf92b26e-d940-4dc8-a339-56903952cee2@amd.com>
 <20231102123851.jsdolkfz7sd3jys7@box>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20231102123851.jsdolkfz7sd3jys7@box>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0044.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:22::19) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|CH0PR12MB5283:EE_
X-MS-Office365-Filtering-Correlation-Id: d576e8f2-9b19-4d59-3da8-08dbdebf0ccf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	2/WWbyEE7V0gl/JXvqZdIsaLc6NtYDzq9BWTSQeh1X8P91ue4y1lo1MRuhgtUyKtbWI0AVkAYqqgsKviCEHA3Cjbs5zzh9CTPN9cWTaJ83f+MMwu9h9ntMEw2gzlCuhI5cYY01fZGsutsgsgx2TgDpgzdK5bOmXso70KgAJfuPnDQYF/EqLS7z0BdqY83pXhSyQSUx7vKuCGzRnRAffxjG7eQJMKlTSNvGYR+3F8jXr3IANqeBiDOYrIgpFHW0QSlOy/Y2FP0YHMPBdxezkgGVl6b3jKdD1qKBsMKBqb/PG8pueUyQWf5+sU2iWww8tDbBF1wDEDipiq8r13a4d2daG9cM99S1ZnxOr4m7N4JzuduKM5yBcSW2AFQXQgt8hJhLy0Yv05F64KUUuEfxhLRKV2PwDwu+SKPQ6xp+DXSsHQWbRfOttKO1npPqwat+gVWhQF3yerOeAWO6zvgsXXGeSnyVF2StuKWwd7ylqxk+HdCRJVa+NvM3ScNnTWXin7CbwG6q0Ffw19EXh+cKO3IDksu2AZyDorw9xQ6VOQvFdQNQ27Iq3EUQtcWGgcAirpBDdk9bjml2ORRg0BuWhTKKMYr8vo0m0eVKoY4hNTJv2HEZ2VZk9TMQOmrX7Q1CU5zmGTroFtTzFGDhIwZkCktg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(366004)(136003)(376002)(396003)(230922051799003)(186009)(1800799009)(64100799003)(451199024)(83380400001)(316002)(38100700002)(6666004)(6506007)(6486002)(478600001)(2616005)(66556008)(66476007)(6512007)(26005)(66946007)(7416002)(5660300002)(53546011)(2906002)(3450700001)(4326008)(36756003)(31696002)(8676002)(8936002)(41300700001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MVlvdk9WaWlUcXg0SUpxNWhTUU5vKytTaVl3UE5sRlRyQmhxdlpyU1FoMnpm?=
 =?utf-8?B?TGZrK3FlZit5anVqQXB3b3dUVUtmNlRFZVBkbC95MS9sNFR1ZWhiM3RXSjc1?=
 =?utf-8?B?R0tWZFdJcy9wSXplejJoY1JPWlVCTmJNenVBeXFqWjEzeXphVVpBSjBqVFdW?=
 =?utf-8?B?ZnhHUHpvK3E4aFRXNklnN1d2WVowVkdJMkZVazNMSkNmYWdSajk5a1RkRGVu?=
 =?utf-8?B?ZkJTWkUyTWVWSXEvQllhQ3dkSXROTHlHdTZsNWtjK1NNZXB3SnRqU3p5ZVlR?=
 =?utf-8?B?emRSL1E2K05ZdWdhNzc0RlM3S1E0V0ZvakY5Tzc0Y2pUQU1EaGxwa2NnUytL?=
 =?utf-8?B?QXdpQU9UNmZFQ004Z0UycThXOW1sT0NXOWMyNkR2OFhBNTVUZWcvS2NzZ3BU?=
 =?utf-8?B?cUtrQ1hvdFF3ZnN2Vk95dGs5SlVsSi8zbDZ3ZU5TL1NYREhSNitqVHJhZ1Vu?=
 =?utf-8?B?VVRGWStzYnUvUlVDZkFlMXJoeng0aWE2VEhxSnFLY1I2MVRmNVAxcmh1Qjlx?=
 =?utf-8?B?Y0xpOEhIZW1naXl5aG82bDZYTmVtS3g2OU14b0lDckMwQnh3WExDWHJSYkNX?=
 =?utf-8?B?dlU2anFVeHA0YkNHYk45SER3WGo3dElsN3ZLcThmZTU4THJIQjBTY1lFUXYx?=
 =?utf-8?B?dHhPbU1jK0lOTVFlaG13anF4MzNFdU5SWElpcTNnSkw4dE9FSDNRdzVtNkFQ?=
 =?utf-8?B?MWUvYjU1RktyNjB2c0k1RGJ6Rkk2WXNHUUEwNnhiZEdyTmRSSlI3WkdrVExx?=
 =?utf-8?B?OU9OQkhDRGU4eHlIRUxETXBGNXdNNHUxSXlsbkp0M3NKT1RnS1FET3hzeXM3?=
 =?utf-8?B?OWs5MFlDbm1zbC9BYmNyWWtzWmtmeStqTVhIb3V0azAvMGRLenY0T3ZtMFRI?=
 =?utf-8?B?ZzE0ZUFFRndUWFdqUUtJV3VLM0E3b0V4SU9ZU1pRbFJ1NXlTYWtSRzdlVDRv?=
 =?utf-8?B?aFR4SHZqUHZjSENvUlFYRU5FZzdhUTF6T3R0dG5YRlJ4eXpRSnlJNCtzeVB5?=
 =?utf-8?B?K2ZwS3cxSXdRUzYzOXc5MXB3K2dPajBoZkRnS21PNzdzWVpna0RFYzZuc3lo?=
 =?utf-8?B?OVdhK2E1cWRpYU1JNUdDRWY5OTEvdXYxNnVFUktKR2lZcndJUWRCUElGTHZ0?=
 =?utf-8?B?VGFCWHdEVnNVM3FCbmMvdlVURzhWTGFMLy9TSVFCbFhvWmYzYSthdmhEQndR?=
 =?utf-8?B?cW9VQkh3VHVjeDMyQkNEUDdSMnhia0F0Wllkb25oYVJENEFCbHR1NHFKOGsw?=
 =?utf-8?B?WEtkTGYxcDUvMmlScVFuUnk2SVQzSXJxdkFkdXRzaTBlM3ZhbWVNQkxTL0hi?=
 =?utf-8?B?M29icWowd2lScXFDOG55NUhDVHdzdkpha2pDd05nT094MlR6RGV6ZnEvaHRH?=
 =?utf-8?B?cU14M3JXbVpBQjVCd1ZPZTF2cTI5L3FlMnlZUVo4OEhRdjU4THI1U2V6RUtC?=
 =?utf-8?B?Z016N3pYTVdhYW0xZVdYaG1lY1BiNjU2bWtTQkJGRGJ3Z3hXV3NGZjdEenlI?=
 =?utf-8?B?OEFhR1p4WVRUcUlXcGIxOVVoTTlMT2tnZ0VpdlU3L1lrQVE2M2h5K3NRdmVD?=
 =?utf-8?B?aFZWbVhrUWdhNG5MbERXeFZYVHZVazRLOHFVRmUzZTduTGhiMWp3RHdOZGQ2?=
 =?utf-8?B?aXd5ZVBEb3Z5K0hacXFCempkbWdXSVZnQkRFeGpaUXZ2MksxZ21RdW53YnVU?=
 =?utf-8?B?ZDFza0c1d0JlZ3J4OXZJajlpSTVDVmNDYTlKcWNNV1NkWFVkWklXSGxKZmQz?=
 =?utf-8?B?TG03OE5iZk56UUpGenZ4L0xaMDR0bklJZzBjQzJMYlY1MkYrbVUyaUhPc2tx?=
 =?utf-8?B?Y3hUdmUzUFZMOGZDYyszU2UxWUNHYmhmMlVERjZYaHl4QWZKbzdCMFpPTUJ0?=
 =?utf-8?B?dCs2RStGYWpKMVdPSVBoZzFVNTY4SGhtNDE4UzhFMWtTeEJhRTNQMjh1K1VV?=
 =?utf-8?B?b2QrV3Y5dXVOOGh6SFVaaHB4U0JVNkl6SXdKQVllb29rZE9NRmpCc01KWUVJ?=
 =?utf-8?B?NWdsTFAzd0twY0ZjTGE3T3BCRDZ1UFBDcWR3MHc0a2VnSVVzSDcxaXExWlZX?=
 =?utf-8?B?OFlhWEZMS2xYVEpvVmk4enZtb0VZU3pqNnBQQ1lUVTFqanhnUmlzQjR1Rytq?=
 =?utf-8?Q?x7tFvrSnoyLBYoJ9igaOmDk89?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d576e8f2-9b19-4d59-3da8-08dbdebf0ccf
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2023 11:53:54.1533
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S3Wu/f6v+nlA6qL27o+ow8oxt6C/otuPAp0TY/QTdEyd7HmjECV0l4lYX03b1dcRyWg6W8WouAsVAZc2gaP9rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5283

On 11/2/2023 6:08 PM, Kirill A. Shutemov wrote:
> On Thu, Nov 02, 2023 at 05:46:26PM +0530, Nikunj A. Dadhania wrote:
>> On 11/2/2023 5:37 PM, Nikunj A. Dadhania wrote:
>>> On 11/2/2023 4:03 PM, Kirill A. Shutemov wrote:
>>>> On Thu, Nov 02, 2023 at 11:23:34AM +0530, Nikunj A. Dadhania wrote:
>>>>> On 10/30/2023 10:48 PM, Dave Hansen wrote:
>>>>>> On 10/29/23 23:36, Nikunj A Dadhania wrote:
>>>>>> ...
>>>>>>> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
>>>>>>> index 15f97c0abc9d..b0a8546d3703 100644
>>>>>>> --- a/arch/x86/kernel/tsc.c
>>>>>>> +++ b/arch/x86/kernel/tsc.c
>>>>>>> @@ -1241,7 +1241,7 @@ static void __init check_system_tsc_reliable(void)
>>>>>>>  			tsc_clocksource_reliable = 1;
>>>>>>>  	}
>>>>>>>  #endif
>>>>>>> -	if (boot_cpu_has(X86_FEATURE_TSC_RELIABLE))
>>>>>>> +	if (boot_cpu_has(X86_FEATURE_TSC_RELIABLE) || cc_platform_has(CC_ATTR_GUEST_SECURE_TSC))
>>>>>>>  		tsc_clocksource_reliable = 1;
>>>>>>
>>>>>> Why can't you just set X86_FEATURE_TSC_RELIABLE?
>>>>>
>>>>> Last time when I tried, I had removed my kvmclock changes and I had set
>>>>> the X86_FEATURE_TSC_RELIABLE similar to Kirill's patch[1], this did not
>>>>> select the SecureTSC.
>>>>>
>>>>> Let me try setting X86_FEATURE_TSC_RELIABLE and retaining my patch for
>>>>> skipping kvmclock.
>>>>
>>>> kvmclock lowers its rating if TSC is good enough:
>>>>
>>>> 	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC) &&
>>>> 	    boot_cpu_has(X86_FEATURE_NONSTOP_TSC) &&
>>>> 	    !check_tsc_unstable())
>>>> 		kvm_clock.rating = 299;
>>>>
>>>> Does your TSC meet the requirements?
>>>
>>> I have set TscInvariant (bit 8) in CPUID_8000_0007_edx and TSC is set as reliable.
>>>
>>> With this I see kvm_clock rating being lowered, but kvm-clock is still being picked as clock-source.
>>
>> Ah.. at later point TSC is picked up, is this expected ?
>>
>> [    2.564052] clocksource: Switched to clocksource kvm-clock
>> [    2.678136] clocksource: Switched to clocksource tsc
> 
> On bare metal I see switch from tsc-early to tsc. tsc-early rating is
> equal to kvmclock rating after it gets lowered.

For SNP guest with secure tsc enabled, kvm-clock and tsc-early both are at 299.
Initially, kvm-clock is selected as clocksource and when tsc with 300 rating is enqueued, 
clocksource then switches to tsc.

[    0.004231] clocksource: clocksource_enqueue: name kvm-clock rating 299
[...]
[    2.046319] clocksource: clocksource_enqueue: name tsc-early rating 299
[...]
[    3.399179] clocksource: Switched to clocksource kvm-clock
[...]
[    3.513652] clocksource: clocksource_enqueue: name tsc rating 300
[    3.517314] clocksource: Switched to clocksource tsc
 
> Maybe kvmclock rating has to be even lower after detecting sane TSC?

If I set kvmclock rating to 298, I do see exact behavior as you have seen on the bare-metal.

[    0.004520] clocksource: clocksource_enqueue: name kvm-clock rating 298
[...]
[    1.827422] clocksource: clocksource_enqueue: name tsc-early rating 299
[...]
[    3.485059] clocksource: Switched to clocksource tsc-early
[...]
[    3.623625] clocksource: clocksource_enqueue: name tsc rating 300
[    3.628954] clocksource: Switched to clocksource tsc

Regards
Nikunj


