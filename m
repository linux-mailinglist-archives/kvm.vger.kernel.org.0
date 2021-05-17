Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87DA9383A0E
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 18:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237215AbhEQQg6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 12:36:58 -0400
Received: from mail-bn8nam11on2078.outbound.protection.outlook.com ([40.107.236.78]:31457
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243784AbhEQQgu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 May 2021 12:36:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kyFE33uOK2dlXocRCVGWCcWyRXoIkM+im/6KKY3631G+H3Z4ul/OtWUtMlcs6cbHrk5+kxCu1qiBgQPzlNdfox7KTVU2+/kSIolp8ZZib57pgrgMDOZT3NGO8j6oRgCU5roqzhQXAKhIycDBd7YELwUnDfICDkmyff7gD5FSqLTNyG7gGors7kCDNDBLNDVv6y6SUjZ1Yyak35mdN6qPz50B8UpmVJEFkO2PwWqQyV7Ndo/oBJpZu815iN3+j0x67Ime1R5lE7PGxYZl3wQWTRm9QYhJdKB7GxKYEZFhjheDr/LodOYC6+L3FdItEaJk5QY1SqlgOWdXTK6BrePfwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v2wR/5lNrG8dLICltDAbNDe1RCcSOkEGFehmQMiLO54=;
 b=EmCMwtdb3GUUGcU7PKTmeneUbqidJYZDyRDWLLwhOPxLVIQxtERcwy8t13wXRVOlT7E9LIt0IahSosdVCsCx0khsttDHitIM1EGJ3O7ridXN4C/OmxH79YAyizQ8lH0/M7FLNSaJEiacN+a/1+wnJAlmJJaggkrdVfrw2YwZu2gwVbcGsJdvKgj+jckFtAseBceK3CPtruNv//Ja3oTAsnwZB/4DdF1zFXepFWDQEOMdCyJo3Fnk9z5MGTwywsujvfluZFM4UEhau5FR52RPoVMhHV8dIj9TwazPMm/XrHGzpjN4VTyGBGfkKxyrTrLU7JJsvdJ5MxvRD+C0ZEgyBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v2wR/5lNrG8dLICltDAbNDe1RCcSOkEGFehmQMiLO54=;
 b=rielq9SePFvcA+2/bmvG7cBh6gNVeGW9bRPybMo/RfVYhUKAvjaNQXq/b022wXpdf3xsUV9dT9Q9gKIhq5IkaciNx4MA10qq4eyqSaqD7eq8izjPKe1/4ynu73IfZHgXrAWkyzeaJ8bQEnxaJt6Wj0PDk/lklPrQHWBqZCVvwO4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB2987.namprd12.prod.outlook.com (2603:10b6:5:3b::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4129.28; Mon, 17 May 2021 16:35:30 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9%12]) with mapi id 15.20.4129.031; Mon, 17 May
 2021 16:35:30 +0000
Subject: Re: [PATCH] KVM: x86: add hint to skip hidden rdpkru under
 kvm_load_host_xsave_state
To:     Jon Kohler <jon@nutanix.com>, Andy Lutomirski <luto@kernel.org>
Cc:     Babu Moger <babu.moger@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Yu-cheng Yu <yu-cheng.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Petteri Aimonen <jpa@git.mail.kapsi.fi>,
        Kan Liang <kan.liang@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>,
        Benjamin Thiel <b.thiel@posteo.de>,
        Fan Yang <Fan_Yang@sjtu.edu.cn>,
        Juergen Gross <jgross@suse.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>
References: <20210507164456.1033-1-jon@nutanix.com>
 <CALCETrW0_vwpbVVpc+85MvoGqg3qJA+FV=9tmUiZz6an7dQrGg@mail.gmail.com>
 <02D65AFF-2DD0-493A-91CA-997450404826@nutanix.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <1ab2699d-eccb-5848-33cb-f8bc87ac4b62@amd.com>
