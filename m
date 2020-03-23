Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9849018F4E3
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 13:45:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728247AbgCWMpF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 08:45:05 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:30182 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728221AbgCWMpF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Mar 2020 08:45:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584967500;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/Yo5gdEQUbMr75i4NYVPFAZ+sdrm2XAPHFiHVijyxDc=;
        b=aEiyV+KB4NTWTs0NJTIHiyGqmFkLDtLx0nN78GHwoUu630XY15KY4NvywLp8NX7kO+SzoS
        +IerWMFpKMaDnBU6qWAGB0CL4Ugl945u8CZrOr9nyC92kOcCHT8fiZXhSkt0hTHZvd2mo/
        e3bvBFBPou/brszXSndye7Sk6XD3XMQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-419-iFAxVqUFMbCddYhCicbUAg-1; Mon, 23 Mar 2020 08:44:53 -0400
X-MC-Unique: iFAxVqUFMbCddYhCicbUAg-1
Received: by mail-wr1-f72.google.com with SMTP id d17so7268869wrs.7
        for <kvm@vger.kernel.org>; Mon, 23 Mar 2020 05:44:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=/Yo5gdEQUbMr75i4NYVPFAZ+sdrm2XAPHFiHVijyxDc=;
        b=BfhQoO7Ht8iqTCkd+4oHu0WigbtjGXOI0RX+TixxS4k63KlONBAlYJotjeKLDwrfto
         biz+NFz7RzKq9I4gctHYDJP+APQ1c0wvtmwBOamo3Oa+pZzjXJ/3QK/1XsLMwTvHrjiY
         lUfJ8AMmPr6mXiL+XtsdhKG9ZGIRkRK5rFbP0qucY8xNg4bSly4R7MM5T7UOy65OlXYS
         UcLC4xr/7dHWHA09FH84kwUFnhtQHwkWwe0O5yoHI8zeHOwy+VpmD56zAUGjPkozjCpU
         wB2JnBkL9xZ4sja2ZOBARFqNGDOVWAv/mMHNuk0MgexlNovvgg0CMBAveSoMwBz659oH
         fttw==
X-Gm-Message-State: ANhLgQ14fSrRtEu2VBIaHgqYFhgKrdd7rDPy4VSGCQ1efdYMFI1dF1sP
        btnUh+1JeMREA4D3mOEkAe0TzkN004CEXAX+Qv+VkMHI/eTLLzVkR5J/XNkvs7FnnjljapXea19
        B+yV3RNgKWaVa
X-Received: by 2002:a05:600c:295e:: with SMTP id n30mr3103430wmd.106.1584967490871;
        Mon, 23 Mar 2020 05:44:50 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vulhv5kmumTjfkR9z9myR25Oduv5pLvqzuh6eMfmCIkuI6s5PaNDswIyOXLkZ28pCRnkokvvQ==
X-Received: by 2002:a05:600c:295e:: with SMTP id n30mr3103333wmd.106.1584967489487;
        Mon, 23 Mar 2020 05:44:49 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id c7sm24211101wro.75.2020.03.23.05.44.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 05:44:48 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 6/9] KVM: x86: Copy kvm_x86_ops by value to eliminate layer of indirection
