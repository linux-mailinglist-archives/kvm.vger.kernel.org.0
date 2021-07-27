Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7DCE3D7656
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 15:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232186AbhG0N1t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 09:27:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32873 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236627AbhG0NWu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Jul 2021 09:22:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627392170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KcIg/Lx6Su2LCnsmswDEv7xCBQIvYa+umdLL3a2VScU=;
        b=Y6HT7L84DWf7IXGuKt+H0+0degBVtVcs6J0EqHYYvTeBoE2+6keiptzxv4GGNzQw7oLBYP
        DZZGXW33PA0Zxe6crtVrJ5nrT/fLj7PAlrxv7bz5VChLHUjIO3YsA20RTR8nSrN/dwomB7
        TdzXNlZBk130YH5LlDco6FwdjwQJytw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-PnSYT2r1PBKHEOFBQ3xmEQ-1; Tue, 27 Jul 2021 09:22:48 -0400
X-MC-Unique: PnSYT2r1PBKHEOFBQ3xmEQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D70BF760CE;
        Tue, 27 Jul 2021 13:22:45 +0000 (UTC)
Received: from starship (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F34196A90B;
        Tue, 27 Jul 2021 13:22:41 +0000 (UTC)
Message-ID: <654e0b6aa25c15ef8907813b6ab17681c7f12f5f.camel@redhat.com>
Subject: Re: [PATCH v2 5/8] KVM: x86: APICv: fix race in
 kvm_request_apicv_update on SVM
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Sean Christopherson <seanjc@google.com>
Date:   Tue, 27 Jul 2021 16:22:40 +0300
In-Reply-To: <e8acf99c-0e3b-f0cc-c8ad-53074420d734@redhat.com>
References: <20210713142023.106183-1-mlevitsk@redhat.com>
         <20210713142023.106183-6-mlevitsk@redhat.com>
         <e8acf99c-0e3b-f0cc-c8ad-53074420d734@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-07-27 at 00:34 +0200, Paolo Bonzini wrote:
> On 13/07/21 16:20, Maxim Levitsky wrote:
> > +	mutex_lock(&vcpu->kvm->apicv_update_lock);
> > +
> >  	vcpu->arch.apicv_active = kvm_apicv_activated(vcpu->kvm);
> >  	kvm_apic_update_apicv(vcpu);
> >  	static_call(kvm_x86_refresh_apicv_exec_ctrl)(vcpu);
> > @@ -9246,6 +9248,8 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
> >  	 */
> >  	if (!vcpu->arch.apicv_active)
> >  		kvm_make_request(KVM_REQ_EVENT, vcpu);
> > +
> > +	mutex_unlock(&vcpu->kvm->apicv_update_lock);
> 
> Does this whole piece of code need the lock/unlock?  Does it work and/or 
> make sense to do the unlock immediately after mutex_lock()?  This makes 
> it clearer that the mutex is being to synchronize against the requestor.

Yes, I do need to hold the mutex for the whole duration.

The requester does the following:

1. Take the mutex
 
2. Kick all the vCPUs out of the guest mode with KVM_REQ_EVENT
   At that point all these vCPUs will be (or soon will be) stuck on the mutex
   and guaranteed to be outside of the guest mode.
   which is exactly what I need to avoid them entering the guest
   mode as long as the AVIC's memslot state is not up to date.

3. Update kvm->arch.apicv_inhibit_reasons. I removed the cmpchg loop
   since it is now protected under the lock anyway.
   This step doesn't have to be done at this point, but should be done while mutex is held
   so that there is no need to cmpchg and such.

   This itself isn't the justification for the mutex.
 
4. Update the memslot
 
5. Release the mutex.
   Only now all other vCPUs are permitted to enter the guest mode again
   (since only now the memslot is up to date)
   and they will also update their per-vcpu AVIC enablement prior to entering it.
 
 
I think it might be possible to avoid the mutex, but I am not sure if this is worth it:
 
First of all, the above sync sequence is only really needed when we enable AVIC.

(Because from the moment we enable the memslot and to the moment the vCPU enables the AVIC,
it must not be in guest mode as otherwise it will access the dummy page in the memslot
without VMexit, instead of going through AVIC vmexit/acceleration.
 
The other way around is OK. IF we disable the memslot, and a vCPU still has a enabled AVIC, 
it will just get a page fault which will be correctly emulated as APIC read/write by
the MMIO page fault.
 
If I had a guarantee that when I enable the memslot (either as it done today or
using the kvm_zap_gfn_range (which I strongly prefer), would always raise a TLB
flush request on all vCPUs, then I could (ab)use that request to update local
AVIC state.
 
Or I can just always check if local AVIC state matches the memslot and update
if it doesn't prior to guest mode entry.
 
I still think I would prefer a mutex to be 100% sure that there are no races,
since the whole AVIC disablement isn't something that is done often anyway.
 
Best regards,
	Maxim Levitsky

> 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index ed4d1581d502..ba5d5d9ebc64 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -943,6 +943,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
> >   	mutex_init(&kvm->irq_lock);
> >   	mutex_init(&kvm->slots_lock);
> >   	mutex_init(&kvm->slots_arch_lock);
> > +	mutex_init(&kvm->apicv_update_lock);
> >   	INIT_LIST_HEAD(&kvm->devices);
> >   
> >   	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
> > 
> 
> Please add comments above fields that are protected by this lock 
> (anything but apicv_inhibit_reasons?), and especially move it to kvm->arch.
I agree, I will do this.


> 
> Paolo


