Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75B44192704
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 12:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbgCYLXY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 07:23:24 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:57305 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727137AbgCYLXY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Mar 2020 07:23:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585135402;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xM8/HiUu9KS4l1vvKviFSbzzMYLuLCSAR51DCNPH9wg=;
        b=ilRkrFXC1dAIarLRo1xtNrAq//vHuzzODd8DH4sDzV6m2Nm18h86NlU18yI/p62Q/ExLeG
        MSIdOfM4LQpGgF/O1qZaSSu4hdS4XH35g/LuoAwrORL1fte7Mh87tr87I/O5rrdoszIx8i
        Vk1t0wLrudAFteVtECLIbPVjWhpCz0w=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-_LhD1vw1NsKYxrqeOZkXxA-1; Wed, 25 Mar 2020 07:23:20 -0400
X-MC-Unique: _LhD1vw1NsKYxrqeOZkXxA-1
Received: by mail-wr1-f70.google.com with SMTP id m15so1010912wrb.0
        for <kvm@vger.kernel.org>; Wed, 25 Mar 2020 04:23:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=xM8/HiUu9KS4l1vvKviFSbzzMYLuLCSAR51DCNPH9wg=;
        b=X4bGtlc4CbyKtDUMXAqnGbpuMYPHPP6cIZdRBjls+YO0L5yRNKdm4W2EjrFiy/9JAE
         Iot60qwZAySg7RqnEYzSsxNfPnt/yy7el4KE4MoxHX07QaVqKKKuJvagfjz2atmQzQKS
         Qk+8wLrPPg2EOEzl8ZH/zpa2cT+5Hm3FfdTR3HwlykC7Ib/K+NaR3c24w6+7zybRUEKE
         Ee175axgfRjsDONFzk52cRh3qlM2rRQNqgRiDR6PJVPtK3W1m/jQYfKCD50/HNkgpt7M
         brUTjmhKwClBIXhspr80vwyciAl8xaoP9JG96RPNUGVQ5eQcGBKx+rAo38hhpMF/UMg0
         7OYw==
X-Gm-Message-State: ANhLgQ397Ibwl2SF8BJcUuE/PWrttJpiCVDxXbFw2N5U+Js3vqIVrQ0u
        W9OHhtqPVOiSxRcYJ5nWNcc8ST6hM67/yAh/L8WHrSO4Cis5ZfNjPZkDn1N68nn/6/OeLDOnmxH
        oFHUBtmMhjnFE
X-Received: by 2002:a1c:418b:: with SMTP id o133mr3059401wma.165.1585135399340;
        Wed, 25 Mar 2020 04:23:19 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsNxpymlGDXK2pMtUJu3/qkiDEJlJHA+syg80J0/Cezok4jop+ihdiZCFhavJ0NbJDsMJMGXA==
X-Received: by 2002:a1c:418b:: with SMTP id o133mr3059372wma.165.1585135399026;
        Wed, 25 Mar 2020 04:23:19 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id u5sm25475275wrq.85.2020.03.25.04.23.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 04:23:18 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v3 16/37] KVM: x86: Drop @invalidate_gpa param from kvm_x86_ops' tlb_flush()
