Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 520492D9BB8
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 17:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbgLNQEp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 11:04:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46128 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2439518AbgLNQEf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Dec 2020 11:04:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607961787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jWacN7wf0pjio/Reitp1z+b7lbzmf3F10vxMXqZSb7s=;
        b=Knuy75BJGaxUFULun58Fid0wsogeIhUlo6TZyP/iNwzGy372dEPac16cC1O2/EOFSlIqQQ
        PtG3+22jlvzsPfDo7luR/9siyjE8UmliT70KaFSwYSSexmZRylpE8eII95Kd/MvDisY+aq
        yollOFKv92W18NkKMGAZ0UdI8k4dJss=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-430-EFP-vqyOMIaMZdv4hs4Sbw-1; Mon, 14 Dec 2020 11:03:05 -0500
X-MC-Unique: EFP-vqyOMIaMZdv4hs4Sbw-1
Received: by mail-ed1-f71.google.com with SMTP id c24so8487219edx.2
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 08:03:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jWacN7wf0pjio/Reitp1z+b7lbzmf3F10vxMXqZSb7s=;
        b=LrgMuqQkcJdJpUInfqZETCTndygaxXGiCvQCAuLnML9HqVYtDPYvVJc7udiDWVYa3c
         07oOe3lCtxMGcnzHVMbtknaVgqU7rQ4BpOgF3K6W6w3obodHqc+rM/ax/fNcdE8Suv1J
         RJ9+RM78INZSMSg3g6MAA9RQAGf77cL0F4hOtAu4eq6llEPvrc3g+P72SwYtUVdwSme3
         EoI4+5huQWkWV4uWerQtXSDJvQtt7Y3xmCIwLOkstzL/jqtfANMfq6fP0voaweQgS6Ge
         5PeTBAN9C77Ck34dUZ9wpN3UBfbZW8YcJ1lGvmBStS3Jwcgjv28fFmHzupvgYCTXmNKa
         Zqpg==
X-Gm-Message-State: AOAM533KyhAE/v17+p9ZVvLTe2TkjV8CPd9YVdiIEMSgcAueI0pOtSu5
        X8vC9zZ28aZH/IxJ0tCNZoJFtq439sn01KWS60jcE/IPI90jUTGINWkJcu8MSY0ch+9rGIQLYXy
        lgD65A+StMFm2
X-Received: by 2002:a17:906:34c3:: with SMTP id h3mr2128676ejb.132.1607961783459;
        Mon, 14 Dec 2020 08:03:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzj8F+e4+bl46aJRkFRx+Ha/R+a8zbCZnWePk/TWRyfAkJm5pyRLcQ8QVAmKE7i7F3koe0APg==
X-Received: by 2002:a17:906:34c3:: with SMTP id h3mr2128646ejb.132.1607961783165;
        Mon, 14 Dec 2020 08:03:03 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id ng1sm13912531ejb.112.2020.12.14.08.03.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Dec 2020 08:03:01 -0800 (PST)
Subject: Re: [PATCH v5 27/34] KVM: SVM: Add support for booting APs for an
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
References: <cover.1607620209.git.thomas.lendacky@amd.com>
 <47d11ed1c1a48ab71858fc3cde766bf67a4612d1.1607620209.git.thomas.lendacky@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8ed48a0f-d490-d74d-d10a-968b561a4f2e@redhat.com>
Date:   Mon, 14 Dec 2020 17:03:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <47d11ed1c1a48ab71858fc3cde766bf67a4612d1.1607620209.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/12/20 18:10, Tom Lendacky wrote:
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
> The GHCB specification also requires the hypervisor to save the address of
> an AP Jump Table so that, for example, vCPUs that have been parked by UEFI
> can be started by the OS. Provide support for the AP Jump Table set/get
> exit code.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  2 ++
>   arch/x86/kvm/svm/sev.c          | 50 +++++++++++++++++++++++++++++++++
>   arch/x86/kvm/svm/svm.c          |  7 +++++
>   arch/x86/kvm/svm/svm.h          |  3 ++
>   arch/x86/kvm/x86.c              |  9 ++++++
>   5 files changed, 71 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 048b08437c33..60a3b9d33407 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1286,6 +1286,8 @@ struct kvm_x86_ops {
>   
>   	void (*migrate_timers)(struct kvm_vcpu *vcpu);
>   	void (*msr_filter_changed)(struct kvm_vcpu *vcpu);
> +
> +	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
>   };
>   
>   struct kvm_x86_nested_ops {
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index a7531de760b5..b47285384b1f 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -17,6 +17,8 @@
>   #include <linux/processor.h>
>   #include <linux/trace_events.h>
>   
> +#include <asm/trapnr.h>
> +
>   #include "x86.h"
>   #include "svm.h"
>   #include "cpuid.h"
> @@ -1449,6 +1451,8 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
>   		if (!ghcb_sw_scratch_is_valid(ghcb))
>   			goto vmgexit_err;
>   		break;
> +	case SVM_VMGEXIT_AP_HLT_LOOP:
> +	case SVM_VMGEXIT_AP_JUMP_TABLE:
>   	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
>   		break;
>   	default:
> @@ -1770,6 +1774,35 @@ int sev_handle_vmgexit(struct vcpu_svm *svm)
>   					    control->exit_info_2,
>   					    svm->ghcb_sa);
>   		break;
> +	case SVM_VMGEXIT_AP_HLT_LOOP:
> +		svm->ap_hlt_loop = true;

