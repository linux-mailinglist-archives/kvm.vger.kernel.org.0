Return-Path: <kvm+bounces-33372-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 489149EA472
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 02:40:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 11EA91643AC
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 01:40:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B970670823;
	Tue, 10 Dec 2024 01:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wQxcykbv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F97F17BD9
	for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 01:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733794851; cv=none; b=dEKDhwhj+hduKIPejp/eDghX62iRn2s2zkGcEzZtDMPcQQ1Vkiz6HY+ejpVnd6SJ4XRt64GRLmYEOW9FQ0q2GewPs4Ed7CiKfc/QvDvLrunLqNML9Xo68y28MNTh99Lohdw843Vy7Y9BLJEZyqw0hyHIOOo4uKJ9dCU7EYuBWiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733794851; c=relaxed/simple;
	bh=XP/k/q0i0lQJ0g5pYg/DpgSgV9EvWoGsrklS8h7J4Qk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RIlAMerlXv+hzaAQNm0Dte9SjhwNGJHqGq5t3bJ9qEl0H68rQ/zPoewjFNaG1NY1p564Bv3D1MeoRgWYXYerzx0T5kK+/yaEAe54MqVdS+CzjzIOZMPPOoOdpUtwDILTsESKtDtVI52XHTTndnphCe/qcKPir/4x/9r2qAUfi5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wQxcykbv; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-725e8775611so1510184b3a.1
        for <kvm@vger.kernel.org>; Mon, 09 Dec 2024 17:40:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733794849; x=1734399649; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1bErHPnG0cBPr7OTaDgSE9m8Ooeq0/K7I1LubD/D/QQ=;
        b=wQxcykbvEIxw5rjI6RpxarLQNczAq4oPN6AN9Kpw2B9WAVbu4SarAMr2n41jkauvD4
         OQklKAkEulaXQW57vr75N1lDUQsPV9ptYIb8msn0Er6e2K2Bb6u1Z02axrmxUVWpizVE
         4wNghWMYDJQaUAOukK/+EUlE4tBGcJ0iP0FuZwg5V277zrfLE7uYBG/b9RwhAD5gQaK7
         QFPTaEc1EQJqQtEf7lZvpZac7BPNVQbR+zkgNqMnaygnbt+mBCous5Onsf4UiKyoPlEb
         0XTOZcBn2UbNA+v8FEM1m9u/PKNksGHQeUQkdnJJdPnBViSW8GX/ESDmRLVKXI94aFPQ
         XUvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733794849; x=1734399649;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1bErHPnG0cBPr7OTaDgSE9m8Ooeq0/K7I1LubD/D/QQ=;
        b=qzjnjuu10+pAiYYEVguUhOwAfQ7lJucRVyy13ab3XssvS3Em3qaJYyEmZNg+tqmiBJ
         uD2DafTgNr6hMM5bzrDvG8hLNZtP6e8X06JqoxTXKUQ+sLDo9QwGITsom6fT0EOHFkh6
         8vhivsJze1hHmDLTZR8I6r0eDG/Nc8sABi2Kax57OyYC7WNhgjVCU/ybc8T45j4dbRLD
         hldLYFw1BklQSe/15ReTIac5//PRShdtqOAXCR0jSu3P5wZKU/DDNhxCcz39iic/vGa8
         lffPTyNlNU+GVagdll9Shnem7BcmspJlBtqdrxR0ErzkGX96OJFn1NUJKwltQZIetYi5
         7MGA==
X-Gm-Message-State: AOJu0YwMU4Sc2OJn6AfF3AGSO0wEDIWJRY69FRlsY9cis08/dP9PioPY
	VvrGtobjJBJyJRwqEWyqJ2WBeJWf2shJRU/olZ/qM5SS9E98jEwIfzcO8f2/Jn6YqTmjlaCoWVt
	jkQ==
X-Google-Smtp-Source: AGHT+IHW1z/+JqVrrgmSCERALc9rLSyuwidSnvty9L39Mhbl3kmC9YetkXdy8traWBT/taiajplFM+S0g/k=
X-Received: from pfbbe25.prod.google.com ([2002:a05:6a00:1f19:b0:725:e6a0:55ea])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:22c6:b0:725:9edd:dc30
 with SMTP id d2e1a72fcca58-7273cb1af91mr3890080b3a.12.1733794849659; Mon, 09
 Dec 2024 17:40:49 -0800 (PST)
Date: Mon, 9 Dec 2024 17:40:48 -0800
In-Reply-To: <Z1eXyv2VVsFiw_0i@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241021102321.665060-1-bk@alpico.io> <Z1eXyv2VVsFiw_0i@google.com>
Message-ID: <Z1ecILHBlpkiAThl@google.com>
Subject: Re: [PATCH v2] KVM: x86: Drop the kvm_has_noapic_vcpu optimization
From: Sean Christopherson <seanjc@google.com>
To: Bernhard Kauer <bk@alpico.io>
Cc: kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

+Paolo, I'm pretty sure he still doesn't subscribe to kvm@ :-)

