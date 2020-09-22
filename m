Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 287F3273E22
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 11:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgIVJJv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 05:09:51 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43743 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726341AbgIVJJv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Sep 2020 05:09:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600765788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dlwBbmlT33V+h0BeMM8gRKX8e2iMIelZkNm7u7GyTbg=;
        b=GAh4tO217k03vcV1t55K+4jz0fBe88bFiCf85unem2oA8YI/IvzP8JqpaDuQ57JEwGqBvd
        E/vRcOScz9yWHmcRyXOqbLJ0rYmNfRXvEWMYDxPUwm7Htl2Vd2vVos0PmsdaYOOBkKHBC4
        22oAWf3+4D3p7nS/OuCq8NEcmQ+64Qc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-05OGaCqdNxKoWPlgmUf9JQ-1; Tue, 22 Sep 2020 05:09:46 -0400
X-MC-Unique: 05OGaCqdNxKoWPlgmUf9JQ-1
Received: by mail-wr1-f70.google.com with SMTP id a2so7116936wrp.8
        for <kvm@vger.kernel.org>; Tue, 22 Sep 2020 02:09:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dlwBbmlT33V+h0BeMM8gRKX8e2iMIelZkNm7u7GyTbg=;
        b=jUnD5BOHTcRvVaqCk6gjVX1VNeJ5L5xpKInGIDojoDBSinuDp3SCKKmiuiUefUFO7l
         4vf8oKQlORKHUD4xsfkagvea4kdS4xookOgNEhjQnBIbLL+uOf5ayCJ2P1f8b8RSWHs5
         Pa3JlKE0mRQyixcxmJo504UOFiaLLnqA2x94uwdOhK7VqjOasx5XZxOYtF2TQqCRtMTN
         qQ+etoyKgUy/LrfNaGJHB/6gn7vcQcJVRh7DZvhOx+oF4zh+4U6oHxf/rcz79CyxBSqV
         M5TP34um2HlGq0QEOXPf3HoHtGI92Kghj9wwseIUOWufw4Fe3JTDMQFYFGDy/F00fGDI
         0l9g==
X-Gm-Message-State: AOAM532GX/CTkxEkDbMv2T/d6RqfXYQ67edTQZuGWaADJfq+QF5uIBmI
        TwsZSRzNMRUdvYYVClW0QedcHGIvHG3U/Z/WqovVDhmCR2xW7iXx5voN1tzWkgs47gc4LETKwJr
        pjqsYZ6NUO+Uf
X-Received: by 2002:a5d:4645:: with SMTP id j5mr3805574wrs.388.1600765785466;
        Tue, 22 Sep 2020 02:09:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw7JqV24PrXJuYHeDqe3X8GvO65yGb5CIe9mFGwkxcEfjYU3ieJvPK/stYm5zTeJ+bk0vEEZQ==
X-Received: by 2002:a5d:4645:: with SMTP id j5mr3805551wrs.388.1600765785182;
        Tue, 22 Sep 2020 02:09:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec2c:90a9:1236:ebc6? ([2001:b07:6468:f312:ec2c:90a9:1236:ebc6])
        by smtp.gmail.com with ESMTPSA id c25sm3454921wml.31.2020.09.22.02.09.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2020 02:09:44 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: emulate wait-for-SIPI and SIPI-VMExit
To:     yadong.qi@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        liran.alon@oracle.com, nikita.leshchenko@oracle.com,
        chao.gao@intel.com, kevin.tian@intel.com, luhai.chen@intel.com,
        bing.zhu@intel.com, kai.z.wang@intel.com
References: <20200922052343.84388-1-yadong.qi@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c0157014-d1bb-ef81-b92f-ebecb72396c9@redhat.com>
Date:   Tue, 22 Sep 2020 11:09:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200922052343.84388-1-yadong.qi@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/09/20 07:23, yadong.qi@intel.com wrote:
> From: Yadong Qi <yadong.qi@intel.com>
> 
> Background: We have a lightweight HV, it needs INIT-VMExit and
> SIPI-VMExit to wake-up APs for guests since it do not monitor
> the Local APIC. But currently virtual wait-for-SIPI(WFS) state
> is not supported in nVMX, so when running on top of KVM, the L1
> HV cannot receive the INIT-VMExit and SIPI-VMExit which cause
> the L2 guest cannot wake up the APs.
> 
> According to Intel SDM Chapter 25.2 Other Causes of VM Exits,
> SIPIs cause VM exits when a logical processor is in
> wait-for-SIPI state.
> 
> In this patch:
>     1. introduce SIPI exit reason,
>     2. introduce wait-for-SIPI state for nVMX,
>     3. advertise wait-for-SIPI support to guest.
> 
> When L1 hypervisor is not monitoring Local APIC, L0 need to emulate
> INIT-VMExit and SIPI-VMExit to L1 to emulate INIT-SIPI-SIPI for
> L2. L2 LAPIC write would be traped by L0 Hypervisor(KVM), L0 should
> emulate the INIT/SIPI vmexit to L1 hypervisor to set proper state
> for L2's vcpu state.
> 
> Handle procdure:
> Source vCPU:
>     L2 write LAPIC.ICR(INIT).
>     L0 trap LAPIC.ICR write(INIT): inject a latched INIT event to target
>        vCPU.
> Target vCPU:
>     L0 emulate an INIT VMExit to L1 if is guest mode.
>     L1 set guest VMCS, guest_activity_state=WAIT_SIPI, vmresume.
>     L0 set vcpu.mp_state to INIT_RECEIVED if (vmcs12.guest_activity_state
>        == WAIT_SIPI).
> 
> Source vCPU:
>     L2 write LAPIC.ICR(SIPI).
>     L0 trap LAPIC.ICR write(INIT): inject a latched SIPI event to traget
>        vCPU.
> Target vCPU:
>     L0 emulate an SIPI VMExit to L1 if (vcpu.mp_state == INIT_RECEIVED).
>     L1 set CS:IP, guest_activity_state=ACTIVE, vmresume.
>     L0 resume to L2.
>     L2 start-up.

