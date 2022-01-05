Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFEB48518F
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 12:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239583AbiAELDy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 06:03:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50955 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235128AbiAELDx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Jan 2022 06:03:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641380633;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2Bn5J92jb9VCDdlzZ06HPXHfYjgq++ytq59wMITpuvg=;
        b=Y6gV/GnxYJAPemGvXF+v0djWrY8m9BRNyv+9KAOAMYTriXMgLD12R0XLXoi2gZwI0+2Vp2
        W8crJJGyrVexktcwnzQgYgvykfjpU1Q1hICQmAX++SAfuueDlL0NSTYOqlJVhN5Wy0b38E
        AklMYxELes2t8q+NEh7MbLuHE5Rorqc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-504-cX5u5NJfNLWY3qV1pr_g9w-1; Wed, 05 Jan 2022 06:03:48 -0500
X-MC-Unique: cX5u5NJfNLWY3qV1pr_g9w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A3831101AFA7;
        Wed,  5 Jan 2022 11:03:46 +0000 (UTC)
Received: from starship (unknown [10.40.192.177])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6972C708D2;
        Wed,  5 Jan 2022 11:03:42 +0000 (UTC)
Message-ID: <628ac6d9b16c6b3a2573f717df0d2417df7caddb.camel@redhat.com>
Subject: Re: [PATCH v2 3/5] KVM: SVM: fix race between interrupt delivery
 and AVIC inhibition
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
Date:   Wed, 05 Jan 2022 13:03:41 +0200
In-Reply-To: <YdTPvdY6ysjXMpAU@google.com>
References: <20211213104634.199141-1-mlevitsk@redhat.com>
         <20211213104634.199141-4-mlevitsk@redhat.com> <YdTPvdY6ysjXMpAU@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-01-04 at 22:52 +0000, Sean Christopherson wrote:
> On Mon, Dec 13, 2021, Maxim Levitsky wrote:
> > If svm_deliver_avic_intr is called just after the target vcpu's AVIC got
> > inhibited, it might read a stale value of vcpu->arch.apicv_active
> > which can lead to the target vCPU not noticing the interrupt.
> > 
> > To fix this use load-acquire/store-release so that, if the target vCPU
> > is IN_GUEST_MODE, we're guaranteed to see a previous disabling of the
> > AVIC.  If AVIC has been disabled in the meanwhile, proceed with the
> > KVM_REQ_EVENT-based delivery.
> > 
> > All this complicated logic is actually exactly how we can handle an
> > incomplete IPI vmexit; the only difference lies in who sets IRR, whether
> > KVM or the processor.
> > 
> > Also incomplete IPI vmexit, has the same races as svm_deliver_avic_intr.
> > therefore just reuse the avic_kick_target_vcpu for it as well.
> > 
> > Reported-by: Maxim Levitsky <mlevitsk@redhat.com>
> 
> Heh, probably don't need a Reported-by for a patch you wrote :-)

Paolo gave me this version, I pretty much sent it as is. We had few iterations
of this patch before though we agreed that the race is finally gone.

> 
> > Co-developed-with: Paolo Bonzini <pbonzini@redhat.com>
> 
> Co-developed-by: is preferred, and should be accompanied by Paolo's SoB.

First time I use this format, so I didn't knew about this.

