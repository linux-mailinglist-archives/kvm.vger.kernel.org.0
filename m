Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB05C4871D7
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 05:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346086AbiAGEhD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 23:37:03 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:33518 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346075AbiAGEhA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Jan 2022 23:37:00 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=laijs@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0V19C5WZ_1641530215;
Received: from 30.22.113.103(mailfrom:laijs@linux.alibaba.com fp:SMTPD_---0V19C5WZ_1641530215)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 07 Jan 2022 12:36:56 +0800
Message-ID: <142c192f-f8a5-cd52-fe85-6cbccd6c2a9b@linux.alibaba.com>
Date:   Fri, 7 Jan 2022 12:36:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [RFC PATCH 5/6] KVM: X86: Alloc pae_root shadow page
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
References: <20211210092508.7185-1-jiangshanlai@gmail.com>
 <20211210092508.7185-6-jiangshanlai@gmail.com> <YdTCKoTgI5IgOvln@google.com>
 <CAJhGHyAOyR6yGdyxsKydt_+HboGjxc-psbbSCqsrBo4WgUgQsQ@mail.gmail.com>
 <YdXLNEwCY8cqV7KS@google.com>
 <dc8f2508-35ac-0dee-2465-4b5a8e3879ca@linux.alibaba.com>
 <YddF+6eX7ycAsZLr@google.com>
From:   Lai Jiangshan <laijs@linux.alibaba.com>
In-Reply-To: <YddF+6eX7ycAsZLr@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2022/1/7 03:41, Sean Christopherson wrote:
> On Thu, Jan 06, 2022, Lai Jiangshan wrote:
>>
>>
>> On 2022/1/6 00:45, Sean Christopherson wrote:
>>> On Wed, Jan 05, 2022, Lai Jiangshan wrote:
>>>> On Wed, Jan 5, 2022 at 5:54 AM Sean Christopherson <seanjc@google.com> wrote:
>>>>
>>>>>>
>>>>>> default_pae_pdpte is needed because the cpu expect PAE pdptes are
>>>>>> present when VMenter.
>>>>>
>>>>> That's incorrect.  Neither Intel nor AMD require PDPTEs to be present.  Not present
>>>>> is perfectly ok, present with reserved bits is what's not allowed.
>>>>>
>>>>> Intel SDM:
>>>>>     A VM entry that checks the validity of the PDPTEs uses the same checks that are
>>>>>     used when CR3 is loaded with MOV to CR3 when PAE paging is in use[7].  If MOV to CR3
>>>>>     would cause a general-protection exception due to the PDPTEs that would be loaded
>>>>>     (e.g., because a reserved bit is set), the VM entry fails.
>>>>>
>>>>>     7. This implies that (1) bits 11:9 in each PDPTE are ignored; and (2) if bit 0
>>>>>        (present) is clear in one of the PDPTEs, bits 63:1 of that PDPTE are ignored.
>>>>
>>>> But in practice, the VM entry fails if the present bit is not set in the
>>>> PDPTE for the linear address being accessed (when EPT enabled at least).  The
>>>> host kvm complains and dumps the vmcs state.
>>>
>>> That doesn't make any sense.  If EPT is enabled, KVM should never use a pae_root.
>>> The vmcs.GUEST_PDPTRn fields are in play, but those shouldn't derive from KVM's
>>> shadow page tables.
>>
>> Oh, I wrote the negative what I want to say again when I try to emphasis
>> something after I wrote a sentence and modified it several times.
>>
>> I wanted to mean "EPT not enabled" when vmx.
> 
> Heh, that makes a lot more sense.
> 
>> The VM entry fails when the guest is in very early stage when booting which
>> might be still in real mode.
>>
>> VMEXIT: intr_info=00000000 errorcode=0000000 ilen=00000000
>> reason=80000021 qualification=0000000000000002
> 
> Yep, that's the signature for an illegal PDPTE at VM-Enter.  But as noted above,
> a not-present PDPTE is perfectly legal, VM-Enter should failed if and only if a
> PDPTE is present and has reserved bits set.
> 
>> IDTVectoring: info=00000000 errorcode=00000000
>>
>>>
>>> And I doubt there is a VMX ucode bug at play, as KVM currently uses '0' in its
>>> shadow page tables for not-present PDPTEs.
>>>
>>> If you can post/provide the patches that lead to VM-Fail, I'd be happy to help
>>> debug.
>>
>> If you can try this patchset, you can just set the default_pae_pdpte to 0 to test
>> it.
> 
> I can't reproduce the failure with this on top of your series + kvm/queue (commit
> cc0e35f9c2d4 ("KVM: SVM: Nullify vcpu_(un)blocking() hooks if AVIC is disabled")).
> 


I can't reproduce the failure with this code base either.  And I can't reproduce
the failure when I switch to the code base when I developed it.

After reviewing all the logs I saved that time, I think it was fixed after
make_pae_pdpte().  I should have added make_pae_pdpte() first before added
default_pae_pdpte.  (The code was still mess and the guest can't fully
function even when make_pae_pdpte() was added that time)

Removing default_pae_pdpte will simplify the code. Thank you.

Thanks
Lai.
