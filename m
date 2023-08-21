Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1BC783478
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 23:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbjHUUYP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 16:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbjHUUYM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 16:24:12 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2087.outbound.protection.outlook.com [40.107.92.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26DF7101;
        Mon, 21 Aug 2023 13:24:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kYsuDg71AJ+sMdII2fYAbH7Xz9OGhGep8UdaJ/44olsRrcCiZaO1oUgp7wLdxhQx8ct0jeiwKWA1uJC2PIddF+/eBW3/XK19DHnv0lkDl110CE9fJ/mm2UXUKEkzT3DiQ3AIylBMWRWN7IxDHo8JhpavWWm4o5+K/9GNec8p6Eud1bNl4xOyz3uJcCx5EHcQL0bVtzh45OhxF8y0kxak7Rzvl3yeiSUcKPG7rJXPJVPiEd9KgeUbDSS4Pj1fHSQL5hW3oci+inD0blcM2R/WvVlA5+XRp7PXeNAtejBFqEv/o2RF6Gu5tRuNJB4PhpZHWgTwzFB0l/d6pMEzklkzmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LVR4jTTo8Bt9J9ags44VtcQUyN4ahE+yrvWHnwtqRGA=;
 b=W8ZiElbDDFj6LUXCzwQcnh8yDKkUfCI+j4V+eTSA738L+g7xSmVYq0uTntBeJgqxqGsus2bdDzuy9Cbj7dJD5O1oOBg81cQUP8QD5/3BVXGgf+xOBilmZNNHZeV7lySCEsaE9q6cV1wTarSry+xWnl44/b9vH9ml3zkMw0yDOG5IdLTxKzBYuu/S9sJ/rv8iA+eUT9gd2yZZWGzdZtZ42J9aFKZOBlBRXSbjN0U23FmYuRje6hIVJck0hKJ2CmA/vvg3ZPRfizt9LZginkdzCnMHLxXL+jhTWlvFTRqgHYBk19s0p7oAbyPDTfXwx4gPkEWIwNESTToUYAeJ2gTl0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LVR4jTTo8Bt9J9ags44VtcQUyN4ahE+yrvWHnwtqRGA=;
 b=0l74L9RBX5SAvRF61OLu5EuIDxRo2f4TlO2fUlvTo75ulE/d4GlxWHqeVooPnT76UpBMNCYvr8STRBgbLO21Q1w7WXzwGvb45epWTrqZEtQ5yoXDDb1PGwvp+73d6CKXPuT8zP6pXQA7s1Pef+nBPKoWlcbxPr+bpOupwmYtLdg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by MW4PR12MB7167.namprd12.prod.outlook.com (2603:10b6:303:225::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.24; Mon, 21 Aug
 2023 20:24:05 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d267:7b8b:844f:8bcd%7]) with mapi id 15.20.6699.022; Mon, 21 Aug 2023
 20:24:05 +0000
Message-ID: <303d2eb7-d337-8516-1120-13c4c2443d2e@amd.com>
Date:   Mon, 21 Aug 2023 15:24:02 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] x86/sev: Make early_set_memory_decrypted() calls page
 aligned
Content-Language: en-US
To:     Steve Rutherford <srutherford@google.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David.Kaplan@amd.com,
        jacobhxu@google.com, patelsvishal@google.com, bhillier@google.com
References: <20230818233451.3615464-1-srutherford@google.com>
 <08418fc0-839a-f2fb-1c2e-b4f077d2647b@amd.com>
 <CABayD+cw3s1UDSN7oR4gWfRT4-snWEqOgAN-y4rzOpe-8D=KdA@mail.gmail.com>
 <2a391d50-d474-eec5-76ea-e5dc5590609c@amd.com>
 <CABayD+f3BLjg4ekO=b4yweqsV4-kA3nfDjKh7MieMh+=zvkA=Q@mail.gmail.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <CABayD+f3BLjg4ekO=b4yweqsV4-kA3nfDjKh7MieMh+=zvkA=Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA1PR04CA0012.namprd04.prod.outlook.com
 (2603:10b6:806:2ce::15) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|MW4PR12MB7167:EE_
