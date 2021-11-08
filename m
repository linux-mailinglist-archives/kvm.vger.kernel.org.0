Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5E1447C5C
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 09:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238211AbhKHI6b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 03:58:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25083 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238201AbhKHI62 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Nov 2021 03:58:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636361744;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v9Uxou/I9CAEWqD2sDJCTKS109caH4A5MI+TAebpwNY=;
        b=I2JJR65EfEDwP6t5cJynsq9bSnM0zK35yYUBOkVtSZl6TYOk+lrWYd3bv7hXSTnHMjS8KQ
        D29m8l3iWvEceC9p8l/DT+asgD79GPI3yL1kk3rGZpjfs6c2zwMaih0+yWHdVleL9jQdKv
        27cCFtUtx72IFfHRro67ay1nn1FPLRc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-_URZhROyMtevT9buxj-b0Q-1; Mon, 08 Nov 2021 03:55:41 -0500
X-MC-Unique: _URZhROyMtevT9buxj-b0Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EFF6E102CB76;
        Mon,  8 Nov 2021 08:55:38 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 707AA1B46B;
        Mon,  8 Nov 2021 08:55:20 +0000 (UTC)
Message-ID: <cdfd94b3f37d69efb75a70f42dc295cb283aab7c.camel@redhat.com>
Subject: Re: [PATCH v3] KVM: x86: inhibit APICv when KVM_GUESTDBG_BLOCKIRQ
 active
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Date:   Mon, 08 Nov 2021 10:55:19 +0200
In-Reply-To: <YYQz3E/eNxdnNwBj@google.com>
References: <20211103143929.15264-1-mlevitsk@redhat.com>
         <YYQz3E/eNxdnNwBj@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-11-04 at 19:26 +0000, Sean Christopherson wrote:
> On Wed, Nov 03, 2021, Maxim Levitsky wrote:
> > KVM_GUESTDBG_BLOCKIRQ relies on interrupts being injected using
> > standard kvm's inject_pending_event, and not via APICv/AVIC.
> > 
> > Since this is a debug feature, just inhibit APICv/AVIC while
> > KVM_GUESTDBG_BLOCKIRQ is in use on at least one vCPU.
> 
> Very clever!

Thanks! It is now possible to enjoy this,
after we broke our back making APICv/AVIC inhibition actually work...

> 
> > Fixes: 61e5f69ef0837 ("KVM: x86: implement KVM_GUESTDBG_BLOCKIRQ")
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> 
> With the below nits resolved (tested on Intel w/ APICv):
> 
> Reviewed-and-tested-by: Sean Christopherson <seanjc@google.com>
> 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index ac83d873d65b0..5d30cea58182e 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -10703,6 +10703,25 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
> >  	return ret;
> >  }
> >  
> > +static void kvm_arch_vcpu_guestdbg_update_apicv_inhibit(struct kvm *kvm)
> > +{
> > +	struct kvm_vcpu *vcpu = NULL;
> 
> vcpu doesn't need to be initialized.
True, fixed in v4
> 
> > +	int i;
> 
> Nit, I'd prefer we use reverse fir tree when it's convenient, i.e.
Fixed in v4

> 
> 	bool block_irq_used = false;
> 	struct kvm_vcpu *vcpu;
> 	int i;
> 
> > +	bool block_irq_used = false;
> > +
> > +	down_write(&kvm->arch.apicv_update_lock);
> > +
> > +	kvm_for_each_vcpu(i, vcpu, kvm) {
> > +		if (vcpu->guest_debug & KVM_GUESTDBG_BLOCKIRQ) {
> > +			block_irq_used = true;
> > +			break;
> > +		}
> > +	}
> > +	__kvm_request_apicv_update(kvm, !block_irq_used,
> > +					       APICV_INHIBIT_REASON_BLOCKIRQ);
> 
> Heh, this indentation is still messed up, I think you need to change your
> 
> 	if (r == -ENOCOFFEE)
> 		maxim_get_coffee();
> 
> to
> 
> 	while (r == -ENOCOFFEE)
> 		r = maxim_get_coffee();

Yep :-)

> 
> > +	up_write(&kvm->arch.apicv_update_lock);
> > +}
> > +
> >  int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
> >  					struct kvm_guest_debug *dbg)
> >  {
> > @@ -10755,6 +10774,8 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
> >  
> >  	static_call(kvm_x86_update_exception_bitmap)(vcpu);
> >  
> > +	kvm_arch_vcpu_guestdbg_update_apicv_inhibit(vcpu->kvm);
> > +
> >  	r = 0;
> >  
> >  out:
> > -- 
> > 2.26.3
> > 

Thanks for the review,
	Best regards,
		Maxim Levitsky


