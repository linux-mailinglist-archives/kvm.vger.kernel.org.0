Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2B71272556
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 15:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbgIUNYD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 09:24:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56363 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726419AbgIUNYA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Sep 2020 09:24:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600694639;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J2/FeX5V/ZEFcOQ6qB7LEOuNKAsmu6be+QX5MLdG1mc=;
        b=S/5jd1gt/dWZ3oe9Xx96Qu7dkLhGntyJnfUcy9QtBw5kFmUgcfSdOjiYrMPZTZbyMjxZWY
        AdUj4MHrhiHNzm/LKIBp3vmrvNi5MosKcE8vKCbe1avKZv3ebZoksqPWsLSd/M19SNIoWs
        l9x0xtK5me2wGFrh3Z0xDUGJQ+NRuJ4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-CbD6S37cMhSQvyElEobkeg-1; Mon, 21 Sep 2020 09:23:55 -0400
X-MC-Unique: CbD6S37cMhSQvyElEobkeg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2BEC107464D;
        Mon, 21 Sep 2020 13:23:53 +0000 (UTC)
Received: from starship (unknown [10.35.206.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3A6845C1DC;
        Mon, 21 Sep 2020 13:23:49 +0000 (UTC)
Message-ID: <badafb14f2b3659e6c5669602511083364e99fb5.camel@redhat.com>
Subject: Re: [PATCH v4 2/2] KVM: nSVM: implement ondemand allocation of the
 nested state
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Date:   Mon, 21 Sep 2020 16:23:47 +0300
In-Reply-To: <20200917162942.GE13522@sjchrist-ice>
References: <20200917101048.739691-1-mlevitsk@redhat.com>
         <20200917101048.739691-3-mlevitsk@redhat.com>
         <20200917162942.GE13522@sjchrist-ice>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2020-09-17 at 09:29 -0700, Sean Christopherson wrote:
> On Thu, Sep 17, 2020 at 01:10:48PM +0300, Maxim Levitsky wrote:
> > This way we don't waste memory on VMs which don't use
> > nesting virtualization even if it is available to them.
> > 
> > If allocation of nested state fails (which should happen,
> > only when host is about to OOM anyway), use new KVM_REQ_OUT_OF_MEMORY
> > request to shut down the guest
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  arch/x86/kvm/svm/nested.c | 42 ++++++++++++++++++++++++++++++
> >  arch/x86/kvm/svm/svm.c    | 54 ++++++++++++++++++++++-----------------
> >  arch/x86/kvm/svm/svm.h    |  7 +++++
> >  3 files changed, 79 insertions(+), 24 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index 09417f5197410..fe119da2ef836 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -467,6 +467,9 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
> >  
> >  	vmcb12 = map.hva;
> >  
> > +	if (WARN_ON(!svm->nested.initialized))
> > +		return 1;
> > +
> >  	if (!nested_vmcb_checks(svm, vmcb12)) {
> >  		vmcb12->control.exit_code    = SVM_EXIT_ERR;
> >  		vmcb12->control.exit_code_hi = 0;
> > @@ -684,6 +687,45 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
> >  	return 0;
> >  }
> >  
> > +int svm_allocate_nested(struct vcpu_svm *svm)
> > +{
> > +	struct page *hsave_page;
> > +
> > +	if (svm->nested.initialized)
> > +		return 0;
> > +
> > +	hsave_page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> > +	if (!hsave_page)
> > +		goto error;
> 
> goto is unnecessary, just do
> 
> 		return -ENOMEM;

To be honest this is a philosophical question,
what way is better, but I don't mind to change this.

> 
> > +
> > +	svm->nested.hsave = page_address(hsave_page);
> > +
> > +	svm->nested.msrpm = svm_vcpu_init_msrpm();
> > +	if (!svm->nested.msrpm)
> > +		goto err_free_hsave;
> > +
> > +	svm->nested.initialized = true;
> > +	return 0;
> > +err_free_hsave:
> > +	__free_page(hsave_page);
> > +error:
> > +	return 1;
> 
> As above, -ENOMEM would be preferable.
After the changes to return negative values from msr writes,
this indeed makes sense and is done now.
> 
> > +}
> > +
> > +void svm_free_nested(struct vcpu_svm *svm)
> > +{
> > +	if (!svm->nested.initialized)
> > +		return;
> > +
> > +	svm_vcpu_free_msrpm(svm->nested.msrpm);
> > +	svm->nested.msrpm = NULL;
> > +
> > +	__free_page(virt_to_page(svm->nested.hsave));
> > +	svm->nested.hsave = NULL;
> > +
> > +	svm->nested.initialized = false;
> > +}
> > +
> >  /*
> >   * Forcibly leave nested mode in order to be able to reset the VCPU later on.
> >   */
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index 3da5b2f1b4a19..57ea4407dcf09 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -266,6 +266,7 @@ static int get_max_npt_level(void)
> >  void svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
> >  {
> >  	struct vcpu_svm *svm = to_svm(vcpu);
> > +	u64 old_efer = vcpu->arch.efer;
> >  	vcpu->arch.efer = efer;
> >  
> >  	if (!npt_enabled) {
> > @@ -276,9 +277,26 @@ void svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
> >  			efer &= ~EFER_LME;
> >  	}
> >  
> > -	if (!(efer & EFER_SVME)) {
> > -		svm_leave_nested(svm);
> > -		svm_set_gif(svm, true);
> > +	if ((old_efer & EFER_SVME) != (efer & EFER_SVME)) {
> > +		if (!(efer & EFER_SVME)) {
> > +			svm_leave_nested(svm);
> > +			svm_set_gif(svm, true);
> > +
> > +			/*
> > +			 * Free the nested state unless we are in SMM, in which
> > +			 * case the exit from SVM mode is only for duration of the SMI
> > +			 * handler
> > +			 */
> > +			if (!is_smm(&svm->vcpu))
> > +				svm_free_nested(svm);
> > +
> > +		} else {
> > +			if (svm_allocate_nested(svm)) {
> > +				vcpu->arch.efer = old_efer;
> > +				kvm_make_request(KVM_REQ_OUT_OF_MEMORY, vcpu);
> 
> I really dislike KVM_REQ_OUT_OF_MEMORY.  It's redundant with -ENOMEM and
> creates a huge discrepancy with respect to existing code, e.g. nVMX returns
> -ENOMEM in a similar situation.
> 
> The deferred error handling creates other issues, e.g. vcpu->arch.efer is
> unwound but the guest's RIP is not.
> 
> One thought for handling this without opening a can of worms would be to do:
> 
> 	r = kvm_x86_ops.set_efer(vcpu, efer);
> 	if (r) {
> 		WARN_ON(r > 0);
> 		return r;
> 	}
> 
> I.e. go with the original approach, but only for returning errors that will
> go all the way out to userspace.

Done as explained in the other reply.

> 
> > +				return;
> > +			}
> > +		}
> >  	}
> >  
> >  	svm->vmcb->save.efer = efer | EFER_SVME;


Thanks for the review,
	Best regards,
		Maxim Levitsky

