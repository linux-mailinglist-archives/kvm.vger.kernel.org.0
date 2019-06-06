Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3029E37A60
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 18:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbfFFQ7f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 12:59:35 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38193 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727356AbfFFQ7f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 12:59:35 -0400
Received: by mail-wm1-f67.google.com with SMTP id t5so684262wmh.3
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2019 09:59:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GHsYqKSECs1OPyezKZPKEsgnF26B95g43Poi2/mzVCg=;
        b=ZM1OLLxSvKo94efQkqGETqKvK6YIDYTkKE9Mn1WzZ/q/WJgbYvsu4XvEwiFH6mkxDn
         Gp9n9w3/zCa4G2YyRa4WFl0I3t8gGK66a+7QSTsVEmhPRpzV2tD0xybQ3PyCvulkqdUZ
         NvE3WXuKSltC6xjRmiEDN56yIOhu699KP99kTiE2gep0jpwMyG+0dYeucA/WmRgstoFT
         l7TV0RlGbnTadFcF8pOYSY0RGQDecQAFgBE7Kh6t6IawP8APG/ZZzOW1DEpVKRnHI0K1
         dmo0vKhHD0hPeHa6LwvstfWzqWPVBZ0uVpB3DAT8+s546vUl0hJ2HkYrzqtouDzTHby4
         D4HA==
X-Gm-Message-State: APjAAAV78njHPhsCYz5n1TNWRkH1M9MM8GSBvtZUWDXq+KcP5+dYCO/q
        uamqoekyK+6Go60Ge7RGhXy+q4ZsSXE=
X-Google-Smtp-Source: APXvYqzMI+3V8YbVl+tkh60Z9q2cwzIj3uQgVieMF7ZaYZSyIiuMfkPXZ7uefFefoMqYVKPW/8zOEQ==
X-Received: by 2002:a05:600c:21c6:: with SMTP id x6mr710765wmj.102.1559840372416;
        Thu, 06 Jun 2019 09:59:32 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id j3sm2509137wrt.73.2019.06.06.09.59.31
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 09:59:31 -0700 (PDT)
Subject: Re: [PATCH 05/13] KVM: VMX: Shadow VMCS secondary execution controls
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20190507191805.9932-1-sean.j.christopherson@intel.com>
 <20190507191805.9932-6-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7aa2a066-9452-fef0-5078-a17bc68c9192@redhat.com>
