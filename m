Return-Path: <kvm+bounces-65904-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C7FB5CBA0BE
	for <lists+kvm@lfdr.de>; Sat, 13 Dec 2025 00:23:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A997C30A0F82
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 23:23:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9D4430DD32;
	Fri, 12 Dec 2025 23:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xOWvWB1E"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D3728B3E7
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 23:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765581811; cv=none; b=ZmNHU+IlRF7Ya4thE2qn0EPjCIrPf0Debljd8vu1WUZL4PgJMxyHe/1R6Jcdb4XCv8TisRX2WOnxZUeia+SittPDH8yHcN7XPRCkKlUN2ptIGLE5e32jnJ6W3cKp17VeUnFkW8uWiBbGNMpJ9Wrg5daSTa0vNjgVo9fmzUdaloc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765581811; c=relaxed/simple;
	bh=cPt4+L+Tq3/9sw/6eednpCP1IHSFDXysRe2eK8BwgsI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IkiBYpFQum6/Qq/3TwjJ4ABsVb+hEXzav8NMJHSZpK6cNhAL/6jbC9FsJ/QPTB53vx31ZM2dhs9kwUPLUOJNP5dGQ8V0+m5cBVtSGkDnhzoePpnF6od8u2RPsEpnqHbtPXKXIxec6yu1Dq3JYxamuVKWEfenICXVydfS1OQ1JI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xOWvWB1E; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34a1bca4c23so3091098a91.1
        for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:23:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765581809; x=1766186609; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CUpMh+9ad9lwr4IxktuH344ueNrw88ySbZ9Im72lfmY=;
        b=xOWvWB1Ef5xlPYpFDOF7oL+rub7Un79eLb/FRFqc02p0X2bM2c2Y9Bqwf7ioj6YzSW
         kNRvuKD6YxARWgJjl0IZ2VnC9WrwoLxdwy1e0k2FCJny3hFyFlnLZdf9dX0+t7eliZAD
         2PAQnA8BQZhxS5ixYWslFSesW4kOvC+Bh7i2g7n0pP47s0yUnIV4gshsLQHWtrN2Wba+
         jFc0Rqn60aMX2CcJa0mns2x1LQ1a4xq5lIikv3BUipYdh8x47oL9rnPYstoe7+htO7zz
         z9sM5l0+jGPJ2MPSX5xRr1R9V+q5WbE0R1WvpopKwN4iDGoTwIhw2GQp8NsaHEiYRPE/
         xS8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765581809; x=1766186609;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CUpMh+9ad9lwr4IxktuH344ueNrw88ySbZ9Im72lfmY=;
        b=Qtt0GctMQs+XFa15/QHrzX5dAds7QtX0HDYdcm3tuj8oMgiSrjzKCpTWLI21iy9qRl
         so8GlxyYoQHh5/heR/N30mq1MuASM+nT6Zu2xtOkP8fGSzQtmPfxLEvA5VgfVFCbGYMc
         Cn9MzJXyE2nLjVQ5wmntijtNwxY6oHSqOt4NFcqVjv7h3zaQud1gVZMx/4laOQIFKl1B
         NCoMLviHFVrH3LCFGMnX0CLDPvcAZQrd/TnDC8d9a30/j3YHlpsIB+9kc+sJGEFtDaY+
         l5zNfYcDC3D1eOo7UsF2xLcJqp27MlyqWEPeWE+UNq8hyF2XH1wJNV6P/UGbNzFhBMnh
         YAoA==
X-Forwarded-Encrypted: i=1; AJvYcCVE05mkqnBAbaFDERU9LOGbzh4eNsO0a2UyhyYSVQwRpHnz0W1To7jhxFIo39eVpFRbtlA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzLEWUKrX8kDsND9bIxca3OmIZsGdlyis+pYeuljaMwze8TQEpL
	arZOzhvK5sthxIvdSPSiXHkBuwcH8u7K0FbZ2pueCK79i5I6jI2ZVzHQiA3QS1cnAkF/esPo/fu
	9qh/2/Q==
