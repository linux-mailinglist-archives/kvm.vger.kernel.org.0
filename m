Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACDFD377DA
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 17:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729274AbfFFP3t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 11:29:49 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44370 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727559AbfFFP3t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 11:29:49 -0400
Received: by mail-wr1-f67.google.com with SMTP id b17so1794390wrq.11
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2019 08:29:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mVZ40N7lnN4yCfDLph22nitMuKVnMuyZv0FvrWDBrRs=;
        b=lnuonTihR8fpxR1aS6UvjAl6hErqLunmBd91iglVPwJTADSqajUwJfiYIg4y3bz3cg
         T7VhzHgLXzuZjPsfXiNq0CI/ba9MqISnIuEt5prbpNK+eVV5kmAccoQs33pI+A1fXTzw
         5Klq8LIf4KDbIGNuvLYAWhr9v1wVlxOxTAlH5QhwEPu+0jXIyYg5gJ6ZFB+tGlvY7mjb
         YHp29hteFJL4ykru5c/fNJXCh8KB9HCXeHb04NLhPIFcLgPQRDIstj0jDWVZIA18h+Pr
         bT8v3nAJ1HKynVB+NwVrAoiPa4rkgxZ6OpzLi8yQgYxXZAaHsf2N/HUssRMHRdsLC0eP
         MytA==
X-Gm-Message-State: APjAAAU0PvKdofyURQj4DTg158GNsphOwh8BYRgzXOU5BePPToY1LnyM
        LDF8yRsV7jHkw8yrzYAj5PmJfQ==
X-Google-Smtp-Source: APXvYqytblk+jnOIFKBPikZTxjR4smWrNS0OEQ7sZc7MzsecLhVLEDlkRJzTrvyPbuDxZX7botGvMg==
X-Received: by 2002:adf:dcc2:: with SMTP id x2mr16340525wrm.55.1559834986534;
        Thu, 06 Jun 2019 08:29:46 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id d10sm2737516wrh.91.2019.06.06.08.29.45
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 08:29:46 -0700 (PDT)
Subject: Re: [PATCH 7/7] KVM: nVMX: Sync rarely accessed guest fields only
 when needed
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Liran Alon <liran.alon@oracle.com>
References: <20190507153629.3681-1-sean.j.christopherson@intel.com>
 <20190507153629.3681-8-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9fe9cc16-641a-25ae-6f5c-79da8bbc57f8@redhat.com>
Date:   Thu, 6 Jun 2019 17:29:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190507153629.3681-8-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/05/19 17:36, Sean Christopherson wrote:
> Many guest fields are rarely read (or written) by VMMs, i.e. likely
> aren't accessed between runs of a nested VMCS.  Delay pulling rarely
> accessed guest fields from vmcs02 until they are VMREAD or until vmcs12
> is dirtied.  The latter case is necessary because nested VM-Entry will
> consume all manner of fields when vmcs12 is dirty, e.g. for consistency
> checks.
> 
> Note, an alternative to synchronizing all guest fields on VMREAD would
> be to read *only* the field being accessed, but switching VMCS pointers
> is expensive and odds are good if one guest field is being accessed then
> others will soon follow, or that vmcs12 will be dirtied due to a VMWRITE
> (see above).  And the full synchronization results in slightly cleaner
> code.
> 
> Note, although GUEST_PDPTRs are relevant only for a 32-bit PAE guest,
> they are accessed quite frequently for said guests, and a separate patch
> is in flight to optimize away GUEST_PDTPR synchronziation for non-PAE
> guests.
> 
> Skipping rarely accessed guest fields reduces the latency of a nested
> VM-Exit by ~200 cycles.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Just some naming improvements to be made here:

- __sync_vmcs02_to_vmcs12_ext -> sync_vmcs02_to_vmcs12_extra

