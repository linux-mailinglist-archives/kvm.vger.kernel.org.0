Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCB5557B432
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 11:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232126AbiGTJuw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 05:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238585AbiGTJuo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 05:50:44 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2058.outbound.protection.outlook.com [40.107.93.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B473911C18;
        Wed, 20 Jul 2022 02:50:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ji5sfsRJnLrpQLCTvEahjWb0b2Gz0i9PvtGsulEKqyCLwFE42Tl7mYY6hQLbI2ktP022tNU5CcvFV6co1bfKRnYqN9Kv40nGuLktOfu33NRP3X1zDTZrEj9NOwMhS6akuhu3Y7YNWYTp4DdxJhhTsVk7HHlzCYvsL9KdG7ZIcXNSZbwVZFoI8Ypenj9JhQavwBr8u4UTrjsZ8ECWaccoJtBYX0SkQ1R9rHgz3p+DLNkME/9qqusdomjFBJoYtJgipb6N4sI8OU4Rk+ofJU3/xFpxMrvuE1aHcvA00WugeIbxF3IS0bmBKJeNEHDKE9jn10g0c9qg5iOS8DcxvmDA1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1+E1+w2y/EhSZsZv93Qn3hFoWgYfqyiJXErKsRN0rnw=;
 b=V2NmlZOFTmMKTBt6VC8uaNn2BTPZ4/QnVtqOneka4vlpE3Oti+VwTR2XZrIbPArXwigKf2c0UlSf4kxgG/d6syXWWSpI/Cr01WXhbhnJ2eY4sazZUCfQfNFQVx2/oEWlf16vRZu6mo24UQBSEVAjkNpKgv3EkVFEjYgnMPHxo17JYsZd66zC49e78bXbUZQbMdWHcsc2F3MI5JgdoIIVg1/0bf3KZmixGfW9RH46gND13QCSg9xgqcaxG6+LbzIZPPkk+16KUFBfjVvQlwuWDcaxv6oVODJpIpeDDP4owMsP3fw8cdi0X0hsOjes4h3JWvKfe0dD723gC3uMUZVS8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1+E1+w2y/EhSZsZv93Qn3hFoWgYfqyiJXErKsRN0rnw=;
 b=Mh76pgetdT27mNOAX5ugHQRnWh9XLWMu9Vxgz2Z4NKv9tNhAR/CbajNsjxGzmKBW86Zg+4UChcQ56a9ETJuJTVHoxlmE9yPBDyqiIE8/ijZ11KjnwmovxSaR5jzxtrv9yVJ5kWMILnIMpWJmms97B3FyxphkB+kzQnBaQvdy5mQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 CH2PR12MB4821.namprd12.prod.outlook.com (2603:10b6:610:c::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5438.19; Wed, 20 Jul 2022 09:50:40 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::d4af:b726:bc18:e60c]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::d4af:b726:bc18:e60c%6]) with mapi id 15.20.5438.024; Wed, 20 Jul 2022
 09:50:40 +0000
Message-ID: <1d7f546f-a497-f580-6439-0a543afb26d8@amd.com>
Date:   Wed, 20 Jul 2022 16:50:32 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH] KVM: x86: Do not block APIC write for non ICR registers
Content-Language: en-US
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, mlevitsk@redhat.com, jon.grimm@amd.com,
        Zeng Guang <guang.zeng@intel.com>
References: <20220718083913.222140-1-suravee.suthikulpanit@amd.com>
 <YtWYL6mvN72kaDOi@google.com> <40b6f9e6-90c5-ca42-13d7-5e81ff4990c6@amd.com>
In-Reply-To: <40b6f9e6-90c5-ca42-13d7-5e81ff4990c6@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR03CA0094.apcprd03.prod.outlook.com
 (2603:1096:4:7c::22) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cb0d49b8-80b2-4426-eb0d-08da6a354dfe