Date:   Mon, 17 May 2021 11:35:26 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <02D65AFF-2DD0-493A-91CA-997450404826@nutanix.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA9PR03CA0030.namprd03.prod.outlook.com
 (2603:10b6:806:20::35) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA9PR03CA0030.namprd03.prod.outlook.com (2603:10b6:806:20::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Mon, 17 May 2021 16:35:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2aaec96b-3788-4313-14c3-08d91951c8c2
X-MS-TrafficTypeDiagnostic: DM6PR12MB2987:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB29871F0C2B20D05144876024EC2D9@DM6PR12MB2987.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IO52JKZtg+clwmzHAxsCMzO2d9/PfoCkJpH2uja/9EDjmUJqU9b3sLSGevk7RdNnPeHCtKEw1fnFMjF6FQXKk7CsVGV4EHi1swldwSCwq5mHYLA0d8ZYewAoxXxKCHsiDsG35KQ/UQkuk3KBHoNoRPK0f/wlNtHxzvw1ZoiqXhd0yutG4cR0FvuxKyoV6lonnyiilEt6CdhDZTIP75MvF4bBQXlgzYlr12SonWAlTrfr4R6L+MXSLWFoImmrJE3womGy4YzwcI4FY1ZCYGJxTFrMlzL1n0/MMnakruFRkkrxce3lFnoRVIdwpMF+RFUq2wpxpQQg+fnLBwvBJB8nvE0EpUCD7ZmB7tYeeI0uiPOUAueIutMYowW70RLbmRHIMa5JhcGq8TsBasM04Mi96++AfWwK0DDqb+EmMDyFrBYv0bLRRGu7kDVA/4/saT2+3fTIYb45mYNlJi0DX9P/qw8mc/nuF9nr4Wwz92E1e+zXKdvMUqdUF2oIIGA4AgBxEla8oVd5EHe0HoNRz2hJiXGl/Yu7dAsW2tK+JklPm+WhsR4DR4X2kdzj+kR2DS6p8G8NaXXwDjNIQAE3eogfPvcYQajc3d0pF99B2TuZZ4wQtj+kgymtKRJK4Iq+P47zinlY80uredsWrDbBTlrS8NlaEMiGEWvZQUJU7yxyHrpGG1IXpI3MluwMGtIDCD+q
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(346002)(376002)(136003)(110136005)(54906003)(478600001)(31686004)(4326008)(66476007)(66556008)(26005)(7406005)(6506007)(66946007)(8676002)(36756003)(6486002)(8936002)(5660300002)(7416002)(38100700002)(186003)(16526019)(956004)(86362001)(6512007)(31696002)(83380400001)(2616005)(53546011)(2906002)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dWdUbUNXTGN2QU9obEV3Wk85aG03WHRzYk5BbGFFcnNNV0JNZnRxNlRpN3hx?=
 =?utf-8?B?MVpqVXZxS3dWTE9WTVVuVmNUcTFlL1hPYWs5anJvcER0aDFsV01ERjVaSUNF?=
 =?utf-8?B?M3pzYndZL2xkdTRFR2dLbWt0akxZeEtOS05URlo5QzR1dUJXS3pxSTh1UDla?=
 =?utf-8?B?Tkp4M1ZKVmwzUmg3dk1CTDN1cGI2WWszemx0d3NGNjl4YmRrQ0tmbnozMHIz?=
 =?utf-8?B?NFIvR21mTk9xb04zaDlJRjEzM1pSUHJEd1J5QkozazdUVzl4R3haS09NNnFK?=
 =?utf-8?B?U1RiMU9ESWlkSHBSckYxMHY5d2VvcU9wajQ1QnE2VEpCTVQxdU92Mmd5RllV?=
 =?utf-8?B?RWhVTjcyMHRGdkl1ay92TGxTWjJNUlFpTE9MRSszV2x6dGpmVVQ3dm40eVNH?=
 =?utf-8?B?ZHhlY0NYb0tJc2JBQ0prd0ZsWlNnM1JyVGdLUDRXY2wraUwxSHo2ZjZPMmhs?=
 =?utf-8?B?N0hYaGttRnBPa0xjSEFqNUVDSXVkR1kwY3JVVmMyV3JodzllSm05b0ZKQXlW?=
 =?utf-8?B?NnhIYVRYTHJoWGlxZG9sNWhOSnFsZ0tkbU5pUkwzWVVOUnk2aHp5bXh0SDZQ?=
 =?utf-8?B?Nm5VQmJZclNVanNpK3hSaFNyN3RJdkpScnZBTVdPRTNKUXZnUCtRb1NjUkxn?=
 =?utf-8?B?TFl0NEU4NFpCWTlnVXZLOGtoaDJGMDRnejJOczZmUWRiWlE0RTdXQ2NLR2ht?=
 =?utf-8?B?aXBadEMwaTJjdVVqMGZ5bDBKTjE5UHMyL1pIZzhCNlgzNXc1dTQ2OTcyOVZ0?=
 =?utf-8?B?WXQ2Nngya2RaUURHd1R1eXRwTUZvOXQ3bVJnRitUdE1kR24rOTdNdGNNdHVm?=
 =?utf-8?B?ckpuWFRWeDREUktPak1sNlJPM3ExM0tibFJyZmJQcUlvOUgwT0NnL3c4MDdQ?=
 =?utf-8?B?SEZqN3lZaTdTYkVDc0VrWG9LeEZRbkRWWmlnMkFlaFVmd2p2cGQxQ2NWMzcy?=
 =?utf-8?B?NGJSUGRGN0JsUitTYjdDK01acS9TdnZYbUg3bXVxZ1pXYkZPNUluME5IWHMz?=
 =?utf-8?B?UlE0LzB5djRpc1F0ajVNWWpBUWdRYzZickdtV1NyL3RoYlYwalY2RFZQMnR5?=
 =?utf-8?B?aVRTT29nSDFFMlI5bFZMd3hFWUlObjNZckJQQU5YRnRvNEx3Q0d4bzdvemlV?=
 =?utf-8?B?bFQ0ZU5LN1dqV242bzlBTmJUSXNtRlRMaURVeklRQWNFRXFIaUJBYVBMNlBh?=
 =?utf-8?B?M3U2TDhaeDRlcENOUWlMaXJUbE9BRkxFeUNRMXM3S2Iza1ZQbDdIYkhZMzFh?=
 =?utf-8?B?d3BZekdDOG1KUEdaWStseE9kOSt5RmZaT2VlUDNGN09hQzR0eXVuWERYUFp2?=
 =?utf-8?B?NzQ3NzlCclloZ3E5V3VLNThpTjAxNnpmVVRLMWQzMjdESW4ydjBvQTIrL0dt?=
 =?utf-8?B?NDlkWmVFMDhSaHZiUk12by9NUTVXeGNuYVFySG0yc0lxQnFDZWlvbC9QL3I3?=
 =?utf-8?B?U0ZWOXJHWGtTdVZQbXZLNjJHT0hBNUp3ZXJrZnoxb21qcEJIY2ozNDVhS1h4?=
 =?utf-8?B?bE00eStMdGVFWHIxQjZmREJPaDJEa1pTdzVITk94dWFXQTR0SFBQdFhabUFV?=
 =?utf-8?B?dnE3eG9RYzUxMUpObU5SMDJIR3BaYjYyQm5SaFRUejQxS0lsdG5PT0VlODc2?=
 =?utf-8?B?YXB4eHBTMnMzTy9jZ1R5NjFDQU01VUtJcCt6S1dSU1B3UlZCcERBMHJLMXM0?=
 =?utf-8?B?bGs0QTdvd1MxUHBwYkNxUVpkWS9ZTGN4bzIrd0JQb0lJTW9XaWhyMXZzaTNk?=
 =?utf-8?Q?cxWeYRWtIny12zX4zfEOnH94HLxcrlCM+cC6+st?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2aaec96b-3788-4313-14c3-08d91951c8c2
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2021 16:35:30.4172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WFDOHAQO12/EdHitJ983TeQdDh3E2Lrk2VnyQ+I6hWXUpC8QxH0h1IUz46el066TWxSL0FHkKU2GpxZySX79UQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2987
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/16/21 9:50 PM, Jon Kohler wrote:
> 
> 
>> On May 14, 2021, at 1:11 AM, Andy Lutomirski <luto@kernel.org> wrote:
>>
>> On Fri, May 7, 2021 at 9:45 AM Jon Kohler <jon@nutanix.com> wrote:
>>>
>>> kvm_load_host_xsave_state handles xsave on vm exit, part of which is
>>> managing memory protection key state. The latest arch.pkru is updated
>>> with a rdpkru, and if that doesn't match the base host_pkru (which
>>> about 70% of the time), we issue a __write_pkru.
>>
>> This thread caused me to read the code, and I don't get how it's even
>> remotely correct.
>>
>> First, kvm_load_guest_fpu() has this delight:
>>
>>    /*
>>     * Guests with protected state can't have it set by the hypervisor,
>>     * so skip trying to set it.
>>     */
>>    if (vcpu->arch.guest_fpu)
>>        /* PKRU is separately restored in kvm_x86_ops.run. */
>>        __copy_kernel_to_fpregs(&vcpu->arch.guest_fpu->state,
>>                    ~XFEATURE_MASK_PKRU);
>>
>> That's nice, but it fails to restore XINUSE[PKRU].  As far as I know,
>> that bit is live, and the only way to restore it to 0 is with
>> XRSTOR(S).
> 
> Thanks, Andy - Adding Tom Lendacky to this thread as that
> Particular snippet was last touched in ~5.11 in ed02b213098a.