> 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  arch/x86/kvm/svm/avic.c | 85 +++++++++++++++++++++++++----------------
> >  arch/x86/kvm/x86.c      |  4 +-
> >  2 files changed, 55 insertions(+), 34 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> > index 90364d02f22aa..34f62da2fbadd 100644
> > --- a/arch/x86/kvm/svm/avic.c
> > +++ b/arch/x86/kvm/svm/avic.c
> > @@ -289,6 +289,47 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
> >  	return 0;
> >  }
> >  
> > +static void avic_kick_target_vcpu(struct kvm_vcpu *vcpu)
> > +{
> > +	bool in_guest_mode;
> > +
> > +	/*
> > +	 * vcpu->arch.apicv_active is read after vcpu->mode.  Pairs
> 
> This should say "must be read", not "is read".  It's obvious from the code that
> apicv_active is read second, the comment is there to say that it _must_ be read
> after vcpu->mode.
> 
> > +	 * with smp_store_release in vcpu_enter_guest.
> > +	 */
> > +	in_guest_mode = (smp_load_acquire(&vcpu->mode) == IN_GUEST_MODE);
> 
> IMO, it's marginally clear to initialize the bool.
> 
> 	bool in_guest_mode = (smp_load_acquire(&vcpu->mode) == IN_GUEST_MODE);
> 
> > +	if (READ_ONCE(vcpu->arch.apicv_active)) {
> > +		if (in_guest_mode) {
> > +			/*
> > +			 * Signal the doorbell to tell hardware to inject the IRQ if the vCPU
> > +			 * is in the guest.  If the vCPU is not in the guest, hardware will
> > +			 * automatically process AVIC interrupts at VMRUN.
> 
> Might as well wrap these comments at 80 chars since they're being moved.  Or
> maybe even better....
> 
> 	/* blah blah blah */
> 	if (!READ_ONCE(vcpu->arch.apicv_active)) {
> 		kvm_make_request(KVM_REQ_EVENT, vcpu);
> 		kvm_vcpu_kick(vcpu);
> 		return;
> 	}
> 
> 	if (in_guest_mode) {
> 		...
> 	} else {
> 		....
> 	}
> 
> ...so that the existing comments can be preserved as is.
> 
> > +			 *
> > +			 * Note, the vCPU could get migrated to a different pCPU at any
> > +			 * point, which could result in signalling the wrong/previous
> > +			 * pCPU.  But if that happens the vCPU is guaranteed to do a
> > +			 * VMRUN (after being migrated) and thus will process pending
> > +			 * interrupts, i.e. a doorbell is not needed (and the spurious
> > +			 * one is harmless).
> > +			 */
> > +			int cpu = READ_ONCE(vcpu->cpu);
> > +			if (cpu != get_cpu())
> > +				wrmsrl(SVM_AVIC_DOORBELL, kvm_cpu_get_apicid(cpu));
> > +			put_cpu();
> > +		} else {
> > +			/*
> > +			 * Wake the vCPU if it was blocking.  KVM will then detect the
> > +			 * pending IRQ when checking if the vCPU has a wake event.
> > +			 */
> > +			kvm_vcpu_wake_up(vcpu);
> > +		}
> > +	} else {
> > +		/* Compare this case with __apic_accept_irq.  */
> 
> Honestly, this comment isn't very helpful.  It only takes a few lines to say:
> 
> 		/*
> 		 * Manually signal the event, the __apic_accept_irq() fallback
> 		 * path can't be used if AVIC is disabled after the vector is
> 		 * already queued in the vIRR.
> 		 */
> 
> (incorporating more feedback below)
> 
> > +		kvm_make_request(KVM_REQ_EVENT, vcpu);
> > +		kvm_vcpu_kick(vcpu);
> > +	}
> > +}
> > +
> >  static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
> >  				   u32 icrl, u32 icrh)
> >  {
> > @@ -304,8 +345,10 @@ static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
> >  	kvm_for_each_vcpu(i, vcpu, kvm) {
> >  		if (kvm_apic_match_dest(vcpu, source, icrl & APIC_SHORT_MASK,
> >  					GET_APIC_DEST_FIELD(icrh),
> > -					icrl & APIC_DEST_MASK))
> > -			kvm_vcpu_wake_up(vcpu);
> > +					icrl & APIC_DEST_MASK)) {
> > +			vcpu->arch.apic->irr_pending = true;
> > +			avic_kick_target_vcpu(vcpu);
> > +		}
> >  	}
> >  }
> >  
> > @@ -671,9 +714,12 @@ void svm_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
> >  
> >  int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
> >  {
> > -	if (!vcpu->arch.apicv_active)
> > -		return -1;
> > -
> > +	/*
> > +	 * Below, we have to handle anyway the case of AVIC being disabled
> > +	 * in the middle of this function, and there is hardly any overhead
> > +	 * if AVIC is disabled.  So, we do not bother returning -1 and handle
> > +	 * the kick ourselves for disabled APICv.
> 
> Hmm, my preference would be to keep the "return -1" even though apicv_active must
> be rechecked.  That would help highlight that returning "failure" after this point
> is not an option as it would result in kvm_lapic_set_irr() being called twice.

I don't mind either - this will fix the tracepoint I recently added to report the
number of interrupts that were delivered by AVIC/APICv - with this patch,
all of them count as such.


I will also address all other feedback about the comments and send new version soon.

Thanks for the review!
Best regards,
	Maxim Levitsky

> 
> > +	 */
> >  	kvm_lapic_set_irr(vec, vcpu->arch.apic);
> >  
> >  	/*
> > @@ -684,34 +730,7 @@ int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
> >  	 * the doorbell if the vCPU is already running in the guest.
> >  	 */
> >  	smp_mb__after_atomic();
> > -
> > -	/*
> > -	 * Signal the doorbell to tell hardware to inject the IRQ if the vCPU
> > -	 * is in the guest.  If the vCPU is not in the guest, hardware will
> > -	 * automatically process AVIC interrupts at VMRUN.
> > -	 */
> > -	if (vcpu->mode == IN_GUEST_MODE) {
> > -		int cpu = READ_ONCE(vcpu->cpu);
> > -
> > -		/*
> > -		 * Note, the vCPU could get migrated to a different pCPU at any
> > -		 * point, which could result in signalling the wrong/previous
> > -		 * pCPU.  But if that happens the vCPU is guaranteed to do a
> > -		 * VMRUN (after being migrated) and thus will process pending
> > -		 * interrupts, i.e. a doorbell is not needed (and the spurious
> > -		 * one is harmless).
> > -		 */
> > -		if (cpu != get_cpu())
> > -			wrmsrl(SVM_AVIC_DOORBELL, kvm_cpu_get_apicid(cpu));
> > -		put_cpu();
> > -	} else {
> > -		/*
> > -		 * Wake the vCPU if it was blocking.  KVM will then detect the
> > -		 * pending IRQ when checking if the vCPU has a wake event.
> > -		 */
> > -		kvm_vcpu_wake_up(vcpu);
> > -	}
> > -
> > +	avic_kick_target_vcpu(vcpu);
> >  	return 0;
> >  }
> >  
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 85127b3e3690b..81a74d86ee5eb 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -9869,7 +9869,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
> >  	 * result in virtual interrupt delivery.
> >  	 */
> >  	local_irq_disable();
> > -	vcpu->mode = IN_GUEST_MODE;
> > +
> > +	/* Store vcpu->apicv_active before vcpu->mode.  */
> > +	smp_store_release(&vcpu->mode, IN_GUEST_MODE);
> >  
> >  	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
> >  
> > -- 
> > 2.26.3
> > 


