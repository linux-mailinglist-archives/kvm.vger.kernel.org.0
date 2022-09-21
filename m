Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95A135BF587
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 06:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiIUEnv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 00:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbiIUEnt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 00:43:49 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2052.outbound.protection.outlook.com [40.107.94.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51C757E837
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 21:43:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e6CdPBMPnaNTgla3g5TTc1L9L/kj9Gt6VgNinzld0iwWfhCg8uBT4tsgJzqRbf9rxhUU2hU8hP4Fd+WD3EgQPmjkTsFDjMoVBNQEvffdPHMUibh2j0J6X3TuA+dO5l3V5qMUAheZsOJnKr2C2NUuSihfzEcqvcFSpRmD54VEjh1+J9S7SclUNMpZLOu3x+kFMWVgwPUYBcoiywEvtUbr46LrpS1TvOV4sSH133Ikmw8JBpOI8petxARHWqSZ+SZzPJKQYCnhsIpuObaM0WNvGPc9il5kcKdUSsMLQGxhQ2FMYFDaj0/ukjD13d0gRraLT1ivBryO5+c/pX9S4xad2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4BUr5aNF3ctKPGXjDdd5vjhMvMVPdos1SW9wBgsxvro=;
 b=VILYczID8dW5q31DIqNbz93RUio4z/zyUZSzcQOnLxmdgsA8rvX+GDWHtXX7FnrTdVOJHnopD3B5PLJ1Xq/3PM3aF2zGDFi0qeoMBw63G1RlQDJEwra3ljXU8C83bTjKfDdAPxMMriRtkJ9Q1o7+ZnpaPvGkhyJS0aLflm5jZG8+O/CAIDAF2NQvVBgH+hWVIjKSrAb760cp/r90KjxFd6ykFe8SN6oFyLRzdauc7mirZpptUDiEN3p6OHEJn/0F2CHcuXXrhT9N+WIyRQjVhkA2CKL73o4Y4BGAmO/PPPSnOKb7CZYspjv9z3hWdnzild2dchtTbaT0MqLh8OwNYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4BUr5aNF3ctKPGXjDdd5vjhMvMVPdos1SW9wBgsxvro=;
 b=xVh2bOcw3a3l2jnPYfjVF7p0POSjdeSYis1+YeqXez4pkm5ROwYfsyohxVHkyzyEgUDRQexpREj8+2OblYCJr+EhnRZqyFCZn4OYqRT/7TfHBDZF1YVdH1DCMTjTW2mtajqHdvMlmQyiAe3+kdC/KZ6wYO5MhaXkCpKmC0yhYBA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 CY5PR12MB6033.namprd12.prod.outlook.com (2603:10b6:930:2f::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.16; Wed, 21 Sep 2022 04:43:44 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::85c7:62a1:1a09:5f3]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::85c7:62a1:1a09:5f3%4]) with mapi id 15.20.5612.014; Wed, 21 Sep 2022
 04:43:44 +0000
Message-ID: <13ff8157-7620-bf3e-202b-f087abb72233@amd.com>
Date:   Wed, 21 Sep 2022 10:13:33 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH kernel] KVM: SVM: Fix function name in comment
Content-Language: en-US
To:     Alexey Kardashevskiy <aik@amd.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "Roth, Michael" <Michael.Roth@amd.com>
References: <20220912075219.70379-1-aik@amd.com> <Yx79ugW49M3FT/Zp@google.com>
 <699404b6-dfa7-f286-8e66-6d9cadd10250@amd.com> <YyAlVrrSpqTxrRlM@google.com>
 <1b766883-23a9-72e6-b7ee-f7473bf6b096@amd.com>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <1b766883-23a9-72e6-b7ee-f7473bf6b096@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN3PR01CA0129.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:bf::8) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|CY5PR12MB6033:EE_
