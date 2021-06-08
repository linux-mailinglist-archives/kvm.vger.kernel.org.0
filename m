Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1717339F85A
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 16:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbhFHODU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 10:03:20 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:46965 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233076AbhFHODU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Jun 2021 10:03:20 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R281e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=laijs@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0Ublzl.x_1623160884;
Received: from C02XQCBJJG5H.local(mailfrom:laijs@linux.alibaba.com fp:SMTPD_---0Ublzl.x_1623160884)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 08 Jun 2021 22:01:25 +0800
Subject: Re: [PATCH V2] KVM: X86: fix tlb_flush_guest()
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
References: <4c3ef411ba68ca726531a379fb6c9d16178c8513.camel@redhat.com>
 <20210531172256.2908-1-jiangshanlai@gmail.com>
 <9d457b982c3fcd6e7413065350b9f860d45a6e47.camel@redhat.com>
 <YL6z5sv7cnsbZhvT@google.com>
From:   Lai Jiangshan <laijs@linux.alibaba.com>
Message-ID: <abcfa1a3-982b-ccf5-5e6f-16e63ac03dbc@linux.alibaba.com>
Date:   Tue, 8 Jun 2021 22:01:24 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YL6z5sv7cnsbZhvT@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/6/8 08:03, Sean Christopherson wrote:
> On Tue, Jun 08, 2021, Maxim Levitsky wrote:
>> So this patch *does* fix the windows boot without TDP!
> 
> Woot!
> 
>> Tested-by: Maxim Levitsky <mlevitsk@redhat.com>
>> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> 
> Lai,
> 
> I have a reworded version of your patch sitting in a branch that leverages this
> path to fix similar bugs and do additional cleanup.  Any objection to me gathering
> Maxim's tags and posting the version below?  I'm more than happy to hold off if
> you'd prefer to send your own version, but I don't want to send my own series
> without this fix as doing so would introduce bugs.

Sean

Wow, thank you, it is an excellent rewording and I'm happy with it.

I'm looking forward to your series and I will remake the "need_sync"[1] patch
to more precisely keep&synchronize roots in few days if there is no other
optimization.

Thanks
Lai

[1]: https://lore.kernel.org/lkml/20210525213920.3340-1-jiangshanlai@gmail.com/

> 
> Thanks!
> 
> Author: Lai Jiangshan <laijs@linux.alibaba.com>
> Date:   Tue Jun 1 01:22:56 2021 +0800
> 
>      KVM: x86: Unload MMU on guest TLB flush if TDP disabled to force MMU sync
>      
>      When using shadow paging, unload the guest MMU when emulating a guest TLB
>      flush to all roots are synchronized.  From the guest's perspective,
>      flushing the TLB ensures any and all modifications to its PTEs will be
>      recognized by the CPU.
>      
>      Note, unloading the MMU is overkill, but is done to mirror KVM's existing
>      handling of INVPCID(all) and ensure the bug is squashed.  Future cleanup
>      can be done to more precisely synchronize roots when servicing a guest
>      TLB flush.
>      
>      If TDP is enabled, synchronizing the MMU is unnecessary even if nested
>      TDP is in play, as a "legacy" TLB flush from L1 does not invalidate L1's
>      TDP mappgins.  For EPT, an explicit INVEPT is required to invalidate
>      guest-physical mappings.  For NPT, guest mappings are always tagged with
>      an ASID and thus can only be invalidated via the VMCB's ASID control.
>      
>      This bug has existed since the introduction of KVM_VCPU_FLUSH_TLB, but
>      was only recently exposed after Linux guests stopped flushing the local
>      CPU's TLB prior to flushing remote TLBs (see commit 4ce94eabac16,
>      "x86/mm/tlb: Flush remote and local TLBs concurrently").
>      
>      Tested-by: Maxim Levitsky <mlevitsk@redhat.com>
>      Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
>      Fixes: f38a7b75267f ("KVM: X86: support paravirtualized help for TLB shootdowns")
>      Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
>      [sean: massaged comment and changelog]
>      Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 1cd6d4685932..3b02528d5ee8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3072,6 +3072,18 @@ static void kvm_vcpu_flush_tlb_all(struct kvm_vcpu *vcpu)
>   static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
>   {
>          ++vcpu->stat.tlb_flush;
> +
> +       if (!tdp_enabled) {
> +               /*
> +                * Unload the entire MMU to force a sync of the shadow page
> +                * tables.  A TLB flush on behalf of the guest is equivalent
> +                * to INVPCID(all), toggling CR4.PGE, etc...  Note, loading the
> +                * MMU will also do an actual TLB flush.
> +                */
> +               kvm_mmu_unload(vcpu);
> +               return;
> +       }
> +
>          static_call(kvm_x86_tlb_flush_guest)(vcpu);
>   }
>   
> 
>> More notes from the testing I just did:
>>   
>> 1. On AMD with npt=0, the windows VM boots very slowly, and then in the task manager
>> I see that it booted with 1 CPU, although I configured it for 3-28 vCPUs (doesn't matter how many)
>> I tested this with several win10 VMs, same pattern repeats.
> 
> That's very odd.  Maybe it's so slow that the guest gives up on the AP and marks
> it as dead?  That seems unlikely though, I can't imagine waking APs would be
> _that_ slow.
> 
>> 2. The windows nag screen about "we beg you to open a microsoft account" makes the VM enter a live lock.
>> I see about half million at least VM exits per second due to page faults and it is stuck in 'please wait' screen
>> while with NPT=1 it shows up instantly. The VM has 12 GB of ram so I don't think RAM is an issue.
>>   
>> It's likely that those are just result of unoptimized code in regard to TLB flushes,
>> and timeouts in windows.
>> On my Intel laptop, the VM is way faster with EPT=0 and it boots with 3 vCPUs just fine
>> (the laptop has just dual core CPU, so I can't really give more that 3 vCPU to the VM)
> 
> Any chance your Intel CPU has PCID?  Although the all-contexts INVPCID emulation
> nukes everything, the single-context INVPCID emulation in KVM is optimized to
> (a) sync the current MMU (if necessary) instead of unloading it and (b) free
> only roots with the matching PCID.  I believe all other forms of TLB flushing
> that are likely to be used by the guest will lead to KVM unloading the entire
> MMU and rebuilding it from scratch.
> 
