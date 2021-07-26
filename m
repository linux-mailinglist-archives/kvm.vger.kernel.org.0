Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3A593D5ACD
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 15:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233954AbhGZNQs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 09:16:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:37540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230421AbhGZNQr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jul 2021 09:16:47 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E0CD6023F;
        Mon, 26 Jul 2021 13:57:16 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1m816Y-0013Q0-N0; Mon, 26 Jul 2021 14:57:14 +0100
MIME-Version: 1.0
Date:   Mon, 26 Jul 2021 14:57:14 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Juergen Gross <jgross@suse.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH 5/6] kvm: allocate vcpu pointer array separately
In-Reply-To: <2aed0475-3df0-5ac6-f393-042b5e798ebc@suse.com>
References: <20210701154105.23215-1-jgross@suse.com>
 <20210701154105.23215-6-jgross@suse.com>
 <001b7eab-ed7b-da27-a623-057781cf1211@redhat.com>
 <2aed0475-3df0-5ac6-f393-042b5e798ebc@suse.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <1643c773ce53d643f45feb53dbbfd819@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: jgross@suse.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, alexandru.elisei@arm.com, suzuki.poulose@arm.com, catalin.marinas@arm.com, will@kernel.org, seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-07-26 14:46, Juergen Gross wrote:
> On 26.07.21 15:40, Paolo Bonzini wrote:
>> On 01/07/21 17:41, Juergen Gross wrote:
>>>   {
>>> -    if (!has_vhe())
>>> +    if (!has_vhe()) {
>>> +        kfree(kvm->vcpus);
>>>           kfree(kvm);
>>> -    else
>>> +    } else {
>>> +        vfree(kvm->vcpus);
>>>           vfree(kvm);
>>> +    }
>>>   }
>>>   int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
>>> diff --git a/arch/x86/include/asm/kvm_host.h 
>>> b/arch/x86/include/asm/kvm_host.h
>>> index 79138c91f83d..39cbc4b6bffb 100644
>>> --- a/arch/x86/include/asm/kvm_host.h
>>> +++ b/arch/x86/include/asm/kvm_host.h
>>> @@ -1440,10 +1440,7 @@ static inline void 
>>> kvm_ops_static_call_update(void)
>>>   }
>>>   #define __KVM_HAVE_ARCH_VM_ALLOC
>>> -static inline struct kvm *kvm_arch_alloc_vm(void)
>>> -{
>>> -    return __vmalloc(kvm_x86_ops.vm_size, GFP_KERNEL_ACCOUNT | 
>>> __GFP_ZERO);
>>> -}
>>> +struct kvm *kvm_arch_alloc_vm(void);
>>>   void kvm_arch_free_vm(struct kvm *kvm);
>>>   #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index 3af398ef1fc9..a9b0bb2221ea 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -10741,9 +10741,28 @@ void kvm_arch_sched_in(struct kvm_vcpu 
>>> *vcpu, int cpu)
>>>       static_call(kvm_x86_sched_in)(vcpu, cpu);
>>>   }
>>> +struct kvm *kvm_arch_alloc_vm(void)
>>> +{
>>> +    struct kvm *kvm;
>>> +
>>> +    kvm = __vmalloc(kvm_x86_ops.vm_size, GFP_KERNEL_ACCOUNT | 
>>> __GFP_ZERO);
>>> +    if (!kvm)
>>> +        return NULL;
>>> +
>>> +    kvm->vcpus = __vmalloc(KVM_MAX_VCPUS * sizeof(void *),
>>> +                   GFP_KERNEL_ACCOUNT | __GFP_ZERO);
>>> +    if (!kvm->vcpus) {
>>> +        vfree(kvm);
>>> +        kvm = NULL;
>>> +    }
>>> +
>> 
>> Let's keep this cleaner:
>> 
>> 1) use kvfree in the common version of kvm_arch_free_vm
>> 
>> 2) split __KVM_HAVE_ARCH_VM_ALLOC and __KVM_HAVE_ARCH_VM_FREE (ARM 
>> does not need it once kvfree is used)
>> 
>> 3) define a __kvm_arch_free_vm version that is defined even if 
>> !__KVM_HAVE_ARCH_VM_FREE, and which can be used on x86.
> 
> Okay, will do so.

I'd appreciate if you could Cc me on the whole series, and
not just the single arm64 patch.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
