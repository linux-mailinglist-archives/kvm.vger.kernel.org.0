Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 189182ED67C
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 19:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728814AbhAGSPC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 13:15:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42445 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726073AbhAGSPB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Jan 2021 13:15:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610043213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IWg+Dy8bMmg6eRxlaM9RZlMkMk/A1C/4W7WbWPrcins=;
        b=U+bgDu7q7b8oMR/OegrQ8KbEsrmVi3bn+VfzL3ZUYrRLgUQZi5rvG8snP9Ct3THQN4j116
        z9GY219McSzZH8oyMnqeDWa1LTxL7eTz00IwhwK3mWMXISDSYpKqmlPuFCDHKZ7C6oB2U5
        j3VYOngApI3m8RiiwN8GYBlRPst0yzk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-jsSFKNrSN5qXLWv-Cq7Kqg-1; Thu, 07 Jan 2021 13:13:30 -0500
X-MC-Unique: jsSFKNrSN5qXLWv-Cq7Kqg-1
Received: by mail-wr1-f70.google.com with SMTP id r8so2959292wro.22
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 10:13:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IWg+Dy8bMmg6eRxlaM9RZlMkMk/A1C/4W7WbWPrcins=;
        b=tVFWGjFzXPPjtmZR+g+UMpo04ij75tnMgQTMPYy2cD9/WjpkU75PX/2BPZHVQpSM08
         eTkfyBMAZh8vXrnpCbM0UWZdVSPNXIlUU/WzkNYlEnUlqLR0Ou3P7Qo2jEe5Hk0EE9v+
         6tCtZ4DwcHFzWvDZ/NzkeSNG+bHIgDaW+HaMPz4D1aomH+IX8msnwlXxMIARkweYrZq3
         b70K3N99S3MEgh9eSZk2HG3b0CATrbUYRsqRPRIg2w7J0bH5mseUEUAOZ+6VozttOCLV
         m0eUvWBWGUowjifPDVg67gzNr38UGgAJa7YzQohPPIkGN1fd7qPZpqtLfqoN4y+nNsVD
         CZDA==
X-Gm-Message-State: AOAM532U/p3xr5+G8r2eXF6LvYRKnItq7SSYCJCYFO5Lg3XydrG5y86B
        ZCopxkLwFbh8aWW5iKA8XpGrD5QqlM15yQtOxksI8d6A6UeH/QvIfg1pxAO7FgqM7YcP37tnFz1
        a531UAnMFsfGT
X-Received: by 2002:adf:d20b:: with SMTP id j11mr9861864wrh.318.1610043208938;
        Thu, 07 Jan 2021 10:13:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzTpkjaIZH9VZWvuE5Oqm+3xD3DoFiXeTf+mQn/EFflP8vIZnKknaRW5rcjMj6lM0P7luiPsg==
X-Received: by 2002:adf:d20b:: with SMTP id j11mr9861846wrh.318.1610043208669;
        Thu, 07 Jan 2021 10:13:28 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id a17sm9854175wrs.20.2021.01.07.10.13.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jan 2021 10:13:27 -0800 (PST)
Subject: Re: [PATCH v5.1 27/34] KVM: SVM: Add support for booting APs in an
 SEV-ES guest
To:     Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <47d11ed1c1a48ab71858fc3cde766bf67a4612d1.1607620209.git.thomas.lendacky@amd.com>
 <e8fbebe8eb161ceaabdad7c01a5859a78b424d5e.1609791600.git.thomas.lendacky@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f7df25ab-0a2c-7295-05c9-dcc6e1878b9c@redhat.com>
