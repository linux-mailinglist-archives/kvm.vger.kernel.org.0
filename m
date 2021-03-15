Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB4C33C267
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 17:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232906AbhCOQpW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 12:45:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232829AbhCOQpU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 12:45:20 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECF13C06175F
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 09:45:19 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id c17so3356439pfv.12
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 09:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=U/NwnK7GgeCgwti3NMpPAcZaldrKmQoxLdXxuBnx+pQ=;
        b=XuXQHJU+29r3Bb9uaTtrX4ZQ/GP/I5Pc3B5m/VoaUNvdR95LcaDMX2QRlYAMC2jb3l
         Zf4GHE828XKqCTPOBJDNtJg+UdhgIBvvoC/vcFDjFCIn76jz1+4kxhemPwqT5vgDDz0v
         tu+SvZW5Lj2yRW8YVPQmm79p2oXJCjmJYvFsCiYUoeWFEn3UF8OJklB8+McZiZCuQWQ/
         5oSyp7M0A57vMx06+k9ehlh9V4LgSCZdYXV4LM8bhD6KT3ELbbdtZVMRVCKaS5B8Epht
         iExzbTF4sS35hADZ2j3qtuIiG8VdJbydrNad2U5Jnhizm5UoKL9UJ/Lr1VMorkwrx7OD
         JFTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=U/NwnK7GgeCgwti3NMpPAcZaldrKmQoxLdXxuBnx+pQ=;
        b=MjGhzGycU++7/T15QDQIH64yNVgy/vB29BqeqOM0FXrmJp0E/nmQ+vMhgjt1Y+NqNr
         GlZjXzLdih3U8nQpQ2k4GbyaMs234qSYxDFcC8OFyEaR0TN8Nd+bfQoyhm2waUzA2P0v
         KpYgs6/lqXbZCePbdrOnxDuf8Sq4ztAiVaWPxZRfTXhmhRcTMMcq0TIduhfxIoUcluCY
         x/4IwN3Rcox+SREpCvD03znztw7ndhGRJAOZUKvs0WZcFPiNoYe+ebDp2sACXyU6JkiC
         +Bo28OsuSbAjUj47Dw5GS1v3Hjy4XrBP5nPb3Wux2mrkSpeY+iZDgOs0d/f2NaJQsapu
         zlKw==
X-Gm-Message-State: AOAM532KFVtInvdnPp6+L6ACktwTbEQa6f6zxNwc5hDfHpGBT1rIDI0j
        ic9huBuyn20eyS9fsBnKz9EsGhSmszxSiA==
X-Google-Smtp-Source: ABdhPJz7imQ4Wdll8vOKYyrUS5ptYMDeC97IL57XMeJU5ujASZAwWLWC4w1+YBiqJVyQmUZoX+Xvjg==
X-Received: by 2002:a05:6a00:1504:b029:203:6bc9:3f14 with SMTP id q4-20020a056a001504b02902036bc93f14mr11290700pfu.22.1615826719061;
        Mon, 15 Mar 2021 09:45:19 -0700 (PDT)
Received: from google.com ([2620:15c:f:10:3d60:4c70:d756:da57])
        by smtp.gmail.com with ESMTPSA id w26sm7487498pfj.58.2021.03.15.09.45.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 09:45:18 -0700 (PDT)
Date:   Mon, 15 Mar 2021 09:45:11 -0700
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] KVM: nVMX: Sync L2 guest CET states between L1/L2
Message-ID: <YE+PF1zfkZTTgwxn@google.com>
References: <20210315071841.7045-1-weijiang.yang@intel.com>
 <20210315071841.7045-2-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315071841.7045-2-weijiang.yang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 15, 2021, Yang Weijiang wrote:
