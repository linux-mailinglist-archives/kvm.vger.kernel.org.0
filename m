Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0A8230511
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 10:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbgG1IPm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 04:15:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26529 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727916AbgG1IPl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 04:15:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595924138;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=APT8Y3ORGJu3Lws0o+AhpjjphfqMFHNSKEthfl1TagM=;
        b=IKnXlTMlWtgvQW4+/PeXbMnoPI+/OgabTaYrp2/whd5D5MZ96qGiUjiOlZ+9moyl7dwtVF
        fjJ26Kse9+nRq8NEio6yQ66C63gmLn0o/Mji8VaI1J3qQaArgEUEve5GGEHxK9ZajftfsK
        14G5qWOCqGAUKkwdqMu6w+9sisLpmJQ=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-431-cXxd6i6lP0C2rB5hDdjB1g-1; Tue, 28 Jul 2020 04:15:34 -0400
X-MC-Unique: cXxd6i6lP0C2rB5hDdjB1g-1
Received: by mail-ed1-f69.google.com with SMTP id u25so6676618edq.1
        for <kvm@vger.kernel.org>; Tue, 28 Jul 2020 01:15:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=APT8Y3ORGJu3Lws0o+AhpjjphfqMFHNSKEthfl1TagM=;
        b=opqN3lKEdh1P9E5QyYJFzNALaSFJi6P91DjX5etWSNPp6J+gaIm4FmJnXhCPtIKd5w
         fSupWQkh7cH44KjZE3x0MbMTaF89S+oI+Buz7SlBMPDy1OUkuLk3UAr7wGyKb0zGXn5x
         hAql/jvhgWzSjyaM6BoAoUPXsRMAWbMOQHxLIL0F0AkaiUdZq8adX0siWnIAcvwxLzqP
         GIqUklOft22KmJ07Ob9bQTaSmqHZsVpi4RAv1Ufh0kYoQdKbvAHIZ9ufoK60ZkKP2opN
         XAbxsaE8g1wankxRis688RbVrlCl3SsQbe2EmC2MEan3UU8oqlNZhi7ZSMM4WgBMV3+m
         YwvA==
X-Gm-Message-State: AOAM533d/F6CL79At8G1zDV5VCJ/BcXUkzzKkoHuqGufgrrc+H38YSGC
        3dtWi8D/dDUYfp8bKVtB89adswjnUlwVoHJeLoqxp7kHR7QORq9ALNCcGnqfIViZCrFsYEoKO6j
        jwXEdSaYvINGD
X-Received: by 2002:a17:906:38da:: with SMTP id r26mr23841757ejd.120.1595924133578;
        Tue, 28 Jul 2020 01:15:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwb98HPPbq/2K7IqnsEzz8Csf1eNidOkGNybPkktMe5ZL14g6ELn3sSQbAKJ3km9uBevv5MZQ==
X-Received: by 2002:a17:906:38da:: with SMTP id r26mr23841731ejd.120.1595924133134;
        Tue, 28 Jul 2020 01:15:33 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id by20sm8781254ejc.119.2020.07.28.01.15.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2020 01:15:32 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Alexander Graf <graf@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Deflect unknown MSR accesses to user space
In-Reply-To: <20200728004446.932-1-graf@amazon.com>
References: <20200728004446.932-1-graf@amazon.com>
Date:   Tue, 28 Jul 2020 10:15:31 +0200
Message-ID: <87d04gm4ws.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Alexander Graf <graf@amazon.com> writes:

> MSRs are weird. Some of them are normal control registers, such as EFER.
> Some however are registers that really are model specific, not very
> interesting to virtualization workloads, and not performance critical.
> Others again are really just windows into package configuration.
>
> Out of these MSRs, only the first category is necessary to implement in
> kernel space. Rarely accessed MSRs, MSRs that should be fine tunes against
> certain CPU models and MSRs that contain information on the package level
> are much better suited for user space to process. However, over time we have
> accumulated a lot of MSRs that are not the first category, but still handled
> by in-kernel KVM code.
>
> This patch adds a generic interface to handle WRMSR and RDMSR from user
> space. With this, any future MSR that is part of the latter categories can
> be handled in user space.
>
> Furthermore, it allows us to replace the existing "ignore_msrs" logic with
> something that applies per-VM rather than on the full system. That way you
> can run productive VMs in parallel to experimental ones where you don't care
> about proper MSR handling.
>