Date:   Thu, 6 Jun 2019 18:59:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190507191805.9932-6-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/05/19 21:17, Sean Christopherson wrote:
> Prepare to shadow all major control fields on a per-VMCS basis, which
> allows KVM to avoid costly VMWRITEs when switching between vmcs01 and
> vmcs02.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 12 ++++++------
>  arch/x86/kvm/vmx/vmx.c    | 40 +++++++++++++++++++--------------------
>  arch/x86/kvm/vmx/vmx.h    |  2 ++
>  3 files changed, 28 insertions(+), 26 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 7212cd04e9c2..007d03a49484 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -182,7 +182,7 @@ static void nested_vmx_abort(struct kvm_vcpu *vcpu, u32 indicator)
>  
>  static void vmx_disable_shadow_vmcs(struct vcpu_vmx *vmx)
>  {
> -	vmcs_clear_bits(SECONDARY_VM_EXEC_CONTROL, SECONDARY_EXEC_SHADOW_VMCS);
> +	sec_exec_controls_clearbit(vmx, SECONDARY_EXEC_SHADOW_VMCS);

Prefer "secondary_exec_controls_*".  Yes, it's a mouthful but it's more
consistent with code that is not about the shadowed control (such as the
constants, as in this line).

Paolo
>  	vmcs_write64(VMCS_LINK_POINTER, -1ull);
>  }
>  
> @@ -256,6 +256,7 @@ static void vmx_switch_vmcs(struct kvm_vcpu *vcpu, struct loaded_vmcs *vmcs)
>  	vm_exit_controls_reset_shadow(vmx);
>  	pin_controls_reset_shadow(vmx);
>  	exec_controls_reset_shadow(vmx);
> +	sec_exec_controls_reset_shadow(vmx);
>  	vmx_segment_cache_clear(vmx);
>  }
>  
> @@ -2074,7 +2075,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
>  		if (exec_control & SECONDARY_EXEC_ENCLS_EXITING)
>  			vmcs_write64(ENCLS_EXITING_BITMAP, -1ull);
>  
> -		vmcs_write32(SECONDARY_VM_EXEC_CONTROL, exec_control);
> +		sec_exec_controls_init(vmx, exec_control);
>  	}
>  
>  	/*
> @@ -2849,8 +2850,8 @@ static void nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
>  			hpa = page_to_phys(vmx->nested.apic_access_page);
>  			vmcs_write64(APIC_ACCESS_ADDR, hpa);
>  		} else {
> -			vmcs_clear_bits(SECONDARY_VM_EXEC_CONTROL,
> -					SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES);
> +			sec_exec_controls_clearbit(vmx,
> +				SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES);
>  		}
>  	}
>  
> @@ -4522,8 +4523,7 @@ static void set_current_vmptr(struct vcpu_vmx *vmx, gpa_t vmptr)
>  {
>  	vmx->nested.current_vmptr = vmptr;
>  	if (enable_shadow_vmcs) {
> -		vmcs_set_bits(SECONDARY_VM_EXEC_CONTROL,
> -			      SECONDARY_EXEC_SHADOW_VMCS);
> +		sec_exec_controls_setbit(vmx, SECONDARY_EXEC_SHADOW_VMCS);
>  		vmcs_write64(VMCS_LINK_POINTER,
>  			     __pa(vmx->vmcs01.shadow_vmcs));
>  		vmx->nested.need_vmcs12_sync = true;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 278007885a8e..274b870f6511 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2879,6 +2879,7 @@ void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
>  
>  int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>  {
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	/*
>  	 * Pass through host's Machine Check Enable value to hw_cr4, which
>  	 * is in force while we are in guest mode.  Do not let guests control
> @@ -2889,20 +2890,19 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>  	hw_cr4 = (cr4_read_shadow() & X86_CR4_MCE) | (cr4 & ~X86_CR4_MCE);
>  	if (enable_unrestricted_guest)
>  		hw_cr4 |= KVM_VM_CR4_ALWAYS_ON_UNRESTRICTED_GUEST;
> -	else if (to_vmx(vcpu)->rmode.vm86_active)
> +	else if (vmx->rmode.vm86_active)
>  		hw_cr4 |= KVM_RMODE_VM_CR4_ALWAYS_ON;
>  	else
>  		hw_cr4 |= KVM_PMODE_VM_CR4_ALWAYS_ON;
>  
>  	if (!boot_cpu_has(X86_FEATURE_UMIP) && vmx_umip_emulated()) {
>  		if (cr4 & X86_CR4_UMIP) {
> -			vmcs_set_bits(SECONDARY_VM_EXEC_CONTROL,
> -				SECONDARY_EXEC_DESC);
> +			sec_exec_controls_setbit(vmx, SECONDARY_EXEC_DESC);
>  			hw_cr4 &= ~X86_CR4_UMIP;
>  		} else if (!is_guest_mode(vcpu) ||
> -			!nested_cpu_has2(get_vmcs12(vcpu), SECONDARY_EXEC_DESC))
> -			vmcs_clear_bits(SECONDARY_VM_EXEC_CONTROL,
> -					SECONDARY_EXEC_DESC);
> +			!nested_cpu_has2(get_vmcs12(vcpu), SECONDARY_EXEC_DESC)) {
> +			sec_exec_controls_clearbit(vmx, SECONDARY_EXEC_DESC);
> +		}
>  	}
>  
>  	if (cr4 & X86_CR4_VMXE) {
> @@ -2917,7 +2917,7 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>  			return 1;
>  	}
>  
> -	if (to_vmx(vcpu)->nested.vmxon && !nested_cr4_valid(vcpu, cr4))
> +	if (vmx->nested.vmxon && !nested_cr4_valid(vcpu, cr4))
>  		return 1;
>  
>  	vcpu->arch.cr4 = cr4;
> @@ -3535,7 +3535,7 @@ static u8 vmx_msr_bitmap_mode(struct kvm_vcpu *vcpu)
>  	u8 mode = 0;
>  
>  	if (cpu_has_secondary_exec_ctrls() &&
> -	    (vmcs_read32(SECONDARY_VM_EXEC_CONTROL) &
> +	    (sec_exec_controls_get(to_vmx(vcpu)) &
>  	     SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE)) {
>  		mode |= MSR_BITMAP_MODE_X2APIC;
>  		if (enable_apicv && kvm_vcpu_apicv_active(vcpu))
> @@ -3818,11 +3818,11 @@ static void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
>  	pin_controls_set(vmx, vmx_pin_based_exec_ctrl(vmx));
>  	if (cpu_has_secondary_exec_ctrls()) {
>  		if (kvm_vcpu_apicv_active(vcpu))
> -			vmcs_set_bits(SECONDARY_VM_EXEC_CONTROL,
> +			sec_exec_controls_setbit(vmx,
>  				      SECONDARY_EXEC_APIC_REGISTER_VIRT |
>  				      SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
>  		else
> -			vmcs_clear_bits(SECONDARY_VM_EXEC_CONTROL,
> +			sec_exec_controls_clearbit(vmx,
>  					SECONDARY_EXEC_APIC_REGISTER_VIRT |
>  					SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
>  	}
> @@ -4020,8 +4020,7 @@ static void vmx_vcpu_setup(struct vcpu_vmx *vmx)
>  
>  	if (cpu_has_secondary_exec_ctrls()) {
>  		vmx_compute_secondary_exec_control(vmx);
> -		vmcs_write32(SECONDARY_VM_EXEC_CONTROL,
> -			     vmx->secondary_exec_control);
> +		sec_exec_controls_init(vmx, vmx->secondary_exec_control);
>  	}
>  
>  	if (kvm_vcpu_apicv_active(&vmx->vcpu)) {
> @@ -5935,6 +5934,7 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
>  
>  void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
>  {
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	u32 sec_exec_control;
>  
>  	if (!lapic_in_kernel(vcpu))
> @@ -5946,11 +5946,11 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
>  
>  	/* Postpone execution until vmcs01 is the current VMCS. */
>  	if (is_guest_mode(vcpu)) {
> -		to_vmx(vcpu)->nested.change_vmcs01_virtual_apic_mode = true;
> +		vmx->nested.change_vmcs01_virtual_apic_mode = true;
>  		return;
>  	}
>  
> -	sec_exec_control = vmcs_read32(SECONDARY_VM_EXEC_CONTROL);
> +	sec_exec_control = sec_exec_controls_get(vmx);
>  	sec_exec_control &= ~(SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES |
>  			      SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE);
>  
> @@ -5972,7 +5972,7 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
>  				SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE;
>  		break;
>  	}
> -	vmcs_write32(SECONDARY_VM_EXEC_CONTROL, sec_exec_control);
> +	sec_exec_controls_set(vmx, sec_exec_control);
>  
>  	vmx_update_msr_bitmap(vcpu);
>  }
> @@ -6776,7 +6776,7 @@ static int vmx_get_lpage_level(void)
>  		return PT_PDPE_LEVEL;
>  }
>  
> -static void vmcs_set_secondary_exec_control(u32 new_ctl)
> +static void vmcs_set_secondary_exec_control(struct vcpu_vmx *vmx)
>  {
>  	/*
>  	 * These bits in the secondary execution controls field
> @@ -6790,10 +6790,10 @@ static void vmcs_set_secondary_exec_control(u32 new_ctl)
>  		SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES |
>  		SECONDARY_EXEC_DESC;
>  
> -	u32 cur_ctl = vmcs_read32(SECONDARY_VM_EXEC_CONTROL);
> +	u32 new_ctl = vmx->secondary_exec_control;
> +	u32 cur_ctl = sec_exec_controls_get(vmx);
>  
> -	vmcs_write32(SECONDARY_VM_EXEC_CONTROL,
> -		     (new_ctl & ~mask) | (cur_ctl & mask));
> +	sec_exec_controls_set(vmx, (new_ctl & ~mask) | (cur_ctl & mask));
>  }
>  
>  /*
> @@ -6955,7 +6955,7 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
>  
>  	if (cpu_has_secondary_exec_ctrls()) {
>  		vmx_compute_secondary_exec_control(vmx);
> -		vmcs_set_secondary_exec_control(vmx->secondary_exec_control);
> +		vmcs_set_secondary_exec_control(vmx);
>  	}
>  
>  	if (nested_vmx_allowed(vcpu))
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 673cab3f6f66..7655ed28f12c 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -90,6 +90,7 @@ struct vmx_controls_shadow {
>  	u32 vm_exit;
>  	u32 pin;
>  	u32 exec;
> +	u32 sec_exec;
>  };
>  
>  /*
> @@ -414,6 +415,7 @@ BUILD_CONTROLS_SHADOW(vm_entry, VM_ENTRY_CONTROLS)
>  BUILD_CONTROLS_SHADOW(vm_exit, VM_EXIT_CONTROLS)
>  BUILD_CONTROLS_SHADOW(pin, PIN_BASED_VM_EXEC_CONTROL)
>  BUILD_CONTROLS_SHADOW(exec, CPU_BASED_VM_EXEC_CONTROL)
> +BUILD_CONTROLS_SHADOW(sec_exec, SECONDARY_VM_EXEC_CONTROL)
>  
>  static inline void vmx_segment_cache_clear(struct vcpu_vmx *vmx)
>  {
> 