Again, this looks good but it needs testcases.

Thanks,

Paolo

> Signed-off-by: Yadong Qi <yadong.qi@intel.com>
> ---
>  arch/x86/include/asm/vmx.h      |  1 +
>  arch/x86/include/uapi/asm/vmx.h |  2 ++
>  arch/x86/kvm/lapic.c            |  5 ++--
>  arch/x86/kvm/vmx/nested.c       | 53 ++++++++++++++++++++++++---------
>  4 files changed, 45 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index cd7de4b401fe..bff06dc64c52 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -113,6 +113,7 @@
>  #define VMX_MISC_PREEMPTION_TIMER_RATE_MASK	0x0000001f
>  #define VMX_MISC_SAVE_EFER_LMA			0x00000020
>  #define VMX_MISC_ACTIVITY_HLT			0x00000040
> +#define VMX_MISC_ACTIVITY_WAIT_SIPI		0x00000100
>  #define VMX_MISC_ZERO_LEN_INS			0x40000000
>  #define VMX_MISC_MSR_LIST_MULTIPLIER		512
>  
> diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
> index b8ff9e8ac0d5..ada955c5ebb6 100644
> --- a/arch/x86/include/uapi/asm/vmx.h
> +++ b/arch/x86/include/uapi/asm/vmx.h
> @@ -32,6 +32,7 @@
>  #define EXIT_REASON_EXTERNAL_INTERRUPT  1
>  #define EXIT_REASON_TRIPLE_FAULT        2
>  #define EXIT_REASON_INIT_SIGNAL			3
> +#define EXIT_REASON_SIPI_SIGNAL         4
>  
>  #define EXIT_REASON_INTERRUPT_WINDOW    7
>  #define EXIT_REASON_NMI_WINDOW          8
> @@ -94,6 +95,7 @@
>  	{ EXIT_REASON_EXTERNAL_INTERRUPT,    "EXTERNAL_INTERRUPT" }, \
>  	{ EXIT_REASON_TRIPLE_FAULT,          "TRIPLE_FAULT" }, \
>  	{ EXIT_REASON_INIT_SIGNAL,           "INIT_SIGNAL" }, \
> +	{ EXIT_REASON_SIPI_SIGNAL,           "SIPI_SIGNAL" }, \
>  	{ EXIT_REASON_INTERRUPT_WINDOW,      "INTERRUPT_WINDOW" }, \
>  	{ EXIT_REASON_NMI_WINDOW,            "NMI_WINDOW" }, \
>  	{ EXIT_REASON_TASK_SWITCH,           "TASK_SWITCH" }, \
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 5ccbee7165a2..d04ac7dc6adf 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2839,7 +2839,7 @@ void kvm_apic_accept_events(struct kvm_vcpu *vcpu)
>  
>  	/*
>  	 * INITs are latched while CPU is in specific states
> -	 * (SMM, VMX non-root mode, SVM with GIF=0).
> +	 * (SMM, SVM with GIF=0).
>  	 * Because a CPU cannot be in these states immediately
>  	 * after it has processed an INIT signal (and thus in
>  	 * KVM_MP_STATE_INIT_RECEIVED state), just eat SIPIs
> @@ -2847,7 +2847,8 @@ void kvm_apic_accept_events(struct kvm_vcpu *vcpu)
>  	 */
>  	if (kvm_vcpu_latch_init(vcpu)) {
>  		WARN_ON_ONCE(vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED);
> -		if (test_bit(KVM_APIC_SIPI, &apic->pending_events))
> +		if (test_bit(KVM_APIC_SIPI, &apic->pending_events) &&
> +		    !is_guest_mode(vcpu))
>  			clear_bit(KVM_APIC_SIPI, &apic->pending_events);
>  		return;
>  	}
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 1bb6b31eb646..fe3bb68df987 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2946,7 +2946,8 @@ static int nested_vmx_check_vmcs_link_ptr(struct kvm_vcpu *vcpu,
>  static int nested_check_guest_non_reg_state(struct vmcs12 *vmcs12)
>  {
>  	if (CC(vmcs12->guest_activity_state != GUEST_ACTIVITY_ACTIVE &&
> -	       vmcs12->guest_activity_state != GUEST_ACTIVITY_HLT))
> +	       vmcs12->guest_activity_state != GUEST_ACTIVITY_HLT &&
> +	       vmcs12->guest_activity_state != GUEST_ACTIVITY_WAIT_SIPI))
>  		return -EINVAL;
>  
>  	return 0;
> @@ -3543,19 +3544,29 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
>  	 */
>  	nested_cache_shadow_vmcs12(vcpu, vmcs12);
>  
> -	/*
> -	 * If we're entering a halted L2 vcpu and the L2 vcpu won't be
> -	 * awakened by event injection or by an NMI-window VM-exit or
> -	 * by an interrupt-window VM-exit, halt the vcpu.
> -	 */
> -	if ((vmcs12->guest_activity_state == GUEST_ACTIVITY_HLT) &&
> -	    !(vmcs12->vm_entry_intr_info_field & INTR_INFO_VALID_MASK) &&
> -	    !(vmcs12->cpu_based_vm_exec_control & CPU_BASED_NMI_WINDOW_EXITING) &&
> -	    !((vmcs12->cpu_based_vm_exec_control & CPU_BASED_INTR_WINDOW_EXITING) &&
> -	      (vmcs12->guest_rflags & X86_EFLAGS_IF))) {
> +	switch (vmcs12->guest_activity_state) {
> +	case GUEST_ACTIVITY_HLT:
> +		/*
> +		 * If we're entering a halted L2 vcpu and the L2 vcpu won't be
> +		 * awakened by event injection or by an NMI-window VM-exit or
> +		 * by an interrupt-window VM-exit, halt the vcpu.
> +		 */
> +		if (!(vmcs12->vm_entry_intr_info_field & INTR_INFO_VALID_MASK) &&
> +		    !nested_cpu_has(vmcs12, CPU_BASED_NMI_WINDOW_EXITING) &&
> +		    !(nested_cpu_has(vmcs12, CPU_BASED_INTR_WINDOW_EXITING) &&
> +		      (vmcs12->guest_rflags & X86_EFLAGS_IF))) {
> +			vmx->nested.nested_run_pending = 0;
> +			return kvm_vcpu_halt(vcpu);
> +		}
> +		break;
> +	case GUEST_ACTIVITY_WAIT_SIPI:
>  		vmx->nested.nested_run_pending = 0;
> -		return kvm_vcpu_halt(vcpu);
> +		vcpu->arch.mp_state = KVM_MP_STATE_INIT_RECEIVED;
> +		break;
> +	default:
> +		break;
>  	}
> +
>  	return 1;
>  
>  vmentry_failed:
> @@ -3781,7 +3792,20 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
>  			return -EBUSY;
>  		nested_vmx_update_pending_dbg(vcpu);
>  		clear_bit(KVM_APIC_INIT, &apic->pending_events);
> -		nested_vmx_vmexit(vcpu, EXIT_REASON_INIT_SIGNAL, 0, 0);
> +		if (vcpu->arch.mp_state != KVM_MP_STATE_INIT_RECEIVED)
> +			nested_vmx_vmexit(vcpu, EXIT_REASON_INIT_SIGNAL, 0, 0);
> +		return 0;
> +	}
> +
> +	if (lapic_in_kernel(vcpu) &&
> +	    test_bit(KVM_APIC_SIPI, &apic->pending_events)) {
> +		if (block_nested_events)
> +			return -EBUSY;
> +
> +		clear_bit(KVM_APIC_SIPI, &apic->pending_events);
> +		if (vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED)
> +			nested_vmx_vmexit(vcpu, EXIT_REASON_SIPI_SIGNAL, 0,
> +						apic->sipi_vector & 0xFFUL);
>  		return 0;
>  	}
>  
> @@ -6471,7 +6495,8 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
>  	msrs->misc_low |=
>  		MSR_IA32_VMX_MISC_VMWRITE_SHADOW_RO_FIELDS |
>  		VMX_MISC_EMULATED_PREEMPTION_TIMER_RATE |
> -		VMX_MISC_ACTIVITY_HLT;
> +		VMX_MISC_ACTIVITY_HLT |
> +		VMX_MISC_ACTIVITY_WAIT_SIPI;
>  	msrs->misc_high = 0;
>  
>  	/*
> 

