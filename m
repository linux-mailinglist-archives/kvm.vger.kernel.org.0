Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A83213CB54
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 18:48:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728998AbgAORse (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 12:48:34 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:26511 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726778AbgAORsd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Jan 2020 12:48:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579110511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qiGs3aRg68/AAaYWAB8KmVGkVt1asDcnY1mp5eIoi1s=;
        b=MLzW4/73tyfIx1KwcaFce5DBABIO9uegYRDVXe3CixvcGmIrStZ+r+liKDC3F+fyEBhETm
        GkxpWGN6vMRffGEKrQ4yb+RwoAHntwDgZXUzusK1aQ8ockO5wCcIIwRUDvyYUJrP0gdeku
        TLia10kwS4quzZApppN2fC44Sh3r1Y0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-AQPnq9y1Onuzz6qvmtuZjA-1; Wed, 15 Jan 2020 12:48:28 -0500
X-MC-Unique: AQPnq9y1Onuzz6qvmtuZjA-1
Received: by mail-wr1-f70.google.com with SMTP id j4so8250849wrs.13
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2020 09:48:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qiGs3aRg68/AAaYWAB8KmVGkVt1asDcnY1mp5eIoi1s=;
        b=Dr7JphtLktBYzjrt2UyhJ5V7Rk3nDLMMPYzlmXPhOG0PT6KGFPAgEv8BvYJFhymT4t
         UxYyY55dKJ7gk1WmvhpJfvAJkeGgOeebnl0OzX/3dQsFRjTKw/qGCWE3rLsSQJvVftik
         aUtIWKDBpxmW3De6Y2vWnz81NK6J3xSXePsngfCi+aXSPKuQbZnqdLHsW+1FxhhqLpmA
         HBHqf3zsv+jeXP9HrJ0UEWZXhJ/5hx8nJfk73rnHwRr4V0OrBkIzwhucyDk8/x6rqUSY
         Ai51JMnkZX3vJL1k/9AreNxObMrfhpuQ50jGia5YBu/4mgRhTFt+nKv0HHFlN0jUZ28z
         BHFw==
X-Gm-Message-State: APjAAAXl62kfT7/BaiTAy7geGNTWg6pi/GS6QNUa2o4MDztW82HuoAls
        +39NKXJsv33pvbSiHx4+0YhX8rMt1HGkzmliJzeAe5xl0ggbdsoFAQMsMGyQAQsIHaAYsa542px
        pzwPbk2Q+xBx/
X-Received: by 2002:a7b:c936:: with SMTP id h22mr1047123wml.115.1579110507772;
        Wed, 15 Jan 2020 09:48:27 -0800 (PST)
X-Google-Smtp-Source: APXvYqxXaCbt7zHgkUjh36EVIIWlXCggrmNqreGIK2GpxwsGzYUmAQW/FYlGCR6bSOEwV9oCGseEug==
X-Received: by 2002:a7b:c936:: with SMTP id h22mr1047090wml.115.1579110507462;
        Wed, 15 Jan 2020 09:48:27 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:436:e17d:1fd9:d92a? ([2001:b07:6468:f312:436:e17d:1fd9:d92a])
        by smtp.gmail.com with ESMTPSA id u8sm762774wmm.15.2020.01.15.09.48.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2020 09:48:26 -0800 (PST)
Subject: Re: [PATCH v4 1/2] KVM: VMX: FIXED+PHYSICAL mode single target IPI
 fastpath
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Liran Alon <liran.alon@oracle.com>
References: <1574306232-872-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <edfbe07e-cafd-f7d4-5007-78201801b377@redhat.com>
Date:   Wed, 15 Jan 2020 18:48:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1574306232-872-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/11/19 04:17, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> ICR and TSCDEADLINE MSRs write cause the main MSRs write vmexits in our 
> product observation, multicast IPIs are not as common as unicast IPI like 
> RESCHEDULE_VECTOR and CALL_FUNCTION_SINGLE_VECTOR etc.
> 
> This patch introduce a mechanism to handle certain performance-critical 
> WRMSRs in a very early stage of KVM VMExit handler.
> 
> This mechanism is specifically used for accelerating writes to x2APIC ICR 
> that attempt to send a virtual IPI with physical destination-mode, fixed 
> delivery-mode and single target. Which was found as one of the main causes 
> of VMExits for Linux workloads.
> 
> The reason this mechanism significantly reduce the latency of such virtual 
> IPIs is by sending the physical IPI to the target vCPU in a very early stage 
> of KVM VMExit handler, before host interrupts are enabled and before expensive
> operations such as reacquiring KVM’s SRCU lock.
> Latency is reduced even more when KVM is able to use APICv posted-interrupt
> mechanism (which allows to deliver the virtual IPI directly to target vCPU 
> without the need to kick it to host).
> 
> Testing on Xeon Skylake server:
> 
> The virtual IPI latency from sender send to receiver receive reduces 
> more than 200+ cpu cycles.

Applied with s/accel_exit/exit_fastpath/ and s/accel/fastpath/.

Paolo

> Reviewed-by: Liran Alon <liran.alon@oracle.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Liran Alon <liran.alon@oracle.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> v3 -> v4:
>  * check !is_guest_mode(vcpu)
>  * ACCEL_EXIT_SKIP_EMUL_INS don't need be -1
>  * move comments on top of handle_accel_set_x2apic_icr_irqoff
>  * update patch description
> v2 -> v3:
>  * for both VMX and SVM
>  * vmx_handle_exit() get second parameter by value and not by pointer
>  * rename parameter to “accel_exit_completion”
>  * preserve tracepoint ordering
>  * rename handler to handle_accel_set_msr_irqoff and more generic
>  * add comments above handle_accel_set_msr_irqoff
>  * msr index APIC_BASE_MSR + (APIC_ICR >> 4)
> v1 -> v2:
>  * add tracepoint
>  * Instead of a separate vcpu->fast_vmexit, set exit_reason
>   to vmx->exit_reason to -1 if the fast path succeeds.
>  * move the "kvm_skip_emulated_instruction(vcpu)" to vmx_handle_exit
>  * moving the handling into vmx_handle_exit_irqoff()
> 
>  arch/x86/include/asm/kvm_host.h | 11 ++++++++--
>  arch/x86/kvm/svm.c              | 15 +++++++++----
>  arch/x86/kvm/vmx/vmx.c          | 14 +++++++++---
>  arch/x86/kvm/x86.c              | 48 +++++++++++++++++++++++++++++++++++++++--
>  arch/x86/kvm/x86.h              |  1 +
>  5 files changed, 78 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 898ab9e..62af1c5 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -175,6 +175,11 @@ enum {
>  	VCPU_SREG_LDTR,
>  };
>  
> +enum accel_exit_completion {
> +	ACCEL_EXIT_NONE,
> +	ACCEL_EXIT_SKIP_EMUL_INS,
> +};
> +
>  #include <asm/kvm_emulate.h>
>  
>  #define KVM_NR_MEM_OBJS 40
> @@ -1084,7 +1089,8 @@ struct kvm_x86_ops {
>  	void (*tlb_flush_gva)(struct kvm_vcpu *vcpu, gva_t addr);
>  
>  	void (*run)(struct kvm_vcpu *vcpu);
> -	int (*handle_exit)(struct kvm_vcpu *vcpu);
> +	int (*handle_exit)(struct kvm_vcpu *vcpu,
> +		enum accel_exit_completion accel_exit);
>  	int (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
>  	void (*set_interrupt_shadow)(struct kvm_vcpu *vcpu, int mask);
>  	u32 (*get_interrupt_shadow)(struct kvm_vcpu *vcpu);
> @@ -1134,7 +1140,8 @@ struct kvm_x86_ops {
>  	int (*check_intercept)(struct kvm_vcpu *vcpu,
>  			       struct x86_instruction_info *info,
>  			       enum x86_intercept_stage stage);
> -	void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu);
> +	void (*handle_exit_irqoff)(struct kvm_vcpu *vcpu,
> +		enum accel_exit_completion *accel_exit);
>  	bool (*mpx_supported)(void);
>  	bool (*xsaves_supported)(void);
>  	bool (*umip_emulated)(void);
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index d02a73a..d0367c4 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -4929,7 +4929,8 @@ static void svm_get_exit_info(struct kvm_vcpu *vcpu, u64 *info1, u64 *info2)
>  	*info2 = control->exit_info_2;
>  }
>  
> -static int handle_exit(struct kvm_vcpu *vcpu)
> +static int handle_exit(struct kvm_vcpu *vcpu,
> +	enum accel_exit_completion accel_exit)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	struct kvm_run *kvm_run = vcpu->run;
> @@ -4987,7 +4988,10 @@ static int handle_exit(struct kvm_vcpu *vcpu)
>  		       __func__, svm->vmcb->control.exit_int_info,
>  		       exit_code);
>  
> -	if (exit_code >= ARRAY_SIZE(svm_exit_handlers)
> +	if (accel_exit == ACCEL_EXIT_SKIP_EMUL_INS) {
> +		kvm_skip_emulated_instruction(vcpu);
> +		return 1;
> +	} else if (exit_code >= ARRAY_SIZE(svm_exit_handlers)
>  	    || !svm_exit_handlers[exit_code]) {
>  		vcpu_unimpl(vcpu, "svm: unexpected exit reason 0x%x\n", exit_code);
>  		dump_vmcb(vcpu);
> @@ -6187,9 +6191,12 @@ static int svm_check_intercept(struct kvm_vcpu *vcpu,
>  	return ret;
>  }
>  
> -static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu)
> +static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu,
> +	enum accel_exit_completion *accel_exit)
>  {
> -
> +	if (!is_guest_mode(vcpu) &&
> +		to_svm(vcpu)->vmcb->control.exit_code == EXIT_REASON_MSR_WRITE)
> +		*accel_exit = handle_accel_set_msr_irqoff(vcpu);
>  }
>  
>  static void svm_sched_in(struct kvm_vcpu *vcpu, int cpu)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 621142e5..5d77188 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5792,7 +5792,8 @@ void dump_vmcs(void)
>   * The guest has exited.  See if we can fix it or if we need userspace
>   * assistance.
>   */
> -static int vmx_handle_exit(struct kvm_vcpu *vcpu)
> +static int vmx_handle_exit(struct kvm_vcpu *vcpu,
> +	enum accel_exit_completion accel_exit)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	u32 exit_reason = vmx->exit_reason;
> @@ -5878,7 +5879,10 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
>  		}
>  	}
>  
> -	if (exit_reason < kvm_vmx_max_exit_handlers
> +	if (accel_exit == ACCEL_EXIT_SKIP_EMUL_INS) {
> +		kvm_skip_emulated_instruction(vcpu);
> +		return 1;
> +	} else if (exit_reason < kvm_vmx_max_exit_handlers
>  	    && kvm_vmx_exit_handlers[exit_reason]) {
>  #ifdef CONFIG_RETPOLINE
>  		if (exit_reason == EXIT_REASON_MSR_WRITE)
> @@ -6223,7 +6227,8 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
>  }
>  STACK_FRAME_NON_STANDARD(handle_external_interrupt_irqoff);
>  
> -static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
> +static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu,
> +	enum accel_exit_completion *accel_exit)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  
> @@ -6231,6 +6236,9 @@ static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
>  		handle_external_interrupt_irqoff(vcpu);
>  	else if (vmx->exit_reason == EXIT_REASON_EXCEPTION_NMI)
>  		handle_exception_nmi_irqoff(vmx);
> +	else if (!is_guest_mode(vcpu) &&
> +		vmx->exit_reason == EXIT_REASON_MSR_WRITE)
> +		*accel_exit = handle_accel_set_msr_irqoff(vcpu);
>  }
>  
>  static bool vmx_has_emulated_msr(int index)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 991dd01..c55348c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1510,6 +1510,49 @@ int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
>  EXPORT_SYMBOL_GPL(kvm_emulate_wrmsr);
>  
>  /*
> + * The fast path for frequent and performance sensitive wrmsr emulation,
> + * i.e. the sending of IPI, sending IPI early in the VM-Exit flow reduces
> + * the latency of virtual IPI by avoiding the expensive bits of transitioning
> + * from guest to host, e.g. reacquiring KVM's SRCU lock. In contrast to the
> + * other cases which must be called after interrupts are enabled on the host.
> + */
> +static int handle_accel_set_x2apic_icr_irqoff(struct kvm_vcpu *vcpu, u64 data)
> +{
> +	if (lapic_in_kernel(vcpu) && apic_x2apic_mode(vcpu->arch.apic) &&
> +		((data & KVM_APIC_DEST_MASK) == APIC_DEST_PHYSICAL) &&
> +		((data & APIC_MODE_MASK) == APIC_DM_FIXED)) {
> +
> +		kvm_lapic_set_reg(vcpu->arch.apic, APIC_ICR2, (u32)(data >> 32));
> +		return kvm_lapic_reg_write(vcpu->arch.apic, APIC_ICR, (u32)data);
> +	}
> +
> +	return 1;
> +}
> +
> +enum accel_exit_completion handle_accel_set_msr_irqoff(struct kvm_vcpu *vcpu)
> +{
> +	u32 msr = kvm_rcx_read(vcpu);
> +	u64 data = kvm_read_edx_eax(vcpu);
> +	int ret = 0;
> +
> +	switch (msr) {
> +	case APIC_BASE_MSR + (APIC_ICR >> 4):
> +		ret = handle_accel_set_x2apic_icr_irqoff(vcpu, data);
> +		break;
> +	default:
> +		return ACCEL_EXIT_NONE;
> +	}
> +
> +	if (!ret) {
> +		trace_kvm_msr_write(msr, data);
> +		return ACCEL_EXIT_SKIP_EMUL_INS;
> +	}
> +
> +	return ACCEL_EXIT_NONE;
> +}
> +EXPORT_SYMBOL_GPL(handle_accel_set_msr_irqoff);
> +
> +/*
>   * Adapt set_msr() to msr_io()'s calling convention
>   */
>  static int do_get_msr(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
> @@ -7984,6 +8027,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  	bool req_int_win =
>  		dm_request_for_irq_injection(vcpu) &&
>  		kvm_cpu_accept_dm_intr(vcpu);
> +	enum accel_exit_completion accel_exit = ACCEL_EXIT_NONE;
>  
>  	bool req_immediate_exit = false;
>  
> @@ -8226,7 +8270,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  	vcpu->mode = OUTSIDE_GUEST_MODE;
>  	smp_wmb();
>  
> -	kvm_x86_ops->handle_exit_irqoff(vcpu);
> +	kvm_x86_ops->handle_exit_irqoff(vcpu, &accel_exit);
>  
>  	/*
>  	 * Consume any pending interrupts, including the possible source of
> @@ -8270,7 +8314,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  		kvm_lapic_sync_from_vapic(vcpu);
>  
>  	vcpu->arch.gpa_available = false;
> -	r = kvm_x86_ops->handle_exit(vcpu);
> +	r = kvm_x86_ops->handle_exit(vcpu, accel_exit);
>  	return r;
>  
>  cancel_injection:
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 29391af..f14ec14 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -291,6 +291,7 @@ bool kvm_mtrr_check_gfn_range_consistency(struct kvm_vcpu *vcpu, gfn_t gfn,
>  bool kvm_vector_hashing_enabled(void);
>  int x86_emulate_instruction(struct kvm_vcpu *vcpu, unsigned long cr2,
>  			    int emulation_type, void *insn, int insn_len);
> +enum accel_exit_completion handle_accel_set_msr_irqoff(struct kvm_vcpu *vcpu);
>  
>  #define KVM_SUPPORTED_XCR0     (XFEATURE_MASK_FP | XFEATURE_MASK_SSE \
>  				| XFEATURE_MASK_YMM | XFEATURE_MASK_BNDREGS \
> 