Date:   Thu, 7 Jan 2021 19:13:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <e8fbebe8eb161ceaabdad7c01a5859a78b424d5e.1609791600.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/01/21 21:20, Tom Lendacky wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> Typically under KVM, an AP is booted using the INIT-SIPI-SIPI sequence,
> where the guest vCPU register state is updated and then the vCPU is VMRUN
> to begin execution of the AP. For an SEV-ES guest, this won't work because
> the guest register state is encrypted.
> 
> Following the GHCB specification, the hypervisor must not alter the guest
> register state, so KVM must track an AP/vCPU boot. Should the guest want
> to park the AP, it must use the AP Reset Hold exit event in place of, for
> example, a HLT loop.
> 
> First AP boot (first INIT-SIPI-SIPI sequence):
>    Execute the AP (vCPU) as it was initialized and measured by the SEV-ES
>    support. It is up to the guest to transfer control of the AP to the
>    proper location.
> 
> Subsequent AP boot:
>    KVM will expect to receive an AP Reset Hold exit event indicating that
>    the vCPU is being parked and will require an INIT-SIPI-SIPI sequence to
>    awaken it. When the AP Reset Hold exit event is received, KVM will place
>    the vCPU into a simulated HLT mode. Upon receiving the INIT-SIPI-SIPI
>    sequence, KVM will make the vCPU runnable. It is again up to the guest
>    to then transfer control of the AP to the proper location.
> 
>    To differentiate between an actual HLT and an AP Reset Hold, a new MP
>    state is introduced, KVM_MP_STATE_AP_RESET_HOLD, which the vCPU is
>    placed in upon receiving the AP Reset Hold exit event. Additionally, to
>    communicate the AP Reset Hold exit event up to userspace (if needed), a
>    new exit reason is introduced, KVM_EXIT_AP_RESET_HOLD.
> 
> A new x86 ops function is introduced, vcpu_deliver_sipi_vector, in order
> to accomplish AP booting. For VMX, vcpu_deliver_sipi_vector is set to the
> original SIPI delivery function, kvm_vcpu_deliver_sipi_vector(). SVM adds
> a new function that, for non SEV-ES guests, invokes the original SIPI
> delivery function, kvm_vcpu_deliver_sipi_vector(), but for SEV-ES guests,
> implements the logic above.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

Queued, thanks.

Paolo

