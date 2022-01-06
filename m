Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7B50485E63
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 03:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344560AbiAFCBo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 21:01:44 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:45746 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344518AbiAFCBo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Jan 2022 21:01:44 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R701e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=laijs@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0V13mZFO_1641434499;
Received: from 192.168.2.97(mailfrom:laijs@linux.alibaba.com fp:SMTPD_---0V13mZFO_1641434499)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 06 Jan 2022 10:01:40 +0800
Message-ID: <dc8f2508-35ac-0dee-2465-4b5a8e3879ca@linux.alibaba.com>
Date:   Thu, 6 Jan 2022 10:01:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [RFC PATCH 5/6] KVM: X86: Alloc pae_root shadow page
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
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
From:   Lai Jiangshan <laijs@linux.alibaba.com>
In-Reply-To: <YdXLNEwCY8cqV7KS@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2022/1/6 00:45, Sean Christopherson wrote:
> On Wed, Jan 05, 2022, Lai Jiangshan wrote:
>> On Wed, Jan 5, 2022 at 5:54 AM Sean Christopherson <seanjc@google.com> wrote:
>>
>>>>
>>>> default_pae_pdpte is needed because the cpu expect PAE pdptes are
>>>> present when VMenter.
>>>
>>> That's incorrect.  Neither Intel nor AMD require PDPTEs to be present.  Not present
>>> is perfectly ok, present with reserved bits is what's not allowed.
>>>
>>> Intel SDM:
>>>    A VM entry that checks the validity of the PDPTEs uses the same checks that are
>>>    used when CR3 is loaded with MOV to CR3 when PAE paging is in use[7].  If MOV to CR3
>>>    would cause a general-protection exception due to the PDPTEs that would be loaded
>>>    (e.g., because a reserved bit is set), the VM entry fails.
>>>
>>>    7. This implies that (1) bits 11:9 in each PDPTE are ignored; and (2) if bit 0
>>>       (present) is clear in one of the PDPTEs, bits 63:1 of that PDPTE are ignored.
>>
>> But in practice, the VM entry fails if the present bit is not set in the
>> PDPTE for the linear address being accessed (when EPT enabled at least).  The
>> host kvm complains and dumps the vmcs state.
> 
> That doesn't make any sense.  If EPT is enabled, KVM should never use a pae_root.
> The vmcs.GUEST_PDPTRn fields are in play, but those shouldn't derive from KVM's
> shadow page tables.

Oh, I wrote the negative what I want to say again when I try to emphasis
something after I wrote a sentence and modified it several times.

I wanted to mean "EPT not enabled" when vmx.

The VM entry fails when the guest is in very early stage when booting which
might be still in real mode.

VMEXIT: intr_info=00000000 errorcode=0000000 ilen=00000000
reason=80000021 qualification=0000000000000002

IDTVectoring: info=00000000 errorcode=00000000

> 
> And I doubt there is a VMX ucode bug at play, as KVM currently uses '0' in its
> shadow page tables for not-present PDPTEs.
> 
> If you can post/provide the patches that lead to VM-Fail, I'd be happy to help
> debug.

If you can try this patchset, you can just set the default_pae_pdpte to 0 to test
it.

If you can't try this patchset, the mmu->pae_root can be possible to be modified
to test it.

I guess the vmx fails to translate %rip when VMentry in this case.



