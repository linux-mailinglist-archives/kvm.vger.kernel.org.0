Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D82DB463FB4
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 22:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343955AbhK3VMU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 16:12:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49324 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343931AbhK3VMP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Nov 2021 16:12:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638306534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3GAPrdMvodpqtHg3h179yFFbDiokWWUnbQiFfTfLMBc=;
        b=A1bOiYaD81uuZim9hwIIU9zH/uUbpKSLDLP3TRWS4FjA2M6WYje4ENS6e3iSa3MD0kBSAa
        3k5hZqfPzPRlKddVNDdDlDMel4O2SnQTqtdUVXLNbegzdGe5Hvt6SqlMfIwEJfYdYDvOxg
        4qHZdabLNZ6IAruFg+qz/eKFyZZbnZw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-328-n_StjTtBPMCbv23bA8k5hQ-1; Tue, 30 Nov 2021 16:08:50 -0500
X-MC-Unique: n_StjTtBPMCbv23bA8k5hQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB2DC801AE8;
        Tue, 30 Nov 2021 21:08:49 +0000 (UTC)
Received: from starship (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C45595F905;
        Tue, 30 Nov 2021 21:08:47 +0000 (UTC)
Message-ID: <a7bbdf09c64ef2d343f49a80c7e39fd6ae66b1a0.camel@redhat.com>
Subject: Re: [PATCH] KVM: ensure APICv is considered inactive if there is no
 APIC
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Ignat Korchagin <ignat@cloudflare.com>
Date:   Tue, 30 Nov 2021 23:08:46 +0200
In-Reply-To: <YaaL/Hh5pz3pydDY@google.com>
References: <20211130123746.293379-1-pbonzini@redhat.com>
         <YaaL/Hh5pz3pydDY@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-11-30 at 20:39 +0000, Sean Christopherson wrote:
> On Tue, Nov 30, 2021, Paolo Bonzini wrote:
> > kvm_vcpu_apicv_active() returns false if a virtual machine has no in-kernel
> > local APIC, however kvm_apicv_activated might still be true if there are
> > no reasons to disable APICv; in fact it is quite likely that there is none
> > because APICv is inhibited by specific configurations of the local APIC
> > and those configurations cannot be programmed.  This triggers a WARN:
> > 
> >    WARN_ON_ONCE(kvm_apicv_activated(vcpu->kvm) != kvm_vcpu_apicv_active(vcpu));
> > 
> > To avoid this, introduce another cause for APICv inhibition, namely the
> > absence of an in-kernel local APIC.  This cause is enabled by default,
> > and is dropped by either KVM_CREATE_IRQCHIP or the enabling of
> > KVM_CAP_IRQCHIP_SPLIT.
> > 
> > Reported-by: Ignat Korchagin <ignat@cloudflare.com>
> > Fixes: ee49a8932971 ("KVM: x86: Move SVM's APICv sanity check to common x86", 2021-10-22)
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 0ee1a039b490..e0aa4dd53c7f 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -5740,6 +5740,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> >  		smp_wmb();
> >  		kvm->arch.irqchip_mode = KVM_IRQCHIP_SPLIT;
> >  		kvm->arch.nr_reserved_ioapic_pins = cap->args[0];
> > +		kvm_request_apicv_update(kvm, true, APICV_INHIBIT_REASON_ABSENT);
> >  		r = 0;
> >  split_irqchip_unlock:
> >  		mutex_unlock(&kvm->lock);
> > @@ -6120,6 +6121,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
> >  		/* Write kvm->irq_routing before enabling irqchip_in_kernel. */
> >  		smp_wmb();
> >  		kvm->arch.irqchip_mode = KVM_IRQCHIP_KERNEL;
> > +		kvm_request_apicv_update(kvm, true, APICV_INHIBIT_REASON_ABSENT);
> 
> Blech, kvm_request_apicv_update() is very counter-intuitive, true == clear. :-/
> Wrappers along the lines of kvm_{set,clear}_apicv_inhibit() would help a lot, and
> would likely avoid a handful of newlines as well.  I'll send a patch on top of this,
> unless you want to do it while pushing this one out.

100% agree that kvm_request_apicv_update() is very counter-intuitive!

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

> 
> >  	create_irqchip_unlock:
> >  		mutex_unlock(&kvm->lock);
> >  		break;
> > @@ -8818,10 +8820,9 @@ static void kvm_apicv_init(struct kvm *kvm)
> >  {
> >  	init_rwsem(&kvm->arch.apicv_update_lock);
> >  
> > -	if (enable_apicv)
> > -		clear_bit(APICV_INHIBIT_REASON_DISABLE,
> > -			  &kvm->arch.apicv_inhibit_reasons);
> > -	else
> > +	set_bit(APICV_INHIBIT_REASON_ABSENT,
> > +		&kvm->arch.apicv_inhibit_reasons);
> 
> Nit, this one fits on a single line.
> 
> > +	if (!enable_apicv)
> >  		set_bit(APICV_INHIBIT_REASON_DISABLE,
> >  			&kvm->arch.apicv_inhibit_reasons);
> >  }
> > -- 
> > 2.31.1
> > 


