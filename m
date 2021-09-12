Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6835407CED
	for <lists+kvm@lfdr.de>; Sun, 12 Sep 2021 12:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233678AbhILKnp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Sep 2021 06:43:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25102 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229814AbhILKno (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 12 Sep 2021 06:43:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631443350;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kLhgaTfkIpNPMCStZQ5KZVO+z6tKcp6dPDxDqqETIEo=;
        b=J9SB6sGaKsRujNv/G0XPkQTZYgzFtAyoO8v8CFY6mkhEmOv9val9XIAYx1rOqpUBphTiCm
        LrHj8ahN/NDgVH1JaGygjKWUjkk9LlmiOIf2BYibQCSt1H0cbqFC5cIOoqwARt4VoH+rZ6
        EpRqKzPWHCwT3hZfTD1pnurOoP/p4xc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-GWF40BrFMwqgq4cpJSdCXQ-1; Sun, 12 Sep 2021 06:42:29 -0400
X-MC-Unique: GWF40BrFMwqgq4cpJSdCXQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B93D680196C;
        Sun, 12 Sep 2021 10:42:27 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 52B0819E7E;
        Sun, 12 Sep 2021 10:42:24 +0000 (UTC)
Message-ID: <21d2bf8c4e3eb3fc5d297fd13300557ec686b625.camel@redhat.com>
Subject: Re: [RFC PATCH 3/3] nSVM: use svm->nested.save to load vmcb12
 registers and avoid TOC/TOU races
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
Date:   Sun, 12 Sep 2021 13:42:23 +0300
In-Reply-To: <20210903102039.55422-4-eesposit@redhat.com>
References: <20210903102039.55422-1-eesposit@redhat.com>
         <20210903102039.55422-4-eesposit@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-09-03 at 12:20 +0200, Emanuele Giuseppe Esposito wrote:
> Move the checks done by nested_vmcb_valid_sregs and
> nested_vmcb_check_controls directly in enter_svm_guest_mode,
> and use svm->nested.save cached fields (EFER, CR0, CR4)
> instead of vmcb12's.
> This prevents from creating TOC/TOU races.
> 
> This also avoids the need of force-setting EFER_SVME in
> nested_vmcb02_prepare_save.
> 
> Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
> ---
>  arch/x86/kvm/svm/nested.c | 23 ++++++-----------------
>  1 file changed, 6 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 2491c77203c7..487810cfefde 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -280,13 +280,6 @@ static bool nested_vmcb_check_controls(struct kvm_vcpu *vcpu,
>  static bool nested_vmcb_valid_sregs(struct kvm_vcpu *vcpu,
>  				    struct vmcb_save_area *save)
>  {
> -	/*
> -	 * FIXME: these should be done after copying the fields,
> -	 * to avoid TOC/TOU races.  For these save area checks
> -	 * the possible damage is limited since kvm_set_cr0 and
> -	 * kvm_set_cr4 handle failure; EFER_SVME is an exception
> -	 * so it is force-set later in nested_prepare_vmcb_save.
> -	 */
>  	if (CC(!(save->efer & EFER_SVME)))
>  		return false;
>  
> @@ -459,7 +452,8 @@ void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm)
>  	svm->nested.vmcb02.ptr->save.g_pat = svm->vmcb01.ptr->save.g_pat;
>  }
>  
> -static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12)
> +static void nested_vmcb02_prepare_save(struct vcpu_svm *svm,
> +				       struct vmcb *vmcb12)
Tiny nitpick: the kernel these days allow up to 100 characters in a line,
thus this change is not needed IMHO.

>  {
>  	bool new_vmcb12 = false;
>  
> @@ -488,15 +482,10 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
>  
>  	kvm_set_rflags(&svm->vcpu, vmcb12->save.rflags | X86_EFLAGS_FIXED);
>  
> -	/*
> -	 * Force-set EFER_SVME even though it is checked earlier on the
> -	 * VMCB12, because the guest can flip the bit between the check
> -	 * and now.  Clearing EFER_SVME would call svm_free_nested.
> -	 */
> -	svm_set_efer(&svm->vcpu, vmcb12->save.efer | EFER_SVME);
> +	svm_set_efer(&svm->vcpu, svm->nested.save.efer);
>  
> -	svm_set_cr0(&svm->vcpu, vmcb12->save.cr0);
> -	svm_set_cr4(&svm->vcpu, vmcb12->save.cr4);
> +	svm_set_cr0(&svm->vcpu, svm->nested.save.cr0);
> +	svm_set_cr4(&svm->vcpu, svm->nested.save.cr4);
>  
>  	svm->vcpu.arch.cr2 = vmcb12->save.cr2;
>  
> @@ -671,7 +660,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
>  	nested_load_control_from_vmcb12(svm, &vmcb12->control);
>  	nested_load_save_from_vmcb12(svm, &vmcb12->save);
>  
> -	if (!nested_vmcb_valid_sregs(vcpu, &vmcb12->save) ||
> +	if (!nested_vmcb_valid_sregs(vcpu, &svm->nested.save) ||
>  	    !nested_vmcb_check_controls(vcpu, &svm->nested.ctl)) {

If you use a different struct for the copied fields, then it makes
sense IMHO to drop the 'control' parameter from nested_vmcb_check_controls,
and just use the svm->nested.save there directly.

>  		vmcb12->control.exit_code    = SVM_EXIT_ERR;
>  		vmcb12->control.exit_code_hi = 0;


I think you forgot to use svm->nested.save.cr3.
It is used in enter_svm_guest_mode to setup the mmu.

While there are likely no TOC/TOU races in regard to it, it is still
better to be consistent about it.

Looks very good otherwise.

Best regards,
	Maxim Levitsky