In-Reply-To: <20200321202603.19355-7-sean.j.christopherson@intel.com>
References: <20200321202603.19355-1-sean.j.christopherson@intel.com> <20200321202603.19355-7-sean.j.christopherson@intel.com>
Date:   Mon, 23 Mar 2020 13:44:46 +0100
Message-ID: <87d0939r5t.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Replace the kvm_x86_ops pointer in common x86 with an instance of the
> struct to save one memory instance when invoking function.  Copy the
> struct by value to set the ops during kvm_init().
>
> Arbitrarily use kvm_x86_ops.hardware_enable to track whether or not the
> ops have been initialized, i.e. a vendor KVM module has been loaded.
>
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  18 +-
>  arch/x86/kvm/cpuid.c            |   4 +-
>  arch/x86/kvm/hyperv.c           |   8 +-
>  arch/x86/kvm/kvm_cache_regs.h   |  10 +-
>  arch/x86/kvm/lapic.c            |  30 +--
>  arch/x86/kvm/mmu.h              |   8 +-
>  arch/x86/kvm/mmu/mmu.c          |  32 +--
>  arch/x86/kvm/pmu.c              |  30 +--
>  arch/x86/kvm/pmu.h              |   2 +-
>  arch/x86/kvm/svm.c              |   2 +-
>  arch/x86/kvm/trace.h            |   4 +-
>  arch/x86/kvm/vmx/nested.c       |   2 +-
>  arch/x86/kvm/vmx/vmx.c          |   4 +-
>  arch/x86/kvm/x86.c              | 356 ++++++++++++++++----------------
>  arch/x86/kvm/x86.h              |   4 +-
>  15 files changed, 257 insertions(+), 257 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index f4c5b49299ff..54f991244fae 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1274,13 +1274,13 @@ struct kvm_arch_async_pf {
>  
>  extern u64 __read_mostly host_efer;
>  
> -extern struct kvm_x86_ops *kvm_x86_ops;
> +extern struct kvm_x86_ops kvm_x86_ops;
>  extern struct kmem_cache *x86_fpu_cache;
>  
>  #define __KVM_HAVE_ARCH_VM_ALLOC
>  static inline struct kvm *kvm_arch_alloc_vm(void)
>  {
> -	return __vmalloc(kvm_x86_ops->vm_size,
> +	return __vmalloc(kvm_x86_ops.vm_size,
>  			 GFP_KERNEL_ACCOUNT | __GFP_ZERO, PAGE_KERNEL);
>  }
>  void kvm_arch_free_vm(struct kvm *kvm);
> @@ -1288,8 +1288,8 @@ void kvm_arch_free_vm(struct kvm *kvm);
>  #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB
>  static inline int kvm_arch_flush_remote_tlb(struct kvm *kvm)
>  {
> -	if (kvm_x86_ops->tlb_remote_flush &&
> -	    !kvm_x86_ops->tlb_remote_flush(kvm))
> +	if (kvm_x86_ops.tlb_remote_flush &&
> +	    !kvm_x86_ops.tlb_remote_flush(kvm))
>  		return 0;
>  	else
>  		return -ENOTSUPP;
> @@ -1375,7 +1375,7 @@ extern u64 kvm_mce_cap_supported;
>   *
>   * EMULTYPE_SKIP - Set when emulating solely to skip an instruction, i.e. to
>   *		   decode the instruction length.  For use *only* by
> - *		   kvm_x86_ops->skip_emulated_instruction() implementations.
> + *		   kvm_x86_ops.skip_emulated_instruction() implementations.
>   *
>   * EMULTYPE_ALLOW_RETRY_PF - Set when the emulator should resume the guest to
>   *			     retry native execution under certain conditions,
> @@ -1669,14 +1669,14 @@ static inline bool kvm_irq_is_postable(struct kvm_lapic_irq *irq)
>  
>  static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
>  {
> -	if (kvm_x86_ops->vcpu_blocking)
> -		kvm_x86_ops->vcpu_blocking(vcpu);
> +	if (kvm_x86_ops.vcpu_blocking)
> +		kvm_x86_ops.vcpu_blocking(vcpu);
>  }
>  
>  static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
>  {
> -	if (kvm_x86_ops->vcpu_unblocking)
> -		kvm_x86_ops->vcpu_unblocking(vcpu);
> +	if (kvm_x86_ops.vcpu_unblocking)
> +		kvm_x86_ops.vcpu_unblocking(vcpu);
>  }
>  
>  static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 435a7da07d5f..0aefa9acae10 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -209,7 +209,7 @@ int kvm_vcpu_ioctl_set_cpuid(struct kvm_vcpu *vcpu,
>  	vcpu->arch.cpuid_nent = cpuid->nent;
>  	cpuid_fix_nx_cap(vcpu);
>  	kvm_apic_set_version(vcpu);
> -	kvm_x86_ops->cpuid_update(vcpu);
> +	kvm_x86_ops.cpuid_update(vcpu);
>  	r = kvm_update_cpuid(vcpu);
>  
>  out:
> @@ -232,7 +232,7 @@ int kvm_vcpu_ioctl_set_cpuid2(struct kvm_vcpu *vcpu,
>  		goto out;
>  	vcpu->arch.cpuid_nent = cpuid->nent;
>  	kvm_apic_set_version(vcpu);
> -	kvm_x86_ops->cpuid_update(vcpu);
> +	kvm_x86_ops.cpuid_update(vcpu);
>  	r = kvm_update_cpuid(vcpu);
>  out:
>  	return r;
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index a86fda7a1d03..bcefa9d4e57e 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1022,7 +1022,7 @@ static int kvm_hv_set_msr_pw(struct kvm_vcpu *vcpu, u32 msr, u64 data,
>  		addr = gfn_to_hva(kvm, gfn);
>  		if (kvm_is_error_hva(addr))
>  			return 1;
> -		kvm_x86_ops->patch_hypercall(vcpu, instructions);
> +		kvm_x86_ops.patch_hypercall(vcpu, instructions);
>  		((unsigned char *)instructions)[3] = 0xc3; /* ret */
>  		if (__copy_to_user((void __user *)addr, instructions, 4))
>  			return 1;
> @@ -1607,7 +1607,7 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>  	 * hypercall generates UD from non zero cpl and real mode
>  	 * per HYPER-V spec
>  	 */
> -	if (kvm_x86_ops->get_cpl(vcpu) != 0 || !is_protmode(vcpu)) {
> +	if (kvm_x86_ops.get_cpl(vcpu) != 0 || !is_protmode(vcpu)) {
>  		kvm_queue_exception(vcpu, UD_VECTOR);
>  		return 1;
>  	}
> @@ -1800,8 +1800,8 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
>  	};
>  	int i, nent = ARRAY_SIZE(cpuid_entries);
>  
> -	if (kvm_x86_ops->nested_get_evmcs_version)
> -		evmcs_ver = kvm_x86_ops->nested_get_evmcs_version(vcpu);
> +	if (kvm_x86_ops.nested_get_evmcs_version)
> +		evmcs_ver = kvm_x86_ops.nested_get_evmcs_version(vcpu);
>  
>  	/* Skip NESTED_FEATURES if eVMCS is not supported */
>  	if (!evmcs_ver)
> diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
> index 58767020de41..62558b9bdda7 100644
> --- a/arch/x86/kvm/kvm_cache_regs.h
> +++ b/arch/x86/kvm/kvm_cache_regs.h
> @@ -68,7 +68,7 @@ static inline unsigned long kvm_register_read(struct kvm_vcpu *vcpu, int reg)
>  		return 0;
>  
>  	if (!kvm_register_is_available(vcpu, reg))
> -		kvm_x86_ops->cache_reg(vcpu, reg);
> +		kvm_x86_ops.cache_reg(vcpu, reg);
>  
>  	return vcpu->arch.regs[reg];
>  }
> @@ -108,7 +108,7 @@ static inline u64 kvm_pdptr_read(struct kvm_vcpu *vcpu, int index)
>  	might_sleep();  /* on svm */
>  
>  	if (!kvm_register_is_available(vcpu, VCPU_EXREG_PDPTR))
> -		kvm_x86_ops->cache_reg(vcpu, VCPU_EXREG_PDPTR);
> +		kvm_x86_ops.cache_reg(vcpu, VCPU_EXREG_PDPTR);
>  
>  	return vcpu->arch.walk_mmu->pdptrs[index];
>  }
> @@ -117,7 +117,7 @@ static inline ulong kvm_read_cr0_bits(struct kvm_vcpu *vcpu, ulong mask)
>  {
>  	ulong tmask = mask & KVM_POSSIBLE_CR0_GUEST_BITS;
>  	if (tmask & vcpu->arch.cr0_guest_owned_bits)
> -		kvm_x86_ops->decache_cr0_guest_bits(vcpu);
> +		kvm_x86_ops.decache_cr0_guest_bits(vcpu);
>  	return vcpu->arch.cr0 & mask;
>  }
>  
> @@ -130,14 +130,14 @@ static inline ulong kvm_read_cr4_bits(struct kvm_vcpu *vcpu, ulong mask)
>  {
>  	ulong tmask = mask & KVM_POSSIBLE_CR4_GUEST_BITS;
>  	if (tmask & vcpu->arch.cr4_guest_owned_bits)
> -		kvm_x86_ops->decache_cr4_guest_bits(vcpu);
> +		kvm_x86_ops.decache_cr4_guest_bits(vcpu);
>  	return vcpu->arch.cr4 & mask;
>  }
>  
>  static inline ulong kvm_read_cr3(struct kvm_vcpu *vcpu)
>  {
>  	if (!kvm_register_is_available(vcpu, VCPU_EXREG_CR3))
> -		kvm_x86_ops->cache_reg(vcpu, VCPU_EXREG_CR3);
> +		kvm_x86_ops.cache_reg(vcpu, VCPU_EXREG_CR3);
>  	return vcpu->arch.cr3;
>  }
>  
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 41bd49ebe355..62d57c348286 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -463,7 +463,7 @@ static inline void apic_clear_irr(int vec, struct kvm_lapic *apic)
>  	if (unlikely(vcpu->arch.apicv_active)) {
>  		/* need to update RVI */
>  		kvm_lapic_clear_vector(vec, apic->regs + APIC_IRR);
> -		kvm_x86_ops->hwapic_irr_update(vcpu,
> +		kvm_x86_ops.hwapic_irr_update(vcpu,
>  				apic_find_highest_irr(apic));
>  	} else {
>  		apic->irr_pending = false;
> @@ -488,7 +488,7 @@ static inline void apic_set_isr(int vec, struct kvm_lapic *apic)
>  	 * just set SVI.
>  	 */
>  	if (unlikely(vcpu->arch.apicv_active))
> -		kvm_x86_ops->hwapic_isr_update(vcpu, vec);
> +		kvm_x86_ops.hwapic_isr_update(vcpu, vec);
>  	else {
>  		++apic->isr_count;
>  		BUG_ON(apic->isr_count > MAX_APIC_VECTOR);
> @@ -536,7 +536,7 @@ static inline void apic_clear_isr(int vec, struct kvm_lapic *apic)
>  	 * and must be left alone.
>  	 */
>  	if (unlikely(vcpu->arch.apicv_active))
> -		kvm_x86_ops->hwapic_isr_update(vcpu,
> +		kvm_x86_ops.hwapic_isr_update(vcpu,
>  					       apic_find_highest_isr(apic));
>  	else {
>  		--apic->isr_count;
> @@ -674,7 +674,7 @@ static int apic_has_interrupt_for_ppr(struct kvm_lapic *apic, u32 ppr)
>  {
>  	int highest_irr;
>  	if (apic->vcpu->arch.apicv_active)
> -		highest_irr = kvm_x86_ops->sync_pir_to_irr(apic->vcpu);
> +		highest_irr = kvm_x86_ops.sync_pir_to_irr(apic->vcpu);
>  	else
>  		highest_irr = apic_find_highest_irr(apic);
>  	if (highest_irr == -1 || (highest_irr & 0xF0) <= ppr)
> @@ -1063,7 +1063,7 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
>  						       apic->regs + APIC_TMR);
>  		}
>  
> -		if (kvm_x86_ops->deliver_posted_interrupt(vcpu, vector)) {
> +		if (kvm_x86_ops.deliver_posted_interrupt(vcpu, vector)) {
>  			kvm_lapic_set_irr(vector, apic);
>  			kvm_make_request(KVM_REQ_EVENT, vcpu);
>  			kvm_vcpu_kick(vcpu);
> @@ -1746,7 +1746,7 @@ static void cancel_hv_timer(struct kvm_lapic *apic)
>  {
>  	WARN_ON(preemptible());
>  	WARN_ON(!apic->lapic_timer.hv_timer_in_use);
> -	kvm_x86_ops->cancel_hv_timer(apic->vcpu);
> +	kvm_x86_ops.cancel_hv_timer(apic->vcpu);
>  	apic->lapic_timer.hv_timer_in_use = false;
>  }
>  
> @@ -1757,13 +1757,13 @@ static bool start_hv_timer(struct kvm_lapic *apic)
>  	bool expired;
>  
>  	WARN_ON(preemptible());
> -	if (!kvm_x86_ops->set_hv_timer)
> +	if (!kvm_x86_ops.set_hv_timer)
>  		return false;
>  
>  	if (!ktimer->tscdeadline)
>  		return false;
>  
> -	if (kvm_x86_ops->set_hv_timer(vcpu, ktimer->tscdeadline, &expired))
> +	if (kvm_x86_ops.set_hv_timer(vcpu, ktimer->tscdeadline, &expired))
>  		return false;
>  
>  	ktimer->hv_timer_in_use = true;
> @@ -2190,7 +2190,7 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
>  		kvm_apic_set_x2apic_id(apic, vcpu->vcpu_id);
>  
>  	if ((old_value ^ value) & (MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE))
> -		kvm_x86_ops->set_virtual_apic_mode(vcpu);
> +		kvm_x86_ops.set_virtual_apic_mode(vcpu);
>  
>  	apic->base_address = apic->vcpu->arch.apic_base &
>  			     MSR_IA32_APICBASE_BASE;
> @@ -2268,9 +2268,9 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
>  	vcpu->arch.pv_eoi.msr_val = 0;
>  	apic_update_ppr(apic);
>  	if (vcpu->arch.apicv_active) {
> -		kvm_x86_ops->apicv_post_state_restore(vcpu);
> -		kvm_x86_ops->hwapic_irr_update(vcpu, -1);
> -		kvm_x86_ops->hwapic_isr_update(vcpu, -1);
> +		kvm_x86_ops.apicv_post_state_restore(vcpu);
> +		kvm_x86_ops.hwapic_irr_update(vcpu, -1);
> +		kvm_x86_ops.hwapic_isr_update(vcpu, -1);
>  	}
>  
>  	vcpu->arch.apic_arb_prio = 0;
> @@ -2521,10 +2521,10 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
>  	kvm_apic_update_apicv(vcpu);
>  	apic->highest_isr_cache = -1;
>  	if (vcpu->arch.apicv_active) {
> -		kvm_x86_ops->apicv_post_state_restore(vcpu);
> -		kvm_x86_ops->hwapic_irr_update(vcpu,
> +		kvm_x86_ops.apicv_post_state_restore(vcpu);
> +		kvm_x86_ops.hwapic_irr_update(vcpu,
>  				apic_find_highest_irr(apic));
> -		kvm_x86_ops->hwapic_isr_update(vcpu,
> +		kvm_x86_ops.hwapic_isr_update(vcpu,
>  				apic_find_highest_isr(apic));
>  	}
>  	kvm_make_request(KVM_REQ_EVENT, vcpu);
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index e6bfe79e94d8..8a3b1bce722a 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -98,8 +98,8 @@ static inline unsigned long kvm_get_active_pcid(struct kvm_vcpu *vcpu)
>  static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vcpu)
>  {
>  	if (VALID_PAGE(vcpu->arch.mmu->root_hpa))
> -		kvm_x86_ops->load_mmu_pgd(vcpu, vcpu->arch.mmu->root_hpa |
> -					        kvm_get_active_pcid(vcpu));
> +		kvm_x86_ops.load_mmu_pgd(vcpu, vcpu->arch.mmu->root_hpa |
> +					       kvm_get_active_pcid(vcpu));
>  }
>  
>  int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
> @@ -170,8 +170,8 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>  				  unsigned pte_access, unsigned pte_pkey,
>  				  unsigned pfec)
>  {
> -	int cpl = kvm_x86_ops->get_cpl(vcpu);
> -	unsigned long rflags = kvm_x86_ops->get_rflags(vcpu);
> +	int cpl = kvm_x86_ops.get_cpl(vcpu);
> +	unsigned long rflags = kvm_x86_ops.get_rflags(vcpu);
>  
>  	/*
>  	 * If CPL < 3, SMAP prevention are disabled if EFLAGS.AC = 1.
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 560e85ebdf22..8071952e9cf2 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -305,7 +305,7 @@ kvm_mmu_calc_root_page_role(struct kvm_vcpu *vcpu);
>  
>  static inline bool kvm_available_flush_tlb_with_range(void)
>  {
> -	return kvm_x86_ops->tlb_remote_flush_with_range;
> +	return kvm_x86_ops.tlb_remote_flush_with_range;
>  }
>  
>  static void kvm_flush_remote_tlbs_with_range(struct kvm *kvm,
> @@ -313,8 +313,8 @@ static void kvm_flush_remote_tlbs_with_range(struct kvm *kvm,
>  {
>  	int ret = -ENOTSUPP;
>  
> -	if (range && kvm_x86_ops->tlb_remote_flush_with_range)
> -		ret = kvm_x86_ops->tlb_remote_flush_with_range(kvm, range);
> +	if (range && kvm_x86_ops.tlb_remote_flush_with_range)
> +		ret = kvm_x86_ops.tlb_remote_flush_with_range(kvm, range);
>  
>  	if (ret)
>  		kvm_flush_remote_tlbs(kvm);
> @@ -1642,7 +1642,7 @@ static bool spte_set_dirty(u64 *sptep)
>  	rmap_printk("rmap_set_dirty: spte %p %llx\n", sptep, *sptep);
>  
>  	/*
> -	 * Similar to the !kvm_x86_ops->slot_disable_log_dirty case,
> +	 * Similar to the !kvm_x86_ops.slot_disable_log_dirty case,
>  	 * do not bother adding back write access to pages marked
>  	 * SPTE_AD_WRPROT_ONLY_MASK.
>  	 */
> @@ -1731,8 +1731,8 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
>  				struct kvm_memory_slot *slot,
>  				gfn_t gfn_offset, unsigned long mask)
>  {
> -	if (kvm_x86_ops->enable_log_dirty_pt_masked)
> -		kvm_x86_ops->enable_log_dirty_pt_masked(kvm, slot, gfn_offset,
> +	if (kvm_x86_ops.enable_log_dirty_pt_masked)
> +		kvm_x86_ops.enable_log_dirty_pt_masked(kvm, slot, gfn_offset,
>  				mask);
>  	else
>  		kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
> @@ -1747,8 +1747,8 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
>   */
>  int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu)
>  {
> -	if (kvm_x86_ops->write_log_dirty)
> -		return kvm_x86_ops->write_log_dirty(vcpu);
> +	if (kvm_x86_ops.write_log_dirty)
> +		return kvm_x86_ops.write_log_dirty(vcpu);
>  
>  	return 0;
>  }
> @@ -3036,7 +3036,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>  	if (level > PT_PAGE_TABLE_LEVEL)
>  		spte |= PT_PAGE_SIZE_MASK;
>  	if (tdp_enabled)
> -		spte |= kvm_x86_ops->get_mt_mask(vcpu, gfn,
> +		spte |= kvm_x86_ops.get_mt_mask(vcpu, gfn,
>  			kvm_is_mmio_pfn(pfn));
>  
>  	if (host_writable)
> @@ -4909,7 +4909,7 @@ kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu, bool base_only)
>  	union kvm_mmu_role role = kvm_calc_mmu_role_common(vcpu, base_only);
>  
>  	role.base.ad_disabled = (shadow_accessed_mask == 0);
> -	role.base.level = kvm_x86_ops->get_tdp_level(vcpu);
> +	role.base.level = kvm_x86_ops.get_tdp_level(vcpu);
>  	role.base.direct = true;
>  	role.base.gpte_is_8_bytes = true;
>  
> @@ -4930,7 +4930,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
>  	context->sync_page = nonpaging_sync_page;
>  	context->invlpg = nonpaging_invlpg;
>  	context->update_pte = nonpaging_update_pte;
> -	context->shadow_root_level = kvm_x86_ops->get_tdp_level(vcpu);
> +	context->shadow_root_level = kvm_x86_ops.get_tdp_level(vcpu);
>  	context->direct_map = true;
>  	context->get_guest_pgd = get_cr3;
>  	context->get_pdptr = kvm_pdptr_read;
> @@ -5183,7 +5183,7 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
>  	if (r)
>  		goto out;
>  	kvm_mmu_load_pgd(vcpu);
> -	kvm_x86_ops->tlb_flush(vcpu, true);
> +	kvm_x86_ops.tlb_flush(vcpu, true);
>  out:
>  	return r;
>  }
> @@ -5488,7 +5488,7 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
>  	 * guest, with the exception of AMD Erratum 1096 which is unrecoverable.
>  	 */
>  	if (unlikely(insn && !insn_len)) {
> -		if (!kvm_x86_ops->need_emulation_on_page_fault(vcpu))
> +		if (!kvm_x86_ops.need_emulation_on_page_fault(vcpu))
>  			return 1;
>  	}
>  
> @@ -5523,7 +5523,7 @@ void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva)
>  		if (VALID_PAGE(mmu->prev_roots[i].hpa))
>  			mmu->invlpg(vcpu, gva, mmu->prev_roots[i].hpa);
>  
> -	kvm_x86_ops->tlb_flush_gva(vcpu, gva);
> +	kvm_x86_ops.tlb_flush_gva(vcpu, gva);
>  	++vcpu->stat.invlpg;
>  }
>  EXPORT_SYMBOL_GPL(kvm_mmu_invlpg);
> @@ -5548,7 +5548,7 @@ void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid)
>  	}
>  
>  	if (tlb_flush)
> -		kvm_x86_ops->tlb_flush_gva(vcpu, gva);
> +		kvm_x86_ops.tlb_flush_gva(vcpu, gva);
>  
>  	++vcpu->stat.invlpg;
>  
> @@ -5672,7 +5672,7 @@ static int alloc_mmu_pages(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
>  	 * SVM's 32-bit NPT support, TDP paging doesn't use PAE paging and can
>  	 * skip allocating the PDP table.
>  	 */
> -	if (tdp_enabled && kvm_x86_ops->get_tdp_level(vcpu) > PT32E_ROOT_LEVEL)
> +	if (tdp_enabled && kvm_x86_ops.get_tdp_level(vcpu) > PT32E_ROOT_LEVEL)
>  		return 0;
>  
>  	page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_DMA32);
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index d1f8ca57d354..a5078841bdac 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -211,7 +211,7 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
>  			  ARCH_PERFMON_EVENTSEL_CMASK |
>  			  HSW_IN_TX |
>  			  HSW_IN_TX_CHECKPOINTED))) {
> -		config = kvm_x86_ops->pmu_ops->find_arch_event(pmc_to_pmu(pmc),
> +		config = kvm_x86_ops.pmu_ops->find_arch_event(pmc_to_pmu(pmc),
>  						      event_select,
>  						      unit_mask);
>  		if (config != PERF_COUNT_HW_MAX)
> @@ -265,7 +265,7 @@ void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int idx)
>  
>  	pmc->current_config = (u64)ctrl;
>  	pmc_reprogram_counter(pmc, PERF_TYPE_HARDWARE,
> -			      kvm_x86_ops->pmu_ops->find_fixed_event(idx),
> +			      kvm_x86_ops.pmu_ops->find_fixed_event(idx),
>  			      !(en_field & 0x2), /* exclude user */
>  			      !(en_field & 0x1), /* exclude kernel */
>  			      pmi, false, false);
> @@ -274,7 +274,7 @@ EXPORT_SYMBOL_GPL(reprogram_fixed_counter);
>  
>  void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx)
>  {
> -	struct kvm_pmc *pmc = kvm_x86_ops->pmu_ops->pmc_idx_to_pmc(pmu, pmc_idx);
> +	struct kvm_pmc *pmc = kvm_x86_ops.pmu_ops->pmc_idx_to_pmc(pmu, pmc_idx);
>  
>  	if (!pmc)
>  		return;
> @@ -296,7 +296,7 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
>  	int bit;
>  
>  	for_each_set_bit(bit, pmu->reprogram_pmi, X86_PMC_IDX_MAX) {
> -		struct kvm_pmc *pmc = kvm_x86_ops->pmu_ops->pmc_idx_to_pmc(pmu, bit);
> +		struct kvm_pmc *pmc = kvm_x86_ops.pmu_ops->pmc_idx_to_pmc(pmu, bit);
>  
>  		if (unlikely(!pmc || !pmc->perf_event)) {
>  			clear_bit(bit, pmu->reprogram_pmi);
> @@ -318,7 +318,7 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
>  /* check if idx is a valid index to access PMU */
>  int kvm_pmu_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
>  {
> -	return kvm_x86_ops->pmu_ops->is_valid_rdpmc_ecx(vcpu, idx);
> +	return kvm_x86_ops.pmu_ops->is_valid_rdpmc_ecx(vcpu, idx);
>  }
>  
>  bool is_vmware_backdoor_pmc(u32 pmc_idx)
> @@ -368,7 +368,7 @@ int kvm_pmu_rdpmc(struct kvm_vcpu *vcpu, unsigned idx, u64 *data)
>  	if (is_vmware_backdoor_pmc(idx))
>  		return kvm_pmu_rdpmc_vmware(vcpu, idx, data);
>  
> -	pmc = kvm_x86_ops->pmu_ops->rdpmc_ecx_to_pmc(vcpu, idx, &mask);
> +	pmc = kvm_x86_ops.pmu_ops->rdpmc_ecx_to_pmc(vcpu, idx, &mask);
>  	if (!pmc)
>  		return 1;
>  
> @@ -384,14 +384,14 @@ void kvm_pmu_deliver_pmi(struct kvm_vcpu *vcpu)
>  
>  bool kvm_pmu_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
>  {
> -	return kvm_x86_ops->pmu_ops->msr_idx_to_pmc(vcpu, msr) ||
> -		kvm_x86_ops->pmu_ops->is_valid_msr(vcpu, msr);
> +	return kvm_x86_ops.pmu_ops->msr_idx_to_pmc(vcpu, msr) ||
> +		kvm_x86_ops.pmu_ops->is_valid_msr(vcpu, msr);
>  }
>  
>  static void kvm_pmu_mark_pmc_in_use(struct kvm_vcpu *vcpu, u32 msr)
>  {
>  	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> -	struct kvm_pmc *pmc = kvm_x86_ops->pmu_ops->msr_idx_to_pmc(vcpu, msr);
> +	struct kvm_pmc *pmc = kvm_x86_ops.pmu_ops->msr_idx_to_pmc(vcpu, msr);
>  
>  	if (pmc)
>  		__set_bit(pmc->idx, pmu->pmc_in_use);
> @@ -399,13 +399,13 @@ static void kvm_pmu_mark_pmc_in_use(struct kvm_vcpu *vcpu, u32 msr)
>  
>  int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
>  {
> -	return kvm_x86_ops->pmu_ops->get_msr(vcpu, msr, data);
> +	return kvm_x86_ops.pmu_ops->get_msr(vcpu, msr, data);
>  }
>  
>  int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  {
>  	kvm_pmu_mark_pmc_in_use(vcpu, msr_info->index);
> -	return kvm_x86_ops->pmu_ops->set_msr(vcpu, msr_info);
> +	return kvm_x86_ops.pmu_ops->set_msr(vcpu, msr_info);
>  }
>  
>  /* refresh PMU settings. This function generally is called when underlying
> @@ -414,7 +414,7 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   */
>  void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
>  {
> -	kvm_x86_ops->pmu_ops->refresh(vcpu);
> +	kvm_x86_ops.pmu_ops->refresh(vcpu);
>  }
>  
>  void kvm_pmu_reset(struct kvm_vcpu *vcpu)
> @@ -422,7 +422,7 @@ void kvm_pmu_reset(struct kvm_vcpu *vcpu)
>  	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>  
>  	irq_work_sync(&pmu->irq_work);
> -	kvm_x86_ops->pmu_ops->reset(vcpu);
> +	kvm_x86_ops.pmu_ops->reset(vcpu);
>  }
>  
>  void kvm_pmu_init(struct kvm_vcpu *vcpu)
> @@ -430,7 +430,7 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
>  	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>  
>  	memset(pmu, 0, sizeof(*pmu));
> -	kvm_x86_ops->pmu_ops->init(vcpu);
> +	kvm_x86_ops.pmu_ops->init(vcpu);
>  	init_irq_work(&pmu->irq_work, kvm_pmi_trigger_fn);
>  	pmu->event_count = 0;
>  	pmu->need_cleanup = false;
> @@ -462,7 +462,7 @@ void kvm_pmu_cleanup(struct kvm_vcpu *vcpu)
>  		      pmu->pmc_in_use, X86_PMC_IDX_MAX);
>  
>  	for_each_set_bit(i, bitmask, X86_PMC_IDX_MAX) {
> -		pmc = kvm_x86_ops->pmu_ops->pmc_idx_to_pmc(pmu, i);
> +		pmc = kvm_x86_ops.pmu_ops->pmc_idx_to_pmc(pmu, i);
>  
>  		if (pmc && pmc->perf_event && !pmc_speculative_in_use(pmc))
>  			pmc_stop_counter(pmc);
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index d7da2b9e0755..a6c78a797cb1 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -88,7 +88,7 @@ static inline bool pmc_is_fixed(struct kvm_pmc *pmc)
>  
>  static inline bool pmc_is_enabled(struct kvm_pmc *pmc)
>  {
> -	return kvm_x86_ops->pmu_ops->pmc_is_enabled(pmc);
> +	return kvm_x86_ops.pmu_ops->pmc_is_enabled(pmc);
>  }
>  
>  static inline bool kvm_valid_perf_global_ctrl(struct kvm_pmu *pmu,
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 33e67c3389c2..b61bb306602b 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -7326,7 +7326,7 @@ static bool svm_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
>  	 * TODO: Last condition latch INIT signals on vCPU when
>  	 * vCPU is in guest-mode and vmcb12 defines intercept on INIT.
>  	 * To properly emulate the INIT intercept, SVM should implement
> -	 * kvm_x86_ops->check_nested_events() and call nested_svm_vmexit()
> +	 * kvm_x86_ops.check_nested_events() and call nested_svm_vmexit()
>  	 * there if an INIT signal is pending.
>  	 */
>  	return !gif_set(svm) ||
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index 6c4d9b4caf07..71b697916214 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -240,7 +240,7 @@ TRACE_EVENT(kvm_exit,
>  		__entry->guest_rip	= kvm_rip_read(vcpu);
>  		__entry->isa            = isa;
>  		__entry->vcpu_id        = vcpu->vcpu_id;
> -		kvm_x86_ops->get_exit_info(vcpu, &__entry->info1,
> +		kvm_x86_ops.get_exit_info(vcpu, &__entry->info1,
>  					   &__entry->info2);
>  	),
>  
> @@ -744,7 +744,7 @@ TRACE_EVENT(kvm_emulate_insn,
>  		),
>  
>  	TP_fast_assign(
> -		__entry->csbase = kvm_x86_ops->get_segment_base(vcpu, VCPU_SREG_CS);
> +		__entry->csbase = kvm_x86_ops.get_segment_base(vcpu, VCPU_SREG_CS);
>  		__entry->len = vcpu->arch.emulate_ctxt->fetch.ptr
>  			       - vcpu->arch.emulate_ctxt->fetch.data;
>  		__entry->rip = vcpu->arch.emulate_ctxt->_eip - __entry->len;
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 87fea22c3799..de232306561a 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4535,7 +4535,7 @@ void nested_vmx_pmu_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
>  		return;
>  
>  	vmx = to_vmx(vcpu);
> -	if (kvm_x86_ops->pmu_ops->is_valid_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL)) {
> +	if (kvm_x86_ops.pmu_ops->is_valid_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL)) {
>  		vmx->nested.msrs.entry_ctls_high |=
>  				VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
>  		vmx->nested.msrs.exit_ctls_high |=
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index cfa9093bdc06..4bbe0d165a0c 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3007,7 +3007,7 @@ void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long cr3)
>  		eptp = construct_eptp(vcpu, cr3);
>  		vmcs_write64(EPT_POINTER, eptp);
>  
> -		if (kvm_x86_ops->tlb_remote_flush) {
> +		if (kvm_x86_ops.tlb_remote_flush) {
>  			spin_lock(&to_kvm_vmx(kvm)->ept_pointer_lock);
>  			to_vmx(vcpu)->ept_pointer = eptp;
>  			to_kvm_vmx(kvm)->ept_pointers_match
> @@ -7485,7 +7485,7 @@ static void pi_post_block(struct kvm_vcpu *vcpu)
>  
>  static void vmx_post_block(struct kvm_vcpu *vcpu)
>  {
> -	if (kvm_x86_ops->set_hv_timer)
> +	if (kvm_x86_ops.set_hv_timer)
>  		kvm_lapic_switch_to_hv_timer(vcpu);
>  
>  	pi_post_block(vcpu);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index eb1976214ada..1fc862927c9b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -110,7 +110,7 @@ static void __kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
>  static void store_regs(struct kvm_vcpu *vcpu);
>  static int sync_regs(struct kvm_vcpu *vcpu);
>  
> -struct kvm_x86_ops *kvm_x86_ops __read_mostly;
> +struct kvm_x86_ops kvm_x86_ops __read_mostly;
>  EXPORT_SYMBOL_GPL(kvm_x86_ops);
>  
>  static bool __read_mostly ignore_msrs = 0;
> @@ -646,7 +646,7 @@ EXPORT_SYMBOL_GPL(kvm_requeue_exception_e);
>   */
>  bool kvm_require_cpl(struct kvm_vcpu *vcpu, int required_cpl)
>  {
> -	if (kvm_x86_ops->get_cpl(vcpu) <= required_cpl)
> +	if (kvm_x86_ops.get_cpl(vcpu) <= required_cpl)
>  		return true;
>  	kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
>  	return false;
> @@ -787,7 +787,7 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
>  
>  			if (!is_pae(vcpu))
>  				return 1;
> -			kvm_x86_ops->get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
> +			kvm_x86_ops.get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
>  			if (cs_l)
>  				return 1;
>  		} else
> @@ -800,7 +800,7 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
>  	if (!(cr0 & X86_CR0_PG) && kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE))
>  		return 1;
>  
> -	kvm_x86_ops->set_cr0(vcpu, cr0);
> +	kvm_x86_ops.set_cr0(vcpu, cr0);
>  
>  	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
>  		kvm_clear_async_pf_completion_queue(vcpu);
> @@ -896,7 +896,7 @@ static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
>  
>  int kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
>  {
> -	if (kvm_x86_ops->get_cpl(vcpu) != 0 ||
> +	if (kvm_x86_ops.get_cpl(vcpu) != 0 ||
>  	    __kvm_set_xcr(vcpu, index, xcr)) {
>  		kvm_inject_gp(vcpu, 0);
>  		return 1;
> @@ -977,7 +977,7 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>  			return 1;
>  	}
>  
> -	if (kvm_x86_ops->set_cr4(vcpu, cr4))
> +	if (kvm_x86_ops.set_cr4(vcpu, cr4))
>  		return 1;
>  
>  	if (((cr4 ^ old_cr4) & pdptr_bits) ||
> @@ -1061,7 +1061,7 @@ static void kvm_update_dr0123(struct kvm_vcpu *vcpu)
>  static void kvm_update_dr6(struct kvm_vcpu *vcpu)
>  {
>  	if (!(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP))
> -		kvm_x86_ops->set_dr6(vcpu, vcpu->arch.dr6);
> +		kvm_x86_ops.set_dr6(vcpu, vcpu->arch.dr6);
>  }
>  
>  static void kvm_update_dr7(struct kvm_vcpu *vcpu)
> @@ -1072,7 +1072,7 @@ static void kvm_update_dr7(struct kvm_vcpu *vcpu)
>  		dr7 = vcpu->arch.guest_debug_dr7;
>  	else
>  		dr7 = vcpu->arch.dr7;
> -	kvm_x86_ops->set_dr7(vcpu, dr7);
> +	kvm_x86_ops.set_dr7(vcpu, dr7);
>  	vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_BP_ENABLED;
>  	if (dr7 & DR7_BP_EN_MASK)
>  		vcpu->arch.switch_db_regs |= KVM_DEBUGREG_BP_ENABLED;
> @@ -1142,7 +1142,7 @@ int kvm_get_dr(struct kvm_vcpu *vcpu, int dr, unsigned long *val)
>  		if (vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP)
>  			*val = vcpu->arch.dr6;
>  		else
> -			*val = kvm_x86_ops->get_dr6(vcpu);
> +			*val = kvm_x86_ops.get_dr6(vcpu);
>  		break;
>  	case 5:
>  		/* fall through */
> @@ -1377,7 +1377,7 @@ static int kvm_get_msr_feature(struct kvm_msr_entry *msr)
>  		rdmsrl_safe(msr->index, &msr->data);
>  		break;
>  	default:
> -		if (kvm_x86_ops->get_msr_feature(msr))
> +		if (kvm_x86_ops.get_msr_feature(msr))
>  			return 1;
>  	}
>  	return 0;
> @@ -1445,7 +1445,7 @@ static int set_efer(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	efer &= ~EFER_LMA;
>  	efer |= vcpu->arch.efer & EFER_LMA;
>  
> -	kvm_x86_ops->set_efer(vcpu, efer);
> +	kvm_x86_ops.set_efer(vcpu, efer);
>  
>  	/* Update reserved bits */
>  	if ((efer ^ old_efer) & EFER_NX)
> @@ -1501,7 +1501,7 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
>  	msr.index = index;
>  	msr.host_initiated = host_initiated;
>  
> -	return kvm_x86_ops->set_msr(vcpu, &msr);
> +	return kvm_x86_ops.set_msr(vcpu, &msr);
>  }
>  
>  /*
> @@ -1519,7 +1519,7 @@ int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
>  	msr.index = index;
>  	msr.host_initiated = host_initiated;
>  
> -	ret = kvm_x86_ops->get_msr(vcpu, &msr);
> +	ret = kvm_x86_ops.get_msr(vcpu, &msr);
>  	if (!ret)
>  		*data = msr.data;
>  	return ret;
> @@ -1900,7 +1900,7 @@ static void kvm_track_tsc_matching(struct kvm_vcpu *vcpu)
>  
>  static void update_ia32_tsc_adjust_msr(struct kvm_vcpu *vcpu, s64 offset)
>  {
> -	u64 curr_offset = kvm_x86_ops->read_l1_tsc_offset(vcpu);
> +	u64 curr_offset = kvm_x86_ops.read_l1_tsc_offset(vcpu);
>  	vcpu->arch.ia32_tsc_adjust_msr += offset - curr_offset;
>  }
>  
> @@ -1942,7 +1942,7 @@ static u64 kvm_compute_tsc_offset(struct kvm_vcpu *vcpu, u64 target_tsc)
>  
>  u64 kvm_read_l1_tsc(struct kvm_vcpu *vcpu, u64 host_tsc)
>  {
> -	u64 tsc_offset = kvm_x86_ops->read_l1_tsc_offset(vcpu);
> +	u64 tsc_offset = kvm_x86_ops.read_l1_tsc_offset(vcpu);
>  
>  	return tsc_offset + kvm_scale_tsc(vcpu, host_tsc);
>  }
> @@ -1950,7 +1950,7 @@ EXPORT_SYMBOL_GPL(kvm_read_l1_tsc);
>  
>  static void kvm_vcpu_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
>  {
> -	vcpu->arch.tsc_offset = kvm_x86_ops->write_l1_tsc_offset(vcpu, offset);
> +	vcpu->arch.tsc_offset = kvm_x86_ops.write_l1_tsc_offset(vcpu, offset);
>  }
>  
>  static inline bool kvm_check_tsc_unstable(void)
> @@ -2074,7 +2074,7 @@ EXPORT_SYMBOL_GPL(kvm_write_tsc);
>  static inline void adjust_tsc_offset_guest(struct kvm_vcpu *vcpu,
>  					   s64 adjustment)
>  {
> -	u64 tsc_offset = kvm_x86_ops->read_l1_tsc_offset(vcpu);
> +	u64 tsc_offset = kvm_x86_ops.read_l1_tsc_offset(vcpu);
>  	kvm_vcpu_write_tsc_offset(vcpu, tsc_offset + adjustment);
>  }
>  
> @@ -2672,7 +2672,7 @@ static void kvmclock_reset(struct kvm_vcpu *vcpu)
>  static void kvm_vcpu_flush_tlb(struct kvm_vcpu *vcpu, bool invalidate_gpa)
>  {
>  	++vcpu->stat.tlb_flush;
> -	kvm_x86_ops->tlb_flush(vcpu, invalidate_gpa);
> +	kvm_x86_ops.tlb_flush(vcpu, invalidate_gpa);
>  }
>  
>  static void record_steal_time(struct kvm_vcpu *vcpu)
> @@ -3389,10 +3389,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  		 * fringe case that is not enabled except via specific settings
>  		 * of the module parameters.
>  		 */
> -		r = kvm_x86_ops->has_emulated_msr(MSR_IA32_SMBASE);
> +		r = kvm_x86_ops.has_emulated_msr(MSR_IA32_SMBASE);
>  		break;
>  	case KVM_CAP_VAPIC:
> -		r = !kvm_x86_ops->cpu_has_accelerated_tpr();
> +		r = !kvm_x86_ops.cpu_has_accelerated_tpr();
>  		break;
>  	case KVM_CAP_NR_VCPUS:
>  		r = KVM_SOFT_MAX_VCPUS;
> @@ -3419,14 +3419,14 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  		r = KVM_X2APIC_API_VALID_FLAGS;
>  		break;
>  	case KVM_CAP_NESTED_STATE:
> -		r = kvm_x86_ops->get_nested_state ?
> -			kvm_x86_ops->get_nested_state(NULL, NULL, 0) : 0;
> +		r = kvm_x86_ops.get_nested_state ?
> +			kvm_x86_ops.get_nested_state(NULL, NULL, 0) : 0;
>  		break;
>  	case KVM_CAP_HYPERV_DIRECT_TLBFLUSH:
> -		r = kvm_x86_ops->enable_direct_tlbflush != NULL;
> +		r = kvm_x86_ops.enable_direct_tlbflush != NULL;
>  		break;
>  	case KVM_CAP_HYPERV_ENLIGHTENED_VMCS:
> -		r = kvm_x86_ops->nested_enable_evmcs != NULL;
> +		r = kvm_x86_ops.nested_enable_evmcs != NULL;
>  		break;
>  	default:
>  		break;
> @@ -3542,14 +3542,14 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  {
>  	/* Address WBINVD may be executed by guest */
>  	if (need_emulate_wbinvd(vcpu)) {
> -		if (kvm_x86_ops->has_wbinvd_exit())
> +		if (kvm_x86_ops.has_wbinvd_exit())
>  			cpumask_set_cpu(cpu, vcpu->arch.wbinvd_dirty_mask);
>  		else if (vcpu->cpu != -1 && vcpu->cpu != cpu)
>  			smp_call_function_single(vcpu->cpu,
>  					wbinvd_ipi, NULL, 1);
>  	}
>  
> -	kvm_x86_ops->vcpu_load(vcpu, cpu);
> +	kvm_x86_ops.vcpu_load(vcpu, cpu);
>  
>  	/* Apply any externally detected TSC adjustments (due to suspend) */
>  	if (unlikely(vcpu->arch.tsc_offset_adjustment)) {
> @@ -3616,7 +3616,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  	int idx;
>  
>  	if (vcpu->preempted)
> -		vcpu->arch.preempted_in_kernel = !kvm_x86_ops->get_cpl(vcpu);
> +		vcpu->arch.preempted_in_kernel = !kvm_x86_ops.get_cpl(vcpu);
>  
>  	/*
>  	 * Disable page faults because we're in atomic context here.
> @@ -3635,7 +3635,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  	kvm_steal_time_set_preempted(vcpu);
>  	srcu_read_unlock(&vcpu->kvm->srcu, idx);
>  	pagefault_enable();
> -	kvm_x86_ops->vcpu_put(vcpu);
> +	kvm_x86_ops.vcpu_put(vcpu);
>  	vcpu->arch.last_host_tsc = rdtsc();
>  	/*
>  	 * If userspace has set any breakpoints or watchpoints, dr6 is restored
> @@ -3649,7 +3649,7 @@ static int kvm_vcpu_ioctl_get_lapic(struct kvm_vcpu *vcpu,
>  				    struct kvm_lapic_state *s)
>  {
>  	if (vcpu->arch.apicv_active)
> -		kvm_x86_ops->sync_pir_to_irr(vcpu);
> +		kvm_x86_ops.sync_pir_to_irr(vcpu);
>  
>  	return kvm_apic_get_state(vcpu, s);
>  }
> @@ -3757,7 +3757,7 @@ static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_vcpu *vcpu,
>  	for (bank = 0; bank < bank_num; bank++)
>  		vcpu->arch.mce_banks[bank*4] = ~(u64)0;
>  
> -	kvm_x86_ops->setup_mce(vcpu);
> +	kvm_x86_ops.setup_mce(vcpu);
>  out:
>  	return r;
>  }
> @@ -3861,11 +3861,11 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
>  		vcpu->arch.interrupt.injected && !vcpu->arch.interrupt.soft;
>  	events->interrupt.nr = vcpu->arch.interrupt.nr;
>  	events->interrupt.soft = 0;
> -	events->interrupt.shadow = kvm_x86_ops->get_interrupt_shadow(vcpu);
> +	events->interrupt.shadow = kvm_x86_ops.get_interrupt_shadow(vcpu);
>  
>  	events->nmi.injected = vcpu->arch.nmi_injected;
>  	events->nmi.pending = vcpu->arch.nmi_pending != 0;
> -	events->nmi.masked = kvm_x86_ops->get_nmi_mask(vcpu);
> +	events->nmi.masked = kvm_x86_ops.get_nmi_mask(vcpu);
>  	events->nmi.pad = 0;
>  
>  	events->sipi_vector = 0; /* never valid when reporting to user space */
> @@ -3932,13 +3932,13 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
>  	vcpu->arch.interrupt.nr = events->interrupt.nr;
>  	vcpu->arch.interrupt.soft = events->interrupt.soft;
>  	if (events->flags & KVM_VCPUEVENT_VALID_SHADOW)
> -		kvm_x86_ops->set_interrupt_shadow(vcpu,
> +		kvm_x86_ops.set_interrupt_shadow(vcpu,
>  						  events->interrupt.shadow);
>  
>  	vcpu->arch.nmi_injected = events->nmi.injected;
>  	if (events->flags & KVM_VCPUEVENT_VALID_NMI_PENDING)
>  		vcpu->arch.nmi_pending = events->nmi.pending;
> -	kvm_x86_ops->set_nmi_mask(vcpu, events->nmi.masked);
> +	kvm_x86_ops.set_nmi_mask(vcpu, events->nmi.masked);
>  
>  	if (events->flags & KVM_VCPUEVENT_VALID_SIPI_VECTOR &&
>  	    lapic_in_kernel(vcpu))
> @@ -4212,9 +4212,9 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
>  		return kvm_hv_activate_synic(vcpu, cap->cap ==
>  					     KVM_CAP_HYPERV_SYNIC2);
>  	case KVM_CAP_HYPERV_ENLIGHTENED_VMCS:
> -		if (!kvm_x86_ops->nested_enable_evmcs)
> +		if (!kvm_x86_ops.nested_enable_evmcs)
>  			return -ENOTTY;
> -		r = kvm_x86_ops->nested_enable_evmcs(vcpu, &vmcs_version);
> +		r = kvm_x86_ops.nested_enable_evmcs(vcpu, &vmcs_version);
>  		if (!r) {
>  			user_ptr = (void __user *)(uintptr_t)cap->args[0];
>  			if (copy_to_user(user_ptr, &vmcs_version,
> @@ -4223,10 +4223,10 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
>  		}
>  		return r;
>  	case KVM_CAP_HYPERV_DIRECT_TLBFLUSH:
> -		if (!kvm_x86_ops->enable_direct_tlbflush)
> +		if (!kvm_x86_ops.enable_direct_tlbflush)
>  			return -ENOTTY;
>  
> -		return kvm_x86_ops->enable_direct_tlbflush(vcpu);
> +		return kvm_x86_ops.enable_direct_tlbflush(vcpu);
>  
>  	default:
>  		return -EINVAL;
> @@ -4529,7 +4529,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  		u32 user_data_size;
>  
>  		r = -EINVAL;
> -		if (!kvm_x86_ops->get_nested_state)
> +		if (!kvm_x86_ops.get_nested_state)
>  			break;
>  
>  		BUILD_BUG_ON(sizeof(user_data_size) != sizeof(user_kvm_nested_state->size));
> @@ -4537,7 +4537,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  		if (get_user(user_data_size, &user_kvm_nested_state->size))
>  			break;
>  
> -		r = kvm_x86_ops->get_nested_state(vcpu, user_kvm_nested_state,
> +		r = kvm_x86_ops.get_nested_state(vcpu, user_kvm_nested_state,
>  						  user_data_size);
>  		if (r < 0)
>  			break;
> @@ -4559,7 +4559,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  		int idx;
>  
>  		r = -EINVAL;
> -		if (!kvm_x86_ops->set_nested_state)
> +		if (!kvm_x86_ops.set_nested_state)
>  			break;
>  
>  		r = -EFAULT;
> @@ -4581,7 +4581,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  			break;
>  
>  		idx = srcu_read_lock(&vcpu->kvm->srcu);
> -		r = kvm_x86_ops->set_nested_state(vcpu, user_kvm_nested_state, &kvm_state);
> +		r = kvm_x86_ops.set_nested_state(vcpu, user_kvm_nested_state, &kvm_state);
>  		srcu_read_unlock(&vcpu->kvm->srcu, idx);
>  		break;
>  	}
> @@ -4625,14 +4625,14 @@ static int kvm_vm_ioctl_set_tss_addr(struct kvm *kvm, unsigned long addr)
>  
>  	if (addr > (unsigned int)(-3 * PAGE_SIZE))
>  		return -EINVAL;
> -	ret = kvm_x86_ops->set_tss_addr(kvm, addr);
> +	ret = kvm_x86_ops.set_tss_addr(kvm, addr);
>  	return ret;
>  }
>  
>  static int kvm_vm_ioctl_set_identity_map_addr(struct kvm *kvm,
>  					      u64 ident_addr)
>  {
> -	return kvm_x86_ops->set_identity_map_addr(kvm, ident_addr);
> +	return kvm_x86_ops.set_identity_map_addr(kvm, ident_addr);
>  }
>  
>  static int kvm_vm_ioctl_set_nr_mmu_pages(struct kvm *kvm,
> @@ -4789,8 +4789,8 @@ void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
>  	/*
>  	 * Flush potentially hardware-cached dirty pages to dirty_bitmap.
>  	 */
> -	if (kvm_x86_ops->flush_log_dirty)
> -		kvm_x86_ops->flush_log_dirty(kvm);
> +	if (kvm_x86_ops.flush_log_dirty)
> +		kvm_x86_ops.flush_log_dirty(kvm);
>  }
>  
>  int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_event,
> @@ -5143,8 +5143,8 @@ long kvm_arch_vm_ioctl(struct file *filp,
>  	}
>  	case KVM_MEMORY_ENCRYPT_OP: {
>  		r = -ENOTTY;
> -		if (kvm_x86_ops->mem_enc_op)
> -			r = kvm_x86_ops->mem_enc_op(kvm, argp);
> +		if (kvm_x86_ops.mem_enc_op)
> +			r = kvm_x86_ops.mem_enc_op(kvm, argp);
>  		break;
>  	}
>  	case KVM_MEMORY_ENCRYPT_REG_REGION: {
> @@ -5155,8 +5155,8 @@ long kvm_arch_vm_ioctl(struct file *filp,
>  			goto out;
>  
>  		r = -ENOTTY;
> -		if (kvm_x86_ops->mem_enc_reg_region)
> -			r = kvm_x86_ops->mem_enc_reg_region(kvm, &region);
> +		if (kvm_x86_ops.mem_enc_reg_region)
> +			r = kvm_x86_ops.mem_enc_reg_region(kvm, &region);
>  		break;
>  	}
>  	case KVM_MEMORY_ENCRYPT_UNREG_REGION: {
> @@ -5167,8 +5167,8 @@ long kvm_arch_vm_ioctl(struct file *filp,
>  			goto out;
>  
>  		r = -ENOTTY;
> -		if (kvm_x86_ops->mem_enc_unreg_region)
> -			r = kvm_x86_ops->mem_enc_unreg_region(kvm, &region);
> +		if (kvm_x86_ops.mem_enc_unreg_region)
> +			r = kvm_x86_ops.mem_enc_unreg_region(kvm, &region);
>  		break;
>  	}
>  	case KVM_HYPERV_EVENTFD: {
> @@ -5263,7 +5263,7 @@ static void kvm_init_msr_list(void)
>  	}
>  
>  	for (i = 0; i < ARRAY_SIZE(emulated_msrs_all); i++) {
> -		if (!kvm_x86_ops->has_emulated_msr(emulated_msrs_all[i]))
> +		if (!kvm_x86_ops.has_emulated_msr(emulated_msrs_all[i]))
>  			continue;
>  
>  		emulated_msrs[num_emulated_msrs++] = emulated_msrs_all[i];
> @@ -5326,13 +5326,13 @@ static int vcpu_mmio_read(struct kvm_vcpu *vcpu, gpa_t addr, int len, void *v)
>  static void kvm_set_segment(struct kvm_vcpu *vcpu,
>  			struct kvm_segment *var, int seg)
>  {
> -	kvm_x86_ops->set_segment(vcpu, var, seg);
> +	kvm_x86_ops.set_segment(vcpu, var, seg);
>  }
>  
>  void kvm_get_segment(struct kvm_vcpu *vcpu,
>  		     struct kvm_segment *var, int seg)
>  {
> -	kvm_x86_ops->get_segment(vcpu, var, seg);
> +	kvm_x86_ops.get_segment(vcpu, var, seg);
>  }
>  
>  gpa_t translate_nested_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access,
> @@ -5352,14 +5352,14 @@ gpa_t translate_nested_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access,
>  gpa_t kvm_mmu_gva_to_gpa_read(struct kvm_vcpu *vcpu, gva_t gva,
>  			      struct x86_exception *exception)
>  {
> -	u32 access = (kvm_x86_ops->get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0;
> +	u32 access = (kvm_x86_ops.get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0;
>  	return vcpu->arch.walk_mmu->gva_to_gpa(vcpu, gva, access, exception);
>  }
>  
>   gpa_t kvm_mmu_gva_to_gpa_fetch(struct kvm_vcpu *vcpu, gva_t gva,
>  				struct x86_exception *exception)
>  {
> -	u32 access = (kvm_x86_ops->get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0;
> +	u32 access = (kvm_x86_ops.get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0;
>  	access |= PFERR_FETCH_MASK;
>  	return vcpu->arch.walk_mmu->gva_to_gpa(vcpu, gva, access, exception);
>  }
> @@ -5367,7 +5367,7 @@ gpa_t kvm_mmu_gva_to_gpa_read(struct kvm_vcpu *vcpu, gva_t gva,
>  gpa_t kvm_mmu_gva_to_gpa_write(struct kvm_vcpu *vcpu, gva_t gva,
>  			       struct x86_exception *exception)
>  {
> -	u32 access = (kvm_x86_ops->get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0;
> +	u32 access = (kvm_x86_ops.get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0;
>  	access |= PFERR_WRITE_MASK;
>  	return vcpu->arch.walk_mmu->gva_to_gpa(vcpu, gva, access, exception);
>  }
> @@ -5416,7 +5416,7 @@ static int kvm_fetch_guest_virt(struct x86_emulate_ctxt *ctxt,
>  				struct x86_exception *exception)
>  {
>  	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
> -	u32 access = (kvm_x86_ops->get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0;
> +	u32 access = (kvm_x86_ops.get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0;
>  	unsigned offset;
>  	int ret;
>  
> @@ -5441,7 +5441,7 @@ int kvm_read_guest_virt(struct kvm_vcpu *vcpu,
>  			       gva_t addr, void *val, unsigned int bytes,
>  			       struct x86_exception *exception)
>  {
> -	u32 access = (kvm_x86_ops->get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0;
> +	u32 access = (kvm_x86_ops.get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0;
>  
>  	/*
>  	 * FIXME: this should call handle_emulation_failure if X86EMUL_IO_NEEDED
> @@ -5462,7 +5462,7 @@ static int emulator_read_std(struct x86_emulate_ctxt *ctxt,
>  	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
>  	u32 access = 0;
>  
> -	if (!system && kvm_x86_ops->get_cpl(vcpu) == 3)
> +	if (!system && kvm_x86_ops.get_cpl(vcpu) == 3)
>  		access |= PFERR_USER_MASK;
>  
>  	return kvm_read_guest_virt_helper(addr, val, bytes, vcpu, access, exception);
> @@ -5515,7 +5515,7 @@ static int emulator_write_std(struct x86_emulate_ctxt *ctxt, gva_t addr, void *v
>  	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
>  	u32 access = PFERR_WRITE_MASK;
>  
> -	if (!system && kvm_x86_ops->get_cpl(vcpu) == 3)
> +	if (!system && kvm_x86_ops.get_cpl(vcpu) == 3)
>  		access |= PFERR_USER_MASK;
>  
>  	return kvm_write_guest_virt_helper(addr, val, bytes, vcpu,
> @@ -5578,7 +5578,7 @@ static int vcpu_mmio_gva_to_gpa(struct kvm_vcpu *vcpu, unsigned long gva,
>  				gpa_t *gpa, struct x86_exception *exception,
>  				bool write)
>  {
> -	u32 access = ((kvm_x86_ops->get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0)
> +	u32 access = ((kvm_x86_ops.get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0)
>  		| (write ? PFERR_WRITE_MASK : 0);
>  
>  	/*
> @@ -5976,7 +5976,7 @@ static int emulator_pio_out_emulated(struct x86_emulate_ctxt *ctxt,
>  
>  static unsigned long get_segment_base(struct kvm_vcpu *vcpu, int seg)
>  {
> -	return kvm_x86_ops->get_segment_base(vcpu, seg);
> +	return kvm_x86_ops.get_segment_base(vcpu, seg);
>  }
>  
>  static void emulator_invlpg(struct x86_emulate_ctxt *ctxt, ulong address)
> @@ -5989,7 +5989,7 @@ static int kvm_emulate_wbinvd_noskip(struct kvm_vcpu *vcpu)
>  	if (!need_emulate_wbinvd(vcpu))
>  		return X86EMUL_CONTINUE;
>  
> -	if (kvm_x86_ops->has_wbinvd_exit()) {
> +	if (kvm_x86_ops.has_wbinvd_exit()) {
>  		int cpu = get_cpu();
>  
>  		cpumask_set_cpu(cpu, vcpu->arch.wbinvd_dirty_mask);
> @@ -6094,27 +6094,27 @@ static int emulator_set_cr(struct x86_emulate_ctxt *ctxt, int cr, ulong val)
>  
>  static int emulator_get_cpl(struct x86_emulate_ctxt *ctxt)
>  {
> -	return kvm_x86_ops->get_cpl(emul_to_vcpu(ctxt));
> +	return kvm_x86_ops.get_cpl(emul_to_vcpu(ctxt));
>  }
>  
>  static void emulator_get_gdt(struct x86_emulate_ctxt *ctxt, struct desc_ptr *dt)
>  {
> -	kvm_x86_ops->get_gdt(emul_to_vcpu(ctxt), dt);
> +	kvm_x86_ops.get_gdt(emul_to_vcpu(ctxt), dt);
>  }
>  
>  static void emulator_get_idt(struct x86_emulate_ctxt *ctxt, struct desc_ptr *dt)
>  {
> -	kvm_x86_ops->get_idt(emul_to_vcpu(ctxt), dt);
> +	kvm_x86_ops.get_idt(emul_to_vcpu(ctxt), dt);
>  }
>  
>  static void emulator_set_gdt(struct x86_emulate_ctxt *ctxt, struct desc_ptr *dt)
>  {
> -	kvm_x86_ops->set_gdt(emul_to_vcpu(ctxt), dt);
> +	kvm_x86_ops.set_gdt(emul_to_vcpu(ctxt), dt);
>  }
>  
>  static void emulator_set_idt(struct x86_emulate_ctxt *ctxt, struct desc_ptr *dt)
>  {
> -	kvm_x86_ops->set_idt(emul_to_vcpu(ctxt), dt);
> +	kvm_x86_ops.set_idt(emul_to_vcpu(ctxt), dt);
>  }
>  
>  static unsigned long emulator_get_cached_segment_base(
> @@ -6236,7 +6236,7 @@ static int emulator_intercept(struct x86_emulate_ctxt *ctxt,
>  			      struct x86_instruction_info *info,
>  			      enum x86_intercept_stage stage)
>  {
> -	return kvm_x86_ops->check_intercept(emul_to_vcpu(ctxt), info, stage,
> +	return kvm_x86_ops.check_intercept(emul_to_vcpu(ctxt), info, stage,
>  					    &ctxt->exception);
>  }
>  
> @@ -6274,7 +6274,7 @@ static void emulator_write_gpr(struct x86_emulate_ctxt *ctxt, unsigned reg, ulon
>  
>  static void emulator_set_nmi_mask(struct x86_emulate_ctxt *ctxt, bool masked)
>  {
> -	kvm_x86_ops->set_nmi_mask(emul_to_vcpu(ctxt), masked);
> +	kvm_x86_ops.set_nmi_mask(emul_to_vcpu(ctxt), masked);
>  }
>  
>  static unsigned emulator_get_hflags(struct x86_emulate_ctxt *ctxt)
> @@ -6290,7 +6290,7 @@ static void emulator_set_hflags(struct x86_emulate_ctxt *ctxt, unsigned emul_fla
>  static int emulator_pre_leave_smm(struct x86_emulate_ctxt *ctxt,
>  				  const char *smstate)
>  {
> -	return kvm_x86_ops->pre_leave_smm(emul_to_vcpu(ctxt), smstate);
> +	return kvm_x86_ops.pre_leave_smm(emul_to_vcpu(ctxt), smstate);
>  }
>  
>  static void emulator_post_leave_smm(struct x86_emulate_ctxt *ctxt)
> @@ -6352,7 +6352,7 @@ static const struct x86_emulate_ops emulate_ops = {
>  
>  static void toggle_interruptibility(struct kvm_vcpu *vcpu, u32 mask)
>  {
> -	u32 int_shadow = kvm_x86_ops->get_interrupt_shadow(vcpu);
> +	u32 int_shadow = kvm_x86_ops.get_interrupt_shadow(vcpu);
>  	/*
>  	 * an sti; sti; sequence only disable interrupts for the first
>  	 * instruction. So, if the last instruction, be it emulated or
> @@ -6363,7 +6363,7 @@ static void toggle_interruptibility(struct kvm_vcpu *vcpu, u32 mask)
>  	if (int_shadow & mask)
>  		mask = 0;
>  	if (unlikely(int_shadow || mask)) {
> -		kvm_x86_ops->set_interrupt_shadow(vcpu, mask);
> +		kvm_x86_ops.set_interrupt_shadow(vcpu, mask);
>  		if (!mask)
>  			kvm_make_request(KVM_REQ_EVENT, vcpu);
>  	}
> @@ -6405,7 +6405,7 @@ static void init_emulate_ctxt(struct kvm_vcpu *vcpu)
>  	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
>  	int cs_db, cs_l;
>  
> -	kvm_x86_ops->get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
> +	kvm_x86_ops.get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
>  
>  	ctxt->gpa_available = false;
>  	ctxt->eflags = kvm_get_rflags(vcpu);
> @@ -6466,7 +6466,7 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
>  
>  	kvm_queue_exception(vcpu, UD_VECTOR);
>  
> -	if (!is_guest_mode(vcpu) && kvm_x86_ops->get_cpl(vcpu) == 0) {
> +	if (!is_guest_mode(vcpu) && kvm_x86_ops.get_cpl(vcpu) == 0) {
>  		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>  		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
>  		vcpu->run->internal.ndata = 0;
> @@ -6647,10 +6647,10 @@ static int kvm_vcpu_do_singlestep(struct kvm_vcpu *vcpu)
>  
>  int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
>  {
> -	unsigned long rflags = kvm_x86_ops->get_rflags(vcpu);
> +	unsigned long rflags = kvm_x86_ops.get_rflags(vcpu);
>  	int r;
>  
> -	r = kvm_x86_ops->skip_emulated_instruction(vcpu);
> +	r = kvm_x86_ops.skip_emulated_instruction(vcpu);
>  	if (unlikely(!r))
>  		return 0;
>  
> @@ -6885,7 +6885,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  		r = 1;
>  
>  	if (writeback) {
> -		unsigned long rflags = kvm_x86_ops->get_rflags(vcpu);
> +		unsigned long rflags = kvm_x86_ops.get_rflags(vcpu);
>  		toggle_interruptibility(vcpu, ctxt->interruptibility);
>  		vcpu->arch.emulate_regs_need_sync_to_vcpu = false;
>  		if (!ctxt->have_exception ||
> @@ -6893,8 +6893,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  			kvm_rip_write(vcpu, ctxt->eip);
>  			if (r && ctxt->tf)
>  				r = kvm_vcpu_do_singlestep(vcpu);
> -			if (kvm_x86_ops->update_emulated_instruction)
> -				kvm_x86_ops->update_emulated_instruction(vcpu);
> +			if (kvm_x86_ops.update_emulated_instruction)
> +				kvm_x86_ops.update_emulated_instruction(vcpu);
>  			__kvm_set_rflags(vcpu, ctxt->eflags);
>  		}
>  
> @@ -7221,7 +7221,7 @@ static int kvm_is_user_mode(void)
>  	int user_mode = 3;
>  
>  	if (__this_cpu_read(current_vcpu))
> -		user_mode = kvm_x86_ops->get_cpl(__this_cpu_read(current_vcpu));
> +		user_mode = kvm_x86_ops.get_cpl(__this_cpu_read(current_vcpu));
>  
>  	return user_mode != 0;
>  }
> @@ -7301,7 +7301,7 @@ int kvm_arch_init(void *opaque)
>  	struct kvm_x86_init_ops *ops = opaque;
>  	int r;
>  
> -	if (kvm_x86_ops) {
> +	if (kvm_x86_ops.hardware_enable) {
>  		printk(KERN_ERR "kvm: already loaded the other module\n");
>  		r = -EEXIST;
>  		goto out;
> @@ -7404,7 +7404,7 @@ void kvm_arch_exit(void)
>  #ifdef CONFIG_X86_64
>  	pvclock_gtod_unregister_notifier(&pvclock_gtod_notifier);
>  #endif
> -	kvm_x86_ops = NULL;
> +	kvm_x86_ops.hardware_enable = NULL;
>  	kvm_mmu_module_exit();
>  	free_percpu(shared_msrs);
>  	kmem_cache_destroy(x86_fpu_cache);
> @@ -7542,7 +7542,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>  		a3 &= 0xFFFFFFFF;
>  	}
>  
> -	if (kvm_x86_ops->get_cpl(vcpu) != 0) {
> +	if (kvm_x86_ops.get_cpl(vcpu) != 0) {
>  		ret = -KVM_EPERM;
>  		goto out;
>  	}
> @@ -7588,7 +7588,7 @@ static int emulator_fix_hypercall(struct x86_emulate_ctxt *ctxt)
>  	char instruction[3];
>  	unsigned long rip = kvm_rip_read(vcpu);
>  
> -	kvm_x86_ops->patch_hypercall(vcpu, instruction);
> +	kvm_x86_ops.patch_hypercall(vcpu, instruction);
>  
>  	return emulator_write_emulated(ctxt, rip, instruction, 3,
>  		&ctxt->exception);
> @@ -7617,7 +7617,7 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu)
>  {
>  	int max_irr, tpr;
>  
> -	if (!kvm_x86_ops->update_cr8_intercept)
> +	if (!kvm_x86_ops.update_cr8_intercept)
>  		return;
>  
>  	if (!lapic_in_kernel(vcpu))
> @@ -7636,7 +7636,7 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu)
>  
>  	tpr = kvm_lapic_get_cr8(vcpu);
>  
> -	kvm_x86_ops->update_cr8_intercept(vcpu, tpr, max_irr);
> +	kvm_x86_ops.update_cr8_intercept(vcpu, tpr, max_irr);
>  }
>  
>  static int inject_pending_event(struct kvm_vcpu *vcpu)
> @@ -7646,7 +7646,7 @@ static int inject_pending_event(struct kvm_vcpu *vcpu)
>  	/* try to reinject previous events if any */
>  
>  	if (vcpu->arch.exception.injected)
> -		kvm_x86_ops->queue_exception(vcpu);
> +		kvm_x86_ops.queue_exception(vcpu);
>  	/*
>  	 * Do not inject an NMI or interrupt if there is a pending
>  	 * exception.  Exceptions and interrupts are recognized at
> @@ -7663,9 +7663,9 @@ static int inject_pending_event(struct kvm_vcpu *vcpu)
>  	 */
>  	else if (!vcpu->arch.exception.pending) {
>  		if (vcpu->arch.nmi_injected)
> -			kvm_x86_ops->set_nmi(vcpu);
> +			kvm_x86_ops.set_nmi(vcpu);
>  		else if (vcpu->arch.interrupt.injected)
> -			kvm_x86_ops->set_irq(vcpu);
> +			kvm_x86_ops.set_irq(vcpu);
>  	}
>  
>  	/*
> @@ -7674,8 +7674,8 @@ static int inject_pending_event(struct kvm_vcpu *vcpu)
>  	 * from L2 to L1 due to pending L1 events which require exit
>  	 * from L2 to L1.
>  	 */
> -	if (is_guest_mode(vcpu) && kvm_x86_ops->check_nested_events) {
> -		r = kvm_x86_ops->check_nested_events(vcpu);
> +	if (is_guest_mode(vcpu) && kvm_x86_ops.check_nested_events) {
> +		r = kvm_x86_ops.check_nested_events(vcpu);
>  		if (r != 0)
>  			return r;
>  	}
> @@ -7712,7 +7712,7 @@ static int inject_pending_event(struct kvm_vcpu *vcpu)
>  			}
>  		}
>  
> -		kvm_x86_ops->queue_exception(vcpu);
> +		kvm_x86_ops.queue_exception(vcpu);
>  	}
>  
>  	/* Don't consider new event if we re-injected an event */
> @@ -7720,14 +7720,14 @@ static int inject_pending_event(struct kvm_vcpu *vcpu)
>  		return 0;
>  
>  	if (vcpu->arch.smi_pending && !is_smm(vcpu) &&
> -	    kvm_x86_ops->smi_allowed(vcpu)) {
> +	    kvm_x86_ops.smi_allowed(vcpu)) {
>  		vcpu->arch.smi_pending = false;
>  		++vcpu->arch.smi_count;
>  		enter_smm(vcpu);
> -	} else if (vcpu->arch.nmi_pending && kvm_x86_ops->nmi_allowed(vcpu)) {
> +	} else if (vcpu->arch.nmi_pending && kvm_x86_ops.nmi_allowed(vcpu)) {
>  		--vcpu->arch.nmi_pending;
>  		vcpu->arch.nmi_injected = true;
> -		kvm_x86_ops->set_nmi(vcpu);
> +		kvm_x86_ops.set_nmi(vcpu);
>  	} else if (kvm_cpu_has_injectable_intr(vcpu)) {
>  		/*
>  		 * Because interrupts can be injected asynchronously, we are
> @@ -7736,15 +7736,15 @@ static int inject_pending_event(struct kvm_vcpu *vcpu)
>  		 * proposal and current concerns.  Perhaps we should be setting
>  		 * KVM_REQ_EVENT only on certain events and not unconditionally?
>  		 */
> -		if (is_guest_mode(vcpu) && kvm_x86_ops->check_nested_events) {
> -			r = kvm_x86_ops->check_nested_events(vcpu);
> +		if (is_guest_mode(vcpu) && kvm_x86_ops.check_nested_events) {
> +			r = kvm_x86_ops.check_nested_events(vcpu);
>  			if (r != 0)
>  				return r;
>  		}
> -		if (kvm_x86_ops->interrupt_allowed(vcpu)) {
> +		if (kvm_x86_ops.interrupt_allowed(vcpu)) {
>  			kvm_queue_interrupt(vcpu, kvm_cpu_get_interrupt(vcpu),
>  					    false);
> -			kvm_x86_ops->set_irq(vcpu);
> +			kvm_x86_ops.set_irq(vcpu);
>  		}
>  	}
>  
> @@ -7760,7 +7760,7 @@ static void process_nmi(struct kvm_vcpu *vcpu)
>  	 * If an NMI is already in progress, limit further NMIs to just one.
>  	 * Otherwise, allow two (and we'll inject the first one immediately).
>  	 */
> -	if (kvm_x86_ops->get_nmi_mask(vcpu) || vcpu->arch.nmi_injected)
> +	if (kvm_x86_ops.get_nmi_mask(vcpu) || vcpu->arch.nmi_injected)
>  		limit = 1;
>  
>  	vcpu->arch.nmi_pending += atomic_xchg(&vcpu->arch.nmi_queued, 0);
> @@ -7850,11 +7850,11 @@ static void enter_smm_save_state_32(struct kvm_vcpu *vcpu, char *buf)
>  	put_smstate(u32, buf, 0x7f7c, seg.limit);
>  	put_smstate(u32, buf, 0x7f78, enter_smm_get_segment_flags(&seg));
>  
> -	kvm_x86_ops->get_gdt(vcpu, &dt);
> +	kvm_x86_ops.get_gdt(vcpu, &dt);
>  	put_smstate(u32, buf, 0x7f74, dt.address);
>  	put_smstate(u32, buf, 0x7f70, dt.size);
>  
> -	kvm_x86_ops->get_idt(vcpu, &dt);
> +	kvm_x86_ops.get_idt(vcpu, &dt);
>  	put_smstate(u32, buf, 0x7f58, dt.address);
>  	put_smstate(u32, buf, 0x7f54, dt.size);
>  
> @@ -7904,7 +7904,7 @@ static void enter_smm_save_state_64(struct kvm_vcpu *vcpu, char *buf)
>  	put_smstate(u32, buf, 0x7e94, seg.limit);
>  	put_smstate(u64, buf, 0x7e98, seg.base);
>  
> -	kvm_x86_ops->get_idt(vcpu, &dt);
> +	kvm_x86_ops.get_idt(vcpu, &dt);
>  	put_smstate(u32, buf, 0x7e84, dt.size);
>  	put_smstate(u64, buf, 0x7e88, dt.address);
>  
> @@ -7914,7 +7914,7 @@ static void enter_smm_save_state_64(struct kvm_vcpu *vcpu, char *buf)
>  	put_smstate(u32, buf, 0x7e74, seg.limit);
>  	put_smstate(u64, buf, 0x7e78, seg.base);
>  
> -	kvm_x86_ops->get_gdt(vcpu, &dt);
> +	kvm_x86_ops.get_gdt(vcpu, &dt);
>  	put_smstate(u32, buf, 0x7e64, dt.size);
>  	put_smstate(u64, buf, 0x7e68, dt.address);
>  
> @@ -7944,28 +7944,28 @@ static void enter_smm(struct kvm_vcpu *vcpu)
>  	 * vCPU state (e.g. leave guest mode) after we've saved the state into
>  	 * the SMM state-save area.
>  	 */
> -	kvm_x86_ops->pre_enter_smm(vcpu, buf);
> +	kvm_x86_ops.pre_enter_smm(vcpu, buf);
>  
>  	vcpu->arch.hflags |= HF_SMM_MASK;
>  	kvm_vcpu_write_guest(vcpu, vcpu->arch.smbase + 0xfe00, buf, sizeof(buf));
>  
> -	if (kvm_x86_ops->get_nmi_mask(vcpu))
> +	if (kvm_x86_ops.get_nmi_mask(vcpu))
>  		vcpu->arch.hflags |= HF_SMM_INSIDE_NMI_MASK;
>  	else
> -		kvm_x86_ops->set_nmi_mask(vcpu, true);
> +		kvm_x86_ops.set_nmi_mask(vcpu, true);
>  
>  	kvm_set_rflags(vcpu, X86_EFLAGS_FIXED);
>  	kvm_rip_write(vcpu, 0x8000);
>  
>  	cr0 = vcpu->arch.cr0 & ~(X86_CR0_PE | X86_CR0_EM | X86_CR0_TS | X86_CR0_PG);
> -	kvm_x86_ops->set_cr0(vcpu, cr0);
> +	kvm_x86_ops.set_cr0(vcpu, cr0);
>  	vcpu->arch.cr0 = cr0;
>  
> -	kvm_x86_ops->set_cr4(vcpu, 0);
> +	kvm_x86_ops.set_cr4(vcpu, 0);
>  
>  	/* Undocumented: IDT limit is set to zero on entry to SMM.  */
>  	dt.address = dt.size = 0;
> -	kvm_x86_ops->set_idt(vcpu, &dt);
> +	kvm_x86_ops.set_idt(vcpu, &dt);
>  
>  	__kvm_set_dr(vcpu, 7, DR7_FIXED_1);
>  
> @@ -7996,7 +7996,7 @@ static void enter_smm(struct kvm_vcpu *vcpu)
>  
>  #ifdef CONFIG_X86_64
>  	if (guest_cpuid_has(vcpu, X86_FEATURE_LM))
> -		kvm_x86_ops->set_efer(vcpu, 0);
> +		kvm_x86_ops.set_efer(vcpu, 0);
>  #endif
>  
>  	kvm_update_cpuid(vcpu);
> @@ -8034,7 +8034,7 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
>  
>  	vcpu->arch.apicv_active = kvm_apicv_activated(vcpu->kvm);
>  	kvm_apic_update_apicv(vcpu);
> -	kvm_x86_ops->refresh_apicv_exec_ctrl(vcpu);
> +	kvm_x86_ops.refresh_apicv_exec_ctrl(vcpu);
>  }
>  EXPORT_SYMBOL_GPL(kvm_vcpu_update_apicv);
>  
> @@ -8049,8 +8049,8 @@ void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
>  {
>  	unsigned long old, new, expected;
>  
> -	if (!kvm_x86_ops->check_apicv_inhibit_reasons ||
> -	    !kvm_x86_ops->check_apicv_inhibit_reasons(bit))
> +	if (!kvm_x86_ops.check_apicv_inhibit_reasons ||
> +	    !kvm_x86_ops.check_apicv_inhibit_reasons(bit))
>  		return;
>  
>  	old = READ_ONCE(kvm->arch.apicv_inhibit_reasons);
> @@ -8069,8 +8069,8 @@ void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
>  		return;
>  
>  	trace_kvm_apicv_update_request(activate, bit);
> -	if (kvm_x86_ops->pre_update_apicv_exec_ctrl)
> -		kvm_x86_ops->pre_update_apicv_exec_ctrl(kvm, activate);
> +	if (kvm_x86_ops.pre_update_apicv_exec_ctrl)
> +		kvm_x86_ops.pre_update_apicv_exec_ctrl(kvm, activate);
>  	kvm_make_all_cpus_request(kvm, KVM_REQ_APICV_UPDATE);
>  }
>  EXPORT_SYMBOL_GPL(kvm_request_apicv_update);
> @@ -8086,7 +8086,7 @@ static void vcpu_scan_ioapic(struct kvm_vcpu *vcpu)
>  		kvm_scan_ioapic_routes(vcpu, vcpu->arch.ioapic_handled_vectors);
>  	else {
>  		if (vcpu->arch.apicv_active)
> -			kvm_x86_ops->sync_pir_to_irr(vcpu);
> +			kvm_x86_ops.sync_pir_to_irr(vcpu);
>  		if (ioapic_in_kernel(vcpu->kvm))
>  			kvm_ioapic_scan_entry(vcpu, vcpu->arch.ioapic_handled_vectors);
>  	}
> @@ -8106,7 +8106,7 @@ static void vcpu_load_eoi_exitmap(struct kvm_vcpu *vcpu)
>  
>  	bitmap_or((ulong *)eoi_exit_bitmap, vcpu->arch.ioapic_handled_vectors,
>  		  vcpu_to_synic(vcpu)->vec_bitmap, 256);
> -	kvm_x86_ops->load_eoi_exitmap(vcpu, eoi_exit_bitmap);
> +	kvm_x86_ops.load_eoi_exitmap(vcpu, eoi_exit_bitmap);
>  }
>  
>  int kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
> @@ -8133,13 +8133,13 @@ void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
>  	if (!lapic_in_kernel(vcpu))
>  		return;
>  
> -	if (!kvm_x86_ops->set_apic_access_page_addr)
> +	if (!kvm_x86_ops.set_apic_access_page_addr)
>  		return;
>  
>  	page = gfn_to_page(vcpu->kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
>  	if (is_error_page(page))
>  		return;
> -	kvm_x86_ops->set_apic_access_page_addr(vcpu, page_to_phys(page));
> +	kvm_x86_ops.set_apic_access_page_addr(vcpu, page_to_phys(page));
>  
>  	/*
>  	 * Do not pin apic access page in memory, the MMU notifier
> @@ -8171,7 +8171,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  
>  	if (kvm_request_pending(vcpu)) {
>  		if (kvm_check_request(KVM_REQ_GET_VMCS12_PAGES, vcpu)) {
> -			if (unlikely(!kvm_x86_ops->get_vmcs12_pages(vcpu))) {
> +			if (unlikely(!kvm_x86_ops.get_vmcs12_pages(vcpu))) {
>  				r = 0;
>  				goto out;
>  			}
> @@ -8295,12 +8295,12 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  			 *    SMI.
>  			 */
>  			if (vcpu->arch.smi_pending && !is_smm(vcpu))
> -				if (!kvm_x86_ops->enable_smi_window(vcpu))
> +				if (!kvm_x86_ops.enable_smi_window(vcpu))
>  					req_immediate_exit = true;
>  			if (vcpu->arch.nmi_pending)
> -				kvm_x86_ops->enable_nmi_window(vcpu);
> +				kvm_x86_ops.enable_nmi_window(vcpu);
>  			if (kvm_cpu_has_injectable_intr(vcpu) || req_int_win)
> -				kvm_x86_ops->enable_irq_window(vcpu);
> +				kvm_x86_ops.enable_irq_window(vcpu);
>  			WARN_ON(vcpu->arch.exception.pending);
>  		}
>  
> @@ -8317,7 +8317,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  
>  	preempt_disable();
>  
> -	kvm_x86_ops->prepare_guest_switch(vcpu);
> +	kvm_x86_ops.prepare_guest_switch(vcpu);
>  
>  	/*
>  	 * Disable IRQs before setting IN_GUEST_MODE.  Posted interrupt
> @@ -8348,7 +8348,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  	 * notified with kvm_vcpu_kick.
>  	 */
>  	if (kvm_lapic_enabled(vcpu) && vcpu->arch.apicv_active)
> -		kvm_x86_ops->sync_pir_to_irr(vcpu);
> +		kvm_x86_ops.sync_pir_to_irr(vcpu);
>  
>  	if (vcpu->mode == EXITING_GUEST_MODE || kvm_request_pending(vcpu)
>  	    || need_resched() || signal_pending(current)) {
> @@ -8363,7 +8363,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  
>  	if (req_immediate_exit) {
>  		kvm_make_request(KVM_REQ_EVENT, vcpu);
> -		kvm_x86_ops->request_immediate_exit(vcpu);
> +		kvm_x86_ops.request_immediate_exit(vcpu);
>  	}
>  
>  	trace_kvm_entry(vcpu->vcpu_id);
> @@ -8383,7 +8383,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  		vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_RELOAD;
>  	}
>  
> -	kvm_x86_ops->run(vcpu);
> +	kvm_x86_ops.run(vcpu);
>  
>  	/*
>  	 * Do this here before restoring debug registers on the host.  And
> @@ -8393,7 +8393,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  	 */
>  	if (unlikely(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)) {
>  		WARN_ON(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP);
> -		kvm_x86_ops->sync_dirty_debug_regs(vcpu);
> +		kvm_x86_ops.sync_dirty_debug_regs(vcpu);
>  		kvm_update_dr0123(vcpu);
>  		kvm_update_dr6(vcpu);
>  		kvm_update_dr7(vcpu);
> @@ -8415,7 +8415,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  	vcpu->mode = OUTSIDE_GUEST_MODE;
>  	smp_wmb();
>  
> -	kvm_x86_ops->handle_exit_irqoff(vcpu, &exit_fastpath);
> +	kvm_x86_ops.handle_exit_irqoff(vcpu, &exit_fastpath);
>  
>  	/*
>  	 * Consume any pending interrupts, including the possible source of
> @@ -8458,11 +8458,11 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  	if (vcpu->arch.apic_attention)
>  		kvm_lapic_sync_from_vapic(vcpu);
>  
> -	r = kvm_x86_ops->handle_exit(vcpu, exit_fastpath);
> +	r = kvm_x86_ops.handle_exit(vcpu, exit_fastpath);
>  	return r;
>  
>  cancel_injection:
> -	kvm_x86_ops->cancel_injection(vcpu);
> +	kvm_x86_ops.cancel_injection(vcpu);
>  	if (unlikely(vcpu->arch.apic_attention))
>  		kvm_lapic_sync_from_vapic(vcpu);
>  out:
> @@ -8472,13 +8472,13 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
>  {
>  	if (!kvm_arch_vcpu_runnable(vcpu) &&
> -	    (!kvm_x86_ops->pre_block || kvm_x86_ops->pre_block(vcpu) == 0)) {
> +	    (!kvm_x86_ops.pre_block || kvm_x86_ops.pre_block(vcpu) == 0)) {
>  		srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
>  		kvm_vcpu_block(vcpu);
>  		vcpu->srcu_idx = srcu_read_lock(&kvm->srcu);
>  
> -		if (kvm_x86_ops->post_block)
> -			kvm_x86_ops->post_block(vcpu);
> +		if (kvm_x86_ops.post_block)
> +			kvm_x86_ops.post_block(vcpu);
>  
>  		if (!kvm_check_request(KVM_REQ_UNHALT, vcpu))
>  			return 1;
> @@ -8504,8 +8504,8 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
>  
>  static inline bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
>  {
> -	if (is_guest_mode(vcpu) && kvm_x86_ops->check_nested_events)
> -		kvm_x86_ops->check_nested_events(vcpu);
> +	if (is_guest_mode(vcpu) && kvm_x86_ops.check_nested_events)
> +		kvm_x86_ops.check_nested_events(vcpu);
>  
>  	return (vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE &&
>  		!vcpu->arch.apf.halted);
> @@ -8661,7 +8661,7 @@ static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
>  
>  	kvm_save_current_fpu(vcpu->arch.user_fpu);
>  
> -	/* PKRU is separately restored in kvm_x86_ops->run.  */
> +	/* PKRU is separately restored in kvm_x86_ops.run.  */
>  	__copy_kernel_to_fpregs(&vcpu->arch.guest_fpu->state,
>  				~XFEATURE_MASK_PKRU);
>  
> @@ -8864,10 +8864,10 @@ static void __get_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
>  	kvm_get_segment(vcpu, &sregs->tr, VCPU_SREG_TR);
>  	kvm_get_segment(vcpu, &sregs->ldt, VCPU_SREG_LDTR);
>  
> -	kvm_x86_ops->get_idt(vcpu, &dt);
> +	kvm_x86_ops.get_idt(vcpu, &dt);
>  	sregs->idt.limit = dt.size;
>  	sregs->idt.base = dt.address;
> -	kvm_x86_ops->get_gdt(vcpu, &dt);
> +	kvm_x86_ops.get_gdt(vcpu, &dt);
>  	sregs->gdt.limit = dt.size;
>  	sregs->gdt.base = dt.address;
>  
> @@ -9014,10 +9014,10 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
>  
>  	dt.size = sregs->idt.limit;
>  	dt.address = sregs->idt.base;
> -	kvm_x86_ops->set_idt(vcpu, &dt);
> +	kvm_x86_ops.set_idt(vcpu, &dt);
>  	dt.size = sregs->gdt.limit;
>  	dt.address = sregs->gdt.base;
> -	kvm_x86_ops->set_gdt(vcpu, &dt);
> +	kvm_x86_ops.set_gdt(vcpu, &dt);
>  
>  	vcpu->arch.cr2 = sregs->cr2;
>  	mmu_reset_needed |= kvm_read_cr3(vcpu) != sregs->cr3;
> @@ -9027,16 +9027,16 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
>  	kvm_set_cr8(vcpu, sregs->cr8);
>  
>  	mmu_reset_needed |= vcpu->arch.efer != sregs->efer;
> -	kvm_x86_ops->set_efer(vcpu, sregs->efer);
> +	kvm_x86_ops.set_efer(vcpu, sregs->efer);
>  
>  	mmu_reset_needed |= kvm_read_cr0(vcpu) != sregs->cr0;
> -	kvm_x86_ops->set_cr0(vcpu, sregs->cr0);
> +	kvm_x86_ops.set_cr0(vcpu, sregs->cr0);
>  	vcpu->arch.cr0 = sregs->cr0;
>  
>  	mmu_reset_needed |= kvm_read_cr4(vcpu) != sregs->cr4;
>  	cpuid_update_needed |= ((kvm_read_cr4(vcpu) ^ sregs->cr4) &
>  				(X86_CR4_OSXSAVE | X86_CR4_PKE));
> -	kvm_x86_ops->set_cr4(vcpu, sregs->cr4);
> +	kvm_x86_ops.set_cr4(vcpu, sregs->cr4);
>  	if (cpuid_update_needed)
>  		kvm_update_cpuid(vcpu);
>  
> @@ -9142,7 +9142,7 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
>  	 */
>  	kvm_set_rflags(vcpu, rflags);
>  
> -	kvm_x86_ops->update_bp_intercept(vcpu);
> +	kvm_x86_ops.update_bp_intercept(vcpu);
>  
>  	r = 0;
>  
> @@ -9353,7 +9353,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  
>  	kvm_hv_vcpu_init(vcpu);
>  
> -	r = kvm_x86_ops->vcpu_create(vcpu);
> +	r = kvm_x86_ops.vcpu_create(vcpu);
>  	if (r)
>  		goto free_guest_fpu;
>  
> @@ -9420,7 +9420,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>  
>  	kvmclock_reset(vcpu);
>  
> -	kvm_x86_ops->vcpu_free(vcpu);
> +	kvm_x86_ops.vcpu_free(vcpu);
>  
>  	kmem_cache_free(x86_emulator_cache, vcpu->arch.emulate_ctxt);
>  	free_cpumask_var(vcpu->arch.wbinvd_dirty_mask);
> @@ -9508,7 +9508,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  
>  	vcpu->arch.ia32_xss = 0;
>  
> -	kvm_x86_ops->vcpu_reset(vcpu, init_event);
> +	kvm_x86_ops.vcpu_reset(vcpu, init_event);
>  }
>  
>  void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
> @@ -9533,7 +9533,7 @@ int kvm_arch_hardware_enable(void)
>  	bool stable, backwards_tsc = false;
>  
>  	kvm_shared_msr_cpu_online();
> -	ret = kvm_x86_ops->hardware_enable();
> +	ret = kvm_x86_ops.hardware_enable();
>  	if (ret != 0)
>  		return ret;
>  
> @@ -9615,7 +9615,7 @@ int kvm_arch_hardware_enable(void)
>  
>  void kvm_arch_hardware_disable(void)
>  {
> -	kvm_x86_ops->hardware_disable();
> +	kvm_x86_ops.hardware_disable();
>  	drop_user_return_notifiers();
>  }
>  
> @@ -9633,7 +9633,7 @@ int kvm_arch_hardware_setup(void *opaque)
>  	if (r != 0)
>  		return r;
>  
> -	kvm_x86_ops = ops->runtime_ops;
> +	memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
>  
>  	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
>  		supported_xss = 0;
> @@ -9660,7 +9660,7 @@ int kvm_arch_hardware_setup(void *opaque)
>  
>  void kvm_arch_hardware_unsetup(void)
>  {
> -	kvm_x86_ops->hardware_unsetup();
> +	kvm_x86_ops.hardware_unsetup();
>  }
>  
>  int kvm_arch_check_processor_compat(void *opaque)
> @@ -9699,7 +9699,7 @@ void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
>  		pmu->need_cleanup = true;
>  		kvm_make_request(KVM_REQ_PMU, vcpu);
>  	}
> -	kvm_x86_ops->sched_in(vcpu, cpu);
> +	kvm_x86_ops.sched_in(vcpu, cpu);
>  }
>  
>  void kvm_arch_free_vm(struct kvm *kvm)
> @@ -9743,7 +9743,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  	kvm_page_track_init(kvm);
>  	kvm_mmu_init_vm(kvm);
>  
> -	return kvm_x86_ops->vm_init(kvm);
> +	return kvm_x86_ops.vm_init(kvm);
>  }
>  
>  int kvm_arch_post_init_vm(struct kvm *kvm)
> @@ -9866,8 +9866,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>  		__x86_set_memory_region(kvm, TSS_PRIVATE_MEMSLOT, 0, 0);
>  		mutex_unlock(&kvm->slots_lock);
>  	}
> -	if (kvm_x86_ops->vm_destroy)
> -		kvm_x86_ops->vm_destroy(kvm);
> +	if (kvm_x86_ops.vm_destroy)
> +		kvm_x86_ops.vm_destroy(kvm);
>  	kvm_pic_destroy(kvm);
>  	kvm_ioapic_destroy(kvm);
>  	kvm_free_vcpus(kvm);
> @@ -10005,7 +10005,7 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
>  	/*
>  	 * Call kvm_x86_ops dirty logging hooks when they are valid.
>  	 *
> -	 * kvm_x86_ops->slot_disable_log_dirty is called when:
> +	 * kvm_x86_ops.slot_disable_log_dirty is called when:
>  	 *
>  	 *  - KVM_MR_CREATE with dirty logging is disabled
>  	 *  - KVM_MR_FLAGS_ONLY with dirty logging is disabled in new flag
> @@ -10017,7 +10017,7 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
>  	 * any additional overhead from PML when guest is running with dirty
>  	 * logging disabled for memory slots.
>  	 *
> -	 * kvm_x86_ops->slot_enable_log_dirty is called when switching new slot
> +	 * kvm_x86_ops.slot_enable_log_dirty is called when switching new slot
>  	 * to dirty logging mode.
>  	 *
>  	 * If kvm_x86_ops dirty logging hooks are invalid, use write protect.
> @@ -10033,8 +10033,8 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
>  	 * See the comments in fast_page_fault().
>  	 */
>  	if (new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
> -		if (kvm_x86_ops->slot_enable_log_dirty) {
> -			kvm_x86_ops->slot_enable_log_dirty(kvm, new);
> +		if (kvm_x86_ops.slot_enable_log_dirty) {
> +			kvm_x86_ops.slot_enable_log_dirty(kvm, new);
>  		} else {
>  			int level =
>  				kvm_dirty_log_manual_protect_and_init_set(kvm) ?
> @@ -10051,8 +10051,8 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
>  			kvm_mmu_slot_remove_write_access(kvm, new, level);
>  		}
>  	} else {
> -		if (kvm_x86_ops->slot_disable_log_dirty)
> -			kvm_x86_ops->slot_disable_log_dirty(kvm, new);
> +		if (kvm_x86_ops.slot_disable_log_dirty)
> +			kvm_x86_ops.slot_disable_log_dirty(kvm, new);
>  	}
>  }
>  
> @@ -10120,8 +10120,8 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
>  static inline bool kvm_guest_apic_has_interrupt(struct kvm_vcpu *vcpu)
>  {
>  	return (is_guest_mode(vcpu) &&
> -			kvm_x86_ops->guest_apic_has_interrupt &&
> -			kvm_x86_ops->guest_apic_has_interrupt(vcpu));
> +			kvm_x86_ops.guest_apic_has_interrupt &&
> +			kvm_x86_ops.guest_apic_has_interrupt(vcpu));
>  }
>  
>  static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
> @@ -10140,7 +10140,7 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
>  
>  	if (kvm_test_request(KVM_REQ_NMI, vcpu) ||
>  	    (vcpu->arch.nmi_pending &&
> -	     kvm_x86_ops->nmi_allowed(vcpu)))
> +	     kvm_x86_ops.nmi_allowed(vcpu)))
>  		return true;
>  
>  	if (kvm_test_request(KVM_REQ_SMI, vcpu) ||
> @@ -10173,7 +10173,7 @@ bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu)
>  		 kvm_test_request(KVM_REQ_EVENT, vcpu))
>  		return true;
>  
> -	if (vcpu->arch.apicv_active && kvm_x86_ops->dy_apicv_has_pending_interrupt(vcpu))
> +	if (vcpu->arch.apicv_active && kvm_x86_ops.dy_apicv_has_pending_interrupt(vcpu))
>  		return true;
>  
>  	return false;
> @@ -10191,7 +10191,7 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
>  
>  int kvm_arch_interrupt_allowed(struct kvm_vcpu *vcpu)
>  {
> -	return kvm_x86_ops->interrupt_allowed(vcpu);
> +	return kvm_x86_ops.interrupt_allowed(vcpu);
>  }
>  
>  unsigned long kvm_get_linear_rip(struct kvm_vcpu *vcpu)
> @@ -10213,7 +10213,7 @@ unsigned long kvm_get_rflags(struct kvm_vcpu *vcpu)
>  {
>  	unsigned long rflags;
>  
> -	rflags = kvm_x86_ops->get_rflags(vcpu);
> +	rflags = kvm_x86_ops.get_rflags(vcpu);
>  	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
>  		rflags &= ~X86_EFLAGS_TF;
>  	return rflags;
> @@ -10225,7 +10225,7 @@ static void __kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
>  	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP &&
>  	    kvm_is_linear_rip(vcpu, vcpu->arch.singlestep_rip))
>  		rflags |= X86_EFLAGS_TF;
> -	kvm_x86_ops->set_rflags(vcpu, rflags);
> +	kvm_x86_ops.set_rflags(vcpu, rflags);
>  }
>  
>  void kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
> @@ -10336,7 +10336,7 @@ static bool kvm_can_deliver_async_pf(struct kvm_vcpu *vcpu)
>  
>  	if (!(vcpu->arch.apf.msr_val & KVM_ASYNC_PF_ENABLED) ||
>  	    (vcpu->arch.apf.send_user_only &&
> -	     kvm_x86_ops->get_cpl(vcpu) == 0))
> +	     kvm_x86_ops.get_cpl(vcpu) == 0))
>  		return false;
>  
>  	return true;
> @@ -10356,7 +10356,7 @@ bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
>  	 * If interrupts are off we cannot even use an artificial
>  	 * halt state.
>  	 */
> -	return kvm_x86_ops->interrupt_allowed(vcpu);
> +	return kvm_x86_ops.interrupt_allowed(vcpu);
>  }
>  
>  void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
> @@ -10485,7 +10485,7 @@ int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
>  
>  	irqfd->producer = prod;
>  
> -	return kvm_x86_ops->update_pi_irte(irqfd->kvm,
> +	return kvm_x86_ops.update_pi_irte(irqfd->kvm,
>  					   prod->irq, irqfd->gsi, 1);
>  }
>  
> @@ -10505,7 +10505,7 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
>  	 * when the irq is masked/disabled or the consumer side (KVM
>  	 * int this case doesn't want to receive the interrupts.
>  	*/
> -	ret = kvm_x86_ops->update_pi_irte(irqfd->kvm, prod->irq, irqfd->gsi, 0);
> +	ret = kvm_x86_ops.update_pi_irte(irqfd->kvm, prod->irq, irqfd->gsi, 0);
>  	if (ret)
>  		printk(KERN_INFO "irq bypass consumer (token %p) unregistration"
>  		       " fails: %d\n", irqfd->consumer.token, ret);
> @@ -10514,7 +10514,7 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
>  int kvm_arch_update_irqfd_routing(struct kvm *kvm, unsigned int host_irq,
>  				   uint32_t guest_irq, bool set)
>  {
> -	return kvm_x86_ops->update_pi_irte(kvm, host_irq, guest_irq, set);
> +	return kvm_x86_ops.update_pi_irte(kvm, host_irq, guest_irq, set);
>  }
>  
>  bool kvm_vector_hashing_enabled(void)
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index c1954e216b41..b968acc0516f 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -97,7 +97,7 @@ static inline bool is_64_bit_mode(struct kvm_vcpu *vcpu)
>  
>  	if (!is_long_mode(vcpu))
>  		return false;
> -	kvm_x86_ops->get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
> +	kvm_x86_ops.get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
>  	return cs_l;
>  }
>  
> @@ -237,7 +237,7 @@ static inline bool kvm_check_has_quirk(struct kvm *kvm, u64 quirk)
>  
>  static inline bool kvm_vcpu_latch_init(struct kvm_vcpu *vcpu)
>  {
> -	return is_smm(vcpu) || kvm_x86_ops->apic_init_signal_blocked(vcpu);
> +	return is_smm(vcpu) || kvm_x86_ops.apic_init_signal_blocked(vcpu);
>  }
>  
>  void kvm_set_pending_timer(struct kvm_vcpu *vcpu);

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

(OK, I have to admit I trust the fact that GCC is still able to build
KVM modules more than my own eyes)

-- 
Vitaly

