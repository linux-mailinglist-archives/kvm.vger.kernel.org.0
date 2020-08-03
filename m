Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3BCC23A34B
	for <lists+kvm@lfdr.de>; Mon,  3 Aug 2020 13:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgHCL1r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Aug 2020 07:27:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46849 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725945AbgHCL1r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Aug 2020 07:27:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596454064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N/VWUxzW6IcSvX9rYb8uOdem82TrreD7ss7kAr+0P60=;
        b=NT94NIQ3JUjl/yoHMHW8biU2TQDnhrLy66qY0VDgpXfWP0MoHCh10DhgCMFMCTxEydBygZ
        zOBV+mDbhPD+EJvdRtlSj/ruj4MvObgwyV7a8XFaP8q9GIPuvUQPzRllG0JGR1q8fF26Zr
        V+6odSQ7CjiprWAoKPnNUUieHEHOyTs=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-342-lPrDtBIRP2O-oX8AZy-1Ag-1; Mon, 03 Aug 2020 07:27:41 -0400
X-MC-Unique: lPrDtBIRP2O-oX8AZy-1Ag-1
Received: by mail-ej1-f70.google.com with SMTP id a19so8775225ejs.12
        for <kvm@vger.kernel.org>; Mon, 03 Aug 2020 04:27:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=N/VWUxzW6IcSvX9rYb8uOdem82TrreD7ss7kAr+0P60=;
        b=QusVy0p2GnNzP6p1DbFYpXD/M6aRoR6s0vVzAZGtvXGkTLulgBiiRzu5szN6zjNQU9
         BhcI2uO+waTo1+WdMi7cEARmIP/qUK8IAkJJBaeTc3Z5ZGOTFS+dTAzrkKWdyI1xwx0V
         mdFd/RyWbdw0P43iPGkM16Nqo1lauEaP+ZAn2YaxsjjC6f2BgZO5Em/HOTNuky033LPC
         crU4pnHiTsL1VpzszprTthoXyGP1I3lLVx/t4+4pXtJf/qPzWv3tzYUJjwYmsIfZxAZS
         bgzSAtKi6BrFLvVhio+9uvOu96t38rUzFylwrtIPuI6p4M/fIwOux5oOiGvJo1QAsd1L
         U8yw==
X-Gm-Message-State: AOAM530qpZAKqWAHXqlp2zg4/Mk56jO0tE0+erKpDFnvlVMpp2iySx8z
        aXUGKxaqbvw3/p9eUbNM6WHD2lSIv85Nq47vN9+Mc9Gg5B8mSlcl7QJtgkKlF65NV9lJoQyvZUT
        JLkfgIRYIQSuP
X-Received: by 2002:a17:906:600f:: with SMTP id o15mr16550582ejj.41.1596454060313;
        Mon, 03 Aug 2020 04:27:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx5QlEQIxxPKdkjc+slNCOjFt9St8xTSGVDWKy/j6+VKYrB3DusKtoSuGr8ODHgdSlF+uyXcA==
X-Received: by 2002:a17:906:600f:: with SMTP id o15mr16550547ejj.41.1596454059881;
        Mon, 03 Aug 2020 04:27:39 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id hk14sm2639271ejb.88.2020.08.03.04.27.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 04:27:38 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Alexander Graf <graf@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        KarimAllah Raslan <karahmed@amazon.de>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] KVM: x86: Deflect unknown MSR accesses to user space