In theory, we can go further: userspace will give KVM the list of MSRs
it is interested in. This list may even contain MSRs which are normally
handled by KVM, in this case userspace gets an option to mangle KVM's
reply (RDMSR) or do something extra (WRMSR). I'm not sure if there is a
real need behind this, just an idea.

The problem with this approach is: if currently some MSR is not
implemented in KVM you will get an exit. When later someone comes with a
patch to implement this MSR your userspace handling will immediately get
broken so the list of not implemented MSRs effectively becomes an API :-)

> Signed-off-by: Alexander Graf <graf@amazon.com>
>
> ---
>
> As a quick example to show what this does, I implemented handling for MSR 0x35
> (MSR_CORE_THREAD_COUNT) in QEMU on top of this patch set:
>
>   https://github.com/agraf/qemu/commits/user-space-msr
> ---
>  Documentation/virt/kvm/api.rst  | 60 ++++++++++++++++++++++++++++++
>  arch/x86/include/asm/kvm_host.h |  6 +++
>  arch/x86/kvm/emulate.c          | 18 +++++++--
>  arch/x86/kvm/x86.c              | 65 ++++++++++++++++++++++++++++++++-
>  include/trace/events/kvm.h      |  2 +-
>  include/uapi/linux/kvm.h        | 11 ++++++
>  6 files changed, 155 insertions(+), 7 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 320788f81a05..7dfcc8e09dad 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -5155,6 +5155,34 @@ Note that KVM does not skip the faulting instruction as it does for
>  KVM_EXIT_MMIO, but userspace has to emulate any change to the processing state
>  if it decides to decode and emulate the instruction.
>  
> +::
> +
> +		/* KVM_EXIT_RDMSR / KVM_EXIT_WRMSR */
> +		struct {
> +			__u8 reply;
> +			__u8 error;
> +			__u8 pad[2];
> +			__u32 index;
> +			__u64 data;
> +		} msr;

(Personal taste most likely)

This layout is perfect but it makes my brain explode :-) Naturally, I
expect index and data to be the most significant members and I expect
them to be the first two members, something like

		struct {
			__u32 index;
			__u32 pad32;
			__u64 data;
			__u8 reply;
			__u8 error;
			__u8 pad8[6];
		} msr;

