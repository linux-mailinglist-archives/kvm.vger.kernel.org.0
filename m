Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E972B60B4C1
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 20:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232066AbiJXSDW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 14:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232235AbiJXSCo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 14:02:44 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2062f.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E0F1193D4;
        Mon, 24 Oct 2022 09:43:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KV4vopp9PP4AMgLqgmUpPo9CT3nblq39NS/CoTmYV3CjiEJPU4foccegCgbiU3N9pGd7eZb/UDw+G8/MMddEYAA6Nkw4fFXfhM1vy0UrhTYmsM7FUGbw1aqfeslB1HV5qDmPfbKXFLWIaqAXi1zMINEGszlRXG+uEXX4FaDJIxNpWG74bOqyUla4y/WEgxsVhWJ0W5h/vh+i1JwXdlWuQQwO8Er9kfEv/hxJArUOhhGd1pYlWpTvxCr4oN+wUxW0NpLRXDnPSAIDUPFmcxQ/f15bYaWnzoSPMp1xtgULTTtRcKujkYTv8EA1597hzYS1RgVZt7TNdaxC2rLDiV8WBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bivh6gKkJycZBICjAaQ/aXQNs93vXzy8mM6U5QWqt2A=;
 b=Fri6qPUEiEL/CXk1GAgCfJoN4U/ltXKdpnjfQrSPkUJ7zKouCdKpZCc6xPfKB7LXvy8FlUIdXCOx8/ADjw3X6oFXKt4wFWo9jH3HcUeXm+59SC9OUz8IsAj294LaY8nXaaBKGd4Gfli20UjnZgyv8WHeWlYh+5Rh1FPNc43b0d1UZWJi4TPUXbz2yRJAIb5Pzv8BCZgIPkJoORXL0bZcuupkEw4tYEEwwxyJ38UM1qiGlKYsNvd4hrTbtalDZSjfl8vzOwvQEUhhNTxC5h1/EF6gwJzMeN7vFXFLDmmyfSRzeyG53IVSYukd9oJFYx6bYq/lOmOGxCSmoPy9cemzwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bivh6gKkJycZBICjAaQ/aXQNs93vXzy8mM6U5QWqt2A=;
 b=qftlCnz0tKSdxSRrLguUpjZCuhee6DeHVJPgiC/juviB1oZAhD9pgu4sDgcYar381qM1iZIXmtYJHfJJ3MbV2TCLun9jvU04vYDA3v807JlJBmUugJpBCM4Yp2zxgYYlV6jIr9eP12i8wU2eTiJBGpdqjHbYxEZ2d/+srax5GWU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by SA3PR12MB7950.namprd12.prod.outlook.com (2603:10b6:806:31c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Mon, 24 Oct
 2022 16:31:45 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00%2]) with mapi id 15.20.5746.026; Mon, 24 Oct 2022
 16:31:45 +0000
Message-ID: <50016f7d-ccfb-6986-470e-42f86c58c6d6@amd.com>
Date:   Mon, 24 Oct 2022 11:31:42 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [RFC PATCH] x86/sev-es: Include XSS value in GHCB CPUID request
Content-Language: en-US
To:     John Allen <John.Allen@amd.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, weijiang.yang@intel.com,
        rick.p.edgecombe@intel.com, x86@kernel.org
