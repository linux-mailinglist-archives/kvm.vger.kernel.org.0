Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85EB9472CD2
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 14:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbhLMNIT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 08:08:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:40078 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231616AbhLMNIS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Dec 2021 08:08:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639400898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TgI/nBlOnVQKiq1w9qS0FHuNe/IggXOsd2RaFDgPPDs=;
        b=hXdj8espiC6NnzAqnCHqZylt6x+wvxP4umlOdx30SK7ckVNjBrwdd9er5AFauWN0vcMLjq
        KkozoPQiR8akqL4vMAJNO1dl4jhRwo/78tngOZgXFOEPQ7TsIvGqyIOG2U/DwJZIVmNo4G
        WN8ddytvXVM+LBNUOxr+b1IdJoYZ6eo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-9-ojG3r84cP2-mISrGfANMyQ-1; Mon, 13 Dec 2021 08:08:14 -0500
X-MC-Unique: ojG3r84cP2-mISrGfANMyQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4BB4E80BCA8;
        Mon, 13 Dec 2021 13:08:12 +0000 (UTC)
Received: from starship (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A0B4D610A5;
        Mon, 13 Dec 2021 13:07:52 +0000 (UTC)
Message-ID: <74c548c61aeb4afba3acb4143fcb91d92e7de8d6.camel@redhat.com>
Subject: Re: [PATCH v2 1/5] KVM: nSVM: deal with L1 hypervisor that
 intercepts interrupts but lets L2 control EFLAGS.IF
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>
Date:   Mon, 13 Dec 2021 15:07:51 +0200
In-Reply-To: <0d893664-ff8d-83ed-e9be-441b45992f68@redhat.com>
References: <20211213104634.199141-1-mlevitsk@redhat.com>
         <20211213104634.199141-2-mlevitsk@redhat.com>
         <0d893664-ff8d-83ed-e9be-441b45992f68@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-12-13 at 12:34 +0100, Paolo Bonzini wrote:
> On 12/13/21 11:46, Maxim Levitsky wrote:
> > Fix a corner case in which L1 hypervisor intercepts interrupts (INTERCEPT_INTR)
> > and either doesn't use virtual interrupt masking (V_INTR_MASKING) or
> > enters a nested guest with EFLAGS.IF disabled prior to the entry.
> > 
> > In this case, despite the fact that L1 intercepts the interrupts,
> > KVM still needs to set up an interrupt window to wait before it
> > can deliver INTR vmexit.
> > 
> > Currently instead, the KVM enters an endless loop of 'req_immediate_exit'.
> > 
> > Note that on VMX this case is impossible as there is only
> > 'vmexit on external interrupts' execution control which either set,
> > in which case both host and guest's EFLAGS.IF
> > is ignored, or clear, in which case no VMexit is delivered.
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >   arch/x86/kvm/svm/svm.c | 10 +++++++---
> >   1 file changed, 7 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index e57e6857e0630..c9668a3b51011 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -3372,17 +3372,21 @@ bool svm_interrupt_blocked(struct kvm_vcpu *vcpu)
> >   static int svm_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
> >   {
> >   	struct vcpu_svm *svm = to_svm(vcpu);
> > +	bool blocked;
> > +
> >   	if (svm->nested.nested_run_pending)
> >   		return -EBUSY;
> >   
> > +	blocked = svm_interrupt_blocked(vcpu);
> > +
> >   	/*
> >   	 * An IRQ must not be injected into L2 if it's supposed to VM-Exit,
> >   	 * e.g. if the IRQ arrived asynchronously after checking nested events.
> >   	 */
> >   	if (for_injection && is_guest_mode(vcpu) && nested_exit_on_intr(svm))
> > -		return -EBUSY;
> > -
> > -	return !svm_interrupt_blocked(vcpu);
> > +		return !blocked ? -EBUSY : 0;
> > +	else
> > +		return !blocked;
> >   }
> >   
> >   static void svm_enable_irq_window(struct kvm_vcpu *vcpu)
> > 
> 
> Right, another case is when CLGI is not trapped and the guest therefore
> runs with GIF=0.  I think that means that a similar change has to be
> done in all the *_allowed functions.

I think that SVM sets real GIF to 1 on VMentry regardless if it is trapped or not.

However if not trapped, and neither EFLAGS.IF is trapped, one could enter a guest
that has EFLAGS.IF == 0, then the guest could disable GIF, enable EFLAGS.IF,
and then enable GIF, but then GIF enablement should trigger out interrupt window
VINTR as well.


> 
> I would write it as
> 
>    	if (svm->nested.nested_run_pending)
>    		return -EBUSY;
>    
> 	if (svm_interrupt_blocked(vcpu))
> 		return 0;
> 
>    	/*
>    	 * An IRQ must not be injected into L2 if it's supposed to VM-Exit,
>    	 * e.g. if the IRQ arrived asynchronously after checking nested events.
>    	 */
>    	if (for_injection && is_guest_mode(vcpu) && nested_exit_on_intr(svm))
> 		return -EBUSY;
> 	return 1;

Thanks! I was worried to not break the non nested case but looking again at the code,
it is logically equivalent. 


Thanks for the review,
	Best regards,
		Maxim Levitsky

> 
> Paolo
> 


