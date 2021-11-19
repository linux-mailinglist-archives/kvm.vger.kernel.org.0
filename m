Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C34F456703
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 01:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233775AbhKSAwS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 19:52:18 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:35660 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233763AbhKSAwQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 19:52:16 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R561e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=laijs@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0UxFMHV9_1637282952;
Received: from 192.168.2.97(mailfrom:laijs@linux.alibaba.com fp:SMTPD_---0UxFMHV9_1637282952)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 19 Nov 2021 08:49:13 +0800
Message-ID: <a585633c-4687-d7b7-80b8-da487a42bedc@linux.alibaba.com>
Date:   Fri, 19 Nov 2021 08:49:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH 13/15] KVM: SVM: Add and use svm_register_cache_reset()
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
References: <20211108124407.12187-1-jiangshanlai@gmail.com>
 <20211108124407.12187-14-jiangshanlai@gmail.com>
 <937c373e-80f4-38d9-b45a-a655dcb66569@redhat.com>
 <55654594-9967-37d2-335b-5035f99212fe@linux.alibaba.com>
 <f2a99afc-6ce6-459d-05d5-a2e396af96d4@redhat.com>
From:   Lai Jiangshan <laijs@linux.alibaba.com>
In-Reply-To: <f2a99afc-6ce6-459d-05d5-a2e396af96d4@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/11/19 01:54, Paolo Bonzini wrote:
> On 11/18/21 17:28, Lai Jiangshan wrote:
>> Using VMX_REGS_DIRTY_SET and SVM_REGS_DIRTY_SET and making the code
>> similar is my intent for patch12,13.  If it causes confusing, I would
>> like to make a second thought.  SVM_REGS_DIRTY_SET does be special
>> in svm where VCPU_EXREG_CR3 is in it by definition, but it is not
>> added into SVM_REGS_DIRTY_SET in the patch just for optimization to allow
>> the compiler optimizes the line of code out.
> 
> I think this is where we disagree.  In my opinion it is enough to
> document that CR3 _can_ be out of date, but it doesn't have to be marked
> dirty because its dirty bit is effectively KVM_REQ_LOAD_MMU_PGD.
> 
> For VMX, it is important to clear VCPU_EXREG_CR3 because the combination
> "avail=0, dirty=1" is nonsensical:
> 
>      av d
>      0  0    in VMCS
>      0  1    *INVALID*
>      1  0    in vcpu->arch
>      1  1    in vcpu->arch, needs store
> 
> But on SVM, VCPU_EXREG_CR3 is always available.
> 
> Thinking more about it, it makes more sense for VMX to reset _all_
> bits of dirty to 0, just like it was before your change, but doing
> so even earlier in vmx_vcpu_run.
> 
> I appreciate that VMX_REGS_LAZY_UPDATE_SET is useful for documentation,
> but it's also important that the values in avail/dirty make sense as
> a pair.
> 
> So here is what I would do:

Reviewed-by: Lai Jiangshan <laijs@linux.alibaba.com>