References: <20221012204716.204904-1-john.allen@amd.com>
 <Y0nGGeCK+/FPOZej@google.com> <8c6a359c-0d8f-b524-984e-bc01be1866d6@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <8c6a359c-0d8f-b524-984e-bc01be1866d6@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0230.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::25) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|SA3PR12MB7950:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f92c6fe-e336-4d62-81f7-08dab5dd3ddc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dkqafm7yMk1bIo9vdhrHx1EwsrIvQO4j1eNeqxQTN11yvWnbiVHlHtCbl+amOXy32zzLaoiOuo+EBqYUHMGLo4m6oZOr7NQajOOwxeqU2Y1Bw9yW7kqaVbNFobtFDGWaATaNGy0ERgprMtq9F8TtCuWTnqSvtE8mJiRJFS5A7ngMQAJMZjBJ3iyUfLYwrQNDoCxtPA6oAzC27nIN4SIiIzBK5cBx6nE9A+aRjvVaxc8/dNygFIaM52UzdyjrHOAVd0hAdF2CiVh4h29t2Snrdy1JQel5+PUZTSULD7x1g73qK/wP8C1QSpM9tB9iz3K0I1Xb1WxGYxsSrWevhcswa0MzHeSuqGgMAUeuq4de9kTz/lb61JLL0eGhj3XJ4Lnd+3AiOrWAAAT42/u5zV939jhJmMC8o18Pyx9M/7Yn36S/CI7eOccu3WmLYvfnQoRXbTdo4d1NJqoh6TW9pJfI6iRi8Jje+w/2W3GGsle5z97M4VS3nLX6J+IU6ocin2PmtKnbMIp5XfDPZinwyz5ev8uUczdnz+YRcdJRpxZvP4BUpzOTZeHl/oxupdoBOwO8Qh9A3F5Vuw4Vm3yQOstl8ZD0d3wE0NItaO9Nu0wxbyLha+IAckk54mMmgiKtnYLi201soXnszfzfiwnyDjSMkF8onARqiyptwuJNtBD8lRdTAGB3fxQ/vRStRgXK6CByrojfkeb89Tgp8723NaDDFP1PZxzfk+poXrTexKnhPGjvaCfLGSQL1HPIdCg6nwANIZvEnjLgNFymSd+IiktLmn0/fDXFhuJIS4rr1BdL9+c+pIOvP/JSde1UhySpZBSI6Tay1Hhfo+up4YQj5p5rrg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(376002)(39860400002)(366004)(346002)(451199015)(6486002)(966005)(31686004)(478600001)(38100700002)(83380400001)(2906002)(53546011)(110136005)(186003)(36756003)(4326008)(66476007)(66946007)(8676002)(66556008)(6506007)(8936002)(26005)(86362001)(316002)(2616005)(41300700001)(6666004)(31696002)(6512007)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SVlRT3M5SmpPQjZtZjlObTNUbk5SR3Z6bm5PYWhjc2VZcHRwOXVnV2o3VjZs?=
 =?utf-8?B?SlE5dVY2Wm5sbjlZRGpLZU5VVWx3MFlndmFDNmtVVmxRV1NVUzZmTm1ycXQ0?=
 =?utf-8?B?RHo4Q3hoc0ZBK01MRjJjZ0VzR1kzL1pvQTlrWFJJLzF0czIyQy9UVURMSzdD?=
 =?utf-8?B?WXU5ZmxreVBheC9CNVY3ekJENHV1R1daK2ROQjN2c0wzRUQyMTRPV1oxUm1F?=
 =?utf-8?B?Z3Z6ZXRyK3J5dTl3Nkxqa3U0cDFZY3kzNDlveHd0TTh5UFAvMUVwb0dJYmg1?=
 =?utf-8?B?eUwyUGpiQmtJWmJ6L3UycFdQQWE1allubUI1UHJjWGFKM3MrNjhiUlFseWFS?=
 =?utf-8?B?bDRGR3ovR2xDU2hWQ2Fkdzd0dllxUzcrY3pDdHM1b3RZTWpsUXM3YW1HNTNR?=
 =?utf-8?B?NDJOM1doQXFCWHhDZGUvV0lGM25oTnRZRWtud1R2WkNTV3U5YU1wcmJtVnNZ?=
 =?utf-8?B?Z0x2MnkvWHpLNTJvT1RCenVCN3MzRklHcUZ5TFhOV2pBeTAzR0hDdm5Sa0Jz?=
 =?utf-8?B?MmhxdDVRVVZLVGR6ZjJMMDVnMWxTblhvakFidUZDTSt5a1pjWk0ya09nR0d6?=
 =?utf-8?B?UUhzQXUvQ0F3SnNOWlhkQyttZENBWmxZazFPbTh0azFnUUZkT0dkeExwS0lV?=
 =?utf-8?B?UWg5cGlRdUQzME1OSWttN0ZHQVRkSElTWXF2UWtqaHVsczJxVjBYWnJsNXlD?=
 =?utf-8?B?ZFdHcTg5Mm5wQm1UTVRLR1RWTmpKdzZIbGtoaVJ1QnZmV3hCNnloQm5mRVR0?=
 =?utf-8?B?VEZkc1JjbUVVaTVrMlV1c0FENGFvNXA1U3NzSFBML2h2Vy9sQ282NmIwN3lO?=
 =?utf-8?B?Z0RjOWUweFBSVUlxUzdqRGx4M25RWWgranNEWWZ1QkFscHRzdFBNQTVzYzFY?=
 =?utf-8?B?QUd6N1pRT0RnVUcxUUZ2TjJnQzZvSE1QT2Q4dG56WEFsNkNrVU9hZGJRZ0xK?=
 =?utf-8?B?cnNJU29nSEEzaUxYclRWRTBMMFVvRHhxSVZkU0JrMFNPOFV4SzZPUmxFQ2ZZ?=
 =?utf-8?B?WFJRdHo4bGpkWnVybjY1bi9NR0cxQWNVTm9lcm96NS9TQzVKaHcyNTVmcHcy?=
 =?utf-8?B?UkVDbXNFVHgwbXhHbFZnYXZldVp4QlZGTXVjV0FUMkYyQkdqU2FJNEN6M1hR?=
 =?utf-8?B?TGZvU05xbXA1Q29kL3Jhdjd3TUdSWTZoeWo3TXVEZGg2NWlTZGYvT3RzTjJw?=
 =?utf-8?B?bkhoVUQyc2tXSDlUOVluakNJU1pjQkM3WEV2bm02bmRMSkpwNHhxQi9nRkI5?=
 =?utf-8?B?c2lZTUpiTnRac0pqZUZBZFNLZ0JwR1ljdHlrU0VYT1BQZnM2WlJhaWpmODVS?=
 =?utf-8?B?TktPMlRHb3RhSnVOTlpOSXpHNUF3Nlgxb0ZlaWNNTXpNNjkvMXlWS2g5Uk53?=
 =?utf-8?B?VzJIUlJOb0ZGbjVUeWY2WXFKTDd3eWtJcFRDUERQN0l1cWRBQSsxblI5N25u?=
 =?utf-8?B?dHF5VnJwc2pkVHNqTVFxa29qcExwYnFPdVpTY3E1L1JGQUJLay9XSndCcHQw?=
 =?utf-8?B?L00wTlV1YytOZ2ZYVElLOWJvN2pSdlNLUENFM2JTc08rZnhobENNOFRtd1dO?=
 =?utf-8?B?VlpUL3Q5bUpmK0dRY0NFTE44bnZKMjJjTXVaR2hFTUhwOVIwS2R3dHRqcG1p?=
 =?utf-8?B?NUlwZ2JiWjduVWUvc3JPS3hvNElnK1FOZWlQWHZicGNYdWI4YmFtVURaL2w0?=
 =?utf-8?B?d3I1Z3BVaW9EdTUzTWcrYkZKZnBtNzFTQVBIazN6ZC8vb2hhdHo0UHVKRFN5?=
 =?utf-8?B?WENFbTBwc1g2cGdqSVhkR0RKZkh2L2ZJWmdYaFhETE9SYTl6anF6YjAvTmY4?=
 =?utf-8?B?WW9QRTY3RFFPbnZVNDRxNFVhL0NFTEtGVXR2b1RHWWdxa0ZZbHVuYWFDVEQw?=
 =?utf-8?B?YjYwcGNLbUxLWk5xQ3BKamlRNTVCUHQ1dlFjai9YVWpIcUgxUzFoa2I1RzhK?=
 =?utf-8?B?T0djcUVSV1ZoU0V1RGZIUlprWTd1dk01ZXZVMmh6NEFFT0ZCMTN5bkh2MTVk?=
 =?utf-8?B?dGl4MDhCWStZVFF6YllvbTN0UkNSL3Q5Vko2Z0FvZm83MjJCQnJSRUh0aWxj?=
 =?utf-8?B?MTA2Z0RrbWxldWVHQjFqUWlvNU8rblgzK3ZRYjladitOMlEzdVhONkRJNmpB?=
 =?utf-8?Q?z8L3XkqPMySCs7wAOhAN9hff+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f92c6fe-e336-4d62-81f7-08dab5dd3ddc
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 16:31:45.7701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0dfQX99fuzM+KIpKduum6vFTaXTCWA+koc5XSt7Z0L8/cEUTMRAV0K9E64VXbU+GODWHb1NWkYAS75sQ8jCDLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7950
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/24/22 11:23, John Allen wrote:
> On 10/14/2022 3:27 PM, Sean Christopherson wrote:
>> On Wed, Oct 12, 2022, John Allen wrote:
>>> When a guest issues a cpuid instruction for Fn0000000D_x0B
>>> (CetUserOffset), KVM will intercept and need to access the guest
>>
>> s/KVM will/the hypervisor may
>>
>>> XSS value.
>>
>> Heh, "need" is debatable.
>>
>>> For SEV-ES, this is encrypted and needs to be
>>> included in the GHCB to be visible to the hypervisor. The rdmsr
>>> instruction needs to be called directly as the code may be used in early
>>> boot in which case the rdmsr wrappers should be avoided as they are
>>> incompatible with the decompression boot phase.
>>>
>>> Signed-off-by: John Allen <john.allen@amd.com>
>>> ---
>>> This patch is logically part of the SVM guest shadow stack support 
>>> series seen
>>> here:
>>> https://lore.kernel.org/all/20221012203910.204793-1-john.allen@amd.com/
>>>
>>> Sending this patch separately from the main series as it should apply 
>>> to the
>>> tip tree as opposed to the kvm tree as this patch is related to guest 
>>> kernel
>>> support.
>>> ---
>>>   arch/x86/kernel/sev-shared.c | 15 +++++++++++++++
>>>   1 file changed, 15 insertions(+)
>>>
>>> diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
>>> index 3a5b0c9c4fcc..34469fac03f0 100644
>>> --- a/arch/x86/kernel/sev-shared.c
>>> +++ b/arch/x86/kernel/sev-shared.c
>>> @@ -887,6 +887,21 @@ static enum es_result vc_handle_cpuid(struct ghcb 
>>> *ghcb,
>>>           /* xgetbv will cause #GP - use reset value for xcr0 */
>>>           ghcb_set_xcr0(ghcb, 1);
>>> +    if (has_cpuflag(X86_FEATURE_SHSTK) && regs->ax == 0xd) {
>>
>> IIRC, XCR0 and XSS are only needed for sub-leafs 0 and 1, i.e. this and 
>> the code
>> above don't need to expose XCR0/XSS to the host for ECX > 1.
>>
>> FWIW, I think it's ridiculous that the guest willingly exposes state to 
>> the host,
>> it's not _that_ difficult to do the math in the guest.
> 
> That makes sense to me. I think given that the XSS code here is tied in 
> with the SVM shadow stack patches, I'll submit a separate patch to first 
> address only exposing XCR0 for sub-leafs 0 and 1. Then I'll address XSS in 
> the next version of the SVM shadow stack patches.
> 
>>
>>> +        unsigned long lo, hi;
>>> +        u64 xss;
>>> +
>>> +        /*
>>> +         * Since vc_handle_cpuid may be used during early boot, the
>>> +         * rdmsr wrappers are incompatible and should not be used.
>>> +         * Invoke the instruction directly.
>>> +         */
>>> +        asm volatile("rdmsr" : "=a" (lo), "=d" (hi)
>>> +                    : "c" (MSR_IA32_XSS));
>>
>> Doesn't __rdmsr() do what you want?  But even that seems unnecessary, 
>> isn't the
>> current XSS available in xfeatures_mask_supervisor()?
> 
> Yes, I think you're right. That should make this change a lot more palatable.

That may depend on how early this CPUID leaf is requested. If requested 
before xfeatures_mask_supervisor is initialized, then it can't be used, 
yet. Maybe there is something that can be checked to see if 
xfeatures_mask_supervisor has been setup and then use it, otherwise read 
the MSR.

Thanks,
Tom

> 
> Thanks,
> John
> 
>>
>>> +        xss = (hi << 32) | lo;
>>> +        ghcb_set_xss(ghcb, xss);
>>> +    }
>>> +
>>>       ret = sev_es_ghcb_hv_call(ghcb, ctxt, SVM_EXIT_CPUID, 0, 0);
>>>       if (ret != ES_OK)
>>>           return ret;
>>> -- 
>>> 2.34.3
>>>
> 