X-MS-TrafficTypeDiagnostic: CH2PR12MB4821:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nLCUxsSUZd/1QkSsf7/p9CjRqeHNmZVXuZrAoqsCNg5oyQSgfZhEFMhXEPIBGci2cIxZd3786cprhaUU93WBwPhetR7jc7cX+kY/R99wDd906a1JocwKLMWy8ZQx+Cj5kmUyBvda3Cq5hytsnO4eKAOx0+SHiFC9U1/5yqI6+dp4mtYnPLBmeTwdMe3SHGAiAxfd6ZqWNs3yoE7BGNXfULTmI6YkTu7G+b1DpbCgpfcoptKXuEzF4ZJwKy7izi/zCO/mnL5BDi7DT+jUfdCV8t/DOXer1UJwOHjVhMbkQuYOOqjITSVT8ZR2eX6e5oW5EKAHx/uE9867o4fDgxXvRZcrHTzjanaEkX/4UPu0HInOBsra2DICNXjUrTWTUFma9fIACd+O2ZY/C2qflQUTHcyP96wwjJVc/JP8jrIfSBPqaoBiwrbmeRP7bIB4N4QglfszaH92yhJCidN1Zpb7Gu34xhdCnHZ4GC4iQRTunsLtQtzZkQpk3mpmpC2w9DXtLnTSEngbhfzoj9qLzU4VnKg0AWYQ7LbV8ICwezyxz7RqPFRBC2h0Y083Hyf/wWKSezSQWTNkHvbvN0heU8OoLmrSivuofBXz9T/dLVHSSM0IQvagn2jkhsft+n5fJkAEqUU4uQ9ppNgnUFz+I07Mbnh/UlgK1+fLWUFxdrSRuqMJfMHeCBuOUACqkJ7kucWdQbwvCsxhBPQIPNBpkfOhVq/gjbfUTXL4nlW0mgCVfqs5bqdtw1rn46etmbuxWnqh1rNTuYmaG9ylGt9Nfup/jMwqMMTKLD8djIPGVAlXATzJVppjRhszLiJJUR90j7rGMk9Mg2tzsYUIqk8i1lZQBQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(396003)(39860400002)(346002)(366004)(6486002)(6916009)(478600001)(31696002)(41300700001)(6666004)(316002)(83380400001)(2616005)(6512007)(53546011)(86362001)(31686004)(26005)(66556008)(186003)(44832011)(66946007)(36756003)(5660300002)(66476007)(8676002)(4326008)(2906002)(8936002)(6506007)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MlFKMXQ4bFNXTmJwRWU0cC9nZDFmbVQ2ZGhSK0MwenhEd0tSeElETVVxdURF?=
 =?utf-8?B?MC9oYTZDMXJOdXVsT3NqYTJuWTBPZlgrVDZyODdXeGZ2MURKMVI0Umdzckww?=
 =?utf-8?B?ZWZCRUdHZ3hKVld0ajRPOGZKVUQ5alo4dEI4NjVENExzU2s5YTFBN1BPVXYy?=
 =?utf-8?B?UTdzQ05Ld3FjUkVhODJzYURteFdVZlBySUdsNHFvdzE4VlY0ODJOSU4vbi9L?=
 =?utf-8?B?VllIaWNHMEJZbDkrYWFoRklBbVV5aUVGSXRuNDlYa1JjcS9vcnpWUit6TDIx?=
 =?utf-8?B?ai9uVXo2ak1GbGZYdDFWTTZ1UGVBaTRiaDY5ZEtyRnB3RDVUQ2RYQ3dKQjZ5?=
 =?utf-8?B?NzZtYjE0bU0wWUI3bDdBOWZ3OU5TZm5JbG9zRVdRKzVzOTZBRkUxYy9oOHlM?=
 =?utf-8?B?VmNzb2FRU0g3T0d6ZzhFNHBFUDNjNUpvdFhBQnhkdVlJVzE4OHR3Q0Q4YUlR?=
 =?utf-8?B?czhQaG54ZnJGTGZIWTZCUGVVV25ENUNoTytYZFhuajhudUpxbG94ZnlLV3JK?=
 =?utf-8?B?Q3JHU1RqbWdickorMVl0VDdYSUtNak5vUWxlYTlwNFJINURqaWROdTIwWEtm?=
 =?utf-8?B?dnVUOXVicHlSQ3JKN3dISW9hTVF4M0RVbFAxSzFUK0tKVDRGWm1zVERDRXJP?=
 =?utf-8?B?cC9taVdscGN3ZkpiU2ZrbUxJWUFyZFQwQ24xNHpoM2xZVXB3L1hNSWFYcFZ5?=
 =?utf-8?B?TFhVb1RLQk04dWJsSVBqRTZmSE5rRnlQT2VoczNHRXFJd21IaUdNbHd0V0Qv?=
 =?utf-8?B?dDVxQVJ6ODdZeXdhdVpRYmN4NlN1ZUdlYTMrZ0EzSkpsTk1xT3lKUVdqeHhK?=
 =?utf-8?B?YTN5S2tQVGxrZDFrQzdqd29DMmdhSkVnUG9TdXhBbng3MFBnWXl5bnZ5eEFo?=
 =?utf-8?B?V1o0UHJOY3NWWlhwRHdQRmhYQ0ppSXlJQVZhOHdhcDV2MGg0M2F4ZEwreFdQ?=
 =?utf-8?B?V0VQaFNrVVA0cVZwOXE3L09qVEErOGJ1SldGT1dvU3h0Vm1HdEQ5UjRpZGxV?=
 =?utf-8?B?bXRXUVVvRFRUVng4R21XQnpybmRURUNTUFFFblUzU2FST0hZNVdwOGk1U3lT?=
 =?utf-8?B?a1ptSVdwd3BXTmN6ZzNOOGRqc204S3VtU0lGV044Z2lEM1JoUk04TCtpdGdB?=
 =?utf-8?B?cWY4WmN1V3RSZFpEOHQ3NWNXajE1YkFPSDdvSWtaMDlPaW1ybWk1cDQxempo?=
 =?utf-8?B?bHlabDFUVGNXWkJac2FuaW00TUs1bmdZZ0YyUlFBZlViOU1JbkVVRTRodHZR?=
 =?utf-8?B?MURoWm5wN1dlbXdPSU9YbmNDRDhBYS9DRXNiVFd5Zms2YWU3RHQrZzB4d3RV?=
 =?utf-8?B?NDlZOGtHWTRRQURNTVBYVTZTY2J4aGM0WGlhL2tsalJhQ2tMcFZPcytQVHlD?=
 =?utf-8?B?MTk3SzhQVGZ5eXJ0NzlYUThaSldTS1UzaXpwbE1kU1BUZjhUWjBudVpOemlK?=
 =?utf-8?B?V25RTGdSMnBGeTZlbG1PV2dmekttcGd2RzUxWDk2b2NJV2RuNjlSbjVsazhR?=
 =?utf-8?B?V2RITjBLUHY1ZTJKYUJDdEE2Si9PUExCNDRQOEpjc2xNME5NNnVFZ0pSL3JN?=
 =?utf-8?B?ZVRqOEkzc3B5VW5VelJKUldvTmdHODA5Z2x1OHdyTDlpMkVTblVkYUxNRnZk?=
 =?utf-8?B?Z0FYNGdYQjJodE1pWldTUTRmamJQSHZYMXdBa2h4V3VmQkZwSHg0eG5yQS9p?=
 =?utf-8?B?M29hUU1QbzZKcmhnTXRtcEFUdzFXSFJiVDlVaFplUk9JY1g4amNZSE1weFZR?=
 =?utf-8?B?eFVFSUw3enF4VDNGNzI3bWx2RkNtTmZncktoS2d5U2JiemptUVFzYVM1WWZj?=
 =?utf-8?B?UzVIbE9odmhRa0VGdXh6enVncFozVWR5S1l6TEhJaWYyaE5JVDZIRXVVd2Rm?=
 =?utf-8?B?RURpQzVCYTBuUTg1YXY2NTl5WUZWSHY4K0VuSDU2UUo5aStmem5hRDdiclNR?=
 =?utf-8?B?Tm1qWGdFNktuRFdBampxTVAwQStORkRjTmpGc3pxZHVMRTVHZVhjOXVXUHpC?=
 =?utf-8?B?azh4TkhVR3dMeXFtWDYyNXFzeTVxSjBKb1BYSStGamROZ3BNbHBjblBLUS9Q?=
 =?utf-8?B?bW92eUNoMEMvR1cydTZhc2NiTk0vVlROWlN1UTNDVmRaK1dqMnIzRnRFUEN1?=
 =?utf-8?Q?fzJO72GgfTxmvmVXjmyoouzU0?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb0d49b8-80b2-4426-eb0d-08da6a354dfe
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 09:50:40.4459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7dRMaxnzUDWN+v7YO5ZEQ6hfFRV/TRAm/1eBCuICemCn/b/p2PYef2YMoi66tJ6leUtMDBPkGm7KYmbEse/Q+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4821
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo / Sean,

