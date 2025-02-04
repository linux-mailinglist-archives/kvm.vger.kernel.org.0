Return-Path: <kvm+bounces-37277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F998A27C7F
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 21:08:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 287881883C7C
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 20:08:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4737218EBF;
	Tue,  4 Feb 2025 20:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ce9cklus"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 006922063F5
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 20:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738699693; cv=none; b=KpaFh6b3GxaxfFXFX4ORtVzoOvZNWee9O3E/9aqa83gVNdPje0ZwhsADC5UsbSAqM+VyGKSBDszoDMGWy2gn6U3CbXSvpiB1zcFDj5mHcGYRWWCNT+cwj8ejOsRcm3SDpI9iOnAyK1tw5h5W5IukU1w9GRyGEyhbrv9OWl6UigI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738699693; c=relaxed/simple;
	bh=VHtnI0C+It1zDRsGDuq5JiICmXRaY48sY7zd06XHfhc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=c75bZS5f8jbOIccfjbLa+wfv9r8PbGoceU5P+5ytICzMWwzChShyWr0gLS+536aPnLsGz+tn3l5TNqPYPqH5C+mWO3ESvJ4nCBCXdAHWJn/Ln2AMdmNo3HJKwsjvxCuGFtSeRPCWh+ZZXinzJ0qjMA4a1LytAoh0mFQ6J2IZdCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ce9cklus; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738699690;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n+rCtdZuxU9qb1fxlGzgU1I/OUCzo/42/LlOykkLNLs=;
	b=Ce9cklus0A4uxPIC/qdMnsKca3eeCYKHXa7YibJ3JyeayYcNariNLlXYXlgFaJJ8QltxXE
	YnqkZ7+9oaZvcUwntM8A4AZCDnCaYE27hcs7qsGr402Axv1fs7/P5PfrOGyuX+i8ICknSw
	XIPCa985jVqAwvJ5s0OagVAdbSak8ew=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-470-y_QcPQk4M16si9hClK_rKQ-1; Tue, 04 Feb 2025 15:08:07 -0500
X-MC-Unique: y_QcPQk4M16si9hClK_rKQ-1
X-Mimecast-MFC-AGG-ID: y_QcPQk4M16si9hClK_rKQ
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6e42e3cb051so6331936d6.0
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2025 12:08:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738699687; x=1739304487;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=n+rCtdZuxU9qb1fxlGzgU1I/OUCzo/42/LlOykkLNLs=;
        b=i9dtUoFmOwywNZGjXLOGyb2s1weMAfFTYqNLpvVkt9h9mStL/O6RwnsHgdw/CJJFVO
         /I4IudVyF9eoY3h1tVmEpStOtojRX7ZcD1wXEj7GUaJ6MdVKAOxxlr7670qOxGL9JBZP
         GMByXhcQksSADZOlXBJgbsfBDms3LFkOwjVboV9FVxMxPFyD401Q4wMLBqFzregkEZVq
         u8GMtCi4DYvZzPt+mR4coYxYvRn1Vtv/ZdYKO+T05/ZuUWhdq8CTV/EydtvlUtZKok7a
         h9vLnDs/rRn0gSWsSDM36z8vXaHbpk9pbkPjj0WTtrNCU9L6+QJu3oSWzfCiHJ7wOpQ8
         SMMA==
X-Forwarded-Encrypted: i=1; AJvYcCWl++hDHMp4WGHjZjgE9gCg3VnrbyliIlaOb+CQ1ornj3AlHxcZL0R/hQIqTbYYHg3C0o8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSvBdgomJMI/sSYHLfqwCd2MBsz/QZJNSGLjI4PAwdRB+eAwfi
	SxB+DUheRUxkHfI2yB2f/N8rnhQGmRX+0kOZjCTIXLpPpDmFG5gfF0s0WnN3e2TjI0lx7O3pU/1
	n1q9kbg/dq1fvNKZ2pHwUKZd44qB2R7OI/8kVvt/JjkYHVCGBNg==