> +
> +Used on x86 systems. When the VM capability KVM_CAP_X86_USER_SPACE_MSR is
> +enabled, MSR accesses to registers that are not known by KVM kernel code will
> +trigger a KVM_EXIT_RDMSR exit for reads and KVM_EXIT_WRMSR exit for writes.
> +
> +For KVM_EXIT_RDMSR, the "index" field tells user space which MSR the guest
> +wants to read. To respond to this request with a successful read, user space
> +writes a 1 into the "reply" field and the respective data into the "data" field.
> +
> +If the RDMSR request was unsuccessful, user space indicates that with a "1"
> +in the "reply" field and a "1" in the "error" field. This will inject a #GP
> +into the guest when the VCPU is executed again.
> +
> +For KVM_EXIT_WRMSR, the "index" field tells user space which MSR the guest
> +wants to write. Once finished processing the event, user space sets the "reply"
> +field to "1". If the MSR write was unsuccessful, user space also sets the
> +"error" field to "1".
> +
>  ::
>  
>  		/* Fix the size of the union. */
> @@ -5844,6 +5872,27 @@ controlled by the kvm module parameter halt_poll_ns. This capability allows
>  the maximum halt time to specified on a per-VM basis, effectively overriding
>  the module parameter for the target VM.
>  
> +7.21 KVM_CAP_X86_USER_SPACE_MSR
> +----------------------
> +
> +:Architectures: x86
> +:Target: VM
> +:Parameters: args[0] is 1 if user space MSR handling is enabled, 0 otherwise
> +:Returns: 0 on success; -1 on error
> +
> +This capability enabled trapping of unhandled RDMSR and WRMSR instructions
> +into user space.
> +
> +When a guest requests to read or write an MSR, KVM may not implement all MSRs
> +that are relevant to a respective system. It also does not differentiate by
> +CPU type.
> +
> +To allow more fine grained control over MSR handling, user space may enable
> +this capability. With it enabled, MSR accesses that are not handled by KVM
> +will trigger KVM_EXIT_RDMSR and KVM_EXIT_WRMSR exit notifications which
> +user space can then handle to implement model specific MSR handling and/or
> +user notifications to inform a user that an MSR was not handled.
> +
>  8. Other capabilities.
>  ======================
>  
> @@ -6151,3 +6200,14 @@ KVM can therefore start protected VMs.
>  This capability governs the KVM_S390_PV_COMMAND ioctl and the
>  KVM_MP_STATE_LOAD MP_STATE. KVM_SET_MP_STATE can fail for protected
>  guests when the state change is invalid.
> +
> +8.24 KVM_CAP_X86_USER_SPACE_MSR
> +----------------------------
> +
> +:Architectures: x86
> +
> +This capability indicates that KVM supports deflection of MSR reads and
> +writes to user space. It can be enabled on a VM level. If enabled, MSR
> +accesses that are not handled by KVM and would thus usually trigger a
> +#GP into the guest will instead get bounced to user space through the
> +KVM_EXIT_RDMSR and KVM_EXIT_WRMSR exit notifications.
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index be5363b21540..c4218e05d8b8 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1002,6 +1002,9 @@ struct kvm_arch {
>  	bool guest_can_read_msr_platform_info;
>  	bool exception_payload_enabled;
>  
> +	/* Deflect RDMSR and WRMSR to user space if not handled in kernel */
> +	bool user_space_msr_enabled;
> +
>  	struct kvm_pmu_event_filter *pmu_event_filter;
>  	struct task_struct *nx_lpage_recovery_thread;
>  };
> @@ -1437,6 +1440,9 @@ int kvm_emulate_instruction(struct kvm_vcpu *vcpu, int emulation_type);
>  int kvm_emulate_instruction_from_buffer(struct kvm_vcpu *vcpu,
>  					void *insn, int insn_len);
>  
> +/* Indicate that an MSR operation should be handled by user space */
> +#define ETRAP_TO_USER_SPACE EREMOTE

What if we just use ENOENT in
kvm_set_msr_user_space()/kvm_get_msr_user_space()? Or, maybe, we can
just notice that KVM_EXIT_RDMSR/KVM_EXIT_WRMSR was set, this way we
don't need a specific exit code.