X-MS-Office365-Filtering-Correlation-Id: 076a4c02-30da-404c-3f35-08da9b8bdd6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 08UI91F4euxY4j5xgNN1W4XCLkqmWAwoyWA9qv9JXH7iWKfMqCBD+F3f9vtFYFxzYx4Snfah97jNiWZ9Np+YVHP4gR+53TrDCmryW7wn5qU6NqiQ5u1zhUxHQ+kxDaVaq2XALGu81HdlKJOaWwK+EDJXHW49GNyRICfpUJBPL5K9uKC9AKzGQevJSyNwh1Yfle6+jJYDTJg0Kcd+oNiXMGRcpFJsSpZWrM9n1KGiPd90z1evN5aUZMf56hjbSXfCu+XoWopQRTI5Tg4NzN1eDx6w6HLFqHfn+Fns0jI8cAnM2K8rAUDZ6VRaJQBD+rabfMHn4aoaevMbKVb4ToG6pEEfpQlTHMscYwj9sztuXfnoBXgOwQ2Ay3zWU2SGH53Fpn5FJkWYvQjhaYEavj04iyff99ywFlYpxtvzSP5HTd9U+t/fpqya5xv4JnbfeSU83FcLtng+d7xt+v3kE8Z1bJ7BJ2/vq1EgNQ0I2eOqVfVzcj/eveHyMEzILmuBeojlkBN7v5PVAuQ2hLE14HXUWYdmkvwo8cZx7bryBlNiktKV1K7gpbrnQ6Xuyjf76qs0rSlAwq+9bOYP0BsG+kCDvuV9gQxqPNm8Bj/zZlyOOOZaDVDvfZnZz2hR6q4DQ3sAd5a+5EeT/7+Iq1xZOzyRELlWo7W/aOeF4Bzgk3Lo8qpXVPcNnoRWt5suUQeFo8hj73t9GFhTrwE1ec+s79Bmr0fPsKvmJcEjjs5533Be6uYHusY30cMRRL+PxIJvqcYoEtRt9NR3H9YfpE0ZrY39Irj7uI+9zXXa8Oln0JTEwsA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(366004)(39860400002)(396003)(346002)(451199015)(186003)(31696002)(83380400001)(41300700001)(38100700002)(5660300002)(2906002)(8936002)(66556008)(110136005)(54906003)(8676002)(66946007)(66476007)(316002)(4326008)(6506007)(53546011)(6666004)(6512007)(26005)(2616005)(478600001)(6486002)(36756003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WmY1M3pqQSsxRDhUeEdwNjByTzBHY2R1UGM0VkVKbklOL0pRZ3VXbFhCRzVp?=
 =?utf-8?B?L3dqMm9nVlFuUGNOeGd2RWRWc2YzYnRwVGdCem9Uenp1TUlsakcyOE9UQTRw?=
 =?utf-8?B?Y3NhVTdaOE5LVitaSTJ3M3BOUlQyYjUwVU5jc2tmUlBhd3BvSHEvU1hoK09B?=
 =?utf-8?B?cXBnWFcrMEZ1SkdWRTFsc1dpbVQxdVNCZmxSUHZueVZRQ0dDTVlHOVVYMmRK?=
 =?utf-8?B?TFBCcXlTV21BNHk4SzY0S3pDMDNXUll0cndGYURKekpXU0k2V0Q1eEdDSGFu?=
 =?utf-8?B?ZFFwRnQ0U3hMb3M0amt6YlZaRFZJUmxlTEtVMldsTUt5Ym01UERBTUxGNUJs?=
 =?utf-8?B?OFJLKy9wVm12VkZhVVZvWk5DOHpGbVlhaENUSzBxYzlybERYV2RBOXNIT1dJ?=
 =?utf-8?B?MUU3TTJ5M29WU24rcEpyQ0FLblhHTnljWjZDZmpJcEM1SE56Uk5KcjBvUDJl?=
 =?utf-8?B?ZDR2OGZoejA2MTgycmpJNkVwWllseFIybjZHaGZYRlRPVVp1cGZZR3F5TkVt?=
 =?utf-8?B?Nk9IcjM2bWRxVDVSSVY1NGtObjJldWVscDNXeWhIUER6aFRkNmZSam9mNUdr?=
 =?utf-8?B?Y3hDZE1VL1NjN2w4RXRBT0U1cmEvdC9jL2ZBZjBNSDRsOVBCUlhPMFdlbExZ?=
 =?utf-8?B?akRnYlZya0lIbE9wT21VQ3hpL0dsYlhhUjNudkVONlpHbzUxTTdycHRUb1JN?=
 =?utf-8?B?MnZCRVgvUmVsMEx0NVNiWllVMnA4Q085elMvY1VSck9qY3RsSG5vc2xnWHlT?=
 =?utf-8?B?cnQyYkt5OFJRVWhBQ1ltdnFWYXVyRjZDWk51dS81dGoxaDFBL0s4YTJUZCtx?=
 =?utf-8?B?U1dSLzBHcjBobUk5VkRyVXp2WXBDdmkxQTJUNVVqRHhoVWdtZjdLN2dHenly?=
 =?utf-8?B?SWZhNkFMWmJtL0NFWHIyVDZWZ1NBNjhPOElvSE5MTkZrSzJ4VFJKbUltdm9I?=
 =?utf-8?B?TlRmZG5zUGtlUmFRZGRtaXJHbUJ3U2F1Q0RlNHAvTHg0WkNRVW1IOHNicGNZ?=
 =?utf-8?B?aWJ5QmMrbCtwNlBRdFNOU2VyTGVYbzJGWEVhQ1k1ZWpwMGU5MVJ5djdWZzRL?=
 =?utf-8?B?QTlpbGlxQ2dtTnlHQis1RzBteXA4ZmErYjZ3dndESmtTUElMb25VTFNTZkQ0?=
 =?utf-8?B?QjUyb0c0SkIwRXdleThLbXFQLzlsVndFL0hhM1VxRk04QmRKMDF5bXpQY3ZG?=
 =?utf-8?B?SllhOVp2Zk1OYmlLSnhhUlBQQ0hodFdlWXVLQlN4Zjg1dS9nMEVTQmwzeUxu?=
 =?utf-8?B?SlpKRk5DUUVrQU96UEZ4R09UUHhBYU9OcXpFR0JlTElucDlPTE9zRjBGVDN4?=
 =?utf-8?B?MkxGOGF3ZkRpUDZWK3RNWXlMZ3RhRlJZaWlHSk5DUzBLQk1UZU1PT0FKUHZC?=
 =?utf-8?B?UDU3cjNQVWJ0Q3lyMHN3VW1aU3BuWmRIYTcwWDh1UGorLzZJK1hmRkF6ZkpE?=
 =?utf-8?B?ZTgwUlJGdENwOWZ1Q01jZXlpaHEyQWN0MUwyV1Npam9DRkw2MDdBOXEzajBl?=
 =?utf-8?B?K2ZzQ0FDU1lFY2hrTWxyNkV5SnRKTzhjR2FOZ29JM3oxNlF2b2dXb042cU5X?=
 =?utf-8?B?L1VkNHRHQ3hRVHNUV1FHRk9ZbUwwYlg5NHdZdmYyNFk4UlRadTZDN0YrMC9U?=
 =?utf-8?B?eU9WUUpocklPWXMrVUIvNU15N0MwMERRckRrajN6Qk12QkRNblJzQWVyUWEx?=
 =?utf-8?B?VllVU1dhdjdoWTBNODdzakZscmtJejZnVnJEeWViYUljd0cwL0FjN1czMXBE?=
 =?utf-8?B?RVFTeVE1cmxwK1pNR2lXdVRlMThCNG9NWFo3Z1N4S2ZZdVh2ZTNoOTN4SGRp?=
 =?utf-8?B?b1hqY0NCeCt5OE5oR2dwc1FyWGxLRjAxRVd6d2NHcHpkeXUwWldwcjcvTG81?=
 =?utf-8?B?MDlaNjZaYXE0aXVlUmo3QnYra0J2RThCZUtyUXlPalgxK2dEQXplN3l6Mm5h?=
 =?utf-8?B?TEVpY0xXVFdBQ1hmYzhKd3FZRENMTEp1Ukt3TUwxeUlRcU5iVHp4WCtYMWJI?=
 =?utf-8?B?UW9TZDk5cEhWQnJ3NGhRaDNndXBpYXNndFJGQmJRUnJGRDdPODBYU0F0TGpl?=
 =?utf-8?B?YkEzN0tlWWlhWkQ2WlJRNk4zUHp6dTU3L2RMcjU0aGQ3M243U3IxSmtwQXZ5?=
 =?utf-8?Q?NXzjEAaH8HD943P2rtzcyQIHD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 076a4c02-30da-404c-3f35-08da9b8bdd6a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 04:43:44.4927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ETikETmuxojUxgUHOc23dlNbHNeVA1UF0UDXK7gp0o2taSeVHY1KzereQIIbAD5t3ThpH3QqI4D2YpsptWFBnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6033
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 20/09/22 14:18, Alexey Kardashevskiy wrote:
> Adding Nikunj for his opinion on the reworking (at the very bottom of this mail).
> 
> 
> On 13/9/22 16:38, Sean Christopherson wrote:
>> On Tue, Sep 13, 2022, Alexey Kardashevskiy wrote:
>>> On 12/9/22 19:36, Sean Christopherson wrote:
>>>> On Mon, Sep 12, 2022, Alexey Kardashevskiy wrote:
>>>>> A recent renaming patch missed 1 spot, fix it.
>>>>>
>>>>> This should cause no behavioural change.
>>>>>
>>>>> Fixes: 23e5092b6e2a ("KVM: SVM: Rename hook implementations to conform to kvm_x86_ops' names")
>>>>> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
>>>>> ---
>>>>>    arch/x86/kvm/svm/sev.c | 2 +-
>>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>>>> index 28064060413a..3b99a690b60d 100644
>>>>> --- a/arch/x86/kvm/svm/sev.c
>>>>> +++ b/arch/x86/kvm/svm/sev.c
>>>>> @@ -3015,7 +3015,7 @@ void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
>>>>>        /*
>>>>>         * As an SEV-ES guest, hardware will restore the host state on VMEXIT,
>>>>>         * of which one step is to perform a VMLOAD.  KVM performs the
>>>>> -     * corresponding VMSAVE in svm_prepare_guest_switch for both
>>>>> +     * corresponding VMSAVE in svm_prepare_switch_to_guest for both
>>>>>         * traditional and SEV-ES guests.
>>>>>         */
>>>>
>>>> Rather than match the rename, what about tweaking the wording to not tie the comment
>>>> to the function name, e.g. "VMSAVE in common SVM code".
>>>
>>> Although I kinda like the pointer to the caller, it is not that useful with
>>> a single caller and working cscope :)
>>
>> Yeah, having exact function names is nice, but we always seem to end up with goofs
>> like this where a comment gets left behind and then they become stale and confusing.
>>
>>>> Even better, This would be a good opportunity to reword this comment to make it more
>>>> clear why SEV-ES needs a hook, and to absorb the somewhat useless comments below.
>>>>
>>>> Would something like this be accurate?  Please modify and/or add details as necessary.
>>>>
>>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>>> index 3b99a690b60d..c50c6851aedb 100644
>>>> --- a/arch/x86/kvm/svm/sev.c
>>>> +++ b/arch/x86/kvm/svm/sev.c
>>>> @@ -3013,19 +3013,14 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm)
>>>>    void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
>>>>    {
>>>>           /*
>>>> -        * As an SEV-ES guest, hardware will restore the host state on VMEXIT,
>>>> -        * of which one step is to perform a VMLOAD.  KVM performs the
>>>> -        * corresponding VMSAVE in svm_prepare_switch_to_guest for both
>>>> -        * traditional and SEV-ES guests.
>>>> +        * Manually save host state that is automatically loaded by hardware on
>>>> +        * VM-Exit from SEV-ES guests, but that is not saved by VMSAVE (which is
>>>> +        * performed by common SVM code).  Hardware unconditionally restores
>>>> +        * host state, and so KVM skips manually restoring this state in common
>>>> +        * code.
>>>
>>> I am new to this arch so not sure :) The AMD spec calls these three "Type B
>>> swaps" from the VMSA's "Table B-3. Swap Types" so may be just say:
>>>
>>> ===
>>> These are Type B swaps which are not saved by VMSAVE (performed by common
>>> SVM code) but restored by VMEXIT unconditionally.
>>
>> Weird consistency nit: KVM refers to VM-Exit as an event and not a thing/action,
>> whereas the APM tends to refer to VMEXIT as a thing, thus the "on VM-Exit" stylization
>> versus "by VMEXIT".  Similarly, when talking about the broader event of entering
>> the guest, KVM uses "VM-Enter".
>>
>> VMRUN and VMSAVE on the other hand are instructions and so are "things" in KVM's world.
>>
>> Using the VM-Enter/VM-Exit terminology consistently throughout KVM x86 makes it easy
>> to talk about KVM x86 behavior that is common to both SVM and VMX without getting
>> tripped up on naming differences between the two.  So even though it's a little odd
>> odd when looking only at SVM code, using "on VM-Exit" instead of "by VMEXIT" is
>> preferred.
>>
>>> ===
>>
>> I want to avoid relying on the APM's arbitrary "Type B" classification.  Having to
>> dig up and look at a manual to understand something that's conceptually quite simple
>> is frustrating.  Providing references to "Type B" and the table in the changelog is
>> definitely welcome, e.g. so that someone who wants more details/background can easily
>> find that info via  via git blame.  

How about the following:

      Save states are classified into three types (APM Volume 2: Table B-3. Swap Types)


      A: VM-Enter: Host state are saved in host save area
         VM-Exit: Host state are restored automatically from host save area

      B: VM-Enter: Host state are _not_ saved to host save area, KVM needs to save 
                   required states manually in the host save area
         VM-Exit: Host state are restored automatically from host save area

      C: VM-Enter: Host state are _not_ saved to host save area.
         VM-Exit: Host state are initialized to default(reset) values.

      Manually save state(type-B) that is loaded unconditionally by hardware on 
      VM-Exit for SEV-ES guests, but is not saved via VMRUN or VMSAVE (performed 
      by common SVM code).

>> But for a comment, providing all the information
>> in the comment itself is usually preferable.
>>
>> How about this?
>>
>>    Save state that is loaded unconditionally by hardware on VM-Exit for SEV-ES
>>    guests, but is not saved via VMRUN or VMSAVE (performed by common SVM code).

Regards
Nikunj


