Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F699486195
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 09:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236900AbiAFIox (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 03:44:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35843 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229762AbiAFIow (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Jan 2022 03:44:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641458691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gxzoQoAWsckj3O4bq1MbuFoX5uVZ/0SJ0i7zSUWX8zY=;
        b=IM3q710bdhHfAEis2vbA/F1At4Eu3C/jqcs6xc4335eLfykJIQ+eBDWROaW1f/9/XBAj5V
        +0Kdho/XYAcqjTZQRKeE0z1XtqICcdkZZIJJyGFSGaJuV3Ao3zuUvlWcXRp9/4nMxkth9s
        zAdBEV/ml8wcUzmqy6Np2D+4ka9knTs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-472-CBzk3zfqNDq1hHV86Jz5Lg-1; Thu, 06 Jan 2022 03:44:49 -0500
X-MC-Unique: CBzk3zfqNDq1hHV86Jz5Lg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB2071800D50;
        Thu,  6 Jan 2022 08:44:47 +0000 (UTC)
Received: from starship (unknown [10.40.192.177])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 959467CAD1;
        Thu,  6 Jan 2022 08:44:38 +0000 (UTC)
Message-ID: <21d662162bfa7a5ba9ba2833cc607828b36480ca.camel@redhat.com>
Subject: Re: [PATCH v2 5/5] KVM: SVM: allow AVIC to co-exist with a nested
 guest running
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>
Date:   Thu, 06 Jan 2022 10:44:37 +0200
In-Reply-To: <YdYUD22otUIF3fqR@google.com>
References: <20211213104634.199141-1-mlevitsk@redhat.com>
         <20211213104634.199141-6-mlevitsk@redhat.com> <YdYUD22otUIF3fqR@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-01-05 at 21:56 +0000, Sean Christopherson wrote:
> On Mon, Dec 13, 2021, Maxim Levitsky wrote:
> > @@ -1486,6 +1485,12 @@ struct kvm_x86_ops {
> >  	int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
> >  
> >  	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
> > +
> > +	/*
> > +	 * Returns false if for some reason APICv (e.g guest mode)
> > +	 * must be inhibited on this vCPU
> 
> Comment is wrong, code returns 'true' if AVIC is inhibited due to is_guest_mode().
> Even better, rename the hook to something that's more self-documenting.
> 
> vcpu_is_apicv_inhibited() jumps to mind, but that's a bad name since it's not
> called by kvm_vcpu_apicv_active().  Maybe vcpu_has_apicv_inhibit_condition()?

Yep. I also kind of don't like the name, but I didn't though of anything better.
vcpu_has_apicv_inhibit_condition seems a good idea.

> 
> > +	 */
> > +	bool (*apicv_check_inhibit)(struct kvm_vcpu *vcpu);
> >  };
> >  
> >  struct kvm_x86_nested_ops {
> > diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> > index 34f62da2fbadd..5a8304938f51e 100644
> > --- a/arch/x86/kvm/svm/avic.c
> > +++ b/arch/x86/kvm/svm/avic.c
> > @@ -734,6 +734,11 @@ int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
> >  	return 0;
> >  }
> >  
> > +bool avic_is_vcpu_inhibited(struct kvm_vcpu *vcpu)
> 
> This should follow whatever wording we decide on for the kvm_x86_ops hook.  In
> isolation, this name is too close to kvm_vcpu_apicv_active() and could be wrongly
> assumed to mean that APICv is not inhibited for _any_ reason on this vCPU if it
> returns false.
I will think of a better name.


> 
> > +{
> > +	return is_guest_mode(vcpu);
> > +}
> > +
> >  bool svm_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu)
> >  {
> >  	return false;
> 
> ...
> 
> > @@ -4486,6 +4493,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
> >  	.complete_emulated_msr = svm_complete_emulated_msr,
> >  
> >  	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
> > +	.apicv_check_inhibit = avic_is_vcpu_inhibited,
> 
> This can technically be NULL if nested=0.
Good idea, now it is possible to after recent refactoring.

> 
> >  };
> >  
> >  /*
> > diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > index daa8ca84afccd..545684ea37353 100644
> > --- a/arch/x86/kvm/svm/svm.h
> > +++ b/arch/x86/kvm/svm/svm.h
> > @@ -590,6 +590,7 @@ void svm_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
> >  void svm_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr);
> >  void svm_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr);
> >  int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec);
> > +bool avic_is_vcpu_inhibited(struct kvm_vcpu *vcpu);
> >  bool svm_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu);
> >  int svm_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
> >  		       uint32_t guest_irq, bool set);
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 81a74d86ee5eb..125599855af47 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -9161,6 +9161,10 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
> >  		r = kvm_check_nested_events(vcpu);
> >  		if (r < 0)
> >  			goto out;
> > +
> > +		/* Nested VM exit might need to update APICv status */
> > +		if (kvm_check_request(KVM_REQ_APICV_UPDATE, vcpu))
> > +			kvm_vcpu_update_apicv(vcpu);
> >  	}
> >  
> >  	/* try to inject new event if pending */
> > @@ -9538,6 +9542,10 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
> >  	down_read(&vcpu->kvm->arch.apicv_update_lock);
> >  
> >  	activate = kvm_apicv_activated(vcpu->kvm);
> > +
> > +	if (kvm_x86_ops.apicv_check_inhibit)
> > +		activate = activate && !kvm_x86_ops.apicv_check_inhibit(vcpu);
> 
> Might as well use Use static_call().  This would also be a candidate for
> DEFINE_STATIC_CALL_RET0, though that's overkill if this is the only call site.
This is also something that should be done, but I prefer to do this in one go.
There are several nested related functions that were not converted to static_call
(like .check_nested_events).

Also I recently found that we have KVM_X86_OP and KVM_X86_OP_NULL which are the
same thing - another thing for refactoring, so I prefer to refactor this
in one patch series.



> 
> > +
> >  	if (vcpu->arch.apicv_active == activate)
> >  		goto out;
> >  
> > @@ -9935,7 +9943,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
> >  		 * per-VM state, and responsing vCPUs must wait for the update
> >  		 * to complete before servicing KVM_REQ_APICV_UPDATE.
> >  		 */
> > -		WARN_ON_ONCE(kvm_apicv_activated(vcpu->kvm) != kvm_vcpu_apicv_active(vcpu));
> > +		if (!is_guest_mode(vcpu))
> > +			WARN_ON_ONCE(kvm_apicv_activated(vcpu->kvm) != kvm_vcpu_apicv_active(vcpu));
> > +		else
> > +			WARN_ON(kvm_vcpu_apicv_active(vcpu));
> 
> Won't this fire on VMX?

Yes it will! Good catch. It almost like I would like to have .apicv_is_avic boolean,
for such cases :-) I'll think of something.

Best regards,
	Maxim Levitsky

> 
> >  
> >  		exit_fastpath = static_call(kvm_x86_run)(vcpu);
> >  		if (likely(exit_fastpath != EXIT_FASTPATH_REENTER_GUEST))
> > -- 
> > 2.26.3
> > 


