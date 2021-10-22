Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 203A1437931
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 16:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233086AbhJVOtG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 10:49:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26683 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232936AbhJVOtF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Oct 2021 10:49:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634914007;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RNDtmI1Kaa7l1fxrz7IM8nlhCEa9GrCf+RG8eas7Usg=;
        b=WEkxn+jqyoEN87h89+YATqESSrt0cGfkijCzl7jKERU2hvR5wzWHFVgn9unXd1BozFobC5
        W61PuQ+/0FzgcNexYaeZY6/g949Joyye/p7r7qDkMVaNIZtY0riEl9ul1G2AxHUGQndRHj
        IusrPU92cCPJN3HiQGkuq0NhEZCL70Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-Th7HulMxPGSx24Wh86rjOQ-1; Fri, 22 Oct 2021 10:46:44 -0400
X-MC-Unique: Th7HulMxPGSx24Wh86rjOQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F1C13835B48;
        Fri, 22 Oct 2021 14:46:42 +0000 (UTC)
Received: from starship (unknown [10.40.192.246])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DDB325C1D5;
        Fri, 22 Oct 2021 14:46:37 +0000 (UTC)
Message-ID: <b028668aaa10a33e0f167c438dc6292d894904c4.camel@redhat.com>
Subject: Re: [PATCH v3 3/8] nSVM: rename nested_load_control_from_vmcb12 in
 nested_copy_vmcb_control_to_cache
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
Date:   Fri, 22 Oct 2021 17:46:36 +0300
In-Reply-To: <20211011143702.1786568-4-eesposit@redhat.com>
References: <20211011143702.1786568-1-eesposit@redhat.com>
         <20211011143702.1786568-4-eesposit@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-10-11 at 10:36 -0400, Emanuele Giuseppe Esposito wrote:
> Following the same naming convention of the previous patch,
> rename nested_load_control_from_vmcb12.
> In addition, inline copy_vmcb_control_area as it is only called
> by this function.

