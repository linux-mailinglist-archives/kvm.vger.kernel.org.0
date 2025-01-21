Return-Path: <kvm+bounces-36179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A8721A18559
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 19:46:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3CAB518874CC
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 18:46:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 253511F63FD;
	Tue, 21 Jan 2025 18:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n6fvwFmD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03001F4285
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 18:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737485150; cv=none; b=I6NlQspbeBFwaYU+Scpu5eh90Vxd2LBJT3CSEesOS0jhUFm/TQYY9O8yN/9WECia+hYL+CpOP1/udY9QnKVtguliPVzRXolHAgLHBcbYhXdyAYM5mdDqJiPLU0yuM2bXTgjXJyPIq4aREjOvSMGei+sVu+yL7hrJYJCJ6bwxAsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737485150; c=relaxed/simple;
	bh=PoFV2Jgi8Fv/S9H4xkzEez8rOm0Jx0WTT+lGGYyfGd4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ljhwXaZnJJwkEUmeyTM+FE3kSWXAnbyctK32oRdpmgvjR7QHULvyD/qKmM50ZaehdZSlKWSGa+fsl0CqzHz2b0LGbD9gJ+fa4RBqkErBH3W0H0qA9PKN3NhPAMMfXhlCwE0BPw0Aa/Q31r2xAp0nClAcN7NKN/S96TZi+uxGgfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n6fvwFmD; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ee86953aeaso11016781a91.2
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 10:45:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737485148; x=1738089948; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LaKDWUH4IvX2kG7AwZHBx4f4xmaqVOZBhWz5/OH0b4U=;
        b=n6fvwFmDBNBAOxeGu7QZAsrm9n9bFZ0fVBGATC34Em6dNgt5qfuk5Z2p5IcBtA9MJA
         Hib4uWcWSbDUeHP3otNbZT3tmIQsNCfmXYCuuE4uZlmd6/MAdgtwjJjTJow80cKVkGU1
         cpsvIxn9FQUBlTfD5REOeYA82dKOTDVjfGSKMFpN4EwWbdF/uDORe/PghD5or0Zzq1NT
         pCWVVh2OkCnOLVt71lm1DQEZuEFZPdCtiZNPVKQQkVIKcBb2QWfkdhDFWBFR3IoDOrQ9
         J8kdWvvaItONZVWhO3TR9zB9JtM2n+cjHhMgarHR++zaxQG58vFbnzghnjNFID6Wv9Q6
         wN1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737485148; x=1738089948;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LaKDWUH4IvX2kG7AwZHBx4f4xmaqVOZBhWz5/OH0b4U=;
        b=FqKXnhSu2tyNhNgBsFA1C/Ex1vXPv95joZZ+lCMDui30gVwELNeRVD4DSRTtCjn+bx
         I2KahOa5SrqWOTF/VUZRZL6QHnfYOdk6u0MlK9l/xy2UhSGt1D7N+xQCR+VrW2B+Uht5
         BXFf5Ai4W2SPqA8FYLQcDKkzg0ej4ST7eh0fPmRINaTpaP03365gzw2ECIYdqiDYj9MA
         CrNgNJI0Y0RbvKVNIK1hkNPoUFQ71skRzHKhH7uPSt3L5Ilo7N+UmUz/jgz/jqiBo4yp
         4AGRDxM7mcBe28rPRLf6WjMlhS4T/KbJ2/nf30C5ALqqErMUj0L9xcCJ442MTUUsSE6X
         j2cg==
X-Forwarded-Encrypted: i=1; AJvYcCXlXFc0WyoADDHxsvKNv3v0DwILzpiili54KhExN95BC7qlELbE3wCNSatF6TW2hwLwe5Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YySNyFJNkJrJv17rJrXGRxE+pjDgk9GJ+H44NC9nbaySnl+C+fR
	DpRWr1AZkrYdNjTogMBS41bLeGhP5I7WjUfC3cszQId7JUFzH1ik6RevJNZIDzZ+FbOA94I8xqE
	nQQ==
X-Google-Smtp-Source: AGHT+IGSvIQ0DSCpnKPgCfk4ldySQtzhEACwGpRoNFncGuH1X7X3fTN5qZxjjPi3+rjBp9+1Qu5qO604uJY=
X-Received: from pfbbx10.prod.google.com ([2002:a05:6a00:428a:b0:725:eccc:e998])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4510:b0:724:5815:62c1
 with SMTP id d2e1a72fcca58-72dafb367dfmr24723026b3a.19.1737485148160; Tue, 21
 Jan 2025 10:45:48 -0800 (PST)
Date: Tue, 21 Jan 2025 10:45:46 -0800
In-Reply-To: <06482c0e-e519-47ca-9f70-da3ab12ed2e4@xen.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250118005552.2626804-1-seanjc@google.com> <20250118005552.2626804-7-seanjc@google.com>
 <06482c0e-e519-47ca-9f70-da3ab12ed2e4@xen.org>
