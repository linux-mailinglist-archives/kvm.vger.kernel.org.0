Return-Path: <kvm+bounces-37880-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 66F2BA31065
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 16:57:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DFCCB164A1F
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 15:57:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76087253B73;
	Tue, 11 Feb 2025 15:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t6kUUSbY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5A3230D0E;
	Tue, 11 Feb 2025 15:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739289465; cv=none; b=NXL9PpGJ/IvJycfW2Y++CYvsh14N93SdmFVi44+uZm7r3bH+LU5HPLs+gpsCBVdtPa80O339Nxad5CjTS+QFqAh8IGPNcKQQLNEZ/LM4WzNmmW7jVe0iOPoqjh12nZ4HwUNn9xynLNAaSOYKwl8ESn8JmL9Ukx6lyxTicT8HL/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739289465; c=relaxed/simple;
	bh=uIApT9eZfOkjxW+tghEwB5jzwb0KkhHL4LwhuptkIlE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ohVSKgHCnXdY/wTzziDC0WgvBRJzxCUfdamVJfGC0qC/fa04C/m7JMG0R1V3dHqJcfimduGK7zpg7opcJkoaIPT5HiuO9r95eoY3OHJdyvAoOhS+2M08z58FP01U0PdLOSMbyu/sNDKeAlkz/ETFSgo22nCDbvR8e19nvmuWnIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t6kUUSbY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AA9FC4CEDD;
	Tue, 11 Feb 2025 15:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739289465;
	bh=uIApT9eZfOkjxW+tghEwB5jzwb0KkhHL4LwhuptkIlE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t6kUUSbY89Kvrb40wajktPBL05ZzvUvJZLV7qFJ+OtsEteDSCcMgLeDavagEfDQyF
	 rlwQsbbNWHW2JBmxh1e3L91SiMWTqKKevlyu5izk7cBzutktT4jA1NDS2CK7cqHbCe
	 nBaYQwQBj18NoG1oOHvvkn/eMzOka4Z1iDyIzjU/n79BWITFki3b9ygIx9johilaL8
	 lcZKJwM+tcHsjhiLn/NbPWDUCQPR1rYK2AvNyowN0RwR9DkZws/Nykc+TnypdWk366
	 ic7JQFV6TqKNx9mWOTKcr48uSSFJKKy2r08pWCVTE1/C4x82xHjMYoUFKX1TGYFexu
	 4cotrWL7YEGKg==
Date: Tue, 11 Feb 2025 21:27:14 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 3/3] KVM: x86: Decouple APICv activation state from
 apicv_inhibit_reasons
Message-ID: <yrxhngndj37edud6tj5y3vunaf7nirwor4n63yf4275wdocnd3@c77ujgialc6r>
References: <cover.1738595289.git.naveen@kernel.org>
 <405a98c2f21b9fe73eddbc35c80b60d6523db70c.1738595289.git.naveen@kernel.org>
 <Z6EOxxZA9XLdXvrA@google.com>
 <60cef3e4-8e94-4cf1-92ae-34089e78a82d@redhat.com>
 <Z6FVaLOsPqmAPNWu@google.com>
 <0e4bd3004d97b145037c36c785c19e97b6995d42.camel@redhat.com>
 <Z6JoInXNntIoHLQ8@google.com>
 <604c0d57-ed91-44d2-80d7-4d3710b04142@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <604c0d57-ed91-44d2-80d7-4d3710b04142@redhat.com>

On Wed, Feb 05, 2025 at 12:36:21PM +0100, Paolo Bonzini wrote:
> On 2/4/25 20:18, Sean Christopherson wrote:
> > On Mon, Feb 03, 2025, Maxim Levitsky wrote:
> > > On Mon, 2025-02-03 at 15:46 -0800, Sean Christopherson wrote:
> > > > On Mon, Feb 03, 2025, Paolo Bonzini wrote:
> > > > > On 2/3/25 19:45, Sean Christopherson wrote:

<snip>

> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index b2d9a16fd4d3..7388f4cfe468 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -10604,7 +10604,11 @@ void __kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
> >   	old = new = kvm->arch.apicv_inhibit_reasons;
> > -	set_or_clear_apicv_inhibit(&new, reason, set);
> > +	if (reason != APICV_INHIBIT_REASON_IRQWIN)
> > +		set_or_clear_apicv_inhibit(&new, reason, set);
> > +
> > +	set_or_clear_apicv_inhibit(&new, APICV_INHIBIT_REASON_IRQWIN,
> > +				   atomic_read(&kvm->arch.apicv_irq_window));
> >   	if (!!old != !!new) {
> >   		/*
> > @@ -10645,6 +10649,36 @@ void kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
> >   }
> >   EXPORT_SYMBOL_GPL(kvm_set_or_clear_apicv_inhibit);
> > +void kvm_inc_or_dec_irq_window_inhibit(struct kvm *kvm, bool inc)
> > +{
> > +	bool toggle;
> > +
> > +	/*
> > +	 * The IRQ window inhibit has a cyclical dependency of sorts, as KVM
> > +	 * needs to manually inject IRQs and thus detect interrupt windows if
> > +	 * APICv is disabled/inhibitied.  To avoid thrashing if the IRQ window
> > +	 * is being requested because APICv is already inhibited, toggle the
> > +	 * actual inhibit (and take the lock for write) if and only if there's
> > +	 * no other inhibit.  KVM evaluates the IRQ window count when _any_
> > +	 * inhibit changes, i.e. the IRQ window inhibit can be lazily updated
> > +	 * on the next inhibit change (if one ever occurs).
> > +	 */
> > +	down_read(&kvm->arch.apicv_update_lock);
> > +
> > +	if (inc)
> > +		toggle = atomic_inc_return(&kvm->arch.apicv_irq_window) == 1;
> > +	else
> > +		toggle = atomic_dec_return(&kvm->arch.apicv_irq_window) == 0;
> > +
> > +	toggle = toggle && !(kvm->arch.apicv_inhibit_reasons & ~BIT(APICV_INHIBIT_REASON_IRQWIN));
> > +
> > +	up_read(&kvm->arch.apicv_update_lock);
> > +
> > +	if (toggle)
> > +		kvm_set_or_clear_apicv_inhibit(kvm, APICV_INHIBIT_REASON_IRQWIN, inc);
> 
> I'm not super confident in breaking the critical section...  Another possibility:
> 
> void kvm_inc_or_dec_irq_window_inhibit(struct kvm *kvm, bool inc)
> {
>         int add = inc ? 1 : -1;
> 
> 	if (!enable_apicv)
> 		return;
> 
>         /*
>         * IRQ windows happen either because of ExtINT injections, or because
> 	* APICv is already disabled/inhibited for another reason.  While ExtINT
> 	* injections are rare and should not happen while the vCPU is running
> 	* its actual workload, it's worth avoiding thrashing if the IRQ window
>         * is being requested because APICv is already inhibited.  So, toggle the
>         * the actual inhibit (which requires taking the lock forwrite) if and
> 	* only if there's no other inhibit.  kvm_set_or_clear_apicv_inhibit()
>         * always evaluates the IRQ window count; thus the IRQ window inhibit
>         * call _will_ be lazily updated on the next call, if it ever happens.
>         */
>         if (READ_ONCE(kvm->arch.apicv_inhibit_reasons) & ~BIT(APICV_INHIBIT_REASON_IRQWIN)) {
>                 guard(rwsem_read)(&kvm->arch.apicv_update_lock);
>                 if (READ_ONCE(kvm->arch.apicv_inhibit_reasons) & ~BIT(APICV_INHIBIT_REASON_IRQWIN)) {
>                         atomic_add(add, &kvm->arch.apicv_irq_window);
>                         return;
>                 }
>         }
> 
> 	/*
> 	 * Strictly speaking the lock is only needed if going 0->1 or 1->0,
> 	 * a la atomic_dec_and_mutex_lock.  However, ExtINTs are rare and
> 	 * only target a single CPU, so that is the common case; do not
> 	 * bother eliding the down_write()/up_write() pair.
> 	 */
>         guard(rwsem_write)(&kvm->arch.apicv_update_lock);
>         if (atomic_add_return(add, &kvm->arch.apicv_irq_window) == inc)
>                 __kvm_set_or_clear_apicv_inhibit(kvm, APICV_INHIBIT_REASON_IRQWIN, inc);
> }
> EXPORT_SYMBOL_GPL(kvm_inc_or_dec_irq_window_inhibit);

I haven't analyzed this yet, but moving apicv_irq_window into a separate 
cacheline is improving the performance in my tests by ~7 to 8%:

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9e3465e70a0a..d8a40ac49226 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1355,6 +1355,9 @@ struct kvm_arch {
        struct kvm_ioapic *vioapic;
        struct kvm_pit *vpit;
        atomic_t vapics_in_nmi_mode;
+
+       atomic_t apicv_irq_window;
+
        struct mutex apic_map_lock;
        struct kvm_apic_map __rcu *apic_map;
        atomic_t apic_map_dirty;
@@ -1365,7 +1368,6 @@ struct kvm_arch {
        /* Protects apicv_inhibit_reasons */
        struct rw_semaphore apicv_update_lock;
        unsigned long apicv_inhibit_reasons;
-       atomic_t apicv_irq_window;

        gpa_t wall_clock;


I chose that spot before apic_map_lock simply because there was a 4 byte 
hole there. This happens to also help performance in the AVIC disabled 
case by a few percentage points (rather, restores the performance in the 
AVIC disabled case).

Before this change, I was trying to see if we could entirely elide the 
rwsem read lock in the specific scenario we are seeing the bottleneck.  
That is, instead of checking for any other inhibit being set, can we 
specifically test for PIT_REINJ while setting the IRQWIN inhibit? Then, 
update the inhibit change logic if PIT_REINJ is cleared to re-check the 
irq window count.

There's probably a race here somewhere, but FWIW, along with the above 
change to 'struct kvm_arch', this helps improve performance by a few 
more percentage points helping close the gap to within 2% of the AVIC 
disabled case.


- Naveen




diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 274eb99aa97b..bd861342b949 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10596,6 +10596,7 @@ void __kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
                                      enum kvm_apicv_inhibit reason, bool set)
 {
        unsigned long old, new;
+       bool retried = false;
 
        lockdep_assert_held_write(&kvm->arch.apicv_update_lock);
 
@@ -10607,6 +10608,7 @@ void __kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
        if (reason != APICV_INHIBIT_REASON_IRQWIN)
                set_or_clear_apicv_inhibit(&new, reason, set);
 
+again:
        set_or_clear_apicv_inhibit(&new, APICV_INHIBIT_REASON_IRQWIN,
                                   atomic_read(&kvm->arch.apicv_irq_window));
 
@@ -10635,6 +10637,14 @@ void __kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
        } else {
                kvm->arch.apicv_inhibit_reasons = new;
        }
+
+       /* If PIT_REINJ inhibit is being cleared, ensure we have updated copy of apicv_irq_window */
+       if (reason == APICV_INHIBIT_REASON_PIT_REINJ && !set && !retried) {
+               smp_mb();
+               retried = true;
+               old = new = kvm->arch.apicv_inhibit_reasons;
+               goto again;
+       }
 }
 
 void kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
@@ -10656,34 +10666,10 @@ void kvm_inc_or_dec_irq_window_inhibit(struct kvm *kvm, bool inc)
        if (!enable_apicv)
                return;
 
-       /*
-        * IRQ windows happen either because of ExtINT injections, or because
-        * APICv is already disabled/inhibited for another reason.  While ExtINT
-        * injections are rare and should not happen while the vCPU is running
-        * its actual workload, it's worth avoiding thrashing if the IRQ window
-        * is being requested because APICv is already inhibited.  So, toggle the
-        * the actual inhibit (which requires taking the lock forwrite) if and
-        * only if there's no other inhibit.  kvm_set_or_clear_apicv_inhibit()
-        * always evaluates the IRQ window count; thus the IRQ window inhibit
-        * call _will_ be lazily updated on the next call, if it ever happens.
-        */
-       if (READ_ONCE(kvm->arch.apicv_inhibit_reasons) & ~BIT(APICV_INHIBIT_REASON_IRQWIN)) {
-               guard(rwsem_read)(&kvm->arch.apicv_update_lock);
-               if (READ_ONCE(kvm->arch.apicv_inhibit_reasons) & ~BIT(APICV_INHIBIT_REASON_IRQWIN)) {
-                       atomic_add(add, &kvm->arch.apicv_irq_window);
-                       return;
-               }
-       }
-
-       /*
-        * Strictly speaking the lock is only needed if going 0->1 or 1->0,
-        * a la atomic_dec_and_mutex_lock.  However, ExtINTs are rare and
-        * only target a single CPU, so that is the common case; do not
-        * bother eliding the down_write()/up_write() pair.
-        */
-       guard(rwsem_write)(&kvm->arch.apicv_update_lock);
-       if (atomic_add_return(add, &kvm->arch.apicv_irq_window) == inc)
-               __kvm_set_or_clear_apicv_inhibit(kvm, APICV_INHIBIT_REASON_IRQWIN, inc);
+       atomic_add(add, &kvm->arch.apicv_irq_window);
+       smp_mb();
+       if (!(READ_ONCE(kvm->arch.apicv_inhibit_reasons) & BIT(APICV_INHIBIT_REASON_PIT_REINJ)))
+               kvm_set_or_clear_apicv_inhibit(kvm, APICV_INHIBIT_REASON_IRQWIN, inc);
 }
 EXPORT_SYMBOL_GPL(kvm_inc_or_dec_irq_window_inhibit);