X-Google-Smtp-Source: AGHT+IG3yPm9vGZ7KMwHDEEE2ruJHkkhjABLyCAeBWQ0CBrS7ZQCejhqnXgbFqAD0l6LPHxJQFcjLe9oxg4=
X-Received: from pjop3.prod.google.com ([2002:a17:90a:9303:b0:340:d583:8694])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:dfce:b0:340:bfcd:6af3
 with SMTP id 98e67ed59e1d1-34abd78748dmr3163169a91.33.1765581809034; Fri, 12
 Dec 2025 15:23:29 -0800 (PST)
Date: Fri, 12 Dec 2025 15:23:27 -0800
In-Reply-To: <rckoq7j5pbe7rkszw7d7kkcyjpjpmdwexyrlcw2hyf6cgzpohf@scxmalwv6buz>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251110222922.613224-1-yosry.ahmed@linux.dev>
 <20251110222922.613224-12-yosry.ahmed@linux.dev> <aThKPT9ItrrDZdSd@google.com>
 <ttlhqevbe7rq5ns4vyk6e2dtlflbrkcfdabwr63jfnszshhiqs@z7ixbtq6zsla>
 <aThz5p655rk8D1KS@google.com> <rckoq7j5pbe7rkszw7d7kkcyjpjpmdwexyrlcw2hyf6cgzpohf@scxmalwv6buz>
Message-ID: <aTyj73ORMhIX-4-c@google.com>
Subject: Re: [PATCH v2 11/13] KVM: nSVM: Simplify nested_svm_vmrun()
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Dec 10, 2025, Yosry Ahmed wrote:
> On Tue, Dec 09, 2025 at 11:09:26AM -0800, Sean Christopherson wrote:
> > On Tue, Dec 09, 2025, Yosry Ahmed wrote:
> > > On Tue, Dec 09, 2025 at 08:11:41AM -0800, Sean Christopherson wrote:
> > > > On Mon, Nov 10, 2025, Yosry Ahmed wrote:
> > > > > Call nested_svm_merge_msrpm() from enter_svm_guest_mode() if called from
> > > > > the VMRUN path, instead of making the call in nested_svm_vmrun(). This
> > > > > simplifies the flow of nested_svm_vmrun() and removes all jumps to
> > > > > cleanup labels.
> > > > > 
> > > > > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > > > > ---
> > > > >  arch/x86/kvm/svm/nested.c | 28 +++++++++++++---------------
> > > > >  1 file changed, 13 insertions(+), 15 deletions(-)
> > > > > 
> > > > > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > > > > index a48668c36a191..89830380cebc5 100644
> > > > > --- a/arch/x86/kvm/svm/nested.c
> > > > > +++ b/arch/x86/kvm/svm/nested.c
> > > > > @@ -1020,6 +1020,9 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa, bool from_vmrun)
> > > > >  
> > > > >  	nested_svm_hv_update_vm_vp_ids(vcpu);
> > > > >  
> > > > > +	if (from_vmrun && !nested_svm_merge_msrpm(vcpu))
> > > > 
> > > > This is silly, just do:
> > > 
> > > Ack. Any objections to just dropping from_vmrun and moving
> > > kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES) to svm_leave_smm()? I
> > > like the consistency of completely relying on from_vmrun or not at all
> > 
> > Zero objections.  When I was initially going through this, I actually thought you
> > were _adding_ the flag and was going to yell at you :-)
> 
> Ugh from_vmrun is also plumbed into nested_svm_load_cr3() as
> reload_pdptrs. Apparently we shouldn't do that in the call path from
> svm_leave_smm()? Anyway, seems like it'll be non-trivial to detangle (at
> least for me, I have 0 understanding of SMM), so I will leave it as-is.

Agreed, there's enough refactoring going on as it is, no need to turn the
snowball into an avalanche.