X-Gm-Gg: ASbGncsVZMd8R0P6yqgaWOk/cY1zk7/OXZF3KJL2YlPQ1OhyNG4a4fCfPNdNCiyO9Li
	J1VLtRkNqvL152i5RJ2V6SgUZwsacMa5+QYjLQDHbjhmN3tsT44llqjlaf9gw8vzwqv6lzr/q3i
	bmcjkJDXRLrKBA46Q6VNDmnQ6V4TDjsS1tgKYvi3RVzkV8VzEqSrmVBWGQLhyLTxo9G6wnpKyYR
	lRL6Oq0A+y9YETLdDFMg14WrO1OdxQwNEY6AvsdE6JRH4lQY0UHL74Pd645sd8Dw5FKnVFcmful
	Sz3n
X-Received: by 2002:a05:6214:2608:b0:6e2:4ad7:24c9 with SMTP id 6a1803df08f44-6e42fb99f18mr1551676d6.2.1738699686955;
        Tue, 04 Feb 2025 12:08:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHzUQWLiTwvoyrVA1+MQsIeNENJzLtO5R2LW10XHcia1XSvL9RymnJjyxsumyoSwBOuy0/PFg==
X-Received: by 2002:a05:6214:2608:b0:6e2:4ad7:24c9 with SMTP id 6a1803df08f44-6e42fb99f18mr1551146d6.2.1738699686640;
        Tue, 04 Feb 2025 12:08:06 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e2547f3e17sm65794116d6.22.2025.02.04.12.08.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 12:08:05 -0800 (PST)
Message-ID: <2c9ffa51b82b4ae75e803d5b30bf74eda9350686.camel@redhat.com>
Subject: Re: [PATCH 3/3] KVM: x86: Decouple APICv activation state from
 apicv_inhibit_reasons
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, "Naveen N Rao (AMD)"
 <naveen@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, Vasant Hegde
 <vasant.hegde@amd.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
Date: Tue, 04 Feb 2025 15:08:04 -0500
In-Reply-To: <Z6JoInXNntIoHLQ8@google.com>
References: <cover.1738595289.git.naveen@kernel.org>
	 <405a98c2f21b9fe73eddbc35c80b60d6523db70c.1738595289.git.naveen@kernel.org>
	 <Z6EOxxZA9XLdXvrA@google.com>
	 <60cef3e4-8e94-4cf1-92ae-34089e78a82d@redhat.com>
	 <Z6FVaLOsPqmAPNWu@google.com>
	 <0e4bd3004d97b145037c36c785c19e97b6995d42.camel@redhat.com>
	 <Z6JoInXNntIoHLQ8@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Tue, 2025-02-04 at 11:18 -0800, Sean Christopherson wrote:
> On Mon, Feb 03, 2025, Maxim Levitsky wrote:
> > On Mon, 2025-02-03 at 15:46 -0800, Sean Christopherson wrote:
> > > On Mon, Feb 03, 2025, Paolo Bonzini wrote:
> > > > On 2/3/25 19:45, Sean Christopherson wrote:
> > > > > Unless there's a very, very good reason to support a use case that generates
> > > > > ExtInts during boot, but _only_ during boot, and otherwise doesn't have any APICv
> > > > > ihibits, I'm leaning towards making SVM's IRQ window inhibit sticky, i.e. never
> > > > > clear it.
> > > > 
> > > > BIOS tends to use PIT, so that may be too much.  With respect to Naveen's report
> > > > of contention on apicv_update_lock, I would go with the sticky-bit idea but apply
> > > > it to APICV_INHIBIT_REASON_PIT_REINJ.
> > > 
> > > That won't work, at least not with yet more changes, because KVM creates the
> > > in-kernel PIT with reinjection enabled by default.  The stick-bit idea is that
> > > if a bit is set and can never be cleared, then there's no need to track new
> > > updates.  Since userspace needs to explicitly disable reinjection, the inhibit
> > > can't be sticky.
> > I confirmed this with a trace, this is indeed the case.
> > 
> > > I assume We could fudge around that easily enough by deferring the inhibit until
> > > a vCPU is created (or run?), but piggybacking PIT_REINJ won't help the userspace
> > > I/O APIC case.
> > > 
> > > > I don't love adding another inhibit reason but, together, these two should
> > > > remove the contention on apicv_update_lock.  Another idea could be to move
> > > > IRQWIN to per-vCPU reason but Maxim tells me that it's not so easy.
> > 
> > I retract this statement, it was based on my knowledge from back when I
> > implemented it.
> > 
> > Looking at the current code again, this should be possible and can be a nice
> > cleanup regardless.
> > 
> > (Or I just might have forgotten the reason that made me think back then that
> > this is not worth it, because I do remember well that I wanted to make IRQWIN
> > inhibit to be per vcpu)
> 
> The complication is the APIC page.  That's not a problem for vCPUs running in L2
> because they'll use a different MMU, i.e. a different set of SPTEs that never map
> the APIC backing page.  At least, that's how it's supposed to work[*].  ;-)

Yes it is that thing that I forgot. Because of this AVIC can't be inhibited on a single vCPU, 
and the only exception is nesting.
I need to write this down somewhere so that I won't forget this again.