In-Reply-To: <20200731214947.16885-2-graf@amazon.com>
References: <20200731214947.16885-1-graf@amazon.com> <20200731214947.16885-2-graf@amazon.com>
Date:   Mon, 03 Aug 2020 13:27:36 +0200
Message-ID: <873654q89j.fsf@vitty.brq.redhat.com>
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
> Signed-off-by: Alexander Graf <graf@amazon.com>
>
> ---
>
> v1 -> v2:
>
>   - s/ETRAP_TO_USER_SPACE/ENOENT/g
>   - deflect all #GP injection events to user space, not just unknown MSRs.
>     That was we can also deflect allowlist errors later
>   - fix emulator case
>
> v2 -> v3:
>
>   - return r if r == X86EMUL_IO_NEEDED
>   - s/KVM_EXIT_RDMSR/KVM_EXIT_X86_RDMSR/g
>   - s/KVM_EXIT_WRMSR/KVM_EXIT_X86_WRMSR/g
>   - Use complete_userspace_io logic instead of reply field
>   - Simplify trapping code
> ---
>  Documentation/virt/kvm/api.rst  |  62 +++++++++++++++++++
>  arch/x86/include/asm/kvm_host.h |   6 ++
>  arch/x86/kvm/emulate.c          |  18 +++++-
>  arch/x86/kvm/x86.c              | 106 ++++++++++++++++++++++++++++++--
>  include/trace/events/kvm.h      |   2 +-
>  include/uapi/linux/kvm.h        |  10 +++
>  6 files changed, 197 insertions(+), 7 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 320788f81a05..79c3e2fdfae4 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -5155,6 +5155,35 @@ Note that KVM does not skip the faulting instruction as it does for
>  KVM_EXIT_MMIO, but userspace has to emulate any change to the processing state
>  if it decides to decode and emulate the instruction.
>  
> +::
> +
> +		/* KVM_EXIT_X86_RDMSR / KVM_EXIT_X86_WRMSR */
> +		struct {
> +			__u8 error;
> +			__u8 pad[3];
> +			__u32 index;
> +			__u64 data;
> +		} msr;
> +
> +Used on x86 systems. When the VM capability KVM_CAP_X86_USER_SPACE_MSR is
> +enabled, MSR accesses to registers that would invoke a #GP by KVM kernel code
> +will instead trigger a KVM_EXIT_X86_RDMSR exit for reads and KVM_EXIT_X86_WRMSR
> +exit for writes.
> +
> +For KVM_EXIT_X86_RDMSR, the "index" field tells user space which MSR the guest
> +wants to read. To respond to this request with a successful read, user space
> +writes the respective data into the "data" field and must continue guest
> +execution to ensure the read data is transferred into guest register state.
> +
> +If the RDMSR request was unsuccessful, user space indicates that with a "1" in
> +the "error" field. This will inject a #GP into the guest when the VCPU is
> +executed again.
> +
> +For KVM_EXIT_X86_WRMSR, the "index" field tells user space which MSR the guest
> +wants to write. Once finished processing the event, user space must continue
> +vCPU execution. If the MSR write was unsuccessful, user space also sets the
> +"error" field to "1".
> +
>  ::
>  
>  		/* Fix the size of the union. */
> @@ -5844,6 +5873,28 @@ controlled by the kvm module parameter halt_poll_ns. This capability allows
>  the maximum halt time to specified on a per-VM basis, effectively overriding
>  the module parameter for the target VM.
>  
> +7.21 KVM_CAP_X86_USER_SPACE_MSR
> +-------------------------------
> +
> +:Architectures: x86
> +:Target: VM
> +:Parameters: args[0] is 1 if user space MSR handling is enabled, 0 otherwise
> +:Returns: 0 on success; -1 on error
> +
> +This capability enables trapping of #GP invoking RDMSR and WRMSR instructions
> +into user space.
> +
> +When a guest requests to read or write an MSR, KVM may not implement all MSRs
> +that are relevant to a respective system. It also does not differentiate by
> +CPU type.
> +
> +To allow more fine grained control over MSR handling, user space may enable
> +this capability. With it enabled, MSR accesses that would usually trigger
> +a #GP event inside the guest by KVM will instead trigger KVM_EXIT_X86_RDMSR
> +and KVM_EXIT_X86_WRMSR exit notifications which user space can then handle to
> +implement model specific MSR handling and/or user notifications to inform
> +a user that an MSR was not handled.
> +
>  8. Other capabilities.
>  ======================
>  
> @@ -6151,3 +6202,14 @@ KVM can therefore start protected VMs.
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
> +accesses that would usually trigger a #GP by KVM into the guest will
> +instead get bounced to user space through the KVM_EXIT_X86_RDMSR and
> +KVM_EXIT_X86_WRMSR exit notifications.
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index be5363b21540..809eed0dbdea 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -829,6 +829,9 @@ struct kvm_vcpu_arch {
>  
>  	/* AMD MSRC001_0015 Hardware Configuration */
>  	u64 msr_hwcr;
> +
> +	/* User space is handling an MSR request */
> +	bool pending_user_msr;
>  };
>  
>  struct kvm_lpage_info {
> @@ -1002,6 +1005,9 @@ struct kvm_arch {
>  	bool guest_can_read_msr_platform_info;
>  	bool exception_payload_enabled;
>  
> +	/* Deflect RDMSR and WRMSR to user space when they trigger a #GP */
> +	bool user_space_msr_enabled;
> +
>  	struct kvm_pmu_event_filter *pmu_event_filter;
>  	struct task_struct *nx_lpage_recovery_thread;
>  };
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index d0e2825ae617..744ab9c92b73 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -3689,11 +3689,18 @@ static int em_dr_write(struct x86_emulate_ctxt *ctxt)
>  
>  static int em_wrmsr(struct x86_emulate_ctxt *ctxt)
>  {
> +	u64 msr_index = reg_read(ctxt, VCPU_REGS_RCX);
>  	u64 msr_data;
> +	int r;
>  
>  	msr_data = (u32)reg_read(ctxt, VCPU_REGS_RAX)
>  		| ((u64)reg_read(ctxt, VCPU_REGS_RDX) << 32);
> -	if (ctxt->ops->set_msr(ctxt, reg_read(ctxt, VCPU_REGS_RCX), msr_data))
> +	r = ctxt->ops->set_msr(ctxt, msr_index, msr_data);
> +
> +	if (r == X86EMUL_IO_NEEDED)
> +		return r;
> +
> +	if (r)
>  		return emulate_gp(ctxt, 0);
>  
>  	return X86EMUL_CONTINUE;
> @@ -3701,9 +3708,16 @@ static int em_wrmsr(struct x86_emulate_ctxt *ctxt)
>  
>  static int em_rdmsr(struct x86_emulate_ctxt *ctxt)
>  {
> +	u64 msr_index = reg_read(ctxt, VCPU_REGS_RCX);
>  	u64 msr_data;
> +	int r;
> +
> +	r = ctxt->ops->get_msr(ctxt, msr_index, &msr_data);
> +
> +	if (r == X86EMUL_IO_NEEDED)
> +		return r;
>  
> -	if (ctxt->ops->get_msr(ctxt, reg_read(ctxt, VCPU_REGS_RCX), &msr_data))
> +	if (r)
>  		return emulate_gp(ctxt, 0);
>  
>  	*reg_write(ctxt, VCPU_REGS_RAX) = (u32)msr_data;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 88c593f83b28..24c72250f6df 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1549,12 +1549,75 @@ int kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data)
>  }
>  EXPORT_SYMBOL_GPL(kvm_set_msr);
>  
> +static int complete_emulated_msr(struct kvm_vcpu *vcpu, bool is_read)
> +{
> +	BUG_ON(!vcpu->arch.pending_user_msr);
> +
> +	if (vcpu->run->msr.error) {
> +		kvm_inject_gp(vcpu, 0);
> +	} else if (is_read) {
> +		kvm_rax_write(vcpu, (u32)vcpu->run->msr.data);
> +		kvm_rdx_write(vcpu, vcpu->run->msr.data >> 32);
> +	}
> +
> +	return kvm_skip_emulated_instruction(vcpu);
> +}
> +
> +static int complete_emulated_rdmsr(struct kvm_vcpu *vcpu)
> +{
> +	return complete_emulated_msr(vcpu, true);
> +}
> +
> +static int complete_emulated_wrmsr(struct kvm_vcpu *vcpu)
> +{
> +	return complete_emulated_msr(vcpu, false);
> +}
> +
> +static int kvm_get_msr_user_space(struct kvm_vcpu *vcpu, u32 index)
> +{
> +	if (!vcpu->kvm->arch.user_space_msr_enabled)
> +		return 0;
> +
> +	vcpu->run->exit_reason = KVM_EXIT_X86_RDMSR;
> +	vcpu->run->msr.error = 0;
> +	vcpu->run->msr.index = index;
> +	vcpu->arch.pending_user_msr = true;
> +	vcpu->arch.complete_userspace_io = complete_emulated_rdmsr;
> +
> +	return 1;
> +}
> +
> +static int kvm_set_msr_user_space(struct kvm_vcpu *vcpu, u32 index, u64 data)
> +{
> +	if (!vcpu->kvm->arch.user_space_msr_enabled)
> +		return 0;
> +
> +	vcpu->run->exit_reason = KVM_EXIT_X86_WRMSR;
> +	vcpu->run->msr.error = 0;
> +	vcpu->run->msr.index = index;
> +	vcpu->run->msr.data = data;
> +	vcpu->arch.pending_user_msr = true;
> +	vcpu->arch.complete_userspace_io = complete_emulated_wrmsr;

I'm probably missing something but where do we reset
vcpu->arch.pending_user_msr? Shouldn't it be done in
complete_emulated_msr()?

> +
> +	return 1;
> +}
> +
>  int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu)
>  {
>  	u32 ecx = kvm_rcx_read(vcpu);
>  	u64 data;
> +	int r;
> +
> +	r = kvm_get_msr(vcpu, ecx, &data);
>  
> -	if (kvm_get_msr(vcpu, ecx, &data)) {
> +	/* MSR read failed? See if we should ask user space */
> +	if (r && kvm_get_msr_user_space(vcpu, ecx)) {
> +		/* Bounce to user space */
> +		return 0;
> +	}
> +
> +	/* MSR read failed? Inject a #GP */
> +	if (r) {
>  		trace_kvm_msr_read_ex(ecx);
>  		kvm_inject_gp(vcpu, 0);
>  		return 1;
> @@ -1572,8 +1635,18 @@ int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
>  {
>  	u32 ecx = kvm_rcx_read(vcpu);
>  	u64 data = kvm_read_edx_eax(vcpu);
> +	int r;
> +
> +	r = kvm_set_msr(vcpu, ecx, data);
>  
> -	if (kvm_set_msr(vcpu, ecx, data)) {
> +	/* MSR write failed? See if we should ask user space */
> +	if (r && kvm_set_msr_user_space(vcpu, ecx, data)) {
> +		/* Bounce to user space */
> +		return 0;
> +	}
> +
> +	/* MSR write failed? Inject a #GP */
> +	if (r) {
>  		trace_kvm_msr_write_ex(ecx, data);
>  		kvm_inject_gp(vcpu, 0);
>  		return 1;
> @@ -3476,6 +3549,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_MSR_PLATFORM_INFO:
>  	case KVM_CAP_EXCEPTION_PAYLOAD:
>  	case KVM_CAP_SET_GUEST_DEBUG:
> +	case KVM_CAP_X86_USER_SPACE_MSR:
>  		r = 1;
>  		break;
>  	case KVM_CAP_SYNC_REGS:
> @@ -4990,6 +5064,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
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
> @@ -6319,13 +6397,33 @@ static void emulator_set_segment(struct x86_emulate_ctxt *ctxt, u16 selector,
>  static int emulator_get_msr(struct x86_emulate_ctxt *ctxt,
>  			    u32 msr_index, u64 *pdata)
>  {
> -	return kvm_get_msr(emul_to_vcpu(ctxt), msr_index, pdata);
> +	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
> +	int r;
> +
> +	r = kvm_get_msr(vcpu, msr_index, pdata);
> +
> +	if (r && kvm_get_msr_user_space(vcpu, msr_index)) {
> +		/* Bounce to user space */
> +		return X86EMUL_IO_NEEDED;
> +	}
> +
> +	return r;
>  }
>  
>  static int emulator_set_msr(struct x86_emulate_ctxt *ctxt,
>  			    u32 msr_index, u64 data)
>  {
> -	return kvm_set_msr(emul_to_vcpu(ctxt), msr_index, data);
> +	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
> +	int r;
> +
> +	r = kvm_set_msr(emul_to_vcpu(ctxt), msr_index, data);
> +
> +	if (r && kvm_set_msr_user_space(vcpu, msr_index, data)) {
> +		/* Bounce to user space */
> +		return X86EMUL_IO_NEEDED;
> +	}
> +
> +	return r;
>  }
>  
>  static u64 emulator_get_smbase(struct x86_emulate_ctxt *ctxt)
> diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
> index 9417a34aad08..26cfb0fa8e7e 100644
> --- a/include/trace/events/kvm.h
> +++ b/include/trace/events/kvm.h
> @@ -17,7 +17,7 @@
>  	ERSN(NMI), ERSN(INTERNAL_ERROR), ERSN(OSI), ERSN(PAPR_HCALL),	\
>  	ERSN(S390_UCONTROL), ERSN(WATCHDOG), ERSN(S390_TSCH), ERSN(EPR),\
>  	ERSN(SYSTEM_EVENT), ERSN(S390_STSI), ERSN(IOAPIC_EOI),          \
> -	ERSN(HYPERV), ERSN(ARM_NISV)
> +	ERSN(HYPERV), ERSN(ARM_NISV), ERSN(X86_RDMSR), ERSN(X86_WRMSR)
>  
>  TRACE_EVENT(kvm_userspace_exit,
>  	    TP_PROTO(__u32 reason, int errno),
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 4fdf30316582..13fc7de1eb50 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -248,6 +248,8 @@ struct kvm_hyperv_exit {
>  #define KVM_EXIT_IOAPIC_EOI       26
>  #define KVM_EXIT_HYPERV           27
>  #define KVM_EXIT_ARM_NISV         28
> +#define KVM_EXIT_X86_RDMSR        29
> +#define KVM_EXIT_X86_WRMSR        30
>  
>  /* For KVM_EXIT_INTERNAL_ERROR */
>  /* Emulate instruction failed. */
> @@ -412,6 +414,13 @@ struct kvm_run {
>  			__u64 esr_iss;
>  			__u64 fault_ipa;
>  		} arm_nisv;
> +		/* KVM_EXIT_X86_RDMSR / KVM_EXIT_X86_WRMSR */
> +		struct {
> +			__u8 error;
> +			__u8 pad[3];
> +			__u32 index;
> +			__u64 data;
> +		} msr;
>  		/* Fix the size of the union. */
>  		char padding[256];
>  	};
> @@ -1031,6 +1040,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_PPC_SECURE_GUEST 181
>  #define KVM_CAP_HALT_POLL 182
>  #define KVM_CAP_ASYNC_PF_INT 183
> +#define KVM_CAP_X86_USER_SPACE_MSR 184
>  
>  #ifdef KVM_CAP_IRQ_ROUTING

-- 
Vitaly

