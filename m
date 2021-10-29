Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81EFF43FB1E
	for <lists+kvm@lfdr.de>; Fri, 29 Oct 2021 12:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbhJ2LAW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Oct 2021 07:00:22 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:33178 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231861AbhJ2LAT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 Oct 2021 07:00:19 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=houwenlong93@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0Uu7vr4d_1635505069;
Received: from localhost(mailfrom:houwenlong93@linux.alibaba.com fp:SMTPD_---0Uu7vr4d_1635505069)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 29 Oct 2021 18:57:49 +0800
Date:   Fri, 29 Oct 2021 18:57:49 +0800
From:   Hou Wenlong <houwenlong93@linux.alibaba.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: VMX: fix instruction skipping when handling UD
 exception
Message-ID: <20211029105749.GA113630@k08j02272.eu95sqa>
References: <cover.1634870747.git.houwenlong93@linux.alibaba.com>
 <8ad4de9dae77ee3690ee9bd3c5a51d235d619eb6.1634870747.git.houwenlong93@linux.alibaba.com>
 <YXgu3pvk+Ifrl0Yu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXgu3pvk+Ifrl0Yu@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 26, 2021 at 04:37:50PM +0000, Sean Christopherson wrote:
> On Fri, Oct 22, 2021, Hou Wenlong wrote:
> > When kvm.force_emulation_prefix is enabled, instruction with
> > kvm prefix would trigger an UD exception and do instruction
> > emulation. The emulation may need to exit to userspace due
> > to userspace io, and the complete_userspace_io callback may
> > skip instruction, i.e. MSR accesses emulation would exit to
> > userspace if userspace wanted to know about the MSR fault.
> > However, VM_EXIT_INSTRUCTION_LEN in vmcs is invalid now, it
> > should use kvm_emulate_instruction() to skip instruction.
> > 
> > Signed-off-by: Hou Wenlong <houwenlong93@linux.alibaba.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 4 ++--
> >  arch/x86/kvm/vmx/vmx.h | 9 +++++++++
> >  2 files changed, 11 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 1c8b2b6e7ed9..01049d65da26 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -1501,8 +1501,8 @@ static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
> >  	 * (namely Hyper-V) don't set it due to it being undefined behavior,
> >  	 * i.e. we end up advancing IP with some random value.
> >  	 */
> > -	if (!static_cpu_has(X86_FEATURE_HYPERVISOR) ||
> > -	    exit_reason.basic != EXIT_REASON_EPT_MISCONFIG) {
> > +	if (!is_ud_exit(vcpu) && (!static_cpu_has(X86_FEATURE_HYPERVISOR) ||
> 
> This is incomplete and is just a workaround for the underlying bug.  The same
> mess can occur if the emulator triggers an exit to userspace during "normal"
> emulation, e.g. if unrestricted guest is disabled and the guest accesses an MSR
> while in Big RM.  In that case, there's no #UD to key off of.
> 
> The correct way to fix this is to attach a different callback when the MSR access
> comes from the emulator.  I'd say rename the existing complete_emulated_{rd,wr}msr()
> callbacks to complete_fast_{rd,wr}msr() to match the port I/O nomenclature.
> 
> Something like this (which also has some opportunistic simplification of the
> error handling in kvm_emulate_{rd,wr}msr()).
> 
> ---
>  arch/x86/kvm/x86.c | 82 +++++++++++++++++++++++++---------------------
>  1 file changed, 45 insertions(+), 37 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ac83d873d65b..7ff5b8d58ca3 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1814,18 +1814,44 @@ int kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data)
>  }
>  EXPORT_SYMBOL_GPL(kvm_set_msr);
> 
> -static int complete_emulated_rdmsr(struct kvm_vcpu *vcpu)
> +static void __complete_emulated_rdmsr(struct kvm_vcpu *vcpu)
>  {
> -	int err = vcpu->run->msr.error;
> -	if (!err) {
> +	if (!vcpu->run->msr.error) {
>  		kvm_rax_write(vcpu, (u32)vcpu->run->msr.data);
>  		kvm_rdx_write(vcpu, vcpu->run->msr.data >> 32);
>  	}
> +}
> 
> -	return static_call(kvm_x86_complete_emulated_msr)(vcpu, err);
> +static int complete_emulated_msr_access(struct kvm_vcpu *vcpu)
> +{
> +	if (vcpu->run->msr.error) {
> +		kvm_inject_gp(vcpu, 0);
> +		return 1;
> +	}
> +
> +	return kvm_emulate_instruction(vcpu, EMULTYPE_SKIP);
> +}
> +
> +static int complete_emulated_rdmsr(struct kvm_vcpu *vcpu)
> +{
> +	__complete_emulated_rdmsr(vcpu);
> +
> +	return complete_emulated_msr_access(vcpu);
>  }
> 
>  static int complete_emulated_wrmsr(struct kvm_vcpu *vcpu)
> +{
> +	return complete_emulated_msr_access(vcpu);
> +}
> +
> +static int complete_fast_rdmsr(struct kvm_vcpu *vcpu)
> +{
> +	__complete_emulated_rdmsr(vcpu);
> +
> +	return static_call(kvm_x86_complete_emulated_msr)(vcpu, vcpu->run->msr.error);
> +}
> +
> +static int complete_fast_wrmsr(struct kvm_vcpu *vcpu)
>  {
>  	return static_call(kvm_x86_complete_emulated_msr)(vcpu, vcpu->run->msr.error);
>  }
> @@ -1864,18 +1890,6 @@ static int kvm_msr_user_space(struct kvm_vcpu *vcpu, u32 index,
>  	return 1;
>  }
> 
> -static int kvm_get_msr_user_space(struct kvm_vcpu *vcpu, u32 index, int r)
> -{
> -	return kvm_msr_user_space(vcpu, index, KVM_EXIT_X86_RDMSR, 0,
> -				   complete_emulated_rdmsr, r);
> -}
> -
> -static int kvm_set_msr_user_space(struct kvm_vcpu *vcpu, u32 index, u64 data, int r)
> -{
> -	return kvm_msr_user_space(vcpu, index, KVM_EXIT_X86_WRMSR, data,
> -				   complete_emulated_wrmsr, r);
> -}
> -
>  int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu)
>  {
>  	u32 ecx = kvm_rcx_read(vcpu);
> @@ -1883,19 +1897,15 @@ int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu)
>  	int r;
> 
>  	r = kvm_get_msr(vcpu, ecx, &data);
> -
> -	/* MSR read failed? See if we should ask user space */
> -	if (r && kvm_get_msr_user_space(vcpu, ecx, r)) {
> -		/* Bounce to user space */
> -		return 0;
> -	}
> -
>  	if (!r) {
>  		trace_kvm_msr_read(ecx, data);
> 
>  		kvm_rax_write(vcpu, data & -1u);
>  		kvm_rdx_write(vcpu, (data >> 32) & -1u);
>  	} else {
> +		if (kvm_msr_user_space(vcpu, ecx, KVM_EXIT_X86_RDMSR, 0,
> +				       complete_fast_rdmsr, r))
> +			return 0;
>  		trace_kvm_msr_read_ex(ecx);
>  	}
> 
> @@ -1910,20 +1920,16 @@ int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
>  	int r;
> 
>  	r = kvm_set_msr(vcpu, ecx, data);
> -
> -	/* MSR write failed? See if we should ask user space */
> -	if (r && kvm_set_msr_user_space(vcpu, ecx, data, r))
> -		/* Bounce to user space */
> -		return 0;
> -
> -	/* Signal all other negative errors to userspace */
> -	if (r < 0)
> -		return r;
> -
> -	if (!r)
> +	if (!r) {
>  		trace_kvm_msr_write(ecx, data);
> -	else
> +	} else {
> +		if (kvm_msr_user_space(vcpu, ecx, KVM_EXIT_X86_WRMSR, data,
> +				       complete_fast_wrmsr, r))
> +			return 0;
> +		if (r < 0)
> +			return r;
>  		trace_kvm_msr_write_ex(ecx, data);
> +	}
> 
>  	return static_call(kvm_x86_complete_emulated_msr)(vcpu, r);
>  }
> @@ -7387,7 +7393,8 @@ static int emulator_get_msr(struct x86_emulate_ctxt *ctxt,
> 
>  	r = kvm_get_msr(vcpu, msr_index, pdata);
> 
> -	if (r && kvm_get_msr_user_space(vcpu, msr_index, r)) {
> +	if (r && kvm_msr_user_space(vcpu, msr_index, KVM_EXIT_X86_RDMSR, 0,
> +				    complete_emulated_rdmsr, r)) {
>  		/* Bounce to user space */
>  		return X86EMUL_IO_NEEDED;
>  	}
> @@ -7403,7 +7410,8 @@ static int emulator_set_msr(struct x86_emulate_ctxt *ctxt,
> 
>  	r = kvm_set_msr(vcpu, msr_index, data);
> 
> -	if (r && kvm_set_msr_user_space(vcpu, msr_index, data, r)) {
> +	if (r && kvm_msr_user_space(vcpu, msr_index, KVM_EXIT_X86_WRMSR, data,
> +				    complete_emulated_wrmsr, r)) {
>  		/* Bounce to user space */
>  		return X86EMUL_IO_NEEDED;
>  	}
> --
Hi Sean,

The note in x86_emulate_instruction() for EMULTYPE_SKIP said that the
caller should be responsible for updating interruptibility state and
injecting single-step #DB. And vendor callbacks for
kvm_skip_emulated_instruction() also do some special things, e.g.
I found that sev_es guest just skips RIP updating. So it may be
more appropriate to add a parameter for skip_emulated_instruction()
callback, which force to use x86_skip_instruction() if the instruction
length is invalid.

Thanks
