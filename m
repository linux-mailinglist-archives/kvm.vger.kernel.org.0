Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBD9438E828
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 15:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232685AbhEXOAU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 10:00:20 -0400
Received: from mail-bn8nam11on2058.outbound.protection.outlook.com ([40.107.236.58]:41761
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232409AbhEXOAS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 10:00:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jQaUNDg0XPE70+Y6m20gcEmBBCZOOs7u5VIIlkvpZwySoQr9ufM5V6jssvpnk+JI2KoWULsl2JxoVMfDtYAdKFx7xJ3r5DKIsCTAhjMxkQdCfSsN2hSM0qfOMQYun+IFv88+iMriYkIh0UKh8c0UBI0rBlogqJlPVSGDHUsuyXwplzQkWa+1UCIl6gFoW/tZ0Q7fvj0VwPNFN5dls6sgJtzs7mlsZ54sAl7S1HuaeZaM5iEdreqV7TlnhIcZfrqMSYiZBADR7ZQ/jnMs/+AH5OhDP5A2GhqWkqwy/BDr4Qff8OZjcJA9W4Xi/ay3LNDXtrAwax8SaDtvqBghCD6nFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yDbdgYBSMXwiMHSSnj2U8ZWyqNQVyUDv1yDXOaUkfdU=;
 b=bzaPXCxpZKzbOgPRWeXoNM97hSKrwKQbwHSdJml1JfXFbg/CELJaQEyAh5bJQKlEjTffMG7wNsuB//UoQrenU4+1RXlJ9F1Jl8pYDCltYHb3+aA++vNIrrlBNfGNwQxDk33Xhafdceagr6Nhcf8o+vefCBuo9MfvWcejsj+iJHlWUCBaefeZ0KA2Tsuw7lGplhr5fhKSJr90v7rQ0Bl0VmAbmX9qA51SUHgK6C9kD0tb/aqYKLfcXRCQEkhsthQ66lvZC4m89ng4NjVstDqbqA2ep+OHdi960PEp2L/rzp1+5S0KF466PH2AeUhEQ7wrPA5oz1y+xRkVz08D76G9mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yDbdgYBSMXwiMHSSnj2U8ZWyqNQVyUDv1yDXOaUkfdU=;
 b=QrM/U0VqynZIWGnQkpIOD64z2tlDiirq+CZW7Kv023wv5SACFT52Ir+3o3P+QrTlzg/0Lr1c5tBJ+Pr+wdshuR50XGoGNunJe3dKNMg0sIBQf/aDtoaqic+WjRQ/riNnvwNBE4+2zyi/rrt/wpsUIgNGiqfL8KLvHFTajr4G6t0=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4155.namprd12.prod.outlook.com (2603:10b6:5:221::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4150.23; Mon, 24 May 2021 13:58:48 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9%12]) with mapi id 15.20.4150.027; Mon, 24 May
 2021 13:58:48 +0000
Subject: Re: [PATCH] KVM: SVM: Assume a 64-bit hypercall for guests with
 protected state
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
References: <d0904f0d049300267665bd4abf96c3d7e7aa4825.1621701837.git.thomas.lendacky@amd.com>
 <87pmxg73h7.fsf@vitty.brq.redhat.com>
 <a947ee05-4205-fb3d-a1e6-f5df7275014e@amd.com>
 <87tums8cn0.fsf@vitty.brq.redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <211d5285-e209-b9ef-3099-8da646051661@amd.com>