This value needs to be communicated to userspace.  Let's get this right 
from the beginning and use a new KVM_MP_STATE_* value instead (perhaps 
reuse KVM_MP_STATE_STOPPED but for x86 #define it as 
KVM_MP_STATE_AP_HOLD_RECEIVED?).

> @@ -68,6 +68,7 @@ struct kvm_sev_info {
>  	int fd;			/* SEV device fd */
>  	unsigned long pages_locked; /* Number of pages locked */
>  	struct list_head regions_list;  /* List of registered regions */
> +	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */

Do you have any plans for migration of this value?  How does the guest 
ensure that the hypervisor does not screw with it?

Paolo

> +		ret = kvm_emulate_halt(&svm->vcpu);
> +		break;
> +	case SVM_VMGEXIT_AP_JUMP_TABLE: {
> +		struct kvm_sev_info *sev = &to_kvm_svm(svm->vcpu.kvm)->sev_info;
> +
> +		switch (control->exit_info_1) {
> +		case 0:
> +			/* Set AP jump table address */
> +			sev->ap_jump_table = control->exit_info_2;
> +			break;
> +		case 1:
> +			/* Get AP jump table address */
> +			ghcb_set_sw_exit_info_2(ghcb, sev->ap_jump_table);
> +			break;
> +		default:
> +			pr_err("svm: vmgexit: unsupported AP jump table request - exit_info_1=%#llx\n",
> +			       control->exit_info_1);
> +			ghcb_set_sw_exit_info_1(ghcb, 1);
> +			ghcb_set_sw_exit_info_2(ghcb,
> +						X86_TRAP_UD |
> +						SVM_EVTINJ_TYPE_EXEPT |
> +						SVM_EVTINJ_VALID);
> +		}
> +
> +		ret = 1;
> +		break;
> +	}
>   	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
>   		vcpu_unimpl(&svm->vcpu,
>   			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
> @@ -1790,3 +1823,20 @@ int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
>   	return kvm_sev_es_string_io(&svm->vcpu, size, port,
>   				    svm->ghcb_sa, svm->ghcb_sa_len, in);
>   }
> +
> +void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +
> +	/* First SIPI: Use the values as initially set by the VMM */
> +	if (!svm->ap_hlt_loop)
> +		return;
> +
> +	/*
> +	 * Subsequent SIPI: Return from an AP Reset Hold VMGEXIT, where
> +	 * the guest will set the CS and RIP. Set SW_EXIT_INFO_2 to a
> +	 * non-zero value.
> +	 */
> +	ghcb_set_sw_exit_info_2(svm->ghcb, 1);
> +	svm->ap_hlt_loop = false;
> +}
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 8d22ae25a0f8..2dbc20701ef5 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4400,6 +4400,11 @@ static bool svm_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
>   		   (vmcb_is_intercept(&svm->vmcb->control, INTERCEPT_INIT));
>   }
>   
> +static void svm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
> +{
> +	sev_vcpu_deliver_sipi_vector(vcpu, vector);
> +}
> +
>   static void svm_vm_destroy(struct kvm *kvm)
>   {
>   	avic_vm_destroy(kvm);
> @@ -4541,6 +4546,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>   	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
>   
>   	.msr_filter_changed = svm_msr_filter_changed,
> +
> +	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
>   };
>   
>   static struct kvm_x86_init_ops svm_init_ops __initdata = {
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index b3f03dede6ac..5d570d5a6a2c 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -68,6 +68,7 @@ struct kvm_sev_info {
>   	int fd;			/* SEV device fd */
>   	unsigned long pages_locked; /* Number of pages locked */
>   	struct list_head regions_list;  /* List of registered regions */
> +	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
>   };
>   
>   struct kvm_svm {
> @@ -174,6 +175,7 @@ struct vcpu_svm {
>   	struct vmcb_save_area *vmsa;
>   	struct ghcb *ghcb;
>   	struct kvm_host_map ghcb_map;
> +	bool ap_hlt_loop;
>   
>   	/* SEV-ES scratch area support */
>   	void *ghcb_sa;
> @@ -574,5 +576,6 @@ void sev_hardware_teardown(void);
>   void sev_free_vcpu(struct kvm_vcpu *vcpu);
>   int sev_handle_vmgexit(struct vcpu_svm *svm);
>   int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
> +void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
>   
>   #endif
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ddd614a76744..4fd216b61a89 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10144,6 +10144,15 @@ void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
>   {
>   	struct kvm_segment cs;
>   
> +	/*
> +	 * Guests with protected state can't have their state altered by KVM,
> +	 * call the vcpu_deliver_sipi_vector() x86 op for processing.
> +	 */
> +	if (vcpu->arch.guest_state_protected) {
> +		kvm_x86_ops.vcpu_deliver_sipi_vector(vcpu, vector);
> +		return;
> +	}
> +
>   	kvm_get_segment(vcpu, &cs, VCPU_SREG_CS);
>   	cs.selector = vector << 8;
>   	cs.base = vector << 12;
> 

