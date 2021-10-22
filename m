Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3D55436EC4
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 02:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231961AbhJVAYj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 20:24:39 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:56158 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229512AbhJVAYi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 20:24:38 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=laijs@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0UtBmaPJ_1634862139;
Received: from C02XQCBJJG5H.local(mailfrom:laijs@linux.alibaba.com fp:SMTPD_---0UtBmaPJ_1634862139)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 22 Oct 2021 08:22:20 +0800
Subject: Re: [PATCH 1/4] KVM: X86: Fix tlb flush for tdp in
 kvm_invalidate_pcid()
To:     Sean Christopherson <seanjc@google.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
References: <20211019110154.4091-1-jiangshanlai@gmail.com>
 <20211019110154.4091-2-jiangshanlai@gmail.com> <YW7jfIMduQti8Zqk@google.com>
 <da4dfc96-b1ad-024c-e769-29d3af289eee@linux.alibaba.com>
 <YXBfaqenOhf+M3eA@google.com>
 <55abc519-b528-ddaa-120d-8d157b520623@linux.alibaba.com>
 <YXF+pG0yGA0TQZww@google.com>
From:   Lai Jiangshan <laijs@linux.alibaba.com>
Message-ID: <a79bbdb6-9d24-7674-2a77-f1f68b64635f@linux.alibaba.com>
Date:   Fri, 22 Oct 2021 08:22:19 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YXF+pG0yGA0TQZww@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/10/21 22:52, Sean Christopherson wrote:
> On Thu, Oct 21, 2021, Lai Jiangshan wrote:
>>
>>
>> On 2021/10/21 02:26, Sean Christopherson wrote:
>>> On Wed, Oct 20, 2021, Lai Jiangshan wrote:
>>>> On 2021/10/19 23:25, Sean Christopherson wrote:
>>>> I just read some interception policy in vmx.c, if EPT=1 but vmx_need_pf_intercept()
>>>> return true for some reasons/configs, #PF is intercepted.  But CR3 write is not
>>>> intercepted, which means there will be an EPT fault _after_ (IIUC) the CR3 write if
>>>> the GPA of the new CR3 exceeds the guest maxphyaddr limit.  And kvm queues a fault to
>>>> the guest which is also _after_ the CR3 write, but the guest expects the fault before
>>>> the write.
>>>>
>>>> IIUC, it can be fixed by intercepting CR3 write or reversing the CR3 write in EPT
>>>> violation handler.
>>>
>>> KVM implicitly does the latter by emulating the faulting instruction.
>>>
>>>     static int handle_ept_violation(struct kvm_vcpu *vcpu)
>>>     {
>>> 	...
>>>
>>> 	/*
>>> 	 * Check that the GPA doesn't exceed physical memory limits, as that is
>>> 	 * a guest page fault.  We have to emulate the instruction here, because
>>> 	 * if the illegal address is that of a paging structure, then
>>> 	 * EPT_VIOLATION_ACC_WRITE bit is set.  Alternatively, if supported we
>>> 	 * would also use advanced VM-exit information for EPT violations to
>>> 	 * reconstruct the page fault error code.
>>> 	 */
>>> 	if (unlikely(allow_smaller_maxphyaddr && kvm_vcpu_is_illegal_gpa(vcpu, gpa)))
>>> 		return kvm_emulate_instruction(vcpu, 0);
>>>
>>> 	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
>>>     }
>>>
>>> and injecting a #GP when kvm_set_cr3() fails.
>>
>> I think the EPT violation happens *after* the cr3 write.  So the instruction to be
>> emulated is not "cr3 write".  The emulation will queue fault into guest though,
>> recursive EPT violation happens since the cr3 exceeds maxphyaddr limit.
> 
> Doh, you're correct.  I think my mind wandered into thinking about what would
> happen with PDPTRs and forgot to get back to normal MOV CR3.
> 
> So yeah, the only way to correctly handle this would be to intercept CR3 loads.
> I'm guessing that would have a noticeable impact on guest performance.

I think we can detect it in handle_ept_violation() via checking the cr3 value,
and make it triple-fault if it is the case, so that the VMM can exit.  I don't
think any OS would use the reserved bit in CR3 and the corresponding #GP.

> 
> Paolo, I'll leave this one for you to decide, we have pretty much written off
> allow_smaller_maxphyaddr :-)
> 
