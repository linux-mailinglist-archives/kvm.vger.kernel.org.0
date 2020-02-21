Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 052AA167F59
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 14:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbgBUN4K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 08:56:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21715 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727851AbgBUN4K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Feb 2020 08:56:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582293368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0wJ2DcRu2iM9J+IFuY4fwVGeerGyayvqPTgEiY7hGPg=;
        b=Jw/85POl4FxfJVEXVqjAR9flhoe55ufJNwuWMdrvrXy8HaQR8VzGZP8KemUQmTs3DkAaoV
        ptGvwJ+H9NwOcUNtV4koBaiC9Fjsx0vXw7ciCdi8UjgaR/8x06MENkT/36BP3OKL4ltSuL
        0+sn6vmSJg4wdE95eW17aYVwdnaqfPg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-AG7M6SXCPVe_UkoJE6H86A-1; Fri, 21 Feb 2020 08:56:07 -0500
X-MC-Unique: AG7M6SXCPVe_UkoJE6H86A-1
Received: by mail-wr1-f71.google.com with SMTP id l1so1061740wrt.4
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2020 05:56:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=0wJ2DcRu2iM9J+IFuY4fwVGeerGyayvqPTgEiY7hGPg=;
        b=ijrfWCvUTGXY0wCByvv8F5W5OKR22neIkeodDXGvhy9l5W/3Z1/JIZl2X6sPnmd9Ah
         k6XLFW6NK+gsePMUHebRxjnAcoylaH58YsFNnXIE/eTGgFAk4n1t33GpAx5MWr1K9AtM
         gSwNarTb+Zei5LHFp0Lm4fRacdgfRQ+FEYXzkL3iiEmXiHRFOL9OkKWIe/EUmotsbBh3
         gKEC+sIDuHgH0k+319ZdJDFyT3BItzseJYtcVmkwR9svP5RQiWSBN+jm7RjKwoSG7UD3
         stKKu+aILHsWmKHcuoUePz79k89aVqEXBdUh5oH7cOGiaUdmyEKV5QhyNyaqIxZGIF1j
         DfPg==
X-Gm-Message-State: APjAAAUEvmhxkYpxOIVs4bYAaLQgkKgWWSx22sSC33WpBFqnzA5KmG9w
        v74M0HGrYPw1GKkt+bJIqo17zoh4fru6Yv4y7Xjhsbx7VDAAtxNKZKEy6e4FC2ljalNt2BjW/yI
        2voWwViZLAtit
X-Received: by 2002:a5d:4dc5:: with SMTP id f5mr50305959wru.114.1582293365876;
        Fri, 21 Feb 2020 05:56:05 -0800 (PST)
X-Google-Smtp-Source: APXvYqx6vLP++U6NB2kRzMQ6ua4noqwRRJdokUKIN/5ekAbUa4srP/tvoSymVT19IWwmFOr+YIcIMA==
X-Received: by 2002:a5d:4dc5:: with SMTP id f5mr50305934wru.114.1582293365592;
        Fri, 21 Feb 2020 05:56:05 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id x7sm3972669wrq.41.2020.02.21.05.56.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 05:56:05 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/10] KVM: x86: Drop @invalidate_gpa param from kvm_x86_ops' tlb_flush()