X-MS-Office365-Filtering-Correlation-Id: 7108e812-17e5-4019-3f37-08dba28490e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rA5dLjEnvGtt2gxoXfDQ7BSzk0vBqnObY7DCgRvgjX/U6ORUXfDw/Zs+Ho18INHpxG0kG/BkwgXVsg3QUcDfN1Z9AVPg4XEIgPmFJd1RGG7kSRieyqjoLjXsxsuV1t7SQDVLmqD/DcjwkXJcsqSlBEMrLoCKHo+DCwUaAPzucYTZMdroNHKiyAPnDFjvwFv3ftxkd12s2GZJLfR3TSuA5la8Oan9q/c/FBOhspKfQ0z1+pP+GilpgCjFXVLMWYqNe3SRDlUts244gyPRRBZzzbwtgWou8Pfo35KF2/RAR2e4EauEuEUb1QvDx6iOviYX/XVvUM/Vw3zAGbikUf8zUXoYHE4iN6HbAbS6uJP/2PiMqZBZ81BuJd7Ozd0xeRsa2lMDAmqW/HQL/wntW28aPyLXWa74d+HOLdm4c/3340nOmOtNCrQo66bqdA9Xg5+aWijNFuu7BTNDLlq/rNx98vHMzrpI0dC+MbG1sCv7Vn3T9660AgO/m+qxvybgptry9/NOaEh3Riua6kpdj+9/TNiM1sjbzhic2R01RucZM1vZm1E/WMTleSxwgJuLe1BgIuTm75Ag/bp2IbFrbRrpeEf0TC7wM77z4u6d2Jyq+YKbqiqXQCgrEdC+VOb4LxO/zayk98eoWI3Gg7t+bQ2d0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(136003)(346002)(39860400002)(366004)(186009)(1800799009)(451199024)(54906003)(6916009)(66476007)(66556008)(316002)(66946007)(6512007)(8676002)(8936002)(2616005)(4326008)(36756003)(41300700001)(478600001)(6666004)(38100700002)(53546011)(6506007)(6486002)(83380400001)(2906002)(7416002)(86362001)(31686004)(31696002)(5660300002)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z2VPdWhZRmZCQURCOTlBNlVrdmRxMzdTM3FOL0VKOWsza1dZVmNnYTlIM2U2?=
 =?utf-8?B?VGdENDBPUzJaQXhSbC9wTkRpdXpGQ1ZveE5DK1ZhaEN3dFpFbStsZXdOMWQw?=
 =?utf-8?B?OVVnNm9iVXNERDhpVm1TODQwMjhjTFE5N0p5NmJEL2oxc3JTTGp3TFBoYVE1?=
 =?utf-8?B?OWxKY0ZxVEJHQXVkUHdDSGQyRmdyZHNrblg3SGlQbFZ4UDQ2bStxUWw4MnYw?=
 =?utf-8?B?MldSL3EwYTc4YVV3UHJtc216VUZKY2JOdlRQQ24rUm9HL013U3JaK3U2V2J5?=
 =?utf-8?B?Z2luRmtva0wreHc4WGJGRU4zNGppV3E3c3NudGNFc21YbmdJS0lmR3FGeGpJ?=
 =?utf-8?B?WFpjY0dSMXFkaVdkR2Q3UExta3NKY3ByS2hWU052MElIdEt5cXphYlQwRkZD?=
 =?utf-8?B?Z05GaTl0bjhaVGhDME5UdTlHUGVNWEZmRUM1VUFhRFVkam50a2hFZXF1S2FC?=
 =?utf-8?B?enBhU0txYlNzaUd5K29xS3hFK0laekEwZ25sSUNYNFdZSGlpNURLaVNVOWpX?=
 =?utf-8?B?aHVjWk12RnR6dlNOVENSS216ODRodWp3OUwzMUY3NmczUlRGWkpwY0NRZUZP?=
 =?utf-8?B?cmhSZEFmWk14UEwrWXcxNk52Vkt2OTJxRFUwUmY1OTl3V2xyclBoaDViUmEr?=
 =?utf-8?B?TjRpWk4vRjdnbDN0bXg0NW80VzM1eDcxakNjWGVvSklGT25PZmhnS2NhOGJl?=
 =?utf-8?B?ejlWOWE4cEwxMGlVUTZpOGY1ZGpuK0RteUZ5U2FoWXhuVS8vWkIycCs5OUJO?=
 =?utf-8?B?VjlwM1p6ZWFjSVBlYjM2Slc1Z2NzLzRPMlEwK2dNQjQ0bDhkTlBmQzBZL3NF?=
 =?utf-8?B?cUUzSmJtUURoQlpSY0Jjd3NPcnBmNWxVTDBZY1RJcDdsY2RpR09ENmVBU1lU?=
 =?utf-8?B?S2tzb1ZzMVpjMkErR3Rod1kwRTAyd2JDVVpsRkdibjVsbUJoc0JNY0FKNTFS?=
 =?utf-8?B?U0NrWXdNTTZCNlMrWmd5M2ljSFRjbENHZjlTTzNMalN1MWV4cXZ3cFNmQVNG?=
 =?utf-8?B?RlJVSFhQd3dhcGNva1BYaTVRMFdTdmJvcFdZTEFHdDVzdEo2bytZTHlKSVhT?=
 =?utf-8?B?WXMzOVRrV3FjMC9mN1V4Sk9iRDUwakdxNitSc3ZKTjFCVnV6RjN0NU0wYkJ2?=
 =?utf-8?B?MGJMa1k4bkZDSXFDdFZQUGJzcjA1c3lSQ3luWXI2M2RhVUJUVWNNTWNFVkU2?=
 =?utf-8?B?cjBqWm9hdGNkNHJxYzJKWVQ3a2NNTFJmKzBZcGJQTzVVMWVzRXc2UUFrckc0?=
 =?utf-8?B?VkJzVGxMZTRGM2I2UTAxaUJMdzExOGpsL2N2MHYwZis2ekhGSnpDMFVSd1JE?=
 =?utf-8?B?V1J4ZTg4TS82akRrVlZOQVFuZjhyb1l1aFYzU3F0ZjMzd3luZ0cxaW9mNWg1?=
 =?utf-8?B?QmczVjBvYlo5aE5kRU9MRUh2dnFwNytrU3IwOC96T1N1UTJTaDZpUG9yY3cy?=
 =?utf-8?B?M0FqZ1hRU3FyeUVSejlwSS9KZTlBKzdvekZiR3U2OUNCbWxoQWdOQ2xWQ0hw?=
 =?utf-8?B?YXZiNitGYzZNNUh0VVJsbnRENzBNSDBmNE9xaEQ1Y0wwRjhxSWVXdGQ1TjZT?=
 =?utf-8?B?WWZjNXE1SWN1ZXFCdXFzU3g5NFpSRGp2dGxPSUJhV043RnRETDVRWmU0bTUy?=
 =?utf-8?B?NFpVTXF0d0k4REJOcmJWVWpJaWQ0WmpSbkM2KzZvY1JqY0NmcUlyWUZtNXdV?=
 =?utf-8?B?R2Z5am0rRDlobmY5azJuTEJLQjBFOUxBOWNHY0hNZzdDejZodnlXT1ZmMTho?=
 =?utf-8?B?SFM1UGladjc3M1RjMmZERjEvZWRNRWpMd0JuaGQ4QWhRRWhUYW5xWFFzazVT?=
 =?utf-8?B?MHdEb2pkTkJOSDUzTEVJUUhIUlVIdGkxTm81OHBrYjVUcG1lemhJTkRwMi80?=
 =?utf-8?B?YXNvUFJId1l1WVhjaDdYYVVQM0RlNS9aQ0c3aFZVa3dPcHd6eHNNK2lLdHBK?=
 =?utf-8?B?ZU13a1JnVTdEYjZybTViUkRwNlJkSkdEWGIyODlMK25VVVplZGJtSmhNSHJ1?=
 =?utf-8?B?WlN4cWxVQkZRVmJWaWczdm9vODFnY3lVQ0t0ZTlwdTA3NzFWS1V5M0hUWVdB?=
 =?utf-8?B?MTR5cmtrWmk1TXdRSitFQ09TdEhWWDB3U2ovZ2lyeU1vVjV3dlgxREttTjg2?=
 =?utf-8?Q?NFWxOqCOegLGINtDYpY2C1R8z?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7108e812-17e5-4019-3f37-08dba28490e4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2023 20:24:05.4976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wPYBe0nkk+KbzzxbMDBPesIdxpybne8rLndu3lmevSF8QeaPPDE8qBhmT+jPJvUuFsCCeF6kKW2/PaXq/Evdbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7167
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/21/23 14:25, Steve Rutherford wrote:
> On Mon, Aug 21, 2023 at 11:54 AM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>>
>> On 8/21/23 13:15, Steve Rutherford wrote:
>>> On Mon, Aug 21, 2023 at 6:10 AM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>>>>
>>>> On 8/18/23 18:34, Steve Rutherford wrote:
>>>>> early_set_memory_decrypted() assumes its parameters are page aligned.
>>>>> Non-page aligned calls result in additional pages being marked as
>>>>> decrypted via the encryption status hypercall, which results in
>>>>> consistent corruption of pages during live migration. Live
>>>>> migration requires accurate encryption status information to avoid
>>>>> migrating pages from the wrong perspective.
>>>>
>>>> Hmmm... I'm not sure this is the proper fix. The code is actually doing
>>>> the right thing from a encyrption/decryption point of view by checking the
>>>> c-bit for the PTE associated with the virtual address and the size
>>>> (possibly crossing page boundaries).
>>>>
>>>> I think the problem is on the call to early_set_mem_enc_dec_hypercall()
>>>> where it doesn't take into account the possible crossing of page
>>>> boundaries and so can under-count the number of pages, right?
>>>
>>> Right now, if you request decryption of e.g. a non-page aligned 0x40
>>> byte structure, it rounds the 0x40 bytes up to one page, and then
>>> hypercalls to mark both the page it's on and the subsequent page as
>>> decrypted (since the rounding stretches the structure onto the next
>>> page spuriously). The arithmetic in the combination of
>>> early_set_memory_enc_dec() and early_set_mem_enc_dec_hypercall() are
>>> correct if they are called with page aligned vaddrs (non-page-aligned
>>> sizes are fine iiuc).
>>
>> Ah, right, correct. It is still related to how the page count is
>> calculated for the hypercall, though, right? The encryption/decryption
>> operations function properly.
> 
> Yep! It's just the hypercall that behaves poorly in this situation.