> 
> Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
> ---
>  arch/x86/kvm/svm/nested.c | 67 ++++++++++++++++++---------------------
>  arch/x86/kvm/svm/svm.c    |  2 +-
>  arch/x86/kvm/svm/svm.h    |  2 +-
>  3 files changed, 32 insertions(+), 39 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index c4959da8aec0..f6030a202bc5 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -163,37 +163,6 @@ void recalc_intercepts(struct vcpu_svm *svm)
>  	vmcb_set_intercept(c, INTERCEPT_VMSAVE);
>  }
>  
> -static void copy_vmcb_control_area(struct vmcb_control_area *dst,
> -				   struct vmcb_control_area *from)
> -{
> -	unsigned int i;
> -
> -	for (i = 0; i < MAX_INTERCEPT; i++)
> -		dst->intercepts[i] = from->intercepts[i];
> -
> -	dst->iopm_base_pa         = from->iopm_base_pa;
> -	dst->msrpm_base_pa        = from->msrpm_base_pa;
> -	dst->tsc_offset           = from->tsc_offset;
> -	/* asid not copied, it is handled manually for svm->vmcb.  */
> -	dst->tlb_ctl              = from->tlb_ctl;
> -	dst->int_ctl              = from->int_ctl;
> -	dst->int_vector           = from->int_vector;
> -	dst->int_state            = from->int_state;
> -	dst->exit_code            = from->exit_code;
> -	dst->exit_code_hi         = from->exit_code_hi;
> -	dst->exit_info_1          = from->exit_info_1;
> -	dst->exit_info_2          = from->exit_info_2;
> -	dst->exit_int_info        = from->exit_int_info;
> -	dst->exit_int_info_err    = from->exit_int_info_err;
> -	dst->nested_ctl           = from->nested_ctl;
> -	dst->event_inj            = from->event_inj;
> -	dst->event_inj_err        = from->event_inj_err;
> -	dst->nested_cr3           = from->nested_cr3;
> -	dst->virt_ext              = from->virt_ext;
> -	dst->pause_filter_count   = from->pause_filter_count;
> -	dst->pause_filter_thresh  = from->pause_filter_thresh;
> -}
> -
>  static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
>  {
>  	/*
> @@ -302,12 +271,36 @@ static bool nested_vmcb_valid_sregs(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> -void nested_load_control_from_vmcb12(struct vcpu_svm *svm,
> -				     struct vmcb_control_area *control)
> +void nested_copy_vmcb_control_to_cache(struct vcpu_svm *svm,
> +				       struct vmcb_control_area *control)
>  {
> -	copy_vmcb_control_area(&svm->nested.ctl, control);
> +	unsigned int i;
>  
> -	/* Copy it here because nested_svm_check_controls will check it.  */
> +	for (i = 0; i < MAX_INTERCEPT; i++)
> +		svm->nested.ctl.intercepts[i] = control->intercepts[i];
> +
> +	svm->nested.ctl.iopm_base_pa        = control->iopm_base_pa;
> +	svm->nested.ctl.msrpm_base_pa       = control->msrpm_base_pa;
> +	svm->nested.ctl.tsc_offset          = control->tsc_offset;
> +	svm->nested.ctl.tlb_ctl             = control->tlb_ctl;
> +	svm->nested.ctl.int_ctl             = control->int_ctl;
> +	svm->nested.ctl.int_vector          = control->int_vector;
> +	svm->nested.ctl.int_state           = control->int_state;
> +	svm->nested.ctl.exit_code           = control->exit_code;
> +	svm->nested.ctl.exit_code_hi        = control->exit_code_hi;
> +	svm->nested.ctl.exit_info_1         = control->exit_info_1;
> +	svm->nested.ctl.exit_info_2         = control->exit_info_2;
> +	svm->nested.ctl.exit_int_info       = control->exit_int_info;
> +	svm->nested.ctl.exit_int_info_err   = control->exit_int_info_err;
> +	svm->nested.ctl.nested_ctl          = control->nested_ctl;
> +	svm->nested.ctl.event_inj           = control->event_inj;
> +	svm->nested.ctl.event_inj_err       = control->event_inj_err;
> +	svm->nested.ctl.nested_cr3          = control->nested_cr3;
> +	svm->nested.ctl.virt_ext            = control->virt_ext;
> +	svm->nested.ctl.pause_filter_count  = control->pause_filter_count;
> +	svm->nested.ctl.pause_filter_thresh = control->pause_filter_thresh;
> +
> +	/* Copy asid here because nested_vmcb_check_controls will check it.  */
>  	svm->nested.ctl.asid           = control->asid;
>  	svm->nested.ctl.msrpm_base_pa &= ~0x0fffULL;
>  	svm->nested.ctl.iopm_base_pa  &= ~0x0fffULL;
> @@ -662,7 +655,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
>  	if (WARN_ON_ONCE(!svm->nested.initialized))
>  		return -EINVAL;
>  
> -	nested_load_control_from_vmcb12(svm, &vmcb12->control);
> +	nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
>  	nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
>  
>  	if (!nested_vmcb_valid_sregs(vcpu, &vmcb12->save) ||
> @@ -1401,7 +1394,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>  	svm->nested.vmcb12_gpa = kvm_state->hdr.svm.vmcb_pa;
>  
>  	svm_copy_vmrun_state(&svm->vmcb01.ptr->save, save);
> -	nested_load_control_from_vmcb12(svm, ctl);
> +	nested_copy_vmcb_control_to_cache(svm, ctl);
>  	nested_copy_vmcb_save_to_cache(svm, save);
>  
>  	svm_switch_vmcb(svm, &svm->nested.vmcb02);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index bf171f5f6158..1b6d25c6e0ae 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4385,7 +4385,7 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
>  
>  			vmcb12 = map.hva;
>  
> -			nested_load_control_from_vmcb12(svm, &vmcb12->control);
> +			nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
>  			nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
>  
>  			ret = enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12);
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index f0195bc263e9..3c950aeca646 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -496,7 +496,7 @@ int nested_svm_check_permissions(struct kvm_vcpu *vcpu);
>  int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
>  			       bool has_error_code, u32 error_code);
>  int nested_svm_exit_special(struct vcpu_svm *svm);
> -void nested_load_control_from_vmcb12(struct vcpu_svm *svm,
> +void nested_copy_vmcb_control_to_cache(struct vcpu_svm *svm,
>  				     struct vmcb_control_area *control);
>  void nested_copy_vmcb_save_to_cache(struct vcpu_svm *svm,
>  				  struct vmcb_save_area *save);


Looks great!

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