Message-ID: <Z4_rWp97tzzZy0Po@google.com>
Subject: Re: [PATCH 06/10] KVM: x86/xen: Use guest's copy of pvclock when
 starting timer
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
> > Use the guest's copy of its pvclock when starting a Xen timer, as KVM's
> > reference copy may not be up-to-date, i.e. may yield a false positive of
> > sorts.  In the unlikely scenario that the guest is starting a Xen timer
> > and has used a Xen pvclock in the past, but has since but turned it "off",
> > then vcpu->arch.hv_clock may be stale, as KVM's reference copy is updated
> > if and only if at least pvclock is enabled.
> > 
> > Furthermore, vcpu->arch.hv_clock is currently used by three different
> > pvclocks: kvmclock, Xen, and Xen compat.  While it's extremely unlikely a
> > guest would ever enable multiple pvclocks, effectively sharing KVM's
> > reference clock could yield very weird behavior.  Using the guest's active
> > Xen pvclock instead of KVM's reference will allow dropping KVM's
> > reference copy.
> > 
> > Fixes: 451a707813ae ("KVM: x86/xen: improve accuracy of Xen timers")
> > Cc: Paul Durrant <pdurrant@amazon.com>
> > Cc: David Woodhouse <dwmw@amazon.co.uk>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >   arch/x86/kvm/xen.c | 58 ++++++++++++++++++++++++++++++++++++++++++----
> >   1 file changed, 53 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> > index a909b817b9c0..b82c28223585 100644
> > --- a/arch/x86/kvm/xen.c
> > +++ b/arch/x86/kvm/xen.c
> > @@ -150,11 +150,46 @@ static enum hrtimer_restart xen_timer_callback(struct hrtimer *timer)
> >   	return HRTIMER_NORESTART;
> >   }
> > +static int xen_get_guest_pvclock(struct kvm_vcpu *vcpu,
> > +				 struct pvclock_vcpu_time_info *hv_clock,
> > +				 struct gfn_to_pfn_cache *gpc,
> > +				 unsigned int offset)
> > +{
> > +	struct pvclock_vcpu_time_info *guest_hv_clock;
> > +	unsigned long flags;
> > +	int r;
> > +
> > +	read_lock_irqsave(&gpc->lock, flags);
> > +	while (!kvm_gpc_check(gpc, offset + sizeof(*guest_hv_clock))) {
> > +		read_unlock_irqrestore(&gpc->lock, flags);
> > +
> > +		r = kvm_gpc_refresh(gpc, offset + sizeof(*guest_hv_clock));
> > +		if (r)
> > +			return r;
> > +
> > +		read_lock_irqsave(&gpc->lock, flags);
> > +	}
> > +
> 
> I guess I must be missing something subtle... What is setting guest_hv_clock
> to point at something meaningful before this line?

Nope, you're not missing anything, this code is completely broken.  As pointed
out by the kernel test bot, the caller is also busted, because the "xen" pointer
is never initialied.

	struct kvm_vcpu_xen *xen;

	...

	do {
		...

		if (xen->vcpu_info_cache.active)
			r = xen_get_guest_pvclock(vcpu, &hv_clock, &xen->vcpu_info_cache,
						offsetof(struct compat_vcpu_info, time));
		else if (xen->vcpu_time_info_cache.active)
			r = xen_get_guest_pvclock(vcpu, &hv_clock, &xen->vcpu_time_info_cache, 0);
		if (r)
			break;
	}


I suspect the selftest passes because the @gpc passed to xen_get_guest_pvclock()
is garbage, which likely results in kvm_gpc_refresh() failing, and so KVM falls
backs to the less precise method:

	if (r) {
		/*
		 * Without CONSTANT_TSC, get_kvmclock_ns() is the only option.
		 *
		 * Also if the guest PV clock hasn't been set up yet, as is
		 * likely to be the case during migration when the vCPU has
		 * not been run yet. It would be possible to calculate the
		 * scaling factors properly in that case but there's not much
		 * point in doing so. The get_kvmclock_ns() drift accumulates
		 * over time, so it's OK to use it at startup. Besides, on
		 * migration there's going to be a little bit of skew in the
		 * precise moment at which timers fire anyway. Often they'll
		 * be in the "past" by the time the VM is running again after
		 * migration.
		 */
		guest_now = get_kvmclock_ns(vcpu->kvm);
		kernel_now = ktime_get();
	}

Ugh.  And the reason my build tests didn't catch this is because the only config
I test with KVM_XEN=y also has KASAN=y, which is incompatible with KVM_ERROR=y
(unless the global WERROR=y is enabled).

Time to punt KASAN=y to it's own Kconfig I guess...

I'll verify the happy path is actually being tested before posting v2.