In-Reply-To: <20200220204356.8837-9-sean.j.christopherson@intel.com>
References: <20200220204356.8837-1-sean.j.christopherson@intel.com> <20200220204356.8837-9-sean.j.christopherson@intel.com>
Date:   Fri, 21 Feb 2020 14:56:04 +0100
Message-ID: <87o8tsrqmj.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Drop @invalidate_gpa from ->tlb_flush() and kvm_vcpu_flush_tlb() now
> that all callers pass %true for said param.
>
> Note, vmx_flush_tlb() now unconditionally passes %true to
> __vmx_flush_tlb(), the less straightforward VMX change will be handled
> in a future patch.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 +-
>  arch/x86/kvm/mmu/mmu.c          |  2 +-
>  arch/x86/kvm/svm.c              | 10 +++++-----
>  arch/x86/kvm/vmx/vmx.c          |  4 ++--
>  arch/x86/kvm/vmx/vmx.h          |  4 ++--
>  arch/x86/kvm/x86.c              |  6 +++---
>  6 files changed, 14 insertions(+), 14 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 86aed64b9a88..2d5ef0081d50 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1095,7 +1095,7 @@ struct kvm_x86_ops {
>  	unsigned long (*get_rflags)(struct kvm_vcpu *vcpu);
>  	void (*set_rflags)(struct kvm_vcpu *vcpu, unsigned long rflags);
>  
> -	void (*tlb_flush)(struct kvm_vcpu *vcpu, bool invalidate_gpa);
> +	void (*tlb_flush)(struct kvm_vcpu *vcpu);
>  	int  (*tlb_remote_flush)(struct kvm *kvm);
>  	int  (*tlb_remote_flush_with_range)(struct kvm *kvm,
>  			struct kvm_tlb_range *range);
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 7011a4e54866..7fefe58dd7ab 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5186,7 +5186,7 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
>  	if (r)
>  		goto out;
>  	kvm_mmu_load_cr3(vcpu);
> -	kvm_x86_ops->tlb_flush(vcpu, true);
> +	kvm_x86_ops->tlb_flush(vcpu);
>  out:
>  	return r;
>  }
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index e549811f51c6..16d58ffc7aff 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -385,7 +385,7 @@ module_param(dump_invalid_vmcb, bool, 0644);
>  static u8 rsm_ins_bytes[] = "\x0f\xaa";
>  
>  static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
> -static void svm_flush_tlb(struct kvm_vcpu *vcpu, bool invalidate_gpa);
> +static void svm_flush_tlb(struct kvm_vcpu *vcpu);
>  static void svm_complete_interrupts(struct vcpu_svm *svm);
>  static void svm_toggle_avic_for_irq_window(struct kvm_vcpu *vcpu, bool activate);
>  static inline void avic_post_state_restore(struct kvm_vcpu *vcpu);
> @@ -2634,7 +2634,7 @@ static int svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>  		return 1;
>  
>  	if (npt_enabled && ((old_cr4 ^ cr4) & X86_CR4_PGE))
> -		svm_flush_tlb(vcpu, true);
> +		svm_flush_tlb(vcpu);
>  
>  	vcpu->arch.cr4 = cr4;
>  	if (!npt_enabled)
> @@ -3588,7 +3588,7 @@ static void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
>  	svm->nested.intercept_exceptions = nested_vmcb->control.intercept_exceptions;
>  	svm->nested.intercept            = nested_vmcb->control.intercept;
>  
> -	svm_flush_tlb(&svm->vcpu, true);
> +	svm_flush_tlb(&svm->vcpu);
>  	svm->vmcb->control.int_ctl = nested_vmcb->control.int_ctl | V_INTR_MASKING_MASK;
>  	if (nested_vmcb->control.int_ctl & V_INTR_MASKING_MASK)
>  		svm->vcpu.arch.hflags |= HF_VINTR_MASK;
> @@ -5591,7 +5591,7 @@ static int svm_set_identity_map_addr(struct kvm *kvm, u64 ident_addr)
>  	return 0;
>  }
>  
> -static void svm_flush_tlb(struct kvm_vcpu *vcpu, bool invalidate_gpa)
> +static void svm_flush_tlb(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
> @@ -5610,7 +5610,7 @@ static void svm_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t gva)
>  
>  static void svm_flush_tlb_guest(struct kvm_vcpu *vcpu)
>  {
> -	svm_flush_tlb(vcpu, true);
> +	svm_flush_tlb(vcpu);
>  }
>  
>  static void svm_prepare_guest_switch(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 906e9d9aa09e..8bb380d22dc2 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6043,7 +6043,7 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
>  		if (flexpriority_enabled) {
>  			sec_exec_control |=
>  				SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
> -			vmx_flush_tlb(vcpu, true);
> +			vmx_flush_tlb(vcpu);
>  		}
>  		break;
>  	case LAPIC_MODE_X2APIC:
> @@ -6061,7 +6061,7 @@ static void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu, hpa_t hpa)
>  {
>  	if (!is_guest_mode(vcpu)) {
>  		vmcs_write64(APIC_ACCESS_ADDR, hpa);
> -		vmx_flush_tlb(vcpu, true);
> +		vmx_flush_tlb(vcpu);
>  	}
>  }
>  
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 7f42cf3dcd70..6e588d238318 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -514,9 +514,9 @@ static inline void __vmx_flush_tlb(struct kvm_vcpu *vcpu, int vpid,
>  	}
>  }
>  
> -static inline void vmx_flush_tlb(struct kvm_vcpu *vcpu, bool invalidate_gpa)
> +static inline void vmx_flush_tlb(struct kvm_vcpu *vcpu)
>  {
> -	__vmx_flush_tlb(vcpu, to_vmx(vcpu)->vpid, invalidate_gpa);
> +	__vmx_flush_tlb(vcpu, to_vmx(vcpu)->vpid, true);
>  }
>  
>  static inline void decache_tsc_multiplier(struct vcpu_vmx *vmx)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 72f7ca4baa6d..e26ffebe6f6e 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2646,10 +2646,10 @@ static void kvmclock_reset(struct kvm_vcpu *vcpu)
>  	vcpu->arch.time = 0;
>  }
>  
> -static void kvm_vcpu_flush_tlb(struct kvm_vcpu *vcpu, bool invalidate_gpa)
> +static void kvm_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
>  {
>  	++vcpu->stat.tlb_flush;
> -	kvm_x86_ops->tlb_flush(vcpu, invalidate_gpa);
> +	kvm_x86_ops->tlb_flush(vcpu);
>  }
>  
>  static void record_steal_time(struct kvm_vcpu *vcpu)
> @@ -8166,7 +8166,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  		if (kvm_check_request(KVM_REQ_LOAD_CR3, vcpu))
>  			kvm_mmu_load_cr3(vcpu);
>  		if (kvm_check_request(KVM_REQ_TLB_FLUSH, vcpu))
> -			kvm_vcpu_flush_tlb(vcpu, true);
> +			kvm_vcpu_flush_tlb(vcpu);
>  		if (kvm_check_request(KVM_REQ_REPORT_TPR_ACCESS, vcpu)) {
>  			vcpu->run->exit_reason = KVM_EXIT_TPR_ACCESS;
>  			r = 0;

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

