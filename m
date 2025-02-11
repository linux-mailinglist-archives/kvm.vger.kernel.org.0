Return-Path: <kvm+bounces-37906-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 524EBA313DC
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 19:17:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 04B1E3A2053
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 18:17:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F05B91E501C;
	Tue, 11 Feb 2025 18:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MgZgOujL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229A3261593;
	Tue, 11 Feb 2025 18:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739297864; cv=none; b=qG7yWwk2Iy3cmuPiEORyQOs16Hny/7zyzFSZIfPMCXChyShvzSdk2G5ZASRI+dNz5PO+86jgPQauhlHKjHIo9x7RoLKxOk+2o6jCWc6ERUQ/EFThxq9AIHGo2om45PhfT/vzC73LuOqMyH0TNRmee3R01Szn3p2O+P/RaLXVYXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739297864; c=relaxed/simple;
	bh=xKb41zA9gdmoS3BgiA42TzP1Nvy5MBdlca57nhJWKO4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d8RJV53iBzFTzKewmu4OGMgEQpxAQuF6NsCPUsLw8CARJk4sAKH/u8lO+TF8LRyuQFBcTJcz2BtL3HXPFVy+uUnuAxbZmUoSRuXzE0MFTIfYptRsW5sKyt8WX9LQpZ7fiUV/0GV69GGB/EI2knfJyal0QVpLsFPmRufEDDfkXVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MgZgOujL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 231ECC4CEDD;
	Tue, 11 Feb 2025 18:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739297864;
	bh=xKb41zA9gdmoS3BgiA42TzP1Nvy5MBdlca57nhJWKO4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MgZgOujLb9ViHpT35cLxVuMdGfT7CiAnbethA+Vi1Bu4Us2zaM02Hl60LkpIbnQRN
	 NpxqH/n+tD9pqaULzixaTMdo7lZWf5O3tLVh1hBfILyzLSURXwbP6jtFXORZPZIoN/
	 kkGWsvk9OKg2OAUiA1eHzHekpUvpLMw2+C7G6ne36rYoj5Nu+hlUve/D8O1p+J4N92
	 HZ8zVgj077aTUGip6ulNgwHiQ33u6nI+ew9mQrzIRkz2b7wHRH9V6f8wvNtHwcRcBb
	 xA9Bi1ufpYJpEXWMjJaBPpAsg6qRp/A9bRxhkkVmH8QDV3ZkG1Dai929CDQvJmK9ET
	 hjr49jn3MPvxg==
Date: Tue, 11 Feb 2025 23:43:41 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 3/3] KVM: x86: Decouple APICv activation state from
 apicv_inhibit_reasons
Message-ID: <evszbck4u7afiu7lkafwcu3rs6a7io2zkv53rygrgz544op4ur@m2bugote2wdl>
References: <cover.1738595289.git.naveen@kernel.org>
 <405a98c2f21b9fe73eddbc35c80b60d6523db70c.1738595289.git.naveen@kernel.org>
 <Z6EOxxZA9XLdXvrA@google.com>
 <60cef3e4-8e94-4cf1-92ae-34089e78a82d@redhat.com>
 <Z6FVaLOsPqmAPNWu@google.com>
 <0e4bd3004d97b145037c36c785c19e97b6995d42.camel@redhat.com>
 <Z6JoInXNntIoHLQ8@google.com>
 <604c0d57-ed91-44d2-80d7-4d3710b04142@redhat.com>
 <yrxhngndj37edud6tj5y3vunaf7nirwor4n63yf4275wdocnd3@c77ujgialc6r>
 <Z6t8vRgQLiuMnAA9@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z6t8vRgQLiuMnAA9@google.com>