Ok, cool.

>>
>> If another caller of early_set_memory_decrypted() gets added, it would
>> need to know to do the same thing. So I just wonder if this wouldn't be
>> better fixed in early_set_memory_enc_dec() by using a page aligned address
>> and proper number of pages when calling early_set_mem_enc_dec_hypercall()
>> or in early_set_mem_enc_dec_hypercall() where it would take a size
>> argument instead of a page count and does the proper work to get a page
>> aligned address and proper page count.
>>
>> Also, if it is the hypercall that is causing the issue, should the Fixes
>> tag be 064ce6c550a0 ("mm: x86: Invoke hypercall when page encryption
>> status is changed") since the problem is around the hypercall.
> 
> Fair question. I was torn about where to point this, since either
> fixing up the value inside early_set_memory_enc_dec() or fixing up the
> per-cpu callers is correct. The non-early version
> (__set_memory_enc_pgtable()) calls WARN_ONCE for misaligned addresses
> under the hood, so I thought the early version should have the same
> contract (though, obviously, this lacks the actual WARN_ONCE). I can
> re-upload with a WARN_ONCE or with the masking moved into
> early_set_memory_enc_dec().

I like the fix for the hypercall being in early_set_memory_enc_dec(). This 
way the behavior doesn't change for existing callers and doesn't require 
adding a WARN.

Thanks,
Tom

> Thanks,
> Steve
> 
>>
>> Thanks,
>> Tom
>>
>>>
>>> Thanks,
>>> Steve
>>>>
>>>> Thanks,
>>>> Tom
>>>>
>>>>>
>>>>> Fixes: 4716276184ec ("X86/KVM: Decrypt shared per-cpu variables when SEV is active")
>>>>> Signed-off-by: Steve Rutherford <srutherford@google.com>
>>>>> ---
>>>>>     arch/x86/kernel/kvm.c | 14 +++++++++++++-
>>>>>     1 file changed, 13 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
>>>>> index 6a36db4f79fd..a0c072d3103c 100644
>>>>> --- a/arch/x86/kernel/kvm.c
>>>>> +++ b/arch/x86/kernel/kvm.c
>>>>> @@ -419,7 +419,14 @@ static u64 kvm_steal_clock(int cpu)
>>>>>
>>>>>     static inline void __set_percpu_decrypted(void *ptr, unsigned long size)
>>>>>     {
>>>>> -     early_set_memory_decrypted((unsigned long) ptr, size);
>>>>> +     /*
>>>>> +      * early_set_memory_decrypted() requires page aligned parameters, but
>>>>> +      * this function needs to handle ptrs offset into a page.
>>>>> +      */
>>>>> +     unsigned long start = PAGE_ALIGN_DOWN((unsigned long) ptr);
>>>>> +     unsigned long end = (unsigned long) ptr + size;
>>>>> +
>>>>> +     early_set_memory_decrypted(start, end - start);
>>>>>     }
>>>>>
>>>>>     /*
>>>>> @@ -438,6 +445,11 @@ static void __init sev_map_percpu_data(void)
>>>>>                 return;
>>>>>
>>>>>         for_each_possible_cpu(cpu) {
>>>>> +             /*
>>>>> +              * Calling __set_percpu_decrypted() for each per-cpu variable is
>>>>> +              * inefficent, since it may decrypt the same page multiple times.
>>>>> +              * That said, it avoids the need for more complicated logic.
>>>>> +              */
>>>>>                 __set_percpu_decrypted(&per_cpu(apf_reason, cpu), sizeof(apf_reason));
>>>>>                 __set_percpu_decrypted(&per_cpu(steal_time, cpu), sizeof(steal_time));
>>>>>                 __set_percpu_decrypted(&per_cpu(kvm_apic_eoi, cpu), sizeof(kvm_apic_eoi));