> 
> For IRQWIN, turning off APICv for the current vCPU will leave the APIC SPTEs in
> place and so KVM will fail to intercept accesses to the APIC page.  And making
> IRQWIN a per-vCPU inhibit won't help performance in the case where there is no
> other inhibit, because (a) toggling it on/off requires taking mmu_lock for writing
> and doing a remote TLB flush, and (b) unless the guest is doing something bizarre,
> only one vCPU will be receiving ExtInt IRQs.  I.e. I don't think trying to make
> IRQWIN a pure per-vCPU inhibit is necessary for performance.
> 
> After fiddling with a bunch of ideas, I think the best approach to address both
> issues is to add a counter for the IRQ window (addresses the per-vCPU aspect of
> IRQ windows), set/clear the IRQWIN inhibit according to the counter when *any*
> inhibit changes, and then force an immediate update if and only if the count hits
> a 0<=>1 transition *and* there is no other inhibit.  That would address the flaw
> Naveen found without needing to make PIT_REINJ sticky.
> 
> Guarding the count with apicv_update_lock held for read ensures that if there is
> a racing change to a different inhibit, that either kvm_inc_or_dec_irq_window_inhibit()
> will see no inhibits and go down the slow path, or __kvm_set_or_clear_apicv_inhibit()
> will set IRQWIN accordingly.
> 
> Compile tested only (and probably needs to be split into multiple patches).  I'll
> try to take it for a spin later today.
> 
> [*] https://lore.kernel.org/all/20250130010825.220346-1-seanjc@google.com
> 
> ---
>  arch/x86/include/asm/kvm_host.h | 13 ++++++++++
>  arch/x86/kvm/svm/svm.c          | 43 +++++++++------------------------
>  arch/x86/kvm/svm/svm.h          |  1 +
>  arch/x86/kvm/x86.c              | 36 ++++++++++++++++++++++++++-
>  4 files changed, 61 insertions(+), 32 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 5193c3dfbce1..9e3465e70a0a 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1365,6 +1365,7 @@ struct kvm_arch {
>  	/* Protects apicv_inhibit_reasons */
>  	struct rw_semaphore apicv_update_lock;
>  	unsigned long apicv_inhibit_reasons;
> +	atomic_t apicv_irq_window;
>  
>  	gpa_t wall_clock;
>  
> @@ -2203,6 +2204,18 @@ static inline void kvm_clear_apicv_inhibit(struct kvm *kvm,
>  	kvm_set_or_clear_apicv_inhibit(kvm, reason, false);
>  }
>  
> +void kvm_inc_or_dec_irq_window_inhibit(struct kvm *kvm, bool inc);
> +
> +static inline void kvm_inc_apicv_irq_window(struct kvm *kvm)
> +{
> +	kvm_inc_or_dec_irq_window_inhibit(kvm, true);
> +}
> +
> +static inline void kvm_dec_apicv_irq_window(struct kvm *kvm)
> +{
> +	kvm_inc_or_dec_irq_window_inhibit(kvm, false);
> +}
> +
>  unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
>  				      unsigned long a0, unsigned long a1,
>  				      unsigned long a2, unsigned long a3,
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 7640a84e554a..668db3bfff3d 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1636,9 +1636,13 @@ static void svm_set_vintr(struct vcpu_svm *svm)
>  	struct vmcb_control_area *control;
>  
>  	/*
> -	 * The following fields are ignored when AVIC is enabled
> +	 * vIRQ is ignored by hardware AVIC is enabled, and so AVIC must be
> +	 * inhibited to detect the interrupt window.
>  	 */
> -	WARN_ON(kvm_vcpu_apicv_activated(&svm->vcpu));
> +	if (enable_apicv && !is_guest_mode(&svm->vcpu)) {
> +		svm->avic_irq_window = true;
> +		kvm_inc_apicv_irq_window(svm->vcpu.kvm);
> +	}
>  
>  	svm_set_intercept(svm, INTERCEPT_VINTR);
>  
> @@ -1666,6 +1670,11 @@ static void svm_set_vintr(struct vcpu_svm *svm)
>  
>  static void svm_clear_vintr(struct vcpu_svm *svm)
>  {
> +	if (svm->avic_irq_window && !is_guest_mode(&svm->vcpu)) {
> +		svm->avic_irq_window = false;
> +		kvm_dec_apicv_irq_window(svm->vcpu.kvm);
> +	}
> +
>  	svm_clr_intercept(svm, INTERCEPT_VINTR);
>  
>  	/* Drop int_ctl fields related to VINTR injection.  */
> @@ -3219,20 +3228,6 @@ static int interrupt_window_interception(struct kvm_vcpu *vcpu)
>  	kvm_make_request(KVM_REQ_EVENT, vcpu);
>  	svm_clear_vintr(to_svm(vcpu));
>  
> -	/*
> -	 * If not running nested, for AVIC, the only reason to end up here is ExtINTs.
> -	 * In this case AVIC was temporarily disabled for
> -	 * requesting the IRQ window and we have to re-enable it.
> -	 *
> -	 * If running nested, still remove the VM wide AVIC inhibit to
> -	 * support case in which the interrupt window was requested when the
> -	 * vCPU was not running nested.
> -
> -	 * All vCPUs which run still run nested, will remain to have their
> -	 * AVIC still inhibited due to per-cpu AVIC inhibition.
> -	 */

Please keep these comment that explain why inhibit has to be cleared here,
and the code as well.

The reason is that IRQ window can be requested before nested entry, which will lead to
VM wide inhibit, and the interrupt window can happen while nested because nested hypervisor
can opt to not intercept interrupts. If that happens, the AVIC will remain inhibited forever.
 


> -	kvm_clear_apicv_inhibit(vcpu->kvm, APICV_INHIBIT_REASON_IRQWIN);
> -
>  	++vcpu->stat.irq_window_exits;
>  	return 1;
>  }
> @@ -3879,22 +3874,8 @@ static void svm_enable_irq_window(struct kvm_vcpu *vcpu)
>  	 * enabled, the STGI interception will not occur. Enable the irq
>  	 * window under the assumption that the hardware will set the GIF.
>  	 */
> -	if (vgif || gif_set(svm)) {
> -		/*
> -		 * IRQ window is not needed when AVIC is enabled,
> -		 * unless we have pending ExtINT since it cannot be injected
> -		 * via AVIC. In such case, KVM needs to temporarily disable AVIC,
> -		 * and fallback to injecting IRQ via V_IRQ.
> -		 *
> -		 * If running nested, AVIC is already locally inhibited
> -		 * on this vCPU, therefore there is no need to request
> -		 * the VM wide AVIC inhibition.
> -		 */

Please keep this comment because it explains why this is needed.

As far as I remember there was a reason, not only related to performance,
to avoid inhibiting AVIC here VM wide.


Best regards,
	Maxim Levitsky




> -		if (!is_guest_mode(vcpu))
> -			kvm_set_apicv_inhibit(vcpu->kvm, APICV_INHIBIT_REASON_IRQWIN);
> -
> +	if (vgif || gif_set(svm))
>  		svm_set_vintr(svm);
> -	}
>  }
>  
>  static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 9d7cdb8fbf87..8eefed0a865a 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -323,6 +323,7 @@ struct vcpu_svm {
>  
>  	bool guest_state_loaded;
>  
> +	bool avic_irq_window;
>  	bool x2avic_msrs_intercepted;
>  
>  	/* Guest GIF value, used when vGIF is not enabled */
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b2d9a16fd4d3..7388f4cfe468 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10604,7 +10604,11 @@ void __kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
>  
>  	old = new = kvm->arch.apicv_inhibit_reasons;
>  
> -	set_or_clear_apicv_inhibit(&new, reason, set);
> +	if (reason != APICV_INHIBIT_REASON_IRQWIN)
> +		set_or_clear_apicv_inhibit(&new, reason, set);
> +
> +	set_or_clear_apicv_inhibit(&new, APICV_INHIBIT_REASON_IRQWIN,
> +				   atomic_read(&kvm->arch.apicv_irq_window));
>  
>  	if (!!old != !!new) {
>  		/*
> @@ -10645,6 +10649,36 @@ void kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
>  }
>  EXPORT_SYMBOL_GPL(kvm_set_or_clear_apicv_inhibit);
>  
> +void kvm_inc_or_dec_irq_window_inhibit(struct kvm *kvm, bool inc)
> +{
> +	bool toggle;
> +
> +	/*
> +	 * The IRQ window inhibit has a cyclical dependency of sorts, as KVM
> +	 * needs to manually inject IRQs and thus detect interrupt windows if
> +	 * APICv is disabled/inhibitied.  To avoid thrashing if the IRQ window
> +	 * is being requested because APICv is already inhibited, toggle the
> +	 * actual inhibit (and take the lock for write) if and only if there's
> +	 * no other inhibit.  KVM evaluates the IRQ window count when _any_
> +	 * inhibit changes, i.e. the IRQ window inhibit can be lazily updated
> +	 * on the next inhibit change (if one ever occurs).
> +	 */
> +	down_read(&kvm->arch.apicv_update_lock);
> +
> +	if (inc)
> +		toggle = atomic_inc_return(&kvm->arch.apicv_irq_window) == 1;
> +	else
> +		toggle = atomic_dec_return(&kvm->arch.apicv_irq_window) == 0;
> +
> +	toggle = toggle && !(kvm->arch.apicv_inhibit_reasons & ~BIT(APICV_INHIBIT_REASON_IRQWIN));
> +
> +	up_read(&kvm->arch.apicv_update_lock);
> +
> +	if (toggle)
> +		kvm_set_or_clear_apicv_inhibit(kvm, APICV_INHIBIT_REASON_IRQWIN, inc);
> +}
> +EXPORT_SYMBOL_GPL(kvm_inc_or_dec_irq_window_inhibit);
> +
>  static void vcpu_scan_ioapic(struct kvm_vcpu *vcpu)
>  {
>  	if (!kvm_apic_present(vcpu))
> 
> base-commit: eb723766b1030a23c38adf2348b7c3d1409d11f0