On Tue, Feb 11, 2025 at 08:37:17AM -0800, Sean Christopherson wrote:
> On Tue, Feb 11, 2025, Naveen N Rao wrote:
> > On Wed, Feb 05, 2025 at 12:36:21PM +0100, Paolo Bonzini wrote:
> > I haven't analyzed this yet, but moving apicv_irq_window into a separate 
> > cacheline is improving the performance in my tests by ~7 to 8%:
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 9e3465e70a0a..d8a40ac49226 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1355,6 +1355,9 @@ struct kvm_arch {
> >         struct kvm_ioapic *vioapic;
> >         struct kvm_pit *vpit;
> >         atomic_t vapics_in_nmi_mode;
> > +
> > +       atomic_t apicv_irq_window;
> > +
> >         struct mutex apic_map_lock;
> >         struct kvm_apic_map __rcu *apic_map;
> >         atomic_t apic_map_dirty;
> > @@ -1365,7 +1368,6 @@ struct kvm_arch {
> >         /* Protects apicv_inhibit_reasons */
> >         struct rw_semaphore apicv_update_lock;
> >         unsigned long apicv_inhibit_reasons;
> > -       atomic_t apicv_irq_window;
> > 
> >         gpa_t wall_clock;
> > 
> > 
> > I chose that spot before apic_map_lock simply because there was a 4 byte 
> > hole there. This happens to also help performance in the AVIC disabled 
> > case by a few percentage points (rather, restores the performance in the 
> > AVIC disabled case).
> > 
> > Before this change, I was trying to see if we could entirely elide the 
> > rwsem read lock in the specific scenario we are seeing the bottleneck.  
> > That is, instead of checking for any other inhibit being set, can we 
> > specifically test for PIT_REINJ while setting the IRQWIN inhibit? Then, 
> > update the inhibit change logic if PIT_REINJ is cleared to re-check the 
> > irq window count.
> > 
> > There's probably a race here somewhere, but FWIW, along with the above 
> > change to 'struct kvm_arch', this helps improve performance by a few 
> > more percentage points helping close the gap to within 2% of the AVIC 
> > disabled case.
> 
> I suspect the issue is that apicv_inhibit_reasons is in the same cache line.  That
> field is read on at least every entry
> 
> 		/*
> 		 * Assert that vCPU vs. VM APICv state is consistent.  An APICv
> 		 * update must kick and wait for all vCPUs before toggling the
> 		 * per-VM state, and responding vCPUs must wait for the update
> 		 * to complete before servicing KVM_REQ_APICV_UPDATE.
> 		 */
> 		WARN_ON_ONCE((kvm_vcpu_apicv_activated(vcpu) != kvm_vcpu_apicv_active(vcpu)) &&
> 			     (kvm_get_apic_mode(vcpu) != LAPIC_MODE_DISABLED));
> 
> and when opening an IRQ window in svm_set_vintr()
> 
> 	WARN_ON(kvm_vcpu_apicv_activated(&svm->vcpu));

Possibly, but we also write to apicv_update_lock every time we update 
apicv_irq_window in kvm_inc_or_dec_irq_window_inhibit(), and that is in 
the same cacheline as apicv_inhibit_reasons:

	if (READ_ONCE(kvm->arch.apicv_inhibit_reasons) & ~BIT(APICV_INHIBIT_REASON_IRQWIN)) {
		guard(rwsem_read)(&kvm->arch.apicv_update_lock);
		if (READ_ONCE(kvm->arch.apicv_inhibit_reasons) & ~BIT(APICV_INHIBIT_REASON_IRQWIN)) {
			atomic_add(add, &kvm->arch.apicv_irq_window);
			return;
		}
	}

Also, note that introducing apicv_irq_window after apicv_inhibit_reasons 
is degrading performance in the AVIC disabled case too. So, it is likely 
that some other cacheline below apicv_inhibit_reasons in kvm_arch may 
also be contributing to this.

> 
> and when handling emulated APIC MMIO in kvm_mmu_faultin_pfn():
> 
> 		/*
> 		 * If the APIC access page exists but is disabled, go directly
> 		 * to emulation without caching the MMIO access or creating a
> 		 * MMIO SPTE.  That way the cache doesn't need to be purged
> 		 * when the AVIC is re-enabled.
> 		 */
> 		if (!kvm_apicv_activated(vcpu->kvm))
> 			return RET_PF_EMULATE;
> 
> Hmm, now that I think about it, lack of emulated MMIO caching that might explain
> the 2% gap.  Do you see the same gap if the guest is using x2APIC?

Are you referring to hybrid-AVIC? I am testing this on a Turin system 
that has x2AVIC support, so the guest is running in x2APIC/x2AVIC mode 
(kvm_amd avic=0/avic=1)


- Naveen


