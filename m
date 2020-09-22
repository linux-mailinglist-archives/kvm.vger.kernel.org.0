Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B19A274624
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 18:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgIVQGG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 12:06:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25962 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726583AbgIVQGE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 12:06:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600790763;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2PxdfcFiZl6sLx0ncb6aNHiRBqDwfAspKHL2qjnrSjE=;
        b=EEfmJkXyRvLCYhuZAuAvSkxGI89oeoVCaUqk3Ao05Zt5ETNiOIcWKgJlTseK7x3m/Ew8Wf
        gT8+ROEQ3CRW8PvbWA9iEuBJDS6R6wcFarrB5JBeKsO/iW1avx+rkmAjnDqtdfXtksSfTA
        ZHjuLqaF1+787eZHgqqC2wXyMlij/bs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-568-bIY8BwJaOsWby4N7PGD8AQ-1; Tue, 22 Sep 2020 12:05:58 -0400
X-MC-Unique: bIY8BwJaOsWby4N7PGD8AQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BAE56109106B;
        Tue, 22 Sep 2020 16:05:56 +0000 (UTC)
Received: from starship (unknown [10.35.206.154])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 242F31001281;
        Tue, 22 Sep 2020 16:05:52 +0000 (UTC)
Message-ID: <57ca638581ce6e4db9b7c879f3aa7140cc5915c6.camel@redhat.com>
Subject: Re: [PATCH v5 3/4] KVM: x86: allow kvm_x86_ops.set_efer to return a
 value
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date:   Tue, 22 Sep 2020 19:05:48 +0300
In-Reply-To: <20200921154151.GA23807@linux.intel.com>
References: <20200921131923.120833-1-mlevitsk@redhat.com>
         <20200921131923.120833-4-mlevitsk@redhat.com>
         <20200921154151.GA23807@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2020-09-21 at 08:41 -0700, Sean Christopherson wrote:
> On Mon, Sep 21, 2020 at 04:19:22PM +0300, Maxim Levitsky wrote:
> > This will be used later to return an error when setting this msr fails.
> > 
> > Note that we ignore this return value for qemu initiated writes to
> > avoid breaking backward compatibility.
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -2835,13 +2835,15 @@ static void enter_rmode(struct kvm_vcpu *vcpu)
> >  	kvm_mmu_reset_context(vcpu);
> >  }
> >  
> > -void vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer)
> > +int vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer)
> >  {
> >  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> >  	struct shared_msr_entry *msr = find_msr_entry(vmx, MSR_EFER);
> >  
> > -	if (!msr)
> > -		return;
> > +	if (!msr) {
> > +		/* Host doen't support EFER, nothing to do */
> > +		return 0;
> > +	}
> 
> Kernel style is to omit braces, even with a line comment.  Though I would
> do something like so to avoid the question.
I didn't knew this, but next time I'll will take this in account!

> 
> 	/* Nothing to do if hardware doesn't support EFER. */
> 	if (!msr)
> 		return 0
I'll do this.

> >  
> >  	vcpu->arch.efer = efer;
> >  	if (efer & EFER_LMA) {
> > @@ -2853,6 +2855,7 @@ void vmx_set_efer(struct kvm_vcpu *vcpu, u64 efer)
> >  		msr->data = efer & ~EFER_LME;
> >  	}
> >  	setup_msrs(vmx);
> > +	return 0;
> >  }
> >  
> >  #ifdef CONFIG_X86_64
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index b6c67ab7c4f34..cab189a71cbb7 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -1456,6 +1456,7 @@ static int set_efer(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >  {
> >  	u64 old_efer = vcpu->arch.efer;
> >  	u64 efer = msr_info->data;
> > +	int r;
> >  
> >  	if (efer & efer_reserved_bits)
> >  		return 1;
> > @@ -1472,7 +1473,12 @@ static int set_efer(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >  	efer &= ~EFER_LMA;
> >  	efer |= vcpu->arch.efer & EFER_LMA;
> >  
> > -	kvm_x86_ops.set_efer(vcpu, efer);
> > +	r = kvm_x86_ops.set_efer(vcpu, efer);
> > +
> > +	if (r && !msr_info->host_initiated) {
> 
> I get the desire to not break backwards compatibility, but this feels all
> kinds of wrong, and potentially dangerous as it will KVM in a mixed state.
> E.g. vcpu->arch.efer will show that nSVM is enabled, but SVM will not have
> the necessary tracking state allocated.  That could lead to a userspace
> triggerable #GP/panic.
Actually I take care to restore the vcpu->arch.efer to its old value
if an error happens, so in case of failure everything would indicate
that nothing happened, and the offending EFER write can even be retried,
however since we agreed that .set_efer will only fail with negative
errors like -ENOMEM, I agree that there is no reason to treat userspace
writes differently. This code is actually a leftover from previous version,
which I should have removed.

I'll send a new version soon.

Thanks for the review,
	Best regards,
		Maxim Levitsky

> 
> Is ignoring OOM scenario really considered backwards compability?  The VM
> is probably hosted if KVM returns -ENOMEM, e.g. a sophisticated userspace
> stack could trigger OOM killer to free memory and resume the VM.  On the
> other hand, the VM is most definitely hosed if KVM ignores the error and
> puts itself into an invalid state.
> 
> > +		WARN_ON(r > 0);
> > +		return r;
> > +	}
> >  
> >  	/* Update reserved bits */
> >  	if ((efer ^ old_efer) & EFER_NX)
> > -- 
> > 2.26.2
> > 


