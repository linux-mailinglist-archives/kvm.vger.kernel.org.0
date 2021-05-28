Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13941393AE7
	for <lists+kvm@lfdr.de>; Fri, 28 May 2021 03:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234748AbhE1BOr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 21:14:47 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:43438 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233887AbhE1BOp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 May 2021 21:14:45 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R851e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=laijs@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0UaJKUwf_1622164388;
Received: from C02XQCBJJG5H.local(mailfrom:laijs@linux.alibaba.com fp:SMTPD_---0UaJKUwf_1622164388)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 28 May 2021 09:13:09 +0800
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
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
References: <20210527023922.2017-1-jiangshanlai@gmail.com>
 <78ad9dff-9a20-c17f-cd8f-931090834133@redhat.com>
 <YK/FGYejaIu6EzSn@google.com> <YK/FbFzKhZEmI40C@google.com>
 <YK/y3QgSg+aYk9Z+@google.com>
From:   Lai Jiangshan <laijs@linux.alibaba.com>
Message-ID: <fc0f8b39-11a9-da21-dc5b-fc9695292556@linux.alibaba.com>
Date:   Fri, 28 May 2021 09:13:08 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YK/y3QgSg+aYk9Z+@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/5/28 03:28, Sean Christopherson wrote:
> On Thu, May 27, 2021, Sean Christopherson wrote:
>>> KVM_REQ_MMU_RELOAD is overkill, nuking the shadow page tables will completely
>>> offset the performance gains of the paravirtualized flush.
> 
> Argh, I take that back.  The PV KVM_VCPU_FLUSH_TLB flag doesn't distinguish
> between flushing a specific mm and flushing the entire TLB.  The HyperV usage
> (via KVM_REQ) also throws everything into a single bucket.  A full RELOAD still
> isn't necessary as KVM just needs to sync all roots, not blast them away.  For
> previous roots, KVM doesn't have a mechanism to defer the sync, so the immediate
> fix will need to unload those roots.
> 
> And looking at KVM's other flows, __kvm_mmu_new_pgd() and kvm_set_cr3() are also
> broken with respect to previous roots.  E.g. if the guest does a MOV CR3 that
> flushes the entire TLB, followed by a MOV CR3 with PCID_NOFLUSH=1, KVM will fail
> to sync the MMU on the second flush even though the guest can technically rely
> on the first MOV CR3 to have synchronized any previous changes relative to the
> fisrt MOV CR3.

Could you elaborate the problem please?
When can a MOV CR3 that needs to flush the entire TLB if PCID is enabled?

If CR4.PCIDE = 1 and bit 63 of the instruction’s source operand is 0, the instruction invalidates all TLB entries 
associated with the PCID specified in bits 11:0 of the instruction’s source operand except those for global pages. It 
also invalidates all entries in all paging-structure caches associated with that PCID. It is not required to invalidate 
entries in the TLBs and paging-structure caches that are associated with other PCIDs.

> 
> Lai, if it's ok with you, I'll massage this patch as discussed and fold it into
> a larger series to fix the other bugs and do additional cleanup/improvements.
> 
>>> I believe the minimal fix is:
>>>
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index 81ab3b8f22e5..b0072063f9bf 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -3072,6 +3072,9 @@ static void kvm_vcpu_flush_tlb_all(struct kvm_vcpu *vcpu)
>>>   static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
>>>   {
>>>          ++vcpu->stat.tlb_flush;
>>> +
>>> +       if (!tdp_enabled)
>>> +               kvm_mmu_sync_roots(vcpu);
>>>          static_call(kvm_x86_tlb_flush_guest)(vcpu);
>>>   }
