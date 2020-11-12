Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B999B2B028F
	for <lists+kvm@lfdr.de>; Thu, 12 Nov 2020 11:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbgKLKLy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Nov 2020 05:11:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33875 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726969AbgKLKLx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Nov 2020 05:11:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605175910;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iHsN82w7xIBwdWwiVkyVaGrTkr3ksvykkOu14oV0/5g=;
        b=ZaZNvJ5kSJMmjN5mnjOtg2zf5fPl8ET6nGu68EgTo/0+/yxDkSPfqzjIr88jDvqK0fCYeW
        4Fc1QUHU70UPALki7jxMR5oGUPH5bQNyZZucTdmvt57wEkNsdCrX0QegO2AuMrgUXEUNmb
        KovMbt2QfHCtZOUH8RQSbtP5M6a6U70=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-JLZrfjdWOZK2F9TrexnruA-1; Thu, 12 Nov 2020 05:11:46 -0500
X-MC-Unique: JLZrfjdWOZK2F9TrexnruA-1
Received: by mail-wr1-f69.google.com with SMTP id g5so320379wrp.5
        for <kvm@vger.kernel.org>; Thu, 12 Nov 2020 02:11:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=iHsN82w7xIBwdWwiVkyVaGrTkr3ksvykkOu14oV0/5g=;
        b=NzFuM9qtox7H9TGN8DBk/aqgQoAUEL6H/Sv15ReaHPD84gIIPoufRM9JP8ImgcWtjs
         pHxPnB76MM3j4RNrAg4sFBWoLWB3UVy61jYJTEEHk1kbu2VVrrQUJm3tamLNsMz0BQ7h
         abBEojA0Is7Bs/USz7vhzvvtvUiaIuy0zxL4kTyiBVD59rgoPTcbH1hNRyCEiRSSG3bj
         MscmgKdesAztMP7NWcrDOJEKSgqLAORbymh2FvI1tmXxTI+3/qKNvqpMWJOQ6ViHrKno
         rkZfaEO+dlYnofI65/SfU6RMsls9j3pQTdo31YePqRX50epirUnbu+t/px2KrQ4W9RKG
         t7QQ==
X-Gm-Message-State: AOAM533fwM3tDIZ0yB/fu73aVboAEVSkVPWycRYObIhsm1UYWgb48yri
        FdX4tnpPt1mb3dSxMONiB17RslXlxyYLLNDbshqOR4GDMlG5iCdOoniKt8mDxauyw0CDemkuHws
        C4hi181LCCHFw
X-Received: by 2002:a05:6000:1050:: with SMTP id c16mr34898236wrx.400.1605175905516;
        Thu, 12 Nov 2020 02:11:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwe2BhjYsp+SSlN1jJwaLZS3c/6Z3eshoazGpahfaJ+CeyDCftFt/EbeZOwlBR9KbbccoUviQ==
X-Received: by 2002:a05:6000:1050:: with SMTP id c16mr34898209wrx.400.1605175905236;
        Thu, 12 Nov 2020 02:11:45 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id p12sm6007408wrw.28.2020.11.12.02.11.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 02:11:44 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 01/11] KVM: x86: Get active PCID only when writing a
 CR3 value
In-Reply-To: <20201027212346.23409-2-sean.j.christopherson@intel.com>
References: <20201027212346.23409-1-sean.j.christopherson@intel.com>
 <20201027212346.23409-2-sean.j.christopherson@intel.com>