On Mon, Dec 09, 2024, Sean Christopherson wrote:
> On Mon, Oct 21, 2024, Bernhard Kauer wrote:
> > It used a static key to avoid loading the lapic pointer from
> > the vcpu->arch structure.  However, in the common case the load
> > is from a hot cacheline and the CPU should be able to perfectly
> > predict it. Thus there is no upside of this premature optimization.
> > 
> > The downside is that code patching including an IPI to all CPUs
> > is required whenever the first VM without an lapic is created or
> > the last is destroyed.
> > 
> > Signed-off-by: Bernhard Kauer <bk@alpico.io>
> > ---
> > 
> > V1->V2: remove spillover from other patch and fix style
> > 
> >  arch/x86/kvm/lapic.c | 10 ++--------
> >  arch/x86/kvm/lapic.h |  6 +-----
> >  arch/x86/kvm/x86.c   |  6 ------
> >  3 files changed, 3 insertions(+), 19 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index 2098dc689088..287a43fae041 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -135,8 +135,6 @@ static inline int __apic_test_and_clear_vector(int vec, void *bitmap)
> >  	return __test_and_clear_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
> >  }
> >  
> > -__read_mostly DEFINE_STATIC_KEY_FALSE(kvm_has_noapic_vcpu);
> > -EXPORT_SYMBOL_GPL(kvm_has_noapic_vcpu);
> >  
> >  __read_mostly DEFINE_STATIC_KEY_DEFERRED_FALSE(apic_hw_disabled, HZ);
> >  __read_mostly DEFINE_STATIC_KEY_DEFERRED_FALSE(apic_sw_disabled, HZ);
> 
> I'm on the fence, slightly leaning towards removing all three of these static keys.
> 
> If we remove kvm_has_noapic_vcpu to avoid the text patching, then we should
> definitely drop apic_sw_disabled, as vCPUs are practically guaranteed to toggle
> the S/W enable bit, e.g. it starts out '0' at RESET.  And if we drop apic_sw_disabled,
> then keeping apic_hw_disabled seems rather pointless.
> 
> Removing all three keys is measurable, but the impact is so tiny that I have a
> hard time believing anyone would notice in practice.
> 
> To measure, I tweaked KVM to handle CPUID exits in the fastpath and then ran the
> KVM-Unit-Test CPUID microbenchmark (with some minor modifications).  Handling
> CPUID in the fastpath makes the kvm_lapic_enabled() call in the innermost run loop
> stick out (that helpers checks all three keys/conditions).
> 
> 	for (;;) {
> 		/*
> 		 * Assert that vCPU vs. VM APICv state is consistent.  An APICv
> 		 * update must kick and wait for all vCPUs before toggling the
> 		 * per-VM state, and responding vCPUs must wait for the update
> 		 * to complete before servicing KVM_REQ_APICV_UPDATE.
> 		 */
> 		WARN_ON_ONCE((kvm_vcpu_apicv_activated(vcpu) != kvm_vcpu_apicv_active(vcpu)) &&
> 			     (kvm_get_apic_mode(vcpu) != LAPIC_MODE_DISABLED));
> 
> 		exit_fastpath = kvm_x86_call(vcpu_run)(vcpu,
> 						       req_immediate_exit);
> 		if (likely(exit_fastpath != EXIT_FASTPATH_REENTER_GUEST))
> 			break;
> 
> 		if (kvm_lapic_enabled(vcpu))
> 			kvm_x86_call(sync_pir_to_irr)(vcpu);
> 
> 		if (unlikely(kvm_vcpu_exit_request(vcpu))) {
> 			exit_fastpath = EXIT_FASTPATH_EXIT_HANDLED;
> 			break;
> 		}
> 
> 		/* Note, VM-Exits that go down the "slow" path are accounted below. */
> 		++vcpu->stat.exits;
> 	}
> 
> With a single vCPU pinned to a single pCPU, the average latency for a CPUID exit
> goes from 1018 => 1027 cycles, plus or minus a few.  With 8 vCPUs, no pinning
> (mostly laziness), the average latency goes from 1034 => 1053.
> 
> Other flows that check multiple vCPUs, e.g. kvm_irq_delivery_to_apic(), might be
> more affected?  The optimized APIC map should help for common cases, but KVM does
> still check if APICs are enabled multiple times when delivering interrupts.  And
> that's really my only hesitation: there are checks *everywhere* in KVM.
> 
> On the other hand, we lose gobs and gobs of cycles with far less thought.  E.g.
> with mitigations on, the latency for a single vCPU jumps all the way to 1600+ cycles.
> 
> And while the diff stats are quite nice, the relevant code is low maintenance.
> 
>  arch/x86/kvm/lapic.c | 41 ++---------------------------------------
>  arch/x86/kvm/lapic.h | 19 +++----------------
>  arch/x86/kvm/x86.c   |  4 +---
>  3 files changed, 6 insertions(+), 58 deletions(-)
> 
> Paolo or anyone else... thoughts?

