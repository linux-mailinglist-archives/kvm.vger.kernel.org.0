Return-Path: <kvm+bounces-13296-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C97FE894735
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 00:22:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F302A1C21162
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 22:22:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01DCF5644E;
	Mon,  1 Apr 2024 22:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Qp6cd8Ww"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B8D1EB37
	for <kvm@vger.kernel.org>; Mon,  1 Apr 2024 22:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712010155; cv=none; b=SvjyCaIFz0WE6uFKwZ163zH3HX9W2JIHiQZpdmYpBOxJHlJ03W0VjBzXH8VaHPYl8z2JW52EtKN6O4qjCmVFGK6Rus4g9Ov+LxyBD6I1fWsrBSrL2csoOxB16ElH4uxoFxL+fRMYtiYcZy4AeRpMmkVsOhFiB2AEdXzikscMLnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712010155; c=relaxed/simple;
	bh=KwFXh+fHkdw/eV5ECyM/OPyb/DdzRWvgPUKKXwmyW4Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ne2Dq4QQn0EygHNVos7NfDzU4GvZGdGABkREc/ZnLquzqJuzPdv/pohduh87qJfhjjK9nuYfkbeHtetXgJGguQMH4JEbhwUKXkZ6i2jwxB9B6118aRlEeTq+8tKUoM4CT6rX1t3UdC9UO0gL8/a9sgtIg9kYyao9No1kZSIkd78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Qp6cd8Ww; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-60ff1816749so67991727b3.3
        for <kvm@vger.kernel.org>; Mon, 01 Apr 2024 15:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712010152; x=1712614952; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sxgSqoF+BNZNMru1IHZMTYfOm5kS224Ezg3Ae26IMtY=;
        b=Qp6cd8WwD0ygKUuDm9PlT5pEWJGJkYDu4zzmM7eLkbCmX37jBbTcszjNnrLo3DzG/E
         yjL5y4oFEM3yDfgJ04cw4aOIeuHs8hgufmpCuY5DWZKUnPB2t+QelMamvYBcYVfUhK8O
         AwSlqIh+Kv3+KgJnY+R58NsLagF4HtWnAMypZV9BPVcbRloEmc89sGk2ldlod5vRh6uQ
         xAK9dcAk51AmSsNTRo/wwkgF7nbRCGDZIvYO1rNDNENkQCzNrn/nJ75oabiGVqHMRiXW
         Ge4Skd8kVyaITq/R8dGXlTiFOPZbVh3ZI00cGxQNtBGppEhZ6g4o3pgahfurP6qD+fQn
         Nm4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712010152; x=1712614952;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sxgSqoF+BNZNMru1IHZMTYfOm5kS224Ezg3Ae26IMtY=;
        b=OAS6LkExr7j4e1KtXjfNUZ5tIKc68VHKCtaq0QioadTkClfyI2q9IYJ8btM4obyOEi
         TEYa+Mt2IhjW2RKDHTqj/0RRJ6IKvg/cDUwgKWZH8oO751ivsYjj60zazFnkek2TL0J7
         CipLemYzobzkIzifqOdNnkXnJMVC4ONGdGJsYupHShNom7uxqsb/Y3GwH84qm7dAxIc5
         RJG5fh+ytjy2bcmm7ZJHlOhWynfvRa2u3XjcpJWXo6ry4PSKBR7Wecz4SPsavatAF8/V
         ReGWQqAQSJicgTc5ZdeVvG88t2+bSlRDHVstDkjLkyRrm9bzDcV1khQQU7WpGZOvwear
         ELvg==
X-Gm-Message-State: AOJu0YwA0Gds78Yo2EEcoeB8asWnyAs93xN3meDYqAKzDG5Worub4GsT
	UsZt77JgZ/Uymznuy0O9KnKpcc/EadwKVL/iQyDRQwjr5TXQ9oFGM1JvQCYCo7SeFf8nWwd46GH
	7NQ==
