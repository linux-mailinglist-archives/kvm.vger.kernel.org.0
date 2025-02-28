Return-Path: <kvm+bounces-39664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DEC1A493D2
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 09:44:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 553A53A922C
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 08:43:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BDB2253356;
	Fri, 28 Feb 2025 08:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fEn/lsau"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9E62512E3
	for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 08:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740732240; cv=none; b=BgJwbs+ikNMu9qrNPZuNxjHL0u9GZKoaB34zZ9fB2UA8iUMaJLSh3mSvNjvhfygYLxIwRGQbyTj6+Ux0KVAnHTOtpEAHX8LPsmKwFsJzmCWUsxYm+EBkWyerGkPbyfWaHjDXvexTDC6vgwuAWoQDU+D+6yy2AMF0nGjbKvPixcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740732240; c=relaxed/simple;
	bh=feDBNntw9yX3Vh3kglgn6q5F5/6MdMcMdpEBHjC7Lfw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kwcPh4dXS75HvUNbUxG/8Nh6M05XFssAJVNJ6s4ugLc1gTlf5wR5jfyohy37M1zPcxgqRm0jAFGDZNmhYVjNfA8H4og8NAt9Q1oii9Wm+WP8lIClSclO8AgkygIhotFR3uto8u9OVrQCrcquwafUgjJ3YKzPu8EK8ZMz4BFpprU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fEn/lsau; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43995bff469so11778725e9.2
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 00:43:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740732237; x=1741337037; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uCQhmEkI20WCXSrDNmwHS83kJOrfCigX2ZIIywReQD0=;
        b=fEn/lsau+ZAFBqaSNEZ7wDpeYUZG7tfzEnuOffhaOZaRxb/000T2LedOouTSl2SRaT
         vcSVn899WYdPG/1gjA76ETy2bzlDfnaFHfWD9JFeje4zBvPAlEAdLUQftmyT2erNZpqN
         qU+hElQrJFvvD/G461l/VN+EmCDb9U/zqFdga+1cGeEwLOjKH/wAC9XT3xz2fDqnnGS8
         bV5Soq3nACzcVd6Zb3Y2fptLE0q7x9czgltEhKfovziqp4xPFWQUN6qwWXjhXe8D2ouq
         +JGnRygloQyVfaYtCjCzuZRaKEeI6/fhLm7YHDr+8+xxpTLyfbXAX/EAOiIhXx4cnlKH
         BO5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740732237; x=1741337037;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uCQhmEkI20WCXSrDNmwHS83kJOrfCigX2ZIIywReQD0=;
        b=OI4kZwGuiSpvmgJR3FKKiIgwOiTBp+E6539MOdIgu6MDWKMqu2K8plO/bQVkB2dyZj
         Lt/DIbvHM1axnDrV++XTNT9EOEzMADfsLjJQ3HV+RNwuVk7HgVVNF1JYrVhRmaXguMtX
         LN6xxjUqEx59BXy3+kf8VcHbNQEitp8yltT5IK7dtFtMSdk2LqLBR1zlJSTTWPzsiGI+
         QrpW3FXHeWpUKvJdmqE0/lNioJHxY+e6knx1lEu+Ki0UqCkhJBVC8wGfP0Nu9ueNTpZ3
         wxLcgOjZR7ysO9KxBHPqOzbY/xfpUdh6WK4hAD6gOtnBNq76HsTScI/ta8fotOlRNkG6
         PKsA==
X-Forwarded-Encrypted: i=1; AJvYcCUpnqZERzCQ4wSdS+V5VrGf1wGrxTkyriZy01FNk9OpxS9wcGB7iFwpcmRDxMEgXUJHppg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKiDuy3Ue2Ny+sjA5nh6CgMtadpG7tTmKpE0uqBEO1yJcAleCc
	ZMebAuh70bWgPtq5gyZhqmHweHp9UbHAHSAOHUugrjRmWrvyXNC2O35s/M0FbssX7TsSC5KyvHQ
	0k2JBI/xSRA==
X-Google-Smtp-Source: AGHT+IEJq+5yWOZHmvu9HxjEv9KlFOODJE3Hve16zw/QnOkwbeaxyl/H0lwa63WLmmVB/J+lwRxrJvVq5cm/Ag==
X-Received: from wmsd7.prod.google.com ([2002:a05:600c:3ac7:b0:439:850b:8080])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4693:b0:439:a1f2:50a3 with SMTP id 5b1f17b1804b1-43ba66dfd93mr17960705e9.4.1740732236929;
 Fri, 28 Feb 2025 00:43:56 -0800 (PST)
Date: Fri, 28 Feb 2025 08:43:55 +0000
In-Reply-To: <20250227120607.GPZ8BVL2762we1j3uE@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227120607.GPZ8BVL2762we1j3uE@fat_crate.local>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250228084355.2061899-1-jackmanb@google.com>
Subject: Re: [PATCH RFC v2 03/29] mm: asi: Introduce ASI core API
From: Brendan Jackman <jackmanb@google.com>
To: bp@alien8.de
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com, 
	jackmanb@google.com, yosryahmed@google.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, peterz@infradead.org, 
	seanjc@google.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