Date:   Mon, 24 May 2021 08:58:45 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <87tums8cn0.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN7PR04CA0191.namprd04.prod.outlook.com
 (2603:10b6:806:126::16) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN7PR04CA0191.namprd04.prod.outlook.com (2603:10b6:806:126::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Mon, 24 May 2021 13:58:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2ef9623c-bc65-4bf4-5e4e-08d91ebc0dba
X-MS-TrafficTypeDiagnostic: DM6PR12MB4155:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB415536816DFBC0923C4EE072EC269@DM6PR12MB4155.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NPvpzi8MadLbh0Oo1GALi9yUXmbG0oVOhIkmiVLhPN7lN9JK0Z8pXrrQdMs9QnkevxsZ6Ng+G/R7KxpM8R260KjwrPyZXDCOvQk+eCw9Ut66kEDiBMvdXaqcFd67ub9VddUGJ/vYrgwxENEZd55wJE4dplmPYuDgYmTeLq/3fF5x+zMwSJ7RHxozr89Y6jP7FftG9KIPPyV5mTJU/8lwMUGqkT1dw6opwc73pkkS0RDXzrQOcqVCVX3X0a8lv3YE7HPl4H7pa1h4Zbm5bSMAh7Z8yhGeMlCN2dk47ID4OVxAEnAvHRQ1dtKovcj4XGC1ick85PWnoa2r4ytP7Q8HsZraCKcHTt1ZRw5CYISmQzhs5vXPvsFFW6sJux3Sy1xqxtA3yhMaQQR/XeohMVq6dTYFd7fJR5XFmwMkKSASflkySCZgay0Ky/3caT86Mi+Pi/ZwhwVdUVagpmNJUDrDHyvWmaXTbxXc3/V99mhVk79Zx/NofY1dlyfuWPYCqX2ziVQS34I19hOs5PATn/toKHO9UAByRQ8alWTpfW5iQXlt8pzSGCoxH/CEME9nZSOkTIYHaqY9SaTJj2wOQzzowgBBT3I+K/QReibhBSZDPI75bIsXY1oVHPFDO2020BfQltL50Qh+bWViOIsMOB0GcOeiXoF9M2RTpAiHhF0GEc8LTttzZR9BYJm8MFMJ/HV/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(366004)(136003)(39860400002)(53546011)(6916009)(16526019)(31696002)(186003)(31686004)(86362001)(6486002)(6506007)(956004)(8676002)(2616005)(316002)(2906002)(8936002)(7416002)(26005)(66556008)(66476007)(38100700002)(478600001)(66946007)(54906003)(83380400001)(6512007)(36756003)(4326008)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bDdlanFxK0lEb0hwL28wRDljaGZxd2VOR2NrMy9FbEppcjRtZ3pIcWM5S3NL?=
 =?utf-8?B?Qnl3eFNjVUlmL0xuSTcyb0ladjR1WDdBYXRPd0pyTEg0M3NHeHJUaFd3aXZn?=
 =?utf-8?B?TzVUciszQTZTTWRnMDFMRlZUemhGRjZiWW9qRTBpd3cwWm9uT3dEcW5pMzBI?=
 =?utf-8?B?b2xwUjcrZ21TQ0ZvMkdYMTJwZW8xL2JRN2tvRkF4ZW5RUG9qS1ZhZnllVFVu?=
 =?utf-8?B?WXN3Y2pmRVpjTDYxZ1BaNWNNZVN5YkFZVCtCTzZqSmdOZHhlWnVLRnl4NlpB?=
 =?utf-8?B?K3J5K0R6eTRsZXZXYytFZUJkazgrcXY1dnR4UDJmMVVjbEMxcEhEV1JtMi9r?=
 =?utf-8?B?TnROQTJKVWFIWE5xK2tXWW45Njd1Ky9DNXdvTGsvRmtrQnJhNkI4SEMrRUFG?=
 =?utf-8?B?dXFYSmdHR3hVRkZqQVN3ZXM4NTdsVkNkT2Q5YjVDSGV5MWczcUw0cFA2YUQ0?=
 =?utf-8?B?N242RU9WMkZwVFJiam8yaDhzTkpkMkQvS3FxdjFnZ0owd3Z3bjBPWHVXUEQ1?=
 =?utf-8?B?UklMYlhaVWQrWmZsaTc3bWZHSXVtYlZyQU5VTU9sRmZOWUw4TFRXNStxOHA5?=
 =?utf-8?B?OGR1d213UmRkcG5YczBkTC81T2hMakszc2tpNDhUVUVydG1XbEJ5ZXpnZCtK?=
 =?utf-8?B?YVJ1cCtQMER3YzJjOTNQUVVDRHN6V1J5V2s1Q1djanlNOVpad3pRNE9ISTQw?=
 =?utf-8?B?S3FYMVhrMGNIWXRMVW5GUm4yTjFpSm5HVE9YbENYSEpTamYreXFhdnlTbVZB?=
 =?utf-8?B?aXdpYzY3U2xzU3g3Rk84S0VMWWZ0eU8wZWdJbEtwN1Q0NDMvc3JDZmFDTWx1?=
 =?utf-8?B?RklBSXZwQ0hkR1ZVVVRSOUZ0YTRWbTJGVTgwbUFkQ3lOU3FTNHdRV0ovZFJw?=
 =?utf-8?B?R2Jkd0Y2Yi9uY2VqS3lnZjFaaHRVem0rc1Bob2cyejNkUk9qQm8rYnVnSlJk?=
 =?utf-8?B?TkFpL0JaY1NoNFJMNXNkOGRzaGlDRUt1cGwwSGhwNXFXUlFrU0JSN2lRVUZw?=
 =?utf-8?B?TUQxWEFsSDgyVVA4MEdQNmxlMGpNak8zUHBlOUhkS3B0dXBLZEU3dlZmaEpB?=
 =?utf-8?B?OVRjTHloWk95cXN2RmJ6WndKVXR3Z2Jkam1BWjBHRGdvTjVnd01pcmFxV05G?=
 =?utf-8?B?RHAxSXZRZzB2UzU4Rms3Z0hKZGZZTGxCekF1aG9iWTg2MVdoY0wyQVdZcjF4?=
 =?utf-8?B?Z2JiOHNlYUw2UUFHQ0N3ZDMzWFBuUmk2SFRxS09mUDY0VTNtbXV2bEEyYjlB?=
 =?utf-8?B?SC9GYk42RTU2U3hFRFBWeHRGTHJPZGFQaXRvZkNQV28vNjVQVUN3T2ZYbGVp?=
 =?utf-8?B?aEgrZ0wvYlJOTURqemZLTXIrSUFDVjM2Ni8wY0o5NEJNRS9CV0ZhakRVSWZJ?=
 =?utf-8?B?Q3NEclJackV6MjZnSnI5dGZkTEpRRlZoQ2d5a2pId2xCWTJTS3RDTHplVW5S?=
 =?utf-8?B?OUszRkpoL1A4MW5OaUg5ZThwaHIyVklyMHoremcxVTBXcWZxckEzQjZKWTBV?=
 =?utf-8?B?K09iZEFhTHFrV0o4THJRMmpscy91bDVWVGd2ZkpOcHNSTmVxR0ZiRUl3N0JB?=
 =?utf-8?B?bHh6d1BDWHJ5bTJ6akpOSnpkZHVLMjdQL0hRUklmM21sYWJWOWxkTWNxUURT?=
 =?utf-8?B?WFMrVUZLb1hpaFc0YUpFZkpjbk9PSjUwWHczb0pQMXVsaHpKZzFkcEVMTHk3?=
 =?utf-8?B?Zi9vcFM2UlRMWkZPZGt0SnQ3aUhyMmJNejFJT3VVNHRmNXc2aUFaaWpaNGxG?=
 =?utf-8?Q?AWATW1ZjHfP6rRObB+yASvWGcgDtVMcfFn67ZBo?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ef9623c-bc65-4bf4-5e4e-08d91ebc0dba
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2021 13:58:48.4267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ntpH+B0Le+cZ/+Ec8B0DYcQXe7FHPBgReLHq+tLIrT1NP8hnm91Kab0CtluJUAeaH8U6aP9HjybSyVxHaE3Vdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4155
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/24/21 8:49 AM, Vitaly Kuznetsov wrote:
> Tom Lendacky <thomas.lendacky@amd.com> writes:
> 
>> On 5/24/21 6:53 AM, Vitaly Kuznetsov wrote:
>>> Tom Lendacky <thomas.lendacky@amd.com> writes:
>>>
>>>> When processing a hypercall for a guest with protected state, currently
>>>> SEV-ES guests, the guest CS segment register can't be checked to
>>>> determine if the guest is in 64-bit mode. For an SEV-ES guest, it is
>>>> expected that communication between the guest and the hypervisor is
>>>> performed to shared memory using the GHCB. In order to use the GHCB, the
>>>> guest must have been in long mode, otherwise writes by the guest to the
>>>> GHCB would be encrypted and not be able to be comprehended by the
>>>> hypervisor. Given that, assume that the guest is in 64-bit mode when
>>>> processing a hypercall from a guest with protected state.
>>>>
>>>> Fixes: f1c6366e3043 ("KVM: SVM: Add required changes to support intercepts under SEV-ES")
>>>> Reported-by: Sean Christopherson <seanjc@google.com>
>>>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>>>> ---
>>>>  arch/x86/kvm/x86.c | 7 ++++++-
>>>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>>> index 9b6bca616929..e715c69bb882 100644
>>>> --- a/arch/x86/kvm/x86.c
>>>> +++ b/arch/x86/kvm/x86.c
>>>> @@ -8403,7 +8403,12 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>>>>  
>>>>  	trace_kvm_hypercall(nr, a0, a1, a2, a3);
>>>>  
>>>> -	op_64_bit = is_64_bit_mode(vcpu);
>>>> +	/*
>>>> +	 * If running with protected guest state, the CS register is not
>>>> +	 * accessible. The hypercall register values will have had to been
>>>> +	 * provided in 64-bit mode, so assume the guest is in 64-bit.
>>>> +	 */
>>>> +	op_64_bit = is_64_bit_mode(vcpu) || vcpu->arch.guest_state_protected;
>>>>  	if (!op_64_bit) {
>>>>  		nr &= 0xFFFFFFFF;
>>>>  		a0 &= 0xFFFFFFFF;
>>>
>>> While this is might be a very theoretical question, what about other
>>> is_64_bit_mode() users? Namely, a very similar to the above check exists
>>> in kvm_hv_hypercall() and kvm_xen_hypercall().
>>
>> Xen doesn't support SEV, so I think this one is ok until they do. Although
>> I guess we could be preemptive and hit all those call sites. The other
>> ones are in arch/x86/kvm/hyperv.c.
>>
>> Thoughts?
> 
> Would it hurt if we just move 'vcpu->arch.guest_state_protected' check
> to is_64_bit_mode() itself? It seems to be too easy to miss this
> peculiar detail about SEV in review if new is_64_bit_mode() users are to
> be added.

I thought about that, but wondered if is_64_bit_mode() was to be used in
other places in the future, if it would be a concern. I think it would be
safe since anyone adding it to a new section of code is likely to look at
what that function is doing first.

I'm ok with this. Paolo, I know you already queued this, but would you
prefer moving the check into is_64_bit_mode()?

Thanks,
Tom

> 
