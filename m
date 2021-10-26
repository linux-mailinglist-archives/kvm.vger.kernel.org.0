Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEB0843B8E5
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 20:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238018AbhJZSFa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 14:05:30 -0400
Received: from mail-bn7nam10on2074.outbound.protection.outlook.com ([40.107.92.74]:59584
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230258AbhJZSF3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Oct 2021 14:05:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RxwW3AtPl/9mOF8/RPKVvoYVHtK8Sv7q0w7uGOFgyQJjxvIers/ZdMk6OvxGR9M6hK6qLrkvQCAJR4cJYK2o3087K7ODNmNxGuETBkip4jjGUG1A8YuCk4mYButTQ4F9JpFJuNbAiztiXpmMdIDgQZmHnJvEdL0xaQAIW54N60p0ugJmnBXNMzA4csfNl55GBYp2H4ioBJ4pz5+y9ZAqUuY4C3lqsGddX/xBvRRJIOjP+JGuqNa/y0XlJnrYsjmq6/xZDYr3wTBCPUeHbAsVnwQcXeYWIi/0rDyzAUTUkIqsDhfyP0S6XIWigxrv1qU/i2tFEvQmiqyuA25quv20DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nfS1HdhpKsZc0wYx+h3rSsR8QxRHyFufMGPnQ/o9zJk=;
 b=Th3vPeDi41RHscuVSQV97sLo3dWAQPyQgxwTfZo4ptDX+ILXdz7v4aSRl7SBa159uOS7+hCWO45XPAHYT7ZhdKyCRMc4p0TBwlHAPSHy/+ubhbry6lDfW2gvOg9f29M0BG4pIsxDizc/dVhy/bSBH2kYSz3A9hqEii9zOs9dLWgsrZSFMqhSQrs3kFiTVSIlm37Ki2BK8FkqRwbGsGBUsBkZloUv5D23hcfgXeAmovY24aErl/c0KDRb9Dmg5IKfVckeskJO/HVN3dklQSjSA+JyWWU9h9PBzYQkuvvnGD6WlyBrBA8mDCdo6/aiqmU5t4ICo6NKiQlRED6NkLjgdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nfS1HdhpKsZc0wYx+h3rSsR8QxRHyFufMGPnQ/o9zJk=;
 b=uPCJn6/IE/tvoEuLJACGhdq/CtJ//cikyXkQAWQy2wJtKi+D12jU1IP3EkOIK09v5qs7GXFE9V8y0XF1P07BDKcpckIu5jS9ZbZBELeM2nDEYyO61FYJOFZvJ3o8dndYykP05StUVf7QjweNY9CvnjG6YlPnmyr863rKV33GY7E=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM4PR12MB5374.namprd12.prod.outlook.com (2603:10b6:5:39a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 18:03:03 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9%7]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 18:03:03 +0000
Subject: Re: [PATCH v2] KVM: x86: Assume a 64-bit hypercall for guests with
 protected state
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        kvm list <kvm@vger.kernel.org>
References: <e0b20c770c9d0d1403f23d83e785385104211f74.1621878537.git.thomas.lendacky@amd.com>
 <87cztf8h43.fsf@vitty.brq.redhat.com>
 <3b8953c9-0611-27da-f955-c79a6fcef9ce@amd.com>
Message-ID: <e45669fa-372f-a29d-d9c9-b4747e56b97c@amd.com>
Date:   Tue, 26 Oct 2021 13:03:00 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <3b8953c9-0611-27da-f955-c79a6fcef9ce@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BLAP220CA0011.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::16) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from [10.236.30.241] (165.204.77.1) by BLAP220CA0011.NAMP220.PROD.OUTLOOK.COM (2603:10b6:208:32c::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.22 via Frontend Transport; Tue, 26 Oct 2021 18:03:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e9f509ff-7ffd-4f83-bea7-08d998aadabe
X-MS-TrafficTypeDiagnostic: DM4PR12MB5374:
X-Microsoft-Antispam-PRVS: <DM4PR12MB5374D0C64EBF9FEB46BA6B6CEC849@DM4PR12MB5374.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +i+Qfww8Segzw/hHkKdJF8DKf+yAI9fB6XmGiwAmnC593U99ZdU9evx9lBAfDWN7I4oxcsoB6ftZum2Z+iONV0vBZVxM66GSx2tlp0e2JbpqEoMvwvqD1cU+VMBABNSAQsJq4YuLaOsW6eMuqOyQm1JPwtBia8Rb3saQO8V1FhrRgDU6MT0yecew2Bi8d2jkoU7rfSDSIbfCzk+VweqVt8ftI8Kng0LC6Nhp2bDJ09+hoP77Vr3TxELEaL7HdsUU+qUQktP09ib2AMbT1peOxa/Uqw3sV5YSncLEmzHlfFQHIX2+T8DC9FA72Ro+J/A25TvFFoAdGGuPUJpJkL1SmJglE+3MWD+EmwKhoF6pzy6vqLezcLHyJq44FIWwe7KcLGL+80VijPUSZo+EsWLaxuwRQWEsvbb4aYw2KKjE3TMAcQAbOnzzxwtUCvEJAp5Mazq/RxwOzsCtuowQtTY3YTy2PEOO/VRJR7Ww+TC/EYa8jlXbmgB1vuIK91HJsoIaxL9tkSaJD6rOeC1Ro7CgKFt2FcluVDlTV0M6HCbm1mymamcX3m/HZvAwWu3K7MPl7aMNPO9NXMw1aZEsTLqvhE7sON+XqU3bxb9Xx6nSXA4v6DI/Tn6tlJ1VJY4Z0qErN0luEsxYrXhvWcgJuejDw7EA9dmy4Q3tBzP/o1AGvPvaIxlZQKtqk6jdwnOTWib2/nn9a6KK85iN44D07G1w/qrcyP8fBP9FDQmS90jMx8zzEVPiMhBSvh8ULKKnObJe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31686004)(36756003)(7416002)(53546011)(8936002)(508600001)(86362001)(2616005)(83380400001)(66556008)(16576012)(110136005)(38100700002)(316002)(8676002)(54906003)(66476007)(4326008)(6486002)(956004)(5660300002)(31696002)(66946007)(26005)(186003)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VWJRbG9sbXNaTW9TZE9LSkRXdWt5QitnWUxKN2x5RUJYbU01czU4NklGaVk0?=
 =?utf-8?B?c0pYblNIVFdLL3orVVhUdkFlcFlXb0oxQTZUbW8vUHVEVkl0RUtTMnJYZVc0?=
 =?utf-8?B?aXd2a1dEZFZjNk1DMUVNRHBnZUt0dWx4RVpIUHM3Vkx6Sk9Ic2wxakpXMnVF?=
 =?utf-8?B?cGMwWm9aUTFpbWo3cXlVdWltKzl4TWs3ZzFUdVZrODVFTVlwaXV6eFNVUk81?=
 =?utf-8?B?OS9PZGZ5elhHTjdZWXJxeEh0UWpmUkdjcDROYTNpcjlaeHI5bktZUlk2VDhO?=
 =?utf-8?B?d3Y0Z0FGVmxHTXZRVXE1NnZkdVFRdDhJSzMxU2trUTBqay9BM3dYMDJyaU5I?=
 =?utf-8?B?TGNKTmIyTXU2NHkvS1R2OHMzSytqSEV1aVJDQjFKSy9KaEJyU0cyVGQ1R0RO?=
 =?utf-8?B?eDdOWlpDdEF0aExRZ0lxU1h0QlNvVGFPSS83U2JxblNEZWpTTXVoVW1Od3Ey?=
 =?utf-8?B?K0t3Tmx5Slh3MEtIMTRta2dvWXpHTmVFK0pYaUxJQTNJT1lzNWNEeUVwWjBZ?=
 =?utf-8?B?Q3RuSTRHai9GR0pyc1BmcjRSRFdIeDRPbXAxQ09Jamp1K3IyODRuR2lzTjN0?=
 =?utf-8?B?T3h2ODcvRjJUc1hjcFJuU0d4SWFJV1M4K3k4Uk04bHZYQ3Frcnh3QXdVcFJm?=
 =?utf-8?B?Q01TNHUwYUFmd005VjhMenVsUlVHUjRmZHFRYk5WOUk4a3cyRC8yU3ZDM040?=
 =?utf-8?B?azFOYkVkeFQ1TTc0cUlnOGMxYnlvbk5SVlBtUFhwMjdlTVlXV0lHZ3hkVlJ2?=
 =?utf-8?B?aGQ1d3lYK3BRY1FGVmNUOVNsM0NWZ3NDZm9wVDBiUTlDRGN5SUl1UVJhdGpI?=
 =?utf-8?B?RWQ3TWlvdzhpa1AxZXNvNEh1TnhQMDgxdjhlK2IwcDhRT2s0aE16VDlHLzhz?=
 =?utf-8?B?U2hnYmVtVURBMGpaRmFFMjIwaWdRTUNId0ZNbXhzL0pxcDR4Mmo5aVJWMjJ5?=
 =?utf-8?B?dWhYNUpqRmRMc0t4MnBWR3kyakNmV1l6LytXTVJESDVtWlZtQUxuZGoreEZ2?=
 =?utf-8?B?cFdpZld3bnhOeWdZelNzWHZicXpNNVZIZzlnQ2x6YmgreWl2eG5CWWJTTXpu?=
 =?utf-8?B?ZTR6L0ZQaEMxLzQrdnlveUZVMGh2Zkp6MlBlWkhYWFN3a3NpV1ArWHg1QWRq?=
 =?utf-8?B?ZnpoNXhvYW1LejNnVzZwMXh1WlVaemxOOVQ0Umk3eWpSbWM3L3IxRUZRYld4?=
 =?utf-8?B?VWtKZUlER25BTTVGSVR4RVA3QXI5RkpWbFVRdHZUSHRqY0I4SzRTQzVBUlhu?=
 =?utf-8?B?V0RiSTFIYUxyVEh6aXZHN0o3cUg4Q3ppcEtjUVJqUjhBSHEyREdwZWV2TjFm?=
 =?utf-8?B?Mmg1cFV6cWl2cmJWa0JnYzE3ZEhlWUVJSTRTOTE5WFZlcE5qM2FNYXg3SUE5?=
 =?utf-8?B?SlZHS2RWNXNrZDljTGhaSEhOQ21kZHFtMHRRdkJibzBqWllNaDJxWTR6SldK?=
 =?utf-8?B?NUJQZUM4dmRIYWYxRzJITkRXRS9jcXkwdnpqZDFoMDR3R0hJbGMycElEWWwv?=
 =?utf-8?B?UC8zaE9oWG1hQlRVejBhUzFvb3E5d0FUdWVwaU5WRVVhWFAyamVyelg0R3d5?=
 =?utf-8?B?QUxyMzY1bzU1L2hMZFIwa3RZOHhBbllBM2h5blcxUUVmRFIzekEyT1hJSUMw?=
 =?utf-8?B?d0JUOVBsdXRFNVlFblBDRklIOEp3bjhtUDB5Ni81d085c0swWHkzR2FkdDNx?=
 =?utf-8?B?Kzc4ellJZW4yY0xZdmV3Q0FLbkZQNVhGQWN3MU5KaGJwZnZFb3ZTVWJhTHU0?=
 =?utf-8?B?bGk2TjNjcDRpaEJsZTEzeElnT3hCQjYvWUVscjNOdTlnRk12YWVYUy85ODZP?=
 =?utf-8?B?d3g3OUplWmFvMWtCbmx1dGNXckR0b3hyM2VrblhOeWNMbi80Y1hENk5acnhk?=
 =?utf-8?B?RTdKOElwYTQ1YnJIWVg4bytLZEdTbFlnV3R6NkxGWlRUZmdBVVZZakhCRjhj?=
 =?utf-8?B?cTRLNElSL3c4cGlVWEJxQ3JuanhMZnB1OGdIZFBCdDhoVkx4cXdRbSt4aWlp?=
 =?utf-8?B?N1pJV2hPeGNwTytXenFETVRGL0JyMjRDRFhBeWg5bEcyUmdtTjU2NFYrSjBj?=
 =?utf-8?B?N0szOGdlbDk2ZFRqWkVQd0I5b3ZlRDN6aVlOZmJnb29tNXhrbW5CQ2xmb1pD?=
 =?utf-8?B?UDcvOEJlU0RWVVRvVWdHVlEzL0xTYTErdkg2K0QvSkU2Mk1HakRKQ3l6T2RO?=
 =?utf-8?Q?l/FlreVyrH/NercKs/N5xWM=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9f509ff-7ffd-4f83-bea7-08d998aadabe
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 18:03:03.3293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: svKX7Ect2E7wf6xIB0dSKOhU96QuGotZYlDqNGXS5+o3J9nOibo0xWgQLRNlYjApJQuCYHUdwp1Mvfc/LjlUdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5374
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/1/21 12:06 PM, Tom Lendacky wrote:
> On 5/25/21 1:25 AM, Vitaly Kuznetsov wrote:
>> Tom Lendacky <thomas.lendacky@amd.com> writes:
>>
>>> When processing a hypercall for a guest with protected state, currently
>>> SEV-ES guests, the guest CS segment register can't be checked to
>>> determine if the guest is in 64-bit mode. For an SEV-ES guest, it is
>>> expected that communication between the guest and the hypervisor is
>>> performed to shared memory using the GHCB. In order to use the GHCB, the
>>> guest must have been in long mode, otherwise writes by the guest to the
>>> GHCB would be encrypted and not be able to be comprehended by the
>>> hypervisor.
>>>
>>> Create a new helper function, is_64_bit_hypercall(), that assumes the
>>> guest is in 64-bit mode when the guest has protected state, and returns
>>> true, otherwise invoking is_64_bit_mode() to determine the mode. Update
>>> the hypercall related routines to use is_64_bit_hypercall() instead of
>>> is_64_bit_mode().
>>>
>>> Add a WARN_ON_ONCE() to is_64_bit_mode() to catch occurences of calls to
>>> this helper function for a guest running with protected state.
>>>
>>> Fixes: f1c6366e3043 ("KVM: SVM: Add required changes to support 
>>> intercepts under SEV-ES")
>>> Reported-by: Sean Christopherson <seanjc@google.com>
>>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>>> ---
>>>
>>> Changes since v1:
>>> - Create a new helper routine, is_64_bit_hypercall(), and use it in place
>>>    of is_64_bit_mode() in hypercall related areas.
>>> - Add a WARN_ON_ONCE() to is_64_bit_mode() to issue a warning if invoked
>>>    for a guest with protected state.
>>> ---
>>>   arch/x86/kvm/hyperv.c |  4 ++--
>>>   arch/x86/kvm/x86.c    |  2 +-
>>>   arch/x86/kvm/x86.h    | 12 ++++++++++++
>>>   arch/x86/kvm/xen.c    |  2 +-
>>>   4 files changed, 16 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
>>> index f98370a39936..1cdf2b213f41 100644
>>> --- a/arch/x86/kvm/hyperv.c
>>> +++ b/arch/x86/kvm/hyperv.c
>>> @@ -1818,7 +1818,7 @@ static void kvm_hv_hypercall_set_result(struct 
>>> kvm_vcpu *vcpu, u64 result)
>>>   {
>>>       bool longmode;
>>> -    longmode = is_64_bit_mode(vcpu);
>>> +    longmode = is_64_bit_hypercall(vcpu);
>>>       if (longmode)
>>>           kvm_rax_write(vcpu, result);
>>>       else {
>>> @@ -1895,7 +1895,7 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>>>       }
>>>   #ifdef CONFIG_X86_64
>>> -    if (is_64_bit_mode(vcpu)) {
>>> +    if (is_64_bit_hypercall(vcpu)) {
>>>           param = kvm_rcx_read(vcpu);
>>>           ingpa = kvm_rdx_read(vcpu);
>>>           outgpa = kvm_r8_read(vcpu);
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index 9b6bca616929..dc72f0a1609a 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -8403,7 +8403,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>>>       trace_kvm_hypercall(nr, a0, a1, a2, a3);
>>> -    op_64_bit = is_64_bit_mode(vcpu);
>>> +    op_64_bit = is_64_bit_hypercall(vcpu);
>>>       if (!op_64_bit) {
>>>           nr &= 0xFFFFFFFF;
>>>           a0 &= 0xFFFFFFFF;
>>> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
>>> index 521f74e5bbf2..3102caf689d2 100644
>>> --- a/arch/x86/kvm/x86.h
>>> +++ b/arch/x86/kvm/x86.h
>>> @@ -151,12 +151,24 @@ static inline bool is_64_bit_mode(struct kvm_vcpu 
>>> *vcpu)
>>>   {
>>>       int cs_db, cs_l;
>>> +    WARN_ON_ONCE(vcpu->arch.guest_state_protected);
>>> +
>>>       if (!is_long_mode(vcpu))
>>>           return false;
>>>       static_call(kvm_x86_get_cs_db_l_bits)(vcpu, &cs_db, &cs_l);
>>>       return cs_l;
>>>   }
>>> +static inline bool is_64_bit_hypercall(struct kvm_vcpu *vcpu)
>>> +{
>>> +    /*
>>> +     * If running with protected guest state, the CS register is not
>>> +     * accessible. The hypercall register values will have had to been
>>> +     * provided in 64-bit mode, so assume the guest is in 64-bit.
>>> +     */
>>> +    return vcpu->arch.guest_state_protected || is_64_bit_mode(vcpu);
>>> +}
>>> +
>>>   static inline bool is_la57_mode(struct kvm_vcpu *vcpu)
>>>   {
>>>   #ifdef CONFIG_X86_64
>>> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
>>> index ae17250e1efe..c58f6369e668 100644
>>> --- a/arch/x86/kvm/xen.c
>>> +++ b/arch/x86/kvm/xen.c
>>> @@ -680,7 +680,7 @@ int kvm_xen_hypercall(struct kvm_vcpu *vcpu)
>>>           kvm_hv_hypercall_enabled(vcpu))
>>>           return kvm_hv_hypercall(vcpu);
>>> -    longmode = is_64_bit_mode(vcpu);
>>> +    longmode = is_64_bit_hypercall(vcpu);
>>>       if (!longmode) {
>>>           params[0] = (u32)kvm_rbx_read(vcpu);
>>>           params[1] = (u32)kvm_rcx_read(vcpu);
>>
>> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>>
>> Thanks!
> 
> Paolo,
> 
> This got lost in my stack of work... any comments?
> 
> Thanks,
> Tom

Ping

Thanks,
Tom

> 
>>
