Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8119446CBD0
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 05:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233263AbhLHEEP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 23:04:15 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:51931 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229958AbhLHEEO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 23:04:14 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R681e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=laijs@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0Uzq5Sf3_1638936038;
Received: from 30.22.113.150(mailfrom:laijs@linux.alibaba.com fp:SMTPD_---0Uzq5Sf3_1638936038)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 08 Dec 2021 12:00:39 +0800
Message-ID: <04d4d0bc-0ef4-f9a3-593b-149f835c74be@linux.alibaba.com>
Date:   Wed, 8 Dec 2021 12:00:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH 17/15] KVM: X86: Ensure pae_root to be reconstructed for
 shadow paging if the guest PDPTEs is changed
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Xiao Guangrong <guangrong.xiao@linux.intel.com>
References: <20211108124407.12187-1-jiangshanlai@gmail.com>
 <20211111144634.88972-1-jiangshanlai@gmail.com> <Ya/5MOYef4L4UUAb@google.com>
From:   Lai Jiangshan <laijs@linux.alibaba.com>
In-Reply-To: <Ya/5MOYef4L4UUAb@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/12/8 08:15, Sean Christopherson wrote:
>>
>> The commit 21823fbda552("KVM: x86: Invalidate all PGDs for the current
>> PCID on MOV CR3 w/ flush") skips kvm_mmu_free_roots() after
>> load_pdptrs() when rewriting the CR3 with the same value.
> 
> This isn't accurate, prior to that commit KVM wasn't guaranteed to do
> kvm_mmu_free_roots() if it got a hit on the current CR3 or if a previous CR3 in
> the cache matched the new CR3 (the "cache" has done some odd things in the past).
> 
> So I think this particular flavor would be:
> 
>    Fixes: 7c390d350f8b ("kvm: x86: Add fast CR3 switch code path")

If guest is 32bit, fast_cr3_switch() always return false, and
kvm_mmu_free_roots() is always called, and no cr3 goes in prev_root.

And from 21823fbda552, fast_cr3_switch() and kvm_mmu_free_roots() are
both skipped when cr3 is unchanged.

> 
>> The commit a91a7c709600("KVM: X86: Don't reset mmu context when
>> toggling X86_CR4_PGE") skips kvm_mmu_reset_context() after
>> load_pdptrs() when changing CR4.PGE.
>>
>> Normally, the guest doesn't change the PDPTEs before doing only the
>> above operation without touching other bits that can force pae_root to
>> be reconstructed.  Guests like linux would keep the PDPTEs unchaged
>> for every instance of pagetable.
>>
>> Fixes: d81135a57aa6("KVM: x86: do not reset mmu if CR0.CD and CR0.NW are changed")
>> Fixes: 21823fbda552("KVM: x86: Invalidate all PGDs for the current PCID on MOV CR3 w/ flush")
>> Fixes: a91a7c709600("KVM: X86: Don't reset mmu context when toggling X86_CR4_PGE")
>> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
>> ---
>>   arch/x86/kvm/x86.c | 10 ++++++++--
>>   1 file changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 0176eaa86a35..cfba337e46ab 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -832,8 +832,14 @@ int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3)
>>   	if (memcmp(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs))) {
>>   		memcpy(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs));
>>   		kvm_register_mark_dirty(vcpu, VCPU_EXREG_PDPTR);
>> -		/* Ensure the dirty PDPTEs to be loaded. */
>> -		kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
>> +		/*
>> +		 * Ensure the dirty PDPTEs to be loaded for VMX with EPT
>> +		 * enabled or pae_root to be reconstructed for shadow paging.
>> +		 */
>> +		if (tdp_enabled)
>> +			kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
>> +		else
>> +			kvm_mmu_free_roots(vcpu, vcpu->arch.mmu, KVM_MMU_ROOT_CURRENT);
> 
> Shouldn't matter since it's legacy shadow paging, but @mmu should be used instead
> of vcpu->arch.mmuvcpu->arch.mmu.

@mmu is the "guest mmu" (vcpu->arch.walk_mmu), which is used to walk
including loading pdptr.

vcpu->arch.mmu is for host constructing mmu for shadowed or tdp mmu
which is used in host side management including kvm_mmu_free_roots().

Even they are the same pointer now for !tdp, the meaning is different.  I prefer
to distinguish them even before kvm_mmu is split different for guest mmu
(vcpu->arch.walk_mmu) and host constructing mmu (vcpu->arch.mmu).

(I once searched all the usage of undistinguished usage of kvm_mmu *mmu, and
found a bug, see "Use vcpu->arch.walk_mmu for kvm_mmu_invlpg()")

I think Paolo is doing the splitting, unless I would take the job because
I have some patches pending depended them.

> 
> To avoid a dependency on the previous patch, I think it makes sense to have this be:
> 
> 	if (!tdp_enabled && memcmp(mmu->pdptrs, pdpte, sizeof(mmu->pdptrs)))
> 		kvm_mmu_free_roots(vcpu, mmu, KVM_MMU_ROOT_CURRENT);
> 

Yes, it is a good idea to add this first.

Thanks for review and suggestion.
Lai