In-Reply-To: <20200320212833.3507-17-sean.j.christopherson@intel.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com> <20200320212833.3507-17-sean.j.christopherson@intel.com>
Date:   Wed, 25 Mar 2020 12:23:16 +0100
Message-ID: <87zhc465ln.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Drop @invalidate_gpa from ->tlb_flush() and kvm_vcpu_flush_tlb() now
> that all callers pass %true for said param, or ignore the param (SVM has
> an internal call to svm_flush_tlb() in svm_flush_tlb_guest that somewhat
> arbitrarily passes %false).
>
> Remove __vmx_flush_tlb() as it is no longer used.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 +-
>  arch/x86/kvm/mmu/mmu.c          |  2 +-
>  arch/x86/kvm/svm.c              | 10 ++++----
>  arch/x86/kvm/vmx/vmx.c          |  4 ++--
>  arch/x86/kvm/vmx/vmx.h          | 42 ++++++++++-----------------------
>  arch/x86/kvm/x86.c              |  6 ++---
>  6 files changed, 24 insertions(+), 42 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index c08f4c0bf4d1..a5dfab4642d6 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1105,7 +1105,7 @@ struct kvm_x86_ops {
>  	unsigned long (*get_rflags)(struct kvm_vcpu *vcpu);
>  	void (*set_rflags)(struct kvm_vcpu *vcpu, unsigned long rflags);
>  
> -	void (*tlb_flush)(struct kvm_vcpu *vcpu, bool invalidate_gpa);
> +	void (*tlb_flush)(struct kvm_vcpu *vcpu);
>  	int  (*tlb_remote_flush)(struct kvm *kvm);
>  	int  (*tlb_remote_flush_with_range)(struct kvm *kvm,
>  			struct kvm_tlb_range *range);
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 5ae620881bbc..a87b8f9f3b1f 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5177,7 +5177,7 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
>  	if (r)
>  		goto out;
>  	kvm_mmu_load_pgd(vcpu);
> -	kvm_x86_ops->tlb_flush(vcpu, true);
> +	kvm_x86_ops->tlb_flush(vcpu);
>  out:
>  	return r;
>  }
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 396f42753489..62fa45dcb6a4 100644
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
> @@ -2692,7 +2692,7 @@ static int svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>  		return 1;
>  
>  	if (npt_enabled && ((old_cr4 ^ cr4) & X86_CR4_PGE))
> -		svm_flush_tlb(vcpu, true);
> +		svm_flush_tlb(vcpu);
>  
>  	vcpu->arch.cr4 = cr4;
>  	if (!npt_enabled)
> @@ -3630,7 +3630,7 @@ static void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
>  	svm->nested.intercept_exceptions = nested_vmcb->control.intercept_exceptions;
>  	svm->nested.intercept            = nested_vmcb->control.intercept;
>  
> -	svm_flush_tlb(&svm->vcpu, true);
> +	svm_flush_tlb(&svm->vcpu);
>  	svm->vmcb->control.int_ctl = nested_vmcb->control.int_ctl | V_INTR_MASKING_MASK;
>  	if (nested_vmcb->control.int_ctl & V_INTR_MASKING_MASK)
>  		svm->vcpu.arch.hflags |= HF_VINTR_MASK;
> @@ -5626,7 +5626,7 @@ static int svm_set_identity_map_addr(struct kvm *kvm, u64 ident_addr)
>  	return 0;
>  }
>  
> -static void svm_flush_tlb(struct kvm_vcpu *vcpu, bool invalidate_gpa)
> +static void svm_flush_tlb(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
> @@ -5645,7 +5645,7 @@ static void svm_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t gva)
>  
>  static void svm_flush_tlb_guest(struct kvm_vcpu *vcpu)
>  {
> -	svm_flush_tlb(vcpu, false);
> +	svm_flush_tlb(vcpu);
>  }
>  
>  static void svm_prepare_guest_switch(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 43c0d4706f9a..477bdbc52ed0 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6079,7 +6079,7 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
>  		if (flexpriority_enabled) {
>  			sec_exec_control |=
>  				SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
> -			vmx_flush_tlb(vcpu, true);
> +			vmx_flush_tlb(vcpu);
>  		}
>  		break;
>  	case LAPIC_MODE_X2APIC:
> @@ -6097,7 +6097,7 @@ static void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu, hpa_t hpa)
>  {
>  	if (!is_guest_mode(vcpu)) {
>  		vmcs_write64(APIC_ACCESS_ADDR, hpa);
> -		vmx_flush_tlb(vcpu, true);
> +		vmx_flush_tlb(vcpu);
>  	}
>  }
>  
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 3770ae111e6a..bab5d62ad964 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -503,46 +503,28 @@ static inline struct vmcs *alloc_vmcs(bool shadow)
>  
>  u64 construct_eptp(struct kvm_vcpu *vcpu, unsigned long root_hpa);
>  
> -static inline void __vmx_flush_tlb(struct kvm_vcpu *vcpu, int vpid,
> -				bool invalidate_gpa)
> -{
> -	if (enable_ept && (invalidate_gpa || !enable_vpid)) {
> -		if (!VALID_PAGE(vcpu->arch.mmu->root_hpa))
> -			return;
> -		ept_sync_context(construct_eptp(vcpu,
> -						vcpu->arch.mmu->root_hpa));
> -	} else {
> -		vpid_sync_context(vpid);
> -	}
> -}
> -
> -static inline void vmx_flush_tlb(struct kvm_vcpu *vcpu, bool invalidate_gpa)
> +static inline void vmx_flush_tlb(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  
>  	/*
> -	 * Flush all EPTP/VPID contexts if the TLB flush _may_ have been
> -	 * invoked via kvm_flush_remote_tlbs(), which always passes %true for
> -	 * @invalidate_gpa.  Flushing remote TLBs requires all contexts to be
> -	 * flushed, not just the active context.
> +	 * Flush all EPTP/VPID contexts, as the TLB flush _may_ have been
> +	 * invoked via kvm_flush_remote_tlbs().  Flushing remote TLBs requires
> +	 * all contexts to be flushed, not just the active context.
>  	 *
>  	 * Note, this also ensures a deferred TLB flush with VPID enabled and
>  	 * EPT disabled invalidates the "correct" VPID, by nuking both L1 and
>  	 * L2's VPIDs.
>  	 */
> -	if (invalidate_gpa) {
> -		if (enable_ept) {
> -			ept_sync_global();
> -		} else if (enable_vpid) {
> -			if (cpu_has_vmx_invvpid_global()) {
> -				vpid_sync_vcpu_global();
> -			} else {
> -				vpid_sync_vcpu_single(vmx->vpid);
> -				vpid_sync_vcpu_single(vmx->nested.vpid02);
> -			}
> +	if (enable_ept) {
> +		ept_sync_global();
> +	} else if (enable_vpid) {
> +		if (cpu_has_vmx_invvpid_global()) {
> +			vpid_sync_vcpu_global();
> +		} else {
> +			vpid_sync_vcpu_single(vmx->vpid);
> +			vpid_sync_vcpu_single(vmx->nested.vpid02);
>  		}
> -	} else {
> -		__vmx_flush_tlb(vcpu, vmx->vpid, false);
>  	}
>  }
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0b90ec2c93cf..84cbd7ca1e18 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2696,10 +2696,10 @@ static void kvmclock_reset(struct kvm_vcpu *vcpu)
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
> @@ -8223,7 +8223,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  		if (kvm_check_request(KVM_REQ_LOAD_MMU_PGD, vcpu))
>  			kvm_mmu_load_pgd(vcpu);
>  		if (kvm_check_request(KVM_REQ_TLB_FLUSH, vcpu))
> -			kvm_vcpu_flush_tlb(vcpu, true);
> +			kvm_vcpu_flush_tlb(vcpu);
>  		if (kvm_check_request(KVM_REQ_REPORT_TPR_ACCESS, vcpu)) {
>  			vcpu->run->exit_reason = KVM_EXIT_TPR_ACCESS;
>  			r = 0;

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

