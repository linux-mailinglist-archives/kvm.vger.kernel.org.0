Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCB1B5ED4C1
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 08:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232866AbiI1GVk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 02:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232256AbiI1GV0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 02:21:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5FF1126470
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 23:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664346084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gR9YEc94x/YWrCxNEskBiCp/j0rf3zq3bUXmUrxcXYs=;
        b=avIwKRe77ZriNE5nweLymmbKHwglw8hT32esGHkE3QzXsr3OM4IL3937oOyLmJBDyO1P3z
        pyd9VkJZn6fIvvKH0Liw4Jb7v0e57YL13qW39CrfCinxVgrcVHwb0w2ZMbJ245nQTJ0Ubq
        /fEyPZxSsz4T8sfQKFAGug57SVdaM8Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-jPN1lnVKNFC58xQKGcizFw-1; Wed, 28 Sep 2022 02:21:19 -0400
X-MC-Unique: jPN1lnVKNFC58xQKGcizFw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2061D185A792;
        Wed, 28 Sep 2022 06:21:19 +0000 (UTC)
Received: from starship (unknown [10.40.193.233])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3BFA440C6EC2;
        Wed, 28 Sep 2022 06:21:17 +0000 (UTC)
Message-ID: <bcc3c67abc3b2c3d896b800c5f8f7295b7238271.camel@redhat.com>
Subject: Re: [PATCH v3 07/28] KVM: x86: Inhibit APIC memslot if x2APIC and
 AVIC are enabled
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Wed, 28 Sep 2022 09:21:16 +0300
In-Reply-To: <YzHawRN8vpEzP7XD@google.com>
References: <20220920233134.940511-1-seanjc@google.com>
         <20220920233134.940511-8-seanjc@google.com>
         <e84ebf0a7ac9322bd0cfa742ef6dd2bbfdac0df9.camel@redhat.com>
         <YzHawRN8vpEzP7XD@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-09-26 at 17:00 +0000, Sean Christopherson wrote:
> On Fri, Sep 23, 2022, Maxim Levitsky wrote:
> > On Tue, 2022-09-20 at 23:31 +0000, Sean Christopherson wrote:
> > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > index 2c96c43c313a..6475c882b359 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -1132,6 +1132,17 @@ enum kvm_apicv_inhibit {
> > >  	 * AVIC is disabled because SEV doesn't support it.
> > >  	 */
> > >  	APICV_INHIBIT_REASON_SEV,
> > > +
> > > +	/*
> > > +	 * Due to sharing page tables across vCPUs, the xAPIC memslot must be
> > > +	 * deleted if any vCPU has x2APIC enabled as SVM doesn't provide fully
> > > +	 * independent controls for AVIC vs. x2AVIC, and also because SVM
> > > +	 * supports a "hybrid" AVIC mode for CPUs that support AVIC but not
> > > +	 * x2AVIC.  Note, this isn't a "full" inhibit and is tracked separately.
> > > +	 * AVIC can still be activated, but KVM must not create SPTEs for the
> > > +	 * APIC base.  For simplicity, this is sticky.
> > > +	 */
> > > +	APICV_INHIBIT_REASON_X2APIC,
> > 
> > Hi Sean!
> > 
> > So assuming that I won't object to making it SVM specific (I still think
> > that VMX should also inhibit this memslot because this is closer to x86 spec,
> > but if you really want it this way, I won't fight over it):
> 
> Heh, I don't necessarily "want" it this way, it's more that I don't see a compelling
> reason to change KVM's behavior and risk silently causing a performance regression.
> If KVM didn't already have the "APIC base may have RAM semantics" quirk, and/or if
> this were the initial APICv implementation and thus no possible users, then I would
> probably also vote to give APICv the same treatment.
> 
> > I somewhat don't like this inhibit, because now it is used just to say
> > 'I am AVIC'.
> > 
> > What do you think if you just move the code that removes the memslot to SVM,
> > to avic_set_virtual_apic_mode?
> 
> Suffers the same SRCU issue (see below) :-/
> 
> Given the SRCU problem, I'd prefer to keep the management of the memslot in common
> code, even though I agree it's a bit silly.  And KVM_REQ_UNBLOCK is a perfect fit
> for dealing with the SRCU issue, i.e. handling this in AVIC code would require
> another hook on top of spreading the memslot management across x86 and SVM code.

OK, I am not going to argue about this. But what about at least not using an inhibit
bit for that but something else like a boolean, or maybe really add 'I am AVIC bit'
or rather something like vcpu->arch.apicv_type enum?


Or we can make SVM code just call a common function - just put these in a function and call it
from avic_set_virtual_apic_mode?


void kvm_disable_apicv_memslot(struct kvm_vcpu *vcpu)
{
	if (!vcpu->kvm->arch.apic_access_memslot_inhibited) {
            vcpu->kvm->arch.apic_access_memslot_inhibited = true;
            kvm_make_request(KVM_REQ_UNBLOCK, vcpu);
	}
}

> 
> > > @@ -1169,10 +1180,11 @@ struct kvm_arch {
> > >  	struct kvm_apic_map __rcu *apic_map;
> > >  	atomic_t apic_map_dirty;
> > >  
> > > -	/* Protects apic_access_memslot_enabled and apicv_inhibit_reasons */
> > > -	struct rw_semaphore apicv_update_lock;
> > > -
> > >  	bool apic_access_memslot_enabled;
> > > +	bool apic_access_memslot_inhibited;
> > 
> > So the apic_access_memslot_enabled currently tracks if the memslot is enabled.
> > As I see later in the patch when you free the memslot, you set it to false,
> > which means that if a vCPU is created after that (it can happen in theory),
> > the memslot will be created again :(
> > 
> > I say we need 'enabled', and 'allocated' booleans instead. Inhibit will set
> > enabled to false, and then on next vcpu run, that will free the memslot.
> > 
> > when enabled == false, the code needs to be changed to not allocate it again.
> 
> This should be handled already.  apic_access_memslot_enabled is toggled from
> true=>false if and only if apic_access_memslot_inhibited is set, and the "enabled"
> flag is protected by slots_lock.  Thus, newly created vCPUs are guaranteed to
> either see apic_access_memslot_enabled==true or apic_access_memslot_inhibited==true.
> 
>   int kvm_alloc_apic_access_page(struct kvm *kvm)
>   {
> 	struct page *page;
> 	void __user *hva;
> 	int ret = 0;
> 
> 	mutex_lock(&kvm->slots_lock);
> 	if (kvm->arch.apic_access_memslot_enabled ||
> 	    kvm->arch.apic_access_memslot_inhibited)  <=== prevents reallocation
> 		goto out;
> 
>   out:
> 	mutex_unlock(&kvm->slots_lock);
> 	return ret;
>   }

Ah, you added this in previous patch which I didn't see, makes sense.

> 
> That could be made more obvious by adding a WARN in kvm_free_apic_access_page(), i.e.
Yep, a WARN_ON_ONCE unless in hot path, is almost always a good idea, so lets add it.
> 
>   void kvm_free_apic_access_page(struct kvm *kvm)
>   {
> 	WARN_ON_ONCE(!kvm->arch.apic_access_memslot_inhibited);
> 
> 	mutex_lock(&kvm->slots_lock);
> 
> 	if (kvm->arch.apic_access_memslot_enabled) {
> 		__x86_set_memory_region(kvm, APIC_ACCESS_PAGE_PRIVATE_MEMSLOT, 0, 0);
> 		kvm->arch.apic_access_memslot_enabled = false;
> 	}
> 
> 	mutex_unlock(&kvm->slots_lock);
>   }
> 
> > > +
> > > +	/* Protects apicv_inhibit_reasons */
> > > +	struct rw_semaphore apicv_update_lock;
> > >  	unsigned long apicv_inhibit_reasons;
> > >  
> > >  	gpa_t wall_clock;
> > > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > > index 99994d2470a2..70f00eda75b2 100644
> > > --- a/arch/x86/kvm/lapic.c
> > > +++ b/arch/x86/kvm/lapic.c
> > > @@ -2394,9 +2394,26 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
> > >  		}
> > >  	}
> > >  
> > > -	if (((old_value ^ value) & X2APIC_ENABLE) && (value & X2APIC_ENABLE))
> > > +	if (((old_value ^ value) & X2APIC_ENABLE) && (value & X2APIC_ENABLE)) {
> > >  		kvm_apic_set_x2apic_id(apic, vcpu->vcpu_id);
> > >  
> > > +		/*
> > > +		 * Mark the APIC memslot as inhibited if x2APIC is enabled and
> > > +		 * the x2APIC inhibit is required.  The actual deletion of the
> > > +		 * memslot is handled by vcpu_run() as SRCU may or may not be
> > > +		 * held at this time, i.e. updating memslots isn't safe.  Don't
> > > +		 * check apic_access_memslot_inhibited, this vCPU needs to
> > > +		 * ensure the memslot is deleted before re-entering the guest,
> > > +		 * i.e. needs to make the request even if the inhibit flag was
> > > +		 * already set by a different vCPU.
> > > +		 */
> > > +		if (vcpu->kvm->arch.apic_access_memslot_enabled &&
> > > +		    static_call(kvm_x86_check_apicv_inhibit_reasons)(APICV_INHIBIT_REASON_X2APIC)) {
> > > +			vcpu->kvm->arch.apic_access_memslot_inhibited = true;
> > > +			kvm_make_request(KVM_REQ_UNBLOCK, vcpu);
> > 
> > You are about to remove the KVM_REQ_UNBLOCK in other patch series.
> 
> No, KVM_REQ_UNHALT is being removed.  KVM_REQ_UNBLOCK needs to stay, although it
> has a rather weird name, e.g. KVM_REQ_WORK would probably be better.

Roger that!
And I guess lets rename it while we are at it.

> 
> > How about just raising KVM_REQ_APICV_UPDATE on current vCPU
> > and having a special case in kvm_vcpu_update_apicv of 
> > 
> > if (apic_access_memslot_enabled == false && apic_access_memslot_allocaed == true) {
> > 	drop srcu lock
> 
> This was my initial thought as well, but the issue is that SRCU may or may not be
> held, and so the unlock+lock would need to be conditional.  That's technically a
> solvable problem, as it's possible to detect if SRCU is held, but I really don't
> want to rely on kvm_vcpu.srcu_depth for anything other than proving that KVM doesn't
> screw up SRCU.

Why though? the KVM_REQ_APICV_UPDATE is only handled AFAIK in vcpu_enter_guest
which drops the srcu lock few lines afterwards, and therefore the
kvm_vcpu_update_apicv is always called with the lock held and it means that it
can drop it for the duration of slot update.

The original issue we had was that we tried to drop the srcu lock in 
'kvm_set_apicv_inhibit' which indeed is called from various places,
with, or without the lock held.

Moving the memslot disable code to kvm_vcpu_update_apicv would actually solve that,
but it was not possible because kvm_vcpu_update_apicv is called simultaneously on all vCPUs, 
and created various races, including toggling the memslot twice.


So if possible please take another look at using KVM_REQ_APICV_UPDATE instead of KVM_REQ_UNBLOCK.

Best regards,
	Maxim Levitsky

> 
> > 	free the memslot
> > 	take srcu lock
> > }


