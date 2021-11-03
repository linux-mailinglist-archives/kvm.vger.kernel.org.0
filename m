Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDE7444469C
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 18:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233067AbhKCRIz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 13:08:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60528 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233009AbhKCRIv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Nov 2021 13:08:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635959174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ySY8z1FvkUOe47wyqKp9BdmKtYcnmnVTTc2sCq1epVE=;
        b=BV+QreZ/ejaMx+FcIEz4S7wyOHqIg89GzT9ccNIVrIGFrMxDkpgLpfRQO62lZ1Lhw3I+yn
        AxKKKnMDJvGaR9cgUfUXGfsi8JUyRnNpQfBczepYBQraJ+3ZRKmIqFtOKiLq4daByIDDWh
        ErZh814frQo6QTikx+yhOrwm+Em+sHQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-XH-8IRQvNZ26ZsPfka-KdA-1; Wed, 03 Nov 2021 13:06:13 -0400
X-MC-Unique: XH-8IRQvNZ26ZsPfka-KdA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0979E101875B;
        Wed,  3 Nov 2021 17:05:52 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2BC7568D7D;
        Wed,  3 Nov 2021 17:05:47 +0000 (UTC)
Message-ID: <5491dbdd3e04bfa71869f408d7225fdbaa3252e0.camel@redhat.com>
Subject: Re: [PATCH v5 7/7] nSVM: use vmcb_ctrl_area_cached instead of
 vmcb_control_area in struct svm_nested_state
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Date:   Wed, 03 Nov 2021 19:05:46 +0200
In-Reply-To: <20211103140527.752797-8-eesposit@redhat.com>
References: <20211103140527.752797-1-eesposit@redhat.com>
         <20211103140527.752797-8-eesposit@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-11-03 at 10:05 -0400, Emanuele Giuseppe Esposito wrote:
> This requires changing all vmcb_is_intercept(&svm->nested.ctl, ...)
> calls with vmcb12_is_intercept().
> 
> In addition, in svm_get_nested_state() user space expects a
> vmcb_control_area struct, so we need to copy back all fields
> in a temporary structure to provide to the user space.
> 
> Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
> ---
>  arch/x86/kvm/svm/nested.c | 48 +++++++++++++++++++++++++--------------
>  arch/x86/kvm/svm/svm.c    |  4 ++--
>  arch/x86/kvm/svm/svm.h    |  8 +++----
>  3 files changed, 37 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index cd15d5373c05..6281d1877211 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -58,8 +58,9 @@ static void svm_inject_page_fault_nested(struct kvm_vcpu *vcpu, struct x86_excep
>         struct vcpu_svm *svm = to_svm(vcpu);
>         WARN_ON(!is_guest_mode(vcpu));
>  
> -       if (vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_EXCEPTION_OFFSET + PF_VECTOR) &&
> -	   !svm->nested.nested_run_pending) {
> +	if (vmcb12_is_intercept(&svm->nested.ctl,
> +				INTERCEPT_EXCEPTION_OFFSET + PF_VECTOR) &&
> +	    !svm->nested.nested_run_pending) {
>                 svm->vmcb->control.exit_code = SVM_EXIT_EXCP_BASE + PF_VECTOR;
>                 svm->vmcb->control.exit_code_hi = 0;
>                 svm->vmcb->control.exit_info_1 = fault->error_code;
> @@ -121,7 +122,8 @@ static void nested_svm_uninit_mmu_context(struct kvm_vcpu *vcpu)
>  
>  void recalc_intercepts(struct vcpu_svm *svm)
>  {
> -	struct vmcb_control_area *c, *h, *g;
> +	struct vmcb_control_area *c, *h;
> +	struct vmcb_ctrl_area_cached *g;
>  	unsigned int i;
>  
>  	vmcb_mark_dirty(svm->vmcb, VMCB_INTERCEPTS);
> @@ -172,7 +174,7 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
>  	 */
>  	int i;
>  
> -	if (!(vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_MSR_PROT)))
> +	if (!(vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_MSR_PROT)))
>  		return true;
>  
>  	for (i = 0; i < MSRPM_OFFSETS; i++) {
> @@ -220,9 +222,9 @@ static bool nested_svm_check_tlb_ctl(struct kvm_vcpu *vcpu, u8 tlb_ctl)
>  }
>  
>  static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
> -				       struct vmcb_control_area *control)
> +				       struct vmcb_ctrl_area_cached *control)
>  {
> -	if (CC(!vmcb_is_intercept(control, INTERCEPT_VMRUN)))
> +	if (CC(!vmcb12_is_intercept(control, INTERCEPT_VMRUN)))
>  		return false;
>  
>  	if (CC(control->asid == 0))
> @@ -288,7 +290,7 @@ static bool nested_vmcb_check_save(struct kvm_vcpu *vcpu)
>  }
>  
>  static
> -void _nested_copy_vmcb_control_to_cache(struct vmcb_control_area *to,
> +void _nested_copy_vmcb_control_to_cache(struct vmcb_ctrl_area_cached *to,
>  					struct vmcb_control_area *from)
>  {
>  	unsigned int i;
> @@ -998,7 +1000,7 @@ static int nested_svm_exit_handled_msr(struct vcpu_svm *svm)
>  	u32 offset, msr, value;
>  	int write, mask;
>  
> -	if (!(vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_MSR_PROT)))
> +	if (!(vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_MSR_PROT)))
>  		return NESTED_EXIT_HOST;
>  
>  	msr    = svm->vcpu.arch.regs[VCPU_REGS_RCX];
> @@ -1025,7 +1027,7 @@ static int nested_svm_intercept_ioio(struct vcpu_svm *svm)
>  	u8 start_bit;
>  	u64 gpa;
>  
> -	if (!(vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_IOIO_PROT)))
> +	if (!(vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_IOIO_PROT)))
>  		return NESTED_EXIT_HOST;
>  
>  	port = svm->vmcb->control.exit_info_1 >> 16;
> @@ -1056,12 +1058,12 @@ static int nested_svm_intercept(struct vcpu_svm *svm)
>  		vmexit = nested_svm_intercept_ioio(svm);
>  		break;
>  	case SVM_EXIT_READ_CR0 ... SVM_EXIT_WRITE_CR8: {
> -		if (vmcb_is_intercept(&svm->nested.ctl, exit_code))
> +		if (vmcb12_is_intercept(&svm->nested.ctl, exit_code))
>  			vmexit = NESTED_EXIT_DONE;
>  		break;
>  	}
>  	case SVM_EXIT_READ_DR0 ... SVM_EXIT_WRITE_DR7: {
> -		if (vmcb_is_intercept(&svm->nested.ctl, exit_code))
> +		if (vmcb12_is_intercept(&svm->nested.ctl, exit_code))
>  			vmexit = NESTED_EXIT_DONE;
>  		break;
>  	}
> @@ -1079,7 +1081,7 @@ static int nested_svm_intercept(struct vcpu_svm *svm)
>  		break;
>  	}
>  	default: {
> -		if (vmcb_is_intercept(&svm->nested.ctl, exit_code))
> +		if (vmcb12_is_intercept(&svm->nested.ctl, exit_code))
>  			vmexit = NESTED_EXIT_DONE;
>  	}
>  	}
> @@ -1157,7 +1159,7 @@ static void nested_svm_inject_exception_vmexit(struct vcpu_svm *svm)
>  
>  static inline bool nested_exit_on_init(struct vcpu_svm *svm)
>  {
> -	return vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_INIT);
> +	return vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_INIT);
>  }
>  
>  static int svm_check_nested_events(struct kvm_vcpu *vcpu)
> @@ -1300,6 +1302,8 @@ static int svm_get_nested_state(struct kvm_vcpu *vcpu,
>  				u32 user_data_size)
>  {
>  	struct vcpu_svm *svm;
> +	struct vmcb_control_area *ctl;
> +	unsigned long r;
>  	struct kvm_nested_state kvm_state = {
>  		.flags = 0,
>  		.format = KVM_STATE_NESTED_FORMAT_SVM,
> @@ -1341,9 +1345,18 @@ static int svm_get_nested_state(struct kvm_vcpu *vcpu,
>  	 */
>  	if (clear_user(user_vmcb, KVM_STATE_NESTED_SVM_VMCB_SIZE))
>  		return -EFAULT;
> -	if (copy_to_user(&user_vmcb->control, &svm->nested.ctl,
> -			 sizeof(user_vmcb->control)))
> +
> +	ctl = kzalloc(sizeof(*ctl), GFP_KERNEL);
> +	if (!ctl)
> +		return -ENOMEM;
> +
> +	nested_copy_vmcb_cache_to_control(ctl, &svm->nested.ctl);
> +	r = copy_to_user(&user_vmcb->control, ctl,
> +			 sizeof(user_vmcb->control));
> +	kfree(ctl);
> +	if (r)
>  		return -EFAULT;
> +
>  	if (copy_to_user(&user_vmcb->save, &svm->vmcb01.ptr->save,
>  			 sizeof(user_vmcb->save)))
>  		return -EFAULT;
> @@ -1361,6 +1374,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>  	struct vmcb_control_area *ctl;
>  	struct vmcb_save_area *save;
>  	struct vmcb_save_area_cached save_cached;
> +	struct vmcb_ctrl_area_cached ctl_cached;
>  	unsigned long cr0;
>  	int ret;
>  
> @@ -1413,7 +1427,8 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>  		goto out_free;
>  
>  	ret = -EINVAL;
> -	if (!nested_vmcb_check_controls(vcpu, ctl))
> +	_nested_copy_vmcb_control_to_cache(&ctl_cached, ctl);
> +	if (!nested_vmcb_check_controls(vcpu, &ctl_cached))
>  		goto out_free;
>  
>  	/*
> @@ -1470,7 +1485,6 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>  	svm->nested.vmcb12_gpa = kvm_state->hdr.svm.vmcb_pa;
>  
>  	svm_copy_vmrun_state(&svm->vmcb01.ptr->save, save);
> -	nested_copy_vmcb_control_to_cache(svm, ctl);
You should keep this line of code, to actualy load the control area,

The whole copying to 'cache' is a bit ugly here, but let it be,
as there is no other way around and the uglyness is only limited to those two functions
(svm_get_nested_state/svm_set_nested_state).


I am currently testing your patches with the above change reverted. 
Seems to pass at least my basic test so far.

Thanks,
Best regards,
	Maxim Levitsky


>  
>  	svm_switch_vmcb(svm, &svm->nested.vmcb02);
>  	nested_vmcb02_prepare_control(svm);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 74d6db9017ea..134205678462 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2506,7 +2506,7 @@ static bool check_selective_cr0_intercepted(struct kvm_vcpu *vcpu,
>  	bool ret = false;
>  
>  	if (!is_guest_mode(vcpu) ||
> -	    (!(vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_SELECTIVE_CR0))))
> +	    (!(vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_SELECTIVE_CR0))))
>  		return false;
>  
>  	cr0 &= ~SVM_CR0_SELECTIVE_MASK;
> @@ -4218,7 +4218,7 @@ static int svm_check_intercept(struct kvm_vcpu *vcpu,
>  		    info->intercept == x86_intercept_clts)
>  			break;
>  
> -		if (!(vmcb_is_intercept(&svm->nested.ctl,
> +		if (!(vmcb12_is_intercept(&svm->nested.ctl,
>  					INTERCEPT_SELECTIVE_CR0)))
>  			break;
>  
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index e29423d4337c..a896a52417ee 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -156,7 +156,7 @@ struct svm_nested_state {
>  	bool nested_run_pending;
>  
>  	/* cache for control fields of the guest */
> -	struct vmcb_control_area ctl;
> +	struct vmcb_ctrl_area_cached ctl;
>  	struct vmcb_save_area_cached save;
>  
>  	bool initialized;
> @@ -494,17 +494,17 @@ static inline bool nested_svm_virtualize_tpr(struct kvm_vcpu *vcpu)
>  
>  static inline bool nested_exit_on_smi(struct vcpu_svm *svm)
>  {
> -	return vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_SMI);
> +	return vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_SMI);
>  }
>  
>  static inline bool nested_exit_on_intr(struct vcpu_svm *svm)
>  {
> -	return vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_INTR);
> +	return vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_INTR);
>  }
>  
>  static inline bool nested_exit_on_nmi(struct vcpu_svm *svm)
>  {
> -	return vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_NMI);
> +	return vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_NMI);
>  }
>  
>  int enter_svm_guest_mode(struct kvm_vcpu *vcpu,


