Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C193437947
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 16:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233264AbhJVOuu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 10:50:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28039 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233262AbhJVOuo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Oct 2021 10:50:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634914106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b8OiQsWc/Wy+EULkxiJalfbMVfARLsKJj7LgXt2G5wM=;
        b=UF+yYKS9Ty6716BgrCOHn7EDuX1XCio56PEviscqmDqRfN3UP6u9cmJse3X/Jqoo+UgWIO
        s6VjP8ep+x3q2NeVUiZQ+UfRK0CzQHzX/InScO+ikJB+IfYhTZRoTWIeebMDxgrWQjYmM9
        v3PLbUBS5VRV/2S98xr5ndu4ALdlLfs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-436-BlDrk2dJMeCG19zI6Ib7hw-1; Fri, 22 Oct 2021 10:48:25 -0400
X-MC-Unique: BlDrk2dJMeCG19zI6Ib7hw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A3D1804B6C;
        Fri, 22 Oct 2021 14:48:23 +0000 (UTC)
Received: from starship (unknown [10.40.192.246])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 508B460657;
        Fri, 22 Oct 2021 14:48:17 +0000 (UTC)
Message-ID: <815fa9d32621244331dfe630a28f3cbf84042ec1.camel@redhat.com>
Subject: Re: [PATCH v3 4/8] nSVM: use vmcb_save_area_cached in
 nested_vmcb_valid_sregs()
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
Date:   Fri, 22 Oct 2021 17:48:16 +0300
In-Reply-To: <20211011143702.1786568-5-eesposit@redhat.com>
References: <20211011143702.1786568-1-eesposit@redhat.com>
         <20211011143702.1786568-5-eesposit@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-10-11 at 10:36 -0400, Emanuele Giuseppe Esposito wrote:
> Now that struct vmcb_save_area_cached contains the required
> vmcb fields values (done in nested_load_save_from_vmcb12()),
> check them to see if they are correct in nested_vmcb_valid_sregs().
> 
> Since we are always checking for the nested struct, it is enough
> to have only the vcpu as parameter.
> 
> Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
> ---
>  arch/x86/kvm/svm/nested.c | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index f6030a202bc5..d07cd4b88acd 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -230,9 +230,10 @@ static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
>  }
>  
>  /* Common checks that apply to both L1 and L2 state.  */
> -static bool nested_vmcb_valid_sregs(struct kvm_vcpu *vcpu,
> -				    struct vmcb_save_area *save)
> +static bool nested_vmcb_valid_sregs(struct kvm_vcpu *vcpu)
>  {
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +	struct vmcb_save_area_cached *save = &svm->nested.save;
>  	/*
>  	 * FIXME: these should be done after copying the fields,
>  	 * to avoid TOC/TOU races.  For these save area checks
> @@ -658,7 +659,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
>  	nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
>  	nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
>  
> -	if (!nested_vmcb_valid_sregs(vcpu, &vmcb12->save) ||
> +	if (!nested_vmcb_valid_sregs(vcpu) ||
>  	    !nested_vmcb_check_controls(vcpu, &svm->nested.ctl)) {
>  		vmcb12->control.exit_code    = SVM_EXIT_ERR;
>  		vmcb12->control.exit_code_hi = 0;
> @@ -1355,11 +1356,12 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>  	 * Validate host state saved from before VMRUN (see
>  	 * nested_svm_check_permissions).
>  	 */
> +	nested_copy_vmcb_save_to_cache(svm, save);


>  	if (!(save->cr0 & X86_CR0_PG) ||
>  	    !(save->cr0 & X86_CR0_PE) ||
>  	    (save->rflags & X86_EFLAGS_VM) ||
> -	    !nested_vmcb_valid_sregs(vcpu, save))
> -		goto out_free;
> +	    !nested_vmcb_valid_sregs(vcpu))
> +		goto out_free_save;

The two changes from above can't be done like that sadly.

We cache only vmcb12 because it comes from the guest which is untrusted.

Here we validate the L1's saved host state which is (once again,
SVM nested state is confused), the 'save' variable.
That state is not guest controlled, but here we validate it
to avoid trusting the KVM_SET_NESTED_STATE caller.

I guess we can copy this to an extra 'struct vmcb_save_area_cached' on stack (this struct is small),
and then pass its address to nested_vmcb_valid_sregs (or better to __nested_vmcb_valid_sregs,
so that nested_vmcb_valid_sregs could still take one parameter, but delegate
its work to __nested_vmcb_valid_sregs with two parameters.

>  
>  	/*
>  	 * While the nested guest CR3 is already checked and set by
> @@ -1371,7 +1373,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>  	ret = nested_svm_load_cr3(&svm->vcpu, vcpu->arch.cr3,
>  				  nested_npt_enabled(svm), false);
>  	if (WARN_ON_ONCE(ret))
> -		goto out_free;
> +		goto out_free_save;
>  
>  
>  	/*
> @@ -1395,12 +1397,15 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
>  
>  	svm_copy_vmrun_state(&svm->vmcb01.ptr->save, save);
>  	nested_copy_vmcb_control_to_cache(svm, ctl);
> -	nested_copy_vmcb_save_to_cache(svm, save);
>  
>  	svm_switch_vmcb(svm, &svm->nested.vmcb02);
>  	nested_vmcb02_prepare_control(svm);
>  	kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
>  	ret = 0;
> +
> +out_free_save:
> +	memset(&svm->nested.save, 0, sizeof(struct vmcb_save_area_cached));
> +

This won't be needed if we don't touch svm->nested.save.

>  out_free:
>  	kfree(save);
>  	kfree(ctl);


Best regards,
	Maxim Levitsky