It sounds like Andy's comment is separate from the changes associated with
commit ed02b213098a, right?

Commit ed02b213098a just added the check for vcpu->arch.guest_fpu to
support SEV-ES guests. Since the hypervisor can't save/restore those
registers directly when running under SEV-ES, we skip this. The state will
be restored when VMRUN is performed.

Thanks,
Tom

> 
>>
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index cebdaa1e3cf5..cd95adbd140c 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -912,10 +912,10 @@ void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
>>>        }
>>>
>>>        if (static_cpu_has(X86_FEATURE_PKU) &&
>>> -           (kvm_read_cr4_bits(vcpu, X86_CR4_PKE) ||
>>> -            (vcpu->arch.xcr0 & XFEATURE_MASK_PKRU)) &&
>>> -           vcpu->arch.pkru != vcpu->arch.host_pkru)
>>> -               __write_pkru(vcpu->arch.pkru);
>>> +           vcpu->arch.pkru != vcpu->arch.host_pkru &&
>>> +           ((vcpu->arch.xcr0 & XFEATURE_MASK_PKRU) ||
>>> +            kvm_read_cr4_bits(vcpu, X86_CR4_PKE)))
>>> +               __write_pkru(vcpu->arch.pkru, false);
>>
>> Please tell me I'm missing something (e.g. KVM very cleverly managing
>> the PKRU register using intercepts) that makes this reliably load the
>> guest value.  An innocent or malicious guest could easily make that
>> condition evaluate to false, thus allowing the host PKRU value to be
>> live in guest mode.  (Or is something fancy going on here?)
>>
>> I don't even want to think about what happens if a perf NMI hits and
>> accesses host user memory while the guest PKRU is live (on VMX -- I
>> think this can't happen on SVM).
> 
> Perhaps Babu / Dave can comment on the exiting logic here? Babu did
> some additional work to fix save/restore on 37486135d3a.
> 
> From this changes perspective, I’m just trying to get to the resultant
> evaluation a bit quicker, which this change (and the v3) seems to do
> ok with; however, if I’ve ran my ship into a larger ice berg, happy to
> collaborate to make it better overall.
> 
>>
>>> }
>>> EXPORT_SYMBOL_GPL(kvm_load_guest_xsave_state);
>>>
>>> @@ -925,11 +925,11 @@ void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
>>>                return;
>>>
>>>        if (static_cpu_has(X86_FEATURE_PKU) &&
>>> -           (kvm_read_cr4_bits(vcpu, X86_CR4_PKE) ||
>>> -            (vcpu->arch.xcr0 & XFEATURE_MASK_PKRU))) {
>>> +           ((vcpu->arch.xcr0 & XFEATURE_MASK_PKRU) ||
>>> +            kvm_read_cr4_bits(vcpu, X86_CR4_PKE))) {
>>>                vcpu->arch.pkru = rdpkru();
>>>                if (vcpu->arch.pkru != vcpu->arch.host_pkru)
>>> -                       __write_pkru(vcpu->arch.host_pkru);
>>> +                       __write_pkru(vcpu->arch.host_pkru, true);
>>>        }
>>
>> Suppose the guest writes to PKRU and then, without exiting, sets PKE =
>> 0 and XCR0[PKRU] = 0.  (Or are the intercepts such that this can't
>> happen except on SEV where maybe SEV magic makes the problem go away?)
>>
>> I admit I'm fairly mystified as to why KVM doesn't handle PKRU like
>> the rest of guest XSTATE.
> 
> I’ll defer to Dave/Babu here. This code has been this way for a bit now,
> I’m not sure at first glance if that situation could occur intentionally
> or accidentally, but that would evaluate the same both before and
> after this change, no?
> 
