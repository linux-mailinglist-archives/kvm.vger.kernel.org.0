Return-Path: <kvm+bounces-36164-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 82672A1829F
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 18:11:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2BA4A188BDDA
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 17:11:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A8931F4E56;
	Tue, 21 Jan 2025 17:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GCTU1Xeu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F6D1F3FFF
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 17:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737479484; cv=none; b=NJXeNF0AmycD//AB5EFuGpkDqvAAn2M4J8Ymsl6dD8bJ93gCpRZded8iO/L8TnTeMghYr2QeanfXjmEJI8eQd6QYOiS2NJUvHs946NpALylxHYqnak2PtqRsEENuSA7mhXefu26dOlkbwgjqax481pu52L3SUod6COEabWeuF1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737479484; c=relaxed/simple;
	bh=TxOI+i+//TT+AB6ctTK+SU8udD3HH6dU6g/cYV6RJZE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=e5B6NCSpdS8dinKwkoTqHgModVahD6mRJH1+yPDux0fFd9i8DHvO44oJvCNwIq+5xX4ZUciWdj+MNSqEB//yzVGW91Fp65q1TTZSPFbH5yVJGJud7m9hF8LwZKVlYU/m3C7CvMfBoq/K/KBwsxOcz/zmTlnyFx1hWSpCXCzno4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GCTU1Xeu; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-218cf85639eso40182725ad.3
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 09:11:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737479482; x=1738084282; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PvvVMs9eMRobZG8DWK4wWLtfTYH0IleiLTAzts0Bzwc=;
        b=GCTU1XeuY9UzwLaNJD3UWJ2VCvfL57hDFtVwXe3JtcHyVLaAaD5rniQl0B1yOCPX/P
         CKohO7vDV8hjUkjmQFxPCdAuNjP5jnvK5Ro0kQ/+jLRqLVxch/KPJG5Gg5xWDH81tomB
         rqj/+SqcdZfao7WP3/bhfQIwAYqY2/T1egIv5UDItC1KOtB0HmolC1waFVwF8O00Cf2r
         Ld7BUaUtkiF/uLkQ0av2GLl2VRofJkq0aPkGwCmSLpG7/3zbTFq4i2y3NTatEzERL20k
         cvyl/pq+v8oijiLpJ4GUZ9Q1KHpe9PQwX5+VTgabEMNWV28eYmm2thI4GnIdO7eCGUh6
         UHHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737479482; x=1738084282;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PvvVMs9eMRobZG8DWK4wWLtfTYH0IleiLTAzts0Bzwc=;
        b=mBuXtHzR4oIUsHF1qT4xDSmHTdejarOcWRgvAt/qgPDVNbKfxbRzEP11uxiPSQWfit
         qa0fQaRkAK/i4gXvZzkN6TKv6y7L5+c2qh+iouHc7lYbgMvilg1Si+trP+yunXlzxVP+
         YLLb4BCYynyCuomlAraOzLQnMpn5m9T9SgMPr9yHgLa92QwPuDOA3vWR3rwaeUek44ZP
         Qbv48pEFazz4obyVRTV5t4xsG2BpUe9phTYUQkvIcK9EDHFtriwZPUx6sI9cYtKoMB8b
         Q9FZXWabYR3rpWc+eOQaBsIAWHoRCjZ+OAqtUOGvu6gAqiT7IKvASObMAVn/phy/FgyG
         Ykfg==
X-Forwarded-Encrypted: i=1; AJvYcCU9sU9gE9IV1ePzTf+U+LSKphABhWvXhOT3aGebcFEo/W5l3Wf/vhj8iHvWPkd4sh9RhwA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNXNl9BA9ZMT2gXP8XxY6y6FV0lARhxZFJ1Mo9LZu5weZnA8ny
	u/fP/G2afjuf4HSyXj8ULgImP4oy5jyWCtwNerLZ5mgRqOkKUIAWnBdtUGh18fRheNrqKZjPh9W
	YxQ==
X-Google-Smtp-Source: AGHT+IFxwgG0JrCzsE4TO/djEBCQpCk1NS7/wTlQmLOZ9As/i/YrdJouLm3UwpJxFf/ut2h60b+9KewpqUQ=
X-Received: from pfbbt6.prod.google.com ([2002:a05:6a00:4386:b0:72a:bc54:8507])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7f8c:b0:1e3:da8c:1e07
 with SMTP id adf61e73a8af0-1eb2147417emr31138725637.7.1737479482000; Tue, 21
 Jan 2025 09:11:22 -0800 (PST)