X-Google-Smtp-Source: AGHT+IHPvWNctz+fLdpUwz6etd0RoTPKnoSgFkk+CiICv1EkJIt2AqYsi9alvg6VCtoIvQ3KZEzkTOW3rwU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:230b:b0:dc6:b982:cfa2 with SMTP id
 do11-20020a056902230b00b00dc6b982cfa2mr765172ybb.8.1712010152688; Mon, 01 Apr
 2024 15:22:32 -0700 (PDT)
Date: Mon, 1 Apr 2024 15:22:31 -0700
In-Reply-To: <acb3fe5acbfe3e126fba5ce16b708e0ea1a9adc9.camel@cyberus-technology.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <acb3fe5acbfe3e126fba5ce16b708e0ea1a9adc9.camel@cyberus-technology.de>
Message-ID: <Zgszp5wvxGtu2YHS@google.com>
Subject: Re: Timer Signals vs KVM
From: Sean Christopherson <seanjc@google.com>
To: Julian Stecklina <julian.stecklina@cyberus-technology.de>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	Thomas Prescher <thomas.prescher@cyberus-technology.de>
Content-Type: text/plain; charset="us-ascii"

On Wed, Mar 27, 2024, Julian Stecklina wrote:
> Hey everyone,
> 
> we are developing the KVM backend for VirtualBox [0] and wanted to reach out
> regarding some weird behavior.
> 
> We are using `timer_create` to deliver timer events to vCPU threads as signals.
> We mask the signal using pthread_sigmask in the host vCPU thread and unmask them
> for guest execution using KVM_SET_SIGNAL_MASK.

What exactly do you mean by "timer events"?  From the split-lock blog post, it
does NOT seem like you're emulating guest timer events.  Specifically, this

  Consider that we want to run a KVM vCPU on Linux, but we want it to
  unconditionally exit after 1ms regardless of what the guest does.

sounds like you're doing vCPU scheduling in userspace.  But the above

  as opposed to using a separate thread that handles timers

doesn't really mesh with that.

> This method of handling timers works well and gives us very low latency as
> opposed to using a separate thread that handles timers. As far as we can tell,
> neither Qemu nor other VMMs use such a setup. We see two issues:
> 
> When we enable nested virtualization, we see what looks like corruption in the
> nested guest. The guest trips over exceptions that shouldn't be there. We are
> currently debugging this to find out details, but the setup is pretty painful
> and it will take a bit. If we disable the timer signals, this issue goes away
> (at the cost of broken VBox timers obviously...).  This is weird and has left us
> wondering, whether there might be something broken with signals in this
> scenario, especially since none of the other VMMs uses this method.

It's certainly possible there's a kernel bug, but it's probably more likely a
problem in your userspace.  QEMU (and others VMMs) do use signals to interrupt
vCPUs, e.g. to take control for live migration.  That's obviously different than
what you're doing, and will have orders of magnitude lower volume of signals in
nested guests, but the effective coverage isn't "zero".

> The other issue is that we have a somewhat sad interaction with split-lock

LOL, I think the "sad" part is redundant.  I've yet to have any iteraction with
split-lock detection that wasn't sad. :-)

> detection, which I've blogged about some time ago [1]. Long story short: When
> you program timers <10ms into the future, you run the risk of making no progress
> anymore when the guest triggers the split-lock punishment [2]. See the blog post
> for details. I was wondering whether there is a better solution here than
> disabling the split-lock detection or whether our approach here is fundamentally
> broken.

I'm pretty sure disabling split-lock is just whacking one mole, there will be many
more lurking.  AIUI, timer_create() provides a per process timer, i.e. a timer
which counts even if a task (i.e. a vCPU) is scheduled out.  The split-lock issue
is the most blatant problem because it's (a) 100% deterministic and (b) tied to
guest code.  But any other paths that might_sleep() are going to be problematic,
albeit far less likely to completely block forward progress.

I don't really see a sane way around that, short of actually having a userspace
component that knows how long a task/vCPU has actually run.