> > OK, sounds like I need to rewrite this explanation! It's only been

> > read before by people who already knew how this thing worked so this
> > might take a few attempts to make it clear.
> > 
> > Maybe the best way to make it clear is to explain this with reference
> > to KVM. At a super high level, That looks like:
> > 
> > ioctl(KVM_RUN) {
> >     enter_from_user_mode()
> >     while !need_userspace_handling() {
> >         asi_enter();  // part 1
> >         vmenter();  // part 2
> >         asi_relax(); // part 3
> >     }
> >     asi _exit(); // part 4b
> >     exit_to_user_mode()
> > }
> > 
> > So part 4a is just referring to continuation of the loop.
> > 
> > This explanation was written when that was the only user of this API
> > so it was probably clearer, now we have userspace it seems a bit odd.
> > 
> > With my pseudocode above, does it make more sense? If so I'll try to
> > think of a better way to explain it.
> 
> Well, it is still confusing. I would expect to see:
> 
> ioctl(KVM_RUN) {
>     enter_from_user_mode()
>     while !need_userspace_handling() {
>         asi_enter();  // part 1
>         vmenter();  // part 2
>         asi_exit(); // part 3
>     }
>     asi_switch(); // part 4b
>     exit_to_user_mode()
> }
> 
> Because then it is ballanced: you enter the restricted address space, do stuff
> and then you exit it without switching address space. But then you need to
> switch address space so you have to do asi_exit or asi_switch or wnatnot. And
> that's still unbalanced.
> 
> So from *only* looking at the usage, it'd be a lot more balanced if all calls
> were paired:
> 
> ioctl(KVM_RUN) {
>     enter_from_user_mode()
>     asi_switch_to();			<-------+
>     while !need_userspace_handling() {		|
>         asi_enter();  // part 1		<---+	|
>         vmenter();  // part 2		    |	|
>         asi_exit(); // part 3		<---+	|
>     }						|
>     asi_switch_back(); // part 4b	<-------+
>     exit_to_user_mode()
> }
> 
> (look at me doing ascii paintint :-P)
> 
> Naming is awful but it should illustrate what I mean:
> 
> 	asi_switch_to
> 	  asi_enter
> 	  asi_exit
> 	asi_switch_back
> 
> Does that make more sense?

Yeah I see what you mean. I think the issues are:

1. We're mixing up two different aspects in the API:

   a. Starting and finishing "critical sections" (i.e. the region
      between asi_enter() and asi_relax())

   b. Actually triggering address space transitions.

2. There is a fundamental asymmetry at play here: asi_enter() and
   asi_exit() can both be NOPs (when we're already in the relevant
   address space), and asi_enter() being a NOP is really the _whole
   point of ASI_.

   The ideal world is where asi_exit() is very very rare, so
   asi_enter() is almost always a NOP.

So we could disentangle part 1 by just rejigging things as you suggest,
and I think the naming would be like:

asi_enter
  asi_start_critical
  asi_end_critical
asi_exit

But the issue with that is that asi_start_critical() _must_ imply
asi_enter() (otherwise if we get an NMI between asi_enter() and
asi_start_critical(), and that causes a #PF, we will start the
critical section in the wrong address space and ASI won't do its job).
So, we are somewhat forced to mix up a. and b. from above.

BTW, there is another thing complicating this picture a little: ASI
"clients" (really just meaning KVM code at this point) are not not
really supposed to care at all about the actual address space, the fact
that they currently have to call asi_exit() in part 4b is just a
temporary thing to simplify the initial implementation. It has a
performance cost (not enormous, serious KVM platforms try pretty hard
to avoid returning to user space, but it does still matter) so
Google's internal version has already got rid of it and that's where I
expect this thing to evolve too. But for now it just lets us keep
things simple since e.g. we never have to think about context
switching in the restricted address space.

With that in mind, what if it looked like this:

ioctl(KVM_RUN) {
    enter_from_user_mode()
    while !need_userspace_handling()
	// This implies asi_enter(), but this code "doesn't care"
	// about that.
        asi_start_critical();
        vmenter();
        asi_end_critical();
    }
    // TODO: This is temporary, it should not be needed.
    asi_exit();
    exit_to_user_mode()
}

Once the asi_exit() call disappears, it will be symmetrical from the
"client API"'s point of view. And while we still mix up address space
switching with critical section boundaries, the address space
switching is "just an implementation detail" and not really visible as
part of the API.

> Documentation/process/email-clients.rst

I have now setup Mutt. But, for now I am replying with plan vim +
git-send-email, because I also sent this RFC to a ridiculous CC list
(I just blindly used the get_maintainers.pl output, I don't know why I
thought that was a reasonable approach) and it turns out this is the
easiest way to trim it in a reply! Hopefully I can get the headers
right...

