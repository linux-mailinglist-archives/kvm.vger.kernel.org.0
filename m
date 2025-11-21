Return-Path: <kvm+bounces-64024-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 502B2C76C8F
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 01:39:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 47B984E20E8
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 00:39:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD66A268C40;
	Fri, 21 Nov 2025 00:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FOnEgNLs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E542459E5
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 00:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763685536; cv=none; b=Z5DSdpLpOrEczABfPHgF/hUevenxvztwZnvg1aectkB2xK3WHK7bmzB2G8EvUcr9I0LeXFkhx+tXP3a2RCQBHHmoASTtY55WjlNf5tDgz+RrK68xSKgznyDV3KAJgEWd2t6VMOLBnDtby9nUyWKqrHFBJjW1KezzkgzW7ejNz0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763685536; c=relaxed/simple;
	bh=ZVm9oVg9+oHojYwfCqjOSWTPawiDqofHfvzZVybJeio=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TT/2MdoRwE0e35mWP0bt2JvxHfY5nvm0GnaL689kmAjekS1F+4sFahDDv91ruA2fjM9qmAhzVO3lTedBF2wpD61uqChL3kNJDOw7+k+KOmf0b8W80H1xb3sgNYhXAXWCb2mS+U8ibDHkrz+6RWiMPTWCWUql3FhBFARwTgiN10I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FOnEgNLs; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-295595cd102so37292515ad.3
        for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 16:38:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763685534; x=1764290334; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9yHOty/6mNUkhCHBQeglcNfXba5Wpwpq1aZlNIfnHbs=;
        b=FOnEgNLsm1yir+BEN6I/gb5qFuDj++EybRuA7xiV2i85p7uK51ZsrlgrNHBkbEDHg/
         Co22vWBB6ahUYK6bhrnt5SsVcNNe6/SWWoWN2WBiH/9t6Ns6Shqv1ibKEpzHFx6nwlf+
         aKXOzBm8f8tc0MiK4b5LuwlGytAyH2ZZ/gXdExf6ddjkD2Xlzr8k7N0DU9guFUXAQhr+
         jOyHV8ph5OJU9Jfji4heeQ2SH/ZcefR2Q1AJJIE+4uPPaxgaP5XZBrzWsnrxQSRQekgh
         ztd0lQemQo3UpOkObVL/k6Yd4KiOw66Vjs0XN2l+n2Du6ctSgiQJn8e6jYWJN9AjN0qn
         asKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763685534; x=1764290334;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9yHOty/6mNUkhCHBQeglcNfXba5Wpwpq1aZlNIfnHbs=;
        b=sr9RBMqauaTa+Ve8EMrWE84QfN29wDIBHQ26PewKOkMIzN9FxXHQ550sHqfjJJj/X2
         xoTTzXqTaQw8gXU+ijkfUYvNUTNZXcgpJS9899PssVc5cIujzf2A9jSV9ZeWEkMnNOYT
         jyvxGmH/NL/RSyC8Vr32nnnrMKsrWb6rFkYFcScbCWMiR9MivV0BRv9CRk0/1aIVYGYQ
         qezGnUyR9rOWevg+1RDADQMdggaLHrYyln9MGaqxs3VrTBefYSerPFHS5qtFKYn3/Rw3
         LkbCbuTGi8MrtxtxF1jTNqmGvlWCi4ToRohp0HjV+sah01yCCeMc7/8KyyTBpy3/JKQj
         13Bw==
X-Forwarded-Encrypted: i=1; AJvYcCW4vMS354HUyGA7foUNdAepSLSG6AtGlSc+oKej8aGxbVC51AZm1CnAfDPeAnlaoeJ/0BE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzyNTgqjQBpj4xbRPC7ka4YpFAL62En5hjVsoykkXEt7e6fdEW0
	W0N0HSLLSMWBKfo4yh8GNZsBCjXGTpx2jUWkMUGtmMwS2hiNkTdrKkmHMqCsqMPYDfKbhf9NBqO
	khc3UOA==
X-Google-Smtp-Source: AGHT+IHAtQ5uOa4zy//oPlSviihcy4vHTC+g1fwm6GKeCXN14PJK2EED5KkhT/Iqwbi3W7eOGEFuceginJY=
X-Received: from pjbbb10.prod.google.com ([2002:a17:90b:8a:b0:340:53bc:56cb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3c6f:b0:295:8c51:64ff
 with SMTP id d9443c01a7336-29b6bf37d57mr6409455ad.29.1763685533874; Thu, 20
 Nov 2025 16:38:53 -0800 (PST)
Date: Thu, 20 Nov 2025 16:38:52 -0800
In-Reply-To: <aR-zxrYATZ4rZZjn@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251110033232.12538-1-kernellwp@gmail.com> <20251110033232.12538-7-kernellwp@gmail.com>
 <aR-zxrYATZ4rZZjn@google.com>
Message-ID: <aR-0nGgVuc2EWm2a@google.com>
Subject: Re: [PATCH 06/10] KVM: Fix last_boosted_vcpu index assignment bug
From: Sean Christopherson <seanjc@google.com>
To: Wanpeng Li <kernellwp@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Paolo Bonzini <pbonzini@redhat.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Juri Lelli <juri.lelli@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Wanpeng Li <wanpengli@tencent.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 20, 2025, Sean Christopherson wrote:
> On Mon, Nov 10, 2025, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> > 
> > From: Wanpeng Li <wanpengli@tencent.com>
> 
> Something might be off in your email scripts.  Speaking of email, mostly as an
> FYI, your @tencent email was bouncing as of last year, and prompted commit
> b018589013d6 ("MAINTAINERS: Drop Wanpeng Li as a Reviewer for KVM Paravirt support").
> 
> > In kvm_vcpu_on_spin(), the loop counter 'i' is incorrectly written to
> > last_boosted_vcpu instead of the actual vCPU index 'idx'. This causes
> > last_boosted_vcpu to store the loop iteration count rather than the
> > vCPU index, leading to incorrect round-robin behavior in subsequent
> > directed yield operations.
> > 
> > Fix this by using 'idx' instead of 'i' in the assignment.
> 
> Fixes: 7e513617da71 ("KVM: Rework core loop of kvm_vcpu_on_spin() to use a single for-loop")
> Cc: stable@vger.kernel.org
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> 
> Please, please don't bury fixes like this in a large-ish series, especially in a
> series that's going to be quite contentious and thus likely to linger on-list for
> quite some time.  It's pretty much dumb luck on my end that I saw this.
> 
> That said, thank you for fixing my goof :-)
> 
> Paolo, do you want to grab this for 6.19?  Or just wait for 6.20?

Err, off-by-one.  6.18 and 6.19....

> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  virt/kvm/kvm_main.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index b7a0ae2a7b20..cde1eddbaa91 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -4026,7 +4026,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
> >  
> >  		yielded = kvm_vcpu_yield_to(vcpu);
> >  		if (yielded > 0) {
> > -			WRITE_ONCE(kvm->last_boosted_vcpu, i);
> > +			WRITE_ONCE(kvm->last_boosted_vcpu, idx);
> >  			break;
> >  		} else if (yielded < 0 && !--try) {
> >  			break;
> > -- 
> > 2.43.0
> > 