Date: Tue, 21 Jan 2025 09:11:20 -0800
In-Reply-To: <30fb80cb-7f4b-4abe-8095-c9b029013923@xen.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250118005552.2626804-1-seanjc@google.com> <20250118005552.2626804-6-seanjc@google.com>
 <30fb80cb-7f4b-4abe-8095-c9b029013923@xen.org>
Message-ID: <Z4_VOILq-bmhBf98@google.com>
Subject: Re: [PATCH 05/10] KVM: x86: Don't bleed PVCLOCK_GUEST_STOPPED across
 PV clocks
From: Sean Christopherson <seanjc@google.com>
To: paul@xen.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com, 
	Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Jan 21, 2025, Paul Durrant wrote:
> On 18/01/2025 00:55, Sean Christopherson wrote:
> > When updating a specific PV clock, make a full copy of KVM's reference
> > copy/cache so that PVCLOCK_GUEST_STOPPED doesn't bleed across clocks.
> > E.g. in the unlikely scenario the guest has enabled both kvmclock and Xen
> > PV clock, a dangling GUEST_STOPPED in kvmclock would bleed into Xen PV
> > clock.
> 
> ... but the line I queried in the previous patch squashes the flag before
> the Xen PV clock is set up, so no bleed?

Yeah, in practice, no bleed after the previous patch.  But very theoretically,
there could be bleed if the guest set PVCLOCK_GUEST_STOPPED in the compat clock
*and* had both compat and non-compat Xen PV clocks active (is that even possible?)

> > Using a local copy of the pvclock structure also sets the stage for
> > eliminating the per-vCPU copy/cache (only the TSC frequency information
> > actually "needs" to be cached/persisted).
> > 
> > Fixes: aa096aa0a05f ("KVM: x86/xen: setup pvclock updates")
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   arch/x86/kvm/x86.c | 13 ++++++++-----
> >   1 file changed, 8 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 3c4d210e8a9e..5f3ad13a8ac7 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -3123,8 +3123,11 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
> >   {
> >   	struct kvm_vcpu_arch *vcpu = &v->arch;
> >   	struct pvclock_vcpu_time_info *guest_hv_clock;
> > +	struct pvclock_vcpu_time_info hv_clock;
> >   	unsigned long flags;
> > +	memcpy(&hv_clock, &vcpu->hv_clock, sizeof(hv_clock));
> > +
> >   	read_lock_irqsave(&gpc->lock, flags);
> >   	while (!kvm_gpc_check(gpc, offset + sizeof(*guest_hv_clock))) {
> >   		read_unlock_irqrestore(&gpc->lock, flags);
> > @@ -3144,25 +3147,25 @@ static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
> >   	 * it is consistent.
> >   	 */
> > -	guest_hv_clock->version = vcpu->hv_clock.version = (guest_hv_clock->version + 1) | 1;
> > +	guest_hv_clock->version = hv_clock.version = (guest_hv_clock->version + 1) | 1;
> >   	smp_wmb();
> >   	/* retain PVCLOCK_GUEST_STOPPED if set in guest copy */
> > -	vcpu->hv_clock.flags |= (guest_hv_clock->flags & PVCLOCK_GUEST_STOPPED);
> > +	hv_clock.flags |= (guest_hv_clock->flags & PVCLOCK_GUEST_STOPPED);
> > -	memcpy(guest_hv_clock, &vcpu->hv_clock, sizeof(*guest_hv_clock));
> > +	memcpy(guest_hv_clock, &hv_clock, sizeof(*guest_hv_clock));
> >   	if (force_tsc_unstable)
> >   		guest_hv_clock->flags &= ~PVCLOCK_TSC_STABLE_BIT;
> >   	smp_wmb();
> > -	guest_hv_clock->version = ++vcpu->hv_clock.version;
> > +	guest_hv_clock->version = ++hv_clock.version;
> >   	kvm_gpc_mark_dirty_in_slot(gpc);
> >   	read_unlock_irqrestore(&gpc->lock, flags);
> > -	trace_kvm_pvclock_update(v->vcpu_id, &vcpu->hv_clock);
> > +	trace_kvm_pvclock_update(v->vcpu_id, &hv_clock);
> >   }
> >   static int kvm_guest_time_update(struct kvm_vcpu *v)
> 