Date:   Thu, 12 Nov 2020 11:11:43 +0100
Message-ID: <87imaazxy8.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Retrieve the active PCID only when writing a guest CR3 value, i.e. don't
> get the PCID when using EPT.  The PCID is not used when EPT is enabled,
> and must be manually stripped, which is annoying and unnecessary.
> And on VMX, getting the active PCID also involves reading the guest's
> CR3 and CR4.PCIDE, i.e. may add pointless VMREADs.
>
> Opportunistically rename the pgd/pgd_level params to root_hpa and
> root_level to better reflect their new roles.  Keep the function names,
> as "load the guest PGD" is still accurate/correct.
>
> Last, and probably least, pass root_hpa as a hpa_t/u64 instead of an
> unsigned long.  The EPTP holds a 64-bit value, even in 32-bit mode, so
> in theory EPT could support HIGHMEM for 32-bit KVM.  Never mind that
> doing so would require changing the MMU page allocators and reworking
> the MMU to use kmap().
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  4 ++--
>  arch/x86/kvm/mmu.h              |  2 +-
>  arch/x86/kvm/svm/svm.c          |  4 ++--
>  arch/x86/kvm/vmx/vmx.c          | 13 ++++++-------
>  arch/x86/kvm/vmx/vmx.h          |  3 +--
>  5 files changed, 12 insertions(+), 14 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index d44858b69353..33b2acfd7869 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1181,8 +1181,8 @@ struct kvm_x86_ops {
>  	int (*set_identity_map_addr)(struct kvm *kvm, u64 ident_addr);
>  	u64 (*get_mt_mask)(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
>  
> -	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, unsigned long pgd,
> -			     int pgd_level);
> +	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
> +			     int root_level);
>  
>  	bool (*has_wbinvd_exit)(void);
>  
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 9c4a9c8e43d9..add537a39177 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -95,7 +95,7 @@ static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vcpu)
>  	if (!VALID_PAGE(root_hpa))
>  		return;
>  
> -	kvm_x86_ops.load_mmu_pgd(vcpu, root_hpa | kvm_get_active_pcid(vcpu),
> +	kvm_x86_ops.load_mmu_pgd(vcpu, root_hpa,
>  				 vcpu->arch.mmu->shadow_root_level);
>  }
>  
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index cf951e588dd1..4a6a5a3dc963 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3667,13 +3667,13 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>  	return svm_exit_handlers_fastpath(vcpu);
>  }
>  
> -static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long root,
> +static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
>  			     int root_level)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	unsigned long cr3;
>  
> -	cr3 = __sme_set(root);
> +	cr3 = __sme_set(root_hpa) | kvm_get_active_pcid(vcpu);
>  	if (npt_enabled) {
>  		svm->vmcb->control.nested_cr3 = cr3;
>  		vmcb_mark_dirty(svm->vmcb, VMCB_NPT);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 281c405c7ea3..273a3206cef7 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3043,8 +3043,7 @@ static int vmx_get_max_tdp_level(void)
>  	return 4;
>  }
>  
> -u64 construct_eptp(struct kvm_vcpu *vcpu, unsigned long root_hpa,
> -		   int root_level)
> +u64 construct_eptp(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level)
>  {
>  	u64 eptp = VMX_EPTP_MT_WB;
>  
> @@ -3053,13 +3052,13 @@ u64 construct_eptp(struct kvm_vcpu *vcpu, unsigned long root_hpa,
>  	if (enable_ept_ad_bits &&
>  	    (!is_guest_mode(vcpu) || nested_ept_ad_enabled(vcpu)))
>  		eptp |= VMX_EPTP_AD_ENABLE_BIT;
> -	eptp |= (root_hpa & PAGE_MASK);
> +	eptp |= root_hpa;

(Nitpicking according to personal taste):

It looks a bit weird that we start building 'eptp' from flags and add
pointer as the last step, I'd suggest we re-write the function as:

u64 construct_eptp(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level)
 {
        u64 eptp = root_hpa | VMX_EPTP_MT_WB;
 
        eptp |= (root_level == 5) ? VMX_EPTP_PWL_5 : VMX_EPTP_PWL_4;
 
        if (enable_ept_ad_bits &&
            (!is_guest_mode(vcpu) || nested_ept_ad_enabled(vcpu)))
                eptp |= VMX_EPTP_AD_ENABLE_BIT;
 
        return eptp;
 }

>  
>  	return eptp;
>  }
>  
> -static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long pgd,
> -			     int pgd_level)
> +static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
> +			     int root_level)
>  {
>  	struct kvm *kvm = vcpu->kvm;
>  	bool update_guest_cr3 = true;
> @@ -3067,7 +3066,7 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long pgd,
>  	u64 eptp;
>  
>  	if (enable_ept) {
> -		eptp = construct_eptp(vcpu, pgd, pgd_level);
> +		eptp = construct_eptp(vcpu, root_hpa, root_level);
>  		vmcs_write64(EPT_POINTER, eptp);
>  
>  		if (kvm_x86_ops.tlb_remote_flush) {
> @@ -3086,7 +3085,7 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long pgd,
>  			update_guest_cr3 = false;
>  		vmx_ept_load_pdptrs(vcpu);
>  	} else {
> -		guest_cr3 = pgd;
> +		guest_cr3 = root_hpa | kvm_get_active_pcid(vcpu);
>  	}
>  
>  	if (update_guest_cr3)
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index f6f66e5c6510..a2d143276603 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -326,8 +326,7 @@ void set_cr4_guest_host_mask(struct vcpu_vmx *vmx);
>  void ept_save_pdptrs(struct kvm_vcpu *vcpu);
>  void vmx_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
>  void vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
> -u64 construct_eptp(struct kvm_vcpu *vcpu, unsigned long root_hpa,
> -		   int root_level);
> +u64 construct_eptp(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
>  
>  void update_exception_bitmap(struct kvm_vcpu *vcpu);
>  void vmx_update_msr_bitmap(struct kvm_vcpu *vcpu);

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