> ---
>   arch/x86/include/asm/kvm_host.h |  3 +++
>   arch/x86/kvm/lapic.c            |  2 +-
>   arch/x86/kvm/svm/sev.c          | 22 ++++++++++++++++++++++
>   arch/x86/kvm/svm/svm.c          | 10 ++++++++++
>   arch/x86/kvm/svm/svm.h          |  2 ++
>   arch/x86/kvm/vmx/vmx.c          |  2 ++
>   arch/x86/kvm/x86.c              | 26 +++++++++++++++++++++-----
>   include/uapi/linux/kvm.h        |  2 ++
>   8 files changed, 63 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 39707e72b062..23d7b203c060 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1287,6 +1287,8 @@ struct kvm_x86_ops {
>   	void (*migrate_timers)(struct kvm_vcpu *vcpu);
>   	void (*msr_filter_changed)(struct kvm_vcpu *vcpu);
>   	int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
> +
> +	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
>   };
>   
>   struct kvm_x86_nested_ops {
> @@ -1468,6 +1470,7 @@ int kvm_fast_pio(struct kvm_vcpu *vcpu, int size, unsigned short port, int in);
>   int kvm_emulate_cpuid(struct kvm_vcpu *vcpu);
>   int kvm_emulate_halt(struct kvm_vcpu *vcpu);
>   int kvm_vcpu_halt(struct kvm_vcpu *vcpu);
> +int kvm_emulate_ap_reset_hold(struct kvm_vcpu *vcpu);
>   int kvm_emulate_wbinvd(struct kvm_vcpu *vcpu);
>   
>   void kvm_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 6a87623aa578..a2f08ed777d8 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2898,7 +2898,7 @@ void kvm_apic_accept_events(struct kvm_vcpu *vcpu)
>   			/* evaluate pending_events before reading the vector */
>   			smp_rmb();
>   			sipi_vector = apic->sipi_vector;
> -			kvm_vcpu_deliver_sipi_vector(vcpu, sipi_vector);
> +			kvm_x86_ops.vcpu_deliver_sipi_vector(vcpu, sipi_vector);
>   			vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
>   		}
>   	}
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index e57847ff8bd2..a08cbc04cb4d 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1563,6 +1563,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
>   			goto vmgexit_err;
>   		break;
>   	case SVM_VMGEXIT_NMI_COMPLETE:
> +	case SVM_VMGEXIT_AP_HLT_LOOP:
>   	case SVM_VMGEXIT_AP_JUMP_TABLE:
>   	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
>   		break;
> @@ -1888,6 +1889,9 @@ int sev_handle_vmgexit(struct vcpu_svm *svm)
>   	case SVM_VMGEXIT_NMI_COMPLETE:
>   		ret = svm_invoke_exit_handler(svm, SVM_EXIT_IRET);
>   		break;
> +	case SVM_VMGEXIT_AP_HLT_LOOP:
> +		ret = kvm_emulate_ap_reset_hold(&svm->vcpu);
> +		break;
>   	case SVM_VMGEXIT_AP_JUMP_TABLE: {
>   		struct kvm_sev_info *sev = &to_kvm_svm(svm->vcpu.kvm)->sev_info;
>   
> @@ -2040,3 +2044,21 @@ void sev_es_vcpu_put(struct vcpu_svm *svm)
>   		wrmsrl(host_save_user_msrs[i].index, svm->host_user_msrs[i]);
>   	}
>   }
> +
> +void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +
> +	/* First SIPI: Use the values as initially set by the VMM */
> +	if (!svm->received_first_sipi) {
> +		svm->received_first_sipi = true;
> +		return;
> +	}
> +
> +	/*
> +	 * Subsequent SIPI: Return from an AP Reset Hold VMGEXIT, where
> +	 * the guest will set the CS and RIP. Set SW_EXIT_INFO_2 to a
> +	 * non-zero value.
> +	 */
> +	ghcb_set_sw_exit_info_2(svm->ghcb, 1);
> +}
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 941e5251e13f..5c37fa68ee56 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4382,6 +4382,14 @@ static bool svm_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
>   		   (vmcb_is_intercept(&svm->vmcb->control, INTERCEPT_INIT));
>   }
>   
> +static void svm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
> +{
> +	if (!sev_es_guest(vcpu->kvm))
> +		return kvm_vcpu_deliver_sipi_vector(vcpu, vector);
> +
> +	sev_vcpu_deliver_sipi_vector(vcpu, vector);
> +}
> +
>   static void svm_vm_destroy(struct kvm *kvm)
>   {
>   	avic_vm_destroy(kvm);
> @@ -4524,6 +4532,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>   
>   	.msr_filter_changed = svm_msr_filter_changed,
>   	.complete_emulated_msr = svm_complete_emulated_msr,
> +
> +	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
>   };
>   
>   static struct kvm_x86_init_ops svm_init_ops __initdata = {
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 5431e6335e2e..0fe874ae5498 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -185,6 +185,7 @@ struct vcpu_svm {
>   	struct vmcb_save_area *vmsa;
>   	struct ghcb *ghcb;
>   	struct kvm_host_map ghcb_map;
> +	bool received_first_sipi;
>   
>   	/* SEV-ES scratch area support */
>   	void *ghcb_sa;
> @@ -591,6 +592,7 @@ void sev_es_init_vmcb(struct vcpu_svm *svm);
>   void sev_es_create_vcpu(struct vcpu_svm *svm);
>   void sev_es_vcpu_load(struct vcpu_svm *svm, int cpu);
>   void sev_es_vcpu_put(struct vcpu_svm *svm);
> +void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
>   
>   /* vmenter.S */
>   
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 75c9c6a0a3a4..2af05d3b0590 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7707,6 +7707,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
>   	.msr_filter_changed = vmx_msr_filter_changed,
>   	.complete_emulated_msr = kvm_complete_insn_gp,
>   	.cpu_dirty_log_size = vmx_cpu_dirty_log_size,
> +
> +	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
>   };
>   
>   static __init int hardware_setup(void)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 648c677b12e9..660683a70b79 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7974,17 +7974,22 @@ void kvm_arch_exit(void)
>   	kmem_cache_destroy(x86_fpu_cache);
>   }
>   
> -int kvm_vcpu_halt(struct kvm_vcpu *vcpu)
> +int __kvm_vcpu_halt(struct kvm_vcpu *vcpu, int state, int reason)
>   {
>   	++vcpu->stat.halt_exits;
>   	if (lapic_in_kernel(vcpu)) {
> -		vcpu->arch.mp_state = KVM_MP_STATE_HALTED;
> +		vcpu->arch.mp_state = state;
>   		return 1;
>   	} else {
> -		vcpu->run->exit_reason = KVM_EXIT_HLT;
> +		vcpu->run->exit_reason = reason;
>   		return 0;
>   	}
>   }
> +
> +int kvm_vcpu_halt(struct kvm_vcpu *vcpu)
> +{
> +	return __kvm_vcpu_halt(vcpu, KVM_MP_STATE_HALTED, KVM_EXIT_HLT);
> +}
>   EXPORT_SYMBOL_GPL(kvm_vcpu_halt);
>   
>   int kvm_emulate_halt(struct kvm_vcpu *vcpu)
> @@ -7998,6 +8003,14 @@ int kvm_emulate_halt(struct kvm_vcpu *vcpu)
>   }
>   EXPORT_SYMBOL_GPL(kvm_emulate_halt);
>   
> +int kvm_emulate_ap_reset_hold(struct kvm_vcpu *vcpu)
> +{
> +	int ret = kvm_skip_emulated_instruction(vcpu);
> +
> +	return __kvm_vcpu_halt(vcpu, KVM_MP_STATE_AP_RESET_HOLD, KVM_EXIT_AP_RESET_HOLD) && ret;
> +}
> +EXPORT_SYMBOL_GPL(kvm_emulate_ap_reset_hold);
> +
>   #ifdef CONFIG_X86_64
>   static int kvm_pv_clock_pairing(struct kvm_vcpu *vcpu, gpa_t paddr,
>   			        unsigned long clock_type)
> @@ -9092,6 +9105,7 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
>   	kvm_apic_accept_events(vcpu);
>   	switch(vcpu->arch.mp_state) {
>   	case KVM_MP_STATE_HALTED:
> +	case KVM_MP_STATE_AP_RESET_HOLD:
>   		vcpu->arch.pv.pv_unhalted = false;
>   		vcpu->arch.mp_state =
>   			KVM_MP_STATE_RUNNABLE;
> @@ -9518,8 +9532,9 @@ int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
>   		kvm_load_guest_fpu(vcpu);
>   
>   	kvm_apic_accept_events(vcpu);
> -	if (vcpu->arch.mp_state == KVM_MP_STATE_HALTED &&
> -					vcpu->arch.pv.pv_unhalted)
> +	if ((vcpu->arch.mp_state == KVM_MP_STATE_HALTED ||
> +	     vcpu->arch.mp_state == KVM_MP_STATE_AP_RESET_HOLD) &&
> +	    vcpu->arch.pv.pv_unhalted)
>   		mp_state->mp_state = KVM_MP_STATE_RUNNABLE;
>   	else
>   		mp_state->mp_state = vcpu->arch.mp_state;
> @@ -10150,6 +10165,7 @@ void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
>   	kvm_set_segment(vcpu, &cs, VCPU_SREG_CS);
>   	kvm_rip_write(vcpu, 0);
>   }
> +EXPORT_SYMBOL_GPL(kvm_vcpu_deliver_sipi_vector);
>   
>   int kvm_arch_hardware_enable(void)
>   {
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 886802b8ffba..374c67875cdb 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -251,6 +251,7 @@ struct kvm_hyperv_exit {
>   #define KVM_EXIT_X86_RDMSR        29
>   #define KVM_EXIT_X86_WRMSR        30
>   #define KVM_EXIT_DIRTY_RING_FULL  31
> +#define KVM_EXIT_AP_RESET_HOLD    32
>   
>   /* For KVM_EXIT_INTERNAL_ERROR */
>   /* Emulate instruction failed. */
> @@ -573,6 +574,7 @@ struct kvm_vapic_addr {
>   #define KVM_MP_STATE_CHECK_STOP        6
>   #define KVM_MP_STATE_OPERATING         7
>   #define KVM_MP_STATE_LOAD              8
> +#define KVM_MP_STATE_AP_RESET_HOLD     9
>   
>   struct kvm_mp_state {
>   	__u32 mp_state;
> 