- sync_vmcs02_to_vmcs12_ext -> copy_vmcs02_to_vmcs12_extra (copy functions
take care of vmptrld/vmclear; sync functions don't!)

- need_vmcs02_to_vmcs12_ext_sync -> need_sync_vmcs02_to_vmcs12_extra

and with this change, this follow-up becomes obvious:

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index fd8150ef6cce..b3249d071202 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3464,6 +3464,8 @@ static void __sync_vmcs02_to_vmcs12_ext(struct kvm_vcpu *vcpu,
 		vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS);
 	if (kvm_mpx_supported())
 		vmcs12->guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
+
+	vmx->nested.need_sync_vmcs02_to_vmcs12_extra = false;
 }
 
 static void sync_vmcs02_to_vmcs12_ext(struct kvm_vcpu *vcpu,
@@ -3487,8 +3489,6 @@ static void sync_vmcs02_to_vmcs12_ext(struct kvm_vcpu *vcpu,
 	vmx->loaded_vmcs = &vmx->vmcs01;
 	vmx_vcpu_load(&vmx->vcpu, cpu);
 	put_cpu();
-
-	vmx->nested.need_vmcs02_to_vmcs12_ext_sync = false;
 }
 
 /*

Paolo

> ---
>  arch/x86/kvm/vmx/nested.c | 140 ++++++++++++++++++++++++++++++++------
>  arch/x86/kvm/vmx/vmx.h    |   6 ++
>  2 files changed, 125 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 279961a63db2..0ff85c88e2eb 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3373,21 +3373,56 @@ static u32 vmx_get_preemption_timer_value(struct kvm_vcpu *vcpu)
>  	return value >> VMX_MISC_EMULATED_PREEMPTION_TIMER_RATE;
>  }
>  
> -/*
> - * Update the guest state fields of vmcs12 to reflect changes that
> - * occurred while L2 was running. (The "IA-32e mode guest" bit of the
> - * VM-entry controls is also updated, since this is really a guest
> - * state bit.)
> - */
> -static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
> +static bool is_vmcs12_ext_field(unsigned long field)
>  {
> -	vmcs12->guest_cr0 = vmcs12_guest_cr0(vcpu, vmcs12);
> -	vmcs12->guest_cr4 = vmcs12_guest_cr4(vcpu, vmcs12);
> +	switch (field) {
> +	case GUEST_ES_SELECTOR:
> +	case GUEST_CS_SELECTOR:
> +	case GUEST_SS_SELECTOR:
> +	case GUEST_DS_SELECTOR:
> +	case GUEST_FS_SELECTOR:
> +	case GUEST_GS_SELECTOR:
> +	case GUEST_LDTR_SELECTOR:
> +	case GUEST_TR_SELECTOR:
> +	case GUEST_ES_LIMIT:
> +	case GUEST_CS_LIMIT:
> +	case GUEST_SS_LIMIT:
> +	case GUEST_DS_LIMIT:
> +	case GUEST_FS_LIMIT:
> +	case GUEST_GS_LIMIT:
> +	case GUEST_LDTR_LIMIT:
> +	case GUEST_TR_LIMIT:
> +	case GUEST_GDTR_LIMIT:
> +	case GUEST_IDTR_LIMIT:
> +	case GUEST_ES_AR_BYTES:
> +	case GUEST_DS_AR_BYTES:
> +	case GUEST_FS_AR_BYTES:
> +	case GUEST_GS_AR_BYTES:
> +	case GUEST_LDTR_AR_BYTES:
> +	case GUEST_TR_AR_BYTES:
> +	case GUEST_ES_BASE:
> +	case GUEST_CS_BASE:
> +	case GUEST_SS_BASE:
> +	case GUEST_DS_BASE:
> +	case GUEST_FS_BASE:
> +	case GUEST_GS_BASE:
> +	case GUEST_LDTR_BASE:
> +	case GUEST_TR_BASE:
> +	case GUEST_GDTR_BASE:
> +	case GUEST_IDTR_BASE:
> +	case GUEST_PENDING_DBG_EXCEPTIONS:
> +	case GUEST_BNDCFGS:
> +		return true;
> +	default:
> +		break;
> +	}
>  
> -	vmcs12->guest_rsp = kvm_rsp_read(vcpu);
> -	vmcs12->guest_rip = kvm_rip_read(vcpu);
> -	vmcs12->guest_rflags = vmcs_readl(GUEST_RFLAGS);
> +	return false;
> +}
>  
> +static void __sync_vmcs02_to_vmcs12_ext(struct kvm_vcpu *vcpu,
> +					struct vmcs12 *vmcs12)
> +{
>  	vmcs12->guest_es_selector = vmcs_read16(GUEST_ES_SELECTOR);
>  	vmcs12->guest_cs_selector = vmcs_read16(GUEST_CS_SELECTOR);
>  	vmcs12->guest_ss_selector = vmcs_read16(GUEST_SS_SELECTOR);
> @@ -3407,8 +3442,6 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
>  	vmcs12->guest_gdtr_limit = vmcs_read32(GUEST_GDTR_LIMIT);
>  	vmcs12->guest_idtr_limit = vmcs_read32(GUEST_IDTR_LIMIT);
>  	vmcs12->guest_es_ar_bytes = vmcs_read32(GUEST_ES_AR_BYTES);
> -	vmcs12->guest_cs_ar_bytes = vmcs_read32(GUEST_CS_AR_BYTES);
> -	vmcs12->guest_ss_ar_bytes = vmcs_read32(GUEST_SS_AR_BYTES);
>  	vmcs12->guest_ds_ar_bytes = vmcs_read32(GUEST_DS_AR_BYTES);
>  	vmcs12->guest_fs_ar_bytes = vmcs_read32(GUEST_FS_AR_BYTES);
>  	vmcs12->guest_gs_ar_bytes = vmcs_read32(GUEST_GS_AR_BYTES);
> @@ -3424,11 +3457,65 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
>  	vmcs12->guest_tr_base = vmcs_readl(GUEST_TR_BASE);
>  	vmcs12->guest_gdtr_base = vmcs_readl(GUEST_GDTR_BASE);
>  	vmcs12->guest_idtr_base = vmcs_readl(GUEST_IDTR_BASE);
> -
> -	vmcs12->guest_interruptibility_info =
> -		vmcs_read32(GUEST_INTERRUPTIBILITY_INFO);
>  	vmcs12->guest_pending_dbg_exceptions =
>  		vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS);
> +	if (kvm_mpx_supported())
> +		vmcs12->guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
> +}
> +
> +static void sync_vmcs02_to_vmcs12_ext(struct kvm_vcpu *vcpu,
> +				      struct vmcs12 *vmcs12)
> +{
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +	int cpu;
> +
> +	if (!vmx->nested.need_vmcs02_to_vmcs12_ext_sync)
> +		return;
> +
> +
> +	WARN_ON_ONCE(vmx->loaded_vmcs != &vmx->vmcs01);
> +
> +	cpu = get_cpu();
> +	vmx->loaded_vmcs = &vmx->nested.vmcs02;
> +	vmx_vcpu_load(&vmx->vcpu, cpu);
> +
> +	__sync_vmcs02_to_vmcs12_ext(vcpu, vmcs12);
> +
> +	vmx->loaded_vmcs = &vmx->vmcs01;
> +	vmx_vcpu_load(&vmx->vcpu, cpu);
> +	put_cpu();
> +
> +	vmx->nested.need_vmcs02_to_vmcs12_ext_sync = false;
> +}
> +
> +/*
> + * Update the guest state fields of vmcs12 to reflect changes that
> + * occurred while L2 was running. (The "IA-32e mode guest" bit of the
> + * VM-entry controls is also updated, since this is really a guest
> + * state bit.)
> + */
> +static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
> +{
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +
> +	if (vmx->nested.hv_evmcs)
> +		__sync_vmcs02_to_vmcs12_ext(vcpu, vmcs12);
> +
> +	vmx->nested.need_vmcs02_to_vmcs12_ext_sync = !vmx->nested.hv_evmcs;
> +
> +	vmcs12->guest_cr0 = vmcs12_guest_cr0(vcpu, vmcs12);
> +	vmcs12->guest_cr4 = vmcs12_guest_cr4(vcpu, vmcs12);
> +
> +	vmcs12->guest_rsp = kvm_rsp_read(vcpu);
> +	vmcs12->guest_rip = kvm_rip_read(vcpu);
> +	vmcs12->guest_rflags = vmcs_readl(GUEST_RFLAGS);
> +
> +	vmcs12->guest_cs_ar_bytes = vmcs_read32(GUEST_CS_AR_BYTES);
> +	vmcs12->guest_ss_ar_bytes = vmcs_read32(GUEST_SS_AR_BYTES);
> +
> +	vmcs12->guest_interruptibility_info =
> +		vmcs_read32(GUEST_INTERRUPTIBILITY_INFO);
> +
>  	if (vcpu->arch.mp_state == KVM_MP_STATE_HALTED)
>  		vmcs12->guest_activity_state = GUEST_ACTIVITY_HLT;
>  	else
> @@ -3478,8 +3565,6 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
>  	vmcs12->guest_sysenter_cs = vmcs_read32(GUEST_SYSENTER_CS);
>  	vmcs12->guest_sysenter_esp = vmcs_readl(GUEST_SYSENTER_ESP);
>  	vmcs12->guest_sysenter_eip = vmcs_readl(GUEST_SYSENTER_EIP);
> -	if (kvm_mpx_supported())
> -		vmcs12->guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
>  }
>  
>  /*
> @@ -4276,6 +4361,8 @@ static inline void nested_release_vmcs12(struct kvm_vcpu *vcpu)
>  	if (vmx->nested.current_vmptr == -1ull)
>  		return;
>  
> +	sync_vmcs02_to_vmcs12_ext(vcpu, get_vmcs12(vcpu));
> +
>  	if (enable_shadow_vmcs) {
>  		/* copy to memory all shadowed fields in case
>  		   they were modified */
> @@ -4392,6 +4479,9 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
>  		return nested_vmx_failValid(vcpu,
>  			VMXERR_UNSUPPORTED_VMCS_COMPONENT);
>  
> +	if (!is_guest_mode(vcpu) && is_vmcs12_ext_field(field))
> +		sync_vmcs02_to_vmcs12_ext(vcpu, vmcs12);
> +
>  	/* Read the field, zero-extended to a u64 field_value */
>  	field_value = vmcs12_read_any(vmcs12, field, offset);
>  
> @@ -4489,9 +4579,16 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
>  		return nested_vmx_failValid(vcpu,
>  			VMXERR_VMWRITE_READ_ONLY_VMCS_COMPONENT);
>  
> -	if (!is_guest_mode(vcpu))
> +	if (!is_guest_mode(vcpu)) {
>  		vmcs12 = get_vmcs12(vcpu);
> -	else {
> +
> +		/*
> +		 * Ensure vmcs12 is up-to-date before any VMWRITE that dirties
> +		 * vmcs12, else we may crush a field or consume a stale value.
> +		 */
> +		if (!is_shadow_field_rw(field))
> +			sync_vmcs02_to_vmcs12_ext(vcpu, vmcs12);
> +	} else {
>  		/*
>  		 * When vmcs->vmcs_link_pointer is -1ull, any VMWRITE
>  		 * to shadowed-field sets the ALU flags for VMfailInvalid.
> @@ -5310,6 +5407,7 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
>  	 */
>  	if (is_guest_mode(vcpu)) {
>  		sync_vmcs02_to_vmcs12(vcpu, vmcs12);
> +		__sync_vmcs02_to_vmcs12_ext(vcpu, vmcs12);
>  	} else if (!vmx->nested.need_vmcs12_to_shadow_sync) {
>  		if (vmx->nested.hv_evmcs)
>  			copy_enlightened_to_vmcs12(vmx);
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 16210dde0374..8b215c6840b4 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -123,6 +123,12 @@ struct nested_vmx {
>  	 */
>  	bool vmcs02_initialized;
>  
> +	/*
> +	 * Indicates lazily loaded guest state has not yet been decached from
> +	 * vmcs02.
> +	 */
> +	bool need_vmcs02_to_vmcs12_ext_sync;
> +
>  	bool change_vmcs01_virtual_apic_mode;
>  
>  	/*
> 

