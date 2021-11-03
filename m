Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 962F7444688
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 18:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233042AbhKCRFm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 13:05:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58070 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232969AbhKCRFl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Nov 2021 13:05:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635958984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QrRmGVF1h5sT+EiXZiJeSIoEBq6T7Fh3KxMTJt9AHos=;
        b=F8/kAAObe5W1B9PZkZQDCCg8AkROOKz1YMiIUTYCzEsdpy1qd+FmSjCEoad3hfmtu+1k1l
        l0a0Ra7WPZnyav9exTb7Eot0ydUedAhUyq9Hh05AcPilW0XKaPUTyFtWJmZomaM1iXgVPl
        dO//KSVt2vYtDDfMmGvzb5XOQLvD0rU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-Hb0P2fPZOxWH3BvHE08raw-1; Wed, 03 Nov 2021 13:03:01 -0400
X-MC-Unique: Hb0P2fPZOxWH3BvHE08raw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 423B91006AA2;
        Wed,  3 Nov 2021 17:02:59 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6D65B60C05;
        Wed,  3 Nov 2021 17:02:55 +0000 (UTC)
Message-ID: <88fc4a2463db6daff52b3f4c2be7d6c76c42fb6e.camel@redhat.com>
Subject: Re: [PATCH v5 2/7] nSVM: introduce smv->nested.save to cache save
 area fields
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
Date:   Wed, 03 Nov 2021 19:02:54 +0200
In-Reply-To: <20211103140527.752797-3-eesposit@redhat.com>
References: <20211103140527.752797-1-eesposit@redhat.com>
         <20211103140527.752797-3-eesposit@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-11-03 at 10:05 -0400, Emanuele Giuseppe Esposito wrote:
> This is useful in next patch, to avoid having temporary
> copies of vmcb12 registers and passing them manually.
> 
> Right now, instead of blindly copying everything,
> we just copy EFER, CR0, CR3, CR4, DR6 and DR7. If more fields
> will need to be added, it will be more obvious to see
> that they must be added in struct vmcb_save_area_cached and
> in nested_copy_vmcb_save_to_cache().
> 
> _nested_copy_vmcb_save_to_cache() takes a vmcb_save_area_cached
> parameter, useful when we want to save the state to a local
> variable instead of svm internals.
> 
> Note that in svm_set_nested_state() we want to cache the L2
> save state only if we are in normal non guest mode, because
> otherwise it is not touched.
> 
> Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
> ---
>  arch/x86/kvm/svm/nested.c | 27 ++++++++++++++++++++++++++-
>  arch/x86/kvm/svm/svm.c    |  1 +
>  arch/x86/kvm/svm/svm.h    | 16 ++++++++++++++++
>  3 files changed, 43 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 946c06a25d37..ea64fea371c8 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -328,6 +328,28 @@ void nested_load_control_from_vmcb12(struct vcpu_svm *svm,
>  	svm->nested.ctl.iopm_base_pa  &= ~0x0fffULL;
>  }
>  
> +static void _nested_copy_vmcb_save_to_cache(struct vmcb_save_area_cached *to,
> +					    struct vmcb_save_area *from)
> +{
> +	/*
> +	 * Copy only fields that are validated, as we need them
> +	 * to avoid TOC/TOU races.
> +	 */
> +	to->efer = from->efer;
> +	to->cr0 = from->cr0;
> +	to->cr3 = from->cr3;
> +	to->cr4 = from->cr4;
> +
> +	to->dr6 = from->dr6;
> +	to->dr7 = from->dr7;
> +}
> +
> +void nested_copy_vmcb_save_to_cache(struct vcpu_svm *svm,
> +				    struct vmcb_save_area *save)
> +{
> +	_nested_copy_vmcb_save_to_cache(&svm->nested.save, save);
> +}
> +
>  /*
>   * Synchronize fields that are written by the processor, so that
>   * they can be copied back into the vmcb12.
> @@ -670,6 +692,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
>  		return -EINVAL;
>  
>  	nested_load_control_from_vmcb12(svm, &vmcb12->control);
> +	nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
>  
>  	if (!nested_vmcb_valid_sregs(vcpu, &vmcb12->save) ||
>  	    !nested_vmcb_check_controls(vcpu, &svm->nested.ctl)) {
> @@ -1402,8 +1425,10 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>  
>  	if (is_guest_mode(vcpu))
>  		svm_leave_nested(svm);
> -	else
> +	else {
>  		svm->nested.vmcb02.ptr->save = svm->vmcb01.ptr->save;
> +		nested_copy_vmcb_save_to_cache(svm, &svm->nested.vmcb02.ptr->save);
> +	}
>  
>  	svm_set_gif(svm, !!(kvm_state->flags & KVM_STATE_NESTED_GIF_SET));
>  
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 21bb81710e0f..6e5c2671e823 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4438,6 +4438,7 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
>  
>  	vmcb12 = map.hva;
>  	nested_load_control_from_vmcb12(svm, &vmcb12->control);
> +	nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
>  	ret = enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12, false);
>  
>  unmap_save:
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 0d7bbe548ac3..0897551d8868 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -103,6 +103,19 @@ struct kvm_vmcb_info {
>  	uint64_t asid_generation;
>  };
>  

Nitpick: There is a bit of ambiguity in this comment. I think you mean that
the contents of the svm->nested.save are not always up to date,
but then the comment should be there, where the field is
declared.

I first read this comment as if the fields of this struct are not
up to date vs SVM spec or something.

Also the same can be said about the svm->nested.ctl and such when not
running a nested guest. Maybe we need to drop that coment at all.

> +/*
> + * This struct is not kept up-to-date, and it is only valid within
> + * svm_set_nested_state and nested_svm_vmrun.
> + */
> +struct vmcb_save_area_cached {
> +	u64 efer;
> +	u64 cr4;
> +	u64 cr3;
> +	u64 cr0;
> +	u64 dr7;
> +	u64 dr6;
> +};
> +
>  struct svm_nested_state {
>  	struct kvm_vmcb_info vmcb02;
>  	u64 hsave_msr;
> @@ -119,6 +132,7 @@ struct svm_nested_state {
>  
>  	/* cache for control fields of the guest */
>  	struct vmcb_control_area ctl;
> +	struct vmcb_save_area_cached save;
>  
>  	bool initialized;
>  };
> @@ -490,6 +504,8 @@ void nested_svm_update_tsc_ratio_msr(struct kvm_vcpu *vcpu);
>  void svm_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 multiplier);
>  void nested_load_control_from_vmcb12(struct vcpu_svm *svm,
>  				     struct vmcb_control_area *control);
> +void nested_copy_vmcb_save_to_cache(struct vcpu_svm *svm,
> +				    struct vmcb_save_area *save);
>  void nested_sync_control_from_vmcb02(struct vcpu_svm *svm);
>  void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm);
>  void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb);

Other than the nitpick looks good.


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


