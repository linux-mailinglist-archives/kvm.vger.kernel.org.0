Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6413D393A31
	for <lists+kvm@lfdr.de>; Fri, 28 May 2021 02:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234438AbhE1AUV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 20:20:21 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:50120 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229911AbhE1AUU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 May 2021 20:20:20 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=laijs@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0UaJXb16_1622161123;
Received: from C02XQCBJJG5H.local(mailfrom:laijs@linux.alibaba.com fp:SMTPD_---0UaJXb16_1622161123)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 28 May 2021 08:18:44 +0800
Subject: Re: [PATCH] KVM: X86: fix tlb_flush_guest()
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
References: <20210527023922.2017-1-jiangshanlai@gmail.com>
 <78ad9dff-9a20-c17f-cd8f-931090834133@redhat.com>
 <YK/FGYejaIu6EzSn@google.com>
From:   Lai Jiangshan <laijs@linux.alibaba.com>
Message-ID: <d96f8c11-19e6-2c2d-91ff-6a7a51fa1b9c@linux.alibaba.com>
Date:   Fri, 28 May 2021 08:18:43 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YK/FGYejaIu6EzSn@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/5/28 00:13, Sean Christopherson wrote:
> +Maxim - A proper fix for this bug might fix your shadow paging + win10 boot
>           issue, this also affects the KVM_REQ_HV_TLB_FLUSH used for HyperV PV
> 	 flushing.
> 
> On Thu, May 27, 2021, Paolo Bonzini wrote:
>> On 27/05/21 04:39, Lai Jiangshan wrote:
>>> From: Lai Jiangshan <laijs@linux.alibaba.com>
>>>
>>> For KVM_VCPU_FLUSH_TLB used in kvm_flush_tlb_multi(), the guest expects
>>> the hypervisor do the operation that equals to native_flush_tlb_global()
>>> or invpcid_flush_all() in the specified guest CPU.
>>>
>>> When TDP is enabled, there is no problem to just flush the hardware
>>> TLB of the specified guest CPU.
>>>
>>> But when using shadowpaging, the hypervisor should have to sync the
>>> shadow pagetable at first before flushing the hardware TLB so that
>>> it can truely emulate the operation of invpcid_flush_all() in guest.
>>
>> Can you explain why?
> 
> KVM's unsync logic hinges on guest TLB flushes.  For page permission modifications
> that require a TLB flush to take effect, e.g. making a writable page read-only,
> KVM waits until the guest explicitly does said flush to propagate the changes to
> the shadow page tables.  E.g. failure to sync PTEs could result in a read-only 4k
> page being writable when the guest expects it to be read-only.
> 
>> Also it is simpler to handle this in kvm_vcpu_flush_tlb_guest, using "if
>> (tdp_enabled).  This provides also a single, good place to add a comment
>> with the explanation of what invalid entries KVM_REQ_RELOAD is presenting.
> 
> Ya.
> 
> KVM_REQ_MMU_RELOAD is overkill, nuking the shadow page tables will completely
> offset the performance gains of the paravirtualized flush >
> And making a request won't work without revamping the order of request handling
> in vcpu_enter_guest(), e.g. KVM_REQ_MMU_RELOAD and KVM_REQ_MMU_SYNC are both
> serviced before KVM_REQ_STEAL_UPDATE.

Yes, it just fixes the said problem in the simplest way.
I copied KVM_REQ_MMU_RELOAD from kvm_handle_invpcid(INVPCID_TYPE_ALL_INCL_GLOBAL).
(If the guest is not preempted, it will call invpcid_flush_all() and will be handled
by this way)


The improvement code will go later, and will not be backported.
The proper way to flush guest is to use code in

https://lore.kernel.org/lkml/20210525213920.3340-1-jiangshanlai@gmail.com/
as:
+		kvm_mmu_sync_roots(vcpu);
+		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu); //or just call flush_current directly
+		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
+			vcpu->arch.mmu->prev_roots[i].need_sync = true;

If need_sync patch is not accepted, we can just use kvm_mmu_sync_roots(vcpu)
to keep the current pagetable and use kvm_mmu_free_roots() to free all the other
roots in prev_roots.



> 
> Cleaning up and documenting the MMU related requests is on my todo list, but the
> immediate fix should be tiny and I can do my cleanups on top.
> 
> I believe the minimal fix is:
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 81ab3b8f22e5..b0072063f9bf 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3072,6 +3072,9 @@ static void kvm_vcpu_flush_tlb_all(struct kvm_vcpu *vcpu)
>   static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
>   {
>          ++vcpu->stat.tlb_flush;
> +
> +       if (!tdp_enabled)
> +               kvm_mmu_sync_roots(vcpu);

it doesn't handle prev_roots which are also needed as
shown in kvm_handle_invpcid(INVPCID_TYPE_ALL_INCL_GLOBAL).

>          static_call(kvm_x86_tlb_flush_guest)(vcpu);

For tdp_enabled, I think it is better to use kvm_x86_tlb_flush_current()
to make it consistent with other shadowpage code.

>   }
>   
> 
