Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9616D475D75
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 17:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244829AbhLOQbY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 11:31:24 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:50602 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238312AbhLOQbX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Dec 2021 11:31:23 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R921e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=laijs@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0V-juVKl_1639585878;
Received: from 30.32.64.86(mailfrom:laijs@linux.alibaba.com fp:SMTPD_---0V-juVKl_1639585878)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 16 Dec 2021 00:31:20 +0800
Message-ID: <604709fa-e8bd-4eb6-6b79-8bf031a785ce@linux.alibaba.com>
Date:   Thu, 16 Dec 2021 00:31:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH 11/15] KVM: VMX: Update vmcs.GUEST_CR3 only when the guest
 CR3 is dirty
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
References: <20211108124407.12187-1-jiangshanlai@gmail.com>
 <20211108124407.12187-12-jiangshanlai@gmail.com>
 <0271da9d3a7494d9e7439d4b8d6d9c857c83a45e.camel@redhat.com>
From:   Lai Jiangshan <laijs@linux.alibaba.com>
In-Reply-To: <0271da9d3a7494d9e7439d4b8d6d9c857c83a45e.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/12/15 23:47, Maxim Levitsky wrote:
> On Mon, 2021-11-08 at 20:44 +0800, Lai Jiangshan wrote:
>> From: Lai Jiangshan <laijs@linux.alibaba.com>
>>
>> When vcpu->arch.cr3 is changed, it is marked dirty, so vmcs.GUEST_CR3
>> can be updated only when kvm_register_is_dirty(vcpu, VCPU_EXREG_CR3).
>>
>> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
>> ---
>>   arch/x86/kvm/vmx/vmx.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index d94e51e9c08f..38b65b97fb7b 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -3126,9 +3126,9 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
>>   
>>   		if (!enable_unrestricted_guest && !is_paging(vcpu))
>>   			guest_cr3 = to_kvm_vmx(kvm)->ept_identity_map_addr;
>> -		else if (test_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail))
>> +		else if (kvm_register_is_dirty(vcpu, VCPU_EXREG_CR3))
>>   			guest_cr3 = vcpu->arch.cr3;
>> -		else /* vmcs01.GUEST_CR3 is already up-to-date. */
>> +		else /* vmcs.GUEST_CR3 is already up-to-date. */
>>   			update_guest_cr3 = false;
>>   		vmx_ept_load_pdptrs(vcpu);
>>   	} else {
> 
> 
> I just bisected this patch to break booting a VM with ept=1 but unrestricted_guest=0
> (I needed to re-test unrestricted_guest=0 bug related to SMM, but didn't want
> to boot without EPT. With ept=0,the VM boots with this patch applied).
> 


Thanks for reporting.

Sorry, I never tested it with unrestricted_guest=0. I can't reproduce it now shortly
with unrestricted_guest=0.  Maybe it can be reproduced easily if I try more guests or
I write a piece of guest code to deliberate hit it if the following analyses is correct.

All the paths changing %cr3 are followed with kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3)
and GUEST_CR3 will be expected to be updated.

What I missed is the case of "if (!enable_unrestricted_guest && !is_paging(vcpu))"
in vmx_load_mmu_pgd() which doesn't load GUEST_CR3 but clears dirty of VCPU_EXREG_CR3
(when after next run).

So when CR0 !PG -> PG, VCPU_EXREG_CR3 dirty bit should be set.

Maybe adding the following patch on top of the original patch can work.

Thanks
Lai

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 85127b3e3690..55b45005ebb9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -858,6 +858,7 @@ void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned lon
  	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
  		kvm_clear_async_pf_completion_queue(vcpu);
  		kvm_async_pf_hash_reset(vcpu);
+		kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
  	}

  	if ((cr0 ^ old_cr0) & KVM_MMU_CR0_ROLE_BITS)