> +
>  void kvm_enable_efer_bits(u64);
>  bool kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer);
>  int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data, bool host_initiated);
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index d0e2825ae617..b08000e3b2fe 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -3693,18 +3693,28 @@ static int em_wrmsr(struct x86_emulate_ctxt *ctxt)
>  
>  	msr_data = (u32)reg_read(ctxt, VCPU_REGS_RAX)
>  		| ((u64)reg_read(ctxt, VCPU_REGS_RDX) << 32);
> -	if (ctxt->ops->set_msr(ctxt, reg_read(ctxt, VCPU_REGS_RCX), msr_data))
> +	switch (ctxt->ops->set_msr(ctxt, reg_read(ctxt, VCPU_REGS_RCX), msr_data)) {
> +	case 0:
> +		return X86EMUL_CONTINUE;
> +	case -ETRAP_TO_USER_SPACE:
> +		return X86EMUL_IO_NEEDED;
> +	default:
>  		return emulate_gp(ctxt, 0);
> -
> -	return X86EMUL_CONTINUE;
> +	}
>  }
>  
>  static int em_rdmsr(struct x86_emulate_ctxt *ctxt)
>  {
>  	u64 msr_data;
>  
> -	if (ctxt->ops->get_msr(ctxt, reg_read(ctxt, VCPU_REGS_RCX), &msr_data))
> +	switch (ctxt->ops->get_msr(ctxt, reg_read(ctxt, VCPU_REGS_RCX), &msr_data)) {
> +	case 0:
> +		break;
> +	case -ETRAP_TO_USER_SPACE:
> +		return X86EMUL_IO_NEEDED;
> +	default:
>  		return emulate_gp(ctxt, 0);
> +	}
>  
>  	*reg_write(ctxt, VCPU_REGS_RAX) = (u32)msr_data;
>  	*reg_write(ctxt, VCPU_REGS_RDX) = msr_data >> 32;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 88c593f83b28..530729e7ca4b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1554,7 +1554,13 @@ int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu)
>  	u32 ecx = kvm_rcx_read(vcpu);
>  	u64 data;
>  
> -	if (kvm_get_msr(vcpu, ecx, &data)) {
> +	switch (kvm_get_msr(vcpu, ecx, &data)) {
> +	case 0:
> +		break;
> +	case -ETRAP_TO_USER_SPACE:
> +		trace_kvm_msr_read(ecx, data);
> +		return 0;
> +	default:
>  		trace_kvm_msr_read_ex(ecx);
>  		kvm_inject_gp(vcpu, 0);
>  		return 1;
> @@ -1573,7 +1579,13 @@ int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
>  	u32 ecx = kvm_rcx_read(vcpu);
>  	u64 data = kvm_read_edx_eax(vcpu);
>  
> -	if (kvm_set_msr(vcpu, ecx, data)) {
> +	switch (kvm_set_msr(vcpu, ecx, data)) {
> +	case 0:
> +		break;
> +	case -ETRAP_TO_USER_SPACE:
> +		trace_kvm_msr_write(ecx, data);
> +		return 0;
> +	default:
>  		trace_kvm_msr_write_ex(ecx, data);
>  		kvm_inject_gp(vcpu, 0);
>  		return 1;
> @@ -2797,6 +2809,26 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
>  	kvm_unmap_gfn(vcpu, &map, &vcpu->arch.st.cache, true, false);
>  }
>  
> +static int kvm_set_msr_user_space(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> +{
> +	if (vcpu->run->exit_reason == KVM_EXIT_WRMSR && vcpu->run->msr.reply) {
> +		vcpu->run->msr.reply = 0;
> +
> +		if (vcpu->run->msr.error)
> +			return 1;
> +
> +		return 0;
> +	}
> +
> +	vcpu->run->exit_reason = KVM_EXIT_WRMSR;
> +	vcpu->run->msr.reply = 0;
> +	vcpu->run->msr.error = 0;
> +	vcpu->run->msr.index = msr_info->index;
> +	vcpu->run->msr.data = msr_info->data;
> +
> +	return -ETRAP_TO_USER_SPACE;
> +}
> +
>  int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  {
>  	bool pr = false;
> @@ -3066,6 +3098,8 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  			return xen_hvm_config(vcpu, data);
>  		if (kvm_pmu_is_valid_msr(vcpu, msr))
>  			return kvm_pmu_set_msr(vcpu, msr_info);
> +		if (vcpu->kvm->arch.user_space_msr_enabled && !msr_info->host_initiated)
> +			return kvm_set_msr_user_space(vcpu, msr_info);
>  		if (!ignore_msrs) {
>  			vcpu_debug_ratelimited(vcpu, "unhandled wrmsr: 0x%x data 0x%llx\n",
>  				    msr, data);
> @@ -3120,6 +3154,26 @@ static int get_msr_mce(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
>  	return 0;
>  }
>  
> +static int kvm_get_msr_user_space(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> +{
> +	if (vcpu->run->exit_reason == KVM_EXIT_RDMSR && vcpu->run->msr.reply) {
> +		vcpu->run->msr.reply = 0;
> +
> +		if (vcpu->run->msr.error)
> +			return 1;
> +
> +		msr_info->data = vcpu->run->msr.data;
> +		return 0;
> +	}
> +
> +	vcpu->run->exit_reason = KVM_EXIT_RDMSR;
> +	vcpu->run->msr.reply = 0;
> +	vcpu->run->msr.error = 0;
> +	vcpu->run->msr.index = msr_info->index;
> +
> +	return -ETRAP_TO_USER_SPACE;
> +}
> +
>  int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  {
>  	switch (msr_info->index) {
> @@ -3331,6 +3385,8 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  	default:
>  		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
>  			return kvm_pmu_get_msr(vcpu, msr_info);
> +		if (vcpu->kvm->arch.user_space_msr_enabled && !msr_info->host_initiated)
> +			return kvm_get_msr_user_space(vcpu, msr_info);
>  		if (!ignore_msrs) {
>  			vcpu_debug_ratelimited(vcpu, "unhandled rdmsr: 0x%x\n",
>  					       msr_info->index);
> @@ -3476,6 +3532,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_MSR_PLATFORM_INFO:
>  	case KVM_CAP_EXCEPTION_PAYLOAD:
>  	case KVM_CAP_SET_GUEST_DEBUG:
> +	case KVM_CAP_X86_USER_SPACE_MSR:
>  		r = 1;
>  		break;
>  	case KVM_CAP_SYNC_REGS:
> @@ -4990,6 +5047,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  		kvm->arch.exception_payload_enabled = cap->args[0];
>  		r = 0;
>  		break;
> +	case KVM_CAP_X86_USER_SPACE_MSR:
> +		kvm->arch.user_space_msr_enabled = cap->args[0];
> +		r = 0;
> +		break;
>  	default:
>  		r = -EINVAL;
>  		break;
> diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
> index 2c735a3e6613..09509dee4968 100644
> --- a/include/trace/events/kvm.h
> +++ b/include/trace/events/kvm.h
> @@ -17,7 +17,7 @@
>  	ERSN(NMI), ERSN(INTERNAL_ERROR), ERSN(OSI), ERSN(PAPR_HCALL),	\
>  	ERSN(S390_UCONTROL), ERSN(WATCHDOG), ERSN(S390_TSCH), ERSN(EPR),\
>  	ERSN(SYSTEM_EVENT), ERSN(S390_STSI), ERSN(IOAPIC_EOI),          \
> -	ERSN(HYPERV)
> +	ERSN(HYPERV), ERSN(ARM_NISV), ERSN(RDMSR), ERSN(WRMSR)
>  
>  TRACE_EVENT(kvm_userspace_exit,
>  	    TP_PROTO(__u32 reason, int errno),
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 4fdf30316582..df237bf2bdc2 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -248,6 +248,8 @@ struct kvm_hyperv_exit {
>  #define KVM_EXIT_IOAPIC_EOI       26
>  #define KVM_EXIT_HYPERV           27
>  #define KVM_EXIT_ARM_NISV         28
> +#define KVM_EXIT_RDMSR            29
> +#define KVM_EXIT_WRMSR            30
>  
>  /* For KVM_EXIT_INTERNAL_ERROR */
>  /* Emulate instruction failed. */
> @@ -412,6 +414,14 @@ struct kvm_run {
>  			__u64 esr_iss;
>  			__u64 fault_ipa;
>  		} arm_nisv;
> +		/* KVM_EXIT_RDMSR / KVM_EXIT_WRMSR */
> +		struct {
> +			__u8 reply;
> +			__u8 error;
> +			__u8 pad[2];
> +			__u32 index;
> +			__u64 data;
> +		} msr;
>  		/* Fix the size of the union. */
>  		char padding[256];
>  	};
> @@ -1031,6 +1041,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_PPC_SECURE_GUEST 181
>  #define KVM_CAP_HALT_POLL 182
>  #define KVM_CAP_ASYNC_PF_INT 183
> +#define KVM_CAP_X86_USER_SPACE_MSR 184
>  
>  #ifdef KVM_CAP_IRQ_ROUTING

-- 
Vitaly

