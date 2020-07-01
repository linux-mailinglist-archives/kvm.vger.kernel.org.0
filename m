Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C77A21075E
	for <lists+kvm@lfdr.de>; Wed,  1 Jul 2020 11:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbgGAJE3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jul 2020 05:04:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32718 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726129AbgGAJE3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jul 2020 05:04:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593594265;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pkbDW3XOjFTlc1GLNiEkuMPIsXZ+fGAYBJ0KGzuTwUo=;
        b=PvCRegKVrFW2fb985R3CyAaMcJ6HvM8znpf01+gj3Zg8X18nzrS8ayegtSZ4CwVbfAofU0
        RUfZ6KAWhCJfUpJqidmkNCvENoYfPcqi4/qjBOizUMz1gZO3ZX1zAI/TRJpv+3RiMNYPkH
        xHSXUU07OCbssW07YhgG/YGi91JLYZg=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-eWujed-LOt2O8oVwoiTlbQ-1; Wed, 01 Jul 2020 05:04:23 -0400
X-MC-Unique: eWujed-LOt2O8oVwoiTlbQ-1
Received: by mail-ej1-f69.google.com with SMTP id x15so14102534ejj.23
        for <kvm@vger.kernel.org>; Wed, 01 Jul 2020 02:04:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=pkbDW3XOjFTlc1GLNiEkuMPIsXZ+fGAYBJ0KGzuTwUo=;
        b=s7QGeVRMGtNOAZCuIaeuamSbMB5F9xibHn7QtgLX8/SF/Bk/iJyffH6Y02WqlYlCOL
         tcYglSqxgIV0Ask8I2WokTGloBwfQOcLIW1gsWxZ2rb/6gf5gLx45fJcZvcM/EHvXDgT
         Njvg+euSUXs5Y0KwMhsU40+eQChawAIC5E0IbGaSc5zsgNZNwxl22mM4KomQzqExgDCD
         obTPhHkcfJAMC9lF+oU0eY7nN2odDSpK2Q9mpRpVuYPDRI3lE6HHthaqEhPq8lpQt9uy
         NAG95GbkOS4XtlBw11jUEMukzF/xL3d+bZ4lFinL65aLnbKME6ACid45PaXUpAZLZf0T
         RJYg==
X-Gm-Message-State: AOAM531Q0e0OkidIDOMULwCQCTQ/G7QzF/gBXZ0XNCsgfq1sEweDYW/S
        IzH/ppGVqhLfNCuQzqntXf06+oltCgtJNE2T2gr7Gx8qB1bcIgBRZ0kws/w/MCGS0luMKcVEfNl
        wC5pJKL0LrToR
X-Received: by 2002:a50:ee8d:: with SMTP id f13mr26319781edr.302.1593594262080;
        Wed, 01 Jul 2020 02:04:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzb7np/MdcMADO0hhTMJekFDhd92I+8R3fiUhn0HZXgzAIzeIHkUWdH3jkj7gvPvo32GooEyQ==
X-Received: by 2002:a50:ee8d:: with SMTP id f13mr26319750edr.302.1593594261793;
        Wed, 01 Jul 2020 02:04:21 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id c9sm5708553edv.8.2020.07.01.02.04.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 02:04:21 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [RFC 2/2] KVM: VMX: Enable bus lock VM exit
In-Reply-To: <20200628085341.5107-3-chenyi.qiang@intel.com>
References: <20200628085341.5107-1-chenyi.qiang@intel.com> <20200628085341.5107-3-chenyi.qiang@intel.com>
Date:   Wed, 01 Jul 2020 11:04:20 +0200
Message-ID: <878sg3bo8b.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Chenyi Qiang <chenyi.qiang@intel.com> writes:

> Virtual Machine can exploit bus locks to degrade the performance of
> system. Bus lock can be caused by split locked access to writeback(WB)
> memory or by using locks on uncacheable(UC) memory. The bus lock is
> typically >1000 cycles slower than an atomic operation within a cache
> line. It also disrupts performance on other cores (which must wait for
> the bus lock to be released before their memory operations can
> complete).
>
> To address the threat, bus lock VM exit is introduced to notify the VMM
> when a bus lock was acquired, allowing it to enforce throttling or other
> policy based mitigations.
>
> A VMM can enable VM exit due to bus locks by setting a new "Bus Lock
> Detection" VM-execution control(bit 30 of Secondary Processor-based VM
> execution controls). If delivery of this VM exit was pre-empted by a
> higher priority VM exit, bit 26 of exit-reason is set to 1.
>
> In current implementation, it only records every bus lock acquired in
> non-root mode in vcpu->stat.bus_locks and exposes the data through
> debugfs. It doesn't implement any further handling but leave it to user.
>
> Document for Bus Lock VM exit is now available at the latest "Intel
> Architecture Instruction Set Extensions Programming Reference".
>
> Document Link:
> https://software.intel.com/content/www/us/en/develop/download/intel-architecture-instruction-set-extensions-programming-reference.html
>
> Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h    |  1 +
>  arch/x86/include/asm/vmx.h         |  1 +
>  arch/x86/include/asm/vmxfeatures.h |  1 +
>  arch/x86/include/uapi/asm/vmx.h    |  4 +++-
>  arch/x86/kvm/vmx/vmx.c             | 17 ++++++++++++++++-
>  arch/x86/kvm/vmx/vmx.h             |  2 +-
>  arch/x86/kvm/x86.c                 |  1 +
>  7 files changed, 24 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index f852ee350beb..efb5a117e11a 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1051,6 +1051,7 @@ struct kvm_vcpu_stat {
>  	u64 req_event;
>  	u64 halt_poll_success_ns;
>  	u64 halt_poll_fail_ns;
> +	u64 bus_locks;
>  };
>  
>  struct x86_instruction_info;
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index cd7de4b401fe..93a880bc31a7 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -73,6 +73,7 @@
>  #define SECONDARY_EXEC_PT_USE_GPA		VMCS_CONTROL_BIT(PT_USE_GPA)
>  #define SECONDARY_EXEC_TSC_SCALING              VMCS_CONTROL_BIT(TSC_SCALING)
>  #define SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE	VMCS_CONTROL_BIT(USR_WAIT_PAUSE)
> +#define SECONDARY_EXEC_BUS_LOCK_DETECTION	VMCS_CONTROL_BIT(BUS_LOCK_DETECTION)
>  
>  #define PIN_BASED_EXT_INTR_MASK                 VMCS_CONTROL_BIT(INTR_EXITING)
>  #define PIN_BASED_NMI_EXITING                   VMCS_CONTROL_BIT(NMI_EXITING)
> diff --git a/arch/x86/include/asm/vmxfeatures.h b/arch/x86/include/asm/vmxfeatures.h
> index 9915990fd8cf..d9a74681a77d 100644
> --- a/arch/x86/include/asm/vmxfeatures.h
> +++ b/arch/x86/include/asm/vmxfeatures.h
> @@ -83,5 +83,6 @@
>  #define VMX_FEATURE_TSC_SCALING		( 2*32+ 25) /* Scale hardware TSC when read in guest */
>  #define VMX_FEATURE_USR_WAIT_PAUSE	( 2*32+ 26) /* Enable TPAUSE, UMONITOR, UMWAIT in guest */
>  #define VMX_FEATURE_ENCLV_EXITING	( 2*32+ 28) /* "" VM-Exit on ENCLV (leaf dependent) */
> +#define VMX_FEATURE_BUS_LOCK_DETECTION	( 2*32+ 30) /* "" VM-Exit when bus lock caused */
>  
>  #endif /* _ASM_X86_VMXFEATURES_H */
> diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
> index b8ff9e8ac0d5..6bddfd7b87be 100644
> --- a/arch/x86/include/uapi/asm/vmx.h
> +++ b/arch/x86/include/uapi/asm/vmx.h
> @@ -88,6 +88,7 @@
>  #define EXIT_REASON_XRSTORS             64
>  #define EXIT_REASON_UMWAIT              67
>  #define EXIT_REASON_TPAUSE              68
> +#define EXIT_REASON_BUS_LOCK		74
>  
>  #define VMX_EXIT_REASONS \
>  	{ EXIT_REASON_EXCEPTION_NMI,         "EXCEPTION_NMI" }, \
> @@ -148,7 +149,8 @@
>  	{ EXIT_REASON_XSAVES,                "XSAVES" }, \
>  	{ EXIT_REASON_XRSTORS,               "XRSTORS" }, \
>  	{ EXIT_REASON_UMWAIT,                "UMWAIT" }, \
> -	{ EXIT_REASON_TPAUSE,                "TPAUSE" }
> +	{ EXIT_REASON_TPAUSE,                "TPAUSE" }, \
> +	{ EXIT_REASON_BUS_LOCK,              "BUS_LOCK" }
>  
>  #define VMX_EXIT_REASON_FLAGS \
>  	{ VMX_EXIT_REASONS_FAILED_VMENTRY,	"FAILED_VMENTRY" }
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 647ee9a1b4e6..9622d7486f6d 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2463,7 +2463,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>  			SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE |
>  			SECONDARY_EXEC_PT_USE_GPA |
>  			SECONDARY_EXEC_PT_CONCEAL_VMX |
> -			SECONDARY_EXEC_ENABLE_VMFUNC;
> +			SECONDARY_EXEC_ENABLE_VMFUNC |
> +			SECONDARY_EXEC_BUS_LOCK_DETECTION;
>  		if (cpu_has_sgx())
>  			opt2 |= SECONDARY_EXEC_ENCLS_EXITING;
>  		if (adjust_vmx_controls(min2, opt2,
> @@ -5664,6 +5665,12 @@ static int handle_encls(struct kvm_vcpu *vcpu)
>  	return 1;
>  }
>  
> +static int handle_bus_lock(struct kvm_vcpu *vcpu)
> +{
> +	vcpu->stat.bus_locks++;
> +	return 1;
> +}
> +
>  /*
>   * The exit handlers return 1 if the exit was handled fully and guest execution
>   * may resume.  Otherwise they set the kvm_run parameter to indicate what needs
> @@ -5720,6 +5727,7 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
>  	[EXIT_REASON_VMFUNC]		      = handle_vmx_instruction,
>  	[EXIT_REASON_PREEMPTION_TIMER]	      = handle_preemption_timer,
>  	[EXIT_REASON_ENCLS]		      = handle_encls,
> +	[EXIT_REASON_BUS_LOCK]                = handle_bus_lock,
>  };
>  
>  static const int kvm_vmx_max_exit_handlers =
> @@ -6830,6 +6838,13 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  	if (unlikely(vmx->exit_reason.failed_vmentry))
>  		return EXIT_FASTPATH_NONE;
>  
> +	/*
> +	 * check the exit_reason to see if there is a bus lock
> +	 * happened in guest.
> +	 */
> +	if (vmx->exit_reason.bus_lock_detected)
> +		handle_bus_lock(vcpu);

In case the ultimate goal is to have an exit to userspace on bus lock,
the two ways to reach handle_bus_lock() are very different: in case
we're handling EXIT_REASON_BUS_LOCK we can easily drop to userspace by
returning 0 but what are we going to do in case of
exit_reason.bus_lock_detected? The 'higher priority VM exit' may require
exit to userspace too. So what's the plan? Maybe we can ignore the case
when we're exiting to userspace for some other reason as this is slow
already and force the exit otherwise? And should we actually introduce
the KVM_EXIT_BUS_LOCK and a capability to enable it here?

> +
>  	vmx->loaded_vmcs->launched = 1;
>  	vmx->idt_vectoring_info = vmcs_read32(IDT_VECTORING_INFO_FIELD);
>  
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index a676db7ac03c..b501a26778fc 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -104,7 +104,7 @@ union vmx_exit_reason {
>  		u32	reserved23		: 1;
>  		u32	reserved24		: 1;
>  		u32	reserved25		: 1;
> -		u32	reserved26		: 1;
> +		u32	bus_lock_detected	: 1;
>  		u32	enclave_mode		: 1;
>  		u32	smi_pending_mtf		: 1;
>  		u32	smi_from_vmx_root	: 1;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 00c88c2f34e4..6258b453b8dd 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -220,6 +220,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
>  	VCPU_STAT("l1d_flush", l1d_flush),
>  	VCPU_STAT("halt_poll_success_ns", halt_poll_success_ns),
>  	VCPU_STAT("halt_poll_fail_ns", halt_poll_fail_ns),
> +	VCPU_STAT("bus_locks", bus_locks),
>  	VM_STAT("mmu_shadow_zapped", mmu_shadow_zapped),
>  	VM_STAT("mmu_pte_write", mmu_pte_write),
>  	VM_STAT("mmu_pte_updated", mmu_pte_updated),

-- 
Vitaly

