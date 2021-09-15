Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71DD040C3A2
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 12:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232731AbhIOKcH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Sep 2021 06:32:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60077 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232304AbhIOKcH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Sep 2021 06:32:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631701847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+jevmYjl//WQ7aSqjNdV6Rv/1a+VPKT86ET3rw91ZgA=;
        b=As3w94YkuyBxKhCcS9eClPfuwF2R+3Hx5fR28vCWAh8sicJnDqMBbMPjPukpjVGW7vmKp0
        niEBxGh7JJOTQCce70HydiYpN9GpUK2FPpbRe0d6d0TQFbfMOgsUZNGDChD87ERNzM6O4I
        +O7qK5zJpWS8+dysP5WA9EajjHO+OHQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-l3lVvEs7ODy-_V7zpFMSiQ-1; Wed, 15 Sep 2021 06:30:46 -0400
X-MC-Unique: l3lVvEs7ODy-_V7zpFMSiQ-1
Received: by mail-wr1-f72.google.com with SMTP id v1-20020adfc401000000b0015e11f71e65so849036wrf.2
        for <kvm@vger.kernel.org>; Wed, 15 Sep 2021 03:30:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=+jevmYjl//WQ7aSqjNdV6Rv/1a+VPKT86ET3rw91ZgA=;
        b=HoV9OZocZo/F8ZX4bXBxBi0/7pw2G3FmQ0N6pHfJMQGXeFT3gy0YxIpOPIeCJzQi+z
         tVCclqqan3Jt2w5zqxcSc0M94GcQfvNwW98dVQ8wTQyTtPNuDl+GVCn6wzCchV0aQFQ2
         CGzjwHd3Rcq9h4X8VnUFAZJFRPoZjsspQOf64CkDGRNISLsTH+vNnVV7xiiXH/mwZ/NO
         8nW3AU4jzmABg1NUhrUJd9CQT72Equfo7iakDoMpG1lGvRnmdlSUEp0RHTnJbxtLlV7j
         VieyQ8tGCX6DwJzydIHDLkopM9o/1X0NQI9bIvBfxYdat3HlF6tugetq7OgMyjXVajjz
         5aOA==
X-Gm-Message-State: AOAM531ViWGd+piOJM2UM128uYxhYTwE1kSyAaNKdDT24O0HskSAk0jS
        gnnyuS0iooFQSpaqD3dZ6Siu+0CWevAjmPKecwnszChN/LyqWSak2pKBj3tgdPdZ0GEeE+DumKe
        mx1o8cF28158T
X-Received: by 2002:adf:e10c:: with SMTP id t12mr4180510wrz.36.1631701845443;
        Wed, 15 Sep 2021 03:30:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyQTWAF3DNcBCbP4LPGORNOeByHF5CiJHBVpD6p/X3MYkXqISCAwl3bsemOuxfLRP3sfGScSQ==
X-Received: by 2002:adf:e10c:: with SMTP id t12mr4180492wrz.36.1631701845208;
        Wed, 15 Sep 2021 03:30:45 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id y8sm6111329wrh.44.2021.09.15.03.30.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 03:30:44 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH 2/3] KVM: VMX: Move RESET emulation to vmx_vcpu_reset()
In-Reply-To: <20210914230840.3030620-3-seanjc@google.com>
References: <20210914230840.3030620-1-seanjc@google.com>
 <20210914230840.3030620-3-seanjc@google.com>