> These fields are rarely updated by L1 QEMU/KVM, sync them when L1 is trying to
> read/write them and after they're changed. If CET guest entry-load bit is not
> set by L1 guest, migrate them to L2 manaully.
> 
> Opportunistically remove one blank line and add minor fix for MPX.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kvm/cpuid.c      |  1 -
>  arch/x86/kvm/vmx/nested.c | 35 +++++++++++++++++++++++++++++++++--
>  arch/x86/kvm/vmx/vmx.h    |  3 +++
>  3 files changed, 36 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index d191de769093..8692f53b8cd0 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -143,7 +143,6 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
>  		}
>  		vcpu->arch.guest_supported_xss =
>  			(((u64)best->edx << 32) | best->ecx) & supported_xss;
> -

Spurious whitespace deletion.

>  	} else {
>  		vcpu->arch.guest_supported_xss = 0;
>  	}
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 9728efd529a1..57ecd8225568 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2516,6 +2516,13 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
>  	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, vmx->msr_autoload.guest.nr);
>  
>  	set_cr4_guest_host_mask(vmx);
> +
> +	if (kvm_cet_supported() && vmx->nested.nested_run_pending &&
> +	    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE)) {
> +		vmcs_writel(GUEST_SSP, vmcs12->guest_ssp);
> +		vmcs_writel(GUEST_S_CET, vmcs12->guest_s_cet);
> +		vmcs_writel(GUEST_INTR_SSP_TABLE, vmcs12->guest_ssp_tbl);
> +	}
>  }
>  
>  /*
> @@ -2556,6 +2563,15 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>  	if (kvm_mpx_supported() && (!vmx->nested.nested_run_pending ||
>  	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
>  		vmcs_write64(GUEST_BNDCFGS, vmx->nested.vmcs01_guest_bndcfgs);
> +
> +	if (kvm_cet_supported() && (!vmx->nested.nested_run_pending ||
> +	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE))) {

Not your code per se, since this pattern comes from BNDCFGS and DEBUGCTL, but I
don't see how loading vmcs01 state in this combo is correct:

    a. kvm_xxx_supported()              == 1
    b. nested_run_pending               == false
    c. vm_entry_controls.load_xxx_state == true

nested_vmx_enter_non_root_mode() only snapshots vmcs01 if 
vm_entry_controls.load_xxx_state == false, which means the above combo is
loading stale values (or more likely, zeros).

I _think_ nested_vmx_enter_non_root_mode() just needs to snapshot vmcs01 if
nested_run_pending=false.  For migration, if userspace restores MSRs after
KVM_SET_NESTED_STATE, then what's done here is likely irrelevant.  If userspace
restores MSRs before nested state, then vmcs01 will hold the desired value since
setting MSRs would have written the value into vmcs01.

I suspect no one has reported this issue because guests simply don't use MPX,
and up until the recent LBR stuff, KVM effectively zeroed out DEBUGCTL for the
guest.

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 45622e9c4449..4184ff601120 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3298,10 +3298,11 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
        if (likely(!evaluate_pending_interrupts) && kvm_vcpu_apicv_active(vcpu))
                evaluate_pending_interrupts |= vmx_has_apicv_interrupt(vcpu);

-       if (!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS))
+       if (!vmx->nested.nested_run_pending ||
+           !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS))
                vmx->nested.vmcs01_debugctl = vmcs_read64(GUEST_IA32_DEBUGCTL);
-       if (kvm_mpx_supported() &&
-               !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
+       if (kvm_mpx_supported() && (!vmx->nested.nested_run_pending ||
+           !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
                vmx->nested.vmcs01_guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);

        /*


Side topic, all of this code is broken for SMM emulation.  SMI+RSM don't do a
full VM-Exit -> VM-Entry; the CPU forcefully exits non-root, but most state that
is loaded from the VMCS is left untouched.  It's the SMI handler's responsibility
to not enable features, e.g. to not set CR4.CET.  For sane use cases, this
probably doesn't matter as vmcs12 will be configured to context switch state,
but if L1 is doing anything out of the ordinary, SMI+RSM will corrupt state.

E.g. if L1 enables MPX in the guest, does not intercept L2 writes to BNDCFGS,
and does not load BNDCFGS on VM-Entry, then SMI+RSM would corrupt BNDCFGS since
the SMI "exit" would clear BNDCFGS, and the RSM "entry" would load zero.  This
is 100% contrived, and probably doesn't impact real world use cases, but it
still bugs me :-)

> +		vmcs_writel(GUEST_SSP, vmx->nested.vmcs01_guest_ssp);
> +		vmcs_writel(GUEST_S_CET, vmx->nested.vmcs01_guest_s_cet);
> +		vmcs_writel(GUEST_INTR_SSP_TABLE,
> +			    vmx->nested.vmcs01_guest_ssp_tbl);
> +	}
> +
>  	vmx_set_rflags(vcpu, vmcs12->guest_rflags);
>  
>  	/* EXCEPTION_BITMAP and CR0_GUEST_HOST_MASK should basically be the
> @@ -3373,8 +3389,14 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
>  	if (!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS))
>  		vmx->nested.vmcs01_debugctl = vmcs_read64(GUEST_IA32_DEBUGCTL);
>  	if (kvm_mpx_supported() &&
> -		!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
> +	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
>  		vmx->nested.vmcs01_guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
> +	if (kvm_cet_supported() &&
> +	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE)) {
> +		vmx->nested.vmcs01_guest_ssp = vmcs_readl(GUEST_SSP);
> +		vmx->nested.vmcs01_guest_s_cet = vmcs_readl(GUEST_S_CET);
> +		vmx->nested.vmcs01_guest_ssp_tbl = vmcs_readl(GUEST_INTR_SSP_TABLE);
> +	}
>  
>  	/*
>  	 * Overwrite vmcs01.GUEST_CR3 with L1's CR3 if EPT is disabled *and*
> @@ -4001,6 +4023,9 @@ static bool is_vmcs12_ext_field(unsigned long field)
>  	case GUEST_IDTR_BASE:
>  	case GUEST_PENDING_DBG_EXCEPTIONS:
>  	case GUEST_BNDCFGS:
> +	case GUEST_SSP:
> +	case GUEST_INTR_SSP_TABLE:
> +	case GUEST_S_CET:
>  		return true;
>  	default:
>  		break;
> @@ -4050,8 +4075,14 @@ static void sync_vmcs02_to_vmcs12_rare(struct kvm_vcpu *vcpu,
>  	vmcs12->guest_idtr_base = vmcs_readl(GUEST_IDTR_BASE);
>  	vmcs12->guest_pending_dbg_exceptions =
>  		vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS);
> -	if (kvm_mpx_supported())
> +	if (kvm_mpx_supported() && guest_cpuid_has(vcpu, X86_FEATURE_MPX))

Adding the CPUID check for MPX definitely needs to be a separate commit.

>  		vmcs12->guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
> +	if (kvm_cet_supported() && (guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) ||
> +	    guest_cpuid_has(vcpu, X86_FEATURE_IBT))) {
> +		vmcs12->guest_ssp = vmcs_readl(GUEST_SSP);
> +		vmcs12->guest_s_cet = vmcs_readl(GUEST_S_CET);
> +		vmcs12->guest_ssp_tbl = vmcs_readl(GUEST_INTR_SSP_TABLE);
> +	}
>  
>  	vmx->nested.need_sync_vmcs02_to_vmcs12_rare = false;
>  }
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 9d3a557949ac..36dc4fdb0909 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -155,6 +155,9 @@ struct nested_vmx {
>  	/* to migrate it to L2 if VM_ENTRY_LOAD_DEBUG_CONTROLS is off */
>  	u64 vmcs01_debugctl;
>  	u64 vmcs01_guest_bndcfgs;
> +	u64 vmcs01_guest_ssp;
> +	u64 vmcs01_guest_s_cet;
> +	u64 vmcs01_guest_ssp_tbl;
>  
>  	/* to migrate it to L1 if L2 writes to L1's CR8 directly */
>  	int l1_tpr_threshold;
> -- 
> 2.26.2
> 