Please let me know if you want me to send v2 with changes proposed by Sean.

Regards,
Suravee

On 7/19/22 10:24 AM, Suthikulpanit, Suravee wrote:
> Sean,
> 
> On 7/19/2022 12:28 AM, Sean Christopherson wrote:
>> On Mon, Jul 18, 2022, Suravee Suthikulpanit wrote:
>>> The commit 5413bcba7ed5 ("KVM: x86: Add support for vICR APIC-write
>>> VM-Exits in x2APIC mode") introduces logic to prevent APIC write
>>> for offset other than ICR. This breaks x2AVIC support, which requires
>>> KVM to trap and emulate x2APIC MSR writes.
>>>
>>> Therefore, removes the warning and modify to logic to allow MSR write.
>>>
>>> Fixes: 5413bcba7ed5 ("KVM: x86: Add support for vICR APIC-write VM-Exits in x2APIC mode")
>>
>> This tag is wrong, I believe it should be:
>>
>>    Fixes: 4d1d7942e36a ("KVM: SVM: Introduce logic to (de)activate x2AVIC mode")
>>
>> And that absolutely matters because this should not be backported to older
>> kernels that don't support x2avic.
> 
> The commit 5413bcba7ed5 is the one that modifies the logic in the kvm_apic_write_nodecode().
> I understand your point that the 5413bcba7ed is committed later than 4d1d7942e36a and being
> affected by the change. However, if there is a case that only x2AVIC stuff is being backported
> w/o the virtualize IPI stuff, then this fix is not needed. Hence, I would say the fix is for
> the 5413bcba7ed5 as specified in the original patch.
> 
>>> .....
>>>            */
>>> -        if (WARN_ON_ONCE(offset != APIC_ICR))
>>> +        if (offset == APIC_ICR) {
>>> +            kvm_apic_send_ipi(apic, (u32)val, (u32)(val >> 32));
>>> +            trace_kvm_apic_write(APIC_ICR, val);
>>>               return;
>>> -
>>> -        kvm_lapic_msr_read(apic, offset, &val);
>>> -        kvm_apic_send_ipi(apic, (u32)val, (u32)(val >> 32));
>>> -        trace_kvm_apic_write(APIC_ICR, val);
>>> +        }
>>> +        kvm_lapic_msr_write(apic, offset, val);
>>
>> Because this lacks the TODO below, what about tweaking this so that there's a
>> single call to kvm_lapic_msr_write()?  gcc-11 even generates more efficient code
>> for this.  Alternatively, the ICR path can be an early return inside a single
>> x2APIC check, but gcc generate identical code and I like making x2APIC+ICR stand
>> out as being truly special.
> 
> That sounds good.
> 
>> Compile tested only.
>>
>> ---
>> From: Sean Christopherson <seanjc@google.com>
>> Date: Mon, 18 Jul 2022 10:16:02 -0700
>> Subject: [PATCH] KVM: x86: Handle trap-like x2APIC accesses for any APIC
>>   register
>>
>> Handle trap-like VM-Exits for all APIC registers when the guest is in
>> x2APIC mode and drop the now-stale WARN that KVM encounters trap-like
>> exits only for ICR.  On Intel, only writes to ICR can be trap-like when
>> APICv and x2APIC are enabled, but AMD's x2AVIC can trap more registers,
>> e.g. LDR and DFR.
>>
>> Fixes: 4d1d7942e36a ("KVM: SVM: Introduce logic to (de)activate x2AVIC mode")
>> Reported-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>> Cc: Zeng Guang <guang.zeng@intel.com>
>> Cc: Maxim Levitsky <mlevitsk@redhat.com>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> ---
>>   arch/x86/kvm/lapic.c | 21 ++++++++++-----------
>>   1 file changed, 10 insertions(+), 11 deletions(-)
>>
>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>> index 9d4f73c4dc02..95bb1ef37a12 100644
>> --- a/arch/x86/kvm/lapic.c
>> +++ b/arch/x86/kvm/lapic.c
>> @@ -2283,21 +2283,20 @@ void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
>>       struct kvm_lapic *apic = vcpu->arch.apic;
>>       u64 val;
>>
>> -    if (apic_x2apic_mode(apic)) {
>> -        /*
>> -         * When guest APIC is in x2APIC mode and IPI virtualization
>> -         * is enabled, accessing APIC_ICR may cause trap-like VM-exit
>> -         * on Intel hardware. Other offsets are not possible.
>> -         */
>> -        if (WARN_ON_ONCE(offset != APIC_ICR))
>> -            return;
>> -
>> +    if (apic_x2apic_mode(apic))
>>           kvm_lapic_msr_read(apic, offset, &val);
>> +    else
>> +        val = kvm_lapic_get_reg(apic, offset);
>> +
>> +    /*
>> +     * ICR is a single 64-bit register when x2APIC is enabled.  For legacy
>> +     * xAPIC, ICR writes need to go down the common (slightly slower) path
>> +     * to get the upper half from ICR2.
>> +     */
>> +    if (apic_x2apic_mode(apic) && offset == APIC_ICR) {
>>           kvm_apic_send_ipi(apic, (u32)val, (u32)(val >> 32));
>>           trace_kvm_apic_write(APIC_ICR, val);
>>       } else {
>> -        val = kvm_lapic_get_reg(apic, offset);
>> -
>>           /* TODO: optimize to just emulate side effect w/o one more write */
>>           kvm_lapic_reg_write(apic, offset, (u32)val);
>>       }
>>
>> base-commit: 8031d87aa9953ddeb047a5356ebd0b240c30f233
>> -- 
> 
> Tested-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> 
> Suravee