Date:   Wed, 15 Sep 2021 12:30:43 +0200
Message-ID: <875yv2167g.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> Move vCPU RESET emulation, including initializating of select VMCS state,
> to vmx_vcpu_reset().  Drop the open coded "vCPU load" sequence, as
> ->vcpu_reset() is invoked while the vCPU is properly loaded (which is
> kind of the point of ->vcpu_reset()...).  Hopefully KVM will someday
> expose a dedicated RESET ioctl(), and in the meantime separating "create"
> from "RESET" is a nice cleanup.
>
> Deferring VMCS initialization is effectively a nop as it's impossible to
> safely access the VMCS between the current call site and its new home, as
> both the vCPU and the pCPU are put immediately after init_vmcs(), i.e.
> the VMCS isn't guaranteed to be loaded.
>
> Note, task preemption is not a problem as vmx_sched_in() _can't_ touch
> the VMCS as ->sched_in() is invoked before the vCPU, and thus VMCS, is
> reloaded.  I.e. the preemption path also can't consume VMCS state.
>
> Cc: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 61 +++++++++++++++++++++---------------------
>  1 file changed, 31 insertions(+), 30 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index dc274b4c9912..629427cf8f4e 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4327,10 +4327,6 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
>  
>  #define VMX_XSS_EXIT_BITMAP 0
>  
> -/*
> - * Noting that the initialization of Guest-state Area of VMCS is in
> - * vmx_vcpu_reset().
> - */
>  static void init_vmcs(struct vcpu_vmx *vmx)
>  {
>  	if (nested)
> @@ -4435,10 +4431,39 @@ static void init_vmcs(struct vcpu_vmx *vmx)
>  	vmx_setup_uret_msrs(vmx);
>  }
>  
> +static void __vmx_vcpu_reset(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +
> +	init_vmcs(vmx);
> +
> +	if (nested)
> +		memcpy(&vmx->nested.msrs, &vmcs_config.nested, sizeof(vmx->nested.msrs));
> +
> +	vcpu_setup_sgx_lepubkeyhash(vcpu);
> +
> +	vmx->nested.posted_intr_nv = -1;
> +	vmx->nested.current_vmptr = -1ull;
> +	vmx->nested.hv_evmcs_vmptr = EVMPTR_INVALID;

What would happen in (hypothetical) case when enlightened VMCS is
currently in use? If we zap 'hv_evmcs_vmptr' here, the consequent
nested_release_evmcs() (called from
nested_vmx_handle_enlightened_vmptrld(), for example) will not do 
kvm_vcpu_unmap() while it should.

This, however, got me thinking: should we free all-things-nested with
free_nested()/nested_vmx_free_vcpu() upon vcpu reset? I can't seem to
find us doing that... (I do remember that INIT is blocked in VMX-root
mode and nobody else besides kvm_arch_vcpu_create()/
kvm_apic_accept_events() seems to call kvm_vcpu_reset()) but maybe we
should at least add a WARN_ON() guardian here?

Side topic: we don't seem to reset Hyper-V specific MSRs either,
probably relying on userspace VMM doing the right thing but this is also
not ideal I believe.

> +
> +	vcpu->arch.microcode_version = 0x100000000ULL;
> +	vmx->msr_ia32_feature_control_valid_bits = FEAT_CTL_LOCKED;
> +
> +	/*
> +	 * Enforce invariant: pi_desc.nv is always either POSTED_INTR_VECTOR
> +	 * or POSTED_INTR_WAKEUP_VECTOR.
> +	 */
> +	vmx->pi_desc.nv = POSTED_INTR_VECTOR;
> +	vmx->pi_desc.sn = 1;
> +}
> +
>  static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  
> +	if (!init_event)
> +		__vmx_vcpu_reset(vcpu);
> +
>  	vmx->rmode.vm86_active = 0;
>  	vmx->spec_ctrl = 0;
>  
> @@ -6797,7 +6822,7 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
>  {
>  	struct vmx_uret_msr *tsx_ctrl;
>  	struct vcpu_vmx *vmx;
> -	int i, cpu, err;
> +	int i, err;
>  
>  	BUILD_BUG_ON(offsetof(struct vcpu_vmx, vcpu) != 0);
>  	vmx = to_vmx(vcpu);
> @@ -6856,12 +6881,7 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
>  	}
>  
>  	vmx->loaded_vmcs = &vmx->vmcs01;
> -	cpu = get_cpu();
> -	vmx_vcpu_load(vcpu, cpu);
> -	vcpu->cpu = cpu;
> -	init_vmcs(vmx);
> -	vmx_vcpu_put(vcpu);
> -	put_cpu();
> +
>  	if (cpu_need_virtualize_apic_accesses(vcpu)) {
>  		err = alloc_apic_access_page(vcpu->kvm);
>  		if (err)
> @@ -6874,25 +6894,6 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
>  			goto free_vmcs;
>  	}
>  
> -	if (nested)
> -		memcpy(&vmx->nested.msrs, &vmcs_config.nested, sizeof(vmx->nested.msrs));
> -
> -	vcpu_setup_sgx_lepubkeyhash(vcpu);
> -
> -	vmx->nested.posted_intr_nv = -1;
> -	vmx->nested.current_vmptr = -1ull;
> -	vmx->nested.hv_evmcs_vmptr = EVMPTR_INVALID;
> -
> -	vcpu->arch.microcode_version = 0x100000000ULL;
> -	vmx->msr_ia32_feature_control_valid_bits = FEAT_CTL_LOCKED;
> -
> -	/*
> -	 * Enforce invariant: pi_desc.nv is always either POSTED_INTR_VECTOR
> -	 * or POSTED_INTR_WAKEUP_VECTOR.
> -	 */
> -	vmx->pi_desc.nv = POSTED_INTR_VECTOR;
> -	vmx->pi_desc.sn = 1;
> -
>  	return 0;
>  
>  free_vmcs:

-- 
Vitaly

