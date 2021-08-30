Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 411B13FB600
	for <lists+kvm@lfdr.de>; Mon, 30 Aug 2021 14:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbhH3M2I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Aug 2021 08:28:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31919 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231765AbhH3M2H (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Aug 2021 08:28:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630326433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JULOJ3D1oEHDnIvJ24fJzaZfSU8J0Xhje3NMw5KwOms=;
        b=VHZ8YbRSnmgwT3iapezS/XYVYeKmn498+srOH4LnyUjSJ4vp3uoY2hBxHCOiuubNTimUdp
        yi1NrNGVYRlxfANUo4kQuUTM/maMGnyAEydlhDzdh2ZdnZL3XW1aqdNVE1097hjFKewgqP
        XmpKe12i3b4WFXqYtbkyJnvfYUqWrtI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-fPIcY7stOCKGYrQnRllVCA-1; Mon, 30 Aug 2021 08:27:10 -0400
X-MC-Unique: fPIcY7stOCKGYrQnRllVCA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 333DF1008064;
        Mon, 30 Aug 2021 12:27:08 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD79460939;
        Mon, 30 Aug 2021 12:27:03 +0000 (UTC)
Message-ID: <36d7884ddc472c8cf6f30e642985e2f3a4066651.camel@redhat.com>
Subject: Re: [PATCH 1/2] KVM: VMX: avoid running vmx_handle_exit_irqoff in
 case of emulation
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Date:   Mon, 30 Aug 2021 15:27:02 +0300
In-Reply-To: <YSe6wphK9b8KSkXW@google.com>
References: <20210826095750.1650467-1-mlevitsk@redhat.com>
         <20210826095750.1650467-2-mlevitsk@redhat.com>
         <YSe6wphK9b8KSkXW@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-08-26 at 16:01 +0000, Sean Christopherson wrote:
> On Thu, Aug 26, 2021, Maxim Levitsky wrote:
> > If we are emulating an invalid guest state, we don't have a correct
> > exit reason, and thus we shouldn't do anything in this function.
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> 
> This should have Cc: stable.  I believe userspace could fairly easily trick KVM
> into "handling" a spurious IRQ, e.g. trigger SIGALRM and stuff invalid state.
> For all those evil folks running CPUs that are almost old enough to drive :-)
> 
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index fada1055f325..0c2c0d5ae873 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -6382,6 +6382,9 @@ static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
> >  {
> >  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> >  
> > +	if (vmx->emulation_required)
> > +		return;
> 
> Rather than play whack-a-mole with flows consuming stale state, I'd much prefer
> to synthesize a VM-Exit(INVALID_GUEST_STATE).  Alternatively, just skip ->run()
> entirely by adding hooks in vcpu_enter_guest(), but that's a much larger change
> and probably not worth the risk at this juncture.
> 
> ---
>  arch/x86/kvm/vmx/vmx.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 32e3a8b35b13..12fe63800889 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6618,10 +6618,21 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  		     vmx->loaded_vmcs->soft_vnmi_blocked))
>  		vmx->loaded_vmcs->entry_time = ktime_get();
>  
> -	/* Don't enter VMX if guest state is invalid, let the exit handler
> -	   start emulation until we arrive back to a valid state */
> -	if (vmx->emulation_required)
> +	/*
> +	 * Don't enter VMX if guest state is invalid, let the exit handler
> +	 * start emulation until we arrive back to a valid state.  Synthesize a
> +	 * consistency check VM-Exit due to invalid guest state and bail.
> +	 */
> +	if (unlikely(vmx->emulation_required)) {
> +		vmx->fail = 0;
> +		vmx->exit_reason.full = EXIT_REASON_INVALID_STATE;
> +		vmx->exit_reason.failed_vmentry = 1;
> +		kvm_register_mark_available(vcpu, VCPU_EXREG_EXIT_INFO_1);
> +		vmx->exit_qualification = ENTRY_FAIL_DEFAULT;
> +		kvm_register_mark_available(vcpu, VCPU_EXREG_EXIT_INFO_2);
> +		vmx->exit_intr_info = 0;
>  		return EXIT_FASTPATH_NONE;
> +	}

I was thinking exactly about this when I wrote the patch, and in fact first
version of it did roughly what you suggest.

But I was afraid that this will also introduce a whack-a-mole as now
it "appears" as if VM entry failed and we should thus kill the guest.

But I'll try that.

Thanks a lot for the review!

Best regards,
	Maxim Levitsky


>  
>  	trace_kvm_entry(vcpu);
>  
> --
> 
> or the beginnings of an aggressive refactor...





> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index cf8fb6eb676a..a4fe0f78898a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9509,6 +9509,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>                 goto cancel_injection;
>         }
> 
> +       if (unlikely(static_call(kvm_x86_emulation_required)(vcpu)))
> +               return static_call(kvm_x86_emulate_invalid_guest_state)(vcpu);
> +
>         preempt_disable();
> 
>         static_call(kvm_x86_prepare_guest_switch)(vcpu);
> 
> > +
> >  	if (vmx->exit_reason.basic == EXIT_REASON_EXTERNAL_INTERRUPT)
> >  		handle_external_interrupt_irqoff(vcpu);
> >  	else if (vmx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI)
> > -- 
> > 2.26.3
> > 