> 
> diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
> index 6e6d0d01f18d..ac3d3bd662f4 100644
> --- a/arch/x86/kvm/kvm_cache_regs.h
> +++ b/arch/x86/kvm/kvm_cache_regs.h
> @@ -43,6 +43,13 @@ BUILD_KVM_GPR_ACCESSORS(r14, R14)
>   BUILD_KVM_GPR_ACCESSORS(r15, R15)
>   #endif
> 
> +/*
> + * avail  dirty
> + * 0      0      register in VMCS/VMCB
> + * 0      1      *INVALID*
> + * 1      0      register in vcpu->arch
> + * 1      1      register in vcpu->arch, needs to be stored back
> + */
>   static inline bool kvm_register_is_available(struct kvm_vcpu *vcpu,
>                            enum kvm_reg reg)
>   {
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 6fce61fc98e3..72ae67e214b5 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6635,6 +6635,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
>           vmcs_writel(GUEST_RSP, vcpu->arch.regs[VCPU_REGS_RSP]);
>       if (kvm_register_is_dirty(vcpu, VCPU_REGS_RIP))
>           vmcs_writel(GUEST_RIP, vcpu->arch.regs[VCPU_REGS_RIP]);
> +    vcpu->arch.regs_dirty = 0;
> 
>       cr3 = __get_current_cr3_fast();
>       if (unlikely(cr3 != vmx->loaded_vmcs->host_state.cr3)) {
> @@ -6729,7 +6730,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
>       loadsegment(es, __USER_DS);
>   #endif
> 
> -    vmx_register_cache_reset(vcpu);
> +    vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
> 
>       pt_guest_exit(vmx);
> 
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 4df2ac24ffc1..f978699480e3 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -473,19 +473,21 @@ BUILD_CONTROLS_SHADOW(pin, PIN_BASED_VM_EXEC_CONTROL)
>   BUILD_CONTROLS_SHADOW(exec, CPU_BASED_VM_EXEC_CONTROL)
>   BUILD_CONTROLS_SHADOW(secondary_exec, SECONDARY_VM_EXEC_CONTROL)
> 
> -static inline void vmx_register_cache_reset(struct kvm_vcpu *vcpu)
> -{
> -    vcpu->arch.regs_avail = ~((1 << VCPU_REGS_RIP) | (1 << VCPU_REGS_RSP)
> -                  | (1 << VCPU_EXREG_RFLAGS)
> -                  | (1 << VCPU_EXREG_PDPTR)
> -                  | (1 << VCPU_EXREG_SEGMENTS)
> -                  | (1 << VCPU_EXREG_CR0)
> -                  | (1 << VCPU_EXREG_CR3)
> -                  | (1 << VCPU_EXREG_CR4)
> -                  | (1 << VCPU_EXREG_EXIT_INFO_1)
> -                  | (1 << VCPU_EXREG_EXIT_INFO_2));
> -    vcpu->arch.regs_dirty = 0;
> -}
> +/*
> + * VMX_REGS_LAZY_LOAD_SET - The set of registers that will be updated in the
> + * cache on demand.  Other registers not listed here are synced to
> + * the cache immediately after VM-Exit.
> + */
> +#define VMX_REGS_LAZY_LOAD_SET    ((1 << VCPU_REGS_RIP) |         \
> +                (1 << VCPU_REGS_RSP) |          \
> +                (1 << VCPU_EXREG_RFLAGS) |      \
> +                (1 << VCPU_EXREG_PDPTR) |       \
> +                (1 << VCPU_EXREG_SEGMENTS) |    \
> +                (1 << VCPU_EXREG_CR0) |         \
> +                (1 << VCPU_EXREG_CR3) |         \
> +                (1 << VCPU_EXREG_CR4) |         \
> +                (1 << VCPU_EXREG_EXIT_INFO_1) | \
> +                (1 << VCPU_EXREG_EXIT_INFO_2))
> 
>   static inline struct kvm_vmx *to_kvm_vmx(struct kvm *kvm)
>   {
> 
> and likewise for SVM:
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index eb2a2609cae8..4b22aa7d55d0 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3944,6 +3944,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>           vcpu->arch.regs[VCPU_REGS_RSP] = svm->vmcb->save.rsp;
>           vcpu->arch.regs[VCPU_REGS_RIP] = svm->vmcb->save.rip;
>       }
> +    vcpu->arch.regs_dirty = 0;
> 
>       if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
>           kvm_before_interrupt(vcpu);
> @@ -3978,7 +3978,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>           vcpu->arch.apf.host_apf_flags =
>               kvm_read_and_reset_apf_flags();
> 
> -    kvm_register_clear_available(vcpu, VCPU_EXREG_PDPTR);
> +    vcpu->arch.regs_avail &= ~SVM_REGS_LAZY_LOAD_SET;
> 
>       /*
>        * We need to handle MC intercepts here before the vcpu has a chance to
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 32769d227860..b3c3c3098216 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -321,6 +321,16 @@ static inline bool vmcb_is_dirty(struct vmcb *vmcb, int bit)
>           return !test_bit(bit, (unsigned long *)&vmcb->control.clean);
>   }
> 
> +/*
> + * Only the PDPTRs are loaded on demand into the shadow MMU.  All other
> + * fields are synchronized in handle_exit, because accessing the VMCB is cheap.
> + *
> + * CR3 might be out of date in the VMCB but it is not marked dirty; instead,
> + * KVM_REQ_LOAD_MMU_PGD is always requested when the cached vcpu->arch.cr3
> + * is changed.  svm_load_mmu_pgd() then syncs the new CR3 value into the VMCB.
> + */
> +#define SVM_REGS_LAZY_LOAD_SET    (1 << VCPU_EXREG_PDPTR)
> +
>   static inline struct vcpu_svm *to_svm(struct kvm_vcpu *vcpu)
>   {
>       return container_of(vcpu, struct vcpu_svm, vcpu);
> 
